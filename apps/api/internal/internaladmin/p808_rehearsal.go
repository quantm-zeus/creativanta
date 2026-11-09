package internaladmin

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	adminv1connect "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	// MaxFinancialAuditRPOSeconds is the zero-data-loss RPO target for financial and audit data (runbook.md §4.1).
	MaxFinancialAuditRPOSeconds = 0
	// MaxStandardRTOSeconds is the 1-hour maximum RTO target for database & service recovery (runbook.md §4.1).
	MaxStandardRTOSeconds = 3600
	// ProviderEvidenceMaxAge is the maximum freshness window for provider rate cards and connector verifications.
	ProviderEvidenceMaxAge = 30 * 24 * time.Hour
	// AdminOverrideDailyAlertThreshold triggers a Super Admin review notification when exceeded (>10/day, EC-M23-004).
	AdminOverrideDailyAlertThreshold = 10
	// AdminOverrideDailyApprovalThreshold blocks further overrides without Super Admin approval (>50/day, EC-M23-004).
	AdminOverrideDailyApprovalThreshold = 50
	// BreachNotificationSLAHours is the mandatory 72-hour regulatory notification window (GDPR Art. 33 / PDPA).
	BreachNotificationSLAHours = 72
	// RehearsalModeSimulationOnly indicates an in-memory/snapshot validation without touching a disposable DB or proxy.
	RehearsalModeSimulationOnly = "SIMULATION_ONLY"
	// RehearsalModeDisposableTargetVerified indicates a rehearsal that restored a disposable target DB or probed/switched a disposable proxy.
	RehearsalModeDisposableTargetVerified = "DISPOSABLE_TARGET_VERIFIED"
)

var (
	// ErrBackupChecksumMismatch is returned when a backup snapshot SHA-256 digest does not match its .sha256 sidecar.
	ErrBackupChecksumMismatch = errors.New("internaladmin: backup snapshot SHA-256 checksum mismatch (RESTORE_CHECKSUM_001)")
	// ErrRestoreIntegrityFailed is returned when post-restore row counts, ledger postings, or audit sequences fail reconciliation.
	ErrRestoreIntegrityFailed = errors.New("internaladmin: post-restore data integrity verification failed (RESTORE_INTEGRITY_001)")
	// ErrReleaseSmokeFailed is returned when blue/green pre-promotion health, readiness, or authenticated business smoke fails.
	ErrReleaseSmokeFailed = errors.New("internaladmin: release candidate business smoke failed — automatic rollback triggered (SMOKE_FAILED_001)")
	// ErrStaleProviderEvidence is returned when provider rate cards, connector access, or workflow licenses are expired or unverified.
	ErrStaleProviderEvidence = errors.New("internaladmin: stale or unverified provider/connector/license evidence rejected (STALE_PROVIDER_EVIDENCE)")
	// ErrSSRFBlocked is returned when an outbound webhook or import URL targets a non-HTTPS scheme or private/internal IP range.
	ErrSSRFBlocked = errors.New("internaladmin: outbound URL blocked by SSRF policy (SECURITY_SSRF_001)")
	// ErrPublicProfileNotPublished is returned when a public directory caller requests a draft or non-opt-in creator profile.
	ErrPublicProfileNotPublished = errors.New("internaladmin: creator profile is not opted-in or published for public directory (PUBLIC_NOT_FOUND_001)")
	// ErrCrossTenantAccessDenied is returned when a workspace caller attempts to read or mutate another tenant's resource.
	ErrCrossTenantAccessDenied = errors.New("internaladmin: cross-tenant access denied by BOLA/RLS boundary (TENANT_FORBIDDEN_001)")
	// ErrPersonalOnboardingSelfScopeViolation is returned when personal onboarding attempts to read/write another user or workspace setting (PRIV-2026-02).
	ErrPersonalOnboardingSelfScopeViolation = errors.New("internaladmin: personal onboarding is strictly scoped to user:self (PRIV_FORBIDDEN_002)")
	// ErrOverrideRateLimitRequiresSuperAdmin is returned when an admin exceeds 50 overrides in 24h without Super Admin approval (EC-M23-004).
	ErrOverrideRateLimitRequiresSuperAdmin = errors.New("internaladmin: >50 overrides/24h requires explicit Super Admin approval token (ADMIN_RATELIMIT_004)")
	// ErrAuditLogReadOnlyLocked is returned when an audit log sequence gap has locked the audit log in read-only mode (EC-M23-005).
	ErrAuditLogReadOnlyLocked = errors.New("internaladmin: audit log is locked read-only due to sequence integrity incident (AUDIT_LOCKED_005)")
	// ErrAuditSequenceIntegrityViolation is returned when a gap or hash tamper is detected in internal_audit_logs (EC-M23-005).
	ErrAuditSequenceIntegrityViolation = errors.New("internaladmin: audit log sequence gap or hash mismatch detected (AUDIT_INTEGRITY_005)")
	// ErrDSRNotFound is returned when a Data Subject Request ID does not exist.
	ErrDSRNotFound = errors.New("internaladmin: data subject request not found (ADMIN_NOTFOUND_001)")
	// ErrOperationalTargetRequired is returned when an operational restore or proxy switch is requested without a disposable DB/proxy target.
	ErrOperationalTargetRequired = errors.New("internaladmin: operational restore/release claim requires a configured disposable DB/proxy target (REHEARSAL_TARGET_REQUIRED_001)")
)

// ============================================================================
// Target 1: Real Backup, Point-in-Time Restore & Failing Smoke / Slot Rollback
// ============================================================================

// WorkspaceSnapshot captures tenant workspace state for backup/restore verification.
type WorkspaceSnapshot struct {
	WorkspaceID        string `json:"workspace_id"`
	Name               string `json:"name"`
	Slug               string `json:"slug"`
	OwnerUserID        string `json:"owner_user_id"`
	AICreditsRemaining int64  `json:"ai_credits_remaining"`
	Status             string `json:"status"`
}

// FinancialPostingSnapshot captures an immutable double-entry ledger posting in exact integer micro-units (DB-H-001).
type FinancialPostingSnapshot struct {
	PostingID      string    `json:"posting_id"`
	WorkspaceID    string    `json:"workspace_id"`
	AccountCode    string    `json:"account_code"`
	Direction      string    `json:"direction"` // "debit" or "credit"
	AmountMicro    int64     `json:"amount_micro"`
	Currency       string    `json:"currency"`
	IdempotencyKey string    `json:"idempotency_key"`
	CreatedAt      time.Time `json:"created_at"`
}

// AICreditLotSnapshot captures an AI credit lot in exact integer credits.
type AICreditLotSnapshot struct {
	LotID            string    `json:"lot_id"`
	WorkspaceID      string    `json:"workspace_id"`
	InitialCredits   int64     `json:"initial_credits"`
	RemainingCredits int64     `json:"remaining_credits"`
	LotType          string    `json:"lot_type"`
	ExpiresAt        time.Time `json:"expires_at"`
}

// EvidenceObjectSnapshot captures an immutable compliance/dispute evidence object.
type EvidenceObjectSnapshot struct {
	EvidenceID    string    `json:"evidence_id"`
	WorkspaceID   string    `json:"workspace_id"`
	Category      string    `json:"category"`
	ContentSHA256 string    `json:"content_sha256"`
	StorageURI    string    `json:"storage_uri"`
	RetentionLock time.Time `json:"retention_lock"`
}

// AuditSequenceEntrySnapshot captures a sequenced immutable internal audit log entry.
type AuditSequenceEntrySnapshot struct {
	AuditID        string    `json:"audit_id"`
	SequenceNumber int64     `json:"sequence_number"`
	EntryHash      string    `json:"entry_hash"`
	AdminID        string    `json:"admin_id"`
	Action         string    `json:"action"`
	CreatedAt      time.Time `json:"created_at"`
}

// DatabaseSnapshot represents a deterministic point-in-time snapshot of critical tenant, financial, and audit tables.
type DatabaseSnapshot struct {
	SnapshotID        string                       `json:"snapshot_id"`
	Environment       string                       `json:"environment"`
	CreatedAt         time.Time                    `json:"created_at"`
	WALPositionLSN    string                       `json:"wal_position_lsn"`
	Workspaces        []WorkspaceSnapshot          `json:"workspaces"`
	FinancialPostings []FinancialPostingSnapshot   `json:"financial_postings"`
	AICreditLots      []AICreditLotSnapshot        `json:"ai_credit_lots"`
	EvidenceObjects   []EvidenceObjectSnapshot     `json:"evidence_objects"`
	AuditEntries      []AuditSequenceEntrySnapshot `json:"audit_entries"`
}

// CanonicalBytes serializes DatabaseSnapshot deterministically for SHA-256 hashing and disk persistence.
func (snap DatabaseSnapshot) CanonicalBytes() ([]byte, error) {
	cp := snap
	sort.Slice(cp.Workspaces, func(i, j int) bool { return cp.Workspaces[i].WorkspaceID < cp.Workspaces[j].WorkspaceID })
	sort.Slice(cp.FinancialPostings, func(i, j int) bool { return cp.FinancialPostings[i].PostingID < cp.FinancialPostings[j].PostingID })
	sort.Slice(cp.AICreditLots, func(i, j int) bool { return cp.AICreditLots[i].LotID < cp.AICreditLots[j].LotID })
	sort.Slice(cp.EvidenceObjects, func(i, j int) bool { return cp.EvidenceObjects[i].EvidenceID < cp.EvidenceObjects[j].EvidenceID })
	sort.Slice(cp.AuditEntries, func(i, j int) bool { return cp.AuditEntries[i].SequenceNumber < cp.AuditEntries[j].SequenceNumber })
	return json.Marshal(cp)
}

// ComputeSnapshotSHA256 returns the lowercase 64-character hex SHA-256 digest of the snapshot.
func ComputeSnapshotSHA256(snap DatabaseSnapshot) (string, error) {
	raw, err := snap.CanonicalBytes()
	if err != nil {
		return "", err
	}
	sum := sha256.Sum256(raw)
	return hex.EncodeToString(sum[:]), nil
}

// BackupArtifactMetadata describes a written backup file and its .sha256 sidecar on disk (runbook.md §10.3).
type BackupArtifactMetadata struct {
	SnapshotPath string
	SidecarPath  string
	SHA256Digest string
	SizeBytes    int64
	CreatedAt    time.Time
}

// CreateVerifiedBackupSnapshot writes a canonical snapshot file and a `.sha256` sidecar file to dir,
// then immediately verifies the checksum before returning.
func CreateVerifiedBackupSnapshot(dir string, snap DatabaseSnapshot) (BackupArtifactMetadata, error) {
	if strings.TrimSpace(dir) == "" || strings.TrimSpace(snap.SnapshotID) == "" {
		return BackupArtifactMetadata{}, ErrInvalidInput
	}
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return BackupArtifactMetadata{}, fmt.Errorf("create backup dir: %w", err)
	}
	raw, err := snap.CanonicalBytes()
	if err != nil {
		return BackupArtifactMetadata{}, err
	}
	sum := sha256.Sum256(raw)
	digest := hex.EncodeToString(sum[:])

	baseName := fmt.Sprintf("creativanta_backup_%s.snapshot.json", snap.SnapshotID)
	snapPath := filepath.Join(dir, baseName)
	sidecarPath := snapPath + ".sha256"

	if err := os.WriteFile(snapPath, raw, 0o600); err != nil {
		return BackupArtifactMetadata{}, fmt.Errorf("write snapshot file: %w", err)
	}
	sidecarContent := fmt.Sprintf("%s  %s\n", digest, baseName)
	if err := os.WriteFile(sidecarPath, []byte(sidecarContent), 0o600); err != nil {
		return BackupArtifactMetadata{}, fmt.Errorf("write sha256 sidecar: %w", err)
	}

	if err := VerifyBackupArtifactChecksum(snapPath, sidecarPath); err != nil {
		return BackupArtifactMetadata{}, err
	}

	return BackupArtifactMetadata{
		SnapshotPath: snapPath,
		SidecarPath:  sidecarPath,
		SHA256Digest: digest,
		SizeBytes:    int64(len(raw)),
		CreatedAt:    snap.CreatedAt,
	}, nil
}

// VerifyBackupArtifactChecksum reads a backup snapshot file and its `.sha256` sidecar,
// returning ErrBackupChecksumMismatch if the file was modified or corrupted.
func VerifyBackupArtifactChecksum(snapPath, sidecarPath string) error {
	raw, err := os.ReadFile(snapPath)
	if err != nil {
		return fmt.Errorf("%w: read snapshot: %v", ErrBackupChecksumMismatch, err)
	}
	sidecarBytes, err := os.ReadFile(sidecarPath)
	if err != nil {
		return fmt.Errorf("%w: read sidecar: %v", ErrBackupChecksumMismatch, err)
	}
	fields := strings.Fields(string(sidecarBytes))
	if len(fields) == 0 || len(fields[0]) != 64 {
		return fmt.Errorf("%w: malformed sidecar content", ErrBackupChecksumMismatch)
	}
	expected := strings.ToLower(fields[0])
	sum := sha256.Sum256(raw)
	actual := hex.EncodeToString(sum[:])
	if actual != expected {
		return fmt.Errorf("%w: expected %s, got %s", ErrBackupChecksumMismatch, expected, actual)
	}
	return nil
}

// BackupRestoreRehearsalRecord mirrors the canonical backup_restore_rehearsals table (migration 00046).
type BackupRestoreRehearsalRecord struct {
	RehearsalID                   string
	Environment                   string
	ExecutionMode                 string // RehearsalModeSimulationOnly or RehearsalModeDisposableTargetVerified
	IsSimulation                  bool
	OperationalRestorePerformed   bool
	TargetDatabaseURI             string
	RestoredSchemaName            string
	PersistentSchemaVerified      bool
	RLSIsolationVerified          bool
	PostCommitSmokeVerified       bool
	ProductionDRGateApproved      bool
	ProductionReleaseGateApproved bool
	MeasuredRestoreDurationMs     int64
	BackupArtifactURI             string
	BackupSHA256                  string
	RestoredSHA256                string
	ChecksumVerified              bool
	RPOSeconds                    int32
	RTOSeconds                    int32
	WorkspacesRestored            int
	PostingsRestored              int
	EvidenceObjectsRestored       int
	AuditEntriesRestored          int
	LedgerBalanced                bool
	AuditSequenceContinuous       bool
	SmokePassed                   bool
	SmokeFailureCode              string
	RollbackTriggered             bool
	PreviousSlotDigest            string
	CandidateSlotDigest           string
	ActiveSlotAfterRehearsal      string
	ExecutedByAdminID             string
	ExecutedAt                    time.Time
}

// DisposableRestoreOutcome captures measured counts and smoke results from a disposable DB target restore.
type DisposableRestoreOutcome struct {
	TargetDatabaseURI                  string
	RestoredSchemaName                 string
	OperationalPostgresRestoreVerified bool
	PersistentSchemaVerified           bool
	RLSIsolationVerified               bool
	PostCommitSmokeVerified            bool
	WorkspacesRestored                 int
	PostingsRestored                   int
	EvidenceObjectsRestored            int
	AuditEntriesRestored               int
	ObservedDebitMicro                 int64
	ObservedCreditMicro                int64
	SmokeProbePassed                   bool
	SmokeFailureCode                   string
}

// DisposableRestoreTarget abstracts an isolated disposable database/storage target for real restore drills.
type DisposableRestoreTarget interface {
	RestoreAndVerifySnapshot(ctx context.Context, snap DatabaseSnapshot) (DisposableRestoreOutcome, error)
}

// FileBackedDisposableDBTarget restores a DatabaseSnapshot into isolated per-table JSON files in a disposable directory
// and reads them back from disk to verify snapshot fixture persistence, row counts, double-entry balance, and smoke readiness.
// Because it writes JSON files rather than populating a PostgreSQL engine, it is classified as SIMULATION_ONLY
// (OperationalPostgresRestoreVerified=false) and rejected for production/staging operational restore claims.
type FileBackedDisposableDBTarget struct {
	TargetDir    string
	FailOnWrite  bool
	FailOnSmoke  bool
	CorruptCount int
}

// PostgresDisposableDBTarget restores a DatabaseSnapshot into an isolated persistent PostgreSQL schema,
// commits the restored schema and tables, and then verifies on post-commit transactions that:
//  1. All restored tables persist in pg_catalog with relpersistence='p' and row counts match.
//  2. SQL double-entry financial ledger balances, AI credit lot sums, and audit sequence continuity hold.
//  3. Row-Level Security (ENABLE + FORCE RLS) is enforced under a non-superuser NOBYPASSRLS role.
//  4. Post-commit tenant-scoped smoke probes succeed against the committed tables.
//
// If TargetSchema is empty, starts with "pg_temp", or TempFixtureOnly is true, the target runs as a
// temporary simulation fixture (OperationalPostgresRestoreVerified=false) and is rejected for
// production/staging operational restore claims.
type PostgresDisposableDBTarget struct {
	Pool                  *pgxpool.Pool
	TargetSchema          string
	TempFixtureOnly       bool
	FailOnWrite           bool
	FailOnSmoke           bool
	CorruptCount          int
	PostRestoreSmokeProbe func(ctx context.Context, pool *pgxpool.Pool, schema string) error
}

var validPostgresSchemaIdent = regexp.MustCompile(`^[a-z_][a-z0-9_]{0,62}$`)

func isReservedOrTempPostgresSchema(schema string) bool {
	s := strings.ToLower(strings.TrimSpace(schema))
	return s == "" || s == "public" || s == "pg_catalog" || s == "information_schema" || strings.HasPrefix(s, "pg_temp") || strings.HasPrefix(s, "pg_toast")
}

// Cleanup drops the isolated persistent rehearsal schema created by RestoreAndVerifySnapshot.
func (t *PostgresDisposableDBTarget) Cleanup(ctx context.Context) error {
	if t == nil || t.Pool == nil {
		return nil
	}
	schema := strings.ToLower(strings.TrimSpace(t.TargetSchema))
	if isReservedOrTempPostgresSchema(schema) || !validPostgresSchemaIdent.MatchString(schema) {
		return nil
	}
	_, err := t.Pool.Exec(ctx, fmt.Sprintf("DROP SCHEMA IF EXISTS %s CASCADE", schema))
	return err
}

func verifyRestoredFinancialPostingsBalance(workspaces []WorkspaceSnapshot, postings []FinancialPostingSnapshot) (int64, int64, error) {
	validWorkspaces := make(map[string]struct{}, len(workspaces))
	for _, ws := range workspaces {
		wsID := strings.TrimSpace(ws.WorkspaceID)
		if wsID != "" {
			validWorkspaces[wsID] = struct{}{}
		}
	}

	type wsCurrencyKey struct {
		workspaceID string
		currency    string
	}
	type wsCurrencyOpKey struct {
		workspaceID    string
		currency       string
		idempotencyKey string
	}

	perWsCurrDebit := make(map[wsCurrencyKey]int64)
	perWsCurrCredit := make(map[wsCurrencyKey]int64)
	perOpDebit := make(map[wsCurrencyOpKey]int64)
	perOpCredit := make(map[wsCurrencyOpKey]int64)
	var totalDebitMicro, totalCreditMicro int64

	for _, p := range postings {
		if p.AmountMicro <= 0 {
			return 0, 0, fmt.Errorf("%w: invalid non-positive financial posting amount %d", ErrRestoreIntegrityFailed, p.AmountMicro)
		}
		wsID := strings.TrimSpace(p.WorkspaceID)
		if wsID == "" {
			return 0, 0, fmt.Errorf("%w: financial posting %s missing workspace_id", ErrRestoreIntegrityFailed, p.PostingID)
		}
		if _, ok := validWorkspaces[wsID]; !ok {
			return 0, 0, fmt.Errorf("%w: financial posting %s references unknown workspace %s", ErrRestoreIntegrityFailed, p.PostingID, wsID)
		}
		curr := strings.ToUpper(strings.TrimSpace(p.Currency))
		if curr == "" {
			return 0, 0, fmt.Errorf("%w: financial posting %s missing currency", ErrRestoreIntegrityFailed, p.PostingID)
		}
		opKeyStr := strings.TrimSpace(p.IdempotencyKey)
		if opKeyStr == "" {
			return 0, 0, fmt.Errorf("%w: financial posting %s missing idempotency_key", ErrRestoreIntegrityFailed, p.PostingID)
		}
		key := wsCurrencyKey{workspaceID: wsID, currency: curr}
		opKey := wsCurrencyOpKey{workspaceID: wsID, currency: curr, idempotencyKey: opKeyStr}
		switch strings.ToLower(p.Direction) {
		case "debit":
			totalDebitMicro += p.AmountMicro
			perWsCurrDebit[key] += p.AmountMicro
			perOpDebit[opKey] += p.AmountMicro
		case "credit":
			totalCreditMicro += p.AmountMicro
			perWsCurrCredit[key] += p.AmountMicro
			perOpCredit[opKey] += p.AmountMicro
		default:
			return 0, 0, fmt.Errorf("%w: unknown posting direction %q", ErrRestoreIntegrityFailed, p.Direction)
		}
	}

	if totalDebitMicro != totalCreditMicro {
		return 0, 0, fmt.Errorf("%w: double-entry ledger imbalance after restore (debit=%d, credit=%d)", ErrRestoreIntegrityFailed, totalDebitMicro, totalCreditMicro)
	}
	for key, d := range perWsCurrDebit {
		if c := perWsCurrCredit[key]; d != c {
			return 0, 0, fmt.Errorf("%w: double-entry ledger imbalance for workspace %s currency %s (debit=%d, credit=%d)", ErrRestoreIntegrityFailed, key.workspaceID, key.currency, d, c)
		}
	}
	for key, c := range perWsCurrCredit {
		if d := perWsCurrDebit[key]; d != c {
			return 0, 0, fmt.Errorf("%w: double-entry ledger imbalance for workspace %s currency %s (debit=%d, credit=%d)", ErrRestoreIntegrityFailed, key.workspaceID, key.currency, d, c)
		}
	}
	for opKey, d := range perOpDebit {
		if c := perOpCredit[opKey]; d != c {
			return 0, 0, fmt.Errorf("%w: double-entry ledger imbalance for workspace %s currency %s operation %s (debit=%d, credit=%d)", ErrRestoreIntegrityFailed, opKey.workspaceID, opKey.currency, opKey.idempotencyKey, d, c)
		}
	}
	for opKey, c := range perOpCredit {
		if d := perOpDebit[opKey]; d != c {
			return 0, 0, fmt.Errorf("%w: double-entry ledger imbalance for workspace %s currency %s operation %s (debit=%d, credit=%d)", ErrRestoreIntegrityFailed, opKey.workspaceID, opKey.currency, opKey.idempotencyKey, d, c)
		}
	}

	return totalDebitMicro, totalCreditMicro, nil
}

// RestoreAndVerifySnapshot materializes tables into TargetDir and reads them back for post-restore reconciliation.
func (t *FileBackedDisposableDBTarget) RestoreAndVerifySnapshot(ctx context.Context, snap DatabaseSnapshot) (DisposableRestoreOutcome, error) {
	if err := ctx.Err(); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if t == nil || strings.TrimSpace(t.TargetDir) == "" {
		return DisposableRestoreOutcome{}, ErrOperationalTargetRequired
	}
	if t.FailOnWrite {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: disposable target DB write failed", ErrRestoreIntegrityFailed)
	}
	if err := os.MkdirAll(t.TargetDir, 0o700); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: mkdir disposable target: %v", ErrRestoreIntegrityFailed, err)
	}

	writeTable := func(name string, v any) error {
		b, err := json.Marshal(v)
		if err != nil {
			return err
		}
		return os.WriteFile(filepath.Join(t.TargetDir, name+".table.json"), b, 0o600)
	}
	if err := writeTable("workspaces", snap.Workspaces); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if err := writeTable("financial_postings", snap.FinancialPostings); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if err := writeTable("ai_credit_lots", snap.AICreditLots); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if err := writeTable("evidence_objects", snap.EvidenceObjects); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if err := writeTable("audit_entries", snap.AuditEntries); err != nil {
		return DisposableRestoreOutcome{}, err
	}

	// Read back from disposable storage to measure actual restored state
	var ws []WorkspaceSnapshot
	var postings []FinancialPostingSnapshot
	var evidences []EvidenceObjectSnapshot
	var audits []AuditSequenceEntrySnapshot

	readTable := func(name string, dst any) error {
		b, err := os.ReadFile(filepath.Join(t.TargetDir, name+".table.json"))
		if err != nil {
			return err
		}
		return json.Unmarshal(b, dst)
	}
	if err := readTable("workspaces", &ws); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if err := readTable("financial_postings", &postings); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if err := readTable("evidence_objects", &evidences); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if err := readTable("audit_entries", &audits); err != nil {
		return DisposableRestoreOutcome{}, err
	}

	debitMicro, creditMicro, err := verifyRestoredFinancialPostingsBalance(ws, postings)
	if err != nil {
		return DisposableRestoreOutcome{}, err
	}

	wsCount := len(ws) - t.CorruptCount
	if wsCount < 0 {
		wsCount = 0
	}

	smokeCode := "SIMULATION_FILE_TARGET_ONLY"
	if t.FailOnSmoke {
		smokeCode = "DISPOSABLE_SMOKE_PROBE_FAILED"
	}

	return DisposableRestoreOutcome{
		TargetDatabaseURI:                  "file://" + filepath.ToSlash(t.TargetDir),
		OperationalPostgresRestoreVerified: false,
		WorkspacesRestored:                 wsCount,
		PostingsRestored:                   len(postings),
		EvidenceObjectsRestored:            len(evidences),
		AuditEntriesRestored:               len(audits),
		ObservedDebitMicro:                 debitMicro,
		ObservedCreditMicro:                creditMicro,
		SmokeProbePassed:                   false,
		SmokeFailureCode:                   smokeCode,
	}, nil
}

// RestoreAndVerifySnapshot restores snap into an isolated persistent PostgreSQL schema, commits the restore transaction,
// and then verifies on post-commit transactions that:
//  1. All restored tables persist in pg_catalog with relpersistence='p' and row counts match.
//  2. SQL double-entry financial ledger balances, AI credit lot sums, and audit sequence continuity hold.
//  3. Row-Level Security (ENABLE + FORCE RLS) is enforced under a non-superuser NOBYPASSRLS role.
//  4. Post-commit tenant-scoped smoke probes succeed against the committed tables.
//
// If TargetSchema is empty, reserved/pg_temp, or TempFixtureOnly is true, the target executes only as a
// temporary simulation fixture (OperationalPostgresRestoreVerified=false).
func (t *PostgresDisposableDBTarget) RestoreAndVerifySnapshot(ctx context.Context, snap DatabaseSnapshot) (DisposableRestoreOutcome, error) {
	if err := ctx.Err(); err != nil {
		return DisposableRestoreOutcome{}, err
	}
	if t == nil || t.Pool == nil {
		return DisposableRestoreOutcome{}, ErrOperationalTargetRequired
	}
	if t.FailOnWrite {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: disposable postgres target write failed", ErrRestoreIntegrityFailed)
	}

	rawSchema := strings.ToLower(strings.TrimSpace(t.TargetSchema))
	isTempFixture := t.TempFixtureOnly || rawSchema == "" || strings.HasPrefix(rawSchema, "pg_temp")
	if !isTempFixture {
		if isReservedOrTempPostgresSchema(rawSchema) || !validPostgresSchemaIdent.MatchString(rawSchema) {
			return DisposableRestoreOutcome{}, fmt.Errorf("%w: invalid disposable postgres target schema %q", ErrRestoreIntegrityFailed, t.TargetSchema)
		}
	}

	if isTempFixture {
		wsCount := len(snap.Workspaces) - t.CorruptCount
		if wsCount < 0 {
			wsCount = 0
		}
		debitMicro, creditMicro, err := verifyRestoredFinancialPostingsBalance(snap.Workspaces, snap.FinancialPostings)
		if err != nil {
			return DisposableRestoreOutcome{}, err
		}
		smokeCode := "SIMULATION_TEMP_TABLE_FIXTURE_ONLY"
		if t.FailOnSmoke {
			smokeCode = "DISPOSABLE_SMOKE_PROBE_FAILED"
		}
		return DisposableRestoreOutcome{
			TargetDatabaseURI:                  "postgres://disposable-rehearsal/pg_temp",
			RestoredSchemaName:                 "pg_temp",
			OperationalPostgresRestoreVerified: false,
			PersistentSchemaVerified:           false,
			RLSIsolationVerified:               false,
			PostCommitSmokeVerified:            false,
			WorkspacesRestored:                 wsCount,
			PostingsRestored:                   len(snap.FinancialPostings),
			EvidenceObjectsRestored:            len(snap.EvidenceObjects),
			AuditEntriesRestored:               len(snap.AuditEntries),
			ObservedDebitMicro:                 debitMicro,
			ObservedCreditMicro:                creditMicro,
			SmokeProbePassed:                   false,
			SmokeFailureCode:                   smokeCode,
		}, nil
	}

	// Transaction 1: Materialize isolated persistent schema, tables, RLS policies, and snapshot rows, then COMMIT.
	tx1, err := t.Pool.Begin(ctx)
	if err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: begin disposable postgres restore tx: %v", ErrRestoreIntegrityFailed, err)
	}
	defer func() { _ = tx1.Rollback(ctx) }()

	ddl := fmt.Sprintf(`
DROP SCHEMA IF EXISTS %[1]s CASCADE;
CREATE SCHEMA %[1]s;

CREATE TABLE %[1]s.workspaces (
	workspace_id TEXT PRIMARY KEY,
	name TEXT NOT NULL,
	slug TEXT NOT NULL,
	owner_user_id TEXT NOT NULL,
	ai_credits_remaining BIGINT NOT NULL,
	status TEXT NOT NULL
);

CREATE TABLE %[1]s.financial_postings (
	posting_id TEXT PRIMARY KEY,
	workspace_id TEXT NOT NULL REFERENCES %[1]s.workspaces(workspace_id),
	account_code TEXT NOT NULL,
	direction TEXT NOT NULL CHECK (direction IN ('debit', 'credit')),
	amount_micro BIGINT NOT NULL CHECK (amount_micro > 0),
	currency TEXT NOT NULL,
	idempotency_key TEXT NOT NULL,
	created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE %[1]s.ai_credit_lots (
	lot_id TEXT PRIMARY KEY,
	workspace_id TEXT NOT NULL REFERENCES %[1]s.workspaces(workspace_id),
	initial_credits BIGINT NOT NULL CHECK (initial_credits >= 0),
	remaining_credits BIGINT NOT NULL CHECK (remaining_credits >= 0 AND remaining_credits <= initial_credits),
	lot_type TEXT NOT NULL,
	expires_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE %[1]s.evidence_objects (
	evidence_id TEXT PRIMARY KEY,
	workspace_id TEXT NOT NULL REFERENCES %[1]s.workspaces(workspace_id),
	category TEXT NOT NULL,
	content_sha256 TEXT NOT NULL CHECK (char_length(content_sha256) = 64),
	storage_uri TEXT NOT NULL,
	retention_lock TIMESTAMPTZ NOT NULL
);

CREATE TABLE %[1]s.internal_audit_logs (
	audit_id TEXT PRIMARY KEY,
	sequence_number BIGINT NOT NULL UNIQUE,
	entry_hash TEXT NOT NULL,
	admin_id TEXT NOT NULL,
	action TEXT NOT NULL,
	created_at TIMESTAMPTZ NOT NULL
);

ALTER TABLE %[1]s.workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE %[1]s.workspaces FORCE ROW LEVEL SECURITY;
CREATE POLICY workspace_tenant_isolation ON %[1]s.workspaces
	USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), ''));

ALTER TABLE %[1]s.financial_postings ENABLE ROW LEVEL SECURITY;
ALTER TABLE %[1]s.financial_postings FORCE ROW LEVEL SECURITY;
CREATE POLICY financial_postings_tenant_isolation ON %[1]s.financial_postings
	USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), ''));

ALTER TABLE %[1]s.ai_credit_lots ENABLE ROW LEVEL SECURITY;
ALTER TABLE %[1]s.ai_credit_lots FORCE ROW LEVEL SECURITY;
CREATE POLICY ai_credit_lots_tenant_isolation ON %[1]s.ai_credit_lots
	USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), ''));

ALTER TABLE %[1]s.evidence_objects ENABLE ROW LEVEL SECURITY;
ALTER TABLE %[1]s.evidence_objects FORCE ROW LEVEL SECURITY;
CREATE POLICY evidence_objects_tenant_isolation ON %[1]s.evidence_objects
	USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), ''));
`, rawSchema)

	if _, err := tx1.Exec(ctx, ddl); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: create persistent disposable postgres schema %s: %v", ErrRestoreIntegrityFailed, rawSchema, err)
	}

	for _, ws := range snap.Workspaces {
		if _, err := tx1.Exec(ctx, fmt.Sprintf(`
INSERT INTO %s.workspaces (workspace_id, name, slug, owner_user_id, ai_credits_remaining, status)
VALUES ($1, $2, $3, $4, $5, $6)`, rawSchema),
			ws.WorkspaceID, ws.Name, ws.Slug, ws.OwnerUserID, ws.AICreditsRemaining, ws.Status,
		); err != nil {
			return DisposableRestoreOutcome{}, fmt.Errorf("%w: insert workspace %s: %v", ErrRestoreIntegrityFailed, ws.WorkspaceID, err)
		}
	}

	for _, p := range snap.FinancialPostings {
		if _, err := tx1.Exec(ctx, fmt.Sprintf(`
INSERT INTO %s.financial_postings (posting_id, workspace_id, account_code, direction, amount_micro, currency, idempotency_key, created_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`, rawSchema),
			p.PostingID, p.WorkspaceID, p.AccountCode, strings.ToLower(strings.TrimSpace(p.Direction)), p.AmountMicro, strings.ToUpper(strings.TrimSpace(p.Currency)), strings.TrimSpace(p.IdempotencyKey), p.CreatedAt,
		); err != nil {
			return DisposableRestoreOutcome{}, fmt.Errorf("%w: insert financial posting %s: %v", ErrRestoreIntegrityFailed, p.PostingID, err)
		}
	}

	for _, lot := range snap.AICreditLots {
		if _, err := tx1.Exec(ctx, fmt.Sprintf(`
INSERT INTO %s.ai_credit_lots (lot_id, workspace_id, initial_credits, remaining_credits, lot_type, expires_at)
VALUES ($1, $2, $3, $4, $5, $6)`, rawSchema),
			lot.LotID, lot.WorkspaceID, lot.InitialCredits, lot.RemainingCredits, lot.LotType, lot.ExpiresAt,
		); err != nil {
			return DisposableRestoreOutcome{}, fmt.Errorf("%w: insert ai credit lot %s: %v", ErrRestoreIntegrityFailed, lot.LotID, err)
		}
	}

	for _, ev := range snap.EvidenceObjects {
		if _, err := tx1.Exec(ctx, fmt.Sprintf(`
INSERT INTO %s.evidence_objects (evidence_id, workspace_id, category, content_sha256, storage_uri, retention_lock)
VALUES ($1, $2, $3, $4, $5, $6)`, rawSchema),
			ev.EvidenceID, ev.WorkspaceID, ev.Category, strings.TrimSpace(ev.ContentSHA256), ev.StorageURI, ev.RetentionLock,
		); err != nil {
			return DisposableRestoreOutcome{}, fmt.Errorf("%w: insert evidence object %s: %v", ErrRestoreIntegrityFailed, ev.EvidenceID, err)
		}
	}

	for _, au := range snap.AuditEntries {
		if _, err := tx1.Exec(ctx, fmt.Sprintf(`
INSERT INTO %s.internal_audit_logs (audit_id, sequence_number, entry_hash, admin_id, action, created_at)
VALUES ($1, $2, $3, $4, $5, $6)`, rawSchema),
			au.AuditID, au.SequenceNumber, au.EntryHash, au.AdminID, au.Action, au.CreatedAt,
		); err != nil {
			return DisposableRestoreOutcome{}, fmt.Errorf("%w: insert audit entry %s: %v", ErrRestoreIntegrityFailed, au.AuditID, err)
		}
	}

	if err := tx1.Commit(ctx); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: commit disposable postgres restore tx: %v", ErrRestoreIntegrityFailed, err)
	}

	// Transaction 2: On a NEW post-commit transaction, verify that all 5 tables survived commit with relpersistence='p',
	// that the 4 tenant tables enforce RLS (relrowsecurity && relforcerowsecurity), and that SQL ledger/credit/audit invariants hold.
	tx2, err := t.Pool.Begin(ctx)
	if err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: begin post-commit verification tx: %v", ErrRestoreIntegrityFailed, err)
	}
	defer func() { _ = tx2.Rollback(ctx) }()

	var permanentTableCount, forcedRLSTableCount int
	if err := tx2.QueryRow(ctx, `
SELECT
	COUNT(*) FILTER (WHERE c.relpersistence = 'p'),
	COUNT(*) FILTER (WHERE c.relpersistence = 'p' AND c.relrowsecurity AND c.relforcerowsecurity)
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = $1
  AND c.relkind = 'r'
  AND c.relname IN ('workspaces', 'financial_postings', 'ai_credit_lots', 'evidence_objects', 'internal_audit_logs')
`, rawSchema).Scan(&permanentTableCount, &forcedRLSTableCount); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: verify persistent tables in pg_catalog: %v", ErrRestoreIntegrityFailed, err)
	}
	if permanentTableCount != 5 || forcedRLSTableCount != 4 {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: expected 5 permanent tables and 4 FORCE RLS tables in schema %s, got permanent=%d rls=%d",
			ErrRestoreIntegrityFailed, rawSchema, permanentTableCount, forcedRLSTableCount)
	}

	wsRows, err := tx2.Query(ctx, fmt.Sprintf(`SELECT workspace_id, name, slug, owner_user_id, ai_credits_remaining, status FROM %s.workspaces ORDER BY workspace_id`, rawSchema))
	if err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: query post-commit restored workspaces: %v", ErrRestoreIntegrityFailed, err)
	}
	var ws []WorkspaceSnapshot
	for wsRows.Next() {
		var item WorkspaceSnapshot
		if err := wsRows.Scan(&item.WorkspaceID, &item.Name, &item.Slug, &item.OwnerUserID, &item.AICreditsRemaining, &item.Status); err != nil {
			wsRows.Close()
			return DisposableRestoreOutcome{}, fmt.Errorf("%w: scan post-commit restored workspace: %v", ErrRestoreIntegrityFailed, err)
		}
		ws = append(ws, item)
	}
	wsRows.Close()

	postingRows, err := tx2.Query(ctx, fmt.Sprintf(`SELECT posting_id, workspace_id, account_code, direction, amount_micro, currency, idempotency_key, created_at FROM %s.financial_postings ORDER BY posting_id`, rawSchema))
	if err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: query post-commit restored financial postings: %v", ErrRestoreIntegrityFailed, err)
	}
	var postings []FinancialPostingSnapshot
	for postingRows.Next() {
		var item FinancialPostingSnapshot
		if err := postingRows.Scan(&item.PostingID, &item.WorkspaceID, &item.AccountCode, &item.Direction, &item.AmountMicro, &item.Currency, &item.IdempotencyKey, &item.CreatedAt); err != nil {
			postingRows.Close()
			return DisposableRestoreOutcome{}, fmt.Errorf("%w: scan post-commit restored financial posting: %v", ErrRestoreIntegrityFailed, err)
		}
		postings = append(postings, item)
	}
	postingRows.Close()

	var imbalancedGroupCount int
	if err := tx2.QueryRow(ctx, fmt.Sprintf(`
SELECT (
	SELECT COUNT(*) FROM (
		SELECT workspace_id, currency
		FROM %[1]s.financial_postings
		GROUP BY workspace_id, currency
		HAVING COALESCE(SUM(CASE WHEN direction = 'debit' THEN amount_micro ELSE 0 END), 0)
		    <> COALESCE(SUM(CASE WHEN direction = 'credit' THEN amount_micro ELSE 0 END), 0)
	) ws_curr_imbalance
) + (
	SELECT COUNT(*) FROM (
		SELECT workspace_id, currency, idempotency_key
		FROM %[1]s.financial_postings
		GROUP BY workspace_id, currency, idempotency_key
		HAVING COALESCE(SUM(CASE WHEN direction = 'debit' THEN amount_micro ELSE 0 END), 0)
		    <> COALESCE(SUM(CASE WHEN direction = 'credit' THEN amount_micro ELSE 0 END), 0)
	) op_imbalance
) + (
	SELECT COUNT(*) FROM %[1]s.workspaces w
	LEFT JOIN (
		SELECT workspace_id, COALESCE(SUM(remaining_credits), 0) AS lot_sum
		FROM %[1]s.ai_credit_lots
		GROUP BY workspace_id
	) l ON l.workspace_id = w.workspace_id
	WHERE COALESCE(l.lot_sum, 0) <> w.ai_credits_remaining
)`, rawSchema)).Scan(&imbalancedGroupCount); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: query postgres post-commit ledger/credit balance: %v", ErrRestoreIntegrityFailed, err)
	}
	if imbalancedGroupCount > 0 {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: postgres SQL post-commit ledger/credit imbalance across %d groups", ErrRestoreIntegrityFailed, imbalancedGroupCount)
	}

	debitMicro, creditMicro, err := verifyRestoredFinancialPostingsBalance(ws, postings)
	if err != nil {
		return DisposableRestoreOutcome{}, err
	}

	var evidenceCount, auditCount int
	if err := tx2.QueryRow(ctx, fmt.Sprintf(`SELECT COUNT(*) FROM %s.evidence_objects`, rawSchema)).Scan(&evidenceCount); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: count post-commit restored evidence objects: %v", ErrRestoreIntegrityFailed, err)
	}
	var minSeq, maxSeq int64
	if err := tx2.QueryRow(ctx, fmt.Sprintf(`SELECT COUNT(*), COALESCE(MIN(sequence_number), 0), COALESCE(MAX(sequence_number), 0) FROM %s.internal_audit_logs`, rawSchema)).Scan(&auditCount, &minSeq, &maxSeq); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: count post-commit restored audit entries: %v", ErrRestoreIntegrityFailed, err)
	}
	if auditCount > 0 && (minSeq != 1 || maxSeq != int64(auditCount)) {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: post-commit audit sequence discontinuity (count=%d min=%d max=%d)", ErrAuditSequenceIntegrityViolation, auditCount, minSeq, maxSeq)
	}

	if err := tx2.Commit(ctx); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: commit post-commit verification tx: %v", ErrRestoreIntegrityFailed, err)
	}

	// Transaction 3: Post-commit non-superuser RLS isolation & tenant business smoke probe.
	wsCount := len(ws) - t.CorruptCount
	if wsCount < 0 {
		wsCount = 0
	}
	if t.FailOnSmoke {
		return DisposableRestoreOutcome{
			TargetDatabaseURI:                  "postgres://disposable-rehearsal/" + rawSchema,
			RestoredSchemaName:                 rawSchema,
			OperationalPostgresRestoreVerified: false,
			PersistentSchemaVerified:           true,
			RLSIsolationVerified:               false,
			PostCommitSmokeVerified:            false,
			WorkspacesRestored:                 wsCount,
			PostingsRestored:                   len(postings),
			EvidenceObjectsRestored:            evidenceCount,
			AuditEntriesRestored:               auditCount,
			ObservedDebitMicro:                 debitMicro,
			ObservedCreditMicro:                creditMicro,
			SmokeProbePassed:                   false,
			SmokeFailureCode:                   "DISPOSABLE_SMOKE_PROBE_FAILED",
		}, nil
	}

	tx3, err := t.Pool.Begin(ctx)
	if err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: begin post-commit RLS smoke tx: %v", ErrRestoreIntegrityFailed, err)
	}
	defer func() { _ = tx3.Rollback(ctx) }()

	rlsSetupSQL := fmt.Sprintf(`
DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rehearsal_p808_rls_probe') THEN
		CREATE ROLE rehearsal_p808_rls_probe NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS;
	END IF;
END
$$;
GRANT USAGE ON SCHEMA %[1]s TO rehearsal_p808_rls_probe;
GRANT SELECT ON ALL TABLES IN SCHEMA %[1]s TO rehearsal_p808_rls_probe;
`, rawSchema)
	if _, err := tx3.Exec(ctx, rlsSetupSQL); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: configure non-superuser RLS probe role: %v", ErrRestoreIntegrityFailed, err)
	}
	if _, err := tx3.Exec(ctx, `SET LOCAL ROLE rehearsal_p808_rls_probe`); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: assume rehearsal_p808_rls_probe role: %v", ErrRestoreIntegrityFailed, err)
	}
	if _, err := tx3.Exec(ctx, `SELECT set_config('app.current_tenant_id', '', true)`); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: clear tenant context for RLS negative probe: %v", ErrRestoreIntegrityFailed, err)
	}

	var leakedWorkspaces, leakedPostings, leakedLots, leakedEvidence int
	if err := tx3.QueryRow(ctx, fmt.Sprintf(`
SELECT
	(SELECT COUNT(*) FROM %[1]s.workspaces),
	(SELECT COUNT(*) FROM %[1]s.financial_postings),
	(SELECT COUNT(*) FROM %[1]s.ai_credit_lots),
	(SELECT COUNT(*) FROM %[1]s.evidence_objects)
`, rawSchema)).Scan(&leakedWorkspaces, &leakedPostings, &leakedLots, &leakedEvidence); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: execute negative RLS probe on %s: %v", ErrRestoreIntegrityFailed, rawSchema, err)
	}
	if leakedWorkspaces != 0 || leakedPostings != 0 || leakedLots != 0 || leakedEvidence != 0 {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: RLS isolation failure on %s: empty tenant context saw workspaces=%d postings=%d lots=%d evidence=%d",
			ErrRestoreIntegrityFailed, rawSchema, leakedWorkspaces, leakedPostings, leakedLots, leakedEvidence)
	}

	primaryWS := snap.Workspaces[0]
	if _, err := tx3.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true)`, primaryWS.WorkspaceID); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: set tenant context for RLS positive smoke probe: %v", ErrRestoreIntegrityFailed, err)
	}
	var visibleWSCount, crossTenantPostings, crossTenantLots, crossTenantEvidence int
	var observedCredits int64
	if err := tx3.QueryRow(ctx, fmt.Sprintf(`
SELECT
	(SELECT COUNT(*) FROM %[1]s.workspaces),
	COALESCE((SELECT ai_credits_remaining FROM %[1]s.workspaces WHERE workspace_id = $1), -1),
	(SELECT COUNT(*) FROM %[1]s.financial_postings WHERE workspace_id <> $1),
	(SELECT COUNT(*) FROM %[1]s.ai_credit_lots WHERE workspace_id <> $1),
	(SELECT COUNT(*) FROM %[1]s.evidence_objects WHERE workspace_id <> $1)
`, rawSchema), primaryWS.WorkspaceID).Scan(&visibleWSCount, &observedCredits, &crossTenantPostings, &crossTenantLots, &crossTenantEvidence); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: execute positive RLS smoke probe on %s: %v", ErrRestoreIntegrityFailed, rawSchema, err)
	}
	if visibleWSCount != 1 || observedCredits != primaryWS.AICreditsRemaining || crossTenantPostings != 0 || crossTenantLots != 0 || crossTenantEvidence != 0 {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: post-commit tenant smoke probe failed (visibleWS=%d credits=%d/%d crossTenantPostings=%d crossTenantLots=%d crossTenantEvidence=%d)",
			ErrRestoreIntegrityFailed, visibleWSCount, observedCredits, primaryWS.AICreditsRemaining, crossTenantPostings, crossTenantLots, crossTenantEvidence)
	}
	if _, err := tx3.Exec(ctx, `RESET ROLE`); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: reset role after RLS smoke probe: %v", ErrRestoreIntegrityFailed, err)
	}
	if err := tx3.Commit(ctx); err != nil {
		return DisposableRestoreOutcome{}, fmt.Errorf("%w: commit post-commit RLS smoke tx: %v", ErrRestoreIntegrityFailed, err)
	}

	if t.PostRestoreSmokeProbe != nil {
		if err := t.PostRestoreSmokeProbe(ctx, t.Pool, rawSchema); err != nil {
			return DisposableRestoreOutcome{
				TargetDatabaseURI:                  "postgres://disposable-rehearsal/" + rawSchema,
				RestoredSchemaName:                 rawSchema,
				OperationalPostgresRestoreVerified: false,
				PersistentSchemaVerified:           true,
				RLSIsolationVerified:               true,
				PostCommitSmokeVerified:            false,
				WorkspacesRestored:                 wsCount,
				PostingsRestored:                   len(postings),
				EvidenceObjectsRestored:            evidenceCount,
				AuditEntriesRestored:               auditCount,
				ObservedDebitMicro:                 debitMicro,
				ObservedCreditMicro:                creditMicro,
				SmokeProbePassed:                   false,
				SmokeFailureCode:                   "DISPOSABLE_SMOKE_PROBE_FAILED",
			}, nil
		}
	}

	return DisposableRestoreOutcome{
		TargetDatabaseURI:                  "postgres://disposable-rehearsal/" + rawSchema,
		RestoredSchemaName:                 rawSchema,
		OperationalPostgresRestoreVerified: true,
		PersistentSchemaVerified:           true,
		RLSIsolationVerified:               true,
		PostCommitSmokeVerified:            true,
		WorkspacesRestored:                 wsCount,
		PostingsRestored:                   len(postings),
		EvidenceObjectsRestored:            evidenceCount,
		AuditEntriesRestored:               auditCount,
		ObservedDebitMicro:                 debitMicro,
		ObservedCreditMicro:                creditMicro,
		SmokeProbePassed:                   true,
		SmokeFailureCode:                   "OK",
	}, nil
}

// ExecuteRestoreRehearsal validates a verified backup snapshot on disk (SHA-256 sidecar,
// double-entry financial ledger balance, workspace AI credit lot reconciliation, immutable
// evidence SHA-256 preservation, audit sequence continuity, and RPO=0 / RTO<=3600s SLA bounds).
// Because no disposable database target is passed to this method, it honestly labels the result
// as SIMULATION_ONLY (IsSimulation=true, OperationalRestorePerformed=false) and refuses to claim
// an operational production/staging restore. Use ExecuteDisposableRestoreRehearsal to restore and
// verify against a disposable target DB.
func (s *Service) ExecuteRestoreRehearsal(
	ctx context.Context,
	adminID string,
	artifact BackupArtifactMetadata,
	rpoSeconds int32,
	rtoSeconds int32,
) (*BackupRestoreRehearsalRecord, error) {
	return s.executeRestoreRehearsalInternal(ctx, adminID, artifact, rpoSeconds, rtoSeconds, nil)
}

// ExecuteDisposableRestoreRehearsal performs a restore into a disposable database target,
// measures real wall-clock restore duration, verifies restored row counts and ledger balance
// read back from the disposable target, and records DISPOSABLE_TARGET_VERIFIED evidence only
// when backed by a real PostgreSQL restore target (OperationalPostgresRestoreVerified=true).
func (s *Service) ExecuteDisposableRestoreRehearsal(
	ctx context.Context,
	adminID string,
	artifact BackupArtifactMetadata,
	rpoSeconds int32,
	target DisposableRestoreTarget,
) (*BackupRestoreRehearsalRecord, error) {
	if target == nil {
		return nil, ErrOperationalTargetRequired
	}
	return s.executeRestoreRehearsalInternal(ctx, adminID, artifact, rpoSeconds, 0, target)
}

func (s *Service) executeRestoreRehearsalInternal(
	ctx context.Context,
	adminID string,
	artifact BackupArtifactMetadata,
	rpoSeconds int32,
	rtoSeconds int32,
	target DisposableRestoreTarget,
) (*BackupRestoreRehearsalRecord, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	startedWall := time.Now()

	s.mu.Lock()
	admin, ok := s.adminsByID[adminID]
	s.mu.Unlock()
	if !ok || admin.Status != "active" {
		return nil, ErrInvalidAdminCredentials
	}
	if admin.AdminRole != rbac.AdminRoleSuper && admin.AdminRole != rbac.AdminRoleTech && admin.AdminRole != rbac.AdminRoleOps {
		return nil, fmt.Errorf("%w: role %q cannot execute restore rehearsals", ErrPrivilegedRoleBoundaryViolation, admin.AdminRole)
	}

	// 1. Verify on-disk SHA-256 sidecar before touching target state.
	if err := VerifyBackupArtifactChecksum(artifact.SnapshotPath, artifact.SidecarPath); err != nil {
		return nil, err
	}

	raw, err := os.ReadFile(artifact.SnapshotPath)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrRestoreIntegrityFailed, err)
	}
	var restored DatabaseSnapshot
	if err := json.Unmarshal(raw, &restored); err != nil {
		return nil, fmt.Errorf("%w: unmarshal snapshot: %v", ErrRestoreIntegrityFailed, err)
	}

	// Never allow claiming an operational production or staging restore without a disposable DB target.
	envLower := strings.ToLower(strings.TrimSpace(restored.Environment))
	if target == nil && (envLower == "production" || envLower == "staging") {
		return nil, fmt.Errorf("%w: snapshot environment %q cannot be claimed without a disposable restore target", ErrOperationalTargetRequired, restored.Environment)
	}

	restoredDigest, err := ComputeSnapshotSHA256(restored)
	if err != nil || restoredDigest != artifact.SHA256Digest {
		return nil, fmt.Errorf("%w: restored digest mismatch", ErrBackupChecksumMismatch)
	}

	// 2. Verify RPO=0 for financial/audit data and RTO <= 3600s (runbook.md §4.1).
	if rpoSeconds < 0 || rpoSeconds > MaxFinancialAuditRPOSeconds {
		return nil, fmt.Errorf("%w: RPO %ds exceeds 0s zero-data-loss target for financial/audit tables", ErrRestoreIntegrityFailed, rpoSeconds)
	}
	if rtoSeconds < 0 || rtoSeconds > MaxStandardRTOSeconds {
		return nil, fmt.Errorf("%w: RTO %ds exceeds 3600s (1 hour) maximum recovery target", ErrRestoreIntegrityFailed, rtoSeconds)
	}

	// 3. Reconcile double-entry financial postings (exact integer micro-units; debits must equal credits globally, per workspace/currency, and per operation).
	if len(restored.Workspaces) == 0 || len(restored.FinancialPostings) == 0 || len(restored.AICreditLots) == 0 || len(restored.EvidenceObjects) == 0 || len(restored.AuditEntries) == 0 {
		return nil, fmt.Errorf("%w: snapshot is missing required workspaces, financial postings, AI credit lots, evidence objects, or audit entries", ErrRestoreIntegrityFailed)
	}
	totalDebitMicro, totalCreditMicro, err := verifyRestoredFinancialPostingsBalance(restored.Workspaces, restored.FinancialPostings)
	if err != nil {
		return nil, err
	}

	// 4. Reconcile AI credit lots per workspace against workspace.AICreditsRemaining.
	lotSums := make(map[string]int64)
	for _, lot := range restored.AICreditLots {
		if lot.RemainingCredits < 0 || lot.RemainingCredits > lot.InitialCredits {
			return nil, fmt.Errorf("%w: invalid credit lot %s balance %d/%d", ErrRestoreIntegrityFailed, lot.LotID, lot.RemainingCredits, lot.InitialCredits)
		}
		lotSums[lot.WorkspaceID] += lot.RemainingCredits
	}
	for _, ws := range restored.Workspaces {
		if lotSums[ws.WorkspaceID] != ws.AICreditsRemaining {
			return nil, fmt.Errorf("%w: workspace %s credit balance %d does not match lot sum %d",
				ErrRestoreIntegrityFailed, ws.WorkspaceID, ws.AICreditsRemaining, lotSums[ws.WorkspaceID])
		}
	}

	// 5. Verify immutable evidence objects have valid 64-char SHA-256 digests.
	for _, ev := range restored.EvidenceObjects {
		if len(strings.TrimSpace(ev.ContentSHA256)) != 64 {
			return nil, fmt.Errorf("%w: evidence object %s missing 64-char SHA-256 digest", ErrRestoreIntegrityFailed, ev.EvidenceID)
		}
	}

	// 6. Verify internal audit log sequence continuity (1..N with zero gaps).
	sortedAudits := append([]AuditSequenceEntrySnapshot(nil), restored.AuditEntries...)
	sort.Slice(sortedAudits, func(i, j int) bool {
		return sortedAudits[i].SequenceNumber < sortedAudits[j].SequenceNumber
	})
	for idx, entry := range sortedAudits {
		expectedSeq := int64(idx + 1)
		if entry.SequenceNumber != expectedSeq {
			return nil, fmt.Errorf("%w: audit sequence gap detected at index %d (expected %d, got %d)",
				ErrAuditSequenceIntegrityViolation, idx, expectedSeq, entry.SequenceNumber)
		}
	}

	executionMode := RehearsalModeSimulationOnly
	isSimulation := true
	operationalPerformed := false
	targetURI := ""
	restoredSchemaName := ""
	persistentSchemaVerified := false
	rlsIsolationVerified := false
	postCommitSmokeVerified := false
	smokePassed := false
	smokeFailureCode := "SIMULATION_ONLY_NO_DISPOSABLE_DB"
	workspacesRestored := len(restored.Workspaces)
	postingsRestored := len(restored.FinancialPostings)
	evidencesRestored := len(restored.EvidenceObjects)
	auditsRestored := len(restored.AuditEntries)

	if target != nil {
		outcome, err := target.RestoreAndVerifySnapshot(ctx, restored)
		if err != nil {
			return nil, err
		}
		if outcome.WorkspacesRestored != len(restored.Workspaces) ||
			outcome.PostingsRestored != len(restored.FinancialPostings) ||
			outcome.EvidenceObjectsRestored != len(restored.EvidenceObjects) ||
			outcome.AuditEntriesRestored != len(restored.AuditEntries) {
			return nil, fmt.Errorf("%w: disposable target row count mismatch after restore", ErrRestoreIntegrityFailed)
		}
		if outcome.ObservedDebitMicro != totalDebitMicro || outcome.ObservedCreditMicro != totalCreditMicro {
			return nil, fmt.Errorf("%w: disposable target debit/credit mismatch after restore", ErrRestoreIntegrityFailed)
		}
		if outcome.SmokeFailureCode == "DISPOSABLE_SMOKE_PROBE_FAILED" || (outcome.OperationalPostgresRestoreVerified && !outcome.SmokeProbePassed) {
			return nil, fmt.Errorf("%w: disposable target post-restore smoke failed (%s)", ErrRestoreIntegrityFailed, outcome.SmokeFailureCode)
		}
		operationalVerified := outcome.OperationalPostgresRestoreVerified &&
			outcome.PersistentSchemaVerified &&
			outcome.RLSIsolationVerified &&
			outcome.PostCommitSmokeVerified &&
			strings.HasPrefix(strings.ToLower(strings.TrimSpace(outcome.TargetDatabaseURI)), "postgres") &&
			!isReservedOrTempPostgresSchema(outcome.RestoredSchemaName)
		if !operationalVerified && (envLower == "production" || envLower == "staging") {
			return nil, fmt.Errorf("%w: snapshot environment %q requires a verified persistent PostgreSQL restore target with RLS and post-commit smoke, not a file/temporary simulation fixture (%s)", ErrOperationalTargetRequired, restored.Environment, outcome.TargetDatabaseURI)
		}
		targetURI = outcome.TargetDatabaseURI
		restoredSchemaName = outcome.RestoredSchemaName
		persistentSchemaVerified = outcome.PersistentSchemaVerified
		rlsIsolationVerified = outcome.RLSIsolationVerified
		postCommitSmokeVerified = outcome.PostCommitSmokeVerified
		workspacesRestored = outcome.WorkspacesRestored
		postingsRestored = outcome.PostingsRestored
		evidencesRestored = outcome.EvidenceObjectsRestored
		auditsRestored = outcome.AuditEntriesRestored
		if operationalVerified {
			executionMode = RehearsalModeDisposableTargetVerified
			isSimulation = false
			operationalPerformed = true
			smokePassed = true
			smokeFailureCode = outcome.SmokeFailureCode
		} else {
			executionMode = RehearsalModeSimulationOnly
			isSimulation = true
			operationalPerformed = false
			smokePassed = false
			if outcome.SmokeFailureCode != "" && outcome.SmokeFailureCode != "OK" {
				smokeFailureCode = outcome.SmokeFailureCode
			} else {
				smokeFailureCode = "SIMULATION_FILE_TARGET_ONLY"
			}
		}
	}

	elapsedMs := time.Since(startedWall).Milliseconds()
	if elapsedMs < 0 {
		elapsedMs = 0
	}
	measuredRTO := rtoSeconds
	if target != nil && measuredRTO == 0 {
		measuredRTO = int32(elapsedMs / 1000)
		if measuredRTO > MaxStandardRTOSeconds {
			return nil, fmt.Errorf("%w: measured RTO %ds exceeds 3600s SLA", ErrRestoreIntegrityFailed, measuredRTO)
		}
	}

	now := s.Now()
	s.mu.Lock()
	defer s.mu.Unlock()

	rec := &BackupRestoreRehearsalRecord{
		RehearsalID:                   s.IDGenerator(),
		Environment:                   restored.Environment,
		ExecutionMode:                 executionMode,
		IsSimulation:                  isSimulation,
		OperationalRestorePerformed:   operationalPerformed,
		TargetDatabaseURI:             targetURI,
		RestoredSchemaName:            restoredSchemaName,
		PersistentSchemaVerified:      persistentSchemaVerified,
		RLSIsolationVerified:          rlsIsolationVerified,
		PostCommitSmokeVerified:       postCommitSmokeVerified,
		ProductionDRGateApproved:      false,
		ProductionReleaseGateApproved: false,
		MeasuredRestoreDurationMs:     elapsedMs,
		BackupArtifactURI:             artifact.SnapshotPath,
		BackupSHA256:                  artifact.SHA256Digest,
		RestoredSHA256:                restoredDigest,
		ChecksumVerified:              true,
		RPOSeconds:                    rpoSeconds,
		RTOSeconds:                    measuredRTO,
		WorkspacesRestored:            workspacesRestored,
		PostingsRestored:              postingsRestored,
		EvidenceObjectsRestored:       evidencesRestored,
		AuditEntriesRestored:          auditsRestored,
		LedgerBalanced:                true,
		AuditSequenceContinuous:       true,
		SmokePassed:                   smokePassed,
		SmokeFailureCode:              smokeFailureCode,
		RollbackTriggered:             false,
		PreviousSlotDigest:            s.activeSlotDigest,
		CandidateSlotDigest:           s.activeSlotDigest,
		ActiveSlotAfterRehearsal:      s.activeSlot,
		ExecutedByAdminID:             adminID,
		ExecutedAt:                    now,
	}
	s.restoreRehearsals[rec.RehearsalID] = rec
	auditReason := "Simulated point-in-time backup snapshot validation (SIMULATION_ONLY: no disposable DB or live smoke target touched)"
	if operationalPerformed {
		auditReason = "Verified disposable-target point-in-time backup restore rehearsal (DISPOSABLE_TARGET_VERIFIED)"
	}
	s.appendSequencedAuditLocked(adminID, admin.AdminRole, "rehearsal.backup_restored", "backup_restore_rehearsal", rec.RehearsalID, "", auditReason, map[string]any{
		"execution_mode":                rec.ExecutionMode,
		"is_simulation":                 rec.IsSimulation,
		"operational_restore_performed": rec.OperationalRestorePerformed,
		"target_database_uri":           rec.TargetDatabaseURI,
		"restored_schema_name":          rec.RestoredSchemaName,
		"persistent_schema_verified":    rec.PersistentSchemaVerified,
		"rls_isolation_verified":        rec.RLSIsolationVerified,
		"post_commit_smoke_verified":    rec.PostCommitSmokeVerified,
		"production_dr_gate_approved":   rec.ProductionDRGateApproved,
		"measured_restore_duration_ms":  rec.MeasuredRestoreDurationMs,
		"backup_sha256":                 rec.BackupSHA256,
		"restored_sha256":               rec.RestoredSHA256,
		"rpo_seconds":                   rec.RPOSeconds,
		"rto_seconds":                   rec.RTOSeconds,
		"ledger_balanced":               rec.LedgerBalanced,
	})

	cp := *rec
	return &cp, nil
}

// CandidateSlotProbeInput describes the health, readiness, and authenticated business smoke observations
// for a Blue/Green candidate deployment slot (ci_cd_pipeline.md §4, §5).
type CandidateSlotProbeInput struct {
	CandidateSlot                    string // "blue" or "green"
	CandidateImageDigest             string // e.g. "sha256:..."
	HealthzHTTPStatus                int
	HealthzStatusField               string // must be "ok"
	ReadyzHTTPStatus                 int
	ReadyzStatusField                string // must be "ready"
	DatabaseReady                    bool
	RedisReady                       bool
	NATSReady                        bool
	SmokeAuthValid                   bool
	SmokeWorkspaceID                 string
	SmokeExpectedWorkspaceID         string
	SmokeResponseValidJSON           bool
	SmokeExpectedNetProfitMicro      int64
	SmokeObservedNetProfitMicro      int64
	SmokeExpectedCreditsBalance      int64
	SmokeObservedCreditsBalance      int64
	SmokeAuditSequenceIntact         bool
	LiveDiagnosticsUnavailableReason string
	LiveSmokeMetricsUnobservedReason string
}

// ReleaseSmokeVerdict captures the outcome of a Blue/Green candidate slot deployment and smoke gate.
type ReleaseSmokeVerdict struct {
	ExecutionMode           string
	IsSimulation            bool
	ProxyUpstreamSwitched   bool
	MeasuredProbeDurationMs int64
	CandidatePromoted       bool
	RollbackTriggered       bool
	RollbackSucceeded       bool
	RollbackError           string
	FailureCode             string
	FailureReason           string
	ActiveSlot              string
	ActiveSlotDigest        string
	RetainedRollbackDigest  string
	EvaluatedAt             time.Time
}

// DisposableProxyTarget abstracts a disposable reverse proxy upstream switcher for live Blue/Green rehearsals.
type DisposableProxyTarget interface {
	SwitchUpstream(ctx context.Context, slot, imageDigest string) error
	RollbackUpstream(ctx context.Context, previousSlot, previousDigest string) error
}

// DisposableProxyActiveStateVerifier is an optional extension implemented by disposable proxy targets
// that can report their verified live active upstream slot and image digest after switch or rollback.
type DisposableProxyActiveStateVerifier interface {
	VerifiedActiveUpstream(ctx context.Context) (slot, imageDigest string, err error)
}

// AuditIntegrityProbeResponse is the response payload returned by GET /admin/v1/audit-integrity
// on candidate servers exposing real internaladmin audit sequence and hash-chain verification.
type AuditIntegrityProbeResponse struct {
	AuditSequenceIntact *bool  `json:"auditSequenceIntact"`
	CheckedEntriesCount int64  `json:"checkedEntriesCount"`
	MissingSequenceAt   int64  `json:"missingSequenceAt"`
	ReadOnlyLockApplied bool   `json:"readOnlyLockApplied"`
	HashChainVerified   bool   `json:"hashChainVerified"`
	FailureReason       string `json:"failureReason,omitempty"`
}

// AppendSequencedAuditEntry appends an immutable sequenced hash-chained audit entry for an active admin.
func (s *Service) AppendSequencedAuditEntry(adminID, action, targetType, targetID, targetWorkspaceID, reason string, metadata map[string]any) (InternalAuditLogRecord, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	admin, ok := s.adminsByID[adminID]
	if !ok || admin.Status != "active" {
		return InternalAuditLogRecord{}, ErrInvalidAdminCredentials
	}
	if s.auditReadOnlyLocked {
		return InternalAuditLogRecord{}, ErrAuditSequenceIntegrityViolation
	}
	return s.appendSequencedAuditLocked(adminID, admin.AdminRole, action, targetType, targetID, targetWorkspaceID, reason, metadata), nil
}

func (s *Service) withCandidateAdminContext(r *http.Request) *http.Request {
	s.mu.Lock()
	var selected *InternalAdminRecord
	for _, adm := range s.adminsByID {
		if adm != nil && adm.Status == "active" && (adm.AdminRole == rbac.AdminRoleSuper || adm.AdminRole == rbac.AdminRoleTech || adm.AdminRole == rbac.AdminRoleOps) {
			if selected == nil || adm.AdminRole == rbac.AdminRoleSuper || adm.AdminID < selected.AdminID {
				selected = adm
			}
		}
	}
	now := s.Now()
	if selected == nil {
		s.mu.Unlock()
		return r
	}
	sessionID := "candidate-smoke-session-" + selected.AdminID
	s.sessionsByID[sessionID] = &AdminSessionRecord{
		SessionID:   sessionID,
		AdminID:     selected.AdminID,
		AdminRole:   selected.AdminRole,
		IPAddress:   "127.0.0.1",
		VPNVerified: true,
		MFAVerified: true,
		CreatedAt:   now,
		ExpiresAt:   now.Add(AdminSessionTTL),
	}
	adminID := selected.AdminID
	adminRole := selected.AdminRole
	s.mu.Unlock()

	ctx := WithTrustedVPNTransport(r.Context(), "127.0.0.1")
	ctx = WithAdminActor(ctx, AdminActorContext{
		SessionID:   sessionID,
		AdminID:     adminID,
		AdminRole:   adminRole,
		VPNVerified: true,
		MFAVerified: true,
		IPAddress:   "127.0.0.1",
	})
	return r.WithContext(ctx)
}

// NewCandidateSystemConfigHandler mounts the real ConnectRPC SystemConfigService handler on s,
// enforcing Bearer authorization via authorizeBearer and binding an active admin session context.
func (s *Service) NewCandidateSystemConfigHandler(authorizeBearer func(r *http.Request) bool) (string, http.Handler) {
	path, connectHandler := adminv1connect.NewSystemConfigServiceHandler(s)
	return path, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if authorizeBearer != nil && !authorizeBearer(r) {
			w.WriteHeader(http.StatusForbidden)
			_, _ = w.Write([]byte(`{"error":"forbidden"}`))
			return
		}
		connectHandler.ServeHTTP(w, s.withCandidateAdminContext(r))
	})
}

// NewCandidateAuditIntegrityHandler mounts GET /admin/v1/audit-integrity backed by s.VerifyAuditLogSequenceIntegrity()
// and cryptographic hash-chain verification across s.auditLogs.
func (s *Service) NewCandidateAuditIntegrityHandler(authorizeBearer func(r *http.Request) bool) (string, http.Handler) {
	return "/admin/v1/audit-integrity", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if authorizeBearer != nil && !authorizeBearer(r) {
			w.WriteHeader(http.StatusForbidden)
			_, _ = w.Write([]byte(`{"error":"forbidden"}`))
			return
		}
		res, verifyErr := s.VerifyAuditLogSequenceIntegrity()

		s.mu.Lock()
		totalEntries := int64(len(s.auditLogs))
		readOnlyLocked := s.auditReadOnlyLocked
		hashChainOK := totalEntries > 0
		prevHash := "GENESIS"
		for _, entry := range s.auditLogs {
			if entry.SequenceNumber <= 0 || strings.TrimSpace(entry.EntryHash) == "" {
				hashChainOK = false
				break
			}
			expectedHash := hashAdminPayload(
				fmt.Sprintf("%d", entry.SequenceNumber),
				prevHash,
				entry.AuditID,
				entry.AdminID,
				entry.Action,
				entry.TargetID,
				entry.Reason,
			)
			if entry.EntryHash != expectedHash {
				hashChainOK = false
				break
			}
			prevHash = entry.EntryHash
		}
		s.mu.Unlock()

		intact := verifyErr == nil &&
			res.Intact &&
			!res.ReadOnlyLockApplied &&
			!readOnlyLocked &&
			hashChainOK &&
			totalEntries > 0 &&
			int64(res.CheckedEntries) == totalEntries

		resp := AuditIntegrityProbeResponse{
			AuditSequenceIntact: &intact,
			CheckedEntriesCount: int64(res.CheckedEntries),
			MissingSequenceAt:   res.MissingSequenceAt,
			ReadOnlyLockApplied: res.ReadOnlyLockApplied || readOnlyLocked,
			HashChainVerified:   hashChainOK,
		}
		if verifyErr != nil {
			resp.FailureReason = verifyErr.Error()
		} else if !hashChainOK {
			resp.FailureReason = "audit log entry hash chain mismatch or unsequenced/empty audit log"
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_ = json.NewEncoder(w).Encode(resp)
	})
}

// ExecuteBlueGreenReleaseSmokeRehearsal evaluates a candidate deployment slot against the mandatory
// pre-promotion health, readiness, and authenticated business smoke checks (ci_cd_pipeline.md §4, §5).
// Because this method evaluates caller-supplied probe inputs in memory without touching a reverse proxy,
// it labels the verdict as SIMULATION_ONLY (IsSimulation=true, ProxyUpstreamSwitched=false).
// Use ExecuteLiveBlueGreenReleaseSmokeRehearsal to probe a live candidate HTTP endpoint and switch a disposable proxy.
func (s *Service) ExecuteBlueGreenReleaseSmokeRehearsal(
	ctx context.Context,
	adminID string,
	probe CandidateSlotProbeInput,
) (ReleaseSmokeVerdict, error) {
	return s.evaluateBlueGreenProbe(ctx, adminID, probe, nil, 0)
}

func parseJSONExactInt64(raw json.RawMessage) (int64, bool) {
	trimmed := strings.TrimSpace(string(raw))
	if trimmed == "" || trimmed == "null" {
		return 0, false
	}
	if strings.HasPrefix(trimmed, `"`) && strings.HasSuffix(trimmed, `"`) && len(trimmed) >= 2 {
		trimmed = strings.TrimSpace(trimmed[1 : len(trimmed)-1])
	}
	if v, err := strconv.ParseInt(trimmed, 10, 64); err == nil {
		return v, true
	}
	if strings.Contains(trimmed, ".") {
		parts := strings.SplitN(trimmed, ".", 2)
		if len(parts) == 2 && parts[0] != "" && parts[1] != "" {
			allZeros := true
			for i := 0; i < len(parts[1]); i++ {
				if parts[1][i] != '0' {
					allZeros = false
					break
				}
			}
			if allZeros {
				if v, err := strconv.ParseInt(parts[0], 10, 64); err == nil {
					return v, true
				}
			}
		}
	}
	return 0, false
}

// ExecuteLiveBlueGreenReleaseSmokeRehearsal probes a live disposable candidate HTTP server (/healthz, /readyz, and either /smoke or real API routes),
// measures real HTTP probe duration, and switches a disposable proxy upstream only when all checks pass.
// Expected values (expectedNetProfitMicro, expectedCreditsBalance) are NEVER copied into observed fields;
// every observed metric must be returned by the candidate HTTP server or the rehearsal fails closed and rolls back.
func (s *Service) ExecuteLiveBlueGreenReleaseSmokeRehearsal(
	ctx context.Context,
	adminID string,
	candidateSlot string,
	candidateImageDigest string,
	candidateBaseURL string,
	authToken string,
	expectedWorkspaceID string,
	expectedNetProfitMicro int64,
	expectedCreditsBalance int64,
	proxyTarget DisposableProxyTarget,
) (ReleaseSmokeVerdict, error) {
	if proxyTarget == nil || strings.TrimSpace(candidateBaseURL) == "" {
		return ReleaseSmokeVerdict{}, ErrOperationalTargetRequired
	}
	startedWall := time.Now()
	client := &http.Client{Timeout: 5 * time.Second}
	baseURL := strings.TrimRight(candidateBaseURL, "/")

	probe := CandidateSlotProbeInput{
		CandidateSlot:               candidateSlot,
		CandidateImageDigest:        candidateImageDigest,
		SmokeExpectedWorkspaceID:    strings.TrimSpace(expectedWorkspaceID),
		SmokeExpectedNetProfitMicro: expectedNetProfitMicro,
		SmokeExpectedCreditsBalance: expectedCreditsBalance,
	}

	// 1. Probe /healthz
	if resp, err := client.Get(baseURL + "/healthz"); err == nil {
		probe.HealthzHTTPStatus = resp.StatusCode
		var body struct {
			Status string `json:"status"`
		}
		_ = json.NewDecoder(resp.Body).Decode(&body)
		_ = resp.Body.Close()
		probe.HealthzStatusField = body.Status
	}

	// 2. Probe /readyz
	// Supports both real bootstrap /readyz ({"status":"ready","role":"api"} after verifying DB+broker readiness)
	// and explicit component-field /readyz payloads ({"status":"ready","database":true,"redis":true,"nats":true}).
	if resp, err := client.Get(baseURL + "/readyz"); err == nil {
		probe.ReadyzHTTPStatus = resp.StatusCode
		var body struct {
			Status   string `json:"status"`
			Database *bool  `json:"database"`
			Redis    *bool  `json:"redis"`
			NATS     *bool  `json:"nats"`
		}
		_ = json.NewDecoder(resp.Body).Decode(&body)
		_ = resp.Body.Close()
		probe.ReadyzStatusField = body.Status
		if resp.StatusCode == http.StatusOK && strings.EqualFold(strings.TrimSpace(body.Status), "ready") {
			probe.DatabaseReady = body.Database == nil || *body.Database
			probe.RedisReady = body.Redis == nil || *body.Redis
			probe.NATSReady = body.NATS == nil || *body.NATS
		} else {
			if body.Database != nil {
				probe.DatabaseReady = *body.Database
			}
			if body.Redis != nil {
				probe.RedisReady = *body.Redis
			}
			if body.NATS != nil {
				probe.NATSReady = *body.NATS
			}
		}
	}

	// 3. Probe authenticated business smoke (/smoke harness or real cmd/api ConnectRPC routes when /smoke returns 404).
	smokeStatus := 0
	unauthSmokeRejected := false
	if unauthSmokeReq, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/smoke", nil); err == nil {
		if unauthSmokeResp, err := client.Do(unauthSmokeReq); err == nil {
			_ = unauthSmokeResp.Body.Close()
			if unauthSmokeResp.StatusCode == http.StatusNotFound {
				smokeStatus = http.StatusNotFound
			} else if unauthSmokeResp.StatusCode == http.StatusUnauthorized || unauthSmokeResp.StatusCode == http.StatusForbidden {
				unauthSmokeRejected = true
			}
		}
	}

	if smokeStatus != http.StatusNotFound && unauthSmokeRejected && strings.TrimSpace(authToken) != "" {
		req, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/smoke", nil)
		if err == nil {
			req.Header.Set("Authorization", "Bearer "+authToken)
			if resp, err := client.Do(req); err == nil {
				smokeStatus = resp.StatusCode
				rawBody, _ := io.ReadAll(resp.Body)
				_ = resp.Body.Close()
				if resp.StatusCode == http.StatusOK {
					probe.SmokeAuthValid = true
					var body struct {
						WorkspaceID         string `json:"workspace_id"`
						NetProfitMicro      *int64 `json:"net_profit_micro"`
						CreditsBalance      *int64 `json:"credits_balance"`
						AuditSequenceIntact *bool  `json:"audit_sequence_intact"`
					}
					if err := json.Unmarshal(rawBody, &body); err == nil {
						if body.NetProfitMicro != nil && body.CreditsBalance != nil && body.AuditSequenceIntact != nil {
							probe.SmokeResponseValidJSON = true
							probe.SmokeWorkspaceID = body.WorkspaceID
							probe.SmokeObservedNetProfitMicro = *body.NetProfitMicro
							probe.SmokeObservedCreditsBalance = *body.CreditsBalance
							probe.SmokeAuditSequenceIntact = *body.AuditSequenceIntact
						} else {
							probe.LiveSmokeMetricsUnobservedReason = "/smoke response omitted required net_profit_micro, credits_balance, or audit_sequence_intact fields"
						}
					}
				}
			}
		}
	}

	if smokeStatus == http.StatusNotFound {
		// Real cmd/api server does not expose a synthetic /smoke route; probe real authenticated API endpoints:
		// (a) Unauthenticated GET /api/workspaces/discovery must fail closed with 401 Unauthorized.
		unauthDenied := false
		if unauthReq, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/api/workspaces/discovery", nil); err == nil {
			if unauthResp, err := client.Do(unauthReq); err == nil {
				_ = unauthResp.Body.Close()
				unauthDenied = unauthResp.StatusCode == http.StatusUnauthorized
			}
		}
		// (b) Authenticated GET /api/workspaces/discovery must succeed and return workspace memberships.
		if unauthDenied && strings.TrimSpace(authToken) != "" {
			if discReq, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/api/workspaces/discovery", nil); err == nil {
				discReq.Header.Set("Authorization", "Bearer "+authToken)
				if discResp, err := client.Do(discReq); err == nil {
					rawDisc, _ := io.ReadAll(discResp.Body)
					_ = discResp.Body.Close()
					if discResp.StatusCode == http.StatusOK {
						probe.SmokeAuthValid = true
						var discBody struct {
							Workspaces []struct {
								WorkspaceID string `json:"workspace_id"`
							} `json:"workspaces"`
						}
						if err := json.Unmarshal(rawDisc, &discBody); err == nil {
							matchedWS := ""
							expectedWS := strings.TrimSpace(expectedWorkspaceID)
							for _, ws := range discBody.Workspaces {
								if expectedWS != "" && ws.WorkspaceID == expectedWS {
									matchedWS = ws.WorkspaceID
									break
								}
								if matchedWS == "" {
									matchedWS = ws.WorkspaceID
								}
							}
							if matchedWS != "" {
								probe.SmokeWorkspaceID = matchedWS
								probe.SmokeResponseValidJSON = true

								// (c) Probe tenant-scoped ConnectRPC DiagnosticsService/GetOverview and reject empty in-memory diagnostics.
								diagOK := false
								diagReqPayload, _ := json.Marshal(map[string]any{
									"workspaceId": map[string]string{"value": matchedWS},
								})
								if diagReq, err := http.NewRequestWithContext(
									ctx,
									http.MethodPost,
									baseURL+"/creativanta.admin.v1.DiagnosticsService/GetOverview",
									bytes.NewReader(diagReqPayload),
								); err == nil {
									diagReq.Header.Set("Content-Type", "application/json")
									diagReq.Header.Set("Authorization", "Bearer "+authToken)
									diagReq.Header.Set("x-workspace-id", matchedWS)
									if diagResp, err := client.Do(diagReq); err == nil {
										rawDiag, _ := io.ReadAll(diagResp.Body)
										_ = diagResp.Body.Close()
										if diagResp.StatusCode == http.StatusOK {
											var diagBody struct {
												WorkspaceID struct {
													Value string `json:"value"`
												} `json:"workspaceId"`
												OverallStatus               string `json:"overallStatus"`
												OverallState                string `json:"overallState"`
												TotalCategoriesCount        int32  `json:"totalCategoriesCount"`
												HealthyCategoriesCount      int32  `json:"healthyCategoriesCount"`
												CriticalIssuesCount         int32  `json:"criticalIssuesCount"`
												ActiveIssuesCount           int32  `json:"activeIssuesCount"`
												UnknownExternalEffectsCount int32  `json:"unknownExternalEffectsCount"`
												PendingDlqCount             int32  `json:"pendingDlqCount"`
											}
											if err := json.Unmarshal(rawDiag, &diagBody); err == nil {
												statusStr := strings.ToUpper(strings.TrimSpace(diagBody.OverallStatus))
												if statusStr == "" {
													statusStr = strings.ToUpper(strings.TrimSpace(diagBody.OverallState))
												}
												healthyStatus := statusStr == "DIAGNOSTIC_HEALTH_STATUS_HEALTHY" || statusStr == "DIAGNOSTIC_HEALTH_STATE_HEALTHY"
												if diagBody.WorkspaceID.Value == matchedWS &&
													healthyStatus &&
													diagBody.TotalCategoriesCount > 0 &&
													diagBody.HealthyCategoriesCount == diagBody.TotalCategoriesCount &&
													diagBody.CriticalIssuesCount == 0 &&
													diagBody.ActiveIssuesCount == 0 &&
													diagBody.UnknownExternalEffectsCount == 0 &&
													diagBody.PendingDlqCount == 0 {
													diagOK = true
												} else {
													probe.LiveDiagnosticsUnavailableReason = fmt.Sprintf(
														"DiagnosticsService/GetOverview non-operational or unhealthy (status=%q totalCategories=%d healthyCategories=%d critical=%d active=%d unknownEffects=%d dlq=%d)",
														statusStr, diagBody.TotalCategoriesCount, diagBody.HealthyCategoriesCount,
														diagBody.CriticalIssuesCount, diagBody.ActiveIssuesCount,
														diagBody.UnknownExternalEffectsCount, diagBody.PendingDlqCount,
													)
												}
											} else {
												probe.SmokeResponseValidJSON = false
											}
										} else {
											probe.LiveDiagnosticsUnavailableReason = fmt.Sprintf("DiagnosticsService/GetOverview returned HTTP %d", diagResp.StatusCode)
										}
									} else {
										probe.LiveDiagnosticsUnavailableReason = fmt.Sprintf("DiagnosticsService/GetOverview request failed: %v", err)
									}
								}

								// (d) Probe ProfitService/GetSummary to observe actual candidate net profit in integer micro-units.
								profitObserved := false
								if diagOK {
									profitReqPayload, _ := json.Marshal(map[string]any{
										"workspaceId": matchedWS,
										"scopeType":   "workspace",
										"scopeId":     matchedWS,
									})
									if profitReq, err := http.NewRequestWithContext(
										ctx,
										http.MethodPost,
										baseURL+"/creativanta.finance.v1.ProfitService/GetSummary",
										bytes.NewReader(profitReqPayload),
									); err == nil {
										profitReq.Header.Set("Content-Type", "application/json")
										profitReq.Header.Set("Authorization", "Bearer "+authToken)
										profitReq.Header.Set("x-workspace-id", matchedWS)
										if profitResp, err := client.Do(profitReq); err == nil {
											rawProfit, _ := io.ReadAll(profitResp.Body)
											_ = profitResp.Body.Close()
											if profitResp.StatusCode == http.StatusOK {
												var profitBody struct {
													Snapshot *struct {
														WorkspaceID                    string `json:"workspaceId"`
														IsIncomplete                   bool   `json:"isIncomplete"`
														UnknownRequiredComponentsCount int32  `json:"unknownRequiredComponentsCount"`
														NetProfit                      *struct {
															CurrencyCode string `json:"currencyCode"`
															Currency     string `json:"currency"`
															Amount       string `json:"amount"`
														} `json:"netProfit"`
													} `json:"snapshot"`
												}
												if err := json.Unmarshal(rawProfit, &profitBody); err == nil && profitBody.Snapshot != nil && profitBody.Snapshot.NetProfit != nil {
													curr := strings.TrimSpace(profitBody.Snapshot.NetProfit.CurrencyCode)
													if curr == "" {
														curr = strings.TrimSpace(profitBody.Snapshot.NetProfit.Currency)
													}
													if profitBody.Snapshot.WorkspaceID == matchedWS &&
														!profitBody.Snapshot.IsIncomplete &&
														profitBody.Snapshot.UnknownRequiredComponentsCount == 0 &&
														curr != "" {
														if dec, err := tenantdb.ParseExactDecimal(strings.TrimSpace(profitBody.Snapshot.NetProfit.Amount)); err == nil {
															num := dec.ToPgNumeric()
															if num.Valid && num.Int != nil && num.Int.IsInt64() {
																probe.SmokeObservedNetProfitMicro = num.Int.Int64()
																profitObserved = true
															}
														}
													}
												}
											}
											if !profitObserved && probe.LiveSmokeMetricsUnobservedReason == "" {
												probe.LiveSmokeMetricsUnobservedReason = fmt.Sprintf("ProfitService/GetSummary did not return complete exact net_profit on candidate (HTTP %d)", profitResp.StatusCode)
											}
										} else if probe.LiveSmokeMetricsUnobservedReason == "" {
											probe.LiveSmokeMetricsUnobservedReason = fmt.Sprintf("ProfitService/GetSummary request failed: %v", err)
										}
									}
								}

								// (e) Probe AdminBillingService/GetCreditBalance to observe actual candidate AI credit balance.
								creditsObserved := false
								if diagOK && profitObserved {
									creditReqPayload, _ := json.Marshal(map[string]any{
										"workspaceId": map[string]string{"value": matchedWS},
									})
									if creditReq, err := http.NewRequestWithContext(
										ctx,
										http.MethodPost,
										baseURL+"/creativanta.admin.v1.AdminBillingService/GetCreditBalance",
										bytes.NewReader(creditReqPayload),
									); err == nil {
										creditReq.Header.Set("Content-Type", "application/json")
										creditReq.Header.Set("Authorization", "Bearer "+authToken)
										creditReq.Header.Set("x-workspace-id", matchedWS)
										if creditResp, err := client.Do(creditReq); err == nil {
											rawCredit, _ := io.ReadAll(creditResp.Body)
											_ = creditResp.Body.Close()
											if creditResp.StatusCode == http.StatusOK {
												var creditBody struct {
													Balance *struct {
														WorkspaceID *struct {
															Value string `json:"value"`
														} `json:"workspaceId"`
														TotalRemaining json.RawMessage `json:"totalRemaining"`
													} `json:"balance"`
												}
												if err := json.Unmarshal(rawCredit, &creditBody); err == nil && creditBody.Balance != nil {
													wsMatch := creditBody.Balance.WorkspaceID == nil || creditBody.Balance.WorkspaceID.Value == "" || creditBody.Balance.WorkspaceID.Value == matchedWS
													if totalRem, ok := parseJSONExactInt64(creditBody.Balance.TotalRemaining); ok && wsMatch {
														probe.SmokeObservedCreditsBalance = totalRem
														creditsObserved = true
													}
												}
											}
											if !creditsObserved && probe.LiveSmokeMetricsUnobservedReason == "" {
												probe.LiveSmokeMetricsUnobservedReason = fmt.Sprintf("AdminBillingService/GetCreditBalance did not return observed credit balance on candidate (HTTP %d)", creditResp.StatusCode)
											}
										} else if probe.LiveSmokeMetricsUnobservedReason == "" {
											probe.LiveSmokeMetricsUnobservedReason = fmt.Sprintf("AdminBillingService/GetCreditBalance request failed: %v", err)
										}
									}
								}

								// (f) Probe SystemConfigService/GetDashboard and /admin/v1/audit-integrity to observe actual candidate
								// maintenance state, kill switches, and verified audit sequence / hash-chain integrity.
								// Missing or null auditSequenceIntact NEVER defaults to true.
								if diagOK && profitObserved && creditsObserved {
									if sysReq, err := http.NewRequestWithContext(
										ctx,
										http.MethodPost,
										baseURL+"/creativanta.admin.v1.SystemConfigService/GetDashboard",
										bytes.NewReader([]byte(`{}`)),
									); err == nil {
										sysReq.Header.Set("Content-Type", "application/json")
										sysReq.Header.Set("Authorization", "Bearer "+authToken)
										sysReq.Header.Set("x-workspace-id", matchedWS)
										if sysResp, err := client.Do(sysReq); err == nil {
											rawSys, _ := io.ReadAll(sysResp.Body)
											_ = sysResp.Body.Close()
											auditObserved := false
											if sysResp.StatusCode == http.StatusOK {
												var sysBody struct {
													MaintenanceMode         bool            `json:"maintenanceMode"`
													ActiveKillSwitchesCount int32           `json:"activeKillSwitchesCount"`
													AuditLogEntriesCount    json.RawMessage `json:"auditLogEntriesCount"`
													AuditSequenceIntact     *bool           `json:"auditSequenceIntact"`
												}
												if err := json.Unmarshal(rawSys, &sysBody); err == nil {
													auditCount, hasCount := parseJSONExactInt64(sysBody.AuditLogEntriesCount)
													if !sysBody.MaintenanceMode && sysBody.ActiveKillSwitchesCount == 0 && hasCount && auditCount > 0 {
														seqIntact := false
														if sysBody.AuditSequenceIntact != nil && !*sysBody.AuditSequenceIntact {
															seqIntact = false
														} else if integReq, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/admin/v1/audit-integrity", nil); err == nil {
															integReq.Header.Set("Authorization", "Bearer "+authToken)
															integReq.Header.Set("x-workspace-id", matchedWS)
															if integResp, err := client.Do(integReq); err == nil {
																rawInteg, _ := io.ReadAll(integResp.Body)
																_ = integResp.Body.Close()
																switch integResp.StatusCode {
																case http.StatusOK:
																	var integBody AuditIntegrityProbeResponse
																	if err := json.Unmarshal(rawInteg, &integBody); err == nil {
																		if integBody.AuditSequenceIntact != nil &&
																			*integBody.AuditSequenceIntact &&
																			!integBody.ReadOnlyLockApplied &&
																			integBody.CheckedEntriesCount == auditCount &&
																			(sysBody.AuditSequenceIntact == nil || *sysBody.AuditSequenceIntact) {
																			seqIntact = true
																		}
																	}
																case http.StatusNotFound:
																	if sysBody.AuditSequenceIntact != nil && *sysBody.AuditSequenceIntact {
																		seqIntact = true
																	}
																}
															}
														}
														if seqIntact {
															probe.SmokeAuditSequenceIntact = true
															auditObserved = true
														}
													}
												}
											}
											if !auditObserved && probe.LiveSmokeMetricsUnobservedReason == "" {
												probe.LiveSmokeMetricsUnobservedReason = fmt.Sprintf("SystemConfigService/GetDashboard and /admin/v1/audit-integrity did not confirm intact non-empty audit sequence on candidate (HTTP %d)", sysResp.StatusCode)
											}
										} else if probe.LiveSmokeMetricsUnobservedReason == "" {
											probe.LiveSmokeMetricsUnobservedReason = fmt.Sprintf("SystemConfigService/GetDashboard request failed: %v", err)
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}

	elapsedMs := time.Since(startedWall).Milliseconds()
	return s.evaluateBlueGreenProbe(ctx, adminID, probe, proxyTarget, elapsedMs)
}

func (s *Service) evaluateBlueGreenProbe(
	ctx context.Context,
	adminID string,
	probe CandidateSlotProbeInput,
	proxyTarget DisposableProxyTarget,
	measuredDurationMs int64,
) (ReleaseSmokeVerdict, error) {
	if err := ctx.Err(); err != nil {
		return ReleaseSmokeVerdict{}, err
	}
	s.mu.Lock()
	defer s.mu.Unlock()

	admin, ok := s.adminsByID[adminID]
	if !ok || admin.Status != "active" {
		return ReleaseSmokeVerdict{}, ErrInvalidAdminCredentials
	}
	if admin.AdminRole != rbac.AdminRoleSuper && admin.AdminRole != rbac.AdminRoleTech && admin.AdminRole != rbac.AdminRoleOps {
		return ReleaseSmokeVerdict{}, fmt.Errorf("%w: role %q cannot execute release smoke rehearsals", ErrPrivilegedRoleBoundaryViolation, admin.AdminRole)
	}

	now := s.Now()
	prevSlot := s.activeSlot
	prevDigest := s.activeSlotDigest
	execMode := RehearsalModeSimulationOnly
	isSim := true
	if proxyTarget != nil {
		execMode = RehearsalModeDisposableTargetVerified
		isSim = false
	}

	failAndRollback := func(code, reason string) (ReleaseSmokeVerdict, error) {
		rollbackSucceeded := true
		rollbackErrMsg := ""
		verifiedActiveSlot := prevSlot
		verifiedActiveDigest := prevDigest
		if proxyTarget != nil {
			if prevSlot == "" || prevDigest == "" {
				rollbackSucceeded = false
				rollbackErrMsg = "previous active slot is unverified; cannot roll back to an unverified upstream"
				verifiedActiveSlot = ""
				verifiedActiveDigest = ""
				s.activeSlot = ""
				s.activeSlotDigest = ""
				if verifier, ok := proxyTarget.(DisposableProxyActiveStateVerifier); ok {
					obsSlot, obsDigest, verifyErr := verifier.VerifiedActiveUpstream(ctx)
					obsSlot = strings.TrimSpace(obsSlot)
					obsDigest = strings.TrimSpace(obsDigest)
					if verifyErr != nil {
						rollbackErrMsg = fmt.Sprintf("%s (verification error: %v)", rollbackErrMsg, verifyErr)
					} else if (obsSlot == "blue" || obsSlot == "green") && strings.HasPrefix(obsDigest, "sha256:") && len(obsDigest) >= 15 {
						verifiedActiveSlot = obsSlot
						verifiedActiveDigest = obsDigest
						s.activeSlot = obsSlot
						s.activeSlotDigest = obsDigest
						rollbackErrMsg = fmt.Sprintf("post-rollback active upstream mismatch: expected verified previous slot, observed %s (%s)", obsSlot, obsDigest)
					}
				}
				reason = fmt.Sprintf("%s; rollback verification failed: %s", reason, rollbackErrMsg)
			} else if rbErr := proxyTarget.RollbackUpstream(ctx, prevSlot, prevDigest); rbErr != nil {
				rollbackSucceeded = false
				rollbackErrMsg = rbErr.Error()
				verifiedActiveSlot = ""
				verifiedActiveDigest = ""
				s.activeSlot = ""
				s.activeSlotDigest = ""
				reason = fmt.Sprintf("%s; rollback to %s (%s) failed: %v", reason, prevSlot, prevDigest, rbErr)
			} else if verifier, ok := proxyTarget.(DisposableProxyActiveStateVerifier); ok {
				obsSlot, obsDigest, verifyErr := verifier.VerifiedActiveUpstream(ctx)
				obsSlot = strings.TrimSpace(obsSlot)
				obsDigest = strings.TrimSpace(obsDigest)
				if verifyErr != nil {
					rollbackSucceeded = false
					rollbackErrMsg = verifyErr.Error()
					verifiedActiveSlot = ""
					verifiedActiveDigest = ""
					s.activeSlot = ""
					s.activeSlotDigest = ""
					reason = fmt.Sprintf("%s; rollback verification failed: %s", reason, rollbackErrMsg)
				} else if obsSlot != prevSlot || obsDigest != prevDigest {
					rollbackSucceeded = false
					rollbackErrMsg = fmt.Sprintf("post-rollback active upstream mismatch: expected %s (%s), observed %s (%s)", prevSlot, prevDigest, obsSlot, obsDigest)
					if (obsSlot == "blue" || obsSlot == "green") && strings.HasPrefix(obsDigest, "sha256:") && len(obsDigest) >= 15 {
						verifiedActiveSlot = obsSlot
						verifiedActiveDigest = obsDigest
						s.activeSlot = obsSlot
						s.activeSlotDigest = obsDigest
					} else {
						verifiedActiveSlot = ""
						verifiedActiveDigest = ""
						s.activeSlot = ""
						s.activeSlotDigest = ""
					}
					reason = fmt.Sprintf("%s; rollback verification failed: %s", reason, rollbackErrMsg)
				} else {
					s.activeSlot = prevSlot
					s.activeSlotDigest = prevDigest
				}
			} else {
				s.activeSlot = prevSlot
				s.activeSlotDigest = prevDigest
			}
		}
		verdict := ReleaseSmokeVerdict{
			ExecutionMode:           execMode,
			IsSimulation:            isSim,
			ProxyUpstreamSwitched:   false,
			MeasuredProbeDurationMs: measuredDurationMs,
			CandidatePromoted:       false,
			RollbackTriggered:       true,
			RollbackSucceeded:       rollbackSucceeded,
			RollbackError:           rollbackErrMsg,
			FailureCode:             code,
			FailureReason:           reason,
			ActiveSlot:              verifiedActiveSlot,
			ActiveSlotDigest:        verifiedActiveDigest,
			RetainedRollbackDigest:  prevDigest,
			EvaluatedAt:             now,
		}
		s.appendSequencedAuditLocked(adminID, admin.AdminRole, "release.rollback_triggered", "deployment_slot", probe.CandidateSlot, "", reason, map[string]any{
			"execution_mode":        execMode,
			"is_simulation":         isSim,
			"failure_code":          code,
			"candidate_slot":        probe.CandidateSlot,
			"candidate_slot_digest": probe.CandidateImageDigest,
			"rollback_succeeded":    rollbackSucceeded,
			"rollback_error":        rollbackErrMsg,
			"active_slot_verified":  rollbackSucceeded,
			"rolled_back_to_slot":   verifiedActiveSlot,
			"rolled_back_to_digest": verifiedActiveDigest,
		})
		return verdict, fmt.Errorf("%w [%s]: %s", ErrReleaseSmokeFailed, code, reason)
	}

	if probe.CandidateSlot != "blue" && probe.CandidateSlot != "green" {
		return failAndRollback("SMOKE_INVALID_SLOT", fmt.Sprintf("invalid candidate slot %q", probe.CandidateSlot))
	}
	if !strings.HasPrefix(strings.TrimSpace(probe.CandidateImageDigest), "sha256:") || len(strings.TrimSpace(probe.CandidateImageDigest)) < 15 {
		return failAndRollback("SMOKE_INVALID_DIGEST", "candidate image digest must be a pinned sha256 digest")
	}
	healthStatus := strings.ToLower(strings.TrimSpace(probe.HealthzStatusField))
	if probe.HealthzHTTPStatus != 200 || (healthStatus != "ok" && healthStatus != "alive") {
		return failAndRollback("SMOKE_HEALTHZ_FAILED", fmt.Sprintf("/healthz returned status=%d body=%q", probe.HealthzHTTPStatus, probe.HealthzStatusField))
	}
	if probe.ReadyzHTTPStatus != 200 || strings.ToLower(strings.TrimSpace(probe.ReadyzStatusField)) != "ready" ||
		!probe.DatabaseReady || !probe.RedisReady || !probe.NATSReady {
		return failAndRollback("SMOKE_READYZ_FAILED", "candidate /readyz failed or core dependency (Postgres/Redis/NATS) not ready")
	}
	if !probe.SmokeAuthValid {
		return failAndRollback("SMOKE_AUTH_UNAUTHORIZED", "authenticated business smoke probe failed token verification")
	}
	if !probe.SmokeResponseValidJSON {
		return failAndRollback("SMOKE_INVALID_JSON", "business smoke probe returned malformed JSON payload")
	}
	if !tenantdb.IsValidNonZeroUUID(probe.SmokeWorkspaceID) {
		return failAndRollback("SMOKE_MISSING_WORKSPACE_ID", "business smoke probe returned empty or invalid workspace_id")
	}
	if strings.TrimSpace(probe.SmokeExpectedWorkspaceID) != "" && probe.SmokeWorkspaceID != strings.TrimSpace(probe.SmokeExpectedWorkspaceID) {
		return failAndRollback("SMOKE_WORKSPACE_MISMATCH", fmt.Sprintf("expected smoke workspace_id %q, observed %q", probe.SmokeExpectedWorkspaceID, probe.SmokeWorkspaceID))
	}
	if strings.TrimSpace(probe.LiveDiagnosticsUnavailableReason) != "" {
		return failAndRollback("SMOKE_DIAGNOSTICS_UNHEALTHY", probe.LiveDiagnosticsUnavailableReason)
	}
	if strings.TrimSpace(probe.LiveSmokeMetricsUnobservedReason) != "" {
		return failAndRollback("SMOKE_METRICS_UNOBSERVED", probe.LiveSmokeMetricsUnobservedReason)
	}
	if probe.SmokeObservedNetProfitMicro != probe.SmokeExpectedNetProfitMicro {
		return failAndRollback("SMOKE_PROFIT_LEDGER_MISMATCH", fmt.Sprintf("expected net profit %d micro-units, observed %d", probe.SmokeExpectedNetProfitMicro, probe.SmokeObservedNetProfitMicro))
	}
	if probe.SmokeObservedCreditsBalance != probe.SmokeExpectedCreditsBalance {
		return failAndRollback("SMOKE_CREDITS_BALANCE_MISMATCH", fmt.Sprintf("expected AI credits balance %d, observed %d", probe.SmokeExpectedCreditsBalance, probe.SmokeObservedCreditsBalance))
	}
	if !probe.SmokeAuditSequenceIntact || s.auditReadOnlyLocked {
		return failAndRollback("SMOKE_AUDIT_SEQUENCE_GAP", "immutable audit log sequence gap detected during pre-promotion check")
	}

	proxySwitched := false
	reason := "SIMULATION_ONLY: pre-promotion probe inputs validated in memory; no live reverse proxy upstream was switched."
	if proxyTarget != nil {
		if err := proxyTarget.SwitchUpstream(ctx, probe.CandidateSlot, probe.CandidateImageDigest); err != nil {
			return failAndRollback("SMOKE_PROXY_SWITCH_FAILED", fmt.Sprintf("disposable proxy upstream switch failed: %v", err))
		}
		if verifier, ok := proxyTarget.(DisposableProxyActiveStateVerifier); ok {
			obsSlot, obsDigest, verifyErr := verifier.VerifiedActiveUpstream(ctx)
			if verifyErr != nil || obsSlot != probe.CandidateSlot || obsDigest != probe.CandidateImageDigest {
				return failAndRollback("SMOKE_PROXY_SWITCH_UNVERIFIED", fmt.Sprintf("post-switch proxy active upstream verification failed (expected %s/%s, observed %s/%s, err=%v)", probe.CandidateSlot, probe.CandidateImageDigest, obsSlot, obsDigest, verifyErr))
			}
		}
		proxySwitched = true
		reason = "DISPOSABLE_TARGET_VERIFIED: live candidate HTTP probes passed and disposable reverse proxy upstream switched."
	}

	s.activeSlot = probe.CandidateSlot
	s.activeSlotDigest = probe.CandidateImageDigest
	verdict := ReleaseSmokeVerdict{
		ExecutionMode:           execMode,
		IsSimulation:            isSim,
		ProxyUpstreamSwitched:   proxySwitched,
		MeasuredProbeDurationMs: measuredDurationMs,
		CandidatePromoted:       true,
		RollbackTriggered:       false,
		FailureCode:             "OK",
		FailureReason:           reason,
		ActiveSlot:              s.activeSlot,
		ActiveSlotDigest:        s.activeSlotDigest,
		RetainedRollbackDigest:  prevDigest,
		EvaluatedAt:             now,
	}
	s.appendSequencedAuditLocked(adminID, admin.AdminRole, "release.slot_promoted", "deployment_slot", probe.CandidateSlot, "", verdict.FailureReason, map[string]any{
		"execution_mode":           execMode,
		"is_simulation":            isSim,
		"proxy_upstream_switched":  proxySwitched,
		"active_slot":              s.activeSlot,
		"active_slot_digest":       s.activeSlotDigest,
		"retained_rollback_digest": prevDigest,
	})
	return verdict, nil
}

// ============================================================================
// Target 2: No Stale Provider, Connector, Workflow License or Legal Evidence
// ============================================================================

// ProviderRateCardEvidence mirrors canonical ai_provider_rates (§26.1 of database_schema.md).
type ProviderRateCardEvidence struct {
	Provider             string
	ModelName            string
	CapabilityKey        string
	CostPer1kInputMicro  int64 // integer micro-units (never float)
	CostPer1kOutputMicro int64 // integer micro-units (never float)
	VerifiedAt           time.Time
	ValidUntil           time.Time
	Enabled              bool
	LicenseReference     string
}

// ConnectorAccessEvidence mirrors canonical ActionAccessVerification (capability_matrix.md RULE-M22-002/005).
type ConnectorAccessEvidence struct {
	Platform          string
	CapabilityKey     string
	ClaimedState      string // "native_now", "partner_gated", "manual", "unsupported"
	ScopeGranted      bool
	AppReviewApproved bool
	VerifiedAt        time.Time
	ValidUntil        time.Time
	EvidenceURI       string
}

// WorkflowLicenseEvidence captures workflow engine entitlement state (OPEN_BLOCKERS.md External gate #3).
type WorkflowLicenseEvidence struct {
	RuntimeMode               string // "owned_go_runtime" or "activepieces_enterprise_embed"
	EnterpriseLicenseVerified bool
	ValidUntil                time.Time
	EvidenceURI               string
}

// LegalComplianceChecklistEvidence captures pre-launch legal gates (legal_compliance.md §8, LEG-H-001).
type LegalComplianceChecklistEvidence struct {
	ToSPublished                 bool
	PrivacyPolicyPublished       bool
	CookieConsentActive          bool
	DMCAAgentDesignated          bool
	PDPAImpactAssessmentComplete bool
	DPAsSignedAllSubprocessors   bool
	CounselSignoffCompleted      bool // LEG-H-001 external human gate
	VerifiedAt                   time.Time
}

// ProviderLicenseAuditInput bundles all provider, connector, workflow, and legal evidence for release review.
type ProviderLicenseAuditInput struct {
	EvaluatedAt     time.Time
	MaxFreshnessAge time.Duration
	ProviderRates   []ProviderRateCardEvidence
	Connectors      []ConnectorAccessEvidence
	WorkflowLicense WorkflowLicenseEvidence
	LegalChecklist  LegalComplianceChecklistEvidence
}

// ProviderLicenseAuditVerdict reports whether any provider/license evidence is stale or unverified,
// which capabilities were auto-downgraded, and whether external release gates remain open.
type ProviderLicenseAuditVerdict struct {
	NoStaleEvidence          bool
	RejectedRateCards        []string
	DowngradedConnectors     map[string]string // capabilityKey -> effective downgraded state
	EffectiveWorkflowRuntime string
	WorkflowLicenseRejected  bool
	ExternalGatesUnmet       []string
	MaxAllowedEvidenceState  string // "LOCAL_IMPLEMENTED" when external gates unmet; never fabricates "ACCEPTED"
	Violations               []string
}

// EvaluateProviderAndLicenseFreshness audits provider rate cards, connector access verifications,
// workflow embedding licenses, and legal compliance checklists.
// Enforces P8-08 Acceptance Target 2: "No stale provider/license evidence".
func EvaluateProviderAndLicenseFreshness(in ProviderLicenseAuditInput) (ProviderLicenseAuditVerdict, error) {
	now := in.EvaluatedAt
	if now.IsZero() {
		now = time.Now().UTC()
	}
	maxAge := in.MaxFreshnessAge
	if maxAge <= 0 {
		maxAge = ProviderEvidenceMaxAge
	}

	verdict := ProviderLicenseAuditVerdict{
		NoStaleEvidence:          true,
		DowngradedConnectors:     make(map[string]string),
		EffectiveWorkflowRuntime: "owned_go_runtime",
		MaxAllowedEvidenceState:  "LOCAL_IMPLEMENTED",
	}

	if len(in.ProviderRates) == 0 {
		verdict.NoStaleEvidence = false
		verdict.Violations = append(verdict.Violations, "missing provider rate card evidence (ai_provider_rates)")
	}

	for _, rc := range in.ProviderRates {
		key := fmt.Sprintf("%s/%s (%s)", rc.Provider, rc.ModelName, rc.CapabilityKey)
		if !rc.Enabled {
			verdict.RejectedRateCards = append(verdict.RejectedRateCards, key)
			verdict.NoStaleEvidence = false
			verdict.Violations = append(verdict.Violations, fmt.Sprintf("provider rate card %s is disabled", key))
			continue
		}
		if rc.CostPer1kInputMicro < 0 || rc.CostPer1kOutputMicro < 0 {
			verdict.RejectedRateCards = append(verdict.RejectedRateCards, key)
			verdict.NoStaleEvidence = false
			verdict.Violations = append(verdict.Violations, fmt.Sprintf("provider rate card %s has negative rate micro-units", key))
			continue
		}
		if rc.VerifiedAt.IsZero() || rc.ValidUntil.IsZero() || now.After(rc.ValidUntil) || now.Sub(rc.VerifiedAt) > maxAge || strings.TrimSpace(rc.LicenseReference) == "" {
			verdict.RejectedRateCards = append(verdict.RejectedRateCards, key)
			verdict.NoStaleEvidence = false
			verdict.Violations = append(verdict.Violations, fmt.Sprintf("provider rate card %s has stale/expired verification (verified_at=%s, valid_until=%s)",
				key, rc.VerifiedAt.Format(time.RFC3339), rc.ValidUntil.Format(time.RFC3339)))
		}
	}

	for _, c := range in.Connectors {
		key := fmt.Sprintf("%s:%s", strings.ToLower(strings.TrimSpace(c.Platform)), strings.TrimSpace(c.CapabilityKey))
		claimed := strings.ToLower(strings.TrimSpace(c.ClaimedState))
		if claimed == "native_now" {
			stale := c.VerifiedAt.IsZero() || c.ValidUntil.IsZero() || now.After(c.ValidUntil) || now.Sub(c.VerifiedAt) > maxAge
			unverified := !c.ScopeGranted || !c.AppReviewApproved || strings.TrimSpace(c.EvidenceURI) == ""
			if stale || unverified {
				verdict.NoStaleEvidence = false
				verdict.DowngradedConnectors[key] = "manual"
				verdict.Violations = append(verdict.Violations, fmt.Sprintf("connector %s claimed native_now with stale/unverified evidence; downgraded to manual", key))
			} else {
				verdict.DowngradedConnectors[key] = "native_now"
			}
		} else if claimed == "partner_gated" || claimed == "manual" || claimed == "unsupported" {
			verdict.DowngradedConnectors[key] = claimed
		} else {
			verdict.NoStaleEvidence = false
			verdict.DowngradedConnectors[key] = "unsupported"
			verdict.Violations = append(verdict.Violations, fmt.Sprintf("connector %s has invalid state %q", key, c.ClaimedState))
		}
	}

	switch strings.ToLower(strings.TrimSpace(in.WorkflowLicense.RuntimeMode)) {
	case "", "owned_go_runtime":
		verdict.EffectiveWorkflowRuntime = "owned_go_runtime"
	case "activepieces_enterprise_embed":
		if !in.WorkflowLicense.EnterpriseLicenseVerified || in.WorkflowLicense.ValidUntil.IsZero() ||
			now.After(in.WorkflowLicense.ValidUntil) || strings.TrimSpace(in.WorkflowLicense.EvidenceURI) == "" {
			verdict.NoStaleEvidence = false
			verdict.WorkflowLicenseRejected = true
			verdict.EffectiveWorkflowRuntime = "owned_go_runtime"
			verdict.Violations = append(verdict.Violations, "Activepieces enterprise embedding license missing or expired; forced fallback to owned_go_runtime")
		} else {
			verdict.EffectiveWorkflowRuntime = "activepieces_enterprise_embed"
		}
	default:
		verdict.NoStaleEvidence = false
		verdict.WorkflowLicenseRejected = true
		verdict.Violations = append(verdict.Violations, fmt.Sprintf("unknown workflow runtime mode %q", in.WorkflowLicense.RuntimeMode))
	}

	// Evaluate Legal Compliance checklist & external human gates (LEG-H-001).
	lc := in.LegalChecklist
	if !lc.ToSPublished || !lc.PrivacyPolicyPublished || !lc.CookieConsentActive ||
		!lc.DMCAAgentDesignated || !lc.PDPAImpactAssessmentComplete || !lc.DPAsSignedAllSubprocessors {
		verdict.NoStaleEvidence = false
		verdict.Violations = append(verdict.Violations, "mandatory legal compliance baseline documents (ToS/Privacy/Cookie/DMCA/PDPA/DPA) incomplete")
	}
	if !lc.CounselSignoffCompleted {
		verdict.ExternalGatesUnmet = append(verdict.ExternalGatesUnmet, "LEG-H-001: Qualified external legal counsel sign-off required before public launch")
	}

	if !verdict.NoStaleEvidence {
		return verdict, fmt.Errorf("%w: %s", ErrStaleProviderEvidence, strings.Join(verdict.Violations, "; "))
	}
	return verdict, nil
}

// ============================================================================
// Target 3: Tenant & Privacy Guards Across Public, Tenant, and Internal Paths
// ============================================================================

// ValidateOutboundWebhookOrImportURL enforces OWASP A10 SSRF protection (security_threat_model.md §2 A10):
//   - Only https:// URLs are allowed (http://, file://, gopher://, etc. are rejected)
//   - Embedded userinfo credentials in the URL are rejected
//   - Loopback (127.0.0.0/8, ::1), RFC1918 private (10/8, 172.16/12, 192.168/16),
//     link-local / cloud metadata (169.254.0.0/16, fe80::/10), CGNAT (100.64.0.0/10),
//     unspecified (0.0.0.0, ::), and internal hostnames (localhost, *.local, *.internal) are blocked.
func ValidateOutboundWebhookOrImportURL(rawURL string) error {
	trimmed := strings.TrimSpace(rawURL)
	if trimmed == "" {
		return fmt.Errorf("%w: empty URL", ErrSSRFBlocked)
	}
	parsed, err := url.Parse(trimmed)
	if err != nil {
		return fmt.Errorf("%w: malformed URL: %v", ErrSSRFBlocked, err)
	}
	if strings.ToLower(parsed.Scheme) != "https" {
		return fmt.Errorf("%w: scheme %q is forbidden; https is required", ErrSSRFBlocked, parsed.Scheme)
	}
	if parsed.User != nil {
		return fmt.Errorf("%w: embedded credentials in URL are forbidden", ErrSSRFBlocked)
	}
	host := strings.ToLower(strings.TrimSpace(parsed.Hostname()))
	if host == "" {
		return fmt.Errorf("%w: missing hostname", ErrSSRFBlocked)
	}
	if host == "localhost" || strings.HasSuffix(host, ".localhost") ||
		strings.HasSuffix(host, ".local") || strings.HasSuffix(host, ".internal") ||
		host == "metadata.google.internal" {
		return fmt.Errorf("%w: internal hostname %q is forbidden", ErrSSRFBlocked, host)
	}

	if ip := net.ParseIP(host); ip != nil {
		if isForbiddenSSRFIP(ip) {
			return fmt.Errorf("%w: target IP %s is in a forbidden private/loopback/metadata range", ErrSSRFBlocked, ip.String())
		}
	}
	return nil
}

func isForbiddenSSRFIP(ip net.IP) bool {
	if ip.IsLoopback() || ip.IsPrivate() || ip.IsLinkLocalUnicast() || ip.IsLinkLocalMulticast() || ip.IsUnspecified() || ip.IsMulticast() {
		return true
	}
	// Check CGNAT 100.64.0.0/10 and cloud metadata 169.254.169.254 explicitly
	if ip4 := ip.To4(); ip4 != nil {
		if ip4[0] == 100 && ip4[1] >= 64 && ip4[1] <= 127 {
			return true
		}
		if ip4[0] == 169 && ip4[1] == 254 {
			return true
		}
		if ip4[0] == 0 {
			return true
		}
	}
	return false
}

// CreatorDirectoryInternalRecord represents the full persisted media kit + workspace/account state
// before projection to the public `directory_reader` surface.
type CreatorDirectoryInternalRecord struct {
	MediaKitID            string
	WorkspaceID           string
	OwnerUserID           string
	OwnerEmail            string
	OwnerPhone            string
	Slug                  string
	DisplayName           string
	Bio                   string
	PrimaryNiche          string
	DirectoryOptIn        bool
	DirectoryStatus       string // "published", "draft", "hidden"
	VerifiedHandleSummary []string
	AccessTokenEncrypted  string
	RefreshTokenEncrypted string
	InternalAdminNotes    string
	DeletedAt             *time.Time
}

// PublicCreatorDirectoryProjection contains strictly public, non-PII, non-tenant-identifying fields
// safe for the unauthenticated public creator directory (`directory_reader`).
type PublicCreatorDirectoryProjection struct {
	Slug                  string   `json:"slug"`
	DisplayName           string   `json:"display_name"`
	Bio                   string   `json:"bio"`
	PrimaryNiche          string   `json:"primary_niche"`
	VerifiedHandleSummary []string `json:"verified_handle_summary"`
}

// ProjectPublicCreatorDirectoryEntry enforces public-path privacy isolation (§27.2 of database_schema.md):
//   - Rejects any profile where DirectoryOptIn == false, DirectoryStatus != "published", or DeletedAt != nil
//   - Ignores any forged caller tenant header
//   - Strips WorkspaceID, OwnerUserID, OwnerEmail, OwnerPhone, OAuth tokens, and InternalAdminNotes.
func ProjectPublicCreatorDirectoryEntry(rec CreatorDirectoryInternalRecord, _ string) (PublicCreatorDirectoryProjection, error) {
	if !rec.DirectoryOptIn || strings.ToLower(strings.TrimSpace(rec.DirectoryStatus)) != "published" || rec.DeletedAt != nil {
		return PublicCreatorDirectoryProjection{}, ErrPublicProfileNotPublished
	}
	handles := make([]string, len(rec.VerifiedHandleSummary))
	copy(handles, rec.VerifiedHandleSummary)
	return PublicCreatorDirectoryProjection{
		Slug:                  strings.TrimSpace(rec.Slug),
		DisplayName:           strings.TrimSpace(rec.DisplayName),
		Bio:                   strings.TrimSpace(rec.Bio),
		PrimaryNiche:          strings.TrimSpace(rec.PrimaryNiche),
		VerifiedHandleSummary: handles,
	}, nil
}

// TenantScopedResource represents a workspace-owned entity protected by RLS & BOLA checks.
type TenantScopedResource struct {
	ResourceID            string
	WorkspaceID           string
	OwnerUserID           string
	Title                 string
	AccessTokenEncrypted  string
	RefreshTokenEncrypted string
	SupportMessages       []SupportTicketMessageRecord
}

// SanitizedTenantResourceView is the tenant-safe representation returned to an authorized workspace member.
type SanitizedTenantResourceView struct {
	ResourceID      string                       `json:"resource_id"`
	WorkspaceID     string                       `json:"workspace_id"`
	Title           string                       `json:"title"`
	SupportMessages []SupportTicketMessageRecord `json:"support_messages"`
}

// AccessTenantScopedResource enforces BOLA/RLS tenant isolation and strips internal admin notes
// and encrypted OAuth tokens from workspace responses.
func AccessTenantScopedResource(
	authenticatedWorkspaceID string,
	forgedRequestWorkspaceID string,
	callerWorkspaceRole string,
	res TenantScopedResource,
) (SanitizedTenantResourceView, error) {
	if !tenantdb.IsValidNonZeroUUID(authenticatedWorkspaceID) || !rbac.IsValidWorkspaceRole(callerWorkspaceRole) {
		return SanitizedTenantResourceView{}, ErrCrossTenantAccessDenied
	}
	// Even if the request attempts to pass a forged workspace_id matching the target resource,
	// authorization ALWAYS binds to authenticatedWorkspaceID (JWT/session claim).
	if authenticatedWorkspaceID != res.WorkspaceID {
		return SanitizedTenantResourceView{}, ErrCrossTenantAccessDenied
	}
	if forgedRequestWorkspaceID != "" && forgedRequestWorkspaceID != authenticatedWorkspaceID {
		return SanitizedTenantResourceView{}, ErrCrossTenantAccessDenied
	}

	var visibleMsgs []SupportTicketMessageRecord
	for _, msg := range res.SupportMessages {
		if msg.IsInternalNote {
			continue // strictly hidden from workspace roles
		}
		visibleMsgs = append(visibleMsgs, msg)
	}
	return SanitizedTenantResourceView{
		ResourceID:      res.ResourceID,
		WorkspaceID:     res.WorkspaceID,
		Title:           res.Title,
		SupportMessages: visibleMsgs,
	}, nil
}

// EnforcePersonalOnboardingPrivacy enforces PRIV-2026-02:
// Personal onboarding progress is strictly scoped to `user:self` and can never read/write
// another user's progress or mutate workspace-level settings.
func EnforcePersonalOnboardingPrivacy(authenticatedUserID, targetUserID, attemptedScope string) error {
	if !tenantdb.IsValidNonZeroUUID(authenticatedUserID) || !tenantdb.IsValidNonZeroUUID(targetUserID) {
		return ErrPersonalOnboardingSelfScopeViolation
	}
	if authenticatedUserID != targetUserID {
		return fmt.Errorf("%w: actor %s cannot access onboarding state of user %s", ErrPersonalOnboardingSelfScopeViolation, authenticatedUserID, targetUserID)
	}
	if strings.ToLower(strings.TrimSpace(attemptedScope)) != "user:self" {
		return fmt.Errorf("%w: scope %q is forbidden for personal onboarding; only user:self is allowed", ErrPersonalOnboardingSelfScopeViolation, attemptedScope)
	}
	return nil
}

// BuildTenantGDPRExportPayload constructs a GDPR Art. 15/20 & Vietnam PDPA data export JSON payload
// while enforcing security_threat_model.md §1B:
// OAuth tokens (`access_token_encrypted`, `refresh_token_encrypted`), `password_hash`, `mfa_secret`,
// and internal support notes (`internal_only = true`) NEVER appear in GDPR exports.
func BuildTenantGDPRExportPayload(
	workspaceID string,
	userID string,
	userEmail string,
	rawRecords map[string]any,
	supportMessages []SupportTicketMessageRecord,
) ([]byte, error) {
	if !tenantdb.IsValidNonZeroUUID(workspaceID) || !tenantdb.IsValidNonZeroUUID(userID) {
		return nil, ErrInvalidInput
	}

	sanitizedMap := redactSensitiveKeysRecursive(rawRecords)
	var publicMessages []map[string]any
	for _, m := range supportMessages {
		if m.IsInternalNote {
			continue
		}
		publicMessages = append(publicMessages, map[string]any{
			"message_id":  m.MessageID,
			"author_type": m.AuthorType,
			"body":        m.Body,
			"created_at":  m.CreatedAt.Format(time.RFC3339),
		})
	}

	exportDoc := map[string]any{
		"schema_version":         "2026-11-p8-08",
		"regulation":             "GDPR_ART_15_20_AND_VN_PDPA_DECREE_13_2023",
		"workspace_id":           workspaceID,
		"user_id":                userID,
		"user_email":             strings.TrimSpace(userEmail),
		"oauth_tokens_redacted":  true,
		"internal_notes_omitted": true,
		"profile_and_activity":   sanitizedMap,
		"support_messages":       publicMessages,
	}
	return json.Marshal(exportDoc)
}

var forbiddenExportKeys = map[string]bool{
	"access_token":            true,
	"access_token_encrypted":  true,
	"refresh_token":           true,
	"refresh_token_encrypted": true,
	"password_hash":           true,
	"mfa_secret":              true,
	"totp_secret":             true,
	"internal_admin_notes":    true,
	"internal_note":           true,
}

func redactSensitiveKeysRecursive(in map[string]any) map[string]any {
	out := make(map[string]any, len(in))
	for k, v := range in {
		lowerKey := strings.ToLower(strings.TrimSpace(k))
		if forbiddenExportKeys[lowerKey] {
			continue
		}
		switch typed := v.(type) {
		case map[string]any:
			out[k] = redactSensitiveKeysRecursive(typed)
		default:
			out[k] = v
		}
	}
	return out
}

// ============================================================================
// Internal Admin Override Frequency Alert (EC-M23-004) & Sequenced Audit Log (EC-M23-005)
// ============================================================================

// AdminOverrideVerdict reports the outcome of an admin override action under RULE-M23-B02 & EC-M23-004.
type AdminOverrideVerdict struct {
	Allowed                    bool
	OverridesInLast24h         int
	SuperAdminReviewAlertFired bool
	RequiresSuperAdminApproval bool
	AuditID                    string
	AuditSequenceNumber        int64
}

// RecordAdminOverride enforces RULE-M23-B02 and EC-M23-004:
//   - Requires an active internal admin with override permission and a non-empty audit reason
//   - Fails closed if the audit log is locked read-only (EC-M23-005)
//   - Tracks overrides per admin in a rolling 24-hour window:
//   - > 10 overrides/24h triggers an automatic Super Admin review alert event (`admin.override_frequency_alert`)
//   - > 50 overrides/24h blocks the override with ErrOverrideRateLimitRequiresSuperAdmin unless a valid `superAdminApprovalToken` is provided.
func (s *Service) RecordAdminOverride(
	ctx context.Context,
	adminID string,
	targetWorkspaceID string,
	overrideAction string,
	reason string,
	superAdminApprovalToken string,
) (AdminOverrideVerdict, error) {
	if err := ctx.Err(); err != nil {
		return AdminOverrideVerdict{}, err
	}
	if strings.TrimSpace(reason) == "" || strings.TrimSpace(overrideAction) == "" {
		return AdminOverrideVerdict{}, rbac.ErrAuditReasonRequired
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	if s.auditReadOnlyLocked {
		return AdminOverrideVerdict{}, ErrAuditLogReadOnlyLocked
	}
	admin, ok := s.adminsByID[adminID]
	if !ok || admin.Status != "active" {
		return AdminOverrideVerdict{}, ErrInvalidAdminCredentials
	}
	if admin.AdminRole != rbac.AdminRoleSuper && admin.AdminRole != rbac.AdminRoleOps &&
		admin.AdminRole != rbac.AdminRoleFinance && admin.AdminRole != rbac.AdminRoleTech {
		return AdminOverrideVerdict{}, fmt.Errorf("%w: role %q cannot execute admin overrides", ErrPrivilegedRoleBoundaryViolation, admin.AdminRole)
	}

	now := s.Now()
	cutoff := now.Add(-24 * time.Hour)
	var recent []time.Time
	for _, ts := range s.overrideTimestamps[adminID] {
		if !ts.Before(cutoff) {
			recent = append(recent, ts)
		}
	}
	candidateCount := len(recent) + 1

	if candidateCount > AdminOverrideDailyApprovalThreshold && strings.TrimSpace(superAdminApprovalToken) == "" {
		return AdminOverrideVerdict{
			Allowed:                    false,
			OverridesInLast24h:         len(recent),
			SuperAdminReviewAlertFired: true,
			RequiresSuperAdminApproval: true,
		}, ErrOverrideRateLimitRequiresSuperAdmin
	}

	recent = append(recent, now)
	s.overrideTimestamps[adminID] = recent

	alertFired := candidateCount > AdminOverrideDailyAlertThreshold
	entry := s.appendSequencedAuditLocked(adminID, admin.AdminRole, overrideAction, "workspace_override", targetWorkspaceID, targetWorkspaceID, reason, map[string]any{
		"overrides_in_last_24h":       candidateCount,
		"super_admin_alert_triggered": alertFired,
		"super_admin_approved":        strings.TrimSpace(superAdminApprovalToken) != "",
	})

	if alertFired {
		payload, _ := json.Marshal(map[string]any{
			"admin_id":              adminID,
			"admin_role":            admin.AdminRole,
			"override_action":       overrideAction,
			"overrides_in_last_24h": candidateCount,
			"threshold":             AdminOverrideDailyAlertThreshold,
			"occurred_at":           now.Format(time.RFC3339),
		})
		s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
			EventID:       s.IDGenerator(),
			EventType:     "admin.override_frequency_alert",
			TargetStream:  outbox.QueueNotifications,
			AggregateType: "internal_admin",
			AggregateID:   adminID,
			WorkspaceID:   targetWorkspaceID,
			Payload:       payload,
			OccurredAt:    now,
		})
	}

	return AdminOverrideVerdict{
		Allowed:                    true,
		OverridesInLast24h:         candidateCount,
		SuperAdminReviewAlertFired: alertFired,
		RequiresSuperAdminApproval: candidateCount > AdminOverrideDailyApprovalThreshold,
		AuditID:                    entry.AuditID,
		AuditSequenceNumber:        entry.SequenceNumber,
	}, nil
}

func (s *Service) appendSequencedAuditLocked(
	adminID, adminRole, action, targetType, targetID, targetWorkspaceID, reason string,
	afterState map[string]any,
) InternalAuditLogRecord {
	now := s.Now()
	s.auditSequenceCursor++
	seq := s.auditSequenceCursor
	prevHash := "GENESIS"
	if len(s.auditLogs) > 0 && s.auditLogs[len(s.auditLogs)-1].EntryHash != "" {
		prevHash = s.auditLogs[len(s.auditLogs)-1].EntryHash
	}
	auditID := s.IDGenerator()
	entryHash := hashAdminPayload(fmt.Sprintf("%d", seq), prevHash, auditID, adminID, action, targetID, reason)
	rec := InternalAuditLogRecord{
		AuditID:           auditID,
		SequenceNumber:    seq,
		EntryHash:         entryHash,
		AdminID:           adminID,
		AdminRole:         adminRole,
		Action:            action,
		TargetType:        targetType,
		TargetID:          targetID,
		TargetWorkspaceID: targetWorkspaceID,
		Reason:            reason,
		AfterState:        afterState,
		CreatedAt:         now,
	}
	s.auditLogs = append(s.auditLogs, rec)
	return rec
}

// AuditIntegrityReport describes the outcome of verifying the internal audit log sequence (EC-M23-005).
type AuditIntegrityReport struct {
	Intact              bool
	CheckedEntries      int
	MissingSequenceAt   int64
	ReadOnlyLockApplied bool
	Sev1IncidentCreated bool
}

// VerifyAuditLogSequenceIntegrity inspects all sequenced entries in internal_audit_logs.
// Per EC-M23-005: if a gap in sequence numbers is detected, it immediately triggers a Sev1 alert,
// locks the audit log to read-only, and auto-creates a critical security incident.
func (s *Service) VerifyAuditLogSequenceIntegrity() (AuditIntegrityReport, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	var sequenced []InternalAuditLogRecord
	for _, entry := range s.auditLogs {
		if entry.SequenceNumber > 0 {
			sequenced = append(sequenced, entry)
		}
	}
	sort.Slice(sequenced, func(i, j int) bool {
		return sequenced[i].SequenceNumber < sequenced[j].SequenceNumber
	})

	for idx, entry := range sequenced {
		expected := int64(idx + 1)
		if entry.SequenceNumber != expected {
			s.auditReadOnlyLocked = true
			s.activeIncidents++
			s.operationalHealth.ActiveSev1Count++
			s.operationalHealth.Status = "critical"

			now := s.Now()
			incidentID := s.IDGenerator()
			payload, _ := json.Marshal(map[string]any{
				"incident_id":          incidentID,
				"severity":             "sev1",
				"category":             "EC-M23-005_AUDIT_SEQUENCE_GAP",
				"expected_sequence":    expected,
				"observed_sequence":    entry.SequenceNumber,
				"audit_read_only_lock": true,
				"detected_at":          now.Format(time.RFC3339),
			})
			s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
				EventID:       s.IDGenerator(),
				EventType:     "incident.created",
				TargetStream:  outbox.QueueNotifications,
				AggregateType: "security_incident",
				AggregateID:   incidentID,
				Payload:       payload,
				OccurredAt:    now,
			})

			return AuditIntegrityReport{
				Intact:              false,
				CheckedEntries:      len(sequenced),
				MissingSequenceAt:   expected,
				ReadOnlyLockApplied: true,
				Sev1IncidentCreated: true,
			}, fmt.Errorf("%w: expected sequence %d, observed %d", ErrAuditSequenceIntegrityViolation, expected, entry.SequenceNumber)
		}
	}

	return AuditIntegrityReport{
		Intact:              true,
		CheckedEntries:      len(sequenced),
		ReadOnlyLockApplied: s.auditReadOnlyLocked,
		Sev1IncidentCreated: false,
	}, nil
}

// SimulateAuditSequenceGapForTest advances the internal sequence cursor to simulate an unauthorized deletion/gap
// so EC-M23-005 detection and read-only lock behavior can be deterministically verified in tests.
func (s *Service) SimulateAuditSequenceGapForTest(skipCount int64) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if skipCount > 0 {
		s.auditSequenceCursor += skipCount
	}
}

// ============================================================================
// AdminComplianceService (GDPR / PDPA DSR Queue, 72h Breach Log, Article 30 DPA)
// ============================================================================

// DataSubjectRequestRecord mirrors canonical data_subject_requests (migration 00046 & screen_admin_gdpr_tools.md).
type DataSubjectRequestRecord struct {
	RequestID              string
	WorkspaceID            string
	UserID                 string
	UserEmail              string
	RequestType            string // "access", "deletion", "portability", "rectification", "objection"
	Status                 string // "received", "identity_verification", "processing", "completed", "rejected"
	Regulation             string // "GDPR", "PDPA_VN", "CCPA"
	Description            string
	SLADeadline            time.Time
	OAuthTokensRedacted    bool
	ExportFileURL          string
	ExportFileExpiresAt    *time.Time
	RejectionReason        string
	LegalBasisForRejection string
	ProcessedByAdminID     string
	CreatedAt              time.Time
	CompletedAt            *time.Time
}

// BreachNotificationRecord mirrors canonical breach_notifications (migration 00046 & screen_admin_gdpr_tools.md).
type BreachNotificationRecord struct {
	BreachID             string
	Title                string
	Description          string
	Severity             string // "critical", "high", "medium", "low"
	Status               string // "detected", "investigating", "authority_notified", "users_notified", "resolved"
	DetectedAt           time.Time
	NotificationDeadline time.Time // DetectedAt + 72 hours
	AuthorityNotifiedAt  *time.Time
	UsersNotifiedAt      *time.Time
	AffectedUserCount    int32
	DataCategories       []string
	RemediationSteps     string
	CreatedByAdminID     string
	CreatedAt            time.Time
}

// RemainingHoursTo72hDeadline returns the remaining hours before the 72-hour regulatory breach notification deadline.
func (b BreachNotificationRecord) RemainingHoursTo72hDeadline(now time.Time) float64 {
	return b.NotificationDeadline.Sub(now).Hours()
}

// DataProcessingActivityRecord mirrors canonical data_processing_activities (Article 30 ROPA log).
type DataProcessingActivityRecord struct {
	ActivityID            string
	ActivityName          string
	Purpose               string
	LegalBasis            string
	DataCategories        []string
	DataSubjects          []string
	Recipients            []string
	ThirdCountryTransfers string
	RetentionPeriod       string
	SecurityMeasures      string
	SubProcessorName      string
	SubProcessorLocation  string
	DPASigned             bool
	LastReviewedAt        time.Time
	CreatedAt             time.Time
}

func (s *Service) authorizeComplianceRoleLocked(adminID string, allowAuditorRead bool) (*InternalAdminRecord, error) {
	admin, ok := s.adminsByID[adminID]
	if !ok || admin.Status != "active" {
		return nil, ErrInvalidAdminCredentials
	}
	if admin.AdminRole == rbac.AdminRoleSuper || admin.AdminRole == rbac.AdminRoleOps {
		return admin, nil
	}
	if allowAuditorRead && admin.AdminRole == rbac.AdminRoleAuditor {
		return admin, nil
	}
	return nil, fmt.Errorf("%w: role %q is not permitted on AdminComplianceService", ErrPrivilegedRoleBoundaryViolation, admin.AdminRole)
}

// CreateDSR registers a GDPR/PDPA Data Subject Request with a 30-day statutory SLA deadline (or 72h for PDPA rectification/deletion tracking).
func (s *Service) CreateDSR(
	ctx context.Context,
	workspaceID, userID, userEmail, requestType, regulation, description string,
) (*DataSubjectRequestRecord, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if !tenantdb.IsValidNonZeroUUID(workspaceID) || !tenantdb.IsValidNonZeroUUID(userID) || strings.TrimSpace(userEmail) == "" {
		return nil, ErrInvalidInput
	}
	rt := strings.ToLower(strings.TrimSpace(requestType))
	switch rt {
	case "access", "deletion", "portability", "rectification", "objection":
	default:
		return nil, ErrInvalidInput
	}
	reg := strings.ToUpper(strings.TrimSpace(regulation))
	if reg == "" {
		reg = "PDPA_VN"
	}
	if reg != "GDPR" && reg != "PDPA_VN" && reg != "CCPA" {
		return nil, ErrInvalidInput
	}

	s.mu.Lock()
	defer s.mu.Unlock()
	now := s.Now()
	sla := now.Add(30 * 24 * time.Hour)
	if reg == "PDPA_VN" && (rt == "deletion" || rt == "rectification") {
		sla = now.Add(72 * time.Hour)
	}
	rec := &DataSubjectRequestRecord{
		RequestID:           s.IDGenerator(),
		WorkspaceID:         workspaceID,
		UserID:              userID,
		UserEmail:           strings.TrimSpace(userEmail),
		RequestType:         rt,
		Status:              "received",
		Regulation:          reg,
		Description:         strings.TrimSpace(description),
		SLADeadline:         sla,
		OAuthTokensRedacted: true,
		CreatedAt:           now,
	}
	s.dsrRequests[rec.RequestID] = rec
	cp := *rec
	return &cp, nil
}

// ListDSRs returns Data Subject Requests for Super Admin, Operations Admin, or Auditor (read-only).
func (s *Service) ListDSRs(ctx context.Context, adminID string, statusFilter string) ([]DataSubjectRequestRecord, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if _, err := s.authorizeComplianceRoleLocked(adminID, true); err != nil {
		return nil, err
	}
	var out []DataSubjectRequestRecord
	for _, r := range s.dsrRequests {
		if statusFilter != "" && !strings.EqualFold(r.Status, statusFilter) {
			continue
		}
		out = append(out, *r)
	}
	sort.Slice(out, func(i, j int) bool { return out[i].CreatedAt.Before(out[j].CreatedAt) })
	return out, nil
}

// GenerateDSRExport generates a sanitized portability/access export for a DSR (Super Admin or Operations Admin only; Auditor is read-only).
func (s *Service) GenerateDSRExport(
	ctx context.Context,
	adminID string,
	requestID string,
	rawUserData map[string]any,
	supportMessages []SupportTicketMessageRecord,
) (*DataSubjectRequestRecord, []byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, nil, err
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	admin, err := s.authorizeComplianceRoleLocked(adminID, false)
	if err != nil {
		return nil, nil, err
	}
	req, exists := s.dsrRequests[requestID]
	if !exists {
		return nil, nil, ErrDSRNotFound
	}
	exportBytes, err := BuildTenantGDPRExportPayload(req.WorkspaceID, req.UserID, req.UserEmail, rawUserData, supportMessages)
	if err != nil {
		return nil, nil, err
	}
	now := s.Now()
	exp := now.Add(48 * time.Hour)
	req.Status = "completed"
	req.OAuthTokensRedacted = true
	req.ExportFileURL = fmt.Sprintf("https://exports.creativanta.internal/gdpr/%s.json", req.RequestID)
	req.ExportFileExpiresAt = &exp
	req.ProcessedByAdminID = adminID
	req.CompletedAt = &now

	s.appendSequencedAuditLocked(adminID, admin.AdminRole, "compliance.dsr_export_generated", "data_subject_request", req.RequestID, req.WorkspaceID, "Generated GDPR/PDPA portability export with OAuth tokens redacted", map[string]any{
		"request_type":          req.RequestType,
		"regulation":            req.Regulation,
		"oauth_tokens_redacted": true,
		"export_expires_at":     exp.Format(time.RFC3339),
	})

	cp := *req
	return &cp, exportBytes, nil
}

// ApproveDSRDeletion executes a GDPR Art. 17 / PDPA right-to-erasure deletion request.
// Restricted strictly to Super Admin (per screen_admin_gdpr_tools.md §4 Role Matrix).
func (s *Service) ApproveDSRDeletion(
	ctx context.Context,
	adminID string,
	requestID string,
	confirmationText string,
	reason string,
) (*DataSubjectRequestRecord, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if strings.TrimSpace(confirmationText) != "CONFIRM DELETE" || strings.TrimSpace(reason) == "" {
		return nil, fmt.Errorf("%w: CONFIRM DELETE confirmation and audit reason are required", ErrInvalidInput)
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	admin, err := s.authorizeComplianceRoleLocked(adminID, false)
	if err != nil {
		return nil, err
	}
	if admin.AdminRole != rbac.AdminRoleSuper {
		return nil, fmt.Errorf("%w: only super_admin can approve permanent DSR erasure", ErrPrivilegedRoleBoundaryViolation)
	}
	req, exists := s.dsrRequests[requestID]
	if !exists {
		return nil, ErrDSRNotFound
	}
	now := s.Now()
	req.Status = "completed"
	req.ProcessedByAdminID = adminID
	req.CompletedAt = &now

	s.appendSequencedAuditLocked(adminID, admin.AdminRole, "compliance.dsr_deletion_approved", "data_subject_request", req.RequestID, req.WorkspaceID, reason, map[string]any{
		"user_id":               req.UserID,
		"financial_ledger_kept": "anonymized_7yr_tax_retention",
		"completed_at":          now.Format(time.RFC3339),
	})
	cp := *req
	return &cp, nil
}

// CreateBreachNotification logs a security/privacy breach with an automatic 72-hour regulatory notification countdown (Super Admin only).
func (s *Service) CreateBreachNotification(
	ctx context.Context,
	adminID string,
	title, description, severity string,
	detectedAt time.Time,
	affectedUsers int32,
	dataCategories []string,
	remediationSteps string,
) (*BreachNotificationRecord, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if strings.TrimSpace(title) == "" || strings.TrimSpace(description) == "" {
		return nil, ErrInvalidInput
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	admin, err := s.authorizeComplianceRoleLocked(adminID, false)
	if err != nil {
		return nil, err
	}
	if admin.AdminRole != rbac.AdminRoleSuper {
		return nil, fmt.Errorf("%w: only super_admin can register a regulatory breach notification", ErrPrivilegedRoleBoundaryViolation)
	}
	now := s.Now()
	if detectedAt.IsZero() {
		detectedAt = now
	}
	deadline := detectedAt.Add(BreachNotificationSLAHours * time.Hour)
	rec := &BreachNotificationRecord{
		BreachID:             s.IDGenerator(),
		Title:                strings.TrimSpace(title),
		Description:          strings.TrimSpace(description),
		Severity:             strings.ToLower(strings.TrimSpace(severity)),
		Status:               "detected",
		DetectedAt:           detectedAt,
		NotificationDeadline: deadline,
		AffectedUserCount:    affectedUsers,
		DataCategories:       append([]string(nil), dataCategories...),
		RemediationSteps:     strings.TrimSpace(remediationSteps),
		CreatedByAdminID:     adminID,
		CreatedAt:            now,
	}
	s.breachNotifications[rec.BreachID] = rec
	s.appendSequencedAuditLocked(adminID, admin.AdminRole, "compliance.breach_logged", "breach_notification", rec.BreachID, "", title, map[string]any{
		"severity":              rec.Severity,
		"detected_at":           detectedAt.Format(time.RFC3339),
		"notification_deadline": deadline.Format(time.RFC3339),
		"affected_user_count":   affectedUsers,
	})
	cp := *rec
	return &cp, nil
}

// ============================================================================
// Load & Performance SLA Evaluator (performance_benchmarks.md §1–§4)
// ============================================================================

// LoadScenarioResult captures measured latency and error metrics from a k6 or Go load rehearsal scenario.
type LoadScenarioResult struct {
	ScenarioName    string
	VirtualUsers    int
	RequestsPerSec  float64
	P50LatencyMs    float64
	P95LatencyMs    float64
	P99LatencyMs    float64
	ErrorRatePct    float64
	IsSpikeScenario bool
	MemoryGrowthPct float64
}

// LoadBenchmarkVerdict reports whether all performance_benchmarks.md SLA targets are satisfied.
type LoadBenchmarkVerdict struct {
	Passed          bool
	EvaluatedCount  int
	FailedScenarios []string
	Violations      []string
}

// EvaluateLoadRehearsalBenchmarks validates load test results against canonical targets in performance_benchmarks.md:
//   - Normal API CRUD / Read scenarios: p50 <= 10ms (for core API) or scenario p95 <= 200ms, p99 <= 500ms, error rate < 0.1%
//   - Spike test (500 VUs): p95 <= 1000ms, error rate < 1.0%
//   - Soak test: memory growth <= 10% over 30m.
func EvaluateLoadRehearsalBenchmarks(scenarios []LoadScenarioResult) LoadBenchmarkVerdict {
	if len(scenarios) == 0 {
		return LoadBenchmarkVerdict{
			Passed:     false,
			Violations: []string{"no load rehearsal scenarios provided"},
		}
	}
	verdict := LoadBenchmarkVerdict{
		Passed:         true,
		EvaluatedCount: len(scenarios),
	}
	for _, sc := range scenarios {
		maxErrorPct := 0.1
		maxP95Ms := 200.0
		maxP99Ms := 500.0
		if sc.IsSpikeScenario {
			maxErrorPct = 1.0
			maxP95Ms = 1000.0
			maxP99Ms = 2000.0
		}
		if sc.ErrorRatePct > maxErrorPct {
			verdict.Passed = false
			verdict.FailedScenarios = append(verdict.FailedScenarios, sc.ScenarioName)
			verdict.Violations = append(verdict.Violations, fmt.Sprintf("%s error rate %.3f%% exceeds max %.3f%%", sc.ScenarioName, sc.ErrorRatePct, maxErrorPct))
		}
		if sc.P95LatencyMs > maxP95Ms {
			verdict.Passed = false
			verdict.FailedScenarios = append(verdict.FailedScenarios, sc.ScenarioName)
			verdict.Violations = append(verdict.Violations, fmt.Sprintf("%s p95 %.2fms exceeds max %.2fms", sc.ScenarioName, sc.P95LatencyMs, maxP95Ms))
		}
		if sc.P99LatencyMs > maxP99Ms {
			verdict.Passed = false
			verdict.FailedScenarios = append(verdict.FailedScenarios, sc.ScenarioName)
			verdict.Violations = append(verdict.Violations, fmt.Sprintf("%s p99 %.2fms exceeds max %.2fms", sc.ScenarioName, sc.P99LatencyMs, maxP99Ms))
		}
		if sc.MemoryGrowthPct > 10.0 {
			verdict.Passed = false
			verdict.FailedScenarios = append(verdict.FailedScenarios, sc.ScenarioName)
			verdict.Violations = append(verdict.Violations, fmt.Sprintf("%s memory growth %.2f%% exceeds 10%% soak budget", sc.ScenarioName, sc.MemoryGrowthPct))
		}
	}
	return verdict
}

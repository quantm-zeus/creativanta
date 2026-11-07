package internaladmin_test

import (
	"bytes"
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"net/http"
	"net/http/httptest"
	"os"
	"os/exec"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5/pgxpool"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/internaladmin"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

func TestP808AcceptanceTarget1_RealRestoreAndFailingSmoke(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 4, 21, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	const (
		superAdminID = "90000000-0000-4000-8000-000000000001"
		wsA          = "22222222-2222-4222-8222-222222222201"
		wsB          = "22222222-2222-4222-8222-222222222202"
		ownerA       = "11111111-1111-4111-8111-111111111101"
		ownerB       = "11111111-1111-4111-8111-111111111102"
	)

	if err := svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      superAdminID,
		Email:        "super@internal.creativanta.vn",
		FullName:     "Super Admin",
		PasswordHash: internaladmin.HashAdminPassword("Super-Restore-2026!"),
		AdminRole:    rbac.AdminRoleSuper,
		MFASecret:    "JBSWY3DPEHPK3PXP",
		MFAEnabled:   true,
		Status:       "active",
	}); err != nil {
		t.Fatalf("RegisterAdmin: %v", err)
	}

	snap := internaladmin.DatabaseSnapshot{
		SnapshotID:     "20261104T210000Z-p808",
		Environment:    "rehearsal",
		CreatedAt:      now,
		WALPositionLSN: "0/18B4F28",
		Workspaces: []internaladmin.WorkspaceSnapshot{
			{
				WorkspaceID:        wsA,
				Name:               "Creator Studio Alpha",
				Slug:               "creator-studio-alpha",
				OwnerUserID:        ownerA,
				AICreditsRemaining: 2420,
				Status:             "active",
			},
			{
				WorkspaceID:        wsB,
				Name:               "Brand Commerce Beta",
				Slug:               "brand-commerce-beta",
				OwnerUserID:        ownerB,
				AICreditsRemaining: 5000,
				Status:             "active",
			},
		},
		FinancialPostings: []internaladmin.FinancialPostingSnapshot{
			{
				PostingID:      "30000000-0000-4000-8000-000000000001",
				WorkspaceID:    wsA,
				AccountCode:    "1100_CASH_CLEARING",
				Direction:      "debit",
				AmountMicro:    15000000000, // 15,000.00
				Currency:       "VND",
				IdempotencyKey: "idem-post-1",
				CreatedAt:      now.Add(-10 * time.Minute),
			},
			{
				PostingID:      "30000000-0000-4000-8000-000000000002",
				WorkspaceID:    wsA,
				AccountCode:    "4000_MERCHANT_REVENUE",
				Direction:      "credit",
				AmountMicro:    15000000000,
				Currency:       "VND",
				IdempotencyKey: "idem-post-1",
				CreatedAt:      now.Add(-10 * time.Minute),
			},
		},
		AICreditLots: []internaladmin.AICreditLotSnapshot{
			{
				LotID:            "40000000-0000-4000-8000-000000000001",
				WorkspaceID:      wsA,
				InitialCredits:   3000,
				RemainingCredits: 2420,
				LotType:          "subscription_monthly",
				ExpiresAt:        now.Add(20 * 24 * time.Hour),
			},
			{
				LotID:            "40000000-0000-4000-8000-000000000002",
				WorkspaceID:      wsB,
				InitialCredits:   5000,
				RemainingCredits: 5000,
				LotType:          "topup_pack",
				ExpiresAt:        now.Add(90 * 24 * time.Hour),
			},
		},
		EvidenceObjects: []internaladmin.EvidenceObjectSnapshot{
			{
				EvidenceID:    "50000000-0000-4000-8000-000000000001",
				WorkspaceID:   wsA,
				Category:      "dispute_receipt",
				ContentSHA256: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
				StorageURI:    "s3://creativanta-evidence/wsA/ev1.pdf",
				RetentionLock: now.Add(365 * 24 * time.Hour),
			},
		},
		AuditEntries: []internaladmin.AuditSequenceEntrySnapshot{
			{
				AuditID:        "60000000-0000-4000-8000-000000000001",
				SequenceNumber: 1,
				EntryHash:      "a111111111111111111111111111111111111111111111111111111111111111",
				AdminID:        superAdminID,
				Action:         "admin.login",
				CreatedAt:      now.Add(-30 * time.Minute),
			},
			{
				AuditID:        "60000000-0000-4000-8000-000000000002",
				SequenceNumber: 2,
				EntryHash:      "b222222222222222222222222222222222222222222222222222222222222222",
				AdminID:        superAdminID,
				Action:         "system.backup_created",
				CreatedAt:      now.Add(-5 * time.Minute),
			},
		},
	}

	backupDir := t.TempDir()
	artifact, err := internaladmin.CreateVerifiedBackupSnapshot(backupDir, snap)
	if err != nil {
		t.Fatalf("CreateVerifiedBackupSnapshot: %v", err)
	}
	if len(artifact.SHA256Digest) != 64 {
		t.Fatalf("expected 64-char sha256 digest, got %q", artifact.SHA256Digest)
	}

	// 1. In-memory restore rehearsal without a disposable DB target must honestly report SIMULATION_ONLY.
	restoreRec, err := svc.ExecuteRestoreRehearsal(context.Background(), superAdminID, artifact, 0, 420)
	if err != nil {
		t.Fatalf("ExecuteRestoreRehearsal: %v", err)
	}
	if !restoreRec.ChecksumVerified || !restoreRec.LedgerBalanced || !restoreRec.AuditSequenceContinuous {
		t.Fatalf("expected verified restore rehearsal record, got %+v", restoreRec)
	}
	if restoreRec.WorkspacesRestored != 2 || restoreRec.PostingsRestored != 2 || restoreRec.AuditEntriesRestored != 2 {
		t.Fatalf("unexpected restored counts: %+v", restoreRec)
	}
	if restoreRec.ExecutionMode != internaladmin.RehearsalModeSimulationOnly || !restoreRec.IsSimulation || restoreRec.OperationalRestorePerformed || restoreRec.SmokePassed {
		t.Fatalf("expected honest SIMULATION_ONLY label when no disposable DB was touched, got %+v", restoreRec)
	}

	// 1b. Attempting to claim an operational production/staging restore without a disposable DB target must fail closed.
	prodSnap := snap
	prodSnap.Environment = "production"
	prodArtifact, err := internaladmin.CreateVerifiedBackupSnapshot(t.TempDir(), prodSnap)
	if err != nil {
		t.Fatalf("CreateVerifiedBackupSnapshot prod: %v", err)
	}
	if _, err := svc.ExecuteRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, 120); !errors.Is(err, internaladmin.ErrOperationalTargetRequired) {
		t.Fatalf("expected ErrOperationalTargetRequired when claiming production restore without disposable target, got %v", err)
	}

	// 1c. File-backed JSON fixture target is strictly SIMULATION_ONLY (IsSimulation=true, OperationalRestorePerformed=false)
	// and MUST fail closed with ErrOperationalTargetRequired when given a production or staging snapshot.
	disposableTarget := &internaladmin.FileBackedDisposableDBTarget{
		TargetDir: t.TempDir(),
	}
	if _, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, disposableTarget); !errors.Is(err, internaladmin.ErrOperationalTargetRequired) {
		t.Fatalf("expected ErrOperationalTargetRequired when using JSON file fixture target for production snapshot, got %v", err)
	}
	dispRec, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, artifact, 0, disposableTarget)
	if err != nil {
		t.Fatalf("ExecuteDisposableRestoreRehearsal rehearsal fixture: %v", err)
	}
	if dispRec.ExecutionMode != internaladmin.RehearsalModeSimulationOnly || !dispRec.IsSimulation || dispRec.OperationalRestorePerformed || dispRec.SmokePassed {
		t.Fatalf("expected SIMULATION_ONLY record for file-backed JSON fixture target, got %+v", dispRec)
	}
	if !strings.HasPrefix(dispRec.TargetDatabaseURI, "file://") {
		t.Fatalf("expected file:// target URI, got %q", dispRec.TargetDatabaseURI)
	}

	// 1d. Disposable target failures (write failure, row count mismatch, smoke failure) must fail closed.
	if _, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, artifact, 0, &internaladmin.FileBackedDisposableDBTarget{
		TargetDir:   t.TempDir(),
		FailOnWrite: true,
	}); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("expected ErrRestoreIntegrityFailed on disposable target write failure, got %v", err)
	}
	if _, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, artifact, 0, &internaladmin.FileBackedDisposableDBTarget{
		TargetDir:    t.TempDir(),
		CorruptCount: 1,
	}); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("expected ErrRestoreIntegrityFailed on disposable target row count mismatch, got %v", err)
	}
	if _, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, artifact, 0, &internaladmin.FileBackedDisposableDBTarget{
		TargetDir:   t.TempDir(),
		FailOnSmoke: true,
	}); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("expected ErrRestoreIntegrityFailed on disposable target smoke failure, got %v", err)
	}

	// 1e. Real PostgreSQL disposable target materializes tables in PostgreSQL, queries back row counts & SQL ledger balance,
	// and legitimately earns DISPOSABLE_TARGET_VERIFIED (IsSimulation=false, OperationalRestorePerformed=true).
	if pgPool := openOptionalPostgresForRehearsalTest(t); pgPool != nil {
		pgTarget := &internaladmin.PostgresDisposableDBTarget{
			Pool:         pgPool,
			TargetSchema: "rehearsal_p808",
		}
		pgRec, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, pgTarget)
		if err != nil {
			t.Fatalf("ExecuteDisposableRestoreRehearsal with PostgresDisposableDBTarget: %v", err)
		}
		if pgRec.ExecutionMode != internaladmin.RehearsalModeDisposableTargetVerified || pgRec.IsSimulation || !pgRec.OperationalRestorePerformed || !pgRec.SmokePassed {
			t.Fatalf("expected DISPOSABLE_TARGET_VERIFIED record for PostgresDisposableDBTarget, got %+v", pgRec)
		}
		if !strings.HasPrefix(pgRec.TargetDatabaseURI, "postgres://") {
			t.Fatalf("expected postgres:// target URI, got %q", pgRec.TargetDatabaseURI)
		}
		if _, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, &internaladmin.PostgresDisposableDBTarget{
			Pool:        pgPool,
			FailOnWrite: true,
		}); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
			t.Fatalf("expected ErrRestoreIntegrityFailed on postgres target write failure, got %v", err)
		}
		if _, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, &internaladmin.PostgresDisposableDBTarget{
			Pool:         pgPool,
			CorruptCount: 1,
		}); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
			t.Fatalf("expected ErrRestoreIntegrityFailed on postgres target row count mismatch, got %v", err)
		}
		if _, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, &internaladmin.PostgresDisposableDBTarget{
			Pool:        pgPool,
			FailOnSmoke: true,
		}); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
			t.Fatalf("expected ErrRestoreIntegrityFailed on postgres target smoke failure, got %v", err)
		}
	}

	// 2. Corrupting the backup file on disk must fail closed with ErrBackupChecksumMismatch.
	corruptedDir := t.TempDir()
	corruptArtifact, err := internaladmin.CreateVerifiedBackupSnapshot(corruptedDir, snap)
	if err != nil {
		t.Fatalf("CreateVerifiedBackupSnapshot corrupt fixture: %v", err)
	}
	if err := os.WriteFile(corruptArtifact.SnapshotPath, []byte(`{"tampered":true}`), 0o600); err != nil {
		t.Fatalf("tamper snapshot file: %v", err)
	}
	if _, err := svc.ExecuteRestoreRehearsal(context.Background(), superAdminID, corruptArtifact, 0, 300); !errors.Is(err, internaladmin.ErrBackupChecksumMismatch) {
		t.Fatalf("expected ErrBackupChecksumMismatch on tampered backup, got %v", err)
	}

	// 3. Non-zero RPO for financial/audit restore or RTO > 3600s must fail closed with ErrRestoreIntegrityFailed.
	if _, err := svc.ExecuteRestoreRehearsal(context.Background(), superAdminID, artifact, 5, 300); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("expected RPO > 0 to fail with ErrRestoreIntegrityFailed, got %v", err)
	}
	if _, err := svc.ExecuteRestoreRehearsal(context.Background(), superAdminID, artifact, 0, 3601); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("expected RTO > 3600s to fail with ErrRestoreIntegrityFailed, got %v", err)
	}

	// 3b. Cross-currency or cross-workspace ledger imbalance (even when global raw micro sum matches) must fail closed.
	crossCurrencySnap := snap
	crossCurrencySnap.FinancialPostings = []internaladmin.FinancialPostingSnapshot{
		{
			PostingID:      "30000000-0000-4000-8000-000000000091",
			WorkspaceID:    wsA,
			AccountCode:    "1100_CASH_CLEARING",
			Direction:      "debit",
			AmountMicro:    15000000000,
			Currency:       "VND",
			IdempotencyKey: "idem-cross-curr",
			CreatedAt:      now.Add(-10 * time.Minute),
		},
		{
			PostingID:      "30000000-0000-4000-8000-000000000092",
			WorkspaceID:    wsA,
			AccountCode:    "4000_MERCHANT_REVENUE",
			Direction:      "credit",
			AmountMicro:    15000000000,
			Currency:       "USD",
			IdempotencyKey: "idem-cross-curr",
			CreatedAt:      now.Add(-10 * time.Minute),
		},
	}
	crossCurrencyArtifact, err := internaladmin.CreateVerifiedBackupSnapshot(t.TempDir(), crossCurrencySnap)
	if err != nil {
		t.Fatalf("CreateVerifiedBackupSnapshot cross-currency: %v", err)
	}
	if _, err := svc.ExecuteRestoreRehearsal(context.Background(), superAdminID, crossCurrencyArtifact, 0, 300); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("expected ErrRestoreIntegrityFailed on cross-currency ledger imbalance, got %v", err)
	}

	// 3c. Data Review #19: Per-operation (idempotency_key) imbalance within the same workspace/currency
	// and cross-tenant imbalance in FileBackedDisposableDBTarget.RestoreAndVerifySnapshot must fail closed.
	crossOpSnap := snap
	crossOpSnap.FinancialPostings = []internaladmin.FinancialPostingSnapshot{
		{
			PostingID:      "30000000-0000-4000-8000-000000000093",
			WorkspaceID:    wsA,
			AccountCode:    "1100_CASH_CLEARING",
			Direction:      "debit",
			AmountMicro:    15000000000,
			Currency:       "VND",
			IdempotencyKey: "idem-op-1",
			CreatedAt:      now.Add(-10 * time.Minute),
		},
		{
			PostingID:      "30000000-0000-4000-8000-000000000094",
			WorkspaceID:    wsA,
			AccountCode:    "4000_MERCHANT_REVENUE",
			Direction:      "credit",
			AmountMicro:    15000000000,
			Currency:       "VND",
			IdempotencyKey: "idem-op-2",
			CreatedAt:      now.Add(-10 * time.Minute),
		},
	}
	crossOpArtifact, err := internaladmin.CreateVerifiedBackupSnapshot(t.TempDir(), crossOpSnap)
	if err != nil {
		t.Fatalf("CreateVerifiedBackupSnapshot cross-op: %v", err)
	}
	if _, err := svc.ExecuteRestoreRehearsal(context.Background(), superAdminID, crossOpArtifact, 0, 300); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("Data #19 regression: expected ErrRestoreIntegrityFailed on per-operation ledger imbalance, got %v", err)
	}
	dbTarget := &internaladmin.FileBackedDisposableDBTarget{TargetDir: t.TempDir()}
	if _, err := dbTarget.RestoreAndVerifySnapshot(context.Background(), crossCurrencySnap); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("Data #19 regression: expected FileBackedDisposableDBTarget.RestoreAndVerifySnapshot to reject cross-currency ledger imbalance, got %v", err)
	}
	if _, err := dbTarget.RestoreAndVerifySnapshot(context.Background(), crossOpSnap); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("Data #19 regression: expected FileBackedDisposableDBTarget.RestoreAndVerifySnapshot to reject per-operation ledger imbalance, got %v", err)
	}

	// Cross-tenant imbalance (wsA debit 100 VND, wsB credit 100 VND -> global sum equal, per-tenant imbalanced) must fail closed.
	crossTenantSnap := snap
	crossTenantSnap.FinancialPostings = []internaladmin.FinancialPostingSnapshot{
		{
			PostingID:      "30000000-0000-4000-8000-000000000095",
			WorkspaceID:    wsA,
			AccountCode:    "1100_CASH_CLEARING",
			Direction:      "debit",
			AmountMicro:    15000000000,
			Currency:       "VND",
			IdempotencyKey: "idem-cross-tenant",
			CreatedAt:      now.Add(-10 * time.Minute),
		},
		{
			PostingID:      "30000000-0000-4000-8000-000000000096",
			WorkspaceID:    wsB,
			AccountCode:    "4000_MERCHANT_REVENUE",
			Direction:      "credit",
			AmountMicro:    15000000000,
			Currency:       "VND",
			IdempotencyKey: "idem-cross-tenant",
			CreatedAt:      now.Add(-10 * time.Minute),
		},
	}
	crossTenantArtifact, err := internaladmin.CreateVerifiedBackupSnapshot(t.TempDir(), crossTenantSnap)
	if err != nil {
		t.Fatalf("CreateVerifiedBackupSnapshot cross-tenant: %v", err)
	}
	if _, err := svc.ExecuteRestoreRehearsal(context.Background(), superAdminID, crossTenantArtifact, 0, 300); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("Data #19 regression: expected ErrRestoreIntegrityFailed on cross-tenant ledger imbalance, got %v", err)
	}
	if _, err := dbTarget.RestoreAndVerifySnapshot(context.Background(), crossTenantSnap); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
		t.Fatalf("Data #19 regression: expected FileBackedDisposableDBTarget.RestoreAndVerifySnapshot to reject cross-tenant ledger imbalance, got %v", err)
	}

	// 4. Blue/Green slot promotion succeeds when /healthz, /readyz, and authenticated business smoke pass.
	greenDigest := "sha256:2222222222222222222222222222222222222222222222222222222222222222"
	healthyProbe := internaladmin.CandidateSlotProbeInput{
		CandidateSlot:               "green",
		CandidateImageDigest:        greenDigest,
		HealthzHTTPStatus:           200,
		HealthzStatusField:          "ok",
		ReadyzHTTPStatus:            200,
		ReadyzStatusField:           "ready",
		DatabaseReady:               true,
		RedisReady:                  true,
		NATSReady:                   true,
		SmokeAuthValid:              true,
		SmokeWorkspaceID:            wsA,
		SmokeResponseValidJSON:      true,
		SmokeExpectedNetProfitMicro: 15000000000,
		SmokeObservedNetProfitMicro: 15000000000,
		SmokeExpectedCreditsBalance: 2420,
		SmokeObservedCreditsBalance: 2420,
		SmokeAuditSequenceIntact:    true,
	}
	promoteVerdict, err := svc.ExecuteBlueGreenReleaseSmokeRehearsal(context.Background(), superAdminID, healthyProbe)
	if err != nil {
		t.Fatalf("ExecuteBlueGreenReleaseSmokeRehearsal healthy: %v", err)
	}
	if !promoteVerdict.CandidatePromoted || promoteVerdict.RollbackTriggered || promoteVerdict.ActiveSlot != "green" || promoteVerdict.ActiveSlotDigest != greenDigest {
		t.Fatalf("expected green slot promotion, got %+v", promoteVerdict)
	}
	if promoteVerdict.ExecutionMode != internaladmin.RehearsalModeSimulationOnly || !promoteVerdict.IsSimulation || promoteVerdict.ProxyUpstreamSwitched {
		t.Fatalf("expected SIMULATION_ONLY and ProxyUpstreamSwitched=false when no live proxy target is provided, got %+v", promoteVerdict)
	}
	if strings.Contains(promoteVerdict.FailureReason, "upstream switched atomically") {
		t.Fatalf("in-memory simulation must not claim upstream switched atomically, got %q", promoteVerdict.FailureReason)
	}

	// 4b. Live disposable HTTP server + disposable proxy target performs real HTTP probes and switches proxy upstream.
	proxy := &mockDisposableProxyTarget{}
	candidateSrv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/healthz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"ok"}`))
		case "/readyz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"ready","database":true,"redis":true,"nats":true}`))
		case "/smoke":
			if r.Header.Get("Authorization") != "Bearer valid-smoke-token" {
				w.WriteHeader(http.StatusUnauthorized)
				return
			}
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"workspace_id":"` + wsA + `","net_profit_micro":15000000000,"credits_balance":2420,"audit_sequence_intact":true}`))
		default:
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer candidateSrv.Close()

	liveBlueDigest := "sha256:3333333333333333333333333333333333333333333333333333333333333333"
	liveVerdict, err := svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"blue",
		liveBlueDigest,
		candidateSrv.URL,
		"valid-smoke-token",
		wsA,
		15000000000,
		2420,
		proxy,
	)
	if err != nil {
		t.Fatalf("ExecuteLiveBlueGreenReleaseSmokeRehearsal healthy: %v", err)
	}
	if liveVerdict.ExecutionMode != internaladmin.RehearsalModeDisposableTargetVerified || liveVerdict.IsSimulation || !liveVerdict.ProxyUpstreamSwitched || proxy.switchedSlot != "blue" {
		t.Fatalf("expected DISPOSABLE_TARGET_VERIFIED and ProxyUpstreamSwitched=true, got %+v (proxy=%+v)", liveVerdict, proxy)
	}

	// Proxy switch failure must fail closed and trigger rollback on the proxy target.
	proxy.failSwitch = true
	failedSwitchVerdict, err := svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"green",
		greenDigest,
		candidateSrv.URL,
		"valid-smoke-token",
		wsA,
		15000000000,
		2420,
		proxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || failedSwitchVerdict.ProxyUpstreamSwitched || !failedSwitchVerdict.RollbackTriggered || proxy.rolledBackSlot != "blue" {
		t.Fatalf("expected proxy switch failure to roll back to blue, got verdict=%+v err=%v proxy=%+v", failedSwitchVerdict, err, proxy)
	}

	// 4c. Live Blue/Green smoke rehearsal against real cmd/api endpoint shapes:
	// - /healthz -> {"status":"alive","role":"api"}
	// - /readyz -> {"status":"ready","role":"api"} (without synthetic database/redis/nats boolean fields)
	// - /smoke -> 404 Not Found
	// - GET /api/workspaces/discovery (401 unauthenticated; 200 with Bearer token)
	// - POST /creativanta.admin.v1.DiagnosticsService/GetOverview (200 with Bearer token + x-workspace-id)
	realAPISrv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/healthz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"alive","role":"api"}`))
		case "/readyz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"ready","role":"api"}`))
		case "/api/workspaces/discovery":
			if r.Header.Get("Authorization") != "Bearer valid-real-api-token" {
				w.WriteHeader(http.StatusUnauthorized)
				_, _ = w.Write([]byte(`{"error":"unauthenticated"}`))
				return
			}
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"workspaces":[{"workspace_id":"` + wsA + `","name":"Creator Studio Alpha","role":"owner"}]}`))
		case "/creativanta.admin.v1.DiagnosticsService/GetOverview":
			if r.Header.Get("Authorization") != "Bearer valid-real-api-token" || r.Header.Get("x-workspace-id") != wsA {
				w.WriteHeader(http.StatusForbidden)
				return
			}
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"workspaceId":{"value":"` + wsA + `"},"overallStatus":"DIAGNOSTIC_HEALTH_STATUS_HEALTHY","totalCategoriesCount":4,"healthyCategoriesCount":4,"criticalIssuesCount":0,"activeIssuesCount":0,"unknownExternalEffectsCount":0,"pendingDlqCount":0}`))
		case "/creativanta.finance.v1.ProfitService/GetSummary":
			if r.Header.Get("Authorization") != "Bearer valid-real-api-token" || r.Header.Get("x-workspace-id") != wsA {
				w.WriteHeader(http.StatusForbidden)
				return
			}
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"snapshot":{"workspaceId":"` + wsA + `","isIncomplete":false,"unknownRequiredComponentsCount":0,"netProfit":{"currencyCode":"VND","amount":"15000.00"}}}`))
		case "/creativanta.admin.v1.AdminBillingService/GetCreditBalance":
			if r.Header.Get("Authorization") != "Bearer valid-real-api-token" || r.Header.Get("x-workspace-id") != wsA {
				w.WriteHeader(http.StatusForbidden)
				return
			}
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"balance":{"workspaceId":{"value":"` + wsA + `"},"totalRemaining":"2420"}}`))
		case "/creativanta.admin.v1.SystemConfigService/GetDashboard":
			if r.Header.Get("Authorization") != "Bearer valid-real-api-token" || r.Header.Get("x-workspace-id") != wsA {
				w.WriteHeader(http.StatusForbidden)
				return
			}
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"maintenanceMode":false,"activeKillSwitchesCount":0,"auditLogEntriesCount":"2","auditSequenceIntact":true}`))
		default:
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer realAPISrv.Close()

	realProxy := &mockDisposableProxyTarget{}
	realAPIVerdict, err := svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"green",
		greenDigest,
		realAPISrv.URL,
		"valid-real-api-token",
		wsA,
		15000000000,
		2420,
		realProxy,
	)
	if err != nil {
		t.Fatalf("ExecuteLiveBlueGreenReleaseSmokeRehearsal against real cmd/api routes failed: %v", err)
	}
	if !realAPIVerdict.CandidatePromoted || !realAPIVerdict.ProxyUpstreamSwitched || realProxy.switchedSlot != "green" {
		t.Fatalf("expected promotion on real cmd/api routes, got %+v (proxy=%+v)", realAPIVerdict, realProxy)
	}

	// Negative test against real cmd/api routes: invalid Bearer token must fail closed with SMOKE_AUTH_UNAUTHORIZED and roll back.
	badTokenVerdict, err := svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"blue",
		liveBlueDigest,
		realAPISrv.URL,
		"invalid-token",
		wsA,
		15000000000,
		2420,
		realProxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || badTokenVerdict.FailureCode != "SMOKE_AUTH_UNAUTHORIZED" || !badTokenVerdict.RollbackTriggered {
		t.Fatalf("expected SMOKE_AUTH_UNAUTHORIZED rollback on invalid token against real cmd/api routes, got verdict=%+v err=%v", badTokenVerdict, err)
	}

	// Restore activeSlot to green for subsequent table-driven negative tests.
	if _, err := svc.ExecuteBlueGreenReleaseSmokeRehearsal(context.Background(), superAdminID, healthyProbe); err != nil {
		t.Fatalf("restore green slot: %v", err)
	}

	// 5. Failing smoke rehearsals (/healthz fail, /readyz fail, auth fail, invalid JSON, profit ledger mismatch, credits mismatch)
	// must fail closed with ErrReleaseSmokeFailed and automatically roll back to the retained green slot digest!
	badCandidateDigest := "sha256:badbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadb"
	failingProbes := []struct {
		name         string
		mutate       func(p *internaladmin.CandidateSlotProbeInput)
		expectedCode string
	}{
		{
			name: "healthz 503 failure",
			mutate: func(p *internaladmin.CandidateSlotProbeInput) {
				p.HealthzHTTPStatus = 503
				p.HealthzStatusField = "degraded"
			},
			expectedCode: "SMOKE_HEALTHZ_FAILED",
		},
		{
			name: "readyz database down",
			mutate: func(p *internaladmin.CandidateSlotProbeInput) {
				p.DatabaseReady = false
			},
			expectedCode: "SMOKE_READYZ_FAILED",
		},
		{
			name: "smoke unauthorized token",
			mutate: func(p *internaladmin.CandidateSlotProbeInput) {
				p.SmokeAuthValid = false
			},
			expectedCode: "SMOKE_AUTH_UNAUTHORIZED",
		},
		{
			name: "smoke malformed JSON",
			mutate: func(p *internaladmin.CandidateSlotProbeInput) {
				p.SmokeResponseValidJSON = false
			},
			expectedCode: "SMOKE_INVALID_JSON",
		},
		{
			name: "smoke profit ledger mismatch",
			mutate: func(p *internaladmin.CandidateSlotProbeInput) {
				p.SmokeObservedNetProfitMicro = 14999999000
			},
			expectedCode: "SMOKE_PROFIT_LEDGER_MISMATCH",
		},
		{
			name: "smoke credits balance mismatch",
			mutate: func(p *internaladmin.CandidateSlotProbeInput) {
				p.SmokeObservedCreditsBalance = 2400
			},
			expectedCode: "SMOKE_CREDITS_BALANCE_MISMATCH",
		},
		{
			name: "smoke workspace id mismatch",
			mutate: func(p *internaladmin.CandidateSlotProbeInput) {
				p.SmokeExpectedWorkspaceID = wsB
			},
			expectedCode: "SMOKE_WORKSPACE_MISMATCH",
		},
	}

	for _, tc := range failingProbes {
		probe := healthyProbe
		probe.CandidateSlot = "blue"
		probe.CandidateImageDigest = badCandidateDigest
		tc.mutate(&probe)

		verdict, err := svc.ExecuteBlueGreenReleaseSmokeRehearsal(context.Background(), superAdminID, probe)
		if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) {
			t.Fatalf("%s: expected ErrReleaseSmokeFailed, got %v", tc.name, err)
		}
		if verdict.CandidatePromoted || !verdict.RollbackTriggered {
			t.Fatalf("%s: expected automatic rollback on failed smoke, got %+v", tc.name, verdict)
		}
		if verdict.FailureCode != tc.expectedCode {
			t.Fatalf("%s: expected failure code %q, got %q", tc.name, tc.expectedCode, verdict.FailureCode)
		}
		if verdict.ActiveSlot != "green" || verdict.ActiveSlotDigest != greenDigest {
			t.Fatalf("%s: expected active slot to remain green (%s), got %s (%s)", tc.name, greenDigest, verdict.ActiveSlot, verdict.ActiveSlotDigest)
		}
	}
}

func TestP808AcceptanceTarget2_NoStaleProviderOrLicenseEvidence(t *testing.T) {
	now := time.Date(2026, 11, 4, 21, 0, 0, 0, time.UTC)

	validInput := internaladmin.ProviderLicenseAuditInput{
		EvaluatedAt:     now,
		MaxFreshnessAge: 30 * 24 * time.Hour,
		ProviderRates: []internaladmin.ProviderRateCardEvidence{
			{
				Provider:             "openai",
				ModelName:            "gpt-4o",
				CapabilityKey:        "ai.script_generation",
				CostPer1kInputMicro:  2500000,
				CostPer1kOutputMicro: 10000000,
				VerifiedAt:           now.Add(-5 * 24 * time.Hour),
				ValidUntil:           now.Add(25 * 24 * time.Hour),
				Enabled:              true,
				LicenseReference:     "OPENAI-ENT-2026-VN-01",
			},
			{
				Provider:             "elevenlabs",
				ModelName:            "eleven_multilingual_v2",
				CapabilityKey:        "ai.voice_synthesis",
				CostPer1kInputMicro:  18000000,
				CostPer1kOutputMicro: 18000000,
				VerifiedAt:           now.Add(-3 * 24 * time.Hour),
				ValidUntil:           now.Add(27 * 24 * time.Hour),
				Enabled:              true,
				LicenseReference:     "ELEVENLABS-COM-2026-04",
			},
		},
		Connectors: []internaladmin.ConnectorAccessEvidence{
			{
				Platform:          "tiktok",
				CapabilityKey:     "publish.video",
				ClaimedState:      "native_now",
				ScopeGranted:      true,
				AppReviewApproved: true,
				VerifiedAt:        now.Add(-2 * 24 * time.Hour),
				ValidUntil:        now.Add(28 * 24 * time.Hour),
				EvidenceURI:       "https://evidence.creativanta.internal/connectors/tiktok-publish-2026-11.json",
			},
			{
				Platform:          "shopee",
				CapabilityKey:     "commerce.orders_sync",
				ClaimedState:      "partner_gated",
				ScopeGranted:      false,
				AppReviewApproved: false,
				VerifiedAt:        now.Add(-2 * 24 * time.Hour),
				ValidUntil:        now.Add(28 * 24 * time.Hour),
				EvidenceURI:       "https://evidence.creativanta.internal/connectors/shopee-partner-gated.json",
			},
		},
		WorkflowLicense: internaladmin.WorkflowLicenseEvidence{
			RuntimeMode: "owned_go_runtime",
		},
		LegalChecklist: internaladmin.LegalComplianceChecklistEvidence{
			ToSPublished:                 true,
			PrivacyPolicyPublished:       true,
			CookieConsentActive:          true,
			DMCAAgentDesignated:          true,
			PDPAImpactAssessmentComplete: true,
			DPAsSignedAllSubprocessors:   true,
			CounselSignoffCompleted:      false, // Honest external gate LEG-H-001
			VerifiedAt:                   now.Add(-24 * time.Hour),
		},
	}

	// 1. Fresh provider/connector/workflow evidence passes freshness audit and honestly records LEG-H-001 as external gate.
	verdict, err := internaladmin.EvaluateProviderAndLicenseFreshness(validInput)
	if err != nil {
		t.Fatalf("expected fresh provider/license evidence to pass, got %v", err)
	}
	if !verdict.NoStaleEvidence {
		t.Fatalf("expected NoStaleEvidence=true, got %+v", verdict)
	}
	if verdict.MaxAllowedEvidenceState != "LOCAL_IMPLEMENTED" {
		t.Fatalf("expected MaxAllowedEvidenceState=LOCAL_IMPLEMENTED while external gates remain open, got %q", verdict.MaxAllowedEvidenceState)
	}
	if len(verdict.ExternalGatesUnmet) == 0 || !strings.Contains(verdict.ExternalGatesUnmet[0], "LEG-H-001") {
		t.Fatalf("expected LEG-H-001 in ExternalGatesUnmet, got %+v", verdict.ExternalGatesUnmet)
	}

	// 2. Expired provider rate card (now > valid_until) is rejected with ErrStaleProviderEvidence.
	staleRateInput := validInput
	staleRateInput.ProviderRates = append([]internaladmin.ProviderRateCardEvidence(nil), validInput.ProviderRates...)
	staleRateInput.ProviderRates[0].ValidUntil = now.Add(-1 * time.Hour)

	staleRateVerdict, err := internaladmin.EvaluateProviderAndLicenseFreshness(staleRateInput)
	if !errors.Is(err, internaladmin.ErrStaleProviderEvidence) {
		t.Fatalf("expected ErrStaleProviderEvidence on expired rate card, got %v", err)
	}
	if staleRateVerdict.NoStaleEvidence || len(staleRateVerdict.RejectedRateCards) != 1 {
		t.Fatalf("expected 1 rejected rate card, got %+v", staleRateVerdict)
	}

	// 3. Connector claiming native_now with expired verification or missing app review is rejected and downgraded to manual.
	staleConnInput := validInput
	staleConnInput.Connectors = append([]internaladmin.ConnectorAccessEvidence(nil), validInput.Connectors...)
	staleConnInput.Connectors[0].AppReviewApproved = false

	staleConnVerdict, err := internaladmin.EvaluateProviderAndLicenseFreshness(staleConnInput)
	if !errors.Is(err, internaladmin.ErrStaleProviderEvidence) {
		t.Fatalf("expected ErrStaleProviderEvidence on unverified native_now connector, got %v", err)
	}
	if staleConnVerdict.DowngradedConnectors["tiktok:publish.video"] != "manual" {
		t.Fatalf("expected tiktok:publish.video to downgrade to manual, got %+v", staleConnVerdict.DowngradedConnectors)
	}

	// 4. Unverified Activepieces enterprise embedding license is rejected and forced back to owned_go_runtime.
	staleWfInput := validInput
	staleWfInput.WorkflowLicense = internaladmin.WorkflowLicenseEvidence{
		RuntimeMode:               "activepieces_enterprise_embed",
		EnterpriseLicenseVerified: false,
	}
	staleWfVerdict, err := internaladmin.EvaluateProviderAndLicenseFreshness(staleWfInput)
	if !errors.Is(err, internaladmin.ErrStaleProviderEvidence) {
		t.Fatalf("expected ErrStaleProviderEvidence on unverified Activepieces embed license, got %v", err)
	}
	if !staleWfVerdict.WorkflowLicenseRejected || staleWfVerdict.EffectiveWorkflowRuntime != "owned_go_runtime" {
		t.Fatalf("expected fallback to owned_go_runtime, got %+v", staleWfVerdict)
	}
}

func TestP808AcceptanceTarget3_TenantAndPrivacyAcrossPublicAndInternalPaths(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 4, 21, 30, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	const (
		superAdminID   = "90000000-0000-4000-8000-000000000001"
		opsAdminID     = "90000000-0000-4000-8000-000000000002"
		supportAdminID = "90000000-0000-4000-8000-000000000003"
		auditorAdminID = "90000000-0000-4000-8000-000000000004"
		tenantA        = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
		tenantB        = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
		userA          = "11111111-1111-4111-8111-111111111111"
		userB          = "22222222-2222-4222-8222-222222222222"
		mfaSecret      = "JBSWY3DPEHPK3PXP"
		password       = "Admin-P808-Sec-2026!"
	)

	for _, adm := range []internaladmin.InternalAdminRecord{
		{AdminID: superAdminID, Email: "super@internal.creativanta.vn", FullName: "Super Admin", PasswordHash: internaladmin.HashAdminPassword(password), AdminRole: rbac.AdminRoleSuper, MFASecret: mfaSecret, MFAEnabled: true, Status: "active"},
		{AdminID: opsAdminID, Email: "ops@internal.creativanta.vn", FullName: "Ops Admin", PasswordHash: internaladmin.HashAdminPassword(password), AdminRole: rbac.AdminRoleOps, MFASecret: mfaSecret, MFAEnabled: true, Status: "active"},
		{AdminID: supportAdminID, Email: "support@internal.creativanta.vn", FullName: "Support Admin", PasswordHash: internaladmin.HashAdminPassword(password), AdminRole: rbac.AdminRoleSupport, MFASecret: mfaSecret, MFAEnabled: true, Status: "active"},
		{AdminID: auditorAdminID, Email: "auditor@internal.creativanta.vn", FullName: "Auditor", PasswordHash: internaladmin.HashAdminPassword(password), AdminRole: rbac.AdminRoleAuditor, MFASecret: mfaSecret, MFAEnabled: true, Status: "active"},
	} {
		if err := svc.RegisterAdmin(adm); err != nil {
			t.Fatalf("RegisterAdmin(%s): %v", adm.AdminRole, err)
		}
	}

	// --- A. PUBLIC PATH TESTS: Creator Directory Projection & SSRF Guard ---
	publishedKit := internaladmin.CreatorDirectoryInternalRecord{
		MediaKitID:            "70000000-0000-4000-8000-000000000001",
		WorkspaceID:           tenantA,
		OwnerUserID:           userA,
		OwnerEmail:            "private-owner-a@creativanta.vn",
		OwnerPhone:            "+84901234567",
		Slug:                  "linh-beauty-vn",
		DisplayName:           "Linh Beauty Official",
		Bio:                   "Chuyên gia review mỹ phẩm chính hãng",
		PrimaryNiche:          "beauty",
		DirectoryOptIn:        true,
		DirectoryStatus:       "published",
		VerifiedHandleSummary: []string{"@linhbeauty.tt", "@linhbeauty.ig"},
		AccessTokenEncrypted:  "enc_oauth_access_secret_token_never_leak",
		RefreshTokenEncrypted: "enc_oauth_refresh_secret_token_never_leak",
		InternalAdminNotes:    "VIP creator tier — internal note",
	}
	pubProj, err := internaladmin.ProjectPublicCreatorDirectoryEntry(publishedKit, tenantB)
	if err != nil {
		t.Fatalf("ProjectPublicCreatorDirectoryEntry: %v", err)
	}
	projBytes, _ := publishedKitProjectionJSON(pubProj)
	for _, forbiddenSubstring := range []string{
		tenantA,
		userA,
		"private-owner-a@creativanta.vn",
		"+84901234567",
		"enc_oauth_access_secret_token_never_leak",
		"enc_oauth_refresh_secret_token_never_leak",
		"VIP creator tier",
	} {
		if bytes.Contains(projBytes, []byte(forbiddenSubstring)) {
			t.Fatalf("PUBLIC PRIVACY LEAK: public directory projection leaked %q in %s", forbiddenSubstring, string(projBytes))
		}
	}

	// Non-opt-in or draft media kit is strictly hidden from public directory even with forged tenant header.
	draftKit := publishedKit
	draftKit.DirectoryOptIn = false
	if _, err := internaladmin.ProjectPublicCreatorDirectoryEntry(draftKit, tenantA); !errors.Is(err, internaladmin.ErrPublicProfileNotPublished) {
		t.Fatalf("expected non-opt-in kit to fail with ErrPublicProfileNotPublished, got %v", err)
	}

	// SSRF Protection (security_threat_model.md A10):
	if err := internaladmin.ValidateOutboundWebhookOrImportURL("https://hooks.partner-commerce.vn/v1/order-webhook"); err != nil {
		t.Fatalf("expected valid public HTTPS webhook URL to pass, got %v", err)
	}
	for _, blockedURL := range []string{
		"http://hooks.partner-commerce.vn/v1/insecure",
		"https://user:pass@hooks.partner-commerce.vn/v1/webhook",
		"https://localhost/admin",
		"https://metadata.google.internal/computeMetadata/v1/",
		"https://db.creativanta.internal:5432/",
		"https://127.0.0.1:8080/healthz",
		"https://[::1]:8080/admin",
		"https://10.0.0.15/internal",
		"https://172.16.12.4/secret",
		"https://192.168.1.1/router",
		"https://169.254.169.254/latest/meta-data/iam/",
		"https://100.64.0.10/cgnat",
	} {
		if err := internaladmin.ValidateOutboundWebhookOrImportURL(blockedURL); !errors.Is(err, internaladmin.ErrSSRFBlocked) {
			t.Fatalf("expected SSRF guard to block %q with ErrSSRFBlocked, got %v", blockedURL, err)
		}
	}

	// --- B. TENANT PATH TESTS: Cross-Tenant BOLA, Support Internal Note Stripping, PRIV-2026-02 Self Scope ---
	tenantResourceA := internaladmin.TenantScopedResource{
		ResourceID:            "80000000-0000-4000-8000-000000000001",
		WorkspaceID:           tenantA,
		OwnerUserID:           userA,
		Title:                 "Chiến dịch Tết 2027",
		AccessTokenEncrypted:  "enc_tt_token_a",
		RefreshTokenEncrypted: "enc_tt_refresh_a",
		SupportMessages: []internaladmin.SupportTicketMessageRecord{
			{MessageID: "m1", AuthorType: "user", IsInternalNote: false, Body: "Cần hỗ trợ đối soát đơn"},
			{MessageID: "m2", AuthorType: "admin", IsInternalNote: true, Body: "GHI CHÚ NỘI BỘ: Đang kiểm tra анти-fraud"},
			{MessageID: "m3", AuthorType: "admin", IsInternalNote: false, Body: "Chúng tôi đã tiếp nhận yêu cầu."},
		},
	}

	// Tenant B attempting to access Tenant A's resource (even by passing Tenant A's workspace_id in request) is denied.
	if _, err := internaladmin.AccessTenantScopedResource(tenantB, tenantA, rbac.RoleOwner, tenantResourceA); !errors.Is(err, internaladmin.ErrCrossTenantAccessDenied) {
		t.Fatalf("expected cross-tenant access by Tenant B to fail with ErrCrossTenantAccessDenied, got %v", err)
	}

	// Tenant A accessing its own resource succeeds, and internal support notes are stripped.
	sanitizedView, err := internaladmin.AccessTenantScopedResource(tenantA, tenantA, rbac.RoleOwner, tenantResourceA)
	if err != nil {
		t.Fatalf("AccessTenantScopedResource for Tenant A: %v", err)
	}
	if len(sanitizedView.SupportMessages) != 2 {
		t.Fatalf("expected 2 public support messages (internal note stripped), got %d", len(sanitizedView.SupportMessages))
	}
	for _, m := range sanitizedView.SupportMessages {
		if m.IsInternalNote || strings.Contains(m.Body, "GHI CHÚ NỘI BỘ") {
			t.Fatalf("TENANT PRIVACY LEAK: internal support note leaked to workspace role: %+v", m)
		}
	}

	// PRIV-2026-02: Personal onboarding is strictly user:self.
	if err := internaladmin.EnforcePersonalOnboardingPrivacy(userA, userA, "user:self"); err != nil {
		t.Fatalf("expected user:self onboarding access to pass, got %v", err)
	}
	if err := internaladmin.EnforcePersonalOnboardingPrivacy(userA, userB, "user:self"); !errors.Is(err, internaladmin.ErrPersonalOnboardingSelfScopeViolation) {
		t.Fatalf("expected cross-user onboarding access to fail with ErrPersonalOnboardingSelfScopeViolation, got %v", err)
	}
	if err := internaladmin.EnforcePersonalOnboardingPrivacy(userA, userA, "workspace:settings"); !errors.Is(err, internaladmin.ErrPersonalOnboardingSelfScopeViolation) {
		t.Fatalf("expected workspace:settings scope in personal onboarding to fail, got %v", err)
	}

	// --- C. INTERNAL ADMIN PATH TESTS: EC-M23-003, EC-M23-004, EC-M23-005 & AdminComplianceService ---
	totp, _ := internaladmin.GenerateTOTPCode(mfaSecret, now)
	vpnCtx := internaladmin.WithTrustedVPNTransport(context.Background(), "100.64.0.10")
	supportLogin, err := svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
		Email:       "support@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
	}))
	if err != nil {
		t.Fatalf("support Login: %v", err)
	}
	opsLogin, err := svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
		Email:       "ops@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
	}))
	if err != nil {
		t.Fatalf("ops Login: %v", err)
	}

	supportCtx := internaladmin.WithAdminActor(context.Background(), internaladmin.AdminActorContext{
		SessionID:   supportLogin.Msg.GetSessionId().GetValue(),
		AdminID:     supportAdminID,
		AdminRole:   rbac.AdminRoleSupport,
		VPNVerified: true,
		MFAVerified: true,
	})
	opsCtx := internaladmin.WithAdminActor(context.Background(), internaladmin.AdminActorContext{
		SessionID:   opsLogin.Msg.GetSessionId().GetValue(),
		AdminID:     opsAdminID,
		AdminRole:   rbac.AdminRoleOps,
		VPNVerified: true,
		MFAVerified: true,
	})

	// 1. EC-M23-003 Concurrent Impersonation Block:
	// Support Admin starts an active impersonation session for userA.
	imp1, err := svc.Impersonate(supportCtx, connect.NewRequest(&adminv1.ImpersonateRequest{
		IdempotencyKey:    "idem-p808-imp-1",
		Reason:            "Investigating ticket SUP-808",
		TargetUserId:      &commonv1.UUID{Value: userA},
		TargetWorkspaceId: &commonv1.UUID{Value: tenantA},
		SupportTicketId:   "SUP-808",
	}))
	if err != nil {
		t.Fatalf("first Impersonate: %v", err)
	}
	// Ops Admin attempting concurrent impersonation on the SAME target userA must be blocked!
	_, err = svc.Impersonate(opsCtx, connect.NewRequest(&adminv1.ImpersonateRequest{
		IdempotencyKey:    "idem-p808-imp-2",
		Reason:            "Concurrent impersonation attempt on userA",
		TargetUserId:      &commonv1.UUID{Value: userA},
		TargetWorkspaceId: &commonv1.UUID{Value: tenantA},
	}))
	if connect.CodeOf(err) != connect.CodeAlreadyExists {
		t.Fatalf("expected EC-M23-003 concurrent impersonation on same target user to fail with CodeAlreadyExists, got %v", err)
	}
	// Ending the first impersonation session unblocks Ops Admin.
	if _, err := svc.EndImpersonation(supportCtx, connect.NewRequest(&adminv1.EndImpersonationRequest{
		ImpersonationId: imp1.Msg.GetImpersonationId(),
		Reason:          "Finished ticket SUP-808",
	})); err != nil {
		t.Fatalf("EndImpersonation: %v", err)
	}
	if _, err := svc.Impersonate(opsCtx, connect.NewRequest(&adminv1.ImpersonateRequest{
		IdempotencyKey:    "idem-p808-imp-3",
		Reason:            "Follow-up ops check after support ended session",
		TargetUserId:      &commonv1.UUID{Value: userA},
		TargetWorkspaceId: &commonv1.UUID{Value: tenantA},
	})); err != nil {
		t.Fatalf("expected Impersonate to succeed after previous session ended, got %v", err)
	}

	// 2. EC-M23-004 Admin Override Frequency Alert (>10/day alert; >50/day requires Super Admin approval):
	for i := 1; i <= 10; i++ {
		v, err := svc.RecordAdminOverride(context.Background(), opsAdminID, tenantA, "quota.manual_override", "Approved burst quota", "")
		if err != nil {
			t.Fatalf("override %d failed: %v", i, err)
		}
		if v.SuperAdminReviewAlertFired {
			t.Fatalf("did not expect alert at override %d (<=10)", i)
		}
	}
	// 11th override in 24h triggers SuperAdminReviewAlertFired.
	v11, err := svc.RecordAdminOverride(context.Background(), opsAdminID, tenantA, "quota.manual_override", "Override #11", "")
	if err != nil {
		t.Fatalf("override 11 failed: %v", err)
	}
	if !v11.SuperAdminReviewAlertFired || v11.OverridesInLast24h != 11 {
		t.Fatalf("expected SuperAdminReviewAlertFired on 11th override, got %+v", v11)
	}
	for i := 12; i <= 50; i++ {
		if _, err := svc.RecordAdminOverride(context.Background(), opsAdminID, tenantA, "quota.manual_override", "Bulk override", ""); err != nil {
			t.Fatalf("override %d failed: %v", i, err)
		}
	}
	// 51st override without Super Admin approval token is blocked with ErrOverrideRateLimitRequiresSuperAdmin.
	if _, err := svc.RecordAdminOverride(context.Background(), opsAdminID, tenantA, "quota.manual_override", "Override #51 without approval", ""); !errors.Is(err, internaladmin.ErrOverrideRateLimitRequiresSuperAdmin) {
		t.Fatalf("expected 51st override without approval to fail with ErrOverrideRateLimitRequiresSuperAdmin, got %v", err)
	}
	// Providing Super Admin approval token permits the 51st override.
	v51, err := svc.RecordAdminOverride(context.Background(), opsAdminID, tenantA, "quota.manual_override", "Override #51 with Super Admin approval", "SA-APPROVAL-2026-808")
	if err != nil || !v51.Allowed {
		t.Fatalf("expected 51st override with Super Admin approval to succeed, got %+v, err=%v", v51, err)
	}

	// 3. AdminComplianceService: GDPR/PDPA DSR Export (OAuth tokens redacted), Role Matrix, and 72h Breach Notification:
	dsr, err := svc.CreateDSR(context.Background(), tenantA, userA, "user-a@creativanta.vn", "portability", "PDPA_VN", "Yêu cầu trích xuất dữ liệu cá nhân")
	if err != nil {
		t.Fatalf("CreateDSR: %v", err)
	}
	// Auditor can list DSRs read-only, but CANNOT generate exports or approve deletions.
	dsrList, err := svc.ListDSRs(context.Background(), auditorAdminID, "")
	if err != nil || len(dsrList) != 1 {
		t.Fatalf("expected Auditor to list 1 DSR, got %d, err=%v", len(dsrList), err)
	}
	if _, _, err := svc.GenerateDSRExport(context.Background(), auditorAdminID, dsr.RequestID, map[string]any{"display_name": "User A"}, nil); !errors.Is(err, internaladmin.ErrPrivilegedRoleBoundaryViolation) {
		t.Fatalf("expected Auditor GenerateDSRExport to fail with ErrPrivilegedRoleBoundaryViolation, got %v", err)
	}

	// Ops Admin can generate the GDPR/PDPA export, and all OAuth tokens / secrets / internal notes are stripped.
	_, exportJSON, err := svc.GenerateDSRExport(
		context.Background(),
		opsAdminID,
		dsr.RequestID,
		map[string]any{
			"display_name":            "User A",
			"access_token_encrypted":  "SECRET_ACCESS_TOKEN_MUST_BE_REDACTED",
			"refresh_token_encrypted": "SECRET_REFRESH_TOKEN_MUST_BE_REDACTED",
			"password_hash":           "SECRET_PASSWORD_HASH_MUST_BE_REDACTED",
			"nested_account": map[string]any{
				"platform":     "tiktok",
				"access_token": "NESTED_SECRET_TOKEN_MUST_BE_REDACTED",
			},
		},
		tenantResourceA.SupportMessages,
	)
	if err != nil {
		t.Fatalf("GenerateDSRExport by Ops Admin: %v", err)
	}
	for _, secret := range []string{
		"SECRET_ACCESS_TOKEN_MUST_BE_REDACTED",
		"SECRET_REFRESH_TOKEN_MUST_BE_REDACTED",
		"SECRET_PASSWORD_HASH_MUST_BE_REDACTED",
		"NESTED_SECRET_TOKEN_MUST_BE_REDACTED",
		"GHI CHÚ NỘI BỘ",
	} {
		if bytes.Contains(exportJSON, []byte(secret)) {
			t.Fatalf("GDPR EXPORT PRIVACY LEAK: found %q in export JSON: %s", secret, string(exportJSON))
		}
	}

	// Deletion DSR: Ops Admin cannot approve permanent erasure; only Super Admin with "CONFIRM DELETE" can.
	delDSR, err := svc.CreateDSR(context.Background(), tenantA, userA, "user-a@creativanta.vn", "deletion", "GDPR", "Right to erasure request")
	if err != nil {
		t.Fatalf("CreateDSR deletion: %v", err)
	}
	if _, err := svc.ApproveDSRDeletion(context.Background(), opsAdminID, delDSR.RequestID, "CONFIRM DELETE", "Ops try delete"); !errors.Is(err, internaladmin.ErrPrivilegedRoleBoundaryViolation) {
		t.Fatalf("expected Ops Admin ApproveDSRDeletion to fail with ErrPrivilegedRoleBoundaryViolation, got %v", err)
	}
	if _, err := svc.ApproveDSRDeletion(context.Background(), superAdminID, delDSR.RequestID, "CONFIRM DELETE", "Verified identity and completed 14-day grace period"); err != nil {
		t.Fatalf("expected Super Admin ApproveDSRDeletion to succeed, got %v", err)
	}

	// 72-Hour Breach Notification countdown (Super Admin only):
	breach, err := svc.CreateBreachNotification(
		context.Background(),
		superAdminID,
		"Suspicious API scraping attempt",
		"Anomalous rate of export calls detected and blocked",
		"high",
		now,
		12,
		[]string{"email", "display_name"},
		"Revoked session tokens and rotated API keys",
	)
	if err != nil {
		t.Fatalf("CreateBreachNotification: %v", err)
	}
	if breach.RemainingHoursTo72hDeadline(now.Add(12*time.Hour)) != 60.0 {
		t.Fatalf("expected 60h remaining on 72h breach timer after 12h, got %v", breach.RemainingHoursTo72hDeadline(now.Add(12*time.Hour)))
	}

	// 4. EC-M23-005 Audit Log Sequence Integrity Check:
	intactReport, err := svc.VerifyAuditLogSequenceIntegrity()
	if err != nil || !intactReport.Intact {
		t.Fatalf("expected intact audit sequence before gap injection, got %+v, err=%v", intactReport, err)
	}

	// Simulate an unauthorized sequence gap, then write one more entry and run VerifyAuditLogSequenceIntegrity.
	svc.SimulateAuditSequenceGapForTest(2)
	_, _ = svc.RecordAdminOverride(context.Background(), superAdminID, tenantA, "billing.credit_grant", "Post-gap entry", "SA-APPROVAL")

	gapReport, err := svc.VerifyAuditLogSequenceIntegrity()
	if !errors.Is(err, internaladmin.ErrAuditSequenceIntegrityViolation) {
		t.Fatalf("expected ErrAuditSequenceIntegrityViolation on sequence gap, got %v", err)
	}
	if gapReport.Intact || !gapReport.ReadOnlyLockApplied || !gapReport.Sev1IncidentCreated {
		t.Fatalf("expected Sev1 incident and read-only lock on audit sequence gap, got %+v", gapReport)
	}

	// Once locked read-only by EC-M23-005, further admin overrides must fail closed with ErrAuditLogReadOnlyLocked.
	if _, err := svc.RecordAdminOverride(context.Background(), superAdminID, tenantA, "billing.credit_grant", "Attempt write while locked", "SA-APPROVAL"); !errors.Is(err, internaladmin.ErrAuditLogReadOnlyLocked) {
		t.Fatalf("expected ErrAuditLogReadOnlyLocked after EC-M23-005 lock, got %v", err)
	}
}

func TestP808LoadAndPerformanceSLABenchmarks(t *testing.T) {
	scenarios := []internaladmin.LoadScenarioResult{
		{ScenarioName: "Homepage load", VirtualUsers: 100, RequestsPerSec: 500, P50LatencyMs: 6.2, P95LatencyMs: 92.0, P99LatencyMs: 210.0, ErrorRatePct: 0.01},
		{ScenarioName: "API CRUD mix", VirtualUsers: 200, RequestsPerSec: 1000, P50LatencyMs: 7.8, P95LatencyMs: 118.0, P99LatencyMs: 290.0, ErrorRatePct: 0.02},
		{ScenarioName: "Publish flow", VirtualUsers: 50, RequestsPerSec: 100, P50LatencyMs: 9.5, P95LatencyMs: 175.0, P99LatencyMs: 410.0, ErrorRatePct: 0.00},
		{ScenarioName: "Inbox query", VirtualUsers: 100, RequestsPerSec: 300, P50LatencyMs: 5.4, P95LatencyMs: 88.0, P99LatencyMs: 195.0, ErrorRatePct: 0.01},
		{ScenarioName: "AI generation queue", VirtualUsers: 50, RequestsPerSec: 50, P50LatencyMs: 8.1, P95LatencyMs: 140.0, P99LatencyMs: 320.0, ErrorRatePct: 0.00},
		{ScenarioName: "Concurrent search", VirtualUsers: 100, RequestsPerSec: 200, P50LatencyMs: 9.0, P95LatencyMs: 165.0, P99LatencyMs: 380.0, ErrorRatePct: 0.02},
		{ScenarioName: "Spike test", VirtualUsers: 500, RequestsPerSec: 2500, P50LatencyMs: 24.0, P95LatencyMs: 640.0, P99LatencyMs: 1450.0, ErrorRatePct: 0.35, IsSpikeScenario: true},
		{ScenarioName: "Soak test", VirtualUsers: 100, RequestsPerSec: 400, P50LatencyMs: 7.1, P95LatencyMs: 110.0, P99LatencyMs: 260.0, ErrorRatePct: 0.01, MemoryGrowthPct: 3.4},
	}

	verdict := internaladmin.EvaluateLoadRehearsalBenchmarks(scenarios)
	if !verdict.Passed || verdict.EvaluatedCount != 8 {
		t.Fatalf("expected all 8 canonical load scenarios to pass SLA, got %+v", verdict)
	}

	// Regression on soak memory growth (>10%) or normal error rate (>0.1%) must fail closed.
	regressed := append([]internaladmin.LoadScenarioResult(nil), scenarios...)
	regressed[7].MemoryGrowthPct = 14.5
	badVerdict := internaladmin.EvaluateLoadRehearsalBenchmarks(regressed)
	if badVerdict.Passed || len(badVerdict.FailedScenarios) != 1 {
		t.Fatalf("expected soak memory leak scenario to fail SLA check, got %+v", badVerdict)
	}
}

func publishedKitProjectionJSON(p internaladmin.PublicCreatorDirectoryProjection) ([]byte, error) {
	return json.Marshal(p)
}

type mockDisposableProxyTarget struct {
	switchedSlot   string
	switchedDigest string
	rolledBackSlot string
	failSwitch     bool
}

func (m *mockDisposableProxyTarget) SwitchUpstream(_ context.Context, slot, imageDigest string) error {
	if m.failSwitch {
		return errors.New("proxy upstream reload failed")
	}
	m.switchedSlot = slot
	m.switchedDigest = imageDigest
	return nil
}

func (m *mockDisposableProxyTarget) RollbackUpstream(_ context.Context, previousSlot, _ string) error {
	m.rolledBackSlot = previousSlot
	return nil
}

func openOptionalPostgresForRehearsalTest(t *testing.T) *pgxpool.Pool {
	t.Helper()
	candidates := []string{
		strings.TrimSpace(os.Getenv("CREATIVANTA_TEST_DATABASE_URL")),
		strings.TrimSpace(os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")),
		strings.TrimSpace(os.Getenv("DATABASE_URL")),
		"postgres://postgres:postgres@127.0.0.1:5432/postgres?sslmode=disable",
	}
	for _, dsn := range candidates {
		if dsn == "" {
			continue
		}
		ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
		pool, err := pgxpool.New(ctx, dsn)
		if err != nil {
			cancel()
			continue
		}
		if err := pool.Ping(ctx); err != nil {
			pool.Close()
			cancel()
			continue
		}
		cancel()
		t.Cleanup(func() {
			pool.Close()
		})
		return pool
	}

	if conn, err := net.DialTimeout("tcp", "127.0.0.1:15432", 1*time.Second); err == nil {
		_ = conn.Close()
		var randBytes [4]byte
		_, _ = rand.Read(randBytes[:])
		suffix := hex.EncodeToString(randBytes[:])
		roleName := "creativanta_p808_role_" + suffix
		dbName := "creativanta_p808_db_" + suffix
		rolePass := "tmp_pw_" + suffix

		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		createCmd := exec.CommandContext(ctx, "docker", "exec", "creativanta-p0-postgres-1",
			"psql", "-U", "creativanta_dev", "-d", "creativanta_dev", "-v", "ON_ERROR_STOP=1",
			"-c", fmt.Sprintf("CREATE ROLE %s WITH LOGIN SUPERUSER PASSWORD '%s';", roleName, rolePass),
			"-c", fmt.Sprintf("CREATE DATABASE %s OWNER %s;", dbName, roleName),
		)
		if err := createCmd.Run(); err == nil {
			dsn := fmt.Sprintf("postgres://%s:%s@127.0.0.1:15432/%s?sslmode=disable", roleName, rolePass, dbName)
			pool, err := pgxpool.New(ctx, dsn)
			if err == nil && pool.Ping(ctx) == nil {
				t.Cleanup(func() {
					pool.Close()
					cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 10*time.Second)
					defer cleanCancel()
					_ = exec.CommandContext(cleanCtx, "docker", "exec", "creativanta-p0-postgres-1",
						"psql", "-U", "creativanta_dev", "-d", "creativanta_dev",
						"-c", fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE);", dbName),
						"-c", fmt.Sprintf("DROP ROLE IF EXISTS %s;", roleName),
					).Run()
				})
				return pool
			}
			if pool != nil {
				pool.Close()
			}
		}
	}
	return nil
}

func TestP808SecondPassRegression_ReleaseF3_NeverCopiesExpectedToObserved(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	const (
		superAdminID = "90000000-0000-4000-8000-000000000001"
		wsA          = "22222222-2222-4222-8222-222222222201"
		greenDigest  = "sha256:f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3"
	)
	if err := svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      superAdminID,
		Email:        "super-f3@internal.creativanta.vn",
		FullName:     "Super Admin F3",
		PasswordHash: internaladmin.HashAdminPassword("Super-Restore-2026!"),
		AdminRole:    rbac.AdminRoleSuper,
		MFASecret:    "JBSWY3DPEHPK3PXP",
		MFAEnabled:   true,
		Status:       "active",
	}); err != nil {
		t.Fatalf("RegisterAdmin: %v", err)
	}

	// Case 1: Candidate server only serves /healthz, /readyz, /api/workspaces/discovery, and DiagnosticsService/GetOverview,
	// while ProfitService/GetSummary, AdminBillingService/GetCreditBalance, and SystemConfigService/GetDashboard are unmounted (404).
	// Previously (Release F3), ExecuteLiveBlueGreenReleaseSmokeRehearsal copied expectedNetProfitMicro and expectedCreditsBalance
	// into SmokeObservedNetProfitMicro and SmokeObservedCreditsBalance, creating a false release pass!
	unmountedFinanceServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/healthz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"alive","role":"api"}`))
		case "/readyz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"ready","role":"api"}`))
		case "/api/workspaces/discovery":
			if r.Header.Get("Authorization") != "Bearer valid-smoke-token" {
				w.WriteHeader(http.StatusUnauthorized)
				return
			}
			w.Header().Set("Content-Type", "application/json")
			_, _ = w.Write([]byte(`{"workspaces":[{"workspace_id":"` + wsA + `","name":"Primary"}]}`))
		case "/creativanta.admin.v1.DiagnosticsService/GetOverview":
			if r.Header.Get("Authorization") != "Bearer valid-smoke-token" {
				w.WriteHeader(http.StatusUnauthorized)
				return
			}
			w.Header().Set("Content-Type", "application/json")
			_, _ = w.Write([]byte(`{"workspaceId":{"value":"` + wsA + `"},"overallStatus":"DIAGNOSTIC_HEALTH_STATUS_HEALTHY","totalCategoriesCount":4,"healthyCategoriesCount":4}`))
		default:
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer unmountedFinanceServer.Close()

	proxy := &mockDisposableProxyTarget{}
	verdict, err := svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"green",
		greenDigest,
		unmountedFinanceServer.URL,
		"valid-smoke-token",
		wsA,
		15000000000,
		2420,
		proxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || verdict.FailureCode != "SMOKE_METRICS_UNOBSERVED" {
		t.Fatalf("Release F3 regression: expected ErrReleaseSmokeFailed [SMOKE_METRICS_UNOBSERVED] when finance/billing/audit endpoints are unmounted, got err=%v verdict=%+v", err, verdict)
	}
	if verdict.CandidatePromoted || !verdict.RollbackTriggered || verdict.ProxyUpstreamSwitched || proxy.switchedSlot != "" {
		t.Fatalf("Release F3 regression: unmounted finance/billing endpoints must fail closed and trigger rollback, got verdict=%+v proxy=%+v", verdict, proxy)
	}

	// Case 2: Empty in-memory diagnostics (totalCategoriesCount == 0) or non-zero unknownExternalEffectsCount
	// must fail closed with SMOKE_DIAGNOSTICS_UNHEALTHY.
	var (
		diagPayload   = `{"workspaceId":{"value":"` + wsA + `"},"overallStatus":"DIAGNOSTIC_HEALTH_STATUS_HEALTHY","totalCategoriesCount":0,"healthyCategoriesCount":0}`
		profitPayload = `{"snapshot":{"workspaceId":"` + wsA + `","isIncomplete":false,"unknownRequiredComponentsCount":0,"netProfit":{"currencyCode":"VND","amount":"15000.00"}}}`
		creditPayload = `{"balance":{"workspaceId":{"value":"` + wsA + `"},"totalRemaining":"2420"}}`
		sysPayload    = `{"maintenanceMode":false,"activeKillSwitchesCount":0,"auditLogEntriesCount":"2","auditSequenceIntact":true}`
	)
	configurableSrv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/healthz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"alive","role":"api"}`))
		case "/readyz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"ready","role":"api"}`))
		case "/api/workspaces/discovery":
			if r.Header.Get("Authorization") != "Bearer valid-smoke-token" {
				w.WriteHeader(http.StatusUnauthorized)
				return
			}
			w.Header().Set("Content-Type", "application/json")
			_, _ = w.Write([]byte(`{"workspaces":[{"workspace_id":"` + wsA + `","name":"Primary"}]}`))
		case "/creativanta.admin.v1.DiagnosticsService/GetOverview":
			w.Header().Set("Content-Type", "application/json")
			_, _ = w.Write([]byte(diagPayload))
		case "/creativanta.finance.v1.ProfitService/GetSummary":
			w.Header().Set("Content-Type", "application/json")
			_, _ = w.Write([]byte(profitPayload))
		case "/creativanta.admin.v1.AdminBillingService/GetCreditBalance":
			w.Header().Set("Content-Type", "application/json")
			_, _ = w.Write([]byte(creditPayload))
		case "/creativanta.admin.v1.SystemConfigService/GetDashboard":
			w.Header().Set("Content-Type", "application/json")
			_, _ = w.Write([]byte(sysPayload))
		default:
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer configurableSrv.Close()

	verdict, err = svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"green",
		greenDigest,
		configurableSrv.URL,
		"valid-smoke-token",
		wsA,
		15000000000,
		2420,
		proxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || verdict.FailureCode != "SMOKE_DIAGNOSTICS_UNHEALTHY" || verdict.CandidatePromoted {
		t.Fatalf("expected SMOKE_DIAGNOSTICS_UNHEALTHY on empty in-memory diagnostics (totalCategories=0), got err=%v verdict=%+v", err, verdict)
	}

	// Restore healthy diagnostics, then test mismatched observed profit ("50.00" vs expected 15000000000 micro-units).
	diagPayload = `{"workspaceId":{"value":"` + wsA + `"},"overallStatus":"DIAGNOSTIC_HEALTH_STATUS_HEALTHY","totalCategoriesCount":4,"healthyCategoriesCount":4}`
	profitPayload = `{"snapshot":{"workspaceId":"` + wsA + `","isIncomplete":false,"unknownRequiredComponentsCount":0,"netProfit":{"currencyCode":"VND","amount":"50.00"}}}`
	verdict, err = svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"green",
		greenDigest,
		configurableSrv.URL,
		"valid-smoke-token",
		wsA,
		15000000000,
		2420,
		proxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || verdict.FailureCode != "SMOKE_PROFIT_LEDGER_MISMATCH" || verdict.CandidatePromoted {
		t.Fatalf("expected SMOKE_PROFIT_LEDGER_MISMATCH on mismatched observed profit, got err=%v verdict=%+v", err, verdict)
	}

	// Restore matching profit, then test mismatched observed credits ("2000" vs expected 2420).
	profitPayload = `{"snapshot":{"workspaceId":"` + wsA + `","isIncomplete":false,"unknownRequiredComponentsCount":0,"netProfit":{"currencyCode":"VND","amount":"15000.00"}}}`
	creditPayload = `{"balance":{"workspaceId":{"value":"` + wsA + `"},"totalRemaining":"2000"}}`
	verdict, err = svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"green",
		greenDigest,
		configurableSrv.URL,
		"valid-smoke-token",
		wsA,
		15000000000,
		2420,
		proxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || verdict.FailureCode != "SMOKE_CREDITS_BALANCE_MISMATCH" || verdict.CandidatePromoted {
		t.Fatalf("expected SMOKE_CREDITS_BALANCE_MISMATCH on mismatched observed credit balance, got err=%v verdict=%+v", err, verdict)
	}

	// Restore matching credits, then test broken audit sequence on SystemConfigService/GetDashboard.
	creditPayload = `{"balance":{"workspaceId":{"value":"` + wsA + `"},"totalRemaining":"2420"}}`
	sysPayload = `{"maintenanceMode":false,"activeKillSwitchesCount":0,"auditLogEntriesCount":"2","auditSequenceIntact":false}`
	verdict, err = svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"green",
		greenDigest,
		configurableSrv.URL,
		"valid-smoke-token",
		wsA,
		15000000000,
		2420,
		proxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || verdict.FailureCode != "SMOKE_METRICS_UNOBSERVED" || verdict.CandidatePromoted {
		t.Fatalf("expected SMOKE_METRICS_UNOBSERVED when candidate auditSequenceIntact=false, got err=%v verdict=%+v", err, verdict)
	}

	// Case 3: /smoke endpoint that fails to reject unauthenticated requests (returns 200 OK without Bearer token)
	// or omits net_profit_micro / credits_balance in JSON must fail closed.
	unprotectedSmokeSrv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/healthz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"ok"}`))
		case "/readyz":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"status":"ready"}`))
		case "/smoke":
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(`{"workspace_id":"` + wsA + `","net_profit_micro":15000000000,"credits_balance":2420,"audit_sequence_intact":true}`))
		default:
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer unprotectedSmokeSrv.Close()

	verdict, err = svc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		context.Background(),
		superAdminID,
		"green",
		greenDigest,
		unprotectedSmokeSrv.URL,
		"valid-smoke-token",
		wsA,
		15000000000,
		2420,
		proxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || verdict.FailureCode != "SMOKE_AUTH_UNAUTHORIZED" || verdict.CandidatePromoted {
		t.Fatalf("expected SMOKE_AUTH_UNAUTHORIZED when /smoke accepts unauthenticated requests, got err=%v verdict=%+v", err, verdict)
	}
}

func TestP808SecondPassRegression_ReleaseF4DataF9_DeletedTempFixtureRejected(t *testing.T) {
	pool := openOptionalPostgresForRehearsalTest(t)
	if pool == nil {
		t.Skip("PostgreSQL not available for Release F4 / Data F9 test")
	}
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 4, 21, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }
	const (
		superAdminID = "90000000-0000-4000-8000-000000000001"
		wsA          = "22222222-2222-4222-8222-222222222201"
		wsB          = "22222222-2222-4222-8222-222222222202"
		ownerA       = "11111111-1111-4111-8111-111111111101"
		ownerB       = "11111111-1111-4111-8111-111111111102"
	)
	if err := svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      superAdminID,
		Email:        "super-f4@internal.creativanta.vn",
		FullName:     "Super Admin F4",
		PasswordHash: internaladmin.HashAdminPassword("Super-Restore-2026!"),
		AdminRole:    rbac.AdminRoleSuper,
		MFASecret:    "JBSWY3DPEHPK3PXP",
		MFAEnabled:   true,
		Status:       "active",
	}); err != nil {
		t.Fatalf("RegisterAdmin: %v", err)
	}

	prodSnap := internaladmin.DatabaseSnapshot{
		SnapshotID:     "20261104T210000Z-p808-f4",
		Environment:    "production",
		CreatedAt:      now,
		WALPositionLSN: "0/18B4F28",
		Workspaces: []internaladmin.WorkspaceSnapshot{
			{
				WorkspaceID:        wsA,
				Name:               "Creator Studio Alpha",
				Slug:               "creator-studio-alpha",
				OwnerUserID:        ownerA,
				AICreditsRemaining: 2420,
				Status:             "active",
			},
			{
				WorkspaceID:        wsB,
				Name:               "Brand Commerce Beta",
				Slug:               "brand-commerce-beta",
				OwnerUserID:        ownerB,
				AICreditsRemaining: 5000,
				Status:             "active",
			},
		},
		FinancialPostings: []internaladmin.FinancialPostingSnapshot{
			{
				PostingID:      "30000000-0000-4000-8000-000000000001",
				WorkspaceID:    wsA,
				AccountCode:    "1100_CASH_CLEARING",
				Direction:      "debit",
				AmountMicro:    15000000000,
				Currency:       "VND",
				IdempotencyKey: "idem-post-1",
				CreatedAt:      now.Add(-10 * time.Minute),
			},
			{
				PostingID:      "30000000-0000-4000-8000-000000000002",
				WorkspaceID:    wsA,
				AccountCode:    "4000_MERCHANT_REVENUE",
				Direction:      "credit",
				AmountMicro:    15000000000,
				Currency:       "VND",
				IdempotencyKey: "idem-post-1",
				CreatedAt:      now.Add(-10 * time.Minute),
			},
		},
		AICreditLots: []internaladmin.AICreditLotSnapshot{
			{
				LotID:            "40000000-0000-4000-8000-000000000001",
				WorkspaceID:      wsA,
				InitialCredits:   3000,
				RemainingCredits: 2420,
				LotType:          "subscription_monthly",
				ExpiresAt:        now.Add(20 * 24 * time.Hour),
			},
			{
				LotID:            "40000000-0000-4000-8000-000000000002",
				WorkspaceID:      wsB,
				InitialCredits:   5000,
				RemainingCredits: 5000,
				LotType:          "topup_pack",
				ExpiresAt:        now.Add(90 * 24 * time.Hour),
			},
		},
		EvidenceObjects: []internaladmin.EvidenceObjectSnapshot{
			{
				EvidenceID:    "50000000-0000-4000-8000-000000000001",
				WorkspaceID:   wsA,
				Category:      "dispute_receipt",
				ContentSHA256: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
				StorageURI:    "s3://creativanta-evidence/wsA/ev1.pdf",
				RetentionLock: now.Add(365 * 24 * time.Hour),
			},
		},
		AuditEntries: []internaladmin.AuditSequenceEntrySnapshot{
			{
				AuditID:        "60000000-0000-4000-8000-000000000001",
				SequenceNumber: 1,
				EntryHash:      "a111111111111111111111111111111111111111111111111111111111111111",
				AdminID:        superAdminID,
				Action:         "admin.login",
				CreatedAt:      now.Add(-30 * time.Minute),
			},
		},
	}
	prodArtifact, err := internaladmin.CreateVerifiedBackupSnapshot(t.TempDir(), prodSnap)
	if err != nil {
		t.Fatalf("CreateVerifiedBackupSnapshot: %v", err)
	}

	// 1. Temporary fixtures (empty TargetSchema, pg_temp*, or TempFixtureOnly=true) MUST be rejected with ErrOperationalTargetRequired
	// for production and staging snapshots.
	for _, tc := range []struct {
		name   string
		target *internaladmin.PostgresDisposableDBTarget
	}{
		{
			name:   "empty_schema",
			target: &internaladmin.PostgresDisposableDBTarget{Pool: pool},
		},
		{
			name:   "pg_temp_schema",
			target: &internaladmin.PostgresDisposableDBTarget{Pool: pool, TargetSchema: "pg_temp"},
		},
		{
			name:   "temp_fixture_only_flag",
			target: &internaladmin.PostgresDisposableDBTarget{Pool: pool, TargetSchema: "rehearsal_p808_temp_flag", TempFixtureOnly: true},
		},
	} {
		if rec, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, tc.target); !errors.Is(err, internaladmin.ErrOperationalTargetRequired) {
			t.Fatalf("Release F4 / Data F9 regression [%s]: expected ErrOperationalTargetRequired, got err=%v rec=%+v", tc.name, err, rec)
		}
	}

	// 2. Reserved or invalid schema names ("public", "pg_catalog", SQL injection attempt) must fail closed with ErrRestoreIntegrityFailed.
	for _, invalidSchema := range []string{"public", "pg_catalog", "information_schema", "rehearsal; DROP SCHEMA public"} {
		if _, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, &internaladmin.PostgresDisposableDBTarget{
			Pool:         pool,
			TargetSchema: invalidSchema,
		}); !errors.Is(err, internaladmin.ErrRestoreIntegrityFailed) {
			t.Fatalf("expected ErrRestoreIntegrityFailed for invalid/reserved schema %q, got %v", invalidSchema, err)
		}
	}

	// 3. Persistent TargetSchema ("rehearsal_p808_verify") materializes permanent tables with FORCE RLS,
	// commits them, verifies them on post-commit transactions, and keeps them queryable after ExecuteDisposableRestoreRehearsal returns!
	persistentTarget := &internaladmin.PostgresDisposableDBTarget{
		Pool:         pool,
		TargetSchema: "rehearsal_p808_verify",
	}
	t.Cleanup(func() {
		_ = persistentTarget.Cleanup(context.Background())
	})

	rec, err := svc.ExecuteDisposableRestoreRehearsal(context.Background(), superAdminID, prodArtifact, 0, persistentTarget)
	if err != nil {
		t.Fatalf("ExecuteDisposableRestoreRehearsal with persistent schema failed: %v", err)
	}
	if rec.ExecutionMode != internaladmin.RehearsalModeDisposableTargetVerified ||
		rec.IsSimulation ||
		!rec.OperationalRestorePerformed ||
		!rec.PersistentSchemaVerified ||
		!rec.RLSIsolationVerified ||
		!rec.PostCommitSmokeVerified ||
		!rec.SmokePassed ||
		rec.RestoredSchemaName != "rehearsal_p808_verify" {
		t.Fatalf("expected verified persistent restore record, got %+v", rec)
	}
	if rec.ProductionDRGateApproved || rec.ProductionReleaseGateApproved {
		t.Fatalf("external production DR/release gates must remain explicitly unapproved, got %+v", rec)
	}

	// 4. Independent post-restore verification on a brand-new transaction AFTER ExecuteDisposableRestoreRehearsal returned:
	// Prove that the restored tables were NOT dropped on commit and that RLS is enforced!
	verifyTx, err := pool.Begin(context.Background())
	if err != nil {
		t.Fatalf("begin independent post-restore verification tx: %v", err)
	}
	defer func() { _ = verifyTx.Rollback(context.Background()) }()

	if _, err := verifyTx.Exec(context.Background(), `SET LOCAL ROLE rehearsal_p808_rls_probe`); err != nil {
		t.Fatalf("assume non-superuser role on post-restore schema: %v", err)
	}
	if _, err := verifyTx.Exec(context.Background(), `SELECT set_config('app.current_tenant_id', '', true)`); err != nil {
		t.Fatalf("clear tenant context: %v", err)
	}
	var emptyTenantWSCount int
	if err := verifyTx.QueryRow(context.Background(), `SELECT COUNT(*) FROM rehearsal_p808_verify.workspaces`).Scan(&emptyTenantWSCount); err != nil {
		t.Fatalf("query workspaces with empty tenant context after restore: %v", err)
	}
	if emptyTenantWSCount != 0 {
		t.Fatalf("expected 0 visible workspaces with empty tenant context under RLS, got %d", emptyTenantWSCount)
	}

	if _, err := verifyTx.Exec(context.Background(), `SELECT set_config('app.current_tenant_id', $1, true)`, wsA); err != nil {
		t.Fatalf("set tenant context to wsA: %v", err)
	}
	var wsAVisibleCount int
	if err := verifyTx.QueryRow(context.Background(), `SELECT COUNT(*) FROM rehearsal_p808_verify.workspaces`).Scan(&wsAVisibleCount); err != nil {
		t.Fatalf("query workspaces with wsA tenant context after restore: %v", err)
	}
	if wsAVisibleCount != 1 {
		t.Fatalf("expected exactly 1 visible workspace for wsA (out of 2 restored workspaces), got %d", wsAVisibleCount)
	}
}

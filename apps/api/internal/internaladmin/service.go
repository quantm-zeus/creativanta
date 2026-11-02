// Package internaladmin implements the P0-07 Internal Admin Panel isolation boundary (S26):
//   - Isolated Admin Listener authentication (separate from workspace Clerk sessions),
//     requiring Tailscale/WireGuard VPN verification + RFC 6238 TOTP MFA (8-hour session TTL)
//   - Strict listener boundary guard: workspace roles (owner..external) are rejected on
//     the admin listener, and admin RPCs are rejected on the workspace listener
//   - Read-only Impersonation (AdminAuthService/Impersonate, EndImpersonation) with 30-minute
//     auto-expiry, dual audit logging, and strict rejection of any mutating action during impersonation
//   - Moderation Queue & Rules Engine (ModerationService/ListCases, ActOnCase) with
//     normalized 0-100 risk bands, non-overridable hard-block categories (SAFE-2026-02),
//     4h/24h/72h SLA deadlines, and conflict-of-interest self-review prevention (EC-S26-002)
//   - Feature Flag & Emergency Kill Switch registry (SystemConfigService/GetDashboard,
//     ToggleFlag, ToggleMaintenance) implementing capability.KillSwitchChecker so tripped
//     kill switches immediately halt unverified/external connector execution.
//
// Canonical references:
//   - docs/02_features/platform/internal_admin.md
//   - docs/02_features/platform/capability_matrix.md
//   - docs/04_contracts/database_schema.md (§15 internal_admins, admin_sessions, impersonation_sessions,
//     internal_audit_logs, moderation_cases, fraud_cases, feature_flags, incidents, system_alerts)
//   - docs/04_contracts/rbac_permission_matrix.md (§3 Internal Admin Roles & Permissions)
//   - docs/04_contracts/rpc_permission_bindings.csv
//   - docs/06_quality_ops/moderation_rules_engine.md
package internaladmin

import (
	"context"
	"crypto/hmac"
	"crypto/rand"
	"crypto/sha1"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/base32"
	"encoding/binary"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

const (
	// AdminSessionTTL is the maximum lifetime of an MFA-verified internal admin session (RULE-S26-001).
	AdminSessionTTL = 8 * time.Hour
	// ImpersonationSessionTTL is the strict 30-minute maximum lifetime of a read-only impersonation session (RULE-S26-002).
	ImpersonationSessionTTL = 30 * time.Minute
)

var (
	// ErrVPNRequired is returned when an admin login or request does not come from the verified VPN mesh.
	ErrVPNRequired = errors.New("internaladmin: private VPN mesh verification required (ADMIN_FORBIDDEN_001)")
	// ErrMFARequired is returned when TOTP MFA is missing or invalid.
	ErrMFARequired = errors.New("internaladmin: valid TOTP MFA code required (ADMIN_FORBIDDEN_001)")
	// ErrInvalidAdminCredentials is returned when admin email/password or status is invalid.
	ErrInvalidAdminCredentials = errors.New("internaladmin: invalid admin credentials or suspended account (AUTH_FORBIDDEN_001)")
	// ErrWorkspaceRoleRejectedOnAdminListener is returned when a workspace role or workspace session calls the admin listener.
	ErrWorkspaceRoleRejectedOnAdminListener = errors.New("internaladmin: workspace role cannot call isolated admin listener (ADMIN_FORBIDDEN_001)")
	// ErrAdminRPCOnWorkspaceListener is returned when an admin-family RPC is invoked on the public workspace listener.
	ErrAdminRPCOnWorkspaceListener = errors.New("internaladmin: admin RPC cannot execute on workspace listener (ADMIN_FORBIDDEN_001)")
	// ErrAdminSessionExpired is returned when an admin session is missing, expired, or revoked.
	ErrAdminSessionExpired = errors.New("internaladmin: admin session missing, expired, or revoked (AUTH_FORBIDDEN_001)")
	// ErrImpersonationExpired is returned when a 30-minute impersonation session has expired or ended.
	ErrImpersonationExpired = errors.New("internaladmin: impersonation session expired or ended (AUTH_FORBIDDEN_001)")
	// ErrSupportTicketRequired is returned when support_admin initiates impersonation without a scoped ticket.
	ErrSupportTicketRequired = errors.New("internaladmin: support_admin impersonation requires an active support ticket reference")
	// ErrSelfReviewConflict is returned when an admin attempts to review/resolve a moderation case involving their own user account (EC-S26-002).
	ErrSelfReviewConflict = errors.New("internaladmin: conflict of interest — admin cannot review own moderation case (ADMIN_CONFLICT_001)")
	// ErrHardBlockNonOverridable is returned when a workspace role attempts to override a non-overridable hard-block moderation category (SAFE-2026-02).
	ErrHardBlockNonOverridable = errors.New("internaladmin: hard-block safety category cannot be overridden by workspace role (MOD_BLOCKED_001)")
	// ErrCaseNotFound is returned when a moderation case ID does not exist.
	ErrCaseNotFound = errors.New("internaladmin: moderation case not found (ADMIN_NOTFOUND_001)")
	// ErrInvalidInput is returned when required request fields are missing or malformed.
	ErrInvalidInput = errors.New("internaladmin: invalid input (SYSTEM_INVALID_001)")
	// ErrIdempotencyConflict is returned when an idempotency key is reused with a different request payload.
	ErrIdempotencyConflict = errors.New("internaladmin: idempotency key reused with different payload (SYSTEM_CONFLICT_001)")
)

// RiskBand represents the normalized 0-100 moderation risk band from moderation_rules_engine.md.
type RiskBand string

const (
	RiskBandAllow       RiskBand = "allow"        // 0-24
	RiskBandHumanReview RiskBand = "human_review" // 25-59
	RiskBandBlock       RiskBand = "block"        // 60-100
)

// HardBlockCategories lists the non-overridable safety categories from docs/06_quality_ops/moderation_rules_engine.md (SAFE-2026-02).
var HardBlockCategories = map[string]string{
	"sexual_minors":               "Exploitation or sexualization of minors",
	"phishing_malware":            "Fraudulent phishing, credential harvesting, or malware distribution",
	"credible_violent_threat":     "Credible violent threats, terrorism, or incitement",
	"self_harm_instruction":       "Self-harm encouragement or instruction",
	"doxxing_pii":                 "Non-consensual intimate imagery or doxxing of private personal data",
	"revoked_clone_consent":       "Impersonation or voice/face clone without active verified consent",
	"unlicensed_rights_violation": "Direct copyright/trademark counterfeit or unlicensed music redistribution",
}

// IsHardBlockCategory reports whether category is a non-overridable hard-block category.
func IsHardBlockCategory(category string) bool {
	_, ok := HardBlockCategories[strings.ToLower(strings.TrimSpace(category))]
	return ok
}

// ModerationEvaluation captures the result of evaluating content against the Moderation Rules Engine.
type ModerationEvaluation struct {
	NormalizedScore   int32
	Band              RiskBand
	HardBlock         bool
	HardBlockReason   string
	OverridableByUser bool
}

// EvaluateModerationRisk evaluates a raw 0-100 risk score and category against SAFE-2026-02.
func EvaluateModerationRisk(score int32, category string) ModerationEvaluation {
	if score < 0 {
		score = 0
	}
	if score > 100 {
		score = 100
	}
	cat := strings.ToLower(strings.TrimSpace(category))
	if reason, hard := HardBlockCategories[cat]; hard {
		if score < 95 {
			score = 100
		}
		return ModerationEvaluation{
			NormalizedScore:   score,
			Band:              RiskBandBlock,
			HardBlock:         true,
			HardBlockReason:   reason,
			OverridableByUser: false,
		}
	}
	switch {
	case score >= 60:
		return ModerationEvaluation{
			NormalizedScore:   score,
			Band:              RiskBandBlock,
			HardBlock:         false,
			OverridableByUser: false,
		}
	case score >= 25:
		return ModerationEvaluation{
			NormalizedScore:   score,
			Band:              RiskBandHumanReview,
			HardBlock:         false,
			OverridableByUser: true,
		}
	default:
		return ModerationEvaluation{
			NormalizedScore:   score,
			Band:              RiskBandAllow,
			HardBlock:         false,
			OverridableByUser: true,
		}
	}
}

// ComputeModerationSLA computes the SLA deadline per RULE-S26-006:
//   - critical: 4 hours
//   - high:     24 hours
//   - medium:   72 hours
//   - low:      72 hours
func ComputeModerationSLA(severity string, createdAt time.Time) time.Time {
	switch strings.ToLower(strings.TrimSpace(severity)) {
	case "critical":
		return createdAt.Add(4 * time.Hour)
	case "high":
		return createdAt.Add(24 * time.Hour)
	default:
		return createdAt.Add(72 * time.Hour)
	}
}

// GenerateTOTPCode computes the 6-digit RFC 6238 TOTP code for a base32 secret at timestamp t.
func GenerateTOTPCode(base32Secret string, t time.Time) (string, error) {
	cleaned := strings.ToUpper(strings.TrimSpace(strings.ReplaceAll(base32Secret, " ", "")))
	if cleaned == "" {
		return "", ErrMFARequired
	}
	secretBytes, err := base32.StdEncoding.WithPadding(base32.NoPadding).DecodeString(strings.TrimRight(cleaned, "="))
	if err != nil || len(secretBytes) == 0 {
		return "", ErrMFARequired
	}
	counter := uint64(t.Unix() / 30)
	var buf [8]byte
	binary.BigEndian.PutUint64(buf[:], counter)
	mac := hmac.New(sha1.New, secretBytes)
	_, _ = mac.Write(buf[:])
	sum := mac.Sum(nil)
	offset := sum[len(sum)-1] & 0x0f
	binCode := (int(sum[offset])&0x7f)<<24 |
		(int(sum[offset+1])&0xff)<<16 |
		(int(sum[offset+2])&0xff)<<8 |
		(int(sum[offset+3]) & 0xff)
	otp := binCode % 1000000
	return fmt.Sprintf("%06d", otp), nil
}

// ValidateTOTPCode verifies a 6-digit TOTP code allowing a +/- 1 step (30s) clock drift window.
func ValidateTOTPCode(base32Secret, code string, now time.Time) bool {
	trimmed := strings.TrimSpace(code)
	if len(trimmed) != 6 {
		return false
	}
	for _, offset := range []time.Duration{-30 * time.Second, 0, 30 * time.Second} {
		expected, err := GenerateTOTPCode(base32Secret, now.Add(offset))
		if err == nil && subtle.ConstantTimeCompare([]byte(expected), []byte(trimmed)) == 1 {
			return true
		}
	}
	return false
}

// InternalAdminRecord mirrors the canonical internal_admins table (§15 of database_schema.md).
type InternalAdminRecord struct {
	AdminID      string
	Email        string
	FullName     string
	PasswordHash string
	AdminRole    string // super_admin, ops_admin, finance_admin, content_admin, support_admin, tech_admin, analyst, auditor
	MFASecret    string
	MFAEnabled   bool
	Status       string // active, suspended, revoked
	LinkedUserID string // optional workspace user_id for conflict-of-interest detection (EC-S26-002)
	LastLoginAt  time.Time
	CreatedAt    time.Time
}

// AdminSessionRecord mirrors the canonical admin_sessions table (§15 of database_schema.md).
type AdminSessionRecord struct {
	SessionID   string
	AdminID     string
	AdminRole   string
	TokenHash   string
	IPAddress   string
	UserAgent   string
	VPNVerified bool
	MFAVerified bool
	CreatedAt   time.Time
	ExpiresAt   time.Time
	RevokedAt   *time.Time
}

// ImpersonationSessionRecord mirrors the canonical impersonation_sessions table (§15 of database_schema.md).
type ImpersonationSessionRecord struct {
	ImpersonationID   string
	AdminID           string
	AdminRole         string
	TargetUserID      string
	TargetWorkspaceID string
	Reason            string
	SupportTicketID   string
	Mode              string // strictly "read_only"
	ActionsCount      int32
	StartedAt         time.Time
	ExpiresAt         time.Time
	EndedAt           *time.Time
}

// InternalAuditLogRecord mirrors the canonical internal_audit_logs table (§15 of database_schema.md).
type InternalAuditLogRecord struct {
	AuditID           string
	AdminID           string
	AdminRole         string
	Action            string
	TargetType        string
	TargetID          string
	TargetWorkspaceID string
	Reason            string
	BeforeState       map[string]any
	AfterState        map[string]any
	IPAddress         string
	CreatedAt         time.Time
}

// ModerationCaseRecord mirrors the canonical moderation_cases table (§15 of database_schema.md).
type ModerationCaseRecord struct {
	CaseID          string
	WorkspaceID     string
	ContentType     string
	ContentID       string
	Category        string
	FlagSource      string
	Severity        string
	RiskScore       int32
	RiskBand        RiskBand
	HardBlock       bool
	Status          string // pending, in_review, approved, rejected, escalated
	FlaggedUserID   string
	ReporterUserID  string
	AssignedAdminID string
	Decision        string
	DecisionReason  string
	SLADueAt        time.Time
	CreatedAt       time.Time
	ResolvedAt      *time.Time
}

// FeatureFlagRecord mirrors the canonical feature_flags table (§15 of database_schema.md).
type FeatureFlagRecord struct {
	FlagID            string
	FlagKey           string
	Name              string
	Description       string
	Status            string // enabled, disabled, percentage_rollout
	Enabled           bool
	RolloutPercentage int32
	IsKillSwitch      bool
	UpdatedByAdminID  string
	Reason            string
	UpdatedAt         time.Time
}

// AdminActorContext represents the verified internal admin caller in context.
type AdminActorContext struct {
	SessionID        string
	AdminID          string
	AdminRole        string
	VPNVerified      bool
	MFAVerified      bool
	IPAddress        string
	SupportTicketID  string
	WorkspaceRoleTry string // populated only if a caller illegally passes a workspace role
}

type adminActorContextKey struct{}

// WithAdminActor attaches an AdminActorContext to ctx.
func WithAdminActor(ctx context.Context, actor AdminActorContext) context.Context {
	return context.WithValue(ctx, adminActorContextKey{}, actor)
}

// AdminActorFromContext extracts AdminActorContext from ctx.
func AdminActorFromContext(ctx context.Context) (AdminActorContext, bool) {
	if ctx == nil {
		return AdminActorContext{}, false
	}
	a, ok := ctx.Value(adminActorContextKey{}).(AdminActorContext)
	return a, ok
}

type cachedAdminCommand struct {
	requestHash string
	response    proto.Message
}

// Service implements AdminAuthServiceHandler, ModerationServiceHandler, SystemConfigServiceHandler,
// transportauth.Verifier (for ModeAdminAPI), and capability.KillSwitchChecker.
type Service struct {
	adminv1connect.UnimplementedAdminAuthServiceHandler
	adminv1connect.UnimplementedModerationServiceHandler
	adminv1connect.UnimplementedSystemConfigServiceHandler

	Bindings    *rbac.Registry
	Now         func() time.Time
	IDGenerator func() string

	mu                sync.Mutex
	adminsByID        map[string]*InternalAdminRecord
	adminsByEmail     map[string]*InternalAdminRecord
	sessionsByToken   map[string]*AdminSessionRecord
	sessionsByID      map[string]*AdminSessionRecord
	impersonations    map[string]*ImpersonationSessionRecord
	moderationCases   map[string]*ModerationCaseRecord
	featureFlags      map[string]*FeatureFlagRecord
	maintenanceActive bool
	maintenanceReason string
	activeIncidents   int32
	auditLogs         []InternalAuditLogRecord
	workspaceAudits   []outbox.AuditLogEntry
	emittedEvents     []outbox.DomainEventEnvelope
	idempotency       map[string]cachedAdminCommand
}

var (
	_ adminv1connect.AdminAuthServiceHandler    = (*Service)(nil)
	_ adminv1connect.ModerationServiceHandler   = (*Service)(nil)
	_ adminv1connect.SystemConfigServiceHandler = (*Service)(nil)
	_ transportauth.Verifier                    = (*Service)(nil)
	_ capability.KillSwitchChecker              = (*Service)(nil)
)

// NewService constructs a fail-closed Internal Admin Service.
func NewService(bindings *rbac.Registry) *Service {
	return &Service{
		Bindings:        bindings,
		Now:             func() time.Time { return time.Now().UTC() },
		IDGenerator:     randomUUIDv4,
		adminsByID:      make(map[string]*InternalAdminRecord),
		adminsByEmail:   make(map[string]*InternalAdminRecord),
		sessionsByToken: make(map[string]*AdminSessionRecord),
		sessionsByID:    make(map[string]*AdminSessionRecord),
		impersonations:  make(map[string]*ImpersonationSessionRecord),
		moderationCases: make(map[string]*ModerationCaseRecord),
		featureFlags:    make(map[string]*FeatureFlagRecord),
		idempotency:     make(map[string]cachedAdminCommand),
	}
}

// HashAdminPassword produces a deterministic SHA-256 hex digest for test/local verification fixtures.
func HashAdminPassword(rawPassword string) string {
	sum := sha256.Sum256([]byte("creativanta-admin-v1:" + rawPassword))
	return hex.EncodeToString(sum[:])
}

func hashToken(rawToken string) string {
	sum := sha256.Sum256([]byte("creativanta-admin-session-v1:" + rawToken))
	return hex.EncodeToString(sum[:])
}

// RegisterAdmin registers an internal admin account in the isolated admin store.
func (s *Service) RegisterAdmin(admin InternalAdminRecord) error {
	if !tenantdb.IsValidNonZeroUUID(admin.AdminID) {
		return fmt.Errorf("%w: invalid admin_id", ErrInvalidInput)
	}
	if !rbac.IsValidAdminRole(admin.AdminRole) {
		return fmt.Errorf("%w: %q is not a valid internal admin role", rbac.ErrUnknownRole, admin.AdminRole)
	}
	email := strings.ToLower(strings.TrimSpace(admin.Email))
	if email == "" || strings.TrimSpace(admin.PasswordHash) == "" || strings.TrimSpace(admin.MFASecret) == "" {
		return fmt.Errorf("%w: admin email, password_hash, and mfa_secret are required", ErrInvalidInput)
	}
	if admin.Status == "" {
		admin.Status = "active"
	}
	if admin.CreatedAt.IsZero() {
		admin.CreatedAt = s.Now()
	}
	admin.Email = email

	s.mu.Lock()
	defer s.mu.Unlock()
	cp := admin
	s.adminsByID[admin.AdminID] = &cp
	s.adminsByEmail[email] = &cp
	return nil
}

// SeedModerationCase adds or updates a moderation case in the queue and emits moderation.case_created.
func (s *Service) SeedModerationCase(mc ModerationCaseRecord) (*ModerationCaseRecord, error) {
	if !tenantdb.IsValidNonZeroUUID(mc.CaseID) || !tenantdb.IsValidNonZeroUUID(mc.WorkspaceID) {
		return nil, ErrInvalidInput
	}
	now := s.Now()
	if mc.CreatedAt.IsZero() {
		mc.CreatedAt = now
	}
	eval := EvaluateModerationRisk(mc.RiskScore, mc.Category)
	mc.RiskScore = eval.NormalizedScore
	mc.RiskBand = eval.Band
	mc.HardBlock = eval.HardBlock
	if mc.Status == "" {
		mc.Status = "pending"
	}
	if mc.FlagSource == "" {
		mc.FlagSource = "ai_pre_publish"
	}
	if mc.Severity == "" {
		if eval.HardBlock || eval.NormalizedScore >= 85 {
			mc.Severity = "critical"
		} else if eval.NormalizedScore >= 60 {
			mc.Severity = "high"
		} else {
			mc.Severity = "medium"
		}
	}
	if mc.SLADueAt.IsZero() {
		mc.SLADueAt = ComputeModerationSLA(mc.Severity, mc.CreatedAt)
	}

	s.mu.Lock()
	defer s.mu.Unlock()
	cp := mc
	s.moderationCases[mc.CaseID] = &cp

	payload, _ := json.Marshal(map[string]any{
		"case_id":      mc.CaseID,
		"workspace_id": mc.WorkspaceID,
		"category":     mc.Category,
		"severity":     mc.Severity,
		"risk_score":   mc.RiskScore,
		"risk_band":    string(mc.RiskBand),
		"hard_block":   mc.HardBlock,
		"sla_due_at":   mc.SLADueAt.Format(time.RFC3339),
	})
	s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
		EventID:       s.IDGenerator(),
		EventType:     "moderation.case_created",
		TargetStream:  outbox.QueueModerationScan,
		AggregateType: "moderation_case",
		AggregateID:   mc.CaseID,
		WorkspaceID:   mc.WorkspaceID,
		Payload:       payload,
		OccurredAt:    now,
	})
	return &cp, nil
}

// AttemptWorkspacePackagingOverride checks whether a workspace role (packaging:override) can override a moderation case.
// Per SAFE-2026-02 (docs/06_quality_ops/moderation_rules_engine.md):
//   - Hard-block categories and block-band cases (score >= 60) can NEVER be overridden by workspace roles.
//   - Soft review cases (25-59, no hard-block category) require packaging:override (Owner/Admin/Manager) and a non-empty audit reason.
func (s *Service) AttemptWorkspacePackagingOverride(caseID, workspaceID, actorUserID, workspaceRole, reason string) error {
	if strings.TrimSpace(reason) == "" {
		return rbac.ErrAuditReasonRequired
	}
	if err := rbac.CheckWorkspacePermission("packaging:override", rbac.PolicyContext{
		ActorUserID: actorUserID,
		WorkspaceID: workspaceID,
		Role:        workspaceRole,
		AuditReason: reason,
	}); err != nil {
		return err
	}

	s.mu.Lock()
	defer s.mu.Unlock()
	mc, ok := s.moderationCases[caseID]
	if !ok || mc.WorkspaceID != workspaceID {
		return ErrCaseNotFound
	}
	eval := EvaluateModerationRisk(mc.RiskScore, mc.Category)
	if eval.HardBlock || !eval.OverridableByUser {
		return ErrHardBlockNonOverridable
	}
	return nil
}

// Verify implements transportauth.Verifier for the isolated ModeAdminAPI listener.
// It rejects any workspace token, workspace role, expired session, or session without VPN+MFA verification.
func (s *Service) Verify(ctx context.Context, bearerToken string) (transportauth.Session, error) {
	if err := ctx.Err(); err != nil {
		return transportauth.Session{}, err
	}
	trimmed := strings.TrimSpace(bearerToken)
	if trimmed == "" || strings.HasPrefix(trimmed, "workspace:") || strings.HasPrefix(trimmed, "clerk:") {
		return transportauth.Session{}, ErrWorkspaceRoleRejectedOnAdminListener
	}
	for _, wsRole := range rbac.CanonicalWorkspaceRoles() {
		if trimmed == "role:"+wsRole {
			return transportauth.Session{}, ErrWorkspaceRoleRejectedOnAdminListener
		}
	}

	now := s.Now()
	th := hashToken(trimmed)

	s.mu.Lock()
	defer s.mu.Unlock()
	sess, ok := s.sessionsByToken[th]
	if !ok {
		return transportauth.Session{}, ErrAdminSessionExpired
	}
	if sess.RevokedAt != nil || !now.Before(sess.ExpiresAt) {
		return transportauth.Session{}, ErrAdminSessionExpired
	}
	if !sess.VPNVerified || !sess.MFAVerified {
		return transportauth.Session{}, ErrMFARequired
	}
	admin, ok := s.adminsByID[sess.AdminID]
	if !ok || admin.Status != "active" || !rbac.IsValidAdminRole(admin.AdminRole) {
		return transportauth.Session{}, ErrInvalidAdminCredentials
	}
	return transportauth.Session{
		UserID:        admin.AdminID,
		WorkspaceID:   "",
		InternalAdmin: true,
	}, nil
}

// GuardListenerBoundary enforces strict separation between ModeAPI (workspace listener)
// and ModeAdminAPI (isolated internal admin listener).
func (s *Service) GuardListenerBoundary(mode transportauth.Mode, rpcName string, actor AdminActorContext) error {
	if s.Bindings == nil {
		return errors.New("internaladmin: missing RBAC registry")
	}
	binding, ok := s.Bindings.Lookup(rpcName)
	if !ok {
		return rbac.ErrUnboundRPC
	}

	if mode == transportauth.ModeAPI && binding.BehaviorFamily == "admin" {
		return ErrAdminRPCOnWorkspaceListener
	}
	if mode == transportauth.ModeAdminAPI {
		if actor.WorkspaceRoleTry != "" || rbac.IsValidWorkspaceRole(actor.AdminRole) {
			return ErrWorkspaceRoleRejectedOnAdminListener
		}
		if binding.PermissionKey != "PUBLIC" {
			if !actor.VPNVerified {
				return ErrVPNRequired
			}
			if !actor.MFAVerified {
				return ErrMFARequired
			}
			if !rbac.IsValidAdminRole(actor.AdminRole) {
				return ErrWorkspaceRoleRejectedOnAdminListener
			}
		}
	}
	return nil
}

func (s *Service) authorizeAdminRPC(ctx context.Context, rpcName, auditReason string) (AdminActorContext, *InternalAdminRecord, error) {
	actor, ok := AdminActorFromContext(ctx)
	if !ok {
		return AdminActorContext{}, nil, ErrAdminSessionExpired
	}
	if actor.WorkspaceRoleTry != "" || rbac.IsValidWorkspaceRole(actor.AdminRole) {
		return AdminActorContext{}, nil, ErrWorkspaceRoleRejectedOnAdminListener
	}
	if err := s.GuardListenerBoundary(transportauth.ModeAdminAPI, rpcName, actor); err != nil {
		return AdminActorContext{}, nil, err
	}

	now := s.Now()
	s.mu.Lock()
	sess, sessOK := s.sessionsByID[actor.SessionID]
	var admin *InternalAdminRecord
	if sessOK {
		admin = s.adminsByID[sess.AdminID]
	}
	s.mu.Unlock()

	if !sessOK || sess.RevokedAt != nil || !now.Before(sess.ExpiresAt) {
		return AdminActorContext{}, nil, ErrAdminSessionExpired
	}
	if !sess.VPNVerified {
		return AdminActorContext{}, nil, ErrVPNRequired
	}
	if !sess.MFAVerified {
		return AdminActorContext{}, nil, ErrMFARequired
	}
	if admin == nil || admin.Status != "active" {
		return AdminActorContext{}, nil, ErrInvalidAdminCredentials
	}

	_, err := s.Bindings.Authorize(rpcName, rbac.PolicyContext{
		ActorUserID:              admin.AdminID,
		AdminRole:                admin.AdminRole,
		AuditReason:              auditReason,
		SupportScopedReadAllowed: strings.TrimSpace(actor.SupportTicketID) != "",
	})
	if err != nil {
		return AdminActorContext{}, nil, err
	}
	actor.AdminID = admin.AdminID
	actor.AdminRole = admin.AdminRole
	return actor, admin, nil
}

// Login implements AdminAuthService/Login (bound to PUBLIC in rpc_permission_bindings.csv on admin surface).
// Requires VPN mesh verification + valid active admin password + valid 6-digit RFC 6238 TOTP code.
func (s *Service) Login(
	ctx context.Context,
	req *connect.Request[adminv1.LoginRequest],
) (*connect.Response[adminv1.LoginResponse], error) {
	if req.Msg == nil {
		return nil, toAdminConnectError(ErrInvalidInput)
	}
	if s.Bindings != nil {
		if _, ok := s.Bindings.Lookup("AdminAuthService/Login"); !ok {
			return nil, toAdminConnectError(rbac.ErrUnboundRPC)
		}
	}

	if !req.Msg.GetVpnVerified() {
		return nil, toAdminConnectError(ErrVPNRequired)
	}
	email := strings.ToLower(strings.TrimSpace(req.Msg.GetEmail()))
	password := req.Msg.GetPassword()
	totpCode := strings.TrimSpace(req.Msg.GetTotpCode())
	if email == "" || password == "" {
		return nil, toAdminConnectError(ErrInvalidAdminCredentials)
	}
	if totpCode == "" {
		return nil, toAdminConnectError(ErrMFARequired)
	}

	now := s.Now()
	expectedHash := HashAdminPassword(password)

	s.mu.Lock()
	admin, exists := s.adminsByEmail[email]
	if !exists || admin.Status != "active" || !rbac.IsValidAdminRole(admin.AdminRole) {
		s.mu.Unlock()
		return nil, toAdminConnectError(ErrInvalidAdminCredentials)
	}
	if subtle.ConstantTimeCompare([]byte(admin.PasswordHash), []byte(expectedHash)) != 1 {
		s.mu.Unlock()
		return nil, toAdminConnectError(ErrInvalidAdminCredentials)
	}
	if !admin.MFAEnabled || !ValidateTOTPCode(admin.MFASecret, totpCode, now) {
		s.mu.Unlock()
		return nil, toAdminConnectError(ErrMFARequired)
	}

	sessionID := s.IDGenerator()
	rawToken := "adm_sess_" + sessionID + "_" + s.IDGenerator()
	expiresAt := now.Add(AdminSessionTTL)
	sess := &AdminSessionRecord{
		SessionID:   sessionID,
		AdminID:     admin.AdminID,
		AdminRole:   admin.AdminRole,
		TokenHash:   hashToken(rawToken),
		IPAddress:   strings.TrimSpace(req.Msg.GetIpAddress()),
		UserAgent:   strings.TrimSpace(req.Msg.GetUserAgent()),
		VPNVerified: true,
		MFAVerified: true,
		CreatedAt:   now,
		ExpiresAt:   expiresAt,
	}
	s.sessionsByToken[sess.TokenHash] = sess
	s.sessionsByID[sessionID] = sess
	admin.LastLoginAt = now

	s.auditLogs = append(s.auditLogs, InternalAuditLogRecord{
		AuditID:    s.IDGenerator(),
		AdminID:    admin.AdminID,
		AdminRole:  admin.AdminRole,
		Action:     "admin.login",
		TargetType: "admin_session",
		TargetID:   sessionID,
		Reason:     "VPN + TOTP MFA verified login",
		AfterState: map[string]any{
			"vpn_verified": true,
			"mfa_verified": true,
			"expires_at":   expiresAt.Format(time.RFC3339),
		},
		IPAddress: sess.IPAddress,
		CreatedAt: now,
	})
	s.mu.Unlock()

	return connect.NewResponse(&adminv1.LoginResponse{
		SessionId:    &commonv1.UUID{Value: sessionID},
		AdminId:      &commonv1.UUID{Value: admin.AdminID},
		Role:         admin.AdminRole,
		SessionToken: rawToken,
		MfaVerified:  true,
		VpnVerified:  true,
		ExpiresAt:    timestamppb.New(expiresAt),
	}), nil
}

// Impersonate implements AdminAuthService/Impersonate (requires admin:impersonate).
// Strictly creates a read_only impersonation session that auto-expires after 30 minutes (RULE-S26-002).
func (s *Service) Impersonate(
	ctx context.Context,
	req *connect.Request[adminv1.ImpersonateRequest],
) (*connect.Response[adminv1.ImpersonateResponse], error) {
	if req.Msg == nil || req.Msg.GetTargetUserId() == nil || req.Msg.GetTargetWorkspaceId() == nil {
		return nil, toAdminConnectError(ErrInvalidInput)
	}
	idemKey := strings.TrimSpace(req.Msg.GetIdempotencyKey())
	reason := strings.TrimSpace(req.Msg.GetReason())
	targetUserID := strings.TrimSpace(req.Msg.GetTargetUserId().GetValue())
	targetWorkspaceID := strings.TrimSpace(req.Msg.GetTargetWorkspaceId().GetValue())
	ticketID := strings.TrimSpace(req.Msg.GetSupportTicketId())

	if idemKey == "" || !tenantdb.IsValidNonZeroUUID(targetUserID) || !tenantdb.IsValidNonZeroUUID(targetWorkspaceID) {
		return nil, toAdminConnectError(ErrInvalidInput)
	}

	if ticketID != "" {
		if actor, ok := AdminActorFromContext(ctx); ok && actor.SupportTicketID == "" {
			actor.SupportTicketID = ticketID
			ctx = WithAdminActor(ctx, actor)
		}
	}
	actor, admin, err := s.authorizeAdminRPC(ctx, "AdminAuthService/Impersonate", reason)
	if err != nil {
		return nil, toAdminConnectError(err)
	}
	if admin.AdminRole == rbac.AdminRoleSupport && ticketID == "" && strings.TrimSpace(actor.SupportTicketID) == "" {
		return nil, toAdminConnectError(ErrSupportTicketRequired)
	}
	if ticketID == "" {
		ticketID = actor.SupportTicketID
	}

	reqHash := hashAdminPayload("Impersonate", admin.AdminID, targetUserID, targetWorkspaceID, reason, ticketID)
	cacheKey := admin.AdminID + "::AdminAuthService/Impersonate::" + idemKey

	s.mu.Lock()
	if prev, ok := s.idempotency[cacheKey]; ok {
		s.mu.Unlock()
		if prev.requestHash != reqHash {
			return nil, toAdminConnectError(ErrIdempotencyConflict)
		}
		cloned := proto.Clone(prev.response.(*adminv1.ImpersonateResponse)).(*adminv1.ImpersonateResponse)
		cloned.Replayed = true
		return connect.NewResponse(cloned), nil
	}

	now := s.Now()
	impID := s.IDGenerator()
	expiresAt := now.Add(ImpersonationSessionTTL)
	imp := &ImpersonationSessionRecord{
		ImpersonationID:   impID,
		AdminID:           admin.AdminID,
		AdminRole:         admin.AdminRole,
		TargetUserID:      targetUserID,
		TargetWorkspaceID: targetWorkspaceID,
		Reason:            reason,
		SupportTicketID:   ticketID,
		Mode:              "read_only",
		ActionsCount:      0,
		StartedAt:         now,
		ExpiresAt:         expiresAt,
	}
	s.impersonations[impID] = imp

	// Dual audit trail: internal_audit_logs + workspace audit_logs + domain event (RULE-S26-002 & RULE-S26-003).
	s.auditLogs = append(s.auditLogs, InternalAuditLogRecord{
		AuditID:           s.IDGenerator(),
		AdminID:           admin.AdminID,
		AdminRole:         admin.AdminRole,
		Action:            "admin.impersonation.started",
		TargetType:        "user",
		TargetID:          targetUserID,
		TargetWorkspaceID: targetWorkspaceID,
		Reason:            reason,
		AfterState: map[string]any{
			"impersonation_id":  impID,
			"mode":              "read_only",
			"support_ticket_id": ticketID,
			"expires_at":        expiresAt.Format(time.RFC3339),
		},
		IPAddress: actor.IPAddress,
		CreatedAt: now,
	})
	s.workspaceAudits = append(s.workspaceAudits, outbox.AuditLogEntry{
		AuditEventID: s.IDGenerator(),
		WorkspaceID:  targetWorkspaceID,
		ActorID:      admin.AdminID,
		ActorType:    "admin",
		Action:       "admin.impersonation_started",
		ResourceType: "impersonation_session",
		ResourceID:   impID,
		Reason:       reason,
		CreatedAt:    now,
	})
	payload, _ := json.Marshal(map[string]any{
		"impersonation_id":    impID,
		"admin_id":            admin.AdminID,
		"target_user_id":      targetUserID,
		"target_workspace_id": targetWorkspaceID,
		"mode":                "read_only",
		"expires_at":          expiresAt.Format(time.RFC3339),
	})
	s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
		EventID:       s.IDGenerator(),
		EventType:     "admin.impersonation_started",
		TargetStream:  outbox.QueueNotifications,
		AggregateType: "impersonation_session",
		AggregateID:   impID,
		WorkspaceID:   targetWorkspaceID,
		Payload:       payload,
		OccurredAt:    now,
	})

	resp := &adminv1.ImpersonateResponse{
		ImpersonationId:   &commonv1.UUID{Value: impID},
		AdminId:           &commonv1.UUID{Value: admin.AdminID},
		TargetUserId:      &commonv1.UUID{Value: targetUserID},
		TargetWorkspaceId: &commonv1.UUID{Value: targetWorkspaceID},
		Mode:              "read_only",
		StartedAt:         timestamppb.New(now),
		ExpiresAt:         timestamppb.New(expiresAt),
		Replayed:          false,
	}
	s.idempotency[cacheKey] = cachedAdminCommand{
		requestHash: reqHash,
		response:    resp,
	}
	s.mu.Unlock()

	return connect.NewResponse(resp), nil
}

// EndImpersonation implements AdminAuthService/EndImpersonation (requires admin:impersonate).
func (s *Service) EndImpersonation(
	ctx context.Context,
	req *connect.Request[adminv1.EndImpersonationRequest],
) (*connect.Response[adminv1.EndImpersonationResponse], error) {
	if req.Msg == nil || req.Msg.GetImpersonationId() == nil {
		return nil, toAdminConnectError(ErrInvalidInput)
	}
	impID := strings.TrimSpace(req.Msg.GetImpersonationId().GetValue())
	reason := strings.TrimSpace(req.Msg.GetReason())
	if reason == "" {
		reason = "Session ended by admin"
	}
	if _, _, err := s.authorizeAdminRPC(ctx, "AdminAuthService/EndImpersonation", reason); err != nil {
		return nil, toAdminConnectError(err)
	}

	now := s.Now()
	s.mu.Lock()
	imp, ok := s.impersonations[impID]
	if !ok {
		s.mu.Unlock()
		return nil, toAdminConnectError(ErrImpersonationExpired)
	}
	if imp.EndedAt == nil {
		ended := now
		imp.EndedAt = &ended
	}
	s.auditLogs = append(s.auditLogs, InternalAuditLogRecord{
		AuditID:           s.IDGenerator(),
		AdminID:           imp.AdminID,
		AdminRole:         imp.AdminRole,
		Action:            "admin.impersonation.ended",
		TargetType:        "impersonation_session",
		TargetID:          imp.ImpersonationID,
		TargetWorkspaceID: imp.TargetWorkspaceID,
		Reason:            reason,
		AfterState: map[string]any{
			"actions_count": imp.ActionsCount,
			"ended_at":      now.Format(time.RFC3339),
		},
		CreatedAt: now,
	})
	payload, _ := json.Marshal(map[string]any{
		"impersonation_id":    imp.ImpersonationID,
		"admin_id":            imp.AdminID,
		"target_user_id":      imp.TargetUserID,
		"target_workspace_id": imp.TargetWorkspaceID,
		"actions_count":       imp.ActionsCount,
	})
	s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
		EventID:       s.IDGenerator(),
		EventType:     "admin.impersonation_ended",
		TargetStream:  outbox.QueueNotifications,
		AggregateType: "impersonation_session",
		AggregateID:   imp.ImpersonationID,
		WorkspaceID:   imp.TargetWorkspaceID,
		Payload:       payload,
		OccurredAt:    now,
	})
	s.mu.Unlock()

	return connect.NewResponse(&adminv1.EndImpersonationResponse{
		ImpersonationId: &commonv1.UUID{Value: impID},
		EndedAt:         timestamppb.New(now),
	}), nil
}

// AuthorizeImpersonatedWorkspaceRPC validates an active impersonation session and enforces read-only
// execution against the canonical RBAC registry. Any mutating RPC fails with rbac.ErrImpersonationReadOnly.
func (s *Service) AuthorizeImpersonatedWorkspaceRPC(impersonationID, rpcName, targetWorkspaceRole string) error {
	now := s.Now()
	s.mu.Lock()
	imp, ok := s.impersonations[impersonationID]
	if !ok || imp.EndedAt != nil || !now.Before(imp.ExpiresAt) {
		s.mu.Unlock()
		return ErrImpersonationExpired
	}
	if imp.Mode != "read_only" {
		s.mu.Unlock()
		return rbac.ErrImpersonationReadOnly
	}
	adminID := imp.AdminID
	adminRole := imp.AdminRole
	targetUserID := imp.TargetUserID
	targetWorkspaceID := imp.TargetWorkspaceID
	s.mu.Unlock()

	if s.Bindings == nil {
		return errors.New("internaladmin: missing RBAC registry")
	}
	binding, err := s.Bindings.Authorize(rpcName, rbac.PolicyContext{
		ActorUserID:     targetUserID,
		WorkspaceID:     targetWorkspaceID,
		Role:            targetWorkspaceRole,
		AdminRole:       adminRole,
		IsImpersonation: true,
	})
	if err != nil {
		return err
	}
	if binding.IsMutating() {
		return rbac.ErrImpersonationReadOnly
	}

	s.mu.Lock()
	imp.ActionsCount++
	s.auditLogs = append(s.auditLogs, InternalAuditLogRecord{
		AuditID:           s.IDGenerator(),
		AdminID:           adminID,
		AdminRole:         adminRole,
		Action:            "admin.impersonation.read_rpc",
		TargetType:        "rpc",
		TargetID:          rpcName,
		TargetWorkspaceID: targetWorkspaceID,
		Reason:            imp.Reason,
		CreatedAt:         now,
	})
	s.mu.Unlock()
	return nil
}

// BuildImpersonatedWorkspaceActor constructs a capability.ActorContext with IsImpersonation=true
// so workspace services enforce read-only behavior when invoked during impersonation.
func (s *Service) BuildImpersonatedWorkspaceActor(impersonationID, workspaceRole string) (capability.ActorContext, error) {
	now := s.Now()
	s.mu.Lock()
	defer s.mu.Unlock()
	imp, ok := s.impersonations[impersonationID]
	if !ok || imp.EndedAt != nil || !now.Before(imp.ExpiresAt) {
		return capability.ActorContext{}, ErrImpersonationExpired
	}
	return capability.ActorContext{
		UserID:           imp.TargetUserID,
		WorkspaceID:      imp.TargetWorkspaceID,
		WorkspaceRole:    workspaceRole,
		WorkspaceActive:  true,
		MembershipActive: true,
		IsImpersonation:  true,
	}, nil
}

// ListCases implements ModerationService/ListCases (requires admin:moderation:manage).
func (s *Service) ListCases(
	ctx context.Context,
	req *connect.Request[adminv1.ListCasesRequest],
) (*connect.Response[adminv1.ListCasesResponse], error) {
	if _, _, err := s.authorizeAdminRPC(ctx, "ModerationService/ListCases", ""); err != nil {
		return nil, toAdminConnectError(err)
	}
	statusFilter := ""
	if req.Msg != nil {
		statusFilter = strings.ToLower(strings.TrimSpace(req.Msg.GetStatusFilter()))
	}

	s.mu.Lock()
	ids := make([]string, 0, len(s.moderationCases))
	for id := range s.moderationCases {
		ids = append(ids, id)
	}
	sort.Strings(ids)
	var items []*adminv1.ModerationCaseItem
	for _, id := range ids {
		mc := s.moderationCases[id]
		if statusFilter != "" && strings.ToLower(mc.Status) != statusFilter {
			continue
		}
		items = append(items, toProtoModerationCase(mc))
	}
	s.mu.Unlock()

	return connect.NewResponse(&adminv1.ListCasesResponse{
		Cases: items,
	}), nil
}

// ActOnCase implements ModerationService/ActOnCase (requires admin:moderation:manage).
// Enforces:
//   - Self-review conflict-of-interest guard (EC-S26-002)
//   - Hard-block non-overridable safety guard (SAFE-2026-02: even content_admin cannot "approve" a hard-block violation)
//   - Mandatory non-empty audit reason + idempotency replay/conflict handling
func (s *Service) ActOnCase(
	ctx context.Context,
	req *connect.Request[adminv1.ActOnCaseRequest],
) (*connect.Response[adminv1.ActOnCaseResponse], error) {
	if req.Msg == nil || req.Msg.GetCaseId() == nil {
		return nil, toAdminConnectError(ErrInvalidInput)
	}
	idemKey := strings.TrimSpace(req.Msg.GetIdempotencyKey())
	reason := strings.TrimSpace(req.Msg.GetReason())
	caseID := strings.TrimSpace(req.Msg.GetCaseId().GetValue())
	decision := strings.ToLower(strings.TrimSpace(req.Msg.GetDecision()))

	if idemKey == "" || !tenantdb.IsValidNonZeroUUID(caseID) || decision == "" {
		return nil, toAdminConnectError(ErrInvalidInput)
	}
	switch decision {
	case "approve", "reject", "escalate", "warn_user", "suspend_workspace":
	default:
		return nil, toAdminConnectError(ErrInvalidInput)
	}

	actor, admin, err := s.authorizeAdminRPC(ctx, "ModerationService/ActOnCase", reason)
	if err != nil {
		return nil, toAdminConnectError(err)
	}

	reqHash := hashAdminPayload("ActOnCase", admin.AdminID, caseID, decision, reason)
	cacheKey := admin.AdminID + "::ModerationService/ActOnCase::" + idemKey

	s.mu.Lock()
	if prev, ok := s.idempotency[cacheKey]; ok {
		s.mu.Unlock()
		if prev.requestHash != reqHash {
			return nil, toAdminConnectError(ErrIdempotencyConflict)
		}
		cloned := proto.Clone(prev.response.(*adminv1.ActOnCaseResponse)).(*adminv1.ActOnCaseResponse)
		cloned.Replayed = true
		return connect.NewResponse(cloned), nil
	}

	mc, exists := s.moderationCases[caseID]
	if !exists {
		s.mu.Unlock()
		return nil, toAdminConnectError(ErrCaseNotFound)
	}

	// EC-S26-002: Admin cannot review a moderation case where they are the flagged or reporting user.
	if (mc.FlaggedUserID != "" && (mc.FlaggedUserID == admin.AdminID || (admin.LinkedUserID != "" && mc.FlaggedUserID == admin.LinkedUserID))) ||
		(mc.ReporterUserID != "" && (mc.ReporterUserID == admin.AdminID || (admin.LinkedUserID != "" && mc.ReporterUserID == admin.LinkedUserID))) {
		s.mu.Unlock()
		return nil, toAdminConnectError(ErrSelfReviewConflict)
	}

	// SAFE-2026-02: Hard-block safety violations cannot be approved for external publish.
	if mc.HardBlock && decision == "approve" {
		s.mu.Unlock()
		return nil, toAdminConnectError(ErrHardBlockNonOverridable)
	}

	now := s.Now()
	prevStatus := mc.Status
	switch decision {
	case "approve":
		mc.Status = "approved"
	case "reject", "warn_user", "suspend_workspace":
		mc.Status = "rejected"
	case "escalate":
		mc.Status = "escalated"
	}
	mc.Decision = decision
	mc.DecisionReason = reason
	mc.AssignedAdminID = admin.AdminID
	mc.ResolvedAt = &now

	auditID := s.IDGenerator()
	s.auditLogs = append(s.auditLogs, InternalAuditLogRecord{
		AuditID:           auditID,
		AdminID:           admin.AdminID,
		AdminRole:         admin.AdminRole,
		Action:            "moderation.case.acted",
		TargetType:        "moderation_case",
		TargetID:          caseID,
		TargetWorkspaceID: mc.WorkspaceID,
		Reason:            reason,
		BeforeState:       map[string]any{"status": prevStatus},
		AfterState:        map[string]any{"status": mc.Status, "decision": decision},
		IPAddress:         actor.IPAddress,
		CreatedAt:         now,
	})
	payload, _ := json.Marshal(map[string]any{
		"case_id":      caseID,
		"workspace_id": mc.WorkspaceID,
		"decision":     decision,
		"status":       mc.Status,
		"admin_id":     admin.AdminID,
		"reason":       reason,
	})
	s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
		EventID:       s.IDGenerator(),
		EventType:     "moderation.case_resolved",
		TargetStream:  outbox.QueueModerationScan,
		AggregateType: "moderation_case",
		AggregateID:   caseID,
		WorkspaceID:   mc.WorkspaceID,
		Payload:       payload,
		OccurredAt:    now,
	})

	resp := &adminv1.ActOnCaseResponse{
		ModerationCase: toProtoModerationCase(mc),
		AuditLogId:     &commonv1.UUID{Value: auditID},
		Replayed:       false,
	}
	s.idempotency[cacheKey] = cachedAdminCommand{
		requestHash: reqHash,
		response:    resp,
	}
	s.mu.Unlock()

	return connect.NewResponse(resp), nil
}

// GetDashboard implements SystemConfigService/GetDashboard (requires admin:analytics:read).
func (s *Service) GetDashboard(
	ctx context.Context,
	_ *connect.Request[adminv1.GetDashboardRequest],
) (*connect.Response[adminv1.GetDashboardResponse], error) {
	if _, _, err := s.authorizeAdminRPC(ctx, "SystemConfigService/GetDashboard", ""); err != nil {
		return nil, toAdminConnectError(err)
	}

	now := s.Now()
	s.mu.Lock()
	var pendingMod int32
	for _, mc := range s.moderationCases {
		if mc.Status == "pending" || mc.Status == "in_review" {
			pendingMod++
		}
	}
	var activeKillSwitches int32
	for _, ff := range s.featureFlags {
		if ff.IsKillSwitch && ff.Enabled {
			activeKillSwitches++
		}
	}
	var activeImpersonations int32
	for _, imp := range s.impersonations {
		if imp.EndedAt == nil && now.Before(imp.ExpiresAt) {
			activeImpersonations++
		}
	}
	maint := s.maintenanceActive
	auditCount := int32(len(s.auditLogs))
	s.mu.Unlock()

	return connect.NewResponse(&adminv1.GetDashboardResponse{
		MaintenanceMode:                  maint,
		ActiveKillSwitchesCount:          activeKillSwitches,
		PendingModerationCasesCount:      pendingMod,
		ActiveImpersonationSessionsCount: activeImpersonations,
		AuditLogEntriesCount:             auditCount,
		GeneratedAt:                      timestamppb.New(now),
	}), nil
}

// ToggleFlag implements SystemConfigService/ToggleFlag (requires admin:feature_flag:toggle — super_admin or tech_admin).
func (s *Service) ToggleFlag(
	ctx context.Context,
	req *connect.Request[adminv1.ToggleFlagRequest],
) (*connect.Response[adminv1.ToggleFlagResponse], error) {
	if req.Msg == nil {
		return nil, toAdminConnectError(ErrInvalidInput)
	}
	idemKey := strings.TrimSpace(req.Msg.GetIdempotencyKey())
	reason := strings.TrimSpace(req.Msg.GetReason())
	flagKey := strings.ToLower(strings.TrimSpace(req.Msg.GetFlagKey()))
	status := strings.ToLower(strings.TrimSpace(req.Msg.GetStatus()))
	if idemKey == "" || flagKey == "" || status == "" {
		return nil, toAdminConnectError(ErrInvalidInput)
	}
	switch status {
	case "enabled", "disabled", "percentage_rollout":
	default:
		return nil, toAdminConnectError(ErrInvalidInput)
	}

	actor, admin, err := s.authorizeAdminRPC(ctx, "SystemConfigService/ToggleFlag", reason)
	if err != nil {
		return nil, toAdminConnectError(err)
	}

	reqHash := hashAdminPayload(
		"ToggleFlag",
		admin.AdminID,
		flagKey,
		status,
		fmt.Sprintf("%t", req.Msg.GetIsKillSwitch()),
		fmt.Sprintf("%d", req.Msg.GetPercentage()),
		reason,
	)
	cacheKey := admin.AdminID + "::SystemConfigService/ToggleFlag::" + idemKey

	s.mu.Lock()
	if prev, ok := s.idempotency[cacheKey]; ok {
		s.mu.Unlock()
		if prev.requestHash != reqHash {
			return nil, toAdminConnectError(ErrIdempotencyConflict)
		}
		cloned := proto.Clone(prev.response.(*adminv1.ToggleFlagResponse)).(*adminv1.ToggleFlagResponse)
		cloned.Replayed = true
		return connect.NewResponse(cloned), nil
	}

	now := s.Now()
	rollout := req.Msg.GetPercentage()
	if rollout < 0 {
		rollout = 0
	}
	if rollout > 100 {
		rollout = 100
	}
	prevStatus := "disabled"
	flagID := s.IDGenerator()
	if existing, ok := s.featureFlags[flagKey]; ok {
		prevStatus = existing.Status
		flagID = existing.FlagID
	}
	enabled := status == "enabled" || (status == "percentage_rollout" && rollout > 0)
	ff := &FeatureFlagRecord{
		FlagID:            flagID,
		FlagKey:           flagKey,
		Name:              flagKey,
		Description:       "Kill switch / feature flag managed via SystemConfigService",
		Status:            status,
		Enabled:           enabled,
		RolloutPercentage: rollout,
		IsKillSwitch:      req.Msg.GetIsKillSwitch(),
		UpdatedByAdminID:  admin.AdminID,
		Reason:            reason,
		UpdatedAt:         now,
	}
	s.featureFlags[flagKey] = ff

	auditID := s.IDGenerator()
	s.auditLogs = append(s.auditLogs, InternalAuditLogRecord{
		AuditID:    auditID,
		AdminID:    admin.AdminID,
		AdminRole:  admin.AdminRole,
		Action:     "feature_flag.toggled",
		TargetType: "feature_flag",
		TargetID:   flagKey,
		Reason:     reason,
		BeforeState: map[string]any{
			"status": prevStatus,
		},
		AfterState: map[string]any{
			"status":         ff.Status,
			"enabled":        ff.Enabled,
			"is_kill_switch": ff.IsKillSwitch,
			"rollout_pct":    ff.RolloutPercentage,
		},
		IPAddress: actor.IPAddress,
		CreatedAt: now,
	})
	payload, _ := json.Marshal(map[string]any{
		"flag_key":       flagKey,
		"status":         ff.Status,
		"enabled":        ff.Enabled,
		"is_kill_switch": ff.IsKillSwitch,
		"admin_id":       admin.AdminID,
		"reason":         reason,
	})
	s.emittedEvents = append(s.emittedEvents, outbox.DomainEventEnvelope{
		EventID:       s.IDGenerator(),
		EventType:     "feature_flag.toggled",
		TargetStream:  outbox.QueueNotifications,
		AggregateType: "feature_flag",
		AggregateID:   flagKey,
		Payload:       payload,
		OccurredAt:    now,
	})

	resp := &adminv1.ToggleFlagResponse{
		Flag:       toProtoFeatureFlag(ff),
		AuditLogId: &commonv1.UUID{Value: auditID},
		Replayed:   false,
	}
	s.idempotency[cacheKey] = cachedAdminCommand{
		requestHash: reqHash,
		response:    resp,
	}
	s.mu.Unlock()

	return connect.NewResponse(resp), nil
}

// ToggleMaintenance implements SystemConfigService/ToggleMaintenance (requires admin:maintenance:toggle — super_admin or tech_admin).
func (s *Service) ToggleMaintenance(
	ctx context.Context,
	req *connect.Request[adminv1.ToggleMaintenanceRequest],
) (*connect.Response[adminv1.ToggleMaintenanceResponse], error) {
	if req.Msg == nil {
		return nil, toAdminConnectError(ErrInvalidInput)
	}
	idemKey := strings.TrimSpace(req.Msg.GetIdempotencyKey())
	reason := strings.TrimSpace(req.Msg.GetReason())
	if idemKey == "" {
		return nil, toAdminConnectError(ErrInvalidInput)
	}

	actor, admin, err := s.authorizeAdminRPC(ctx, "SystemConfigService/ToggleMaintenance", reason)
	if err != nil {
		return nil, toAdminConnectError(err)
	}

	reqHash := hashAdminPayload("ToggleMaintenance", admin.AdminID, fmt.Sprintf("%t", req.Msg.GetEnabled()), reason)
	cacheKey := admin.AdminID + "::SystemConfigService/ToggleMaintenance::" + idemKey

	s.mu.Lock()
	if prev, ok := s.idempotency[cacheKey]; ok {
		s.mu.Unlock()
		if prev.requestHash != reqHash {
			return nil, toAdminConnectError(ErrIdempotencyConflict)
		}
		cloned := proto.Clone(prev.response.(*adminv1.ToggleMaintenanceResponse)).(*adminv1.ToggleMaintenanceResponse)
		cloned.Replayed = true
		return connect.NewResponse(cloned), nil
	}

	now := s.Now()
	prevMaint := s.maintenanceActive
	s.maintenanceActive = req.Msg.GetEnabled()
	s.maintenanceReason = reason

	auditID := s.IDGenerator()
	s.auditLogs = append(s.auditLogs, InternalAuditLogRecord{
		AuditID:     auditID,
		AdminID:     admin.AdminID,
		AdminRole:   admin.AdminRole,
		Action:      "system.maintenance.toggled",
		TargetType:  "system_config",
		TargetID:    "maintenance_mode",
		Reason:      reason,
		BeforeState: map[string]any{"enabled": prevMaint},
		AfterState:  map[string]any{"enabled": s.maintenanceActive},
		IPAddress:   actor.IPAddress,
		CreatedAt:   now,
	})

	resp := &adminv1.ToggleMaintenanceResponse{
		MaintenanceMode: s.maintenanceActive,
		AuditLogId:      &commonv1.UUID{Value: auditID},
		Replayed:        false,
		UpdatedAt:       timestamppb.New(now),
	}
	s.idempotency[cacheKey] = cachedAdminCommand{
		requestHash: reqHash,
		response:    resp,
	}
	s.mu.Unlock()

	return connect.NewResponse(resp), nil
}

// IsCapabilityKilled implements capability.KillSwitchChecker so any tripped kill switch in
// SystemConfigService immediately blocks connector execution in capability.Service!
func (s *Service) IsCapabilityKilled(platform, actionKey string) (bool, string) {
	plat := strings.ToLower(strings.TrimSpace(platform))
	act := strings.ToLower(strings.TrimSpace(actionKey))

	s.mu.Lock()
	defer s.mu.Unlock()

	// Check global kill switch first.
	if ff, ok := s.featureFlags["kill_switch:global"]; ok && ff.IsKillSwitch && ff.Enabled {
		return true, fmt.Sprintf("Công tắc ngắt khẩn cấp toàn hệ thống đang bật (%s)", ff.Reason)
	}
	// Check platform-level kill switch, e.g. "kill_switch:tiktok" or "kill_switch:zalo_oa".
	if ff, ok := s.featureFlags["kill_switch:"+plat]; ok && ff.IsKillSwitch && ff.Enabled {
		return true, fmt.Sprintf("Công tắc ngắt khẩn cấp cho nền tảng %s đang bật (%s)", plat, ff.Reason)
	}
	// Check action-specific kill switch, e.g. "kill_switch:tiktok:publish.video".
	if ff, ok := s.featureFlags["kill_switch:"+plat+":"+act]; ok && ff.IsKillSwitch && ff.Enabled {
		return true, fmt.Sprintf("Công tắc ngắt khẩn cấp cho tác vụ %s/%s đang bật (%s)", plat, act, ff.Reason)
	}
	if s.maintenanceActive {
		return true, fmt.Sprintf("Hệ thống đang trong chế độ bảo trì: %s", s.maintenanceReason)
	}
	return false, ""
}

// AuditLogs returns a snapshot of recorded immutable internal admin audit logs.
func (s *Service) AuditLogs() []InternalAuditLogRecord {
	s.mu.Lock()
	defer s.mu.Unlock()
	out := make([]InternalAuditLogRecord, len(s.auditLogs))
	copy(out, s.auditLogs)
	return out
}

// WorkspaceAuditLogs returns a snapshot of dual-logged workspace audit entries (e.g. impersonation notices).
func (s *Service) WorkspaceAuditLogs() []outbox.AuditLogEntry {
	s.mu.Lock()
	defer s.mu.Unlock()
	out := make([]outbox.AuditLogEntry, len(s.workspaceAudits))
	copy(out, s.workspaceAudits)
	return out
}

// EmittedEvents returns a snapshot of domain events emitted by the internal admin service.
func (s *Service) EmittedEvents() []outbox.DomainEventEnvelope {
	s.mu.Lock()
	defer s.mu.Unlock()
	out := make([]outbox.DomainEventEnvelope, len(s.emittedEvents))
	copy(out, s.emittedEvents)
	return out
}

func toProtoModerationCase(mc *ModerationCaseRecord) *adminv1.ModerationCaseItem {
	item := &adminv1.ModerationCaseItem{
		CaseId:         &commonv1.UUID{Value: mc.CaseID},
		WorkspaceId:    &commonv1.UUID{Value: mc.WorkspaceID},
		ContentType:    mc.ContentType,
		ContentId:      &commonv1.UUID{Value: mc.ContentID},
		FlagReason:     mc.Category,
		FlagSource:     mc.FlagSource,
		RiskScore:      mc.RiskScore,
		IsHardBlock:    mc.HardBlock,
		Status:         mc.Status,
		DecisionReason: mc.DecisionReason,
		SlaDeadline:    timestamppb.New(mc.SLADueAt),
		CreatedAt:      timestamppb.New(mc.CreatedAt),
	}
	if tenantdb.IsValidNonZeroUUID(mc.AssignedAdminID) {
		item.AssignedAdminId = &commonv1.UUID{Value: mc.AssignedAdminID}
	}
	if mc.ResolvedAt != nil {
		item.DecidedAt = timestamppb.New(*mc.ResolvedAt)
	}
	return item
}

func toProtoFeatureFlag(ff *FeatureFlagRecord) *adminv1.FeatureFlagItem {
	return &adminv1.FeatureFlagItem{
		FlagId:       &commonv1.UUID{Value: ff.FlagID},
		FlagKey:      ff.FlagKey,
		Name:         ff.Name,
		Description:  ff.Description,
		Status:       ff.Status,
		Percentage:   ff.RolloutPercentage,
		IsKillSwitch: ff.IsKillSwitch,
		UpdatedAt:    timestamppb.New(ff.UpdatedAt),
	}
}

func hashAdminPayload(parts ...string) string {
	h := sha256.New()
	for _, p := range parts {
		_, _ = h.Write([]byte(p))
		_, _ = h.Write([]byte{0})
	}
	return hex.EncodeToString(h.Sum(nil))
}

func randomUUIDv4() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func toAdminConnectError(err error) error {
	switch {
	case errors.Is(err, ErrAdminSessionExpired), errors.Is(err, ErrInvalidAdminCredentials), errors.Is(err, ErrImpersonationExpired):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, ErrVPNRequired),
		errors.Is(err, ErrMFARequired),
		errors.Is(err, ErrWorkspaceRoleRejectedOnAdminListener),
		errors.Is(err, ErrAdminRPCOnWorkspaceListener),
		errors.Is(err, ErrSupportTicketRequired),
		errors.Is(err, ErrSelfReviewConflict),
		errors.Is(err, ErrHardBlockNonOverridable),
		errors.Is(err, rbac.ErrPermissionDenied),
		errors.Is(err, rbac.ErrImpersonationReadOnly),
		errors.Is(err, rbac.ErrAuditReasonRequired),
		errors.Is(err, rbac.ErrUnknownRole),
		errors.Is(err, rbac.ErrUnboundRPC):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, ErrCaseNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrIdempotencyConflict):
		return connect.NewError(connect.CodeAlreadyExists, err)
	case errors.Is(err, ErrInvalidInput):
		return connect.NewError(connect.CodeInvalidArgument, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

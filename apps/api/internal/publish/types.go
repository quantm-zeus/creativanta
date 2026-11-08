package publish

import (
	"context"
	"crypto/rand"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	publishv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1"
)

// Standard Publish Domain Errors (error_catalog.md & publish_hub.md)
var (
	ErrItemNotFound                   = errors.New("publish: publish item not found")
	ErrJobNotFound                    = errors.New("publish: publish job not found")
	ErrAccountNotFound                = errors.New("publish: connected account not found")
	ErrPrematurePublish               = errors.New("publish: invariant violation - cannot publish before scheduled time (RULE-M11-006)")
	ErrAuthRevoked                    = errors.New("publish: connector authentication revoked or expired (auth_revoked)")
	ErrCapabilityDegraded             = errors.New("publish: platform capability degraded or unsupported, requires manual fallback")
	ErrApprovalRequired               = errors.New("publish: publish requires human approval gate before execution")
	ErrUnknownSubmit                  = errors.New("publish: submission outcome unknown, pending reconciliation before retry")
	ErrDuplicatePostPrevented         = errors.New("publish: duplicate post prevented by reconciliation check")
	ErrInvalidState                   = errors.New("publish: invalid lifecycle state transition")
	ErrProofRequired                  = errors.New("publish: evidence ref or screenshot URL required for manual proof")
	ErrRateLimitExceeded              = errors.New("publish: platform rate limit exceeded")
	ErrStoreNotConfigured             = errors.New("publish: durable store is not configured (fail-closed)")
	ErrUnauthenticated                = errors.New("publish: unauthenticated caller principal")
	ErrPermissionDenied               = errors.New("publish: permission denied or workspace scope mismatch")
	ErrComplianceHardBlocked          = errors.New("publish: compliance/QA hard block active; publishing is forbidden and cannot be overridden")
	ErrComplianceCheckerNotConfigured = fmt.Errorf("%w: compliance checker is not configured (fail-closed)", ErrComplianceHardBlocked)
	ErrComplianceReviewRequired       = errors.New("publish: compliance review required; soft-flag override acknowledgement and reason required")
	ErrDiagnosticsBlocked             = errors.New("publish: item diagnostics state is blocked; publishing is forbidden until resolved")
	ErrConnectorNotConfigured         = errors.New("publish: platform connector is not configured (fail-closed)")
	ErrJobItemMismatch                = errors.New("publish: publish_job_id does not belong to the requested publish_item_id")
	ErrIdempotencyKeyConflict         = errors.New("publish: idempotency key already bound to a different publish item, target account, or payload")
	ErrProviderRequestMismatch        = errors.New("publish: provider_request_id does not match the bound external effect")
)

// Lifecycle State Constants (database_schema.md §8.1, §8.2)
const (
	StateDraft                  = "draft"
	StateQueued                 = "queued"
	StateScheduled              = "scheduled"
	StateReadyToExecute         = "ready_to_execute"
	StateExecuting              = "executing"
	StatePublished              = "published"
	StatePartiallyPublished     = "partially_published"
	StateFailed                 = "failed"
	StateCancelled              = "cancelled"
	StateRequiresManualFallback = "requires_manual_fallback"

	// Job-specific states
	JobStateCreated            = "created"
	JobStateDispatched         = "dispatched"
	JobStatePartiallySucceeded = "partially_succeeded"
	JobStateSucceeded          = "succeeded"

	// Diagnostics states
	DiagnosticsHealthy  = "healthy"
	DiagnosticsWarning  = "warning"
	DiagnosticsDegraded = "degraded"
	DiagnosticsBlocked  = "blocked"

	// Result statuses
	ResultSuccess        = "success"
	ResultPartialSuccess = "partial_success"
	ResultFailed         = "failed"
	ResultTimeout        = "timeout"

	// Execution paths
	PathNativeAPI     = "native_api"
	PathManualUpload  = "manual_upload"
	PathExportPackage = "export_package"

	// Error codes
	ErrorCodeAuthRevoked        = "auth_revoked"
	ErrorCodeRateLimit          = "rate_limit_exceeded"
	ErrorCodeUnknownSubmit      = "unknown_submit"
	ErrorCodeCapabilityDegraded = "capability_degraded"
	ErrorCodeNetworkTimeout     = "network_timeout"
)

// Domain Event Names (domain_event_catalog.md §6, §16.5)
const (
	EventPublishQueued                 = "publish.queued"
	EventPublishScheduled              = "publish.scheduled"
	EventPublishExecuting              = "publish.executing"
	EventPublishSucceeded              = "publish.succeeded"
	EventPublishFailed                 = "publish.failed"
	EventPublishRequiresManualFallback = "publish.requires_manual_fallback"
	EventPublishItemSucceeded          = "publish_item.succeeded"
	EventPublishItemFailed             = "publish_item.failed"
	EventChannelPostSynced             = "channel_post.synced"
)

// PublishItem represents a database row in publish_items (§8.1).
type PublishItem struct {
	PublishItemID        string
	WorkspaceID          string
	AssetID              string
	TargetPlatform       string
	TargetAccountID      string
	TargetFormat         string
	PublishMode          string
	Title                string
	Description          string
	Hashtags             []string
	ScheduleAt           *time.Time
	CapabilitySnapshotID string
	LifecycleState       string
	DiagnosticsState     string
	LinkedOfferIDs       []string
	LinkedCampaignIDs    []string
	PackagingScore       float32
	ComplianceScanResult string
	ComplianceDetails    map[string]any
	Metadata             map[string]any
	CreatedBy            string
	CreatedAt            time.Time
	UpdatedAt            time.Time
	DeletedAt            *time.Time
}

// PublishJob represents a database row in publish_jobs (§8.2).
type PublishJob struct {
	PublishJobID         string
	WorkspaceID          string
	PublishItemID        string
	DispatchStrategy     string
	LifecycleState       string
	AttemptCount         int
	MaxAttempts          int
	CurrentWorkerID      string
	LastExecutionSummary map[string]any
	ApprovalRequestID    string
	CreatedAt            time.Time
	UpdatedAt            time.Time
	DeletedAt            *time.Time
}

// PublishLog represents an immutable database row in publish_logs (§8.3).
type PublishLog struct {
	PublishLogID         string
	WorkspaceID          string
	PublishJobID         string
	PublishItemID        string
	AttemptedAt          time.Time
	CompletedAt          *time.Time
	FailedAt             *time.Time
	ActorUserID          string
	ActingMode           string
	ExecutionPath        string
	CapabilitySnapshotID string
	ResultStatus         string
	ExternalPostID       string
	ExternalPostURL      string
	DiagnosticsRef       string
	EvidenceRef          string
	ErrorCode            string
	ErrorMessage         string
	Metadata             map[string]any
}

// ChannelPost represents a database row in channel_posts (§19.9D).
type ChannelPost struct {
	ChannelPostID      string
	WorkspaceID        string
	PublishItemID      string
	ConnectedAccountID string
	ExternalPostID     string
	ExternalPermalink  string
	Title              string
	ThumbnailURL       string
	Metrics            map[string]any
	PostMetrics        *publishv1.ChannelPostMetrics
	SourceClass        string
	Confidence         string
	SyncedAt           *time.Time
	Metadata           map[string]any
	CreatedAt          time.Time
	UpdatedAt          time.Time
}

// ExternalEffect represents a row in external_effects registry (§26.8).
type ExternalEffect struct {
	EffectID           string
	WorkspaceID        string
	OperationKey       string
	Provider           string
	ConnectedAccountID string
	AggregateType      string
	AggregateID        string
	ProviderRequestID  string
	Status             string // prepared, submitted, succeeded, failed, unknown, cancelled
	ResultPayload      map[string]any
	LastCheckedAt      *time.Time
	CreatedAt          time.Time
	UpdatedAt          time.Time
}

// DomainEvent represents an outbox event.
type DomainEvent struct {
	EventID       string
	WorkspaceID   string
	EventType     string
	AggregateType string
	AggregateID   string
	Payload       map[string]any
	OccurredAt    time.Time
}

// JitterConfig holds queue fairness and jitter settings (RULE-M11-006).
type JitterConfig struct {
	HighLoadThresholdCPM int           // Jobs per minute threshold to activate jitter (default: 100)
	MaxJitterDelay       time.Duration // Maximum delay (default: 30s)
	MaxWorkspaceQuotaPct float64       // Max fraction of slots per workspace (default: 0.20 = 20%)
}

// DefaultJitterConfig returns canonical settings from RULE-M11-006.
func DefaultJitterConfig() JitterConfig {
	return JitterConfig{
		HighLoadThresholdCPM: 100,
		MaxJitterDelay:       30 * time.Second,
		MaxWorkspaceQuotaPct: 0.20,
	}
}

// PlatformConnector defines the platform adapter interface for mock or real publishing.
type PlatformConnector interface {
	Platform() string
	PublishPost(ctx contextContext, accountID string, item *PublishItem, idempotencyKey string) (*ConnectorPublishResult, error)
	CheckPostStatus(ctx contextContext, accountID string, providerRequestID string) (*ConnectorStatusResult, error)
}

// Context wrapper alias for interface definition
type contextContext = context.Context

// ConnectorPublishResult is the direct result from a platform submission.
type ConnectorPublishResult struct {
	ProviderRequestID string
	ExternalPostID    string
	ExternalPostURL   string
	ResultStatus      string // success, failed, unknown, auth_revoked
	ErrorCode         string
	ErrorMessage      string
}

// ConnectorStatusResult is the reconciliation result from polling platform status.
type ConnectorStatusResult struct {
	ProviderRequestID  string
	OperationKey       string
	ConnectedAccountID string
	PublishItemID      string
	RequestHash        string
	ExternalPostID     string
	ExternalPostURL    string
	Found              bool
	PublishedAt        *time.Time
	Status             string // confirmed_published, confirmed_not_published, still_unknown
}

// AssetComplianceRecord represents canonical QA, rights, and consent metadata for a publishable asset.
type AssetComplianceRecord struct {
	AssetID          string
	WorkspaceID      string
	QualityState     string // approved, pass, pass_with_warnings, review_required, blocked, hard_blocked, pending
	HasHardBlocks    bool
	ViolationReasons []string
	PackagingScore   float32
	RightsVerified   bool
	ConsentRequired  bool
	ConsentRecordID  string
	CharacterID      string
	SubjectUserID    string
}

// PublishConsentRecord represents a canonical consent record verified prior to publishing.
type PublishConsentRecord struct {
	ConsentID   string
	WorkspaceID string
	CharacterID string
	UserID      string
	ConsentType string // voice_clone, voice_likeness, digital_twin, likeness_release, talent_release
	Granted     bool
	RevokedAt   *time.Time
}

// ComplianceRecordSource provides canonical QA, rights, and consent records from an authoritative store.
type ComplianceRecordSource interface {
	GetAssetComplianceRecord(ctx context.Context, workspaceID, assetID string) (*AssetComplianceRecord, error)
	GetPublishConsentRecord(ctx context.Context, workspaceID, consentID string) (*PublishConsentRecord, error)
}

// CanonicalComplianceChecker evaluates canonical QA, rights, and likeness/voice consent records before publishing.
// Always fails closed when an asset has no canonical QA/rights record or when the backing source fails.
type CanonicalComplianceChecker struct {
	mu                 sync.RWMutex
	requireAssetRecord bool
	source             ComplianceRecordSource
	assets             map[string]*AssetComplianceRecord
	consents           map[string]*PublishConsentRecord
}

// NewCanonicalComplianceChecker creates a strict compliance checker backed by canonical QA and consent records.
// Runtime compliance checking always requires a canonical asset QA/rights record and fails closed when absent.
func NewCanonicalComplianceChecker(_ bool) *CanonicalComplianceChecker {
	return &CanonicalComplianceChecker{
		requireAssetRecord: true,
		assets:             make(map[string]*AssetComplianceRecord),
		consents:           make(map[string]*PublishConsentRecord),
	}
}

// NewCanonicalComplianceCheckerWithSource creates a strict compliance checker backed by an authoritative ComplianceRecordSource.
func NewCanonicalComplianceCheckerWithSource(source ComplianceRecordSource) *CanonicalComplianceChecker {
	return &CanonicalComplianceChecker{
		requireAssetRecord: true,
		source:             source,
		assets:             make(map[string]*AssetComplianceRecord),
		consents:           make(map[string]*PublishConsentRecord),
	}
}

// NewDefaultComplianceChecker creates the default runtime compliance checker, which strictly requires
// registered canonical QA, rights, and consent records and fails closed when records are missing.
func NewDefaultComplianceChecker() *CanonicalComplianceChecker {
	return NewCanonicalComplianceChecker(true)
}

// SetRecordSource sets or updates the backing canonical compliance record source.
func (c *CanonicalComplianceChecker) SetRecordSource(source ComplianceRecordSource) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.source = source
}

// SetAssetCompliance registers or updates a canonical asset QA/rights/consent record.
func (c *CanonicalComplianceChecker) SetAssetCompliance(rec AssetComplianceRecord) {
	c.mu.Lock()
	defer c.mu.Unlock()
	cp := rec
	c.assets[strings.TrimSpace(rec.WorkspaceID)+"|"+strings.TrimSpace(rec.AssetID)] = &cp
}

// SetConsentRecord registers or updates a canonical consent record.
func (c *CanonicalComplianceChecker) SetConsentRecord(rec PublishConsentRecord) {
	c.mu.Lock()
	defer c.mu.Unlock()
	cp := rec
	c.consents[strings.TrimSpace(rec.WorkspaceID)+"|"+strings.TrimSpace(rec.ConsentID)] = &cp
}

// RevokeConsent marks a canonical consent record as revoked.
func (c *CanonicalComplianceChecker) RevokeConsent(workspaceID, consentID string) {
	c.mu.Lock()
	defer c.mu.Unlock()
	key := strings.TrimSpace(workspaceID) + "|" + strings.TrimSpace(consentID)
	if cr, ok := c.consents[key]; ok && cr != nil {
		now := time.Now().UTC()
		cr.Granted = false
		cr.RevokedAt = &now
	}
}

func isValidPublishConsentType(consentType string) bool {
	switch strings.ToLower(strings.TrimSpace(consentType)) {
	case "voice_clone", "voice_likeness", "digital_twin", "likeness_release", "talent_release":
		return true
	default:
		return false
	}
}

// CheckPublishCompliance implements ComplianceChecker.
func (c *CanonicalComplianceChecker) CheckPublishCompliance(ctx context.Context, workspaceID, assetID, _ string) (string, bool, map[string]any, error) {
	workspaceID = strings.TrimSpace(workspaceID)
	assetID = strings.TrimSpace(assetID)
	if workspaceID == "" {
		return "blocked", true, map[string]any{"has_hard_blocks": true}, ErrPermissionDenied
	}

	c.mu.RLock()
	if assetID != "" {
		for k, other := range c.assets {
			if strings.HasSuffix(k, "|"+assetID) && other != nil && other.WorkspaceID != "" && other.WorkspaceID != workspaceID {
				c.mu.RUnlock()
				return "blocked", true, map[string]any{"has_hard_blocks": true, "reason": "cross_tenant_asset"}, ErrPermissionDenied
			}
		}
	}
	var rec *AssetComplianceRecord
	if assetID != "" {
		if r := c.assets[workspaceID+"|"+assetID]; r != nil {
			cp := *r
			rec = &cp
		}
	}
	source := c.source
	c.mu.RUnlock()

	if rec == nil && source != nil && assetID != "" {
		srcRec, srcErr := source.GetAssetComplianceRecord(ctx, workspaceID, assetID)
		if srcErr != nil {
			return "unverified", true, map[string]any{
				"has_hard_blocks": true,
				"reason":          "canonical_qa_source_error",
			}, fmt.Errorf("%w: %v", ErrComplianceHardBlocked, srcErr)
		}
		if srcRec != nil {
			if srcRec.WorkspaceID != "" && strings.TrimSpace(srcRec.WorkspaceID) != workspaceID {
				return "blocked", true, map[string]any{"has_hard_blocks": true, "reason": "cross_tenant_asset"}, ErrPermissionDenied
			}
			cp := *srcRec
			rec = &cp
		}
	}

	if assetID == "" || rec == nil {
		return "unverified", true, map[string]any{
			"has_hard_blocks": true,
			"reason":          "canonical_qa_report_missing",
		}, ErrComplianceHardBlocked
	}

	score := rec.PackagingScore
	if score == 0 {
		score = 85.0
	}
	details := map[string]any{
		"packaging_score": score,
		"rights_verified": rec.RightsVerified,
	}
	if len(rec.ViolationReasons) > 0 {
		details["violation_reasons"] = append([]string(nil), rec.ViolationReasons...)
	}

	qs := strings.ToLower(strings.TrimSpace(rec.QualityState))
	if rec.HasHardBlocks || qs == "blocked" || qs == "hard_blocked" || qs == "fail" || qs == "rejected" {
		details["has_hard_blocks"] = true
		return "blocked", true, details, nil
	}
	if !rec.RightsVerified {
		details["has_hard_blocks"] = true
		details["rights_blocked"] = true
		return "blocked", true, details, ErrComplianceHardBlocked
	}

	if rec.ConsentRequired || strings.TrimSpace(rec.ConsentRecordID) != "" {
		details["consent_required"] = true
		cid := strings.TrimSpace(rec.ConsentRecordID)
		if cid == "" {
			details["consent_verified"] = false
			details["has_hard_blocks"] = true
			return "blocked", true, details, ErrComplianceHardBlocked
		}
		c.mu.RLock()
		var cr *PublishConsentRecord
		if stored := c.consents[workspaceID+"|"+cid]; stored != nil {
			cp := *stored
			cr = &cp
		}
		c.mu.RUnlock()

		if cr == nil && source != nil {
			srcConsent, cErr := source.GetPublishConsentRecord(ctx, workspaceID, cid)
			if cErr != nil {
				details["consent_verified"] = false
				details["has_hard_blocks"] = true
				details["reason"] = "canonical_consent_source_error"
				return "blocked", true, details, fmt.Errorf("%w: %v", ErrComplianceHardBlocked, cErr)
			}
			if srcConsent != nil {
				cp := *srcConsent
				cr = &cp
			}
		}

		if cr == nil || (cr.WorkspaceID != "" && strings.TrimSpace(cr.WorkspaceID) != workspaceID) || !cr.Granted || cr.RevokedAt != nil {
			details["consent_verified"] = false
			details["consent_revoked"] = true
			details["has_hard_blocks"] = true
			return "blocked", true, details, ErrComplianceHardBlocked
		}
		if !isValidPublishConsentType(cr.ConsentType) {
			details["consent_verified"] = false
			details["has_hard_blocks"] = true
			return "blocked", true, details, ErrComplianceHardBlocked
		}
		if reqChar := strings.TrimSpace(rec.CharacterID); reqChar != "" {
			if strings.TrimSpace(cr.CharacterID) == "" || strings.TrimSpace(cr.CharacterID) != reqChar {
				details["consent_verified"] = false
				details["has_hard_blocks"] = true
				return "blocked", true, details, ErrComplianceHardBlocked
			}
		}
		if reqUser := strings.TrimSpace(rec.SubjectUserID); reqUser != "" {
			if strings.TrimSpace(cr.UserID) == "" || strings.TrimSpace(cr.UserID) != reqUser {
				details["consent_verified"] = false
				details["has_hard_blocks"] = true
				return "blocked", true, details, ErrComplianceHardBlocked
			}
		}
		details["consent_verified"] = true
		details["consent_record_id"] = cid
	} else {
		details["consent_verified"] = true
	}

	switch qs {
	case "review_required":
		return "review_required", false, details, nil
	case "approved", "pass":
		return "pass", false, details, nil
	case "pass_with_warnings":
		return "pass_with_warnings", false, details, nil
	default:
		details["has_hard_blocks"] = true
		return "unverified", true, details, ErrComplianceHardBlocked
	}
}

// Helpers for UUID generation (RFC 4122 v4)
func NewID() string {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		panic(fmt.Sprintf("publish: crypto/rand failed: %v", err))
	}
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

package publish

import (
	"context"
	"crypto/rand"
	"errors"
	"fmt"
	"time"

	publishv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1"
)

// Standard Publish Domain Errors (error_catalog.md & publish_hub.md)
var (
	ErrItemNotFound           = errors.New("publish: publish item not found")
	ErrJobNotFound            = errors.New("publish: publish job not found")
	ErrAccountNotFound        = errors.New("publish: connected account not found")
	ErrPrematurePublish       = errors.New("publish: invariant violation - cannot publish before scheduled time (RULE-M11-006)")
	ErrAuthRevoked            = errors.New("publish: connector authentication revoked or expired (auth_revoked)")
	ErrCapabilityDegraded     = errors.New("publish: platform capability degraded or unsupported, requires manual fallback")
	ErrApprovalRequired       = errors.New("publish: publish requires human approval gate before execution")
	ErrUnknownSubmit          = errors.New("publish: submission outcome unknown, pending reconciliation before retry")
	ErrDuplicatePostPrevented = errors.New("publish: duplicate post prevented by reconciliation check")
	ErrInvalidState           = errors.New("publish: invalid lifecycle state transition")
	ErrProofRequired          = errors.New("publish: evidence ref or screenshot URL required for manual proof")
	ErrRateLimitExceeded      = errors.New("publish: platform rate limit exceeded")
	ErrStoreNotConfigured     = errors.New("publish: durable store is not configured (fail-closed)")
	ErrUnauthenticated        = errors.New("publish: unauthenticated caller principal")
	ErrPermissionDenied       = errors.New("publish: permission denied or workspace scope mismatch")
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
	ProviderRequestID string
	ExternalPostID    string
	ExternalPostURL   string
	Found             bool
	PublishedAt       *time.Time
	Status            string // confirmed_published, confirmed_not_published, still_unknown
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

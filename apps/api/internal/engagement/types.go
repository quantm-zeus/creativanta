package engagement

import (
	"crypto/rand"
	"errors"
	"fmt"
	"strings"
	"time"
)

// Domain Errors (error_catalog.md & unified_inbox.md)
var (
	ErrThreadNotFound            = errors.New("engagement: thread not found")
	ErrMessageNotFound           = errors.New("engagement: message not found")
	ErrEntityNotFound            = errors.New("engagement: entity not found")
	ErrTaskNotFound              = errors.New("engagement: follow-up task not found")
	ErrAccountNotFound           = errors.New("engagement: connected account not found")
	ErrInvalidStateTransition    = errors.New("engagement: invalid thread status transition")
	ErrMandatoryFieldsMissing    = errors.New("engagement: thread must have owner_user_id, intent, status, and next_action (RULE-M12-001)")
	ErrMessagingWindowExpired    = errors.New("engagement: messaging window expired (24h limit reached). Standard reply denied (RULE-M12-006, connector_specs)")
	ErrBotLoopDetected           = errors.New("engagement: bot-loop circuit breaker triggered: >=3 consecutive bot replies detected. Auto-reply paused on thread (RULE-M12-008)")
	ErrBotLoopRateLimitExceeded  = errors.New("engagement: bot-loop circuit breaker triggered: >=5 auto-replies in 5 minutes (RULE-M12-008)")
	ErrBotLoopSimilarityDetected = errors.New("engagement: bot-loop circuit breaker triggered: consecutive auto-reply text similarity >80% (RULE-M12-008)")
	ErrBotLoopHourlyCapExceeded  = errors.New("engagement: bot-loop hard cap reached: max 10 auto-replies per thread per hour (RULE-M12-008)")
	ErrBotLoopPermanentDisabled  = errors.New("engagement: auto-reply permanently disabled on this thread after repeated loop detections (RULE-M12-008)")
	ErrViralSurgeCircuitBreaker  = errors.New("engagement: viral surge circuit breaker active (>500 msg/min): real-time AI paused, messages ingested raw (RULE-M12-007)")
	ErrGhostMessageDeleted       = errors.New("engagement: ghost message detected (404 Not Found): content deleted by user. Compose disabled (A4)")
	ErrGhostMessageRestricted    = errors.New("engagement: ghost message detected (403 Forbidden): post restricted by platform. Compose disabled (A4)")
	ErrGhostMessagePermanent     = errors.New("engagement: ghost message detected (410 Gone): content permanently removed. Thread archived (A4)")
	ErrAccountRevoked            = errors.New("engagement: connected account token revoked or expired (auth_revoked). Please reconnect account (A4)")
	ErrAccountNotRevoked         = errors.New("engagement: connected account is not in revoked state")
	ErrReplyIdentityRequired     = errors.New("engagement: reply-as identity required when sending reply (RULE-M12-006)")
	ErrPermissionDenied          = errors.New("engagement: permission denied for requested action")
)

// Thread Lifecycle States (database_schema.md §9.2, RULE-M12-003)
const (
	StatusNew             = "new"
	StatusTriaged         = "triaged"
	StatusActive          = "active"
	StatusWaitingOnUser   = "waiting_on_user"
	StatusWaitingOnTeam   = "waiting_on_team"
	StatusSnoozed         = "snoozed"
	StatusStale           = "stale"
	StatusConvertedToTask = "converted_to_task"
	StatusResolved        = "resolved"
	StatusArchived        = "archived"
)

// Thread Types
const (
	ThreadTypeComment        = "comment"
	ThreadTypeDM             = "dm"
	ThreadTypeInquiry        = "inquiry"
	ThreadTypeSponsorInquiry = "sponsor_inquiry"
	ThreadTypeSampleRequest  = "sample_request"
	ThreadTypeSupport        = "support"
)

// Priorities
const (
	PriorityLow    = "low"
	PriorityNormal = "normal"
	PriorityHigh   = "high"
	PriorityUrgent = "urgent"
)

// Intent Types
const (
	IntentQuestion         = "question"
	IntentPurchaseInterest = "purchase_interest"
	IntentSupportIssue     = "support_issue"
	IntentObjection        = "objection"
	IntentSponsorInterest  = "sponsor_interest"
	IntentSampleRequest    = "sample_request"
	IntentModerationRisk   = "moderation_risk"
	IntentUnknown          = "unknown"
)

// Message Subtypes & Author Directions (database_schema.md §9.3)
const (
	SubtypeComment = "comment"
	SubtypeDM      = "dm"
	SubtypeInquiry = "inquiry"
	SubtypeReply   = "reply"
	SubtypeSystem  = "system"

	DirectionInbound  = "inbound"
	DirectionOutbound = "outbound"
	DirectionSystem   = "system"
)

// Ghost Status Constants (A4)
const (
	GhostNone                 = "none"
	GhostDeletedByUser        = "deleted_by_user"
	GhostRestrictedByPlatform = "restricted_by_platform"
	GhostPermanentlyRemoved   = "permanently_removed"
)

// Throttle Modes (RULE-M12-007)
const (
	ThrottleNormal         = "normal"
	ThrottleThrottled      = "throttled"
	ThrottleCircuitBreaker = "circuit_breaker"
)

// Follow-up Task States (database_schema.md §9.4)
const (
	TaskStatusOpen       = "open"
	TaskStatusInProgress = "in_progress"
	TaskStatusBlocked    = "blocked"
	TaskStatusCompleted  = "completed"
	TaskStatusCancelled  = "cancelled"
)

// Domain Event Names (domain_event_catalog.md §7, §16.4)
const (
	EventThreadCreated          = "thread.created"
	EventThreadIntentClassified = "thread.intent_classified"
	EventThreadAssigned         = "thread.assigned"
	EventThreadPriorityChanged  = "thread.priority_changed"
	EventThreadResolved         = "thread.resolved"
	EventThreadSLAApproaching   = "thread.sla_approaching"
	EventThreadSLABreached      = "thread.sla_breached"
	EventMessageReceived        = "message.received"
	EventSponsorInquiryDetected = "sponsor_inquiry.detected"
	EventSampleRequestCreated   = "sample_request.created"
	EventFollowUpTaskCreated    = "follow_up_task.created"
	EventBotLoopDetected        = "thread.bot_loop_detected"
	EventViralSurgeStateChanged = "engagement.viral_surge_state_changed"
)

// DomainEvent represents a standard domain event envelope.
type DomainEvent struct {
	EventID       string                 `json:"event_id"`
	EventType     string                 `json:"event_type"`
	AggregateType string                 `json:"aggregate_type"`
	AggregateID   string                 `json:"aggregate_id"`
	WorkspaceID   string                 `json:"workspace_id"`
	Timestamp     time.Time              `json:"timestamp"`
	Payload       map[string]interface{} `json:"payload"`
}

// RelatedObjectRef links a thread to downstream business objects (RULE-M12-005).
type RelatedObjectRef struct {
	Type         string `json:"type"` // "idea", "brand_deal", "sample_request", "offer", "follow_up_task"
	ID           string `json:"id"`
	Label        string `json:"label,omitempty"`
	TaskRef      string `json:"task_ref,omitempty"`       // e.g. "P6-01", "P6-09"
	Phase        string `json:"phase,omitempty"`          // e.g. "P6"
	IsP6Deferred bool   `json:"is_p6_deferred,omitempty"` // true for commerce/seeding operations scheduled for P6
	Status       string `json:"status,omitempty"`         // e.g. "pending_p6_delivery"
}

// ReplyIdentity represents the color-coded sender badge in multi-account compose (RULE-M12-006).
type ReplyIdentity struct {
	AccountID   string `json:"account_id"`
	Platform    string `json:"platform"`
	AccountName string `json:"account_name"`
	AvatarURL   string `json:"avatar_url"`
	BadgeColor  string `json:"badge_color"`
	IsRevoked   bool   `json:"is_revoked"`
}

// Thread represents the database row in threads (database_schema.md §9.2).
type Thread struct {
	ThreadID          string
	WorkspaceID       string
	ThreadType        string
	EntityID          string
	SourcePlatform    string
	SourcePostID      string
	OwnerUserID       string
	Intent            string
	Priority          string
	Status            string
	NextAction        string
	SLADueAt          *time.Time
	RelatedObjectRefs []RelatedObjectRef
	LastActivityAt    time.Time
	MessageCount      int
	CreatedAt         time.Time
	UpdatedAt         time.Time
	DeletedAt         *time.Time

	// Acceptance target fields
	MessagingWindowExpiresAt     *time.Time
	AutoReplyPaused              bool
	AutoReplyConsecutiveCount    int
	AutoReplyHourCount           int
	LastAutoReplyAt              *time.Time
	AutoReplyPermanentlyDisabled bool
	IsGhost                      bool
	GhostStatus                  string
	ThrottleState                string
	ConnectedAccountID           string
	AccountRevoked               bool
	RecentAutoReplies            []time.Time // in-memory sliding window for loop checks
	LastAutoReplyText            string
	LoopDetectionCount           int // track resets vs permanent disable
}

// Message represents the database row in messages (database_schema.md §9.3).
type Message struct {
	MessageID         string
	WorkspaceID       string
	ThreadID          string
	Subtype           string
	SourcePlatform    string
	Body              string
	AuthorDirection   string
	AuthorEntityID    string
	AuthorUserID      string
	ModerationState   string
	IntentOverlay     string
	Attachments       []string
	ExternalMessageID string
	CreatedAt         time.Time
}

// Entity represents the database row in entities (database_schema.md §9.1).
type Entity struct {
	EntityID          string
	WorkspaceID       string
	EntityType        string
	DisplayName       string
	PlatformHandles   []string
	RelationshipState string
	Tags              []string
	Metadata          map[string]string
	CreatedAt         time.Time
	UpdatedAt         time.Time
	DeletedAt         *time.Time
}

// FollowUpTask represents the database row in follow_up_tasks (database_schema.md §9.4).
type FollowUpTask struct {
	TaskID           string
	WorkspaceID      string
	SourceThreadID   string
	SourceObjectType string
	SourceObjectID   string
	AssignedUserID   string
	TaskType         string
	Title            string
	Description      string
	DueAt            *time.Time
	Status           string
	OutcomeSummary   string
	TaskRef          string
	Phase            string
	IsP6Deferred     bool
	CreatedAt        time.Time
	UpdatedAt        time.Time
	DeletedAt        *time.Time
}

// EngagementThrottle represents real-time ingestion rate & viral surge protection (RULE-M12-007).
type EngagementThrottle struct {
	ThrottleID          string
	WorkspaceID         string
	CurrentRatePerMin   int
	ThrottleMode        string
	UnprocessedRawCount int
	LastSurgeAt         *time.Time
	LastEvaluatedAt     time.Time
	CreatedAt           time.Time
	UpdatedAt           time.Time
}

// ComputeTextSimilarity calculates character trigram or word-based Jaccard similarity (0..1).
// Per RULE-M12-008: >80% similarity between consecutive auto-replies triggers immediate stop.
func ComputeTextSimilarity(s1, s2 string) float64 {
	w1 := strings.Fields(strings.ToLower(s1))
	w2 := strings.Fields(strings.ToLower(s2))
	if len(w1) == 0 && len(w2) == 0 {
		return 1.0
	}
	if len(w1) == 0 || len(w2) == 0 {
		return 0.0
	}

	set1 := make(map[string]struct{}, len(w1))
	for _, w := range w1 {
		set1[w] = struct{}{}
	}
	set2 := make(map[string]struct{}, len(w2))
	for _, w := range w2 {
		set2[w] = struct{}{}
	}

	intersection := 0
	for k := range set1 {
		if _, ok := set2[k]; ok {
			intersection++
		}
	}
	union := len(set1) + len(set2) - intersection
	if union == 0 {
		return 1.0
	}
	return float64(intersection) / float64(union)
}

// NewUUID generates a pseudorandom RFC 4122 v4 UUID string for deterministic testing.
func NewUUID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%12x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// ValidateStatusTransition verifies valid transitions per RULE-M12-003.
func ValidateStatusTransition(from, to string) bool {
	if from == to {
		return true
	}
	switch from {
	case StatusNew:
		return to == StatusTriaged || to == StatusActive || to == StatusArchived || to == StatusSnoozed
	case StatusTriaged:
		return to == StatusActive || to == StatusArchived || to == StatusSnoozed || to == StatusConvertedToTask
	case StatusActive:
		return to == StatusWaitingOnUser || to == StatusWaitingOnTeam || to == StatusSnoozed ||
			to == StatusStale || to == StatusConvertedToTask || to == StatusResolved || to == StatusArchived
	case StatusWaitingOnUser:
		return to == StatusActive || to == StatusResolved || to == StatusArchived || to == StatusSnoozed || to == StatusStale
	case StatusWaitingOnTeam:
		return to == StatusActive || to == StatusResolved || to == StatusArchived || to == StatusSnoozed || to == StatusStale
	case StatusSnoozed:
		return to == StatusActive || to == StatusArchived || to == StatusResolved
	case StatusStale:
		return to == StatusActive || to == StatusArchived || to == StatusResolved
	case StatusConvertedToTask:
		return to == StatusActive || to == StatusResolved || to == StatusArchived
	case StatusResolved:
		return to == StatusActive || to == StatusArchived
	case StatusArchived:
		return false // Archived is terminal
	default:
		return false
	}
}

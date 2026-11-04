package livecommerce

import (
	"crypto/rand"
	"fmt"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func newUUID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

type SessionStatus string

const (
	SessionStatusPlanned            SessionStatus = "planned"
	SessionStatusReady              SessionStatus = "ready"
	SessionStatusLive               SessionStatus = "live"
	SessionStatusPaused             SessionStatus = "paused"
	SessionStatusEnded              SessionStatus = "ended"
	SessionStatusPostLiveProcessing SessionStatus = "post_live_processing"
	SessionStatusClosed             SessionStatus = "closed"
)

// IsValidTransition enforces RULE-M17-001 canonical state machine.
func (s SessionStatus) CanTransitionTo(next SessionStatus) bool {
	switch s {
	case SessionStatusPlanned:
		return next == SessionStatusReady || next == SessionStatusLive || next == SessionStatusClosed
	case SessionStatusReady:
		return next == SessionStatusLive || next == SessionStatusPlanned || next == SessionStatusEnded
	case SessionStatusLive:
		return next == SessionStatusPaused || next == SessionStatusEnded
	case SessionStatusPaused:
		return next == SessionStatusLive || next == SessionStatusEnded
	case SessionStatusEnded:
		return next == SessionStatusPostLiveProcessing || next == SessionStatusClosed
	case SessionStatusPostLiveProcessing:
		return next == SessionStatusClosed || next == SessionStatusEnded
	case SessionStatusClosed:
		// Reopening allowed under edge case EC-M17-002 if late orders arrive
		return next == SessionStatusPostLiveProcessing
	default:
		return false
	}
}

type CueStatus string

const (
	CueStatusPending CueStatus = "pending"
	CueStatusActive  CueStatus = "active"
	CueStatusUsed    CueStatus = "used"
	CueStatusSkipped CueStatus = "skipped"
)

// RunOfShowItem represents an item in the live session script.
// database_schema.md §25.2
type RunOfShowItem struct {
	TimeOffsetMin int32      `json:"time_offset_min"`
	Type          string     `json:"type"` // product_pin, poll, giveaway, cta, break, talking_point
	Title         string     `json:"title"`
	ProductID     string     `json:"product_id,omitempty"`
	OfferID       string     `json:"offer_id,omitempty"`
	Notes         string     `json:"notes,omitempty"`
	DurationMin   int32      `json:"duration_min,omitempty"`
	Executed      bool       `json:"executed"`
	ExecutedAt    *time.Time `json:"executed_at,omitempty"`
	CueCardIDs    []string   `json:"cue_card_ids,omitempty"`
}

// LiveMetricsSnapshot captures metrics during and post live.
// database_schema.md §25.2
type LiveMetricsSnapshot struct {
	PeakViewers       int64                 `json:"peak_viewers"`
	AvgViewers        int64                 `json:"avg_viewers"`
	TotalViewers      int64                 `json:"total_viewers"`
	TotalComments     int64                 `json:"total_comments"`
	TotalLikes        int64                 `json:"total_likes"`
	TotalShares       int64                 `json:"total_shares"`
	ProductsShown     int32                 `json:"products_shown"`
	OrdersDuringLive  int64                 `json:"orders_during_live"`
	RevenueDuringLive tenantdb.ExactDecimal `json:"revenue_during_live"`
	RevenueCurrency   string                `json:"revenue_currency"`
	EngagementRate    float64               `json:"engagement_rate"`
}

// LiveSession represents a live commerce session (database_schema.md §12.1).
type LiveSession struct {
	SessionID          string              `json:"session_id"`
	WorkspaceID        string              `json:"workspace_id"`
	Title              string              `json:"title"`
	Platform           string              `json:"platform"`
	ConnectedAccountID string              `json:"connected_account_id,omitempty"`
	Status             SessionStatus       `json:"status"`
	PlannedStartAt     *time.Time          `json:"planned_start_at,omitempty"`
	ActualStartAt      *time.Time          `json:"actual_start_at,omitempty"`
	ActualEndAt        *time.Time          `json:"actual_end_at,omitempty"`
	RunOfShow          []RunOfShowItem     `json:"run_of_show"`
	MetricsSnapshot    LiveMetricsSnapshot `json:"metrics_snapshot"`
	Metadata           map[string]any      `json:"metadata"`
	CreatedAt          time.Time           `json:"created_at"`
	UpdatedAt          time.Time           `json:"updated_at"`
	DeletedAt          *time.Time          `json:"deleted_at,omitempty"`
}

// CueCard represents an operational prompt during live (database_schema.md §19.9B).
type CueCard struct {
	CueCardID       string     `json:"cue_card_id"`
	SessionID       string     `json:"session_id"`
	WorkspaceID     string     `json:"workspace_id"`
	SegmentID       string     `json:"segment_id,omitempty"`
	CueType         string     `json:"cue_type"`
	Title           string     `json:"title"`
	Body            string     `json:"body"`
	PinnedProductID string     `json:"pinned_product_id,omitempty"`
	PinnedOfferID   string     `json:"pinned_offer_id,omitempty"`
	DisplayOrder    int32      `json:"display_order"`
	TriggeredAt     *time.Time `json:"triggered_at,omitempty"`
	Status          CueStatus  `json:"status"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
}

// Highlight represents a tagged moment during live for post-live clip extraction (database_schema.md §19.9C).
type Highlight struct {
	HighlightID        string    `json:"highlight_id"`
	SessionID          string    `json:"session_id"`
	WorkspaceID        string    `json:"workspace_id"`
	Title              string    `json:"title"`
	StartOffsetSeconds int32     `json:"start_offset_seconds"`
	EndOffsetSeconds   int32     `json:"end_offset_seconds"`
	HighlightType      string    `json:"highlight_type"`
	AutoDetected       bool      `json:"auto_detected"`
	AssetID            string    `json:"asset_id,omitempty"` // Extracted clip derivative in M09
	EngagementScore    float64   `json:"engagement_score"`
	Notes              string    `json:"notes,omitempty"`
	PinnedOfferID      string    `json:"pinned_offer_id,omitempty"`
	PinnedProductID    string    `json:"pinned_product_id,omitempty"`
	CreatedAt          time.Time `json:"created_at"`
	UpdatedAt          time.Time `json:"updated_at"`
}

// TraceableOrderLink represents a traceable link in the revenue chain:
// Live Session -> Product -> Offer -> Order -> Revenue.
type TraceableOrderLink struct {
	OrderID             string                `json:"order_id"`
	ProductID           string                `json:"product_id"`
	OfferID             string                `json:"offer_id"`
	CustomerID          string                `json:"customer_id"`
	Amount              tenantdb.ExactDecimal `json:"amount"`
	Currency            string                `json:"currency"`
	CreatedAt           time.Time             `json:"created_at"`
	ReconciliationState string                `json:"reconciliation_state"`
}

// PostLiveProofSummary represents the post-live proof document (RULE-M17-003, RULE-M17-004).
type PostLiveProofSummary struct {
	SummaryID             string                `json:"summary_id"`
	SessionID             string                `json:"session_id"`
	WorkspaceID           string                `json:"workspace_id"`
	SessionTitle          string                `json:"session_title"`
	Platform              string                `json:"platform"`
	Metrics               LiveMetricsSnapshot   `json:"metrics"`
	Highlights            []Highlight           `json:"highlights"`
	ExtractedClipAssetIDs []string              `json:"extracted_clip_asset_ids"`
	Orders                []TraceableOrderLink  `json:"orders"`
	TotalRevenue          tenantdb.ExactDecimal `json:"total_revenue"`
	RevenueCurrency       string                `json:"revenue_currency"`
	SourceClass           string                `json:"source_class"` // "live_attributed"
	ProofBundleID         string                `json:"proof_bundle_id"`
	GeneratedAt           time.Time             `json:"generated_at"`
}

// CommandExecutionRecord ensures durable idempotency across reconnects (Acceptance Target 1).
type CommandExecutionRecord struct {
	IdempotencyKey string    `json:"idempotency_key"`
	WorkspaceID    string    `json:"workspace_id"`
	SessionID      string    `json:"session_id"`
	CommandType    string    `json:"command_type"`
	ExecutedAt     time.Time `json:"executed_at"`
	ResponseJSON   []byte    `json:"response_json"`
}

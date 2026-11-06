package affiliate

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

type LinkLifecycleState string

const (
	LinkStateDraft   LinkLifecycleState = "draft"
	LinkStateActive  LinkLifecycleState = "active"
	LinkStatePaused  LinkLifecycleState = "paused"
	LinkStateRevoked LinkLifecycleState = "revoked"
	LinkStateExpired LinkLifecycleState = "expired"
)

type HealthStatus string

const (
	HealthStatusHealthy            HealthStatus = "healthy"
	HealthStatusWarning            HealthStatus = "warning"
	HealthStatusBroken             HealthStatus = "broken"
	HealthStatusExpired            HealthStatus = "expired"
	HealthStatusProductUnavailable HealthStatus = "product_unavailable"
)

type SourceClass string

const (
	SourceClassOfficial     SourceClass = "official"
	SourceClassImported     SourceClass = "imported"
	SourceClassInferred     SourceClass = "inferred"
	SourceClassEstimated    SourceClass = "estimated"
	SourceClassUnreconciled SourceClass = "unreconciled"
)

type ConfidenceLevel string

const (
	ConfidenceHigh   ConfidenceLevel = "high"
	ConfidenceMedium ConfidenceLevel = "medium"
	ConfidenceLow    ConfidenceLevel = "low"
)

type CommissionState string

const (
	CommissionPending    CommissionState = "pending"
	CommissionConfirmed  CommissionState = "confirmed"
	CommissionClawedBack CommissionState = "clawed_back"
	CommissionPaidOut    CommissionState = "paid_out"
)

type PayoutState string

const (
	PayoutPending    PayoutState = "pending"
	PayoutProcessing PayoutState = "processing"
	PayoutCompleted  PayoutState = "completed"
	PayoutFailed     PayoutState = "failed"
)

type AssignmentState string

const (
	AssignmentActive    AssignmentState = "active"
	AssignmentCompleted AssignmentState = "completed"
	AssignmentCancelled AssignmentState = "cancelled"
)

type EconomicRole string

const (
	EconomicRoleCreator EconomicRole = "creator"
	EconomicRoleSeller  EconomicRole = "seller"
)

// AffiliateLink models affiliate_links (§10.4).
type AffiliateLink struct {
	AffiliateLinkID               string                `json:"affiliate_link_id"`
	WorkspaceID                   string                `json:"workspace_id"`
	ProductID                     *string               `json:"product_id,omitempty"`
	OfferID                       *string               `json:"offer_id,omitempty"`
	CampaignID                    *string               `json:"campaign_id,omitempty"`
	Platform                      string                `json:"platform"`
	OriginalURL                   string                `json:"original_url"`
	TrackedURL                    string                `json:"tracked_url"`
	ShortCode                     string                `json:"short_code,omitempty"`
	CommissionRate                tenantdb.ExactDecimal `json:"commission_rate"`
	LifecycleState                LinkLifecycleState    `json:"lifecycle_state"`
	HealthStatus                  HealthStatus          `json:"health_status"`
	LastHealthCheckAt             *time.Time            `json:"last_health_check_at,omitempty"`
	ClickCount                    int32                 `json:"click_count"`
	ConversionCount               int32                 `json:"conversion_count"`
	RevenueAttributed             tenantdb.ExactDecimal `json:"revenue_attributed"`
	ExpiresAt                     *time.Time            `json:"expires_at,omitempty"`
	SuggestedReplacementProductID *string               `json:"suggested_replacement_product_id,omitempty"`
	CreatedAt                     time.Time             `json:"created_at"`
	UpdatedAt                     time.Time             `json:"updated_at"`
	DeletedAt                     *time.Time            `json:"deleted_at,omitempty"`
}

// CreatorAssignment models creator_assignments.
type CreatorAssignment struct {
	AssignmentID    string          `json:"assignment_id"`
	WorkspaceID     string          `json:"workspace_id"`
	CampaignID      *string         `json:"campaign_id,omitempty"`
	CreatorEntityID string          `json:"creator_entity_id"`
	AffiliateLinkID *string         `json:"affiliate_link_id,omitempty"`
	CouponID        *string         `json:"coupon_id,omitempty"`
	Status          AssignmentState `json:"status"`
	Notes           string          `json:"notes,omitempty"`
	CreatedAt       time.Time       `json:"created_at"`
	UpdatedAt       time.Time       `json:"updated_at"`
	DeletedAt       *time.Time      `json:"deleted_at,omitempty"`
}

// AttributionRecord models affiliate_attributions with source_class provenance.
type AttributionRecord struct {
	AttributionID     string                `json:"attribution_id"`
	WorkspaceID       string                `json:"workspace_id"`
	OrderID           string                `json:"order_id"`
	AffiliateLinkID   string                `json:"affiliate_link_id"`
	CreatorEntityID   *string               `json:"creator_entity_id,omitempty"`
	ClickID           string                `json:"click_id,omitempty"`
	TouchpointCount   int32                 `json:"touchpoint_count"`
	IsMultiTouch      bool                  `json:"is_multi_touch"`
	SourceClass       SourceClass           `json:"source_class"`
	Confidence        ConfidenceLevel       `json:"confidence"`
	AttributionNote   string                `json:"attribution_note,omitempty"`
	OrderAmount       tenantdb.ExactDecimal `json:"order_amount"`
	AttributedRevenue tenantdb.ExactDecimal `json:"attributed_revenue"`
	CommissionAmount  tenantdb.ExactDecimal `json:"commission_amount"`
	Currency          string                `json:"currency"`
	CreatedAt         time.Time             `json:"created_at"`
	UpdatedAt         time.Time             `json:"updated_at"`
}

// AffiliateCommission models affiliate_commissions (§10.4B).
type AffiliateCommission struct {
	CommissionID     string                 `json:"commission_id"`
	WorkspaceID      string                 `json:"workspace_id"`
	AffiliateLinkID  string                 `json:"affiliate_link_id"`
	OrderID          string                 `json:"order_id"`
	CreatorEntityID  *string                `json:"creator_entity_id,omitempty"`
	OrderAmount      tenantdb.ExactDecimal  `json:"order_amount"`
	CommissionAmount tenantdb.ExactDecimal  `json:"commission_amount"`
	Currency         string                 `json:"currency"`
	Status           CommissionState        `json:"status"`
	HoldUntil        time.Time              `json:"hold_until"`
	ClawbackReason   string                 `json:"clawback_reason,omitempty"`
	ClawbackAmount   *tenantdb.ExactDecimal `json:"clawback_amount,omitempty"`
	PayoutID         *string                `json:"payout_id,omitempty"`
	ConfirmedAt      *time.Time             `json:"confirmed_at,omitempty"`
	ClawedBackAt     *time.Time             `json:"clawed_back_at,omitempty"`
	PaidOutAt        *time.Time             `json:"paid_out_at,omitempty"`
	CreatedAt        time.Time              `json:"created_at"`
	UpdatedAt        time.Time              `json:"updated_at"`
}

// VerifiedOrder represents an authoritative, tenant-scoped order snapshot
// eligible for affiliate attribution and commission calculation.
type VerifiedOrder struct {
	OrderID        string                `json:"order_id"`
	WorkspaceID    string                `json:"workspace_id"`
	GrossAmount    tenantdb.ExactDecimal `json:"gross_amount"`
	RefundedAmount tenantdb.ExactDecimal `json:"refunded_amount"`
	Currency       string                `json:"currency"`
	LifecycleState string                `json:"lifecycle_state"`
	CreatedAt      time.Time             `json:"created_at"`
	UpdatedAt      time.Time             `json:"updated_at"`
}

// VerifiedSettlement represents an authoritative, tenant-scoped settlement record
// verified to back an affiliate payout batch.
type VerifiedSettlement struct {
	SettlementID       string                `json:"settlement_id"`
	WorkspaceID        string                `json:"workspace_id"`
	CreatorEntityID    string                `json:"creator_entity_id"`
	NetAmount          tenantdb.ExactDecimal `json:"net_amount"`
	AllocatedAmount    tenantdb.ExactDecimal `json:"allocated_amount"`
	Currency           string                `json:"currency"`
	VerificationStatus string                `json:"verification_status"`
	BoundPayoutID      *string               `json:"bound_payout_id,omitempty"`
	CreatedAt          time.Time             `json:"created_at"`
	UpdatedAt          time.Time             `json:"updated_at"`
}

// AffiliatePayout models affiliate_payouts batch.
type AffiliatePayout struct {
	PayoutID        string                `json:"payout_id"`
	WorkspaceID     string                `json:"workspace_id"`
	CreatorEntityID string                `json:"creator_entity_id"`
	CommissionIDs   []string              `json:"commission_ids"`
	TotalAmount     tenantdb.ExactDecimal `json:"total_amount"`
	Currency        string                `json:"currency"`
	Status          PayoutState           `json:"status"`
	ProofHash       string                `json:"proof_hash,omitempty"`
	ProofMetadata   map[string]any        `json:"proof_metadata,omitempty"`
	SettlementID    *string               `json:"settlement_id,omitempty"`
	PaidAt          *time.Time            `json:"paid_at,omitempty"`
	CreatedAt       time.Time             `json:"created_at"`
	UpdatedAt       time.Time             `json:"updated_at"`
}

// LinkHealthRecord models link_health_records (§22.14).
type LinkHealthRecord struct {
	HealthID                      string                `json:"health_id"`
	WorkspaceID                   string                `json:"workspace_id"`
	AffiliateLinkID               string                `json:"affiliate_link_id"`
	HTTPStatus                    int32                 `json:"http_status"`
	ProductStatus                 string                `json:"product_status"`
	CommissionStatus              string                `json:"commission_status"`
	LinkStatus                    HealthStatus          `json:"link_status"`
	ExpiryDate                    *time.Time            `json:"expiry_date,omitempty"`
	SuggestedAction               string                `json:"suggested_action"`
	CheckedAt                     time.Time             `json:"checked_at"`
	AlertSent                     bool                  `json:"alert_sent"`
	EstimatedRevenueImpact        tenantdb.ExactDecimal `json:"estimated_revenue_impact"`
	SuggestedReplacementProductID *string               `json:"suggested_replacement_product_id,omitempty"`
	CreatedAt                     time.Time             `json:"created_at"`
}

// AffiliateStatement models affiliate_statements.
type AffiliateStatement struct {
	StatementID          string                `json:"statement_id"`
	WorkspaceID          string                `json:"workspace_id"`
	Platform             string                `json:"platform"`
	ExternalStatementRef string                `json:"external_statement_ref"`
	PeriodStart          string                `json:"period_start"`
	PeriodEnd            string                `json:"period_end"`
	TotalCommission      tenantdb.ExactDecimal `json:"total_commission"`
	Currency             string                `json:"currency"`
	ReconciliationState  string                `json:"reconciliation_state"`
	ItemCount            int32                 `json:"item_count"`
	ReconciledItemCount  int32                 `json:"reconciled_item_count"`
	ImportedAt           time.Time             `json:"imported_at"`
}

// AffiliateStatementItem models affiliate_statement_items.
type AffiliateStatementItem struct {
	ItemID              string                `json:"item_id"`
	StatementID         string                `json:"statement_id"`
	ExternalOrderID     string                `json:"external_order_id"`
	OrderAmount         tenantdb.ExactDecimal `json:"order_amount"`
	CommissionAmount    tenantdb.ExactDecimal `json:"commission_amount"`
	MatchedOrderID      *string               `json:"matched_order_id,omitempty"`
	MatchedCommissionID *string               `json:"matched_commission_id,omitempty"`
	Status              string                `json:"status"` // unreconciled, matched, conflict
	CreatedAt           time.Time             `json:"created_at"`
}

// LedgerPostingResult models financial ledger impact.
type LedgerPostingResult struct {
	PostingID       string                `json:"posting_id"`
	WorkspaceID     string                `json:"workspace_id"`
	EconomicRole    EconomicRole          `json:"economic_role"`
	PostingType     string                `json:"posting_type"` // creator_income vs seller_commission_expense
	Amount          tenantdb.ExactDecimal `json:"amount"`
	Currency        string                `json:"currency"`
	COGSDeducted    bool                  `json:"cogs_deducted"`
	NetProfitImpact tenantdb.ExactDecimal `json:"net_profit_impact"`
	PostedAt        time.Time             `json:"posted_at"`
}

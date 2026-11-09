package finance

import (
	"errors"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Canonical component identities per DB schema §26.10 & Financial computation contract.
const (
	ComponentRevenue     = "revenue"
	ComponentPlatformFee = "platform_fee"
	ComponentShipping    = "shipping"
	ComponentCOGS        = "cogs"
	ComponentAICredits   = "ai_credits"
	ComponentCommission  = "commission"
	ComponentAdsSpend    = "ads_spend"
	ComponentSeeding     = "seeding"
	ComponentRefund      = "refund"
	ComponentOther       = "other"
)

// Canonical source classes per PRD §15.1.
const (
	SourceClassOfficial     = "official"
	SourceClassImported     = "imported"
	SourceClassInferred     = "inferred"
	SourceClassEstimated    = "estimated"
	SourceClassUnreconciled = "unreconciled"
)

// Canonical confidence bands per DB schema §4.1.
const (
	ConfidenceHigh       = "high"
	ConfidenceMediumHigh = "medium_high"
	ConfidenceMedium     = "medium"
	ConfidenceLowMedium  = "low_medium"
	ConfidenceLow        = "low"
)

// Canonical reconciliation states per RULE-M19-007.
const (
	ReconciliationAwaitingEvidence            = "awaiting_evidence"
	ReconciliationImportedOnly                = "imported_only"
	ReconciliationInferredPendingConfirmation = "inferred_pending_confirmation"
	ReconciliationPartiallyReconciled         = "partially_reconciled"
	ReconciliationFullyReconciled             = "fully_reconciled"
	ReconciliationConflictDetected            = "conflict_detected"
	ReconciliationManuallyOverridden          = "manually_overridden"
)

// Settlement lifecycle states per DB schema §11.1.
const (
	SettlementStateImported         = "imported"
	SettlementStateNormalized       = "normalized"
	SettlementStateReadyForMatching = "ready_for_matching"
	SettlementStateArchived         = "archived"
)

// Cost states per DB schema §11.2.
const (
	CostStateRecorded        = "recorded"
	CostStatePendingEvidence = "pending_evidence"
	CostStateReconciled      = "reconciled"
	CostStateEstimated       = "estimated"
	CostStateSuperseded      = "superseded"
)

var (
	ErrMissingTenant             = errors.New("finance: workspace_id required in tenant context")
	ErrPostingNotFound           = errors.New("finance: financial posting not found")
	ErrDuplicatePosting          = errors.New("finance: duplicate financial posting for origin/component")
	ErrSettlementNotFound        = errors.New("finance: settlement not found")
	ErrDuplicateSettlement       = errors.New("finance: settlement already exists with external ID or fingerprint")
	ErrCostItemNotFound          = errors.New("finance: cost item not found")
	ErrInvalidAmount             = errors.New("finance: invalid decimal amount")
	ErrCurrencyMismatch          = errors.New("finance: currency mismatch in financial aggregation")
	ErrNegativeRate              = errors.New("finance: exchange rate must be strictly positive")
	ErrCapacityExceeded          = errors.New("finance: settlement line capacity exceeded for matched amount")
	ErrEvidenceNotFound          = errors.New("finance: evidence object not found")
	ErrEvidenceImmutable         = errors.New("finance: evidence content is immutable; cannot modify or delete")
	ErrProofBundleNotFound       = errors.New("finance: proof bundle not found")
	ErrRecordNotFound            = errors.New("finance: reconciliation record not found")
	ErrOrderNotFound             = errors.New("finance: order not found")
	ErrOrderCapacityExceeded     = errors.New("finance: order capacity exceeded for matched amount")
	ErrInvalidReportPeriod       = errors.New("finance: report period_end must be on or after period_start")
	ErrInvalidScopeType          = errors.New("finance: invalid or unsupported profit snapshot scope")
	ErrReportExportTierForbidden = errors.New("finance: BILLING_FORBIDDEN_002: report export not available on Free tier (0/month)")
	ErrReportExportQuotaExceeded = errors.New("finance: BILLING_LIMIT_003: monthly report export quota exceeded for Starter tier (5/month)")
)

// Verification status constants per DB Schema §3.
const (
	VerificationStatusPending  = "pending"
	VerificationStatusVerified = "verified"
	VerificationStatusReVerify = "re_verify"
	VerificationStatusFailed   = "failed"
)

// ObjectRef models a reference to related domain entity (§11.4).
type ObjectRef struct {
	Type string `json:"type"`
	ID   string `json:"id"`
}

// EvidenceObject represents an immutable proof artifact with SHA-512 content hash (§11.4 & RULE-M19-005).
type EvidenceObject struct {
	EvidenceID         string
	WorkspaceID        string
	EvidenceType       string // screenshot, api_response, receipt, report, platform_data
	SourceProvenance   string
	ContentHash        string // SHA-512 hex
	FileURL            string
	PayloadJSON        string
	CollectedAt        time.Time
	VerificationStatus string
	RelatedObjectRefs  []ObjectRef
	CreatedAt          time.Time
	DeletedAt          *time.Time
}

// ProofBundle represents an assembled claim with supporting evidence (§11.5 & RULE-M19-006).
type ProofBundle struct {
	ProofBundleID         string
	WorkspaceID           string
	ClaimScope            string
	ClaimSummary          string
	SupportingEvidenceIDs []string
	SourceClassContext    map[string]any
	Confidence            string
	CoverageSummary       string
	UnresolvedGaps        string
	CreatedAt             time.Time
	UpdatedAt             time.Time
	DeletedAt             *time.Time
}

// ReconciliationRecord represents a batch or scope reconciliation record (§19.9E).
type ReconciliationRecord struct {
	RecordID             string
	WorkspaceID          string
	ScopeType            string // order_batch, settlement_batch, affiliate_period, campaign
	ScopeDescription     string
	RelatedOrderIDs      []string
	RelatedSettlementIDs []string
	MatchedAmount        tenantdb.ExactDecimal
	DiscrepancyAmount    tenantdb.ExactDecimal
	DiscrepancyReason    string
	ReconciliationState  string
	Currency             string
	MismatchesJSON       string
	OverrideReason       string
	OverrideBy           string
	OverrideAt           *time.Time
	PeriodStart          string
	PeriodEnd            string
	CreatedAt            time.Time
	UpdatedAt            time.Time
}

// ReconciliationMatch represents a partial match allocation between a line and an order (§4).
type ReconciliationMatch struct {
	MatchID         string
	WorkspaceID     string
	RecordID        string
	SettlementID    string
	LineID          string
	OrderID         string
	AllocatedAmount tenantdb.ExactDecimal
	Currency        string
	CreatedAt       time.Time
}

// Order represents the order fields relevant for finance reconciliation (§10.3).
type Order struct {
	OrderID              string
	WorkspaceID          string
	LifecycleState       string
	Amount               tenantdb.ExactDecimal
	MatchedAmount        tenantdb.ExactDecimal
	Currency             string
	ReconciliationState  string
	COGSAmount           *tenantdb.ExactDecimal
	ZeroCOGSWithReason   bool
	COGSReason           string
	PlatformFeeAmount    tenantdb.ExactDecimal
	PaymentFeeAmount     tenantdb.ExactDecimal
	ShippingFeeAmount    tenantdb.ExactDecimal
	CommissionAmount     tenantdb.ExactDecimal
	ExchangeRateSnapshot ExchangeRateSnapshot
	OrderedAt            time.Time
	RecognizedAt         *time.Time
	SourceUpdatedAt      *time.Time
	SourcePlatform       string
	ProductID            string
	ProductIDs           []string
	CampaignID           string
	CampaignIDs          []string
	PostID               string
	PostIDs              []string
	ContentID            string
	ContentIDs           []string
}

// EffectiveTime returns the canonical recognition timestamp of the order (RecognizedAt if set, otherwise OrderedAt).
func (o Order) EffectiveTime() time.Time {
	if o.RecognizedAt != nil && !o.RecognizedAt.IsZero() {
		return o.RecognizedAt.UTC()
	}
	return o.OrderedAt.UTC()
}

// HasConfirmedZeroCOGS returns true when an order has an explicit zero COGS with a non-empty reason.
func (o Order) HasConfirmedZeroCOGS() bool {
	return o.ZeroCOGSWithReason && strings.TrimSpace(o.COGSReason) != ""
}

// MatchesProduct returns true if the order is associated with the given product ID.
func (o Order) MatchesProduct(productID string) bool {
	if productID == "" {
		return false
	}
	if o.ProductID == productID {
		return true
	}
	for _, pid := range o.ProductIDs {
		if pid == productID {
			return true
		}
	}
	return false
}

// MatchesCampaign returns true if the order is associated with the given campaign ID.
func (o Order) MatchesCampaign(campaignID string) bool {
	if campaignID == "" {
		return false
	}
	if o.CampaignID == campaignID {
		return true
	}
	for _, cid := range o.CampaignIDs {
		if cid == campaignID {
			return true
		}
	}
	return false
}

// MatchesContent returns true if the order is associated with the given content or post ID.
func (o Order) MatchesContent(contentID string) bool {
	if contentID == "" {
		return false
	}
	if o.ContentID == contentID || o.PostID == contentID {
		return true
	}
	for _, cid := range o.ContentIDs {
		if cid == contentID {
			return true
		}
	}
	for _, pid := range o.PostIDs {
		if pid == contentID {
			return true
		}
	}
	return false
}

// DataGapItem models a permission-filtered repair item in the repair queue (RULE-M19-001, M01).
type DataGapItem struct {
	GapID              string
	GapType            string // missing_cogs, unreconciled_settlement, missing_evidence, stale_connector
	Severity           string // critical, warning, info
	Title              string
	Description        string
	RelatedObjectType  string
	RelatedObjectID    string
	MonetaryAmount     tenantdb.ExactDecimal
	UnresolvedSince    time.Time
	RepairCTALabel     string
	RepairCTARoute     string
	RequiredPermission string
}

// Filter types
type ReconciliationFilter struct {
	ReconciliationState string
	PeriodStart         string
	PeriodEnd           string
}

type EvidenceFilter struct {
	EvidenceType       string
	VerificationStatus string
}

type ProofBundleFilter struct {
	ClaimScope string
}

type DataGapFilter struct {
	Severity    string
	GapType     string
	PeriodStart string
	PeriodEnd   string
	ProductID   string
}

// ExchangeRateSnapshot captures immutable currency conversion snapshot at transaction time (§25.1).
type ExchangeRateSnapshot struct {
	BaseCurrency  string    `json:"base_currency"`  // Workspace base currency (e.g. "VND")
	QuoteCurrency string    `json:"quote_currency"` // Transaction currency (e.g. "USD")
	RateToBase    string    `json:"rate_to_base"`   // Base units per 1 quote unit (e.g. "25000.000000")
	Provider      string    `json:"provider"`       // sbv, ecb, manual, platform
	CapturedAt    time.Time `json:"captured_at"`
	EffectiveAt   time.Time `json:"effective_at"`
	SourceClass   string    `json:"source_class"` // official, imported, estimated
}

// IsEmpty returns true when no fields of the ExchangeRateSnapshot have been populated.
func (fx ExchangeRateSnapshot) IsEmpty() bool {
	return strings.TrimSpace(fx.BaseCurrency) == "" &&
		strings.TrimSpace(fx.QuoteCurrency) == "" &&
		strings.TrimSpace(fx.RateToBase) == "" &&
		strings.TrimSpace(fx.Provider) == "" &&
		strings.TrimSpace(fx.SourceClass) == "" &&
		fx.CapturedAt.IsZero() &&
		fx.EffectiveAt.IsZero()
}

// FinancialPosting represents an immutable, append-only posting in the operating ledger (§26.10).
type FinancialPosting struct {
	PostingID            string
	WorkspaceID          string
	OriginType           string // order, settlement, cost_item, refund
	OriginID             string
	OriginVersion        string
	Component            string                // ComponentRevenue, ComponentPlatformFee, etc.
	Amount               tenantdb.ExactDecimal // Signed base-currency amount: revenue positive, costs/refunds negative
	Currency             string
	SourceClass          string
	Confidence           string
	ExchangeRateSnapshot ExchangeRateSnapshot
	RelatedOrderID       string
	ReversalOf           *string
	EffectiveAt          time.Time
	CreatedAt            time.Time
}

// CostItem represents a tracked cost line item (§11.2).
type CostItem struct {
	CostItemID           string
	WorkspaceID          string
	CostType             string // platform_fee, shipping, ads_spend, ai_credits, commission, service_tool, cogs, seeding, other
	Amount               tenantdb.ExactDecimal
	Currency             string
	ExchangeRateSnapshot ExchangeRateSnapshot
	Description          string
	RelatedScopeType     string
	RelatedScopeID       string
	SourceClass          string
	EvidenceID           string
	ConfidenceReason     string
	CostState            string
	EffectiveDate        string // YYYY-MM-DD
	CreatedAt            time.Time
	UpdatedAt            time.Time
}

// Settlement represents an ingested payout batch from a platform (§11.1).
type Settlement struct {
	SettlementID         string
	WorkspaceID          string
	SourceClass          string
	SourcePlatform       string
	ExternalSettlementID string
	ConnectedAccountID   string
	ExchangeRateSnapshot ExchangeRateSnapshot
	ImportFingerprint    string
	GrossAmount          tenantdb.ExactDecimal
	NetAmount            tenantdb.ExactDecimal
	Fees                 map[string]any
	Deductions           map[string]any
	Currency             string
	SettlementState      string
	ReconciliationState  string
	RelatedOrderIDs      []string
	EffectiveDate        string
	CreatedAt            time.Time
	UpdatedAt            time.Time
	Lines                []SettlementLine
}

// SettlementLine represents an individual line in a platform settlement (§26.9).
type SettlementLine struct {
	LineID              string
	WorkspaceID         string
	SettlementID        string
	ExternalLineID      string
	ExternalOrderID     string
	OrderID             string
	GrossAmount         tenantdb.ExactDecimal
	FeeAmount           tenantdb.ExactDecimal
	RefundAmount        tenantdb.ExactDecimal
	NetAmount           tenantdb.ExactDecimal
	MatchedAmount       tenantdb.ExactDecimal
	Currency            string
	ReconciliationState string
	CreatedAt           time.Time
}

// ProfitSnapshot represents a materialized multi-scope profit calculation view (§11.3).
type ProfitSnapshot struct {
	SnapshotID                     string
	WorkspaceID                    string
	ScopeType                      string // workspace, product, platform, campaign, content, period
	ScopeID                        string
	PeriodStart                    string
	PeriodEnd                      string
	GrossRevenue                   tenantdb.ExactDecimal
	PlatformFees                   tenantdb.ExactDecimal
	ShippingCosts                  tenantdb.ExactDecimal
	AffiliateCommissions           tenantdb.ExactDecimal
	RefundDeductions               tenantdb.ExactDecimal
	COGS                           tenantdb.ExactDecimal
	AdsSpend                       tenantdb.ExactDecimal
	AICreditCosts                  tenantdb.ExactDecimal
	SeedingCosts                   tenantdb.ExactDecimal
	OtherCosts                     tenantdb.ExactDecimal
	NetProfit                      tenantdb.ExactDecimal
	MarginPct                      *tenantdb.ExactDecimal
	SourceClassMix                 map[string]tenantdb.ExactDecimal
	Confidence                     string
	FreshnessAt                    time.Time
	Currency                       string
	CreatedAt                      time.Time
	IsIncomplete                   bool
	UnknownRequiredComponentsCount int
	PendingRevenue                 tenantdb.ExactDecimal
	UnreconciledAmount             tenantdb.ExactDecimal
	UnreconciledCount              int
}

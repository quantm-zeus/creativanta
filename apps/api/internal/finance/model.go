package finance

import (
	"errors"
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
	CostStateSuperseded       = "superseded"
)

var (
	ErrMissingTenant       = errors.New("finance: workspace_id required in tenant context")
	ErrPostingNotFound     = errors.New("finance: financial posting not found")
	ErrDuplicatePosting    = errors.New("finance: duplicate financial posting for origin/component")
	ErrSettlementNotFound  = errors.New("finance: settlement not found")
	ErrDuplicateSettlement = errors.New("finance: settlement already exists with external ID or fingerprint")
	ErrCostItemNotFound    = errors.New("finance: cost item not found")
	ErrInvalidAmount       = errors.New("finance: invalid decimal amount")
	ErrCurrencyMismatch    = errors.New("finance: currency mismatch in financial aggregation")
	ErrNegativeRate        = errors.New("finance: exchange rate must be strictly positive")
	ErrCapacityExceeded    = errors.New("finance: settlement line capacity exceeded for matched amount")
)

// ExchangeRateSnapshot captures immutable currency conversion snapshot at transaction time (§25.1).
type ExchangeRateSnapshot struct {
	BaseCurrency  string    `json:"base_currency"`  // Workspace base currency (e.g. "VND")
	QuoteCurrency string    `json:"quote_currency"` // Transaction currency (e.g. "USD")
	RateToBase    string    `json:"rate_to_base"`   // Base units per 1 quote unit (e.g. "25000.000000")
	Provider      string    `json:"provider"`       // sbv, ecb, manual, platform
	CapturedAt    time.Time `json:"captured_at"`
	EffectiveAt   time.Time `json:"effective_at"`
	SourceClass   string    `json:"source_class"`   // official, imported, estimated
}

// FinancialPosting represents an immutable, append-only posting in the operating ledger (§26.10).
type FinancialPosting struct {
	PostingID            string
	WorkspaceID          string
	OriginType           string // order, settlement, cost_item, refund
	OriginID             string
	OriginVersion        string
	Component            string // ComponentRevenue, ComponentPlatformFee, etc.
	Amount               tenantdb.ExactDecimal // Signed base-currency amount: revenue positive, costs/refunds negative
	Currency             string
	SourceClass          string
	Confidence           string
	ExchangeRateSnapshot ExchangeRateSnapshot
	ReversalOf           *string
	EffectiveAt          time.Time
	CreatedAt            time.Time
}

// CostItem represents a tracked cost line item (§11.2).
type CostItem struct {
	CostItemID       string
	WorkspaceID      string
	CostType         string // platform_fee, shipping, ads_spend, ai_credits, commission, service_tool, cogs, seeding, other
	Amount           tenantdb.ExactDecimal
	Currency         string
	Description      string
	RelatedScopeType string
	RelatedScopeID   string
	SourceClass      string
	EvidenceID       string
	ConfidenceReason string
	CostState        string
	EffectiveDate    string // YYYY-MM-DD
	CreatedAt        time.Time
	UpdatedAt        time.Time
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

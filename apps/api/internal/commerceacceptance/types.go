package commerceacceptance

import (
	"errors"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

var (
	ErrUnauthenticated          = errors.New("commerceacceptance: unauthenticated caller")
	ErrCrossTenantDenied        = errors.New("commerceacceptance: cross-tenant access denied")
	ErrPermissionDenied         = errors.New("commerceacceptance: caller lacks required permission")
	ErrUnreconciledItemNotFound = errors.New("commerceacceptance: unreconciled outcome item not found")
	ErrAuditReasonRequired      = errors.New("commerceacceptance: audit reason is mandatory for operational repairs")
	ErrInvalidRepairType        = errors.New("commerceacceptance: unsupported operational repair type")
	ErrRepairAlreadyApplied     = errors.New("commerceacceptance: operational repair has already been resolved")
	ErrInvalidTrackingState     = errors.New("commerceacceptance: invalid carrier tracking state transition")
	ErrInvalidCarrierSignature  = errors.New("commerceacceptance: invalid shipping carrier webhook signature")
)

// AcceptanceTarget identifiers.
type AcceptanceTarget string

const (
	TargetNoFunctionLost          AcceptanceTarget = "TARGET_1_NO_FUNCTION_LOST"
	TargetPartialUnreconciledSeen AcceptanceTarget = "TARGET_2_PARTIAL_UNRECONCILED_VISIBLE"
	TargetProviderGateEvidence    AcceptanceTarget = "TARGET_3_PROVIDER_GATE_EVIDENCE"
)

// SourceClass follows PRD §15.1 and RULE-M13-002, RULE-M16-001.
type SourceClass string

const (
	SourceClassOfficial     SourceClass = "official"
	SourceClassImported     SourceClass = "imported"
	SourceClassInferred     SourceClass = "inferred"
	SourceClassEstimated    SourceClass = "estimated"
	SourceClassUnreconciled SourceClass = "unreconciled"
)

// ModuleID identifies P6 modules.
type ModuleID string

const (
	ModuleM04 ModuleID = "M04_OPPORTUNITY_BOARD"
	ModuleM05 ModuleID = "M05_IDEA_ENGINE"
	ModuleM09 ModuleID = "M09_ASSET_DERIVATIVES"
	ModuleM12 ModuleID = "M12_UNIFIED_INBOX"
	ModuleM13 ModuleID = "M13_PRODUCT_HUB"
	ModuleM14 ModuleID = "M14_MONETIZATION_OS"
	ModuleM15 ModuleID = "M15_CREATOR_STORE"
	ModuleM16 ModuleID = "M16_AFFILIATE_NETWORK"
	ModuleM17 ModuleID = "M17_LIVE_WAR_ROOM"
	ModuleM18 ModuleID = "M18_SEEDING_CRM"
	ModuleS16 ModuleID = "S16_CREATOR_PRO_TOOLS"
	ModuleM19 ModuleID = "M19_OPERATING_LEDGER"
)

// CrossModuleLink represents a verified connection between two modules.
type CrossModuleLink struct {
	FromModule  ModuleID `json:"from_module"`
	ToModule    ModuleID `json:"to_module"`
	LinkType    string   `json:"link_type"`
	SourceID    string   `json:"source_id"`
	TargetID    string   `json:"target_id"`
	Verified    bool     `json:"verified"`
	Description string   `json:"description"`
}

// ModuleIntegritySummary reports health of each P6 module.
type ModuleIntegritySummary struct {
	ModuleID        ModuleID `json:"module_id"`
	Name            string   `json:"name"`
	ConnectedLinks  int      `json:"connected_links"`
	ActiveEntities  int      `json:"active_entities"`
	PendingOutcomes int      `json:"pending_outcomes"`
	Status          string   `json:"status"` // "HEALTHY", "DEGRADED", "UNCONFIGURED"
}

// CrossModuleVerificationResult aggregates integrity checks across the full loop.
type CrossModuleVerificationResult struct {
	WorkspaceID          string                   `json:"workspace_id"`
	VerifiedAt           time.Time                `json:"verified_at"`
	AllModulesConnected  bool                     `json:"all_modules_connected"`
	ZeroFunctionLost     bool                     `json:"zero_function_lost"`
	ModuleSummaries      []ModuleIntegritySummary `json:"module_summaries"`
	VerifiedLinks        []CrossModuleLink        `json:"verified_links"`
	BrokenLinks          []CrossModuleLink        `json:"broken_links"`
	LineageIntegrityPass bool                     `json:"lineage_integrity_pass"`
}

// UnreconciledOutcome models a transaction or outcome that is partial, ambiguous, or unproven.
type UnreconciledOutcome struct {
	ID                    string                `json:"id"`
	WorkspaceID           string                `json:"workspace_id"`
	Domain                string                `json:"domain"` // "order_refund", "stock_movement", "affiliate_attribution", "affiliate_statement", "seeding_crm", "creator_pro_deal"
	EntityID              string                `json:"entity_id"`
	Title                 string                `json:"title"`
	SourceClass           SourceClass           `json:"source_class"`
	ConfidenceScore       float64               `json:"confidence_score"` // 0.00 to 1.00
	Status                string                `json:"status"`           // "partially_refunded", "stock_discrepancy", "pending_outcome", "unmatched_statement_item", "disputed_deliverable"
	Detail                string                `json:"detail"`
	FinancialImpactExact  tenantdb.ExactDecimal `json:"financial_impact_exact"`
	OriginalCapturedExact tenantdb.ExactDecimal `json:"original_captured_exact,omitempty"`
	RefundedAmountExact   tenantdb.ExactDecimal `json:"refunded_amount_exact,omitempty"`
	PhysicalReturnState   string                `json:"physical_return_state,omitempty"`
	RequiresAuditReason   bool                  `json:"requires_audit_reason"`
	RepairActionSuggested string                `json:"repair_action_suggested"`
	Resolved              bool                  `json:"resolved"`
	ResolvedAt            *time.Time            `json:"resolved_at,omitempty"`
	AuditReason           string                `json:"audit_reason,omitempty"`
	CreatedAt             time.Time             `json:"created_at"`
}

// OperationalRepairRequest represents a manual or audited correction for an unreconciled outcome.
type OperationalRepairRequest struct {
	WorkspaceID      string                `json:"workspace_id"`
	UnreconciledID   string                `json:"unreconciled_id"`
	RepairType       string                `json:"repair_type"` // "reconcile_stock_adjustment", "resolve_affiliate_statement", "qualify_seeding_outcome", "settle_partial_refund", "resolve_deal_dispute"
	AuditReason      string                `json:"audit_reason"`
	AdjustmentAmount tenantdb.ExactDecimal `json:"adjustment_amount,omitempty"`
	ActorID          string                `json:"actor_id"`
	ActorRole        string                `json:"actor_role"`
}

// OperationalRepairResult describes the outcome of an applied repair.
type OperationalRepairResult struct {
	Success         bool      `json:"success"`
	UnreconciledID  string    `json:"unreconciled_id"`
	ActionTaken     string    `json:"action_taken"`
	RepairedAt      time.Time `json:"repaired_at"`
	LedgerPostingID string    `json:"ledger_posting_id,omitempty"`
	AuditLogEntryID string    `json:"audit_log_entry_id"`
}

// ShippingCarrier identifies supported SEA carriers.
type ShippingCarrier string

const (
	CarrierGHN               ShippingCarrier = "ghn"                // Giao Hàng Nhanh
	CarrierGHTK              ShippingCarrier = "ghtk"               // Giao Hàng Tiết Kiệm
	CarrierViettelPost       ShippingCarrier = "viettel_post"       // Viettel Post
	CarrierPlatformLogistics ShippingCarrier = "platform_logistics" // TikTok/Shopee native 3PL
)

// ShippingTrackingState represents carrier logistics progress.
type ShippingTrackingState string

const (
	TrackingCreated        ShippingTrackingState = "created"
	TrackingInTransit      ShippingTrackingState = "in_transit"
	TrackingOutForDelivery ShippingTrackingState = "out_for_delivery"
	TrackingDelivered      ShippingTrackingState = "delivered"
	TrackingException      ShippingTrackingState = "exception"
	TrackingReturned       ShippingTrackingState = "returned"
)

// ShippingParcel represents a tracked logistics parcel.
type ShippingParcel struct {
	TrackingNumber      string                `json:"tracking_number"`
	Carrier             ShippingCarrier       `json:"carrier"`
	OrderID             string                `json:"order_id"`
	SampleRequestID     string                `json:"sample_request_id,omitempty"`
	State               ShippingTrackingState `json:"state"`
	ShippingCostExact   tenantdb.ExactDecimal `json:"shipping_cost_exact"`
	WeightGrams         int                   `json:"weight_grams"`
	DestinationProvince string                `json:"destination_province"`
	LastStatusUpdate    time.Time             `json:"last_status_update"`
	SignatureVerified   bool                  `json:"signature_verified"`
	ExternalGateID      string                `json:"external_gate_id"`
	GateStatus          string                `json:"gate_status"`
}

// PaymentGateHealth reports payment provider status.
type PaymentGateHealth struct {
	Provider             string    `json:"provider"`
	Configured           bool      `json:"configured"`
	WebhookHMACVerified  bool      `json:"webhook_hmac_verified"`
	ReplayDeduplicated   bool      `json:"replay_deduplicated"`
	LatePaymentRecovery  bool      `json:"late_payment_recovery"`
	LiveEntitlementReady bool      `json:"live_entitlement_ready"`
	ExternalGateID       string    `json:"external_gate_id"`
	GateStatus           string    `json:"gate_status"` // "LOCAL_ADAPTER_ONLY", "PENDING_PRODUCTION_KEY"
	LastCheckedAt        time.Time `json:"last_checked_at"`
}

// ProviderAndShippingGateSummary reports actual provider/shipping status.
type ProviderAndShippingGateSummary struct {
	WorkspaceID                 string              `json:"workspace_id"`
	CheckedAt                   time.Time           `json:"checked_at"`
	ProductionEntitlementsReady bool                `json:"production_entitlements_ready"`
	LiveProviderStatus          string              `json:"live_provider_status"`
	PaymentGates                []PaymentGateHealth `json:"payment_gates"`
	ShippingGates               []ShippingParcel    `json:"shipping_gates"`
	ExternalGates               []ExternalGateInfo  `json:"external_gates"`
}

// ExternalGateInfo accurately records external dependency state.
type ExternalGateInfo struct {
	GateID      string `json:"gate_id"`
	Status      string `json:"status"`
	Description string `json:"description"`
}

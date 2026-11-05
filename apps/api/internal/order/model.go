package order

import (
	"errors"
	"fmt"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Domain Errors
var (
	ErrOrderNotFound              = errors.New("order not found")
	ErrRefundNotFound             = errors.New("refund not found")
	ErrReturnNotFound             = errors.New("return not found")
	ErrInvalidOrderTransition     = errors.New("invalid order lifecycle transition")
	ErrInvalidRefundTransition    = errors.New("invalid refund lifecycle transition")
	ErrInvalidReturnTransition    = errors.New("invalid return lifecycle transition")
	ErrRefundExceedsOrderTotal    = errors.New("refund amount exceeds refundable order balance")
	ErrReturnExceedsOrderQuantity = errors.New("return item quantity exceeds ordered quantity")
	ErrReturnAlreadyProcessed     = errors.New("return already closed or rejected")
	ErrInvalidAmount              = errors.New("amount must be strictly positive")
	ErrOrderAlreadyExists         = errors.New("order already exists")
	ErrInvalidInput               = errors.New("invalid input data")
	ErrMissingTenant              = errors.New("missing tenant workspace context")
	ErrCurrencyMismatch           = errors.New("currency mismatch")
)

type SourceClass string

const (
	SourceClassOfficial     SourceClass = "official"
	SourceClassImported     SourceClass = "imported"
	SourceClassInferred     SourceClass = "inferred"
	SourceClassEstimated    SourceClass = "estimated"
	SourceClassUnreconciled SourceClass = "unreconciled"
)

type LifecycleState string

const (
	StateCreated           LifecycleState = "created"
	StateConfirmed         LifecycleState = "confirmed"
	StateFulfilled         LifecycleState = "fulfilled"
	StateCompleted         LifecycleState = "completed"
	StatePartiallyRefunded LifecycleState = "partially_refunded"
	StateRefunded          LifecycleState = "refunded"
	StateReturned          LifecycleState = "returned"
	StateCancelled         LifecycleState = "cancelled"
)

type RefundState string

const (
	RefundRequested  RefundState = "requested"
	RefundApproved   RefundState = "approved"
	RefundRejected   RefundState = "rejected"
	RefundProcessing RefundState = "processing"
	RefundCompleted  RefundState = "completed"
	RefundFailed     RefundState = "failed"
	RefundCancelled  RefundState = "cancelled"
)

type ReturnState string

const (
	ReturnInitiated   ReturnState = "initiated"
	ReturnApproved    ReturnState = "approved"
	ReturnShippedBack ReturnState = "shipped_back"
	ReturnReceived    ReturnState = "received"
	ReturnInspected   ReturnState = "inspected"
	ReturnClosed      ReturnState = "closed"
	ReturnRejected    ReturnState = "rejected"
)

// Valid order lifecycle state transitions per RULE-M13-003.
var validOrderTransitions = map[LifecycleState]map[LifecycleState]bool{
	StateCreated: {
		StateConfirmed: true,
		StateCancelled: true,
	},
	StateConfirmed: {
		StateFulfilled: true,
		StateCancelled: true,
	},
	StateFulfilled: {
		StateCompleted:         true,
		StateReturned:          true,
		StatePartiallyRefunded: true,
		StateRefunded:          true,
	},
	StateCompleted: {
		StatePartiallyRefunded: true,
		StateRefunded:          true,
		StateReturned:          true,
	},
	StatePartiallyRefunded: {
		StatePartiallyRefunded: true, // Subsequent partial refund
		StateRefunded:          true, // Full refund reached
		StateReturned:          true,
	},
	StateReturned: {
		StatePartiallyRefunded: true,
		StateRefunded:          true,
	},
	StateRefunded:  {}, // Terminal state
	StateCancelled: {}, // Terminal state
}

func CanTransitionOrder(from, to LifecycleState) bool {
	if from == to {
		return true // Idempotent same-state
	}
	allowed, ok := validOrderTransitions[from]
	if !ok {
		return false
	}
	return allowed[to]
}

// Valid return lifecycle state transitions per DB Schema §19.6.
var validReturnTransitions = map[ReturnState]map[ReturnState]bool{
	ReturnInitiated: {
		ReturnApproved: true,
		ReturnRejected: true,
	},
	ReturnApproved: {
		ReturnShippedBack: true,
		ReturnReceived:    true,
		ReturnRejected:    true,
	},
	ReturnShippedBack: {
		ReturnReceived: true,
		ReturnRejected: true,
	},
	ReturnReceived: {
		ReturnInspected: true,
		ReturnClosed:    true,
	},
	ReturnInspected: {
		ReturnClosed:   true,
		ReturnRejected: true,
	},
	ReturnClosed:   {}, // Terminal state
	ReturnRejected: {}, // Terminal state
}

func CanTransitionReturn(from, to ReturnState) bool {
	if from == to {
		return true // Idempotent same-state
	}
	allowed, ok := validReturnTransitions[from]
	if !ok {
		return false
	}
	return allowed[to]
}

// OrderItem represents a line item in an order.
type OrderItem struct {
	Sku             string                `json:"sku"`
	ProductID       string                `json:"product_id,omitempty"`
	Name            string                `json:"name"`
	Quantity        int32                 `json:"quantity"`
	UnitPrice       tenantdb.ExactDecimal `json:"unit_price"`
	Discount        tenantdb.ExactDecimal `json:"discount"`
	Total           tenantdb.ExactDecimal `json:"total"`
	UnitCogs        tenantdb.ExactDecimal `json:"unit_cogs"`
	CogsSourceClass SourceClass           `json:"cogs_source_class,omitempty"`
	Variation       string                `json:"variation,omitempty"`
	PlatformItemID  string                `json:"platform_item_id,omitempty"`
}

// OtherFee represents a secondary fee line.
type OtherFee struct {
	Name   string                `json:"name"`
	Amount tenantdb.ExactDecimal `json:"amount"`
}

// FeeBreakdown contains the itemized fees for an order.
type FeeBreakdown struct {
	PlatformFee         tenantdb.ExactDecimal `json:"platform_fee"`
	PaymentFee          tenantdb.ExactDecimal `json:"payment_fee"`
	AffiliateCommission tenantdb.ExactDecimal `json:"affiliate_commission"`
	ShippingCost        tenantdb.ExactDecimal `json:"shipping_cost"`
	VatAmount           tenantdb.ExactDecimal `json:"vat_amount"`
	OtherFees           []OtherFee            `json:"other_fees,omitempty"`
}

// Order represents an order record per DB Schema §10.3 and PRD §15.
type Order struct {
	OrderID              string                `json:"order_id"`
	WorkspaceID          string                `json:"workspace_id"`
	SourceClass          SourceClass           `json:"source_class"`
	SourcePlatform       string                `json:"source_platform,omitempty"`
	ExternalOrderID      string                `json:"external_order_id,omitempty"`
	ConnectedAccountID   string                `json:"connected_account_id,omitempty"`
	TaxAmount            tenantdb.ExactDecimal `json:"tax_amount"`
	TaxJurisdiction      string                `json:"tax_jurisdiction,omitempty"`
	TaxNote              string                `json:"tax_note,omitempty"`
	ExchangeRateSnapshot map[string]any        `json:"exchange_rate_snapshot,omitempty"`
	RecognizedAt         *time.Time            `json:"recognized_at,omitempty"`
	SourceUpdatedAt      *time.Time            `json:"source_updated_at,omitempty"`
	ImportFingerprint    string                `json:"import_fingerprint,omitempty"`
	LifecycleState       LifecycleState        `json:"lifecycle_state"`
	Amount               tenantdb.ExactDecimal `json:"amount"`
	RefundedAmount       tenantdb.ExactDecimal `json:"refunded_amount"`
	Currency             string                `json:"currency"`
	ProductID            string                `json:"product_id,omitempty"`
	OfferID              string                `json:"offer_id,omitempty"`
	CampaignID           string                `json:"campaign_id,omitempty"`
	PostID               string                `json:"post_id,omitempty"`
	LiveSessionID        string                `json:"live_session_id,omitempty"`
	CustomerEntityID     string                `json:"customer_entity_id,omitempty"`
	Items                []OrderItem           `json:"items"`
	FeeBreakdown         FeeBreakdown          `json:"fee_breakdown"`
	ShippingAddress      map[string]any        `json:"shipping_address,omitempty"`
	ReconciliationState  string                `json:"reconciliation_state,omitempty"`
	EvidenceRefs         []string              `json:"evidence_refs,omitempty"`
	Metadata             map[string]any        `json:"metadata,omitempty"`
	OrderedAt            time.Time             `json:"ordered_at"`
	CreatedAt            time.Time             `json:"created_at"`
	UpdatedAt            time.Time             `json:"updated_at"`
	DeletedAt            *time.Time            `json:"deleted_at,omitempty"`
}

// RefundableRemaining calculates how much money can still be refunded.
func (o *Order) RefundableRemaining() (tenantdb.ExactDecimal, error) {
	rem, err := o.Amount.Sub(o.RefundedAmount)
	if err != nil {
		return tenantdb.ZeroDecimal(), err
	}
	if rem.IsNegative() {
		return tenantdb.ZeroDecimal(), fmt.Errorf("inconsistent refund state: refunded exceeds total")
	}
	return rem, nil
}

// Refund represents a financial reversal per DB Schema §19.5.
type Refund struct {
	RefundID         string                `json:"refund_id"`
	WorkspaceID      string                `json:"workspace_id"`
	OrderID          string                `json:"order_id"`
	RefundType       string                `json:"refund_type"` // full, partial, credit
	Amount           tenantdb.ExactDecimal `json:"amount"`
	Currency         string                `json:"currency"`
	Reason           string                `json:"reason"`
	LifecycleState   RefundState           `json:"lifecycle_state"`
	SourceClass      SourceClass           `json:"source_class"`
	SourcePlatform   string                `json:"source_platform,omitempty"`
	ExternalRefundID string                `json:"external_refund_id,omitempty"`
	SettlementID     string                `json:"settlement_id,omitempty"`
	EvidenceRefs     []string              `json:"evidence_refs,omitempty"`
	CreatedAt        time.Time             `json:"created_at"`
	UpdatedAt        time.Time             `json:"updated_at"`
	DeletedAt        *time.Time            `json:"deleted_at,omitempty"`
}

// ReturnItem represents an item line being physically returned.
type ReturnItem struct {
	Sku      string `json:"sku"`
	Quantity int32  `json:"quantity"`
	Reason   string `json:"reason,omitempty"`
}

// Return represents a logistics return record per DB Schema §19.6.
type Return struct {
	ReturnID         string       `json:"return_id"`
	WorkspaceID      string       `json:"workspace_id"`
	OrderID          string       `json:"order_id"`
	RefundID         string       `json:"refund_id,omitempty"`
	ReturnType       string       `json:"return_type"` // full, partial
	Items            []ReturnItem `json:"items"`
	LifecycleState   ReturnState  `json:"lifecycle_state"`
	TrackingNumber   string       `json:"tracking_number,omitempty"`
	EvidencePhotoURL string       `json:"evidence_photo_url,omitempty"`
	CreatedAt        time.Time    `json:"created_at"`
	UpdatedAt        time.Time    `json:"updated_at"`
	DeletedAt        *time.Time   `json:"deleted_at,omitempty"`
}

package commerceadapter

import (
	"errors"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Supported commerce platforms per docs/04_contracts/connector_specs.md.
const (
	PlatformTikTok = "tiktok"
	PlatformShopee = "shopee"
	PlatformLazada = "lazada"
	PlatformStripe = "stripe"
)

// Adapter Errors
var (
	ErrInvalidSignature        = errors.New("invalid webhook signature")
	ErrUnsupportedPlatform     = errors.New("unsupported commerce platform")
	ErrInvalidPayload          = errors.New("invalid webhook payload")
	ErrMissingCredentials      = errors.New("missing platform connector credentials")
	ErrDegradedPlatform        = errors.New("platform connector is in degraded state; falling back to manual import")
	ErrStockExhaustedOnLatePay = errors.New("stock exhausted during late payment recovery")
)

// IngestedOrder represents an order parsed and normalized from a platform webhook.
type IngestedOrder struct {
	ExternalOrderID    string
	Platform           string
	ConnectedAccountID string
	LifecycleState     order.LifecycleState
	Amount             tenantdb.ExactDecimal
	Currency           string
	TaxAmount          tenantdb.ExactDecimal
	Items              []order.OrderItem
	FeeBreakdown       order.FeeBreakdown
	OrderedAt          time.Time
	RawPayload         []byte
}

// IngestedReturn represents a physical return event parsed from a platform webhook.
type IngestedReturn struct {
	ExternalReturnID string
	ExternalOrderID  string
	Platform         string
	Items            []order.ReturnItem
	TrackingNumber   string
	Reason           string
	LifecycleState   order.ReturnState
	RawPayload       []byte
}

// IngestedRefund represents a financial refund event parsed from a platform webhook.
type IngestedRefund struct {
	ExternalRefundID string
	ExternalOrderID  string
	Platform         string
	Amount           tenantdb.ExactDecimal
	Currency         string
	Reason           string
	RawPayload       []byte
}

// IngestedSettlementLine represents a line item in a platform payout report.
type IngestedSettlementLine struct {
	ExternalLineID  string
	ExternalOrderID string
	Platform        string
	GrossAmount     tenantdb.ExactDecimal
	FeeAmount       tenantdb.ExactDecimal
	ShippingAmount  tenantdb.ExactDecimal
	NetAmount       tenantdb.ExactDecimal
	Currency        string
}

// StockSyncResult captures the outcome of polling platform stock and computing delta.
type StockSyncResult struct {
	Platform       string
	WorkspaceID    string
	LocationID     string
	SkuID          string
	PreviousOnHand int32
	ReportedStock  int32
	DeltaQuantity  int32
	MovementID     string
	IsNoOp         bool
}

// PlatformCapabilityStatus reflects verified vs degraded connector capability.
type PlatformCapabilityStatus struct {
	Platform string
	IsNative bool
	Status   string // "verified", "degraded", "manual"
	Reason   string
}

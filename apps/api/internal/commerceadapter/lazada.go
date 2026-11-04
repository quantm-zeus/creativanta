package commerceadapter

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// LazadaAdapter implements commerce integration for Lazada Open Platform.
type LazadaAdapter struct{}

func NewLazadaAdapter() *LazadaAdapter {
	return &LazadaAdapter{}
}

func (a *LazadaAdapter) Platform() string {
	return PlatformLazada
}

// VerifySignature validates Lazada's HMAC-SHA256 signature calculated from raw body.
func (a *LazadaAdapter) VerifySignature(body []byte, signature, appSecret string) bool {
	if appSecret == "" || signature == "" {
		return false
	}
	mac := hmac.New(sha256.New, []byte(appSecret))
	mac.Write(body)
	expected := hex.EncodeToString(mac.Sum(nil))
	return hmac.Equal([]byte(signature), []byte(expected))
}

type lazadaWebhookEnvelope struct {
	SellerID    string          `json:"seller_id"`
	MessageType string          `json:"message_type"`
	Timestamp   int64           `json:"timestamp"`
	Data        json.RawMessage `json:"data"`
}

type lazadaOrderData struct {
	OrderID     string `json:"order_id"`
	OrderStatus string `json:"order_status"` // pending, ready_to_ship, shipped, delivered, canceled
	Price       string `json:"price"`
	Currency    string `json:"currency"`
	CreatedAt   string `json:"created_at"`
	OrderItems  []struct {
		SKU       string `json:"sku"`
		Name      string `json:"name"`
		Quantity  int32  `json:"quantity"`
		PaidPrice string `json:"paid_price"`
		UnitCogs  string `json:"unit_cogs"`
	} `json:"order_items"`
	Fees struct {
		Commission  string `json:"commission"`
		PaymentFee  string `json:"payment_fee"`
		ShippingFee string `json:"shipping_fee"`
		Vat         string `json:"vat"`
	} `json:"fees"`
}

type lazadaReturnData struct {
	ReturnID       string `json:"return_id"`
	OrderID        string `json:"order_id"`
	Status         string `json:"status"` // initiated, approved, received, completed, rejected
	TrackingNumber string `json:"tracking_number"`
	Items          []struct {
		SKU      string `json:"sku"`
		Quantity int32  `json:"quantity"`
		Reason   string `json:"reason"`
	} `json:"items"`
}

type lazadaRefundData struct {
	RefundID string `json:"refund_id"`
	OrderID  string `json:"order_id"`
	Amount   string `json:"amount"`
	Currency string `json:"currency"`
	Reason   string `json:"reason"`
}

type lazadaSettlementData struct {
	StatementID string `json:"statement_id"`
	Lines       []struct {
		LineID      string `json:"line_id"`
		OrderID     string `json:"order_id"`
		GrossAmount string `json:"gross_amount"`
		FeeAmount   string `json:"fee_amount"`
		ShippingFee string `json:"shipping_fee"`
		NetAmount   string `json:"net_amount"`
		Currency    string `json:"currency"`
	} `json:"lines"`
}

func mapLazadaOrderStatus(status string) order.LifecycleState {
	switch status {
	case "pending":
		return order.StateCreated
	case "ready_to_ship":
		return order.StateConfirmed
	case "shipped":
		return order.StateFulfilled
	case "delivered":
		return order.StateCompleted
	case "canceled":
		return order.StateCancelled
	default:
		return order.StateCreated
	}
}

func mapLazadaReturnStatus(status string) order.ReturnState {
	switch status {
	case "initiated":
		return order.ReturnInitiated
	case "approved":
		return order.ReturnApproved
	case "shipped":
		return order.ReturnShippedBack
	case "received":
		return order.ReturnReceived
	case "completed":
		return order.ReturnClosed
	case "rejected":
		return order.ReturnRejected
	default:
		return order.ReturnInitiated
	}
}

func (a *LazadaAdapter) ParseOrderWebhook(body []byte) (*IngestedOrder, error) {
	var env lazadaWebhookEnvelope
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d lazadaOrderData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing lazada order: %v", ErrInvalidPayload, err)
	}
	if d.OrderID == "" {
		return nil, fmt.Errorf("%w: missing order_id", ErrInvalidPayload)
	}

	amt := tenantdb.MustParseExactDecimal(d.Price)
	orderedAt := time.Now().UTC()
	if d.CreatedAt != "" {
		if t, err := time.Parse(time.RFC3339, d.CreatedAt); err == nil {
			orderedAt = t.UTC()
		}
	}

	var items []order.OrderItem
	for _, it := range d.OrderItems {
		p := tenantdb.MustParseExactDecimal(it.PaidPrice)
		unitCogs := tenantdb.ZeroDecimal()
		if it.UnitCogs != "" {
			unitCogs = tenantdb.MustParseExactDecimal(it.UnitCogs)
		}
		qtyDec := tenantdb.MustParseExactDecimal(fmt.Sprintf("%d", it.Quantity))
		tot, _ := p.MulFloor(qtyDec)

		items = append(items, order.OrderItem{
			Sku:             it.SKU,
			Name:            it.Name,
			Quantity:        it.Quantity,
			UnitPrice:       p,
			Total:           tot,
			UnitCogs:        unitCogs,
			CogsSourceClass: order.SourceClassOfficial,
		})
	}

	fb := order.FeeBreakdown{}
	if d.Fees.Commission != "" {
		fb.AffiliateCommission = tenantdb.MustParseExactDecimal(d.Fees.Commission)
	}
	if d.Fees.PaymentFee != "" {
		fb.PaymentFee = tenantdb.MustParseExactDecimal(d.Fees.PaymentFee)
	}
	if d.Fees.ShippingFee != "" {
		fb.ShippingCost = tenantdb.MustParseExactDecimal(d.Fees.ShippingFee)
	}
	if d.Fees.Vat != "" {
		fb.VatAmount = tenantdb.MustParseExactDecimal(d.Fees.Vat)
	}

	return &IngestedOrder{
		ExternalOrderID: d.OrderID,
		Platform:        PlatformLazada,
		LifecycleState:  mapLazadaOrderStatus(d.OrderStatus),
		Amount:          amt,
		Currency:        d.Currency,
		TaxAmount:       tenantdb.ZeroDecimal(),
		Items:           items,
		FeeBreakdown:    fb,
		OrderedAt:       orderedAt,
		RawPayload:      body,
	}, nil
}

func (a *LazadaAdapter) ParseReturnWebhook(body []byte) (*IngestedReturn, error) {
	var env lazadaWebhookEnvelope
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d lazadaReturnData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing lazada return: %v", ErrInvalidPayload, err)
	}
	if d.ReturnID == "" || d.OrderID == "" {
		return nil, fmt.Errorf("%w: missing return_id or order_id", ErrInvalidPayload)
	}

	var items []order.ReturnItem
	for _, it := range d.Items {
		items = append(items, order.ReturnItem{
			Sku:      it.SKU,
			Quantity: it.Quantity,
			Reason:   it.Reason,
		})
	}

	return &IngestedReturn{
		ExternalReturnID: d.ReturnID,
		ExternalOrderID:  d.OrderID,
		Platform:         PlatformLazada,
		Items:            items,
		TrackingNumber:   d.TrackingNumber,
		LifecycleState:   mapLazadaReturnStatus(d.Status),
		RawPayload:       body,
	}, nil
}

func (a *LazadaAdapter) ParseRefundWebhook(body []byte) (*IngestedRefund, error) {
	var env lazadaWebhookEnvelope
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d lazadaRefundData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing lazada refund: %v", ErrInvalidPayload, err)
	}
	if d.RefundID == "" || d.OrderID == "" {
		return nil, fmt.Errorf("%w: missing refund_id or order_id", ErrInvalidPayload)
	}

	amt := tenantdb.MustParseExactDecimal(d.Amount)
	return &IngestedRefund{
		ExternalRefundID: d.RefundID,
		ExternalOrderID:  d.OrderID,
		Platform:         PlatformLazada,
		Amount:           amt,
		Currency:         d.Currency,
		Reason:           d.Reason,
		RawPayload:       body,
	}, nil
}

func (a *LazadaAdapter) ParseSettlementWebhook(body []byte) ([]IngestedSettlementLine, error) {
	var env lazadaWebhookEnvelope
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d lazadaSettlementData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing lazada settlement: %v", ErrInvalidPayload, err)
	}

	var lines []IngestedSettlementLine
	for _, l := range d.Lines {
		gross := tenantdb.MustParseExactDecimal(l.GrossAmount)
		fee := tenantdb.MustParseExactDecimal(l.FeeAmount)
		ship := tenantdb.ZeroDecimal()
		if l.ShippingFee != "" {
			ship = tenantdb.MustParseExactDecimal(l.ShippingFee)
		}
		net := tenantdb.MustParseExactDecimal(l.NetAmount)

		lines = append(lines, IngestedSettlementLine{
			ExternalLineID:  l.LineID,
			ExternalOrderID: l.OrderID,
			Platform:        PlatformLazada,
			GrossAmount:     gross,
			FeeAmount:       fee,
			ShippingAmount:  ship,
			NetAmount:       net,
			Currency:        l.Currency,
		})
	}
	return lines, nil
}

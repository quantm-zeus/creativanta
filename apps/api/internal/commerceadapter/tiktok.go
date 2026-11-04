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

// TikTokAdapter implements commerce integration for TikTok Shop.
type TikTokAdapter struct{}

func NewTikTokAdapter() *TikTokAdapter {
	return &TikTokAdapter{}
}

func (a *TikTokAdapter) Platform() string {
	return PlatformTikTok
}

// VerifySignature validates TikTok's HMAC-SHA256 signature against the app secret.
func (a *TikTokAdapter) VerifySignature(body []byte, signature, appSecret string) bool {
	if appSecret == "" || signature == "" {
		return false
	}
	mac := hmac.New(sha256.New, []byte(appSecret))
	mac.Write(body)
	expectedMAC := hex.EncodeToString(mac.Sum(nil))
	return hmac.Equal([]byte(signature), []byte(expectedMAC))
}

type tikTokWebhookEnvelope struct {
	Type      int             `json:"type"`
	Event     string          `json:"event"`
	Timestamp int64           `json:"timestamp"`
	ShopID    string          `json:"shop_id"`
	Data      json.RawMessage `json:"data"`
}

type tikTokOrderData struct {
	OrderID     string `json:"order_id"`
	OrderStatus string `json:"order_status"` // 100: UNPAID, 111: AWAITING_SHIPMENT, 121: IN_TRANSIT, 130: COMPLETED, 140: CANCELLED
	TotalAmount string `json:"total_amount"`
	Currency    string `json:"currency"`
	TaxAmount   string `json:"tax_amount"`
	CreateTime  int64  `json:"create_time"`
	LineItems   []struct {
		SkuID     string `json:"sku_id"`
		Name      string `json:"name"`
		Quantity  int32  `json:"quantity"`
		Price     string `json:"price"`
		UnitCogs  string `json:"unit_cogs"`
		Variation string `json:"variation"`
	} `json:"line_items"`
	FeeBreakdown struct {
		PlatformFee string `json:"platform_fee"`
		PaymentFee  string `json:"payment_fee"`
		Commission  string `json:"commission"`
		ShippingFee string `json:"shipping_fee"`
		VatAmount   string `json:"vat_amount"`
	} `json:"fee_breakdown"`
}

type tikTokReturnData struct {
	ReturnID       string `json:"return_id"`
	OrderID        string `json:"order_id"`
	ReturnStatus   string `json:"return_status"` // REQUESTED, APPROVED, SHIPPED, RETURN_RECEIVED, COMPLETED, REJECTED
	TrackingNumber string `json:"tracking_number"`
	Items          []struct {
		SkuID    string `json:"sku_id"`
		Quantity int32  `json:"quantity"`
		Reason   string `json:"reason"`
	} `json:"items"`
}

type tikTokRefundData struct {
	RefundID     string `json:"refund_id"`
	OrderID      string `json:"order_id"`
	RefundAmount string `json:"refund_amount"`
	Currency     string `json:"currency"`
	Reason       string `json:"reason"`
}

type tikTokSettlementData struct {
	SettlementID string `json:"settlement_id"`
	Lines        []struct {
		LineID         string `json:"line_id"`
		OrderID        string `json:"order_id"`
		GrossAmount    string `json:"gross_amount"`
		FeeAmount      string `json:"fee_amount"`
		ShippingAmount string `json:"shipping_amount"`
		NetAmount      string `json:"net_amount"`
		Currency       string `json:"currency"`
	} `json:"lines"`
}

func mapTikTokOrderStatus(status string) order.LifecycleState {
	switch status {
	case "100", "UNPAID":
		return order.StateCreated
	case "111", "AWAITING_SHIPMENT":
		return order.StateConfirmed
	case "121", "IN_TRANSIT", "SHIPPED":
		return order.StateFulfilled
	case "130", "COMPLETED", "DELIVERED":
		return order.StateCompleted
	case "140", "CANCELLED":
		return order.StateCancelled
	default:
		return order.StateCreated
	}
}

func mapTikTokReturnStatus(status string) order.ReturnState {
	switch status {
	case "REQUESTED":
		return order.ReturnInitiated
	case "APPROVED":
		return order.ReturnApproved
	case "SHIPPED":
		return order.ReturnShippedBack
	case "RETURN_RECEIVED":
		return order.ReturnReceived
	case "COMPLETED":
		return order.ReturnClosed
	case "REJECTED":
		return order.ReturnRejected
	default:
		return order.ReturnInitiated
	}
}

func (a *TikTokAdapter) ParseOrderWebhook(body []byte) (*IngestedOrder, error) {
	var env tikTokWebhookEnvelope
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d tikTokOrderData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing order data: %v", ErrInvalidPayload, err)
	}
	if d.OrderID == "" {
		return nil, fmt.Errorf("%w: missing order_id", ErrInvalidPayload)
	}

	amt := tenantdb.MustParseExactDecimal(d.TotalAmount)
	tax := tenantdb.ZeroDecimal()
	if d.TaxAmount != "" {
		tax = tenantdb.MustParseExactDecimal(d.TaxAmount)
	}

	orderedAt := time.Now().UTC()
	if d.CreateTime > 0 {
		orderedAt = time.Unix(d.CreateTime, 0).UTC()
	}

	var items []order.OrderItem
	for _, it := range d.LineItems {
		itemPrice := tenantdb.MustParseExactDecimal(it.Price)
		unitCogs := tenantdb.ZeroDecimal()
		if it.UnitCogs != "" {
			unitCogs = tenantdb.MustParseExactDecimal(it.UnitCogs)
		}
		qtyDec := tenantdb.MustParseExactDecimal(fmt.Sprintf("%d", it.Quantity))
		itemTotal, _ := itemPrice.MulFloor(qtyDec)

		items = append(items, order.OrderItem{
			Sku:             it.SkuID,
			Name:            it.Name,
			Quantity:        it.Quantity,
			UnitPrice:       itemPrice,
			Total:           itemTotal,
			UnitCogs:        unitCogs,
			CogsSourceClass: order.SourceClassOfficial,
			Variation:       it.Variation,
		})
	}

	feeBreakdown := order.FeeBreakdown{}
	if d.FeeBreakdown.PlatformFee != "" {
		feeBreakdown.PlatformFee = tenantdb.MustParseExactDecimal(d.FeeBreakdown.PlatformFee)
	}
	if d.FeeBreakdown.PaymentFee != "" {
		feeBreakdown.PaymentFee = tenantdb.MustParseExactDecimal(d.FeeBreakdown.PaymentFee)
	}
	if d.FeeBreakdown.Commission != "" {
		feeBreakdown.AffiliateCommission = tenantdb.MustParseExactDecimal(d.FeeBreakdown.Commission)
	}
	if d.FeeBreakdown.ShippingFee != "" {
		feeBreakdown.ShippingCost = tenantdb.MustParseExactDecimal(d.FeeBreakdown.ShippingFee)
	}
	if d.FeeBreakdown.VatAmount != "" {
		feeBreakdown.VatAmount = tenantdb.MustParseExactDecimal(d.FeeBreakdown.VatAmount)
	}

	return &IngestedOrder{
		ExternalOrderID: d.OrderID,
		Platform:        PlatformTikTok,
		LifecycleState:  mapTikTokOrderStatus(d.OrderStatus),
		Amount:          amt,
		Currency:        d.Currency,
		TaxAmount:       tax,
		Items:           items,
		FeeBreakdown:    feeBreakdown,
		OrderedAt:       orderedAt,
		RawPayload:      body,
	}, nil
}

func (a *TikTokAdapter) ParseReturnWebhook(body []byte) (*IngestedReturn, error) {
	var env tikTokWebhookEnvelope
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d tikTokReturnData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing return data: %v", ErrInvalidPayload, err)
	}
	if d.ReturnID == "" || d.OrderID == "" {
		return nil, fmt.Errorf("%w: missing return_id or order_id", ErrInvalidPayload)
	}

	var items []order.ReturnItem
	for _, it := range d.Items {
		items = append(items, order.ReturnItem{
			Sku:      it.SkuID,
			Quantity: it.Quantity,
			Reason:   it.Reason,
		})
	}

	return &IngestedReturn{
		ExternalReturnID: d.ReturnID,
		ExternalOrderID:  d.OrderID,
		Platform:         PlatformTikTok,
		Items:            items,
		TrackingNumber:   d.TrackingNumber,
		LifecycleState:   mapTikTokReturnStatus(d.ReturnStatus),
		RawPayload:       body,
	}, nil
}

func (a *TikTokAdapter) ParseRefundWebhook(body []byte) (*IngestedRefund, error) {
	var env tikTokWebhookEnvelope
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d tikTokRefundData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing refund data: %v", ErrInvalidPayload, err)
	}
	if d.RefundID == "" || d.OrderID == "" {
		return nil, fmt.Errorf("%w: missing refund_id or order_id", ErrInvalidPayload)
	}

	amt := tenantdb.MustParseExactDecimal(d.RefundAmount)
	return &IngestedRefund{
		ExternalRefundID: d.RefundID,
		ExternalOrderID:  d.OrderID,
		Platform:         PlatformTikTok,
		Amount:           amt,
		Currency:         d.Currency,
		Reason:           d.Reason,
		RawPayload:       body,
	}, nil
}

func (a *TikTokAdapter) ParseSettlementWebhook(body []byte) ([]IngestedSettlementLine, error) {
	var env tikTokWebhookEnvelope
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d tikTokSettlementData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing settlement data: %v", ErrInvalidPayload, err)
	}

	var lines []IngestedSettlementLine
	for _, l := range d.Lines {
		gross := tenantdb.MustParseExactDecimal(l.GrossAmount)
		fee := tenantdb.MustParseExactDecimal(l.FeeAmount)
		ship := tenantdb.ZeroDecimal()
		if l.ShippingAmount != "" {
			ship = tenantdb.MustParseExactDecimal(l.ShippingAmount)
		}
		net := tenantdb.MustParseExactDecimal(l.NetAmount)

		lines = append(lines, IngestedSettlementLine{
			ExternalLineID:  l.LineID,
			ExternalOrderID: l.OrderID,
			Platform:        PlatformTikTok,
			GrossAmount:     gross,
			FeeAmount:       fee,
			ShippingAmount:  ship,
			NetAmount:       net,
			Currency:        l.Currency,
		})
	}
	return lines, nil
}

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

// ShopeeAdapter implements commerce integration for Shopee Open Platform.
type ShopeeAdapter struct{}

func NewShopeeAdapter() *ShopeeAdapter {
	return &ShopeeAdapter{}
}

func (a *ShopeeAdapter) Platform() string {
	return PlatformShopee
}

// VerifySignature validates Shopee's HMAC-SHA256 signature calculated from URL and raw body.
func (a *ShopeeAdapter) VerifySignature(webhookURL string, body []byte, signature, partnerKey string) bool {
	if partnerKey == "" || signature == "" {
		return false
	}
	base := fmt.Sprintf("%s|%s", webhookURL, string(body))
	mac := hmac.New(sha256.New, []byte(partnerKey))
	mac.Write([]byte(base))
	expected := hex.EncodeToString(mac.Sum(nil))
	return hmac.Equal([]byte(signature), []byte(expected))
}

type shopeeWebhookPayload struct {
	ShopID    int64           `json:"shop_id"`
	Code      int             `json:"code"`
	Timestamp int64           `json:"timestamp"`
	Data      json.RawMessage `json:"data"`
}

type shopeeOrderData struct {
	OrderSN     string `json:"ordersn"`
	Status      string `json:"status"` // UNPAID, READY_TO_SHIP, PROCESSED, SHIPPED, COMPLETED, CANCELLED
	TotalAmount string `json:"total_amount"`
	Currency    string `json:"currency"`
	CreateTime  int64  `json:"create_time"`
	Items       []struct {
		ItemSKU                string `json:"item_sku"`
		ItemName               string `json:"item_name"`
		ModelQuantityPurchased int32  `json:"model_quantity_purchased"`
		ModelDiscountedPrice   string `json:"model_discounted_price"`
		UnitCogs               string `json:"unit_cogs"`
	} `json:"items"`
	EscrowDetail struct {
		CommissionFee     string `json:"commission_fee"`
		ServiceFee        string `json:"service_fee"`
		ShopeeShippingFee string `json:"shopee_shipping_fee"`
		TransactionFee    string `json:"transaction_fee"`
		VoucherDiscount   string `json:"voucher_discount"`
	} `json:"escrow_detail"`
}

type shopeeReturnData struct {
	ReturnSN       string `json:"return_sn"`
	OrderSN        string `json:"ordersn"`
	Status         string `json:"status"` // REQUESTED, ACCEPTED, CANCELLED, REFUND_PAID, CLOSED
	TrackingNumber string `json:"tracking_number"`
	Items          []struct {
		ItemSKU  string `json:"item_sku"`
		Quantity int32  `json:"quantity"`
		Reason   string `json:"reason"`
	} `json:"items"`
}

type shopeeRefundData struct {
	RefundSN     string `json:"refund_sn"`
	OrderSN      string `json:"ordersn"`
	RefundAmount string `json:"refund_amount"`
	Currency     string `json:"currency"`
	Reason       string `json:"reason"`
}

type shopeeSettlementData struct {
	PayoutID string `json:"payout_id"`
	Lines    []struct {
		PayoutLineID string `json:"payout_line_id"`
		OrderSN      string `json:"ordersn"`
		GrossAmount  string `json:"gross_amount"`
		FeeAmount    string `json:"fee_amount"`
		ShippingCost string `json:"shipping_cost"`
		NetAmount    string `json:"net_amount"`
		Currency     string `json:"currency"`
	} `json:"lines"`
}

func mapShopeeOrderStatus(status string) order.LifecycleState {
	switch status {
	case "UNPAID":
		return order.StateCreated
	case "READY_TO_SHIP", "PROCESSED":
		return order.StateConfirmed
	case "SHIPPED":
		return order.StateFulfilled
	case "COMPLETED":
		return order.StateCompleted
	case "CANCELLED":
		return order.StateCancelled
	default:
		return order.StateCreated
	}
}

func mapShopeeReturnStatus(status string) order.ReturnState {
	switch status {
	case "REQUESTED":
		return order.ReturnInitiated
	case "ACCEPTED":
		return order.ReturnApproved
	case "SHIPPED_BACK":
		return order.ReturnShippedBack
	case "REFUND_PAID", "CLOSED":
		return order.ReturnClosed
	default:
		return order.ReturnInitiated
	}
}

func (a *ShopeeAdapter) ParseOrderWebhook(body []byte) (*IngestedOrder, error) {
	var env shopeeWebhookPayload
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d shopeeOrderData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing shopee order: %v", ErrInvalidPayload, err)
	}
	if d.OrderSN == "" {
		return nil, fmt.Errorf("%w: missing ordersn", ErrInvalidPayload)
	}

	amt := tenantdb.MustParseExactDecimal(d.TotalAmount)
	orderedAt := time.Now().UTC()
	if d.CreateTime > 0 {
		orderedAt = time.Unix(d.CreateTime, 0).UTC()
	}

	var items []order.OrderItem
	for _, it := range d.Items {
		price := tenantdb.MustParseExactDecimal(it.ModelDiscountedPrice)
		unitCogs := tenantdb.ZeroDecimal()
		if it.UnitCogs != "" {
			unitCogs = tenantdb.MustParseExactDecimal(it.UnitCogs)
		}
		qtyDec := tenantdb.MustParseExactDecimal(fmt.Sprintf("%d", it.ModelQuantityPurchased))
		tot, _ := price.MulFloor(qtyDec)

		items = append(items, order.OrderItem{
			Sku:             it.ItemSKU,
			Name:            it.ItemName,
			Quantity:        it.ModelQuantityPurchased,
			UnitPrice:       price,
			Total:           tot,
			UnitCogs:        unitCogs,
			CogsSourceClass: order.SourceClassOfficial,
		})
	}

	fb := order.FeeBreakdown{}
	// Commission fee maps to platform/affiliate
	if d.EscrowDetail.CommissionFee != "" {
		fb.AffiliateCommission = tenantdb.MustParseExactDecimal(d.EscrowDetail.CommissionFee)
	}
	// Service fee + transaction fee map to platform fee and payment fee
	if d.EscrowDetail.ServiceFee != "" {
		fb.PlatformFee = tenantdb.MustParseExactDecimal(d.EscrowDetail.ServiceFee)
	}
	if d.EscrowDetail.TransactionFee != "" {
		fb.PaymentFee = tenantdb.MustParseExactDecimal(d.EscrowDetail.TransactionFee)
	}
	if d.EscrowDetail.ShopeeShippingFee != "" {
		fb.ShippingCost = tenantdb.MustParseExactDecimal(d.EscrowDetail.ShopeeShippingFee)
	}

	return &IngestedOrder{
		ExternalOrderID: d.OrderSN,
		Platform:        PlatformShopee,
		LifecycleState:  mapShopeeOrderStatus(d.Status),
		Amount:          amt,
		Currency:        d.Currency,
		TaxAmount:       tenantdb.ZeroDecimal(),
		Items:           items,
		FeeBreakdown:    fb,
		OrderedAt:       orderedAt,
		RawPayload:      body,
	}, nil
}

func (a *ShopeeAdapter) ParseReturnWebhook(body []byte) (*IngestedReturn, error) {
	var env shopeeWebhookPayload
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d shopeeReturnData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing shopee return: %v", ErrInvalidPayload, err)
	}
	if d.ReturnSN == "" || d.OrderSN == "" {
		return nil, fmt.Errorf("%w: missing return_sn or ordersn", ErrInvalidPayload)
	}

	var items []order.ReturnItem
	for _, it := range d.Items {
		items = append(items, order.ReturnItem{
			Sku:      it.ItemSKU,
			Quantity: it.Quantity,
			Reason:   it.Reason,
		})
	}

	return &IngestedReturn{
		ExternalReturnID: d.ReturnSN,
		ExternalOrderID:  d.OrderSN,
		Platform:         PlatformShopee,
		Items:            items,
		TrackingNumber:   d.TrackingNumber,
		LifecycleState:   mapShopeeReturnStatus(d.Status),
		RawPayload:       body,
	}, nil
}

func (a *ShopeeAdapter) ParseRefundWebhook(body []byte) (*IngestedRefund, error) {
	var env shopeeWebhookPayload
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d shopeeRefundData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing shopee refund: %v", ErrInvalidPayload, err)
	}
	if d.RefundSN == "" || d.OrderSN == "" {
		return nil, fmt.Errorf("%w: missing refund_sn or ordersn", ErrInvalidPayload)
	}

	amt := tenantdb.MustParseExactDecimal(d.RefundAmount)
	return &IngestedRefund{
		ExternalRefundID: d.RefundSN,
		ExternalOrderID:  d.OrderSN,
		Platform:         PlatformShopee,
		Amount:           amt,
		Currency:         d.Currency,
		Reason:           d.Reason,
		RawPayload:       body,
	}, nil
}

func (a *ShopeeAdapter) ParseSettlementWebhook(body []byte) ([]IngestedSettlementLine, error) {
	var env shopeeWebhookPayload
	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	var d shopeeSettlementData
	if err := json.Unmarshal(env.Data, &d); err != nil {
		return nil, fmt.Errorf("%w: parsing shopee settlement: %v", ErrInvalidPayload, err)
	}

	var lines []IngestedSettlementLine
	for _, l := range d.Lines {
		gross := tenantdb.MustParseExactDecimal(l.GrossAmount)
		fee := tenantdb.MustParseExactDecimal(l.FeeAmount)
		ship := tenantdb.ZeroDecimal()
		if l.ShippingCost != "" {
			ship = tenantdb.MustParseExactDecimal(l.ShippingCost)
		}
		net := tenantdb.MustParseExactDecimal(l.NetAmount)

		lines = append(lines, IngestedSettlementLine{
			ExternalLineID:  l.PayoutLineID,
			ExternalOrderID: l.OrderSN,
			Platform:        PlatformShopee,
			GrossAmount:     gross,
			FeeAmount:       fee,
			ShippingAmount:  ship,
			NetAmount:       net,
			Currency:        l.Currency,
		})
	}
	return lines, nil
}

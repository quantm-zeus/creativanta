package commerceadapter

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// StripeAdapter implements webhook parsing and signature verification for Stripe.
type StripeAdapter struct{}

func NewStripeAdapter() *StripeAdapter {
	return &StripeAdapter{}
}

func (a *StripeAdapter) Platform() string {
	return PlatformStripe
}

// VerifySignature validates Stripe's timestamped HMAC-SHA256 signature header (t=...,v1=...).
func (a *StripeAdapter) VerifySignature(payload []byte, sigHeader, secret string, tolerance time.Duration) bool {
	if sigHeader == "" || secret == "" {
		return false
	}

	var timestampStr string
	var signatures []string

	items := strings.Split(sigHeader, ",")
	for _, item := range items {
		parts := strings.SplitN(item, "=", 2)
		if len(parts) != 2 {
			continue
		}
		key := strings.TrimSpace(parts[0])
		val := strings.TrimSpace(parts[1])
		if key == "t" {
			timestampStr = val
		} else if key == "v1" {
			signatures = append(signatures, val)
		}
	}

	if timestampStr == "" || len(signatures) == 0 {
		return false
	}

	ts, err := strconv.ParseInt(timestampStr, 10, 64)
	if err != nil {
		return false
	}

	if tolerance > 0 {
		eventTime := time.Unix(ts, 0)
		diff := time.Since(eventTime)
		if diff < -tolerance || diff > tolerance {
			return false
		}
	}

	signedPayload := fmt.Sprintf("%s.%s", timestampStr, string(payload))
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write([]byte(signedPayload))
	expected := hex.EncodeToString(mac.Sum(nil))

	for _, sig := range signatures {
		if hmac.Equal([]byte(sig), []byte(expected)) {
			return true
		}
	}
	return false
}

type stripeEvent struct {
	ID      string          `json:"id"`
	Type    string          `json:"type"`
	Created int64           `json:"created"`
	Data    stripeEventData `json:"data"`
}

type stripeEventData struct {
	Object json.RawMessage `json:"object"`
}

type stripePaymentIntent struct {
	ID          string            `json:"id"`
	Amount      int64             `json:"amount"` // in smallest currency unit (cents / 100 for USD/EUR, whole for VND)
	Currency    string            `json:"currency"`
	Status      string            `json:"status"`
	Created     int64             `json:"created"`
	Metadata    map[string]string `json:"metadata"`
	Application string            `json:"application"`
}

type stripeChargeRefunded struct {
	ID             string            `json:"id"`
	PaymentIntent  string            `json:"payment_intent"`
	AmountRefunded int64             `json:"amount_refunded"`
	Currency       string            `json:"currency"`
	Metadata       map[string]string `json:"metadata"`
}

func (a *StripeAdapter) ParseWebhook(payload []byte) (eventType string, ord *IngestedOrder, ref *IngestedRefund, err error) {
	var ev stripeEvent
	if err := json.Unmarshal(payload, &ev); err != nil {
		return "", nil, nil, fmt.Errorf("%w: %v", ErrInvalidPayload, err)
	}

	switch ev.Type {
	case "payment_intent.succeeded":
		var pi stripePaymentIntent
		if err := json.Unmarshal(ev.Data.Object, &pi); err != nil {
			return ev.Type, nil, nil, fmt.Errorf("%w: parsing payment_intent: %v", ErrInvalidPayload, err)
		}

		currency := strings.ToUpper(pi.Currency)
		var amt tenantdb.ExactDecimal
		if currency == "VND" || currency == "JPY" {
			amt = tenantdb.MustParseExactDecimal(fmt.Sprintf("%d", pi.Amount))
		} else {
			// Zero-decimal currencies vs 2-decimal currencies (divide by 100)
			dollars := pi.Amount / 100
			cents := pi.Amount % 100
			amt = tenantdb.MustParseExactDecimal(fmt.Sprintf("%d.%02d", dollars, cents))
		}

		orderID := pi.ID
		if customOrderID, ok := pi.Metadata["order_id"]; ok && customOrderID != "" {
			orderID = customOrderID
		}

		return ev.Type, &IngestedOrder{
			ExternalOrderID: orderID,
			Platform:        PlatformStripe,
			LifecycleState:  order.StateConfirmed,
			Amount:          amt,
			Currency:        currency,
			TaxAmount:       tenantdb.ZeroDecimal(),
			OrderedAt:       time.Unix(pi.Created, 0).UTC(),
			RawPayload:      payload,
		}, nil, nil

	case "charge.refunded":
		var cr stripeChargeRefunded
		if err := json.Unmarshal(ev.Data.Object, &cr); err != nil {
			return ev.Type, nil, nil, fmt.Errorf("%w: parsing charge.refunded: %v", ErrInvalidPayload, err)
		}

		currency := strings.ToUpper(cr.Currency)
		var amt tenantdb.ExactDecimal
		if currency == "VND" || currency == "JPY" {
			amt = tenantdb.MustParseExactDecimal(fmt.Sprintf("%d", cr.AmountRefunded))
		} else {
			dollars := cr.AmountRefunded / 100
			cents := cr.AmountRefunded % 100
			amt = tenantdb.MustParseExactDecimal(fmt.Sprintf("%d.%02d", dollars, cents))
		}

		orderID := cr.PaymentIntent
		if customOrderID, ok := cr.Metadata["order_id"]; ok && customOrderID != "" {
			orderID = customOrderID
		}

		return ev.Type, nil, &IngestedRefund{
			ExternalRefundID: cr.ID,
			ExternalOrderID:  orderID,
			EventID:          ev.ID,
			Platform:         PlatformStripe,
			Amount:           amt,
			IsCumulative:     true,
			Currency:         currency,
			Reason:           "Stripe charge.refunded webhook",
			RawPayload:       payload,
		}, nil

	default:
		return ev.Type, nil, nil, nil
	}
}

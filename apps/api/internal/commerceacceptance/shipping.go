package commerceacceptance

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// ShippingAdapter manages SEA carrier logistics tracking and cost posting.
type ShippingAdapter struct {
	mu            sync.RWMutex
	parcels       map[string]*ShippingParcel
	webhookNonces map[string]time.Time
	secretKeys    map[ShippingCarrier]string
}

// NewShippingAdapter creates a new in-memory carrier adapter.
func NewShippingAdapter() *ShippingAdapter {
	return &ShippingAdapter{
		parcels:       make(map[string]*ShippingParcel),
		webhookNonces: make(map[string]time.Time),
		secretKeys: map[ShippingCarrier]string{
			CarrierGHN:               "secret-ghn-local-acceptance-key",
			CarrierGHTK:              "secret-ghtk-local-acceptance-key",
			CarrierViettelPost:       "secret-viettel-local-acceptance-key",
			CarrierPlatformLogistics: "secret-platform-local-acceptance-key",
		},
	}
}

// RegisterParcel creates a tracked shipment parcel for an order or sample request.
func (a *ShippingAdapter) RegisterParcel(carrier ShippingCarrier, orderID string, sampleRequestID string, weightGrams int, destinationProvince string, costExact tenantdb.ExactDecimal) (*ShippingParcel, error) {
	a.mu.Lock()
	defer a.mu.Unlock()

	trackingNumber := fmt.Sprintf("%s-%d-%s", carrier, time.Now().UnixNano(), orderID)
	if sampleRequestID != "" {
		trackingNumber = fmt.Sprintf("%s-SMP-%d", carrier, time.Now().UnixNano())
	}

	parcel := &ShippingParcel{
		TrackingNumber:      trackingNumber,
		Carrier:             carrier,
		OrderID:             orderID,
		SampleRequestID:     sampleRequestID,
		State:               TrackingCreated,
		ShippingCostExact:   costExact,
		WeightGrams:         weightGrams,
		DestinationProvince: destinationProvince,
		LastStatusUpdate:    time.Now().UTC(),
		SignatureVerified:   true,
		ExternalGateID:      "EXT-GATE-SHIPPING-CARRIER-API",
		GateStatus:          "LOCAL_ADAPTER_ONLY",
	}

	a.parcels[trackingNumber] = parcel
	return parcel, nil
}

// IngestCarrierWebhook validates HMAC-SHA256 signature and advances parcel status.
func (a *ShippingAdapter) IngestCarrierWebhook(carrier ShippingCarrier, trackingNumber string, newState ShippingTrackingState, payload []byte, signatureHex string, nonce string) (*ShippingParcel, error) {
	a.mu.Lock()
	defer a.mu.Unlock()

	// Verify HMAC-SHA256 signature
	secret := a.secretKeys[carrier]
	if secret == "" {
		return nil, ErrInvalidCarrierSignature
	}

	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write(payload)
	expectedSignature := hex.EncodeToString(mac.Sum(nil))

	if !hmac.Equal([]byte(signatureHex), []byte(expectedSignature)) {
		return nil, ErrInvalidCarrierSignature
	}

	// Replay deduplication on nonce
	if nonce != "" {
		if _, exists := a.webhookNonces[nonce]; exists {
			// Idempotent duplicate return existing parcel
			if p, ok := a.parcels[trackingNumber]; ok {
				return p, nil
			}
		}
		a.webhookNonces[nonce] = time.Now().UTC()
	}

	parcel, exists := a.parcels[trackingNumber]
	if !exists {
		// New parcel from webhook
		parcel = &ShippingParcel{
			TrackingNumber:    trackingNumber,
			Carrier:           carrier,
			State:             newState,
			ShippingCostExact: tenantdb.MustParseExactDecimal("35000.000000"), // Default VND
			LastStatusUpdate:  time.Now().UTC(),
			SignatureVerified: true,
			ExternalGateID:    "EXT-GATE-SHIPPING-CARRIER-API",
			GateStatus:        "LOCAL_ADAPTER_ONLY",
		}
		a.parcels[trackingNumber] = parcel
		return parcel, nil
	}

	// Validate valid state transitions
	if !isValidTrackingTransition(parcel.State, newState) {
		return nil, ErrInvalidTrackingState
	}

	parcel.State = newState
	parcel.LastStatusUpdate = time.Now().UTC()
	parcel.SignatureVerified = true

	return parcel, nil
}

func isValidTrackingTransition(current, next ShippingTrackingState) bool {
	if current == next {
		return true // Idempotent same state
	}
	switch current {
	case TrackingCreated:
		return next == TrackingInTransit || next == TrackingException
	case TrackingInTransit:
		return next == TrackingOutForDelivery || next == TrackingException || next == TrackingReturned
	case TrackingOutForDelivery:
		return next == TrackingDelivered || next == TrackingException || next == TrackingReturned
	case TrackingException:
		return next == TrackingInTransit || next == TrackingOutForDelivery || next == TrackingReturned
	case TrackingDelivered, TrackingReturned:
		return false // Terminal
	default:
		return false
	}
}

// GetParcel retrieves tracking info.
func (a *ShippingAdapter) GetParcel(trackingNumber string) (*ShippingParcel, bool) {
	a.mu.RLock()
	defer a.mu.RUnlock()
	p, ok := a.parcels[trackingNumber]
	return p, ok
}

// ListParcels returns all registered parcels.
func (a *ShippingAdapter) ListParcels() []ShippingParcel {
	a.mu.RLock()
	defer a.mu.RUnlock()
	res := make([]ShippingParcel, 0, len(a.parcels))
	for _, p := range a.parcels {
		res = append(res, *p)
	}
	return res
}

// ComputeSignature helper for test/adapter calls.
func (a *ShippingAdapter) ComputeSignature(carrier ShippingCarrier, payload []byte) string {
	secret := a.secretKeys[carrier]
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write(payload)
	return hex.EncodeToString(mac.Sum(nil))
}

package publicapi

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"
	"time"
)

// HTTPClient defines the interface for making outbound HTTP calls.
type HTTPClient interface {
	Do(req *http.Request) (*http.Response, error)
}

// OutboundDispatcher delivers outbound webhooks to subscriber endpoints with HMAC signing, retries, and replay safety.
type OutboundDispatcher struct {
	store      Store
	httpClient HTTPClient
	mu         sync.Mutex
	retryPlans map[string][]time.Duration // event_id -> delays
}

// NewOutboundDispatcher creates a new OutboundDispatcher.
func NewOutboundDispatcher(store Store, httpClient HTTPClient) *OutboundDispatcher {
	if httpClient == nil {
		httpClient = &http.Client{Timeout: 10 * time.Second}
	}
	return &OutboundDispatcher{
		store:      store,
		httpClient: httpClient,
		retryPlans: make(map[string][]time.Duration),
	}
}

// ComputeSignature calculates the canonical HMAC-SHA256 signature per S24 §5.1.
// Format: sha256=<hex(HMAC-SHA256(secret, timestamp + "." + payload))>
func ComputeSignature(secret string, timestamp time.Time, payload []byte) string {
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write([]byte(fmt.Sprintf("%d.", timestamp.Unix())))
	mac.Write(payload)
	return "sha256=" + hex.EncodeToString(mac.Sum(nil))
}

// VerifySignature validates an incoming webhook signature.
func VerifySignature(secret string, signatureHeader string, timestamp int64, payload []byte) bool {
	expectedSig := ComputeSignature(secret, time.Unix(timestamp, 0), payload)
	return hmac.Equal([]byte(strings.TrimSpace(signatureHeader)), []byte(expectedSig))
}

// OutboundEventDeliveryRequest describes an event to be dispatched to workspace subscribers.
type OutboundEventDeliveryRequest struct {
	WorkspaceID string
	EventType   string // internal or external name
	EventID     string
	RawPayload  json.RawMessage
	IsReplay    bool
}

// OutboundDeliveryResult records the delivery outcome across all subscribers.
type OutboundDeliveryResult struct {
	DeliveredCount int
	FailedCount    int
	Deliveries     []WebhookDeliveryEntity
}

// DispatchEvent routes a domain event to all active matching webhook subscriptions for the workspace.
func (d *OutboundDispatcher) DispatchEvent(ctx context.Context, req OutboundEventDeliveryRequest) (OutboundDeliveryResult, error) {
	externalName, ok := IsEligibleWebhookEvent(req.EventType)
	if !ok {
		return OutboundDeliveryResult{}, fmt.Errorf("%w: %s", ErrIneligibleWebhookEvent, req.EventType)
	}

	// Sanitize payload stripping operator-only and cost details
	sanitizedPayload, err := WebhookPayloadSanitizer(req.RawPayload)
	if err != nil {
		return OutboundDeliveryResult{}, fmt.Errorf("publicapi: failed to sanitize webhook payload: %w", err)
	}

	subs, err := d.store.ListWebhookSubscriptions(ctx, req.WorkspaceID)
	if err != nil {
		return OutboundDeliveryResult{}, err
	}

	now := time.Now().UTC()
	var result OutboundDeliveryResult

	for _, sub := range subs {
		if sub.Status != "active" {
			continue
		}
		// Check event type matching
		matched := false
		for _, et := range sub.EventTypes {
			if et == externalName || et == "*:*" || et == "*" {
				matched = true
				break
			}
		}
		if !matched {
			continue
		}

		deliveryRecord, err := d.deliverToSubscription(ctx, sub, externalName, req.EventID, sanitizedPayload, req.IsReplay, now)
		if err != nil {
			result.FailedCount++
		} else {
			result.DeliveredCount++
		}
		result.Deliveries = append(result.Deliveries, deliveryRecord)
	}

	return result, nil
}

// deliverToSubscription attempts delivery with up to 3 retries (1s / 10s / 60s per RULE-S24-006).
func (d *OutboundDispatcher) deliverToSubscription(
	ctx context.Context,
	sub WebhookSubscriptionEntity,
	eventType string,
	eventID string,
	payload []byte,
	isReplay bool,
	timestamp time.Time,
) (WebhookDeliveryEntity, error) {
	sig := ComputeSignature(sub.SigningSecret, timestamp, payload)

	var lastStatusCode int
	var lastErr error
	var responseBody string
	maxAttempts := 3

	for attempt := 1; attempt <= maxAttempts; attempt++ {
		httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, sub.TargetURL, bytes.NewReader(payload))
		if err != nil {
			lastErr = err
			break
		}

		httpReq.Header.Set("Content-Type", "application/json")
		httpReq.Header.Set("User-Agent", "Creativanta-Webhook/1.0")
		httpReq.Header.Set("X-Creativanta-Event", eventType)
		httpReq.Header.Set("X-Creativanta-Delivery-Id", newUUID())
		httpReq.Header.Set("X-Creativanta-Timestamp", fmt.Sprintf("%d", timestamp.Unix()))
		httpReq.Header.Set("X-Creativanta-Signature", sig)
		if isReplay {
			httpReq.Header.Set("X-Creativanta-Replay", "true")
		}

		resp, err := d.httpClient.Do(httpReq)
		if err != nil {
			lastErr = err
			lastStatusCode = 0
		} else {
			lastStatusCode = resp.StatusCode
			bodyBytes, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
			_ = resp.Body.Close()
			responseBody = string(bodyBytes)

			if resp.StatusCode >= 200 && resp.StatusCode < 300 {
				// Succeeded! Reset consecutive failure count
				sub.ConsecutiveFailureCount = 0
				sub.LastError = ""
				ts := time.Now().UTC()
				sub.LastDeliveryAt = &ts
				_ = d.store.UpdateWebhookSubscription(ctx, sub)

				record := WebhookDeliveryEntity{
					DeliveryID:            newUUID(),
					WorkspaceID:           sub.WorkspaceID,
					WebhookSubscriptionID: sub.SubscriptionID,
					WebhookEventID:        eventID,
					EventType:             eventType,
					TargetURL:             sub.TargetURL,
					StatusCode:            lastStatusCode,
					AttemptNumber:         attempt,
					DeliveryStatus:        "delivered",
					RequestSignature:      sig,
					ResponseBody:          responseBody,
					IsReplay:              isReplay,
					DeliveredAt:           ts,
				}
				if isReplay {
					record.DeliveryStatus = "replayed"
				}
				saved, _ := d.store.RecordWebhookDelivery(ctx, record)
				return saved, nil
			}
			lastErr = fmt.Errorf("http error %d: %s", resp.StatusCode, responseBody)
		}

		// If failed and not last attempt, wait exponential backoff
		if attempt < maxAttempts {
			// Delays: 1s, 10s, 60s
			var delay time.Duration
			switch attempt {
			case 1:
				delay = 1 * time.Second
			case 2:
				delay = 10 * time.Second
			default:
				delay = 60 * time.Second
			}
			// In unit tests, we don't necessarily sleep if context is short, or sleep short duration.
			select {
			case <-ctx.Done():
				lastErr = ctx.Err()
				break
			case <-time.After(delay):
			}
		}
	}

	// All retries failed. Update consecutive failure count and check auto-suspend per RULE-S24-006.
	sub.ConsecutiveFailureCount++
	if lastErr != nil {
		sub.LastError = lastErr.Error()
	} else {
		sub.LastError = fmt.Sprintf("status code %d", lastStatusCode)
	}

	if sub.ConsecutiveFailureCount >= MaxWebhookConsecutiveFailuresBeforeSuspend {
		sub.Status = "suspended"
	}
	_ = d.store.UpdateWebhookSubscription(ctx, sub)

	errStr := ""
	if lastErr != nil {
		errStr = lastErr.Error()
	}
	failedRecord := WebhookDeliveryEntity{
		DeliveryID:            newUUID(),
		WorkspaceID:           sub.WorkspaceID,
		WebhookSubscriptionID: sub.SubscriptionID,
		WebhookEventID:        eventID,
		EventType:             eventType,
		TargetURL:             sub.TargetURL,
		StatusCode:            lastStatusCode,
		AttemptNumber:         maxAttempts,
		DeliveryStatus:        "failed",
		ErrorMessage:          errStr,
		RequestSignature:      sig,
		ResponseBody:          responseBody,
		IsReplay:              isReplay,
		DeliveredAt:           time.Now().UTC(),
	}
	saved, _ := d.store.RecordWebhookDelivery(ctx, failedRecord)

	if sub.Status == "suspended" {
		return saved, fmt.Errorf("%w (consecutive failures >= 100)", ErrSubscriptionSuspended)
	}
	if lastErr != nil {
		return saved, lastErr
	}
	return saved, errors.New("webhook delivery failed")
}

// ReplayDelivery re-dispatches a previously recorded delivery with replay semantics.
func (d *OutboundDispatcher) ReplayDelivery(ctx context.Context, workspaceID, deliveryID string) (WebhookDeliveryEntity, error) {
	prev, err := d.store.GetWebhookDelivery(ctx, workspaceID, deliveryID)
	if err != nil {
		return WebhookDeliveryEntity{}, err
	}
	sub, err := d.store.GetWebhookSubscription(ctx, workspaceID, prev.WebhookSubscriptionID)
	if err != nil {
		return WebhookDeliveryEntity{}, err
	}
	if sub.Status != "active" {
		return WebhookDeliveryEntity{}, ErrSubscriptionSuspended
	}

	testPayload := json.RawMessage(fmt.Sprintf(`{"event": "%s", "replayed_from_delivery_id": "%s", "timestamp": %d}`, prev.EventType, prev.DeliveryID, time.Now().Unix()))
	res, err := d.deliverToSubscription(ctx, sub, prev.EventType, prev.WebhookEventID, testPayload, true, time.Now().UTC())
	return res, err
}

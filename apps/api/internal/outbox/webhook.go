package outbox

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	// MaxWebhookConsecutiveFailuresBeforeSuspend is the S24 threshold (100 failures) that auto-suspends a subscription.
	MaxWebhookConsecutiveFailuresBeforeSuspend = 100
)

var (
	// ErrIneligibleOutboundWebhookEvent is returned when an event type is not in the 13 S24 outbound webhook events.
	ErrIneligibleOutboundWebhookEvent = errors.New("outbox: event type is not eligible for S24 outbound webhook delivery")
	// ErrWebhookSubscriptionSuspended is returned when attempting to deliver to a suspended or revoked webhook subscription.
	ErrWebhookSubscriptionSuspended = errors.New("outbox: webhook subscription is not active")
)

// CanonicalS24WebhookEventMap maps the 13 internal domain events to their external S24 webhook names
// per docs/04_contracts/domain_event_catalog.md §21.2 and docs/02_features/platform/public_api.md §5.1.
var CanonicalS24WebhookEventMap = map[string]string{
	"publish.succeeded":          "content.published",
	"publish.failed":             "content.publish_failed",
	"order.imported":             "order.created",
	"order.state_changed":        "order.updated",
	"refund.completed":           "refund.completed",
	"thread.created":             "engagement.thread_created",
	"asset.generation_completed": "asset.ready",
	"workflow_run.completed":     "workflow.completed",
	"subscription.changed":       "billing.plan_changed",
	"credits.exhausted":          "billing.credits_exhausted",
	"brand_deal.status_changed":  "brand_deal.updated",
	"live.session_ended":         "live.ended",
	"achievement.unlocked":       "gamification.achievement",
}

// EligibleS24OutboundEvents lists the canonical S24 outbound webhook event types and their internal domain event sources.
var EligibleS24OutboundEvents = map[string]struct{}{
	// External S24 webhook names (public_api.md §5.1 / domain_event_catalog.md §21.2):
	"content.published":         {},
	"content.publish_failed":    {},
	"order.created":             {},
	"order.updated":             {},
	"refund.completed":          {},
	"engagement.thread_created": {},
	"asset.ready":               {},
	"workflow.completed":        {},
	"billing.plan_changed":      {},
	"billing.credits_exhausted": {},
	"brand_deal.updated":        {},
	"live.ended":                {},
	"gamification.achievement":  {},
	// Internal domain event names (domain_event_catalog.md §21.2):
	"publish.succeeded":          {},
	"publish.failed":             {},
	"order.imported":             {},
	"order.state_changed":        {},
	"thread.created":             {},
	"asset.generation_completed": {},
	"workflow_run.completed":     {},
	"subscription.changed":       {},
	"credits.exhausted":          {},
	"brand_deal.status_changed":  {},
	"live.session_ended":         {},
	"achievement.unlocked":       {},
	// Compatibility event keys:
	"order.status_changed":          {},
	"product.updated":               {},
	"stock.low_alert":               {},
	"settlement.completed":          {},
	"reconciliation.mismatch_found": {},
	"generation.completed":          {},
	"generation.failed":             {},
	"lead.created":                  {},
	"deal.status_changed":           {},
	"credit.low_balance":            {},
}

var strippedInternalOutboundKeys = map[string]struct{}{
	"actual_cost_usd":      {},
	"platform_margin":      {},
	"internal_notes":       {},
	"is_internal_note":     {},
	"operator_explanation": {},
	"cost_breakdown":       {},
	"provider_raw_secret":  {},
}

// InboundWebhookRequest models an incoming provider webhook (e.g. TikTok Shop, Shopee, Stripe).
type InboundWebhookRequest struct {
	WebhookEventID  string
	WorkspaceID     string
	Provider        string
	ExternalEventID string
	IdempotencyKey  string
	ConsumerName    string
	EventID         string
	Payload         json.RawMessage
	ReceivedAt      time.Time
}

// InboundWebhookResult reports whether the webhook was newly processed or deduplicated.
type InboundWebhookResult struct {
	WebhookEventID   string
	EventID          string
	Processed        bool
	Deduplicated     bool
	ProcessingStatus string
}

// WebhookProcessor guarantees that duplicate inbound webhooks have strictly one effect
// by combining webhook_events (provider, idempotency_key) and consumer_inbox (workspace_id, consumer_name, event_id).
type WebhookProcessor struct {
	mu            sync.Mutex
	seenWebhooks  map[string]InboundWebhookResult
	seenInboxKeys map[string]struct{}
	effectCount   map[string]int
	audits        []AuditLogEntry
}

// NewWebhookProcessor creates a WebhookProcessor.
func NewWebhookProcessor() *WebhookProcessor {
	return &WebhookProcessor{
		seenWebhooks:  make(map[string]InboundWebhookResult),
		seenInboxKeys: make(map[string]struct{}),
		effectCount:   make(map[string]int),
	}
}

func webhookDedupKey(provider, idempotencyKey string) string {
	return strings.ToLower(strings.TrimSpace(provider)) + "::" + strings.TrimSpace(idempotencyKey)
}

// ProcessInboundWebhook processes an inbound webhook idempotently.
// If the same (provider, idempotency_key) or (workspace_id, consumer_name, event_id) has already been processed,
// handler is NOT invoked again and Deduplicated=true is returned.
func (p *WebhookProcessor) ProcessInboundWebhook(
	ctx context.Context,
	req InboundWebhookRequest,
	handler func(ctx context.Context, req InboundWebhookRequest) error,
) (InboundWebhookResult, error) {
	if !tenantdb.IsValidNonZeroUUID(req.WorkspaceID) || !tenantdb.IsValidNonZeroUUID(req.EventID) {
		return InboundWebhookResult{}, tenantdb.ErrInvalidTenantScope
	}
	if strings.TrimSpace(req.Provider) == "" || strings.TrimSpace(req.IdempotencyKey) == "" {
		return InboundWebhookResult{}, errors.New("outbox: provider and idempotency_key are required")
	}
	consumer := req.ConsumerName
	if consumer == "" {
		consumer = "inbound_webhook_" + strings.ToLower(req.Provider)
	}
	now := req.ReceivedAt
	if now.IsZero() {
		now = time.Now().UTC()
	}

	whKey := webhookDedupKey(req.Provider, req.IdempotencyKey)
	inKey := inboxKey(req.WorkspaceID, consumer, req.EventID)

	p.mu.Lock()
	if prev, exists := p.seenWebhooks[whKey]; exists {
		p.mu.Unlock()
		prev.Processed = false
		prev.Deduplicated = true
		return prev, nil
	}
	if _, exists := p.seenInboxKeys[inKey]; exists {
		p.mu.Unlock()
		return InboundWebhookResult{
			WebhookEventID:   req.WebhookEventID,
			EventID:          req.EventID,
			Processed:        false,
			Deduplicated:     true,
			ProcessingStatus: "processed",
		}, nil
	}
	// Reserve inside lock so concurrent duplicate webhook deliveries are serialized and deduplicated.
	defer p.mu.Unlock()

	if err := handler(ctx, req); err != nil {
		return InboundWebhookResult{
			WebhookEventID:   req.WebhookEventID,
			EventID:          req.EventID,
			Processed:        false,
			Deduplicated:     false,
			ProcessingStatus: "failed",
		}, err
	}

	res := InboundWebhookResult{
		WebhookEventID:   nonEmpty(req.WebhookEventID, req.EventID),
		EventID:          req.EventID,
		Processed:        true,
		Deduplicated:     false,
		ProcessingStatus: "processed",
	}
	p.seenWebhooks[whKey] = res
	p.seenInboxKeys[inKey] = struct{}{}
	p.effectCount[whKey]++
	p.audits = append(p.audits, AuditLogEntry{
		AuditEventID: req.EventID,
		WorkspaceID:  req.WorkspaceID,
		ActorType:    "system",
		Action:       "webhook.inbound.processed:" + req.Provider,
		ResourceType: "webhook_event",
		ResourceID:   res.WebhookEventID,
		Reason:       req.IdempotencyKey,
		CreatedAt:    now,
	})
	return res, nil
}

// EffectCount returns how many times a given (provider, idempotency_key) triggered a domain effect.
func (p *WebhookProcessor) EffectCount(provider, idempotencyKey string) int {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.effectCount[webhookDedupKey(provider, idempotencyKey)]
}

// =============================================================================
// Outbound S24 Webhook Subscription & Delivery
// =============================================================================

// WebhookSubscription models a row in api_webhook_subscriptions (§18.4B).
type WebhookSubscription struct {
	SubscriptionID          string
	WorkspaceID             string
	TargetURL               string
	EventTypes              []string
	SigningSecret           string
	Status                  string
	ConsecutiveFailureCount int
	LastDeliveryAt          *time.Time
	LastError               string
}

// SanitizeOutboundWebhookPayload strips internal cost/operator fields and any forbidden credential keys
// before delivering an outbound S24 webhook payload to an external customer endpoint.
func SanitizeOutboundWebhookPayload(eventType string, rawPayload json.RawMessage) (json.RawMessage, error) {
	if _, ok := EligibleS24OutboundEvents[eventType]; !ok {
		return nil, fmt.Errorf("%w: %s", ErrIneligibleOutboundWebhookEvent, eventType)
	}
	if err := rejectForbiddenSecretKeys(rawPayload); err != nil {
		return nil, err
	}
	var decoded any
	if err := json.Unmarshal(rawPayload, &decoded); err != nil {
		return nil, err
	}
	cleaned := stripInternalFields(decoded)
	out, err := json.Marshal(cleaned)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func stripInternalFields(v any) any {
	switch val := v.(type) {
	case map[string]any:
		res := make(map[string]any, len(val))
		for k, child := range val {
			norm := strings.ToLower(strings.TrimSpace(k))
			if _, strip := strippedInternalOutboundKeys[norm]; strip {
				continue
			}
			if _, secret := forbiddenSecretKeys[norm]; secret {
				continue
			}
			res[k] = stripInternalFields(child)
		}
		return res
	case []any:
		res := make([]any, len(val))
		for i, item := range val {
			res[i] = stripInternalFields(item)
		}
		return res
	default:
		return val
	}
}

// SignOutboundWebhookPayload computes the canonical S24 HMAC-SHA256 signature header value (`sha256=<hex>`).
func SignOutboundWebhookPayload(secret string, timestamp time.Time, body []byte) string {
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write([]byte(fmt.Sprintf("%d.", timestamp.Unix())))
	mac.Write(body)
	return "sha256=" + hex.EncodeToString(mac.Sum(nil))
}

// RecordSubscriptionDeliveryOutcome updates consecutive failure counters and auto-suspends after 100 consecutive failures (RULE-S24-05).
func RecordSubscriptionDeliveryOutcome(sub *WebhookSubscription, succeeded bool, errMsg string, now time.Time) (autoSuspended bool) {
	if sub == nil {
		return false
	}
	if succeeded {
		sub.ConsecutiveFailureCount = 0
		sub.LastError = ""
		ts := now
		sub.LastDeliveryAt = &ts
		return false
	}
	sub.ConsecutiveFailureCount++
	sub.LastError = errMsg
	if sub.ConsecutiveFailureCount >= MaxWebhookConsecutiveFailuresBeforeSuspend && sub.Status == "active" {
		sub.Status = "suspended"
		return true
	}
	return false
}

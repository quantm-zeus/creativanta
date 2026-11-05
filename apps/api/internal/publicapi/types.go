package publicapi

import (
	"crypto/rand"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

func newUUID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// Standard Tier Limits per RULE-S24-001, RULE-S24-002, RULE-S24-003, pricing_and_credits.md
const (
	StarterTierKeyCap    = 3
	ProTierKeyCap        = 10
	BusinessTierKeyCap   = 25
	EnterpriseTierKeyCap = 100

	StarterMonthlyQuota    int64 = 10000
	ProMonthlyQuota        int64 = 100000
	BusinessMonthlyQuota   int64 = 1000000
	EnterpriseMonthlyQuota int64 = 10000000

	DefaultReadRateLimitRPM  = 100
	DefaultWriteRateLimitRPM = 30
	SecondaryIPRateLimitRPM  = 1000

	DefaultKeyExpiryDays = 90
	RotationGracePeriod  = 24 * time.Hour

	MaxWebhookConsecutiveFailuresBeforeSuspend = 100
)

var (
	ErrKeyNotFound               = errors.New("publicapi: api key not found")
	ErrKeyExpired                = errors.New("publicapi: api key has expired")
	ErrKeyRevoked                = errors.New("publicapi: api key has been revoked")
	ErrKeySuspended              = errors.New("publicapi: api key is suspended")
	ErrTierKeyCapExceeded        = errors.New("publicapi: workspace has reached maximum api key capacity for current tier")
	ErrTierModeViolation         = errors.New("publicapi: starter tier is restricted to read-only API access mode")
	ErrReadOnlyMutationForbidden = errors.New("publicapi: read-only API key cannot execute mutating operation")
	ErrScopeUnauthorized         = errors.New("publicapi: insufficient scope for requested resource")
	ErrRateLimitExceeded         = errors.New("publicapi: rate limit exceeded")
	ErrMonthlyQuotaExceeded      = errors.New("publicapi: monthly api request quota exceeded")
	ErrInvalidSubscription       = errors.New("publicapi: invalid webhook subscription")
	ErrSubscriptionSuspended     = errors.New("publicapi: webhook subscription is suspended")
	ErrIneligibleWebhookEvent    = errors.New("publicapi: event type is not eligible for S24 outbound delivery")
	ErrInvalidWebhookSignature   = errors.New("publicapi: invalid webhook signature")
	ErrInvalidScope              = errors.New("publicapi: invalid or unrecognized API key scope")
	ErrWebhookTargetSSRFBlocked  = errors.New("publicapi: webhook target URL blocked by SSRF policy")
	ErrWebhookRedirectBlocked    = errors.New("publicapi: outbound webhook redirects are forbidden")
)

// TierCaps returns the maximum allowed active/rotating keys for a tier.
func TierCaps(tier string) int {
	switch strings.ToLower(strings.TrimSpace(tier)) {
	case "pro":
		return ProTierKeyCap
	case "business":
		return BusinessTierKeyCap
	case "enterprise":
		return EnterpriseTierKeyCap
	default:
		return StarterTierKeyCap
	}
}

// TierMonthlyQuota returns the monthly request quota for a tier.
func TierMonthlyQuota(tier string) int64 {
	switch strings.ToLower(strings.TrimSpace(tier)) {
	case "pro":
		return ProMonthlyQuota
	case "business":
		return BusinessMonthlyQuota
	case "enterprise":
		return EnterpriseMonthlyQuota
	default:
		return StarterMonthlyQuota
	}
}

// TierAccessMode returns whether the tier allows write mutations ("read-only", "read/write", "full").
func TierAccessMode(tier string) string {
	switch strings.ToLower(strings.TrimSpace(tier)) {
	case "pro":
		return "read/write"
	case "business", "enterprise":
		return "full"
	default:
		return "read-only"
	}
}

// CanonicalS24WebhookEventMap maps internal domain events to external S24 webhook names (§21.2).
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

// EligibleOutboundEvents contains the 13 canonical S24 outbound webhook event names.
var EligibleOutboundEvents = map[string]struct{}{
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
}

// IsEligibleWebhookEvent checks if an event (internal or external name) is valid for outbound S24 delivery.
func IsEligibleWebhookEvent(event string) (externalName string, ok bool) {
	norm := strings.TrimSpace(event)
	if _, exists := EligibleOutboundEvents[norm]; exists {
		return norm, true
	}
	if ext, exists := CanonicalS24WebhookEventMap[norm]; exists {
		return ext, true
	}
	return "", false
}

// Forbidden payload fields stripped before outbound webhook delivery.
var strippedInternalOutboundKeys = map[string]struct{}{
	"actual_cost_usd":      {},
	"platform_margin":      {},
	"internal_notes":       {},
	"is_internal_note":     {},
	"operator_explanation": {},
	"cost_breakdown":       {},
	"provider_raw_secret":  {},
	"db_conn_str":          {},
	"signing_secret":       {},
}

// APIKeyEntity represents a persisted API key in `api_keys` (§18.4).
type APIKeyEntity struct {
	APIKeyID            string
	WorkspaceID         string
	KeyPrefix           string
	KeyHash             string
	Name                string
	Scopes              []string
	Status              string // active, rotating, suspended, revoked, expired
	LogicalKeyID        string
	ReplacedByKeyID     string
	RotationGraceEndsAt *time.Time
	LastUsedAt          *time.Time
	RequestCount        int64
	RateLimitOverride   int
	ExpiresAt           time.Time
	CreatedBy           string
	SuspendedReason     string
	CreatedAt           time.Time
	UpdatedAt           time.Time
}

// DailyUsageEntity represents daily aggregated usage in `api_usage_daily` (§18.4A).
type DailyUsageEntity struct {
	UsageID                   string
	WorkspaceID               string
	APIKeyID                  string
	UsageDate                 string // YYYY-MM-DD
	ReadRequests              int
	WriteRequests             int
	Error4xxCount             int
	Error5xxCount             int
	OutboundWebhookDeliveries int
	BillableAICredits         float64
	CreatedAt                 time.Time
	UpdatedAt                 time.Time
}

// WebhookSubscriptionEntity represents `api_webhook_subscriptions` (§18.4B).
type WebhookSubscriptionEntity struct {
	SubscriptionID          string
	WorkspaceID             string
	APIKeyID                string
	TargetURL               string
	EventTypes              []string
	SigningSecret           string
	SigningSecretHash       string
	Status                  string // active, suspended, revoked
	ConsecutiveFailureCount int
	LastDeliveryAt          *time.Time
	LastError               string
	CreatedBy               string
	CreatedAt               time.Time
	UpdatedAt               time.Time
	DeletedAt               *time.Time
}

// WebhookDeliveryEntity represents a delivery attempt in `api_webhook_deliveries`.
type WebhookDeliveryEntity struct {
	DeliveryID            string
	WorkspaceID           string
	WebhookSubscriptionID string
	WebhookEventID        string
	EventType             string
	TargetURL             string
	StatusCode            int
	AttemptNumber         int
	DeliveryStatus        string // pending, delivered, retrying, failed, replayed
	ErrorMessage          string
	RequestSignature      string
	ResponseBody          string
	IsReplay              bool
	DeliveredAt           time.Time
	CreatedAt             time.Time
	UpdatedAt             time.Time
}

// WebhookPayloadSanitizer cleans sensitive operator and cost fields from outbound payloads.
func WebhookPayloadSanitizer(raw []byte) ([]byte, error) {
	var decoded any
	if err := json.Unmarshal(raw, &decoded); err != nil {
		return nil, err
	}
	cleaned := stripPayload(decoded)
	return json.Marshal(cleaned)
}

func stripPayload(v any) any {
	switch val := v.(type) {
	case map[string]any:
		res := make(map[string]any, len(val))
		for k, child := range val {
			norm := strings.ToLower(strings.TrimSpace(k))
			if _, strip := strippedInternalOutboundKeys[norm]; strip {
				continue
			}
			res[k] = stripPayload(child)
		}
		return res
	case []any:
		res := make([]any, len(val))
		for i, item := range val {
			res[i] = stripPayload(item)
		}
		return res
	default:
		return val
	}
}

var canonicalScopeNormalization = map[string]string{
	"read:orders":      "read:orders",
	"orders:read":      "read:orders",
	"order:read":       "read:orders",
	"refund:read":      "read:orders",
	"write:orders":     "write:orders",
	"orders:write":     "write:orders",
	"orders:manage":    "write:orders",
	"order:manage":     "write:orders",
	"refund:manage":    "write:orders",
	"read:products":    "read:products",
	"products:read":    "read:products",
	"product:read":     "read:products",
	"write:products":   "write:products",
	"products:write":   "write:products",
	"products:manage":  "write:products",
	"product:manage":   "write:products",
	"read:inventory":   "read:inventory",
	"inventory:read":   "read:inventory",
	"write:inventory":  "write:inventory",
	"inventory:write":  "write:inventory",
	"inventory:manage": "write:inventory",
	"read:content":     "read:content",
	"content:read":     "read:content",
	"script:read":      "read:content",
	"write:content":    "write:content",
	"content:write":    "write:content",
	"content:manage":   "write:content",
	"script:edit":      "write:content",
	"read:publish":     "read:publish",
	"publish:read":     "read:publish",
	"write:publish":    "write:publish",
	"publish:write":    "write:publish",
	"publish:execute":  "write:publish",
	"publish:schedule": "write:publish",
	"read:analytics":   "read:analytics",
	"analytics:read":   "read:analytics",
	"read:workflows":   "read:workflows",
	"workflows:read":   "read:workflows",
	"workflow:read":    "read:workflows",
	"write:workflows":  "write:workflows",
	"workflows:write":  "write:workflows",
	"workflow:manage":  "write:workflows",
	"workflow:execute": "write:workflows",
	"read:agents":      "read:agents",
	"agents:read":      "read:agents",
	"agent:read":       "read:agents",
	"write:agents":     "write:agents",
	"agents:write":     "write:agents",
	"agent:manage":     "write:agents",
	"agent:execute":    "write:agents",
	"read:webhooks":    "read:webhooks",
	"webhooks:read":    "read:webhooks",
	"write:webhooks":   "write:webhooks",
	"webhooks:write":   "write:webhooks",
	"read:all":         "read:all",
	"all:read":         "read:all",
	"write:all":        "write:all",
	"all:write":        "write:all",
	"*:*":              "*:*",
	"*":                "*:*",
}

// NormalizeScope maps a scope token to its canonical representation.
func NormalizeScope(scope string) (string, bool) {
	norm := strings.ToLower(strings.TrimSpace(scope))
	if norm == "" {
		return "", false
	}
	canonical, ok := canonicalScopeNormalization[norm]
	return canonical, ok
}

// ValidateScopes verifies that a scope list is non-empty and every scope is a recognized canonical scope.
func ValidateScopes(scopes []string) error {
	if len(scopes) == 0 {
		return fmt.Errorf("%w: at least one scope is required", ErrInvalidScope)
	}
	for _, s := range scopes {
		if _, ok := NormalizeScope(s); !ok {
			return fmt.Errorf("%w: %q", ErrInvalidScope, s)
		}
	}
	return nil
}

// HasScope checks if a scope list satisfies a required scope (supports wildcard `write:all`, `read:all`).
func HasScope(scopes []string, requiredScope string) bool {
	reqCanonical, reqOK := NormalizeScope(requiredScope)
	if !reqOK {
		reqCanonical = strings.ToLower(strings.TrimSpace(requiredScope))
	}
	if reqCanonical == "" {
		return false
	}
	for _, s := range scopes {
		canon, ok := NormalizeScope(s)
		if !ok {
			continue
		}
		if canon == reqCanonical || canon == "*:*" {
			return true
		}
		if strings.HasPrefix(reqCanonical, "read:") && canon == "read:all" {
			return true
		}
		if strings.HasPrefix(reqCanonical, "write:") && canon == "write:all" {
			return true
		}
	}
	return false
}

// IsReadOnlyScopes returns true if the scope list contains no mutating write permissions.
func IsReadOnlyScopes(scopes []string) bool {
	if len(scopes) == 0 {
		return false
	}
	for _, s := range scopes {
		canon, ok := NormalizeScope(s)
		if !ok {
			lower := strings.ToLower(strings.TrimSpace(s))
			if strings.HasPrefix(lower, "write:") || strings.Contains(lower, "manage") ||
				strings.Contains(lower, "delete") || strings.Contains(lower, "edit") ||
				strings.Contains(lower, "execute") || lower == "*:*" || lower == "*" {
				return false
			}
			continue
		}
		if strings.HasPrefix(canon, "write:") || canon == "*:*" {
			return false
		}
	}
	return true
}

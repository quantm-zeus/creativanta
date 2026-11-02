// Package serviceidentity implements the S24 Public API & Developer Platform service identity,
// API key lifecycle, workspace scoping, tier-gated permissions, rate limiting, and usage metering.
//
// Canonical contract:
//   - docs/02_features/platform/public_api.md (S24, RULE-S24-001 through RULE-S24-006, EC-S24-001 through EC-S24-003)
//   - docs/04_contracts/database_schema.md (§18.4 api_keys, §18.5 api_usage_daily)
//   - docs/01_business/pricing_and_credits.md (API key tier caps and rate limits)
//   - docs/04_contracts/rbac_permission_matrix.md (api_key:manage -> Admin+)
package serviceidentity

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Status represents the API key lifecycle status.
type Status string

const (
	StatusActive    Status = "active"
	StatusRotating  Status = "rotating"
	StatusSuspended Status = "suspended"
	StatusRevoked   Status = "revoked"
	StatusExpired   Status = "expired"
)

// Tier represents the workspace subscription tier.
type Tier string

const (
	TierStarter    Tier = "starter"
	TierPro        Tier = "pro"
	TierBusiness   Tier = "business"
	TierEnterprise Tier = "enterprise"
)

// Standard scopes for S24 API keys (§5.2).
const (
	ScopeProductsRead   = "products:read"
	ScopeProductsManage = "products:manage"
	ScopeOrdersRead     = "orders:read"
	ScopeOrdersManage   = "orders:manage"
	ScopeContentRead    = "content:read"
	ScopeContentManage  = "content:manage"
	ScopeAnalyticsRead  = "analytics:read"
)

// Standard rate limits per RULE-S24-002:
// 100 req/min read, 30 req/min write, 1000 req/min secondary IP.
const (
	DefaultRateLimitReadPerMin  = 100
	DefaultRateLimitWritePerMin = 30
	DefaultRateLimitIPPerMin    = 1000
	KeyRotationGracePeriod      = 24 * time.Hour
	KeyAutoExpiryDuration       = 90 * 24 * time.Hour
	KeyExpiryWarningThreshold   = 75 * 24 * time.Hour
)

var (
	ErrKeyNotFound        = errors.New("serviceidentity: api key not found")
	ErrKeyRevoked         = errors.New("serviceidentity: api key has been revoked")
	ErrKeySuspended       = errors.New("serviceidentity: api key is suspended")
	ErrKeyExpired         = errors.New("serviceidentity: api key has expired")
	ErrKeyRotated         = errors.New("serviceidentity: this key has been rotated; use the new key")
	ErrTierCapExceeded    = errors.New("serviceidentity: active api key limit exceeded for subscription tier")
	ErrScopeNotPermitted  = errors.New("serviceidentity: requested scope exceeds subscription tier access mode")
	ErrRateLimitExceeded  = errors.New("serviceidentity: rate limit exceeded")
	ErrInvalidKeyFormat   = errors.New("serviceidentity: invalid api key format")
	ErrInvalidWorkspaceID = errors.New("serviceidentity: invalid workspace id")
	ErrInvalidScopes      = errors.New("serviceidentity: invalid or empty scopes")
	ErrInvalidName        = errors.New("serviceidentity: key name must not be empty")
)

// TierCap returns the maximum number of active/rotating API keys allowed for a tier (RULE-S24-001).
func TierCap(tier Tier) int {
	switch tier {
	case TierStarter:
		return 3
	case TierPro:
		return 10
	case TierBusiness:
		return 25
	case TierEnterprise:
		return 100
	default:
		return 3
	}
}

// IsScopePermittedForTier checks if a scope is permitted under the tier's access mode (RULE-S24-003).
// Starter is read-only; Pro is read/write; Business/Enterprise are full.
func IsScopePermittedForTier(tier Tier, scope string) bool {
	if tier == TierStarter {
		// Starter tier only permits read-only scopes.
		return strings.HasSuffix(scope, ":read")
	}
	// Pro, Business, Enterprise permit all standard scopes.
	return true
}

// APIKey represents a database row in api_keys (§18.4).
type APIKey struct {
	APIKeyID            string
	WorkspaceID         string
	KeyPrefix           string
	KeyHash             string
	Name                string
	Scopes              []string
	Status              Status
	LogicalKeyID        string
	ReplacedByKeyID     string
	RotationGraceEndsAt *time.Time
	LastUsedAt          *time.Time
	RequestCount        int64
	RateLimitOverride   *int
	ExpiresAt           time.Time
	CreatedBy           string
	SuspendedReason     string
	CreatedAt           time.Time
	UpdatedAt           time.Time
}

// APIKeyCreated is returned ONLY when an API key is first generated.
// The PlainKey is displayed exactly once and never persisted.
type APIKeyCreated struct {
	APIKeyID    string    `json:"api_key_id"`
	WorkspaceID string    `json:"workspace_id"`
	KeyPrefix   string    `json:"key_prefix"`
	PlainKey    string    `json:"plain_key"` // Displayed ONCE, never saved
	Name        string    `json:"name"`
	Scopes      []string  `json:"scopes"`
	Status      Status    `json:"status"`
	ExpiresAt   time.Time `json:"expires_at"`
	CreatedAt   time.Time `json:"created_at"`
}

// APIKeyProjection represents the safe public projection of an API key (never contains KeyHash or PlainKey).
type APIKeyProjection struct {
	APIKeyID            string     `json:"api_key_id"`
	WorkspaceID         string     `json:"workspace_id"`
	KeyPrefix           string     `json:"key_prefix"`
	Name                string     `json:"name"`
	Scopes              []string   `json:"scopes"`
	Status              Status     `json:"status"`
	LogicalKeyID        string     `json:"logical_key_id,omitempty"`
	ReplacedByKeyID     string     `json:"replaced_by_key_id,omitempty"`
	RotationGraceEndsAt *time.Time `json:"rotation_grace_ends_at,omitempty"`
	LastUsedAt          *time.Time `json:"last_used_at,omitempty"`
	RequestCount        int64      `json:"request_count"`
	ExpiresAt           time.Time  `json:"expires_at"`
	DaysUntilExpiration int        `json:"days_until_expiration"`
	ExpiringSoon        bool       `json:"expiring_soon"` // Warning at 75 days (RULE-S24-004)
	CreatedAt           time.Time  `json:"created_at"`
}

// Project converts an APIKey to its safe projection without secret hash.
func (k *APIKey) Project(now time.Time) APIKeyProjection {
	scopes := make([]string, len(k.Scopes))
	copy(scopes, k.Scopes)

	daysUntil := int(k.ExpiresAt.Sub(now).Hours() / 24)
	expiringSoon := daysUntil <= 15 && k.Status == StatusActive

	return APIKeyProjection{
		APIKeyID:            k.APIKeyID,
		WorkspaceID:         k.WorkspaceID,
		KeyPrefix:           k.KeyPrefix,
		Name:                k.Name,
		Scopes:              scopes,
		Status:              k.Status,
		LogicalKeyID:        k.LogicalKeyID,
		ReplacedByKeyID:     k.ReplacedByKeyID,
		RotationGraceEndsAt: k.RotationGraceEndsAt,
		LastUsedAt:          k.LastUsedAt,
		RequestCount:        k.RequestCount,
		ExpiresAt:           k.ExpiresAt,
		DaysUntilExpiration: daysUntil,
		ExpiringSoon:        expiringSoon,
		CreatedAt:           k.CreatedAt,
	}
}

// UsageMetrics holds daily aggregated API usage (§18.5 api_usage_daily).
type UsageMetrics struct {
	WorkspaceID       string `json:"workspace_id"`
	APIKeyID          string `json:"api_key_id"`
	Date              string `json:"date"` // YYYY-MM-DD
	RequestCount      int64  `json:"request_count"`
	ReadCount         int64  `json:"read_count"`
	WriteCount        int64  `json:"write_count"`
	ErrorCount        int64  `json:"error_count"`
	BillableAICredits int    `json:"billable_ai_credits"`
}

// ServiceIdentityContext represents an authenticated service identity session.
type ServiceIdentityContext struct {
	WorkspaceID       string
	APIKeyID          string
	LogicalKeyID      string
	KeyPrefix         string
	Scopes            []string
	Tier              Tier
	IsServiceIdentity bool
}

// HasScope checks if the authenticated service identity has the requested scope.
func (c *ServiceIdentityContext) HasScope(requiredScope string) bool {
	for _, s := range c.Scopes {
		if s == requiredScope || s == "*" {
			return true
		}
		// Prefix match e.g. "products:*" matches "products:read"
		if strings.HasSuffix(s, ":*") && strings.HasPrefix(requiredScope, strings.TrimSuffix(s, "*")) {
			return true
		}
	}
	return false
}

// RateLimitResult contains the sliding-window rate limit check headers and status.
type RateLimitResult struct {
	Allowed           bool
	Limit             int
	Remaining         int
	ResetTimestamp    int64 // Unix epoch seconds
	RetryAfterSeconds int
}

func (r RateLimitResult) Error() string {
	return fmt.Sprintf("%s: retry after %d seconds", ErrRateLimitExceeded.Error(), r.RetryAfterSeconds)
}

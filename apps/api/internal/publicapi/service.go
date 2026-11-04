package publicapi

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"strings"
	"time"
)

// WorkspaceTierProvider abstracts querying a workspace's current subscription tier.
type WorkspaceTierProvider interface {
	GetWorkspaceTier(ctx context.Context, workspaceID string) (string, error)
}

// FixedTierProvider returns a configured tier or defaults to "starter".
type FixedTierProvider struct {
	tiers map[string]string
}

func NewFixedTierProvider() *FixedTierProvider {
	return &FixedTierProvider{tiers: make(map[string]string)}
}

func (p *FixedTierProvider) SetTier(workspaceID, tier string) {
	p.tiers[workspaceID] = strings.ToLower(strings.TrimSpace(tier))
}

func (p *FixedTierProvider) GetWorkspaceTier(_ context.Context, workspaceID string) (string, error) {
	if tier, ok := p.tiers[workspaceID]; ok && tier != "" {
		return tier, nil
	}
	return "starter", nil
}

// Service manages Public API keys, rate limits, rotation, and webhook subscriptions.
type Service struct {
	store        Store
	tierProvider WorkspaceTierProvider
}

// NewService creates a Public API Service.
func NewService(store Store, tierProvider WorkspaceTierProvider) *Service {
	if tierProvider == nil {
		tierProvider = NewFixedTierProvider()
	}
	return &Service{
		store:        store,
		tierProvider: tierProvider,
	}
}

// generateSecureKey generates a high-entropy API key with a 10-char prefix (e.g. "ca_live_9f...").
func generateSecureKey() (rawKey string, prefix string, hash string, err error) {
	bytes := make([]byte, 24)
	if _, err := rand.Read(bytes); err != nil {
		return "", "", "", fmt.Errorf("publicapi: failed to generate random key: %w", err)
	}
	hexPart := hex.EncodeToString(bytes)
	rawKey = "ca_live_" + hexPart
	prefix = rawKey[:10]
	hash = HashKey(rawKey)
	return rawKey, prefix, hash, nil
}

// generateSigningSecret generates a secure webhook signing secret (`whsec_<hex>`).
func generateSigningSecret() (string, error) {
	bytes := make([]byte, 24)
	if _, err := rand.Read(bytes); err != nil {
		return "", fmt.Errorf("publicapi: failed to generate signing secret: %w", err)
	}
	return "whsec_" + hex.EncodeToString(bytes), nil
}

// CreateKey creates a new API key scoped to a workspace.
func (s *Service) CreateKey(ctx context.Context, workspaceID, name string, scopes []string, rateLimitOverride int, expiryDays int, createdBy string) (APIKeyEntity, string, error) {
	tier, err := s.tierProvider.GetWorkspaceTier(ctx, workspaceID)
	if err != nil {
		return APIKeyEntity{}, "", err
	}

	cap := TierCaps(tier)
	activeCount, err := s.store.CountActiveKeys(ctx, workspaceID)
	if err != nil {
		return APIKeyEntity{}, "", err
	}
	if activeCount >= cap {
		return APIKeyEntity{}, "", fmt.Errorf("%w: current tier %q allows max %d keys", ErrTierKeyCapExceeded, tier, cap)
	}

	// Starter tier is strictly read-only mode per RULE-S24-003.
	if strings.ToLower(tier) == "starter" && !IsReadOnlyScopes(scopes) {
		return APIKeyEntity{}, "", fmt.Errorf("%w: mutating scopes requested on %s tier", ErrTierModeViolation, tier)
	}

	if expiryDays <= 0 {
		expiryDays = DefaultKeyExpiryDays
	}

	rawKey, prefix, keyHash, err := generateSecureKey()
	if err != nil {
		return APIKeyEntity{}, "", err
	}

	now := time.Now().UTC()
	keyID := newUUID()
	entity := APIKeyEntity{
		APIKeyID:          keyID,
		WorkspaceID:       workspaceID,
		KeyPrefix:         prefix,
		KeyHash:           keyHash,
		Name:              strings.TrimSpace(name),
		Scopes:            scopes,
		Status:            "active",
		LogicalKeyID:      keyID,
		RateLimitOverride: rateLimitOverride,
		ExpiresAt:         now.AddDate(0, 0, expiryDays),
		CreatedBy:         createdBy,
		CreatedAt:         now,
		UpdatedAt:         now,
	}

	created, err := s.store.CreateAPIKey(ctx, entity)
	if err != nil {
		return APIKeyEntity{}, "", err
	}
	return created, rawKey, nil
}

// ListKeys returns all keys for a workspace.
func (s *Service) ListKeys(ctx context.Context, workspaceID string, statusFilter string) ([]APIKeyEntity, error) {
	return s.store.ListAPIKeys(ctx, workspaceID, statusFilter)
}

// RevokeKey immediately revokes an API key per §3.1.
func (s *Service) RevokeKey(ctx context.Context, workspaceID, apiKeyID, reason string) (APIKeyEntity, error) {
	key, err := s.store.GetAPIKey(ctx, workspaceID, apiKeyID)
	if err != nil {
		return APIKeyEntity{}, err
	}
	key.Status = "revoked"
	key.SuspendedReason = strings.TrimSpace(reason)
	key.UpdatedAt = time.Now().UTC()

	if err := s.store.UpdateAPIKey(ctx, key); err != nil {
		return APIKeyEntity{}, err
	}
	return key, nil
}

// RotateKey initiates key rotation with a 24-hour grace period per RULE-S24-004 & EC-S24-001.
func (s *Service) RotateKey(ctx context.Context, workspaceID, apiKeyID string) (oldKey APIKeyEntity, newKey APIKeyEntity, newRawKey string, graceEnds time.Time, err error) {
	prev, err := s.store.GetAPIKey(ctx, workspaceID, apiKeyID)
	if err != nil {
		return APIKeyEntity{}, APIKeyEntity{}, "", time.Time{}, err
	}
	if prev.Status == "revoked" {
		return APIKeyEntity{}, APIKeyEntity{}, "", time.Time{}, ErrKeyRevoked
	}

	rawKey, prefix, keyHash, err := generateSecureKey()
	if err != nil {
		return APIKeyEntity{}, APIKeyEntity{}, "", time.Time{}, err
	}

	now := time.Now().UTC()
	grace := now.Add(RotationGracePeriod)
	newKeyID := newUUID()

	newEntity := APIKeyEntity{
		APIKeyID:          newKeyID,
		WorkspaceID:       workspaceID,
		KeyPrefix:         prefix,
		KeyHash:           keyHash,
		Name:              prev.Name + " (Rotated)",
		Scopes:            prev.Scopes,
		Status:            "active",
		LogicalKeyID:      prev.LogicalKeyID, // Same logical key for continuous metering
		RateLimitOverride: prev.RateLimitOverride,
		ExpiresAt:         now.AddDate(0, 0, DefaultKeyExpiryDays),
		CreatedBy:         prev.CreatedBy,
		CreatedAt:         now,
		UpdatedAt:         now,
	}

	createdNew, err := s.store.CreateAPIKey(ctx, newEntity)
	if err != nil {
		return APIKeyEntity{}, APIKeyEntity{}, "", time.Time{}, err
	}

	// Update old key to 'rotating' with 24h grace window and link replacement.
	prev.Status = "rotating"
	prev.ReplacedByKeyID = createdNew.APIKeyID
	prev.RotationGraceEndsAt = &grace
	prev.UpdatedAt = now

	if err := s.store.UpdateAPIKey(ctx, prev); err != nil {
		return APIKeyEntity{}, APIKeyEntity{}, "", time.Time{}, err
	}

	return prev, createdNew, rawKey, grace, nil
}

// AuthenticateKey verifies a raw API key token, checking expiration, revocation, and 24h rotation grace window.
func (s *Service) AuthenticateKey(ctx context.Context, rawKey string) (APIKeyEntity, error) {
	if strings.TrimSpace(rawKey) == "" {
		return APIKeyEntity{}, ErrKeyNotFound
	}
	hash := HashKey(strings.TrimSpace(rawKey))
	key, err := s.store.GetAPIKeyByHash(ctx, hash)
	if err != nil {
		return APIKeyEntity{}, ErrKeyNotFound
	}

	now := time.Now().UTC()

	switch key.Status {
	case "revoked":
		return APIKeyEntity{}, ErrKeyRevoked
	case "suspended":
		return APIKeyEntity{}, ErrKeySuspended
	case "expired":
		return APIKeyEntity{}, ErrKeyExpired
	case "rotating":
		if key.RotationGraceEndsAt != nil && now.After(*key.RotationGraceEndsAt) {
			// 24h grace window has expired per EC-S24-001.
			key.Status = "expired"
			_ = s.store.UpdateAPIKey(ctx, key)
			return APIKeyEntity{}, fmt.Errorf("%w: key has been rotated and 24h grace period ended; use new key", ErrKeyExpired)
		}
		// Still inside grace window: both keys valid!
		return key, nil
	case "active":
		if !key.ExpiresAt.IsZero() && now.After(key.ExpiresAt) {
			key.Status = "expired"
			_ = s.store.UpdateAPIKey(ctx, key)
			return APIKeyEntity{}, ErrKeyExpired
		}
		return key, nil
	default:
		return APIKeyEntity{}, ErrKeyNotFound
	}
}

// UpdateScopes modifies scopes for an existing key within tier constraints.
func (s *Service) UpdateScopes(ctx context.Context, workspaceID, apiKeyID string, newScopes []string) (APIKeyEntity, error) {
	key, err := s.store.GetAPIKey(ctx, workspaceID, apiKeyID)
	if err != nil {
		return APIKeyEntity{}, err
	}
	tier, err := s.tierProvider.GetWorkspaceTier(ctx, workspaceID)
	if err != nil {
		return APIKeyEntity{}, err
	}
	if strings.ToLower(tier) == "starter" && !IsReadOnlyScopes(newScopes) {
		return APIKeyEntity{}, fmt.Errorf("%w: mutating scopes forbidden on starter tier", ErrTierModeViolation)
	}

	key.Scopes = newScopes
	key.UpdatedAt = time.Now().UTC()
	if err := s.store.UpdateAPIKey(ctx, key); err != nil {
		return APIKeyEntity{}, err
	}
	return key, nil
}

// GetUsage retrieves month-to-date usage and tier quotas for an API key.
func (s *Service) GetUsage(ctx context.Context, workspaceID, apiKeyID string) (monthRequests int64, quota int64, readRPM, writeRPM int, billableAICredits float64, err error) {
	key, err := s.store.GetAPIKey(ctx, workspaceID, apiKeyID)
	if err != nil {
		return 0, 0, 0, 0, 0, err
	}
	tier, err := s.tierProvider.GetWorkspaceTier(ctx, workspaceID)
	if err != nil {
		return 0, 0, 0, 0, 0, err
	}

	quota = TierMonthlyQuota(tier)
	now := time.Now().UTC()
	monthRequests, billableAICredits, err = s.store.GetCurrentMonthRequests(ctx, workspaceID, key.LogicalKeyID, now)
	if err != nil {
		return 0, 0, 0, 0, 0, err
	}

	readRPM = DefaultReadRateLimitRPM
	writeRPM = DefaultWriteRateLimitRPM
	if key.RateLimitOverride > 0 {
		readRPM = key.RateLimitOverride
		writeRPM = key.RateLimitOverride
	}

	return monthRequests, quota, readRPM, writeRPM, billableAICredits, nil
}

// GetUsageStats retrieves daily usage history.
func (s *Service) GetUsageStats(ctx context.Context, workspaceID, apiKeyID, startDate, endDate string) ([]DailyUsageEntity, error) {
	return s.store.GetUsageStats(ctx, workspaceID, apiKeyID, startDate, endDate)
}

// CreateWebhookSubscription registers an outbound webhook subscription with secret and event filtering.
func (s *Service) CreateWebhookSubscription(ctx context.Context, workspaceID, apiKeyID, targetURL string, eventTypes []string, createdBy string) (WebhookSubscriptionEntity, string, error) {
	if strings.TrimSpace(targetURL) == "" {
		return WebhookSubscriptionEntity{}, "", fmt.Errorf("%w: target_url is required", ErrInvalidSubscription)
	}
	if len(eventTypes) == 0 {
		return WebhookSubscriptionEntity{}, "", fmt.Errorf("%w: at least one event type is required", ErrInvalidSubscription)
	}

	var canonicalEvents []string
	for _, ev := range eventTypes {
		canonicalName, ok := IsEligibleWebhookEvent(ev)
		if !ok {
			return WebhookSubscriptionEntity{}, "", fmt.Errorf("%w: %s", ErrIneligibleWebhookEvent, ev)
		}
		canonicalEvents = append(canonicalEvents, canonicalName)
	}

	signingSecret, err := generateSigningSecret()
	if err != nil {
		return WebhookSubscriptionEntity{}, "", err
	}

	now := time.Now().UTC()
	subID := newUUID()
	entity := WebhookSubscriptionEntity{
		SubscriptionID:    subID,
		WorkspaceID:       workspaceID,
		APIKeyID:          apiKeyID,
		TargetURL:         targetURL,
		EventTypes:        canonicalEvents,
		SigningSecret:     signingSecret,
		SigningSecretHash: HashKey(signingSecret),
		Status:            "active",
		CreatedBy:         createdBy,
		CreatedAt:         now,
		UpdatedAt:         now,
	}

	created, err := s.store.CreateWebhookSubscription(ctx, entity)
	if err != nil {
		return WebhookSubscriptionEntity{}, "", err
	}
	return created, signingSecret, nil
}

// ListWebhookSubscriptions returns all subscriptions for a workspace.
func (s *Service) ListWebhookSubscriptions(ctx context.Context, workspaceID string) ([]WebhookSubscriptionEntity, error) {
	return s.store.ListWebhookSubscriptions(ctx, workspaceID)
}

// DeleteWebhookSubscription soft-deletes / revokes a subscription.
func (s *Service) DeleteWebhookSubscription(ctx context.Context, workspaceID, subscriptionID string) error {
	return s.store.DeleteWebhookSubscription(ctx, workspaceID, subscriptionID)
}

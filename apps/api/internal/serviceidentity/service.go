package serviceidentity

import (
	"context"
	"crypto/rand"
	"fmt"
	"strings"
	"time"
)

func randomUUIDv4() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// Clock abstracts time for deterministic testing.
type Clock func() time.Time

// Service provides API key management and service identity authentication.
type Service struct {
	store   Store
	limiter *RateLimiter
	clock   Clock
}

// NewService constructs a new ServiceIdentity service with the given store and rate limiter.
func NewService(store Store, limiter *RateLimiter, clock Clock) *Service {
	if clock == nil {
		clock = func() time.Time { return time.Now().UTC() }
	}
	if limiter == nil {
		limiter = NewRateLimiter()
	}
	return &Service{
		store:   store,
		limiter: limiter,
		clock:   clock,
	}
}

// CreateKeyRequest parameters for creating an API key.
type CreateKeyRequest struct {
	WorkspaceID string
	CreatedBy   string
	Tier        Tier
	Name        string
	Scopes      []string
	Live        bool
}

// CreateKey generates a new API key, validates tier caps and scopes, and persists it.
// RULE-S24-001: Tier caps (Starter=3, Pro=10, Business=25, Enterprise=custom).
// RULE-S24-003: Starter is read-only; Pro is read/write; Business is full.
// RULE-S24-004: Key rotation required every 90 days (expires_at = now + 90 days).
func (s *Service) CreateKey(ctx context.Context, req CreateKeyRequest) (*APIKeyCreated, error) {
	if strings.TrimSpace(req.WorkspaceID) == "" {
		return nil, ErrInvalidWorkspaceID
	}
	if strings.TrimSpace(req.Name) == "" {
		return nil, ErrInvalidName
	}
	if len(req.Scopes) == 0 {
		return nil, ErrInvalidScopes
	}

	// 1. Verify tier scope permissions (RULE-S24-003)
	for _, sc := range req.Scopes {
		if !IsScopePermittedForTier(req.Tier, sc) {
			return nil, fmt.Errorf("%w: scope %q not allowed for %s tier", ErrScopeNotPermitted, sc, req.Tier)
		}
	}

	// 2. Verify active key tier cap (RULE-S24-001)
	activeCount, err := s.store.CountActiveKeys(ctx, req.WorkspaceID)
	if err != nil {
		return nil, fmt.Errorf("serviceidentity: count active keys: %w", err)
	}
	capLimit := TierCap(req.Tier)
	if activeCount >= capLimit {
		return nil, fmt.Errorf("%w: %d active keys reached maximum cap of %d for %s tier",
			ErrTierCapExceeded, activeCount, capLimit, req.Tier)
	}

	// 3. Generate cryptographic key
	plainKey, prefix, keyHash, err := GenerateRawKey(req.Live)
	if err != nil {
		return nil, err
	}

	now := s.clock()
	apiKeyID := randomUUIDv4()
	expiresAt := now.Add(KeyAutoExpiryDuration) // 90 days per RULE-S24-004

	key := APIKey{
		APIKeyID:     apiKeyID,
		WorkspaceID:  req.WorkspaceID,
		KeyPrefix:    prefix,
		KeyHash:      keyHash,
		Name:         req.Name,
		Scopes:       req.Scopes,
		Status:       StatusActive,
		LogicalKeyID: apiKeyID, // Root key is its own logical key
		ExpiresAt:    expiresAt,
		CreatedBy:    req.CreatedBy,
		CreatedAt:    now,
		UpdatedAt:    now,
	}

	if err := s.store.InsertKey(ctx, key); err != nil {
		return nil, fmt.Errorf("serviceidentity: insert key: %w", err)
	}

	return &APIKeyCreated{
		APIKeyID:    apiKeyID,
		WorkspaceID: req.WorkspaceID,
		KeyPrefix:   prefix,
		PlainKey:    plainKey,
		Name:        req.Name,
		Scopes:      req.Scopes,
		Status:      StatusActive,
		ExpiresAt:   expiresAt,
		CreatedAt:   now,
	}, nil
}

// ListKeys returns safe projections of all API keys for a workspace.
func (s *Service) ListKeys(ctx context.Context, workspaceID string) ([]APIKeyProjection, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrInvalidWorkspaceID
	}
	keys, err := s.store.ListKeysByWorkspace(ctx, workspaceID)
	if err != nil {
		return nil, fmt.Errorf("serviceidentity: list keys: %w", err)
	}

	now := s.clock()
	projections := make([]APIKeyProjection, len(keys))
	for i, k := range keys {
		projections[i] = k.Project(now)
	}
	return projections, nil
}

// RevokeKey immediately revokes an API key (§3.1 step 6).
func (s *Service) RevokeKey(ctx context.Context, workspaceID, apiKeyID, reason string) error {
	now := s.clock()
	return s.store.UpdateKeyStatus(ctx, workspaceID, apiKeyID, StatusRevoked, reason, now)
}

// RotateKey performs zero-downtime key rotation (EC-S24-001).
// Generates a new key and gives the old key a 24-hour grace period during which BOTH keys are valid.
func (s *Service) RotateKey(ctx context.Context, workspaceID, apiKeyID string, live bool) (*APIKeyCreated, error) {
	oldKey, err := s.store.GetKeyByID(ctx, workspaceID, apiKeyID)
	if err != nil {
		return nil, err
	}
	if oldKey.Status != StatusActive && oldKey.Status != StatusRotating {
		return nil, fmt.Errorf("serviceidentity: cannot rotate key with status %q", oldKey.Status)
	}

	// Generate new key
	plainKey, prefix, keyHash, err := GenerateRawKey(live)
	if err != nil {
		return nil, err
	}

	now := s.clock()
	newKeyID := randomUUIDv4()
	graceEndsAt := now.Add(KeyRotationGracePeriod)
	expiresAt := now.Add(KeyAutoExpiryDuration)

	logicalKeyID := oldKey.LogicalKeyID
	if logicalKeyID == "" {
		logicalKeyID = oldKey.APIKeyID
	}

	newKey := APIKey{
		APIKeyID:     newKeyID,
		WorkspaceID:  workspaceID,
		KeyPrefix:    prefix,
		KeyHash:      keyHash,
		Name:         oldKey.Name + " (Rotated)",
		Scopes:       oldKey.Scopes,
		Status:       StatusActive,
		LogicalKeyID: logicalKeyID,
		ExpiresAt:    expiresAt,
		CreatedBy:    oldKey.CreatedBy,
		CreatedAt:    now,
		UpdatedAt:    now,
	}

	if err := s.store.RotateKey(ctx, apiKeyID, newKey, graceEndsAt); err != nil {
		return nil, fmt.Errorf("serviceidentity: rotate key: %w", err)
	}

	return &APIKeyCreated{
		APIKeyID:    newKeyID,
		WorkspaceID: workspaceID,
		KeyPrefix:   prefix,
		PlainKey:    plainKey,
		Name:        newKey.Name,
		Scopes:      newKey.Scopes,
		Status:      StatusActive,
		ExpiresAt:   expiresAt,
		CreatedAt:   now,
	}, nil
}

// UpdateScopes updates the permitted scopes on an active API key.
func (s *Service) UpdateScopes(ctx context.Context, workspaceID, apiKeyID string, tier Tier, newScopes []string) error {
	if len(newScopes) == 0 {
		return ErrInvalidScopes
	}
	for _, sc := range newScopes {
		if !IsScopePermittedForTier(tier, sc) {
			return fmt.Errorf("%w: scope %q not allowed for %s tier", ErrScopeNotPermitted, sc, tier)
		}
	}

	key, err := s.store.GetKeyByID(ctx, workspaceID, apiKeyID)
	if err != nil {
		return err
	}
	if key.Status != StatusActive {
		return fmt.Errorf("serviceidentity: cannot update scopes on %s key", key.Status)
	}

	key.Scopes = newScopes
	key.UpdatedAt = s.clock()
	// Persist by updating key
	return s.store.InsertKey(ctx, *key)
}

// Authenticate verifies an incoming API key Bearer token, enforces rate limits,
// and returns the authenticated ServiceIdentityContext.
// Handled Edge Cases:
//   - EC-S24-001: API key used during 24h rotation grace period (both accepted, old fails after 24h)
//   - EC-S24-002: Rate limit exceeded (returns ErrRateLimitExceeded with sliding window reset headers)
func (s *Service) Authenticate(ctx context.Context, plainKey string, isWrite bool, clientIP string) (*ServiceIdentityContext, *RateLimitResult, error) {
	if !ValidateKeyFormat(plainKey) {
		return nil, nil, ErrInvalidKeyFormat
	}

	keyHash := HashKey(plainKey)
	key, err := s.store.GetKeyByHash(ctx, keyHash)
	if err != nil {
		return nil, nil, ErrKeyNotFound
	}

	now := s.clock()

	// 1. Verify key status & rotation grace period (EC-S24-001)
	switch key.Status {
	case StatusRevoked:
		return nil, nil, ErrKeyRevoked
	case StatusSuspended:
		return nil, nil, ErrKeySuspended
	case StatusExpired:
		return nil, nil, ErrKeyExpired
	case StatusRotating:
		if key.RotationGraceEndsAt != nil && now.After(*key.RotationGraceEndsAt) {
			// Grace period expired: mark expired and reject with canonical message
			_ = s.store.UpdateKeyStatus(ctx, key.WorkspaceID, key.APIKeyID, StatusExpired, "rotation grace expired", now)
			return nil, nil, ErrKeyRotated
		}
	case StatusActive:
		// Check 90-day auto expiry (RULE-S24-004)
		if now.After(key.ExpiresAt) {
			_ = s.store.UpdateKeyStatus(ctx, key.WorkspaceID, key.APIKeyID, StatusExpired, "90-day expiration policy", now)
			return nil, nil, ErrKeyExpired
		}
	default:
		return nil, nil, ErrKeyNotFound
	}

	// 2. Sliding window rate limiting (RULE-S24-002, EC-S24-002)
	limit := DefaultRateLimitReadPerMin
	operationType := "read"
	if isWrite {
		limit = DefaultRateLimitWritePerMin
		operationType = "write"
	}
	if key.RateLimitOverride != nil && *key.RateLimitOverride > 0 {
		limit = *key.RateLimitOverride
	}

	rateKey := fmt.Sprintf("key:%s:%s", key.APIKeyID, operationType)
	rlRes := s.limiter.Check(rateKey, limit, now)

	// Also check secondary IP limit if clientIP is provided
	if clientIP != "" {
		ipRateKey := fmt.Sprintf("ip:%s", clientIP)
		ipRes := s.limiter.Check(ipRateKey, DefaultRateLimitIPPerMin, now)
		if !ipRes.Allowed {
			return nil, &ipRes, ErrRateLimitExceeded
		}
	}

	if !rlRes.Allowed {
		return nil, &rlRes, ErrRateLimitExceeded
	}

	// 3. Record usage into daily metering (RULE-S24-005)
	dateStr := now.Format("2006-01-02")
	_ = s.store.RecordUsage(ctx, key.WorkspaceID, key.APIKeyID, dateStr, isWrite, false, 0)

	logicalID := key.LogicalKeyID
	if logicalID == "" {
		logicalID = key.APIKeyID
	}

	return &ServiceIdentityContext{
		WorkspaceID:       key.WorkspaceID,
		APIKeyID:          key.APIKeyID,
		LogicalKeyID:      logicalID,
		KeyPrefix:         key.KeyPrefix,
		Scopes:            key.Scopes,
		IsServiceIdentity: true,
	}, &rlRes, nil
}

// GetUsage retrieves daily aggregated usage metrics for an API key.
func (s *Service) GetUsage(ctx context.Context, workspaceID, apiKeyID, startDate, endDate string) ([]UsageMetrics, error) {
	return s.store.GetUsage(ctx, workspaceID, apiKeyID, startDate, endDate)
}

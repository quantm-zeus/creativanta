package publicapi

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"strings"
	"sync"
	"time"
)

// Store defines persistence operations for API keys, usage, and webhooks.
type Store interface {
	CreateAPIKey(ctx context.Context, key APIKeyEntity) (APIKeyEntity, error)
	GetAPIKey(ctx context.Context, workspaceID, apiKeyID string) (APIKeyEntity, error)
	GetAPIKeyByHash(ctx context.Context, keyHash string) (APIKeyEntity, error)
	ListAPIKeys(ctx context.Context, workspaceID string, statusFilter string) ([]APIKeyEntity, error)
	UpdateAPIKey(ctx context.Context, key APIKeyEntity) error
	CountActiveKeys(ctx context.Context, workspaceID string) (int, error)

	RecordUsage(ctx context.Context, workspaceID, apiKeyID string, isWrite bool, statusCode int, billableAICredits float64, now time.Time) error
	GetUsageStats(ctx context.Context, workspaceID, apiKeyID string, startDate, endDate string) ([]DailyUsageEntity, error)
	GetCurrentMonthRequests(ctx context.Context, workspaceID, apiKeyID string, now time.Time) (int64, float64, error)

	CreateWebhookSubscription(ctx context.Context, sub WebhookSubscriptionEntity) (WebhookSubscriptionEntity, error)
	GetWebhookSubscription(ctx context.Context, workspaceID, subscriptionID string) (WebhookSubscriptionEntity, error)
	ListWebhookSubscriptions(ctx context.Context, workspaceID string) ([]WebhookSubscriptionEntity, error)
	UpdateWebhookSubscription(ctx context.Context, sub WebhookSubscriptionEntity) error
	DeleteWebhookSubscription(ctx context.Context, workspaceID, subscriptionID string) error

	RecordWebhookDelivery(ctx context.Context, delivery WebhookDeliveryEntity) (WebhookDeliveryEntity, error)
	GetWebhookDelivery(ctx context.Context, workspaceID, deliveryID string) (WebhookDeliveryEntity, error)
	ListWebhookDeliveries(ctx context.Context, workspaceID string, limit int) ([]WebhookDeliveryEntity, error)
}

// MemoryStore provides a thread-safe in-memory Store with full transaction/locking safety.
type MemoryStore struct {
	mu            sync.RWMutex
	keys          map[string]APIKeyEntity                 // key_id -> entity
	keysByHash    map[string]string                       // hash -> key_id
	usage         map[string]map[string]*DailyUsageEntity // key_id -> date -> entity
	subscriptions map[string]WebhookSubscriptionEntity    // sub_id -> entity
	deliveries    map[string]WebhookDeliveryEntity        // delivery_id -> entity
}

// NewMemoryStore creates a thread-safe MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		keys:          make(map[string]APIKeyEntity),
		keysByHash:    make(map[string]string),
		usage:         make(map[string]map[string]*DailyUsageEntity),
		subscriptions: make(map[string]WebhookSubscriptionEntity),
		deliveries:    make(map[string]WebhookDeliveryEntity),
	}
}

func HashKey(rawKey string) string {
	sum := sha256.Sum256([]byte(rawKey))
	return hex.EncodeToString(sum[:])
}

func (s *MemoryStore) CreateAPIKey(_ context.Context, key APIKeyEntity) (APIKeyEntity, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	if key.APIKeyID == "" {
		key.APIKeyID = newUUID()
	}
	if key.LogicalKeyID == "" {
		key.LogicalKeyID = key.APIKeyID
	}
	now := time.Now().UTC()
	if key.CreatedAt.IsZero() {
		key.CreatedAt = now
	}
	key.UpdatedAt = now

	s.keys[key.APIKeyID] = key
	s.keysByHash[key.KeyHash] = key.APIKeyID
	return key, nil
}

func (s *MemoryStore) GetAPIKey(_ context.Context, workspaceID, apiKeyID string) (APIKeyEntity, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	key, exists := s.keys[apiKeyID]
	if !exists || key.WorkspaceID != workspaceID {
		return APIKeyEntity{}, ErrKeyNotFound
	}
	return key, nil
}

func (s *MemoryStore) GetAPIKeyByHash(_ context.Context, keyHash string) (APIKeyEntity, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	keyID, exists := s.keysByHash[keyHash]
	if !exists {
		return APIKeyEntity{}, ErrKeyNotFound
	}
	key := s.keys[keyID]
	return key, nil
}

func (s *MemoryStore) ListAPIKeys(_ context.Context, workspaceID string, statusFilter string) ([]APIKeyEntity, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []APIKeyEntity
	for _, k := range s.keys {
		if k.WorkspaceID != workspaceID {
			continue
		}
		if statusFilter != "" && !strings.EqualFold(k.Status, statusFilter) {
			continue
		}
		result = append(result, k)
	}
	return result, nil
}

func (s *MemoryStore) UpdateAPIKey(_ context.Context, key APIKeyEntity) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	prev, exists := s.keys[key.APIKeyID]
	if !exists || prev.WorkspaceID != key.WorkspaceID {
		return ErrKeyNotFound
	}
	key.UpdatedAt = time.Now().UTC()
	s.keys[key.APIKeyID] = key
	s.keysByHash[key.KeyHash] = key.APIKeyID
	return nil
}

func (s *MemoryStore) CountActiveKeys(_ context.Context, workspaceID string) (int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	count := 0
	for _, k := range s.keys {
		if k.WorkspaceID == workspaceID && (k.Status == "active" || k.Status == "rotating") {
			count++
		}
	}
	return count, nil
}

func (s *MemoryStore) RecordUsage(_ context.Context, workspaceID, apiKeyID string, isWrite bool, statusCode int, billableAICredits float64, now time.Time) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key, exists := s.keys[apiKeyID]
	if exists {
		key.RequestCount++
		ts := now
		key.LastUsedAt = &ts
		key.UpdatedAt = now
		s.keys[apiKeyID] = key
	}

	dateStr := now.Format("2006-01-02")
	if _, ok := s.usage[apiKeyID]; !ok {
		s.usage[apiKeyID] = make(map[string]*DailyUsageEntity)
	}
	u, ok := s.usage[apiKeyID][dateStr]
	if !ok {
		u = &DailyUsageEntity{
			UsageID:     newUUID(),
			WorkspaceID: workspaceID,
			APIKeyID:    apiKeyID,
			UsageDate:   dateStr,
			CreatedAt:   now,
		}
		s.usage[apiKeyID][dateStr] = u
	}
	u.UpdatedAt = now
	if isWrite {
		u.WriteRequests++
	} else {
		u.ReadRequests++
	}
	if statusCode >= 400 && statusCode < 500 {
		u.Error4xxCount++
	} else if statusCode >= 500 {
		u.Error5xxCount++
	}
	// Per EC-S24-003: 5xx errors do NOT deduct AI credits.
	if statusCode < 500 && billableAICredits > 0 {
		u.BillableAICredits += billableAICredits
	}
	return nil
}

func (s *MemoryStore) GetUsageStats(_ context.Context, workspaceID, apiKeyID string, startDate, endDate string) ([]DailyUsageEntity, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []DailyUsageEntity
	for keyID, dateMap := range s.usage {
		if apiKeyID != "" && keyID != apiKeyID {
			continue
		}
		for dateStr, u := range dateMap {
			if u.WorkspaceID != workspaceID {
				continue
			}
			if startDate != "" && dateStr < startDate {
				continue
			}
			if endDate != "" && dateStr > endDate {
				continue
			}
			result = append(result, *u)
		}
	}
	return result, nil
}

func (s *MemoryStore) GetCurrentMonthRequests(_ context.Context, workspaceID, apiKeyID string, now time.Time) (int64, float64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	prefix := now.Format("2006-01")
	var totalRequests int64
	var totalAICredits float64

	for keyID, dateMap := range s.usage {
		if apiKeyID != "" && keyID != apiKeyID {
			continue
		}
		for dateStr, u := range dateMap {
			if u.WorkspaceID != workspaceID {
				continue
			}
			if strings.HasPrefix(dateStr, prefix) {
				totalRequests += int64(u.ReadRequests + u.WriteRequests)
				totalAICredits += u.BillableAICredits
			}
		}
	}
	return totalRequests, totalAICredits, nil
}

func (s *MemoryStore) CreateWebhookSubscription(_ context.Context, sub WebhookSubscriptionEntity) (WebhookSubscriptionEntity, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	if sub.SubscriptionID == "" {
		sub.SubscriptionID = newUUID()
	}
	now := time.Now().UTC()
	if sub.CreatedAt.IsZero() {
		sub.CreatedAt = now
	}
	sub.UpdatedAt = now
	s.subscriptions[sub.SubscriptionID] = sub
	return sub, nil
}

func (s *MemoryStore) GetWebhookSubscription(_ context.Context, workspaceID, subscriptionID string) (WebhookSubscriptionEntity, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	sub, exists := s.subscriptions[subscriptionID]
	if !exists || sub.WorkspaceID != workspaceID || sub.DeletedAt != nil {
		return WebhookSubscriptionEntity{}, ErrInvalidSubscription
	}
	return sub, nil
}

func (s *MemoryStore) ListWebhookSubscriptions(_ context.Context, workspaceID string) ([]WebhookSubscriptionEntity, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []WebhookSubscriptionEntity
	for _, sub := range s.subscriptions {
		if sub.WorkspaceID == workspaceID && sub.DeletedAt == nil {
			result = append(result, sub)
		}
	}
	return result, nil
}

func (s *MemoryStore) UpdateWebhookSubscription(_ context.Context, sub WebhookSubscriptionEntity) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	prev, exists := s.subscriptions[sub.SubscriptionID]
	if !exists || prev.WorkspaceID != sub.WorkspaceID {
		return ErrInvalidSubscription
	}
	sub.UpdatedAt = time.Now().UTC()
	s.subscriptions[sub.SubscriptionID] = sub
	return nil
}

func (s *MemoryStore) DeleteWebhookSubscription(_ context.Context, workspaceID, subscriptionID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	sub, exists := s.subscriptions[subscriptionID]
	if !exists || sub.WorkspaceID != workspaceID || sub.DeletedAt != nil {
		return ErrInvalidSubscription
	}
	now := time.Now().UTC()
	sub.DeletedAt = &now
	sub.Status = "revoked"
	sub.UpdatedAt = now
	s.subscriptions[subscriptionID] = sub
	return nil
}

func (s *MemoryStore) RecordWebhookDelivery(_ context.Context, delivery WebhookDeliveryEntity) (WebhookDeliveryEntity, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	if delivery.DeliveryID == "" {
		delivery.DeliveryID = newUUID()
	}
	now := time.Now().UTC()
	if delivery.CreatedAt.IsZero() {
		delivery.CreatedAt = now
	}
	delivery.UpdatedAt = now
	s.deliveries[delivery.DeliveryID] = delivery
	return delivery, nil
}

func (s *MemoryStore) GetWebhookDelivery(_ context.Context, workspaceID, deliveryID string) (WebhookDeliveryEntity, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	deliv, exists := s.deliveries[deliveryID]
	if !exists || deliv.WorkspaceID != workspaceID {
		return WebhookDeliveryEntity{}, fmt.Errorf("publicapi: webhook delivery %s not found", deliveryID)
	}
	return deliv, nil
}

func (s *MemoryStore) ListWebhookDeliveries(_ context.Context, workspaceID string, limit int) ([]WebhookDeliveryEntity, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []WebhookDeliveryEntity
	for _, deliv := range s.deliveries {
		if deliv.WorkspaceID == workspaceID {
			result = append(result, deliv)
			if limit > 0 && len(result) >= limit {
				break
			}
		}
	}
	return result, nil
}

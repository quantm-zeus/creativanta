package publicapi

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
)

// MockHTTPClient simulates downstream webhook receiving endpoints.
type MockHTTPClient struct {
	mu           sync.Mutex
	lastRequest  *http.Request
	lastBody     []byte
	handler      func(req *http.Request) (*http.Response, error)
	requestCount int32
}

func (m *MockHTTPClient) Do(req *http.Request) (*http.Response, error) {
	atomic.AddInt32(&m.requestCount, 1)
	m.mu.Lock()
	m.lastRequest = req
	if req.Body != nil {
		body, _ := io.ReadAll(req.Body)
		m.lastBody = body
		req.Body = io.NopCloser(strings.NewReader(string(body)))
	}
	h := m.handler
	m.mu.Unlock()

	if h != nil {
		return h(req)
	}
	return &http.Response{
		StatusCode: http.StatusOK,
		Body:       io.NopCloser(strings.NewReader(`{"received": true}`)),
	}, nil
}

// =============================================================================
// Target 1 Acceptance Tests: Read-only key cannot mutate
// =============================================================================

func TestAcceptanceTarget1_ReadOnlyKeyCannotMutate(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	tierProvider := NewFixedTierProvider()
	wsID := "22222222-2222-2222-2222-222222222201"
	tierProvider.SetTier(wsID, "pro") // Pro tier allows both read and write keys

	service := NewService(store, tierProvider)
	interceptor := NewAPIKeyInterceptor(service)

	// 1. Create a key with explicitly read-only scopes
	createdKey, rawSecret, err := service.CreateKey(ctx, wsID, "Read-Only Analytics Key", []string{"read:content", "read:orders", "read:analytics"}, 0, 90, "user_admin_01")
	if err != nil {
		t.Fatalf("CreateKey failed: %v", err)
	}
	if !IsReadOnlyScopes(createdKey.Scopes) {
		t.Fatalf("expected key to have read-only scopes, got: %v", createdKey.Scopes)
	}

	dummyHandler := func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		return connect.NewResponse(&struct{}{}), nil
	}
	wrappedHandler := interceptor.WrapUnary(dummyHandler)

	// 2. Read procedure (e.g. "/creativanta.commerce.v1.OrderService/GetOrder") should SUCCEED
	readReq := connect.NewRequest(&struct{}{})
	readReq.Header().Set("Authorization", "Bearer "+rawSecret)
	readReq.Header().Set("X-Procedure", "/creativanta.commerce.v1.OrderService/GetOrder")

	_, err = wrappedHandler(ctx, readReq)
	if err != nil {
		t.Fatalf("expected read procedure to succeed with read-only key, got error: %v", err)
	}

	// 3. Mutating procedure (e.g. "/creativanta.commerce.v1.OrderService/CreateOrder") MUST FAIL with 403 Forbidden!
	mutateReq := connect.NewRequest(&struct{}{})
	mutateReq.Header().Set("Authorization", "Bearer "+rawSecret)
	mutateReq.Header().Set("X-Procedure", "/creativanta.commerce.v1.OrderService/CreateOrder")

	_, err = wrappedHandler(ctx, mutateReq)
	if err == nil {
		t.Fatalf("ACCEPTANCE FAILURE: mutating procedure succeeded with read-only key! Expected 403 PermissionDenied.")
	}

	var connErr *connect.Error
	if !errors.As(err, &connErr) {
		t.Fatalf("expected connect.Error, got %T: %v", err, err)
	}
	if connErr.Code() != connect.CodePermissionDenied {
		t.Fatalf("expected connect.CodePermissionDenied (403), got code: %v", connErr.Code())
	}
	if !strings.Contains(connErr.Message(), "read-only") {
		t.Fatalf("expected error message to explain read-only restriction, got: %v", connErr.Message())
	}

	// 4. Test workspace on Starter Tier: Even if a key attempts mutation, Starter tier is strictly read-only mode!
	starterWs := "22222222-2222-2222-2222-222222222202"
	tierProvider.SetTier(starterWs, "starter")

	starterKey, starterRaw, err := service.CreateKey(ctx, starterWs, "Starter Key", []string{"read:content"}, 0, 90, "user_admin_02")
	if err != nil {
		t.Fatalf("CreateKey for starter failed: %v", err)
	}
	_ = starterKey

	starterMutateReq := connect.NewRequest(&struct{}{})
	starterMutateReq.Header().Set("Authorization", "Bearer "+starterRaw)
	starterMutateReq.Header().Set("X-Procedure", "/creativanta.content.v1.ScriptService/UpdateScript")

	_, err = wrappedHandler(ctx, starterMutateReq)
	if err == nil {
		t.Fatalf("ACCEPTANCE FAILURE: mutating operation allowed on Starter tier! Expected 403 PermissionDenied.")
	}
	if !errors.As(err, &connErr) || connErr.Code() != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for starter tier mutation, got %v", err)
	}
}

func TestAPIKey_TierCapsAndAccessMode(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	tierProvider := NewFixedTierProvider()
	wsID := "22222222-2222-2222-2222-222222222203"
	tierProvider.SetTier(wsID, "starter")

	service := NewService(store, tierProvider)

	// Starter tier rejects mutating scopes at creation time per RULE-S24-003
	_, _, err := service.CreateKey(ctx, wsID, "Illegal Write Key", []string{"write:content"}, 0, 90, "admin")
	if !errors.Is(err, ErrTierModeViolation) {
		t.Fatalf("expected ErrTierModeViolation when requesting write scopes on Starter tier, got: %v", err)
	}

	// Create 3 valid read-only keys on Starter tier (cap = 3)
	for i := 1; i <= 3; i++ {
		_, _, err := service.CreateKey(ctx, wsID, "Starter Key", []string{"read:content"}, 0, 90, "admin")
		if err != nil {
			t.Fatalf("failed to create key %d: %v", i, err)
		}
	}

	// 4th key on Starter tier should be rejected with ErrTierKeyCapExceeded
	_, _, err = service.CreateKey(ctx, wsID, "4th Key", []string{"read:content"}, 0, 90, "admin")
	if !errors.Is(err, ErrTierKeyCapExceeded) {
		t.Fatalf("expected ErrTierKeyCapExceeded for 4th key on Starter tier, got: %v", err)
	}

	// Upgrade workspace to Pro tier (cap = 10, allows read/write)
	tierProvider.SetTier(wsID, "pro")
	key4, _, err := service.CreateKey(ctx, wsID, "4th Key (Pro)", []string{"read:content", "write:content"}, 0, 90, "admin")
	if err != nil {
		t.Fatalf("expected key creation to succeed on Pro tier, got: %v", err)
	}
	if key4.Status != "active" {
		t.Fatalf("expected status active, got %s", key4.Status)
	}
}

func TestAPIKey_RotationWith24HourGracePeriod(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	tierProvider := NewFixedTierProvider()
	wsID := "22222222-2222-2222-2222-222222222204"
	tierProvider.SetTier(wsID, "pro")

	service := NewService(store, tierProvider)

	// 1. Create key
	origKey, origRaw, err := service.CreateKey(ctx, wsID, "Service Key", []string{"read:all"}, 0, 90, "admin")
	if err != nil {
		t.Fatalf("CreateKey failed: %v", err)
	}

	// Verify original key authenticates
	authKey, err := service.AuthenticateKey(ctx, origRaw)
	if err != nil {
		t.Fatalf("AuthenticateKey failed: %v", err)
	}
	if authKey.APIKeyID != origKey.APIKeyID {
		t.Fatalf("expected key ID %s, got %s", origKey.APIKeyID, authKey.APIKeyID)
	}

	// 2. Rotate key
	oldEntity, newEntity, newRaw, graceEnds, err := service.RotateKey(ctx, wsID, origKey.APIKeyID)
	if err != nil {
		t.Fatalf("RotateKey failed: %v", err)
	}

	if oldEntity.Status != "rotating" {
		t.Fatalf("expected old key status 'rotating', got %s", oldEntity.Status)
	}
	if oldEntity.ReplacedByKeyID != newEntity.APIKeyID {
		t.Fatalf("expected old key replaced_by_key_id %s, got %s", newEntity.APIKeyID, oldEntity.ReplacedByKeyID)
	}
	if graceEnds.Before(time.Now().UTC()) {
		t.Fatalf("expected grace period in future, got %v", graceEnds)
	}

	// 3. During grace period: BOTH old key and new key are accepted per EC-S24-001!
	_, err = service.AuthenticateKey(ctx, origRaw)
	if err != nil {
		t.Fatalf("expected old key to authenticate during grace period, got: %v", err)
	}
	_, err = service.AuthenticateKey(ctx, newRaw)
	if err != nil {
		t.Fatalf("expected new key to authenticate during grace period, got: %v", err)
	}

	// 4. Advance time past grace period: old key is expired, returns 401 per EC-S24-001
	expiredOldKey := oldEntity
	past := time.Now().UTC().Add(-1 * time.Hour)
	expiredOldKey.RotationGraceEndsAt = &past
	_ = store.UpdateAPIKey(ctx, expiredOldKey)

	_, err = service.AuthenticateKey(ctx, origRaw)
	if err == nil {
		t.Fatalf("expected old key to be rejected after grace period ended, but it succeeded")
	}
	if !errors.Is(err, ErrKeyExpired) {
		t.Fatalf("expected ErrKeyExpired, got: %v", err)
	}

	// New key continues to authenticate
	_, err = service.AuthenticateKey(ctx, newRaw)
	if err != nil {
		t.Fatalf("expected new key to remain active, got error: %v", err)
	}
}

func TestAPIKey_ImmediateRevocation(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	tierProvider := NewFixedTierProvider()
	wsID := "22222222-2222-2222-2222-222222222205"
	tierProvider.SetTier(wsID, "pro")

	service := NewService(store, tierProvider)

	created, rawSecret, err := service.CreateKey(ctx, wsID, "Temp Key", []string{"read:content"}, 0, 90, "admin")
	if err != nil {
		t.Fatalf("CreateKey failed: %v", err)
	}

	// Revoke key
	revoked, err := service.RevokeKey(ctx, wsID, created.APIKeyID, "Security breach")
	if err != nil {
		t.Fatalf("RevokeKey failed: %v", err)
	}
	if revoked.Status != "revoked" {
		t.Fatalf("expected status 'revoked', got %s", revoked.Status)
	}

	// Immediate rejection on next request
	_, err = service.AuthenticateKey(ctx, rawSecret)
	if !errors.Is(err, ErrKeyRevoked) {
		t.Fatalf("expected ErrKeyRevoked on revoked key, got: %v", err)
	}
}

func TestRateLimiter_SlidingWindowAndRetryAfter(t *testing.T) {
	limiter := NewSlidingWindowRateLimiter()
	keyID := "test_key_rl"
	now := time.Now().UTC()

	// 100 read requests should be allowed
	for i := 1; i <= DefaultReadRateLimitRPM; i++ {
		allowed, limit, remaining, _ := limiter.CheckRateLimit(keyID, false, 0, now)
		if !allowed {
			t.Fatalf("expected request %d to be allowed", i)
		}
		if limit != 100 {
			t.Fatalf("expected limit 100, got %d", limit)
		}
		if remaining != (100 - i) {
			t.Fatalf("expected remaining %d, got %d", 100-i, remaining)
		}
	}

	// 101st request should be rejected with Retry-After > 0
	allowed, _, remaining, resetSec := limiter.CheckRateLimit(keyID, false, 0, now)
	if allowed {
		t.Fatalf("expected 101st request to exceed rate limit!")
	}
	if remaining != 0 {
		t.Fatalf("expected remaining 0, got %d", remaining)
	}
	if resetSec <= 0 {
		t.Fatalf("expected positive resetSec, got %d", resetSec)
	}

	// Write limit is 30 req/min
	for i := 1; i <= DefaultWriteRateLimitRPM; i++ {
		allowed, limit, _, _ := limiter.CheckRateLimit(keyID, true, 0, now)
		if !allowed {
			t.Fatalf("expected write request %d to be allowed", i)
		}
		if limit != 30 {
			t.Fatalf("expected write limit 30, got %d", limit)
		}
	}
	// 31st write request rejected
	allowed, _, _, _ = limiter.CheckRateLimit(keyID, true, 0, now)
	if allowed {
		t.Fatalf("expected 31st write request to exceed rate limit!")
	}
}

func TestUsageMetering_5xxDoesNotDeductAICredits(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	wsID := "22222222-2222-2222-2222-222222222206"
	keyID := "key_usage_test"
	now := time.Now().UTC()

	// Request 1: 200 OK with 5.5 AI credits
	_ = store.RecordUsage(ctx, wsID, keyID, true, 200, 5.5, now)

	// Request 2: 500 Internal Error with attempted 10 AI credits
	// Per EC-S24-003: 5xx server errors do NOT deduct billable AI credits
	_ = store.RecordUsage(ctx, wsID, keyID, true, 500, 10.0, now)

	dateStr := now.Format("2006-01-02")
	stats, err := store.GetUsageStats(ctx, wsID, keyID, dateStr, dateStr)
	if err != nil {
		t.Fatalf("GetUsageStats failed: %v", err)
	}
	if len(stats) != 1 {
		t.Fatalf("expected 1 daily record, got %d", len(stats))
	}
	day := stats[0]
	if day.WriteRequests != 2 {
		t.Fatalf("expected 2 write requests, got %d", day.WriteRequests)
	}
	if day.Error5xxCount != 1 {
		t.Fatalf("expected 1 5xx error, got %d", day.Error5xxCount)
	}
	if day.BillableAICredits != 5.5 {
		t.Fatalf("expected 5.5 billable AI credits (5xx was not deducted), got %f", day.BillableAICredits)
	}
}

// =============================================================================
// Target 2 Acceptance Tests: Replay-safe outbound webhook
// =============================================================================

func TestAcceptanceTarget2_ReplaySafeOutboundWebhook(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	tierProvider := NewFixedTierProvider()
	wsID := "22222222-2222-2222-2222-222222222207"
	tierProvider.SetTier(wsID, "pro")

	service := NewService(store, tierProvider)

	// Register subscription for 'workflow.completed' and 'content.published'
	sub, secret, err := service.CreateWebhookSubscription(ctx, wsID, "", "https://customer.api/webhooks/creativanta", []string{"workflow.completed", "content.published"}, "user_01")
	if err != nil {
		t.Fatalf("CreateWebhookSubscription failed: %v", err)
	}

	mockClient := &MockHTTPClient{
		handler: func(req *http.Request) (*http.Response, error) {
			return &http.Response{
				StatusCode: http.StatusOK,
				Body:       io.NopCloser(strings.NewReader(`{"status": "ok"}`)),
			}, nil
		},
	}
	dispatcher := NewOutboundDispatcher(store, mockClient)

	// Raw payload containing internal costs and secret parameters
	rawPayload := json.RawMessage(`{
		"run_id": "wf_run_999",
		"workflow_name": "Multi-Channel Auto Publish",
		"status": "completed",
		"actual_cost_usd": 12.50,
		"platform_margin": 3.75,
		"internal_notes": "confidential provider route",
		"operator_explanation": "internal debugging only",
		"db_conn_str": "postgres://user:pass@host/db",
		"items_published": 3
	}`)

	// Dispatch 'workflow_run.completed' (internal domain event) -> maps to 'workflow.completed' (§21.2)
	req := OutboundEventDeliveryRequest{
		WorkspaceID: wsID,
		EventType:   "workflow_run.completed",
		EventID:     "ev_001",
		RawPayload:  rawPayload,
	}

	res, err := dispatcher.DispatchEvent(ctx, req)
	if err != nil {
		t.Fatalf("DispatchEvent failed: %v", err)
	}
	if res.DeliveredCount != 1 {
		t.Fatalf("expected 1 delivery, got %d", res.DeliveredCount)
	}

	// 1. Verify HMAC-SHA256 signature
	mockClient.mu.Lock()
	sentReq := mockClient.lastRequest
	sentBody := mockClient.lastBody
	mockClient.mu.Unlock()

	sigHeader := sentReq.Header.Get("X-Creativanta-Signature")
	tsHeader := sentReq.Header.Get("X-Creativanta-Timestamp")
	if !strings.HasPrefix(sigHeader, "sha256=") {
		t.Fatalf("expected sha256= prefix in signature header, got: %s", sigHeader)
	}
	if tsHeader == "" {
		t.Fatalf("missing X-Creativanta-Timestamp header")
	}

	var tsInt int64
	_, _ = fmt.Sscanf(tsHeader, "%d", &tsInt)
	if !VerifySignature(secret, sigHeader, tsInt, sentBody) {
		t.Fatalf("ACCEPTANCE FAILURE: HMAC signature verification failed!")
	}

	// 2. Verify Sanitization: Operator-only and cost details MUST BE STRIPPED!
	var sentPayload map[string]any
	if err := json.Unmarshal(sentBody, &sentPayload); err != nil {
		t.Fatalf("failed to unmarshal sent payload: %v", err)
	}
	if _, exists := sentPayload["actual_cost_usd"]; exists {
		t.Fatalf("SECURITY VIOLATION: actual_cost_usd was not stripped from outbound payload!")
	}
	if _, exists := sentPayload["platform_margin"]; exists {
		t.Fatalf("SECURITY VIOLATION: platform_margin was not stripped from outbound payload!")
	}
	if _, exists := sentPayload["internal_notes"]; exists {
		t.Fatalf("SECURITY VIOLATION: internal_notes was not stripped from outbound payload!")
	}
	if _, exists := sentPayload["db_conn_str"]; exists {
		t.Fatalf("SECURITY VIOLATION: db_conn_str was not stripped from outbound payload!")
	}
	if sentPayload["run_id"] != "wf_run_999" || sentPayload["workflow_name"] != "Multi-Channel Auto Publish" {
		t.Fatalf("expected clean public payload fields, got: %+v", sentPayload)
	}

	// 3. Verify Replay-Safety: Replay delivery
	deliveryID := res.Deliveries[0].DeliveryID
	replayRecord, err := dispatcher.ReplayDelivery(ctx, wsID, deliveryID)
	if err != nil {
		t.Fatalf("ReplayDelivery failed: %v", err)
	}
	if !replayRecord.IsReplay {
		t.Fatalf("expected replayRecord.IsReplay to be true")
	}
	if replayRecord.DeliveryStatus != "replayed" {
		t.Fatalf("expected status 'replayed', got %s", replayRecord.DeliveryStatus)
	}

	// Ineligibility rejection
	_, err = dispatcher.DispatchEvent(ctx, OutboundEventDeliveryRequest{
		WorkspaceID: wsID,
		EventType:   "unauthorized.internal.audit.dump",
		EventID:     "ev_bad",
		RawPayload:  json.RawMessage(`{}`),
	})
	if !errors.Is(err, ErrIneligibleWebhookEvent) {
		t.Fatalf("expected ErrIneligibleWebhookEvent for unauthorized event, got: %v", err)
	}

	_ = sub
}

func TestWebhook_AutoSuspensionAfter100Failures(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	wsID := "22222222-2222-2222-2222-222222222208"

	subEntity := WebhookSubscriptionEntity{
		SubscriptionID:          "sub_fail_100",
		WorkspaceID:             wsID,
		TargetURL:               "https://broken.endpoint.com",
		EventTypes:              []string{"order.created"},
		SigningSecret:           "whsec_test",
		SigningSecretHash:       HashKey("whsec_test"),
		Status:                  "active",
		ConsecutiveFailureCount: 99, // Already failed 99 times
		CreatedAt:               time.Now().UTC(),
	}
	_, _ = store.CreateWebhookSubscription(ctx, subEntity)

	// Mock endpoint failing with 500
	mockClient := &MockHTTPClient{
		handler: func(req *http.Request) (*http.Response, error) {
			return &http.Response{
				StatusCode: http.StatusInternalServerError,
				Body:       io.NopCloser(strings.NewReader(`server error`)),
			}, nil
		},
	}
	// Use short deadline so backoff does not block unit test
	shortCtx, cancel := context.WithTimeout(ctx, 50*time.Millisecond)
	defer cancel()

	dispatcher := NewOutboundDispatcher(store, mockClient)
	_, _ = dispatcher.DispatchEvent(shortCtx, OutboundEventDeliveryRequest{
		WorkspaceID: wsID,
		EventType:   "order.created",
		EventID:     "ev_fail_100",
		RawPayload:  json.RawMessage(`{"order_id": "ord_1"}`),
	})

	// Verify subscription was automatically suspended per RULE-S24-006 & §5.1!
	updatedSub, err := store.GetWebhookSubscription(ctx, wsID, "sub_fail_100")
	if err != nil {
		t.Fatalf("GetWebhookSubscription failed: %v", err)
	}
	if updatedSub.ConsecutiveFailureCount < 100 {
		t.Fatalf("expected >= 100 consecutive failures, got %d", updatedSub.ConsecutiveFailureCount)
	}
	if updatedSub.Status != "suspended" {
		t.Fatalf("expected subscription status 'suspended' after 100 failures, got: %s", updatedSub.Status)
	}
}

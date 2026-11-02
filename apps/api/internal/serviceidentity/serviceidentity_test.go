package serviceidentity_test

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/serviceidentity"
)

func TestAPIKeyLifecycleAndSecretHashing(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	svc := serviceidentity.NewService(store, nil, nil)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	// Create an API key
	created, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierPro,
		Name:        "Production Integration Key",
		Scopes:      []string{serviceidentity.ScopeProductsRead, serviceidentity.ScopeOrdersRead},
		Live:        true,
	})
	if err != nil {
		t.Fatalf("CreateKey failed: %v", err)
	}

	if created.PlainKey == "" {
		t.Fatal("expected plain key to be returned upon creation")
	}
	if !serviceidentity.ValidateKeyFormat(created.PlainKey) {
		t.Fatalf("invalid key format: %s", created.PlainKey)
	}
	if len(created.KeyPrefix) != 10 {
		t.Fatalf("expected key prefix length 10, got %d (%s)", len(created.KeyPrefix), created.KeyPrefix)
	}

	// Verify key can authenticate
	authCtx, _, err := svc.Authenticate(ctx, created.PlainKey, false, "127.0.0.1")
	if err != nil {
		t.Fatalf("Authenticate failed: %v", err)
	}
	if authCtx.WorkspaceID != workspaceID {
		t.Errorf("expected workspace %s, got %s", workspaceID, authCtx.WorkspaceID)
	}
	if authCtx.APIKeyID != created.APIKeyID {
		t.Errorf("expected apiKeyID %s, got %s", created.APIKeyID, authCtx.APIKeyID)
	}
	if !authCtx.HasScope(serviceidentity.ScopeProductsRead) {
		t.Errorf("expected to have ScopeProductsRead")
	}
	if authCtx.HasScope(serviceidentity.ScopeProductsManage) {
		t.Errorf("should NOT have ScopeProductsManage")
	}

	// Verify public projection never exposes key hash or plain key
	projections, err := svc.ListKeys(ctx, workspaceID)
	if err != nil {
		t.Fatalf("ListKeys failed: %v", err)
	}
	if len(projections) != 1 {
		t.Fatalf("expected 1 key projection, got %d", len(projections))
	}
	proj := projections[0]
	if proj.APIKeyID != created.APIKeyID {
		t.Errorf("mismatched key ID in projection")
	}
	if proj.KeyPrefix != created.KeyPrefix {
		t.Errorf("mismatched prefix in projection")
	}
}

func TestTierCapsAndScopeRestrictions(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	svc := serviceidentity.NewService(store, nil, nil)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	// 1. Starter tier cannot create write scopes (RULE-S24-003)
	_, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierStarter,
		Name:        "Invalid Starter Key",
		Scopes:      []string{serviceidentity.ScopeProductsManage},
		Live:        true,
	})
	if !errors.Is(err, serviceidentity.ErrScopeNotPermitted) {
		t.Fatalf("expected ErrScopeNotPermitted for Starter write scope, got: %v", err)
	}

	// 2. Starter tier allows read-only scopes up to cap of 3
	for i := 1; i <= 3; i++ {
		_, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
			WorkspaceID: workspaceID,
			CreatedBy:   userID,
			Tier:        serviceidentity.TierStarter,
			Name:        fmt.Sprintf("Starter Key %d", i),
			Scopes:      []string{serviceidentity.ScopeProductsRead},
			Live:        true,
		})
		if err != nil {
			t.Fatalf("failed to create key %d: %v", i, err)
		}
	}

	// 4th key should fail with ErrTierCapExceeded
	_, err = svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierStarter,
		Name:        "Starter Key 4",
		Scopes:      []string{serviceidentity.ScopeProductsRead},
		Live:        true,
	})
	if !errors.Is(err, serviceidentity.ErrTierCapExceeded) {
		t.Fatalf("expected ErrTierCapExceeded when exceeding Starter cap (3), got: %v", err)
	}
}

func TestImmediateRevocation(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	svc := serviceidentity.NewService(store, nil, nil)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	created, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierPro,
		Name:        "To Revoke",
		Scopes:      []string{serviceidentity.ScopeOrdersRead},
		Live:        true,
	})
	if err != nil {
		t.Fatal(err)
	}

	// Immediate revocation
	if err := svc.RevokeKey(ctx, workspaceID, created.APIKeyID, "Manual security revoke"); err != nil {
		t.Fatalf("RevokeKey failed: %v", err)
	}

	// Authenticate must fail immediately
	_, _, err = svc.Authenticate(ctx, created.PlainKey, false, "127.0.0.1")
	if !errors.Is(err, serviceidentity.ErrKeyRevoked) {
		t.Fatalf("expected ErrKeyRevoked after revocation, got: %v", err)
	}
}

func TestKeyRotationAndGracePeriod_ECS24_001(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	simulatedTime := time.Date(2026, 11, 2, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return simulatedTime }
	svc := serviceidentity.NewService(store, nil, clock)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	// Step 1: Create initial key
	oldKey, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierPro,
		Name:        "Original Key",
		Scopes:      []string{serviceidentity.ScopeProductsRead, serviceidentity.ScopeProductsManage},
		Live:        true,
	})
	if err != nil {
		t.Fatal(err)
	}

	// Step 2: Rotate key
	newKey, err := svc.RotateKey(ctx, workspaceID, oldKey.APIKeyID, true)
	if err != nil {
		t.Fatalf("RotateKey failed: %v", err)
	}

	// EC-S24-001 Check 1: During 24h rotation window, BOTH keys are valid
	authOld, _, err := svc.Authenticate(ctx, oldKey.PlainKey, false, "127.0.0.1")
	if err != nil {
		t.Fatalf("old key failed to authenticate during grace period: %v", err)
	}
	authNew, _, err := svc.Authenticate(ctx, newKey.PlainKey, false, "127.0.0.1")
	if err != nil {
		t.Fatalf("new key failed to authenticate: %v", err)
	}

	// Both should share the same logical key identity for metered billing
	if authOld.LogicalKeyID != authNew.LogicalKeyID {
		t.Errorf("expected same LogicalKeyID for rotated keys, got old=%s new=%s",
			authOld.LogicalKeyID, authNew.LogicalKeyID)
	}

	// Advance clock by 12 hours (still in grace period)
	simulatedTime = simulatedTime.Add(12 * time.Hour)
	_, _, err = svc.Authenticate(ctx, oldKey.PlainKey, false, "127.0.0.1")
	if err != nil {
		t.Fatalf("old key should still work at 12 hours: %v", err)
	}

	// Advance clock past 24 hours (grace period expired)
	simulatedTime = simulatedTime.Add(13 * time.Hour) // Total 25 hours elapsed
	_, _, err = svc.Authenticate(ctx, oldKey.PlainKey, false, "127.0.0.1")
	if !errors.Is(err, serviceidentity.ErrKeyRotated) {
		t.Fatalf("expected ErrKeyRotated after 24h grace period, got: %v", err)
	}

	// New key MUST still work
	_, _, err = svc.Authenticate(ctx, newKey.PlainKey, false, "127.0.0.1")
	if err != nil {
		t.Fatalf("new key must still work after grace period: %v", err)
	}
}

func TestSlidingWindowRateLimiting_ECS24_002(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	simulatedTime := time.Date(2026, 11, 2, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return simulatedTime }
	svc := serviceidentity.NewService(store, nil, clock)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	key, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierPro,
		Name:        "Rate Limit Test Key",
		Scopes:      []string{serviceidentity.ScopeProductsRead, serviceidentity.ScopeProductsManage},
		Live:        true,
	})
	if err != nil {
		t.Fatal(err)
	}

	// Read limit is 100 req/min
	for i := 1; i <= 100; i++ {
		_, res, err := svc.Authenticate(ctx, key.PlainKey, false, "127.0.0.1")
		if err != nil {
			t.Fatalf("read request %d failed: %v", i, err)
		}
		if res.Remaining != (100 - i) {
			t.Errorf("expected remaining %d, got %d", 100-i, res.Remaining)
		}
	}

	// 101st read request must be rejected with 429 / ErrRateLimitExceeded
	_, res, err := svc.Authenticate(ctx, key.PlainKey, false, "127.0.0.1")
	if !errors.Is(err, serviceidentity.ErrRateLimitExceeded) {
		t.Fatalf("expected ErrRateLimitExceeded on 101st request, got: %v", err)
	}
	if res.RetryAfterSeconds <= 0 {
		t.Errorf("expected positive RetryAfterSeconds, got %d", res.RetryAfterSeconds)
	}

	// Advance time by 61 seconds: sliding window rolls over
	simulatedTime = simulatedTime.Add(61 * time.Second)
	_, res, err = svc.Authenticate(ctx, key.PlainKey, false, "127.0.0.1")
	if err != nil {
		t.Fatalf("request after sliding window rollover failed: %v", err)
	}
	if !res.Allowed {
		t.Errorf("expected request to be allowed after 61s")
	}

	// Write limit is 30 req/min
	for i := 1; i <= 30; i++ {
		_, _, err := svc.Authenticate(ctx, key.PlainKey, true, "127.0.0.1")
		if err != nil {
			t.Fatalf("write request %d failed: %v", i, err)
		}
	}
	// 31st write request must be rejected
	_, resWrite, err := svc.Authenticate(ctx, key.PlainKey, true, "127.0.0.1")
	if !errors.Is(err, serviceidentity.ErrRateLimitExceeded) {
		t.Fatalf("expected ErrRateLimitExceeded on 31st write request, got: %v", err)
	}
	if resWrite.RetryAfterSeconds <= 0 {
		t.Errorf("expected positive RetryAfterSeconds for write")
	}
}

func Test90DayAutoExpiration_RULES24_004(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	simulatedTime := time.Date(2026, 11, 2, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return simulatedTime }
	svc := serviceidentity.NewService(store, nil, clock)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	key, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierPro,
		Name:        "Expiration Test Key",
		Scopes:      []string{serviceidentity.ScopeProductsRead},
		Live:        true,
	})
	if err != nil {
		t.Fatal(err)
	}

	// Day 70: ExpiringSoon is false
	simulatedTime = simulatedTime.Add(70 * 24 * time.Hour)
	projs, _ := svc.ListKeys(ctx, workspaceID)
	if projs[0].ExpiringSoon {
		t.Errorf("day 70 should not be expiring soon")
	}

	// Day 76 (> 75 days warning threshold): ExpiringSoon is true
	simulatedTime = simulatedTime.Add(6 * 24 * time.Hour)
	projs, _ = svc.ListKeys(ctx, workspaceID)
	if !projs[0].ExpiringSoon {
		t.Errorf("day 76 (<= 14 days remaining) should be expiring soon")
	}

	// Key still authenticates
	_, _, err = svc.Authenticate(ctx, key.PlainKey, false, "127.0.0.1")
	if err != nil {
		t.Fatalf("key should still authenticate at day 76: %v", err)
	}

	// Day 91: Expired
	simulatedTime = simulatedTime.Add(15 * 24 * time.Hour)
	_, _, err = svc.Authenticate(ctx, key.PlainKey, false, "127.0.0.1")
	if !errors.Is(err, serviceidentity.ErrKeyExpired) {
		t.Fatalf("expected ErrKeyExpired on day 91, got: %v", err)
	}
}

func TestConcurrentRequestsAndThreadSafety(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	svc := serviceidentity.NewService(store, nil, nil)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	key, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierEnterprise,
		Name:        "Concurrent Key",
		Scopes:      []string{serviceidentity.ScopeProductsRead, serviceidentity.ScopeProductsManage},
		Live:        true,
	})
	if err != nil {
		t.Fatal(err)
	}

	var wg sync.WaitGroup
	workers := 20
	iterations := 50

	for w := 0; w < workers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			for i := 0; i < iterations; i++ {
				_, _, _ = svc.Authenticate(ctx, key.PlainKey, workerID%2 == 0, fmt.Sprintf("192.168.1.%d", workerID))
			}
		}(w)
	}

	wg.Wait()

	// Verify key request count incremented
	projs, err := svc.ListKeys(ctx, workspaceID)
	if err != nil {
		t.Fatal(err)
	}
	if projs[0].RequestCount == 0 {
		t.Errorf("expected positive request count")
	}
}

func TestUpdateScopes(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	svc := serviceidentity.NewService(store, nil, nil)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	key, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierPro,
		Name:        "Scope Update Key",
		Scopes:      []string{serviceidentity.ScopeProductsRead},
		Live:        true,
	})
	if err != nil {
		t.Fatal(err)
	}

	// 1. Cannot update with empty scopes
	if err := svc.UpdateScopes(ctx, workspaceID, key.APIKeyID, serviceidentity.TierPro, []string{}); !errors.Is(err, serviceidentity.ErrInvalidScopes) {
		t.Fatalf("expected ErrInvalidScopes, got %v", err)
	}

	// 2. Cannot update with unsupported scope for tier
	if err := svc.UpdateScopes(ctx, workspaceID, key.APIKeyID, serviceidentity.TierStarter, []string{serviceidentity.ScopeProductsManage}); !errors.Is(err, serviceidentity.ErrScopeNotPermitted) {
		t.Fatalf("expected ErrScopeNotPermitted, got %v", err)
	}

	// 3. Successfully update scopes for Pro tier
	newScopes := []string{serviceidentity.ScopeProductsRead, serviceidentity.ScopeProductsManage, serviceidentity.ScopeOrdersRead}
	if err := svc.UpdateScopes(ctx, workspaceID, key.APIKeyID, serviceidentity.TierPro, newScopes); err != nil {
		t.Fatalf("UpdateScopes failed: %v", err)
	}

	authCtx, _, err := svc.Authenticate(ctx, key.PlainKey, false, "127.0.0.1")
	if err != nil {
		t.Fatalf("Authenticate failed after update: %v", err)
	}
	if !authCtx.HasScope(serviceidentity.ScopeProductsManage) {
		t.Fatalf("expected to have ScopeProductsManage after update")
	}

	// 4. Cannot update scopes on revoked key
	if err := svc.RevokeKey(ctx, workspaceID, key.APIKeyID, "testing"); err != nil {
		t.Fatal(err)
	}
	if err := svc.UpdateScopes(ctx, workspaceID, key.APIKeyID, serviceidentity.TierPro, newScopes); err == nil {
		t.Fatalf("expected error updating scopes on revoked key")
	}
}

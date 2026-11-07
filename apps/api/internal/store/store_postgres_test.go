package store

import (
	"context"
	"errors"
	"fmt"
	"net/url"
	"os"
	"path/filepath"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func buildAppUserStoreDSN(adminDSN string) (string, error) {
	u, err := url.Parse(adminDSN)
	if err != nil {
		return "", err
	}
	u.User = url.UserPassword("app_user", "app_user_test_pw")
	return u.String(), nil
}

type failingSavePostgresStore struct {
	*PostgresStore
	failSave bool
}

func (f *failingSavePostgresStore) SaveCheckoutResult(ctx context.Context, workspaceID, idempotencyKey string, res *CheckoutResult) error {
	if f.failSave {
		return fmt.Errorf("simulated PostgresStore SaveCheckoutResult outage")
	}
	return f.PostgresStore.SaveCheckoutResult(ctx, workspaceID, idempotencyKey, res)
}

func TestPostgresLiveCrossInstanceCheckoutIdempotencyAndRLS(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL S3 store checkout suite executes when DB is available")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	migConn, err := adminPool.Acquire(ctx)
	if err != nil {
		t.Fatalf("acquire migConn: %v", err)
	}
	if _, err := migConn.Exec(ctx, `SELECT pg_advisory_lock(77331100)`); err != nil {
		migConn.Release()
		t.Fatalf("pg_advisory_lock: %v", err)
	}
	_, migErr := migrate.Up(ctx, adminPool, dir)
	_, roleErr := adminPool.Exec(ctx, `ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw' NOBYPASSRLS`)
	_, _ = migConn.Exec(ctx, `SELECT pg_advisory_unlock(77331100)`)
	migConn.Release()
	if migErr != nil {
		t.Fatalf("migrate.Up failed: %v", migErr)
	}
	if roleErr != nil {
		t.Fatalf("configure app_user login: %v", roleErr)
	}

	const (
		userA     = "11111111-1111-4111-8111-111111111301"
		userB     = "22222222-2222-4222-8222-222222222302"
		tenantA   = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaa301"
		tenantB   = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbb302"
		customerA = "cccccccc-cccc-4ccc-8ccc-ccccccccc301"
		prodA     = "dddddddd-dddd-4ddd-8ddd-ddddddddd301"
	)

	_, err = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ($1::uuid, 's3_store_ext_a', 's3_store_a@example.com', 'S3 Store User A', 'active'),
		  ($2::uuid, 's3_store_ext_b', 's3_store_b@example.com', 'S3 Store User B', 'active')
		ON CONFLICT (user_id) DO NOTHING
	`, userA, userB)
	if err != nil {
		t.Fatalf("seed users: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status) VALUES
		  ($1::uuid, 'S3 Store Tenant A', 's3-store-tenant-a', $2::uuid, 'active'),
		  ($3::uuid, 'S3 Store Tenant B', 's3-store-tenant-b', $4::uuid, 'active')
		ON CONFLICT (workspace_id) DO NOTHING
	`, tenantA, userA, tenantB, userB)
	if err != nil {
		t.Fatalf("seed workspaces: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspace_members (workspace_id, user_id, role, status) VALUES
		  ($1::uuid, $2::uuid, 'owner', 'active'),
		  ($3::uuid, $4::uuid, 'owner', 'active')
		ON CONFLICT (workspace_id, user_id) DO NOTHING
	`, tenantA, userA, tenantB, userB)
	if err != nil {
		t.Fatalf("seed workspace_members: %v", err)
	}

	_, _ = adminPool.Exec(ctx, `DELETE FROM external_effects WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)

	appDSN, err := buildAppUserStoreDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserStoreDSN: %v", err)
	}
	appPool, err := pgxpool.New(ctx, appDSN)
	if err != nil {
		t.Fatalf("connect appPool: %v", err)
	}
	defer appPool.Close()

	now := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)

	// Two independent PostgresStore + Service instances with separate in-memory stores,
	// sharing ONLY PostgreSQL appPool (external_effects under RLS).
	pgStore1 := NewPostgresStore(appPool, NewMemoryStore())
	pgStore2 := NewPostgresStore(appPool, NewMemoryStore())
	svc1 := NewService(pgStore1, &mockSink{}, func() time.Time { return now })
	svc2 := NewService(pgStore2, &mockSink{}, func() time.Time { return now })

	for _, svc := range []*Service{svc1, svc2} {
		if err := svc.UpsertProduct(ctx, &StoreProduct{
			ProductID:   prodA,
			WorkspaceID: tenantA,
			Title:       "PG Cross-Instance Digital Pack",
			Price:       mustDecimal(t, "50000.000000"),
			Currency:    "VND",
			Status:      ProductStatusActive,
		}); err != nil {
			t.Fatalf("UpsertProduct: %v", err)
		}
		svc.SetPaymentVerifier(func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
			return PaymentStatusSucceeded, nil
		})
	}

	// 1. Concurrent cross-instance race with SAME PaymentIntentID and DIFFERENT IdempotencyKeys
	startBarrier := make(chan struct{})
	var wg sync.WaitGroup
	var wins int32
	var replayRejects int32
	var otherErrs int32

	wg.Add(2)
	go func() {
		defer wg.Done()
		<-startBarrier
		_, cErr := svc1.Checkout(ctx, CheckoutRequest{
			WorkspaceID:      tenantA,
			CustomerEntityID: customerA,
			IdempotencyKey:   "pg-race-idem-1",
			PaymentIntentID:  "pi_pg_shared_1",
			ProductIDs:       []string{prodA},
			OrderAmount:      mustDecimal(t, "50000.000000"),
			Currency:         "VND",
		})
		if cErr == nil {
			atomic.AddInt32(&wins, 1)
		} else if errors.Is(cErr, ErrPaymentReplay) {
			atomic.AddInt32(&replayRejects, 1)
		} else {
			t.Errorf("svc1 unexpected error: %v", cErr)
			atomic.AddInt32(&otherErrs, 1)
		}
	}()
	go func() {
		defer wg.Done()
		<-startBarrier
		_, cErr := svc2.Checkout(ctx, CheckoutRequest{
			WorkspaceID:      tenantA,
			CustomerEntityID: customerA,
			IdempotencyKey:   "pg-race-idem-2",
			PaymentIntentID:  "pi_pg_shared_1",
			ProductIDs:       []string{prodA},
			OrderAmount:      mustDecimal(t, "50000.000000"),
			Currency:         "VND",
		})
		if cErr == nil {
			atomic.AddInt32(&wins, 1)
		} else if errors.Is(cErr, ErrPaymentReplay) {
			atomic.AddInt32(&replayRejects, 1)
		} else {
			t.Errorf("svc2 unexpected error: %v", cErr)
			atomic.AddInt32(&otherErrs, 1)
		}
	}()
	close(startBarrier)
	wg.Wait()

	if wins != 1 || replayRejects != 1 || otherErrs != 0 {
		t.Fatalf("expected wins=1 replayRejects=1 otherErrs=0 across PostgresStore instances, got wins=%d replayRejects=%d otherErrs=%d", wins, replayRejects, otherErrs)
	}

	// 2. Concurrent cross-instance race with SAME PaymentIntentID and SAME IdempotencyKey
	startSame := make(chan struct{})
	var wgSame sync.WaitGroup
	var resA, resB *CheckoutResult
	var errA, errB error
	wgSame.Add(2)
	go func() {
		defer wgSame.Done()
		<-startSame
		resA, errA = svc1.Checkout(ctx, CheckoutRequest{
			WorkspaceID:      tenantA,
			CustomerEntityID: customerA,
			IdempotencyKey:   "pg-same-idem-1",
			PaymentIntentID:  "pi_pg_same_1",
			ProductIDs:       []string{prodA},
			OrderAmount:      mustDecimal(t, "50000.000000"),
			Currency:         "VND",
		})
	}()
	go func() {
		defer wgSame.Done()
		<-startSame
		resB, errB = svc2.Checkout(ctx, CheckoutRequest{
			WorkspaceID:      tenantA,
			CustomerEntityID: customerA,
			IdempotencyKey:   "pg-same-idem-1",
			PaymentIntentID:  "pi_pg_same_1",
			ProductIDs:       []string{prodA},
			OrderAmount:      mustDecimal(t, "50000.000000"),
			Currency:         "VND",
		})
	}()
	close(startSame)
	wgSame.Wait()

	if errA != nil || errB != nil {
		t.Fatalf("expected both same-idempotency-key calls across PostgresStore instances to succeed, got errA=%v errB=%v", errA, errB)
	}
	if resA.OrderID != resB.OrderID {
		t.Fatalf("expected identical OrderID across PostgresStore instances, got %q vs %q", resA.OrderID, resB.OrderID)
	}
	if resA.IsReplayed == resB.IsReplayed {
		t.Fatalf("expected exactly one primary and one replay across PostgresStore instances, got replayA=%v replayB=%v", resA.IsReplayed, resB.IsReplayed)
	}

	// 3. Cross-tenant RLS isolation check under app_user
	if rlsRes, err := pgStore2.GetCheckoutResultByIdempotency(ctx, tenantB, "pg-same-idem-1"); err != nil || rlsRes != nil {
		t.Fatalf("RLS violation: tenantB should not read tenantA checkout result by idempotency (res=%+v err=%v)", rlsRes, err)
	}
	if rlsRes, rlsIdem, err := pgStore2.GetCheckoutByPaymentIntent(ctx, tenantB, "pi_pg_same_1"); err != nil || rlsRes != nil || rlsIdem != "" {
		t.Fatalf("RLS violation: tenantB should not read tenantA checkout result by payment_intent_id (res=%+v idem=%q err=%v)", rlsRes, rlsIdem, err)
	}

	// 4. Failure compensation: SaveCheckoutResult failure releases PostgreSQL claim and rolls back posting
	flakyMem := NewMemoryStore()
	flakyStore := &failingSavePostgresStore{
		PostgresStore: NewPostgresStore(appPool, flakyMem),
		failSave:      true,
	}
	flakySvc := NewService(flakyStore, &mockSink{}, func() time.Time { return now })
	if err := flakySvc.UpsertProduct(ctx, &StoreProduct{
		ProductID:   prodA,
		WorkspaceID: tenantA,
		Title:       "PG Cross-Instance Digital Pack",
		Price:       mustDecimal(t, "50000.000000"),
		Currency:    "VND",
		Status:      ProductStatusActive,
	}); err != nil {
		t.Fatalf("UpsertProduct flakySvc: %v", err)
	}
	flakySvc.SetPaymentVerifier(func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
		return PaymentStatusSucceeded, nil
	})
	_, err = flakySvc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      tenantA,
		CustomerEntityID: customerA,
		IdempotencyKey:   "pg-flaky-idem-1",
		PaymentIntentID:  "pi_pg_flaky_1",
		ProductIDs:       []string{prodA},
		OrderAmount:      mustDecimal(t, "50000.000000"),
		Currency:         "VND",
	})
	if err == nil {
		t.Fatalf("expected failure when SaveCheckoutResult fails on PostgresStore")
	}
	postingsAfterFail, _ := flakyMem.ListFinancialPostings(ctx, tenantA)
	if len(postingsAfterFail) != 0 {
		t.Fatalf("expected 0 financial postings after SaveCheckoutResult rollback, got %d", len(postingsAfterFail))
	}

	// Retry after transient failure should succeed because ReleaseCheckoutClaim cleaned up the pending rows
	flakyStore.failSave = false
	retryRes, err := flakySvc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      tenantA,
		CustomerEntityID: customerA,
		IdempotencyKey:   "pg-flaky-idem-1",
		PaymentIntentID:  "pi_pg_flaky_1",
		ProductIDs:       []string{prodA},
		OrderAmount:      mustDecimal(t, "50000.000000"),
		Currency:         "VND",
	})
	if err != nil {
		t.Fatalf("expected retry after transient SaveCheckoutResult failure to succeed, got: %v", err)
	}
	if retryRes.IsReplayed {
		t.Fatalf("expected first successful completion after rollback to have IsReplayed=false")
	}
}

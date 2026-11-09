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
	onFail   func()
}

func (f *failingSavePostgresStore) SaveCheckoutResult(ctx context.Context, workspaceID, idempotencyKey string, res *CheckoutResult) error {
	if f.failSave {
		if f.onFail != nil {
			f.onFail()
		}
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

	// 3b. Cross-instance IdempotencyKey replay with tampered RequestFingerprint or conflicting PaymentIntentID
	//     must fail closed with ErrPaymentReplay on svc2 (proving RequestFingerprint and PaymentIntentID survive JSONB persistence).
	if _, err := svc2.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      tenantA,
		CustomerEntityID: customerA,
		IdempotencyKey:   "pg-same-idem-1",
		PaymentIntentID:  "pi_pg_same_1",
		ProductIDs:       []string{prodA},
		OrderAmount:      mustDecimal(t, "99000.000000"), // tampered amount -> different RequestFingerprint
		Currency:         "VND",
	}); !errors.Is(err, ErrPaymentReplay) {
		t.Fatalf("expected cross-instance replay with tampered OrderAmount on settled IdempotencyKey to fail with ErrPaymentReplay, got %v", err)
	}
	if _, err := svc2.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      tenantA,
		CustomerEntityID: customerA,
		IdempotencyKey:   "pg-same-idem-1",
		PaymentIntentID:  "pi_pg_different_pi", // conflicting PaymentIntentID on settled IdempotencyKey
		ProductIDs:       []string{prodA},
		OrderAmount:      mustDecimal(t, "50000.000000"),
		Currency:         "VND",
	}); !errors.Is(err, ErrPaymentReplay) {
		t.Fatalf("expected cross-instance replay with conflicting PaymentIntentID on settled IdempotencyKey to fail with ErrPaymentReplay, got %v", err)
	}

	// 3c. Cross-instance economic effects visibility: deliveries and financial postings created on svc1/svc2
	//     must be visible on a brand-new third PostgresStore instance (pgStore3) with an empty MemoryStore.
	pgStore3 := NewPostgresStore(appPool, NewMemoryStore())
	delivsOn3, err := pgStore3.ListDeliveriesByCustomer(ctx, tenantA, customerA)
	if err != nil {
		t.Fatalf("pgStore3.ListDeliveriesByCustomer failed: %v", err)
	}
	if len(delivsOn3) != 2 {
		t.Fatalf("expected 2 deliveries (for customerA across the 2 settled checkouts) visible on fresh pgStore3 instance, got %d", len(delivsOn3))
	}
	postingsOn3, err := pgStore3.ListFinancialPostings(ctx, tenantA)
	if err != nil {
		t.Fatalf("pgStore3.ListFinancialPostings failed: %v", err)
	}
	if len(postingsOn3) != 2 {
		t.Fatalf("expected 2 financial postings visible on fresh pgStore3 instance, got %d", len(postingsOn3))
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

type killStage string

const (
	killAfterClaim         killStage = "after_claim"
	killAfterBundleReserve killStage = "after_bundle_reserve"
	killAfterSubscription  killStage = "after_subscription"
	killAfterFirstDelivery killStage = "after_first_delivery"
	killAfterAllDeliveries killStage = "after_all_deliveries"
	killAfterPosting       killStage = "after_posting"
)

type processKillSentinel struct {
	stage killStage
}

type crashInjectingPostgresStore struct {
	*PostgresStore
	stage         killStage
	deliveryCount int
}

func (c *crashInjectingPostgresStore) ClaimCheckout(ctx context.Context, workspaceID, idempotencyKey, paymentIntentID, requestFingerprint string) (*CheckoutResult, string, error) {
	res, orderID, err := c.PostgresStore.ClaimCheckout(ctx, workspaceID, idempotencyKey, paymentIntentID, requestFingerprint)
	if err == nil && c.stage == killAfterClaim {
		panic(processKillSentinel{stage: c.stage})
	}
	return res, orderID, err
}

func (c *crashInjectingPostgresStore) AtomicallyReserveBundleStock(ctx context.Context, workspaceID, bundleID string, quantity int32) error {
	err := c.PostgresStore.AtomicallyReserveBundleStock(ctx, workspaceID, bundleID, quantity)
	if err == nil && c.stage == killAfterBundleReserve {
		panic(processKillSentinel{stage: c.stage})
	}
	return err
}

func (c *crashInjectingPostgresStore) CreateSubscription(ctx context.Context, sub *MembershipSubscription) error {
	err := c.PostgresStore.CreateSubscription(ctx, sub)
	if err == nil && c.stage == killAfterSubscription {
		panic(processKillSentinel{stage: c.stage})
	}
	return err
}

func (c *crashInjectingPostgresStore) CreateDigitalDelivery(ctx context.Context, d *DigitalDelivery) error {
	err := c.PostgresStore.CreateDigitalDelivery(ctx, d)
	if err == nil {
		c.deliveryCount++
		if c.stage == killAfterFirstDelivery && c.deliveryCount == 1 {
			panic(processKillSentinel{stage: c.stage})
		}
		if c.stage == killAfterAllDeliveries && c.deliveryCount == 2 {
			panic(processKillSentinel{stage: c.stage})
		}
	}
	return err
}

func (c *crashInjectingPostgresStore) RecordFinancialPosting(ctx context.Context, posting *FinancialPosting) error {
	err := c.PostgresStore.RecordFinancialPosting(ctx, posting)
	if err == nil && c.stage == killAfterPosting {
		panic(processKillSentinel{stage: c.stage})
	}
	return err
}

func runCheckoutWithSimulatedKill(svc *Service, ctx context.Context, req CheckoutRequest) (killed bool, err error) {
	defer func() {
		if r := recover(); r != nil {
			if _, ok := r.(processKillSentinel); ok {
				killed = true
				return
			}
			panic(r)
		}
	}()
	_, err = svc.Checkout(ctx, req)
	return false, err
}

func TestPostgresLiveM01_ProcessKillTakeoverAndEffectRecovery(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL M01 crash-recovery suite executes when DB is available")
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
		userA   = "11111111-1111-4111-8111-111111111311"
		tenantA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaa311"
		prod1   = "dddddddd-dddd-4ddd-8ddd-ddddddddd311"
		prod2   = "dddddddd-dddd-4ddd-8ddd-ddddddddd312"
		comp1   = "dddddddd-dddd-4ddd-8ddd-ddddddddd313"
	)

	_, err = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ($1::uuid, 'm01_store_ext_a', 'm01_store_a@example.com', 'M01 Store User A', 'active')
		ON CONFLICT (user_id) DO NOTHING
	`, userA)
	if err != nil {
		t.Fatalf("seed user: %v", err)
	}
	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status) VALUES
		  ($1::uuid, 'M01 Store Tenant A', 'm01-store-tenant-a', $2::uuid, 'active')
		ON CONFLICT (workspace_id) DO NOTHING
	`, tenantA, userA)
	if err != nil {
		t.Fatalf("seed workspace: %v", err)
	}
	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspace_members (workspace_id, user_id, role, status) VALUES
		  ($1::uuid, $2::uuid, 'owner', 'active')
		ON CONFLICT (workspace_id, user_id) DO NOTHING
	`, tenantA, userA)
	if err != nil {
		t.Fatalf("seed workspace_member: %v", err)
	}

	appDSN, err := buildAppUserStoreDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserStoreDSN: %v", err)
	}
	appPool, err := pgxpool.New(ctx, appDSN)
	if err != nil {
		t.Fatalf("connect appPool: %v", err)
	}
	defer appPool.Close()

	stages := []killStage{
		killAfterClaim,
		killAfterBundleReserve,
		killAfterSubscription,
		killAfterFirstDelivery,
		killAfterAllDeliveries,
		killAfterPosting,
	}

	for idx, stage := range stages {
		_, _ = adminPool.Exec(ctx, `DELETE FROM external_effects WHERE workspace_id = $1::uuid`, tenantA)

		now := time.Date(2026, 11, 9, 6, 0, 0, 0, time.UTC)
		currentNow := now
		clockFn := func() time.Time { return currentNow }

		customerID := fmt.Sprintf("cccccccc-cccc-4ccc-8ccc-ccccccccc3%02d", idx+10)
		idemKey := fmt.Sprintf("m01-kill-%s-idem", stage)
		piID := fmt.Sprintf("pi_m01_kill_%s", stage)

		// Instance 1 (will be killed mid-checkout without running rollback/ReleaseCheckoutClaim)
		pg1 := NewPostgresStore(appPool, NewMemoryStore())
		crashStore1 := &crashInjectingPostgresStore{PostgresStore: pg1, stage: stage}
		svc1 := NewService(crashStore1, &mockSink{}, clockFn)

		seedM01Catalog := func(s *Service, st Store) (bundleID, planID string) {
			_ = st.SetProductStock(ctx, tenantA, comp1, 10)
			if err := s.UpsertProduct(ctx, &StoreProduct{
				ProductID:   prod1,
				WorkspaceID: tenantA,
				Title:       "M01 Digital Asset 1",
				Price:       mustDecimal(t, "50000.000000"),
				Currency:    "VND",
				Status:      ProductStatusActive,
			}); err != nil {
				t.Fatalf("UpsertProduct 1: %v", err)
			}
			if err := s.UpsertProduct(ctx, &StoreProduct{
				ProductID:   prod2,
				WorkspaceID: tenantA,
				Title:       "M01 Digital Asset 2",
				Price:       mustDecimal(t, "30000.000000"),
				Currency:    "VND",
				Status:      ProductStatusActive,
			}); err != nil {
				t.Fatalf("UpsertProduct 2: %v", err)
			}
			b, err := s.CreateBundle(ctx, &Bundle{
				BundleID:    "eeeeeeee-eeee-4eee-8eee-eeeeeeeee311",
				WorkspaceID: tenantA,
				Title:       "M01 Creator Bundle",
				BundlePrice: mustDecimal(t, "100000.000000"),
				Currency:    "VND",
				Status:      "active",
				Items:       []BundleItem{{ProductID: comp1, Quantity: 2, ProductTitle: "Bundle Component"}},
			})
			if err != nil {
				t.Fatalf("CreateBundle: %v", err)
			}
			p, err := s.CreatePlan(ctx, &MembershipPlan{
				PlanID:          "ffffffff-ffff-4fff-8fff-fffffffff311",
				WorkspaceID:     tenantA,
				Title:           "M01 Creator Club",
				Price:           mustDecimal(t, "120000.000000"),
				Currency:        "VND",
				BillingInterval: "monthly",
				Status:          MembershipPlanStatusActive,
			})
			if err != nil {
				t.Fatalf("CreatePlan: %v", err)
			}
			if _, err := s.PublishPlan(ctx, tenantA, p.PlanID); err != nil {
				t.Fatalf("PublishPlan: %v", err)
			}
			s.SetPaymentVerifier(func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
				return PaymentStatusSucceeded, nil
			})
			return b.BundleID, p.PlanID
		}

		bundleID, planID := seedM01Catalog(svc1, pg1)
		req := CheckoutRequest{
			WorkspaceID:      tenantA,
			CustomerEntityID: customerID,
			IdempotencyKey:   idemKey,
			PaymentIntentID:  piID,
			BundleID:         bundleID,
			MembershipPlanID: planID,
			ProductIDs:       []string{prod1, prod2},
			OrderAmount:      mustDecimal(t, "300000.000000"),
			Currency:         "VND",
		}

		killed, err := runCheckoutWithSimulatedKill(svc1, ctx, req)
		if !killed {
			t.Fatalf("stage %s: expected simulated process kill, got killed=false err=%v", stage, err)
		}

		// Instance 2: Brand-new PostgresStore + Service (empty MemoryStore) retries after process 1 died.
		// Notice we do NOT re-seed catalog or stock on pg2; pg2 must recover catalog, stock, and partial effects from PostgreSQL!
		pg2 := NewPostgresStore(appPool, NewMemoryStore())
		sink2 := &mockSink{}
		svc2 := NewService(pg2, sink2, clockFn)
		svc2.SetPaymentVerifier(func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
			return PaymentStatusSucceeded, nil
		})

		// Advance clock past checkout claim lease TTL so Instance 2 can take over the abandoned 'prepared' claim.
		currentNow = now.Add(10 * time.Second)

		// Negative check: Even after lease expiry, a DIFFERENT idempotency key attempting to hijack the same PaymentIntentID
		// must still fail closed with ErrPaymentReplay.
		hijackReq := req
		hijackReq.IdempotencyKey = idemKey + "-hijack"
		if _, hijackErr := svc2.Checkout(ctx, hijackReq); !errors.Is(hijackErr, ErrPaymentReplay) {
			t.Fatalf("stage %s: expected ErrPaymentReplay when hijacking expired claim with different IdempotencyKey, got %v", stage, hijackErr)
		}

		// Also verify that if a zombie process (pg1) wakes up after a new owner claims it, its stale ReleaseCheckoutClaim is ignored.
		retryCtx, retryCancel := context.WithTimeout(ctx, 250*time.Millisecond)
		res2, err2 := svc2.Checkout(retryCtx, req)
		retryCancel()
		if err2 != nil {
			t.Fatalf("stage %s: M01 BUG REPRODUCED — Instance 2 failed to recover checkout after Process 1 died: %v", stage, err2)
		}
		if res2 == nil || !res2.Success || res2.Status != "confirmed" || res2.IsReplayed {
			t.Fatalf("stage %s: expected confirmed non-replayed checkout result on recovery completion, got %+v", stage, res2)
		}
		if len(res2.Deliveries) != 2 || res2.Subscription == nil {
			t.Fatalf("stage %s: expected 2 deliveries and 1 subscription on recovered checkout, got delivs=%d sub=%+v",
				stage, len(res2.Deliveries), res2.Subscription)
		}

		// Zombie pg1 calling ReleaseCheckoutClaim must not delete the confirmed checkout or a newer owner's claim.
		_ = pg1.ReleaseCheckoutClaim(ctx, tenantA, idemKey, piID)

		// Subsequent retry with same IdempotencyKey + PaymentIntentID replays the confirmed result.
		replayRes, replayErr := svc2.Checkout(ctx, req)
		if replayErr != nil || replayRes == nil || !replayRes.IsReplayed || replayRes.OrderID != res2.OrderID {
			t.Fatalf("stage %s: expected deterministic replay after recovery, got res=%+v err=%v", stage, replayRes, replayErr)
		}

		// Verify across a 3rd fresh instance that effects were executed EXACTLY ONCE (no duplicates).
		pg3 := NewPostgresStore(appPool, NewMemoryStore())
		delivs3, err := pg3.ListDeliveriesByCustomer(ctx, tenantA, customerID)
		if err != nil || len(delivs3) != 2 {
			t.Fatalf("stage %s: expected exactly 2 deliveries in PG, got %d (err=%v)", stage, len(delivs3), err)
		}
		subs3, err := pg3.ListSubscriptionsByCustomer(ctx, tenantA, customerID)
		if err != nil || len(subs3) != 1 {
			t.Fatalf("stage %s: expected exactly 1 subscription in PG, got %d (err=%v)", stage, len(subs3), err)
		}
		postings3, err := pg3.ListFinancialPostings(ctx, tenantA)
		if err != nil || len(postings3) != 1 {
			t.Fatalf("stage %s: expected exactly 1 financial posting in PG, got %d (err=%v)", stage, len(postings3), err)
		}
		stock3, err := pg3.GetProductStock(ctx, tenantA, comp1)
		if err != nil || stock3 != 8 {
			t.Fatalf("stage %s: expected bundle component stock to be deducted once (10 - 2 = 8), got %d (err=%v)", stage, stock3, err)
		}
	}

	// Sub-scenario: Caller context canceled right as SaveCheckoutResult fails in-process.
	// Because rollback() uses context.WithoutCancel(ctx), the claim and partial effects are cleaned up immediately
	// without even needing to wait for lease expiry.
	{
		baseTime := time.Date(2026, 3, 25, 17, 0, 0, 0, time.UTC)
		cancelCtx, cancelFn := context.WithCancel(ctx)
		pgCancel := NewPostgresStore(appPool, NewMemoryStore())
		fStore := &failingSavePostgresStore{
			PostgresStore: pgCancel,
			failSave:      true,
			onFail: func() {
				cancelFn() // Cancel caller context right when SaveCheckoutResult fails
			},
		}
		svcCancel := NewService(fStore, &mockSink{}, func() time.Time { return baseTime })
		_ = pgCancel.SetProductStock(ctx, tenantA, comp1, 10)
		svcCancel.SetPaymentVerifier(func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
			return PaymentStatusSucceeded, nil
		})
		cancelReq := CheckoutRequest{
			WorkspaceID:      tenantA,
			CustomerEntityID: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaa399",
			IdempotencyKey:   "idem-m01-canceled-ctx",
			PaymentIntentID:  "pi-m01-canceled-ctx",
			BundleID:         "eeeeeeee-eeee-4eee-8eee-eeeeeeeee311",
			ProductIDs:       []string{prod1},
			OrderAmount:      mustDecimal(t, "150000.000000"),
			Currency:         "VND",
		}
		if _, err := svcCancel.Checkout(cancelCtx, cancelReq); err == nil {
			t.Fatalf("expected failure from failingSaveStore")
		}
		// Immediately retry on a second instance WITHOUT advancing the clock (proving rollback() succeeded despite canceled ctx).
		pgRetry := NewPostgresStore(appPool, NewMemoryStore())
		svcRetry := NewService(pgRetry, &mockSink{}, func() time.Time { return baseTime })
		svcRetry.SetPaymentVerifier(func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
			return PaymentStatusSucceeded, nil
		})
		resRetry, errRetry := svcRetry.Checkout(ctx, cancelReq)
		if errRetry != nil || resRetry == nil || !resRetry.Success {
			t.Fatalf("expected immediate retry to succeed after canceled-context rollback, got res=%+v err=%v", resRetry, errRetry)
		}
	}
}

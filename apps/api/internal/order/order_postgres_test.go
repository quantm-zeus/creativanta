package order_test

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func TestMigrationsDirectoryResolvable(t *testing.T) {
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	entries, err := os.ReadDir(migrationsDir)
	if err != nil {
		t.Fatalf("expected migrations dir %s to be readable: %v", migrationsDir, err)
	}
	if len(entries) == 0 {
		t.Fatalf("expected migration files in %s", migrationsDir)
	}
}

type fakeRow struct {
	scanFn func(dest ...any) error
}

func (r fakeRow) Scan(dest ...any) error {
	if r.scanFn != nil {
		return r.scanFn(dest...)
	}
	return nil
}

type fakeTx struct {
	tenantSet  string
	userSet    string
	committed  bool
	rolledBack bool
	queries    []string
	failExec   bool
}

func (f *fakeTx) Begin(ctx context.Context) (pgx.Tx, error) { return f, nil }
func (f *fakeTx) Commit(ctx context.Context) error {
	f.committed = true
	return nil
}
func (f *fakeTx) Rollback(ctx context.Context) error {
	f.rolledBack = true
	return nil
}
func (f *fakeTx) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	return 0, nil
}
func (f *fakeTx) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults { return nil }
func (f *fakeTx) LargeObjects() pgx.LargeObjects                               { return pgx.LargeObjects{} }
func (f *fakeTx) Prepare(ctx context.Context, name, sql string) (*pgconn.StatementDescription, error) {
	return nil, nil
}
func (f *fakeTx) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	if f.tenantSet == "" {
		return pgconn.CommandTag{}, errors.New("RLS violation: app.current_tenant_id not set before query")
	}
	f.queries = append(f.queries, sql)
	if f.failExec {
		return pgconn.CommandTag{}, errors.New("simulated database failure")
	}
	return pgconn.NewCommandTag("INSERT 0 1"), nil
}
func (f *fakeTx) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	if f.tenantSet == "" {
		return nil, errors.New("RLS violation: app.current_tenant_id not set before query")
	}
	f.queries = append(f.queries, sql)
	return nil, nil
}
func (f *fakeTx) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row {
	if strings.Contains(sql, "set_config('app.current_tenant_id'") {
		if len(args) >= 1 {
			f.tenantSet, _ = args[0].(string)
		}
		if len(args) >= 2 {
			f.userSet, _ = args[1].(string)
		}
		return fakeRow{scanFn: func(dest ...any) error {
			if len(dest) >= 1 {
				if p, ok := dest[0].(*string); ok {
					*p = f.tenantSet
				}
			}
			if len(dest) >= 2 {
				if p, ok := dest[1].(*string); ok {
					*p = f.userSet
				}
			}
			return nil
		}}
	}
	if f.tenantSet == "" {
		return fakeRow{scanFn: func(dest ...any) error {
			return errors.New("RLS violation: app.current_tenant_id not set before query")
		}}
	}
	f.queries = append(f.queries, sql)
	return fakeRow{scanFn: func(dest ...any) error {
		return pgx.ErrNoRows
	}}
}
func (f *fakeTx) Conn() *pgx.Conn { return nil }

type fakeBeginner struct {
	lastTx *fakeTx
	fail   bool
}

func (b *fakeBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	tx := &fakeTx{failExec: b.fail}
	b.lastTx = tx
	return tx, nil
}

func TestPostgresStoreEnforcesTenantTxAndRollback(t *testing.T) {
	ctx := context.Background()
	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa15"

	beginner := &fakeBeginner{}
	store := order.NewPostgresStoreWithBeginner(beginner)

	// 1. Missing tenant must fail closed
	err := store.CreateOrder(ctx, &order.Order{
		OrderID:     "33333333-3333-3333-3333-333333333333",
		WorkspaceID: "",
		Amount:      tenantdb.MustParseExactDecimal("450000"),
		Currency:    "VND",
	})
	if !errors.Is(err, order.ErrMissingTenant) {
		t.Fatalf("expected ErrMissingTenant, got %v", err)
	}

	// 2. Valid CreateOrder sets app.current_tenant_id and commits
	err = store.CreateOrder(ctx, &order.Order{
		OrderID:        "33333333-3333-3333-3333-333333333333",
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("450000"),
		Currency:       "VND",
		LifecycleState: order.StateCreated,
	})
	if err != nil {
		t.Fatalf("CreateOrder failed: %v", err)
	}
	if beginner.lastTx == nil || beginner.lastTx.tenantSet != wsID {
		t.Fatalf("expected tenant %s set on tx, got %+v", wsID, beginner.lastTx)
	}
	if !beginner.lastTx.committed {
		t.Fatalf("expected transaction to commit")
	}

	// 3. Database error rolls back transaction
	beginner.fail = true
	err = store.CreateOrder(ctx, &order.Order{
		OrderID:        "33333333-3333-3333-3333-333333333334",
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("450000"),
		Currency:       "VND",
		LifecycleState: order.StateCreated,
	})
	if err == nil {
		t.Fatalf("expected error on simulated DB failure")
	}
	if !beginner.lastTx.rolledBack || beginner.lastTx.committed {
		t.Fatalf("expected transaction rollback on error, got committed=%v rolledBack=%v", beginner.lastTx.committed, beginner.lastTx.rolledBack)
	}
}

func TestPostgresLiveOrderStore(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL order suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect pgxpool: %v", err)
	}
	defer pool.Close()

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, pool, migrationsDir); err != nil {
		if errors.Is(err, migrate.ErrChecksumMismatch) {
			_, _ = pool.Exec(ctx, `DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO CURRENT_USER; GRANT USAGE ON SCHEMA public TO PUBLIC;`)
			if _, rErr := migrate.Up(ctx, pool, migrationsDir); rErr != nil {
				t.Fatalf("migrate.Up after schema reset: %v", rErr)
			}
		} else {
			t.Fatalf("migrate.Up: %v", err)
		}
	}

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa15"
	otherWsID := "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb15"
	ordID := "33333333-3333-3333-3333-333333333333"

	// Ensure workspace exists
	_, err = pool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, created_at, updated_at)
		VALUES ('11111111-1111-4111-8111-111111111115'::uuid, 'ext_order_user_15', 'order-user@test.com', 'Order User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa15'::uuid, 'Order Workspace', 'order-ws', '11111111-1111-4111-8111-111111111115'::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb15'::uuid, 'Other Order Workspace', 'other-order-ws', '11111111-1111-4111-8111-111111111115'::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
		DELETE FROM returns WHERE order_id = '33333333-3333-3333-3333-333333333333'::uuid;
		DELETE FROM refunds WHERE order_id = '33333333-3333-3333-3333-333333333333'::uuid;
		DELETE FROM orders WHERE order_id = '33333333-3333-3333-3333-333333333333'::uuid;
	`)
	if err != nil {
		t.Fatalf("seed order workspace fixtures: %v", err)
	}

	appPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect appPool: %v", err)
	}
	defer appPool.Close()
	_, _ = appPool.Exec(ctx, `SET ROLE app_user`)

	store := order.NewPostgresStore(appPool)

	ord := &order.Order{
		OrderID:        ordID,
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("450000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCompleted,
		OrderedAt:      time.Now().UTC(),
		Items: []order.OrderItem{
			{Sku: "PG-SKU-1", Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("225000.000000"), Total: tenantdb.MustParseExactDecimal("450000.000000")},
		},
	}

	if err := store.CreateOrder(ctx, ord); err != nil {
		t.Fatalf("create order: %v", err)
	}

	gotOrd, err := store.GetOrder(ctx, wsID, ordID)
	if err != nil || gotOrd.Amount.String() != "450000" {
		t.Fatalf("get order failed: %v", err)
	}

	if _, err := store.GetOrder(ctx, otherWsID, ordID); err == nil {
		t.Fatalf("expected cross-tenant GetOrder to fail under RLS")
	}

	// Verify PostgresStore refund external deduplication, approval, and partial revert (F09, F10)
	ref1 := &order.Refund{
		WorkspaceID:      wsID,
		OrderID:          ordID,
		RefundType:       "partial",
		Amount:           tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:         "VND",
		Reason:           "pg ref 1",
		LifecycleState:   order.RefundRequested,
		SourceClass:      order.SourceClassOfficial,
		SourcePlatform:   "tiktok",
		ExternalRefundID: "pg-ext-ref-1",
	}
	if err := store.CreateRefund(ctx, ref1); err != nil {
		t.Fatalf("create ref1: %v", err)
	}
	// Duplicate external refund ID with same amount returns existing refund
	ref1Dup := &order.Refund{
		WorkspaceID:      wsID,
		OrderID:          ordID,
		RefundType:       "partial",
		Amount:           tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:         "VND",
		Reason:           "pg ref 1 dup",
		LifecycleState:   order.RefundRequested,
		SourceClass:      order.SourceClassOfficial,
		SourcePlatform:   "tiktok",
		ExternalRefundID: "pg-ext-ref-1",
	}
	if err := store.CreateRefund(ctx, ref1Dup); err != nil || ref1Dup.RefundID != ref1.RefundID {
		t.Fatalf("expected duplicate external refund to return %s, got %s (err=%v)", ref1.RefundID, ref1Dup.RefundID, err)
	}
	// Conflicting amount on same external refund ID must fail with ErrIdempotencyConflict
	ref1Conflict := *ref1Dup
	ref1Conflict.RefundID = ""
	ref1Conflict.Amount = tenantdb.MustParseExactDecimal("150000.000000")
	if err := store.CreateRefund(ctx, &ref1Conflict); !errors.Is(err, order.ErrIdempotencyConflict) {
		t.Fatalf("expected ErrIdempotencyConflict on conflicting external refund amount, got %v", err)
	}

	ref2 := &order.Refund{
		WorkspaceID:      wsID,
		OrderID:          ordID,
		RefundType:       "partial",
		Amount:           tenantdb.MustParseExactDecimal("150000.000000"),
		Currency:         "VND",
		Reason:           "pg ref 2",
		LifecycleState:   order.RefundRequested,
		SourceClass:      order.SourceClassOfficial,
		SourcePlatform:   "tiktok",
		ExternalRefundID: "pg-ext-ref-2",
	}
	if err := store.CreateRefund(ctx, ref2); err != nil {
		t.Fatalf("create ref2: %v", err)
	}

	_, _, prevSt1, prevRef1, _, err := store.ApproveRefundAtomic(ctx, wsID, ref1.RefundID)
	if err != nil {
		t.Fatalf("approve ref1: %v", err)
	}
	if _, _, _, _, _, err := store.ApproveRefundAtomic(ctx, wsID, ref2.RefundID); err != nil {
		t.Fatalf("approve ref2: %v", err)
	}
	// Reverting ref1 after ref2 succeeded must subtract only ref1 (leaving 150000 from ref2)
	if err := store.RevertRefundApproval(ctx, wsID, ref1.RefundID, ordID, prevSt1, prevRef1); err != nil {
		t.Fatalf("revert ref1: %v", err)
	}
	ordAfterRevert, err := store.GetOrder(ctx, wsID, ordID)
	if err != nil || ordAfterRevert.RefundedAmount.String() != "150000" {
		t.Fatalf("expected RefundedAmount=150000 after ref1 revert, got %v (err=%v)", ordAfterRevert, err)
	}

	// Verify PostgresStore return external deduplication and cumulative quantity check (F11, Data #16)
	ret1 := &order.Return{
		WorkspaceID:      wsID,
		OrderID:          ordID,
		ReturnType:       "partial",
		Items:            []order.ReturnItem{{Sku: "PG-SKU-1", Quantity: 2}},
		LifecycleState:   order.ReturnInitiated,
		SourcePlatform:   "tiktok",
		ExternalReturnID: "pg-ext-ret-1",
	}
	if err := store.CreateReturn(ctx, ret1); err != nil {
		t.Fatalf("create ret1: %v", err)
	}
	ret1Dup := &order.Return{
		WorkspaceID:      wsID,
		OrderID:          ordID,
		ReturnType:       "partial",
		Items:            []order.ReturnItem{{Sku: "PG-SKU-1", Quantity: 2}},
		LifecycleState:   order.ReturnReceived,
		SourcePlatform:   "tiktok",
		ExternalReturnID: "pg-ext-ret-1",
	}
	if err := store.CreateReturn(ctx, ret1Dup); err != nil || ret1Dup.ReturnID != ret1.ReturnID {
		t.Fatalf("expected duplicate external return to return %s, got %s (err=%v)", ret1.ReturnID, ret1Dup.ReturnID, err)
	}
	retExcess := &order.Return{
		WorkspaceID:      wsID,
		OrderID:          ordID,
		ReturnType:       "partial",
		Items:            []order.ReturnItem{{Sku: "PG-SKU-1", Quantity: 1}},
		LifecycleState:   order.ReturnInitiated,
		SourcePlatform:   "tiktok",
		ExternalReturnID: "pg-ext-ret-2",
	}
	if err := store.CreateReturn(ctx, retExcess); !errors.Is(err, order.ErrReturnExceedsOrderQuantity) {
		t.Fatalf("expected ErrReturnExceedsOrderQuantity on excess return in PostgresStore, got %v", err)
	}
}

// Data #17: Orders and returns must enforce composite same-tenant foreign keys in PostgreSQL
// so a row in Tenant B cannot reference Tenant A's connected_account_id, product_id, offer_id,
// customer_entity_id, or refund_id.
func TestData17_PostgresCrossTenantOrderAndReturnForeignKeysRejected(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL order suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect pgxpool: %v", err)
	}
	defer pool.Close()

	_, _ = pool.Exec(ctx, `DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO CURRENT_USER; GRANT USAGE ON SCHEMA public TO PUBLIC;`)
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, pool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	const (
		userA   = "11111111-1111-4111-8111-111111111121"
		wsA     = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa21"
		wsB     = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb21"
		connA   = "cccccccc-cccc-4ccc-8ccc-cccccccccc21"
		prodA   = "dddddddd-dddd-4ddd-8ddd-dddddddddd21"
		offerA  = "eeeeeeee-eeee-4eee-8eee-eeeeeeeeee21"
		entityA = "ffffffff-ffff-4fff-8fff-ffffffffff21"
		ordA    = "33333333-3333-4333-8333-333333333321"
		refA    = "44444444-4444-4444-8444-444444444421"
		ordB    = "55555555-5555-4555-8555-555555555521"
	)

	_, err = pool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status)
		VALUES ('11111111-1111-4111-8111-111111111121'::uuid, 'ext_u_d17', 'd17@test.com', 'D17 User', 'active');
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa21'::uuid, 'WS A', 'ws-d17-a', '11111111-1111-4111-8111-111111111121'::uuid, 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb21'::uuid, 'WS B', 'ws-d17-b', '11111111-1111-4111-8111-111111111121'::uuid, 'active');
		INSERT INTO connected_accounts (connected_account_id, workspace_id, platform, account_type, external_account_id, connection_state)
		VALUES ('cccccccc-cccc-4ccc-8ccc-cccccccccc21'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa21'::uuid, 'tiktok', 'creator', 'tt_d17_a', 'connected');
		INSERT INTO products (product_id, workspace_id, title, product_type, base_price, currency, catalog_status)
		VALUES ('dddddddd-dddd-4ddd-8ddd-dddddddddd21'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa21'::uuid, 'Prod A', 'physical', 100000, 'VND', 'active');
		INSERT INTO offers (offer_id, workspace_id, product_id, title, offer_type, pricing_value, pricing_currency, lifecycle_state)
		VALUES ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeee21'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa21'::uuid, 'dddddddd-dddd-4ddd-8ddd-dddddddddd21'::uuid, 'Offer A', 'direct', 100000, 'VND', 'active');
		INSERT INTO entities (entity_id, workspace_id, entity_type, display_name)
		VALUES ('ffffffff-ffff-4fff-8fff-ffffffffff21'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa21'::uuid, 'buyer', 'Customer A');
		INSERT INTO orders (order_id, workspace_id, source_class, lifecycle_state, amount, currency)
		VALUES
		  ('33333333-3333-4333-8333-333333333321'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa21'::uuid, 'official', 'completed', 100000, 'VND'),
		  ('55555555-5555-4555-8555-555555555521'::uuid, 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb21'::uuid, 'official', 'completed', 100000, 'VND');
		INSERT INTO refunds (refund_id, workspace_id, order_id, refund_type, amount, currency, reason, lifecycle_state)
		VALUES ('44444444-4444-4444-8444-444444444421'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa21'::uuid, '33333333-3333-4333-8333-333333333321'::uuid, 'partial', 20000, 'VND', 'test', 'requested');
	`)
	if err != nil {
		t.Fatalf("seed fixtures failed: %v", err)
	}

	tx, err := pool.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback(ctx)

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, wsB, userA); err != nil {
		t.Fatal(err)
	}

	crossTests := []struct {
		name string
		sql  string
		fkID string
	}{
		{
			name: "connected_account_id",
			sql:  `INSERT INTO orders (workspace_id, source_class, lifecycle_state, amount, currency, connected_account_id) VALUES ($1::uuid, 'official', 'created', 100000, 'VND', $2::uuid)`,
			fkID: connA,
		},
		{
			name: "product_id",
			sql:  `INSERT INTO orders (workspace_id, source_class, lifecycle_state, amount, currency, product_id) VALUES ($1::uuid, 'official', 'created', 100000, 'VND', $2::uuid)`,
			fkID: prodA,
		},
		{
			name: "offer_id",
			sql:  `INSERT INTO orders (workspace_id, source_class, lifecycle_state, amount, currency, offer_id) VALUES ($1::uuid, 'official', 'created', 100000, 'VND', $2::uuid)`,
			fkID: offerA,
		},
		{
			name: "customer_entity_id",
			sql:  `INSERT INTO orders (workspace_id, source_class, lifecycle_state, amount, currency, customer_entity_id) VALUES ($1::uuid, 'official', 'created', 100000, 'VND', $2::uuid)`,
			fkID: entityA,
		},
	}

	for _, tc := range crossTests {
		_, _ = tx.Exec(ctx, `SAVEPOINT sp_cross_ord_fk`)
		if _, err := tx.Exec(ctx, tc.sql, wsB, tc.fkID); err == nil {
			t.Fatalf("expected composite tenant FK on orders.%s to reject cross-tenant reference from wsB to wsA", tc.name)
		}
		_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_ord_fk`)
	}

	_, _ = tx.Exec(ctx, `SAVEPOINT sp_cross_ret_fk`)
	if _, err := tx.Exec(ctx, `
		INSERT INTO returns (workspace_id, order_id, refund_id, return_type, lifecycle_state)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'partial', 'initiated')
	`, wsB, ordB, refA); err == nil {
		t.Fatalf("expected composite tenant FK on returns.refund_id to reject cross-tenant refund_id from wsB to wsA")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_ret_fk`)
}

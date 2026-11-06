package inventory_test

import (
	"context"
	"errors"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func buildAppUserDSN(adminDSN string) (string, error) {
	u, err := url.Parse(adminDSN)
	if err != nil {
		return "", err
	}
	u.User = url.UserPassword("app_user", "app_user_test_pw")
	return u.String(), nil
}

func TestMigrationsDirectoryResolvable(t *testing.T) {
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	entries, err := os.ReadDir(migrationsDir)
	if err != nil || len(entries) == 0 {
		t.Fatalf("expected non-empty migrations directory at %s, err: %v", migrationsDir, err)
	}
}

type fakeRow struct {
	scanFn func(dest ...any) error
}

func (r fakeRow) Scan(dest ...any) error {
	return r.scanFn(dest...)
}

type fakeRLSTx struct {
	mu          sync.Mutex
	tenantID    string
	userID      string
	committed   bool
	rolledBack  bool
	execQueries []string
}

func (f *fakeRLSTx) Begin(ctx context.Context) (pgx.Tx, error) { return f, nil }
func (f *fakeRLSTx) Commit(ctx context.Context) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.committed = true
	f.tenantID = ""
	f.userID = ""
	return nil
}
func (f *fakeRLSTx) Rollback(ctx context.Context) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.rolledBack = true
	f.tenantID = ""
	f.userID = ""
	return nil
}
func (f *fakeRLSTx) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	return 0, nil
}
func (f *fakeRLSTx) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults { return nil }
func (f *fakeRLSTx) LargeObjects() pgx.LargeObjects                               { return pgx.LargeObjects{} }
func (f *fakeRLSTx) Prepare(ctx context.Context, name, sql string) (*pgconn.StatementDescription, error) {
	return nil, nil
}
func (f *fakeRLSTx) Conn() *pgx.Conn { return nil }

func (f *fakeRLSTx) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	if f.tenantID == "" {
		return pgconn.CommandTag{}, errors.New("RLS violation: app.current_tenant_id not set in transaction")
	}
	f.execQueries = append(f.execQueries, sql)
	return pgconn.NewCommandTag("UPDATE 1"), nil
}

func (f *fakeRLSTx) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	if f.tenantID == "" {
		return nil, errors.New("RLS violation: app.current_tenant_id not set in transaction")
	}
	return nil, errors.New("unexpected Query in unit test")
}

func (f *fakeRLSTx) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row {
	if strings.Contains(sql, "set_config('app.current_tenant_id'") {
		tID := args[0].(string)
		uID := args[1].(string)
		f.mu.Lock()
		f.tenantID = tID
		f.userID = uID
		f.mu.Unlock()
		return fakeRow{scanFn: func(dest ...any) error {
			*(dest[0].(*string)) = tID
			*(dest[1].(*string)) = uID
			return nil
		}}
	}
	f.mu.Lock()
	hasTenant := f.tenantID != ""
	activeTenant := f.tenantID
	f.mu.Unlock()
	if !hasTenant {
		return fakeRow{scanFn: func(dest ...any) error {
			return errors.New("RLS violation: app.current_tenant_id not set in transaction")
		}}
	}
	if strings.Contains(sql, "FROM inventory_locations") {
		return fakeRow{scanFn: func(dest ...any) error {
			if args[0].(string) != activeTenant {
				return pgx.ErrNoRows
			}
			*(dest[0].(*string)) = args[1].(string)
			*(dest[1].(*string)) = activeTenant
			*(dest[2].(*string)) = "Main Warehouse"
			*(dest[3].(*string)) = "warehouse"
			*(dest[4].(*[]byte)) = []byte(`{}`)
			*(dest[5].(*bool)) = true
			*(dest[6].(*string)) = "active"
			*(dest[7].(*time.Time)) = time.Now().UTC()
			return nil
		}}
	}
	if strings.Contains(sql, "SELECT 1 FROM inventory_balances") {
		return fakeRow{scanFn: func(dest ...any) error {
			*(dest[0].(*int)) = 1
			return nil
		}}
	}
	return fakeRow{scanFn: func(dest ...any) error {
		return pgx.ErrNoRows
	}}
}

type fakeBeginner struct {
	mu  sync.Mutex
	txs []*fakeRLSTx
}

func (b *fakeBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	b.mu.Lock()
	defer b.mu.Unlock()
	tx := &fakeRLSTx{}
	b.txs = append(b.txs, tx)
	return tx, nil
}

func TestPostgresStoreEnforcesTenantTxAndRollback(t *testing.T) {
	ctx := context.Background()
	fb := &fakeBeginner{}
	store := inventory.NewPostgresStoreWithBeginner(fb)

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa14"
	locID := "22222222-2222-4222-8222-222222222222"

	// 1. Missing workspace fails closed without beginning a transaction
	if _, err := store.GetLocation(ctx, "", locID); !errors.Is(err, inventory.ErrMissingTenant) {
		t.Fatalf("expected ErrMissingTenant, got %v", err)
	}
	if len(fb.txs) != 0 {
		t.Fatalf("expected 0 transactions started for missing tenant, got %d", len(fb.txs))
	}

	// 2. CreateLocation and GetLocation execute inside tenant-scoped transaction
	loc := &inventory.Location{
		LocationID:   locID,
		WorkspaceID:  wsID,
		Name:         "Main Warehouse",
		LocationType: "warehouse",
		IsDefault:    true,
		Status:       "active",
	}
	if err := store.CreateLocation(ctx, loc); err != nil {
		t.Fatalf("CreateLocation failed: %v", err)
	}
	if len(fb.txs) != 1 || !fb.txs[0].committed {
		t.Fatalf("expected CreateLocation transaction to commit")
	}

	got, err := store.GetLocation(ctx, wsID, locID)
	if err != nil || got.Name != "Main Warehouse" {
		t.Fatalf("GetLocation failed: %v", err)
	}

	// 3. AtomicExecute sets tenant context and rolls back when callback errors
	expectedErr := errors.New("simulated inventory failure")
	err = store.AtomicExecute(ctx, wsID, []inventory.SkuLocPair{{SkuID: "sku-1", LocationID: locID}}, func(tx inventory.StoreTx) error {
		return expectedErr
	})
	if !errors.Is(err, expectedErr) {
		t.Fatalf("expected %v, got %v", expectedErr, err)
	}
	lastTx := fb.txs[len(fb.txs)-1]
	if !lastTx.rolledBack || lastTx.committed {
		t.Fatalf("expected failed AtomicExecute transaction to roll back")
	}
}

func TestPostgresLiveInventoryStore(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL inventory suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect admin pgxpool: %v", err)
	}
	defer adminPool.Close()

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa14"
	otherWS := "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb14"
	locID := "22222222-2222-2222-2222-222222222222"
	userID := "11111111-1111-4111-8111-111111111114"
	prodID := "77777777-7777-4777-8777-777777777714"
	skuF19 := "33333333-3333-4333-8333-333333333319"
	skuF15 := "44444444-4444-4444-8444-444444444415"
	orderOverbook := "55555555-5555-4555-8555-555555555515"
	orderCoalesce := "66666666-6666-4666-8666-666666666615"

	// Ensure user, workspaces, product, SKUs, and orders exist
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'inv-user@test.com', 'Inv User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING
	`, userID); err != nil {
		t.Fatalf("seed user: %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($1::uuid, 'Inv Workspace', 'inv-ws', $3::uuid, NOW(), NOW()),
		       ($2::uuid, 'Other Workspace', 'other-inv-ws', $3::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING
	`, wsID, otherWS, userID); err != nil {
		t.Fatalf("seed workspaces: %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO products (product_id, workspace_id, product_type, title, base_price, currency, cogs, catalog_status, inventory_enabled, created_at, updated_at)
		VALUES ($1::uuid, $2::uuid, 'physical', 'Inv Test Product', 100000.000000, 'VND', 50000.000000, 'active', true, NOW(), NOW())
		ON CONFLICT (product_id) DO NOTHING
	`, prodID, wsID); err != nil {
		t.Fatalf("seed product: %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO product_skus (sku_id, workspace_id, product_id, sku_code, currency, price_override, cogs_override, stock_quantity, stock_reserved, low_stock_threshold, is_active, created_at, updated_at)
		VALUES ($1::uuid, $3::uuid, $4::uuid, 'SKU-F19', 'VND', 100000.000000, 50000.000000, 0, 0, 5, true, NOW(), NOW()),
		       ($2::uuid, $3::uuid, $4::uuid, 'SKU-F15', 'VND', 100000.000000, 50000.000000, 0, 0, 5, true, NOW(), NOW())
		ON CONFLICT (sku_id) DO NOTHING
	`, skuF19, skuF15, wsID, prodID); err != nil {
		t.Fatalf("seed product_skus: %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO orders (order_id, workspace_id, product_id, amount, currency, lifecycle_state, ordered_at, created_at, updated_at)
		VALUES ($1::uuid, $3::uuid, $4::uuid, 200000.000000, 'VND', 'created', NOW(), NOW(), NOW()),
		       ($2::uuid, $3::uuid, $4::uuid, 200000.000000, 'VND', 'created', NOW(), NOW(), NOW())
		ON CONFLICT (order_id) DO NOTHING
	`, orderOverbook, orderCoalesce, wsID, prodID); err != nil {
		t.Fatalf("seed orders: %v", err)
	}

	appDSN, err := buildAppUserDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserDSN: %v", err)
	}
	appPool, err := pgxpool.New(ctx, appDSN)
	if err != nil {
		t.Fatalf("connect app_user pool: %v", err)
	}
	defer appPool.Close()

	store := inventory.NewPostgresStore(appPool)

	// Create location under app_user (enforcing RLS)
	loc := &inventory.Location{
		LocationID:   locID,
		WorkspaceID:  wsID,
		Name:         "Main Warehouse",
		LocationType: "warehouse",
		IsDefault:    true,
		Status:       "active",
	}
	if err := store.CreateLocation(ctx, loc); err != nil {
		t.Fatalf("create location under app_user: %v", err)
	}

	gotLoc, err := store.GetLocation(ctx, wsID, locID)
	if err != nil || gotLoc.Name != "Main Warehouse" {
		t.Fatalf("get location failed: %v", err)
	}

	// Cross-tenant read under app_user must fail closed
	if _, err := store.GetLocation(ctx, otherWS, locID); !errors.Is(err, inventory.ErrLocationNotFound) {
		t.Fatalf("expected ErrLocationNotFound for cross-tenant read, got %v", err)
	}

	// F19: RecordOpeningBaseline on PostgreSQL must initialize the inventory_balances row, set opening_at, and be idempotent on replay
	now := time.Date(2026, 11, 6, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, &mockSink{}, func() time.Time { return now })
	openingAt := now.Add(-2 * time.Hour)

	if err := svc.RecordOpeningBaseline(ctx, wsID, skuF19, locID, 25, openingAt); err != nil {
		t.Fatalf("F19 RecordOpeningBaseline failed on PostgreSQL: %v", err)
	}
	balF19, err := store.GetBalance(ctx, wsID, skuF19, locID)
	if err != nil {
		t.Fatalf("F19 regression: GetBalance after RecordOpeningBaseline failed: %v", err)
	}
	if balF19.OnHand != 25 || balF19.Reserved != 0 || balF19.OpeningAt == nil {
		t.Fatalf("F19 unexpected balance state: %+v", balF19)
	}
	// Replay of identical baseline must be idempotent
	if err := svc.RecordOpeningBaseline(ctx, wsID, skuF19, locID, 25, openingAt); err != nil {
		t.Fatalf("F19 idempotent baseline replay failed: %v", err)
	}
	// Conflicting baseline count at same timestamp must fail with ErrMovementDuplicate
	if err := svc.RecordOpeningBaseline(ctx, wsID, skuF19, locID, 99, openingAt); !errors.Is(err, inventory.ErrMovementDuplicate) {
		t.Fatalf("F19 expected ErrMovementDuplicate on conflicting baseline replay, got %v", err)
	}

	// F15 on PostgreSQL: Duplicate (sku_id, location_id) lines in ReserveStock must coalesce and never overbook
	if err := svc.RecordOpeningBaseline(ctx, wsID, skuF15, locID, 1, openingAt); err != nil {
		t.Fatalf("RecordOpeningBaseline skuF15: %v", err)
	}
	_, err = svc.ReserveStock(ctx, wsID, orderOverbook, []inventory.ReservationItem{
		{SkuID: skuF15, LocationID: locID, Quantity: 1},
		{SkuID: skuF15, LocationID: locID, Quantity: 1},
	}, 15*time.Minute)
	if !errors.Is(err, inventory.ErrInsufficientStock) {
		t.Fatalf("F15 Postgres regression: expected ErrInsufficientStock on duplicate line overbook, got %v", err)
	}
	// Increase stock to 3 and verify coalesced reservation
	if _, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuF15, 3, "pg-sync-f15"); err != nil {
		t.Fatalf("PlatformSyncAbsoluteCount skuF15: %v", err)
	}
	resF15, err := svc.ReserveStock(ctx, wsID, orderCoalesce, []inventory.ReservationItem{
		{SkuID: skuF15, LocationID: locID, Quantity: 1},
		{SkuID: skuF15, LocationID: locID, Quantity: 1},
	}, 15*time.Minute)
	if err != nil || len(resF15) != 1 || resF15[0].Quantity != 2 {
		t.Fatalf("F15 Postgres coalesced reserve failed: res=%+v err=%v", resF15, err)
	}

	// F14 on PostgreSQL: Replay of PlatformSyncAbsoluteCount after subsequent movement must NOT overwrite OnHand
	if _, err := svc.FulfillReservation(ctx, wsID, orderCoalesce); err != nil {
		t.Fatalf("FulfillReservation orderCoalesce: %v", err)
	}
	// OnHand is now 3 - 2 = 1. Replaying "pg-sync-f15" (count=3) must NOT reset OnHand to 3!
	if _, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuF15, 3, "pg-sync-f15"); err != nil {
		t.Fatalf("F14 Postgres sync replay failed: %v", err)
	}
	balF14, err := store.GetBalance(ctx, wsID, skuF15, locID)
	if err != nil || balF14.OnHand != 1 {
		t.Fatalf("F14 Postgres regression: OnHand is %d (expected 1), err=%v", balF14.OnHand, err)
	}
	if rep, err := svc.ReconcileLedger(ctx, wsID, skuF15, locID); err != nil || rep.Discrepancy != 0 {
		t.Fatalf("F14 Postgres ledger discrepancy: rep=%+v err=%v", rep, err)
	}
	if _, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuF15, 7, "pg-sync-f15"); !errors.Is(err, inventory.ErrMovementDuplicate) {
		t.Fatalf("F14 Postgres expected ErrMovementDuplicate on conflicting syncKey reuse, got %v", err)
	}

	_ = tenantdb.ErrNilContext
}

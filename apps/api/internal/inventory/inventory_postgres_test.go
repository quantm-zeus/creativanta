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

	// Ensure workspaces exist
	_, _ = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'inv-user@test.com', 'Inv User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($2::uuid, 'Inv Workspace', 'inv-ws', $1::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($3::uuid, 'Other Workspace', 'other-inv-ws', $1::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
	`, userID, wsID, otherWS)

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

	_ = tenantdb.ErrNilContext
}

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
		t.Fatalf("migrate.Up: %v", err)
	}

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa15"
	otherWsID := "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb15"
	ordID := "33333333-3333-3333-3333-333333333333"
	userID := "11111111-1111-4111-8111-111111111115"

	// Ensure workspace exists
	_, _ = pool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'order-user@test.com', 'Order User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($2::uuid, 'Order Workspace', 'order-ws', $1::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($3::uuid, 'Other Order Workspace', 'other-order-ws', $1::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
	`, userID, wsID, otherWsID)

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
		LifecycleState: order.StateCreated,
		OrderedAt:      time.Now().UTC(),
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
}

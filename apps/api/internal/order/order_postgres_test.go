package order_test

import (
	"context"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

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

	migrationsDir := filepath.Join("..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, pool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa15"
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
	`, userID, wsID)

	store := order.NewPostgresStore(pool)

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
}

package inventory_test

import (
	"context"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
)

func TestPostgresLiveInventoryStore(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL inventory suite executes in CI")
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

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa14"
	locID := "22222222-2222-2222-2222-222222222222"
	userID := "11111111-1111-4111-8111-111111111114"

	// Ensure workspace exists
	_, _ = pool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'inv-user@test.com', 'Inv User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($2::uuid, 'Inv Workspace', 'inv-ws', $1::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
	`, userID, wsID)

	store := inventory.NewPostgresStore(pool)

	// Create location
	loc := &inventory.Location{
		LocationID:   locID,
		WorkspaceID:  wsID,
		Name:         "Main Warehouse",
		LocationType: "warehouse",
		IsDefault:    true,
		Status:       "active",
	}
	if err := store.CreateLocation(ctx, loc); err != nil {
		t.Fatalf("create location: %v", err)
	}

	gotLoc, err := store.GetLocation(ctx, wsID, locID)
	if err != nil || gotLoc.Name != "Main Warehouse" {
		t.Fatalf("get location failed: %v", err)
	}
}

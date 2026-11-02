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

	store := inventory.NewPostgresStore(pool)
	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "22222222-2222-2222-2222-222222222222"

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

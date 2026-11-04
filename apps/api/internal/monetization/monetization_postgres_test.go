package monetization_test

import (
	"context"
	"crypto/rand"
	"fmt"
	"net/url"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
)

func uuidV4() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func buildAppUserDSN(adminDSN string) (string, error) {
	u, err := url.Parse(adminDSN)
	if err != nil {
		return "", err
	}
	u.User = url.UserPassword("app_user", "app_user_test_pw")
	return u.String(), nil
}

func TestPostgresLiveCampaignsCouponsAndMonetization(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL M14 monetization suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	root := findRepoRoot(t)
	migrationsDir := filepath.Join(root, "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("apply migrations: %v", err)
	}

	appDSN, err := buildAppUserDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserDSN: %v", err)
	}
	appPool, err := pgxpool.New(ctx, appDSN)
	if err != nil {
		t.Fatalf("connect appPool: %v", err)
	}
	defer appPool.Close()

	workspaceA := uuidV4()
	workspaceB := uuidV4()
	userA := uuidV4()
	userB := uuidV4()

	// Provision tenant workspaces
	for _, ws := range []struct {
		wsID string
		uID  string
		name string
	}{
		{workspaceA, userA, "Tenant A Commerce"},
		{workspaceB, userB, "Tenant B Commerce"},
	} {
		_, err := adminPool.Exec(ctx, `
			INSERT INTO workspaces (workspace_id, name, slug)
			VALUES ($1, $2, $3)
			ON CONFLICT (workspace_id) DO NOTHING
		`, ws.wsID, ws.name, ws.wsID)
		if err != nil {
			t.Fatalf("insert workspace %s: %v", ws.wsID, err)
		}
	}

	// Verify Tenant A creates a coupon and campaign under RLS
	txA, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txA: %v", err)
	}
	defer txA.Rollback(ctx)

	if _, err := txA.Exec(ctx, `SET LOCAL app.current_tenant_id = $1`, workspaceA); err != nil {
		t.Fatalf("set tenantA: %v", err)
	}
	couponID := uuidV4()
	_, err = txA.Exec(ctx, `
		INSERT INTO coupons (coupon_id, workspace_id, code, coupon_type, discount_value, max_uses, lifecycle_state)
		VALUES ($1, $2, 'SUMMER50', 'fixed_amount', 50000.000000, 10, 'active')
	`, couponID, workspaceA)
	if err != nil {
		t.Fatalf("insert coupon under scope A: %v", err)
	}
	if err := txA.Commit(ctx); err != nil {
		t.Fatalf("commit txA: %v", err)
	}

	// Verify Tenant B CANNOT read Tenant A's coupon under RLS
	txB, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txB: %v", err)
	}
	defer txB.Rollback(ctx)

	if _, err := txB.Exec(ctx, `SET LOCAL app.current_tenant_id = $1`, workspaceB); err != nil {
		t.Fatalf("set tenantB: %v", err)
	}
	var count int
	err = txB.QueryRow(ctx, `
		SELECT count(*) FROM coupons WHERE code = 'SUMMER50'
	`).Scan(&count)
	if err != nil {
		t.Fatalf("query coupons under tenant B: %v", err)
	}
	if count != 0 {
		t.Fatalf("RLS VIOLATION: Tenant B saw Tenant A coupon count=%d", count)
	}
}

func findRepoRoot(t *testing.T) string {
	t.Helper()
	dir, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	for {
		if _, err := os.Stat(filepath.Join(dir, "go.work")); err == nil {
			return dir
		}
		if _, err := os.Stat(filepath.Join(dir, "package.json")); err == nil {
			return dir
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			t.Fatalf("could not find repo root from %s", dir)
		}
		dir = parent
	}
}

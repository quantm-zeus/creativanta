package product_test

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
	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
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

func TestPostgresLiveProductAndSkuCatalog(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL M13 product catalog suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	// Ensure migrations are up
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	const (
		tenantA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa13"
		tenantB = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb13"
		userA   = "11111111-1111-4111-8111-111111111113"
		userB   = "22222222-2222-4222-8222-222222222213"
	)

	// Clean up previous runs
	_, _ = adminPool.Exec(ctx, `DELETE FROM product_skus WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM products WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM workspace_members WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM workspaces WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM users WHERE user_id IN ($1::uuid, $2::uuid)`, userA, userB)

	// Seed workspace and user
	_, err = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'userA-p1@test.com', 'User A', NOW(), NOW()),
		       ($2::uuid, 'userB-p1@test.com', 'User B', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING
	`, userA, userB)
	if err != nil {
		t.Fatalf("seed users: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($1::uuid, 'Workspace A', 'ws-p1-a', $3::uuid, NOW(), NOW()),
		       ($2::uuid, 'Workspace B', 'ws-p1-b', $4::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING
	`, tenantA, tenantB, userA, userB)
	if err != nil {
		t.Fatalf("seed workspaces: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspace_members (member_id, workspace_id, user_id, role, created_at, updated_at)
		VALUES (gen_random_uuid(), $1::uuid, $3::uuid, 'owner', NOW(), NOW()),
		       (gen_random_uuid(), $2::uuid, $4::uuid, 'owner', NOW(), NOW())
		ON CONFLICT DO NOTHING
	`, tenantA, tenantB, userA, userB)
	if err != nil {
		t.Fatalf("seed members: %v", err)
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

	priceDec, _ := tenantdb.ParseExactDecimal("350000.000000")
	cogsDec, _ := tenantdb.ParseExactDecimal("180000.000000")

	// 1. Insert product as Tenant A under RLS
	txA, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txA: %v", err)
	}
	defer txA.Rollback(ctx)

	_, err = txA.Exec(ctx, `SET LOCAL app.current_tenant_id = $1`, tenantA)
	if err != nil {
		t.Fatalf("set tenantA: %v", err)
	}
	storeA := product.NewPostgresStoreTx(txA)

	prodA := &product.Product{
		ProductID:        uuidV4(),
		WorkspaceID:      tenantA,
		ProductType:      product.TypePhysical,
		Title:            "Balo Laptop Chống Nước",
		Description:      "Balo chống sốc 15.6 inch",
		Category:         "Phụ kiện",
		BasePrice:        &priceDec,
		Currency:         "VND",
		COGS:             &cogsDec,
		CatalogStatus:    product.StatusActive,
		InventoryEnabled: true,
		CreatedAt:        time.Now().UTC(),
		UpdatedAt:        time.Now().UTC(),
		SKUs: []product.ProductSku{
			{
				SkuID:             uuidV4(),
				WorkspaceID:       tenantA,
				SkuCode:           "BALO-LAP-15",
				VariantAttributes: map[string]string{"size": "15.6", "color": "grey"},
				Currency:          "VND",
				LowStockThreshold: 5,
				IsActive:          true,
				CreatedAt:         time.Now().UTC(),
				UpdatedAt:         time.Now().UTC(),
			},
		},
	}
	if err := storeA.CreateProduct(ctx, prodA); err != nil {
		t.Fatalf("storeA CreateProduct: %v", err)
	}
	if err := txA.Commit(ctx); err != nil {
		t.Fatalf("commit txA: %v", err)
	}

	// 2. Tenant B queries Tenant A's product -> must return ErrProductNotFound under RLS
	txB, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txB: %v", err)
	}
	defer txB.Rollback(ctx)

	_, err = txB.Exec(ctx, `SET LOCAL app.current_tenant_id = $1`, tenantB)
	if err != nil {
		t.Fatalf("set tenantB: %v", err)
	}
	storeB := product.NewPostgresStoreTx(txB)

	_, err = storeB.GetProduct(ctx, tenantB, prodA.ProductID)
	if err != product.ErrProductNotFound {
		t.Fatalf("RLS VIOLATION: Tenant B could access Tenant A product: %v", err)
	}

	// 3. Update stock in Tenant A
	txA2, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txA2: %v", err)
	}
	defer txA2.Rollback(ctx)
	_, _ = txA2.Exec(ctx, `SET LOCAL app.current_tenant_id = $1`, tenantA)
	storeA2 := product.NewPostgresStoreTx(txA2)

	newQty, err := storeA2.UpdateSkuStock(ctx, tenantA, prodA.SKUs[0].SkuID, 100)
	if err != nil {
		t.Fatalf("UpdateSkuStock: %v", err)
	}
	if newQty != 100 {
		t.Fatalf("expected 100, got %d", newQty)
	}
	_ = txA2.Commit(ctx)

	t.Log("PASS: Live PostgreSQL RLS isolation, product catalog, and SKU transactions verified.")
}

package product_test

import (
	"context"
	"crypto/rand"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"net"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5/pgxpool"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
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
	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		conn, err := net.DialTimeout("tcp", "127.0.0.1:15432", time.Second)
		if err != nil {
			t.Skip("CREATIVANTA_TEST_DATABASE_URL not set and local Postgres not reachable on 127.0.0.1:15432")
		}
		_ = conn.Close()
		suffix := fmt.Sprintf("%d", time.Now().UnixNano()%1000000)
		roleName := "cv_t7_prod_" + suffix
		rolePass := "cv_t7_pass_" + suffix
		dbName := "cv_t7_prod_db_" + suffix
		createCmd := exec.CommandContext(ctx, "docker", "exec", "creativanta-p0-postgres-1",
			"psql", "-U", "creativanta_dev", "-d", "creativanta_dev", "-v", "ON_ERROR_STOP=1",
			"-c", fmt.Sprintf("CREATE ROLE %s WITH LOGIN SUPERUSER PASSWORD '%s';", roleName, rolePass),
			"-c", fmt.Sprintf("CREATE DATABASE %s OWNER %s;", dbName, roleName),
		)
		if out, err := createCmd.CombinedOutput(); err != nil {
			t.Skipf("local disposable docker postgres setup unavailable: %v (%s)", err, string(out))
		}
		dsn = fmt.Sprintf("postgres://%s:%s@127.0.0.1:15432/%s?sslmode=disable", roleName, rolePass, dbName)
		t.Cleanup(func() {
			cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cleanCancel()
			_ = exec.CommandContext(cleanCtx, "docker", "exec", "creativanta-p0-postgres-1",
				"psql", "-U", "creativanta_dev", "-d", "creativanta_dev",
				"-c", fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE);", dbName),
				"-c", fmt.Sprintf("DROP ROLE IF EXISTS %s;", roleName),
			).Run()
		})
	}

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

	_, err = adminPool.Exec(ctx, `ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw'`)
	if err != nil {
		t.Fatalf("alter app_user login: %v", err)
	}

	const (
		tenantA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa13"
		tenantB = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb13"
		userA   = "11111111-1111-4111-8111-111111111113"
		userB   = "22222222-2222-4222-8222-222222222213"
	)

	// Clean up previous runs
	_, _ = adminPool.Exec(ctx, `DELETE FROM refunds WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM stock_movements WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM inventory_balances WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM inventory_locations WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM orders WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM api_idempotency_records WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
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
	t0 := time.Date(2026, 11, 6, 10, 0, 0, 0, time.UTC)

	// 1. Insert product as Tenant A under RLS
	txA, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txA: %v", err)
	}
	defer txA.Rollback(ctx)

	_, err = txA.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_workspace_id', $1, true)`, tenantA)
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
		CreatedAt:        t0,
		UpdatedAt:        t0,
		SKUs: []product.ProductSku{
			{
				SkuID:             uuidV4(),
				WorkspaceID:       tenantA,
				SkuCode:           "BALO-LAP-15",
				VariantAttributes: map[string]string{"size": "15.6", "color": "grey"},
				Currency:          "VND",
				LowStockThreshold: 5,
				IsActive:          true,
				CreatedAt:         t0,
				UpdatedAt:         t0,
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

	_, err = txB.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_workspace_id', $1, true)`, tenantB)
	if err != nil {
		t.Fatalf("set tenantB: %v", err)
	}
	storeB := product.NewPostgresStoreTx(txB)

	_, err = storeB.GetProduct(ctx, tenantB, prodA.ProductID)
	if err != product.ErrProductNotFound {
		t.Fatalf("RLS VIOLATION: Tenant B could access Tenant A product: %v", err)
	}
	_ = txB.Rollback(ctx)

	// 3. F01: Update stock in Tenant A -> must append stock_movements, upsert inventory_balances, and update product_skus
	txA2, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txA2: %v", err)
	}
	defer txA2.Rollback(ctx)
	_, _ = txA2.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_workspace_id', $1, true)`, tenantA)
	storeA2 := product.NewPostgresStoreTx(txA2)

	skuID := prodA.SKUs[0].SkuID
	adjCtx := product.WithStockAdjustmentMeta(ctx, "initial_stock_count", "pg-adj-1")
	newQty, err := storeA2.UpdateSkuStock(adjCtx, tenantA, skuID, 100)
	if err != nil {
		t.Fatalf("UpdateSkuStock: %v", err)
	}
	if newQty != 100 {
		t.Fatalf("expected 100, got %d", newQty)
	}

	// Verify stock_movements row was written
	var mvCount int
	var mvQty int32
	var mvReason, mvType string
	if err := txA2.QueryRow(ctx, `
		SELECT COUNT(*), MAX(quantity), MAX(reason), MAX(movement_type::text)
		FROM stock_movements
		WHERE workspace_id = $1::uuid AND sku_id = $2::uuid
	`, tenantA, skuID).Scan(&mvCount, &mvQty, &mvReason, &mvType); err != nil {
		t.Fatalf("query stock_movements: %v", err)
	}
	if mvCount != 1 || mvQty != 100 || mvReason != "initial_stock_count" || mvType != "adjustment" {
		t.Fatalf("unexpected stock_movements row: count=%d qty=%d reason=%q type=%q", mvCount, mvQty, mvReason, mvType)
	}

	// Verify inventory_balances row was upserted
	var balOnHand int32
	if err := txA2.QueryRow(ctx, `
		SELECT on_hand FROM inventory_balances WHERE workspace_id = $1::uuid AND sku_id = $2::uuid
	`, tenantA, skuID).Scan(&balOnHand); err != nil {
		t.Fatalf("query inventory_balances: %v", err)
	}
	if balOnHand != 100 {
		t.Fatalf("expected inventory_balances.on_hand=100, got %d", balOnHand)
	}

	// Idempotent replay with same movement_key returns 100 without duplicating movement
	replayQty, err := storeA2.UpdateSkuStock(adjCtx, tenantA, skuID, 100)
	if err != nil {
		t.Fatalf("replay UpdateSkuStock failed: %v", err)
	}
	if replayQty != 100 {
		t.Fatalf("expected replayQty=100, got %d", replayQty)
	}
	if err := txA2.QueryRow(ctx, `SELECT COUNT(*) FROM stock_movements WHERE workspace_id = $1::uuid AND sku_id = $2::uuid`, tenantA, skuID).Scan(&mvCount); err != nil {
		t.Fatalf("recount stock_movements: %v", err)
	}
	if mvCount != 1 {
		t.Fatalf("expected 1 stock movement after replay, got %d", mvCount)
	}

	// Conflicting replay with same movement_key and different delta must return ErrIdempotencyConflict
	if _, err := storeA2.UpdateSkuStock(adjCtx, tenantA, skuID, 50); !errors.Is(err, product.ErrIdempotencyConflict) {
		t.Fatalf("expected ErrIdempotencyConflict on conflicting movement_key replay, got %v", err)
	}

	// Negative stock adjustment (-150 from 100) must return ErrInsufficientStock
	negCtx := product.WithStockAdjustmentMeta(ctx, "shrinkage", "pg-adj-neg")
	if _, err := storeA2.UpdateSkuStock(negCtx, tenantA, skuID, -150); !errors.Is(err, product.ErrInsufficientStock) {
		t.Fatalf("expected ErrInsufficientStock on negative resulting stock, got %v", err)
	}

	// 4. Data review #8: Optimistic concurrency (ExpectedUpdatedAt) on UpdateProduct
	staleTime := t0.Add(-5 * time.Minute)
	prodA.Title = "Stale Update Attempt"
	prodA.ExpectedUpdatedAt = &staleTime
	if err := storeA2.UpdateProduct(ctx, prodA); !errors.Is(err, product.ErrConcurrencyConflict) {
		t.Fatalf("expected ErrConcurrencyConflict on stale ExpectedUpdatedAt, got %v", err)
	}

	prodA.Title = "Balo Laptop Chống Nước Pro"
	prodA.ExpectedUpdatedAt = &t0
	prodA.UpdatedAt = t0.Add(time.Minute)
	if err := storeA2.UpdateProduct(ctx, prodA); err != nil {
		t.Fatalf("UpdateProduct with matching ExpectedUpdatedAt failed: %v", err)
	}

	// 5. Data review #6: api_idempotency_records persistence and conflict detection
	if err := storeA2.SaveIdempotencyRecord(ctx, product.IdempotencyRecord{
		WorkspaceID:    tenantA,
		IdempotencyKey: "pg-idem-key-1",
		RequestHash:    "hash-abc",
		ResponseStatus: 200,
		ResponseBody:   []byte(`{"product_id":"` + prodA.ProductID + `"}`),
	}); err != nil {
		t.Fatalf("SaveIdempotencyRecord failed: %v", err)
	}
	if err := storeA2.SaveIdempotencyRecord(ctx, product.IdempotencyRecord{
		WorkspaceID:    tenantA,
		IdempotencyKey: "pg-idem-key-1",
		RequestHash:    "hash-different",
		ResponseStatus: 200,
		ResponseBody:   []byte(`{}`),
	}); !errors.Is(err, product.ErrIdempotencyConflict) {
		t.Fatalf("expected ErrIdempotencyConflict on mismatched request_hash, got %v", err)
	}

	// 6. Data review #13 & #20: Seed second product + order and verify keyset pagination, sales summary, chart, and rank
	prodA2 := &product.Product{
		ProductID:        uuidV4(),
		WorkspaceID:      tenantA,
		ProductType:      product.TypePhysical,
		Title:            "Túi Chống Sốc 14 inch",
		Category:         "Phụ kiện",
		BasePrice:        &priceDec,
		Currency:         "VND",
		COGS:             &cogsDec,
		CatalogStatus:    product.StatusActive,
		InventoryEnabled: true,
		CreatedAt:        t0.Add(2 * time.Minute),
		UpdatedAt:        t0.Add(2 * time.Minute),
	}
	if err := storeA2.CreateProduct(ctx, prodA2); err != nil {
		t.Fatalf("CreateProduct prodA2: %v", err)
	}

	// Keyset cursor test: page 1 (limit 1) returns prodA2; page 2 with cursor=(prodA2.CreatedAt, prodA2.ProductID) returns prodA
	page1, total, err := storeA2.ListProducts(ctx, tenantA, product.ListFilter{Category: "Phụ kiện"}, 1, 0)
	if err != nil || total != 2 || len(page1) != 1 || page1[0].ProductID != prodA2.ProductID {
		t.Fatalf("unexpected page1: len=%d total=%d err=%v", len(page1), total, err)
	}
	cursorTS := page1[0].CreatedAt
	page2, total2, err := storeA2.ListProducts(ctx, tenantA, product.ListFilter{
		Category:        "Phụ kiện",
		CursorCreatedAt: &cursorTS,
		CursorProductID: page1[0].ProductID,
	}, 1, 0)
	if err != nil || total2 != 2 || len(page2) != 1 || page2[0].ProductID != prodA.ProductID {
		t.Fatalf("unexpected keyset page2: len=%d total=%d err=%v", len(page2), total2, err)
	}

	// Seed an order for prodA and verify GetProductSalesSummary, GetProductSalesChart, and GetProductRank
	_, err = txA2.Exec(ctx, `
		INSERT INTO orders (
			order_id, workspace_id, product_id, amount, currency, items, lifecycle_state, ordered_at
		) VALUES (
			$1::uuid, $2::uuid, $3::uuid, 700000.000000, 'VND', $4::jsonb, 'completed', NOW()
		)
	`, uuidV4(), tenantA, prodA.ProductID, fmt.Sprintf(`[{"product_id":%q,"sku":%q,"quantity":2,"unit_price":"350000.000000","total":"700000.000000","unit_cogs":"180000.000000"}]`, prodA.ProductID, skuID))
	if err != nil {
		t.Fatalf("insert order: %v", err)
	}

	summary, err := storeA2.GetProductSalesSummary(ctx, tenantA, prodA.ProductID)
	if err != nil {
		t.Fatalf("GetProductSalesSummary: %v", err)
	}
	if summary.UnitsSold != 2 || summary.GrossRevenue.String() != "700000" || summary.TotalCOGS.String() != "360000" || summary.TotalProfit.String() != "340000" || summary.StockMovements != 1 {
		t.Fatalf("unexpected sales summary: %+v", summary)
	}

	chart, err := storeA2.GetProductSalesChart(ctx, tenantA, prodA.ProductID, 30)
	if err != nil || len(chart) != 1 || chart[0].UnitsSold != 2 {
		t.Fatalf("unexpected sales chart: %+v (err=%v)", chart, err)
	}

	rankA, err := storeA2.GetProductRank(ctx, tenantA, prodA.ProductID)
	if err != nil {
		t.Fatalf("GetProductRank prodA: %v", err)
	}
	rankA2, err := storeA2.GetProductRank(ctx, tenantA, prodA2.ProductID)
	if err != nil {
		t.Fatalf("GetProductRank prodA2: %v", err)
	}
	if rankA.WorkspaceRank != 1 || rankA2.WorkspaceRank != 2 {
		t.Fatalf("expected prodA rank 1 and prodA2 rank 2, got %d and %d", rankA.WorkspaceRank, rankA2.WorkspaceRank)
	}

	// 7. Second-pass Data F2: Multi-location stock adjustment without double counting + opening_balance ledger row
	openingSkuID := uuidV4()
	if err := storeA2.CreateSku(ctx, &product.ProductSku{
		SkuID:             openingSkuID,
		WorkspaceID:       tenantA,
		ProductID:         prodA2.ProductID,
		SkuCode:           "TUI-14-OPEN",
		VariantAttributes: map[string]string{"color": "black"},
		Currency:          "VND",
		StockQuantity:     15,
		LowStockThreshold: 3,
		IsActive:          true,
		CreatedAt:         t0,
		UpdatedAt:         t0,
	}); err != nil {
		t.Fatalf("CreateSku with opening stock: %v", err)
	}
	var openMovCount int
	var openMovQty int32
	if err := txA2.QueryRow(ctx, `
		SELECT COUNT(*), COALESCE(SUM(quantity), 0)
		FROM stock_movements
		WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND movement_type = 'opening_balance'
	`, tenantA, openingSkuID).Scan(&openMovCount, &openMovQty); err != nil {
		t.Fatalf("query opening_balance stock_movements: %v", err)
	}
	if openMovCount != 1 || openMovQty != 15 {
		t.Fatalf("expected 1 opening_balance movement of 15, got count=%d qty=%d", openMovCount, openMovQty)
	}

	// Create a second location (Location A) holding 10 units of a new SKU, while default Location B has NO balance row yet
	multiLocSkuID := uuidV4()
	if err := storeA2.CreateSku(ctx, &product.ProductSku{
		SkuID:             multiLocSkuID,
		WorkspaceID:       tenantA,
		ProductID:         prodA2.ProductID,
		SkuCode:           "TUI-14-MULTILOC",
		VariantAttributes: map[string]string{"color": "navy"},
		Currency:          "VND",
		StockQuantity:     0,
		LowStockThreshold: 2,
		IsActive:          true,
		CreatedAt:         t0,
		UpdatedAt:         t0,
	}); err != nil {
		t.Fatalf("CreateSku multiLocSkuID: %v", err)
	}
	locAID := uuidV4()
	if _, err := txA2.Exec(ctx, `
		INSERT INTO inventory_locations (location_id, workspace_id, name, location_type, is_default, status, created_at)
		VALUES ($1::uuid, $2::uuid, 'Secondary Warehouse', 'warehouse', FALSE, 'active', NOW())
	`, locAID, tenantA); err != nil {
		t.Fatalf("insert secondary location: %v", err)
	}
	locACtx := product.WithStockAdjustmentLocation(product.WithStockAdjustmentMeta(ctx, "seed_loc_a", "pg-f2-loc-a"), locAID)
	if qtyAfterLocA, err := storeA2.UpdateSkuStock(locACtx, tenantA, multiLocSkuID, 10); err != nil || qtyAfterLocA != 10 {
		t.Fatalf("UpdateSkuStock at locA failed: qty=%d err=%v", qtyAfterLocA, err)
	}
	// Now adjust stock by +5 at the default location (which has no inventory_balances row for multiLocSkuID yet!)
	defCtx := product.WithStockAdjustmentMeta(ctx, "receive_default_loc", "pg-f2-def-loc")
	qtyAfterDef, err := storeA2.UpdateSkuStock(defCtx, tenantA, multiLocSkuID, 5)
	if err != nil {
		t.Fatalf("UpdateSkuStock at default location failed: %v", err)
	}
	if qtyAfterDef != 15 {
		t.Fatalf("Data F2 regression in Postgres: expected total stock 15 (10 + 5), got %d", qtyAfterDef)
	}
	var sumBalances, sumMovements, skuStock int32
	if err := txA2.QueryRow(ctx, `SELECT COALESCE(SUM(on_hand), 0) FROM inventory_balances WHERE workspace_id = $1::uuid AND sku_id = $2::uuid`, tenantA, multiLocSkuID).Scan(&sumBalances); err != nil {
		t.Fatalf("sum inventory_balances: %v", err)
	}
	if err := txA2.QueryRow(ctx, `SELECT COALESCE(SUM(quantity), 0) FROM stock_movements WHERE workspace_id = $1::uuid AND sku_id = $2::uuid`, tenantA, multiLocSkuID).Scan(&sumMovements); err != nil {
		t.Fatalf("sum stock_movements: %v", err)
	}
	if err := txA2.QueryRow(ctx, `SELECT stock_quantity FROM product_skus WHERE workspace_id = $1::uuid AND sku_id = $2::uuid`, tenantA, multiLocSkuID).Scan(&skuStock); err != nil {
		t.Fatalf("select product_skus.stock_quantity: %v", err)
	}
	if sumBalances != 15 || sumMovements != 15 || skuStock != 15 {
		t.Fatalf("Data F2 ledger mismatch: balances=%d movements=%d skuStock=%d (want 15, 15, 15)", sumBalances, sumMovements, skuStock)
	}

	// 8. Second-pass Data F6: Multi-product order with partial refund allocates proportionally
	multiOrderID := uuidV4()
	_, err = txA2.Exec(ctx, `
		INSERT INTO orders (
			order_id, workspace_id, product_id, amount, currency, items, lifecycle_state, ordered_at
		) VALUES (
			$1::uuid, $2::uuid, $3::uuid, 1000000.000000, 'VND', $4::jsonb, 'partially_refunded', NOW()
		)
	`, multiOrderID, tenantA, prodA.ProductID, fmt.Sprintf(
		`[{"product_id":%q,"quantity":2,"unit_price":"350000.000000","total":"700000.000000","unit_cogs":"180000.000000"},{"product_id":%q,"quantity":1,"unit_price":"300000.000000","total":"300000.000000","unit_cogs":"150000.000000"}]`,
		prodA.ProductID, prodA2.ProductID,
	))
	if err != nil {
		t.Fatalf("insert multi-product order: %v", err)
	}
	_, err = txA2.Exec(ctx, `
		INSERT INTO refunds (
			refund_id, workspace_id, order_id, refund_type, amount, currency, reason, lifecycle_state, created_at, updated_at
		) VALUES (
			$1::uuid, $2::uuid, $3::uuid, 'partial', 100000.000000, 'VND', 'partial_discount', 'completed', NOW(), NOW()
		)
	`, uuidV4(), tenantA, multiOrderID)
	if err != nil {
		t.Fatalf("insert partial refund: %v", err)
	}
	sumA2, err := storeA2.GetProductSalesSummary(ctx, tenantA, prodA2.ProductID)
	if err != nil {
		t.Fatalf("GetProductSalesSummary prodA2: %v", err)
	}
	// prodA2 has 300,000 VND out of 1,000,000 VND order (30%), so its share of 100,000 VND refund is 30,000 VND -> NetRevenue = 270,000 VND
	if sumA2.GrossRevenue.String() != "300000" || sumA2.NetRevenue.String() != "270000" || sumA2.RefundCount != 1 {
		t.Fatalf("Data F6 Postgres regression: expected prodA2 gross=300000 net=270000 refunds=1, got %+v", sumA2)
	}

	// 9. Second-pass Data F7 & F8: Multi-currency order FX conversion / fail-closed and period window in Postgres
	fxOrderID := uuidV4()
	_, err = txA2.Exec(ctx, `
		INSERT INTO orders (
			order_id, workspace_id, product_id, amount, currency, items, exchange_rate_snapshot, lifecycle_state, ordered_at
		) VALUES (
			$1::uuid, $2::uuid, $3::uuid, 10.000000, 'USD', $4::jsonb, '{}'::jsonb, 'completed', NOW() - INTERVAL '45 days'
		)
	`, fxOrderID, tenantA, prodA2.ProductID, fmt.Sprintf(
		`[{"product_id":%q,"quantity":1,"unit_price":"10.000000","total":"10.000000","unit_cogs":"4.000000"}]`,
		prodA2.ProductID,
	))
	if err != nil {
		t.Fatalf("insert cross-currency order without FX snapshot: %v", err)
	}
	// All-time summary must fail closed with ErrCurrencyMismatch because the 45-day-old USD order lacks exchange_rate_snapshot
	if _, err := storeA2.GetProductSalesSummary(ctx, tenantA, prodA2.ProductID); !errors.Is(err, product.ErrCurrencyMismatch) {
		t.Fatalf("Data F7 Postgres regression: expected ErrCurrencyMismatch for USD order without FX snapshot, got %v", err)
	}
	// 7-day period filter excludes the 45-day-old USD order and succeeds (Data F8)
	since7d := time.Now().UTC().Add(-7 * 24 * time.Hour)
	ctx7d := product.WithSalesStatsFilter(ctx, product.SalesStatsFilter{Period: "7d", Since: &since7d})
	sum7d, err := storeA2.GetProductSalesSummary(ctx7d, tenantA, prodA2.ProductID)
	if err != nil || sum7d.UnitsSold != 1 || sum7d.NetRevenue.String() != "270000" {
		t.Fatalf("Data F8 Postgres regression: expected 7d summary units=1 net=270000, got %+v (err=%v)", sum7d, err)
	}
	// Attach valid exchange_rate_snapshot (1 USD = 25,000 VND) and verify all-time summary converts 10 USD -> 250,000 VND
	_, err = txA2.Exec(ctx, `
		UPDATE orders
		SET exchange_rate_snapshot = '{"base_currency":"VND","quote_currency":"USD","rate_to_base":"25000.000000"}'::jsonb
		WHERE workspace_id = $1::uuid AND order_id = $2::uuid
	`, tenantA, fxOrderID)
	if err != nil {
		t.Fatalf("update order FX snapshot: %v", err)
	}
	sumAll, err := storeA2.GetProductSalesSummary(ctx, tenantA, prodA2.ProductID)
	if err != nil || sumAll.UnitsSold != 2 || sumAll.GrossRevenue.String() != "550000" || sumAll.NetRevenue.String() != "520000" {
		t.Fatalf("Data F7 Postgres regression: expected converted gross=550000 net=520000 units=2, got %+v (err=%v)", sumAll, err)
	}

	// 10. Second-pass Data F10: Store-level ArchiveProduct and DeleteProduct enforce ExpectedUpdatedAt atomically
	staleExpected := t0.Add(-10 * time.Minute)
	staleCtx := product.WithExpectedUpdatedAt(ctx, &staleExpected)
	if err := storeA2.ArchiveProduct(staleCtx, tenantA, prodA2.ProductID); !errors.Is(err, product.ErrConcurrencyConflict) {
		t.Fatalf("Data F10 Postgres regression: expected ErrConcurrencyConflict on stale ArchiveProduct, got %v", err)
	}
	if err := storeA2.DeleteProduct(staleCtx, tenantA, prodA2.ProductID); !errors.Is(err, product.ErrConcurrencyConflict) {
		t.Fatalf("Data F10 Postgres regression: expected ErrConcurrencyConflict on stale DeleteProduct, got %v", err)
	}

	if err := txA2.Commit(ctx); err != nil {
		t.Fatalf("commit txA2: %v", err)
	}

	// 11. Second-pass Data F1 & F11: Pool-backed PostgresStore + Handler atomic idempotency & Update clear/inventory_enabled
	poolStore := product.NewPostgresStore(appPool)
	sink := product.NewMemoryEventSink()
	svc := product.NewService(poolStore, sink, func() time.Time { return t0 })
	h := product.NewHandler(svc)
	callerCtx := product.WithCaller(ctx, tenantA, userA, rbac.RoleOwner)

	emptyStr := ""
	invFalse := false
	updResp, err := h.Update(callerCtx, connect.NewRequest(&commercev1.UpdateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: tenantA},
			IdempotencyKey: "pg-f1-f11-atomic-update",
		},
		ProductId:        prodA2.ProductID,
		Category:         &emptyStr,
		InventoryEnabled: &invFalse,
	}))
	if err != nil {
		t.Fatalf("Handler.Update via pool-backed PostgresStore failed: %v", err)
	}
	if updResp.Msg.Product.InventoryEnabled || updResp.Msg.Product.Category != "" {
		t.Fatalf("Data F11 Postgres regression: expected InventoryEnabled=false and Category=\"\", got inv=%v cat=%q",
			updResp.Msg.Product.InventoryEnabled, updResp.Msg.Product.Category)
	}

	// 12. Second-pass Data F13 & F15 on PostgreSQL: Reject cross-currency BasePrice/COGS update & verify long cursor <= 512 chars
	if _, err := h.Update(callerCtx, connect.NewRequest(&commercev1.UpdateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: tenantA},
			IdempotencyKey: "pg-f13-reject-usd-price-on-vnd",
		},
		ProductId: prodA2.ProductID,
		BasePrice: &commonv1.Money{Amount: "15.000000", Currency: "USD"},
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("Data F13 Postgres regression: expected CodeInvalidArgument on USD BasePrice update for VND product, got %v", err)
	}

	longSearch := strings.Repeat("TìmKiếmSảnPhẩm", 20)
	listP1, err := h.List(callerCtx, connect.NewRequest(&commercev1.ListRequest{
		Pagination: &commonv1.Pagination{PageSize: 1},
	}))
	if err != nil {
		t.Fatalf("Handler.List page 1 on Postgres failed: %v", err)
	}
	if listP1.Msg.Pagination.GetHasMore() {
		tok := listP1.Msg.Pagination.GetNextPageToken()
		if len(tok) == 0 || len(tok) > 512 {
			t.Fatalf("Data F15 Postgres regression: unexpected token length %d", len(tok))
		}
		if _, err := h.List(callerCtx, connect.NewRequest(&commercev1.ListRequest{
			Pagination:  &commonv1.Pagination{PageSize: 1, PageToken: tok},
			SearchQuery: longSearch,
		})); connect.CodeOf(err) != connect.CodeInvalidArgument {
			t.Fatalf("Data F15 Postgres regression: expected CodeInvalidArgument on tampered SearchQuery with cursor, got %v", err)
		}
	}

	// 13. Remediation M05, N1, N2, N3 on PostgreSQL with pool-backed adapter store (matching runtimeassembly tenantProductStore)
	if _, err := h.UpdateStock(callerCtx, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: tenantA},
			IdempotencyKey: "pg-m05-overflow-reject",
		},
		SkuId:         skuID,
		DeltaQuantity: math.MaxInt32,
		Reason:        "overflow_attempt",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("M05 Postgres regression: expected CodeInvalidArgument on int32 overflow in UpdateStock, got %v", err)
	}

	adapterStore := &poolAdapterProductStore{pool: adminPool}
	adapterSvc := product.NewService(adapterStore, product.NewMemoryEventSink(), func() time.Time { return t0 })
	adapterHandler := product.NewHandler(adapterSvc)

	n1CreateResp, err := adapterHandler.Create(callerCtx, connect.NewRequest(&commercev1.CreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: tenantA},
			IdempotencyKey: "pg-n1-adapter-create-1",
		},
		ProductType:      commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:            "Micro Thu Âm Không Dây Pro",
		Category:         "Audio",
		BasePrice:        &commonv1.Money{Amount: "950000.000000", Currency: "VND"},
		Currency:         "VND",
		InventoryEnabled: true,
		MetadataJson:     `{"search_index":{"document_id":"pending","workspace_id":"` + tenantA + `","title":"Micro Thu Âm Không Dây Pro"}}`,
		InitialSkus: []*commercev1.ProductSku{
			{
				SkuCode:       "MIC-PRO-01",
				Currency:      "VND",
				StockQuantity: 10,
				IsActive:      true,
			},
		},
	}))
	if err != nil {
		t.Fatalf("N1 adapterHandler.Create failed: %v", err)
	}
	n1ProdID := n1CreateResp.Msg.Product.ProductId
	n1SkuID := n1CreateResp.Msg.Product.Skus[0].SkuId

	// Replay with identical idempotency key must return the exact same product without creating a second row
	n1ReplayResp, err := adapterHandler.Create(callerCtx, connect.NewRequest(&commercev1.CreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: tenantA},
			IdempotencyKey: "pg-n1-adapter-create-1",
		},
		ProductType:      commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:            "Micro Thu Âm Không Dây Pro",
		Category:         "Audio",
		BasePrice:        &commonv1.Money{Amount: "950000.000000", Currency: "VND"},
		Currency:         "VND",
		InventoryEnabled: true,
		MetadataJson:     `{"search_index":{"document_id":"pending","workspace_id":"` + tenantA + `","title":"Micro Thu Âm Không Dây Pro"}}`,
		InitialSkus: []*commercev1.ProductSku{
			{
				SkuCode:       "MIC-PRO-01",
				Currency:      "VND",
				StockQuantity: 10,
				IsActive:      true,
			},
		},
	}))
	if err != nil || n1ReplayResp.Msg.Product.ProductId != n1ProdID {
		t.Fatalf("N1 Postgres replay mismatch: got=%v want=%s err=%v", n1ReplayResp, n1ProdID, err)
	}

	// UpdateStock via adapterHandler must write event_outbox row containing movement_id, location_id, movement_type="adjustment", quantity=15
	if _, err := adapterHandler.UpdateStock(callerCtx, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: tenantA},
			IdempotencyKey: "pg-n2-adapter-stock-1",
		},
		SkuId:         n1SkuID,
		DeltaQuantity: 15,
		Reason:        "warehouse_restock",
	})); err != nil {
		t.Fatalf("N2 adapterHandler.UpdateStock failed: %v", err)
	}
	var outboxPayloadRaw []byte
	if err := adminPool.QueryRow(ctx, `
		SELECT payload
		FROM event_outbox
		WHERE workspace_id = $1::uuid AND aggregate_id = $2::uuid AND event_type = 'inventory.stock_moved'
		ORDER BY created_at DESC LIMIT 1
	`, tenantA, n1SkuID).Scan(&outboxPayloadRaw); err != nil {
		t.Fatalf("N2 query event_outbox for inventory.stock_moved failed: %v", err)
	}
	var outboxPayload map[string]any
	if err := json.Unmarshal(outboxPayloadRaw, &outboxPayload); err != nil {
		t.Fatalf("N2 unmarshal outbox payload: %v", err)
	}
	if outboxPayload["movement_id"] == "" || outboxPayload["location_id"] == "" || outboxPayload["movement_type"] != "adjustment" || outboxPayload["quantity"] != float64(15) {
		t.Fatalf("N2 Postgres regression: outbox payload missing movement_id/location_id/movement_type/quantity: %+v", outboxPayload)
	}

	// Update title/category/base_price via adapterHandler must synchronize metadata->'search_index' in PostgreSQL (N3)
	updTitle := "Micro Thu Âm Không Dây Studio Max"
	updCat := "Thiết Bị Thu Âm"
	if _, err := adapterHandler.Update(callerCtx, connect.NewRequest(&commercev1.UpdateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: tenantA},
			IdempotencyKey: "pg-n3-adapter-update-1",
		},
		ProductId: n1ProdID,
		Title:     &updTitle,
		Category:  &updCat,
		BasePrice: &commonv1.Money{Amount: "1200000.000000", Currency: "VND"},
	})); err != nil {
		t.Fatalf("N3 adapterHandler.Update failed: %v", err)
	}
	var syncedTitle, syncedCat, syncedPrice string
	if err := adminPool.QueryRow(ctx, `
		SELECT
			COALESCE(metadata->'search_index'->>'title', ''),
			COALESCE(metadata->'search_index'->>'category', ''),
			COALESCE(metadata->'search_index'->>'base_price', '')
		FROM products
		WHERE workspace_id = $1::uuid AND product_id = $2::uuid
	`, tenantA, n1ProdID).Scan(&syncedTitle, &syncedCat, &syncedPrice); err != nil {
		t.Fatalf("N3 query products.metadata->'search_index' failed: %v", err)
	}
	if syncedTitle != updTitle || syncedCat != updCat || syncedPrice != "1200000.000000" {
		t.Fatalf("N3 Postgres regression: metadata->'search_index' not synchronized: title=%q cat=%q price=%q",
			syncedTitle, syncedCat, syncedPrice)
	}

	t.Log("PASS: Live PostgreSQL RLS isolation, product catalog, stock movements ledger, CAS, keyset cursor, and sales analytics verified.")
}

// poolAdapterProductStore mirrors runtimeassembly.tenantProductStore (holding only an unexported *pgxpool.Pool field)
// to verify that beginStoreMutationTx unwraps the pool and executes mutations + idempotency + outbox atomically in one pgx.Tx.
type poolAdapterProductStore struct {
	pool *pgxpool.Pool
}

func (s *poolAdapterProductStore) CreateProduct(context.Context, *product.Product) error {
	return errors.New("unexpected non-tx call to CreateProduct")
}
func (s *poolAdapterProductStore) GetProduct(context.Context, string, string) (*product.Product, error) {
	return nil, errors.New("unexpected non-tx call to GetProduct")
}
func (s *poolAdapterProductStore) ListProducts(context.Context, string, product.ListFilter, int, int) ([]*product.Product, int64, error) {
	return nil, 0, errors.New("unexpected non-tx call to ListProducts")
}
func (s *poolAdapterProductStore) UpdateProduct(context.Context, *product.Product) error {
	return errors.New("unexpected non-tx call to UpdateProduct")
}
func (s *poolAdapterProductStore) DeleteProduct(context.Context, string, string) error {
	return errors.New("unexpected non-tx call to DeleteProduct")
}
func (s *poolAdapterProductStore) ArchiveProduct(context.Context, string, string) error {
	return errors.New("unexpected non-tx call to ArchiveProduct")
}
func (s *poolAdapterProductStore) BulkArchiveProducts(context.Context, string, []string) (int, error) {
	return 0, errors.New("unexpected non-tx call to BulkArchiveProducts")
}
func (s *poolAdapterProductStore) FindProductByExternalID(context.Context, string, string, string, string) (*product.Product, error) {
	return nil, errors.New("unexpected non-tx call to FindProductByExternalID")
}
func (s *poolAdapterProductStore) CreateSku(context.Context, *product.ProductSku) error {
	return errors.New("unexpected non-tx call to CreateSku")
}
func (s *poolAdapterProductStore) GetSku(context.Context, string, string) (*product.ProductSku, error) {
	return nil, errors.New("unexpected non-tx call to GetSku")
}
func (s *poolAdapterProductStore) ListSkusByProduct(context.Context, string, string) ([]product.ProductSku, error) {
	return nil, errors.New("unexpected non-tx call to ListSkusByProduct")
}
func (s *poolAdapterProductStore) UpdateSkuStock(context.Context, string, string, int32) (int32, error) {
	return 0, errors.New("unexpected non-tx call to UpdateSkuStock")
}
func (s *poolAdapterProductStore) SetSkuAlertThreshold(context.Context, string, string, int32) error {
	return errors.New("unexpected non-tx call to SetSkuAlertThreshold")
}
func (s *poolAdapterProductStore) LinkContent(context.Context, string, string, product.ContentRef) error {
	return errors.New("unexpected non-tx call to LinkContent")
}
func (s *poolAdapterProductStore) GetLinkedContent(context.Context, string, string) ([]product.ContentRef, error) {
	return nil, errors.New("unexpected non-tx call to GetLinkedContent")
}
func (s *poolAdapterProductStore) BatchTag(context.Context, string, []string, []string, []string) (int, error) {
	return 0, errors.New("unexpected non-tx call to BatchTag")
}
func (s *poolAdapterProductStore) GetIdempotencyRecord(context.Context, string, string) (*product.IdempotencyRecord, error) {
	return nil, errors.New("unexpected non-tx call to GetIdempotencyRecord")
}
func (s *poolAdapterProductStore) SaveIdempotencyRecord(context.Context, product.IdempotencyRecord) error {
	return errors.New("unexpected non-tx call to SaveIdempotencyRecord")
}
func (s *poolAdapterProductStore) GetProductSalesSummary(context.Context, string, string) (*product.ProductSalesSummary, error) {
	return nil, errors.New("unexpected non-tx call to GetProductSalesSummary")
}
func (s *poolAdapterProductStore) GetProductSalesChart(context.Context, string, string, int) ([]product.SalesChartDataPoint, error) {
	return nil, errors.New("unexpected non-tx call to GetProductSalesChart")
}
func (s *poolAdapterProductStore) GetProductRank(context.Context, string, string) (*product.ProductRankSummary, error) {
	return nil, errors.New("unexpected non-tx call to GetProductRank")
}

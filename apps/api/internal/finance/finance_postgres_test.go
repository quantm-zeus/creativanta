package finance_test

import (
	"context"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func TestPostgresLiveFinanceStore(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL finance suite executes in CI")
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

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa19"
	userID := "11111111-1111-4111-8111-111111111119"

	_, _ = pool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'finance-user@test.com', 'Finance User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($2::uuid, 'Finance Workspace', 'finance-ws', $1::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
	`, userID, wsID)

	store := finance.NewPostgresStore(pool)

	// 1. Test Posting creation
	posting := &finance.FinancialPosting{
		PostingID:     "11111111-1111-1111-1111-111111111101",
		WorkspaceID:   wsID,
		OriginType:    "order",
		OriginID:      "22222222-2222-2222-2222-222222222201",
		OriginVersion: "v1",
		Component:     finance.ComponentRevenue,
		Amount:        tenantdb.MustParseExactDecimal("1500000.000000"),
		Currency:      "VND",
		SourceClass:   finance.SourceClassOfficial,
		Confidence:    finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Now().UTC(),
		CreatedAt:   time.Now().UTC(),
	}
	if err := store.CreatePosting(ctx, posting); err != nil {
		t.Fatalf("CreatePosting live PG failed: %v", err)
	}

	gotPosting, err := store.GetPosting(ctx, wsID, posting.PostingID)
	if err != nil || gotPosting.Amount.String() != "1500000" {
		t.Fatalf("GetPosting live PG failed: %v", err)
	}

	// 2. Test Cost Item creation & list
	costItem := &finance.CostItem{
		CostItemID:    "33333333-3333-3333-3333-333333333301",
		WorkspaceID:   wsID,
		CostType:      "ads_spend",
		Amount:        tenantdb.MustParseExactDecimal("250000.000000"),
		Currency:      "VND",
		Description:   "TikTok Ads boost",
		SourceClass:   finance.SourceClassOfficial,
		CostState:     finance.CostStateRecorded,
		EffectiveDate: "2026-11-01",
	}
	if err := store.CreateCostItem(ctx, costItem); err != nil {
		t.Fatalf("CreateCostItem live PG failed: %v", err)
	}

	costItems, total, err := store.ListCostItems(ctx, wsID, finance.CostItemFilter{CostType: "ads_spend"}, 10, 0)
	if err != nil || total < 1 || len(costItems) < 1 {
		t.Fatalf("ListCostItems live PG failed: %v, total: %d", err, total)
	}

	// 3. Test Settlement creation
	settlement := &finance.Settlement{
		SettlementID:         "44444444-4444-4444-4444-444444444401",
		WorkspaceID:          wsID,
		SourceClass:          finance.SourceClassOfficial,
		SourcePlatform:       "tiktok",
		ExternalSettlementID: "tt-settle-001",
		GrossAmount:          tenantdb.MustParseExactDecimal("1500000.000000"),
		NetAmount:            tenantdb.MustParseExactDecimal("1350000.000000"),
		Currency:             "VND",
		SettlementState:      finance.SettlementStateImported,
		ReconciliationState:  finance.ReconciliationImportedOnly,
		EffectiveDate:        "2026-11-01",
	}
	if err := store.CreateSettlement(ctx, settlement); err != nil {
		t.Fatalf("CreateSettlement live PG failed: %v", err)
	}

	gotSment, err := store.GetSettlement(ctx, wsID, settlement.SettlementID)
	if err != nil || gotSment.NetAmount.String() != "1350000" {
		t.Fatalf("GetSettlement live PG failed: %v", err)
	}
}

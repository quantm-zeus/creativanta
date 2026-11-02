package finance_test

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	financev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func TestCostServiceCRUDAndHandlers(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	costHandler := finance.NewCostHandler(svc)

	const wsID = "ws-cost-test"

	// 1. Create Cost Item via Handler
	createReq := connect.NewRequest(&financev1.CostServiceCreateRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "cost-create-1",
			WorkspaceId:    &commonv1.UUID{Value: wsID},
		},
		WorkspaceId:      wsID,
		CostType:         "shipping",
		Amount:           &commonv1.Money{Amount: "45000.000000", Currency: "VND"},
		Description:      "Express delivery via GHN",
		RelatedScopeType: "workspace",
		EffectiveDate:    "2026-11-02",
	})

	createResp, err := costHandler.Create(ctx, createReq)
	if err != nil {
		t.Fatalf("CostHandler.Create failed: %v", err)
	}
	costItemID := createResp.Msg.CostItem.CostItemId
	if costItemID == "" {
		t.Fatalf("expected non-empty cost_item_id")
	}
	if createResp.Msg.CostItem.Amount.Amount != "45000.000000" {
		t.Errorf("expected amount 45000.000000, got %s", createResp.Msg.CostItem.Amount.Amount)
	}

	// 2. List Cost Items via Handler
	listReq := connect.NewRequest(&financev1.CostServiceListRequest{
		WorkspaceId: wsID,
		CostType:    "shipping",
	})
	listResp, err := costHandler.List(ctx, listReq)
	if err != nil {
		t.Fatalf("CostHandler.List failed: %v", err)
	}
	if len(listResp.Msg.CostItems) != 1 {
		t.Fatalf("expected 1 cost item, got %d", len(listResp.Msg.CostItems))
	}

	// 3. Update Cost Item via Handler
	updateReq := connect.NewRequest(&financev1.CostServiceUpdateRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "cost-update-1",
			WorkspaceId:    &commonv1.UUID{Value: wsID},
		},
		WorkspaceId: wsID,
		CostItemId:  costItemID,
		Amount:      &commonv1.Money{Amount: "50000.000000", Currency: "VND"},
		Description: "Updated shipping cost with surcharge",
	})
	updateResp, err := costHandler.Update(ctx, updateReq)
	if err != nil {
		t.Fatalf("CostHandler.Update failed: %v", err)
	}
	if updateResp.Msg.CostItem.Amount.Amount != "50000.000000" {
		t.Errorf("expected updated amount 50000.000000, got %s", updateResp.Msg.CostItem.Amount.Amount)
	}

	// 4. Delete Cost Item via Handler
	delReq := connect.NewRequest(&financev1.CostServiceDeleteRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "cost-del-1",
			WorkspaceId:    &commonv1.UUID{Value: wsID},
		},
		WorkspaceId: wsID,
		CostItemId:  costItemID,
	})
	delResp, err := costHandler.Delete(ctx, delReq)
	if err != nil || !delResp.Msg.Success {
		t.Fatalf("CostHandler.Delete failed: %v", err)
	}

	// Verify deleted from list
	listResp2, err := costHandler.List(ctx, listReq)
	if err != nil || len(listResp2.Msg.CostItems) != 0 {
		t.Fatalf("expected 0 cost items after delete, got %d", len(listResp2.Msg.CostItems))
	}
}

func TestProfitServiceHandlers(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	profitHandler := finance.NewProfitHandler(svc)
	const wsID = "ws-profit-test"

	cogs := tenantdb.MustParseExactDecimal("200000.000000")
	_ = svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          "order-test-1",
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("500000.000000"),
		FeeAmount:        tenantdb.MustParseExactDecimal("50000.000000"),
		ShippingAmount:   tenantdb.MustParseExactDecimal("25000.000000"),
		COGSAmount:       &cogs,
		CommissionAmount: tenantdb.ZeroDecimal(),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC),
	})

	// 1. GetSummary
	summaryReq := connect.NewRequest(&financev1.ProfitServiceGetSummaryRequest{
		WorkspaceId: wsID,
		ScopeType:   "workspace",
		ScopeId:     wsID,
		PeriodStart: "2026-11-01",
		PeriodEnd:   "2026-11-30",
	})
	summaryResp, err := profitHandler.GetSummary(ctx, summaryReq)
	if err != nil {
		t.Fatalf("GetSummary failed: %v", err)
	}
	snap := summaryResp.Msg.Snapshot
	if snap.GrossRevenue.Amount != "500000.000000" {
		t.Errorf("expected 500000.000000 gross revenue, got %s", snap.GrossRevenue.Amount)
	}
	// Net: 500,000 - 50,000 - 25,000 - 200,000 = 225,000
	if snap.NetProfit.Amount != "225000.000000" {
		t.Errorf("expected 225000.000000 net profit, got %s", snap.NetProfit.Amount)
	}

	// 2. DrillDown
	drillReq := connect.NewRequest(&financev1.ProfitServiceDrillDownRequest{
		WorkspaceId: wsID,
		ScopeType:   "workspace",
		ScopeId:     wsID,
		PeriodStart: "2026-11-01",
		PeriodEnd:   "2026-11-30",
	})
	drillResp, err := profitHandler.DrillDown(ctx, drillReq)
	if err != nil {
		t.Fatalf("DrillDown failed: %v", err)
	}
	if len(drillResp.Msg.Items) == 0 {
		t.Errorf("expected drilldown items, got 0")
	}

	// 3. RefreshSnapshot
	refreshReq := connect.NewRequest(&financev1.ProfitServiceRefreshSnapshotRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "refresh-1",
			WorkspaceId:    &commonv1.UUID{Value: wsID},
		},
		WorkspaceId: wsID,
		ScopeType:   "workspace",
		ScopeId:     wsID,
		PeriodStart: "2026-11-01",
		PeriodEnd:   "2026-11-30",
	})
	refreshResp, err := profitHandler.RefreshSnapshot(ctx, refreshReq)
	if err != nil {
		t.Fatalf("RefreshSnapshot failed: %v", err)
	}
	if refreshResp.Msg.Snapshot.NetProfit.Amount != "225000.000000" {
		t.Errorf("expected refreshed net profit 225000.000000, got %s", refreshResp.Msg.Snapshot.NetProfit.Amount)
	}

	// 4. GetSnapshot
	getReq := connect.NewRequest(&financev1.ProfitServiceGetSnapshotRequest{
		WorkspaceId: wsID,
		SnapshotId:  refreshResp.Msg.Snapshot.SnapshotId,
		ScopeType:   "workspace",
		ScopeId:     wsID,
		PeriodStart: "2026-11-01",
		PeriodEnd:   "2026-11-30",
	})
	getResp, err := profitHandler.GetSnapshot(ctx, getReq)
	if err != nil {
		t.Fatalf("GetSnapshot failed: %v", err)
	}
	if getResp.Msg.Snapshot.SnapshotId != refreshResp.Msg.Snapshot.SnapshotId {
		t.Errorf("expected same snapshot ID")
	}
}

func TestSettlementServiceHandlers(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	smentHandler := finance.NewSettlementHandler(svc)
	const wsID = "ws-sment-test"

	// 1. Import Settlement
	importReq := connect.NewRequest(&financev1.SettlementServiceImportRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "sment-import-1",
			WorkspaceId:    &commonv1.UUID{Value: wsID},
		},
		WorkspaceId:          wsID,
		SourcePlatform:       "lazada",
		ExternalSettlementId: "laz-payout-101",
		GrossAmount:          &commonv1.Money{Amount: "2000000.000000", Currency: "VND"},
		NetAmount:            &commonv1.Money{Amount: "1850000.000000", Currency: "VND"},
		Currency:             "VND",
		EffectiveDate:        "2026-11-02",
		Lines: []*financev1.SettlementLineInput{
			{
				ExternalLineId: "laz-line-1",
				GrossAmount:    &commonv1.Money{Amount: "1000000.000000", Currency: "VND"},
				FeeAmount:      &commonv1.Money{Amount: "75000.000000", Currency: "VND"},
				NetAmount:      &commonv1.Money{Amount: "925000.000000", Currency: "VND"},
			},
			{
				ExternalLineId: "laz-line-2",
				GrossAmount:    &commonv1.Money{Amount: "1000000.000000", Currency: "VND"},
				FeeAmount:      &commonv1.Money{Amount: "75000.000000", Currency: "VND"},
				NetAmount:      &commonv1.Money{Amount: "925000.000000", Currency: "VND"},
			},
		},
	})

	importResp, err := smentHandler.Import(ctx, importReq)
	if err != nil {
		t.Fatalf("SettlementHandler.Import failed: %v", err)
	}
	smentID := importResp.Msg.Settlement.SettlementId
	if smentID == "" {
		t.Fatalf("expected non-empty settlement_id")
	}
	if importResp.Msg.ImportedLinesCount != 2 {
		t.Errorf("expected 2 lines imported, got %d", importResp.Msg.ImportedLinesCount)
	}

	// 2. List Settlements
	listReq := connect.NewRequest(&financev1.SettlementServiceListRequest{
		WorkspaceId:    wsID,
		SourcePlatform: "lazada",
	})
	listResp, err := smentHandler.List(ctx, listReq)
	if err != nil {
		t.Fatalf("SettlementHandler.List failed: %v", err)
	}
	if len(listResp.Msg.Settlements) != 1 {
		t.Fatalf("expected 1 settlement in list, got %d", len(listResp.Msg.Settlements))
	}

	// 3. Get Settlement
	getReq := connect.NewRequest(&financev1.SettlementServiceGetRequest{
		WorkspaceId:  wsID,
		SettlementId: smentID,
	})
	getResp, err := smentHandler.Get(ctx, getReq)
	if err != nil {
		t.Fatalf("SettlementHandler.Get failed: %v", err)
	}
	if getResp.Msg.Settlement.NetAmount.Amount != "1850000.000000" {
		t.Errorf("expected net amount 1850000.000000, got %s", getResp.Msg.Settlement.NetAmount.Amount)
	}
}

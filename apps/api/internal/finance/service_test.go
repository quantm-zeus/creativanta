package finance_test

import (
	"context"
	"errors"
	"strings"
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

func TestP802CompleteFinancialReportsTaxDisclaimerAndExportTierGates(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	profitHandler := finance.NewProfitHandler(svc)
	const wsID = "ws-p802-reports-test"

	cogs := tenantdb.MustParseExactDecimal("3000000.000000")
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          "order-p802-1",
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("10000000.000000"),
		FeeAmount:        tenantdb.MustParseExactDecimal("500000.000000"),
		ShippingAmount:   tenantdb.MustParseExactDecimal("200000.000000"),
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
		EffectiveAt: time.Date(2026, 11, 2, 10, 0, 0, 0, time.UTC),
	}); err != nil {
		t.Fatalf("RecordOrderPosting failed: %v", err)
	}

	// 1. GetReportTemplates
	tplResp, err := profitHandler.GetReportTemplates(ctx, connect.NewRequest(&financev1.ProfitServiceGetReportTemplatesRequest{
		WorkspaceId: wsID,
	}))
	if err != nil || len(tplResp.Msg.GetTemplates()) < 6 {
		t.Fatalf("GetReportTemplates failed: %+v, err=%v", tplResp, err)
	}

	// 2. GenerateReport (pnl_statement)
	genResp, err := profitHandler.GenerateReport(ctx, connect.NewRequest(&financev1.ProfitServiceGenerateReportRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "p802-gen-pnl",
		},
		WorkspaceId: wsID,
		ReportType:  "pnl_statement",
		PeriodStart: "2026-11-01",
		PeriodEnd:   "2026-11-30",
		GroupBy:     "monthly",
	}))
	if err != nil {
		t.Fatalf("GenerateReport failed: %v", err)
	}
	report := genResp.Msg.GetReport()
	if report.GetReportType() != "pnl_statement" || len(report.GetLineItems()) < 8 {
		t.Fatalf("expected pnl_statement report with >=8 line items, got %+v", report)
	}

	// 3. GetSavedReports
	savedResp, err := profitHandler.GetSavedReports(ctx, connect.NewRequest(&financev1.ProfitServiceGetSavedReportsRequest{
		WorkspaceId: wsID,
	}))
	if err != nil || len(savedResp.Msg.GetReports()) == 0 {
		t.Fatalf("GetSavedReports failed: %+v, err=%v", savedResp, err)
	}

	// 4. Tier Export Gate: Free tier (0/mo) must be blocked; Starter tier allows 5 exports/mo and rejects the 6th!
	_, err = svc.ExportFinancialReport(ctx, wsID, "pnl_statement", "csv", "2026-11-01", "2026-11-30", "free", false)
	if !errors.Is(err, finance.ErrReportExportTierForbidden) {
		t.Fatalf("expected Free tier report export to fail with ErrReportExportTierForbidden, got %v", err)
	}

	for i := 1; i <= 5; i++ {
		expResp, expErr := profitHandler.ExportReport(ctx, connect.NewRequest(&financev1.ProfitServiceExportReportRequest{
			Context: &commonv1.CommandContext{
				WorkspaceId:    &commonv1.UUID{Value: wsID},
				IdempotencyKey: "p802-exp-starter",
			},
			WorkspaceId:      wsID,
			ReportType:       "pnl_statement",
			Format:           "csv",
			PeriodStart:      "2026-11-01",
			PeriodEnd:        "2026-11-30",
			SubscriptionTier: "starter",
		}))
		if expErr != nil || len(expResp.Msg.GetContentHashSha512()) != 128 {
			t.Fatalf("Starter export #%d failed: %+v, err=%v", i, expResp, expErr)
		}
	}
	// 6th export on Starter tier in the same month must fail with ErrReportExportQuotaExceeded.
	if _, err := svc.ExportFinancialReport(ctx, wsID, "pnl_statement", "csv", "2026-11-01", "2026-11-30", "starter", false); !errors.Is(err, finance.ErrReportExportQuotaExceeded) {
		t.Fatalf("expected 6th Starter report export in same month to fail with ErrReportExportQuotaExceeded, got %v", err)
	}

	// 5. ExportTaxReport on Pro tier: unlimited exports + BIZ-007 creator_responsible tax disclaimer.
	taxResp, err := profitHandler.ExportTaxReport(ctx, connect.NewRequest(&financev1.ProfitServiceExportTaxReportRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "p802-tax-export",
		},
		WorkspaceId:      wsID,
		Format:           "pdf",
		PeriodStart:      "2026-11-01",
		PeriodEnd:        "2026-11-30",
		SubscriptionTier: "pro",
	}))
	if err != nil {
		t.Fatalf("ExportTaxReport failed: %v", err)
	}
	if taxResp.Msg.GetTaxResponsibilityMode() != "creator_responsible" ||
		!strings.Contains(taxResp.Msg.GetTaxDisclaimer(), "creator_responsible") ||
		len(taxResp.Msg.GetContentHashSha512()) != 128 {
		t.Fatalf("expected BIZ-007 creator_responsible tax disclaimer and 128-hex SHA-512 hash, got %+v", taxResp.Msg)
	}
}

func TestP802MeasuredCohortEconomicsAll7CanonicalMetrics(t *testing.T) {
	fv1 := int64(3600)
	fv2 := int64(7200)
	repSec := int64(180)

	// Case A: Full cohort with demo/test/internal exclusion, login-only exclusion from retention,
	// proofed operating loops, repair burden, usable production yield (excluding previews & cancelled),
	// cost per accepted output (including failed paid provider costs), and net unit economics.
	econ, err := finance.ComputeCohortEconomics(finance.CohortEconomicsInput{
		CohortID:          "cohort-2026-W44",
		ObservationWindow: "2026-11-01..2026-11-07",
		Currency:          "USD",
		Workspaces: []finance.CohortWorkspaceObservation{
			{
				WorkspaceID:            "ws-active-retained",
				Activated:              true,
				EligibleForWeekN:       true,
				FirstValueSeconds:      &fv1,
				RealDomainActionsCount: 5,
				EvidenceReviewsCount:   2,
			},
			{
				WorkspaceID:            "ws-login-only-not-retained",
				Activated:              true,
				EligibleForWeekN:       true,
				FirstValueSeconds:      &fv2,
				RealDomainActionsCount: 0,
				EvidenceReviewsCount:   0,
				LoginOrPageViewsCount:  40, // Login/page views alone MUST NOT count as retained!
			},
			{
				WorkspaceID:      "ws-demo-excluded",
				IsDemo:           true,
				Activated:        true,
				EligibleForWeekN: true,
			},
			{
				WorkspaceID: "ws-internal-excluded",
				IsInternal:  true,
				Activated:   true,
			},
		},
		OperatingLoops: []finance.CohortOperatingLoopObservation{
			{
				PublishItemID:               "pub-loop-1",
				WorkspaceID:                 "ws-active-retained",
				HasAttributedCompletedOrder: true,
				HasVersionedProfitSnapshot:  true,
				HasReviewedEvidence:         true,
				HasUnresolvedGap:            false,
			},
			{
				PublishItemID:               "pub-loop-gap",
				WorkspaceID:                 "ws-active-retained",
				HasAttributedCompletedOrder: true,
				HasVersionedProfitSnapshot:  true,
				HasReviewedEvidence:         true,
				HasUnresolvedGap:            true, // Unresolved gap excluded from proofed loops!
			},
			{
				PublishItemID:               "pub-loop-demo",
				WorkspaceID:                 "ws-demo-excluded",
				IsDemo:                      true,
				HasAttributedCompletedOrder: true,
				HasVersionedProfitSnapshot:  true,
				HasReviewedEvidence:         true,
			},
		},
		ImportBatches: []finance.CohortImportBatchObservation{
			{
				BatchID:                      "batch-1",
				WorkspaceID:                  "ws-active-retained",
				OperatorRepairSeconds:        &repSec,
				UnresolvedRequiredComponents: 2,
			},
		},
		GenerationAttempts: []finance.CohortGenerationAttemptObservation{
			{
				OperationID:        "op-accepted-1",
				WorkspaceID:        "ws-active-retained",
				IsTerminal:         true,
				IsAcceptedUsable:   true,
				ActualProviderCost: tenantdb.MustParseExactDecimal("4.000000"),
				RenderStorageCost:  tenantdb.MustParseExactDecimal("1.000000"),
			},
			{
				OperationID:        "op-failed-paid-2",
				WorkspaceID:        "ws-active-retained",
				IsTerminal:         true,
				IsAcceptedUsable:   false,
				ActualProviderCost: tenantdb.MustParseExactDecimal("3.000000"),
				RenderStorageCost:  tenantdb.ZeroDecimal(),
			},
			{
				OperationID:        "op-preview-excluded",
				WorkspaceID:        "ws-active-retained",
				IsPreview:          true,
				IsTerminal:         true,
				IsAcceptedUsable:   true,
				ActualProviderCost: tenantdb.ZeroDecimal(),
			},
		},
		RecognizedSubscriptionRevenue: tenantdb.MustParseExactDecimal("60.000000"),
		RecognizedTopUpRevenue:        tenantdb.MustParseExactDecimal("20.000000"),
		AllocatedComputeStorageCost:   tenantdb.MustParseExactDecimal("2.000000"),
		AllocatedPaymentRefundCost:    tenantdb.MustParseExactDecimal("3.000000"),
		AttributedSupportCost:         tenantdb.MustParseExactDecimal("1.000000"),
	})
	if err != nil {
		t.Fatalf("ComputeCohortEconomics failed: %v", err)
	}
	if econ.EligibleWorkspacesCount != 2 || econ.ExcludedDemoTestInternalCount != 2 {
		t.Fatalf("expected 2 eligible workspaces and 2 excluded demo/internal workspaces, got %+v", econ)
	}
	// Median of [3600, 7200] = 5400.000000; retention = 1/2 = 50.000000% (login-only excluded!).
	if econ.MedianFirstValueSeconds != "5400.000000" || econ.WeeklyOperatorRetentionPct != "50.000000" {
		t.Fatalf("unexpected first_value=%s or retention=%s (want 5400.000000, 50.000000)", econ.MedianFirstValueSeconds, econ.WeeklyOperatorRetentionPct)
	}
	if econ.WeeklyProofedOperatingLoops != 1 {
		t.Fatalf("expected 1 weekly proofed operating loop (unresolved gap & demo excluded), got %d", econ.WeeklyProofedOperatingLoops)
	}
	// Usable yield = 1 accepted / 2 terminal non-preview attempts = 50.000000%.
	// Cost per accepted output = ($4 + $1 + $3 failed paid) / 1 accepted = $8.000000.
	if econ.UsableProductionYieldPct != "50.000000" || econ.CostPerAcceptedOutput.Fixed6String() != "8.000000" || econ.IsCostPerAcceptedOutputUndefined {
		t.Fatalf("unexpected yield=%s or cost_per_accepted=%s", econ.UsableProductionYieldPct, econ.CostPerAcceptedOutput.Fixed6String())
	}
	// Net unit economics = ($60 + $20) - ($7 provider + $3 compute/storage + $4 payment/support) = $66.000000.
	if econ.NetUnitEconomics.Fixed6String() != "66.000000" {
		t.Fatalf("expected NetUnitEconomics=66.000000, got %s", econ.NetUnitEconomics.Fixed6String())
	}

	// Case B: Zero accepted outputs and missing repair time -> IsCostPerAcceptedOutputUndefined=true, IsRepairTimeUnknown=true.
	econZero, err := finance.ComputeCohortEconomics(finance.CohortEconomicsInput{
		CohortID:          "cohort-zero",
		ObservationWindow: "2026-11-01..2026-11-07",
		Currency:          "USD",
		ImportBatches: []finance.CohortImportBatchObservation{
			{
				BatchID:                      "batch-missing-time",
				WorkspaceID:                  "ws-1",
				OperatorRepairSeconds:        nil, // missing time tracking -> unknown, never 0!
				UnresolvedRequiredComponents: 1,
			},
		},
		GenerationAttempts: []finance.CohortGenerationAttemptObservation{
			{
				OperationID:        "op-failed-only",
				WorkspaceID:        "ws-1",
				IsTerminal:         true,
				IsAcceptedUsable:   false,
				ActualProviderCost: tenantdb.MustParseExactDecimal("5.000000"),
			},
		},
	})
	if err != nil {
		t.Fatalf("ComputeCohortEconomics zero accepted failed: %v", err)
	}
	if !econZero.IsCostPerAcceptedOutputUndefined {
		t.Fatalf("expected 0 accepted outputs to set IsCostPerAcceptedOutputUndefined=true, got %+v", econZero)
	}
	if !econZero.IsRepairTimeUnknown || econZero.MedianRepairBurdenSeconds != "unknown" {
		t.Fatalf("expected missing repair time to set IsRepairTimeUnknown=true and MedianRepairBurdenSeconds='unknown', got %+v", econZero)
	}
}

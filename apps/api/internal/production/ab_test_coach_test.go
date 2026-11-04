package production_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/production"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func setupTestProductionService(t *testing.T) (*production.Service, *production.MemoryStore, *production.DefaultM11GateChecker) {
	t.Helper()
	store := production.NewMemoryStore()
	svc := production.NewService(production.ServiceConfig{
		Store: store,
		InitialBalances: map[string]tenantdb.ExactDecimal{
			"ws-test-1": tenantdb.MustParseExactDecimal("100"),
		},
	})
	gateChecker := production.NewDefaultM11GateChecker(store, svc.PackagingQAMgr)
	svc.ABTestMgr = production.NewABTestManager(store, svc.PackagingQAMgr, gateChecker)
	svc.CoachMgr = production.NewPerformanceCoachManager(store)
	return svc, store, gateChecker
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Low Exposure -> Inconclusive
// ----------------------------------------------------------------------------

func TestABExperiment_AcceptanceTarget1_LowExposureInconclusive(t *testing.T) {
	ctx := context.Background()
	svc, store, _ := setupTestProductionService(t)

	caller := production.CallerContext{
		UserID:        "usr-001",
		WorkspaceID:   "ws-test-1",
		WorkspaceRole: "Editor",
	}

	// Create source asset
	_ = store.CreateAsset(ctx, &production.Asset{
		AssetID:     "asset-source-01",
		WorkspaceID: "ws-test-1",
		Title:       "Original Product Demo",
	})

	t.Run("three variants with 20 impressions each after 72h -> inconclusive (packaging_qa.md)", func(t *testing.T) {
		variants := []*production.ABVariantRecord{
			{AssetID: "variant-a", VariantLabel: "Variant A", Views: 20, Impressions: 20, Clicks: 2, EngagementRate: 10.0},
			{AssetID: "variant-b", VariantLabel: "Variant B", Views: 20, Impressions: 20, Clicks: 1, EngagementRate: 5.0},
			{AssetID: "variant-c", VariantLabel: "Variant C", Views: 20, Impressions: 20, Clicks: 1, EngagementRate: 5.0},
		}

		exp, err := svc.ABTestMgr.CreateExperiment(ctx, caller, "asset-source-01", "Hook Test", "Question hook increases CTR", "views", 72, 1000, 1.2, variants)
		if err != nil {
			t.Fatalf("unexpected error creating experiment: %v", err)
		}

		evaluated, isConclusive, summary, err := svc.ABTestMgr.EvaluateTest(ctx, production.CallerContext{
			UserID:        "usr-mgr",
			WorkspaceID:   "ws-test-1",
			WorkspaceRole: "Manager",
		}, exp.ExperimentID)
		if err != nil {
			t.Fatalf("unexpected evaluation error: %v", err)
		}

		if isConclusive {
			t.Errorf("expected inconclusive result due to low exposure (<1000 impressions), got conclusive")
		}
		if evaluated.ResultStatus != "inconclusive" {
			t.Errorf("expected result_status inconclusive, got %s", evaluated.ResultStatus)
		}
		if evaluated.WinnerAssetID != "" {
			t.Errorf("expected winner_asset_id to remain empty for inconclusive test, got %s", evaluated.WinnerAssetID)
		}
		if !evaluated.IsObservational {
			t.Errorf("expected is_observational=true, got false")
		}
		if !strings.Contains(evaluated.InconclusiveReason, "insufficient exposure") {
			t.Errorf("expected insufficient exposure reason, got: %s", evaluated.InconclusiveReason)
		}
		if !strings.Contains(summary, "insufficient exposure") {
			t.Errorf("expected summary to mention insufficient exposure, got: %s", summary)
		}
	})

	t.Run("zero exposure / missing denominator safely produces inconclusive without divide by zero", func(t *testing.T) {
		variants := []*production.ABVariantRecord{
			{AssetID: "variant-zero-a", VariantLabel: "Variant A", Views: 0, Impressions: 0, Clicks: 0, EngagementRate: 0.0},
			{AssetID: "variant-zero-b", VariantLabel: "Variant B", Views: 0, Impressions: 0, Clicks: 0, EngagementRate: 0.0},
		}

		exp, err := svc.ABTestMgr.CreateExperiment(ctx, caller, "asset-source-01", "Zero Views Test", "Hypothesis", "click_through", 48, 1000, 1.5, variants)
		if err != nil {
			t.Fatalf("failed to create experiment: %v", err)
		}

		evaluated, isConclusive, _, err := svc.ABTestMgr.EvaluateTest(ctx, production.CallerContext{
			UserID:        "usr-mgr",
			WorkspaceID:   "ws-test-1",
			WorkspaceRole: "Manager",
		}, exp.ExperimentID)
		if err != nil {
			t.Fatalf("evaluation should handle zero exposure safely without error: %v", err)
		}
		if isConclusive {
			t.Errorf("expected inconclusive for zero exposure, got conclusive")
		}
		if evaluated.WinnerAssetID != "" {
			t.Errorf("expected empty winner for zero exposure, got %s", evaluated.WinnerAssetID)
		}
	})

	t.Run("adequate exposure with statistically significant lift identifies winner and retains observational label", func(t *testing.T) {
		variants := []*production.ABVariantRecord{
			{AssetID: "variant-win-a", VariantLabel: "Variant A", Views: 2400, Impressions: 2400, Clicks: 240, CTR: 0.10, EngagementRate: 8.5},
			{AssetID: "variant-win-b", VariantLabel: "Variant B", Views: 2100, Impressions: 2100, Clicks: 105, CTR: 0.05, EngagementRate: 4.8},
		}

		exp, err := svc.ABTestMgr.CreateExperiment(ctx, caller, "asset-source-01", "High Exposure Test", "Hypothesis", "engagement_rate", 48, 1000, 1.5, variants)
		if err != nil {
			t.Fatalf("failed to create experiment: %v", err)
		}

		evaluated, isConclusive, _, err := svc.ABTestMgr.EvaluateTest(ctx, production.CallerContext{
			UserID:        "usr-mgr",
			WorkspaceID:   "ws-test-1",
			WorkspaceRole: "Manager",
		}, exp.ExperimentID)
		if err != nil {
			t.Fatalf("unexpected evaluation error: %v", err)
		}

		if !isConclusive {
			t.Errorf("expected conclusive result for 8.5%% vs 4.8%% ER with 2400 views, got inconclusive")
		}
		if evaluated.WinnerAssetID != "variant-win-a" {
			t.Errorf("expected winner variant-win-a, got %s", evaluated.WinnerAssetID)
		}
		// ACCEPTANCE TARGET 2: Observational label retained!
		if !evaluated.IsObservational {
			t.Errorf("expected is_observational=true even on conclusive winner, got false")
		}
	})

	t.Run("adequate exposure but lift below threshold multiplier -> inconclusive", func(t *testing.T) {
		variants := []*production.ABVariantRecord{
			{AssetID: "variant-tie-a", VariantLabel: "Variant A", Views: 1500, Impressions: 1500, EngagementRate: 6.2},
			{AssetID: "variant-tie-b", VariantLabel: "Variant B", Views: 1500, Impressions: 1500, EngagementRate: 6.0},
		}

		exp, err := svc.ABTestMgr.CreateExperiment(ctx, caller, "asset-source-01", "Near Tie Test", "Hypothesis", "engagement_rate", 48, 1000, 1.2, variants)
		if err != nil {
			t.Fatalf("failed to create experiment: %v", err)
		}

		evaluated, isConclusive, _, err := svc.ABTestMgr.EvaluateTest(ctx, production.CallerContext{
			UserID:        "usr-mgr",
			WorkspaceID:   "ws-test-1",
			WorkspaceRole: "Manager",
		}, exp.ExperimentID)
		if err != nil {
			t.Fatalf("unexpected evaluation error: %v", err)
		}

		if isConclusive {
			t.Errorf("expected inconclusive due to sub-threshold lift, got conclusive")
		}
		if evaluated.WinnerAssetID != "" {
			t.Errorf("expected empty winner, got %s", evaluated.WinnerAssetID)
		}
		if !evaluated.IsObservational {
			t.Errorf("expected is_observational=true, got false")
		}
	})
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Observational Label Retained
// ----------------------------------------------------------------------------

func TestPerformanceCoach_AcceptanceTarget2_ObservationalLabelRetained(t *testing.T) {
	ctx := context.Background()
	svc, store, _ := setupTestProductionService(t)

	caller := production.CallerContext{
		UserID:        "usr-member",
		WorkspaceID:   "ws-test-1",
		WorkspaceRole: "Member",
	}

	_ = store.CreateAsset(ctx, &production.Asset{
		AssetID:     "asset-coach-01",
		WorkspaceID: "ws-test-1",
		Title:       "Top Selling Skincare Routine",
	})

	t.Run("PerformanceCoach GetInsights retains observational label and notice", func(t *testing.T) {
		insights, isObs, notice, err := svc.CoachMgr.GetInsights(ctx, caller, "tiktok", 5)
		if err != nil {
			t.Fatalf("unexpected GetInsights error: %v", err)
		}
		if !isObs {
			t.Errorf("expected is_observational=true on GetInsights, got false")
		}
		if len(insights) == 0 {
			t.Fatalf("expected insights list, got 0")
		}
		for _, ins := range insights {
			if !ins.IsObservational {
				t.Errorf("insight %s missing observational flag", ins.InsightID)
			}
		}
		if !strings.Contains(notice, "Observational recommendation") {
			t.Errorf("expected standard observational notice, got: %s", notice)
		}
	})

	t.Run("PerformanceCoach GetVideoScorecard retains observational label", func(t *testing.T) {
		scorecard, err := svc.CoachMgr.GetVideoScorecard(ctx, caller, "asset-coach-01")
		if err != nil {
			t.Fatalf("unexpected GetVideoScorecard error: %v", err)
		}
		if !scorecard.IsObservational {
			t.Errorf("expected is_observational=true on scorecard, got false")
		}
		if scorecard.Grade == "" {
			t.Errorf("expected scorecard grade to be set")
		}
		if len(scorecard.Strengths) == 0 || len(scorecard.DropOffPoints) == 0 {
			t.Errorf("expected scorecard strengths and drop-off points")
		}
		if !strings.Contains(scorecard.ObservationalNotice, "Observational recommendation") {
			t.Errorf("expected observational notice in scorecard, got: %s", scorecard.ObservationalNotice)
		}
	})

	t.Run("PerformanceCoach GetImprovementPlan retains observational label", func(t *testing.T) {
		editorCaller := production.CallerContext{
			UserID:        "usr-editor",
			WorkspaceID:   "ws-test-1",
			WorkspaceRole: "Editor",
		}
		plan, err := svc.CoachMgr.GetImprovementPlan(ctx, editorCaller, "7d")
		if err != nil {
			t.Fatalf("unexpected GetImprovementPlan error: %v", err)
		}
		if !plan.IsObservational {
			t.Errorf("expected is_observational=true on plan, got false")
		}
		if len(plan.ActionItems) == 0 {
			t.Errorf("expected actionable items in plan")
		}
		for _, item := range plan.ActionItems {
			if item.Impact == "" || item.Effort == "" {
				t.Errorf("action item missing impact or effort rating")
			}
		}
	})

	t.Run("PerformanceCoach ListBenchmarks and CompareToIndustry retain observational label", func(t *testing.T) {
		benchmarks, isObs, err := svc.CoachMgr.ListBenchmarks(ctx, caller, "tiktok", "beauty")
		if err != nil {
			t.Fatalf("unexpected ListBenchmarks error: %v", err)
		}
		if !isObs {
			t.Errorf("expected is_observational=true on benchmarks")
		}
		if len(benchmarks) == 0 {
			t.Fatalf("expected benchmark list, got 0")
		}

		comparison, err := svc.CoachMgr.CompareToIndustry(ctx, caller, "tiktok", "beauty")
		if err != nil {
			t.Fatalf("unexpected CompareToIndustry error: %v", err)
		}
		if !comparison.IsObservational {
			t.Errorf("expected is_observational=true on comparison")
		}
		if comparison.PercentileRank == "" {
			t.Errorf("expected percentile rank to be populated")
		}
	})

	t.Run("Manual DeclareWinner retains observational label", func(t *testing.T) {
		variants := []*production.ABVariantRecord{
			{AssetID: "variant-man-a", VariantLabel: "Variant A", Views: 500},
			{AssetID: "variant-man-b", VariantLabel: "Variant B", Views: 450},
		}
		editorCaller := production.CallerContext{
			UserID:        "usr-editor",
			WorkspaceID:   "ws-test-1",
			WorkspaceRole: "Editor",
		}
		exp, err := svc.ABTestMgr.CreateExperiment(ctx, editorCaller, "asset-coach-01", "Manual Pick Test", "Hypothesis", "views", 48, 1000, 1.2, variants)
		if err != nil {
			t.Fatalf("failed to create experiment: %v", err)
		}

		declared, err := svc.ABTestMgr.DeclareWinner(ctx, editorCaller, exp.ExperimentID, "variant-man-a", "Creator picked based on brand visual tone")
		if err != nil {
			t.Fatalf("unexpected DeclareWinner error: %v", err)
		}
		if declared.WinnerAssetID != "variant-man-a" {
			t.Errorf("expected winner variant-man-a, got %s", declared.WinnerAssetID)
		}
		if !declared.IsObservational {
			t.Errorf("expected is_observational=true on manually declared winner")
		}
	})
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Scaling Rechecks M11 Gates
// ----------------------------------------------------------------------------

func TestABExperiment_AcceptanceTarget3_ScalingRechecksM11Gates(t *testing.T) {
	ctx := context.Background()
	svc, store, gateChecker := setupTestProductionService(t)

	editorCaller := production.CallerContext{
		UserID:        "usr-editor",
		WorkspaceID:   "ws-test-1",
		WorkspaceRole: "Editor",
	}

	_ = store.CreateAsset(ctx, &production.Asset{
		AssetID:     "asset-scale-source",
		WorkspaceID: "ws-test-1",
		Title:       "Base Scalable Video",
	})

	createConclusiveExperiment := func() *production.ABExperimentRecord {
		variants := []*production.ABVariantRecord{
			{AssetID: "variant-winner", VariantLabel: "Variant A", Views: 2500, Impressions: 2500, EngagementRate: 9.0},
			{AssetID: "variant-loser", VariantLabel: "Variant B", Views: 2000, Impressions: 2000, EngagementRate: 4.0},
		}
		exp, err := svc.ABTestMgr.CreateExperiment(ctx, editorCaller, "asset-scale-source", "Scale Experiment", "Hypothesis", "engagement_rate", 48, 1000, 1.5, variants)
		if err != nil {
			t.Fatalf("failed to create experiment: %v", err)
		}
		eval, isConclusive, _, err := svc.ABTestMgr.EvaluateTest(ctx, production.CallerContext{
			UserID:        "usr-mgr",
			WorkspaceID:   "ws-test-1",
			WorkspaceRole: "Manager",
		}, exp.ExperimentID)
		if err != nil || !isConclusive {
			t.Fatalf("failed to evaluate to conclusive: %v", err)
		}
		return eval
	}

	t.Run("Gate 1 failure: Caller lacks publish permission (Contributor role) -> scaling denied", func(t *testing.T) {
		exp := createConclusiveExperiment()
		contributorCaller := production.CallerContext{
			UserID:        "usr-contrib",
			WorkspaceID:   "ws-test-1",
			WorkspaceRole: "Contributor",
		}

		res, err := svc.ABTestMgr.ScaleWinner(ctx, contributorCaller, exp.ExperimentID, []string{"tiktok"})
		if err == nil {
			t.Fatalf("expected scaling to fail for Contributor role, got success")
		}
		if res != nil {
			t.Errorf("expected nil result on failure")
		}
		if !strings.Contains(err.Error(), "M11 gate failure: caller lacks publish:execute") {
			t.Errorf("expected permission gate error, got: %v", err)
		}
	})

	t.Run("Gate 2 failure: Target platform capability is degraded/revoked -> scaling denied", func(t *testing.T) {
		exp := createConclusiveExperiment()
		gateChecker.SetPlatformCapability("ws-test-1", "instagram", "degraded")

		res, err := svc.ABTestMgr.ScaleWinner(ctx, editorCaller, exp.ExperimentID, []string{"instagram"})
		if err == nil {
			t.Fatalf("expected scaling to fail on degraded platform capability, got success")
		}
		if res != nil {
			t.Errorf("expected nil result on failure")
		}
		if !strings.Contains(err.Error(), "capability is degraded") {
			t.Errorf("expected capability degraded error, got: %v", err)
		}
	})

	t.Run("Gate 3 failure: Packaging QA compliance has hard blocks -> scaling denied", func(t *testing.T) {
		exp := createConclusiveExperiment()

		// Save a hard-blocked QA result for the winner asset
		_ = store.SaveQAResult(ctx, &production.PackagingQAItem{
			ReportID:                "qa-blocked-01",
			WorkspaceID:             "ws-test-1",
			AssetID:                 "variant-winner",
			HasHardBlocks:           true,
			ComplianceOverallResult: "blocked",
			CreatedAt:               time.Now().UTC(),
		})

		res, err := svc.ABTestMgr.ScaleWinner(ctx, editorCaller, exp.ExperimentID, []string{"tiktok"})
		if err == nil {
			t.Fatalf("expected scaling to fail on packaging QA hard block, got success")
		}
		if res != nil {
			t.Errorf("expected nil result on failure")
		}
		if !strings.Contains(err.Error(), "has unresolved compliance or policy hard blocks") {
			t.Errorf("expected policy blocked error, got: %v", err)
		}
	})

	t.Run("Gate 4 failure: Identical asset already published within 24h cooldown -> scaling denied", func(t *testing.T) {
		exp := createConclusiveExperiment()

		// Ensure policy passes by saving a clean QA report
		_ = store.SaveQAResult(ctx, &production.PackagingQAItem{
			ReportID:                "qa-clean-01",
			WorkspaceID:             "ws-test-1",
			AssetID:                 "variant-winner",
			HasHardBlocks:           false,
			ComplianceOverallResult: "pass",
			CreatedAt:               time.Now().UTC(),
		})

		// Record a recent post 2 hours ago
		gateChecker.RecordPriorPost("ws-test-1", "variant-winner", "tiktok", time.Now().UTC().Add(-2*time.Hour))

		res, err := svc.ABTestMgr.ScaleWinner(ctx, editorCaller, exp.ExperimentID, []string{"tiktok"})
		if err == nil {
			t.Fatalf("expected duplicate-post gate failure, got success")
		}
		if res != nil {
			t.Errorf("expected nil result on duplicate post")
		}
		if !strings.Contains(err.Error(), "already posted to tiktok within 24h0m0s cooldown window") {
			t.Errorf("expected duplicate post error, got: %v", err)
		}
	})

	t.Run("All 4 M11 Gates Pass: Scaling succeeds and sets result_status = scaled", func(t *testing.T) {
		// Use fresh gateChecker to avoid prior subtest recorded posts
		freshGateChecker := production.NewDefaultM11GateChecker(store, svc.PackagingQAMgr)
		svc.ABTestMgr = production.NewABTestManager(store, svc.PackagingQAMgr, freshGateChecker)

		exp := createConclusiveExperiment()

		// Clean policy
		_ = store.SaveQAResult(ctx, &production.PackagingQAItem{
			ReportID:                "qa-clean-02",
			WorkspaceID:             "ws-test-1",
			AssetID:                 "variant-winner",
			HasHardBlocks:           false,
			ComplianceOverallResult: "pass",
			CreatedAt:               time.Now().UTC(),
		})

		// Clean platform capabilities
		freshGateChecker.SetPlatformCapability("ws-test-1", "tiktok", "active")
		freshGateChecker.SetPlatformCapability("ws-test-1", "youtube", "active")

		// No recent duplicate post
		res, err := svc.ABTestMgr.ScaleWinner(ctx, editorCaller, exp.ExperimentID, []string{"tiktok", "youtube"})
		if err != nil {
			t.Fatalf("unexpected scaling failure when all 4 gates pass: %v", err)
		}

		if res.ResultStatus != "scaled" {
			t.Errorf("expected result_status scaled, got %s", res.ResultStatus)
		}
		if !res.ObservationalLabelRetained {
			t.Errorf("expected observational_label_retained=true")
		}
		if len(res.ScheduledItemIDs) != 2 {
			t.Errorf("expected 2 scheduled items, got %d", len(res.ScheduledItemIDs))
		}

		// Verify stored experiment state
		updated, _ := store.GetExperiment(ctx, "ws-test-1", exp.ExperimentID)
		if updated.ResultStatus != "scaled" {
			t.Errorf("stored experiment result_status expected scaled, got %s", updated.ResultStatus)
		}
		if !updated.IsObservational {
			t.Errorf("stored experiment must retain is_observational=true")
		}
	})
}

// ----------------------------------------------------------------------------
// ConnectRPC Protocol Tests
// ----------------------------------------------------------------------------

func TestABTestAndCoach_ConnectRPCEndpoints(t *testing.T) {
	ctx := context.Background()
	svc, store, _ := setupTestProductionService(t)

	_ = store.CreateAsset(ctx, &production.Asset{
		AssetID:     "asset-rpc-01",
		WorkspaceID: "ws-test-1",
		Title:       "ConnectRPC Video Asset",
	})

	t.Run("ABTestService ConnectRPC handler create, list, evaluate, and metrics", func(t *testing.T) {
		abHandler := svc.ABTest()

		createReq := connect.NewRequest(&productionv1.ABTestServiceCreateRequest{
			Context: &commonv1.CommandContext{
				WorkspaceId:    &commonv1.UUID{Value: "ws-test-1"},
				IdempotencyKey: "idem-create-01",
			},
			SourceAssetId: "asset-rpc-01",
			Title:         "Proto AB Test",
			Hypothesis:    "Testing thumbnail CTR",
			TargetMetric:  "ctr",
			Variants: []*productionv1.ABVariant{
				{AssetId: "v-1", VariantLabel: "Variant 1", Views: 1500, Impressions: 1500, Clicks: 150, Ctr: 0.10},
				{AssetId: "v-2", VariantLabel: "Variant 2", Views: 1500, Impressions: 1500, Clicks: 60, Ctr: 0.04},
			},
		})

		createResp, err := abHandler.Create(ctx, createReq)
		if err != nil {
			t.Fatalf("ABTest.Create failed: %v", err)
		}
		expID := createResp.Msg.GetExperiment().GetExperimentId()

		// Get
		getResp, err := abHandler.Get(ctx, connect.NewRequest(&productionv1.ABTestServiceGetRequest{
			WorkspaceId:  &commonv1.UUID{Value: "ws-test-1"},
			ExperimentId: expID,
		}))
		if err != nil {
			t.Fatalf("ABTest.Get failed: %v", err)
		}
		if getResp.Msg.GetExperiment().GetTitle() != "Proto AB Test" {
			t.Errorf("unexpected title: %s", getResp.Msg.GetExperiment().GetTitle())
		}
		if !getResp.Msg.GetExperiment().GetIsObservational() {
			t.Errorf("ABTest.Get missing observational flag")
		}

		// Evaluate (requires Manager+ role per rpc_permission_bindings.csv)
		mgrCtx := context.WithValue(ctx, "caller_role", "Manager")
		evalResp, err := abHandler.EvaluateTest(mgrCtx, connect.NewRequest(&productionv1.ABTestServiceEvaluateTestRequest{
			Context: &commonv1.CommandContext{
				WorkspaceId:    &commonv1.UUID{Value: "ws-test-1"},
				IdempotencyKey: "idem-eval-01",
			},
			ExperimentId: expID,
		}))
		if err != nil {
			t.Fatalf("ABTest.EvaluateTest failed: %v", err)
		}
		if !evalResp.Msg.GetIsConclusive() {
			t.Errorf("expected conclusive test for 0.10 vs 0.04 CTR")
		}
		if evalResp.Msg.GetWinnerAssetId() != "v-1" {
			t.Errorf("expected winner v-1, got %s", evalResp.Msg.GetWinnerAssetId())
		}
		if !evalResp.Msg.GetIsObservational() {
			t.Errorf("ABTest.EvaluateTest missing observational flag")
		}

		// GetMetrics
		metricsResp, err := abHandler.GetMetrics(ctx, connect.NewRequest(&productionv1.ABTestServiceGetMetricsRequest{
			WorkspaceId:  &commonv1.UUID{Value: "ws-test-1"},
			ExperimentId: expID,
		}))
		if err != nil {
			t.Fatalf("ABTest.GetMetrics failed: %v", err)
		}
		if len(metricsResp.Msg.GetVariants()) != 2 {
			t.Errorf("expected 2 variants in metrics response, got %d", len(metricsResp.Msg.GetVariants()))
		}
		if !metricsResp.Msg.GetIsObservational() {
			t.Errorf("ABTest.GetMetrics missing observational flag")
		}
	})

	t.Run("PerformanceCoachService ConnectRPC handler all 5 endpoints", func(t *testing.T) {
		coachHandler := svc.PerformanceCoach()

		// 1. GetInsights
		insResp, err := coachHandler.GetInsights(ctx, connect.NewRequest(&productionv1.PerformanceCoachServiceGetInsightsRequest{
			WorkspaceId:   &commonv1.UUID{Value: "ws-test-1"},
			TargetChannel: "tiktok",
			Limit:         5,
		}))
		if err != nil {
			t.Fatalf("PerformanceCoach.GetInsights failed: %v", err)
		}
		if !insResp.Msg.GetIsObservational() {
			t.Errorf("GetInsights response missing is_observational")
		}
		if len(insResp.Msg.GetInsights()) == 0 {
			t.Errorf("GetInsights returned empty insights")
		}

		// 2. GetVideoScorecard
		cardResp, err := coachHandler.GetVideoScorecard(ctx, connect.NewRequest(&productionv1.PerformanceCoachServiceGetVideoScorecardRequest{
			WorkspaceId: &commonv1.UUID{Value: "ws-test-1"},
			AssetId:     "asset-rpc-01",
		}))
		if err != nil {
			t.Fatalf("PerformanceCoach.GetVideoScorecard failed: %v", err)
		}
		if !cardResp.Msg.GetScorecard().GetIsObservational() {
			t.Errorf("GetVideoScorecard response missing is_observational")
		}
		if cardResp.Msg.GetScorecard().GetTitle() != "ConnectRPC Video Asset" {
			t.Errorf("unexpected scorecard title: %s", cardResp.Msg.GetScorecard().GetTitle())
		}

		// 3. GetImprovementPlan
		planResp, err := coachHandler.GetImprovementPlan(ctx, connect.NewRequest(&productionv1.PerformanceCoachServiceGetImprovementPlanRequest{
			Context: &commonv1.CommandContext{
				WorkspaceId:    &commonv1.UUID{Value: "ws-test-1"},
				IdempotencyKey: "idem-plan-01",
			},
			Timeframe: "7d",
		}))
		if err != nil {
			t.Fatalf("PerformanceCoach.GetImprovementPlan failed: %v", err)
		}
		if !planResp.Msg.GetPlan().GetIsObservational() {
			t.Errorf("GetImprovementPlan response missing is_observational")
		}
		if len(planResp.Msg.GetPlan().GetActionItems()) == 0 {
			t.Errorf("GetImprovementPlan missing action items")
		}

		// 4. ListBenchmarks
		bmResp, err := coachHandler.ListBenchmarks(ctx, connect.NewRequest(&productionv1.PerformanceCoachServiceListBenchmarksRequest{
			WorkspaceId: &commonv1.UUID{Value: "ws-test-1"},
			Platform:    "tiktok",
			Niche:       "beauty",
		}))
		if err != nil {
			t.Fatalf("PerformanceCoach.ListBenchmarks failed: %v", err)
		}
		if !bmResp.Msg.GetIsObservational() {
			t.Errorf("ListBenchmarks missing is_observational")
		}

		// 5. CompareToIndustry
		compResp, err := coachHandler.CompareToIndustry(ctx, connect.NewRequest(&productionv1.PerformanceCoachServiceCompareToIndustryRequest{
			WorkspaceId: &commonv1.UUID{Value: "ws-test-1"},
			Platform:    "tiktok",
			Niche:       "beauty",
		}))
		if err != nil {
			t.Fatalf("PerformanceCoach.CompareToIndustry failed: %v", err)
		}
		if !compResp.Msg.GetComparison().GetIsObservational() {
			t.Errorf("CompareToIndustry missing is_observational")
		}
		if compResp.Msg.GetComparison().GetPercentileRank() == "" {
			t.Errorf("CompareToIndustry missing percentile rank")
		}
	})
}

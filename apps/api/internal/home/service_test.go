package home_test

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/home"
)

const (
	testWorkspaceID = "99999999-9999-4000-8000-000000000001"
)

func TestSixModeIdentitiesRetained(t *testing.T) {
	svc := home.NewService(nil)
	ctx := context.Background()

	modes := []struct {
		mode         adminv1.OperatorModeId
		expectedCard string
		name         string
	}{
		{
			mode:         adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR,
			expectedCard: "card-creator-trend",
			name:         "Solo Creator",
		},
		{
			mode:         adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
			expectedCard: "card-seller-orders",
			name:         "Seller",
		},
		{
			mode:         adminv1.OperatorModeId_OPERATOR_MODE_ID_AFFILIATE_OPERATOR,
			expectedCard: "card-affiliate-links",
			name:         "Affiliate Operator",
		},
		{
			mode:         adminv1.OperatorModeId_OPERATOR_MODE_ID_LIVE_OPERATOR,
			expectedCard: "card-live-readiness",
			name:         "Live Operator",
		},
		{
			mode:         adminv1.OperatorModeId_OPERATOR_MODE_ID_AGENCY_MCN,
			expectedCard: "card-agency-approvals",
			name:         "Agency / MCN",
		},
		{
			mode:         adminv1.OperatorModeId_OPERATOR_MODE_ID_BRAND_COLLABORATION,
			expectedCard: "card-brand-inquiries",
			name:         "Brand Collaboration",
		},
	}

	for _, tc := range modes {
		t.Run(tc.name, func(t *testing.T) {
			resp, err := svc.GetDecisionCards(ctx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
				WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
				OperatorMode: tc.mode,
			}))
			if err != nil {
				t.Fatalf("GetDecisionCards failed for %s: %v", tc.name, err)
			}
			if len(resp.Msg.Cards) == 0 {
				t.Fatalf("expected decision cards for %s, got 0", tc.name)
			}
			// Verify top priority card matches canonical mode identity
			topCard := resp.Msg.Cards[0]
			if topCard.CardId != tc.expectedCard {
				t.Errorf("expected top card %s for %s, got %s", tc.expectedCard, tc.name, topCard.CardId)
			}
		})
	}
}

func TestUnbuiltActionUnavailableWithExplanation(t *testing.T) {
	svc := home.NewService(nil)
	svc.SetPhase("P0")
	ctx := context.Background()

	// Get decision cards for Seller mode
	resp, err := svc.GetDecisionCards(ctx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
		WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
		OperatorMode: adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetDecisionCards failed: %v", err)
	}

	for _, card := range resp.Msg.Cards {
		if !card.IsActionAvailable {
			// Acceptance Target 2: unbuilt action MUST provide non-empty explanation
			if card.UnavailableReason == "" {
				t.Errorf("card %s is unavailable but missing unavailable_reason", card.CardId)
			}
		}
	}

	// Verify Creator cards: Diagnostics card is AVAILABLE (P0-05), while AI Video Studio is UNAVAILABLE
	respCreator, _ := svc.GetDecisionCards(ctx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
		WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
		OperatorMode: adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR,
	}))
	for _, card := range respCreator.Msg.Cards {
		if card.CardId == "card-creator-repair" {
			if !card.IsActionAvailable {
				t.Errorf("diagnostics card should be available in P0")
			}
		}
		if card.CardId == "card-creator-script" {
			if card.IsActionAvailable {
				t.Errorf("script lab should be marked unavailable in P0")
			}
			if card.UnavailableReason == "" {
				t.Errorf("script lab must state unavailable reason")
			}
		}
	}
}

func TestNoDemoDataInCustomerTotals(t *testing.T) {
	svc := home.NewService(nil)
	ctx := context.Background()

	// 1. Seed real customer metric (e.g. 5,000,000 VND from official Shopee sync)
	svc.SeedWorkspaceMetric(testWorkspaceID, home.StoredMetric{
		MetricKey:     "revenue_today",
		DisplayName:   "Doanh thu hôm nay (Chính thức)",
		AmountCents:   5000000,
		Currency:      "VND",
		DataSource:    adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
		Confidence:    adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
		LastSyncedAt:  time.Now().UTC(),
		IsDemoFixture: false,
	})

	// 2. Seed a separate DEMO fixture (e.g. 99,000,000 VND simulated demo)
	svc.SeedWorkspaceMetric(testWorkspaceID, home.StoredMetric{
		MetricKey:     "demo_simulation_metric",
		DisplayName:   "Doanh thu mô phỏng (Demo)",
		AmountCents:   99000000,
		Currency:      "VND",
		DataSource:    adminv1.DataSourceBadge_DATA_SOURCE_BADGE_DEMO,
		Confidence:    adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_LOW,
		LastSyncedAt:  time.Now().UTC(),
		IsDemoFixture: true,
	})

	// 3. Request Mobile Home
	resp, err := svc.GetMobileHome(ctx, connect.NewRequest(&adminv1.GetMobileHomeRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		ActiveMode:  adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetMobileHome failed: %v", err)
	}

	// Acceptance Target 3: customer_verified_total_revenue MUST ONLY reflect the 5,000,000 VND, NOT 104,000,000 VND!
	expectedFormatted := "5.000.000 ₫"
	if resp.Msg.CustomerVerifiedTotalRevenue != expectedFormatted {
		t.Fatalf("ACCEPTANCE VIOLATION: Customer verified total includes demo data! Expected %s, got %s",
			expectedFormatted, resp.Msg.CustomerVerifiedTotalRevenue)
	}
}

func TestWhyThisNumberBreakdown(t *testing.T) {
	svc := home.NewService(nil)
	ctx := context.Background()

	svc.SeedWorkspaceMetric(testWorkspaceID, home.StoredMetric{
		MetricKey:          "revenue_today",
		DisplayName:        "Doanh thu hôm nay",
		AmountCents:        3200000,
		Currency:           "VND",
		DataSource:         adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED,
		Confidence:         adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_MEDIUM,
		LastSyncedAt:       time.Now().UTC(),
		DataOrigins:        []string{"Tệp CSV đơn hàng TikTok Shop ngày 02/11/2026"},
		MissingDataCaveats: []string{"Chưa đối soát phí sàn chính thức từ báo cáo sao kê."},
		RecommendedSteps:   []string{"Tải lên file sao kê ngân sách quảng cáo để tính lợi nhuận ròng."},
		IsDemoFixture:      false,
	})

	resp, err := svc.GetWhyThisNumber(ctx, connect.NewRequest(&adminv1.GetWhyThisNumberRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		MetricKey:   "revenue_today",
	}))
	if err != nil {
		t.Fatalf("GetWhyThisNumber failed: %v", err)
	}

	details := resp.Msg.Details
	if details.DataSource != adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED {
		t.Errorf("expected source IMPORTED, got %v", details.DataSource)
	}
	if details.Confidence != adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_MEDIUM {
		t.Errorf("expected confidence MEDIUM, got %v", details.Confidence)
	}
	if details.ContainsDemoData {
		t.Errorf("expected ContainsDemoData=false")
	}
	if len(details.MissingDataCaveats) == 0 {
		t.Errorf("expected missing data caveats to be provided")
	}
}

func TestOnboardingChecklistProgress(t *testing.T) {
	svc := home.NewService(nil)
	ctx := context.Background()

	// Initial checklist (0/5 steps)
	homeResp, err := svc.GetMobileHome(ctx, connect.NewRequest(&adminv1.GetMobileHomeRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		ActiveMode:  adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR,
	}))
	if err != nil {
		t.Fatalf("GetMobileHome failed: %v", err)
	}
	if homeResp.Msg.Onboarding.CompletedCount != 0 {
		t.Errorf("expected initial completed count 0, got %d", homeResp.Msg.Onboarding.CompletedCount)
	}
	if homeResp.Msg.Onboarding.TotalSteps != 5 {
		t.Errorf("expected 5 total steps, got %d", homeResp.Msg.Onboarding.TotalSteps)
	}

	// Complete Step 1 (connect_data)
	compResp, err := svc.CompleteOnboardingStep(ctx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  1,
	}))
	if err != nil {
		t.Fatalf("CompleteOnboardingStep failed: %v", err)
	}
	if compResp.Msg.UpdatedChecklist.CompletedCount != 1 {
		t.Errorf("expected completed count 1, got %d", compResp.Msg.UpdatedChecklist.CompletedCount)
	}
	if !compResp.Msg.UpdatedChecklist.Steps[0].IsCompleted {
		t.Errorf("expected Step 1 is_completed=true")
	}
}

func TestP105NoConnectorRequiredForAuthorizedImportAndDataRepair(t *testing.T) {
	svc := home.NewService(nil)
	svc.SetPhase("P1")
	now := time.Date(2026, 11, 2, 8, 0, 0, 0, time.UTC)

	ownerCtx := home.WithCallerContext(context.Background(), home.CallerContext{
		UserID:        "user_owner_1",
		WorkspaceID:   testWorkspaceID,
		WorkspaceRole: "owner",
	})
	memberCtx := home.WithCallerContext(context.Background(), home.CallerContext{
		UserID:        "user_member_2",
		WorkspaceID:   testWorkspaceID,
		WorkspaceRole: "editor",
	})
	viewerCtx := home.WithCallerContext(context.Background(), home.CallerContext{
		UserID:        "user_viewer_3",
		WorkspaceID:   testWorkspaceID,
		WorkspaceRole: "viewer",
	})

	// 1. Demo fixture import must be rejected (Demo fixtures never contribute to customer profit or activation).
	if _, err := svc.IngestAuthorizedImport(ownerCtx, home.AuthorizedImportRequest{
		WorkspaceID:            testWorkspaceID,
		ConnectedAccountsCount: 0,
		OrdersCount:            5,
		GrossRevenueCents:      10000000,
		IsDemoFixture:          true,
		ImportedAt:             now,
	}); err == nil {
		t.Fatalf("expected demo fixture import to be rejected")
	}

	// 2. Viewer role must be denied import mutation.
	if _, err := svc.IngestAuthorizedImport(viewerCtx, home.AuthorizedImportRequest{
		WorkspaceID:            testWorkspaceID,
		ConnectedAccountsCount: 0,
		OrdersCount:            5,
		GrossRevenueCents:      10000000,
		ImportedAt:             now,
	}); err == nil {
		t.Fatalf("expected viewer role to be denied IngestAuthorizedImport")
	}

	// 3. Seller Owner with ZERO connected accounts imports a valid product/order/cost sample with 2 data-repair gaps.
	proj, err := svc.IngestAuthorizedImport(ownerCtx, home.AuthorizedImportRequest{
		WorkspaceID:            testWorkspaceID,
		ConnectedAccountsCount: 0, // NO native API connector required!
		ProductsCount:          3,
		OrdersCount:            12,
		CostsCount:             1,
		GrossRevenueCents:      8500000,
		KnownCostsCents:        2100000,
		Currency:               "VND",
		RepairGaps: []home.DataRepairGap{
			{
				GapID:       "gap-missing-cogs-sku-a",
				GapKind:     "missing_cogs",
				Title:       "Thiếu giá vốn (COGS) cho 2 SKU bán chạy",
				Reason:      "2 SKU trong lô nhập CSV chưa có giá vốn; lợi nhuận đang gắn nhãn chưa hoàn chỉnh (Confidence: LOW).",
				RepairCTA:   "Cập nhật giá vốn SKU",
				RepairRoute: "/kinh-doanh",
				AmountCents: 1500000,
				Currency:    "VND",
			},
			{
				GapID:       "gap-unmatched-settlement-nov",
				GapKind:     "unmatched_settlement",
				Title:       "Chênh lệch đối soát sao kê chưa khớp",
				Reason:      "1 khoản thanh toán 450.000 ₫ chưa khớp chứng từ đơn hàng.",
				RepairCTA:   "Mở hàng đợi đối soát",
				RepairRoute: "/kinh-doanh",
				AmountCents: 450000,
				Currency:    "VND",
			},
		},
		ImportedAt: now,
	})
	if err != nil {
		t.Fatalf("IngestAuthorizedImport with 0 connectors failed: %v", err)
	}
	if proj.ConnectedAccountsCount != 0 || proj.RequiresNativeConnector {
		t.Fatalf("expected ConnectedAccountsCount=0 and RequiresNativeConnector=false, got count=%d req=%v",
			proj.ConnectedAccountsCount, proj.RequiresNativeConnector)
	}
	if proj.SourceBadge != adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED {
		t.Fatalf("expected source badge IMPORTED, got %v", proj.SourceBadge)
	}
	if proj.Confidence != adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_LOW || !proj.IsIncomplete || proj.UnknownRequiredComponentsCount != 2 {
		t.Fatalf("expected Confidence=LOW, IsIncomplete=true, UnknownRequiredComponentsCount=2, got conf=%v inc=%v unk=%d",
			proj.Confidence, proj.IsIncomplete, proj.UnknownRequiredComponentsCount)
	}
	if proj.FormattedGrossRevenue != "8.500.000 ₫" || proj.FormattedNetProfit != "6.400.000 ₫" {
		t.Fatalf("unexpected formatted revenue/profit: rev=%s net=%s", proj.FormattedGrossRevenue, proj.FormattedNetProfit)
	}

	// Verify Owner's personal onboarding progress: Steps 1, 2, 5 completed (3/5), Steps 3 & 4 unavailable, IsClosedLoopComplete=false!
	if proj.PersonalOnboarding.CompletedCount != 3 || proj.PersonalOnboarding.IsClosedLoopComplete {
		t.Fatalf("expected CompletedCount=3 and IsClosedLoopComplete=false in P1, got count=%d complete=%v",
			proj.PersonalOnboarding.CompletedCount, proj.PersonalOnboarding.IsClosedLoopComplete)
	}
	if proj.PersonalOnboarding.Steps[2].IsAvailable || proj.PersonalOnboarding.Steps[3].IsAvailable {
		t.Fatalf("expected future-phase Steps 3 and 4 to remain IsAvailable=false in P1")
	}

	// Attempting to complete unshipped future step 3 in P1 must fail closed.
	if _, err := svc.CompleteOnboardingStep(ownerCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  3,
	})); err == nil {
		t.Fatalf("expected completing unavailable future-phase step 3 in P1 to fail")
	}

	// 4. Verify personal onboarding isolation: Member 2 starts at 0/5 and completing Step 1 for Member 2
	//    does NOT alter Owner's progress or workspace dashboard config.
	cfgBefore := svc.GetWorkspaceDashboardConfig(testWorkspaceID)
	memberHome, err := svc.GetMobileHome(memberCtx, connect.NewRequest(&adminv1.GetMobileHomeRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		ActiveMode:  adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetMobileHome for member failed: %v", err)
	}
	if memberHome.Msg.Onboarding.CompletedCount != 0 {
		t.Fatalf("expected member personal onboarding to be isolated at 0 completed steps, got %d", memberHome.Msg.Onboarding.CompletedCount)
	}
	if _, err := svc.CompleteOnboardingStep(memberCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  1,
	})); err != nil {
		t.Fatalf("member CompleteOnboardingStep(1) failed: %v", err)
	}
	cfgAfter := svc.GetWorkspaceDashboardConfig(testWorkspaceID)
	if cfgBefore.MorningBriefTime != cfgAfter.MorningBriefTime || cfgBefore.Timezone != cfgAfter.Timezone {
		t.Fatalf("member personal checklist completion must not mutate workspace settings")
	}

	// 5. Verify RBAC privacy on Data-Repair cards:
	//    Owner sees the 2 data_repair cards; Viewer sees ZERO data_repair or M19 cards and ZERO revenue total!
	ownerCardsResp, err := svc.GetDecisionCards(ownerCtx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
		WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
		OperatorMode: adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetDecisionCards for owner failed: %v", err)
	}
	repairCountOwner := 0
	for _, c := range ownerCardsResp.Msg.Cards {
		if c.CardFamily == "data_repair" {
			repairCountOwner++
		}
	}
	if repairCountOwner != 2 {
		t.Fatalf("expected Owner to see 2 data_repair cards, got %d", repairCountOwner)
	}

	viewerCardsResp, err := svc.GetDecisionCards(viewerCtx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
		WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
		OperatorMode: adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetDecisionCards for viewer failed: %v", err)
	}
	for _, c := range viewerCardsResp.Msg.Cards {
		if c.CardFamily == "data_repair" || c.ModuleRef == "M19" || c.CardFamily == "revenue_today" {
			t.Fatalf("RBAC PRIVACY VIOLATION: viewer saw restricted finance/repair card %s (%s)", c.CardId, c.CardFamily)
		}
	}
	viewerHomeResp, err := svc.GetMobileHome(viewerCtx, connect.NewRequest(&adminv1.GetMobileHomeRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		ActiveMode:  adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetMobileHome for viewer failed: %v", err)
	}
	if viewerHomeResp.Msg.CustomerVerifiedTotalRevenue != "" {
		t.Fatalf("RBAC PRIVACY VIOLATION: viewer saw CustomerVerifiedTotalRevenue=%q", viewerHomeResp.Msg.CustomerVerifiedTotalRevenue)
	}

	// 6. Completing the underlying repairs in domain state dynamically removes the repair cards
	//    and upgrades profit confidence from LOW to MEDIUM.
	afterRepair1, err := svc.ResolveUnderlyingDataRepair(ownerCtx, testWorkspaceID, "gap-missing-cogs-sku-a", 1500000)
	if err != nil {
		t.Fatalf("ResolveUnderlyingDataRepair 1 failed: %v", err)
	}
	if len(afterRepair1.ActiveRepairCards) != 1 || afterRepair1.FormattedNetProfit != "4.900.000 ₫" {
		t.Fatalf("expected 1 remaining repair card and net profit 4.900.000 ₫, got cards=%d net=%s",
			len(afterRepair1.ActiveRepairCards), afterRepair1.FormattedNetProfit)
	}

	afterRepair2, err := svc.ResolveUnderlyingDataRepair(ownerCtx, testWorkspaceID, "gap-unmatched-settlement-nov", 0)
	if err != nil {
		t.Fatalf("ResolveUnderlyingDataRepair 2 failed: %v", err)
	}
	if len(afterRepair2.ActiveRepairCards) != 0 || afterRepair2.IsIncomplete || afterRepair2.Confidence != adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_MEDIUM {
		t.Fatalf("expected 0 repair cards, IsIncomplete=false, Confidence=MEDIUM after resolving all gaps, got cards=%d inc=%v conf=%v",
			len(afterRepair2.ActiveRepairCards), afterRepair2.IsIncomplete, afterRepair2.Confidence)
	}
}

func TestP105DSTAndTimezoneCannotDoubleDeliverMorningBrief(t *testing.T) {
	svc := home.NewService(nil)
	ownerCtx := home.WithCallerContext(context.Background(), home.CallerContext{
		UserID:        "user_owner_1",
		WorkspaceID:   testWorkspaceID,
		WorkspaceRole: "owner",
	})

	// 1. Workspace with no authorized data (only demo fixture) is ineligible for Morning Brief.
	svc.SeedWorkspaceMetric(testWorkspaceID, home.StoredMetric{
		MetricKey:     "demo_only",
		AmountCents:   5000000,
		DataSource:    adminv1.DataSourceBadge_DATA_SOURCE_BADGE_DEMO,
		IsDemoFixture: true,
	})
	ineligibleRes, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID: testWorkspaceID,
		NowUTC:      time.Date(2026, 11, 1, 0, 5, 0, 0, time.UTC), // 07:05 Asia/Ho_Chi_Minh
	})
	if err != nil || ineligibleRes.Decision != "ineligible_no_authorized_data" {
		t.Fatalf("expected workspace with only demo fixture to be ineligible_no_authorized_data, got %+v, err=%v", ineligibleRes, err)
	}

	// 2. Ingest authorized P1 import (with 0 connected accounts) -> workspace becomes eligible!
	if _, err := svc.IngestAuthorizedImport(ownerCtx, home.AuthorizedImportRequest{
		WorkspaceID:            testWorkspaceID,
		ConnectedAccountsCount: 0,
		ProductsCount:          2,
		OrdersCount:            4,
		GrossRevenueCents:      3200000,
		KnownCostsCents:        1200000,
		Currency:               "VND",
	}); err != nil {
		t.Fatalf("IngestAuthorizedImport failed: %v", err)
	}

	// 3. Configure workspace for America/New_York at "01:30" on US DST Fall-Back day (Sunday 2026-11-01).
	//    On 2026-11-01 in America/New_York:
	//      - First 01:30 local time is 01:30 EDT (UTC-4) = 2026-11-01T05:30:00Z
	//      - Second 01:30 local time (after fall-back at 02:00 EDT -> 01:00 EST) is 01:30 EST (UTC-5) = 2026-11-01T06:30:00Z
	if _, err := svc.ConfigureWorkspaceDashboard(home.HomeDashboardConfig{
		WorkspaceID:          testWorkspaceID,
		OperatorMode:         adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
		Timezone:             "America/New_York",
		MorningBriefEnabled:  true,
		MorningBriefTime:     "01:30",
		MorningBriefChannels: []string{"push", "in_app"},
	}); err != nil {
		t.Fatalf("ConfigureWorkspaceDashboard failed: %v", err)
	}

	// First 01:30 local occurrence (EDT, 05:30 UTC): delivers once!
	dstRun1, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID: testWorkspaceID,
		NowUTC:      time.Date(2026, 11, 1, 5, 30, 0, 0, time.UTC),
	})
	if err != nil || dstRun1.Decision != home.MorningBriefStatusDelivered || dstRun1.AlreadyProcessedForLocalDate {
		t.Fatalf("expected first 01:30 EDT evaluation to deliver brief, got %+v, err=%v", dstRun1, err)
	}
	if dstRun1.LocalDate != "2026-11-01" || dstRun1.Record == nil || len(dstRun1.Record.Items) != 5 {
		t.Fatalf("expected local_date=2026-11-01 and 5 brief items, got date=%s rec=%+v", dstRun1.LocalDate, dstRun1.Record)
	}

	// Second 01:30 local occurrence 1 hour later during DST fall-back (EST, 06:30 UTC): MUST NOT double-deliver!
	dstRun2, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID: testWorkspaceID,
		NowUTC:      time.Date(2026, 11, 1, 6, 30, 0, 0, time.UTC),
	})
	if err != nil || dstRun2.Decision != "already_delivered_local_date" || !dstRun2.AlreadyProcessedForLocalDate {
		t.Fatalf("ACCEPTANCE VIOLATION: DST fall-back double-delivered brief! got %+v, err=%v", dstRun2, err)
	}

	// 4. Timezone change test on 2026-11-02:
	//    Configure Asia/Ho_Chi_Minh (UTC+7) at 07:00 -> delivers at 2026-11-02T00:02:00Z (07:02 ICT).
	//    Then change workspace timezone to Europe/London (UTC+0) at 07:00 -> when 2026-11-02T07:02:00Z arrives (07:02 GMT on 2026-11-02),
	//    it MUST NOT deliver a second time for local_date 2026-11-02!
	_, _ = svc.ConfigureWorkspaceDashboard(home.HomeDashboardConfig{
		WorkspaceID:         testWorkspaceID,
		OperatorMode:        adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
		Timezone:            "Asia/Ho_Chi_Minh",
		MorningBriefEnabled: true,
		MorningBriefTime:    "07:00",
	})
	tzRun1, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID: testWorkspaceID,
		NowUTC:      time.Date(2026, 11, 2, 0, 2, 0, 0, time.UTC), // 07:02 ICT on 2026-11-02
	})
	if err != nil || tzRun1.Decision != home.MorningBriefStatusDelivered {
		t.Fatalf("expected 07:02 ICT on 2026-11-02 to deliver, got %+v, err=%v", tzRun1, err)
	}

	// Operator changes workspace timezone to Europe/London on the same day:
	_, _ = svc.ConfigureWorkspaceDashboard(home.HomeDashboardConfig{
		WorkspaceID:         testWorkspaceID,
		OperatorMode:        adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
		Timezone:            "Europe/London",
		MorningBriefEnabled: true,
		MorningBriefTime:    "07:00",
	})
	tzRun2, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID: testWorkspaceID,
		NowUTC:      time.Date(2026, 11, 2, 7, 2, 0, 0, time.UTC), // 07:02 GMT on 2026-11-02
	})
	if err != nil || tzRun2.Decision != "already_delivered_local_date" || !tzRun2.AlreadyProcessedForLocalDate {
		t.Fatalf("ACCEPTANCE VIOLATION: Timezone change double-delivered brief for 2026-11-02! got %+v, err=%v", tzRun2, err)
	}

	// 5. Missed run (stale window > 15m) on 2026-11-03 at 09:00 GMT when configured for 07:00 GMT -> skipped_stale_window!
	staleRun, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID: testWorkspaceID,
		NowUTC:      time.Date(2026, 11, 3, 9, 0, 0, 0, time.UTC),
	})
	if err != nil || staleRun.Decision != "skipped_stale_window" {
		t.Fatalf("expected missed window (09:00 vs 07:00) to return skipped_stale_window, got %+v, err=%v", staleRun, err)
	}

	// 6. Separate generated, delivered, and failed outcomes + retry audit on 2026-11-04:
	failDeliv, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID:        testWorkspaceID,
		NowUTC:             time.Date(2026, 11, 4, 7, 1, 0, 0, time.UTC),
		ForceDeliveryError: context.DeadlineExceeded,
	})
	if err != nil || failDeliv.Decision != home.MorningBriefStatusFailed || failDeliv.Record == nil {
		t.Fatalf("expected delivery failure to record Status=failed, got %+v, err=%v", failDeliv, err)
	}
	if failDeliv.Record.GeneratedAt == nil || failDeliv.Record.DeliveredAt != nil || failDeliv.Record.FailedAt == nil {
		t.Fatalf("expected GeneratedAt!=nil, DeliveredAt==nil, FailedAt!=nil on delivery failure, got %+v", failDeliv.Record)
	}

	// Subsequent automatic cron tick without IsExplicitRetry does NOT resend stale failed brief:
	noStaleRetry, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID:     testWorkspaceID,
		NowUTC:          time.Date(2026, 11, 4, 7, 3, 0, 0, time.UTC),
		IsExplicitRetry: false,
	})
	if err != nil || noStaleRetry.Decision != "already_failed_no_stale_resend" {
		t.Fatalf("expected automatic tick after failure to return already_failed_no_stale_resend, got %+v, err=%v", noStaleRetry, err)
	}

	// Explicit audited retry within freshness window succeeds and records audit trail:
	explicitRetry, err := svc.EvaluateAndDeliverMorningBrief(home.MorningBriefEvalInput{
		WorkspaceID:     testWorkspaceID,
		NowUTC:          time.Date(2026, 11, 4, 7, 5, 0, 0, time.UTC),
		IsExplicitRetry: true,
	})
	if err != nil || explicitRetry.Decision != home.MorningBriefStatusDelivered || explicitRetry.Record.RetryCount != 1 {
		t.Fatalf("expected explicit audited retry to deliver with RetryCount=1, got %+v, err=%v", explicitRetry, err)
	}
}

func TestP105PilotMeasurementsRecordActualUnknowns(t *testing.T) {
	svc := home.NewService(nil)
	winStart := time.Date(2026, 11, 1, 0, 0, 0, 0, time.UTC)
	winEnd := time.Date(2026, 11, 8, 0, 0, 0, 0, time.UTC)
	created := winStart.Add(1 * time.Hour)
	viewed := created.Add(15 * time.Minute) // 900 seconds

	// 1. Record demo and internal observations -> must be excluded from cohort report.
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:    "ws-demo",
		ObjectID:       "obj-demo",
		OperationID:    "op-demo",
		IsDemoFixture:  true,
		Kind:           "repair_batch",
		SourceClass:    home.SourceClassImported,
		ConfidenceBand: home.ConfidenceBandHigh,
		ObservedAt:     winStart.Add(2 * time.Hour),
	})
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:                 "ws-internal",
		ObjectID:                    "obj-int",
		OperationID:                 "op-int",
		IsInternalAccount:           true,
		Kind:                        "production_job",
		StartedProductionJob:        true,
		AcceptedWithinBoundedPasses: true,
		ObservedAt:                  winStart.Add(2 * time.Hour),
	})

	// 2. Record First Value observations (1 known latency = 900s, 1 unknown latency where FirstSnapshotViewedAt is nil).
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:               "ws-pilot-1",
		ObjectID:                  "onb-1",
		OperationID:               "fv-1",
		Kind:                      "first_value_view",
		SourceClass:               home.SourceClassImported,
		ConfidenceBand:            home.ConfidenceBandMediumHigh,
		WorkspaceCreatedAt:        &created,
		FirstSnapshotViewedAt:     &viewed,
		HasSourceAndGapDisclosure: true,
		ObservedAt:                viewed,
	})
	// Duplicate (workspace_id, object_id, operation_id) -> must be deduplicated!
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:               "ws-pilot-1",
		ObjectID:                  "onb-1",
		OperationID:               "fv-1",
		Kind:                      "first_value_view",
		SourceClass:               home.SourceClassImported,
		ConfidenceBand:            home.ConfidenceBandMediumHigh,
		WorkspaceCreatedAt:        &created,
		FirstSnapshotViewedAt:     &viewed,
		HasSourceAndGapDisclosure: true,
		ObservedAt:                viewed,
	})
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:               "ws-pilot-2",
		ObjectID:                  "onb-2",
		OperationID:               "fv-2",
		Kind:                      "first_value_view",
		SourceClass:               home.SourceClassImported,
		ConfidenceBand:            home.ConfidenceBandLowMedium,
		WorkspaceCreatedAt:        &created,
		FirstSnapshotViewedAt:     nil, // not yet reached first value -> unknown latency, never 0
		HasSourceAndGapDisclosure: false,
		ObservedAt:                winStart.Add(3 * time.Hour),
	})

	// 3. Record Repair Burden batches where OperatorRepairSeconds is nil (missing time tracking -> MUST remain unknown, NEVER 0).
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:                 "ws-pilot-1",
		ObjectID:                    "batch-csv-1",
		OperationID:                 "import-1",
		Kind:                        "repair_batch",
		SourceClass:                 home.SourceClassImported,
		ConfidenceBand:              home.ConfidenceBandLow,
		UnresolvedRequiredGapsCount: 3,
		OperatorRepairSeconds:       nil, // Missing operator time tracking!
		ObservedAt:                  winStart.Add(4 * time.Hour),
	})
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:                 "ws-pilot-2",
		ObjectID:                    "batch-csv-2",
		OperationID:                 "import-2",
		Kind:                        "repair_batch",
		SourceClass:                 home.SourceClassEstimated,
		ConfidenceBand:              home.ConfidenceBandMedium,
		UnresolvedRequiredGapsCount: 1,
		OperatorRepairSeconds:       nil, // Missing operator time tracking!
		ObservedAt:                  winStart.Add(5 * time.Hour),
	})

	// 4. Record Production Jobs with 2 started jobs and ZERO accepted outputs -> CostPerAcceptedOutput MUST be undefined/unknown, NEVER 0!
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:                 "ws-pilot-1",
		ObjectID:                    "job-1",
		OperationID:                 "gen-1",
		Kind:                        "production_job",
		SourceClass:                 home.SourceClassOfficial,
		ConfidenceBand:              home.ConfidenceBandHigh,
		StartedProductionJob:        true,
		AcceptedWithinBoundedPasses: false,
		SettledProviderCostMicros:   400000, // $0.40
		SettledCreditsMicros:        54000000,
		ObservedAt:                  winStart.Add(6 * time.Hour),
	})

	// 5. Record Unit Economics scope with nil COGSMicros and nil ShippingCostsMicros -> recorded as explicit unknowns!
	knownFee := int64(250000000000)
	_ = svc.RecordPilotObservation(home.PilotObservation{
		WorkspaceID:             "ws-pilot-1",
		ObjectID:                "scope-order-1",
		OperationID:             "econ-1",
		Kind:                    "unit_economics",
		SourceClass:             home.SourceClassUnreconciled,
		ConfidenceBand:          home.ConfidenceBandLow,
		RecognizedRevenueMicros: 3200000000000,
		PlatformFeesMicros:      &knownFee,
		ShippingCostsMicros:     nil, // Unknown shipping cost!
		COGSMicros:              nil, // Unknown COGS!
		ObservedAt:              winStart.Add(7 * time.Hour),
	})

	report := svc.BuildPilotCohortReport(winStart, winEnd)

	if report.ExcludedDemoOrInternalCount != 2 {
		t.Fatalf("expected 2 excluded demo/internal observations, got %d", report.ExcludedDemoOrInternalCount)
	}
	if report.DeduplicatedDuplicatesCount != 1 {
		t.Fatalf("expected 1 deduplicated observation, got %d", report.DeduplicatedDuplicatesCount)
	}

	// Verify all 5 canonical confidence bands are preserved without collapsing medium_high or low_medium:
	for _, band := range []string{
		home.ConfidenceBandHigh,
		home.ConfidenceBandMediumHigh,
		home.ConfidenceBandMedium,
		home.ConfidenceBandLowMedium,
		home.ConfidenceBandLow,
	} {
		if report.ConfidenceBandDistribution[band] == 0 {
			t.Fatalf("expected uncollapsed confidence_band %q to be present in distribution, got %+v", band, report.ConfidenceBandDistribution)
		}
	}

	// Verify Repair Burden: missing operator time tracking remains unknown (OperatorTimeKnown=false, MedianOperatorRepairSeconds=nil), NEVER 0!
	if report.RepairBurden.OperatorTimeKnown || report.RepairBurden.MedianOperatorRepairSeconds != nil {
		t.Fatalf("ACCEPTANCE VIOLATION: missing operator time tracking was fabricated as known/zero! got %+v", report.RepairBurden)
	}
	if report.RepairBurden.UnknownOperatorTimeBatchesCount != 2 || report.RepairBurden.MedianUnresolvedRequiredGapsCount == nil || *report.RepairBurden.MedianUnresolvedRequiredGapsCount != 2 {
		t.Fatalf("unexpected RepairBurden counts: %+v", report.RepairBurden)
	}

	// Verify Cost per Accepted Output: 0 accepted outputs -> CostPerAcceptedOutputKnown=false, nil pointers, status="undefined_zero_accepted_outputs"!
	if report.ProductionYieldAndCost.CostPerAcceptedOutputKnown ||
		report.ProductionYieldAndCost.CostUSDPerAcceptedMicros != nil ||
		report.ProductionYieldAndCost.CreditsPerAcceptedMicros != nil ||
		report.ProductionYieldAndCost.CostPerAcceptedOutputStatus != "undefined_zero_accepted_outputs" {
		t.Fatalf("ACCEPTANCE VIOLATION: zero accepted outputs fabricated a zero cost per accepted output! got %+v", report.ProductionYieldAndCost)
	}

	// Verify Net Unit Economics: records actual unknown cost components (cogs=1, shipping_costs=1).
	if !report.NetUnitEconomics.HasUnknownCosts ||
		report.NetUnitEconomics.IncompleteScopesCount != 1 ||
		report.NetUnitEconomics.UnknownComponentCounts["cogs"] != 1 ||
		report.NetUnitEconomics.UnknownComponentCounts["shipping_costs"] != 1 {
		t.Fatalf("expected NetUnitEconomics to record unknown cogs=1 and shipping_costs=1, got %+v", report.NetUnitEconomics)
	}
}

// -----------------------------------------------------------------------------
// P8-01 Acceptance Suite: Six-Mode Home, Parity & Onboarding Completion
// -----------------------------------------------------------------------------

func TestP801AcceptanceTarget1_AllSixModePriorities(t *testing.T) {
	svc := home.NewService(nil)
	ctx := context.Background()

	type modeTestCase struct {
		mode            adminv1.OperatorModeId
		name            string
		expectedLen     int
		expectedCardIds []string
		expectedRoutes  []string
		expectedModules []string
	}

	testCases := []modeTestCase{
		{
			mode:        adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR,
			name:        "Creator Mode",
			expectedLen: 7,
			expectedCardIds: []string{
				"card-creator-trend",
				"card-creator-ideas",
				"card-creator-script",
				"card-creator-publish",
				"card-creator-comments",
				"card-creator-earnings",
				"card-creator-repair",
			},
			expectedRoutes: []string{
				"/kham-pha",
				"/ideas",
				"/scripts",
				"/xuat-ban",
				"/inbox",
				"/finance",
				"/settings/diagnostics",
			},
			expectedModules: []string{"M02", "M05", "M06", "M11", "M12", "M19", "M22"},
		},
		{
			mode:        adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
			name:        "Seller Mode",
			expectedLen: 5,
			expectedCardIds: []string{
				"card-seller-orders",
				"card-seller-revenue",
				"card-seller-stock",
				"card-seller-profit",
				"card-seller-messages",
			},
			expectedRoutes: []string{
				"/kinh-doanh",
				"/finance",
				"/kinh-doanh",
				"/finance",
				"/inbox",
			},
			expectedModules: []string{"M13", "M19", "M13", "M19", "M12"},
		},
		{
			mode:        adminv1.OperatorModeId_OPERATOR_MODE_ID_AFFILIATE_OPERATOR,
			name:        "Affiliate Operator Mode",
			expectedLen: 5,
			expectedCardIds: []string{
				"card-affiliate-links",
				"card-affiliate-opportunities",
				"card-affiliate-offers",
				"card-affiliate-coupons",
				"card-affiliate-attribution",
			},
			expectedRoutes: []string{
				"/affiliates",
				"/kham-pha",
				"/offers",
				"/coupons",
				"/attribution",
			},
			expectedModules: []string{"M16", "M04", "M14", "M14", "M16"},
		},
		{
			mode:        adminv1.OperatorModeId_OPERATOR_MODE_ID_LIVE_OPERATOR,
			name:        "Live Operator Mode",
			expectedLen: 5,
			expectedCardIds: []string{
				"card-live-readiness",
				"card-live-cue",
				"card-live-offers",
				"card-live-comments",
				"card-live-highlights",
			},
			expectedRoutes: []string{
				"/live",
				"/live",
				"/offers",
				"/inbox",
				"/studio",
			},
			expectedModules: []string{"M17", "M17", "M14", "M12", "M09"},
		},
		{
			mode:        adminv1.OperatorModeId_OPERATOR_MODE_ID_AGENCY_MCN,
			name:        "Agency / MCN Mode",
			expectedLen: 5,
			expectedCardIds: []string{
				"card-agency-approvals",
				"card-agency-diagnostics",
				"card-agency-creators",
				"card-agency-deliverables",
				"card-agency-reports",
			},
			expectedRoutes: []string{
				"/workflows",
				"/settings/diagnostics",
				"/workspaces",
				"/campaigns",
				"/creator-pro",
			},
			expectedModules: []string{"M20", "M22", "M22", "M14", "S16"},
		},
		{
			mode:        adminv1.OperatorModeId_OPERATOR_MODE_ID_BRAND_COLLABORATION,
			name:        "Brand Collaboration Mode",
			expectedLen: 5,
			expectedCardIds: []string{
				"card-brand-inquiries",
				"card-brand-deliverables",
				"card-brand-proof",
				"card-brand-invoices",
				"card-brand-evidence",
			},
			expectedRoutes: []string{
				"/creator-pro",
				"/xuat-ban",
				"/seeding",
				"/finance",
				"/attribution",
			},
			expectedModules: []string{"S16", "M11", "M18", "M19", "M16"},
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			resp, err := svc.GetDecisionCards(ctx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
				WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
				OperatorMode: tc.mode,
			}))
			if err != nil {
				t.Fatalf("GetDecisionCards failed for %s: %v", tc.name, err)
			}
			cards := resp.Msg.Cards
			if len(cards) != tc.expectedLen {
				t.Fatalf("%s: expected %d cards, got %d", tc.name, tc.expectedLen, len(cards))
			}

			for i, card := range cards {
				// Verify card identity and ordering
				expectedID := tc.expectedCardIds[i]
				if card.CardId != expectedID {
					t.Errorf("%s rank %d: expected card %s, got %s", tc.name, i+1, expectedID, card.CardId)
				}

				// Verify priority rank is strictly 1-indexed and ascending
				if card.PriorityRank != int32(i+1) {
					t.Errorf("%s rank %d: expected PriorityRank=%d, got %d", tc.name, i+1, i+1, card.PriorityRank)
				}

				// Verify Action is Available in P8
				if !card.IsActionAvailable {
					t.Errorf("%s card %s must be IsActionAvailable=true in P8", tc.name, card.CardId)
				}
				if card.UnavailableReason != "" {
					t.Errorf("%s card %s must have empty UnavailableReason in P8, got %q", tc.name, card.CardId, card.UnavailableReason)
				}

				// Verify CTA and Route
				if card.PrimaryCtaLabel == "" {
					t.Errorf("%s card %s missing PrimaryCtaLabel (RULE-M01-001 violation)", tc.name, card.CardId)
				}
				expectedRoute := tc.expectedRoutes[i]
				if card.PrimaryCtaRoute != expectedRoute {
					t.Errorf("%s card %s: expected route %s, got %s", tc.name, card.CardId, expectedRoute, card.PrimaryCtaRoute)
				}

				// Verify WhyThisMatters explanation
				if card.WhyThisMatters == "" {
					t.Errorf("%s card %s missing WhyThisMatters (RULE-M01-003 violation)", tc.name, card.CardId)
				}

				// Verify module reference
				expectedMod := tc.expectedModules[i]
				if card.ModuleRef != expectedMod {
					t.Errorf("%s card %s: expected ModuleRef %s, got %s", tc.name, card.CardId, expectedMod, card.ModuleRef)
				}
			}
		})
	}
}

func TestP801AcceptanceTarget2_FirstValueAndFullLoopCompletionDistinct(t *testing.T) {
	svc := home.NewService(nil)
	userCtx := home.WithCallerContext(context.Background(), home.CallerContext{
		UserID:        "user_p8_onboarding",
		WorkspaceID:   testWorkspaceID,
		WorkspaceRole: "owner",
	})

	// 1. Initial State: 0/5 completed
	homeResp, err := svc.GetMobileHome(userCtx, connect.NewRequest(&adminv1.GetMobileHomeRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		ActiveMode:  adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR,
	}))
	if err != nil {
		t.Fatalf("GetMobileHome failed: %v", err)
	}
	chk := homeResp.Msg.Onboarding
	if chk.CompletedCount != 0 {
		t.Fatalf("expected initial CompletedCount=0, got %d", chk.CompletedCount)
	}
	if chk.IsFirstValueComplete {
		t.Fatalf("expected initial IsFirstValueComplete=false")
	}
	if chk.IsClosedLoopComplete {
		t.Fatalf("expected initial IsClosedLoopComplete=false")
	}
	// Verify all 5 steps are available in P8
	for _, step := range chk.Steps {
		if !step.IsAvailable {
			t.Fatalf("step %d (%s) must be IsAvailable=true in P8", step.StepNumber, step.StepKey)
		}
	}

	// 2. Complete Step 1: Connect Account or Import Data
	// Invariant: Completing step 1 achieves FIRST VALUE, but does NOT complete the FULL LOOP!
	step1Resp, err := svc.CompleteOnboardingStep(userCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  1,
	}))
	if err != nil {
		t.Fatalf("CompleteOnboardingStep 1 failed: %v", err)
	}
	chk1 := step1Resp.Msg.UpdatedChecklist
	if chk1.CompletedCount != 1 {
		t.Fatalf("expected CompletedCount=1 after step 1, got %d", chk1.CompletedCount)
	}
	if !chk1.IsFirstValueComplete {
		t.Fatalf("ACCEPTANCE TARGET 2 VIOLATION: step 1 completed must set IsFirstValueComplete=true")
	}
	if chk1.IsClosedLoopComplete {
		t.Fatalf("ACCEPTANCE TARGET 2 VIOLATION: step 1 completion must NOT set IsClosedLoopComplete=true! Full loop requires all 5 steps.")
	}

	// 3. Complete Step 2: Select Offer
	step2Resp, err := svc.CompleteOnboardingStep(userCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  2,
	}))
	if err != nil {
		t.Fatalf("CompleteOnboardingStep 2 failed: %v", err)
	}
	chk2 := step2Resp.Msg.UpdatedChecklist
	if chk2.CompletedCount != 2 || !chk2.IsFirstValueComplete || chk2.IsClosedLoopComplete {
		t.Fatalf("step 2 progress mismatch: count=%d first=%v closed=%v", chk2.CompletedCount, chk2.IsFirstValueComplete, chk2.IsClosedLoopComplete)
	}

	// 4. Complete Step 3: Create AI Content (M06/M07) — P8 unlocked!
	step3Resp, err := svc.CompleteOnboardingStep(userCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  3,
	}))
	if err != nil {
		t.Fatalf("CompleteOnboardingStep 3 should succeed in P8: %v", err)
	}
	chk3 := step3Resp.Msg.UpdatedChecklist
	if chk3.CompletedCount != 3 || chk3.IsClosedLoopComplete {
		t.Fatalf("step 3 progress mismatch: count=%d closed=%v", chk3.CompletedCount, chk3.IsClosedLoopComplete)
	}

	// 5. Complete Step 4: Publish (M11) — P8 unlocked!
	step4Resp, err := svc.CompleteOnboardingStep(userCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  4,
	}))
	if err != nil {
		t.Fatalf("CompleteOnboardingStep 4 should succeed in P8: %v", err)
	}
	chk4 := step4Resp.Msg.UpdatedChecklist
	if chk4.CompletedCount != 4 || chk4.IsClosedLoopComplete {
		t.Fatalf("step 4 progress mismatch: count=%d closed=%v", chk4.CompletedCount, chk4.IsClosedLoopComplete)
	}

	// 6. Complete Step 5: Track Outcome (M19) — FULL LOOP COMPLETION!
	step5Resp, err := svc.CompleteOnboardingStep(userCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  5,
	}))
	if err != nil {
		t.Fatalf("CompleteOnboardingStep 5 failed: %v", err)
	}
	chk5 := step5Resp.Msg.UpdatedChecklist
	if chk5.CompletedCount != 5 {
		t.Fatalf("expected 5/5 completed steps, got %d", chk5.CompletedCount)
	}
	if !chk5.IsFirstValueComplete {
		t.Fatalf("expected IsFirstValueComplete=true")
	}
	if !chk5.IsClosedLoopComplete {
		t.Fatalf("ACCEPTANCE TARGET 2 VIOLATION: all 5 steps complete must set IsClosedLoopComplete=true!")
	}

	// 7. Negative & denial cases:
	// Out-of-bounds step number <1 or >5
	if _, err := svc.CompleteOnboardingStep(userCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  0,
	})); err == nil {
		t.Fatalf("expected step 0 to fail with InvalidArgument")
	}
	if _, err := svc.CompleteOnboardingStep(userCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID},
		StepNumber:  6,
	})); err == nil {
		t.Fatalf("expected step 6 to fail with InvalidArgument")
	}
	// Missing workspace ID
	if _, err := svc.CompleteOnboardingStep(userCtx, connect.NewRequest(&adminv1.CompleteOnboardingStepRequest{
		StepNumber: 1,
	})); err == nil {
		t.Fatalf("expected missing workspace_id to fail")
	}
}

func TestP801AcceptanceTarget3_SharedUIStatesAndRouteMappings(t *testing.T) {
	svc := home.NewService(nil)
	ctx := context.Background()

	// 1. Verify 5 canonical UI states are defined in adminv1.UIStateType
	states := []adminv1.UIStateType{
		adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
		adminv1.UIStateType_UI_STATE_TYPE_LOADING,
		adminv1.UIStateType_UI_STATE_TYPE_EMPTY,
		adminv1.UIStateType_UI_STATE_TYPE_ERROR,
		adminv1.UIStateType_UI_STATE_TYPE_REPAIR,
	}
	for _, s := range states {
		if s == adminv1.UIStateType_UI_STATE_TYPE_UNSPECIFIED {
			t.Errorf("unspecified UI state encountered")
		}
	}

	// 2. Verify all mapped routes exist across decision cards in 6 modes
	validRoutePrefixes := []string{
		"/kham-pha",
		"/ideas",
		"/scripts",
		"/studio",
		"/xuat-ban",
		"/inbox",
		"/kinh-doanh",
		"/finance",
		"/affiliates",
		"/offers",
		"/coupons",
		"/attribution",
		"/live",
		"/workflows",
		"/creator-pro",
		"/workspaces",
		"/campaigns",
		"/seeding",
		"/settings/diagnostics",
	}

	for _, mode := range []adminv1.OperatorModeId{
		adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR,
		adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
		adminv1.OperatorModeId_OPERATOR_MODE_ID_AFFILIATE_OPERATOR,
		adminv1.OperatorModeId_OPERATOR_MODE_ID_LIVE_OPERATOR,
		adminv1.OperatorModeId_OPERATOR_MODE_ID_AGENCY_MCN,
		adminv1.OperatorModeId_OPERATOR_MODE_ID_BRAND_COLLABORATION,
	} {
		resp, err := svc.GetDecisionCards(ctx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
			WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
			OperatorMode: mode,
		}))
		if err != nil {
			t.Fatalf("GetDecisionCards for mode %v failed: %v", mode, err)
		}
		for _, card := range resp.Msg.Cards {
			matched := false
			for _, prefix := range validRoutePrefixes {
				if card.PrimaryCtaRoute == prefix {
					matched = true
					break
				}
			}
			if !matched {
				t.Errorf("card %s has unmapped primary_cta_route: %s", card.CardId, card.PrimaryCtaRoute)
			}
		}
	}

	// 3. Test Data Repair gap rendering with UIStateType = REPAIR
	importReq := home.AuthorizedImportRequest{
		WorkspaceID:            testWorkspaceID,
		ConnectedAccountsCount: 0,
		ProductsCount:          1,
		OrdersCount:            1,
		CostsCount:             1,
		SettlementsCount:       0,
		GrossRevenueCents:      150000,
		KnownCostsCents:        20000,
		Currency:               "VND",
		RepairGaps: []home.DataRepairGap{
			{
				GapID:       "gap-cogs-unmatched",
				GapKind:     "missing_cogs",
				Title:       "Thiếu giá vốn hàng bán (COGS)",
				Reason:      "SKU-REPAIR-1 chưa có hóa đơn chứng từ giá vốn đầu vào.",
				RepairCTA:   "Cập nhật hóa đơn chi phí",
				RepairRoute: "/kinh-doanh",
				AmountCents: 50000,
				Currency:    "VND",
				Resolved:    false,
			},
		},
		IsDemoFixture: false,
		ImportedAt:    time.Now().UTC(),
	}
	_, err := svc.IngestAuthorizedImport(ctx, importReq)
	if err != nil {
		t.Fatalf("IngestAuthorizedImport failed: %v", err)
	}

	// Fetch cards as Manager: should include the repair card with state REPAIR
	managerCardsResp, err := svc.GetDecisionCards(ctx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
		WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
		OperatorMode: adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetDecisionCards failed: %v", err)
	}

	foundRepairCard := false
	for _, c := range managerCardsResp.Msg.Cards {
		if c.CardFamily == "data_repair" {
			foundRepairCard = true
			if c.StateType != adminv1.UIStateType_UI_STATE_TYPE_REPAIR {
				t.Errorf("expected repair card to have StateType=REPAIR, got %v", c.StateType)
			}
			if c.PrimaryCtaRoute != "/kinh-doanh" {
				t.Errorf("expected repair route /kinh-doanh, got %s", c.PrimaryCtaRoute)
			}
		}
	}
	if !foundRepairCard {
		t.Fatalf("expected data repair card to be surfaced in decision cards")
	}

	// Fetch cards as Viewer: financial and repair cards MUST be redacted (RBAC security check)
	viewerCtx := home.WithCallerContext(ctx, home.CallerContext{
		UserID:        "user_viewer_safe",
		WorkspaceID:   testWorkspaceID,
		WorkspaceRole: "viewer",
	})
	viewerCardsResp, err := svc.GetDecisionCards(viewerCtx, connect.NewRequest(&adminv1.GetDecisionCardsRequest{
		WorkspaceId:  &commonv1.UUID{Value: testWorkspaceID},
		OperatorMode: adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetDecisionCards as viewer failed: %v", err)
	}
	for _, c := range viewerCardsResp.Msg.Cards {
		if c.CardFamily == "data_repair" || c.ModuleRef == "M19" {
			t.Fatalf("SECURITY VIOLATION: viewer was exposed to financial or repair card %s!", c.CardId)
		}
	}
}

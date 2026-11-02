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

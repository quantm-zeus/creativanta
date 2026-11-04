package creatorpro

import (
	"context"
	"sync"
	"testing"
	"time"
)

type mockEventSink struct {
	mu     sync.Mutex
	events []OutboxEvent
}

func (m *mockEventSink) Emit(_ context.Context, ev OutboxEvent) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = append(m.events, ev)
	return nil
}

func (m *mockEventSink) CountType(evType string) int {
	m.mu.Lock()
	defer m.mu.Unlock()
	c := 0
	for _, e := range m.events {
		if e.EventType == evType {
			c++
		}
	}
	return c
}

func (m *mockEventSink) LastEvent() *OutboxEvent {
	m.mu.Lock()
	defer m.mu.Unlock()
	if len(m.events) == 0 {
		return nil
	}
	ev := m.events[len(m.events)-1]
	return &ev
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Canonical Deal Lifecycle
// ----------------------------------------------------------------------------

func TestAcceptanceTarget1_CanonicalDealLifecycle(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	// 1. Create deal in negotiating status
	deal, err := svc.CreateBrandDeal(ctx, &BrandDeal{
		WorkspaceID:         wsID,
		BrandName:           "Acme Co",
		ContactEmail:        "sponsor@acme.com",
		DealType:            BrandDealTypeSponsoredPost,
		Value:               15000000,
		Currency:            "VND",
		Deliverables:        "1x YouTube Integration, 2x TikTok Videos",
		ContractEvidenceIDs: []string{"contract-doc-uuid-001"},
	})
	if err != nil {
		t.Fatalf("failed to create brand deal: %v", err)
	}
	if deal.Status != BrandDealStatusNegotiating {
		t.Fatalf("expected initial status negotiating, got %s", deal.Status)
	}

	// 2. Reject invalid step skipping (negotiating -> delivered directly is invalid)
	_, err = svc.UpdateBrandDealStatus(ctx, wsID, deal.DealID, BrandDealStatusDelivered, "", false)
	if err == nil {
		t.Fatalf("expected error when skipping from negotiating to delivered, got nil")
	}

	// 3. Negotiating -> Agreed
	deal, err = svc.UpdateBrandDealStatus(ctx, wsID, deal.DealID, BrandDealStatusAgreed, "", false)
	if err != nil {
		t.Fatalf("transition to agreed failed: %v", err)
	}
	if deal.Status != BrandDealStatusAgreed {
		t.Fatalf("expected agreed, got %s", deal.Status)
	}

	// 4. Agreed -> InProgress
	deal, err = svc.UpdateBrandDealStatus(ctx, wsID, deal.DealID, BrandDealStatusInProgress, "", false)
	if err != nil {
		t.Fatalf("transition to in_progress failed: %v", err)
	}
	if deal.Status != BrandDealStatusInProgress {
		t.Fatalf("expected in_progress, got %s", deal.Status)
	}

	// 5. InProgress -> Delivered
	deal, err = svc.UpdateBrandDealStatus(ctx, wsID, deal.DealID, BrandDealStatusDelivered, "", false)
	if err != nil {
		t.Fatalf("transition to delivered failed: %v", err)
	}
	if deal.Status != BrandDealStatusDelivered {
		t.Fatalf("expected delivered, got %s", deal.Status)
	}

	// 6. Delivered -> Paid
	deal, err = svc.UpdateBrandDealStatus(ctx, wsID, deal.DealID, BrandDealStatusPaid, "", false)
	if err != nil {
		t.Fatalf("transition to paid failed: %v", err)
	}
	if deal.Status != BrandDealStatusPaid {
		t.Fatalf("expected paid, got %s", deal.Status)
	}

	// 7. Paid -> Completed (canonical terminal state)
	deal, err = svc.UpdateBrandDealStatus(ctx, wsID, deal.DealID, BrandDealStatusCompleted, "", false)
	if err != nil {
		t.Fatalf("transition to completed failed: %v", err)
	}
	if deal.Status != BrandDealStatusCompleted {
		t.Fatalf("expected completed, got %s", deal.Status)
	}

	// 8. Terminal state completed cannot transition further
	_, err = svc.UpdateBrandDealStatus(ctx, wsID, deal.DealID, BrandDealStatusNegotiating, "", false)
	if err == nil {
		t.Fatalf("expected error transitioning from completed to negotiating, got nil")
	}

	// Verify events emitted
	if sink.CountType("creator_pro.brand_deal.status_updated") < 5 {
		t.Fatalf("expected at least 5 deal transition events, got %d", sink.CountType("creator_pro.brand_deal.status_updated"))
	}
}

func TestAcceptanceTarget1_CancellationAndFinancialReversal(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	// Case A: Cancellation requires reason
	deal1, err := svc.CreateBrandDeal(ctx, &BrandDeal{
		WorkspaceID:  wsID,
		BrandName:    "Beta Brand",
		Value:        5000000,
		Currency:     "VND",
		Deliverables: "Product review",
	})
	if err != nil {
		t.Fatalf("failed to create deal: %v", err)
	}

	_, err = svc.UpdateBrandDealStatus(ctx, wsID, deal1.DealID, BrandDealStatusCancelled, "", false)
	if err == nil {
		t.Fatalf("expected error when cancelling without reason, got nil")
	}

	deal1, err = svc.UpdateBrandDealStatus(ctx, wsID, deal1.DealID, BrandDealStatusCancelled, "Client cancelled campaign budget", false)
	if err != nil {
		t.Fatalf("cancellation with reason should succeed: %v", err)
	}
	if deal1.Status != BrandDealStatusCancelled || deal1.CancellationReason != "Client cancelled campaign budget" {
		t.Fatalf("expected cancelled status with reason preserved")
	}

	// Case B: Paid deal cancellation requires financial reversal audit
	deal2, err := svc.CreateBrandDeal(ctx, &BrandDeal{
		WorkspaceID:  wsID,
		BrandName:    "Gamma Brand",
		Value:        20000000,
		Currency:     "VND",
		Deliverables: "Sponsorship slot",
	})
	if err != nil {
		t.Fatalf("failed to create deal: %v", err)
	}

	// Transition through to paid
	_, _ = svc.UpdateBrandDealStatus(ctx, wsID, deal2.DealID, BrandDealStatusAgreed, "", false)
	_, _ = svc.UpdateBrandDealStatus(ctx, wsID, deal2.DealID, BrandDealStatusInProgress, "", false)
	_, _ = svc.UpdateBrandDealStatus(ctx, wsID, deal2.DealID, BrandDealStatusDelivered, "", false)
	deal2, err = svc.UpdateBrandDealStatus(ctx, wsID, deal2.DealID, BrandDealStatusPaid, "", false)
	if err != nil {
		t.Fatalf("failed to transition to paid: %v", err)
	}

	// Try to cancel paid deal without financial reversal confirmation
	_, err = svc.UpdateBrandDealStatus(ctx, wsID, deal2.DealID, BrandDealStatusCancelled, "Brand requested refund due to delivery defect", false)
	if err == nil {
		t.Fatalf("expected error requiring financial reversal for paid deal, got nil")
	}

	// Try to cancel paid deal WITH financial reversal confirmation
	deal2, err = svc.UpdateBrandDealStatus(ctx, wsID, deal2.DealID, BrandDealStatusCancelled, "Brand requested refund due to delivery defect", true)
	if err != nil {
		t.Fatalf("paid deal cancellation with financial reversal should succeed: %v", err)
	}
	if !deal2.FinancialReversalLogged {
		t.Fatalf("expected financial reversal logged to be true")
	}
	if sink.CountType("creator_pro.brand_deal.financial_reversal_logged") != 1 {
		t.Fatalf("expected financial_reversal_logged event to be emitted")
	}
}

func TestSponsorInquiryConversionToBrandDeal(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	inq, err := svc.CreateSponsorInquiry(ctx, &SponsorInquiry{
		WorkspaceID:     wsID,
		BrandName:       "Delta Tech",
		ContactEmail:    "partners@deltatech.io",
		Message:         "Looking for sponsored review of our AI tool",
		EstimatedBudget: 35000000,
	})
	if err != nil {
		t.Fatalf("failed to create sponsor inquiry: %v", err)
	}
	if inq.Status != "pending" || inq.ThreadID == "" {
		t.Fatalf("expected pending status and generated thread ID")
	}

	// Convert inquiry into brand deal
	deal, err := svc.ConvertInquiryToDeal(ctx, wsID, inq.InquiryID, "1x Dedicated Video, 1x Newsletter")
	if err != nil {
		t.Fatalf("failed to convert inquiry to deal: %v", err)
	}
	if deal.InquiryThreadID != inq.ThreadID {
		t.Fatalf("expected inquiry thread id %s, got %s", inq.ThreadID, deal.InquiryThreadID)
	}
	if deal.Value != inq.EstimatedBudget {
		t.Fatalf("expected deal value %f, got %f", inq.EstimatedBudget, deal.Value)
	}
	if deal.Status != BrandDealStatusNegotiating {
		t.Fatalf("expected status negotiating")
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Phishing Cannot Be Acknowledged Away & Throttle
// ----------------------------------------------------------------------------

func TestAcceptanceTarget2_PhishingCannotBeAcknowledgedAway(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	// Create bio page
	page, err := svc.CreatePage(ctx, &LinkInBioPage{
		WorkspaceID: wsID,
		Slug:        "my-creator-links",
		Title:       "My Links",
	})
	if err != nil {
		t.Fatalf("failed to create page: %v", err)
	}

	// Add a safe link
	safeItem, err := svc.AddLinkItem(ctx, &LinkItem{
		WorkspaceID: wsID,
		PageID:      page.PageID,
		Label:       "Official Store",
		URL:         "https://mybrand.com/shop",
		LinkType:    LinkTypeProduct,
	})
	if err != nil {
		t.Fatalf("failed to add safe link: %v", err)
	}
	if safeItem.ScanStatus != LinkSecurityScanStatusSafe || safeItem.PhishingDetected {
		t.Fatalf("expected safe link")
	}

	// Add a phishing link (Google Safe Browsing flags phishing)
	phishingItem, err := svc.AddLinkItem(ctx, &LinkItem{
		WorkspaceID: wsID,
		PageID:      page.PageID,
		Label:       "Win Free iPhone Login Now",
		URL:         "https://steal-login.fake-bank-phishing.com/account",
		LinkType:    LinkTypeURL,
	})
	if err != nil {
		t.Fatalf("adding link should record scan even if flagged: %v", err)
	}
	if phishingItem.ScanStatus != LinkSecurityScanStatusPhishing || !phishingItem.PhishingDetected {
		t.Fatalf("expected scan status phishing and PhishingDetected=true")
	}
	if phishingItem.IsActive {
		t.Fatalf("phishing link must default to inactive")
	}

	// CRITICAL TEST: ToggleLink cannot activate a phishing link
	_, err = svc.ToggleLink(ctx, wsID, phishingItem.LinkItemID, true)
	if err == nil {
		t.Fatalf("expected ErrPhishingBlocked when attempting to toggle phishing link to active, got nil")
	}

	// CRITICAL TEST: Publishing a page containing phishing link is strictly blocked
	// Even if user accepts AUP acknowledgment, phishing CANNOT be published
	_, err = svc.PublishPage(ctx, wsID, page.PageID, true) // aupAcknowledged = true
	if err == nil {
		t.Fatalf("expected ErrPhishingBlocked when publishing page with phishing link despite AUP acknowledged, got nil")
	}

	// Remove phishing link, now publishing should succeed
	err = svc.DeleteLinkItem(ctx, wsID, phishingItem.LinkItemID)
	if err != nil {
		t.Fatalf("failed to delete phishing item: %v", err)
	}

	publishedPage, err := svc.PublishPage(ctx, wsID, page.PageID, false)
	if err != nil {
		t.Fatalf("publishing clean page should succeed: %v", err)
	}
	if publishedPage.Status != LinkInBioPageStatusActive {
		t.Fatalf("expected page to be active")
	}
}

func TestAcceptanceTarget2_DailyLinkThrottle(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	page, err := svc.CreatePage(ctx, &LinkInBioPage{
		WorkspaceID: wsID,
		Slug:        "throttle-test",
		Title:       "Throttle Test",
	})
	if err != nil {
		t.Fatalf("failed to create page: %v", err)
	}

	// Add 20 links (allowed limit)
	for i := 1; i <= 20; i++ {
		_, err := svc.AddLinkItem(ctx, &LinkItem{
			WorkspaceID: wsID,
			PageID:      page.PageID,
			Label:       "Product Link",
			URL:         "https://mybrand.com/item",
			LinkType:    LinkTypeProduct,
		})
		if err != nil {
			t.Fatalf("link creation %d should succeed: %v", i, err)
		}
	}

	// 21st link must be throttled with ErrDailyLinkLimitExceeded
	_, err = svc.AddLinkItem(ctx, &LinkItem{
		WorkspaceID: wsID,
		PageID:      page.PageID,
		Label:       "Product Link 21",
		URL:         "https://mybrand.com/item21",
		LinkType:    LinkTypeProduct,
	})
	if err == nil {
		t.Fatalf("expected ErrDailyLinkLimitExceeded on 21st link, got nil")
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Zero-View RPM Undefined Representation
// ----------------------------------------------------------------------------

func TestAcceptanceTarget3_ZeroViewRPMUndefined(t *testing.T) {
	// Case A: 0 views strictly returns undefined
	rpm, isUndefined := ComputeRPM(0, 500000)
	if !isUndefined {
		t.Fatalf("expected RPM to be undefined when views == 0")
	}
	if rpm != 0.0 {
		t.Fatalf("expected numeric zero when undefined, got %f", rpm)
	}

	// Case B: Negative views strictly returns undefined
	rpm, isUndefined = ComputeRPM(-10, 500000)
	if !isUndefined {
		t.Fatalf("expected RPM to be undefined when views < 0")
	}

	// Case C: Non-zero views calculates accurately
	// 50,000 views, 2,500,000 VND revenue => RPM = 2,500,000 / 50 = 50,000 VND
	rpm, isUndefined = ComputeRPM(50000, 2500000)
	if isUndefined {
		t.Fatalf("expected RPM to be defined when views > 0")
	}
	if rpm != 50000.0 {
		t.Fatalf("expected RPM 50000.0, got %f", rpm)
	}
}

func TestAcceptanceTarget3_RPMTrendAndDropAlert(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	// Record historical content metrics
	// Period 1 (last week): 10,000 views, 1,000,000 VND => RPM = 100,000 VND
	err := svc.RecordContentMetric(ctx, wsID, &ContentROIMetric{
		ContentID:         "video-p1",
		Title:             "Old Video",
		Platform:          "tiktok",
		Views:             10000,
		RevenueAttributed: 1000000,
		PublishedAt:       now.AddDate(0, 0, -8),
	})
	if err != nil {
		t.Fatalf("failed to record metric: %v", err)
	}

	// Period 2 (this week): 10,000 views, 700,000 VND => RPM = 70,000 VND (drop 30% > 20% threshold)
	err = svc.RecordContentMetric(ctx, wsID, &ContentROIMetric{
		ContentID:         "video-p2",
		Title:             "New Video",
		Platform:          "tiktok",
		Views:             10000,
		RevenueAttributed: 700000,
		PublishedAt:       now.AddDate(0, 0, -1),
	})
	if err != nil {
		t.Fatalf("failed to record metric: %v", err)
	}

	trend, _, dropAlert, err := svc.GetRPMTrends(ctx, wsID, "tiktok", 4)
	if err != nil {
		t.Fatalf("failed to get RPM trend: %v", err)
	}
	if len(trend) < 2 {
		t.Fatalf("expected at least 2 trend points, got %d", len(trend))
	}
	if !dropAlert {
		t.Fatalf("expected dropAlert to be true for 30%% RPM drop, got false")
	}

	// Verify derivative roll-up: source content aggregates revenue from derivative shorts
	err = svc.RecordContentMetric(ctx, wsID, &ContentROIMetric{
		ContentID:         "long-form-001",
		Title:             "Full Length Tutorial",
		Platform:          "youtube",
		Views:             50000,
		RevenueAttributed: 5000000,
		CostToProduce:     1000000,
		IsDerivative:      false,
		PublishedAt:       now.AddDate(0, 0, -5),
	})
	if err != nil {
		t.Fatalf("failed to record source content: %v", err)
	}

	// Add derivative short
	err = svc.RecordContentMetric(ctx, wsID, &ContentROIMetric{
		ContentID:         "short-form-001",
		Title:             "Highlight Clip 1",
		Platform:          "tiktok",
		Views:             20000,
		RevenueAttributed: 1200000,
		IsDerivative:      true,
		SourceContentID:   "long-form-001",
		PublishedAt:       now.AddDate(0, 0, -3),
	})
	if err != nil {
		t.Fatalf("failed to record derivative content: %v", err)
	}

	// Fetch rolled up source content
	updatedSource, err := svc.RollupDerivativePerformance(ctx, wsID, "long-form-001")
	if err != nil {
		t.Fatalf("failed to rollup derivative performance: %v", err)
	}
	if updatedSource.DerivativeCount != 1 {
		t.Fatalf("expected derivative count 1, got %d", updatedSource.DerivativeCount)
	}
	if updatedSource.DerivativeTotalRevenue != 1200000 {
		t.Fatalf("expected derivative total revenue 1200000, got %f", updatedSource.DerivativeTotalRevenue)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 4: All Six Modes Can Reach Entitled Tools
// ----------------------------------------------------------------------------

func TestAcceptanceTarget4_AllSixModesCanReachEntitledTools(t *testing.T) {
	allModes := []OperatorMode{
		ModeCreator,
		ModeSeller,
		ModeAgency,
		ModeAffiliate,
		ModeBrandCollab,
		ModeLiveOperator,
	}

	allTools := []CreatorProTool{
		ToolLinkInBio,
		ToolMediaKit,
		ToolRateCard,
		ToolBrandDeals,
		ToolRevenueTracker,
		ToolTaxExport,
	}

	// Invariant: All six modes can reach their entitled tools per S16 §8.2
	for _, mode := range allModes {
		route := GetRouteForMode(mode)
		if route == "" {
			t.Fatalf("mode %s must have a defined highlighted route", mode)
		}

		entitledCount := 0
		for _, tool := range allTools {
			if CheckModeEntitlement(mode, tool) {
				entitledCount++
			}
		}
		if entitledCount == 0 {
			t.Fatalf("mode %s has no entitled tools", mode)
		}
	}

	// Unknown mode must return false
	if CheckModeEntitlement("unknown_mode", ToolLinkInBio) {
		t.Fatalf("expected false for unknown mode")
	}
}

// ----------------------------------------------------------------------------
// Custom Domain Verification & Tax Reports
// ----------------------------------------------------------------------------

func TestCustomDomainVerification(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	page, err := svc.CreatePage(ctx, &LinkInBioPage{
		WorkspaceID: wsID,
		Slug:        "creator-cname",
		Title:       "Creator CNAME",
	})
	if err != nil {
		t.Fatalf("failed to create page: %v", err)
	}

	// Valid domain with prefix "links."
	verified, _, sslActive, err := svc.VerifyCustomDomain(ctx, wsID, page.PageID, "links.topcreator.com")
	if err != nil || !verified || !sslActive {
		t.Fatalf("expected valid CNAME verification, got err=%v, verified=%v, ssl=%v", err, verified, sslActive)
	}

	// Invalid domain without required CNAME target
	verified, _, _, err = svc.VerifyCustomDomain(ctx, wsID, page.PageID, "random.example.com")
	if err == nil || verified {
		t.Fatalf("expected error for unconfigured custom domain, got nil")
	}
}

func TestTaxReportGeneration(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	report, fileData, fileName, err := svc.GenerateTaxReport(ctx, wsID, TaxReportPeriodQuarterly, 2026, 3, TaxReportFormatCSV)
	if err != nil {
		t.Fatalf("failed to generate tax report: %v", err)
	}
	if report.Period != TaxReportPeriodQuarterly || report.TaxYear != 2026 || report.PeriodNumber != 3 {
		t.Fatalf("tax report fields mismatch")
	}
	if report.NetIncomeBeforeTax <= 0 || report.DownloadURL == "" || len(fileData) == 0 || fileName == "" {
		t.Fatalf("expected positive net income, non-empty data and valid download URL")
	}
	if sink.CountType("creator_pro.tax_report.generated") != 1 {
		t.Fatalf("expected tax report event to be emitted")
	}
}

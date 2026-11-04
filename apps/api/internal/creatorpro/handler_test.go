package creatorpro

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
)

func TestConnectRPCHandlers(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockEventSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	bioHandler := NewLinkInBioHandler(svc)
	mediaKitHandler := NewMediaKitHandler(svc)
	rateCardHandler := NewRateCardHandler(svc)
	dealHandler := NewBrandDealHandler(svc)
	inquiryHandler := NewSponsorInquiryHandler(svc)
	roiHandler := NewRevenueTrackerHandler(svc)
	taxHandler := NewTaxReportHandler(svc)

	// 1. LinkInBioService: Create Page & Scan Link & Verify Custom Domain
	createPageResp, err := bioHandler.CreatePage(ctx, connect.NewRequest(&commercev1.CreatePageRequest{
		WorkspaceId: wsID,
		Slug:        "viet-creator-links",
		Title:       "Viet Creator Official Links",
		Bio:         "Tech reviewer and creative coder",
		Theme:       "dark-glass",
	}))
	if err != nil {
		t.Fatalf("CreatePage failed: %v", err)
	}
	pageID := createPageResp.Msg.Page.PageId
	if pageID == "" {
		t.Fatalf("expected non-empty page ID")
	}

	// Scan Link
	scanResp, err := bioHandler.ScanLink(ctx, connect.NewRequest(&commercev1.ScanLinkRequest{
		WorkspaceId: wsID,
		Url:         "https://mybrand.com/clean-link",
	}))
	if err != nil {
		t.Fatalf("ScanLink failed: %v", err)
	}
	if !scanResp.Msg.CanBePublished {
		t.Fatalf("expected clean link to be publishable")
	}

	// Verify Custom Domain
	domainResp, err := bioHandler.VerifyCustomDomain(ctx, connect.NewRequest(&commercev1.VerifyCustomDomainRequest{
		WorkspaceId:  wsID,
		PageId:       pageID,
		CustomDomain: "links.creator.vn",
	}))
	if err != nil {
		t.Fatalf("VerifyCustomDomain failed: %v", err)
	}
	if !domainResp.Msg.Verified {
		t.Fatalf("expected CNAME verified")
	}

	// 2. RateCardService: AISuggest & Create
	aiPriceResp, err := rateCardHandler.AISuggest(ctx, connect.NewRequest(&commercev1.RateCardServiceAISuggestRequest{
		WorkspaceId: wsID,
		Platform:    "tiktok",
		ServiceType: "sponsored_video",
	}))
	if err != nil {
		t.Fatalf("AISuggest failed: %v", err)
	}
	if aiPriceResp.Msg.SuggestedPrice <= 0 {
		t.Fatalf("expected positive suggested price, got %f", aiPriceResp.Msg.SuggestedPrice)
	}

	createCardResp, err := rateCardHandler.Create(ctx, connect.NewRequest(&commercev1.RateCardServiceCreateRequest{
		WorkspaceId: wsID,
		Currency:    "VND",
		CustomNote:  "Standard 2026 Creator Rates",
		Items: []*commercev1.RateCardItem{
			{
				WorkspaceId:      wsID,
				ServiceType:      "sponsored_video",
				PriceMin:         aiPriceResp.Msg.PriceRangeLow,
				PriceMax:         aiPriceResp.Msg.PriceRangeHigh,
				AiSuggestedPrice: aiPriceResp.Msg.SuggestedPrice,
				Description:      "60s dedicated TikTok video",
			},
		},
	}))
	if err != nil {
		t.Fatalf("RateCard Create failed: %v", err)
	}
	if len(createCardResp.Msg.RateCard.Items) != 1 {
		t.Fatalf("expected 1 rate card item")
	}

	// 3. BrandDealService: Create & UpdateStatus (Target 1 Lifecycle)
	createDealResp, err := dealHandler.Create(ctx, connect.NewRequest(&commercev1.BrandDealServiceCreateRequest{
		WorkspaceId:  wsID,
		BrandName:    "Tech Corp",
		ContactEmail: "sponsor@techcorp.vn",
		DealType:     commercev1.BrandDealType_BRAND_DEAL_TYPE_SPONSORED_POST,
		Value:        12000000,
		Currency:     "VND",
		Deliverables: "1x video post",
	}))
	if err != nil {
		t.Fatalf("Create BrandDeal failed: %v", err)
	}
	dealID := createDealResp.Msg.Deal.DealId

	// Transition negotiating -> agreed
	updateStatusResp, err := dealHandler.UpdateStatus(ctx, connect.NewRequest(&commercev1.BrandDealServiceUpdateStatusRequest{
		WorkspaceId:  wsID,
		DealId:       dealID,
		TargetStatus: commercev1.BrandDealStatus_BRAND_DEAL_STATUS_AGREED,
	}))
	if err != nil {
		t.Fatalf("UpdateStatus to agreed failed: %v", err)
	}
	if updateStatusResp.Msg.Deal.Status != commercev1.BrandDealStatus_BRAND_DEAL_STATUS_AGREED {
		t.Fatalf("expected agreed status")
	}

	// Get Pipeline Stats
	statsResp, err := dealHandler.GetPipelineStats(ctx, connect.NewRequest(&commercev1.GetPipelineStatsRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("GetPipelineStats failed: %v", err)
	}
	if statsResp.Msg.Stats.AgreedCount != 1 {
		t.Fatalf("expected 1 agreed deal in stats, got %d", statsResp.Msg.Stats.AgreedCount)
	}

	// 4. MediaKitService: Generate, GetKit & Export
	genKitResp, err := mediaKitHandler.Generate(ctx, connect.NewRequest(&commercev1.MediaKitServiceGenerateRequest{
		WorkspaceId: wsID,
		Template:    "standard_2026",
	}))
	if err != nil {
		t.Fatalf("Generate MediaKit failed: %v", err)
	}
	kitID := genKitResp.Msg.MediaKit.MediaKitId

	mediaKitResp, err := mediaKitHandler.GetKit(ctx, connect.NewRequest(&commercev1.GetKitRequest{
		WorkspaceId: wsID,
		MediaKitId:  kitID,
	}))
	if err != nil {
		t.Fatalf("GetKit failed: %v", err)
	}
	if mediaKitResp.Msg.MediaKit.MediaKitId != kitID {
		t.Fatalf("expected media kit ID %s", kitID)
	}

	exportResp, err := mediaKitHandler.Export(ctx, connect.NewRequest(&commercev1.MediaKitServiceExportRequest{
		WorkspaceId: wsID,
		MediaKitId:  kitID,
		Format:      "pdf",
	}))
	if err != nil {
		t.Fatalf("Export MediaKit failed: %v", err)
	}
	if exportResp.Msg.ExportUrl == "" {
		t.Fatalf("expected export URL")
	}

	// 5. SponsorInquiryService: Submit & ListInquiries
	submitInqResp, err := inquiryHandler.Submit(ctx, connect.NewRequest(&commercev1.SponsorInquiryServiceSubmitRequest{
		WorkspaceId:    wsID,
		BrandName:      "Super Brands",
		ContactEmail:   "collab@superbrands.com",
		Message:        "We'd love to sponsor your next podcast segment",
		ProposedBudget: 18000000,
	}))
	if err != nil {
		t.Fatalf("Submit inquiry failed: %v", err)
	}
	if submitInqResp.Msg.InquiryId == "" {
		t.Fatalf("expected inquiry id")
	}

	listInqResp, err := inquiryHandler.ListInquiries(ctx, connect.NewRequest(&commercev1.ListInquiriesRequest{
		WorkspaceId: wsID,
	}))
	if err != nil || len(listInqResp.Msg.Inquiries) != 1 {
		t.Fatalf("expected 1 inquiry in list")
	}

	// 6. RevenueTrackerService: GetPerContent & GetRPMTrends (Target 3 check)
	roiResp, err := roiHandler.GetPerContent(ctx, connect.NewRequest(&commercev1.GetPerContentRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("GetPerContent failed: %v", err)
	}
	_ = roiResp

	trendsResp, err := roiHandler.GetRPMTrends(ctx, connect.NewRequest(&commercev1.GetRPMTrendsRequest{
		WorkspaceId: wsID,
		Platform:    "tiktok",
		Periods:     4,
	}))
	if err != nil {
		t.Fatalf("GetRPMTrends failed: %v", err)
	}
	_ = trendsResp

	// 7. TaxReportService: ExportTaxReport
	taxResp, err := taxHandler.ExportTaxReport(ctx, connect.NewRequest(&commercev1.ExportTaxReportRequest{
		WorkspaceId:  wsID,
		Period:       commercev1.TaxReportPeriod_TAX_REPORT_PERIOD_QUARTERLY,
		Year:         2026,
		PeriodNumber: 2,
		Format:       commercev1.TaxReportFormat_TAX_REPORT_FORMAT_PDF,
	}))
	if err != nil {
		t.Fatalf("ExportTaxReport failed: %v", err)
	}
	if taxResp.Msg.Summary == nil || taxResp.Msg.Summary.DownloadUrl == "" {
		t.Fatalf("expected download URL")
	}
}

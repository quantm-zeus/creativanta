package seeding

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func TestSeedingConnectRPCHandlers(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	wsID := "019086a1-7c3e-7000-8000-000000000020"
	prodID := "prod-connect-1"

	cogsDec, _ := tenantdb.ParseExactDecimal("120000.000000")
	_ = store.SetProduct(ctx, wsID, &ProductSummary{
		ProductID: prodID,
		Title:     "Serum Glow",
		COGS:      cogsDec,
		Currency:  "VND",
	})

	svc := NewService(store, nil)
	seedingHandler := NewSeedingHandler(svc)
	sampleHandler := NewSampleHandler(svc)

	// 1. Create Campaign via SeedingService
	campResp, err := seedingHandler.CreateCampaign(ctx, connect.NewRequest(&commercev1.SeedingServiceCreateCampaignRequest{
		WorkspaceId:    wsID,
		Title:          "Holiday 2026 Seeding",
		Objective:      "Brand Awareness",
		StartDate:      "2026-11-01",
		EndDate:        "2026-12-31",
		Budget:         "10000000.000000",
		BudgetCurrency: "VND",
	}))
	if err != nil {
		t.Fatalf("CreateCampaign failed: %v", err)
	}
	campID := campResp.Msg.Campaign.CampaignId
	if campID == "" {
		t.Fatalf("expected non-empty campaign ID")
	}

	// 2. Create Sample Request via SeedingService
	createResp, err := seedingHandler.CreateSample(ctx, connect.NewRequest(&commercev1.SeedingServiceCreateSampleRequest{
		WorkspaceId:     wsID,
		CampaignId:      campID,
		CreatorEntityId: "creator-connect-1",
		ProductId:       prodID,
		Quantity:        2,
		ShippingAddress: &commercev1.ShippingAddress{
			Name:          "Dang Thi C",
			Phone:         "0933333333",
			AddressLine_1: "77 Tran Phu",
			City:          "Nha Trang",
			Country:       "VN",
		},
		Notes: "Holiday promo gift",
	}))
	if err != nil {
		t.Fatalf("CreateSample failed: %v", err)
	}
	reqID := createResp.Msg.SampleRequest.RequestId
	if reqID == "" {
		t.Fatalf("expected non-empty sample request ID")
	}

	// 3. Approve via SampleService
	apprResp, err := sampleHandler.Approve(ctx, connect.NewRequest(&commercev1.SampleServiceApproveRequest{
		WorkspaceId:    wsID,
		RequestId:      reqID,
		IdempotencyKey: "idemp-connect-appr",
	}))
	if err != nil {
		t.Fatalf("SampleService.Approve failed: %v", err)
	}
	if apprResp.Msg.SampleRequest.Status != commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_APPROVED {
		t.Errorf("expected APPROVED, got %v", apprResp.Msg.SampleRequest.Status)
	}

	// 4. Ship via SeedingService
	shipResp, err := seedingHandler.Ship(ctx, connect.NewRequest(&commercev1.SeedingServiceShipRequest{
		WorkspaceId:    wsID,
		RequestId:      reqID,
		Carrier:        "GHTK",
		TrackingNumber: "GHTK-CONNECT-01",
		ShippingCost:   "28000.000000",
		IdempotencyKey: "idemp-connect-ship",
	}))
	if err != nil {
		t.Fatalf("SeedingService.Ship failed: %v", err)
	}
	shipID := shipResp.Msg.Shipment.ShipmentId
	if shipID == "" {
		t.Fatalf("expected non-empty shipment ID")
	}

	// 5. Mark Received (Delivered) via SeedingService
	delivResp, err := seedingHandler.MarkReceived(ctx, connect.NewRequest(&commercev1.SeedingServiceMarkReceivedRequest{
		WorkspaceId: wsID,
		RequestId:   reqID,
	}))
	if err != nil {
		t.Fatalf("SeedingService.MarkReceived failed: %v", err)
	}
	if delivResp.Msg.SampleRequest.Status != commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_FULFILLED {
		t.Errorf("expected FULFILLED status, got %v", delivResp.Msg.SampleRequest.Status)
	}
	// Verify outcome_status is STILL PENDING
	if delivResp.Msg.SampleRequest.OutcomeStatus != commercev1.SampleOutcomeStatus_SAMPLE_OUTCOME_STATUS_PENDING {
		t.Errorf("expected outcome_status PENDING, got %v", delivResp.Msg.SampleRequest.OutcomeStatus)
	}

	// 6. Send Reminder (Follow-up) via SeedingService
	remindResp, err := seedingHandler.SendReminder(ctx, connect.NewRequest(&commercev1.SeedingServiceSendReminderRequest{
		WorkspaceId: wsID,
		RequestId:   reqID,
		Message:     "Messaged creator checking if package arrived safely",
	}))
	if err != nil {
		t.Fatalf("SendReminder failed: %v", err)
	}
	if remindResp.Msg.FollowUpStatus != commercev1.FollowUpStatus_FOLLOW_UP_STATUS_CONTACTED {
		t.Errorf("expected CONTACTED follow up status, got %v", remindResp.Msg.FollowUpStatus)
	}

	// 7. Link Content via SeedingService
	linkResp, err := seedingHandler.LinkContent(ctx, connect.NewRequest(&commercev1.SeedingServiceLinkContentRequest{
		WorkspaceId:         wsID,
		RequestId:           reqID,
		ContentUrl:          "https://tiktok.com/@creator/video/998877",
		ContentType:         "video",
		PublishItemId:       "pub-connect-item-1",
		ConversionsCount:    5,
		AttributableRevenue: "1500000.000000",
		Currency:            "VND",
		SourceClass:         commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_OFFICIAL,
		ConfidenceLevel:     commercev1.SeedingConfidenceLevel_SEEDING_CONFIDENCE_LEVEL_HIGH,
	}))
	if err != nil {
		t.Fatalf("LinkContent failed: %v", err)
	}
	if linkResp.Msg.SampleRequest.OutcomeStatus != commercev1.SampleOutcomeStatus_SAMPLE_OUTCOME_STATUS_LOGGED {
		t.Errorf("expected LOGGED outcome status, got %v", linkResp.Msg.SampleRequest.OutcomeStatus)
	}

	// 8. Get Report via SeedingService
	reportResp, err := seedingHandler.GetReport(ctx, connect.NewRequest(&commercev1.SeedingServiceGetReportRequest{
		WorkspaceId: wsID,
		CampaignId:  campID,
	}))
	if err != nil {
		t.Fatalf("GetReport failed: %v", err)
	}
	// Total cost = 2 * 120,000 + 28,000 = 268,000 VND
	if reportResp.Msg.Report.TotalCost != "268000.000000" {
		t.Errorf("expected total cost 268000.000000, got %s", reportResp.Msg.Report.TotalCost)
	}
	// Total revenue = 1,500,000 VND
	if reportResp.Msg.Report.AttributableRevenue != "1500000.000000" {
		t.Errorf("expected attributable revenue 1500000.000000, got %s", reportResp.Msg.Report.AttributableRevenue)
	}
	// Total delivered = 1, outcomes logged = 1, pending = 0
	if reportResp.Msg.Report.TotalSamplesDelivered != 1 {
		t.Errorf("expected 1 delivered sample, got %d", reportResp.Msg.Report.TotalSamplesDelivered)
	}
	if reportResp.Msg.Report.OutcomesLoggedCount != 1 {
		t.Errorf("expected 1 logged outcome, got %d", reportResp.Msg.Report.OutcomesLoggedCount)
	}
}

var _ = time.Now

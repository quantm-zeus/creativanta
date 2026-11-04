package affiliate

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func TestAffiliateConnectRPCHandlers(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, nil, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	affHandler := NewAffiliateHandler(svc)
	assignHandler := NewCreatorAssignmentHandler(svc)
	attrHandler := NewAttributionHandler(svc)
	commHandler := NewAffiliateCommissionHandler(svc)
	payoutHandler := NewAffiliatePayoutHandler(svc)
	healthHandler := NewLinkHealthHandler(svc)

	// 1. Create Affiliate Link via ConnectRPC
	createLinkResp, err := affHandler.CreateAffiliateLink(ctx, connect.NewRequest(&commercev1.CreateAffiliateLinkRequest{
		WorkspaceId:    wsID,
		Platform:       "tiktok",
		OriginalUrl:    "https://shop.tiktok.com/product/abc",
		CommissionRate: "12.50",
	}))
	if err != nil {
		t.Fatalf("CreateAffiliateLink failed: %v", err)
	}
	linkID := createLinkResp.Msg.Link.AffiliateLinkId
	if linkID == "" {
		t.Fatalf("expected non-empty link ID")
	}

	// 2. Get Link
	getLinkResp, err := affHandler.GetAffiliateLink(ctx, connect.NewRequest(&commercev1.GetAffiliateLinkRequest{
		WorkspaceId:     wsID,
		AffiliateLinkId: linkID,
	}))
	if err != nil || getLinkResp.Msg.Link.Platform != "tiktok" {
		t.Fatalf("GetAffiliateLink failed: %v", err)
	}

	// 3. Create Assignment
	assignResp, err := assignHandler.CreateAssignment(ctx, connect.NewRequest(&commercev1.CreateAssignmentRequest{
		WorkspaceId:     wsID,
		CreatorEntityId: "creator-uuid-1",
		AffiliateLinkId: linkID,
		Notes:           "Launch partner",
	}))
	if err != nil {
		t.Fatalf("CreateAssignment failed: %v", err)
	}
	if assignResp.Msg.Assignment.Status != commercev1.AssignmentStatus_ASSIGNMENT_STATUS_ACTIVE {
		t.Fatalf("expected active assignment")
	}

	// 4. Record Attribution (Multi-touch -> Inferred)
	attrResp, err := attrHandler.RecordAttribution(ctx, connect.NewRequest(&commercev1.RecordAttributionRequest{
		WorkspaceId:     wsID,
		OrderId:         "ord-rpc-01",
		AffiliateLinkId: linkID,
		TouchpointCount: 2,
		IsMultiTouch:    true,
		OrderAmount:     "400000.000000",
		Currency:        "VND",
	}))
	if err != nil {
		t.Fatalf("RecordAttribution failed: %v", err)
	}
	if attrResp.Msg.Attribution.SourceClass != commercev1.AttributionSourceClass_ATTRIBUTION_SOURCE_CLASS_INFERRED {
		t.Fatalf("expected inferred source class")
	}

	// 5. Calculate & Confirm Commission
	calcResp, err := commHandler.CalculateCommission(ctx, connect.NewRequest(&commercev1.CalculateCommissionRequest{
		WorkspaceId:     wsID,
		AffiliateLinkId: linkID,
		OrderId:         "ord-rpc-01",
		OrderAmount:     "400000.000000",
		Currency:        "VND",
	}))
	if err != nil {
		t.Fatalf("CalculateCommission failed: %v", err)
	}
	commID := calcResp.Msg.Commission.CommissionId

	confirmResp, err := commHandler.ConfirmCommission(ctx, connect.NewRequest(&commercev1.ConfirmCommissionRequest{
		WorkspaceId:  wsID,
		CommissionId: commID,
	}))
	if err != nil || confirmResp.Msg.Commission.Status != commercev1.CommissionStatus_COMMISSION_STATUS_CONFIRMED {
		t.Fatalf("ConfirmCommission failed: %v", err)
	}

	// 6. Post Commission to Ledger with EconomicRole Creator
	postResp, err := commHandler.PostCommissionToLedger(ctx, connect.NewRequest(&commercev1.PostCommissionToLedgerRequest{
		WorkspaceId:  wsID,
		CommissionId: commID,
		EconomicRole: commercev1.WorkspaceEconomicRole_WORKSPACE_ECONOMIC_ROLE_CREATOR,
	}))
	if err != nil {
		t.Fatalf("PostCommissionToLedger failed: %v", err)
	}
	if postResp.Msg.Result.PostingType != "creator_income" {
		t.Fatalf("expected creator_income posting type, got %s", postResp.Msg.Result.PostingType)
	}
	if postResp.Msg.Result.CogsDeducted {
		t.Fatalf("COGS must not be deducted for creator income")
	}

	// 7. Create and Execute Payout Batch
	payoutResp, err := payoutHandler.CreatePayoutBatch(ctx, connect.NewRequest(&commercev1.CreatePayoutBatchRequest{
		WorkspaceId:     wsID,
		CreatorEntityId: "creator-uuid-1",
		CommissionIds:   []string{commID},
	}))
	if err != nil {
		t.Fatalf("CreatePayoutBatch failed: %v", err)
	}
	payoutID := payoutResp.Msg.Payout.PayoutId

	execResp, err := payoutHandler.ExecutePayoutBatch(ctx, connect.NewRequest(&commercev1.ExecutePayoutBatchRequest{
		WorkspaceId:  wsID,
		PayoutId:     payoutID,
		SettlementId: "settle-123",
	}))
	if err != nil || execResp.Msg.Payout.Status != commercev1.PayoutStatus_PAYOUT_STATUS_COMPLETED {
		t.Fatalf("ExecutePayoutBatch failed: %v", err)
	}

	// 8. Health check and repair
	healthCheckResp, err := healthHandler.RunHealthCheck(ctx, connect.NewRequest(&commercev1.RunHealthCheckRequest{
		WorkspaceId:             wsID,
		AffiliateLinkId:         linkID,
		SimulatedHttpStatus:     500,
		SimulatedProductStatus: "out_of_stock",
	}))
	if err != nil || !healthCheckResp.Msg.HealthDegraded {
		t.Fatalf("RunHealthCheck expected degraded health")
	}

	repairResp, err := healthHandler.RepairBrokenLink(ctx, connect.NewRequest(&commercev1.RepairBrokenLinkRequest{
		WorkspaceId:          wsID,
		AffiliateLinkId:      linkID,
		NewDestinationUrl:    "https://shop.tiktok.com/product/replacement",
		ReplacementProductId: "prod-new-123",
	}))
	if err != nil || repairResp.Msg.Health.LinkStatus != commercev1.LinkHealthStatus_LINK_HEALTH_STATUS_HEALTHY {
		t.Fatalf("RepairBrokenLink failed: %v", err)
	}
}

func init() {
	_ = tenantdb.ExactDecimal{}
}

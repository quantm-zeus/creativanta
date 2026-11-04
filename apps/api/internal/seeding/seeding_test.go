package seeding

import (
	"context"
	"strings"
	"testing"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func newTestServiceWithProduct(wsID, productID string, cogs string) (*Service, *MemoryStore) {
	store := NewMemoryStore()
	cogsDec, _ := tenantdb.ParseExactDecimal(cogs)
	_ = store.SetProduct(context.Background(), wsID, &ProductSummary{
		ProductID: productID,
		Title:     "Sample Beauty Product",
		COGS:      cogsDec,
		Currency:  "VND",
	})
	svc := NewService(store, nil)
	return svc, store
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Request, shipment, outcome, and follow-up states separate
// ----------------------------------------------------------------------------
func TestTarget1_OrthogonalStateMachines(t *testing.T) {
	ctx := context.Background()
	wsID := "019086a1-7c3e-7000-8000-000000000001"
	prodID := "prod-101"
	svc, _ := newTestServiceWithProduct(wsID, prodID, "150000.000000")

	// 1. Create sample request
	req := &SampleRequest{
		WorkspaceID:     wsID,
		CreatorEntityID: "creator-101",
		ProductID:       prodID,
		Quantity:        2,
		ShippingAddress: ShippingAddress{
			Name:         "Nguyen Van A",
			Phone:        "0901234567",
			AddressLine1: "123 Le Loi",
			City:         "Ho Chi Minh",
			Country:      "VN",
		},
	}
	created, isDup, err := svc.CreateSample(ctx, req, "")
	if err != nil {
		t.Fatalf("CreateSample failed: %v", err)
	}
	if isDup {
		t.Errorf("expected not duplicate")
	}

	// Verify initial orthogonal states
	if created.Status != RequestStatusRequested {
		t.Errorf("expected status %s, got %s", RequestStatusRequested, created.Status)
	}
	if created.OutcomeStatus != OutcomeStatusPending {
		t.Errorf("expected outcome_status %s, got %s", OutcomeStatusPending, created.OutcomeStatus)
	}
	if created.FollowUpStatus != FollowUpPending {
		t.Errorf("expected follow_up_status %s, got %s", FollowUpPending, created.FollowUpStatus)
	}

	// 2. Approve sample request
	apprReq, _, _, err := svc.ApproveSample(ctx, wsID, created.RequestID, "actor-admin", "idemp-appr-1")
	if err != nil {
		t.Fatalf("ApproveSample failed: %v", err)
	}
	if apprReq.Status != RequestStatusApproved {
		t.Errorf("expected status %s, got %s", RequestStatusApproved, apprReq.Status)
	}
	// Verify outcome and follow-up status remain orthogonal and unaffected
	if apprReq.OutcomeStatus != OutcomeStatusPending {
		t.Errorf("expected outcome_status to remain %s, got %s", OutcomeStatusPending, apprReq.OutcomeStatus)
	}
	if apprReq.FollowUpStatus != FollowUpPending {
		t.Errorf("expected follow_up_status to remain %s, got %s", FollowUpPending, apprReq.FollowUpStatus)
	}

	// 3. Ship sample: creates shipment
	shippingCost, _ := tenantdb.ParseExactDecimal("30000.000000")
	shipReq, shipment, isReplay, err := svc.ShipSample(ctx, wsID, created.RequestID, "GHTK", "GHTK-987654321", shippingCost, "idemp-ship-1")
	if err != nil {
		t.Fatalf("ShipSample failed: %v", err)
	}
	if isReplay {
		t.Errorf("expected not replay on first shipment")
	}
	if shipment.Status != ShipmentStatusShipped {
		t.Errorf("expected shipment status %s, got %s", ShipmentStatusShipped, shipment.Status)
	}
	// Verify outcome status is STILL orthogonal pending
	if shipReq.OutcomeStatus != OutcomeStatusPending {
		t.Errorf("expected outcome_status to remain %s, got %s", OutcomeStatusPending, shipReq.OutcomeStatus)
	}

	// 4. Mark received (delivered): logistics fulfilled
	delivReq, delivShip, err := svc.MarkReceived(ctx, wsID, created.RequestID)
	if err != nil {
		t.Fatalf("MarkReceived failed: %v", err)
	}
	if delivShip.Status != ShipmentStatusDelivered {
		t.Errorf("expected shipment status %s, got %s", ShipmentStatusDelivered, delivShip.Status)
	}
	if delivReq.Status != RequestStatusFulfilled {
		t.Errorf("expected request status %s, got %s", RequestStatusFulfilled, delivReq.Status)
	}
	// Target 1 critical check: outcome_status remains pending!
	if delivReq.OutcomeStatus != OutcomeStatusPending {
		t.Errorf("expected outcome_status to remain %s after delivery, got %s", OutcomeStatusPending, delivReq.OutcomeStatus)
	}

	// 5. Update Follow-up status independently
	fuReq, err := svc.UpdateFollowUp(ctx, wsID, created.RequestID, FollowUpContacted, "Sent DM check-in")
	if err != nil {
		t.Fatalf("UpdateFollowUp failed: %v", err)
	}
	if fuReq.FollowUpStatus != FollowUpContacted {
		t.Errorf("expected follow_up_status %s, got %s", FollowUpContacted, fuReq.FollowUpStatus)
	}
	if fuReq.OutcomeStatus != OutcomeStatusPending {
		t.Errorf("expected outcome_status to still be %s, got %s", OutcomeStatusPending, fuReq.OutcomeStatus)
	}

	// 6. Link Content Outcome independently
	rev, _ := tenantdb.ParseExactDecimal("1200000.000000")
	linkedReq, err := svc.LinkContent(ctx, wsID, created.RequestID, SampleOutcome{
		ContentURL:          "https://tiktok.com/@creator/video/123",
		ContentType:         "video",
		PublishItemID:       "pub-item-1",
		AttributableRevenue: rev,
		Currency:            "VND",
		SourceClass:         SourceClassOfficial,
		ConfidenceLevel:     ConfidenceHigh,
	})
	if err != nil {
		t.Fatalf("LinkContent failed: %v", err)
	}
	if linkedReq.OutcomeStatus != OutcomeStatusLogged {
		t.Errorf("expected outcome_status %s, got %s", OutcomeStatusLogged, linkedReq.OutcomeStatus)
	}
	// Follow-up status is preserved independently
	if linkedReq.FollowUpStatus != FollowUpContacted {
		t.Errorf("expected follow_up_status to remain %s, got %s", FollowUpContacted, linkedReq.FollowUpStatus)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Missing outcome not definitive zero
// ----------------------------------------------------------------------------
func TestTarget2_MissingOutcomeNotDefinitiveZero(t *testing.T) {
	ctx := context.Background()
	wsID := "019086a1-7c3e-7000-8000-000000000002"
	prodID := "prod-202"
	store := NewMemoryStore()
	cogsDec, _ := tenantdb.ParseExactDecimal("250000.000000")
	_ = store.SetProduct(ctx, wsID, &ProductSummary{
		ProductID: prodID,
		Title:     "Summer Skincare Kit",
		COGS:      cogsDec,
		Currency:  "VND",
	})
	svc := NewService(store, nil)

	// Create campaign
	campID := "camp-summer-2026"
	budget, _ := tenantdb.ParseExactDecimal("5000000.000000")
	_ = svc.CreateCampaign(ctx, &SeedingCampaign{
		CampaignID:     campID,
		WorkspaceID:    wsID,
		Title:          "Summer Glow 2026",
		Objective:      "Brand awareness",
		Status:         "active",
		Budget:         budget,
		BudgetCurrency: "VND",
	})

	// Create, approve, ship, deliver sample request
	req := &SampleRequest{
		WorkspaceID:     wsID,
		CampaignID:      &campID,
		CreatorEntityID: "creator-202",
		ProductID:       prodID,
		Quantity:        1,
		ShippingAddress: ShippingAddress{Name: "Tran Thi B", Phone: "0912345678", City: "Da Nang", Country: "VN"},
	}
	created, _, err := svc.CreateSample(ctx, req, "")
	if err != nil {
		t.Fatalf("CreateSample failed: %v", err)
	}

	_, _, _, err = svc.ApproveSample(ctx, wsID, created.RequestID, "actor-admin", "idemp-appr-2")
	if err != nil {
		t.Fatalf("ApproveSample failed: %v", err)
	}

	shippingCost, _ := tenantdb.ParseExactDecimal("35000.000000")
	_, _, _, err = svc.ShipSample(ctx, wsID, created.RequestID, "ViettelPost", "VT-123456", shippingCost, "idemp-ship-2")
	if err != nil {
		t.Fatalf("ShipSample failed: %v", err)
	}

	_, _, err = svc.MarkReceived(ctx, wsID, created.RequestID)
	if err != nil {
		t.Fatalf("MarkReceived failed: %v", err)
	}

	// At this point: Sample is delivered, but outcome is still PENDING (not yet logged)
	report, err := svc.GetReport(ctx, wsID, campID)
	if err != nil {
		t.Fatalf("GetReport failed: %v", err)
	}

	// Target 2 Validations:
	if report.TotalSamplesDelivered != 1 {
		t.Errorf("expected 1 delivered sample, got %d", report.TotalSamplesDelivered)
	}
	if report.OutcomesLoggedCount != 0 {
		t.Errorf("expected 0 logged outcomes, got %d", report.OutcomesLoggedCount)
	}
	if report.PendingOutcomesCount != 1 {
		t.Errorf("expected 1 pending outcome, got %d", report.PendingOutcomesCount)
	}
	if !report.IsMissingOutcomePending {
		t.Errorf("expected IsMissingOutcomePending to be true")
	}

	// Missing outcome must NOT claim definitive zero revenue
	if !strings.Contains(strings.ToLower(report.ConfidenceNotes), "pending") || !strings.Contains(strings.ToLower(report.ConfidenceNotes), "not counted as zero revenue") {
		t.Errorf("expected confidence notes to clarify missing outcomes are pending and not counted as zero revenue, got: %s", report.ConfidenceNotes)
	}

	// Confidence level must be qualified (cannot be High when outcomes are pending)
	if report.OverallConfidence == ConfidenceHigh {
		t.Errorf("expected overall confidence to be qualified (Medium/Low), got %s", report.OverallConfidence)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Replay no duplicate sample cost
// ----------------------------------------------------------------------------
func TestTarget3_ReplayNoDuplicateSampleCost(t *testing.T) {
	ctx := context.Background()
	wsID := "019086a1-7c3e-7000-8000-000000000003"
	prodID := "prod-303"
	store := NewMemoryStore()
	cogsDec, _ := tenantdb.ParseExactDecimal("100000.000000")
	_ = store.SetProduct(ctx, wsID, &ProductSummary{
		ProductID: prodID,
		Title:     "Lipstick Red",
		COGS:      cogsDec,
		Currency:  "VND",
	})
	svc := NewService(store, nil)

	req := &SampleRequest{
		WorkspaceID:     wsID,
		CreatorEntityID: "creator-303",
		ProductID:       prodID,
		Quantity:        3,
		ShippingAddress: ShippingAddress{Name: "Le Van C", Phone: "0987654321", City: "Hanoi", Country: "VN"},
	}
	created, _, err := svc.CreateSample(ctx, req, "")
	if err != nil {
		t.Fatalf("CreateSample failed: %v", err)
	}

	// 1. First Approve: creates provisional cost item (3 * 100,000 = 300,000 VND)
	idempApprove := "idemp-replay-appr-42"
	_, costSummary1, isReplay1, err := svc.ApproveSample(ctx, wsID, created.RequestID, "actor-admin", idempApprove)
	if err != nil {
		t.Fatalf("First ApproveSample failed: %v", err)
	}
	if isReplay1 {
		t.Errorf("expected not replay on first approve")
	}
	if costSummary1 == nil || costSummary1.Amount.Fixed6String() != "300000.000000" {
		t.Fatalf("expected cost item amount 300000.000000, got %v", costSummary1)
	}

	// Verify only 1 cost item exists
	if len(store.costItems) != 1 {
		t.Fatalf("expected 1 cost item in store, got %d", len(store.costItems))
	}

	// 2. Replay Approve with same idempotency key
	_, costSummary2, isReplay2, err := svc.ApproveSample(ctx, wsID, created.RequestID, "actor-admin", idempApprove)
	if err != nil {
		t.Fatalf("Replay ApproveSample failed: %v", err)
	}
	if !isReplay2 {
		t.Errorf("expected isReplay to be true on replay")
	}
	if costSummary2.Amount.Fixed6String() != "300000.000000" {
		t.Errorf("expected replay amount 300000.000000, got %s", costSummary2.Amount.Fixed6String())
	}
	// Verify STILL only 1 cost item in store (no duplicate!)
	if len(store.costItems) != 1 {
		t.Fatalf("expected STILL 1 cost item in store after replay, got %d", len(store.costItems))
	}

	// 3. First Ship: updates existing cost item with actual shipping (300,000 + 45,000 = 345,000 VND)
	idempShip := "idemp-replay-ship-88"
	shippingCost, _ := tenantdb.ParseExactDecimal("45000.000000")
	_, ship1, isReplayShip1, err := svc.ShipSample(ctx, wsID, created.RequestID, "ShopeeExpress", "SPX-11223344", shippingCost, idempShip)
	if err != nil {
		t.Fatalf("First ShipSample failed: %v", err)
	}
	if isReplayShip1 {
		t.Errorf("expected not replay on first ship")
	}
	if ship1.TrackingNumber != "SPX-11223344" {
		t.Errorf("expected tracking SPX-11223344, got %s", ship1.TrackingNumber)
	}

	// Cost item updated in-place: still exactly 1 cost item for this request!
	if len(store.costItems) != 1 {
		t.Fatalf("expected still exactly 1 cost item in store, got %d", len(store.costItems))
	}
	costItem := store.costItems[wsID+":"+created.RequestID]
	if costItem.Amount.Fixed6String() != "345000.000000" {
		t.Errorf("expected total cost %s, got %s", "345000.000000", costItem.Amount.Fixed6String())
	}

	// 4. Replay Ship with same idempotency key
	_, ship2, isReplayShip2, err := svc.ShipSample(ctx, wsID, created.RequestID, "ShopeeExpress", "SPX-11223344", shippingCost, idempShip)
	if err != nil {
		t.Fatalf("Replay ShipSample failed: %v", err)
	}
	if !isReplayShip2 {
		t.Errorf("expected isReplayShip2 to be true")
	}
	if ship2.ShipmentID != ship1.ShipmentID {
		t.Errorf("expected same shipment ID on replay, got %s vs %s", ship2.ShipmentID, ship1.ShipmentID)
	}
	// Verify NO duplicate cost item created
	if len(store.costItems) != 1 {
		t.Fatalf("expected STILL exactly 1 cost item in store after replay ship, got %d", len(store.costItems))
	}
}

// ----------------------------------------------------------------------------
// Domain Rules & Edge Cases
// ----------------------------------------------------------------------------
func TestEdgeCase_M18_001_DeliveredNoCreatorResponse(t *testing.T) {
	ctx := context.Background()
	wsID := "019086a1-7c3e-7000-8000-000000000004"
	svc, _ := newTestServiceWithProduct(wsID, "prod-404", "100000.000000")

	req := &SampleRequest{
		WorkspaceID:     wsID,
		CreatorEntityID: "creator-unresponsive",
		ProductID:       "prod-404",
		Quantity:        1,
		ShippingAddress: ShippingAddress{Name: "Tester", Phone: "0900000000", AddressLine1: "Street 1", City: "HCM", Country: "VN"},
	}
	created, _, _ := svc.CreateSample(ctx, req, "")
	_, _, _, _ = svc.ApproveSample(ctx, wsID, created.RequestID, "admin", "")
	shippingCost, _ := tenantdb.ParseExactDecimal("20000.000000")
	_, _, _, _ = svc.ShipSample(ctx, wsID, created.RequestID, "GHN", "GHN-001", shippingCost, "")
	_, _, _ = svc.MarkReceived(ctx, wsID, created.RequestID)

	// Follow-up: Creator does not respond after attempts
	updatedReq, err := svc.UpdateFollowUp(ctx, wsID, created.RequestID, FollowUpNoResponse, "Contacted 3 times via email and Zalo, no response")
	if err != nil {
		t.Fatalf("UpdateFollowUp failed: %v", err)
	}
	if updatedReq.FollowUpStatus != FollowUpNoResponse {
		t.Errorf("expected %s, got %s", FollowUpNoResponse, updatedReq.FollowUpStatus)
	}
	// Outcome remains pending (not definitive loss/failure)
	if updatedReq.OutcomeStatus != OutcomeStatusPending {
		t.Errorf("expected outcome status %s, got %s", OutcomeStatusPending, updatedReq.OutcomeStatus)
	}
}

func TestEdgeCase_M18_002_UnlinkedContentTaggedInferred(t *testing.T) {
	ctx := context.Background()
	wsID := "019086a1-7c3e-7000-8000-000000000005"
	svc, _ := newTestServiceWithProduct(wsID, "prod-505", "100000.000000")

	req := &SampleRequest{
		WorkspaceID:     wsID,
		CreatorEntityID: "creator-inferred",
		ProductID:       "prod-505",
		Quantity:        1,
		ShippingAddress: ShippingAddress{Name: "Tester", Phone: "0900000000", AddressLine1: "Street 1", City: "HCM", Country: "VN"},
	}
	created, _, _ := svc.CreateSample(ctx, req, "")

	// Creator posted video without tracked publish item / affiliate link, claiming official
	rev, _ := tenantdb.ParseExactDecimal("2500000.000000")
	outcome := SampleOutcome{
		ContentURL:          "https://tiktok.com/@creator/video/unlinked",
		ContentType:         "video",
		PublishItemID:       "", // Empty publish item ID
		AttributableRevenue: rev,
		Currency:            "VND",
		SourceClass:         SourceClassOfficial, // Claims official
	}
	updatedReq, err := svc.LinkContent(ctx, wsID, created.RequestID, outcome)
	if err != nil {
		t.Fatalf("LinkContent failed: %v", err)
	}

	// Service MUST downgrade SourceClass to Imported/Inferred because no publish_item_id exists
	if updatedReq.Outcome.SourceClass == SourceClassOfficial {
		t.Errorf("unlinked content must not be tagged Official source class")
	}
	if updatedReq.Outcome.SourceClass != SourceClassImported {
		t.Errorf("expected Imported source class, got %s", updatedReq.Outcome.SourceClass)
	}
}

func TestEdgeCase_M18_003_MissingCOGSDefaultsToZeroWithConfidenceReason(t *testing.T) {
	ctx := context.Background()
	wsID := "019086a1-7c3e-7000-8000-000000000006"
	store := NewMemoryStore() // No product in store!
	svc := NewService(store, nil)

	req := &SampleRequest{
		WorkspaceID:     wsID,
		CreatorEntityID: "creator-no-cogs",
		ProductID:       "prod-missing",
		Quantity:        2,
		ShippingAddress: ShippingAddress{Name: "Tester", Phone: "0900000000", AddressLine1: "Street 1", City: "HCM", Country: "VN"},
	}
	created, _, err := svc.CreateSample(ctx, req, "")
	if err != nil {
		t.Fatalf("CreateSample failed: %v", err)
	}

	_, costSummary, _, err := svc.ApproveSample(ctx, wsID, created.RequestID, "admin", "")
	if err != nil {
		t.Fatalf("ApproveSample failed: %v", err)
	}

	// Missing COGS defaults to 0 with confidence reason noted
	if costSummary.Amount.Fixed6String() != "0.000000" {
		t.Errorf("expected 0.000000 cost summary for missing COGS, got %s", costSummary.Amount.Fixed6String())
	}
	if !strings.Contains(costSummary.Description, "COGS not configured") {
		t.Errorf("expected description to mention COGS not configured, got %s", costSummary.Description)
	}
}

func TestEdgeCase_M18_004_DuplicateRequestDetection(t *testing.T) {
	ctx := context.Background()
	wsID := "019086a1-7c3e-7000-8000-000000000007"
	svc, _ := newTestServiceWithProduct(wsID, "prod-707", "100000.000000")

	req1 := &SampleRequest{
		WorkspaceID:     wsID,
		CreatorEntityID: "creator-dup",
		ProductID:       "prod-707",
		Quantity:        1,
		ShippingAddress: ShippingAddress{Name: "Tester", Phone: "0900000000", AddressLine1: "Street 1", City: "HCM", Country: "VN"},
	}
	_, isDup1, err := svc.CreateSample(ctx, req1, "")
	if err != nil {
		t.Fatalf("First CreateSample failed: %v", err)
	}
	if isDup1 {
		t.Errorf("first request should not be duplicate")
	}

	// Second request for same creator + same product while first is still pending/active
	req2 := &SampleRequest{
		WorkspaceID:     wsID,
		CreatorEntityID: "creator-dup",
		ProductID:       "prod-707",
		Quantity:        1,
		ShippingAddress: ShippingAddress{Name: "Tester", Phone: "0900000000", AddressLine1: "Street 1", City: "HCM", Country: "VN"},
	}
	_, isDup2, err := svc.CreateSample(ctx, req2, "")
	if err != nil {
		t.Fatalf("Second CreateSample failed: %v", err)
	}
	if !isDup2 {
		t.Errorf("expected duplicate flag to be true for second request")
	}
}

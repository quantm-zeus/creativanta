package affiliate

import (
	"context"
	"sync"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type mockSink struct {
	mu     sync.Mutex
	events []OutboxEvent
}

func (m *mockSink) Emit(_ context.Context, ev OutboxEvent) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = append(m.events, ev)
	return nil
}

func (m *mockSink) CountType(evType string) int {
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

func mustDecimal(t *testing.T, s string) tenantdb.ExactDecimal {
	t.Helper()
	d, err := tenantdb.ParseExactDecimal(s)
	if err != nil {
		t.Fatalf("invalid decimal %q: %v", s, err)
	}
	return d
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Creator Income Distinct from Seller Expense
// ----------------------------------------------------------------------------

func TestAcceptanceTarget1_CreatorIncomeDistinctFromSellerExpense(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	prodID := newUUID()

	// 1. Create active affiliate link with 10% commission
	link, err := svc.CreateLink(ctx, &AffiliateLink{
		WorkspaceID:    wsID,
		ProductID:      &prodID,
		Platform:       "shopee",
		OriginalURL:    "https://shopee.vn/product/123",
		CommissionRate: mustDecimal(t, "10.00"),
	})
	if err != nil {
		t.Fatalf("failed to create affiliate link: %v", err)
	}

	// 2. Calculate commission for an order of 1,000,000 VND -> 100,000 VND commission
	orderAmount := mustDecimal(t, "1000000.000000")
	comm, err := svc.CalculateCommission(ctx, wsID, link.AffiliateLinkID, "ord-101", nil, orderAmount, "VND", 15)
	if err != nil {
		t.Fatalf("failed to calculate commission: %v", err)
	}
	expectedComm := mustDecimal(t, "100000.000000")
	if comm.CommissionAmount.Cmp(expectedComm) != 0 {
		t.Fatalf("expected commission 100,000 VND, got %s", comm.CommissionAmount.String())
	}

	// 3. Confirm commission
	comm, err = svc.ConfirmCommission(ctx, wsID, comm.CommissionID)
	if err != nil {
		t.Fatalf("failed to confirm commission: %v", err)
	}
	if comm.Status != CommissionConfirmed {
		t.Fatalf("expected commission confirmed, got %s", comm.Status)
	}

	// 4. Post to ledger as CREATOR role:
	// - RULE-M16-003 & AC 3: "seller commission is one expense; creator commission is income.
	//   The same sale MUST NOT deduct seller commission/COGS from a creator income view."
	creatorPosting, err := svc.PostCommissionToLedger(ctx, wsID, comm.CommissionID, EconomicRoleCreator)
	if err != nil {
		t.Fatalf("failed to post creator commission: %v", err)
	}
	if creatorPosting.PostingType != "creator_income" {
		t.Fatalf("expected posting type 'creator_income', got %s", creatorPosting.PostingType)
	}
	if creatorPosting.COGSDeducted {
		t.Fatalf("acceptance violation: COGS MUST NOT be deducted from creator income view!")
	}
	if creatorPosting.NetProfitImpact.Cmp(expectedComm) != 0 {
		t.Fatalf("expected net profit impact +100,000 for creator income, got %s", creatorPosting.NetProfitImpact.String())
	}

	// 5. Post to ledger as SELLER role:
	// - Seller pays commission to affiliates: it is a cost/expense deduction
	sellerPosting, err := svc.PostCommissionToLedger(ctx, wsID, comm.CommissionID, EconomicRoleSeller)
	if err != nil {
		t.Fatalf("failed to post seller commission: %v", err)
	}
	if sellerPosting.PostingType != "seller_commission_expense" {
		t.Fatalf("expected posting type 'seller_commission_expense', got %s", sellerPosting.PostingType)
	}
	if !sellerPosting.COGSDeducted {
		t.Fatalf("expected seller posting to account for seller expense structure")
	}
	expectedSellerImpact := mustDecimal(t, "-100000.000000")
	if sellerPosting.NetProfitImpact.Cmp(expectedSellerImpact) != 0 {
		t.Fatalf("expected net profit impact -100,000 for seller expense, got %s", sellerPosting.NetProfitImpact.String())
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Ambiguous Attribution Labeled
// ----------------------------------------------------------------------------

func TestAcceptanceTarget2_AmbiguousAttributionLabeled(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	prodID := newUUID()

	link, _ := svc.CreateLink(ctx, &AffiliateLink{
		WorkspaceID:    wsID,
		ProductID:      &prodID,
		Platform:       "tiktok",
		OriginalURL:    "https://shop.tiktok.com/prod/456",
		CommissionRate: mustDecimal(t, "15.00"),
	})

	// Case 1: Definitive Official Attribution (single click from connected API)
	attrOfficial, err := svc.RecordAttribution(ctx, &AttributionInput{
		WorkspaceID:     wsID,
		OrderID:         "ord-official-001",
		AffiliateLinkID: link.AffiliateLinkID,
		TouchpointCount: 1,
		IsMultiTouch:    false,
		OrderAmount:     mustDecimal(t, "500000.000000"),
		Currency:        "VND",
		IsOfficialAPI:   true,
	})
	if err != nil {
		t.Fatalf("failed official attribution: %v", err)
	}
	if attrOfficial.SourceClass != SourceClassOfficial {
		t.Fatalf("expected source_class 'official', got %s", attrOfficial.SourceClass)
	}
	if attrOfficial.Confidence != ConfidenceHigh {
		t.Fatalf("expected confidence 'high', got %s", attrOfficial.Confidence)
	}

	// Case 2: Ambiguous Multi-Touch Attribution (customer clicked affiliate link, then direct visit)
	// - RULE-M16-001, RULE-M16-002, AC 2:
	//   "Ambiguous attribution MUST be explicitly labeled as inferred or unreconciled.
	//    The system MUST NOT present uncertain attribution as definitive truth."
	attrInferred, err := svc.RecordAttribution(ctx, &AttributionInput{
		WorkspaceID:     wsID,
		OrderID:         "ord-multitouch-002",
		AffiliateLinkID: link.AffiliateLinkID,
		TouchpointCount: 2,
		IsMultiTouch:    true,
		OrderAmount:     mustDecimal(t, "800000.000000"),
		Currency:        "VND",
		IsOfficialAPI:   false,
	})
	if err != nil {
		t.Fatalf("failed multi-touch attribution: %v", err)
	}
	if attrInferred.SourceClass != SourceClassInferred {
		t.Fatalf("acceptance violation: ambiguous attribution MUST be labeled 'inferred', got %s", attrInferred.SourceClass)
	}
	if attrInferred.Confidence != ConfidenceMedium {
		t.Fatalf("expected confidence 'medium', got %s", attrInferred.Confidence)
	}
	if attrInferred.AttributionNote != "Multiple touch points detected — last click rule applied." {
		t.Fatalf("expected multi-touch explanation note, got %q", attrInferred.AttributionNote)
	}

	// Case 3: High Ambiguity Multi-Touch (>3 touchpoints) -> confidence LOW
	attrLow, err := svc.RecordAttribution(ctx, &AttributionInput{
		WorkspaceID:     wsID,
		OrderID:         "ord-multitouch-003",
		AffiliateLinkID: link.AffiliateLinkID,
		TouchpointCount: 4,
		IsMultiTouch:    true,
		OrderAmount:     mustDecimal(t, "300000.000000"),
		Currency:        "VND",
		IsOfficialAPI:   false,
	})
	if err != nil {
		t.Fatalf("failed low confidence attribution: %v", err)
	}
	if attrLow.Confidence != ConfidenceLow {
		t.Fatalf("expected confidence 'low' for 4 touchpoints, got %s", attrLow.Confidence)
	}

	// Verify Attribution Report aggregates breakdown
	records, counts, totRev, err := svc.GetAttributionReport(ctx, wsID, &link.AffiliateLinkID)
	if err != nil {
		t.Fatalf("failed to get attribution report: %v", err)
	}
	if len(records) != 3 {
		t.Fatalf("expected 3 attribution records, got %d", len(records))
	}
	if counts["official"] != 1 || counts["inferred"] != 2 {
		t.Fatalf("unexpected counts: %+v", counts)
	}
	expectedTotalRev := mustDecimal(t, "1600000.000000") // 500k + 800k + 300k
	if totRev.Cmp(expectedTotalRev) != 0 {
		t.Fatalf("expected total revenue %s, got %s", expectedTotalRev.String(), totRev.String())
	}

	// Check conversion.attributed event emission
	if sink.CountType("conversion.attributed") != 3 {
		t.Fatalf("expected 3 conversion.attributed events, got %d", sink.CountType("conversion.attributed"))
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Broken Link Repair
// ----------------------------------------------------------------------------

func TestAcceptanceTarget3_BrokenLinkRepair(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	prodID := newUUID()
	replacementProdID := newUUID()

	link, _ := svc.CreateLink(ctx, &AffiliateLink{
		WorkspaceID:    wsID,
		ProductID:      &prodID,
		Platform:       "lazada",
		OriginalURL:    "https://lazada.vn/products/old-item",
		CommissionRate: mustDecimal(t, "8.00"),
	})

	// 1. Health check detects 404 dead link and out of stock product
	hr, degraded, err := svc.RunHealthCheck(ctx, wsID, link.AffiliateLinkID, 404, "out_of_stock", "8.00")
	if err != nil {
		t.Fatalf("failed to run health check: %v", err)
	}
	if !degraded {
		t.Fatalf("expected link health to be degraded")
	}
	if hr.LinkStatus != HealthStatusBroken {
		t.Fatalf("expected link status 'broken', got %s", hr.LinkStatus)
	}
	if !hr.AlertSent {
		t.Fatalf("expected alert to be sent on broken link")
	}
	if hr.EstimatedRevenueImpact.Cmp(mustDecimal(t, "0.000000")) <= 0 {
		t.Fatalf("expected positive estimated revenue impact, got %s", hr.EstimatedRevenueImpact.String())
	}

	// Verify link was updated to broken
	updatedLink, _, _ := svc.GetLink(ctx, wsID, link.AffiliateLinkID)
	if updatedLink.HealthStatus != HealthStatusBroken {
		t.Fatalf("expected affiliate link health status 'broken', got %s", updatedLink.HealthStatus)
	}

	// Verify critical notification event emitted
	if sink.CountType("affiliate.link_health.broken") != 1 {
		t.Fatalf("expected affiliate.link_health.broken event to be emitted")
	}

	// 2. Perform Broken Link Repair Workflow
	newURL := "https://lazada.vn/products/replacement-item"
	repairedLink, repairedHealth, err := svc.RepairBrokenLink(ctx, wsID, link.AffiliateLinkID, newURL, replacementProdID)
	if err != nil {
		t.Fatalf("failed to repair broken link: %v", err)
	}

	if repairedLink.HealthStatus != HealthStatusHealthy {
		t.Fatalf("expected repaired link to have health status 'healthy', got %s", repairedLink.HealthStatus)
	}
	if repairedLink.OriginalURL != newURL {
		t.Fatalf("expected updated original URL %q, got %q", newURL, repairedLink.OriginalURL)
	}
	if *repairedLink.ProductID != replacementProdID {
		t.Fatalf("expected updated product ID %q, got %q", replacementProdID, *repairedLink.ProductID)
	}
	if repairedHealth.LinkStatus != HealthStatusHealthy {
		t.Fatalf("expected new health record to be healthy, got %s", repairedHealth.LinkStatus)
	}

	// 3. State Machine Guard: Permitted policy revocation -> revoked is terminal!
	// Link health recovery CANNOT silently reactivate a revoked link!
	_, err = svc.RevokeLink(ctx, wsID, link.AffiliateLinkID)
	if err != nil {
		t.Fatalf("failed to revoke link: %v", err)
	}
	_, _, err = svc.RepairBrokenLink(ctx, wsID, link.AffiliateLinkID, "https://lazada.vn/another", replacementProdID)
	if err != ErrLinkPermanentlyRevoked {
		t.Fatalf("expected ErrLinkPermanentlyRevoked when trying to repair revoked link, got %v", err)
	}
}

// ----------------------------------------------------------------------------
// Creator Assignments & Coupons
// ----------------------------------------------------------------------------

func TestCreatorAssignmentsAndCoupons(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	campID := newUUID()
	creatorID := newUUID()
	linkID := newUUID()
	couponID := newUUID()

	// Create creator assignment
	assignment, err := svc.CreateAssignment(ctx, &CreatorAssignment{
		WorkspaceID:     wsID,
		CampaignID:      &campID,
		CreatorEntityID: creatorID,
		AffiliateLinkID: &linkID,
		CouponID:        &couponID,
		Notes:           "Exclusive influencer deal for Q4 launch",
	})
	if err != nil {
		t.Fatalf("failed to create assignment: %v", err)
	}
	if assignment.Status != AssignmentActive {
		t.Fatalf("expected assignment active, got %s", assignment.Status)
	}

	// List assignments
	list, err := svc.ListAssignments(ctx, wsID, &campID, &creatorID, 10, 0)
	if err != nil || len(list) != 1 {
		t.Fatalf("expected 1 assignment in list, got %d (err: %v)", len(list), err)
	}

	// Update assignment status to completed
	updated, err := svc.UpdateAssignment(ctx, wsID, assignment.AssignmentID, AssignmentCompleted, "Delivered all posts")
	if err != nil {
		t.Fatalf("failed to update assignment: %v", err)
	}
	if updated.Status != AssignmentCompleted {
		t.Fatalf("expected status completed, got %s", updated.Status)
	}

	if sink.CountType("creator_assignment.created") != 1 {
		t.Fatalf("expected creator_assignment.created event")
	}
}

// ----------------------------------------------------------------------------
// Statement Imports & Reconciliation
// ----------------------------------------------------------------------------

func TestAffiliateStatementImportAndReconciliation(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	svc := NewService(store, nil, nil, nil)
	wsID := "019086a1-7c3e-7000-8000-000000000010"

	// 1. Seed two commissions
	comm1 := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ext-ord-001",
		CommissionAmount: mustDecimal(t, "50000.000000"),
		Currency:         "VND",
		Status:           CommissionPending,
	}
	_ = store.CreateCommission(ctx, comm1)

	comm2 := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ext-ord-002",
		CommissionAmount: mustDecimal(t, "75000.000000"),
		Currency:         "VND",
		Status:           CommissionPending,
	}
	_ = store.CreateCommission(ctx, comm2)

	// 2. Import statement with 1 matching item, 1 conflicting item, 1 unmatched item
	stmt := &AffiliateStatement{
		WorkspaceID:          wsID,
		Platform:             "shopee",
		ExternalStatementRef: "STMT-2026-OCT",
		PeriodStart:          "2026-10-01",
		PeriodEnd:            "2026-10-31",
		TotalCommission:      mustDecimal(t, "225000.000000"),
		Currency:             "VND",
	}

	items := []*AffiliateStatementItem{
		{
			ExternalOrderID:  "ext-ord-001",
			OrderAmount:      mustDecimal(t, "500000.000000"),
			CommissionAmount: mustDecimal(t, "50000.000000"), // Match!
		},
		{
			ExternalOrderID:  "ext-ord-002",
			OrderAmount:      mustDecimal(t, "750000.000000"),
			CommissionAmount: mustDecimal(t, "90000.000000"), // Conflict (expected 75k, got 90k)
		},
		{
			ExternalOrderID:  "ext-ord-999",
			OrderAmount:      mustDecimal(t, "1000000.000000"),
			CommissionAmount: mustDecimal(t, "100000.000000"), // Unmatched / unreconciled
		},
	}

	importedStmt, err := svc.ImportStatement(ctx, stmt, items)
	if err != nil {
		t.Fatalf("failed to import statement: %v", err)
	}
	if importedStmt.ReconciliationState != "imported_only" {
		t.Fatalf("expected state 'imported_only', got %s", importedStmt.ReconciliationState)
	}

	// 3. Trigger reconciliation
	reconciledStmt, matched, conflict, unreconciled, err := svc.ReconcileStatement(ctx, wsID, importedStmt.StatementID)
	if err != nil {
		t.Fatalf("failed to reconcile statement: %v", err)
	}

	if matched != 1 || conflict != 1 || unreconciled != 1 {
		t.Fatalf("unexpected counts: matched=%d, conflict=%d, unreconciled=%d", matched, conflict, unreconciled)
	}
	// Conflict detected takes precedence in state
	if reconciledStmt.ReconciliationState != "conflict_detected" {
		t.Fatalf("expected reconciliation_state 'conflict_detected', got %s", reconciledStmt.ReconciliationState)
	}
}

// ----------------------------------------------------------------------------
// Payout Batch & Proof Generation
// ----------------------------------------------------------------------------

func TestPayoutBatchAndProofGeneration(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	svc := NewService(store, nil, sink, nil)
	wsID := "019086a1-7c3e-7000-8000-000000000010"
	creatorID := newUUID()

	// 1. Create two confirmed commissions
	comm1 := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-payout-1",
		CreatorEntityID:  &creatorID,
		CommissionAmount: mustDecimal(t, "300000.000000"),
		Currency:         "VND",
		Status:           CommissionConfirmed,
	}
	_ = store.CreateCommission(ctx, comm1)

	comm2 := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-payout-2",
		CreatorEntityID:  &creatorID,
		CommissionAmount: mustDecimal(t, "200000.000000"),
		Currency:         "VND",
		Status:           CommissionConfirmed,
	}
	_ = store.CreateCommission(ctx, comm2)

	// 2. Create Payout Batch
	payout, err := svc.CreatePayoutBatch(ctx, wsID, creatorID, []string{comm1.CommissionID, comm2.CommissionID})
	if err != nil {
		t.Fatalf("failed to create payout batch: %v", err)
	}
	expectedTotal := mustDecimal(t, "500000.000000")
	if payout.TotalAmount.Cmp(expectedTotal) != 0 {
		t.Fatalf("expected total payout 500,000 VND, got %s", payout.TotalAmount.String())
	}
	if payout.Status != PayoutPending {
		t.Fatalf("expected status pending, got %s", payout.Status)
	}

	// 3. Execute Payout Batch with Settlement ID
	settlementID := newUUID()
	executed, err := svc.ExecutePayoutBatch(ctx, wsID, payout.PayoutID, settlementID)
	if err != nil {
		t.Fatalf("failed to execute payout: %v", err)
	}
	if executed.Status != PayoutCompleted {
		t.Fatalf("expected payout completed, got %s", executed.Status)
	}
	if executed.ProofHash == "" {
		t.Fatalf("expected cryptographic proof hash to be generated")
	}

	// 4. Verify Payout Proof endpoint
	_, proofHash, proofURL, err := svc.GetPayoutProof(ctx, wsID, payout.PayoutID)
	if err != nil {
		t.Fatalf("failed to get payout proof: %v", err)
	}
	if proofHash != executed.ProofHash {
		t.Fatalf("mismatched proof hash")
	}
	if proofURL == "" {
		t.Fatalf("expected proof URL")
	}

	// 5. Verify individual commissions transitioned to paid_out
	c1, _ := store.GetCommission(ctx, wsID, comm1.CommissionID)
	if c1.Status != CommissionPaidOut || *c1.PayoutID != payout.PayoutID {
		t.Fatalf("expected commission 1 paid out with payout reference")
	}
}

// ----------------------------------------------------------------------------
// Clawback & Reversals Flow
// ----------------------------------------------------------------------------

func TestCommissionClawbackFlow(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	svc := NewService(store, nil, sink, nil)
	wsID := "019086a1-7c3e-7000-8000-000000000010"

	comm := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-refund-001",
		CommissionAmount: mustDecimal(t, "100000.000000"),
		Currency:         "VND",
		Status:           CommissionPending,
	}
	_ = store.CreateCommission(ctx, comm)

	// Clawback entire amount due to customer return
	clawed, err := svc.ClawbackCommission(ctx, wsID, comm.CommissionID, "refund", "100000.000000")
	if err != nil {
		t.Fatalf("failed to clawback commission: %v", err)
	}
	if clawed.Status != CommissionClawedBack {
		t.Fatalf("expected status clawed_back, got %s", clawed.Status)
	}
	if clawed.ClawbackReason != "refund" {
		t.Fatalf("expected reason refund, got %s", clawed.ClawbackReason)
	}

	// Cannot confirm or clawback again
	_, err = svc.ConfirmCommission(ctx, wsID, comm.CommissionID)
	if err != ErrCommissionAlreadyConfirmed {
		t.Fatalf("expected ErrCommissionAlreadyConfirmed on clawed back commission, got %v", err)
	}
}

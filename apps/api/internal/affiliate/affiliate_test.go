package affiliate

import (
	"context"
	"errors"
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
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-101",
		WorkspaceID:    wsID,
		GrossAmount:    orderAmount,
		RefundedAmount: tenantdb.ZeroDecimal(),
		Currency:       "VND",
		LifecycleState: "completed",
	}); err != nil {
		t.Fatalf("failed to register verified order: %v", err)
	}
	comm, err := svc.CalculateCommission(ctx, wsID, link.AffiliateLinkID, "ord-101", nil, orderAmount, "VND", 15)
	if err != nil {
		t.Fatalf("failed to calculate commission: %v", err)
	}
	expectedComm := mustDecimal(t, "100000.000000")
	if comm.CommissionAmount.Cmp(expectedComm) != 0 {
		t.Fatalf("expected commission 100,000 VND, got %s", comm.CommissionAmount.String())
	}

	// 3. Confirm commission: must fail before 15-day hold window elapses, then succeed after
	if _, err := svc.ConfirmCommission(ctx, wsID, comm.CommissionID); !errors.Is(err, ErrCommissionHoldPeriodActive) {
		t.Fatalf("expected ErrCommissionHoldPeriodActive before hold period elapses, got %v", err)
	}
	now = now.Add(16 * 24 * time.Hour)
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
	if err := svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       settlementID,
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorID,
		NetAmount:          expectedTotal,
		Currency:           "VND",
		VerificationStatus: "verified",
	}); err != nil {
		t.Fatalf("failed to register verified settlement: %v", err)
	}
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

// AFF-01: Payout batches must reject duplicate commission IDs, commissions already assigned to
// another payout batch, creator/currency mismatches, clawed-back commissions, and unverified settlements.
func TestPayoutBatchCommissionDedupHoldPeriodAndSettlementVerification(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	creatorA := newUUID()
	creatorB := newUUID()

	commA := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-aff01-1",
		CreatorEntityID:  &creatorA,
		CommissionAmount: mustDecimal(t, "250000.000000"),
		Currency:         "VND",
		Status:           CommissionConfirmed,
		HoldUntil:        now.Add(-24 * time.Hour),
	}
	_ = store.CreateCommission(ctx, commA)

	commB := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-aff01-2",
		CreatorEntityID:  &creatorB,
		CommissionAmount: mustDecimal(t, "150000.000000"),
		Currency:         "VND",
		Status:           CommissionConfirmed,
		HoldUntil:        now.Add(-24 * time.Hour),
	}
	_ = store.CreateCommission(ctx, commB)

	// 1. Duplicate commission IDs in the same request must fail
	if _, err := svc.CreatePayoutBatch(ctx, wsID, creatorA, []string{commA.CommissionID, commA.CommissionID}); !errors.Is(err, ErrInvalidPayoutBatch) {
		t.Fatalf("expected ErrInvalidPayoutBatch on duplicate commission IDs, got %v", err)
	}

	// 2. Commission belonging to another creator must fail
	if _, err := svc.CreatePayoutBatch(ctx, wsID, creatorA, []string{commB.CommissionID}); !errors.Is(err, ErrInvalidPayoutBatch) {
		t.Fatalf("expected ErrInvalidPayoutBatch on creator mismatch, got %v", err)
	}

	// 3. Valid payout batch binds commA so a second batch cannot reuse commA
	batch1, err := svc.CreatePayoutBatch(ctx, wsID, creatorA, []string{commA.CommissionID})
	if err != nil {
		t.Fatalf("CreatePayoutBatch failed: %v", err)
	}
	if _, err := svc.CreatePayoutBatch(ctx, wsID, creatorA, []string{commA.CommissionID}); !errors.Is(err, ErrCommissionAlreadyInPayout) {
		t.Fatalf("expected ErrCommissionAlreadyInPayout when reusing commission in second batch, got %v", err)
	}

	// 4. ExecutePayoutBatch without verified settlement ID must fail closed
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, ""); !errors.Is(err, ErrSettlementRequired) {
		t.Fatalf("expected ErrSettlementRequired when settlementID is empty, got %v", err)
	}
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle_unverified_01"); !errors.Is(err, ErrSettlementRequired) {
		t.Fatalf("expected ErrSettlementRequired on unverified settlement ID, got %v", err)
	}

	// 5. If a commission in a pending batch is clawed back before execution, ExecutePayoutBatch must fail
	batchB, err := svc.CreatePayoutBatch(ctx, wsID, creatorB, []string{commB.CommissionID})
	if err != nil {
		t.Fatalf("CreatePayoutBatch for creatorB failed: %v", err)
	}
	if err := svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-verified-b",
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorB,
		NetAmount:          mustDecimal(t, "150000.000000"),
		Currency:           "VND",
		VerificationStatus: "verified",
	}); err != nil {
		t.Fatalf("RegisterVerifiedSettlement b: %v", err)
	}
	if _, err := svc.ClawbackCommission(ctx, wsID, commB.CommissionID, "order_refunded", "150000.000000"); err != nil {
		t.Fatalf("ClawbackCommission failed: %v", err)
	}
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batchB.PayoutID, "settle-verified-b"); !errors.Is(err, ErrInvalidPayoutBatch) {
		t.Fatalf("expected ErrInvalidPayoutBatch when executing payout with clawed-back commission, got %v", err)
	}

	// 6. ExecutePayoutBatch on valid batch1 with verified settlement succeeds
	if err := svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-verified-a",
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorA,
		NetAmount:          mustDecimal(t, "250000.000000"),
		Currency:           "VND",
		VerificationStatus: "verified",
	}); err != nil {
		t.Fatalf("RegisterVerifiedSettlement a: %v", err)
	}
	execBatch1, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle-verified-a")
	if err != nil || execBatch1.Status != PayoutCompleted {
		t.Fatalf("expected PayoutCompleted for batch1, got status=%v err=%v", execBatch1, err)
	}
}

func TestF16_UnverifiedOrderAndReplayCommissionRejected(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	otherWS := "019086a1-7c3e-7000-8000-000000000099"
	prodID := newUUID()

	linkA, err := svc.CreateLink(ctx, &AffiliateLink{
		WorkspaceID:    wsID,
		ProductID:      &prodID,
		Platform:       "shopee",
		OriginalURL:    "https://shopee.vn/product/f16-a",
		CommissionRate: mustDecimal(t, "10.00"),
	})
	if err != nil {
		t.Fatalf("CreateLink A: %v", err)
	}
	linkB, err := svc.CreateLink(ctx, &AffiliateLink{
		WorkspaceID:    wsID,
		ProductID:      &prodID,
		Platform:       "shopee",
		OriginalURL:    "https://shopee.vn/product/f16-b",
		CommissionRate: mustDecimal(t, "15.00"),
	})
	if err != nil {
		t.Fatalf("CreateLink B: %v", err)
	}

	// 1. Unverified / non-existent order must fail closed
	if _, err := svc.CalculateCommission(ctx, wsID, linkA.AffiliateLinkID, "ord-fabricated-999", nil, mustDecimal(t, "9999999.000000"), "VND", 15); !errors.Is(err, ErrOrderNotVerified) {
		t.Fatalf("expected ErrOrderNotVerified for non-existent order, got %v", err)
	}

	// 2. Order belonging to another tenant (otherWS) must fail closed when queried from wsID
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-other-tenant",
		WorkspaceID:    otherWS,
		GrossAmount:    mustDecimal(t, "1000000.000000"),
		Currency:       "VND",
		LifecycleState: "completed",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder otherWS: %v", err)
	}
	if _, err := svc.CalculateCommission(ctx, wsID, linkA.AffiliateLinkID, "ord-other-tenant", nil, mustDecimal(t, "1000000.000000"), "VND", 15); !errors.Is(err, ErrOrderNotVerified) {
		t.Fatalf("expected ErrOrderNotVerified for cross-tenant order, got %v", err)
	}

	// 3. Unpaid order ("unpaid" / "pending_payment" / "created") must fail closed
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-unpaid",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "500000.000000"),
		Currency:       "VND",
		LifecycleState: "unpaid",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder unpaid: %v", err)
	}
	if _, err := svc.CalculateCommission(ctx, wsID, linkA.AffiliateLinkID, "ord-unpaid", nil, mustDecimal(t, "500000.000000"), "VND", 15); !errors.Is(err, ErrOrderIneligible) {
		t.Fatalf("expected ErrOrderIneligible for unpaid order, got %v", err)
	}

	// 4. Fully refunded or cancelled order must fail closed
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-refunded",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "500000.000000"),
		RefundedAmount: mustDecimal(t, "500000.000000"),
		Currency:       "VND",
		LifecycleState: "refunded",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder refunded: %v", err)
	}
	if _, err := svc.CalculateCommission(ctx, wsID, linkA.AffiliateLinkID, "ord-refunded", nil, mustDecimal(t, "500000.000000"), "VND", 15); !errors.Is(err, ErrOrderIneligible) {
		t.Fatalf("expected ErrOrderIneligible for refunded order, got %v", err)
	}

	// 5. Partially refunded order (1,000,000 gross - 300,000 refunded = 700,000 eligible):
	//    - Forged/inflated client amount (1,000,000 or 5,000,000) must fail closed with ErrOrderAmountMismatch
	//    - Wrong currency (USD instead of VND) must fail closed with ErrOrderCurrencyMismatch
	//    - Valid call computes 10% of 700,000 = 70,000 VND
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-partial-ref",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "1000000.000000"),
		RefundedAmount: mustDecimal(t, "300000.000000"),
		Currency:       "VND",
		LifecycleState: "partially_refunded",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder partial: %v", err)
	}
	if _, err := svc.CalculateCommission(ctx, wsID, linkA.AffiliateLinkID, "ord-partial-ref", nil, mustDecimal(t, "1000000.000000"), "VND", 15); !errors.Is(err, ErrOrderAmountMismatch) {
		t.Fatalf("expected ErrOrderAmountMismatch when claiming full gross amount on partially refunded order, got %v", err)
	}
	if _, err := svc.CalculateCommission(ctx, wsID, linkA.AffiliateLinkID, "ord-partial-ref", nil, mustDecimal(t, "700000.000000"), "USD", 15); !errors.Is(err, ErrOrderCurrencyMismatch) {
		t.Fatalf("expected ErrOrderCurrencyMismatch on wrong currency, got %v", err)
	}

	// 6. Concurrent replay on the same order/link must produce a single unique commission
	const workers = 10
	var wg sync.WaitGroup
	results := make([]*AffiliateCommission, workers)
	errs := make([]error, workers)
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			results[idx], errs[idx] = svc.CalculateCommission(ctx, wsID, linkA.AffiliateLinkID, "ord-partial-ref", nil, mustDecimal(t, "700000.000000"), "VND", 15)
		}(i)
	}
	wg.Wait()

	var firstID string
	for i := 0; i < workers; i++ {
		if errs[i] != nil {
			t.Fatalf("worker %d unexpected error: %v", i, errs[i])
		}
		if results[i].CommissionAmount.Cmp(mustDecimal(t, "70000.000000")) != 0 {
			t.Fatalf("worker %d expected commission 70,000, got %s", i, results[i].CommissionAmount.String())
		}
		if firstID == "" {
			firstID = results[i].CommissionID
		} else if results[i].CommissionID != firstID {
			t.Fatalf("duplicate CommissionID created on replay: %s vs %s", firstID, results[i].CommissionID)
		}
	}

	allComms, err := store.ListCommissions(ctx, wsID, nil, nil, 100, 0)
	if err != nil || len(allComms) != 1 {
		t.Fatalf("expected exactly 1 commission in store after 10 replays, got %d (err=%v)", len(allComms), err)
	}

	// 7. Attempting to calculate a second commission for the same order under a different link must fail closed
	if _, err := svc.CalculateCommission(ctx, wsID, linkB.AffiliateLinkID, "ord-partial-ref", nil, mustDecimal(t, "700000.000000"), "VND", 15); !errors.Is(err, ErrDuplicateCommission) {
		t.Fatalf("expected ErrDuplicateCommission when another link claims same order, got %v", err)
	}
}

func TestF17_FabricatedSettlementReferenceRejected(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	otherWS := "019086a1-7c3e-7000-8000-000000000099"
	creatorA := newUUID()
	creatorB := newUUID()

	comm1 := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-f17-1",
		CreatorEntityID:  &creatorA,
		CommissionAmount: mustDecimal(t, "100000.000000"),
		Currency:         "VND",
		Status:           CommissionConfirmed,
		HoldUntil:        now.Add(-24 * time.Hour),
	}
	comm2 := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-f17-2",
		CreatorEntityID:  &creatorA,
		CommissionAmount: mustDecimal(t, "100000.000000"),
		Currency:         "VND",
		Status:           CommissionConfirmed,
		HoldUntil:        now.Add(-24 * time.Hour),
	}
	_ = store.CreateCommission(ctx, comm1)
	_ = store.CreateCommission(ctx, comm2)

	batch1, err := svc.CreatePayoutBatch(ctx, wsID, creatorA, []string{comm1.CommissionID})
	if err != nil {
		t.Fatalf("CreatePayoutBatch 1: %v", err)
	}
	batch2, err := svc.CreatePayoutBatch(ctx, wsID, creatorA, []string{comm2.CommissionID})
	if err != nil {
		t.Fatalf("CreatePayoutBatch 2: %v", err)
	}

	// 1. Fabricated settlement reference not in store must fail closed
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle-fake-123"); !errors.Is(err, ErrSettlementRequired) {
		t.Fatalf("expected ErrSettlementRequired for fabricated settlement_id, got %v", err)
	}

	// 2. Settlement from another tenant must fail closed
	_ = svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-other-ws",
		WorkspaceID:        otherWS,
		CreatorEntityID:    creatorA,
		NetAmount:          mustDecimal(t, "100000.000000"),
		Currency:           "VND",
		VerificationStatus: "verified",
	})
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle-other-ws"); !errors.Is(err, ErrSettlementRequired) {
		t.Fatalf("expected ErrSettlementRequired for cross-tenant settlement, got %v", err)
	}

	// 3. Settlement with unverified status ("imported_only") must fail closed
	_ = svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-imported-only",
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorA,
		NetAmount:          mustDecimal(t, "100000.000000"),
		Currency:           "VND",
		VerificationStatus: "imported_only",
	})
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle-imported-only"); !errors.Is(err, ErrSettlementRequired) {
		t.Fatalf("expected ErrSettlementRequired for unverified settlement status, got %v", err)
	}

	// 4. Settlement for wrong beneficiary must fail closed
	_ = svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-wrong-creator",
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorB,
		NetAmount:          mustDecimal(t, "100000.000000"),
		Currency:           "VND",
		VerificationStatus: "verified",
	})
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle-wrong-creator"); !errors.Is(err, ErrSettlementBeneficiaryMismatch) {
		t.Fatalf("expected ErrSettlementBeneficiaryMismatch for wrong creator, got %v", err)
	}

	// 5. Settlement with wrong currency must fail closed
	_ = svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-wrong-currency",
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorA,
		NetAmount:          mustDecimal(t, "100000.000000"),
		Currency:           "USD",
		VerificationStatus: "verified",
	})
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle-wrong-currency"); !errors.Is(err, ErrSettlementCurrencyMismatch) {
		t.Fatalf("expected ErrSettlementCurrencyMismatch for wrong currency, got %v", err)
	}

	// 6. Settlement with wrong amount must fail closed
	_ = svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-wrong-amount",
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorA,
		NetAmount:          mustDecimal(t, "50000.000000"),
		Currency:           "VND",
		VerificationStatus: "verified",
	})
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle-wrong-amount"); !errors.Is(err, ErrSettlementAmountMismatch) {
		t.Fatalf("expected ErrSettlementAmountMismatch for wrong amount, got %v", err)
	}

	// 7. Valid verified settlement succeeds for batch1, and reusing the same settlement for batch2 fails closed!
	_ = svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-valid-100k",
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorA,
		NetAmount:          mustDecimal(t, "100000.000000"),
		Currency:           "VND",
		VerificationStatus: "verified",
	})
	exec1, err := svc.ExecutePayoutBatch(ctx, wsID, batch1.PayoutID, "settle-valid-100k")
	if err != nil || exec1.Status != PayoutCompleted {
		t.Fatalf("expected batch1 execution to succeed, got %v, err=%v", exec1, err)
	}
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch2.PayoutID, "settle-valid-100k"); !errors.Is(err, ErrSettlementAlreadyUsed) {
		t.Fatalf("expected ErrSettlementAlreadyUsed when reusing settlement across payout batches, got %v", err)
	}
}

// Billing R08: Affiliate commission must NOT remain eligible for confirmation or payout after
// the source order is refunded (fully or partially), and ledger postings must be reversible and immutable.
func TestR08_RefundedOrderExcludedFromConfirmAndPayoutWithReversibleLedger(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	ledger := NewDefaultLedgerRecorder()
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, ledger, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	creatorID := "creator-r08-01"
	prodID := newUUID()

	link, err := svc.CreateLink(ctx, &AffiliateLink{
		WorkspaceID:    wsID,
		ProductID:      &prodID,
		Platform:       "tiktok",
		OriginalURL:    "https://shop.tiktok.com/product/r08",
		CommissionRate: mustDecimal(t, "10.00"),
	})
	if err != nil {
		t.Fatalf("CreateLink: %v", err)
	}

	// -------------------------------------------------------------------------
	// Case 1: Order completed -> CalculateCommission -> Full Refund before ConfirmCommission
	// -------------------------------------------------------------------------
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-r08-full-before-confirm",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "1000000.000000"),
		RefundedAmount: tenantdb.ZeroDecimal(),
		Currency:       "VND",
		LifecycleState: "completed",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder 1: %v", err)
	}
	comm1, err := svc.CalculateCommission(ctx, wsID, link.AffiliateLinkID, "ord-r08-full-before-confirm", &creatorID, mustDecimal(t, "1000000.000000"), "VND", 15)
	if err != nil {
		t.Fatalf("CalculateCommission 1: %v", err)
	}
	// Source order is fully refunded during hold period
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-r08-full-before-confirm",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "1000000.000000"),
		RefundedAmount: mustDecimal(t, "1000000.000000"),
		Currency:       "VND",
		LifecycleState: "refunded",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder 1 refund: %v", err)
	}
	now = now.Add(16 * 24 * time.Hour)
	if _, err := svc.ConfirmCommission(ctx, wsID, comm1.CommissionID); !errors.Is(err, ErrOrderIneligible) {
		t.Fatalf("R08 violation: expected ErrOrderIneligible when confirming commission for refunded order, got %v", err)
	}
	comm1After, _ := store.GetCommission(ctx, wsID, comm1.CommissionID)
	if comm1After.Status != CommissionClawedBack {
		t.Fatalf("R08 violation: expected comm1 status clawed_back after full order refund, got %s", comm1After.Status)
	}

	// -------------------------------------------------------------------------
	// Case 2: Order completed -> Calculate -> Confirm -> PostToLedger -> Full Refund before Payout
	// -------------------------------------------------------------------------
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-r08-full-after-confirm",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "500000.000000"),
		RefundedAmount: tenantdb.ZeroDecimal(),
		Currency:       "VND",
		LifecycleState: "completed",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder 2: %v", err)
	}
	comm2, err := svc.CalculateCommission(ctx, wsID, link.AffiliateLinkID, "ord-r08-full-after-confirm", &creatorID, mustDecimal(t, "500000.000000"), "VND", 15)
	if err != nil {
		t.Fatalf("CalculateCommission 2: %v", err)
	}
	now = now.Add(16 * 24 * time.Hour)
	if _, err := svc.ConfirmCommission(ctx, wsID, comm2.CommissionID); err != nil {
		t.Fatalf("ConfirmCommission 2: %v", err)
	}
	if _, err := svc.PostCommissionToLedger(ctx, wsID, comm2.CommissionID, EconomicRoleCreator); err != nil {
		t.Fatalf("PostCommissionToLedger 2: %v", err)
	}
	batch2, err := svc.CreatePayoutBatch(ctx, wsID, creatorID, []string{comm2.CommissionID})
	if err != nil {
		t.Fatalf("CreatePayoutBatch 2: %v", err)
	}
	// Source order is fully refunded after batch creation, before ExecutePayoutBatch!
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-r08-full-after-confirm",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "500000.000000"),
		RefundedAmount: mustDecimal(t, "500000.000000"),
		Currency:       "VND",
		LifecycleState: "refunded",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder 2 refund: %v", err)
	}
	_ = svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       "settle-r08-2",
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorID,
		NetAmount:          mustDecimal(t, "50000.000000"),
		Currency:           "VND",
		VerificationStatus: "verified",
	})
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch2.PayoutID, "settle-r08-2"); !errors.Is(err, ErrInvalidPayoutBatch) && !errors.Is(err, ErrOrderIneligible) {
		t.Fatalf("R08 violation: expected ExecutePayoutBatch to reject batch when source order was refunded, got %v", err)
	}
	// Verify immutable ledger recorded original posting and reversal with net balance 0
	entries2 := svc.ListLedgerPostings(wsID, comm2.CommissionID)
	if len(entries2) != 2 || entries2[1].ReversalOf == nil || *entries2[1].ReversalOf != entries2[0].PostingID {
		t.Fatalf("R08 violation: expected immutable original + reversal ledger entries for comm2, got %+v", entries2)
	}
	net2, _ := entries2[0].Amount.Add(entries2[1].Amount)
	if !net2.IsZero() {
		t.Fatalf("R08 violation: expected net ledger amount 0 after full refund, got %s", net2.String())
	}
	// Settlement must remain unallocated after rejected payout execution
	settle2, _ := store.GetVerifiedSettlement(ctx, wsID, "settle-r08-2")
	if !settle2.AllocatedAmount.IsZero() {
		t.Fatalf("expected settlement AllocatedAmount=0 after rejected payout, got %s", settle2.AllocatedAmount.String())
	}

	// -------------------------------------------------------------------------
	// Case 3: Partial Refund before Confirm / Payout reduces commission proportionally
	// -------------------------------------------------------------------------
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-r08-partial",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "1000000.000000"),
		RefundedAmount: tenantdb.ZeroDecimal(),
		Currency:       "VND",
		LifecycleState: "completed",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder 3: %v", err)
	}
	comm3, err := svc.CalculateCommission(ctx, wsID, link.AffiliateLinkID, "ord-r08-partial", &creatorID, mustDecimal(t, "1000000.000000"), "VND", 15)
	if err != nil {
		t.Fatalf("CalculateCommission 3: %v", err)
	}
	// Initial commission = 10% of 1,000,000 = 100,000
	if comm3.CommissionAmount.Cmp(mustDecimal(t, "100000.000000")) != 0 {
		t.Fatalf("expected initial commission 100000, got %s", comm3.CommissionAmount.String())
	}
	// Partial refund of 400,000 -> net eligible order amount is 600,000 -> commission must become 60,000 (clawback 40,000)
	if err := svc.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        "ord-r08-partial",
		WorkspaceID:    wsID,
		GrossAmount:    mustDecimal(t, "1000000.000000"),
		RefundedAmount: mustDecimal(t, "400000.000000"),
		Currency:       "VND",
		LifecycleState: "partially_refunded",
	}); err != nil {
		t.Fatalf("RegisterVerifiedOrder 3 partial refund: %v", err)
	}
	now = now.Add(16 * 24 * time.Hour)
	confirmed3, err := svc.ConfirmCommission(ctx, wsID, comm3.CommissionID)
	if err != nil {
		t.Fatalf("ConfirmCommission 3 after partial refund: %v", err)
	}
	if confirmed3.CommissionAmount.Cmp(mustDecimal(t, "60000.000000")) != 0 {
		t.Fatalf("R08 violation: expected confirmed commission reduced to 60000 after 40%% partial refund, got %s", confirmed3.CommissionAmount.String())
	}
	if confirmed3.ClawbackAmount == nil || confirmed3.ClawbackAmount.Cmp(mustDecimal(t, "40000.000000")) != 0 {
		t.Fatalf("R08 violation: expected clawback_amount=40000 on partial refund, got %v", confirmed3.ClawbackAmount)
	}
	batch3, err := svc.CreatePayoutBatch(ctx, wsID, creatorID, []string{confirmed3.CommissionID})
	if err != nil {
		t.Fatalf("CreatePayoutBatch 3: %v", err)
	}
	if batch3.TotalAmount.Cmp(mustDecimal(t, "60000.000000")) != 0 {
		t.Fatalf("expected payout batch total 60000, got %s", batch3.TotalAmount.String())
	}
}

// failingAffiliateStore injects transient errors during ExecutePayoutBatch to test Billing R10.
type failingAffiliateStore struct {
	Store
	failUpdateCommCount int
	updateCommCalls     int
	failUpdatePayout    bool
}

func (f *failingAffiliateStore) UpdateCommission(ctx context.Context, comm *AffiliateCommission) error {
	f.updateCommCalls++
	if f.failUpdateCommCount > 0 && f.updateCommCalls == f.failUpdateCommCount {
		return errors.New("simulated transient DB failure during UpdateCommission")
	}
	return f.Store.UpdateCommission(ctx, comm)
}

func (f *failingAffiliateStore) UpdatePayout(ctx context.Context, payout *AffiliatePayout) error {
	if f.failUpdatePayout && payout.Status == PayoutCompleted {
		return errors.New("simulated transient DB failure during final UpdatePayout")
	}
	return f.Store.UpdatePayout(ctx, payout)
}

// Billing R10: If ExecutePayoutBatch fails after settlement allocation or mid-way through
// updating commissions/payout, retrying ExecutePayoutBatch with the same (payoutID, settlementID)
// must resume idempotently and complete once without failing on remainingSettle or commission status.
func TestR10_ExecutePayoutBatchMidwayFailureIsRetryableIdempotently(t *testing.T) {
	ctx := context.Background()
	baseStore := NewMemoryStore()
	fStore := &failingAffiliateStore{Store: baseStore}
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(fStore, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	creatorID := "creator-r10-01"

	comm1 := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-r10-1",
		CreatorEntityID:  &creatorID,
		CommissionAmount: mustDecimal(t, "150000.000000"),
		Currency:         "VND",
		Status:           CommissionConfirmed,
		HoldUntil:        now.Add(-24 * time.Hour),
	}
	comm2 := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  newUUID(),
		OrderID:          "ord-r10-2",
		CreatorEntityID:  &creatorID,
		CommissionAmount: mustDecimal(t, "250000.000000"),
		Currency:         "VND",
		Status:           CommissionConfirmed,
		HoldUntil:        now.Add(-24 * time.Hour),
	}
	_ = baseStore.CreateCommission(ctx, comm1)
	_ = baseStore.CreateCommission(ctx, comm2)

	batch, err := svc.CreatePayoutBatch(ctx, wsID, creatorID, []string{comm1.CommissionID, comm2.CommissionID})
	if err != nil {
		t.Fatalf("CreatePayoutBatch failed: %v", err)
	}

	settlementID := "settle-r10-400k"
	if err := svc.RegisterVerifiedSettlement(ctx, &VerifiedSettlement{
		SettlementID:       settlementID,
		WorkspaceID:        wsID,
		CreatorEntityID:    creatorID,
		NetAmount:          mustDecimal(t, "400000.000000"),
		Currency:           "VND",
		VerificationStatus: "verified",
	}); err != nil {
		t.Fatalf("RegisterVerifiedSettlement failed: %v", err)
	}

	// 1. Fail on the 2nd commission update inside ExecutePayoutBatch (after settlement is allocated and comm1 is paid_out)
	fStore.updateCommCalls = 0
	fStore.failUpdateCommCount = 2
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch.PayoutID, settlementID); err == nil {
		t.Fatalf("expected ExecutePayoutBatch to fail when 2nd UpdateCommission fails")
	}

	// 2. Retry ExecutePayoutBatch with final UpdatePayout failing
	fStore.failUpdateCommCount = 0
	fStore.failUpdatePayout = true
	if _, err := svc.ExecutePayoutBatch(ctx, wsID, batch.PayoutID, settlementID); err == nil {
		t.Fatalf("expected ExecutePayoutBatch to fail when final UpdatePayout fails")
	}

	// 3. Retry ExecutePayoutBatch with healthy store -> MUST succeed idempotently!
	fStore.failUpdatePayout = false
	executed, err := svc.ExecutePayoutBatch(ctx, wsID, batch.PayoutID, settlementID)
	if err != nil {
		t.Fatalf("R10 violation: retry of ExecutePayoutBatch after partial failure failed: %v", err)
	}
	if executed.Status != PayoutCompleted {
		t.Fatalf("expected PayoutCompleted after retry, got %s", executed.Status)
	}

	settleAfter, err := baseStore.GetVerifiedSettlement(ctx, wsID, settlementID)
	if err != nil {
		t.Fatalf("GetVerifiedSettlement failed: %v", err)
	}
	if settleAfter.AllocatedAmount.Cmp(mustDecimal(t, "400000.000000")) != 0 {
		t.Fatalf("expected settlement AllocatedAmount=400000 (allocated once), got %s", settleAfter.AllocatedAmount.String())
	}
}

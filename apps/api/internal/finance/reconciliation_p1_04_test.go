package finance_test

import (
	"context"
	"crypto/sha512"
	"encoding/hex"
	"errors"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	financev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/home"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Target 1: Concurrent partial match cannot overallocate (§4 partial match capacity & RULE-M19-007)
func TestConcurrentPartialMatchCannotOverallocate(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, func() time.Time { return time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC) })

	wsID := "ws-test-capacity"
	settlementID := "sment-01"
	lineID := "line-cap-01"
	orderID := "order-cap-01"

	// Create settlement line with net amount 1,000,000 VND
	lineNet := tenantdb.MustParseExactDecimal("1000000.000000")
	line := &finance.SettlementLine{
		LineID:              lineID,
		WorkspaceID:         wsID,
		SettlementID:        settlementID,
		NetAmount:           lineNet,
		MatchedAmount:       tenantdb.ZeroDecimal(),
		Currency:            "VND",
		ReconciliationState: finance.ReconciliationImportedOnly,
		CreatedAt:           time.Now().UTC(),
	}
	if err := store.CreateSettlementLine(ctx, line); err != nil {
		t.Fatalf("failed to create settlement line: %v", err)
	}

	// Create order with amount 1,000,000 VND
	orderAmt := tenantdb.MustParseExactDecimal("1000000.000000")
	order := &finance.Order{
		OrderID:             orderID,
		WorkspaceID:         wsID,
		Amount:              orderAmt,
		MatchedAmount:       tenantdb.ZeroDecimal(),
		Currency:            "VND",
		LifecycleState:      "completed",
		ReconciliationState: finance.ReconciliationImportedOnly,
		OrderedAt:           time.Now().UTC(),
	}
	if err := store.CreateOrder(ctx, order); err != nil {
		t.Fatalf("failed to create order: %v", err)
	}

	// Queue 20 concurrent goroutines, each attempting to allocate 100,000 VND.
	// Capacity is 1,000,000 VND total.
	// Exactly 10 allocations must succeed. Exactly 10 must fail with ErrCapacityExceeded or ErrOrderCapacityExceeded.
	concurrency := 20
	allocAmount := tenantdb.MustParseExactDecimal("100000.000000")

	var successCount int64
	var failureCount int64
	var wg sync.WaitGroup

	startSignal := make(chan struct{})

	for i := 0; i < concurrency; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-startSignal

			_, _, _, err := svc.Match(ctx, wsID, settlementID, lineID, orderID, "", allocAmount)
			if err == nil {
				atomic.AddInt64(&successCount, 1)
			} else {
				if errors.Is(err, finance.ErrCapacityExceeded) || errors.Is(err, finance.ErrOrderCapacityExceeded) {
					atomic.AddInt64(&failureCount, 1)
				} else {
					t.Errorf("unexpected error on match: %v", err)
				}
			}
		}()
	}

	// Release all goroutines simultaneously
	close(startSignal)
	wg.Wait()

	if successCount != 10 {
		t.Fatalf("expected exactly 10 successful allocations, got %d", successCount)
	}
	if failureCount != 10 {
		t.Fatalf("expected exactly 10 rejected allocations, got %d", failureCount)
	}

	// Verify line matched amount in store is exactly 1,000,000 VND
	updatedLine, err := store.GetSettlementLine(ctx, wsID, settlementID, lineID)
	if err != nil {
		t.Fatalf("failed to get line: %v", err)
	}
	if updatedLine.MatchedAmount.Cmp(lineNet) != 0 {
		t.Fatalf("line matched amount = %s, expected %s", updatedLine.MatchedAmount.String(), lineNet.String())
	}
	if updatedLine.ReconciliationState != finance.ReconciliationFullyReconciled {
		t.Errorf("line state = %s, expected fully_reconciled", updatedLine.ReconciliationState)
	}

	// Verify order matched amount in store is exactly 1,000,000 VND
	updatedOrder, err := store.GetOrder(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("failed to get order: %v", err)
	}
	if updatedOrder.MatchedAmount.Cmp(orderAmt) != 0 {
		t.Fatalf("order matched amount = %s, expected %s", updatedOrder.MatchedAmount.String(), orderAmt.String())
	}
	if updatedOrder.ReconciliationState != finance.ReconciliationFullyReconciled {
		t.Errorf("order state = %s, expected fully_reconciled", updatedOrder.ReconciliationState)
	}

	// A further allocation must be denied
	_, _, _, err = svc.Match(ctx, wsID, settlementID, lineID, orderID, "", tenantdb.MustParseExactDecimal("1.000000"))
	if !errors.Is(err, finance.ErrCapacityExceeded) && !errors.Is(err, finance.ErrOrderCapacityExceeded) {
		t.Fatalf("expected capacity error on full order/line, got %v", err)
	}
}

// Target 1B: Asymmetric capacity check - Order smaller than line
func TestAsymmetricMatchCapacity(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, func() time.Time { return time.Now().UTC() })

	wsID := "ws-asym"
	settlementID := "sment-asym"
	lineID := "line-asym"
	orderID := "order-asym"

	// Line has 1,000,000 VND
	_ = store.CreateSettlementLine(ctx, &finance.SettlementLine{
		LineID:        lineID,
		WorkspaceID:   wsID,
		SettlementID:  settlementID,
		NetAmount:     tenantdb.MustParseExactDecimal("1000000.000000"),
		MatchedAmount: tenantdb.ZeroDecimal(),
		Currency:      "VND",
	})

	// Order has only 300,000 VND
	_ = store.CreateOrder(ctx, &finance.Order{
		OrderID:       orderID,
		WorkspaceID:   wsID,
		Amount:        tenantdb.MustParseExactDecimal("300000.000000"),
		MatchedAmount: tenantdb.ZeroDecimal(),
		Currency:      "VND",
	})

	// Allocating 400,000 should fail because of order capacity even though line has capacity
	_, _, _, err := svc.Match(ctx, wsID, settlementID, lineID, orderID, "", tenantdb.MustParseExactDecimal("400000.000000"))
	if !errors.Is(err, finance.ErrOrderCapacityExceeded) {
		t.Fatalf("expected ErrOrderCapacityExceeded, got %v", err)
	}

	// Allocating 300,000 should succeed
	l, o, m, err := svc.Match(ctx, wsID, settlementID, lineID, orderID, "", tenantdb.MustParseExactDecimal("300000.000000"))
	if err != nil {
		t.Fatalf("expected match to succeed, got %v", err)
	}
	if o.ReconciliationState != finance.ReconciliationFullyReconciled {
		t.Errorf("order state = %s, expected fully_reconciled", o.ReconciliationState)
	}
	if l.ReconciliationState != finance.ReconciliationPartiallyReconciled {
		t.Errorf("line state = %s, expected partially_reconciled", l.ReconciliationState)
	}
	if m.AllocatedAmount.String() != "300000" {
		t.Errorf("allocated amount = %s, expected 300000", m.AllocatedAmount.String())
	}
}

// Target 2: Evidence modification denied (RULE-M19-005 & Immutability Trigger)
func TestEvidenceModificationDenied(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, func() time.Time { return time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC) })

	wsID := "ws-ev-test"
	rawScreenshot := []byte("fake screenshot bytes of tiktok settlement report")
	hashArr := sha512.Sum512(rawScreenshot)
	expectedHash := hex.EncodeToString(hashArr[:])

	ev := &finance.EvidenceObject{
		EvidenceID:       "ev-01",
		WorkspaceID:      wsID,
		EvidenceType:     "screenshot",
		SourceProvenance: "tiktok_shop_settlement_tab",
		FileURL:          "https://storage.creativanta.vn/ev/ev-01.png",
		PayloadJSON:      `{"period": "2026-10"}`,
	}

	// 1. Submit with raw content: auto-computes SHA-512
	submitted, err := svc.SubmitEvidence(ctx, ev, rawScreenshot)
	if err != nil {
		t.Fatalf("failed to submit evidence: %v", err)
	}
	if submitted.ContentHash != expectedHash {
		t.Fatalf("expected hash %s, got %s", expectedHash, submitted.ContentHash)
	}
	if submitted.VerificationStatus != finance.VerificationStatusPending {
		t.Errorf("status = %s, expected pending", submitted.VerificationStatus)
	}

	// 2. Submit with mismatched raw content and hash: must be rejected!
	badEv := &finance.EvidenceObject{
		EvidenceID:   "ev-bad",
		WorkspaceID:  wsID,
		EvidenceType: "screenshot",
		ContentHash:  "deadbeef1234",
	}
	_, err = svc.SubmitEvidence(ctx, badEv, []byte("mismatched content"))
	if err == nil {
		t.Fatal("expected error for mismatched content hash, got nil")
	}

	// 3. Attempt to mutate immutable fields: must be denied with ErrEvidenceImmutable!
	// Test modifying content_hash:
	mutatedHash := *submitted
	mutatedHash.ContentHash = "tampered-hash-value"
	if err := store.UpdateEvidence(ctx, &mutatedHash); !errors.Is(err, finance.ErrEvidenceImmutable) {
		t.Fatalf("expected ErrEvidenceImmutable for content_hash tampering, got %v", err)
	}

	// Test modifying file_url:
	mutatedURL := *submitted
	mutatedURL.FileURL = "https://evil.com/replaced.png"
	if err := store.UpdateEvidence(ctx, &mutatedURL); !errors.Is(err, finance.ErrEvidenceImmutable) {
		t.Fatalf("expected ErrEvidenceImmutable for file_url change, got %v", err)
	}

	// Test modifying payload_json:
	mutatedPayload := *submitted
	mutatedPayload.PayloadJSON = `{"tampered": true}`
	if err := store.UpdateEvidence(ctx, &mutatedPayload); !errors.Is(err, finance.ErrEvidenceImmutable) {
		t.Fatalf("expected ErrEvidenceImmutable for payload change, got %v", err)
	}

	// Test modifying source_provenance:
	mutatedProv := *submitted
	mutatedProv.SourceProvenance = "forged_source"
	if err := store.UpdateEvidence(ctx, &mutatedProv); !errors.Is(err, finance.ErrEvidenceImmutable) {
		t.Fatalf("expected ErrEvidenceImmutable for source_provenance change, got %v", err)
	}

	// 4. Hard deletion must be strictly denied per RULE-M19-005
	if err := store.DeleteEvidence(ctx, wsID, "ev-01"); !errors.Is(err, finance.ErrEvidenceImmutable) {
		t.Fatalf("expected ErrEvidenceImmutable on DeleteEvidence, got %v", err)
	}

	// 5. Verification status alone CAN be updated
	validUpdate := *submitted
	validUpdate.VerificationStatus = finance.VerificationStatusVerified
	if err := store.UpdateEvidence(ctx, &validUpdate); err != nil {
		t.Fatalf("expected verification status update to succeed, got %v", err)
	}

	verified, err := store.GetEvidence(ctx, wsID, "ev-01")
	if err != nil {
		t.Fatalf("failed to retrieve evidence: %v", err)
	}
	if verified.VerificationStatus != finance.VerificationStatusVerified {
		t.Errorf("status = %s, expected verified", verified.VerificationStatus)
	}
	if verified.ContentHash != expectedHash {
		t.Errorf("content hash changed! expected %s, got %s", expectedHash, verified.ContentHash)
	}
}

// Target 3: Finance gaps do not leak to Viewer (RULE-M19-001, M01, RBAC matrix)
func TestFinanceGapsDoNotLeakToViewer(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, func() time.Time { return time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC) })

	wsID := "ws-leak-test"

	// 1. Seed gaps:
	// a. Order with missing COGS
	_ = store.CreateOrder(ctx, &finance.Order{
		OrderID:        "order-gap-01",
		WorkspaceID:    wsID,
		Amount:         tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:       "VND",
		LifecycleState: "completed",
		COGSAmount:     nil, // missing COGS!
		OrderedAt:      time.Now().Add(-24 * time.Hour),
	})

	// b. Unreconciled settlement line
	_ = store.CreateSettlementLine(ctx, &finance.SettlementLine{
		LineID:              "line-gap-01",
		WorkspaceID:         wsID,
		SettlementID:        "sment-01",
		NetAmount:           tenantdb.MustParseExactDecimal("300000.000000"),
		MatchedAmount:       tenantdb.ZeroDecimal(),
		Currency:            "VND",
		ReconciliationState: finance.ReconciliationImportedOnly,
		CreatedAt:           time.Now().Add(-12 * time.Hour),
	})

	// c. Cost item pending evidence
	_ = store.CreateCostItem(ctx, &finance.CostItem{
		CostItemID:  "cost-gap-01",
		WorkspaceID: wsID,
		CostType:    "shipping",
		Amount:      tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:    "VND",
		CostState:   finance.CostStatePendingEvidence,
		CreatedAt:   time.Now().Add(-6 * time.Hour),
	})

	// 2. Query as Manager/Admin: all 3 gaps MUST appear, sorted by severity (critical COGS first)
	adminGaps, adminTotal, _, unreconciledAmt, unreconciledCount, err := svc.ListPendingGaps(ctx, wsID, rbac.RoleAdmin, finance.DataGapFilter{}, 10, 0)
	if err != nil {
		t.Fatalf("admin query failed: %v", err)
	}
	if adminTotal != 3 {
		t.Fatalf("expected 3 data gaps for admin, got %d", adminTotal)
	}
	if len(adminGaps) != 3 {
		t.Fatalf("expected 3 gap items returned, got %d", len(adminGaps))
	}
	if adminGaps[0].Severity != "critical" || adminGaps[0].GapType != "missing_cogs" {
		t.Errorf("first gap should be critical missing_cogs, got %s / %s", adminGaps[0].Severity, adminGaps[0].GapType)
	}
	if unreconciledCount != 1 {
		t.Errorf("unreconciled count = %d, expected 1", unreconciledCount)
	}
	if unreconciledAmt.String() != "300000" {
		t.Errorf("unreconciled amt = %s, expected 300000", unreconciledAmt.String())
	}

	// 3. Query as Viewer: must return ZERO items, ZERO totals, NO leakage!
	viewerGaps, viewerTotal, missingCount, viewerUnrecAmt, viewerUnrecCount, err := svc.ListPendingGaps(ctx, wsID, rbac.RoleViewer, finance.DataGapFilter{}, 10, 0)
	if err != nil {
		t.Fatalf("viewer query returned unexpected error: %v", err)
	}
	if viewerTotal != 0 {
		t.Errorf("SECURITY LEAK: viewerTotal = %d, expected 0", viewerTotal)
	}
	if len(viewerGaps) != 0 {
		t.Errorf("SECURITY LEAK: viewer received %d gap items!", len(viewerGaps))
	}
	if missingCount != 0 {
		t.Errorf("SECURITY LEAK: missingCount = %d, expected 0", missingCount)
	}
	if !viewerUnrecAmt.IsZero() {
		t.Errorf("SECURITY LEAK: viewerUnrecAmt = %s, expected 0", viewerUnrecAmt.String())
	}
	if viewerUnrecCount != 0 {
		t.Errorf("SECURITY LEAK: viewerUnrecCount = %d, expected 0", viewerUnrecCount)
	}

	// 4. Test ReconciliationHandler.ListPending with PolicyContext for Viewer
	recHandler := finance.NewReconciliationHandler(svc)
	viewerCtx := rbac.WithPolicyContext(ctx, rbac.PolicyContext{
		WorkspaceID: wsID,
		Role:        rbac.RoleViewer,
	})

	resp, err := recHandler.ListPending(viewerCtx, connect.NewRequest(&financev1.ReconciliationServiceListPendingRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("unexpected handler error: %v", err)
	}
	if len(resp.Msg.Items) != 0 {
		t.Errorf("SECURITY LEAK via RPC: received %d items for Viewer!", len(resp.Msg.Items))
	}
	if resp.Msg.TotalUnreconciledAmount != nil && resp.Msg.TotalUnreconciledAmount.Amount != "" {
		t.Errorf("SECURITY LEAK via RPC: total unreconciled amount leaked to Viewer: %v", resp.Msg.TotalUnreconciledAmount)
	}

	// 5. Test Home Decision Engine (M01): Mobile Home & Decision Cards for Viewer
	homeSvc := home.NewService(nil)
	homeSvc.SeedWorkspaceMetric(wsID, home.StoredMetric{
		MetricKey:     "revenue_today",
		DisplayName:   "Doanh thu hôm nay",
		AmountCents:   15000000,
		Currency:      "VND",
		DataSource:    adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
		Confidence:    adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
		LastSyncedAt:  time.Now().UTC(),
		IsDemoFixture: false,
	})

	// Call GetMobileHome as Viewer:
	homeViewerCtx := home.WithCallerContext(ctx, home.CallerContext{
		UserID:        "user-viewer",
		WorkspaceID:   wsID,
		WorkspaceRole: rbac.RoleViewer,
	})
	homeResp, err := homeSvc.GetMobileHome(homeViewerCtx, connect.NewRequest(&adminv1.GetMobileHomeRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
		ActiveMode:  adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER,
	}))
	if err != nil {
		t.Fatalf("GetMobileHome failed: %v", err)
	}

	// Verified revenue MUST be redacted for Viewer
	if homeResp.Msg.CustomerVerifiedTotalRevenue != "" {
		t.Errorf("SECURITY LEAK: CustomerVerifiedTotalRevenue = %q, expected empty for Viewer", homeResp.Msg.CustomerVerifiedTotalRevenue)
	}

	// Decision cards MUST NOT contain M19 finance cards for Viewer
	for _, card := range homeResp.Msg.DecisionCards {
		if card.ModuleRef == "M19" || card.CardFamily == "revenue_today" || card.CardFamily == "profit_anomalies" {
			t.Errorf("SECURITY LEAK: finance decision card %s (%s) leaked to Viewer!", card.CardId, card.CardFamily)
		}
	}

	// Call GetWhyThisNumber as Viewer: MUST return PermissionDenied
	_, err = homeSvc.GetWhyThisNumber(homeViewerCtx, connect.NewRequest(&adminv1.GetWhyThisNumberRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
		MetricKey:   "revenue_today",
	}))
	if err == nil {
		t.Errorf("SECURITY LEAK: GetWhyThisNumber allowed for Viewer, expected PermissionDenied")
	} else if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Errorf("expected CodePermissionDenied, got %v", err)
	}
}

// Proof Bundle Assembly & Dynamic Confidence (§11.5 & RULE-M19-006)
func TestProofBundleAssemblyAndConfidence(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, func() time.Time { return time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC) })

	wsID := "ws-proof-test"

	// Create 2 evidence objects
	ev1 := &finance.EvidenceObject{
		EvidenceID:         "ev-pb-01",
		WorkspaceID:        wsID,
		EvidenceType:       "api_response",
		ContentHash:        "hash1",
		VerificationStatus: finance.VerificationStatusVerified,
	}
	ev2 := &finance.EvidenceObject{
		EvidenceID:         "ev-pb-02",
		WorkspaceID:        wsID,
		EvidenceType:       "receipt",
		ContentHash:        "hash2",
		VerificationStatus: finance.VerificationStatusPending,
	}
	_ = store.CreateEvidence(ctx, ev1)
	_ = store.CreateEvidence(ctx, ev2)

	// 1. Assemble bundle with 1 verified and 1 pending evidence: confidence should be Medium
	pb1 := &finance.ProofBundle{
		ProofBundleID:         "pb-01",
		WorkspaceID:           wsID,
		ClaimScope:            "order:batch-2026-11",
		ClaimSummary:          "Dispute resolution evidence bundle",
		SupportingEvidenceIDs: []string{"ev-pb-01", "ev-pb-02"},
	}
	assembled1, err := svc.AssembleProofBundle(ctx, pb1)
	if err != nil {
		t.Fatalf("failed to assemble bundle: %v", err)
	}
	if assembled1.Confidence != finance.ConfidenceMedium {
		t.Errorf("confidence = %s, expected medium", assembled1.Confidence)
	}

	// 2. Mark ev2 as verified: assemble new bundle, confidence should be High
	ev2.VerificationStatus = finance.VerificationStatusVerified
	_ = store.UpdateEvidence(ctx, ev2)

	pb2 := &finance.ProofBundle{
		ProofBundleID:         "pb-02",
		WorkspaceID:           wsID,
		ClaimScope:            "order:batch-2026-11",
		ClaimSummary:          "Dispute resolution evidence bundle - fully verified",
		SupportingEvidenceIDs: []string{"ev-pb-01", "ev-pb-02"},
	}
	assembled2, err := svc.AssembleProofBundle(ctx, pb2)
	if err != nil {
		t.Fatalf("failed to assemble bundle: %v", err)
	}
	if assembled2.Confidence != finance.ConfidenceHigh {
		t.Errorf("confidence = %s, expected high", assembled2.Confidence)
	}

	// 3. Assemble with non-existent evidence: must fail
	pbMissing := &finance.ProofBundle{
		ProofBundleID:         "pb-missing",
		WorkspaceID:           wsID,
		SupportingEvidenceIDs: []string{"ev-does-not-exist"},
	}
	_, err = svc.AssembleProofBundle(ctx, pbMissing)
	if err == nil {
		t.Fatal("expected error for non-existent evidence in bundle, got nil")
	}
}

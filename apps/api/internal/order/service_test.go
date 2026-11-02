package order_test

import (
	"context"
	"sync"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type mockSink struct {
	mu     sync.Mutex
	events []order.OutboxEvent
}

func (s *mockSink) Emit(_ context.Context, evt order.OutboxEvent) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.events = append(s.events, evt)
	return nil
}

func setupTestHarness() (*order.Service, *inventory.Service, order.Store, inventory.Store, *mockSink) {
	orderStore := order.NewMemoryStore()
	invStore := inventory.NewMemoryStore()
	sink := &mockSink{}

	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }

	invSvc := inventory.NewService(invStore, nil, clock)
	orderSvc := order.NewService(orderStore, invSvc, sink, clock)

	return orderSvc, invSvc, orderStore, invStore, sink
}

// Acceptance Target 2: Historical imports do not double-deduct stock
func TestHistoricalImportDoesNotDoubleDeductStock(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, _, invStore, _ := setupTestHarness()

	wsID := "00000000-0000-0000-0000-000000000001"
	skuID := "11111111-1111-1111-1111-111111111111"
	locID := "22222222-2222-2222-2222-222222222222"

	// Establish opening inventory count baseline of 50 units at T0
	t0 := time.Date(2026, 11, 1, 0, 0, 0, 0, time.UTC)
	err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 50, t0)
	if err != nil {
		t.Fatalf("failed to record baseline: %v", err)
	}

	bal0, err := invStore.GetBalance(ctx, wsID, skuID, locID)
	if err != nil || bal0.OnHand != 50 {
		t.Fatalf("expected baseline on_hand=50, got %d, err: %v", bal0.OnHand, err)
	}

	// 1. Ingest historical order that occurred BEFORE opening baseline (T0 - 2 days)
	historicalOrderedAt := t0.Add(-48 * time.Hour)
	histOrder := &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassImported,
		SourcePlatform:  "shopee",
		ExternalOrderID: "SHOP-HIST-001",
		Amount:          tenantdb.MustParseExactDecimal("250000.000000"),
		Currency:        "VND",
		OrderedAt:       historicalOrderedAt,
		LifecycleState:  order.StateConfirmed,
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Quantity:  5,
				UnitPrice: tenantdb.MustParseExactDecimal("50000.000000"),
				Total:     tenantdb.MustParseExactDecimal("250000.000000"),
			},
		},
	}

	createdOrder, created, err := orderSvc.IngestOrder(ctx, histOrder, locID)
	if err != nil {
		t.Fatalf("historical order ingestion failed: %v", err)
	}
	if !created {
		t.Fatalf("expected historical order to be created")
	}
	if createdOrder.OrderID == "" {
		t.Fatalf("expected order ID to be set")
	}

	// Stock must NOT be deducted for historical order!
	balAfterHist, err := invStore.GetBalance(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("failed to get balance: %v", err)
	}
	if balAfterHist.OnHand != 50 || balAfterHist.Reserved != 0 {
		t.Fatalf("historical order double-deducted stock! expected on_hand=50, reserved=0, got on_hand=%d, reserved=%d",
			balAfterHist.OnHand, balAfterHist.Reserved)
	}

	// 2. Ingest modern order that occurred AFTER opening baseline (T0 + 2 days)
	modernOrderedAt := t0.Add(48 * time.Hour)
	modernOrder := &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassImported,
		SourcePlatform:  "shopee",
		ExternalOrderID: "SHOP-MODERN-002",
		Amount:          tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:        "VND",
		OrderedAt:       modernOrderedAt,
		LifecycleState:  order.StateCreated,
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Quantity:  10,
				UnitPrice: tenantdb.MustParseExactDecimal("50000.000000"),
				Total:     tenantdb.MustParseExactDecimal("500000.000000"),
			},
		},
	}

	_, created, err = orderSvc.IngestOrder(ctx, modernOrder, locID)
	if err != nil {
		t.Fatalf("modern order ingestion failed: %v", err)
	}
	if !created {
		t.Fatalf("expected modern order to be created")
	}

	// Modern order MUST hold stock reservation!
	balAfterModern, err := invStore.GetBalance(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("failed to get balance: %v", err)
	}
	if balAfterModern.OnHand != 50 || balAfterModern.Reserved != 10 {
		t.Fatalf("expected on_hand=50, reserved=10, got on_hand=%d, reserved=%d",
			balAfterModern.OnHand, balAfterModern.Reserved)
	}

	// Confirm modern order -> fulfills reservation, on_hand drops to 40, reserved drops to 0
	_, err = orderSvc.ConfirmOrder(ctx, wsID, modernOrder.OrderID)
	if err != nil {
		t.Fatalf("failed to confirm modern order: %v", err)
	}

	balFinal, err := invStore.GetBalance(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("failed to get final balance: %v", err)
	}
	if balFinal.OnHand != 40 || balFinal.Reserved != 0 {
		t.Fatalf("expected final on_hand=40, reserved=0, got on_hand=%d, reserved=%d",
			balFinal.OnHand, balFinal.Reserved)
	}
}

// Acceptance Target 3: Partial refund followed by full refund works
func TestPartialRefundFollowedByFullRefund(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, orderStore, _, _ := setupTestHarness()

	wsID := "00000000-0000-0000-0000-000000000001"
	ord := &order.Order{
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("1000000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCompleted,
	}

	ord, created, err := orderSvc.IngestOrder(ctx, ord, "")
	if err != nil || !created {
		t.Fatalf("failed to create completed order: %v", err)
	}

	// Initial refundable balance: 1,000,000 VND
	rem0, err := ord.RefundableRemaining()
	if err != nil || rem0.String() != "1000000" {
		t.Fatalf("expected initial remaining 1000000, got %s, err: %v", rem0.String(), err)
	}

	// Step 1: Request and approve partial refund of 300,000 VND
	ref1 := &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "partial",
		Amount:      tenantdb.MustParseExactDecimal("300000.000000"),
		Currency:    "VND",
		Reason:      "Customer returned 1 damaged item",
	}

	createdRef1, _, err := orderSvc.RequestRefund(ctx, ref1)
	if err != nil {
		t.Fatalf("failed to request partial refund 1: %v", err)
	}

	appRef1, updatedOrd1, err := orderSvc.ApproveRefund(ctx, wsID, createdRef1.RefundID)
	if err != nil {
		t.Fatalf("failed to approve refund 1: %v", err)
	}
	if appRef1.LifecycleState != order.RefundCompleted {
		t.Fatalf("expected refund state completed, got %s", appRef1.LifecycleState)
	}

	// Verify order is now in partially_refunded state
	if updatedOrd1.LifecycleState != order.StatePartiallyRefunded {
		t.Fatalf("expected order state %s, got %s", order.StatePartiallyRefunded, updatedOrd1.LifecycleState)
	}
	if updatedOrd1.RefundedAmount.String() != "300000" {
		t.Fatalf("expected refunded amount 300000, got %s", updatedOrd1.RefundedAmount.String())
	}

	// Remaining balance must be 700,000 VND
	rem1, _ := updatedOrd1.RefundableRemaining()
	if rem1.String() != "700000" {
		t.Fatalf("expected remaining 700000, got %s", rem1.String())
	}

	// Step 2: Attempting an excessive refund of 800,000 VND must be rejected
	refExcess := &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "partial",
		Amount:      tenantdb.MustParseExactDecimal("800000.000000"),
		Currency:    "VND",
		Reason:      "Excessive amount test",
	}
	_, _, err = orderSvc.RequestRefund(ctx, refExcess)
	if err == nil {
		t.Fatalf("expected excessive refund to be rejected, but it succeeded")
	}

	// Step 3: Second refund for remaining 700,000 VND (completes full refund)
	ref2 := &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "full",
		Amount:      tenantdb.MustParseExactDecimal("700000.000000"),
		Currency:    "VND",
		Reason:      "Full settlement of remaining items",
	}

	createdRef2, _, err := orderSvc.RequestRefund(ctx, ref2)
	if err != nil {
		t.Fatalf("failed to request refund 2: %v", err)
	}

	appRef2, updatedOrd2, err := orderSvc.ApproveRefund(ctx, wsID, createdRef2.RefundID)
	if err != nil {
		t.Fatalf("failed to approve refund 2: %v", err)
	}
	if appRef2.LifecycleState != order.RefundCompleted {
		t.Fatalf("expected refund 2 completed, got %s", appRef2.LifecycleState)
	}

	// Verify order state is now fully refunded!
	if updatedOrd2.LifecycleState != order.StateRefunded {
		t.Fatalf("expected order state %s, got %s", order.StateRefunded, updatedOrd2.LifecycleState)
	}
	if updatedOrd2.RefundedAmount.String() != "1000000" {
		t.Fatalf("expected refunded amount 1000000, got %s", updatedOrd2.RefundedAmount.String())
	}

	rem2, _ := updatedOrd2.RefundableRemaining()
	if !rem2.IsZero() {
		t.Fatalf("expected 0 remaining refundable, got %s", rem2.String())
	}

	// Step 4: Any further refund attempt on fully refunded order must fail
	refPost := &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "partial",
		Amount:      tenantdb.MustParseExactDecimal("10000.000000"),
		Currency:    "VND",
		Reason:      "Post-refund attempt",
	}
	_, _, err = orderSvc.RequestRefund(ctx, refPost)
	if err == nil {
		t.Fatalf("expected post-refund to be rejected")
	}

	// Verify persistent store state reflects exact numbers
	persistedOrd, err := orderStore.GetOrder(ctx, wsID, ord.OrderID)
	if err != nil {
		t.Fatalf("failed to get persisted order: %v", err)
	}
	if persistedOrd.LifecycleState != order.StateRefunded {
		t.Fatalf("expected persisted state %s, got %s", order.StateRefunded, persistedOrd.LifecycleState)
	}
	if persistedOrd.RefundedAmount.String() != "1000000" {
		t.Fatalf("expected persisted refunded amount 1000000, got %s", persistedOrd.RefundedAmount.String())
	}
}

// Ingestion Idempotency Test
func TestOrderIngestionIdempotency(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, _, _, _ := setupTestHarness()

	wsID := "00000000-0000-0000-0000-000000000001"
	ord := &order.Order{
		WorkspaceID:       wsID,
		SourceClass:       order.SourceClassImported,
		SourcePlatform:    "tiktok",
		ExternalOrderID:   "TT-998877",
		ImportFingerprint: "sha256-order-fingerprint-unique",
		Amount:            tenantdb.MustParseExactDecimal("350000.000000"),
		Currency:          "VND",
		LifecycleState:    order.StateCreated,
	}

	o1, created1, err := orderSvc.IngestOrder(ctx, ord, "")
	if err != nil || !created1 {
		t.Fatalf("initial ingest failed: %v", err)
	}

	// Second ingest with exact same import fingerprint -> idempotent return
	ord2 := &order.Order{
		WorkspaceID:       wsID,
		ImportFingerprint: "sha256-order-fingerprint-unique",
		Amount:            tenantdb.MustParseExactDecimal("350000.000000"),
		Currency:          "VND",
	}
	o2, created2, err := orderSvc.IngestOrder(ctx, ord2, "")
	if err != nil {
		t.Fatalf("re-ingest failed: %v", err)
	}
	if created2 {
		t.Fatalf("expected created=false on duplicate fingerprint")
	}
	if o2.OrderID != o1.OrderID {
		t.Fatalf("expected same order ID returned, got %s vs %s", o2.OrderID, o1.OrderID)
	}

	// Third ingest with exact same platform + external ID -> idempotent return
	ord3 := &order.Order{
		WorkspaceID:     wsID,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "TT-998877",
		Amount:          tenantdb.MustParseExactDecimal("350000.000000"),
		Currency:        "VND",
	}
	o3, created3, err := orderSvc.IngestOrder(ctx, ord3, "")
	if err != nil {
		t.Fatalf("re-ingest 3 failed: %v", err)
	}
	if created3 {
		t.Fatalf("expected created=false on duplicate platform/externalID")
	}
	if o3.OrderID != o1.OrderID {
		t.Fatalf("expected same order ID returned, got %s vs %s", o3.OrderID, o1.OrderID)
	}
}

// Order Lifecycle Transitions and Cancellation
func TestOrderLifecycleAndCancellation(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, _, invStore, _ := setupTestHarness()

	wsID := "00000000-0000-0000-0000-000000000001"
	skuID := "11111111-1111-1111-1111-111111111111"
	locID := "22222222-2222-2222-2222-222222222222"

	// Baseline
	_ = invStore.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID,
		SkuID:       skuID,
		LocationID:  locID,
		OnHand:      20,
		Reserved:    0,
	})

	ord := &order.Order{
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("150000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCreated,
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 4, UnitPrice: tenantdb.MustParseExactDecimal("37500.000000"), Total: tenantdb.MustParseExactDecimal("150000.000000")},
		},
	}

	ord, _, err := orderSvc.IngestOrder(ctx, ord, locID)
	if err != nil {
		t.Fatalf("ingest failed: %v", err)
	}

	bal, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 20 || bal.Reserved != 4 {
		t.Fatalf("expected reserved=4, got %d", bal.Reserved)
	}

	// Cancel order -> reservation must be released!
	cancelledOrd, err := orderSvc.CancelOrder(ctx, wsID, ord.OrderID, "Customer cancelled before payment")
	if err != nil {
		t.Fatalf("cancel failed: %v", err)
	}
	if cancelledOrd.LifecycleState != order.StateCancelled {
		t.Fatalf("expected cancelled state, got %s", cancelledOrd.LifecycleState)
	}

	balAfterCancel, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if balAfterCancel.OnHand != 20 || balAfterCancel.Reserved != 0 {
		t.Fatalf("expected reserved released back to 0, got %d", balAfterCancel.Reserved)
	}

	// Trying to confirm a cancelled order must fail closed
	_, err = orderSvc.ConfirmOrder(ctx, wsID, ord.OrderID)
	if err == nil {
		t.Fatalf("expected confirm of cancelled order to fail")
	}
}

// Physical Returns vs Financial Refunds Separation
func TestPhysicalReturnRestocksInventoryWhileRefundDoesNot(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, _, invStore, _ := setupTestHarness()

	wsID := "00000000-0000-0000-0000-000000000001"
	skuID := "11111111-1111-1111-1111-111111111111"
	locID := "22222222-2222-2222-2222-222222222222"

	// Baseline of 10 on hand
	_ = invStore.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID,
		SkuID:       skuID,
		LocationID:  locID,
		OnHand:      10,
		Reserved:    0,
	})

	// Order of 2 items
	ord := &order.Order{
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCreated,
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000"), Total: tenantdb.MustParseExactDecimal("200000.000000")},
		},
	}
	ord, _, _ = orderSvc.IngestOrder(ctx, ord, locID)
	_, _ = orderSvc.ConfirmOrder(ctx, wsID, ord.OrderID)
	_, _ = orderSvc.FulfillOrder(ctx, wsID, ord.OrderID)
	_, _ = orderSvc.CompleteOrder(ctx, wsID, ord.OrderID)

	// Stock is now 8 on hand
	bal, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 8 {
		t.Fatalf("expected on_hand=8 after fulfillment, got %d", bal.OnHand)
	}

	// Step 1: Process full financial refund of 200,000 VND
	ref := &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "full",
		Amount:      tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:    "VND",
		Reason:      "Customer return refund",
	}
	r, _, _ := orderSvc.RequestRefund(ctx, ref)
	_, _, err := orderSvc.ApproveRefund(ctx, wsID, r.RefundID)
	if err != nil {
		t.Fatalf("refund approval failed: %v", err)
	}

	// Financial refund MUST NOT alter stock! Stock must remain 8
	balPostRefund, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if balPostRefund.OnHand != 8 {
		t.Fatalf("financial refund illegally modified stock! on_hand=%d", balPostRefund.OnHand)
	}

	// Step 2: Physical return arrives and is received -> Restocks 2 units
	ret := &order.Return{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundID:    r.RefundID,
		ReturnType:  "full",
		Items: []order.ReturnItem{
			{Sku: skuID, Quantity: 2, Reason: "Defective stitching"},
		},
	}
	createdRet, err := orderSvc.CreateReturn(ctx, ret)
	if err != nil {
		t.Fatalf("create return failed: %v", err)
	}

	_, err = orderSvc.ReceiveReturn(ctx, wsID, createdRet.ReturnID, locID)
	if err != nil {
		t.Fatalf("receive return failed: %v", err)
	}

	// Physical return restocks inventory back to 10!
	balPostReturn, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if balPostReturn.OnHand != 10 {
		t.Fatalf("physical return failed to restock: expected on_hand=10, got %d", balPostReturn.OnHand)
	}
}

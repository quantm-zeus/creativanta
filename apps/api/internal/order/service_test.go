package order_test

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/affiliate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
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

type fkCheckingInventoryService struct {
	inner      order.InventoryService
	orderStore order.Store
	lastOrder  string
}

func (f *fkCheckingInventoryService) ReserveStock(ctx context.Context, workspaceID, orderID string, items []inventory.ReservationItem, ttl time.Duration) ([]*inventory.Reservation, error) {
	f.lastOrder = orderID
	if strings.HasSuffix(orderID, "-late") {
		return nil, fmt.Errorf("invalid non-UUID order_id %s passed to ReserveStock", orderID)
	}
	if _, err := f.orderStore.GetOrder(ctx, workspaceID, orderID); err != nil {
		return nil, fmt.Errorf("FK violation: parent order %s does not exist before ReserveStock: %w", orderID, err)
	}
	return f.inner.ReserveStock(ctx, workspaceID, orderID, items, ttl)
}

func (f *fkCheckingInventoryService) FulfillReservation(ctx context.Context, workspaceID, orderID string) ([]*inventory.Movement, error) {
	if strings.HasSuffix(orderID, "-late") {
		return nil, fmt.Errorf("invalid non-UUID order_id %s passed to FulfillReservation", orderID)
	}
	if _, err := f.orderStore.GetOrder(ctx, workspaceID, orderID); err != nil {
		return nil, fmt.Errorf("FK violation: parent order %s does not exist before FulfillReservation: %w", orderID, err)
	}
	return f.inner.FulfillReservation(ctx, workspaceID, orderID)
}

func (f *fkCheckingInventoryService) ReleaseReservation(ctx context.Context, workspaceID, orderID, reason string) error {
	return f.inner.ReleaseReservation(ctx, workspaceID, orderID, reason)
}

func (f *fkCheckingInventoryService) ShouldDeductStockForImportedOrder(ctx context.Context, workspaceID, skuID, locationID string, orderOrderedAt time.Time) (bool, error) {
	return f.inner.ShouldDeductStockForImportedOrder(ctx, workspaceID, skuID, locationID, orderOrderedAt)
}

func (f *fkCheckingInventoryService) RecordPhysicalReturn(ctx context.Context, workspaceID, orderID, returnID, skuID, locationID string, quantity int32, reason string) (*inventory.Movement, error) {
	return f.inner.RecordPhysicalReturn(ctx, workspaceID, orderID, returnID, skuID, locationID, quantity, reason)
}

// INV-01: Parent order must exist before ReserveStock, rollback deletes order if reservation fails,
// and late payment recovery re-reserves on canonical UUID order_id rather than orderID+"-late".
func TestParentOrderExistsBeforeReservationAndLatePaymentRecoveryUsesCanonicalOrderID(t *testing.T) {
	ctx := context.Background()
	orderStore := order.NewMemoryStore()
	invStore := inventory.NewMemoryStore()

	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }

	invSvc := inventory.NewService(invStore, nil, clock)
	fkInv := &fkCheckingInventoryService{inner: invSvc, orderStore: orderStore}
	orderSvc := order.NewService(orderStore, fkInv, nil, clock)

	wsID := "00000000-0000-0000-0000-000000000001"
	skuID := "11111111-1111-1111-1111-111111111111"
	locID := "22222222-2222-2222-2222-222222222222"

	_ = invStore.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID,
		SkuID:       skuID,
		LocationID:  locID,
		OnHand:      5,
		Reserved:    0,
	})

	// 1. Order requesting 10 units (> 5 on hand) must fail ReserveStock AND roll back the parent order row
	excessOrder := &order.Order{
		OrderID:        "33333333-3333-4333-8333-333333333301",
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCreated,
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 10, UnitPrice: tenantdb.MustParseExactDecimal("50000.000000"), Total: tenantdb.MustParseExactDecimal("500000.000000")},
		},
	}
	if _, _, err := orderSvc.IngestOrder(ctx, excessOrder, locID); err == nil {
		t.Fatalf("expected insufficient stock error during IngestOrder")
	}
	if _, err := orderStore.GetOrder(ctx, wsID, excessOrder.OrderID); !errors.Is(err, order.ErrOrderNotFound) {
		t.Fatalf("expected parent order to be rolled back after ReserveStock failure, got err=%v", err)
	}

	// 2. Valid order of 3 units succeeds because parent order exists before ReserveStock is called
	validOrder := &order.Order{
		OrderID:        "33333333-3333-4333-8333-333333333302",
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("150000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCreated,
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 3, UnitPrice: tenantdb.MustParseExactDecimal("50000.000000"), Total: tenantdb.MustParseExactDecimal("150000.000000")},
		},
	}
	createdOrd, created, err := orderSvc.IngestOrder(ctx, validOrder, locID)
	if err != nil || !created {
		t.Fatalf("expected valid order ingestion to succeed with FK check enabled, got err=%v", err)
	}

	// 3. Advance clock past reservation TTL (30m) and expire reservations
	now = now.Add(45 * time.Minute)
	if _, err := invSvc.ExpireReservations(ctx, now); err != nil {
		t.Fatalf("ExpireReservations failed: %v", err)
	}
	balAfterExpiry, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if balAfterExpiry.Reserved != 0 || balAfterExpiry.OnHand != 5 {
		t.Fatalf("expected reserved=0 on_hand=5 after expiry, got reserved=%d on_hand=%d", balAfterExpiry.Reserved, balAfterExpiry.OnHand)
	}

	// 4. Late payment confirmation recovers using canonical orderID (no "-late" suffix)
	confirmedOrd, err := orderSvc.HandlePaymentConfirmation(ctx, wsID, createdOrd.OrderID, locID)
	if err != nil {
		t.Fatalf("HandlePaymentConfirmation late recovery failed: %v", err)
	}
	if confirmedOrd.LifecycleState != order.StateConfirmed {
		t.Fatalf("expected StateConfirmed, got %s", confirmedOrd.LifecycleState)
	}
	if fkInv.lastOrder != createdOrd.OrderID {
		t.Fatalf("expected canonical orderID %s used for late reservation, got %s", createdOrd.OrderID, fkInv.lastOrder)
	}
	balAfterConfirm, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if balAfterConfirm.OnHand != 2 || balAfterConfirm.Reserved != 0 {
		t.Fatalf("expected on_hand=2 reserved=0 after late payment fulfillment, got on_hand=%d reserved=%d", balAfterConfirm.OnHand, balAfterConfirm.Reserved)
	}
}

type failingFinanceService struct {
	failOrderPosting  bool
	failRefundPosting bool
	failCorrection    bool
}

func (f *failingFinanceService) RecordOrderPosting(ctx context.Context, input finance.OrderPostingInput) error {
	if f.failOrderPosting {
		return errors.New("simulated finance order posting failure")
	}
	return nil
}

func (f *failingFinanceService) RecordRefundPosting(ctx context.Context, workspaceID, refundID, orderID string, refundAmount tenantdb.ExactDecimal, currency string, sourceClass, confidence string, fx finance.ExchangeRateSnapshot) error {
	if f.failRefundPosting {
		return errors.New("simulated finance refund posting failure")
	}
	return nil
}

func (f *failingFinanceService) RecordOrderCorrection(ctx context.Context, workspaceID, orderID, component string, newAmount tenantdb.ExactDecimal, newVersion, sourceClass, confidence string, fx finance.ExchangeRateSnapshot) error {
	if f.failCorrection {
		return errors.New("simulated finance correction failure")
	}
	return nil
}

// FIN-02: Completed orders always record finance postings and roll back state if finance posting fails.
func TestCompletedOrdersRecordFinancePostingsAndRollbackOnFinanceError(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, orderStore, _, _ := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)
	orderSvc.SetFinance(finSvc)

	wsID := "00000000-0000-0000-0000-000000000001"

	// 1. Order ingested directly in StateCompleted posts revenue immediately
	completedImport := &order.Order{
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("400000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCompleted,
	}
	completedImport, _, err := orderSvc.IngestOrder(ctx, completedImport, "")
	if err != nil {
		t.Fatalf("IngestOrder StateCompleted failed: %v", err)
	}
	postings, err := finStore.ListPostings(ctx, wsID, finance.PostingFilter{})
	if err != nil || len(postings) == 0 {
		t.Fatalf("expected revenue posting for order ingested in StateCompleted, got %d postings (err=%v)", len(postings), err)
	}

	// 2. Order transitioning Fulfilled -> Completed rolls back to StateFulfilled if FinanceService fails
	failFin := &failingFinanceService{failOrderPosting: true}
	orderSvc.SetFinance(failFin)

	ord := &order.Order{
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("250000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateFulfilled,
	}
	ord, _, err = orderSvc.IngestOrder(ctx, ord, "")
	if err != nil {
		t.Fatalf("IngestOrder StateFulfilled failed: %v", err)
	}

	if _, err := orderSvc.CompleteOrder(ctx, wsID, ord.OrderID); err == nil {
		t.Fatalf("expected CompleteOrder to return error when finance posting fails")
	}
	persisted, err := orderStore.GetOrder(ctx, wsID, ord.OrderID)
	if err != nil {
		t.Fatalf("GetOrder failed: %v", err)
	}
	if persisted.LifecycleState != order.StateFulfilled {
		t.Fatalf("expected order state rolled back to %s after finance failure, got %s", order.StateFulfilled, persisted.LifecycleState)
	}

	// 3. When finance succeeds, CompleteOrder transitions to StateCompleted and posts revenue
	orderSvc.SetFinance(finSvc)
	if _, err := orderSvc.CompleteOrder(ctx, wsID, ord.OrderID); err != nil {
		t.Fatalf("CompleteOrder failed after restoring finance service: %v", err)
	}

	// 4. UpdateFeeBreakdown rolls back FeeBreakdown if RecordOrderCorrection fails
	orderSvc.SetFinance(&failingFinanceService{failCorrection: true})
	_, err = orderSvc.UpdateFeeBreakdown(ctx, wsID, ord.OrderID, order.FeeBreakdown{
		PlatformFee: tenantdb.MustParseExactDecimal("15000.000000"),
	}, "v2", "ev-1", "settlement fee update")
	if err == nil {
		t.Fatalf("expected UpdateFeeBreakdown to fail when finance correction fails")
	}
	persistedAfterFeeFail, _ := orderStore.GetOrder(ctx, wsID, ord.OrderID)
	if !persistedAfterFeeFail.FeeBreakdown.PlatformFee.IsZero() {
		t.Fatalf("expected PlatformFee rolled back to 0 on correction failure, got %s", persistedAfterFeeFail.FeeBreakdown.PlatformFee.String())
	}
}

// FIN-03: Concurrent refund approvals never exceed order total, currency mismatch is rejected,
// and failed finance refund posting reverts refund approval.
func TestConcurrentRefundApprovalsCannotExceedCapturedTotal(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, orderStore, _, _ := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)
	orderSvc.SetFinance(finSvc)

	wsID := "00000000-0000-0000-0000-000000000001"
	ord := &order.Order{
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("1000000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCompleted,
	}
	ord, _, err := orderSvc.IngestOrder(ctx, ord, "")
	if err != nil {
		t.Fatalf("IngestOrder failed: %v", err)
	}

	// 1. Currency mismatch must fail closed
	_, _, err = orderSvc.RequestRefund(ctx, &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "partial",
		Amount:      tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:    "USD",
	})
	if !errors.Is(err, order.ErrCurrencyMismatch) {
		t.Fatalf("expected ErrCurrencyMismatch on USD refund against VND order, got %v", err)
	}

	// 2. Request 10 partial refunds of 300,000 VND each (each <= 1,000,000 VND remaining at request time)
	const workers = 10
	refundIDs := make([]string, workers)
	for i := 0; i < workers; i++ {
		ref, _, err := orderSvc.RequestRefund(ctx, &order.Refund{
			WorkspaceID: wsID,
			OrderID:     ord.OrderID,
			RefundType:  "partial",
			Amount:      tenantdb.MustParseExactDecimal("300000.000000"),
			Currency:    "VND",
			Reason:      fmt.Sprintf("concurrent partial refund %d", i),
		})
		if err != nil {
			t.Fatalf("RequestRefund %d failed: %v", i, err)
		}
		refundIDs[i] = ref.RefundID
	}

	// 3. Approve all 10 concurrently: at most 3 can succeed (900,000 VND <= 1,000,000 VND)
	var wg sync.WaitGroup
	var mu sync.Mutex
	successCount := 0
	rejectCount := 0

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(refID string) {
			defer wg.Done()
			_, _, err := orderSvc.ApproveRefund(ctx, wsID, refID)
			mu.Lock()
			defer mu.Unlock()
			if err == nil {
				successCount++
			} else if errors.Is(err, order.ErrRefundExceedsOrderTotal) {
				rejectCount++
			} else {
				t.Errorf("unexpected ApproveRefund error: %v", err)
			}
		}(refundIDs[i])
	}
	wg.Wait()

	if successCount != 3 || rejectCount != 7 {
		t.Fatalf("expected exactly 3 approvals and 7 rejections, got success=%d reject=%d", successCount, rejectCount)
	}

	finalOrd, err := orderStore.GetOrder(ctx, wsID, ord.OrderID)
	if err != nil {
		t.Fatalf("GetOrder failed: %v", err)
	}
	if finalOrd.RefundedAmount.String() != "900000" {
		t.Fatalf("expected RefundedAmount=900000 after 3 concurrent 300k approvals, got %s", finalOrd.RefundedAmount.String())
	}
	if finalOrd.LifecycleState != order.StatePartiallyRefunded {
		t.Fatalf("expected StatePartiallyRefunded, got %s", finalOrd.LifecycleState)
	}

	// 4. If finance posting fails during ApproveRefund, refund approval and order RefundedAmount are reverted
	remRef, _, err := orderSvc.RequestRefund(ctx, &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "partial",
		Amount:      tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:    "VND",
	})
	if err != nil {
		t.Fatalf("RequestRefund for remaining 100k failed: %v", err)
	}

	orderSvc.SetFinance(&failingFinanceService{failRefundPosting: true})
	if _, _, err := orderSvc.ApproveRefund(ctx, wsID, remRef.RefundID); err == nil {
		t.Fatalf("expected ApproveRefund to fail when finance refund posting fails")
	}

	revertedOrd, _ := orderStore.GetOrder(ctx, wsID, ord.OrderID)
	if revertedOrd.RefundedAmount.String() != "900000" || revertedOrd.LifecycleState != order.StatePartiallyRefunded {
		t.Fatalf("expected order RefundedAmount=900000 and StatePartiallyRefunded after revert, got %s (%s)",
			revertedOrd.RefundedAmount.String(), revertedOrd.LifecycleState)
	}
	revertedRef, _ := orderStore.GetRefund(ctx, wsID, remRef.RefundID)
	if revertedRef.LifecycleState != order.RefundRequested {
		t.Fatalf("expected refund reverted to RefundRequested, got %s", revertedRef.LifecycleState)
	}
}

func TestAUTH03_OrderAndRefundHandlersEnforceTenantScopeAndPermissions(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, _, _, _ := setupTestHarness()
	orderHandler := order.NewOrderHandler(orderSvc)
	refundHandler := order.NewRefundHandler(orderSvc)

	wsA := "11111111-1111-4111-8111-111111111110"
	wsB := "22222222-2222-4222-8222-222222222220"

	ordB, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:    wsB,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCreated,
	}, "")
	if err != nil {
		t.Fatalf("ingest order in wsB failed: %v", err)
	}

	// 1. Unauthenticated caller supplying CommandContext.WorkspaceId must fail with CodeUnauthenticated.
	_, err = orderHandler.Confirm(ctx, connect.NewRequest(&commercev1.OrderServiceConfirmRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsB}},
		OrderId: ordB.OrderID,
	}))
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for unauthenticated OrderHandler.Confirm, got %v", err)
	}

	// 2. API key bound to Workspace A attempting to pass CommandContext.WorkspaceId = Workspace B must fail with CodePermissionDenied.
	apiKeyCtxA := transportauth.WithPrincipal(ctx, transportauth.Session{
		WorkspaceID:  wsA,
		ServiceKeyID: "key_ws_a",
		ScopesCSV:    transportauth.JoinScopes([]string{"read:orders", "write:orders"}),
	})
	_, err = orderHandler.Confirm(apiKeyCtxA, connect.NewRequest(&commercev1.OrderServiceConfirmRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsB}},
		OrderId: ordB.OrderID,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when API key for wsA requests wsB in CommandContext, got %v", err)
	}

	// 3. API key bound to Workspace A calling Get uses wsA and cannot read ordB (CodeNotFound).
	_, err = orderHandler.Get(apiKeyCtxA, connect.NewRequest(&commercev1.OrderServiceGetRequest{
		OrderId: ordB.OrderID,
	}))
	if connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when API key for wsA queries order belonging to wsB, got %v", err)
	}

	// 4. API key with read:orders only cannot call OrderHandler.Confirm or RefundHandler.Create (requires write:orders).
	readOnlyKeyCtxB := transportauth.WithPrincipal(ctx, transportauth.Session{
		WorkspaceID:  wsB,
		ServiceKeyID: "key_ws_b_ro",
		ScopesCSV:    transportauth.JoinScopes([]string{"read:orders"}),
	})
	_, err = orderHandler.Confirm(readOnlyKeyCtxB, connect.NewRequest(&commercev1.OrderServiceConfirmRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsB}},
		OrderId: ordB.OrderID,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when read:orders key calls Confirm, got %v", err)
	}
	_, err = refundHandler.Create(readOnlyKeyCtxB, connect.NewRequest(&commercev1.RefundServiceCreateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsB}},
		OrderId: ordB.OrderID,
		Amount:  &commonv1.Money{Amount: "100000", Currency: "VND"},
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when read:orders key calls RefundHandler.Create, got %v", err)
	}

	// 5. User principal with editor role can read orders (order:read, Editor+) while viewer is denied (CodePermissionDenied).
	viewerCtxB := transportauth.WithPrincipal(ctx, transportauth.Session{
		UserID:      "33333333-3333-4333-8333-333333333330",
		WorkspaceID: wsB,
		Role:        "viewer",
	})
	if _, err := orderHandler.Get(viewerCtxB, connect.NewRequest(&commercev1.OrderServiceGetRequest{
		OrderId: ordB.OrderID,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when viewer calls OrderHandler.Get (requires order:read / Editor+), got %v", err)
	}
	editorCtxB := transportauth.WithPrincipal(ctx, transportauth.Session{
		UserID:      "33333333-3333-4333-8333-333333333331",
		WorkspaceID: wsB,
		Role:        "editor",
	})
	if _, err := orderHandler.Get(editorCtxB, connect.NewRequest(&commercev1.OrderServiceGetRequest{
		OrderId: ordB.OrderID,
	})); err != nil {
		t.Fatalf("expected editor OrderHandler.Get to succeed, got %v", err)
	}
	_, err = refundHandler.Create(editorCtxB, connect.NewRequest(&commercev1.RefundServiceCreateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsB}},
		OrderId: ordB.OrderID,
		Amount:  &commonv1.Money{Amount: "100000", Currency: "VND"},
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when editor calls RefundHandler.Create (requires refund:manage / Manager+), got %v", err)
	}
}

// F09: RefundHandler.Create requires idempotency_key, deduplicates replays, rejects payload conflicts,
// and enforces unique external refund identity under concurrency.
func TestF09_RefundCreateIdempotencyConflictAndConcurrentExternalIdentity(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, orderStore, _, _ := setupTestHarness()
	refundHandler := order.NewRefundHandler(orderSvc)

	wsID := "11111111-1111-4111-8111-111111111110"
	managerCtx := transportauth.WithPrincipal(ctx, transportauth.Session{
		UserID:      "33333333-3333-4333-8333-333333333339",
		WorkspaceID: wsID,
		Role:        "manager",
	})

	ord, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCompleted,
	}, "")
	if err != nil {
		t.Fatalf("ingest order failed: %v", err)
	}

	// 1. Missing idempotency_key on RefundHandler.Create must fail with CodeInvalidArgument
	_, err = refundHandler.Create(managerCtx, connect.NewRequest(&commercev1.RefundServiceCreateRequest{
		Context:    &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		OrderId:    ord.OrderID,
		RefundType: "partial",
		Amount:     &commonv1.Money{Amount: "30000", Currency: "VND"},
		Reason:     "partial refund",
	}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument when idempotency_key is missing on RefundHandler.Create, got %v", err)
	}

	// 2. First call with idempotency_key succeeds; second call with same key + same payload returns exact same refund
	req1 := &commercev1.RefundServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-refund-create-01",
		},
		OrderId:    ord.OrderID,
		RefundType: "partial",
		Amount:     &commonv1.Money{Amount: "30000", Currency: "VND"},
		Reason:     "partial refund",
	}
	resp1, err := refundHandler.Create(managerCtx, connect.NewRequest(req1))
	if err != nil {
		t.Fatalf("first RefundHandler.Create failed: %v", err)
	}
	resp2, err := refundHandler.Create(managerCtx, connect.NewRequest(req1))
	if err != nil {
		t.Fatalf("replayed RefundHandler.Create failed: %v", err)
	}
	if resp1.Msg.GetRefund().GetRefundId() != resp2.Msg.GetRefund().GetRefundId() {
		t.Fatalf("expected replayed RefundHandler.Create to return same refund_id %s, got %s",
			resp1.Msg.GetRefund().GetRefundId(), resp2.Msg.GetRefund().GetRefundId())
	}
	allRefunds, err := orderStore.ListRefundsByOrder(ctx, wsID, ord.OrderID)
	if err != nil || len(allRefunds) != 1 {
		t.Fatalf("expected exactly 1 refund after idempotent replay, got %d (err=%v)", len(allRefunds), err)
	}

	// 3. Reusing same idempotency_key with different amount must fail with CodeAlreadyExists (conflict)
	_, err = refundHandler.Create(managerCtx, connect.NewRequest(&commercev1.RefundServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-refund-create-01",
		},
		OrderId:    ord.OrderID,
		RefundType: "partial",
		Amount:     &commonv1.Money{Amount: "40000", Currency: "VND"},
		Reason:     "partial refund",
	}))
	if connect.CodeOf(err) != connect.CodeAlreadyExists {
		t.Fatalf("expected CodeAlreadyExists when reusing idempotency_key with different amount, got %v", err)
	}

	// 4. Concurrent external refund requests with same ExternalRefundID must create only 1 refund
	const workers = 10
	var wg sync.WaitGroup
	errs := make(chan error, workers)
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			_, _, rErr := orderSvc.RequestRefund(ctx, &order.Refund{
				WorkspaceID:      wsID,
				OrderID:          ord.OrderID,
				RefundType:       "partial",
				Amount:           tenantdb.MustParseExactDecimal("25000.000000"),
				Currency:         "VND",
				Reason:           "webhook refund",
				SourcePlatform:   "tiktok",
				ExternalRefundID: "ext-ref-dup-01",
			})
			if rErr != nil {
				errs <- rErr
			}
		}()
	}
	wg.Wait()
	close(errs)
	for e := range errs {
		t.Fatalf("unexpected error in concurrent external RequestRefund: %v", e)
	}
	allRefunds, _ = orderStore.ListRefundsByOrder(ctx, wsID, ord.OrderID)
	extCount := 0
	for _, r := range allRefunds {
		if r.ExternalRefundID == "ext-ref-dup-01" {
			extCount++
		}
	}
	if extCount != 1 {
		t.Fatalf("expected exactly 1 refund for ExternalRefundID ext-ref-dup-01, got %d", extCount)
	}
}

type selectiveFailFinanceService struct {
	mu               sync.Mutex
	delegate         order.FinanceService
	failRefundIDs    map[string]bool
	beforeRefundHook func(refundID string)
}

func (f *selectiveFailFinanceService) RecordOrderPosting(ctx context.Context, input finance.OrderPostingInput) error {
	return f.delegate.RecordOrderPosting(ctx, input)
}

func (f *selectiveFailFinanceService) RecordOrderCorrection(ctx context.Context, workspaceID, orderID, component string, newAmount tenantdb.ExactDecimal, newVersion, sourceClass, confidence string, fx finance.ExchangeRateSnapshot) error {
	return f.delegate.RecordOrderCorrection(ctx, workspaceID, orderID, component, newAmount, newVersion, sourceClass, confidence, fx)
}

func (f *selectiveFailFinanceService) RecordRefundPosting(ctx context.Context, workspaceID, refundID, orderID string, refundAmount tenantdb.ExactDecimal, currency string, sourceClass, confidence string, fx finance.ExchangeRateSnapshot) error {
	if f.beforeRefundHook != nil {
		f.beforeRefundHook(refundID)
	}
	f.mu.Lock()
	shouldFail := f.failRefundIDs[refundID]
	f.mu.Unlock()
	if shouldFail {
		return errors.New("simulated refund finance failure")
	}
	return f.delegate.RecordRefundPosting(ctx, workspaceID, refundID, orderID, refundAmount, currency, sourceClass, confidence, fx)
}

// F10: Concurrent refund approval rollback when one finance posting fails must NOT clobber
// another refund approval that succeeded concurrently.
func TestF10_ConcurrentRefundApprovalRollbackPreservesOtherRefunds(t *testing.T) {
	ctx := context.Background()
	orderSvc, _, orderStore, _, _ := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)

	wsID := "00000000-0000-0000-0000-000000000001"
	ord, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		Amount:         tenantdb.MustParseExactDecimal("100.000000"),
		Currency:       "VND",
		LifecycleState: order.StateCompleted,
	}, "")
	if err != nil {
		t.Fatalf("ingest order failed: %v", err)
	}

	ref1, _, err := orderSvc.RequestRefund(ctx, &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "partial",
		Amount:      tenantdb.MustParseExactDecimal("30.000000"),
		Currency:    "VND",
		Reason:      "refund 1 (will fail finance)",
	})
	if err != nil {
		t.Fatalf("request ref1 failed: %v", err)
	}
	ref2, _, err := orderSvc.RequestRefund(ctx, &order.Refund{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		RefundType:  "partial",
		Amount:      tenantdb.MustParseExactDecimal("40.000000"),
		Currency:    "VND",
		Reason:      "refund 2 (will succeed finance)",
	})
	if err != nil {
		t.Fatalf("request ref2 failed: %v", err)
	}

	ref1EnteredFinance := make(chan struct{})
	ref2Done := make(chan struct{})

	selFin := &selectiveFailFinanceService{
		delegate:      finSvc,
		failRefundIDs: map[string]bool{ref1.RefundID: true},
		beforeRefundHook: func(refundID string) {
			if refundID == ref1.RefundID {
				close(ref1EnteredFinance)
				<-ref2Done
			}
		},
	}
	orderSvc.SetFinance(selFin)

	var wg sync.WaitGroup
	wg.Add(2)
	go func() {
		defer wg.Done()
		_, _, _ = orderSvc.ApproveRefund(ctx, wsID, ref1.RefundID)
	}()
	go func() {
		defer wg.Done()
		<-ref1EnteredFinance
		if _, _, err := orderSvc.ApproveRefund(ctx, wsID, ref2.RefundID); err != nil {
			t.Errorf("expected ref2 ApproveRefund to succeed, got %v", err)
		}
		close(ref2Done)
	}()
	wg.Wait()

	finalOrd, err := orderStore.GetOrder(ctx, wsID, ord.OrderID)
	if err != nil {
		t.Fatalf("GetOrder failed: %v", err)
	}
	if finalOrd.RefundedAmount.String() != "40" {
		t.Fatalf("expected order RefundedAmount=40 after ref1 rollback and ref2 success, got %s", finalOrd.RefundedAmount.String())
	}
	if finalOrd.LifecycleState != order.StatePartiallyRefunded {
		t.Fatalf("expected order LifecycleState=partially_refunded, got %s", finalOrd.LifecycleState)
	}
	r1After, _ := orderStore.GetRefund(ctx, wsID, ref1.RefundID)
	r2After, _ := orderStore.GetRefund(ctx, wsID, ref2.RefundID)
	if r1After.LifecycleState != order.RefundRequested {
		t.Fatalf("expected ref1 reverted to requested, got %s", r1After.LifecycleState)
	}
	if r2After.LifecycleState != order.RefundCompleted {
		t.Fatalf("expected ref2 completed, got %s", r2After.LifecycleState)
	}
}

// F12: When IngestOrder receives a completed order and finance posting fails after stock fulfillment,
// retrying with the same external identity must NOT double-deduct stock and must complete the order.
func TestF12_CompletedOrderFinanceFailurePreservesStockAndReplayIdentityOnRetry(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, _, invStore, _ := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-F12-01"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline failed: %v", err)
	}

	// Inject finance failure on first ingest attempt
	orderSvc.SetFinance(&failingFinanceService{failOrderPosting: true})

	incoming := func() *order.Order {
		return &order.Order{
			WorkspaceID:     wsID,
			SourceClass:     order.SourceClassOfficial,
			SourcePlatform:  "tiktok",
			ExternalOrderID: "tt-ord-f12-001",
			LifecycleState:  order.StateCompleted,
			Amount:          tenantdb.MustParseExactDecimal("200000.000000"),
			Currency:        "VND",
			OrderedAt:       t0.Add(1 * time.Hour),
			Items: []order.OrderItem{
				{
					Sku:       skuID,
					Name:      "F12 Item",
					Quantity:  2,
					UnitPrice: tenantdb.MustParseExactDecimal("100000.000000"),
					Total:     tenantdb.MustParseExactDecimal("200000.000000"),
				},
			},
		}
	}

	if _, _, err := orderSvc.IngestOrder(ctx, incoming(), locID); err == nil {
		t.Fatalf("expected IngestOrder to fail when finance posting fails")
	}

	// Restore working finance service and retry ingest with same external identity
	orderSvc.SetFinance(finSvc)
	retriedOrd, _, err := orderSvc.IngestOrder(ctx, incoming(), locID)
	if err != nil {
		t.Fatalf("retry IngestOrder after finance recovery failed: %v", err)
	}
	if retriedOrd.LifecycleState != order.StateCompleted {
		t.Fatalf("expected retried order to be in StateCompleted, got %s", retriedOrd.LifecycleState)
	}

	bal, err := invStore.GetBalance(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("GetBalance failed: %v", err)
	}
	if bal.OnHand != 8 || bal.Reserved != 0 {
		t.Fatalf("expected OnHand=8, Reserved=0 (single deduction of 2 units), got OnHand=%d Reserved=%d", bal.OnHand, bal.Reserved)
	}

	postings, err := finStore.ListPostings(ctx, wsID, finance.PostingFilter{})
	if err != nil || len(postings) != 1 {
		t.Fatalf("expected 1 revenue posting after retry, got %d (err=%v)", len(postings), err)
	}
}

// Data #16: Concurrent CreateReturn calls and duplicate SKU lines in a single CreateReturn
// must never exceed sold quantity.
func TestData16_ConcurrentReturnCreationAndDuplicateSkuCannotExceedOrderedQty(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, orderStore, invStore, _ := setupTestHarness()

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-RET-RACE-01"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline failed: %v", err)
	}

	ord, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "shp-ret-race-001",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(1 * time.Hour),
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Name:      "Single Unit Item",
				Quantity:  1,
				UnitPrice: tenantdb.MustParseExactDecimal("100000.000000"),
				Total:     tenantdb.MustParseExactDecimal("100000.000000"),
			},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder failed: %v", err)
	}

	// 1. Single CreateReturn with duplicate SKU lines totaling 2 > 1 ordered must fail
	_, err = orderSvc.CreateReturn(ctx, &order.Return{
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		ReturnType:  "partial",
		Items: []order.ReturnItem{
			{Sku: skuID, Quantity: 1, Reason: "dup line 1"},
			{Sku: skuID, Quantity: 1, Reason: "dup line 2"},
		},
	})
	if !errors.Is(err, order.ErrReturnExceedsOrderQuantity) {
		t.Fatalf("expected ErrReturnExceedsOrderQuantity for duplicate SKU lines exceeding ordered qty, got %v", err)
	}

	// 2. Concurrent CreateReturn calls (10 goroutines each requesting 1 unit when only 1 unit was sold)
	const workers = 10
	var wg sync.WaitGroup
	successes := make(chan *order.Return, workers)
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			r, cErr := orderSvc.CreateReturn(ctx, &order.Return{
				WorkspaceID: wsID,
				OrderID:     ord.OrderID,
				ReturnType:  "full",
				Items: []order.ReturnItem{
					{Sku: skuID, Quantity: 1, Reason: "concurrent return"},
				},
			})
			if cErr == nil {
				successes <- r
			}
		}(i)
	}
	wg.Wait()
	close(successes)

	var createdReturns []*order.Return
	for r := range successes {
		createdReturns = append(createdReturns, r)
	}
	if len(createdReturns) != 1 {
		t.Fatalf("expected exactly 1 concurrent CreateReturn to succeed for 1 unit sold, got %d", len(createdReturns))
	}

	allRets, _ := orderStore.ListReturnsByOrder(ctx, wsID, ord.OrderID)
	if len(allRets) != 1 {
		t.Fatalf("expected 1 persisted return row, got %d", len(allRets))
	}

	if _, err := orderSvc.ReceiveReturn(ctx, wsID, createdReturns[0].ReturnID, locID); err != nil {
		t.Fatalf("ReceiveReturn failed: %v", err)
	}
	bal, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 10 {
		t.Fatalf("expected OnHand restored to 10 (9+1), got %d", bal.OnHand)
	}
}

// crashSimulatingInventoryService simulates a process crash or transient storage failure
// after parent order creation (before ReserveStock or before FulfillReservation) to test Billing R06.
type crashSimulatingInventoryService struct {
	inner       *inventory.Service
	failReserve bool
	failFulfill bool
}

func (c *crashSimulatingInventoryService) Store() inventory.Store {
	return c.inner.Store()
}

func (c *crashSimulatingInventoryService) ReserveStock(ctx context.Context, workspaceID, orderID string, items []inventory.ReservationItem, ttl time.Duration) ([]*inventory.Reservation, error) {
	if c.failReserve {
		return nil, errors.New("simulated crash before ReserveStock")
	}
	return c.inner.ReserveStock(ctx, workspaceID, orderID, items, ttl)
}

func (c *crashSimulatingInventoryService) FulfillReservation(ctx context.Context, workspaceID, orderID string) ([]*inventory.Movement, error) {
	if c.failFulfill {
		return nil, errors.New("simulated crash after ReserveStock before FulfillReservation")
	}
	return c.inner.FulfillReservation(ctx, workspaceID, orderID)
}

func (c *crashSimulatingInventoryService) ReleaseReservation(ctx context.Context, workspaceID, orderID, reason string) error {
	return c.inner.ReleaseReservation(ctx, workspaceID, orderID, reason)
}

func (c *crashSimulatingInventoryService) ShouldDeductStockForImportedOrder(ctx context.Context, workspaceID, skuID, locationID string, orderOrderedAt time.Time) (bool, error) {
	return c.inner.ShouldDeductStockForImportedOrder(ctx, workspaceID, skuID, locationID, orderOrderedAt)
}

func (c *crashSimulatingInventoryService) RecordPhysicalReturn(ctx context.Context, workspaceID, orderID, returnID, skuID, locationID string, quantity int32, reason string) (*inventory.Movement, error) {
	return c.inner.RecordPhysicalReturn(ctx, workspaceID, orderID, returnID, skuID, locationID, quantity, reason)
}

// nonDeletingOrderStore simulates a crash between CreateOrder and DeleteOrder rollback
// so the persisted parent order remains in the store when a crash occurs before stock effects complete.
type nonDeletingOrderStore struct {
	order.Store
	blockDelete         bool
	createdInitialState order.LifecycleState
}

func (n *nonDeletingOrderStore) CreateOrder(ctx context.Context, o *order.Order) error {
	if n.createdInitialState == "" {
		n.createdInitialState = o.LifecycleState
	}
	return n.Store.CreateOrder(ctx, o)
}

func (n *nonDeletingOrderStore) DeleteOrder(ctx context.Context, workspaceID, orderID string) error {
	if n.blockDelete {
		return errors.New("process crashed before rollback DeleteOrder could run")
	}
	return n.Store.DeleteOrder(ctx, workspaceID, orderID)
}

// Billing R06: Importing a completed (or fulfilled) order must NOT persist LifecycleState=fulfilled
// before stock reservation/fulfillment succeeds, and if a crash/restart leaves the parent order row
// persisted before stock effects complete, retrying IngestOrder across instances must recover stock
// deduction and finance postings idempotently without skipping stock deduction.
func TestR06_CrashAfterCreateOrderDoesNotSkipStockDeductionOnRetry(t *testing.T) {
	ctx := context.Background()
	_, invSvc, baseOrderStore, invStore, sink := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-R06-01"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline failed: %v", err)
	}

	crashStore := &nonDeletingOrderStore{Store: baseOrderStore, blockDelete: true}
	crashInv := &crashSimulatingInventoryService{inner: invSvc, failReserve: true}
	svcInstance1 := order.NewService(crashStore, crashInv, sink, func() time.Time { return t0.Add(2 * time.Hour) }).WithFinance(finSvc)

	makeCompletedOrder := func(extID string) *order.Order {
		return &order.Order{
			WorkspaceID:     wsID,
			SourceClass:     order.SourceClassOfficial,
			SourcePlatform:  "tiktok",
			ExternalOrderID: extID,
			LifecycleState:  order.StateCompleted,
			Amount:          tenantdb.MustParseExactDecimal("300000.000000"),
			Currency:        "VND",
			OrderedAt:       t0.Add(1 * time.Hour),
			Items: []order.OrderItem{
				{
					Sku:       skuID,
					Name:      "R06 Product",
					Quantity:  2,
					UnitPrice: tenantdb.MustParseExactDecimal("150000.000000"),
					Total:     tenantdb.MustParseExactDecimal("300000.000000"),
				},
			},
		}
	}

	// 1. First instance crashes right after CreateOrder (before ReserveStock runs)
	if _, _, err := svcInstance1.IngestOrder(ctx, makeCompletedOrder("tt-r06-crash-1"), locID); err == nil {
		t.Fatalf("expected simulated crash before ReserveStock to return error")
	}

	// Verify initial persisted state at CreateOrder was NOT prematurely StateFulfilled or StateCompleted
	if crashStore.createdInitialState == order.StateFulfilled || crashStore.createdInitialState == order.StateCompleted {
		t.Fatalf("R06 violation: CreateOrder persisted order in %s before stock effects executed", crashStore.createdInitialState)
	}

	// 2. Second instance (restart / cross-instance replay) retries IngestOrder for the same order
	svcInstance2 := order.NewService(baseOrderStore, invSvc, sink, func() time.Time { return t0.Add(2 * time.Hour) }).WithFinance(finSvc)
	recoveredOrd, _, err := svcInstance2.IngestOrder(ctx, makeCompletedOrder("tt-r06-crash-1"), locID)
	if err != nil {
		t.Fatalf("retry IngestOrder on instance 2 failed: %v", err)
	}
	if recoveredOrd.LifecycleState != order.StateCompleted {
		t.Fatalf("expected recovered order in StateCompleted, got %s", recoveredOrd.LifecycleState)
	}

	// Stock MUST be deducted (10 - 2 = 8), NOT skipped!
	bal, err := invStore.GetBalance(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("GetBalance failed: %v", err)
	}
	if bal.OnHand != 8 || bal.Reserved != 0 {
		t.Fatalf("R06 violation: expected OnHand=8 Reserved=0 after retry recovery, got OnHand=%d Reserved=%d", bal.OnHand, bal.Reserved)
	}

	// 3. Also test crash after ReserveStock but before FulfillReservation on a second order
	crashStore2 := &nonDeletingOrderStore{Store: baseOrderStore, blockDelete: true}
	crashInv2 := &crashSimulatingInventoryService{inner: invSvc, failFulfill: true}
	svcCrashMid := order.NewService(crashStore2, crashInv2, sink, func() time.Time { return t0.Add(2 * time.Hour) }).WithFinance(finSvc)
	if _, _, err := svcCrashMid.IngestOrder(ctx, makeCompletedOrder("tt-r06-crash-2"), locID); err == nil {
		t.Fatalf("expected simulated crash before FulfillReservation to return error")
	}

	recoveredOrd2, _, err := svcInstance2.IngestOrder(ctx, makeCompletedOrder("tt-r06-crash-2"), locID)
	if err != nil {
		t.Fatalf("retry IngestOrder for order 2 failed: %v", err)
	}
	if recoveredOrd2.LifecycleState != order.StateCompleted {
		t.Fatalf("expected order 2 in StateCompleted, got %s", recoveredOrd2.LifecycleState)
	}

	bal2, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if bal2.OnHand != 6 || bal2.Reserved != 0 {
		t.Fatalf("R06 violation: expected OnHand=6 Reserved=0 after second 2-unit order recovery, got OnHand=%d Reserved=%d", bal2.OnHand, bal2.Reserved)
	}

	// 4. Cross-instance replay of already completed order is idempotent (OnHand stays 6)
	replayed, created, err := svcInstance2.IngestOrder(ctx, makeCompletedOrder("tt-r06-crash-2"), locID)
	if err != nil || created || replayed.LifecycleState != order.StateCompleted {
		t.Fatalf("expected idempotent replay on completed order, got created=%v state=%s err=%v", created, replayed.LifecycleState, err)
	}
	bal3, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if bal3.OnHand != 6 || bal3.Reserved != 0 {
		t.Fatalf("expected OnHand=6 Reserved=0 after idempotent replay, got OnHand=%d Reserved=%d", bal3.OnHand, bal3.Reserved)
	}
}

// Billing R07: Cancelling a confirmed order (both created->confirmed->cancelled and ingest-confirmed->cancelled)
// must restore stock to initial on-hand with zero reserved hold, distinguish pre-fulfillment cancel
// restoration from physical customer return, and be idempotent on duplicate cancellation replay.
func TestR07_CancelConfirmedOrderRestoresStockAndReplayIsIdempotent(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, _, invStore, _ := setupTestHarness()

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-R07-01"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline failed: %v", err)
	}

	// Case 1: created -> confirmed -> cancelled
	ord1, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r07-ord-1",
		LifecycleState:  order.StateCreated,
		Amount:          tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(1 * time.Hour),
		Items: []order.OrderItem{
			{Sku: skuID, Name: "R07 Item", Quantity: 3, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder(created) failed: %v", err)
	}
	if _, err := orderSvc.ConfirmOrder(ctx, wsID, ord1.OrderID); err != nil {
		t.Fatalf("ConfirmOrder failed: %v", err)
	}
	if _, err := orderSvc.CancelOrder(ctx, wsID, ord1.OrderID, "buyer_cancelled_before_shipment"); err != nil {
		t.Fatalf("CancelOrder on confirmed order failed: %v", err)
	}

	bal1, err := invStore.GetBalance(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("GetBalance failed: %v", err)
	}
	if bal1.OnHand != 10 || bal1.Reserved != 0 {
		t.Fatalf("R07 violation (created->confirmed->cancelled): expected OnHand=10 Reserved=0, got OnHand=%d Reserved=%d", bal1.OnHand, bal1.Reserved)
	}

	// Replay cancellation must NOT add more stock
	if _, err := orderSvc.CancelOrder(ctx, wsID, ord1.OrderID, "duplicate_cancel_webhook"); err != nil {
		t.Fatalf("replay CancelOrder failed: %v", err)
	}
	bal1Replay, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if bal1Replay.OnHand != 10 || bal1Replay.Reserved != 0 {
		t.Fatalf("R07 violation on cancel replay: expected OnHand=10 Reserved=0, got OnHand=%d Reserved=%d", bal1Replay.OnHand, bal1Replay.Reserved)
	}

	// Case 2: ingest-confirmed -> cancelled
	ord2, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-r07-ord-2",
		LifecycleState:  order.StateConfirmed,
		Amount:          tenantdb.MustParseExactDecimal("400000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(2 * time.Hour),
		Items: []order.OrderItem{
			{Sku: skuID, Name: "R07 Item", Quantity: 4, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder(confirmed) failed: %v", err)
	}
	if _, err := orderSvc.CancelOrder(ctx, wsID, ord2.OrderID, "seller_cancelled_before_fulfillment"); err != nil {
		t.Fatalf("CancelOrder on ingest-confirmed order failed: %v", err)
	}

	bal2, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if bal2.OnHand != 10 || bal2.Reserved != 0 {
		t.Fatalf("R07 violation (ingest-confirmed->cancelled): expected OnHand=10 Reserved=0, got OnHand=%d Reserved=%d", bal2.OnHand, bal2.Reserved)
	}

	// Verify ledger reconciliation passes with zero discrepancy and no MovementReturn was fabricated
	rep, err := invSvc.ReconcileLedger(ctx, wsID, skuID, locID)
	if err != nil || rep.Discrepancy != 0 {
		t.Fatalf("expected zero ledger discrepancy after cancel compensation, got rep=%+v err=%v", rep, err)
	}
	movs, _, _ := invStore.ListMovements(ctx, wsID, skuID, locID, 100, 0)
	for _, m := range movs {
		if m.MovementType == inventory.MovementReturn {
			t.Fatalf("pre-fulfillment cancel must not record physical MovementReturn, found %+v", m)
		}
	}

	// Cancelled confirmed order must reject physical return creation
	if _, err := orderSvc.CreateReturn(ctx, &order.Return{
		WorkspaceID: wsID,
		OrderID:     ord2.OrderID,
		ReturnType:  "full",
		Items:       []order.ReturnItem{{Sku: skuID, Quantity: 1, Reason: "invalid return on cancelled order"}},
	}); !errors.Is(err, order.ErrInvalidReturnTransition) {
		t.Fatalf("expected ErrInvalidReturnTransition on cancelled order, got %v", err)
	}
}

// TestR08_OrderToAffiliateVerifierSyncAndConcurrentRefunds verifies end-to-end integration
// between order.Service and affiliate.Service: order completion, concurrent partial/full refunds,
// automatic commission clawback, payout exclusion, and reversible immutable ledger entries.
func TestR08_OrderToAffiliateVerifierSyncAndConcurrentRefunds(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, orderStore, invStore, sink := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	now := t0
	affStore := affiliate.NewMemoryStore()
	affLedger := affiliate.NewDefaultLedgerRecorder()
	affSvc := affiliate.NewService(affStore, affLedger, nil, func() time.Time { return now })

	orderSvc.WithFinance(finSvc).WithAffiliateVerifier(affSvc)

	wsID := "00000000-0000-0000-0000-000000000001"
	otherWS := "00000000-0000-0000-0000-000000000099"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-ORD-AFF-01"
	creatorID := "creator-ord-aff-01"

	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 20, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline: %v", err)
	}

	link, err := affSvc.CreateLink(ctx, &affiliate.AffiliateLink{
		WorkspaceID:    wsID,
		Platform:       "tiktok",
		OriginalURL:    "https://shop.tiktok.com/product/ord-aff-1",
		CommissionRate: tenantdb.MustParseExactDecimal("10.000000"),
	})
	if err != nil {
		t.Fatalf("CreateLink: %v", err)
	}

	// 1. Ingest completed order of 1,000,000 VND -> automatically syncs VerifiedOrder into affSvc
	ord, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         "ord-aff-sync-01",
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-ord-aff-sync-01",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(1 * time.Hour),
		Items: []order.OrderItem{
			{Sku: skuID, Name: "Synced Item", Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("500000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder: %v", err)
	}

	// 2. Calculate & confirm commission, then post to creator ledger
	comm, err := affSvc.CalculateCommission(ctx, wsID, link.AffiliateLinkID, ord.OrderID, &creatorID, tenantdb.MustParseExactDecimal("1000000.000000"), "VND", 15)
	if err != nil {
		t.Fatalf("CalculateCommission: %v", err)
	}
	now = now.Add(16 * 24 * time.Hour)
	if _, err := affSvc.ConfirmCommission(ctx, wsID, comm.CommissionID); err != nil {
		t.Fatalf("ConfirmCommission: %v", err)
	}
	initialPost, err := affSvc.PostCommissionToLedger(ctx, wsID, comm.CommissionID, affiliate.EconomicRoleCreator)
	if err != nil {
		t.Fatalf("PostCommissionToLedger: %v", err)
	}

	// 3. Fire concurrent partial refund requests & approvals across multiple order.Service instances
	orderSvc2 := order.NewService(orderStore, invSvc, sink, func() time.Time { return now }).WithFinance(finSvc).WithAffiliateVerifier(affSvc)
	ref1, _, err := orderSvc.RequestRefund(ctx, &order.Refund{
		RefundID:    "ref-sync-300k",
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		Amount:      tenantdb.MustParseExactDecimal("300000.000000"),
		Currency:    "VND",
		Reason:      "partial refund 1",
	})
	if err != nil {
		t.Fatalf("RequestRefund 1: %v", err)
	}

	var wg sync.WaitGroup
	wg.Add(2)
	go func() {
		defer wg.Done()
		_, _, _ = orderSvc.ApproveRefund(ctx, wsID, ref1.RefundID)
	}()
	go func() {
		defer wg.Done()
		_, _, _ = orderSvc2.ApproveRefund(ctx, wsID, ref1.RefundID)
	}()
	wg.Wait()

	// Verify commission was reduced from 100,000 to 70,000 and ledger has immutable reversal + replacement
	commAfterPartial, err := affStore.GetCommission(ctx, wsID, comm.CommissionID)
	if err != nil {
		t.Fatalf("GetCommission after partial refund: %v", err)
	}
	if commAfterPartial.CommissionAmount.Cmp(tenantdb.MustParseExactDecimal("70000.000000")) != 0 {
		t.Fatalf("expected commission reduced to 70000 after 300k refund, got %s", commAfterPartial.CommissionAmount.String())
	}
	ledgerEntries := affSvc.ListLedgerPostings(wsID, comm.CommissionID)
	if len(ledgerEntries) != 3 {
		t.Fatalf("expected 3 immutable ledger entries (initial +100k, reversal -100k, replacement +70k), got %d", len(ledgerEntries))
	}
	if ledgerEntries[1].ReversalOf == nil || *ledgerEntries[1].ReversalOf != initialPost.PostingID {
		t.Fatalf("expected 2nd ledger entry to reference initial posting %s via ReversalOf, got %+v", initialPost.PostingID, ledgerEntries[1])
	}

	// 4. Approve remaining 700,000 VND refund (full refund) -> commission clawed back, payout blocked
	ref2, _, err := orderSvc.RequestRefund(ctx, &order.Refund{
		RefundID:    "ref-sync-700k",
		WorkspaceID: wsID,
		OrderID:     ord.OrderID,
		Amount:      tenantdb.MustParseExactDecimal("700000.000000"),
		Currency:    "VND",
		Reason:      "remaining refund",
	})
	if err != nil {
		t.Fatalf("RequestRefund 2: %v", err)
	}
	if _, _, err := orderSvc.ApproveRefund(ctx, wsID, ref2.RefundID); err != nil {
		t.Fatalf("ApproveRefund 2: %v", err)
	}

	commAfterFull, _ := affStore.GetCommission(ctx, wsID, comm.CommissionID)
	if commAfterFull.Status != affiliate.CommissionClawedBack {
		t.Fatalf("expected commission clawed_back after full refund, got %s", commAfterFull.Status)
	}
	if _, err := affSvc.CreatePayoutBatch(ctx, wsID, creatorID, []string{comm.CommissionID}); !errors.Is(err, affiliate.ErrInvalidPayoutBatch) && !errors.Is(err, affiliate.ErrOrderIneligible) {
		t.Fatalf("expected CreatePayoutBatch on refunded order to fail closed, got %v", err)
	}

	// Verify net sum of immutable ledger entries for fully refunded order is 0
	finalLedger := affSvc.ListLedgerPostings(wsID, comm.CommissionID)
	netLedger := tenantdb.ZeroDecimal()
	for _, entry := range finalLedger {
		netLedger, _ = netLedger.Add(entry.Amount)
	}
	if !netLedger.IsZero() {
		t.Fatalf("expected net ledger balance 0 after full refund reversal, got %s", netLedger.String())
	}

	// 5. Negative security & tenant isolation checks
	if _, err := orderSvc.GetOrder(ctx, otherWS, ord.OrderID); !errors.Is(err, order.ErrOrderNotFound) {
		t.Fatalf("expected cross-tenant GetOrder to fail with ErrOrderNotFound, got %v", err)
	}
	if _, err := orderSvc.CancelOrder(ctx, otherWS, ord.OrderID, "cross-tenant-attack"); !errors.Is(err, order.ErrOrderNotFound) {
		t.Fatalf("expected cross-tenant CancelOrder to fail with ErrOrderNotFound, got %v", err)
	}
	if _, _, err := orderSvc.ApproveRefund(ctx, otherWS, ref2.RefundID); !errors.Is(err, order.ErrRefundNotFound) {
		t.Fatalf("expected cross-tenant ApproveRefund to fail with ErrRefundNotFound, got %v", err)
	}
	bal, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 18 {
		t.Fatalf("financial refunds must not restock physical inventory: expected OnHand=18, got %d", bal.OnHand)
	}
}

// Billing N02: Unfulfilled (created or un-deducted) orders, cancelled orders (including confirmed-then-cancelled),
// and historical pre-opening_at orders that never deducted stock must reject physical returns
// and must never fabricate inventory stock on ReceiveReturn.
func TestN02_UnfulfilledConfirmedAndUnsoldOrdersRejectReturnAndNeverFabricateStock(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, orderStore, invStore, _ := setupTestHarness()

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-N02-01"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline failed: %v", err)
	}

	// 1. Order in StateCreated (held reservation, not fulfilled -> OnHand=10, Reserved=2):
	// CreateReturn MUST fail with ErrInvalidReturnTransition.
	createdOrd, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-n02-created-1",
		LifecycleState:  order.StateCreated,
		Amount:          tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(1 * time.Hour),
		Items: []order.OrderItem{
			{Sku: skuID, Name: "N02 Item", Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder failed: %v", err)
	}
	if _, err := orderSvc.CreateReturn(ctx, &order.Return{
		WorkspaceID: wsID,
		OrderID:     createdOrd.OrderID,
		ReturnType:  "full",
		Items:       []order.ReturnItem{{Sku: skuID, Quantity: 2, Reason: "unfulfilled created return attempt"}},
	}); !errors.Is(err, order.ErrInvalidReturnTransition) {
		t.Fatalf("N02 violation: expected ErrInvalidReturnTransition when creating return on StateCreated order, got %v", err)
	}

	// 2. Confirm then Cancel the order before shipment (OnHand: 10 -> 8 -> 10 via mov_cancel_comp):
	// Return created before cancel MUST be rejected on ReceiveReturn, and CreateReturn after cancel MUST be rejected.
	if _, err := orderSvc.ConfirmOrder(ctx, wsID, createdOrd.OrderID); err != nil {
		t.Fatalf("ConfirmOrder failed: %v", err)
	}
	retBeforeCancel, err := orderSvc.CreateReturn(ctx, &order.Return{
		WorkspaceID: wsID,
		OrderID:     createdOrd.OrderID,
		ReturnType:  "full",
		Items:       []order.ReturnItem{{Sku: skuID, Quantity: 2, Reason: "return initiated before cancel"}},
	})
	if err != nil {
		t.Fatalf("CreateReturn on confirmed order failed: %v", err)
	}
	if _, err := orderSvc.CancelOrder(ctx, wsID, createdOrd.OrderID, "cancelled_before_shipment"); err != nil {
		t.Fatalf("CancelOrder failed: %v", err)
	}
	if _, err := orderSvc.ReceiveReturn(ctx, wsID, retBeforeCancel.ReturnID, locID); !errors.Is(err, order.ErrInvalidReturnTransition) {
		t.Fatalf("N02 violation: expected ErrInvalidReturnTransition when receiving return after pre-shipment cancel, got %v", err)
	}
	if _, err := orderSvc.CreateReturn(ctx, &order.Return{
		WorkspaceID: wsID,
		OrderID:     createdOrd.OrderID,
		ReturnType:  "full",
		Items:       []order.ReturnItem{{Sku: skuID, Quantity: 2, Reason: "return after cancel"}},
	}); !errors.Is(err, order.ErrInvalidReturnTransition) {
		t.Fatalf("N02 violation: expected ErrInvalidReturnTransition when creating return after cancel, got %v", err)
	}

	// 3. Historical order before opening_at (stock was NEVER deducted on ingest/complete -> OnHand remains 10)
	// must NOT fabricate stock via CreateReturn / ReceiveReturn!
	histOrd, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassImported,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-n02-hist-1",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("300000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(-24 * time.Hour), // Before opening baseline t0!
		Items: []order.OrderItem{
			{Sku: skuID, Name: "N02 Item", Quantity: 3, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder historical failed: %v", err)
	}
	balAfterHist, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if balAfterHist.OnHand != 10 {
		t.Fatalf("expected OnHand=10 after historical order import, got %d", balAfterHist.OnHand)
	}

	if _, err := orderSvc.CreateReturn(ctx, &order.Return{
		WorkspaceID: wsID,
		OrderID:     histOrd.OrderID,
		ReturnType:  "full",
		Items:       []order.ReturnItem{{Sku: skuID, Quantity: 3, Reason: "historical order return"}},
	}); !errors.Is(err, order.ErrInvalidReturnTransition) {
		t.Fatalf("N02 violation: expected ErrInvalidReturnTransition on historical order without sale deduction, got %v", err)
	}

	balFinal, _ := invStore.GetBalance(ctx, wsID, skuID, locID)
	if balFinal.OnHand != 10 || balFinal.Reserved != 0 {
		t.Fatalf("N02 violation: expected OnHand=10 Reserved=0 (no fabricated stock), got OnHand=%d Reserved=%d", balFinal.OnHand, balFinal.Reserved)
	}
	_ = orderStore
}

// Billing R06 extra coverage: If CreateOrder succeeds and ReserveStock crashes on a StateCreated order,
// subsequent ConfirmOrder -> FulfillOrder -> CompleteOrder (which do not pass locID) must recover the
// order's location from persisted metadata and deduct stock instead of falling back to 0000...0001 and skipping.
func TestR06_ConfirmFulfillCompleteAfterReserveCrashRecoversLocationAndDeductsStock(t *testing.T) {
	ctx := context.Background()
	_, invSvc, baseOrderStore, invStore, sink := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-R06-LOC-01"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline failed: %v", err)
	}

	crashStore := &nonDeletingOrderStore{Store: baseOrderStore, blockDelete: true}
	crashInv := &crashSimulatingInventoryService{inner: invSvc, failReserve: true}
	svcCrash := order.NewService(crashStore, crashInv, sink, func() time.Time { return t0.Add(2 * time.Hour) }).WithFinance(finSvc)

	ordID := "33333333-3333-4333-8333-333333333601"
	_, _, err := svcCrash.IngestOrder(ctx, &order.Order{
		OrderID:         ordID,
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r06-loc-1",
		LifecycleState:  order.StateCreated,
		Amount:          tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(1 * time.Hour),
		Items: []order.OrderItem{
			{Sku: skuID, Name: "R06 Loc Product", Quantity: 3, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err == nil {
		t.Fatalf("expected simulated crash on ReserveStock")
	}

	// Now a healthy service instance processes ConfirmOrder -> FulfillOrder -> CompleteOrder (without passing locID)
	svcHealthy := order.NewService(baseOrderStore, invSvc, sink, func() time.Time { return t0.Add(2 * time.Hour) }).WithFinance(finSvc)
	if _, err := svcHealthy.ConfirmOrder(ctx, wsID, ordID); err != nil {
		t.Fatalf("ConfirmOrder after crash recovery failed: %v", err)
	}
	if _, err := svcHealthy.FulfillOrder(ctx, wsID, ordID); err != nil {
		t.Fatalf("FulfillOrder after crash recovery failed: %v", err)
	}
	if _, err := svcHealthy.CompleteOrder(ctx, wsID, ordID); err != nil {
		t.Fatalf("CompleteOrder after crash recovery failed: %v", err)
	}

	bal, err := invStore.GetBalance(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("GetBalance failed: %v", err)
	}
	if bal.OnHand != 7 || bal.Reserved != 0 {
		t.Fatalf("R06 violation: expected OnHand=7 Reserved=0 after Confirm/Fulfill/Complete recovery, got OnHand=%d Reserved=%d", bal.OnHand, bal.Reserved)
	}
}

// Codex HIGH H04 & MEDIUM M02:
//   - Newer economic revisions on an order in the same lifecycle state (e.g. completed -> completed,
//     confirmed -> confirmed) must update order amounts/fees/items/timestamps, emit versioned correcting
//     finance postings (preserving idempotent replay and rejecting stale out-of-order revisions), and sync affiliate.
//   - PaymentFee must be included in initial order postings and preserved/corrected in UpdateFeeBreakdown.
func TestH04_SameLifecycleEconomicRevisionUpdatesOrderLedgerAndAffiliate(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, orderStore, _, _ := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	affStore := affiliate.NewMemoryStore()
	affSvc := affiliate.NewService(affStore, nil, nil, func() time.Time { return t0 })

	orderSvc.WithFinance(finSvc).WithAffiliateVerifier(affSvc)

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-H04-01"

	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 50, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline: %v", err)
	}

	t1 := t0.Add(1 * time.Hour)
	t2 := t0.Add(2 * time.Hour)
	t3 := t0.Add(3 * time.Hour)

	// 1. Ingest initial completed order at t1
	ordV1, created, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         "ord-h04-rev-1",
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-h04-rev-1",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t1,
		FeeBreakdown: order.FeeBreakdown{
			PlatformFee:         tenantdb.MustParseExactDecimal("50000.000000"),
			PaymentFee:          tenantdb.MustParseExactDecimal("10000.000000"),
			ShippingCost:        tenantdb.MustParseExactDecimal("20000.000000"),
			AffiliateCommission: tenantdb.MustParseExactDecimal("30000.000000"),
		},
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Name:      "H04 Item",
				Quantity:  2,
				UnitPrice: tenantdb.MustParseExactDecimal("500000.000000"),
				Total:     tenantdb.MustParseExactDecimal("1000000.000000"),
				UnitCogs:  tenantdb.MustParseExactDecimal("100000.000000"),
			},
		},
	}, locID)
	if err != nil || !created {
		t.Fatalf("initial IngestOrder failed: created=%v err=%v", created, err)
	}

	sumOrderLedger := func(orderID string) (tenantdb.ExactDecimal, int) {
		entries, err := finStore.ListPostings(ctx, wsID, finance.PostingFilter{
			OriginType: "order",
			OriginID:   orderID,
		})
		if err != nil {
			t.Fatalf("ListPostings: %v", err)
		}
		sum := tenantdb.ZeroDecimal()
		for _, e := range entries {
			sum, _ = sum.Add(e.Amount)
		}
		return sum, len(entries)
	}

	// Net v1 = 1,000,000 - (50,000 + 10,000) - 20,000 - 30,000 - 200,000 = 690,000
	netV1, countV1 := sumOrderLedger(ordV1.OrderID)
	if netV1.Cmp(tenantdb.MustParseExactDecimal("690000.000000")) != 0 {
		t.Fatalf("expected initial net ledger 690000.000000 (including PaymentFee), got %s (entries=%d)", netV1.String(), countV1)
	}

	// 2. Ingest newer revision at t2 in the SAME lifecycle state (completed -> completed)
	revisedPayload := &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-h04-rev-1",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("900000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t2,
		FeeBreakdown: order.FeeBreakdown{
			PlatformFee:         tenantdb.MustParseExactDecimal("45000.000000"),
			PaymentFee:          tenantdb.MustParseExactDecimal("12000.000000"),
			ShippingCost:        tenantdb.MustParseExactDecimal("25000.000000"),
			AffiliateCommission: tenantdb.MustParseExactDecimal("27000.000000"),
		},
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Name:      "H04 Item",
				Quantity:  2,
				UnitPrice: tenantdb.MustParseExactDecimal("450000.000000"),
				Total:     tenantdb.MustParseExactDecimal("900000.000000"),
				UnitCogs:  tenantdb.MustParseExactDecimal("110000.000000"),
			},
		},
	}
	ordV2, createdV2, err := orderSvc.IngestOrder(ctx, revisedPayload, locID)
	if err != nil || createdV2 {
		t.Fatalf("revised IngestOrder failed: created=%v err=%v", createdV2, err)
	}
	if ordV2.Amount.Cmp(tenantdb.MustParseExactDecimal("900000.000000")) != 0 {
		t.Fatalf("H04 violation: expected updated order Amount=900000.000000, got %s", ordV2.Amount.String())
	}
	if ordV2.FeeBreakdown.PlatformFee.Cmp(tenantdb.MustParseExactDecimal("45000.000000")) != 0 ||
		ordV2.FeeBreakdown.PaymentFee.Cmp(tenantdb.MustParseExactDecimal("12000.000000")) != 0 {
		t.Fatalf("H04 violation: expected updated FeeBreakdown (45k, 12k), got (%s, %s)",
			ordV2.FeeBreakdown.PlatformFee.String(), ordV2.FeeBreakdown.PaymentFee.String())
	}

	// Net v2 = 900,000 - (45,000 + 12,000) - 25,000 - 27,000 - 220,000 = 571,000
	netV2, countV2 := sumOrderLedger(ordV1.OrderID)
	if netV2.Cmp(tenantdb.MustParseExactDecimal("571000.000000")) != 0 {
		t.Fatalf("H04 violation: expected net ledger 571000.000000 after same-lifecycle revision, got %s (entries=%d)", netV2.String(), countV2)
	}

	// Verify Affiliate VerifiedOrder was synced with revised GrossAmount = 900,000
	verOrd, err := affStore.GetVerifiedOrder(ctx, wsID, ordV1.OrderID)
	if err != nil {
		t.Fatalf("GetVerifiedOrder: %v", err)
	}
	if verOrd.GrossAmount.Cmp(tenantdb.MustParseExactDecimal("900000.000000")) != 0 {
		t.Fatalf("H04 violation: expected affiliate VerifiedOrder GrossAmount=900000.000000, got %s", verOrd.GrossAmount.String())
	}

	// 3. Idempotent replay of the exact same t2 revision must NOT add duplicate ledger entries
	if _, _, err := orderSvc.IngestOrder(ctx, revisedPayload, locID); err != nil {
		t.Fatalf("replay revised IngestOrder: %v", err)
	}
	netReplay, countReplay := sumOrderLedger(ordV1.OrderID)
	if netReplay.Cmp(tenantdb.MustParseExactDecimal("571000.000000")) != 0 || countReplay != countV2 {
		t.Fatalf("expected idempotent replay to keep net=571000 and entries=%d, got net=%s entries=%d", countV2, netReplay.String(), countReplay)
	}

	// 4. Stale t1 revision (and untimestamped stale payload with different amount) must be ignored
	stalePayload := *revisedPayload
	stalePayload.SourceUpdatedAt = &t1
	stalePayload.Amount = tenantdb.MustParseExactDecimal("1000000.000000")
	ordAfterStale, _, err := orderSvc.IngestOrder(ctx, &stalePayload, locID)
	if err != nil {
		t.Fatalf("stale IngestOrder: %v", err)
	}
	if ordAfterStale.Amount.Cmp(tenantdb.MustParseExactDecimal("900000.000000")) != 0 {
		t.Fatalf("stale webhook overwrote newer revision: got %s", ordAfterStale.Amount.String())
	}

	// 5. Third revision at t3 changing Amount to 950,000 must advance to v3 and update ledger
	rev3Payload := *revisedPayload
	rev3Payload.SourceUpdatedAt = &t3
	rev3Payload.Amount = tenantdb.MustParseExactDecimal("950000.000000")
	if _, _, err := orderSvc.IngestOrder(ctx, &rev3Payload, locID); err != nil {
		t.Fatalf("rev3 IngestOrder: %v", err)
	}
	netV3, _ := sumOrderLedger(ordV1.OrderID)
	if netV3.Cmp(tenantdb.MustParseExactDecimal("621000.000000")) != 0 {
		t.Fatalf("expected net ledger 621000.000000 after rev3, got %s", netV3.String())
	}

	// 6. UpdateFeeBreakdown must preserve PaymentFee when PlatformFee updates, and handle PaymentFee-only updates
	_, err = orderSvc.UpdateFeeBreakdown(ctx, wsID, ordV1.OrderID, order.FeeBreakdown{
		PlatformFee:         tenantdb.MustParseExactDecimal("45000.000000"),
		PaymentFee:          tenantdb.MustParseExactDecimal("20000.000000"), // +8,000 fee increase
		ShippingCost:        tenantdb.MustParseExactDecimal("25000.000000"),
		AffiliateCommission: tenantdb.MustParseExactDecimal("27000.000000"),
	}, "v4-fees", "ev-fee-1", "payment gateway settlement adjustment")
	if err != nil {
		t.Fatalf("UpdateFeeBreakdown failed: %v", err)
	}
	netAfterFeeUpdate, _ := sumOrderLedger(ordV1.OrderID)
	if netAfterFeeUpdate.Cmp(tenantdb.MustParseExactDecimal("613000.000000")) != 0 {
		t.Fatalf("M02 violation: expected net ledger 613000.000000 after PaymentFee update, got %s", netAfterFeeUpdate.String())
	}

	// 7. Same-lifecycle revision on an unrecognized order (confirmed -> confirmed) followed by completion
	ordConf, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         "ord-h04-conf-1",
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-h04-conf-1",
		LifecycleState:  order.StateConfirmed,
		Amount:          tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t1,
		FeeBreakdown: order.FeeBreakdown{
			PlatformFee: tenantdb.MustParseExactDecimal("20000.000000"),
			PaymentFee:  tenantdb.MustParseExactDecimal("5000.000000"),
		},
		Items: []order.OrderItem{
			{Sku: skuID, Name: "Conf Item", Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("500000.000000"), UnitCogs: tenantdb.MustParseExactDecimal("80000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder confirmed: %v", err)
	}
	// Revise while still in StateConfirmed at t2
	if _, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-h04-conf-1",
		LifecycleState:  order.StateConfirmed,
		Amount:          tenantdb.MustParseExactDecimal("450000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t2,
		FeeBreakdown: order.FeeBreakdown{
			PlatformFee: tenantdb.MustParseExactDecimal("18000.000000"),
			PaymentFee:  tenantdb.MustParseExactDecimal("4000.000000"),
		},
		Items: []order.OrderItem{
			{Sku: skuID, Name: "Conf Item", Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("450000.000000"), UnitCogs: tenantdb.MustParseExactDecimal("80000.000000")},
		},
	}, locID); err != nil {
		t.Fatalf("IngestOrder confirmed revision: %v", err)
	}
	if _, err := orderSvc.FulfillOrder(ctx, wsID, ordConf.OrderID); err != nil {
		t.Fatalf("FulfillOrder: %v", err)
	}
	if _, err := orderSvc.CompleteOrder(ctx, wsID, ordConf.OrderID); err != nil {
		t.Fatalf("CompleteOrder: %v", err)
	}
	// Net = 450,000 - (18,000 + 4,000) - 80,000 = 348,000
	netConfCompleted, _ := sumOrderLedger(ordConf.OrderID)
	if netConfCompleted.Cmp(tenantdb.MustParseExactDecimal("348000.000000")) != 0 {
		t.Fatalf("expected net ledger 348000.000000 after completing revised confirmed order, got %s", netConfCompleted.String())
	}
	_ = orderStore
}

// Codex Round-03 HIGH N02:
// Order revisions that change item quantity or add/remove SKUs must reconcile stock holds (StateCreated)
// and stock deductions/movements (StateConfirmed/StateFulfilled/StateCompleted), fail closed on insufficient
// stock without mutating order items, and keep CancelOrder and CreateReturn/ReceiveReturn consistent with
// revised item quantities.
func TestRound03_N02_OrderRevisionReconcilesInventoryOnSkuAndQuantityChanges(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, _, invStore, _ := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)
	orderSvc.WithFinance(finSvc)

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuA := "SKU-R03-N02-A"
	skuB := "SKU-R03-N02-B"
	skuC := "SKU-R03-N02-C"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	for _, sku := range []string{skuA, skuB, skuC} {
		if err := invSvc.RecordOpeningBaseline(ctx, wsID, sku, locID, 10, t0); err != nil {
			t.Fatalf("RecordOpeningBaseline(%s): %v", sku, err)
		}
	}

	t1 := t0.Add(1 * time.Hour)
	t2 := t0.Add(2 * time.Hour)
	t3 := t0.Add(3 * time.Hour)
	t4 := t0.Add(4 * time.Hour)

	// Part 1: StateCreated order item revision (held reservations)
	createdOrd, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         "ord-r03-n02-created",
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n02-created",
		LifecycleState:  order.StateCreated,
		Amount:          tenantdb.MustParseExactDecimal("300000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t1,
		Items: []order.OrderItem{
			{Sku: skuA, Name: "Item A", Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
			{Sku: skuB, Name: "Item B", Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder created v1: %v", err)
	}

	// Revise StateCreated order at t2: SKU-A 2->4, SKU-B removed, SKU-C added qty=3
	if _, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n02-created",
		LifecycleState:  order.StateCreated,
		Amount:          tenantdb.MustParseExactDecimal("700000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t2,
		Items: []order.OrderItem{
			{Sku: skuA, Name: "Item A", Quantity: 4, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
			{Sku: skuC, Name: "Item C", Quantity: 3, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID); err != nil {
		t.Fatalf("IngestOrder created v2: %v", err)
	}

	balA, _ := invStore.GetBalance(ctx, wsID, skuA, locID)
	balB, _ := invStore.GetBalance(ctx, wsID, skuB, locID)
	balC, _ := invStore.GetBalance(ctx, wsID, skuC, locID)
	if balA.Reserved != 4 || balB.Reserved != 0 || balC.Reserved != 3 {
		t.Fatalf("N02 created revision: expected Reserved=(4,0,3), got (%d,%d,%d)", balA.Reserved, balB.Reserved, balC.Reserved)
	}

	// Negative test: Revise StateCreated order at t3 requesting 15 units of SKU-A (only 10 OnHand) -> fail closed
	if _, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n02-created",
		LifecycleState:  order.StateCreated,
		Amount:          tenantdb.MustParseExactDecimal("1500000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t3,
		Items: []order.OrderItem{
			{Sku: skuA, Name: "Item A", Quantity: 15, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID); !errors.Is(err, inventory.ErrInsufficientStock) {
		t.Fatalf("expected ErrInsufficientStock on oversold created revision, got %v", err)
	}
	if _, err := orderSvc.CancelOrder(ctx, wsID, createdOrd.OrderID, "cancel_created_revised"); err != nil {
		t.Fatalf("CancelOrder created: %v", err)
	}
	for _, sku := range []string{skuA, skuB, skuC} {
		b, _ := invStore.GetBalance(ctx, wsID, sku, locID)
		if b.OnHand != 10 || b.Reserved != 0 {
			t.Fatalf("expected OnHand=10 Reserved=0 for %s after cancelling created order, got OnHand=%d Reserved=%d", sku, b.OnHand, b.Reserved)
		}
	}

	// Part 2: StateConfirmed order item revision (consumed reservations + stock movements)
	confOrd, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         "ord-r03-n02-confirmed",
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-r03-n02-confirmed",
		LifecycleState:  order.StateConfirmed,
		Amount:          tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t1,
		Items: []order.OrderItem{
			{Sku: skuA, Name: "Item A", Quantity: 3, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
			{Sku: skuB, Name: "Item B", Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder confirmed v1: %v", err)
	}

	// Revise StateConfirmed order at t2: SKU-A 3->1, SKU-B (2) removed, SKU-C added qty=4
	revConfPayload := &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-r03-n02-confirmed",
		LifecycleState:  order.StateConfirmed,
		Amount:          tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t2,
		Items: []order.OrderItem{
			{Sku: skuA, Name: "Item A", Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
			{Sku: skuC, Name: "Item C", Quantity: 4, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}
	if _, _, err := orderSvc.IngestOrder(ctx, revConfPayload, locID); err != nil {
		t.Fatalf("IngestOrder confirmed v2: %v", err)
	}

	balA, _ = invStore.GetBalance(ctx, wsID, skuA, locID)
	balB, _ = invStore.GetBalance(ctx, wsID, skuB, locID)
	balC, _ = invStore.GetBalance(ctx, wsID, skuC, locID)
	if balA.OnHand != 9 || balB.OnHand != 10 || balC.OnHand != 6 {
		t.Fatalf("N02 confirmed revision violation: expected OnHand=(9,10,6), got (%d,%d,%d)", balA.OnHand, balB.OnHand, balC.OnHand)
	}
	if balA.Reserved != 0 || balB.Reserved != 0 || balC.Reserved != 0 {
		t.Fatalf("N02 confirmed revision violation: expected Reserved=(0,0,0), got (%d,%d,%d)", balA.Reserved, balB.Reserved, balC.Reserved)
	}

	// Idempotent replay of t2 revision must keep OnHand=(9,10,6)
	if _, _, err := orderSvc.IngestOrder(ctx, revConfPayload, locID); err != nil {
		t.Fatalf("replay confirmed v2: %v", err)
	}
	balA, _ = invStore.GetBalance(ctx, wsID, skuA, locID)
	balB, _ = invStore.GetBalance(ctx, wsID, skuB, locID)
	balC, _ = invStore.GetBalance(ctx, wsID, skuC, locID)
	if balA.OnHand != 9 || balB.OnHand != 10 || balC.OnHand != 6 {
		t.Fatalf("N02 replay violation: expected OnHand=(9,10,6), got (%d,%d,%d)", balA.OnHand, balB.OnHand, balC.OnHand)
	}

	// Negative test: Revise StateConfirmed order at t3 requesting 12 units of SKU-C (exceeds 10 total stock) -> fail closed
	if _, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-r03-n02-confirmed",
		LifecycleState:  order.StateConfirmed,
		Amount:          tenantdb.MustParseExactDecimal("1300000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t3,
		Items: []order.OrderItem{
			{Sku: skuA, Name: "Item A", Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
			{Sku: skuC, Name: "Item C", Quantity: 12, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID); !errors.Is(err, inventory.ErrInsufficientStock) {
		t.Fatalf("expected ErrInsufficientStock on oversold confirmed revision, got %v", err)
	}
	persistedAfterReject, _ := orderSvc.GetOrder(ctx, wsID, confOrd.OrderID)
	if len(persistedAfterReject.Items) != 2 || persistedAfterReject.Items[1].Quantity != 4 {
		t.Fatalf("failed revision must not overwrite persisted order items, got %+v", persistedAfterReject.Items)
	}

	// Forward transition + revision at t4 to StateCompleted: SKU-A 1->2, SKU-C 4->3
	if _, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "shopee",
		ExternalOrderID: "sp-r03-n02-confirmed",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t4,
		Items: []order.OrderItem{
			{Sku: skuA, Name: "Item A", Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
			{Sku: skuC, Name: "Item C", Quantity: 3, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID); err != nil {
		t.Fatalf("IngestOrder completed v4: %v", err)
	}

	balA, _ = invStore.GetBalance(ctx, wsID, skuA, locID)
	balB, _ = invStore.GetBalance(ctx, wsID, skuB, locID)
	balC, _ = invStore.GetBalance(ctx, wsID, skuC, locID)
	if balA.OnHand != 8 || balB.OnHand != 10 || balC.OnHand != 7 {
		t.Fatalf("N02 completed revision violation: expected OnHand=(8,10,7), got (%d,%d,%d)", balA.OnHand, balB.OnHand, balC.OnHand)
	}

	// Physical return checks after revision:
	// Returning 3 units of SKU-A (the old v1 quantity!) must fail because revised order only has 2 units of SKU-A.
	if _, err := orderSvc.CreateReturn(ctx, &order.Return{
		WorkspaceID: wsID,
		OrderID:     confOrd.OrderID,
		ReturnType:  "partial",
		Items:       []order.ReturnItem{{Sku: skuA, Quantity: 3, Reason: "stale quantity return"}},
	}); !errors.Is(err, order.ErrReturnExceedsOrderQuantity) {
		t.Fatalf("expected ErrReturnExceedsOrderQuantity for stale SKU-A qty=3, got %v", err)
	}
	// Returning 3 units of SKU-C (the revised v4 quantity, which was not in v1!) must succeed and restock SKU-C to 10.
	retC, err := orderSvc.CreateReturn(ctx, &order.Return{
		WorkspaceID: wsID,
		OrderID:     confOrd.OrderID,
		ReturnType:  "partial",
		Items:       []order.ReturnItem{{Sku: skuC, Quantity: 3, Reason: "return revised SKU-C"}},
	})
	if err != nil {
		t.Fatalf("CreateReturn for revised SKU-C qty=3 failed: %v", err)
	}
	if _, err := orderSvc.ReceiveReturn(ctx, wsID, retC.ReturnID, locID); err != nil {
		t.Fatalf("ReceiveReturn for revised SKU-C qty=3 failed: %v", err)
	}
	balC, _ = invStore.GetBalance(ctx, wsID, skuC, locID)
	if balC.OnHand != 10 {
		t.Fatalf("expected SKU-C OnHand=10 after physical return of revised item, got %d", balC.OnHand)
	}

	// Part 3: CancelOrder on a revised confirmed order must only compensate active consumed items
	confCancelOrd, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         "ord-r03-n02-cancel-conf",
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n02-cancel-conf",
		LifecycleState:  order.StateConfirmed,
		Amount:          tenantdb.MustParseExactDecimal("300000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t1,
		Items: []order.OrderItem{
			{Sku: skuB, Name: "Item B", Quantity: 3, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder cancel-conf v1: %v", err)
	}
	// Revise to replace SKU-B (3) with SKU-C (2) before cancellation
	if _, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n02-cancel-conf",
		LifecycleState:  order.StateConfirmed,
		Amount:          tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t2,
		Items: []order.OrderItem{
			{Sku: skuC, Name: "Item C", Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID); err != nil {
		t.Fatalf("IngestOrder cancel-conf v2: %v", err)
	}
	if _, err := orderSvc.CancelOrder(ctx, wsID, confCancelOrd.OrderID, "cancel_after_sku_swap"); err != nil {
		t.Fatalf("CancelOrder after sku swap: %v", err)
	}
	balB, _ = invStore.GetBalance(ctx, wsID, skuB, locID)
	balC, _ = invStore.GetBalance(ctx, wsID, skuC, locID)
	if balB.OnHand != 10 || balC.OnHand != 10 {
		t.Fatalf("expected SKU-B=10 and SKU-C=10 after cancel of revised confirmed order, got B=%d C=%d", balB.OnHand, balC.OnHand)
	}

	// Verify ledger reconciliation across all three SKUs
	for _, sku := range []string{skuA, skuB, skuC} {
		rep, err := invSvc.ReconcileLedger(ctx, wsID, sku, locID)
		if err != nil || rep.Discrepancy != 0 {
			t.Fatalf("ReconcileLedger(%s) discrepancy: rep=%+v err=%v", sku, rep, err)
		}
	}
}

// Codex Round-03 MEDIUM N04:
// An order revision whose fee breakdown fields or tax amount are explicitly set to 0 ("0.000000")
// must update the persisted order and emit a 0-amount correction in Finance (reversing prior fees),
// while an omitted zero-value struct preserves existing values.
func TestRound03_N04_OrderRevisionWithAllZeroFeesUpdatesOrderAndFinanceLedger(t *testing.T) {
	ctx := context.Background()
	orderSvc, invSvc, _, _, _ := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)
	orderSvc.WithFinance(finSvc)

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-R03-N04-01"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 20, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline: %v", err)
	}

	t1 := t0.Add(1 * time.Hour)
	t2 := t0.Add(2 * time.Hour)
	t3 := t0.Add(3 * time.Hour)

	ord, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         "ord-r03-n04-1",
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n04-1",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("500000.000000"),
		TaxAmount:       tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t1,
		FeeBreakdown: order.FeeBreakdown{
			PlatformFee:         tenantdb.MustParseExactDecimal("25000.000000"),
			PaymentFee:          tenantdb.MustParseExactDecimal("5000.000000"),
			ShippingCost:        tenantdb.MustParseExactDecimal("15000.000000"),
			AffiliateCommission: tenantdb.MustParseExactDecimal("10000.000000"),
		},
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Name:      "N04 Item",
				Quantity:  1,
				UnitPrice: tenantdb.MustParseExactDecimal("500000.000000"),
				Total:     tenantdb.MustParseExactDecimal("500000.000000"),
				UnitCogs:  tenantdb.MustParseExactDecimal("80000.000000"),
			},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder v1: %v", err)
	}

	sumOrderLedger := func(orderID string) tenantdb.ExactDecimal {
		entries, err := finStore.ListPostings(ctx, wsID, finance.PostingFilter{
			OriginType: "order",
			OriginID:   orderID,
		})
		if err != nil {
			t.Fatalf("ListPostings: %v", err)
		}
		sum := tenantdb.ZeroDecimal()
		for _, e := range entries {
			sum, _ = sum.Add(e.Amount)
		}
		return sum
	}

	// Net v1 = 500,000 - (25,000 + 5,000) - 15,000 - 10,000 - 80,000 = 365,000
	if got := sumOrderLedger(ord.OrderID); got.Cmp(tenantdb.MustParseExactDecimal("365000.000000")) != 0 {
		t.Fatalf("expected v1 net ledger 365000.000000, got %s", got.String())
	}

	// Revision at t2 where all fees and TaxAmount are explicitly zeroed ("0.000000")
	zero := tenantdb.MustParseExactDecimal("0.000000")
	ordV2, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n04-1",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("500000.000000"),
		TaxAmount:       zero,
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t2,
		FeeBreakdown: order.FeeBreakdown{
			PlatformFee:         zero,
			PaymentFee:          zero,
			ShippingCost:        zero,
			AffiliateCommission: zero,
		},
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Name:      "N04 Item",
				Quantity:  1,
				UnitPrice: tenantdb.MustParseExactDecimal("500000.000000"),
				Total:     tenantdb.MustParseExactDecimal("500000.000000"),
				UnitCogs:  tenantdb.MustParseExactDecimal("80000.000000"),
			},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder v2 (all-zero fees): %v", err)
	}

	if !ordV2.FeeBreakdown.PlatformFee.IsZero() ||
		!ordV2.FeeBreakdown.PaymentFee.IsZero() ||
		!ordV2.FeeBreakdown.ShippingCost.IsZero() ||
		!ordV2.FeeBreakdown.AffiliateCommission.IsZero() ||
		!ordV2.TaxAmount.IsZero() {
		t.Fatalf("N04 violation: expected all zero fees and tax after explicit 0 revision, got fees=%+v tax=%s",
			ordV2.FeeBreakdown, ordV2.TaxAmount.String())
	}

	// Net v2 = 500,000 - 0 - 0 - 0 - 80,000 = 420,000
	if got := sumOrderLedger(ord.OrderID); got.Cmp(tenantdb.MustParseExactDecimal("420000.000000")) != 0 {
		t.Fatalf("N04 violation: expected v2 net ledger 420000.000000 after zeroing fees, got %s", got.String())
	}

	// Set PlatformFee back to 10,000 via UpdateFeeBreakdown, then send a t3 revision with omitted FeeBreakdown{}
	if _, err := orderSvc.UpdateFeeBreakdown(ctx, wsID, ord.OrderID, order.FeeBreakdown{
		PlatformFee: tenantdb.MustParseExactDecimal("10000.000000"),
	}, "v2b", "ev-n04-1", "reintroduce platform fee"); err != nil {
		t.Fatalf("UpdateFeeBreakdown: %v", err)
	}
	ordV3, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n04-1",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("490000.000000"),
		Currency:        "VND",
		OrderedAt:       t1,
		SourceUpdatedAt: &t3,
		// FeeBreakdown omitted (zero-value struct)
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Name:      "N04 Item",
				Quantity:  1,
				UnitPrice: tenantdb.MustParseExactDecimal("490000.000000"),
				Total:     tenantdb.MustParseExactDecimal("490000.000000"),
			},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder v3 (omitted fees): %v", err)
	}
	if ordV3.FeeBreakdown.PlatformFee.Cmp(tenantdb.MustParseExactDecimal("10000.000000")) != 0 {
		t.Fatalf("expected omitted FeeBreakdown to preserve PlatformFee=10000.000000, got %s", ordV3.FeeBreakdown.PlatformFee.String())
	}
}

type failingCorrectionFinanceRecorder struct {
	inner           order.FinanceService
	failOnCall      int
	correctionCalls int
}

func (f *failingCorrectionFinanceRecorder) RecordOrderPosting(ctx context.Context, input finance.OrderPostingInput) error {
	return f.inner.RecordOrderPosting(ctx, input)
}

func (f *failingCorrectionFinanceRecorder) RecordRefundPosting(ctx context.Context, workspaceID, refundID, orderID string, refundAmount tenantdb.ExactDecimal, currency string, sourceClass, confidence string, fx finance.ExchangeRateSnapshot) error {
	return f.inner.RecordRefundPosting(ctx, workspaceID, refundID, orderID, refundAmount, currency, sourceClass, confidence, fx)
}

func (f *failingCorrectionFinanceRecorder) RecordOrderCorrection(ctx context.Context, workspaceID, orderID, component string, newAmount tenantdb.ExactDecimal, newVersion, sourceClass, confidence string, fx finance.ExchangeRateSnapshot) error {
	f.correctionCalls++
	if f.failOnCall > 0 && f.correctionCalls >= f.failOnCall {
		return errors.New("simulated finance correction crash")
	}
	return f.inner.RecordOrderCorrection(ctx, workspaceID, orderID, component, newAmount, newVersion, sourceClass, confidence, fx)
}

type crashAfterFirstUpdateOrderStore struct {
	order.Store
	updateCalls   int
	blockRollback bool
}

func (s *crashAfterFirstUpdateOrderStore) UpdateOrder(ctx context.Context, o *order.Order) error {
	s.updateCalls++
	if s.blockRollback && s.updateCalls > 1 {
		return errors.New("process crashed before rollback UpdateOrder could run")
	}
	return s.Store.UpdateOrder(ctx, o)
}

// Codex Round-03 HIGH N03:
// If UpdateFeeBreakdown crashes after persisting o.FeeBreakdown to the order store (before rollbackFees
// can run, or midway between component corrections), retrying UpdateFeeBreakdown with the same target fees
// must still emit the missing Finance correction postings and converge the ledger.
func TestRound03_N03_CrashAfterUpdateFeeBreakdownRecoversFinanceCorrectionOnRetry(t *testing.T) {
	ctx := context.Background()
	_, invSvc, orderStore, _, sink := setupTestHarness()
	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, nil)

	wsID := "00000000-0000-0000-0000-000000000001"
	locID := "00000000-0000-0000-0000-000000000010"
	skuID := "SKU-R03-N03-01"

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 20, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline: %v", err)
	}

	svcHealthy := order.NewService(orderStore, invSvc, sink, func() time.Time { return t0.Add(2 * time.Hour) }).WithFinance(finSvc)
	ord, _, err := svcHealthy.IngestOrder(ctx, &order.Order{
		OrderID:         "ord-r03-n03-1",
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n03-1",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(1 * time.Hour),
		FeeBreakdown: order.FeeBreakdown{
			PlatformFee:         tenantdb.MustParseExactDecimal("20000.000000"),
			PaymentFee:          tenantdb.MustParseExactDecimal("5000.000000"),
			ShippingCost:        tenantdb.MustParseExactDecimal("10000.000000"),
			AffiliateCommission: tenantdb.MustParseExactDecimal("15000.000000"),
		},
		Items: []order.OrderItem{
			{Sku: skuID, Name: "N03 Item", Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("500000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder: %v", err)
	}

	targetFees := order.FeeBreakdown{
		PlatformFee:         tenantdb.MustParseExactDecimal("30000.000000"),
		PaymentFee:          tenantdb.MustParseExactDecimal("8000.000000"),
		ShippingCost:        tenantdb.MustParseExactDecimal("12000.000000"),
		AffiliateCommission: tenantdb.MustParseExactDecimal("18000.000000"),
	}

	// Simulate process crash after initial UpdateOrder commit and 1st component correction (before rollback can run)
	crashStore := &crashAfterFirstUpdateOrderStore{Store: orderStore, blockRollback: true}
	crashFin := &failingCorrectionFinanceRecorder{inner: finSvc, failOnCall: 2}
	svcCrash := order.NewService(crashStore, invSvc, sink, func() time.Time { return t0.Add(2 * time.Hour) }).WithFinance(crashFin)
	if _, err := svcCrash.UpdateFeeBreakdown(ctx, wsID, ord.OrderID, targetFees, "v2-settlement", "ev-n03-1", "settlement update"); err == nil {
		t.Fatalf("expected UpdateFeeBreakdown to fail when finance correction crashes")
	}

	// Retry exact same UpdateFeeBreakdown call on healthy service instance
	if _, err := svcHealthy.UpdateFeeBreakdown(ctx, wsID, ord.OrderID, targetFees, "v2-settlement", "ev-n03-1", "settlement update"); err != nil {
		t.Fatalf("retry UpdateFeeBreakdown on healthy service failed: %v", err)
	}

	// Net must be 500,000 - (30,000 + 8,000) - 12,000 - 18,000 = 432,000
	entries, err := finStore.ListPostings(ctx, wsID, finance.PostingFilter{
		OriginType: "order",
		OriginID:   ord.OrderID,
	})
	if err != nil {
		t.Fatalf("ListPostings: %v", err)
	}
	net := tenantdb.ZeroDecimal()
	for _, e := range entries {
		net, _ = net.Add(e.Amount)
	}
	if net.Cmp(tenantdb.MustParseExactDecimal("432000.000000")) != 0 {
		t.Fatalf("N03 violation: expected net ledger 432000.000000 after retry recovery, got %s", net.String())
	}

	// Also verify crash midway through IngestOrder revision (applyOrderEconomicRevision) recovers on retry
	t2 := t0.Add(3 * time.Hour)
	revPayload := &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  "tiktok",
		ExternalOrderID: "tt-r03-n03-1",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("550000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(1 * time.Hour),
		SourceUpdatedAt: &t2,
		FeeBreakdown: order.FeeBreakdown{
			PlatformFee:         tenantdb.MustParseExactDecimal("35000.000000"),
			PaymentFee:          tenantdb.MustParseExactDecimal("5000.000000"),
			ShippingCost:        tenantdb.MustParseExactDecimal("15000.000000"),
			AffiliateCommission: tenantdb.MustParseExactDecimal("20000.000000"),
		},
		Items: []order.OrderItem{
			{Sku: skuID, Name: "N03 Item", Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("550000.000000")},
		},
	}
	crashFin2 := &failingCorrectionFinanceRecorder{inner: finSvc, failOnCall: 2}
	svcCrash2 := order.NewService(orderStore, invSvc, sink, func() time.Time { return t2 }).WithFinance(crashFin2)
	if _, _, err := svcCrash2.IngestOrder(ctx, revPayload, locID); err == nil {
		t.Fatalf("expected IngestOrder revision to fail when finance correction crashes")
	}
	if _, _, err := svcHealthy.IngestOrder(ctx, revPayload, locID); err != nil {
		t.Fatalf("retry IngestOrder revision on healthy service failed: %v", err)
	}
	// Net must be 550,000 - (35,000 + 5,000) - 15,000 - 20,000 = 475,000
	entries2, _ := finStore.ListPostings(ctx, wsID, finance.PostingFilter{
		OriginType: "order",
		OriginID:   ord.OrderID,
	})
	net2 := tenantdb.ZeroDecimal()
	for _, e := range entries2 {
		net2, _ = net2.Add(e.Amount)
	}
	if net2.Cmp(tenantdb.MustParseExactDecimal("475000.000000")) != 0 {
		t.Fatalf("N03 violation on IngestOrder revision retry: expected net ledger 475000.000000, got %s", net2.String())
	}
}

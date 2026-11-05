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

package commerceadapter_test

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// TestPaymentRace_ExpiryRacesPaymentConfirmation verifies atomic locking when
// reservation TTL expiry races payment confirmation (Acceptance Target 1).
func TestPaymentRace_ExpiryRacesPaymentConfirmation(t *testing.T) {
	ctx := context.Background()
	_, orderSvc, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-race-01"
	const locID = "loc-warehouse-01"
	const skuID = "sku-race-item-1"
	const orderID = "order-race-01"

	// 1 unit on hand
	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 1, baseHarnessTime.Add(-1*time.Hour))

	// Ingest order with 1 unit reserved with short TTL
	_, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:        orderID,
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		SourcePlatform: "stripe",
		LifecycleState: order.StateCreated,
		Amount:         tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:       "VND",
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("ingest order: %v", err)
	}

	// Advance time past expiry
	pastExpiry := baseHarnessTime.Add(2 * time.Hour)

	var wg sync.WaitGroup
	wg.Add(2)

	var confirmErr error
	var expireCount int

	go func() {
		defer wg.Done()
		_, confirmErr = orderSvc.HandlePaymentConfirmation(ctx, wsID, orderID, locID)
	}()

	go func() {
		defer wg.Done()
		expireCount, _ = invSvc.ExpireReservations(ctx, pastExpiry)
	}()

	wg.Wait()

	// Exactly one clean outcome: either confirmed/fulfilled or expired with late recovery
	o, err := orderSvc.GetOrder(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("get order: %v", err)
	}

	// Since stock was available, either payment won first, or expiry won and payment recovered
	if confirmErr != nil {
		t.Fatalf("expected payment confirmation to succeed (or recover), got %v", confirmErr)
	}
	if o.LifecycleState != order.StateConfirmed {
		t.Fatalf("expected order to be confirmed, got %s", o.LifecycleState)
	}
	_ = expireCount
}

// TestPaymentRace_LatePaymentRecoveryStockAvailable verifies that if a hold expired,
// but stock is still available, late payment confirmation re-reserves and fulfills seamlessly.
func TestPaymentRace_LatePaymentRecoveryStockAvailable(t *testing.T) {
	ctx := context.Background()
	_, orderSvc, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-race-02"
	const locID = "loc-warehouse-01"
	const skuID = "sku-race-item-2"
	const orderID = "order-race-02"

	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 5, baseHarnessTime.Add(-1*time.Hour))

	// Create order with hold
	_, _, _ = orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:        orderID,
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		SourcePlatform: "stripe",
		LifecycleState: order.StateCreated,
		Amount:         tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:       "VND",
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)

	// Explicitly expire the reservation
	pastExpiry := baseHarnessTime.Add(2 * time.Hour)
	count, err := invSvc.ExpireReservations(ctx, pastExpiry)
	if err != nil || count == 0 {
		t.Fatalf("expected 1 expired reservation, got %d, err: %v", count, err)
	}

	// Late payment confirmation arrives
	confirmedOrder, err := orderSvc.HandlePaymentConfirmation(ctx, wsID, orderID, locID)
	if err != nil {
		t.Fatalf("expected late payment recovery to succeed, got %v", err)
	}
	if confirmedOrder.LifecycleState != order.StateConfirmed {
		t.Fatalf("expected confirmed state, got %s", confirmedOrder.LifecycleState)
	}
}

// TestPaymentRace_LatePaymentFailsWhenStockExhausted verifies that when stock was sold out
// to another customer after hold expiry, late payment confirmation fails closed without overselling.
func TestPaymentRace_LatePaymentFailsWhenStockExhausted(t *testing.T) {
	ctx := context.Background()
	_, orderSvc, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-race-03"
	const locID = "loc-warehouse-01"
	const skuID = "sku-race-item-3"
	const orderID = "order-race-03"

	// Only 1 unit exists
	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 1, baseHarnessTime.Add(-1*time.Hour))

	// Ingest order 1 holding the only unit
	_, _, _ = orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:        orderID,
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		SourcePlatform: "stripe",
		LifecycleState: order.StateCreated,
		Amount:         tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:       "VND",
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)

	// Hold expires
	pastExpiry := baseHarnessTime.Add(2 * time.Hour)
	_, _ = invSvc.ExpireReservations(ctx, pastExpiry)

	// In the meantime, Customer 2 buys and fulfills the last unit!
	const orderID2 = "order-competitor"
	_, _ = invSvc.ReserveStock(ctx, wsID, orderID2, []inventory.ReservationItem{{SkuID: skuID, LocationID: locID, Quantity: 1}}, 15*time.Minute)
	_, _ = invSvc.FulfillReservation(ctx, wsID, orderID2)

	// Stock is now 0 on hand, 0 sellable
	bal, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 0 || bal.Sellable() != 0 {
		t.Fatalf("unexpected balance: on_hand=%d, sellable=%d", bal.OnHand, bal.Sellable())
	}

	// Late payment confirmation arrives for Order 1
	_, err := orderSvc.HandlePaymentConfirmation(ctx, wsID, orderID, locID)
	if err == nil {
		t.Fatalf("expected late payment confirmation to fail due to exhausted stock, but it succeeded!")
	}

	// Sellable stock must NOT become negative
	balAfter, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if balAfter.Sellable() < 0 {
		t.Fatalf("sellable stock became negative: %d", balAfter.Sellable())
	}
}

// TestPaymentRace_ConcurrentWebhooksIdempotent verifies that multiple concurrent payment
// webhooks for the same order fulfill exactly once without duplicate movements or postings.
func TestPaymentRace_ConcurrentWebhooksIdempotent(t *testing.T) {
	ctx := context.Background()
	_, orderSvc, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-race-04"
	const locID = "loc-warehouse-01"
	const skuID = "sku-race-item-4"
	const orderID = "order-race-04"

	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, baseHarnessTime.Add(-1*time.Hour))

	_, _, _ = orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:        orderID,
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		SourcePlatform: "stripe",
		LifecycleState: order.StateCreated,
		Amount:         tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:       "VND",
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)

	// 10 concurrent confirmation webhooks
	const concurrency = 10
	var wg sync.WaitGroup
	wg.Add(concurrency)

	errCount := 0
	var mu sync.Mutex

	for i := 0; i < concurrency; i++ {
		go func() {
			defer wg.Done()
			_, err := orderSvc.HandlePaymentConfirmation(ctx, wsID, orderID, locID)
			if err != nil {
				mu.Lock()
				errCount++
				mu.Unlock()
			}
		}()
	}

	wg.Wait()

	if errCount != 0 {
		t.Fatalf("expected 0 errors across idempotent webhooks, got %d", errCount)
	}

	// Check balance: exactly 10 - 2 = 8 on hand
	bal, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 8 || bal.Reserved != 0 {
		t.Fatalf("expected on_hand=8, reserved=0, got on_hand=%d, reserved=%d", bal.OnHand, bal.Reserved)
	}

	// List movements: exactly 1 sale movement recorded in ledger!
	movs, _, err := invSvc.Store().ListMovements(ctx, wsID, skuID, locID, 10, 0)
	if err != nil {
		t.Fatalf("list movements: %v", err)
	}
	saleCount := 0
	for _, m := range movs {
		if m.MovementType == inventory.MovementSale {
			saleCount++
		}
	}
	if saleCount != 1 {
		t.Fatalf("expected exactly 1 sale movement in ledger, got %d", saleCount)
	}
}

// TestPaymentRace_PaymentRacesCancellation verifies atomic outcome when payment confirmation
// races order cancellation.
func TestPaymentRace_PaymentRacesCancellation(t *testing.T) {
	ctx := context.Background()
	_, orderSvc, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-race-05"
	const locID = "loc-warehouse-01"
	const skuID = "sku-race-item-5"
	const orderID = "order-race-05"

	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 5, baseHarnessTime.Add(-1*time.Hour))

	_, _, _ = orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:        orderID,
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		SourcePlatform: "stripe",
		LifecycleState: order.StateCreated,
		Amount:         tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:       "VND",
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 1, UnitPrice: tenantdb.MustParseExactDecimal("100000.000000")},
		},
	}, locID)

	var wg sync.WaitGroup
	wg.Add(2)

	var confirmErr error
	var cancelErr error

	go func() {
		defer wg.Done()
		_, confirmErr = orderSvc.HandlePaymentConfirmation(ctx, wsID, orderID, locID)
	}()

	go func() {
		defer wg.Done()
		_, cancelErr = orderSvc.CancelOrder(ctx, wsID, orderID, "Customer requested cancellation")
	}()

	wg.Wait()

	o, _ := orderSvc.GetOrder(ctx, wsID, orderID)

	if confirmErr == nil && cancelErr == nil {
		// Both reported success only if cancel was after or idempotent, but lifecycle must be decisive
		if o.LifecycleState != order.StateConfirmed && o.LifecycleState != order.StateCancelled {
			t.Fatalf("invalid state after race: %s", o.LifecycleState)
		}
	} else if confirmErr != nil {
		// Cancel won: confirm failed
		if o.LifecycleState != order.StateCancelled {
			t.Fatalf("expected cancelled state when confirm failed, got %s", o.LifecycleState)
		}
	} else {
		// Confirm won: cancel failed
		if o.LifecycleState != order.StateConfirmed {
			t.Fatalf("expected confirmed state when cancel failed, got %s", o.LifecycleState)
		}
		if !errors.Is(cancelErr, order.ErrInvalidOrderTransition) {
			t.Fatalf("expected ErrInvalidOrderTransition on cancelling confirmed order, got %v", cancelErr)
		}
	}
}

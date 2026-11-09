package inventory_test

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

type mockSink struct {
	mu     sync.Mutex
	events []inventory.OutboxEvent
}

func (s *mockSink) Emit(_ context.Context, evt inventory.OutboxEvent) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.events = append(s.events, evt)
	return nil
}

func (s *mockSink) Count(eventType string) int {
	s.mu.Lock()
	defer s.mu.Unlock()
	c := 0
	for _, e := range s.events {
		if e.EventType == eventType {
			c++
		}
	}
	return c
}

// I01: One unit; two simultaneous one-unit holds -> One hold succeeds; no negative sellable quantity
func TestI01_SimultaneousHoldsOneUnit(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuID = "sku-01"

	_ = store.CreateLocation(ctx, &inventory.Location{
		LocationID:   locID,
		WorkspaceID:  wsID,
		Name:         "Main Warehouse",
		LocationType: inventory.LocWarehouse,
		Status:       inventory.StatusActive,
	})

	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID,
		SkuID:       skuID,
		LocationID:  locID,
		OnHand:      1,
		Reserved:    0,
	})

	var wg sync.WaitGroup
	wg.Add(2)

	var successCount int32
	var failCount int32
	var mu sync.Mutex

	holdFn := func(orderID string) {
		defer wg.Done()
		items := []inventory.ReservationItem{
			{SkuID: skuID, LocationID: locID, Quantity: 1},
		}
		_, err := svc.ReserveStock(ctx, wsID, orderID, items, 15*time.Minute)
		mu.Lock()
		defer mu.Unlock()
		if err == nil {
			successCount++
		} else {
			failCount++
		}
	}

	go holdFn("order-alpha")
	go holdFn("order-beta")
	wg.Wait()

	if successCount != 1 {
		t.Fatalf("expected exactly 1 success, got %d", successCount)
	}
	if failCount != 1 {
		t.Fatalf("expected exactly 1 failure, got %d", failCount)
	}

	bal, err := store.GetBalance(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("get balance: %v", err)
	}
	if bal.Sellable() < 0 {
		t.Fatalf("sellable stock became negative: %d", bal.Sellable())
	}
	if bal.OnHand != 1 || bal.Reserved != 1 || bal.Sellable() != 0 {
		t.Fatalf("unexpected balance: on_hand=%d, reserved=%d, sellable=%d", bal.OnHand, bal.Reserved, bal.Sellable())
	}
}

// I02: Fulfill a held order; replay request and webhook -> One sale movement; one consumed hold
func TestI02_FulfillHeldOrderReplayIdempotency(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuID = "sku-01"
	const orderID = "order-002"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc 1"})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuID, LocationID: locID, OnHand: 5, Reserved: 0,
	})

	// Reserve 2 units
	_, err := svc.ReserveStock(ctx, wsID, orderID, []inventory.ReservationItem{{SkuID: skuID, LocationID: locID, Quantity: 2}}, 15*time.Minute)
	if err != nil {
		t.Fatalf("reserve failed: %v", err)
	}

	// First fulfillment
	m1, err := svc.FulfillReservation(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("fulfill failed: %v", err)
	}
	if len(m1) != 1 || m1[0].Quantity != -2 {
		t.Fatalf("expected 1 movement with qty -2, got %+v", m1)
	}

	// Second fulfillment replay (webhook duplicate)
	m2, err := svc.FulfillReservation(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("fulfill replay failed: %v", err)
	}
	if len(m2) != 1 {
		t.Fatalf("expected idempotent 1 movement returned on replay, got %+v", m2)
	}

	// Verify balance: on_hand should be 5 - 2 = 3, reserved = 0
	bal, _ := store.GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 3 || bal.Reserved != 0 {
		t.Fatalf("unexpected balance: on_hand=%d, reserved=%d (expected 3 and 0)", bal.OnHand, bal.Reserved)
	}

	// Verify total movements in store
	movs, total, _ := store.ListMovements(ctx, wsID, skuID, locID, 10, 0)
	if total != 1 || len(movs) != 1 {
		t.Fatalf("expected exactly 1 movement recorded in ledger, got %d", total)
	}
}

// I03: One failed line in a two-SKU bundle -> No partial reservation or movement
func TestI03_BundleFailedLineLeavesNoPartialHolds(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuA = "sku-bundle-item-A"
	const skuB = "sku-bundle-item-B"
	const orderID = "order-bundle-003"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc 1"})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuA, LocationID: locID, OnHand: 10, Reserved: 0,
	})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuB, LocationID: locID, OnHand: 0, Reserved: 0, // Stock exhausted for B
	})

	bundleItems := []inventory.ReservationItem{
		{SkuID: skuA, LocationID: locID, Quantity: 1},
		{SkuID: skuB, LocationID: locID, Quantity: 1}, // Will fail
	}

	_, err := svc.ReserveStock(ctx, wsID, orderID, bundleItems, 15*time.Minute)
	if err == nil {
		t.Fatalf("expected error due to insufficient stock of SKU B, got nil")
	}

	// Verify SKU A was NOT partially reserved
	balA, _ := store.GetBalance(ctx, wsID, skuA, locID)
	if balA.Reserved != 0 || balA.Sellable() != 10 {
		t.Fatalf("partial hold leaked on SKU A! reserved=%d, sellable=%d", balA.Reserved, balA.Sellable())
	}

	resList, _ := store.ListReservationsByOrder(ctx, wsID, orderID)
	if len(resList) != 0 {
		t.Fatalf("expected 0 reservations stored, got %d", len(resList))
	}
}

// I04: Opening count 10 today; import completed order from yesterday -> Stock stays 10; historical finance still recognizes once
func TestI04_OpeningCountBaselineProtectsHistoricalOrder(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	today := time.Date(2026, 11, 2, 10, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return today })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuID = "sku-04"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc 1"})

	// Record opening baseline of 10 today at 10:00 UTC
	err := svc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, today)
	if err != nil {
		t.Fatalf("record baseline: %v", err)
	}

	// Historical order from yesterday at 08:00 UTC
	yesterday := today.Add(-24 * time.Hour)
	shouldDeduct, err := svc.ShouldDeductStockForImportedOrder(ctx, wsID, skuID, locID, yesterday)
	if err != nil {
		t.Fatalf("check deduction: %v", err)
	}
	if shouldDeduct {
		t.Fatalf("historical order before opening baseline must NOT deduct stock!")
	}

	// Verify stock is still exactly 10
	bal, _ := store.GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 10 || bal.Reserved != 0 {
		t.Fatalf("stock mutated! on_hand=%d, expected 10", bal.OnHand)
	}

	// A future order today at 12:00 UTC SHOULD deduct stock
	future := today.Add(2 * time.Hour)
	shouldDeductFuture, _ := svc.ShouldDeductStockForImportedOrder(ctx, wsID, skuID, locID, future)
	if !shouldDeductFuture {
		t.Fatalf("future order after opening baseline SHOULD deduct stock")
	}
}

// I05: Confirmed physical return replay; separate refund callback -> One positive return movement; refund adds no stock
func TestI05_PhysicalReturnReplayAndRefundSeparation(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuID = "sku-05"
	const orderID = "order-05"
	const returnID = "ret-05"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc 1"})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuID, LocationID: locID, OnHand: 5, Reserved: 0,
	})

	// Process physical return: 1 unit returned
	m1, err := svc.RecordPhysicalReturn(ctx, wsID, orderID, returnID, skuID, locID, 1, "Customer returned unopened item")
	if err != nil {
		t.Fatalf("record return: %v", err)
	}
	if m1.Quantity != 1 {
		t.Fatalf("expected positive return movement of +1, got %d", m1.Quantity)
	}

	// Replay webhook of same return
	m2, err := svc.RecordPhysicalReturn(ctx, wsID, orderID, returnID, skuID, locID, 1, "Duplicate webhook")
	if err != nil {
		t.Fatalf("record return replay: %v", err)
	}
	if m2.MovementID != m1.MovementID {
		t.Fatalf("replay must return the exact same movement identity!")
	}

	// On hand must be 5 + 1 = 6 (not 7)
	bal, _ := store.GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 6 {
		t.Fatalf("expected on_hand=6 after idempotent return replay, got %d", bal.OnHand)
	}

	// Movements count must be 1
	movs, total, _ := store.ListMovements(ctx, wsID, skuID, locID, 10, 0)
	if total != 1 || len(movs) != 1 {
		t.Fatalf("expected 1 movement in ledger, got %d", total)
	}
}

// I06: Expiry races payment confirmation -> One locked outcome; no lost hold or double fulfillment
func TestI06_ExpiryRacesPaymentConfirmation(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuID = "sku-06"
	const orderID = "order-06"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc 1"})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuID, LocationID: locID, OnHand: 1, Reserved: 0,
	})

	// Reserve 1 unit with 1-second TTL
	_, _ = svc.ReserveStock(ctx, wsID, orderID, []inventory.ReservationItem{{SkuID: skuID, LocationID: locID, Quantity: 1}}, 1*time.Second)

	// Advance time past expiry
	pastExpiry := now.Add(2 * time.Second)

	var wg sync.WaitGroup
	wg.Add(2)

	var fulfillErr error
	var expireCount int

	go func() {
		defer wg.Done()
		_, fulfillErr = svc.FulfillReservation(ctx, wsID, orderID)
	}()

	go func() {
		defer wg.Done()
		expireCount, _ = svc.ExpireReservations(ctx, pastExpiry)
	}()

	wg.Wait()

	// Exactly one outcome: either fulfilled (expireCount=0) OR expired (fulfillErr != nil)
	bal, _ := store.GetBalance(ctx, wsID, skuID, locID)

	if fulfillErr == nil {
		// Fulfillment won the race
		if expireCount != 0 {
			t.Fatalf("fulfillment won: expected expireCount=0, got %d", expireCount)
		}
		if bal.OnHand != 0 || bal.Reserved != 0 {
			t.Fatalf("fulfillment won: expected on_hand=0, reserved=0, got %d, %d", bal.OnHand, bal.Reserved)
		}
	} else {
		// Expiry won the race
		if expireCount != 1 {
			t.Fatalf("expiry won: expected expireCount=1, got %d", expireCount)
		}
		if bal.OnHand != 1 || bal.Reserved != 0 {
			t.Fatalf("expiry won: expected on_hand=1, reserved=0, got %d, %d", bal.OnHand, bal.Reserved)
		}
	}
}

// I07: Foreign tenant SKU/location/order or forged movement key -> Rejected before mutation; no foreign data disclosure
func TestI07_CrossTenantIsolation(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	svc := inventory.NewService(store, sink, nil)

	const tenantA = "ws-tenant-A"
	const tenantB = "ws-tenant-B"
	const locA = "loc-A"
	const skuA = "sku-A"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locA, WorkspaceID: tenantA, Name: "A Warehouse"})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: tenantA, SkuID: skuA, LocationID: locA, OnHand: 10, Reserved: 0,
	})

	// Tenant B tries to reserve Tenant A's SKU
	_, err := svc.ReserveStock(ctx, tenantB, "order-hacker", []inventory.ReservationItem{
		{SkuID: skuA, LocationID: locA, Quantity: 1},
	}, 15*time.Minute)

	if err == nil {
		t.Fatalf("cross-tenant reservation must be rejected!")
	}

	// Verify Tenant A stock was completely untouched
	balA, _ := store.GetBalance(ctx, tenantA, skuA, locA)
	if balA.Reserved != 0 || balA.OnHand != 10 {
		t.Fatalf("tenant A data compromised! on_hand=%d, reserved=%d", balA.OnHand, balA.Reserved)
	}

	// Tenant B cannot read Tenant A's location
	_, err = store.GetLocation(ctx, tenantB, locA)
	if err == nil {
		t.Fatalf("tenant B should not be able to read tenant A location!")
	}
}

// I08: External correction drives stock below reservations -> Truth retained; discrepancy visible; new local holds blocked
func TestI08_ExternalCorrectionDrivesStockBelowReservations(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuID = "sku-08"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc 1"})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuID, LocationID: locID, OnHand: 5, Reserved: 0,
	})

	// Hold 4 units for order
	_, err := svc.ReserveStock(ctx, wsID, "order-08", []inventory.ReservationItem{{SkuID: skuID, LocationID: locID, Quantity: 4}}, 15*time.Minute)
	if err != nil {
		t.Fatalf("reserve: %v", err)
	}

	// External channel sync says real on_hand is only 2 (less than the 4 reserved!)
	_, err = svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 2, "sync-ext-oversell")
	if err != nil {
		t.Fatalf("sync error: %v", err)
	}

	bal, _ := store.GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 2 || bal.Reserved != 4 {
		t.Fatalf("truth not retained: on_hand=%d, reserved=%d", bal.OnHand, bal.Reserved)
	}
	// Sellable is now negative (2 - 4 = -2)
	if bal.Sellable() != -2 {
		t.Fatalf("expected sellable -2, got %d", bal.Sellable())
	}

	// New local holds MUST be blocked
	_, err = svc.ReserveStock(ctx, wsID, "order-new", []inventory.ReservationItem{{SkuID: skuID, LocationID: locID, Quantity: 1}}, 15*time.Minute)
	if err == nil {
		t.Fatalf("new holds must be blocked when sellable is negative or insufficient!")
	}

	// Verify discrepancy event was emitted
	if sink.Count("inventory.discrepancy_detected") == 0 {
		t.Fatalf("expected inventory.discrepancy_detected event emitted!")
	}
}

// I09: Crash after transaction before event ACK; rebuild cache -> Ledger, holds and projections agree; no repeated movement
func TestI09_ReconcileLedgerAndBalanceIntegrity(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuID = "sku-09"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc 1"})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuID, LocationID: locID, OnHand: 10, Reserved: 0,
	})

	_ = store.AppendMovement(ctx, &inventory.Movement{
		MovementID:   "mov-1",
		WorkspaceID:  wsID,
		SkuID:        skuID,
		LocationID:   locID,
		MovementType: inventory.MovementPurchase,
		MovementKey:  "mov_init",
		Quantity:     10,
	})

	// Reconcile when balanced
	rep, err := svc.ReconcileLedger(ctx, wsID, skuID, locID)
	if err != nil {
		t.Fatalf("expected clean reconciliation, got err: %v", err)
	}
	if rep.Discrepancy != 0 {
		t.Fatalf("expected discrepancy 0, got %d", rep.Discrepancy)
	}

	// Simulate cache corruption / drift in balance projection (e.g. on_hand became 8 instead of 10)
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuID, LocationID: locID, OnHand: 8, Reserved: 0,
	})

	// Reconcile must detect the discrepancy
	repDrift, err := svc.ReconcileLedger(ctx, wsID, skuID, locID)
	if err == nil {
		t.Fatalf("expected error detecting discrepancy!")
	}
	if repDrift.Discrepancy != -2 {
		t.Fatalf("expected discrepancy -2, got %d", repDrift.Discrepancy)
	}
}

// I10: Same absolute source count polled twice -> Second sync changes no quantity
func TestI10_PolledAbsoluteCountTwiceNoOp(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-01"
	const locID = "loc-01"
	const skuID = "sku-10"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc 1"})
	_ = store.UpsertBalance(ctx, &inventory.Balance{
		WorkspaceID: wsID, SkuID: skuID, LocationID: locID, OnHand: 15, Reserved: 0,
	})

	// Poll 1: reports 15 (same as current)
	m1, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 15, "sync-01")
	if err != nil {
		t.Fatalf("sync 1 failed: %v", err)
	}
	if m1 != nil {
		t.Fatalf("expected nil movement when count matches on_hand, got %+v", m1)
	}

	// Poll 2: reports 20 (delta +5)
	m2, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 20, "sync-02")
	if err != nil {
		t.Fatalf("sync 2 failed: %v", err)
	}
	if m2 == nil || m2.Quantity != 5 {
		t.Fatalf("expected delta +5 movement, got %+v", m2)
	}

	// Poll 3: reports 20 again (identical to current 20) -> MUST BE NO-OP!
	m3, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 20, "sync-03")
	if err != nil {
		t.Fatalf("sync 3 failed: %v", err)
	}
	if m3 != nil {
		t.Fatalf("expected nil movement on repeated identical count, got %+v", m3)
	}

	// Total movements in ledger must be exactly 1 (+5)
	_, total, _ := store.ListMovements(ctx, wsID, skuID, locID, 10, 0)
	if total != 1 {
		t.Fatalf("expected exactly 1 movement recorded, got %d", total)
	}
}

func TestRemediation_F14_StockSyncReplayDoesNotCorruptBalanceAfterMovement(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 6, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-f14"
	const locID = "loc-f14"
	const skuID = "sku-f14"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc F14", IsDefault: true, Status: inventory.StatusActive})
	if err := svc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, now.Add(-1*time.Hour)); err != nil {
		t.Fatalf("RecordOpeningBaseline: %v", err)
	}

	// 1. External platform sync sets count to 8 (delta = -2)
	m1, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 8, "sync-snap-001")
	if err != nil {
		t.Fatalf("first sync failed: %v", err)
	}
	if m1 == nil || m1.Quantity != -2 {
		t.Fatalf("expected sync movement of -2, got %+v", m1)
	}

	// 2. Subsequent order reserves and fulfills 2 units -> OnHand becomes 6
	if _, err := svc.ReserveStock(ctx, wsID, "ord-f14-1", []inventory.ReservationItem{{SkuID: skuID, LocationID: locID, Quantity: 2}}, 15*time.Minute); err != nil {
		t.Fatalf("ReserveStock: %v", err)
	}
	if _, err := svc.FulfillReservation(ctx, wsID, "ord-f14-1"); err != nil {
		t.Fatalf("FulfillReservation: %v", err)
	}

	balMid, err := store.GetBalance(ctx, wsID, skuID, locID)
	if err != nil || balMid.OnHand != 6 {
		t.Fatalf("expected OnHand=6 after sale, got %+v (err=%v)", balMid, err)
	}

	// 3. Replay of "sync-snap-001" with count=8 MUST NOT overwrite OnHand back to 8 or fail
	mReplay, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 8, "sync-snap-001")
	if err != nil {
		t.Fatalf("sync replay should be idempotent, got err: %v", err)
	}
	if mReplay == nil || mReplay.MovementID != m1.MovementID {
		t.Fatalf("expected original movement on replay, got %+v", mReplay)
	}

	balAfterReplay, _ := store.GetBalance(ctx, wsID, skuID, locID)
	if balAfterReplay.OnHand != 6 {
		t.Fatalf("F14 regression: sync replay overwrote OnHand to %d (expected 6)", balAfterReplay.OnHand)
	}
	if rep, err := svc.ReconcileLedger(ctx, wsID, skuID, locID); err != nil || rep.Discrepancy != 0 {
		t.Fatalf("ledger discrepancy after sync replay: rep=%+v err=%v", rep, err)
	}

	// 4. Reusing "sync-snap-001" with a DIFFERENT count (e.g. 5) must fail with ErrMovementDuplicate
	if _, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 5, "sync-snap-001"); !errors.Is(err, inventory.ErrMovementDuplicate) {
		t.Fatalf("expected ErrMovementDuplicate on conflicting syncKey reuse, got %v", err)
	}

	// 5. Zero-delta sync followed by sale and replay of zero-delta sync must also preserve OnHand
	if mZero, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 6, "sync-zero-001"); err != nil || mZero != nil {
		t.Fatalf("expected nil movement on zero-delta sync, got mov=%+v err=%v", mZero, err)
	}
	if _, err := svc.ReserveStock(ctx, wsID, "ord-f14-2", []inventory.ReservationItem{{SkuID: skuID, LocationID: locID, Quantity: 1}}, 15*time.Minute); err != nil {
		t.Fatalf("ReserveStock 2: %v", err)
	}
	if _, err := svc.FulfillReservation(ctx, wsID, "ord-f14-2"); err != nil {
		t.Fatalf("FulfillReservation 2: %v", err)
	}
	// OnHand is now 5. Replaying "sync-zero-001" (count=6) must NOT reset OnHand to 6!
	if mZeroReplay, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 6, "sync-zero-001"); err != nil || mZeroReplay != nil {
		t.Fatalf("expected nil movement on zero-delta sync replay, got mov=%+v err=%v", mZeroReplay, err)
	}
	balAfterZeroReplay, _ := store.GetBalance(ctx, wsID, skuID, locID)
	if balAfterZeroReplay.OnHand != 5 {
		t.Fatalf("zero-delta sync replay corrupted OnHand: got %d, want 5", balAfterZeroReplay.OnHand)
	}
	if _, err := svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 9, "sync-zero-001"); !errors.Is(err, inventory.ErrMovementDuplicate) {
		t.Fatalf("expected ErrMovementDuplicate when zero-delta syncKey reused with different count, got %v", err)
	}
}

func TestRemediation_F15_DuplicateSkuLocationReservationCannotOverbook(t *testing.T) {
	ctx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 6, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })

	const wsID = "ws-tenant-f15"
	const locID = "loc-f15"
	const skuID = "sku-f15"

	_ = store.CreateLocation(ctx, &inventory.Location{LocationID: locID, WorkspaceID: wsID, Name: "Loc F15", IsDefault: true, Status: inventory.StatusActive})
	if err := svc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 1, now.Add(-1*time.Hour)); err != nil {
		t.Fatalf("RecordOpeningBaseline: %v", err)
	}

	// 1. Duplicate lines for (skuID, locID) with qty 1 + 1 = 2 when OnHand = 1 must be rejected!
	_, err := svc.ReserveStock(ctx, wsID, "ord-dup-overbook", []inventory.ReservationItem{
		{SkuID: skuID, LocationID: locID, Quantity: 1},
		{SkuID: skuID, LocationID: locID, Quantity: 1},
	}, 15*time.Minute)
	if !errors.Is(err, inventory.ErrInsufficientStock) {
		t.Fatalf("F15 regression: expected ErrInsufficientStock for duplicate SKU/location overbook, got %v", err)
	}

	bal, _ := store.GetBalance(ctx, wsID, skuID, locID)
	if bal.Reserved != 0 || bal.Sellable() != 1 {
		t.Fatalf("expected Reserved=0, Sellable=1 after rejected overbook, got Reserved=%d Sellable=%d", bal.Reserved, bal.Sellable())
	}

	// 2. When stock is sufficient (e.g. OnHand = 3), duplicate lines coalesce cleanly into a single hold of 2
	_, _ = svc.PlatformSyncAbsoluteCount(ctx, wsID, locID, skuID, 3, "sync-f15-restock")
	resList, err := svc.ReserveStock(ctx, wsID, "ord-dup-valid", []inventory.ReservationItem{
		{SkuID: skuID, LocationID: locID, Quantity: 1},
		{SkuID: skuID, LocationID: locID, Quantity: 1},
	}, 15*time.Minute)
	if err != nil {
		t.Fatalf("expected coalesced reservation to succeed when stock=3, got %v", err)
	}
	if len(resList) != 1 || resList[0].Quantity != 2 {
		t.Fatalf("expected 1 coalesced reservation of quantity 2, got %+v", resList)
	}
	balAfter, _ := store.GetBalance(ctx, wsID, skuID, locID)
	if balAfter.Reserved != 2 || balAfter.Sellable() != 1 {
		t.Fatalf("expected Reserved=2, Sellable=1, got Reserved=%d Sellable=%d", balAfter.Reserved, balAfter.Sellable())
	}
}

func TestSecondPass_InventoryHandler_RBACIdempotencyMovementRestrictionsAndBulkStockIn(t *testing.T) {
	baseCtx := context.Background()
	store := inventory.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)
	svc := inventory.NewService(store, sink, func() time.Time { return now })
	h := inventory.NewHandler(svc)

	const wsID = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa99"
	const locID = "loc-h-01"
	const sku1 = "sku-h-01"
	const sku2 = "sku-h-02"

	_ = store.CreateLocation(baseCtx, &inventory.Location{
		LocationID:  locID,
		WorkspaceID: wsID,
		Name:        "Main Warehouse",
		IsDefault:   true,
		Status:      inventory.StatusActive,
	})
	_ = svc.RecordOpeningBaseline(baseCtx, wsID, sku1, locID, 10, now.Add(-1*time.Hour))
	_ = svc.RecordOpeningBaseline(baseCtx, wsID, sku2, locID, 5, now.Add(-1*time.Hour))

	// Hold 8 units on sku1 -> OnHand=10, Reserved=8, Sellable=2
	if _, err := svc.ReserveStock(baseCtx, wsID, "ord-h-hold", []inventory.ReservationItem{
		{SkuID: sku1, LocationID: locID, Quantity: 8},
	}, 15*time.Minute); err != nil {
		t.Fatalf("ReserveStock failed: %v", err)
	}

	ctxViewer := rbac.WithPolicyContext(baseCtx, rbac.PolicyContext{
		ActorUserID: "user-viewer-1",
		WorkspaceID: wsID,
		Role:        rbac.RoleViewer,
	})
	ctxEditor := rbac.WithPolicyContext(baseCtx, rbac.PolicyContext{
		ActorUserID: "user-editor-1",
		WorkspaceID: wsID,
		Role:        rbac.RoleEditor,
	})

	// 1. Viewer cannot mutate stock via CreateStockMovement or BulkStockIn -> CodePermissionDenied
	if _, err := h.CreateStockMovement(ctxViewer, connect.NewRequest(&commercev1.InventoryServiceCreateStockMovementRequest{
		Context:      &commonv1.CommandContext{IdempotencyKey: "idem-inv-viewer-denied"},
		SkuId:        sku1,
		LocationId:   locID,
		MovementType: commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_ADJUSTMENT,
		Quantity:     1,
		Reason:       "viewer attempt",
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for Viewer on CreateStockMovement, got %v", err)
	}

	// 2. Missing IdempotencyKey on CreateStockMovement -> CodeInvalidArgument
	if _, err := h.CreateStockMovement(ctxEditor, connect.NewRequest(&commercev1.InventoryServiceCreateStockMovementRequest{
		SkuId:        sku1,
		LocationId:   locID,
		MovementType: commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_ADJUSTMENT,
		Quantity:     1,
		Reason:       "missing idempotency key",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument for missing idempotency_key on CreateStockMovement, got %v", err)
	}

	// 3. Fabricated sale/return/transfer on CreateStockMovement -> CodeInvalidArgument per api_behavior_contracts.md
	for _, forbiddenType := range []commercev1.StockMovementType{
		commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_SALE,
		commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_RETURN,
		commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_TRANSFER,
	} {
		if _, err := h.CreateStockMovement(ctxEditor, connect.NewRequest(&commercev1.InventoryServiceCreateStockMovementRequest{
			Context:      &commonv1.CommandContext{IdempotencyKey: "idem-inv-forbidden-" + forbiddenType.String()},
			SkuId:        sku1,
			LocationId:   locID,
			MovementType: forbiddenType,
			Quantity:     -1,
			Reason:       "fabricated movement",
		})); connect.CodeOf(err) != connect.CodeInvalidArgument {
			t.Fatalf("expected CodeInvalidArgument for fabricated %v on CreateStockMovement, got %v", forbiddenType, err)
		}
	}

	// 4. Negative adjustment driving OnHand (10 - 5 = 5) below Reserved (8) -> CodeFailedPrecondition
	if _, err := h.CreateStockMovement(ctxEditor, connect.NewRequest(&commercev1.InventoryServiceCreateStockMovementRequest{
		Context:      &commonv1.CommandContext{IdempotencyKey: "idem-inv-below-reserved"},
		SkuId:        sku1,
		LocationId:   locID,
		MovementType: commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_DAMAGE,
		Quantity:     -5,
		Reason:       "damaged units",
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition when negative adjustment drops OnHand below Reserved, got %v", err)
	}
	balSku1, _ := store.GetBalance(baseCtx, wsID, sku1, locID)
	if balSku1.OnHand != 10 || balSku1.Reserved != 8 {
		t.Fatalf("expected balance unchanged (OnHand=10, Reserved=8) after rejected adjustment, got %+v", balSku1)
	}

	// 5. BulkStockIn atomically records stock_in movements and supports idempotent replay
	bulkResp, err := h.BulkStockIn(ctxEditor, connect.NewRequest(&commercev1.InventoryServiceBulkStockInRequest{
		Context:    &commonv1.CommandContext{IdempotencyKey: "idem-inv-bulk-1"},
		LocationId: locID,
		Reason:     "PO-2026-11",
		Items: []*commercev1.StockMovementItem{
			{SkuId: sku1, Quantity: 4},
			{SkuId: sku2, Quantity: 6},
		},
	}))
	if err != nil {
		t.Fatalf("BulkStockIn failed: %v", err)
	}
	if bulkResp.Msg.ProcessedCount != 2 || len(bulkResp.Msg.Movements) != 2 {
		t.Fatalf("expected ProcessedCount=2 and 2 movements from BulkStockIn, got count=%d len=%d",
			bulkResp.Msg.ProcessedCount, len(bulkResp.Msg.Movements))
	}
	bal1After, _ := store.GetBalance(baseCtx, wsID, sku1, locID)
	bal2After, _ := store.GetBalance(baseCtx, wsID, sku2, locID)
	if bal1After.OnHand != 14 || bal2After.OnHand != 11 {
		t.Fatalf("unexpected balances after BulkStockIn: sku1=%d (want 14), sku2=%d (want 11)", bal1After.OnHand, bal2After.OnHand)
	}

	// Replay BulkStockIn with same key and payload -> idempotent return without double-counting
	bulkReplay, err := h.BulkStockIn(ctxEditor, connect.NewRequest(&commercev1.InventoryServiceBulkStockInRequest{
		Context:    &commonv1.CommandContext{IdempotencyKey: "idem-inv-bulk-1"},
		LocationId: locID,
		Reason:     "PO-2026-11",
		Items: []*commercev1.StockMovementItem{
			{SkuId: sku1, Quantity: 4},
			{SkuId: sku2, Quantity: 6},
		},
	}))
	if err != nil {
		t.Fatalf("BulkStockIn replay failed: %v", err)
	}
	if bulkReplay.Msg.ProcessedCount != 2 {
		t.Fatalf("expected ProcessedCount=2 on replay, got %d", bulkReplay.Msg.ProcessedCount)
	}
	bal1Replay, _ := store.GetBalance(baseCtx, wsID, sku1, locID)
	if bal1Replay.OnHand != 14 {
		t.Fatalf("BulkStockIn replay double-counted stock: got %d, want 14", bal1Replay.OnHand)
	}
}

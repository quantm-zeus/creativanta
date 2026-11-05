package inventory

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"
)

type OutboxEvent struct {
	EventID       string
	EventType     string
	AggregateType string
	AggregateID   string
	WorkspaceID   string
	PayloadJSON   []byte
	CreatedAt     time.Time
}

type EventSink interface {
	Emit(ctx context.Context, evt OutboxEvent) error
}

type Service struct {
	store     Store
	eventSink EventSink
	clock     func() time.Time
}

func NewService(store Store, sink EventSink, clock func() time.Time) *Service {
	if clock == nil {
		clock = func() time.Time { return time.Now().UTC() }
	}
	return &Service{
		store:     store,
		eventSink: sink,
		clock:     clock,
	}
}

func (s *Service) Store() Store {
	return s.store
}

func (s *Service) emitEvent(ctx context.Context, eventType, aggregateType, aggregateID, workspaceID string, payload any) {
	if s.eventSink == nil {
		return
	}
	data, err := json.Marshal(payload)
	if err != nil {
		return
	}
	_ = s.eventSink.Emit(ctx, OutboxEvent{
		EventID:       newUUID(),
		EventType:     eventType,
		AggregateType: aggregateType,
		AggregateID:   aggregateID,
		WorkspaceID:   workspaceID,
		PayloadJSON:   data,
		CreatedAt:     s.clock(),
	})
}

// ----------------------------------------------------------------------------
// Atomic Reservation Protocol (§3 of inventory_computation_contract.md)
// ----------------------------------------------------------------------------

// ReserveStock executes atomic multi-SKU reservation with sorted row locking.
// All-or-nothing: if any single line cannot be satisfied, no partial holds remain (I01, I03).
func (s *Service) ReserveStock(
	ctx context.Context,
	workspaceID string,
	orderID string,
	items []ReservationItem,
	ttl time.Duration,
) ([]*Reservation, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	if len(items) == 0 {
		return nil, fmt.Errorf("%w: empty reservation items", ErrInvalidInput)
	}

	var pairs []SkuLocPair
	for _, item := range items {
		if item.Quantity <= 0 {
			return nil, ErrInvalidQuantity
		}
		pairs = append(pairs, SkuLocPair{SkuID: item.SkuID, LocationID: item.LocationID})
	}

	if ttl <= 0 {
		ttl = DefaultHoldTTL
	}
	expiresAt := s.clock().Add(ttl)

	var createdReservations []*Reservation

	err := s.store.AtomicExecute(ctx, workspaceID, pairs, func(tx StoreTx) error {
		existingByKey := make(map[string]*Reservation, len(items))
		// 1. Verify existing reservation state and sellable inventory for all items
		for _, item := range items {
			resKey := fmt.Sprintf("res_%s_%s_%s", orderID, item.SkuID, item.LocationID)
			existing, err := tx.GetReservation(ctx, workspaceID, resKey)
			if err != nil && !errors.Is(err, ErrReservationNotFound) {
				return err
			}
			if existing != nil {
				if existing.Status == ResHeld && existing.Quantity == item.Quantity {
					existingByKey[resKey] = existing
					continue
				}
				if existing.Status != ResExpired && existing.Status != ResReleased {
					return fmt.Errorf("%w: reservation %s already in status %s", ErrReservationConflict, existing.ReservationID, existing.Status)
				}
				existingByKey[resKey] = existing
			}

			bal, err := tx.GetBalanceForUpdate(ctx, workspaceID, item.SkuID, item.LocationID)
			if err != nil {
				return err
			}
			if bal.Sellable() < item.Quantity {
				return fmt.Errorf("%w: sku %s at location %s needs %d, sellable %d",
					ErrInsufficientStock, item.SkuID, item.LocationID, item.Quantity, bal.Sellable())
			}
		}

		// 2. All items verified: insert/reactivate held reservations and increment reserved counts
		for _, item := range items {
			resKey := fmt.Sprintf("res_%s_%s_%s", orderID, item.SkuID, item.LocationID)
			if existing, ok := existingByKey[resKey]; ok && existing.Status == ResHeld && existing.Quantity == item.Quantity {
				createdReservations = append(createdReservations, existing)
				continue
			}

			resID := newUUID()
			if existing, ok := existingByKey[resKey]; ok {
				resID = existing.ReservationID
			}
			res := &Reservation{
				ReservationID:  resID,
				WorkspaceID:    workspaceID,
				OrderID:        orderID,
				SkuID:          item.SkuID,
				LocationID:     item.LocationID,
				ReservationKey: resKey,
				Quantity:       item.Quantity,
				Status:         ResHeld,
				ExpiresAt:      &expiresAt,
				CreatedAt:      s.clock(),
				UpdatedAt:      s.clock(),
			}

			if err := tx.CreateReservation(ctx, res); err != nil {
				return err
			}

			bal, err := tx.GetBalanceForUpdate(ctx, workspaceID, item.SkuID, item.LocationID)
			if err != nil {
				return err
			}
			bal.Reserved += item.Quantity
			if err := tx.UpdateBalance(ctx, bal); err != nil {
				return err
			}

			createdReservations = append(createdReservations, res)
		}
		return nil
	})

	if err != nil {
		return nil, err
	}
	return createdReservations, nil
}

// FulfillReservation consumes all held reservations for an order, appends sale movements,
// and decrements both on_hand and reserved projections atomically (I02).
// Webhook replay is completely idempotent.
func (s *Service) FulfillReservation(
	ctx context.Context,
	workspaceID string,
	orderID string,
) ([]*Movement, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}

	resList, err := s.store.ListReservationsByOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if len(resList) == 0 {
		return nil, ErrReservationNotFound
	}

	var pairs []SkuLocPair
	for _, r := range resList {
		pairs = append(pairs, SkuLocPair{SkuID: r.SkuID, LocationID: r.LocationID})
	}

	var movements []*Movement

	err = s.store.AtomicExecute(ctx, workspaceID, pairs, func(tx StoreTx) error {
		// Re-fetch reservations in transaction
		activeResList, err := tx.ListReservationsByOrder(ctx, workspaceID, orderID)
		if err != nil {
			return err
		}

		for _, r := range activeResList {
			movKey := fmt.Sprintf("mov_sale_%s_%s_%s", orderID, r.SkuID, r.LocationID)

			if r.Status == ResConsumed {
				// Replay / already fulfilled: return existing movement
				existing, err := s.store.FindMovementByKey(ctx, workspaceID, movKey)
				if err == nil && existing != nil {
					movements = append(movements, existing)
					continue
				}
			}

			if r.Status != ResHeld {
				if r.Status == ResExpired {
					return fmt.Errorf("%w: reservation %s in status expired", ErrReservationExpired, r.ReservationID)
				}
				return fmt.Errorf("%w: reservation %s in status %s", ErrReservationConflict, r.ReservationID, r.Status)
			}

			// 1. Consume reservation
			if err := tx.UpdateReservationStatus(ctx, workspaceID, r.ReservationID, ResConsumed); err != nil {
				return err
			}

			// 2. Append sale movement (negative quantity)
			mov := &Movement{
				MovementID:    newUUID(),
				WorkspaceID:   workspaceID,
				SkuID:         r.SkuID,
				LocationID:    r.LocationID,
				MovementType:  MovementSale,
				MovementKey:   movKey,
				Quantity:      -r.Quantity,
				ReferenceType: "order",
				ReferenceID:   orderID,
				Reason:        "Order fulfilled",
				CreatedAt:     s.clock(),
			}
			if err := tx.AppendMovement(ctx, mov); err != nil {
				return err
			}
			movements = append(movements, mov)

			// 3. Decrement on_hand and reserved
			bal, err := tx.GetBalanceForUpdate(ctx, workspaceID, r.SkuID, r.LocationID)
			if err != nil {
				return err
			}
			bal.OnHand -= r.Quantity
			bal.Reserved -= r.Quantity
			if bal.Reserved < 0 {
				bal.Reserved = 0
			}
			if err := tx.UpdateBalance(ctx, bal); err != nil {
				return err
			}
		}
		return nil
	})

	if err != nil {
		return nil, err
	}

	// Emit stock moved events after transaction commits
	for _, m := range movements {
		s.emitEvent(ctx, "inventory.stock_moved", "stock_movement", m.MovementID, workspaceID, map[string]any{
			"movement_id":   m.MovementID,
			"sku_id":        m.SkuID,
			"location_id":   m.LocationID,
			"quantity":      m.Quantity,
			"movement_type": m.MovementType,
		})
	}

	return movements, nil
}

// ReleaseReservation releases all held reservations for an order upon cancellation or payment failure.
func (s *Service) ReleaseReservation(ctx context.Context, workspaceID, orderID, reason string) error {
	if workspaceID == "" {
		return ErrMissingTenant
	}

	resList, err := s.store.ListReservationsByOrder(ctx, workspaceID, orderID)
	if err != nil {
		return err
	}
	if len(resList) == 0 {
		return nil // Idempotent no-op if no reservations
	}

	var pairs []SkuLocPair
	for _, r := range resList {
		pairs = append(pairs, SkuLocPair{SkuID: r.SkuID, LocationID: r.LocationID})
	}

	return s.store.AtomicExecute(ctx, workspaceID, pairs, func(tx StoreTx) error {
		activeResList, err := tx.ListReservationsByOrder(ctx, workspaceID, orderID)
		if err != nil {
			return err
		}

		for _, r := range activeResList {
			if r.Status != ResHeld {
				continue // Already consumed, released or expired
			}

			if err := tx.UpdateReservationStatus(ctx, workspaceID, r.ReservationID, ResReleased); err != nil {
				return err
			}

			bal, err := tx.GetBalanceForUpdate(ctx, workspaceID, r.SkuID, r.LocationID)
			if err != nil {
				continue
			}
			bal.Reserved -= r.Quantity
			if bal.Reserved < 0 {
				bal.Reserved = 0
			}
			if err := tx.UpdateBalance(ctx, bal); err != nil {
				return err
			}
		}
		return nil
	})
}

// ExpireReservations scans and expires unpaid checkout holds that exceeded their 15-minute TTL.
func (s *Service) ExpireReservations(ctx context.Context, now time.Time) (int, error) {
	expiredList, err := s.store.ListExpiredReservations(ctx, now)
	if err != nil {
		return 0, err
	}
	count := 0

	for _, r := range expiredList {
		pairs := []SkuLocPair{{SkuID: r.SkuID, LocationID: r.LocationID}}
		err := s.store.AtomicExecute(ctx, r.WorkspaceID, pairs, func(tx StoreTx) error {
			res, err := tx.GetReservation(ctx, r.WorkspaceID, r.ReservationKey)
			if err != nil {
				return err
			}
			if res.Status != ResHeld {
				return nil // Raced and resolved by payment or other worker
			}
			if err := tx.UpdateReservationStatus(ctx, r.WorkspaceID, res.ReservationID, ResExpired); err != nil {
				return err
			}

			bal, err := tx.GetBalanceForUpdate(ctx, r.WorkspaceID, res.SkuID, res.LocationID)
			if err == nil {
				bal.Reserved -= res.Quantity
				if bal.Reserved < 0 {
					bal.Reserved = 0
				}
				_ = tx.UpdateBalance(ctx, bal)
			}
			count++
			return nil
		})
		if err != nil {
			continue
		}
	}
	return count, nil
}

// ----------------------------------------------------------------------------
// Baseline & Historical Import Protection (§2 of inventory_computation_contract.md)
// ----------------------------------------------------------------------------

// RecordOpeningBaseline initializes the SKU/location opening count and sets opening_at.
func (s *Service) RecordOpeningBaseline(
	ctx context.Context,
	workspaceID, skuID, locationID string,
	openingCount int32,
	openingAt time.Time,
) error {
	if workspaceID == "" {
		return ErrMissingTenant
	}

	pairs := []SkuLocPair{{SkuID: skuID, LocationID: locationID}}
	return s.store.AtomicExecute(ctx, workspaceID, pairs, func(tx StoreTx) error {
		movKey := fmt.Sprintf("mov_baseline_%s_%s_%d", skuID, locationID, openingAt.Unix())
		mov := &Movement{
			MovementID:      newUUID(),
			WorkspaceID:     workspaceID,
			SkuID:           skuID,
			LocationID:      locationID,
			MovementType:    MovementAdjustment,
			MovementKey:     movKey,
			Quantity:        openingCount,
			ReferenceType:   "opening_count",
			SourceCreatedAt: &openingAt,
			Reason:          "Evidenced opening count baseline",
			CreatedAt:       s.clock(),
		}
		if err := tx.AppendMovement(ctx, mov); err != nil {
			return err
		}

		bal := &Balance{
			BalanceID:   newUUID(),
			WorkspaceID: workspaceID,
			SkuID:       skuID,
			LocationID:  locationID,
			OnHand:      openingCount,
			Reserved:    0,
			OpeningAt:   &openingAt,
			UpdatedAt:   s.clock(),
		}
		return tx.UpdateBalance(ctx, bal)
	})
}

// ShouldDeductStockForImportedOrder verifies if an imported order should deduct stock.
// Historical orders at or before opening_at DO NOT deduct stock again (I04, Acceptance Target 2).
func (s *Service) ShouldDeductStockForImportedOrder(
	ctx context.Context,
	workspaceID, skuID, locationID string,
	orderOrderedAt time.Time,
) (bool, error) {
	bal, err := s.store.GetBalance(ctx, workspaceID, skuID, locationID)
	if err != nil {
		if errors.Is(err, ErrSkuNotInitialized) {
			// Not initialized: cannot deduct stock blindly
			return false, nil
		}
		return false, err
	}

	if bal.OpeningAt == nil {
		// No opening baseline defined: normal order flow
		return true, nil
	}

	// If order occurred at or before opening baseline boundary, do NOT double-deduct
	if orderOrderedAt.Before(*bal.OpeningAt) || orderOrderedAt.Equal(*bal.OpeningAt) {
		return false, nil
	}

	return true, nil
}

// ----------------------------------------------------------------------------
// Physical Returns & Restocking (§3 of inventory_computation_contract.md)
// ----------------------------------------------------------------------------

// RecordPhysicalReturn records an accepted physical return of goods, appending a return
// movement and incrementing on_hand (I05).
// Enforces that money refund alone does NOT restock goods (RULE-M13-006).
func (s *Service) RecordPhysicalReturn(
	ctx context.Context,
	workspaceID, orderID, returnID, skuID, locationID string,
	quantity int32,
	reason string,
) (*Movement, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	if quantity <= 0 {
		return nil, ErrInvalidQuantity
	}

	movKey := fmt.Sprintf("mov_return_%s_%s_%d", returnID, skuID, quantity)

	pairs := []SkuLocPair{{SkuID: skuID, LocationID: locationID}}
	var mov *Movement

	err := s.store.AtomicExecute(ctx, workspaceID, pairs, func(tx StoreTx) error {
		// Check idempotency on return replay
		existing, err := s.store.FindMovementByKey(ctx, workspaceID, movKey)
		if err == nil && existing != nil {
			mov = existing
			return nil
		}

		mov = &Movement{
			MovementID:    newUUID(),
			WorkspaceID:   workspaceID,
			SkuID:         skuID,
			LocationID:    locationID,
			MovementType:  MovementReturn,
			MovementKey:   movKey,
			Quantity:      quantity, // Positive quantity adds back to on_hand
			ReferenceType: "return",
			ReferenceID:   returnID,
			Reason:        reason,
			CreatedAt:     s.clock(),
		}
		if err := tx.AppendMovement(ctx, mov); err != nil {
			return err
		}

		bal, err := tx.GetBalanceForUpdate(ctx, workspaceID, skuID, locationID)
		if err != nil {
			return err
		}
		bal.OnHand += quantity
		return tx.UpdateBalance(ctx, bal)
	})

	if err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "inventory.stock_moved", "stock_movement", mov.MovementID, workspaceID, map[string]any{
		"movement_id":   mov.MovementID,
		"sku_id":        mov.SkuID,
		"location_id":   mov.LocationID,
		"quantity":      mov.Quantity,
		"movement_type": mov.MovementType,
	})

	return mov, nil
}

// ----------------------------------------------------------------------------
// Platform Absolute Stock Sync (§2 of inventory_computation_contract.md)
// ----------------------------------------------------------------------------

// PlatformSyncAbsoluteCount compares an external channel's absolute count with local on_hand.
// If identical, NO-OP: returns nil movement (I10).
// If different, records a platform_sync delta movement.
// If external correction drives on_hand below reservations, preserves truth and alerts (I08).
func (s *Service) PlatformSyncAbsoluteCount(
	ctx context.Context,
	workspaceID, locationID, skuID string,
	count int32,
	syncKey string,
) (*Movement, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}

	pairs := []SkuLocPair{{SkuID: skuID, LocationID: locationID}}
	var mov *Movement

	err := s.store.AtomicExecute(ctx, workspaceID, pairs, func(tx StoreTx) error {
		bal, err := tx.GetBalanceForUpdate(ctx, workspaceID, skuID, locationID)
		if err != nil {
			return err
		}

		delta := count - bal.OnHand
		if delta == 0 {
			// Identical count: NO-OP per contract (I10)
			return nil
		}

		movKey := fmt.Sprintf("mov_sync_%s_%s_%s", syncKey, skuID, locationID)
		mov = &Movement{
			MovementID:    newUUID(),
			WorkspaceID:   workspaceID,
			SkuID:         skuID,
			LocationID:    locationID,
			MovementType:  MovementPlatformSync,
			MovementKey:   movKey,
			Quantity:      delta,
			ReferenceType: "platform_sync",
			Reason:        fmt.Sprintf("Sync absolute count %d (delta %d)", count, delta),
			CreatedAt:     s.clock(),
		}
		if err := tx.AppendMovement(ctx, mov); err != nil {
			return err
		}

		bal.OnHand = count
		if err := tx.UpdateBalance(ctx, bal); err != nil {
			return err
		}

		// I08: If external correction drives stock below reserved, emit discrepancy
		if bal.OnHand < bal.Reserved {
			s.emitEvent(ctx, "inventory.discrepancy_detected", "inventory_balance", bal.BalanceID, workspaceID, map[string]any{
				"workspace_id":   workspaceID,
				"sku_id":         skuID,
				"location_id":    locationID,
				"expected_stock": bal.Reserved,
				"actual_stock":   bal.OnHand,
			})
		}
		return nil
	})

	if err != nil {
		return nil, err
	}
	return mov, nil
}

// ----------------------------------------------------------------------------
// Reconciliation & Discrepancy Auditing (§3 of inventory_computation_contract.md)
// ----------------------------------------------------------------------------

func (s *Service) ReconcileLedger(ctx context.Context, workspaceID, skuID, locationID string) (*DiscrepancyReport, error) {
	bal, err := s.store.GetBalance(ctx, workspaceID, skuID, locationID)
	if err != nil {
		return nil, err
	}

	movements, _, err := s.store.ListMovements(ctx, workspaceID, skuID, locationID, 10000, 0)
	if err != nil {
		return nil, err
	}

	var sum int32 = 0
	for _, m := range movements {
		sum += m.Quantity
	}

	if sum != bal.OnHand {
		rep := &DiscrepancyReport{
			WorkspaceID:   workspaceID,
			SkuID:         skuID,
			LocationID:    locationID,
			ExpectedStock: sum,
			ActualStock:   bal.OnHand,
			Discrepancy:   bal.OnHand - sum,
		}
		s.emitEvent(ctx, "inventory.discrepancy_detected", "inventory_balance", bal.BalanceID, workspaceID, rep)
		return rep, ErrDiscrepancy
	}

	return &DiscrepancyReport{
		WorkspaceID:   workspaceID,
		SkuID:         skuID,
		LocationID:    locationID,
		ExpectedStock: sum,
		ActualStock:   bal.OnHand,
		Discrepancy:   0,
	}, nil
}

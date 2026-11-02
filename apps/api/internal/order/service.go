package order

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
)

type InventoryService interface {
	ReserveStock(ctx context.Context, workspaceID, orderID string, items []inventory.ReservationItem, ttl time.Duration) ([]*inventory.Reservation, error)
	FulfillReservation(ctx context.Context, workspaceID, orderID string) ([]*inventory.Movement, error)
	ReleaseReservation(ctx context.Context, workspaceID, orderID, reason string) error
	ShouldDeductStockForImportedOrder(ctx context.Context, workspaceID, skuID, locationID string, orderOrderedAt time.Time) (bool, error)
	RecordPhysicalReturn(ctx context.Context, workspaceID, orderID, returnID, skuID, locationID string, quantity int32, reason string) (*inventory.Movement, error)
}

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
	inventory InventoryService
	eventSink EventSink
	clock     func() time.Time
}

func NewService(store Store, inv InventoryService, sink EventSink, clock func() time.Time) *Service {
	if clock == nil {
		clock = time.Now
	}
	return &Service{
		store:     store,
		inventory: inv,
		eventSink: sink,
		clock:     clock,
	}
}

func (s *Service) emitEvent(ctx context.Context, eventType, aggregateType, aggregateID, workspaceID string, payload any) {
	if s.eventSink == nil {
		return
	}
	b, err := json.Marshal(payload)
	if err != nil {
		return
	}
	_ = s.eventSink.Emit(ctx, OutboxEvent{
		EventID:       newUUID(),
		EventType:     eventType,
		AggregateType: aggregateType,
		AggregateID:   aggregateID,
		WorkspaceID:   workspaceID,
		PayloadJSON:   b,
		CreatedAt:     s.clock().UTC(),
	})
}

// IngestOrder handles order creation and ingestion from external platforms or native channels.
// Enforces:
// 1. Idempotency on (platform, external_id, connected_account) and import_fingerprint
// 2. Historical order stock protection (I04 / Acceptance Target 2)
// 3. State initialization and reservation
func (s *Service) IngestOrder(ctx context.Context, o *Order, defaultLocationID string) (*Order, bool, error) {
	if o.WorkspaceID == "" {
		return nil, false, ErrMissingTenant
	}
	if o.Amount.IsNegative() || o.Amount.IsZero() {
		return nil, false, ErrInvalidAmount
	}

	// 1. Idempotency Check: Fingerprint
	if o.ImportFingerprint != "" {
		existing, err := s.store.FindOrderByImportFingerprint(ctx, o.WorkspaceID, o.ImportFingerprint)
		if err != nil {
			return nil, false, err
		}
		if existing != nil {
			return existing, false, nil // Idempotent return
		}
	}

	// Idempotency Check: External Order Identity
	if o.SourcePlatform != "" && o.ExternalOrderID != "" {
		existing, err := s.store.FindOrderByExternalID(ctx, o.WorkspaceID, o.SourcePlatform, o.ExternalOrderID, o.ConnectedAccountID)
		if err != nil {
			return nil, false, err
		}
		if existing != nil {
			return existing, false, nil // Idempotent return
		}
	}

	if o.OrderID == "" {
		o.OrderID = newUUID()
	}
	if o.LifecycleState == "" {
		o.LifecycleState = StateCreated
	}
	if o.OrderedAt.IsZero() {
		o.OrderedAt = s.clock().UTC()
	}

	// 2. Inventory evaluation: check if items should deduct stock
	var reservationItems []inventory.ReservationItem
	for _, item := range o.Items {
		if item.Sku == "" || item.Quantity <= 0 {
			continue
		}
		locID := defaultLocationID
		if locID == "" {
			locID = "00000000-0000-0000-0000-000000000001" // standard fallback
		}

		if s.inventory != nil {
			shouldDeduct, err := s.inventory.ShouldDeductStockForImportedOrder(ctx, o.WorkspaceID, item.Sku, locID, o.OrderedAt)
			if err != nil {
				return nil, false, fmt.Errorf("evaluate stock deduction for sku %s: %w", item.Sku, err)
			}
			if shouldDeduct {
				reservationItems = append(reservationItems, inventory.ReservationItem{
					SkuID:      item.Sku,
					LocationID: locID,
					Quantity:   item.Quantity,
				})
			}
		}
	}

	// If stock deduction is required and order is created, reserve stock
	if len(reservationItems) > 0 && s.inventory != nil {
		if o.LifecycleState == StateCreated {
			const holdTTL = 30 * time.Minute
			_, err := s.inventory.ReserveStock(ctx, o.WorkspaceID, o.OrderID, reservationItems, holdTTL)
			if err != nil {
				return nil, false, fmt.Errorf("reserve stock: %w", err)
			}
		} else if o.LifecycleState == StateConfirmed || o.LifecycleState == StateFulfilled {
			// Pre-confirmed order (e.g. historical paid order after baseline): reserve then fulfill immediately
			const holdTTL = 5 * time.Minute
			_, err := s.inventory.ReserveStock(ctx, o.WorkspaceID, o.OrderID, reservationItems, holdTTL)
			if err != nil {
				return nil, false, fmt.Errorf("reserve stock for confirmed order: %w", err)
			}
			_, err = s.inventory.FulfillReservation(ctx, o.WorkspaceID, o.OrderID)
			if err != nil {
				return nil, false, fmt.Errorf("fulfill stock for confirmed order: %w", err)
			}
		}
	}

	// 3. Persist Order
	if err := s.store.CreateOrder(ctx, o); err != nil {
		return nil, false, err
	}

	s.emitEvent(ctx, "commerce.order.created", "order", o.OrderID, o.WorkspaceID, map[string]any{
		"order_id":        o.OrderID,
		"lifecycle_state": o.LifecycleState,
		"amount":          o.Amount.Fixed6String(),
		"currency":        o.Currency,
		"item_count":      len(o.Items),
	})

	return o, true, nil
}

// ConfirmOrder transitions an order from created to confirmed and fulfills any held stock reservation.
func (s *Service) ConfirmOrder(ctx context.Context, workspaceID, orderID string) (*Order, error) {
	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateConfirmed {
		return o, nil // Idempotent
	}
	if !CanTransitionOrder(o.LifecycleState, StateConfirmed) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateConfirmed)
	}

	// Fulfill reservation in inventory ledger
	if s.inventory != nil {
		_, err := s.inventory.FulfillReservation(ctx, workspaceID, orderID)
		if err != nil && !errors.Is(err, inventory.ErrReservationNotFound) {
			return nil, fmt.Errorf("fulfill inventory reservation: %w", err)
		}
	}

	if err := s.store.UpdateOrderStatus(ctx, workspaceID, orderID, StateConfirmed, nil); err != nil {
		return nil, err
	}
	o.LifecycleState = StateConfirmed
	o.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.order.confirmed", "order", orderID, workspaceID, map[string]any{
		"order_id": orderID,
	})

	return o, nil
}

// FulfillOrder transitions an order from confirmed to fulfilled.
func (s *Service) FulfillOrder(ctx context.Context, workspaceID, orderID string) (*Order, error) {
	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateFulfilled {
		return o, nil // Idempotent
	}
	if !CanTransitionOrder(o.LifecycleState, StateFulfilled) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateFulfilled)
	}

	if err := s.store.UpdateOrderStatus(ctx, workspaceID, orderID, StateFulfilled, nil); err != nil {
		return nil, err
	}
	o.LifecycleState = StateFulfilled
	o.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.order.fulfilled", "order", orderID, workspaceID, map[string]any{
		"order_id": orderID,
	})

	return o, nil
}

// CompleteOrder marks an order completed.
func (s *Service) CompleteOrder(ctx context.Context, workspaceID, orderID string) (*Order, error) {
	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateCompleted {
		return o, nil
	}
	if !CanTransitionOrder(o.LifecycleState, StateCompleted) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateCompleted)
	}

	if err := s.store.UpdateOrderStatus(ctx, workspaceID, orderID, StateCompleted, nil); err != nil {
		return nil, err
	}
	o.LifecycleState = StateCompleted
	o.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.order.completed", "order", orderID, workspaceID, map[string]any{
		"order_id": orderID,
	})

	return o, nil
}

// CancelOrder cancels an order and releases any held stock reservations.
func (s *Service) CancelOrder(ctx context.Context, workspaceID, orderID, reason string) (*Order, error) {
	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateCancelled {
		return o, nil // Idempotent
	}
	if !CanTransitionOrder(o.LifecycleState, StateCancelled) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateCancelled)
	}

	// Release reservations if any held
	if s.inventory != nil {
		_ = s.inventory.ReleaseReservation(ctx, workspaceID, orderID, reason)
	}

	if err := s.store.UpdateOrderStatus(ctx, workspaceID, orderID, StateCancelled, nil); err != nil {
		return nil, err
	}
	o.LifecycleState = StateCancelled
	o.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.order.cancelled", "order", orderID, workspaceID, map[string]any{
		"order_id": orderID,
		"reason":   reason,
	})

	return o, nil
}

// RequestRefund creates a financial refund request.
// Verifies that requested refund amount <= order refundable remaining balance.
func (s *Service) RequestRefund(ctx context.Context, r *Refund) (*Refund, *Order, error) {
	if r.WorkspaceID == "" {
		return nil, nil, ErrMissingTenant
	}
	if r.Amount.IsNegative() || r.Amount.IsZero() {
		return nil, nil, ErrInvalidAmount
	}

	o, err := s.store.GetOrder(ctx, r.WorkspaceID, r.OrderID)
	if err != nil {
		return nil, nil, err
	}

	rem, err := o.RefundableRemaining()
	if err != nil {
		return nil, nil, err
	}
	if r.Amount.Cmp(rem) > 0 {
		return nil, nil, fmt.Errorf("%w: requested %s exceeds remaining refundable %s", ErrRefundExceedsOrderTotal, r.Amount.Fixed6String(), rem.Fixed6String())
	}

	if r.RefundID == "" {
		r.RefundID = newUUID()
	}
	r.LifecycleState = RefundRequested
	if r.Currency == "" {
		r.Currency = o.Currency
	}

	if err := s.store.CreateRefund(ctx, r); err != nil {
		return nil, nil, err
	}

	s.emitEvent(ctx, "commerce.refund.requested", "refund", r.RefundID, r.WorkspaceID, map[string]any{
		"refund_id": r.RefundID,
		"order_id":  r.OrderID,
		"amount":    r.Amount.Fixed6String(),
	})

	return r, o, nil
}

// ApproveRefund approves and completes a refund.
// Enforces Acceptance Target 3:
// - Partial refund transitions order to partially_refunded.
// - Followed by full refund transitions order to refunded.
// - Over-refunding is strictly rejected.
func (s *Service) ApproveRefund(ctx context.Context, workspaceID, refundID string) (*Refund, *Order, error) {
	r, err := s.store.GetRefund(ctx, workspaceID, refundID)
	if err != nil {
		return nil, nil, err
	}
	if r.LifecycleState == RefundApproved || r.LifecycleState == RefundCompleted {
		// Idempotent
		o, err := s.store.GetOrder(ctx, workspaceID, r.OrderID)
		return r, o, err
	}

	o, err := s.store.GetOrder(ctx, workspaceID, r.OrderID)
	if err != nil {
		return nil, nil, err
	}

	rem, err := o.RefundableRemaining()
	if err != nil {
		return nil, nil, err
	}
	if r.Amount.Cmp(rem) > 0 {
		return nil, nil, fmt.Errorf("%w: refund amount %s exceeds remaining refundable %s", ErrRefundExceedsOrderTotal, r.Amount.Fixed6String(), rem.Fixed6String())
	}

	newRefunded, err := o.RefundedAmount.Add(r.Amount)
	if err != nil {
		return nil, nil, err
	}

	var newOrderState LifecycleState
	if newRefunded.Cmp(o.Amount) == 0 {
		newOrderState = StateRefunded
	} else {
		newOrderState = StatePartiallyRefunded
	}

	if err := s.store.UpdateOrderStatus(ctx, workspaceID, o.OrderID, newOrderState, &newRefunded); err != nil {
		return nil, nil, err
	}
	if err := s.store.UpdateRefundStatus(ctx, workspaceID, refundID, RefundCompleted); err != nil {
		return nil, nil, err
	}

	r.LifecycleState = RefundCompleted
	r.UpdatedAt = s.clock().UTC()
	o.LifecycleState = newOrderState
	o.RefundedAmount = newRefunded
	o.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.refund.completed", "refund", refundID, workspaceID, map[string]any{
		"refund_id": refundID,
		"order_id":  o.OrderID,
		"amount":    r.Amount.Fixed6String(),
	})
	s.emitEvent(ctx, "commerce.order.refunded", "order", o.OrderID, workspaceID, map[string]any{
		"order_id":        o.OrderID,
		"lifecycle_state": newOrderState,
		"refunded_total":  newRefunded.Fixed6String(),
	})

	return r, o, nil
}

// CreateReturn creates a physical return request.
func (s *Service) CreateReturn(ctx context.Context, ret *Return) (*Return, error) {
	if ret.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	o, err := s.store.GetOrder(ctx, ret.WorkspaceID, ret.OrderID)
	if err != nil {
		return nil, err
	}
	_ = o

	if ret.ReturnID == "" {
		ret.ReturnID = newUUID()
	}
	ret.LifecycleState = ReturnInitiated
	if err := s.store.CreateReturn(ctx, ret); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "commerce.return.initiated", "return", ret.ReturnID, ret.WorkspaceID, map[string]any{
		"return_id": ret.ReturnID,
		"order_id":  ret.OrderID,
	})

	return ret, nil
}

// ReceiveReturn processes physical receipt and restocks inventory.
// NOTE: Physical return restocks inventory via inventoryService; refunds NEVER restock inventory!
func (s *Service) ReceiveReturn(ctx context.Context, workspaceID, returnID, restockLocationID string) (*Return, error) {
	ret, err := s.store.GetReturn(ctx, workspaceID, returnID)
	if err != nil {
		return nil, err
	}
	if ret.LifecycleState == ReturnClosed {
		return ret, nil // Idempotent
	}

	// Physical restock
	if s.inventory != nil && restockLocationID != "" {
		for _, item := range ret.Items {
			if item.Quantity > 0 && item.Sku != "" {
				_, err := s.inventory.RecordPhysicalReturn(ctx, workspaceID, ret.OrderID, returnID, item.Sku, restockLocationID, item.Quantity, item.Reason)
				if err != nil {
					return nil, fmt.Errorf("restock returned item %s: %w", item.Sku, err)
				}
			}
		}
	}

	if err := s.store.UpdateReturnStatus(ctx, workspaceID, returnID, ReturnClosed); err != nil {
		return nil, err
	}
	ret.LifecycleState = ReturnClosed
	ret.UpdatedAt = s.clock().UTC()

	// Update order state to returned if not already refunded
	o, err := s.store.GetOrder(ctx, workspaceID, ret.OrderID)
	if err == nil && o.LifecycleState != StateRefunded && o.LifecycleState != StatePartiallyRefunded {
		_ = s.store.UpdateOrderStatus(ctx, workspaceID, ret.OrderID, StateReturned, nil)
	}

	s.emitEvent(ctx, "commerce.return.closed", "return", returnID, workspaceID, map[string]any{
		"return_id": returnID,
		"order_id":  ret.OrderID,
	})

	return ret, nil
}

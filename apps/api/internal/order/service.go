package order

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type InventoryService interface {
	ReserveStock(ctx context.Context, workspaceID, orderID string, items []inventory.ReservationItem, ttl time.Duration) ([]*inventory.Reservation, error)
	FulfillReservation(ctx context.Context, workspaceID, orderID string) ([]*inventory.Movement, error)
	ReleaseReservation(ctx context.Context, workspaceID, orderID, reason string) error
	ShouldDeductStockForImportedOrder(ctx context.Context, workspaceID, skuID, locationID string, orderOrderedAt time.Time) (bool, error)
	RecordPhysicalReturn(ctx context.Context, workspaceID, orderID, returnID, skuID, locationID string, quantity int32, reason string) (*inventory.Movement, error)
}

type FinanceService interface {
	RecordOrderPosting(ctx context.Context, input finance.OrderPostingInput) error
	RecordRefundPosting(ctx context.Context, workspaceID, refundID, orderID string, refundAmount tenantdb.ExactDecimal, currency string, sourceClass, confidence string, fx finance.ExchangeRateSnapshot) error
	RecordOrderCorrection(ctx context.Context, workspaceID, orderID, component string, newAmount tenantdb.ExactDecimal, newVersion, sourceClass, confidence string, fx finance.ExchangeRateSnapshot) error
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
	finance   FinanceService
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

func (s *Service) SetFinance(fin FinanceService) {
	s.finance = fin
}

func (s *Service) WithFinance(fin FinanceService) *Service {
	s.finance = fin
	return s
}

func (s *Service) GetOrder(ctx context.Context, workspaceID, orderID string) (*Order, error) {
	return s.store.GetOrder(ctx, workspaceID, orderID)
}

func (s *Service) Store() Store {
	return s.store
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

func (s *Service) recordOrderPosting(ctx context.Context, o *Order) error {
	if s.finance == nil {
		return nil
	}
	cogsTotal := tenantdb.ZeroDecimal()
	hasCogs := false
	for _, it := range o.Items {
		if !it.UnitCogs.IsZero() {
			qtyDec := tenantdb.MustParseExactDecimal(fmt.Sprintf("%d", it.Quantity))
			lineCogs, err := it.UnitCogs.MulFloor(qtyDec)
			if err != nil {
				return err
			}
			cogsTotal, err = cogsTotal.Add(lineCogs)
			if err != nil {
				return err
			}
			hasCogs = true
		}
	}
	var cogsPtr *tenantdb.ExactDecimal
	if hasCogs {
		cogsPtr = &cogsTotal
	}

	return s.finance.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:      o.WorkspaceID,
		OrderID:          o.OrderID,
		OrderVersion:     "v1",
		LifecycleState:   string(o.LifecycleState),
		GrossAmount:      o.Amount,
		FeeAmount:        o.FeeBreakdown.PlatformFee,
		ShippingAmount:   o.FeeBreakdown.ShippingCost,
		COGSAmount:       cogsPtr,
		CommissionAmount: o.FeeBreakdown.AffiliateCommission,
		Currency:         o.Currency,
		SourceClass:      string(o.SourceClass),
		Confidence:       string(finance.ConfidenceHigh),
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  o.Currency,
			QuoteCurrency: o.Currency,
			RateToBase:    "1",
			SourceClass:   string(o.SourceClass),
		},
		EffectiveAt: s.clock().UTC(),
	})
}

// IngestOrder handles order creation and ingestion from external platforms or native channels.
// Enforces:
// 1. Idempotency on (platform, external_id, connected_account) and import_fingerprint
// 2. Historical order stock protection (I04 / Acceptance Target 2)
// 3. State initialization and reservation AFTER parent order row exists
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

	// 3. Persist Parent Order FIRST so inventory_reservations FK to orders(id) is always satisfied
	if err := s.store.CreateOrder(ctx, o); err != nil {
		return nil, false, err
	}

	// 4. Reserve/fulfill stock after parent order exists; roll back order creation on failure
	if len(reservationItems) > 0 && s.inventory != nil {
		if o.LifecycleState == StateCreated {
			const holdTTL = 30 * time.Minute
			_, err := s.inventory.ReserveStock(ctx, o.WorkspaceID, o.OrderID, reservationItems, holdTTL)
			if err != nil {
				_ = s.store.DeleteOrder(ctx, o.WorkspaceID, o.OrderID)
				return nil, false, fmt.Errorf("reserve stock: %w", err)
			}
		} else if o.LifecycleState == StateConfirmed || o.LifecycleState == StateFulfilled || o.LifecycleState == StateCompleted {
			// Pre-confirmed/completed order (e.g. historical paid order after baseline): reserve then fulfill immediately
			const holdTTL = 5 * time.Minute
			_, err := s.inventory.ReserveStock(ctx, o.WorkspaceID, o.OrderID, reservationItems, holdTTL)
			if err != nil {
				_ = s.store.DeleteOrder(ctx, o.WorkspaceID, o.OrderID)
				return nil, false, fmt.Errorf("reserve stock for confirmed order: %w", err)
			}
			_, err = s.inventory.FulfillReservation(ctx, o.WorkspaceID, o.OrderID)
			if err != nil {
				_ = s.inventory.ReleaseReservation(ctx, o.WorkspaceID, o.OrderID, "fulfill_failed_rollback")
				_ = s.store.DeleteOrder(ctx, o.WorkspaceID, o.OrderID)
				return nil, false, fmt.Errorf("fulfill stock for confirmed order: %w", err)
			}
		}
	}

	// 5. If order is ingested directly in StateCompleted, post to finance ledger atomically or roll back
	if o.LifecycleState == StateCompleted && s.finance != nil {
		if err := s.recordOrderPosting(ctx, o); err != nil {
			_ = s.store.DeleteOrder(ctx, o.WorkspaceID, o.OrderID)
			return nil, false, fmt.Errorf("record completed order finance posting: %w", err)
		}
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

// CompleteOrder marks an order completed and ensures its revenue/cost postings exist in Finance.
func (s *Service) CompleteOrder(ctx context.Context, workspaceID, orderID string) (*Order, error) {
	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateCompleted {
		if err := s.recordOrderPosting(ctx, o); err != nil {
			return nil, fmt.Errorf("record completed order finance posting: %w", err)
		}
		return o, nil
	}
	if !CanTransitionOrder(o.LifecycleState, StateCompleted) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateCompleted)
	}

	prevState := o.LifecycleState
	if err := s.store.UpdateOrderStatus(ctx, workspaceID, orderID, StateCompleted, nil); err != nil {
		return nil, err
	}
	o.LifecycleState = StateCompleted
	o.UpdatedAt = s.clock().UTC()

	// Post revenue and known costs to Finance Operating Ledger; roll back order status if posting fails
	if err := s.recordOrderPosting(ctx, o); err != nil {
		_ = s.store.UpdateOrderStatus(ctx, workspaceID, orderID, prevState, nil)
		return nil, fmt.Errorf("record completed order finance posting: %w", err)
	}

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
// Verifies currency match, external refund deduplication, and that requested refund amount <= order refundable remaining balance.
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

	if r.Currency != "" && o.Currency != "" && r.Currency != o.Currency {
		return nil, nil, fmt.Errorf("%w: refund currency %s does not match order currency %s", ErrCurrencyMismatch, r.Currency, o.Currency)
	}

	// Idempotent deduplication by external refund ID
	if r.ExternalRefundID != "" {
		existing, err := s.store.FindRefundByExternalID(ctx, r.WorkspaceID, r.OrderID, r.SourcePlatform, r.ExternalRefundID)
		if err != nil {
			return nil, nil, err
		}
		if existing != nil {
			return existing, o, nil
		}
	}
	if r.RefundID != "" {
		existing, err := s.store.GetRefund(ctx, r.WorkspaceID, r.RefundID)
		if err == nil && existing != nil {
			return existing, o, nil
		}
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

// ApproveRefund approves and completes a refund atomically.
// Enforces Acceptance Target 3:
// - Partial refund transitions order to partially_refunded.
// - Followed by full refund transitions order to refunded.
// - Over-refunding (including concurrent approvals) is strictly rejected.
func (s *Service) ApproveRefund(ctx context.Context, workspaceID, refundID string) (*Refund, *Order, error) {
	r, o, prevState, prevRefunded, newlyApproved, err := s.store.ApproveRefundAtomic(ctx, workspaceID, refundID)
	if err != nil {
		return nil, nil, err
	}

	// Post negative refund deduction to Finance Operating Ledger; revert approval if posting fails
	if s.finance != nil {
		fx := finance.ExchangeRateSnapshot{
			BaseCurrency:  o.Currency,
			QuoteCurrency: o.Currency,
			RateToBase:    "1",
			SourceClass:   string(o.SourceClass),
		}
		if err := s.finance.RecordRefundPosting(ctx, workspaceID, refundID, o.OrderID, r.Amount, r.Currency, string(o.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
			if newlyApproved {
				_ = s.store.RevertRefundApproval(ctx, workspaceID, refundID, o.OrderID, prevState, prevRefunded)
			}
			return nil, nil, fmt.Errorf("record refund finance posting: %w", err)
		}
	}

	if newlyApproved {
		s.emitEvent(ctx, "commerce.refund.completed", "refund", refundID, workspaceID, map[string]any{
			"refund_id": refundID,
			"order_id":  o.OrderID,
			"amount":    r.Amount.Fixed6String(),
		})
		s.emitEvent(ctx, "commerce.order.refunded", "order", o.OrderID, workspaceID, map[string]any{
			"order_id":        o.OrderID,
			"lifecycle_state": o.LifecycleState,
			"refunded_total":  o.RefundedAmount.Fixed6String(),
		})
	}

	return r, o, nil
}

// CreateReturn creates a physical return request.
// Enforces inventory contract §3: cumulative return quantity <= sold quantity across all non-rejected returns.
func (s *Service) CreateReturn(ctx context.Context, ret *Return) (*Return, error) {
	if ret.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	o, err := s.store.GetOrder(ctx, ret.WorkspaceID, ret.OrderID)
	if err != nil {
		return nil, err
	}

	if len(ret.Items) == 0 {
		return nil, fmt.Errorf("%w: return must contain at least one item", ErrInvalidInput)
	}

	// Validate cumulative returned quantity per SKU
	priorReturns, err := s.store.ListReturnsByOrder(ctx, ret.WorkspaceID, ret.OrderID)
	if err != nil {
		return nil, err
	}

	orderedQty := make(map[string]int32)
	for _, it := range o.Items {
		orderedQty[it.Sku] += it.Quantity
	}

	returnedQty := make(map[string]int32)
	for _, pr := range priorReturns {
		if pr.LifecycleState != ReturnRejected {
			for _, it := range pr.Items {
				returnedQty[it.Sku] += it.Quantity
			}
		}
	}

	for _, it := range ret.Items {
		if it.Quantity <= 0 {
			return nil, fmt.Errorf("%w: return quantity must be positive", ErrInvalidInput)
		}
		totalRet := returnedQty[it.Sku] + it.Quantity
		maxAllowed := orderedQty[it.Sku]
		if totalRet > maxAllowed {
			return nil, fmt.Errorf("%w: sku %s cumulative return %d exceeds ordered quantity %d",
				ErrReturnExceedsOrderQuantity, it.Sku, totalRet, maxAllowed)
		}
	}

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

// ApproveReturn approves an initiated return.
func (s *Service) ApproveReturn(ctx context.Context, workspaceID, returnID string) (*Return, error) {
	ret, err := s.store.GetReturn(ctx, workspaceID, returnID)
	if err != nil {
		return nil, err
	}
	if ret.LifecycleState == ReturnApproved {
		return ret, nil // Idempotent
	}
	if !CanTransitionReturn(ret.LifecycleState, ReturnApproved) {
		return nil, fmt.Errorf("%w: cannot transition return from %s to %s", ErrInvalidReturnTransition, ret.LifecycleState, ReturnApproved)
	}

	if err := s.store.UpdateReturnStatus(ctx, workspaceID, returnID, ReturnApproved); err != nil {
		return nil, err
	}
	ret.LifecycleState = ReturnApproved
	ret.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.return.approved", "return", returnID, workspaceID, map[string]any{
		"return_id": returnID,
		"order_id":  ret.OrderID,
	})
	return ret, nil
}

// ShipReturn marks an approved return as shipped back with tracking information.
func (s *Service) ShipReturn(ctx context.Context, workspaceID, returnID, trackingNumber string) (*Return, error) {
	ret, err := s.store.GetReturn(ctx, workspaceID, returnID)
	if err != nil {
		return nil, err
	}
	if ret.LifecycleState == ReturnShippedBack {
		return ret, nil // Idempotent
	}
	if !CanTransitionReturn(ret.LifecycleState, ReturnShippedBack) {
		return nil, fmt.Errorf("%w: cannot transition return from %s to %s", ErrInvalidReturnTransition, ret.LifecycleState, ReturnShippedBack)
	}

	ret.TrackingNumber = trackingNumber
	if err := s.store.UpdateReturnStatus(ctx, workspaceID, returnID, ReturnShippedBack); err != nil {
		return nil, err
	}
	ret.LifecycleState = ReturnShippedBack
	ret.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.return.shipped_back", "return", returnID, workspaceID, map[string]any{
		"return_id":       returnID,
		"order_id":        ret.OrderID,
		"tracking_number": trackingNumber,
	})
	return ret, nil
}

// InspectReturn records physical inspection result.
func (s *Service) InspectReturn(ctx context.Context, workspaceID, returnID string, passed bool, notes string) (*Return, error) {
	ret, err := s.store.GetReturn(ctx, workspaceID, returnID)
	if err != nil {
		return nil, err
	}
	target := ReturnInspected
	if !passed {
		target = ReturnRejected
	}
	if ret.LifecycleState == target {
		return ret, nil // Idempotent
	}
	if !CanTransitionReturn(ret.LifecycleState, target) {
		return nil, fmt.Errorf("%w: cannot transition return from %s to %s", ErrInvalidReturnTransition, ret.LifecycleState, target)
	}

	if err := s.store.UpdateReturnStatus(ctx, workspaceID, returnID, target); err != nil {
		return nil, err
	}
	ret.LifecycleState = target
	ret.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.return.inspected", "return", returnID, workspaceID, map[string]any{
		"return_id": returnID,
		"order_id":  ret.OrderID,
		"passed":    passed,
		"notes":     notes,
	})
	return ret, nil
}

// RejectReturn rejects an initiated or inspected return.
func (s *Service) RejectReturn(ctx context.Context, workspaceID, returnID, reason string) (*Return, error) {
	ret, err := s.store.GetReturn(ctx, workspaceID, returnID)
	if err != nil {
		return nil, err
	}
	if ret.LifecycleState == ReturnRejected {
		return ret, nil // Idempotent
	}
	if !CanTransitionReturn(ret.LifecycleState, ReturnRejected) {
		return nil, fmt.Errorf("%w: cannot transition return from %s to %s", ErrInvalidReturnTransition, ret.LifecycleState, ReturnRejected)
	}

	if err := s.store.UpdateReturnStatus(ctx, workspaceID, returnID, ReturnRejected); err != nil {
		return nil, err
	}
	ret.LifecycleState = ReturnRejected
	ret.UpdatedAt = s.clock().UTC()

	s.emitEvent(ctx, "commerce.return.rejected", "return", returnID, workspaceID, map[string]any{
		"return_id": returnID,
		"order_id":  ret.OrderID,
		"reason":    reason,
	})
	return ret, nil
}

// ReceiveReturn processes physical receipt and restocks inventory.
// NOTE: Physical return restocks inventory via inventoryService; refunds NEVER restock inventory!
// Enforces that duplicate callbacks or replays are idempotent and restock exactly once.
func (s *Service) ReceiveReturn(ctx context.Context, workspaceID, returnID, restockLocationID string) (*Return, error) {
	ret, err := s.store.GetReturn(ctx, workspaceID, returnID)
	if err != nil {
		return nil, err
	}
	if ret.LifecycleState == ReturnClosed {
		return ret, nil // Idempotent no-op
	}
	if ret.LifecycleState == ReturnRejected {
		return nil, fmt.Errorf("%w: cannot receive a rejected return", ErrReturnAlreadyProcessed)
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

// UpdateFeeBreakdown updates an order's fee breakdown (e.g. from platform settlement)
// and records correcting postings in Finance while preserving proof and audit trail.
func (s *Service) UpdateFeeBreakdown(ctx context.Context, workspaceID, orderID string, newFees FeeBreakdown, version, evidenceRef, reason string) (*Order, error) {
	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}

	oldFees := o.FeeBreakdown
	o.FeeBreakdown = newFees
	o.UpdatedAt = s.clock().UTC()

	// Persist order with updated fee breakdown
	if err := s.store.UpdateOrder(ctx, o); err != nil {
		return nil, err
	}

	// If finance service is wired and order is completed, correct postings
	if s.finance != nil && (o.LifecycleState == StateCompleted || o.LifecycleState == StatePartiallyRefunded || o.LifecycleState == StateRefunded) {
		fx := finance.ExchangeRateSnapshot{
			BaseCurrency:  o.Currency,
			QuoteCurrency: o.Currency,
			RateToBase:    "1",
			SourceClass:   string(o.SourceClass),
		}

		rollbackFees := func() {
			o.FeeBreakdown = oldFees
			_ = s.store.UpdateOrder(ctx, o)
		}

		// Platform fee correction
		if newFees.PlatformFee.Cmp(oldFees.PlatformFee) != 0 {
			negFee, _ := tenantdb.ZeroDecimal().Sub(newFees.PlatformFee)
			if err := s.finance.RecordOrderCorrection(ctx, workspaceID, orderID, finance.ComponentPlatformFee, negFee, version, string(o.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
				rollbackFees()
				return nil, fmt.Errorf("record platform fee correction: %w", err)
			}
		}
		// Shipping cost correction
		if newFees.ShippingCost.Cmp(oldFees.ShippingCost) != 0 {
			negShip, _ := tenantdb.ZeroDecimal().Sub(newFees.ShippingCost)
			if err := s.finance.RecordOrderCorrection(ctx, workspaceID, orderID, finance.ComponentShipping, negShip, version, string(o.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
				rollbackFees()
				return nil, fmt.Errorf("record shipping cost correction: %w", err)
			}
		}
		// Affiliate commission correction
		if newFees.AffiliateCommission.Cmp(oldFees.AffiliateCommission) != 0 {
			negComm, _ := tenantdb.ZeroDecimal().Sub(newFees.AffiliateCommission)
			if err := s.finance.RecordOrderCorrection(ctx, workspaceID, orderID, finance.ComponentCommission, negComm, version, string(o.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
				rollbackFees()
				return nil, fmt.Errorf("record affiliate commission correction: %w", err)
			}
		}
	}

	s.emitEvent(ctx, "commerce.order.fee_corrected", "order", orderID, workspaceID, map[string]any{
		"order_id":     orderID,
		"evidence_ref": evidenceRef,
		"reason":       reason,
		"version":      version,
	})

	return o, nil
}

// HandlePaymentConfirmation processes payment confirmation for an order, handling races against reservation expiry.
// If reservation expired or is missing:
// - If stock is still sellable, re-reserves and fulfills immediately on the canonical order ID.
// - If stock is exhausted, flags order as payment anomaly (stock exhausted), blocking fulfillment and preserving sellable >= 0.
func (s *Service) HandlePaymentConfirmation(ctx context.Context, workspaceID, orderID, defaultLocationID string) (*Order, error) {
	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateConfirmed || o.LifecycleState == StateFulfilled || o.LifecycleState == StateCompleted {
		return o, nil // Idempotent
	}
	if o.LifecycleState == StateCancelled {
		return nil, fmt.Errorf("%w: cannot confirm cancelled order; requires refund flow", ErrInvalidOrderTransition)
	}

	// Try normal fulfillment of existing held reservation
	if s.inventory != nil {
		_, err := s.inventory.FulfillReservation(ctx, workspaceID, orderID)
		if err != nil {
			if errors.Is(err, inventory.ErrReservationNotFound) || errors.Is(err, inventory.ErrReservationExpired) || errors.Is(err, inventory.ErrReservationConflict) {
				// Reservation expired! Attempt late recovery: check if stock is still available
				var items []inventory.ReservationItem
				for _, it := range o.Items {
					if it.Sku != "" && it.Quantity > 0 {
						loc := defaultLocationID
						if loc == "" {
							loc = "00000000-0000-0000-0000-000000000001"
						}
						items = append(items, inventory.ReservationItem{
							SkuID:      it.Sku,
							LocationID: loc,
							Quantity:   it.Quantity,
						})
					}
				}
				if len(items) > 0 {
					// Attempt fresh reservation on the canonical orderID with short TTL
					_, resErr := s.inventory.ReserveStock(ctx, workspaceID, orderID, items, 5*time.Minute)
					if resErr != nil {
						// Stock is exhausted! Fulfill must fail closed to prevent oversell!
						s.emitEvent(ctx, "commerce.order.payment_anomaly", "order", orderID, workspaceID, map[string]any{
							"order_id": orderID,
							"reason":   "late payment after expiry, stock exhausted",
							"error":    resErr.Error(),
						})
						return nil, fmt.Errorf("late payment recovery failed: stock exhausted: %w", resErr)
					}
					// Successfully re-reserved: fulfill the reservation on the canonical orderID
					if _, fulfillErr := s.inventory.FulfillReservation(ctx, workspaceID, orderID); fulfillErr != nil {
						_ = s.inventory.ReleaseReservation(ctx, workspaceID, orderID, "late_fulfill_failed_rollback")
						return nil, fmt.Errorf("late payment fulfill reservation failed: %w", fulfillErr)
					}
				}
			} else {
				return nil, fmt.Errorf("fulfill reservation: %w", err)
			}
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

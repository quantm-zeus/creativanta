package order

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
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

type inventoryStoreProvider interface {
	Store() inventory.Store
}

type AffiliateOrderVerifier interface {
	SyncOrderState(ctx context.Context, workspaceID, orderID string, grossAmount, refundedAmount tenantdb.ExactDecimal, currency, lifecycleState string) error
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
	store      Store
	inventory  InventoryService
	finance    FinanceService
	affiliate  AffiliateOrderVerifier
	eventSink  EventSink
	clock      func() time.Time
	entityLock sync.Map
}

func (s *Service) lockEntity(kind, workspaceID, id string) func() {
	if id == "" {
		return func() {}
	}
	key := kind + ":" + workspaceID + ":" + id
	val, _ := s.entityLock.LoadOrStore(key, &sync.Mutex{})
	mu := val.(*sync.Mutex)
	mu.Lock()
	return mu.Unlock
}

func orderForwardRank(st LifecycleState) int {
	switch st {
	case StateCreated:
		return 1
	case StateConfirmed:
		return 2
	case StateFulfilled:
		return 3
	case StateCompleted:
		return 4
	case StatePartiallyRefunded, StateRefunded, StateReturned:
		return 5
	default:
		return 0
	}
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

func (s *Service) SetAffiliateVerifier(v AffiliateOrderVerifier) {
	s.affiliate = v
}

func (s *Service) WithAffiliateVerifier(v AffiliateOrderVerifier) *Service {
	s.affiliate = v
	return s
}

func (s *Service) syncAffiliateOrder(ctx context.Context, o *Order) {
	if s.affiliate == nil || o == nil {
		return
	}
	_ = s.affiliate.SyncOrderState(ctx, o.WorkspaceID, o.OrderID, o.Amount, o.RefundedAmount, o.Currency, string(o.LifecycleState))
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

func isRecognizedOrderState(state LifecycleState) bool {
	return state == StateCompleted || state == StatePartiallyRefunded || state == StateRefunded || state == StateReturned
}

func orderEconomicVersion(o *Order) int {
	if o == nil || o.Metadata == nil {
		return 1
	}
	switch v := o.Metadata["economic_version"].(type) {
	case int:
		if v >= 1 {
			return v
		}
	case int64:
		if v >= 1 {
			return int(v)
		}
	case float64:
		if int(v) >= 1 {
			return int(v)
		}
	case string:
		var parsed int
		if _, err := fmt.Sscanf(v, "%d", &parsed); err == nil && parsed >= 1 {
			return parsed
		}
	}
	return 1
}

func orderCogsTotal(items []OrderItem) (tenantdb.ExactDecimal, bool, error) {
	cogsTotal := tenantdb.ZeroDecimal()
	hasCogs := false
	for _, it := range items {
		if !it.UnitCogs.IsZero() {
			qtyDec := tenantdb.MustParseExactDecimal(fmt.Sprintf("%d", it.Quantity))
			lineCogs, err := it.UnitCogs.MulFloor(qtyDec)
			if err != nil {
				return tenantdb.ZeroDecimal(), false, err
			}
			cogsTotal, err = cogsTotal.Add(lineCogs)
			if err != nil {
				return tenantdb.ZeroDecimal(), false, err
			}
			hasCogs = true
		}
	}
	return cogsTotal, hasCogs, nil
}

func isZeroFeeBreakdown(fb FeeBreakdown) bool {
	if !fb.PlatformFee.IsZero() ||
		!fb.PaymentFee.IsZero() ||
		!fb.ShippingCost.IsZero() ||
		!fb.AffiliateCommission.IsZero() ||
		!fb.VatAmount.IsZero() {
		return false
	}
	for _, of := range fb.OtherFees {
		if !of.Amount.IsZero() {
			return false
		}
	}
	return true
}

func feeBreakdownEqual(a, b FeeBreakdown) bool {
	if a.PlatformFee.Cmp(b.PlatformFee) != 0 ||
		a.PaymentFee.Cmp(b.PaymentFee) != 0 ||
		a.ShippingCost.Cmp(b.ShippingCost) != 0 ||
		a.AffiliateCommission.Cmp(b.AffiliateCommission) != 0 ||
		a.VatAmount.Cmp(b.VatAmount) != 0 ||
		len(a.OtherFees) != len(b.OtherFees) {
		return false
	}
	for i := range a.OtherFees {
		if a.OtherFees[i].Name != b.OtherFees[i].Name ||
			a.OtherFees[i].Amount.Cmp(b.OtherFees[i].Amount) != 0 {
			return false
		}
	}
	return true
}

func orderItemsEqual(a, b []OrderItem) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i].Sku != b[i].Sku ||
			a[i].ProductID != b[i].ProductID ||
			a[i].PlatformItemID != b[i].PlatformItemID ||
			a[i].Variation != b[i].Variation ||
			a[i].Quantity != b[i].Quantity ||
			a[i].UnitPrice.Cmp(b[i].UnitPrice) != 0 ||
			a[i].Discount.Cmp(b[i].Discount) != 0 ||
			a[i].Total.Cmp(b[i].Total) != 0 ||
			a[i].UnitCogs.Cmp(b[i].UnitCogs) != 0 {
			return false
		}
	}
	return true
}

func hasOrderEconomicRevision(existing, incoming *Order) bool {
	if existing == nil || incoming == nil {
		return false
	}
	if !incoming.Amount.IsZero() && incoming.Amount.Cmp(existing.Amount) != 0 {
		return true
	}
	if !isZeroFeeBreakdown(incoming.FeeBreakdown) && !feeBreakdownEqual(existing.FeeBreakdown, incoming.FeeBreakdown) {
		return true
	}
	if len(incoming.Items) > 0 && !orderItemsEqual(existing.Items, incoming.Items) {
		return true
	}
	if !incoming.TaxAmount.IsZero() && incoming.TaxAmount.Cmp(existing.TaxAmount) != 0 {
		return true
	}
	return false
}

func (s *Service) recordOrderPosting(ctx context.Context, o *Order) error {
	if s.finance == nil {
		return nil
	}
	cogsTotal, hasCogs, err := orderCogsTotal(o.Items)
	if err != nil {
		return err
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
		PaymentFeeAmount: o.FeeBreakdown.PaymentFee,
		ShippingAmount:   o.FeeBreakdown.ShippingCost,
		COGSAmount:       cogsPtr,
		CommissionAmount: o.FeeBreakdown.AffiliateCommission,
		Currency:         o.Currency,
		SourceClass:      string(o.SourceClass),
		SourcePlatform:   o.SourcePlatform,
		ProductID:        o.ProductID,
		CampaignID:       o.CampaignID,
		PostID:           o.PostID,
		Confidence:       string(finance.ConfidenceHigh),
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  o.Currency,
			QuoteCurrency: o.Currency,
			RateToBase:    "1",
			SourceClass:   string(o.SourceClass),
		},
		EffectiveAt:     s.clock().UTC(),
		RecognizedAt:    o.RecognizedAt,
		OrderedAt:       o.OrderedAt,
		SourceUpdatedAt: o.SourceUpdatedAt,
	})
}

func (s *Service) applyOrderEconomicRevision(ctx context.Context, existing, incoming *Order) (bool, error) {
	if existing == nil || incoming == nil {
		return false, nil
	}
	// Do not allow an untimestamped payload to overwrite an already-timestamped order's economic fields.
	if existing.SourceUpdatedAt != nil && incoming.SourceUpdatedAt == nil {
		return false, nil
	}

	hasEconChange := hasOrderEconomicRevision(existing, incoming)
	hasNewerTimestamp := incoming.SourceUpdatedAt != nil && (existing.SourceUpdatedAt == nil || incoming.SourceUpdatedAt.After(*existing.SourceUpdatedAt))
	hasNewerRecognizedAt := incoming.RecognizedAt != nil && (existing.RecognizedAt == nil || !incoming.RecognizedAt.Equal(*existing.RecognizedAt))
	if !hasEconChange && !hasNewerTimestamp && !hasNewerRecognizedAt {
		return false, nil
	}

	newAmount := existing.Amount
	if !incoming.Amount.IsZero() {
		newAmount = incoming.Amount
	}
	newFees := existing.FeeBreakdown
	if !isZeroFeeBreakdown(incoming.FeeBreakdown) {
		newFees = incoming.FeeBreakdown
	}
	newItems := existing.Items
	if len(incoming.Items) > 0 {
		newItems = make([]OrderItem, len(incoming.Items))
		copy(newItems, incoming.Items)
	}
	newTax := existing.TaxAmount
	if !incoming.TaxAmount.IsZero() {
		newTax = incoming.TaxAmount
	}

	nextVer := orderEconomicVersion(existing)
	if hasEconChange && isRecognizedOrderState(existing.LifecycleState) {
		if s.finance != nil && nextVer == 1 && existing.LifecycleState == StateCompleted {
			if err := s.recordOrderPosting(ctx, existing); err != nil {
				return false, fmt.Errorf("record initial order finance posting before revision: %w", err)
			}
		}
		nextVer++
		verStr := fmt.Sprintf("v%d", nextVer)
		if s.finance != nil {
			fx := finance.ExchangeRateSnapshot{
				BaseCurrency:  existing.Currency,
				QuoteCurrency: existing.Currency,
				RateToBase:    "1",
				SourceClass:   string(existing.SourceClass),
			}
			if newAmount.Cmp(existing.Amount) != 0 {
				if err := s.finance.RecordOrderCorrection(ctx, existing.WorkspaceID, existing.OrderID, finance.ComponentRevenue, newAmount, verStr, string(existing.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
					return false, fmt.Errorf("record revenue correction: %w", err)
				}
			}
			oldCombinedFee, _ := existing.FeeBreakdown.PlatformFee.Add(existing.FeeBreakdown.PaymentFee)
			newCombinedFee, _ := newFees.PlatformFee.Add(newFees.PaymentFee)
			if newCombinedFee.Cmp(oldCombinedFee) != 0 {
				negFee, _ := tenantdb.ZeroDecimal().Sub(newCombinedFee)
				if err := s.finance.RecordOrderCorrection(ctx, existing.WorkspaceID, existing.OrderID, finance.ComponentPlatformFee, negFee, verStr, string(existing.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
					return false, fmt.Errorf("record platform fee correction: %w", err)
				}
			}
			if newFees.ShippingCost.Cmp(existing.FeeBreakdown.ShippingCost) != 0 {
				negShip, _ := tenantdb.ZeroDecimal().Sub(newFees.ShippingCost)
				if err := s.finance.RecordOrderCorrection(ctx, existing.WorkspaceID, existing.OrderID, finance.ComponentShipping, negShip, verStr, string(existing.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
					return false, fmt.Errorf("record shipping cost correction: %w", err)
				}
			}
			if newFees.AffiliateCommission.Cmp(existing.FeeBreakdown.AffiliateCommission) != 0 {
				negComm, _ := tenantdb.ZeroDecimal().Sub(newFees.AffiliateCommission)
				if err := s.finance.RecordOrderCorrection(ctx, existing.WorkspaceID, existing.OrderID, finance.ComponentCommission, negComm, verStr, string(existing.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
					return false, fmt.Errorf("record affiliate commission correction: %w", err)
				}
			}
			oldCogs, oldHasCogs, err := orderCogsTotal(existing.Items)
			if err != nil {
				return false, err
			}
			newCogs, newHasCogs, err := orderCogsTotal(newItems)
			if err != nil {
				return false, err
			}
			if (oldHasCogs || newHasCogs) && newCogs.Cmp(oldCogs) != 0 {
				negCogs, _ := tenantdb.ZeroDecimal().Sub(newCogs)
				if err := s.finance.RecordOrderCorrection(ctx, existing.WorkspaceID, existing.OrderID, finance.ComponentCOGS, negCogs, verStr, string(existing.SourceClass), string(finance.ConfidenceHigh), fx); err != nil {
					return false, fmt.Errorf("record cogs correction: %w", err)
				}
			}
		}
		if existing.Metadata == nil {
			existing.Metadata = make(map[string]any)
		}
		existing.Metadata["economic_version"] = nextVer
	}

	existing.Amount = newAmount
	existing.FeeBreakdown = newFees
	existing.Items = newItems
	existing.TaxAmount = newTax
	if hasNewerTimestamp {
		ts := *incoming.SourceUpdatedAt
		existing.SourceUpdatedAt = &ts
	}
	if hasNewerRecognizedAt {
		rt := *incoming.RecognizedAt
		existing.RecognizedAt = &rt
	}
	existing.UpdatedAt = s.clock().UTC()
	if err := s.store.UpdateOrder(ctx, existing); err != nil {
		return false, err
	}

	if hasEconChange {
		s.emitEvent(ctx, "commerce.order.fee_corrected", "order", existing.OrderID, existing.WorkspaceID, map[string]any{
			"order_id": existing.OrderID,
			"amount":   existing.Amount.Fixed6String(),
			"version":  fmt.Sprintf("v%d", nextVer),
			"reason":   "ingest_economic_revision",
		})
	}
	return hasEconChange, nil
}

func (s *Service) resolveInventoryStore() inventory.Store {
	if s.inventory == nil {
		return nil
	}
	if sp, ok := s.inventory.(inventoryStoreProvider); ok {
		return sp.Store()
	}
	return nil
}

func (s *Service) resolveOrderLocationID(ctx context.Context, o *Order, defaultLocationID string) string {
	if loc := strings.TrimSpace(defaultLocationID); loc != "" {
		return loc
	}
	if o != nil && o.Metadata != nil {
		if loc, ok := o.Metadata["default_location_id"].(string); ok && strings.TrimSpace(loc) != "" {
			return strings.TrimSpace(loc)
		}
	}
	if invStore := s.resolveInventoryStore(); invStore != nil && o != nil {
		if resList, err := invStore.ListReservationsByOrder(ctx, o.WorkspaceID, o.OrderID); err == nil {
			for _, r := range resList {
				if strings.TrimSpace(r.LocationID) != "" {
					return strings.TrimSpace(r.LocationID)
				}
			}
		}
		if defLoc, err := invStore.GetDefaultLocation(ctx, o.WorkspaceID); err == nil && defLoc != nil && strings.TrimSpace(defLoc.LocationID) != "" {
			return strings.TrimSpace(defLoc.LocationID)
		}
		if bals, _, err := invStore.ListBalances(ctx, o.WorkspaceID, "", 50, 0); err == nil {
			for _, it := range o.Items {
				for _, b := range bals {
					if b.SkuID == it.Sku && strings.TrimSpace(b.LocationID) != "" {
						return strings.TrimSpace(b.LocationID)
					}
				}
			}
		}
	}
	return "00000000-0000-0000-0000-000000000001"
}

func (s *Service) buildReservationItems(ctx context.Context, o *Order, defaultLocationID string) ([]inventory.ReservationItem, error) {
	if s.inventory == nil || o == nil {
		return nil, nil
	}
	resolvedLocID := s.resolveOrderLocationID(ctx, o, defaultLocationID)
	var reservationItems []inventory.ReservationItem
	for _, item := range o.Items {
		if item.Sku == "" || item.Quantity <= 0 {
			continue
		}
		locID := resolvedLocID
		shouldDeduct, err := s.inventory.ShouldDeductStockForImportedOrder(ctx, o.WorkspaceID, item.Sku, locID, o.OrderedAt)
		if err != nil {
			return nil, fmt.Errorf("evaluate stock deduction for sku %s: %w", item.Sku, err)
		}
		if shouldDeduct {
			reservationItems = append(reservationItems, inventory.ReservationItem{
				SkuID:      item.Sku,
				LocationID: locID,
				Quantity:   item.Quantity,
			})
		}
	}
	return reservationItems, nil
}

// ensureOrderStockEffects idempotently reconciles stock reservations and sale deductions for an order's
// target/effective lifecycle state, recovering safely if a previous attempt crashed after persisting the order row.
func (s *Service) ensureOrderStockEffects(ctx context.Context, o *Order, effectiveState LifecycleState, defaultLocationID string) error {
	if s.inventory == nil || o == nil || effectiveState == StateCancelled || effectiveState == StateReturned {
		return nil
	}
	reservationItems, err := s.buildReservationItems(ctx, o, defaultLocationID)
	if err != nil {
		return err
	}
	if len(reservationItems) == 0 {
		return nil
	}

	if effectiveState == StateCreated {
		const holdTTL = 30 * time.Minute
		_, err := s.inventory.ReserveStock(ctx, o.WorkspaceID, o.OrderID, reservationItems, holdTTL)
		if err != nil && !errors.Is(err, inventory.ErrReservationConflict) {
			return fmt.Errorf("reserve stock: %w", err)
		}
		return nil
	}

	if effectiveState == StateConfirmed || effectiveState == StateFulfilled || effectiveState == StateCompleted ||
		effectiveState == StatePartiallyRefunded || effectiveState == StateRefunded {
		_, err := s.inventory.FulfillReservation(ctx, o.WorkspaceID, o.OrderID)
		if err == nil {
			return nil
		}
		if errors.Is(err, inventory.ErrReservationNotFound) || errors.Is(err, inventory.ErrReservationExpired) || errors.Is(err, inventory.ErrReservationConflict) {
			const holdTTL = 5 * time.Minute
			if _, resErr := s.inventory.ReserveStock(ctx, o.WorkspaceID, o.OrderID, reservationItems, holdTTL); resErr != nil && !errors.Is(resErr, inventory.ErrReservationConflict) {
				return fmt.Errorf("reserve stock for order %s: %w", o.OrderID, resErr)
			}
			if _, fulErr := s.inventory.FulfillReservation(ctx, o.WorkspaceID, o.OrderID); fulErr != nil {
				return fmt.Errorf("fulfill stock for order %s: %w", o.OrderID, fulErr)
			}
			return nil
		}
		return fmt.Errorf("fulfill stock for order %s: %w", o.OrderID, err)
	}
	return nil
}

// releaseOrCompensateOrderStockOnCancel releases held reservations and, if an order was already confirmed
// (consuming its reservation prior to physical fulfillment), idempotently restores on-hand stock using a
// deterministic cancellation compensation adjustment movement (distinct from physical customer returns).
func (s *Service) releaseOrCompensateOrderStockOnCancel(ctx context.Context, o *Order, reason string) error {
	if s.inventory == nil || o == nil {
		return nil
	}
	if err := s.inventory.ReleaseReservation(ctx, o.WorkspaceID, o.OrderID, reason); err != nil {
		return err
	}

	sp, ok := s.inventory.(inventoryStoreProvider)
	if !ok || sp.Store() == nil {
		return nil
	}
	invStore := sp.Store()
	resList, err := invStore.ListReservationsByOrder(ctx, o.WorkspaceID, o.OrderID)
	if err != nil || len(resList) == 0 {
		return err
	}

	var pairs []inventory.SkuLocPair
	seen := make(map[string]struct{}, len(resList))
	for _, r := range resList {
		k := r.SkuID + ":" + r.LocationID
		if _, exists := seen[k]; !exists {
			seen[k] = struct{}{}
			pairs = append(pairs, inventory.SkuLocPair{SkuID: r.SkuID, LocationID: r.LocationID})
		}
	}

	return invStore.AtomicExecute(ctx, o.WorkspaceID, pairs, func(tx inventory.StoreTx) error {
		activeResList, err := tx.ListReservationsByOrder(ctx, o.WorkspaceID, o.OrderID)
		if err != nil {
			return err
		}
		for _, r := range activeResList {
			if r.Status == inventory.ResHeld {
				if err := tx.UpdateReservationStatus(ctx, o.WorkspaceID, r.ReservationID, inventory.ResReleased); err != nil {
					return err
				}
				if bal, bErr := tx.GetBalanceForUpdate(ctx, o.WorkspaceID, r.SkuID, r.LocationID); bErr == nil && bal != nil {
					bal.Reserved -= r.Quantity
					if bal.Reserved < 0 {
						bal.Reserved = 0
					}
					if err := tx.UpdateBalance(ctx, bal); err != nil {
						return err
					}
				}
				continue
			}

			// Pre-fulfillment cancellation compensation: check if a sale movement was recorded for this order line
			saleMovKey := fmt.Sprintf("mov_sale_%s_%s_%s", o.OrderID, r.SkuID, r.LocationID)
			saleMov, err := tx.FindMovementByKey(ctx, o.WorkspaceID, saleMovKey)
			if err != nil {
				return err
			}
			if saleMov == nil {
				continue
			}

			compMovKey := fmt.Sprintf("mov_cancel_comp_%s_%s_%s", o.OrderID, r.SkuID, r.LocationID)
			existingComp, err := tx.FindMovementByKey(ctx, o.WorkspaceID, compMovKey)
			if err != nil {
				return err
			}
			if existingComp == nil {
				cancelReason := strings.TrimSpace(reason)
				if cancelReason == "" {
					cancelReason = "Pre-fulfillment confirmed order cancelled"
				}
				mov := &inventory.Movement{
					MovementID:    newUUID(),
					WorkspaceID:   o.WorkspaceID,
					SkuID:         r.SkuID,
					LocationID:    r.LocationID,
					MovementType:  inventory.MovementAdjustment,
					MovementKey:   compMovKey,
					Quantity:      r.Quantity,
					ReferenceType: "order_cancel",
					ReferenceID:   o.OrderID,
					Reason:        cancelReason,
					CreatedAt:     s.clock().UTC(),
				}
				if err := tx.AppendMovement(ctx, mov); err != nil {
					return err
				}
				bal, err := tx.GetBalanceForUpdate(ctx, o.WorkspaceID, r.SkuID, r.LocationID)
				if err != nil {
					return err
				}
				bal.OnHand += r.Quantity
				if err := tx.UpdateBalance(ctx, bal); err != nil {
					return err
				}
			}
			if r.Status == inventory.ResConsumed {
				if err := tx.UpdateReservationStatus(ctx, o.WorkspaceID, r.ReservationID, inventory.ResReleased); err != nil {
					return err
				}
			}
		}
		return nil
	})
}

// IngestOrder handles order creation and ingestion from external platforms or native channels.
// Enforces:
//  1. Idempotency on (platform, external_id, connected_account) and import_fingerprint, plus forward lifecycle progression on updates (F13)
//  2. Historical order stock protection (I04 / Acceptance Target 2)
//  3. Safe transactional ordering (Billing R06): parent order row is persisted initially in StateCreated,
//     stock reservation/fulfillment executes before advancing persisted state to confirmed/fulfilled,
//     and retries idempotently recover stock and finance effects on crash/restart (F12, R06).
func (s *Service) IngestOrder(ctx context.Context, o *Order, defaultLocationID string) (*Order, bool, error) {
	if o.WorkspaceID == "" {
		return nil, false, ErrMissingTenant
	}
	if o.Amount.IsNegative() || o.Amount.IsZero() {
		return nil, false, ErrInvalidAmount
	}

	lockKey := o.ExternalOrderID
	if lockKey == "" {
		lockKey = o.ImportFingerprint
	}
	if lockKey == "" {
		lockKey = o.OrderID
	}
	unlock := s.lockEntity("ingest_order", o.WorkspaceID, lockKey)
	defer unlock()

	// 1. Idempotency / Lifecycle Progression Check: Fingerprint
	if o.ImportFingerprint != "" {
		existing, err := s.store.FindOrderByImportFingerprint(ctx, o.WorkspaceID, o.ImportFingerprint)
		if err != nil {
			return nil, false, err
		}
		if existing != nil {
			return s.reconcileExistingOrderOnIngest(ctx, existing, o, defaultLocationID)
		}
	}

	// Idempotency / Lifecycle Progression Check: External Order Identity
	if o.SourcePlatform != "" && o.ExternalOrderID != "" {
		existing, err := s.store.FindOrderByExternalID(ctx, o.WorkspaceID, o.SourcePlatform, o.ExternalOrderID, o.ConnectedAccountID)
		if err != nil {
			return nil, false, err
		}
		if existing != nil {
			return s.reconcileExistingOrderOnIngest(ctx, existing, o, defaultLocationID)
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

	targetState := o.LifecycleState
	if strings.TrimSpace(defaultLocationID) != "" {
		if o.Metadata == nil {
			o.Metadata = make(map[string]any)
		}
		o.Metadata["default_location_id"] = strings.TrimSpace(defaultLocationID)
	}

	// 2. Inventory evaluation: check if items should deduct stock
	reservationItems, err := s.buildReservationItems(ctx, o, defaultLocationID)
	if err != nil {
		return nil, false, err
	}

	// 3. Persist Parent Order FIRST in StateCreated so inventory_reservations FK to orders(id) is satisfied
	// without prematurely marking the order confirmed/fulfilled/completed before stock effects run (Billing R06).
	o.LifecycleState = StateCreated
	if err := s.store.CreateOrder(ctx, o); err != nil {
		return nil, false, err
	}

	// 4. Reserve/fulfill stock after parent order exists; roll back order creation only if stock step fails
	if len(reservationItems) > 0 && s.inventory != nil {
		if targetState == StateCreated {
			const holdTTL = 30 * time.Minute
			_, err := s.inventory.ReserveStock(ctx, o.WorkspaceID, o.OrderID, reservationItems, holdTTL)
			if err != nil {
				_ = s.store.DeleteOrder(ctx, o.WorkspaceID, o.OrderID)
				return nil, false, fmt.Errorf("reserve stock: %w", err)
			}
		} else if targetState == StateConfirmed || targetState == StateFulfilled || targetState == StateCompleted ||
			targetState == StatePartiallyRefunded || targetState == StateRefunded || targetState == StateReturned {
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

	// 5. Advance persisted order status only AFTER required stock effects have succeeded (Billing R06).
	if targetState == StateConfirmed {
		if err := s.store.UpdateOrderStatus(ctx, o.WorkspaceID, o.OrderID, StateConfirmed, nil); err != nil {
			return nil, false, err
		}
		o.LifecycleState = StateConfirmed
		o.UpdatedAt = s.clock().UTC()
	} else if targetState == StateFulfilled || targetState == StateCompleted {
		if err := s.store.UpdateOrderStatus(ctx, o.WorkspaceID, o.OrderID, StateFulfilled, nil); err != nil {
			return nil, false, err
		}
		o.LifecycleState = StateFulfilled
		o.UpdatedAt = s.clock().UTC()
	} else if targetState != StateCreated {
		if err := s.store.UpdateOrderStatus(ctx, o.WorkspaceID, o.OrderID, targetState, nil); err != nil {
			return nil, false, err
		}
		o.LifecycleState = targetState
		o.UpdatedAt = s.clock().UTC()
	}

	// 6. If order was requested in StateCompleted, transition from StateFulfilled -> StateCompleted and post to finance ledger.
	// If finance fails, CompleteOrder rolls back status to StateFulfilled (NOT deleting the order!), preserving stock & replay identity.
	if targetState == StateCompleted {
		completedOrder, err := s.CompleteOrder(ctx, o.WorkspaceID, o.OrderID)
		if err != nil {
			return nil, false, err
		}
		o = completedOrder
	}

	s.syncAffiliateOrder(ctx, o)

	s.emitEvent(ctx, "commerce.order.created", "order", o.OrderID, o.WorkspaceID, map[string]any{
		"order_id":        o.OrderID,
		"lifecycle_state": o.LifecycleState,
		"amount":          o.Amount.Fixed6String(),
		"currency":        o.Currency,
		"item_count":      len(o.Items),
	})

	return o, true, nil
}

func (s *Service) reconcileExistingOrderOnIngest(ctx context.Context, existing *Order, incoming *Order, defaultLocationID string) (*Order, bool, error) {
	// Stale observation protection: ignore webhooks older than the already-applied source_updated_at
	if existing.SourceUpdatedAt != nil && incoming.SourceUpdatedAt != nil && incoming.SourceUpdatedAt.Before(*existing.SourceUpdatedAt) {
		s.emitEvent(ctx, "commerce.order.out_of_order_ignored", "order", existing.OrderID, existing.WorkspaceID, map[string]any{
			"order_id":            existing.OrderID,
			"existing_state":      existing.LifecycleState,
			"incoming_state":      incoming.LifecycleState,
			"existing_updated_at": existing.SourceUpdatedAt,
			"incoming_updated_at": incoming.SourceUpdatedAt,
		})
		return existing, false, nil
	}

	targetState := incoming.LifecycleState
	if targetState == "" || targetState == existing.LifecycleState ||
		(isRecognizedOrderState(existing.LifecycleState) && targetState == StateCompleted) {
		// Billing R06: Even if the persisted state already matches targetState, ensure stock and finance
		// effects actually completed in case a prior crash occurred after status persistence.
		if err := s.ensureOrderStockEffects(ctx, existing, existing.LifecycleState, defaultLocationID); err != nil {
			return nil, false, err
		}
		if existing.LifecycleState == StateCompleted && orderEconomicVersion(existing) == 1 {
			if err := s.recordOrderPosting(ctx, existing); err != nil {
				return nil, false, fmt.Errorf("record completed order finance posting: %w", err)
			}
		}
		if _, err := s.applyOrderEconomicRevision(ctx, existing, incoming); err != nil {
			return nil, false, err
		}
		if isRecognizedOrderState(existing.LifecycleState) {
			s.syncAffiliateOrder(ctx, existing)
		}
		return existing, false, nil
	}

	if targetState == StateCancelled {
		if CanTransitionOrder(existing.LifecycleState, StateCancelled) {
			cancelled, err := s.CancelOrder(ctx, existing.WorkspaceID, existing.OrderID, "platform_webhook_cancelled")
			return cancelled, false, err
		}
		s.emitEvent(ctx, "commerce.order.out_of_order_ignored", "order", existing.OrderID, existing.WorkspaceID, map[string]any{
			"order_id":       existing.OrderID,
			"existing_state": existing.LifecycleState,
			"incoming_state": targetState,
		})
		return existing, false, nil
	}

	curRank := orderForwardRank(existing.LifecycleState)
	targetRank := orderForwardRank(targetState)
	if curRank == 0 || targetRank == 0 || targetRank <= curRank {
		s.emitEvent(ctx, "commerce.order.out_of_order_ignored", "order", existing.OrderID, existing.WorkspaceID, map[string]any{
			"order_id":       existing.OrderID,
			"existing_state": existing.LifecycleState,
			"incoming_state": targetState,
		})
		return existing, false, nil
	}

	// Merge any newer economic revision or source_updated_at before advancing forward.
	if _, err := s.applyOrderEconomicRevision(ctx, existing, incoming); err != nil {
		return nil, false, err
	}

	// Billing R06: Ensure stock effects for the existing state are reconciled before stepping forward.
	if err := s.ensureOrderStockEffects(ctx, existing, existing.LifecycleState, defaultLocationID); err != nil {
		return nil, false, err
	}

	cur := existing
	var err error
	if cur.LifecycleState == StateCreated && targetRank >= orderForwardRank(StateConfirmed) {
		cur, err = s.HandlePaymentConfirmation(ctx, cur.WorkspaceID, cur.OrderID, defaultLocationID)
		if err != nil {
			return nil, false, err
		}
	}
	if cur.LifecycleState == StateConfirmed && targetRank >= orderForwardRank(StateFulfilled) {
		cur, err = s.FulfillOrder(ctx, cur.WorkspaceID, cur.OrderID)
		if err != nil {
			return nil, false, err
		}
	}
	if cur.LifecycleState == StateFulfilled && targetRank >= orderForwardRank(StateCompleted) {
		cur, err = s.CompleteOrder(ctx, cur.WorkspaceID, cur.OrderID)
		if err != nil {
			return nil, false, err
		}
	}
	return cur, false, nil
}

// ConfirmOrder transitions an order from created to confirmed and fulfills any held stock reservation.
func (s *Service) ConfirmOrder(ctx context.Context, workspaceID, orderID string) (*Order, error) {
	unlock := s.lockEntity("order", workspaceID, orderID)
	defer unlock()

	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateConfirmed {
		if err := s.ensureOrderStockEffects(ctx, o, StateConfirmed, ""); err != nil {
			return nil, err
		}
		return o, nil // Idempotent
	}
	if !CanTransitionOrder(o.LifecycleState, StateConfirmed) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateConfirmed)
	}

	// Fulfill reservation in inventory ledger (re-reserving if an earlier crash skipped reservation)
	if err := s.ensureOrderStockEffects(ctx, o, StateConfirmed, ""); err != nil {
		return nil, err
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
	unlock := s.lockEntity("order", workspaceID, orderID)
	defer unlock()

	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateFulfilled {
		if err := s.ensureOrderStockEffects(ctx, o, StateFulfilled, ""); err != nil {
			return nil, err
		}
		return o, nil // Idempotent
	}
	if !CanTransitionOrder(o.LifecycleState, StateFulfilled) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateFulfilled)
	}

	if err := s.ensureOrderStockEffects(ctx, o, StateFulfilled, ""); err != nil {
		return nil, err
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
	unlock := s.lockEntity("order", workspaceID, orderID)
	defer unlock()

	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateCompleted {
		if err := s.ensureOrderStockEffects(ctx, o, StateCompleted, ""); err != nil {
			return nil, err
		}
		if err := s.recordOrderPosting(ctx, o); err != nil {
			return nil, fmt.Errorf("record completed order finance posting: %w", err)
		}
		s.syncAffiliateOrder(ctx, o)
		return o, nil
	}
	if !CanTransitionOrder(o.LifecycleState, StateCompleted) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateCompleted)
	}

	if err := s.ensureOrderStockEffects(ctx, o, StateCompleted, ""); err != nil {
		return nil, err
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

	s.syncAffiliateOrder(ctx, o)

	s.emitEvent(ctx, "commerce.order.completed", "order", orderID, workspaceID, map[string]any{
		"order_id": orderID,
	})

	return o, nil
}

// CancelOrder cancels an order, releases any held stock reservations, and idempotently compensates
// any reservation that was consumed at confirmation prior to physical fulfillment (Billing R07).
func (s *Service) CancelOrder(ctx context.Context, workspaceID, orderID, reason string) (*Order, error) {
	unlock := s.lockEntity("order", workspaceID, orderID)
	defer unlock()

	o, err := s.store.GetOrder(ctx, workspaceID, orderID)
	if err != nil {
		return nil, err
	}
	if o.LifecycleState == StateCancelled {
		if err := s.releaseOrCompensateOrderStockOnCancel(ctx, o, reason); err != nil {
			return nil, err
		}
		s.syncAffiliateOrder(ctx, o)
		return o, nil // Idempotent
	}
	if !CanTransitionOrder(o.LifecycleState, StateCancelled) {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidOrderTransition, o.LifecycleState, StateCancelled)
	}

	if err := s.releaseOrCompensateOrderStockOnCancel(ctx, o, reason); err != nil {
		return nil, err
	}

	if err := s.store.UpdateOrderStatus(ctx, workspaceID, orderID, StateCancelled, nil); err != nil {
		return nil, err
	}
	o.LifecycleState = StateCancelled
	o.UpdatedAt = s.clock().UTC()

	s.syncAffiliateOrder(ctx, o)

	s.emitEvent(ctx, "commerce.order.cancelled", "order", orderID, workspaceID, map[string]any{
		"order_id": orderID,
		"reason":   reason,
	})

	return o, nil
}

// RequestRefund creates a financial refund request.
// Verifies currency match, external refund deduplication, and that cumulative active refunds <= order total atomically.
func (s *Service) RequestRefund(ctx context.Context, r *Refund) (*Refund, *Order, error) {
	if r.WorkspaceID == "" {
		return nil, nil, ErrMissingTenant
	}
	if r.Amount.IsNegative() || r.Amount.IsZero() {
		return nil, nil, ErrInvalidAmount
	}

	if r.RefundID == "" {
		r.RefundID = newUUID()
	}
	if r.LifecycleState == "" {
		r.LifecycleState = RefundRequested
	}

	if err := s.store.CreateRefund(ctx, r); err != nil {
		return nil, nil, err
	}

	o, err := s.store.GetOrder(ctx, r.WorkspaceID, r.OrderID)
	if err != nil {
		return nil, nil, err
	}

	s.emitEvent(ctx, "commerce.refund.requested", "refund", r.RefundID, r.WorkspaceID, map[string]any{
		"refund_id": r.RefundID,
		"order_id":  r.OrderID,
		"amount":    r.Amount.Fixed6String(),
	})

	return r, o, nil
}

// RequestCumulativeRefund atomically computes the positive delta between a cumulative refund total (e.g. Stripe charge.refunded)
// and already-booked refunds on the order under the store/DB lock.
func (s *Service) RequestCumulativeRefund(ctx context.Context, r *Refund, cumulativeAmount tenantdb.ExactDecimal) (*Refund, *Order, bool, error) {
	if r.WorkspaceID == "" {
		return nil, nil, false, ErrMissingTenant
	}
	if cumulativeAmount.IsNegative() || cumulativeAmount.IsZero() {
		return nil, nil, false, ErrInvalidAmount
	}
	if r.RefundID == "" {
		r.RefundID = newUUID()
	}
	if r.LifecycleState == "" {
		r.LifecycleState = RefundRequested
	}

	created, err := s.store.CreateCumulativeRefund(ctx, r, cumulativeAmount)
	if err != nil {
		return nil, nil, false, err
	}

	o, err := s.store.GetOrder(ctx, r.WorkspaceID, r.OrderID)
	if err != nil {
		return nil, nil, false, err
	}

	if created {
		s.emitEvent(ctx, "commerce.refund.requested", "refund", r.RefundID, r.WorkspaceID, map[string]any{
			"refund_id": r.RefundID,
			"order_id":  r.OrderID,
			"amount":    r.Amount.Fixed6String(),
		})
	}
	return r, o, created, nil
}

// ApproveRefund approves and completes a refund atomically.
// Enforces Acceptance Target 3:
// - Partial refund transitions order to partially_refunded.
// - Followed by full refund transitions order to refunded.
// - Over-refunding (including concurrent approvals) is strictly rejected.
func (s *Service) ApproveRefund(ctx context.Context, workspaceID, refundID string) (*Refund, *Order, error) {
	unlock := s.lockEntity("refund", workspaceID, refundID)
	defer unlock()

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
	s.syncAffiliateOrder(ctx, o)

	return r, o, nil
}

// validateOrderInventoryEligibleForReturn ensures that when inventory is wired and a SKU balance is initialized,
// a physical return can only be created or received if the order actually deducted stock via a sale movement
// (without pre-fulfillment cancellation compensation) and cumulative returned quantity does not exceed the
// canonical fulfilled sale deduction, preventing unfulfilled or pre-baseline historical orders from fabricating
// inventory stock (Billing N02).
func (s *Service) validateOrderInventoryEligibleForReturn(ctx context.Context, o *Order, returnID string, items []ReturnItem, locationID string) error {
	if o == nil {
		return ErrOrderNotFound
	}
	if !isOrderEligibleForPhysicalReturn(o) {
		return fmt.Errorf("%w: cannot process physical return for order in state %s", ErrInvalidReturnTransition, o.LifecycleState)
	}
	invStore := s.resolveInventoryStore()
	if invStore == nil {
		return nil
	}

	cumRetQty := make(map[string]int32)
	alreadyIncluded := false
	if existingReturns, err := s.store.ListReturnsByOrder(ctx, o.WorkspaceID, o.OrderID); err == nil {
		for _, ex := range existingReturns {
			if ex == nil || ex.DeletedAt != nil || ex.LifecycleState == ReturnRejected {
				continue
			}
			if returnID != "" && ex.ReturnID == returnID {
				alreadyIncluded = true
			}
			for _, it := range ex.Items {
				if it.Sku != "" && it.Quantity > 0 {
					cumRetQty[it.Sku] += it.Quantity
				}
			}
		}
	}
	if !alreadyIncluded {
		for _, it := range items {
			if it.Sku != "" && it.Quantity > 0 {
				cumRetQty[it.Sku] += it.Quantity
			}
		}
	}

	locID := s.resolveOrderLocationID(ctx, o, locationID)
	for _, item := range items {
		if item.Sku == "" || item.Quantity <= 0 {
			continue
		}
		if _, err := invStore.GetBalance(ctx, o.WorkspaceID, item.Sku, locID); err != nil {
			if errors.Is(err, inventory.ErrSkuNotInitialized) {
				continue
			}
			return err
		}
		compMovKey := fmt.Sprintf("mov_cancel_comp_%s_%s_%s", o.OrderID, item.Sku, locID)
		if compMov, err := invStore.FindMovementByKey(ctx, o.WorkspaceID, compMovKey); err != nil {
			return err
		} else if compMov != nil {
			return fmt.Errorf("%w: order %s was cancelled before fulfillment for sku %s", ErrInvalidReturnTransition, o.OrderID, item.Sku)
		}
		saleMovKey := fmt.Sprintf("mov_sale_%s_%s_%s", o.OrderID, item.Sku, locID)
		saleMov, err := invStore.FindMovementByKey(ctx, o.WorkspaceID, saleMovKey)
		if err != nil {
			return err
		}
		if saleMov == nil || saleMov.Quantity >= 0 {
			return fmt.Errorf("%w: order %s has no recorded sale stock deduction for sku %s", ErrInvalidReturnTransition, o.OrderID, item.Sku)
		}
		fulfilledQty := -saleMov.Quantity
		if cumRetQty[item.Sku] > fulfilledQty {
			return fmt.Errorf("%w: sku %s cumulative returned %d exceeds fulfilled sale quantity %d", ErrReturnExceedsOrderQuantity, item.Sku, cumRetQty[item.Sku], fulfilledQty)
		}
	}
	return nil
}

// CreateReturn creates a physical return request.
// Enforces inventory contract §3: cumulative return quantity <= sold quantity across all non-rejected returns atomically.
func (s *Service) CreateReturn(ctx context.Context, ret *Return) (*Return, error) {
	if ret.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if len(ret.Items) == 0 {
		return nil, fmt.Errorf("%w: return must contain at least one item", ErrInvalidInput)
	}

	o, err := s.store.GetOrder(ctx, ret.WorkspaceID, ret.OrderID)
	if err != nil {
		return nil, err
	}
	if err := s.validateOrderInventoryEligibleForReturn(ctx, o, ret.ReturnID, ret.Items, ""); err != nil {
		return nil, err
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
	unlock := s.lockEntity("return", workspaceID, returnID)
	defer unlock()

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

	o, err := s.store.GetOrder(ctx, workspaceID, ret.OrderID)
	if err != nil {
		return nil, err
	}
	if err := s.validateOrderInventoryEligibleForReturn(ctx, o, ret.ReturnID, ret.Items, restockLocationID); err != nil {
		return nil, err
	}

	// Physical restock (aggregate quantities per SKU so duplicate SKU lines in a return restock accurately)
	resolvedRestockLoc := restockLocationID
	if resolvedRestockLoc == "" && s.inventory != nil {
		resolvedRestockLoc = s.resolveOrderLocationID(ctx, o, "")
	}
	if s.inventory != nil && resolvedRestockLoc != "" {
		qtyBySku := make(map[string]int32)
		reasonBySku := make(map[string]string)
		var skuOrder []string
		for _, item := range ret.Items {
			if item.Quantity > 0 && item.Sku != "" {
				if _, seen := qtyBySku[item.Sku]; !seen {
					skuOrder = append(skuOrder, item.Sku)
					reasonBySku[item.Sku] = item.Reason
				}
				qtyBySku[item.Sku] += item.Quantity
			}
		}
		for _, sku := range skuOrder {
			_, err := s.inventory.RecordPhysicalReturn(ctx, workspaceID, ret.OrderID, returnID, sku, resolvedRestockLoc, qtyBySku[sku], reasonBySku[sku])
			if err != nil {
				return nil, fmt.Errorf("restock returned item %s: %w", sku, err)
			}
		}
	}

	if err := s.store.UpdateReturnStatus(ctx, workspaceID, returnID, ReturnClosed); err != nil {
		return nil, err
	}
	ret.LifecycleState = ReturnClosed
	ret.UpdatedAt = s.clock().UTC()

	// Update order state to returned if not already refunded
	if o.LifecycleState != StateRefunded && o.LifecycleState != StatePartiallyRefunded {
		_ = s.store.UpdateOrderStatus(ctx, workspaceID, ret.OrderID, StateReturned, nil)
		o.LifecycleState = StateReturned
		s.syncAffiliateOrder(ctx, o)
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
	oldEconVer := orderEconomicVersion(o)
	nextEconVer := oldEconVer + 1
	var parsedVer int
	if _, err := fmt.Sscanf(strings.TrimPrefix(strings.ToLower(strings.TrimSpace(version)), "v"), "%d", &parsedVer); err == nil && parsedVer > nextEconVer {
		nextEconVer = parsedVer
	}
	if o.Metadata == nil {
		o.Metadata = make(map[string]any)
	}
	o.Metadata["economic_version"] = nextEconVer
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
			o.Metadata["economic_version"] = oldEconVer
			_ = s.store.UpdateOrder(ctx, o)
		}

		// Platform + payment fee correction
		oldCombinedFee, _ := oldFees.PlatformFee.Add(oldFees.PaymentFee)
		newCombinedFee, _ := newFees.PlatformFee.Add(newFees.PaymentFee)
		if newCombinedFee.Cmp(oldCombinedFee) != 0 {
			negFee, _ := tenantdb.ZeroDecimal().Sub(newCombinedFee)
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

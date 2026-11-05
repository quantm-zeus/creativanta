package finance

import (
	"context"
	"crypto/sha512"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
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

type OrderPostingInput struct {
	WorkspaceID          string
	OrderID              string
	OrderVersion         string
	LifecycleState       string // created, confirmed, fulfilled, completed, cancelled, refunded
	GrossAmount          tenantdb.ExactDecimal
	FeeAmount            tenantdb.ExactDecimal
	ShippingAmount       tenantdb.ExactDecimal
	COGSAmount           *tenantdb.ExactDecimal // nil if missing/unknown
	CommissionAmount     tenantdb.ExactDecimal
	Currency             string
	SourceClass          string
	Confidence           string
	ExchangeRateSnapshot ExchangeRateSnapshot
	EffectiveAt          time.Time
}

type Service struct {
	mu        sync.RWMutex
	store     Store
	eventSink EventSink
	clock     func() time.Time

	// Internal tracker for orders with missing COGS
	missingCOGSOrders map[string]bool
	pendingOrders     map[string]OrderPostingInput
	attributionEngine *AttributionEngine
}

func NewService(store Store, eventSink EventSink, clock func() time.Time) *Service {
	if clock == nil {
		clock = func() time.Time { return time.Now().UTC() }
	}
	return &Service{
		store:             store,
		eventSink:         eventSink,
		clock:             clock,
		missingCOGSOrders: make(map[string]bool),
		pendingOrders:     make(map[string]OrderPostingInput),
		attributionEngine: NewAttributionEngine(),
	}
}

func (s *Service) AttributionEngine() *AttributionEngine {
	if s.attributionEngine == nil {
		s.attributionEngine = NewAttributionEngine()
	}
	return s.attributionEngine
}

func (s *Service) Store() Store {
	return s.store
}

// RecordOrderPosting recognizes completed orders into financial_postings or tracks pending orders.
// Per financial computation contract §1:
// - Revenue is recognized once when an order becomes completed; recognized_at is source completion timestamp.
// - Created/confirmed/fulfilled orders are shown as pending revenue, excluded from recognized profit.
// - Missing COGS is a gap, never verified zero.
func (s *Service) RecordOrderPosting(ctx context.Context, input OrderPostingInput) error {
	if input.WorkspaceID == "" {
		return ErrMissingTenant
	}
	if input.OrderVersion == "" {
		input.OrderVersion = "v1"
	}
	if input.EffectiveAt.IsZero() {
		input.EffectiveAt = s.clock()
	}

	// If order is not completed (e.g. created, confirmed, fulfilled), keep in pending pool
	if input.LifecycleState != "completed" {
		s.mu.Lock()
		s.pendingOrders[input.OrderID] = input
		s.mu.Unlock()
		return nil
	}

	// Order is completed: remove from pending pool if present
	s.mu.Lock()
	delete(s.pendingOrders, input.OrderID)
	s.mu.Unlock()

	// FX Conversion to base currency
	baseRevenue, err := ComputeBaseAmount(input.GrossAmount, input.ExchangeRateSnapshot)
	if err != nil {
		return fmt.Errorf("fx conversion for revenue: %w", err)
	}

	// 1. Post Revenue (positive)
	revPosting := &FinancialPosting{
		WorkspaceID:          input.WorkspaceID,
		OriginType:           "order",
		OriginID:             input.OrderID,
		OriginVersion:        input.OrderVersion,
		Component:            ComponentRevenue,
		Amount:               baseRevenue,
		Currency:             input.Currency,
		SourceClass:          input.SourceClass,
		Confidence:           input.Confidence,
		ExchangeRateSnapshot: input.ExchangeRateSnapshot,
		EffectiveAt:          input.EffectiveAt,
		CreatedAt:            s.clock(),
	}
	if err := s.store.CreatePosting(ctx, revPosting); err != nil && err != ErrDuplicatePosting {
		return err
	}

	// Seed canonical order in attribution engine for revenue attribution and deduplication
	s.AttributionEngine().SeedCanonicalOrder(CanonicalOrderRecord{
		OrderID:           input.OrderID,
		WorkspaceID:       input.WorkspaceID,
		GrossRevenue:      baseRevenue,
		RefundDeduction:   tenantdb.ZeroDecimal(),
		NetRevenue:        baseRevenue,
		Currency:          input.Currency,
		SourceClass:       input.SourceClass,
		Confidence:        input.Confidence,
		LifecycleState:    input.LifecycleState,
		IsRecognizedOrder: true,
	})

	// 2. Post Platform Fee (negative) if present
	if !input.FeeAmount.IsZero() {
		baseFee, err := ComputeBaseAmount(input.FeeAmount, input.ExchangeRateSnapshot)
		if err != nil {
			return fmt.Errorf("fx conversion for fee: %w", err)
		}
		negFee, _ := tenantdb.ZeroDecimal().Sub(baseFee)
		feePosting := &FinancialPosting{
			WorkspaceID:          input.WorkspaceID,
			OriginType:           "order",
			OriginID:             input.OrderID,
			OriginVersion:        input.OrderVersion,
			Component:            ComponentPlatformFee,
			Amount:               negFee,
			Currency:             input.Currency,
			SourceClass:          input.SourceClass,
			Confidence:           input.Confidence,
			ExchangeRateSnapshot: input.ExchangeRateSnapshot,
			EffectiveAt:          input.EffectiveAt,
			CreatedAt:            s.clock(),
		}
		if err := s.store.CreatePosting(ctx, feePosting); err != nil && err != ErrDuplicatePosting {
			return err
		}
	}

	// 3. Post Shipping (negative) if present
	if !input.ShippingAmount.IsZero() {
		baseShip, err := ComputeBaseAmount(input.ShippingAmount, input.ExchangeRateSnapshot)
		if err != nil {
			return fmt.Errorf("fx conversion for shipping: %w", err)
		}
		negShip, _ := tenantdb.ZeroDecimal().Sub(baseShip)
		shipPosting := &FinancialPosting{
			WorkspaceID:          input.WorkspaceID,
			OriginType:           "order",
			OriginID:             input.OrderID,
			OriginVersion:        input.OrderVersion,
			Component:            ComponentShipping,
			Amount:               negShip,
			Currency:             input.Currency,
			SourceClass:          input.SourceClass,
			Confidence:           input.Confidence,
			ExchangeRateSnapshot: input.ExchangeRateSnapshot,
			EffectiveAt:          input.EffectiveAt,
			CreatedAt:            s.clock(),
		}
		if err := s.store.CreatePosting(ctx, shipPosting); err != nil && err != ErrDuplicatePosting {
			return err
		}
	}

	// 4. Post COGS (negative) if present, or flag missing
	if input.COGSAmount == nil {
		s.mu.Lock()
		s.missingCOGSOrders[input.OrderID] = true
		s.mu.Unlock()
	} else {
		s.mu.Lock()
		delete(s.missingCOGSOrders, input.OrderID)
		s.mu.Unlock()
		if !input.COGSAmount.IsZero() {
			baseCOGS, err := ComputeBaseAmount(*input.COGSAmount, input.ExchangeRateSnapshot)
			if err != nil {
				return fmt.Errorf("fx conversion for cogs: %w", err)
			}
			negCOGS, _ := tenantdb.ZeroDecimal().Sub(baseCOGS)
			cogsPosting := &FinancialPosting{
				WorkspaceID:          input.WorkspaceID,
				OriginType:           "order",
				OriginID:             input.OrderID,
				OriginVersion:        input.OrderVersion,
				Component:            ComponentCOGS,
				Amount:               negCOGS,
				Currency:             input.Currency,
				SourceClass:          input.SourceClass,
				Confidence:           input.Confidence,
				ExchangeRateSnapshot: input.ExchangeRateSnapshot,
				EffectiveAt:          input.EffectiveAt,
				CreatedAt:            s.clock(),
			}
			if err := s.store.CreatePosting(ctx, cogsPosting); err != nil && err != ErrDuplicatePosting {
				return err
			}
		}
	}

	// 5. Post Commission (negative) if present
	if !input.CommissionAmount.IsZero() {
		baseComm, err := ComputeBaseAmount(input.CommissionAmount, input.ExchangeRateSnapshot)
		if err != nil {
			return fmt.Errorf("fx conversion for commission: %w", err)
		}
		negComm, _ := tenantdb.ZeroDecimal().Sub(baseComm)
		commPosting := &FinancialPosting{
			WorkspaceID:          input.WorkspaceID,
			OriginType:           "order",
			OriginID:             input.OrderID,
			OriginVersion:        input.OrderVersion,
			Component:            ComponentCommission,
			Amount:               negComm,
			Currency:             input.Currency,
			SourceClass:          input.SourceClass,
			Confidence:           input.Confidence,
			ExchangeRateSnapshot: input.ExchangeRateSnapshot,
			EffectiveAt:          input.EffectiveAt,
			CreatedAt:            s.clock(),
		}
		if err := s.store.CreatePosting(ctx, commPosting); err != nil && err != ErrDuplicatePosting {
			return err
		}
	}

	return nil
}

// RecordOrderCorrection reverses a prior component posting and appends a corrected one (F06).
func (s *Service) RecordOrderCorrection(
	ctx context.Context,
	workspaceID, orderID, component string,
	newAmount tenantdb.ExactDecimal,
	newVersion string,
	sourceClass, confidence string,
	fx ExchangeRateSnapshot,
) error {
	now := s.clock()
	effectiveAt := now
	currency := fx.QuoteCurrency
	if currency == "" {
		currency = fx.BaseCurrency
	}

	existing, err := s.store.FindPostingByOrigin(ctx, workspaceID, "order", orderID, component)
	if err != nil && !errors.Is(err, ErrPostingNotFound) {
		return err
	}

	if existing != nil {
		effectiveAt = existing.EffectiveAt
		currency = existing.Currency
		// 1. Create reversal posting
		reversalAmount, _ := tenantdb.ZeroDecimal().Sub(existing.Amount)
		reversal := &FinancialPosting{
			WorkspaceID:          workspaceID,
			OriginType:           "order",
			OriginID:             orderID,
			OriginVersion:        existing.OriginVersion + "-reversal",
			Component:            component,
			Amount:               reversalAmount,
			Currency:             existing.Currency,
			SourceClass:          sourceClass,
			Confidence:           confidence,
			ExchangeRateSnapshot: fx,
			ReversalOf:           &existing.PostingID,
			EffectiveAt:          existing.EffectiveAt,
			CreatedAt:            now,
		}
		if err := s.store.CreatePosting(ctx, reversal); err != nil && !errors.Is(err, ErrDuplicatePosting) {
			return fmt.Errorf("create reversal: %w", err)
		}
	}

	// 2. Append new corrected posting
	corrected := &FinancialPosting{
		WorkspaceID:          workspaceID,
		OriginType:           "order",
		OriginID:             orderID,
		OriginVersion:        newVersion,
		Component:            component,
		Amount:               newAmount,
		Currency:             currency,
		SourceClass:          sourceClass,
		Confidence:           confidence,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          effectiveAt,
		CreatedAt:            now,
	}
	if err := s.store.CreatePosting(ctx, corrected); err != nil && !errors.Is(err, ErrDuplicatePosting) {
		return err
	}
	return nil
}

// RecordRefundPosting creates a negative refund posting without netting original revenue (F02).
// Enforces idempotency: duplicate refund callbacks or replays do not create duplicate refund postings (Acceptance Target 3).
func (s *Service) RecordRefundPosting(
	ctx context.Context,
	workspaceID, refundID, orderID string,
	refundAmount tenantdb.ExactDecimal,
	currency string,
	sourceClass, confidence string,
	fx ExchangeRateSnapshot,
) error {
	// Idempotency check: if refund posting already recorded, do not duplicate
	existing, err := s.store.FindPostingByOrigin(ctx, workspaceID, "refund", refundID, ComponentRefund)
	if err == nil && existing != nil {
		return nil // Idempotent no-op
	}

	baseRefund, err := ComputeBaseAmount(refundAmount, fx)
	if err != nil {
		return err
	}
	negRefund, _ := tenantdb.ZeroDecimal().Sub(baseRefund)

	posting := &FinancialPosting{
		WorkspaceID:          workspaceID,
		OriginType:           "refund",
		OriginID:             refundID,
		OriginVersion:        "v1",
		Component:            ComponentRefund,
		Amount:               negRefund,
		Currency:             currency,
		SourceClass:          sourceClass,
		Confidence:           confidence,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          s.clock(),
		CreatedAt:            s.clock(),
	}
	if s.attributionEngine != nil {
		s.attributionEngine.RecordRefundDeduction(orderID, baseRefund)
	}
	if err := s.store.CreatePosting(ctx, posting); err != nil && !errors.Is(err, ErrDuplicatePosting) {
		return err
	}
	return nil
}

// CreateCostItem creates a cost item and posts to financial ledger if recorded/reconciled.
func (s *Service) CreateCostItem(ctx context.Context, item *CostItem) (*CostItem, error) {
	if item.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if err := s.store.CreateCostItem(ctx, item); err != nil {
		return nil, err
	}

	// Map cost_type to financial component
	comp := mapCostTypeToComponent(item.CostType)

	// Costs are negative financial postings
	negAmount, _ := tenantdb.ZeroDecimal().Sub(item.Amount)
	fx := ExchangeRateSnapshot{
		BaseCurrency:  item.Currency,
		QuoteCurrency: item.Currency,
		RateToBase:    "1",
		SourceClass:   item.SourceClass,
	}

	posting := &FinancialPosting{
		WorkspaceID:          item.WorkspaceID,
		OriginType:           "cost_item",
		OriginID:             item.CostItemID,
		OriginVersion:        "v1",
		Component:            comp,
		Amount:               negAmount,
		Currency:             item.Currency,
		SourceClass:          item.SourceClass,
		Confidence:           ConfidenceMedium,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          s.clock(),
		CreatedAt:            s.clock(),
	}
	_ = s.store.CreatePosting(ctx, posting)

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"cost_item_id": item.CostItemID,
			"workspace_id": item.WorkspaceID,
			"cost_type":    item.CostType,
			"amount":       item.Amount.String(),
			"currency":     item.Currency,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "cost.recorded",
			AggregateType: "cost_item",
			AggregateID:   item.CostItemID,
			WorkspaceID:   item.WorkspaceID,
			PayloadJSON:   payload,
			CreatedAt:     s.clock(),
		})
	}

	return item, nil
}

func (s *Service) ListCostItems(ctx context.Context, workspaceID string, filter CostItemFilter, limit, offset int) ([]CostItem, int64, error) {
	return s.store.ListCostItems(ctx, workspaceID, filter, limit, offset)
}

func (s *Service) UpdateCostItem(ctx context.Context, item *CostItem) (*CostItem, error) {
	if err := s.store.UpdateCostItem(ctx, item); err != nil {
		return nil, err
	}
	return item, nil
}

func (s *Service) DeleteCostItem(ctx context.Context, workspaceID, costItemID string) error {
	return s.store.DeleteCostItem(ctx, workspaceID, costItemID)
}

// ImportSettlement imports a platform settlement and reconciles fees without double charging (F03).
func (s *Service) ImportSettlement(ctx context.Context, sment *Settlement, lines []SettlementLine) (*Settlement, error) {
	if sment.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}

	// Idempotency check
	if sment.ExternalSettlementID != "" && sment.ConnectedAccountID != "" {
		existing, err := s.store.FindSettlementByExternalID(ctx, sment.WorkspaceID, sment.ConnectedAccountID, sment.ExternalSettlementID)
		if err == nil && existing != nil {
			return existing, nil
		}
	}
	if sment.ImportFingerprint != "" {
		existing, err := s.store.FindSettlementByFingerprint(ctx, sment.WorkspaceID, sment.ImportFingerprint)
		if err == nil && existing != nil {
			return existing, nil
		}
	}

	if err := s.store.CreateSettlement(ctx, sment); err != nil {
		return nil, err
	}

	for i := range lines {
		lines[i].SettlementID = sment.SettlementID
		lines[i].WorkspaceID = sment.WorkspaceID
		if err := s.store.CreateSettlementLine(ctx, &lines[i]); err != nil {
			return nil, err
		}

		// Reconcile fee if order is linked:
		// If an order fee posting exists, replace it with the settlement fee.
		// Never charge both! (F03)
		if lines[i].OrderID != "" && !lines[i].FeeAmount.IsZero() {
			existingFee, err := s.store.FindPostingByOrigin(ctx, sment.WorkspaceID, "order", lines[i].OrderID, ComponentPlatformFee)
			if err == nil && existingFee != nil {
				// Reverse the estimated order fee
				revAmount, _ := tenantdb.ZeroDecimal().Sub(existingFee.Amount)
				revPosting := &FinancialPosting{
					WorkspaceID:          sment.WorkspaceID,
					OriginType:           "order",
					OriginID:             lines[i].OrderID,
					OriginVersion:        existingFee.OriginVersion + "-superseded",
					Component:            ComponentPlatformFee,
					Amount:               revAmount,
					Currency:             existingFee.Currency,
					SourceClass:          SourceClassOfficial,
					Confidence:           ConfidenceHigh,
					ExchangeRateSnapshot: sment.ExchangeRateSnapshot,
					ReversalOf:           &existingFee.PostingID,
					EffectiveAt:          s.clock(),
					CreatedAt:            s.clock(),
				}
				_ = s.store.CreatePosting(ctx, revPosting)
			}

			// Post the official settlement fee
			negFee, _ := tenantdb.ZeroDecimal().Sub(lines[i].FeeAmount)
			settlementFeePosting := &FinancialPosting{
				WorkspaceID:          sment.WorkspaceID,
				OriginType:           "settlement_line",
				OriginID:             lines[i].LineID,
				OriginVersion:        "v1",
				Component:            ComponentPlatformFee,
				Amount:               negFee,
				Currency:             lines[i].Currency,
				SourceClass:          SourceClassOfficial,
				Confidence:           ConfidenceHigh,
				ExchangeRateSnapshot: sment.ExchangeRateSnapshot,
				EffectiveAt:          s.clock(),
				CreatedAt:            s.clock(),
			}
			_ = s.store.CreatePosting(ctx, settlementFeePosting)
		}
	}

	sment.Lines = lines

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"settlement_id": sment.SettlementID,
			"workspace_id":  sment.WorkspaceID,
			"gross_amount":  sment.GrossAmount.String(),
			"net_amount":    sment.NetAmount.String(),
			"currency":      sment.Currency,
			"line_count":    len(lines),
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "settlement.imported",
			AggregateType: "settlement",
			AggregateID:   sment.SettlementID,
			WorkspaceID:   sment.WorkspaceID,
			PayloadJSON:   payload,
			CreatedAt:     s.clock(),
		})
	}

	return sment, nil
}

// AllocateSettlementLine matches a settlement line amount to an order, enforcing line capacity (F08).
func (s *Service) AllocateSettlementLine(
	ctx context.Context,
	workspaceID, settlementID, lineID, orderID string,
	allocationAmount tenantdb.ExactDecimal,
) error {
	line, err := s.store.GetSettlementLine(ctx, workspaceID, settlementID, lineID)
	if err != nil {
		return err
	}

	newMatched, err := line.MatchedAmount.Add(allocationAmount)
	if err != nil {
		return err
	}

	// Capacity check: matched_amount cannot exceed net_amount
	if newMatched.Cmp(line.NetAmount) > 0 {
		return ErrCapacityExceeded
	}

	newState := ReconciliationPartiallyReconciled
	if newMatched.Cmp(line.NetAmount) == 0 {
		newState = ReconciliationFullyReconciled
	}

	return s.store.UpdateSettlementLineMatched(ctx, workspaceID, lineID, newMatched, newState)
}

// GetOrComputeProfitSnapshot retrieves the latest snapshot or computes a fresh one from postings.
func (s *Service) GetOrComputeProfitSnapshot(
	ctx context.Context,
	workspaceID, scopeType, scopeID, periodStart, periodEnd string,
	forceRefresh bool,
) (*ProfitSnapshot, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}

	if !forceRefresh {
		snap, err := s.store.GetLatestSnapshot(ctx, workspaceID, scopeType, scopeID, periodStart, periodEnd)
		if err == nil && snap != nil && s.clock().Sub(snap.FreshnessAt) < 15*time.Minute {
			return snap, nil
		}
	}

	// Compute fresh snapshot from active postings
	postings, err := s.store.ListPostings(ctx, workspaceID, PostingFilter{})
	if err != nil {
		return nil, err
	}

	s.mu.RLock()
	missingCOGSCount := len(s.missingCOGSOrders)
	hasMissingCOGS := missingCOGSCount > 0
	var wsPending []OrderPostingInput
	for _, p := range s.pendingOrders {
		if p.WorkspaceID == workspaceID {
			wsPending = append(wsPending, p)
		}
	}
	s.mu.RUnlock()

	summary, err := SummarizePostings(postings, hasMissingCOGS)
	if err != nil {
		return nil, err
	}

	// Calculate pending revenue from pending orders
	pendingRevenue := tenantdb.ZeroDecimal()
	for _, p := range wsPending {
		baseP, _ := ComputeBaseAmount(p.GrossAmount, p.ExchangeRateSnapshot)
		pendingRevenue, _ = pendingRevenue.Add(baseP)
	}

	// Calculate unreconciled bucket from settlements
	unreconciledAmount := tenantdb.ZeroDecimal()
	unreconciledCount := 0
	sments, _, err := s.store.ListSettlements(ctx, workspaceID, SettlementFilter{}, 1000, 0)
	if err == nil {
		for _, sm := range sments {
			for _, l := range sm.Lines {
				if l.ReconciliationState == ReconciliationImportedOnly || l.ReconciliationState == ReconciliationAwaitingEvidence {
					unreconciledCount++
					unmatched, _ := l.NetAmount.Sub(l.MatchedAmount)
					unreconciledAmount, _ = unreconciledAmount.Add(unmatched)
				}
			}
		}
	}

	currency := "VND"
	if len(postings) > 0 {
		currency = postings[0].Currency
	}

	snapshot := &ProfitSnapshot{
		SnapshotID:                     newUUID(),
		WorkspaceID:                    workspaceID,
		ScopeType:                      scopeType,
		ScopeID:                        scopeID,
		PeriodStart:                    periodStart,
		PeriodEnd:                      periodEnd,
		GrossRevenue:                   summary.GrossRevenue,
		PlatformFees:                   summary.PlatformFees,
		ShippingCosts:                  summary.ShippingCosts,
		AffiliateCommissions:           summary.Commissions,
		RefundDeductions:               summary.RefundDeductions,
		COGS:                           summary.COGS,
		AdsSpend:                       summary.AdsSpend,
		AICreditCosts:                  summary.AICreditCosts,
		SeedingCosts:                   summary.SeedingCosts,
		OtherCosts:                     summary.OtherCosts,
		NetProfit:                      summary.NetProfit,
		SourceClassMix:                 summary.SourceClassMix,
		Confidence:                     summary.Confidence,
		FreshnessAt:                    s.clock(),
		Currency:                       currency,
		CreatedAt:                      s.clock(),
		IsIncomplete:                   hasMissingCOGS,
		UnknownRequiredComponentsCount: missingCOGSCount,
		PendingRevenue:                 pendingRevenue,
		UnreconciledAmount:             unreconciledAmount,
		UnreconciledCount:              unreconciledCount,
	}

	_ = s.store.CreateSnapshot(ctx, snapshot)

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"snapshot_id":   snapshot.SnapshotID,
			"workspace_id":  snapshot.WorkspaceID,
			"gross_revenue": snapshot.GrossRevenue.String(),
			"net_profit":    snapshot.NetProfit.String(),
			"confidence":    snapshot.Confidence,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "profit.snapshot_updated",
			AggregateType: "profit_snapshot",
			AggregateID:   snapshot.SnapshotID,
			WorkspaceID:   snapshot.WorkspaceID,
			PayloadJSON:   payload,
			CreatedAt:     s.clock(),
		})
	}

	return snapshot, nil
}

func mapCostTypeToComponent(costType string) string {
	switch costType {
	case "platform_fee":
		return ComponentPlatformFee
	case "shipping":
		return ComponentShipping
	case "cogs":
		return ComponentCOGS
	case "ai_credits":
		return ComponentAICredits
	case "commission":
		return ComponentCommission
	case "ads_spend":
		return ComponentAdsSpend
	case "seeding":
		return ComponentSeeding
	case "refund":
		return ComponentRefund
	default:
		return ComponentOther
	}
}

// ----------------------------------------------------------------------------
// Service: Reconciliation & Matching (M19 / P1-04)
// ----------------------------------------------------------------------------

func (s *Service) QueueReconciliationBatch(ctx context.Context, r *ReconciliationRecord) (*ReconciliationRecord, error) {
	if r.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if r.ReconciliationState == "" {
		r.ReconciliationState = ReconciliationImportedOnly
	}
	if err := s.store.CreateReconciliationRecord(ctx, r); err != nil {
		return nil, err
	}

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"record_id":    r.RecordID,
			"workspace_id": r.WorkspaceID,
			"scope_type":   r.ScopeType,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "reconciliation.batch_queued",
			AggregateType: "reconciliation_record",
			AggregateID:   r.RecordID,
			WorkspaceID:   r.WorkspaceID,
			PayloadJSON:   payload,
			CreatedAt:     s.clock(),
		})
	}
	return r, nil
}

func (s *Service) Match(
	ctx context.Context,
	workspaceID, settlementID, lineID, orderID, recordID string,
	allocAmount tenantdb.ExactDecimal,
) (*SettlementLine, *Order, *ReconciliationMatch, error) {
	if workspaceID == "" {
		return nil, nil, nil, ErrMissingTenant
	}
	line, order, match, err := s.store.AtomicMatch(ctx, workspaceID, settlementID, lineID, orderID, recordID, allocAmount)
	if err != nil {
		return nil, nil, nil, err
	}

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"match_id":         match.MatchID,
			"workspace_id":     workspaceID,
			"line_id":          lineID,
			"order_id":         orderID,
			"allocated_amount": allocAmount.String(),
			"record_id":        recordID,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "reconciliation.matched",
			AggregateType: "reconciliation_match",
			AggregateID:   match.MatchID,
			WorkspaceID:   workspaceID,
			PayloadJSON:   payload,
			CreatedAt:     s.clock(),
		})
	}
	return line, order, match, nil
}

func (s *Service) ManualMatch(
	ctx context.Context,
	workspaceID, settlementID, lineID, orderID, recordID string,
	allocAmount tenantdb.ExactDecimal,
	reason string,
	actorID string,
) (*SettlementLine, *Order, *ReconciliationMatch, error) {
	line, order, match, err := s.Match(ctx, workspaceID, settlementID, lineID, orderID, recordID, allocAmount)
	if err != nil {
		return nil, nil, nil, err
	}
	if recordID != "" {
		rec, getErr := s.store.GetReconciliationRecord(ctx, workspaceID, recordID)
		if getErr == nil && rec != nil {
			rec.OverrideReason = reason
			rec.OverrideBy = actorID
			now := s.clock()
			rec.OverrideAt = &now
			rec.ReconciliationState = ReconciliationManuallyOverridden
			_ = s.store.UpdateReconciliationRecord(ctx, rec)
		}
	}
	return line, order, match, nil
}

func (s *Service) OverrideReconciliation(
	ctx context.Context,
	workspaceID, recordID, decision, reason, actorID string,
	evidenceIDs []string,
) (*ReconciliationRecord, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	rec, err := s.store.GetReconciliationRecord(ctx, workspaceID, recordID)
	if err != nil {
		return nil, err
	}

	now := s.clock()
	rec.OverrideReason = reason
	rec.OverrideBy = actorID
	rec.OverrideAt = &now
	rec.ReconciliationState = ReconciliationManuallyOverridden
	rec.UpdatedAt = now

	if err := s.store.UpdateReconciliationRecord(ctx, rec); err != nil {
		return nil, err
	}

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"record_id":    recordID,
			"workspace_id": workspaceID,
			"decision":     decision,
			"reason":       reason,
			"override_by":  actorID,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "reconciliation.overridden",
			AggregateType: "reconciliation_record",
			AggregateID:   recordID,
			WorkspaceID:   workspaceID,
			PayloadJSON:   payload,
			CreatedAt:     s.clock(),
		})
	}
	return rec, nil
}

func (s *Service) GetReconciliationRecord(ctx context.Context, workspaceID, recordID string) (*ReconciliationRecord, []ReconciliationMatch, error) {
	if workspaceID == "" {
		return nil, nil, ErrMissingTenant
	}
	rec, err := s.store.GetReconciliationRecord(ctx, workspaceID, recordID)
	if err != nil {
		return nil, nil, err
	}
	matches, err := s.store.ListReconciliationMatches(ctx, workspaceID, recordID)
	if err != nil {
		return nil, nil, err
	}
	return rec, matches, nil
}

func (s *Service) ListReconciliationRecords(ctx context.Context, workspaceID string, filter ReconciliationFilter, limit, offset int) ([]ReconciliationRecord, int64, error) {
	if workspaceID == "" {
		return nil, 0, ErrMissingTenant
	}
	return s.store.ListReconciliationRecords(ctx, workspaceID, filter, limit, offset)
}

func (s *Service) ListPendingGaps(
	ctx context.Context,
	workspaceID string,
	callerRole string,
	filter DataGapFilter,
	limit, offset int,
) ([]DataGapItem, int64, int32, tenantdb.ExactDecimal, int32, error) {
	if workspaceID == "" {
		return nil, 0, 0, tenantdb.ZeroDecimal(), 0, ErrMissingTenant
	}

	// CRITICAL ACCEPTANCE TARGET: Finance gaps do not leak to Viewer
	if callerRole == "viewer" || callerRole == rbac.RoleViewer {
		return []DataGapItem{}, 0, 0, tenantdb.ZeroDecimal(), 0, nil
	}

	items, total, err := s.store.ListDataGaps(ctx, workspaceID, filter, limit, offset)
	if err != nil {
		return nil, 0, 0, tenantdb.ZeroDecimal(), 0, err
	}

	// Calculate overall unreconciled amount and counts
	unreconciledAmount := tenantdb.ZeroDecimal()
	unreconciledCount := 0
	for _, item := range items {
		if item.GapType == "unreconciled_settlement" {
			unreconciledCount++
			unreconciledAmount, _ = unreconciledAmount.Add(item.MonetaryAmount)
		}
	}

	s.mu.RLock()
	missingCOGS := int32(len(s.missingCOGSOrders))
	s.mu.RUnlock()

	return items, total, missingCOGS, unreconciledAmount, int32(unreconciledCount), nil
}

// ----------------------------------------------------------------------------
// Service: Evidence Objects (§11.4 & RULE-M19-005)
// ----------------------------------------------------------------------------

func (s *Service) SubmitEvidence(ctx context.Context, e *EvidenceObject, rawContent []byte) (*EvidenceObject, error) {
	if e.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}

	// Compute SHA-512 content hash if raw content is provided
	if len(rawContent) > 0 {
		hashArr := sha512.Sum512(rawContent)
		computedHash := hex.EncodeToString(hashArr[:])
		if e.ContentHash != "" && !strings.EqualFold(e.ContentHash, computedHash) {
			return nil, errors.New("finance: content_hash does not match computed SHA-512")
		}
		e.ContentHash = computedHash
	}

	if e.ContentHash == "" {
		return nil, errors.New("finance: content_hash is required for evidence")
	}

	if e.VerificationStatus == "" {
		e.VerificationStatus = VerificationStatusPending
	}
	if e.CollectedAt.IsZero() {
		e.CollectedAt = s.clock()
	}

	if err := s.store.CreateEvidence(ctx, e); err != nil {
		return nil, err
	}

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"evidence_id":       e.EvidenceID,
			"workspace_id":      e.WorkspaceID,
			"evidence_type":     e.EvidenceType,
			"source_provenance": e.SourceProvenance,
			"content_hash":      e.ContentHash,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "evidence.submitted",
			AggregateType: "evidence_object",
			AggregateID:   e.EvidenceID,
			WorkspaceID:   e.WorkspaceID,
			PayloadJSON:   payload,
			CreatedAt:     s.clock(),
		})
	}

	return e, nil
}

func (s *Service) GetEvidence(ctx context.Context, workspaceID, evidenceID string) (*EvidenceObject, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetEvidence(ctx, workspaceID, evidenceID)
}

func (s *Service) ListEvidence(ctx context.Context, workspaceID string, filter EvidenceFilter, limit, offset int) ([]EvidenceObject, int64, error) {
	if workspaceID == "" {
		return nil, 0, ErrMissingTenant
	}
	return s.store.ListEvidence(ctx, workspaceID, filter, limit, offset)
}

// ----------------------------------------------------------------------------
// Service: Proof Bundles (§11.5 & RULE-M19-006)
// ----------------------------------------------------------------------------

func (s *Service) AssembleProofBundle(ctx context.Context, pb *ProofBundle) (*ProofBundle, error) {
	if pb.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}

	// Verify all supporting evidence exists
	allVerified := true
	for _, evID := range pb.SupportingEvidenceIDs {
		ev, err := s.store.GetEvidence(ctx, pb.WorkspaceID, evID)
		if err != nil {
			return nil, fmt.Errorf("supporting evidence %s not found: %w", evID, err)
		}
		if ev.VerificationStatus != VerificationStatusVerified {
			allVerified = false
		}
	}

	if pb.Confidence == "" {
		if len(pb.SupportingEvidenceIDs) == 0 {
			pb.Confidence = ConfidenceLow
		} else if allVerified {
			pb.Confidence = ConfidenceHigh
		} else {
			pb.Confidence = ConfidenceMedium
		}
	}

	if err := s.store.CreateProofBundle(ctx, pb); err != nil {
		return nil, err
	}

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"proof_bundle_id": pb.ProofBundleID,
			"workspace_id":    pb.WorkspaceID,
			"claim_scope":     pb.ClaimScope,
			"confidence":      pb.Confidence,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "proof_bundle.assembled",
			AggregateType: "proof_bundle",
			AggregateID:   pb.ProofBundleID,
			WorkspaceID:   pb.WorkspaceID,
			PayloadJSON:   payload,
			CreatedAt:     s.clock(),
		})
	}

	return pb, nil
}

func (s *Service) GetProofBundle(ctx context.Context, workspaceID, bundleID string) (*ProofBundle, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetProofBundle(ctx, workspaceID, bundleID)
}

func (s *Service) ListProofBundles(ctx context.Context, workspaceID string, filter ProofBundleFilter, limit, offset int) ([]ProofBundle, int64, error) {
	if workspaceID == "" {
		return nil, 0, ErrMissingTenant
	}
	return s.store.ListProofBundles(ctx, workspaceID, filter, limit, offset)
}

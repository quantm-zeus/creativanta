package finance

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

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
	store     Store
	eventSink EventSink
	clock     func() time.Time

	// Internal tracker for orders with missing COGS
	missingCOGSOrders map[string]bool
	pendingOrders     map[string]OrderPostingInput
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
	}
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
		s.pendingOrders[input.OrderID] = input
		return nil
	}

	// Order is completed: remove from pending pool if present
	delete(s.pendingOrders, input.OrderID)

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
		s.missingCOGSOrders[input.OrderID] = true
	} else {
		delete(s.missingCOGSOrders, input.OrderID)
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
	existing, err := s.store.FindPostingByOrigin(ctx, workspaceID, "order", orderID, component)
	if err != nil {
		return err
	}

	now := s.clock()

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
	if err := s.store.CreatePosting(ctx, reversal); err != nil {
		return fmt.Errorf("create reversal: %w", err)
	}

	// 2. Append new corrected posting
	corrected := &FinancialPosting{
		WorkspaceID:          workspaceID,
		OriginType:           "order",
		OriginID:             orderID,
		OriginVersion:        newVersion,
		Component:            component,
		Amount:               newAmount,
		Currency:             existing.Currency,
		SourceClass:          sourceClass,
		Confidence:           confidence,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          existing.EffectiveAt,
		CreatedAt:            now,
	}
	return s.store.CreatePosting(ctx, corrected)
}

// RecordRefundPosting creates a negative refund posting without netting original revenue (F02).
func (s *Service) RecordRefundPosting(
	ctx context.Context,
	workspaceID, refundID, orderID string,
	refundAmount tenantdb.ExactDecimal,
	currency string,
	sourceClass, confidence string,
	fx ExchangeRateSnapshot,
) error {
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
	return s.store.CreatePosting(ctx, posting)
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

	hasMissingCOGS := len(s.missingCOGSOrders) > 0
	summary, err := SummarizePostings(postings, hasMissingCOGS)
	if err != nil {
		return nil, err
	}

	// Calculate pending revenue from pending orders
	pendingRevenue := tenantdb.ZeroDecimal()
	for _, p := range s.pendingOrders {
		if p.WorkspaceID == workspaceID {
			baseP, _ := ComputeBaseAmount(p.GrossAmount, p.ExchangeRateSnapshot)
			pendingRevenue, _ = pendingRevenue.Add(baseP)
		}
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
		UnknownRequiredComponentsCount: len(s.missingCOGSOrders),
		PendingRevenue:                 pendingRevenue,
		UnreconciledAmount:             unreconciledAmount,
		UnreconciledCount:              unreconciledCount,
	}

	_ = s.store.CreateSnapshot(ctx, snapshot)

	if s.eventSink != nil {
		payload, _ := json.Marshal(map[string]any{
			"snapshot_id":  snapshot.SnapshotID,
			"workspace_id": snapshot.WorkspaceID,
			"gross_revenue": snapshot.GrossRevenue.String(),
			"net_profit":   snapshot.NetProfit.String(),
			"confidence":   snapshot.Confidence,
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

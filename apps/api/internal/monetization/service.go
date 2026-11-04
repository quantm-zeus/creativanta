package monetization

import (
	"context"
	"encoding/json"
	"fmt"
	"math/big"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
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
	Emit(ctx context.Context, ev OutboxEvent) error
}

type LedgerRecorder interface {
	RecordOrderRevenue(ctx context.Context, workspaceID, orderID, offerID, couponID string, grossAmount, discountAmount, netAmount tenantdb.ExactDecimal, currency string, now time.Time) (string, error)
	RecordCampaignCost(ctx context.Context, workspaceID, campaignID, costType, description string, amount tenantdb.ExactDecimal, currency string, now time.Time) (string, error)
}

// DefaultLedgerRecorder stores postings in memory if no external ledger adapter is injected.
type DefaultLedgerRecorder struct {
	mu       sync.RWMutex
	postings map[string]map[string]any // postingID -> details
}

func NewDefaultLedgerRecorder() *DefaultLedgerRecorder {
	return &DefaultLedgerRecorder{postings: make(map[string]map[string]any)}
}

func (d *DefaultLedgerRecorder) RecordOrderRevenue(ctx context.Context, workspaceID, orderID, offerID, couponID string, grossAmount, discountAmount, netAmount tenantdb.ExactDecimal, currency string, now time.Time) (string, error) {
	d.mu.Lock()
	defer d.mu.Unlock()

	postingID := fmt.Sprintf("post-rev-%s", newUUID()[:8])
	d.postings[postingID] = map[string]any{
		"workspace_id":    workspaceID,
		"order_id":        orderID,
		"offer_id":        offerID,
		"coupon_id":       couponID,
		"gross_amount":    grossAmount.String(),
		"discount_amount": discountAmount.String(),
		"net_amount":      netAmount.String(),
		"currency":        currency,
		"component":       "revenue",
		"created_at":      now,
	}
	return postingID, nil
}

func (d *DefaultLedgerRecorder) RecordCampaignCost(ctx context.Context, workspaceID, campaignID, costType, description string, amount tenantdb.ExactDecimal, currency string, now time.Time) (string, error) {
	d.mu.Lock()
	defer d.mu.Unlock()

	postingID := fmt.Sprintf("post-cost-%s", newUUID()[:8])
	d.postings[postingID] = map[string]any{
		"workspace_id": workspaceID,
		"campaign_id":  campaignID,
		"cost_type":    costType,
		"description":  description,
		"amount":       amount.String(),
		"currency":     currency,
		"component":    "campaign_cost",
		"created_at":   now,
	}
	return postingID, nil
}

type Service struct {
	store     Store
	ledger    LedgerRecorder
	eventSink EventSink
	clock     func() time.Time
}

func NewService(store Store, ledger LedgerRecorder, sink EventSink, clock func() time.Time) *Service {
	if clock == nil {
		clock = time.Now
	}
	if ledger == nil {
		ledger = NewDefaultLedgerRecorder()
	}
	return &Service{
		store:     store,
		ledger:    ledger,
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

// ----------------------------------------------------------------------------
// Offer Management
// ----------------------------------------------------------------------------

func (s *Service) CreateOffer(ctx context.Context, offer *Offer) (*Offer, error) {
	if offer.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if offer.LifecycleState == "" {
		offer.LifecycleState = OfferStateDraft
	}
	if offer.PricingCurrency == "" {
		offer.PricingCurrency = "VND"
	}
	if err := s.store.CreateOffer(ctx, offer); err != nil {
		return nil, err
	}
	return offer, nil
}

func (s *Service) GetOffer(ctx context.Context, workspaceID, offerID string) (*Offer, error) {
	return s.store.GetOffer(ctx, workspaceID, offerID)
}

func (s *Service) ListOffers(ctx context.Context, workspaceID string, filter OfferFilter) ([]*Offer, int, error) {
	return s.store.ListOffers(ctx, workspaceID, filter)
}

func (s *Service) UpdateOffer(ctx context.Context, offer *Offer) (*Offer, error) {
	existing, err := s.store.GetOffer(ctx, offer.WorkspaceID, offer.OfferID)
	if err != nil {
		return nil, err
	}
	if existing.LifecycleState == OfferStateRetired {
		return nil, ErrOfferInvalidStateChange
	}
	if err := s.store.UpdateOffer(ctx, offer); err != nil {
		return nil, err
	}
	return offer, nil
}

// ActivateOffer activates an offer with product validation per RULE-M14-002 and EC-M14-001.
func (s *Service) ActivateOffer(ctx context.Context, workspaceID, offerID string) (*Offer, error) {
	offer, err := s.store.GetOffer(ctx, workspaceID, offerID)
	if err != nil {
		return nil, err
	}

	// EC-M14-001 & AC 4: Offer must reference product_id or set product_less_declaration
	hasProduct := offer.ProductID != nil && strings.TrimSpace(*offer.ProductID) != ""
	hasProductLess := strings.TrimSpace(offer.ProductLessDeclaration) != ""
	if !hasProduct && !hasProductLess {
		return nil, ErrOfferProductRequired
	}

	if offer.LifecycleState == OfferStateRetired {
		return nil, ErrOfferInvalidStateChange
	}

	now := s.clock().UTC()
	if offer.ValidUntil != nil && !offer.ValidUntil.IsZero() && now.After(*offer.ValidUntil) {
		offer.LifecycleState = OfferStateExpired
		_ = s.store.UpdateOffer(ctx, offer)
		return nil, ErrOfferExpired
	}

	offer.LifecycleState = OfferStateActive
	offer.UpdatedAt = now
	if err := s.store.UpdateOffer(ctx, offer); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "offer.activated", "offer", offer.OfferID, workspaceID, map[string]any{
		"offer_id": offer.OfferID,
		"type":     offer.OfferType,
	})
	return offer, nil
}

func (s *Service) PauseOffer(ctx context.Context, workspaceID, offerID string) (*Offer, error) {
	offer, err := s.store.GetOffer(ctx, workspaceID, offerID)
	if err != nil {
		return nil, err
	}
	if offer.LifecycleState != OfferStateActive {
		return nil, ErrOfferInvalidStateChange
	}
	offer.LifecycleState = OfferStatePaused
	offer.UpdatedAt = s.clock().UTC()
	if err := s.store.UpdateOffer(ctx, offer); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "offer.paused", "offer", offer.OfferID, workspaceID, map[string]any{
		"offer_id": offer.OfferID,
	})
	return offer, nil
}

func (s *Service) ResumeOffer(ctx context.Context, workspaceID, offerID string) (*Offer, error) {
	offer, err := s.store.GetOffer(ctx, workspaceID, offerID)
	if err != nil {
		return nil, err
	}
	if offer.LifecycleState != OfferStatePaused {
		return nil, ErrOfferInvalidStateChange
	}
	now := s.clock().UTC()
	if offer.ValidUntil != nil && !offer.ValidUntil.IsZero() && now.After(*offer.ValidUntil) {
		offer.LifecycleState = OfferStateExpired
		_ = s.store.UpdateOffer(ctx, offer)
		return nil, ErrOfferExpired
	}
	offer.LifecycleState = OfferStateActive
	offer.UpdatedAt = now
	if err := s.store.UpdateOffer(ctx, offer); err != nil {
		return nil, err
	}
	return offer, nil
}

func (s *Service) ExpireOffer(ctx context.Context, workspaceID, offerID string) (*Offer, error) {
	offer, err := s.store.GetOffer(ctx, workspaceID, offerID)
	if err != nil {
		return nil, err
	}
	offer.LifecycleState = OfferStateExpired
	offer.UpdatedAt = s.clock().UTC()
	if err := s.store.UpdateOffer(ctx, offer); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "offer.expired", "offer", offer.OfferID, workspaceID, map[string]any{
		"offer_id": offer.OfferID,
	})
	return offer, nil
}

func (s *Service) RetireOffer(ctx context.Context, workspaceID, offerID string) (*Offer, error) {
	offer, err := s.store.GetOffer(ctx, workspaceID, offerID)
	if err != nil {
		return nil, err
	}
	offer.LifecycleState = OfferStateRetired
	offer.UpdatedAt = s.clock().UTC()
	if err := s.store.UpdateOffer(ctx, offer); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "offer.retired", "offer", offer.OfferID, workspaceID, map[string]any{
		"offer_id": offer.OfferID,
	})
	return offer, nil
}

func (s *Service) DuplicateOffer(ctx context.Context, workspaceID, offerID, newTitle string) (*Offer, error) {
	existing, err := s.store.GetOffer(ctx, workspaceID, offerID)
	if err != nil {
		return nil, err
	}
	newOffer := *existing
	newOffer.OfferID = newUUID()
	newOffer.Title = newTitle
	newOffer.LifecycleState = OfferStateDraft
	if err := s.store.CreateOffer(ctx, &newOffer); err != nil {
		return nil, err
	}
	return &newOffer, nil
}

func (s *Service) DeleteOffer(ctx context.Context, workspaceID, offerID string) error {
	return s.store.DeleteOffer(ctx, workspaceID, offerID)
}

func (s *Service) BulkPauseOffers(ctx context.Context, workspaceID string, offerIDs []string) (int, error) {
	count := 0
	for _, id := range offerIDs {
		_, err := s.PauseOffer(ctx, workspaceID, id)
		if err == nil {
			count++
		}
	}
	return count, nil
}

// ----------------------------------------------------------------------------
// Coupon Management & Validation
// ----------------------------------------------------------------------------

func (s *Service) CreateCoupon(ctx context.Context, coupon *Coupon) (*Coupon, error) {
	if coupon.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if coupon.LifecycleState == "" {
		coupon.LifecycleState = CouponStateDraft
	}
	coupon.Code = strings.ToUpper(strings.TrimSpace(coupon.Code))
	if err := s.store.CreateCoupon(ctx, coupon); err != nil {
		return nil, err
	}
	return coupon, nil
}

func (s *Service) GetCoupon(ctx context.Context, workspaceID, couponID string) (*Coupon, error) {
	return s.store.GetCoupon(ctx, workspaceID, couponID)
}

func (s *Service) GetCouponByCode(ctx context.Context, workspaceID, code string) (*Coupon, error) {
	return s.store.GetCouponByCode(ctx, workspaceID, code)
}

func (s *Service) ListCoupons(ctx context.Context, workspaceID string, filter CouponFilter) ([]*Coupon, int, error) {
	return s.store.ListCoupons(ctx, workspaceID, filter)
}

func (s *Service) UpdateCoupon(ctx context.Context, coupon *Coupon) (*Coupon, error) {
	return coupon, s.store.UpdateCoupon(ctx, coupon)
}

func (s *Service) ActivateCoupon(ctx context.Context, workspaceID, couponID string) (*Coupon, error) {
	coupon, err := s.store.GetCoupon(ctx, workspaceID, couponID)
	if err != nil {
		return nil, err
	}
	if coupon.LifecycleState == CouponStateRevoked || coupon.LifecycleState == CouponStateRetired {
		return nil, ErrCouponInvalidStateChange
	}
	now := s.clock().UTC()
	if coupon.ValidUntil != nil && !coupon.ValidUntil.IsZero() && now.After(*coupon.ValidUntil) {
		coupon.LifecycleState = CouponStateExpired
		_ = s.store.UpdateCoupon(ctx, coupon)
		return nil, ErrCouponExpired
	}
	coupon.LifecycleState = CouponStateActive
	coupon.UpdatedAt = now
	if err := s.store.UpdateCoupon(ctx, coupon); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "coupon.activated", "coupon", coupon.CouponID, workspaceID, map[string]any{
		"coupon_id": coupon.CouponID,
		"code":      coupon.Code,
	})
	return coupon, nil
}

func (s *Service) PauseCoupon(ctx context.Context, workspaceID, couponID string) (*Coupon, error) {
	coupon, err := s.store.GetCoupon(ctx, workspaceID, couponID)
	if err != nil {
		return nil, err
	}
	if coupon.LifecycleState != CouponStateActive {
		return nil, ErrCouponInvalidStateChange
	}
	coupon.LifecycleState = CouponStatePaused
	coupon.UpdatedAt = s.clock().UTC()
	return coupon, s.store.UpdateCoupon(ctx, coupon)
}

func (s *Service) ResumeCoupon(ctx context.Context, workspaceID, couponID string) (*Coupon, error) {
	coupon, err := s.store.GetCoupon(ctx, workspaceID, couponID)
	if err != nil {
		return nil, err
	}
	if coupon.LifecycleState != CouponStatePaused {
		return nil, ErrCouponInvalidStateChange
	}
	now := s.clock().UTC()
	if coupon.ValidUntil != nil && !coupon.ValidUntil.IsZero() && now.After(*coupon.ValidUntil) {
		coupon.LifecycleState = CouponStateExpired
		_ = s.store.UpdateCoupon(ctx, coupon)
		return nil, ErrCouponExpired
	}
	coupon.LifecycleState = CouponStateActive
	coupon.UpdatedAt = now
	return coupon, s.store.UpdateCoupon(ctx, coupon)
}

func (s *Service) DeactivateCoupon(ctx context.Context, workspaceID, couponID string) (*Coupon, error) {
	return s.PauseCoupon(ctx, workspaceID, couponID)
}

func (s *Service) RevokeCoupon(ctx context.Context, workspaceID, couponID, reason string) (*Coupon, error) {
	coupon, err := s.store.GetCoupon(ctx, workspaceID, couponID)
	if err != nil {
		return nil, err
	}
	coupon.LifecycleState = CouponStateRevoked
	coupon.UpdatedAt = s.clock().UTC()
	return coupon, s.store.UpdateCoupon(ctx, coupon)
}

func (s *Service) DeleteCoupon(ctx context.Context, workspaceID, couponID string) error {
	return s.store.DeleteCoupon(ctx, workspaceID, couponID)
}

type CouponValidationResult struct {
	Valid              bool                  `json:"valid"`
	CouponID           string                `json:"coupon_id"`
	DiscountType       string                `json:"discount_type"`
	DiscountValue      tenantdb.ExactDecimal `json:"discount_value"`
	CalculatedDiscount tenantdb.ExactDecimal `json:"calculated_discount"`
	RemainingUses      int                   `json:"remaining_uses"`
	ExpiresAt          *time.Time            `json:"expires_at,omitempty"`
	FailureReason      string                `json:"failure_reason,omitempty"`
}

// ValidateCoupon checks coupon rules without committing redemption.
func (s *Service) ValidateCoupon(ctx context.Context, workspaceID, code string, orderAmount tenantdb.ExactDecimal) (*CouponValidationResult, error) {
	coupon, err := s.store.GetCouponByCode(ctx, workspaceID, code)
	if err != nil {
		return &CouponValidationResult{Valid: false, FailureReason: "Coupon code not found"}, ErrCouponNotFound
	}

	now := s.clock().UTC()
	if coupon.LifecycleState == CouponStateRevoked {
		return &CouponValidationResult{Valid: false, FailureReason: "Coupon has been revoked"}, ErrCouponRevoked
	}
	if coupon.LifecycleState == CouponStateExpired || (coupon.ValidUntil != nil && !coupon.ValidUntil.IsZero() && now.After(*coupon.ValidUntil)) {
		return &CouponValidationResult{Valid: false, FailureReason: "Coupon code has expired"}, ErrCouponExpired
	}
	if coupon.LifecycleState != CouponStateActive {
		return &CouponValidationResult{Valid: false, FailureReason: "Coupon is not active"}, ErrCouponNotActive
	}
	if coupon.MaxUses != nil && coupon.CurrentUses >= *coupon.MaxUses {
		return &CouponValidationResult{Valid: false, FailureReason: "Coupon usage limit reached"}, ErrCouponLimitExceeded
	}

	// Min order amount check
	if coupon.MinOrderAmount != nil && orderAmount.Cmp(*coupon.MinOrderAmount) < 0 {
		return &CouponValidationResult{
			Valid:         false,
			FailureReason: fmt.Sprintf("Order subtotal must be at least %s", coupon.MinOrderAmount.String()),
		}, ErrCouponMinOrderNotMet
	}

	// Calculate discount
	discount := s.calculateDiscount(coupon, orderAmount)
	remUses := -1
	if coupon.MaxUses != nil {
		remUses = *coupon.MaxUses - coupon.CurrentUses
		if remUses < 0 {
			remUses = 0
		}
	}

	return &CouponValidationResult{
		Valid:              true,
		CouponID:           coupon.CouponID,
		DiscountType:       string(coupon.CouponType),
		DiscountValue:      coupon.DiscountValue,
		CalculatedDiscount: discount,
		RemainingUses:      remUses,
		ExpiresAt:          coupon.ValidUntil,
	}, nil
}

func (s *Service) calculateDiscount(coupon *Coupon, orderAmount tenantdb.ExactDecimal) tenantdb.ExactDecimal {
	zero := tenantdb.ZeroDecimal()
	if orderAmount.Cmp(zero) <= 0 {
		return zero
	}

	switch coupon.CouponType {
	case CouponTypeFixedAmount:
		if coupon.DiscountValue.Cmp(orderAmount) > 0 {
			return orderAmount
		}
		return coupon.DiscountValue
	case CouponTypePercentage:
		// discount = orderAmount * (discount_value / 100)
		onePercent, _ := tenantdb.ParseExactDecimal("0.010000")
		pctFraction, err := coupon.DiscountValue.MulFloor(onePercent)
		if err != nil {
			return zero
		}
		disc, err := orderAmount.MulFloor(pctFraction)
		if err != nil {
			return zero
		}
		if disc.Cmp(orderAmount) > 0 {
			return orderAmount
		}
		return disc
	case CouponTypeFreeShipping:
		return coupon.DiscountValue
	default:
		return zero
	}
}

// ----------------------------------------------------------------------------
// Campaign Management & Budget Alerts
// ----------------------------------------------------------------------------

func (s *Service) CreateCampaign(ctx context.Context, campaign *Campaign) (*Campaign, error) {
	if campaign.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if campaign.Status == "" {
		campaign.Status = CampaignStatusPlanned
	}
	if campaign.BudgetCurrency == "" {
		campaign.BudgetCurrency = "VND"
	}
	if err := s.store.CreateCampaign(ctx, campaign); err != nil {
		return nil, err
	}
	return campaign, nil
}

func (s *Service) GetCampaign(ctx context.Context, workspaceID, campaignID string) (*Campaign, error) {
	return s.store.GetCampaign(ctx, workspaceID, campaignID)
}

func (s *Service) ListCampaigns(ctx context.Context, workspaceID string, filter CampaignFilter) ([]*Campaign, int, error) {
	return s.store.ListCampaigns(ctx, workspaceID, filter)
}

func (s *Service) UpdateCampaign(ctx context.Context, campaign *Campaign) (*Campaign, error) {
	return campaign, s.store.UpdateCampaign(ctx, campaign)
}

func (s *Service) ActivateCampaign(ctx context.Context, workspaceID, campaignID string) (*Campaign, error) {
	campaign, err := s.store.GetCampaign(ctx, workspaceID, campaignID)
	if err != nil {
		return nil, err
	}
	campaign.Status = CampaignStatusLive
	campaign.UpdatedAt = s.clock().UTC()
	if err := s.store.UpdateCampaign(ctx, campaign); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "campaign.started", "campaign", campaign.CampaignID, workspaceID, map[string]any{
		"campaign_id": campaign.CampaignID,
	})
	return campaign, nil
}

func (s *Service) PauseCampaign(ctx context.Context, workspaceID, campaignID string) (*Campaign, error) {
	campaign, err := s.store.GetCampaign(ctx, workspaceID, campaignID)
	if err != nil {
		return nil, err
	}
	campaign.Status = CampaignStatusPaused
	campaign.UpdatedAt = s.clock().UTC()
	return campaign, s.store.UpdateCampaign(ctx, campaign)
}

func (s *Service) ResumeCampaign(ctx context.Context, workspaceID, campaignID string) (*Campaign, error) {
	campaign, err := s.store.GetCampaign(ctx, workspaceID, campaignID)
	if err != nil {
		return nil, err
	}
	campaign.Status = CampaignStatusLive
	campaign.UpdatedAt = s.clock().UTC()
	return campaign, s.store.UpdateCampaign(ctx, campaign)
}

func (s *Service) EndCampaign(ctx context.Context, workspaceID, campaignID string) (*Campaign, error) {
	campaign, err := s.store.GetCampaign(ctx, workspaceID, campaignID)
	if err != nil {
		return nil, err
	}
	campaign.Status = CampaignStatusCompleted
	campaign.UpdatedAt = s.clock().UTC()
	if err := s.store.UpdateCampaign(ctx, campaign); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "campaign.completed", "campaign", campaign.CampaignID, workspaceID, map[string]any{
		"campaign_id": campaign.CampaignID,
	})
	return campaign, nil
}

func (s *Service) DeleteCampaign(ctx context.Context, workspaceID, campaignID string) error {
	return s.store.DeleteCampaign(ctx, workspaceID, campaignID)
}

type AddCampaignCostResult struct {
	CostItemID           string                `json:"cost_item_id"`
	CampaignID           string                `json:"campaign_id"`
	TotalSpend           tenantdb.ExactDecimal `json:"total_spend"`
	Budget               tenantdb.ExactDecimal `json:"budget"`
	BudgetUtilizationPct string                `json:"budget_utilization_pct"`
	WarningEmitted       bool                  `json:"warning_emitted"` // spend >= 80%
	AlertEmitted         bool                  `json:"alert_emitted"`   // spend >= 100%
}

// AddCampaignCost tracks an expense against a campaign, verifies budget thresholds, and posts to ledger.
func (s *Service) AddCampaignCost(ctx context.Context, cost *CampaignCostItem) (*AddCampaignCostResult, error) {
	campaign, err := s.store.GetCampaign(ctx, cost.WorkspaceID, cost.CampaignID)
	if err != nil {
		return nil, err
	}

	// 1. Add cost to store
	if err := s.store.AddCampaignCost(ctx, cost); err != nil {
		return nil, err
	}

	// 2. Financial impact reaches ledger (RULE-M14-001)
	_, _ = s.ledger.RecordCampaignCost(ctx, cost.WorkspaceID, cost.CampaignID, cost.CostType, cost.Description, cost.Amount, cost.Currency, s.clock().UTC())

	// 3. Compute budget utilization
	_, totalSpend, err := s.store.GetCampaignCosts(ctx, cost.WorkspaceID, cost.CampaignID)
	if err != nil {
		return nil, err
	}

	budget := tenantdb.ZeroDecimal()
	if campaign.Budget != nil {
		budget = *campaign.Budget
	}

	warning := false
	alert := false
	utilPctStr := "0.0%"

	if budget.IsPositive() {
		// Calculate utilization: (totalSpend / budget) * 100
		spendMicros := totalSpend.ToPgNumeric().Int
		budgetMicros := budget.ToPgNumeric().Int
		pctTimes100 := new(big.Int).Mul(spendMicros, big.NewInt(100))
		pctTimes100.Mul(pctTimes100, big.NewInt(1000000))
		pctMicros := new(big.Int).Quo(pctTimes100, budgetMicros)
		pctDec, err := tenantdb.FromPgNumeric(pgtype.Numeric{Int: pctMicros, Exp: -tenantdb.MaxDecimalScale, Valid: true})
		if err == nil {
			utilPctStr = fmt.Sprintf("%s%%", pctDec.String())
			eighty, _ := tenantdb.ParseExactDecimal("80.000000")
			oneHundred, _ := tenantdb.ParseExactDecimal("100.000000")
			if pctDec.Cmp(eighty) >= 0 {
				warning = true
			}
			if pctDec.Cmp(oneHundred) >= 0 {
				alert = true
				// EC-M14-003: alert to manager, optional pause
				s.emitEvent(ctx, "campaign.budget_exceeded", "campaign", campaign.CampaignID, cost.WorkspaceID, map[string]any{
					"campaign_id": campaign.CampaignID,
					"budget":      budget.String(),
					"total_spend": totalSpend.String(),
				})
			}
		}
	}

	return &AddCampaignCostResult{
		CostItemID:           cost.CostItemID,
		CampaignID:           cost.CampaignID,
		TotalSpend:           totalSpend,
		Budget:               budget,
		BudgetUtilizationPct: utilPctStr,
		WarningEmitted:       warning,
		AlertEmitted:         alert,
	}, nil
}

func (s *Service) GetCampaignCosts(ctx context.Context, workspaceID, campaignID string) ([]*CampaignCostItem, tenantdb.ExactDecimal, error) {
	return s.store.GetCampaignCosts(ctx, workspaceID, campaignID)
}

// ----------------------------------------------------------------------------
// Acceptance Coordination Engine: Checkout Evaluation & Concurrency Race Gate
// ----------------------------------------------------------------------------

type CheckoutRequest struct {
	WorkspaceID      string                `json:"workspace_id"`
	OfferID          string                `json:"offer_id,omitempty"`
	CouponCode       string                `json:"coupon_code,omitempty"`
	CustomerEntityID string                `json:"customer_entity_id,omitempty"`
	ProductIDs       []string              `json:"product_ids"`
	OrderAmount      tenantdb.ExactDecimal `json:"order_amount"`
	Currency         string                `json:"currency"`
}

// EvaluateCheckout processes order checkout validating offer expiration,
// atomic coupon redemption limits, and posting financial impact to the M19 ledger.
func (s *Service) EvaluateCheckout(ctx context.Context, req CheckoutRequest) (*CheckoutEvaluation, error) {
	if req.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	now := s.clock().UTC()
	if req.Currency == "" {
		req.Currency = "VND"
	}

	// ------------------------------------------------------------------------
	// TARGET 1: Expired offer rejected at checkout
	// ------------------------------------------------------------------------
	if req.OfferID != "" {
		offer, err := s.store.GetOffer(ctx, req.WorkspaceID, req.OfferID)
		if err != nil {
			return &CheckoutEvaluation{
				Accepted:     false,
				ErrorCode:    "ERR_OFFER_NOT_FOUND",
				ErrorMessage: "Specified offer does not exist",
			}, ErrOfferNotFound
		}

		// Strictly reject if expired (RULE-M14-002, EC-M14-002, Acceptance Target 1)
		if offer.IsExpired(now) {
			return &CheckoutEvaluation{
				Accepted:     false,
				ErrorCode:    "ERR_OFFER_EXPIRED",
				ErrorMessage: "Offer has expired and cannot be used at checkout",
			}, ErrOfferExpired
		}

		if offer.LifecycleState != OfferStateActive {
			return &CheckoutEvaluation{
				Accepted:     false,
				ErrorCode:    "ERR_OFFER_NOT_ACTIVE",
				ErrorMessage: fmt.Sprintf("Offer is not active (state: %s)", offer.LifecycleState),
			}, ErrOfferNotActive
		}
	}

	// ------------------------------------------------------------------------
	// TARGET 2: Coupon races do not exceed limits
	// ------------------------------------------------------------------------
	discountAmount := tenantdb.ZeroDecimal()
	couponID := ""
	remUses := -1

	if req.CouponCode != "" {
		valRes, err := s.ValidateCoupon(ctx, req.WorkspaceID, req.CouponCode, req.OrderAmount)
		if err != nil {
			errCode := "ERR_COUPON_INVALID"
			if valRes != nil && valRes.FailureReason == "Coupon code has expired" {
				errCode = "ERR_COUPON_EXPIRED"
			} else if valRes != nil && valRes.FailureReason == "Coupon usage limit reached" {
				errCode = "ERR_COUPON_LIMIT_EXCEEDED"
			}
			return &CheckoutEvaluation{
				Accepted:     false,
				ErrorCode:    errCode,
				ErrorMessage: valRes.FailureReason,
			}, err
		}

		// Perform atomic redemption to guarantee that concurrent races NEVER exceed limits
		tempOrderID := newUUID()
		redemption, updatedCoupon, err := s.store.RedeemCouponAtomic(
			ctx,
			req.WorkspaceID,
			valRes.CouponID,
			tempOrderID,
			valRes.CalculatedDiscount,
			req.Currency,
			now,
		)
		if err != nil {
			errCode := "ERR_COUPON_REDEMPTION_FAILED"
			if err == ErrCouponLimitExceeded {
				errCode = "ERR_COUPON_LIMIT_EXCEEDED"
			} else if err == ErrCouponExpired {
				errCode = "ERR_COUPON_EXPIRED"
			}
			return &CheckoutEvaluation{
				Accepted:     false,
				ErrorCode:    errCode,
				ErrorMessage: err.Error(),
			}, err
		}

		discountAmount = redemption.DiscountAmount
		couponID = redemption.CouponID
		if updatedCoupon.MaxUses != nil {
			remUses = *updatedCoupon.MaxUses - updatedCoupon.CurrentUses
			if remUses < 0 {
				remUses = 0
			}
		}

		// Emitted event per Domain Event Catalog §19
		s.emitEvent(ctx, "coupon.used", "coupon", couponID, req.WorkspaceID, map[string]any{
			"coupon_id":       couponID,
			"order_id":        tempOrderID,
			"discount_amount": discountAmount.String(),
		})
	}

	// Calculate net payable amount: max(0, orderAmount - discountAmount)
	netPayable, err := req.OrderAmount.Sub(discountAmount)
	if err != nil || netPayable.IsNegative() {
		netPayable = tenantdb.ZeroDecimal()
	}

	// ------------------------------------------------------------------------
	// TARGET 3: Financial impact reaches ledger
	// ------------------------------------------------------------------------
	orderID := newUUID()
	postingID, err := s.ledger.RecordOrderRevenue(
		ctx,
		req.WorkspaceID,
		orderID,
		req.OfferID,
		couponID,
		req.OrderAmount,
		discountAmount,
		netPayable,
		req.Currency,
		now,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to record financial impact into operating ledger: %w", err)
	}

	return &CheckoutEvaluation{
		Accepted:            true,
		OriginalAmount:      req.OrderAmount,
		DiscountAmount:      discountAmount,
		NetPayableAmount:    netPayable,
		Currency:            req.Currency,
		OrderID:             orderID,
		PostingID:           postingID,
		CouponID:            couponID,
		CouponRemainingUses: remUses,
	}, nil
}

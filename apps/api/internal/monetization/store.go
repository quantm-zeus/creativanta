package monetization

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type OfferFilter struct {
	LifecycleState *OfferLifecycleState
	ProductID      *string
	Query          string
	Sort           string
	PageSize       int
	PageToken      string
}

type CouponFilter struct {
	LifecycleState *CouponLifecycleState
	Query          string
	PageSize       int
	PageToken      string
}

type CampaignFilter struct {
	Status       *CampaignStatus
	CampaignType *CampaignType
	Query        string
	PageSize     int
	PageToken    string
}

// Store defines repository contracts for offers, coupons, campaigns, and redemptions.
type Store interface {
	// Offer operations
	CreateOffer(ctx context.Context, offer *Offer) error
	GetOffer(ctx context.Context, workspaceID, offerID string) (*Offer, error)
	ListOffers(ctx context.Context, workspaceID string, filter OfferFilter) ([]*Offer, int, error)
	UpdateOffer(ctx context.Context, offer *Offer) error
	DeleteOffer(ctx context.Context, workspaceID, offerID string) error

	// Coupon operations
	CreateCoupon(ctx context.Context, coupon *Coupon) error
	GetCoupon(ctx context.Context, workspaceID, couponID string) (*Coupon, error)
	GetCouponByCode(ctx context.Context, workspaceID, code string) (*Coupon, error)
	ListCoupons(ctx context.Context, workspaceID string, filter CouponFilter) ([]*Coupon, int, error)
	UpdateCoupon(ctx context.Context, coupon *Coupon) error
	DeleteCoupon(ctx context.Context, workspaceID, couponID string) error
	// RedeemCouponAtomic atomically validates availability, increments current_uses, transitions to expired if max_uses reached, and creates a redemption record.
	RedeemCouponAtomic(ctx context.Context, workspaceID, couponID, orderID string, discount tenantdb.ExactDecimal, currency string, now time.Time) (*CouponRedemption, *Coupon, error)

	// Campaign operations
	CreateCampaign(ctx context.Context, campaign *Campaign) error
	GetCampaign(ctx context.Context, workspaceID, campaignID string) (*Campaign, error)
	ListCampaigns(ctx context.Context, workspaceID string, filter CampaignFilter) ([]*Campaign, int, error)
	UpdateCampaign(ctx context.Context, campaign *Campaign) error
	DeleteCampaign(ctx context.Context, workspaceID, campaignID string) error
	AddCampaignCost(ctx context.Context, cost *CampaignCostItem) error
	GetCampaignCosts(ctx context.Context, workspaceID, campaignID string) ([]*CampaignCostItem, tenantdb.ExactDecimal, error)
}

// MemoryStore provides a thread-safe multi-tenant in-memory store for unit & race testing.
type MemoryStore struct {
	mu          sync.RWMutex
	offers      map[string]*Offer              // key: workspaceID:offerID
	coupons     map[string]*Coupon             // key: workspaceID:couponID
	couponCodes map[string]string              // key: workspaceID:code -> couponID
	redemptions map[string]*CouponRedemption   // key: workspaceID:redemptionID
	campaigns   map[string]*Campaign           // key: workspaceID:campaignID
	costs       map[string][]*CampaignCostItem // key: workspaceID:campaignID
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		offers:      make(map[string]*Offer),
		coupons:     make(map[string]*Coupon),
		couponCodes: make(map[string]string),
		redemptions: make(map[string]*CouponRedemption),
		campaigns:   make(map[string]*Campaign),
		costs:       make(map[string][]*CampaignCostItem),
	}
}

func (s *MemoryStore) CreateOffer(ctx context.Context, offer *Offer) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if offer.WorkspaceID == "" {
		return ErrMissingTenant
	}
	if offer.OfferID == "" {
		offer.OfferID = newUUID()
	}
	now := time.Now().UTC()
	offer.CreatedAt = now
	offer.UpdatedAt = now

	key := fmt.Sprintf("%s:%s", offer.WorkspaceID, offer.OfferID)
	// Clone
	cp := *offer
	s.offers[key] = &cp
	return nil
}

func (s *MemoryStore) GetOffer(ctx context.Context, workspaceID, offerID string) (*Offer, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", workspaceID, offerID)
	offer, ok := s.offers[key]
	if !ok || offer.DeletedAt != nil {
		return nil, ErrOfferNotFound
	}
	cp := *offer
	return &cp, nil
}

func (s *MemoryStore) ListOffers(ctx context.Context, workspaceID string, filter OfferFilter) ([]*Offer, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if workspaceID == "" {
		return nil, 0, ErrMissingTenant
	}

	var results []*Offer
	for _, o := range s.offers {
		if o.WorkspaceID != workspaceID || o.DeletedAt != nil {
			continue
		}
		if filter.LifecycleState != nil && o.LifecycleState != *filter.LifecycleState {
			continue
		}
		if filter.ProductID != nil && (o.ProductID == nil || *o.ProductID != *filter.ProductID) {
			continue
		}
		if filter.Query != "" && !strings.Contains(strings.ToLower(o.Title), strings.ToLower(filter.Query)) {
			continue
		}
		cp := *o
		results = append(results, &cp)
	}

	total := len(results)
	return results, total, nil
}

func (s *MemoryStore) UpdateOffer(ctx context.Context, offer *Offer) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if offer.WorkspaceID == "" {
		return ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", offer.WorkspaceID, offer.OfferID)
	existing, ok := s.offers[key]
	if !ok || existing.DeletedAt != nil {
		return ErrOfferNotFound
	}

	offer.UpdatedAt = time.Now().UTC()
	cp := *offer
	s.offers[key] = &cp
	return nil
}

func (s *MemoryStore) DeleteOffer(ctx context.Context, workspaceID, offerID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if workspaceID == "" {
		return ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", workspaceID, offerID)
	existing, ok := s.offers[key]
	if !ok || existing.DeletedAt != nil {
		return ErrOfferNotFound
	}
	now := time.Now().UTC()
	existing.DeletedAt = &now
	return nil
}

func (s *MemoryStore) CreateCoupon(ctx context.Context, coupon *Coupon) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if coupon.WorkspaceID == "" {
		return ErrMissingTenant
	}
	if coupon.CouponID == "" {
		coupon.CouponID = newUUID()
	}
	now := time.Now().UTC()
	coupon.CreatedAt = now
	coupon.UpdatedAt = now

	codeKey := fmt.Sprintf("%s:%s", coupon.WorkspaceID, strings.ToUpper(coupon.Code))
	if _, exists := s.couponCodes[codeKey]; exists {
		return fmt.Errorf("coupon code already exists in workspace")
	}

	key := fmt.Sprintf("%s:%s", coupon.WorkspaceID, coupon.CouponID)
	cp := *coupon
	s.coupons[key] = &cp
	s.couponCodes[codeKey] = coupon.CouponID
	return nil
}

func (s *MemoryStore) GetCoupon(ctx context.Context, workspaceID, couponID string) (*Coupon, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", workspaceID, couponID)
	coupon, ok := s.coupons[key]
	if !ok || coupon.DeletedAt != nil {
		return nil, ErrCouponNotFound
	}
	cp := *coupon
	return &cp, nil
}

func (s *MemoryStore) GetCouponByCode(ctx context.Context, workspaceID, code string) (*Coupon, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	codeKey := fmt.Sprintf("%s:%s", workspaceID, strings.ToUpper(code))
	couponID, ok := s.couponCodes[codeKey]
	if !ok {
		return nil, ErrCouponNotFound
	}
	key := fmt.Sprintf("%s:%s", workspaceID, couponID)
	coupon, ok := s.coupons[key]
	if !ok || coupon.DeletedAt != nil {
		return nil, ErrCouponNotFound
	}
	cp := *coupon
	return &cp, nil
}

func (s *MemoryStore) ListCoupons(ctx context.Context, workspaceID string, filter CouponFilter) ([]*Coupon, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if workspaceID == "" {
		return nil, 0, ErrMissingTenant
	}

	var results []*Coupon
	for _, c := range s.coupons {
		if c.WorkspaceID != workspaceID || c.DeletedAt != nil {
			continue
		}
		if filter.LifecycleState != nil && c.LifecycleState != *filter.LifecycleState {
			continue
		}
		if filter.Query != "" && !strings.Contains(strings.ToUpper(c.Code), strings.ToUpper(filter.Query)) {
			continue
		}
		cp := *c
		results = append(results, &cp)
	}

	return results, len(results), nil
}

func (s *MemoryStore) UpdateCoupon(ctx context.Context, coupon *Coupon) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if coupon.WorkspaceID == "" {
		return ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", coupon.WorkspaceID, coupon.CouponID)
	existing, ok := s.coupons[key]
	if !ok || existing.DeletedAt != nil {
		return ErrCouponNotFound
	}

	coupon.UpdatedAt = time.Now().UTC()
	cp := *coupon
	s.coupons[key] = &cp
	return nil
}

func (s *MemoryStore) DeleteCoupon(ctx context.Context, workspaceID, couponID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if workspaceID == "" {
		return ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", workspaceID, couponID)
	existing, ok := s.coupons[key]
	if !ok || existing.DeletedAt != nil {
		return ErrCouponNotFound
	}
	now := time.Now().UTC()
	existing.DeletedAt = &now
	return nil
}

// RedeemCouponAtomic is atomic with mutex protection guaranteeing that concurrent races cannot exceed max_uses.
func (s *MemoryStore) RedeemCouponAtomic(ctx context.Context, workspaceID, couponID, orderID string, discount tenantdb.ExactDecimal, currency string, now time.Time) (*CouponRedemption, *Coupon, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	if workspaceID == "" {
		return nil, nil, ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", workspaceID, couponID)
	coupon, ok := s.coupons[key]
	if !ok || coupon.DeletedAt != nil {
		return nil, nil, ErrCouponNotFound
	}

	// 1. Verify active state
	if coupon.LifecycleState == CouponStateRevoked {
		return nil, nil, ErrCouponRevoked
	}
	if coupon.LifecycleState == CouponStateExpired {
		return nil, nil, ErrCouponExpired
	}
	if coupon.LifecycleState != CouponStateActive {
		return nil, nil, ErrCouponNotActive
	}

	// 2. Verify effective window
	if coupon.ValidFrom != nil && !coupon.ValidFrom.IsZero() && now.Before(*coupon.ValidFrom) {
		return nil, nil, ErrCouponNotActive
	}
	if coupon.ValidUntil != nil && !coupon.ValidUntil.IsZero() && now.After(*coupon.ValidUntil) {
		coupon.LifecycleState = CouponStateExpired
		coupon.UpdatedAt = now
		return nil, nil, ErrCouponExpired
	}

	// 3. Verify max_uses limit (RACE PROTECTION)
	if coupon.MaxUses != nil {
		if coupon.CurrentUses >= *coupon.MaxUses {
			coupon.LifecycleState = CouponStateExpired
			coupon.UpdatedAt = now
			return nil, nil, ErrCouponLimitExceeded
		}
	}

	// 4. Atomically increment uses
	coupon.CurrentUses++
	if coupon.MaxUses != nil && coupon.CurrentUses >= *coupon.MaxUses {
		// Ceiled: transition to expired per RULE-M14-003
		coupon.LifecycleState = CouponStateExpired
	}
	coupon.UpdatedAt = now

	// 5. Record redemption
	redemption := &CouponRedemption{
		RedemptionID:   newUUID(),
		WorkspaceID:    workspaceID,
		CouponID:       couponID,
		OrderID:        orderID,
		DiscountAmount: discount,
		Currency:       currency,
		RedeemedAt:     now,
		Metadata:       make(map[string]any),
	}
	rKey := fmt.Sprintf("%s:%s", workspaceID, redemption.RedemptionID)
	rCp := *redemption
	s.redemptions[rKey] = &rCp

	updatedCoupon := *coupon
	return redemption, &updatedCoupon, nil
}

func (s *MemoryStore) CreateCampaign(ctx context.Context, campaign *Campaign) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if campaign.WorkspaceID == "" {
		return ErrMissingTenant
	}
	if campaign.CampaignID == "" {
		campaign.CampaignID = newUUID()
	}
	now := time.Now().UTC()
	campaign.CreatedAt = now
	campaign.UpdatedAt = now

	key := fmt.Sprintf("%s:%s", campaign.WorkspaceID, campaign.CampaignID)
	cp := *campaign
	s.campaigns[key] = &cp
	return nil
}

func (s *MemoryStore) GetCampaign(ctx context.Context, workspaceID, campaignID string) (*Campaign, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", workspaceID, campaignID)
	campaign, ok := s.campaigns[key]
	if !ok || campaign.DeletedAt != nil {
		return nil, ErrCampaignNotFound
	}
	cp := *campaign
	return &cp, nil
}

func (s *MemoryStore) ListCampaigns(ctx context.Context, workspaceID string, filter CampaignFilter) ([]*Campaign, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if workspaceID == "" {
		return nil, 0, ErrMissingTenant
	}

	var results []*Campaign
	for _, c := range s.campaigns {
		if c.WorkspaceID != workspaceID || c.DeletedAt != nil {
			continue
		}
		if filter.Status != nil && c.Status != *filter.Status {
			continue
		}
		if filter.CampaignType != nil && c.CampaignType != *filter.CampaignType {
			continue
		}
		if filter.Query != "" && !strings.Contains(strings.ToLower(c.Title), strings.ToLower(filter.Query)) {
			continue
		}
		cp := *c
		results = append(results, &cp)
	}

	return results, len(results), nil
}

func (s *MemoryStore) UpdateCampaign(ctx context.Context, campaign *Campaign) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if campaign.WorkspaceID == "" {
		return ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", campaign.WorkspaceID, campaign.CampaignID)
	existing, ok := s.campaigns[key]
	if !ok || existing.DeletedAt != nil {
		return ErrCampaignNotFound
	}

	campaign.UpdatedAt = time.Now().UTC()
	cp := *campaign
	s.campaigns[key] = &cp
	return nil
}

func (s *MemoryStore) DeleteCampaign(ctx context.Context, workspaceID, campaignID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if workspaceID == "" {
		return ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", workspaceID, campaignID)
	existing, ok := s.campaigns[key]
	if !ok || existing.DeletedAt != nil {
		return ErrCampaignNotFound
	}
	now := time.Now().UTC()
	existing.DeletedAt = &now
	return nil
}

func (s *MemoryStore) AddCampaignCost(ctx context.Context, cost *CampaignCostItem) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if cost.WorkspaceID == "" {
		return ErrMissingTenant
	}
	if cost.CostItemID == "" {
		cost.CostItemID = newUUID()
	}
	cost.CreatedAt = time.Now().UTC()

	key := fmt.Sprintf("%s:%s", cost.WorkspaceID, cost.CampaignID)
	cp := *cost
	s.costs[key] = append(s.costs[key], &cp)
	return nil
}

func (s *MemoryStore) GetCampaignCosts(ctx context.Context, workspaceID, campaignID string) ([]*CampaignCostItem, tenantdb.ExactDecimal, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if workspaceID == "" {
		return nil, tenantdb.ZeroDecimal(), ErrMissingTenant
	}
	key := fmt.Sprintf("%s:%s", workspaceID, campaignID)
	items := s.costs[key]

	total := tenantdb.ZeroDecimal()
	var results []*CampaignCostItem
	for _, item := range items {
		var addErr error
		total, addErr = total.Add(item.Amount)
		if addErr != nil {
			return nil, tenantdb.ZeroDecimal(), addErr
		}
		cp := *item
		results = append(results, &cp)
	}

	return results, total, nil
}

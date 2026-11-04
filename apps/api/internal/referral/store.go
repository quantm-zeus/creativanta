package referral

import (
	"context"
	"fmt"
	"sync"
	"time"
)

// Store defines persistence operations for referral programs, funnels, promos, and growth prompts.
type Store interface {
	GetReferralByID(ctx context.Context, workspaceID, referralID string) (*ReferralRecord, error)
	GetReferralRecord(ctx context.Context, referralID string) (*ReferralRecord, error)
	GetReferralByReferee(ctx context.Context, refereeUserID string) (*ReferralRecord, error)
	ListReferrals(ctx context.Context, workspaceID, statusFilter string, limit, offset int) ([]*ReferralRecord, int, error)
	SaveReferral(ctx context.Context, record *ReferralRecord) error

	RecordEvent(ctx context.Context, event *ReferralEvent) error
	GetEventsByWorkspace(ctx context.Context, workspaceID string) ([]*ReferralEvent, error)
	GetFunnel(ctx context.Context, workspaceID string) (*ReferralFunnel, error)

	GetCampaignByCode(ctx context.Context, code string) (*PromotionalCampaign, error)
	GetCampaignByID(ctx context.Context, campaignID string) (*PromotionalCampaign, error)
	SaveCampaign(ctx context.Context, campaign *PromotionalCampaign) error
	ListActiveCampaigns(ctx context.Context) ([]*PromotionalCampaign, error)
	RecordPromoRedemption(ctx context.Context, redemption *PromotionalRedemption) error
	HasRedeemed(ctx context.Context, workspaceID, campaignID string) (bool, error)

	ListGrowthPrompts(ctx context.Context, workspaceID, userID string) ([]*GrowthPrompt, error)
	SaveGrowthPrompt(ctx context.Context, prompt *GrowthPrompt) error
	CompleteGrowthPrompt(ctx context.Context, workspaceID, promptID string) (*GrowthPrompt, error)

	GetWorkspaceReferralCode(ctx context.Context, workspaceID string) (string, error)
	SetWorkspaceReferralCode(ctx context.Context, workspaceID, code string) error

	EmitEvent(ctx context.Context, event *DomainEvent) error
	GetEmittedEvents() []*DomainEvent
}

// MemoryStore provides a high-performance in-memory Store with full concurrency safety and tenant isolation.
type MemoryStore struct {
	mu sync.RWMutex

	referrals        map[string]*ReferralRecord        // referralID -> record
	workspaceCodes   map[string]string                 // workspaceID -> referralCode
	codeToWorkspace  map[string]string                 // referralCode -> workspaceID
	refereeIndex     map[string]string                 // refereeUserID -> referralID
	events           map[string][]*ReferralEvent       // workspaceID -> events
	campaigns        map[string]*PromotionalCampaign   // campaignID -> campaign
	campaignsByCode  map[string]string                 // code -> campaignID
	redemptions      map[string]*PromotionalRedemption // redemptionID -> redemption
	redemptionsIndex map[string]bool                   // workspaceID:campaignID -> true
	growthPrompts    map[string]*GrowthPrompt          // promptID -> prompt
	emittedEvents    []*DomainEvent
}

// NewMemoryStore initializes a fresh MemoryStore with standard default campaigns.
func NewMemoryStore() *MemoryStore {
	s := &MemoryStore{
		referrals:        make(map[string]*ReferralRecord),
		workspaceCodes:   make(map[string]string),
		codeToWorkspace:  make(map[string]string),
		refereeIndex:     make(map[string]string),
		events:           make(map[string][]*ReferralEvent),
		campaigns:        make(map[string]*PromotionalCampaign),
		campaignsByCode:  make(map[string]string),
		redemptions:      make(map[string]*PromotionalRedemption),
		redemptionsIndex: make(map[string]bool),
		growthPrompts:    make(map[string]*GrowthPrompt),
		emittedEvents:    make([]*DomainEvent, 0),
	}

	// Seed default promotional campaigns (referral_growth.md §6)
	welcomeCampaign := &PromotionalCampaign{
		CampaignID:         "cmp-welcome-2026",
		Code:               "WELCOME2026",
		Title:              "Welcome Creator Bonus",
		Description:        "Get 50 bonus credits on joining Creativanta",
		CreditBonus:        "50.000000",
		MaxRedemptions:     5000,
		CurrentRedemptions: 0,
		TierEligibility:    []string{"free", "starter", "pro", "business"},
		ExpiresAt:          time.Now().UTC().Add(365 * 24 * time.Hour),
		IsActive:           true,
		CreatedAt:          time.Now().UTC(),
	}
	s.campaigns[welcomeCampaign.CampaignID] = welcomeCampaign
	s.campaignsByCode[welcomeCampaign.Code] = welcomeCampaign.CampaignID

	proTryCampaign := &PromotionalCampaign{
		CampaignID:         "cmp-pro-boost",
		Code:               "PROBOOST100",
		Title:              "Pro Video Sprint Boost",
		Description:        "100 bonus credits for Pro video automation",
		CreditBonus:        "100.000000",
		MaxRedemptions:     1000,
		CurrentRedemptions: 0,
		TierEligibility:    []string{"starter", "pro", "business"},
		ExpiresAt:          time.Now().UTC().Add(90 * 24 * time.Hour),
		IsActive:           true,
		CreatedAt:          time.Now().UTC(),
	}
	s.campaigns[proTryCampaign.CampaignID] = proTryCampaign
	s.campaignsByCode[proTryCampaign.Code] = proTryCampaign.CampaignID

	return s
}

func (s *MemoryStore) GetReferralByID(ctx context.Context, workspaceID, referralID string) (*ReferralRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	rec, exists := s.referrals[referralID]
	if !exists {
		return nil, ErrReferralNotFound
	}
	if workspaceID != "" && rec.WorkspaceID != workspaceID && rec.RefereeWorkspaceID != workspaceID {
		return nil, ErrReferralNotFound
	}
	copy := *rec
	return &copy, nil
}

func (s *MemoryStore) GetReferralRecord(ctx context.Context, referralID string) (*ReferralRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	rec, exists := s.referrals[referralID]
	if !exists {
		return nil, ErrReferralNotFound
	}
	copy := *rec
	return &copy, nil
}

func (s *MemoryStore) GetReferralByReferee(ctx context.Context, refereeUserID string) (*ReferralRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	refID, exists := s.refereeIndex[refereeUserID]
	if !exists {
		return nil, ErrReferralNotFound
	}
	rec, exists := s.referrals[refID]
	if !exists {
		return nil, ErrReferralNotFound
	}
	copy := *rec
	return &copy, nil
}

func (s *MemoryStore) ListReferrals(ctx context.Context, workspaceID, statusFilter string, limit, offset int) ([]*ReferralRecord, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matching []*ReferralRecord
	for _, rec := range s.referrals {
		if rec.WorkspaceID != workspaceID {
			continue
		}
		if statusFilter != "" && rec.Status != statusFilter {
			continue
		}
		copy := *rec
		matching = append(matching, &copy)
	}

	total := len(matching)
	if offset > total {
		return []*ReferralRecord{}, total, nil
	}
	end := offset + limit
	if end > total || limit <= 0 {
		end = total
	}
	return matching[offset:end], total, nil
}

func (s *MemoryStore) SaveReferral(ctx context.Context, record *ReferralRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	copy := *record
	s.referrals[record.ReferralID] = &copy
	if record.RefereeUserID != "" {
		s.refereeIndex[record.RefereeUserID] = record.ReferralID
	}
	return nil
}

func (s *MemoryStore) RecordEvent(ctx context.Context, event *ReferralEvent) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	copy := *event
	s.events[event.WorkspaceID] = append(s.events[event.WorkspaceID], &copy)
	return nil
}

func (s *MemoryStore) GetEventsByWorkspace(ctx context.Context, workspaceID string) ([]*ReferralEvent, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	events := s.events[workspaceID]
	res := make([]*ReferralEvent, len(events))
	for i, e := range events {
		copy := *e
		res[i] = &copy
	}
	return res, nil
}

func (s *MemoryStore) GetFunnel(ctx context.Context, workspaceID string) (*ReferralFunnel, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var clicks int64
	for _, ev := range s.events[workspaceID] {
		if ev.EventType == "click" {
			clicks++
		}
	}

	var signups, paid int64
	var totalEarned, totalPending float64

	for _, rec := range s.referrals {
		if rec.WorkspaceID != workspaceID {
			continue
		}
		signups++
		if rec.PaymentStatus == "paid" || rec.Status == StatusQualified || rec.Status == StatusRewarded {
			paid++
		}
		var earned float64
		fmt.Sscanf(rec.ReferrerCreditsAwarded, "%f", &earned)
		totalEarned += earned

		if rec.Status == StatusPending {
			// Projected pending credits based on plan tier
			switch rec.PlanTier {
			case "starter":
				totalPending += 100
			case "pro":
				totalPending += 300
			case "business":
				totalPending += 1000
			default:
				totalPending += 50
			}
		}
	}

	var clickToSignup, signupToPaid float64
	if clicks > 0 {
		clickToSignup = float64(signups) / float64(clicks)
	}
	if signups > 0 {
		signupToPaid = float64(paid) / float64(signups)
	}

	return &ReferralFunnel{
		TotalClicks:         clicks,
		TotalSignups:        signups,
		TotalPaid:           paid,
		ClickToSignupRate:   clickToSignup,
		SignupToPaidRate:    signupToPaid,
		CreditsEarnedTotal:  fmt.Sprintf("%.6f", totalEarned),
		CreditsPendingTotal: fmt.Sprintf("%.6f", totalPending),
	}, nil
}

func (s *MemoryStore) GetCampaignByCode(ctx context.Context, code string) (*PromotionalCampaign, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	id, exists := s.campaignsByCode[code]
	if !exists {
		return nil, ErrCampaignNotFound
	}
	cmp := s.campaigns[id]
	copy := *cmp
	return &copy, nil
}

func (s *MemoryStore) GetCampaignByID(ctx context.Context, campaignID string) (*PromotionalCampaign, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	cmp, exists := s.campaigns[campaignID]
	if !exists {
		return nil, ErrCampaignNotFound
	}
	copy := *cmp
	return &copy, nil
}

func (s *MemoryStore) SaveCampaign(ctx context.Context, campaign *PromotionalCampaign) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	copy := *campaign
	s.campaigns[campaign.CampaignID] = &copy
	s.campaignsByCode[campaign.Code] = campaign.CampaignID
	return nil
}

func (s *MemoryStore) ListActiveCampaigns(ctx context.Context) ([]*PromotionalCampaign, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	now := time.Now().UTC()
	var list []*PromotionalCampaign
	for _, c := range s.campaigns {
		if c.IsActive && (c.ExpiresAt.IsZero() || c.ExpiresAt.After(now)) && c.CurrentRedemptions < c.MaxRedemptions {
			copy := *c
			list = append(list, &copy)
		}
	}
	return list, nil
}

func (s *MemoryStore) RecordPromoRedemption(ctx context.Context, redemption *PromotionalRedemption) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := fmt.Sprintf("%s:%s", redemption.WorkspaceID, redemption.CampaignID)
	if s.redemptionsIndex[key] {
		return ErrAlreadyRedeemed
	}

	copy := *redemption
	s.redemptions[redemption.RedemptionID] = &copy
	s.redemptionsIndex[key] = true

	if cmp, ok := s.campaigns[redemption.CampaignID]; ok {
		cmp.CurrentRedemptions++
	}
	return nil
}

func (s *MemoryStore) HasRedeemed(ctx context.Context, workspaceID, campaignID string) (bool, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	key := fmt.Sprintf("%s:%s", workspaceID, campaignID)
	return s.redemptionsIndex[key], nil
}

func (s *MemoryStore) ListGrowthPrompts(ctx context.Context, workspaceID, userID string) ([]*GrowthPrompt, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var prompts []*GrowthPrompt
	for _, p := range s.growthPrompts {
		if p.WorkspaceID == workspaceID && (userID == "" || p.UserID == userID) {
			copy := *p
			prompts = append(prompts, &copy)
		}
	}
	return prompts, nil
}

func (s *MemoryStore) SaveGrowthPrompt(ctx context.Context, prompt *GrowthPrompt) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	copy := *prompt
	s.growthPrompts[prompt.PromptID] = &copy
	return nil
}

func (s *MemoryStore) CompleteGrowthPrompt(ctx context.Context, workspaceID, promptID string) (*GrowthPrompt, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	p, exists := s.growthPrompts[promptID]
	if !exists || p.WorkspaceID != workspaceID {
		return nil, ErrPromptNotFound
	}
	now := time.Now().UTC()
	p.Status = "completed"
	p.CompletedAt = &now
	copy := *p
	return &copy, nil
}

func (s *MemoryStore) GetWorkspaceReferralCode(ctx context.Context, workspaceID string) (string, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	code, exists := s.workspaceCodes[workspaceID]
	if !exists {
		return "", nil
	}
	return code, nil
}

func (s *MemoryStore) SetWorkspaceReferralCode(ctx context.Context, workspaceID, code string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	s.workspaceCodes[workspaceID] = code
	s.codeToWorkspace[code] = workspaceID
	return nil
}

func (s *MemoryStore) EmitEvent(ctx context.Context, event *DomainEvent) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	s.emittedEvents = append(s.emittedEvents, event)
	return nil
}

func (s *MemoryStore) GetEmittedEvents() []*DomainEvent {
	s.mu.RLock()
	defer s.mu.RUnlock()

	res := make([]*DomainEvent, len(s.emittedEvents))
	for i, e := range s.emittedEvents {
		copy := *e
		res[i] = &copy
	}
	return res
}

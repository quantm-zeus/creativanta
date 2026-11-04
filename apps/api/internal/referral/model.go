package referral

import (
	"errors"
	"time"
)

// Canonical referral record statuses per docs/02_features/platform/referral_growth.md §5.
const (
	StatusPending      = "pending"
	StatusQualified    = "qualified"
	StatusRewarded     = "rewarded"
	StatusRevoked      = "revoked"
	StatusExpired      = "expired"
	StatusFraudFlagged = "fraud_flagged"
	StatusForfeited    = "forfeited"
)

// Canonical referral tiers per docs/02_features/platform/referral_growth.md §4.2.
const (
	TierBronze   = "bronze"   // 1–5 referrals: 1.0x
	TierSilver   = "silver"   // 6–20 referrals: 1.5x
	TierGold     = "gold"     // 21–50 referrals: 2.0x + 10% recurring
	TierPlatinum = "platinum" // 51+ referrals: 2.5x + 15% recurring
)

// Canonical growth trigger points per docs/02_features/platform/referral_growth.md §3.4.
const (
	TriggerFirstPublish      = "first_publish"
	TriggerFirstProfit       = "first_profit_proof"
	TriggerFollowerMilestone = "followers_1000"
	TriggerTeamInvite        = "team_invite"
	TriggerRecipeSubmit      = "recipe_submit"
	TriggerFeatureUpvote     = "feature_upvote"
)

// Canonical domain event names per docs/04_contracts/domain_event_catalog.md.
const (
	EventReferralQualified     = "referral.qualified"
	EventReferralRewarded      = "referral.rewarded"
	EventReferralFraudDetected = "referral.fraud_detected"
)

// Anti-fraud signal keys.
const (
	SignalSelfReferralSameUser      = "self_referral_same_user"
	SignalSelfReferralSameWorkspace = "self_referral_same_workspace"
	SignalSelfReferralSameIP        = "self_referral_same_ip"
	SignalSelfReferralSameDevice    = "self_referral_same_device"
	SignalSelfReferralSameCard      = "self_referral_same_card"
	SignalIPRangeClustering         = "ip_range_clustering"
	SignalScriptedSignup            = "scripted_signup"
)

// Business rule error codes.
var (
	ErrReferralNotFound      = errors.New("REFERRAL_NOT_FOUND: referral record not found")
	ErrInvalidReferralCode   = errors.New("REFERRAL_INVALID_CODE: referral code is invalid or expired")
	ErrFraudFlagged          = errors.New("REFERRAL_FRAUD_FLAGGED: referral flagged for fraud review")
	ErrPaymentPending        = errors.New("REFERRAL_PAYMENT_PENDING: cannot qualify reward while payment is pending")
	ErrQualificationNotMet   = errors.New("REFERRAL_QUALIFICATION_NOT_MET: qualification criteria not yet satisfied")
	ErrAlreadyRewarded       = errors.New("REFERRAL_ALREADY_REWARDED: referral already rewarded")
	ErrAlreadyRevoked        = errors.New("REFERRAL_ALREADY_REVOKED: referral reward already revoked")
	ErrCampaignNotFound      = errors.New("PROMO_CAMPAIGN_NOT_FOUND: promotional campaign not found")
	ErrCampaignExpired       = errors.New("PROMO_CAMPAIGN_EXPIRED: promotional campaign expired")
	ErrCampaignExhausted     = errors.New("PROMO_CAMPAIGN_EXHAUSTED: promotional redemptions exhausted")
	ErrAlreadyRedeemed       = errors.New("PROMO_ALREADY_REDEEMED: promo campaign already redeemed by workspace")
	ErrPromptNotFound        = errors.New("GROWTH_PROMPT_NOT_FOUND: growth prompt not found")
	ErrSelfReferralForbidden = errors.New("REFERRAL_SELF_FORBIDDEN: self-referral detected and held for review")
)

// Reward credit schedule definitions (exact decimal strings, no floats).
const (
	CreditsFreeSignupReferrer = "20.000000"
	CreditsFreeSignupReferee  = "20.000000"

	CreditsStarterReferrerBase = "100.000000"
	CreditsStarterReferee      = "50.000000"

	CreditsProReferrerBase = "300.000000"
	CreditsProReferee      = "100.000000"

	CreditsBusinessReferrerBase = "1000.000000"
	CreditsBusinessReferee      = "300.000000"

	CreditsMonth1ReferrerBase = "50.000000"

	// Prompt incentives
	CreditsPromptFirstPublish  = "20.000000"
	CreditsPromptFirstProfit   = "50.000000"
	CreditsPromptFollowers1000 = "30.000000"
	CreditsPromptTeamInvite    = "10.000000"
	CreditsPromptRecipeSubmit  = "50.000000"
	CreditsPromptFeatureUpvote = "5.000000"
)

// ReferralRecord represents a persisted referral row in referral_records (§18.6).
type ReferralRecord struct {
	ReferralID                string     `json:"referral_id"`
	WorkspaceID               string     `json:"workspace_id"`
	RefereeWorkspaceID        string     `json:"referee_workspace_id"`
	ReferrerUserID            string     `json:"referrer_user_id"`
	RefereeUserID             string     `json:"referee_user_id"`
	RefereeName               string     `json:"referee_name"`
	RefereeEmailMasked        string     `json:"referee_email_masked"`
	ReferralCode              string     `json:"referral_code"`
	Status                    string     `json:"status"` // pending, qualified, rewarded, revoked, expired, fraud_flagged, forfeited
	ReferrerCreditsAwarded    string     `json:"referrer_credits_awarded"`
	RefereeCreditsAwarded     string     `json:"referee_credits_awarded"`
	PlanTier                  string     `json:"plan_tier"`      // free, starter, pro, business
	PaymentStatus             string     `json:"payment_status"` // unpaid, pending, paid, refunded
	FraudCheckPassed          *bool      `json:"fraud_check_passed"`
	FraudReason               string     `json:"fraud_reason"`
	FraudSignals              []string   `json:"fraud_signals"`
	RecurringCommissionRate   string     `json:"recurring_commission_rate"`
	RecurringCommissionEarned string     `json:"recurring_commission_earned"`
	ReversalTransactionID     string     `json:"reversal_transaction_id"`
	ReversedAt                *time.Time `json:"reversed_at"`
	QualifiedAt               *time.Time `json:"qualified_at"`
	RewardedAt                *time.Time `json:"rewarded_at"`
	CreatedAt                 time.Time  `json:"created_at"`
	UpdatedAt                 time.Time  `json:"updated_at"`
}

// FraudContext carries inbound client and network metadata for fraud evaluation.
type FraudContext struct {
	IPAddress         string
	DeviceFingerprint string
	CardFingerprint   string
	IsBot             bool
}

// ReferralEvent tracks funnel occurrences.
type ReferralEvent struct {
	EventID      string                 `json:"event_id"`
	WorkspaceID  string                 `json:"workspace_id"`
	ReferralCode string                 `json:"referral_code"`
	EventType    string                 `json:"event_type"` // click, signup, paid_convert, reminder_sent
	IPHash       string                 `json:"ip_hash"`
	Metadata     map[string]interface{} `json:"metadata"`
	CreatedAt    time.Time              `json:"created_at"`
}

// PromotionalCampaign represents time-limited credit promo codes.
type PromotionalCampaign struct {
	CampaignID         string    `json:"campaign_id"`
	Code               string    `json:"code"`
	Title              string    `json:"title"`
	Description        string    `json:"description"`
	CreditBonus        string    `json:"credit_bonus"`
	MaxRedemptions     int       `json:"max_redemptions"`
	CurrentRedemptions int       `json:"current_redemptions"`
	TierEligibility    []string  `json:"tier_eligibility"`
	ExpiresAt          time.Time `json:"expires_at"`
	IsActive           bool      `json:"is_active"`
	CreatedAt          time.Time `json:"created_at"`
}

// PromotionalRedemption logs an applied promo code per workspace.
type PromotionalRedemption struct {
	RedemptionID   string    `json:"redemption_id"`
	WorkspaceID    string    `json:"workspace_id"`
	UserID         string    `json:"user_id"`
	CampaignID     string    `json:"campaign_id"`
	CreditsAwarded string    `json:"credits_awarded"`
	CreatedAt      time.Time `json:"created_at"`
}

// GrowthPrompt represents in-product viral loop triggers.
type GrowthPrompt struct {
	PromptID      string     `json:"prompt_id"`
	WorkspaceID   string     `json:"workspace_id"`
	UserID        string     `json:"user_id"`
	TriggerPoint  string     `json:"trigger_point"`
	Status        string     `json:"status"` // active, completed, dismissed
	CreditsReward string     `json:"credits_reward"`
	CreatedAt     time.Time  `json:"created_at"`
	CompletedAt   *time.Time `json:"completed_at"`
}

// ReferralFunnel contains aggregate growth metrics.
type ReferralFunnel struct {
	TotalClicks         int64   `json:"total_clicks"`
	TotalSignups        int64   `json:"total_signups"`
	TotalPaid           int64   `json:"total_paid"`
	ClickToSignupRate   float64 `json:"click_to_signup_rate"`
	SignupToPaidRate    float64 `json:"signup_to_paid_rate"`
	CreditsEarnedTotal  string  `json:"credits_earned_total"`
	CreditsPendingTotal string  `json:"credits_pending_total"`
}

// TierProgress represents tier status, multipliers, and progress towards next tier.
type TierProgress struct {
	CurrentTier             string  `json:"current_tier"`
	NextTier                string  `json:"next_tier"`
	QualifiedReferralsCount int     `json:"qualified_referrals_count"`
	ReferralsToNextTier     int     `json:"referrals_to_next_tier"`
	ProgressPercentage      float64 `json:"progress_percentage"`
	RewardMultiplier        string  `json:"reward_multiplier"`
	RecurringCommissionRate string  `json:"recurring_commission_rate"`
}

// DomainEvent carries emitted events for notification/audit queues.
type DomainEvent struct {
	EventID     string                 `json:"event_id"`
	EventType   string                 `json:"event_type"`
	WorkspaceID string                 `json:"workspace_id"`
	Payload     map[string]interface{} `json:"payload"`
	OccurredAt  time.Time              `json:"occurred_at"`
}

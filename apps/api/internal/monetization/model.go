package monetization

import (
	"crypto/rand"
	"fmt"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func newUUID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

type OfferType string

const (
	OfferTypeProductOffer    OfferType = "product_offer"
	OfferTypeDigitalOffer    OfferType = "digital_offer"
	OfferTypeMembershipOffer OfferType = "membership_offer"
	OfferTypeBundleOffer     OfferType = "bundle_offer"
	OfferTypeAffiliateOffer  OfferType = "affiliate_offer"
	OfferTypeSponsorOffer    OfferType = "sponsor_offer"
)

type OfferLifecycleState string

const (
	OfferStateDraft          OfferLifecycleState = "draft"
	OfferStateReviewRequired OfferLifecycleState = "review_required"
	OfferStateActive         OfferLifecycleState = "active"
	OfferStatePaused         OfferLifecycleState = "paused"
	OfferStateExpired        OfferLifecycleState = "expired"
	OfferStateRetired        OfferLifecycleState = "retired"
)

type ChannelAvailability struct {
	Platform string `json:"platform"`
	Enabled  bool   `json:"enabled"`
}

// Offer represents a commercial offer in M14 (DB §10.2).
type Offer struct {
	OfferID                string                `json:"offer_id"`
	WorkspaceID            string                `json:"workspace_id"`
	OfferType              OfferType             `json:"offer_type"`
	ProductID              *string               `json:"product_id,omitempty"`
	ProductLessDeclaration string                `json:"product_less_declaration,omitempty"`
	Title                  string                `json:"title"`
	PricingValue           tenantdb.ExactDecimal `json:"pricing_value"`
	PricingCurrency        string                `json:"pricing_currency"`
	PricingLogic           map[string]any        `json:"pricing_logic"`
	CtaText                string                `json:"cta_text"`
	CtaURL                 string                `json:"cta_url"`
	ChannelAvailability    []ChannelAvailability `json:"channel_availability"`
	LifecycleState         OfferLifecycleState   `json:"lifecycle_state"`
	CampaignIDs            []string              `json:"campaign_ids"`
	Metadata               map[string]any        `json:"metadata"`
	ValidFrom              *time.Time            `json:"valid_from,omitempty"`
	ValidUntil             *time.Time            `json:"valid_until,omitempty"`
	CreatedAt              time.Time             `json:"created_at"`
	UpdatedAt              time.Time             `json:"updated_at"`
	DeletedAt              *time.Time            `json:"deleted_at,omitempty"`
}

// IsExpired checks if the offer is in expired state or past its valid_until time.
func (o *Offer) IsExpired(at time.Time) bool {
	if o.LifecycleState == OfferStateExpired || o.LifecycleState == OfferStateRetired {
		return true
	}
	if o.ValidUntil != nil && !o.ValidUntil.IsZero() && at.After(*o.ValidUntil) {
		return true
	}
	return false
}

type CouponType string

const (
	CouponTypePercentage   CouponType = "percentage"
	CouponTypeFixedAmount  CouponType = "fixed_amount"
	CouponTypeFreeShipping CouponType = "free_shipping"
)

type CouponLifecycleState string

const (
	CouponStateDraft   CouponLifecycleState = "draft"
	CouponStateActive  CouponLifecycleState = "active"
	CouponStatePaused  CouponLifecycleState = "paused"
	CouponStateExpired CouponLifecycleState = "expired"
	CouponStateRetired CouponLifecycleState = "retired"
	CouponStateRevoked CouponLifecycleState = "revoked"
)

// Coupon represents a discount coupon in M14 (DB §19.2).
type Coupon struct {
	CouponID           string                 `json:"coupon_id"`
	WorkspaceID        string                 `json:"workspace_id"`
	Code               string                 `json:"code"`
	CouponType         CouponType             `json:"coupon_type"`
	DiscountValue      tenantdb.ExactDecimal  `json:"discount_value"`
	MinOrderAmount     *tenantdb.ExactDecimal `json:"min_order_amount,omitempty"`
	MaxUses            *int                   `json:"max_uses,omitempty"`
	CurrentUses        int                    `json:"current_uses"`
	LifecycleState     CouponLifecycleState   `json:"lifecycle_state"`
	RelatedOfferIDs    []string               `json:"related_offer_ids"`
	RelatedCampaignIDs []string               `json:"related_campaign_ids"`
	ValidFrom          *time.Time             `json:"valid_from,omitempty"`
	ValidUntil         *time.Time             `json:"valid_until,omitempty"`
	CreatedAt          time.Time              `json:"created_at"`
	UpdatedAt          time.Time              `json:"updated_at"`
	DeletedAt          *time.Time             `json:"deleted_at,omitempty"`
}

// IsExpired checks if coupon is expired or exceeded uses.
func (c *Coupon) IsExpired(at time.Time) bool {
	if c.LifecycleState == CouponStateExpired || c.LifecycleState == CouponStateRetired || c.LifecycleState == CouponStateRevoked {
		return true
	}
	if c.MaxUses != nil && c.CurrentUses >= *c.MaxUses {
		return true
	}
	if c.ValidUntil != nil && !c.ValidUntil.IsZero() && at.After(*c.ValidUntil) {
		return true
	}
	return false
}

// CouponRedemption represents an immutable redemption of a coupon linked to an order.
type CouponRedemption struct {
	RedemptionID   string                `json:"redemption_id"`
	WorkspaceID    string                `json:"workspace_id"`
	CouponID       string                `json:"coupon_id"`
	OrderID        string                `json:"order_id"`
	DiscountAmount tenantdb.ExactDecimal `json:"discount_amount"`
	Currency       string                `json:"currency"`
	RedeemedAt     time.Time             `json:"redeemed_at"`
	Metadata       map[string]any        `json:"metadata"`
}

type CampaignType string

const (
	CampaignTypeContent     CampaignType = "content"
	CampaignTypeAffiliate   CampaignType = "affiliate"
	CampaignTypeSeeding     CampaignType = "seeding"
	CampaignTypeLive        CampaignType = "live"
	CampaignTypeBrandCollab CampaignType = "brand_collab"
)

type CampaignStatus string

const (
	CampaignStatusPlanned   CampaignStatus = "planned"
	CampaignStatusReady     CampaignStatus = "ready"
	CampaignStatusLive      CampaignStatus = "live"
	CampaignStatusPaused    CampaignStatus = "paused"
	CampaignStatusCompleted CampaignStatus = "completed"
	CampaignStatusCancelled CampaignStatus = "cancelled"
)

// Campaign represents a coordination campaign in M14 (DB §10.5).
type Campaign struct {
	CampaignID        string                 `json:"campaign_id"`
	WorkspaceID       string                 `json:"workspace_id"`
	CampaignType      CampaignType           `json:"campaign_type"`
	Title             string                 `json:"title"`
	Objective         string                 `json:"objective"`
	Status            CampaignStatus         `json:"status"`
	StartDate         *string                `json:"start_date,omitempty"` // YYYY-MM-DD
	EndDate           *string                `json:"end_date,omitempty"`   // YYYY-MM-DD
	Budget            *tenantdb.ExactDecimal `json:"budget,omitempty"`
	BudgetCurrency    string                 `json:"budget_currency"`
	RelatedProductIDs []string               `json:"related_product_ids"`
	RelatedOfferIDs   []string               `json:"related_offer_ids"`
	Metadata          map[string]any         `json:"metadata"`
	CreatedAt         time.Time              `json:"created_at"`
	UpdatedAt         time.Time              `json:"updated_at"`
	DeletedAt         *time.Time             `json:"deleted_at,omitempty"`
}

// CampaignCostItem tracks expenses attributable to a campaign (M19 ledger connection).
type CampaignCostItem struct {
	CostItemID    string                `json:"cost_item_id"`
	WorkspaceID   string                `json:"workspace_id"`
	CampaignID    string                `json:"campaign_id"`
	CostType      string                `json:"cost_type"` // ads_spend, creator_payout, shipping, production, other
	Amount        tenantdb.ExactDecimal `json:"amount"`
	Currency      string                `json:"currency"`
	Description   string                `json:"description"`
	EffectiveDate string                `json:"effective_date"`
	CreatedAt     time.Time             `json:"created_at"`
}

// CheckoutEvaluation contains evaluation of an order with offers and coupons.
type CheckoutEvaluation struct {
	Accepted            bool                  `json:"accepted"`
	ErrorCode           string                `json:"error_code,omitempty"`
	ErrorMessage        string                `json:"error_message,omitempty"`
	OriginalAmount      tenantdb.ExactDecimal `json:"original_amount"`
	DiscountAmount      tenantdb.ExactDecimal `json:"discount_amount"`
	NetPayableAmount    tenantdb.ExactDecimal `json:"net_payable_amount"`
	Currency            string                `json:"currency"`
	OrderID             string                `json:"order_id,omitempty"`
	PostingID           string                `json:"posting_id,omitempty"`
	CouponID            string                `json:"coupon_id,omitempty"`
	CouponRemainingUses int                   `json:"coupon_remaining_uses"`
}

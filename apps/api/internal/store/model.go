package store

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

// ----------------------------------------------------------------------------
// Enums & Lifecycle States
// ----------------------------------------------------------------------------

type StorePageStatus string

const (
	StorePageStatusDraft     StorePageStatus = "draft"
	StorePageStatusPublished StorePageStatus = "published"
	StorePageStatusHidden    StorePageStatus = "hidden"
	StorePageStatusRetired   StorePageStatus = "retired"
)

type MembershipPlanStatus string

const (
	MembershipPlanStatusDraft   MembershipPlanStatus = "draft"
	MembershipPlanStatusActive  MembershipPlanStatus = "active"
	MembershipPlanStatusHidden  MembershipPlanStatus = "hidden"
	MembershipPlanStatusPaused  MembershipPlanStatus = "paused"
	MembershipPlanStatusRetired MembershipPlanStatus = "retired"
)

type MembershipSubscriptionStatus string

const (
	MembershipSubscriptionStatusActive    MembershipSubscriptionStatus = "active"
	MembershipSubscriptionStatusCancelled MembershipSubscriptionStatus = "cancelled"
	MembershipSubscriptionStatusExpired   MembershipSubscriptionStatus = "expired"
)

type DeliveryType string

const (
	DeliveryTypeDownloadLink DeliveryType = "download_link"
	DeliveryTypeLicenseKey   DeliveryType = "license_key"
	DeliveryTypeAccessGrant  DeliveryType = "access_grant"
)

type DeliveryStatus string

const (
	DeliveryStatusPending   DeliveryStatus = "pending"
	DeliveryStatusDelivered DeliveryStatus = "delivered"
	DeliveryStatusRevoked   DeliveryStatus = "revoked"
)

// ----------------------------------------------------------------------------
// Domain Entities
// ----------------------------------------------------------------------------

type StorePage struct {
	StorePageID        string          `json:"store_page_id"`
	WorkspaceID        string          `json:"workspace_id"`
	Title              string          `json:"title"`
	Slug               string          `json:"slug"`
	Description        string          `json:"description"`
	LayoutJSON         map[string]any  `json:"layout_json"`
	ThemeOverridesJSON map[string]any  `json:"theme_overrides_json"`
	Status             StorePageStatus `json:"status"`
	CustomDomain       string          `json:"custom_domain"`
	SEOConfigJSON      map[string]any  `json:"seo_config_json"`
	WidgetConfigJSON   map[string]any  `json:"widget_config_json"`
	CreatedAt          time.Time       `json:"created_at"`
	UpdatedAt          time.Time       `json:"updated_at"`
	DeletedAt          *time.Time      `json:"deleted_at,omitempty"`
}

type StoreTheme struct {
	ThemeID      string `json:"theme_id"`
	Name         string `json:"name"`
	PrimaryColor string `json:"primary_color"`
	FontFamily   string `json:"font_family"`
	BorderRadius string `json:"border_radius"`
	IsDefault    bool   `json:"is_default"`
}

type PageStats struct {
	StorePageID    string                `json:"store_page_id"`
	Views          int64                 `json:"views"`
	Orders         int64                 `json:"orders"`
	ConversionRate float64               `json:"conversion_rate"`
	Revenue        tenantdb.ExactDecimal `json:"revenue"`
	Currency       string                `json:"currency"`
}

type MembershipPlan struct {
	PlanID                string                `json:"plan_id"`
	WorkspaceID           string                `json:"workspace_id"`
	Title                 string                `json:"title"`
	Description           string                `json:"description"`
	Price                 tenantdb.ExactDecimal `json:"price"`
	Currency              string                `json:"currency"`
	BillingInterval       string                `json:"billing_interval"` // monthly, quarterly, yearly
	BenefitsJSON          []map[string]any      `json:"benefits_json"`
	EntitlementConfigJSON map[string]any        `json:"entitlement_config_json"` // Store/audience entitlements ONLY, no SaaS workspace privileges
	Status                MembershipPlanStatus  `json:"status"`
	SubscriberCount       int32                 `json:"subscriber_count"`
	CreatedAt             time.Time             `json:"created_at"`
	UpdatedAt             time.Time             `json:"updated_at"`
	DeletedAt             *time.Time            `json:"deleted_at,omitempty"`
}

type MembershipSubscription struct {
	MembershipID            string                       `json:"membership_id"`
	WorkspaceID             string                       `json:"workspace_id"`
	PlanID                  string                       `json:"plan_id"`
	CustomerEntityID        string                       `json:"customer_entity_id"`
	Status                  MembershipSubscriptionStatus `json:"status"`
	ProviderSubscriptionID  string                       `json:"provider_subscription_id"`
	CurrentPeriodStart      time.Time                    `json:"current_period_start"`
	CurrentPeriodEnd        time.Time                    `json:"current_period_end"`
	EntitlementSnapshotJSON map[string]any               `json:"entitlement_snapshot_json"`
	CreatedAt               time.Time                    `json:"created_at"`
	UpdatedAt               time.Time                    `json:"updated_at"`
}

type BundleItem struct {
	BundleID       string `json:"bundle_id"`
	ProductID      string `json:"product_id"`
	Quantity       int32  `json:"quantity"`
	ProductTitle   string `json:"product_title"`
	AvailableStock int32  `json:"available_stock"`
}

type Bundle struct {
	BundleID          string                `json:"bundle_id"`
	WorkspaceID       string                `json:"workspace_id"`
	Title             string                `json:"title"`
	OfferID           string                `json:"offer_id"`
	BundlePrice       tenantdb.ExactDecimal `json:"bundle_price"`
	DiscountPct       float64               `json:"discount_pct"`
	Status            string                `json:"status"`
	Items             []BundleItem          `json:"items"`
	IsAvailable       bool                  `json:"is_available"`
	UnavailableReason string                `json:"unavailable_reason"`
	CreatedAt         time.Time             `json:"created_at"`
}

type DigitalDelivery struct {
	DeliveryID             string         `json:"delivery_id"`
	WorkspaceID            string         `json:"workspace_id"`
	OrderID                string         `json:"order_id"`
	CustomerEntityID       string         `json:"customer_entity_id"`
	ProductID              string         `json:"product_id"`
	OfferID                string         `json:"offer_id"`
	DeliveryType           DeliveryType   `json:"delivery_type"`
	EntitlementPayloadJSON map[string]any `json:"entitlement_payload_json"`
	Status                 DeliveryStatus `json:"status"`
	IdempotencyKey         string         `json:"idempotency_key"`
	DownloadCount          int32          `json:"download_count"`
	MaxDownloads           int32          `json:"max_downloads"`
	ExpiresAt              *time.Time     `json:"expires_at,omitempty"`
	CreatedAt              time.Time      `json:"created_at"`
}

type BuyerEntitlements struct {
	CustomerEntityID     string                   `json:"customer_entity_id"`
	WorkspaceID          string                   `json:"workspace_id"`
	AccessibleContentIDs []string                 `json:"accessible_content_ids"`
	DiscountPct          float64                  `json:"discount_pct"`
	HasPriorityDM        bool                     `json:"has_priority_dm"`
	Deliveries           []DigitalDelivery        `json:"deliveries"`
	ActiveSubscriptions  []MembershipSubscription `json:"active_subscriptions"`
}

// ----------------------------------------------------------------------------
// Events & Financial Postings
// ----------------------------------------------------------------------------

type OutboxEvent struct {
	EventID     string         `json:"event_id"`
	WorkspaceID string         `json:"workspace_id"`
	EventType   string         `json:"event_type"`
	AggregateID string         `json:"aggregate_id"`
	Payload     map[string]any `json:"payload"`
	CreatedAt   time.Time      `json:"created_at"`
}

type FinancialPosting struct {
	PostingID      string                `json:"posting_id"`
	WorkspaceID    string                `json:"workspace_id"`
	OrderID        string                `json:"order_id"`
	SourcePlatform string                `json:"source_platform"` // 'own_store' per RULE-M15-007
	GrossAmount    tenantdb.ExactDecimal `json:"gross_amount"`
	Currency       string                `json:"currency"`
	CreatedAt      time.Time             `json:"created_at"`
}

// ----------------------------------------------------------------------------
// Checkout & Operations DTOs
// ----------------------------------------------------------------------------

type CheckoutRequest struct {
	WorkspaceID      string                `json:"workspace_id"`
	CustomerEntityID string                `json:"customer_entity_id"`
	IdempotencyKey   string                `json:"idempotency_key"`
	PaymentIntentID  string                `json:"payment_intent_id"`
	OfferID          string                `json:"offer_id,omitempty"`
	BundleID         string                `json:"bundle_id,omitempty"`
	MembershipPlanID string                `json:"membership_plan_id,omitempty"`
	ProductIDs       []string              `json:"product_ids,omitempty"`
	OrderAmount      tenantdb.ExactDecimal `json:"order_amount"`
	Currency         string                `json:"currency"`
}

type CheckoutResult struct {
	Success      bool                    `json:"success"`
	OrderID      string                  `json:"order_id"`
	Status       string                  `json:"status"`
	Deliveries   []DigitalDelivery       `json:"deliveries"`
	Subscription *MembershipSubscription `json:"subscription,omitempty"`
	IsReplayed   bool                    `json:"is_replayed"`
}

package creatorpro

import (
	"crypto/rand"
	"fmt"
	"strings"
	"time"
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
// Canonical Enums
// ----------------------------------------------------------------------------

type BrandDealStatus string

const (
	BrandDealStatusNegotiating BrandDealStatus = "negotiating"
	BrandDealStatusAgreed      BrandDealStatus = "agreed"
	BrandDealStatusInProgress  BrandDealStatus = "in_progress"
	BrandDealStatusDelivered   BrandDealStatus = "delivered"
	BrandDealStatusPaid        BrandDealStatus = "paid"
	BrandDealStatusCompleted   BrandDealStatus = "completed"
	BrandDealStatusCancelled   BrandDealStatus = "cancelled"
)

// CanonicalDealLifecycleSequence defines canonical forward state progression.
var CanonicalDealLifecycleSequence = map[BrandDealStatus][]BrandDealStatus{
	BrandDealStatusNegotiating: {BrandDealStatusAgreed, BrandDealStatusCancelled},
	BrandDealStatusAgreed:      {BrandDealStatusInProgress, BrandDealStatusCancelled},
	BrandDealStatusInProgress:  {BrandDealStatusDelivered, BrandDealStatusCancelled},
	BrandDealStatusDelivered:   {BrandDealStatusPaid, BrandDealStatusCancelled},
	BrandDealStatusPaid:        {BrandDealStatusCompleted, BrandDealStatusCancelled},
	BrandDealStatusCompleted:   {}, // terminal
	BrandDealStatusCancelled:   {}, // terminal
}

// NormalizeDealStatus maps UI aliases to canonical stored values per PRD / S16 §4.
func NormalizeDealStatus(status string) (BrandDealStatus, error) {
	norm := strings.ToLower(strings.TrimSpace(status))
	switch norm {
	case "negotiating", "negotiation":
		return BrandDealStatusNegotiating, nil
	case "agreed", "contracted":
		return BrandDealStatusAgreed, nil
	case "in_progress", "inprogress", "active":
		return BrandDealStatusInProgress, nil
	case "delivered":
		return BrandDealStatusDelivered, nil
	case "paid":
		return BrandDealStatusPaid, nil
	case "completed", "closed", "archived":
		return BrandDealStatusCompleted, nil
	case "cancelled", "canceled":
		return BrandDealStatusCancelled, nil
	default:
		return "", fmt.Errorf("%w: unknown deal status %q", ErrInvalidStateTransition, status)
	}
}

type BrandDealType string

const (
	BrandDealTypeSponsoredPost BrandDealType = "sponsored_post"
	BrandDealTypeProductReview BrandDealType = "product_review"
	BrandDealTypeAmbassador    BrandDealType = "ambassador"
	BrandDealTypeAffiliate     BrandDealType = "affiliate"
	BrandDealTypeCustom        BrandDealType = "custom"
)

type LinkType string

const (
	LinkTypeURL      LinkType = "url"
	LinkTypeProduct  LinkType = "product"
	LinkTypeVideo    LinkType = "video"
	LinkTypeSocial   LinkType = "social"
	LinkTypeDownload LinkType = "download"
	LinkTypeEmail    LinkType = "email"
)

type LinkInBioPageStatus string

const (
	LinkInBioPageStatusActive    LinkInBioPageStatus = "active"
	LinkInBioPageStatusSuspended LinkInBioPageStatus = "suspended"
	LinkInBioPageStatusArchived  LinkInBioPageStatus = "archived"
)

type LinkSecurityScanStatus string

const (
	LinkSecurityScanStatusSafe       LinkSecurityScanStatus = "safe"
	LinkSecurityScanStatusSuspicious LinkSecurityScanStatus = "suspicious"
	LinkSecurityScanStatusPhishing   LinkSecurityScanStatus = "phishing"
	LinkSecurityScanStatusMalware    LinkSecurityScanStatus = "malware"
	LinkSecurityScanStatusBlocked    LinkSecurityScanStatus = "blocked"
)

type MediaKitDirectoryStatus string

const (
	MediaKitDirectoryStatusHidden        MediaKitDirectoryStatus = "hidden"
	MediaKitDirectoryStatusPendingReview MediaKitDirectoryStatus = "pending_review"
	MediaKitDirectoryStatusPublished     MediaKitDirectoryStatus = "published"
)

type TaxReportPeriod string

const (
	TaxReportPeriodMonthly   TaxReportPeriod = "monthly"
	TaxReportPeriodQuarterly TaxReportPeriod = "quarterly"
	TaxReportPeriodYearly    TaxReportPeriod = "yearly"
)

type TaxReportFormat string

const (
	TaxReportFormatPDF  TaxReportFormat = "pdf"
	TaxReportFormatXLSX TaxReportFormat = "xlsx"
	TaxReportFormatCSV  TaxReportFormat = "csv"
)

// ----------------------------------------------------------------------------
// Domain Entities
// ----------------------------------------------------------------------------

type LinkInBioPage struct {
	PageID               string              `json:"page_id"`
	WorkspaceID          string              `json:"workspace_id"`
	Slug                 string              `json:"slug"`
	Title                string              `json:"title"`
	Bio                  string              `json:"bio"`
	AvatarURL            string              `json:"avatar_url"`
	Theme                string              `json:"theme"`
	CustomCSS            map[string]any      `json:"custom_css,omitempty"`
	CustomDomain         string              `json:"custom_domain,omitempty"`
	CustomDomainVerified bool                `json:"custom_domain_verified"`
	AnalyticsEnabled     bool                `json:"analytics_enabled"`
	TotalViews           int32               `json:"total_views"`
	Status               LinkInBioPageStatus `json:"status"`
	CreatedAt            time.Time           `json:"created_at"`
	UpdatedAt            time.Time           `json:"updated_at"`
	DeletedAt            *time.Time          `json:"deleted_at,omitempty"`
	Items                []LinkItem          `json:"items,omitempty"`
}

type LinkItem struct {
	LinkItemID        string                 `json:"link_item_id"`
	PageID            string                 `json:"page_id"`
	WorkspaceID       string                 `json:"workspace_id"`
	LinkType          LinkType               `json:"link_type"`
	Label             string                 `json:"label"`
	URL               string                 `json:"url"`
	Icon              string                 `json:"icon,omitempty"`
	ThumbnailURL      string                 `json:"thumbnail_url,omitempty"`
	Position          int32                  `json:"position"`
	Clicks            int32                  `json:"clicks"`
	IsActive          bool                   `json:"is_active"`
	ScanStatus        LinkSecurityScanStatus `json:"scan_status"`
	PhishingDetected  bool                   `json:"phishing_detected"`
	ScanThreatDetails string                 `json:"scan_threat_details,omitempty"`
	CreatedAt         time.Time              `json:"created_at"`
	UpdatedAt         time.Time              `json:"updated_at"`
	DeletedAt         *time.Time             `json:"deleted_at,omitempty"`
}

type LinkSecurityScan struct {
	ScanId                string                 `json:"scan_id"`
	WorkspaceID           string                 `json:"workspace_id"`
	URL                   string                 `json:"url"`
	LinkItemID            string                 `json:"link_item_id,omitempty"`
	ScanStatus            LinkSecurityScanStatus `json:"scan_status"`
	PhishingDetected      bool                   `json:"phishing_detected"`
	ThreatDetails         string                 `json:"threat_details,omitempty"`
	BlockedFromPublishing bool                   `json:"blocked_from_publishing"`
	ScannedAt             time.Time              `json:"scanned_at"`
}

type MediaKit struct {
	MediaKitID            string                  `json:"media_kit_id"`
	WorkspaceID           string                  `json:"workspace_id"`
	Template              string                  `json:"template"`
	SectionsJSON          string                  `json:"sections_json"`
	BrandProfileID        string                  `json:"brand_profile_id,omitempty"`
	ShareURL              string                  `json:"share_url,omitempty"`
	DirectoryOptIn        bool                    `json:"directory_opt_in"`
	DirectoryStatus       MediaKitDirectoryStatus `json:"directory_status"`
	DirectoryProfileJSON  string                  `json:"directory_profile_json"`
	DirectoryConsentedAt  *time.Time              `json:"directory_consented_at,omitempty"`
	LastGeneratedAt       *time.Time              `json:"last_generated_at,omitempty"`
	GenerationCreditsUsed float64                 `json:"generation_credits_used"`
	CreatedAt             time.Time               `json:"created_at"`
	UpdatedAt             time.Time               `json:"updated_at"`
	DeletedAt             *time.Time              `json:"deleted_at,omitempty"`
}

type RateCard struct {
	RateCardID    string         `json:"rate_card_id"`
	WorkspaceID   string         `json:"workspace_id"`
	Currency      string         `json:"currency"`
	CustomNote    string         `json:"custom_note,omitempty"`
	AISuggestedAt *time.Time     `json:"ai_suggested_at,omitempty"`
	CreatedAt     time.Time      `json:"created_at"`
	UpdatedAt     time.Time      `json:"updated_at"`
	DeletedAt     *time.Time     `json:"deleted_at,omitempty"`
	Items         []RateCardItem `json:"items,omitempty"`
}

type RateCardItem struct {
	ItemID           string    `json:"item_id"`
	RateCardID       string    `json:"rate_card_id"`
	WorkspaceID      string    `json:"workspace_id"`
	ServiceType      string    `json:"service_type"`
	PriceMin         float64   `json:"price_min"`
	PriceMax         float64   `json:"price_max"`
	AISuggestedPrice float64   `json:"ai_suggested_price"`
	Description      string    `json:"description,omitempty"`
	DeliveryTime     string    `json:"delivery_time,omitempty"`
	Position         int32     `json:"position"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}

type BrandDeal struct {
	DealID                  string          `json:"deal_id"`
	WorkspaceID             string          `json:"workspace_id"`
	BrandName               string          `json:"brand_name"`
	ContactEmail            string          `json:"contact_email,omitempty"`
	DealType                BrandDealType   `json:"deal_type"`
	Value                   float64         `json:"value"`
	Currency                string          `json:"currency"`
	Status                  BrandDealStatus `json:"status"`
	Deadline                string          `json:"deadline,omitempty"`
	Deliverables            string          `json:"deliverables,omitempty"`
	ContractEvidenceIDs     []string        `json:"contract_evidence_ids"`
	InquiryThreadID         string          `json:"inquiry_thread_id,omitempty"`
	Notes                   string          `json:"notes,omitempty"`
	CancellationReason      string          `json:"cancellation_reason,omitempty"`
	FinancialReversalLogged bool            `json:"financial_reversal_logged,omitempty"`
	KanbanOrder             int32           `json:"kanban_order"`
	Version                 int32           `json:"version"`
	CreatedAt               time.Time       `json:"created_at"`
	UpdatedAt               time.Time       `json:"updated_at"`
	DeletedAt               *time.Time      `json:"deleted_at,omitempty"`
}

// ----------------------------------------------------------------------------
// Creator Directory & Contract Template Models (database_schema.md §27.2)
// ----------------------------------------------------------------------------

type PublicRateItem struct {
	ServiceType string `json:"service_type"`
	Amount      string `json:"amount"`
	Currency    string `json:"currency"`
}

type PublicCreatorProfile struct {
	DisplayName   string           `json:"display_name"`
	Bio           string           `json:"bio"`
	Categories    []string         `json:"categories"`
	Languages     []string         `json:"languages"`
	PortfolioURLs []string         `json:"portfolio_urls"`
	PublicRates   []PublicRateItem `json:"public_rates"`
}

type CreatorDirectoryEntry struct {
	MediaKitID  string               `json:"media_kit_id"`
	Profile     PublicCreatorProfile `json:"profile"`
	PublishedAt time.Time            `json:"published_at"`
}

type ContractTemplate struct {
	TemplateID      string `json:"template_id"`
	Title           string `json:"title"`
	Description     string `json:"description"`
	DefaultTerms    string `json:"default_terms"`
	Version         string `json:"version"`
	SourceArticleID string `json:"source_article_id"`
	BodyMarkdown    string `json:"body_markdown"`
	Disclaimer      string `json:"disclaimer"`
}

type BrandDealPipelineStats struct {
	WorkspaceID         string  `json:"workspace_id"`
	NegotiatingCount    int32   `json:"negotiating_count"`
	AgreedCount         int32   `json:"agreed_count"`
	InProgressCount     int32   `json:"in_progress_count"`
	DeliveredCount      int32   `json:"delivered_count"`
	PaidCount           int32   `json:"paid_count"`
	CompletedCount      int32   `json:"completed_count"`
	CancelledCount      int32   `json:"cancelled_count"`
	TotalActiveValue    float64 `json:"total_active_value"`
	TotalCompletedValue float64 `json:"total_completed_value"`
	Currency            string  `json:"currency"`
}

type SponsorInquiry struct {
	InquiryID       string    `json:"inquiry_id"`
	WorkspaceID     string    `json:"workspace_id"`
	BrandName       string    `json:"brand_name"`
	ContactEmail    string    `json:"contact_email"`
	Message         string    `json:"message"`
	EstimatedBudget float64   `json:"estimated_budget"`
	Status          string    `json:"status"` // pending, accepted, declined, flagged
	ThreadID        string    `json:"thread_id"`
	ReceivedAt      time.Time `json:"received_at"`
}

type ContentROIMetric struct {
	WorkspaceID       string  `json:"workspace_id,omitempty"`
	ContentID         string  `json:"content_id"`
	Title             string  `json:"title"`
	Platform          string  `json:"platform"`
	Views             int64   `json:"views"`
	Engagement        int64   `json:"engagement"`
	LinkClicks        int64   `json:"link_clicks"`
	OrdersAttributed  int64   `json:"orders_attributed"`
	RevenueAttributed float64 `json:"revenue_attributed"`
	CostToProduce     float64 `json:"cost_to_produce"`
	ROIPercentage     float64 `json:"roi_percentage"`
	RPM               float64 `json:"rpm"`
	// Target 3: Zero-view RPM undefined representation
	RPMIsUndefined         bool      `json:"rpm_is_undefined"`
	ProductionMode         string    `json:"production_mode"`
	IsDerivative           bool      `json:"is_derivative"`
	SourceContentID        string    `json:"source_content_id,omitempty"`
	DerivativeCount        int32     `json:"derivative_count"`
	DerivativeTotalRevenue float64   `json:"derivative_total_revenue"`
	PublishedAt            time.Time `json:"published_at"`
}

type RPMTrendPoint struct {
	PeriodLabel        string  `json:"period_label"`
	Platform           string  `json:"platform"`
	RPM                float64 `json:"rpm"`
	RPMIsUndefined     bool    `json:"rpm_is_undefined"`
	Views              int64   `json:"views"`
	Revenue            float64 `json:"revenue"`
	ChangePercent      float64 `json:"change_percent"`
	DropAlertTriggered bool    `json:"drop_alert_triggered"`
}

type TaxReportSummary struct {
	ReportID             string          `json:"report_id"`
	WorkspaceID          string          `json:"workspace_id"`
	Period               TaxReportPeriod `json:"period"`
	TaxYear              int32           `json:"tax_year"`
	PeriodNumber         int32           `json:"period_number"`
	TotalRevenue         float64         `json:"total_revenue"`
	AffiliateRevenue     float64         `json:"affiliate_revenue"`
	SponsorshipRevenue   float64         `json:"sponsorship_revenue"`
	ProductSalesRevenue  float64         `json:"product_sales_revenue"`
	AICreditExpenses     float64         `json:"ai_credit_expenses"`
	SubscriptionExpenses float64         `json:"subscription_expenses"`
	NetIncomeBeforeTax   float64         `json:"net_income_before_tax"`
	Currency             string          `json:"currency"`
	Format               TaxReportFormat `json:"format"`
	DownloadURL          string          `json:"download_url"`
	GeneratedAt          time.Time       `json:"generated_at"`
}

type OutboxEvent struct {
	EventID     string         `json:"event_id"`
	WorkspaceID string         `json:"workspace_id"`
	EventType   string         `json:"event_type"`
	AggregateID string         `json:"aggregate_id"`
	Payload     map[string]any `json:"payload"`
	CreatedAt   time.Time      `json:"created_at"`
}

package seeding

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

type SampleRequestStatus string

const (
	RequestStatusRequested SampleRequestStatus = "requested"
	RequestStatusApproved  SampleRequestStatus = "approved"
	RequestStatusDeclined  SampleRequestStatus = "declined"
	RequestStatusFulfilled SampleRequestStatus = "fulfilled"
	RequestStatusCancelled SampleRequestStatus = "cancelled"
)

type SampleShipmentStatus string

const (
	ShipmentStatusPreparing SampleShipmentStatus = "preparing"
	ShipmentStatusShipped   SampleShipmentStatus = "shipped"
	ShipmentStatusDelivered SampleShipmentStatus = "delivered"
	ShipmentStatusLost      SampleShipmentStatus = "lost"
	ShipmentStatusReturned  SampleShipmentStatus = "returned"
	ShipmentStatusClosed    SampleShipmentStatus = "closed"
)

type SampleOutcomeStatus string

const (
	OutcomeStatusPending SampleOutcomeStatus = "pending"
	OutcomeStatusLogged  SampleOutcomeStatus = "logged"
)

type FollowUpStatus string

const (
	FollowUpPending    FollowUpStatus = "pending_followup"
	FollowUpContacted  FollowUpStatus = "contacted"
	FollowUpResponded  FollowUpStatus = "responded"
	FollowUpNoResponse FollowUpStatus = "no_response"
)

type SourceClass string

const (
	SourceClassOfficial     SourceClass = "official"
	SourceClassImported     SourceClass = "imported"
	SourceClassInferred     SourceClass = "inferred"
	SourceClassEstimated    SourceClass = "estimated"
	SourceClassUnreconciled SourceClass = "unreconciled"
)

type ConfidenceLevel string

const (
	ConfidenceHigh   ConfidenceLevel = "high"
	ConfidenceMedium ConfidenceLevel = "medium"
	ConfidenceLow    ConfidenceLevel = "low"
)

type ShippingAddress struct {
	Name         string `json:"name"`
	Phone        string `json:"phone"`
	AddressLine1 string `json:"address_line_1"`
	AddressLine2 string `json:"address_line_2,omitempty"`
	City         string `json:"city"`
	PostalCode   string `json:"postal_code"`
	Country      string `json:"country"`
}

type SampleOutcome struct {
	ContentURL          string                `json:"content_url"`
	ContentType         string                `json:"content_type"`
	PublishItemID       string                `json:"publish_item_id,omitempty"`
	Impressions         int64                 `json:"impressions"`
	Views               int64                 `json:"views"`
	Engagements         int64                 `json:"engagements"`
	ConversionsCount    int64                 `json:"conversions_count"`
	AttributableRevenue tenantdb.ExactDecimal `json:"attributable_revenue"`
	Currency            string                `json:"currency"`
	SourceClass         SourceClass           `json:"source_class"`
	ConfidenceLevel     ConfidenceLevel       `json:"confidence_level"`
	ConfidenceReason    string                `json:"confidence_reason"`
	Notes               string                `json:"notes,omitempty"`
	LoggedAt            time.Time             `json:"logged_at"`
}

type SampleRequest struct {
	RequestID           string              `json:"request_id"`
	WorkspaceID         string              `json:"workspace_id"`
	CampaignID          *string             `json:"campaign_id,omitempty"`
	ProductID           string              `json:"product_id"`
	CreatorEntityID     string              `json:"creator_entity_id"`
	Status              SampleRequestStatus `json:"status"`
	Quantity            int32               `json:"quantity"`
	OutcomeStatus       SampleOutcomeStatus `json:"outcome_status"`
	Outcome             SampleOutcome       `json:"outcome"`
	FollowUpStatus      FollowUpStatus      `json:"follow_up_status"`
	ShippingAddress     ShippingAddress     `json:"shipping_address"`
	ContentRequirements string              `json:"content_requirements,omitempty"`
	Deadline            *string             `json:"deadline,omitempty"`
	DeclineReason       *string             `json:"decline_reason,omitempty"`
	Notes               string              `json:"notes,omitempty"`
	CreatedAt           time.Time           `json:"created_at"`
	UpdatedAt           time.Time           `json:"updated_at"`
	DeletedAt           *time.Time          `json:"deleted_at,omitempty"`

	// Enriched fields for read projections
	ProductTitle     string                `json:"product_title,omitempty"`
	ProductCOGS      tenantdb.ExactDecimal `json:"product_cogs"`
	CreatorName      string                `json:"creator_name,omitempty"`
	CreatorHandle    string                `json:"creator_handle,omitempty"`
	CreatorAvatarURL string                `json:"creator_avatar_url,omitempty"`
	CreatorFollowers int64                 `json:"creator_followers,omitempty"`
	CreatorPlatform  string                `json:"creator_platform,omitempty"`
	Shipment         *SampleShipment       `json:"shipment,omitempty"`
}

type SampleShipment struct {
	ShipmentID     string                `json:"shipment_id"`
	RequestID      string                `json:"request_id"`
	WorkspaceID    string                `json:"workspace_id"`
	TrackingNumber string                `json:"tracking_number"`
	Carrier        string                `json:"carrier"`
	ShippingCost   tenantdb.ExactDecimal `json:"shipping_cost"`
	ShippedAt      *time.Time            `json:"shipped_at,omitempty"`
	DeliveredAt    *time.Time            `json:"delivered_at,omitempty"`
	Status         SampleShipmentStatus  `json:"status"`
	CreatedAt      time.Time             `json:"created_at"`
	UpdatedAt      time.Time             `json:"updated_at"`
}

type SeedingCampaign struct {
	CampaignID        string                `json:"campaign_id"`
	WorkspaceID       string                `json:"workspace_id"`
	Title             string                `json:"title"`
	Objective         string                `json:"objective"`
	Status            string                `json:"status"`
	StartDate         string                `json:"start_date,omitempty"`
	EndDate           string                `json:"end_date,omitempty"`
	Budget            tenantdb.ExactDecimal `json:"budget"`
	BudgetCurrency    string                `json:"budget_currency"`
	RelatedProductIDs []string              `json:"related_product_ids,omitempty"`
	TotalRequests     int32                 `json:"total_requests"`
	ShippedCount      int32                 `json:"shipped_count"`
	PublishedCount    int32                 `json:"published_count"`
	TotalCost         tenantdb.ExactDecimal `json:"total_cost"`
	AttributedRevenue tenantdb.ExactDecimal `json:"attributed_revenue"`
	CreatedAt         time.Time             `json:"created_at"`
	UpdatedAt         time.Time             `json:"updated_at"`
}

type SeedingReport struct {
	CampaignID              string                `json:"campaign_id,omitempty"`
	WorkspaceID             string                `json:"workspace_id"`
	TotalSamplesRequested   int32                 `json:"total_samples_requested"`
	TotalSamplesApproved    int32                 `json:"total_samples_approved"`
	TotalSamplesShipped     int32                 `json:"total_samples_shipped"`
	TotalSamplesDelivered   int32                 `json:"total_samples_delivered"`
	OutcomesLoggedCount     int32                 `json:"outcomes_logged_count"`
	PendingOutcomesCount    int32                 `json:"pending_outcomes_count"`
	OutcomeCoverageRate     string                `json:"outcome_coverage_rate"`
	TotalCOGS               tenantdb.ExactDecimal `json:"total_cogs"`
	TotalShipping           tenantdb.ExactDecimal `json:"total_shipping"`
	TotalCost               tenantdb.ExactDecimal `json:"total_cost"`
	AttributableRevenue     tenantdb.ExactDecimal `json:"attributable_revenue"`
	ROIPercentage           string                `json:"roi_percentage"`
	OverallConfidence       ConfidenceLevel       `json:"overall_confidence"`
	ConfidenceNotes         string                `json:"confidence_notes"`
	Currency                string                `json:"currency"`
	IsMissingOutcomePending bool                  `json:"is_missing_outcome_pending"`
}

type ProductSummary struct {
	ProductID string
	Title     string
	COGS      tenantdb.ExactDecimal
	Currency  string
}

type CreatorSummary struct {
	EntityID    string
	DisplayName string
	Handle      string
	AvatarURL   string
	Platform    string
	Followers   int64
}

type CostItemSummary struct {
	CostItemID       string
	WorkspaceID      string
	CostType         string
	Amount           tenantdb.ExactDecimal
	Currency         string
	Description      string
	RelatedScopeType string
	RelatedScopeID   string
	SourceClass      string
	CostState        string
	EffectiveDate    time.Time
}

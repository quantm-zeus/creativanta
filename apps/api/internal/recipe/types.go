package recipe

import (
	"time"

	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/workflow"
)

// CallerContext represents the authenticated caller tenant and user identity.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string // owner, admin, manager, editor, contributor, member, viewer
}

// PortableSnapshot represents the portable recipe snapshot JSONB shape per database_schema.md §27.4.
type PortableSnapshot struct {
	SchemaVersion int                    `json:"schema_version"`
	Graph         workflow.WorkflowGraph `json:"graph"`
	StyleSettings map[string]any         `json:"style_settings,omitempty"`
	LicenseNotice string                 `json:"license_notice"`
}

// RecipeTemplate represents a reusable workflow template in the marketplace per database_schema.md §12.3B.
type RecipeTemplate struct {
	RecipeID               string            `json:"recipe_id"`
	WorkspaceID            *string           `json:"workspace_id,omitempty"` // nil for global system recipes
	AuthorWorkspaceID      *string           `json:"author_workspace_id,omitempty"`
	Title                  string            `json:"title"`
	Description            string            `json:"description"`
	Category               string            `json:"category"`
	ActivepiecesTemplateID string            `json:"activepieces_template_id,omitempty"`
	TemplateKind           string            `json:"template_kind"` // workflow, style_workflow
	TemplateVersion        int               `json:"template_version"`
	TemplatePayload        PortableSnapshot  `json:"template_payload"`
	Parameters             []RecipeParameter `json:"parameters"`
	RequiredCapabilities   []string          `json:"required_capabilities"`
	InstallCount           int               `json:"install_count"`
	RatingAvg              float32           `json:"rating_avg"` // 0-5 non-financial rating
	ReviewCount            int               `json:"review_count"`
	PriceUSD               string            `json:"price_usd"` // exact decimal string per DB-H-001
	Status                 string            `json:"status"`    // draft, review_required, published, deprecated, retired, taken_down
	CreatedAt              time.Time         `json:"created_at"`
	UpdatedAt              time.Time         `json:"updated_at"`
	DeletedAt              *time.Time        `json:"deleted_at,omitempty"`
}

// RecipeParameter defines a user-configurable parameter in a recipe.
type RecipeParameter struct {
	Name         string `json:"name"`
	Type         string `json:"type"` // string, number, boolean, select, channel, credential_ref
	DefaultValue string `json:"default_value"`
	Required     bool   `json:"required"`
	Description  string `json:"description"`
}

// MissingCapabilityExplanation provides structured user-facing diagnostic for missing capabilities.
type MissingCapabilityExplanation struct {
	CapabilityKey      string `json:"capability_key"`
	Platform           string `json:"platform"`
	Reason             string `json:"reason"`
	ResolutionGuidance string `json:"resolution_guidance"`
	ConnectURL         string `json:"connect_url"`
}

// RecipeInstallation tracks an installed recipe instance in a workspace.
type RecipeInstallation struct {
	InstallationID   string         `json:"installation_id"`
	WorkspaceID      string         `json:"workspace_id"`
	RecipeID         string         `json:"recipe_id"`
	WorkflowID       string         `json:"workflow_id"`
	InstalledVersion int            `json:"installed_version"`
	Status           string         `json:"status"` // installed, customized, update_available, pinned, deprecated, workflow_deleted
	ParameterValues  map[string]any `json:"parameter_values"`
	InstalledBy      string         `json:"installed_by,omitempty"`
	CreatedAt        time.Time      `json:"created_at"`
	UpdatedAt        time.Time      `json:"updated_at"`
	DeletedAt        *time.Time     `json:"deleted_at,omitempty"`
}

// RecipeReview represents a creator or user review and 1-5 rating.
type RecipeReview struct {
	ReviewID    string    `json:"review_id"`
	RecipeID    string    `json:"recipe_id"`
	WorkspaceID string    `json:"workspace_id"`
	UserID      string    `json:"user_id"`
	Rating      int       `json:"rating"` // 1-5 stars
	ReviewText  string    `json:"review_text"`
	AuthorName  string    `json:"author_name"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

// RecipeSubmission represents a recipe submitted for marketplace governance review (Pack 06 S22).
type RecipeSubmission struct {
	SubmissionID      string     `json:"submission_id"`
	RecipeID          string     `json:"recipe_id"`
	AuthorWorkspaceID string     `json:"author_workspace_id"`
	SubmittedVersion  int        `json:"submitted_version"`
	Status            string     `json:"status"` // pending, approved, rejected, changes_requested, taken_down
	ReviewNotes       string     `json:"review_notes"`
	ReviewedBy        string     `json:"reviewed_by,omitempty"`
	ReviewedAt        *time.Time `json:"reviewed_at,omitempty"`
	TakedownReason    string     `json:"takedown_reason,omitempty"`
	TakedownTicketRef string     `json:"takedown_ticket_ref,omitempty"`
	CreatedAt         time.Time  `json:"created_at"`
	UpdatedAt         time.Time  `json:"updated_at"`
}

// RecipeRevenueShare represents a 70/30 creator/platform split for paid recipes (RULE-M21-006).
type RecipeRevenueShare struct {
	RevenueShareID       string    `json:"revenue_share_id"`
	RecipeID             string    `json:"recipe_id"`
	AuthorWorkspaceID    string    `json:"author_workspace_id"`
	PurchaserWorkspaceID string    `json:"purchaser_workspace_id"`
	GrossAmount          string    `json:"gross_amount"`    // exact decimal string (DB-H-001)
	CreatorAmount        string    `json:"creator_amount"`  // 70% exact decimal string
	PlatformAmount       string    `json:"platform_amount"` // 30% exact decimal string
	Currency             string    `json:"currency"`
	Status               string    `json:"status"`                // settled, refunded, disputed
	RefundEligibleUntil  time.Time `json:"refund_eligible_until"` // 7-day refund window
	CreatedAt            time.Time `json:"created_at"`
	UpdatedAt            time.Time `json:"updated_at"`
}

// Conversion helpers to protobuf models

func ToProtoRecipeTemplate(r *RecipeTemplate) *automationv1.RecipeTemplate {
	if r == nil {
		return nil
	}
	var wsID, authorWsID string
	if r.WorkspaceID != nil {
		wsID = *r.WorkspaceID
	}
	if r.AuthorWorkspaceID != nil {
		authorWsID = *r.AuthorWorkspaceID
	}

	params := make([]*automationv1.RecipeParameter, 0, len(r.Parameters))
	for _, p := range r.Parameters {
		params = append(params, &automationv1.RecipeParameter{
			Name:         p.Name,
			Type:         p.Type,
			DefaultValue: p.DefaultValue,
			Required:     p.Required,
			Description:  p.Description,
		})
	}

	var status automationv1.RecipeStatus
	switch r.Status {
	case "draft":
		status = automationv1.RecipeStatus_RECIPE_STATUS_DRAFT
	case "review_required":
		status = automationv1.RecipeStatus_RECIPE_STATUS_REVIEW_REQUIRED
	case "published":
		status = automationv1.RecipeStatus_RECIPE_STATUS_PUBLISHED
	case "deprecated":
		status = automationv1.RecipeStatus_RECIPE_STATUS_DEPRECATED
	case "retired":
		status = automationv1.RecipeStatus_RECIPE_STATUS_RETIRED
	case "taken_down":
		status = automationv1.RecipeStatus_RECIPE_STATUS_TAKEN_DOWN
	default:
		status = automationv1.RecipeStatus_RECIPE_STATUS_UNSPECIFIED
	}

	var kind automationv1.TemplateKind
	switch r.TemplateKind {
	case "workflow":
		kind = automationv1.TemplateKind_TEMPLATE_KIND_WORKFLOW
	case "style_workflow":
		kind = automationv1.TemplateKind_TEMPLATE_KIND_STYLE_WORKFLOW
	default:
		kind = automationv1.TemplateKind_TEMPLATE_KIND_UNSPECIFIED
	}

	return &automationv1.RecipeTemplate{
		RecipeId:               r.RecipeID,
		WorkspaceId:            wsID,
		AuthorWorkspaceId:      authorWsID,
		Title:                  r.Title,
		Description:            r.Description,
		Category:               r.Category,
		ActivepiecesTemplateId: r.ActivepiecesTemplateID,
		TemplateKind:           kind,
		TemplateVersion:        int32(r.TemplateVersion),
		Parameters:             params,
		RequiredCapabilities:   r.RequiredCapabilities,
		InstallCount:           int32(r.InstallCount),
		RatingAvg:              r.RatingAvg,
		ReviewCount:            int32(r.ReviewCount),
		PriceUsd:               r.PriceUSD,
		Status:                 status,
	}
}

func ToProtoRecipeInstallation(inst *RecipeInstallation) *automationv1.RecipeInstallation {
	if inst == nil {
		return nil
	}
	var status automationv1.RecipeInstallationStatus
	switch inst.Status {
	case "installed":
		status = automationv1.RecipeInstallationStatus_RECIPE_INSTALLATION_STATUS_INSTALLED
	case "customized":
		status = automationv1.RecipeInstallationStatus_RECIPE_INSTALLATION_STATUS_CUSTOMIZED
	case "update_available":
		status = automationv1.RecipeInstallationStatus_RECIPE_INSTALLATION_STATUS_UPDATE_AVAILABLE
	case "pinned":
		status = automationv1.RecipeInstallationStatus_RECIPE_INSTALLATION_STATUS_PINNED
	case "deprecated":
		status = automationv1.RecipeInstallationStatus_RECIPE_INSTALLATION_STATUS_DEPRECATED
	case "workflow_deleted":
		status = automationv1.RecipeInstallationStatus_RECIPE_INSTALLATION_STATUS_WORKFLOW_DELETED
	default:
		status = automationv1.RecipeInstallationStatus_RECIPE_INSTALLATION_STATUS_UNSPECIFIED
	}

	return &automationv1.RecipeInstallation{
		InstallationId:   inst.InstallationID,
		WorkspaceId:      inst.WorkspaceID,
		RecipeId:         inst.RecipeID,
		WorkflowId:       inst.WorkflowID,
		InstalledVersion: int32(inst.InstalledVersion),
		Status:           status,
		InstalledBy:      inst.InstalledBy,
	}
}

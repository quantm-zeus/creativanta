// Package conversion implements cross-domain commerce conversions and shared lineage (P6-08)
// per docs/02_features/intelligence/opportunity_board.md,
// docs/02_features/content/idea_engine.md,
// docs/02_features/engagement/unified_inbox.md,
// and docs/04_contracts/rbac_permission_matrix.md.
package conversion

import (
	"crypto/rand"
	"errors"
	"fmt"
	"strings"
	"time"
)

var (
	ErrUnauthenticated            = errors.New("conversion: unauthenticated caller")
	ErrCrossTenantDenied          = errors.New("conversion: cross-tenant access strictly forbidden")
	ErrPermissionDenied           = errors.New("conversion: caller lacks required permission")
	ErrTargetPermissionDenied     = errors.New("conversion: caller lacks permission to create target domain object (target permission recheck failed)")
	ErrSourceNotFound             = errors.New("conversion: source object not found")
	ErrInvalidSourceType          = errors.New("conversion: unsupported source object type")
	ErrInvalidTargetType          = errors.New("conversion: unsupported target object type")
	ErrInvalidSourceState         = errors.New("conversion: source object is not in a convertible state")
	ErrConversionValidationFailed = errors.New("conversion: validation failed for conversion requirements")
	ErrConcurrentConflict         = errors.New("conversion: concurrent modification detected; source object was updated")
	ErrTargetCreationFailed       = errors.New("conversion: downstream target object creation failed")
	ErrAlreadyConverted           = errors.New("conversion: source object has already been converted")
)

// SourceType identifies an originating object in a cross-domain conversion.
type SourceType string

const (
	SourceTypeOpportunity SourceType = "opportunity"
	SourceTypeIdea        SourceType = "idea"
	SourceTypeThread      SourceType = "thread"
)

// TargetType identifies a downstream commerce object in a cross-domain conversion.
type TargetType string

const (
	TargetTypeCampaign TargetType = "campaign"
	TargetTypeLive     TargetType = "live"
	TargetTypeOffer    TargetType = "offer"
	TargetTypeSeeding  TargetType = "seeding"
	TargetTypeDeal     TargetType = "deal"
	TargetTypeScript   TargetType = "script"
)

// NormalizeSourceType validates and converts string to canonical SourceType.
func NormalizeSourceType(s string) (SourceType, error) {
	norm := strings.ToLower(strings.TrimSpace(s))
	switch norm {
	case "opportunity":
		return SourceTypeOpportunity, nil
	case "idea":
		return SourceTypeIdea, nil
	case "thread":
		return SourceTypeThread, nil
	default:
		return "", fmt.Errorf("%w: %q (supported: opportunity, idea, thread)", ErrInvalidSourceType, s)
	}
}

// NormalizeTargetType validates and converts string to canonical TargetType.
func NormalizeTargetType(t string) (TargetType, error) {
	norm := strings.ToLower(strings.TrimSpace(t))
	switch norm {
	case "campaign":
		return TargetTypeCampaign, nil
	case "live", "live_session", "live_plan":
		return TargetTypeLive, nil
	case "offer":
		return TargetTypeOffer, nil
	case "seeding", "sample_request", "sample":
		return TargetTypeSeeding, nil
	case "deal", "brand_deal":
		return TargetTypeDeal, nil
	case "script":
		return TargetTypeScript, nil
	default:
		return "", fmt.Errorf("%w: %q (supported: campaign, live, offer, seeding, deal, script)", ErrInvalidTargetType, t)
	}
}

// RequiredSourcePermission returns the RBAC permission needed on the source module.
func RequiredSourcePermission(source SourceType) string {
	switch source {
	case SourceTypeOpportunity:
		return "opportunity:convert"
	case SourceTypeIdea:
		return "idea:convert"
	case SourceTypeThread:
		return "thread:triage"
	default:
		return ""
	}
}

// RequiredTargetPermission returns the RBAC permission that MUST be rechecked on the target domain.
// Acceptance Target 1: "Each target permission rechecked".
func RequiredTargetPermission(target TargetType) string {
	switch target {
	case TargetTypeCampaign:
		return "campaign:manage" // Editor+
	case TargetTypeLive:
		return "live:manage" // Editor+
	case TargetTypeOffer:
		return "offer:manage" // Editor+
	case TargetTypeSeeding:
		return "sample:manage" // Editor+
	case TargetTypeDeal:
		return "brand_deal:manage" // Manager+!
	case TargetTypeScript:
		return "script:create" // Contributor+
	default:
		return ""
	}
}

// CallerContext represents caller identity and role for authorization checks.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
}

// ConversionParams specifies parameters for initiating a cross-domain conversion.
type ConversionParams struct {
	WorkspaceID       string         `json:"workspace_id"`
	SourceType        SourceType     `json:"source_type"`
	SourceID          string         `json:"source_id"`
	TargetType        TargetType     `json:"target_type"`
	TargetTitle       string         `json:"target_title"`
	TargetDetails     map[string]any `json:"target_details"`
	ExpectedUpdatedAt *time.Time     `json:"expected_updated_at,omitempty"`
}

// LineageRecord represents a row in table `cross_domain_conversions` (shared lineage).
type LineageRecord struct {
	ConversionID   string         `json:"conversion_id"`
	WorkspaceID    string         `json:"workspace_id"`
	SourceType     SourceType     `json:"source_type"`
	SourceID       string         `json:"source_id"`
	TargetType     TargetType     `json:"target_type"`
	TargetID       string         `json:"target_id"`
	ConvertedBy    string         `json:"converted_by"`
	Status         string         `json:"status"` // completed, failed, rolled_back
	LineageDepth   int            `json:"lineage_depth"`
	RootSourceType string         `json:"root_source_type,omitempty"`
	RootSourceID   string         `json:"root_source_id,omitempty"`
	Metadata       map[string]any `json:"metadata"`
	CreatedAt      time.Time      `json:"created_at"`
	UpdatedAt      time.Time      `json:"updated_at"`
}

// ConversionResult represents the outcome of a successful atomic conversion.
type ConversionResult struct {
	ConversionID   string        `json:"conversion_id"`
	WorkspaceID    string        `json:"workspace_id"`
	SourceType     SourceType    `json:"source_type"`
	SourceID       string        `json:"source_id"`
	TargetType     TargetType    `json:"target_type"`
	TargetID       string        `json:"target_id"`
	TargetRoute    string        `json:"target_route"`
	Status         string        `json:"status"`
	ConvertedAt    time.Time     `json:"converted_at"`
	SourceSurvives bool          `json:"source_survives"`
	Lineage        LineageRecord `json:"lineage"`
	TargetObject   any           `json:"target_object,omitempty"`
}

// LineageNode represents an item in a lineage trace graph.
type LineageNode struct {
	ID        string         `json:"id"`
	Type      string         `json:"type"` // trend, opportunity, idea, thread, campaign, live, offer, seeding, deal, script
	Title     string         `json:"title"`
	Route     string         `json:"route"`
	Depth     int            `json:"depth"`
	Direction string         `json:"direction"` // upstream, current, downstream
	Metadata  map[string]any `json:"metadata,omitempty"`
}

// LineageGraph represents the full upstream and downstream lineage of an object.
type LineageGraph struct {
	RootNode    LineageNode     `json:"root_node"`
	Upstream    []LineageNode   `json:"upstream"`
	Downstream  []LineageNode   `json:"downstream"`
	Conversions []LineageRecord `json:"conversions"`
}

// NewUUID generates a random UUID v4 string.
func NewUUID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

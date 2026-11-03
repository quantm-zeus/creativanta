// Package intelligence implements the Intelligence operating loop, access proof,
// and downstream conversion gating (M02, M03, M04, M22) per docs/00_index/IMPLEMENTATION_ORDER.md (P2)
// and docs/00_index/AGENT_TASK_CARDS.md (P2-04).
package intelligence

import (
	"errors"
	"time"

	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
)

var (
	ErrUnauthenticated        = errors.New("intelligence: unauthenticated caller")
	ErrInvalidInput           = errors.New("intelligence: invalid input parameter")
	ErrPermissionDenied       = errors.New("intelligence: caller role is not authorized for this operation")
	ErrCrossTenantDenied      = errors.New("intelligence: cross-tenant access strictly forbidden")
	ErrUnverifiedLiveAccess   = errors.New("intelligence: live source access denied; valid access evidence required (no mock posing as live data)")
	ErrDownstreamActionGated  = errors.New("intelligence: downstream generation execution is gated to later phases (P3/P6); linked draft preserved")
	ErrFinancialConflation    = errors.New("intelligence: observational competitor data or estimated profit cannot be accepted by financial ledger (M19)")
	ErrOrphanProvenance       = errors.New("intelligence: orphan object forbidden; provenance lineage required")
	ErrConcurrentModification = errors.New("intelligence: concurrent modification detected; please refresh and try again (409)")
)

// CallerContext represents caller identity and tenant workspace context.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
}

// AccessProofResult represents the result of validating a live source connector's access proof.
// Enforces Acceptance Target 1: "Every live source has access evidence".
type AccessProofResult struct {
	Platform            string                        `json:"platform"`
	ActionKey           string                        `json:"action_key"`
	IsVerified          bool                          `json:"is_verified"`
	IsDegraded          bool                          `json:"is_degraded"`
	SourceClass         intelligencev1.SourceClass    `json:"source_class"`
	ConfidenceBand      intelligencev1.ConfidenceBand `json:"confidence_band"`
	EvidenceRef         string                        `json:"evidence_ref"`
	GrantedScopes       []string                      `json:"granted_scopes"`
	RequiredScopes      []string                      `json:"required_scopes"`
	Endpoint            string                        `json:"endpoint"`
	CheckedAt           time.Time                     `json:"checked_at"`
	ValidUntil          time.Time                     `json:"valid_until"`
	DegradedReason      string                        `json:"degraded_reason,omitempty"`
	FallbackNote        string                        `json:"fallback_note,omitempty"`
	CanFallbackToImport bool                          `json:"can_fallback_to_import"`
	ReconnectRequired   bool                          `json:"reconnect_required"`
	ReconnectCTA        string                        `json:"reconnect_cta,omitempty"`
}

// DownstreamGatePolicy defines gating rules for conversions from Opportunity (M04).
// Enforces Acceptance Target 2: "Future conversions remain assigned to later tasks".
type DownstreamGatePolicy struct {
	TargetType       string   `json:"target_type"`       // "idea", "script", "campaign", "live_plan"
	OwningModule     string   `json:"owning_module"`     // "M05", "M06", "M14", "M17"
	OwningPhase      string   `json:"owning_phase"`      // "P3", "P6"
	OwningTaskIDs    []string `json:"owning_task_ids"`   // e.g. ["P3-01", "P3-02"]
	IsGated          bool     `json:"is_gated"`          // Always true in P2
	LineagePreserved bool     `json:"lineage_preserved"` // Always true
	GatingNotice     string   `json:"gating_notice"`
}

// AuthorizedSignalImportItem specifies a trend signal item for zero-connector import.
type AuthorizedSignalImportItem struct {
	SignalType        string                        `json:"signal_type"`
	SourceSystem      string                        `json:"source_system"`
	NormalizedSummary string                        `json:"normalized_summary"`
	Confidence        intelligencev1.ConfidenceBand `json:"confidence"`
	FreshnessHours    int32                         `json:"freshness_hours"`
	Payload           map[string]any                `json:"payload"`
}

// AuthorizedBenchmarkImportItem specifies a competitor benchmark item for zero-connector import.
type AuthorizedBenchmarkImportItem struct {
	CompetitorName     string                        `json:"competitor_name"`
	Platform           string                        `json:"platform"`
	ExternalHandle     string                        `json:"external_handle"`
	Category           string                        `json:"category"`
	EngagementRate     float32                       `json:"engagement_rate"`
	FollowersCount     int64                         `json:"followers_count"`
	ObservedPriceRange string                        `json:"observed_price_range"`
	Confidence         intelligencev1.ConfidenceBand `json:"confidence"`
	BasisSummary       string                        `json:"basis_summary"`
}

// AuthorizedImportBatchRequest represents a multi-domain manual/import batch
// enabling full operating loop with ZERO connected accounts.
type AuthorizedImportBatchRequest struct {
	WorkspaceID      string                          `json:"workspace_id"`
	SourceProvenance string                          `json:"source_provenance"`
	SignalItems      []AuthorizedSignalImportItem    `json:"signal_items"`
	BenchmarkItems   []AuthorizedBenchmarkImportItem `json:"benchmark_items"`
}

// AuthorizedImportBatchResponse summarizes the result of an authorized import.
type AuthorizedImportBatchResponse struct {
	WorkspaceID             string                        `json:"workspace_id"`
	ImportedSignalsCount    int                           `json:"imported_signals_count"`
	ImportedTrendsCount     int                           `json:"imported_trends_count"`
	ImportedCompetitorCount int                           `json:"imported_competitor_count"`
	ImportedSnapshotsCount  int                           `json:"imported_snapshots_count"`
	SourceClass             intelligencev1.SourceClass    `json:"source_class"`
	ConfidenceBand          intelligencev1.ConfidenceBand `json:"confidence_band"`
	ImportedAt              time.Time                     `json:"imported_at"`
}

// EmptyStateSummary models the empty state across intelligence modules.
type EmptyStateSummary struct {
	WorkspaceID            string `json:"workspace_id"`
	ConnectedAccountsCount int    `json:"connected_accounts_count"`
	TrendsCount            int    `json:"trends_count"`
	CompetitorsCount       int    `json:"competitors_count"`
	OpportunitiesCount     int    `json:"opportunities_count"`
	TrendRadarEmpty        bool   `json:"trend_radar_empty"`
	CompetitorEmpty        bool   `json:"competitor_empty"`
	OpportunityEmpty       bool   `json:"opportunity_empty"`
	TrendCTA               string `json:"trend_cta"`
	CompetitorCTA          string `json:"competitor_cta"`
	OpportunityCTA         string `json:"opportunity_cta"`
}

// DegradedStateSummary models degraded state when external connections fail.
type DegradedStateSummary struct {
	WorkspaceID             string   `json:"workspace_id"`
	HasDegradedSources      bool     `json:"has_degraded_sources"`
	DegradedPlatforms       []string `json:"degraded_platforms"`
	DegradedReasons         []string `json:"degraded_reasons"`
	ReconnectCTAs           []string `json:"reconnect_ctas"`
	SuggestedFallbackAction string   `json:"suggested_fallback_action"`
}

// IntelligenceAuditReport models the audit verification output.
type IntelligenceAuditReport struct {
	WorkspaceID                  string              `json:"workspace_id"`
	AuditedAt                    time.Time           `json:"audited_at"`
	Passed                       bool                `json:"passed"`
	Target1AccessProofPassed     bool                `json:"target1_access_proof_passed"`
	Target2DownstreamGatedPassed bool                `json:"target2_downstream_gated_passed"`
	Target3EmptyDegradedPassed   bool                `json:"target3_empty_degraded_passed"`
	ProvenanceIntegrityPassed    bool                `json:"provenance_integrity_passed"`
	FinancialNonConflationPassed bool                `json:"financial_non_conflation_passed"`
	RBACPermissionsPassed        bool                `json:"rbac_permissions_passed"`
	OptimisticConcurrencyPassed  bool                `json:"optimistic_concurrency_passed"`
	AlertStormBatchedPassed      bool                `json:"alert_storm_batched_passed"`
	LiveSourceVerifications      []AccessProofResult `json:"live_source_verifications"`
	Violations                   []string            `json:"violations"`
}

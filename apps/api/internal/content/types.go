// Package content coordinates content handoffs, cross-domain lineage,
// concurrent edit preservation, and mobile review acceptance for Phase P3
// per docs/02_features/content/idea_engine.md (M05),
// docs/02_features/content/script_lab.md (M06),
// docs/02_features/intelligence/trend_radar.md (M02),
// docs/02_features/intelligence/opportunity_board.md (M04),
// and docs/02_features/platform/home_decision_engine.md (M01).
package content

import (
	"errors"
	"time"
)

var (
	ErrUnauthenticated            = errors.New("content: unauthenticated request")
	ErrCrossTenantDenied          = errors.New("content: cross-tenant access strictly forbidden")
	ErrPermissionDenied           = errors.New("content: caller role is not authorized for this operation")
	ErrScriptNotFound             = errors.New("content: requested script not found")
	ErrIdeaNotFound               = errors.New("content: requested idea not found")
	ErrOpportunityNotFound        = errors.New("content: requested opportunity not found")
	ErrTrendNotFound              = errors.New("content: requested trend not found")
	ErrAssetBriefIncomplete       = errors.New("content: asset brief is incomplete; cannot mark ready for production")
	ErrStaleReviewConflict        = errors.New("content: script was updated since review began; reload to inspect author changes (EC-M06-003)")
	ErrConcurrentVersionConflict  = errors.New("content: concurrent modification detected; base version does not match current version")
	ErrPublishSideEffectForbidden = errors.New("content: creative assistant cannot publish or schedule posts; publishing is gated to Publish Hub M11 in Phase P5")
	ErrEmptyScenesNotAllowed      = errors.New("content: script has empty scenes; complete all scene content before submitting (EC-M06-001)")
	ErrRejectionReasonTooShort    = errors.New("content: rejection reason must be at least 10 characters (RULE-M06-002)")
)

// CallerContext models authenticated caller context across content operations.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
}

// LineageNodeType classifies nodes along the content generation pipeline.
type LineageNodeType string

const (
	LineageNodeTrend       LineageNodeType = "trend"
	LineageNodeOpportunity LineageNodeType = "opportunity"
	LineageNodeIdea        LineageNodeType = "idea"
	LineageNodeScript      LineageNodeType = "script"
	LineageNodeAssetBrief  LineageNodeType = "asset_brief"
)

// LineageNode represents a single point in the source chain.
type LineageNode struct {
	ID          string          `json:"id"`
	Type        LineageNodeType `json:"type"`
	Title       string          `json:"title"`
	State       string          `json:"state"`
	Confidence  string          `json:"confidence,omitempty"`
	SourceClass string          `json:"source_class,omitempty"`
	RouteURL    string          `json:"route_url"`
	CreatedAt   time.Time       `json:"created_at"`
	UpdatedAt   time.Time       `json:"updated_at"`
	Metadata    map[string]any  `json:"metadata,omitempty"`
}

// SourceChainLineage encapsulates the complete provenance trail for a script.
// Satisfies Acceptance Target 1: "Source chain reaches approved brief".
type SourceChainLineage struct {
	WorkspaceID        string       `json:"workspace_id"`
	ScriptID           string       `json:"script_id"`
	Trend              *LineageNode `json:"trend,omitempty"`
	Opportunity        *LineageNode `json:"opportunity,omitempty"`
	Idea               *LineageNode `json:"idea,omitempty"`
	Script             *LineageNode `json:"script"`
	AssetBrief         *LineageNode `json:"asset_brief,omitempty"`
	IsComplete         bool         `json:"is_complete"`
	IsProductionReady  bool         `json:"is_production_ready"`
	LineageHash        string       `json:"lineage_hash"`
	EmittedEvents      []string     `json:"emitted_events"`
	VerificationPassed bool         `json:"verification_passed"`
}

// ConcurrentEditState tracks script versioning and review freshness.
// Satisfies Acceptance Target 2: "Concurrent edits preserve data".
type ConcurrentEditState struct {
	ScriptID             string    `json:"script_id"`
	CurrentVersionIndex  int32     `json:"current_version_index"`
	ExpectedVersionIndex int32     `json:"expected_version_index"`
	LastUpdatedAt        time.Time `json:"last_updated_at"`
	ReviewerSnapshotTime time.Time `json:"reviewer_snapshot_time"`
	IsStaleReview        bool      `json:"is_stale_review"`
	ConflictDetected     bool      `json:"conflict_detected"`
	PreservedSnapshots   int       `json:"preserved_snapshots"`
	AuthorEditsPreserved bool      `json:"author_edits_preserved"`
	ResolutionMessage    string    `json:"resolution_message,omitempty"`
}

// CreativeAssistantSafetyStatus tracks the isolation between creative drafting and publishing.
// Satisfies Acceptance Target 3: "No publish side effects from creative assistant".
type CreativeAssistantSafetyStatus struct {
	IsPublishSafe         bool      `json:"is_publish_safe"`
	PublishIntentDetected bool      `json:"publish_intent_detected"`
	RefusalMessage        string    `json:"refusal_message,omitempty"`
	AllowedCreativeOutput bool      `json:"allowed_creative_output"`
	PublishedPostsCount   int       `json:"published_posts_count"`  // MUST be 0 in P3
	ScheduledJobsCount    int       `json:"scheduled_jobs_count"`   // MUST be 0 in P3
	ExternalEffectsCount  int       `json:"external_effects_count"` // MUST be 0 in P3
	CheckedAt             time.Time `json:"checked_at"`
}

// CreativeDraftResult represents draft content generated by the creative assistant.
type CreativeDraftResult struct {
	DraftID            string    `json:"draft_id"`
	DraftType          string    `json:"draft_type"` // hook, angle, channel_rewrite, scene_expansion
	Title              string    `json:"title"`
	Content            string    `json:"content"`
	SuggestedPlatforms []string  `json:"suggested_platforms"`
	RequiresUserReview bool      `json:"requires_user_review"`
	IsPublished        bool      `json:"is_published"` // Guaranteed false
	CreatedAt          time.Time `json:"created_at"`
}

// ContentHandoffSummary aggregates operational metrics for M01 Home Decision Engine.
type ContentHandoffSummary struct {
	WorkspaceID               string   `json:"workspace_id"`
	OpportunitiesConverted    int      `json:"opportunities_converted"`
	IdeasCandidateCount       int      `json:"ideas_candidate_count"`
	IdeasConvertedCount       int      `json:"ideas_converted_count"`
	ScriptsInReviewCount      int      `json:"scripts_in_review_count"`
	ScriptsApprovedCount      int      `json:"scripts_approved_count"`
	ScriptsReadyProduction    int      `json:"scripts_ready_production"`
	StaleReviewConflictsCount int      `json:"stale_review_conflicts_count"`
	PendingReviewScriptIDs    []string `json:"pending_review_script_ids"`
	ReadyProductionScriptIDs  []string `json:"ready_production_script_ids"`
}

// ConvertTrendToIdeaRequest defines parameters to start the pipeline from a Trend.
type ConvertTrendToIdeaRequest struct {
	WorkspaceID     string `json:"workspace_id"`
	TrendID         string `json:"trend_id"`
	Title           string `json:"title"`
	AudienceIntent  string `json:"audience_intent,omitempty"`
	SuggestedFormat string `json:"suggested_format,omitempty"`
}

// ConvertOpportunityToIdeaRequest defines parameters to start pipeline from Opportunity.
type ConvertOpportunityToIdeaRequest struct {
	WorkspaceID     string `json:"workspace_id"`
	OpportunityID   string `json:"opportunity_id"`
	Title           string `json:"title"`
	AudienceIntent  string `json:"audience_intent,omitempty"`
	SuggestedFormat string `json:"suggested_format,omitempty"`
}

// ConvertIdeaToScriptRequest defines parameters to convert an Idea to a Script.
type ConvertIdeaToScriptRequest struct {
	WorkspaceID       string   `json:"workspace_id"`
	IdeaID            string   `json:"idea_id"`
	FormatType        string   `json:"format_type"`
	TargetDurationSec int32    `json:"target_duration_seconds"`
	PublishProfiles   []string `json:"publish_target_profiles,omitempty"`
}

// CompleteBriefAndHandOffRequest defines parameters to finalize the Asset Brief.
type CompleteBriefAndHandOffRequest struct {
	WorkspaceID                string `json:"workspace_id"`
	ScriptID                   string `json:"script_id"`
	OutputType                 string `json:"output_type"`
	TargetFormat               string `json:"target_format"`
	TargetDurationSeconds      int32  `json:"target_duration_seconds"`
	ContinuityRequirementsJSON string `json:"continuity_requirements_json"`
	BrandVoiceRequirementsJSON string `json:"brand_voice_requirements_json"`
	ProductionInstructions     string `json:"production_instructions"`
}

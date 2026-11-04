package production

import (
	"errors"
	"time"
)

// Standard observational notice required by docs/04_contracts/api_behavior_contracts.md#7.
const StandardObservationalNotice = "Observational recommendation - not causal proof or guaranteed revenue uplift."

var (
	ErrExperimentAlreadyCompleted      = errors.New("production: A/B experiment is already completed")
	ErrExperimentCancelled             = errors.New("production: A/B experiment has been cancelled")
	ErrInsufficientExposure            = errors.New("insufficient exposure (<1000 impressions per variant); comparison retained as observational without automated scaling")
	ErrLiftBelowThreshold              = errors.New("statistical lift below threshold; retain as observational without automated scaling")
	ErrExperimentNotEligibleForScaling = errors.New("experiment is not eligible for scaling: must be completed, conclusive, with a valid winner")
	ErrScalingPermissionDenied         = errors.New("M11 gate failure: caller lacks publish:execute or publish:schedule permission")
	ErrScalingCapabilityDegraded       = errors.New("M11 gate failure: target platform connector is degraded, unsupported, or revoked")
	ErrScalingPolicyBlocked            = errors.New("M11 gate failure: packaging QA compliance scan blocked or has unresolved hard blocks")
	ErrScalingDuplicatePost            = errors.New("M11 gate failure: identical content already published to target platform within cooldown window")
)

// ABVariantRecord models a single test variant (thumbnail, title, hook, CTA, music, full_video).
type ABVariantRecord struct {
	VariantID      string  `json:"variant_id"`
	AssetID        string  `json:"asset_id"`
	PublishItemID  string  `json:"publish_item_id,omitempty"`
	VariantType    string  `json:"variant_type"`  // thumbnail, title, hook, cta, music, full_video
	VariantLabel   string  `json:"variant_label"` // "A", "B", "Control"
	Impressions    int64   `json:"impressions"`
	Views          int64   `json:"views"`
	Clicks         int64   `json:"clicks"`
	CTR            float64 `json:"ctr"`
	Conversions    int64   `json:"conversions"`
	EngagementRate float64 `json:"engagement_rate"`
}

// AutoWinnerCriteriaRecord models auto-winner rules for experiments.
type AutoWinnerCriteriaRecord struct {
	Metric              string  `json:"metric"`               // views, engagement_rate, click_through, watch_time
	ThresholdMultiplier float64 `json:"threshold_multiplier"` // e.g. 1.2 or 1.5
	MinDurationHours    int     `json:"min_duration_hours"`   // e.g. 48
	MinImpressions      int64   `json:"min_impressions"`      // e.g. 1000
}

// PerformanceInsightRecord models an AI performance coach insight (EF-09).
type PerformanceInsightRecord struct {
	InsightID       string `json:"insight_id"`
	Title           string `json:"title"`
	Description     string `json:"description"`
	Category        string `json:"category"`     // hook, retention, engagement, format, timing, sound
	ImpactLevel     string `json:"impact_level"` // high, medium, low
	EffortLevel     string `json:"effort_level"` // low, medium, high
	SuggestedAction string `json:"suggested_action"`
	TargetAssetID   string `json:"target_asset_id,omitempty"`
	IsObservational bool   `json:"is_observational"`
}

// VideoScorecardRecord models 24h post-publish analysis for a video asset (EF-09).
type VideoScorecardRecord struct {
	AssetID             string   `json:"asset_id"`
	Title               string   `json:"title"`
	PackagingScore      float64  `json:"packaging_score"`
	HookScore           float64  `json:"hook_score"`
	RetentionRate3s     float64  `json:"retention_rate_3s"`
	CompletionRate      float64  `json:"completion_rate"`
	EngagementRate      float64  `json:"engagement_rate"`
	Views               int64    `json:"views"`
	Likes               int64    `json:"likes"`
	Comments            int64    `json:"comments"`
	Shares              int64    `json:"shares"`
	Grade               string   `json:"grade"` // A+, A, B, C, D
	Strengths           []string `json:"strengths"`
	DropOffPoints       []string `json:"drop_off_points"`
	ImprovementTips     []string `json:"improvement_tips"`
	IsObservational     bool     `json:"is_observational"`
	ObservationalNotice string   `json:"observational_notice"`
}

// ImprovementItemRecord models a single actionable coaching recommendation.
type ImprovementItemRecord struct {
	ItemID               string `json:"item_id"`
	Title                string `json:"title"`
	Description          string `json:"description"`
	FormatRecommendation string `json:"format_recommendation"`
	SoundSuggestion      string `json:"sound_suggestion"`
	Impact               string `json:"impact"` // High, Medium, Low
	Effort               string `json:"effort"` // Low, Medium, High
	ActionCTA            string `json:"action_cta"`
}

// ImprovementPlanRecord models a weekly AI report card and improvement plan.
type ImprovementPlanRecord struct {
	PlanID              string                   `json:"plan_id"`
	WorkspaceID         string                   `json:"workspace_id"`
	Period              string                   `json:"period"`
	CurrentScore        float64                  `json:"current_score"`
	PreviousScore       float64                  `json:"previous_score"`
	ScoreChange         float64                  `json:"score_change"`
	BestPostTitle       string                   `json:"best_post_title"`
	BestPostER          float64                  `json:"best_post_er"`
	WorstPostTitle      string                   `json:"worst_post_title"`
	WorstPostER         float64                  `json:"worst_post_er"`
	ActionItems         []*ImprovementItemRecord `json:"action_items"`
	IsObservational     bool                     `json:"is_observational"`
	ObservationalNotice string                   `json:"observational_notice"`
}

// IndustryBenchmarkRecord models industry/niche baseline metrics.
type IndustryBenchmarkRecord struct {
	BenchmarkID       string  `json:"benchmark_id"`
	Platform          string  `json:"platform"`
	Niche             string  `json:"niche"`
	AvgEngagementRate float64 `json:"avg_engagement_rate"`
	Avg3sRetention    float64 `json:"avg_3s_retention"`
	AvgCompletionRate float64 `json:"avg_completion_rate"`
	AvgCTR            float64 `json:"avg_ctr"`
	SampleSize        int     `json:"sample_size"`
	IsObservational   bool    `json:"is_observational"`
}

// IndustryComparisonRecord models workspace metrics vs industry averages.
type IndustryComparisonRecord struct {
	Platform                  string  `json:"platform"`
	Niche                     string  `json:"niche"`
	WorkspaceEngagementRate   float64 `json:"workspace_engagement_rate"`
	IndustryAvgEngagementRate float64 `json:"industry_avg_engagement_rate"`
	ERDeltaPercent            float64 `json:"er_delta_percent"`
	Workspace3sRetention      float64 `json:"workspace_3s_retention"`
	IndustryAvg3sRetention    float64 `json:"industry_avg_3s_retention"`
	RetentionDeltaPercent     float64 `json:"retention_delta_percent"`
	PercentileRank            string  `json:"percentile_rank"`
	Summary                   string  `json:"summary"`
	IsObservational           bool    `json:"is_observational"`
	ObservationalNotice       string  `json:"observational_notice"`
}

// ScaleWinnerResult models the result of an experiment scaling execution across M11 gates.
type ScaleWinnerResult struct {
	ExperimentID               string    `json:"experiment_id"`
	WinnerAssetID              string    `json:"winner_asset_id"`
	ScheduledItemIDs           []string  `json:"scheduled_item_ids"`
	TargetPlatforms            []string  `json:"target_platforms"`
	ResultStatus               string    `json:"result_status"`
	ObservationalLabelRetained bool      `json:"observational_label_retained"`
	Message                    string    `json:"message"`
	ScaledAt                   time.Time `json:"scaled_at"`
}

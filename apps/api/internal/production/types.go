// Package production implements M07 AI Video Studio durable generation jobs,
// smart pipeline router, bounded quotes/budgets, provider adapters, BYOK,
// lineage provenance, upload safety, and sandboxed post-production.
package production

import (
	"errors"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

var (
	ErrUnauthenticated            = errors.New("production: unauthenticated request")
	ErrCrossTenantDenied          = errors.New("production: cross-tenant access strictly forbidden")
	ErrPermissionDenied           = errors.New("production: caller role is not authorized for this operation")
	ErrJobNotFound                = errors.New("production: generation job not found")
	ErrAssetNotFound              = errors.New("production: asset not found")
	ErrCannotCancelCompletedJob   = errors.New("production: cannot cancel already completed or failed job")
	ErrInsufficientCredits        = errors.New("production: insufficient credit balance for estimated generation cost (EC-M07-002)")
	ErrQuoteExpiredOrInvalid      = errors.New("production: credit quote is expired, stale, or does not match parameters (BILLING_CONFLICT_002)")
	ErrPaidRetryExceedsQuote      = errors.New("production: paid retry/fallback exceeds confirmed bounded quote plan; new quote required (BILLING_CONFLICT_002)")
	ErrDisallowedFFmpegArg        = errors.New("production: FFmpeg argument is not in security allowlist")
	ErrOutputValidationFailed     = errors.New("production: post-production output validation failed (audio normalization/resolution/streams)")
	ErrExecutionTimeout           = errors.New("production: worker execution exceeded time limit")
	ErrProcessTerminated          = errors.New("production: process group was terminated")
	ErrFileTooLarge               = errors.New("production: uploaded file exceeds size limit")
	ErrDisallowedMimeType         = errors.New("production: mime type is not supported")
	ErrInfectedFile               = errors.New("production: virus scan detected infected payload")
	ErrScriptSimilarityExceeded   = errors.New("production: remix script similarity exceeds 30% threshold (RULE-M07-003)")
	ErrCircuitBreakerOpen         = errors.New("production: provider circuit breaker open due to consecutive failures")
	ErrInvalidBatchRow            = errors.New("production: invalid batch input row")
	ErrTranscriptNotFound         = errors.New("production: transcript not found")
	ErrDraftNotFound              = errors.New("production: quick edit draft not found")
	ErrSoundNotFound              = errors.New("production: sound track not found")
	ErrAlignmentFailed            = errors.New("production: auto-alignment failed. [Try segment mode] or [Manual cut]")
	ErrCopyrightViolation         = errors.New("production: music detected as copyrighted without commercial license clearance (EC-M07-M01)")
	ErrConsentRequired            = errors.New("production: consent verification required before voice clone can be created or used (RULE-M08-002)")
	ErrConsentRevoked             = errors.New("production: consent for voice likeness was revoked; cannot generate voiceover")
	ErrTierGateBlocked            = errors.New("production: voice clone requires Pro tier or above (TIER_GATE_BLOCKED)")
	ErrLicensedInputRequired      = errors.New("production: valid commercial license or verified copyright ownership required (SAFE-2026-02)")
	ErrQualityRepairRequired      = errors.New("production: audio clarity or translation quality below acceptable threshold; repair required")
	ErrDRMProtected               = errors.New("production: cannot access video at this URL: content is DRM protected (EC-M07-R01)")
	ErrGeoBlocked                 = errors.New("production: cannot access video at this URL: content is geo-blocked (EC-M07-R01)")
	ErrUnlicensedMediaBlocked     = errors.New("production: unlicensed copyrighted media detected; bypass not permitted (RULE-M07-008, SAFE-2026-02)")
	ErrInvalidReferenceURL        = errors.New("production: invalid reference video URL or SSRF attempt detected")
	ErrMultiMergeLimitExceeded    = errors.New("production: media input count exceeds workspace tier limit")
	ErrSingleMediaNotAllowed      = errors.New("production: multi-merge requires at least 2 media files")
	ErrBlueprintNotFound          = errors.New("production: remix blueprint not found")
	ErrVideoEditJobNotFound       = errors.New("production: video edit job not found")
	ErrClipCollectionNotFound     = errors.New("production: clip collection not found")
	ErrConcurrentJobLimitExceeded = errors.New("production: processing queue full for workspace tier (EC-M07-004)")
)

// CallerContext models authenticated caller context across production operations.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string // Owner, Admin, Manager, Editor, Contributor, Member, Viewer
}

// HasRole checks whether caller has minimum role requirement.
func (c CallerContext) HasRole(minRole string) bool {
	roles := map[string]int{
		"Viewer":      1,
		"Member":      2,
		"Contributor": 3,
		"Editor":      4,
		"Manager":     5,
		"Admin":       6,
		"Owner":       7,
	}
	callerRank := roles[c.WorkspaceRole]
	minRank := roles[minRole]
	return callerRank >= minRank && callerRank > 0
}

// LineageRecord holds provenance info for assets per RULE-M07-001.
type LineageRecord struct {
	SourceProvider        string                `json:"source_provider"`
	SourceModel           string                `json:"source_model"`
	GenerationPrompt      string                `json:"generation_prompt"`
	ContinuityPackIDs     []string              `json:"continuity_pack_ids"`
	GenerationCostCredits tenantdb.ExactDecimal `json:"generation_cost_credits"`
	GenerationCostUSD     tenantdb.ExactDecimal `json:"generation_cost_usd"`
	ParentAssetID         string                `json:"parent_asset_id,omitempty"`
	RecordedAt            time.Time             `json:"recorded_at"`
}

// GenerationJob represents a durable generation job record (§7.4).
type GenerationJob struct {
	JobID             string                `json:"job_id"`
	WorkspaceID       string                `json:"workspace_id"`
	AssetID           string                `json:"asset_id"`
	JobType           string                `json:"job_type"` // video_gen, quick_edit, clip_factory, multi_merge, remix, etc.
	Provider          string                `json:"provider"` // veo, kling, runway, elevenlabs, etc.
	Model             string                `json:"model"`
	PipelineStrategy  string                `json:"pipeline_strategy"` // native_audio, audio_first, post_prod_lip_sync, simple_voice_over
	InputParamsJSON   string                `json:"input_params_json"`
	PromptPackageJSON string                `json:"prompt_package_json"`
	Status            string                `json:"status"` // queued, processing, completed, failed, cancelled
	ProgressPct       int                   `json:"progress_pct"`
	CurrentStep       string                `json:"current_step"`
	EstimatedCredits  tenantdb.ExactDecimal `json:"estimated_credits"`
	ActualCredits     tenantdb.ExactDecimal `json:"actual_credits"`
	ActualCostUSD     tenantdb.ExactDecimal `json:"actual_cost_usd"`
	ProviderJobID     string                `json:"provider_job_id"`
	ResultURL         string                `json:"result_url"`
	ResultMetadata    string                `json:"result_metadata"`
	ErrorCode         string                `json:"error_code"`
	ErrorMessage      string                `json:"error_message"`
	RetryCount        int                   `json:"retry_count"`
	MaxRetries        int                   `json:"max_retries"`
	QuoteID           string                `json:"quote_id"`
	ReservationID     string                `json:"reservation_id"`
	BYOKUsed          bool                  `json:"byok_used"`
	StartedAt         *time.Time            `json:"started_at,omitempty"`
	CompletedAt       *time.Time            `json:"completed_at,omitempty"`
	CreatedAt         time.Time             `json:"created_at"`
	UpdatedAt         time.Time             `json:"updated_at"`
}

// Asset represents a canonical creative asset (§7.3).
type Asset struct {
	AssetID               string                `json:"asset_id"`
	WorkspaceID           string                `json:"workspace_id"`
	AssetType             string                `json:"asset_type"` // video, image, audio, thumbnail, subtitle
	Title                 string                `json:"title"`
	ScriptID              string                `json:"script_id,omitempty"`
	AssetBriefID          string                `json:"asset_brief_id,omitempty"`
	SourceGenerationMode  string                `json:"source_generation_mode"` // ai_generated, user_uploaded, imported, derived
	SourceProvider        string                `json:"source_provider"`
	SourceModel           string                `json:"source_model"`
	FileURL               string                `json:"file_url"`
	FileSizeBytes         int64                 `json:"file_size_bytes"`
	DurationSeconds       tenantdb.ExactDecimal `json:"duration_seconds"`
	Resolution            string                `json:"resolution"`
	AspectRatio           string                `json:"aspect_ratio"`
	MimeType              string                `json:"mime_type"`
	GenerationState       string                `json:"generation_state"` // queued, generating, generated, failed, cancelled
	QualityState          string                `json:"quality_state"`    // draft, review_required, approved, rejected, promoted_canonical
	LineageRefs           []LineageRecord       `json:"lineage_refs"`
	ContinuityPackIDs     []string              `json:"continuity_pack_ids"`
	GenerationCostCredits tenantdb.ExactDecimal `json:"generation_cost_credits"`
	GenerationCostUSD     tenantdb.ExactDecimal `json:"generation_cost_usd"`
	GenerationPrompt      string                `json:"generation_prompt"`
	GenerationParamsJSON  string                `json:"generation_params_json"`
	ErrorMessage          string                `json:"error_message,omitempty"`
	ParentAssetID         string                `json:"parent_asset_id,omitempty"`
	DerivativeType        string                `json:"derivative_type,omitempty"`
	DriftScore            *float32              `json:"drift_score,omitempty"`
	DriftSeverity         string                `json:"drift_severity,omitempty"` // none, low_drift, moderate_drift, high_drift
	DriftDetailsJSON      string                `json:"drift_details_json,omitempty"`
	CreatedBy             string                `json:"created_by,omitempty"`
	CreatedAt             time.Time             `json:"created_at"`
	UpdatedAt             time.Time             `json:"updated_at"`
	DeletedAt             *time.Time            `json:"deleted_at,omitempty"`
}

// FileUpload represents an upload record (§18.7).
type FileUpload struct {
	UploadID        string    `json:"upload_id"`
	WorkspaceID     string    `json:"workspace_id"`
	UploaderUserID  string    `json:"uploader_user_id"`
	FileName        string    `json:"file_name"`
	FileSizeBytes   int64     `json:"file_size_bytes"`
	MimeType        string    `json:"mime_type"`
	StorageKey      string    `json:"storage_key"`
	StorageURL      string    `json:"storage_url"`
	ChecksumSHA256  string    `json:"checksum_sha256"`
	UploadPurpose   string    `json:"upload_purpose"`
	VirusScanStatus string    `json:"virus_scan_status"` // pending, clean, infected, error
	CreatedAt       time.Time `json:"created_at"`
}

// PostProductionConfig represents audio and video normalization options.
type PostProductionConfig struct {
	NormalizeAudio       bool    `json:"normalize_audio"`
	TargetLUFS           float64 `json:"target_lufs"` // Target loudness in LUFS (-14.0 target per RULE-M07-005)
	AspectRatio          string  `json:"aspect_ratio"`
	SubtitleOverlay      bool    `json:"subtitle_overlay"`
	SubtitleStyle        string  `json:"subtitle_style"`
	ActiveSpeakerReframe bool    `json:"active_speaker_reframe"`
}

// BatchRowInput represents single item for batch validation / generation.
type BatchRowInput struct {
	Index        int      `json:"index"`
	ItemID       string   `json:"item_id"`
	ItemName     string   `json:"item_name"`
	Prompt       string   `json:"prompt"`
	ReferenceURL string   `json:"reference_url"`
	ImageURLs    []string `json:"image_urls"`
}

// BatchRowValidationResult holds the result of inspecting a single batch row.
type BatchRowValidationResult struct {
	Index            int                   `json:"index"`
	ItemID           string                `json:"item_id"`
	ItemName         string                `json:"item_name"`
	IsValid          bool                  `json:"is_valid"`
	ValidationError  string                `json:"validation_error,omitempty"`
	EstimatedCredits tenantdb.ExactDecimal `json:"estimated_credits"`
	EstimatedCostUSD tenantdb.ExactDecimal `json:"estimated_cost_usd"`
}

// BatchBudgetPreviewResult holds aggregate preview calculation and validation details.
type BatchBudgetPreviewResult struct {
	TotalEstimatedCredits   tenantdb.ExactDecimal      `json:"total_estimated_credits"`
	TotalCostCeilingUSD     tenantdb.ExactDecimal      `json:"total_cost_ceiling_usd"`
	TotalItems              int                        `json:"total_items"`
	ValidItemsCount         int                        `json:"valid_items_count"`
	InvalidItemsCount       int                        `json:"invalid_items_count"`
	Items                   []BatchRowValidationResult `json:"items"`
	SufficientCredits       bool                       `json:"sufficient_credits"`
	CurrentAvailableCredits tenantdb.ExactDecimal      `json:"current_available_credits"`
	QuoteID                 string                     `json:"quote_id"`
	QuoteExpiresAt          time.Time                  `json:"quote_expires_at"`
}

// TranscriptWordRecord represents a word with millisecond timecodes and filler metadata.
type TranscriptWordRecord struct {
	WordID     string  `json:"word_id"`
	Text       string  `json:"text"`
	StartMS    int64   `json:"start_ms"`
	EndMS      int64   `json:"end_ms"`
	Confidence float64 `json:"confidence"`
	IsFiller   bool    `json:"is_filler"`
	FillerType string  `json:"filler_type,omitempty"`
	IsDeleted  bool    `json:"is_deleted"`
}

// TranscriptSegmentRecord represents a continuous sentence or speaker utterance.
type TranscriptSegmentRecord struct {
	SegmentID string `json:"segment_id"`
	StartMS   int64  `json:"start_ms"`
	EndMS     int64  `json:"end_ms"`
	Text      string `json:"text"`
	SpeakerID string `json:"speaker_id,omitempty"`
}

// TranscriptRecord represents durable speech transcription.
type TranscriptRecord struct {
	TranscriptID    string                    `json:"transcript_id"`
	WorkspaceID     string                    `json:"workspace_id"`
	AssetID         string                    `json:"asset_id"`
	Language        string                    `json:"language"`
	RawText         string                    `json:"raw_text"`
	Words           []TranscriptWordRecord    `json:"words"`
	Segments        []TranscriptSegmentRecord `json:"segments"`
	FillerCount     int                       `json:"filler_count"`
	PauseCount      int                       `json:"pause_count"`
	AlignmentStatus string                    `json:"alignment_status"` // auto_aligned, repaired, manual_fallback, failed
	AlignmentError  string                    `json:"alignment_error,omitempty"`
	CreatedAt       time.Time                 `json:"created_at"`
	UpdatedAt       time.Time                 `json:"updated_at"`
	DeletedAt       *time.Time                `json:"deleted_at,omitempty"`
}

// DeadPauseRecord identifies silent gaps between speech.
type DeadPauseRecord struct {
	StartMS    int64 `json:"start_ms"`
	EndMS      int64 `json:"end_ms"`
	DurationMS int64 `json:"duration_ms"`
}

// TranscriptAnalysisRecord holds ASR analysis, filler/pause counts and hook quality score.
type TranscriptAnalysisRecord struct {
	FillerCount          int               `json:"filler_count"`
	PauseCount           int               `json:"pause_count"`
	HookQualityScore     float64           `json:"hook_quality_score"` // 0-10
	EstimatedTimeSavedMS int64             `json:"estimated_time_saved_ms"`
	FinalDurationMS      int64             `json:"final_duration_ms"`
	DetectedFillers      []string          `json:"detected_fillers"`
	DeadPauses           []DeadPauseRecord `json:"dead_pauses"`
	HookFeedback         string            `json:"hook_feedback"`
}

// TranscriptCorrectionItem holds user corrections for dialect/accent repair (EC-M07-Q01).
type TranscriptCorrectionItem struct {
	WordID        string `json:"word_id"`
	CorrectedText string `json:"corrected_text"`
	NewStartMS    int64  `json:"new_start_ms"`
	NewEndMS      int64  `json:"new_end_ms"`
	MarkCut       bool   `json:"mark_cut"`
}

// CutIntervalRecord represents a cut timestamp interval [start_ms, end_ms].
type CutIntervalRecord struct {
	StartMS int64  `json:"start_ms"`
	EndMS   int64  `json:"end_ms"`
	Reason  string `json:"reason"` // filler, pause, manual_cut, hook_trim
}

// QuickEditAddonsConfig contains user-selected studio enhancements.
type QuickEditAddonsConfig struct {
	AutoCaptions     bool    `json:"auto_captions"`
	CaptionStyle     string  `json:"caption_style"` // bounce, karaoke, highlight, typewriter
	AddHook          bool    `json:"add_hook"`
	HookID           string  `json:"hook_id,omitempty"`
	HookType         string  `json:"hook_type,omitempty"` // question, shock, story, pov, listicle, contrast
	BeatSync         bool    `json:"beat_sync"`
	SoundID          string  `json:"sound_id,omitempty"`
	BRoll            bool    `json:"b_roll"`
	BRollScene       string  `json:"b_roll_scene,omitempty"`
	PlatformPreset   string  `json:"platform_preset,omitempty"` // tiktok, youtube_shorts, reels
	AudioEnhancement bool    `json:"audio_enhancement"`
	TargetLUFS       float64 `json:"target_lufs"`   // default -14.0 LUFS
	ReframeRatio     string  `json:"reframe_ratio"` // 9:16, 16:9, 1:1
}

// QuickEditDraftRecord stores an in-progress Quick Edit draft.
type QuickEditDraftRecord struct {
	DraftID          string                `json:"draft_id"`
	WorkspaceID      string                `json:"workspace_id"`
	AssetID          string                `json:"asset_id"`
	TranscriptID     string                `json:"transcript_id"`
	Name             string                `json:"name"`
	Cuts             []CutIntervalRecord   `json:"cuts"`
	Addons           QuickEditAddonsConfig `json:"addons"`
	EstimatedCredits tenantdb.ExactDecimal `json:"estimated_credits"`
	CreatedBy        string                `json:"created_by,omitempty"`
	CreatedAt        time.Time             `json:"created_at"`
	UpdatedAt        time.Time             `json:"updated_at"`
}

// SoundTrackRecord represents royalty-free or tenant-owned audio assets.
type SoundTrackRecord struct {
	SoundID             string    `json:"sound_id"`
	WorkspaceID         string    `json:"workspace_id,omitempty"` // empty for global
	Title               string    `json:"title"`
	Artist              string    `json:"artist"`
	Genre               string    `json:"genre"`
	BPM                 int       `json:"bpm"`
	DurationSeconds     float64   `json:"duration_seconds"`
	AudioURL            string    `json:"audio_url"`
	IsRoyaltyFree       bool      `json:"is_royalty_free"`
	ACRCloudCleared     bool      `json:"acrcloud_cleared"`
	ACRCloudFingerprint string    `json:"acrcloud_fingerprint,omitempty"`
	LicenseType         string    `json:"license_type"`
	Tags                []string  `json:"tags"`
	CreatedAt           time.Time `json:"created_at"`
	UpdatedAt           time.Time `json:"updated_at"`
}

// BeatSyncGridRecord holds BPM and detected beat timecodes.
type BeatSyncGridRecord struct {
	BPM                  int     `json:"bpm"`
	BeatTimestampsMS     []int64 `json:"beat_timestamps_ms"`
	DownbeatTimestampsMS []int64 `json:"downbeat_timestamps_ms"`
	Confidence           float64 `json:"confidence"`
}

// CopyrightScanRecord holds ACRCloud scan results.
type CopyrightScanRecord struct {
	IsCopyrighted         bool                `json:"is_copyrighted"`
	MatchedTrack          string              `json:"matched_track,omitempty"`
	MatchedArtist         string              `json:"matched_artist,omitempty"`
	ClearanceAllowed      bool                `json:"clearance_allowed"`
	ScanProvider          string              `json:"scan_provider"`
	SuggestedAlternatives []*SoundTrackRecord `json:"suggested_alternatives,omitempty"`
}

// HookItem represents a curated hook from the Smart Hook Library.
type HookItem struct {
	HookID             string  `json:"hook_id"`
	HookText           string  `json:"hook_text"`
	HookType           string  `json:"hook_type"` // question, shock, story, pov, listicle, contrast
	EffectivenessScore float64 `json:"effectiveness_score"`
	Source             string  `json:"source"`
}

// TranslationJob represents a multi-language localization record (§22.6).
type TranslationJob struct {
	TranslationJobID          string                `json:"translation_job_id"`
	WorkspaceID               string                `json:"workspace_id"`
	VideoEditJobID            string                `json:"video_edit_job_id,omitempty"`
	SourceAssetID             string                `json:"source_asset_id"`
	TargetLanguages           []string              `json:"target_languages"`
	LipSyncEnabled            bool                  `json:"lip_sync_enabled"`
	CulturalAdaptationEnabled bool                  `json:"cultural_adaptation_enabled"`
	TranslateCaptions         bool                  `json:"translate_captions"`
	TranslateOverlays         bool                  `json:"translate_overlays"`
	VoiceOption               string                `json:"voice_option"`
	VoiceCloneID              string                `json:"voice_clone_id,omitempty"`
	PerLanguageStatus         map[string]string     `json:"per_language_status"`
	OutputAssetIDs            map[string]string     `json:"output_asset_ids"`
	TotalCreditsUsed          tenantdb.ExactDecimal `json:"total_credits_used"`
	Status                    string                `json:"status"` // queued, processing, partially_completed, completed, failed, cancelled
	QualityScores             map[string]float64    `json:"quality_scores"`
	RepairNotes               map[string]string     `json:"repair_notes"`
	QuoteID                   string                `json:"quote_id,omitempty"`
	CreatedAt                 time.Time             `json:"created_at"`
	UpdatedAt                 time.Time             `json:"updated_at"`
	DeletedAt                 *time.Time            `json:"deleted_at,omitempty"`
}

// TranslationSegment represents a timed dialogue segment.
type TranslationSegment struct {
	SegmentID    string            `json:"segment_id"`
	StartTimeS   float64           `json:"start_time_s"`
	EndTimeS     float64           `json:"end_time_s"`
	SourceText   string            `json:"source_text"`
	Translations map[string]string `json:"translations"`
	QualityScore float64           `json:"quality_score"`
	NeedsRepair  bool              `json:"needs_repair"`
	RepairReason string            `json:"repair_reason,omitempty"`
}

// SoundTrack represents an audio sound track with licensing metadata (§EF-06).
type SoundTrack struct {
	TrackID           string    `json:"track_id"`
	WorkspaceID       string    `json:"workspace_id"`
	Title             string    `json:"title"`
	Category          string    `json:"category"` // music, sfx, ambient
	Genre             string    `json:"genre"`
	Mood              string    `json:"mood"`
	BPM               int       `json:"bpm"`
	DurationSeconds   float64   `json:"duration_seconds"`
	FileURL           string    `json:"file_url"`
	LicenseType       string    `json:"license_type"` // commercial_royalty_free, licensed_library, user_uploaded
	LicenseID         string    `json:"license_id"`
	IsVerifiedLicense bool      `json:"is_verified_license"`
	WaveformPeaks     []float32 `json:"waveform_peaks"`
	CreatedAt         time.Time `json:"created_at"`
}

// VoiceCloneRecord represents a voice clone likeness record linked to characters and consent (§22.12).
type VoiceCloneRecord struct {
	VoiceCloneID    string    `json:"voice_clone_id"`
	WorkspaceID     string    `json:"workspace_id"`
	CharacterID     string    `json:"character_id"`
	Provider        string    `json:"provider"`
	ProviderVoiceID string    `json:"provider_voice_id"`
	VoiceName       string    `json:"voice_name"`
	SampleAudioURLs []string  `json:"sample_audio_urls"`
	CloneStatus     string    `json:"clone_status"` // pending, processing, ready, failed, revoked
	ConsentRecordID string    `json:"consent_record_id,omitempty"`
	QualityScore    float64   `json:"quality_score"`
	RepairApplied   bool      `json:"repair_applied"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

// CreativeDNA models the 8-layer video analysis result per Mode 4.
type CreativeDNA struct {
	SceneCount              int     `json:"scene_count"`
	HookType                string  `json:"hook_type"` // Question, Shock, Story, Listicle, Contrast, POV
	ContentStructureJSON    string  `json:"content_structure_json"`
	PacingProfileJSON       string  `json:"pacing_profile_json"`
	VisualStyleJSON         string  `json:"visual_style_json"`
	AudioProfileJSON        string  `json:"audio_profile_json"`
	TransitionMapJSON       string  `json:"transition_map_json"`
	TotalDurationSeconds    float64 `json:"total_duration_seconds"`
	EngagementStructureJSON string  `json:"engagement_structure_json"`
}

// RemixBlueprint models a durable Creative DNA blueprint (§22.2).
type RemixBlueprint struct {
	BlueprintID          string      `json:"blueprint_id"`
	WorkspaceID          string      `json:"workspace_id"`
	ReferenceAssetID     string      `json:"reference_asset_id"`
	ReferenceURL         string      `json:"reference_url,omitempty"`
	ReferenceTranscript  string      `json:"reference_transcript,omitempty"`
	OutputAssetID        string      `json:"output_asset_id,omitempty"`
	VideoEditJobID       string      `json:"video_edit_job_id,omitempty"`
	CreativeDNA          CreativeDNA `json:"creative_dna"`
	RemixScript          string      `json:"remix_script"`
	FidelityLevel        string      `json:"fidelity_level"`        // match_1to1, adapt, loose
	OriginalityScore     float64     `json:"originality_score"`     // 0-100 score, >70 required
	SimilarityPercentage float64     `json:"similarity_percentage"` // 0-100 similarity, <30% required
	Status               string      `json:"status"`                // analyzing, analyzed, generating, generated, failed, rejected
	RejectionReason      string      `json:"rejection_reason,omitempty"`
	ErrorMessage         string      `json:"error_message,omitempty"`
	CreatedAt            time.Time   `json:"created_at"`
	UpdatedAt            time.Time   `json:"updated_at"`
	DeletedAt            *time.Time  `json:"deleted_at,omitempty"`
}

// OriginalityCheckResult holds the result of validating a remix against the reference transcript.
type OriginalityCheckResult struct {
	SimilarityPercentage         float64  `json:"similarity_percentage"`
	CanonicalThresholdPercentage float64  `json:"canonical_threshold_percentage"` // 30.0%
	OriginalityScore             float64  `json:"originality_score"`
	Passed                       bool     `json:"passed"`
	Explanation                  string   `json:"explanation"`
	ActionableAlternatives       []string `json:"actionable_alternatives"`
}

// CopyrightCheckResult holds copyright detection and license verification for media.
type CopyrightCheckResult struct {
	MediaID           string   `json:"media_id"`
	MediaTitle        string   `json:"media_title"`
	IsCopyrighted     bool     `json:"is_copyrighted"`
	DetectedSongTitle string   `json:"detected_song_title,omitempty"`
	DetectedArtist    string   `json:"detected_artist,omitempty"`
	LicenseVerified   bool     `json:"license_verified"`
	LicenseKey        string   `json:"license_key,omitempty"`
	Passed            bool     `json:"passed"`
	CanBypassRisk     bool     `json:"can_bypass_risk"` // strictly false for confirmed copyright infringements
	WarningMessage    string   `json:"warning_message,omitempty"`
	ActionableOptions []string `json:"actionable_options,omitempty"`
}

// MultiMergeTimelineItem represents a segment in Mode 3 Multi-Merge.
type MultiMergeTimelineItem struct {
	ItemID                    string  `json:"item_id"`
	AssetID                   string  `json:"asset_id"`
	OrderIndex                int     `json:"order_index"`
	DurationSeconds           float64 `json:"duration_seconds"`
	MediaType                 string  `json:"media_type"`         // video, image
	TransitionToNext          string  `json:"transition_to_next"` // ken_burns, crossfade, fade_in, cut, zoom, glitch
	TransitionDurationSeconds float64 `json:"transition_duration_seconds"`
	LicenseStatus             string  `json:"license_status"` // licensed, royalty_free, copyrighted_unverified, copyrighted_verified
	LicenseProofKey           string  `json:"license_proof_key,omitempty"`
}

// MultiMergeSettings configures Multi-Merge production.
type MultiMergeSettings struct {
	TargetDurationSeconds float64 `json:"target_duration_seconds"`
	AutoTransitions       bool    `json:"auto_transitions"`
	VoiceOverType         string  `json:"voice_over_type"` // none, character_tts, upload, record
	VoiceOverCharacterID  string  `json:"voice_over_character_id,omitempty"`
	MusicSource           string  `json:"music_source"` // none, ai_select, library, upload
	MusicAssetID          string  `json:"music_asset_id,omitempty"`
	MusicLicenseProof     string  `json:"music_license_proof,omitempty"`
	AspectRatio           string  `json:"aspect_ratio"` // 9:16, 16:9, 1:1
	Pacing                string  `json:"pacing"`       // fast, medium, slow
}

// VideoEditJobRecord represents a row in video_edit_jobs (§22.1).
type VideoEditJobRecord struct {
	JobID              string                `json:"job_id"`
	WorkspaceID        string                `json:"workspace_id"`
	Mode               string                `json:"mode"` // quick_edit, clip_factory, multi_merge, remix, etc.
	SourceAssetIDs     []string              `json:"source_asset_ids"`
	OutputAssetIDs     []string              `json:"output_asset_ids"`
	GenerationJobID    string                `json:"generation_job_id,omitempty"`
	CharacterID        string                `json:"character_id,omitempty"`
	BrandPackID        string                `json:"brand_pack_id,omitempty"`
	Status             string                `json:"status"` // queued, processing, completed, partially_completed, failed, cancelled
	InputParamsJSON    string                `json:"input_params_json"`
	OutputMetadataJSON string                `json:"output_metadata_json"`
	CreditsEstimated   tenantdb.ExactDecimal `json:"credits_estimated"`
	CreditsUsed        tenantdb.ExactDecimal `json:"credits_used"`
	ActualCostUSD      tenantdb.ExactDecimal `json:"actual_cost_usd"`
	ErrorMessage       string                `json:"error_message,omitempty"`
	StartedAt          *time.Time            `json:"started_at,omitempty"`
	CompletedAt        *time.Time            `json:"completed_at,omitempty"`
	CreatedBy          string                `json:"created_by,omitempty"`
	CreatedAt          time.Time             `json:"created_at"`
	UpdatedAt          time.Time             `json:"updated_at"`
	DeletedAt          *time.Time            `json:"deleted_at,omitempty"`
}

// ViralityBreakdownRecord stores the 5 components of virality scoring (§Mode 2).
type ViralityBreakdownRecord struct {
	EngagementPatternMatch float64 `json:"engagement_pattern_match"` // 30% weight
	HookStrength           float64 `json:"hook_strength"`            // 25% weight
	PacingScore            float64 `json:"pacing_score"`             // 20% weight
	AudioQuality           float64 `json:"audio_quality"`            // 15% weight
	ContentRelevance       float64 `json:"content_relevance"`        // 10% weight
	HasTrendData           bool    `json:"has_trend_data"`           // false -> badge="⚠️ Pattern-only"
	Badge                  string  `json:"badge"`
	HookAnalysisMethod     string  `json:"hook_analysis_method"` // "speech_asr" | "visual_beat_pattern"
	TotalScore             float64 `json:"total_score"`          // 0-100
}

// ClipDataRecord represents an individual clip proposal inside clip_collections.clip_data (§22.3).
type ClipDataRecord struct {
	ClipID               string                  `json:"clip_id"`
	ClipIndex            int                     `json:"clip_index"`
	StartS               float64                 `json:"start_s"`
	EndS                 float64                 `json:"end_s"`
	DurationS            float64                 `json:"duration_s"`
	Title                string                  `json:"title"`
	ViralityScore        float64                 `json:"virality_score"`
	Selected             bool                    `json:"selected"`
	HookType             string                  `json:"hook_type"`
	PacingLabel          string                  `json:"pacing_label"`
	ScriptSnippet        string                  `json:"script_snippet"`
	IsVisualOnlyFallback bool                    `json:"is_visual_only_fallback"`
	HasTrendData         bool                    `json:"has_trend_data"`
	Badge                string                  `json:"badge"`
	Highlights           []string                `json:"highlights,omitempty"`
	Breakdown            ViralityBreakdownRecord `json:"breakdown"`
	SourceAssetID        string                  `json:"source_asset_id"`
	ThumbnailURL         string                  `json:"thumbnail_url,omitempty"`
}

// ClipCollectionRecord represents a row in clip_collections (§22.3).
type ClipCollectionRecord struct {
	CollectionID   string           `json:"collection_id"`
	WorkspaceID    string           `json:"workspace_id"`
	SourceAssetID  string           `json:"source_asset_id"`
	VideoEditJobID string           `json:"video_edit_job_id,omitempty"`
	TotalClips     int              `json:"total_clips"`
	ClipData       []ClipDataRecord `json:"clip_data"`
	Status         string           `json:"status"` // analyzing, proposed, processing, completed, failed
	HasTrendData   bool             `json:"has_trend_data"`
	IsVisualOnly   bool             `json:"is_visual_only"`
	CreatedAt      time.Time        `json:"created_at"`
	UpdatedAt      time.Time        `json:"updated_at"`
	DeletedAt      *time.Time       `json:"deleted_at,omitempty"`
}

// ----------------------------------------------------------------------------
// Style Learning, Character Preview & Drift QA Types (M07 EF-07 & M08)
// ----------------------------------------------------------------------------

// Domain errors for P4-07.
var (
	ErrHighDriftBlocksReadiness = errors.New("high drift blocks asset readiness: asset has high drift and unresolved blocking violation; requires Manager+ override with explicit reason")
	ErrOverrideReasonRequired   = errors.New("explicit override reason is required to unblock high drift violation")
	ErrConsentNotVerified       = errors.New("digital twin consent has not been verified")
	ErrStylePackNotFound        = errors.New("style pack not found")
	ErrStylePackDeleted         = errors.New("style pack has been deleted")
	ErrInvalidPreviewDuration   = errors.New("preview duration must be between 1 and 30 seconds (standard 15s)")
	ErrInvalidReferenceVideos   = errors.New("style extraction requires 1 to 5 reference videos")
	ErrContinuityPackNotFound   = errors.New("continuity pack not found")
	ErrViolationNotFound        = errors.New("continuity violation not found")
)

// DomainEvent represents an emitted domain event per domain_event_catalog.md §5, §15.
type DomainEvent struct {
	EventType   string
	WorkspaceID string
	Payload     map[string]any
	OccurredAt  time.Time
}

// StylePackRecord represents a learned editing style pack (database_schema.md §22.7).
type StylePackRecord struct {
	StylePackID        string     `json:"style_pack_id"`
	WorkspaceID        string     `json:"workspace_id"`
	Name               string     `json:"name"`
	SourceAssetID      string     `json:"source_asset_id"`
	ExtractedStyleJSON string     `json:"extracted_style_json"`
	IsActive           bool       `json:"is_active"`
	ContinuityPackID   string     `json:"continuity_pack_id,omitempty"`
	CreatedAt          time.Time  `json:"created_at"`
	UpdatedAt          time.Time  `json:"updated_at"`
	DeletedAt          *time.Time `json:"deleted_at,omitempty"`
}

// StyleElementsDomain captures 7 extracted styling parameters (Screen W032).
type StyleElementsDomain struct {
	ColorPalette     string   `json:"color_palette"`
	CutPacing        string   `json:"cut_pacing"`
	TextStyle        string   `json:"text_style"`
	MusicStyle       string   `json:"music_style"`
	Transitions      string   `json:"transitions"`
	HookPattern      string   `json:"hook_pattern"`
	VisualMood       string   `json:"visual_mood"`
	AvgCutDurationMs int32    `json:"avg_cut_duration_ms"`
	ColorPaletteHex  []string `json:"color_palette_hex"`
}

// ContinuityViolationRecord represents a row in continuity_violations (§7.5).
type ContinuityViolationRecord struct {
	ViolationID    string     `json:"violation_id"`
	WorkspaceID    string     `json:"workspace_id"`
	AssetID        string     `json:"asset_id"`
	PackID         string     `json:"pack_id"`
	ViolationType  string     `json:"violation_type"` // visual_drift, voice_drift, brand_drift, style_drift
	Severity       string     `json:"severity"`       // warning, blocking
	Description    string     `json:"description"`
	DriftScore     float32    `json:"drift_score"`
	Resolved       bool       `json:"resolved"`
	ResolvedBy     string     `json:"resolved_by,omitempty"`
	ResolvedAt     *time.Time `json:"resolved_at,omitempty"`
	OverrideReason string     `json:"override_reason,omitempty"`
	CreatedAt      time.Time  `json:"created_at"`
	DeletedAt      *time.Time `json:"deleted_at,omitempty"`
}

// DriftEvaluationDomain represents the result of evaluating asset drift against canonical references.
type DriftEvaluationDomain struct {
	AssetID          string   `json:"asset_id"`
	PackID           string   `json:"pack_id"`
	PackVersion      int32    `json:"pack_version"`
	DriftScore       float32  `json:"drift_score"`
	DriftSeverity    string   `json:"drift_severity"` // none, low_drift, moderate_drift, high_drift
	IsBlocked        bool     `json:"is_blocked"`
	ViolationReasons []string `json:"violation_reasons"`
	DetailsJSON      string   `json:"details_json"`
	ViolationID      string   `json:"violation_id,omitempty"`
}

// ProductionCharacter represents a character avatar for video generation and previews.
type ProductionCharacter struct {
	CharacterID        string
	WorkspaceID        string
	Name               string
	CharacterType      string // digital_twin, ai_generated, stock
	Description        string
	ConsentVerified    bool
	ConsentRecordID    string
	IsDefault          bool
	Status             string // creating, ready, failed, archived
	CharacterPackID    string
	VisualSettingsJSON string
	VoiceSettingsJSON  string
	CreatedAt          time.Time
	UpdatedAt          time.Time
}

// ProductionConsentRecord represents a legally binding consent record.
type ProductionConsentRecord struct {
	ConsentID   string
	UserID      string
	WorkspaceID string
	ConsentType string
	Version     string
	Granted     bool
	GrantedAt   *time.Time
	RevokedAt   *time.Time
}

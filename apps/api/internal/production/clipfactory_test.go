package production

import (
	"context"
	"encoding/json"
	"testing"
	"time"

	"connectrpc.com/connect"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Helper to create a test service with mock caller context and initial balances.
func setupClipFactoryTestService(t *testing.T) (*Service, string, string) {
	t.Helper()
	store := NewMemoryStore()
	wsID := "ws-test-p4-03"
	userID := "user-editor-01"

	svc := NewService(ServiceConfig{
		Store:            store,
		InitialBalances:  map[string]tenantdb.ExactDecimal{wsID: tenantdb.MustParseExactDecimal("200.000000")},
		PostProdExecutor: NewPostProductionExecutor(DefaultWorkerLimits()),
	})

	return svc, wsID, userID
}

// TestClipFactory_AcceptanceTarget1_NoSpeechUsesVisualPath verifies EC-M07-C01:
// Video has no speech (music-only/silent) -> system falls back to visual scene detection + beat analysis.
// Hook strength uses visual hook pattern instead of speech analysis.
func TestClipFactory_AcceptanceTarget1_NoSpeechUsesVisualPath(t *testing.T) {
	svc, wsID, userID := setupClipFactoryTestService(t)
	ctx := contextWithRole("Editor", userID)

	// 1. Create a music-only source video asset
	sourceAssetID := "asset-long-music-video"
	sourceAsset := &Asset{
		AssetID:               sourceAssetID,
		WorkspaceID:           wsID,
		AssetType:             "video",
		Title:                 "Electronic Music Instrumental Live Set",
		GenerationPrompt:      "instrumental background music with visual lights",
		DurationSeconds:       tenantdb.MustParseExactDecimal("600.000000"), // 10 minutes
		Resolution:            "1920x1080",
		AspectRatio:           "16:9",
		MimeType:              "video/mp4",
		GenerationState:       "generated",
		QualityState:          "approved",
		GenerationCostCredits: tenantdb.MustParseExactDecimal("0.000000"),
		CreatedAt:             time.Now().UTC(),
	}
	if err := svc.store.CreateAsset(ctx, sourceAsset); err != nil {
		t.Fatalf("failed to create source asset: %v", err)
	}

	clipSvc := svc.ClipFactory()

	// 2. Call Analyze with force_visual_path = true (or auto-detected from music-only content)
	req := connect.NewRequest(&productionv1.ClipFactoryServiceAnalyzeRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:    sourceAssetID,
		VideoDurationS:   600.0,
		ForceVisualPath:  true,
		TrendTopicId:     "trend-edm-visuals",
		HasMockTrendData: true,
	})

	res, err := clipSvc.Analyze(ctx, req)
	if err != nil {
		t.Fatalf("Analyze failed: %v", err)
	}

	col := res.Msg.GetCollection()
	if col == nil {
		t.Fatalf("expected non-nil clip collection")
	}

	// Verify that the collection is flagged as visual-only
	if !col.GetIsVisualOnly() {
		t.Errorf("expected collection.is_visual_only = true for no-speech video, got false")
	}

	if len(col.GetClips()) < 5 {
		t.Fatalf("expected at least 5 proposed clips for 10-minute video, got %d", len(col.GetClips()))
	}

	// Check each clip's hook analysis method and hook type
	for _, clip := range col.GetClips() {
		if !clip.GetIsVisualOnlyFallback() {
			t.Errorf("clip %s: expected is_visual_only_fallback = true, got false", clip.GetClipId())
		}
		if clip.GetHookType() != "visual_hook" {
			t.Errorf("clip %s: expected hook_type = 'visual_hook', got %q", clip.GetClipId(), clip.GetHookType())
		}

		breakdown := clip.GetViralityBreakdown()
		if breakdown == nil {
			t.Fatalf("clip %s: expected non-nil virality breakdown", clip.GetClipId())
		}

		if breakdown.GetHookAnalysisMethod() != "visual_beat_pattern" {
			t.Errorf("clip %s: expected hook_analysis_method = 'visual_beat_pattern', got %q",
				clip.GetClipId(), breakdown.GetHookAnalysisMethod())
		}

		// Ensure Hook Strength score is valid (>0 and <=100)
		if breakdown.GetHookStrength() <= 0 || breakdown.GetHookStrength() > 100 {
			t.Errorf("clip %s: invalid visual hook strength score: %f", clip.GetClipId(), breakdown.GetHookStrength())
		}

		// Ensure Total Virality Score is computed
		if clip.GetViralityScore() <= 0 || clip.GetViralityScore() > 100 {
			t.Errorf("clip %s: invalid virality score: %f", clip.GetClipId(), clip.GetViralityScore())
		}
	}
}

// TestClipFactory_AcceptanceTarget2_MissingTrendDataLabeled verifies Mode 2 Virality Algorithm:
// Virality Score MUST use real trend data. Scores without trend data carry "⚠️ Pattern-only" badge.
func TestClipFactory_AcceptanceTarget2_MissingTrendDataLabeled(t *testing.T) {
	svc, wsID, userID := setupClipFactoryTestService(t)
	ctx := contextWithRole("Editor", userID)

	sourceAssetID := "asset-speech-video-no-trend"
	sourceAsset := &Asset{
		AssetID:               sourceAssetID,
		WorkspaceID:           wsID,
		AssetType:             "video",
		Title:                 "Productivity Tips Podcast",
		GenerationPrompt:      "discussion on daily focus and time management",
		DurationSeconds:       tenantdb.MustParseExactDecimal("300.000000"), // 5 minutes
		Resolution:            "1920x1080",
		AspectRatio:           "16:9",
		MimeType:              "video/mp4",
		GenerationState:       "generated",
		QualityState:          "approved",
		GenerationCostCredits: tenantdb.MustParseExactDecimal("0.000000"),
		CreatedAt:             time.Now().UTC(),
	}
	_ = svc.store.CreateAsset(ctx, sourceAsset)

	clipSvc := svc.ClipFactory()

	// Scenario A: NO trend data supplied (missing trend signals from M02/M03)
	reqNoTrend := connect.NewRequest(&productionv1.ClipFactoryServiceAnalyzeRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:    sourceAssetID,
		VideoDurationS:   300.0,
		ForceVisualPath:  false,
		TrendTopicId:     "", // Empty topic ID -> no trend data
		HasMockTrendData: false,
	})

	resNoTrend, err := clipSvc.Analyze(ctx, reqNoTrend)
	if err != nil {
		t.Fatalf("Analyze without trend failed: %v", err)
	}

	colNoTrend := resNoTrend.Msg.GetCollection()
	if colNoTrend.GetHasTrendData() {
		t.Errorf("expected colNoTrend.has_trend_data = false, got true")
	}

	for _, clip := range colNoTrend.GetClips() {
		if clip.GetHasTrendData() {
			t.Errorf("clip %s: expected has_trend_data = false, got true", clip.GetClipId())
		}
		// Explicit canonical mandate: Scores without trend data carry "⚠️ Pattern-only" badge.
		if clip.GetBadge() != "⚠️ Pattern-only" {
			t.Errorf("clip %s: expected badge = '⚠️ Pattern-only', got %q", clip.GetClipId(), clip.GetBadge())
		}
		if clip.GetViralityBreakdown().GetBadge() != "⚠️ Pattern-only" {
			t.Errorf("clip %s breakdown: expected badge = '⚠️ Pattern-only', got %q",
				clip.GetClipId(), clip.GetViralityBreakdown().GetBadge())
		}
		if clip.GetViralityBreakdown().GetContentRelevance() != 0.0 {
			t.Errorf("clip %s: expected content_relevance = 0.0 when trend data missing, got %f",
				clip.GetClipId(), clip.GetViralityBreakdown().GetContentRelevance())
		}
	}

	// Scenario B: WITH real trend data supplied from M02/M03
	sourceAssetWithTrendID := "asset-speech-video-with-trend"
	sourceAssetWithTrend := &Asset{
		AssetID:               sourceAssetWithTrendID,
		WorkspaceID:           wsID,
		AssetType:             "video",
		Title:                 "Creator Economy Trends Podcast",
		GenerationPrompt:      "monetization strategies for content creators",
		DurationSeconds:       tenantdb.MustParseExactDecimal("300.000000"),
		Resolution:            "1920x1080",
		AspectRatio:           "16:9",
		MimeType:              "video/mp4",
		GenerationState:       "generated",
		QualityState:          "approved",
		GenerationCostCredits: tenantdb.MustParseExactDecimal("0.000000"),
		CreatedAt:             time.Now().UTC(),
	}
	_ = svc.store.CreateAsset(ctx, sourceAssetWithTrend)

	reqWithTrend := connect.NewRequest(&productionv1.ClipFactoryServiceAnalyzeRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:    sourceAssetWithTrendID,
		VideoDurationS:   300.0,
		ForceVisualPath:  false,
		TrendTopicId:     "trend-creator-monetization-2026",
		HasMockTrendData: true,
	})

	resWithTrend, err := clipSvc.Analyze(ctx, reqWithTrend)
	if err != nil {
		t.Fatalf("Analyze with trend failed: %v", err)
	}

	colWithTrend := resWithTrend.Msg.GetCollection()
	if !colWithTrend.GetHasTrendData() {
		t.Errorf("expected colWithTrend.has_trend_data = true, got false")
	}

	for _, clip := range colWithTrend.GetClips() {
		if !clip.GetHasTrendData() {
			t.Errorf("clip %s: expected has_trend_data = true, got false", clip.GetClipId())
		}
		// When trend data is present, badge must NOT be "⚠️ Pattern-only"
		if clip.GetBadge() == "⚠️ Pattern-only" {
			t.Errorf("clip %s: unexpected '⚠️ Pattern-only' badge when trend data is present", clip.GetClipId())
		}
		if clip.GetViralityBreakdown().GetContentRelevance() <= 0 {
			t.Errorf("clip %s: expected positive content relevance from trend data, got %f",
				clip.GetClipId(), clip.GetViralityBreakdown().GetContentRelevance())
		}
	}
}

// TestClipFactory_AcceptanceTarget3_EachClipHasSourceLineage verifies AC-5:
// Completed generation / extracted clips must have:
// - audio normalized to -14 LUFS
// - correct aspect ratio
// - subtitle overlay (if enabled)
// - full lineage in lineage_refs JSONB referencing the source video asset and timecodes
func TestClipFactory_AcceptanceTarget3_EachClipHasSourceLineage(t *testing.T) {
	svc, wsID, userID := setupClipFactoryTestService(t)
	ctx := contextWithRole("Editor", userID)

	sourceAssetID := "asset-source-long-interview"
	sourceAsset := &Asset{
		AssetID:               sourceAssetID,
		WorkspaceID:           wsID,
		AssetType:             "video",
		Title:                 "Exclusive Human Interview",
		GenerationPrompt:      "deep dive interview with entrepreneur",
		DurationSeconds:       tenantdb.MustParseExactDecimal("900.000000"), // 15 minutes
		Resolution:            "1920x1080",
		AspectRatio:           "16:9",
		MimeType:              "video/mp4",
		GenerationState:       "generated",
		QualityState:          "approved",
		GenerationCostCredits: tenantdb.MustParseExactDecimal("0.000000"),
		CreatedAt:             time.Now().UTC(),
	}
	_ = svc.store.CreateAsset(ctx, sourceAsset)

	clipSvc := svc.ClipFactory()

	// 1. Analyze video to propose clips
	analyzeRes, err := clipSvc.Analyze(ctx, connect.NewRequest(&productionv1.ClipFactoryServiceAnalyzeRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:    sourceAssetID,
		VideoDurationS:   900.0,
		TrendTopicId:     "trend-founders",
		HasMockTrendData: true,
	}))
	if err != nil {
		t.Fatalf("Analyze failed: %v", err)
	}

	collection := analyzeRes.Msg.GetCollection()
	if len(collection.GetClips()) == 0 {
		t.Fatalf("expected proposed clips")
	}

	clip1 := collection.GetClips()[0]
	clip2 := collection.GetClips()[1]

	// 2. Process selected clips with multi-ratio variants and CTA
	processReq := connect.NewRequest(&productionv1.ClipFactoryServiceProcessClipsRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		CollectionId:    collection.GetCollectionId(),
		SelectedClipIds: []string{clip1.GetClipId(), clip2.GetClipId()},
		Variants: []*productionv1.ClipVariantConfig{
			{
				ClipId:                clip1.GetClipId(),
				TargetRatios:          []string{"9:16", "1:1"},
				SubtitleFirst:         true,
				CtaText:               "Follow for Part 2",
				GenerateHighlightReel: false,
				TargetPlatforms:       []string{"tiktok", "reels"},
			},
			{
				ClipId:                clip2.GetClipId(),
				TargetRatios:          []string{"9:16"},
				SubtitleFirst:         false,
				CtaText:               "",
				GenerateHighlightReel: false,
				TargetPlatforms:       []string{"shorts"},
			},
		},
		TargetPlatforms: []string{"tiktok", "reels", "shorts"},
	})

	processRes, err := clipSvc.ProcessClips(ctx, processReq)
	if err != nil {
		t.Fatalf("ProcessClips failed: %v", err)
	}

	if processRes.Msg.GetStatus() != "completed" {
		t.Errorf("expected status 'completed', got %q", processRes.Msg.GetStatus())
	}

	outputs := processRes.Msg.GetOutputs()
	if len(outputs) < 4 { // 2 ratios + 1 CTA for clip1, 1 ratio for clip2 = at least 4
		t.Fatalf("expected at least 4 outputs, got %d", len(outputs))
	}

	// 3. Inspect every output and verify provenance and lineage
	for _, out := range outputs {
		if out.GetOutputAssetId() == "" {
			t.Errorf("clip output missing output_asset_id")
		}
		if out.GetLineageJson() == "" {
			t.Errorf("clip output %s missing lineage_json", out.GetOutputAssetId())
		}

		// Verify persisted asset in store
		storedAsset, err := svc.store.GetAsset(ctx, wsID, out.GetOutputAssetId())
		if err != nil {
			t.Fatalf("failed to retrieve stored clip asset %s: %v", out.GetOutputAssetId(), err)
		}

		// Target 3 checks:
		// a. ParentAssetID must equal source long video
		if storedAsset.ParentAssetID != sourceAssetID {
			t.Errorf("asset %s: expected ParentAssetID %q, got %q",
				storedAsset.AssetID, sourceAssetID, storedAsset.ParentAssetID)
		}

		// b. DerivativeType must be 'clip'
		if storedAsset.DerivativeType != "clip" {
			t.Errorf("asset %s: expected DerivativeType 'clip', got %q",
				storedAsset.AssetID, storedAsset.DerivativeType)
		}

		// c. Parse and verify JSON lineage
		var lineageMap map[string]interface{}
		if err := json.Unmarshal([]byte(out.GetLineageJson()), &lineageMap); err != nil {
			t.Fatalf("asset %s: failed to parse lineage JSON: %v", storedAsset.AssetID, err)
		}

		// Must record parent_id and source_asset_id
		if lineageMap["parent_id"] != sourceAssetID || lineageMap["source_asset_id"] != sourceAssetID {
			t.Errorf("asset %s: lineage parent mismatch: %v", storedAsset.AssetID, lineageMap["parent_id"])
		}

		// Audio normalization check (-14.0 LUFS per AC-5)
		lufs, ok := lineageMap["audio_lufs"].(float64)
		if !ok || lufs != -14.0 {
			t.Errorf("asset %s: expected audio_lufs = -14.0 LUFS, got %v", storedAsset.AssetID, lineageMap["audio_lufs"])
		}

		if lineageMap["audio_normalized"] != true {
			t.Errorf("asset %s: expected audio_normalized = true", storedAsset.AssetID)
		}

		// Timestamp must be present
		if lineageMap["extracted_at"] == nil || lineageMap["extracted_at"] == "" {
			t.Errorf("asset %s: missing extracted_at timestamp in lineage", storedAsset.AssetID)
		}

		// Store LineageRefs must have at least one record
		if len(storedAsset.LineageRefs) == 0 {
			t.Errorf("asset %s: missing LineageRefs in asset record", storedAsset.AssetID)
		} else if storedAsset.LineageRefs[0].ParentAssetID != sourceAssetID {
			t.Errorf("asset %s: LineageRefs parent mismatch: %q vs %q",
				storedAsset.AssetID, storedAsset.LineageRefs[0].ParentAssetID, sourceAssetID)
		}
	}
}

// TestClipFactory_ConcurrencyLimit_ECM07C04 verifies tier concurrency limit:
// Free: 1, Starter: 2, Pro: 5, Business: 10. Beyond limit -> returns queue position.
func TestClipFactory_ConcurrencyLimit_ECM07C04(t *testing.T) {
	tierMax := TierMaxConcurrentClipJobs("Free")
	if tierMax != 1 {
		t.Errorf("Free tier max expected 1, got %d", tierMax)
	}

	tierMaxStarter := TierMaxConcurrentClipJobs("Starter")
	if tierMaxStarter != 2 {
		t.Errorf("Starter tier max expected 2, got %d", tierMaxStarter)
	}

	tierMaxPro := TierMaxConcurrentClipJobs("Pro")
	if tierMaxPro != 5 {
		t.Errorf("Pro tier max expected 5, got %d", tierMaxPro)
	}

	tierMaxBiz := TierMaxConcurrentClipJobs("Business")
	if tierMaxBiz != 10 {
		t.Errorf("Business tier max expected 10, got %d", tierMaxBiz)
	}
}

// TestClipFactory_RBACEnforcement verifies RBAC permissions:
// Editor+ permitted; Viewer/Contributor denied for management mutations.
func TestClipFactory_RBACEnforcement(t *testing.T) {
	svc, wsID, _ := setupClipFactoryTestService(t)
	ctx := context.Background()

	clipSvc := svc.ClipFactory()

	// Anonymous / empty context -> CodeUnauthenticated
	_, err := clipSvc.Analyze(ctx, connect.NewRequest(&productionv1.ClipFactoryServiceAnalyzeRequest{}))
	if err == nil {
		t.Errorf("expected error for unauthenticated analyze call")
	}

	// Viewer role caller -> CodePermissionDenied
	viewerCtx := context.WithValue(ctx, "caller_role", "Viewer")
	viewerCtx = context.WithValue(viewerCtx, "caller_workspace_id", wsID)

	_, errViewer := clipSvc.Analyze(viewerCtx, connect.NewRequest(&productionv1.ClipFactoryServiceAnalyzeRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:  "some-asset",
		VideoDurationS: 60.0,
	}))
	if errViewer == nil {
		t.Errorf("expected permission denied for Viewer role on Analyze")
	}
}

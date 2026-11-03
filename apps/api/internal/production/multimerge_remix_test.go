package production

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// ============================================================================
// Acceptance Target 1: One canonical similarity threshold (<30%)
// ============================================================================

func TestRemixOriginality_OneCanonicalThreshold(t *testing.T) {
	// RULE-M07-003, PRD §23.7, Pack 04 §9.5.6: Strictly < 30.0% script similarity.
	// There is NO separate 70% threshold.
	if CanonicalScriptSimilarityThreshold != 30.0 {
		t.Fatalf("expected CanonicalScriptSimilarityThreshold to be 30.0, got %f", CanonicalScriptSimilarityThreshold)
	}
}

func TestRemixOriginality_PassBelow30Percent(t *testing.T) {
	svc, store, _, _ := setupTestService(t)
	remixSvc := svc.Remix()
	ctx := contextWithRole("Editor", "user-remix-1")
	wsID := "ws-test-01"

	initBal := svc.GetWorkspaceBalance(wsID)

	// 1. Analyze reference URL
	analyzeRes, err := remixSvc.Analyze(ctx, connect.NewRequest(&productionv1.RemixServiceAnalyzeRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		ReferenceUrl: "https://example.com/reference-marketing-clip.mp4",
	}))
	if err != nil {
		t.Fatalf("Analyze failed: %v", err)
	}

	blueprintID := analyzeRes.Msg.GetBlueprint().GetBlueprintId()
	if blueprintID == "" {
		t.Fatal("expected non-empty blueprint ID")
	}

	// 2. Generate with LOW similarity (original script distinct from reference)
	genRes, err := remixSvc.Generate(ctx, connect.NewRequest(&productionv1.RemixServiceGenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		BlueprintId:   blueprintID,
		FidelityLevel: productionv1.FidelityLevel_FIDELITY_LEVEL_LOOSE,
		EditedScript:  "Completely different angle: Focus on automated workflow efficiency for remote enterprise teams.",
	}))
	if err != nil {
		t.Fatalf("Generate should succeed when similarity < 30%%: %v", err)
	}

	origCheck := genRes.Msg.GetOriginalityCheck()
	if !origCheck.GetPassed() {
		t.Fatalf("expected originality check to pass, got failed: %s", origCheck.GetExplanation())
	}
	if origCheck.GetSimilarityPercentage() >= 30.0 {
		t.Fatalf("expected script similarity < 30.0, got %f", origCheck.GetSimilarityPercentage())
	}
	if origCheck.GetOriginalityScore() <= 70.0 {
		t.Fatalf("expected originality score > 70.0, got %f", origCheck.GetOriginalityScore())
	}

	// Verify credits were deducted (8 credits for analyze + 35 credits for generate = 43 credits)
	expectedBal, _ := initBal.Sub(tenantdb.MustParseExactDecimal("43.000000"))
	currentBal := svc.GetWorkspaceBalance(wsID)
	if currentBal.Cmp(expectedBal) != 0 {
		t.Fatalf("expected balance %s, got %s", expectedBal.String(), currentBal.String())
	}

	// Verify blueprint updated in store
	bp, err := store.GetRemixBlueprint(ctx, wsID, blueprintID)
	if err != nil {
		t.Fatalf("failed to get blueprint: %v", err)
	}
	if bp.Status != "generated" {
		t.Fatalf("expected status 'generated', got %s", bp.Status)
	}
	if bp.OriginalityScore <= 70.0 {
		t.Fatalf("expected blueprint originality score > 70.0, got %f", bp.OriginalityScore)
	}
}

func TestRemixOriginality_BlockAtOrAbove30Percent(t *testing.T) {
	svc, store, _, _ := setupTestService(t)
	remixSvc := svc.Remix()
	ctx := contextWithRole("Editor", "user-remix-2")
	wsID := "ws-test-01"

	initBal := svc.GetWorkspaceBalance(wsID)

	// Create a blueprint directly with reference transcript
	refTranscript := "Transform your digital workflow today with our cloud-native AI platform for creators."
	bpID := "bp-test-high-similarity"
	now := time.Now().UTC()
	err := store.CreateRemixBlueprint(ctx, &RemixBlueprint{
		BlueprintID:         bpID,
		WorkspaceID:         wsID,
		ReferenceURL:        "https://example.com/source.mp4",
		ReferenceTranscript: refTranscript,
		Status:              "analyzed",
		RemixScript:         refTranscript,
		CreativeDNA:         CreativeDNA{HookType: "Question"},
		CreatedAt:           now,
		UpdatedAt:           now,
	})
	if err != nil {
		t.Fatalf("failed to create blueprint: %v", err)
	}

	// Generate with nearly identical script (similarity >= 30%)
	identicalPrompt := "Transform your digital workflow today with our cloud-native AI platform for creators."
	genRes, err := remixSvc.Generate(ctx, connect.NewRequest(&productionv1.RemixServiceGenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		BlueprintId:   bpID,
		FidelityLevel: productionv1.FidelityLevel_FIDELITY_LEVEL_MATCH_1TO1,
		EditedScript:  identicalPrompt,
	}))

	if err != nil {
		t.Fatalf("expected response with rejected originality check, got RPC error: %v", err)
	}

	origCheck := genRes.Msg.GetOriginalityCheck()
	if origCheck.GetPassed() {
		t.Fatal("expected originality check to fail (similarity >= 30%)")
	}
	if genRes.Msg.GetBlueprint().GetStatus() != productionv1.RemixStatus_REMIX_STATUS_REJECTED {
		t.Fatalf("expected blueprint status to be REMIX_STATUS_REJECTED, got %v", genRes.Msg.GetBlueprint().GetStatus())
	}
	if genRes.Msg.GetCreditsDeducted() != "0.000000" {
		t.Fatalf("credits should NOT be charged when originality gate fails; expected 0, got %s", genRes.Msg.GetCreditsDeducted())
	}
	if len(origCheck.GetActionableAlternatives()) == 0 {
		t.Fatal("expected actionable alternatives to be returned on rejection")
	}

	// Verify credits were NOT charged
	currentBal := svc.GetWorkspaceBalance(wsID)
	if currentBal.Cmp(initBal) != 0 {
		t.Fatalf("credits should NOT be charged when originality gate fails; expected %s, got %s", initBal.String(), currentBal.String())
	}

	// Verify blueprint status in store is marked rejected
	bp, err := store.GetRemixBlueprint(ctx, wsID, bpID)
	if err != nil {
		t.Fatalf("failed to get blueprint: %v", err)
	}
	if bp.Status != "rejected" {
		t.Fatalf("blueprint status in store should be 'rejected', got %s", bp.Status)
	}
}

func TestRemixOriginality_ExactBoundary(t *testing.T) {
	threshold := CanonicalScriptSimilarityThreshold

	// Boundary condition 1: 29.9%
	simPass := 29.9
	passed1 := simPass < threshold
	if !passed1 {
		t.Errorf("expected 29.9%% similarity to PASS originality gate (threshold: %.1f%%)", threshold)
	}

	// Boundary condition 2: 30.0%
	simExact := 30.0
	passed2 := simExact < threshold
	if passed2 {
		t.Errorf("expected 30.0%% similarity to FAIL originality gate (strictly < 30%% required)")
	}

	// Boundary condition 3: 30.1%
	simFail := 30.1
	passed3 := simFail < threshold
	if passed3 {
		t.Errorf("expected 30.1%% similarity to FAIL originality gate")
	}

	// Functional test of CheckOriginality:
	// 1. Identical text should fail completely (~100% similarity)
	ref := "Unlocking rapid video creation using artificial intelligence models"
	identical := "Unlocking rapid video creation using artificial intelligence models"
	resFail := CheckOriginality(ref, identical)
	if resFail.Passed {
		t.Fatal("expected CheckOriginality to fail for identical script")
	}
	if len(resFail.ActionableAlternatives) == 0 {
		t.Fatal("expected actionable alternatives on failure")
	}
	if !strings.Contains(resFail.Explanation, "too similar") {
		t.Fatalf("expected explanation to mention 'too similar', got: %s", resFail.Explanation)
	}

	// 2. Completely distinct text should pass (0% similarity)
	distinct := "Organic coffee brewing guide for early morning pour-over enthusiasts"
	resPass := CheckOriginality(ref, distinct)
	if !resPass.Passed {
		t.Fatalf("expected CheckOriginality to pass for distinct script, got failed: %s", resPass.Explanation)
	}
	if resPass.SimilarityPercentage >= CanonicalScriptSimilarityThreshold {
		t.Fatalf("expected similarity < 30.0%%, got %.2f%%", resPass.SimilarityPercentage)
	}
}

// ============================================================================
// Acceptance Target 2: No unlicensed media bypass
// ============================================================================

func TestMultiMerge_UnlicensedCopyrightBlocked(t *testing.T) {
	svc, _, _, _ := setupTestService(t)
	editSvc := svc.VideoEditJob()
	ctx := contextWithRole("Editor", "user-mm-1")
	wsID := "ws-test-01"

	// Timeline with copyrighted audio track and NO license proof
	timeline := []*productionv1.MultiMergeTimelineItem{
		{
			ItemId:          "item-1",
			AssetId:         "asset-video-1",
			OrderIndex:      0,
			MediaType:       "video",
			DurationSeconds: 5.0,
		},
		{
			ItemId:          "item-2",
			AssetId:         "audio-copyrighted",
			OrderIndex:      1,
			MediaType:       "audio",
			DurationSeconds: 10.0,
			LicenseProofKey: "", // NO license proof!
		},
	}

	// Regular submission attempt
	_, err := editSvc.Create(ctx, connect.NewRequest(&productionv1.VideoEditJobServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Mode:          productionv1.ProductionMode_PRODUCTION_MODE_MULTI_MERGE,
		TimelineItems: timeline,
	}))

	if err == nil {
		t.Fatal("expected unlicensed media to be blocked, but create succeeded")
	}

	connectErr, ok := err.(*connect.Error)
	if !ok {
		t.Fatalf("expected connect.Error, got %T: %v", err, err)
	}
	if connectErr.Code() != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument, got %v", connectErr.Code())
	}
	if !strings.Contains(connectErr.Message(), "unlicensed") || !strings.Contains(connectErr.Message(), "bypass not permitted") {
		t.Fatalf("expected error message to mention unlicensed copyrighted media blocked, got: %s", connectErr.Message())
	}

	// CheckMediaCopyright direct test: verifying risk cannot be acknowledged away (SAFE-2026-02)
	copyrightRes := CheckMediaCopyright("audio-copyrighted", "")
	if copyrightRes.Passed {
		t.Fatal("expected copyright check to fail")
	}
	if copyrightRes.CanBypassRisk {
		t.Fatal("SAFE-2026-02 violation: CanBypassRisk must be false for hard copyright hits")
	}
}

func TestMultiMerge_LicensedAudioAllowed(t *testing.T) {
	svc, _, _, _ := setupTestService(t)
	editSvc := svc.VideoEditJob()
	ctx := contextWithRole("Editor", "user-mm-2")
	wsID := "ws-test-01"

	// Timeline with copyrighted audio track WITH valid license proof
	timeline := []*productionv1.MultiMergeTimelineItem{
		{
			ItemId:          "item-1",
			AssetId:         "asset-video-1",
			OrderIndex:      0,
			MediaType:       "video",
			DurationSeconds: 5.0,
		},
		{
			ItemId:          "item-2",
			AssetId:         "audio-copyrighted",
			OrderIndex:      1,
			MediaType:       "audio",
			DurationSeconds: 10.0,
			LicenseProofKey: "https://licensing.example.com/certs/AUTH-9921", // Valid license!
		},
	}

	res, err := editSvc.Create(ctx, connect.NewRequest(&productionv1.VideoEditJobServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Mode:          productionv1.ProductionMode_PRODUCTION_MODE_MULTI_MERGE,
		TimelineItems: timeline,
	}))

	if err != nil {
		t.Fatalf("expected licensed media to be allowed, got error: %v", err)
	}
	if res.Msg.GetJob().GetJobId() == "" {
		t.Fatal("expected valid job ID for licensed multi-merge job")
	}
}

func TestMultiMerge_TierLimits(t *testing.T) {
	// Free: 5, Starter: 10, Pro: 20, Business: 50
	if TierMaxInputs("free") != 5 {
		t.Errorf("expected Free tier max 5, got %d", TierMaxInputs("free"))
	}
	if TierMaxInputs("starter") != 10 {
		t.Errorf("expected Starter tier max 10, got %d", TierMaxInputs("starter"))
	}
	if TierMaxInputs("pro") != 20 {
		t.Errorf("expected Pro tier max 20, got %d", TierMaxInputs("pro"))
	}
	if TierMaxInputs("business") != 50 {
		t.Errorf("expected Business tier max 50, got %d", TierMaxInputs("business"))
	}

	// Validate min 2 files
	singleItem := []MultiMergeTimelineItem{
		{AssetID: "asset-1", MediaType: "video", DurationSeconds: 5.0},
	}
	resSingle := ValidateMultiMergeTimeline("free", singleItem, MultiMergeSettings{})
	if resSingle.IsValid {
		t.Fatal("expected single item timeline to be invalid (minimum 2 required)")
	}

	// Validate Free tier exceeding 5 items
	sixItems := make([]MultiMergeTimelineItem, 6)
	for i := range sixItems {
		sixItems[i] = MultiMergeTimelineItem{
			AssetID:         fmt.Sprintf("asset-%d", i),
			MediaType:       "video",
			DurationSeconds: 2.0,
		}
	}
	resExceeded := ValidateMultiMergeTimeline("free", sixItems, MultiMergeSettings{})
	if resExceeded.IsValid {
		t.Fatal("expected 6 items to exceed Free tier limit of 5")
	}

	// Same 6 items should pass for Starter tier (limit 10)
	resStarter := ValidateMultiMergeTimeline("starter", sixItems, MultiMergeSettings{})
	if !resStarter.IsValid {
		t.Fatalf("expected 6 items to pass for starter tier, got errors: %v", resStarter.Errors)
	}
}

func TestMultiMerge_AutoTransitions(t *testing.T) {
	items := []MultiMergeTimelineItem{
		{AssetID: "img-1", MediaType: "image", DurationSeconds: 3.0},
		{AssetID: "img-2", MediaType: "image", DurationSeconds: 3.0},
		{AssetID: "vid-1", MediaType: "video", DurationSeconds: 5.0},
		{AssetID: "vid-2", MediaType: "video", DurationSeconds: 5.0},
	}

	settings := MultiMergeSettings{AutoTransitions: true}
	res := ValidateMultiMergeTimeline("pro", items, settings)
	if !res.IsValid {
		t.Fatalf("timeline should be valid: %v", res.Errors)
	}

	// Check transitions assigned
	// Image -> Image => ken_burns
	if items[0].TransitionToNext != "ken_burns" {
		t.Errorf("expected Image->Image transition 'ken_burns', got '%s'", items[0].TransitionToNext)
	}
	// Image -> Video => fade_in
	if items[1].TransitionToNext != "fade_in" {
		t.Errorf("expected Image->Video transition 'fade_in', got '%s'", items[1].TransitionToNext)
	}
	// Video -> Video => crossfade
	if items[2].TransitionToNext != "crossfade" {
		t.Errorf("expected Video->Video transition 'crossfade', got '%s'", items[2].TransitionToNext)
	}
}

// ============================================================================
// Acceptance Target 3: Foreign/DRM source has usable error
// ============================================================================

func TestRemix_DRMProtectedURLError(t *testing.T) {
	svc, _, _, _ := setupTestService(t)
	remixSvc := svc.Remix()
	ctx := contextWithRole("Editor", "user-remix-drm")
	wsID := "ws-test-01"

	drmURLs := []string{
		"https://www.netflix.com/watch/81234567",
		"https://video.example.com/stream?drm=widevine",
		"https://example.com/protected.mp4?drm=fairplay",
		"widevine://content-server/asset-01",
	}

	for _, u := range drmURLs {
		_, err := remixSvc.Analyze(ctx, connect.NewRequest(&productionv1.RemixServiceAnalyzeRequest{
			Context: &commonv1.CommandContext{
				WorkspaceId: &commonv1.UUID{Value: wsID},
			},
			ReferenceUrl: u,
		}))

		if err == nil {
			t.Fatalf("expected DRM URL '%s' to fail, but it succeeded", u)
		}

		connectErr, ok := err.(*connect.Error)
		if !ok {
			t.Fatalf("expected connect.Error, got %T: %v", err, err)
		}
		if connectErr.Code() != connect.CodeInvalidArgument {
			t.Fatalf("expected CodeInvalidArgument for DRM URL, got %v", connectErr.Code())
		}

		// Actionable copy verification per EC-M07-R01
		if !strings.Contains(connectErr.Message(), "Cannot access video at this URL") {
			t.Fatalf("expected error message to contain actionable copy 'Cannot access video at this URL', got: %s", connectErr.Message())
		}
		if !strings.Contains(connectErr.Message(), "Upload video file instead") {
			t.Fatalf("expected error message to suggest uploading video file instead, got: %s", connectErr.Message())
		}
	}
}

func TestRemix_GeoBlockedURLError(t *testing.T) {
	svc, _, _, _ := setupTestService(t)
	remixSvc := svc.Remix()
	ctx := contextWithRole("Editor", "user-remix-geo")
	wsID := "ws-test-01"

	geoURL := "https://hulu.com/watch/georestricted-content"

	_, err := remixSvc.Analyze(ctx, connect.NewRequest(&productionv1.RemixServiceAnalyzeRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		ReferenceUrl: geoURL,
	}))

	if err == nil {
		t.Fatalf("expected geo-blocked URL '%s' to fail, but it succeeded", geoURL)
	}

	connectErr, ok := err.(*connect.Error)
	if !ok {
		t.Fatalf("expected connect.Error, got %T: %v", err, err)
	}
	if connectErr.Code() != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument for geo-blocked URL, got %v", connectErr.Code())
	}
	if !strings.Contains(connectErr.Message(), "geo-blocked") && !strings.Contains(connectErr.Message(), "geo-restricted") {
		t.Fatalf("expected geo-blocked mention in error, got: %s", connectErr.Message())
	}
}

func TestRemix_SSRFPrevention(t *testing.T) {
	ssrfTargets := []string{
		"http://localhost:8080/admin",
		"http://127.0.0.1:9090/metrics",
		"http://10.0.0.1/internal-api",
		"http://169.254.169.254/latest/meta-data/", // AWS metadata
		"http://[::1]:8080/status",
	}

	for _, target := range ssrfTargets {
		val := ValidateReferenceURL(target)
		if val.IsValid {
			t.Fatalf("SSRF vulnerability: %s should NOT be valid", target)
		}
		if !strings.Contains(val.ErrorMessage, "SSRF") && !strings.Contains(val.ErrorMessage, "blocked") {
			t.Fatalf("expected SSRF error message for %s, got: %s", target, val.ErrorMessage)
		}
	}
}

func TestVideoEditJob_LifecycleAndCancelRefund(t *testing.T) {
	svc, store, _, _ := setupTestService(t)
	editSvc := svc.VideoEditJob()
	ctx := contextWithRole("Editor", "user-edit-1")
	wsID := "ws-test-01"

	initBal := svc.GetWorkspaceBalance(wsID)

	// 1. Create a MultiMerge Job
	createRes, err := editSvc.Create(ctx, connect.NewRequest(&productionv1.VideoEditJobServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Mode: productionv1.ProductionMode_PRODUCTION_MODE_MULTI_MERGE,
		TimelineItems: []*productionv1.MultiMergeTimelineItem{
			{ItemId: "i-1", AssetId: "asset-1", OrderIndex: 0, MediaType: "video", DurationSeconds: 5.0},
			{ItemId: "i-2", AssetId: "asset-2", OrderIndex: 1, MediaType: "video", DurationSeconds: 5.0},
		},
	}))
	if err != nil {
		t.Fatalf("failed to create job: %v", err)
	}

	jobID := createRes.Msg.GetJob().GetJobId()
	if jobID == "" {
		t.Fatal("expected non-empty job ID")
	}

	// Cost was deducted (20 credits for multi_merge)
	expectedBalAfterCreate, _ := initBal.Sub(tenantdb.MustParseExactDecimal("20.000000"))
	if svc.GetWorkspaceBalance(wsID).Cmp(expectedBalAfterCreate) != 0 {
		t.Fatalf("expected balance %s after job creation, got %s", expectedBalAfterCreate.String(), svc.GetWorkspaceBalance(wsID).String())
	}

	// 2. Get Job
	getRes, err := editSvc.Get(ctx, connect.NewRequest(&productionv1.VideoEditJobServiceGetRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
		JobId:       jobID,
	}))
	if err != nil {
		t.Fatalf("failed to get job: %v", err)
	}
	if getRes.Msg.GetJob().GetJobId() != jobID {
		t.Fatalf("expected job ID %s, got %s", jobID, getRes.Msg.GetJob().GetJobId())
	}

	// 3. Cancel Job (§7.1: Cancels and refunds unspent credits)
	cancelRes, err := editSvc.Cancel(ctx, connect.NewRequest(&productionv1.VideoEditJobServiceCancelRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		JobId:  jobID,
		Reason: "User cancelled job",
	}))
	if err != nil {
		t.Fatalf("failed to cancel job: %v", err)
	}
	if cancelRes.Msg.GetJob().GetStatus() != productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_CANCELLED {
		t.Fatalf("cancel returned status %v, expected CANCELLED", cancelRes.Msg.GetJob().GetStatus())
	}
	if cancelRes.Msg.GetCreditsRefunded() == "" {
		t.Fatal("expected non-empty credits refunded string")
	}

	// Verify credits were refunded back to initBal
	if svc.GetWorkspaceBalance(wsID).Cmp(initBal) != 0 {
		t.Fatalf("expected balance to be restored to %s after cancellation refund, got %s", initBal.String(), svc.GetWorkspaceBalance(wsID).String())
	}

	// Verify job status in store
	job, err := store.GetVideoEditJob(ctx, wsID, jobID)
	if err != nil {
		t.Fatalf("failed to get job from store: %v", err)
	}
	if job.Status != "cancelled" {
		t.Fatalf("expected job status 'cancelled', got %s", job.Status)
	}

	// 4. List Jobs
	listRes, err := editSvc.List(ctx, connect.NewRequest(&productionv1.VideoEditJobServiceListRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
	}))
	if err != nil {
		t.Fatalf("failed to list jobs: %v", err)
	}
	if len(listRes.Msg.GetJobs()) == 0 {
		t.Fatal("expected at least 1 job in list response")
	}
}

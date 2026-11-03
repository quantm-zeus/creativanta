package production

import (
	"context"
	"errors"
	"strings"
	"sync"
	"testing"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
)

// ============================================================================
// Acceptance Target 1: Poor ASR can be repaired (EC-M07-Q01)
// ============================================================================

func TestASRRepairAndFallback_AcceptanceTarget1(t *testing.T) {
	ctx := context.Background()
	engine := NewASREngine()

	// 1. Initial simulated Whisper transcript with dialect errors and filler words
	// Vietnamese raw utterance: "Ừm xin chào các bạn ờ hôm nay mình sẽ chia sẻ trang cá nhân tạo"
	// ("trang cá nhân tạo" was misheard by ASR for "trang cá nhân")
	rawWords := []TranscriptWordRecord{
		{WordID: "w1", Text: "Ừm", StartMS: 500, EndMS: 900, Confidence: 0.95},
		{WordID: "w2", Text: "xin", StartMS: 1000, EndMS: 1300, Confidence: 0.98},
		{WordID: "w3", Text: "chào", StartMS: 1350, EndMS: 1650, Confidence: 0.99},
		{WordID: "w4", Text: "các", StartMS: 1700, EndMS: 1900, Confidence: 0.99},
		{WordID: "w5", Text: "bạn", StartMS: 1950, EndMS: 2200, Confidence: 0.97},
		// Dead pause: 2200ms -> 4000ms (1800ms silence > 1500ms threshold)
		{WordID: "w6", Text: "ờ", StartMS: 4000, EndMS: 4400, Confidence: 0.91},
		{WordID: "w7", Text: "hôm", StartMS: 4500, EndMS: 4750, Confidence: 0.96},
		{WordID: "w8", Text: "nay", StartMS: 4800, EndMS: 5050, Confidence: 0.97},
		{WordID: "w9", Text: "mình", StartMS: 5100, EndMS: 5350, Confidence: 0.98},
		{WordID: "w10", Text: "sẽ", StartMS: 5400, EndMS: 5600, Confidence: 0.95},
		{WordID: "w11", Text: "chia", StartMS: 5650, EndMS: 5900, Confidence: 0.99},
		{WordID: "w12", Text: "sẻ", StartMS: 5950, EndMS: 6200, Confidence: 0.98},
		// Misheard dialect words with lower confidence
		{WordID: "w13", Text: "trang", StartMS: 6300, EndMS: 6600, Confidence: 0.65},
		{WordID: "w14", Text: "cá", StartMS: 6650, EndMS: 6900, Confidence: 0.60},
		{WordID: "w15", Text: "nhân", StartMS: 6950, EndMS: 7200, Confidence: 0.55},
		{WordID: "w16", Text: "tạo", StartMS: 7250, EndMS: 7600, Confidence: 0.50}, // Extraneous hallucinated word
	}

	// 2. Parse initial transcript: detect fillers and dead pauses
	tagged, analysis := engine.ParseTranscript(rawWords, 1500)

	if analysis.FillerCount != 2 {
		t.Fatalf("expected 2 fillers (Ừm, ờ), got %d (%v)", analysis.FillerCount, analysis.DetectedFillers)
	}
	if analysis.PauseCount != 1 {
		t.Fatalf("expected 1 dead pause (1800ms), got %d", analysis.PauseCount)
	}
	if analysis.DeadPauses[0].DurationMS != 1800 {
		t.Fatalf("expected pause duration 1800ms, got %d", analysis.DeadPauses[0].DurationMS)
	}

	initialTranscript := &TranscriptRecord{
		TranscriptID:    "tr-001",
		WorkspaceID:     "ws-001",
		AssetID:         "asset-001",
		Language:        "vi",
		Words:           tagged,
		FillerCount:     analysis.FillerCount,
		PauseCount:      analysis.PauseCount,
		AlignmentStatus: "auto_aligned",
	}

	// 3. User repairs transcript:
	// - Corrects w16 by marking it cut (extraneous "tạo")
	// - Corrects w13-w15 text and timing
	corrections := []TranscriptCorrectionItem{
		{WordID: "w16", CorrectedText: "", MarkCut: true},
		{WordID: "w15", CorrectedText: "nhân", NewEndMS: 7300},
	}

	repaired, err := engine.RepairTranscript(ctx, initialTranscript, corrections)
	if err != nil {
		t.Fatalf("expected successful repair, got error: %v", err)
	}
	if repaired.AlignmentStatus != "repaired" {
		t.Fatalf("expected alignment_status 'repaired', got %s", repaired.AlignmentStatus)
	}
	if !repaired.Words[15].IsDeleted {
		t.Fatalf("expected w16 to be marked deleted")
	}

	// 4. Edge Case EC-M07-Q01: Poor ASR alignment failure with invalid timecode inversion
	// When user sets an impossible timecode that inverts order or creates massive conflict:
	badCorrections := []TranscriptCorrectionItem{
		{WordID: "w2", NewStartMS: 5000, NewEndMS: 2000}, // Inverted StartMS >= EndMS
	}

	failedRepaired, err := engine.RepairTranscript(ctx, initialTranscript, badCorrections)
	if err == nil {
		t.Fatalf("expected error on invalid alignment repair")
	}
	if !errors.Is(err, ErrAlignmentFailed) {
		t.Fatalf("expected ErrAlignmentFailed, got: %v", err)
	}
	if failedRepaired.AlignmentStatus != "manual_fallback" {
		t.Fatalf("expected alignment_status 'manual_fallback', got %s", failedRepaired.AlignmentStatus)
	}
	if !strings.Contains(failedRepaired.AlignmentError, "Auto-alignment failed. [Try segment mode] or [Manual cut].") {
		t.Fatalf("expected EC-M07-Q01 exact fallback message, got: %s", failedRepaired.AlignmentError)
	}
}

// ============================================================================
// Acceptance Target 2: Correct ratio/audio/subtitles
// ============================================================================

func TestAspectAudioSubtitlesBeatCopyright_AcceptanceTarget2(t *testing.T) {
	st := NewMemoryStore()
	enhancer := NewEnhancerEngine(st)

	// 1. Aspect Ratio Reframe Engine (9:16 vertical, 16:9 landscape, 1:1 square)
	// Given 1920x1080 source video with active speaker at (1100, 540)
	crop916, filter916, err := enhancer.CalculateReframeCrop(1920, 1080, "9:16", 1100, 540)
	if err != nil {
		t.Fatalf("reframe 9:16 failed: %v", err)
	}
	if crop916.Width != 608 || crop916.Height != 1080 {
		t.Fatalf("expected 9:16 crop dimensions ~608x1080, got %dx%d", crop916.Width, crop916.Height)
	}
	if crop916.X+crop916.Width > 1920 || crop916.X < 0 {
		t.Fatalf("crop box out of bounds: x=%d w=%d", crop916.X, crop916.Width)
	}
	if !strings.HasPrefix(filter916, "crop=") {
		t.Fatalf("invalid crop filter string: %s", filter916)
	}

	// 1:1 Square reframe
	crop11, _, err := enhancer.CalculateReframeCrop(1920, 1080, "1:1", 960, 540)
	if err != nil {
		t.Fatalf("reframe 1:1 failed: %v", err)
	}
	if crop11.Width != 1080 || crop11.Height != 1080 {
		t.Fatalf("expected 1:1 crop 1080x1080, got %dx%d", crop11.Width, crop11.Height)
	}

	// 2. Audio Loudness Normalization (-14 LUFS per RULE-M07-005)
	loudnormFilter := enhancer.BuildLoudnormFilter(-14.0)
	if loudnormFilter != "loudnorm=I=-14.0:LRA=11.0:TP=-1.5" {
		t.Fatalf("unexpected loudnorm filter: %s", loudnormFilter)
	}

	// Compliance checks
	ok1, _ := enhancer.ValidateLoudnessCompliance(-14.2, -14.0)
	if !ok1 {
		t.Fatalf("expected -14.2 LUFS to pass compliance (-14 ± 2.5 LUFS)")
	}
	ok2, _ := enhancer.ValidateLoudnessCompliance(-12.0, -14.0)
	if !ok2 {
		t.Fatalf("expected -12.0 LUFS to pass compliance (-14 ± 2.5 LUFS)")
	}
	ok3, _ := enhancer.ValidateLoudnessCompliance(-9.5, -14.0)
	if ok3 {
		t.Fatalf("expected -9.5 LUFS to fail compliance (exceeds +2.5 LUFS)")
	}

	// 3. Subtitle Styles (Bounce, Karaoke, Highlight, Typewriter)
	words := []TranscriptWordRecord{
		{WordID: "w1", Text: "Hello", StartMS: 0, EndMS: 500},
		{WordID: "w2", Text: "World", StartMS: 550, EndMS: 1100},
	}
	for _, style := range []string{"bounce", "karaoke", "highlight", "typewriter"} {
		stDef := enhancer.GetSubtitleStyle(style)
		filters := enhancer.GenerateDrawtextFilters(words, stDef)
		if len(filters) != 2 {
			t.Fatalf("expected 2 drawtext filters for %s, got %d", style, len(filters))
		}
		if !strings.Contains(filters[0], "drawtext=") {
			t.Fatalf("filter for %s does not contain drawtext: %s", style, filters[0])
		}
	}

	// 4. Beat Sync Alignment
	beatGrid := enhancer.GenerateBeatGrid(120, 60.0) // 120 BPM -> 500ms intervals (0, 500, 1000, 1500...)
	snapped := enhancer.SnapToBeat(520, beatGrid, 150)
	if snapped != 500 {
		t.Fatalf("expected 520ms to snap to nearest beat 500ms, got %d", snapped)
	}
	notSnapped := enhancer.SnapToBeat(750, beatGrid, 100)
	if notSnapped != 750 {
		t.Fatalf("expected 750ms not to snap (too far from 500 and 1000), got %d", notSnapped)
	}

	// 5. ACRCloud Copyright Scan & Enforcement (EC-M07-M01)
	globalSounds, _, _ := st.ListSoundTracks(context.Background(), "", "", true, 10, 0)

	// Clean audio test
	scanClean, err := enhancer.ScanAudioCopyright("https://cdn.creativanta.com/audio/my_recording.mp3", "clean_hash_123", globalSounds)
	if err != nil {
		t.Fatalf("expected clean audio to pass copyright scan, got: %v", err)
	}
	if scanClean.IsCopyrighted || !scanClean.ClearanceAllowed {
		t.Fatalf("expected clean audio to have clearance_allowed=true")
	}

	// Copyrighted audio test (e.g. Ed Sheeran - Shape of You)
	scanCR, err := enhancer.ScanAudioCopyright("https://cdn.example.com/cr_audio.mp3", "acr:sony:shape_of_you", globalSounds)
	if err == nil {
		t.Fatalf("expected copyright violation error for commercial song")
	}
	if !errors.Is(err, ErrCopyrightViolation) {
		t.Fatalf("expected ErrCopyrightViolation, got: %v", err)
	}
	if !scanCR.IsCopyrighted || scanCR.ClearanceAllowed {
		t.Fatalf("expected is_copyrighted=true and clearance_allowed=false")
	}
	if len(scanCR.SuggestedAlternatives) == 0 {
		t.Fatalf("expected suggested royalty-free alternatives for copyrighted track")
	}
	if !scanCR.SuggestedAlternatives[0].IsRoyaltyFree {
		t.Fatalf("suggested alternative must be royalty free")
	}
}

// ============================================================================
// Acceptance Target 3: Deleted text maps to intended segment
// ============================================================================

func TestDeletedTextMappingAndZeroDrift_AcceptanceTarget3(t *testing.T) {
	cutEngine := NewCutEngine(80)

	// 10-second video (10000 ms)
	totalDurationMS := int64(10000)

	// Words:
	// [0-1000] "Xin chào"
	// [1200-1600] "ừm" (filler, to cut)
	// [1650-2000] "kiểu" (filler, to cut) -> gap is 50ms < 80ms, should coalesce with "ừm"!
	// [2500-4500] "các bạn hôm nay" (retained)
	// [4500-6500] "awkward pause" (to cut: 4500-6500)
	// [6600-8000] "mình giới thiệu sản phẩm" (retained)
	// [8100-9000] "strikethrough text" (deleted by user: 8100-9000)
	// [9200-10000] "kết thúc" (retained)

	words := []TranscriptWordRecord{
		{WordID: "w1", Text: "Xin chào", StartMS: 0, EndMS: 1000},
		{WordID: "w2", Text: "ừm", StartMS: 1200, EndMS: 1600, IsFiller: true},
		{WordID: "w3", Text: "kiểu", StartMS: 1650, EndMS: 2000, IsFiller: true},
		{WordID: "w4", Text: "các bạn hôm nay", StartMS: 2500, EndMS: 4500},
		{WordID: "w5", Text: "mình giới thiệu sản phẩm", StartMS: 6600, EndMS: 8000},
		{WordID: "w6", Text: "strikethrough text", StartMS: 8100, EndMS: 9000, IsDeleted: true},
		{WordID: "w7", Text: "kết thúc", StartMS: 9200, EndMS: 10000},
	}

	pauses := []DeadPauseRecord{
		{StartMS: 4500, EndMS: 6500, DurationMS: 2000},
	}

	// 1. Build cuts with filler and pause removal enabled
	cuts := cutEngine.BuildCutIntervalsFromTranscript(words, pauses, true, true, nil)

	// Coalescing check: w2 (1200-1600) and w3 (1650-2000) are separated by 50ms < 80ms threshold
	// They must be coalesced into [1200, 2000] (duration 800ms)
	foundCoalesced := false
	for _, c := range cuts {
		if c.StartMS == 1200 && c.EndMS == 2000 {
			foundCoalesced = true
			break
		}
	}
	if !foundCoalesced {
		t.Fatalf("expected w2 and w3 to coalesce into [1200, 2000], got cuts: %+v", cuts)
	}

	// 2. Compute retained timeline segments
	retained, timeSavedMS, finalDurationMS := cutEngine.ComputeRetainedSegments(totalDurationMS, cuts)

	// Expected retained segments:
	// seg 0: [0, 1200] (1200ms)
	// seg 1: [2000, 4500] (2500ms)
	// seg 2: [6500, 8100] (1600ms)
	// seg 3: [9000, 10000] (1000ms)
	// Total retained: 1200 + 2500 + 1600 + 1000 = 6300ms
	// Time saved: 800 (w2+w3) + 2000 (pause) + 900 (w6) = 3700ms
	// Total: 6300 + 3700 = 10000ms
	if finalDurationMS != 6300 {
		t.Fatalf("expected finalDurationMS=6300, got %d", finalDurationMS)
	}
	if timeSavedMS != 3700 {
		t.Fatalf("expected timeSavedMS=3700, got %d", timeSavedMS)
	}
	if len(retained) != 4 {
		t.Fatalf("expected 4 retained segments, got %d", len(retained))
	}

	// 3. Mathematical proof of ZERO cumulative drift
	noDrift, driftErr := cutEngine.ValidateNoCumulativeDrift(totalDurationMS, cuts, words)
	if !noDrift {
		t.Fatalf("cumulative drift detected: %s", driftErr)
	}

	// 4. Generate FFmpeg filter complex
	fc, err := cutEngine.GenerateFFmpegFilterComplex(retained)
	if err != nil {
		t.Fatalf("filter complex generation failed: %v", err)
	}
	if !strings.Contains(fc, "concat=n=4:v=1:a=1[outv][outa]") {
		t.Fatalf("expected concat filter for 4 segments, got: %s", fc)
	}
	if !strings.Contains(fc, "trim=start=0.000:end=1.200") {
		t.Fatalf("missing segment 0 trim: %s", fc)
	}
}

// ============================================================================
// Service, RBAC, and Smart Hook Library Tests
// ============================================================================

func TestQuickEditServiceAndHooks(t *testing.T) {
	st := NewMemoryStore()
	svc := NewService(ServiceConfig{
		Store: st,
	})
	ctx := context.Background()

	// 1. SaveDraft RBAC: Editor+ permitted, Viewer denied
	editorCtx := context.WithValue(ctx, "caller_role", "Editor")
	viewerCtx := context.WithValue(ctx, "caller_role", "Viewer")

	wsID := "22222222-2222-2222-2222-222222222201"

	req := connect.NewRequest(&productionv1.QuickEditServiceSaveDraftRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		AssetId:      "asset-101",
		TranscriptId: "tr-101",
		Name:         "My Awesome Vlog Draft",
		Cuts: []*productionv1.CutInterval{
			{StartMs: 1200, EndMs: 2000, Reason: "filler"},
		},
		Addons: &productionv1.QuickEditAddons{
			AutoCaptions:     true,
			CaptionStyle:     "bounce",
			AddHook:          true,
			BeatSync:         true,
			AudioEnhancement: true,
		},
	})

	// Viewer denied
	_, err := svc.SaveDraft(viewerCtx, req)
	if err == nil {
		t.Fatalf("expected permission denied for Viewer role")
	}

	// Editor permitted
	resp, err := svc.SaveDraft(editorCtx, req)
	if err != nil {
		t.Fatalf("SaveDraft failed for Editor: %v", err)
	}
	draft := resp.Msg.GetDraft()
	if draft.GetName() != "My Awesome Vlog Draft" {
		t.Fatalf("unexpected draft name: %s", draft.GetName())
	}
	// Expected cost: base 15 + hook 3 + beat_sync 5 + audio_enhancement 3 = 26 credits
	if draft.GetEstimatedCredits() != "26" && draft.GetEstimatedCredits() != "26.000000" {
		t.Fatalf("expected estimated credits 26, got %s", draft.GetEstimatedCredits())
	}

	// 2. SoundStudioService: List pre-seeded tracks
	listReq := connect.NewRequest(&productionv1.ListSoundLibraryRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
		Pagination: &commonv1.Pagination{
			PageSize: 10,
		},
	})
	listResp, err := svc.ListSoundLibrary(editorCtx, listReq)
	if err != nil {
		t.Fatalf("ListSoundLibrary failed: %v", err)
	}
	if len(listResp.Msg.GetSounds()) < 6 {
		t.Fatalf("expected at least 6 pre-seeded royalty-free tracks, got %d", len(listResp.Msg.GetSounds()))
	}

	// 3. Smart Hook Library: Check 60 hooks across 6 categories
	hooks := GetSmartHookLibrary()
	if len(hooks) != 60 {
		t.Fatalf("expected 60 hooks, got %d", len(hooks))
	}
	categories := []string{"question", "shock", "story", "pov", "listicle", "contrast"}
	for _, cat := range categories {
		catHooks := GetHooksByCategory(cat)
		if len(catHooks) != 10 {
			t.Fatalf("expected 10 hooks in category %q, got %d", cat, len(catHooks))
		}
	}
}

// ============================================================================
// Concurrency & Race Condition Test
// ============================================================================

func TestQuickEditConcurrency(t *testing.T) {
	st := NewMemoryStore()
	svc := NewService(ServiceConfig{
		Store: st,
	})
	ctx := context.WithValue(context.Background(), "caller_role", "Editor")

	var wg sync.WaitGroup
	workers := 10

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()

			wsID := "22222222-2222-2222-2222-222222222201"
			req := connect.NewRequest(&productionv1.QuickEditServiceSaveDraftRequest{
				Context: &commonv1.CommandContext{
					WorkspaceId: &commonv1.UUID{Value: wsID},
				},
				AssetId:      "asset-concurrent",
				TranscriptId: "tr-concurrent",
				Name:         "Concurrent Draft",
			})
			_, err := svc.SaveDraft(ctx, req)
			if err != nil {
				t.Errorf("worker %d SaveDraft failed: %v", workerID, err)
			}

			// Concurrently list sound tracks
			listReq := connect.NewRequest(&productionv1.ListSoundLibraryRequest{
				WorkspaceId: &commonv1.UUID{Value: wsID},
			})
			_, err = svc.ListSoundLibrary(ctx, listReq)
			if err != nil {
				t.Errorf("worker %d ListSoundLibrary failed: %v", workerID, err)
			}
		}(i)
	}

	wg.Wait()
}

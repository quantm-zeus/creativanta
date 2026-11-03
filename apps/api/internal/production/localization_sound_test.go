package production

import (
	"context"
	"strings"
	"testing"

	"connectrpc.com/connect"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func createLocalizationTestContext(wsID, role string) context.Context {
	ctx := context.Background()
	ctx = context.WithValue(ctx, "caller_role", role)
	ctx = context.WithValue(ctx, "caller_user_id", "test-user-001")
	return ctx
}

func setupLocalizationService(t *testing.T) (*Service, Store) {
	t.Helper()
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{
		Store: store,
	})
	return svc, store
}

// TestAcceptanceTarget1_ConsentRequired verifies Target 1:
// - Voice clone creation requires likeness consent.
// - Voice clone usage in voiceover or translation dubbing enforces valid consent.
// - Revoking consent immediately cascades and prevents any subsequent voice generation or translation.
// - Starter / free tier workspaces cannot create voice clones (tier gating).
func TestAcceptanceTarget1_ConsentRequired(t *testing.T) {
	svc, _ := setupLocalizationService(t)
	wsID := "01908700-0001-7000-8000-000000000001"
	ctx := createLocalizationTestContext(wsID, "Owner")
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("500.00"))

	vcMgr := svc.VoiceClone
	vcMgr.SetWorkspaceTier(wsID, "pro")

	// 1. Attempt to create voice clone without consent -> MUST FAIL
	_, err := vcMgr.Create(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		CharacterId:      "char-001",
		Name:             "Alex Twin",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/alex-sample1.mp3"},
		ConsentRecordId:  "", // Missing consent!
		ConsentConfirmed: false,
	}))
	if err == nil {
		t.Fatalf("expected error when creating voice clone without consent, got nil")
	}
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition, got %v", connect.CodeOf(err))
	}
	if !strings.Contains(err.Error(), "consent") || !strings.Contains(err.Error(), "required") {
		t.Fatalf("expected error message to mention consent required, got %v", err)
	}

	// 2. Create voice clone WITH valid consent
	consentID := "consent-alex-001"
	vcMgr.SetConsentStatus(consentID, true)

	createResp, err := vcMgr.Create(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		CharacterId:      "char-001",
		Name:             "Alex Twin",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/alex-sample1.mp3", "https://assets.creativanta.com/alex-sample2.mp3"},
		ConsentRecordId:  consentID,
		ConsentConfirmed: true,
	}))
	if err != nil {
		t.Fatalf("failed to create voice clone with consent: %v", err)
	}
	if createResp.Msg.Record == nil {
		t.Fatalf("expected Record in response, got nil")
	}
	cloneID := createResp.Msg.Record.VoiceCloneId
	if createResp.Msg.Record.CloneStatus != "ready" {
		t.Fatalf("expected status ready, got %s", createResp.Msg.Record.CloneStatus)
	}
	if createResp.Msg.Record.ConsentRecordId != consentID {
		t.Fatalf("expected consent record id %s, got %s", consentID, createResp.Msg.Record.ConsentRecordId)
	}

	// Check consent status RPC
	consentResp, err := vcMgr.GetConsentStatus(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceGetConsentStatusRequest{
		WorkspaceId:  &commonv1.UUID{Value: wsID},
		VoiceCloneId: cloneID,
	}))
	if err != nil {
		t.Fatalf("failed to get consent status: %v", err)
	}
	if !consentResp.Msg.IsValidForGeneration || consentResp.Msg.RevokedAt != nil {
		t.Fatalf("expected consent valid for generation and not revoked, got valid=%v", consentResp.Msg.IsValidForGeneration)
	}

	// 3. Generate voiceover with active consent -> MUST SUCCEED
	voResp, err := vcMgr.GenerateVoiceover(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		VoiceCloneId: cloneID,
		Text:         "Welcome to Creativanta localized studio.",
		Language:     "en",
	}))
	if err != nil {
		t.Fatalf("failed to generate voiceover with active consent: %v", err)
	}
	if voResp.Msg.AudioUrl == "" {
		t.Fatalf("expected non-empty AudioUrl")
	}

	// 4. Revoke consent cascade
	vcMgr.SetConsentStatus(consentID, false)

	// Check consent status now reflects revocation
	consentRespRevoked, err := vcMgr.GetConsentStatus(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceGetConsentStatusRequest{
		WorkspaceId:  &commonv1.UUID{Value: wsID},
		VoiceCloneId: cloneID,
	}))
	if err != nil {
		t.Fatalf("failed to get consent status after revocation: %v", err)
	}
	if consentRespRevoked.Msg.IsValidForGeneration || consentRespRevoked.Msg.ConsentStatus != "revoked" {
		t.Fatalf("expected consent invalid and revoked status, got valid=%v, status=%s", consentRespRevoked.Msg.IsValidForGeneration, consentRespRevoked.Msg.ConsentStatus)
	}

	// 5. Attempt voiceover generation after revocation -> MUST FAIL with PermissionDenied
	_, err = vcMgr.GenerateVoiceover(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		VoiceCloneId: cloneID,
		Text:         "This prompt should be blocked due to revoked consent.",
		Language:     "en",
	}))
	if err == nil {
		t.Fatalf("expected error generating voiceover after revocation, got nil")
	}
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied, got %v", connect.CodeOf(err))
	}
	if !strings.Contains(err.Error(), "revoked") {
		t.Fatalf("expected error message to mention consent revoked, got %v", err)
	}

	// 6. Attempt translation using this clone -> MUST FAIL with PermissionDenied
	transMgr := svc.Translation
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("500.00"))

	_, err = transMgr.Create(ctx, connect.NewRequest(&productionv1.TranslationServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:   "asset-src-001",
		TargetLanguages: []string{"es", "ja"},
		VoiceOption:     "cloned",
		VoiceCloneId:    cloneID,
	}))
	if err == nil {
		t.Fatalf("expected translation create to fail with revoked voice clone consent, got nil")
	}
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied, got %v", connect.CodeOf(err))
	}
	if !strings.Contains(err.Error(), "revoked") {
		t.Fatalf("expected error message to mention consent revoked, got %v", err)
	}

	// 7. Verify tier gating: starter workspace cannot create voice clone
	starterWs := "01908700-0002-7000-8000-000000000002"
	ctxStarter := createLocalizationTestContext(starterWs, "Manager")
	vcMgr.SetWorkspaceTier(starterWs, "starter")

	_, err = vcMgr.Create(ctxStarter, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: starterWs},
		},
		CharacterId:      "char-002",
		Name:             "Starter Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/sample.mp3"},
		ConsentRecordId:  "consent-starter",
		ConsentConfirmed: true,
	}))
	if err == nil {
		t.Fatalf("expected error for starter workspace creating voice clone, got nil")
	}
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied, got %v", connect.CodeOf(err))
	}
	if !strings.Contains(err.Error(), "tier") {
		t.Fatalf("expected error message to mention tier requirement, got %v", err)
	}
}

// TestAcceptanceTarget2_LanguageVoiceQualityRepair verifies Target 2:
// - Voice quality scoring and automatic repair detection.
// - Script translation quality scoring and speech clarity repair notes.
// - Post-production audio normalization to -14 LUFS.
func TestAcceptanceTarget2_LanguageVoiceQualityRepair(t *testing.T) {
	svc, _ := setupLocalizationService(t)
	wsID := "01908700-0001-7000-8000-000000000001"
	ctx := createLocalizationTestContext(wsID, "Manager")
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("500.00"))

	vcMgr := svc.VoiceClone
	vcMgr.SetWorkspaceTier(wsID, "pro")
	consentID := "consent-quality-001"
	vcMgr.SetConsentStatus(consentID, true)

	// 1. Single noisy sample triggers auto quality repair
	resp1, err := vcMgr.Create(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		CharacterId:      "char-noisy",
		Name:             "Noisy Sample Voice",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/noisy-sample.mp3"}, // Single sample
		ConsentRecordId:  consentID,
		ConsentConfirmed: true,
	}))
	if err != nil {
		t.Fatalf("failed to create voice clone: %v", err)
	}
	if !resp1.Msg.Record.RepairApplied {
		t.Fatalf("expected RepairApplied to be true for single audio sample")
	}
	if resp1.Msg.Record.QualityScore != 68.0 {
		t.Fatalf("expected quality score 68.0, got %f", resp1.Msg.Record.QualityScore)
	}

	// 2. High-quality multi-sample
	resp2, err := vcMgr.Create(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		CharacterId:      "char-studio",
		Name:             "Studio Sample Voice",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/s1.mp3", "https://assets.creativanta.com/s2.mp3"},
		ConsentRecordId:  consentID,
		ConsentConfirmed: true,
	}))
	if err != nil {
		t.Fatalf("failed to create voice clone: %v", err)
	}
	if resp2.Msg.Record.RepairApplied {
		t.Fatalf("expected RepairApplied to be false for multi-sample")
	}
	if resp2.Msg.Record.QualityScore != 88.5 {
		t.Fatalf("expected quality score 88.5, got %f", resp2.Msg.Record.QualityScore)
	}

	// 3. Translation Quality Scoring & Speech Clarity Repair Notes (-14 LUFS normalization)
	transMgr := svc.Translation
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("1000.00"))

	transResp, err := transMgr.Create(ctx, connect.NewRequest(&productionv1.TranslationServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:             "asset-video-001",
		TargetLanguages:           []string{"es", "ja", "vi"},
		LipSyncEnabled:            true,
		CulturalAdaptationEnabled: true,
		TranslateCaptions:         true,
		CustomScriptCorrections: map[string]string{
			"vi": "Repaired Vietnamese tone mark on segment 1",
		},
	}))
	if err != nil {
		t.Fatalf("failed to create translation job: %v", err)
	}
	job := transResp.Msg.Job
	if job.Status != "completed" {
		t.Fatalf("expected status completed, got %s", job.Status)
	}
	if len(job.QualityScores) != 3 {
		t.Fatalf("expected 3 quality scores, got %d", len(job.QualityScores))
	}
	for _, lang := range []string{"es", "ja", "vi"} {
		score, ok := job.QualityScores[lang]
		if !ok || score < 90.0 {
			t.Fatalf("expected quality score >= 90 for %s, got %f", lang, score)
		}
		notes, ok := job.RepairNotes[lang]
		if !ok {
			t.Fatalf("expected repair notes for %s", lang)
		}
		if lang == "vi" {
			if !strings.Contains(notes, "Custom script repair applied") {
				t.Fatalf("expected custom script repair note for vi, got %s", notes)
			}
		} else {
			if !strings.Contains(notes, "-14 LUFS") {
				t.Fatalf("expected repair notes with -14 LUFS for %s, got %s", lang, notes)
			}
		}
	}

	// 4. Post-production sound generation with verified waveform envelope
	soundMgr := svc.SoundStudio
	musicResp, err := soundMgr.GenerateMusic(ctx, connect.NewRequest(&productionv1.SoundStudioServiceGenerateMusicRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Prompt:          "Energetic synthwave beat for product intro",
		Genre:           "synthwave",
		Mood:            "upbeat",
		DurationSeconds: 30,
		LicenseType:     "commercial_royalty_free",
	}))
	if err != nil {
		t.Fatalf("failed to generate music: %v", err)
	}
	if len(musicResp.Msg.Track.WaveformPeaks) == 0 {
		t.Fatalf("expected waveform peaks to be generated")
	}
}

// TestAcceptanceTarget3_LicensedInputAndMeasuredQuote verifies Target 3:
// - Bounded credit quote before execution with multi-language volume discount formula.
// - Insufficient credits rejection.
// - Licensed sound generation with verified license metadata and license ID.
// - Sound preview and beat sync analysis.
func TestAcceptanceTarget3_LicensedInputAndMeasuredQuote(t *testing.T) {
	svc, _ := setupLocalizationService(t)
	wsID := "01908700-0001-7000-8000-000000000001"
	ctx := createLocalizationTestContext(wsID, "Editor")

	// 1. Verify Multi-language Volume Discount Formula (screen_web_studio_translation.md §5):
	// Base = 20 cr/lang, Lip-sync = +10 cr/lang, Cultural adaptation = +5 cr/lang -> 35 cr/lang
	// 1 language: 1 * 35 = 35 credits, 0% discount
	q1, d1 := CalculateTranslationQuote(1, true, true)
	if q1.String() != "35" || d1 != 0.0 {
		t.Fatalf("expected 35 and 0.0 discount for 1 lang, got %s and %f", q1.String(), d1)
	}

	// 3 languages: 3 * 35 * (1 - 0.20) = 84 credits (20% discount)
	q3, d3 := CalculateTranslationQuote(3, true, true)
	if q3.String() != "84" || d3 != 0.20 {
		t.Fatalf("expected 84 and 0.20 discount for 3 langs, got %s and %f", q3.String(), d3)
	}

	// 5 languages: 5 * 35 * (1 - 0.30 max) = 122.5 credits -> 122 rounded (30% max discount)
	q5, d5 := CalculateTranslationQuote(5, true, true)
	if q5.String() != "122" || d5 != 0.30 {
		t.Fatalf("expected 122 and 0.30 discount for 5 langs, got %s and %f", q5.String(), d5)
	}

	// 2. Insufficient balance test
	transMgr := svc.Translation
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("50.00")) // Needs 84 for 3 langs

	_, err := transMgr.Create(ctx, connect.NewRequest(&productionv1.TranslationServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:             "asset-vid-1",
		TargetLanguages:           []string{"es", "fr", "de"},
		LipSyncEnabled:            true,
		CulturalAdaptationEnabled: true,
	}))
	if err == nil {
		t.Fatalf("expected insufficient credits error, got nil")
	}
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition, got %v", connect.CodeOf(err))
	}
	if !strings.Contains(err.Error(), "insufficient credit") {
		t.Fatalf("expected error to mention insufficient credits, got %v", err)
	}

	// 3. Sufficient balance allows translation
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("500.00"))
	createResp, err := transMgr.Create(ctx, connect.NewRequest(&productionv1.TranslationServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		SourceAssetId:             "asset-vid-1",
		TargetLanguages:           []string{"es", "fr", "de"},
		LipSyncEnabled:            true,
		CulturalAdaptationEnabled: true,
	}))
	if err != nil {
		t.Fatalf("failed to create translation job with sufficient balance: %v", err)
	}
	if createResp.Msg.Job.TotalCreditsUsed != "84" {
		t.Fatalf("expected 84 credits used, got %s", createResp.Msg.Job.TotalCreditsUsed)
	}

	// Verify balance was deducted: 500 - 84 = 416
	bal := svc.GetWorkspaceBalance(wsID)
	if bal.String() != "416" {
		t.Fatalf("expected balance 416, got %s", bal.String())
	}

	// 4. Sound Studio Rights Confirmation & CC0 Licensing
	soundMgr := svc.SoundStudio

	// Reject if license is unlicensed / unauthorized
	_, err = soundMgr.GenerateMusic(ctx, connect.NewRequest(&productionv1.SoundStudioServiceGenerateMusicRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Prompt:      "Ambient corporate background music",
		LicenseType: "unlicensed", // Unlicensed input!
	}))
	if err == nil {
		t.Fatalf("expected error for unlicensed input, got nil")
	}
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition, got %v", connect.CodeOf(err))
	}
	if !strings.Contains(err.Error(), "license verification") {
		t.Fatalf("expected error to mention license verification, got %v", err)
	}

	// Succeeded with confirmed licensed input and verify license metadata
	musicResp, err := soundMgr.GenerateMusic(ctx, connect.NewRequest(&productionv1.SoundStudioServiceGenerateMusicRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Prompt:          "Ambient corporate background music",
		Genre:           "ambient",
		Mood:            "chill",
		DurationSeconds: 45,
		LicenseType:     "commercial_royalty_free",
	}))
	if err != nil {
		t.Fatalf("failed to generate music: %v", err)
	}
	track := musicResp.Msg.Track
	if track.LicenseType != "commercial_royalty_free" {
		t.Fatalf("expected commercial_royalty_free, got %s", track.LicenseType)
	}
	if !track.IsVerifiedLicense {
		t.Fatalf("expected IsVerifiedLicense to be true")
	}
	if !strings.HasPrefix(track.LicenseId, "CREATIVANTA-BGM-LIC-") {
		t.Fatalf("expected license id starting with CREATIVANTA-BGM-LIC-, got %s", track.LicenseId)
	}

	// 5. Sound preview and beat sync analysis
	previewResp, err := soundMgr.PreviewSound(ctx, connect.NewRequest(&productionv1.SoundStudioServicePreviewSoundRequest{
		TrackId:     track.TrackId,
		WorkspaceId: &commonv1.UUID{Value: wsID},
	}))
	if err != nil {
		t.Fatalf("failed to preview sound: %v", err)
	}
	if previewResp.Msg.PreviewUrl == "" {
		t.Fatalf("expected non-empty preview url")
	}
	if !previewResp.Msg.IsFree {
		t.Fatalf("expected preview to be free")
	}

	beatResp, err := soundMgr.AnalyzeBeat(ctx, connect.NewRequest(&productionv1.SoundStudioServiceAnalyzeBeatRequest{
		WorkspaceId:  &commonv1.UUID{Value: wsID},
		AudioAssetId: track.TrackId,
	}))
	if err != nil {
		t.Fatalf("failed to analyze beat: %v", err)
	}
	if beatResp.Msg.Bpm != 124.0 {
		t.Fatalf("expected BPM 124.0, got %f", beatResp.Msg.Bpm)
	}
	if len(beatResp.Msg.BeatTimestampsMs) == 0 {
		t.Fatalf("expected beat timestamps to be populated")
	}
	if len(beatResp.Msg.DownbeatTimestampsMs) == 0 {
		t.Fatalf("expected downbeat timestamps to be populated")
	}
}

package production

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

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
		Store:              store,
		VoiceCloneProvider: NewMockVoiceCloneProvider(),
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

	// 2. High-quality multi-sample (with its own character-bound consent record)
	consentID2 := "consent-quality-002"
	vcMgr.SetConsentStatus(consentID2, true)
	resp2, err := vcMgr.Create(ctx, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		CharacterId:      "char-studio",
		Name:             "Studio Sample Voice",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/s1.mp3", "https://assets.creativanta.com/s2.mp3"},
		ConsentRecordId:  consentID2,
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

func TestR4_VoiceClone_UnverifiedCrossTenantOrMismatchedConsentRejected(t *testing.T) {
	ctx := context.Background()
	svc, store := setupLocalizationService(t)
	wsA := "01908700-0001-7000-8000-0000000000a1"
	wsB := "01908700-0002-7000-8000-0000000000b2"
	ctxOwnerA := createLocalizationTestContext(wsA, "Owner")
	ctxOwnerB := createLocalizationTestContext(wsB, "Owner")
	svc.SetWorkspaceBalance(wsA, tenantdb.MustParseExactDecimal("500.00"))
	svc.SetWorkspaceBalance(wsB, tenantdb.MustParseExactDecimal("500.00"))

	vcMgr := svc.VoiceClone
	vcMgr.SetWorkspaceTier(wsA, "pro")
	vcMgr.SetWorkspaceTier(wsB, "pro")

	// 1. Arbitrary/nonexistent ConsentRecordId with ConsentConfirmed=true MUST be rejected (and MUST NOT self-authenticate!)
	for attempt := 1; attempt <= 2; attempt++ {
		_, err := vcMgr.Create(ctxOwnerA, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
			Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsA}},
			CharacterId:      "char-a1",
			Name:             "Unverified Clone",
			SampleAudioUrls:  []string{"https://assets.creativanta.com/sample1.mp3"},
			ConsentRecordId:  "consent-arbitrary-fake-999",
			ConsentConfirmed: true,
		}))
		if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
			t.Fatalf("attempt %d: expected unverified ConsentRecordId to fail with FailedPrecondition, got: %v", attempt, err)
		}
	}
	if bal := svc.GetWorkspaceBalance(wsA); bal.Cmp(tenantdb.MustParseExactDecimal("500.00")) != 0 {
		t.Fatalf("expected 0 credits deducted on rejected consent, got balance %s", bal.String())
	}

	// 2. Seed a canonical consent record in store for Workspace A and Character "char-a1"
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-canonical-a1",
		WorkspaceID: wsA,
		CharacterID: "char-a1",
		ConsentType: "voice_likeness",
		Granted:     true,
	})

	// 3. Cross-tenant reuse: Workspace B attempting to use Workspace A's consent record MUST fail
	_, err := vcMgr.Create(ctxOwnerB, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsB}},
		CharacterId:      "char-a1",
		Name:             "Cross Tenant Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/sample1.mp3"},
		ConsentRecordId:  "consent-canonical-a1",
		ConsentConfirmed: true,
	}))
	if err == nil {
		t.Fatalf("expected cross-tenant consent record usage to fail, got nil")
	}

	// 4. Wrong character in same workspace: using char-a1's consent record for char-other MUST fail
	_, err = vcMgr.Create(ctxOwnerA, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsA}},
		CharacterId:      "char-other",
		Name:             "Mismatched Character Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/sample1.mp3"},
		ConsentRecordId:  "consent-canonical-a1",
		ConsentConfirmed: true,
	}))
	if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected character mismatch on consent record to fail with FailedPrecondition, got: %v", err)
	}

	// 5. Matching workspace + character + granted consent succeeds
	createResp, err := vcMgr.Create(ctxOwnerA, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsA}},
		CharacterId:      "char-a1",
		Name:             "Authorized Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/sample1.mp3", "https://assets.creativanta.com/sample2.mp3"},
		ConsentRecordId:  "consent-canonical-a1",
		ConsentConfirmed: true,
	}))
	if err != nil {
		t.Fatalf("expected valid canonical consent to succeed, got: %v", err)
	}

	// 6. Revoking consent in canonical store blocks GenerateVoiceover even without calling vcMgr.SetConsentStatus
	if err := store.RevokeConsentRecord(ctx, wsA, "consent-canonical-a1"); err != nil {
		t.Fatalf("RevokeConsentRecord failed: %v", err)
	}
	_, err = vcMgr.GenerateVoiceover(ctxOwnerA, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
		Context:      &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsA}},
		VoiceCloneId: createResp.Msg.GetRecord().GetVoiceCloneId(),
		Text:         "Should be blocked by store consent revocation",
		Language:     "en",
	}))
	if err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected GenerateVoiceover to fail with PermissionDenied after store consent revocation, got: %v", err)
	}
}

func TestS6_F9_VoiceCloneConsentKindSubjectAndOwnerBinding(t *testing.T) {
	ctx := context.Background()
	svc, store := setupLocalizationService(t)
	wsID := "01908700-0009-7000-8000-0000000000f9"
	ctxManager := createLocalizationTestContext(wsID, "Manager")
	initialBal := tenantdb.MustParseExactDecimal("500.00")
	svc.SetWorkspaceBalance(wsID, initialBal)

	vcMgr := svc.VoiceClone
	vcMgr.SetWorkspaceTier(wsID, "pro")

	// 1. Non-voice consent types (privacy, marketing, tos, analytics, ai_processing) in the SAME workspace MUST be rejected.
	for _, wrongType := range []string{"privacy", "marketing", "tos", "analytics", "ai_processing", ""} {
		cid := "consent-wrong-type-" + wrongType
		_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
			ConsentID:   cid,
			WorkspaceID: wsID,
			CharacterID: "char-f9-a",
			UserID:      "test-user-001",
			ConsentType: wrongType,
			Granted:     true,
		})
		_, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
			Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
			CharacterId:      "char-f9-a",
			Name:             "Wrong Consent Type Clone",
			SampleAudioUrls:  []string{"https://assets.creativanta.com/f9-sample1.mp3"},
			ConsentRecordId:  cid,
			ConsentConfirmed: true,
		}))
		if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
			t.Fatalf("F9 VIOLATION: expected consent type %q to be rejected with FailedPrecondition, got: %v", wrongType, err)
		}
	}

	// 2. Valid voice_likeness consent for char-f9-a, but request omits character_id ("") -> MUST be rejected.
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-f9-valid-char-a",
		WorkspaceID: wsID,
		CharacterID: "char-f9-a",
		UserID:      "test-user-001",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	_, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		CharacterId:      "",
		Name:             "Empty Character Bypass Attempt",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/f9-other-sample.mp3"},
		ConsentRecordId:  "consent-f9-valid-char-a",
		ConsentConfirmed: true,
	}))
	if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F9 VIOLATION: expected empty character_id to fail with FailedPrecondition, got: %v", err)
	}

	// 3. Consent record in store without a bound CharacterID -> MUST be rejected.
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-f9-unbound-char",
		WorkspaceID: wsID,
		CharacterID: "",
		UserID:      "test-user-001",
		ConsentType: "voice_clone",
		Granted:     true,
	})
	_, err = vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		CharacterId:      "char-f9-a",
		Name:             "Unbound Consent Subject",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/f9-sample1.mp3"},
		ConsentRecordId:  "consent-f9-unbound-char",
		ConsentConfirmed: true,
	}))
	if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F9 VIOLATION: expected unbound CharacterID in consent record to fail with FailedPrecondition, got: %v", err)
	}

	// 4. Consent record bound to a different voice owner UserID -> MUST be rejected.
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-f9-wrong-owner",
		WorkspaceID: wsID,
		CharacterID: "char-f9-a",
		UserID:      "user-different-voice-owner",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	_, err = vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		CharacterId:      "char-f9-a",
		Name:             "Wrong Voice Owner Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/f9-sample1.mp3"},
		ConsentRecordId:  "consent-f9-wrong-owner",
		ConsentConfirmed: true,
	}))
	if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F9 VIOLATION: expected mismatched voice owner UserID to fail with FailedPrecondition, got: %v", err)
	}

	// Verify 0 credits deducted and 0 voice clones created after all rejected attempts.
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(initialBal) != 0 {
		t.Fatalf("F9 VIOLATION: expected balance %s after rejected attempts, got %s", initialBal.String(), bal.String())
	}
	if clones, total, _ := store.ListVoiceClones(ctx, wsID, "", 100, 0); total != 0 || len(clones) != 0 {
		t.Fatalf("F9 VIOLATION: expected 0 voice clones stored after rejected attempts, got %d", total)
	}

	// 5. Valid voice_likeness consent with matching workspace, character, and owner succeeds,
	//    but reusing that same consent ID with different sample audio URLs is rejected.
	okResp, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		CharacterId:      "char-f9-a",
		Name:             "Valid Bound Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/f9-sample1.mp3", "https://assets.creativanta.com/f9-sample2.mp3"},
		ConsentRecordId:  "consent-f9-valid-char-a",
		ConsentConfirmed: true,
	}))
	if err != nil || okResp.Msg.GetRecord().GetCloneStatus() != "ready" {
		t.Fatalf("expected valid bound consent to succeed, got err=%v", err)
	}

	_, err = vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		CharacterId:      "char-f9-a",
		Name:             "Swapped Audio Source Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/unauthorized-third-party-voice.mp3"},
		ConsentRecordId:  "consent-f9-valid-char-a",
		ConsentConfirmed: true,
	}))
	if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F9 VIOLATION: expected reusing consent with swapped sample audio source to fail with FailedPrecondition, got: %v", err)
	}
}

type failingVoiceCloneStore struct {
	Store
	failCreateVoiceClone bool
	failCreateAsset      bool
}

func (f *failingVoiceCloneStore) CreateVoiceClone(ctx context.Context, record *VoiceCloneRecord) error {
	if f.failCreateVoiceClone {
		return fmt.Errorf("simulated store CreateVoiceClone error")
	}
	return f.Store.CreateVoiceClone(ctx, record)
}

func (f *failingVoiceCloneStore) CreateAsset(ctx context.Context, asset *Asset) error {
	if f.failCreateAsset {
		return fmt.Errorf("simulated store CreateAsset error")
	}
	return f.Store.CreateAsset(ctx, asset)
}

func TestR8_VoiceCloneAndVoiceover_FailClosedWithoutProvider_And_NoChargeOnStoreError(t *testing.T) {
	ctx := context.Background()
	wsID := "01908700-0008-7000-8000-000000000088"
	ctxManager := createLocalizationTestContext(wsID, "Manager")
	initialBal := tenantdb.MustParseExactDecimal("500.00")

	// 1. Default NewService without VoiceCloneProvider MUST fail closed on Create and GenerateVoiceover without charging credits!
	{
		store := NewMemoryStore()
		svc := NewService(ServiceConfig{Store: store})
		svc.SetWorkspaceBalance(wsID, initialBal)
		vcMgr := svc.VoiceClone
		vcMgr.SetWorkspaceTier(wsID, "pro")
		_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
			ConsentID:   "consent-r8-unconfigured",
			WorkspaceID: wsID,
			CharacterID: "char-r8",
			UserID:      "test-user-001",
			ConsentType: "voice_likeness",
			Granted:     true,
		})

		_, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
			Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
			CharacterId:      "char-r8",
			Name:             "Unconfigured Provider Clone",
			SampleAudioUrls:  []string{"https://assets.creativanta.com/r8-sample.mp3"},
			ConsentRecordId:  "consent-r8-unconfigured",
			ConsentConfirmed: true,
		}))
		if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
			t.Fatalf("R8 VIOLATION: expected VoiceClone.Create without provider to fail with FailedPrecondition, got: %v", err)
		}
		if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(initialBal) != 0 {
			t.Fatalf("R8 VIOLATION: expected 0 credits deducted when provider unconfigured, got balance %s", bal.String())
		}
		if clones, total, _ := store.ListVoiceClones(ctx, wsID, "", 100, 0); total != 0 || len(clones) != 0 {
			t.Fatalf("R8 VIOLATION: expected 0 voice clones created when provider unconfigured, got %d", total)
		}
	}

	// 2. Store failure on CreateVoiceClone or CreateAsset MUST NOT deduct credits!
	{
		baseStore := NewMemoryStore()
		fStore := &failingVoiceCloneStore{Store: baseStore, failCreateVoiceClone: true}
		svc := NewService(ServiceConfig{
			Store:              fStore,
			VoiceCloneProvider: NewMockVoiceCloneProvider(),
		})
		svc.SetWorkspaceBalance(wsID, initialBal)
		vcMgr := svc.VoiceClone
		vcMgr.SetWorkspaceTier(wsID, "pro")
		_ = baseStore.SaveConsentRecord(ctx, &ProductionConsentRecord{
			ConsentID:   "consent-r8-store",
			WorkspaceID: wsID,
			CharacterID: "char-r8-store",
			UserID:      "test-user-001",
			ConsentType: "voice_likeness",
			Granted:     true,
		})

		// 2a. CreateVoiceClone fails -> 0 credits deducted
		_, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
			Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
			CharacterId:      "char-r8-store",
			Name:             "Store Error Clone",
			SampleAudioUrls:  []string{"https://assets.creativanta.com/r8-sample.mp3"},
			ConsentRecordId:  "consent-r8-store",
			ConsentConfirmed: true,
		}))
		if err == nil || connect.CodeOf(err) != connect.CodeInternal {
			t.Fatalf("expected CreateVoiceClone store error to return CodeInternal, got: %v", err)
		}
		if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(initialBal) != 0 {
			t.Fatalf("R8 VIOLATION: credits deducted despite CreateVoiceClone error! balance=%s", bal.String())
		}

		// 2b. Allow CreateVoiceClone to succeed (500 - 15 = 485), then fail CreateAsset on GenerateVoiceover
		fStore.failCreateVoiceClone = false
		createResp, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
			Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
			CharacterId:      "char-r8-store",
			Name:             "Valid Clone",
			SampleAudioUrls:  []string{"https://assets.creativanta.com/r8-sample.mp3"},
			ConsentRecordId:  "consent-r8-store",
			ConsentConfirmed: true,
		}))
		if err != nil {
			t.Fatalf("Create failed: %v", err)
		}
		cloneID := createResp.Msg.GetRecord().GetVoiceCloneId()
		balAfterClone := svc.GetWorkspaceBalance(wsID) // 485

		// Unconfigure provider before GenerateVoiceover -> must fail closed with 0 credits deducted
		vcMgr.SetProvider(nil)
		_, err = vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
			Context:      &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
			VoiceCloneId: cloneID,
			Text:         "Voiceover without provider",
			Language:     "en",
		}))
		if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
			t.Fatalf("R8 VIOLATION: expected GenerateVoiceover without provider to fail with FailedPrecondition, got: %v", err)
		}
		if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(balAfterClone) != 0 {
			t.Fatalf("R8 VIOLATION: credits deducted on GenerateVoiceover without provider! balance=%s", bal.String())
		}

		// Restore provider, but fail CreateAsset -> must return CodeInternal and deduct 0 credits!
		vcMgr.SetProvider(NewMockVoiceCloneProvider())
		fStore.failCreateAsset = true
		_, err = vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
			Context:      &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
			VoiceCloneId: cloneID,
			Text:         "Voiceover with store failure",
			Language:     "en",
		}))
		if err == nil || connect.CodeOf(err) != connect.CodeInternal {
			t.Fatalf("R8 VIOLATION: expected GenerateVoiceover to fail with CodeInternal when CreateAsset fails, got: %v", err)
		}
		if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(balAfterClone) != 0 {
			t.Fatalf("R8 CRITICAL VIOLATION: credits deducted despite CreateAsset error! got balance=%s, expected %s", bal.String(), balAfterClone.String())
		}
	}
}

type barrierVoiceCloneProvider struct {
	mu               sync.Mutex
	cloneCalls       int
	synthCalls       int
	cloneEnteredCh   chan struct{}
	cloneReleaseCh   chan struct{}
	synthEnteredCh   chan struct{}
	synthReleaseCh   chan struct{}
	cloneErr         error
	synthErr         error
	seenCloneEffects []string
	seenSynthEffects []string
	seenCloneOpKeys  []string
	seenSynthOpKeys  []string
}

func (p *barrierVoiceCloneProvider) CloneVoice(ctx context.Context, workspaceID, characterID, voiceName string, _ []string, _ bool) (string, string, error) {
	p.mu.Lock()
	p.cloneCalls++
	callNum := p.cloneCalls
	p.seenCloneEffects = append(p.seenCloneEffects, workspaceID+":"+characterID+":"+voiceName)
	if opKey, ok := VoiceOperationIdempotencyKeyFromContext(ctx); ok {
		p.seenCloneOpKeys = append(p.seenCloneOpKeys, opKey)
	}
	enteredCh := p.cloneEnteredCh
	releaseCh := p.cloneReleaseCh
	cloneErr := p.cloneErr
	p.mu.Unlock()

	if enteredCh != nil {
		select {
		case enteredCh <- struct{}{}:
		default:
		}
	}
	if releaseCh != nil {
		select {
		case <-releaseCh:
		case <-ctx.Done():
			return "", "", ctx.Err()
		}
	}
	if cloneErr != nil {
		return "", "", cloneErr
	}
	return "elevenlabs", fmt.Sprintf("prov-clone-%d", callNum), nil
}

func (p *barrierVoiceCloneProvider) SynthesizeSpeech(ctx context.Context, workspaceID, providerVoiceID, text, _ string) (string, float64, error) {
	p.mu.Lock()
	p.synthCalls++
	callNum := p.synthCalls
	p.seenSynthEffects = append(p.seenSynthEffects, workspaceID+":"+providerVoiceID+":"+text)
	if opKey, ok := VoiceOperationIdempotencyKeyFromContext(ctx); ok {
		p.seenSynthOpKeys = append(p.seenSynthOpKeys, opKey)
	}
	enteredCh := p.synthEnteredCh
	releaseCh := p.synthReleaseCh
	synthErr := p.synthErr
	p.mu.Unlock()

	if enteredCh != nil {
		select {
		case enteredCh <- struct{}{}:
		default:
		}
	}
	if releaseCh != nil {
		select {
		case <-releaseCh:
		case <-ctx.Done():
			return "", 0, ctx.Err()
		}
	}
	if synthErr != nil {
		return "", 0, synthErr
	}
	return fmt.Sprintf("https://cdn.creativanta.com/voiceovers/vo-%d.mp3", callNum), 10.0, nil
}

func TestN2_VoiceCloneAndVoiceover_ConcurrentBarrierPreventsOverspend(t *testing.T) {
	ctx := context.Background()

	// 1. Two concurrent GenerateVoiceover calls with balance = 3.00 (cost is 3.00 each).
	// Credits MUST be reserved before SynthesizeSpeech is called so at most 1 provider call executes
	// and final balance is 0 (never -3).
	{
		wsID := "01908700-0002-7000-8000-000000000201"
		ctxManager := createLocalizationTestContext(wsID, "Manager")
		store := NewMemoryStore()
		prov := &barrierVoiceCloneProvider{
			synthEnteredCh: make(chan struct{}, 2),
			synthReleaseCh: make(chan struct{}),
		}
		svc := NewService(ServiceConfig{
			Store:              store,
			VoiceCloneProvider: prov,
		})
		vcMgr := svc.VoiceClone
		vcMgr.SetWorkspaceTier(wsID, "pro")
		_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
			ConsentID:   "consent-n2-vo",
			WorkspaceID: wsID,
			CharacterID: "char-n2-vo",
			UserID:      "test-user-001",
			ConsentType: "voice_likeness",
			Granted:     true,
		})

		// Create the clone first with sufficient balance (15 credits), then set balance to exactly 3 credits.
		svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("15.00"))
		createResp, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
			Context:          &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
			CharacterId:      "char-n2-vo",
			Name:             "N2 Clone",
			SampleAudioUrls:  []string{"https://assets.creativanta.com/n2-s1.mp3", "https://assets.creativanta.com/n2-s2.mp3"},
			ConsentRecordId:  "consent-n2-vo",
			ConsentConfirmed: true,
		}))
		if err != nil {
			t.Fatalf("setup Create failed: %v", err)
		}
		cloneID := createResp.Msg.GetRecord().GetVoiceCloneId()

		svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("3.00"))

		var wg sync.WaitGroup
		errs := make([]error, 2)
		wg.Add(2)
		for i := 0; i < 2; i++ {
			go func(idx int) {
				defer wg.Done()
				_, errs[idx] = vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
					Context: &commonv1.CommandContext{
						WorkspaceId:    &commonv1.UUID{Value: wsID},
						IdempotencyKey: fmt.Sprintf("idem-n2-vo-%d", idx),
					},
					VoiceCloneId: cloneID,
					Text:         fmt.Sprintf("Concurrent voiceover line %d", idx),
					Language:     "en",
				}))
			}(i)
		}

		// Wait for the winning request to enter the provider, give the second goroutine a moment to hit the credit reservation check, then release.
		<-prov.synthEnteredCh
		time.Sleep(25 * time.Millisecond)
		close(prov.synthReleaseCh)
		wg.Wait()

		successCount := 0
		insufficientCount := 0
		for _, e := range errs {
			if e == nil {
				successCount++
			} else if connect.CodeOf(e) == connect.CodeFailedPrecondition && strings.Contains(e.Error(), ErrInsufficientCredits.Error()) {
				insufficientCount++
			} else {
				t.Fatalf("unexpected error in concurrent GenerateVoiceover: %v", e)
			}
		}
		if successCount != 1 || insufficientCount != 1 {
			t.Fatalf("N2 VIOLATION: expected 1 success and 1 insufficient-credit rejection, got success=%d insufficient=%d (errs=%v)", successCount, insufficientCount, errs)
		}
		if prov.synthCalls != 1 {
			t.Fatalf("N2 VIOLATION: expected provider SynthesizeSpeech called once, got %d calls", prov.synthCalls)
		}
		if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.ZeroDecimal()) != 0 {
			t.Fatalf("N2 VIOLATION: expected final workspace balance 0 after single 3-credit spend, got %s", bal.String())
		}
	}

	// 2. Two concurrent VoiceClone.Create calls with balance = 15.00 (cost is 15.00 each).
	// Credits MUST be reserved before CloneVoice is called so at most 1 provider call executes
	// and final balance is 0 (never -15).
	{
		wsID := "01908700-0002-7000-8000-000000000202"
		ctxManager := createLocalizationTestContext(wsID, "Manager")
		store := NewMemoryStore()
		prov := &barrierVoiceCloneProvider{
			cloneEnteredCh: make(chan struct{}, 2),
			cloneReleaseCh: make(chan struct{}),
		}
		svc := NewService(ServiceConfig{
			Store:              store,
			VoiceCloneProvider: prov,
		})
		vcMgr := svc.VoiceClone
		vcMgr.SetWorkspaceTier(wsID, "pro")
		for i := 0; i < 2; i++ {
			_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
				ConsentID:   fmt.Sprintf("consent-n2-clone-%d", i),
				WorkspaceID: wsID,
				CharacterID: fmt.Sprintf("char-n2-%d", i),
				UserID:      "test-user-001",
				ConsentType: "voice_likeness",
				Granted:     true,
			})
		}
		svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("15.00"))

		var wg sync.WaitGroup
		errs := make([]error, 2)
		wg.Add(2)
		for i := 0; i < 2; i++ {
			go func(idx int) {
				defer wg.Done()
				_, errs[idx] = vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
					Context: &commonv1.CommandContext{
						WorkspaceId:    &commonv1.UUID{Value: wsID},
						IdempotencyKey: fmt.Sprintf("idem-n2-clone-%d", idx),
					},
					CharacterId:      fmt.Sprintf("char-n2-%d", idx),
					Name:             fmt.Sprintf("Concurrent Clone %d", idx),
					SampleAudioUrls:  []string{fmt.Sprintf("https://assets.creativanta.com/n2-clone-%d.mp3", idx)},
					ConsentRecordId:  fmt.Sprintf("consent-n2-clone-%d", idx),
					ConsentConfirmed: true,
				}))
			}(i)
		}

		<-prov.cloneEnteredCh
		time.Sleep(25 * time.Millisecond)
		close(prov.cloneReleaseCh)
		wg.Wait()

		successCount := 0
		insufficientCount := 0
		for _, e := range errs {
			if e == nil {
				successCount++
			} else if connect.CodeOf(e) == connect.CodeFailedPrecondition && strings.Contains(e.Error(), ErrInsufficientCredits.Error()) {
				insufficientCount++
			} else {
				t.Fatalf("unexpected error in concurrent Create: %v", e)
			}
		}
		if successCount != 1 || insufficientCount != 1 {
			t.Fatalf("N2 VIOLATION: expected 1 success and 1 insufficient-credit rejection on Create, got success=%d insufficient=%d (errs=%v)", successCount, insufficientCount, errs)
		}
		if prov.cloneCalls != 1 {
			t.Fatalf("N2 VIOLATION: expected provider CloneVoice called once, got %d calls", prov.cloneCalls)
		}
		if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.ZeroDecimal()) != 0 {
			t.Fatalf("N2 VIOLATION: expected final workspace balance 0 after single 15-credit spend, got %s", bal.String())
		}
	}
}

func TestN3_VoiceCloneAndVoiceover_UnknownOutcomeHoldsCreditsAndBlocksReplay(t *testing.T) {
	ctx := context.Background()
	wsID := "01908700-0003-7000-8000-000000000301"
	ctxManager := createLocalizationTestContext(wsID, "Manager")
	store := NewMemoryStore()
	prov := &barrierVoiceCloneProvider{
		cloneErr: context.DeadlineExceeded,
	}
	svc := NewService(ServiceConfig{
		Store:              store,
		VoiceCloneProvider: prov,
	})
	vcMgr := svc.VoiceClone
	vcMgr.SetWorkspaceTier(wsID, "pro")
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-n3-clone",
		WorkspaceID: wsID,
		CharacterID: "char-n3-clone",
		UserID:      "test-user-001",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("100.00"))

	// 1. VoiceClone.Create times out after provider recorded the side effect.
	cloneReq := &productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-n3-voice-clone-001",
		},
		CharacterId:      "char-n3-clone",
		Name:             "N3 Timeout Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/n3-sample1.mp3"},
		ConsentRecordId:  "consent-n3-clone",
		ConsentConfirmed: true,
	}
	_, err := vcMgr.Create(ctxManager, connect.NewRequest(cloneReq))
	if err == nil || !errors.Is(err, ErrOutcomeUnknown) {
		t.Fatalf("N3 VIOLATION: expected ErrOutcomeUnknown on provider timeout during Create, got: %v", err)
	}
	if prov.cloneCalls != 1 {
		t.Fatalf("expected 1 provider CloneVoice call, got %d", prov.cloneCalls)
	}
	// Credits (15) MUST remain held in reconciling state while outcome is unknown (available balance = 85).
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("85.00")) != 0 {
		t.Fatalf("N3 VIOLATION: expected 15 credits held while Create outcome is unknown (balance 85), got %s", bal.String())
	}

	// Even if provider recovers, retrying with the SAME idempotency key while reconciling MUST NOT re-send the effect!
	prov.mu.Lock()
	prov.cloneErr = nil
	prov.mu.Unlock()

	_, retryErr := vcMgr.Create(ctxManager, connect.NewRequest(cloneReq))
	if retryErr == nil || !errors.Is(retryErr, ErrOutcomeUnknown) {
		t.Fatalf("N3 VIOLATION: expected retry of reconciling voice clone operation to fail closed with ErrOutcomeUnknown, got: %v", retryErr)
	}
	if prov.cloneCalls != 1 {
		t.Fatalf("N3 VIOLATION: provider CloneVoice was re-executed on retry! cloneCalls=%d", prov.cloneCalls)
	}
	if len(prov.seenCloneOpKeys) != 1 || !strings.Contains(prov.seenCloneOpKeys[0], "idem-n3-voice-clone-001") {
		t.Fatalf("N3 VIOLATION: expected provider to receive idempotency key in ctx, got %v", prov.seenCloneOpKeys)
	}
	if opRec, ok := vcMgr.GetOperation(wsID, "idem-n3-voice-clone-001"); !ok || opRec.Status != "reconciling" {
		t.Fatalf("N3 VIOLATION: expected voice clone operation in reconciling state, got ok=%v op=%+v", ok, opRec)
	}
	if resRec, ok := svc.GetReservationByJob("idem-n3-voice-clone-001"); !ok || resRec.Status != "reconciling" {
		t.Fatalf("N3 VIOLATION: expected credit reservation in reconciling state, got ok=%v res=%+v", ok, resRec)
	}
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("85.00")) != 0 {
		t.Fatalf("N3 VIOLATION: expected balance to remain 85 while reconciling, got %s", bal.String())
	}

	// Reusing the same idempotency key with different parameters MUST fail with CodeAlreadyExists.
	conflictCloneReq := &productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-n3-voice-clone-001",
		},
		CharacterId:      "char-n3-clone",
		Name:             "Mutated Clone Name",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/n3-sample1.mp3"},
		ConsentRecordId:  "consent-n3-clone",
		ConsentConfirmed: true,
	}
	_, conflictErr := vcMgr.Create(ctxManager, connect.NewRequest(conflictCloneReq))
	if conflictErr == nil || connect.CodeOf(conflictErr) != connect.CodeAlreadyExists || !errors.Is(conflictErr, ErrDuplicateIdempotencyKeyConflict) {
		t.Fatalf("N3 VIOLATION: expected parameter mismatch on same idempotency key to fail with CodeAlreadyExists, got: %v", conflictErr)
	}

	// Reconcile clone as confirmed_not_executed -> releases the 15 held credits back to 100.00!
	if err := vcMgr.ReconcileOperation(ctx, wsID, "idem-n3-voice-clone-001", "confirmed_not_executed", "", "", 0); err != nil {
		t.Fatalf("ReconcileOperation failed: %v", err)
	}
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("100.00")) != 0 {
		t.Fatalf("expected balance restored to 100.00 after confirmed_not_executed reconciliation, got %s", bal.String())
	}

	// 2. Now test GenerateVoiceover timeout -> holds 3 credits in reconciling and blocks duplicate provider call on retry.
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-n3-vo",
		WorkspaceID: wsID,
		CharacterID: "char-n3-vo",
		UserID:      "test-user-001",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	readyCloneResp, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-n3-voice-clone-002",
		},
		CharacterId:      "char-n3-vo",
		Name:             "N3 Ready Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/n3-sample2.mp3"},
		ConsentRecordId:  "consent-n3-vo",
		ConsentConfirmed: true,
	}))
	if err != nil {
		t.Fatalf("setup ready clone failed: %v", err)
	}
	cloneID := readyCloneResp.Msg.GetRecord().GetVoiceCloneId()
	// Balance is now 100 - 15 = 85.

	prov.mu.Lock()
	prov.synthErr = context.DeadlineExceeded
	prov.mu.Unlock()

	voReq := &productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-n3-voiceover-001",
		},
		VoiceCloneId: cloneID,
		Text:         "Hello from N3 voiceover test",
		Language:     "en",
	}
	_, voErr := vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(voReq))
	if voErr == nil || !errors.Is(voErr, ErrOutcomeUnknown) {
		t.Fatalf("N3 VIOLATION: expected ErrOutcomeUnknown on provider timeout during GenerateVoiceover, got: %v", voErr)
	}
	if prov.synthCalls != 1 {
		t.Fatalf("expected 1 provider SynthesizeSpeech call, got %d", prov.synthCalls)
	}
	if len(prov.seenSynthOpKeys) != 1 || !strings.Contains(prov.seenSynthOpKeys[0], "idem-n3-voiceover-001") {
		t.Fatalf("N3 VIOLATION: expected SynthesizeSpeech to receive idempotency key in ctx, got %v", prov.seenSynthOpKeys)
	}
	// 3 credits MUST remain held in reconciling state (85 - 3 = 82).
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("82.00")) != 0 {
		t.Fatalf("N3 VIOLATION: expected 3 credits held while GenerateVoiceover outcome is unknown (balance 82), got %s", bal.String())
	}

	// Clear provider error and retry with the same IdempotencyKey -> MUST NOT call SynthesizeSpeech a second time!
	prov.mu.Lock()
	prov.synthErr = nil
	prov.mu.Unlock()

	_, voRetryErr := vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(voReq))
	if voRetryErr == nil || !errors.Is(voRetryErr, ErrOutcomeUnknown) {
		t.Fatalf("N3 VIOLATION: expected retry of reconciling voiceover operation to fail closed with ErrOutcomeUnknown, got: %v", voRetryErr)
	}
	if prov.synthCalls != 1 {
		t.Fatalf("N3 VIOLATION: provider SynthesizeSpeech was re-executed on retry! synthCalls=%d", prov.synthCalls)
	}

	// Reconcile the voiceover operation as completed -> commits the 3 held credits and allows idempotent replay without calling provider again!
	if err := vcMgr.ReconcileOperation(ctx, wsID, "idem-n3-voiceover-001", "completed", "", "https://cdn.creativanta.com/voiceovers/reconciled.mp3", 12.0); err != nil {
		t.Fatalf("ReconcileOperation completed failed: %v", err)
	}
	replayedVO, err := vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(voReq))
	if err != nil {
		t.Fatalf("expected idempotent replay after completed reconciliation to succeed, got: %v", err)
	}
	if replayedVO.Msg.GetAudioUrl() != "https://cdn.creativanta.com/voiceovers/reconciled.mp3" {
		t.Fatalf("unexpected replayed audio url: %s", replayedVO.Msg.GetAudioUrl())
	}
	if prov.synthCalls != 1 {
		t.Fatalf("expected synthCalls to remain 1 after idempotent replay, got %d", prov.synthCalls)
	}
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("82.00")) != 0 {
		t.Fatalf("expected balance to remain 82.00 after idempotent replay, got %s", bal.String())
	}
}

func TestC1_VoiceIdempotencyKeyCannotOverwriteCrossTenantOrOperationReservationIndex(t *testing.T) {
	ctx := context.Background()
	wsA := "ws-c1-tenant-a"
	wsB := "ws-c1-tenant-b"
	ctxManagerA := createLocalizationTestContext(wsA, "Manager")
	ctxManagerB := createLocalizationTestContext(wsB, "Manager")

	store := NewMemoryStore()
	prov := &barrierVoiceCloneProvider{
		cloneErr: context.DeadlineExceeded,
		synthErr: context.DeadlineExceeded,
	}
	svc := NewService(ServiceConfig{
		Store:              store,
		VoiceCloneProvider: prov,
	})
	vcMgr := svc.VoiceClone
	vcMgr.SetWorkspaceTier(wsA, "pro")
	vcMgr.SetWorkspaceTier(wsB, "pro")

	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-c1-a",
		WorkspaceID: wsA,
		CharacterID: "char-c1-a",
		UserID:      "test-user-001",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-c1-b",
		WorkspaceID: wsB,
		CharacterID: "char-c1-b",
		UserID:      "test-user-001",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	_ = store.CreateVoiceClone(ctx, &VoiceCloneRecord{
		VoiceCloneID:    "vc-c1-b-ready",
		WorkspaceID:     wsB,
		CharacterID:     "char-c1-b",
		Provider:        "elevenlabs",
		ProviderVoiceID: "el_voice_b",
		VoiceName:       "Tenant B Ready Voice",
		SampleAudioURLs: []string{"https://assets.creativanta.com/c1-b.mp3"},
		CloneStatus:     "ready",
		ConsentRecordID: "consent-c1-b",
		CreatedAt:       time.Now().UTC(),
		UpdatedAt:       time.Now().UTC(),
	})

	svc.SetWorkspaceBalance(wsA, tenantdb.MustParseExactDecimal("15.00"))
	svc.SetWorkspaceBalance(wsB, tenantdb.MustParseExactDecimal("3.00"))

	// 1. Tenant A starts a 15-credit voice clone operation that enters reconciling state.
	_, errA := vcMgr.Create(ctxManagerA, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsA},
			IdempotencyKey: "idem-c1-tenant-a",
		},
		CharacterId:      "char-c1-a",
		Name:             "Tenant A Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/c1-a.mp3"},
		ConsentRecordId:  "consent-c1-a",
		ConsentConfirmed: true,
	}))
	if !errors.Is(errA, ErrOutcomeUnknown) {
		t.Fatalf("expected Tenant A Create to enter reconciling with ErrOutcomeUnknown, got: %v", errA)
	}
	opA, ok := vcMgr.GetOperation(wsA, "idem-c1-tenant-a")
	if !ok || opA == nil {
		t.Fatalf("expected Tenant A operation record to exist")
	}

	// 2. Tenant B starts a 3-credit voiceover operation using Tenant A's OperationID as its IdempotencyKey!
	_, errB := vcMgr.GenerateVoiceover(ctxManagerB, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsB},
			IdempotencyKey: opA.OperationID,
		},
		VoiceCloneId: "vc-c1-b-ready",
		Text:         "Tenant B voiceover attempting reservation index collision",
		Language:     "en",
	}))
	if !errors.Is(errB, ErrOutcomeUnknown) {
		t.Fatalf("expected Tenant B GenerateVoiceover to enter reconciling with ErrOutcomeUnknown, got: %v", errB)
	}
	opB, ok := vcMgr.GetOperation(wsB, opA.OperationID)
	if !ok || opB == nil {
		t.Fatalf("expected Tenant B operation record to exist")
	}

	// Verify Tenant A's canonical operation reservation was NOT overwritten by Tenant B's alias!
	resA, ok := svc.GetReservationByJob(opA.OperationID)
	if !ok || resA == nil {
		t.Fatalf("expected canonical reservation for %s to exist", opA.OperationID)
	}
	if resA.WorkspaceID != wsA || resA.ReservedCredits.Cmp(tenantdb.MustParseExactDecimal("15")) != 0 {
		t.Fatalf("C1 VIOLATION: Tenant A operation %s reservation was overwritten! got workspace=%s credits=%s", opA.OperationID, resA.WorkspaceID, resA.ReservedCredits.String())
	}

	// 3. Reconciling Tenant A as confirmed_not_executed must refund 15 credits to Tenant A (not 3 credits, and must not release Tenant B's reservation).
	if err := vcMgr.ReconcileOperation(ctx, wsA, "idem-c1-tenant-a", "confirmed_not_executed", "", "", 0); err != nil {
		t.Fatalf("ReconcileOperation for Tenant A failed: %v", err)
	}
	if balA := svc.GetWorkspaceBalance(wsA); balA.Cmp(tenantdb.MustParseExactDecimal("15.00")) != 0 {
		t.Fatalf("C1 VIOLATION: expected Tenant A balance restored to 15.00, got %s", balA.String())
	}
	if balB := svc.GetWorkspaceBalance(wsB); balB.Cmp(tenantdb.MustParseExactDecimal("0.00")) != 0 {
		t.Fatalf("C1 VIOLATION: expected Tenant B 3.00 credits to remain held (balance 0.00), got %s", balB.String())
	}

	// 4. Tenant B can still reconcile its own operation as completed and commit its 3-credit reservation.
	if err := vcMgr.ReconcileOperation(ctx, wsB, opB.OperationID, "completed", "", "https://cdn.creativanta.com/c1-b-vo.mp3", 10.0); err != nil {
		t.Fatalf("C1 VIOLATION: Tenant B ReconcileOperation completed failed because its reservation was released by Tenant A: %v", err)
	}
}

type flakyPersistenceVoiceStore struct {
	*MemoryStore
	mu                  sync.Mutex
	failCreateCloneOnce bool
	failCreateAssetOnce bool
	createCloneCalls    int
	createAssetCalls    int
}

func (s *flakyPersistenceVoiceStore) CreateVoiceClone(ctx context.Context, r *VoiceCloneRecord) error {
	s.mu.Lock()
	s.createCloneCalls++
	if s.failCreateCloneOnce {
		s.failCreateCloneOnce = false
		s.mu.Unlock()
		return errors.New("simulated transient database error on CreateVoiceClone")
	}
	s.mu.Unlock()
	return s.MemoryStore.CreateVoiceClone(ctx, r)
}

func (s *flakyPersistenceVoiceStore) CreateAsset(ctx context.Context, a *Asset) error {
	s.mu.Lock()
	s.createAssetCalls++
	if s.failCreateAssetOnce {
		s.failCreateAssetOnce = false
		s.mu.Unlock()
		return errors.New("simulated transient database error on CreateAsset")
	}
	s.mu.Unlock()
	return s.MemoryStore.CreateAsset(ctx, a)
}

func TestC4_VoicePersistenceFailureAfterProviderSuccessPreservesIdempotencyAndAvoidsRedispatch(t *testing.T) {
	ctx := context.Background()
	wsID := "ws-c4-persistence-retry"
	ctxManager := createLocalizationTestContext(wsID, "Manager")

	flakyStore := &flakyPersistenceVoiceStore{
		MemoryStore:         NewMemoryStore(),
		failCreateCloneOnce: true,
		failCreateAssetOnce: true,
	}
	prov := &barrierVoiceCloneProvider{}
	svc := NewService(ServiceConfig{
		Store:              flakyStore,
		VoiceCloneProvider: prov,
	})
	vcMgr := svc.VoiceClone
	vcMgr.SetWorkspaceTier(wsID, "pro")
	_ = flakyStore.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-c4-001",
		WorkspaceID: wsID,
		CharacterID: "char-c4-001",
		UserID:      "test-user-001",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("50.00"))

	// 1. VoiceClone.Create: provider succeeds on attempt 1, but CreateVoiceClone fails once.
	cloneReq := &productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-c4-clone-001",
		},
		CharacterId:      "char-c4-001",
		Name:             "C4 Resilient Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/c4-sample.mp3"},
		ConsentRecordId:  "consent-c4-001",
		ConsentConfirmed: true,
	}
	_, err1 := vcMgr.Create(ctxManager, connect.NewRequest(cloneReq))
	if err1 == nil {
		t.Fatalf("expected attempt 1 to fail when CreateVoiceClone fails")
	}
	if prov.cloneCalls != 1 {
		t.Fatalf("expected 1 provider CloneVoice call after attempt 1, got %d", prov.cloneCalls)
	}
	// Customer is not charged while output persistence failed, but operation receipt remains protected in persistence_pending.
	if opRec, ok := vcMgr.GetOperation(wsID, "idem-c4-clone-001"); !ok || opRec.Status != "persistence_pending" {
		t.Fatalf("C4 VIOLATION: expected operation to remain in persistence_pending with provider receipt, got ok=%v op=%+v", ok, opRec)
	}

	// Retry with the same idempotency key: must materialize from saved provider receipt WITHOUT calling provider again!
	cloneResp, err2 := vcMgr.Create(ctxManager, connect.NewRequest(cloneReq))
	if err2 != nil {
		t.Fatalf("C4 VIOLATION: expected retry after transient persistence error to succeed without re-dispatching, got: %v", err2)
	}
	if prov.cloneCalls != 1 {
		t.Fatalf("C4 VIOLATION: provider CloneVoice was called %d times (expected 1)!", prov.cloneCalls)
	}
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("35.00")) != 0 {
		t.Fatalf("C4 VIOLATION: expected single 15-credit settlement (balance 35.00), got %s", bal.String())
	}
	clones, _, _ := flakyStore.ListVoiceClones(ctx, wsID, "", 100, 0)
	if len(clones) != 1 {
		t.Fatalf("expected exactly 1 persisted voice clone record, got %d", len(clones))
	}

	// 2. GenerateVoiceover: provider succeeds on attempt 1, but CreateAsset fails once.
	voReq := &productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-c4-vo-001",
		},
		VoiceCloneId: cloneResp.Msg.GetRecord().GetVoiceCloneId(),
		Text:         "C4 voiceover persistence recovery test",
		Language:     "en",
	}
	_, voErr1 := vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(voReq))
	if voErr1 == nil {
		t.Fatalf("expected voiceover attempt 1 to fail when CreateAsset fails")
	}
	if prov.synthCalls != 1 {
		t.Fatalf("expected 1 provider SynthesizeSpeech call after attempt 1, got %d", prov.synthCalls)
	}
	if opRec, ok := vcMgr.GetOperation(wsID, "idem-c4-vo-001"); !ok || opRec.Status != "persistence_pending" {
		t.Fatalf("C4 VIOLATION: expected voiceover operation to remain in persistence_pending with provider receipt, got ok=%v op=%+v", ok, opRec)
	}

	voResp, voErr2 := vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(voReq))
	if voErr2 != nil {
		t.Fatalf("C4 VIOLATION: expected voiceover retry after transient persistence error to succeed, got: %v", voErr2)
	}
	if prov.synthCalls != 1 {
		t.Fatalf("C4 VIOLATION: provider SynthesizeSpeech was called %d times (expected 1)!", prov.synthCalls)
	}
	if voResp.Msg.GetAssetId() == "" {
		t.Fatalf("expected valid asset_id on recovered voiceover response")
	}
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("32.00")) != 0 {
		t.Fatalf("C4 VIOLATION: expected single 3-credit settlement (balance 32.00), got %s", bal.String())
	}
	assets, _ := flakyStore.GetRecentAssets(ctx, wsID, 100)
	if len(assets) != 1 {
		t.Fatalf("expected exactly 1 persisted voiceover asset, got %d", len(assets))
	}
}

func TestC5_VoiceReconcileOperationRejectsLateSuccessWithoutMaterializingOutputAndDedupsConcurrentCompletions(t *testing.T) {
	ctx := context.Background()
	wsID := "ws-c5-reconcile"
	ctxManager := createLocalizationTestContext(wsID, "Manager")

	store := NewMemoryStore()
	prov := &barrierVoiceCloneProvider{
		cloneErr: context.DeadlineExceeded,
		synthErr: context.DeadlineExceeded,
	}
	svc := NewService(ServiceConfig{
		Store:              store,
		VoiceCloneProvider: prov,
	})
	vcMgr := svc.VoiceClone
	vcMgr.SetWorkspaceTier(wsID, "pro")
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-c5-001",
		WorkspaceID: wsID,
		CharacterID: "char-c5-001",
		UserID:      "test-user-001",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("100.00"))

	// Part 1: Late completion AFTER release must NOT materialize a ready voice clone or usable asset.
	_, err := vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-c5-late-clone",
		},
		CharacterId:      "char-c5-001",
		Name:             "C5 Late Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/c5-1.mp3"},
		ConsentRecordId:  "consent-c5-001",
		ConsentConfirmed: true,
	}))
	if !errors.Is(err, ErrOutcomeUnknown) {
		t.Fatalf("expected Create timeout to return ErrOutcomeUnknown, got: %v", err)
	}
	// Release via confirmed_not_executed
	if err := vcMgr.ReconcileOperation(ctx, wsID, "idem-c5-late-clone", "confirmed_not_executed", "", "", 0); err != nil {
		t.Fatalf("ReconcileOperation confirmed_not_executed failed: %v", err)
	}
	// Late completed arrives after release -> must fail with ErrReservationAlreadyReleased AND create 0 voice clones!
	lateErr := vcMgr.ReconcileOperation(ctx, wsID, "idem-c5-late-clone", "completed", "el_late_voice_001", "", 0)
	if !errors.Is(lateErr, ErrReservationAlreadyReleased) {
		t.Fatalf("expected ErrReservationAlreadyReleased on late completed after release, got: %v", lateErr)
	}
	clonesAfterLate, _, _ := store.ListVoiceClones(ctx, wsID, "", 100, 0)
	if len(clonesAfterLate) != 0 {
		t.Fatalf("C5 VIOLATION: late completed after release materialized %d usable VoiceCloneRecord(s) in store!", len(clonesAfterLate))
	}

	// Part 2: Concurrent and repeated "completed" reconciliations on a reconciling operation must materialize only 1 output and settle once.
	_ = store.SaveConsentRecord(ctx, &ProductionConsentRecord{
		ConsentID:   "consent-c5-002",
		WorkspaceID: wsID,
		CharacterID: "char-c5-002",
		UserID:      "test-user-001",
		ConsentType: "voice_likeness",
		Granted:     true,
	})
	_, err = vcMgr.Create(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-c5-concurrent-clone",
		},
		CharacterId:      "char-c5-002",
		Name:             "C5 Concurrent Clone",
		SampleAudioUrls:  []string{"https://assets.creativanta.com/c5-2.mp3"},
		ConsentRecordId:  "consent-c5-002",
		ConsentConfirmed: true,
	}))
	if !errors.Is(err, ErrOutcomeUnknown) {
		t.Fatalf("expected Create timeout to return ErrOutcomeUnknown, got: %v", err)
	}

	start := make(chan struct{})
	var wg sync.WaitGroup
	errs := make([]error, 2)
	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			<-start
			errs[idx] = vcMgr.ReconcileOperation(ctx, wsID, "idem-c5-concurrent-clone", "completed", "el_concurrent_voice_002", "", 0)
		}(i)
	}
	close(start)
	wg.Wait()

	for i, e := range errs {
		if e != nil {
			t.Fatalf("expected concurrent completed reconciliation %d to be idempotent, got error: %v", i, e)
		}
	}
	clonesAfterConcurrent, _, _ := store.ListVoiceClones(ctx, wsID, "", 100, 0)
	if len(clonesAfterConcurrent) != 1 {
		t.Fatalf("C5 VIOLATION: concurrent completed reconciliations created %d VoiceCloneRecord(s), expected 1!", len(clonesAfterConcurrent))
	}
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("85.00")) != 0 {
		t.Fatalf("expected balance 85.00 after single 15-credit settlement, got %s", bal.String())
	}

	// Part 3: Voiceover late completion after release must create 0 assets, and concurrent/sequential voiceover completions create 1 asset.
	readyCloneID := clonesAfterConcurrent[0].VoiceCloneID
	_, voErr := vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-c5-late-vo",
		},
		VoiceCloneId: readyCloneID,
		Text:         "Late voiceover test",
		Language:     "en",
	}))
	if !errors.Is(voErr, ErrOutcomeUnknown) {
		t.Fatalf("expected GenerateVoiceover timeout to return ErrOutcomeUnknown, got: %v", voErr)
	}
	if err := vcMgr.ReconcileOperation(ctx, wsID, "idem-c5-late-vo", "confirmed_not_executed", "", "", 0); err != nil {
		t.Fatalf("ReconcileOperation confirmed_not_executed for voiceover failed: %v", err)
	}
	lateVOErr := vcMgr.ReconcileOperation(ctx, wsID, "idem-c5-late-vo", "completed", "", "https://cdn.creativanta.com/c5-late-vo.mp3", 9.0)
	if !errors.Is(lateVOErr, ErrReservationAlreadyReleased) {
		t.Fatalf("expected ErrReservationAlreadyReleased on late voiceover completed after release, got: %v", lateVOErr)
	}
	assetsAfterLateVO, _ := store.GetRecentAssets(ctx, wsID, 100)
	if len(assetsAfterLateVO) != 0 {
		t.Fatalf("C5 VIOLATION: late voiceover completed after release created %d usable Asset(s) in store!", len(assetsAfterLateVO))
	}

	// Concurrent + sequential completed for voiceover
	_, voErr2 := vcMgr.GenerateVoiceover(ctxManager, connect.NewRequest(&productionv1.VoiceCloneServiceGenerateVoiceoverRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-c5-concurrent-vo",
		},
		VoiceCloneId: readyCloneID,
		Text:         "Concurrent voiceover test",
		Language:     "en",
	}))
	if !errors.Is(voErr2, ErrOutcomeUnknown) {
		t.Fatalf("expected GenerateVoiceover timeout to return ErrOutcomeUnknown, got: %v", voErr2)
	}
	startVO := make(chan struct{})
	var wgVO sync.WaitGroup
	voErrs := make([]error, 2)
	for i := 0; i < 2; i++ {
		wgVO.Add(1)
		go func(idx int) {
			defer wgVO.Done()
			<-startVO
			voErrs[idx] = vcMgr.ReconcileOperation(ctx, wsID, "idem-c5-concurrent-vo", "completed", "", "https://cdn.creativanta.com/c5-concurrent-vo.mp3", 11.0)
		}(i)
	}
	close(startVO)
	wgVO.Wait()
	for i, e := range voErrs {
		if e != nil {
			t.Fatalf("expected concurrent voiceover completed reconciliation %d to be idempotent, got: %v", i, e)
		}
	}
	// Sequential replay as well
	if err := vcMgr.ReconcileOperation(ctx, wsID, "idem-c5-concurrent-vo", "completed", "", "https://cdn.creativanta.com/c5-concurrent-vo.mp3", 11.0); err != nil {
		t.Fatalf("expected sequential voiceover completed reconciliation replay to be idempotent, got: %v", err)
	}
	assetsAfterConcurrentVO, _ := store.GetRecentAssets(ctx, wsID, 100)
	if len(assetsAfterConcurrentVO) != 1 {
		t.Fatalf("C5 VIOLATION: concurrent/sequential voiceover completed reconciliations created %d Asset(s), expected 1!", len(assetsAfterConcurrentVO))
	}
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("82.00")) != 0 {
		t.Fatalf("expected balance 82.00 after single 3-credit voiceover settlement, got %s", bal.String())
	}
}

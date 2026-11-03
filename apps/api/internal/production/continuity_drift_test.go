package production

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// makeAuthContext constructs a context with tenant workspace and role.
func makeAuthContext(userID, workspaceID, role string) context.Context {
	ctx := context.Background()
	ctx = context.WithValue(ctx, "caller_role", role)
	ctx = context.WithValue(ctx, "caller_user_id", userID)
	return ctx
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: 15s preview quoted
// ----------------------------------------------------------------------------
func TestAcceptanceTarget1_15sPreviewQuoted(t *testing.T) {
	svc := NewService(ServiceConfig{})
	store := svc.store
	ctx := makeAuthContext("user-ed", "ws-prod", "Editor")

	// 1. Setup an AI Generated character
	char := &ProductionCharacter{
		CharacterID:        "char-mai-01",
		WorkspaceID:        "ws-prod",
		Name:               "Mai",
		CharacterType:      "ai_generated",
		ConsentVerified:    true,
		Status:             "ready",
		VisualSettingsJSON: `{"avatarUrl":"https://cdn.creativanta.io/mai.png"}`,
		VoiceSettingsJSON:  `{"preset":"ai_voice_vi_female_01"}`,
		CreatedAt:          time.Now().UTC(),
		UpdatedAt:          time.Now().UTC(),
	}
	if err := store.SaveCharacter(ctx, char); err != nil {
		t.Fatalf("failed to save character: %v", err)
	}

	// 2. Quote 15s Preview: verifies duration = 15s, credit quote = 5.0 credits
	quoteReq := connect.NewRequest(&productionv1.QuoteCharacterPreviewRequest{
		WorkspaceId:     &commonv1.UUID{Value: "ws-prod"},
		CharacterId:     char.CharacterID,
		DurationSeconds: 15,
	})
	quoteResp, err := svc.AIService.QuoteCharacterPreview(ctx, quoteReq)
	if err != nil {
		t.Fatalf("QuoteCharacterPreview failed: %v", err)
	}
	if quoteResp.Msg.GetDurationSeconds() != 15 {
		t.Fatalf("expected 15 seconds duration quote, got %d", quoteResp.Msg.GetDurationSeconds())
	}
	if quoteResp.Msg.GetCreditsRequired() != "5" && quoteResp.Msg.GetCreditsRequired() != "5.000000" {
		t.Fatalf("expected 5 credits required, got %s", quoteResp.Msg.GetCreditsRequired())
	}
	if !quoteResp.Msg.GetCanAfford() {
		t.Fatalf("expected can_afford=true for default starting balance")
	}

	// 3. Test insufficient credits rejection
	svc.SetWorkspaceBalance("ws-prod", tenantdb.MustParseExactDecimal("2.000000"))
	genReqLowCredit := connect.NewRequest(&productionv1.GenerateCharacterPreviewRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: "ws-prod"},
			IdempotencyKey: "idem-preview-low",
		},
		CharacterId:     char.CharacterID,
		DurationSeconds: 15,
	})
	_, errLowCredit := svc.AIService.GenerateCharacterPreview(ctx, genReqLowCredit)
	if errLowCredit == nil {
		t.Fatalf("expected InsufficientCredits error when balance is 2.0 and preview requires 5.0 credits")
	}

	// 4. Restore balance and generate 15s preview
	svc.SetWorkspaceBalance("ws-prod", tenantdb.MustParseExactDecimal("50.000000"))
	genReq := connect.NewRequest(&productionv1.GenerateCharacterPreviewRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: "ws-prod"},
			IdempotencyKey: "idem-preview-01",
		},
		CharacterId:     char.CharacterID,
		DurationSeconds: 15,
		AspectRatio:     "9:16",
	})
	genResp, err := svc.AIService.GenerateCharacterPreview(ctx, genReq)
	if err != nil {
		t.Fatalf("GenerateCharacterPreview failed: %v", err)
	}
	if genResp.Msg.GetDurationSeconds() != 15 {
		t.Fatalf("expected 15 seconds preview generated, got %d", genResp.Msg.GetDurationSeconds())
	}
	if genResp.Msg.GetCreditsUsed() != "5" && genResp.Msg.GetCreditsUsed() != "5.000000" {
		t.Fatalf("expected 5 credits used, got %s", genResp.Msg.GetCreditsUsed())
	}
	if !genResp.Msg.GetVerified() {
		t.Fatalf("expected verified=true for completed 15s preview")
	}
	if genResp.Msg.GetPreviewAssetId() == "" || genResp.Msg.GetPreviewUrl() == "" {
		t.Fatalf("expected valid preview_asset_id and preview_url")
	}

	// Verify balance decremented by 5.0
	bal := svc.GetWorkspaceBalance("ws-prod")
	if bal.String() != "45" && bal.String() != "45.000000" {
		t.Fatalf("expected 45 credits remaining, got %s", bal.String())
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: High drift blocks readiness
// ----------------------------------------------------------------------------
func TestAcceptanceTarget2_HighDriftBlocksReadiness(t *testing.T) {
	svc := NewService(ServiceConfig{})
	store := svc.store
	ctxEditor := makeAuthContext("user-ed", "ws-prod", "Editor")
	ctxManager := makeAuthContext("user-mgr", "ws-prod", "Manager")

	// 1. Create a generated asset that deviates from canonical references
	now := time.Now().UTC()
	highDriftAsset := &Asset{
		AssetID:               "asset-deviant-01",
		WorkspaceID:           "ws-prod",
		AssetType:             "video",
		Title:                 "Marketing Video with high_drift deviation",
		GenerationPrompt:      "high_drift character variation test",
		GenerationState:       "generated",
		QualityState:          "draft",
		DurationSeconds:       tenantdb.MustParseExactDecimal("30.00"),
		GenerationCostCredits: tenantdb.MustParseExactDecimal("15.000000"),
		ContinuityPackIDs:     []string{"pack-mila-01"},
		CreatedAt:             now,
		UpdatedAt:             now,
	}
	if err := store.CreateAsset(ctxEditor, highDriftAsset); err != nil {
		t.Fatalf("failed to create asset: %v", err)
	}

	// 2. Evaluate Drift: scores 78.5% -> maps to high_drift severity and blocking violation
	evalReq := connect.NewRequest(&productionv1.EvaluateDriftRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		AssetId: highDriftAsset.AssetID,
		PackId:  "pack-mila-01",
	})
	evalResp, err := svc.EvaluateDrift(ctxEditor, evalReq)
	if err != nil {
		t.Fatalf("EvaluateDrift failed: %v", err)
	}

	result := evalResp.Msg.GetResult()
	if result.GetDriftSeverity() != "high_drift" {
		t.Fatalf("expected high_drift severity, got %s", result.GetDriftSeverity())
	}
	if !result.GetIsBlocked() {
		t.Fatalf("expected is_blocked=true for high drift asset")
	}
	if result.GetViolationId() == "" {
		t.Fatalf("expected violation_id to be generated for blocking violation")
	}

	// 3. Acceptance Target 2 Gate: High drift BLOCKS readiness
	// Normal Approve MUST FAIL with ErrHighDriftBlocksReadiness
	appReq := connect.NewRequest(&productionv1.ApproveRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		AssetId: highDriftAsset.AssetID,
	})
	_, approveErr := svc.Approve(ctxManager, appReq)
	if approveErr == nil {
		t.Fatalf("expected Approve to be blocked by high drift, but it passed")
	}

	// Also verify PromoteCanonical is rejected because asset is unapproved
	promReq := connect.NewRequest(&productionv1.PromoteCanonicalRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		AssetId: highDriftAsset.AssetID,
	})
	_, promErr := svc.PromoteCanonical(ctxManager, promReq)
	if promErr == nil {
		t.Fatalf("expected PromoteCanonical to fail on unapproved asset")
	}

	// 4. Test Manager Override requires non-empty justification
	overrideEmptyReq := connect.NewRequest(&productionv1.OverrideDriftViolationRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		ViolationId:    result.GetViolationId(),
		OverrideReason: "", // Empty reason should be rejected
	})
	_, emptyErr := svc.OverrideDriftViolation(ctxManager, overrideEmptyReq)
	if emptyErr == nil {
		t.Fatalf("expected override with empty reason to be rejected")
	}

	// 5. Manager unblocks with valid explicit justification
	overrideValidReq := connect.NewRequest(&productionv1.OverrideDriftViolationRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		ViolationId:    result.GetViolationId(),
		OverrideReason: "Artistic style deviation approved by Creative Director for Halloween campaign",
	})
	overrideResp, err := svc.OverrideDriftViolation(ctxManager, overrideValidReq)
	if err != nil {
		t.Fatalf("OverrideDriftViolation failed: %v", err)
	}
	if !overrideResp.Msg.GetResolved() {
		t.Fatalf("expected resolved=true")
	}
	if overrideResp.Msg.GetNewQualityState() != "approved" {
		t.Fatalf("expected new_quality_state=approved, got %s", overrideResp.Msg.GetNewQualityState())
	}

	// Asset is now approved
	updatedAsset, _ := store.GetAsset(ctxManager, "ws-prod", highDriftAsset.AssetID)
	if updatedAsset.QualityState != "approved" {
		t.Fatalf("expected asset quality state approved after override, got %s", updatedAsset.QualityState)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Consent withdrawal prevents new use
// ----------------------------------------------------------------------------
func TestAcceptanceTarget3_ConsentWithdrawalPreventsNewUse(t *testing.T) {
	svc := NewService(ServiceConfig{})
	store := svc.store
	ctxEditor := makeAuthContext("user-ed", "ws-prod", "Editor")

	// 1. Create a Digital Twin likeness consent record and character
	consentID := "consent-twin-alice"
	cr := &ProductionConsentRecord{
		ConsentID:   consentID,
		UserID:      "user-alice",
		WorkspaceID: "ws-prod",
		ConsentType: "digital_twin",
		Version:     "1.0-GDPR",
		Granted:     true,
		GrantedAt:   timePtr(time.Now().UTC()),
	}
	if err := store.SaveConsentRecord(ctxEditor, cr); err != nil {
		t.Fatalf("failed to save consent: %v", err)
	}

	twinChar := &ProductionCharacter{
		CharacterID:        "char-twin-alice",
		WorkspaceID:        "ws-prod",
		Name:               "Alice Twin",
		CharacterType:      "digital_twin",
		ConsentVerified:    true,
		ConsentRecordID:    consentID,
		Status:             "ready",
		VisualSettingsJSON: `{"face_url":"https://cdn.creativanta.io/alice.jpg"}`,
		CreatedAt:          time.Now().UTC(),
		UpdatedAt:          time.Now().UTC(),
	}
	if err := store.SaveCharacter(ctxEditor, twinChar); err != nil {
		t.Fatalf("failed to save character: %v", err)
	}

	// 2. Verified digital twin successfully generates 15s preview
	prevReq := connect.NewRequest(&productionv1.GenerateCharacterPreviewRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		CharacterId:     twinChar.CharacterID,
		DurationSeconds: 15,
	})
	prevResp, err := svc.AIService.GenerateCharacterPreview(ctxEditor, prevReq)
	if err != nil {
		t.Fatalf("expected successful preview for consented digital twin: %v", err)
	}
	if !prevResp.Msg.GetVerified() {
		t.Fatalf("expected verified=true")
	}

	// 3. User withdraws consent (Consent Revocation)
	if err := store.RevokeConsentRecord(ctxEditor, "ws-prod", consentID); err != nil {
		t.Fatalf("failed to revoke consent: %v", err)
	}

	// 4. Acceptance Target 3 Gate: Consent withdrawal MUST PREVENT ANY NEW USE
	// Re-attempting preview generation MUST FAIL with hard consent error
	prevReqAfterRevoke := connect.NewRequest(&productionv1.GenerateCharacterPreviewRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		CharacterId:     twinChar.CharacterID,
		DurationSeconds: 15,
	})
	_, revokeErr := svc.AIService.GenerateCharacterPreview(ctxEditor, prevReqAfterRevoke)
	if revokeErr == nil {
		t.Fatalf("expected GenerateCharacterPreview to fail after consent revocation, but it succeeded")
	}

	// Verify character was archived and consentVerified set to false
	updatedChar, _ := store.GetCharacter(ctxEditor, "ws-prod", twinChar.CharacterID)
	if updatedChar.ConsentVerified {
		t.Fatalf("expected character.ConsentVerified=false after consent revocation")
	}
	if updatedChar.Status != "archived" {
		t.Fatalf("expected character.Status=archived after consent revocation, got %s", updatedChar.Status)
	}
}

// ----------------------------------------------------------------------------
// EF-07 Style Learning & Transfer Slice Test
// ----------------------------------------------------------------------------
func TestEF07_StyleExtractionAndTransfer(t *testing.T) {
	svc := NewService(ServiceConfig{})
	ctx := makeAuthContext("user-ed", "ws-prod", "Editor")

	// 1. Style Extraction requires 1-5 reference videos and deducts 15 credits
	svc.SetWorkspaceBalance("ws-prod", tenantdb.MustParseExactDecimal("50.000000"))
	extractReq := connect.NewRequest(&productionv1.StylePackServiceExtractRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		SourceAssetIds: []string{"ref-video-01", "ref-video-02"},
	})
	extractResp, err := svc.StylePack.Extract(ctx, extractReq)
	if err != nil {
		t.Fatalf("Extract failed: %v", err)
	}
	if extractResp.Msg.GetCreditsUsed() != "15" && extractResp.Msg.GetCreditsUsed() != "15.000000" {
		t.Fatalf("expected 15 credits used, got %s", extractResp.Msg.GetCreditsUsed())
	}
	elems := extractResp.Msg.GetElements()
	if elems.GetCutPacing() == "" || elems.GetColorPalette() == "" || elems.GetTextStyle() == "" {
		t.Fatalf("expected extracted style parameters populated")
	}

	// 2. Style Pack Creation with Continuity OS integration
	createReq := connect.NewRequest(&productionv1.StylePackServiceCreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		Name:                 "Tech Review Fast Cut Style",
		SourceAssetId:        "ref-video-01",
		ExtractedStyleJson:   extractResp.Msg.GetExtractedStyleJson(),
		LinkToContinuityPack: true,
	})
	createResp, err := svc.StylePack.Create(ctx, createReq)
	if err != nil {
		t.Fatalf("Create style pack failed: %v", err)
	}
	packID := createResp.Msg.GetStylePack().GetStylePackId()
	if packID == "" || createResp.Msg.GetContinuityPackId() == "" {
		t.Fatalf("expected style_pack_id and continuity_pack_id to be populated")
	}

	// 3. Style Pack Get and List
	getReq := connect.NewRequest(&productionv1.StylePackServiceGetRequest{
		WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		StylePackId: packID,
	})
	getResp, err := svc.StylePack.Get(ctx, getReq)
	if err != nil {
		t.Fatalf("Get style pack failed: %v", err)
	}
	if getResp.Msg.GetStylePack().GetName() != "Tech Review Fast Cut Style" {
		t.Fatalf("unexpected style pack name %s", getResp.Msg.GetStylePack().GetName())
	}

	listReq := connect.NewRequest(&productionv1.StylePackServiceListRequest{
		WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
	})
	listResp, err := svc.StylePack.List(ctx, listReq)
	if err != nil {
		t.Fatalf("List style packs failed: %v", err)
	}
	if len(listResp.Msg.GetStylePacks()) != 1 {
		t.Fatalf("expected 1 active style pack, got %d", len(listResp.Msg.GetStylePacks()))
	}

	// 4. Style Transfer / Apply to Production Job
	applyReq := connect.NewRequest(&productionv1.StylePackServiceApplyRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		StylePackId: packID,
		TargetJobId: "job-multi-merge-01",
		TargetMode:  "multi_merge",
	})
	applyResp, err := svc.StylePack.Apply(ctx, applyReq)
	if err != nil {
		t.Fatalf("Apply style pack failed: %v", err)
	}
	if !applyResp.Msg.GetSuccess() {
		t.Fatalf("expected apply success=true")
	}

	// 5. Delete Style Pack (Manager+)
	ctxManager := makeAuthContext("user-mgr", "ws-prod", "Manager")
	delReq := connect.NewRequest(&productionv1.StylePackServiceDeleteRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-prod"},
		},
		StylePackId: packID,
	})
	delResp, err := svc.StylePack.Delete(ctxManager, delReq)
	if err != nil {
		t.Fatalf("Delete style pack failed: %v", err)
	}
	if !delResp.Msg.GetSuccess() {
		t.Fatalf("expected delete success=true")
	}
}

func timePtr(t time.Time) *time.Time {
	return &t
}

package continuity_test

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"testing"

	"connectrpc.com/connect"
	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/continuity"
)

func newTestContext(userID, workspaceID, role string) context.Context {
	return continuity.WithCallerContext(context.Background(), continuity.CallerContext{
		UserID:        userID,
		WorkspaceID:   workspaceID,
		WorkspaceRole: role,
	})
}

// TestAcceptanceTarget1_RevokedConsentBlocksGeneration tests:
// - Granting likeness consent enables digital twin creation
// - Preflight check passes for verified active consent
// - Revoking consent immediately blocks generation preflight
// - Creating a digital twin with revoked consent fails closed
func TestAcceptanceTarget1_RevokedConsentBlocksGeneration(t *testing.T) {
	svc := continuity.NewService(continuity.ServiceConfig{})
	ctx := newTestContext("user_creator_01", "ws_prod_01", "owner")

	// 1. Grant digital twin likeness consent
	grantResp, err := svc.ConsentHandler().Grant(ctx, connect.NewRequest(&contentv1.ConsentServiceGrantRequest{
		UserId:            "user_creator_01",
		WorkspaceId:       "ws_prod_01",
		ConsentType:       "digital_twin",
		Version:           "1.0-GDPR",
		SourceFootageUrl:  "https://cdn.creativanta.io/footage/raw_person_a.mp4",
		ConsentVideoUrl:   "https://cdn.creativanta.io/consent/signed_person_a.mp4",
		DeclarationSigned: true,
	}))
	if err != nil {
		t.Fatalf("unexpected error granting consent: %v", err)
	}
	if !grantResp.Msg.FaceMatchVerified {
		t.Fatal("expected face match to be verified")
	}
	consentID := grantResp.Msg.Record.ConsentId
	if consentID == "" {
		t.Fatal("expected non-empty consent ID")
	}

	// 2. Create Digital Twin character using verified consent
	charResp, err := svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_prod_01",
		Name:            "Executive Twin Alex",
		CharacterType:   contentv1.CharacterType_CHARACTER_TYPE_DIGITAL_TWIN,
		Description:     "Alex corporate presenter",
		ConsentRecordId: consentID,
		WizardStep:      4,
		PreviewVerified: true,
		PreviewVideoUrl: "https://cdn.creativanta.io/previews/preview_alex.mp4",
	}))
	if err != nil {
		t.Fatalf("unexpected error creating digital twin: %v", err)
	}
	charID := charResp.Msg.Character.CharacterId
	if !charResp.Msg.Character.ConsentVerified {
		t.Fatal("expected character to have consent_verified = true")
	}

	// 3. Preflight check for M07 generation: consent is valid
	char, err := svc.CheckGenerationConsent(ctx, "ws_prod_01", charID)
	if err != nil {
		t.Fatalf("expected preflight check to pass, got: %v", err)
	}
	if char.CharacterID != charID {
		t.Fatalf("expected character %s, got %s", charID, char.CharacterID)
	}

	// 4. Revoke consent (Acceptance Target 1)
	revokeResp, err := svc.ConsentHandler().Revoke(ctx, connect.NewRequest(&contentv1.ConsentServiceRevokeRequest{
		UserId:      "user_creator_01",
		WorkspaceId: "ws_prod_01",
		ConsentType: "digital_twin",
		Reason:      "Actor withdrew likeness permission",
	}))
	if err != nil {
		t.Fatalf("unexpected error revoking consent: %v", err)
	}
	if !revokeResp.Msg.Success {
		t.Fatal("expected revoke response success = true")
	}
	if revokeResp.Msg.CharactersDisabledCount < 1 {
		t.Fatalf("expected at least 1 character disabled, got %d", revokeResp.Msg.CharactersDisabledCount)
	}

	// 5. Preflight check for M07 generation MUST FAIL CLOSED
	_, err = svc.CheckGenerationConsent(ctx, "ws_prod_01", charID)
	if err == nil {
		t.Fatal("expected preflight check to fail after consent revocation, but it passed")
	}
	if !errors.Is(err, continuity.ErrConsentRevoked) && !errors.Is(err, continuity.ErrConsentNotVerified) {
		t.Fatalf("expected ErrConsentRevoked or ErrConsentNotVerified, got: %v", err)
	}

	// 6. Attempting to create a new digital twin using revoked consent fails closed
	_, err = svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_prod_01",
		Name:            "Executive Twin Alex V2",
		CharacterType:   contentv1.CharacterType_CHARACTER_TYPE_DIGITAL_TWIN,
		ConsentRecordId: consentID,
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err == nil {
		t.Fatal("expected creation to fail with revoked consent, but succeeded")
	}

	// 7. Verify audit events emitted
	events := svc.GetEvents()
	var grantedEmitted, revokedEmitted bool
	for _, e := range events {
		if e.EventType == "consent.granted" {
			grantedEmitted = true
		}
		if e.EventType == "consent.revoked" {
			revokedEmitted = true
		}
	}
	if !grantedEmitted || !revokedEmitted {
		t.Fatalf("expected audit events for grant and revoke, got: %v", events)
	}
}

// TestAcceptanceTarget2_PackUpdatesRetainOldLineage tests:
// - Creating a pack creates version 1
// - Updating the pack increments version to 2 and snapshots version 1
// - Subsequent updates create version 3 and preserve versions 1 & 2
// - Retrieving pack history returns all previous versions in lineage
func TestAcceptanceTarget2_PackUpdatesRetainOldLineage(t *testing.T) {
	svc := continuity.NewService(continuity.ServiceConfig{})
	ctx := newTestContext("user_manager_01", "ws_prod_01", "manager")

	// 1. Create a brand continuity pack
	createResp, err := svc.ContinuityHandler().Create(ctx, connect.NewRequest(&contentv1.ContinuityServiceCreateRequest{
		WorkspaceId:  "ws_prod_01",
		PackType:     contentv1.PackType_PACK_TYPE_BRAND,
		Name:         "Spring 2026 Brand Pack",
		RulesSummary: "Spring pastel palette and minimal typography",
		ApprovedReferences: []*contentv1.ApprovedReference{
			{
				ReferenceId:   "ref-logo-01",
				Name:          "Primary Brand Logo",
				MediaUrl:      "https://cdn.creativanta.io/brand/logo_v1.svg",
				ReferenceType: "brand_logo",
				Status:        "approved",
			},
		},
	}))
	if err != nil {
		t.Fatalf("unexpected error creating pack: %v", err)
	}
	packID := createResp.Msg.Pack.PackId
	if createResp.Msg.Pack.Version != 1 {
		t.Fatalf("expected initial version 1, got %d", createResp.Msg.Pack.Version)
	}

	// 2. Update pack (creates version 2, snapshots version 1)
	updateResp1, err := svc.ContinuityHandler().UpdatePack(ctx, connect.NewRequest(&contentv1.ContinuityServiceUpdatePackRequest{
		WorkspaceId:  "ws_prod_01",
		PackId:       packID,
		Name:         "Spring 2026 Brand Pack - Rev A",
		RulesSummary: "Updated primary logo colorway",
		ApprovedReferences: []*contentv1.ApprovedReference{
			{
				ReferenceId:   "ref-logo-02",
				Name:          "Primary Brand Logo 2026",
				MediaUrl:      "https://cdn.creativanta.io/brand/logo_v2.svg",
				ReferenceType: "brand_logo",
				Status:        "approved",
			},
		},
		UpdateReason: "Q2 brand refresh",
	}))
	if err != nil {
		t.Fatalf("unexpected error updating pack: %v", err)
	}
	if updateResp1.Msg.Pack.Version != 2 {
		t.Fatalf("expected pack version 2, got %d", updateResp1.Msg.Pack.Version)
	}
	if updateResp1.Msg.ArchivedVersion.VersionIndex != 1 {
		t.Fatalf("expected archived version index 1, got %d", updateResp1.Msg.ArchivedVersion.VersionIndex)
	}
	if updateResp1.Msg.ArchivedVersion.ApprovedReferences[0].ReferenceId != "ref-logo-01" {
		t.Fatalf("expected old reference preserved in archived version, got %s", updateResp1.Msg.ArchivedVersion.ApprovedReferences[0].ReferenceId)
	}

	// 3. Update pack again (creates version 3, snapshots version 2)
	updateResp2, err := svc.ContinuityHandler().UpdatePack(ctx, connect.NewRequest(&contentv1.ContinuityServiceUpdatePackRequest{
		WorkspaceId:  "ws_prod_01",
		PackId:       packID,
		Name:         "Spring 2026 Brand Pack - Final",
		RulesSummary: "Added secondary typography rules",
		UpdateReason: "Final legal sign-off",
	}))
	if err != nil {
		t.Fatalf("unexpected error on second pack update: %v", err)
	}
	if updateResp2.Msg.Pack.Version != 3 {
		t.Fatalf("expected pack version 3, got %d", updateResp2.Msg.Pack.Version)
	}

	// 4. Retrieve complete pack lineage (Acceptance Target 2)
	getPackResp, err := svc.ContinuityHandler().GetPack(ctx, connect.NewRequest(&contentv1.ContinuityServiceGetPackRequest{
		WorkspaceId: "ws_prod_01",
		PackId:      packID,
	}))
	if err != nil {
		t.Fatalf("unexpected error getting pack lineage: %v", err)
	}
	if getPackResp.Msg.Pack.Version != 3 {
		t.Fatalf("expected current version 3, got %d", getPackResp.Msg.Pack.Version)
	}
	// Total versions recorded in history: v1 (initial), v1 (archived upon update to v2), v2 (archived upon update to v3)
	if len(getPackResp.Msg.VersionHistory) < 3 {
		t.Fatalf("expected at least 3 version history records, got %d", len(getPackResp.Msg.VersionHistory))
	}

	// Verify immutable contents of initial version 1
	foundV1 := false
	for _, v := range getPackResp.Msg.VersionHistory {
		if v.VersionIndex == 1 && len(v.ApprovedReferences) > 0 && v.ApprovedReferences[0].ReferenceId == "ref-logo-01" {
			foundV1 = true
			break
		}
	}
	if !foundV1 {
		t.Fatal("expected version 1 with reference ref-logo-01 to be preserved in lineage")
	}

	// 5. Verify continuity.pack_updated domain events were emitted
	events := svc.GetEvents()
	packUpdatedCount := 0
	for _, e := range events {
		if e.EventType == "continuity.pack_updated" {
			packUpdatedCount++
		}
	}
	if packUpdatedCount != 2 {
		t.Fatalf("expected 2 continuity.pack_updated events, got %d", packUpdatedCount)
	}
}

// TestAcceptanceTarget3_OnlyOneDefaultCharacter tests:
// - Workspace enforces exactly one default character
// - First character is automatically made default
// - Second character created with is_default = false does not alter default
// - Third character created with is_default = true atomically unsets previous default
// - Updating a character to is_default = true unsets all other characters
func TestAcceptanceTarget3_OnlyOneDefaultCharacter(t *testing.T) {
	svc := continuity.NewService(continuity.ServiceConfig{})
	svc.Store().SetWorkspaceTier("ws_tier_business", "business") // 15 slots
	ctx := newTestContext("user_lead_01", "ws_tier_business", "owner")

	// 1. Create first character (should become default automatically)
	char1Resp, err := svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_tier_business",
		Name:            "Character Alpha",
		CharacterType:   contentv1.CharacterType_CHARACTER_TYPE_AI_GENERATED,
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err != nil {
		t.Fatalf("unexpected error creating char 1: %v", err)
	}
	if !char1Resp.Msg.Character.IsDefault {
		t.Fatal("expected first character in workspace to be default automatically")
	}
	char1ID := char1Resp.Msg.Character.CharacterId

	// 2. Create second character with is_default = false
	char2Resp, err := svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_tier_business",
		Name:            "Character Beta",
		CharacterType:   contentv1.CharacterType_CHARACTER_TYPE_AI_GENERATED,
		IsDefault:       false,
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err != nil {
		t.Fatalf("unexpected error creating char 2: %v", err)
	}
	if char2Resp.Msg.Character.IsDefault {
		t.Fatal("expected char 2 is_default to be false")
	}
	char2ID := char2Resp.Msg.Character.CharacterId

	// Verify char 1 is still the one and only default
	c1, err := svc.CharacterHandler().Get(ctx, connect.NewRequest(&contentv1.CharacterServiceGetRequest{
		WorkspaceId: "ws_tier_business",
		CharacterId: char1ID,
	}))
	if err != nil || !c1.Msg.Character.IsDefault {
		t.Fatal("expected char 1 to remain default")
	}

	// 3. Create third character with is_default = true
	char3Resp, err := svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_tier_business",
		Name:            "Character Gamma",
		CharacterType:   contentv1.CharacterType_CHARACTER_TYPE_AI_GENERATED,
		IsDefault:       true,
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err != nil {
		t.Fatalf("unexpected error creating char 3: %v", err)
	}
	if !char3Resp.Msg.Character.IsDefault {
		t.Fatal("expected char 3 to be default")
	}
	char3ID := char3Resp.Msg.Character.CharacterId
	if char3ID == "" {
		t.Fatal("expected char 3 character ID to be non-empty")
	}

	// Verify char 1 was atomically unset from default
	c1After, _ := svc.CharacterHandler().Get(ctx, connect.NewRequest(&contentv1.CharacterServiceGetRequest{
		WorkspaceId: "ws_tier_business",
		CharacterId: char1ID,
	}))
	if c1After.Msg.Character.IsDefault {
		t.Fatal("expected char 1 to be unset from default when char 3 was designated default")
	}

	// 4. Update char 2 to become default
	_, err = svc.CharacterHandler().Update(ctx, connect.NewRequest(&contentv1.CharacterServiceUpdateRequest{
		WorkspaceId: "ws_tier_business",
		CharacterId: char2ID,
		Name:        "Character Beta Updated",
		IsDefault:   true,
	}))
	if err != nil {
		t.Fatalf("unexpected error updating char 2 to default: %v", err)
	}

	// Verify list characters has exactly ONE default character across workspace
	listResp, err := svc.CharacterHandler().List(ctx, connect.NewRequest(&contentv1.CharacterServiceListRequest{
		WorkspaceId: "ws_tier_business",
	}))
	if err != nil {
		t.Fatalf("unexpected error listing characters: %v", err)
	}
	defaultCount := 0
	var defaultCharID string
	for _, c := range listResp.Msg.Characters {
		if c.IsDefault {
			defaultCount++
			defaultCharID = c.CharacterId
		}
	}
	if defaultCount != 1 {
		t.Fatalf("expected exactly 1 default character, found %d", defaultCount)
	}
	if defaultCharID != char2ID {
		t.Fatalf("expected char 2 (%s) to be the default character, got %s", char2ID, defaultCharID)
	}
}

// TestCharacterSlotQuotaGating tests RULE-M08-003 and AC 3:
// - Free tier allows 1 character
// - 2nd character creation blocked with ErrSlotQuotaExceeded
// - Archiving character frees slot (A4)
// - Creating character succeeds once slot is freed
func TestCharacterSlotQuotaGating(t *testing.T) {
	svc := continuity.NewService(continuity.ServiceConfig{})
	svc.Store().SetWorkspaceTier("ws_free_tier", "free") // 1 slot
	ctx := newTestContext("user_free", "ws_free_tier", "manager")

	// 1. Create first character (uses 1/1 slot)
	char1Resp, err := svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_free_tier",
		Name:            "Solo Free Avatar",
		CharacterType:   contentv1.CharacterType_CHARACTER_TYPE_AI_GENERATED,
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err != nil {
		t.Fatalf("unexpected error creating first character on free tier: %v", err)
	}
	char1ID := char1Resp.Msg.Character.CharacterId

	// 2. Attempt to create 2nd character (MUST FAIL with ResourceExhausted)
	_, err = svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_free_tier",
		Name:            "Second Character Blocked",
		CharacterType:   contentv1.CharacterType_CHARACTER_TYPE_STOCK,
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err == nil {
		t.Fatal("expected creation to fail when quota is exceeded, but succeeded")
	}
	var connectErr *connect.Error
	if errors.As(err, &connectErr) {
		if connectErr.Code() != connect.CodeResourceExhausted {
			t.Fatalf("expected CodeResourceExhausted, got %v", connectErr.Code())
		}
	}

	// 3. Verify slot quota reflected in List endpoint
	listResp, err := svc.CharacterHandler().List(ctx, connect.NewRequest(&contentv1.CharacterServiceListRequest{
		WorkspaceId: "ws_free_tier",
	}))
	if err != nil {
		t.Fatalf("unexpected error on list: %v", err)
	}
	if listResp.Msg.SlotQuota != 1 {
		t.Fatalf("expected slot quota 1, got %d", listResp.Msg.SlotQuota)
	}
	if listResp.Msg.ActiveCharacterCount != 1 {
		t.Fatalf("expected active count 1, got %d", listResp.Msg.ActiveCharacterCount)
	}

	// 4. Archive character 1 (frees slot per A4)
	delResp, err := svc.CharacterHandler().Delete(ctx, connect.NewRequest(&contentv1.CharacterServiceDeleteRequest{
		WorkspaceId: "ws_free_tier",
		CharacterId: char1ID,
		HardDelete:  false, // Soft delete / archive
	}))
	if err != nil {
		t.Fatalf("unexpected error archiving character: %v", err)
	}
	if delResp.Msg.NewStatus != contentv1.CharacterStatus_CHARACTER_STATUS_ARCHIVED {
		t.Fatalf("expected status ARCHIVED, got %v", delResp.Msg.NewStatus)
	}

	// 5. Creating character now succeeds because slot was freed
	char2Resp, err := svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_free_tier",
		Name:            "New Active Avatar",
		CharacterType:   contentv1.CharacterType_CHARACTER_TYPE_STOCK,
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err != nil {
		t.Fatalf("expected creation to succeed after archiving previous character, got: %v", err)
	}
	if char2Resp.Msg.Character.Name != "New Active Avatar" {
		t.Fatalf("expected name New Active Avatar, got %s", char2Resp.Msg.Character.Name)
	}
}

// TestWizardFlowAndValidation tests RULE-M08-001 (4-step sequence),
// EC-M08-001 (face mismatch), and AC 1 (preview verification).
func TestWizardFlowAndValidation(t *testing.T) {
	svc := continuity.NewService(continuity.ServiceConfig{})
	ctx := newTestContext("user_wizard", "ws_wizard", "manager")

	// 1. Missing Step 3 preview verification MUST fail
	_, err := svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_wizard",
		Name:            "Unpreviewed Avatar",
		WizardStep:      4,
		PreviewVerified: false,
	}))
	if err == nil {
		t.Fatal("expected creation without preview verification to fail")
	}

	// 2. Empty character name MUST fail
	_, err = svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "ws_wizard",
		Name:            "",
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err == nil {
		t.Fatal("expected creation with empty name to fail")
	}

	// 3. EC-M08-001: Face mismatch in consent flow MUST fail
	_, err = svc.ConsentHandler().Grant(ctx, connect.NewRequest(&contentv1.ConsentServiceGrantRequest{
		UserId:            "user_wizard",
		WorkspaceId:       "ws_wizard",
		DeclarationSigned: true,
		SourceFootageUrl:  "https://cdn.creativanta.io/footage/person_a.mp4",
		ConsentVideoUrl:   "https://cdn.creativanta.io/consent/mismatch_person_b.mp4",
	}))
	if err == nil {
		t.Fatal("expected face mismatch in consent to fail, but succeeded")
	}
	if !errors.Is(err, continuity.ErrConsentFaceMismatch) {
		var connErr *connect.Error
		if errors.As(err, &connErr) && connErr.Code() != connect.CodeFailedPrecondition {
			t.Fatalf("expected CodeFailedPrecondition on face mismatch, got %v", connErr.Code())
		}
	}
}

// TestCrossTenantIsolationAndRBAC ensures cross-tenant access is rejected
// and unauthorized roles are blocked.
func TestCrossTenantIsolationAndRBAC(t *testing.T) {
	svc := continuity.NewService(continuity.ServiceConfig{})
	ctxTenantA := newTestContext("user_a", "workspace_a", "manager")

	// Create character in tenant A
	charResp, err := svc.CharacterHandler().Create(ctxTenantA, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "workspace_a",
		Name:            "Tenant A Character",
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err != nil {
		t.Fatalf("unexpected error creating char in tenant A: %v", err)
	}
	charIDA := charResp.Msg.Character.CharacterId

	// Tenant B tries to read Tenant A's character (Must return CodePermissionDenied or CodeNotFound)
	ctxTenantB := newTestContext("user_b", "workspace_b", "manager")
	_, err = svc.CharacterHandler().Get(ctxTenantB, connect.NewRequest(&contentv1.CharacterServiceGetRequest{
		WorkspaceId: "workspace_a", // Spying on workspace A
		CharacterId: charIDA,
	}))
	if err == nil {
		t.Fatal("expected cross-tenant access to fail, but succeeded")
	}

	// Editor role cannot manage continuity packs/characters (requires continuity:pack_manage / Manager+)
	ctxEditor := newTestContext("user_editor", "workspace_a", "editor")
	_, err = svc.CharacterHandler().Create(ctxEditor, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "workspace_a",
		Name:            "Editor Attempt",
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err == nil {
		t.Fatal("expected editor role creation attempt to fail")
	}

	// Viewer role cannot create characters
	ctxViewer := newTestContext("user_viewer", "workspace_a", "viewer")
	_, err = svc.CharacterHandler().Create(ctxViewer, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
		WorkspaceId:     "workspace_a",
		Name:            "Viewer Attempt",
		WizardStep:      4,
		PreviewVerified: true,
	}))
	if err == nil {
		t.Fatal("expected viewer role creation attempt to fail")
	}
}

// TestConcurrentDefaultSetting verifies race-free execution when multiple
// callers attempt to update default character concurrently.
func TestConcurrentDefaultSetting(t *testing.T) {
	svc := continuity.NewService(continuity.ServiceConfig{})
	svc.Store().SetWorkspaceTier("ws_concurrency", "enterprise")
	ctx := newTestContext("user_concurrent", "ws_concurrency", "owner")

	var charIDs []string
	for i := 0; i < 5; i++ {
		resp, err := svc.CharacterHandler().Create(ctx, connect.NewRequest(&contentv1.CharacterServiceCreateRequest{
			WorkspaceId:     "ws_concurrency",
			Name:            fmt.Sprintf("Parallel Char %d", i),
			WizardStep:      4,
			PreviewVerified: true,
		}))
		if err != nil {
			t.Fatalf("unexpected error creating parallel character %d: %v", i, err)
		}
		charIDs = append(charIDs, resp.Msg.Character.CharacterId)
	}

	var wg sync.WaitGroup
	for _, id := range charIDs {
		wg.Add(1)
		go func(charID string) {
			defer wg.Done()
			_, _ = svc.CharacterHandler().Update(ctx, connect.NewRequest(&contentv1.CharacterServiceUpdateRequest{
				WorkspaceId: "ws_concurrency",
				CharacterId: charID,
				IsDefault:   true,
			}))
		}(id)
	}
	wg.Wait()

	listResp, err := svc.CharacterHandler().List(ctx, connect.NewRequest(&contentv1.CharacterServiceListRequest{
		WorkspaceId: "ws_concurrency",
	}))
	if err != nil {
		t.Fatalf("unexpected error on list: %v", err)
	}

	defaultCount := 0
	for _, c := range listResp.Msg.Characters {
		if c.IsDefault {
			defaultCount++
		}
	}
	if defaultCount != 1 {
		t.Fatalf("concurrency violation: expected exactly 1 default character, found %d", defaultCount)
	}
}

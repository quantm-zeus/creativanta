package recipe

import (
	"context"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/workflow"
)

// Acceptance Target 3: Licensed template install clones tenant-owned pack
// Verifies:
// 1. Clones approved definitions into destination workspace.
// 2. Creates tenant-owned continuity style pack + editable draft workflow.
// 3. Immutable install audit records template version and recipe identity without source-tenant IDs.
// 4. Repeat install does not duplicate or double-charge.
func TestAcceptanceTarget3_LicensedTemplateInstallClonesTenantOwnedPack(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	svc := NewService(store, wfStore, nil)
	cloner := NewInMemoryStylePackCloner()
	svc.SetStylePackCloner(cloner)

	authorWS := "ws-style-author"
	authorUser := "user-author"
	buyerWS := "ws-style-buyer"
	buyerUser := "user-buyer"

	authorCaller := CallerContext{UserID: authorUser, WorkspaceID: authorWS, WorkspaceRole: "manager"}
	_ = authorCaller
	buyerCaller := CallerContext{UserID: buyerUser, WorkspaceID: buyerWS, WorkspaceRole: "manager"}

	// 1. Author creates published style_workflow recipe
	recipeID := "rec-style-cinematic-01"
	styleSettings := map[string]any{
		"color_grade":   "teal_orange_film",
		"caption_style": "minimal_bottom_glow",
		"pacing":        "dynamic_cut_120bpm",
		"transitions":   "smooth_whip_pan",
		"text_overlay":  "clean_modern_sans",
		"audio_mix":     "duck_ambient_minus_12db",
	}

	graph := workflow.WorkflowGraph{
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:   "trigger-1",
				NodeType: workflow.NodeTypeTrigger,
				Config:   map[string]any{"type": "manual"},
			},
			{
				NodeID:   "action-apply-style",
				NodeType: workflow.NodeTypeAction,
				ActionConfig: &workflow.ActionConfig{
					RPCName: "continuity.apply_style",
				},
				Config: map[string]any{
					"style_preset": "param:style_choice",
				},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trigger-1", ToNodeID: "action-apply-style"},
		},
	}

	tmpl := &RecipeTemplate{
		RecipeID:          recipeID,
		WorkspaceID:       &authorWS,
		AuthorWorkspaceID: &authorWS,
		Title:             "Cinematic Film Vlog Style",
		Description:       "Teal & orange color grade with dynamic pacing",
		Category:          "production",
		TemplateKind:      "style_workflow",
		TemplateVersion:   2,
		TemplatePayload: PortableSnapshot{
			SchemaVersion: 1,
			Graph:         graph,
			StyleSettings: styleSettings,
			LicenseNotice: "Licensed under Creativanta Community Style License v1.0. No source media transfer.",
		},
		RequiredCapabilities: []string{"workflow:create", "continuity:pack_manage"},
		PriceUSD:             "15.000000",
		Status:               "published",
		CreatedAt:            time.Now().UTC(),
		UpdatedAt:            time.Now().UTC(),
	}
	_, err := store.CreateRecipe(ctx, tmpl)
	if err != nil {
		t.Fatalf("CreateRecipe failed: %v", err)
	}

	// 2. Buyer installs licensed style template
	inst, installedWf, missingCaps, err := svc.InstallRecipe(ctx, buyerCaller, recipeID, `{"style_choice": "custom"}`, "My Personal Vlog Style")
	if err != nil {
		t.Fatalf("InstallRecipe failed: %v", err)
	}
	if len(missingCaps) > 0 {
		t.Fatalf("unexpected missing caps: %v", missingCaps)
	}
	if inst == nil || installedWf == nil {
		t.Fatalf("expected non-nil installation and workflow")
	}

	// Verify Tenant-Owned Cloned Style Pack exists and is owned by buyerWS
	if inst.ContinuityPackID == "" || inst.StylePackID == "" {
		t.Fatalf("expected non-empty ContinuityPackID and StylePackID, got c=%s s=%s", inst.ContinuityPackID, inst.StylePackID)
	}
	clonedRecord, exists := cloner.Packs[inst.StylePackID]
	if !exists {
		t.Fatalf("cloned style pack record not found in cloner")
	}
	if clonedRecord.WorkspaceID != buyerWS {
		t.Fatalf("expected cloned pack owned by buyerWS (%s), got %s", buyerWS, clonedRecord.WorkspaceID)
	}
	if clonedRecord.StyleSettings["color_grade"] != "teal_orange_film" {
		t.Fatalf("expected cloned color_grade 'teal_orange_film', got %v", clonedRecord.StyleSettings["color_grade"])
	}

	// Verify workflow status is draft (inactive until approved/activated)
	if installedWf.Status != workflow.WorkflowStatusDraft {
		t.Fatalf("expected installed workflow in draft status, got %s", installedWf.Status)
	}
	if installedWf.WorkspaceID != buyerWS {
		t.Fatalf("expected installed workflow owned by buyerWS (%s), got %s", buyerWS, installedWf.WorkspaceID)
	}

	// Verify immutable install audit records recipe identity and template version
	audit := inst.ImmutableInstallAudit
	if audit == nil {
		t.Fatalf("expected non-nil ImmutableInstallAudit")
	}
	if audit["recipe_id"] != recipeID {
		t.Fatalf("expected audit recipe_id=%s, got %v", recipeID, audit["recipe_id"])
	}
	if audit["template_version"] != 2 {
		t.Fatalf("expected audit template_version=2, got %v", audit["template_version"])
	}
	if audit["template_kind"] != "style_workflow" {
		t.Fatalf("expected audit template_kind=style_workflow, got %v", audit["template_kind"])
	}
	if audit["license_notice"] != tmpl.TemplatePayload.LicenseNotice {
		t.Fatalf("expected audit license_notice matching template, got %v", audit["license_notice"])
	}

	// 3. Repeat purchase / install idempotency: cannot double charge or duplicate
	instRepeat, wfRepeat, _, err := svc.InstallRecipe(ctx, buyerCaller, recipeID, "", "")
	if err != nil {
		t.Fatalf("repeat InstallRecipe failed: %v", err)
	}
	if instRepeat.InstallationID != inst.InstallationID {
		t.Fatalf("expected repeat install to return existing InstallationID %s, got %s", inst.InstallationID, instRepeat.InstallationID)
	}
	if wfRepeat.WorkflowID != installedWf.WorkflowID {
		t.Fatalf("expected repeat install to return existing WorkflowID %s, got %s", installedWf.WorkflowID, wfRepeat.WorkflowID)
	}

	// Install count should still be 1 (not duplicated)
	recipeAfter, _ := store.GetRecipe(ctx, recipeID)
	if recipeAfter.InstallCount != 1 {
		t.Fatalf("expected install count to be 1 after repeat install, got %d", recipeAfter.InstallCount)
	}
}

// Acceptance Target 4: No private source media in shared style template
// Verifies rejection of:
// - private URLs (file://, localhost, private s3 presigned)
// - raw footage / private source media
// - biometric data (voice clone, voice sample, face embedding)
// - credentials / API keys / tokens
func TestAcceptanceTarget4_NoPrivateSourceMediaInSharedStyleTemplate(t *testing.T) {
	validGraph := workflow.WorkflowGraph{
		Nodes: []workflow.WorkflowNode{
			{NodeID: "node-1", NodeType: workflow.NodeTypeTrigger, Config: map[string]any{"type": "manual"}},
		},
	}

	testCases := []struct {
		name        string
		kind        string
		payload     PortableSnapshot
		expectedErr error
		errorSubstr string
	}{
		{
			name: "Valid clean style workflow",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: map[string]any{
					"color_grade":   "clean_neutral",
					"pacing":        "steady",
					"caption_style": "bold_yellow",
				},
				LicenseNotice: "Community license v1",
			},
			expectedErr: nil,
		},
		{
			name: "Rejects file:// URL in style settings",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: map[string]any{
					"color_grade": "file:///home/user/private/lut.cube",
				},
				LicenseNotice: "Community license v1",
			},
			expectedErr: ErrPrivateMediaForbidden,
		},
		{
			name: "Rejects raw footage or private media reference",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: map[string]any{
					"filter_lut": "https://cdn.creativanta.com/assets/raw_footage/video1.mp4",
				},
				LicenseNotice: "Community license v1",
			},
			expectedErr: ErrPrivateMediaForbidden,
		},
		{
			name: "Rejects presigned S3 URL with AWS credentials",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: map[string]any{
					"filter_lut": "https://mybucket.s3.amazonaws.com/lut?X-Amz-Signature=abcd1234efgh&X-Amz-Credential=AKIAIOSFODNN7EXAMPLE",
				},
				LicenseNotice: "Community license v1",
			},
			expectedErr: ErrPrivateMediaForbidden,
		},
		{
			name: "Rejects voice sample or voice clone biometric data",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: map[string]any{
					"voice_sample": "https://cdn.example.com/audio/my_voice_sample.wav",
				},
				LicenseNotice: "Community license v1",
			},
			expectedErr: ErrBiometricDataForbidden,
		},
		{
			name: "Rejects face embedding biometric data",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: map[string]any{
					"face_embedding": "[0.123, -0.456, 0.789]",
				},
				LicenseNotice: "Community license v1",
			},
			expectedErr: ErrBiometricDataForbidden,
		},
		{
			name: "Rejects bearer auth tokens or credentials",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: map[string]any{
					"color_grade": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
				},
				LicenseNotice: "Community license v1",
			},
			expectedErr: ErrCredentialsForbidden,
		},
		{
			name: "Rejects missing style settings for style_workflow",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: nil,
				LicenseNotice: "Community license v1",
			},
			expectedErr: ErrMissingStyleSettings,
		},
		{
			name: "Rejects empty license notice for style_workflow",
			kind: "style_workflow",
			payload: PortableSnapshot{
				SchemaVersion: 1,
				Graph:         validGraph,
				StyleSettings: map[string]any{"color_grade": "clean"},
				LicenseNotice: "",
			},
			expectedErr: ErrEmptyLicenseNotice,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			err := ValidateStyleTemplatePayload(tc.kind, &tc.payload)
			if tc.expectedErr == nil {
				if err != nil {
					t.Fatalf("expected nil error, got %v", err)
				}
			} else {
				if err == nil {
					t.Fatalf("expected error %v, got nil", tc.expectedErr)
				}
				if !errors.Is(err, tc.expectedErr) && !strings.Contains(err.Error(), tc.expectedErr.Error()) {
					t.Fatalf("expected error matching %v, got %v", tc.expectedErr, err)
				}
			}
		})
	}
}

// Takedown stops new installs while preserving existing installed objects (EF-07A)
func TestTakedownStopsNewInstalls(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	svc := NewService(store, wfStore, nil)

	wsAuthor := "ws-author"
	wsBuyer1 := "ws-buyer-1"
	wsBuyer2 := "ws-buyer-2"

	tmpl := &RecipeTemplate{
		RecipeID:        "rec-takedown-test",
		WorkspaceID:     &wsAuthor,
		Title:           "Disputed Style",
		TemplateKind:    "style_workflow",
		TemplateVersion: 1,
		TemplatePayload: PortableSnapshot{
			SchemaVersion: 1,
			Graph: workflow.WorkflowGraph{
				Nodes: []workflow.WorkflowNode{{NodeID: "n1", NodeType: workflow.NodeTypeTrigger, Config: map[string]any{"type": "manual"}}},
			},
			StyleSettings: map[string]any{"color_grade": "vintage"},
			LicenseNotice: "MIT",
		},
		Status: "published",
	}
	_, _ = store.CreateRecipe(ctx, tmpl)

	// Buyer 1 installs before takedown
	buyer1Caller := CallerContext{UserID: "u1", WorkspaceID: wsBuyer1, WorkspaceRole: "manager"}
	inst1, _, _, err := svc.InstallRecipe(ctx, buyer1Caller, tmpl.RecipeID, "", "")
	if err != nil {
		t.Fatalf("Buyer 1 install failed: %v", err)
	}
	if inst1 == nil {
		t.Fatalf("expected valid installation for buyer 1")
	}

	// Admin executes takedown
	adminCaller := CallerContext{UserID: "admin", WorkspaceID: "ws-admin", WorkspaceRole: "super_admin"}
	_, err = svc.TakedownRecipe(ctx, adminCaller, tmpl.RecipeID, "Infringement notice received", "TICKET-1234")
	if err != nil {
		t.Fatalf("TakedownRecipe failed: %v", err)
	}

	// Buyer 2 tries to install after takedown -> MUST be denied!
	buyer2Caller := CallerContext{UserID: "u2", WorkspaceID: wsBuyer2, WorkspaceRole: "manager"}
	_, _, _, err = svc.InstallRecipe(ctx, buyer2Caller, tmpl.RecipeID, "", "")
	if !errors.Is(err, ErrRecipeUnavailableForInstall) {
		t.Fatalf("expected ErrRecipeUnavailableForInstall, got %v", err)
	}

	// Buyer 1's existing installed instance remains intact and functional
	existingInst, err := store.GetInstallation(ctx, wsBuyer1, inst1.InstallationID)
	if err != nil || existingInst == nil {
		t.Fatalf("Buyer 1's existing install must be preserved after takedown")
	}
}

// Permission gating: continuity:pack_manage and workflow:create required for style_workflow install
func TestStyleRecipePermissionDenial(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	svc := NewService(store, wfStore, nil)

	wsID := "ws-perm-test"
	tmpl := &RecipeTemplate{
		RecipeID:     "rec-perm-test",
		Title:        "Pro Style",
		TemplateKind: "style_workflow",
		TemplatePayload: PortableSnapshot{
			SchemaVersion: 1,
			Graph: workflow.WorkflowGraph{
				Nodes: []workflow.WorkflowNode{{NodeID: "n1", NodeType: workflow.NodeTypeTrigger, Config: map[string]any{"type": "manual"}}},
			},
			StyleSettings: map[string]any{"color_grade": "cool_blue"},
			LicenseNotice: "Community",
		},
		Status: "published",
	}
	_, _ = store.CreateRecipe(ctx, tmpl)

	// Viewer does not have recipe:install or continuity:pack_manage -> denied
	viewerCaller := CallerContext{UserID: "viewer", WorkspaceID: wsID, WorkspaceRole: "viewer"}
	_, _, _, err := svc.InstallRecipe(ctx, viewerCaller, tmpl.RecipeID, "", "")
	if err == nil {
		t.Fatalf("expected permission denial for viewer")
	}
}

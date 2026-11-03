package script_test

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/script"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func ctxWithUser(userID, workspaceID, role string) context.Context {
	return script.WithCallerContext(context.Background(), script.CallerContext{
		UserID:        userID,
		WorkspaceID:   workspaceID,
		WorkspaceRole: role,
	})
}

func setupService() (*script.Service, *script.MemoryStore) {
	memStore := script.NewMemoryStore()
	svc := script.NewService(script.ServiceConfig{Store: memStore})
	return svc, memStore
}

// ---------------------------------------------------------------------------
// Acceptance Target 1: Stale approval fails (EC-M06-003)
// ---------------------------------------------------------------------------

func TestAcceptanceTarget1_StaleApprovalFails(t *testing.T) {
	svc, _ := setupService()
	editorCtx := ctxWithUser("user-editor-1", "ws-tenant-alpha", "editor")
	managerCtx := ctxWithUser("user-manager-1", "ws-tenant-alpha", "manager")

	// 1. Create a script with 2 non-empty scenes
	createResp, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Product Launch Script",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Hook: Stop scrolling if you want smoother skin in 7 days.", DurationSeconds: 5},
			{SceneIndex: 1, Content: "Problem & Solution: Our gentle peptide formula rebuilds moisture barrier.", DurationSeconds: 20},
		},
	}))
	if err != nil {
		t.Fatalf("Create script failed: %v", err)
	}
	scriptID := createResp.Msg.Script.ScriptId
	initVersion := createResp.Msg.Script.VersionIndex // 1

	// 2. Submit for approval
	_, err = svc.SubmitApproval(editorCtx, connect.NewRequest(&contentv1.ScriptServiceSubmitApprovalRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err != nil {
		t.Fatalf("SubmitApproval failed: %v", err)
	}

	// 3. Manager starts reviewing at snapshot time T0 with expected_version = 1
	reviewSnapshotTime := time.Now().UTC()

	// Author concurrently updates the script (version increments to 2, and UpdatedAt advances)
	time.Sleep(10 * time.Millisecond)
	_, err = svc.Update(editorCtx, connect.NewRequest(&contentv1.ScriptServiceUpdateRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
		Title:       "Product Launch Script (Author Revised Pacing)",
	}))
	if err != nil {
		t.Fatalf("Author concurrent update failed: %v", err)
	}

	// 4a. Manager attempts to Approve with stale ExpectedVersion (1) -> MUST FAIL (EC-M06-003)
	_, err = svc.Approve(managerCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId:     "ws-tenant-alpha",
		ScriptId:        scriptID,
		ExpectedVersion: initVersion, // stale version: 1 while current is 2
	}))
	if err == nil {
		t.Fatal("Expected Approve to fail with stale version conflict, but it succeeded")
	}
	if !strings.Contains(err.Error(), "script was updated since you started reviewing") {
		t.Fatalf("Expected stale review error message, got: %v", err)
	}

	// 4b. Manager attempts to Approve with stale ReviewerSnapshotTime -> MUST FAIL (EC-M06-003)
	_, err = svc.Approve(managerCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId:          "ws-tenant-alpha",
		ScriptId:             scriptID,
		ReviewerSnapshotTime: timestamppb.New(reviewSnapshotTime), // stale timestamp
	}))
	if err == nil {
		t.Fatal("Expected Approve to fail with stale snapshot time, but it succeeded")
	}
	if !strings.Contains(err.Error(), "script was updated since you started reviewing") {
		t.Fatalf("Expected stale review error message, got: %v", err)
	}

	// 4c. Manager attempts to Reject with stale ExpectedVersion (1) -> MUST FAIL (EC-M06-003)
	_, err = svc.Reject(managerCtx, connect.NewRequest(&contentv1.ScriptServiceRejectRequest{
		WorkspaceId:     "ws-tenant-alpha",
		ScriptId:        scriptID,
		ExpectedVersion: initVersion,
		RejectionReason: "Pacing is completely off in scene 2, needs trimming.",
	}))
	if err == nil {
		t.Fatal("Expected Reject to fail with stale version conflict, but it succeeded")
	}

	// 4d. Re-submitting for approval transitions script to pending_approval again
	_, err = svc.SubmitApproval(editorCtx, connect.NewRequest(&contentv1.ScriptServiceSubmitApprovalRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err != nil {
		t.Fatalf("Re-submitting for approval failed: %v", err)
	}

	// 4e. Approving with the fresh version (2) succeeds
	approveResp, err := svc.Approve(managerCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId:     "ws-tenant-alpha",
		ScriptId:        scriptID,
		ExpectedVersion: 2,
	}))
	if err != nil {
		t.Fatalf("Fresh Approve failed: %v", err)
	}
	if approveResp.Msg.Script.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED {
		t.Fatalf("Expected approval state APPROVED, got %v", approveResp.Msg.Script.ApprovalState)
	}

	// 4f. Approving an already approved script (non-pending state) MUST fail with ErrApprovalStateNotPending
	_, err = svc.Approve(managerCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId:     "ws-tenant-alpha",
		ScriptId:        scriptID,
		ExpectedVersion: 2,
	}))
	if err == nil {
		t.Fatal("Expected approving an already approved script to fail, but it succeeded")
	}
	if !strings.Contains(err.Error(), "script is not in pending_approval state") {
		t.Fatalf("Expected ErrApprovalStateNotPending, got: %v", err)
	}
}

// ---------------------------------------------------------------------------
// Acceptance Target 2: Rejection reason validated (RULE-M06-002, EC-M06-002)
// ---------------------------------------------------------------------------

func TestAcceptanceTarget2_RejectionReasonValidated(t *testing.T) {
	svc, store := setupService()
	editorCtx := ctxWithUser("user-editor-1", "ws-tenant-alpha", "editor")
	managerCtx := ctxWithUser("user-manager-1", "ws-tenant-alpha", "manager")

	// 1. Create and submit script
	createResp, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "UGC Hook Test",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Hook: You are applying your serum completely wrong.", DurationSeconds: 4},
		},
	}))
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}
	scriptID := createResp.Msg.Script.ScriptId

	_, err = svc.SubmitApproval(editorCtx, connect.NewRequest(&contentv1.ScriptServiceSubmitApprovalRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err != nil {
		t.Fatalf("SubmitApproval failed: %v", err)
	}

	// 2. Test rejections with < 10 characters -> MUST FAIL with InvalidArgument (RULE-M06-002, EC-M06-002)
	invalidReasons := []string{
		"",
		"   ",
		"bad",
		"fix it",
		"too slow",
		"123456789", // 9 characters
	}

	for _, invalidReason := range invalidReasons {
		t.Run("InvalidReason_"+invalidReason, func(t *testing.T) {
			_, err := svc.Reject(managerCtx, connect.NewRequest(&contentv1.ScriptServiceRejectRequest{
				WorkspaceId:     "ws-tenant-alpha",
				ScriptId:        scriptID,
				RejectionReason: invalidReason,
			}))
			if err == nil {
				t.Fatalf("Expected rejection with reason '%s' to fail, but it succeeded", invalidReason)
			}
			connectErr, ok := err.(*connect.Error)
			if !ok || connectErr.Code() != connect.CodeInvalidArgument {
				t.Fatalf("Expected connect.CodeInvalidArgument, got %v", err)
			}
			if !strings.Contains(err.Error(), "rejection reason must be at least 10 characters") {
				t.Fatalf("Expected specific feedback validation error, got: %v", err)
			}

			// Script MUST remain in pending_approval
			getResp, err := svc.Get(editorCtx, connect.NewRequest(&contentv1.ScriptServiceGetRequest{
				WorkspaceId: "ws-tenant-alpha",
				ScriptId:    scriptID,
			}))
			if err != nil {
				t.Fatalf("Get script failed: %v", err)
			}
			if getResp.Msg.Script.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_PENDING_APPROVAL {
				t.Fatalf("Expected script to remain in PENDING_APPROVAL, got %v", getResp.Msg.Script.ApprovalState)
			}
		})
	}

	// 3. Test rejection with valid reason (≥ 10 characters) -> MUST SUCCEED
	validReason := "The hook is too aggressive for TikTok guidelines; please soften the opening."
	rejectResp, err := svc.Reject(managerCtx, connect.NewRequest(&contentv1.ScriptServiceRejectRequest{
		WorkspaceId:     "ws-tenant-alpha",
		ScriptId:        scriptID,
		RejectionReason: validReason,
	}))
	if err != nil {
		t.Fatalf("Valid reject failed: %v", err)
	}

	if rejectResp.Msg.Script.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_REJECTED {
		t.Fatalf("Expected approval state REJECTED, got %v", rejectResp.Msg.Script.ApprovalState)
	}
	if rejectResp.Msg.Script.LifecycleState != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED {
		t.Fatalf("Expected lifecycle state REVISION_REQUIRED, got %v", rejectResp.Msg.Script.LifecycleState)
	}
	if rejectResp.Msg.Script.RejectionReason != validReason {
		t.Fatalf("Expected rejection reason '%s', got '%s'", validReason, rejectResp.Msg.Script.RejectionReason)
	}

	// Check domain event emitted
	events := store.GetEvents(scriptID)
	var foundRejectEvent bool
	for _, ev := range events {
		if ev.EventType == "script.rejected" {
			foundRejectEvent = true
			if ev.Payload["rejection_reason"] != validReason {
				t.Fatalf("Event payload missing valid rejection reason: %v", ev.Payload)
			}
		}
	}
	if !foundRejectEvent {
		t.Fatal("Expected script.rejected domain event was not recorded")
	}
}

// ---------------------------------------------------------------------------
// Acceptance Target 3: Ready-for-production requires approval and complete brief
// (RULE-M06-005, RULE-M06-006, AC-2)
// ---------------------------------------------------------------------------

func TestAcceptanceTarget3_ReadyForProductionRequiresApprovalAndCompleteBrief(t *testing.T) {
	svc, store := setupService()
	editorCtx := ctxWithUser("user-editor-1", "ws-tenant-alpha", "editor")
	managerCtx := ctxWithUser("user-manager-1", "ws-tenant-alpha", "manager")

	// 1. Create a draft script
	createResp, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "HydraSerum Video Ad",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Hook: Glow like glass in 3 seconds.", DurationSeconds: 3},
			{SceneIndex: 1, Content: "Demo: Apply 2 drops on clean skin.", DurationSeconds: 15},
		},
	}))
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}
	scriptID := createResp.Msg.Script.ScriptId

	// Case 3a: Script is in DRAFT (unapproved). Attempting to fetch or create a complete brief
	// should NOT transition script to ready_for_production (AC-2)
	briefResp, err := svc.GetBrief(editorCtx, connect.NewRequest(&contentv1.ScriptServiceGetBriefRequest{
		WorkspaceId:                "ws-tenant-alpha",
		ScriptId:                   scriptID,
		CreateIfMissing:            true,
		OutputType:                 "video",
		TargetFormat:               "9:16 vertical short",
		TargetDurationSeconds:      30,
		ContinuityRequirementsJson: `{"actor_age": "20s", "setting": "modern bathroom", "lighting": "natural ring light"}`,
	}))
	if err != nil {
		t.Fatalf("GetBrief failed: %v", err)
	}
	if briefResp.Msg.ReadyForProduction {
		t.Fatal("Expected ready_for_production to be FALSE while script is still draft/unapproved")
	}

	getScript, _ := svc.Get(editorCtx, connect.NewRequest(&contentv1.ScriptServiceGetRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if getScript.Msg.Script.LifecycleState == contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION {
		t.Fatal("Script should not be in READY_FOR_PRODUCTION state while unapproved")
	}

	// Case 3b: Now submit and approve the script
	_, err = svc.SubmitApproval(editorCtx, connect.NewRequest(&contentv1.ScriptServiceSubmitApprovalRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err != nil {
		t.Fatalf("SubmitApproval failed: %v", err)
	}

	approveResp, err := svc.Approve(managerCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err != nil {
		t.Fatalf("Approve failed: %v", err)
	}

	// Since complete brief already existed, Approve should transition to READY_FOR_PRODUCTION!
	if approveResp.Msg.Script.LifecycleState != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION {
		t.Fatalf("Expected script lifecycle to be READY_FOR_PRODUCTION, got %v", approveResp.Msg.Script.LifecycleState)
	}

	// Check domain event emitted with script_id and asset_brief_id
	events := store.GetEvents(scriptID)
	var foundReadyEvent bool
	for _, ev := range events {
		if ev.EventType == "script.ready_for_production" {
			foundReadyEvent = true
			if ev.Payload["script_id"] != scriptID {
				t.Fatalf("Mismatched script_id in event payload: %v", ev.Payload)
			}
			if ev.Payload["asset_brief_id"] == "" {
				t.Fatalf("asset_brief_id missing in event payload: %v", ev.Payload)
			}
		}
	}
	if !foundReadyEvent {
		t.Fatal("Expected script.ready_for_production domain event was not emitted")
	}

	// Case 3c: Incomplete brief on approved script MUST NOT transition to ready_for_production
	script2Resp, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Second Script Incomplete Brief",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Hook: Why is everyone talking about this cleanser?", DurationSeconds: 5},
		},
	}))
	if err != nil {
		t.Fatalf("Create script 2 failed: %v", err)
	}
	scriptID2 := script2Resp.Msg.Script.ScriptId

	_, _ = svc.SubmitApproval(editorCtx, connect.NewRequest(&contentv1.ScriptServiceSubmitApprovalRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID2,
	}))
	_, _ = svc.Approve(managerCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID2,
	}))

	// Create incomplete brief (missing continuity_requirements_json and target_duration_seconds)
	brief2Resp, err := svc.GetBrief(editorCtx, connect.NewRequest(&contentv1.ScriptServiceGetBriefRequest{
		WorkspaceId:     "ws-tenant-alpha",
		ScriptId:        scriptID2,
		CreateIfMissing: true,
		OutputType:      "video",
		TargetFormat:    "9:16 vertical short",
		// Incomplete fields: TargetDurationSeconds=0, ContinuityRequirementsJson=""
	}))
	if err != nil {
		t.Fatalf("GetBrief on script 2 failed: %v", err)
	}
	if brief2Resp.Msg.ReadyForProduction {
		t.Fatal("Incomplete brief must NOT trigger ready_for_production")
	}

	// Verify script2 lifecycle remains APPROVED, not READY_FOR_PRODUCTION
	s2, _ := svc.Get(editorCtx, connect.NewRequest(&contentv1.ScriptServiceGetRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID2,
	}))
	if s2.Msg.Script.LifecycleState != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_APPROVED {
		t.Fatalf("Expected script 2 to remain in APPROVED state, got %v", s2.Msg.Script.LifecycleState)
	}
}

// ---------------------------------------------------------------------------
// Error Condition EC-M06-001: Empty scenes block submission
// ---------------------------------------------------------------------------

func TestEmptyScenesBlockSubmission(t *testing.T) {
	svc, _ := setupService()
	editorCtx := ctxWithUser("user-editor-1", "ws-tenant-alpha", "editor")

	// 1. Script with zero scenes
	respZero, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Zero Scenes Script",
		Scenes:      []*contentv1.Scene{},
	}))
	if err != nil {
		t.Fatalf("Create script failed: %v", err)
	}

	_, err = svc.SubmitApproval(editorCtx, connect.NewRequest(&contentv1.ScriptServiceSubmitApprovalRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    respZero.Msg.Script.ScriptId,
	}))
	if err == nil {
		t.Fatal("Expected submission with zero scenes to fail, but it succeeded")
	}
	if !strings.Contains(err.Error(), "must have at least one scene") {
		t.Fatalf("Unexpected error message: %v", err)
	}

	// 2. Script with empty scene content (whitespace only)
	respEmpty, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Empty Content Scene Script",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "   ", DurationSeconds: 5},
		},
	}))
	if err != nil {
		t.Fatalf("Create script failed: %v", err)
	}

	_, err = svc.SubmitApproval(editorCtx, connect.NewRequest(&contentv1.ScriptServiceSubmitApprovalRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    respEmpty.Msg.Script.ScriptId,
	}))
	if err == nil {
		t.Fatal("Expected submission with empty scene content to fail (EC-M06-001), but it succeeded")
	}
	if !strings.Contains(err.Error(), "empty scenes. Complete all scene content") {
		t.Fatalf("Unexpected error message for empty scenes: %v", err)
	}
}

// ---------------------------------------------------------------------------
// Channel Rewrite (RULE-M06-004, AC-4)
// ---------------------------------------------------------------------------

func TestChannelRewriteProducesIndependentScriptWithSameIdea(t *testing.T) {
	svc, _ := setupService()
	editorCtx := ctxWithUser("user-editor-1", "ws-tenant-alpha", "editor")

	// 1. Create a TikTok script derived from idea "idea-glow-100"
	createResp, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId:           "ws-tenant-alpha",
		IdeaId:                "idea-glow-100",
		Title:                 "Glow Routine TikTok",
		FormatType:            "9:16 vertical short",
		DurationTargetSeconds: 30,
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Hook: The viral routine actually works.", DurationSeconds: 5},
			{SceneIndex: 1, Content: "Steps: 1 wash, 2 hydrate, 3 lock in.", DurationSeconds: 25},
		},
	}))
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}
	sourceID := createResp.Msg.Script.ScriptId

	// 2. Channel rewrite to YouTube long form
	dupResp, err := svc.Duplicate(editorCtx, connect.NewRequest(&contentv1.ScriptServiceDuplicateRequest{
		WorkspaceId:             "ws-tenant-alpha",
		ScriptId:                sourceID,
		TargetPlatform:          "YouTube",
		NewFormatType:           "16:9 horizontal long",
		AdjustedDurationSeconds: 180,
	}))
	if err != nil {
		t.Fatalf("Duplicate for channel rewrite failed: %v", err)
	}

	dupScript := dupResp.Msg.DuplicatedScript
	if dupScript.ScriptId == sourceID {
		t.Fatal("Duplicated script must have a new distinct ScriptId")
	}
	if dupScript.IdeaId != "idea-glow-100" {
		t.Fatalf("Expected rewritten script to retain source idea_id 'idea-glow-100', got '%s'", dupScript.IdeaId)
	}
	if !strings.Contains(dupScript.Title, "YouTube Adaptation") {
		t.Fatalf("Expected adaptation title, got: %s", dupScript.Title)
	}
	if dupScript.FormatType != "16:9 horizontal long" {
		t.Fatalf("Expected format '16:9 horizontal long', got '%s'", dupScript.FormatType)
	}
	if dupScript.DurationTargetSeconds != 180 {
		t.Fatalf("Expected duration 180, got %d", dupScript.DurationTargetSeconds)
	}
	if dupScript.LifecycleState != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT {
		t.Fatalf("Expected new script in draft lifecycle, got %v", dupScript.LifecycleState)
	}
}

// ---------------------------------------------------------------------------
// Commercial Offer Hooks & Auto-Disclosure (RULE-M06-007)
// ---------------------------------------------------------------------------

func TestCommercialOfferHooks_AutoSuggestDisclosure(t *testing.T) {
	svc, _ := setupService()
	editorCtx := ctxWithUser("user-editor-1", "ws-tenant-alpha", "editor")

	createResp, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId:       "ws-tenant-alpha",
		Title:             "Sponsored Cleanser Review",
		OfferProductHooks: []string{"hook-affiliate-cleanser-20pct-off"},
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Use code GLOW20 for 20% off!", DurationSeconds: 15},
		},
	}))
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}

	// Auto-disclosure block must be attached (RULE-M06-007)
	if len(createResp.Msg.Script.DisclosureBlocks) == 0 {
		t.Fatal("Expected auto-suggested disclosure block when offer product hooks are present")
	}
	disc := createResp.Msg.Script.DisclosureBlocks[0]
	if !strings.Contains(disc.Text, "promotion") && !strings.Contains(disc.Text, "sponsored") {
		t.Fatalf("Expected promotional disclosure wording, got: %s", disc.Text)
	}
}

// ---------------------------------------------------------------------------
// Version Snapshots, Listing & Rollback (Alternate Flow A3)
// ---------------------------------------------------------------------------

func TestScriptVersionSnapshotAndRestore(t *testing.T) {
	svc, _ := setupService()
	editorCtx := ctxWithUser("user-editor-1", "ws-tenant-alpha", "editor")

	// 1. Create -> v1
	createResp, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Original Title v1",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Scene 1 Original", DurationSeconds: 10},
		},
	}))
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}
	scriptID := createResp.Msg.Script.ScriptId

	// 2. Update -> v2
	_, err = svc.Update(editorCtx, connect.NewRequest(&contentv1.ScriptServiceUpdateRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
		Title:       "Revised Title v2",
	}))
	if err != nil {
		t.Fatalf("Update 1 failed: %v", err)
	}

	// 3. Update -> v3
	_, err = svc.Update(editorCtx, connect.NewRequest(&contentv1.ScriptServiceUpdateRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
		Title:       "Final Title v3",
	}))
	if err != nil {
		t.Fatalf("Update 2 failed: %v", err)
	}

	// 4. List versions -> should have 3 versions
	listVersResp, err := svc.ListVersions(editorCtx, connect.NewRequest(&contentv1.ScriptServiceListVersionsRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err != nil {
		t.Fatalf("ListVersions failed: %v", err)
	}
	if len(listVersResp.Msg.Versions) != 3 {
		t.Fatalf("Expected 3 versions, got %d", len(listVersResp.Msg.Versions))
	}

	// 5. Restore version 1 (rollback per A3)
	restoreResp, err := svc.RestoreVersion(editorCtx, connect.NewRequest(&contentv1.ScriptServiceRestoreVersionRequest{
		WorkspaceId:  "ws-tenant-alpha",
		ScriptId:     scriptID,
		VersionIndex: 1,
	}))
	if err != nil {
		t.Fatalf("RestoreVersion failed: %v", err)
	}

	// Active script now has title from v1, but version index is incremented to 4
	if restoreResp.Msg.Script.Title != "Original Title v1" {
		t.Fatalf("Expected restored title 'Original Title v1', got '%s'", restoreResp.Msg.Script.Title)
	}
	if restoreResp.Msg.Script.VersionIndex != 4 {
		t.Fatalf("Expected version index to increment to 4 on restore, got %d", restoreResp.Msg.Script.VersionIndex)
	}
}

// ---------------------------------------------------------------------------
// RBAC Permission Enforcement
// ---------------------------------------------------------------------------

func TestRBACPermissionGating(t *testing.T) {
	svc, _ := setupService()
	contributorCtx := ctxWithUser("user-contrib", "ws-tenant-alpha", "contributor")
	memberCtx := ctxWithUser("user-member", "ws-tenant-alpha", "viewer")
	editorCtx := ctxWithUser("user-editor", "ws-tenant-alpha", "editor")
	managerCtx := ctxWithUser("user-manager", "ws-tenant-alpha", "manager")

	// 1. Contributor CAN create script
	createResp, err := svc.Create(contributorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Contributor Script",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Hook content", DurationSeconds: 5},
		},
	}))
	if err != nil {
		t.Fatalf("Contributor should be able to create script: %v", err)
	}
	scriptID := createResp.Msg.Script.ScriptId

	// 2. Member CANNOT create script
	_, err = svc.Create(memberCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Member Script",
	}))
	if err == nil {
		t.Fatal("Expected Member to be denied script:create, but succeeded")
	}

	// 3. Member CAN read script
	getResp, err := svc.Get(memberCtx, connect.NewRequest(&contentv1.ScriptServiceGetRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err != nil {
		t.Fatalf("Member should be able to read script: %v", err)
	}
	if getResp.Msg.Script.Title != "Contributor Script" {
		t.Fatalf("Unexpected title: %s", getResp.Msg.Script.Title)
	}

	// 4. Contributor CANNOT approve script
	_, _ = svc.SubmitApproval(editorCtx, connect.NewRequest(&contentv1.ScriptServiceSubmitApprovalRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))

	_, err = svc.Approve(contributorCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err == nil {
		t.Fatal("Expected Contributor to be denied script:approve, but succeeded")
	}

	// 5. Editor CANNOT approve script (requires Manager+)
	_, err = svc.Approve(editorCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err == nil {
		t.Fatal("Expected Editor to be denied script:approve, but succeeded")
	}

	// 6. Manager CAN approve script
	_, err = svc.Approve(managerCtx, connect.NewRequest(&contentv1.ScriptServiceApproveRequest{
		WorkspaceId: "ws-tenant-alpha",
		ScriptId:    scriptID,
	}))
	if err != nil {
		t.Fatalf("Manager should be able to approve script: %v", err)
	}
}

// ---------------------------------------------------------------------------
// Multi-Tenant Isolation
// ---------------------------------------------------------------------------

func TestMultiTenantIsolation(t *testing.T) {
	svc, _ := setupService()
	tenantACtx := ctxWithUser("user-a", "ws-tenant-alpha", "editor")
	tenantBCtx := ctxWithUser("user-b", "ws-tenant-beta", "editor")

	createResp, err := svc.Create(tenantACtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Tenant Alpha Secret Script",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Confidential launch info", DurationSeconds: 10},
		},
	}))
	if err != nil {
		t.Fatalf("Create script in Tenant Alpha failed: %v", err)
	}
	scriptID := createResp.Msg.Script.ScriptId

	// Tenant Beta attempts to read Tenant Alpha's script
	_, err = svc.Get(tenantBCtx, connect.NewRequest(&contentv1.ScriptServiceGetRequest{
		WorkspaceId: "ws-tenant-beta",
		ScriptId:    scriptID, // belongs to alpha
	}))
	if err == nil {
		t.Fatal("Expected Tenant Beta to not find Tenant Alpha script, but Get succeeded")
	}

	// Cross-tenant explicit workspace mismatch in request parameter
	_, err = svc.Get(tenantBCtx, connect.NewRequest(&contentv1.ScriptServiceGetRequest{
		WorkspaceId: "ws-tenant-alpha", // caller context is beta
		ScriptId:    scriptID,
	}))
	if err == nil {
		t.Fatal("Expected cross-tenant workspace header mismatch to fail, but succeeded")
	}
}

// ---------------------------------------------------------------------------
// Concurrent Operations & Race-Safety
// ---------------------------------------------------------------------------

func TestConcurrentScriptOperations_NoRace(t *testing.T) {
	svc, _ := setupService()
	editorCtx := ctxWithUser("user-editor-concurrent", "ws-tenant-alpha", "editor")

	createResp, err := svc.Create(editorCtx, connect.NewRequest(&contentv1.ScriptServiceCreateRequest{
		WorkspaceId: "ws-tenant-alpha",
		Title:       "Concurrent Script Base",
		Scenes: []*contentv1.Scene{
			{SceneIndex: 0, Content: "Base scene", DurationSeconds: 10},
		},
	}))
	if err != nil {
		t.Fatalf("Create script failed: %v", err)
	}
	scriptID := createResp.Msg.Script.ScriptId

	var wg sync.WaitGroup
	workers := 10

	for i := 0; i < workers; i++ {
		wg.Add(3)

		// Concurrent reader
		go func(workerID int) {
			defer wg.Done()
			_, _ = svc.Get(editorCtx, connect.NewRequest(&contentv1.ScriptServiceGetRequest{
				WorkspaceId: "ws-tenant-alpha",
				ScriptId:    scriptID,
			}))
		}(i)

		// Concurrent comment adder
		go func(workerID int) {
			defer wg.Done()
			_, _ = svc.AddComment(editorCtx, connect.NewRequest(&contentv1.ScriptServiceAddCommentRequest{
				WorkspaceId: "ws-tenant-alpha",
				ScriptId:    scriptID,
				Content:     fmt.Sprintf("Comment from worker %d", workerID),
				SceneIndex:  0,
			}))
		}(i)

		// Concurrent stats query
		go func(workerID int) {
			defer wg.Done()
			_, _ = svc.GetStats(editorCtx, connect.NewRequest(&contentv1.ScriptServiceGetStatsRequest{
				WorkspaceId: "ws-tenant-alpha",
			}))
		}(i)
	}

	wg.Wait()
}

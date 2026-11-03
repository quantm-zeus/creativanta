package content_test

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/content"
	"github.com/quantm-zeus/creativanta/apps/api/internal/idea"
	"github.com/quantm-zeus/creativanta/apps/api/internal/opportunity"
	"github.com/quantm-zeus/creativanta/apps/api/internal/script"
	"github.com/quantm-zeus/creativanta/apps/api/internal/trend"
)

func setupTestEnvironment() (*content.Service, *script.MemoryStore, *idea.MemoryStore, *opportunity.MemoryStore, *trend.MemoryStore) {
	ss := script.NewMemoryStore()
	is := idea.NewMemoryStore()
	os := opportunity.NewMemoryStore()
	ts := trend.NewMemoryStore()

	svc := content.NewService(content.ServiceConfig{
		ScriptStore:      ss,
		IdeaStore:        is,
		OpportunityStore: os,
		TrendStore:       ts,
	})

	return svc, ss, is, os, ts
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Source chain reaches approved brief
// ----------------------------------------------------------------------------

func TestTarget1_SourceChainReachesApprovedBrief(t *testing.T) {
	ctx := context.Background()
	svc, _, is, os, ts := setupTestEnvironment()

	wsID := "ws-content-001"
	editorCaller := content.CallerContext{
		UserID:        "user-editor",
		WorkspaceID:   wsID,
		WorkspaceRole: "editor",
	}
	managerCaller := content.CallerContext{
		UserID:        "user-manager",
		WorkspaceID:   wsID,
		WorkspaceRole: "manager",
	}

	// Step 1: Create source Trend (M02)
	trendID := "tr-skincare-2026"
	err := ts.SaveTrend(ctx, trend.StoredTrend{
		TrendID:        trendID,
		WorkspaceID:    wsID,
		Title:          "Skincare Routine Peptide",
		Summary:        "Peptide-based morning skincare routine trending on TikTok",
		StrengthScore:  88.5,
		VelocityScore:  92.0,
		FreshnessScore: 85.0,
		Confidence:     intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		SourceClass:    intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		LifecycleState: intelligencev1.LifecycleState_LIFECYCLE_STATE_RISING,
		FreshnessAt:    time.Now().UTC(),
	})
	if err != nil {
		t.Fatalf("failed to save trend: %v", err)
	}

	// Step 2: Create Opportunity referencing the Trend (M04)
	oppID := "opp-skincare-morning"
	err = os.SaveOpportunity(ctx, opportunity.StoredOpportunity{
		OpportunityID:   oppID,
		WorkspaceID:     wsID,
		OpportunityType: "content",
		Title:           "Sáng tạo video routine peptide buổi sáng",
		Summary:         "Nắm bắt trào lưu peptide trước khi bão hòa",
		WhyItMatters:    "Tăng chuyển đổi sản phẩm serum peptide",
		ExpectedImpact:  opportunity.StoredExpectedImpact{Score: 85},
		ExpectedEffort:  opportunity.StoredExpectedEffort{Score: 30},
		PriorityState:   intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED,
		PriorityReason:  "Velocity cao và tệp khán giả phù hợp",
		OwnerUserID:     "user-editor",
		Confidence:      intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		SourceClass:     intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		Sources: []opportunity.StoredOpportunitySource{
			{SourceID: trendID, SourceType: "trend"},
		},
		CreatedAt: time.Now().UTC(),
		UpdatedAt: time.Now().UTC(),
	})
	if err != nil {
		t.Fatalf("failed to save opportunity: %v", err)
	}

	// Step 3: Convert Opportunity to Idea (M05)
	createdIdea, err := svc.ConvertOpportunityToIdea(ctx, editorCaller, content.ConvertOpportunityToIdeaRequest{
		WorkspaceID:     wsID,
		OpportunityID:   oppID,
		Title:           "Ý tưởng: 3 bước dùng peptide không bết dính",
		AudienceIntent:  "Khán giả trẻ muốn da căng bóng không nhờn rít",
		SuggestedFormat: "9:16 vertical short",
	})
	if err != nil {
		t.Fatalf("ConvertOpportunityToIdea failed: %v", err)
	}
	if createdIdea.IdeaID == "" || len(createdIdea.Sources) == 0 {
		t.Fatalf("expected created idea with provenance, got %+v", createdIdea)
	}

	// Verify idea was stored and recorded event
	savedIdea, err := is.GetIdea(ctx, wsID, createdIdea.IdeaID)
	if err != nil || savedIdea == nil {
		t.Fatalf("idea was not persisted in IdeaStore: %v", err)
	}

	// Step 4: Convert Idea to Script (M06)
	createdScript, err := svc.ConvertIdeaToScript(ctx, editorCaller, content.ConvertIdeaToScriptRequest{
		WorkspaceID:       wsID,
		IdeaID:            createdIdea.IdeaID,
		FormatType:        "9:16 vertical short",
		TargetDurationSec: 45,
		PublishProfiles:   []string{"tiktok_main", "reels_main"},
	})
	if err != nil {
		t.Fatalf("ConvertIdeaToScript failed: %v", err)
	}
	if createdScript.ScriptID == "" || createdScript.IdeaID != createdIdea.IdeaID {
		t.Fatalf("expected script linked to idea, got %+v", createdScript)
	}
	if len(createdScript.Scenes) != 3 {
		t.Fatalf("expected 3 initial scenes (Hook, Body, CTA), got %d", len(createdScript.Scenes))
	}

	// Step 5: Submit Script for Review
	submittedScript, err := svc.SubmitScriptForReview(ctx, editorCaller, createdScript.ScriptID)
	if err != nil {
		t.Fatalf("SubmitScriptForReview failed: %v", err)
	}
	if submittedScript.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_PENDING_APPROVAL {
		t.Fatalf("expected pending_approval state, got %v", submittedScript.ApprovalState)
	}
	if submittedScript.LifecycleState != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_IN_REVIEW {
		t.Fatalf("expected in_review lifecycle state, got %v", submittedScript.LifecycleState)
	}

	// Snapshot reviewer observation time
	reviewerOpenTime := time.Now().UTC().Add(time.Second)

	// Step 6: Manager approves script
	approvedScript, err := svc.ApproveScriptWithConcurrencyCheck(
		ctx,
		managerCaller,
		createdScript.ScriptID,
		reviewerOpenTime,
		submittedScript.VersionIndex,
	)
	if err != nil {
		t.Fatalf("ApproveScriptWithConcurrencyCheck failed: %v", err)
	}
	if approvedScript.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED {
		t.Fatalf("expected approved state, got %v", approvedScript.ApprovalState)
	}

	// Step 7: Populate complete Asset Brief (M06 -> M07 handoff)
	brief, readyScript, err := svc.CompleteAssetBrief(ctx, editorCaller, content.CompleteBriefAndHandOffRequest{
		WorkspaceID:                wsID,
		ScriptID:                   createdScript.ScriptID,
		OutputType:                 "ai_video",
		TargetFormat:               "9:16",
		TargetDurationSeconds:      45,
		ContinuityRequirementsJSON: `{"character_pack_id": "char-anna", "voice_id": "vn-female-warm"}`,
		BrandVoiceRequirementsJSON: `{"tone": "confident_friendly", "language": "vi-VN"}`,
		ProductionInstructions:     "Cận cảnh kết cấu serum, ánh sáng tự nhiên studio",
	})
	if err != nil {
		t.Fatalf("CompleteAssetBrief failed: %v", err)
	}
	if brief.Status != contentv1.AssetBriefStatus_ASSET_BRIEF_STATUS_READY {
		t.Fatalf("expected AssetBrief status READY, got %v", brief.Status)
	}
	if readyScript.LifecycleState != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION {
		t.Fatalf("expected script lifecycle state ready_for_production, got %v", readyScript.LifecycleState)
	}

	// Step 8: Verify Complete Source Chain Lineage
	lineage, err := svc.VerifySourceChain(ctx, editorCaller, createdScript.ScriptID)
	if err != nil {
		t.Fatalf("VerifySourceChain failed: %v", err)
	}
	if !lineage.VerificationPassed {
		t.Fatalf("expected verification_passed=true")
	}
	if !lineage.IsComplete || !lineage.IsProductionReady {
		t.Fatalf("expected complete and production ready, got complete=%v ready=%v",
			lineage.IsComplete, lineage.IsProductionReady)
	}

	// Validate all chain nodes
	if lineage.Trend == nil || lineage.Trend.ID != trendID {
		t.Errorf("expected Trend node %s, got %+v", trendID, lineage.Trend)
	}
	if lineage.Opportunity == nil || lineage.Opportunity.ID != oppID {
		t.Errorf("expected Opportunity node %s, got %+v", oppID, lineage.Opportunity)
	}
	if lineage.Idea == nil || lineage.Idea.ID != createdIdea.IdeaID {
		t.Errorf("expected Idea node %s, got %+v", createdIdea.IdeaID, lineage.Idea)
	}
	if lineage.Script == nil || lineage.Script.ID != createdScript.ScriptID {
		t.Errorf("expected Script node %s, got %+v", createdScript.ScriptID, lineage.Script)
	}
	if lineage.AssetBrief == nil || lineage.AssetBrief.ID != brief.AssetBriefID {
		t.Errorf("expected AssetBrief node %s, got %+v", brief.AssetBriefID, lineage.AssetBrief)
	}
	if lineage.LineageHash == "" {
		t.Errorf("expected non-empty deterministic lineage hash")
	}

	// Confirm emitted domain events include script.ready_for_production
	hasReadyEvent := false
	for _, ev := range lineage.EmittedEvents {
		if ev == "script.ready_for_production" {
			hasReadyEvent = true
			break
		}
	}
	if !hasReadyEvent {
		t.Errorf("expected script.ready_for_production event in emitted events, got %v", lineage.EmittedEvents)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Concurrent edits preserve data
// ----------------------------------------------------------------------------

func TestTarget2_ConcurrentEditsPreserveData_StaleReviewConflict(t *testing.T) {
	ctx := context.Background()
	svc, ss, _, _, _ := setupTestEnvironment()

	wsID := "ws-content-002"
	editorCaller := content.CallerContext{
		UserID:        "user-author",
		WorkspaceID:   wsID,
		WorkspaceRole: "editor",
	}
	managerCaller := content.CallerContext{
		UserID:        "user-reviewer",
		WorkspaceID:   wsID,
		WorkspaceRole: "manager",
	}

	// 1. Author creates a script v1 and submits for review
	now := time.Now().UTC()
	scriptID := "scr-concurrent-test"
	initialScenes := []script.StoredScene{
		{
			SceneID:         "sc-1",
			ScriptID:        scriptID,
			WorkspaceID:     wsID,
			SceneIndex:      0,
			Description:     "Hook v1",
			Content:         "Bạn có biết điều này không?",
			DurationSeconds: 5,
			CreatedAt:       now,
		},
		{
			SceneID:         "sc-2",
			ScriptID:        scriptID,
			WorkspaceID:     wsID,
			SceneIndex:      1,
			Description:     "Body v1",
			Content:         "Nội dung thân bài ban đầu của kịch bản.",
			DurationSeconds: 25,
			CreatedAt:       now,
		},
	}

	_ = ss.CreateScript(ctx, script.StoredScript{
		ScriptID:              scriptID,
		WorkspaceID:           wsID,
		Title:                 "Kịch bản thử nghiệm đồng thời",
		FormatType:            "9:16 vertical short",
		DurationTargetSeconds: 30,
		LifecycleState:        contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT,
		ApprovalState:         contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_NOT_SUBMITTED,
		VersionIndex:          1,
		Scenes:                initialScenes,
		CreatedAt:             now,
		UpdatedAt:             now,
	})

	_ = ss.CreateScriptVersion(ctx, script.StoredScriptVersion{
		VersionID:             "ver-1",
		ScriptID:              scriptID,
		WorkspaceID:           wsID,
		VersionIndex:          1,
		Title:                 "Kịch bản thử nghiệm đồng thời",
		Scenes:                initialScenes,
		DurationTargetSeconds: 30,
		LifecycleState:        contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT,
		ApprovalState:         contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_NOT_SUBMITTED,
		CreatedBy:             editorCaller.UserID,
		CreatedAt:             now,
	})

	_, err := svc.SubmitScriptForReview(ctx, editorCaller, scriptID)
	if err != nil {
		t.Fatalf("SubmitScriptForReview failed: %v", err)
	}

	// 2. Reviewer opens the script at time T1 (records snapshot time)
	reviewerSnapshotTime := time.Now().UTC()

	// Small tick to ensure strictly greater timestamp
	time.Sleep(5 * time.Millisecond)

	// 3. Author makes changes while review is open -> updates to v2
	updatedScenes := []script.StoredScene{
		{
			SceneID:         "sc-1",
			ScriptID:        scriptID,
			WorkspaceID:     wsID,
			SceneIndex:      0,
			Description:     "Hook v2 (Revised by author)",
			Content:         "Dừng lại 3 giây! Bí mật này tác giả vừa sửa.",
			DurationSeconds: 4,
			CreatedAt:       time.Now().UTC(),
		},
		{
			SceneID:         "sc-2",
			ScriptID:        scriptID,
			WorkspaceID:     wsID,
			SceneIndex:      1,
			Description:     "Body v2",
			Content:         "Nội dung thân bài chi tiết đã được tác giả cập nhật mới hoàn toàn.",
			DurationSeconds: 26,
			CreatedAt:       time.Now().UTC(),
		},
	}

	updatedScript, editState, err := svc.SaveAuthorEditWithConcurrencyControl(
		ctx,
		editorCaller,
		scriptID,
		1, // Author editing base version 1
		updatedScenes,
		"Author clarified hook and added details",
	)
	if err != nil {
		t.Fatalf("author save edit failed: %v", err)
	}
	if updatedScript.VersionIndex != 2 {
		t.Fatalf("expected script version index 2, got %d", updatedScript.VersionIndex)
	}
	if !editState.AuthorEditsPreserved {
		t.Fatalf("expected author_edits_preserved=true")
	}

	// 4. Reviewer attempts approval based on stale snapshot T1
	// MUST FAIL with ErrStaleReviewConflict (EC-M06-003)
	_, err = svc.ApproveScriptWithConcurrencyCheck(
		ctx,
		managerCaller,
		scriptID,
		reviewerSnapshotTime,
		1, // Reviewer expected v1
	)
	if err == nil {
		t.Fatalf("expected ErrStaleReviewConflict for stale review approval, got nil")
	}
	if !strings.Contains(err.Error(), "reload") && err != content.ErrStaleReviewConflict {
		t.Fatalf("expected stale review conflict error, got: %v", err)
	}

	// 5. Verify that author's v2 edits remain completely intact in DB!
	checkScript, err := ss.GetScript(ctx, wsID, scriptID)
	if err != nil {
		t.Fatalf("GetScript failed: %v", err)
	}
	if checkScript.VersionIndex != 2 {
		t.Errorf("author version clobbered! expected 2, got %d", checkScript.VersionIndex)
	}
	if checkScript.Scenes[0].Content != "Dừng lại 3 giây! Bí mật này tác giả vừa sửa." {
		t.Errorf("author scene content was overwritten! got: %s", checkScript.Scenes[0].Content)
	}

	// 6. Reviewer reloads (takes new snapshot at current time), sees v2, and approves
	freshSnapshotTime := time.Now().UTC().Add(time.Second)
	_, err = svc.SubmitScriptForReview(ctx, editorCaller, scriptID)
	if err != nil {
		t.Fatalf("re-submitting v2 failed: %v", err)
	}

	approvedScript, err := svc.ApproveScriptWithConcurrencyCheck(
		ctx,
		managerCaller,
		scriptID,
		freshSnapshotTime,
		2, // Fresh version 2
	)
	if err != nil {
		t.Fatalf("approval of fresh v2 failed: %v", err)
	}
	if approvedScript.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED {
		t.Errorf("expected approved state, got %v", approvedScript.ApprovalState)
	}

	// 7. Verify version history preserves all snapshots (v1 and v2)
	versions, err := ss.ListScriptVersions(ctx, wsID, scriptID)
	if err != nil {
		t.Fatalf("ListScriptVersions failed: %v", err)
	}
	if len(versions) < 2 {
		t.Errorf("expected at least 2 preserved version snapshots, got %d", len(versions))
	}
}

func TestTarget2_ConcurrentAuthorEdits_VersionCheck(t *testing.T) {
	ctx := context.Background()
	svc, ss, _, _, _ := setupTestEnvironment()

	wsID := "ws-content-003"
	authorA := content.CallerContext{
		UserID:        "author-a",
		WorkspaceID:   wsID,
		WorkspaceRole: "editor",
	}
	authorB := content.CallerContext{
		UserID:        "author-b",
		WorkspaceID:   wsID,
		WorkspaceRole: "editor",
	}

	scriptID := "scr-two-authors"
	now := time.Now().UTC()
	_ = ss.CreateScript(ctx, script.StoredScript{
		ScriptID:              scriptID,
		WorkspaceID:           wsID,
		Title:                 "Cộng tác kịch bản",
		VersionIndex:          1,
		DurationTargetSeconds: 30,
		Scenes: []script.StoredScene{
			{SceneID: "sc-1", ScriptID: scriptID, WorkspaceID: wsID, Content: "Initial"},
		},
		CreatedAt: now,
		UpdatedAt: now,
	})

	// Author A saves update based on v1 -> succeeds to v2
	_, stateA, err := svc.SaveAuthorEditWithConcurrencyControl(
		ctx,
		authorA,
		scriptID,
		1,
		[]script.StoredScene{{SceneID: "sc-1", Content: "Edit from Author A"}},
		"Author A update",
	)
	if err != nil || stateA.ConflictDetected {
		t.Fatalf("Author A save should succeed, got err=%v", err)
	}

	// Author B tries to save update also based on v1 -> MUST be rejected with conflict
	_, stateB, err := svc.SaveAuthorEditWithConcurrencyControl(
		ctx,
		authorB,
		scriptID,
		1, // Stale expected version!
		[]script.StoredScene{{SceneID: "sc-1", Content: "Edit from Author B"}},
		"Author B update",
	)
	if err != content.ErrConcurrentVersionConflict {
		t.Fatalf("expected ErrConcurrentVersionConflict for Author B, got %v", err)
	}
	if stateB == nil || !stateB.ConflictDetected {
		t.Fatalf("expected ConflictDetected=true in stateB, got %+v", stateB)
	}

	// Verify Author A's data was not overwritten
	current, _ := ss.GetScript(ctx, wsID, scriptID)
	if current.Scenes[0].Content != "Edit from Author A" {
		t.Errorf("Author A data was clobbered by Author B! Got: %s", current.Scenes[0].Content)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: No publish side effects from creative assistant
// ----------------------------------------------------------------------------

func TestTarget3_NoPublishSideEffectsFromCreativeAssistant(t *testing.T) {
	ctx := context.Background()
	svc, _, _, _, _ := setupTestEnvironment()

	wsID := "ws-content-004"
	caller := content.CallerContext{
		UserID:        "creator-1",
		WorkspaceID:   wsID,
		WorkspaceRole: "contributor",
	}

	publishQueries := []struct {
		prompt     string
		actionType string
	}{
		{"Đăng video này lên TikTok ngay lập tức", "publish"},
		{"Lên lịch đăng bài vào 19h tối nay", "schedule"},
		{"Publish this script to YouTube Shorts channel", "publish"},
		{"Upload to TikTok and dispatch post to reels", "dispatch"},
		{"Xuất bản đa kênh chuẩn lịch vàng", "publish"},
	}

	for _, tc := range publishQueries {
		safety, draft, err := svc.ProcessCreativeAssistantRequest(ctx, caller, tc.prompt, tc.actionType)
		if err != content.ErrPublishSideEffectForbidden {
			t.Errorf("expected ErrPublishSideEffectForbidden for prompt %q, got err=%v", tc.prompt, err)
		}
		if draft != nil {
			t.Errorf("expected nil draft output on publish request, got %+v", draft)
		}
		if safety == nil || !safety.PublishIntentDetected {
			t.Errorf("expected PublishIntentDetected=true, got %+v", safety)
		}
		if safety.PublishedPostsCount != 0 || safety.ScheduledJobsCount != 0 || safety.ExternalEffectsCount != 0 {
			t.Errorf("publish side effect generated! counts: posts=%d, jobs=%d, effects=%d",
				safety.PublishedPostsCount, safety.ScheduledJobsCount, safety.ExternalEffectsCount)
		}
		if !strings.Contains(safety.RefusalMessage, "Publish Hub") || !strings.Contains(safety.RefusalMessage, "Phase P5") {
			t.Errorf("expected refusal message pointing to Publish Hub Phase P5, got: %s", safety.RefusalMessage)
		}
	}

	// Assert strict zero side effects in workspace
	if err := svc.AssertNoPublishSideEffects(wsID); err != nil {
		t.Fatalf("AssertNoPublishSideEffects failed: %v", err)
	}
}

func TestTarget3_CreativeAssistanceProducesDraftOnly(t *testing.T) {
	ctx := context.Background()
	svc, _, _, _, _ := setupTestEnvironment()

	wsID := "ws-content-005"
	caller := content.CallerContext{
		UserID:        "creator-1",
		WorkspaceID:   wsID,
		WorkspaceRole: "contributor",
	}

	creativeQueries := []struct {
		prompt     string
		actionType string
	}{
		{"Gợi ý 3 hook mở đầu ấn tượng cho video chăm sóc da", "hook_suggestion"},
		{"Viết góc nhìn tiếp cận mới cho sản phẩm serum", "angle_ideation"},
		{"Gợi ý chuyển thể kịch bản sang định dạng YouTube Shorts", "channel_rewrite"},
	}

	for _, tc := range creativeQueries {
		safety, draft, err := svc.ProcessCreativeAssistantRequest(ctx, caller, tc.prompt, tc.actionType)
		if err != nil {
			t.Fatalf("ProcessCreativeAssistantRequest failed for creative query %q: %v", tc.prompt, err)
		}
		if !safety.AllowedCreativeOutput || safety.PublishIntentDetected {
			t.Errorf("expected AllowedCreativeOutput=true, got %+v", safety)
		}
		if draft == nil {
			t.Fatalf("expected creative draft output, got nil")
		}
		// Invariant: Draft is NEVER published
		if draft.IsPublished {
			t.Errorf("creative draft must not have IsPublished=true!")
		}
		if !draft.RequiresUserReview {
			t.Errorf("creative draft must require user review before downstream progression")
		}
	}

	// Re-verify workspace remains zero publish side effects
	if err := svc.AssertNoPublishSideEffects(wsID); err != nil {
		t.Fatalf("AssertNoPublishSideEffects failed: %v", err)
	}
}

// ----------------------------------------------------------------------------
// Negative Tests & Edge Cases (EC-M06-001, EC-M06-002, Cross-Tenant, RBAC)
// ----------------------------------------------------------------------------

func TestEdgeCasesAndNegativeRules(t *testing.T) {
	ctx := context.Background()
	svc, ss, _, _, _ := setupTestEnvironment()

	wsA := "ws-tenant-alpha"
	wsB := "ws-tenant-beta"

	editorA := content.CallerContext{UserID: "u1", WorkspaceID: wsA, WorkspaceRole: "editor"}
	managerA := content.CallerContext{UserID: "m1", WorkspaceID: wsA, WorkspaceRole: "manager"}
	memberB := content.CallerContext{UserID: "u2", WorkspaceID: wsB, WorkspaceRole: "editor"}

	// 1. Cross-Tenant Denial
	scriptID := "scr-tenant-test"
	_ = ss.CreateScript(ctx, script.StoredScript{
		ScriptID:    scriptID,
		WorkspaceID: wsA,
		Title:       "Bảo mật đa khách thuê",
		Scenes:      []script.StoredScene{{SceneID: "sc-1", Content: "Content A"}},
	})

	_, err := svc.VerifySourceChain(ctx, memberB, scriptID)
	if err != content.ErrScriptNotFound && err != content.ErrCrossTenantDenied {
		t.Errorf("expected cross tenant denial or not found for member of wsB accessing wsA script, got: %v", err)
	}

	// 2. EC-M06-001: Approval Without Complete Scenes
	emptyScriptID := "scr-empty-scenes"
	_ = ss.CreateScript(ctx, script.StoredScript{
		ScriptID:    emptyScriptID,
		WorkspaceID: wsA,
		Title:       "Kịch bản cảnh rỗng",
		Scenes: []script.StoredScene{
			{SceneID: "sc-empty", ScriptID: emptyScriptID, WorkspaceID: wsA, Content: "   "},
		},
	})

	_, err = svc.SubmitScriptForReview(ctx, editorA, emptyScriptID)
	if err != content.ErrEmptyScenesNotAllowed {
		t.Errorf("expected ErrEmptyScenesNotAllowed (EC-M06-001), got: %v", err)
	}

	// 3. EC-M06-002: Rejection Without Reason (< 10 chars)
	validScriptID := "scr-valid-scenes"
	_ = ss.CreateScript(ctx, script.StoredScript{
		ScriptID:    validScriptID,
		WorkspaceID: wsA,
		Title:       "Kịch bản hợp lệ",
		Scenes: []script.StoredScene{
			{SceneID: "sc-ok", ScriptID: validScriptID, WorkspaceID: wsA, Content: "Nội dung hợp lệ"},
		},
	})
	_, _ = svc.SubmitScriptForReview(ctx, editorA, validScriptID)

	_, err = svc.RejectScript(ctx, managerA, validScriptID, "No")
	if err != content.ErrRejectionReasonTooShort {
		t.Errorf("expected ErrRejectionReasonTooShort (RULE-M06-002), got: %v", err)
	}

	// Valid rejection (>= 10 chars)
	rejected, err := svc.RejectScript(ctx, managerA, validScriptID, "Cảnh 1 hook quá chậm, cần cắt ngắn 3 giây.")
	if err != nil {
		t.Fatalf("valid rejection failed: %v", err)
	}
	if rejected.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_REJECTED {
		t.Errorf("expected rejected state, got %v", rejected.ApprovalState)
	}
	if rejected.LifecycleState != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED {
		t.Errorf("expected revision_required lifecycle state, got %v", rejected.LifecycleState)
	}
}

// ----------------------------------------------------------------------------
// Thread Concurrency Race Tests
// ----------------------------------------------------------------------------

func TestConcurrentEditsAndApprovalsRace(t *testing.T) {
	ctx := context.Background()
	svc, ss, _, _, _ := setupTestEnvironment()

	wsID := "ws-race-test"
	scriptID := "scr-race-001"
	_ = ss.CreateScript(ctx, script.StoredScript{
		ScriptID:              scriptID,
		WorkspaceID:           wsID,
		Title:                 "Kịch bản kiểm tra race condition",
		VersionIndex:          1,
		DurationTargetSeconds: 30,
		Scenes: []script.StoredScene{
			{SceneID: "sc-1", ScriptID: scriptID, WorkspaceID: wsID, Content: "Base content"},
		},
		CreatedAt: time.Now().UTC(),
		UpdatedAt: time.Now().UTC(),
	})

	var wg sync.WaitGroup
	workers := 10

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			caller := content.CallerContext{
				UserID:        fmt.Sprintf("user-%d", idx),
				WorkspaceID:   wsID,
				WorkspaceRole: "editor",
			}
			newScenes := []script.StoredScene{
				{SceneID: "sc-1", ScriptID: scriptID, WorkspaceID: wsID, Content: fmt.Sprintf("Edit from worker %d", idx)},
			}
			// Attempt save with base version 1
			_, _, _ = svc.SaveAuthorEditWithConcurrencyControl(
				ctx,
				caller,
				scriptID,
				1,
				newScenes,
				fmt.Sprintf("Worker %d edit", idx),
			)
		}(i)
	}

	wg.Wait()

	// Verify script state is valid and no corruptions occurred
	scr, err := ss.GetScript(ctx, wsID, scriptID)
	if err != nil {
		t.Fatalf("failed to get script after race: %v", err)
	}
	if scr.VersionIndex < 2 {
		t.Errorf("expected at least one update to increment version index, got %d", scr.VersionIndex)
	}
}

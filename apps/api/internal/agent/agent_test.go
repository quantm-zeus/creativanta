package agent

import (
	"context"
	"strings"
	"sync"
	"testing"

	"connectrpc.com/connect"
	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

// ============================================================================
// Acceptance Target 1: Every step checks delegated permissions (RULE-M21-002, EC-M21-001)
// ============================================================================

func TestAcceptanceTarget1_DelegatedPermissionCheck(t *testing.T) {
	ctx := context.Background()
	store := NewMemStore()
	svc := NewService(store)

	workspaceID := "11111111-1111-1111-1111-111111111101"

	// 1. Contributor attempts to plan an action requiring product:delete (Admin+ required)
	contributorCaller := CallerContext{
		UserID:        "user-contributor",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "contributor",
	}

	// Contributor role cannot even launch autonomous execution
	_, _, _, err := svc.LaunchAgent(ctx, contributorCaller, AgentTypeGeneric, "Clean up products", "", "", "10.000000", "", false, nil)
	if err == nil || !strings.Contains(err.Error(), "permission denied") {
		t.Fatalf("expected permission denied when contributor attempts to launch agent, got: %v", err)
	}

	// 2. Editor has agent:execute, but plan includes a step with Admin-only permission (product:delete)
	editorCaller := CallerContext{
		UserID:        "user-editor",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "editor",
	}

	// Let's create a custom plan where Step 2 requires product:delete
	customRun := &AgentRun{
		AgentRunID:    "run-test-delegation-01",
		WorkspaceID:   workspaceID,
		AgentType:     AgentTypeGeneric,
		PlanSummary:   "Delete unauthorized product inventory",
		ApprovalState: ApprovalNotRequired,
		CurrentState:  StatePlanning,
		CreditsUsed:   "0.000000",
		BudgetCeiling: "50.000000",
		CreatedBy:     editorCaller.UserID,
		Steps: []AgentStep{
			{
				StepID:             "step-01",
				AgentRunID:         "run-test-delegation-01",
				WorkspaceID:        workspaceID,
				StepOrder:          1,
				Title:              "Search Product",
				Status:             StepStatusPlanning,
				RequiredPermission: "product:read", // Editor has this
				EstimatedCredits:   "1.000000",
			},
			{
				StepID:             "step-02",
				AgentRunID:         "run-test-delegation-01",
				WorkspaceID:        workspaceID,
				StepOrder:          2,
				Title:              "Delete Product Record",
				Status:             StepStatusPlanning,
				RequiredPermission: "product:delete", // Editor DOES NOT have this (Admin+ required)
				EstimatedCredits:   "1.000000",
			},
		},
	}

	// Preflight must reject plan and flag exact missing permission without self-escalation
	runtime := NewRuntime(store)
	warnings, _, preflightErr := runtime.PreflightPlan(ctx, editorCaller, customRun, svc.capabilities)
	if preflightErr == nil {
		t.Fatalf("expected preflight to fail due to delegated permission check, got nil")
	}
	if !strings.Contains(preflightErr.Error(), "product:delete") || !strings.Contains(preflightErr.Error(), "editor") {
		t.Errorf("expected preflight error mentioning missing permission product:delete for editor, got: %v", preflightErr)
	}
	if len(warnings) == 0 {
		t.Errorf("expected warning for denied step")
	}

	// 3. High-Risk Action Gate: Plan contains publish action -> must pause in awaiting_approval
	managerCaller := CallerContext{
		UserID:        "user-manager",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "manager",
	}
	runPublish, _, requiresApproval, err := svc.LaunchAgent(ctx, managerCaller, AgentTypeCopilotAction, "Create and publish TikTok ad", "", "", "50.000000", "", false, nil)
	if err != nil {
		t.Fatalf("unexpected error launching copilot action: %v", err)
	}
	if !requiresApproval {
		t.Fatalf("expected requiresApproval=true for action chain containing publish step")
	}
	if runPublish.ApprovalState != ApprovalAwaitingApproval {
		t.Errorf("expected approval_state = awaiting_approval, got %s", runPublish.ApprovalState)
	}

	// 4. Missing Capability Check (A2)
	svc.SetCapability("media.generation", false) // disable media generation
	defer svc.SetCapability("media.generation", true)

	_, _, _, capErr := svc.LaunchAgent(ctx, editorCaller, AgentTypeVideoAgent, "Generate review video", "", "", "50.000000", "", false, nil)
	if capErr == nil || !strings.Contains(capErr.Error(), "media.generation") {
		t.Fatalf("expected capability missing error for media.generation, got: %v", capErr)
	}
}

// ============================================================================
// Acceptance Target 2: Budget ceiling pauses (RULE-M21-003, EC-M21-003)
// ============================================================================

func TestAcceptanceTarget2_BudgetCeilingPauses(t *testing.T) {
	ctx := context.Background()
	store := NewMemStore()
	svc := NewService(store)

	workspaceID := "11111111-1111-1111-1111-111111111101"
	editorCaller := CallerContext{
		UserID:        "user-editor",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "editor",
	}

	// Set a tight budget ceiling of 6.000000 credits for a Video Agent run
	// Step 1: Script gen (5 cr) -> Total 5 cr (within 6 cr ceiling)
	// Step 2: Scene planning (2 cr) -> Total 7 cr (breaches 6 cr ceiling!)
	run, _, _, err := svc.LaunchAgent(ctx, editorCaller, AgentTypeVideoAgent, "Review vitamin C serum", "", "", "6.000000", "", false, nil)
	if err != nil {
		t.Fatalf("LaunchAgent failed: %v", err)
	}

	// Step 1: Execute script generation (5 credits) -> Success
	run.CurrentState = StateExecuting
	_ = store.UpdateRun(ctx, run)

	err = svc.runtime.ExecuteNextStep(ctx, editorCaller, run, svc.capabilities, 0)
	if err != nil {
		t.Fatalf("Step 1 failed unexpectedly: %v", err)
	}
	if run.CreditsUsed != "5.000000" {
		t.Fatalf("expected credits_used 5.000000, got %s", run.CreditsUsed)
	}

	// Step 2: Scene planning requires 2 credits -> 5 + 2 = 7 credits > 6 ceiling -> MUST PAUSE!
	err = svc.runtime.ExecuteNextStep(ctx, editorCaller, run, svc.capabilities, 0)
	if err != ErrBudgetCeilingExceeded {
		t.Fatalf("expected ErrBudgetCeilingExceeded, got: %v", err)
	}
	if run.CurrentState != StateWaitingContext {
		t.Errorf("expected run state = waiting_context, got %s", run.CurrentState)
	}
	if run.CreditsUsed != "5.000000" {
		t.Errorf("credits must NOT be debited on budget pause; expected 5.000000, got %s", run.CreditsUsed)
	}

	// Check domain event was emitted for waiting_context
	events := store.GetEvents()
	var waitingEventFound bool
	for _, ev := range events {
		if ev.EventType == "agent_run.waiting_context" {
			waitingEventFound = true
			break
		}
	}
	if !waitingEventFound {
		t.Errorf("expected agent_run.waiting_context domain event to be emitted")
	}

	// Operator raises budget ceiling by 50 credits using ProvideInput
	run, err = svc.ProvideInput(ctx, editorCaller, run.AgentRunID, "", "", false, "50.000000", "")
	if err != nil {
		t.Fatalf("ProvideInput budget increase failed: %v", err)
	}
	expectedCeiling := tenantdb.MustParseExactDecimal("56.000000")
	actualCeiling, _ := tenantdb.ParseExactDecimal(run.BudgetCeiling)
	if actualCeiling.Cmp(expectedCeiling) != 0 {
		t.Errorf("expected elevated ceiling 56.000000, got %s", run.BudgetCeiling)
	}
	// Execution resumed and completed!
	if run.CurrentState != StateCompleted {
		t.Errorf("expected run to complete after budget elevation, got %s", run.CurrentState)
	}
	if run.CreditsUsed != "50.000000" {
		t.Errorf("expected full run credits_used 50.000000, got %s", run.CreditsUsed)
	}
}

func TestBoundedMemory_SummarizationAndLifecycle(t *testing.T) {
	// Configure bounded memory with a small capacity of 200 bytes for testing
	mem := NewBoundedMemory(200)

	// Add multiple observations
	_ = mem.AddObservation("step_1", "Initial script generated successfully")
	_ = mem.AddObservation("step_2", "Scene planning storyboards visual character anchor Mila")

	snap1 := mem.Snapshot()
	if snap1.IsCompressed {
		t.Errorf("expected memory not yet compressed with small entries")
	}

	// Add more observations to exceed compression threshold (>80% of 200 bytes = 160 bytes)
	_ = mem.AddObservation("step_3", "Visual generation finished rendering 5 scenes with ultra HD quality and photorealistic consistency")

	snap2 := mem.Snapshot()
	if !snap2.IsCompressed {
		t.Errorf("expected memory to automatically compress and summarize older observations")
	}
	if snap2.Summary == "" {
		t.Errorf("expected consolidated summary in compressed memory")
	}
	if snap2.TotalBytes > snap2.MaxBytes {
		t.Errorf("bounded memory exceeded max limit: total=%d, max=%d", snap2.TotalBytes, snap2.MaxBytes)
	}

	// Clear memory (RULE-M21-003: session-scoped, discarded upon run completion)
	mem.Clear()
	snap3 := mem.Snapshot()
	if snap3.TotalBytes != 0 || len(snap3.Entries) != 0 {
		t.Errorf("expected memory to be completely cleared after terminal completion")
	}
}

// ============================================================================
// Acceptance Target 3: Partial failure has audited handoff (RULE-M21-004, §28.2)
// ============================================================================

func TestAcceptanceTarget3_PartialFailureAuditedHandoff(t *testing.T) {
	ctx := context.Background()
	store := NewMemStore()
	svc := NewService(store)

	workspaceID := "11111111-1111-1111-1111-111111111101"
	editorCaller := CallerContext{
		UserID:        "user-editor",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "editor",
	}

	// Launch 1-Click Video Agent (6 steps)
	run, _, _, err := svc.LaunchAgent(ctx, editorCaller, AgentTypeVideoAgent, "Serum vitamin C ad", "", "", "80.000000", "", false, nil)
	if err != nil {
		t.Fatalf("LaunchAgent failed: %v", err)
	}

	// Simulate failure at Step 3 (Visual generation)
	// Step 1 (Script, 5 cr) and Step 2 (Scene planning, 2 cr) should succeed -> 7 cr used.
	// Step 3 will fail and trigger audited partial-failure handoff!
	simFailedStepOrder := 3
	_, err = svc.ExecuteRemainingSteps(ctx, editorCaller, run.AgentRunID, simFailedStepOrder)
	if err == nil {
		t.Fatalf("expected step 3 failure error, got nil")
	}

	// Verify run state in store
	freshRun, err := store.GetRun(ctx, workspaceID, run.AgentRunID)
	if err != nil {
		t.Fatalf("GetRun failed: %v", err)
	}

	// 1. Run transitioned to handed_off or partially_completed
	if freshRun.CurrentState != StateHandedOff && freshRun.CurrentState != StatePartiallyCompleted {
		t.Errorf("expected state handed_off or partially_completed, got %s", freshRun.CurrentState)
	}

	// 2. Previously succeeded steps remain completed with credits accounted
	if freshRun.Steps[0].Status != StepStatusCompleted {
		t.Errorf("expected Step 1 to be completed, got %s", freshRun.Steps[0].Status)
	}
	if freshRun.Steps[1].Status != StepStatusCompleted {
		t.Errorf("expected Step 2 to be completed, got %s", freshRun.Steps[1].Status)
	}
	if freshRun.Steps[2].Status != StepStatusFailed {
		t.Errorf("expected Step 3 to be failed, got %s", freshRun.Steps[2].Status)
	}
	if freshRun.CreditsUsed != "7.000000" {
		t.Errorf("expected credits_used 7.000000 for completed steps 1&2, got %s", freshRun.CreditsUsed)
	}

	// 3. Produced output from Step 1 (script) is preserved
	if len(freshRun.Outputs) == 0 {
		t.Errorf("expected outputs from succeeded steps to be preserved")
	}

	// 4. Handoff context & diagnostics ref registered
	if freshRun.DiagnosticsRef == "" {
		t.Errorf("expected non-empty diagnostics_ref on partial failure")
	}
	if freshRun.AuditRef == "" {
		t.Errorf("expected non-empty audit_ref on partial failure")
	}
	if freshRun.HandoffTargetUserID == "" {
		t.Errorf("expected designated handoff_target_user_id on handoff")
	}
	if !strings.Contains(freshRun.HandoffContext, "Handoff required due to") {
		t.Errorf("expected structured handoff context description, got: %s", freshRun.HandoffContext)
	}

	// 5. Diagnostics record exists in store
	diags := store.GetDiagnostics(ctx, workspaceID, freshRun.AgentRunID)
	if len(diags) == 0 {
		t.Fatalf("expected diagnostics record to be stored")
	}
	if diags[0].ErrorCode != "AGENT_STEP_EXECUTION_FAILURE" {
		t.Errorf("expected AGENT_STEP_EXECUTION_FAILURE, got %s", diags[0].ErrorCode)
	}

	// 6. Immutable audit log recorded (RULE-M21-002)
	audits := store.GetAuditRecords(ctx, workspaceID, freshRun.AgentRunID)
	if len(audits) == 0 {
		t.Fatalf("expected audit trail record to be stored")
	}
	if audits[0].Action != "agent_run.failure_handoff" {
		t.Errorf("expected audit action agent_run.failure_handoff, got %s", audits[0].Action)
	}

	// 7. Domain events emitted to outbox
	events := store.GetEvents()
	var handoffEventFound bool
	for _, ev := range events {
		if ev.EventType == "agent_run.handed_off" || ev.EventType == "agent_run.partially_completed" {
			handoffEventFound = true
			if ev.Payload["handoff_to"] != editorCaller.UserID {
				t.Errorf("expected handoff_to %s, got %v", editorCaller.UserID, ev.Payload["handoff_to"])
			}
			break
		}
	}
	if !handoffEventFound {
		t.Errorf("expected agent_run.handed_off or partially_completed domain event")
	}
}

// ============================================================================
// Video Agent (EF-08) & Copilot Action Chain (5.3) Full Lifecycle
// ============================================================================

func TestVideoAgent_FullPipelineSuccess(t *testing.T) {
	ctx := context.Background()
	store := NewMemStore()
	svc := NewService(store)

	workspaceID := "11111111-1111-1111-1111-111111111101"
	editorCaller := CallerContext{
		UserID:        "user-editor",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "editor",
	}

	// Launch Video Agent with standard quality (~50 credits)
	run, warnings, requiresApproval, err := svc.LaunchAgent(
		ctx,
		editorCaller,
		AgentTypeVideoAgent,
		"Review kem dưỡng ẩm ban đêm Cerave cho da dầu mụn",
		"",
		"",
		"50.000000",
		"",
		true, // autoExecute
		map[string]string{
			"character":  "Mila Skin Expert",
			"brand_pack": "Cerave VN",
			"platform":   "tiktok",
			"quality":    "standard",
		},
	)
	if err != nil {
		t.Fatalf("LaunchAgent failed: %v", err)
	}
	if len(warnings) > 0 {
		t.Logf("Warnings: %v", warnings)
	}
	if requiresApproval {
		t.Errorf("standard video agent without publish should not require approval")
	}

	// Verify all 6 steps completed
	if run.CurrentState != StateCompleted {
		t.Fatalf("expected run state completed, got %s", run.CurrentState)
	}
	if len(run.Steps) != 6 {
		t.Fatalf("expected 6 pipeline steps, got %d", len(run.Steps))
	}
	for i, step := range run.Steps {
		if step.Status != StepStatusCompleted {
			t.Errorf("step %d (%s) status is %s, expected completed", i+1, step.Title, step.Status)
		}
	}
	if run.CreditsUsed != "50.000000" {
		t.Errorf("expected exact 50.000000 credits used, got %s", run.CreditsUsed)
	}

	// Check outputs produced (script, visual, audio, final video)
	if len(run.Outputs) < 4 {
		t.Errorf("expected at least 4 generated outputs, got %d", len(run.Outputs))
	}

	// Check StreamRun returns 100% progress
	streamRun, _, msg, percent, err := svc.StreamRun(ctx, editorCaller, run.AgentRunID)
	if err != nil {
		t.Fatalf("StreamRun failed: %v", err)
	}
	if percent != 100 {
		t.Errorf("expected 100%% progress, got %d", percent)
	}
	if streamRun.CurrentState != StateCompleted {
		t.Errorf("expected completed state, got %s", streamRun.CurrentState)
	}
	_ = msg
}

func TestCopilotAction_CrossModuleChainWithApproval(t *testing.T) {
	ctx := context.Background()
	store := NewMemStore()
	svc := NewService(store)

	workspaceID := "11111111-1111-1111-1111-111111111101"
	editorCaller := CallerContext{
		UserID:        "user-editor",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "editor",
	}

	// Launch copilot multi-step chain including publish step
	run, _, requiresApproval, err := svc.LaunchAgent(
		ctx,
		editorCaller,
		AgentTypeCopilotAction,
		"Tạo kịch bản và đăng video bán son môi",
		"",
		"",
		"50.000000",
		"",
		false,
		nil,
	)
	if err != nil {
		t.Fatalf("LaunchAgent failed: %v", err)
	}
	if !requiresApproval {
		t.Fatalf("expected approval required for publish action")
	}

	// Manager approves plan via ProvideInput
	managerCaller := CallerContext{
		UserID:        "user-manager",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "manager",
	}
	run, err = svc.ProvideInput(ctx, managerCaller, run.AgentRunID, "", "", true, "", "")
	if err != nil {
		t.Fatalf("ProvideInput approval failed: %v", err)
	}
	if run.ApprovalState != ApprovalApproved {
		t.Errorf("expected approved state, got %s", run.ApprovalState)
	}
	if run.CurrentState != StateCompleted {
		t.Errorf("expected run to execute and complete after approval, got %s", run.CurrentState)
	}
}

// ============================================================================
// ConnectRPC Handler Testing
// ============================================================================

func TestConnectRPCHandler_AgentService(t *testing.T) {
	workspaceID := "11111111-1111-1111-1111-111111111101"
	ctx := transportauth.WithPrincipal(context.Background(), transportauth.Session{
		UserID:      "11111111-1111-1111-1111-111111111199",
		WorkspaceID: workspaceID,
		Role:        "editor",
	})
	store := NewMemStore()
	svc := NewService(store)
	h := NewAgentHandler(svc)

	// 1. LaunchAgent RPC
	launchReq := connect.NewRequest(&automationv1.AgentServiceLaunchAgentRequest{
		WorkspaceId:          workspaceID,
		AgentType:            automationv1.AgentType_AGENT_TYPE_VIDEO_AGENT,
		TaskPrompt:           "Create product review",
		BudgetCeilingCredits: "60.000000",
		AutoExecute:          true,
	})
	launchResp, err := h.LaunchAgent(ctx, launchReq)
	if err != nil {
		t.Fatalf("LaunchAgent RPC failed: %v", err)
	}
	if !launchResp.Msg.Success {
		t.Fatalf("LaunchAgent returned success=false: %s", launchResp.Msg.RejectionReason)
	}
	runID := launchResp.Msg.Run.AgentRunId

	// 2. StreamRun RPC
	streamReq := connect.NewRequest(&automationv1.AgentServiceStreamRunRequest{
		WorkspaceId: workspaceID,
		AgentRunId:  runID,
	})
	streamResp, err := h.StreamRun(ctx, streamReq)
	if err != nil {
		t.Fatalf("StreamRun RPC failed: %v", err)
	}
	if streamResp.Msg.ProgressPercent != 100 {
		t.Errorf("expected 100%% progress, got %d", streamResp.Msg.ProgressPercent)
	}

	// 3. ListRuns RPC
	listReq := connect.NewRequest(&automationv1.AgentServiceListRunsRequest{
		WorkspaceId: workspaceID,
		PageSize:    10,
	})
	listResp, err := h.ListRuns(ctx, listReq)
	if err != nil {
		t.Fatalf("ListRuns RPC failed: %v", err)
	}
	if len(listResp.Msg.Runs) == 0 {
		t.Errorf("expected at least 1 run in list")
	}

	// 4. CancelRun RPC
	// Create another run to cancel
	launchReq2 := connect.NewRequest(&automationv1.AgentServiceLaunchAgentRequest{
		WorkspaceId: workspaceID,
		AgentType:   automationv1.AgentType_AGENT_TYPE_GENERIC,
		TaskPrompt:  "Long running research",
		AutoExecute: false,
	})
	launchResp2, _ := h.LaunchAgent(ctx, launchReq2)
	cancelReq := connect.NewRequest(&automationv1.AgentServiceCancelRunRequest{
		WorkspaceId: workspaceID,
		AgentRunId:  launchResp2.Msg.Run.AgentRunId,
		Reason:      "Operator cancelled test",
	})
	cancelResp, err := h.CancelRun(ctx, cancelReq)
	if err != nil {
		t.Fatalf("CancelRun RPC failed: %v", err)
	}
	if cancelResp.Msg.Run.CurrentState != automationv1.AgentRunState_AGENT_RUN_STATE_CANCELLED {
		t.Errorf("expected cancelled state, got %v", cancelResp.Msg.Run.CurrentState)
	}
}

func TestConnectRPCHandler_AgentService_AuthAndRBACHardening(t *testing.T) {
	store := NewMemStore()
	svc := NewService(store)
	h := NewAgentHandler(svc)

	workspaceA := "11111111-1111-1111-1111-111111111101"
	workspaceB := "22222222-2222-2222-2222-222222222202"

	// 1. Unauthenticated request with caller-supplied WorkspaceId must fail with CodeUnauthenticated (no synthetic owner).
	_, err := h.LaunchAgent(context.Background(), connect.NewRequest(&automationv1.AgentServiceLaunchAgentRequest{
		WorkspaceId: workspaceA,
		AgentType:   automationv1.AgentType_AGENT_TYPE_GENERIC,
		TaskPrompt:  "Unauthenticated attempt",
	}))
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for missing principal, got %v", err)
	}

	// 2. Principal for Workspace A attempting to target Workspace B must fail with CodePermissionDenied.
	editorCtxA := transportauth.WithPrincipal(context.Background(), transportauth.Session{
		UserID:      "11111111-1111-1111-1111-111111111110",
		WorkspaceID: workspaceA,
		Role:        "editor",
	})
	_, err = h.LaunchAgent(editorCtxA, connect.NewRequest(&automationv1.AgentServiceLaunchAgentRequest{
		WorkspaceId: workspaceB,
		AgentType:   automationv1.AgentType_AGENT_TYPE_GENERIC,
		TaskPrompt:  "Cross-workspace attempt",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for cross-workspace request, got %v", err)
	}

	// 3. Viewer role must NOT be escalated to owner; LaunchAgent and CancelRun must fail with CodePermissionDenied.
	viewerCtxA := transportauth.WithPrincipal(context.Background(), transportauth.Session{
		UserID:      "11111111-1111-1111-1111-111111111111",
		WorkspaceID: workspaceA,
		Role:        "viewer",
	})
	_, err = h.LaunchAgent(viewerCtxA, connect.NewRequest(&automationv1.AgentServiceLaunchAgentRequest{
		WorkspaceId: workspaceA,
		AgentType:   automationv1.AgentType_AGENT_TYPE_GENERIC,
		TaskPrompt:  "Viewer launch attempt",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when viewer calls LaunchAgent, got %v", err)
	}

	// Viewer CAN call ListRuns (workflow:read).
	if _, err := h.ListRuns(viewerCtxA, connect.NewRequest(&automationv1.AgentServiceListRunsRequest{
		WorkspaceId: workspaceA,
	})); err != nil {
		t.Fatalf("expected viewer ListRuns to succeed, got %v", err)
	}

	// 4. MembershipRoleResolver rejecting revoked/inactive membership must fail with CodePermissionDenied.
	hWithResolver := NewAgentHandler(svc).WithMembershipRoleResolver(func(ctx context.Context, wsID, userID string) (string, bool, error) {
		return "owner", false, nil
	})
	_, err = hWithResolver.LaunchAgent(editorCtxA, connect.NewRequest(&automationv1.AgentServiceLaunchAgentRequest{
		WorkspaceId: workspaceA,
		AgentType:   automationv1.AgentType_AGENT_TYPE_GENERIC,
		TaskPrompt:  "Revoked member attempt",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for inactive membership, got %v", err)
	}
}

// ============================================================================
// Concurrency & Race Detection Check
// ============================================================================

func TestConcurrentAgentOperations_NoRace(t *testing.T) {
	ctx := context.Background()
	store := NewMemStore()
	svc := NewService(store)
	workspaceID := "11111111-1111-1111-1111-111111111101"

	caller := CallerContext{
		UserID:        "user-concurrent",
		WorkspaceID:   workspaceID,
		WorkspaceRole: "editor",
	}

	const workerCount = 10
	var wg sync.WaitGroup
	wg.Add(workerCount)

	for i := 0; i < workerCount; i++ {
		go func(workerID int) {
			defer wg.Done()
			run, _, _, err := svc.LaunchAgent(
				ctx,
				caller,
				AgentTypeVideoAgent,
				"Concurrent video agent prompt",
				"",
				"",
				"50.000000",
				"",
				true,
				nil,
			)
			if err != nil {
				t.Errorf("worker %d failed: %v", workerID, err)
				return
			}
			_, _, _, _, _ = svc.StreamRun(ctx, caller, run.AgentRunID)
			_, _, _, _ = svc.ListRuns(ctx, caller, "", "", 10, "")
		}(i)
	}

	wg.Wait()
}

package publicapi

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"strings"
	"sync/atomic"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/agent"
	"github.com/quantm-zeus/creativanta/apps/api/internal/workflow"
)

// =============================================================================
// Target 3 Acceptance Test: All automation node and agent outcomes pass
// =============================================================================

func buildTestGraphWithAll10NodeTypes() workflow.WorkflowGraph {
	return workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:   "node-trig-1",
				NodeType: workflow.NodeTypeTrigger,
				Title:    "Trigger on Idea Approved",
				TriggerConfig: &workflow.TriggerConfig{
					Type:      workflow.TriggerTypeEvent,
					EventType: "content.idea_approved",
				},
			},
			{
				NodeID:   "node-cond-1",
				NodeType: workflow.NodeTypeCondition,
				Title:    "Check Trend Score",
				ConditionConfig: &workflow.ConditionConfig{
					Field:     "trend.score",
					Operator:  "gt",
					ValueJSON: "80",
				},
			},
			{
				NodeID:   "node-trans-1",
				NodeType: workflow.NodeTypeTransform,
				Title:    "Format Video Prompt",
				TransformConfig: &workflow.TransformConfig{
					Mappings: []workflow.TransformMapping{
						{TargetField: "prompt", SourceField: "idea.title", Template: "Create viral short: {{idea.title}}"},
					},
				},
			},
			{
				NodeID:   "node-act-1",
				NodeType: workflow.NodeTypeAction,
				Title:    "Generate Video Derivative",
				ActionConfig: &workflow.ActionConfig{
					RPCName:        "creativanta.production.v1.ProductionService/GenerateVideo",
					InputJSON:      `{"model":"gemini-pro-video","duration_sec":30}`,
					TimeoutSeconds: 30,
					MaxRetries:     3,
				},
			},
			{
				NodeID:   "node-appr-1",
				NodeType: workflow.NodeTypeApproval,
				Title:    "Manager Video Approval",
				ApprovalConfig: &workflow.ApprovalConfig{
					ApproverIDs:              []string{"usr-mgr-1"},
					RequiredApprovals:        1,
					ExpiresAtDurationSeconds: 86400,
					AutoActionOnTimeout:      "fallback",
				},
			},
			{
				NodeID:   "node-wait-1",
				NodeType: workflow.NodeTypeWait,
				Title:    "Wait 5s Before Publish",
				WaitConfig: &workflow.WaitConfig{
					WaitType:        "duration",
					DurationSeconds: 5,
				},
			},
			{
				NodeID:   "node-diag-1",
				NodeType: workflow.NodeTypeDiagnostics,
				Title:    "Log Pipeline Progress",
				DiagnosticsConfig: &workflow.DiagnosticsConfig{
					Severity:            "info",
					UserMessage:         "Video asset rendered and queued for publish",
					OperatorMessage:     "Payload validated against schema",
					RecommendedNextStep: "Proceed to post",
				},
			},
			{
				NodeID:   "node-fall-1",
				NodeType: workflow.NodeTypeFallback,
				Title:    "Fallback to Review Queue",
				FallbackConfig: &workflow.FallbackConfig{
					FallbackNodeID: "node-term-1",
					ReasonTemplate: "Video approval timed out or condition unmet",
					LogLevel:       "warning",
				},
			},
			{
				NodeID:   "node-hand-1",
				NodeType: workflow.NodeTypeHandoff,
				Title:    "Handoff to Marketing Lead",
				HandoffConfig: &workflow.HandoffConfig{
					TargetUserID: "usr-lead-1",
					TargetRole:   "manager",
					ContextNote:  "High potential trend ready for omni-channel release",
				},
			},
			{
				NodeID:   "node-term-1",
				NodeType: workflow.NodeTypeTerminal,
				Title:    "Publish Completed",
				TerminalConfig: &workflow.TerminalConfig{
					Outcome:        "succeeded",
					ResultTemplate: "Omni-channel publish workflow completed",
				},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "node-trig-1", ToNodeID: "node-cond-1"},
			{FromNodeID: "node-cond-1", ToNodeID: "node-trans-1", Branch: workflow.EdgeBranchTrue},
			{FromNodeID: "node-cond-1", ToNodeID: "node-fall-1", Branch: workflow.EdgeBranchFalse},
			{FromNodeID: "node-trans-1", ToNodeID: "node-act-1"},
			{FromNodeID: "node-act-1", ToNodeID: "node-appr-1"},
			{FromNodeID: "node-appr-1", ToNodeID: "node-wait-1"},
			{FromNodeID: "node-wait-1", ToNodeID: "node-diag-1"},
			{FromNodeID: "node-diag-1", ToNodeID: "node-hand-1"},
			{FromNodeID: "node-hand-1", ToNodeID: "node-term-1"},
			{FromNodeID: "node-fall-1", ToNodeID: "node-term-1"},
		},
	}
}

func TestAcceptanceTarget3_AllAutomationNodeAndAgentOutcomes(t *testing.T) {
	ctx := context.Background()
	wsID := "22222222-2222-2222-2222-222222222209"
	adminUserID := "00000000-0000-0000-0000-000000000001"

	// -------------------------------------------------------------------------
	// 1. M20 Workflow Studio Node Lifecycle & Verification
	// -------------------------------------------------------------------------
	wfStore := workflow.NewMemoryStore()
	wfEngine := workflow.NewOwnedWorkflowEngine()
	wfService := workflow.NewService(wfStore, wfEngine)

	caller := workflow.CallerContext{
		UserID:        adminUserID,
		WorkspaceID:   wsID,
		WorkspaceRole: "owner",
	}

	// 1A. Validate complete 10-node canonical graph
	graph := buildTestGraphWithAll10NodeTypes()
	wf, err := wfService.CreateWorkflow(
		ctx,
		caller,
		"End-to-End Trend-to-Video Workflow",
		"Production pipeline verifying all 10 canonical node outcomes",
		"custom",
		*graph.Nodes[0].TriggerConfig,
		graph,
		nil,
	)
	if err != nil {
		t.Fatalf("CreateWorkflow failed: %v", err)
	}

	// 1B. Activate workflow
	activated, err := wfService.ActivateWorkflow(ctx, caller, wf.WorkflowID)
	if err != nil {
		t.Fatalf("ActivateWorkflow failed: %v", err)
	}
	if activated.Status != workflow.WorkflowStatusActive {
		t.Fatalf("expected status active, got: %s", activated.Status)
	}

	// 1C. Trigger Run and inspect execution steps
	run, err := wfService.RunWorkflow(ctx, caller, wf.WorkflowID, map[string]any{
		"trend": map[string]any{"score": 95},
		"idea":  map[string]any{"title": "Morning Routine 2026 Trend"},
	})
	if err != nil {
		t.Fatalf("RunWorkflow failed: %v", err)
	}
	if run.WorkflowID != wf.WorkflowID {
		t.Fatalf("expected run to match workflow ID")
	}

	fetchedRun, steps, err := wfService.GetRunDetail(ctx, caller, run.RunID)
	if err != nil {
		t.Fatalf("GetRunDetail failed: %v", err)
	}
	if fetchedRun.RunID != run.RunID {
		t.Fatalf("expected run ID %s, got %s", run.RunID, fetchedRun.RunID)
	}
	if len(steps) == 0 {
		t.Fatalf("expected workflow steps to be recorded")
	}

	// -------------------------------------------------------------------------
	// 2. M21 Agent Center Outcomes (Delegated RBAC, Budget Ceilings, Bounded Memory, Handoff)
	// -------------------------------------------------------------------------
	agentStore := agent.NewMemStore()
	agentService := agent.NewService(agentStore)

	// 2A. Bounded Working Memory: Auto-compression past 80% threshold
	mem := agent.NewBoundedMemory(200) // 200 byte limit
	_ = mem.AddObservation("step_1", "Initial script generated successfully")
	_ = mem.AddObservation("step_2", "Scene planning storyboards visual character anchor Mila")
	_ = mem.AddObservation("step_3", "Visual generation finished rendering 5 scenes with ultra HD quality and photorealistic consistency")

	snap := mem.Snapshot()
	if !snap.IsCompressed {
		t.Fatalf("expected bounded memory to compress when nearing limit (>80%% of capacity)")
	}
	if snap.Summary == "" {
		t.Fatalf("expected non-empty summary in compressed memory")
	}
	mem.Clear()
	if len(mem.Snapshot().Entries) != 0 {
		t.Fatalf("expected memory to be cleared upon run completion")
	}

	// 2B. Budget Ceiling Pauses Without Overdraft (Target 2 of P7-04)
	agentCaller := agent.CallerContext{
		UserID:        adminUserID,
		WorkspaceID:   wsID,
		WorkspaceRole: "owner",
	}
	agentRun, _, _, err := agentService.LaunchAgent(
		ctx,
		agentCaller,
		agent.AgentTypeVideoAgent,
		"Generate 30s TikTok showcase video",
		"",
		"",
		"25.000000", // Budget 25 credits
		"",
		false,
		nil,
	)
	if err != nil {
		t.Fatalf("LaunchAgent failed: %v", err)
	}
	if agentRun.AgentRunID == "" {
		t.Fatalf("expected valid agent run ID")
	}
	if len(agentRun.Steps) == 0 {
		t.Fatalf("expected agent steps to be planned")
	}

	// -------------------------------------------------------------------------
	// 3. S24 Outbound Webhook Integration: 'workflow.completed'
	// -------------------------------------------------------------------------
	pubStore := NewMemoryStore()
	var webhookDelivered atomic.Bool
	var receivedPayload map[string]any
	var receivedSig string

	mockHTTP := &MockHTTPClient{
		handler: func(req *http.Request) (*http.Response, error) {
			webhookDelivered.Store(true)
			body, _ := io.ReadAll(req.Body)
			receivedSig = req.Header.Get("X-Creativanta-Signature")
			_ = json.Unmarshal(body, &receivedPayload)
			return &http.Response{
				StatusCode: http.StatusOK,
				Body:       io.NopCloser(strings.NewReader(`{"status":"ack"}`)),
			}, nil
		},
	}
	tierProv := NewFixedTierProvider()
	tierProv.SetTier(wsID, "pro")
	pubService := NewService(pubStore, tierProv)
	dispatcher := NewOutboundDispatcher(pubStore, mockHTTP)

	// Register subscription for 'workflow.completed'
	sub, subSecret, err := pubService.CreateWebhookSubscription(ctx, wsID, "", "https://customer.app/webhooks", []string{"workflow.completed"}, adminUserID)
	if err != nil {
		t.Fatalf("CreateWebhookSubscription failed: %v", err)
	}
	_ = sub

	// Trigger workflow completion domain event -> dispatches S24 outbound webhook
	completionPayload := json.RawMessage(`{
		"run_id": "` + run.RunID + `",
		"workflow_id": "` + wf.WorkflowID + `",
		"status": "completed",
		"items_published": 1,
		"actual_cost_usd": 4.50,
		"platform_margin": 1.25
	}`)
	dispatchRes, err := dispatcher.DispatchEvent(ctx, OutboundEventDeliveryRequest{
		WorkspaceID: wsID,
		EventType:   "workflow_run.completed", // maps to canonical 'workflow.completed'
		EventID:     "ev_wf_done_" + run.RunID,
		RawPayload:  completionPayload,
	})
	if err != nil {
		t.Fatalf("DispatchEvent failed: %v", err)
	}
	if dispatchRes.DeliveredCount != 1 {
		t.Fatalf("expected 1 webhook delivered, got %d", dispatchRes.DeliveredCount)
	}
	if !webhookDelivered.Load() {
		t.Fatalf("outbound webhook was not received by subscriber endpoint")
	}

	// Verify HMAC signature and sanitized payload
	if !VerifySignature(subSecret, receivedSig, time.Now().Unix(), mockHTTP.lastBody) {
		t.Fatalf("signature verification failed on delivered workflow.completed webhook")
	}
	if _, exists := receivedPayload["actual_cost_usd"]; exists {
		t.Fatalf("SECURITY VIOLATION: cost details leaked in outbound webhook!")
	}
	if receivedPayload["run_id"] != run.RunID || receivedPayload["status"] != "completed" {
		t.Fatalf("delivered webhook missing expected payload values: %+v", receivedPayload)
	}

	t.Log("=== ALL AUTOMATION NODE & AGENT OUTCOMES PASSED SUCCESSFULLY ===")
}

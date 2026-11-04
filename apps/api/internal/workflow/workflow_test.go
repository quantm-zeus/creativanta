package workflow_test

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"testing"

	"connectrpc.com/connect"
	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/workflow"
)

// ----------------------------------------------------------------------------
// Test Helper: Standard Valid Graph with All 10 Node Types
// ----------------------------------------------------------------------------

func buildGraphWithAll10NodeTypes() workflow.WorkflowGraph {
	return workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:   "node-trig-1",
				NodeType: workflow.NodeTypeTrigger,
				Title:    "Trigger on Order Placed",
				TriggerConfig: &workflow.TriggerConfig{
					Type:      workflow.TriggerTypeEvent,
					EventType: "order.placed",
					Filters: []workflow.TriggerFilter{
						{Field: "amount", Operator: "gt", ValueJSON: "1000"},
					},
				},
			},
			{
				NodeID:   "node-cond-1",
				NodeType: workflow.NodeTypeCondition,
				Title:    "Check VIP Status",
				ConditionConfig: &workflow.ConditionConfig{
					Field:     "customer.is_vip",
					Operator:  "eq",
					ValueJSON: "true",
				},
			},
			{
				NodeID:   "node-trans-1",
				NodeType: workflow.NodeTypeTransform,
				Title:    "Format Notification Payload",
				TransformConfig: &workflow.TransformConfig{
					Mappings: []workflow.TransformMapping{
						{TargetField: "greeting", SourceField: "customer.name", Template: "Hello {{customer.name}}"},
						{TargetField: "tier", SourceField: "customer.tier", DefaultValue: "standard"},
					},
				},
			},
			{
				NodeID:   "node-act-1",
				NodeType: workflow.NodeTypeAction,
				Title:    "Reserve VIP Inventory",
				ActionConfig: &workflow.ActionConfig{
					RPCName:        "creativanta.commerce.v1.InventoryService/ReserveStock",
					InputJSON:      `{"sku_id":"sku-vip-99","quantity":1}`,
					TimeoutSeconds: 10,
					MaxRetries:     3,
				},
			},
			{
				NodeID:   "node-appr-1",
				NodeType: workflow.NodeTypeApproval,
				Title:    "Manager Discount Approval",
				ApprovalConfig: &workflow.ApprovalConfig{
					ApproverIDs:              []string{"usr-mgr-1", "usr-mgr-2"},
					RequiredApprovals:        1,
					ExpiresAtDurationSeconds: 86400,
					AutoActionOnTimeout:      "fallback",
				},
			},
			{
				NodeID:   "node-wait-1",
				NodeType: workflow.NodeTypeWait,
				Title:    "Wait 10 Minutes Before Sync",
				WaitConfig: &workflow.WaitConfig{
					WaitType:        "duration",
					DurationSeconds: 600,
				},
			},
			{
				NodeID:   "node-diag-1",
				NodeType: workflow.NodeTypeDiagnostics,
				Title:    "Log Diagnostics",
				DiagnosticsConfig: &workflow.DiagnosticsConfig{
					Severity:            "info",
					UserMessage:         "VIP workflow step executed successfully",
					OperatorMessage:     "Payload validated against schema",
					RecommendedNextStep: "Proceed to fulfill",
				},
			},
			{
				NodeID:   "node-fall-1",
				NodeType: workflow.NodeTypeFallback,
				Title:    "Route to Standard Fulfillment",
				FallbackConfig: &workflow.FallbackConfig{
					FallbackNodeID: "node-term-1",
					ReasonTemplate: "VIP routing condition was false or approval timed out",
					LogLevel:       "warning",
				},
			},
			{
				NodeID:   "node-hand-1",
				NodeType: workflow.NodeTypeHandoff,
				Title:    "Handoff to Support Agent",
				HandoffConfig: &workflow.HandoffConfig{
					TargetUserID: "usr-support-1",
					TargetRole:   "support",
					ContextNote:  "High-value VIP order requires personal call",
				},
			},
			{
				NodeID:   "node-term-1",
				NodeType: workflow.NodeTypeTerminal,
				Title:    "Workflow Completion",
				TerminalConfig: &workflow.TerminalConfig{
					Outcome:        "succeeded",
					ResultTemplate: "VIP order workflow processed successfully",
				},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "node-trig-1", ToNodeID: "node-cond-1"},
			// Condition branches: true -> transform, false -> fallback
			{FromNodeID: "node-cond-1", ToNodeID: "node-trans-1", Branch: workflow.EdgeBranchTrue},
			{FromNodeID: "node-cond-1", ToNodeID: "node-fall-1", Branch: workflow.EdgeBranchFalse},
			// True branch progression
			{FromNodeID: "node-trans-1", ToNodeID: "node-act-1"},
			{FromNodeID: "node-act-1", ToNodeID: "node-appr-1"},
			{FromNodeID: "node-appr-1", ToNodeID: "node-wait-1"},
			{FromNodeID: "node-wait-1", ToNodeID: "node-diag-1"},
			{FromNodeID: "node-diag-1", ToNodeID: "node-hand-1"},
			{FromNodeID: "node-hand-1", ToNodeID: "node-term-1"},
			// Fallback branch also terminates at terminal
			{FromNodeID: "node-fall-1", ToNodeID: "node-term-1"},
		},
	}
}

// ----------------------------------------------------------------------------
// Target 1: Graph Validation, Cycle Detection & Unbounded Graph Tests
// ----------------------------------------------------------------------------

func TestGraphValidation_ValidAll10Nodes(t *testing.T) {
	g := buildGraphWithAll10NodeTypes()
	if err := workflow.ValidateWorkflowGraph(&g); err != nil {
		t.Fatalf("expected valid 10-node graph to pass validation, got: %v", err)
	}
}

func TestGraphValidation_SelfLoopRejected(t *testing.T) {
	g := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "n1", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "n2", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "n1", ToNodeID: "n2"},
			{FromNodeID: "n2", ToNodeID: "n2"}, // Self-loop!
		},
	}
	err := workflow.ValidateWorkflowGraph(&g)
	if err == nil {
		t.Fatal("expected self-loop to be rejected, got nil")
	}
	if !strings.Contains(err.Error(), "self-loop") && !strings.Contains(err.Error(), "cycle") {
		t.Fatalf("expected self-loop or cycle error, got: %v", err)
	}
}

func TestGraphValidation_TwoNodeCycleRejected(t *testing.T) {
	g := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "n1", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "n2", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "pkg.Svc/Method"}},
			{NodeID: "n3", NodeType: workflow.NodeTypeTransform, TransformConfig: &workflow.TransformConfig{Mappings: []workflow.TransformMapping{{TargetField: "a", SourceField: "b"}}}},
			{NodeID: "n4", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "n1", ToNodeID: "n2"},
			{FromNodeID: "n2", ToNodeID: "n3"},
			{FromNodeID: "n3", ToNodeID: "n2"}, // 2-node cycle between intermediate nodes: n2 <-> n3
			{FromNodeID: "n3", ToNodeID: "n4"},
		},
	}
	err := workflow.ValidateWorkflowGraph(&g)
	if err == nil {
		t.Fatal("expected 2-node cycle to be rejected, got nil")
	}
	if !strings.Contains(err.Error(), "cycle") {
		t.Fatalf("expected cycle error, got: %v", err)
	}
}

func TestGraphValidation_ThreeNodeCycleRejected(t *testing.T) {
	g := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "n-trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "n-a", NodeType: workflow.NodeTypeTransform, TransformConfig: &workflow.TransformConfig{Mappings: []workflow.TransformMapping{{TargetField: "x", SourceField: "y"}}}},
			{NodeID: "n-b", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "pkg.Svc/Do"}},
			{NodeID: "n-c", NodeType: workflow.NodeTypeWait, WaitConfig: &workflow.WaitConfig{WaitType: "duration", DurationSeconds: 10}},
			{NodeID: "n-term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "n-trig", ToNodeID: "n-a"},
			{FromNodeID: "n-a", ToNodeID: "n-b"},
			{FromNodeID: "n-b", ToNodeID: "n-c"},
			{FromNodeID: "n-c", ToNodeID: "n-a"}, // Cycle: n-a -> n-b -> n-c -> n-a
			{FromNodeID: "n-c", ToNodeID: "n-term"},
		},
	}
	err := workflow.ValidateWorkflowGraph(&g)
	if err == nil {
		t.Fatal("expected 3-node cycle to be rejected, got nil")
	}
	if !strings.Contains(err.Error(), "cycle") {
		t.Fatalf("expected cycle error, got: %v", err)
	}
}

func TestGraphValidation_UnboundedNodeCountRejected(t *testing.T) {
	// Create graph with 101 nodes (exceeds max 100)
	nodes := make([]workflow.WorkflowNode, 102)
	edges := make([]workflow.WorkflowEdge, 101)

	nodes[0] = workflow.WorkflowNode{
		NodeID:        "node-0",
		NodeType:      workflow.NodeTypeTrigger,
		TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual},
	}
	for i := 1; i <= 100; i++ {
		nodes[i] = workflow.WorkflowNode{
			NodeID:          fmt.Sprintf("node-%d", i),
			NodeType:        workflow.NodeTypeTransform,
			TransformConfig: &workflow.TransformConfig{Mappings: []workflow.TransformMapping{{TargetField: "a", SourceField: "b"}}},
		}
		edges[i-1] = workflow.WorkflowEdge{
			FromNodeID: fmt.Sprintf("node-%d", i-1),
			ToNodeID:   fmt.Sprintf("node-%d", i),
		}
	}
	nodes[101] = workflow.WorkflowNode{
		NodeID:         "node-101",
		NodeType:       workflow.NodeTypeTerminal,
		TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
	}
	edges[100] = workflow.WorkflowEdge{
		FromNodeID: "node-100",
		ToNodeID:   "node-101",
	}

	g := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes:         nodes,
		Edges:         edges,
	}
	err := workflow.ValidateWorkflowGraph(&g)
	if err == nil {
		t.Fatal("expected >100 nodes graph to be rejected, got nil")
	}
	if !strings.Contains(err.Error(), "exceeds maximum") {
		t.Fatalf("expected node count exceeded error, got: %v", err)
	}
}

func TestGraphValidation_DisconnectedComponentRejected(t *testing.T) {
	g := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
			{NodeID: "floating", NodeType: workflow.NodeTypeTransform, TransformConfig: &workflow.TransformConfig{Mappings: []workflow.TransformMapping{{TargetField: "x", SourceField: "y"}}}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "term"},
		},
	}
	err := workflow.ValidateWorkflowGraph(&g)
	if err == nil {
		t.Fatal("expected disconnected node to be rejected, got nil")
	}
	if !strings.Contains(err.Error(), "unreachable") {
		t.Fatalf("expected unreachable node error, got: %v", err)
	}
}

func TestGraphValidation_DeadEndPathRejected(t *testing.T) {
	g := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
			{NodeID: "dead_end", NodeType: workflow.NodeTypeTransform, TransformConfig: &workflow.TransformConfig{Mappings: []workflow.TransformMapping{{TargetField: "x", SourceField: "y"}}}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "term"},
			{FromNodeID: "trig", ToNodeID: "dead_end"}, // dead_end has no out edges and is not terminal
		},
	}
	err := workflow.ValidateWorkflowGraph(&g)
	if err == nil {
		t.Fatal("expected dead end node without path to terminal to be rejected, got nil")
	}
	if !strings.Contains(err.Error(), "no path to terminal") {
		t.Fatalf("expected no path to terminal error, got: %v", err)
	}
}

func TestGraphValidation_MissingTerminalNodeRejected(t *testing.T) {
	g := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "pkg.Svc/Do"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act"},
		},
	}
	err := workflow.ValidateWorkflowGraph(&g)
	if err == nil {
		t.Fatal("expected graph without terminal node to be rejected, got nil")
	}
	if !strings.Contains(err.Error(), "terminal node") {
		t.Fatalf("expected missing terminal error, got: %v", err)
	}
}

func TestGraphValidation_ConditionNodeBranchValidation(t *testing.T) {
	// Condition node with invalid branch name (e.g., "maybe")
	g := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "cond", NodeType: workflow.NodeTypeCondition, ConditionConfig: &workflow.ConditionConfig{Field: "status", Operator: "eq", ValueJSON: `"ok"`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "cond"},
			{FromNodeID: "cond", ToNodeID: "term", Branch: "invalid_branch"},
		},
	}
	err := workflow.ValidateWorkflowGraph(&g)
	if err == nil {
		t.Fatal("expected invalid condition branch to be rejected, got nil")
	}
}

func TestGraphValidation_SecurityAudit(t *testing.T) {
	// 1. Raw SQL query injection
	g1 := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "DROP TABLE users;", InputJSON: "{}"}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act"},
			{FromNodeID: "act", ToNodeID: "term"},
		},
	}
	if err := workflow.ValidateWorkflowGraph(&g1); err == nil {
		t.Fatal("expected raw SQL to be rejected by security audit")
	}

	// 2. Secret credential leak
	g2 := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "pkg.Svc/Do", InputJSON: `{"secret":"sk_live_12345abcdef"}`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act"},
			{FromNodeID: "act", ToNodeID: "term"},
		},
	}
	if err := workflow.ValidateWorkflowGraph(&g2); err == nil {
		t.Fatal("expected credential key to be rejected by security audit")
	}

	// 3. Arbitrary eval in transform
	g3 := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "trans", NodeType: workflow.NodeTypeTransform, TransformConfig: &workflow.TransformConfig{
				Mappings: []workflow.TransformMapping{
					{TargetField: "code", SourceField: "input", Template: "eval(input.code)"},
				},
			}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "trans"},
			{FromNodeID: "trans", ToNodeID: "term"},
		},
	}
	if err := workflow.ValidateWorkflowGraph(&g3); err == nil {
		t.Fatal("expected arbitrary eval in transform to be rejected")
	}
}

// ----------------------------------------------------------------------------
// Target 2: Every Node Type Round Trip & Simulation
// ----------------------------------------------------------------------------

func TestEveryNodeType_RoundTripAndSimulation(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	engine := workflow.NewOwnedWorkflowEngine()
	svc := workflow.NewService(store, engine)

	caller := workflow.CallerContext{
		UserID:        "00000000-0000-0000-0000-000000000001",
		WorkspaceID:   "11111111-1111-1111-1111-111111111111",
		WorkspaceRole: "owner",
	}

	// 1. Create Workflow containing all 10 node types
	graph := buildGraphWithAll10NodeTypes()
	triggerCfg := workflow.TriggerConfig{Type: workflow.TriggerTypeEvent, EventType: "order.placed"}
	if graph.Nodes[0].TriggerConfig != nil {
		triggerCfg = *graph.Nodes[0].TriggerConfig
	}

	created, err := svc.CreateWorkflow(
		ctx,
		caller,
		"End-to-End All 10 Nodes Test",
		"Verifies serialization, storage, and dry-run execution",
		"custom",
		triggerCfg,
		graph,
		[]string{"usr-mgr-1"},
	)
	if err != nil {
		t.Fatalf("failed to create workflow with 10 nodes: %v", err)
	}

	if created.WorkflowID == "" {
		t.Fatal("expected non-empty workflow_id")
	}
	if len(created.ActionChain.Nodes) != 10 {
		t.Fatalf("expected 10 nodes, got %d", len(created.ActionChain.Nodes))
	}

	// 2. Retrieve Workflow and verify exact fields across all 10 nodes
	fetched, err := svc.GetWorkflow(ctx, caller, created.WorkflowID)
	if err != nil {
		t.Fatalf("failed to fetch workflow: %v", err)
	}
	if fetched.Title != "End-to-End All 10 Nodes Test" {
		t.Fatalf("expected title match, got: %s", fetched.Title)
	}

	nodeTypeSet := make(map[workflow.NodeType]bool)
	for _, n := range fetched.ActionChain.Nodes {
		nodeTypeSet[n.NodeType] = true
	}
	all10 := []workflow.NodeType{
		workflow.NodeTypeTrigger,
		workflow.NodeTypeCondition,
		workflow.NodeTypeTransform,
		workflow.NodeTypeAction,
		workflow.NodeTypeApproval,
		workflow.NodeTypeWait,
		workflow.NodeTypeFallback,
		workflow.NodeTypeDiagnostics,
		workflow.NodeTypeHandoff,
		workflow.NodeTypeTerminal,
	}
	for _, expectedType := range all10 {
		if !nodeTypeSet[expectedType] {
			t.Errorf("missing node type in fetched workflow: %s", expectedType)
		}
	}

	// 3. Dry-run simulation using OwnedWorkflowEngine
	simReport, err := svc.TestWorkflow(ctx, caller, created.WorkflowID, nil, map[string]any{
		"amount": 2500,
		"customer": map[string]any{
			"is_vip": true,
			"name":   "Ada Lovelace",
			"tier":   "platinum",
		},
	})
	if err != nil {
		t.Fatalf("dry run test simulation failed: %v", err)
	}

	if !simReport.Success {
		t.Fatalf("expected dry-run simulation to succeed, got report: %+v", simReport)
	}
	if len(simReport.StepResults) == 0 {
		t.Fatal("expected simulated step results, got 0")
	}
	if simReport.TotalEstimatedCredits <= 0 {
		t.Fatalf("expected positive estimated credits for action nodes, got %f", simReport.TotalEstimatedCredits)
	}
}

func TestAllTriggerTypes(t *testing.T) {
	triggers := []struct {
		name string
		cfg  workflow.TriggerConfig
	}{
		{
			name: "event",
			cfg: workflow.TriggerConfig{
				Type:      workflow.TriggerTypeEvent,
				EventType: "inventory.stock_depleted",
			},
		},
		{
			name: "schedule",
			cfg: workflow.TriggerConfig{
				Type:           workflow.TriggerTypeSchedule,
				CronExpression: "0 0 * * *",
			},
		},
		{
			name: "manual",
			cfg: workflow.TriggerConfig{
				Type: workflow.TriggerTypeManual,
			},
		},
		{
			name: "webhook",
			cfg: workflow.TriggerConfig{
				Type:        workflow.TriggerTypeWebhook,
				WebhookPath: "/webhooks/v1/custom-ingest",
			},
		},
	}

	for _, tc := range triggers {
		t.Run(tc.name, func(t *testing.T) {
			g := workflow.WorkflowGraph{
				SchemaVersion: 1,
				Nodes: []workflow.WorkflowNode{
					{
						NodeID:        "trig-1",
						NodeType:      workflow.NodeTypeTrigger,
						TriggerConfig: &tc.cfg,
					},
					{
						NodeID:         "term-1",
						NodeType:       workflow.NodeTypeTerminal,
						TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
					},
				},
				Edges: []workflow.WorkflowEdge{
					{FromNodeID: "trig-1", ToNodeID: "term-1"},
				},
			}
			if err := workflow.ValidateWorkflowGraph(&g); err != nil {
				t.Fatalf("expected valid trigger %s, got: %v", tc.name, err)
			}
		})
	}
}

// ----------------------------------------------------------------------------
// Target 3: Adapter Entitlement & Zero Embedding License Assumed
// ----------------------------------------------------------------------------

func TestAdapterEntitlement_ZeroLicenseAssumed(t *testing.T) {
	ctx := context.Background()

	// 1. Verify OwnedWorkflowEngine operates without any external license key
	ownedEngine := workflow.NewOwnedWorkflowEngine()
	entitled, err := ownedEngine.IsEntitled(ctx, "workspace-test-1")
	if err != nil || !entitled {
		t.Fatal("owned workflow engine must always be entitled by default (first-class baseline)")
	}
	if ownedEngine.RequiresLicense() {
		t.Fatal("owned workflow engine must NOT require any embedding license")
	}

	// 2. Verify ActivepiecesAdapter rejects execution when unentitled
	apAdapter := workflow.NewActivepiecesAdapter("")
	apEntitled, err := apAdapter.IsEntitled(ctx, "workspace-test-1")
	if apEntitled || err == nil {
		t.Fatal("ActivepiecesAdapter without commercial license must report unentitled")
	}
	if !apAdapter.RequiresLicense() {
		t.Fatal("ActivepiecesAdapter must indicate that external license is required")
	}

	// Attempting to simulate with unentitled adapter must fail with sentinel ErrActivepiecesUnentitled
	g := buildGraphWithAll10NodeTypes()
	_, err = apAdapter.SimulateWorkflow(ctx, &g, map[string]any{})
	if err == nil {
		t.Fatal("expected unentitled ActivepiecesAdapter to fail execution")
	}
	if !strings.Contains(err.Error(), "Activepieces Enterprise license is not entitled") {
		t.Fatalf("expected Activepieces unentitled error, got: %v", err)
	}
}

// ----------------------------------------------------------------------------
// Target 4: Versioning, Optimistic Concurrency, and Portable Export/Import
// ----------------------------------------------------------------------------

func TestVersioningAndOptimisticConcurrency(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())

	caller := workflow.CallerContext{
		UserID:        "00000000-0000-0000-0000-000000000001",
		WorkspaceID:   "11111111-1111-1111-1111-111111111111",
		WorkspaceRole: "owner",
	}

	graph := buildGraphWithAll10NodeTypes()
	created, err := svc.CreateWorkflow(
		ctx,
		caller,
		"Concurrency Test Workflow",
		"Test initial version",
		"custom",
		*graph.Nodes[0].TriggerConfig,
		graph,
		nil,
	)
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}
	if created.Version != 1 {
		t.Fatalf("expected initial version 1, got %d", created.Version)
	}

	// 1. Successful update with expected_version = 1 -> bumps to 2
	updated, err := svc.UpdateWorkflow(
		ctx,
		caller,
		created.WorkflowID,
		"Updated Title v2",
		"Updated description",
		*graph.Nodes[0].TriggerConfig,
		graph,
		nil,
		1,
	)
	if err != nil {
		t.Fatalf("expected version 1 update to succeed, got: %v", err)
	}
	if updated.Version != 2 {
		t.Fatalf("expected version bumped to 2, got %d", updated.Version)
	}

	// 2. Conflicting update with stale expected_version = 1 -> must fail with ErrVersionMismatch
	_, err = svc.UpdateWorkflow(
		ctx,
		caller,
		created.WorkflowID,
		"Conflicting Update",
		"Should fail",
		*graph.Nodes[0].TriggerConfig,
		graph,
		nil,
		1, // Stale version!
	)
	if err == nil {
		t.Fatal("expected optimistic concurrency conflict, got nil")
	}
	if !strings.Contains(err.Error(), "version mismatch") {
		t.Fatalf("expected version mismatch error, got: %v", err)
	}
}

func TestPortableExportImport_RoundTrip(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())

	caller := workflow.CallerContext{
		UserID:        "00000000-0000-0000-0000-000000000001",
		WorkspaceID:   "11111111-1111-1111-1111-111111111111",
		WorkspaceRole: "owner",
	}

	graph := buildGraphWithAll10NodeTypes()
	original, err := svc.CreateWorkflow(
		ctx,
		caller,
		"Export Template Source",
		"Export source description",
		"custom",
		*graph.Nodes[0].TriggerConfig,
		graph,
		[]string{"approver-1"},
	)
	if err != nil {
		t.Fatalf("failed to create original workflow: %v", err)
	}

	// 1. Export Workflow
	exported, err := svc.ExportWorkflow(ctx, caller, original.WorkflowID)
	if err != nil {
		t.Fatalf("failed to export workflow: %v", err)
	}

	if exported.SchemaVersion != 1 {
		t.Fatalf("expected schema version 1, got %d", exported.SchemaVersion)
	}
	if exported.Title != "Export Template Source" {
		t.Fatalf("expected title match, got %s", exported.Title)
	}
	if !strings.Contains(exported.LicenseNotice, "Proprietary to tenant") {
		t.Fatalf("expected license notice in export, got: %s", exported.LicenseNotice)
	}

	// 2. Serialize exported payload to JSON and deserialize (simulating file download/upload)
	jsonBytes, err := json.Marshal(exported)
	if err != nil {
		t.Fatalf("failed to marshal export: %v", err)
	}

	var importedPayload workflow.PortableWorkflowPayload
	if err := json.Unmarshal(jsonBytes, &importedPayload); err != nil {
		t.Fatalf("failed to unmarshal exported JSON: %v", err)
	}

	// 3. Import Workflow into a different workspace
	importCaller := workflow.CallerContext{
		UserID:        "00000000-0000-0000-0000-000000000002",
		WorkspaceID:   "22222222-2222-2222-2222-222222222222",
		WorkspaceRole: "owner",
	}

	imported, err := svc.ImportWorkflow(ctx, importCaller, &importedPayload)
	if err != nil {
		t.Fatalf("failed to import workflow: %v", err)
	}

	// Verify imported entity has fresh ID, new tenant workspace, Draft status, and clean version 1
	if imported.WorkflowID == original.WorkflowID {
		t.Fatal("imported workflow must receive a new UUID, not reuse original")
	}
	if imported.WorkspaceID != importCaller.WorkspaceID {
		t.Fatalf("expected imported workspace %s, got %s", importCaller.WorkspaceID, imported.WorkspaceID)
	}
	if imported.Status != workflow.WorkflowStatusDraft {
		t.Fatalf("imported workflow must be draft, got %s", imported.Status)
	}
	if imported.Version != 1 {
		t.Fatalf("imported workflow must have version 1, got %d", imported.Version)
	}
	if len(imported.ActionChain.Nodes) != 10 {
		t.Fatalf("expected 10 nodes preserved after import, got %d", len(imported.ActionChain.Nodes))
	}
}

func TestCloneWorkflow(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())

	caller := workflow.CallerContext{
		UserID:        "00000000-0000-0000-0000-000000000001",
		WorkspaceID:   "11111111-1111-1111-1111-111111111111",
		WorkspaceRole: "owner",
	}

	graph := buildGraphWithAll10NodeTypes()
	original, err := svc.CreateWorkflow(
		ctx,
		caller,
		"Base Workflow",
		"Desc",
		"custom",
		*graph.Nodes[0].TriggerConfig,
		graph,
		nil,
	)
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}

	cloned, err := svc.CloneWorkflow(ctx, caller, original.WorkflowID, "Cloned Workflow v1")
	if err != nil {
		t.Fatalf("clone failed: %v", err)
	}

	if cloned.WorkflowID == original.WorkflowID {
		t.Fatal("cloned workflow must have a distinct workflow_id")
	}
	if cloned.Title != "Cloned Workflow v1" {
		t.Fatalf("expected title 'Cloned Workflow v1', got: %s", cloned.Title)
	}
	if cloned.Status != workflow.WorkflowStatusDraft {
		t.Fatalf("cloned workflow must start in draft, got: %s", cloned.Status)
	}
}

// ----------------------------------------------------------------------------
// Target 5: Service Lifecycle & ConnectRPC Handler Test
// ----------------------------------------------------------------------------

func TestServiceLifecycle_ActivateDeactivateRun(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())

	caller := workflow.CallerContext{
		UserID:        "00000000-0000-0000-0000-000000000001",
		WorkspaceID:   "11111111-1111-1111-1111-111111111111",
		WorkspaceRole: "owner",
	}

	graph := buildGraphWithAll10NodeTypes()
	wf, err := svc.CreateWorkflow(
		ctx,
		caller,
		"Lifecycle Flow",
		"Desc",
		"custom",
		*graph.Nodes[0].TriggerConfig,
		graph,
		nil,
	)
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}

	// 1. Activate
	activated, err := svc.ActivateWorkflow(ctx, caller, wf.WorkflowID)
	if err != nil {
		t.Fatalf("activate failed: %v", err)
	}
	if activated.Status != workflow.WorkflowStatusActive {
		t.Fatalf("expected status active, got %s", activated.Status)
	}

	// 2. Trigger Run
	run, err := svc.RunWorkflow(ctx, caller, wf.WorkflowID, map[string]any{"customer": map[string]any{"is_vip": true}})
	if err != nil {
		t.Fatalf("run failed: %v", err)
	}
	if run.WorkflowID != wf.WorkflowID {
		t.Fatalf("run workflow mismatch: %s != %s", run.WorkflowID, wf.WorkflowID)
	}

	// 3. Inspect Run Details and Steps
	fetchedRun, steps, err := svc.GetRunDetail(ctx, caller, run.RunID)
	if err != nil {
		t.Fatalf("get run detail failed: %v", err)
	}
	if fetchedRun.RunID != run.RunID {
		t.Fatalf("run ID mismatch")
	}
	if len(steps) == 0 {
		t.Fatal("expected steps recorded for run")
	}

	// 4. Deactivate
	deactivated, err := svc.DeactivateWorkflow(ctx, caller, wf.WorkflowID)
	if err != nil {
		t.Fatalf("deactivate failed: %v", err)
	}
	if deactivated.Status != workflow.WorkflowStatusPaused {
		t.Fatalf("expected status paused, got %s", deactivated.Status)
	}
}

func TestRBACPermissionChecks(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())

	viewerCaller := workflow.CallerContext{
		UserID:        "00000000-0000-0000-0000-000000000099",
		WorkspaceID:   "11111111-1111-1111-1111-111111111111",
		WorkspaceRole: "viewer", // Viewer has read permissions only
	}

	graph := buildGraphWithAll10NodeTypes()

	// Attempting create as viewer must fail with ErrUnauthorized
	_, err := svc.CreateWorkflow(
		ctx,
		viewerCaller,
		"Unauthorized Flow",
		"Desc",
		"custom",
		*graph.Nodes[0].TriggerConfig,
		graph,
		nil,
	)
	if err == nil {
		t.Fatal("expected viewer create to fail with unauthorized, got nil")
	}
	if !strings.Contains(err.Error(), "unauthorized") {
		t.Fatalf("expected unauthorized error, got: %v", err)
	}
}

func TestConnectRPCHandler(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())
	handler := workflow.NewHandler(svc)

	wsID := "11111111-1111-1111-1111-111111111111"

	// 1. Handler Create
	createReq := connect.NewRequest(&automationv1.WorkflowServiceCreateRequest{
		WorkspaceId:  wsID,
		Title:        "ConnectRPC Flow",
		Description:  "Created via ConnectRPC Handler",
		WorkflowType: "custom",
		TriggerConfig: &automationv1.TriggerConfig{
			Type:      automationv1.TriggerType_TRIGGER_TYPE_EVENT,
			EventType: "order.created",
		},
		ActionChain: &automationv1.WorkflowGraph{
			SchemaVersion: 1,
			Nodes: []*automationv1.WorkflowNode{
				{
					NodeId:   "n1",
					NodeType: automationv1.NodeType_NODE_TYPE_TRIGGER,
					Config: &automationv1.WorkflowNode_TriggerConfig{
						TriggerConfig: &automationv1.TriggerNodeConfig{
							Config: &automationv1.TriggerConfig{Type: automationv1.TriggerType_TRIGGER_TYPE_EVENT, EventType: "order.created"},
						},
					},
				},
				{
					NodeId:   "n2",
					NodeType: automationv1.NodeType_NODE_TYPE_TERMINAL,
					Config: &automationv1.WorkflowNode_TerminalConfig{
						TerminalConfig: &automationv1.TerminalNodeConfig{Outcome: "succeeded"},
					},
				},
			},
			Edges: []*automationv1.WorkflowEdge{
				{FromNodeId: "n1", ToNodeId: "n2"},
			},
		},
	})

	createResp, err := handler.Create(ctx, createReq)
	if err != nil {
		t.Fatalf("handler Create failed: %v", err)
	}
	wfID := createResp.Msg.Id
	if wfID == "" {
		t.Fatal("expected workflow ID returned from Create")
	}

	// 2. Handler Get
	getReq := connect.NewRequest(&automationv1.WorkflowServiceGetRequest{
		WorkspaceId: wsID,
		WorkflowId:  wfID,
	})
	getResp, err := handler.Get(ctx, getReq)
	if err != nil {
		t.Fatalf("handler Get failed: %v", err)
	}
	if getResp.Msg.Workflow.Title != "ConnectRPC Flow" {
		t.Fatalf("title mismatch: %s", getResp.Msg.Workflow.Title)
	}

	// 3. Handler List
	listReq := connect.NewRequest(&automationv1.WorkflowServiceListRequest{
		WorkspaceId: wsID,
	})
	listResp, err := handler.List(ctx, listReq)
	if err != nil {
		t.Fatalf("handler List failed: %v", err)
	}
	if listResp.Msg.TotalCount != 1 {
		t.Fatalf("expected total_count 1, got %d", listResp.Msg.TotalCount)
	}

	// 4. Handler Run
	runReq := connect.NewRequest(&automationv1.WorkflowServiceRunRequest{
		WorkspaceId: wsID,
		WorkflowId:  wfID,
	})
	runResp, err := handler.Run(ctx, runReq)
	if err != nil {
		t.Fatalf("handler Run failed: %v", err)
	}
	if runResp.Msg.RunId == "" {
		t.Fatal("expected run_id in RunResponse")
	}

	// 5. Handler Export
	exportReq := connect.NewRequest(&automationv1.WorkflowServiceExportRequest{
		WorkspaceId: wsID,
		WorkflowId:  wfID,
	})
	exportResp, err := handler.Export(ctx, exportReq)
	if err != nil {
		t.Fatalf("handler Export failed: %v", err)
	}
	if exportResp.Msg.Payload == nil {
		t.Fatal("expected portable payload in ExportResponse")
	}

	// 6. Handler Test
	testReq := connect.NewRequest(&automationv1.WorkflowServiceTestRequest{
		WorkspaceId: wsID,
		WorkflowId:  wfID,
	})
	testResp, err := handler.Test(ctx, testReq)
	if err != nil {
		t.Fatalf("handler Test failed: %v", err)
	}
	if !testResp.Msg.Success {
		t.Fatal("expected test execution to succeed")
	}
}

// ----------------------------------------------------------------------------
// Target 6: Concurrency Race Test
// ----------------------------------------------------------------------------

func TestConcurrentWorkflowOperations(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())

	caller := workflow.CallerContext{
		UserID:        "00000000-0000-0000-0000-000000000001",
		WorkspaceID:   "11111111-1111-1111-1111-111111111111",
		WorkspaceRole: "owner",
	}

	var wg sync.WaitGroup
	workers := 10
	iterations := 5

	for w := 0; w < workers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			graph := buildGraphWithAll10NodeTypes()
			for i := 0; i < iterations; i++ {
				title := fmt.Sprintf("Concurrent Flow worker %d iter %d", workerID, i)
				wf, err := svc.CreateWorkflow(
					ctx,
					caller,
					title,
					"Desc",
					"custom",
					*graph.Nodes[0].TriggerConfig,
					graph,
					nil,
				)
				if err != nil {
					t.Errorf("worker %d iteration %d create failed: %v", workerID, i, err)
					return
				}

				// Run workflow
				_, err = svc.RunWorkflow(ctx, caller, wf.WorkflowID, map[string]any{"worker": workerID})
				if err != nil {
					t.Errorf("worker %d iteration %d run failed: %v", workerID, i, err)
					return
				}

				// Fetch details
				_, err = svc.GetWorkflow(ctx, caller, wf.WorkflowID)
				if err != nil {
					t.Errorf("worker %d iteration %d get failed: %v", workerID, i, err)
					return
				}
			}
		}(w)
	}

	wg.Wait()
}

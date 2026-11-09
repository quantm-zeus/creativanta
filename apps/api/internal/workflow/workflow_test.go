package workflow_test

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
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
	wsID := "11111111-1111-1111-1111-111111111111"
	ctx := transportauth.WithPrincipal(context.Background(), transportauth.Session{
		UserID:      "11111111-1111-1111-1111-111111111199",
		WorkspaceID: wsID,
		Role:        "manager",
	})
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())
	handler := workflow.NewHandler(svc)

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
					NodeId:   "n_act",
					NodeType: automationv1.NodeType_NODE_TYPE_ACTION,
					Config: &automationv1.WorkflowNode_ActionConfig{
						ActionConfig: &automationv1.ActionNodeConfig{
							RpcName:   "creativanta.commerce.v1.InventoryService/ReserveStock",
							InputJson: `{"sku":"sku-1"}`,
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
				{FromNodeId: "n1", ToNodeId: "n_act"},
				{FromNodeId: "n_act", ToNodeId: "n2"},
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

	// 4. Handler Activate + Run
	actReq := connect.NewRequest(&automationv1.WorkflowServiceActivateRequest{
		WorkspaceId: wsID,
		WorkflowId:  wfID,
	})
	if _, err := handler.Activate(ctx, actReq); err != nil {
		t.Fatalf("handler Activate failed: %v", err)
	}
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

func TestConnectRPCHandler_AuthAndRBACHardening(t *testing.T) {
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, workflow.NewOwnedWorkflowEngine())
	handler := workflow.NewHandler(svc)

	wsA := "11111111-1111-1111-1111-111111111111"
	wsB := "22222222-2222-2222-2222-222222222222"

	// 1. Unauthenticated caller supplying WorkspaceId must be rejected with CodeUnauthenticated (no synthetic owner).
	_, err := handler.Create(context.Background(), connect.NewRequest(&automationv1.WorkflowServiceCreateRequest{
		WorkspaceId: wsA,
		Title:       "Unauthenticated Flow",
	}))
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for missing principal, got %v", err)
	}

	// 2. Principal for Workspace A targeting Workspace B must be rejected with CodePermissionDenied.
	editorCtxA := transportauth.WithPrincipal(context.Background(), transportauth.Session{
		UserID:      "11111111-1111-1111-1111-111111111110",
		WorkspaceID: wsA,
		Role:        "editor",
	})
	_, err = handler.List(editorCtxA, connect.NewRequest(&automationv1.WorkflowServiceListRequest{
		WorkspaceId: wsB,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for cross-workspace request, got %v", err)
	}

	// 3. Viewer role must NOT be escalated to owner; Create and Activate must fail with CodePermissionDenied.
	viewerCtxA := transportauth.WithPrincipal(context.Background(), transportauth.Session{
		UserID:      "11111111-1111-1111-1111-111111111112",
		WorkspaceID: wsA,
		Role:        "viewer",
	})
	_, err = handler.Create(viewerCtxA, connect.NewRequest(&automationv1.WorkflowServiceCreateRequest{
		WorkspaceId: wsA,
		Title:       "Viewer Flow",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when viewer calls Create, got %v", err)
	}

	// Editor cannot Activate (requires workflow:activate / Manager+).
	_, err = handler.Activate(editorCtxA, connect.NewRequest(&automationv1.WorkflowServiceActivateRequest{
		WorkspaceId: wsA,
		WorkflowId:  "wf-1",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when editor calls Activate, got %v", err)
	}

	// Viewer CAN call List (workflow:read).
	if _, err := handler.List(viewerCtxA, connect.NewRequest(&automationv1.WorkflowServiceListRequest{
		WorkspaceId: wsA,
	})); err != nil {
		t.Fatalf("expected viewer List to succeed, got %v", err)
	}

	// 4. MembershipRoleResolver rejecting inactive membership must fail with CodePermissionDenied.
	handlerWithResolver := workflow.NewHandler(svc).WithMembershipRoleResolver(func(ctx context.Context, wsID, userID string) (string, bool, error) {
		return "owner", false, nil
	})
	_, err = handlerWithResolver.List(editorCtxA, connect.NewRequest(&automationv1.WorkflowServiceListRequest{
		WorkspaceId: wsA,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for inactive membership, got %v", err)
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

				if _, err := svc.ActivateWorkflow(ctx, caller, wf.WorkflowID); err != nil {
					t.Errorf("worker %d iteration %d activate failed: %v", workerID, i, err)
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

// ============================================================================
// P7-02 Acceptance Tests
// Acceptance Targets:
//   1. Simulation has no business effects
//   2. Changed action invalidates approval
//   3. Resume never replays confirmed effect
// ============================================================================

func TestP702_Simulation_ZeroBusinessEffects(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	capProvider := workflow.NewDefaultCapabilityProvider()
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)
	svc.SetCapabilityProvider(capProvider)

	caller := workflow.CallerContext{
		UserID:        "usr-editor-1",
		WorkspaceID:   "ws-sim-1",
		WorkspaceRole: "editor",
	}

	graph := buildGraphWithAll10NodeTypes()
	sampleContext := map[string]any{
		"amount": 2500,
		"customer": map[string]any{
			"is_vip": "true",
			"name":   "Alex Creator",
			"tier":   "gold",
		},
	}

	// 1. Run Preflight Check
	preflightReport, err := svc.PreflightWorkflow(ctx, caller, "", &graph)
	if err != nil {
		t.Fatalf("PreflightWorkflow failed: %v", err)
	}
	if !preflightReport.Valid {
		t.Fatalf("expected preflight valid, got errors: %v", preflightReport.Errors)
	}
	if preflightReport.TotalMaxCreditQuote <= 0 {
		t.Errorf("expected positive total credit quote, got %.2f", preflightReport.TotalMaxCreditQuote)
	}
	if !preflightReport.RequiresApproval {
		t.Errorf("expected preflight to flag sensitive action requiring approval")
	}

	// 2. Run Dry Run Simulation
	report, err := svc.TestWorkflow(ctx, caller, "", &graph, sampleContext)
	if err != nil {
		t.Fatalf("TestWorkflow (simulation) failed: %v", err)
	}

	if !report.Success {
		t.Fatalf("expected simulation success, got summary: %s", report.SimulationSummary)
	}
	if report.TotalEstimatedCredits <= 0 {
		t.Errorf("expected positive estimated credits in simulation, got %.2f", report.TotalEstimatedCredits)
	}
	if len(report.StepResults) < 5 {
		t.Errorf("expected at least 5 simulated steps, got %d", len(report.StepResults))
	}

	// 3. Acceptance Target 1: Simulation has NO business effects!
	// Assert 0 calls were dispatched to the underlying action dispatcher
	dispatchedCount := dispatcher.GetDispatchedCount("")
	if dispatchedCount != 0 {
		t.Fatalf("ACCEPTANCE TARGET VIOLATION: Simulation made %d real action dispatches! Expected strictly 0.", dispatchedCount)
	}

	// Assert no runs, run steps, or approvals were created in the store
	runs, totalRuns, _ := svc.ListRuns(ctx, caller, "", "", 10, 0)
	if totalRuns != 0 || len(runs) != 0 {
		t.Fatalf("ACCEPTANCE TARGET VIOLATION: Simulation created %d real workflow runs in storage!", totalRuns)
	}
	approvals, _ := svc.ListPendingApprovals(ctx, caller)
	if len(approvals) != 0 {
		t.Fatalf("ACCEPTANCE TARGET VIOLATION: Simulation created %d real approval requests!", len(approvals))
	}
}

func TestP702_ChangedAction_InvalidatesApproval(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	capProvider := workflow.NewDefaultCapabilityProvider()
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)
	svc.SetCapabilityProvider(capProvider)

	editor := workflow.CallerContext{
		UserID:        "usr-editor-1",
		WorkspaceID:   "ws-appr-1",
		WorkspaceRole: "editor",
	}
	manager := workflow.CallerContext{
		UserID:        "usr-mgr-1",
		WorkspaceID:   "ws-appr-1",
		WorkspaceRole: "manager",
	}

	// Build workflow: Trigger -> Action1 -> Approval -> Action2 -> Terminal
	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:        "node-trig",
				NodeType:      workflow.NodeTypeTrigger,
				Title:         "Trigger",
				TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual},
			},
			{
				NodeID:   "node-act-1",
				NodeType: workflow.NodeTypeAction,
				Title:    "Initial Step",
				ActionConfig: &workflow.ActionConfig{
					RPCName:   "creativanta.commerce.v1.InventoryService/ReserveStock",
					InputJSON: `{"sku":"sku-test-1"}`,
				},
			},
			{
				NodeID:   "node-appr",
				NodeType: workflow.NodeTypeApproval,
				Title:    "Publish Approval Gate",
				ApprovalConfig: &workflow.ApprovalConfig{
					ApproverIDs:              []string{manager.UserID},
					RequiredApprovals:        1,
					ExpiresAtDurationSeconds: 86400,
				},
			},
			{
				NodeID:   "node-act-2",
				NodeType: workflow.NodeTypeAction,
				Title:    "Sensitive Publish",
				ActionConfig: &workflow.ActionConfig{
					RPCName:   "creativanta.publish.v1.PublishService/Publish",
					InputJSON: `{"platform":"tiktok","account_id":"acc-initial-123"}`,
				},
			},
			{
				NodeID:         "node-term",
				NodeType:       workflow.NodeTypeTerminal,
				Title:          "Done",
				TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "node-trig", ToNodeID: "node-act-1"},
			{FromNodeID: "node-act-1", ToNodeID: "node-appr"},
			{FromNodeID: "node-appr", ToNodeID: "node-act-2", Branch: workflow.EdgeBranchSuccess},
			{FromNodeID: "node-act-2", ToNodeID: "node-term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, editor, "Approval Invalidation Flow", "Test Flow", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow failed: %v", err)
	}

	_, err = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)
	if err != nil {
		t.Fatalf("ActivateWorkflow failed: %v", err)
	}

	// 1. Run workflow -> should pause at node-appr in waiting_approval
	run, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, map[string]any{"source": "test"})
	if err != nil {
		t.Fatalf("RunWorkflow failed: %v", err)
	}

	if run.Status != workflow.WorkflowRunStatusWaitingApproval {
		t.Fatalf("expected run status waiting_approval, got %s", run.Status)
	}

	// Check approval request was created
	pending, err := svc.ListPendingApprovals(ctx, manager)
	if err != nil {
		t.Fatalf("ListPendingApprovals failed: %v", err)
	}
	if len(pending) != 1 {
		t.Fatalf("expected 1 pending approval, got %d", len(pending))
	}
	appReq := pending[0]
	if appReq.Status != "pending_approval" {
		t.Fatalf("expected pending_approval status, got %s", appReq.Status)
	}

	// 2. Acceptance Target 2: Changed action invalidates approval!
	// Scenario A: Operator modifies the action target (e.g. from acc-initial-123 to acc-changed-999)
	graph.Nodes[3].ActionConfig.InputJSON = `{"platform":"tiktok","account_id":"acc-changed-999"}`
	_, err = svc.UpdateWorkflow(ctx, editor, wf.WorkflowID, "Approval Invalidation Flow Updated", "Updated Desc", *graph.Nodes[0].TriggerConfig, graph, nil, wf.Version)
	if err != nil {
		t.Fatalf("UpdateWorkflow failed: %v", err)
	}

	// The existing approval request MUST have been invalidated!
	appAfterUpdate, err := svc.ApprovalManager().GetApprovalRequest(ctx, manager.WorkspaceID, appReq.RequestID)
	if err != nil {
		t.Fatalf("GetApprovalRequest failed: %v", err)
	}
	if appAfterUpdate.Status != "cancelled" {
		t.Fatalf("ACCEPTANCE TARGET VIOLATION: Expected approval status 'cancelled' after workflow action update, got '%s'", appAfterUpdate.Status)
	}

	// 3. Attempting to approve the invalidated request MUST fail with ErrApprovalInvalidated
	_, _, approveErr := svc.Approve(ctx, manager, appReq.RequestID)
	if approveErr == nil {
		t.Fatalf("ACCEPTANCE TARGET VIOLATION: Expected error approving invalidated approval request, but it succeeded!")
	}
	if !strings.Contains(approveErr.Error(), "invalid approval state transition") && !strings.Contains(approveErr.Error(), "cancelled") {
		t.Logf("Approve returned expected rejection for invalidated request: %v", approveErr)
	}

	// Scenario B: Test action hash mismatch detection inside Approve()
	// Trigger fresh run
	run2, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, map[string]any{"source": "test2"})
	if err != nil {
		t.Fatalf("RunWorkflow 2 failed: %v", err)
	}
	_ = run2
	pending2, _ := svc.ListPendingApprovals(ctx, manager)
	if len(pending2) != 1 {
		t.Fatalf("expected 1 pending approval for run2, got %d", len(pending2))
	}
	appReq2 := pending2[0]

	// Simulate action input change directly on workflow store before approval is processed
	wfCurrent, _ := svc.GetWorkflow(ctx, editor, wf.WorkflowID)
	wfCurrent.Version++ // bump version
	_ = store.UpdateWorkflow(ctx, wfCurrent)

	_, _, staleApproveErr := svc.Approve(ctx, manager, appReq2.RequestID)
	if staleApproveErr == nil {
		t.Fatalf("ACCEPTANCE TARGET VIOLATION: Expected ErrApprovalInvalidated on version bump, but approval succeeded!")
	}
	if !strings.Contains(staleApproveErr.Error(), "changed after approval requested") {
		t.Logf("Approve rejected with: %v", staleApproveErr)
	}
}

func TestP702_Resume_NeverReplaysConfirmedEffect(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	capProvider := workflow.NewDefaultCapabilityProvider()
	capProvider.SetStatus("tiktok", "supported")
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)
	svc.SetCapabilityProvider(capProvider)

	editor := workflow.CallerContext{
		UserID:        "usr-editor-1",
		WorkspaceID:   "ws-resume-1",
		WorkspaceRole: "editor",
	}
	manager := workflow.CallerContext{
		UserID:        "usr-mgr-1",
		WorkspaceID:   "ws-resume-1",
		WorkspaceRole: "manager",
	}
	store.SetMemberRole(editor.WorkspaceID, editor.UserID, editor.WorkspaceRole, true)
	store.SetMemberRole(manager.WorkspaceID, manager.UserID, manager.WorkspaceRole, true)

	// Graph: Trigger -> Action1 (ReserveStock) -> ApprovalGate -> Action2 (Publish) -> Terminal
	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:        "node-trig",
				NodeType:      workflow.NodeTypeTrigger,
				Title:         "Trigger",
				TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual},
			},
			{
				NodeID:   "node-act-1",
				NodeType: workflow.NodeTypeAction,
				Title:    "Reserve Stock Action",
				ActionConfig: &workflow.ActionConfig{
					RPCName:   "creativanta.commerce.v1.InventoryService/ReserveStock",
					InputJSON: `{"sku":"sku-vip-resume","qty":1}`,
				},
			},
			{
				NodeID:   "node-appr",
				NodeType: workflow.NodeTypeApproval,
				Title:    "Gate",
				ApprovalConfig: &workflow.ApprovalConfig{
					ApproverIDs:              []string{manager.UserID},
					RequiredApprovals:        1,
					ExpiresAtDurationSeconds: 86400,
				},
			},
			{
				NodeID:   "node-act-2",
				NodeType: workflow.NodeTypeAction,
				Title:    "Publish Content Action",
				ActionConfig: &workflow.ActionConfig{
					RPCName:   "creativanta.publish.v1.PublishService/Publish",
					InputJSON: `{"platform":"tiktok","title":"VIP Drop"}`,
				},
			},
			{
				NodeID:         "node-term",
				NodeType:       workflow.NodeTypeTerminal,
				Title:          "Terminal",
				TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "node-trig", ToNodeID: "node-act-1"},
			{FromNodeID: "node-act-1", ToNodeID: "node-appr"},
			{FromNodeID: "node-appr", ToNodeID: "node-act-2", Branch: workflow.EdgeBranchSuccess},
			{FromNodeID: "node-act-2", ToNodeID: "node-term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, editor, "Resume Idempotency Flow", "Flow", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow failed: %v", err)
	}

	_, err = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)
	if err != nil {
		t.Fatalf("ActivateWorkflow failed: %v", err)
	}

	// 1. Initial run: Action 1 executes, run halts at ApprovalGate
	run, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, map[string]any{"order_id": "ord-123"})
	if err != nil {
		t.Fatalf("RunWorkflow failed: %v", err)
	}

	if run.Status != workflow.WorkflowRunStatusWaitingApproval {
		t.Fatalf("expected status waiting_approval, got %s", run.Status)
	}

	// Verify Action 1 was dispatched exactly once
	initialAction1Dispatches := dispatcher.GetDispatchedCount("creativanta.commerce.v1.InventoryService/ReserveStock")
	if initialAction1Dispatches != 1 {
		t.Fatalf("expected Action 1 dispatched exactly 1 time, got %d", initialAction1Dispatches)
	}

	// Action 2 must not have been dispatched yet
	if dispatcher.GetDispatchedCount("creativanta.publish.v1.PublishService/Publish") != 0 {
		t.Fatalf("expected Action 2 not dispatched yet, got %d", dispatcher.GetDispatchedCount("creativanta.publish.v1.PublishService/Publish"))
	}

	// Find the pending approval
	pending, err := svc.ListPendingApprovals(ctx, manager)
	if err != nil || len(pending) != 1 {
		t.Fatalf("expected 1 pending approval, got %d (err: %v)", len(pending), err)
	}

	// 2. Manager approves -> Triggers ResumeRun
	_, resumedRun, err := svc.Approve(ctx, manager, pending[0].RequestID)
	if err != nil {
		t.Fatalf("Approve failed: %v", err)
	}

	if resumedRun == nil {
		t.Fatalf("expected non-nil resumed run")
	}
	if resumedRun.Status != workflow.WorkflowRunStatusSucceeded {
		t.Fatalf("expected resumed run status succeeded, got %s", resumedRun.Status)
	}

	// 3. Acceptance Target 3: Resume NEVER replays confirmed effect!
	// Assert Action 1 was NEVER re-dispatched during resume! Dispatched count MUST still be 1!
	action1DispatchesAfterResume := dispatcher.GetDispatchedCount("creativanta.commerce.v1.InventoryService/ReserveStock")
	if action1DispatchesAfterResume != 1 {
		t.Fatalf("ACCEPTANCE TARGET VIOLATION: Resume replayed confirmed effect! Action 1 dispatch count went from 1 to %d", action1DispatchesAfterResume)
	}

	// Assert Action 2 was dispatched exactly once
	action2Dispatches := dispatcher.GetDispatchedCount("creativanta.publish.v1.PublishService/Publish")
	if action2Dispatches != 1 {
		t.Fatalf("expected Action 2 dispatched exactly 1 time after resume, got %d", action2Dispatches)
	}

	// Verify step history shows Action 1 and Action 2 with their confirmed side effects
	_, steps, err := svc.GetRunDetail(ctx, editor, run.RunID)
	if err != nil {
		t.Fatalf("GetRunDetail failed: %v", err)
	}

	var action1Steps, action2Steps int
	for _, step := range steps {
		if step.NodeID == "node-act-1" && step.Status == "succeeded" {
			action1Steps++
			if len(step.SideEffectRefs) == 0 {
				t.Errorf("expected Action 1 step to retain side effect refs")
			}
		}
		if step.NodeID == "node-act-2" && step.Status == "succeeded" {
			action2Steps++
		}
	}
	if action1Steps != 1 {
		t.Errorf("expected exactly 1 succeeded step for Action 1, got %d", action1Steps)
	}
	if action2Steps != 1 {
		t.Errorf("expected exactly 1 succeeded step for Action 2, got %d", action2Steps)
	}
}

func TestP702_CapabilityAware_DegradedRoutingAndFallback(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	capProvider := workflow.NewDefaultCapabilityProvider()

	// Set TikTok capability to DEGRADED
	capProvider.SetStatus("tiktok", "degraded")

	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)
	svc.SetCapabilityProvider(capProvider)

	caller := workflow.CallerContext{
		UserID:        "usr-editor-1",
		WorkspaceID:   "ws-cap-1",
		WorkspaceRole: "editor",
	}
	manager := workflow.CallerContext{
		UserID:        "usr-mgr-1",
		WorkspaceID:   "ws-cap-1",
		WorkspaceRole: "manager",
	}

	// Scenario A: Graph with Fallback route configured
	graphWithFallback := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:        "trig-1",
				NodeType:      workflow.NodeTypeTrigger,
				Title:         "Trigger",
				TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual},
			},
			{
				NodeID:   "act-tiktok",
				NodeType: workflow.NodeTypeAction,
				Title:    "TikTok Direct Publish",
				ActionConfig: &workflow.ActionConfig{
					RPCName:   "creativanta.publish.v1.PublishService/Publish",
					InputJSON: `{"platform":"tiktok","title":"Summer Promo"}`,
				},
			},
			{
				NodeID:   "fall-route",
				NodeType: workflow.NodeTypeFallback,
				Title:    "Degraded Fallback: Draft Notification",
				FallbackConfig: &workflow.FallbackConfig{
					FallbackNodeID: "term-fallback",
					ReasonTemplate: "TikTok capability degraded; routed to fallback draft",
				},
			},
			{
				NodeID:         "term-success",
				NodeType:       workflow.NodeTypeTerminal,
				Title:          "Primary Done",
				TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
			},
			{
				NodeID:         "term-fallback",
				NodeType:       workflow.NodeTypeTerminal,
				Title:          "Fallback Done",
				TerminalConfig: &workflow.TerminalConfig{Outcome: "partially_succeeded"},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig-1", ToNodeID: "act-tiktok"},
			{FromNodeID: "act-tiktok", ToNodeID: "term-success", Branch: workflow.EdgeBranchSuccess},
			{FromNodeID: "act-tiktok", ToNodeID: "fall-route", Branch: workflow.EdgeBranchFailure},
			{FromNodeID: "fall-route", ToNodeID: "term-fallback"},
		},
	}

	wfA, err := svc.CreateWorkflow(ctx, caller, "Capability Fallback Flow", "Desc", "custom", *graphWithFallback.Nodes[0].TriggerConfig, graphWithFallback, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow A failed: %v", err)
	}
	_, _ = svc.ActivateWorkflow(ctx, manager, wfA.WorkflowID)

	runA, err := svc.RunWorkflow(ctx, caller, wfA.WorkflowID, map[string]any{"test": true})
	if err != nil {
		t.Fatalf("RunWorkflow A failed: %v", err)
	}

	// Action should NOT have been dispatched
	if dispatcher.GetDispatchedCount("creativanta.publish.v1.PublishService/Publish") != 0 {
		t.Fatalf("RULE-M20-002 VIOLATION: Degraded action was dispatched!")
	}

	// Run should complete on fallback path with partially_succeeded
	if runA.Status != workflow.WorkflowRunStatusPartiallySucceeded {
		t.Fatalf("expected run status partially_succeeded, got %s", runA.Status)
	}

	// Scenario B: Graph WITHOUT fallback route -> MUST halt with user-facing explanation (RULE-M20-003, AC-M20-003)
	graphNoFallback := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:        "trig-2",
				NodeType:      workflow.NodeTypeTrigger,
				Title:         "Trigger",
				TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual},
			},
			{
				NodeID:   "act-tiktok-nofallback",
				NodeType: workflow.NodeTypeAction,
				Title:    "TikTok Direct Publish No Fallback",
				ActionConfig: &workflow.ActionConfig{
					RPCName:   "creativanta.publish.v1.PublishService/Publish",
					InputJSON: `{"platform":"tiktok","title":"Summer Promo"}`,
				},
			},
			{
				NodeID:         "term-done",
				NodeType:       workflow.NodeTypeTerminal,
				Title:          "Done",
				TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig-2", ToNodeID: "act-tiktok-nofallback"},
			{FromNodeID: "act-tiktok-nofallback", ToNodeID: "term-done"},
		},
	}

	wfB, _ := svc.CreateWorkflow(ctx, caller, "Capability No Fallback Flow", "Desc", "custom", *graphNoFallback.Nodes[0].TriggerConfig, graphNoFallback, nil)
	_, _ = svc.ActivateWorkflow(ctx, manager, wfB.WorkflowID)

	runB, err := svc.RunWorkflow(ctx, caller, wfB.WorkflowID, map[string]any{"test": true})
	if err != nil {
		t.Fatalf("RunWorkflow B failed: %v", err)
	}

	// Must have entered failed status with diagnostics
	if runB.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("expected failed status without fallback, got %s", runB.Status)
	}

	userFacingExpl, _ := runB.ResultSummary["user_facing_explanation"].(string)
	if !strings.Contains(userFacingExpl, "tiktok") && !strings.Contains(userFacingExpl, "issues") {
		t.Errorf("expected user-facing explanation mentioning platform issues, got: %s", userFacingExpl)
	}

	// Dead letter item must exist
	dlqItems, totalDLQ, err := svc.ListDLQ(ctx, caller, "pending", 10, 0)
	if err != nil || totalDLQ == 0 {
		t.Fatalf("expected DLQ item created for failed run, total: %d (err: %v)", totalDLQ, err)
	}
	if dlqItems[0].OriginalMessageID != runB.RunID {
		t.Errorf("expected DLQ original_message_id %s, got %s", runB.RunID, dlqItems[0].OriginalMessageID)
	}
}

func TestP702_Approval_ExpiryAutoDenyAndDiagnostics(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)

	caller := workflow.CallerContext{
		UserID:        "usr-editor-1",
		WorkspaceID:   "ws-exp-1",
		WorkspaceRole: "editor",
	}
	manager := workflow.CallerContext{
		UserID:        "usr-mgr-1",
		WorkspaceID:   "ws-exp-1",
		WorkspaceRole: "manager",
	}

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:        "node-trig",
				NodeType:      workflow.NodeTypeTrigger,
				Title:         "Trigger",
				TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual},
			},
			{
				NodeID:   "node-appr",
				NodeType: workflow.NodeTypeApproval,
				Title:    "Expiring Approval Gate",
				ApprovalConfig: &workflow.ApprovalConfig{
					ApproverIDs:              []string{manager.UserID},
					RequiredApprovals:        1,
					ExpiresAtDurationSeconds: 1, // 1 second expiry
				},
			},
			{
				NodeID:   "node-act",
				NodeType: workflow.NodeTypeAction,
				Title:    "Post-Approval Action",
				ActionConfig: &workflow.ActionConfig{
					RPCName:   "creativanta.commerce.v1.InventoryService/ReserveStock",
					InputJSON: `{"sku":"sku-exp"}`,
				},
			},
			{
				NodeID:         "node-term",
				NodeType:       workflow.NodeTypeTerminal,
				Title:          "Terminal",
				TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "node-trig", ToNodeID: "node-appr"},
			{FromNodeID: "node-appr", ToNodeID: "node-act", Branch: workflow.EdgeBranchSuccess},
			{FromNodeID: "node-act", ToNodeID: "node-term"},
		},
	}

	wf, _ := svc.CreateWorkflow(ctx, caller, "Expiring Approval Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

	run, _ := svc.RunWorkflow(ctx, caller, wf.WorkflowID, nil)
	if run.Status != workflow.WorkflowRunStatusWaitingApproval {
		t.Fatalf("expected waiting_approval, got %s", run.Status)
	}

	pending, _ := svc.ListPendingApprovals(ctx, manager)
	if len(pending) != 1 {
		t.Fatalf("expected 1 pending approval, got %d", len(pending))
	}

	// Simulate expiry by setting expires_at to the past
	pastTime := time.Now().UTC().Add(-10 * time.Minute)
	pending[0].ExpiresAt = &pastTime
	_ = store.UpdateApprovalRequest(ctx, &pending[0])

	// Evaluate expiry
	expiredList, err := svc.EvaluateApprovalExpiry(ctx, manager)
	if err != nil {
		t.Fatalf("EvaluateApprovalExpiry failed: %v", err)
	}
	if len(expiredList) != 1 {
		t.Fatalf("expected 1 expired approval, got %d", len(expiredList))
	}
	if expiredList[0].Status != "expired" {
		t.Fatalf("expected status 'expired', got %s", expiredList[0].Status)
	}

	// Verify run failed with user-facing diagnostics
	updatedRun, _ := store.GetWorkflowRun(ctx, caller.WorkspaceID, run.RunID)
	if updatedRun.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("expected run status failed after expiry, got %s", updatedRun.Status)
	}
	if updatedRun.ResultSummary["failure_type"] != "APPROVAL_EXPIRED" {
		t.Errorf("expected failure_type APPROVAL_EXPIRED, got %v", updatedRun.ResultSummary["failure_type"])
	}
}

func TestP702_DeadLetterQueue_FullLifecycle(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, nil)

	caller := workflow.CallerContext{
		UserID:        "usr-admin-1",
		WorkspaceID:   "ws-dlq-1",
		WorkspaceRole: "admin",
	}

	// 1. Push DLQ item
	dlqItem := &workflow.DLQItem{
		DLQID:             "dlq-test-1",
		QueueName:         "workflow_runs",
		OriginalMessageID: "run-failed-123",
		Payload: map[string]any{
			"param": "bad_input",
		},
		ErrorClass:          "ACTION_FAILED",
		ErrorMessage:        "Parameter validation failed on third-party webhook",
		LastErrorAt:         time.Now().UTC(),
		AttemptCount:        3,
		WorkspaceID:         caller.WorkspaceID,
		Status:              "pending",
		SuggestedRepairPath: "Provide sanitized param string.",
		CreatedAt:           time.Now().UTC(),
	}
	err := svc.DLQManager().PushToDLQ(ctx, dlqItem)
	if err != nil {
		t.Fatalf("PushToDLQ failed: %v", err)
	}

	// Mock workflow run for DLQ operations
	run := &workflow.WorkflowRun{
		RunID:        "run-failed-123",
		WorkspaceID:  caller.WorkspaceID,
		WorkflowID:   "wf-dummy-1",
		TriggerEvent: map[string]any{"param": "bad_input"},
		Status:       workflow.WorkflowRunStatusFailed,
		CreatedAt:    time.Now().UTC(),
		UpdatedAt:    time.Now().UTC(),
	}
	_ = store.CreateWorkflowRun(ctx, run)

	// 2. List DLQ
	items, total, err := svc.ListDLQ(ctx, caller, "pending", 10, 0)
	if err != nil || total != 1 {
		t.Fatalf("ListDLQ failed: total=%d, err=%v", total, err)
	}
	if items[0].DLQID != "dlq-test-1" {
		t.Errorf("expected dlq-test-1, got %s", items[0].DLQID)
	}

	// 3. Retry DLQ Item
	retriedRun, err := svc.RetryDLQItem(ctx, caller, "dlq-test-1")
	if err != nil {
		t.Fatalf("RetryDLQItem failed: %v", err)
	}
	if retriedRun.Status != workflow.WorkflowRunStatusQueued {
		t.Errorf("expected run queued after retry, got %s", retriedRun.Status)
	}
	updatedItem, _ := svc.GetDLQItem(ctx, caller, "dlq-test-1")
	if updatedItem.Status != "retrying" {
		t.Errorf("expected DLQ status retrying, got %s", updatedItem.Status)
	}

	// 4. Repair and Retry DLQ Item
	repairedRun, err := svc.RepairAndRetryDLQItem(ctx, caller, "dlq-test-1", map[string]any{"param": "good_input"})
	if err != nil {
		t.Fatalf("RepairAndRetryDLQItem failed: %v", err)
	}
	if repairedRun.TriggerEvent["param"] != "good_input" {
		t.Errorf("expected param good_input, got %v", repairedRun.TriggerEvent["param"])
	}
	resolvedItem, _ := svc.GetDLQItem(ctx, caller, "dlq-test-1")
	if resolvedItem.Status != "resolved" {
		t.Errorf("expected DLQ status resolved after repair, got %s", resolvedItem.Status)
	}

	// 5. Discard DLQ Item
	dlqItem2 := &workflow.DLQItem{
		DLQID:             "dlq-test-2",
		QueueName:         "workflow_runs",
		OriginalMessageID: "run-failed-456",
		WorkspaceID:       caller.WorkspaceID,
		Status:            "pending",
		CreatedAt:         time.Now().UTC(),
	}
	_ = svc.DLQManager().PushToDLQ(ctx, dlqItem2)

	discarded, err := svc.DiscardDLQItem(ctx, caller, "dlq-test-2", "Obsolete test error")
	if err != nil {
		t.Fatalf("DiscardDLQItem failed: %v", err)
	}
	if discarded.Status != "discarded" {
		t.Errorf("expected discarded status, got %s", discarded.Status)
	}
}

func TestP702_CascadeDepthLimit_EC_M20_001(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	svc := workflow.NewService(store, nil)

	caller := workflow.CallerContext{
		UserID:        "usr-editor-1",
		WorkspaceID:   "ws-casc-1",
		WorkspaceRole: "editor",
	}
	manager := workflow.CallerContext{
		UserID:        "usr-mgr-1",
		WorkspaceID:   "ws-casc-1",
		WorkspaceRole: "manager",
	}

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:        "trig-casc",
				NodeType:      workflow.NodeTypeTrigger,
				Title:         "Cascade Trigger",
				TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeEvent, EventType: "cascade.event"},
			},
			{
				NodeID:       "act-casc",
				NodeType:     workflow.NodeTypeAction,
				Title:        "Cascade Action",
				ActionConfig: &workflow.ActionConfig{RPCName: "creativanta.commerce.v1.InventoryService/ReserveStock", InputJSON: `{"sku":"sku-1"}`},
			},
			{
				NodeID:         "term-casc",
				NodeType:       workflow.NodeTypeTerminal,
				Title:          "Terminal",
				TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig-casc", ToNodeID: "act-casc"},
			{FromNodeID: "act-casc", ToNodeID: "term-casc"},
		},
	}

	wf, _ := svc.CreateWorkflow(ctx, caller, "Cascade Test Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if _, err := svc.ActivateWorkflow(ctx, manager, wf.WorkflowID); err != nil {
		t.Fatalf("ActivateWorkflow failed: %v", err)
	}

	// Trigger run with cascade_depth = 6 (> 5 default limit)
	run, err := svc.RunWorkflow(ctx, caller, wf.WorkflowID, map[string]any{"cascade_depth": 6})
	if err != nil {
		t.Fatalf("RunWorkflow failed: %v", err)
	}

	if run.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("expected run status failed when cascade depth > 5, got %s", run.Status)
	}
	if run.ResultSummary["failure_type"] != "CASCADE_DEPTH_EXCEEDED" {
		t.Errorf("expected failure_type CASCADE_DEPTH_EXCEEDED, got %v", run.ResultSummary["failure_type"])
	}
	userMsg, _ := run.ResultSummary["user_facing_explanation"].(string)
	if !strings.Contains(userMsg, "cascade depth limit") {
		t.Errorf("expected user explanation mentioning cascade depth, got: %s", userMsg)
	}
}

func TestP702_ConcurrentApprovalsAndResumeRace(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)

	caller := workflow.CallerContext{
		UserID:        "usr-editor-1",
		WorkspaceID:   "ws-conc-1",
		WorkspaceRole: "editor",
	}
	manager := workflow.CallerContext{
		UserID:        "usr-mgr-1",
		WorkspaceID:   "ws-conc-1",
		WorkspaceRole: "manager",
	}

	workers := 10
	var wg sync.WaitGroup

	for w := 0; w < workers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			graph := workflow.WorkflowGraph{
				SchemaVersion: 1,
				Nodes: []workflow.WorkflowNode{
					{
						NodeID:        "trig-c",
						NodeType:      workflow.NodeTypeTrigger,
						Title:         "Trig",
						TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual},
					},
					{
						NodeID:   "act-c1",
						NodeType: workflow.NodeTypeAction,
						Title:    "Act1",
						ActionConfig: &workflow.ActionConfig{
							RPCName:   "creativanta.commerce.v1.InventoryService/ReserveStock",
							InputJSON: fmt.Sprintf(`{"worker":%d}`, workerID),
						},
					},
					{
						NodeID:   "appr-c",
						NodeType: workflow.NodeTypeApproval,
						Title:    "Appr",
						ApprovalConfig: &workflow.ApprovalConfig{
							ApproverIDs:              []string{manager.UserID},
							RequiredApprovals:        1,
							ExpiresAtDurationSeconds: 3600,
						},
					},
					{
						NodeID:   "act-c2",
						NodeType: workflow.NodeTypeAction,
						Title:    "Act2",
						ActionConfig: &workflow.ActionConfig{
							RPCName:   "creativanta.publish.v1.PublishService/Publish",
							InputJSON: fmt.Sprintf(`{"worker":%d}`, workerID),
						},
					},
					{
						NodeID:         "term-c",
						NodeType:       workflow.NodeTypeTerminal,
						Title:          "Term",
						TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"},
					},
				},
				Edges: []workflow.WorkflowEdge{
					{FromNodeID: "trig-c", ToNodeID: "act-c1"},
					{FromNodeID: "act-c1", ToNodeID: "appr-c"},
					{FromNodeID: "appr-c", ToNodeID: "act-c2", Branch: workflow.EdgeBranchSuccess},
					{FromNodeID: "act-c2", ToNodeID: "term-c"},
				},
			}

			title := fmt.Sprintf("Concurrent Flow %d", workerID)
			wf, err := svc.CreateWorkflow(ctx, caller, title, "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
			if err != nil {
				t.Errorf("worker %d create failed: %v", workerID, err)
				return
			}
			_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

			run, err := svc.RunWorkflow(ctx, caller, wf.WorkflowID, map[string]any{"worker": workerID})
			if err != nil {
				t.Errorf("worker %d run failed: %v", workerID, err)
				return
			}
			if run.Status != workflow.WorkflowRunStatusWaitingApproval {
				t.Errorf("worker %d expected waiting_approval, got %s", workerID, run.Status)
				return
			}

			pending, err := svc.ApprovalManager().FindPendingApprovalsByRun(ctx, caller.WorkspaceID, run.RunID)
			if err != nil || len(pending) == 0 {
				t.Errorf("worker %d find pending failed: %v", workerID, err)
				return
			}

			_, _, err = svc.Approve(ctx, manager, pending[0].RequestID)
			if err != nil {
				t.Errorf("worker %d approve failed: %v", workerID, err)
				return
			}
		}(w)
	}

	wg.Wait()
}

// ============================================================================
// Remediation Regression Tests: AI-04, AI-09, AI-10, AI-11, AI-12 (R06, R07, R09)
// ============================================================================

func TestAI04_DefaultServiceFailsClosedWithoutActionDispatcher(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	// Default NewService must NOT wire NewMockActionDispatcher.
	svc := workflow.NewService(store, nil)

	owner := workflow.CallerContext{
		UserID:        "11111111-1111-4111-8111-111111111101",
		WorkspaceID:   "22222222-2222-4222-8222-222222222201",
		WorkspaceRole: "owner",
	}

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "creativanta.commerce.v1.InventoryService/ReserveStock", InputJSON: `{"sku":"sku-1"}`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act"},
			{FromNodeID: "act", ToNodeID: "term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, owner, "Unconfigured Dispatcher Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow: %v", err)
	}
	if _, err := svc.ActivateWorkflow(ctx, owner, wf.WorkflowID); err != nil {
		t.Fatalf("ActivateWorkflow: %v", err)
	}

	run, err := svc.RunWorkflow(ctx, owner, wf.WorkflowID, map[string]any{})
	if err != nil {
		t.Fatalf("RunWorkflow: %v", err)
	}
	if run.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("expected run status failed when dispatcher is unconfigured, got %s", run.Status)
	}
	if len(run.SideEffectsSummary) != 0 {
		t.Fatalf("expected 0 side effects when dispatcher is unconfigured, got %d", len(run.SideEffectsSummary))
	}
}

func TestAI09_LifecycleEnforcement_DelegatedRBAC_And_MandatoryApproval(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)

	wsID := "22222222-2222-4222-8222-222222222202"
	editor := workflow.CallerContext{UserID: "usr-editor", WorkspaceID: wsID, WorkspaceRole: "editor"}
	manager := workflow.CallerContext{UserID: "usr-manager", WorkspaceID: wsID, WorkspaceRole: "manager"}

	// 1. Draft and Paused workflows MUST NOT be runnable via RunWorkflow
	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "creativanta.commerce.v1.ProductService/DeleteProduct", InputJSON: `{"id":"prod-1"}`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act"},
			{FromNodeID: "act", ToNodeID: "term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, editor, "Delegated Check Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow: %v", err)
	}
	if _, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, nil); err == nil {
		t.Fatalf("expected RunWorkflow on draft workflow to fail with ErrInvalidWorkflowState")
	}

	_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)
	_, _ = svc.DeactivateWorkflow(ctx, manager, wf.WorkflowID)
	if _, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, nil); err == nil {
		t.Fatalf("expected RunWorkflow on paused workflow to fail with ErrInvalidWorkflowState")
	}

	// 2. Delegated RBAC permission check at action effect point:
	// Editor cannot execute DeleteProduct (requires product:delete, which is Admin/Owner only)
	_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)
	run, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, nil)
	if err != nil {
		t.Fatalf("RunWorkflow: %v", err)
	}
	if run.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("expected run to fail due to delegated permission denial, got %s", run.Status)
	}
	if run.ResultSummary["failure_type"] != "PERMISSION_DENIED" {
		t.Fatalf("expected failure_type PERMISSION_DENIED, got %v", run.ResultSummary["failure_type"])
	}
	if dispatcher.GetDispatchedCount("") != 0 {
		t.Fatalf("expected 0 dispatches on delegated permission denial, got %d", dispatcher.GetDispatchedCount(""))
	}

	// 3. Mandatory Approval check at action effect point for sensitive action without upstream Approval node
	capProvider := workflow.NewDefaultCapabilityProvider()
	capProvider.SetStatus("tiktok", "supported")
	svc.SetCapabilityProvider(capProvider)
	sensGraph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act_pub", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "creativanta.publish.v1.PublishService/Publish", InputJSON: `{"platform":"tiktok"}`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act_pub"},
			{FromNodeID: "act_pub", ToNodeID: "term"},
		},
	}
	sensWf, err := svc.CreateWorkflow(ctx, manager, "Unapproved Sensitive Flow", "Desc", "custom", *sensGraph.Nodes[0].TriggerConfig, sensGraph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow: %v", err)
	}
	_, _ = svc.ActivateWorkflow(ctx, manager, sensWf.WorkflowID)
	sensRun, err := svc.RunWorkflow(ctx, manager, sensWf.WorkflowID, nil)
	if err != nil {
		t.Fatalf("RunWorkflow: %v", err)
	}
	if sensRun.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("expected sensitive action without approval gate to fail closed, got %s", sensRun.Status)
	}
	if sensRun.ResultSummary["failure_type"] != "APPROVAL_REQUIRED" {
		t.Fatalf("expected failure_type APPROVAL_REQUIRED, got %v", sensRun.ResultSummary["failure_type"])
	}
	if dispatcher.GetDispatchedCount("creativanta.publish.v1.PublishService/Publish") != 0 {
		t.Fatalf("expected 0 dispatches for unapproved sensitive action")
	}
}

func TestAI11_ApproverAllowlist_Quorum_And_DuplicateVotePrevention(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	capProvider := workflow.NewDefaultCapabilityProvider()
	capProvider.SetStatus("tiktok", "supported")
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)
	svc.SetCapabilityProvider(capProvider)

	wsID := "22222222-2222-4222-8222-222222222203"
	editor := workflow.CallerContext{UserID: "usr-editor", WorkspaceID: wsID, WorkspaceRole: "editor"}
	mgr1 := workflow.CallerContext{UserID: "usr-mgr-1", WorkspaceID: wsID, WorkspaceRole: "manager"}
	mgr2 := workflow.CallerContext{UserID: "usr-mgr-2", WorkspaceID: wsID, WorkspaceRole: "manager"}
	mgrOutsider := workflow.CallerContext{UserID: "usr-mgr-outsider", WorkspaceID: wsID, WorkspaceRole: "manager"}
	store.SetMemberRole(wsID, editor.UserID, editor.WorkspaceRole, true)
	store.SetMemberRole(wsID, mgr1.UserID, mgr1.WorkspaceRole, true)
	store.SetMemberRole(wsID, mgr2.UserID, mgr2.WorkspaceRole, true)

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{
				NodeID:   "appr",
				NodeType: workflow.NodeTypeApproval,
				ApprovalConfig: &workflow.ApprovalConfig{
					ApproverIDs:              []string{mgr1.UserID, mgr2.UserID},
					RequiredApprovals:        2,
					ExpiresAtDurationSeconds: 3600,
				},
			},
			{
				NodeID:   "act_pub",
				NodeType: workflow.NodeTypeAction,
				ActionConfig: &workflow.ActionConfig{
					RPCName:   "creativanta.publish.v1.PublishService/Publish",
					InputJSON: `{"platform":"tiktok","title":"Quorum Approved"}`,
				},
			},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "appr"},
			{FromNodeID: "appr", ToNodeID: "act_pub", Branch: workflow.EdgeBranchSuccess},
			{FromNodeID: "act_pub", ToNodeID: "term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, editor, "Quorum Approval Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow: %v", err)
	}
	_, _ = svc.ActivateWorkflow(ctx, mgr1, wf.WorkflowID)

	run, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, nil)
	if err != nil {
		t.Fatalf("RunWorkflow: %v", err)
	}
	if run.Status != workflow.WorkflowRunStatusWaitingApproval {
		t.Fatalf("expected waiting_approval, got %s", run.Status)
	}

	pending, _ := svc.ListPendingApprovals(ctx, mgr1)
	if len(pending) != 1 {
		t.Fatalf("expected 1 pending approval, got %d", len(pending))
	}
	reqID := pending[0].RequestID

	// 1. Manager NOT in ApproverIDs must be rejected
	if _, _, err := svc.Approve(ctx, mgrOutsider, reqID); err == nil || !strings.Contains(err.Error(), "not in configured approver_ids") {
		t.Fatalf("expected outsider manager to be rejected with approver_ids error, got: %v", err)
	}

	// 2. First authorized approver (mgr1) votes -> 1 of 2 required approvals -> stays pending_approval, does NOT resume run!
	reqAfter1, resumedAfter1, err := svc.Approve(ctx, mgr1, reqID)
	if err != nil {
		t.Fatalf("mgr1 Approve failed: %v", err)
	}
	if reqAfter1.Status != "pending_approval" {
		t.Fatalf("expected status pending_approval after 1 of 2 votes, got %s", reqAfter1.Status)
	}
	if resumedAfter1 != nil {
		t.Fatalf("expected run NOT to resume after 1 of 2 votes")
	}
	if dispatcher.GetDispatchedCount("") != 0 {
		t.Fatalf("expected 0 dispatches before quorum is met")
	}

	// 3. Duplicate vote by mgr1 must be rejected!
	if _, _, err := svc.Approve(ctx, mgr1, reqID); err == nil || !strings.Contains(err.Error(), "already approved") {
		t.Fatalf("expected duplicate vote by mgr1 to be rejected, got: %v", err)
	}

	// 4. Second authorized approver (mgr2) votes -> 2 of 2 quorum met -> approved and run resumes to succeeded!
	reqAfter2, resumedAfter2, err := svc.Approve(ctx, mgr2, reqID)
	if err != nil {
		t.Fatalf("mgr2 Approve failed: %v", err)
	}
	if reqAfter2.Status != "approved" {
		t.Fatalf("expected status approved after quorum met, got %s", reqAfter2.Status)
	}
	if resumedAfter2 == nil || resumedAfter2.Status != workflow.WorkflowRunStatusSucceeded {
		t.Fatalf("expected resumed run succeeded after quorum met, got %+v", resumedAfter2)
	}
	if dispatcher.GetDispatchedCount("creativanta.publish.v1.PublishService/Publish") != 1 {
		t.Fatalf("expected exactly 1 dispatch after quorum met, got %d", dispatcher.GetDispatchedCount("creativanta.publish.v1.PublishService/Publish"))
	}
}

type failingStepStore struct {
	*workflow.MemoryStore
	failUpdateActionStep bool
}

func (f *failingStepStore) UpdateWorkflowRunStep(ctx context.Context, step *workflow.WorkflowRunStep) error {
	if f.failUpdateActionStep && step.NodeType == workflow.NodeTypeAction && step.Status == "succeeded" {
		return fmt.Errorf("simulated DB failure persisting post-dispatch step completion")
	}
	return f.MemoryStore.UpdateWorkflowRunStep(ctx, step)
}

func TestAI10_UncertainStepReconciliation_And_ConcurrentResumeFencing(t *testing.T) {
	ctx := context.Background()
	fStore := &failingStepStore{MemoryStore: workflow.NewMemoryStore(), failUpdateActionStep: true}
	dispatcher := workflow.NewMockActionDispatcher()
	svc := workflow.NewService(fStore, nil)
	svc.SetActionDispatcher(dispatcher)

	wsID := "22222222-2222-4222-8222-222222222204"
	manager := workflow.CallerContext{UserID: "usr-mgr-1", WorkspaceID: wsID, WorkspaceRole: "manager"}

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "creativanta.commerce.v1.InventoryService/ReserveStock", InputJSON: `{"sku":"sku-1"}`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act"},
			{FromNodeID: "act", ToNodeID: "term"},
		},
	}

	wf, _ := svc.CreateWorkflow(ctx, manager, "Uncertain Effect Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

	// 1. Run fails when UpdateWorkflowRunStep fails after dispatch
	_, err := svc.RunWorkflow(ctx, manager, wf.WorkflowID, nil)
	if err == nil || !strings.Contains(err.Error(), "persist post-dispatch succeeded step") {
		t.Fatalf("expected post-dispatch step persistence error to propagate, got: %v", err)
	}
	if dispatcher.GetDispatchedCount("") != 1 {
		t.Fatalf("expected 1 dispatch before store failure, got %d", dispatcher.GetDispatchedCount(""))
	}

	// Restore store health and attempt ResumeRun: because the action step was persisted as 'running' before dispatch,
	// ResumeRun MUST NOT re-dispatch the uncertain action; it must enter requires_manual_intervention!
	fStore.failUpdateActionStep = false
	runs, _, _ := svc.ListRuns(ctx, manager, wf.WorkflowID, "", 10, 0)
	if len(runs) != 1 {
		t.Fatalf("expected 1 run in store, got %d", len(runs))
	}
	resumed, resumeErr := svc.ResumeRun(ctx, manager, runs[0].RunID, &workflow.ResumeSignal{SignalType: "manual_resume"})
	if resumeErr == nil || !strings.Contains(resumeErr.Error(), "uncertain running state") {
		t.Fatalf("expected ErrUncertainStepEffect on resuming interrupted running step, got: %v", resumeErr)
	}
	if resumed == nil || resumed.Status != workflow.WorkflowRunStatusRequiresManualIntervention {
		t.Fatalf("expected run status requires_manual_intervention, got %+v", resumed)
	}
	if dispatcher.GetDispatchedCount("") != 1 {
		t.Fatalf("expected uncertain step NOT to be re-dispatched! Dispatch count=%d", dispatcher.GetDispatchedCount(""))
	}
}

type mockTx struct {
	mu          *sync.Mutex
	queries     *[]string
	tenantIDSet string
	userIDSet   string
}

func (m *mockTx) Begin(ctx context.Context) (pgx.Tx, error) { return m, nil }
func (m *mockTx) Commit(ctx context.Context) error          { return nil }
func (m *mockTx) Rollback(ctx context.Context) error        { return nil }
func (m *mockTx) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	return 0, nil
}
func (m *mockTx) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults { return nil }
func (m *mockTx) LargeObjects() pgx.LargeObjects                               { return pgx.LargeObjects{} }
func (m *mockTx) Prepare(ctx context.Context, name, sql string) (*pgconn.StatementDescription, error) {
	return nil, nil
}
func (m *mockTx) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	m.mu.Lock()
	*m.queries = append(*m.queries, strings.TrimSpace(sql))
	m.mu.Unlock()
	return pgconn.NewCommandTag("INSERT 0 1"), nil
}
func (m *mockTx) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	return nil, nil
}
func (m *mockTx) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row {
	m.mu.Lock()
	*m.queries = append(*m.queries, strings.TrimSpace(sql))
	if strings.Contains(sql, "set_config('app.current_tenant_id'") && len(args) >= 2 {
		m.tenantIDSet, _ = args[0].(string)
		m.userIDSet, _ = args[1].(string)
	}
	m.mu.Unlock()
	return &mockRow{tenantID: m.tenantIDSet, userID: m.userIDSet}
}
func (m *mockTx) Conn() *pgx.Conn { return nil }

type mockRow struct {
	tenantID string
	userID   string
}

func (r *mockRow) Scan(dest ...any) error {
	if len(dest) == 2 {
		if p0, ok := dest[0].(*string); ok {
			*p0 = r.tenantID
		}
		if p1, ok := dest[1].(*string); ok {
			*p1 = r.userID
		}
	}
	return nil
}

type mockBeginner struct {
	mu      sync.Mutex
	queries []string
	lastTx  *mockTx
}

func (b *mockBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	b.mu.Lock()
	defer b.mu.Unlock()
	tx := &mockTx{mu: &b.mu, queries: &b.queries}
	b.lastTx = tx
	return tx, nil
}

func TestAI12_PostgresStore_UsesTenantDBWithTxScope(t *testing.T) {
	ctx := context.Background()
	beginner := &mockBeginner{}
	pgStore := workflow.NewPostgresStoreWithBeginner(beginner)

	validWorkspaceID := "11111111-1111-4111-8111-111111111111"
	validUserID := "22222222-2222-4222-8222-222222222222"

	// 1. Invalid / non-UUID workspaceID must fail closed via tenantdb.WithTx validation
	err := pgStore.CreateWorkflow(ctx, &workflow.Workflow{
		WorkflowID:  "33333333-3333-4333-8333-333333333333",
		WorkspaceID: "not-a-valid-uuid",
		Title:       "Bad Tenant",
	})
	if err == nil || !strings.Contains(err.Error(), tenantdb.ErrInvalidTenantScope.Error()) {
		t.Fatalf("expected ErrInvalidTenantScope for invalid workspace_id, got: %v", err)
	}

	// 2. Valid workspaceID executes inside tenantdb.WithTx with set_config('app.current_tenant_id', ...) first
	err = pgStore.CreateWorkflow(ctx, &workflow.Workflow{
		WorkflowID:  "33333333-3333-4333-8333-333333333333",
		WorkspaceID: validWorkspaceID,
		CreatedBy:   validUserID,
		Title:       "RLS Scoped Workflow",
		Status:      workflow.WorkflowStatusDraft,
		Version:     1,
	})
	if err != nil {
		t.Fatalf("CreateWorkflow with valid tenant scope failed: %v", err)
	}
	if len(beginner.queries) < 2 {
		t.Fatalf("expected set_config query followed by INSERT query, got %d queries", len(beginner.queries))
	}
	if !strings.Contains(beginner.queries[0], "set_config('app.current_tenant_id'") {
		t.Fatalf("expected first query in transaction to be set_config, got: %s", beginner.queries[0])
	}
	if !strings.Contains(beginner.queries[1], "INSERT INTO workflows") {
		t.Fatalf("expected second query in transaction to be INSERT INTO workflows, got: %s", beginner.queries[1])
	}
	if beginner.lastTx.tenantIDSet != validWorkspaceID || beginner.lastTx.userIDSet != validUserID {
		t.Fatalf("expected tenant=%s user=%s set in tx, got tenant=%s user=%s",
			validWorkspaceID, validUserID, beginner.lastTx.tenantIDSet, beginner.lastTx.userIDSet)
	}
}

func TestR4_Workflow_UncertainDispatchNeverRoutesToFallbackOrAllowsBlindRetry(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	// Configure primary action to return an ambiguous timeout error after dispatch
	primaryRPC := "creativanta.commerce.v1.InventoryService/ReserveStock"
	fallbackRPC := "creativanta.engagement.v1.ThreadService/Reply"
	dispatcher.SetError(primaryRPC, context.DeadlineExceeded)

	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)

	wsID := "22222222-2222-4222-8222-222222222291"
	manager := workflow.CallerContext{UserID: "usr-mgr-r4", WorkspaceID: wsID, WorkspaceRole: "manager"}

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act_primary", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: primaryRPC, InputJSON: `{"sku":"sku-99"}`}},
			{NodeID: "act_fallback", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: fallbackRPC, InputJSON: `{"message":"fallback"}`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act_primary"},
			{FromNodeID: "act_primary", ToNodeID: "term", Branch: workflow.EdgeBranchSuccess},
			{FromNodeID: "act_primary", ToNodeID: "act_fallback", Branch: workflow.EdgeBranchFailure},
			{FromNodeID: "act_fallback", ToNodeID: "term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, manager, "Ambiguous Dispatch Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow: %v", err)
	}
	_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

	// 1. RunWorkflow encounters context.DeadlineExceeded on act_primary:
	// MUST return ErrUncertainStepEffect, transition run to RequiresManualIntervention, and MUST NOT execute act_fallback!
	run, err := svc.RunWorkflow(ctx, manager, wf.WorkflowID, nil)
	if !errors.Is(err, workflow.ErrUncertainStepEffect) {
		t.Fatalf("expected ErrUncertainStepEffect on ambiguous dispatch timeout, got: %v", err)
	}
	if run == nil || run.Status != workflow.WorkflowRunStatusRequiresManualIntervention {
		t.Fatalf("expected run status RequiresManualIntervention, got %+v", run)
	}
	if dispatcher.GetDispatchedCount(fallbackRPC) != 0 {
		t.Fatalf("fallback action must NEVER execute when primary dispatch outcome is uncertain! got %d dispatches", dispatcher.GetDispatchedCount(fallbackRPC))
	}

	// 2. RetryRun while step is still in uncertain 'running' state MUST fail closed with ErrUncertainStepEffect!
	dispatcher.SetError(primaryRPC, nil) // even if primary would succeed now, blind retry is forbidden
	_, retryErr := svc.RetryRun(ctx, manager, run.RunID, "blind retry without reconciliation")
	if !errors.Is(retryErr, workflow.ErrUncertainStepEffect) {
		t.Fatalf("expected RetryRun to be blocked by ErrUncertainStepEffect, got: %v", retryErr)
	}
	if dispatcher.GetDispatchedCount(primaryRPC) != 0 {
		t.Fatalf("expected 0 successful dispatches on blocked retry, got %d", dispatcher.GetDispatchedCount(primaryRPC))
	}
}

func TestR4_Workflow_CanonicalRPCPermissionAndSensitiveActionEnforcement(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)

	wsID := "22222222-2222-4222-8222-222222222292"
	editor := workflow.CallerContext{UserID: "usr-ed-r4", WorkspaceID: wsID, WorkspaceRole: "editor"}
	manager := workflow.CallerContext{UserID: "usr-mgr-r4", WorkspaceID: wsID, WorkspaceRole: "manager"}
	owner := workflow.CallerContext{UserID: "usr-own-r4", WorkspaceID: wsID, WorkspaceRole: "owner"}

	// 1. Canonical RPCs that previously bypassed substring matching (OfferService/Activate, OfferService/UpdatePrice,
	// RefundService/Approve, ReconciliationService/Override, OrderService/Cancel, ProductService/DeleteProduct)
	// MUST be detected as Sensitive and enforce their exact RBAC permission!
	sensitiveRPCs := []struct {
		rpc          string
		expectedPerm string
	}{
		{"creativanta.commerce.v1.OfferService/Activate", "offer:activate"},
		{"creativanta.commerce.v1.OfferService/UpdatePrice", "offer:price_change"},
		{"creativanta.commerce.v1.RefundService/Approve", "refund:manage"},
		{"creativanta.commerce.v1.ReconciliationService/Override", "reconciliation:override"},
		{"creativanta.commerce.v1.OrderService/Cancel", "order:manage"},
		{"creativanta.commerce.v1.ProductService/DeleteProduct", "product:delete"},
	}

	pe := workflow.NewPreflightEngine(nil)
	for _, tc := range sensitiveRPCs {
		if !workflow.IsSensitiveAction(tc.rpc) {
			t.Fatalf("expected IsSensitiveAction(%q) == true", tc.rpc)
		}
		g := workflow.WorkflowGraph{
			SchemaVersion: 1,
			Nodes: []workflow.WorkflowNode{
				{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
				{NodeID: "act", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: tc.rpc, InputJSON: `{"id":"1"}`}},
				{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
			},
			Edges: []workflow.WorkflowEdge{
				{FromNodeID: "trig", ToNodeID: "act"},
				{FromNodeID: "act", ToNodeID: "term"},
			},
		}
		rep, err := pe.PreflightWorkflow(ctx, wsID, &g)
		if err != nil {
			t.Fatalf("PreflightWorkflow(%s): %v", tc.rpc, err)
		}
		if !rep.RequiresApproval || len(rep.Actions) != 1 || rep.Actions[0].RequiredPermission != tc.expectedPerm {
			t.Fatalf("expected preflight for %s to require approval and permission %q, got %+v", tc.rpc, tc.expectedPerm, rep)
		}

		// Editor attempting to execute Manager+/Admin+ action must fail with PERMISSION_DENIED
		wf, _ := svc.CreateWorkflow(ctx, editor, "Flow "+tc.rpc, "Desc", "custom", *g.Nodes[0].TriggerConfig, g, nil)
		_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)
		runEd, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, nil)
		if err != nil {
			t.Fatalf("RunWorkflow editor (%s): %v", tc.rpc, err)
		}
		if runEd.Status != workflow.WorkflowRunStatusFailed || runEd.ResultSummary["failure_type"] != "PERMISSION_DENIED" {
			t.Fatalf("expected editor to be denied %s with PERMISSION_DENIED, got status=%s summary=%+v", tc.rpc, runEd.Status, runEd.ResultSummary)
		}

		// Owner attempting to execute sensitive action WITHOUT upstream Approval node must fail with APPROVAL_REQUIRED
		runOwn, err := svc.RunWorkflow(ctx, owner, wf.WorkflowID, nil)
		if err != nil {
			t.Fatalf("RunWorkflow owner (%s): %v", tc.rpc, err)
		}
		if runOwn.Status != workflow.WorkflowRunStatusFailed || runOwn.ResultSummary["failure_type"] != "APPROVAL_REQUIRED" {
			t.Fatalf("expected unapproved sensitive RPC %s to fail with APPROVAL_REQUIRED, got status=%s summary=%+v", tc.rpc, runOwn.Status, runOwn.ResultSummary)
		}
	}

	// 2. Unknown / unregistered RPC must fail closed (never default to workflow:edit!)
	unknownGraph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: "creativanta.unknown.v1.SecretService/BypassAll", InputJSON: `{}`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act"},
			{FromNodeID: "act", ToNodeID: "term"},
		},
	}
	repUnknown, err := pe.PreflightWorkflow(ctx, wsID, &unknownGraph)
	if err != nil {
		t.Fatalf("PreflightWorkflow unknown RPC: %v", err)
	}
	if repUnknown.Valid {
		t.Fatalf("expected PreflightWorkflow to mark unregistered RPC as invalid!")
	}
	wfUnknown, _ := svc.CreateWorkflow(ctx, owner, "Unknown RPC Flow", "Desc", "custom", *unknownGraph.Nodes[0].TriggerConfig, unknownGraph, nil)
	_, _ = svc.ActivateWorkflow(ctx, owner, wfUnknown.WorkflowID)
	runUnknown, err := svc.RunWorkflow(ctx, owner, wfUnknown.WorkflowID, nil)
	if err != nil {
		t.Fatalf("RunWorkflow unknown RPC: %v", err)
	}
	if runUnknown.Status != workflow.WorkflowRunStatusFailed || runUnknown.ResultSummary["failure_type"] != "PERMISSION_DENIED" {
		t.Fatalf("expected unregistered RPC to fail closed with PERMISSION_DENIED even for owner, got status=%s summary=%+v", runUnknown.Status, runUnknown.ResultSummary)
	}
}

func TestS5_F10_SkipStepCannotClearUncertainEffectLockOrAllowDuplicateDispatch(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	primaryRPC := "creativanta.commerce.v1.InventoryService/ReserveStock"
	dispatcher.SetError(primaryRPC, context.DeadlineExceeded)

	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)

	wsID := "22222222-2222-4222-8222-222222222295"
	manager := workflow.CallerContext{UserID: "usr-mgr-f10", WorkspaceID: wsID, WorkspaceRole: "manager"}

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{NodeID: "act_uncertain", NodeType: workflow.NodeTypeAction, ActionConfig: &workflow.ActionConfig{RPCName: primaryRPC, InputJSON: `{"sku":"sku-f10"}`}},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "act_uncertain"},
			{FromNodeID: "act_uncertain", ToNodeID: "term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, manager, "F10 SkipStep Uncertain Lock Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow: %v", err)
	}
	_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

	// 1. First execution times out -> step is left in uncertain "running" state, run is in RequiresManualIntervention
	run, err := svc.RunWorkflow(ctx, manager, wf.WorkflowID, nil)
	if !errors.Is(err, workflow.ErrUncertainStepEffect) {
		t.Fatalf("expected ErrUncertainStepEffect on timeout, got: %v", err)
	}
	if run == nil || run.Status != workflow.WorkflowRunStatusRequiresManualIntervention {
		t.Fatalf("expected run status RequiresManualIntervention, got %+v", run)
	}

	// 2. Attempting SkipStep on an uncertain/in-flight step MUST be rejected with ErrUncertainStepEffect!
	_, skipErr := svc.SkipStep(ctx, manager, run.RunID, "act_uncertain", "operator trying to skip uncertain step")
	if !errors.Is(skipErr, workflow.ErrUncertainStepEffect) {
		t.Fatalf("F10 VIOLATION: expected SkipStep on uncertain running step to be rejected with ErrUncertainStepEffect, got: %v", skipErr)
	}

	// 3. Even if provider recovers now, RetryRun MUST still be blocked and MUST NOT re-dispatch the external action!
	dispatcher.SetError(primaryRPC, nil)
	_, retryErr := svc.RetryRun(ctx, manager, run.RunID, "retry after attempted skip")
	if !errors.Is(retryErr, workflow.ErrUncertainStepEffect) {
		t.Fatalf("F10 VIOLATION: expected RetryRun after rejected SkipStep to fail with ErrUncertainStepEffect, got: %v", retryErr)
	}
	if dispatcher.GetDispatchedCount(primaryRPC) != 0 {
		t.Fatalf("F10 CRITICAL VIOLATION: SkipStep + RetryRun bypassed uncertain-effect lock and re-dispatched external action! count=%d",
			dispatcher.GetDispatchedCount(primaryRPC))
	}
}

func TestS5_F11_WorkflowRechecksInitiatorLiveRoleAndMembershipOnResumeAndApproval(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)

	wsID := "22222222-2222-4222-8222-222222222296"
	admin := workflow.CallerContext{UserID: "usr-admin-f11", WorkspaceID: wsID, WorkspaceRole: "admin"}
	manager := workflow.CallerContext{UserID: "usr-mgr-f11", WorkspaceID: wsID, WorkspaceRole: "manager"}
	deleteRPC := "creativanta.commerce.v1.ProductService/DeleteProduct"

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{
				NodeID:   "appr",
				NodeType: workflow.NodeTypeApproval,
				ApprovalConfig: &workflow.ApprovalConfig{
					ApproverIDs:              []string{manager.UserID},
					RequiredApprovals:        1,
					ExpiresAtDurationSeconds: 3600,
				},
			},
			{
				NodeID:   "act_del",
				NodeType: workflow.NodeTypeAction,
				ActionConfig: &workflow.ActionConfig{
					RPCName:   deleteRPC,
					InputJSON: `{"id":"prod-f11"}`,
				},
			},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "appr"},
			{FromNodeID: "appr", ToNodeID: "act_del", Branch: workflow.EdgeBranchSuccess},
			{FromNodeID: "act_del", ToNodeID: "term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, admin, "F11 Initiator Downgrade Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow: %v", err)
	}
	_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

	// Case 1: Admin launches workflow -> pauses at approval -> Admin is downgraded to Editor before Manager approves
	run1, err := svc.RunWorkflow(ctx, admin, wf.WorkflowID, nil)
	if err != nil {
		t.Fatalf("RunWorkflow 1: %v", err)
	}
	if run1.Status != workflow.WorkflowRunStatusWaitingApproval {
		t.Fatalf("expected waiting_approval, got %s", run1.Status)
	}

	// Downgrade initiator from Admin to Editor while run is paused
	svc.SetMemberRole(wsID, admin.UserID, "editor", true)

	pending1, _ := svc.ApprovalManager().FindPendingApprovalsByRun(ctx, wsID, run1.RunID)
	if len(pending1) != 1 {
		t.Fatalf("expected 1 pending approval for run1, got %d", len(pending1))
	}
	_, resumed1, err := svc.Approve(ctx, manager, pending1[0].RequestID)
	if err != nil {
		t.Fatalf("Approve run1: %v", err)
	}
	if resumed1 == nil || resumed1.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("F11 VIOLATION: expected resumed run to fail after initiator role downgrade to editor, got %+v", resumed1)
	}
	if resumed1.ResultSummary["failure_type"] != "PERMISSION_DENIED" {
		t.Fatalf("expected failure_type PERMISSION_DENIED after downgrade, got %+v", resumed1.ResultSummary)
	}
	if dispatcher.GetDispatchedCount(deleteRPC) != 0 {
		t.Fatalf("F11 CRITICAL VIOLATION: DeleteProduct executed despite initiator downgrade from admin to editor! count=%d",
			dispatcher.GetDispatchedCount(deleteRPC))
	}

	// Case 2: Restore Admin, launch run2 -> pause at approval -> revoke Admin's workspace membership -> Manager approves
	svc.SetMemberRole(wsID, admin.UserID, "admin", true)
	run2, err := svc.RunWorkflow(ctx, admin, wf.WorkflowID, nil)
	if err != nil {
		t.Fatalf("RunWorkflow 2: %v", err)
	}
	svc.RevokeMemberAccess(wsID, admin.UserID)

	pending2, _ := svc.ApprovalManager().FindPendingApprovalsByRun(ctx, wsID, run2.RunID)
	if len(pending2) != 1 {
		t.Fatalf("expected 1 pending approval for run2, got %d", len(pending2))
	}
	_, resumed2, err := svc.Approve(ctx, manager, pending2[0].RequestID)
	if err != nil {
		t.Fatalf("Approve run2: %v", err)
	}
	if resumed2 == nil || resumed2.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("F11 VIOLATION: expected resumed run to fail after initiator access revocation, got %+v", resumed2)
	}
	if resumed2.ResultSummary["failure_type"] != "PERMISSION_DENIED" {
		t.Fatalf("expected failure_type PERMISSION_DENIED after revocation, got %+v", resumed2.ResultSummary)
	}
	if dispatcher.GetDispatchedCount(deleteRPC) != 0 {
		t.Fatalf("F11 CRITICAL VIOLATION: DeleteProduct executed after initiator tenant access was revoked! count=%d",
			dispatcher.GetDispatchedCount(deleteRPC))
	}
}

func TestR3_WorkflowLiveMembership_FailsClosedWithoutResolverAndHonorsAuthoritativeStore(t *testing.T) {
	ctx := context.Background()
	deleteRPC := "creativanta.commerce.v1.ProductService/DeleteProduct"

	buildPrivilegedApprovalGraph := func(approverID string) workflow.WorkflowGraph {
		return workflow.WorkflowGraph{
			SchemaVersion: 1,
			Nodes: []workflow.WorkflowNode{
				{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
				{
					NodeID:   "appr",
					NodeType: workflow.NodeTypeApproval,
					ApprovalConfig: &workflow.ApprovalConfig{
						ApproverIDs:              []string{approverID},
						RequiredApprovals:        1,
						ExpiresAtDurationSeconds: 3600,
					},
				},
				{
					NodeID:   "act_del",
					NodeType: workflow.NodeTypeAction,
					ActionConfig: &workflow.ActionConfig{
						RPCName:   deleteRPC,
						InputJSON: `{"id":"prod-r3-1"}`,
					},
				},
				{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
			},
			Edges: []workflow.WorkflowEdge{
				{FromNodeID: "trig", ToNodeID: "appr"},
				{FromNodeID: "appr", ToNodeID: "act_del", Branch: workflow.EdgeBranchSuccess},
				{FromNodeID: "act_del", ToNodeID: "term"},
			},
		}
	}

	// Subtest 1: No authoritative membership resolver or store record -> cross-actor Approve MUST fail closed (no fallback to launch/observed role).
	{
		store := workflow.NewMemoryStore()
		dispatcher := workflow.NewMockActionDispatcher()
		svc := workflow.NewService(store, nil)
		svc.SetActionDispatcher(dispatcher)

		wsID := "22222222-2222-4222-8222-222222222301"
		admin := workflow.CallerContext{UserID: "usr-admin-r3-a", WorkspaceID: wsID, WorkspaceRole: "admin"}
		manager := workflow.CallerContext{UserID: "usr-mgr-r3-a", WorkspaceID: wsID, WorkspaceRole: "manager"}

		graph := buildPrivilegedApprovalGraph(manager.UserID)
		wf, err := svc.CreateWorkflow(ctx, admin, "R3 Unverified Membership Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
		if err != nil {
			t.Fatalf("CreateWorkflow: %v", err)
		}
		_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

		run, err := svc.RunWorkflow(ctx, admin, wf.WorkflowID, nil)
		if err != nil || run.Status != workflow.WorkflowRunStatusWaitingApproval {
			t.Fatalf("expected waiting_approval, got run=%+v err=%v", run, err)
		}

		pending, _ := svc.ApprovalManager().FindPendingApprovalsByRun(ctx, wsID, run.RunID)
		if len(pending) != 1 {
			t.Fatalf("expected 1 pending approval, got %d", len(pending))
		}
		_, resumed, err := svc.Approve(ctx, manager, pending[0].RequestID)
		if err != nil {
			t.Fatalf("Approve: %v", err)
		}
		if resumed == nil || resumed.Status != workflow.WorkflowRunStatusFailed || resumed.ResultSummary["failure_type"] != "PERMISSION_DENIED" {
			t.Fatalf("R3 VIOLATION: expected cross-actor Approve without authoritative membership to fail closed with PERMISSION_DENIED, got %+v", resumed)
		}
		if dispatcher.GetDispatchedCount(deleteRPC) != 0 {
			t.Fatalf("R3 VIOLATION: privileged action dispatched without authoritative membership verification!")
		}
	}

	// Subtest 2: Authoritative store membership changed directly (without calling svc.SetMemberRole) -> Approve MUST block privileged action.
	{
		store := workflow.NewMemoryStore()
		dispatcher := workflow.NewMockActionDispatcher()
		svc := workflow.NewService(store, nil)
		svc.SetActionDispatcher(dispatcher)

		wsID := "22222222-2222-4222-8222-222222222302"
		admin := workflow.CallerContext{UserID: "usr-admin-r3-b", WorkspaceID: wsID, WorkspaceRole: "admin"}
		manager := workflow.CallerContext{UserID: "usr-mgr-r3-b", WorkspaceID: wsID, WorkspaceRole: "manager"}

		// Seed authoritative membership in store
		store.SetMemberRole(wsID, admin.UserID, "admin", true)
		store.SetMemberRole(wsID, manager.UserID, "manager", true)

		graph := buildPrivilegedApprovalGraph(manager.UserID)
		wf, err := svc.CreateWorkflow(ctx, admin, "R3 Store Mutation Flow", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
		if err != nil {
			t.Fatalf("CreateWorkflow: %v", err)
		}
		_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

		run1, err := svc.RunWorkflow(ctx, admin, wf.WorkflowID, nil)
		if err != nil || run1.Status != workflow.WorkflowRunStatusWaitingApproval {
			t.Fatalf("expected waiting_approval, got run=%+v err=%v", run1, err)
		}

		// Mutate membership in the authoritative store directly (do NOT call svc.SetMemberRole)
		store.SetMemberRole(wsID, admin.UserID, "editor", true)

		pending1, _ := svc.ApprovalManager().FindPendingApprovalsByRun(ctx, wsID, run1.RunID)
		_, resumed1, err := svc.Approve(ctx, manager, pending1[0].RequestID)
		if err != nil {
			t.Fatalf("Approve run1: %v", err)
		}
		if resumed1 == nil || resumed1.Status != workflow.WorkflowRunStatusFailed || resumed1.ResultSummary["failure_type"] != "PERMISSION_DENIED" {
			t.Fatalf("R3 VIOLATION: expected store demotion (without svc.SetMemberRole) to block privileged action, got %+v", resumed1)
		}
		if dispatcher.GetDispatchedCount(deleteRPC) != 0 {
			t.Fatalf("R3 VIOLATION: privileged action dispatched after authoritative store demotion!")
		}
	}
}

func TestR5_ApprovalSingleUsePerActionNode_BlocksSecondIdenticalSensitiveAction(t *testing.T) {
	ctx := context.Background()
	store := workflow.NewMemoryStore()
	dispatcher := workflow.NewMockActionDispatcher()
	capProvider := workflow.NewDefaultCapabilityProvider()
	capProvider.SetStatus("tiktok", "supported")
	svc := workflow.NewService(store, nil)
	svc.SetActionDispatcher(dispatcher)
	svc.SetCapabilityProvider(capProvider)

	wsID := "22222222-2222-4222-8222-222222222505"
	editor := workflow.CallerContext{UserID: "usr-editor-r5", WorkspaceID: wsID, WorkspaceRole: "editor"}
	manager := workflow.CallerContext{UserID: "usr-mgr-r5", WorkspaceID: wsID, WorkspaceRole: "manager"}
	store.SetMemberRole(wsID, editor.UserID, "editor", true)
	store.SetMemberRole(wsID, manager.UserID, "manager", true)

	publishRPC := "creativanta.publish.v1.PublishService/Publish"
	sameInput := `{"platform":"tiktok","title":"Identical Sensitive Payload"}`

	// Graph: trig -> appr -> act_a -> act_b -> term
	// Both act_a and act_b invoke the exact same sensitive RPC with the exact same InputJSON,
	// but only act_a is gated by appr; act_b has no dedicated approval gate.
	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
			{
				NodeID:   "appr",
				NodeType: workflow.NodeTypeApproval,
				ApprovalConfig: &workflow.ApprovalConfig{
					ApproverIDs:              []string{manager.UserID},
					RequiredApprovals:        1,
					ExpiresAtDurationSeconds: 3600,
				},
			},
			{
				NodeID:   "act_a",
				NodeType: workflow.NodeTypeAction,
				ActionConfig: &workflow.ActionConfig{
					RPCName:   publishRPC,
					InputJSON: sameInput,
				},
			},
			{
				NodeID:   "act_b",
				NodeType: workflow.NodeTypeAction,
				ActionConfig: &workflow.ActionConfig{
					RPCName:   publishRPC,
					InputJSON: sameInput,
				},
			},
			{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trig", ToNodeID: "appr"},
			{FromNodeID: "appr", ToNodeID: "act_a", Branch: workflow.EdgeBranchSuccess},
			{FromNodeID: "act_a", ToNodeID: "act_b"},
			{FromNodeID: "act_b", ToNodeID: "term"},
		},
	}

	wf, err := svc.CreateWorkflow(ctx, editor, "R5 Single Approval Reuse Prevention", "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
	if err != nil {
		t.Fatalf("CreateWorkflow: %v", err)
	}
	_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

	run, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, nil)
	if err != nil || run.Status != workflow.WorkflowRunStatusWaitingApproval {
		t.Fatalf("expected waiting_approval at appr, got run=%+v err=%v", run, err)
	}

	pending, _ := svc.ApprovalManager().FindPendingApprovalsByRun(ctx, wsID, run.RunID)
	if len(pending) != 1 {
		t.Fatalf("expected 1 pending approval, got %d", len(pending))
	}

	_, resumed, err := svc.Approve(ctx, manager, pending[0].RequestID)
	if err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if resumed == nil || resumed.Status != workflow.WorkflowRunStatusFailed {
		t.Fatalf("R5 VIOLATION: expected run to fail at second unapproved sensitive action node act_b, got %+v", resumed)
	}
	if resumed.ResultSummary["failure_type"] != "APPROVAL_REQUIRED" {
		t.Fatalf("R5 VIOLATION: expected failure_type APPROVAL_REQUIRED on act_b, got %+v", resumed.ResultSummary)
	}
	if count := dispatcher.GetDispatchedCount(publishRPC); count != 1 {
		t.Fatalf("R5 CRITICAL VIOLATION: expected exactly 1 dispatch (for act_a only), got %d dispatches!", count)
	}

	// Verify that UndoApprove is rejected once the approval request has been consumed by act_a
	if _, undoErr := svc.UndoApprove(ctx, manager, pending[0].RequestID); !errors.Is(undoErr, workflow.ErrInvalidApprovalState) && !errors.Is(undoErr, workflow.ErrInvalidRunState) {
		t.Fatalf("R5 VIOLATION: expected UndoApprove on consumed approval request to fail, got: %v", undoErr)
	}
}

type staticCapabilityProvider struct {
	status string
	err    error
}

func (p *staticCapabilityProvider) GetPlatformCapability(_ context.Context, _, _, _ string) (string, error) {
	return p.status, p.err
}

func TestC2_WorkflowCapabilityFailClosed_BlocksNilDefaultErrorEmptyUnknownManualReadOnly(t *testing.T) {
	ctx := context.Background()
	publishRPC := "creativanta.publish.v1.PublishService/Publish"

	cases := []struct {
		name     string
		setupCap func(svc *workflow.Service)
	}{
		{
			name: "nil_provider",
			setupCap: func(svc *workflow.Service) {
				svc.SetCapabilityProvider(nil)
			},
		},
		{
			name: "default_unconfigured_provider",
			setupCap: func(svc *workflow.Service) {
				svc.SetCapabilityProvider(workflow.NewDefaultCapabilityProvider())
			},
		},
		{
			name: "lookup_error",
			setupCap: func(svc *workflow.Service) {
				svc.SetCapabilityProvider(&staticCapabilityProvider{status: "", err: errors.New("capability lookup failed")})
			},
		},
		{
			name: "empty_status",
			setupCap: func(svc *workflow.Service) {
				svc.SetCapabilityProvider(&staticCapabilityProvider{status: "", err: nil})
			},
		},
		{
			name: "unknown_status",
			setupCap: func(svc *workflow.Service) {
				svc.SetCapabilityProvider(&staticCapabilityProvider{status: "mystery_state", err: nil})
			},
		},
		{
			name: "manual_status",
			setupCap: func(svc *workflow.Service) {
				svc.SetCapabilityProvider(&staticCapabilityProvider{status: "manual", err: nil})
			},
		},
		{
			name: "read_only_status",
			setupCap: func(svc *workflow.Service) {
				svc.SetCapabilityProvider(&staticCapabilityProvider{status: "read_only", err: nil})
			},
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			store := workflow.NewMemoryStore()
			dispatcher := workflow.NewMockActionDispatcher()
			svc := workflow.NewService(store, nil)
			svc.SetActionDispatcher(dispatcher)
			tc.setupCap(svc)

			wsID := "22222222-2222-4222-8222-222222222902"
			editor := workflow.CallerContext{UserID: "usr-editor-c2", WorkspaceID: wsID, WorkspaceRole: "editor"}
			manager := workflow.CallerContext{UserID: "usr-mgr-c2", WorkspaceID: wsID, WorkspaceRole: "manager"}
			store.SetMemberRole(wsID, editor.UserID, "editor", true)
			store.SetMemberRole(wsID, manager.UserID, "manager", true)

			graph := workflow.WorkflowGraph{
				SchemaVersion: 1,
				Nodes: []workflow.WorkflowNode{
					{NodeID: "trig", NodeType: workflow.NodeTypeTrigger, TriggerConfig: &workflow.TriggerConfig{Type: workflow.TriggerTypeManual}},
					{
						NodeID:   "appr",
						NodeType: workflow.NodeTypeApproval,
						ApprovalConfig: &workflow.ApprovalConfig{
							ApproverIDs:              []string{manager.UserID},
							RequiredApprovals:        1,
							ExpiresAtDurationSeconds: 3600,
						},
					},
					{
						NodeID:   "act_pub",
						NodeType: workflow.NodeTypeAction,
						ActionConfig: &workflow.ActionConfig{
							RPCName:   publishRPC,
							InputJSON: `{"platform":"tiktok","account_id":"acc-tiktok-1","title":"C2 Publish"}`,
						},
					},
					{NodeID: "term", NodeType: workflow.NodeTypeTerminal, TerminalConfig: &workflow.TerminalConfig{Outcome: "succeeded"}},
				},
				Edges: []workflow.WorkflowEdge{
					{FromNodeID: "trig", ToNodeID: "appr"},
					{FromNodeID: "appr", ToNodeID: "act_pub", Branch: workflow.EdgeBranchSuccess},
					{FromNodeID: "act_pub", ToNodeID: "term"},
				},
			}

			// Also verify PreflightWorkflow reflects the same non-executable decision.
			pfRes, pfErr := svc.PreflightWorkflow(ctx, editor, "", &graph)
			if pfErr != nil {
				t.Fatalf("PreflightWorkflow returned unexpected error: %v", pfErr)
			}
			if len(pfRes.Actions) == 1 && (pfRes.Actions[0].CapabilityStatus == "supported" || pfRes.Actions[0].CapabilityStatus == "native") {
				t.Fatalf("C2 VIOLATION (%s): PreflightWorkflow reported executable CapabilityStatus=%q for non-executable capability", tc.name, pfRes.Actions[0].CapabilityStatus)
			}
			if len(pfRes.Warnings) == 0 {
				t.Fatalf("C2 VIOLATION (%s): expected PreflightWorkflow warning when non-executable capability action lacks fallback branch", tc.name)
			}

			wf, err := svc.CreateWorkflow(ctx, editor, "C2 Capability Flow "+tc.name, "Desc", "custom", *graph.Nodes[0].TriggerConfig, graph, nil)
			if err != nil {
				t.Fatalf("CreateWorkflow: %v", err)
			}
			_, _ = svc.ActivateWorkflow(ctx, manager, wf.WorkflowID)

			run, err := svc.RunWorkflow(ctx, editor, wf.WorkflowID, nil)
			if err != nil || run.Status != workflow.WorkflowRunStatusWaitingApproval {
				t.Fatalf("expected waiting_approval, got run=%+v err=%v", run, err)
			}

			pending, _ := svc.ApprovalManager().FindPendingApprovalsByRun(ctx, wsID, run.RunID)
			if len(pending) != 1 {
				t.Fatalf("expected 1 pending approval, got %d", len(pending))
			}

			_, resumed, err := svc.Approve(ctx, manager, pending[0].RequestID)
			if err != nil {
				t.Fatalf("Approve: %v", err)
			}
			if count := dispatcher.GetDispatchedCount(publishRPC); count != 0 {
				t.Fatalf("C2 VIOLATION (%s): expected 0 dispatches when capability is not verified executable, got %d!", tc.name, count)
			}
			if resumed == nil || resumed.Status != workflow.WorkflowRunStatusFailed {
				t.Fatalf("C2 VIOLATION (%s): expected resumed run to fail without fallback, got %+v", tc.name, resumed)
			}
		})
	}
}

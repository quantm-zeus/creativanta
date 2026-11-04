package workflow

import (
	"context"
	"fmt"
	"os"
	"strings"
)

// SimulationStepResult captures a simulated step outcome in dry run.
type SimulationStepResult struct {
	NodeID            string         `json:"node_id"`
	NodeType          NodeType       `json:"node_type"`
	Status            string         `json:"status"` // simulated_success, simulated_skipped, simulated_failure
	SimulatedOutput   map[string]any `json:"simulated_output,omitempty"`
	DiagnosticMessage string         `json:"diagnostic_message,omitempty"`
	EstimatedCredits  float64        `json:"estimated_credits"`
}

// SimulationReport summarizes the dry run results per RULE-M20-007.
type SimulationReport struct {
	Success               bool                   `json:"success"`
	StepResults           []SimulationStepResult `json:"step_results"`
	TotalEstimatedCredits float64                `json:"total_estimated_credits"`
	SimulationSummary     string                 `json:"simulation_summary"`
}

// WorkflowEngineAdapter defines the execution adapter abstraction.
// Creativanta natively ships with OwnedWorkflowEngine, ensuring zero dependency
// on proprietary enterprise embedding licenses.
type WorkflowEngineAdapter interface {
	EngineType() string
	IsEntitled(ctx context.Context, workspaceID string) (bool, error)
	RequiresLicense() bool
	SimulateWorkflow(ctx context.Context, graph *WorkflowGraph, sampleContext map[string]any) (*SimulationReport, error)
}

// ----------------------------------------------------------------------------
// OwnedWorkflowEngine (Native first-class engine, zero external license needed)
// ----------------------------------------------------------------------------

type OwnedWorkflowEngine struct{}

func NewOwnedWorkflowEngine() *OwnedWorkflowEngine {
	return &OwnedWorkflowEngine{}
}

var _ WorkflowEngineAdapter = (*OwnedWorkflowEngine)(nil)

func (e *OwnedWorkflowEngine) EngineType() string {
	return "owned"
}

// RequiresLicense indicates whether this engine needs external licensing.
func (e *OwnedWorkflowEngine) RequiresLicense() bool {
	return false
}

// IsEntitled is always true for the owned engine. No external license required!
func (e *OwnedWorkflowEngine) IsEntitled(ctx context.Context, workspaceID string) (bool, error) {
	return true, nil
}

// SimulateWorkflow executes dry run per RULE-M20-007.
// Guarantees NO business side effects: no outbound publish/payment/notification,
// no real credit debit, no domain events emitted, and no mutations.
func (e *OwnedWorkflowEngine) SimulateWorkflow(ctx context.Context, graph *WorkflowGraph, sampleContext map[string]any) (*SimulationReport, error) {
	if err := ValidateWorkflowGraph(graph); err != nil {
		return nil, fmt.Errorf("simulation validation failed: %w", err)
	}

	report := &SimulationReport{
		Success:     true,
		StepResults: make([]SimulationStepResult, 0, len(graph.Nodes)),
	}

	if sampleContext == nil {
		sampleContext = make(map[string]any)
	}

	// Adjacency map
	adj := make(map[string][]WorkflowEdge)
	for _, edge := range graph.Edges {
		adj[edge.FromNodeID] = append(adj[edge.FromNodeID], edge)
	}

	nodeMap := make(map[string]*WorkflowNode)
	var rootID string
	for i := range graph.Nodes {
		n := &graph.Nodes[i]
		nodeMap[n.NodeID] = n
		if n.NodeType == NodeTypeTrigger {
			rootID = n.NodeID
		}
	}

	// Traverse from root trigger
	currentContext := make(map[string]any)
	for k, v := range sampleContext {
		currentContext[k] = v
	}

	visited := make(map[string]bool)
	currID := rootID

	for currID != "" && !visited[currID] {
		visited[currID] = true
		node, ok := nodeMap[currID]
		if !ok {
			break
		}

		stepRes := SimulationStepResult{
			NodeID:   node.NodeID,
			NodeType: node.NodeType,
			Status:   "simulated_success",
		}

		var nextNodeID string

		switch node.NodeType {
		case NodeTypeTrigger:
			stepRes.DiagnosticMessage = fmt.Sprintf("Trigger %s matched sample context", node.NodeID)
			stepRes.SimulatedOutput = map[string]any{"trigger_fired": true, "context": currentContext}
			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeCondition:
			cfg := node.ConditionConfig
			if cfg == nil {
				cfg = parseConditionConfigFromMap(node.Config)
			}
			matched := evaluateSimulatedCondition(cfg, currentContext)
			stepRes.SimulatedOutput = map[string]any{"condition_matched": matched}
			stepRes.DiagnosticMessage = fmt.Sprintf("Condition evaluated: %v", matched)

			// Route based on true / false branch
			targetBranch := EdgeBranchFalse
			if matched {
				targetBranch = EdgeBranchTrue
			}
			for _, edge := range adj[node.NodeID] {
				if edge.Branch == targetBranch {
					nextNodeID = edge.ToNodeID
					break
				}
			}

		case NodeTypeTransform:
			cfg := node.TransformConfig
			if cfg == nil {
				cfg = parseTransformConfigFromMap(node.Config)
			}
			transformed := make(map[string]any)
			if cfg != nil {
				for _, m := range cfg.Mappings {
					if val, ok := currentContext[m.SourceField]; ok {
						transformed[m.TargetField] = val
					} else if m.DefaultValue != "" {
						transformed[m.TargetField] = m.DefaultValue
					}
				}
			}
			for k, v := range transformed {
				currentContext[k] = v
			}
			stepRes.SimulatedOutput = transformed
			stepRes.DiagnosticMessage = fmt.Sprintf("Transform mapped %d fields", len(transformed))
			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeAction:
			cfg := node.ActionConfig
			if cfg == nil {
				cfg = parseActionConfigFromMap(node.Config)
			}
			rpcName := "unknown"
			if cfg != nil {
				rpcName = cfg.RPCName
			}
			stepRes.EstimatedCredits = 2.0 // Typical estimated simulation cost
			report.TotalEstimatedCredits += stepRes.EstimatedCredits
			stepRes.SimulatedOutput = map[string]any{
				"simulated_action": rpcName,
				"dry_run":          true,
				"side_effects":     "none (simulation only)",
			}
			stepRes.DiagnosticMessage = fmt.Sprintf("Simulated action execution: %s (dry run, 0 actual side effects)", rpcName)
			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeApproval:
			cfg := node.ApprovalConfig
			if cfg == nil {
				cfg = parseApprovalConfigFromMap(node.Config)
			}
			stepRes.SimulatedOutput = map[string]any{
				"gate_type":      "human_approval",
				"approvers":      cfg.ApproverIDs,
				"simulated_path": "approved",
			}
			stepRes.DiagnosticMessage = "Approval gate reached; simulation assumed approved"
			// Follow success branch
			for _, edge := range adj[node.NodeID] {
				if edge.Branch == EdgeBranchSuccess || edge.Branch == "" {
					nextNodeID = edge.ToNodeID
					break
				}
			}

		case NodeTypeWait:
			stepRes.DiagnosticMessage = "Wait node reached; skipped for instant simulation"
			stepRes.SimulatedOutput = map[string]any{"simulated_wait": true}
			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeFallback:
			stepRes.DiagnosticMessage = "Fallback node configured (not triggered in happy path)"
			stepRes.SimulatedOutput = map[string]any{"fallback_ready": true}
			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeDiagnostics:
			stepRes.DiagnosticMessage = "Diagnostics node simulated"
			stepRes.SimulatedOutput = map[string]any{"diagnostic_emitted": true}
			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeHandoff:
			stepRes.DiagnosticMessage = "Handoff node simulated"
			stepRes.SimulatedOutput = map[string]any{"handoff_target": "simulated_operator"}
			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeTerminal:
			cfg := node.TerminalConfig
			if cfg == nil {
				cfg = parseTerminalConfigFromMap(node.Config)
			}
			outcome := "succeeded"
			if cfg != nil && cfg.Outcome != "" {
				outcome = cfg.Outcome
			}
			stepRes.DiagnosticMessage = fmt.Sprintf("Terminal reached with outcome %s", outcome)
			stepRes.SimulatedOutput = map[string]any{"outcome": outcome}
			nextNodeID = "" // Terminal is end
		}

		report.StepResults = append(report.StepResults, stepRes)
		currID = nextNodeID
	}

	report.SimulationSummary = fmt.Sprintf("Simulation completed successfully across %d nodes with 0 business side effects. Total estimated credits: %.2f", len(report.StepResults), report.TotalEstimatedCredits)
	return report, nil
}

func resolveValueByPath(m map[string]any, path string) (any, bool) {
	if val, ok := m[path]; ok {
		return val, true
	}
	parts := strings.Split(path, ".")
	var current any = m
	for _, part := range parts {
		currMap, ok := current.(map[string]any)
		if !ok {
			return nil, false
		}
		val, ok := currMap[part]
		if !ok {
			return nil, false
		}
		current = val
	}
	return current, true
}

func evaluateSimulatedCondition(cfg *ConditionConfig, ctx map[string]any) bool {
	if cfg == nil {
		return true
	}
	val, exists := resolveValueByPath(ctx, cfg.Field)
	if !exists {
		return cfg.Operator == "neq"
	}
	cleanValue := strings.Trim(cfg.ValueJSON, `"`)
	switch strings.ToLower(cfg.Operator) {
	case "exists":
		return exists
	case "eq":
		return fmt.Sprintf("%v", val) == cleanValue || fmt.Sprintf("%v", val) == cfg.ValueJSON
	case "neq":
		return fmt.Sprintf("%v", val) != cleanValue && fmt.Sprintf("%v", val) != cfg.ValueJSON
	case "contains":
		return strings.Contains(fmt.Sprintf("%v", val), cleanValue)
	default:
		return true
	}
}

func stringContainsJSON(val any, target string) bool {
	cleanTarget := strings.Trim(target, `"`)
	return fmt.Sprintf("%v", val) == cleanTarget
}

// ----------------------------------------------------------------------------
// ActivepiecesAdapter (Optional adapter requiring actual enterprise entitlement)
// ----------------------------------------------------------------------------

type ActivepiecesAdapter struct {
	enterpriseLicenseKey string
}

func NewActivepiecesAdapter(licenseKey string) *ActivepiecesAdapter {
	if licenseKey == "" {
		licenseKey = os.Getenv("CREATIVANTA_ACTIVEPIECES_ENTERPRISE_KEY")
	}
	return &ActivepiecesAdapter{enterpriseLicenseKey: licenseKey}
}

var _ WorkflowEngineAdapter = (*ActivepiecesAdapter)(nil)

func (a *ActivepiecesAdapter) EngineType() string {
	return "activepieces"
}

// RequiresLicense indicates that Activepieces Enterprise requires external commercial licensing.
func (a *ActivepiecesAdapter) RequiresLicense() bool {
	return true
}

// IsEntitled checks if an enterprise license has been legally provisioned.
// If not entitled, fails closed without granting fake access.
func (a *ActivepiecesAdapter) IsEntitled(ctx context.Context, workspaceID string) (bool, error) {
	if strings.TrimSpace(a.enterpriseLicenseKey) == "" {
		return false, ErrActivepiecesUnentitled
	}
	return true, nil
}

func (a *ActivepiecesAdapter) SimulateWorkflow(ctx context.Context, graph *WorkflowGraph, sampleContext map[string]any) (*SimulationReport, error) {
	entitled, err := a.IsEntitled(ctx, "")
	if !entitled || err != nil {
		return nil, ErrActivepiecesUnentitled
	}
	// Fallback to owned simulator for deterministic simulation
	owned := NewOwnedWorkflowEngine()
	return owned.SimulateWorkflow(ctx, graph, sampleContext)
}

package workflow

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"time"
)

// ActionDispatcher abstracts executing inventory / external RPCs.
type ActionDispatcher interface {
	Dispatch(ctx context.Context, workspaceID, rpcName, inputJSON string) (output map[string]any, affectedObjects []string, err error)
}

// MockActionDispatcher records all dispatched actions for audit and idempotency assertions.
type MockActionDispatcher struct {
	mu           sync.Mutex
	dispatched   []DispatchedAction
	customErrors map[string]error
}

type DispatchedAction struct {
	WorkspaceID string
	RPCName     string
	InputJSON   string
	Timestamp   time.Time
}

func NewMockActionDispatcher() *MockActionDispatcher {
	return &MockActionDispatcher{
		dispatched:   make([]DispatchedAction, 0),
		customErrors: make(map[string]error),
	}
}

func (m *MockActionDispatcher) SetError(rpcName string, err error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.customErrors[rpcName] = err
}

func (m *MockActionDispatcher) Dispatch(ctx context.Context, workspaceID, rpcName, inputJSON string) (map[string]any, []string, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if err, ok := m.customErrors[rpcName]; ok && err != nil {
		return nil, nil, err
	}

	m.dispatched = append(m.dispatched, DispatchedAction{
		WorkspaceID: workspaceID,
		RPCName:     rpcName,
		InputJSON:   inputJSON,
		Timestamp:   time.Now().UTC(),
	})

	output := map[string]any{
		"dispatched":  true,
		"rpc":         rpcName,
		"executed_at": time.Now().UTC().Format(time.RFC3339),
	}
	affected := []string{fmt.Sprintf("obj-%s-%d", strings.ReplaceAll(rpcName, "/", "-"), len(m.dispatched))}
	return output, affected, nil
}

func (m *MockActionDispatcher) GetDispatchedCount(rpcName string) int {
	m.mu.Lock()
	defer m.mu.Unlock()
	count := 0
	for _, a := range m.dispatched {
		if rpcName == "" || a.RPCName == rpcName {
			count++
		}
	}
	return count
}

func (m *MockActionDispatcher) Reset() {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.dispatched = make([]DispatchedAction, 0)
	m.customErrors = make(map[string]error)
}

// ExecutionEngine executes workflow runs sequentially with capability-awareness,
// approval pausing, wait suspension, DLQ capture, and idempotency guarantees.
type ExecutionEngine struct {
	store           Store
	capProvider     CapabilityStatusProvider
	approvalMgr     *ApprovalManager
	dlqMgr          *DLQManager
	diagBuilder     *DiagnosticsBuilder
	dispatcher      ActionDispatcher
	maxCascadeDepth int
}

func NewExecutionEngine(
	store Store,
	capProvider CapabilityStatusProvider,
	dispatcher ActionDispatcher,
) *ExecutionEngine {
	if capProvider == nil {
		capProvider = NewDefaultCapabilityProvider()
	}
	if dispatcher == nil {
		dispatcher = NewMockActionDispatcher()
	}
	diagBuilder := NewDiagnosticsBuilder()
	dlqMgr := NewDLQManager(store)

	engine := &ExecutionEngine{
		store:           store,
		capProvider:     capProvider,
		dlqMgr:          dlqMgr,
		diagBuilder:     diagBuilder,
		dispatcher:      dispatcher,
		maxCascadeDepth: 5, // EC-M20-001
	}

	approvalMgr := NewApprovalManager(store, engine)
	engine.approvalMgr = approvalMgr

	return engine
}

func (e *ExecutionEngine) ApprovalManager() *ApprovalManager {
	return e.approvalMgr
}

func (e *ExecutionEngine) DLQManager() *DLQManager {
	return e.dlqMgr
}

func (e *ExecutionEngine) DiagnosticsBuilder() *DiagnosticsBuilder {
	return e.diagBuilder
}

func (e *ExecutionEngine) Dispatcher() ActionDispatcher {
	return e.dispatcher
}

// ExecuteRun begins or continues execution of a workflow run.
func (e *ExecutionEngine) ExecuteRun(ctx context.Context, workspaceID, runID string) (*WorkflowRun, error) {
	return e.runLoop(ctx, workspaceID, runID, nil)
}

// ResumeRun resumes execution of a paused or waiting workflow run with a signal.
// Strictly enforces: Resume never replays confirmed effect.
func (e *ExecutionEngine) ResumeRun(ctx context.Context, workspaceID, runID string, signal *ResumeSignal) (*WorkflowRun, error) {
	return e.runLoop(ctx, workspaceID, runID, signal)
}

// RouteToFallback routes a run to the fallback node configured for the current failure.
func (e *ExecutionEngine) RouteToFallback(ctx context.Context, workspaceID, runID, reason string) (*WorkflowRun, error) {
	run, err := e.store.GetWorkflowRun(ctx, workspaceID, runID)
	if err != nil {
		return nil, err
	}
	wf, err := e.store.GetWorkflow(ctx, workspaceID, run.WorkflowID)
	if err != nil {
		return nil, err
	}

	// Look for fallback edge from current node or fallback node in graph
	var fallbackTargetID string
	for _, edge := range wf.ActionChain.Edges {
		if edge.FromNodeID == run.CurrentNode && (edge.Branch == EdgeBranchFailure || edge.Branch == EdgeBranchFalse) {
			fallbackTargetID = edge.ToNodeID
			break
		}
	}
	if fallbackTargetID == "" {
		for _, n := range wf.ActionChain.Nodes {
			if n.NodeType == NodeTypeFallback {
				fallbackTargetID = n.NodeID
				break
			}
		}
	}

	if fallbackTargetID == "" {
		return nil, fmt.Errorf("no fallback path configured from node %s", run.CurrentNode)
	}

	run.CurrentNode = fallbackTargetID
	run.Status = WorkflowRunStatusRunning
	now := time.Now().UTC()
	run.UpdatedAt = now
	if run.ResultSummary == nil {
		run.ResultSummary = make(map[string]any)
	}
	run.ResultSummary["fallback_routed"] = true
	run.ResultSummary["fallback_reason"] = reason

	if err := e.store.UpdateWorkflowRun(ctx, run); err != nil {
		return nil, err
	}

	return e.runLoop(ctx, workspaceID, runID, &ResumeSignal{
		SignalType: "fallback_routed",
		Payload:    map[string]any{"reason": reason},
	})
}

// FailRunWithDiagnostics marks a run failed, attaches a diagnostics record, and pushes to DLQ.
func (e *ExecutionEngine) FailRunWithDiagnostics(
	ctx context.Context,
	workspaceID, runID string,
	diag *DiagnosticsRecord,
) (*WorkflowRun, error) {
	run, err := e.store.GetWorkflowRun(ctx, workspaceID, runID)
	if err != nil {
		return nil, err
	}

	now := time.Now().UTC()
	run.Status = WorkflowRunStatusFailed
	run.CompletedAt = &now
	run.UpdatedAt = now

	if run.ResultSummary == nil {
		run.ResultSummary = make(map[string]any)
	}
	run.ResultSummary["diagnostics"] = diag
	run.ResultSummary["failure_type"] = diag.FailureType
	run.ResultSummary["user_facing_explanation"] = diag.UserFacingExplanation
	run.ResultSummary["operator_explanation"] = diag.OperatorExplanation
	run.ResultSummary["recommended_next_step"] = diag.RecommendedNextStep
	run.ResultSummary["fallback_available"] = diag.FallbackAvailable

	if err := e.store.UpdateWorkflowRun(ctx, run); err != nil {
		return nil, err
	}

	// Dead-letter queue capture per RULE-M20-006
	dlqItem := &DLQItem{
		DLQID:               newUUID(),
		QueueName:           "workflow_runs",
		OriginalMessageID:   runID,
		Payload:             run.TriggerEvent,
		ErrorClass:          diag.FailureType,
		ErrorMessage:        diag.UserFacingExplanation,
		LastErrorAt:         now,
		AttemptCount:        1,
		WorkspaceID:         workspaceID,
		Status:              "pending",
		SuggestedRepairPath: diag.RecommendedNextStep,
		CreatedAt:           now,
	}
	_ = e.dlqMgr.PushToDLQ(ctx, dlqItem)

	return run, nil
}

// runLoop executes the sequential graph traversal until completion or pause.
func (e *ExecutionEngine) runLoop(
	ctx context.Context,
	workspaceID, runID string,
	signal *ResumeSignal,
) (*WorkflowRun, error) {
	run, err := e.store.GetWorkflowRun(ctx, workspaceID, runID)
	if err != nil {
		return nil, err
	}

	wf, err := e.store.GetWorkflow(ctx, workspaceID, run.WorkflowID)
	if err != nil {
		return nil, err
	}

	// 1. Cascade depth limit check (EC-M20-001)
	cascadeDepth := 0
	if run.TriggerEvent != nil {
		if d, ok := run.TriggerEvent["cascade_depth"].(float64); ok {
			cascadeDepth = int(d)
		} else if d, ok := run.TriggerEvent["cascade_depth"].(int); ok {
			cascadeDepth = d
		}
	}
	if cascadeDepth > e.maxCascadeDepth {
		diag := e.diagBuilder.CascadeDepthExceeded(workspaceID, runID, cascadeDepth)
		return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
	}

	// Build node lookup and adjacency maps
	nodeMap := make(map[string]*WorkflowNode, len(wf.ActionChain.Nodes))
	var rootTriggerID string
	for i := range wf.ActionChain.Nodes {
		n := &wf.ActionChain.Nodes[i]
		nodeMap[n.NodeID] = n
		if n.NodeType == NodeTypeTrigger {
			rootTriggerID = n.NodeID
		}
	}

	adj := make(map[string][]WorkflowEdge)
	for _, edge := range wf.ActionChain.Edges {
		adj[edge.FromNodeID] = append(adj[edge.FromNodeID], edge)
	}

	// Load existing steps to enforce: Resume never replays confirmed effect
	existingSteps, err := e.store.ListWorkflowRunSteps(ctx, workspaceID, runID)
	if err != nil {
		return nil, err
	}
	completedSteps := make(map[string]*WorkflowRunStep)
	for i := range existingSteps {
		st := &existingSteps[i]
		if st.Status == "succeeded" {
			completedSteps[st.NodeID] = st
		}
	}

	// Execution context
	currentContext := make(map[string]any)
	if run.TriggerEvent != nil {
		for k, v := range run.TriggerEvent {
			currentContext[k] = v
		}
	}

	// Determine starting node
	currID := run.CurrentNode
	if currID == "" {
		currID = rootTriggerID
	}

	now := time.Now().UTC()
	if run.StartedAt == nil {
		run.StartedAt = &now
	}
	run.Status = WorkflowRunStatusRunning
	run.UpdatedAt = now

	// Execution loop
	visitedInCurrentCycle := make(map[string]bool)

	for currID != "" {
		if visitedInCurrentCycle[currID] {
			// Loop detected in execution cycle
			diag := e.diagBuilder.CreateRecord(workspaceID, runID, "CYCLE_DETECTED", currID, NodeTypeAction,
				"A runtime loop was encountered. Execution was halted.",
				fmt.Sprintf("Node %s was revisited within the same execution pass.", currID),
				"Review graph branching logic.", false)
			return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
		}
		visitedInCurrentCycle[currID] = true

		node, exists := nodeMap[currID]
		if !exists {
			diag := e.diagBuilder.CreateRecord(workspaceID, runID, "NODE_NOT_FOUND", currID, NodeTypeAction,
				"Workflow references a missing node.", fmt.Sprintf("Node %s not in graph.", currID),
				"Edit workflow graph.", false)
			return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
		}

		run.CurrentNode = currID

		var nextNodeID string
		var branchTaken EdgeBranch

		switch node.NodeType {
		case NodeTypeTrigger:
			// Root trigger step
			stepOrder := int16(len(existingSteps) + 1)
			triggerInputJSON, _ := json.Marshal(currentContext)
			step := &WorkflowRunStep{
				StepID:         newUUID(),
				WorkspaceID:    workspaceID,
				RunID:          runID,
				NodeID:         node.NodeID,
				NodeType:       NodeTypeTrigger,
				StepOrder:      stepOrder,
				Status:         "succeeded",
				InputSnapshot:  string(triggerInputJSON),
				OutputSnapshot: string(triggerInputJSON),
				StartedAt:      &now,
				CompletedAt:    &now,
				CreatedAt:      now,
				UpdatedAt:      now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)
			existingSteps = append(existingSteps, *step)
			completedSteps[node.NodeID] = step

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

			outJSON, _ := json.Marshal(map[string]any{"condition_matched": matched})
			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:         newUUID(),
				WorkspaceID:    workspaceID,
				RunID:          runID,
				NodeID:         node.NodeID,
				NodeType:       NodeTypeCondition,
				StepOrder:      stepOrder,
				Status:         "succeeded",
				OutputSnapshot: string(outJSON),
				StartedAt:      &now,
				CompletedAt:    &now,
				CreatedAt:      now,
				UpdatedAt:      now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)
			existingSteps = append(existingSteps, *step)
			completedSteps[node.NodeID] = step

			targetBranch := EdgeBranchFalse
			if matched {
				targetBranch = EdgeBranchTrue
			}
			branchTaken = targetBranch

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

			outJSON, _ := json.Marshal(transformed)
			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:         newUUID(),
				WorkspaceID:    workspaceID,
				RunID:          runID,
				NodeID:         node.NodeID,
				NodeType:       NodeTypeTransform,
				StepOrder:      stepOrder,
				Status:         "succeeded",
				OutputSnapshot: string(outJSON),
				StartedAt:      &now,
				CompletedAt:    &now,
				CreatedAt:      now,
				UpdatedAt:      now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)
			existingSteps = append(existingSteps, *step)
			completedSteps[node.NodeID] = step

			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeAction:
			cfg := node.ActionConfig
			if cfg == nil {
				cfg = parseActionConfigFromMap(node.Config)
			}
			rpcName := ""
			inputJSON := "{}"
			if cfg != nil {
				rpcName = cfg.RPCName
				inputJSON = cfg.InputJSON
			}

			// Check: RESUME NEVER REPLAYS CONFIRMED EFFECT (Acceptance Target 3)
			if completedStep, ok := completedSteps[node.NodeID]; ok && len(completedStep.SideEffectRefs) > 0 {
				// Step was already executed with confirmed effects! Skip replaying.
				if completedStep.OutputSnapshot != "" {
					var outMap map[string]any
					if err := json.Unmarshal([]byte(completedStep.OutputSnapshot), &outMap); err == nil {
						for k, v := range outMap {
							currentContext[k] = v
						}
					}
				}
				edges := adj[node.NodeID]
				if len(edges) > 0 {
					nextNodeID = edges[0].ToNodeID
				}
				break
			}

			// 1. MANDATORY Capability Check (RULE-M20-002, AC-M20-003)
			platform := detectPlatform(rpcName, inputJSON)
			capStatus := "supported"
			if platform != "" {
				s, err := e.capProvider.GetPlatformCapability(ctx, workspaceID, platform, rpcName)
				if err == nil && s != "" {
					capStatus = s
				}
			}

			hasFallbackBranch := false
			var fallbackNodeID string
			for _, edge := range adj[node.NodeID] {
				if edge.Branch == EdgeBranchFailure {
					hasFallbackBranch = true
					fallbackNodeID = edge.ToNodeID
					break
				}
			}

			if capStatus == "degraded" || capStatus == "unsupported" {
				// Must not execute action silently per RULE-M20-002
				if hasFallbackBranch {
					// Route to fallback branch!
					stepOrder := int16(len(existingSteps) + 1)
					step := &WorkflowRunStep{
						StepID:         newUUID(),
						WorkspaceID:    workspaceID,
						RunID:          runID,
						NodeID:         node.NodeID,
						NodeType:       NodeTypeAction,
						StepOrder:      stepOrder,
						Status:         "skipped",
						OutputSnapshot: fmt.Sprintf(`{"skipped_reason":"capability_%s","platform":%q}`, capStatus, platform),
						StartedAt:      &now,
						CompletedAt:    &now,
						CreatedAt:      now,
						UpdatedAt:      now,
					}
					_ = e.store.CreateWorkflowRunStep(ctx, step)
					existingSteps = append(existingSteps, *step)

					nextNodeID = fallbackNodeID
					branchTaken = EdgeBranchFailure
					break
				}

				// No fallback path -> Fail with user-facing explanation per RULE-M20-003
				diag := e.diagBuilder.CapabilityDegraded(workspaceID, runID, node.NodeID, platform, rpcName, capStatus, false)
				stepOrder := int16(len(existingSteps) + 1)
				step := &WorkflowRunStep{
					StepID:         newUUID(),
					WorkspaceID:    workspaceID,
					RunID:          runID,
					NodeID:         node.NodeID,
					NodeType:       NodeTypeAction,
					StepOrder:      stepOrder,
					Status:         "failed",
					OutputSnapshot: fmt.Sprintf(`{"error":%q,"cap_status":%q}`, diag.UserFacingExplanation, capStatus),
					StartedAt:      &now,
					CompletedAt:    &now,
					CreatedAt:      now,
					UpdatedAt:      now,
				}
				_ = e.store.CreateWorkflowRunStep(ctx, step)
				return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
			}

			// 2. Dispatch action
			output, affectedObjs, dispatchErr := e.dispatcher.Dispatch(ctx, workspaceID, rpcName, inputJSON)
			if dispatchErr != nil {
				if hasFallbackBranch {
					stepOrder := int16(len(existingSteps) + 1)
					step := &WorkflowRunStep{
						StepID:         newUUID(),
						WorkspaceID:    workspaceID,
						RunID:          runID,
						NodeID:         node.NodeID,
						NodeType:       NodeTypeAction,
						StepOrder:      stepOrder,
						Status:         "failed",
						OutputSnapshot: fmt.Sprintf(`{"error":%q}`, dispatchErr.Error()),
						StartedAt:      &now,
						CompletedAt:    &now,
						CreatedAt:      now,
						UpdatedAt:      now,
					}
					_ = e.store.CreateWorkflowRunStep(ctx, step)
					nextNodeID = fallbackNodeID
					branchTaken = EdgeBranchFailure
					break
				}

				diag := e.diagBuilder.ActionFailed(workspaceID, runID, node.NodeID, rpcName, dispatchErr.Error(), false)
				return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
			}

			// Merge output to context
			for k, v := range output {
				currentContext[k] = v
			}

			// Create confirmed side effect record
			sideEffectID := newUUID()
			sideEffect := SideEffect{
				SideEffectID:    sideEffectID,
				RunID:           runID,
				StepID:          newUUID(),
				NodeID:          node.NodeID,
				Actor:           "system",
				Action:          rpcName,
				AffectedObjects: affectedObjs,
				CorrelationID:   runID,
				Timestamp:       now,
			}
			run.SideEffectsSummary = append(run.SideEffectsSummary, sideEffect)
			for _, obj := range affectedObjs {
				run.AffectedObjectRefs = append(run.AffectedObjectRefs, obj)
			}

			outBytes, _ := json.Marshal(output)
			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:         sideEffect.StepID,
				WorkspaceID:    workspaceID,
				RunID:          runID,
				NodeID:         node.NodeID,
				NodeType:       NodeTypeAction,
				StepOrder:      stepOrder,
				Status:         "succeeded",
				InputSnapshot:  inputJSON,
				OutputSnapshot: string(outBytes),
				SideEffectRefs: []string{sideEffectID},
				StartedAt:      &now,
				CompletedAt:    &now,
				CreatedAt:      now,
				UpdatedAt:      now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)
			existingSteps = append(existingSteps, *step)
			completedSteps[node.NodeID] = step

			// Follow default or success branch
			for _, edge := range adj[node.NodeID] {
				if edge.Branch == EdgeBranchSuccess || edge.Branch == "" {
					nextNodeID = edge.ToNodeID
					break
				}
			}

		case NodeTypeApproval:
			// Check if resuming with approval decision
			if signal != nil && signal.SignalType == "approval_granted" {
				// Resumed after approval granted!
				stepOrder := int16(len(existingSteps) + 1)
				step := &WorkflowRunStep{
					StepID:         newUUID(),
					WorkspaceID:    workspaceID,
					RunID:          runID,
					NodeID:         node.NodeID,
					NodeType:       NodeTypeApproval,
					StepOrder:      stepOrder,
					Status:         "succeeded",
					OutputSnapshot: `{"approval_status":"approved"}`,
					StartedAt:      &now,
					CompletedAt:    &now,
					CreatedAt:      now,
					UpdatedAt:      now,
				}
				_ = e.store.CreateWorkflowRunStep(ctx, step)
				existingSteps = append(existingSteps, *step)
				completedSteps[node.NodeID] = step

				// Reset signal for downstream nodes
				signal = nil

				for _, edge := range adj[node.NodeID] {
					if edge.Branch == EdgeBranchSuccess || edge.Branch == "" {
						nextNodeID = edge.ToNodeID
						break
					}
				}
				break
			}

			// First time reaching approval gate -> PAUSE RUN!
			run.Status = WorkflowRunStatusWaitingApproval
			run.CurrentNode = node.NodeID
			run.UpdatedAt = now

			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:      newUUID(),
				WorkspaceID: workspaceID,
				RunID:       runID,
				NodeID:      node.NodeID,
				NodeType:    NodeTypeApproval,
				StepOrder:   stepOrder,
				Status:      "waiting_approval",
				StartedAt:   &now,
				CreatedAt:   now,
				UpdatedAt:   now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)

			// Look up next action node to bind in approval request
			var nextActionNode *WorkflowNode
			for _, edge := range adj[node.NodeID] {
				if edge.Branch == EdgeBranchSuccess || edge.Branch == "" {
					if n, ok := nodeMap[edge.ToNodeID]; ok && n.NodeType == NodeTypeAction {
						nextActionNode = n
					}
					break
				}
			}

			var targetObjs []string
			if nextActionNode != nil && nextActionNode.ActionConfig != nil {
				targetObjs = append(targetObjs, nextActionNode.ActionConfig.RPCName)
			}

			caller := CallerContext{WorkspaceID: workspaceID, UserID: "system", WorkspaceRole: "manager"}
			_, err = e.approvalMgr.CreateApprovalRequest(ctx, caller, wf, run, node, nextActionNode, targetObjs)
			if err != nil {
				return nil, fmt.Errorf("creating approval request for run: %w", err)
			}

			_ = e.store.UpdateWorkflowRun(ctx, run)
			return run, nil

		case NodeTypeWait:
			if signal != nil && (signal.SignalType == "wait_timer" || signal.SignalType == "external_condition") {
				// Resumed after wait completed!
				stepOrder := int16(len(existingSteps) + 1)
				step := &WorkflowRunStep{
					StepID:         newUUID(),
					WorkspaceID:    workspaceID,
					RunID:          runID,
					NodeID:         node.NodeID,
					NodeType:       NodeTypeWait,
					StepOrder:      stepOrder,
					Status:         "succeeded",
					OutputSnapshot: fmt.Sprintf(`{"resumed_signal":%q}`, signal.SignalType),
					StartedAt:      &now,
					CompletedAt:    &now,
					CreatedAt:      now,
					UpdatedAt:      now,
				}
				_ = e.store.CreateWorkflowRunStep(ctx, step)
				existingSteps = append(existingSteps, *step)
				completedSteps[node.NodeID] = step

				signal = nil

				edges := adj[node.NodeID]
				if len(edges) > 0 {
					nextNodeID = edges[0].ToNodeID
				}
				break
			}

			// Pause execution for wait
			run.Status = WorkflowRunStatusWaitingExternalCondition
			run.CurrentNode = node.NodeID
			run.UpdatedAt = now

			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:      newUUID(),
				WorkspaceID: workspaceID,
				RunID:       runID,
				NodeID:      node.NodeID,
				NodeType:    NodeTypeWait,
				StepOrder:   stepOrder,
				Status:      "waiting_external_condition",
				StartedAt:   &now,
				CreatedAt:   now,
				UpdatedAt:   now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)
			_ = e.store.UpdateWorkflowRun(ctx, run)
			return run, nil

		case NodeTypeFallback:
			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:         newUUID(),
				WorkspaceID:    workspaceID,
				RunID:          runID,
				NodeID:         node.NodeID,
				NodeType:       NodeTypeFallback,
				StepOrder:      stepOrder,
				Status:         "succeeded",
				OutputSnapshot: `{"fallback_executed":true}`,
				StartedAt:      &now,
				CompletedAt:    &now,
				CreatedAt:      now,
				UpdatedAt:      now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)
			existingSteps = append(existingSteps, *step)
			completedSteps[node.NodeID] = step

			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeDiagnostics:
			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:         newUUID(),
				WorkspaceID:    workspaceID,
				RunID:          runID,
				NodeID:         node.NodeID,
				NodeType:       NodeTypeDiagnostics,
				StepOrder:      stepOrder,
				Status:         "succeeded",
				OutputSnapshot: `{"diagnostic_logged":true}`,
				StartedAt:      &now,
				CompletedAt:    &now,
				CreatedAt:      now,
				UpdatedAt:      now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)
			existingSteps = append(existingSteps, *step)
			completedSteps[node.NodeID] = step

			edges := adj[node.NodeID]
			if len(edges) > 0 {
				nextNodeID = edges[0].ToNodeID
			}

		case NodeTypeHandoff:
			run.Status = WorkflowRunStatusRequiresManualIntervention
			run.CurrentNode = node.NodeID
			run.UpdatedAt = now

			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:         newUUID(),
				WorkspaceID:    workspaceID,
				RunID:          runID,
				NodeID:         node.NodeID,
				NodeType:       NodeTypeHandoff,
				StepOrder:      stepOrder,
				Status:         "succeeded",
				OutputSnapshot: `{"handoff":true}`,
				StartedAt:      &now,
				CompletedAt:    &now,
				CreatedAt:      now,
				UpdatedAt:      now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)

			// Push to DLQ for manual intervention
			_ = e.dlqMgr.PushToDLQ(ctx, &DLQItem{
				DLQID:               newUUID(),
				QueueName:           "workflow_runs",
				OriginalMessageID:   runID,
				Payload:             run.TriggerEvent,
				ErrorClass:          "MANUAL_INTERVENTION_REQUIRED",
				ErrorMessage:        "Run handed off for manual operator intervention",
				LastErrorAt:         now,
				AttemptCount:        1,
				WorkspaceID:         workspaceID,
				Status:              "pending",
				SuggestedRepairPath: "Review step inputs and resume after resolving intervention requirement.",
				CreatedAt:           now,
			})

			_ = e.store.UpdateWorkflowRun(ctx, run)
			return run, nil

		case NodeTypeTerminal:
			cfg := node.TerminalConfig
			if cfg == nil {
				cfg = parseTerminalConfigFromMap(node.Config)
			}
			outcome := "succeeded"
			if cfg != nil && cfg.Outcome != "" {
				outcome = cfg.Outcome
			}

			stepOrder := int16(len(existingSteps) + 1)
			step := &WorkflowRunStep{
				StepID:         newUUID(),
				WorkspaceID:    workspaceID,
				RunID:          runID,
				NodeID:         node.NodeID,
				NodeType:       NodeTypeTerminal,
				StepOrder:      stepOrder,
				Status:         outcome,
				OutputSnapshot: fmt.Sprintf(`{"outcome":%q}`, outcome),
				StartedAt:      &now,
				CompletedAt:    &now,
				CreatedAt:      now,
				UpdatedAt:      now,
			}
			_ = e.store.CreateWorkflowRunStep(ctx, step)

			run.Status = WorkflowRunStatus(outcome)
			run.CompletedAt = &now
			run.UpdatedAt = now
			if run.ResultSummary == nil {
				run.ResultSummary = make(map[string]any)
			}
			run.ResultSummary["final_outcome"] = outcome
			_ = e.store.UpdateWorkflowRun(ctx, run)
			return run, nil
		}

		_ = branchTaken
		currID = nextNodeID
	}

	// Finalize if reached end without terminal
	run.Status = WorkflowRunStatusSucceeded
	run.CompletedAt = &now
	run.UpdatedAt = now
	_ = e.store.UpdateWorkflowRun(ctx, run)
	return run, nil
}

package workflow

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

type actionIdempotencyKeyCtxKey struct{}

// WithActionIdempotencyKey attaches a deterministic step idempotency key to ctx.
func WithActionIdempotencyKey(ctx context.Context, key string) context.Context {
	return context.WithValue(ctx, actionIdempotencyKeyCtxKey{}, key)
}

// ActionIdempotencyKeyFromContext extracts the step idempotency key from ctx.
func ActionIdempotencyKeyFromContext(ctx context.Context) string {
	if ctx == nil {
		return ""
	}
	v, _ := ctx.Value(actionIdempotencyKeyCtxKey{}).(string)
	return v
}

// TierLimitChecker abstracts workspace tier entitlement & limit verification for workflows.
type TierLimitChecker interface {
	CheckTierLimit(ctx context.Context, workspaceID string, wf *Workflow) error
}

// ActionDispatcher abstracts executing inventory / external RPCs.
type ActionDispatcher interface {
	Dispatch(ctx context.Context, workspaceID, rpcName, inputJSON string) (output map[string]any, affectedObjects []string, err error)
}

// MockActionDispatcher records all dispatched actions for audit and idempotency assertions.
type MockActionDispatcher struct {
	mu           sync.Mutex
	dispatched   []DispatchedAction
	seenIdemKeys map[string]DispatchedAction
	customErrors map[string]error
}

type DispatchedAction struct {
	WorkspaceID    string
	RPCName        string
	InputJSON      string
	IdempotencyKey string
	Timestamp      time.Time
}

func NewMockActionDispatcher() *MockActionDispatcher {
	return &MockActionDispatcher{
		dispatched:   make([]DispatchedAction, 0),
		seenIdemKeys: make(map[string]DispatchedAction),
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

	idemKey := ActionIdempotencyKeyFromContext(ctx)
	if idemKey != "" {
		if prev, exists := m.seenIdemKeys[idemKey]; exists {
			output := map[string]any{
				"dispatched":      true,
				"rpc":             prev.RPCName,
				"idempotent_hit":  true,
				"idempotency_key": idemKey,
				"executed_at":     prev.Timestamp.Format(time.RFC3339),
			}
			affected := []string{fmt.Sprintf("obj-%s-idempotent", strings.ReplaceAll(rpcName, "/", "-"))}
			return output, affected, nil
		}
	}

	rec := DispatchedAction{
		WorkspaceID:    workspaceID,
		RPCName:        rpcName,
		InputJSON:      inputJSON,
		IdempotencyKey: idemKey,
		Timestamp:      time.Now().UTC(),
	}
	m.dispatched = append(m.dispatched, rec)
	if idemKey != "" {
		m.seenIdemKeys[idemKey] = rec
	}

	output := map[string]any{
		"dispatched":  true,
		"rpc":         rpcName,
		"executed_at": rec.Timestamp.Format(time.RFC3339),
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
	m.seenIdemKeys = make(map[string]DispatchedAction)
	m.customErrors = make(map[string]error)
}

type memberMembershipState struct {
	role   string
	active bool
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
	tierChecker     TierLimitChecker
	roleResolver    MembershipRoleResolver
	membersMu       sync.RWMutex
	memberStates    map[string]memberMembershipState
	maxCascadeDepth int
	runLocksMu      sync.Mutex
	inFlightRuns    map[string]bool
}

func NewExecutionEngine(
	store Store,
	capProvider CapabilityStatusProvider,
	dispatcher ActionDispatcher,
) *ExecutionEngine {
	if capProvider == nil {
		capProvider = NewDefaultCapabilityProvider()
	}
	// Do NOT default dispatcher to NewMockActionDispatcher() (AI-04 / R07 fail-closed contract).
	diagBuilder := NewDiagnosticsBuilder()
	dlqMgr := NewDLQManager(store)

	engine := &ExecutionEngine{
		store:           store,
		capProvider:     capProvider,
		dlqMgr:          dlqMgr,
		diagBuilder:     diagBuilder,
		dispatcher:      dispatcher,
		memberStates:    make(map[string]memberMembershipState),
		maxCascadeDepth: 5, // EC-M20-001
		inFlightRuns:    make(map[string]bool),
	}

	approvalMgr := NewApprovalManager(store, engine)
	engine.approvalMgr = approvalMgr

	return engine
}

func (e *ExecutionEngine) SetCapabilityProvider(cp CapabilityStatusProvider) {
	e.capProvider = cp
}

func (e *ExecutionEngine) SetActionDispatcher(ad ActionDispatcher) {
	e.dispatcher = ad
}

func (e *ExecutionEngine) SetTierLimitChecker(tc TierLimitChecker) {
	e.tierChecker = tc
}

func (e *ExecutionEngine) SetMembershipRoleResolver(resolver MembershipRoleResolver) {
	e.membersMu.Lock()
	defer e.membersMu.Unlock()
	e.roleResolver = resolver
}

func (e *ExecutionEngine) SetMemberRole(workspaceID, userID, role string, active bool) {
	ws := strings.TrimSpace(workspaceID)
	uid := strings.TrimSpace(userID)
	if ws == "" || uid == "" {
		return
	}
	if mut, ok := e.store.(WorkspaceMembershipMutator); ok && mut != nil {
		mut.SetMemberRole(ws, uid, strings.TrimSpace(role), active)
	}
	e.membersMu.Lock()
	defer e.membersMu.Unlock()
	if e.memberStates == nil {
		e.memberStates = make(map[string]memberMembershipState)
	}
	e.memberStates[ws+":"+uid] = memberMembershipState{
		role:   strings.TrimSpace(role),
		active: active,
	}
}

type liveRequestCallerKey struct{}

func withLiveRequestCaller(ctx context.Context, caller CallerContext) context.Context {
	if ctx == nil {
		return ctx
	}
	return context.WithValue(ctx, liveRequestCallerKey{}, caller)
}

func liveRequestCallerFromContext(ctx context.Context) (CallerContext, bool) {
	if ctx == nil {
		return CallerContext{}, false
	}
	caller, ok := ctx.Value(liveRequestCallerKey{}).(CallerContext)
	return caller, ok
}

func isInactiveOrRevokedRole(role string, active bool) bool {
	trimmed := strings.TrimSpace(role)
	return !active || trimmed == "" || strings.EqualFold(trimmed, "revoked") || strings.EqualFold(trimmed, "none") || strings.EqualFold(trimmed, "denied")
}

// resolveLiveActorRole resolves the initiator's current active workspace role from an authoritative
// membership source (configured MembershipRoleResolver or WorkspaceMembershipStore). It never falls
// back to a launch-time role snapshot or unverified observed cache on resumed/cross-actor execution (R3).
func (e *ExecutionEngine) resolveLiveActorRole(ctx context.Context, workspaceID, actorUserID string, isResumed bool) (string, bool, error) {
	uid := strings.TrimSpace(actorUserID)
	ws := strings.TrimSpace(workspaceID)
	if uid == "" || ws == "" {
		return "", false, fmt.Errorf("%w: workflow run is missing verified initiator identity", rbac.ErrPermissionDenied)
	}

	e.membersMu.RLock()
	resolver := e.roleResolver
	st, hasState := e.memberStates[ws+":"+uid]
	e.membersMu.RUnlock()

	if resolver != nil {
		resolvedRole, active, err := resolver(ctx, ws, uid)
		if err != nil {
			return "", false, fmt.Errorf("%w: failed to verify initiator %s membership: %v", rbac.ErrPermissionDenied, uid, err)
		}
		if isInactiveOrRevokedRole(resolvedRole, active) {
			return "", false, fmt.Errorf("%w: initiator %s workspace membership is inactive or revoked", rbac.ErrPermissionDenied, uid)
		}
		return strings.TrimSpace(resolvedRole), true, nil
	}

	if memStore, ok := e.store.(WorkspaceMembershipStore); ok && memStore != nil {
		storeRole, active, found, err := memStore.ResolveWorkspaceMemberRole(ctx, ws, uid)
		if err != nil {
			return "", false, fmt.Errorf("%w: failed to query authoritative workspace membership for %s: %v", rbac.ErrPermissionDenied, uid, err)
		}
		if found {
			if isInactiveOrRevokedRole(storeRole, active) {
				return "", false, fmt.Errorf("%w: initiator %s workspace membership is inactive or revoked", rbac.ErrPermissionDenied, uid)
			}
			return strings.TrimSpace(storeRole), true, nil
		}
	}

	if hasState {
		if isInactiveOrRevokedRole(st.role, st.active) {
			return "", false, fmt.Errorf("%w: initiator %s workspace access has been revoked", rbac.ErrPermissionDenied, uid)
		}
		return strings.TrimSpace(st.role), true, nil
	}

	if !isResumed {
		if liveCaller, ok := liveRequestCallerFromContext(ctx); ok &&
			strings.TrimSpace(liveCaller.WorkspaceID) == ws &&
			strings.TrimSpace(liveCaller.UserID) == uid {
			if isInactiveOrRevokedRole(liveCaller.WorkspaceRole, true) {
				return "", false, fmt.Errorf("%w: initiator %s role is invalid or revoked", rbac.ErrPermissionDenied, uid)
			}
			return strings.TrimSpace(liveCaller.WorkspaceRole), true, nil
		}
	}

	return "", false, fmt.Errorf("%w: authoritative workspace membership required to verify live role for initiator %s in workspace %s", rbac.ErrPermissionDenied, uid, ws)
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

func resolveActionPermissionKey(rpcName string) string {
	if policy, ok := lookupWorkflowActionPolicy(rpcName); ok {
		return policy.PermissionKey
	}
	return ""
}

func checkDelegatedActionPermission(actorUserID, workspaceID, actorRole, rpcName string) error {
	permKey := resolveActionPermissionKey(rpcName)
	if permKey == "" {
		return fmt.Errorf("%w: unregistered or unsupported workflow action RPC %q", rbac.ErrPermissionDenied, rpcName)
	}
	role := strings.ToLower(strings.TrimSpace(actorRole))
	if role == "member" {
		role = "contributor"
	}
	return rbac.CheckWorkspacePermission(permKey, rbac.PolicyContext{
		ActorUserID: actorUserID,
		WorkspaceID: workspaceID,
		Role:        role,
	})
}

func isUncertainDispatchError(err error) bool {
	if err == nil {
		return false
	}
	if errors.Is(err, context.DeadlineExceeded) ||
		errors.Is(err, context.Canceled) ||
		errors.Is(err, io.EOF) ||
		errors.Is(err, io.ErrUnexpectedEOF) ||
		errors.Is(err, ErrUncertainStepEffect) {
		return true
	}
	lower := strings.ToLower(err.Error())
	return strings.Contains(lower, "timeout") ||
		strings.Contains(lower, "deadline exceeded") ||
		strings.Contains(lower, "unknown") ||
		strings.Contains(lower, "unexpected eof") ||
		strings.Contains(lower, "connection reset") ||
		strings.Contains(lower, "broken pipe")
}

func (e *ExecutionEngine) hasValidApprovedRequestForAction(
	ctx context.Context,
	workspaceID string,
	wf *Workflow,
	runID, actionNodeID, stepID, rpcName, inputJSON string,
	now time.Time,
	consume bool,
) (bool, error) {
	targetActionNodeID := strings.TrimSpace(actionNodeID)
	if targetActionNodeID == "" {
		return false, nil
	}
	approvals, _, err := e.store.ListApprovalRequests(ctx, workspaceID, ApprovalFilter{
		RunID:  runID,
		Status: "approved",
		Limit:  100,
	})
	if err != nil {
		return false, err
	}
	budgetQuote := estimateActionCredits(rpcName)
	for i := range approvals {
		req := &approvals[i]
		hydrateApprovalMetadata(req)
		if req.Status != "approved" {
			continue
		}
		if req.WorkflowID != "" && req.WorkflowID != wf.WorkflowID {
			continue
		}
		if req.WorkflowVersion != 0 && req.WorkflowVersion != wf.Version {
			continue
		}
		if req.ExpiresAt != nil && now.After(*req.ExpiresAt) {
			continue
		}
		// R5: Approval request must be bound to this specific target actionNodeID and not already consumed.
		if strings.TrimSpace(req.ActionNodeID) == "" || strings.TrimSpace(req.ActionNodeID) != targetActionNodeID {
			continue
		}
		if strings.TrimSpace(req.ConsumedByNodeID) != "" && strings.TrimSpace(req.ConsumedByNodeID) != targetActionNodeID {
			continue
		}
		if strings.TrimSpace(req.ConsumedByStepID) != "" && strings.TrimSpace(stepID) != "" && strings.TrimSpace(req.ConsumedByStepID) != strings.TrimSpace(stepID) {
			continue
		}
		expectedHash := ComputeActionHash(wf.Version, req.NodeID, rpcName, inputJSON, req.TargetObjects, budgetQuote)
		if req.ActionHash != "" && req.ActionHash == expectedHash {
			if consume {
				req.ConsumedByNodeID = targetActionNodeID
				req.ConsumedByStepID = strings.TrimSpace(stepID)
				req.UpdatedAt = now
				syncApprovalMetadataToReason(req)
				if err := e.store.UpdateApprovalRequest(ctx, req); err != nil {
					return false, err
				}
			}
			return true, nil
		}
	}
	return false, nil
}

// runLoop executes the sequential graph traversal until completion or pause.
func (e *ExecutionEngine) runLoop(
	ctx context.Context,
	workspaceID, runID string,
	signal *ResumeSignal,
) (*WorkflowRun, error) {
	e.runLocksMu.Lock()
	if e.inFlightRuns == nil {
		e.inFlightRuns = make(map[string]bool)
	}
	if e.inFlightRuns[runID] {
		e.runLocksMu.Unlock()
		return nil, ErrRunAlreadyInFlight
	}
	e.inFlightRuns[runID] = true
	e.runLocksMu.Unlock()
	defer func() {
		e.runLocksMu.Lock()
		delete(e.inFlightRuns, runID)
		e.runLocksMu.Unlock()
	}()

	run, err := e.store.GetWorkflowRun(ctx, workspaceID, runID)
	if err != nil {
		return nil, err
	}
	if run.Status == WorkflowRunStatusSucceeded || run.Status == WorkflowRunStatusCancelled {
		return run, fmt.Errorf("%w: run is already in terminal state %s", ErrInvalidRunState, run.Status)
	}

	wf, err := e.store.GetWorkflow(ctx, workspaceID, run.WorkflowID)
	if err != nil {
		return nil, err
	}
	if wf.Status != WorkflowStatusActive {
		return nil, fmt.Errorf("%w: workflow status is %s (must be active to execute)", ErrInvalidWorkflowState, wf.Status)
	}

	if wf.TierLimitCheck && e.tierChecker != nil {
		if err := e.tierChecker.CheckTierLimit(ctx, workspaceID, wf); err != nil {
			diag := e.diagBuilder.CreateRecord(workspaceID, runID, "TIER_LIMIT_EXCEEDED", run.CurrentNode, NodeTypeAction,
				"Workspace subscription tier limit exceeded for this workflow.",
				err.Error(),
				"Upgrade workspace subscription tier or reduce workflow usage.", false)
			return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
		}
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
	skippedSteps := make(map[string]*WorkflowRunStep)
	inFlightSteps := make(map[string]*WorkflowRunStep)
	for i := range existingSteps {
		st := &existingSteps[i]
		if st.Status == "succeeded" {
			completedSteps[st.NodeID] = st
		} else if st.NodeType == NodeTypeAction && (st.Status == "running" || strings.Contains(st.OutputSnapshot, "uncertain_error")) {
			inFlightSteps[st.NodeID] = st
		} else if st.Status == "skipped" {
			skippedSteps[st.NodeID] = st
		}
	}

	launchActorRole := strings.TrimSpace(run.InitiatedByRole)
	actorUserID := strings.TrimSpace(run.InitiatedByUserID)
	if run.TriggerEvent != nil {
		if launchActorRole == "" {
			if r, ok := run.TriggerEvent["_actor_role"].(string); ok {
				launchActorRole = strings.TrimSpace(r)
			}
		}
		if actorUserID == "" {
			if u, ok := run.TriggerEvent["_actor_user_id"].(string); ok {
				actorUserID = strings.TrimSpace(u)
			}
		}
	}
	isResumedExecution := signal != nil || len(existingSteps) > 0

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

			// F10: Check uncertain-effect lock FIRST so neither SkipStep nor completedSteps can mask an unresolved in-flight step
			if _, uncertain := inFlightSteps[node.NodeID]; uncertain {
				run.Status = WorkflowRunStatusRequiresManualIntervention
				run.UpdatedAt = now
				if run.ResultSummary == nil {
					run.ResultSummary = make(map[string]any)
				}
				run.ResultSummary["failure_type"] = "ACTION_EFFECT_UNCERTAIN"
				run.ResultSummary["user_facing_explanation"] = fmt.Sprintf("Action step %s was interrupted in flight; manual reconciliation is required before replay.", node.NodeID)
				if err := e.store.UpdateWorkflowRun(ctx, run); err != nil {
					return nil, err
				}
				return run, ErrUncertainStepEffect
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

			// F10: If a non-uncertain step was explicitly skipped, advance past it without executing the action
			if _, alreadySkipped := skippedSteps[node.NodeID]; alreadySkipped {
				for _, edge := range adj[node.NodeID] {
					if edge.Branch == "" || edge.Branch == EdgeBranchSuccess {
						nextNodeID = edge.ToNodeID
						branchTaken = edge.Branch
						break
					}
				}
				if nextNodeID == "" && len(adj[node.NodeID]) > 0 {
					nextNodeID = adj[node.NodeID][0].ToNodeID
				}
				break
			}

			// 1. MANDATORY Capability Check (RULE-M20-002, AC-M20-003, C2 fail-closed allowlist)
			platform, capStatus, capExecutable := resolveActionCapabilityStatus(ctx, e.capProvider, workspaceID, rpcName, inputJSON)

			hasFallbackBranch := false
			var fallbackNodeID string
			for _, edge := range adj[node.NodeID] {
				if edge.Branch == EdgeBranchFailure {
					hasFallbackBranch = true
					fallbackNodeID = edge.ToNodeID
					break
				}
			}

			if !capExecutable {
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
					if err := e.store.CreateWorkflowRunStep(ctx, step); err != nil {
						return nil, err
					}
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
				if err := e.store.CreateWorkflowRunStep(ctx, step); err != nil {
					return nil, err
				}
				return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
			}

			// 2. Delegated RBAC Permission & Live Membership Check at Action Effect Point (AI-09, F11, R3)
			liveActorRole, activeMember, roleErr := e.resolveLiveActorRole(ctx, workspaceID, actorUserID, isResumedExecution)
			var permErr error
			if roleErr != nil || !activeMember {
				permErr = roleErr
				if permErr == nil {
					permErr = fmt.Errorf("%w: initiator %s membership is no longer active", rbac.ErrPermissionDenied, actorUserID)
				}
			} else {
				permErr = checkDelegatedActionPermission(actorUserID, workspaceID, liveActorRole, rpcName)
			}
			if permErr != nil {
				roleLabel := liveActorRole
				if roleLabel == "" {
					roleLabel = "revoked"
				}
				diag := e.diagBuilder.CreateRecord(
					workspaceID,
					runID,
					"PERMISSION_DENIED",
					node.NodeID,
					NodeTypeAction,
					fmt.Sprintf("Permission denied: initiator role %q (launch role %q) is not authorized to execute action %q.", roleLabel, launchActorRole, rpcName),
					permErr.Error(),
					"Verify initiator's active workspace membership and role or re-authorize the workflow with an eligible operator.",
					hasFallbackBranch,
				)
				stepOrder := int16(len(existingSteps) + 1)
				step := &WorkflowRunStep{
					StepID:         newUUID(),
					WorkspaceID:    workspaceID,
					RunID:          runID,
					NodeID:         node.NodeID,
					NodeType:       NodeTypeAction,
					StepOrder:      stepOrder,
					Status:         "failed",
					OutputSnapshot: fmt.Sprintf(`{"error":%q}`, diag.UserFacingExplanation),
					StartedAt:      &now,
					CompletedAt:    &now,
					CreatedAt:      now,
					UpdatedAt:      now,
				}
				if err := e.store.CreateWorkflowRunStep(ctx, step); err != nil {
					return nil, err
				}
				if hasFallbackBranch {
					nextNodeID = fallbackNodeID
					branchTaken = EdgeBranchFailure
					break
				}
				return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
			}

			stepID := newUUID()

			// 3. Mandatory Approval Verification for Sensitive Actions at Effect Point (AI-09, R5)
			if IsSensitiveAction(rpcName) {
				approvedOK, err := e.hasValidApprovedRequestForAction(ctx, workspaceID, wf, runID, node.NodeID, stepID, rpcName, inputJSON, now, false)
				if err != nil {
					return nil, err
				}
				if !approvedOK {
					diag := e.diagBuilder.CreateRecord(
						workspaceID,
						runID,
						"APPROVAL_REQUIRED",
						node.NodeID,
						NodeTypeAction,
						fmt.Sprintf("Sensitive action %q requires a valid approved approval gate bound to the current workflow version and inputs.", rpcName),
						ErrApprovalRequiredForSensitiveAction.Error(),
						"Add an upstream Approval node and obtain manager approval before executing this sensitive action.",
						hasFallbackBranch,
					)
					stepOrder := int16(len(existingSteps) + 1)
					step := &WorkflowRunStep{
						StepID:         stepID,
						WorkspaceID:    workspaceID,
						RunID:          runID,
						NodeID:         node.NodeID,
						NodeType:       NodeTypeAction,
						StepOrder:      stepOrder,
						Status:         "failed",
						OutputSnapshot: fmt.Sprintf(`{"error":%q}`, ErrApprovalRequiredForSensitiveAction.Error()),
						StartedAt:      &now,
						CompletedAt:    &now,
						CreatedAt:      now,
						UpdatedAt:      now,
					}
					if err := e.store.CreateWorkflowRunStep(ctx, step); err != nil {
						return nil, err
					}
					if hasFallbackBranch {
						nextNodeID = fallbackNodeID
						branchTaken = EdgeBranchFailure
						break
					}
					return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
				}
			}

			// 4. Fail-Closed Dispatcher Check (AI-04 / R07)
			if e.dispatcher == nil {
				stepOrder := int16(len(existingSteps) + 1)
				step := &WorkflowRunStep{
					StepID:         stepID,
					WorkspaceID:    workspaceID,
					RunID:          runID,
					NodeID:         node.NodeID,
					NodeType:       NodeTypeAction,
					StepOrder:      stepOrder,
					Status:         "failed",
					InputSnapshot:  inputJSON,
					OutputSnapshot: fmt.Sprintf(`{"error":%q}`, ErrDispatcherNotConfigured.Error()),
					StartedAt:      &now,
					CompletedAt:    &now,
					CreatedAt:      now,
					UpdatedAt:      now,
				}
				if err := e.store.CreateWorkflowRunStep(ctx, step); err != nil {
					return nil, err
				}
				if hasFallbackBranch {
					nextNodeID = fallbackNodeID
					branchTaken = EdgeBranchFailure
					break
				}
				diag := e.diagBuilder.ActionFailed(workspaceID, runID, node.NodeID, rpcName, ErrDispatcherNotConfigured.Error(), false)
				return e.FailRunWithDiagnostics(ctx, workspaceID, runID, diag)
			}

			// Consume bound approval one-to-one with this action node/step before dispatch (R5)
			if IsSensitiveAction(rpcName) {
				consumedOK, err := e.hasValidApprovedRequestForAction(ctx, workspaceID, wf, runID, node.NodeID, stepID, rpcName, inputJSON, now, true)
				if err != nil {
					return nil, err
				}
				if !consumedOK {
					return nil, ErrApprovalRequiredForSensitiveAction
				}
			}

			// 5. Persist pre-dispatch running step BEFORE external dispatch (AI-10 / R09)
			stepOrder := int16(len(existingSteps) + 1)
			runningStep := &WorkflowRunStep{
				StepID:        stepID,
				WorkspaceID:   workspaceID,
				RunID:         runID,
				NodeID:        node.NodeID,
				NodeType:      NodeTypeAction,
				StepOrder:     stepOrder,
				Status:        "running",
				InputSnapshot: inputJSON,
				StartedAt:     &now,
				CreatedAt:     now,
				UpdatedAt:     now,
			}
			if err := e.store.CreateWorkflowRunStep(ctx, runningStep); err != nil {
				return nil, fmt.Errorf("persist pre-dispatch running step: %w", err)
			}
			existingSteps = append(existingSteps, *runningStep)

			// 6. Dispatch action with deterministic idempotency key
			dispatchCtx := WithActionIdempotencyKey(ctx, fmt.Sprintf("%s:%s", runID, node.NodeID))
			output, affectedObjs, dispatchErr := e.dispatcher.Dispatch(dispatchCtx, workspaceID, rpcName, inputJSON)
			if dispatchErr != nil {
				if isUncertainDispatchError(dispatchErr) {
					// Keep step in 'running' state so RetryRun / ResumeRun cannot blindly re-dispatch or route to fallback!
					runningStep.Status = "running"
					runningStep.OutputSnapshot = fmt.Sprintf(`{"uncertain_error":%q}`, dispatchErr.Error())
					runningStep.UpdatedAt = now
					if err := e.store.UpdateWorkflowRunStep(ctx, runningStep); err != nil {
						return nil, fmt.Errorf("persist uncertain action step: %w", err)
					}

					run.Status = WorkflowRunStatusRequiresManualIntervention
					run.CurrentNode = node.NodeID
					run.UpdatedAt = now
					if run.ResultSummary == nil {
						run.ResultSummary = make(map[string]any)
					}
					run.ResultSummary["failure_type"] = "ACTION_EFFECT_UNCERTAIN"
					run.ResultSummary["user_facing_explanation"] = fmt.Sprintf("Action step %s (%s) encountered an ambiguous outcome (%v); manual reconciliation is required before fallback or retry.", node.NodeID, rpcName, dispatchErr)
					if err := e.store.UpdateWorkflowRun(ctx, run); err != nil {
						return nil, err
					}
					_ = e.dlqMgr.PushToDLQ(ctx, &DLQItem{
						DLQID:               newUUID(),
						QueueName:           "workflow_runs",
						OriginalMessageID:   runID,
						Payload:             run.TriggerEvent,
						ErrorClass:          "ACTION_EFFECT_UNCERTAIN",
						ErrorMessage:        dispatchErr.Error(),
						LastErrorAt:         now,
						AttemptCount:        1,
						WorkspaceID:         workspaceID,
						Status:              "pending",
						SuggestedRepairPath: "Reconcile external action outcome before resuming or retrying run.",
						CreatedAt:           now,
					})
					return run, ErrUncertainStepEffect
				}

				runningStep.Status = "failed"
				runningStep.OutputSnapshot = fmt.Sprintf(`{"error":%q}`, dispatchErr.Error())
				runningStep.CompletedAt = &now
				runningStep.UpdatedAt = now
				if err := e.store.UpdateWorkflowRunStep(ctx, runningStep); err != nil {
					return nil, fmt.Errorf("persist failed action step: %w", err)
				}
				if hasFallbackBranch {
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
				StepID:          stepID,
				NodeID:          node.NodeID,
				Actor:           actorUserID,
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
			runningStep.Status = "succeeded"
			runningStep.OutputSnapshot = string(outBytes)
			runningStep.SideEffectRefs = []string{sideEffectID}
			runningStep.CompletedAt = &now
			runningStep.UpdatedAt = now
			if err := e.store.UpdateWorkflowRunStep(ctx, runningStep); err != nil {
				return nil, fmt.Errorf("persist post-dispatch succeeded step: %w", err)
			}
			existingSteps[len(existingSteps)-1] = *runningStep
			completedSteps[node.NodeID] = runningStep
			if err := e.store.UpdateWorkflowRun(ctx, run); err != nil {
				return nil, fmt.Errorf("persist workflow run after action: %w", err)
			}

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
				if sigReqID, ok := signal.Payload["approval_request_id"].(string); ok && strings.TrimSpace(sigReqID) != "" {
					sigReq, rErr := e.store.GetApprovalRequest(ctx, workspaceID, strings.TrimSpace(sigReqID))
					if rErr != nil || sigReq == nil {
						return nil, fmt.Errorf("%w: approval request %s not found for gate %s", ErrUnauthorized, sigReqID, node.NodeID)
					}
					hydrateApprovalMetadata(sigReq)
					if sigReq.Status != "approved" || sigReq.ObjectID != runID {
						return nil, fmt.Errorf("%w: approval request %s is not valid for run %s", ErrUnauthorized, sigReqID, runID)
					}
					if strings.TrimSpace(sigReq.ConsumedByNodeID) != "" || strings.TrimSpace(sigReq.ConsumedByStepID) != "" {
						return nil, fmt.Errorf("%w: approval request %s has already been consumed", ErrUnauthorized, sigReqID)
					}
					if strings.TrimSpace(sigReq.NodeID) != "" && sigReq.NodeID != node.NodeID {
						return nil, fmt.Errorf("%w: approval request %s belongs to gate %s, cannot resume gate %s", ErrUnauthorized, sigReqID, sigReq.NodeID, node.NodeID)
					}
				}
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

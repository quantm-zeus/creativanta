package workflow

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"
)

// ComputeActionHash generates a deterministic SHA-256 digest over the action's execution parameters.
// If inputs, target objects, budget quote, or workflow version change, the hash changes,
// invalidating any pending approval per workflow_studio.md lines 209-211.
func ComputeActionHash(
	workflowVersion int32,
	nodeID, rpcName, inputJSON string,
	targetObjects []string,
	maxBudgetQuote float64,
) string {
	sortedTargets := make([]string, len(targetObjects))
	copy(sortedTargets, targetObjects)
	sort.Strings(sortedTargets)

	canonicalInput := strings.TrimSpace(inputJSON)
	var compactBuf strings.Builder
	var obj any
	if err := json.Unmarshal([]byte(canonicalInput), &obj); err == nil {
		if norm, err := json.Marshal(obj); err == nil {
			compactBuf.Write(norm)
		} else {
			compactBuf.WriteString(canonicalInput)
		}
	} else {
		compactBuf.WriteString(canonicalInput)
	}

	payload := fmt.Sprintf("v=%d|node=%s|rpc=%s|input=%s|targets=%s|quote=%.2f",
		workflowVersion,
		strings.TrimSpace(nodeID),
		strings.TrimSpace(rpcName),
		compactBuf.String(),
		strings.Join(sortedTargets, ","),
		maxBudgetQuote,
	)

	h := sha256.Sum256([]byte(payload))
	return hex.EncodeToString(h[:])
}

// ApprovalManager manages approval gates, validation, invalidation, and expiry.
type ApprovalManager struct {
	mu     sync.Mutex
	store  Store
	engine WorkflowExecutor
}

// WorkflowExecutor abstracts resuming execution from the approval manager.
type WorkflowExecutor interface {
	ResumeRun(ctx context.Context, workspaceID, runID string, signal *ResumeSignal) (*WorkflowRun, error)
	RouteToFallback(ctx context.Context, workspaceID, runID, reason string) (*WorkflowRun, error)
	FailRunWithDiagnostics(ctx context.Context, workspaceID, runID string, diag *DiagnosticsRecord) (*WorkflowRun, error)
}

func NewApprovalManager(store Store, engine WorkflowExecutor) *ApprovalManager {
	return &ApprovalManager{
		store:  store,
		engine: engine,
	}
}

// CreateApprovalRequest creates and binds a new approval request at an approval node.
func (am *ApprovalManager) CreateApprovalRequest(
	ctx context.Context,
	caller CallerContext,
	wf *Workflow,
	run *WorkflowRun,
	node *WorkflowNode,
	actionNode *WorkflowNode,
	targetObjects []string,
) (*ApprovalRequest, error) {
	now := time.Now().UTC()
	var durationSec int64 = 86400 // default 24h
	if node.ApprovalConfig != nil && node.ApprovalConfig.ExpiresAtDurationSeconds > 0 {
		durationSec = node.ApprovalConfig.ExpiresAtDurationSeconds
	}
	expiresAt := now.Add(time.Duration(durationSec) * time.Second)

	rpcName := ""
	inputJSON := "{}"
	var budgetQuote float64 = 1.0
	if actionNode != nil {
		if actionNode.ActionConfig != nil {
			rpcName = actionNode.ActionConfig.RPCName
			inputJSON = actionNode.ActionConfig.InputJSON
		}
		budgetQuote = estimateActionCredits(rpcName)
	}

	actionHash := ComputeActionHash(wf.Version, node.NodeID, rpcName, inputJSON, targetObjects, budgetQuote)

	appCfg := node.ApprovalConfig
	if appCfg == nil {
		appCfg = parseApprovalConfigFromMap(node.Config)
	}
	var approverIDs []string
	requiredApprovals := 1
	if appCfg != nil {
		for _, id := range appCfg.ApproverIDs {
			if trimmed := strings.TrimSpace(id); trimmed != "" {
				approverIDs = append(approverIDs, trimmed)
			}
		}
		if appCfg.RequiredApprovals > 0 {
			requiredApprovals = appCfg.RequiredApprovals
		}
	}

	reasonMeta := map[string]any{
		"workflow_id":        wf.WorkflowID,
		"node_id":            node.NodeID,
		"workflow_version":   wf.Version,
		"action_hash":        actionHash,
		"target_objects":     targetObjects,
		"input_snapshot":     inputJSON,
		"budget_quote":       budgetQuote,
		"node_title":         node.Title,
		"approver_ids":       approverIDs,
		"required_approvals": requiredApprovals,
		"approved_by_ids":    []string{},
	}
	reasonBytes, _ := json.Marshal(reasonMeta)

	req := &ApprovalRequest{
		RequestID:         newUUID(),
		WorkspaceID:       caller.WorkspaceID,
		RequestType:       "workflow_approval",
		ObjectType:        "workflow_run",
		ObjectID:          run.RunID,
		RequestedBy:       caller.UserID,
		Status:            "pending_approval",
		Reason:            string(reasonBytes),
		ExpiresAt:         &expiresAt,
		WorkflowID:        wf.WorkflowID,
		NodeID:            node.NodeID,
		WorkflowVersion:   wf.Version,
		ActionHash:        actionHash,
		TargetObjects:     targetObjects,
		InputSnapshot:     inputJSON,
		MaxBudgetQuote:    budgetQuote,
		ApproverIDs:       approverIDs,
		RequiredApprovals: requiredApprovals,
		ApprovedByIDs:     []string{},
		CreatedAt:         now,
		UpdatedAt:         now,
	}

	if err := am.store.CreateApprovalRequest(ctx, req); err != nil {
		return nil, err
	}
	return req, nil
}

func hydrateApprovalMetadata(req *ApprovalRequest) {
	if req == nil || req.Reason == "" {
		return
	}
	var meta map[string]any
	if err := json.Unmarshal([]byte(req.Reason), &meta); err != nil {
		return
	}
	if req.WorkflowID == "" {
		if v, ok := meta["workflow_id"].(string); ok {
			req.WorkflowID = v
		}
	}
	if req.NodeID == "" {
		if v, ok := meta["node_id"].(string); ok {
			req.NodeID = v
		}
	}
	if req.WorkflowVersion == 0 {
		if v, ok := meta["workflow_version"].(float64); ok {
			req.WorkflowVersion = int32(v)
		}
	}
	if req.ActionHash == "" {
		if v, ok := meta["action_hash"].(string); ok {
			req.ActionHash = v
		}
	}
	if req.InputSnapshot == "" {
		if v, ok := meta["input_snapshot"].(string); ok {
			req.InputSnapshot = v
		}
	}
	if req.MaxBudgetQuote == 0 {
		if v, ok := meta["budget_quote"].(float64); ok {
			req.MaxBudgetQuote = v
		}
	}
	if len(req.TargetObjects) == 0 {
		if arr, ok := meta["target_objects"].([]any); ok {
			for _, item := range arr {
				if s, ok := item.(string); ok {
					req.TargetObjects = append(req.TargetObjects, s)
				}
			}
		}
	}
	if len(req.ApproverIDs) == 0 {
		if arr, ok := meta["approver_ids"].([]any); ok {
			for _, item := range arr {
				if s, ok := item.(string); ok && strings.TrimSpace(s) != "" {
					req.ApproverIDs = append(req.ApproverIDs, strings.TrimSpace(s))
				}
			}
		}
	}
	if req.RequiredApprovals <= 0 {
		if v, ok := meta["required_approvals"].(float64); ok && int(v) > 0 {
			req.RequiredApprovals = int(v)
		}
	}
	if len(req.ApprovedByIDs) == 0 {
		if arr, ok := meta["approved_by_ids"].([]any); ok {
			for _, item := range arr {
				if s, ok := item.(string); ok && strings.TrimSpace(s) != "" {
					req.ApprovedByIDs = append(req.ApprovedByIDs, strings.TrimSpace(s))
				}
			}
		}
	}
}

func syncApprovalMetadataToReason(req *ApprovalRequest) {
	if req == nil {
		return
	}
	meta := make(map[string]any)
	if req.Reason != "" {
		_ = json.Unmarshal([]byte(req.Reason), &meta)
	}
	meta["workflow_id"] = req.WorkflowID
	meta["node_id"] = req.NodeID
	meta["workflow_version"] = req.WorkflowVersion
	meta["action_hash"] = req.ActionHash
	meta["target_objects"] = req.TargetObjects
	meta["input_snapshot"] = req.InputSnapshot
	meta["budget_quote"] = req.MaxBudgetQuote
	meta["approver_ids"] = req.ApproverIDs
	meta["required_approvals"] = req.RequiredApprovals
	meta["approved_by_ids"] = req.ApprovedByIDs
	if b, err := json.Marshal(meta); err == nil {
		req.Reason = string(b)
	}
}

func (am *ApprovalManager) GetApprovalRequest(ctx context.Context, workspaceID, requestID string) (*ApprovalRequest, error) {
	return am.store.GetApprovalRequest(ctx, workspaceID, requestID)
}

func (am *ApprovalManager) FindPendingApprovalsByRun(ctx context.Context, workspaceID, runID string) ([]ApprovalRequest, error) {
	return am.store.FindPendingApprovalsByRun(ctx, workspaceID, runID)
}

// InvalidatePendingApprovals marks all pending approvals for a workflow as cancelled/invalidated.
// Triggered when an operator edits the workflow graph or action configurations.
func (am *ApprovalManager) InvalidatePendingApprovals(
	ctx context.Context,
	workspaceID, workflowID, reason string,
) error {
	approvals, err := am.store.FindPendingApprovalsByWorkflow(ctx, workspaceID, workflowID)
	if err != nil {
		return err
	}
	now := time.Now().UTC()
	for i := range approvals {
		app := &approvals[i]
		app.Status = "cancelled"
		app.RejectionReason = reason
		app.UpdatedAt = now
		if err := am.store.UpdateApprovalRequest(ctx, app); err != nil {
			return err
		}
	}
	return nil
}

// Approve validates the approval request, checks that action/inputs have NOT changed,
// sets approved status, and resumes the workflow execution.
func (am *ApprovalManager) Approve(
	ctx context.Context,
	caller CallerContext,
	requestID string,
) (*ApprovalRequest, *WorkflowRun, error) {
	if err := checkPerm(caller, "workflow_run:approve"); err != nil {
		return nil, nil, fmt.Errorf("%w: %v", ErrApprovalUnauthorized, err)
	}

	am.mu.Lock()
	locked := true
	defer func() {
		if locked {
			am.mu.Unlock()
		}
	}()

	req, err := am.store.GetApprovalRequest(ctx, caller.WorkspaceID, requestID)
	if err != nil {
		return nil, nil, err
	}
	hydrateApprovalMetadata(req)

	if req.Status != "pending_approval" {
		return nil, nil, fmt.Errorf("%w: current status is %s", ErrInvalidApprovalState, req.Status)
	}

	now := time.Now().UTC()
	if req.ExpiresAt != nil && now.After(*req.ExpiresAt) {
		req.Status = "expired"
		req.RejectionReason = "Approval timed out"
		req.UpdatedAt = now
		_ = am.store.UpdateApprovalRequest(ctx, req)
		return nil, nil, ErrApprovalExpired
	}

	// Verify action hash has not changed (Acceptance Target: Changed action invalidates approval)
	wf, err := am.store.GetWorkflow(ctx, caller.WorkspaceID, req.WorkflowID)
	if err != nil {
		return nil, nil, fmt.Errorf("lookup workflow for approval validation failed: %w", err)
	}

	// If workflow version changed since approval was requested -> INVALIDATED!
	if wf.Version != req.WorkflowVersion {
		req.Status = "cancelled"
		req.RejectionReason = fmt.Sprintf("Workflow version changed from %d to %d after approval requested", req.WorkflowVersion, wf.Version)
		req.UpdatedAt = now
		_ = am.store.UpdateApprovalRequest(ctx, req)
		return nil, nil, ErrApprovalInvalidated
	}

	// Recheck node in current graph
	var targetNode *WorkflowNode
	for i := range wf.ActionChain.Nodes {
		if wf.ActionChain.Nodes[i].NodeID == req.NodeID {
			targetNode = &wf.ActionChain.Nodes[i]
			break
		}
	}
	if targetNode == nil {
		req.Status = "cancelled"
		req.RejectionReason = "Approval node removed from workflow"
		req.UpdatedAt = now
		_ = am.store.UpdateApprovalRequest(ctx, req)
		return nil, nil, ErrApprovalInvalidated
	}

	// Hydrate approver configuration from targetNode if not already populated on req
	appCfg := targetNode.ApprovalConfig
	if appCfg == nil {
		appCfg = parseApprovalConfigFromMap(targetNode.Config)
	}
	if appCfg != nil {
		if len(req.ApproverIDs) == 0 && len(appCfg.ApproverIDs) > 0 {
			for _, id := range appCfg.ApproverIDs {
				if trimmed := strings.TrimSpace(id); trimmed != "" {
					req.ApproverIDs = append(req.ApproverIDs, trimmed)
				}
			}
		}
		if req.RequiredApprovals <= 0 && appCfg.RequiredApprovals > 0 {
			req.RequiredApprovals = appCfg.RequiredApprovals
		}
	}

	// Enforce ApproverIDs allowlist (AI-11)
	if len(req.ApproverIDs) > 0 {
		allowed := false
		for _, id := range req.ApproverIDs {
			if id == caller.UserID {
				allowed = true
				break
			}
		}
		if !allowed {
			return nil, nil, fmt.Errorf("%w: user %q is not in configured approver_ids", ErrApprovalUnauthorized, caller.UserID)
		}
	}

	// Enforce duplicate vote prevention (AI-11)
	for _, votedID := range req.ApprovedByIDs {
		if votedID == caller.UserID {
			return nil, nil, fmt.Errorf("%w: user %q has already approved request %s", ErrDuplicateApprovalVote, caller.UserID, req.RequestID)
		}
	}

	// Check if the next action node configuration or target objects changed
	currentActionHash := req.ActionHash
	for _, edge := range wf.ActionChain.Edges {
		if edge.FromNodeID == req.NodeID {
			for _, n := range wf.ActionChain.Nodes {
				if n.NodeID == edge.ToNodeID && n.NodeType == NodeTypeAction {
					cfg := n.ActionConfig
					if cfg == nil {
						cfg = parseActionConfigFromMap(n.Config)
					}
					rpc := ""
					input := "{}"
					if cfg != nil {
						rpc = cfg.RPCName
						input = cfg.InputJSON
					}
					currentActionHash = ComputeActionHash(wf.Version, req.NodeID, rpc, input, req.TargetObjects, req.MaxBudgetQuote)
					break
				}
			}
			break
		}
	}

	if currentActionHash != req.ActionHash {
		req.Status = "cancelled"
		req.RejectionReason = "Action configuration, target objects, or inputs modified after approval requested"
		req.UpdatedAt = now
		_ = am.store.UpdateApprovalRequest(ctx, req)
		return nil, nil, ErrApprovalInvalidated
	}

	req.ApprovedByIDs = append(req.ApprovedByIDs, caller.UserID)
	req.ApprovedBy = caller.UserID
	req.UpdatedAt = now

	requiredQuorum := req.RequiredApprovals
	if requiredQuorum <= 0 {
		requiredQuorum = 1
	}

	// If multi-approver quorum is not yet reached, keep request pending_approval and do NOT resume run (AI-11).
	if len(req.ApprovedByIDs) < requiredQuorum {
		req.Status = "pending_approval"
		syncApprovalMetadataToReason(req)
		if err := am.store.UpdateApprovalRequest(ctx, req); err != nil {
			return nil, nil, err
		}
		return req, nil, nil
	}

	// Quorum reached -> Mark approved
	req.Status = "approved"
	syncApprovalMetadataToReason(req)
	if err := am.store.UpdateApprovalRequest(ctx, req); err != nil {
		return nil, nil, err
	}

	locked = false
	am.mu.Unlock()

	// Resume workflow execution!
	var resumedRun *WorkflowRun
	if am.engine != nil {
		resumedRun, err = am.engine.ResumeRun(ctx, caller.WorkspaceID, req.ObjectID, &ResumeSignal{
			SignalType: "approval_granted",
			Payload: map[string]any{
				"approval_request_id": req.RequestID,
				"approved_by":         caller.UserID,
				"approved_by_ids":     req.ApprovedByIDs,
				"approved_at":         now.Format(time.RFC3339),
			},
		})
		if err != nil {
			return req, nil, fmt.Errorf("resuming run after approval: %w", err)
		}
	}

	return req, resumedRun, nil
}

// Reject rejects the approval request and routes the run to reject/fallback or fails it.
func (am *ApprovalManager) Reject(
	ctx context.Context,
	caller CallerContext,
	requestID, reason string,
) (*ApprovalRequest, *WorkflowRun, error) {
	if err := checkPerm(caller, "workflow_run:approve"); err != nil {
		return nil, nil, fmt.Errorf("%w: %v", ErrApprovalUnauthorized, err)
	}

	req, err := am.store.GetApprovalRequest(ctx, caller.WorkspaceID, requestID)
	if err != nil {
		return nil, nil, err
	}

	if req.Status != "pending_approval" {
		return nil, nil, fmt.Errorf("%w: current status is %s", ErrInvalidApprovalState, req.Status)
	}

	now := time.Now().UTC()
	req.Status = "rejected"
	req.ApprovedBy = caller.UserID
	req.RejectionReason = reason
	req.UpdatedAt = now

	if err := am.store.UpdateApprovalRequest(ctx, req); err != nil {
		return nil, nil, err
	}

	var run *WorkflowRun
	if am.engine != nil {
		// Attempt fallback route first; if no fallback, fail with diagnostics
		run, err = am.engine.RouteToFallback(ctx, caller.WorkspaceID, req.ObjectID, fmt.Sprintf("Approval rejected: %s", reason))
		if err != nil {
			// Fail with diagnostics
			diag := &DiagnosticsRecord{
				RecordID:              newUUID(),
				WorkspaceID:           caller.WorkspaceID,
				RunID:                 req.ObjectID,
				FailureType:           "APPROVAL_REJECTED",
				AffectedNodeID:        req.NodeID,
				AffectedNodeType:      NodeTypeApproval,
				UserFacingExplanation: fmt.Sprintf("Action was rejected during approval review: %s", reason),
				OperatorExplanation:   fmt.Sprintf("Approval request %s rejected by %s: %s", req.RequestID, caller.UserID, reason),
				RecommendedNextStep:   "Adjust the workflow inputs or seek approval from an authorized manager.",
				FallbackAvailable:     false,
				CreatedAt:             now,
			}
			run, _ = am.engine.FailRunWithDiagnostics(ctx, caller.WorkspaceID, req.ObjectID, diag)
		}
	}

	return req, run, nil
}

// EvaluateApprovalExpiry checks all pending approvals and auto-denies expired ones per RULE-M20-004.
func (am *ApprovalManager) EvaluateApprovalExpiry(ctx context.Context, workspaceID string) ([]ApprovalRequest, error) {
	approvals, _, err := am.store.ListApprovalRequests(ctx, workspaceID, ApprovalFilter{Status: "pending_approval", Limit: 1000})
	if err != nil {
		return nil, err
	}

	now := time.Now().UTC()
	var expired []ApprovalRequest

	for i := range approvals {
		app := &approvals[i]
		if app.ExpiresAt != nil && now.After(*app.ExpiresAt) {
			app.Status = "expired"
			app.RejectionReason = "Approval timed out"
			app.UpdatedAt = now
			_ = am.store.UpdateApprovalRequest(ctx, app)
			expired = append(expired, *app)

			if am.engine != nil {
				_, fallbackErr := am.engine.RouteToFallback(ctx, workspaceID, app.ObjectID, "Approval timed out")
				if fallbackErr != nil {
					diag := &DiagnosticsRecord{
						RecordID:              newUUID(),
						WorkspaceID:           workspaceID,
						RunID:                 app.ObjectID,
						FailureType:           "APPROVAL_EXPIRED",
						AffectedNodeID:        app.NodeID,
						AffectedNodeType:      NodeTypeApproval,
						UserFacingExplanation: "Approval request timed out after the deadline. Action was automatically denied.",
						OperatorExplanation:   fmt.Sprintf("Approval request %s expired at %s", app.RequestID, app.ExpiresAt.Format(time.RFC3339)),
						RecommendedNextStep:   "Trigger a fresh workflow run if this operation is still needed.",
						FallbackAvailable:     false,
						CreatedAt:             now,
					}
					_, _ = am.engine.FailRunWithDiagnostics(ctx, workspaceID, app.ObjectID, diag)
				}
			}
		}
	}

	return expired, nil
}

// BatchApprove processes multiple approval requests in batch.
func (am *ApprovalManager) BatchApprove(
	ctx context.Context,
	caller CallerContext,
	requestIDs []string,
) ([]*ApprovalRequest, []error) {
	var succeeded []*ApprovalRequest
	var errs []error
	for _, id := range requestIDs {
		req, _, err := am.Approve(ctx, caller, id)
		if err != nil {
			errs = append(errs, fmt.Errorf("approval %s: %w", id, err))
		} else {
			succeeded = append(succeeded, req)
		}
	}
	return succeeded, errs
}

// UndoApprove reverts an approved request if the action has not yet committed.
func (am *ApprovalManager) UndoApprove(
	ctx context.Context,
	caller CallerContext,
	requestID string,
) (*ApprovalRequest, error) {
	if err := checkPerm(caller, "workflow_run:approve"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrApprovalUnauthorized, err)
	}
	req, err := am.store.GetApprovalRequest(ctx, caller.WorkspaceID, requestID)
	if err != nil {
		return nil, err
	}
	if req.Status != "approved" {
		return nil, fmt.Errorf("%w: only approved requests can be reverted to pending", ErrInvalidApprovalState)
	}

	// Verify run state: if run has already succeeded, cannot undo approval
	run, err := am.store.GetWorkflowRun(ctx, caller.WorkspaceID, req.ObjectID)
	if err == nil && run != nil && (run.Status == WorkflowRunStatusSucceeded || run.Status == WorkflowRunStatusFailed) {
		return nil, fmt.Errorf("%w: workflow run already finalized in state %s", ErrInvalidRunState, run.Status)
	}

	now := time.Now().UTC()
	req.Status = "pending_approval"
	req.ApprovedBy = ""
	req.ApprovedByIDs = nil
	req.UpdatedAt = now
	syncApprovalMetadataToReason(req)
	if err := am.store.UpdateApprovalRequest(ctx, req); err != nil {
		return nil, err
	}
	return req, nil
}

// UndoReject reverts a rejected request back to pending.
func (am *ApprovalManager) UndoReject(
	ctx context.Context,
	caller CallerContext,
	requestID string,
) (*ApprovalRequest, error) {
	if err := checkPerm(caller, "workflow_run:approve"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrApprovalUnauthorized, err)
	}
	req, err := am.store.GetApprovalRequest(ctx, caller.WorkspaceID, requestID)
	if err != nil {
		return nil, err
	}
	if req.Status != "rejected" {
		return nil, fmt.Errorf("%w: only rejected requests can be reverted to pending", ErrInvalidApprovalState)
	}

	now := time.Now().UTC()
	req.Status = "pending_approval"
	req.RejectionReason = ""
	req.UpdatedAt = now
	if err := am.store.UpdateApprovalRequest(ctx, req); err != nil {
		return nil, err
	}
	return req, nil
}

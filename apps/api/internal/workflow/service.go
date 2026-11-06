package workflow

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string // owner, admin, manager, editor, contributor, member, viewer
}

type Service struct {
	store       Store
	adapter     WorkflowEngineAdapter
	engine      *ExecutionEngine
	approvalMgr *ApprovalManager
	dlqMgr      *DLQManager
	preflight   *PreflightEngine
	capProvider CapabilityStatusProvider
	dispatcher  ActionDispatcher
	tierChecker TierLimitChecker
}

func NewService(store Store, adapter WorkflowEngineAdapter) *Service {
	if adapter == nil {
		adapter = NewOwnedWorkflowEngine()
	}
	capProvider := NewDefaultCapabilityProvider()
	// Do NOT default dispatcher to NewMockActionDispatcher() (AI-04 / R07 fail-closed contract).
	var dispatcher ActionDispatcher
	engine := NewExecutionEngine(store, capProvider, dispatcher)
	preflight := NewPreflightEngine(capProvider)

	return &Service{
		store:       store,
		adapter:     adapter,
		engine:      engine,
		approvalMgr: engine.ApprovalManager(),
		dlqMgr:      engine.DLQManager(),
		preflight:   preflight,
		capProvider: capProvider,
		dispatcher:  dispatcher,
	}
}

func (s *Service) SetCapabilityProvider(cp CapabilityStatusProvider) {
	s.capProvider = cp
	s.engine = NewExecutionEngine(s.store, cp, s.dispatcher)
	s.engine.SetTierLimitChecker(s.tierChecker)
	s.approvalMgr = s.engine.ApprovalManager()
	s.preflight = NewPreflightEngine(cp)
}

func (s *Service) SetActionDispatcher(ad ActionDispatcher) {
	s.dispatcher = ad
	s.engine = NewExecutionEngine(s.store, s.capProvider, ad)
	s.engine.SetTierLimitChecker(s.tierChecker)
	s.approvalMgr = s.engine.ApprovalManager()
}

func (s *Service) SetTierLimitChecker(tc TierLimitChecker) {
	s.tierChecker = tc
	if s.engine != nil {
		s.engine.SetTierLimitChecker(tc)
	}
}

func (s *Service) Engine() *ExecutionEngine {
	return s.engine
}

func (s *Service) ApprovalManager() *ApprovalManager {
	return s.approvalMgr
}

func (s *Service) DLQManager() *DLQManager {
	return s.dlqMgr
}

func (s *Service) PreflightEngine() *PreflightEngine {
	return s.preflight
}

func checkPerm(caller CallerContext, perm string) error {
	return rbac.CheckWorkspacePermission(perm, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

// ----------------------------------------------------------------------------
// Core Workflow CRUD & Lifecycle
// ----------------------------------------------------------------------------

func (s *Service) CreateWorkflow(
	ctx context.Context,
	caller CallerContext,
	title, description, wfType string,
	trigger TriggerConfig,
	chain WorkflowGraph,
	approvalReqs []string,
) (*Workflow, error) {
	if err := checkPerm(caller, "workflow:create"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	if strings.TrimSpace(title) == "" {
		return nil, fmt.Errorf("%w: title cannot be empty", ErrInvalidGraphStructure)
	}

	if err := ValidateWorkflowGraph(&chain); err != nil {
		return nil, err
	}

	if wfType == "" {
		wfType = "custom"
	}
	if approvalReqs == nil {
		approvalReqs = []string{}
	}

	now := time.Now().UTC()
	wf := &Workflow{
		WorkflowID:           newUUID(),
		WorkspaceID:          caller.WorkspaceID,
		Title:                title,
		Description:          description,
		WorkflowType:         wfType,
		Status:               WorkflowStatusDraft,
		Version:              1,
		TriggerConfig:        trigger,
		ActionChain:          chain,
		ApprovalRequirements: approvalReqs,
		TierLimitCheck:       true,
		RunCount:             0,
		CreatedBy:            caller.UserID,
		CreatedAt:            now,
		UpdatedAt:            now,
	}

	if err := s.store.CreateWorkflow(ctx, wf); err != nil {
		return nil, err
	}
	return wf, nil
}

func (s *Service) GetWorkflow(ctx context.Context, caller CallerContext, workflowID string) (*Workflow, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	return s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
}

func (s *Service) ListWorkflows(ctx context.Context, caller CallerContext, status string, limit, offset int) ([]Workflow, int, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, 0, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	return s.store.ListWorkflows(ctx, caller.WorkspaceID, status, limit, offset)
}

func (s *Service) UpdateWorkflow(
	ctx context.Context,
	caller CallerContext,
	workflowID, title, description string,
	trigger TriggerConfig,
	chain WorkflowGraph,
	approvalReqs []string,
	expectedVersion int32,
) (*Workflow, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	existing, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
	if err != nil {
		return nil, err
	}
	if existing.Status == WorkflowStatusArchived {
		return nil, fmt.Errorf("%w: cannot edit archived workflow", ErrInvalidWorkflowState)
	}

	if err := ValidateWorkflowGraph(&chain); err != nil {
		return nil, err
	}

	if err := IncrementVersion(existing, expectedVersion); err != nil {
		return nil, err
	}

	if title != "" {
		existing.Title = title
	}
	existing.Description = description
	existing.TriggerConfig = trigger
	existing.ActionChain = chain
	if approvalReqs != nil {
		existing.ApprovalRequirements = approvalReqs
	}

	if err := s.store.UpdateWorkflow(ctx, existing); err != nil {
		return nil, err
	}

	// Acceptance Target 2: Changed action / workflow invalidates pending approval
	if s.approvalMgr != nil {
		_ = s.approvalMgr.InvalidatePendingApprovals(ctx, caller.WorkspaceID, existing.WorkflowID, "Workflow updated to a new version")
	}

	return existing, nil
}

func (s *Service) ActivateWorkflow(ctx context.Context, caller CallerContext, workflowID string) (*Workflow, error) {
	if err := checkPerm(caller, "workflow:activate"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	existing, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
	if err != nil {
		return nil, err
	}
	if existing.Status == WorkflowStatusArchived {
		return nil, fmt.Errorf("%w: cannot activate archived workflow", ErrInvalidWorkflowState)
	}

	// Validate graph before activation (must have trigger + at least 1 action node)
	if err := ValidateWorkflowGraph(&existing.ActionChain); err != nil {
		return nil, fmt.Errorf("activation validation failed: %w", err)
	}

	hasAction := false
	for _, n := range existing.ActionChain.Nodes {
		if n.NodeType == NodeTypeAction {
			hasAction = true
			break
		}
	}
	if !hasAction {
		return nil, fmt.Errorf("%w: active workflow must have at least one action node", ErrInvalidGraphStructure)
	}

	existing.Status = WorkflowStatusActive
	existing.UpdatedAt = time.Now().UTC()

	if err := s.store.UpdateWorkflow(ctx, existing); err != nil {
		return nil, err
	}

	// Invalidate any pending approvals if workflow deactivated
	if s.approvalMgr != nil {
		_ = s.approvalMgr.InvalidatePendingApprovals(ctx, caller.WorkspaceID, existing.WorkflowID, "Workflow paused/deactivated")
	}

	return existing, nil
}

func (s *Service) DeactivateWorkflow(ctx context.Context, caller CallerContext, workflowID string) (*Workflow, error) {
	if err := checkPerm(caller, "workflow:activate"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	existing, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
	if err != nil {
		return nil, err
	}
	if existing.Status == WorkflowStatusArchived {
		return nil, fmt.Errorf("%w: cannot deactivate archived workflow", ErrInvalidWorkflowState)
	}

	existing.Status = WorkflowStatusPaused
	existing.UpdatedAt = time.Now().UTC()

	if err := s.store.UpdateWorkflow(ctx, existing); err != nil {
		return nil, err
	}

	// Invalidate any pending approvals if workflow deactivated
	if s.approvalMgr != nil {
		_ = s.approvalMgr.InvalidatePendingApprovals(ctx, caller.WorkspaceID, existing.WorkflowID, "Workflow paused/deactivated")
	}

	return existing, nil
}

// ----------------------------------------------------------------------------
// Execution & Runs
// ----------------------------------------------------------------------------

func (s *Service) RunWorkflow(ctx context.Context, caller CallerContext, workflowID string, triggerContext map[string]any) (*WorkflowRun, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	ctx = WithStoreActorUserID(ctx, caller.UserID)

	wf, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
	if err != nil {
		return nil, err
	}
	if wf.Status != WorkflowStatusActive {
		return nil, fmt.Errorf("%w: cannot run workflow in status %s (must be active)", ErrInvalidWorkflowState, wf.Status)
	}
	if wf.TierLimitCheck && s.tierChecker != nil {
		if err := s.tierChecker.CheckTierLimit(ctx, caller.WorkspaceID, wf); err != nil {
			return nil, fmt.Errorf("%w: %v", ErrTierLimitExceeded, err)
		}
	}

	now := time.Now().UTC()
	runID := newUUID()
	var rootNodeID string
	var rootNodeType NodeType = NodeTypeTrigger
	for _, n := range wf.ActionChain.Nodes {
		if n.NodeType == NodeTypeTrigger {
			rootNodeID = n.NodeID
			rootNodeType = n.NodeType
			break
		}
	}
	if rootNodeID == "" && len(wf.ActionChain.Nodes) > 0 {
		rootNodeID = wf.ActionChain.Nodes[0].NodeID
		rootNodeType = wf.ActionChain.Nodes[0].NodeType
	}

	triggerCopy := make(map[string]any, len(triggerContext)+2)
	for k, v := range triggerContext {
		triggerCopy[k] = v
	}
	triggerCopy["_actor_user_id"] = caller.UserID
	triggerCopy["_actor_role"] = caller.WorkspaceRole

	run := &WorkflowRun{
		RunID:              runID,
		WorkspaceID:        caller.WorkspaceID,
		WorkflowID:         workflowID,
		TriggerEvent:       triggerCopy,
		InitiatedByUserID:  caller.UserID,
		InitiatedByRole:    caller.WorkspaceRole,
		Status:             WorkflowRunStatusQueued,
		CurrentNode:        rootNodeID,
		ExecutionLog:       []any{},
		AffectedObjectRefs: []any{},
		SideEffectsSummary: []any{},
		CreatedAt:          now,
		UpdatedAt:          now,
	}

	if err := s.store.CreateWorkflowRun(ctx, run); err != nil {
		return nil, err
	}

	if s.engine == nil && rootNodeID != "" {
		inputJSON, _ := json.Marshal(triggerContext)
		step := &WorkflowRunStep{
			StepID:        newUUID(),
			WorkspaceID:   caller.WorkspaceID,
			RunID:         runID,
			NodeID:        rootNodeID,
			NodeType:      rootNodeType,
			StepOrder:     1,
			Status:        "succeeded",
			InputSnapshot: string(inputJSON),
			StartedAt:     &now,
			CompletedAt:   &now,
			CreatedAt:     now,
			UpdatedAt:     now,
		}
		if err := s.store.CreateWorkflowRunStep(ctx, step); err != nil {
			return nil, err
		}
	}

	wf.RunCount++
	if err := s.store.UpdateWorkflow(ctx, wf); err != nil {
		return nil, err
	}

	if s.engine != nil {
		executedRun, err := s.engine.ExecuteRun(ctx, caller.WorkspaceID, run.RunID)
		if err != nil {
			return executedRun, err
		}
		if executedRun != nil {
			return executedRun, nil
		}
	}

	return run, nil
}

func (s *Service) GetRunDetail(ctx context.Context, caller CallerContext, runID string) (*WorkflowRun, []WorkflowRunStep, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	run, err := s.store.GetWorkflowRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, nil, err
	}
	steps, err := s.store.ListWorkflowRunSteps(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, nil, err
	}
	return run, steps, nil
}

func (s *Service) GetRunLogs(ctx context.Context, caller CallerContext, runID string) ([]any, []WorkflowRunStep, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	run, err := s.store.GetWorkflowRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, nil, err
	}
	steps, err := s.store.ListWorkflowRunSteps(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, nil, err
	}
	return run.ExecutionLog, steps, nil
}

func (s *Service) ListRuns(ctx context.Context, caller CallerContext, workflowID, status string, limit, offset int) ([]WorkflowRun, int, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, 0, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	return s.store.ListWorkflowRuns(ctx, caller.WorkspaceID, workflowID, status, limit, offset)
}

// ----------------------------------------------------------------------------
// Clone, Import, Export, Simulation (Dry Run)
// ----------------------------------------------------------------------------

func (s *Service) CloneWorkflow(ctx context.Context, caller CallerContext, workflowID, newTitle string) (*Workflow, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	existing, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
	if err != nil {
		return nil, err
	}
	cloned, err := CloneWorkflow(existing, newTitle)
	if err != nil {
		return nil, err
	}
	cloned.CreatedBy = caller.UserID
	if err := s.store.CreateWorkflow(ctx, cloned); err != nil {
		return nil, err
	}
	return cloned, nil
}

func (s *Service) ExportWorkflow(ctx context.Context, caller CallerContext, workflowID string) (*PortableWorkflowPayload, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	wf, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
	if err != nil {
		return nil, err
	}
	return ExportWorkflow(wf)
}

func (s *Service) ImportWorkflow(ctx context.Context, caller CallerContext, payload *PortableWorkflowPayload) (*Workflow, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	wf, err := ImportWorkflow(caller.WorkspaceID, payload)
	if err != nil {
		return nil, err
	}
	wf.CreatedBy = caller.UserID
	if err := s.store.CreateWorkflow(ctx, wf); err != nil {
		return nil, err
	}
	return wf, nil
}

func (s *Service) TestWorkflow(
	ctx context.Context,
	caller CallerContext,
	workflowID string,
	draftGraph *WorkflowGraph,
	sampleContext map[string]any,
) (*SimulationReport, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	var targetGraph *WorkflowGraph
	if draftGraph != nil && len(draftGraph.Nodes) > 0 {
		targetGraph = draftGraph
	} else if workflowID != "" {
		wf, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
		if err != nil {
			return nil, err
		}
		targetGraph = &wf.ActionChain
	} else {
		return nil, fmt.Errorf("%w: must provide draft_graph or workflow_id", ErrInvalidGraphStructure)
	}

	return s.adapter.SimulateWorkflow(ctx, targetGraph, sampleContext)
}

func (s *Service) GetRunStats(ctx context.Context, caller CallerContext, workflowID string) (total, successful, failed, pendingApprovals int, avgDurationSec float64, err error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return 0, 0, 0, 0, 0, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	runs, _, err := s.store.ListWorkflowRuns(ctx, caller.WorkspaceID, workflowID, "", 1000, 0)
	if err != nil {
		return 0, 0, 0, 0, 0, err
	}
	total = len(runs)
	var totalDur time.Duration
	var completedCount int

	for _, r := range runs {
		switch r.Status {
		case WorkflowRunStatusSucceeded:
			successful++
		case WorkflowRunStatusFailed:
			failed++
		case WorkflowRunStatusWaitingApproval:
			pendingApprovals++
		}
		if r.StartedAt != nil && r.CompletedAt != nil {
			totalDur += r.CompletedAt.Sub(*r.StartedAt)
			completedCount++
		}
	}
	if completedCount > 0 {
		avgDurationSec = totalDur.Seconds() / float64(completedCount)
	}
	return total, successful, failed, pendingApprovals, avgDurationSec, nil
}

func (s *Service) CancelRun(ctx context.Context, caller CallerContext, runID, reason string) (*WorkflowRun, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	run, err := s.store.GetWorkflowRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, err
	}
	if run.Status == WorkflowRunStatusSucceeded || run.Status == WorkflowRunStatusCancelled {
		return nil, fmt.Errorf("%w: cannot cancel run in state %s", ErrInvalidRunState, run.Status)
	}
	now := time.Now().UTC()
	run.Status = WorkflowRunStatusCancelled
	run.CompletedAt = &now
	run.UpdatedAt = now
	if run.ResultSummary == nil {
		run.ResultSummary = make(map[string]any)
	}
	run.ResultSummary["cancellation_reason"] = reason

	if err := s.store.UpdateWorkflowRun(ctx, run); err != nil {
		return nil, err
	}
	return run, nil
}

func (s *Service) RetryRun(ctx context.Context, caller CallerContext, runID, repairContext string) (*WorkflowRun, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	run, err := s.store.GetWorkflowRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, err
	}
	if run.Status != WorkflowRunStatusFailed && run.Status != WorkflowRunStatusRequiresManualIntervention {
		return nil, fmt.Errorf("%w: only failed runs can be retried", ErrInvalidRunState)
	}
	now := time.Now().UTC()
	run.Status = WorkflowRunStatusQueued
	run.StartedAt = nil
	run.CompletedAt = nil
	run.UpdatedAt = now
	if repairContext != "" {
		if run.ResultSummary == nil {
			run.ResultSummary = make(map[string]any)
		}
		run.ResultSummary["repair_context"] = repairContext
	}
	if err := s.store.UpdateWorkflowRun(ctx, run); err != nil {
		return nil, err
	}

	if s.engine != nil {
		executedRun, err := s.engine.ResumeRun(ctx, caller.WorkspaceID, run.RunID, &ResumeSignal{
			SignalType: "run_retried",
			Payload:    map[string]any{"repair_context": repairContext},
		})
		if err != nil {
			return executedRun, err
		}
		if executedRun != nil {
			return executedRun, nil
		}
	}

	return run, nil
}

func (s *Service) DismissRun(ctx context.Context, caller CallerContext, runID, reason string) error {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	run, err := s.store.GetWorkflowRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return err
	}
	if run.ResultSummary == nil {
		run.ResultSummary = make(map[string]any)
	}
	run.ResultSummary["dismissed"] = true
	run.ResultSummary["dismissal_reason"] = reason
	run.UpdatedAt = time.Now().UTC()
	return s.store.UpdateWorkflowRun(ctx, run)
}

func (s *Service) SkipStep(ctx context.Context, caller CallerContext, runID, nodeID, reason string) (*WorkflowRunStep, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	steps, err := s.store.ListWorkflowRunSteps(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, err
	}
	now := time.Now().UTC()
	for i := range steps {
		st := &steps[i]
		if st.NodeID == nodeID {
			st.Status = "skipped"
			st.CompletedAt = &now
			st.UpdatedAt = now
			if err := s.store.UpdateWorkflowRunStep(ctx, st); err != nil {
				return nil, err
			}
			return st, nil
		}
	}
	// If not found in steps yet, create skipped step
	step := &WorkflowRunStep{
		StepID:         newUUID(),
		WorkspaceID:    caller.WorkspaceID,
		RunID:          runID,
		NodeID:         nodeID,
		NodeType:       NodeTypeAction,
		StepOrder:      int16(len(steps) + 1),
		Status:         "skipped",
		OutputSnapshot: fmt.Sprintf(`{"skipped_reason":%q}`, reason),
		CompletedAt:    &now,
		CreatedAt:      now,
		UpdatedAt:      now,
	}
	if err := s.store.CreateWorkflowRunStep(ctx, step); err != nil {
		return nil, err
	}
	return step, nil
}

func (s *Service) ProvideInput(ctx context.Context, caller CallerContext, runID, nodeID, inputJSON string) (*WorkflowRunStep, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	var testMap map[string]any
	if err := json.Unmarshal([]byte(inputJSON), &testMap); err != nil {
		return nil, fmt.Errorf("invalid input_json: %w", err)
	}
	now := time.Now().UTC()
	step := &WorkflowRunStep{
		StepID:        newUUID(),
		WorkspaceID:   caller.WorkspaceID,
		RunID:         runID,
		NodeID:        nodeID,
		NodeType:      NodeTypeApproval,
		StepOrder:     1,
		Status:        "succeeded",
		InputSnapshot: inputJSON,
		CompletedAt:   &now,
		CreatedAt:     now,
		UpdatedAt:     now,
	}
	if err := s.store.CreateWorkflowRunStep(ctx, step); err != nil {
		return nil, err
	}
	return step, nil
}

func (s *Service) ExportRuns(ctx context.Context, caller CallerContext, workflowID, format string) (string, string, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return "", "", fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	runs, _, err := s.store.ListWorkflowRuns(ctx, caller.WorkspaceID, workflowID, "", 1000, 0)
	if err != nil {
		return "", "", err
	}
	if strings.ToLower(format) == "csv" {
		var b strings.Builder
		b.WriteString("run_id,workflow_id,status,created_at\n")
		for _, r := range runs {
			b.WriteString(fmt.Sprintf("%s,%s,%s,%s\n", r.RunID, r.WorkflowID, r.Status, r.CreatedAt.Format(time.RFC3339)))
		}
		return "/exports/runs.csv", b.String(), nil
	}
	data, err := json.MarshalIndent(runs, "", "  ")
	if err != nil {
		return "", "", err
	}
	return "/exports/runs.json", string(data), nil
}

// ----------------------------------------------------------------------------
// P7-02: Preflight & Simulation (Target 1)
// ----------------------------------------------------------------------------

func (s *Service) PreflightWorkflow(
	ctx context.Context,
	caller CallerContext,
	workflowID string,
	draftGraph *WorkflowGraph,
) (*PreflightReport, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	var targetGraph *WorkflowGraph
	if draftGraph != nil && len(draftGraph.Nodes) > 0 {
		targetGraph = draftGraph
	} else if workflowID != "" {
		wf, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
		if err != nil {
			return nil, err
		}
		targetGraph = &wf.ActionChain
	} else {
		return nil, fmt.Errorf("%w: must provide workflow_id or draft_graph", ErrInvalidGraphStructure)
	}

	report, err := s.preflight.PreflightWorkflow(ctx, caller.WorkspaceID, targetGraph)
	if err != nil {
		return nil, err
	}
	report.WorkflowID = workflowID
	return report, nil
}

// ----------------------------------------------------------------------------
// P7-02: Resume Execution (Target 3: Resume never replays confirmed effect)
// ----------------------------------------------------------------------------

func (s *Service) ResumeRun(
	ctx context.Context,
	caller CallerContext,
	runID string,
	signal *ResumeSignal,
) (*WorkflowRun, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	if s.engine == nil {
		return nil, fmt.Errorf("runtime engine not initialized")
	}
	return s.engine.ResumeRun(ctx, caller.WorkspaceID, runID, signal)
}

// ----------------------------------------------------------------------------
// P7-02: ApprovalService (8 Canonical RPCs per rpc_permission_bindings.csv)
// ----------------------------------------------------------------------------

func (s *Service) ListApprovals(
	ctx context.Context,
	caller CallerContext,
	filter ApprovalFilter,
) ([]ApprovalRequest, int, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, 0, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	return s.store.ListApprovalRequests(ctx, caller.WorkspaceID, filter)
}

func (s *Service) ListPendingApprovals(
	ctx context.Context,
	caller CallerContext,
) ([]ApprovalRequest, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	filter := ApprovalFilter{Status: "pending_approval", Limit: 500}
	res, _, err := s.store.ListApprovalRequests(ctx, caller.WorkspaceID, filter)
	return res, err
}

func (s *Service) GetApprovalQueueStats(
	ctx context.Context,
	caller CallerContext,
) (*ApprovalQueueStats, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	all, _, err := s.store.ListApprovalRequests(ctx, caller.WorkspaceID, ApprovalFilter{Limit: 2000})
	if err != nil {
		return nil, err
	}
	stats := &ApprovalQueueStats{Total: len(all)}
	for _, a := range all {
		switch a.Status {
		case "pending_approval":
			stats.Pending++
		case "approved":
			stats.Approved++
		case "rejected":
			stats.Rejected++
		case "expired":
			stats.Expired++
		case "cancelled":
			stats.Cancelled++
		}
	}
	return stats, nil
}

func (s *Service) Approve(
	ctx context.Context,
	caller CallerContext,
	requestID string,
) (*ApprovalRequest, *WorkflowRun, error) {
	if s.approvalMgr == nil {
		return nil, nil, fmt.Errorf("approval manager not initialized")
	}
	return s.approvalMgr.Approve(ctx, caller, requestID)
}

func (s *Service) Reject(
	ctx context.Context,
	caller CallerContext,
	requestID, reason string,
) (*ApprovalRequest, *WorkflowRun, error) {
	if s.approvalMgr == nil {
		return nil, nil, fmt.Errorf("approval manager not initialized")
	}
	return s.approvalMgr.Reject(ctx, caller, requestID, reason)
}

func (s *Service) BatchApprove(
	ctx context.Context,
	caller CallerContext,
	requestIDs []string,
) ([]*ApprovalRequest, []error) {
	if s.approvalMgr == nil {
		return nil, []error{fmt.Errorf("approval manager not initialized")}
	}
	return s.approvalMgr.BatchApprove(ctx, caller, requestIDs)
}

func (s *Service) UndoApprove(
	ctx context.Context,
	caller CallerContext,
	requestID string,
) (*ApprovalRequest, error) {
	if s.approvalMgr == nil {
		return nil, fmt.Errorf("approval manager not initialized")
	}
	return s.approvalMgr.UndoApprove(ctx, caller, requestID)
}

func (s *Service) UndoReject(
	ctx context.Context,
	caller CallerContext,
	requestID string,
) (*ApprovalRequest, error) {
	if s.approvalMgr == nil {
		return nil, fmt.Errorf("approval manager not initialized")
	}
	return s.approvalMgr.UndoReject(ctx, caller, requestID)
}

func (s *Service) EvaluateApprovalExpiry(
	ctx context.Context,
	caller CallerContext,
) ([]ApprovalRequest, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	if s.approvalMgr == nil {
		return nil, fmt.Errorf("approval manager not initialized")
	}
	return s.approvalMgr.EvaluateApprovalExpiry(ctx, caller.WorkspaceID)
}

// ----------------------------------------------------------------------------
// P7-02: Dead-Letter Queue (DLQ) Management
// ----------------------------------------------------------------------------

func (s *Service) ListDLQ(
	ctx context.Context,
	caller CallerContext,
	status string,
	limit, offset int,
) ([]DLQItem, int, error) {
	if s.dlqMgr == nil {
		return nil, 0, fmt.Errorf("DLQ manager not initialized")
	}
	return s.dlqMgr.ListDLQItems(ctx, caller, status, limit, offset)
}

func (s *Service) GetDLQItem(
	ctx context.Context,
	caller CallerContext,
	dlqID string,
) (*DLQItem, error) {
	if s.dlqMgr == nil {
		return nil, fmt.Errorf("DLQ manager not initialized")
	}
	return s.dlqMgr.GetDLQItem(ctx, caller, dlqID)
}

func (s *Service) RetryDLQItem(
	ctx context.Context,
	caller CallerContext,
	dlqID string,
) (*WorkflowRun, error) {
	if s.dlqMgr == nil {
		return nil, fmt.Errorf("DLQ manager not initialized")
	}
	return s.dlqMgr.RetryDLQItem(ctx, caller, dlqID)
}

func (s *Service) RepairAndRetryDLQItem(
	ctx context.Context,
	caller CallerContext,
	dlqID string,
	repairContext map[string]any,
) (*WorkflowRun, error) {
	if s.dlqMgr == nil {
		return nil, fmt.Errorf("DLQ manager not initialized")
	}
	return s.dlqMgr.RepairAndRetryDLQItem(ctx, caller, dlqID, repairContext)
}

func (s *Service) DiscardDLQItem(
	ctx context.Context,
	caller CallerContext,
	dlqID string,
	reason string,
) (*DLQItem, error) {
	if s.dlqMgr == nil {
		return nil, fmt.Errorf("DLQ manager not initialized")
	}
	return s.dlqMgr.DiscardDLQItem(ctx, caller, dlqID, reason)
}

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
	store   Store
	adapter WorkflowEngineAdapter
}

func NewService(store Store, adapter WorkflowEngineAdapter) *Service {
	if adapter == nil {
		adapter = NewOwnedWorkflowEngine()
	}
	return &Service{
		store:   store,
		adapter: adapter,
	}
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
	return existing, nil
}

// ----------------------------------------------------------------------------
// Execution & Runs
// ----------------------------------------------------------------------------

func (s *Service) RunWorkflow(ctx context.Context, caller CallerContext, workflowID string, triggerContext map[string]any) (*WorkflowRun, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	wf, err := s.store.GetWorkflow(ctx, caller.WorkspaceID, workflowID)
	if err != nil {
		return nil, err
	}
	if wf.Status == WorkflowStatusArchived {
		return nil, fmt.Errorf("%w: cannot run archived workflow", ErrInvalidWorkflowState)
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

	run := &WorkflowRun{
		RunID:              runID,
		WorkspaceID:        caller.WorkspaceID,
		WorkflowID:         workflowID,
		TriggerEvent:       triggerContext,
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

	if rootNodeID != "" {
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
		_ = s.store.CreateWorkflowRunStep(ctx, step)
	}

	wf.RunCount++
	_ = s.store.UpdateWorkflow(ctx, wf)

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

package agent

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

type launchIdempotencyEntry struct {
	workspaceID      string
	idempotencyKey   string
	requestHash      string
	done             chan struct{}
	runID            string
	warnings         []string
	requiresApproval bool
	err              error
}

// Service provides high-level business logic for autonomous agent operations.
type Service struct {
	store             Store
	planner           *Planner
	runtime           *Runtime
	capabilities      map[string]bool // workspace capability map (defaults supported)
	execLocksMu       sync.Mutex
	runExecLocks      map[string]*sync.Mutex
	launchIdemMu      sync.Mutex
	launchIdemEntries map[string]*launchIdempotencyEntry
}

func NewService(store Store) *Service {
	return &Service{
		store:             store,
		planner:           NewPlanner(),
		runtime:           NewRuntime(store),
		runExecLocks:      make(map[string]*sync.Mutex),
		launchIdemEntries: make(map[string]*launchIdempotencyEntry),
		capabilities: map[string]bool{
			"ai.nlu":            true,
			"ai.vision":         true,
			"media.generation":  true,
			"media.tts":         true,
			"media.sound":       true,
			"media.render":      true,
			"commerce.catalog":  true,
			"media.image":       true,
			"publish.channel":   true,
			"shopee.order.sync": true,
			"tiktok.publish":    true,
		},
	}
}

// SetCapability allows test suites to inject missing/unsupported platform capabilities.
func (s *Service) SetCapability(key string, supported bool) {
	s.capabilities[key] = supported
}

// SetStepExecutor configures the concrete StepExecutor for autonomous step execution.
// When not set, step execution fails closed with ErrExecutorNotConfigured (AI-04 / R07).
func (s *Service) SetStepExecutor(executor StepExecutor) {
	s.runtime.SetStepExecutor(executor)
}

func (s *Service) SetMembershipRoleResolver(resolver MembershipRoleResolver) {
	s.runtime.SetMembershipRoleResolver(resolver)
}

func (s *Service) SetMemberRole(workspaceID, userID, role string, active bool) {
	if mut, ok := s.store.(WorkspaceMembershipMutator); ok && mut != nil {
		mut.SetMemberRole(workspaceID, userID, role, active)
	}
	s.runtime.SetMemberRole(workspaceID, userID, role, active)
}

func (s *Service) RevokeMemberAccess(workspaceID, userID string) {
	if mut, ok := s.store.(WorkspaceMembershipMutator); ok && mut != nil {
		mut.RevokeMemberAccess(workspaceID, userID)
	}
	s.runtime.SetMemberRole(workspaceID, userID, "", false)
}

func verifyCallerPrincipal(ctx context.Context, caller CallerContext) error {
	if strings.TrimSpace(caller.WorkspaceID) == "" {
		return ErrCrossTenantDenied
	}
	if p, ok := transportauth.PrincipalFromContext(ctx); ok {
		if p.WorkspaceID != caller.WorkspaceID {
			return ErrCrossTenantDenied
		}
		if p.UserID != "" && caller.UserID != "" && p.UserID != caller.UserID {
			return ErrCrossTenantDenied
		}
	}
	if scope, ok := tenantdb.ScopeFromContext(ctx); ok {
		if scope.WorkspaceID != "" && scope.WorkspaceID != caller.WorkspaceID {
			return ErrCrossTenantDenied
		}
		if scope.UserID != "" && caller.UserID != "" && scope.UserID != caller.UserID {
			return ErrCrossTenantDenied
		}
	}
	return nil
}

func computeLaunchAgentRequestHash(
	workspaceID, agentType, taskPrompt, recipeID, workflowID, budgetCeiling, executionScopeJSON string,
	autoExecute bool,
	params map[string]string,
) string {
	type kv struct {
		K string `json:"k"`
		V string `json:"v"`
	}
	var sortedParams []kv
	if len(params) > 0 {
		keys := make([]string, 0, len(params))
		for k := range params {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, k := range keys {
			sortedParams = append(sortedParams, kv{K: k, V: params[k]})
		}
	}
	payload := struct {
		WorkspaceID        string `json:"workspace_id"`
		AgentType          string `json:"agent_type"`
		TaskPrompt         string `json:"task_prompt"`
		RecipeID           string `json:"recipe_id"`
		WorkflowID         string `json:"workflow_id"`
		BudgetCeiling      string `json:"budget_ceiling"`
		ExecutionScopeJSON string `json:"execution_scope_json"`
		AutoExecute        bool   `json:"auto_execute"`
		Params             []kv   `json:"params,omitempty"`
	}{
		WorkspaceID:        strings.TrimSpace(workspaceID),
		AgentType:          strings.TrimSpace(agentType),
		TaskPrompt:         strings.TrimSpace(taskPrompt),
		RecipeID:           strings.TrimSpace(recipeID),
		WorkflowID:         strings.TrimSpace(workflowID),
		BudgetCeiling:      strings.TrimSpace(budgetCeiling),
		ExecutionScopeJSON: strings.TrimSpace(executionScopeJSON),
		AutoExecute:        autoExecute,
		Params:             sortedParams,
	}
	b, _ := json.Marshal(payload)
	sum := sha256.Sum256(b)
	return hex.EncodeToString(sum[:])
}

// LaunchAgent plans, preflights, and creates an agent run graph.
func (s *Service) LaunchAgent(
	ctx context.Context,
	caller CallerContext,
	agentType string,
	taskPrompt string,
	recipeID string,
	workflowID string,
	budgetCeiling string,
	executionScopeJSON string,
	autoExecute bool,
	params map[string]string,
) (retRun *AgentRun, retWarnings []string, retRequiresApproval bool, retErr error) {
	if err := verifyCallerPrincipal(ctx, caller); err != nil {
		return nil, nil, false, err
	}
	if !CheckPermission(caller.WorkspaceRole, "agent:execute") {
		return nil, nil, false, fmt.Errorf("%w: role %q cannot launch agent", ErrPermissionDenied, caller.WorkspaceRole)
	}

	if taskPrompt == "" {
		taskPrompt = "Execute autonomous task"
	}
	if agentType == "" {
		agentType = AgentTypeGeneric
	}

	if strings.TrimSpace(budgetCeiling) != "" {
		parsedCeiling, err := tenantdb.ParseExactDecimal(budgetCeiling)
		if err != nil || parsedCeiling.IsNegative() {
			return nil, nil, false, fmt.Errorf("%w: budget_ceiling must be a non-negative decimal", ErrInvalidBudgetCeiling)
		}
		if parsedCeiling.IsZero() {
			budgetCeiling = ""
		} else {
			budgetCeiling = parsedCeiling.Fixed6String()
		}
	}

	idemKey := strings.TrimSpace(LaunchIdempotencyKeyFromContext(ctx))
	if idemKey != "" {
		reqHash := computeLaunchAgentRequestHash(
			caller.WorkspaceID,
			agentType,
			taskPrompt,
			recipeID,
			workflowID,
			budgetCeiling,
			executionScopeJSON,
			autoExecute,
			params,
		)
		lookupKey := caller.WorkspaceID + "\x00" + idemKey

		s.launchIdemMu.Lock()
		if s.launchIdemEntries == nil {
			s.launchIdemEntries = make(map[string]*launchIdempotencyEntry)
		}
		if existing, ok := s.launchIdemEntries[lookupKey]; ok && existing != nil {
			if existing.requestHash != reqHash {
				s.launchIdemMu.Unlock()
				return nil, nil, false, ErrIdempotencyKeyConflict
			}
			s.launchIdemMu.Unlock()
			select {
			case <-existing.done:
			case <-ctx.Done():
				return nil, nil, false, ctx.Err()
			}
			var replayedRun *AgentRun
			if existing.runID != "" {
				replayedRun, _ = s.store.GetRun(ctx, caller.WorkspaceID, existing.runID)
			}
			return replayedRun, append([]string(nil), existing.warnings...), existing.requiresApproval, existing.err
		}

		entry := &launchIdempotencyEntry{
			workspaceID:    caller.WorkspaceID,
			idempotencyKey: idemKey,
			requestHash:    reqHash,
			done:           make(chan struct{}),
		}
		s.launchIdemEntries[lookupKey] = entry
		s.launchIdemMu.Unlock()

		defer func() {
			s.launchIdemMu.Lock()
			if retRun != nil {
				entry.runID = retRun.AgentRunID
				entry.warnings = append([]string(nil), retWarnings...)
				entry.requiresApproval = retRequiresApproval
				entry.err = retErr
			} else {
				delete(s.launchIdemEntries, lookupKey)
			}
			close(entry.done)
			s.launchIdemMu.Unlock()
		}()
	}

	var steps []AgentStep
	var estCredits string
	var planSummary string

	switch agentType {
	case AgentTypeVideoAgent:
		steps, estCredits, planSummary = s.planner.PlanVideoAgent(taskPrompt, params)
		if budgetCeiling == "" {
			budgetCeiling = estCredits
		}
	case AgentTypeCopilotAction:
		includePublish := false
		if strings.Contains(strings.ToLower(taskPrompt), "publish") || strings.Contains(strings.ToLower(taskPrompt), "đăng") {
			includePublish = true
		}
		steps, estCredits, planSummary = s.planner.PlanCopilotAction(taskPrompt, includePublish)
		if budgetCeiling == "" {
			budgetCeiling = estCredits
		}
	default:
		steps, estCredits, planSummary = s.planner.PlanGeneric(taskPrompt, budgetCeiling)
		if budgetCeiling == "" {
			budgetCeiling = estCredits
		}
	}

	runID := NewID()
	for i := range steps {
		steps[i].StepID = NewID()
		steps[i].AgentRunID = runID
		steps[i].WorkspaceID = caller.WorkspaceID
	}

	run := &AgentRun{
		AgentRunID:             runID,
		WorkspaceID:            caller.WorkspaceID,
		AgentType:              agentType,
		RecipeID:               recipeID,
		WorkflowID:             workflowID,
		PlanSummary:            planSummary,
		ExecutionScopeJSON:     executionScopeJSON,
		ApprovalState:          ApprovalNotRequired,
		CurrentState:           StatePlanning,
		SideEffectsSummaryJSON: "[]",
		CreditsUsed:            "0.000000",
		BudgetCeiling:          budgetCeiling,
		Memory:                 NewBoundedMemory(DefaultMaxMemoryBytes),
		Steps:                  steps,
		Outputs:                make([]AgentOutput, 0),
		CreatedBy:              caller.UserID,
		CreatedByRole:          caller.WorkspaceRole,
	}

	// Preflight checks
	warnings, requiresApproval, err := s.runtime.PreflightPlan(ctx, caller, run, s.capabilities)
	if err != nil {
		run.CurrentState = StateFailed
		run.PlanSummary = err.Error()
		_ = s.store.CreateRun(ctx, run)
		return run, warnings, false, err
	}

	if requiresApproval {
		run.ApprovalState = ApprovalAwaitingApproval
		run.CurrentState = StateAwaitingApproval
	} else if autoExecute {
		run.CurrentState = StateExecuting
		now := time.Now().UTC()
		run.StartedAt = &now
	}

	if err := s.store.CreateRun(ctx, run); err != nil {
		return nil, nil, false, err
	}

	s.store.PublishEvent(ctx, DomainEvent{
		EventType:   "agent_run.started",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"run_id":         run.AgentRunID,
			"current_state":  run.CurrentState,
			"plan_summary":   run.PlanSummary,
			"budget_ceiling": run.BudgetCeiling,
		},
		OccurredAt: time.Now().UTC(),
	})

	if autoExecute && !requiresApproval {
		// Run steps sequentially until paused, completed, or failed
		_, execErr := s.ExecuteRemainingSteps(ctx, caller, run.AgentRunID, 0)
		if updatedRun, getErr := s.store.GetRun(context.WithoutCancel(ctx), caller.WorkspaceID, run.AgentRunID); getErr == nil && updatedRun != nil {
			run = updatedRun
		}
		if execErr != nil {
			return run, warnings, false, execErr
		}
	}

	return run, warnings, requiresApproval, nil
}

func (s *Service) getRunExecutionLock(runID string) *sync.Mutex {
	s.execLocksMu.Lock()
	defer s.execLocksMu.Unlock()
	if s.runExecLocks == nil {
		s.runExecLocks = make(map[string]*sync.Mutex)
	}
	mu, ok := s.runExecLocks[runID]
	if !ok {
		mu = &sync.Mutex{}
		s.runExecLocks[runID] = mu
	}
	return mu
}

func (s *Service) mutateRun(ctx context.Context, workspaceID, runID string, fn func(run *AgentRun) error) (*AgentRun, error) {
	if leaseStore, ok := s.store.(StepLeaseStore); ok && leaseStore != nil {
		return leaseStore.MutateRunAtomically(ctx, workspaceID, runID, fn)
	}
	run, err := s.store.GetRun(ctx, workspaceID, runID)
	if err != nil {
		return nil, err
	}
	if err := fn(run); err != nil {
		return run, err
	}
	if err := s.store.UpdateRun(ctx, run); err != nil {
		return nil, err
	}
	return run, nil
}

// ExecuteRemainingSteps runs remaining steps in sequence.
func (s *Service) ExecuteRemainingSteps(ctx context.Context, caller CallerContext, runID string, simStepFailureOrder int) (*AgentRun, error) {
	if err := verifyCallerPrincipal(ctx, caller); err != nil {
		return nil, err
	}
	if _, err := s.store.GetRun(ctx, caller.WorkspaceID, runID); err != nil {
		return nil, err
	}

	runLock := s.getRunExecutionLock(runID)
	runLock.Lock()
	defer runLock.Unlock()

	run, err := s.store.GetRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, err
	}

	if run.CurrentState != StateExecuting {
		if run.CurrentState == StatePlanning {
			run, err = s.mutateRun(ctx, caller.WorkspaceID, runID, func(stored *AgentRun) error {
				stored.CurrentState = StateExecuting
				now := time.Now().UTC()
				if stored.StartedAt == nil {
					stored.StartedAt = &now
				}
				return nil
			})
			if err != nil {
				return nil, err
			}
		} else if isResumedExecution(ctx) && run.CurrentState == StateCompleted {
			// Concurrent approval/resume already completed the remaining steps while waiting on runLock.
			return run, nil
		} else {
			return run, fmt.Errorf("%w: run in state %s", ErrInvalidStateTransition, run.CurrentState)
		}
	}

	// Keep executing next step while in executing state
	for run.CurrentState == StateExecuting {
		err := s.runtime.ExecuteNextStep(ctx, caller, run, s.capabilities, simStepFailureOrder)
		if errors.Is(err, ErrStepAlreadyClaimed) {
			time.Sleep(5 * time.Millisecond)
			run, _ = s.store.GetRun(ctx, caller.WorkspaceID, runID)
			continue
		}
		// Fetch fresh run state
		run, _ = s.store.GetRun(ctx, caller.WorkspaceID, runID)
		if err != nil {
			return run, err
		}
	}

	return run, nil
}

// GetRun returns an agent run with tenant isolation.
func (s *Service) GetRun(ctx context.Context, caller CallerContext, runID string) (*AgentRun, error) {
	if err := verifyCallerPrincipal(ctx, caller); err != nil {
		return nil, err
	}
	return s.store.GetRun(ctx, caller.WorkspaceID, runID)
}

// ListRuns returns agent runs matching filters.
func (s *Service) ListRuns(ctx context.Context, caller CallerContext, agentType string, stateFilter string, pageSize int, pageToken string) ([]AgentRun, string, int, error) {
	if err := verifyCallerPrincipal(ctx, caller); err != nil {
		return nil, "", 0, err
	}
	offset := 0
	if pageToken != "" {
		if parsed, err := strconv.Atoi(pageToken); err == nil && parsed >= 0 {
			offset = parsed
		}
	}
	if pageSize <= 0 {
		pageSize = 20
	}

	runs, total, err := s.store.ListRuns(ctx, caller.WorkspaceID, agentType, stateFilter, pageSize, offset)
	if err != nil {
		return nil, "", 0, err
	}

	nextPageToken := ""
	if offset+len(runs) < total {
		nextPageToken = strconv.Itoa(offset + len(runs))
	}
	return runs, nextPageToken, total, nil
}

// CancelRun aborts an in-progress agent run.
func (s *Service) CancelRun(ctx context.Context, caller CallerContext, runID string, reason string) (*AgentRun, error) {
	if err := verifyCallerPrincipal(ctx, caller); err != nil {
		return nil, err
	}
	if !CheckPermission(caller.WorkspaceRole, "agent:execute") {
		return nil, fmt.Errorf("%w: role %q cannot cancel agent run", ErrPermissionDenied, caller.WorkspaceRole)
	}

	run, err := s.store.GetRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, err
	}

	if run.CurrentState == StateCompleted || run.CurrentState == StateFailed || run.CurrentState == StateCancelled {
		return nil, ErrRunAlreadyFinished
	}

	now := time.Now().UTC()
	run.CurrentState = StateCancelled
	run.CompletedAt = &now
	if reason == "" {
		reason = "Cancelled by operator"
	}
	run.PlanSummary = fmt.Sprintf("%s (Cancelled: %s)", run.PlanSummary, reason)

	for i := range run.Steps {
		if run.Steps[i].Status == StepStatusPlanning || run.Steps[i].Status == StepStatusExecuting || run.Steps[i].Status == StepStatusWaitingContext {
			run.Steps[i].Status = StepStatusCancelled
			run.Steps[i].CompletedAt = &now
		}
	}

	if err := s.store.UpdateRun(ctx, run); err != nil {
		return nil, err
	}

	s.store.PublishEvent(ctx, DomainEvent{
		EventType:   "agent_run.cancelled",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"run_id":       run.AgentRunID,
			"cancelled_by": caller.UserID,
			"reason":       reason,
		},
		OccurredAt: now,
	})

	return run, nil
}

// StreamRun provides current status and progress percentage.
func (s *Service) StreamRun(ctx context.Context, caller CallerContext, runID string) (*AgentRun, *AgentStep, string, int32, error) {
	if err := verifyCallerPrincipal(ctx, caller); err != nil {
		return nil, nil, "", 0, err
	}
	run, err := s.store.GetRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, nil, "", 0, err
	}

	var currentStep *AgentStep
	completedCount := 0
	for i := range run.Steps {
		if run.Steps[i].Status == StepStatusCompleted {
			completedCount++
		} else if currentStep == nil && (run.Steps[i].Status == StepStatusExecuting || run.Steps[i].Status == StepStatusWaitingContext || run.Steps[i].Status == StepStatusPlanning) {
			currentStep = &run.Steps[i]
		}
	}

	percent := int32(0)
	if len(run.Steps) > 0 {
		percent = int32((completedCount * 100) / len(run.Steps))
	}
	if run.CurrentState == StateCompleted {
		percent = 100
	}

	msg := fmt.Sprintf("State: %s (%d/%d steps completed)", run.CurrentState, completedCount, len(run.Steps))
	if currentStep != nil {
		msg = fmt.Sprintf("Executing Step %d: %s", currentStep.StepOrder, currentStep.Title)
	}

	return run, currentStep, msg, percent, nil
}

// ProvideInput delivers input/approval to a paused or waiting agent run.
func (s *Service) ProvideInput(
	ctx context.Context,
	caller CallerContext,
	runID string,
	inputText string,
	inputJSON string,
	approvePlan bool,
	budgetCeilingIncrease string,
	handoffTargetUserID string,
) (*AgentRun, error) {
	if err := verifyCallerPrincipal(ctx, caller); err != nil {
		return nil, err
	}
	run, err := s.store.GetRun(ctx, caller.WorkspaceID, runID)
	if err != nil {
		return nil, err
	}

	now := time.Now().UTC()

	// 1. Explicit Handoff Transfer
	if handoffTargetUserID != "" {
		run, err = s.mutateRun(ctx, caller.WorkspaceID, runID, func(stored *AgentRun) error {
			stored.CurrentState = StateHandedOff
			stored.HandoffTargetUserID = handoffTargetUserID
			if inputText != "" {
				stored.HandoffContext = inputText
			}
			stored.CompletedAt = &now
			return nil
		})
		if err != nil {
			return nil, err
		}
		s.store.PublishEvent(ctx, DomainEvent{
			EventType:   "agent_run.handed_off",
			WorkspaceID: caller.WorkspaceID,
			Payload: map[string]any{
				"run_id":     run.AgentRunID,
				"handoff_to": handoffTargetUserID,
				"reason":     run.HandoffContext,
			},
			OccurredAt: now,
		})
		return run, nil
	}

	// 2. Manager Approval Gate (Target 1 & RULE-M21-004)
	if approvePlan {
		if !CheckPermission(caller.WorkspaceRole, "workflow:manage") {
			return nil, fmt.Errorf("%w: role %q lacks manager authority to approve agent plan", ErrPermissionDenied, caller.WorkspaceRole)
		}
		run, err = s.mutateRun(ctx, caller.WorkspaceID, runID, func(stored *AgentRun) error {
			stored.ApprovalState = ApprovalApproved
			if stored.CurrentState == StateAwaitingApproval {
				stored.CurrentState = StateExecuting
				for i := range stored.Steps {
					if stored.Steps[i].Status == StepStatusAwaitingApproval {
						stored.Steps[i].Status = StepStatusPlanning
					}
				}
			}
			return nil
		})
		if err != nil {
			return nil, err
		}
		// Resume execution
		return s.ExecuteRemainingSteps(withResumedExecution(ctx), caller, run.AgentRunID, 0)
	}

	// 3. Budget Ceiling Elevation (Target 2 & F13)
	if budgetCeilingIncrease != "" {
		inc, err := tenantdb.ParseExactDecimal(budgetCeilingIncrease)
		if err != nil || !inc.IsPositive() {
			return nil, fmt.Errorf("%w: budget_ceiling_increase must be a positive decimal", ErrInvalidBudgetCeiling)
		}
		var stillOverBudget bool
		run, err = s.mutateRun(ctx, caller.WorkspaceID, runID, func(stored *AgentRun) error {
			currCeiling, cErr := tenantdb.ParseExactDecimal(stored.BudgetCeiling)
			if cErr != nil || currCeiling.IsNegative() {
				return fmt.Errorf("%w: current budget_ceiling %q is invalid", ErrInvalidBudgetCeiling, stored.BudgetCeiling)
			}
			// If a concurrent resume already transitioned the run out of StateWaitingContext, do not double-add the duplicate budget increase.
			if stored.CurrentState != StateWaitingContext {
				return nil
			}
			newCeiling, addErr := currCeiling.Add(inc)
			if addErr != nil || !newCeiling.IsPositive() {
				return fmt.Errorf("%w: invalid elevated budget ceiling", ErrInvalidBudgetCeiling)
			}
			stored.BudgetCeiling = newCeiling.Fixed6String()

			usedDec, uErr := tenantdb.ParseExactDecimal(stored.CreditsUsed)
			if uErr != nil {
				usedDec = tenantdb.MustParseExactDecimal("0.000000")
			}
			if usedDec.Cmp(newCeiling) > 0 {
				// Still over budget ceiling even after increase: remain paused in StateWaitingContext
				stillOverBudget = true
				return nil
			}

			stored.CurrentState = StateExecuting
			for i := range stored.Steps {
				if stored.Steps[i].Status == StepStatusWaitingContext {
					stored.Steps[i].Status = StepStatusPlanning
				}
			}
			return nil
		})
		if err != nil {
			return nil, err
		}
		if stillOverBudget {
			return run, ErrBudgetCeilingExceeded
		}
		return s.ExecuteRemainingSteps(withResumedExecution(ctx), caller, run.AgentRunID, 0)
	}

	// 4. Human Context Injection
	if inputText != "" || inputJSON != "" {
		run, err = s.mutateRun(ctx, caller.WorkspaceID, runID, func(stored *AgentRun) error {
			if stored.Memory != nil {
				_ = stored.Memory.AddObservation("operator_input", inputText)
			}
			if stored.CurrentState == StateWaitingContext {
				stored.CurrentState = StateExecuting
				for i := range stored.Steps {
					if stored.Steps[i].Status == StepStatusWaitingContext {
						stored.Steps[i].Status = StepStatusPlanning
						if inputJSON != "" {
							stored.Steps[i].InputContextJSON = inputJSON
						}
					}
				}
			}
			return nil
		})
		if err != nil {
			return nil, err
		}
		return s.ExecuteRemainingSteps(withResumedExecution(ctx), caller, run.AgentRunID, 0)
	}

	return run, nil
}

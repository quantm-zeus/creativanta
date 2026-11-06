package agent

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Runtime orchestrates multi-step agent planning, execution, delegated permission
// checks, budget ceiling pauses, bounded memory, and audited partial-failure handoff.
type Runtime struct {
	store    Store
	executor StepExecutor
}

func NewRuntime(store Store) *Runtime {
	return &Runtime{store: store}
}

func NewRuntimeWithExecutor(store Store, executor StepExecutor) *Runtime {
	return &Runtime{store: store, executor: executor}
}

// SetStepExecutor configures the concrete step executor for the runtime.
// When nil, step execution fails closed with ErrExecutorNotConfigured.
func (r *Runtime) SetStepExecutor(executor StepExecutor) {
	r.executor = executor
}

type simulatedStepExecutor struct{}

// NewSimulatedStepExecutor returns an explicit test-only StepExecutor that
// produces deterministic step outputs for unit tests. Production services do
// NOT wire this by default (AI-04 / R07 fail-closed contract).
func NewSimulatedStepExecutor() StepExecutor {
	return &simulatedStepExecutor{}
}

func (s *simulatedStepExecutor) ExecuteStep(_ context.Context, req StepExecutionRequest) (*StepExecutionResult, error) {
	now := time.Now().UTC()
	var outType string
	lowerTitle := strings.ToLower(req.Step.Title)
	switch {
	case strings.Contains(lowerTitle, "script"):
		outType = OutputTypeText
	case strings.Contains(lowerTitle, "visual") || strings.Contains(lowerTitle, "video"):
		outType = OutputTypeVideo
	case strings.Contains(lowerTitle, "thumbnail"):
		outType = OutputTypeAsset
	case strings.Contains(lowerTitle, "product"):
		outType = OutputTypeDataset
	default:
		outType = OutputTypeReport
	}
	outcome := fmt.Sprintf("Successfully executed %s", req.Step.Title)
	return &StepExecutionResult{
		ObservedOutcome: outcome,
		ActualCredits:   req.Step.EstimatedCredits,
		Outputs: []AgentOutput{
			{
				OutputID:           NewID(),
				WorkspaceID:        req.WorkspaceID,
				AgentRunID:         req.AgentRunID,
				OutputType:         outType,
				Title:              req.Step.Title + " Output",
				Summary:            outcome,
				ApprovalState:      ApprovalNotRequired,
				PreviewPayloadJSON: fmt.Sprintf(`{"step_order":%d,"title":%q}`, req.Step.StepOrder, req.Step.Title),
				CreatedAt:          now,
				UpdatedAt:          now,
			},
		},
	}, nil
}

// CheckPermission checks if a workspace role possesses the delegated permission.
// Role hierarchy: owner > admin > manager > editor > contributor > member.
// An agent NEVER self-escalates permissions (RULE-M21-002, EC-M21-001).
func CheckPermission(role string, requiredPerm string) bool {
	normalizedRole := strings.ToLower(strings.TrimSpace(role))
	switch requiredPerm {
	case "billing:manage":
		return normalizedRole == "owner"
	case "product:delete":
		return normalizedRole == "owner" || normalizedRole == "admin"
	case "workflow:manage":
		return normalizedRole == "owner" || normalizedRole == "admin" || normalizedRole == "manager"
	case "publish:item_manage":
		// High-risk: manager+ can execute directly; editor requires explicit approval
		return normalizedRole == "owner" || normalizedRole == "admin" || normalizedRole == "manager" || normalizedRole == "editor"
	case "script:write", "asset:generate", "agent:execute", "recipe:install":
		return normalizedRole == "owner" || normalizedRole == "admin" || normalizedRole == "manager" || normalizedRole == "editor"
	case "workflow:read", "asset:read", "product:read", "coach:read", "copilot:use_creative", "copilot:use_help":
		return normalizedRole == "owner" || normalizedRole == "admin" || normalizedRole == "manager" || normalizedRole == "editor" || normalizedRole == "contributor" || normalizedRole == "member"
	default:
		// Default fail-closed
		return normalizedRole == "owner" || normalizedRole == "admin"
	}
}

// PreflightPlan validates all steps against caller's delegated permissions and capabilities.
func (r *Runtime) PreflightPlan(ctx context.Context, caller CallerContext, run *AgentRun, capabilities map[string]bool) ([]string, bool, error) {
	var warnings []string
	requiresApproval := false

	for i := range run.Steps {
		step := &run.Steps[i]

		// 1. Delegated Permission Check (Target 1)
		if step.RequiredPermission != "" && !CheckPermission(caller.WorkspaceRole, step.RequiredPermission) {
			errMsg := fmt.Sprintf("⚠️ Step %d: [%s] — requires %s permission. Caller has %s role.",
				step.StepOrder, step.Title, step.RequiredPermission, caller.WorkspaceRole)
			warnings = append(warnings, errMsg)
			return warnings, false, fmt.Errorf("%w: %s", ErrPermissionDenied, errMsg)
		}

		// 2. Connector Capability Check (Target 1)
		if step.RequiredCapability != "" && capabilities != nil {
			if supported, ok := capabilities[step.RequiredCapability]; !ok || !supported {
				errMsg := fmt.Sprintf("⚠️ Step %d: [%s] — capability %q is unsupported or missing connector.",
					step.StepOrder, step.Title, step.RequiredCapability)
				warnings = append(warnings, errMsg)
				return warnings, false, fmt.Errorf("%w: %s", ErrCapabilityMissing, errMsg)
			}
		}

		// 3. High Risk Gate Check (RULE-M21-004)
		if step.IsHighRisk && run.ApprovalState != ApprovalApproved {
			requiresApproval = true
			warnings = append(warnings, fmt.Sprintf("Step %d: [%s] involves high-risk actions and requires manager approval.",
				step.StepOrder, step.Title))
		}
	}

	return warnings, requiresApproval, nil
}

// ExecuteNextStep executes the next pending step in an agent run while enforcing
// delegated permissions, budget ceiling pauses, and audited handoff on partial failure.
func (r *Runtime) ExecuteNextStep(ctx context.Context, caller CallerContext, run *AgentRun, capabilities map[string]bool, simStepFailureOrder int) error {
	if run.CurrentState != StateExecuting {
		return fmt.Errorf("%w: run is in state %q, cannot execute", ErrInvalidStateTransition, run.CurrentState)
	}

	// Find the next step to execute
	var currentStep *AgentStep
	var stepIndex int = -1
	for i := range run.Steps {
		if run.Steps[i].Status == StepStatusPlanning || run.Steps[i].Status == StepStatusExecuting {
			currentStep = &run.Steps[i]
			stepIndex = i
			break
		}
	}

	if currentStep == nil {
		// All steps completed!
		now := time.Now().UTC()
		run.CurrentState = StateCompleted
		run.CompletedAt = &now
		if run.Memory != nil {
			// Per RULE-M21-003, memory is discarded after completion
			run.Memory.Clear()
		}
		_ = r.store.UpdateRun(ctx, run)
		r.store.PublishEvent(ctx, DomainEvent{
			EventType:   "agent_run.completed",
			WorkspaceID: run.WorkspaceID,
			Payload: map[string]any{
				"run_id":          run.AgentRunID,
				"total_credits":   run.CreditsUsed,
				"steps_completed": len(run.Steps),
			},
			OccurredAt: now,
		})
		return nil
	}

	now := time.Now().UTC()
	currentStep.StartedAt = &now
	currentStep.Status = StepStatusExecuting

	// ------------------------------------------------------------------------
	// Acceptance Target 1: Every step checks delegated permissions
	// ------------------------------------------------------------------------
	if currentStep.RequiredPermission != "" && !CheckPermission(caller.WorkspaceRole, currentStep.RequiredPermission) {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.ObservedOutcome = fmt.Sprintf("Permission denied: user role [%s] lacks delegated permission [%s]",
			caller.WorkspaceRole, currentStep.RequiredPermission)

		return r.HandlePartialFailure(ctx, caller, run, stepIndex, ErrPermissionDenied, caller.UserID)
	}

	// Check capability
	if currentStep.RequiredCapability != "" && capabilities != nil {
		if supported, ok := capabilities[currentStep.RequiredCapability]; !ok || !supported {
			currentStep.Status = StepStatusFailed
			currentStep.CompletedAt = &now
			currentStep.ObservedOutcome = fmt.Sprintf("Required capability [%s] is missing or unsupported in workspace",
				currentStep.RequiredCapability)

			return r.HandlePartialFailure(ctx, caller, run, stepIndex, ErrCapabilityMissing, caller.UserID)
		}
	}

	// High risk approval pause
	if currentStep.IsHighRisk && run.ApprovalState != ApprovalApproved {
		run.CurrentState = StateAwaitingApproval
		currentStep.Status = StepStatusAwaitingApproval
		_ = r.store.UpdateRun(ctx, run)
		r.store.PublishEvent(ctx, DomainEvent{
			EventType:   "agent_run.approval_required",
			WorkspaceID: run.WorkspaceID,
			Payload: map[string]any{
				"run_id":        run.AgentRunID,
				"step_order":    currentStep.StepOrder,
				"risk_action":   currentStep.Title,
				"required_perm": currentStep.RequiredPermission,
			},
			OccurredAt: now,
		})
		return ErrApprovalRequired
	}

	// ------------------------------------------------------------------------
	// Acceptance Target 2: Budget ceiling pauses
	// ------------------------------------------------------------------------
	usedDec, err := tenantdb.ParseExactDecimal(run.CreditsUsed)
	if err != nil {
		usedDec = tenantdb.MustParseExactDecimal("0.000000")
	}
	stepCostDec, err := tenantdb.ParseExactDecimal(currentStep.EstimatedCredits)
	if err != nil {
		stepCostDec = tenantdb.MustParseExactDecimal("0.000000")
	}
	ceilingDec, err := tenantdb.ParseExactDecimal(run.BudgetCeiling)
	if err != nil {
		ceilingDec = tenantdb.MustParseExactDecimal("0.000000")
	}

	newTotalDec, err := usedDec.Add(stepCostDec)
	if err != nil {
		return fmt.Errorf("credit addition overflow: %w", err)
	}

	// If ceiling is configured (> 0) and would be exceeded: PAUSE immediately!
	if !ceilingDec.IsZero() && newTotalDec.Cmp(ceilingDec) > 0 {
		run.CurrentState = StateWaitingContext
		currentStep.Status = StepStatusWaitingContext
		currentStep.ObservedOutcome = fmt.Sprintf("Budget ceiling reached: step requires %s credits, cumulative %s exceeds ceiling %s. Pausing execution.",
			currentStep.EstimatedCredits, newTotalDec.Fixed6String(), ceilingDec.Fixed6String())

		_ = r.store.UpdateRun(ctx, run)
		r.store.PublishEvent(ctx, DomainEvent{
			EventType:   "agent_run.waiting_context",
			WorkspaceID: run.WorkspaceID,
			Payload: map[string]any{
				"run_id":                 run.AgentRunID,
				"requested_context_type": "budget_increase",
				"prompt":                 currentStep.ObservedOutcome,
				"credits_used":           run.CreditsUsed,
				"budget_ceiling":         run.BudgetCeiling,
			},
			OccurredAt: now,
		})
		return ErrBudgetCeilingExceeded
	}

	// ------------------------------------------------------------------------
	// Simulated or real failure handling (Target 3)
	// ------------------------------------------------------------------------
	if simStepFailureOrder > 0 && currentStep.StepOrder == simStepFailureOrder {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.ObservedOutcome = fmt.Sprintf("Step %d execution failed: simulated downstream service fault", currentStep.StepOrder)
		return r.HandlePartialFailure(ctx, caller, run, stepIndex, fmt.Errorf("downstream fault at step %d", currentStep.StepOrder), caller.UserID)
	}

	// Fail closed when no concrete StepExecutor is configured (AI-04 / R07).
	if r.executor == nil {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.ObservedOutcome = ErrExecutorNotConfigured.Error()
		return r.HandlePartialFailure(ctx, caller, run, stepIndex, ErrExecutorNotConfigured, caller.UserID)
	}

	var remainingBudgetStr string
	if !ceilingDec.IsZero() {
		if remDec, rErr := ceilingDec.Sub(usedDec); rErr == nil {
			remainingBudgetStr = remDec.Fixed6String()
		}
	}

	execRes, err := r.executor.ExecuteStep(ctx, StepExecutionRequest{
		WorkspaceID:            run.WorkspaceID,
		AgentRunID:             run.AgentRunID,
		AgentType:              run.AgentType,
		Caller:                 caller,
		Step:                   *currentStep,
		RemainingBudgetCredits: remainingBudgetStr,
	})
	if err != nil {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.ObservedOutcome = err.Error()
		return r.HandlePartialFailure(ctx, caller, run, stepIndex, err, caller.UserID)
	}
	if execRes == nil || strings.TrimSpace(execRes.ObservedOutcome) == "" {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.ObservedOutcome = ErrInvalidStepOutput.Error()
		return r.HandlePartialFailure(ctx, caller, run, stepIndex, ErrInvalidStepOutput, caller.UserID)
	}

	actualStepCostDec := stepCostDec
	if strings.TrimSpace(execRes.ActualCredits) != "" {
		parsedActual, err := tenantdb.ParseExactDecimal(execRes.ActualCredits)
		if err != nil || parsedActual.IsNegative() {
			invalidErr := fmt.Errorf("%w: invalid actual credits %q", ErrInvalidStepOutput, execRes.ActualCredits)
			currentStep.Status = StepStatusFailed
			currentStep.CompletedAt = &now
			currentStep.ObservedOutcome = invalidErr.Error()
			return r.HandlePartialFailure(ctx, caller, run, stepIndex, invalidErr, caller.UserID)
		}
		actualStepCostDec = parsedActual
		newTotalDec, err = usedDec.Add(actualStepCostDec)
		if err != nil {
			return fmt.Errorf("credit addition overflow: %w", err)
		}
	}

	for i := range execRes.Outputs {
		out := execRes.Outputs[i]
		if strings.TrimSpace(out.OutputType) == "" || strings.TrimSpace(out.Title) == "" {
			invalidErr := fmt.Errorf("%w: output missing required type or title", ErrInvalidStepOutput)
			currentStep.Status = StepStatusFailed
			currentStep.CompletedAt = &now
			currentStep.ObservedOutcome = invalidErr.Error()
			return r.HandlePartialFailure(ctx, caller, run, stepIndex, invalidErr, caller.UserID)
		}
		if out.OutputID == "" {
			out.OutputID = NewID()
		}
		out.WorkspaceID = run.WorkspaceID
		out.AgentRunID = run.AgentRunID
		if out.ApprovalState == "" {
			out.ApprovalState = ApprovalNotRequired
		}
		if out.CreatedAt.IsZero() {
			out.CreatedAt = now
		}
		if out.UpdatedAt.IsZero() {
			out.UpdatedAt = now
		}
		if err := r.store.CreateOutput(ctx, out); err != nil {
			return err
		}
		run.Outputs = append(run.Outputs, out)
	}

	// Step has already executed: record its actual credits, outputs, and completion status
	// so ProvideInput never replays an already-executed step!
	currentStep.Status = StepStatusCompleted
	currentStep.CompletedAt = &now
	currentStep.ActualCredits = actualStepCostDec.Fixed6String()
	currentStep.ObservedOutcome = execRes.ObservedOutcome

	run.CreditsUsed = newTotalDec.Fixed6String()

	// Update working memory (RULE-M21-003: bounded, non-canonical)
	if run.Memory != nil {
		_ = run.Memory.AddObservation(currentStep.Title, currentStep.ObservedOutcome)
	}

	// If actual post-step spend exceeded the configured budget ceiling, pause the run before any further work
	if !ceilingDec.IsZero() && newTotalDec.Cmp(ceilingDec) > 0 {
		run.CurrentState = StateWaitingContext
		pauseMsg := fmt.Sprintf("Budget ceiling reached after step %d: actual %s credits brought cumulative spend to %s (ceiling %s). Pausing execution.",
			currentStep.StepOrder, actualStepCostDec.Fixed6String(), newTotalDec.Fixed6String(), ceilingDec.Fixed6String())
		if stepIndex+1 < len(run.Steps) && run.Steps[stepIndex+1].Status == StepStatusPlanning {
			run.Steps[stepIndex+1].Status = StepStatusWaitingContext
			run.Steps[stepIndex+1].ObservedOutcome = pauseMsg
		}
		_ = r.store.UpdateRun(ctx, run)
		r.store.PublishEvent(ctx, DomainEvent{
			EventType:   "agent_run.waiting_context",
			WorkspaceID: run.WorkspaceID,
			Payload: map[string]any{
				"run_id":                 run.AgentRunID,
				"requested_context_type": "budget_increase",
				"prompt":                 pauseMsg,
				"credits_used":           run.CreditsUsed,
				"budget_ceiling":         run.BudgetCeiling,
			},
			OccurredAt: now,
		})
		return ErrBudgetCeilingExceeded
	}

	if err := r.store.UpdateRun(ctx, run); err != nil {
		return err
	}
	return nil
}

// HandlePartialFailure implements Acceptance Target 3:
// When partial failure occurs, all succeeded steps are preserved,
// state moves to partially_completed or handed_off, diagnostics & audit records
// are registered, and domain events are emitted.
func (r *Runtime) HandlePartialFailure(ctx context.Context, caller CallerContext, run *AgentRun, failedStepIndex int, stepErr error, handoffUser string) error {
	now := time.Now().UTC()
	failedStep := &run.Steps[failedStepIndex]
	diagID := NewID()
	auditID := NewID()

	// Enumerate resolved vs unresolved steps
	var resolvedSteps []string
	var unresolvedSteps []string

	for i := range run.Steps {
		s := &run.Steps[i]
		if s.Status == StepStatusCompleted {
			resolvedSteps = append(resolvedSteps, fmt.Sprintf("Step %d: %s (%s cr)", s.StepOrder, s.Title, s.ActualCredits))
		} else {
			unresolvedSteps = append(unresolvedSteps, fmt.Sprintf("Step %d: %s (estimated %s cr)", s.StepOrder, s.Title, s.EstimatedCredits))
		}
	}

	completedWorkSummary := fmt.Sprintf("%d of %d steps completed. Resolved: [%s]",
		len(resolvedSteps), len(run.Steps), strings.Join(resolvedSteps, "; "))

	handoffCtx := AgentHandoffContext{
		HandoffTargetUserID:    handoffUser,
		Reason:                 stepErr.Error(),
		SummaryOfCompletedWork: completedWorkSummary,
		UnresolvedActions:      unresolvedSteps,
		DiagnosticsRef:         diagID,
		AuditRef:               auditID,
	}
	_ = handoffCtx

	// Update run properties
	if len(resolvedSteps) > 0 {
		run.CurrentState = StatePartiallyCompleted
	} else {
		run.CurrentState = StateFailed
	}
	if handoffUser != "" {
		run.CurrentState = StateHandedOff
	}

	run.HandoffTargetUserID = handoffUser
	run.HandoffContext = fmt.Sprintf("Handoff required due to: %s. %s", stepErr.Error(), completedWorkSummary)
	run.DiagnosticsRef = diagID
	run.AuditRef = auditID
	run.CompletedAt = &now

	// Record side effects summary
	run.SideEffectsSummaryJSON = fmt.Sprintf(`{"resolved":%d,"unresolved":%d,"failed_step":%d,"error":%q}`,
		len(resolvedSteps), len(unresolvedSteps), failedStep.StepOrder, stepErr.Error())

	// Persist diagnostics record
	_ = r.store.AddDiagnostics(ctx, DiagnosticsRecord{
		DiagnosticsID:       diagID,
		WorkspaceID:         run.WorkspaceID,
		AgentRunID:          run.AgentRunID,
		FailedStepID:        failedStep.StepID,
		ErrorCode:           "AGENT_STEP_EXECUTION_FAILURE",
		RootCause:           stepErr.Error(),
		RecoveryGuidance:    "Review completed work and resume remaining steps or manually execute unresolved actions.",
		HandoffTargetUserID: handoffUser,
		CreatedAt:           now,
	})

	// Persist immutable audit record (RULE-M21-002)
	_ = r.store.AddAuditRecord(ctx, AuditRecord{
		AuditID:        auditID,
		WorkspaceID:    run.WorkspaceID,
		ActorUserID:    caller.UserID,
		ActorRole:      caller.WorkspaceRole,
		Action:         "agent_run.failure_handoff",
		AffectedObject: run.AgentRunID,
		OldState:       StateExecuting,
		NewState:       run.CurrentState,
		CorrelationID:  run.AgentRunID,
		Details: map[string]any{
			"failed_step_order": failedStep.StepOrder,
			"failed_step_title": failedStep.Title,
			"resolved_count":    len(resolvedSteps),
			"unresolved_count":  len(unresolvedSteps),
			"credits_used":      run.CreditsUsed,
			"error":             stepErr.Error(),
		},
		OccurredAt: now,
	})

	_ = r.store.UpdateRun(ctx, run)

	// Emit appropriate domain event (§11)
	eventType := "agent_run.failed"
	if run.CurrentState == StatePartiallyCompleted {
		eventType = "agent_run.partially_completed"
	} else if run.CurrentState == StateHandedOff {
		eventType = "agent_run.handed_off"
	}

	r.store.PublishEvent(ctx, DomainEvent{
		EventType:   eventType,
		WorkspaceID: run.WorkspaceID,
		Payload: map[string]any{
			"run_id":             run.AgentRunID,
			"handoff_to":         handoffUser,
			"unresolved_actions": unresolvedSteps,
			"error":              stepErr.Error(),
		},
		OccurredAt: now,
	})

	return fmt.Errorf("step %d failed: %w (handed off with audit ref %s)", failedStep.StepOrder, stepErr, auditID)
}

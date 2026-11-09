package agent

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type agentMemberState struct {
	role   string
	active bool
}

// Runtime orchestrates multi-step agent planning, execution, delegated permission
// checks, budget ceiling pauses, bounded memory, and audited partial-failure handoff.
type Runtime struct {
	store        Store
	executor     StepExecutor
	membersMu    sync.RWMutex
	roleResolver MembershipRoleResolver
	memberStates map[string]agentMemberState
}

func NewRuntime(store Store) *Runtime {
	return &Runtime{
		store:        store,
		memberStates: make(map[string]agentMemberState),
	}
}

func NewRuntimeWithExecutor(store Store, executor StepExecutor) *Runtime {
	return &Runtime{
		store:        store,
		executor:     executor,
		memberStates: make(map[string]agentMemberState),
	}
}

func (r *Runtime) SetMembershipRoleResolver(resolver MembershipRoleResolver) {
	r.membersMu.Lock()
	defer r.membersMu.Unlock()
	r.roleResolver = resolver
}

func (r *Runtime) SetMemberRole(workspaceID, userID, role string, active bool) {
	ws := strings.TrimSpace(workspaceID)
	uid := strings.TrimSpace(userID)
	if ws == "" || uid == "" {
		return
	}
	if mut, ok := r.store.(WorkspaceMembershipMutator); ok && mut != nil {
		mut.SetMemberRole(ws, uid, strings.TrimSpace(role), active)
	}
	r.membersMu.Lock()
	defer r.membersMu.Unlock()
	if r.memberStates == nil {
		r.memberStates = make(map[string]agentMemberState)
	}
	r.memberStates[ws+":"+uid] = agentMemberState{
		role:   strings.TrimSpace(role),
		active: active,
	}
}

func isInactiveOrRevokedAgentRole(role string, active bool) bool {
	trimmed := strings.TrimSpace(role)
	return !active || trimmed == "" || strings.EqualFold(trimmed, "revoked") || strings.EqualFold(trimmed, "none") || strings.EqualFold(trimmed, "denied")
}

type resumedExecutionCtxKey struct{}

func withResumedExecution(ctx context.Context) context.Context {
	return context.WithValue(ctx, resumedExecutionCtxKey{}, true)
}

func isResumedExecution(ctx context.Context) bool {
	if ctx == nil {
		return false
	}
	v, _ := ctx.Value(resumedExecutionCtxKey{}).(bool)
	return v
}

// resolveInitiatorRole resolves the initiator's current active workspace role from an authoritative
// membership source (configured MembershipRoleResolver or WorkspaceMembershipStore). It never falls
// back to a launch-time role snapshot or unverified observed cache on cross-actor/resumed execution (R3).
func (r *Runtime) resolveInitiatorRole(ctx context.Context, workspaceID, createdBy string, liveCaller CallerContext, isResumed bool) (string, bool, error) {
	ws := strings.TrimSpace(workspaceID)
	uid := strings.TrimSpace(createdBy)
	if ws == "" || uid == "" {
		return "", false, fmt.Errorf("%w: agent run is missing verified initiator identity", ErrPermissionDenied)
	}
	r.membersMu.RLock()
	resolver := r.roleResolver
	st, hasState := r.memberStates[ws+":"+uid]
	r.membersMu.RUnlock()

	if resolver != nil {
		role, active, err := resolver(ctx, ws, uid)
		if err != nil {
			return "", false, fmt.Errorf("%w: failed to verify initiator %s membership: %v", ErrPermissionDenied, uid, err)
		}
		if isInactiveOrRevokedAgentRole(role, active) {
			return "", false, fmt.Errorf("%w: initiator %s workspace membership is inactive or revoked", ErrPermissionDenied, uid)
		}
		return strings.TrimSpace(role), true, nil
	}

	if memStore, ok := r.store.(WorkspaceMembershipStore); ok && memStore != nil {
		storeRole, active, found, err := memStore.ResolveWorkspaceMemberRole(ctx, ws, uid)
		if err != nil {
			return "", false, fmt.Errorf("%w: failed to query authoritative workspace membership for %s: %v", ErrPermissionDenied, uid, err)
		}
		if found {
			if isInactiveOrRevokedAgentRole(storeRole, active) {
				return "", false, fmt.Errorf("%w: initiator %s workspace membership is inactive or revoked", ErrPermissionDenied, uid)
			}
			return strings.TrimSpace(storeRole), true, nil
		}
	}

	if hasState {
		if isInactiveOrRevokedAgentRole(st.role, st.active) {
			return "", false, fmt.Errorf("%w: initiator %s workspace access has been revoked", ErrPermissionDenied, uid)
		}
		return strings.TrimSpace(st.role), true, nil
	}

	if !isResumed && strings.TrimSpace(liveCaller.WorkspaceID) == ws && strings.TrimSpace(liveCaller.UserID) == uid {
		if isInactiveOrRevokedAgentRole(liveCaller.WorkspaceRole, true) {
			return "", false, fmt.Errorf("%w: initiator %s role is invalid or revoked", ErrPermissionDenied, uid)
		}
		return strings.TrimSpace(liveCaller.WorkspaceRole), true, nil
	}

	return "", false, fmt.Errorf("%w: authoritative workspace membership required to verify live role for initiator %s in workspace %s", ErrPermissionDenied, uid, ws)
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
// atomic step lease claims/fencing, delegated permissions, budget ceiling pauses,
// and audited handoff on partial failure.
func (r *Runtime) ExecuteNextStep(ctx context.Context, caller CallerContext, run *AgentRun, capabilities map[string]bool, simStepFailureOrder int) error {
	if run.CurrentState != StateExecuting {
		return fmt.Errorf("%w: run is in state %q, cannot execute", ErrInvalidStateTransition, run.CurrentState)
	}

	ownerID := "exec-" + NewID()
	var (
		workingRun  *AgentRun
		currentStep *AgentStep
		stepIndex   = -1
		allDone     bool
	)

	if leaseStore, ok := r.store.(StepLeaseStore); ok && leaseStore != nil {
		claimedRun, idx, claimed, done, claimErr := leaseStore.ClaimStepForExecution(ctx, run.WorkspaceID, run.AgentRunID, ownerID, 5*time.Minute)
		if claimErr != nil {
			if claimedRun != nil {
				*run = *claimedRun
			}
			return claimErr
		}
		allDone = done
		if claimed && claimedRun != nil && idx >= 0 && idx < len(claimedRun.Steps) {
			workingRun = claimedRun
			stepIndex = idx
			currentStep = &workingRun.Steps[stepIndex]
		} else if claimedRun != nil {
			workingRun = claimedRun
		}
	} else {
		workingRun = run
		for i := range workingRun.Steps {
			if workingRun.Steps[i].Status == StepStatusPlanning || workingRun.Steps[i].Status == StepStatusExecuting {
				currentStep = &workingRun.Steps[i]
				stepIndex = i
				break
			}
		}
		if currentStep == nil {
			allDone = true
		} else {
			now := time.Now().UTC()
			currentStep.StartedAt = &now
			currentStep.Status = StepStatusExecuting
			currentStep.ExecutionOwner = ownerID
			currentStep.FencingToken++
			if strings.TrimSpace(currentStep.OperationKey) == "" {
				currentStep.OperationKey = fmt.Sprintf("agent_run:%s:step:%d", workingRun.AgentRunID, currentStep.StepOrder)
			}
		}
	}

	if allDone || currentStep == nil {
		// All steps completed!
		now := time.Now().UTC()
		if leaseStore, ok := r.store.(StepLeaseStore); ok && leaseStore != nil {
			completedRun, _ := leaseStore.MutateRunAtomically(ctx, run.WorkspaceID, run.AgentRunID, func(stored *AgentRun) error {
				stored.CurrentState = StateCompleted
				stored.CompletedAt = &now
				if stored.Memory != nil {
					stored.Memory.Clear()
				}
				return nil
			})
			if completedRun != nil {
				*run = *completedRun
			}
		} else {
			run.CurrentState = StateCompleted
			run.CompletedAt = &now
			if run.Memory != nil {
				run.Memory.Clear()
			}
			_ = r.store.UpdateRun(ctx, run)
		}
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
	fencingToken := currentStep.FencingToken
	syncCallerRun := func(updated *AgentRun) {
		if updated != nil {
			*run = *updated
		}
	}

	// ------------------------------------------------------------------------
	// Acceptance Target 1, F11, R3: Every step checks live delegated permissions
	// ------------------------------------------------------------------------
	effectiveRole := caller.WorkspaceRole
	if strings.TrimSpace(workingRun.CreatedBy) != "" {
		isResumed := isResumedExecution(ctx) || workingRun.ApprovalState == ApprovalApproved
		initRole, active, roleErr := r.resolveInitiatorRole(ctx, workingRun.WorkspaceID, workingRun.CreatedBy, caller, isResumed)
		if roleErr != nil || !active || initRole == "" || !CheckPermission(initRole, "agent:execute") {
			currentStep.Status = StepStatusFailed
			currentStep.CompletedAt = &now
			currentStep.LeaseExpiresAt = nil
			currentStep.ExecutionOwner = ""
			currentStep.ObservedOutcome = fmt.Sprintf("Permission denied: initiator [%s] workspace access was revoked or downgraded [%s]",
				workingRun.CreatedBy, initRole)
			err := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, ErrPermissionDenied, caller.UserID)
			syncCallerRun(workingRun)
			return err
		}
		if currentStep.RequiredPermission != "" && !CheckPermission(initRole, currentStep.RequiredPermission) {
			currentStep.Status = StepStatusFailed
			currentStep.CompletedAt = &now
			currentStep.LeaseExpiresAt = nil
			currentStep.ExecutionOwner = ""
			currentStep.ObservedOutcome = fmt.Sprintf("Permission denied: initiator role [%s] lacks delegated permission [%s]",
				initRole, currentStep.RequiredPermission)
			err := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, ErrPermissionDenied, caller.UserID)
			syncCallerRun(workingRun)
			return err
		}
		effectiveRole = initRole
	}
	if currentStep.RequiredPermission != "" && !CheckPermission(effectiveRole, currentStep.RequiredPermission) {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.LeaseExpiresAt = nil
		currentStep.ExecutionOwner = ""
		currentStep.ObservedOutcome = fmt.Sprintf("Permission denied: user role [%s] lacks delegated permission [%s]",
			effectiveRole, currentStep.RequiredPermission)

		err := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, ErrPermissionDenied, caller.UserID)
		syncCallerRun(workingRun)
		return err
	}

	// Check capability
	if currentStep.RequiredCapability != "" && capabilities != nil {
		if supported, ok := capabilities[currentStep.RequiredCapability]; !ok || !supported {
			currentStep.Status = StepStatusFailed
			currentStep.CompletedAt = &now
			currentStep.LeaseExpiresAt = nil
			currentStep.ExecutionOwner = ""
			currentStep.ObservedOutcome = fmt.Sprintf("Required capability [%s] is missing or unsupported in workspace",
				currentStep.RequiredCapability)

			err := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, ErrCapabilityMissing, caller.UserID)
			syncCallerRun(workingRun)
			return err
		}
	}

	// High risk approval pause
	if currentStep.IsHighRisk && workingRun.ApprovalState != ApprovalApproved {
		workingRun.CurrentState = StateAwaitingApproval
		currentStep.Status = StepStatusAwaitingApproval
		currentStep.LeaseExpiresAt = nil
		currentStep.ExecutionOwner = ""
		_ = r.store.UpdateRun(ctx, workingRun)
		syncCallerRun(workingRun)
		r.store.PublishEvent(ctx, DomainEvent{
			EventType:   "agent_run.approval_required",
			WorkspaceID: workingRun.WorkspaceID,
			Payload: map[string]any{
				"run_id":        workingRun.AgentRunID,
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
	usedDec, err := tenantdb.ParseExactDecimal(workingRun.CreditsUsed)
	if err != nil {
		usedDec = tenantdb.MustParseExactDecimal("0.000000")
	}
	stepCostDec, err := tenantdb.ParseExactDecimal(currentStep.EstimatedCredits)
	if err != nil {
		stepCostDec = tenantdb.MustParseExactDecimal("0.000000")
	}
	ceilingDec, err := tenantdb.ParseExactDecimal(workingRun.BudgetCeiling)
	if err != nil || ceilingDec.IsNegative() {
		return fmt.Errorf("%w: invalid budget ceiling %q", ErrInvalidBudgetCeiling, workingRun.BudgetCeiling)
	}

	newTotalDec, err := usedDec.Add(stepCostDec)
	if err != nil {
		return fmt.Errorf("credit addition overflow: %w", err)
	}

	// Enforce hard budget ceiling (F13: zero ceiling is NEVER treated as unlimited)
	if newTotalDec.Cmp(ceilingDec) > 0 {
		workingRun.CurrentState = StateWaitingContext
		currentStep.Status = StepStatusWaitingContext
		currentStep.LeaseExpiresAt = nil
		currentStep.ExecutionOwner = ""
		currentStep.ObservedOutcome = fmt.Sprintf("Budget ceiling reached: step requires %s credits, cumulative %s exceeds ceiling %s. Pausing execution.",
			currentStep.EstimatedCredits, newTotalDec.Fixed6String(), ceilingDec.Fixed6String())

		_ = r.store.UpdateRun(ctx, workingRun)
		syncCallerRun(workingRun)
		r.store.PublishEvent(ctx, DomainEvent{
			EventType:   "agent_run.waiting_context",
			WorkspaceID: workingRun.WorkspaceID,
			Payload: map[string]any{
				"run_id":                 workingRun.AgentRunID,
				"requested_context_type": "budget_increase",
				"prompt":                 currentStep.ObservedOutcome,
				"credits_used":           workingRun.CreditsUsed,
				"budget_ceiling":         workingRun.BudgetCeiling,
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
		currentStep.LeaseExpiresAt = nil
		currentStep.ExecutionOwner = ""
		currentStep.ObservedOutcome = fmt.Sprintf("Step %d execution failed: simulated downstream service fault", currentStep.StepOrder)
		err := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, fmt.Errorf("downstream fault at step %d", currentStep.StepOrder), caller.UserID)
		syncCallerRun(workingRun)
		return err
	}

	// Fail closed when no concrete StepExecutor is configured (AI-04 / R07).
	if r.executor == nil {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.LeaseExpiresAt = nil
		currentStep.ExecutionOwner = ""
		currentStep.ObservedOutcome = ErrExecutorNotConfigured.Error()
		err := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, ErrExecutorNotConfigured, caller.UserID)
		syncCallerRun(workingRun)
		return err
	}

	var remainingBudgetStr string
	if !ceilingDec.IsZero() {
		if remDec, rErr := ceilingDec.Sub(usedDec); rErr == nil {
			remainingBudgetStr = remDec.Fixed6String()
		}
	}

	execRes, err := r.executor.ExecuteStep(ctx, StepExecutionRequest{
		WorkspaceID:            workingRun.WorkspaceID,
		AgentRunID:             workingRun.AgentRunID,
		AgentType:              workingRun.AgentType,
		Caller:                 caller,
		Step:                   *currentStep,
		RemainingBudgetCredits: remainingBudgetStr,
		OperationKey:           currentStep.OperationKey,
		ExecutionOwner:         ownerID,
		FencingToken:           fencingToken,
	})
	if err != nil {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.LeaseExpiresAt = nil
		currentStep.ExecutionOwner = ""
		currentStep.ObservedOutcome = err.Error()
		fErr := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, err, caller.UserID)
		syncCallerRun(workingRun)
		return fErr
	}
	if execRes == nil || strings.TrimSpace(execRes.ObservedOutcome) == "" {
		currentStep.Status = StepStatusFailed
		currentStep.CompletedAt = &now
		currentStep.LeaseExpiresAt = nil
		currentStep.ExecutionOwner = ""
		currentStep.ObservedOutcome = ErrInvalidStepOutput.Error()
		fErr := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, ErrInvalidStepOutput, caller.UserID)
		syncCallerRun(workingRun)
		return fErr
	}

	actualStepCostDec := stepCostDec
	if strings.TrimSpace(execRes.ActualCredits) != "" {
		parsedActual, err := tenantdb.ParseExactDecimal(execRes.ActualCredits)
		if err != nil || parsedActual.IsNegative() {
			invalidErr := fmt.Errorf("%w: invalid actual credits %q", ErrInvalidStepOutput, execRes.ActualCredits)
			currentStep.Status = StepStatusFailed
			currentStep.CompletedAt = &now
			currentStep.LeaseExpiresAt = nil
			currentStep.ExecutionOwner = ""
			currentStep.ObservedOutcome = invalidErr.Error()
			fErr := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, invalidErr, caller.UserID)
			syncCallerRun(workingRun)
			return fErr
		}
		actualStepCostDec = parsedActual
	}

	var createdOutputs []AgentOutput
	for i := range execRes.Outputs {
		out := execRes.Outputs[i]
		if strings.TrimSpace(out.OutputType) == "" || strings.TrimSpace(out.Title) == "" {
			invalidErr := fmt.Errorf("%w: output missing required type or title", ErrInvalidStepOutput)
			currentStep.Status = StepStatusFailed
			currentStep.CompletedAt = &now
			currentStep.LeaseExpiresAt = nil
			currentStep.ExecutionOwner = ""
			currentStep.ObservedOutcome = invalidErr.Error()
			fErr := r.HandlePartialFailure(ctx, caller, workingRun, stepIndex, invalidErr, caller.UserID)
			syncCallerRun(workingRun)
			return fErr
		}
		if out.OutputID == "" {
			out.OutputID = NewID()
		}
		out.WorkspaceID = workingRun.WorkspaceID
		out.AgentRunID = workingRun.AgentRunID
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
		createdOutputs = append(createdOutputs, out)
	}

	var (
		exceededPostStepCeiling bool
		pauseMsg                string
	)
	if leaseStore, ok := r.store.(StepLeaseStore); ok && leaseStore != nil {
		committedRun, commitErr := leaseStore.MutateRunAtomically(ctx, workingRun.WorkspaceID, workingRun.AgentRunID, func(stored *AgentRun) error {
			if stepIndex < 0 || stepIndex >= len(stored.Steps) {
				return ErrStepNotFound
			}
			st := &stored.Steps[stepIndex]
			if st.FencingToken != fencingToken || st.ExecutionOwner != ownerID {
				return ErrStepAlreadyClaimed
			}
			authUsedDec, uErr := tenantdb.ParseExactDecimal(stored.CreditsUsed)
			if uErr != nil {
				authUsedDec = tenantdb.MustParseExactDecimal("0.000000")
			}
			updatedTotalDec, addErr := authUsedDec.Add(actualStepCostDec)
			if addErr != nil {
				return fmt.Errorf("credit addition overflow: %w", addErr)
			}
			authCeilingDec, cErr := tenantdb.ParseExactDecimal(stored.BudgetCeiling)
			if cErr != nil || authCeilingDec.IsNegative() {
				return fmt.Errorf("%w: invalid budget ceiling %q", ErrInvalidBudgetCeiling, stored.BudgetCeiling)
			}

			st.Status = StepStatusCompleted
			st.CompletedAt = &now
			st.ActualCredits = actualStepCostDec.Fixed6String()
			st.ObservedOutcome = execRes.ObservedOutcome
			st.LeaseExpiresAt = nil
			st.ExecutionOwner = ""
			st.UpdatedAt = now

			stored.CreditsUsed = updatedTotalDec.Fixed6String()
			stored.Outputs = append(stored.Outputs, createdOutputs...)
			if stored.Memory != nil {
				_ = stored.Memory.AddObservation(st.Title, st.ObservedOutcome)
			}

			if updatedTotalDec.Cmp(authCeilingDec) > 0 {
				exceededPostStepCeiling = true
				stored.CurrentState = StateWaitingContext
				pauseMsg = fmt.Sprintf("Budget ceiling reached after step %d: actual %s credits brought cumulative spend to %s (ceiling %s). Pausing execution.",
					st.StepOrder, actualStepCostDec.Fixed6String(), updatedTotalDec.Fixed6String(), authCeilingDec.Fixed6String())
				if stepIndex+1 < len(stored.Steps) && stored.Steps[stepIndex+1].Status == StepStatusPlanning {
					stored.Steps[stepIndex+1].Status = StepStatusWaitingContext
					stored.Steps[stepIndex+1].ObservedOutcome = pauseMsg
				}
			}
			return nil
		})
		if commitErr != nil {
			return commitErr
		}
		syncCallerRun(committedRun)
		if exceededPostStepCeiling {
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
		return nil
	}

	// Fallback path for non-StepLeaseStore implementations
	newTotalDec, err = usedDec.Add(actualStepCostDec)
	if err != nil {
		return fmt.Errorf("credit addition overflow: %w", err)
	}
	currentStep.Status = StepStatusCompleted
	currentStep.CompletedAt = &now
	currentStep.ActualCredits = actualStepCostDec.Fixed6String()
	currentStep.ObservedOutcome = execRes.ObservedOutcome
	currentStep.LeaseExpiresAt = nil
	currentStep.ExecutionOwner = ""
	workingRun.Outputs = append(workingRun.Outputs, createdOutputs...)
	workingRun.CreditsUsed = newTotalDec.Fixed6String()
	if workingRun.Memory != nil {
		_ = workingRun.Memory.AddObservation(currentStep.Title, currentStep.ObservedOutcome)
	}
	if newTotalDec.Cmp(ceilingDec) > 0 {
		workingRun.CurrentState = StateWaitingContext
		pauseMsg = fmt.Sprintf("Budget ceiling reached after step %d: actual %s credits brought cumulative spend to %s (ceiling %s). Pausing execution.",
			currentStep.StepOrder, actualStepCostDec.Fixed6String(), newTotalDec.Fixed6String(), ceilingDec.Fixed6String())
		if stepIndex+1 < len(workingRun.Steps) && workingRun.Steps[stepIndex+1].Status == StepStatusPlanning {
			workingRun.Steps[stepIndex+1].Status = StepStatusWaitingContext
			workingRun.Steps[stepIndex+1].ObservedOutcome = pauseMsg
		}
		_ = r.store.UpdateRun(ctx, workingRun)
		syncCallerRun(workingRun)
		r.store.PublishEvent(ctx, DomainEvent{
			EventType:   "agent_run.waiting_context",
			WorkspaceID: workingRun.WorkspaceID,
			Payload: map[string]any{
				"run_id":                 workingRun.AgentRunID,
				"requested_context_type": "budget_increase",
				"prompt":                 pauseMsg,
				"credits_used":           workingRun.CreditsUsed,
				"budget_ceiling":         workingRun.BudgetCeiling,
			},
			OccurredAt: now,
		})
		return ErrBudgetCeilingExceeded
	}
	if err := r.store.UpdateRun(ctx, workingRun); err != nil {
		return err
	}
	syncCallerRun(workingRun)
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

package agent

import (
	"context"
	"errors"
	"strings"

	"connectrpc.com/connect"
	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1/automationv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

// MembershipRoleResolver looks up a user's active workspace membership role.
type MembershipRoleResolver func(ctx context.Context, workspaceID, userID string) (role string, active bool, err error)

// AgentHandler implements automationv1connect.AgentServiceHandler.
type AgentHandler struct {
	service      *Service
	roleResolver MembershipRoleResolver
}

func NewAgentHandler(service *Service) *AgentHandler {
	return &AgentHandler{service: service}
}

// WithMembershipRoleResolver configures a workspace membership role resolver for AgentHandler.
func (h *AgentHandler) WithMembershipRoleResolver(resolver MembershipRoleResolver) *AgentHandler {
	h.roleResolver = resolver
	if h.service != nil {
		h.service.SetMembershipRoleResolver(resolver)
	}
	return h
}

var _ automationv1connect.AgentServiceHandler = (*AgentHandler)(nil)

func (h *AgentHandler) resolveCaller(ctx context.Context, explicitWorkspaceID string, requiredPerm string) (CallerContext, error) {
	session, ok := transportauth.PrincipalFromContext(ctx)
	if !ok || strings.TrimSpace(session.UserID) == "" || strings.TrimSpace(session.WorkspaceID) == "" {
		return CallerContext{}, connect.NewError(connect.CodeUnauthenticated, errors.New("authenticated workspace principal required"))
	}
	if session.InternalAdmin || session.ServiceKeyID != "" {
		return CallerContext{}, connect.NewError(connect.CodePermissionDenied, errors.New("workspace user principal required"))
	}
	if explicitWorkspaceID != "" && explicitWorkspaceID != session.WorkspaceID {
		return CallerContext{}, connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}

	role := strings.TrimSpace(session.Role)
	if h.roleResolver != nil {
		resolvedRole, active, err := h.roleResolver(ctx, session.WorkspaceID, session.UserID)
		if err != nil {
			return CallerContext{}, connect.NewError(connect.CodePermissionDenied, err)
		}
		if !active {
			return CallerContext{}, connect.NewError(connect.CodePermissionDenied, errors.New("active workspace membership required"))
		}
		role = strings.TrimSpace(resolvedRole)
	} else if h.service != nil && h.service.store != nil {
		if memStore, ok := h.service.store.(WorkspaceMembershipStore); ok && memStore != nil {
			resolvedRole, active, found, err := memStore.ResolveWorkspaceMemberRole(ctx, session.WorkspaceID, session.UserID)
			if err != nil {
				return CallerContext{}, connect.NewError(connect.CodePermissionDenied, err)
			}
			if found {
				if isInactiveOrRevokedAgentRole(resolvedRole, active) {
					return CallerContext{}, connect.NewError(connect.CodePermissionDenied, errors.New("active workspace membership required"))
				}
				role = strings.TrimSpace(resolvedRole)
			}
		}
	}
	if role == "" || !rbac.IsValidWorkspaceRole(role) {
		return CallerContext{}, connect.NewError(connect.CodePermissionDenied, errors.New("verified workspace membership role required"))
	}

	if requiredPerm != "" {
		if err := rbac.CheckWorkspacePermission(requiredPerm, rbac.PolicyContext{
			ActorUserID: session.UserID,
			WorkspaceID: session.WorkspaceID,
			Role:        role,
		}); err != nil {
			return CallerContext{}, connect.NewError(connect.CodePermissionDenied, err)
		}
	}

	return CallerContext{
		UserID:        session.UserID,
		WorkspaceID:   session.WorkspaceID,
		WorkspaceRole: role,
	}, nil
}

func toConnectError(err error) error {
	if err == nil {
		return nil
	}
	var connectErr *connect.Error
	if errors.As(err, &connectErr) {
		return connectErr
	}
	if errors.Is(err, ErrRunNotFound) || errors.Is(err, ErrStepNotFound) {
		return connect.NewError(connect.CodeNotFound, err)
	}
	if errors.Is(err, ErrPermissionDenied) || errors.Is(err, ErrCrossTenantDenied) {
		return connect.NewError(connect.CodePermissionDenied, err)
	}
	if errors.Is(err, ErrInvalidBudgetCeiling) {
		return connect.NewError(connect.CodeInvalidArgument, err)
	}
	if errors.Is(err, ErrCapabilityMissing) || errors.Is(err, ErrBudgetCeilingExceeded) ||
		errors.Is(err, ErrApprovalRequired) || errors.Is(err, ErrInvalidStateTransition) ||
		errors.Is(err, ErrRunAlreadyFinished) {
		return connect.NewError(connect.CodeFailedPrecondition, err)
	}
	return connect.NewError(connect.CodeInternal, err)
}

func (h *AgentHandler) LaunchAgent(
	ctx context.Context,
	req *connect.Request[automationv1.AgentServiceLaunchAgentRequest],
) (*connect.Response[automationv1.AgentServiceLaunchAgentResponse], error) {
	caller, err := h.resolveCaller(ctx, req.Msg.WorkspaceId, "agent:execute")
	if err != nil {
		return nil, err
	}

	run, warnings, requiresApproval, err := h.service.LaunchAgent(
		ctx,
		caller,
		ProtoToAgentType(req.Msg.AgentType),
		req.Msg.TaskPrompt,
		req.Msg.RecipeId,
		req.Msg.WorkflowId,
		req.Msg.BudgetCeilingCredits,
		req.Msg.ExecutionScopeJson,
		req.Msg.AutoExecute,
		req.Msg.Parameters,
	)
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) || errors.Is(err, ErrCrossTenantDenied) {
			return nil, toConnectError(err)
		}
		rejection := err.Error()
		return connect.NewResponse(&automationv1.AgentServiceLaunchAgentResponse{
			Success:            false,
			Run:                RunToProto(run),
			PermissionWarnings: warnings,
			RequiresApproval:   requiresApproval,
			RejectionReason:    rejection,
		}), nil
	}

	return connect.NewResponse(&automationv1.AgentServiceLaunchAgentResponse{
		Success:            true,
		Run:                RunToProto(run),
		PermissionWarnings: warnings,
		RequiresApproval:   requiresApproval,
	}), nil
}

func (h *AgentHandler) ListRuns(
	ctx context.Context,
	req *connect.Request[automationv1.AgentServiceListRunsRequest],
) (*connect.Response[automationv1.AgentServiceListRunsResponse], error) {
	caller, err := h.resolveCaller(ctx, req.Msg.WorkspaceId, "workflow:read")
	if err != nil {
		return nil, err
	}

	agentType := ""
	if req.Msg.AgentType != automationv1.AgentType_AGENT_TYPE_UNSPECIFIED {
		agentType = ProtoToAgentType(req.Msg.AgentType)
	}
	stateFilter := ""
	if req.Msg.StateFilter != automationv1.AgentRunState_AGENT_RUN_STATE_UNSPECIFIED {
		stateFilter = req.Msg.StateFilter.String()
	}

	runs, nextPageToken, total, err := h.service.ListRuns(
		ctx,
		caller,
		agentType,
		stateFilter,
		int(req.Msg.PageSize),
		req.Msg.PageToken,
	)
	if err != nil {
		return nil, toConnectError(err)
	}

	var protoRuns []*automationv1.AgentRun
	for i := range runs {
		protoRuns = append(protoRuns, RunToProto(&runs[i]))
	}

	return connect.NewResponse(&automationv1.AgentServiceListRunsResponse{
		Runs:          protoRuns,
		NextPageToken: nextPageToken,
		TotalCount:    int32(total),
	}), nil
}

func (h *AgentHandler) CancelRun(
	ctx context.Context,
	req *connect.Request[automationv1.AgentServiceCancelRunRequest],
) (*connect.Response[automationv1.AgentServiceCancelRunResponse], error) {
	caller, err := h.resolveCaller(ctx, req.Msg.WorkspaceId, "agent:execute")
	if err != nil {
		return nil, err
	}

	run, err := h.service.CancelRun(ctx, caller, req.Msg.AgentRunId, req.Msg.Reason)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.AgentServiceCancelRunResponse{
		Success: true,
		Run:     RunToProto(run),
	}), nil
}

func (h *AgentHandler) StreamRun(
	ctx context.Context,
	req *connect.Request[automationv1.AgentServiceStreamRunRequest],
) (*connect.Response[automationv1.AgentServiceStreamRunResponse], error) {
	caller, err := h.resolveCaller(ctx, req.Msg.WorkspaceId, "workflow:read")
	if err != nil {
		return nil, err
	}

	run, currentStep, msg, percent, err := h.service.StreamRun(ctx, caller, req.Msg.AgentRunId)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.AgentServiceStreamRunResponse{
		Run:             RunToProto(run),
		CurrentStep:     StepToProto(currentStep),
		ProgressMessage: msg,
		ProgressPercent: percent,
	}), nil
}

func (h *AgentHandler) ProvideInput(
	ctx context.Context,
	req *connect.Request[automationv1.AgentServiceProvideInputRequest],
) (*connect.Response[automationv1.AgentServiceProvideInputResponse], error) {
	caller, err := h.resolveCaller(ctx, req.Msg.WorkspaceId, "agent:execute")
	if err != nil {
		return nil, err
	}

	run, err := h.service.ProvideInput(
		ctx,
		caller,
		req.Msg.AgentRunId,
		req.Msg.InputText,
		req.Msg.InputJson,
		req.Msg.ApprovePlan,
		req.Msg.BudgetCeilingIncrease,
		req.Msg.HandoffTargetUserId,
	)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.AgentServiceProvideInputResponse{
		Success: true,
		Run:     RunToProto(run),
	}), nil
}

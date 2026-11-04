package agent

import (
	"context"
	"errors"

	"connectrpc.com/connect"
	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1/automationv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

// AgentHandler implements automationv1connect.AgentServiceHandler.
type AgentHandler struct {
	service *Service
}

func NewAgentHandler(service *Service) *AgentHandler {
	return &AgentHandler{service: service}
}

var _ automationv1connect.AgentServiceHandler = (*AgentHandler)(nil)

func resolveCaller(ctx context.Context, explicitWorkspaceID string) (CallerContext, error) {
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.WorkspaceID != "" {
		if explicitWorkspaceID != "" && explicitWorkspaceID != session.WorkspaceID && !session.InternalAdmin {
			return CallerContext{}, connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
		}
		role := "owner"
		if session.InternalAdmin {
			role = "admin"
		}
		return CallerContext{
			UserID:        session.UserID,
			WorkspaceID:   session.WorkspaceID,
			WorkspaceRole: role,
		}, nil
	}
	if explicitWorkspaceID != "" {
		return CallerContext{
			UserID:        "00000000-0000-0000-0000-000000000001",
			WorkspaceID:   explicitWorkspaceID,
			WorkspaceRole: "owner",
		}, nil
	}
	return CallerContext{}, connect.NewError(connect.CodeUnauthenticated, errors.New("missing workspace or tenant context"))
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
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
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
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
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
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
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
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
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
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
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

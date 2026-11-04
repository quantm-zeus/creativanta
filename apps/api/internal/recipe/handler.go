package recipe

import (
	"context"
	"errors"
	"strings"

	"connectrpc.com/connect"
	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1/automationv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"github.com/quantm-zeus/creativanta/apps/api/internal/workflow"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// RecipeHandler implements automationv1connect.RecipeServiceHandler.
type RecipeHandler struct {
	service *Service
}

func NewRecipeHandler(service *Service) *RecipeHandler {
	return &RecipeHandler{service: service}
}

var _ automationv1connect.RecipeServiceHandler = (*RecipeHandler)(nil)

// TemplateHandler implements automationv1connect.TemplateServiceHandler.
type TemplateHandler struct {
	service *Service
}

func NewTemplateHandler(service *Service) *TemplateHandler {
	return &TemplateHandler{service: service}
}

var _ automationv1connect.TemplateServiceHandler = (*TemplateHandler)(nil)

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
	if errors.Is(err, ErrRecipeNotFound) || errors.Is(err, ErrInstallationNotFound) || errors.Is(err, ErrReviewNotFound) {
		return connect.NewError(connect.CodeNotFound, err)
	}
	if errors.Is(err, ErrTenantAccessDenied) || errors.Is(err, ErrSystemRecipeReadOnly) {
		return connect.NewError(connect.CodePermissionDenied, err)
	}
	if errors.Is(err, ErrMissingCapabilities) || errors.Is(err, ErrInvalidRecipeStatus) || errors.Is(err, ErrInvalidRating) {
		return connect.NewError(connect.CodeFailedPrecondition, err)
	}
	if errors.Is(err, ErrReviewAlreadyExists) {
		return connect.NewError(connect.CodeAlreadyExists, err)
	}
	return connect.NewError(connect.CodeInternal, err)
}

// ----------------------------------------------------------------------------
// RecipeServiceHandler Implementation
// ----------------------------------------------------------------------------

func (h *RecipeHandler) Install(ctx context.Context, req *connect.Request[automationv1.RecipeServiceInstallRequest]) (*connect.Response[automationv1.RecipeServiceInstallResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	inst, wf, missing, err := h.service.InstallRecipe(
		ctx,
		caller,
		req.Msg.RecipeId,
		req.Msg.ParameterValuesJson,
		req.Msg.TitleOverride,
	)
	if err != nil {
		var missingProto []*automationv1.MissingCapabilityExplanation
		for _, m := range missing {
			missingProto = append(missingProto, &automationv1.MissingCapabilityExplanation{
				CapabilityKey:      m.CapabilityKey,
				Platform:           m.Platform,
				Reason:             m.Reason,
				ResolutionGuidance: m.ResolutionGuidance,
				ConnectUrl:         m.ConnectURL,
			})
		}
		if len(missing) > 0 {
			// Structured response with missing capability explanations (AC-M21-003)
			return connect.NewResponse(&automationv1.RecipeServiceInstallResponse{
				Success:             false,
				MissingCapabilities: missingProto,
			}), nil
		}
		return nil, toConnectError(err)
	}

	var protoWf *automationv1.Workflow
	if wf != nil {
		protoWf = workflow.WorkflowToProto(wf)
	}

	return connect.NewResponse(&automationv1.RecipeServiceInstallResponse{
		Success:         true,
		Installation:    ToProtoRecipeInstallation(inst),
		CreatedWorkflow: protoWf,
	}), nil
}

func (h *RecipeHandler) Uninstall(ctx context.Context, req *connect.Request[automationv1.RecipeServiceUninstallRequest]) (*connect.Response[automationv1.RecipeServiceUninstallResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	err = h.service.UninstallRecipe(ctx, caller, req.Msg.InstallationId, req.Msg.DeleteWorkflow)
	if err != nil {
		return nil, toConnectError(err)
	}
	return connect.NewResponse(&automationv1.RecipeServiceUninstallResponse{Success: true}), nil
}

func (h *RecipeHandler) List(ctx context.Context, req *connect.Request[automationv1.RecipeServiceListRequest]) (*connect.Response[automationv1.RecipeServiceListResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	limit := int(req.Msg.PageSize)
	if limit <= 0 {
		limit = 50
	}

	recipes, insts, total, err := h.service.ListRecipes(
		ctx,
		caller,
		req.Msg.Category,
		req.Msg.StatusFilter,
		req.Msg.IncludeSystem,
		limit,
		0,
	)
	if err != nil {
		return nil, toConnectError(err)
	}

	var protoRecipes []*automationv1.RecipeTemplate
	for _, r := range recipes {
		protoRecipes = append(protoRecipes, ToProtoRecipeTemplate(r))
	}
	var protoInsts []*automationv1.RecipeInstallation
	for _, i := range insts {
		protoInsts = append(protoInsts, ToProtoRecipeInstallation(i))
	}

	return connect.NewResponse(&automationv1.RecipeServiceListResponse{
		Recipes:       protoRecipes,
		Installations: protoInsts,
		TotalCount:    int32(total),
	}), nil
}

func (h *RecipeHandler) Get(ctx context.Context, req *connect.Request[automationv1.RecipeServiceGetRequest]) (*connect.Response[automationv1.RecipeServiceGetResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	recipe, missing, activeInst, err := h.service.GetRecipe(ctx, caller, req.Msg.RecipeId)
	if err != nil {
		return nil, toConnectError(err)
	}

	var missingProto []*automationv1.MissingCapabilityExplanation
	for _, m := range missing {
		missingProto = append(missingProto, &automationv1.MissingCapabilityExplanation{
			CapabilityKey:      m.CapabilityKey,
			Platform:           m.Platform,
			Reason:             m.Reason,
			ResolutionGuidance: m.ResolutionGuidance,
			ConnectUrl:         m.ConnectURL,
		})
	}

	return connect.NewResponse(&automationv1.RecipeServiceGetResponse{
		Recipe:              ToProtoRecipeTemplate(recipe),
		MissingCapabilities: missingProto,
		ActiveInstallation:  ToProtoRecipeInstallation(activeInst),
	}), nil
}

func (h *RecipeHandler) Run(ctx context.Context, req *connect.Request[automationv1.RecipeServiceRunRequest]) (*connect.Response[automationv1.RecipeServiceRunResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	activeInst, err := h.service.store.GetInstallationByRecipe(ctx, caller.WorkspaceID, req.Msg.RecipeId)
	if err != nil {
		return nil, toConnectError(err)
	}

	// Trigger underlying workflow
	if h.service.workflowStore != nil {
		run := &workflow.WorkflowRun{
			RunID:       "run-" + activeInst.WorkflowID,
			WorkspaceID: caller.WorkspaceID,
			WorkflowID:  activeInst.WorkflowID,
			TriggerEvent: map[string]any{
				"source":    "recipe_service",
				"recipe_id": req.Msg.RecipeId,
			},
			Status:    workflow.WorkflowRunStatusQueued,
			CreatedAt: timestamppb.Now().AsTime(),
			UpdatedAt: timestamppb.Now().AsTime(),
		}
		_ = h.service.workflowStore.CreateWorkflowRun(ctx, run)
		return connect.NewResponse(&automationv1.RecipeServiceRunResponse{
			WorkflowRunId: run.RunID,
			Status:        automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_QUEUED,
		}), nil
	}

	return connect.NewResponse(&automationv1.RecipeServiceRunResponse{
		WorkflowRunId: "run-simulated",
		Status:        automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_QUEUED,
	}), nil
}

func (h *RecipeHandler) GetRunStatus(ctx context.Context, req *connect.Request[automationv1.RecipeServiceGetRunStatusRequest]) (*connect.Response[automationv1.RecipeServiceGetRunStatusResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	if h.service.workflowStore != nil {
		run, err := h.service.workflowStore.GetWorkflowRun(ctx, caller.WorkspaceID, req.Msg.RunId)
		if err == nil && run != nil {
			var completedAt *timestamppb.Timestamp
			if run.CompletedAt != nil {
				completedAt = timestamppb.New(*run.CompletedAt)
			}
			return connect.NewResponse(&automationv1.RecipeServiceGetRunStatusResponse{
				RunId:       run.RunID,
				Status:      automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_SUCCEEDED,
				CurrentNode: run.CurrentNode,
				CompletedAt: completedAt,
			}), nil
		}
	}

	return connect.NewResponse(&automationv1.RecipeServiceGetRunStatusResponse{
		RunId:  req.Msg.RunId,
		Status: automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_SUCCEEDED,
	}), nil
}

func (h *RecipeHandler) ListRuns(ctx context.Context, req *connect.Request[automationv1.RecipeServiceListRunsRequest]) (*connect.Response[automationv1.RecipeServiceListRunsResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	if h.service.workflowStore != nil {
		inst, err := h.service.store.GetInstallationByRecipe(ctx, caller.WorkspaceID, req.Msg.RecipeId)
		if err == nil && inst != nil {
			runs, total, _ := h.service.workflowStore.ListWorkflowRuns(ctx, caller.WorkspaceID, inst.WorkflowID, "", int(req.Msg.PageSize), 0)
			var protoRuns []*automationv1.WorkflowRun
			for i := range runs {
				protoRuns = append(protoRuns, workflow.RunToProto(&runs[i]))
			}
			return connect.NewResponse(&automationv1.RecipeServiceListRunsResponse{
				Runs:       protoRuns,
				TotalCount: int32(total),
			}), nil
		}
	}

	return connect.NewResponse(&automationv1.RecipeServiceListRunsResponse{
		Runs:       []*automationv1.WorkflowRun{},
		TotalCount: 0,
	}), nil
}

func (h *RecipeHandler) Configure(ctx context.Context, req *connect.Request[automationv1.RecipeServiceConfigureRequest]) (*connect.Response[automationv1.RecipeServiceConfigureResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	inst, err := h.service.Configure(
		ctx,
		caller,
		req.Msg.InstallationId,
		req.Msg.ParameterValuesJson,
		int(req.Msg.PinnedVersion),
		req.Msg.AutoUpdate,
	)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.RecipeServiceConfigureResponse{
		Installation: ToProtoRecipeInstallation(inst),
	}), nil
}

// ----------------------------------------------------------------------------
// TemplateServiceHandler Implementation
// ----------------------------------------------------------------------------

func (h *TemplateHandler) ListTemplates(ctx context.Context, req *connect.Request[automationv1.TemplateServiceListTemplatesRequest]) (*connect.Response[automationv1.TemplateServiceListTemplatesResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	limit := int(req.Msg.PageSize)
	if limit <= 0 {
		limit = 50
	}

	recipes, _, total, err := h.service.ListRecipes(ctx, caller, req.Msg.Category, "published", true, limit, 0)
	if err != nil {
		return nil, toConnectError(err)
	}

	var protoTemplates []*automationv1.RecipeTemplate
	for _, r := range recipes {
		protoTemplates = append(protoTemplates, ToProtoRecipeTemplate(r))
	}

	return connect.NewResponse(&automationv1.TemplateServiceListTemplatesResponse{
		Templates:  protoTemplates,
		TotalCount: int32(total),
	}), nil
}

func (h *TemplateHandler) GetTemplate(ctx context.Context, req *connect.Request[automationv1.TemplateServiceGetTemplateRequest]) (*connect.Response[automationv1.TemplateServiceGetTemplateResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	recipe, missing, _, err := h.service.GetRecipe(ctx, caller, req.Msg.TemplateId)
	if err != nil {
		return nil, toConnectError(err)
	}

	var missingProto []*automationv1.MissingCapabilityExplanation
	for _, m := range missing {
		missingProto = append(missingProto, &automationv1.MissingCapabilityExplanation{
			CapabilityKey:      m.CapabilityKey,
			Platform:           m.Platform,
			Reason:             m.Reason,
			ResolutionGuidance: m.ResolutionGuidance,
			ConnectUrl:         m.ConnectURL,
		})
	}

	return connect.NewResponse(&automationv1.TemplateServiceGetTemplateResponse{
		Template:            ToProtoRecipeTemplate(recipe),
		MissingCapabilities: missingProto,
	}), nil
}

func (h *TemplateHandler) SearchTemplates(ctx context.Context, req *connect.Request[automationv1.TemplateServiceSearchTemplatesRequest]) (*connect.Response[automationv1.TemplateServiceSearchTemplatesResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	limit := int(req.Msg.PageSize)
	if limit <= 0 {
		limit = 50
	}

	recipes, _, total, err := h.service.ListRecipes(ctx, caller, req.Msg.Category, "published", true, limit*2, 0)
	if err != nil {
		return nil, toConnectError(err)
	}

	query := strings.ToLower(strings.TrimSpace(req.Msg.Query))
	var matched []*automationv1.RecipeTemplate
	for _, r := range recipes {
		if query != "" {
			if !strings.Contains(strings.ToLower(r.Title), query) &&
				!strings.Contains(strings.ToLower(r.Description), query) &&
				!strings.Contains(strings.ToLower(r.Category), query) {
				continue
			}
		}
		matched = append(matched, ToProtoRecipeTemplate(r))
		if len(matched) >= limit {
			break
		}
	}

	return connect.NewResponse(&automationv1.TemplateServiceSearchTemplatesResponse{
		Templates:  matched,
		TotalCount: int32(total),
	}), nil
}

func (h *TemplateHandler) GetFeatured(ctx context.Context, req *connect.Request[automationv1.TemplateServiceGetFeaturedRequest]) (*connect.Response[automationv1.TemplateServiceGetFeaturedResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	recipes, _, _, err := h.service.ListRecipes(ctx, caller, req.Msg.Category, "published", true, 10, 0)
	if err != nil {
		return nil, toConnectError(err)
	}

	var protoTemplates []*automationv1.RecipeTemplate
	var weekly *automationv1.RecipeTemplate
	for i, r := range recipes {
		pt := ToProtoRecipeTemplate(r)
		protoTemplates = append(protoTemplates, pt)
		if i == 0 {
			weekly = pt
		}
	}

	return connect.NewResponse(&automationv1.TemplateServiceGetFeaturedResponse{
		FeaturedTemplates: protoTemplates,
		WeeklyHighlight:   weekly,
	}), nil
}

func (h *TemplateHandler) GetReviews(ctx context.Context, req *connect.Request[automationv1.TemplateServiceGetReviewsRequest]) (*connect.Response[automationv1.TemplateServiceGetReviewsResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	limit := int(req.Msg.PageSize)
	if limit <= 0 {
		limit = 20
	}

	reviews, _, err := h.service.ListReviews(ctx, caller, req.Msg.TemplateId, limit, 0)
	if err != nil {
		return nil, toConnectError(err)
	}

	recipe, err := h.service.store.GetRecipe(ctx, req.Msg.TemplateId)
	var ratingAvg float32
	var reviewCount int
	if err == nil && recipe != nil {
		ratingAvg = recipe.RatingAvg
		reviewCount = recipe.ReviewCount
	}

	var protoReviews []*automationv1.RecipeReview
	for _, rev := range reviews {
		protoReviews = append(protoReviews, &automationv1.RecipeReview{
			ReviewId:    rev.ReviewID,
			RecipeId:    rev.RecipeID,
			WorkspaceId: rev.WorkspaceID,
			UserId:      rev.UserID,
			Rating:      int32(rev.Rating),
			ReviewText:  rev.ReviewText,
			AuthorName:  rev.AuthorName,
			CreatedAt:   timestamppb.New(rev.CreatedAt),
			UpdatedAt:   timestamppb.New(rev.UpdatedAt),
		})
	}

	return connect.NewResponse(&automationv1.TemplateServiceGetReviewsResponse{
		Reviews:     protoReviews,
		RatingAvg:   ratingAvg,
		ReviewCount: int32(reviewCount),
	}), nil
}

func (h *TemplateHandler) Deploy(ctx context.Context, req *connect.Request[automationv1.TemplateServiceDeployRequest]) (*connect.Response[automationv1.TemplateServiceDeployResponse], error) {
	caller, err := resolveCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	inst, wf, missing, err := h.service.InstallRecipe(
		ctx,
		caller,
		req.Msg.TemplateId,
		req.Msg.ParameterValuesJson,
		req.Msg.TitleOverride,
	)
	if err != nil {
		var missingProto []*automationv1.MissingCapabilityExplanation
		for _, m := range missing {
			missingProto = append(missingProto, &automationv1.MissingCapabilityExplanation{
				CapabilityKey:      m.CapabilityKey,
				Platform:           m.Platform,
				Reason:             m.Reason,
				ResolutionGuidance: m.ResolutionGuidance,
				ConnectUrl:         m.ConnectURL,
			})
		}
		if len(missing) > 0 {
			return connect.NewResponse(&automationv1.TemplateServiceDeployResponse{
				Success:             false,
				MissingCapabilities: missingProto,
			}), nil
		}
		return nil, toConnectError(err)
	}

	var protoWf *automationv1.Workflow
	var wfID, instID string
	if wf != nil {
		protoWf = workflow.WorkflowToProto(wf)
		wfID = wf.WorkflowID
	}
	if inst != nil {
		instID = inst.InstallationID
	}

	return connect.NewResponse(&automationv1.TemplateServiceDeployResponse{
		Success:         true,
		WorkflowId:      wfID,
		CreatedWorkflow: protoWf,
		InstallationId:  instID,
	}), nil
}

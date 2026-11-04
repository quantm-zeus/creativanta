package production

import (
	"context"
	"errors"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1/productionv1connect"
)

// ABTestServiceServer implements productionv1connect.ABTestServiceHandler.
type ABTestServiceServer struct {
	svc *Service
}

var _ productionv1connect.ABTestServiceHandler = (*ABTestServiceServer)(nil)

// Create initializes an A/B test experiment.
func (s *ABTestServiceServer) Create(ctx context.Context, req *connect.Request[productionv1.ABTestServiceCreateRequest]) (*connect.Response[productionv1.ABTestServiceCreateResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	var variants []*ABVariantRecord
	for _, v := range req.Msg.GetVariants() {
		variants = append(variants, &ABVariantRecord{
			VariantID:      v.GetVariantId(),
			AssetID:        v.GetAssetId(),
			PublishItemID:  v.GetPublishItemId(),
			VariantType:    v.GetVariantType(),
			VariantLabel:   v.GetVariantLabel(),
			Impressions:    v.GetImpressions(),
			Views:          v.GetViews(),
			Clicks:         v.GetClicks(),
			CTR:            v.GetCtr(),
			Conversions:    v.GetConversions(),
			EngagementRate: v.GetEngagementRate(),
		})
	}

	exp, err := s.svc.ABTestMgr.CreateExperiment(
		ctx,
		caller,
		req.Msg.GetSourceAssetId(),
		req.Msg.GetTitle(),
		req.Msg.GetHypothesis(),
		req.Msg.GetTargetMetric(),
		int(req.Msg.GetMinDurationHours()),
		req.Msg.GetMinImpressionsPerVariant(),
		req.Msg.GetAutoWinnerThresholdMultiplier(),
		variants,
	)
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&productionv1.ABTestServiceCreateResponse{
		Experiment: experimentRecordToProto(exp),
	}), nil
}

// Get returns details of an experiment.
func (s *ABTestServiceServer) Get(ctx context.Context, req *connect.Request[productionv1.ABTestServiceGetRequest]) (*connect.Response[productionv1.ABTestServiceGetResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	exp, err := s.svc.ABTestMgr.GetExperiment(ctx, caller, req.Msg.GetExperimentId())
	if err != nil {
		if errors.Is(err, ErrExperimentNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.ABTestServiceGetResponse{
		Experiment: experimentRecordToProto(exp),
	}), nil
}

// List returns a list of experiments.
func (s *ABTestServiceServer) List(ctx context.Context, req *connect.Request[productionv1.ABTestServiceListRequest]) (*connect.Response[productionv1.ABTestServiceListResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	list, err := s.svc.ABTestMgr.ListExperiments(ctx, caller, req.Msg.GetSourceAssetId(), req.Msg.GetStatus())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoList []*productionv1.ABExperiment
	for _, e := range list {
		protoList = append(protoList, experimentRecordToProto(e))
	}

	total := int64(len(protoList))
	return connect.NewResponse(&productionv1.ABTestServiceListResponse{
		Experiments: protoList,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
		},
	}), nil
}

// DeclareWinner manually declares a winning variant.
func (s *ABTestServiceServer) DeclareWinner(ctx context.Context, req *connect.Request[productionv1.ABTestServiceDeclareWinnerRequest]) (*connect.Response[productionv1.ABTestServiceDeclareWinnerResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	exp, err := s.svc.ABTestMgr.DeclareWinner(ctx, caller, req.Msg.GetExperimentId(), req.Msg.GetWinnerAssetId(), req.Msg.GetReason())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&productionv1.ABTestServiceDeclareWinnerResponse{
		Experiment:                 experimentRecordToProto(exp),
		ObservationalLabelRetained: true,
	}), nil
}

// Cancel cancels a running experiment.
func (s *ABTestServiceServer) Cancel(ctx context.Context, req *connect.Request[productionv1.ABTestServiceCancelRequest]) (*connect.Response[productionv1.ABTestServiceCancelResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	exp, err := s.svc.ABTestMgr.CancelExperiment(ctx, caller, req.Msg.GetExperimentId(), req.Msg.GetReason())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}

	return connect.NewResponse(&productionv1.ABTestServiceCancelResponse{
		Experiment: experimentRecordToProto(exp),
		Success:    true,
	}), nil
}

// EvaluateTest evaluates test results against statistical lift and exposure thresholds.
func (s *ABTestServiceServer) EvaluateTest(ctx context.Context, req *connect.Request[productionv1.ABTestServiceEvaluateTestRequest]) (*connect.Response[productionv1.ABTestServiceEvaluateTestResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	exp, isConclusive, summary, err := s.svc.ABTestMgr.EvaluateTest(ctx, caller, req.Msg.GetExperimentId())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.ABTestServiceEvaluateTestResponse{
		Experiment:        experimentRecordToProto(exp),
		IsConclusive:      isConclusive,
		IsObservational:   true, // Acceptance Target 2: Observational label retained!
		WinnerAssetId:     exp.WinnerAssetID,
		EvaluationSummary: summary,
	}), nil
}

// GetMetrics returns real-time metrics for variants.
func (s *ABTestServiceServer) GetMetrics(ctx context.Context, req *connect.Request[productionv1.ABTestServiceGetMetricsRequest]) (*connect.Response[productionv1.ABTestServiceGetMetricsResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	_, variants, leadingID, hasSufficient, err := s.svc.ABTestMgr.GetMetrics(ctx, caller, req.Msg.GetExperimentId())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	var protoVariants []*productionv1.ABVariant
	for _, v := range variants {
		protoVariants = append(protoVariants, variantRecordToProto(v))
	}

	return connect.NewResponse(&productionv1.ABTestServiceGetMetricsResponse{
		ExperimentId:          req.Msg.GetExperimentId(),
		Variants:              protoVariants,
		LeadingVariantId:      leadingID,
		IsObservational:       true, // Observational label retained!
		HasSufficientExposure: hasSufficient,
	}), nil
}

func experimentRecordToProto(e *ABExperimentRecord) *productionv1.ABExperiment {
	if e == nil {
		return nil
	}
	var protoVariants []*productionv1.ABVariant
	for _, v := range e.Variants {
		protoVariants = append(protoVariants, variantRecordToProto(v))
	}

	p := &productionv1.ABExperiment{
		ExperimentId:                  e.ExperimentID,
		SourceAssetId:                 e.SourceAssetID,
		Title:                         e.Title,
		Hypothesis:                    e.Hypothesis,
		VariantAssetIds:               e.VariantAssetIDs,
		VariantCount:                  int32(e.VariantCount),
		TargetMetric:                  e.TargetMetric,
		MinDurationHours:              int32(e.MinDurationHours),
		MinImpressionsPerVariant:      e.MinImpressionsPerVariant,
		AutoWinnerThresholdMultiplier: e.AutoWinnerThresholdMultiplier,
		Status:                        e.Status,
		ResultStatus:                  e.ResultStatus,
		WinnerAssetId:                 e.WinnerAssetID,
		IsObservational:               e.IsObservational,
		InconclusiveReason:            e.InconclusiveReason,
		Variants:                      protoVariants,
	}

	if e.Criteria != nil {
		p.Criteria = &productionv1.AutoWinnerCriteria{
			Metric:              e.Criteria.Metric,
			ThresholdMultiplier: e.Criteria.ThresholdMultiplier,
			MinDurationHours:    int32(e.Criteria.MinDurationHours),
			MinImpressions:      e.Criteria.MinImpressions,
		}
	}
	if e.StartedAt != nil {
		p.StartedAt = timestamppb.New(*e.StartedAt)
	}
	if e.CompletedAt != nil {
		p.CompletedAt = timestamppb.New(*e.CompletedAt)
	}
	if !e.CreatedAt.IsZero() {
		p.CreatedAt = timestamppb.New(e.CreatedAt)
	}
	if !e.UpdatedAt.IsZero() {
		p.UpdatedAt = timestamppb.New(e.UpdatedAt)
	}
	return p
}

func variantRecordToProto(v *ABVariantRecord) *productionv1.ABVariant {
	if v == nil {
		return nil
	}
	return &productionv1.ABVariant{
		VariantId:      v.VariantID,
		AssetId:        v.AssetID,
		PublishItemId:  v.PublishItemID,
		VariantType:    v.VariantType,
		VariantLabel:   v.VariantLabel,
		Impressions:    v.Impressions,
		Views:          v.Views,
		Clicks:         v.Clicks,
		Ctr:            v.CTR,
		Conversions:    v.Conversions,
		EngagementRate: v.EngagementRate,
	}
}

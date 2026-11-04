package production

import (
	"context"
	"errors"

	"connectrpc.com/connect"

	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1/productionv1connect"
)

// PerformanceCoachServiceServer implements productionv1connect.PerformanceCoachServiceHandler.
type PerformanceCoachServiceServer struct {
	svc *Service
}

var _ productionv1connect.PerformanceCoachServiceHandler = (*PerformanceCoachServiceServer)(nil)

// GetInsights returns proactive coaching insights and performance trends.
func (s *PerformanceCoachServiceServer) GetInsights(ctx context.Context, req *connect.Request[productionv1.PerformanceCoachServiceGetInsightsRequest]) (*connect.Response[productionv1.PerformanceCoachServiceGetInsightsResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	insights, isObs, notice, err := s.svc.CoachMgr.GetInsights(ctx, caller, req.Msg.GetTargetChannel(), int(req.Msg.GetLimit()))
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoInsights []*productionv1.PerformanceInsight
	for _, ins := range insights {
		protoInsights = append(protoInsights, &productionv1.PerformanceInsight{
			InsightId:       ins.InsightID,
			Title:           ins.Title,
			Description:     ins.Description,
			Category:        ins.Category,
			ImpactLevel:     ins.ImpactLevel,
			EffortLevel:     ins.EffortLevel,
			SuggestedAction: ins.SuggestedAction,
			TargetAssetId:   ins.TargetAssetID,
			IsObservational: ins.IsObservational,
		})
	}

	return connect.NewResponse(&productionv1.PerformanceCoachServiceGetInsightsResponse{
		Insights:            protoInsights,
		IsObservational:     isObs,
		ObservationalNotice: notice,
	}), nil
}

// GetVideoScorecard returns post-publish scorecard analysis for a specific video asset.
func (s *PerformanceCoachServiceServer) GetVideoScorecard(ctx context.Context, req *connect.Request[productionv1.PerformanceCoachServiceGetVideoScorecardRequest]) (*connect.Response[productionv1.PerformanceCoachServiceGetVideoScorecardResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	scorecard, err := s.svc.CoachMgr.GetVideoScorecard(ctx, caller, req.Msg.GetAssetId())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		if errors.Is(err, ErrAssetNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.PerformanceCoachServiceGetVideoScorecardResponse{
		Scorecard: &productionv1.VideoScorecard{
			AssetId:             scorecard.AssetID,
			Title:               scorecard.Title,
			PackagingScore:      scorecard.PackagingScore,
			HookScore:           scorecard.HookScore,
			RetentionRate_3S:    scorecard.RetentionRate3s,
			CompletionRate:      scorecard.CompletionRate,
			EngagementRate:      scorecard.EngagementRate,
			Views:               scorecard.Views,
			Likes:               scorecard.Likes,
			Comments:            scorecard.Comments,
			Shares:              scorecard.Shares,
			Grade:               scorecard.Grade,
			Strengths:           scorecard.Strengths,
			DropOffPoints:       scorecard.DropOffPoints,
			ImprovementTips:     scorecard.ImprovementTips,
			IsObservational:     scorecard.IsObservational,
			ObservationalNotice: scorecard.ObservationalNotice,
		},
	}), nil
}

// GetImprovementPlan returns weekly report card and proactive AI improvement suggestions.
func (s *PerformanceCoachServiceServer) GetImprovementPlan(ctx context.Context, req *connect.Request[productionv1.PerformanceCoachServiceGetImprovementPlanRequest]) (*connect.Response[productionv1.PerformanceCoachServiceGetImprovementPlanResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	plan, err := s.svc.CoachMgr.GetImprovementPlan(ctx, caller, req.Msg.GetTimeframe())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var actionItems []*productionv1.ImprovementItem
	for _, it := range plan.ActionItems {
		actionItems = append(actionItems, &productionv1.ImprovementItem{
			ItemId:               it.ItemID,
			Title:                it.Title,
			Description:          it.Description,
			FormatRecommendation: it.FormatRecommendation,
			SoundSuggestion:      it.SoundSuggestion,
			Impact:               it.Impact,
			Effort:               it.Effort,
			ActionCta:            it.ActionCTA,
		})
	}

	return connect.NewResponse(&productionv1.PerformanceCoachServiceGetImprovementPlanResponse{
		Plan: &productionv1.ImprovementPlan{
			PlanId:              plan.PlanID,
			WorkspaceId:         plan.WorkspaceID,
			Period:              plan.Period,
			CurrentScore:        plan.CurrentScore,
			PreviousScore:       plan.PreviousScore,
			ScoreChange:         plan.ScoreChange,
			BestPostTitle:       plan.BestPostTitle,
			BestPostEr:          plan.BestPostER,
			WorstPostTitle:      plan.WorstPostTitle,
			WorstPostEr:         plan.WorstPostER,
			ActionItems:         actionItems,
			IsObservational:     plan.IsObservational,
			ObservationalNotice: plan.ObservationalNotice,
		},
	}), nil
}

// ListBenchmarks returns industry baselines.
func (s *PerformanceCoachServiceServer) ListBenchmarks(ctx context.Context, req *connect.Request[productionv1.PerformanceCoachServiceListBenchmarksRequest]) (*connect.Response[productionv1.PerformanceCoachServiceListBenchmarksResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	benchmarks, isObs, err := s.svc.CoachMgr.ListBenchmarks(ctx, caller, req.Msg.GetPlatform(), req.Msg.GetNiche())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoList []*productionv1.IndustryBenchmark
	for _, b := range benchmarks {
		protoList = append(protoList, &productionv1.IndustryBenchmark{
			BenchmarkId:       b.BenchmarkID,
			Platform:          b.Platform,
			Niche:             b.Niche,
			AvgEngagementRate: b.AvgEngagementRate,
			Avg_3SRetention:   b.Avg3sRetention,
			AvgCompletionRate: b.AvgCompletionRate,
			AvgCtr:            b.AvgCTR,
			SampleSize:        int32(b.SampleSize),
			IsObservational:   b.IsObservational,
		})
	}

	return connect.NewResponse(&productionv1.PerformanceCoachServiceListBenchmarksResponse{
		Benchmarks:      protoList,
		IsObservational: isObs,
	}), nil
}

// CompareToIndustry compares workspace performance metrics against industry benchmarks.
func (s *PerformanceCoachServiceServer) CompareToIndustry(ctx context.Context, req *connect.Request[productionv1.PerformanceCoachServiceCompareToIndustryRequest]) (*connect.Response[productionv1.PerformanceCoachServiceCompareToIndustryResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	comp, err := s.svc.CoachMgr.CompareToIndustry(ctx, caller, req.Msg.GetPlatform(), req.Msg.GetNiche())
	if err != nil {
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.PerformanceCoachServiceCompareToIndustryResponse{
		Comparison: &productionv1.IndustryComparison{
			Platform:                  comp.Platform,
			Niche:                     comp.Niche,
			WorkspaceEngagementRate:   comp.WorkspaceEngagementRate,
			IndustryAvgEngagementRate: comp.IndustryAvgEngagementRate,
			ErDeltaPercent:            comp.ERDeltaPercent,
			Workspace_3SRetention:     comp.Workspace3sRetention,
			IndustryAvg_3SRetention:   comp.IndustryAvg3sRetention,
			RetentionDeltaPercent:     comp.RetentionDeltaPercent,
			PercentileRank:            comp.PercentileRank,
			Summary:                   comp.Summary,
			IsObservational:           comp.IsObservational,
			ObservationalNotice:       comp.ObservationalNotice,
		},
	}), nil
}

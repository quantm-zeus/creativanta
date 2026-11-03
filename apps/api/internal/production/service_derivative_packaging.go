package production

import (
	"context"
	"errors"
	"fmt"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1/productionv1connect"
)

// DerivativeServiceServer implements productionv1connect.DerivativeServiceHandler.
type DerivativeServiceServer struct {
	svc *Service
}

var _ productionv1connect.DerivativeServiceHandler = (*DerivativeServiceServer)(nil)

// List returns derivative records matching criteria.
func (s *DerivativeServiceServer) List(ctx context.Context, req *connect.Request[productionv1.DerivativeServiceListRequest]) (*connect.Response[productionv1.DerivativeServiceListResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Member") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	limit := 50
	offset := 0
	if req.Msg.GetPagination() != nil && req.Msg.GetPagination().GetPageSize() > 0 {
		limit = int(req.Msg.GetPagination().GetPageSize())
	}

	records, total, err := s.svc.DerivativeMgr.List(
		ctx,
		caller,
		req.Msg.GetSourceAssetId(),
		req.Msg.GetDerivativeType(),
		req.Msg.GetTargetChannel(),
		req.Msg.GetStatus(),
		limit,
		offset,
	)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	items := make([]*productionv1.DerivativeItem, 0, len(records))
	for _, r := range records {
		items = append(items, derivativeRecordToProto(r))
	}

	return connect.NewResponse(&productionv1.DerivativeServiceListResponse{
		Derivatives: items,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(items)) < total,
		},
	}), nil
}

// Create creates a new derivative asset record.
func (s *DerivativeServiceServer) Create(ctx context.Context, req *connect.Request[productionv1.DerivativeServiceCreateRequest]) (*connect.Response[productionv1.DerivativeServiceCreateResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	created, err := s.svc.DerivativeMgr.Create(
		ctx,
		caller,
		req.Msg.GetParentAssetId(),
		req.Msg.GetDerivativeType(),
		req.Msg.GetTargetChannel(),
		req.Msg.GetAspectRatio(),
		req.Msg.GetTitle(),
		req.Msg.GetCtaVariant(),
		req.Msg.GetSubtitleLanguage(),
		req.Msg.GetTags(),
	)
	if err != nil {
		if errors.Is(err, ErrMissingLineage) {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.DerivativeServiceCreateResponse{
		Derivative:  derivativeRecordToProto(created),
		OperationId: "op-create-" + created.AssetID,
	}), nil
}

// BatchTag executes bulk tagging across up to 150 items with partial error reporting.
func (s *DerivativeServiceServer) BatchTag(ctx context.Context, req *connect.Request[productionv1.DerivativeServiceBatchTagRequest]) (*connect.Response[productionv1.DerivativeServiceBatchTagResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	res, err := s.svc.DerivativeMgr.BatchTag(ctx, caller, req.Msg.GetAssetIds(), req.Msg.GetAddTags(), req.Msg.GetRemoveTags())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	failedProto := make([]*productionv1.BatchItemError, 0, len(res.Failures))
	for _, f := range res.Failures {
		failedProto = append(failedProto, &productionv1.BatchItemError{
			AssetId:      f.AssetID,
			ErrorCode:    f.ErrorCode,
			ErrorMessage: f.ErrorMessage,
		})
	}

	return connect.NewResponse(&productionv1.DerivativeServiceBatchTagResponse{
		TotalItems:        int32(res.TotalItems),
		SucceededCount:    int32(res.SucceededCount),
		FailedCount:       int32(res.FailedCount),
		SucceededAssetIds: res.SucceededAssetIDs,
		Failures:          failedProto,
		Summary:           res.Summary,
	}), nil
}

// GetLineage retrieves the lineage tree for an asset.
func (s *DerivativeServiceServer) GetLineage(ctx context.Context, req *connect.Request[productionv1.DerivativeServiceGetLineageRequest]) (*connect.Response[productionv1.DerivativeServiceGetLineageResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Member") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	rootNode, chain, hasLineage, err := s.svc.DerivativeMgr.GetLineage(ctx, caller, req.Msg.GetAssetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var rootProto *productionv1.DerivativeLineageNode
	if rootNode != nil {
		rootProto = lineageNodeToProto(rootNode)
	}

	var targetProto *productionv1.DerivativeLineageNode
	var chainProto []*productionv1.DerivativeLineageNode
	for _, c := range chain {
		nodeProto := lineageNodeToProto(c)
		chainProto = append(chainProto, nodeProto)
		if c.AssetID == req.Msg.GetAssetId() {
			targetProto = nodeProto
		}
	}

	summary := fmt.Sprintf("Lineage chain depth: %d", len(chain))
	if !hasLineage {
		summary = "No lineage found"
	}

	return connect.NewResponse(&productionv1.DerivativeServiceGetLineageResponse{
		RootSource:     rootProto,
		TargetNode:     targetProto,
		Chain:          chainProto,
		HasLineage:     hasLineage,
		LineageSummary: summary,
	}), nil
}

// Delete soft-deletes a derivative asset.
func (s *DerivativeServiceServer) Delete(ctx context.Context, req *connect.Request[productionv1.DerivativeServiceDeleteRequest]) (*connect.Response[productionv1.DerivativeServiceDeleteResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Manager") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	err := s.svc.DerivativeMgr.Delete(ctx, caller, req.Msg.GetAssetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.DerivativeServiceDeleteResponse{
		Success: true,
		AssetId: req.Msg.GetAssetId(),
	}), nil
}

// Promote promotes a derivative to canonical master asset status.
func (s *DerivativeServiceServer) Promote(ctx context.Context, req *connect.Request[productionv1.DerivativeServicePromoteRequest]) (*connect.Response[productionv1.DerivativeServicePromoteResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	promoted, err := s.svc.DerivativeMgr.Promote(ctx, caller, req.Msg.GetAssetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.DerivativeServicePromoteResponse{
		Derivative:  derivativeRecordToProto(promoted),
		IsCanonical: true,
	}), nil
}

// GetStats returns aggregated derivative performance stats for a source asset.
func (s *DerivativeServiceServer) GetStats(ctx context.Context, req *connect.Request[productionv1.DerivativeServiceGetStatsRequest]) (*connect.Response[productionv1.DerivativeServiceGetStatsResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Member") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	stats, err := s.svc.DerivativeMgr.GetStats(ctx, caller, req.Msg.GetSourceAssetId())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	topDerivs := make([]*productionv1.DerivativeItem, 0, len(stats.TopDerivatives))
	for _, d := range stats.TopDerivatives {
		topDerivs = append(topDerivs, derivativeRecordToProto(d))
	}

	return connect.NewResponse(&productionv1.DerivativeServiceGetStatsResponse{
		Stats: &productionv1.DerivativeStats{
			SourceAssetId:             stats.SourceAssetID,
			TotalDerivatives:          int32(stats.TotalDerivatives),
			AggregateViews:            stats.AggregateViews,
			AverageEngagementRate:     stats.AverageEngagementRate,
			AverageCtr:                stats.AverageCTR,
			TopPerformingDerivativeId: stats.TopPerformingDerivativeID,
			TopDerivatives:            topDerivs,
		},
	}), nil
}

// PackagingServiceServer implements productionv1connect.PackagingServiceHandler.
type PackagingServiceServer struct {
	svc *Service
}

var _ productionv1connect.PackagingServiceHandler = (*PackagingServiceServer)(nil)

// Score evaluates packaging quality and compliance before publish.
func (s *PackagingServiceServer) Score(ctx context.Context, req *connect.Request[productionv1.PackagingServiceScoreRequest]) (*connect.Response[productionv1.PackagingServiceScoreResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	isCommercial := req.Msg.GetDisclosure() != "" || (req.Msg.GetContext() != nil && req.Msg.GetContext().GetReason() == "commercial")
	report, err := s.svc.PackagingQAMgr.Score(
		ctx,
		caller,
		req.Msg.GetAssetId(),
		req.Msg.GetPublishItemId(),
		req.Msg.GetTargetPlatform(),
		req.Msg.GetTitle(),
		req.Msg.GetCaption(),
		req.Msg.GetHashtags(),
		req.Msg.GetCta(),
		req.Msg.GetDisclosure(),
		req.Msg.GetAudioTrackId(),
		req.Msg.GetPresetId(),
		isCommercial,
	)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.PackagingServiceScoreResponse{
		Report: packagingReportToProto(report),
	}), nil
}

// ScanCompliance executes deep compliance scan across copyright, disclosures, community guidelines.
func (s *PackagingServiceServer) ScanCompliance(ctx context.Context, req *connect.Request[productionv1.PackagingServiceScanComplianceRequest]) (*connect.Response[productionv1.PackagingServiceScanComplianceResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	overall, details, hasHard, err := s.svc.PackagingQAMgr.ScanCompliance(
		ctx,
		caller,
		req.Msg.GetAssetId(),
		req.Msg.GetPublishItemId(),
		req.Msg.GetTargetPlatform(),
	)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoDetails := make([]*productionv1.ComplianceScanDetail, 0, len(details))
	for _, d := range details {
		protoDetails = append(protoDetails, &productionv1.ComplianceScanDetail{
			ScanId:             d.ScanID,
			Category:           d.Category,
			Status:             d.Status,
			FindingDescription: d.FindingDescription,
			MatchedWork:        d.MatchedWork,
			MatchConfidence:    d.MatchConfidence,
			IsHardBlocked:      d.IsHardBlocked,
			CanOverride:        d.CanOverride,
		})
	}

	return connect.NewResponse(&productionv1.PackagingServiceScanComplianceResponse{
		ComplianceScanResult: overall,
		HasHardBlocks:        hasHard,
		Details:              protoDetails,
	}), nil
}

// GetReport retrieves a stored packaging report.
func (s *PackagingServiceServer) GetReport(ctx context.Context, req *connect.Request[productionv1.PackagingServiceGetReportRequest]) (*connect.Response[productionv1.PackagingServiceGetReportResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Member") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	report, err := s.svc.PackagingQAMgr.GetReport(ctx, caller, req.Msg.GetAssetId(), req.Msg.GetPublishItemId())
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(&productionv1.PackagingServiceGetReportResponse{
		Report: packagingReportToProto(report),
	}), nil
}

// BatchScore runs packaging QA scores across multiple assets.
func (s *PackagingServiceServer) BatchScore(ctx context.Context, req *connect.Request[productionv1.PackagingServiceBatchScoreRequest]) (*connect.Response[productionv1.PackagingServiceBatchScoreResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	reports, failures, err := s.svc.PackagingQAMgr.BatchScore(ctx, caller, req.Msg.GetAssetIds(), req.Msg.GetTargetPlatform())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoReports := make([]*productionv1.PackagingReport, 0, len(reports))
	for _, r := range reports {
		protoReports = append(protoReports, packagingReportToProto(r))
	}

	protoFailures := make([]*productionv1.BatchItemError, 0, len(failures))
	for _, f := range failures {
		protoFailures = append(protoFailures, &productionv1.BatchItemError{
			AssetId:      f.AssetID,
			ErrorCode:    f.ErrorCode,
			ErrorMessage: f.ErrorMessage,
		})
	}

	total := len(req.Msg.GetAssetIds())
	scored := len(protoReports)
	failed := len(protoFailures)

	return connect.NewResponse(&productionv1.PackagingServiceBatchScoreResponse{
		TotalItems:  int32(total),
		ScoredCount: int32(scored),
		FailedCount: int32(failed),
		Reports:     protoReports,
		Failures:    protoFailures,
	}), nil
}

// OverrideResult overrides a reviewable packaging check (requires Manager+ role and reason >= 10 chars).
// HARD BLOCKS CANNOT BE OVERRIDDEN BY WORKSPACE USERS UNDER ANY CIRCUMSTANCES.
func (s *PackagingServiceServer) OverrideResult(ctx context.Context, req *connect.Request[productionv1.PackagingServiceOverrideResultRequest]) (*connect.Response[productionv1.PackagingServiceOverrideResultResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)

	updatedReport, err := s.svc.PackagingQAMgr.OverrideResult(
		ctx,
		caller,
		req.Msg.GetAssetId(),
		req.Msg.GetPublishItemId(),
		req.Msg.GetCheckIdOrCategory(),
		req.Msg.GetReason(),
	)
	if err != nil {
		if errors.Is(err, ErrHardBlockCannotBeOverridden) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("hard block cannot be overridden: %w", err))
		}
		if errors.Is(err, ErrOverrideReasonTooShort) {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		if errors.Is(err, ErrPermissionDenied) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.PackagingServiceOverrideResultResponse{
		Success:       true,
		Message:       "Override recorded successfully",
		UpdatedReport: packagingReportToProto(updatedReport),
	}), nil
}

// GetHistory retrieves historical packaging QA reports for an asset.
func (s *PackagingServiceServer) GetHistory(ctx context.Context, req *connect.Request[productionv1.PackagingServiceGetHistoryRequest]) (*connect.Response[productionv1.PackagingServiceGetHistoryResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Member") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	// Fetch current report
	currentReport, err := s.svc.PackagingQAMgr.GetReport(ctx, caller, req.Msg.GetAssetId(), "")
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	protoReports := []*productionv1.PackagingReport{packagingReportToProto(currentReport)}

	return connect.NewResponse(&productionv1.PackagingServiceGetHistoryResponse{
		Reports: protoReports,
	}), nil
}

// RunQA executes automated pre-publish QA check for an asset.
func (s *PackagingServiceServer) RunQA(ctx context.Context, req *connect.Request[productionv1.PackagingServiceRunQARequest]) (*connect.Response[productionv1.PackagingServiceRunQAResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	targetPlatform := "tiktok"
	if len(req.Msg.GetTargetPlatforms()) > 0 {
		targetPlatform = req.Msg.GetTargetPlatforms()[0]
	}

	report, err := s.svc.PackagingQAMgr.Score(
		ctx,
		caller,
		req.Msg.GetAssetId(),
		"pub-auto-"+req.Msg.GetAssetId(),
		targetPlatform,
		"Auto QA Title",
		"Auto QA Caption #fyp",
		[]string{"fyp", "trending"},
		"Click below to learn more",
		"",
		"",
		req.Msg.GetPresetId(),
		false,
	)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&productionv1.PackagingServiceRunQAResponse{
		Report: packagingReportToProto(report),
	}), nil
}

// Helper converters

func derivativeRecordToProto(d *DerivativeRecord) *productionv1.DerivativeItem {
	if d == nil {
		return nil
	}
	return &productionv1.DerivativeItem{
		AssetId:          d.AssetID,
		ParentAssetId:    d.ParentAssetID,
		Title:            d.Title,
		DerivativeType:   d.DerivativeType,
		TargetChannel:    d.TargetChannel,
		AspectRatio:      d.AspectRatio,
		CtaVariant:       d.CTAVariant,
		SubtitleLanguage: d.SubtitleLanguage,
		DurationSeconds:  d.DurationSeconds,
		Resolution:       d.Resolution,
		FileUrl:          d.FileURL,
		QualityState:     d.QualityState,
		GenerationState:  d.GenerationState,
		Tags:             d.Tags,
		Views:            d.Views,
		EngagementRate:   d.EngagementRate,
		Ctr:              d.CTR,
		CreatedAt:        timestamppb.New(d.CreatedAt),
		UpdatedAt:        timestamppb.New(d.UpdatedAt),
	}
}

func packagingReportToProto(r *PackagingReport) *productionv1.PackagingReport {
	if r == nil {
		return nil
	}
	components := make([]*productionv1.PackagingScoreComponent, 0, len(r.Components))
	for _, c := range r.Components {
		components = append(components, &productionv1.PackagingScoreComponent{
			ComponentName: c.ComponentName,
			Score:         c.Score,
			Weight:        c.Weight,
			Status:        c.Status,
			Findings:      c.Findings,
			SuggestedFix:  c.SuggestedFix,
			IsHardBlocked: c.IsHardBlocked,
			CanOverride:   c.CanOverride,
		})
	}
	readiness := make([]*productionv1.ReadinessCheckItem, 0, len(r.ReadinessChecks))
	for _, rc := range r.ReadinessChecks {
		readiness = append(readiness, &productionv1.ReadinessCheckItem{
			CheckId:       rc.CheckID,
			Platform:      rc.Platform,
			CheckType:     rc.CheckType,
			Status:        rc.Status,
			CurrentValue:  rc.CurrentValue,
			RequiredValue: rc.RequiredValue,
			SuggestedFix:  rc.SuggestedFix,
			IsHardBlocked: rc.IsHardBlocked,
			CanOverride:   rc.CanOverride,
		})
	}
	compliance := make([]*productionv1.ComplianceScanDetail, 0, len(r.ComplianceDetails))
	for _, cd := range r.ComplianceDetails {
		compliance = append(compliance, &productionv1.ComplianceScanDetail{
			ScanId:             cd.ScanID,
			Category:           cd.Category,
			Status:             cd.Status,
			FindingDescription: cd.FindingDescription,
			MatchedWork:        cd.MatchedWork,
			MatchConfidence:    cd.MatchConfidence,
			IsHardBlocked:      cd.IsHardBlocked,
			CanOverride:        cd.CanOverride,
		})
	}
	overrides := make([]*productionv1.OverrideAuditRecord, 0, len(r.AppliedOverrides))
	for _, o := range r.AppliedOverrides {
		overrides = append(overrides, &productionv1.OverrideAuditRecord{
			OverrideId:         o.OverrideID,
			CheckIdOrCategory:  o.CheckIDOrCategory,
			OverriddenByUserId: o.OverriddenByUID,
			ActorRole:          o.ActorRole,
			Reason:             o.Reason,
			CreatedAt:          timestamppb.New(o.CreatedAt),
		})
	}
	return &productionv1.PackagingReport{
		ReportId:                r.ReportID,
		AssetId:                 r.AssetID,
		PublishItemId:           r.PublishItemID,
		OverallPackagingScore:   r.OverallPackagingScore,
		ScoreStatus:             r.ScoreStatus,
		Components:              components,
		ReadinessChecks:         readiness,
		ComplianceDetails:       compliance,
		ComplianceOverallResult: r.ComplianceOverallResult,
		HasHardBlocks:           r.HasHardBlocks,
		HardBlockReasons:        r.HardBlockReasons,
		ReadyForPackaging:       r.ReadyForPackaging,
		ReadyToPublish:          r.ReadyToPublish,
		AppliedOverrides:        overrides,
		CreatedAt:               timestamppb.New(r.CreatedAt),
	}
}

func lineageNodeToProto(node *DerivativeLineageNode) *productionv1.DerivativeLineageNode {
	if node == nil {
		return nil
	}
	protoChildren := make([]*productionv1.DerivativeLineageNode, 0, len(node.Children))
	for _, child := range node.Children {
		protoChildren = append(protoChildren, lineageNodeToProto(child))
	}
	return &productionv1.DerivativeLineageNode{
		AssetId:         node.AssetID,
		ParentAssetId:   node.ParentAssetID,
		Title:           node.Title,
		DerivativeType:  node.DerivativeType,
		AssetType:       node.AssetType,
		QualityState:    node.QualityState,
		Depth:           int32(node.Depth),
		Views:           node.Views,
		EngagementRate:  node.EngagementRate,
		Ctr:             node.CTR,
		IsSourceDeleted: node.IsSourceDeleted,
		Children:        protoChildren,
	}
}

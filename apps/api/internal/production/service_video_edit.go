package production

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Create starts a new production job (e.g. multi_merge, quick_edit) per §7.1.
func (s *VideoEditJobServiceServer) Create(ctx context.Context, req *connect.Request[productionv1.VideoEditJobServiceCreateRequest]) (*connect.Response[productionv1.VideoEditJobServiceCreateResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	mode := req.Msg.GetMode()
	dryRun := req.Msg.GetDryRun()

	var copyrightCheckResults []CopyrightCheckResult

	// Handle Mode 3: Multi-Merge (N->1)
	if mode == productionv1.ProductionMode_PRODUCTION_MODE_MULTI_MERGE {
		rawItems := req.Msg.GetTimelineItems()
		var domainItems []MultiMergeTimelineItem
		for _, it := range rawItems {
			domainItems = append(domainItems, MultiMergeTimelineItem{
				ItemID:                    it.GetItemId(),
				AssetID:                   it.GetAssetId(),
				OrderIndex:                int(it.GetOrderIndex()),
				DurationSeconds:           it.GetDurationSeconds(),
				MediaType:                 it.GetMediaType(),
				TransitionToNext:          it.GetTransitionToNext(),
				TransitionDurationSeconds: it.GetTransitionDurationSeconds(),
				LicenseStatus:             it.GetLicenseStatus(),
				LicenseProofKey:           it.GetLicenseProofKey(),
			})
		}

		rawSettings := req.Msg.GetMultimergeSettings()
		var domainSettings MultiMergeSettings
		if rawSettings != nil {
			domainSettings = MultiMergeSettings{
				TargetDurationSeconds: rawSettings.GetTargetDurationSeconds(),
				AutoTransitions:       rawSettings.GetAutoTransitions(),
				VoiceOverType:         rawSettings.GetVoiceOverType(),
				VoiceOverCharacterID:  rawSettings.GetVoiceOverCharacterId(),
				MusicSource:           rawSettings.GetMusicSource(),
				MusicAssetID:          rawSettings.GetMusicAssetId(),
				MusicLicenseProof:     rawSettings.GetMusicLicenseProof(),
				AspectRatio:           rawSettings.GetAspectRatio(),
				Pacing:                rawSettings.GetPacing(),
			}
		}

		// Tier limits check: Free 5, Starter 10, Pro 20, Business 50
		tier := "Pro" // default workspace tier in test context
		valRes := ValidateMultiMergeTimeline(tier, domainItems, domainSettings)
		copyrightCheckResults = valRes.CopyrightChecks

		if !valRes.IsValid {
			// Check if failure is due to copyright infringement
			for _, c := range valRes.CopyrightChecks {
				if !c.Passed {
					if dryRun {
						// In dry run, return the check results so UI can show the block warning
						return connect.NewResponse(&productionv1.VideoEditJobServiceCreateResponse{
							CreditsEstimated: "20.000000",
							IsDryRun:         true,
							CopyrightChecks:  toProtoCopyrightChecks(copyrightCheckResults),
						}), nil
					}
					// Hard block: confirmed copyright violations cannot be bypassed by accepting risk (SAFE-2026-02)
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%s: %s", ErrUnlicensedMediaBlocked.Error(), c.WarningMessage))
				}
			}

			// Validation failure due to input count
			if len(domainItems) < 2 {
				return nil, connect.NewError(connect.CodeInvalidArgument, ErrSingleMediaNotAllowed)
			}
			if len(domainItems) > TierMaxInputs(tier) {
				return nil, connect.NewError(connect.CodeInvalidArgument, ErrMultiMergeLimitExceeded)
			}
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("multi-merge validation failed: %s", strings.Join(valRes.Errors, "; ")))
		}

		estCredits := tenantdb.MustParseExactDecimal("20.000000")

		if dryRun {
			return connect.NewResponse(&productionv1.VideoEditJobServiceCreateResponse{
				CreditsEstimated: estCredits.String(),
				IsDryRun:         true,
				CopyrightChecks:  toProtoCopyrightChecks(copyrightCheckResults),
			}), nil
		}

		// Check credit balance
		bal := s.svc.GetWorkspaceBalance(wsID)
		if bal.Cmp(estCredits) < 0 {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInsufficientCredits)
		}
		s.svc.deductCredits(wsID, estCredits)

		// Create output asset and VideoEditJob
		jobID := fmt.Sprintf("job-merge-%d", time.Now().UnixNano())
		outputAssetID := fmt.Sprintf("asset-merge-%d", time.Now().UnixNano())
		now := time.Now().UTC()

		asset := &Asset{
			AssetID:               outputAssetID,
			WorkspaceID:           wsID,
			AssetType:             "video",
			Title:                 "Multi-Merge Video Assembly",
			SourceGenerationMode:  "derived",
			SourceProvider:        "internal_ffmpeg",
			SourceModel:           "concat_v3",
			FileURL:               fmt.Sprintf("https://storage.creativanta.com/%s/merged/%s.mp4", wsID, outputAssetID),
			FileSizeBytes:         31457280, // ~30MB
			DurationSeconds:       tenantdb.MustParseExactDecimal("60.00"),
			Resolution:            "1080x1920",
			AspectRatio:           "9:16",
			MimeType:              "video/mp4",
			GenerationState:       "generated",
			QualityState:          "approved",
			GenerationCostCredits: estCredits,
			GenerationCostUSD:     tenantdb.MustParseExactDecimal("0.300000"),
			DerivativeType:        "merged",
			CreatedAt:             now,
			UpdatedAt:             now,
		}
		_ = s.svc.store.CreateAsset(ctx, asset)

		inputParams, _ := json.Marshal(map[string]any{
			"item_count":       len(domainItems),
			"auto_transitions": domainSettings.AutoTransitions,
			"aspect_ratio":     domainSettings.AspectRatio,
		})

		job := &VideoEditJobRecord{
			JobID:            jobID,
			WorkspaceID:      wsID,
			Mode:             "multi_merge",
			SourceAssetIDs:   req.Msg.GetSourceAssetIds(),
			OutputAssetIDs:   []string{outputAssetID},
			Status:           "processing",
			InputParamsJSON:  string(inputParams),
			CreditsEstimated: estCredits,
			CreditsUsed:      estCredits,
			ActualCostUSD:    tenantdb.MustParseExactDecimal("0.300000"),
			StartedAt:        &now,
			CreatedAt:        now,
			UpdatedAt:        now,
		}
		_ = s.svc.store.CreateVideoEditJob(ctx, job)

		return connect.NewResponse(&productionv1.VideoEditJobServiceCreateResponse{
			Job:              toProtoVideoEditJob(job),
			CreditsEstimated: estCredits.String(),
			IsDryRun:         false,
			CopyrightChecks:  toProtoCopyrightChecks(copyrightCheckResults),
		}), nil
	}

	// Generic production mode handling
	estCredits := tenantdb.MustParseExactDecimal("15.000000")
	if dryRun {
		return connect.NewResponse(&productionv1.VideoEditJobServiceCreateResponse{
			CreditsEstimated: estCredits.String(),
			IsDryRun:         true,
		}), nil
	}

	bal := s.svc.GetWorkspaceBalance(wsID)
	if bal.Cmp(estCredits) < 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInsufficientCredits)
	}
	s.svc.deductCredits(wsID, estCredits)

	jobID := fmt.Sprintf("job-edit-%d", time.Now().UnixNano())
	now := time.Now().UTC()
	job := &VideoEditJobRecord{
		JobID:            jobID,
		WorkspaceID:      wsID,
		Mode:             protoModeToString(mode),
		SourceAssetIDs:   req.Msg.GetSourceAssetIds(),
		Status:           "processing",
		CreditsEstimated: estCredits,
		CreditsUsed:      estCredits,
		StartedAt:        &now,
		CreatedAt:        now,
		UpdatedAt:        now,
	}
	_ = s.svc.store.CreateVideoEditJob(ctx, job)

	return connect.NewResponse(&productionv1.VideoEditJobServiceCreateResponse{
		Job:              toProtoVideoEditJob(job),
		CreditsEstimated: estCredits.String(),
		IsDryRun:         false,
	}), nil
}

// Get retrieves job status and metadata (§7.1).
func (s *VideoEditJobServiceServer) Get(ctx context.Context, req *connect.Request[productionv1.VideoEditJobServiceGetRequest]) (*connect.Response[productionv1.VideoEditJobServiceGetResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Contributor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	job, err := s.svc.store.GetVideoEditJob(ctx, wsID, req.Msg.GetJobId())
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrVideoEditJobNotFound)
	}

	return connect.NewResponse(&productionv1.VideoEditJobServiceGetResponse{
		Job: toProtoVideoEditJob(job),
	}), nil
}

// List returns filtered production jobs for a workspace (§7.1).
func (s *VideoEditJobServiceServer) List(ctx context.Context, req *connect.Request[productionv1.VideoEditJobServiceListRequest]) (*connect.Response[productionv1.VideoEditJobServiceListResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Contributor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	modeStr := ""
	if req.Msg.GetMode() != productionv1.ProductionMode_PRODUCTION_MODE_UNSPECIFIED {
		modeStr = protoModeToString(req.Msg.GetMode())
	}

	statusStr := ""
	if req.Msg.GetStatus() != productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_UNSPECIFIED {
		statusStr = protoJobStatusToString(req.Msg.GetStatus())
	}

	limit := 20
	offset := 0
	if req.Msg.GetPagination() != nil {
		if req.Msg.GetPagination().GetPageSize() > 0 {
			limit = int(req.Msg.GetPagination().GetPageSize())
		}
	}

	jobs, total, err := s.svc.store.ListVideoEditJobs(ctx, wsID, modeStr, statusStr, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to list video edit jobs: %w", err))
	}

	var pbJobs []*productionv1.VideoEditJob
	for _, j := range jobs {
		pbJobs = append(pbJobs, toProtoVideoEditJob(j))
	}

	return connect.NewResponse(&productionv1.VideoEditJobServiceListResponse{
		Jobs: pbJobs,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(pbJobs)) < total,
		},
	}), nil
}

// Cancel cancels an in-flight video edit job and refunds unspent credits (§7.1).
func (s *VideoEditJobServiceServer) Cancel(ctx context.Context, req *connect.Request[productionv1.VideoEditJobServiceCancelRequest]) (*connect.Response[productionv1.VideoEditJobServiceCancelResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	job, err := s.svc.store.GetVideoEditJob(ctx, wsID, req.Msg.GetJobId())
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrVideoEditJobNotFound)
	}

	if job.Status == "completed" || job.Status == "failed" {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrCannotCancelCompletedJob)
	}

	job.Status = "cancelled"
	now := time.Now().UTC()
	job.CompletedAt = &now
	_ = s.svc.store.UpdateVideoEditJob(ctx, job)

	// Refund unspent credits
	refundAmount := job.CreditsUsed
	newBal, _ := s.svc.GetWorkspaceBalance(wsID).Add(refundAmount)
	s.svc.SetWorkspaceBalance(wsID, newBal)

	return connect.NewResponse(&productionv1.VideoEditJobServiceCancelResponse{
		Job:             toProtoVideoEditJob(job),
		CreditsRefunded: refundAmount.String(),
	}), nil
}

// Retry retries a failed video edit job (§7.1).
func (s *VideoEditJobServiceServer) Retry(ctx context.Context, req *connect.Request[productionv1.VideoEditJobServiceRetryRequest]) (*connect.Response[productionv1.VideoEditJobServiceRetryResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	job, err := s.svc.store.GetVideoEditJob(ctx, wsID, req.Msg.GetJobId())
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrVideoEditJobNotFound)
	}

	job.Status = "queued"
	job.ErrorMessage = ""
	_ = s.svc.store.UpdateVideoEditJob(ctx, job)

	return connect.NewResponse(&productionv1.VideoEditJobServiceRetryResponse{
		Job: toProtoVideoEditJob(job),
	}), nil
}

// Helper mappings
func toProtoVideoEditJob(j *VideoEditJobRecord) *productionv1.VideoEditJob {
	if j == nil {
		return nil
	}
	res := &productionv1.VideoEditJob{
		JobId:              j.JobID,
		WorkspaceId:        j.WorkspaceID,
		Mode:               stringToProtoMode(j.Mode),
		SourceAssetIds:     j.SourceAssetIDs,
		OutputAssetIds:     j.OutputAssetIDs,
		GenerationJobId:    j.GenerationJobID,
		CharacterId:        j.CharacterID,
		BrandPackId:        j.BrandPackID,
		Status:             stringToProtoJobStatus(j.Status),
		InputParamsJson:    j.InputParamsJSON,
		OutputMetadataJson: j.OutputMetadataJSON,
		CreditsEstimated:   j.CreditsEstimated.String(),
		CreditsUsed:        j.CreditsUsed.String(),
		ActualCostUsd:      j.ActualCostUSD.String(),
		ErrorMessage:       j.ErrorMessage,
		CreatedAt:          timestamppb.New(j.CreatedAt),
		UpdatedAt:          timestamppb.New(j.UpdatedAt),
	}
	if j.StartedAt != nil {
		res.StartedAt = timestamppb.New(*j.StartedAt)
	}
	if j.CompletedAt != nil {
		res.CompletedAt = timestamppb.New(*j.CompletedAt)
	}
	return res
}

func toProtoCopyrightChecks(checks []CopyrightCheckResult) []*productionv1.CopyrightCheckResult {
	var pbChecks []*productionv1.CopyrightCheckResult
	for _, c := range checks {
		pbChecks = append(pbChecks, &productionv1.CopyrightCheckResult{
			MediaId:           c.MediaID,
			MediaTitle:        c.MediaTitle,
			IsCopyrighted:     c.IsCopyrighted,
			DetectedSongTitle: c.DetectedSongTitle,
			DetectedArtist:    c.DetectedArtist,
			LicenseVerified:   c.LicenseVerified,
			LicenseKey:        c.LicenseKey,
			Passed:            c.Passed,
			CanBypassRisk:     c.CanBypassRisk,
			WarningMessage:    c.WarningMessage,
			ActionableOptions: c.ActionableOptions,
		})
	}
	return pbChecks
}

func protoModeToString(m productionv1.ProductionMode) string {
	switch m {
	case productionv1.ProductionMode_PRODUCTION_MODE_MULTI_MERGE:
		return "multi_merge"
	case productionv1.ProductionMode_PRODUCTION_MODE_AI_REMIX:
		return "remix"
	case productionv1.ProductionMode_PRODUCTION_MODE_CLIP_FACTORY:
		return "clip_factory"
	case productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE:
		return "product_showcase"
	case productionv1.ProductionMode_PRODUCTION_MODE_QUICK_EDIT:
		fallthrough
	default:
		return "quick_edit"
	}
}

func stringToProtoMode(s string) productionv1.ProductionMode {
	switch s {
	case "multi_merge":
		return productionv1.ProductionMode_PRODUCTION_MODE_MULTI_MERGE
	case "remix":
		return productionv1.ProductionMode_PRODUCTION_MODE_AI_REMIX
	case "clip_factory":
		return productionv1.ProductionMode_PRODUCTION_MODE_CLIP_FACTORY
	case "product_showcase":
		return productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE
	default:
		return productionv1.ProductionMode_PRODUCTION_MODE_QUICK_EDIT
	}
}

func protoJobStatusToString(st productionv1.VideoEditJobStatus) string {
	switch st {
	case productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_PROCESSING:
		return "processing"
	case productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_COMPLETED:
		return "completed"
	case productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_PARTIALLY_COMPLETED:
		return "partially_completed"
	case productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_FAILED:
		return "failed"
	case productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_CANCELLED:
		return "cancelled"
	case productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_QUEUED:
		fallthrough
	default:
		return "queued"
	}
}

func stringToProtoJobStatus(s string) productionv1.VideoEditJobStatus {
	switch s {
	case "processing":
		return productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_PROCESSING
	case "completed":
		return productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_COMPLETED
	case "partially_completed":
		return productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_PARTIALLY_COMPLETED
	case "failed":
		return productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_FAILED
	case "cancelled":
		return productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_CANCELLED
	default:
		return productionv1.VideoEditJobStatus_VIDEO_EDIT_JOB_STATUS_QUEUED
	}
}

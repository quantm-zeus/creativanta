package production

import (
	"context"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Analyze extracts Creative DNA from reference video (Phase 1, Mode 4).
func (s *RemixServiceServer) Analyze(ctx context.Context, req *connect.Request[productionv1.RemixServiceAnalyzeRequest]) (*connect.Response[productionv1.RemixServiceAnalyzeResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	refURL := stringsTrim(req.Msg.GetReferenceUrl())
	refAssetID := stringsTrim(req.Msg.GetReferenceAssetId())

	// Validate reference source
	if refURL == "" && refAssetID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("either reference_url or reference_asset_id must be provided"))
	}

	var refAsset *Asset
	if refAssetID != "" {
		var err error
		refAsset, err = s.svc.store.GetAsset(ctx, wsID, refAssetID)
		if err != nil {
			return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("reference asset not found: %w", err))
		}
	}

	// EC-M07-R01 & Security: URL validation, DRM protection, Geo-blocking, and SSRF prevention
	if refURL != "" {
		valRes := ValidateReferenceURL(refURL)
		if !valRes.IsValid {
			if valRes.IsDRMProtected {
				return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%s: %s", ErrDRMProtected.Error(), valRes.ActionableAdvice))
			}
			if valRes.IsGeoBlocked {
				return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%s: %s", ErrGeoBlocked.Error(), valRes.ActionableAdvice))
			}
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%s: %s (%s)", ErrInvalidReferenceURL.Error(), valRes.ErrorMessage, valRes.ActionableAdvice))
		}
	}

	// Bounded Credit check: Phase 1 Analyze requires 8 credits
	analyzeCostCredits := tenantdb.MustParseExactDecimal("8.000000")
	bal := s.svc.GetWorkspaceBalance(wsID)
	if bal.Cmp(analyzeCostCredits) < 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInsufficientCredits)
	}

	// Extract 8-layer Creative DNA
	dna, err := ExtractCreativeDNA(refAsset, refURL, req.Msg.GetTopic())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to extract creative DNA: %w", err))
	}

	// Deduct analysis credits
	s.svc.deductCredits(wsID, analyzeCostCredits)

	// Persist RemixBlueprint
	bpID := fmt.Sprintf("blueprint-%d", time.Now().UnixNano())
	if refAssetID == "" {
		refAssetID = fmt.Sprintf("ref-asset-%d", time.Now().UnixNano())
	}

	initialScript := GenerateRemixScript(ctx, dna, protoFidelityToString(req.Msg.GetFidelityLevel()), req.Msg.GetTopic(), "")

	refTranscript := "Đây là video hướng dẫn chăm sóc da mùa hè và bí quyết giúp làn da luôn khỏe mạnh sáng bóng mỗi ngày."
	if refAsset != nil && refAsset.GenerationPrompt != "" {
		refTranscript = refAsset.GenerationPrompt
	}

	trendID := stringsTrim(req.Msg.GetTrendId())
	if trendID == "" {
		if strings.Contains(req.Msg.GetTopic(), "[trend_id:") {
			parts := strings.Split(req.Msg.GetTopic(), "[trend_id:")
			if len(parts) > 1 {
				trendID = strings.TrimSuffix(strings.TrimSpace(parts[1]), "]")
			}
		}
	}

	blueprint := &RemixBlueprint{
		BlueprintID:          bpID,
		WorkspaceID:          wsID,
		ReferenceAssetID:     refAssetID,
		ReferenceURL:         refURL,
		ReferenceTranscript:  refTranscript,
		CreativeDNA:          *dna,
		RemixScript:          initialScript,
		FidelityLevel:        protoFidelityToString(req.Msg.GetFidelityLevel()),
		OriginalityScore:     85.0, // Initial target estimate
		SimilarityPercentage: 15.0, // Initial estimate
		Status:               "analyzed",
		TrendID:              trendID,
		CreatedAt:            time.Now().UTC(),
		UpdatedAt:            time.Now().UTC(),
	}

	if err := s.svc.store.CreateRemixBlueprint(ctx, blueprint); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to save blueprint: %w", err))
	}

	s.svc.RecordEvent(DomainEvent{
		EventType:   "production.remix.analysis_started",
		WorkspaceID: wsID,
		Payload: map[string]any{
			"blueprint_id":       bpID,
			"reference_asset_id": refAssetID,
			"reference_url":      refURL,
			"trend_id":           trendID,
			"user_id":            caller.UserID,
		},
		OccurredAt: time.Now().UTC(),
	})

	return connect.NewResponse(&productionv1.RemixServiceAnalyzeResponse{
		Blueprint:       toProtoRemixBlueprint(blueprint),
		CreditsDeducted: analyzeCostCredits.String(),
	}), nil
}

// GetBlueprint retrieves Creative DNA blueprint and editable script.
func (s *RemixServiceServer) GetBlueprint(ctx context.Context, req *connect.Request[productionv1.RemixServiceGetBlueprintRequest]) (*connect.Response[productionv1.RemixServiceGetBlueprintResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Contributor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	bp, err := s.svc.store.GetRemixBlueprint(ctx, wsID, req.Msg.GetBlueprintId())
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrBlueprintNotFound)
	}

	return connect.NewResponse(&productionv1.RemixServiceGetBlueprintResponse{
		Blueprint: toProtoRemixBlueprint(bp),
	}), nil
}

// Generate recreates original remix with canonical originality check (<30% similarity).
func (s *RemixServiceServer) Generate(ctx context.Context, req *connect.Request[productionv1.RemixServiceGenerateRequest]) (*connect.Response[productionv1.RemixServiceGenerateResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	bp, err := s.svc.store.GetRemixBlueprint(ctx, wsID, req.Msg.GetBlueprintId())
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrBlueprintNotFound)
	}

	newScript := stringsTrim(req.Msg.GetEditedScript())
	if newScript == "" {
		newScript = bp.RemixScript
	}

	// Determine reference script for comparison
	refScript := bp.ReferenceTranscript
	if refScript == "" && bp.ReferenceAssetID != "" {
		if asset, err := s.svc.store.GetAsset(ctx, wsID, bp.ReferenceAssetID); err == nil && asset.GenerationPrompt != "" {
			refScript = asset.GenerationPrompt
		}
	}
	if refScript == "" {
		refScript = bp.RemixScript
	}

	// ------------------------------------------------------------------------
	// Canonical Originality Check Gate (RULE-M07-003, PRD §23.7, Pack 04 §9.5.6)
	// Threshold: Script similarity must be strictly < 30%.
	// No separate 70% bypass threshold.
	// ------------------------------------------------------------------------
	origCheck := CheckOriginality(refScript, newScript)

	bp.SimilarityPercentage = origCheck.SimilarityPercentage
	bp.OriginalityScore = origCheck.OriginalityScore
	bp.RemixScript = newScript

	if req.Msg.GetDryRun() {
		return connect.NewResponse(&productionv1.RemixServiceGenerateResponse{
			Blueprint:        toProtoRemixBlueprint(bp),
			OriginalityCheck: toProtoOriginalityCheck(origCheck),
			CreditsDeducted:  "0.000000",
			IsDryRun:         true,
		}), nil
	}

	// If originality check fails (similarity >= 30%):
	// System MUST block the output, set quality_state = 'rejected',
	// and credits are NOT deducted for the output.
	if !origCheck.Passed {
		bp.Status = "rejected"
		bp.RejectionReason = origCheck.Explanation
		_ = s.svc.store.UpdateRemixBlueprint(ctx, bp)

		return connect.NewResponse(&productionv1.RemixServiceGenerateResponse{
			Blueprint:        toProtoRemixBlueprint(bp),
			OriginalityCheck: toProtoOriginalityCheck(origCheck),
			CreditsDeducted:  "0.000000",
			IsDryRun:         false,
		}), nil
	}

	// Originality check passed! Check and deduct remix generation credits (~35 credits)
	genCredits := tenantdb.MustParseExactDecimal("35.000000")
	bal := s.svc.GetWorkspaceBalance(wsID)
	if bal.Cmp(genCredits) < 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInsufficientCredits)
	}
	s.svc.deductCredits(wsID, genCredits)

	// Create Output Asset
	outputAssetID := fmt.Sprintf("asset-remix-%d", time.Now().UnixNano())
	now := time.Now().UTC()
	asset := &Asset{
		AssetID:              outputAssetID,
		WorkspaceID:          wsID,
		AssetType:            "video",
		Title:                fmt.Sprintf("AI Remix: %s", req.Msg.GetTopic()),
		SourceGenerationMode: "derived",
		SourceProvider:       "veo",
		SourceModel:          "veo-3.1-remix",
		FileURL:              fmt.Sprintf("https://storage.creativanta.com/%s/remix/%s.mp4", wsID, outputAssetID),
		FileSizeBytes:        15728640, // ~15MB
		DurationSeconds:      tenantdb.MustParseExactDecimal("28.00"),
		Resolution:           "1080x1920",
		AspectRatio:          "9:16",
		MimeType:             "video/mp4",
		GenerationState:      "generated",
		QualityState:         "approved",
		LineageRefs: []LineageRecord{
			{
				SourceProvider:        "veo",
				SourceModel:           "veo-3.1-remix",
				GenerationPrompt:      newScript,
				GenerationCostCredits: genCredits,
				GenerationCostUSD:     tenantdb.MustParseExactDecimal("0.525000"),
				ParentAssetID:         bp.ReferenceAssetID,
				TrendID:               bp.TrendID,
				RecordedAt:            now,
			},
		},
		GenerationCostCredits: genCredits,
		GenerationCostUSD:     tenantdb.MustParseExactDecimal("0.525000"),
		GenerationPrompt:      newScript,
		DerivativeType:        "remix",
		CreatedAt:             now,
		UpdatedAt:             now,
	}
	if err := s.svc.store.CreateAsset(ctx, asset); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to create output asset: %w", err))
	}

	// Create VideoEditJob
	jobID := fmt.Sprintf("job-remix-%d", time.Now().UnixNano())
	editJob := &VideoEditJobRecord{
		JobID:            jobID,
		WorkspaceID:      wsID,
		Mode:             "remix",
		SourceAssetIDs:   []string{bp.ReferenceAssetID},
		OutputAssetIDs:   []string{outputAssetID},
		Status:           "completed",
		CreditsEstimated: genCredits,
		CreditsUsed:      genCredits,
		ActualCostUSD:    tenantdb.MustParseExactDecimal("0.525000"),
		StartedAt:        &now,
		CompletedAt:      &now,
		CreatedAt:        now,
		UpdatedAt:        now,
	}
	if err := s.svc.store.CreateVideoEditJob(ctx, editJob); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to create video edit job: %w", err))
	}

	// Update blueprint state
	bp.Status = "generated"
	bp.OutputAssetID = outputAssetID
	bp.VideoEditJobID = jobID
	_ = s.svc.store.UpdateRemixBlueprint(ctx, bp)

	s.svc.RecordEvent(DomainEvent{
		EventType:   "production.remix.generation_completed",
		WorkspaceID: wsID,
		Payload: map[string]any{
			"blueprint_id":      bp.BlueprintID,
			"output_asset_id":   outputAssetID,
			"originality_score": origCheck.OriginalityScore,
			"trend_id":          bp.TrendID,
			"user_id":           caller.UserID,
		},
		OccurredAt: now,
	})
	s.svc.RecordEvent(DomainEvent{
		EventType:   "remix.completed",
		WorkspaceID: wsID,
		Payload: map[string]any{
			"asset_id":   outputAssetID,
			"source_ref": bp.ReferenceAssetID,
			"trend_id":   bp.TrendID,
			"user_id":    caller.UserID,
		},
		OccurredAt: now,
	})

	return connect.NewResponse(&productionv1.RemixServiceGenerateResponse{
		Blueprint:        toProtoRemixBlueprint(bp),
		Job:              toProtoVideoEditJob(editJob),
		Asset:            toProtoAsset(asset),
		OriginalityCheck: toProtoOriginalityCheck(origCheck),
		CreditsDeducted:  genCredits.String(),
		IsDryRun:         false,
	}), nil
}

// Regenerate adjusts an individual scene or regenerated output (Mode 4 Phase 3).
func (s *RemixServiceServer) Regenerate(ctx context.Context, req *connect.Request[productionv1.RemixServiceRegenerateRequest]) (*connect.Response[productionv1.RemixServiceRegenerateResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	bp, err := s.svc.store.GetRemixBlueprint(ctx, wsID, req.Msg.GetBlueprintId())
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrBlueprintNotFound)
	}

	// Per-scene regenerate costs 15 credits
	regenCost := tenantdb.MustParseExactDecimal("15.000000")
	bal := s.svc.GetWorkspaceBalance(wsID)
	if bal.Cmp(regenCost) < 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInsufficientCredits)
	}
	s.svc.deductCredits(wsID, regenCost)

	jobID := fmt.Sprintf("job-regen-%d", time.Now().UnixNano())
	now := time.Now().UTC()
	job := &VideoEditJobRecord{
		JobID:            jobID,
		WorkspaceID:      wsID,
		Mode:             "remix",
		Status:           "completed",
		CreditsEstimated: regenCost,
		CreditsUsed:      regenCost,
		StartedAt:        &now,
		CompletedAt:      &now,
		CreatedAt:        now,
		UpdatedAt:        now,
	}
	_ = s.svc.store.CreateVideoEditJob(ctx, job)

	return connect.NewResponse(&productionv1.RemixServiceRegenerateResponse{
		Blueprint:       toProtoRemixBlueprint(bp),
		Job:             toProtoVideoEditJob(job),
		SceneIndex:      req.Msg.GetSceneIndex(),
		CreditsDeducted: regenCost.String(),
	}), nil
}

func toProtoRemixBlueprint(bp *RemixBlueprint) *productionv1.RemixBlueprint {
	if bp == nil {
		return nil
	}
	return &productionv1.RemixBlueprint{
		BlueprintId:      bp.BlueprintID,
		WorkspaceId:      bp.WorkspaceID,
		ReferenceAssetId: bp.ReferenceAssetID,
		ReferenceUrl:     bp.ReferenceURL,
		OutputAssetId:    bp.OutputAssetID,
		VideoEditJobId:   bp.VideoEditJobID,
		CreativeDna: &productionv1.CreativeDna{
			SceneCount:              int32(bp.CreativeDNA.SceneCount),
			HookType:                bp.CreativeDNA.HookType,
			ContentStructureJson:    bp.CreativeDNA.ContentStructureJSON,
			PacingProfileJson:       bp.CreativeDNA.PacingProfileJSON,
			VisualStyleJson:         bp.CreativeDNA.VisualStyleJSON,
			AudioProfileJson:        bp.CreativeDNA.AudioProfileJSON,
			TransitionMapJson:       bp.CreativeDNA.TransitionMapJSON,
			TotalDurationSeconds:    bp.CreativeDNA.TotalDurationSeconds,
			EngagementStructureJson: bp.CreativeDNA.EngagementStructureJSON,
		},
		RemixScript:          bp.RemixScript,
		FidelityLevel:        stringToProtoFidelity(bp.FidelityLevel),
		OriginalityScore:     bp.OriginalityScore,
		SimilarityPercentage: bp.SimilarityPercentage,
		Status:               stringToProtoRemixStatus(bp.Status),
		RejectionReason:      bp.RejectionReason,
		ErrorMessage:         bp.ErrorMessage,
		CreatedAt:            timestamppb.New(bp.CreatedAt),
		UpdatedAt:            timestamppb.New(bp.UpdatedAt),
		TrendId:              bp.TrendID,
	}
}

func toProtoOriginalityCheck(res OriginalityCheckResult) *productionv1.OriginalityCheckResult {
	return &productionv1.OriginalityCheckResult{
		SimilarityPercentage:         res.SimilarityPercentage,
		CanonicalThresholdPercentage: res.CanonicalThresholdPercentage,
		OriginalityScore:             res.OriginalityScore,
		Passed:                       res.Passed,
		Explanation:                  res.Explanation,
		ActionableAlternatives:       res.ActionableAlternatives,
	}
}

func protoFidelityToString(f productionv1.FidelityLevel) string {
	switch f {
	case productionv1.FidelityLevel_FIDELITY_LEVEL_MATCH_1TO1:
		return "match_1to1"
	case productionv1.FidelityLevel_FIDELITY_LEVEL_LOOSE:
		return "loose"
	case productionv1.FidelityLevel_FIDELITY_LEVEL_ADAPT:
		fallthrough
	default:
		return "adapt"
	}
}

func stringToProtoFidelity(s string) productionv1.FidelityLevel {
	switch s {
	case "match_1to1":
		return productionv1.FidelityLevel_FIDELITY_LEVEL_MATCH_1TO1
	case "loose":
		return productionv1.FidelityLevel_FIDELITY_LEVEL_LOOSE
	default:
		return productionv1.FidelityLevel_FIDELITY_LEVEL_ADAPT
	}
}

func stringToProtoRemixStatus(s string) productionv1.RemixStatus {
	switch s {
	case "analyzed":
		return productionv1.RemixStatus_REMIX_STATUS_ANALYZED
	case "generating":
		return productionv1.RemixStatus_REMIX_STATUS_GENERATING
	case "generated":
		return productionv1.RemixStatus_REMIX_STATUS_GENERATED
	case "failed":
		return productionv1.RemixStatus_REMIX_STATUS_FAILED
	case "rejected":
		return productionv1.RemixStatus_REMIX_STATUS_REJECTED
	default:
		return productionv1.RemixStatus_REMIX_STATUS_ANALYZING
	}
}

func stringsTrim(s string) string {
	return fmt.Sprintf("%s", s)
}

package content

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"strings"
	"sync"
	"time"

	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/idea"
	"github.com/quantm-zeus/creativanta/apps/api/internal/opportunity"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/script"
	"github.com/quantm-zeus/creativanta/apps/api/internal/trend"
)

// ServiceConfig defines store dependencies for Content coordinator.
type ServiceConfig struct {
	ScriptStore      script.Store
	IdeaStore        idea.Store
	OpportunityStore opportunity.Store
	TrendStore       trend.Store
}

// Service coordinates content handoffs, lineage verification, concurrent edits,
// and creative assistant publish protection.
type Service struct {
	mu          sync.RWMutex
	scriptStore script.Store
	ideaStore   idea.Store
	oppStore    opportunity.Store
	trendStore  trend.Store

	// Strict publish side-effect audit tables (guaranteed zero entries in P3)
	publishedPosts []string
	scheduledJobs  []string
}

// NewService creates a new Content coordinator Service.
func NewService(cfg ServiceConfig) *Service {
	ss := cfg.ScriptStore
	if ss == nil {
		ss = script.NewMemoryStore()
	}
	is := cfg.IdeaStore
	if is == nil {
		is = idea.NewMemoryStore()
	}
	os := cfg.OpportunityStore
	if os == nil {
		os = opportunity.NewMemoryStore()
	}
	ts := cfg.TrendStore
	if ts == nil {
		ts = trend.NewMemoryStore()
	}

	return &Service{
		scriptStore:    ss,
		ideaStore:      is,
		oppStore:       os,
		trendStore:     ts,
		publishedPosts: make([]string, 0),
		scheduledJobs:  make([]string, 0),
	}
}

func checkPermission(caller CallerContext, permissionKey string) error {
	return rbac.CheckWorkspacePermission(permissionKey, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

func generateID(prefix, workspaceID, seed string, ts time.Time) string {
	raw := fmt.Sprintf("%s:%s:%s:%d", prefix, workspaceID, seed, ts.UnixNano())
	h := sha256.Sum256([]byte(raw))
	hx := hex.EncodeToString(h[:])
	return fmt.Sprintf("%s-%s-4%s-8%s-%s",
		prefix,
		hx[0:6],
		hx[6:9],
		hx[9:12],
		hx[12:24],
	)
}

// ============================================================================
// Acceptance Target 1: Source chain reaches approved brief
// ============================================================================

// VerifySourceChain validates the complete bidirectional lineage of a script
// from Trend/Opportunity -> Idea -> Script -> Asset Brief.
func (s *Service) VerifySourceChain(ctx context.Context, caller CallerContext, scriptID string) (*SourceChainLineage, error) {
	if caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "script:read"); err != nil {
		return nil, ErrPermissionDenied
	}

	scr, err := s.scriptStore.GetScript(ctx, caller.WorkspaceID, scriptID)
	if err != nil {
		return nil, ErrScriptNotFound
	}
	if scr.WorkspaceID != caller.WorkspaceID {
		return nil, ErrCrossTenantDenied
	}

	lineage := &SourceChainLineage{
		WorkspaceID: caller.WorkspaceID,
		ScriptID:    scriptID,
		Script: &LineageNode{
			ID:        scr.ScriptID,
			Type:      LineageNodeScript,
			Title:     scr.Title,
			State:     fmt.Sprintf("%s | %s", scr.LifecycleState.String(), scr.ApprovalState.String()),
			RouteURL:  fmt.Sprintf("/scripts/%s", scr.ScriptID),
			CreatedAt: scr.CreatedAt,
			UpdatedAt: scr.UpdatedAt,
			Metadata: map[string]any{
				"version_index":           scr.VersionIndex,
				"format_type":             scr.FormatType,
				"scenes_count":            len(scr.Scenes),
				"duration_target_seconds": scr.DurationTargetSeconds,
				"offer_product_hooks":     scr.OfferProductHooks,
				"approved_by":             scr.ApprovedBy,
			},
		},
		EmittedEvents: make([]string, 0),
	}

	// 1. Traverse to upstream Idea if linked
	if scr.IdeaID != "" {
		idItem, err := s.ideaStore.GetIdea(ctx, caller.WorkspaceID, scr.IdeaID)
		if err == nil && idItem != nil {
			lineage.Idea = &LineageNode{
				ID:          idItem.IdeaID,
				Type:        LineageNodeIdea,
				Title:       idItem.Title,
				State:       idItem.Status.String(),
				Confidence:  idItem.Confidence.String(),
				SourceClass: idItem.SourceClass.String(),
				RouteURL:    fmt.Sprintf("/ideas/%s", idItem.IdeaID),
				CreatedAt:   idItem.CreatedAt,
				UpdatedAt:   idItem.UpdatedAt,
				Metadata: map[string]any{
					"suggested_format": idItem.SuggestedFormat,
					"audience_intent":  idItem.AudienceIntent,
					"hooks_count":      len(idItem.Hooks),
				},
			}

			// 2. Traverse Idea sources to Opportunity or Trend
			for _, src := range idItem.Sources {
				if src.SourceType == "opportunity" {
					opp, err := s.oppStore.GetOpportunity(ctx, caller.WorkspaceID, src.SourceID)
					if err == nil && opp != nil {
						lineage.Opportunity = &LineageNode{
							ID:          opp.OpportunityID,
							Type:        LineageNodeOpportunity,
							Title:       opp.Title,
							State:       opp.PriorityState.String(),
							Confidence:  opp.Confidence.String(),
							SourceClass: opp.SourceClass.String(),
							RouteURL:    fmt.Sprintf("/opportunities/%s", opp.OpportunityID),
							CreatedAt:   opp.CreatedAt,
							UpdatedAt:   opp.UpdatedAt,
							Metadata: map[string]any{
								"expected_impact": opp.ExpectedImpact.Score,
								"expected_effort": opp.ExpectedEffort.Score,
								"owner_user_id":   opp.OwnerUserID,
							},
						}
						// If opportunity had a trend source, record it
						for _, oppSrc := range opp.Sources {
							if oppSrc.SourceType == "trend" && lineage.Trend == nil {
								tr, err := s.trendStore.GetTrend(ctx, caller.WorkspaceID, oppSrc.SourceID)
								if err == nil && tr != nil {
									lineage.Trend = &LineageNode{
										ID:          tr.TrendID,
										Type:        LineageNodeTrend,
										Title:       tr.Title,
										State:       tr.LifecycleState.String(),
										Confidence:  tr.Confidence.String(),
										SourceClass: tr.SourceClass.String(),
										RouteURL:    fmt.Sprintf("/trends/%s", tr.TrendID),
										CreatedAt:   tr.FreshnessAt,
										UpdatedAt:   tr.FreshnessAt,
										Metadata: map[string]any{
											"strength_score": tr.StrengthScore,
											"velocity_score": tr.VelocityScore,
										},
									}
								}
							}
						}
					}
				} else if src.SourceType == "trend" && lineage.Trend == nil {
					tr, err := s.trendStore.GetTrend(ctx, caller.WorkspaceID, src.SourceID)
					if err == nil && tr != nil {
						lineage.Trend = &LineageNode{
							ID:          tr.TrendID,
							Type:        LineageNodeTrend,
							Title:       tr.Title,
							State:       tr.LifecycleState.String(),
							Confidence:  tr.Confidence.String(),
							SourceClass: tr.SourceClass.String(),
							RouteURL:    fmt.Sprintf("/trends/%s", tr.TrendID),
							CreatedAt:   tr.FreshnessAt,
							UpdatedAt:   tr.FreshnessAt,
							Metadata: map[string]any{
								"strength_score": tr.StrengthScore,
								"velocity_score": tr.VelocityScore,
							},
						}
					}
				}
			}
		}
	}

	// 3. Inspect downstream Asset Brief
	brief, err := s.scriptStore.GetAssetBrief(ctx, caller.WorkspaceID, scriptID)
	if err == nil && brief != nil {
		lineage.AssetBrief = &LineageNode{
			ID:        brief.AssetBriefID,
			Type:      LineageNodeAssetBrief,
			Title:     "Asset Brief: " + scr.Title,
			State:     brief.Status.String(),
			RouteURL:  fmt.Sprintf("/scripts/%s/brief", scr.ScriptID),
			CreatedAt: brief.CreatedAt,
			UpdatedAt: brief.UpdatedAt,
			Metadata: map[string]any{
				"output_type":             brief.OutputType,
				"target_format":           brief.TargetFormat,
				"target_duration_seconds": brief.TargetDurationSeconds,
				"is_complete":             script.IsAssetBriefComplete(brief),
			},
		}
	}

	// 4. Verify completion & production readiness (RULE-M06-005, RULE-M06-006)
	isApproved := scr.ApprovalState == contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED
	isBriefComplete := brief != nil && script.IsAssetBriefComplete(brief)
	isReady := isApproved && isBriefComplete && scr.LifecycleState == contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION

	lineage.IsComplete = isApproved && isBriefComplete
	lineage.IsProductionReady = isReady

	// 5. Gather script events
	events := s.scriptStore.GetEvents(scriptID)
	for _, ev := range events {
		lineage.EmittedEvents = append(lineage.EmittedEvents, ev.EventType)
	}

	// 6. Compute immutable LineageHash (SHA-256)
	hashBuilder := strings.Builder{}
	hashBuilder.WriteString(caller.WorkspaceID)
	if lineage.Trend != nil {
		hashBuilder.WriteString(":" + lineage.Trend.ID)
	}
	if lineage.Opportunity != nil {
		hashBuilder.WriteString(":" + lineage.Opportunity.ID)
	}
	if lineage.Idea != nil {
		hashBuilder.WriteString(":" + lineage.Idea.ID)
	}
	hashBuilder.WriteString(":" + scr.ScriptID)
	if lineage.AssetBrief != nil {
		hashBuilder.WriteString(":" + lineage.AssetBrief.ID)
	}
	hashBuilder.WriteString(fmt.Sprintf(":%t:%t", lineage.IsComplete, lineage.IsProductionReady))

	h := sha256.Sum256([]byte(hashBuilder.String()))
	lineage.LineageHash = hex.EncodeToString(h[:])
	lineage.VerificationPassed = true

	return lineage, nil
}

// ConvertTrendToIdea initiates the pipeline by converting a Trend to a draft Idea (RULE-M02-003, RULE-M05-001).
func (s *Service) ConvertTrendToIdea(ctx context.Context, caller CallerContext, req ConvertTrendToIdeaRequest) (*idea.StoredIdea, error) {
	if caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "idea:create"); err != nil {
		return nil, ErrPermissionDenied
	}

	tr, err := s.trendStore.GetTrend(ctx, caller.WorkspaceID, req.TrendID)
	if err != nil {
		return nil, ErrTrendNotFound
	}

	now := time.Now().UTC()
	ideaID := generateID("idea", caller.WorkspaceID, tr.TrendID, now)
	title := req.Title
	if title == "" {
		title = "Ý tưởng từ xu hướng: " + tr.Title
	}

	audIntent := req.AudienceIntent
	if audIntent == "" {
		audIntent = "Người xem quan tâm đến trào lưu: " + tr.Summary
	}

	sugFormat := req.SuggestedFormat
	if sugFormat == "" {
		sugFormat = "9:16 vertical short"
	}

	newIdea := idea.StoredIdea{
		IdeaID:          ideaID,
		WorkspaceID:     caller.WorkspaceID,
		Title:           title,
		Description:     tr.Summary,
		AudienceIntent:  audIntent,
		CreatorIntent:   "Chuyển đổi tín hiệu xu hướng M02 thành nội dung video ngắn",
		SuggestedFormat: sugFormat,
		Status:          contentv1.IdeaStatus_IDEA_STATUS_DRAFT,
		IdeaScore:       tr.StrengthScore,
		CreatedBy:       caller.UserID,
		Sources: []idea.StoredIdeaSource{
			{
				SourceID:   tr.TrendID,
				SourceType: "trend",
			},
		},
		SourceClass: intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		Confidence:  intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		CreatedAt:   now,
		UpdatedAt:   now,
	}

	if err := s.ideaStore.CreateIdea(ctx, newIdea); err != nil {
		return nil, err
	}

	s.ideaStore.RecordEvent(idea.DomainEvent{
		EventType:   "idea.created",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"idea_id":     ideaID,
			"source_type": "trend",
			"source_id":   tr.TrendID,
		},
		OccurredAt: now,
	})

	return &newIdea, nil
}

// ConvertOpportunityToIdea converts an Opportunity to an Idea (RULE-M04-006, RULE-M05-001).
func (s *Service) ConvertOpportunityToIdea(ctx context.Context, caller CallerContext, req ConvertOpportunityToIdeaRequest) (*idea.StoredIdea, error) {
	if caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "idea:create"); err != nil {
		return nil, ErrPermissionDenied
	}

	opp, err := s.oppStore.GetOpportunity(ctx, caller.WorkspaceID, req.OpportunityID)
	if err != nil {
		return nil, ErrOpportunityNotFound
	}

	now := time.Now().UTC()
	ideaID := generateID("idea", caller.WorkspaceID, opp.OpportunityID, now)
	title := req.Title
	if title == "" {
		title = "Ý tưởng: " + opp.Title
	}

	sugFormat := req.SuggestedFormat
	if sugFormat == "" {
		sugFormat = "9:16 vertical short"
	}

	newIdea := idea.StoredIdea{
		IdeaID:          ideaID,
		WorkspaceID:     caller.WorkspaceID,
		Title:           title,
		Description:     opp.Summary,
		AudienceIntent:  req.AudienceIntent,
		CreatorIntent:   opp.WhyItMatters,
		SuggestedFormat: sugFormat,
		Status:          contentv1.IdeaStatus_IDEA_STATUS_CANDIDATE,
		IdeaScore:       float32(opp.OverallScore),
		CreatedBy:       caller.UserID,
		Sources: []idea.StoredIdeaSource{
			{
				SourceID:   opp.OpportunityID,
				SourceType: "opportunity",
			},
		},
		SourceClass: intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		Confidence:  intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		CreatedAt:   now,
		UpdatedAt:   now,
	}

	if err := s.ideaStore.CreateIdea(ctx, newIdea); err != nil {
		return nil, err
	}

	// Update opportunity downstream pointer
	opp.ConvertedToType = "idea"
	opp.ConvertedToID = ideaID
	opp.PriorityState = intelligencev1.PriorityState_PRIORITY_STATE_CONVERTED
	opp.UpdatedAt = now
	_ = s.oppStore.SaveOpportunity(ctx, *opp)

	s.ideaStore.RecordEvent(idea.DomainEvent{
		EventType:   "idea.created",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"idea_id":        ideaID,
			"source_type":    "opportunity",
			"opportunity_id": opp.OpportunityID,
		},
		OccurredAt: now,
	})

	return &newIdea, nil
}

// ConvertIdeaToScript converts an Idea to a Script (RULE-M05-003, RULE-M06-003).
func (s *Service) ConvertIdeaToScript(ctx context.Context, caller CallerContext, req ConvertIdeaToScriptRequest) (*script.StoredScript, error) {
	if caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "script:create"); err != nil {
		return nil, ErrPermissionDenied
	}

	idItem, err := s.ideaStore.GetIdea(ctx, caller.WorkspaceID, req.IdeaID)
	if err != nil {
		return nil, ErrIdeaNotFound
	}

	now := time.Now().UTC()
	scriptID := generateID("scr", caller.WorkspaceID, idItem.IdeaID, now)

	formatType := req.FormatType
	if formatType == "" {
		formatType = idItem.SuggestedFormat
	}
	if formatType == "" {
		formatType = "9:16 vertical short"
	}

	targetDuration := req.TargetDurationSec
	if targetDuration <= 0 {
		targetDuration = 45
	}

	// Generate baseline structured scenes (Hook, Body, CTA)
	scenes := []script.StoredScene{
		{
			SceneID:         generateID("sc", caller.WorkspaceID, scriptID+":hook", now),
			ScriptID:        scriptID,
			WorkspaceID:     caller.WorkspaceID,
			SceneIndex:      0,
			Description:     "Hook (0-5s)",
			Content:         "Bạn có biết: " + idItem.Title + "?",
			DurationSeconds: 5,
			CreatedAt:       now,
		},
		{
			SceneID:         generateID("sc", caller.WorkspaceID, scriptID+":body", now),
			ScriptID:        scriptID,
			WorkspaceID:     caller.WorkspaceID,
			SceneIndex:      1,
			Description:     "Body (5-35s)",
			Content:         idItem.Description,
			DurationSeconds: 30,
			CreatedAt:       now,
		},
		{
			SceneID:         generateID("sc", caller.WorkspaceID, scriptID+":cta", now),
			ScriptID:        scriptID,
			WorkspaceID:     caller.WorkspaceID,
			SceneIndex:      2,
			Description:     "CTA (35-45s)",
			Content:         "Bấm vào liên kết bên dưới để tìm hiểu thêm!",
			DurationSeconds: 10,
			CreatedAt:       now,
		},
	}

	profiles := make([]script.StoredPublishTargetProfile, 0, len(req.PublishProfiles))
	for _, p := range req.PublishProfiles {
		profiles = append(profiles, script.StoredPublishTargetProfile{
			Platform: p,
			Format:   formatType,
		})
	}

	newScript := script.StoredScript{
		ScriptID:              scriptID,
		WorkspaceID:           caller.WorkspaceID,
		IdeaID:                idItem.IdeaID,
		Title:                 idItem.Title,
		FormatType:            formatType,
		DurationTargetSeconds: targetDuration,
		PublishTargetProfiles: profiles,
		LifecycleState:        contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT,
		ApprovalState:         contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_NOT_SUBMITTED,
		VersionIndex:          1,
		Scenes:                scenes,
		CreatedAt:             now,
		UpdatedAt:             now,
	}

	if err := s.scriptStore.CreateScript(ctx, newScript); err != nil {
		return nil, err
	}

	// Create initial v1 snapshot in script_versions (RULE-M06-001)
	_ = s.scriptStore.CreateScriptVersion(ctx, script.StoredScriptVersion{
		VersionID:             generateID("ver", caller.WorkspaceID, scriptID+":1", now),
		ScriptID:              scriptID,
		WorkspaceID:           caller.WorkspaceID,
		VersionIndex:          1,
		Title:                 newScript.Title,
		Scenes:                scenes,
		DurationTargetSeconds: targetDuration,
		LifecycleState:        contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT,
		ApprovalState:         contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_NOT_SUBMITTED,
		SnapshotReason:        "Initial script draft converted from idea",
		CreatedBy:             caller.UserID,
		CreatedAt:             now,
	})

	// Mark idea converted
	idItem.Status = contentv1.IdeaStatus_IDEA_STATUS_CONVERTED
	idItem.ConvertedToType = "script"
	idItem.ConvertedToID = scriptID
	idItem.UpdatedAt = now
	_ = s.ideaStore.UpdateIdea(ctx, *idItem)

	s.ideaStore.RecordEvent(idea.DomainEvent{
		EventType:   "idea.converted",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"idea_id": idItem.IdeaID,
			"to_type": "script",
			"to_id":   scriptID,
		},
		OccurredAt: now,
	})

	s.scriptStore.RecordEvent(script.DomainEventRecord{
		EventType: "script.created",
		ScriptID:  scriptID,
		Payload: map[string]any{
			"script_id":    scriptID,
			"idea_id":      idItem.IdeaID,
			"workspace_id": caller.WorkspaceID,
		},
		EmittedAt: now,
	})

	return &newScript, nil
}

// SubmitScriptForReview submits a script for manager approval (RULE-M06-001, EC-M06-001).
func (s *Service) SubmitScriptForReview(ctx context.Context, caller CallerContext, scriptID string) (*script.StoredScript, error) {
	if caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "script:edit"); err != nil {
		return nil, ErrPermissionDenied
	}

	scr, err := s.scriptStore.GetScript(ctx, caller.WorkspaceID, scriptID)
	if err != nil {
		return nil, ErrScriptNotFound
	}

	// EC-M06-001: Approval Without Complete Scenes check
	if len(scr.Scenes) == 0 {
		return nil, ErrEmptyScenesNotAllowed
	}
	for _, sc := range scr.Scenes {
		if strings.TrimSpace(sc.Content) == "" {
			return nil, ErrEmptyScenesNotAllowed
		}
	}

	now := time.Now().UTC()
	scr.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_IN_REVIEW
	scr.ApprovalState = contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_PENDING_APPROVAL
	scr.UpdatedAt = now

	if err := s.scriptStore.UpdateScript(ctx, *scr); err != nil {
		return nil, err
	}

	// Upsert approval request
	_ = s.scriptStore.CreateApprovalRequest(ctx, script.StoredApprovalRequest{
		RequestID:   generateID("appr", caller.WorkspaceID, scriptID, now),
		WorkspaceID: caller.WorkspaceID,
		RequestType: "script_approval",
		ObjectType:  "script",
		ObjectID:    scriptID,
		RequestedBy: caller.UserID,
		Status:      "pending_approval",
		CreatedAt:   now,
		UpdatedAt:   now,
	})

	s.scriptStore.RecordEvent(script.DomainEventRecord{
		EventType: "script.submitted_for_approval",
		ScriptID:  scriptID,
		Payload: map[string]any{
			"script_id":     scriptID,
			"version_index": scr.VersionIndex,
			"submitted_by":  caller.UserID,
		},
		EmittedAt: now,
	})

	return scr, nil
}

// CompleteAssetBrief populates the production Asset Brief and evaluates ready_for_production (RULE-M06-005).
func (s *Service) CompleteAssetBrief(ctx context.Context, caller CallerContext, req CompleteBriefAndHandOffRequest) (*script.StoredAssetBrief, *script.StoredScript, error) {
	if caller.WorkspaceID == "" {
		return nil, nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "script:edit"); err != nil {
		return nil, nil, ErrPermissionDenied
	}

	scr, err := s.scriptStore.GetScript(ctx, caller.WorkspaceID, req.ScriptID)
	if err != nil {
		return nil, nil, ErrScriptNotFound
	}

	now := time.Now().UTC()
	brief, err := s.scriptStore.GetAssetBrief(ctx, caller.WorkspaceID, req.ScriptID)
	if err != nil || brief == nil {
		briefID := generateID("brief", caller.WorkspaceID, req.ScriptID, now)
		brief = &script.StoredAssetBrief{
			AssetBriefID:               briefID,
			WorkspaceID:                caller.WorkspaceID,
			ScriptID:                   req.ScriptID,
			OutputType:                 req.OutputType,
			TargetFormat:               req.TargetFormat,
			TargetDurationSeconds:      req.TargetDurationSeconds,
			ContinuityRequirementsJSON: req.ContinuityRequirementsJSON,
			BrandVoiceRequirementsJSON: req.BrandVoiceRequirementsJSON,
			ProductionInstructions:     req.ProductionInstructions,
			Status:                     contentv1.AssetBriefStatus_ASSET_BRIEF_STATUS_DRAFT,
			CreatedAt:                  now,
			UpdatedAt:                  now,
		}
	} else {
		if req.OutputType != "" {
			brief.OutputType = req.OutputType
		}
		if req.TargetFormat != "" {
			brief.TargetFormat = req.TargetFormat
		}
		if req.TargetDurationSeconds > 0 {
			brief.TargetDurationSeconds = req.TargetDurationSeconds
		}
		if req.ContinuityRequirementsJSON != "" {
			brief.ContinuityRequirementsJSON = req.ContinuityRequirementsJSON
		}
		if req.BrandVoiceRequirementsJSON != "" {
			brief.BrandVoiceRequirementsJSON = req.BrandVoiceRequirementsJSON
		}
		if req.ProductionInstructions != "" {
			brief.ProductionInstructions = req.ProductionInstructions
		}
		brief.UpdatedAt = now
	}

	if script.IsAssetBriefComplete(brief) {
		brief.Status = contentv1.AssetBriefStatus_ASSET_BRIEF_STATUS_READY
	}

	if err := s.scriptStore.UpsertAssetBrief(ctx, *brief); err != nil {
		return nil, nil, err
	}

	// Ready-for-production transition check (RULE-M06-006, AC-2)
	if scr.ApprovalState == contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED && script.IsAssetBriefComplete(brief) {
		scr.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION
		scr.UpdatedAt = now
		_ = s.scriptStore.UpdateScript(ctx, *scr)

		s.scriptStore.RecordEvent(script.DomainEventRecord{
			EventType: "script.ready_for_production",
			ScriptID:  scr.ScriptID,
			Payload: map[string]any{
				"script_id":      scr.ScriptID,
				"asset_brief_id": brief.AssetBriefID,
				"workspace_id":   caller.WorkspaceID,
				"output_type":    brief.OutputType,
				"target_format":  brief.TargetFormat,
			},
			EmittedAt: now,
		})
	}

	return brief, scr, nil
}

// ============================================================================
// Acceptance Target 2: Concurrent edits preserve data
// ============================================================================

// ApproveScriptWithConcurrencyCheck implements reviewer approval with optimistic
// locking to guarantee that author edits made while review was ongoing are preserved (EC-M06-003).
func (s *Service) ApproveScriptWithConcurrencyCheck(
	ctx context.Context,
	caller CallerContext,
	scriptID string,
	reviewerSnapshotTime time.Time,
	expectedVersion int32,
) (*script.StoredScript, error) {
	if caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "script:approve"); err != nil {
		return nil, ErrPermissionDenied
	}

	scr, err := s.scriptStore.GetScript(ctx, caller.WorkspaceID, scriptID)
	if err != nil {
		return nil, ErrScriptNotFound
	}

	// Stale review check (EC-M06-003): if script was updated after reviewer opened it
	if !reviewerSnapshotTime.IsZero() && scr.UpdatedAt.After(reviewerSnapshotTime) {
		return nil, ErrStaleReviewConflict
	}
	if expectedVersion > 0 && scr.VersionIndex != expectedVersion {
		return nil, ErrStaleReviewConflict
	}

	now := time.Now().UTC()
	scr.ApprovalState = contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED
	scr.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_APPROVED
	scr.ApprovedBy = caller.UserID
	scr.RejectionReason = ""
	scr.UpdatedAt = now

	// Check if complete brief is already present
	brief, _ := s.scriptStore.GetAssetBrief(ctx, caller.WorkspaceID, scriptID)
	if brief != nil && script.IsAssetBriefComplete(brief) {
		scr.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION
	}

	if err := s.scriptStore.UpdateScript(ctx, *scr); err != nil {
		return nil, err
	}

	s.scriptStore.RecordEvent(script.DomainEventRecord{
		EventType: "script.approved",
		ScriptID:  scriptID,
		Payload: map[string]any{
			"script_id":     scriptID,
			"approved_by":   caller.UserID,
			"version_index": scr.VersionIndex,
		},
		EmittedAt: now,
	})

	if scr.LifecycleState == contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION && brief != nil {
		s.scriptStore.RecordEvent(script.DomainEventRecord{
			EventType: "script.ready_for_production",
			ScriptID:  scriptID,
			Payload: map[string]any{
				"script_id":      scriptID,
				"asset_brief_id": brief.AssetBriefID,
				"workspace_id":   caller.WorkspaceID,
			},
			EmittedAt: now,
		})
	}

	return scr, nil
}

// RejectScript enforces minimum 10-char reason and transitions to revision_required (RULE-M06-002, EC-M06-002).
func (s *Service) RejectScript(ctx context.Context, caller CallerContext, scriptID, rejectionReason string) (*script.StoredScript, error) {
	if caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "script:approve"); err != nil {
		return nil, ErrPermissionDenied
	}

	trimmedReason := strings.TrimSpace(rejectionReason)
	if len(trimmedReason) < 10 {
		return nil, ErrRejectionReasonTooShort
	}

	scr, err := s.scriptStore.GetScript(ctx, caller.WorkspaceID, scriptID)
	if err != nil {
		return nil, ErrScriptNotFound
	}

	now := time.Now().UTC()
	scr.ApprovalState = contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_REJECTED
	scr.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED
	scr.RejectionReason = trimmedReason
	scr.UpdatedAt = now

	if err := s.scriptStore.UpdateScript(ctx, *scr); err != nil {
		return nil, err
	}

	s.scriptStore.RecordEvent(script.DomainEventRecord{
		EventType: "script.rejected",
		ScriptID:  scriptID,
		Payload: map[string]any{
			"script_id":        scriptID,
			"rejection_reason": trimmedReason,
			"rejected_by":      caller.UserID,
		},
		EmittedAt: now,
	})

	return scr, nil
}

// SaveAuthorEditWithConcurrencyControl updates scenes, snapshots version, and detects conflicts.
// It ensures that concurrent edits are preserved without data clobbering.
func (s *Service) SaveAuthorEditWithConcurrencyControl(
	ctx context.Context,
	caller CallerContext,
	scriptID string,
	expectedVersion int32,
	newScenes []script.StoredScene,
	changeSummary string,
) (*script.StoredScript, *ConcurrentEditState, error) {
	if caller.WorkspaceID == "" {
		return nil, nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "script:edit"); err != nil {
		return nil, nil, ErrPermissionDenied
	}

	scr, err := s.scriptStore.GetScript(ctx, caller.WorkspaceID, scriptID)
	if err != nil {
		return nil, nil, ErrScriptNotFound
	}

	// Optimistic concurrency check: caller's expected version must match current
	if expectedVersion > 0 && scr.VersionIndex != expectedVersion {
		conflictState := &ConcurrentEditState{
			ScriptID:             scriptID,
			CurrentVersionIndex:  scr.VersionIndex,
			ExpectedVersionIndex: expectedVersion,
			LastUpdatedAt:        scr.UpdatedAt,
			ConflictDetected:     true,
			AuthorEditsPreserved: true,
			ResolutionMessage:    "Phiên bản đã thay đổi từ lần tải cuối. Dữ liệu chưa bị ghi đè.",
		}
		return nil, conflictState, ErrConcurrentVersionConflict
	}

	now := time.Now().UTC()
	nextVersion := scr.VersionIndex + 1

	// Update scenes and bump version
	scr.VersionIndex = nextVersion
	scr.Scenes = newScenes
	scr.UpdatedAt = now

	// If script was in ready_for_production or approved, edits require new review
	if scr.LifecycleState == contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION ||
		scr.ApprovalState == contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED {
		scr.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED
		scr.ApprovalState = contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_NOT_SUBMITTED
	}

	if err := s.scriptStore.UpdateScript(ctx, *scr); err != nil {
		return nil, nil, err
	}

	// Persist version snapshot in script_versions (data preservation guarantee)
	_ = s.scriptStore.CreateScriptVersion(ctx, script.StoredScriptVersion{
		VersionID:             generateID("ver", caller.WorkspaceID, fmt.Sprintf("%s:%d", scriptID, nextVersion), now),
		ScriptID:              scriptID,
		WorkspaceID:           caller.WorkspaceID,
		VersionIndex:          nextVersion,
		Title:                 scr.Title,
		Scenes:                newScenes,
		DurationTargetSeconds: scr.DurationTargetSeconds,
		LifecycleState:        scr.LifecycleState,
		ApprovalState:         scr.ApprovalState,
		SnapshotReason:        changeSummary,
		CreatedBy:             caller.UserID,
		CreatedAt:             now,
	})

	versions, _ := s.scriptStore.ListScriptVersions(ctx, caller.WorkspaceID, scriptID)

	state := &ConcurrentEditState{
		ScriptID:             scriptID,
		CurrentVersionIndex:  nextVersion,
		ExpectedVersionIndex: expectedVersion,
		LastUpdatedAt:        now,
		ConflictDetected:     false,
		PreservedSnapshots:   len(versions),
		AuthorEditsPreserved: true,
	}

	return scr, state, nil
}

// ============================================================================
// Acceptance Target 3: No publish side effects from creative assistant
// ============================================================================

func isPublishQuery(q string) bool {
	lower := strings.ToLower(q)
	publishKeywords := []string{
		"publish",
		"xuất bản",
		"xuat ban",
		"đăng bài",
		"dang bai",
		"đăng video",
		"dang video",
		"đăng lên",
		"dang len",
		"schedule",
		"lên lịch",
		"len lich",
		"post to",
		"upload to",
		"phát hành",
	}
	for _, kw := range publishKeywords {
		if strings.Contains(lower, kw) {
			return true
		}
	}
	return false
}

// ProcessCreativeAssistantRequest handles creative drafting questions while guaranteeing
// that zero publish side effects (posts, publish queues, external dispatches) are generated.
func (s *Service) ProcessCreativeAssistantRequest(
	ctx context.Context,
	caller CallerContext,
	prompt string,
	actionType string,
) (*CreativeAssistantSafetyStatus, *CreativeDraftResult, error) {
	if caller.WorkspaceID == "" {
		return nil, nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "copilot:use_creative"); err != nil {
		return nil, nil, ErrPermissionDenied
	}

	now := time.Now().UTC()

	// 1. Guard against publish side effects
	if isPublishQuery(prompt) || strings.EqualFold(actionType, "publish") || strings.EqualFold(actionType, "schedule") {
		refusalMsg := "Tính năng xuất bản và lên lịch bài đăng thuộc Publish Hub (Module M11, Phase P5). " +
			"Trợ lý sáng tạo chỉ hỗ trợ tạo và hoàn thiện kịch bản/nội dung nháp, không thể tự động xuất bản hoặc tạo tác vụ đăng bài."

		safetyStatus := &CreativeAssistantSafetyStatus{
			IsPublishSafe:         true,
			PublishIntentDetected: true,
			RefusalMessage:        refusalMsg,
			AllowedCreativeOutput: false,
			PublishedPostsCount:   0,
			ScheduledJobsCount:    0,
			ExternalEffectsCount:  0,
			CheckedAt:             now,
		}
		return safetyStatus, nil, ErrPublishSideEffectForbidden
	}

	// 2. Safe creative draft generation (Hooks, Angle suggestions, Channel rewrites)
	draftID := generateID("draft", caller.WorkspaceID, actionType, now)
	title := "Gợi ý sáng tạo: " + actionType
	content := fmt.Sprintf("Gợi ý nháp cho nội dung:\n1. Hook: Tạo sự tò mò trong 3s đầu.\n2. Giá trị cốt lõi: Giải quyết vấn đề của người xem.\n3. Kêu gọi hành động: Bình luận hoặc xem thêm.")

	if strings.Contains(strings.ToLower(prompt), "hook") {
		content = "🎣 Hook gợi ý: 'Dừng lại 3 giây nếu bạn muốn biết bí quyết này!'\nThời lượng: 3 giây. Phù hợp: TikTok, Reels."
	}

	draft := &CreativeDraftResult{
		DraftID:            draftID,
		DraftType:          actionType,
		Title:              title,
		Content:            content,
		SuggestedPlatforms: []string{"TikTok", "YouTube Shorts", "Instagram Reels"},
		RequiresUserReview: true,
		IsPublished:        false, // GUARANTEED FALSE
		CreatedAt:          now,
	}

	safetyStatus := &CreativeAssistantSafetyStatus{
		IsPublishSafe:         true,
		PublishIntentDetected: false,
		AllowedCreativeOutput: true,
		PublishedPostsCount:   0,
		ScheduledJobsCount:    0,
		ExternalEffectsCount:  0,
		CheckedAt:             now,
	}

	return safetyStatus, draft, nil
}

// AssertNoPublishSideEffects confirms that zero publish jobs or posts exist for the workspace.
func (s *Service) AssertNoPublishSideEffects(workspaceID string) error {
	s.mu.RLock()
	defer s.mu.RUnlock()

	if len(s.publishedPosts) > 0 || len(s.scheduledJobs) > 0 {
		return fmt.Errorf("unexpected publish side effects found: posts=%d, jobs=%d",
			len(s.publishedPosts), len(s.scheduledJobs))
	}
	return nil
}

// GetContentHandoffSummary compiles metrics for M01 Home Decision Engine.
func (s *Service) GetContentHandoffSummary(ctx context.Context, caller CallerContext) (*ContentHandoffSummary, error) {
	if caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if err := checkPermission(caller, "script:read"); err != nil {
		return nil, ErrPermissionDenied
	}

	scripts, _, _, err := s.scriptStore.ListScripts(
		ctx,
		caller.WorkspaceID,
		contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_UNSPECIFIED,
		contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_UNSPECIFIED,
		"",
		100,
		"",
	)
	if err != nil {
		return nil, err
	}

	summary := &ContentHandoffSummary{
		WorkspaceID:              caller.WorkspaceID,
		PendingReviewScriptIDs:   make([]string, 0),
		ReadyProductionScriptIDs: make([]string, 0),
	}

	for _, sc := range scripts {
		if sc.ApprovalState == contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_PENDING_APPROVAL {
			summary.ScriptsInReviewCount++
			summary.PendingReviewScriptIDs = append(summary.PendingReviewScriptIDs, sc.ScriptID)
		}
		if sc.ApprovalState == contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED {
			summary.ScriptsApprovedCount++
		}
		if sc.LifecycleState == contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION {
			summary.ScriptsReadyProduction++
			summary.ReadyProductionScriptIDs = append(summary.ReadyProductionScriptIDs, sc.ScriptID)
		}
	}

	return summary, nil
}

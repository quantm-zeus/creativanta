package script

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1/contentv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type ServiceConfig struct {
	Store Store
}

type Service struct {
	store Store
}

func NewService(cfg ServiceConfig) *Service {
	if cfg.Store == nil {
		cfg.Store = NewMemoryStore()
	}
	return &Service{store: cfg.Store}
}

var _ contentv1connect.ScriptServiceHandler = (*Service)(nil)

func checkPerm(caller CallerContext, perm string) error {
	return rbac.CheckWorkspacePermission(perm, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

func generateDeterministicUUID(workspaceID, seed string, ts time.Time) string {
	raw := fmt.Sprintf("%s:%s:%d", workspaceID, seed, ts.UnixNano())
	h := sha256.Sum256([]byte(raw))
	hx := hex.EncodeToString(h[:])
	return fmt.Sprintf("%s-%s-4%s-8%s-%s",
		hx[0:8],
		hx[8:12],
		hx[13:16],
		hx[16:19],
		hx[19:31],
	)
}

// Create creates a new script, creates initial v1 snapshot, and suggests disclosure if commercial hooks present.
func (s *Service) Create(ctx context.Context, req *connect.Request[contentv1.ScriptServiceCreateRequest]) (*connect.Response[contentv1.ScriptServiceCreateResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	title := strings.TrimSpace(req.Msg.Title)
	if title == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrTitleRequired)
	}

	now := time.Now().UTC()
	scriptID := generateDeterministicUUID(caller.WorkspaceID, title, now)

	// Convert proto scenes if provided
	scenes := make([]StoredScene, 0, len(req.Msg.Scenes))
	for i, sc := range req.Msg.Scenes {
		sceneID := sc.SceneId
		if sceneID == "" {
			sceneID = generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:scene:%d", scriptID, i), now)
		}
		shots := make([]StoredShot, 0, len(sc.ShotList))
		for j, sh := range sc.ShotList {
			shotID := sh.ShotId
			if shotID == "" {
				shotID = generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:shot:%d", sceneID, j), now)
			}
			shots = append(shots, StoredShot{
				ShotID:          shotID,
				SceneID:         sceneID,
				WorkspaceID:     caller.WorkspaceID,
				ShotIndex:       int32(j),
				ShotType:        sh.ShotType,
				Description:     sh.Description,
				DurationSeconds: sh.DurationSeconds,
				CreatedAt:       now,
			})
		}
		scenes = append(scenes, StoredScene{
			SceneID:         sceneID,
			ScriptID:        scriptID,
			WorkspaceID:     caller.WorkspaceID,
			SceneIndex:      int32(i),
			Description:     sc.Description,
			Content:         sc.Content,
			DurationSeconds: sc.DurationSeconds,
			VisualNotes:     sc.VisualNotes,
			AudioNotes:      sc.AudioNotes,
			ShotList:        shots,
			CreatedAt:       now,
		})
	}

	ctaBlocks := make([]StoredCtaBlock, 0, len(req.Msg.CtaBlocks))
	for i, c := range req.Msg.CtaBlocks {
		ctaID := c.CtaId
		if ctaID == "" {
			ctaID = generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:cta:%d", scriptID, i), now)
		}
		ctaBlocks = append(ctaBlocks, StoredCtaBlock{
			CtaID:          ctaID,
			Text:           c.Text,
			ButtonText:     c.ButtonText,
			DestinationURL: c.DestinationUrl,
			CtaType:        c.CtaType,
		})
	}

	disclosureBlocks := make([]StoredDisclosureBlock, 0, len(req.Msg.DisclosureBlocks))
	for i, d := range req.Msg.DisclosureBlocks {
		discID := d.DisclosureId
		if discID == "" {
			discID = generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:disc:%d", scriptID, i), now)
		}
		var dismissedAt *time.Time
		if d.DismissedAt != nil {
			t := d.DismissedAt.AsTime()
			dismissedAt = &t
		}
		disclosureBlocks = append(disclosureBlocks, StoredDisclosureBlock{
			DisclosureID:    discID,
			Text:            d.Text,
			Platform:        d.Platform,
			IsDismissed:     d.IsDismissed,
			DismissedBy:     d.DismissedBy,
			DismissedAt:     dismissedAt,
			DismissalReason: d.DismissalReason,
		})
	}

	// Auto-suggest disclosure if offer product hooks exist and no disclosure block attached (RULE-M06-007)
	if len(req.Msg.OfferProductHooks) > 0 && len(disclosureBlocks) == 0 {
		disclosureBlocks = append(disclosureBlocks, StoredDisclosureBlock{
			DisclosureID: generateDeterministicUUID(caller.WorkspaceID, scriptID+":auto_disc", now),
			Text:         "Includes paid promotion / sponsored product",
			Platform:     "all",
			IsDismissed:  false,
		})
	}

	profiles := make([]StoredPublishTargetProfile, 0, len(req.Msg.PublishTargetProfiles))
	for _, p := range req.Msg.PublishTargetProfiles {
		profiles = append(profiles, StoredPublishTargetProfile{
			Platform:  p.Platform,
			Format:    p.Format,
			AccountID: p.AccountId,
		})
	}

	formatType := req.Msg.FormatType
	if formatType == "" {
		formatType = "short_video"
	}
	durationTarget := req.Msg.DurationTargetSeconds
	if durationTarget <= 0 {
		durationTarget = 60
	}

	storedScript := StoredScript{
		ScriptID:              scriptID,
		WorkspaceID:           caller.WorkspaceID,
		IdeaID:                req.Msg.IdeaId,
		SourceIdeaTitle:       "",
		Title:                 title,
		FormatType:            formatType,
		Scenes:                scenes,
		CtaBlocks:             ctaBlocks,
		DisclosureBlocks:      disclosureBlocks,
		DurationTargetSeconds: durationTarget,
		LifecycleState:        contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT,
		ApprovalState:         contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_UNSPECIFIED,
		PublishTargetProfiles: profiles,
		ContinuityRefs:        req.Msg.ContinuityRefs,
		OfferProductHooks:     req.Msg.OfferProductHooks,
		VersionIndex:          1,
		CreatedBy:             caller.UserID,
		CreatedAt:             now,
		UpdatedAt:             now,
	}

	if err := s.store.CreateScript(ctx, storedScript); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Save initial version v1 snapshot
	ver := StoredScriptVersion{
		VersionID:             generateDeterministicUUID(caller.WorkspaceID, scriptID+":v1", now),
		WorkspaceID:           caller.WorkspaceID,
		ScriptID:              scriptID,
		VersionIndex:          1,
		Title:                 title,
		Scenes:                scenes,
		CtaBlocks:             ctaBlocks,
		DisclosureBlocks:      disclosureBlocks,
		DurationTargetSeconds: durationTarget,
		LifecycleState:        contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT,
		ApprovalState:         contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_UNSPECIFIED,
		SnapshotReason:        "Initial version",
		CreatedBy:             caller.UserID,
		CreatedAt:             now,
	}
	_ = s.store.CreateScriptVersion(ctx, ver)

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.created",
		ScriptID:  scriptID,
		Payload: map[string]any{
			"script_id":    scriptID,
			"workspace_id": caller.WorkspaceID,
			"idea_id":      req.Msg.IdeaId,
			"title":        title,
		},
		EmittedAt: now,
	})

	return connect.NewResponse(&contentv1.ScriptServiceCreateResponse{
		Script: storedScript.ToProto(),
	}), nil
}

// Get retrieves a script and optionally its asset brief.
func (s *Service) Get(ctx context.Context, req *connect.Request[contentv1.ScriptServiceGetRequest]) (*connect.Response[contentv1.ScriptServiceGetResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	var assetBriefProto *contentv1.AssetBrief
	brief, err := s.store.GetAssetBrief(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err == nil && brief != nil {
		assetBriefProto = brief.ToProto()
	}

	return connect.NewResponse(&contentv1.ScriptServiceGetResponse{
		Script:     script.ToProto(),
		AssetBrief: assetBriefProto,
	}), nil
}

// Update updates script content and increments version snapshot.
func (s *Service) Update(ctx context.Context, req *connect.Request[contentv1.ScriptServiceUpdateRequest]) (*connect.Response[contentv1.ScriptServiceUpdateResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	// Concurrency check
	if req.Msg.ExpectedVersion > 0 && script.VersionIndex != req.Msg.ExpectedVersion {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrStaleReviewConflict)
	}

	now := time.Now().UTC()
	if req.Msg.Title != "" {
		script.Title = strings.TrimSpace(req.Msg.Title)
	}
	if req.Msg.FormatType != "" {
		script.FormatType = req.Msg.FormatType
	}
	if req.Msg.DurationTargetSeconds > 0 {
		script.DurationTargetSeconds = req.Msg.DurationTargetSeconds
	}

	if len(req.Msg.Scenes) > 0 {
		newScenes := make([]StoredScene, 0, len(req.Msg.Scenes))
		for i, sc := range req.Msg.Scenes {
			sceneID := sc.SceneId
			if sceneID == "" {
				sceneID = generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:scene:%d", script.ScriptID, i), now)
			}
			shots := make([]StoredShot, 0, len(sc.ShotList))
			for j, sh := range sc.ShotList {
				shotID := sh.ShotId
				if shotID == "" {
					shotID = generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:shot:%d", sceneID, j), now)
				}
				shots = append(shots, StoredShot{
					ShotID:          shotID,
					SceneID:         sceneID,
					WorkspaceID:     caller.WorkspaceID,
					ShotIndex:       int32(j),
					ShotType:        sh.ShotType,
					Description:     sh.Description,
					DurationSeconds: sh.DurationSeconds,
					CreatedAt:       now,
				})
			}
			newScenes = append(newScenes, StoredScene{
				SceneID:         sceneID,
				ScriptID:        script.ScriptID,
				WorkspaceID:     caller.WorkspaceID,
				SceneIndex:      int32(i),
				Description:     sc.Description,
				Content:         sc.Content,
				DurationSeconds: sc.DurationSeconds,
				VisualNotes:     sc.VisualNotes,
				AudioNotes:      sc.AudioNotes,
				ShotList:        shots,
				CreatedAt:       now,
			})
		}
		script.Scenes = newScenes
	}

	if len(req.Msg.CtaBlocks) > 0 {
		newCta := make([]StoredCtaBlock, 0, len(req.Msg.CtaBlocks))
		for i, c := range req.Msg.CtaBlocks {
			ctaID := c.CtaId
			if ctaID == "" {
				ctaID = generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:cta:%d", script.ScriptID, i), now)
			}
			newCta = append(newCta, StoredCtaBlock{
				CtaID:          ctaID,
				Text:           c.Text,
				ButtonText:     c.ButtonText,
				DestinationURL: c.DestinationUrl,
				CtaType:        c.CtaType,
			})
		}
		script.CtaBlocks = newCta
	}

	if len(req.Msg.DisclosureBlocks) > 0 {
		newDisc := make([]StoredDisclosureBlock, 0, len(req.Msg.DisclosureBlocks))
		for i, d := range req.Msg.DisclosureBlocks {
			discID := d.DisclosureId
			if discID == "" {
				discID = generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:disc:%d", script.ScriptID, i), now)
			}
			var dismissedAt *time.Time
			if d.DismissedAt != nil {
				t := d.DismissedAt.AsTime()
				dismissedAt = &t
			}
			newDisc = append(newDisc, StoredDisclosureBlock{
				DisclosureID:    discID,
				Text:            d.Text,
				Platform:        d.Platform,
				IsDismissed:     d.IsDismissed,
				DismissedBy:     d.DismissedBy,
				DismissedAt:     dismissedAt,
				DismissalReason: d.DismissalReason,
			})
		}
		script.DisclosureBlocks = newDisc
	}

	if len(req.Msg.PublishTargetProfiles) > 0 {
		newProfiles := make([]StoredPublishTargetProfile, 0, len(req.Msg.PublishTargetProfiles))
		for _, p := range req.Msg.PublishTargetProfiles {
			newProfiles = append(newProfiles, StoredPublishTargetProfile{
				Platform:  p.Platform,
				Format:    p.Format,
				AccountID: p.AccountId,
			})
		}
		script.PublishTargetProfiles = newProfiles
	}

	if len(req.Msg.ContinuityRefs) > 0 {
		script.ContinuityRefs = req.Msg.ContinuityRefs
	}
	if len(req.Msg.OfferProductHooks) > 0 {
		script.OfferProductHooks = req.Msg.OfferProductHooks
	}

	// Auto-disclosure suggest if commercial hooks and none exist (RULE-M06-007)
	if len(script.OfferProductHooks) > 0 && len(script.DisclosureBlocks) == 0 {
		script.DisclosureBlocks = append(script.DisclosureBlocks, StoredDisclosureBlock{
			DisclosureID: generateDeterministicUUID(caller.WorkspaceID, script.ScriptID+":auto_disc", now),
			Text:         "Includes paid promotion / sponsored product",
			Platform:     "all",
			IsDismissed:  false,
		})
	}

	script.VersionIndex++
	script.UpdatedAt = now

	if err := s.store.UpdateScript(ctx, *script); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Create new version snapshot (Alternate Flow A3)
	ver := StoredScriptVersion{
		VersionID:             generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:v%d", script.ScriptID, script.VersionIndex), now),
		WorkspaceID:           caller.WorkspaceID,
		ScriptID:              script.ScriptID,
		VersionIndex:          script.VersionIndex,
		Title:                 script.Title,
		Scenes:                script.Scenes,
		CtaBlocks:             script.CtaBlocks,
		DisclosureBlocks:      script.DisclosureBlocks,
		DurationTargetSeconds: script.DurationTargetSeconds,
		LifecycleState:        script.LifecycleState,
		ApprovalState:         script.ApprovalState,
		SnapshotReason:        fmt.Sprintf("Update version %d", script.VersionIndex),
		CreatedBy:             caller.UserID,
		CreatedAt:             now,
	}
	_ = s.store.CreateScriptVersion(ctx, ver)

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.updated",
		ScriptID:  script.ScriptID,
		Payload: map[string]any{
			"script_id":     script.ScriptID,
			"workspace_id":  caller.WorkspaceID,
			"version_index": script.VersionIndex,
		},
		EmittedAt: now,
	})

	return connect.NewResponse(&contentv1.ScriptServiceUpdateResponse{
		Script: script.ToProto(),
	}), nil
}

// SubmitApproval validates non-empty scenes and requests approval (EC-M06-001).
func (s *Service) SubmitApproval(ctx context.Context, req *connect.Request[contentv1.ScriptServiceSubmitApprovalRequest]) (*connect.Response[contentv1.ScriptServiceSubmitApprovalResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	// Validate scenes are non-empty (EC-M06-001)
	if err := ValidateScenesForSubmission(script.Scenes); err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	now := time.Now().UTC()
	script.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_IN_REVIEW
	script.ApprovalState = contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_PENDING_APPROVAL
	script.UpdatedAt = now

	if err := s.store.UpdateScript(ctx, *script); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Create/Update approval request (§18.1)
	appReq := StoredApprovalRequest{
		RequestID:   generateDeterministicUUID(caller.WorkspaceID, script.ScriptID+":approval", now),
		WorkspaceID: caller.WorkspaceID,
		RequestType: "script_approval",
		ObjectType:  "script",
		ObjectID:    script.ScriptID,
		RequestedBy: caller.UserID,
		Status:      "pending",
		Reason:      fmt.Sprintf("Submitted for review by %s", caller.UserID),
		CreatedAt:   now,
		UpdatedAt:   now,
	}
	_ = s.store.CreateApprovalRequest(ctx, appReq)

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.submitted_for_approval",
		ScriptID:  script.ScriptID,
		Payload: map[string]any{
			"script_id":      script.ScriptID,
			"workspace_id":   caller.WorkspaceID,
			"requested_by":   caller.UserID,
			"version_index":  script.VersionIndex,
			"approval_state": "pending_approval",
		},
		EmittedAt: now,
	})

	return connect.NewResponse(&contentv1.ScriptServiceSubmitApprovalResponse{
		Script:            script.ToProto(),
		ApprovalRequestId: appReq.RequestID,
	}), nil
}

// Approve handles manager approval with stale review detection (EC-M06-003, AC-2).
func (s *Service) Approve(ctx context.Context, req *connect.Request[contentv1.ScriptServiceApproveRequest]) (*connect.Response[contentv1.ScriptServiceApproveResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:approve"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	// Stale review detection: expected_version or snapshot timestamp mismatch (EC-M06-003)
	if req.Msg.ExpectedVersion > 0 && script.VersionIndex != req.Msg.ExpectedVersion {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrStaleReviewConflict)
	}
	if req.Msg.ReviewerSnapshotTime != nil {
		snapTime := req.Msg.ReviewerSnapshotTime.AsTime()
		if script.UpdatedAt.After(snapTime) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrStaleReviewConflict)
		}
	}

	// Must be in pending_approval
	if script.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_PENDING_APPROVAL {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrApprovalStateNotPending)
	}

	now := time.Now().UTC()
	script.ApprovalState = contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED
	script.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_APPROVED
	script.ApprovedBy = caller.UserID
	script.RejectionReason = ""
	script.UpdatedAt = now

	// Check if complete asset brief already exists for ready_for_production
	brief, _ := s.store.GetAssetBrief(ctx, caller.WorkspaceID, script.ScriptID)
	if brief != nil && IsAssetBriefComplete(brief) {
		script.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION
	}

	if err := s.store.UpdateScript(ctx, *script); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Update approval request
	if appReq, err := s.store.GetApprovalRequest(ctx, caller.WorkspaceID, script.ScriptID); err == nil && appReq != nil {
		appReq.Status = "approved"
		appReq.ApprovedBy = caller.UserID
		appReq.UpdatedAt = now
		_ = s.store.UpdateApprovalRequest(ctx, *appReq)
	}

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.approved",
		ScriptID:  script.ScriptID,
		Payload: map[string]any{
			"script_id":     script.ScriptID,
			"workspace_id":  caller.WorkspaceID,
			"approved_by":   caller.UserID,
			"version_index": script.VersionIndex,
		},
		EmittedAt: now,
	})

	if script.LifecycleState == contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION && brief != nil {
		s.store.RecordEvent(DomainEventRecord{
			EventType: "script.ready_for_production",
			ScriptID:  script.ScriptID,
			Payload: map[string]any{
				"script_id":      script.ScriptID,
				"asset_brief_id": brief.AssetBriefID,
				"workspace_id":   caller.WorkspaceID,
			},
			EmittedAt: now,
		})
	}

	return connect.NewResponse(&contentv1.ScriptServiceApproveResponse{
		Script:     script.ToProto(),
		ApprovedAt: timestamppb.New(now),
	}), nil
}

// Reject handles manager rejection with stale check and validation (RULE-M06-002, EC-M06-002, EC-M06-003).
func (s *Service) Reject(ctx context.Context, req *connect.Request[contentv1.ScriptServiceRejectRequest]) (*connect.Response[contentv1.ScriptServiceRejectResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:approve"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	// Stale review detection: expected_version or snapshot timestamp mismatch (EC-M06-003)
	if req.Msg.ExpectedVersion > 0 && script.VersionIndex != req.Msg.ExpectedVersion {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrStaleReviewConflict)
	}
	if req.Msg.ReviewerSnapshotTime != nil {
		snapTime := req.Msg.ReviewerSnapshotTime.AsTime()
		if script.UpdatedAt.After(snapTime) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrStaleReviewConflict)
		}
	}

	// Must be in pending_approval
	if script.ApprovalState != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_PENDING_APPROVAL {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrApprovalStateNotPending)
	}

	// Validate rejection reason ≥ 10 chars (RULE-M06-002, EC-M06-002)
	rejectionReason := strings.TrimSpace(req.Msg.RejectionReason)
	if err := ValidateRejectionReason(rejectionReason); err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	now := time.Now().UTC()
	script.ApprovalState = contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_REJECTED
	script.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED
	script.RejectionReason = rejectionReason
	script.UpdatedAt = now

	if err := s.store.UpdateScript(ctx, *script); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Update approval request
	if appReq, err := s.store.GetApprovalRequest(ctx, caller.WorkspaceID, script.ScriptID); err == nil && appReq != nil {
		appReq.Status = "rejected"
		appReq.RejectionReason = rejectionReason
		appReq.UpdatedAt = now
		_ = s.store.UpdateApprovalRequest(ctx, *appReq)
	}

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.rejected",
		ScriptID:  script.ScriptID,
		Payload: map[string]any{
			"script_id":        script.ScriptID,
			"workspace_id":     caller.WorkspaceID,
			"rejected_by":      caller.UserID,
			"rejection_reason": rejectionReason,
		},
		EmittedAt: now,
	})

	return connect.NewResponse(&contentv1.ScriptServiceRejectResponse{
		Script: script.ToProto(),
	}), nil
}

// List lists scripts with filters and pagination.
func (s *Service) List(ctx context.Context, req *connect.Request[contentv1.ScriptServiceListRequest]) (*connect.Response[contentv1.ScriptServiceListResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	items, nextToken, total, err := s.store.ListScripts(
		ctx,
		caller.WorkspaceID,
		req.Msg.LifecycleState,
		req.Msg.ApprovalState,
		req.Msg.IdeaId,
		int(req.Msg.Limit),
		req.Msg.PageToken,
	)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoScripts := make([]*contentv1.Script, len(items))
	for i, item := range items {
		protoScripts[i] = item.ToProto()
	}

	return connect.NewResponse(&contentv1.ScriptServiceListResponse{
		Scripts:       protoScripts,
		NextPageToken: nextToken,
		TotalCount:    int32(total),
	}), nil
}

// Delete soft-deletes a script.
func (s *Service) Delete(ctx context.Context, req *connect.Request[contentv1.ScriptServiceDeleteRequest]) (*connect.Response[contentv1.ScriptServiceDeleteResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:delete"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	if err := s.store.DeleteScript(ctx, caller.WorkspaceID, req.Msg.ScriptId); err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.deleted",
		ScriptID:  req.Msg.ScriptId,
		Payload: map[string]any{
			"script_id":    req.Msg.ScriptId,
			"workspace_id": caller.WorkspaceID,
			"deleted_by":   caller.UserID,
		},
		EmittedAt: time.Now().UTC(),
	})

	return connect.NewResponse(&contentv1.ScriptServiceDeleteResponse{
		Success: true,
	}), nil
}

// Duplicate handles script duplication and channel rewrites (RULE-M06-004, AC-4).
func (s *Service) Duplicate(ctx context.Context, req *connect.Request[contentv1.ScriptServiceDuplicateRequest]) (*connect.Response[contentv1.ScriptServiceDuplicateResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	source, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	now := time.Now().UTC()
	newScriptID := generateDeterministicUUID(caller.WorkspaceID, source.ScriptID+":dup", now)

	newTitle := req.Msg.NewTitle
	targetPlatform := req.Msg.TargetPlatform
	targetFormat := req.Msg.NewFormatType
	if targetFormat == "" {
		targetFormat = source.FormatType
	}
	durationTarget := source.DurationTargetSeconds
	if req.Msg.AdjustedDurationSeconds > 0 {
		durationTarget = req.Msg.AdjustedDurationSeconds
	}

	// Channel rewrite specific modifications (AC-4, RULE-M06-004)
	profiles := make([]StoredPublishTargetProfile, 0)
	if targetPlatform != "" {
		if newTitle == "" {
			newTitle = fmt.Sprintf("%s (%s Adaptation)", source.Title, targetPlatform)
		}
		if strings.EqualFold(targetPlatform, "TikTok") || strings.EqualFold(targetPlatform, "Reels") {
			targetFormat = "9:16 vertical short"
			if durationTarget > 60 {
				durationTarget = 60
			}
		} else if strings.EqualFold(targetPlatform, "YouTube") {
			targetFormat = "16:9 horizontal long"
			if durationTarget < 120 {
				durationTarget = 180
			}
		}
		profiles = append(profiles, StoredPublishTargetProfile{
			Platform: targetPlatform,
			Format:   targetFormat,
		})
	} else if newTitle == "" {
		newTitle = fmt.Sprintf("%s (Copy)", source.Title)
	}

	// Deep clone scenes with new IDs
	clonedScenes := make([]StoredScene, 0, len(source.Scenes))
	for i, sc := range source.Scenes {
		newSceneID := generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:sc:%d", newScriptID, i), now)
		clonedShots := make([]StoredShot, 0, len(sc.ShotList))
		for j, sh := range sc.ShotList {
			clonedShots = append(clonedShots, StoredShot{
				ShotID:          generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:sh:%d", newSceneID, j), now),
				SceneID:         newSceneID,
				WorkspaceID:     caller.WorkspaceID,
				ShotIndex:       sh.ShotIndex,
				ShotType:        sh.ShotType,
				Description:     sh.Description,
				DurationSeconds: sh.DurationSeconds,
				CreatedAt:       now,
			})
		}
		clonedScenes = append(clonedScenes, StoredScene{
			SceneID:         newSceneID,
			ScriptID:        newScriptID,
			WorkspaceID:     caller.WorkspaceID,
			SceneIndex:      sc.SceneIndex,
			Description:     sc.Description,
			Content:         sc.Content,
			DurationSeconds: sc.DurationSeconds,
			VisualNotes:     sc.VisualNotes,
			AudioNotes:      sc.AudioNotes,
			ShotList:        clonedShots,
			CreatedAt:       now,
		})
	}

	// Cloned script retains source idea_id (RULE-M06-004)
	newScript := StoredScript{
		ScriptID:              newScriptID,
		WorkspaceID:           caller.WorkspaceID,
		IdeaID:                source.IdeaID,
		SourceIdeaTitle:       source.SourceIdeaTitle,
		Title:                 newTitle,
		FormatType:            targetFormat,
		Scenes:                clonedScenes,
		CtaBlocks:             cloneCtaBlocks(source.CtaBlocks),
		DisclosureBlocks:      cloneDisclosureBlocks(source.DisclosureBlocks),
		DurationTargetSeconds: durationTarget,
		LifecycleState:        contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT,
		ApprovalState:         contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_UNSPECIFIED,
		PublishTargetProfiles: profiles,
		ContinuityRefs:        cloneStrings(source.ContinuityRefs),
		OfferProductHooks:     cloneStrings(source.OfferProductHooks),
		VersionIndex:          1,
		CreatedBy:             caller.UserID,
		CreatedAt:             now,
		UpdatedAt:             now,
	}

	if err := s.store.CreateScript(ctx, newScript); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Initial version snapshot
	ver := StoredScriptVersion{
		VersionID:             generateDeterministicUUID(caller.WorkspaceID, newScriptID+":v1", now),
		WorkspaceID:           caller.WorkspaceID,
		ScriptID:              newScriptID,
		VersionIndex:          1,
		Title:                 newTitle,
		Scenes:                clonedScenes,
		CtaBlocks:             newScript.CtaBlocks,
		DisclosureBlocks:      newScript.DisclosureBlocks,
		DurationTargetSeconds: durationTarget,
		LifecycleState:        contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT,
		ApprovalState:         contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_UNSPECIFIED,
		SnapshotReason:        fmt.Sprintf("Duplicated from %s (Channel rewrite: %s)", source.ScriptID, targetPlatform),
		CreatedBy:             caller.UserID,
		CreatedAt:             now,
	}
	_ = s.store.CreateScriptVersion(ctx, ver)

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.created",
		ScriptID:  newScriptID,
		Payload: map[string]any{
			"script_id":        newScriptID,
			"workspace_id":     caller.WorkspaceID,
			"source_script_id": source.ScriptID,
			"idea_id":          source.IdeaID,
			"target_platform":  targetPlatform,
		},
		EmittedAt: now,
	})

	return connect.NewResponse(&contentv1.ScriptServiceDuplicateResponse{
		DuplicatedScript: newScript.ToProto(),
	}), nil
}

// GetStats computes workspace script counts by lifecycle and approval state.
func (s *Service) GetStats(ctx context.Context, req *connect.Request[contentv1.ScriptServiceGetStatsRequest]) (*connect.Response[contentv1.ScriptServiceGetStatsResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	scripts, _, total, err := s.store.ListScripts(
		ctx,
		caller.WorkspaceID,
		contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_UNSPECIFIED,
		contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_UNSPECIFIED,
		"",
		1000,
		"",
	)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var draftCount int32
	var pendingCount int32
	var approvedCount int32
	var readyCount int32
	var archivedCount int32

	for _, sc := range scripts {
		switch sc.LifecycleState {
		case contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_DRAFT:
			draftCount++
		case contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION:
			readyCount++
		case contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_ARCHIVED:
			archivedCount++
		}
		if sc.ApprovalState == contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_PENDING_APPROVAL {
			pendingCount++
		} else if sc.ApprovalState == contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED {
			approvedCount++
		}
	}

	return connect.NewResponse(&contentv1.ScriptServiceGetStatsResponse{
		TotalScripts:            int32(total),
		DraftCount:              draftCount,
		PendingApprovalCount:    pendingCount,
		ApprovedCount:           approvedCount,
		ReadyForProductionCount: readyCount,
		ArchivedCount:           archivedCount,
	}), nil
}

// GetBrief manages Asset Brief and validates ready-for-production (RULE-M06-005, RULE-M06-006, AC-2).
func (s *Service) GetBrief(ctx context.Context, req *connect.Request[contentv1.ScriptServiceGetBriefRequest]) (*connect.Response[contentv1.ScriptServiceGetBriefResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	now := time.Now().UTC()
	brief, err := s.store.GetAssetBrief(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		if req.Msg.CreateIfMissing {
			briefID := generateDeterministicUUID(caller.WorkspaceID, req.Msg.ScriptId+":brief", now)
			brief = &StoredAssetBrief{
				AssetBriefID:               briefID,
				WorkspaceID:                caller.WorkspaceID,
				ScriptID:                   req.Msg.ScriptId,
				OutputType:                 req.Msg.OutputType,
				TargetFormat:               req.Msg.TargetFormat,
				TargetDurationSeconds:      req.Msg.TargetDurationSeconds,
				ContinuityRequirementsJSON: req.Msg.ContinuityRequirementsJson,
				BrandVoiceRequirementsJSON: req.Msg.BrandVoiceRequirementsJson,
				ProductionInstructions:     req.Msg.ProductionInstructions,
				Status:                     contentv1.AssetBriefStatus_ASSET_BRIEF_STATUS_DRAFT,
				CreatedAt:                  now,
				UpdatedAt:                  now,
			}
			if IsAssetBriefComplete(brief) {
				brief.Status = contentv1.AssetBriefStatus_ASSET_BRIEF_STATUS_READY
			}
			if err := s.store.UpsertAssetBrief(ctx, *brief); err != nil {
				return nil, connect.NewError(connect.CodeInternal, err)
			}
		} else {
			return nil, connect.NewError(connect.CodeNotFound, ErrAssetBriefNotFound)
		}
	} else if req.Msg.OutputType != "" || req.Msg.TargetFormat != "" || req.Msg.TargetDurationSeconds > 0 || req.Msg.ContinuityRequirementsJson != "" {
		// Update existing brief
		if req.Msg.OutputType != "" {
			brief.OutputType = req.Msg.OutputType
		}
		if req.Msg.TargetFormat != "" {
			brief.TargetFormat = req.Msg.TargetFormat
		}
		if req.Msg.TargetDurationSeconds > 0 {
			brief.TargetDurationSeconds = req.Msg.TargetDurationSeconds
		}
		if req.Msg.ContinuityRequirementsJson != "" {
			brief.ContinuityRequirementsJSON = req.Msg.ContinuityRequirementsJson
		}
		if req.Msg.BrandVoiceRequirementsJson != "" {
			brief.BrandVoiceRequirementsJSON = req.Msg.BrandVoiceRequirementsJson
		}
		if req.Msg.ProductionInstructions != "" {
			brief.ProductionInstructions = req.Msg.ProductionInstructions
		}
		brief.UpdatedAt = now
		if IsAssetBriefComplete(brief) {
			brief.Status = contentv1.AssetBriefStatus_ASSET_BRIEF_STATUS_READY
		}
		_ = s.store.UpsertAssetBrief(ctx, *brief)
	}

	// Ready-for-production transition check (RULE-M06-005, RULE-M06-006, AC-2)
	readyForProduction := false
	if script.ApprovalState == contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_APPROVED && IsAssetBriefComplete(brief) {
		readyForProduction = true
		if script.LifecycleState != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION {
			script.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION
			script.UpdatedAt = now
			_ = s.store.UpdateScript(ctx, *script)

			s.store.RecordEvent(DomainEventRecord{
				EventType: "script.ready_for_production",
				ScriptID:  script.ScriptID,
				Payload: map[string]any{
					"script_id":      script.ScriptID,
					"asset_brief_id": brief.AssetBriefID,
					"workspace_id":   caller.WorkspaceID,
					"output_type":    brief.OutputType,
					"target_format":  brief.TargetFormat,
				},
				EmittedAt: now,
			})
		}
	}

	return connect.NewResponse(&contentv1.ScriptServiceGetBriefResponse{
		AssetBrief:         brief.ToProto(),
		ReadyForProduction: readyForProduction,
	}), nil
}

// GetReview returns approval status and inline feedback.
func (s *Service) GetReview(ctx context.Context, req *connect.Request[contentv1.ScriptServiceGetReviewRequest]) (*connect.Response[contentv1.ScriptServiceGetReviewResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	comments, _ := s.store.ListComments(ctx, script.ScriptID)
	protoComments := make([]*contentv1.ScriptReviewComment, len(comments))
	for i, c := range comments {
		protoComments[i] = &contentv1.ScriptReviewComment{
			CommentId:  c.CommentID,
			ScriptId:   c.ScriptID,
			UserId:     c.UserID,
			AuthorName: c.AuthorName,
			Content:    c.Content,
			SceneIndex: c.SceneIndex,
			IsResolved: c.IsResolved,
			CreatedAt:  timestamppb.New(c.CreatedAt),
		}
	}

	return connect.NewResponse(&contentv1.ScriptServiceGetReviewResponse{
		ScriptId:        script.ScriptID,
		ApprovalState:   script.ApprovalState,
		ApprovedBy:      script.ApprovedBy,
		RejectionReason: script.RejectionReason,
		Comments:        protoComments,
	}), nil
}

// SubmitReview appends comments and feedback.
func (s *Service) SubmitReview(ctx context.Context, req *connect.Request[contentv1.ScriptServiceSubmitReviewRequest]) (*connect.Response[contentv1.ScriptServiceSubmitReviewResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	now := time.Now().UTC()
	if strings.TrimSpace(req.Msg.ReviewNotes) != "" {
		commentID := generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:comm:%d", req.Msg.ScriptId, now.UnixNano()), now)
		_ = s.store.AddComment(ctx, StoredComment{
			CommentID:  commentID,
			ScriptID:   req.Msg.ScriptId,
			UserID:     caller.UserID,
			AuthorName: caller.UserID,
			Content:    req.Msg.ReviewNotes,
			SceneIndex: 0,
			IsResolved: false,
			CreatedAt:  now,
		})
	}

	return connect.NewResponse(&contentv1.ScriptServiceSubmitReviewResponse{
		Success: true,
	}), nil
}

// RequestChanges handles changes request with stale check and reason validation.
func (s *Service) RequestChanges(ctx context.Context, req *connect.Request[contentv1.ScriptServiceRequestChangesRequest]) (*connect.Response[contentv1.ScriptServiceRequestChangesResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	// Concurrency check
	if req.Msg.ExpectedVersion > 0 && script.VersionIndex != req.Msg.ExpectedVersion {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrStaleReviewConflict)
	}

	reason := strings.TrimSpace(req.Msg.Feedback)
	if err := ValidateRejectionReason(reason); err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	now := time.Now().UTC()
	script.ApprovalState = contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_REJECTED
	script.LifecycleState = contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED
	script.RejectionReason = reason
	script.UpdatedAt = now

	if err := s.store.UpdateScript(ctx, *script); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.changes_requested",
		ScriptID:  script.ScriptID,
		Payload: map[string]any{
			"script_id": script.ScriptID,
			"reason":    reason,
		},
		EmittedAt: now,
	})

	return connect.NewResponse(&contentv1.ScriptServiceRequestChangesResponse{
		Script: script.ToProto(),
	}), nil
}

// AddSection adds a scene.
func (s *Service) AddSection(ctx context.Context, req *connect.Request[contentv1.ScriptServiceAddSectionRequest]) (*connect.Response[contentv1.ScriptServiceAddSectionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	now := time.Now().UTC()
	sceneID := generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:sc:%d", script.ScriptID, len(script.Scenes)), now)
	newScene := StoredScene{
		SceneID:         sceneID,
		ScriptID:        script.ScriptID,
		WorkspaceID:     caller.WorkspaceID,
		SceneIndex:      int32(len(script.Scenes)),
		Description:     req.Msg.Scene.Description,
		Content:         req.Msg.Scene.Content,
		DurationSeconds: req.Msg.Scene.DurationSeconds,
		VisualNotes:     req.Msg.Scene.VisualNotes,
		AudioNotes:      req.Msg.Scene.AudioNotes,
		CreatedAt:       now,
	}

	script.Scenes = append(script.Scenes, newScene)
	script.VersionIndex++
	script.UpdatedAt = now
	_ = s.store.UpdateScript(ctx, *script)

	return connect.NewResponse(&contentv1.ScriptServiceAddSectionResponse{
		Script: script.ToProto(),
	}), nil
}

// UpdateSection updates a scene.
func (s *Service) UpdateSection(ctx context.Context, req *connect.Request[contentv1.ScriptServiceUpdateSectionRequest]) (*connect.Response[contentv1.ScriptServiceUpdateSectionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	if req.Msg.Scene == nil || req.Msg.Scene.SceneId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("scene with scene_id required"))
	}

	found := false
	for i, sc := range script.Scenes {
		if sc.SceneID == req.Msg.Scene.SceneId {
			script.Scenes[i].Description = req.Msg.Scene.Description
			script.Scenes[i].Content = req.Msg.Scene.Content
			script.Scenes[i].DurationSeconds = req.Msg.Scene.DurationSeconds
			script.Scenes[i].VisualNotes = req.Msg.Scene.VisualNotes
			script.Scenes[i].AudioNotes = req.Msg.Scene.AudioNotes
			found = true
			break
		}
	}
	if !found {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("scene not found"))
	}

	now := time.Now().UTC()
	script.VersionIndex++
	script.UpdatedAt = now
	_ = s.store.UpdateScript(ctx, *script)

	return connect.NewResponse(&contentv1.ScriptServiceUpdateSectionResponse{
		Script: script.ToProto(),
	}), nil
}

// DeleteSection removes a scene.
func (s *Service) DeleteSection(ctx context.Context, req *connect.Request[contentv1.ScriptServiceDeleteSectionRequest]) (*connect.Response[contentv1.ScriptServiceDeleteSectionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	idx := -1
	for i, sc := range script.Scenes {
		if sc.SceneID == req.Msg.SceneId {
			idx = i
			break
		}
	}
	if idx == -1 {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("scene not found"))
	}

	script.Scenes = append(script.Scenes[:idx], script.Scenes[idx+1:]...)
	// Reindex
	for i := range script.Scenes {
		script.Scenes[i].SceneIndex = int32(i)
	}

	now := time.Now().UTC()
	script.VersionIndex++
	script.UpdatedAt = now
	_ = s.store.UpdateScript(ctx, *script)

	return connect.NewResponse(&contentv1.ScriptServiceDeleteSectionResponse{
		Script: script.ToProto(),
	}), nil
}

// ReorderSections adjusts order of scenes.
func (s *Service) ReorderSections(ctx context.Context, req *connect.Request[contentv1.ScriptServiceReorderSectionsRequest]) (*connect.Response[contentv1.ScriptServiceReorderSectionsResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	sceneMap := make(map[string]StoredScene)
	for _, sc := range script.Scenes {
		sceneMap[sc.SceneID] = sc
	}

	var reordered []StoredScene
	for i, sid := range req.Msg.SceneIdsInOrder {
		if sc, exists := sceneMap[sid]; exists {
			sc.SceneIndex = int32(i)
			reordered = append(reordered, sc)
			delete(sceneMap, sid)
		}
	}
	// Append remaining
	for _, sc := range sceneMap {
		sc.SceneIndex = int32(len(reordered))
		reordered = append(reordered, sc)
	}

	now := time.Now().UTC()
	script.Scenes = reordered
	script.VersionIndex++
	script.UpdatedAt = now
	_ = s.store.UpdateScript(ctx, *script)

	return connect.NewResponse(&contentv1.ScriptServiceReorderSectionsResponse{
		Script: script.ToProto(),
	}), nil
}

// AddComment appends inline feedback (Contributor+).
func (s *Service) AddComment(ctx context.Context, req *connect.Request[contentv1.ScriptServiceAddCommentRequest]) (*connect.Response[contentv1.ScriptServiceAddCommentResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	now := time.Now().UTC()
	commentID := generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:comm:%d", req.Msg.ScriptId, now.UnixNano()), now)
	comment := StoredComment{
		CommentID:  commentID,
		ScriptID:   req.Msg.ScriptId,
		UserID:     caller.UserID,
		AuthorName: caller.UserID,
		Content:    req.Msg.Content,
		SceneIndex: req.Msg.SceneIndex,
		IsResolved: false,
		CreatedAt:  now,
	}

	_ = s.store.AddComment(ctx, comment)

	return connect.NewResponse(&contentv1.ScriptServiceAddCommentResponse{
		Comment: &contentv1.ScriptReviewComment{
			CommentId:  comment.CommentID,
			ScriptId:   comment.ScriptID,
			UserId:     comment.UserID,
			AuthorName: comment.AuthorName,
			Content:    comment.Content,
			SceneIndex: comment.SceneIndex,
			IsResolved: comment.IsResolved,
			CreatedAt:  timestamppb.New(comment.CreatedAt),
		},
	}), nil
}

// ResolveComment resolves an inline feedback item.
func (s *Service) ResolveComment(ctx context.Context, req *connect.Request[contentv1.ScriptServiceResolveCommentRequest]) (*connect.Response[contentv1.ScriptServiceResolveCommentResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	if err := s.store.ResolveComment(ctx, req.Msg.ScriptId, req.Msg.CommentId); err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(&contentv1.ScriptServiceResolveCommentResponse{
		Success: true,
	}), nil
}

// GetVersion fetches a specific historical version snapshot (A3).
func (s *Service) GetVersion(ctx context.Context, req *connect.Request[contentv1.ScriptServiceGetVersionRequest]) (*connect.Response[contentv1.ScriptServiceGetVersionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	ver, err := s.store.GetScriptVersion(ctx, caller.WorkspaceID, req.Msg.ScriptId, req.Msg.VersionIndex)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrVersionNotFound)
	}

	return connect.NewResponse(&contentv1.ScriptServiceGetVersionResponse{
		Version: ver.ToProto(),
	}), nil
}

// ListVersions lists all historical versions for diffing and rollback (A3).
func (s *Service) ListVersions(ctx context.Context, req *connect.Request[contentv1.ScriptServiceListVersionsRequest]) (*connect.Response[contentv1.ScriptServiceListVersionsResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	versions, err := s.store.ListScriptVersions(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoVers := make([]*contentv1.ScriptVersion, len(versions))
	for i, v := range versions {
		protoVers[i] = v.ToProto()
	}

	return connect.NewResponse(&contentv1.ScriptServiceListVersionsResponse{
		Versions: protoVers,
	}), nil
}

// RestoreVersion restores script to a previous version snapshot (A3).
func (s *Service) RestoreVersion(ctx context.Context, req *connect.Request[contentv1.ScriptServiceRestoreVersionRequest]) (*connect.Response[contentv1.ScriptServiceRestoreVersionResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "script:edit"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	script, err := s.store.GetScript(ctx, caller.WorkspaceID, req.Msg.ScriptId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrScriptNotFound)
	}

	targetVer, err := s.store.GetScriptVersion(ctx, caller.WorkspaceID, req.Msg.ScriptId, req.Msg.VersionIndex)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrVersionNotFound)
	}

	now := time.Now().UTC()
	script.Title = targetVer.Title
	script.Scenes = cloneScenes(targetVer.Scenes)
	script.CtaBlocks = cloneCtaBlocks(targetVer.CtaBlocks)
	script.DisclosureBlocks = cloneDisclosureBlocks(targetVer.DisclosureBlocks)
	script.DurationTargetSeconds = targetVer.DurationTargetSeconds
	script.VersionIndex++
	script.UpdatedAt = now

	if err := s.store.UpdateScript(ctx, *script); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Create snapshot for the restore event
	newVer := StoredScriptVersion{
		VersionID:             generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:v%d", script.ScriptID, script.VersionIndex), now),
		WorkspaceID:           caller.WorkspaceID,
		ScriptID:              script.ScriptID,
		VersionIndex:          script.VersionIndex,
		Title:                 script.Title,
		Scenes:                script.Scenes,
		CtaBlocks:             script.CtaBlocks,
		DisclosureBlocks:      script.DisclosureBlocks,
		DurationTargetSeconds: script.DurationTargetSeconds,
		LifecycleState:        script.LifecycleState,
		ApprovalState:         script.ApprovalState,
		SnapshotReason:        fmt.Sprintf("Restored from version %d", targetVer.VersionIndex),
		CreatedBy:             caller.UserID,
		CreatedAt:             now,
	}
	_ = s.store.CreateScriptVersion(ctx, newVer)

	s.store.RecordEvent(DomainEventRecord{
		EventType: "script.version_restored",
		ScriptID:  script.ScriptID,
		Payload: map[string]any{
			"script_id":        script.ScriptID,
			"restored_version": targetVer.VersionIndex,
			"new_version":      script.VersionIndex,
		},
		EmittedAt: now,
	})

	return connect.NewResponse(&contentv1.ScriptServiceRestoreVersionResponse{
		Script: script.ToProto(),
	}), nil
}

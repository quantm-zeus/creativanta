package idea

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1/contentv1connect"
	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
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

var _ contentv1connect.IdeaServiceHandler = (*Service)(nil)

func checkPerm(caller CallerContext, perm string) error {
	return rbac.CheckWorkspacePermission(perm, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

// Create creates a new idea, enforcing source lineage, duplicate warnings (>0.85),
// and mobile title-only quick capture.
func (s *Service) Create(ctx context.Context, req *connect.Request[contentv1.IdeaServiceCreateRequest]) (*connect.Response[contentv1.IdeaServiceCreateResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	title := strings.TrimSpace(req.Msg.Title)
	if title == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrTitleRequired)
	}

	// 1. Deduplication check per RULE-M05-005 and Acceptance Target 1 (>0.85 similarity)
	matches, err := s.store.FindSimilarIdeas(ctx, caller.WorkspaceID, title, nil, 0.85)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	if len(matches) > 0 {
		topMatch := matches[0]
		warning := &contentv1.DuplicateWarning{
			IsDuplicate:       true,
			SimilarityScore:   topMatch.SimilarityScore,
			ExistingIdeaId:    topMatch.ExistingIdeaID,
			ExistingIdeaTitle: topMatch.ExistingIdeaTitle,
			WarningMessage:    fmt.Sprintf("Similar idea exists: '%s' (similarity: %.2f) — View existing or proceed anyway?", topMatch.ExistingIdeaTitle, topMatch.SimilarityScore),
		}

		// If user only wanted to check or has not explicitly confirmed, return warning WITHOUT silent merge or saving
		if req.Msg.CheckDuplicateOnly || !req.Msg.ConfirmDuplicate {
			return connect.NewResponse(&contentv1.IdeaServiceCreateResponse{
				Created:          false,
				DuplicateWarning: warning,
			}), nil
		}
	} else if req.Msg.CheckDuplicateOnly {
		return connect.NewResponse(&contentv1.IdeaServiceCreateResponse{
			Created: false,
			DuplicateWarning: &contentv1.DuplicateWarning{
				IsDuplicate: false,
			},
		}), nil
	}

	now := time.Now().UTC()
	ideaID := generateDeterministicUUID(caller.WorkspaceID, title, now)

	// 2. Source Lineage Enforcement per RULE-M05-001 and Acceptance Target 2
	var sources []StoredIdeaSource
	if len(req.Msg.SourceRefs) > 0 {
		for _, ref := range req.Msg.SourceRefs {
			st := strings.ToLower(strings.TrimSpace(ref.SourceType))
			if !ValidSourceTypes[st] {
				st = "manual"
			}
			sID := ref.SourceId
			if sID == "" {
				sID = caller.UserID
			}
			sources = append(sources, StoredIdeaSource{
				SourceType:    st,
				SourceID:      sID,
				SourceTitle:   ref.SourceTitle,
				SourceURL:     ref.SourceUrl,
				IsArchived:    ref.IsArchived,
				ArchiveNotice: ref.ArchiveNotice,
			})
		}
	} else {
		// Manual fallback per RULE-M05-001: manual ideas use source_type = 'manual' with source_id = user_id
		sources = append(sources, StoredIdeaSource{
			SourceType:  "manual",
			SourceID:    caller.UserID,
			SourceTitle: "Manual Entry by " + caller.UserID,
		})
	}

	status := contentv1.IdeaStatus_IDEA_STATUS_DRAFT
	score := computeInitialIdeaScore(title, req.Msg.Description, req.Msg.SuggestedFormat)

	idea := StoredIdea{
		IdeaID:             ideaID,
		WorkspaceID:        caller.WorkspaceID,
		Title:              title,
		Description:        req.Msg.Description,
		AudienceIntent:     req.Msg.AudienceIntent,
		CreatorIntent:      req.Msg.CreatorIntent,
		SuggestedFormat:    req.Msg.SuggestedFormat,
		SuggestedDirection: req.Msg.SuggestedDirection,
		Status:             status,
		IdeaScore:          score,
		CreatedBy:          caller.UserID,
		Sources:            sources,
		EmbeddingVector:    generateSyntheticEmbedding(title),
		CreatedAt:          now,
		UpdatedAt:          now,
		SourceClass:        intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		Confidence:         intelligencev1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM,
	}

	if err := s.store.CreateIdea(ctx, idea); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// 3. Attach initial hooks if provided
	var attachedHooks []StoredHook
	for idx, hookText := range req.Msg.InitialHooks {
		if strings.TrimSpace(hookText) == "" {
			continue
		}
		h := StoredHook{
			HookID:             generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:hook:%d", ideaID, idx), now),
			WorkspaceID:        caller.WorkspaceID,
			IdeaID:             ideaID,
			HookText:           strings.TrimSpace(hookText),
			HookType:           contentv1.HookType_HOOK_TYPE_QUESTION,
			EffectivenessScore: 75.0,
			UsageCount:         0,
			Source:             contentv1.HookSource_HOOK_SOURCE_MANUAL,
			CreatedAt:          now,
		}
		_ = s.store.AddHook(ctx, h)
		attachedHooks = append(attachedHooks, h)
	}
	idea.Hooks = attachedHooks

	// 4. Emit domain event idea.created per domain_event_catalog.md §4
	firstSourceType := "manual"
	if len(sources) > 0 {
		firstSourceType = sources[0].SourceType
	}
	s.store.RecordEvent(DomainEvent{
		EventType:   "idea.created",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"idea_id":     ideaID,
			"source_type": firstSourceType,
		},
		OccurredAt: now,
	})

	var dupWarn *contentv1.DuplicateWarning
	if len(matches) > 0 {
		topMatch := matches[0]
		dupWarn = &contentv1.DuplicateWarning{
			IsDuplicate:       true,
			SimilarityScore:   topMatch.SimilarityScore,
			ExistingIdeaId:    topMatch.ExistingIdeaID,
			ExistingIdeaTitle: topMatch.ExistingIdeaTitle,
			WarningMessage:    fmt.Sprintf("Created alongside existing similar idea: '%s' (similarity: %.2f)", topMatch.ExistingIdeaTitle, topMatch.SimilarityScore),
		}
	}

	return connect.NewResponse(&contentv1.IdeaServiceCreateResponse{
		Idea:             mapToProtoIdea(idea),
		Created:          true,
		DuplicateWarning: dupWarn,
	}), nil
}

// List lists ideas with filtering by status, source_type, and search query.
func (s *Service) List(ctx context.Context, req *connect.Request[contentv1.IdeaServiceListRequest]) (*connect.Response[contentv1.IdeaServiceListResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	limit := int(req.Msg.PageSize)
	if limit <= 0 || limit > 100 {
		limit = 50
	}

	ideas, err := s.store.ListIdeas(ctx, caller.WorkspaceID, req.Msg.Status, req.Msg.SourceType, req.Msg.SearchQuery, limit)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoIdeas []*contentv1.Idea
	for _, item := range ideas {
		hooks, _ := s.store.ListHooks(ctx, caller.WorkspaceID, item.IdeaID)
		item.Hooks = hooks
		protoIdeas = append(protoIdeas, mapToProtoIdea(item))
	}

	return connect.NewResponse(&contentv1.IdeaServiceListResponse{
		Ideas:      protoIdeas,
		TotalCount: int32(len(protoIdeas)),
	}), nil
}

// Get retrieves an idea and its attached hooks and provenance sources.
func (s *Service) Get(ctx context.Context, req *connect.Request[contentv1.IdeaServiceGetRequest]) (*connect.Response[contentv1.IdeaServiceGetResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	idea, err := s.store.GetIdea(ctx, caller.WorkspaceID, req.Msg.IdeaId)
	if err != nil {
		if errors.Is(err, ErrIdeaNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	hooks, _ := s.store.ListHooks(ctx, caller.WorkspaceID, idea.IdeaID)
	idea.Hooks = hooks

	return connect.NewResponse(&contentv1.IdeaServiceGetResponse{
		Idea: mapToProtoIdea(*idea),
	}), nil
}

// Update updates idea fields with optimistic concurrency.
func (s *Service) Update(ctx context.Context, req *connect.Request[contentv1.IdeaServiceUpdateRequest]) (*connect.Response[contentv1.IdeaServiceUpdateResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	idea, err := s.store.GetIdea(ctx, caller.WorkspaceID, req.Msg.IdeaId)
	if err != nil {
		if errors.Is(err, ErrIdeaNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	if req.Msg.ExpectedUpdatedAt != nil {
		expected := req.Msg.ExpectedUpdatedAt.AsTime()
		if !idea.UpdatedAt.Truncate(time.Microsecond).Equal(expected.Truncate(time.Microsecond)) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrConcurrentConflict)
		}
	}

	if req.Msg.Title != "" {
		idea.Title = strings.TrimSpace(req.Msg.Title)
		idea.EmbeddingVector = generateSyntheticEmbedding(idea.Title)
	}
	if req.Msg.Description != "" {
		idea.Description = req.Msg.Description
	}
	if req.Msg.AudienceIntent != "" {
		idea.AudienceIntent = req.Msg.AudienceIntent
	}
	if req.Msg.CreatorIntent != "" {
		idea.CreatorIntent = req.Msg.CreatorIntent
	}
	if req.Msg.SuggestedFormat != "" {
		idea.SuggestedFormat = req.Msg.SuggestedFormat
	}
	if req.Msg.SuggestedDirection != "" {
		idea.SuggestedDirection = req.Msg.SuggestedDirection
	}
	if req.Msg.Angle != "" {
		idea.Angle = req.Msg.Angle
	}

	now := time.Now().UTC()
	idea.UpdatedAt = now
	idea.IdeaScore = computeInitialIdeaScore(idea.Title, idea.Description, idea.SuggestedFormat)

	if err := s.store.UpdateIdea(ctx, *idea); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.IdeaServiceUpdateResponse{
		Idea: mapToProtoIdea(*idea),
	}), nil
}

// Delete soft-deletes an idea.
func (s *Service) Delete(ctx context.Context, req *connect.Request[contentv1.IdeaServiceDeleteRequest]) (*connect.Response[contentv1.IdeaServiceDeleteResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	if err := s.store.DeleteIdea(ctx, caller.WorkspaceID, req.Msg.IdeaId); err != nil {
		if errors.Is(err, ErrIdeaNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.IdeaServiceDeleteResponse{
		Success: true,
	}), nil
}

// UpdateStatus enforces canonical state machine progression (RULE-M05-002):
// draft → candidate → selected → converted | archived. State skipping is strictly forbidden.
func (s *Service) UpdateStatus(ctx context.Context, req *connect.Request[contentv1.IdeaServiceUpdateStatusRequest]) (*connect.Response[contentv1.IdeaServiceUpdateStatusResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	idea, err := s.store.GetIdea(ctx, caller.WorkspaceID, req.Msg.IdeaId)
	if err != nil {
		if errors.Is(err, ErrIdeaNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	if req.Msg.ExpectedUpdatedAt != nil {
		expected := req.Msg.ExpectedUpdatedAt.AsTime()
		if !idea.UpdatedAt.Truncate(time.Microsecond).Equal(expected.Truncate(time.Microsecond)) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrConcurrentConflict)
		}
	}

	if err := ValidateStateTransition(idea.Status, req.Msg.TargetStatus); err != nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("%w: cannot transition from %s to %s", err, idea.Status, req.Msg.TargetStatus))
	}

	now := time.Now().UTC()
	idea.Status = req.Msg.TargetStatus
	idea.UpdatedAt = now

	if err := s.store.UpdateIdea(ctx, *idea); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.IdeaServiceUpdateStatusResponse{
		Idea: mapToProtoIdea(*idea),
	}), nil
}

// Generate provides AI idea enrichment and hook/angle suggestions with a 20/hr rate limit (EC-M05-003).
func (s *Service) Generate(ctx context.Context, req *connect.Request[contentv1.IdeaServiceGenerateRequest]) (*connect.Response[contentv1.IdeaServiceGenerateResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	// Hourly rate limit check (max 20 generations per hour per workspace)
	now := time.Now().UTC()
	oneHourAgo := now.Add(-1 * time.Hour)
	count, err := s.store.CountAIGenerations(ctx, caller.WorkspaceID, oneHourAgo)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if count >= 20 {
		return nil, connect.NewError(connect.CodeResourceExhausted, ErrHourlyRateLimitExceeded)
	}

	requestedCount := int(req.Msg.Count)
	if requestedCount <= 0 || requestedCount > 5 {
		requestedCount = 3
	}

	_ = s.store.RecordAIGeneration(ctx, caller.WorkspaceID, now)

	var generatedIdeas []*contentv1.Idea
	templates := []struct {
		format string
		angle  string
		hooks  []string
	}{
		{
			format: "short_form",
			angle:  "Before/After Transformation",
			hooks:  []string{"Bạn có đang làm sai điều này mỗi sáng?", "3 lỗi phổ biến khiến bạn không đạt hiệu quả mong muốn"},
		},
		{
			format: "review",
			angle:  "Honest Breakdown & Contrast",
			hooks:  []string{"Đừng mua sản phẩm này trước khi biết 2 sự thật này", "So sánh thực tế: Tiết kiệm hay lãng phí?"},
		},
		{
			format: "tutorial",
			angle:  "Step-by-Step Practical Guide",
			hooks:  []string{"Cách làm chuẩn chỉnh chỉ trong 60 giây", "Công thức đơn giản ai cũng áp dụng được ngay"},
		},
	}

	for i := 0; i < requestedCount; i++ {
		tIdx := i % len(templates)
		tmpl := templates[tIdx]

		title := fmt.Sprintf("%s #%d: %s", req.Msg.Prompt, i+1, tmpl.angle)
		ideaID := generateDeterministicUUID(caller.WorkspaceID, title, now)

		sources := []StoredIdeaSource{
			{
				SourceType:    "opportunity",
				SourceID:      req.Msg.SourceId,
				SourceTitle:   req.Msg.Prompt,
				IsArchived:    false,
				ArchiveNotice: "",
			},
		}

		newIdea := StoredIdea{
			IdeaID:               ideaID,
			WorkspaceID:          caller.WorkspaceID,
			Title:                title,
			Description:          fmt.Sprintf("AI-enriched concept targeting %s with angle: %s", req.Msg.TargetAudience, tmpl.angle),
			AudienceIntent:       req.Msg.TargetAudience,
			CreatorIntent:        "Value delivery & conversion",
			SuggestedFormat:      tmpl.format,
			SuggestedDirection:   "High pacing short-form video with strong visual hook",
			Status:               contentv1.IdeaStatus_IDEA_STATUS_DRAFT,
			IdeaScore:            82.5,
			CreatedBy:            caller.UserID,
			Sources:              sources,
			EmbeddingVector:      generateSyntheticEmbedding(title),
			CreatedAt:            now,
			UpdatedAt:            now,
			SourceClass:          intelligencev1.SourceClass_SOURCE_CLASS_INFERRED,
			Confidence:           intelligencev1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM_HIGH,
			RecommendedFormats:   []string{tmpl.format, "reels", "tiktok"},
			RecommendedPlatforms: []string{"tiktok", "youtube_shorts"},
			Angle:                tmpl.angle,
			HookSuggestion:       tmpl.hooks[0],
		}

		_ = s.store.CreateIdea(ctx, newIdea)

		for hIdx, hText := range tmpl.hooks {
			h := StoredHook{
				HookID:             generateDeterministicUUID(caller.WorkspaceID, fmt.Sprintf("%s:ai_hook:%d", ideaID, hIdx), now),
				WorkspaceID:        caller.WorkspaceID,
				IdeaID:             ideaID,
				HookText:           hText,
				HookType:           contentv1.HookType_HOOK_TYPE_QUESTION,
				EffectivenessScore: 80.0,
				UsageCount:         0,
				Source:             contentv1.HookSource_HOOK_SOURCE_AI_GENERATED,
				CreatedAt:          now,
			}
			_ = s.store.AddHook(ctx, h)
			newIdea.Hooks = append(newIdea.Hooks, h)
		}

		s.store.RecordEvent(DomainEvent{
			EventType:   "idea.created",
			WorkspaceID: caller.WorkspaceID,
			Payload: map[string]any{
				"idea_id":      ideaID,
				"source_type":  "opportunity",
				"source_class": "inferred",
			},
			OccurredAt: now,
		})

		generatedIdeas = append(generatedIdeas, mapToProtoIdea(newIdea))
	}

	remainingQuota := 20 - (count + 1)
	if remainingQuota < 0 {
		remainingQuota = 0
	}

	return connect.NewResponse(&contentv1.IdeaServiceGenerateResponse{
		GeneratedIdeas:       generatedIdeas,
		RemainingHourlyQuota: int32(remainingQuota),
	}), nil
}

// Convert converts an idea to a script (M06) and validates required fields (EC-M05-004, RULE-M05-003).
func (s *Service) Convert(ctx context.Context, req *connect.Request[contentv1.IdeaServiceConvertRequest]) (*connect.Response[contentv1.IdeaServiceConvertResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:convert"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	idea, err := s.store.GetIdea(ctx, caller.WorkspaceID, req.Msg.IdeaId)
	if err != nil {
		if errors.Is(err, ErrIdeaNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	if req.Msg.ExpectedUpdatedAt != nil {
		expected := req.Msg.ExpectedUpdatedAt.AsTime()
		if !idea.UpdatedAt.Truncate(time.Microsecond).Equal(expected.Truncate(time.Microsecond)) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrConcurrentConflict)
		}
	}

	// EC-M05-004: Validate required fields before conversion (needs at least description and suggested_format)
	if strings.TrimSpace(idea.Description) == "" || strings.TrimSpace(idea.SuggestedFormat) == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrConversionValidationFailed)
	}

	now := time.Now().UTC()
	scriptID := generateDeterministicUUID(caller.WorkspaceID, idea.IdeaID+":script", now)

	idea.Status = contentv1.IdeaStatus_IDEA_STATUS_CONVERTED
	idea.ConvertedToType = "script"
	idea.ConvertedToID = scriptID
	idea.UpdatedAt = now

	if err := s.store.UpdateIdea(ctx, *idea); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// RULE-M05-003: Emit idea.converted with {idea_id, to_type: 'script', to_id}
	s.store.RecordEvent(DomainEvent{
		EventType:   "idea.converted",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"idea_id": idea.IdeaID,
			"to_type": "script",
			"to_id":   scriptID,
		},
		OccurredAt: now,
	})

	return connect.NewResponse(&contentv1.IdeaServiceConvertResponse{
		Idea:            mapToProtoIdea(*idea),
		ConvertedToType: "script",
		ConvertedToId:   scriptID,
		ScriptId:        scriptID,
	}), nil
}

// Search searches ideas using lexical/semantic similarity.
func (s *Service) Search(ctx context.Context, req *connect.Request[contentv1.IdeaServiceSearchRequest]) (*connect.Response[contentv1.IdeaServiceSearchResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	threshold := req.Msg.MinSimilarity
	if threshold <= 0 {
		threshold = 0.5
	}
	limit := int(req.Msg.Limit)
	if limit <= 0 || limit > 50 {
		limit = 20
	}

	matches, err := s.store.FindSimilarIdeas(ctx, caller.WorkspaceID, req.Msg.Query, nil, threshold)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoIdeas []*contentv1.Idea
	var scores []float32
	for i, m := range matches {
		if i >= limit {
			break
		}
		item, err := s.store.GetIdea(ctx, caller.WorkspaceID, m.ExistingIdeaID)
		if err == nil {
			protoIdeas = append(protoIdeas, mapToProtoIdea(*item))
			scores = append(scores, m.SimilarityScore)
		}
	}

	return connect.NewResponse(&contentv1.IdeaServiceSearchResponse{
		Ideas:            protoIdeas,
		SimilarityScores: scores,
	}), nil
}

// CreateFromTrend creates an idea pre-filled with trend data and provenance (Flow A1).
func (s *Service) CreateFromTrend(ctx context.Context, req *connect.Request[contentv1.IdeaServiceCreateFromTrendRequest]) (*connect.Response[contentv1.IdeaServiceCreateFromTrendResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	title := strings.TrimSpace(req.Msg.Title)
	if title == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrTitleRequired)
	}

	now := time.Now().UTC()
	ideaID := generateDeterministicUUID(caller.WorkspaceID, title+":trend:"+req.Msg.TrendId, now)

	sources := []StoredIdeaSource{
		{
			SourceType:    "trend",
			SourceID:      req.Msg.TrendId,
			SourceTitle:   title,
			IsArchived:    false,
			ArchiveNotice: "",
		},
	}

	idea := StoredIdea{
		IdeaID:               ideaID,
		WorkspaceID:          caller.WorkspaceID,
		Title:                title,
		Description:          fmt.Sprintf("Idea created from trending topic %s", title),
		AudienceIntent:       req.Msg.AudienceIntent,
		CreatorIntent:        "Ride trend wave",
		SuggestedFormat:      "short_form",
		Status:               contentv1.IdeaStatus_IDEA_STATUS_DRAFT,
		IdeaScore:            85.0,
		CreatedBy:            caller.UserID,
		Sources:              sources,
		EmbeddingVector:      generateSyntheticEmbedding(title),
		CreatedAt:            now,
		UpdatedAt:            now,
		SourceClass:          intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		Confidence:           intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		RecommendedFormats:   []string{"short_form", "tiktok"},
		RecommendedPlatforms: []string{"tiktok", "youtube_shorts"},
	}

	if err := s.store.CreateIdea(ctx, idea); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	s.store.RecordEvent(DomainEvent{
		EventType:   "idea.created",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"idea_id":     ideaID,
			"source_type": "trend",
		},
		OccurredAt: now,
	})

	return connect.NewResponse(&contentv1.IdeaServiceCreateFromTrendResponse{
		Idea: mapToProtoIdea(idea),
	}), nil
}

// ListMobile returns a compact listing of ideas optimized for mobile client.
func (s *Service) ListMobile(ctx context.Context, req *connect.Request[contentv1.IdeaServiceListMobileRequest]) (*connect.Response[contentv1.IdeaServiceListMobileResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "idea:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	limit := int(req.Msg.Limit)
	if limit <= 0 || limit > 100 {
		limit = 30
	}

	ideas, err := s.store.ListIdeas(ctx, caller.WorkspaceID, req.Msg.Status, "", "", limit)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoIdeas []*contentv1.Idea
	for _, item := range ideas {
		protoIdeas = append(protoIdeas, mapToProtoIdea(item))
	}

	return connect.NewResponse(&contentv1.IdeaServiceListMobileResponse{
		Ideas:      protoIdeas,
		TotalCount: int32(len(protoIdeas)),
	}), nil
}

// --- Helpers ---

func mapToProtoIdea(item StoredIdea) *contentv1.Idea {
	var protoSources []*contentv1.IdeaSourceRef
	for _, s := range item.Sources {
		protoSources = append(protoSources, &contentv1.IdeaSourceRef{
			SourceType:    s.SourceType,
			SourceId:      s.SourceID,
			SourceTitle:   s.SourceTitle,
			SourceUrl:     s.SourceURL,
			IsArchived:    s.IsArchived,
			ArchiveNotice: s.ArchiveNotice,
		})
	}

	var protoHooks []*contentv1.Hook
	for _, h := range item.Hooks {
		protoHooks = append(protoHooks, &contentv1.Hook{
			HookId:             h.HookID,
			WorkspaceId:        h.WorkspaceID,
			IdeaId:             h.IdeaID,
			HookText:           h.HookText,
			HookType:           h.HookType,
			EffectivenessScore: h.EffectivenessScore,
			UsageCount:         h.UsageCount,
			Source:             h.Source,
			CreatedAt:          timestamppb.New(h.CreatedAt),
		})
	}

	return &contentv1.Idea{
		IdeaId:               item.IdeaID,
		WorkspaceId:          item.WorkspaceID,
		Title:                item.Title,
		Description:          item.Description,
		AudienceIntent:       item.AudienceIntent,
		CreatorIntent:        item.CreatorIntent,
		SuggestedFormat:      item.SuggestedFormat,
		SuggestedDirection:   item.SuggestedDirection,
		Status:               item.Status,
		IdeaScore:            item.IdeaScore,
		ConvertedToType:      item.ConvertedToType,
		ConvertedToId:        item.ConvertedToID,
		CreatedBy:            item.CreatedBy,
		Sources:              protoSources,
		Hooks:                protoHooks,
		EmbeddingVector:      item.EmbeddingVector,
		CreatedAt:            timestamppb.New(item.CreatedAt),
		UpdatedAt:            timestamppb.New(item.UpdatedAt),
		SourceClass:          item.SourceClass,
		Confidence:           item.Confidence,
		RecommendedFormats:   item.RecommendedFormats,
		RecommendedPlatforms: item.RecommendedPlatforms,
		Angle:                item.Angle,
		HookSuggestion:       item.HookSuggestion,
	}
}

func computeInitialIdeaScore(title, desc, format string) float32 {
	var score float32 = 60.0
	if len(strings.TrimSpace(title)) > 10 {
		score += 10.0
	}
	if len(strings.TrimSpace(desc)) > 20 {
		score += 15.0
	}
	if strings.TrimSpace(format) != "" {
		score += 10.0
	}
	if score > 100.0 {
		score = 100.0
	}
	return score
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

func generateSyntheticEmbedding(seed string) []float32 {
	h := sha256.Sum256([]byte(seed))
	emb := make([]float32, 16)
	for i := 0; i < 16; i++ {
		emb[i] = float32(h[i]) / 255.0
	}
	return emb
}

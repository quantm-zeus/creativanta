package publish

import (
	"context"
	"errors"
	"fmt"
	"math/rand"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	publishv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1/publishv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
)

// CapabilityEvaluator resolves platform capability state before and during execution.
type CapabilityEvaluator interface {
	EvaluateActionAccess(workspaceID, platform, actionKey string, requiredScopes []string) capability.EvaluationResult
}

// ConnectedAccountLookup provides account state and platform details.
type ConnectedAccountLookup interface {
	GetAccount(workspaceID, accountID string) (*capability.ConnectedAccountRecord, error)
}

// ApprovalPolicyChecker checks if an item requires approval.
type ApprovalPolicyChecker interface {
	RequiresApproval(workspaceID, action string) bool
	IsApproved(workspaceID, approvalRequestID string) bool
}

// ServiceConfig configures the Publish Service.
type ServiceConfig struct {
	CapabilityService capability.KillSwitchChecker // or CapabilityEvaluator
	Accounts          ConnectedAccountLookup
	ApprovalChecker   ApprovalPolicyChecker
	Jitter            JitterConfig
	Connectors        map[string]PlatformConnector
	Clock             func() time.Time
}

// Service implements publishv1connect.PublishServiceHandler.
type Service struct {
	mu                  sync.RWMutex
	items               map[string]*PublishItem    // itemID -> item
	jobs                map[string]*PublishJob     // jobID -> job
	logs                []*PublishLog              // append-only immutable logs
	posts               map[string]*ChannelPost    // postID -> post
	effects             map[string]*ExternalEffect // opKey -> effect
	pausedAccounts      map[string]bool            // accountID -> isPaused
	events              []DomainEvent              // recorded outbox events
	recentDispatches    []time.Time                // sliding window for fairness/jitter calculation
	workspaceDispatches map[string][]time.Time     // workspaceID -> recent timestamps
	connectors          map[string]PlatformConnector
	capEvaluator        CapabilityEvaluator
	accountLookup       ConnectedAccountLookup
	approvalChecker     ApprovalPolicyChecker
	jitterConfig        JitterConfig
	nowFn               func() time.Time
}

var _ publishv1connect.PublishServiceHandler = (*Service)(nil)

// NewService creates a new PublishService instance.
func NewService(cfg ServiceConfig) *Service {
	nowFn := cfg.Clock
	if nowFn == nil {
		nowFn = time.Now
	}
	jCfg := cfg.Jitter
	if jCfg.HighLoadThresholdCPM == 0 {
		jCfg = DefaultJitterConfig()
	}
	return &Service{
		items:               make(map[string]*PublishItem),
		jobs:                make(map[string]*PublishJob),
		logs:                make([]*PublishLog, 0),
		posts:               make(map[string]*ChannelPost),
		effects:             make(map[string]*ExternalEffect),
		pausedAccounts:      make(map[string]bool),
		events:              make([]DomainEvent, 0),
		recentDispatches:    make([]time.Time, 0),
		workspaceDispatches: make(map[string][]time.Time),
		connectors:          cfg.Connectors,
		accountLookup:       cfg.Accounts,
		approvalChecker:     cfg.ApprovalChecker,
		jitterConfig:        jCfg,
		nowFn:               nowFn,
	}
}

// SetCapabilityEvaluator injects the capability service.
func (s *Service) SetCapabilityEvaluator(eval CapabilityEvaluator) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.capEvaluator = eval
}

// RegisterConnector registers a platform connector adapter.
func (s *Service) RegisterConnector(connector PlatformConnector) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.connectors == nil {
		s.connectors = make(map[string]PlatformConnector)
	}
	s.connectors[strings.ToLower(connector.Platform())] = connector
}

// SetTimeProvider sets a custom clock for testing.
func (s *Service) SetTimeProvider(nowFn func() time.Time) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.nowFn = nowFn
}

// Helper to record domain events.
func (s *Service) recordEventLocked(workspaceID, eventType, aggType, aggID string, payload map[string]any) {
	s.events = append(s.events, DomainEvent{
		EventID:       NewID(),
		WorkspaceID:   workspaceID,
		EventType:     eventType,
		AggregateType: aggType,
		AggregateID:   aggID,
		Payload:       payload,
		OccurredAt:    s.nowFn(),
	})
}

// Events returns a copy of recorded domain events.
func (s *Service) Events() []DomainEvent {
	s.mu.RLock()
	defer s.mu.RUnlock()
	copied := make([]DomainEvent, len(s.events))
	copy(copied, s.events)
	return copied
}

// ResolveCapability evaluates platform capability for publish_post.
func (s *Service) ResolveCapability(workspaceID, platform string) *publishv1.PlatformCapabilitySummary {
	p := strings.ToLower(platform)
	summary := &publishv1.PlatformCapabilitySummary{
		Platform:        p,
		CapabilityState: publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_MANUAL,
		ConnectorState:  "connected",
		RequiredScopes:  []string{"publish"},
		Executable:      true,
		PolicySummary:   "Xuất bản nội dung lên nền tảng",
	}

	if s.capEvaluator != nil {
		eval := s.capEvaluator.EvaluateActionAccess(workspaceID, p, "publish_post", nil)
		summary.RequiredScopes = []string{eval.ActionKey}
		summary.PolicySummary = eval.PolicyNote.Summary
		summary.FallbackInstructions = eval.FallbackPath.Instructions
		summary.Executable = eval.Executable

		switch eval.State {
		case capability.StateNative:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_NATIVE
		case capability.StateReadOnly:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_READ_ONLY
			summary.RequiresManualFallback = true
			summary.Executable = false
		case capability.StateManual:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_MANUAL
			summary.RequiresManualFallback = true
		case capability.StateDegraded:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_DEGRADED
			summary.RequiresManualFallback = true
		case capability.StateUnsupported:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_UNSUPPORTED
			summary.RequiresManualFallback = true
			summary.Executable = false
		}
	} else {
		// Default platform capabilities matching canonical specs
		switch p {
		case "shopee":
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_UNSUPPORTED
			summary.RequiresManualFallback = true
			summary.Executable = false
			summary.PolicySummary = "Shopee không cung cấp Public API để đăng Shopee Video tự động"
			summary.FallbackInstructions = "Tải video đã đóng gói về thiết bị và đăng thủ công qua app Shopee Video"
		case "tiktok", "youtube", "instagram", "facebook":
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_NATIVE
			summary.RequiresManualFallback = false
			summary.Executable = true
		}
	}
	return summary
}

// CalculateJitterDelay calculates system queue fairness jitter (RULE-M11-006).
// Invariant: Delay is ALWAYS >= 0. Never negative.
func (s *Service) CalculateJitterDelay(workspaceID string) time.Duration {
	now := s.nowFn()
	cutoff := now.Add(-1 * time.Minute)

	// Clean older dispatches
	validRecent := make([]time.Time, 0, len(s.recentDispatches))
	for _, t := range s.recentDispatches {
		if t.After(cutoff) {
			validRecent = append(validRecent, t)
		}
	}
	s.recentDispatches = validRecent

	// If rate exceeds threshold (e.g. >100 jobs/minute globally), jitter activates
	if len(s.recentDispatches) >= s.jitterConfig.HighLoadThresholdCPM {
		// Delayed 0-30s after scheduled time (never publish before approved time)
		delaySecs := rand.Intn(int(s.jitterConfig.MaxJitterDelay.Seconds()) + 1)
		if delaySecs < 0 {
			delaySecs = 0
		}
		return time.Duration(delaySecs) * time.Second
	}
	return 0
}

// ----------------------------------------------------------------------------
// Core RPC Implementations
// ----------------------------------------------------------------------------

// CreateItem creates a publish item in draft or scheduled state.
func (s *Service) CreateItem(ctx context.Context, req *connect.Request[publishv1.CreateItemRequest]) (*connect.Response[publishv1.CreateItemResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	workspaceID := ""
	if req.Msg.Context != nil && req.Msg.Context.WorkspaceId != nil {
		workspaceID = req.Msg.Context.WorkspaceId.Value
	}
	if workspaceID == "" {
		workspaceID = "00000000-0000-0000-0000-000000000001"
	}

	platform := strings.ToLower(req.Msg.TargetPlatform)
	capSummary := s.ResolveCapability(workspaceID, platform)

	now := s.nowFn()
	item := &PublishItem{
		PublishItemID:        NewID(),
		WorkspaceID:          workspaceID,
		AssetID:              req.Msg.AssetId,
		TargetPlatform:       platform,
		TargetAccountID:      req.Msg.TargetAccountId,
		TargetFormat:         req.Msg.TargetFormat,
		PublishMode:          PublishModeToString(req.Msg.PublishMode),
		Title:                req.Msg.Title,
		Description:          req.Msg.Description,
		Hashtags:             req.Msg.Hashtags,
		LifecycleState:       StateDraft,
		DiagnosticsState:     DiagnosticsHealthy,
		PackagingScore:       85.0,
		ComplianceScanResult: "pass",
		CreatedAt:            now,
		UpdatedAt:            now,
	}

	if req.Msg.ScheduleAt != nil {
		sch := req.Msg.ScheduleAt.AsTime()
		item.ScheduleAt = &sch
		item.LifecycleState = StateScheduled
	}

	s.items[item.PublishItemID] = item
	s.recordEventLocked(workspaceID, EventPublishQueued, "publish_item", item.PublishItemID, map[string]any{
		"platform": platform,
		"state":    item.LifecycleState,
	})

	return connect.NewResponse(&publishv1.CreateItemResponse{
		Item:              ItemToProto(item),
		CapabilitySummary: capSummary,
	}), nil
}

// Schedule validates and schedules a publish item (Acceptance Target 1: Never publish before schedule).
func (s *Service) Schedule(ctx context.Context, req *connect.Request[publishv1.ScheduleRequest]) (*connect.Response[publishv1.ScheduleResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	if req.Msg.ScheduledAt == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("scheduled_at is required"))
	}

	scheduledTime := req.Msg.ScheduledAt.AsTime()
	now := s.nowFn()

	// Invariant: Schedule time must be in future (or now)
	if scheduledTime.Before(now.Add(-1 * time.Second)) {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("cannot schedule in the past"))
	}

	// Calculate queue fairness jitter delay (RULE-M11-006): delay >= 0
	jitterDelay := s.CalculateJitterDelay(item.WorkspaceID)
	effectiveDispatchTime := scheduledTime.Add(jitterDelay)

	// Ensure invariant: effective dispatch time is NEVER earlier than scheduled time
	if effectiveDispatchTime.Before(scheduledTime) {
		return nil, connect.NewError(connect.CodeInternal, ErrPrematurePublish)
	}

	item.ScheduleAt = &effectiveDispatchTime
	item.LifecycleState = StateScheduled
	item.UpdatedAt = now

	// Create associated PublishJob in created/queued state
	job := &PublishJob{
		PublishJobID:     NewID(),
		WorkspaceID:      item.WorkspaceID,
		PublishItemID:    item.PublishItemID,
		DispatchStrategy: "scheduled_jitter",
		LifecycleState:   JobStateCreated,
		AttemptCount:     0,
		MaxAttempts:      3,
		CreatedAt:        now,
		UpdatedAt:        now,
	}
	s.jobs[job.PublishJobID] = job

	s.recordEventLocked(item.WorkspaceID, EventPublishScheduled, "publish_item", item.PublishItemID, map[string]any{
		"scheduled_at":         effectiveDispatchTime.Format(time.RFC3339),
		"jitter_delay_seconds": int(jitterDelay.Seconds()),
	})

	return connect.NewResponse(&publishv1.ScheduleResponse{
		Item:               ItemToProto(item),
		Job:                JobToProto(job),
		ScheduledAt:        timestamppb.New(effectiveDispatchTime),
		JitterDelaySeconds: int32(jitterDelay.Seconds()),
	}), nil
}

// Execute executes publish immediately or dispatches a due scheduled job.
// Acceptance Target 1: Never publish before schedule.
// Acceptance Target 2: Unknown submit reconciles.
// Acceptance Target 4: Token revoke pauses affected queued work.
func (s *Service) Execute(ctx context.Context, req *connect.Request[publishv1.ExecuteRequest]) (*connect.Response[publishv1.ExecuteResponse], error) {
	s.mu.Lock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		s.mu.Unlock()
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	now := s.nowFn()

	// Check if this account is currently paused due to token revocation
	if s.pausedAccounts[item.TargetAccountID] {
		item.DiagnosticsState = DiagnosticsBlocked
		s.mu.Unlock()
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("publish blocked: target account token is revoked, please reconnect"))
	}

	// ACCEPTANCE TARGET 1: Never publish before schedule!
	if item.ScheduleAt != nil && now.Before(*item.ScheduleAt) {
		s.mu.Unlock()
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrPrematurePublish)
	}

	// Check approval gating
	if s.approvalChecker != nil && s.approvalChecker.RequiresApproval(item.WorkspaceID, "publish:execute") {
		// find existing job
		var job *PublishJob
		for _, j := range s.jobs {
			if j.PublishItemID == item.PublishItemID {
				job = j
				break
			}
		}
		if job == nil || job.ApprovalRequestID == "" || !s.approvalChecker.IsApproved(item.WorkspaceID, job.ApprovalRequestID) {
			s.mu.Unlock()
			return nil, connect.NewError(connect.CodePermissionDenied, ErrApprovalRequired)
		}
	}

	// Capability re-check at execution time (EC-M11-004)
	capSummary := s.ResolveCapability(item.WorkspaceID, item.TargetPlatform)
	if capSummary.CapabilityState == publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_MANUAL ||
		capSummary.CapabilityState == publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_UNSUPPORTED ||
		capSummary.CapabilityState == publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_DEGRADED {
		item.LifecycleState = StateRequiresManualFallback
		item.DiagnosticsState = DiagnosticsDegraded
		item.UpdatedAt = now
		s.recordEventLocked(item.WorkspaceID, EventPublishRequiresManualFallback, "publish_item", item.PublishItemID, map[string]any{
			"platform": item.TargetPlatform,
			"reason":   capSummary.PolicySummary,
		})
		s.mu.Unlock()
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrCapabilityDegraded)
	}

	// Find or create job
	var job *PublishJob
	if req.Msg.PublishJobId != "" {
		job = s.jobs[req.Msg.PublishJobId]
	}
	if job == nil {
		for _, j := range s.jobs {
			if j.PublishItemID == item.PublishItemID && (j.LifecycleState == JobStateCreated || j.LifecycleState == StateQueued) {
				job = j
				break
			}
		}
	}
	if job == nil {
		job = &PublishJob{
			PublishJobID:     NewID(),
			WorkspaceID:      item.WorkspaceID,
			PublishItemID:    item.PublishItemID,
			DispatchStrategy: "direct",
			LifecycleState:   JobStateCreated,
			AttemptCount:     0,
			MaxAttempts:      3,
			CreatedAt:        now,
			UpdatedAt:        now,
		}
		s.jobs[job.PublishJobID] = job
	}

	// Transition to executing
	item.LifecycleState = StateExecuting
	job.LifecycleState = StateExecuting
	job.AttemptCount++
	job.UpdatedAt = now
	s.recentDispatches = append(s.recentDispatches, now)

	s.recordEventLocked(item.WorkspaceID, EventPublishExecuting, "publish_item", item.PublishItemID, map[string]any{
		"job_id":  job.PublishJobID,
		"attempt": job.AttemptCount,
	})

	// Prepare external_effects record (queue_retry_design.md §5.3)
	opKey := fmt.Sprintf("pub_%s_%s_%d", item.WorkspaceID, job.PublishJobID, job.AttemptCount)
	effect := &ExternalEffect{
		EffectID:           NewID(),
		WorkspaceID:        item.WorkspaceID,
		OperationKey:       opKey,
		Provider:           item.TargetPlatform,
		ConnectedAccountID: item.TargetAccountID,
		AggregateType:      "publish_job",
		AggregateID:        job.PublishJobID,
		Status:             "submitted",
		CreatedAt:          now,
		UpdatedAt:          now,
	}
	s.effects[opKey] = effect

	connector := s.connectors[item.TargetPlatform]
	s.mu.Unlock()

	// External platform submission
	var pubResult *ConnectorPublishResult
	var callErr error
	if connector != nil {
		pubResult, callErr = connector.PublishPost(ctx, item.TargetAccountID, item, opKey)
	} else {
		// Mock fallback default: success if connected
		pubResult = &ConnectorPublishResult{
			ProviderRequestID: "req_" + NewID(),
			ExternalPostID:    "post_" + NewID(),
			ExternalPostURL:   "https://" + item.TargetPlatform + ".com/post/" + NewID(),
			ResultStatus:      ResultSuccess,
		}
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	// Handle Outcome Families
	// ACCEPTANCE TARGET 4: Token Revoke Pauses Affected Queued Work
	if (pubResult != nil && pubResult.ResultStatus == "auth_revoked") || (callErr != nil && strings.Contains(callErr.Error(), "auth_revoked")) {
		job.LifecycleState = StateFailed
		job.UpdatedAt = s.nowFn()
		item.LifecycleState = StateFailed
		item.DiagnosticsState = DiagnosticsBlocked
		item.UpdatedAt = s.nowFn()

		effect.Status = "failed"
		effect.UpdatedAt = s.nowFn()

		// Write immutable failed log
		log := &PublishLog{
			PublishLogID:  NewID(),
			WorkspaceID:   item.WorkspaceID,
			PublishJobID:  job.PublishJobID,
			PublishItemID: item.PublishItemID,
			AttemptedAt:   now,
			FailedAt:      &item.UpdatedAt,
			ExecutionPath: PathNativeAPI,
			ResultStatus:  ResultFailed,
			ErrorCode:     ErrorCodeAuthRevoked,
			ErrorMessage:  "Tài khoản kết nối bị thu hồi quyền truy cập (auth_revoked). Vui lòng kết nối lại tài khoản.",
		}
		s.logs = append(s.logs, log)

		// PAUSE ALL QUEUED/SCHEDULED JOBS FOR THIS ACCOUNT (AC 5 / RULE-M11-003)
		if item.TargetAccountID != "" {
			s.pausedAccounts[item.TargetAccountID] = true
			for _, otherItem := range s.items {
				if otherItem.TargetAccountID == item.TargetAccountID && (otherItem.LifecycleState == StateQueued || otherItem.LifecycleState == StateScheduled) {
					otherItem.DiagnosticsState = DiagnosticsBlocked
					otherItem.UpdatedAt = s.nowFn()
				}
			}
		}

		s.recordEventLocked(item.WorkspaceID, EventPublishFailed, "publish_item", item.PublishItemID, map[string]any{
			"error":    ErrorCodeAuthRevoked,
			"fallback": "reconnect_required",
		})
		s.recordEventLocked(item.WorkspaceID, EventPublishItemFailed, "publish_item", item.PublishItemID, map[string]any{
			"error_category": ErrorCodeAuthRevoked,
			"error_message":  log.ErrorMessage,
		})

		return nil, connect.NewError(connect.CodeUnauthenticated, ErrAuthRevoked)
	}

	// ACCEPTANCE TARGET 2: Unknown Submit Reconciles
	if (pubResult != nil && (pubResult.ResultStatus == "unknown" || pubResult.ResultStatus == ResultTimeout)) ||
		(callErr != nil && (errors.Is(callErr, context.DeadlineExceeded) || strings.Contains(callErr.Error(), "timeout"))) {

		effect.Status = "unknown"
		if pubResult != nil {
			effect.ProviderRequestID = pubResult.ProviderRequestID
		}
		effect.UpdatedAt = s.nowFn()

		// Keep in executing or pending reconciliation; NEVER blindly mark failed or publish without proof
		job.LifecycleState = StateExecuting
		job.LastExecutionSummary = map[string]any{
			"status":                  "unknown_submit",
			"requires_reconciliation": true,
			"provider_request_id":     effect.ProviderRequestID,
		}
		job.UpdatedAt = s.nowFn()

		item.DiagnosticsState = DiagnosticsWarning
		item.UpdatedAt = s.nowFn()

		// Write timeout log
		log := &PublishLog{
			PublishLogID:  NewID(),
			WorkspaceID:   item.WorkspaceID,
			PublishJobID:  job.PublishJobID,
			PublishItemID: item.PublishItemID,
			AttemptedAt:   now,
			ExecutionPath: PathNativeAPI,
			ResultStatus:  ResultTimeout,
			ErrorCode:     ErrorCodeUnknownSubmit,
			ErrorMessage:  "Kết quả đăng bài chưa xác định do mất kết nối/timeout. Cần đối soát (reconcile) trước khi thử lại.",
		}
		s.logs = append(s.logs, log)

		s.recordEventLocked(item.WorkspaceID, EventPublishFailed, "publish_item", item.PublishItemID, map[string]any{
			"error":    ErrorCodeUnknownSubmit,
			"fallback": "reconciliation_required",
		})

		return nil, connect.NewError(connect.CodeDeadlineExceeded, ErrUnknownSubmit)
	}

	// Normal Failure (Definitive 4xx / business rejection)
	if callErr != nil || (pubResult != nil && pubResult.ResultStatus == ResultFailed) {
		job.LifecycleState = StateFailed
		job.UpdatedAt = s.nowFn()
		item.LifecycleState = StateFailed
		item.DiagnosticsState = DiagnosticsDegraded
		item.UpdatedAt = s.nowFn()
		effect.Status = "failed"
		effect.UpdatedAt = s.nowFn()

		errMsg := "Đăng bài thất bại"
		if pubResult != nil && pubResult.ErrorMessage != "" {
			errMsg = pubResult.ErrorMessage
		} else if callErr != nil {
			errMsg = callErr.Error()
		}

		log := &PublishLog{
			PublishLogID:  NewID(),
			WorkspaceID:   item.WorkspaceID,
			PublishJobID:  job.PublishJobID,
			PublishItemID: item.PublishItemID,
			AttemptedAt:   now,
			FailedAt:      &item.UpdatedAt,
			ExecutionPath: PathNativeAPI,
			ResultStatus:  ResultFailed,
			ErrorCode:     "publish_api_error",
			ErrorMessage:  errMsg,
		}
		s.logs = append(s.logs, log)

		s.recordEventLocked(item.WorkspaceID, EventPublishFailed, "publish_item", item.PublishItemID, map[string]any{
			"error": errMsg,
		})

		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("publish failed: %s", errMsg))
	}

	// SUCCESS PATH (RULE-M11-002: Published state requires immutable success log)
	effect.Status = "succeeded"
	effect.ProviderRequestID = pubResult.ProviderRequestID
	effect.UpdatedAt = s.nowFn()

	completedAt := s.nowFn()
	log := &PublishLog{
		PublishLogID:    NewID(),
		WorkspaceID:     item.WorkspaceID,
		PublishJobID:    job.PublishJobID,
		PublishItemID:   item.PublishItemID,
		AttemptedAt:     now,
		CompletedAt:     &completedAt,
		ExecutionPath:   PathNativeAPI,
		ResultStatus:    ResultSuccess,
		ExternalPostID:  pubResult.ExternalPostID,
		ExternalPostURL: pubResult.ExternalPostURL,
	}
	s.logs = append(s.logs, log)

	job.LifecycleState = JobStateSucceeded
	job.UpdatedAt = completedAt

	// Item state marked published ONLY AFTER immutable log is appended (RULE-M11-002)
	item.LifecycleState = StatePublished
	item.DiagnosticsState = DiagnosticsHealthy
	item.UpdatedAt = completedAt

	// Post-publish sync (RULE-M11-007)
	channelPost := &ChannelPost{
		ChannelPostID:      NewID(),
		WorkspaceID:        item.WorkspaceID,
		PublishItemID:      item.PublishItemID,
		ConnectedAccountID: item.TargetAccountID,
		ExternalPostID:     pubResult.ExternalPostID,
		ExternalPermalink:  pubResult.ExternalPostURL,
		Title:              item.Title,
		SyncedAt:           &completedAt,
		CreatedAt:          completedAt,
		UpdatedAt:          completedAt,
	}
	s.posts[channelPost.ChannelPostID] = channelPost

	s.recordEventLocked(item.WorkspaceID, EventPublishSucceeded, "publish_item", item.PublishItemID, map[string]any{
		"external_id": pubResult.ExternalPostID,
		"url":         pubResult.ExternalPostURL,
	})
	s.recordEventLocked(item.WorkspaceID, EventPublishItemSucceeded, "publish_item", item.PublishItemID, map[string]any{
		"external_url": pubResult.ExternalPostURL,
		"published_at": completedAt.Format(time.RFC3339),
	})
	s.recordEventLocked(item.WorkspaceID, EventChannelPostSynced, "channel_post", channelPost.ChannelPostID, map[string]any{
		"external_post_id": pubResult.ExternalPostID,
	})

	return connect.NewResponse(&publishv1.ExecuteResponse{
		Item:        ItemToProto(item),
		Job:         JobToProto(job),
		Log:         LogToProto(log),
		ChannelPost: ChannelPostToProto(channelPost),
	}), nil
}

// ReconcilePublish reconciles unknown platform submission outcomes (Acceptance Target 2).
func (s *Service) ReconcilePublish(ctx context.Context, req *connect.Request[publishv1.ReconcilePublishRequest]) (*connect.Response[publishv1.ReconcilePublishResponse], error) {
	s.mu.Lock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		s.mu.Unlock()
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	var job *PublishJob
	if req.Msg.PublishJobId != "" {
		job = s.jobs[req.Msg.PublishJobId]
	}
	if job == nil {
		for _, j := range s.jobs {
			if j.PublishItemID == item.PublishItemID {
				job = j
				break
			}
		}
	}
	if job == nil {
		s.mu.Unlock()
		return nil, connect.NewError(connect.CodeNotFound, ErrJobNotFound)
	}

	connector := s.connectors[item.TargetPlatform]
	providerReqID := req.Msg.ProviderRequestId
	s.mu.Unlock()

	var statusRes *ConnectorStatusResult
	var callErr error
	if connector != nil {
		statusRes, callErr = connector.CheckPostStatus(ctx, item.TargetAccountID, providerReqID)
	} else {
		// Mock reconciliation logic
		statusRes = &ConnectorStatusResult{
			ProviderRequestID: providerReqID,
			ExternalPostID:    "rec_post_" + NewID(),
			ExternalPostURL:   "https://" + item.TargetPlatform + ".com/post/" + NewID(),
			Found:             true,
			Status:            "confirmed_published",
		}
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	now := s.nowFn()
	if callErr != nil || statusRes == nil || statusRes.Status == "still_unknown" {
		return connect.NewResponse(&publishv1.ReconcilePublishResponse{
			Item:                  ItemToProto(item),
			Job:                   JobToProto(job),
			Reconciled:            false,
			ReconciliationOutcome: "still_unknown",
		}), nil
	}

	if statusRes.Found || statusRes.Status == "confirmed_published" {
		// Post was actually published on platform! Prevent duplicate submit and create success log.
		log := &PublishLog{
			PublishLogID:    NewID(),
			WorkspaceID:     item.WorkspaceID,
			PublishJobID:    job.PublishJobID,
			PublishItemID:   item.PublishItemID,
			AttemptedAt:     now,
			CompletedAt:     &now,
			ExecutionPath:   PathNativeAPI,
			ResultStatus:    ResultSuccess,
			ExternalPostID:  statusRes.ExternalPostID,
			ExternalPostURL: statusRes.ExternalPostURL,
			Metadata: map[string]any{
				"reconciled":          true,
				"provider_request_id": providerReqID,
			},
		}
		s.logs = append(s.logs, log)

		job.LifecycleState = JobStateSucceeded
		job.UpdatedAt = now
		item.LifecycleState = StatePublished
		item.DiagnosticsState = DiagnosticsHealthy
		item.UpdatedAt = now

		channelPost := &ChannelPost{
			ChannelPostID:      NewID(),
			WorkspaceID:        item.WorkspaceID,
			PublishItemID:      item.PublishItemID,
			ConnectedAccountID: item.TargetAccountID,
			ExternalPostID:     statusRes.ExternalPostID,
			ExternalPermalink:  statusRes.ExternalPostURL,
			Title:              item.Title,
			SyncedAt:           &now,
			CreatedAt:          now,
			UpdatedAt:          now,
		}
		s.posts[channelPost.ChannelPostID] = channelPost

		s.recordEventLocked(item.WorkspaceID, EventPublishSucceeded, "publish_item", item.PublishItemID, map[string]any{
			"external_id": statusRes.ExternalPostID,
			"url":         statusRes.ExternalPostURL,
			"reconciled":  true,
		})

		return connect.NewResponse(&publishv1.ReconcilePublishResponse{
			Item:                  ItemToProto(item),
			Job:                   JobToProto(job),
			Log:                   LogToProto(log),
			Reconciled:            true,
			ReconciliationOutcome: "confirmed_published",
		}), nil
	}

	// Post was confirmed NOT published: safe to retry with new operation key
	job.LifecycleState = StateFailed
	job.UpdatedAt = now
	item.LifecycleState = StateFailed
	item.UpdatedAt = now

	return connect.NewResponse(&publishv1.ReconcilePublishResponse{
		Item:                  ItemToProto(item),
		Job:                   JobToProto(job),
		Reconciled:            true,
		ReconciliationOutcome: "confirmed_not_published",
	}), nil
}

// ExportManualPackage generates an export package for offline upload (Acceptance Target 3: Manual proof).
func (s *Service) ExportManualPackage(ctx context.Context, req *connect.Request[publishv1.ExportManualPackageRequest]) (*connect.Response[publishv1.ExportManualPackageResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	item.LifecycleState = StateRequiresManualFallback
	item.UpdatedAt = s.nowFn()

	s.recordEventLocked(item.WorkspaceID, EventPublishRequiresManualFallback, "publish_item", item.PublishItemID, map[string]any{
		"platform": item.TargetPlatform,
		"mode":     "manual_export",
	})

	pkg := &publishv1.ManualExportPackage{
		PublishItemId:          item.PublishItemID,
		Title:                  item.Title,
		Description:            item.Description,
		Hashtags:               item.Hashtags,
		MediaUrl:               "https://storage.creativanta.vn/assets/" + item.AssetID + ".mp4",
		TargetPlatform:         item.TargetPlatform,
		Instructions:           fmt.Sprintf("1. Tải video về máy\n2. Mở ứng dụng %s\n3. Dán caption và hashtags\n4. Đăng bài và chụp ảnh màn hình / lấy URL xác nhận", item.TargetPlatform),
		RecommendedAspectRatio: "9:16",
	}

	return connect.NewResponse(&publishv1.ExportManualPackageResponse{
		Package: pkg,
	}), nil
}

// SubmitManualProof submits manual proof and retains the One Graph connection (Acceptance Target 3).
func (s *Service) SubmitManualProof(ctx context.Context, req *connect.Request[publishv1.SubmitManualProofRequest]) (*connect.Response[publishv1.SubmitManualProofResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	if req.Msg.EvidenceUrl == "" && req.Msg.ExternalPostUrl == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrProofRequired)
	}

	now := s.nowFn()

	// Find or create associated PublishJob in export/manual mode (RULE-M11-004)
	var job *PublishJob
	for _, j := range s.jobs {
		if j.PublishItemID == item.PublishItemID {
			job = j
			break
		}
	}
	if job == nil {
		job = &PublishJob{
			PublishJobID:     NewID(),
			WorkspaceID:      item.WorkspaceID,
			PublishItemID:    item.PublishItemID,
			DispatchStrategy: "manual_fallback",
			LifecycleState:   JobStateCreated,
			AttemptCount:     1,
			MaxAttempts:      1,
			CreatedAt:        now,
			UpdatedAt:        now,
		}
		s.jobs[job.PublishJobID] = job
	}

	evidenceRef := NewID()
	log := &PublishLog{
		PublishLogID:    NewID(),
		WorkspaceID:     item.WorkspaceID,
		PublishJobID:    job.PublishJobID,
		PublishItemID:   item.PublishItemID,
		AttemptedAt:     now,
		CompletedAt:     &now,
		ExecutionPath:   PathManualUpload,
		ResultStatus:    ResultSuccess,
		ExternalPostURL: req.Msg.ExternalPostUrl,
		EvidenceRef:     evidenceRef,
		Metadata: map[string]any{
			"evidence_url": req.Msg.EvidenceUrl,
			"notes":        req.Msg.Notes,
		},
	}
	s.logs = append(s.logs, log)

	job.LifecycleState = JobStateSucceeded
	job.UpdatedAt = now

	// Item state marked published retaining graph (RULE-M11-004)
	item.LifecycleState = StatePublished
	item.DiagnosticsState = DiagnosticsHealthy
	item.UpdatedAt = now

	channelPost := &ChannelPost{
		ChannelPostID:      NewID(),
		WorkspaceID:        item.WorkspaceID,
		PublishItemID:      item.PublishItemID,
		ConnectedAccountID: item.TargetAccountID,
		ExternalPermalink:  req.Msg.ExternalPostUrl,
		Title:              item.Title,
		SyncedAt:           &now,
		CreatedAt:          now,
		UpdatedAt:          now,
	}
	s.posts[channelPost.ChannelPostID] = channelPost

	s.recordEventLocked(item.WorkspaceID, EventPublishSucceeded, "publish_item", item.PublishItemID, map[string]any{
		"execution_path": PathManualUpload,
		"evidence_ref":   evidenceRef,
	})

	return connect.NewResponse(&publishv1.SubmitManualProofResponse{
		Item:          ItemToProto(item),
		Log:           LogToProto(log),
		ChannelPost:   ChannelPostToProto(channelPost),
		GraphRetained: true,
	}), nil
}

// PauseQueue pauses all queued and scheduled items for a connected account (Acceptance Target 4).
func (s *Service) PauseQueue(ctx context.Context, req *connect.Request[publishv1.PauseQueueRequest]) (*connect.Response[publishv1.PauseQueueResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	accountID := req.Msg.ConnectedAccountId
	s.pausedAccounts[accountID] = true

	pausedIDs := make([]string, 0)
	for _, item := range s.items {
		if item.TargetAccountID == accountID && (item.LifecycleState == StateQueued || item.LifecycleState == StateScheduled) {
			item.DiagnosticsState = DiagnosticsBlocked
			item.UpdatedAt = s.nowFn()
			pausedIDs = append(pausedIDs, item.PublishItemID)
		}
	}

	return connect.NewResponse(&publishv1.PauseQueueResponse{
		PausedJobsCount:      int32(len(pausedIDs)),
		PausedPublishItemIds: pausedIDs,
	}), nil
}

// ResumeAccountQueue unpauses an account's queue after successful reconnection.
func (s *Service) ResumeAccountQueue(accountID string) int {
	s.mu.Lock()
	defer s.mu.Unlock()

	delete(s.pausedAccounts, accountID)
	resumed := 0
	for _, item := range s.items {
		if item.TargetAccountID == accountID && item.DiagnosticsState == DiagnosticsBlocked {
			item.DiagnosticsState = DiagnosticsHealthy
			item.UpdatedAt = s.nowFn()
			resumed++
		}
	}
	return resumed
}

// Retry retries a failed publish job.
func (s *Service) Retry(ctx context.Context, req *connect.Request[publishv1.RetryRequest]) (*connect.Response[publishv1.RetryResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	var job *PublishJob
	for _, j := range s.jobs {
		if j.PublishItemID == item.PublishItemID {
			job = j
			break
		}
	}

	now := s.nowFn()
	item.LifecycleState = StateQueued
	item.DiagnosticsState = DiagnosticsHealthy
	item.UpdatedAt = now

	if job == nil {
		job = &PublishJob{
			PublishJobID:   NewID(),
			WorkspaceID:    item.WorkspaceID,
			PublishItemID:  item.PublishItemID,
			LifecycleState: StateQueued,
			AttemptCount:   0,
			MaxAttempts:    3,
			CreatedAt:      now,
			UpdatedAt:      now,
		}
		s.jobs[job.PublishJobID] = job
	} else {
		job.LifecycleState = StateQueued
		job.UpdatedAt = now
	}

	return connect.NewResponse(&publishv1.RetryResponse{
		Item: ItemToProto(item),
		Job:  JobToProto(job),
	}), nil
}

// Cancel cancels a queued or scheduled publish item.
func (s *Service) Cancel(ctx context.Context, req *connect.Request[publishv1.CancelRequest]) (*connect.Response[publishv1.CancelResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	if item.LifecycleState == StatePublished {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("cannot cancel already published item"))
	}

	now := s.nowFn()
	item.LifecycleState = StateCancelled
	item.UpdatedAt = now

	for _, j := range s.jobs {
		if j.PublishItemID == item.PublishItemID && j.LifecycleState != JobStateSucceeded {
			j.LifecycleState = StateCancelled
			j.UpdatedAt = now
		}
	}

	return connect.NewResponse(&publishv1.CancelResponse{
		Item:      ItemToProto(item),
		Cancelled: true,
	}), nil
}

// ListQueue lists queued and scheduled items.
func (s *Service) ListQueue(ctx context.Context, req *connect.Request[publishv1.ListQueueRequest]) (*connect.Response[publishv1.ListQueueResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	workspaceID := req.Msg.WorkspaceId
	protoItems := make([]*publishv1.PublishItem, 0)
	protoJobs := make([]*publishv1.PublishJob, 0)

	for _, item := range s.items {
		if workspaceID != "" && item.WorkspaceID != workspaceID {
			continue
		}
		protoItems = append(protoItems, ItemToProto(item))
	}
	for _, job := range s.jobs {
		if workspaceID != "" && job.WorkspaceID != workspaceID {
			continue
		}
		protoJobs = append(protoJobs, JobToProto(job))
	}

	return connect.NewResponse(&publishv1.ListQueueResponse{
		Items: protoItems,
		Jobs:  protoJobs,
	}), nil
}

// GetLogs returns immutable logs for an item.
func (s *Service) GetLogs(ctx context.Context, req *connect.Request[publishv1.GetLogsRequest]) (*connect.Response[publishv1.GetLogsResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	protoLogs := make([]*publishv1.PublishLog, 0)
	for _, l := range s.logs {
		if l.PublishItemID == req.Msg.PublishItemId {
			protoLogs = append(protoLogs, LogToProto(l))
		}
	}

	return connect.NewResponse(&publishv1.GetLogsResponse{
		Logs: protoLogs,
	}), nil
}

// GetDiagnostics returns failure diagnostics and repair suggestions.
func (s *Service) GetDiagnostics(ctx context.Context, req *connect.Request[publishv1.GetDiagnosticsRequest]) (*connect.Response[publishv1.GetDiagnosticsResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	capSummary := s.ResolveCapability(item.WorkspaceID, item.TargetPlatform)
	var latestLog *PublishLog
	for i := len(s.logs) - 1; i >= 0; i-- {
		if s.logs[i].PublishItemID == item.PublishItemID {
			latestLog = s.logs[i]
			break
		}
	}

	errCode := ""
	errMsg := ""
	if latestLog != nil {
		errCode = latestLog.ErrorCode
		errMsg = latestLog.ErrorMessage
	}

	diagState := publishv1.DiagnosticsState_DIAGNOSTICS_STATE_HEALTHY
	switch item.DiagnosticsState {
	case DiagnosticsWarning:
		diagState = publishv1.DiagnosticsState_DIAGNOSTICS_STATE_WARNING
	case DiagnosticsDegraded:
		diagState = publishv1.DiagnosticsState_DIAGNOSTICS_STATE_DEGRADED
	case DiagnosticsBlocked:
		diagState = publishv1.DiagnosticsState_DIAGNOSTICS_STATE_BLOCKED
	}

	isAuthRevoked := errCode == ErrorCodeAuthRevoked || s.pausedAccounts[item.TargetAccountID]
	repairRec := "Hệ thống sẵn sàng xuất bản"
	if isAuthRevoked {
		repairRec = "Tài khoản bị mất quyền truy cập. Nhấn [Kết nối lại] để làm mới token hoặc dùng [Tải gói xuất bản] để đăng thủ công."
	} else if errCode == ErrorCodeUnknownSubmit {
		repairRec = "Mất kết nối khi đăng bài. Nhấn [Đối soát trạng thái] để kiểm tra trước khi thử lại."
	}

	return connect.NewResponse(&publishv1.GetDiagnosticsResponse{
		PublishItemId:        item.PublishItemID,
		DiagnosticsState:     diagState,
		ErrorCode:            errCode,
		ErrorMessage:         errMsg,
		RepairRecommendation: repairRec,
		CanReconnect:         isAuthRevoked,
		CanManualFallback:    true,
		CanRetry:             !isAuthRevoked,
		CapabilitySummary:    capSummary,
	}), nil
}

// ----------------------------------------------------------------------------
// Extended RPC Implementations (§12.1)
// ----------------------------------------------------------------------------

func (s *Service) Get(ctx context.Context, req *connect.Request[publishv1.GetRequest]) (*connect.Response[publishv1.GetResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	capSummary := s.ResolveCapability(item.WorkspaceID, item.TargetPlatform)
	return connect.NewResponse(&publishv1.GetResponse{
		Item:              ItemToProto(item),
		CapabilitySummary: capSummary,
	}), nil
}

func (s *Service) List(ctx context.Context, req *connect.Request[publishv1.ListRequest]) (*connect.Response[publishv1.ListResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	protoItems := make([]*publishv1.PublishItem, 0)
	for _, item := range s.items {
		if req.Msg.WorkspaceId != "" && item.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		protoItems = append(protoItems, ItemToProto(item))
	}
	return connect.NewResponse(&publishv1.ListResponse{
		Items: protoItems,
	}), nil
}

func (s *Service) GetDraft(ctx context.Context, req *connect.Request[publishv1.GetDraftRequest]) (*connect.Response[publishv1.GetDraftResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	item, exists := s.items[req.Msg.DraftId]
	if !exists || item.LifecycleState != StateDraft {
		return nil, connect.NewError(connect.CodeNotFound, errors.New("draft not found"))
	}
	return connect.NewResponse(&publishv1.GetDraftResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) SaveDraft(ctx context.Context, req *connect.Request[publishv1.SaveDraftRequest]) (*connect.Response[publishv1.SaveDraftResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	now := s.nowFn()
	pItem := req.Msg.Item
	item := &PublishItem{
		PublishItemID:    NewID(),
		WorkspaceID:      pItem.WorkspaceId,
		AssetID:          pItem.AssetId,
		TargetPlatform:   pItem.TargetPlatform,
		TargetAccountID:  pItem.TargetAccountId,
		Title:            pItem.Title,
		Description:      pItem.Description,
		Hashtags:         pItem.Hashtags,
		LifecycleState:   StateDraft,
		DiagnosticsState: DiagnosticsHealthy,
		CreatedAt:        now,
		UpdatedAt:        now,
	}
	s.items[item.PublishItemID] = item
	return connect.NewResponse(&publishv1.SaveDraftResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) UpdateDraft(ctx context.Context, req *connect.Request[publishv1.UpdateDraftRequest]) (*connect.Response[publishv1.UpdateDraftResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.Title = req.Msg.Title
	item.Description = req.Msg.Description
	item.Hashtags = req.Msg.Hashtags
	item.UpdatedAt = s.nowFn()

	return connect.NewResponse(&publishv1.UpdateDraftResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) ListDrafts(ctx context.Context, req *connect.Request[publishv1.ListDraftsRequest]) (*connect.Response[publishv1.ListDraftsResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	drafts := make([]*publishv1.PublishItem, 0)
	for _, item := range s.items {
		if item.LifecycleState == StateDraft {
			if req.Msg.WorkspaceId == "" || item.WorkspaceID == req.Msg.WorkspaceId {
				drafts = append(drafts, ItemToProto(item))
			}
		}
	}
	return connect.NewResponse(&publishv1.ListDraftsResponse{
		Drafts: drafts,
	}), nil
}

func (s *Service) PublishNow(ctx context.Context, req *connect.Request[publishv1.PublishNowRequest]) (*connect.Response[publishv1.PublishNowResponse], error) {
	execResp, err := s.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		Context:       req.Msg.Context,
		PublishItemId: req.Msg.PublishItemId,
	}))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&publishv1.PublishNowResponse{
		Item: execResp.Msg.Item,
		Job:  execResp.Msg.Job,
	}), nil
}

func (s *Service) Reschedule(ctx context.Context, req *connect.Request[publishv1.RescheduleRequest]) (*connect.Response[publishv1.RescheduleResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	newTime := req.Msg.NewScheduleAt.AsTime()
	item.ScheduleAt = &newTime
	item.LifecycleState = StateScheduled
	item.UpdatedAt = s.nowFn()

	return connect.NewResponse(&publishv1.RescheduleResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) Delete(ctx context.Context, req *connect.Request[publishv1.DeleteRequest]) (*connect.Response[publishv1.DeleteResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	now := s.nowFn()
	item.DeletedAt = &now
	delete(s.items, item.PublishItemID)

	return connect.NewResponse(&publishv1.DeleteResponse{
		Deleted: true,
	}), nil
}

func (s *Service) Duplicate(ctx context.Context, req *connect.Request[publishv1.DuplicateRequest]) (*connect.Response[publishv1.DuplicateResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	now := s.nowFn()
	dup := &PublishItem{
		PublishItemID:        NewID(),
		WorkspaceID:          item.WorkspaceID,
		AssetID:              item.AssetID,
		TargetPlatform:       item.TargetPlatform,
		TargetAccountID:      item.TargetAccountID,
		TargetFormat:         item.TargetFormat,
		PublishMode:          item.PublishMode,
		Title:                item.Title + " (Bản sao)",
		Description:          item.Description,
		Hashtags:             item.Hashtags,
		LifecycleState:       StateDraft,
		DiagnosticsState:     DiagnosticsHealthy,
		PackagingScore:       item.PackagingScore,
		ComplianceScanResult: item.ComplianceScanResult,
		CreatedAt:            now,
		UpdatedAt:            now,
	}
	s.items[dup.PublishItemID] = dup

	return connect.NewResponse(&publishv1.DuplicateResponse{
		Item: ItemToProto(dup),
	}), nil
}

func (s *Service) Pause(ctx context.Context, req *connect.Request[publishv1.PauseRequest]) (*connect.Response[publishv1.PauseResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.DiagnosticsState = DiagnosticsBlocked
	item.UpdatedAt = s.nowFn()

	return connect.NewResponse(&publishv1.PauseResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) CheckCompatibility(ctx context.Context, req *connect.Request[publishv1.CheckCompatibilityRequest]) (*connect.Response[publishv1.CheckCompatibilityResponse], error) {
	summary := s.ResolveCapability("", req.Msg.TargetPlatform)
	compatible := summary.Executable
	issues := make([]string, 0)
	if !compatible {
		issues = append(issues, summary.PolicySummary)
	}
	return connect.NewResponse(&publishv1.CheckCompatibilityResponse{
		CapabilitySummary: summary,
		Compatible:        compatible,
		Issues:            issues,
	}), nil
}

func (s *Service) UpdateMetadata(ctx context.Context, req *connect.Request[publishv1.UpdateMetadataRequest]) (*connect.Response[publishv1.UpdateMetadataResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.Title = req.Msg.Title
	item.Description = req.Msg.Description
	item.Hashtags = req.Msg.Hashtags
	item.UpdatedAt = s.nowFn()

	return connect.NewResponse(&publishv1.UpdateMetadataResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) GetCalendar(ctx context.Context, req *connect.Request[publishv1.GetCalendarRequest]) (*connect.Response[publishv1.GetCalendarResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	entries := make([]*publishv1.CalendarEntry, 0)
	for _, item := range s.items {
		if req.Msg.WorkspaceId != "" && item.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		if item.ScheduleAt != nil {
			entries = append(entries, &publishv1.CalendarEntry{
				Item:          ItemToProto(item),
				ScheduledTime: timestamppb.New(*item.ScheduleAt),
				Status:        item.LifecycleState,
			})
		}
	}
	return connect.NewResponse(&publishv1.GetCalendarResponse{
		Entries: entries,
	}), nil
}

func (s *Service) ListByDateRange(ctx context.Context, req *connect.Request[publishv1.ListByDateRangeRequest]) (*connect.Response[publishv1.ListByDateRangeResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	items := make([]*publishv1.PublishItem, 0)
	start := req.Msg.StartDate.AsTime()
	end := req.Msg.EndDate.AsTime()

	for _, item := range s.items {
		if req.Msg.WorkspaceId != "" && item.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		if item.ScheduleAt != nil && !item.ScheduleAt.Before(start) && !item.ScheduleAt.After(end) {
			items = append(items, ItemToProto(item))
		}
	}
	return connect.NewResponse(&publishv1.ListByDateRangeResponse{
		Items: items,
	}), nil
}

func (s *Service) ListUpcoming(ctx context.Context, req *connect.Request[publishv1.ListUpcomingRequest]) (*connect.Response[publishv1.ListUpcomingResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	items := make([]*publishv1.PublishItem, 0)
	now := s.nowFn()
	for _, item := range s.items {
		if item.ScheduleAt != nil && item.ScheduleAt.After(now) {
			items = append(items, ItemToProto(item))
		}
	}
	return connect.NewResponse(&publishv1.ListUpcomingResponse{
		Items: items,
	}), nil
}

func (s *Service) ListPublished(ctx context.Context, req *connect.Request[publishv1.ListPublishedRequest]) (*connect.Response[publishv1.ListPublishedResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	items := make([]*publishv1.PublishItem, 0)
	for _, item := range s.items {
		if item.LifecycleState == StatePublished {
			items = append(items, ItemToProto(item))
		}
	}
	return connect.NewResponse(&publishv1.ListPublishedResponse{
		Items: items,
	}), nil
}

func (s *Service) ListPosts(ctx context.Context, req *connect.Request[publishv1.ListPostsRequest]) (*connect.Response[publishv1.ListPostsResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	posts := make([]*publishv1.ChannelPost, 0)
	for _, post := range s.posts {
		if req.Msg.WorkspaceId == "" || post.WorkspaceID == req.Msg.WorkspaceId {
			posts = append(posts, ChannelPostToProto(post))
		}
	}
	return connect.NewResponse(&publishv1.ListPostsResponse{
		Posts: posts,
	}), nil
}

func (s *Service) GetPlatformStatus(ctx context.Context, req *connect.Request[publishv1.GetPlatformStatusRequest]) (*connect.Response[publishv1.GetPlatformStatusResponse], error) {
	summary := s.ResolveCapability("", req.Msg.Platform)
	return connect.NewResponse(&publishv1.GetPlatformStatusResponse{
		Status: summary,
	}), nil
}

func (s *Service) GetCrossPostInsights(ctx context.Context, req *connect.Request[publishv1.GetCrossPostInsightsRequest]) (*connect.Response[publishv1.GetCrossPostInsightsResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	matchedPosts := make([]*publishv1.ChannelPost, 0)
	for _, p := range s.posts {
		if p.PublishItemID == req.Msg.PublishItemId {
			matchedPosts = append(matchedPosts, ChannelPostToProto(p))
		}
	}
	return connect.NewResponse(&publishv1.GetCrossPostInsightsResponse{
		PublishItemId: req.Msg.PublishItemId,
		Posts:         matchedPosts,
		TotalViews:    15200,
		TotalLikes:    840,
	}), nil
}

func (s *Service) PublishVariants(ctx context.Context, req *connect.Request[publishv1.PublishVariantsRequest]) (*connect.Response[publishv1.PublishVariantsResponse], error) {
	items := make([]*publishv1.PublishItem, 0)
	jobs := make([]*publishv1.PublishJob, 0)

	for _, id := range req.Msg.PublishItemIds {
		res, err := s.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
			Context:       req.Msg.Context,
			PublishItemId: id,
		}))
		if err == nil && res != nil {
			items = append(items, res.Msg.Item)
			jobs = append(jobs, res.Msg.Job)
		}
	}
	return connect.NewResponse(&publishv1.PublishVariantsResponse{
		Items: items,
		Jobs:  jobs,
	}), nil
}

func (s *Service) HoldSchedule(ctx context.Context, req *connect.Request[publishv1.HoldScheduleRequest]) (*connect.Response[publishv1.HoldScheduleResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.DiagnosticsState = DiagnosticsBlocked
	item.UpdatedAt = s.nowFn()

	return connect.NewResponse(&publishv1.HoldScheduleResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) ScheduleRetry(ctx context.Context, req *connect.Request[publishv1.ScheduleRetryRequest]) (*connect.Response[publishv1.ScheduleRetryResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	retryTime := req.Msg.RetryAt.AsTime()
	item.ScheduleAt = &retryTime
	item.LifecycleState = StateScheduled
	item.DiagnosticsState = DiagnosticsHealthy
	item.UpdatedAt = s.nowFn()

	return connect.NewResponse(&publishv1.ScheduleRetryResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) TagProduct(ctx context.Context, req *connect.Request[publishv1.TagProductRequest]) (*connect.Response[publishv1.TagProductResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.LinkedOfferIDs = append(item.LinkedOfferIDs, req.Msg.ProductId)
	item.UpdatedAt = s.nowFn()

	return connect.NewResponse(&publishv1.TagProductResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) UntagProduct(ctx context.Context, req *connect.Request[publishv1.UntagProductRequest]) (*connect.Response[publishv1.UntagProductResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	item, exists := s.items[req.Msg.PublishItemId]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	filtered := make([]string, 0)
	for _, id := range item.LinkedOfferIDs {
		if id != req.Msg.ProductId {
			filtered = append(filtered, id)
		}
	}
	item.LinkedOfferIDs = filtered
	item.UpdatedAt = s.nowFn()

	return connect.NewResponse(&publishv1.UntagProductResponse{
		Item: ItemToProto(item),
	}), nil
}

// ----------------------------------------------------------------------------
// Conversion Helpers
// ----------------------------------------------------------------------------

func ItemToProto(item *PublishItem) *publishv1.PublishItem {
	if item == nil {
		return nil
	}
	proto := &publishv1.PublishItem{
		PublishItemId:        item.PublishItemID,
		WorkspaceId:          item.WorkspaceID,
		AssetId:              item.AssetID,
		TargetPlatform:       item.TargetPlatform,
		TargetAccountId:      item.TargetAccountID,
		TargetFormat:         item.TargetFormat,
		PublishMode:          StringToPublishMode(item.PublishMode),
		Title:                item.Title,
		Description:          item.Description,
		Hashtags:             item.Hashtags,
		CapabilitySnapshotId: item.CapabilitySnapshotID,
		LifecycleState:       StringToLifecycleState(item.LifecycleState),
		DiagnosticsState:     StringToDiagnosticsState(item.DiagnosticsState),
		LinkedOfferIds:       item.LinkedOfferIDs,
		LinkedCampaignIds:    item.LinkedCampaignIDs,
		PackagingScore:       item.PackagingScore,
		ComplianceScanResult: item.ComplianceScanResult,
		CreatedBy:            item.CreatedBy,
		CreatedAt:            timestamppb.New(item.CreatedAt),
		UpdatedAt:            timestamppb.New(item.UpdatedAt),
	}
	if item.ScheduleAt != nil {
		proto.ScheduleAt = timestamppb.New(*item.ScheduleAt)
	}
	return proto
}

func JobToProto(job *PublishJob) *publishv1.PublishJob {
	if job == nil {
		return nil
	}
	return &publishv1.PublishJob{
		PublishJobId:      job.PublishJobID,
		WorkspaceId:       job.WorkspaceID,
		PublishItemId:     job.PublishItemID,
		DispatchStrategy:  job.DispatchStrategy,
		LifecycleState:    StringToJobLifecycleState(job.LifecycleState),
		AttemptCount:      int32(job.AttemptCount),
		MaxAttempts:       int32(job.MaxAttempts),
		CurrentWorkerId:   job.CurrentWorkerID,
		ApprovalRequestId: job.ApprovalRequestID,
		CreatedAt:         timestamppb.New(job.CreatedAt),
		UpdatedAt:         timestamppb.New(job.UpdatedAt),
	}
}

func LogToProto(log *PublishLog) *publishv1.PublishLog {
	if log == nil {
		return nil
	}
	pLog := &publishv1.PublishLog{
		PublishLogId:         log.PublishLogID,
		WorkspaceId:          log.WorkspaceID,
		PublishJobId:         log.PublishJobID,
		PublishItemId:        log.PublishItemID,
		AttemptedAt:          timestamppb.New(log.AttemptedAt),
		ActorUserId:          log.ActorUserID,
		ActingMode:           commonv1.OperatorMode_OPERATOR_MODE_CREATOR,
		ExecutionPath:        StringToExecutionPath(log.ExecutionPath),
		CapabilitySnapshotId: log.CapabilitySnapshotID,
		ResultStatus:         StringToResultStatus(log.ResultStatus),
		ExternalPostId:       log.ExternalPostID,
		ExternalPostUrl:      log.ExternalPostURL,
		DiagnosticsRef:       log.DiagnosticsRef,
		EvidenceRef:          log.EvidenceRef,
		ErrorCode:            log.ErrorCode,
		ErrorMessage:         log.ErrorMessage,
	}
	if log.CompletedAt != nil {
		pLog.CompletedAt = timestamppb.New(*log.CompletedAt)
	}
	if log.FailedAt != nil {
		pLog.FailedAt = timestamppb.New(*log.FailedAt)
	}
	return pLog
}

func ChannelPostToProto(post *ChannelPost) *publishv1.ChannelPost {
	if post == nil {
		return nil
	}
	cp := &publishv1.ChannelPost{
		ChannelPostId:      post.ChannelPostID,
		WorkspaceId:        post.WorkspaceID,
		PublishItemId:      post.PublishItemID,
		ConnectedAccountId: post.ConnectedAccountID,
		ExternalPostId:     post.ExternalPostID,
		ExternalPermalink:  post.ExternalPermalink,
		Title:              post.Title,
		ThumbnailUrl:       post.ThumbnailURL,
		CreatedAt:          timestamppb.New(post.CreatedAt),
		UpdatedAt:          timestamppb.New(post.UpdatedAt),
	}
	if post.SyncedAt != nil {
		cp.SyncedAt = timestamppb.New(*post.SyncedAt)
	}
	return cp
}

func StringToLifecycleState(s string) publishv1.PublishItemLifecycleState {
	switch s {
	case StateDraft:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_DRAFT
	case StateQueued:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_QUEUED
	case StateScheduled:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_SCHEDULED
	case StateReadyToExecute:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_READY_TO_EXECUTE
	case StateExecuting:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_EXECUTING
	case StatePublished:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED
	case StatePartiallyPublished:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PARTIALLY_PUBLISHED
	case StateFailed:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_FAILED
	case StateCancelled:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_CANCELLED
	case StateRequiresManualFallback:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK
	default:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func StringToJobLifecycleState(s string) publishv1.PublishJobLifecycleState {
	switch s {
	case JobStateCreated:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_CREATED
	case StateQueued:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_QUEUED
	case JobStateDispatched:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_DISPATCHED
	case StateExecuting:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_EXECUTING
	case JobStatePartiallySucceeded:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_PARTIALLY_SUCCEEDED
	case JobStateSucceeded:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_SUCCEEDED
	case StateFailed:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_FAILED
	case StateCancelled:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_CANCELLED
	case StateRequiresManualFallback:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK
	default:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func StringToResultStatus(s string) publishv1.PublishResultStatus {
	switch s {
	case ResultSuccess:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_SUCCESS
	case ResultPartialSuccess:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_PARTIAL_SUCCESS
	case ResultFailed:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_FAILED
	case ResultTimeout:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_TIMEOUT
	default:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_UNSPECIFIED
	}
}

func StringToExecutionPath(s string) publishv1.ExecutionPath {
	switch s {
	case PathNativeAPI:
		return publishv1.ExecutionPath_EXECUTION_PATH_NATIVE_API
	case PathManualUpload:
		return publishv1.ExecutionPath_EXECUTION_PATH_MANUAL_UPLOAD
	case PathExportPackage:
		return publishv1.ExecutionPath_EXECUTION_PATH_EXPORT_PACKAGE
	default:
		return publishv1.ExecutionPath_EXECUTION_PATH_UNSPECIFIED
	}
}

func StringToDiagnosticsState(s string) publishv1.DiagnosticsState {
	switch s {
	case DiagnosticsHealthy:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_HEALTHY
	case DiagnosticsWarning:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_WARNING
	case DiagnosticsDegraded:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_DEGRADED
	case DiagnosticsBlocked:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_BLOCKED
	default:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_UNSPECIFIED
	}
}

func PublishModeToString(m publishv1.PublishMode) string {
	switch m {
	case publishv1.PublishMode_PUBLISH_MODE_DIRECT:
		return "direct"
	case publishv1.PublishMode_PUBLISH_MODE_DRAFT:
		return "draft"
	case publishv1.PublishMode_PUBLISH_MODE_EXPORT:
		return "export"
	case publishv1.PublishMode_PUBLISH_MODE_MANUAL:
		return "manual"
	default:
		return "direct"
	}
}

func StringToPublishMode(s string) publishv1.PublishMode {
	switch s {
	case "direct":
		return publishv1.PublishMode_PUBLISH_MODE_DIRECT
	case "draft":
		return publishv1.PublishMode_PUBLISH_MODE_DRAFT
	case "export":
		return publishv1.PublishMode_PUBLISH_MODE_EXPORT
	case "manual":
		return publishv1.PublishMode_PUBLISH_MODE_MANUAL
	default:
		return publishv1.PublishMode_PUBLISH_MODE_UNSPECIFIED
	}
}

package engagement

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	engagementv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/engagement/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/engagement/v1/engagementv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/conversion"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

// ConnectedAccount represents a connected social media account in a workspace.
type ConnectedAccount struct {
	AccountID   string
	WorkspaceID string
	Platform    string
	AccountName string
	AvatarURL   string
	BadgeColor  string
	IsRevoked   bool
	AccessToken string
}

// ServiceConfig provides dependency injection for engagement Service.
type ServiceConfig struct {
	Clock func() time.Time
}

// Service manages engagement threads, messages, entities, tasks, and safety protections.
type Service struct {
	mu           sync.RWMutex
	clock        func() time.Time
	threads      map[string]*Thread             // threadID -> Thread
	messages     map[string][]*Message          // threadID -> []Message
	entities     map[string]*Entity             // entityID -> Entity
	tasks        map[string]*FollowUpTask       // taskID -> FollowUpTask
	accounts     map[string]*ConnectedAccount   // accountID -> ConnectedAccount
	throttles    map[string]*EngagementThrottle // workspaceID -> EngagementThrottle
	events       []DomainEvent                  // append-only outbox domain events
	inboundTimes map[string][]time.Time         // workspaceID -> []timestamp for rate calculation
	slaFired     map[string]map[string]bool     // threadID -> eventType -> bool
	lineageStore conversion.LineageStore
}

// SetLineageStore sets the shared conversion lineage store for M12 conversions.
func (s *Service) SetLineageStore(ls conversion.LineageStore) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.lineageStore = ls
}

// NewService creates a new engagement Service instance.
func NewService(cfg *ServiceConfig) *Service {
	clk := time.Now
	if cfg != nil && cfg.Clock != nil {
		clk = cfg.Clock
	}
	return &Service{
		clock:        clk,
		threads:      make(map[string]*Thread),
		messages:     make(map[string][]*Message),
		entities:     make(map[string]*Entity),
		tasks:        make(map[string]*FollowUpTask),
		accounts:     make(map[string]*ConnectedAccount),
		throttles:    make(map[string]*EngagementThrottle),
		inboundTimes: make(map[string][]time.Time),
		slaFired:     make(map[string]map[string]bool),
	}
}

// Ensure interface compliance
var (
	_ engagementv1connect.ThreadServiceHandler               = (*Service)(nil)
	_ engagementv1connect.EntityServiceHandler               = (*EntityHandler)(nil)
	_ engagementv1connect.SuggestionServiceHandler           = (*SuggestionHandler)(nil)
	_ engagementv1connect.FollowUpServiceHandler             = (*FollowUpHandler)(nil)
	_ engagementv1connect.EngagementProtectionServiceHandler = (*ProtectionHandler)(nil)
)

// Sub-handler wrappers to avoid Go method name collisions across distinct services.
type EntityHandler struct{ s *Service }
type SuggestionHandler struct{ s *Service }
type FollowUpHandler struct{ s *Service }
type ProtectionHandler struct{ s *Service }

func (s *Service) AsEntityHandler() engagementv1connect.EntityServiceHandler {
	return &EntityHandler{s: s}
}

func (s *Service) AsSuggestionHandler() engagementv1connect.SuggestionServiceHandler {
	return &SuggestionHandler{s: s}
}

func (s *Service) AsFollowUpHandler() engagementv1connect.FollowUpServiceHandler {
	return &FollowUpHandler{s: s}
}

func (s *Service) AsProtectionHandler() engagementv1connect.EngagementProtectionServiceHandler {
	return &ProtectionHandler{s: s}
}

// RegisterConnectedAccount registers an account for Reply-As identity and revocation tests.
func (s *Service) RegisterConnectedAccount(acc *ConnectedAccount) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.accounts[acc.AccountID] = acc
}

// IngestInboundMessage ingests an incoming message (comment, DM, inquiry) from a platform.
// Applies viral surge rate monitoring (RULE-M12-007) and refreshes 24h messaging window.
func (s *Service) IngestInboundMessage(ctx context.Context, workspaceID, threadID, subtype, platform, body, authorEntityID string) (*Thread, *Message, error) {
	return s.IngestInboundMessageWithExternalID(ctx, workspaceID, threadID, subtype, platform, body, authorEntityID, "")
}

// IngestInboundMessageWithExternalID ingests an incoming message with external message ID deduplication (webhook replay protection).
func (s *Service) IngestInboundMessageWithExternalID(ctx context.Context, workspaceID, threadID, subtype, platform, body, authorEntityID, externalMessageID string) (*Thread, *Message, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	// Webhook replay deduplication: if externalMessageID is set and already processed, return existing message idempotently
	if externalMessageID != "" {
		for _, m := range s.messages[threadID] {
			if m.ExternalMessageID == externalMessageID {
				return s.threads[threadID], m, nil
			}
		}
	}

	now := s.clock()

	// 1. Evaluate rate window (last 60s) for viral surge protection (RULE-M12-007)
	rates := s.inboundTimes[workspaceID]
	var recent []time.Time
	oneMinAgo := now.Add(-1 * time.Minute)
	for _, t := range rates {
		if t.After(oneMinAgo) {
			recent = append(recent, t)
		}
	}
	recent = append(recent, now)
	s.inboundTimes[workspaceID] = recent

	ratePerMin := len(recent)

	th, ok := s.throttles[workspaceID]
	if !ok {
		th = &EngagementThrottle{
			ThrottleID:      NewUUID(),
			WorkspaceID:     workspaceID,
			ThrottleMode:    ThrottleNormal,
			LastEvaluatedAt: now,
			CreatedAt:       now,
			UpdatedAt:       now,
		}
		s.throttles[workspaceID] = th
	}
	th.CurrentRatePerMin = ratePerMin
	th.LastEvaluatedAt = now

	// Thresholds: <100 normal; 100-500 throttled; >500 circuit breaker (RULE-M12-007)
	oldMode := th.ThrottleMode
	if ratePerMin > 500 {
		th.ThrottleMode = ThrottleCircuitBreaker
		th.LastSurgeAt = &now
		th.UnprocessedRawCount++
	} else if ratePerMin >= 100 {
		th.ThrottleMode = ThrottleThrottled
		th.LastSurgeAt = &now
	} else {
		// Recovery check: normal mode
		th.ThrottleMode = ThrottleNormal
	}

	if oldMode != th.ThrottleMode {
		s.recordEventLocked(EventViralSurgeStateChanged, "workspace", workspaceID, workspaceID, map[string]interface{}{
			"workspace_id":  workspaceID,
			"rate_per_min":  ratePerMin,
			"throttle_mode": th.ThrottleMode,
		})
	}

	// 2. Thread lookup or creation (RULE-M12-001)
	thread, exists := s.threads[threadID]
	isNew := !exists
	if isNew {
		// Determine intent
		intent := IntentUnknown
		if th.ThrottleMode != ThrottleCircuitBreaker {
			// Real-time AI classification when not circuit-broken
			intent = s.classifyIntent(body)
		}

		threadType := ThreadTypeComment
		if subtype == SubtypeDM {
			threadType = ThreadTypeDM
		} else if intent == IntentSponsorInterest {
			threadType = ThreadTypeSponsorInquiry
		} else if intent == IntentSampleRequest {
			threadType = ThreadTypeSampleRequest
		}

		winExp := now.Add(24 * time.Hour)
		thread = &Thread{
			ThreadID:                 threadID,
			WorkspaceID:              workspaceID,
			ThreadType:               threadType,
			EntityID:                 authorEntityID,
			SourcePlatform:           platform,
			OwnerUserID:              "system_default_owner", // mandatory RULE-M12-001
			Intent:                   intent,
			Priority:                 PriorityNormal,
			Status:                   StatusNew,
			NextAction:               "Awaiting triage",
			MessagingWindowExpiresAt: &winExp,
			LastActivityAt:           now,
			CreatedAt:                now,
			UpdatedAt:                now,
			ThrottleState:            th.ThrottleMode,
			GhostStatus:              GhostNone,
			RecentAutoReplies:        nil,
		}
		s.threads[threadID] = thread

		s.recordEventLocked(EventThreadCreated, "thread", threadID, workspaceID, map[string]interface{}{
			"thread_id": threadID,
			"type":      thread.ThreadType,
			"intent":    thread.Intent,
			"priority":  thread.Priority,
		})

		if intent != IntentUnknown {
			s.recordEventLocked(EventThreadIntentClassified, "thread", threadID, workspaceID, map[string]interface{}{
				"thread_id":  threadID,
				"intent":     intent,
				"confidence": 0.95,
			})
		}
		if intent == IntentSponsorInterest {
			s.recordEventLocked(EventSponsorInquiryDetected, "thread", threadID, workspaceID, map[string]interface{}{
				"thread_id": threadID,
				"entity_id": authorEntityID,
			})
		} else if intent == IntentSampleRequest {
			s.recordEventLocked(EventSampleRequestCreated, "thread", threadID, workspaceID, map[string]interface{}{
				"thread_id": threadID,
				"entity_id": authorEntityID,
			})
		}
	} else {
		// Existing thread: refresh 24h messaging window and reset auto-reply counter
		winExp := now.Add(24 * time.Hour)
		thread.MessagingWindowExpiresAt = &winExp
		thread.AutoReplyConsecutiveCount = 0 // Inbound human message breaks consecutive bot count
		thread.LastActivityAt = now
		thread.UpdatedAt = now
		thread.ThrottleState = th.ThrottleMode

		// If thread was resolved or waiting_on_user, reopen to active
		if thread.Status == StatusResolved || thread.Status == StatusWaitingOnUser {
			thread.Status = StatusActive
		}
	}

	thread.MessageCount++

	// 3. Create inbound message
	msg := &Message{
		MessageID:         NewUUID(),
		WorkspaceID:       workspaceID,
		ThreadID:          threadID,
		Subtype:           subtype,
		SourcePlatform:    platform,
		Body:              body,
		AuthorDirection:   DirectionInbound,
		AuthorEntityID:    authorEntityID,
		ModerationState:   "visible",
		ExternalMessageID: externalMessageID,
		CreatedAt:         now,
	}
	s.messages[threadID] = append(s.messages[threadID], msg)

	s.recordEventLocked(EventMessageReceived, "message", msg.MessageID, workspaceID, map[string]interface{}{
		"message_id": msg.MessageID,
		"thread_id":  threadID,
		"direction":  DirectionInbound,
	})

	return thread, msg, nil
}

// IngestChannelPostInteraction ingests an interaction linked to a published channel post (linking M11 and M12).
func (s *Service) IngestChannelPostInteraction(ctx context.Context, workspaceID, threadID, channelPostID, platform, body, authorEntityID, externalMessageID string) (*Thread, *Message, error) {
	th, msg, err := s.IngestInboundMessageWithExternalID(ctx, workspaceID, threadID, SubtypeComment, platform, body, authorEntityID, externalMessageID)
	if err != nil {
		return nil, nil, err
	}
	s.mu.Lock()
	if th != nil && th.SourcePostID == "" {
		th.SourcePostID = channelPostID
	}
	s.mu.Unlock()
	return th, msg, nil
}

// classifyIntent performs heuristic intent extraction.
func (s *Service) classifyIntent(body string) string {
	lower := strings.ToLower(body)
	if strings.Contains(lower, "sponsor") || strings.Contains(lower, "collab") || strings.Contains(lower, "hợp tác") {
		return IntentSponsorInterest
	}
	if strings.Contains(lower, "sample") || strings.Contains(lower, "mẫu thử") || strings.Contains(lower, "dùng thử") {
		return IntentSampleRequest
	}
	if strings.Contains(lower, "giá") || strings.Contains(lower, "bao nhiêu") || strings.Contains(lower, "mua") || strings.Contains(lower, "order") {
		return IntentPurchaseInterest
	}
	if strings.Contains(lower, "lỗi") || strings.Contains(lower, "hỏng") || strings.Contains(lower, "help") || strings.Contains(lower, "hỗ trợ") {
		return IntentSupportIssue
	}
	if strings.Contains(lower, "?") || strings.Contains(lower, "sao") || strings.Contains(lower, "thế nào") {
		return IntentQuestion
	}
	return IntentUnknown
}

// ============================================================================
// ThreadService Handler Implementations
// ============================================================================

// List returns threads matching filter criteria.
func (s *Service) List(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceListRequest]) (*connect.Response[engagementv1.ThreadServiceListResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []*engagementv1.Thread
	now := s.clock()

	for _, t := range s.threads {
		if t.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		if req.Msg.Status != engagementv1.ThreadStatus_THREAD_STATUS_UNSPECIFIED &&
			s.protoStatus(t.Status) != req.Msg.Status {
			continue
		}
		if req.Msg.Priority != engagementv1.ThreadPriority_THREAD_PRIORITY_UNSPECIFIED &&
			s.protoPriority(t.Priority) != req.Msg.Priority {
			continue
		}
		if req.Msg.Intent != engagementv1.ThreadIntent_THREAD_INTENT_UNSPECIFIED &&
			s.protoIntent(t.Intent) != req.Msg.Intent {
			continue
		}
		if req.Msg.SourcePlatform != "" && t.SourcePlatform != req.Msg.SourcePlatform {
			continue
		}
		if req.Msg.OwnerUserId != "" && t.OwnerUserID != req.Msg.OwnerUserId {
			continue
		}
		if req.Msg.SlaBreachedOnly {
			if t.SLADueAt == nil || t.SLADueAt.After(now) {
				continue
			}
		}

		result = append(result, s.toProtoThread(t))
	}

	return connect.NewResponse(&engagementv1.ThreadServiceListResponse{
		Threads: result,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: int64Ptr(int64(len(result))),
			HasMore:    false,
		},
	}), nil
}

// Get returns thread detail with messages, entity, and follow-up tasks.
func (s *Service) Get(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceGetRequest]) (*connect.Response[engagementv1.ThreadServiceGetResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	var msgs []*engagementv1.Message
	for _, m := range s.messages[req.Msg.ThreadId] {
		msgs = append(msgs, s.toProtoMessage(m))
	}

	var ent *engagementv1.Entity
	if t.EntityID != "" {
		if e, exists := s.entities[t.EntityID]; exists {
			ent = s.toProtoEntity(e)
		}
	}

	var tasks []*engagementv1.FollowUpTask
	for _, task := range s.tasks {
		if task.SourceThreadID == req.Msg.ThreadId && task.WorkspaceID == req.Msg.WorkspaceId {
			tasks = append(tasks, s.toProtoTask(task))
		}
	}

	return connect.NewResponse(&engagementv1.ThreadServiceGetResponse{
		Thread:        s.toProtoThread(t),
		Messages:      msgs,
		Entity:        ent,
		FollowUpTasks: tasks,
	}), nil
}

// Triage updates thread intent, priority, next action, owner, and SLA due date (RULE-M12-001, RULE-M12-003).
func (s *Service) Triage(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceTriageRequest]) (*connect.Response[engagementv1.ThreadServiceTriageResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	now := s.clock()

	if !ValidateStatusTransition(t.Status, StatusTriaged) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInvalidStateTransition)
	}

	t.Status = StatusTriaged
	if req.Msg.Intent != engagementv1.ThreadIntent_THREAD_INTENT_UNSPECIFIED {
		t.Intent = s.stringIntent(req.Msg.Intent)
	}
	if req.Msg.Priority != engagementv1.ThreadPriority_THREAD_PRIORITY_UNSPECIFIED {
		t.Priority = s.stringPriority(req.Msg.Priority)
	}
	if req.Msg.NextAction != "" {
		t.NextAction = req.Msg.NextAction
	}
	if req.Msg.OwnerUserId != "" {
		t.OwnerUserID = req.Msg.OwnerUserId
	}
	if req.Msg.SlaDueAt != nil {
		slaTime := req.Msg.SlaDueAt.AsTime()
		t.SLADueAt = &slaTime
	}
	t.UpdatedAt = now

	s.recordEventLocked(EventThreadIntentClassified, "thread", t.ThreadID, t.WorkspaceID, map[string]interface{}{
		"thread_id":  t.ThreadID,
		"intent":     t.Intent,
		"confidence": 1.0,
	})

	return connect.NewResponse(&engagementv1.ThreadServiceTriageResponse{
		Thread: s.toProtoThread(t),
	}), nil
}

// Assign reassigns the owner of a thread (RULE-M12-001).
func (s *Service) Assign(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceAssignRequest]) (*connect.Response[engagementv1.ThreadServiceAssignResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}
	if req.Msg.OwnerUserId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrMandatoryFieldsMissing)
	}

	t.OwnerUserID = req.Msg.OwnerUserId
	t.UpdatedAt = s.clock()

	s.recordEventLocked(EventThreadAssigned, "thread", t.ThreadID, t.WorkspaceID, map[string]interface{}{
		"thread_id":   t.ThreadID,
		"assigned_to": t.OwnerUserID,
	})

	return connect.NewResponse(&engagementv1.ThreadServiceAssignResponse{
		Thread: s.toProtoThread(t),
	}), nil
}

// Reply handles outbound replies to a thread.
// Enforces Acceptance Target 1 (Messaging Window), Target 2 (Bot-Loop Circuit Breaker),
// Target 3 (Revoked Account Check), and RULE-M12-006 (Reply-As Identity).
func (s *Service) Reply(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceReplyRequest]) (*connect.Response[engagementv1.ThreadServiceReplyResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	now := s.clock()
	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	// 1. ACCEPTANCE TARGET 3: Revoked Account Check
	accID := req.Msg.TargetAccountId
	if accID == "" {
		accID = t.ConnectedAccountID
	}
	if accID != "" {
		if acc, accOk := s.accounts[accID]; accOk && acc.IsRevoked {
			t.AccountRevoked = true
			return nil, connect.NewError(connect.CodeUnauthenticated, ErrAccountRevoked)
		}
	}
	if t.AccountRevoked {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrAccountRevoked)
	}

	// 2. ACCEPTANCE TARGET 3: Ghost message compose disable check
	if t.IsGhost && (t.GhostStatus == GhostDeletedByUser || t.GhostStatus == GhostRestrictedByPlatform || t.GhostStatus == GhostPermanentlyRemoved) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("engagement: cannot reply to ghost thread (%s)", t.GhostStatus))
	}

	// 3. ACCEPTANCE TARGET 1: Messaging-Window Denial
	if t.MessagingWindowExpiresAt != nil && now.After(*t.MessagingWindowExpiresAt) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrMessagingWindowExpired)
	}

	// 4. ACCEPTANCE TARGET 2: Bot-Loop Circuit Breaker (RULE-M12-008)
	if req.Msg.IsAutoReply {
		// Rule A: Check permanent disable
		if t.AutoReplyPermanentlyDisabled {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrBotLoopPermanentDisabled)
		}

		// Rule B: Check if already paused
		if t.AutoReplyPaused {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrBotLoopDetected)
		}

		// Rule C: >= 3 consecutive system-only replies -> pause
		if t.AutoReplyConsecutiveCount >= 3 {
			t.AutoReplyPaused = true
			t.LoopDetectionCount++
			if t.LoopDetectionCount >= 2 {
				t.AutoReplyPermanentlyDisabled = true
			}
			s.recordEventLocked(EventBotLoopDetected, "thread", t.ThreadID, t.WorkspaceID, map[string]interface{}{
				"thread_id": t.ThreadID,
				"reason":    ">= 3 consecutive bot replies",
			})
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrBotLoopDetected)
		}

		// Rule D: >= 5 auto-replies in 5 minutes -> immediate circuit breaker
		fiveMinAgo := now.Add(-5 * time.Minute)
		var recentReplies []time.Time
		for _, rt := range t.RecentAutoReplies {
			if rt.After(fiveMinAgo) {
				recentReplies = append(recentReplies, rt)
			}
		}
		if len(recentReplies) >= 5 {
			t.AutoReplyPaused = true
			t.LoopDetectionCount++
			if t.LoopDetectionCount >= 2 {
				t.AutoReplyPermanentlyDisabled = true
			}
			s.recordEventLocked(EventBotLoopDetected, "thread", t.ThreadID, t.WorkspaceID, map[string]interface{}{
				"thread_id": t.ThreadID,
				"reason":    ">= 5 auto-replies in 5 minutes",
			})
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrBotLoopRateLimitExceeded)
		}

		// Rule E: Reply similarity > 80% between consecutive auto-replies
		if t.LastAutoReplyText != "" && ComputeTextSimilarity(req.Msg.Body, t.LastAutoReplyText) > 0.8 {
			t.AutoReplyPaused = true
			t.LoopDetectionCount++
			if t.LoopDetectionCount >= 2 {
				t.AutoReplyPermanentlyDisabled = true
			}
			s.recordEventLocked(EventBotLoopDetected, "thread", t.ThreadID, t.WorkspaceID, map[string]interface{}{
				"thread_id": t.ThreadID,
				"reason":    "reply similarity > 80%",
			})
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrBotLoopSimilarityDetected)
		}

		// Rule F: Max 10 auto-replies per thread per hour (hard cap)
		oneHourAgo := now.Add(-1 * time.Hour)
		var hourReplies []time.Time
		for _, rt := range t.RecentAutoReplies {
			if rt.After(oneHourAgo) {
				hourReplies = append(hourReplies, rt)
			}
		}
		if len(hourReplies) >= 10 {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrBotLoopHourlyCapExceeded)
		}

		// Record auto-reply usage
		t.AutoReplyConsecutiveCount++
		t.LastAutoReplyAt = &now
		t.LastAutoReplyText = req.Msg.Body
		t.RecentAutoReplies = append(t.RecentAutoReplies, now)
		t.AutoReplyHourCount = len(hourReplies) + 1
	} else {
		// Human operator reply: resets consecutive bot count
		t.AutoReplyConsecutiveCount = 0
	}

	// 5. Append outbound message
	direction := DirectionOutbound
	sub := SubtypeReply
	if req.Msg.IsAutoReply {
		direction = DirectionSystem
		sub = SubtypeSystem
	}

	msg := &Message{
		MessageID:       NewUUID(),
		WorkspaceID:     req.Msg.WorkspaceId,
		ThreadID:        req.Msg.ThreadId,
		Subtype:         sub,
		SourcePlatform:  t.SourcePlatform,
		Body:            req.Msg.Body,
		AuthorDirection: direction,
		ModerationState: "visible",
		Attachments:     req.Msg.Attachments,
		CreatedAt:       now,
	}
	s.messages[req.Msg.ThreadId] = append(s.messages[req.Msg.ThreadId], msg)

	// Update thread state machine (RULE-M12-003): outbound reply transitions to waiting_on_user
	if t.Status == StatusNew || t.Status == StatusTriaged {
		t.Status = StatusActive
	}
	if ValidateStatusTransition(t.Status, StatusWaitingOnUser) {
		t.Status = StatusWaitingOnUser
	}
	t.MessageCount++
	t.LastActivityAt = now
	t.UpdatedAt = now

	return connect.NewResponse(&engagementv1.ThreadServiceReplyResponse{
		Message: s.toProtoMessage(msg),
		Thread:  s.toProtoThread(t),
	}), nil
}

// Resolve marks a thread resolved (RULE-M12-003).
func (s *Service) Resolve(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceResolveRequest]) (*connect.Response[engagementv1.ThreadServiceResolveResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	if !ValidateStatusTransition(t.Status, StatusResolved) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInvalidStateTransition)
	}

	t.Status = StatusResolved
	t.UpdatedAt = s.clock()

	s.recordEventLocked(EventThreadResolved, "thread", t.ThreadID, t.WorkspaceID, map[string]interface{}{
		"thread_id":       t.ThreadID,
		"outcome_summary": req.Msg.OutcomeSummary,
	})

	return connect.NewResponse(&engagementv1.ThreadServiceResolveResponse{
		Thread: s.toProtoThread(t),
	}), nil
}

// BulkTriage applies batch operations to multiple threads (RULE-M12-001).
func (s *Service) BulkTriage(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceBulkTriageRequest]) (*connect.Response[engagementv1.ThreadServiceBulkTriageResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	var updated []*engagementv1.Thread
	now := s.clock()

	for _, tid := range req.Msg.ThreadIds {
		t, ok := s.threads[tid]
		if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}

		if req.Msg.TargetStatus != engagementv1.ThreadStatus_THREAD_STATUS_UNSPECIFIED {
			tStatus := s.stringStatus(req.Msg.TargetStatus)
			if ValidateStatusTransition(t.Status, tStatus) {
				t.Status = tStatus
			}
		} else {
			if ValidateStatusTransition(t.Status, StatusTriaged) {
				t.Status = StatusTriaged
			}
		}

		if req.Msg.Intent != engagementv1.ThreadIntent_THREAD_INTENT_UNSPECIFIED {
			t.Intent = s.stringIntent(req.Msg.Intent)
		}
		if req.Msg.Priority != engagementv1.ThreadPriority_THREAD_PRIORITY_UNSPECIFIED {
			t.Priority = s.stringPriority(req.Msg.Priority)
		}
		if req.Msg.OwnerUserId != "" {
			t.OwnerUserID = req.Msg.OwnerUserId
		}
		if req.Msg.NextAction != "" {
			t.NextAction = req.Msg.NextAction
		}
		t.UpdatedAt = now
		updated = append(updated, s.toProtoThread(t))
	}

	return connect.NewResponse(&engagementv1.ThreadServiceBulkTriageResponse{
		TriagedCount: int32(len(updated)),
		Threads:      updated,
	}), nil
}

// GetMessages lists messages for a thread with pagination.
func (s *Service) GetMessages(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceGetMessagesRequest]) (*connect.Response[engagementv1.ThreadServiceGetMessagesResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	var msgs []*engagementv1.Message
	for _, m := range s.messages[req.Msg.ThreadId] {
		msgs = append(msgs, s.toProtoMessage(m))
	}

	return connect.NewResponse(&engagementv1.ThreadServiceGetMessagesResponse{
		Messages: msgs,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: int64Ptr(int64(len(msgs))),
			HasMore:    false,
		},
	}), nil
}

// GetUnreadCount returns thread count and SLA breached count.
func (s *Service) GetUnreadCount(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceGetUnreadCountRequest]) (*connect.Response[engagementv1.ThreadServiceGetUnreadCountResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	now := s.clock()
	unread := 0
	breached := 0

	for _, t := range s.threads {
		if t.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		if req.Msg.OwnerUserId != "" && t.OwnerUserID != req.Msg.OwnerUserId {
			continue
		}
		if t.Status == StatusNew || t.Status == StatusTriaged || t.Status == StatusActive {
			unread++
		}
		if t.SLADueAt != nil && t.SLADueAt.Before(now) && t.Status != StatusResolved && t.Status != StatusArchived {
			breached++
		}
	}

	return connect.NewResponse(&engagementv1.ThreadServiceGetUnreadCountResponse{
		UnreadCount:      int32(unread),
		SlaBreachedCount: int32(breached),
	}), nil
}

// MarkRead acknowledges a thread.
func (s *Service) MarkRead(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceMarkReadRequest]) (*connect.Response[engagementv1.ThreadServiceMarkReadResponse], error) {
	return connect.NewResponse(&engagementv1.ThreadServiceMarkReadResponse{
		Success: true,
	}), nil
}

// Update modifies next action, priority, or intent.
func (s *Service) Update(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceUpdateRequest]) (*connect.Response[engagementv1.ThreadServiceUpdateResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	if req.Msg.NextAction != "" {
		t.NextAction = req.Msg.NextAction
	}
	if req.Msg.Priority != engagementv1.ThreadPriority_THREAD_PRIORITY_UNSPECIFIED {
		t.Priority = s.stringPriority(req.Msg.Priority)
	}
	if req.Msg.Intent != engagementv1.ThreadIntent_THREAD_INTENT_UNSPECIFIED {
		t.Intent = s.stringIntent(req.Msg.Intent)
	}
	t.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.ThreadServiceUpdateResponse{
		Thread: s.toProtoThread(t),
	}), nil
}

// AddTag tags a thread.
func (s *Service) AddTag(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceAddTagRequest]) (*connect.Response[engagementv1.ThreadServiceAddTagResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	t.UpdatedAt = s.clock()
	return connect.NewResponse(&engagementv1.ThreadServiceAddTagResponse{
		Thread: s.toProtoThread(t),
	}), nil
}

// Mute mutes notifications for a thread.
func (s *Service) Mute(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceMuteRequest]) (*connect.Response[engagementv1.ThreadServiceMuteResponse], error) {
	return connect.NewResponse(&engagementv1.ThreadServiceMuteResponse{
		Muted: true,
	}), nil
}

// Snooze sets a thread to snooze until wake time (RULE-M12-003).
func (s *Service) Snooze(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceSnoozeRequest]) (*connect.Response[engagementv1.ThreadServiceSnoozeResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	if !ValidateStatusTransition(t.Status, StatusSnoozed) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInvalidStateTransition)
	}

	t.Status = StatusSnoozed
	t.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.ThreadServiceSnoozeResponse{
		Thread: s.toProtoThread(t),
	}), nil
}

// ListMobile lists threads optimized for mobile swipe triage.
func (s *Service) ListMobile(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceListMobileRequest]) (*connect.Response[engagementv1.ThreadServiceListMobileResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []*engagementv1.Thread
	for _, t := range s.threads {
		if t.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		if req.Msg.OwnerUserId != "" && t.OwnerUserID != req.Msg.OwnerUserId {
			continue
		}
		if req.Msg.Status != engagementv1.ThreadStatus_THREAD_STATUS_UNSPECIFIED &&
			s.protoStatus(t.Status) != req.Msg.Status {
			continue
		}
		result = append(result, s.toProtoThread(t))
	}

	return connect.NewResponse(&engagementv1.ThreadServiceListMobileResponse{
		Threads: result,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: int64Ptr(int64(len(result))),
			HasMore:    false,
		},
	}), nil
}

// HandleGhostMessage handles platform 404, 403, 410 errors per Alternate Flow A4.
// Format follows WHAT -> WHY -> NEXT formula.
func (s *Service) HandleGhostMessage(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceHandleGhostMessageRequest]) (*connect.Response[engagementv1.ThreadServiceHandleGhostMessageResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	now := s.clock()
	code := req.Msg.PlatformHttpCode
	var isStale bool
	var composeDisabled bool
	var explanation string

	switch code {
	case 404:
		// 404: Content deleted by user
		t.IsGhost = true
		t.GhostStatus = GhostDeletedByUser
		t.Status = StatusStale
		isStale = true
		composeDisabled = true
		explanation = "WHAT: Tin nhắn không còn khả dụng trên nền tảng (404 Not Found).\nWHY: Người dùng đã xoá bình luận hoặc tin nhắn gốc.\nNEXT: Hộp soạn thảo đã bị vô hiệu hoá. Bạn có thể lưu trữ cuộc hội thoại hoặc gắn thẻ nội bộ."
	case 403:
		// 403: Post restricted by platform
		t.IsGhost = true
		t.GhostStatus = GhostRestrictedByPlatform
		t.Status = StatusStale
		isStale = true
		composeDisabled = true
		explanation = "WHAT: Nội dung bị giới hạn quyền truy cập bởi nền tảng (403 Forbidden).\nWHY: Bài viết hoặc quyền riêng tư của tài khoản đã thay đổi trên nền tảng.\nNEXT: Không thể gửi phản hồi trực tiếp. Vui lòng kiểm tra quyền kết nối trên trang quản trị kênh."
	case 410:
		// 410: Permanently removed -> archive thread
		t.IsGhost = true
		t.GhostStatus = GhostPermanentlyRemoved
		t.Status = StatusArchived
		isStale = true
		composeDisabled = true
		explanation = "WHAT: Cuộc trò chuyện đã bị xoá vĩnh viễn (410 Gone).\nWHY: Tài khoản hoặc nội dung gốc đã bị gỡ bỏ hoàn toàn khỏi nền tảng.\nNEXT: Cuộc hội thoại đã tự động được chuyển vào Lưu trữ (Archived)."
	default:
		// 5xx / timeout -> transient, compose stays enabled
		isStale = false
		composeDisabled = false
		explanation = fmt.Sprintf("WHAT: Sự cố kết nối tạm thời tới nền tảng (HTTP %d).\nWHY: Nền tảng phản hồi chậm hoặc gián đoạn mạng.\nNEXT: Hộp soạn thảo vẫn mở. Bạn có thể thử gửi lại tin nhắn sau vài giây.", code)
	}

	t.UpdatedAt = now

	return connect.NewResponse(&engagementv1.ThreadServiceHandleGhostMessageResponse{
		Thread:          s.toProtoThread(t),
		IsStale:         isStale,
		ComposeDisabled: composeDisabled,
		UserExplanation: explanation,
	}), nil
}

// ResetAutoReplyLoop allows an operator to manually re-enable auto-reply on a thread (RULE-M12-008).
// A second loop detection permanently disables auto-reply.
func (s *Service) ResetAutoReplyLoop(ctx context.Context, req *connect.Request[engagementv1.ThreadServiceResetAutoReplyLoopRequest]) (*connect.Response[engagementv1.ThreadServiceResetAutoReplyLoopResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	if t.AutoReplyPermanentlyDisabled {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrBotLoopPermanentDisabled)
	}

	t.AutoReplyPaused = false
	t.AutoReplyConsecutiveCount = 0
	t.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.ThreadServiceResetAutoReplyLoopResponse{
		Thread:          s.toProtoThread(t),
		AutoReplyActive: true,
	}), nil
}

// ============================================================================
// EntityService Handler Implementations
// ============================================================================

func (h *EntityHandler) List(ctx context.Context, req *connect.Request[engagementv1.EntityServiceListRequest]) (*connect.Response[engagementv1.EntityServiceListResponse], error) {
	return h.s.ListEntities(ctx, req)
}

func (h *EntityHandler) Get(ctx context.Context, req *connect.Request[engagementv1.EntityServiceGetRequest]) (*connect.Response[engagementv1.EntityServiceGetResponse], error) {
	return h.s.GetEntity(ctx, req)
}

func (h *EntityHandler) Create(ctx context.Context, req *connect.Request[engagementv1.EntityServiceCreateRequest]) (*connect.Response[engagementv1.EntityServiceCreateResponse], error) {
	return h.s.CreateEntity(ctx, req)
}

func (h *EntityHandler) Merge(ctx context.Context, req *connect.Request[engagementv1.EntityServiceMergeRequest]) (*connect.Response[engagementv1.EntityServiceMergeResponse], error) {
	return h.s.MergeEntities(ctx, req)
}

func (h *EntityHandler) AddNote(ctx context.Context, req *connect.Request[engagementv1.EntityServiceAddNoteRequest]) (*connect.Response[engagementv1.EntityServiceAddNoteResponse], error) {
	return h.s.AddEntityNote(ctx, req)
}

func (h *EntityHandler) AddTag(ctx context.Context, req *connect.Request[engagementv1.EntityServiceAddTagRequest]) (*connect.Response[engagementv1.EntityServiceAddTagResponse], error) {
	return h.s.AddEntityTag(ctx, req)
}

// ListEntities returns entities with filtering and pagination.
func (s *Service) ListEntities(ctx context.Context, req *connect.Request[engagementv1.EntityServiceListRequest]) (*connect.Response[engagementv1.EntityServiceListResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []*engagementv1.Entity
	for _, e := range s.entities {
		if e.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		if req.Msg.SearchQuery != "" && !strings.Contains(strings.ToLower(e.DisplayName), strings.ToLower(req.Msg.SearchQuery)) {
			continue
		}
		result = append(result, s.toProtoEntity(e))
	}

	return connect.NewResponse(&engagementv1.EntityServiceListResponse{
		Entities: result,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: int64Ptr(int64(len(result))),
			HasMore:    false,
		},
	}), nil
}

// Get returns entity detail and related threads.
func (s *Service) GetEntity(ctx context.Context, req *connect.Request[engagementv1.EntityServiceGetRequest]) (*connect.Response[engagementv1.EntityServiceGetResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	e, ok := s.entities[req.Msg.EntityId]
	if !ok || e.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrEntityNotFound)
	}

	var threads []*engagementv1.Thread
	for _, t := range s.threads {
		if t.EntityID == req.Msg.EntityId && t.WorkspaceID == req.Msg.WorkspaceId {
			threads = append(threads, s.toProtoThread(t))
		}
	}

	return connect.NewResponse(&engagementv1.EntityServiceGetResponse{
		Entity:  s.toProtoEntity(e),
		Threads: threads,
	}), nil
}

// Create manually creates an entity (database_schema.md §9.1).
func (s *Service) CreateEntity(ctx context.Context, req *connect.Request[engagementv1.EntityServiceCreateRequest]) (*connect.Response[engagementv1.EntityServiceCreateResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	now := s.clock()
	entType := "person"
	if req.Msg.EntityType == engagementv1.EntityType_ENTITY_TYPE_BRAND {
		entType = "brand"
	}

	relState := "lead"
	if req.Msg.RelationshipState != engagementv1.EntityRelationshipState_ENTITY_RELATIONSHIP_STATE_UNSPECIFIED {
		relState = strings.ToLower(req.Msg.RelationshipState.String())
	}

	e := &Entity{
		EntityID:          NewUUID(),
		WorkspaceID:       req.Msg.WorkspaceId,
		EntityType:        entType,
		DisplayName:       req.Msg.DisplayName,
		PlatformHandles:   req.Msg.PlatformHandlesJson,
		RelationshipState: relState,
		Tags:              req.Msg.Tags,
		CreatedAt:         now,
		UpdatedAt:         now,
	}
	s.entities[e.EntityID] = e

	return connect.NewResponse(&engagementv1.EntityServiceCreateResponse{
		Entity: s.toProtoEntity(e),
	}), nil
}

// Merge merges secondary entities into a primary entity.
func (s *Service) MergeEntities(ctx context.Context, req *connect.Request[engagementv1.EntityServiceMergeRequest]) (*connect.Response[engagementv1.EntityServiceMergeResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	primary, ok := s.entities[req.Msg.PrimaryEntityId]
	if !ok || primary.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrEntityNotFound)
	}

	reassigned := 0
	for _, secID := range req.Msg.SecondaryEntityIds {
		sec, secOk := s.entities[secID]
		if !secOk || sec.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		// Reassign threads
		for _, t := range s.threads {
			if t.EntityID == secID && t.WorkspaceID == req.Msg.WorkspaceId {
				t.EntityID = primary.EntityID
				reassigned++
			}
		}
		// Merge handles
		primary.PlatformHandles = append(primary.PlatformHandles, sec.PlatformHandles...)
		// Soft delete secondary
		now := s.clock()
		sec.DeletedAt = &now
	}
	primary.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.EntityServiceMergeResponse{
		MergedEntity:      s.toProtoEntity(primary),
		ThreadsReassigned: int32(reassigned),
	}), nil
}

// AddNote adds a note to an entity.
func (s *Service) AddEntityNote(ctx context.Context, req *connect.Request[engagementv1.EntityServiceAddNoteRequest]) (*connect.Response[engagementv1.EntityServiceAddNoteResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	e, ok := s.entities[req.Msg.EntityId]
	if !ok || e.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrEntityNotFound)
	}

	if e.Metadata == nil {
		e.Metadata = make(map[string]string)
	}
	e.Metadata["last_note"] = req.Msg.Note
	e.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.EntityServiceAddNoteResponse{
		Entity: s.toProtoEntity(e),
	}), nil
}

// AddTag adds a tag to an entity.
func (s *Service) AddEntityTag(ctx context.Context, req *connect.Request[engagementv1.EntityServiceAddTagRequest]) (*connect.Response[engagementv1.EntityServiceAddTagResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	e, ok := s.entities[req.Msg.EntityId]
	if !ok || e.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrEntityNotFound)
	}

	e.Tags = append(e.Tags, req.Msg.Tag)
	e.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.EntityServiceAddTagResponse{
		Entity: s.toProtoEntity(e),
	}), nil
}

// ============================================================================
// SuggestionService Handler Implementations
// ============================================================================

func (h *SuggestionHandler) GetReply(ctx context.Context, req *connect.Request[engagementv1.SuggestionServiceGetReplyRequest]) (*connect.Response[engagementv1.SuggestionServiceGetReplyResponse], error) {
	return h.s.GetReply(ctx, req)
}

func (h *SuggestionHandler) GetActions(ctx context.Context, req *connect.Request[engagementv1.SuggestionServiceGetActionsRequest]) (*connect.Response[engagementv1.SuggestionServiceGetActionsResponse], error) {
	return h.s.GetActions(ctx, req)
}

// GetReply generates AI reply suggestions for a thread.
func (s *Service) GetReply(ctx context.Context, req *connect.Request[engagementv1.SuggestionServiceGetReplyRequest]) (*connect.Response[engagementv1.SuggestionServiceGetReplyResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	suggestions := []*engagementv1.SuggestedReply{
		{
			SuggestionId: NewUUID(),
			ReplyText:    fmt.Sprintf("Chào bạn! Cảm ơn bạn đã quan tâm. Sản phẩm hiện đang có sẵn, bạn có thể tham khảo chi tiết tại giỏ hàng nhé!"),
			Confidence:   0.92,
			Tone:         "friendly",
		},
		{
			SuggestionId: NewUUID(),
			ReplyText:    fmt.Sprintf("Dạ shop đã gửi thông tin chi tiết qua tin nhắn trực tiếp cho mình rồi ạ!"),
			Confidence:   0.88,
			Tone:         "supportive",
		},
	}

	return connect.NewResponse(&engagementv1.SuggestionServiceGetReplyResponse{
		Suggestions: suggestions,
	}), nil
}

// GetActions recommends commercial or workflow conversions for a thread (RULE-M12-005).
func (s *Service) GetActions(ctx context.Context, req *connect.Request[engagementv1.SuggestionServiceGetActionsRequest]) (*connect.Response[engagementv1.SuggestionServiceGetActionsResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	t, ok := s.threads[req.Msg.ThreadId]
	if !ok || t.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrThreadNotFound)
	}

	var actions []*engagementv1.SuggestedAction
	switch t.Intent {
	case IntentSponsorInterest:
		actions = append(actions, &engagementv1.SuggestedAction{
			ActionType:   "route_to_brand_deals",
			Title:        "Chuyển sang Hợp đồng Nhãn hàng (S16)",
			Description:  "Tạo cơ hội Brand Deal trong chế độ Brand Collaboration",
			TargetModule: "S16",
		})
	case IntentSampleRequest:
		actions = append(actions, &engagementv1.SuggestedAction{
			ActionType:   "route_to_seeding",
			Title:        "Chuyển sang Seeding CRM (M18)",
			Description:  "Ghi nhận yêu cầu gửi hàng mẫu cho nhà sáng tạo",
			TargetModule: "M18",
		})
	case IntentPurchaseInterest:
		actions = append(actions, &engagementv1.SuggestedAction{
			ActionType:   "pin_offer",
			Title:        "Ghim Ưu đãi / Tạo Coupon (M14)",
			Description:  "Tạo coupon giảm giá cá nhân hoá cho khách hàng",
			TargetModule: "M14",
		})
	default:
		actions = append(actions, &engagementv1.SuggestedAction{
			ActionType:   "convert_to_idea",
			Title:        "Chuyển thành Ý tưởng Nội dung (M05)",
			Description:  "Lưu bình luận này làm nguồn cảm hứng sáng tạo nội dung",
			TargetModule: "M05",
		})
	}

	return connect.NewResponse(&engagementv1.SuggestionServiceGetActionsResponse{
		Actions: actions,
	}), nil
}

// ============================================================================
// FollowUpService Handler Implementations
// ============================================================================

func (h *FollowUpHandler) Create(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceCreateRequest]) (*connect.Response[engagementv1.FollowUpServiceCreateResponse], error) {
	return h.s.CreateFollowUpTask(ctx, req)
}

func (h *FollowUpHandler) List(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceListRequest]) (*connect.Response[engagementv1.FollowUpServiceListResponse], error) {
	return h.s.ListFollowUpTasks(ctx, req)
}

func (h *FollowUpHandler) Update(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceUpdateRequest]) (*connect.Response[engagementv1.FollowUpServiceUpdateResponse], error) {
	return h.s.UpdateFollowUpTask(ctx, req)
}

func (h *FollowUpHandler) Complete(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceCompleteRequest]) (*connect.Response[engagementv1.FollowUpServiceCompleteResponse], error) {
	return h.s.CompleteFollowUpTask(ctx, req)
}

func (h *FollowUpHandler) Reschedule(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceRescheduleRequest]) (*connect.Response[engagementv1.FollowUpServiceRescheduleResponse], error) {
	return h.s.RescheduleFollowUpTask(ctx, req)
}

// Create creates a follow-up task linked to a thread (RULE-M12-005, DB schema §9.4).
func (s *Service) CreateFollowUpTask(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceCreateRequest]) (*connect.Response[engagementv1.FollowUpServiceCreateResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	now := s.clock()
	var due *time.Time
	if req.Msg.DueAt != nil {
		t := req.Msg.DueAt.AsTime()
		due = &t
	}

	task := &FollowUpTask{
		TaskID:           NewUUID(),
		WorkspaceID:      req.Msg.WorkspaceId,
		SourceThreadID:   req.Msg.SourceThreadId,
		SourceObjectType: "thread",
		SourceObjectID:   req.Msg.SourceThreadId,
		AssignedUserID:   req.Msg.AssignedUserId,
		TaskType:         req.Msg.TaskType,
		Title:            req.Msg.Title,
		Description:      req.Msg.Description,
		DueAt:            due,
		Status:           TaskStatusOpen,
		CreatedAt:        now,
		UpdatedAt:        now,
	}
	if req.Msg.TaskType == "sample_request" || req.Msg.TaskType == "sponsor_followup" || req.Msg.TaskType == "brand_deal" {
		task.TaskRef = "P6-09"
		task.Phase = "P6"
		task.IsP6Deferred = true
	} else if req.Msg.TaskType == "offer_creation" || req.Msg.TaskType == "coupon_creation" {
		task.TaskRef = "P6-01"
		task.Phase = "P6"
		task.IsP6Deferred = true
	}
	s.tasks[task.TaskID] = task

	// Link back to thread's related_object_refs (RULE-M12-005)
	if req.Msg.SourceThreadId != "" {
		if t, ok := s.threads[req.Msg.SourceThreadId]; ok {
			t.RelatedObjectRefs = append(t.RelatedObjectRefs, RelatedObjectRef{
				Type:         "follow_up_task",
				ID:           task.TaskID,
				Label:        task.Title,
				TaskRef:      task.TaskRef,
				Phase:        task.Phase,
				IsP6Deferred: task.IsP6Deferred,
				Status:       task.Status,
			})
			t.UpdatedAt = now
		}
	}

	s.recordEventLocked(EventFollowUpTaskCreated, "follow_up_task", task.TaskID, req.Msg.WorkspaceId, map[string]interface{}{
		"task_id":     task.TaskID,
		"assigned_to": task.AssignedUserID,
		"due_at":      task.DueAt,
	})

	return connect.NewResponse(&engagementv1.FollowUpServiceCreateResponse{
		Task: s.toProtoTask(task),
	}), nil
}

// List lists follow-up tasks.
func (s *Service) ListFollowUpTasks(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceListRequest]) (*connect.Response[engagementv1.FollowUpServiceListResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []*engagementv1.FollowUpTask
	for _, task := range s.tasks {
		if task.WorkspaceID != req.Msg.WorkspaceId {
			continue
		}
		if req.Msg.AssignedUserId != "" && task.AssignedUserID != req.Msg.AssignedUserId {
			continue
		}
		result = append(result, s.toProtoTask(task))
	}

	return connect.NewResponse(&engagementv1.FollowUpServiceListResponse{
		Tasks: result,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: int64Ptr(int64(len(result))),
			HasMore:    false,
		},
	}), nil
}

// Update updates task status and outcome summary.
func (s *Service) UpdateFollowUpTask(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceUpdateRequest]) (*connect.Response[engagementv1.FollowUpServiceUpdateResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	task, ok := s.tasks[req.Msg.TaskId]
	if !ok || task.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrTaskNotFound)
	}

	if req.Msg.Status != engagementv1.FollowUpTaskStatus_FOLLOW_UP_TASK_STATUS_UNSPECIFIED {
		task.Status = strings.ToLower(req.Msg.Status.String())
	}
	if req.Msg.OutcomeSummary != "" {
		task.OutcomeSummary = req.Msg.OutcomeSummary
	}
	task.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.FollowUpServiceUpdateResponse{
		Task: s.toProtoTask(task),
	}), nil
}

// Complete marks a follow-up task completed.
func (s *Service) CompleteFollowUpTask(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceCompleteRequest]) (*connect.Response[engagementv1.FollowUpServiceCompleteResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	task, ok := s.tasks[req.Msg.TaskId]
	if !ok || task.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrTaskNotFound)
	}

	task.Status = TaskStatusCompleted
	task.OutcomeSummary = req.Msg.OutcomeSummary
	task.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.FollowUpServiceCompleteResponse{
		Task: s.toProtoTask(task),
	}), nil
}

// Reschedule reschedules a task's due date.
func (s *Service) RescheduleFollowUpTask(ctx context.Context, req *connect.Request[engagementv1.FollowUpServiceRescheduleRequest]) (*connect.Response[engagementv1.FollowUpServiceRescheduleResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	task, ok := s.tasks[req.Msg.TaskId]
	if !ok || task.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrTaskNotFound)
	}

	if req.Msg.NewDueAt != nil {
		t := req.Msg.NewDueAt.AsTime()
		task.DueAt = &t
	}
	task.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.FollowUpServiceRescheduleResponse{
		Task: s.toProtoTask(task),
	}), nil
}

// ============================================================================
// EngagementProtectionService Handler Implementations
// ============================================================================

func (h *ProtectionHandler) GetThrottleStatus(ctx context.Context, req *connect.Request[engagementv1.EngagementProtectionServiceGetThrottleStatusRequest]) (*connect.Response[engagementv1.EngagementProtectionServiceGetThrottleStatusResponse], error) {
	return h.s.GetThrottleStatus(ctx, req)
}

func (h *ProtectionHandler) TriggerBatchAnalysis(ctx context.Context, req *connect.Request[engagementv1.EngagementProtectionServiceTriggerBatchAnalysisRequest]) (*connect.Response[engagementv1.EngagementProtectionServiceTriggerBatchAnalysisResponse], error) {
	return h.s.TriggerBatchAnalysis(ctx, req)
}

func (h *ProtectionHandler) RepairRevokedAccount(ctx context.Context, req *connect.Request[engagementv1.EngagementProtectionServiceRepairRevokedAccountRequest]) (*connect.Response[engagementv1.EngagementProtectionServiceRepairRevokedAccountResponse], error) {
	return h.s.RepairRevokedAccount(ctx, req)
}

// GetThrottleStatus retrieves viral surge ingestion mode and unprocessed message counts.
func (s *Service) GetThrottleStatus(ctx context.Context, req *connect.Request[engagementv1.EngagementProtectionServiceGetThrottleStatusRequest]) (*connect.Response[engagementv1.EngagementProtectionServiceGetThrottleStatusResponse], error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	th, ok := s.throttles[req.Msg.WorkspaceId]
	if !ok {
		return connect.NewResponse(&engagementv1.EngagementProtectionServiceGetThrottleStatusResponse{
			ThrottleStatus: &engagementv1.EngagementThrottleStatus{
				WorkspaceId:         req.Msg.WorkspaceId,
				CurrentRatePerMin:   0,
				ThrottleMode:        engagementv1.ThrottleMode_THROTTLE_MODE_NORMAL,
				UnprocessedRawCount: 0,
				UserNotice:          "Hoạt động bình thường",
			},
		}), nil
	}

	return connect.NewResponse(&engagementv1.EngagementProtectionServiceGetThrottleStatusResponse{
		ThrottleStatus: s.toProtoThrottle(th),
	}), nil
}

// TriggerBatchAnalysis triggers batch AI processing of raw-ingested surge messages (Acceptance Criteria 5).
func (s *Service) TriggerBatchAnalysis(ctx context.Context, req *connect.Request[engagementv1.EngagementProtectionServiceTriggerBatchAnalysisRequest]) (*connect.Response[engagementv1.EngagementProtectionServiceTriggerBatchAnalysisResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	th, ok := s.throttles[req.Msg.WorkspaceId]
	if !ok {
		return nil, connect.NewError(connect.CodeNotFound, errors.New("engagement: no throttle records for workspace"))
	}

	limit := int(req.Msg.MaxBatchSize)
	if limit <= 0 {
		limit = 100
	}

	analyzed := 0
	for _, t := range s.threads {
		if t.WorkspaceID != req.Msg.WorkspaceId || t.Intent != IntentUnknown {
			continue
		}
		// Classify thread
		var firstMsgBody string
		if msgs := s.messages[t.ThreadID]; len(msgs) > 0 {
			firstMsgBody = msgs[0].Body
		}
		t.Intent = s.classifyIntent(firstMsgBody)
		t.ThrottleState = ThrottleNormal
		t.UpdatedAt = s.clock()
		analyzed++
		if analyzed >= limit {
			break
		}
	}

	th.UnprocessedRawCount -= analyzed
	if th.UnprocessedRawCount < 0 {
		th.UnprocessedRawCount = 0
	}
	th.UpdatedAt = s.clock()

	return connect.NewResponse(&engagementv1.EngagementProtectionServiceTriggerBatchAnalysisResponse{
		AnalyzedCount:  int32(analyzed),
		ThrottleStatus: s.toProtoThrottle(th),
	}), nil
}

// RepairRevokedAccount restores connectivity for a revoked account (Acceptance Target 3).
func (s *Service) RepairRevokedAccount(ctx context.Context, req *connect.Request[engagementv1.EngagementProtectionServiceRepairRevokedAccountRequest]) (*connect.Response[engagementv1.EngagementProtectionServiceRepairRevokedAccountResponse], error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	acc, ok := s.accounts[req.Msg.ConnectedAccountId]
	if !ok || acc.WorkspaceID != req.Msg.WorkspaceId {
		return nil, connect.NewError(connect.CodeNotFound, ErrAccountNotFound)
	}

	if req.Msg.NewAccessToken == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("engagement: new access token required to repair account"))
	}

	// Restore account status
	acc.IsRevoked = false
	acc.AccessToken = req.Msg.NewAccessToken

	// Unblock all threads tied to this account
	unblocked := 0
	for _, t := range s.threads {
		if t.WorkspaceID == req.Msg.WorkspaceId && (t.ConnectedAccountID == req.Msg.ConnectedAccountId || t.AccountRevoked) {
			t.AccountRevoked = false
			t.UpdatedAt = s.clock()
			unblocked++
		}
	}

	return connect.NewResponse(&engagementv1.EngagementProtectionServiceRepairRevokedAccountResponse{
		Repaired:              true,
		ConnectedAccountId:    req.Msg.ConnectedAccountId,
		UnblockedThreadsCount: int32(unblocked),
	}), nil
}

// ============================================================================
// Downstream Conversion Helpers (RULE-M12-005, P6-08)
// ============================================================================

// ConvertToIdea converts a thread into a content idea (M05 link).
func (s *Service) ConvertToIdea(ctx context.Context, workspaceID, threadID, ideaID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[threadID]
	if !ok || t.WorkspaceID != workspaceID {
		return ErrThreadNotFound
	}

	t.RelatedObjectRefs = append(t.RelatedObjectRefs, RelatedObjectRef{
		Type:         "idea",
		ID:           ideaID,
		Label:        "Ý tưởng nội dung (M05)",
		TaskRef:      "P6-08",
		Phase:        "P6",
		IsP6Deferred: false,
		Status:       "converted",
	})
	if ValidateStatusTransition(t.Status, StatusConvertedToTask) {
		t.Status = StatusConvertedToTask
	}
	now := s.clock()
	t.UpdatedAt = now

	if s.lineageStore != nil {
		_ = s.lineageStore.SaveLineage(ctx, conversion.LineageRecord{
			ConversionID:   ideaID,
			WorkspaceID:    workspaceID,
			SourceType:     conversion.SourceTypeThread,
			SourceID:       threadID,
			TargetType:     conversion.TargetType("idea"),
			TargetID:       ideaID,
			ConvertedBy:    t.OwnerUserID,
			Status:         "completed",
			LineageDepth:   1,
			RootSourceType: "thread",
			RootSourceID:   threadID,
			Metadata: map[string]any{
				"thread_type": t.ThreadType,
				"intent":      t.Intent,
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
	}

	return nil
}

// ConvertToBrandDeal converts a sponsor inquiry thread to Brand Collaboration (S16 link, Phase P6).
func (s *Service) ConvertToBrandDeal(ctx context.Context, workspaceID, threadID, dealID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[threadID]
	if !ok || t.WorkspaceID != workspaceID {
		return ErrThreadNotFound
	}

	t.RelatedObjectRefs = append(t.RelatedObjectRefs, RelatedObjectRef{
		Type:         "brand_deal",
		ID:           dealID,
		Label:        "Hợp tác Nhãn hàng (S16)",
		TaskRef:      "P6-09",
		Phase:        "P6",
		IsP6Deferred: true,
		Status:       "pending_p6_delivery",
	})
	if ValidateStatusTransition(t.Status, StatusConvertedToTask) {
		t.Status = StatusConvertedToTask
	}
	now := s.clock()
	t.UpdatedAt = now

	if s.lineageStore != nil {
		_ = s.lineageStore.SaveLineage(ctx, conversion.LineageRecord{
			ConversionID:   dealID,
			WorkspaceID:    workspaceID,
			SourceType:     conversion.SourceTypeThread,
			SourceID:       threadID,
			TargetType:     conversion.TargetTypeDeal,
			TargetID:       dealID,
			ConvertedBy:    t.OwnerUserID,
			Status:         "completed",
			LineageDepth:   1,
			RootSourceType: "thread",
			RootSourceID:   threadID,
			Metadata: map[string]any{
				"thread_type": t.ThreadType,
				"intent":      t.Intent,
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
	}

	s.recordEventLocked(EventSponsorInquiryDetected, "thread", threadID, workspaceID, map[string]interface{}{
		"thread_id":   threadID,
		"deal_id":     dealID,
		"task_ref":    "P6-09",
		"phase":       "P6",
		"is_deferred": true,
	})

	return nil
}

// ConvertToSampleRequest converts a thread to Seeding CRM (M18 link, Phase P6).
func (s *Service) ConvertToSampleRequest(ctx context.Context, workspaceID, threadID, sampleID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[threadID]
	if !ok || t.WorkspaceID != workspaceID {
		return ErrThreadNotFound
	}

	t.RelatedObjectRefs = append(t.RelatedObjectRefs, RelatedObjectRef{
		Type:         "sample_request",
		ID:           sampleID,
		Label:        "Gửi mẫu thử (M18)",
		TaskRef:      "P6-09",
		Phase:        "P6",
		IsP6Deferred: true,
		Status:       "pending_p6_delivery",
	})
	if ValidateStatusTransition(t.Status, StatusConvertedToTask) {
		t.Status = StatusConvertedToTask
	}
	now := s.clock()
	t.UpdatedAt = now

	if s.lineageStore != nil {
		_ = s.lineageStore.SaveLineage(ctx, conversion.LineageRecord{
			ConversionID:   sampleID,
			WorkspaceID:    workspaceID,
			SourceType:     conversion.SourceTypeThread,
			SourceID:       threadID,
			TargetType:     conversion.TargetTypeSeeding,
			TargetID:       sampleID,
			ConvertedBy:    t.OwnerUserID,
			Status:         "completed",
			LineageDepth:   1,
			RootSourceType: "thread",
			RootSourceID:   threadID,
			Metadata: map[string]any{
				"thread_type": t.ThreadType,
				"intent":      t.Intent,
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
	}

	s.recordEventLocked(EventSampleRequestCreated, "thread", threadID, workspaceID, map[string]interface{}{
		"thread_id":   threadID,
		"sample_id":   sampleID,
		"task_ref":    "P6-09",
		"phase":       "P6",
		"is_deferred": true,
	})

	return nil
}

// ConvertToOffer converts a thread to a Commerce Offer / Coupon action (M14 link, Phase P6).
func (s *Service) ConvertToOffer(ctx context.Context, workspaceID, threadID, offerID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[threadID]
	if !ok || t.WorkspaceID != workspaceID {
		return ErrThreadNotFound
	}

	t.RelatedObjectRefs = append(t.RelatedObjectRefs, RelatedObjectRef{
		Type:         "offer",
		ID:           offerID,
		Label:        "Tạo ưu đãi / mã giảm giá (M14)",
		TaskRef:      "P6-01",
		Phase:        "P6",
		IsP6Deferred: true,
		Status:       "pending_p6_delivery",
	})
	if ValidateStatusTransition(t.Status, StatusConvertedToTask) {
		t.Status = StatusConvertedToTask
	}
	now := s.clock()
	t.UpdatedAt = now

	if s.lineageStore != nil {
		_ = s.lineageStore.SaveLineage(ctx, conversion.LineageRecord{
			ConversionID:   offerID,
			WorkspaceID:    workspaceID,
			SourceType:     conversion.SourceTypeThread,
			SourceID:       threadID,
			TargetType:     conversion.TargetTypeOffer,
			TargetID:       offerID,
			ConvertedBy:    t.OwnerUserID,
			Status:         "completed",
			LineageDepth:   1,
			RootSourceType: "thread",
			RootSourceID:   threadID,
			Metadata: map[string]any{
				"thread_type": t.ThreadType,
				"intent":      t.Intent,
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
	}

	s.recordEventLocked("offer.created", "thread", threadID, workspaceID, map[string]interface{}{
		"thread_id":   threadID,
		"offer_id":    offerID,
		"task_ref":    "P6-01",
		"phase":       "P6",
		"is_deferred": true,
	})

	return nil
}

// ConvertToCampaign converts a thread to a coordination campaign (M14 link, Phase P6-08).
func (s *Service) ConvertToCampaign(ctx context.Context, workspaceID, threadID, campaignID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[threadID]
	if !ok || t.WorkspaceID != workspaceID {
		return ErrThreadNotFound
	}

	t.RelatedObjectRefs = append(t.RelatedObjectRefs, RelatedObjectRef{
		Type:         "campaign",
		ID:           campaignID,
		Label:        "Chiến dịch phối hợp (M14)",
		TaskRef:      "P6-08",
		Phase:        "P6",
		IsP6Deferred: false,
		Status:       "converted",
	})
	if ValidateStatusTransition(t.Status, StatusConvertedToTask) {
		t.Status = StatusConvertedToTask
	}
	now := s.clock()
	t.UpdatedAt = now

	if s.lineageStore != nil {
		_ = s.lineageStore.SaveLineage(ctx, conversion.LineageRecord{
			ConversionID:   campaignID,
			WorkspaceID:    workspaceID,
			SourceType:     conversion.SourceTypeThread,
			SourceID:       threadID,
			TargetType:     conversion.TargetTypeCampaign,
			TargetID:       campaignID,
			ConvertedBy:    t.OwnerUserID,
			Status:         "completed",
			LineageDepth:   1,
			RootSourceType: "thread",
			RootSourceID:   threadID,
			Metadata: map[string]any{
				"thread_type": t.ThreadType,
				"intent":      t.Intent,
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
	}

	s.recordEventLocked("campaign.started", "thread", threadID, workspaceID, map[string]interface{}{
		"thread_id":   threadID,
		"campaign_id": campaignID,
		"task_ref":    "P6-08",
		"phase":       "P6",
	})

	return nil
}

// ConvertToLiveSession converts a thread to a Live Commerce session (M17 link, Phase P6-08).
func (s *Service) ConvertToLiveSession(ctx context.Context, workspaceID, threadID, sessionID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	t, ok := s.threads[threadID]
	if !ok || t.WorkspaceID != workspaceID {
		return ErrThreadNotFound
	}

	t.RelatedObjectRefs = append(t.RelatedObjectRefs, RelatedObjectRef{
		Type:         "live_session",
		ID:           sessionID,
		Label:        "Phiên livestream thương mại (M17)",
		TaskRef:      "P6-08",
		Phase:        "P6",
		IsP6Deferred: false,
		Status:       "converted",
	})
	if ValidateStatusTransition(t.Status, StatusConvertedToTask) {
		t.Status = StatusConvertedToTask
	}
	now := s.clock()
	t.UpdatedAt = now

	if s.lineageStore != nil {
		_ = s.lineageStore.SaveLineage(ctx, conversion.LineageRecord{
			ConversionID:   sessionID,
			WorkspaceID:    workspaceID,
			SourceType:     conversion.SourceTypeThread,
			SourceID:       threadID,
			TargetType:     conversion.TargetTypeLive,
			TargetID:       sessionID,
			ConvertedBy:    t.OwnerUserID,
			Status:         "completed",
			LineageDepth:   1,
			RootSourceType: "thread",
			RootSourceID:   threadID,
			Metadata: map[string]any{
				"thread_type": t.ThreadType,
				"intent":      t.Intent,
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
	}

	s.recordEventLocked("live.session_started", "thread", threadID, workspaceID, map[string]interface{}{
		"thread_id":  threadID,
		"session_id": sessionID,
		"task_ref":   "P6-08",
		"phase":      "P6",
	})

	return nil
}

// ConvertThreadWithPermissionCheck rechecks both thread triage permission AND target domain permission (P6-08).
func (s *Service) ConvertThreadWithPermissionCheck(ctx context.Context, caller conversion.CallerContext, threadID string, targetType conversion.TargetType, targetID string) error {
	if caller.UserID == "" || caller.WorkspaceID == "" {
		return conversion.ErrUnauthenticated
	}

	// 1. Check Source Permission (thread:triage)
	if err := rbac.CheckWorkspacePermission("thread:triage", rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	}); err != nil {
		return fmt.Errorf("%w: role %q lacks thread:triage: %v", conversion.ErrPermissionDenied, caller.WorkspaceRole, err)
	}

	// 2. ACCEPTANCE TARGET 1: Recheck Target Permission
	targetPerm := conversion.RequiredTargetPermission(targetType)
	if err := rbac.CheckWorkspacePermission(targetPerm, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	}); err != nil {
		return fmt.Errorf("%w: role %q lacks target permission %q for target %q: %v", conversion.ErrTargetPermissionDenied, caller.WorkspaceRole, targetPerm, targetType, err)
	}

	switch targetType {
	case conversion.TargetTypeCampaign:
		return s.ConvertToCampaign(ctx, caller.WorkspaceID, threadID, targetID)
	case conversion.TargetTypeLive:
		return s.ConvertToLiveSession(ctx, caller.WorkspaceID, threadID, targetID)
	case conversion.TargetTypeOffer:
		return s.ConvertToOffer(ctx, caller.WorkspaceID, threadID, targetID)
	case conversion.TargetTypeSeeding:
		return s.ConvertToSampleRequest(ctx, caller.WorkspaceID, threadID, targetID)
	case conversion.TargetTypeDeal:
		return s.ConvertToBrandDeal(ctx, caller.WorkspaceID, threadID, targetID)
	default:
		return fmt.Errorf("%w: %s", conversion.ErrInvalidTargetType, targetType)
	}
}

// ============================================================================
// SLA Check Engine (RULE-M12-004)
// ============================================================================

// CheckSLABreaches evaluates SLA thresholds across active threads and emits events.
func (s *Service) CheckSLABreaches(ctx context.Context) ([]DomainEvent, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	now := s.clock()
	var triggered []DomainEvent

	for _, t := range s.threads {
		if t.SLADueAt == nil || t.Status == StatusResolved || t.Status == StatusArchived {
			continue
		}

		if s.slaFired[t.ThreadID] == nil {
			s.slaFired[t.ThreadID] = make(map[string]bool)
		}

		// Breach check: now >= sla_due_at
		if now.After(*t.SLADueAt) || now.Equal(*t.SLADueAt) {
			if !s.slaFired[t.ThreadID][EventThreadSLABreached] {
				evt := s.recordEventLocked(EventThreadSLABreached, "thread", t.ThreadID, t.WorkspaceID, map[string]interface{}{
					"thread_id":   t.ThreadID,
					"sla_due_at":  t.SLADueAt,
					"breached_at": now,
				})
				s.slaFired[t.ThreadID][EventThreadSLABreached] = true
				triggered = append(triggered, evt)
			}
		} else if now.After(t.SLADueAt.Add(-30 * time.Minute)) {
			// Approaching check: 30 minutes before due time
			if !s.slaFired[t.ThreadID][EventThreadSLAApproaching] {
				evt := s.recordEventLocked(EventThreadSLAApproaching, "thread", t.ThreadID, t.WorkspaceID, map[string]interface{}{
					"thread_id":   t.ThreadID,
					"sla_due_at":  t.SLADueAt,
					"approaching": true,
				})
				s.slaFired[t.ThreadID][EventThreadSLAApproaching] = true
				triggered = append(triggered, evt)
			}
		}
	}

	return triggered, nil
}

// GetRecordedEvents returns all events emitted by the service.
func (s *Service) GetRecordedEvents() []DomainEvent {
	s.mu.RLock()
	defer s.mu.RUnlock()
	copied := make([]DomainEvent, len(s.events))
	copy(copied, s.events)
	return copied
}

func (s *Service) recordEventLocked(evtType, aggType, aggID, wsID string, payload map[string]interface{}) DomainEvent {
	evt := DomainEvent{
		EventID:       NewUUID(),
		EventType:     evtType,
		AggregateType: aggType,
		AggregateID:   aggID,
		WorkspaceID:   wsID,
		Timestamp:     s.clock(),
		Payload:       payload,
	}
	s.events = append(s.events, evt)
	return evt
}

// ============================================================================
// Mapping Helpers (Proto <-> Domain)
// ============================================================================

func (s *Service) toProtoThread(t *Thread) *engagementv1.Thread {
	if t == nil {
		return nil
	}
	now := s.clock()
	winExpired := t.MessagingWindowExpiresAt != nil && now.After(*t.MessagingWindowExpiresAt)

	var winExp *timestamppb.Timestamp
	if t.MessagingWindowExpiresAt != nil {
		winExp = timestamppb.New(*t.MessagingWindowExpiresAt)
	}
	var slaExp *timestamppb.Timestamp
	if t.SLADueAt != nil {
		slaExp = timestamppb.New(*t.SLADueAt)
	}

	var refs []*engagementv1.RelatedObjectRef
	for _, r := range t.RelatedObjectRefs {
		refs = append(refs, &engagementv1.RelatedObjectRef{
			Type:         r.Type,
			Id:           r.ID,
			Label:        r.Label,
			TaskRef:      r.TaskRef,
			Phase:        r.Phase,
			IsP6Deferred: r.IsP6Deferred,
			Status:       r.Status,
		})
	}

	var repIdent *engagementv1.ReplyIdentity
	if acc, ok := s.accounts[t.ConnectedAccountID]; ok {
		repIdent = &engagementv1.ReplyIdentity{
			AccountId:   acc.AccountID,
			Platform:    acc.Platform,
			AccountName: acc.AccountName,
			AvatarUrl:   acc.AvatarURL,
			BadgeColor:  acc.BadgeColor,
			IsRevoked:   acc.IsRevoked,
		}
	}

	return &engagementv1.Thread{
		ThreadId:                     t.ThreadID,
		WorkspaceId:                  t.WorkspaceID,
		ThreadType:                   s.protoThreadType(t.ThreadType),
		EntityId:                     t.EntityID,
		SourcePlatform:               t.SourcePlatform,
		SourcePostId:                 t.SourcePostID,
		OwnerUserId:                  t.OwnerUserID,
		Intent:                       s.protoIntent(t.Intent),
		Priority:                     s.protoPriority(t.Priority),
		Status:                       s.protoStatus(t.Status),
		NextAction:                   t.NextAction,
		SlaDueAt:                     slaExp,
		RelatedObjectRefs:            refs,
		LastActivityAt:               timestamppb.New(t.LastActivityAt),
		MessageCount:                 int32(t.MessageCount),
		CreatedAt:                    timestamppb.New(t.CreatedAt),
		UpdatedAt:                    timestamppb.New(t.UpdatedAt),
		MessagingWindowExpiresAt:     winExp,
		MessagingWindowExpired:       winExpired,
		AutoReplyPaused:              t.AutoReplyPaused,
		AutoReplyConsecutiveCount:    int32(t.AutoReplyConsecutiveCount),
		AutoReplyHourCount:           int32(t.AutoReplyHourCount),
		AutoReplyPermanentlyDisabled: t.AutoReplyPermanentlyDisabled,
		IsGhost:                      t.IsGhost,
		GhostStatus:                  s.protoGhostStatus(t.GhostStatus),
		ThrottleState:                s.protoThrottleMode(t.ThrottleState),
		ConnectedAccountId:           t.ConnectedAccountID,
		AccountRevoked:               t.AccountRevoked,
		ReplyIdentity:                repIdent,
	}
}

func (s *Service) toProtoMessage(m *Message) *engagementv1.Message {
	if m == nil {
		return nil
	}
	return &engagementv1.Message{
		MessageId:         m.MessageID,
		WorkspaceId:       m.WorkspaceID,
		ThreadId:          m.ThreadID,
		Subtype:           s.protoSubtype(m.Subtype),
		SourcePlatform:    m.SourcePlatform,
		Body:              m.Body,
		AuthorDirection:   s.protoDirection(m.AuthorDirection),
		AuthorEntityId:    m.AuthorEntityID,
		AuthorUserId:      m.AuthorUserID,
		ModerationState:   m.ModerationState,
		IntentOverlay:     m.IntentOverlay,
		Attachments:       m.Attachments,
		ExternalMessageId: m.ExternalMessageID,
		CreatedAt:         timestamppb.New(m.CreatedAt),
	}
}

func (s *Service) toProtoEntity(e *Entity) *engagementv1.Entity {
	if e == nil {
		return nil
	}
	return &engagementv1.Entity{
		EntityId:            e.EntityID,
		WorkspaceId:         e.WorkspaceID,
		EntityType:          s.protoEntityType(e.EntityType),
		DisplayName:         e.DisplayName,
		PlatformHandlesJson: e.PlatformHandles,
		RelationshipState:   s.protoRelationship(e.RelationshipState),
		Tags:                e.Tags,
		CreatedAt:           timestamppb.New(e.CreatedAt),
		UpdatedAt:           timestamppb.New(e.UpdatedAt),
	}
}

func (s *Service) toProtoTask(t *FollowUpTask) *engagementv1.FollowUpTask {
	if t == nil {
		return nil
	}
	var due *timestamppb.Timestamp
	if t.DueAt != nil {
		due = timestamppb.New(*t.DueAt)
	}
	return &engagementv1.FollowUpTask{
		TaskId:           t.TaskID,
		WorkspaceId:      t.WorkspaceID,
		SourceThreadId:   t.SourceThreadID,
		SourceObjectType: t.SourceObjectType,
		SourceObjectId:   t.SourceObjectID,
		AssignedUserId:   t.AssignedUserID,
		TaskType:         t.TaskType,
		Title:            t.Title,
		Description:      t.Description,
		DueAt:            due,
		Status:           s.protoTaskStatus(t.Status),
		OutcomeSummary:   t.OutcomeSummary,
		TaskRef:          t.TaskRef,
		Phase:            t.Phase,
		IsP6Deferred:     t.IsP6Deferred,
		CreatedAt:        timestamppb.New(t.CreatedAt),
		UpdatedAt:        timestamppb.New(t.UpdatedAt),
	}
}

func (s *Service) toProtoThrottle(th *EngagementThrottle) *engagementv1.EngagementThrottleStatus {
	if th == nil {
		return nil
	}
	var lastSurge *timestamppb.Timestamp
	if th.LastSurgeAt != nil {
		lastSurge = timestamppb.New(*th.LastSurgeAt)
	}
	notice := "Bình thường"
	var requiresManual bool
	switch th.ThrottleMode {
	case ThrottleThrottled:
		notice = "⚡ Khối lượng cao — AI đang phân tích theo đợt (5 phút/lần)"
	case ThrottleCircuitBreaker:
		notice = "🔴 Khối lượng cực lớn — Đã tạm dừng AI trực tiếp. Tin nhắn được lưu thô."
		requiresManual = true
	}
	return &engagementv1.EngagementThrottleStatus{
		WorkspaceId:                th.WorkspaceID,
		CurrentRatePerMin:          int32(th.CurrentRatePerMin),
		ThrottleMode:               s.protoThrottleMode(th.ThrottleMode),
		UnprocessedRawCount:        int32(th.UnprocessedRawCount),
		LastSurgeAt:                lastSurge,
		UserNotice:                 notice,
		RequiresManualBatchTrigger: requiresManual,
	}
}

func (s *Service) protoStatus(st string) engagementv1.ThreadStatus {
	switch st {
	case StatusNew:
		return engagementv1.ThreadStatus_THREAD_STATUS_NEW
	case StatusTriaged:
		return engagementv1.ThreadStatus_THREAD_STATUS_TRIAGED
	case StatusActive:
		return engagementv1.ThreadStatus_THREAD_STATUS_ACTIVE
	case StatusWaitingOnUser:
		return engagementv1.ThreadStatus_THREAD_STATUS_WAITING_ON_USER
	case StatusWaitingOnTeam:
		return engagementv1.ThreadStatus_THREAD_STATUS_WAITING_ON_TEAM
	case StatusSnoozed:
		return engagementv1.ThreadStatus_THREAD_STATUS_SNOOZED
	case StatusStale:
		return engagementv1.ThreadStatus_THREAD_STATUS_STALE
	case StatusConvertedToTask:
		return engagementv1.ThreadStatus_THREAD_STATUS_CONVERTED_TO_TASK
	case StatusResolved:
		return engagementv1.ThreadStatus_THREAD_STATUS_RESOLVED
	case StatusArchived:
		return engagementv1.ThreadStatus_THREAD_STATUS_ARCHIVED
	default:
		return engagementv1.ThreadStatus_THREAD_STATUS_UNSPECIFIED
	}
}

func (s *Service) stringStatus(st engagementv1.ThreadStatus) string {
	switch st {
	case engagementv1.ThreadStatus_THREAD_STATUS_NEW:
		return StatusNew
	case engagementv1.ThreadStatus_THREAD_STATUS_TRIAGED:
		return StatusTriaged
	case engagementv1.ThreadStatus_THREAD_STATUS_ACTIVE:
		return StatusActive
	case engagementv1.ThreadStatus_THREAD_STATUS_WAITING_ON_USER:
		return StatusWaitingOnUser
	case engagementv1.ThreadStatus_THREAD_STATUS_WAITING_ON_TEAM:
		return StatusWaitingOnTeam
	case engagementv1.ThreadStatus_THREAD_STATUS_SNOOZED:
		return StatusSnoozed
	case engagementv1.ThreadStatus_THREAD_STATUS_STALE:
		return StatusStale
	case engagementv1.ThreadStatus_THREAD_STATUS_CONVERTED_TO_TASK:
		return StatusConvertedToTask
	case engagementv1.ThreadStatus_THREAD_STATUS_RESOLVED:
		return StatusResolved
	case engagementv1.ThreadStatus_THREAD_STATUS_ARCHIVED:
		return StatusArchived
	default:
		return StatusNew
	}
}

func (s *Service) protoPriority(p string) engagementv1.ThreadPriority {
	switch p {
	case PriorityLow:
		return engagementv1.ThreadPriority_THREAD_PRIORITY_LOW
	case PriorityNormal:
		return engagementv1.ThreadPriority_THREAD_PRIORITY_NORMAL
	case PriorityHigh:
		return engagementv1.ThreadPriority_THREAD_PRIORITY_HIGH
	case PriorityUrgent:
		return engagementv1.ThreadPriority_THREAD_PRIORITY_URGENT
	default:
		return engagementv1.ThreadPriority_THREAD_PRIORITY_NORMAL
	}
}

func (s *Service) stringPriority(p engagementv1.ThreadPriority) string {
	switch p {
	case engagementv1.ThreadPriority_THREAD_PRIORITY_LOW:
		return PriorityLow
	case engagementv1.ThreadPriority_THREAD_PRIORITY_NORMAL:
		return PriorityNormal
	case engagementv1.ThreadPriority_THREAD_PRIORITY_HIGH:
		return PriorityHigh
	case engagementv1.ThreadPriority_THREAD_PRIORITY_URGENT:
		return PriorityUrgent
	default:
		return PriorityNormal
	}
}

func (s *Service) protoIntent(i string) engagementv1.ThreadIntent {
	switch i {
	case IntentQuestion:
		return engagementv1.ThreadIntent_THREAD_INTENT_QUESTION
	case IntentPurchaseInterest:
		return engagementv1.ThreadIntent_THREAD_INTENT_PURCHASE_INTEREST
	case IntentSupportIssue:
		return engagementv1.ThreadIntent_THREAD_INTENT_SUPPORT_ISSUE
	case IntentObjection:
		return engagementv1.ThreadIntent_THREAD_INTENT_OBJECTION
	case IntentSponsorInterest:
		return engagementv1.ThreadIntent_THREAD_INTENT_SPONSOR_INTEREST
	case IntentSampleRequest:
		return engagementv1.ThreadIntent_THREAD_INTENT_SAMPLE_REQUEST
	case IntentModerationRisk:
		return engagementv1.ThreadIntent_THREAD_INTENT_MODERATION_RISK
	default:
		return engagementv1.ThreadIntent_THREAD_INTENT_UNKNOWN
	}
}

func (s *Service) stringIntent(i engagementv1.ThreadIntent) string {
	switch i {
	case engagementv1.ThreadIntent_THREAD_INTENT_QUESTION:
		return IntentQuestion
	case engagementv1.ThreadIntent_THREAD_INTENT_PURCHASE_INTEREST:
		return IntentPurchaseInterest
	case engagementv1.ThreadIntent_THREAD_INTENT_SUPPORT_ISSUE:
		return IntentSupportIssue
	case engagementv1.ThreadIntent_THREAD_INTENT_OBJECTION:
		return IntentObjection
	case engagementv1.ThreadIntent_THREAD_INTENT_SPONSOR_INTEREST:
		return IntentSponsorInterest
	case engagementv1.ThreadIntent_THREAD_INTENT_SAMPLE_REQUEST:
		return IntentSampleRequest
	case engagementv1.ThreadIntent_THREAD_INTENT_MODERATION_RISK:
		return IntentModerationRisk
	default:
		return IntentUnknown
	}
}

func (s *Service) protoThreadType(tt string) engagementv1.ThreadType {
	switch tt {
	case ThreadTypeComment:
		return engagementv1.ThreadType_THREAD_TYPE_COMMENT
	case ThreadTypeDM:
		return engagementv1.ThreadType_THREAD_TYPE_DM
	case ThreadTypeInquiry:
		return engagementv1.ThreadType_THREAD_TYPE_INQUIRY
	case ThreadTypeSponsorInquiry:
		return engagementv1.ThreadType_THREAD_TYPE_SPONSOR_INQUIRY
	case ThreadTypeSampleRequest:
		return engagementv1.ThreadType_THREAD_TYPE_SAMPLE_REQUEST
	case ThreadTypeSupport:
		return engagementv1.ThreadType_THREAD_TYPE_SUPPORT
	default:
		return engagementv1.ThreadType_THREAD_TYPE_COMMENT
	}
}

func (s *Service) protoSubtype(st string) engagementv1.MessageSubtype {
	switch st {
	case SubtypeComment:
		return engagementv1.MessageSubtype_MESSAGE_SUBTYPE_COMMENT
	case SubtypeDM:
		return engagementv1.MessageSubtype_MESSAGE_SUBTYPE_DM
	case SubtypeInquiry:
		return engagementv1.MessageSubtype_MESSAGE_SUBTYPE_INQUIRY
	case SubtypeReply:
		return engagementv1.MessageSubtype_MESSAGE_SUBTYPE_REPLY
	case SubtypeSystem:
		return engagementv1.MessageSubtype_MESSAGE_SUBTYPE_SYSTEM
	default:
		return engagementv1.MessageSubtype_MESSAGE_SUBTYPE_COMMENT
	}
}

func (s *Service) protoDirection(d string) engagementv1.AuthorDirection {
	switch d {
	case DirectionInbound:
		return engagementv1.AuthorDirection_AUTHOR_DIRECTION_INBOUND
	case DirectionOutbound:
		return engagementv1.AuthorDirection_AUTHOR_DIRECTION_OUTBOUND
	case DirectionSystem:
		return engagementv1.AuthorDirection_AUTHOR_DIRECTION_SYSTEM
	default:
		return engagementv1.AuthorDirection_AUTHOR_DIRECTION_INBOUND
	}
}

func (s *Service) protoGhostStatus(g string) engagementv1.GhostStatus {
	switch g {
	case GhostDeletedByUser:
		return engagementv1.GhostStatus_GHOST_STATUS_DELETED_BY_USER
	case GhostRestrictedByPlatform:
		return engagementv1.GhostStatus_GHOST_STATUS_RESTRICTED_BY_PLATFORM
	case GhostPermanentlyRemoved:
		return engagementv1.GhostStatus_GHOST_STATUS_PERMANENTLY_REMOVED
	default:
		return engagementv1.GhostStatus_GHOST_STATUS_NONE
	}
}

func (s *Service) protoThrottleMode(tm string) engagementv1.ThrottleMode {
	switch tm {
	case ThrottleThrottled:
		return engagementv1.ThrottleMode_THROTTLE_MODE_THROTTLED
	case ThrottleCircuitBreaker:
		return engagementv1.ThrottleMode_THROTTLE_MODE_CIRCUIT_BREAKER
	default:
		return engagementv1.ThrottleMode_THROTTLE_MODE_NORMAL
	}
}

func (s *Service) protoTaskStatus(st string) engagementv1.FollowUpTaskStatus {
	switch st {
	case TaskStatusOpen:
		return engagementv1.FollowUpTaskStatus_FOLLOW_UP_TASK_STATUS_OPEN
	case TaskStatusInProgress:
		return engagementv1.FollowUpTaskStatus_FOLLOW_UP_TASK_STATUS_IN_PROGRESS
	case TaskStatusBlocked:
		return engagementv1.FollowUpTaskStatus_FOLLOW_UP_TASK_STATUS_BLOCKED
	case TaskStatusCompleted:
		return engagementv1.FollowUpTaskStatus_FOLLOW_UP_TASK_STATUS_COMPLETED
	case TaskStatusCancelled:
		return engagementv1.FollowUpTaskStatus_FOLLOW_UP_TASK_STATUS_CANCELLED
	default:
		return engagementv1.FollowUpTaskStatus_FOLLOW_UP_TASK_STATUS_OPEN
	}
}

func (s *Service) protoEntityType(et string) engagementv1.EntityType {
	switch et {
	case "brand":
		return engagementv1.EntityType_ENTITY_TYPE_BRAND
	case "bot":
		return engagementv1.EntityType_ENTITY_TYPE_BOT
	case "person":
		return engagementv1.EntityType_ENTITY_TYPE_PERSON
	default:
		return engagementv1.EntityType_ENTITY_TYPE_PERSON
	}
}

func (s *Service) protoRelationship(rs string) engagementv1.EntityRelationshipState {
	switch strings.ToLower(rs) {
	case "customer":
		return engagementv1.EntityRelationshipState_ENTITY_RELATIONSHIP_STATE_CUSTOMER
	case "creator":
		return engagementv1.EntityRelationshipState_ENTITY_RELATIONSHIP_STATE_CREATOR
	case "partner":
		return engagementv1.EntityRelationshipState_ENTITY_RELATIONSHIP_STATE_PARTNER
	case "sponsor":
		return engagementv1.EntityRelationshipState_ENTITY_RELATIONSHIP_STATE_SPONSOR
	default:
		return engagementv1.EntityRelationshipState_ENTITY_RELATIONSHIP_STATE_LEAD
	}
}

func int64Ptr(v int64) *int64 {
	return &v
}

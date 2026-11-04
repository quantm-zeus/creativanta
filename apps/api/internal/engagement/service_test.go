package engagement

import (
	"context"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	engagementv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/engagement/v1"
)

// setupTestService initializes a Service with a mockable clock and test account.
func setupTestService(t *testing.T) (*Service, func(time.Duration), string, string) {
	currentTime := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time {
		return currentTime
	}
	advance := func(d time.Duration) {
		currentTime = currentTime.Add(d)
	}

	svc := NewService(&ServiceConfig{Clock: clock})

	wsID := "ws-test-engagement-1"
	accID := "acc-tiktok-eng-01"
	svc.RegisterConnectedAccount(&ConnectedAccount{
		AccountID:   accID,
		WorkspaceID: wsID,
		Platform:    "tiktok",
		AccountName: "@creativanta_store",
		AvatarURL:   "https://cdn.example.com/avatar.png",
		BadgeColor:  "#FE2C55",
		IsRevoked:   false,
		AccessToken: "valid_oauth_token_123",
	})

	return svc, advance, wsID, accID
}

// ============================================================================
// ACCEPTANCE TARGET 1: Messaging-Window Denial
// ============================================================================

func TestAcceptanceTarget1_MessagingWindowDenial(t *testing.T) {
	svc, advance, wsID, accID := setupTestService(t)
	ctx := context.Background()
	threadID := "thread-win-001"

	// 1. Inbound message received -> opens 24h reply window
	thread, msg, err := svc.IngestInboundMessage(ctx, wsID, threadID, SubtypeComment, "tiktok", "Giá bao nhiêu thế shop?", "entity-user-1")
	if err != nil {
		t.Fatalf("IngestInboundMessage failed: %v", err)
	}
	if thread.MessagingWindowExpiresAt == nil {
		t.Fatalf("expected MessagingWindowExpiresAt to be set")
	}
	expectedExp := msg.CreatedAt.Add(24 * time.Hour)
	if !thread.MessagingWindowExpiresAt.Equal(expectedExp) {
		t.Fatalf("expected expiration at %v, got %v", expectedExp, *thread.MessagingWindowExpiresAt)
	}

	// 2. Normal reply within 24h window (e.g., 2 hours later) -> SUCCEEDS
	advance(2 * time.Hour)
	replyResp, err := svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Dạ giá sản phẩm là 299.000đ ạ!",
		TargetAccountId: accID,
	}))
	if err != nil {
		t.Fatalf("expected reply within 24h window to succeed, got %v", err)
	}
	if replyResp.Msg.Thread.Status != engagementv1.ThreadStatus_THREAD_STATUS_WAITING_ON_USER {
		t.Fatalf("expected status WAITING_ON_USER after outbound reply, got %v", replyResp.Msg.Thread.Status)
	}

	// 3. Fast-forward clock past 24-hour limit (advance 23 hours more -> total 25 hours since inbound)
	advance(23 * time.Hour)

	// Outbound standard reply MUST be DENIED with CodeFailedPrecondition and ErrMessagingWindowExpired
	_, err = svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Bạn ơi shop vẫn còn hàng nhé!",
		TargetAccountId: accID,
	}))
	if err == nil {
		t.Fatalf("expected reply after 24h to fail with ErrMessagingWindowExpired, got nil")
	}
	connectErr, ok := err.(*connect.Error)
	if !ok || connectErr.Code() != connect.CodeFailedPrecondition {
		t.Fatalf("expected connect.CodeFailedPrecondition, got code %v: %v", connectErr.Code(), err)
	}
	if !strings.Contains(err.Error(), "messaging window expired") {
		t.Fatalf("expected error message to mention messaging window expired, got %v", err)
	}

	// 4. Inbound user interaction re-engages and refreshes the 24-hour window
	_, _, err = svc.IngestInboundMessage(ctx, wsID, threadID, SubtypeComment, "tiktok", "Shop có freeship không ạ?", "entity-user-1")
	if err != nil {
		t.Fatalf("re-engagement IngestInboundMessage failed: %v", err)
	}

	// Now outbound reply SUCCEEDS again
	advance(10 * time.Minute)
	replyResp2, err := svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Dạ shop có hỗ trợ freeship toàn quốc ạ!",
		TargetAccountId: accID,
	}))
	if err != nil {
		t.Fatalf("expected reply after re-engagement to succeed, got %v", err)
	}
	if replyResp2.Msg.Message.Body != "Dạ shop có hỗ trợ freeship toàn quốc ạ!" {
		t.Fatalf("unexpected message body: %s", replyResp2.Msg.Message.Body)
	}
}

// ============================================================================
// ACCEPTANCE TARGET 2: Bot-Loop & Viral Surge Handling
// ============================================================================

func TestAcceptanceTarget2_BotLoopHandling(t *testing.T) {
	svc, advance, wsID, accID := setupTestService(t)
	ctx := context.Background()
	threadID := "thread-loop-001"

	// Initial inbound user message
	_, _, err := svc.IngestInboundMessage(ctx, wsID, threadID, SubtypeDM, "tiktok", "Xin chào!", "entity-user-2")
	if err != nil {
		t.Fatalf("IngestInboundMessage failed: %v", err)
	}

	// 1. Send 3 consecutive auto-replies without user response
	distinctBodies := []string{
		"Alpha distinct auto reply message one",
		"Beta distinct auto reply message two",
		"Gamma distinct auto reply message three",
	}
	for i := 0; i < 3; i++ {
		advance(1 * time.Minute)
		_, err := svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
			WorkspaceId:     wsID,
			ThreadId:        threadID,
			Body:            distinctBodies[i],
			TargetAccountId: accID,
			IsAutoReply:     true,
		}))
		if err != nil {
			t.Fatalf("auto-reply %d failed: %v", i+1, err)
		}
	}

	// 4th consecutive auto-reply MUST be blocked by bot-loop circuit breaker (>= 3 consecutive bot replies)
	advance(1 * time.Minute)
	_, err = svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Delta distinct auto reply message four",
		TargetAccountId: accID,
		IsAutoReply:     true,
	}))
	if err == nil {
		t.Fatalf("expected 4th consecutive auto-reply to trigger bot-loop circuit breaker, got nil")
	}
	if !strings.Contains(err.Error(), "bot-loop circuit breaker") {
		t.Fatalf("expected bot-loop circuit breaker error, got %v", err)
	}

	// Verify EventBotLoopDetected was recorded
	events := svc.GetRecordedEvents()
	var foundLoopEvt bool
	for _, e := range events {
		if e.EventType == EventBotLoopDetected {
			foundLoopEvt = true
			break
		}
	}
	if !foundLoopEvt {
		t.Fatalf("expected EventBotLoopDetected event in recorded events")
	}

	// 2. Operator manually re-enables auto-reply (1st reset)
	resetResp, err := svc.ResetAutoReplyLoop(ctx, connect.NewRequest(&engagementv1.ThreadServiceResetAutoReplyLoopRequest{
		WorkspaceId: wsID,
		ThreadId:    threadID,
	}))
	if err != nil {
		t.Fatalf("ResetAutoReplyLoop failed: %v", err)
	}
	if !resetResp.Msg.AutoReplyActive {
		t.Fatalf("expected AutoReplyActive=true after manual reset")
	}

	// 3. User responds -> resets consecutive bot counter
	_, _, err = svc.IngestInboundMessage(ctx, wsID, threadID, SubtypeDM, "tiktok", "Tôi có thắc mắc khác", "entity-user-2")
	if err != nil {
		t.Fatalf("user ingest failed: %v", err)
	}

	// 4. Test Text Similarity > 80% circuit breaker
	advance(1 * time.Minute)
	_, err = svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Cảm ơn bạn đã liên hệ chúng tôi hôm nay",
		TargetAccountId: accID,
		IsAutoReply:     true,
	}))
	if err != nil {
		t.Fatalf("first auto-reply failed: %v", err)
	}

	// Second auto-reply with > 80% similarity
	advance(10 * time.Second)
	_, err = svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Cảm ơn bạn đã liên hệ chúng tôi ngay hôm nay", // almost identical
		TargetAccountId: accID,
		IsAutoReply:     true,
	}))
	if err == nil {
		t.Fatalf("expected similarity check to fail, got nil")
	}
	if !strings.Contains(err.Error(), "similarity >80%") {
		t.Fatalf("expected similarity error, got %v", err)
	}

	// 5. Repeated loop trigger permanently disables auto-reply on thread
	// Thread has now hit loop detection twice
	_, err = svc.ResetAutoReplyLoop(ctx, connect.NewRequest(&engagementv1.ThreadServiceResetAutoReplyLoopRequest{
		WorkspaceId: wsID,
		ThreadId:    threadID,
	}))
	if err == nil {
		t.Fatalf("expected 2nd loop reset to be permanently disabled, got nil")
	}
	if !strings.Contains(err.Error(), "permanently disabled") {
		t.Fatalf("expected permanently disabled error, got %v", err)
	}
}

func TestAcceptanceTarget2_ViralSurgeHandling(t *testing.T) {
	svc, advance, wsID, _ := setupTestService(t)
	ctx := context.Background()

	// 1. Normal rate (< 100 msg/min): Real-time AI classification is performed
	thNormal, _, err := svc.IngestInboundMessage(ctx, wsID, "thread-norm-1", SubtypeComment, "tiktok", "Giá bao nhiêu thế bạn ơi?", "entity-norm-1")
	if err != nil {
		t.Fatalf("IngestInboundMessage failed: %v", err)
	}
	if thNormal.ThrottleState != ThrottleNormal {
		t.Fatalf("expected ThrottleNormal, got %s", thNormal.ThrottleState)
	}
	if thNormal.Intent != IntentPurchaseInterest {
		t.Fatalf("expected real-time classification to identify IntentPurchaseInterest, got %s", thNormal.Intent)
	}

	// 2. Simulate viral surge: Ingest 550 messages within the same minute (> 500 msg/min threshold)
	for i := 1; i <= 510; i++ {
		advance(50 * time.Millisecond)
		tid := "thread-surge-" + strings.Repeat("x", i%5)
		th, _, err := svc.IngestInboundMessage(ctx, wsID, tid, SubtypeComment, "tiktok", "Hay quá bạn ơi "+string(rune(i)), "entity-surge")
		if err != nil {
			t.Fatalf("surge ingest %d failed: %v", i, err)
		}
		if i > 500 {
			// Ingestion must now be in circuit breaker mode
			if th.ThrottleState != ThrottleCircuitBreaker {
				t.Fatalf("expected ThrottleCircuitBreaker at message %d, got %s", i, th.ThrottleState)
			}
		}
	}

	// 3. In circuit breaker mode: Inbound messages are saved raw with intent = unknown
	thSurge, _, err := svc.IngestInboundMessage(ctx, wsID, "thread-surge-late", SubtypeComment, "tiktok", "Hợp tác tài trợ nhé shop", "entity-surge-late")
	if err != nil {
		t.Fatalf("late surge ingest failed: %v", err)
	}
	if thSurge.ThrottleState != ThrottleCircuitBreaker {
		t.Fatalf("expected circuit breaker state, got %s", thSurge.ThrottleState)
	}
	if thSurge.Intent != IntentUnknown {
		t.Fatalf("expected real-time AI to be paused (intent=unknown), got %s", thSurge.Intent)
	}

	// 4. Verify throttle status reflects unprocessed raw count and high volume banner
	statusResp, err := svc.GetThrottleStatus(ctx, connect.NewRequest(&engagementv1.EngagementProtectionServiceGetThrottleStatusRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("GetThrottleStatus failed: %v", err)
	}
	if statusResp.Msg.ThrottleStatus.ThrottleMode != engagementv1.ThrottleMode_THROTTLE_MODE_CIRCUIT_BREAKER {
		t.Fatalf("expected proto ThrottleMode CIRCUIT_BREAKER, got %v", statusResp.Msg.ThrottleStatus.ThrottleMode)
	}
	if !statusResp.Msg.ThrottleStatus.RequiresManualBatchTrigger {
		t.Fatalf("expected RequiresManualBatchTrigger=true")
	}
	if !strings.Contains(statusResp.Msg.ThrottleStatus.UserNotice, "🔴") {
		t.Fatalf("expected red banner notice, got %s", statusResp.Msg.ThrottleStatus.UserNotice)
	}

	// 5. Operator triggers manual batch analysis of unprocessed messages (Acceptance Criteria 5)
	batchResp, err := svc.TriggerBatchAnalysis(ctx, connect.NewRequest(&engagementv1.EngagementProtectionServiceTriggerBatchAnalysisRequest{
		WorkspaceId:  wsID,
		MaxBatchSize: 50,
	}))
	if err != nil {
		t.Fatalf("TriggerBatchAnalysis failed: %v", err)
	}
	if batchResp.Msg.AnalyzedCount == 0 {
		t.Fatalf("expected at least 1 message analyzed")
	}

	// Check that the late surge message was classified properly
	getResp, err := svc.Get(ctx, connect.NewRequest(&engagementv1.ThreadServiceGetRequest{
		WorkspaceId: wsID,
		ThreadId:    "thread-surge-late",
	}))
	if err != nil {
		t.Fatalf("Get thread failed: %v", err)
	}
	if getResp.Msg.Thread.Intent != engagementv1.ThreadIntent_THREAD_INTENT_SPONSOR_INTEREST {
		t.Fatalf("expected intent SPONSOR_INTEREST after batch analysis, got %v", getResp.Msg.Thread.Intent)
	}
}

// ============================================================================
// ACCEPTANCE TARGET 3: Ghost Messages and Revoked Account Repair
// ============================================================================

func TestAcceptanceTarget3_GhostMessagesHandling(t *testing.T) {
	svc, _, wsID, accID := setupTestService(t)
	ctx := context.Background()

	// 1. Ghost message 404 (deleted by user)
	thread404ID := "thread-ghost-404"
	_, _, err := svc.IngestInboundMessage(ctx, wsID, thread404ID, SubtypeComment, "tiktok", "Bình luận sẽ bị xoá", "ent-404")
	if err != nil {
		t.Fatalf("ingest failed: %v", err)
	}

	ghostResp404, err := svc.HandleGhostMessage(ctx, connect.NewRequest(&engagementv1.ThreadServiceHandleGhostMessageRequest{
		WorkspaceId:      wsID,
		ThreadId:         thread404ID,
		PlatformHttpCode: 404,
		ErrorMessage:     "Not Found",
	}))
	if err != nil {
		t.Fatalf("HandleGhostMessage 404 failed: %v", err)
	}
	if !ghostResp404.Msg.IsStale || !ghostResp404.Msg.ComposeDisabled {
		t.Fatalf("expected IsStale=true, ComposeDisabled=true for 404")
	}
	if !strings.Contains(ghostResp404.Msg.UserExplanation, "WHAT:") || !strings.Contains(ghostResp404.Msg.UserExplanation, "WHY:") || !strings.Contains(ghostResp404.Msg.UserExplanation, "NEXT:") {
		t.Fatalf("expected WHAT->WHY->NEXT explanation, got: %s", ghostResp404.Msg.UserExplanation)
	}

	// Attempting reply on 404 ghost thread MUST fail
	_, err = svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        thread404ID,
		Body:            "Phản hồi bình luận đã xoá",
		TargetAccountId: accID,
	}))
	if err == nil {
		t.Fatalf("expected reply to ghost thread to fail, got nil")
	}

	// 2. Ghost message 410 (permanently removed) -> auto archive
	thread410ID := "thread-ghost-410"
	_, _, err = svc.IngestInboundMessage(ctx, wsID, thread410ID, SubtypeComment, "tiktok", "Bình luận vĩnh viễn", "ent-410")
	if err != nil {
		t.Fatalf("ingest failed: %v", err)
	}

	ghostResp410, err := svc.HandleGhostMessage(ctx, connect.NewRequest(&engagementv1.ThreadServiceHandleGhostMessageRequest{
		WorkspaceId:      wsID,
		ThreadId:         thread410ID,
		PlatformHttpCode: 410,
		ErrorMessage:     "Gone",
	}))
	if err != nil {
		t.Fatalf("HandleGhostMessage 410 failed: %v", err)
	}
	if ghostResp410.Msg.Thread.Status != engagementv1.ThreadStatus_THREAD_STATUS_ARCHIVED {
		t.Fatalf("expected 410 to transition status to ARCHIVED, got %v", ghostResp410.Msg.Thread.Status)
	}

	// 3. Transient 500 error -> compose stays enabled
	thread500ID := "thread-ghost-500"
	_, _, err = svc.IngestInboundMessage(ctx, wsID, thread500ID, SubtypeComment, "tiktok", "Bình luận mạng chập chờn", "ent-500")
	if err != nil {
		t.Fatalf("ingest failed: %v", err)
	}

	ghostResp500, err := svc.HandleGhostMessage(ctx, connect.NewRequest(&engagementv1.ThreadServiceHandleGhostMessageRequest{
		WorkspaceId:      wsID,
		ThreadId:         thread500ID,
		PlatformHttpCode: 500,
		ErrorMessage:     "Internal Server Error",
	}))
	if err != nil {
		t.Fatalf("HandleGhostMessage 500 failed: %v", err)
	}
	if ghostResp500.Msg.ComposeDisabled {
		t.Fatalf("expected ComposeDisabled=false for transient 500 error")
	}
}

func TestAcceptanceTarget3_RevokedAccountRepair(t *testing.T) {
	svc, _, wsID, accID := setupTestService(t)
	ctx := context.Background()
	threadID := "thread-revoked-001"

	// Create thread tied to account
	th, _, err := svc.IngestInboundMessage(ctx, wsID, threadID, SubtypeComment, "tiktok", "Hàng có sẵn không shop?", "ent-rev-1")
	if err != nil {
		t.Fatalf("ingest failed: %v", err)
	}
	th.ConnectedAccountID = accID

	// 1. Simulate account token revocation (auth_revoked)
	svc.accounts[accID].IsRevoked = true

	// Attempting reply MUST fail with ErrAccountRevoked and CodeUnauthenticated
	_, err = svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Dạ hàng có sẵn ạ!",
		TargetAccountId: accID,
	}))
	if err == nil {
		t.Fatalf("expected reply with revoked account to fail, got nil")
	}
	connErr, ok := err.(*connect.Error)
	if !ok || connErr.Code() != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated, got %v: %v", connErr.Code(), err)
	}
	if !strings.Contains(err.Error(), "auth_revoked") {
		t.Fatalf("expected auth_revoked mention in error, got %v", err)
	}

	// Verify thread is now marked with account_revoked = true
	getResp, err := svc.Get(ctx, connect.NewRequest(&engagementv1.ThreadServiceGetRequest{
		WorkspaceId: wsID,
		ThreadId:    threadID,
	}))
	if err != nil {
		t.Fatalf("Get failed: %v", err)
	}
	if !getResp.Msg.Thread.AccountRevoked {
		t.Fatalf("expected AccountRevoked=true on thread")
	}

	// 2. Perform Account Repair with new OAuth token
	repairResp, err := svc.RepairRevokedAccount(ctx, connect.NewRequest(&engagementv1.EngagementProtectionServiceRepairRevokedAccountRequest{
		WorkspaceId:        wsID,
		ConnectedAccountId: accID,
		NewAccessToken:     "refreshed_oauth_token_456",
	}))
	if err != nil {
		t.Fatalf("RepairRevokedAccount failed: %v", err)
	}
	if !repairResp.Msg.Repaired || repairResp.Msg.UnblockedThreadsCount != 1 {
		t.Fatalf("expected Repaired=true and UnblockedThreadsCount=1, got %+v", repairResp.Msg)
	}

	// 3. Outbound reply now SUCCEEDS
	replyResp, err := svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Dạ hàng có sẵn ạ! Shop giao ngay trong ngày nhé.",
		TargetAccountId: accID,
	}))
	if err != nil {
		t.Fatalf("expected reply after account repair to succeed, got %v", err)
	}
	if replyResp.Msg.Thread.AccountRevoked {
		t.Fatalf("expected AccountRevoked=false after repair")
	}
}

// ============================================================================
// Core Flows, SLAs, Entities, and Conversions
// ============================================================================

func TestEngagement_CoreFlowsAndConversions(t *testing.T) {
	svc, advance, wsID, accID := setupTestService(t)
	ctx := context.Background()

	// 1. Ingest comment
	tID := "thread-core-01"
	_, _, err := svc.IngestInboundMessage(ctx, wsID, tID, SubtypeComment, "tiktok", "Sản phẩm dùng tốt không bạn?", "ent-c-1")
	if err != nil {
		t.Fatalf("Ingest failed: %v", err)
	}

	// 2. Triage thread
	due := svc.clock().Add(2 * time.Hour)
	triageResp, err := svc.Triage(ctx, connect.NewRequest(&engagementv1.ThreadServiceTriageRequest{
		WorkspaceId: wsID,
		ThreadId:    tID,
		Intent:      engagementv1.ThreadIntent_THREAD_INTENT_QUESTION,
		Priority:    engagementv1.ThreadPriority_THREAD_PRIORITY_HIGH,
		NextAction:  "Tư vấn công dụng",
		OwnerUserId: "user-agent-1",
		SlaDueAt:    timestamppb.New(due),
	}))
	if err != nil {
		t.Fatalf("Triage failed: %v", err)
	}
	if triageResp.Msg.Thread.Status != engagementv1.ThreadStatus_THREAD_STATUS_TRIAGED {
		t.Fatalf("expected status TRIAGED, got %v", triageResp.Msg.Thread.Status)
	}

	// 3. Conversions (RULE-M12-005)
	// Convert to Idea (M05)
	err = svc.ConvertToIdea(ctx, wsID, tID, "idea-123")
	if err != nil {
		t.Fatalf("ConvertToIdea failed: %v", err)
	}

	// Create follow-up task (M12 FollowUpService)
	taskResp, err := svc.AsFollowUpHandler().Create(ctx, connect.NewRequest(&engagementv1.FollowUpServiceCreateRequest{
		WorkspaceId:    wsID,
		SourceThreadId: tID,
		TaskType:       "customer_feedback",
		Title:          "Liên hệ xin feedback sau 3 ngày",
		AssignedUserId: "user-agent-1",
	}))
	if err != nil {
		t.Fatalf("CreateFollowUpTask failed: %v", err)
	}
	if taskResp.Msg.Task.Title != "Liên hệ xin feedback sau 3 ngày" {
		t.Fatalf("unexpected task title: %s", taskResp.Msg.Task.Title)
	}

	// Complete task
	compResp, err := svc.AsFollowUpHandler().Complete(ctx, connect.NewRequest(&engagementv1.FollowUpServiceCompleteRequest{
		WorkspaceId:    wsID,
		TaskId:         taskResp.Msg.Task.TaskId,
		OutcomeSummary: "Khách khen sản phẩm tốt, đã mua thêm 2 hộp",
	}))
	if err != nil {
		t.Fatalf("CompleteFollowUpTask failed: %v", err)
	}
	if compResp.Msg.Task.Status != engagementv1.FollowUpTaskStatus_FOLLOW_UP_TASK_STATUS_COMPLETED {
		t.Fatalf("expected status COMPLETED, got %v", compResp.Msg.Task.Status)
	}

	// 4. SLA Approaching & Breached events (RULE-M12-004)
	// Advance to 1.5h -> approaching
	advance(95 * time.Minute)
	events, err := svc.CheckSLABreaches(ctx)
	if err != nil {
		t.Fatalf("CheckSLABreaches failed: %v", err)
	}
	var foundApproaching bool
	for _, e := range events {
		if e.EventType == EventThreadSLAApproaching {
			foundApproaching = true
		}
	}
	if !foundApproaching {
		t.Fatalf("expected EventThreadSLAApproaching event")
	}

	// Advance past 2h -> breached
	advance(30 * time.Minute)
	events2, err := svc.CheckSLABreaches(ctx)
	if err != nil {
		t.Fatalf("CheckSLABreaches breached failed: %v", err)
	}
	var foundBreached bool
	for _, e := range events2 {
		if e.EventType == EventThreadSLABreached {
			foundBreached = true
		}
	}
	if !foundBreached {
		t.Fatalf("expected EventThreadSLABreached event")
	}

	// 5. Reply and Resolve
	_, err = svc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        tID,
		Body:            "Dạ chào bạn, sản phẩm rất an toàn và hiệu quả ạ!",
		TargetAccountId: accID,
	}))
	if err != nil {
		t.Fatalf("Reply failed: %v", err)
	}

	resResp, err := svc.Resolve(ctx, connect.NewRequest(&engagementv1.ThreadServiceResolveRequest{
		WorkspaceId:    wsID,
		ThreadId:       tID,
		OutcomeSummary: "Đã tư vấn xong",
	}))
	if err != nil {
		t.Fatalf("Resolve failed: %v", err)
	}
	if resResp.Msg.Thread.Status != engagementv1.ThreadStatus_THREAD_STATUS_RESOLVED {
		t.Fatalf("expected RESOLVED, got %v", resResp.Msg.Thread.Status)
	}
}

func TestEngagement_EntityServiceOperations(t *testing.T) {
	svc, _, wsID, _ := setupTestService(t)
	ctx := context.Background()

	// 1. Create entities
	e1Resp, err := svc.AsEntityHandler().Create(ctx, connect.NewRequest(&engagementv1.EntityServiceCreateRequest{
		WorkspaceId:         wsID,
		EntityType:          engagementv1.EntityType_ENTITY_TYPE_PERSON,
		DisplayName:         "Nguyễn Văn A",
		RelationshipState:   engagementv1.EntityRelationshipState_ENTITY_RELATIONSHIP_STATE_LEAD,
		PlatformHandlesJson: []string{"@nguyenvana_tiktok"},
		Tags:                []string{"vip", "hanoi"},
	}))
	if err != nil {
		t.Fatalf("Create entity 1 failed: %v", err)
	}

	e2Resp, err := svc.AsEntityHandler().Create(ctx, connect.NewRequest(&engagementv1.EntityServiceCreateRequest{
		WorkspaceId:         wsID,
		EntityType:          engagementv1.EntityType_ENTITY_TYPE_PERSON,
		DisplayName:         "Van A Nguyen",
		RelationshipState:   engagementv1.EntityRelationshipState_ENTITY_RELATIONSHIP_STATE_LEAD,
		PlatformHandlesJson: []string{"@vana_insta"},
	}))
	if err != nil {
		t.Fatalf("Create entity 2 failed: %v", err)
	}

	// Ingest thread tied to entity 2
	tID := "thread-ent-merge-1"
	_, _, err = svc.IngestInboundMessage(ctx, wsID, tID, SubtypeDM, "instagram", "Xin chào shop", e2Resp.Msg.Entity.EntityId)
	if err != nil {
		t.Fatalf("ingest failed: %v", err)
	}

	// 2. Merge entity 2 into entity 1
	mergeResp, err := svc.AsEntityHandler().Merge(ctx, connect.NewRequest(&engagementv1.EntityServiceMergeRequest{
		WorkspaceId:        wsID,
		PrimaryEntityId:    e1Resp.Msg.Entity.EntityId,
		SecondaryEntityIds: []string{e2Resp.Msg.Entity.EntityId},
	}))
	if err != nil {
		t.Fatalf("Merge failed: %v", err)
	}
	if mergeResp.Msg.ThreadsReassigned != 1 {
		t.Fatalf("expected 1 thread reassigned, got %d", mergeResp.Msg.ThreadsReassigned)
	}

	// 3. Add note & tag
	_, err = svc.AsEntityHandler().AddNote(ctx, connect.NewRequest(&engagementv1.EntityServiceAddNoteRequest{
		WorkspaceId: wsID,
		EntityId:    e1Resp.Msg.Entity.EntityId,
		Note:        "Khách hàng tiềm năng hợp tác kênh ẩm thực",
	}))
	if err != nil {
		t.Fatalf("AddNote failed: %v", err)
	}

	getEnt, err := svc.AsEntityHandler().Get(ctx, connect.NewRequest(&engagementv1.EntityServiceGetRequest{
		WorkspaceId: wsID,
		EntityId:    e1Resp.Msg.Entity.EntityId,
	}))
	if err != nil {
		t.Fatalf("Get entity failed: %v", err)
	}
	if len(getEnt.Msg.Threads) != 1 {
		t.Fatalf("expected merged thread to belong to primary entity, got %d threads", len(getEnt.Msg.Threads))
	}
}

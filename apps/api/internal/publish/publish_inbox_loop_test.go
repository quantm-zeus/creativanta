package publish

import (
	"context"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	engagementv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/engagement/v1"
	publishv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
	"github.com/quantm-zeus/creativanta/apps/api/internal/engagement"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// loopMockConnector implements PlatformConnector for loop testing
type loopMockConnector struct {
	platform          string
	publishCalled     int
	statusCheckCalled int
	publishResult     *ConnectorPublishResult
	statusResult      *ConnectorStatusResult
}

func (m *loopMockConnector) Platform() string {
	return m.platform
}

func (m *loopMockConnector) PublishPost(ctx context.Context, accountID string, item *PublishItem, idempotencyKey string) (*ConnectorPublishResult, error) {
	m.publishCalled++
	if m.publishResult != nil {
		return m.publishResult, nil
	}
	return &ConnectorPublishResult{
		ProviderRequestID: "req-loop-123",
		ExternalPostID:    "ext-post-tiktok-456",
		ExternalPostURL:   "https://tiktok.com/@creator/video/ext-post-tiktok-456",
		ResultStatus:      ResultSuccess,
	}, nil
}

func (m *loopMockConnector) CheckPostStatus(ctx context.Context, accountID string, providerRequestID string) (*ConnectorStatusResult, error) {
	m.statusCheckCalled++
	if m.statusResult != nil {
		return m.statusResult, nil
	}
	pubAt := time.Now()
	return &ConnectorStatusResult{
		ProviderRequestID: providerRequestID,
		ExternalPostID:    "ext-post-tiktok-456",
		ExternalPostURL:   "https://tiktok.com/@creator/video/ext-post-tiktok-456",
		Found:             true,
		PublishedAt:       &pubAt,
		Status:            "confirmed_published",
	}, nil
}

type loopMockAccountLookup struct {
	accounts map[string]*capability.ConnectedAccountRecord
}

func (m *loopMockAccountLookup) GetAccount(workspaceID, accountID string) (*capability.ConnectedAccountRecord, error) {
	if acc, ok := m.accounts[accountID]; ok {
		return acc, nil
	}
	return nil, ErrAccountNotFound
}

// ============================================================================
// TARGET 1: FIVE ACCEPTANCE PATHS (Happy, Degraded, Missing Data, Broken, Audit)
// ============================================================================

func TestPublishInboxLoop_Path1_HappyPath(t *testing.T) {
	wsID := "ws-loop-happy"
	ctx := WithCaller(context.Background(), wsID, "user-loop-1", "owner")
	now := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }

	conn := &loopMockConnector{platform: "tiktok"}
	pubSvc := NewService(ServiceConfig{
		Clock:             clock,
		ComplianceChecker: newTestFixtureComplianceChecker(),
		Accounts: &loopMockAccountLookup{
			accounts: map[string]*capability.ConnectedAccountRecord{
				"acc-tt-1": {
					ConnectedAccountID: "acc-tt-1",
					WorkspaceID:        wsID,
					Platform:           "tiktok",
					AccountName:        "Shop TikTok",
				},
			},
		},
	})
	pubSvc.RegisterConnector(conn)

	engSvc := engagement.NewService(&engagement.ServiceConfig{Clock: clock})
	engSvc.RegisterConnectedAccount(&engagement.ConnectedAccount{
		AccountID:   "acc-tt-1",
		WorkspaceID: wsID,
		Platform:    "tiktok",
		AccountName: "Shop TikTok",
		AvatarURL:   "https://cdn.creativanta.test/avatar.png",
		BadgeColor:  "#00f2fe",
	})

	// 1. Create and Execute Publish Item (Native API route)
	createResp, err := pubSvc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		Context:         &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tt-1",
		Title:           "Sản phẩm mùa hè mới",
		Description:     "Giảm giá 30% hôm nay #summer #sale",
		Hashtags:        []string{"#summer", "#sale"},
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	execResp, err := pubSvc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("Execute failed: %v", err)
	}
	if execResp.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected state published, got %v", execResp.Msg.Item.LifecycleState)
	}
	if execResp.Msg.ChannelPost == nil || execResp.Msg.ChannelPost.ExternalPostId == "" {
		t.Fatalf("expected channel post with external post ID")
	}
	channelPostID := execResp.Msg.ChannelPost.ChannelPostId

	// 2. Channel post triggers inbound interaction in Unified Inbox
	threadID := "th-happy-1"
	thread, msg, err := engSvc.IngestChannelPostInteraction(
		ctx,
		wsID,
		threadID,
		channelPostID,
		"tiktok",
		"Sản phẩm này có size XL không bạn?",
		"entity-cust-1",
		"msg-ext-101",
	)
	if err != nil {
		t.Fatalf("IngestChannelPostInteraction failed: %v", err)
	}
	if thread.Status != engagement.StatusNew {
		t.Fatalf("expected status new, got %s", thread.Status)
	}
	if thread.SourcePostID != channelPostID {
		t.Fatalf("expected thread linked to channelPostID %s, got %s", channelPostID, thread.SourcePostID)
	}
	if msg.Body != "Sản phẩm này có size XL không bạn?" {
		t.Fatalf("unexpected message body: %s", msg.Body)
	}

	// 3. Operator triages thread (RULE-M12-001)
	triageResp, err := engSvc.Triage(ctx, connect.NewRequest(&engagementv1.ThreadServiceTriageRequest{
		WorkspaceId: wsID,
		ThreadId:    threadID,
		Intent:      engagementv1.ThreadIntent_THREAD_INTENT_QUESTION,
		Priority:    engagementv1.ThreadPriority_THREAD_PRIORITY_HIGH,
		OwnerUserId: "operator-1",
		NextAction:  "Trả lời tư vấn size",
	}))
	if err != nil {
		t.Fatalf("Triage failed: %v", err)
	}
	if triageResp.Msg.Thread.Status != engagementv1.ThreadStatus_THREAD_STATUS_TRIAGED {
		t.Fatalf("expected triaged status, got %v", triageResp.Msg.Thread.Status)
	}

	// 4. Operator replies with Reply-As identity (RULE-M12-006)
	replyResp, err := engSvc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        threadID,
		Body:            "Dạ bên mình còn size XL bạn nhé!",
		TargetAccountId: "acc-tt-1",
	}))
	if err != nil {
		t.Fatalf("Reply failed: %v", err)
	}
	if replyResp.Msg.Thread.Status != engagementv1.ThreadStatus_THREAD_STATUS_WAITING_ON_USER {
		t.Fatalf("expected waiting_on_user, got %v", replyResp.Msg.Thread.Status)
	}

	// 5. Operator resolves thread
	resolveResp, err := engSvc.Resolve(ctx, connect.NewRequest(&engagementv1.ThreadServiceResolveRequest{
		WorkspaceId:    wsID,
		ThreadId:       threadID,
		OutcomeSummary: "Đã tư vấn size thành công",
	}))
	if err != nil {
		t.Fatalf("Resolve failed: %v", err)
	}
	if resolveResp.Msg.Thread.Status != engagementv1.ThreadStatus_THREAD_STATUS_RESOLVED {
		t.Fatalf("expected resolved status, got %v", resolveResp.Msg.Thread.Status)
	}
}

func TestPublishInboxLoop_Path2_DegradedPath(t *testing.T) {
	wsID := "ws-loop-degraded"
	ctx := WithCaller(context.Background(), wsID, "user-loop-2", "owner")
	now := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }

	// Platform has degraded capability requiring manual fallback
	pubSvc := NewService(ServiceConfig{
		Clock:             clock,
		ComplianceChecker: newTestFixtureComplianceChecker(),
		Accounts: &loopMockAccountLookup{
			accounts: map[string]*capability.ConnectedAccountRecord{
				"acc-shopee-1": {
					ConnectedAccountID: "acc-shopee-1",
					WorkspaceID:        wsID,
					Platform:           "shopee",
					AccountName:        "Shopee Store",
				},
			},
		},
	})

	// Inject degraded capability evaluator
	pubSvc.SetCapabilityEvaluator(&MockCapabilityEvaluator{state: capability.StateManual})

	createResp, err := pubSvc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		Context:         &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		TargetPlatform:  "shopee",
		TargetAccountId: "acc-shopee-1",
		Title:           "Video Hướng dẫn sử dụng",
		Description:     "Chi tiết cách sử dụng sản phẩm",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// Attempting native execute fails with ErrCapabilityDegraded and sets requires_manual_fallback
	_, err = pubSvc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if err == nil || !strings.Contains(err.Error(), "manual fallback") {
		t.Fatalf("expected capability degraded error, got %v", err)
	}

	// 1. Generate manual export package
	exportResp, err := pubSvc.ExportManualPackage(ctx, connect.NewRequest(&publishv1.ExportManualPackageRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("ExportManualPackage failed: %v", err)
	}
	exportPkg := exportResp.Msg.Package
	if exportPkg.MediaUrl == "" || exportPkg.Instructions == "" {
		t.Fatalf("expected media URL and instructions in manual export package")
	}

	// 2. Operator submits manual proof
	proofResp, err := pubSvc.SubmitManualProof(ctx, connect.NewRequest(&publishv1.SubmitManualProofRequest{
		PublishItemId:   itemID,
		ExternalPostUrl: "https://shopee.vn/feed/post123",
		EvidenceUrl:     "https://cdn.creativanta.test/proof123.png",
		Notes:           "Uploaded via app",
	}))
	if err != nil {
		t.Fatalf("SubmitManualProof failed: %v", err)
	}
	if proofResp.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected published lifecycle state after manual proof, got %v", proofResp.Msg.Item.LifecycleState)
	}
	if proofResp.Msg.Log.ExecutionPath != publishv1.ExecutionPath_EXECUTION_PATH_MANUAL_UPLOAD {
		t.Fatalf("expected manual_upload execution path, got %v", proofResp.Msg.Log.ExecutionPath)
	}

	// 3. Channel post synced as imported / manual proof
	if proofResp.Msg.ChannelPost == nil || proofResp.Msg.ChannelPost.ExternalPermalink != "https://shopee.vn/feed/post123" {
		t.Fatalf("expected channel post with external permalink")
	}

	// 4. In degraded channel post, manual note in inbox operates without failing
	engSvc := engagement.NewService(&engagement.ServiceConfig{Clock: clock})
	thread, _, err := engSvc.IngestInboundMessage(ctx, wsID, "th-deg-1", engagement.SubtypeComment, "shopee", "Shop cho mình xin thêm tài liệu", "ent-deg-1")
	if err != nil {
		t.Fatalf("IngestInboundMessage failed: %v", err)
	}
	if thread.Status != engagement.StatusNew {
		t.Fatalf("expected status new, got %s", thread.Status)
	}
}

func TestPublishInboxLoop_Path3_MissingDataPath(t *testing.T) {
	wsID := "ws-loop-empty"
	ctx := WithCaller(context.Background(), wsID, "user-loop-3", "owner")
	pubSvc := NewService(ServiceConfig{
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	engSvc := engagement.NewService(&engagement.ServiceConfig{})

	// 1. Preflight check: cannot execute publish on nonexistent item
	_, err := pubSvc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: "nonexistent-item",
	}))
	if err == nil || !strings.Contains(err.Error(), "publish item not found") {
		t.Fatalf("expected item not found error, got %v", err)
	}

	// 2. Preflight check: cannot schedule nonexistent item
	_, err = pubSvc.Schedule(ctx, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: "item-no-account",
	}))
	if err == nil {
		t.Fatalf("expected error when scheduling nonexistent item")
	}

	// 3. Empty inbox search returns 0 items without panic
	listResp, err := engSvc.List(ctx, connect.NewRequest(&engagementv1.ThreadServiceListRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("List threads failed: %v", err)
	}
	if len(listResp.Msg.Threads) != 0 {
		t.Fatalf("expected 0 threads for empty workspace, got %d", len(listResp.Msg.Threads))
	}

	// 4. Getting unread count on empty inbox returns 0
	unreadResp, err := engSvc.GetUnreadCount(ctx, connect.NewRequest(&engagementv1.ThreadServiceGetUnreadCountRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("GetUnreadCount failed: %v", err)
	}
	if unreadResp.Msg.UnreadCount != 0 {
		t.Fatalf("expected 0 unread, got %d", unreadResp.Msg.UnreadCount)
	}
}

func TestPublishInboxLoop_Path4_BrokenPath(t *testing.T) {
	wsID := "ws-loop-broken"
	ctx := WithCaller(context.Background(), wsID, "user-loop-4", "owner")
	now := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }

	// A. Token Revoked mid-publish
	revokedConn := &loopMockConnector{
		platform: "tiktok",
		publishResult: &ConnectorPublishResult{
			ResultStatus: "auth_revoked",
			ErrorCode:    ErrorCodeAuthRevoked,
			ErrorMessage: "OAuth token revoked",
		},
	}
	pubSvc := NewService(ServiceConfig{
		Clock:             clock,
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	pubSvc.RegisterConnector(revokedConn)

	item1, _ := pubSvc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		Context:         &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-broken-1",
		Title:           "Item 1 executing",
	}))
	item2, _ := pubSvc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		Context:         &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-broken-1",
		Title:           "Item 2 queued",
		ScheduleAt:      timestamppb.New(now.Add(1 * time.Hour)),
	}))
	item3, _ := pubSvc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		Context:         &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-other-account",
		Title:           "Item 3 other account",
	}))

	// Execute item1 -> fails with auth_revoked and pauses item2 targeting same account
	_, err := pubSvc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: item1.Msg.Item.PublishItemId,
	}))
	if err == nil || !strings.Contains(err.Error(), "auth_revoked") {
		t.Fatalf("expected auth_revoked error, got %v", err)
	}

	// Verify item1 is failed and diagnostics blocked
	it1, _ := pubSvc.Get(ctx, connect.NewRequest(&publishv1.GetRequest{
		PublishItemId: item1.Msg.Item.PublishItemId,
	}))
	if it1.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_FAILED {
		t.Fatalf("expected failed state, got %v", it1.Msg.Item.LifecycleState)
	}
	if it1.Msg.Item.DiagnosticsState != publishv1.DiagnosticsState_DIAGNOSTICS_STATE_BLOCKED {
		t.Fatalf("expected blocked diagnostics, got %v", it1.Msg.Item.DiagnosticsState)
	}

	// Verify item2 is paused (blocked diagnostics) while retaining queued state
	it2, _ := pubSvc.Get(ctx, connect.NewRequest(&publishv1.GetRequest{
		PublishItemId: item2.Msg.Item.PublishItemId,
	}))
	if it2.Msg.Item.DiagnosticsState != publishv1.DiagnosticsState_DIAGNOSTICS_STATE_BLOCKED {
		t.Fatalf("expected queued item for revoked account to be blocked, got %v", it2.Msg.Item.DiagnosticsState)
	}

	// Verify item3 on other account is unaffected
	it3, _ := pubSvc.Get(ctx, connect.NewRequest(&publishv1.GetRequest{
		PublishItemId: item3.Msg.Item.PublishItemId,
	}))
	if it3.Msg.Item.DiagnosticsState == publishv1.DiagnosticsState_DIAGNOSTICS_STATE_BLOCKED {
		t.Fatalf("unrelated account should not be blocked")
	}

	// B. Ghost message in inbox
	engSvc := engagement.NewService(&engagement.ServiceConfig{Clock: clock})
	engSvc.RegisterConnectedAccount(&engagement.ConnectedAccount{
		AccountID:   "acc-broken-1",
		WorkspaceID: wsID,
		Platform:    "tiktok",
	})
	thGhost, _, _ := engSvc.IngestInboundMessage(ctx, wsID, "th-ghost-1", engagement.SubtypeComment, "tiktok", "Bình luận sẽ bị xoá", "ent-ghost")
	if thGhost == nil {
		t.Fatalf("failed to ingest ghost message")
	}

	// Platform returns 404 (deleted by user)
	_, err = engSvc.HandleGhostMessage(ctx, connect.NewRequest(&engagementv1.ThreadServiceHandleGhostMessageRequest{
		WorkspaceId:      wsID,
		ThreadId:         "th-ghost-1",
		PlatformHttpCode: 404,
	}))
	if err != nil {
		t.Fatalf("HandleGhostMessage failed: %v", err)
	}
	thRes, err := engSvc.Get(ctx, connect.NewRequest(&engagementv1.ThreadServiceGetRequest{
		WorkspaceId: wsID,
		ThreadId:    "th-ghost-1",
	}))
	if err != nil {
		t.Fatalf("Get thread failed: %v", err)
	}
	if !thRes.Msg.Thread.IsGhost || thRes.Msg.Thread.GhostStatus != engagementv1.GhostStatus_GHOST_STATUS_DELETED_BY_USER {
		t.Fatalf("expected ghost status deleted_by_user, got %v", thRes.Msg.Thread.GhostStatus)
	}

	// Outbound reply attempt on ghost thread is rejected
	_, err = engSvc.Reply(ctx, connect.NewRequest(&engagementv1.ThreadServiceReplyRequest{
		WorkspaceId:     wsID,
		ThreadId:        "th-ghost-1",
		Body:            "Phản hồi bình luận đã xoá",
		TargetAccountId: "acc-broken-1",
	}))
	if err == nil || !strings.Contains(err.Error(), "deleted_by_user") {
		t.Fatalf("expected reply rejection on ghost message, got %v", err)
	}
}

func TestPublishInboxLoop_Path5_AuditPath(t *testing.T) {
	wsID := "ws-loop-audit"
	ctx := WithCaller(context.Background(), wsID, "user-loop-5", "owner")
	now := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }

	conn := &loopMockConnector{platform: "tiktok"}
	pubSvc := NewService(ServiceConfig{
		Clock:             clock,
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	pubSvc.RegisterConnector(conn)
	engSvc := engagement.NewService(&engagement.ServiceConfig{Clock: clock})

	// 1. Create and Execute
	itemResp, _ := pubSvc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		Context:        &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		TargetPlatform: "tiktok",
		Title:          "Audit test item",
	}))
	itemID := itemResp.Msg.Item.PublishItemId

	_, err := pubSvc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("Execute failed: %v", err)
	}

	// 2. Verify immutable publish log exists
	logsResp, err := pubSvc.GetLogs(ctx, connect.NewRequest(&publishv1.GetLogsRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("GetLogs failed: %v", err)
	}
	if len(logsResp.Msg.Logs) == 0 {
		t.Fatalf("expected publish logs to exist")
	}
	log := logsResp.Msg.Logs[0]
	if log.ResultStatus != publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_SUCCESS {
		t.Fatalf("expected success log, got %v", log.ResultStatus)
	}
	if log.ExternalPostId == "" || log.ExternalPostUrl == "" {
		t.Fatalf("expected external post id and url in immutable log")
	}

	// 3. Verify domain events outbox audit trail
	events := pubSvc.Events()
	var foundExecuting, foundSucceeded, foundChannelSynced bool
	for _, e := range events {
		if e.EventType == EventPublishExecuting {
			foundExecuting = true
		}
		if e.EventType == EventPublishSucceeded {
			foundSucceeded = true
		}
		if e.EventType == EventChannelPostSynced {
			foundChannelSynced = true
		}
	}
	if !foundExecuting || !foundSucceeded || !foundChannelSynced {
		t.Fatalf("missing audit domain events: executing=%v, succeeded=%v, channelSynced=%v",
			foundExecuting, foundSucceeded, foundChannelSynced)
	}

	// 4. Ingest and verify inbox audit trail
	_, _, err = engSvc.IngestInboundMessage(ctx, wsID, "th-audit-1", engagement.SubtypeComment, "tiktok", "Audit message", "ent-audit")
	if err != nil {
		t.Fatalf("IngestInboundMessage failed: %v", err)
	}
	inboxEvents := engSvc.GetRecordedEvents()
	var foundThreadCreated, foundMsgReceived bool
	for _, e := range inboxEvents {
		if e.EventType == engagement.EventThreadCreated {
			foundThreadCreated = true
		}
		if e.EventType == engagement.EventMessageReceived {
			foundMsgReceived = true
		}
	}
	if !foundThreadCreated || !foundMsgReceived {
		t.Fatalf("missing inbox audit domain events: threadCreated=%v, msgReceived=%v", foundThreadCreated, foundMsgReceived)
	}
}

// ============================================================================
// TARGET 2: REPLAY WITH ONE EXTERNAL RESULT
// ============================================================================

func TestPublishInboxLoop_Target2_ReplayWithOneExternalResult(t *testing.T) {
	wsID := "ws-replay-test"
	ctx := WithCaller(context.Background(), wsID, "user-loop-6", "owner")
	now := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }

	conn := &loopMockConnector{platform: "tiktok"}
	pubSvc := NewService(ServiceConfig{
		Clock:             clock,
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	pubSvc.RegisterConnector(conn)

	itemResp, err := pubSvc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		Context:         &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tt-replay",
		Title:           "Replay Test Item",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := itemResp.Msg.Item.PublishItemId

	// Initial execution with idempotency key
	idemKey := "idem-exec-001"
	req1 := connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
		Context: &commonv1.CommandContext{
			IdempotencyKey: idemKey,
		},
	})
	resp1, err := pubSvc.Execute(ctx, req1)
	if err != nil {
		t.Fatalf("Execute (first call) failed: %v", err)
	}
	if conn.publishCalled != 1 {
		t.Fatalf("expected connector to be called once, got %d", conn.publishCalled)
	}
	firstPostID := resp1.Msg.ChannelPost.ExternalPostId
	firstLogID := resp1.Msg.Log.PublishLogId

	// REPLAY 1: Calling Execute again with the same idempotency key
	req2 := connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
		Context: &commonv1.CommandContext{
			IdempotencyKey: idemKey,
		},
	})
	resp2, err := pubSvc.Execute(ctx, req2)
	if err != nil {
		t.Fatalf("Execute (replay with idemKey) failed: %v", err)
	}

	// Critical invariant: Connector MUST NOT be called a second time!
	if conn.publishCalled != 1 {
		t.Fatalf("REPLAY VIOLATION: expected connector called exactly once, but was called %d times", conn.publishCalled)
	}

	// External result must be identical
	if resp2.Msg.ChannelPost.ExternalPostId != firstPostID {
		t.Fatalf("expected identical external post ID on replay, got %s vs %s", resp2.Msg.ChannelPost.ExternalPostId, firstPostID)
	}
	if resp2.Msg.Log.PublishLogId != firstLogID {
		t.Fatalf("expected identical log ID without duplicate creation, got %s vs %s", resp2.Msg.Log.PublishLogId, firstLogID)
	}

	// REPLAY 2: Calling Execute on an already published item without idempotency key
	req3 := connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	})
	resp3, err := pubSvc.Execute(ctx, req3)
	if err != nil {
		t.Fatalf("Execute (replay on published item) failed: %v", err)
	}
	if conn.publishCalled != 1 {
		t.Fatalf("REPLAY VIOLATION: connector called %d times after replay on published item", conn.publishCalled)
	}
	if resp3.Msg.ChannelPost.ExternalPostId != firstPostID {
		t.Fatalf("expected identical external post ID, got %s", resp3.Msg.ChannelPost.ExternalPostId)
	}

	// Verify publish logs count: strictly 1 log created (no duplicates on replay)
	logsResp, _ := pubSvc.GetLogs(ctx, connect.NewRequest(&publishv1.GetLogsRequest{
		PublishItemId: itemID,
	}))
	if len(logsResp.Msg.Logs) != 1 {
		t.Fatalf("expected exactly 1 immutable log entry, found %d", len(logsResp.Msg.Logs))
	}

	// REPLAY 3: Inbound Webhook Deduplication in Unified Inbox
	engSvc := engagement.NewService(&engagement.ServiceConfig{Clock: clock})
	threadID := "th-webhook-replay"

	// First webhook delivery
	th1, m1, err := engSvc.IngestInboundMessageWithExternalID(
		ctx, wsID, threadID, engagement.SubtypeComment, "tiktok", "Hello from user!", "ent-1", "ext-msg-999",
	)
	if err != nil {
		t.Fatalf("first webhook delivery failed: %v", err)
	}
	if th1.MessageCount != 1 {
		t.Fatalf("expected message count 1, got %d", th1.MessageCount)
	}

	// Replay identical webhook delivery
	th2, m2, err := engSvc.IngestInboundMessageWithExternalID(
		ctx, wsID, threadID, engagement.SubtypeComment, "tiktok", "Hello from user!", "ent-1", "ext-msg-999",
	)
	if err != nil {
		t.Fatalf("second webhook delivery failed: %v", err)
	}

	// Must deduplicate idempotently: same message returned, message count NOT incremented
	if m1.MessageID != m2.MessageID {
		t.Fatalf("expected duplicate webhook to return same message, got %s vs %s", m1.MessageID, m2.MessageID)
	}
	if th2.MessageCount != 1 {
		t.Fatalf("REPLAY VIOLATION: duplicate webhook delivery incremented message count to %d", th2.MessageCount)
	}
}

// ============================================================================
// TARGET 3: COMMERCE/SEEDING ACTIONS RETAIN P6 TASK LINKS
// ============================================================================

func TestPublishInboxLoop_Target3_CommerceSeedingRetainP6TaskLinks(t *testing.T) {
	ctx := context.Background()
	wsID := "ws-p6-links"
	now := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }

	engSvc := engagement.NewService(&engagement.ServiceConfig{Clock: clock})

	// 1. Thread with Sample Request Intent (M18 Seeding CRM link - P6-09)
	sampleThreadID := "th-sample-p6"
	thSample, _, err := engSvc.IngestInboundMessage(
		ctx, wsID, sampleThreadID, engagement.SubtypeDM, "tiktok", "Mình là KOC 50k follow, muốn xin mẫu thử review được không?", "ent-koc-1",
	)
	if err != nil {
		t.Fatalf("Ingest failed: %v", err)
	}
	if thSample.Intent != engagement.IntentSampleRequest {
		t.Fatalf("expected sample_request intent, got %s", thSample.Intent)
	}

	sampleID := "sample-req-789"
	err = engSvc.ConvertToSampleRequest(ctx, wsID, sampleThreadID, sampleID)
	if err != nil {
		t.Fatalf("ConvertToSampleRequest failed: %v", err)
	}

	// Verify P6 task links retained in related_object_refs
	thSampleUpdated, err := engSvc.Get(ctx, connect.NewRequest(&engagementv1.ThreadServiceGetRequest{
		WorkspaceId: wsID,
		ThreadId:    sampleThreadID,
	}))
	if err != nil {
		t.Fatalf("Get thread failed: %v", err)
	}
	var foundSampleRef bool
	for _, r := range thSampleUpdated.Msg.Thread.RelatedObjectRefs {
		if r.Type == "sample_request" && r.Id == sampleID {
			foundSampleRef = true
			if r.TaskRef != "P6-09" {
				t.Fatalf("expected TaskRef P6-09, got %s", r.TaskRef)
			}
			if r.Phase != "P6" {
				t.Fatalf("expected Phase P6, got %s", r.Phase)
			}
			if !r.IsP6Deferred {
				t.Fatalf("expected IsP6Deferred true")
			}
			if r.Status != "pending_p6_delivery" {
				t.Fatalf("expected status pending_p6_delivery, got %s", r.Status)
			}
		}
	}
	if !foundSampleRef {
		t.Fatalf("sample request ref not found in thread related_object_refs")
	}

	// 2. Thread with Sponsor Interest Intent (S16 Brand Collaboration link - P6-09)
	sponsorThreadID := "th-sponsor-p6"
	thSponsor, _, err := engSvc.IngestInboundMessage(
		ctx, wsID, sponsorThreadID, engagement.SubtypeDM, "tiktok", "Chào bạn, mình từ nhãn hàng XYZ muốn hợp tác tài trợ video", "ent-brand-1",
	)
	if err != nil {
		t.Fatalf("Ingest failed: %v", err)
	}
	if thSponsor.Intent != engagement.IntentSponsorInterest {
		t.Fatalf("expected sponsor_interest intent, got %s", thSponsor.Intent)
	}

	dealID := "brand-deal-456"
	err = engSvc.ConvertToBrandDeal(ctx, wsID, sponsorThreadID, dealID)
	if err != nil {
		t.Fatalf("ConvertToBrandDeal failed: %v", err)
	}

	thSponsorUpdated, err := engSvc.Get(ctx, connect.NewRequest(&engagementv1.ThreadServiceGetRequest{
		WorkspaceId: wsID,
		ThreadId:    sponsorThreadID,
	}))
	if err != nil {
		t.Fatalf("Get thread failed: %v", err)
	}
	var foundSponsorRef bool
	for _, r := range thSponsorUpdated.Msg.Thread.RelatedObjectRefs {
		if r.Type == "brand_deal" && r.Id == dealID {
			foundSponsorRef = true
			if r.TaskRef != "P6-09" {
				t.Fatalf("expected TaskRef P6-09, got %s", r.TaskRef)
			}
			if r.Phase != "P6" {
				t.Fatalf("expected Phase P6, got %s", r.Phase)
			}
			if !r.IsP6Deferred {
				t.Fatalf("expected IsP6Deferred true")
			}
			if r.Status != "pending_p6_delivery" {
				t.Fatalf("expected status pending_p6_delivery, got %s", r.Status)
			}
		}
	}
	if !foundSponsorRef {
		t.Fatalf("brand deal ref not found in thread related_object_refs")
	}

	// 3. Thread with Offer / Coupon action (M14 Monetization OS link - P6-01)
	offerThreadID := "th-offer-p6"
	_, _, err = engSvc.IngestInboundMessage(
		ctx, wsID, offerThreadID, engagement.SubtypeComment, "tiktok", "Sản phẩm này có mã giảm giá cho fan không?", "ent-buyer-1",
	)
	if err != nil {
		t.Fatalf("Ingest failed: %v", err)
	}

	offerID := "offer-coupon-101"
	err = engSvc.ConvertToOffer(ctx, wsID, offerThreadID, offerID)
	if err != nil {
		t.Fatalf("ConvertToOffer failed: %v", err)
	}

	thOfferUpdated, err := engSvc.Get(ctx, connect.NewRequest(&engagementv1.ThreadServiceGetRequest{
		WorkspaceId: wsID,
		ThreadId:    offerThreadID,
	}))
	if err != nil {
		t.Fatalf("Get thread failed: %v", err)
	}
	var foundOfferRef bool
	for _, r := range thOfferUpdated.Msg.Thread.RelatedObjectRefs {
		if r.Type == "offer" && r.Id == offerID {
			foundOfferRef = true
			if r.TaskRef != "P6-01" {
				t.Fatalf("expected TaskRef P6-01, got %s", r.TaskRef)
			}
			if r.Phase != "P6" {
				t.Fatalf("expected Phase P6, got %s", r.Phase)
			}
			if !r.IsP6Deferred {
				t.Fatalf("expected IsP6Deferred true")
			}
			if r.Status != "pending_p6_delivery" {
				t.Fatalf("expected status pending_p6_delivery, got %s", r.Status)
			}
		}
	}
	if !foundOfferRef {
		t.Fatalf("offer ref not found in thread related_object_refs")
	}

	// 4. Follow-up task creation for seeding / commerce retains P6 task links
	taskResp, err := engSvc.AsFollowUpHandler().Create(ctx, connect.NewRequest(&engagementv1.FollowUpServiceCreateRequest{
		WorkspaceId:    wsID,
		SourceThreadId: sampleThreadID,
		TaskType:       "sample_request",
		Title:          "Gửi mẫu son môi cho KOC Lan Anh",
		Description:    "Địa chỉ: 123 Lê Lợi, Q1, HCM. Hạn review 7 ngày.",
	}))
	if err != nil {
		t.Fatalf("FollowUpService.Create failed: %v", err)
	}
	createdTask := taskResp.Msg.Task
	if createdTask.TaskRef != "P6-09" || createdTask.Phase != "P6" || !createdTask.IsP6Deferred {
		t.Fatalf("expected task with TaskRef=P6-09, Phase=P6, IsP6Deferred=true, got %s, %s, %v",
			createdTask.TaskRef, createdTask.Phase, createdTask.IsP6Deferred)
	}
	if createdTask.SourceThreadId != sampleThreadID {
		t.Fatalf("expected source thread ID preserved, got %s", createdTask.SourceThreadId)
	}
}

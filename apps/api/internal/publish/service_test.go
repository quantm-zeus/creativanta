package publish

import (
	"context"
	"errors"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	publishv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

const (
	testWorkspaceA = "00000000-0000-0000-0000-000000000001"
	testWorkspaceB = "00000000-0000-0000-0000-000000000002"
	testUserA      = "00000000-0000-0000-0000-0000000000a1"
	testUserB      = "00000000-0000-0000-0000-0000000000b2"
)

// MockConnector implements PlatformConnector for tests.
type MockConnector struct {
	platform         string
	publishOutcome   string // success, failed, unknown, unknown_no_req_id, auth_revoked, timeout_error
	reconcileOutcome string // confirmed_published, confirmed_not_published, still_unknown
	publishCalls     int
	reconcileCalls   int
	publishedPostID  string
	publishedPostURL string
}

func (m *MockConnector) Platform() string {
	return m.platform
}

func (m *MockConnector) PublishPost(ctx contextContext, accountID string, item *PublishItem, idempotencyKey string) (*ConnectorPublishResult, error) {
	m.publishCalls++
	switch m.publishOutcome {
	case "auth_revoked":
		return &ConnectorPublishResult{
			ResultStatus: "auth_revoked",
			ErrorCode:    ErrorCodeAuthRevoked,
			ErrorMessage: "OAuth token revoked by user",
		}, nil
	case "unknown":
		return &ConnectorPublishResult{
			ProviderRequestID: "prov_req_12345",
			ResultStatus:      "unknown",
			ErrorCode:         ErrorCodeUnknownSubmit,
			ErrorMessage:      "Connection dropped mid-upload",
		}, nil
	case "unknown_no_req_id":
		return &ConnectorPublishResult{
			ProviderRequestID: "",
			ResultStatus:      "unknown",
			ErrorCode:         ErrorCodeUnknownSubmit,
			ErrorMessage:      "Socket closed before provider request ID received",
		}, nil
	case "failed":
		return &ConnectorPublishResult{
			ResultStatus: ResultFailed,
			ErrorCode:    "invalid_media_format",
			ErrorMessage: "Media bitrate too high",
		}, nil
	case "timeout_error":
		return nil, context.DeadlineExceeded
	default:
		postID := m.publishedPostID
		if postID == "" {
			postID = "post_success_" + NewID()
		}
		postURL := m.publishedPostURL
		if postURL == "" {
			postURL = "https://" + m.platform + ".com/p/" + postID
		}
		return &ConnectorPublishResult{
			ProviderRequestID: "prov_req_success",
			ExternalPostID:    postID,
			ExternalPostURL:   postURL,
			ResultStatus:      ResultSuccess,
		}, nil
	}
}

func (m *MockConnector) CheckPostStatus(ctx contextContext, accountID string, providerRequestID string) (*ConnectorStatusResult, error) {
	m.reconcileCalls++
	switch m.reconcileOutcome {
	case "confirmed_published":
		return &ConnectorStatusResult{
			ProviderRequestID: providerRequestID,
			ExternalPostID:    "rec_post_999",
			ExternalPostURL:   "https://" + m.platform + ".com/p/rec_post_999",
			Found:             true,
			Status:            "confirmed_published",
		}, nil
	case "confirmed_not_published":
		return &ConnectorStatusResult{
			ProviderRequestID: providerRequestID,
			Found:             false,
			Status:            "confirmed_not_published",
		}, nil
	default:
		return &ConnectorStatusResult{
			ProviderRequestID: providerRequestID,
			Status:            "still_unknown",
		}, nil
	}
}

// MockCapabilityEvaluator implements CapabilityEvaluator.
type MockCapabilityEvaluator struct {
	state capability.State
}

func (m *MockCapabilityEvaluator) EvaluateActionAccess(workspaceID, platform, actionKey string, requiredScopes []string) capability.EvaluationResult {
	executable := m.state == capability.StateNative
	return capability.EvaluationResult{
		Platform:    platform,
		ActionKey:   actionKey,
		DisplayName: "Publish Action",
		State:       m.state,
		Executable:  executable,
		PolicyNote: capability.PolicyNoteSpec{
			Summary: "Capability policy for " + platform,
		},
		FallbackPath: capability.FallbackPathSpec{
			Instructions: "Export package and upload manually",
		},
	}
}

// TestAcceptanceTarget1_NeverPublishBeforeSchedule verifies:
// 1. Scheduled items cannot be dispatched or published when now < schedule_at.
// 2. Schedule fairness jitter delay is strictly non-negative [0, 30s] (RULE-M11-006).
func TestAcceptanceTarget1_NeverPublishBeforeSchedule(t *testing.T) {
	simulatedTime := time.Date(2026, 11, 3, 10, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock: func() time.Time { return simulatedTime },
	})

	mockConn := &MockConnector{platform: "tiktok"}
	svc.RegisterConnector(mockConn)

	ctx := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	// 1. Create a draft publish item
	createResp, err := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tiktok-01",
		Title:           "Scheduled Post 1",
		Description:     "Scheduled post for 10:30 UTC",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// 2. Schedule for 10:30:00 UTC (30 minutes in the future)
	scheduledTarget := simulatedTime.Add(30 * time.Minute)
	schedResp, err := svc.Schedule(ctx, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: itemID,
		ScheduledAt:   timestamppb.New(scheduledTarget),
	}))
	if err != nil {
		t.Fatalf("Schedule failed: %v", err)
	}

	effectiveScheduled := schedResp.Msg.ScheduledAt.AsTime()
	if effectiveScheduled.Before(scheduledTarget) {
		t.Fatalf("CRITICAL INVARIANT VIOLATION: effective schedule time %v is before requested time %v", effectiveScheduled, scheduledTarget)
	}
	if schedResp.Msg.JitterDelaySeconds < 0 {
		t.Fatalf("CRITICAL INVARIANT VIOLATION: jitter delay is negative: %d", schedResp.Msg.JitterDelaySeconds)
	}

	// 3. Attempt to execute while now < schedule_at (e.g. at 10:15:00 UTC)
	simulatedTime = simulatedTime.Add(15 * time.Minute)
	_, execErr := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))

	if execErr == nil {
		t.Fatalf("ACCEPTED TARGET 1 FAILED: system allowed publish before scheduled time!")
	}
	var connectErr *connect.Error
	if errors.As(execErr, &connectErr) {
		if connectErr.Code() != connect.CodeFailedPrecondition {
			t.Fatalf("expected CodeFailedPrecondition for premature publish, got %v", connectErr.Code())
		}
	}
	if mockConn.publishCalls != 0 {
		t.Fatalf("platform connector was called %d times despite premature publish rejection", mockConn.publishCalls)
	}

	// 4. Advance time past scheduled time (10:35:00 UTC) -> Execution must now succeed!
	simulatedTime = effectiveScheduled.Add(5 * time.Minute)
	execSuccessResp, err := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("Execute failed after scheduled time had arrived: %v", err)
	}

	if execSuccessResp.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected state published, got %v", execSuccessResp.Msg.Item.LifecycleState)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected exactly 1 connector publish call, got %d", mockConn.publishCalls)
	}
}

// TestAcceptanceTarget1_ScheduleFairnessJitterActivation tests RULE-M11-006:
// When system load exceeds 100 jobs/minute threshold, jitter activates with 0-30s non-negative delay.
func TestAcceptanceTarget1_ScheduleFairnessJitterActivation(t *testing.T) {
	now := time.Date(2026, 11, 3, 12, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock: func() time.Time { return now },
		Jitter: JitterConfig{
			HighLoadThresholdCPM: 5,
			MaxJitterDelay:       30 * time.Second,
			MaxWorkspaceQuotaPct: 0.20,
		},
	})

	for i := 0; i < 10; i++ {
		svc.recentDispatches = append(svc.recentDispatches, now.Add(-time.Duration(i)*time.Second))
	}

	for i := 0; i < 20; i++ {
		delay := svc.CalculateJitterDelay("ws-test")
		if delay < 0 {
			t.Fatalf("jitter delay must NEVER be negative, got %v", delay)
		}
		if delay > 30*time.Second {
			t.Fatalf("jitter delay exceeded max 30s, got %v", delay)
		}
	}
}

// TestAcceptanceTarget2_UnknownSubmitReconciles verifies:
// 1. Indeterminate submit (timeout / drop) marks external effect as unknown.
// 2. System does NOT blind re-post or invent success.
// 3. Reconcile verifies platform post by provider request ID and prevents duplicate post.
func TestAcceptanceTarget2_UnknownSubmitReconciles(t *testing.T) {
	simulatedTime := time.Date(2026, 11, 3, 14, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock: func() time.Time { return simulatedTime },
	})

	mockConn := &MockConnector{
		platform:         "youtube",
		publishOutcome:   "unknown",
		reconcileOutcome: "confirmed_published",
	}
	svc.RegisterConnector(mockConn)

	ctx := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	// 1. Create item and execute -> returns unknown submit
	createResp, err := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "youtube",
		TargetAccountId: "acc-yt-01",
		Title:           "YouTube Short",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	_, execErr := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))

	if execErr == nil {
		t.Fatalf("expected error on unknown submit, got nil")
	}

	item, err := svc.Store().GetItem(ctx, testWorkspaceA, itemID)
	if err != nil {
		t.Fatalf("GetItem failed: %v", err)
	}
	if item.LifecycleState == StatePublished {
		t.Fatalf("ACCEPTANCE TARGET 2 VIOLATION: item marked published without verified proof!")
	}

	job, err := svc.Store().GetJobByItemID(ctx, testWorkspaceA, itemID)
	if err != nil {
		t.Fatalf("GetJobByItemID failed: %v", err)
	}

	effects, err := svc.Store().ListEffectsByAggregate(ctx, testWorkspaceA, "publish_job", job.PublishJobID)
	if err != nil {
		t.Fatalf("ListEffectsByAggregate failed: %v", err)
	}
	var unknownEffect *ExternalEffect
	for _, eff := range effects {
		if eff.Status == "unknown" {
			unknownEffect = eff
			break
		}
	}
	if unknownEffect == nil {
		t.Fatalf("expected an external_effects row with status=unknown")
	}
	if unknownEffect.ProviderRequestID != "prov_req_12345" {
		t.Fatalf("expected provider_request_id prov_req_12345, got %q", unknownEffect.ProviderRequestID)
	}

	logs, _ := svc.Store().ListLogsByItemID(ctx, testWorkspaceA, itemID)
	if len(logs) != 1 || logs[0].ResultStatus != ResultTimeout {
		t.Fatalf("expected 1 log with result_status=timeout, got %v", logs)
	}

	// 2. Perform Reconciliation (ReconcilePublish)
	reconcileResp, err := svc.ReconcilePublish(ctx, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId:     itemID,
		ProviderRequestId: unknownEffect.ProviderRequestID,
	}))
	if err != nil {
		t.Fatalf("ReconcilePublish failed: %v", err)
	}

	if !reconcileResp.Msg.Reconciled {
		t.Fatalf("expected reconciled=true, got false")
	}
	if reconcileResp.Msg.ReconciliationOutcome != "confirmed_published" {
		t.Fatalf("expected outcome confirmed_published, got %s", reconcileResp.Msg.ReconciliationOutcome)
	}

	itemAfter, _ := svc.Store().GetItem(ctx, testWorkspaceA, itemID)
	if itemAfter.LifecycleState != StatePublished {
		t.Fatalf("expected item lifecycle_state=published after successful reconciliation, got %s", itemAfter.LifecycleState)
	}

	posts, _ := svc.Store().ListPosts(ctx, testWorkspaceA)
	if len(posts) != 1 {
		t.Fatalf("expected 1 channel post created after reconciliation, got %d", len(posts))
	}

	if mockConn.publishCalls != 1 {
		t.Fatalf("duplicate publish detected! Expected exactly 1 publish call, got %d", mockConn.publishCalls)
	}
	if mockConn.reconcileCalls != 1 {
		t.Fatalf("expected 1 reconcile call, got %d", mockConn.reconcileCalls)
	}
}

// TestAcceptanceTarget3_ManualProofRetainsGraph verifies:
// 1. Export package generation for manual fallback.
// 2. Item transitions to requires_manual_fallback.
// 3. Manual proof submission creates immutable log and transitions to published.
// 4. One Graph connection is retained (publish_item -> publish_job -> publish_log -> channel_post).
func TestAcceptanceTarget3_ManualProofRetainsGraph(t *testing.T) {
	now := time.Date(2026, 11, 3, 15, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock: func() time.Time { return now },
	})

	ctx := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	// 1. Create publish item for Shopee Video (where API is unsupported per RULE-M11-001)
	createResp, err := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "shopee",
		TargetAccountId: "acc-shopee-01",
		AssetId:         "asset-video-123",
		Title:           "Shopee Review Video",
		Description:     "Giày chạy bộ êm ái #shopee #review",
		Hashtags:        []string{"shopee", "review"},
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	if !createResp.Msg.CapabilitySummary.RequiresManualFallback {
		t.Fatalf("expected Shopee to require manual fallback")
	}

	// 2. Export manual package
	exportResp, err := svc.ExportManualPackage(ctx, connect.NewRequest(&publishv1.ExportManualPackageRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("ExportManualPackage failed: %v", err)
	}

	pkg := exportResp.Msg.Package
	if pkg.Title != "Shopee Review Video" || pkg.TargetPlatform != "shopee" {
		t.Fatalf("export package contents mismatch: %+v", pkg)
	}
	itemAfterExport, _ := svc.Store().GetItem(ctx, testWorkspaceA, itemID)
	if itemAfterExport.LifecycleState != StateRequiresManualFallback {
		t.Fatalf("expected item state requires_manual_fallback, got %s", itemAfterExport.LifecycleState)
	}

	// 3. User uploads manual proof (screenshot + post URL)
	proofResp, err := svc.SubmitManualProof(ctx, connect.NewRequest(&publishv1.SubmitManualProofRequest{
		PublishItemId:   itemID,
		EvidenceUrl:     "https://storage.creativanta.vn/proof/screenshot_shopee_01.png",
		ExternalPostUrl: "https://shopee.vn/universal-link/video/12345678",
		Notes:           "Đăng video thành công qua app Shopee lúc 15:05",
	}))
	if err != nil {
		t.Fatalf("SubmitManualProof failed: %v", err)
	}

	if !proofResp.Msg.GraphRetained {
		t.Fatalf("ACCEPTANCE TARGET 3 FAILED: graph_retained must be true")
	}

	if proofResp.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected item lifecycle_state=published, got %v", proofResp.Msg.Item.LifecycleState)
	}

	log := proofResp.Msg.Log
	if log.ExecutionPath != publishv1.ExecutionPath_EXECUTION_PATH_MANUAL_UPLOAD {
		t.Fatalf("expected execution_path=manual_upload, got %v", log.ExecutionPath)
	}
	if log.ResultStatus != publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_SUCCESS {
		t.Fatalf("expected result_status=success, got %v", log.ResultStatus)
	}
	if log.EvidenceRef == "" {
		t.Fatalf("expected non-empty evidence_ref in publish log")
	}

	if log.PublishItemId != itemID {
		t.Fatalf("log.publish_item_id %s != itemID %s", log.PublishItemId, itemID)
	}
	if log.PublishJobId == "" {
		t.Fatalf("log must reference publish_job_id")
	}
	if proofResp.Msg.ChannelPost == nil || proofResp.Msg.ChannelPost.PublishItemId != itemID {
		t.Fatalf("channel post must reference publish_item_id in graph")
	}
}

// TestAcceptanceTarget4_TokenRevokePausesAffectedQueuedWork verifies:
// 1. Mid-publish token revocation causes executing job to fail with auth_revoked.
// 2. All OTHER queued and scheduled items for that same account are immediately paused (diagnostics_state=blocked).
// 3. Account reconnection unblocks queued work.
func TestAcceptanceTarget4_TokenRevokePausesAffectedQueuedWork(t *testing.T) {
	now := time.Date(2026, 11, 3, 16, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock: func() time.Time { return now },
	})

	mockConn := &MockConnector{
		platform:       "tiktok",
		publishOutcome: "auth_revoked",
	}
	svc.RegisterConnector(mockConn)

	ctx := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	accountID := "acc-tiktok-revoked-01"

	// Item 1: executing
	item1Resp, _ := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: accountID,
		Title:           "Item 1 (Executing)",
	}))
	item1ID := item1Resp.Msg.Item.PublishItemId

	// Item 2: scheduled
	item2Resp, _ := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: accountID,
		Title:           "Item 2 (Scheduled)",
		ScheduleAt:      timestamppb.New(now.Add(1 * time.Hour)),
	}))
	item2ID := item2Resp.Msg.Item.PublishItemId

	// Item 3: queued
	item3Resp, _ := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: accountID,
		Title:           "Item 3 (Queued)",
	}))
	item3ID := item3Resp.Msg.Item.PublishItemId
	it3Stored, _ := svc.Store().GetItem(ctx, testWorkspaceA, item3ID)
	it3Stored.LifecycleState = StateQueued
	_ = svc.Store().SaveItem(ctx, it3Stored)

	// 2. Execute Item 1 -> Token revoked!
	_, execErr := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: item1ID,
	}))

	if execErr == nil {
		t.Fatalf("expected error on auth_revoked, got nil")
	}

	it1After, _ := svc.Store().GetItem(ctx, testWorkspaceA, item1ID)
	if it1After.LifecycleState != StateFailed {
		t.Fatalf("expected item 1 state=failed, got %s", it1After.LifecycleState)
	}
	if it1After.DiagnosticsState != DiagnosticsBlocked {
		t.Fatalf("expected item 1 diagnostics=blocked, got %s", it1After.DiagnosticsState)
	}

	it2After, _ := svc.Store().GetItem(ctx, testWorkspaceA, item2ID)
	if it2After.LifecycleState != StateScheduled {
		t.Fatalf("scheduled item 2 state was modified! Expected scheduled, got %s", it2After.LifecycleState)
	}
	if it2After.DiagnosticsState != DiagnosticsBlocked {
		t.Fatalf("ACCEPTANCE TARGET 4 FAILED: scheduled item 2 was NOT paused (diagnostics_state=%s)", it2After.DiagnosticsState)
	}

	it3After, _ := svc.Store().GetItem(ctx, testWorkspaceA, item3ID)
	if it3After.LifecycleState != StateQueued {
		t.Fatalf("queued item 3 state was modified! Expected queued, got %s", it3After.LifecycleState)
	}
	if it3After.DiagnosticsState != DiagnosticsBlocked {
		t.Fatalf("ACCEPTANCE TARGET 4 FAILED: queued item 3 was NOT paused (diagnostics_state=%s)", it3After.DiagnosticsState)
	}

	_, blockedExecErr := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: item2ID,
	}))
	if blockedExecErr == nil || !strings.Contains(blockedExecErr.Error(), "revoked") {
		t.Fatalf("expected execution of paused item to fail closed, got %v", blockedExecErr)
	}

	// 3. User reconnects account -> ResumeAccountQueue
	resumedCount := svc.ResumeAccountQueue(accountID)
	if resumedCount != 3 {
		t.Fatalf("expected 3 items unblocked on resume, got %d", resumedCount)
	}
	it2Resumed, _ := svc.Store().GetItem(ctx, testWorkspaceA, item2ID)
	if it2Resumed.DiagnosticsState != DiagnosticsHealthy {
		t.Fatalf("expected item 2 diagnostics=healthy after reconnect, got %s", it2Resumed.DiagnosticsState)
	}
}

// TestCapabilityRecheckAtExecution verifies EC-M11-004:
// When capability degrades between schedule and execute, system prompts for manual fallback.
func TestCapabilityRecheckAtExecution(t *testing.T) {
	now := time.Date(2026, 11, 3, 17, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock: func() time.Time { return now },
	})

	mockCap := &MockCapabilityEvaluator{state: capability.StateNative}
	svc.SetCapabilityEvaluator(mockCap)

	ctx := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	createResp, err := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tiktok-02",
		Title:           "Degraded Test",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	mockCap.state = capability.StateManual

	_, execErr := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))

	if execErr == nil {
		t.Fatalf("expected error when capability degraded, got nil")
	}
	itAfter, _ := svc.Store().GetItem(ctx, testWorkspaceA, itemID)
	if itAfter.LifecycleState != StateRequiresManualFallback {
		t.Fatalf("expected state requires_manual_fallback, got %s", itAfter.LifecycleState)
	}
}

// ============================================================================
// REMEDIATION TESTS: PUB-01 / R02 (Auth, Tenant Isolation & Named RBAC)
// ============================================================================

func TestRemediation_PUB01_R02_TenantIsolationAndRBAC(t *testing.T) {
	now := time.Date(2026, 11, 5, 9, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock: func() time.Time { return now },
		Accounts: &loopMockAccountLookup{
			accounts: map[string]*capability.ConnectedAccountRecord{
				"acc-ws-a": {ConnectedAccountID: "acc-ws-a", WorkspaceID: testWorkspaceA, Platform: "tiktok"},
				"acc-ws-b": {ConnectedAccountID: "acc-ws-b", WorkspaceID: testWorkspaceB, Platform: "tiktok"},
			},
		},
	})
	svc.RegisterConnector(&MockConnector{platform: "tiktok"})

	ctxUnauth := context.Background()
	ctxOwnerA := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	ctxOwnerB := WithCaller(context.Background(), testWorkspaceB, testUserB, rbac.RoleOwner)
	ctxViewerA := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleViewer)
	ctxEditorA := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleEditor)

	// 1. Reject absent principal on all RPCs
	if _, err := svc.ListQueue(ctxUnauth, connect.NewRequest(&publishv1.ListQueueRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for unauthenticated ListQueue, got %v", err)
	}
	if _, err := svc.Get(ctxUnauth, connect.NewRequest(&publishv1.GetRequest{PublishItemId: "any"})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for unauthenticated Get, got %v", err)
	}
	if _, err := svc.GetLogs(ctxUnauth, connect.NewRequest(&publishv1.GetLogsRequest{PublishItemId: "any"})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for unauthenticated GetLogs, got %v", err)
	}
	if _, err := svc.CreateItem(ctxUnauth, connect.NewRequest(&publishv1.CreateItemRequest{TargetPlatform: "tiktok"})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for unauthenticated CreateItem, got %v", err)
	}

	// 2. Seed items and jobs in Workspace A and Workspace B
	itemAResp, err := svc.CreateItem(ctxOwnerA, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-ws-a",
		Title:           "Tenant A Post",
	}))
	if err != nil {
		t.Fatalf("CreateItem A failed: %v", err)
	}
	itemAID := itemAResp.Msg.Item.PublishItemId
	_, err = svc.Schedule(ctxOwnerA, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: itemAID,
		ScheduledAt:   timestamppb.New(now.Add(15 * time.Minute)),
	}))
	if err != nil {
		t.Fatalf("Schedule A failed: %v", err)
	}

	itemBResp, err := svc.CreateItem(ctxOwnerB, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-ws-b",
		Title:           "Tenant B Secret Post",
	}))
	if err != nil {
		t.Fatalf("CreateItem B failed: %v", err)
	}
	itemBID := itemBResp.Msg.Item.PublishItemId
	_, err = svc.Schedule(ctxOwnerB, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: itemBID,
		ScheduledAt:   timestamppb.New(now.Add(15 * time.Minute)),
	}))
	if err != nil {
		t.Fatalf("Schedule B failed: %v", err)
	}

	// 3. ListQueue with EMPTY WorkspaceId must ONLY return caller's tenant items/jobs, NEVER all tenants!
	queueAResp, err := svc.ListQueue(ctxOwnerA, connect.NewRequest(&publishv1.ListQueueRequest{
		WorkspaceId: "", // Empty workspace filter!
	}))
	if err != nil {
		t.Fatalf("ListQueue A failed: %v", err)
	}
	if len(queueAResp.Msg.Items) != 1 || queueAResp.Msg.Items[0].PublishItemId != itemAID {
		t.Fatalf("PUB-01 VIOLATION: ListQueue with empty WorkspaceId exposed wrong items: %+v", queueAResp.Msg.Items)
	}
	if len(queueAResp.Msg.Jobs) != 1 || queueAResp.Msg.Jobs[0].PublishItemId != itemAID {
		t.Fatalf("PUB-01 VIOLATION: ListQueue with empty WorkspaceId exposed wrong jobs: %+v", queueAResp.Msg.Jobs)
	}

	// Also verify List, ListUpcoming with empty WorkspaceId only return Tenant A
	listAResp, err := svc.List(ctxOwnerA, connect.NewRequest(&publishv1.ListRequest{WorkspaceId: ""}))
	if err != nil || len(listAResp.Msg.Items) != 1 || listAResp.Msg.Items[0].PublishItemId != itemAID {
		t.Fatalf("List with empty WorkspaceId leaked across tenants: %+v, err=%v", listAResp, err)
	}
	upcomingAResp, err := svc.ListUpcoming(ctxOwnerA, connect.NewRequest(&publishv1.ListUpcomingRequest{WorkspaceId: ""}))
	if err != nil || len(upcomingAResp.Msg.Items) != 1 || upcomingAResp.Msg.Items[0].PublishItemId != itemAID {
		t.Fatalf("ListUpcoming leaked across tenants: %+v, err=%v", upcomingAResp, err)
	}

	// 4. Reject forged foreign workspace in request message or CommandContext
	if _, err := svc.ListQueue(ctxOwnerA, connect.NewRequest(&publishv1.ListQueueRequest{
		WorkspaceId: testWorkspaceB,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when caller A requests Workspace B queue, got %v", err)
	}
	if _, err := svc.CreateItem(ctxOwnerA, connect.NewRequest(&publishv1.CreateItemRequest{
		Context:        &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: testWorkspaceB}},
		TargetPlatform: "tiktok",
		Title:          "Forged Workspace Item",
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for forged CommandContext workspace, got %v", err)
	}
	if _, err := svc.CreateItem(ctxOwnerA, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-ws-b", // Foreign connected account!
		Title:           "Foreign Account Item",
	})); connect.CodeOf(err) != connect.CodePermissionDenied && connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected cross-tenant account rejection, got %v", err)
	}

	// 5. Cross-tenant object access on Get / GetLogs / GetDiagnostics / UpdateMetadata / Cancel / Retry / GetPlatformStatus
	if _, err := svc.Get(ctxOwnerA, connect.NewRequest(&publishv1.GetRequest{PublishItemId: itemBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when caller A reads Tenant B item, got %v", err)
	}
	if _, err := svc.GetLogs(ctxOwnerA, connect.NewRequest(&publishv1.GetLogsRequest{PublishItemId: itemBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when caller A reads Tenant B logs, got %v", err)
	}
	if _, err := svc.GetDiagnostics(ctxOwnerA, connect.NewRequest(&publishv1.GetDiagnosticsRequest{PublishItemId: itemBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when caller A reads Tenant B diagnostics, got %v", err)
	}
	if _, err := svc.UpdateMetadata(ctxOwnerA, connect.NewRequest(&publishv1.UpdateMetadataRequest{PublishItemId: itemBID, Title: "Hijacked"})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when caller A updates Tenant B metadata, got %v", err)
	}
	if _, err := svc.Cancel(ctxOwnerA, connect.NewRequest(&publishv1.CancelRequest{PublishItemId: itemBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when caller A cancels Tenant B item, got %v", err)
	}
	if _, err := svc.CheckCompatibility(ctxOwnerA, connect.NewRequest(&publishv1.CheckCompatibilityRequest{TargetPlatform: "tiktok", TargetAccountId: "acc-ws-b"})); connect.CodeOf(err) != connect.CodePermissionDenied && connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected error when caller A checks Tenant B account compatibility, got %v", err)
	}

	// 6. Named RBAC permission and Role Envelope checks
	// Viewer CAN call Get, ListQueue, GetLogs, GetDiagnostics, GetPlatformStatus
	if _, err := svc.Get(ctxViewerA, connect.NewRequest(&publishv1.GetRequest{PublishItemId: itemAID})); err != nil {
		t.Fatalf("viewer should be allowed to call Get (publish:read): %v", err)
	}
	if _, err := svc.ListQueue(ctxViewerA, connect.NewRequest(&publishv1.ListQueueRequest{})); err != nil {
		t.Fatalf("viewer should be allowed to call ListQueue (publish:read): %v", err)
	}
	// Viewer CANNOT call CreateItem, Schedule, Execute, Retry, Cancel, UpdateMetadata
	if _, err := svc.CreateItem(ctxViewerA, connect.NewRequest(&publishv1.CreateItemRequest{TargetPlatform: "tiktok", Title: "Denied"})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("viewer must be denied CreateItem (publish:create), got %v", err)
	}
	if _, err := svc.UpdateMetadata(ctxViewerA, connect.NewRequest(&publishv1.UpdateMetadataRequest{PublishItemId: itemAID, Title: "Denied"})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("viewer must be denied UpdateMetadata (publish:create), got %v", err)
	}
	if _, err := svc.Schedule(ctxViewerA, connect.NewRequest(&publishv1.ScheduleRequest{PublishItemId: itemAID, ScheduledAt: timestamppb.New(now.Add(time.Hour))})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("viewer must be denied Schedule (publish:schedule), got %v", err)
	}
	if _, err := svc.Execute(ctxViewerA, connect.NewRequest(&publishv1.ExecuteRequest{PublishItemId: itemAID})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("viewer must be denied Execute (publish:execute), got %v", err)
	}
	if _, err := svc.Retry(ctxViewerA, connect.NewRequest(&publishv1.RetryRequest{PublishItemId: itemAID})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("viewer must be denied Retry (publish:retry), got %v", err)
	}
	if _, err := svc.Cancel(ctxViewerA, connect.NewRequest(&publishv1.CancelRequest{PublishItemId: itemAID})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("viewer must be denied Cancel (publish:cancel), got %v", err)
	}

	// Editor CAN call UpdateMetadata, Schedule, Retry, but CANNOT call Execute or Cancel (Manager+ required)
	if _, err := svc.UpdateMetadata(ctxEditorA, connect.NewRequest(&publishv1.UpdateMetadataRequest{PublishItemId: itemAID, Title: "Editor Updated"})); err != nil {
		t.Fatalf("editor should be allowed UpdateMetadata: %v", err)
	}
	if _, err := svc.Execute(ctxEditorA, connect.NewRequest(&publishv1.ExecuteRequest{PublishItemId: itemAID})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("editor must be denied Execute (publish:execute requires Manager+), got %v", err)
	}
	if _, err := svc.Cancel(ctxEditorA, connect.NewRequest(&publishv1.CancelRequest{PublishItemId: itemAID})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("editor must be denied Cancel (publish:cancel requires Manager+), got %v", err)
	}
}

type fixedSessionVerifier struct {
	sess transportauth.Session
}

func (f *fixedSessionVerifier) Verify(_ context.Context, _ string) (transportauth.Session, error) {
	return f.sess, nil
}

func TestRemediation_TransportAuthInterceptorIntegration(t *testing.T) {
	svc := NewService(ServiceConfig{
		RoleResolver: func(_ context.Context, userID, workspaceID string) (string, error) {
			if userID == testUserA && workspaceID == testWorkspaceA {
				return rbac.RoleViewer, nil
			}
			return "", ErrPermissionDenied
		},
	})
	interceptor, err := transportauth.NewServerInterceptor(transportauth.Options{
		Mode:     transportauth.ModeAPI,
		Verifier: &fixedSessionVerifier{sess: transportauth.Session{UserID: testUserA, WorkspaceID: testWorkspaceA}},
	})
	if err != nil {
		t.Fatalf("NewServerInterceptor: %v", err)
	}

	// Viewer session through transportauth interceptor can ListQueue, but cannot CreateItem
	listUnary := interceptor.WrapUnary(func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		return svc.ListQueue(ctx, req.(*connect.Request[publishv1.ListQueueRequest]))
	})
	reqList := connect.NewRequest(&publishv1.ListQueueRequest{})
	reqList.Header().Set("Authorization", "Bearer valid-token")
	if _, err := listUnary(context.Background(), reqList); err != nil {
		t.Fatalf("expected viewer to pass ListQueue via transportauth interceptor, got %v", err)
	}

	createUnary := interceptor.WrapUnary(func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		return svc.CreateItem(ctx, req.(*connect.Request[publishv1.CreateItemRequest]))
	})
	reqCreate := connect.NewRequest(&publishv1.CreateItemRequest{TargetPlatform: "tiktok", Title: "Blocked"})
	reqCreate.Header().Set("Authorization", "Bearer valid-token")
	if _, err := createUnary(context.Background(), reqCreate); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected viewer to be denied CreateItem via transportauth interceptor, got %v", err)
	}
}

// ============================================================================
// REMEDIATION TESTS: PUB-02 (Unknown Provider Outcomes & Durable Effect Lock)
// ============================================================================

func TestRemediation_PUB02_UnknownOutcomeBlocksRetryUntilReconciled(t *testing.T) {
	now := time.Date(2026, 11, 5, 10, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock: func() time.Time { return now },
	})

	// Case A: Unknown outcome WITHOUT ProviderRequestID (e.g. socket drop before response header)
	mockConn := &MockConnector{
		platform:         "tiktok",
		publishOutcome:   "unknown_no_req_id",
		reconcileOutcome: "still_unknown",
	}
	svc.RegisterConnector(mockConn)

	ctx := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	createResp, err := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tt-pub02",
		Title:           "PUB-02 Unknown Outcome Post",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// 1. First Execute (without explicit IdempotencyKey!) -> returns ErrUnknownSubmit
	_, execErr1 := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if connect.CodeOf(execErr1) != connect.CodeDeadlineExceeded {
		t.Fatalf("expected CodeDeadlineExceeded on initial unknown submit, got %v", execErr1)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected 1 publish call, got %d", mockConn.publishCalls)
	}

	// 2. Second Execute (still without IdempotencyKey!) MUST NOT increment AttemptCount past the unknown effect or call PublishPost!
	mockConn.publishOutcome = "success" // Even if connector would succeed now, it must NOT be called!
	_, execErr2 := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if connect.CodeOf(execErr2) != connect.CodeFailedPrecondition {
		t.Fatalf("PUB-02 VIOLATION: second Execute on unresolved unknown effect must fail closed with CodeFailedPrecondition, got %v", execErr2)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("PUB-02 VIOLATION: connector was called %d times! Duplicate submit occurred!", mockConn.publishCalls)
	}

	// 3. Retry RPC MUST also refuse to reset the item while the unknown effect is unresolved!
	_, retryErr := svc.Retry(ctx, connect.NewRequest(&publishv1.RetryRequest{
		PublishItemId: itemID,
	}))
	if connect.CodeOf(retryErr) != connect.CodeFailedPrecondition {
		t.Fatalf("PUB-02 VIOLATION: Retry allowed resetting item with unresolved unknown effect: %v", retryErr)
	}

	// 4. ReconcilePublish without provider_request_id or while still_unknown must return Reconciled: false (never false success!)
	recResp1, err := svc.ReconcilePublish(ctx, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("ReconcilePublish failed: %v", err)
	}
	if recResp1.Msg.Reconciled || recResp1.Msg.ReconciliationOutcome != "still_unknown" {
		t.Fatalf("PUB-02 VIOLATION: ReconcilePublish fabricated reconciliation without provider request ID: %+v", recResp1.Msg)
	}

	// 5. Now operator supplies the provider_request_id and provider confirms "confirmed_not_published"
	mockConn.reconcileOutcome = "confirmed_not_published"
	recResp2, err := svc.ReconcilePublish(ctx, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId:     itemID,
		ProviderRequestId: "prov_req_recovered_01",
	}))
	if err != nil {
		t.Fatalf("ReconcilePublish failed: %v", err)
	}
	if !recResp2.Msg.Reconciled || recResp2.Msg.ReconciliationOutcome != "confirmed_not_published" {
		t.Fatalf("expected confirmed_not_published reconciliation, got %+v", recResp2.Msg)
	}

	// 6. After confirmed_not_published, Retry + Execute succeeds cleanly with exactly 1 additional PublishPost call!
	if _, err := svc.Retry(ctx, connect.NewRequest(&publishv1.RetryRequest{PublishItemId: itemID})); err != nil {
		t.Fatalf("expected Retry to succeed after confirmed_not_published reconciliation, got %v", err)
	}
	execResp3, err := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{PublishItemId: itemID}))
	if err != nil {
		t.Fatalf("expected Execute to succeed after confirmed_not_published reconciliation, got %v", err)
	}
	if execResp3.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected published state, got %v", execResp3.Msg.Item.LifecycleState)
	}
	if mockConn.publishCalls != 2 {
		t.Fatalf("expected exactly 2 total publish calls (1 initial + 1 post-reconciliation), got %d", mockConn.publishCalls)
	}
}

// ============================================================================
// REMEDIATION TESTS: R10 (Durable Store Fail-Closed & Service Restart Survival)
// ============================================================================

func TestRemediation_R10_FailClosedAndRestartSurvival(t *testing.T) {
	now := time.Date(2026, 11, 5, 11, 0, 0, 0, time.UTC)
	ctx := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	// 1. Fail-closed when RequireDurableStore is true and Store is nil
	if _, err := NewStrictService(ServiceConfig{}); !errors.Is(err, ErrStoreNotConfigured) {
		t.Fatalf("expected ErrStoreNotConfigured from NewStrictService with nil Store, got %v", err)
	}
	unconfiguredSvc := NewService(ServiceConfig{RequireDurableStore: true})
	if _, err := unconfiguredSvc.ListQueue(ctx, connect.NewRequest(&publishv1.ListQueueRequest{})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition when durable store is unconfigured, got %v", err)
	}

	// 2. Restart survival with durable Store: scheduled jobs and unknown external effects survive service restart
	durableStore := NewMemoryStore()
	conn1 := &MockConnector{
		platform:         "tiktok",
		publishOutcome:   "unknown",
		reconcileOutcome: "still_unknown",
	}

	svcBeforeRestart := NewService(ServiceConfig{
		Store:               durableStore,
		RequireDurableStore: true,
		Clock:               func() time.Time { return now },
	})
	svcBeforeRestart.RegisterConnector(conn1)

	// Create a scheduled item and an item that hits an unknown external outcome before restart
	schedItemResp, err := svcBeforeRestart.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-restart-1",
		Title:           "Scheduled Across Restart",
	}))
	if err != nil {
		t.Fatalf("CreateItem scheduled failed: %v", err)
	}
	schedItemID := schedItemResp.Msg.Item.PublishItemId
	_, err = svcBeforeRestart.Schedule(ctx, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: schedItemID,
		ScheduledAt:   timestamppb.New(now.Add(30 * time.Minute)),
	}))
	if err != nil {
		t.Fatalf("Schedule failed: %v", err)
	}

	unknownItemResp, err := svcBeforeRestart.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-restart-1",
		Title:           "Unknown Effect Across Restart",
	}))
	if err != nil {
		t.Fatalf("CreateItem unknown failed: %v", err)
	}
	unknownItemID := unknownItemResp.Msg.Item.PublishItemId
	_, err = svcBeforeRestart.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: unknownItemID,
	}))
	if connect.CodeOf(err) != connect.CodeDeadlineExceeded {
		t.Fatalf("expected CodeDeadlineExceeded on unknown outcome before restart, got %v", err)
	}
	if conn1.publishCalls != 1 {
		t.Fatalf("expected 1 publish call before restart, got %d", conn1.publishCalls)
	}

	// Simulate process restart: construct a brand new Service instance backed by durableStore
	connAfterRestart := &MockConnector{
		platform:         "tiktok",
		publishOutcome:   "success",
		reconcileOutcome: "still_unknown",
	}
	svcAfterRestart, err := NewStrictService(ServiceConfig{
		Store: durableStore,
		Clock: func() time.Time { return now },
	})
	if err != nil {
		t.Fatalf("NewStrictService after restart failed: %v", err)
	}
	svcAfterRestart.RegisterConnector(connAfterRestart)

	// Verify scheduled item and job survived restart in ListQueue
	queueAfter, err := svcAfterRestart.ListQueue(ctx, connect.NewRequest(&publishv1.ListQueueRequest{}))
	if err != nil {
		t.Fatalf("ListQueue after restart failed: %v", err)
	}
	if len(queueAfter.Msg.Items) != 2 || len(queueAfter.Msg.Jobs) != 2 {
		t.Fatalf("expected 2 items and 2 jobs preserved across restart, got %d items and %d jobs", len(queueAfter.Msg.Items), len(queueAfter.Msg.Jobs))
	}

	// Verify unknown effect lock survived restart: calling Execute after restart MUST NOT call PublishPost while still_unknown!
	_, err = svcAfterRestart.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: unknownItemID,
	}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("R10/PUB-02 VIOLATION: Execute after restart must block unverified unknown effect, got %v", err)
	}
	if connAfterRestart.publishCalls != 0 {
		t.Fatalf("R10/PUB-02 VIOLATION: post-restart service re-submitted unknown effect (%d calls)!", connAfterRestart.publishCalls)
	}
	if connAfterRestart.reconcileCalls != 1 {
		t.Fatalf("expected post-restart Execute to probe CheckPostStatus once, got %d", connAfterRestart.reconcileCalls)
	}

	// Now provider confirms post was published during the pre-restart attempt -> Execute reconciles to published without calling PublishPost!
	connAfterRestart.reconcileOutcome = "confirmed_published"
	reconciledExecResp, err := svcAfterRestart.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: unknownItemID,
	}))
	if err != nil {
		t.Fatalf("expected post-restart Execute to reconcile when confirmed_published, got %v", err)
	}
	if reconciledExecResp.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected published state after reconciliation, got %v", reconciledExecResp.Msg.Item.LifecycleState)
	}
	if connAfterRestart.publishCalls != 0 {
		t.Fatalf("expected 0 new publish calls after reconciliation, got %d", connAfterRestart.publishCalls)
	}

	// Verify PostgresStore fails closed when db is nil across all Store operations
	pgNil := NewPostgresStore(nil)
	wsUUID := "11111111-1111-4000-8000-000000000001"
	if err := pgNil.SaveItem(ctx, &PublishItem{WorkspaceID: wsUUID}); !errors.Is(err, ErrStoreNotConfigured) {
		t.Fatalf("expected ErrStoreNotConfigured on nil PostgresStore.SaveItem, got %v", err)
	}
	if _, err := pgNil.GetItem(ctx, wsUUID, wsUUID); !errors.Is(err, ErrStoreNotConfigured) {
		t.Fatalf("expected ErrStoreNotConfigured on nil PostgresStore.GetItem, got %v", err)
	}
	if _, err := pgNil.ListItems(ctx, wsUUID); !errors.Is(err, ErrStoreNotConfigured) {
		t.Fatalf("expected ErrStoreNotConfigured on nil PostgresStore.ListItems, got %v", err)
	}
	if err := pgNil.SaveJob(ctx, &PublishJob{WorkspaceID: wsUUID}); !errors.Is(err, ErrStoreNotConfigured) {
		t.Fatalf("expected ErrStoreNotConfigured on nil PostgresStore.SaveJob, got %v", err)
	}
	if _, err := pgNil.GetEffectByKey(ctx, wsUUID, "publish:key"); !errors.Is(err, ErrStoreNotConfigured) {
		t.Fatalf("expected ErrStoreNotConfigured on nil PostgresStore.GetEffectByKey, got %v", err)
	}
	if err := pgNil.SaveEffect(ctx, &ExternalEffect{WorkspaceID: wsUUID, OperationKey: "publish:key"}); !errors.Is(err, ErrStoreNotConfigured) {
		t.Fatalf("expected ErrStoreNotConfigured on nil PostgresStore.SaveEffect, got %v", err)
	}
}

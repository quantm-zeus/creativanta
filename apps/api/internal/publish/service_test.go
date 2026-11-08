package publish

import (
	"context"
	"errors"
	"io"
	"strings"
	"sync"
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
	mu                 sync.Mutex
	platform           string
	publishOutcome     string // success, failed, unknown, unknown_no_req_id, auth_revoked, timeout_error
	reconcileOutcome   string // confirmed_published, confirmed_not_published, still_unknown
	publishCalls       int
	reconcileCalls     int
	publishedPostID    string
	publishedPostURL   string
	boundRecoveryReqID string
	lastOpKey          string
	lastAccountID      string
	lastItemID         string
	lastRequestHash    string
}

func (m *MockConnector) Platform() string {
	return m.platform
}

func (m *MockConnector) PublishPost(ctx contextContext, accountID string, item *PublishItem, idempotencyKey string) (*ConnectorPublishResult, error) {
	m.mu.Lock()
	m.publishCalls++
	outcome := m.publishOutcome
	postID := m.publishedPostID
	postURL := m.publishedPostURL
	m.lastOpKey = idempotencyKey
	m.lastAccountID = accountID
	if item != nil {
		m.lastItemID = item.PublishItemID
		m.lastRequestHash = computePublishRequestHash(item)
	}
	m.mu.Unlock()
	switch outcome {
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
		if postID == "" {
			postID = "post_success_" + NewID()
		}
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
	m.mu.Lock()
	m.reconcileCalls++
	outcome := m.reconcileOutcome
	var opKey, connAccID, itemID, reqHash string
	if m.boundRecoveryReqID != "" && providerRequestID == m.boundRecoveryReqID {
		opKey = m.lastOpKey
		connAccID = m.lastAccountID
		itemID = m.lastItemID
		reqHash = m.lastRequestHash
	}
	m.mu.Unlock()
	switch outcome {
	case "confirmed_published":
		return &ConnectorStatusResult{
			ProviderRequestID:  providerRequestID,
			OperationKey:       opKey,
			ConnectedAccountID: connAccID,
			PublishItemID:      itemID,
			RequestHash:        reqHash,
			ExternalPostID:     "rec_post_999",
			ExternalPostURL:    "https://" + m.platform + ".com/p/rec_post_999",
			Found:              true,
			Status:             "confirmed_published",
		}, nil
	case "confirmed_not_published":
		return &ConnectorStatusResult{
			ProviderRequestID:  providerRequestID,
			OperationKey:       opKey,
			ConnectedAccountID: connAccID,
			PublishItemID:      itemID,
			RequestHash:        reqHash,
			Found:              false,
			Status:             "confirmed_not_published",
		}, nil
	default:
		return &ConnectorStatusResult{
			ProviderRequestID:  providerRequestID,
			OperationKey:       opKey,
			ConnectedAccountID: connAccID,
			PublishItemID:      itemID,
			RequestHash:        reqHash,
			Status:             "still_unknown",
		}, nil
	}
}

type testFixtureComplianceChecker struct {
	inner *CanonicalComplianceChecker
}

type testFixtureComplianceSource struct{}

func (testFixtureComplianceSource) GetAssetComplianceRecord(_ context.Context, workspaceID, assetID string) (*AssetComplianceRecord, error) {
	return &AssetComplianceRecord{
		AssetID:        assetID,
		WorkspaceID:    workspaceID,
		QualityState:   "pass",
		PackagingScore: 88.0,
		RightsVerified: true,
	}, nil
}

func (testFixtureComplianceSource) GetPublishConsentRecord(_ context.Context, _, _ string) (*PublishConsentRecord, error) {
	return nil, nil
}

func newTestFixtureComplianceChecker() ComplianceChecker {
	return &testFixtureComplianceChecker{
		inner: NewCanonicalComplianceCheckerWithSource(testFixtureComplianceSource{}),
	}
}

func (t *testFixtureComplianceChecker) CheckPublishCompliance(ctx context.Context, workspaceID, assetID, targetPlatform string) (string, bool, map[string]any, error) {
	if strings.TrimSpace(assetID) == "" {
		assetID = "test-fixture-asset-default"
	}
	return t.inner.CheckPublishCompliance(ctx, workspaceID, assetID, targetPlatform)
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
		Clock:             func() time.Time { return simulatedTime },
		ComplianceChecker: newTestFixtureComplianceChecker(),
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
		Clock:             func() time.Time { return simulatedTime },
		ComplianceChecker: newTestFixtureComplianceChecker(),
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
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
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
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
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
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
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
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
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
		ComplianceChecker: newTestFixtureComplianceChecker(),
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
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
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

	// 5. Now operator supplies the provider_request_id and provider confirms "confirmed_not_published" (bound to the submitted operation)
	mockConn.boundRecoveryReqID = "prov_req_recovered_01"
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
		ComplianceChecker:   newTestFixtureComplianceChecker(),
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
		Store:             durableStore,
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
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

// ============================================================================
// REMEDIATION TESTS: R4 (Hard-Block Gate, Missing Connector, Log Atomicity, Job-Item Binding)
// ============================================================================

type testComplianceChecker struct {
	scanResult    string
	hasHardBlocks bool
	details       map[string]any
	err           error
}

func (c *testComplianceChecker) CheckPublishCompliance(_ context.Context, _, _, _ string) (string, bool, map[string]any, error) {
	return c.scanResult, c.hasHardBlocks, c.details, c.err
}

type failingAppendLogStore struct {
	Store
	failAppendLog bool
}

func (s *failingAppendLogStore) AppendLog(ctx context.Context, log *PublishLog) error {
	if s.failAppendLog {
		return errors.New("simulated immutable publish_logs write failure")
	}
	return s.Store.AppendLog(ctx, log)
}

type staticApprovalChecker struct {
	requireApproval bool
	approvedIDs     map[string]bool
}

func (a *staticApprovalChecker) RequiresApproval(_, _ string) bool {
	return a.requireApproval
}

func (a *staticApprovalChecker) IsApproved(_, approvalRequestID string) bool {
	return a.approvedIDs[approvalRequestID]
}

func TestR4_Publish_ComplianceHardBlockAndDiagnosticsGateCannotBeBypassed(t *testing.T) {
	now := time.Date(2026, 11, 6, 12, 0, 0, 0, time.UTC)
	checker := &testComplianceChecker{
		scanResult:    "blocked",
		hasHardBlocks: true,
		details:       map[string]any{"violation": "music_license_hard_block"},
	}
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: checker,
	})
	mockConn := &MockConnector{platform: "tiktok", publishOutcome: "success"}
	svc.RegisterConnector(mockConn)

	// Even Owner cannot bypass a compliance hard block!
	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	createResp, err := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-r4-hb",
		AssetId:         "asset-hard-blocked-1",
		Title:           "Hard Blocked Asset",
	}))
	if err != nil {
		t.Fatalf("CreateItem draft should succeed and record blocked diagnostics, got: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// 1. Schedule must fail with CodeFailedPrecondition (ErrComplianceHardBlocked)
	if _, err := svc.Schedule(ctxOwner, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: itemID,
		ScheduledAt:   timestamppb.New(now.Add(15 * time.Minute)),
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected Schedule to be blocked by compliance hard block, got: %v", err)
	}

	// 2. Execute must fail with CodeFailedPrecondition and 0 connector calls
	if _, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected Execute to be blocked by compliance hard block even for Owner, got: %v", err)
	}
	if mockConn.publishCalls != 0 {
		t.Fatalf("expected 0 connector calls on hard-blocked item, got %d", mockConn.publishCalls)
	}

	// 3. SubmitManualProof must also fail on hard-blocked item
	if _, err := svc.SubmitManualProof(ctxOwner, connect.NewRequest(&publishv1.SubmitManualProofRequest{
		PublishItemId:   itemID,
		ExternalPostUrl: "https://tiktok.com/@brand/video/123",
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected SubmitManualProof to be blocked by compliance hard block, got: %v", err)
	}

	// 4. Soft-flag review_required without override acknowledgement/reason must fail, then succeed once overridden
	checker.scanResult = "review_required"
	checker.hasHardBlocks = false
	checker.details = map[string]any{"soft_flag": "borderline_claim"}

	softResp, err := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-r4-hb",
		AssetId:         "asset-soft-review-1",
		Title:           "Soft Flagged Asset",
	}))
	if err != nil {
		t.Fatalf("CreateItem soft-flagged failed: %v", err)
	}
	softID := softResp.Msg.Item.PublishItemId

	if _, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: softID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected review_required without override to fail with FailedPrecondition, got: %v", err)
	}

	// Acknowledge soft-flag override with reason
	softItem, _ := svc.Store().GetItem(ctxOwner, testWorkspaceA, softID)
	softItem.ComplianceDetails["override_acknowledged"] = true
	softItem.ComplianceDetails["override_reason"] = "Legal team approved substantiation doc #442"
	softItem.DiagnosticsState = DiagnosticsHealthy
	_ = svc.Store().SaveItem(ctxOwner, softItem)

	if _, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: softID,
	})); err != nil {
		t.Fatalf("expected review_required with valid override to succeed, got: %v", err)
	}
}

func TestR4_Publish_UnconfiguredConnectorFailsClosedWithoutFakeSuccess(t *testing.T) {
	now := time.Date(2026, 11, 6, 13, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
		// No connectors registered!
	})
	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	createResp, err := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "youtube",
		TargetAccountId: "acc-yt-unconf",
		Title:           "Unconfigured Connector Video",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	_, execErr := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if connect.CodeOf(execErr) != connect.CodeFailedPrecondition {
		t.Fatalf("expected Execute without configured connector to fail closed with CodeFailedPrecondition, got: %v", execErr)
	}

	itemAfter, _ := svc.Store().GetItem(ctxOwner, testWorkspaceA, itemID)
	if itemAfter.LifecycleState == StatePublished {
		t.Fatalf("item must NOT be marked published when connector is missing!")
	}
	logs, _ := svc.Store().ListLogsByItemID(ctxOwner, testWorkspaceA, itemID)
	if len(logs) != 0 {
		t.Fatalf("expected 0 publish logs when connector is missing, got %d", len(logs))
	}
	post, _ := svc.Store().GetPostByItemID(ctxOwner, testWorkspaceA, itemID)
	if post != nil {
		t.Fatalf("expected nil ChannelPost when connector is missing, got %+v", post)
	}
}

func TestR4_Publish_AppendLogFailurePreventsPublishedStateAndRecoversOnRetry(t *testing.T) {
	now := time.Date(2026, 11, 6, 14, 0, 0, 0, time.UTC)
	baseStore := NewMemoryStore()
	wrapStore := &failingAppendLogStore{
		Store:         baseStore,
		failAppendLog: true,
	}
	svc := NewService(ServiceConfig{
		Store:             wrapStore,
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	mockConn := &MockConnector{
		platform:       "tiktok",
		publishOutcome: "success",
	}
	svc.RegisterConnector(mockConn)

	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	createResp, err := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tt-logfail",
		Title:           "Log Atomicity Video",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// 1. First Execute: connector succeeds, but AppendLog fails -> MUST return Internal error and NOT mark item published!
	_, err = svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if connect.CodeOf(err) != connect.CodeInternal {
		t.Fatalf("expected CodeInternal when AppendLog fails, got: %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected 1 connector publish call, got %d", mockConn.publishCalls)
	}
	itemMid, _ := baseStore.GetItem(ctxOwner, testWorkspaceA, itemID)
	if itemMid.LifecycleState == StatePublished {
		t.Fatalf("RULE-M11-002 VIOLATION: item marked published despite AppendLog failure!")
	}

	// 2. Restore AppendLog and retry Execute: must repair log/item/job/post from succeeded ExternalEffect WITHOUT calling connector again!
	wrapStore.failAppendLog = false
	execResp, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("expected retry Execute after transient AppendLog failure to repair state, got: %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected 1 total connector publish call (no duplicate post on repair), got %d", mockConn.publishCalls)
	}
	if execResp.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected item state PUBLISHED after repair, got %v", execResp.Msg.Item.LifecycleState)
	}
	if execResp.Msg.Log == nil || execResp.Msg.Log.ResultStatus != publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_SUCCESS {
		t.Fatalf("expected repaired success log, got %+v", execResp.Msg.Log)
	}
}

func TestR4_Publish_ApprovedJobCannotBeReusedForDifferentItem(t *testing.T) {
	now := time.Date(2026, 11, 6, 15, 0, 0, 0, time.UTC)
	store := NewMemoryStore()
	approvals := &staticApprovalChecker{
		requireApproval: true,
		approvedIDs:     map[string]bool{"apr-item-a": true},
	}
	svc := NewService(ServiceConfig{
		Store:             store,
		Clock:             func() time.Time { return now },
		ApprovalChecker:   approvals,
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	mockConn := &MockConnector{platform: "tiktok", publishOutcome: "success"}
	svc.RegisterConnector(mockConn)

	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	itemAResp, _ := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tt-apr",
		Title:           "Approved Item A",
	}))
	itemAID := itemAResp.Msg.Item.PublishItemId

	itemBResp, _ := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tt-apr",
		Title:           "Unapproved Item B",
	}))
	itemBID := itemBResp.Msg.Item.PublishItemId

	// Create an approved job bound to Item A
	jobA := &PublishJob{
		PublishJobID:      "job-approved-for-a",
		WorkspaceID:       testWorkspaceA,
		PublishItemID:     itemAID,
		DispatchStrategy:  "direct",
		LifecycleState:    JobStateCreated,
		ApprovalRequestID: "apr-item-a",
		CreatedAt:         now,
		UpdatedAt:         now,
	}
	_ = store.SaveJob(ctxOwner, jobA)

	// Attempting to execute Item B using Item A's approved job MUST fail with CodeInvalidArgument (ErrJobItemMismatch)
	_, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemBID,
		PublishJobId:  jobA.PublishJobID,
	}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument when reusing Item A's approved job for Item B, got: %v", err)
	}
	if mockConn.publishCalls != 0 {
		t.Fatalf("expected 0 connector calls when job-item binding fails, got %d", mockConn.publishCalls)
	}

	// Attempting ReconcilePublish on Item B with Item A's job ID MUST also fail with CodeInvalidArgument
	_, err = svc.ReconcilePublish(ctxOwner, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId: itemBID,
		PublishJobId:  jobA.PublishJobID,
	}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument on ReconcilePublish with mismatched job ID, got: %v", err)
	}

	// Executing Item A with its own approved jobA succeeds
	if _, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemAID,
		PublishJobId:  jobA.PublishJobID,
	})); err != nil {
		t.Fatalf("expected Item A with its own approved job to succeed, got: %v", err)
	}
}

// ============================================================================
// REMEDIATION TESTS: S6 (F1, F2, F5, F6, F7, F8, F12)
// ============================================================================

func sessionContextFromInterceptor(t *testing.T, sess transportauth.Session) context.Context {
	t.Helper()
	interceptor, err := transportauth.NewServerInterceptor(transportauth.Options{
		Mode:     transportauth.ModeAPI,
		Verifier: &fixedSessionVerifier{sess: sess},
	})
	if err != nil {
		t.Fatalf("NewServerInterceptor: %v", err)
	}
	var capturedCtx context.Context
	unary := interceptor.WrapUnary(func(ctx context.Context, _ connect.AnyRequest) (connect.AnyResponse, error) {
		capturedCtx = ctx
		return connect.NewResponse(&publishv1.ListQueueResponse{}), nil
	})
	req := connect.NewRequest(&publishv1.ListQueueRequest{})
	req.Header().Set("Authorization", "Bearer valid-session-token")
	if _, err := unary(context.Background(), req); err != nil {
		t.Fatalf("interceptor session setup failed: %v", err)
	}
	return capturedCtx
}

func TestS6_F1_PublishAuthorizationFailsClosedWithoutRoleElevation(t *testing.T) {
	now := time.Date(2026, 11, 7, 10, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
		// Intentionally nil RoleResolver to test fail-closed behavior!
	})
	mockConn := &MockConnector{platform: "tiktok", publishOutcome: "success"}
	svc.RegisterConnector(mockConn)

	// Seed an item as Owner
	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	createResp, err := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-s6-f1",
		Title:           "S6 F1 RBAC Item",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// 1. Session with Viewer role and nil RoleResolver MUST NOT elevate to Manager!
	ctxSessionViewer := sessionContextFromInterceptor(t, transportauth.Session{
		UserID:      testUserA,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleViewer,
	})
	if _, err := svc.Execute(ctxSessionViewer, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: Viewer session without RoleResolver was elevated on Execute: %v", err)
	}
	if _, err := svc.CreateItem(ctxSessionViewer, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform: "tiktok",
		Title:          "Viewer Create",
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: Viewer session without RoleResolver was allowed CreateItem: %v", err)
	}

	// 2. Session with Editor role and nil RoleResolver MUST be denied Execute and PublishVariants (requires Manager+)
	ctxSessionEditor := sessionContextFromInterceptor(t, transportauth.Session{
		UserID:      testUserA,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleEditor,
	})
	if _, err := svc.Execute(ctxSessionEditor, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: Editor session was allowed Execute (requires Manager+): %v", err)
	}
	if _, err := svc.PublishVariants(ctxSessionEditor, connect.NewRequest(&publishv1.PublishVariantsRequest{
		Context:        &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: testWorkspaceA}},
		PublishItemIds: []string{itemID},
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: Editor session was allowed PublishVariants (elevated to Manager): %v", err)
	}

	// 3. Session with empty Role and nil RoleResolver MUST fail closed with CodePermissionDenied
	ctxSessionEmptyRole := sessionContextFromInterceptor(t, transportauth.Session{
		UserID:      testUserA,
		WorkspaceID: testWorkspaceA,
		Role:        "",
	})
	if _, err := svc.Get(ctxSessionEmptyRole, connect.NewRequest(&publishv1.GetRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: Session with empty Role and nil RoleResolver did not fail closed: %v", err)
	}

	// 4. WithCaller with empty role MUST NOT default to RoleOwner
	ctxCallerEmptyRole := WithCaller(context.Background(), testWorkspaceA, testUserA, "")
	if _, err := svc.Get(ctxCallerEmptyRole, connect.NewRequest(&publishv1.GetRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: WithCaller empty role defaulted to Owner instead of failing closed: %v", err)
	}

	// 5. Conflicting Session (Viewer) + PolicyContext (Owner) in same context MUST be rejected
	ctxConflicting := WithCaller(ctxSessionViewer, testWorkspaceA, testUserA, rbac.RoleOwner)
	if _, err := svc.Execute(ctxConflicting, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: Conflicting Session(Viewer) and PolicyContext(Owner) was not rejected: %v", err)
	}

	// 6. Conflicting Session (Owner) + RoleResolver (Editor) MUST be rejected
	svcWithResolver := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
		RoleResolver: func(_ context.Context, _, _ string) (string, error) {
			return rbac.RoleEditor, nil
		},
	})
	ctxSessionOwner := sessionContextFromInterceptor(t, transportauth.Session{
		UserID:      testUserA,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	})
	if _, err := svcWithResolver.ListQueue(ctxSessionOwner, connect.NewRequest(&publishv1.ListQueueRequest{})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: Mismatch between Session.Role and RoleResolver was not rejected: %v", err)
	}

	// 7. PublishVariants with Editor via WithCaller MUST fail closed, and with Manager must propagate child errors
	ctxEditor := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleEditor)
	if _, err := svc.PublishVariants(ctxEditor, connect.NewRequest(&publishv1.PublishVariantsRequest{
		Context:        &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: testWorkspaceA}},
		PublishItemIds: []string{itemID},
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("F1 VIOLATION: Editor caller allowed PublishVariants: %v", err)
	}
	if mockConn.publishCalls != 0 {
		t.Fatalf("expected 0 connector calls after all unauthorized attempts, got %d", mockConn.publishCalls)
	}

	ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)
	if _, err := svc.PublishVariants(ctxManager, connect.NewRequest(&publishv1.PublishVariantsRequest{
		Context:        &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: testWorkspaceA}},
		PublishItemIds: []string{"nonexistent-variant-id"},
	})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected PublishVariants to propagate child Execute error (CodeNotFound), got %v", err)
	}
}

func TestS6_F2_ComplianceGateFailsClosedWhenCheckerNilOrConsentRevoked(t *testing.T) {
	now := time.Date(2026, 11, 7, 11, 0, 0, 0, time.UTC)
	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	// Part A: Service with nil ComplianceChecker MUST fail closed on Schedule, Execute, and SubmitManualProof
	svcNilChecker := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: nil,
	})
	mockConn := &MockConnector{platform: "tiktok", publishOutcome: "success"}
	svcNilChecker.RegisterConnector(mockConn)

	draftResp, err := svcNilChecker.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-s6-f2",
		AssetId:         "asset-unverified-1",
		Title:           "Unverified Compliance Item",
	}))
	if err != nil {
		t.Fatalf("CreateItem draft failed: %v", err)
	}
	unverifiedID := draftResp.Msg.Item.PublishItemId

	storedDraft, _ := svcNilChecker.Store().GetItem(ctxOwner, testWorkspaceA, unverifiedID)
	if storedDraft.ComplianceScanResult != "pending" {
		t.Fatalf("F2 VIOLATION: expected default ComplianceScanResult='pending' when checker is nil, got %q", storedDraft.ComplianceScanResult)
	}
	if storedDraft.DiagnosticsState != DiagnosticsBlocked {
		t.Fatalf("F2 VIOLATION: expected DiagnosticsState='blocked' when checker is nil, got %q", storedDraft.DiagnosticsState)
	}

	// Even if someone tampers with stored item fields to say "passed", nil ComplianceChecker must STILL fail closed!
	storedDraft.ComplianceScanResult = "passed"
	storedDraft.DiagnosticsState = DiagnosticsHealthy
	_ = svcNilChecker.Store().SaveItem(ctxOwner, storedDraft)

	if _, err := svcNilChecker.Schedule(ctxOwner, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: unverifiedID,
		ScheduledAt:   timestamppb.New(now.Add(15 * time.Minute)),
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F2 VIOLATION: Schedule succeeded with nil ComplianceChecker: %v", err)
	}
	if _, err := svcNilChecker.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: unverifiedID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F2 VIOLATION: Execute succeeded with nil ComplianceChecker: %v", err)
	}
	if _, err := svcNilChecker.SubmitManualProof(ctxOwner, connect.NewRequest(&publishv1.SubmitManualProofRequest{
		PublishItemId:   unverifiedID,
		ExternalPostUrl: "https://tiktok.com/@user/video/1",
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F2 VIOLATION: SubmitManualProof succeeded with nil ComplianceChecker: %v", err)
	}
	if mockConn.publishCalls != 0 {
		t.Fatalf("expected 0 connector calls when ComplianceChecker is nil, got %d", mockConn.publishCalls)
	}

	// Part B: CanonicalComplianceChecker enforces QA scan, rights status, and consent proof
	canonChecker := NewCanonicalComplianceChecker(true)
	canonChecker.SetAssetCompliance(AssetComplianceRecord{
		AssetID:         "asset-consented",
		WorkspaceID:     testWorkspaceA,
		QualityState:    "pass",
		PackagingScore:  92,
		RightsVerified:  true,
		ConsentRequired: true,
		ConsentRecordID: "consent-valid-1",
		CharacterID:     "char-talent-1",
		SubjectUserID:   testUserA,
	})
	canonChecker.SetConsentRecord(PublishConsentRecord{
		ConsentID:   "consent-valid-1",
		WorkspaceID: testWorkspaceA,
		CharacterID: "char-talent-1",
		UserID:      testUserA,
		ConsentType: "likeness_release",
		Granted:     true,
	})

	svcCanon := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: canonChecker,
	})
	svcCanon.RegisterConnector(mockConn)

	itemResp, err := svcCanon.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-s6-f2",
		AssetId:         "asset-consented",
		Title:           "Consented Video",
	}))
	if err != nil {
		t.Fatalf("CreateItem with valid consent failed: %v", err)
	}
	consentedItemID := itemResp.Msg.Item.PublishItemId

	// Schedule succeeds while consent is valid
	schedTime := now.Add(10 * time.Minute)
	schedResp, err := svcCanon.Schedule(ctxOwner, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: consentedItemID,
		ScheduledAt:   timestamppb.New(schedTime),
	}))
	if err != nil {
		t.Fatalf("Schedule with valid consent failed: %v", err)
	}

	// Advance clock past scheduled time, but REVOKE consent before Execute!
	now = schedResp.Msg.ScheduledAt.AsTime().Add(1 * time.Minute)
	canonChecker.RevokeConsent(testWorkspaceA, "consent-valid-1")

	if _, err := svcCanon.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: consentedItemID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F2 VIOLATION: Execute allowed publishing after consent was revoked: %v", err)
	}
	if mockConn.publishCalls != 0 {
		t.Fatalf("expected 0 connector calls when consent is revoked before Execute, got %d", mockConn.publishCalls)
	}

	// Restore consent with wrong ConsentType ("marketing") -> must be rejected
	canonChecker.SetConsentRecord(PublishConsentRecord{
		ConsentID:   "consent-valid-1",
		WorkspaceID: testWorkspaceA,
		CharacterID: "char-talent-1",
		UserID:      testUserA,
		ConsentType: "marketing",
		Granted:     true,
	})
	if _, err := svcCanon.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: consentedItemID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F2 VIOLATION: Execute allowed publishing with marketing consent instead of likeness/voice_clone: %v", err)
	}

	// Restore valid ConsentType ("likeness_release") -> Execute succeeds
	canonChecker.SetConsentRecord(PublishConsentRecord{
		ConsentID:   "consent-valid-1",
		WorkspaceID: testWorkspaceA,
		CharacterID: "char-talent-1",
		UserID:      testUserA,
		ConsentType: "likeness_release",
		Granted:     true,
	})
	if _, err := svcCanon.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: consentedItemID,
	})); err != nil {
		t.Fatalf("expected Execute to succeed once likeness consent is valid, got: %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected 1 connector call after valid consent, got %d", mockConn.publishCalls)
	}
}

type ambiguousTransportConnector struct {
	platform             string
	externalPostsCreated int
	callErr              error
	callRes              *ConnectorPublishResult
	reconcileOutcome     string
}

func (c *ambiguousTransportConnector) Platform() string { return c.platform }

func (c *ambiguousTransportConnector) PublishPost(_ context.Context, _ string, _ *PublishItem, _ string) (*ConnectorPublishResult, error) {
	// Simulate provider accepting the post on the remote server before the connection drops with EOF / reset!
	c.externalPostsCreated++
	return c.callRes, c.callErr
}

func (c *ambiguousTransportConnector) CheckPostStatus(_ context.Context, _ string, providerRequestID string) (*ConnectorStatusResult, error) {
	if c.reconcileOutcome == "confirmed_published" {
		return &ConnectorStatusResult{
			ProviderRequestID: providerRequestID,
			ExternalPostID:    "ext_eof_post_1",
			ExternalPostURL:   "https://tiktok.com/@brand/video/ext_eof_post_1",
			Found:             true,
			Status:            "confirmed_published",
		}, nil
	}
	return &ConnectorStatusResult{
		ProviderRequestID: providerRequestID,
		Status:            "still_unknown",
	}, nil
}

func TestS6_F5_AmbiguousTransportEOFAndResetLockRetryUntilReconciled(t *testing.T) {
	now := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)
	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	transportErrors := []struct {
		name string
		err  error
	}{
		{name: "io.EOF", err: io.EOF},
		{name: "io.ErrUnexpectedEOF", err: io.ErrUnexpectedEOF},
		{name: "connection_reset", err: errors.New("read tcp 10.0.0.1:443: connection reset by peer")},
		{name: "context_canceled", err: context.Canceled},
	}

	for _, tc := range transportErrors {
		t.Run(tc.name, func(t *testing.T) {
			svc := NewService(ServiceConfig{
				Clock:             func() time.Time { return now },
				ComplianceChecker: newTestFixtureComplianceChecker(),
			})
			conn := &ambiguousTransportConnector{
				platform:         "tiktok",
				callErr:          tc.err,
				reconcileOutcome: "still_unknown",
			}
			svc.RegisterConnector(conn)

			createResp, err := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
				TargetPlatform:  "tiktok",
				TargetAccountId: "acc-s6-f5",
				Title:           "EOF Post " + tc.name,
			}))
			if err != nil {
				t.Fatalf("CreateItem failed: %v", err)
			}
			itemID := createResp.Msg.Item.PublishItemId

			// 1. First Execute encounters EOF/reset after provider accepted post -> MUST classify as unknown (CodeDeadlineExceeded)
			_, err = svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
				PublishItemId: itemID,
			}))
			if connect.CodeOf(err) != connect.CodeDeadlineExceeded {
				t.Fatalf("F5 VIOLATION (%s): expected CodeDeadlineExceeded (ErrUnknownSubmit), got %v", tc.name, err)
			}
			if conn.externalPostsCreated != 1 {
				t.Fatalf("expected 1 external post created on first attempt, got %d", conn.externalPostsCreated)
			}

			// Verify effect status is "unknown", NOT "failed"
			job, _ := svc.Store().GetJobByItemID(ctxOwner, testWorkspaceA, itemID)
			effects, _ := svc.Store().ListEffectsByAggregate(ctxOwner, testWorkspaceA, "publish_job", job.PublishJobID)
			if len(effects) != 1 || effects[0].Status != "unknown" {
				t.Fatalf("F5 VIOLATION (%s): expected 1 effect with status='unknown', got %+v", tc.name, effects)
			}

			// 2. Subsequent Execute or Retry MUST be blocked and MUST NOT create a second external post!
			conn.callErr = nil
			conn.callRes = &ConnectorPublishResult{
				ProviderRequestID: "prov_req_2",
				ExternalPostID:    "ext_post_duplicate",
				ExternalPostURL:   "https://tiktok.com/@brand/video/ext_post_duplicate",
				ResultStatus:      ResultSuccess,
			}

			if _, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
				PublishItemId: itemID,
			})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
				t.Fatalf("F5 VIOLATION (%s): second Execute after EOF was not blocked: %v", tc.name, err)
			}
			if _, err := svc.Retry(ctxOwner, connect.NewRequest(&publishv1.RetryRequest{
				PublishItemId: itemID,
			})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
				t.Fatalf("F5 VIOLATION (%s): Retry after EOF was not blocked: %v", tc.name, err)
			}
			if conn.externalPostsCreated != 1 {
				t.Fatalf("F5 VIOLATION (%s): duplicate external post was created (%d total)!", tc.name, conn.externalPostsCreated)
			}
		})
	}
}

func TestS6_F6_IdempotencyKeyBoundToExactItemAccountAndPayload(t *testing.T) {
	now := time.Date(2026, 11, 7, 13, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	mockConn := &MockConnector{
		platform:         "tiktok",
		publishOutcome:   "success",
		publishedPostID:  "post_item_a_only",
		publishedPostURL: "https://tiktok.com/@brand/video/post_item_a_only",
	}
	svc.RegisterConnector(mockConn)

	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	itemAResp, _ := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-s6-f6-1",
		AssetId:         "asset-a",
		Title:           "Original Video A",
		Description:     "Caption A",
	}))
	itemAID := itemAResp.Msg.Item.PublishItemId

	itemBResp, _ := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-s6-f6-1",
		AssetId:         "asset-b",
		Title:           "Different Video B",
		Description:     "Caption B",
	}))
	itemBID := itemBResp.Msg.Item.PublishItemId

	itemCResp, _ := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-s6-f6-2", // Different target account!
		AssetId:         "asset-a",
		Title:           "Original Video A",
		Description:     "Caption A",
	}))
	itemCID := itemCResp.Msg.Item.PublishItemId

	sharedKey := "idem-key-s6-f6"

	// 1. Execute Item A with sharedKey -> succeeds
	respA, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemAID,
		Context:       &commonv1.CommandContext{IdempotencyKey: sharedKey},
	}))
	if err != nil {
		t.Fatalf("Execute Item A failed: %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected 1 publish call, got %d", mockConn.publishCalls)
	}

	// 2. Reusing sharedKey on Item B MUST fail with CodeAlreadyExists (ErrIdempotencyKeyConflict) and NEVER mark Item B published!
	_, errB := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemBID,
		Context:       &commonv1.CommandContext{IdempotencyKey: sharedKey},
	}))
	if connect.CodeOf(errB) != connect.CodeAlreadyExists {
		t.Fatalf("F6 VIOLATION: reusing idempotency key on Item B did not fail with CodeAlreadyExists, got %v", errB)
	}
	itemBStored, _ := svc.Store().GetItem(ctxOwner, testWorkspaceA, itemBID)
	if itemBStored.LifecycleState == StatePublished {
		t.Fatalf("F6 VIOLATION: Item B was falsely marked published using Item A's idempotency key!")
	}
	if postB, _ := svc.Store().GetPostByItemID(ctxOwner, testWorkspaceA, itemBID); postB != nil {
		t.Fatalf("F6 VIOLATION: ChannelPost fabricated for Item B: %+v", postB)
	}

	// 3. Reusing sharedKey on Item C (same content, different TargetAccountID) MUST also fail with CodeAlreadyExists
	_, errC := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemCID,
		Context:       &commonv1.CommandContext{IdempotencyKey: sharedKey},
	}))
	if connect.CodeOf(errC) != connect.CodeAlreadyExists {
		t.Fatalf("F6 VIOLATION: reusing idempotency key on different account Item C did not fail with CodeAlreadyExists, got %v", errC)
	}

	// 4. Replaying sharedKey on the EXACT same Item A succeeds idempotently without calling connector
	respAReplay, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemAID,
		Context:       &commonv1.CommandContext{IdempotencyKey: sharedKey},
	}))
	if err != nil {
		t.Fatalf("expected idempotent replay on Item A to succeed, got %v", err)
	}
	if respAReplay.Msg.ChannelPost.ExternalPostId != respA.Msg.ChannelPost.ExternalPostId {
		t.Fatalf("expected identical ExternalPostId on Item A replay")
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected still 1 publish call, got %d", mockConn.publishCalls)
	}
}

func TestS6_F7_RescheduleScheduleAndScheduleRetryBlockedWhileUnknownEffectPending(t *testing.T) {
	now := time.Date(2026, 11, 7, 14, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	mockConn := &MockConnector{
		platform:         "tiktok",
		publishOutcome:   "unknown",
		reconcileOutcome: "still_unknown",
	}
	svc.RegisterConnector(mockConn)

	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	createResp, err := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-s6-f7",
		Title:           "S6 F7 Unknown Attempt Item",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// 1. First Execute hits unknown submit on Job 1
	_, err = svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if connect.CodeOf(err) != connect.CodeDeadlineExceeded {
		t.Fatalf("expected CodeDeadlineExceeded on initial unknown submit, got %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected 1 publish call, got %d", mockConn.publishCalls)
	}

	// 2. Schedule, Reschedule, ScheduleRetry, Retry, Cancel, Delete, UpdateDraft, UpdateMetadata MUST all fail closed!
	future := timestamppb.New(now.Add(20 * time.Minute))
	if _, err := svc.Schedule(ctxOwner, connect.NewRequest(&publishv1.ScheduleRequest{
		PublishItemId: itemID,
		ScheduledAt:   future,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F7 VIOLATION: Schedule succeeded while unknown publish attempt was pending: %v", err)
	}
	if _, err := svc.Reschedule(ctxOwner, connect.NewRequest(&publishv1.RescheduleRequest{
		PublishItemId: itemID,
		NewScheduleAt: future,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F7 VIOLATION: Reschedule succeeded while unknown publish attempt was pending: %v", err)
	}
	if _, err := svc.ScheduleRetry(ctxOwner, connect.NewRequest(&publishv1.ScheduleRetryRequest{
		PublishItemId: itemID,
		RetryAt:       future,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F7 VIOLATION: ScheduleRetry succeeded while unknown publish attempt was pending: %v", err)
	}
	if _, err := svc.Cancel(ctxOwner, connect.NewRequest(&publishv1.CancelRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F7 VIOLATION: Cancel succeeded while unknown publish attempt was pending: %v", err)
	}
	if _, err := svc.Delete(ctxOwner, connect.NewRequest(&publishv1.DeleteRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F7 VIOLATION: Delete succeeded while unknown publish attempt was pending: %v", err)
	}
	if _, err := svc.UpdateMetadata(ctxOwner, connect.NewRequest(&publishv1.UpdateMetadataRequest{
		PublishItemId: itemID,
		Title:         "Mutated Title During Unknown",
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F7 VIOLATION: UpdateMetadata succeeded while unknown publish attempt was pending: %v", err)
	}

	// 3. Even if a second PublishJob is persisted in the store for the same item, Execute must inspect effects across ALL jobs for the item!
	secondJob := &PublishJob{
		PublishJobID:     "job-s6-f7-second",
		WorkspaceID:      testWorkspaceA,
		PublishItemID:    itemID,
		DispatchStrategy: "direct",
		LifecycleState:   JobStateCreated,
		CreatedAt:        now.Add(1 * time.Minute),
		UpdatedAt:        now.Add(1 * time.Minute),
	}
	_ = svc.Store().SaveJob(ctxOwner, secondJob)

	mockConn.publishOutcome = "success"
	_, err = svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
		PublishJobId:  secondJob.PublishJobID,
	}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F7 VIOLATION: Execute on second job bypassed prior job's unknown effect: %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("F7 VIOLATION: connector was called %d times across jobs!", mockConn.publishCalls)
	}
}

func TestS6_F8_ReconcilePublishRejectsMismatchedOrUnboundProviderRequestID(t *testing.T) {
	now := time.Date(2026, 11, 7, 15, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	mockConn := &MockConnector{
		platform:         "youtube",
		publishOutcome:   "unknown", // sets ProviderRequestID = "prov_req_12345"
		reconcileOutcome: "confirmed_not_published",
	}
	svc.RegisterConnector(mockConn)

	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)

	// Item A: has unknown effect with bound ProviderRequestID = "prov_req_12345"
	itemAResp, _ := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "youtube",
		TargetAccountId: "acc-s6-f8",
		Title:           "S6 F8 Item A",
	}))
	itemAID := itemAResp.Msg.Item.PublishItemId
	_, _ = svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{PublishItemId: itemAID}))

	// 1. Supplying a different ProviderRequestId ("bogus_nonexistent_req") MUST fail with CodeInvalidArgument (ErrProviderRequestMismatch)
	_, err := svc.ReconcilePublish(ctxOwner, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId:     itemAID,
		ProviderRequestId: "bogus_nonexistent_req",
	}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F8 VIOLATION: ReconcilePublish accepted mismatched client ProviderRequestId: %v", err)
	}
	if mockConn.reconcileCalls != 0 {
		t.Fatalf("F8 VIOLATION: CheckPostStatus was called with mismatched ProviderRequestId (%d calls)", mockConn.reconcileCalls)
	}

	// Verify Item A's unknown effect was NOT cleared and Retry is still blocked
	if _, err := svc.Retry(ctxOwner, connect.NewRequest(&publishv1.RetryRequest{
		PublishItemId: itemAID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F8 VIOLATION: Retry was unlocked after rejected ReconcilePublish: %v", err)
	}

	// 2. Item B: hits unknown outcome WITHOUT a bound ProviderRequestID ("unknown_no_req_id")
	mockConn.publishOutcome = "unknown_no_req_id"
	itemBResp, _ := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "youtube",
		TargetAccountId: "acc-s6-f8",
		Title:           "S6 F8 Item B",
	}))
	itemBID := itemBResp.Msg.Item.PublishItemId
	_, _ = svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{PublishItemId: itemBID}))

	// Attempting to reconcile Item B using Item A's ProviderRequestID ("prov_req_12345") MUST fail with CodeInvalidArgument!
	_, err = svc.ReconcilePublish(ctxOwner, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId:     itemBID,
		ProviderRequestId: "prov_req_12345",
	}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F8 VIOLATION: ReconcilePublish allowed binding Item A's ProviderRequestId onto Item B: %v", err)
	}

	// 3. Reconciling Item A with empty ProviderRequestId uses Item A's durable bound "prov_req_12345" and succeeds
	mockConn.reconcileOutcome = "confirmed_published"
	recRespA, err := svc.ReconcilePublish(ctxOwner, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId:     itemAID,
		ProviderRequestId: "", // Empty -> uses durable bound ID
	}))
	if err != nil || !recRespA.Msg.Reconciled || recRespA.Msg.ReconciliationOutcome != "confirmed_published" {
		t.Fatalf("expected ReconcilePublish with empty ProviderRequestId to use durable bound ID and succeed, got %+v, err=%v", recRespA, err)
	}
}

type faultInjectingPublishStore struct {
	Store
	failSavePost    bool
	failAppendEvent bool
}

func (s *faultInjectingPublishStore) SavePost(ctx context.Context, post *ChannelPost) error {
	if s.failSavePost {
		return errors.New("simulated SavePost database failure")
	}
	return s.Store.SavePost(ctx, post)
}

func (s *faultInjectingPublishStore) AppendEvent(ctx context.Context, evt DomainEvent) error {
	if s.failAppendEvent && (evt.EventType == EventPublishSucceeded || evt.EventType == EventChannelPostSynced) {
		return errors.New("simulated AppendEvent outbox failure")
	}
	return s.Store.AppendEvent(ctx, evt)
}

func TestS6_F12_SavePostAndAppendEventFailuresRecoverIdempotentlyOnReplay(t *testing.T) {
	now := time.Date(2026, 11, 7, 16, 0, 0, 0, time.UTC)
	baseStore := NewMemoryStore()
	faultStore := &faultInjectingPublishStore{
		Store:        baseStore,
		failSavePost: true,
	}
	svc := NewService(ServiceConfig{
		Store:             faultStore,
		Clock:             func() time.Time { return now },
		ComplianceChecker: newTestFixtureComplianceChecker(),
	})
	mockConn := &MockConnector{
		platform:         "tiktok",
		publishOutcome:   "success",
		publishedPostID:  "ext_post_f12_1",
		publishedPostURL: "https://tiktok.com/@brand/video/ext_post_f12_1",
	}
	svc.RegisterConnector(mockConn)

	ctxOwner := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleOwner)
	createResp, err := svc.CreateItem(ctxOwner, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-s6-f12",
		Title:           "S6 F12 Durable Completion Video",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// 1. First Execute: connector succeeds, AppendLog succeeds, but SavePost fails -> returns CodeInternal and item is NOT marked published!
	_, err = svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if connect.CodeOf(err) != connect.CodeInternal {
		t.Fatalf("expected CodeInternal when SavePost fails, got %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected 1 connector call, got %d", mockConn.publishCalls)
	}
	itemAfterSavePostFail, _ := baseStore.GetItem(ctxOwner, testWorkspaceA, itemID)
	if itemAfterSavePostFail.LifecycleState == StatePublished {
		t.Fatalf("F12 VIOLATION: item was marked StatePublished before SavePost succeeded!")
	}

	// 2. Second Execute: SavePost now succeeds, but AppendEvent fails -> returns CodeInternal and item is still NOT marked published
	faultStore.failSavePost = false
	faultStore.failAppendEvent = true
	_, err = svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if connect.CodeOf(err) != connect.CodeInternal {
		t.Fatalf("expected CodeInternal when AppendEvent fails, got %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("F12 VIOLATION: connector called again (%d times) during SavePost/AppendEvent recovery!", mockConn.publishCalls)
	}

	// 3. Third Execute: AppendEvent now succeeds -> repairs ChannelPost, domain events, job, and item state=published with 0 extra connector calls!
	faultStore.failAppendEvent = false
	execResp, err := svc.Execute(ctxOwner, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))
	if err != nil {
		t.Fatalf("expected third Execute to complete recovery cleanly, got %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("expected 1 total connector call after full recovery, got %d", mockConn.publishCalls)
	}
	if execResp.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected item state PUBLISHED after recovery, got %v", execResp.Msg.Item.LifecycleState)
	}
	if execResp.Msg.ChannelPost == nil || execResp.Msg.ChannelPost.ExternalPostId != "ext_post_f12_1" {
		t.Fatalf("expected recovered ChannelPost with ExternalPostId='ext_post_f12_1', got %+v", execResp.Msg.ChannelPost)
	}
	logs, _ := baseStore.ListLogsByItemID(ctxOwner, testWorkspaceA, itemID)
	if len(logs) != 1 {
		t.Fatalf("expected exactly 1 immutable publish log (no duplicate logs during recovery), got %d", len(logs))
	}
}

type errorComplianceRecordSource struct {
	assetRec   *AssetComplianceRecord
	consentRec *PublishConsentRecord
	assetErr   error
	consentErr error
}

func (s *errorComplianceRecordSource) GetAssetComplianceRecord(_ context.Context, _, _ string) (*AssetComplianceRecord, error) {
	if s.assetErr != nil {
		return nil, s.assetErr
	}
	return s.assetRec, nil
}

func (s *errorComplianceRecordSource) GetPublishConsentRecord(_ context.Context, _, _ string) (*PublishConsentRecord, error) {
	if s.consentErr != nil {
		return nil, s.consentErr
	}
	return s.consentRec, nil
}

func TestT6_R1_DefaultComplianceCheckerRejectsUnregisteredAssetAndMissingQARecords(t *testing.T) {
	now := time.Date(2026, 11, 8, 9, 0, 0, 0, time.UTC)
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: NewDefaultComplianceChecker(),
	})
	mockConn := &MockConnector{
		platform:       "tiktok",
		publishOutcome: "success",
	}
	svc.RegisterConnector(mockConn)

	ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)

	// 1. Unregistered asset ID in NewDefaultComplianceChecker() must fail closed
	createResp, err := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-t6-r1",
		AssetId:         "asset-unregistered-t6-r1",
		Title:           "Unregistered Asset Must Fail Closed",
	}))
	if err != nil {
		t.Fatalf("CreateItem draft failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	if _, err := svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("R1 VIOLATION: expected CodeFailedPrecondition when asset has no QA/rights record in default compliance checker, got %v", err)
	}
	if mockConn.publishCalls != 0 {
		t.Fatalf("R1 VIOLATION: expected 0 connector calls for unregistered asset, got %d", mockConn.publishCalls)
	}

	// 2. Empty asset ID in NewDefaultComplianceChecker() must also fail closed
	emptyAssetResp, err := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-t6-r1",
		AssetId:         "",
		Title:           "Empty Asset ID Must Fail Closed",
	}))
	if err != nil {
		t.Fatalf("CreateItem empty asset draft failed: %v", err)
	}
	if _, err := svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: emptyAssetResp.Msg.Item.PublishItemId,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("R1 VIOLATION: expected CodeFailedPrecondition when AssetId is empty, got %v", err)
	}

	// 3. NewCanonicalComplianceChecker(false) must still fail closed on missing QA/rights record
	nonPermissiveChecker := NewCanonicalComplianceChecker(false)
	scanRes, hasHard, details, cErr := nonPermissiveChecker.CheckPublishCompliance(ctxManager, testWorkspaceA, "asset-missing", "tiktok")
	if cErr == nil || !hasHard || scanRes == "pass" || details["rights_verified"] == true {
		t.Fatalf("R1 VIOLATION: NewCanonicalComplianceChecker(false) synthesized pass/rights_verified: scan=%q hard=%v details=%v err=%v", scanRes, hasHard, details, cErr)
	}

	// 4. ComplianceRecordSource error and cross-tenant record isolation must fail closed
	srcErrChecker := NewCanonicalComplianceCheckerWithSource(&errorComplianceRecordSource{
		assetErr: errors.New("db connection timeout"),
	})
	if _, hasHard, _, err := srcErrChecker.CheckPublishCompliance(ctxManager, testWorkspaceA, "asset-db-err", "tiktok"); err == nil || !hasHard {
		t.Fatalf("expected source error to fail closed, got hard=%v err=%v", hasHard, err)
	}

	crossTenantChecker := NewCanonicalComplianceCheckerWithSource(&errorComplianceRecordSource{
		assetRec: &AssetComplianceRecord{
			AssetID:        "asset-cross-ws",
			WorkspaceID:    testWorkspaceB,
			QualityState:   "pass",
			RightsVerified: true,
		},
	})
	if _, hasHard, details, err := crossTenantChecker.CheckPublishCompliance(ctxManager, testWorkspaceA, "asset-cross-ws", "tiktok"); err == nil || !hasHard || details["reason"] != "cross_tenant_asset" {
		t.Fatalf("expected cross-tenant asset compliance record to fail closed, got hard=%v details=%v err=%v", hasHard, details, err)
	}
}

func TestT6_R2_ReconcileRejectsUnboundExternalRequestIDOnUnknownEffect(t *testing.T) {
	now := time.Date(2026, 11, 8, 9, 15, 0, 0, time.UTC)
	checker := NewCanonicalComplianceChecker(true)
	checker.SetAssetCompliance(AssetComplianceRecord{
		AssetID:        "asset-t6-r2",
		WorkspaceID:    testWorkspaceA,
		QualityState:   "pass",
		PackagingScore: 90,
		RightsVerified: true,
	})
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: checker,
	})
	mockConn := &MockConnector{
		platform:         "youtube",
		publishOutcome:   "unknown_no_req_id",
		reconcileOutcome: "confirmed_not_published",
	}
	svc.RegisterConnector(mockConn)

	ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)
	createResp, err := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "youtube",
		TargetAccountId: "acc-t6-r2",
		AssetId:         "asset-t6-r2",
		Title:           "Unknown Submit Without ProviderRequestID",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// 1. Execute hits unknown outcome without saving a provider_request_id
	if _, err := svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodeDeadlineExceeded {
		t.Fatalf("expected CodeDeadlineExceeded on unknown submit, got %v", err)
	}

	// 2. Client supplies an external request ID B ("external_req_B_other_op") that is not in local registry
	// and has no provider proof binding it to item A's operation key / request hash.
	recResp, recErr := svc.ReconcilePublish(ctxManager, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId:     itemID,
		ProviderRequestId: "external_req_B_other_op",
	}))
	if connect.CodeOf(recErr) != connect.CodeInvalidArgument || (recResp != nil && recResp.Msg.Reconciled) {
		t.Fatalf("R2 VIOLATION: ReconcilePublish did not reject unbound external request ID with CodeInvalidArgument: resp=%+v err=%v", recResp, recErr)
	}

	// 2b. Even if connector returns status metadata, if the operation_key or request_hash belongs to a different item, reject!
	mockConn.mu.Lock()
	savedHash := mockConn.lastRequestHash
	mockConn.boundRecoveryReqID = "external_req_wrong_hash"
	mockConn.lastRequestHash = "different_item_hash_999999"
	mockConn.mu.Unlock()
	if _, err := svc.ReconcilePublish(ctxManager, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId:     itemID,
		ProviderRequestId: "external_req_wrong_hash",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("R2 VIOLATION: ReconcilePublish accepted external request ID with mismatched request_hash: %v", err)
	}
	mockConn.mu.Lock()
	mockConn.lastRequestHash = savedHash
	mockConn.boundRecoveryReqID = ""
	mockConn.mu.Unlock()

	// 2c. Cross-tenant caller cannot reconcile item A
	ctxOtherTenant := WithCaller(context.Background(), testWorkspaceB, testUserB, rbac.RoleManager)
	if _, err := svc.ReconcilePublish(ctxOtherTenant, connect.NewRequest(&publishv1.ReconcilePublishRequest{
		PublishItemId:     itemID,
		ProviderRequestId: "external_req_B_other_op",
	})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound for cross-tenant ReconcilePublish, got %v", err)
	}

	// 3. Retry and Execute on item A must STILL be blocked!
	mockConn.publishOutcome = "success"
	if _, err := svc.Retry(ctxManager, connect.NewRequest(&publishv1.RetryRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("R2 VIOLATION: Retry was unlocked by unbound external request ID: %v", err)
	}
	if _, err := svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("R2 VIOLATION: Execute was unlocked by unbound external request ID: %v", err)
	}
	if mockConn.publishCalls != 1 {
		t.Fatalf("R2 VIOLATION: expected 1 total connector publish call, got %d", mockConn.publishCalls)
	}
}

type customCapabilityEvaluator struct {
	res capability.EvaluationResult
}

func (e *customCapabilityEvaluator) EvaluateActionAccess(_, platform, actionKey string, _ []string) capability.EvaluationResult {
	out := e.res
	out.Platform = platform
	out.ActionKey = actionKey
	return out
}

func TestT6_R4_ExecuteRejectsReadOnlyNonExecutableAndUnknownCapabilities(t *testing.T) {
	now := time.Date(2026, 11, 8, 9, 30, 0, 0, time.UTC)
	cases := []struct {
		name string
		eval capability.EvaluationResult
	}{
		{
			name: "read_only",
			eval: capability.EvaluationResult{
				State:      capability.StateReadOnly,
				Executable: false,
				PolicyNote: capability.PolicyNoteSpec{Summary: "Read-only probe cannot authorize writes"},
			},
		},
		{
			name: "native_but_not_executable",
			eval: capability.EvaluationResult{
				State:      capability.StateNative,
				Executable: false,
				PolicyNote: capability.PolicyNoteSpec{Summary: "Verification stale; not executable"},
			},
		},
		{
			name: "unknown_state",
			eval: capability.EvaluationResult{
				State:      capability.State("unknown_unverified"),
				Executable: true,
				PolicyNote: capability.PolicyNoteSpec{Summary: "Unknown capability state"},
			},
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			checker := NewCanonicalComplianceChecker(true)
			checker.SetAssetCompliance(AssetComplianceRecord{
				AssetID:        "asset-t6-r4-" + tc.name,
				WorkspaceID:    testWorkspaceA,
				QualityState:   "pass",
				PackagingScore: 90,
				RightsVerified: true,
			})
			svc := NewService(ServiceConfig{
				Clock:             func() time.Time { return now },
				ComplianceChecker: checker,
			})
			svc.SetCapabilityEvaluator(&customCapabilityEvaluator{res: tc.eval})
			mockConn := &MockConnector{
				platform:       "tiktok",
				publishOutcome: "success",
			}
			svc.RegisterConnector(mockConn)

			ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)
			createResp, err := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
				TargetPlatform:  "tiktok",
				TargetAccountId: "acc-t6-r4",
				AssetId:         "asset-t6-r4-" + tc.name,
				Title:           "Capability Gate Test " + tc.name,
			}))
			if err != nil {
				t.Fatalf("CreateItem failed: %v", err)
			}
			itemID := createResp.Msg.Item.PublishItemId

			if _, err := svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
				PublishItemId: itemID,
			})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
				t.Fatalf("R4 VIOLATION (%s): expected CodeFailedPrecondition, got %v", tc.name, err)
			}
			if mockConn.publishCalls != 0 {
				t.Fatalf("R4 VIOLATION (%s): expected 0 outbound connector calls, got %d", tc.name, mockConn.publishCalls)
			}
			storedItem, _ := svc.Store().GetItem(ctxManager, testWorkspaceA, itemID)
			if storedItem.LifecycleState != StateRequiresManualFallback {
				t.Fatalf("expected item state %q, got %q", StateRequiresManualFallback, storedItem.LifecycleState)
			}
		})
	}
}

type barrierPublishStore struct {
	Store
	mu          sync.Mutex
	barrier     chan struct{}
	arrived     int
	targetCount int
}

func (b *barrierPublishStore) ListEffectsByAggregate(ctx context.Context, workspaceID, aggregateType, aggregateID string) ([]*ExternalEffect, error) {
	effs, err := b.Store.ListEffectsByAggregate(ctx, workspaceID, aggregateType, aggregateID)
	if aggregateType == "publish_item" && b.targetCount > 0 {
		b.mu.Lock()
		b.arrived++
		if b.arrived == b.targetCount {
			close(b.barrier)
		}
		ch := b.barrier
		b.mu.Unlock()
		<-ch
	}
	return effs, err
}

func TestT6_R6_ConcurrentExecuteBarrierAllowsOnlySingleSubmission(t *testing.T) {
	now := time.Date(2026, 11, 8, 9, 45, 0, 0, time.UTC)
	for _, mode := range []string{"same_idempotency_key", "distinct_idempotency_keys", "no_idempotency_key"} {
		t.Run(mode, func(t *testing.T) {
			checker := NewCanonicalComplianceChecker(true)
			checker.SetAssetCompliance(AssetComplianceRecord{
				AssetID:        "asset-t6-r6-" + mode,
				WorkspaceID:    testWorkspaceA,
				QualityState:   "pass",
				PackagingScore: 95,
				RightsVerified: true,
			})
			bStore := &barrierPublishStore{
				Store:       NewMemoryStore(),
				barrier:     make(chan struct{}),
				targetCount: 2,
			}
			svc := NewService(ServiceConfig{
				Store:             bStore,
				Clock:             func() time.Time { return now },
				ComplianceChecker: checker,
			})
			mockConn := &MockConnector{
				platform:         "tiktok",
				publishOutcome:   "success",
				publishedPostID:  "post_r6_" + mode,
				publishedPostURL: "https://tiktok.com/@brand/video/post_r6_" + mode,
			}
			svc.RegisterConnector(mockConn)

			ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)
			createResp, err := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
				TargetPlatform:  "tiktok",
				TargetAccountId: "acc-t6-r6",
				AssetId:         "asset-t6-r6-" + mode,
				Title:           "Concurrent Claim Item " + mode,
			}))
			if err != nil {
				t.Fatalf("CreateItem failed: %v", err)
			}
			itemID := createResp.Msg.Item.PublishItemId

			var wg sync.WaitGroup
			wg.Add(2)
			errs := make([]error, 2)
			for i := 0; i < 2; i++ {
				idx := i
				go func() {
					defer wg.Done()
					var cmdCtx *commonv1.CommandContext
					switch mode {
					case "same_idempotency_key":
						cmdCtx = &commonv1.CommandContext{IdempotencyKey: "same-race-key-r6"}
					case "distinct_idempotency_keys":
						if idx == 0 {
							cmdCtx = &commonv1.CommandContext{IdempotencyKey: "race-key-r6-A"}
						} else {
							cmdCtx = &commonv1.CommandContext{IdempotencyKey: "race-key-r6-B"}
						}
					}
					_, errs[idx] = svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
						PublishItemId: itemID,
						Context:       cmdCtx,
					}))
				}()
			}
			wg.Wait()

			if mockConn.publishCalls != 1 {
				t.Fatalf("R6 VIOLATION (%s): expected1 outbound PublishPost call across concurrent Execute calls, got %d (errs=%v)", mode, mockConn.publishCalls, errs)
			}
		})
	}
}

func TestT6_R7_PublishVariantsWithBatchIdempotencyKeyExecutesAllItemsAndReplaysCleanly(t *testing.T) {
	now := time.Date(2026, 11, 8, 10, 0, 0, 0, time.UTC)
	checker := NewCanonicalComplianceChecker(true)
	checker.SetAssetCompliance(AssetComplianceRecord{
		AssetID:        "asset-t6-r7-1",
		WorkspaceID:    testWorkspaceA,
		QualityState:   "pass",
		PackagingScore: 90,
		RightsVerified: true,
	})
	checker.SetAssetCompliance(AssetComplianceRecord{
		AssetID:        "asset-t6-r7-2",
		WorkspaceID:    testWorkspaceA,
		QualityState:   "pass",
		PackagingScore: 91,
		RightsVerified: true,
	})
	svc := NewService(ServiceConfig{
		Clock:             func() time.Time { return now },
		ComplianceChecker: checker,
	})
	mockConn := &MockConnector{
		platform:         "tiktok",
		publishOutcome:   "success",
		publishedPostID:  "post_r7_batch",
		publishedPostURL: "https://tiktok.com/@brand/video/post_r7_batch",
	}
	svc.RegisterConnector(mockConn)

	ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)
	item1Resp, _ := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-t6-r7",
		AssetId:         "asset-t6-r7-1",
		Title:           "Variant 1",
	}))
	item2Resp, _ := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-t6-r7",
		AssetId:         "asset-t6-r7-2",
		Title:           "Variant 2",
	}))
	ids := []string{item1Resp.Msg.Item.PublishItemId, item2Resp.Msg.Item.PublishItemId}

	batchResp, err := svc.PublishVariants(ctxManager, connect.NewRequest(&publishv1.PublishVariantsRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "batch-idem-key-r7",
		},
		PublishItemIds: ids,
	}))
	if err != nil {
		t.Fatalf("R7 VIOLATION: PublishVariants with batch idempotency key failed: %v", err)
	}
	if len(batchResp.Msg.Items) != 2 {
		t.Fatalf("expected 2 published items in batch response, got %d", len(batchResp.Msg.Items))
	}
	if mockConn.publishCalls != 2 {
		t.Fatalf("expected 2 connector publish calls for 2 batch items, got %d", mockConn.publishCalls)
	}

	// Replay with the same batch key must succeed without calling connector again
	replayResp, err := svc.PublishVariants(ctxManager, connect.NewRequest(&publishv1.PublishVariantsRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "batch-idem-key-r7",
		},
		PublishItemIds: ids,
	}))
	if err != nil {
		t.Fatalf("PublishVariants replay failed: %v", err)
	}
	if len(replayResp.Msg.Items) != 2 {
		t.Fatalf("expected 2 items on replay, got %d", len(replayResp.Msg.Items))
	}
	if mockConn.publishCalls != 2 {
		t.Fatalf("R7 VIOLATION: expected 0 additional connector calls on batch replay (still 2), got %d", mockConn.publishCalls)
	}

	// Reusing the same batch idempotency key with a different item set must fail with CodeAlreadyExists
	if _, err := svc.PublishVariants(ctxManager, connect.NewRequest(&publishv1.PublishVariantsRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "batch-idem-key-r7",
		},
		PublishItemIds: []string{item1Resp.Msg.Item.PublishItemId},
	})); connect.CodeOf(err) != connect.CodeAlreadyExists {
		t.Fatalf("expected CodeAlreadyExists when reusing batch idempotency key with different item list, got %v", err)
	}
}

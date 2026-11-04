package publish

import (
	"context"
	"errors"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	publishv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
)

// MockConnector implements PlatformConnector for tests.
type MockConnector struct {
	platform         string
	publishOutcome   string // success, failed, unknown, auth_revoked
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

	ctx := context.Background()

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

	// Verify scheduled time is at or after requested time (never before!)
	effectiveScheduled := schedResp.Msg.ScheduledAt.AsTime()
	if effectiveScheduled.Before(scheduledTarget) {
		t.Fatalf("CRITICAL INVARIANT VIOLATION: effective schedule time %v is before requested time %v", effectiveScheduled, scheduledTarget)
	}
	if schedResp.Msg.JitterDelaySeconds < 0 {
		t.Fatalf("CRITICAL INVARIANT VIOLATION: jitter delay is negative: %d", schedResp.Msg.JitterDelaySeconds)
	}

	// 3. Attempt to execute while now < schedule_at (e.g. at 10:15:00 UTC)
	simulatedTime = simulatedTime.Add(15 * time.Minute) // 10:15:00
	_, execErr := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))

	// MUST BE REJECTED with ErrPrematurePublish!
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
			HighLoadThresholdCPM: 5, // low threshold for testing
			MaxJitterDelay:       30 * time.Second,
			MaxWorkspaceQuotaPct: 0.20,
		},
	})

	// Simulate 10 recent dispatches in the last minute (exceeding threshold of 5)
	for i := 0; i < 10; i++ {
		svc.recentDispatches = append(svc.recentDispatches, now.Add(-time.Duration(i)*time.Second))
	}

	// Calculate jitter
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

	ctx := context.Background()

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

	// Must fail with ErrUnknownSubmit / DeadlineExceeded
	if execErr == nil {
		t.Fatalf("expected error on unknown submit, got nil")
	}

	// Verify item is NOT marked published (PRD §23.11 / RULE-M11-002)
	item := svc.items[itemID]
	if item.LifecycleState == StatePublished {
		t.Fatalf("ACCEPTANCE TARGET 2 VIOLATION: item marked published without verified proof!")
	}

	// Verify external effect was saved with status 'unknown'
	var unknownEffect *ExternalEffect
	for _, eff := range svc.effects {
		if eff.AggregateID != "" && eff.Status == "unknown" {
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

	// Verify immutable log has result_status = timeout
	if len(svc.logs) != 1 || svc.logs[0].ResultStatus != ResultTimeout {
		t.Fatalf("expected 1 log with result_status=timeout, got %v", svc.logs)
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

	// Assert item is now safely published with proof
	if svc.items[itemID].LifecycleState != StatePublished {
		t.Fatalf("expected item lifecycle_state=published after successful reconciliation, got %s", svc.items[itemID].LifecycleState)
	}

	// Assert channel post was created and linked
	if len(svc.posts) != 1 {
		t.Fatalf("expected 1 channel post created after reconciliation, got %d", len(svc.posts))
	}

	// Assert NO duplicate publish call was made to platform! (reconcile was a status check only)
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

	ctx := context.Background()

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

	// Capability pre-check must report Unsupported / RequiresManualFallback
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
	if svc.items[itemID].LifecycleState != StateRequiresManualFallback {
		t.Fatalf("expected item state requires_manual_fallback, got %s", svc.items[itemID].LifecycleState)
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

	// Verify state is published
	if proofResp.Msg.Item.LifecycleState != publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED {
		t.Fatalf("expected item lifecycle_state=published, got %v", proofResp.Msg.Item.LifecycleState)
	}

	// Verify immutable publish log exists with execution_path=manual_upload
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

	// Verify One Graph connection: item -> job -> log -> post
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

	ctx := context.Background()
	accountID := "acc-tiktok-revoked-01"

	// 1. Create 3 items for the same account:
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

	// Item 3: queued (draft ready)
	item3Resp, _ := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: accountID,
		Title:           "Item 3 (Queued)",
	}))
	item3ID := item3Resp.Msg.Item.PublishItemId
	svc.items[item3ID].LifecycleState = StateQueued

	// 2. Execute Item 1 -> Token revoked!
	_, execErr := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: item1ID,
	}))

	// Must fail with ErrAuthRevoked
	if execErr == nil {
		t.Fatalf("expected error on auth_revoked, got nil")
	}

	// Verify Item 1 is marked failed with blocked diagnostics
	if svc.items[item1ID].LifecycleState != StateFailed {
		t.Fatalf("expected item 1 state=failed, got %s", svc.items[item1ID].LifecycleState)
	}
	if svc.items[item1ID].DiagnosticsState != DiagnosticsBlocked {
		t.Fatalf("expected item 1 diagnostics=blocked, got %s", svc.items[item1ID].DiagnosticsState)
	}

	// ACCEPTANCE TARGET 4 CHECK:
	// Verify Item 2 (scheduled) and Item 3 (queued) are PAUSED (diagnostics_state = blocked)!
	// They must NOT be failed or deleted!
	if svc.items[item2ID].LifecycleState != StateScheduled {
		t.Fatalf("scheduled item 2 state was modified! Expected scheduled, got %s", svc.items[item2ID].LifecycleState)
	}
	if svc.items[item2ID].DiagnosticsState != DiagnosticsBlocked {
		t.Fatalf("ACCEPTANCE TARGET 4 FAILED: scheduled item 2 was NOT paused (diagnostics_state=%s)", svc.items[item2ID].DiagnosticsState)
	}

	if svc.items[item3ID].LifecycleState != StateQueued {
		t.Fatalf("queued item 3 state was modified! Expected queued, got %s", svc.items[item3ID].LifecycleState)
	}
	if svc.items[item3ID].DiagnosticsState != DiagnosticsBlocked {
		t.Fatalf("ACCEPTANCE TARGET 4 FAILED: queued item 3 was NOT paused (diagnostics_state=%s)", svc.items[item3ID].DiagnosticsState)
	}

	// Verify executing item 2 while paused fails closed
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
	if svc.items[item2ID].DiagnosticsState != DiagnosticsHealthy {
		t.Fatalf("expected item 2 diagnostics=healthy after reconnect, got %s", svc.items[item2ID].DiagnosticsState)
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

	ctx := context.Background()
	createResp, err := svc.CreateItem(ctx, connect.NewRequest(&publishv1.CreateItemRequest{
		TargetPlatform:  "tiktok",
		TargetAccountId: "acc-tiktok-02",
		Title:           "Degraded Test",
	}))
	if err != nil {
		t.Fatalf("CreateItem failed: %v", err)
	}
	itemID := createResp.Msg.Item.PublishItemId

	// Later, capability degrades to Manual
	mockCap.state = capability.StateManual

	// Execution re-checks capability and transitions to requires_manual_fallback
	_, execErr := svc.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		PublishItemId: itemID,
	}))

	if execErr == nil {
		t.Fatalf("expected error when capability degraded, got nil")
	}
	if svc.items[itemID].LifecycleState != StateRequiresManualFallback {
		t.Fatalf("expected state requires_manual_fallback, got %s", svc.items[itemID].LifecycleState)
	}
}

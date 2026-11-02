package capability

import (
	"context"
	"encoding/json"
	"errors"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

func loadCanonicalRBAC(t *testing.T) *rbac.Registry {
	t.Helper()
	repoRoot := filepath.Join("..", "..", "..", "..")
	reg, err := rbac.LoadCanonicalBindings(repoRoot)
	if err != nil {
		t.Fatalf("LoadCanonicalBindings(%q) failed: %v", repoRoot, err)
	}
	return reg
}

type stubKillSwitch struct {
	killed map[string]string
}

func (k *stubKillSwitch) IsCapabilityKilled(platform, actionKey string) (bool, string) {
	if k == nil || k.killed == nil {
		return false, ""
	}
	if reason, ok := k.killed["*"]; ok {
		return true, reason
	}
	if reason, ok := k.killed[strings.ToLower(platform)+"::*"]; ok {
		return true, reason
	}
	if reason, ok := k.killed[strings.ToLower(platform)+"::"+strings.ToLower(actionKey)]; ok {
		return true, reason
	}
	return false, ""
}

func TestUnverifiedStaleReadOnlyAndKilledRoutesCannotExecute(t *testing.T) {
	bindings := loadCanonicalRBAC(t)
	killSwitch := &stubKillSwitch{killed: make(map[string]string)}
	svc := NewService(bindings, killSwitch)
	fixedNow := time.Date(2026, 11, 2, 7, 30, 0, 0, time.UTC)
	svc.Now = func() time.Time { return fixedNow }

	const (
		wsA  = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
		usrA = "11111111-1111-4111-8111-111111111111"
		accA = "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
	)
	ctx := WithActorContext(context.Background(), ActorContext{
		UserID:           usrA,
		WorkspaceID:      wsA,
		WorkspaceRole:    rbac.RoleAdmin,
		WorkspaceActive:  true,
		MembershipActive: true,
	})

	// 1. Default fail-closed: before any account or verification is registered, TikTok publish_post is 'manual' and CANNOT execute.
	eval, err := svc.RequireExecutableCapability(ctx, wsA, accA, "tiktok", "publish_post", "VN", true)
	if !errors.Is(err, ErrUnverifiedRouteCannotExecute) {
		t.Fatalf("expected ErrUnverifiedRouteCannotExecute for unverified route, got %v", err)
	}
	var routeErr *UnverifiedRouteError
	if !errors.As(err, &routeErr) {
		t.Fatalf("expected *UnverifiedRouteError, got %T", err)
	}
	if eval.State != StateManual || eval.Executable || routeErr.PolicyNote.Summary == "" || routeErr.FallbackPath.Instructions == "" {
		t.Fatalf("expected manual fallback with policy note and instructions (RULE-M22-001/004), got %+v", eval)
	}

	// 2. Unsupported route (Shopee publish_post) starts and stays 'unsupported' with manual fallback explanation.
	evalUnsupported, err := svc.RequireExecutableCapability(ctx, wsA, accA, "shopee", "publish_post", "VN", true)
	if !errors.Is(err, ErrUnverifiedRouteCannotExecute) {
		t.Fatalf("expected ErrUnverifiedRouteCannotExecute for unsupported route, got %v", err)
	}
	if evalUnsupported.State != StateUnsupported || evalUnsupported.Executable {
		t.Fatalf("expected StateUnsupported and Executable=false, got %+v", evalUnsupported)
	}

	// 3. Wildcard scopes (e.g. "shop.*") are strictly rejected on both account registration and verification recording.
	if err := svc.RegisterConnectedAccount(ConnectedAccountRecord{
		ConnectedAccountID: accA,
		WorkspaceID:        wsA,
		Platform:           "tiktok",
		AccountType:        "creator",
		ExternalAccountID:  "tt_123",
		AccountName:        "Creator VN",
		Status:             "active",
		GrantedScopes:      []string{"shop.*"},
		Market:             "VN",
		TokenExpiresAt:     fixedNow.Add(24 * time.Hour),
	}); !errors.Is(err, ErrWildcardOrInvalidScope) {
		t.Fatalf("expected ErrWildcardOrInvalidScope for shop.*, got %v", err)
	}

	// Register valid connected account with encrypted tokens.
	if err := svc.RegisterConnectedAccount(ConnectedAccountRecord{
		ConnectedAccountID:    accA,
		WorkspaceID:           wsA,
		Platform:              "tiktok",
		AccountType:           "creator",
		ExternalAccountID:     "tt_123",
		AccountName:           "Creator VN",
		Status:                "active",
		GrantedScopes:         []string{"video.publish", "video.upload", "user.info.basic", "video.list"},
		Market:                "VN",
		AccessTokenEncrypted:  []byte("enc_secret_access_token_do_not_leak"),
		RefreshTokenEncrypted: []byte("enc_secret_refresh_token_do_not_leak"),
		TokenExpiresAt:        fixedNow.Add(24 * time.Hour),
	}); err != nil {
		t.Fatalf("RegisterConnectedAccount: %v", err)
	}

	// 4. Connected account exists, but no ActionAccessVerification recorded yet -> still 'manual', cannot execute!
	if _, err := svc.RequireExecutableCapability(ctx, wsA, accA, "tiktok", "publish_post", "VN", true); !errors.Is(err, ErrUnverifiedRouteCannotExecute) {
		t.Fatalf("expected unverified route with connected account to be blocked, got %v", err)
	}

	// 5. Read-only GET probe cannot unlock 'native' write execution!
	if err := svc.RecordVerification(wsA, accA, ActionAccessVerification{
		Platform:          "tiktok",
		Product:           "TikTok Content Posting API",
		ActionKey:         "publish_post",
		AppApprovalStatus: "approved",
		RequiredScopes:    []string{"video.publish", "video.upload"},
		GrantedScopes:     []string{"video.publish", "video.upload"},
		AccountEligible:   true,
		MarketEligibility: []string{"VN", "SG"},
		ProbeEndpoint:     "/v2/post/publish/creator_info/query/",
		ProbeMethod:       "GET",
		ProbeStatus:       "passed",
		CheckedAt:         fixedNow.Add(-2 * time.Minute),
		ValidUntil:        fixedNow.Add(24 * time.Hour),
	}); err != nil {
		t.Fatalf("RecordVerification (GET probe): %v", err)
	}
	evalReadOnly, err := svc.RequireExecutableCapability(ctx, wsA, accA, "tiktok", "publish_post", "VN", true)
	if !errors.Is(err, ErrUnverifiedRouteCannotExecute) {
		t.Fatalf("expected GET probe to be rejected for native write execution, got %v", err)
	}
	if evalReadOnly.State != StateReadOnly || evalReadOnly.Executable {
		t.Fatalf("expected StateReadOnly and Executable=false for GET probe on write action, got %+v", evalReadOnly)
	}

	// 6. Full POST probe verification within 10m freshness window unlocks StateNative and Executable=true!
	if err := svc.RecordVerification(wsA, accA, ActionAccessVerification{
		Platform:          "tiktok",
		Product:           "TikTok Content Posting API",
		ActionKey:         "publish_post",
		AppApprovalStatus: "approved",
		RequiredScopes:    []string{"video.publish", "video.upload"},
		GrantedScopes:     []string{"video.publish", "video.upload"},
		AccountEligible:   true,
		MarketEligibility: []string{"VN", "SG"},
		ProbeEndpoint:     "/v2/post/publish/video/init/",
		ProbeMethod:       "POST",
		ProbeStatus:       "passed",
		CheckedAt:         fixedNow.Add(-2 * time.Minute),
		ValidUntil:        fixedNow.Add(24 * time.Hour),
	}); err != nil {
		t.Fatalf("RecordVerification (POST probe): %v", err)
	}
	evalNative, err := svc.RequireExecutableCapability(ctx, wsA, accA, "tiktok", "publish_post", "VN", true)
	if err != nil {
		t.Fatalf("expected verified fresh POST route to execute, got %v", err)
	}
	if evalNative.State != StateNative || !evalNative.Executable || !evalNative.VerificationFresh {
		t.Fatalf("expected StateNative + Executable=true + VerificationFresh=true, got %+v", evalNative)
	}

	// 7. Ineligible target market ("JP" not in ["VN", "SG"]) cannot execute!
	if _, err := svc.RequireExecutableCapability(ctx, wsA, accA, "tiktok", "publish_post", "JP", true); !errors.Is(err, ErrUnverifiedRouteCannotExecute) {
		t.Fatalf("expected ineligible target market JP to be blocked, got %v", err)
	}

	// 8. Advance clock by 15 minutes (> 10m SnapshotFreshnessTTL): snapshot becomes stale and CANNOT execute!
	fixedNow = fixedNow.Add(15 * time.Minute)
	evalStale, err := svc.RequireExecutableCapability(ctx, wsA, accA, "tiktok", "publish_post", "VN", true)
	if !errors.Is(err, ErrUnverifiedRouteCannotExecute) {
		t.Fatalf("expected stale verification (>10m) to block execution, got %v", err)
	}
	if evalStale.VerificationFresh || evalStale.Executable || evalStale.State != StateManual {
		t.Fatalf("expected stale snapshot to degrade to StateManual with VerificationFresh=false, got %+v", evalStale)
	}

	// Refresh CheckedAt to current time, then activate kill switch -> immediately degrades to StateDegraded and blocks execution!
	_ = svc.RecordVerification(wsA, accA, ActionAccessVerification{
		Platform:          "tiktok",
		Product:           "TikTok Content Posting API",
		ActionKey:         "publish_post",
		AppApprovalStatus: "approved",
		RequiredScopes:    []string{"video.publish", "video.upload"},
		GrantedScopes:     []string{"video.publish", "video.upload"},
		AccountEligible:   true,
		MarketEligibility: []string{"VN", "SG"},
		ProbeEndpoint:     "/v2/post/publish/video/init/",
		ProbeMethod:       "POST",
		ProbeStatus:       "passed",
		CheckedAt:         fixedNow,
		ValidUntil:        fixedNow.Add(24 * time.Hour),
	})
	killSwitch.killed["tiktok::publish_post"] = "Kill Switch: TikTok Content Posting API đang bảo trì khẩn cấp"
	evalKilled, err := svc.RequireExecutableCapability(ctx, wsA, accA, "tiktok", "publish_post", "VN", true)
	if !errors.Is(err, ErrUnverifiedRouteCannotExecute) {
		t.Fatalf("expected kill switch to block execution, got %v", err)
	}
	if evalKilled.State != StateDegraded || evalKilled.Executable {
		t.Fatalf("expected StateDegraded and Executable=false when kill switch active, got %+v", evalKilled)
	}
}

func TestCompositeHealthScoresProactiveCoachingTokenRedactionAndImpersonationReadOnly(t *testing.T) {
	bindings := loadCanonicalRBAC(t)
	svc := NewService(bindings, nil)
	fixedNow := time.Date(2026, 11, 2, 8, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return fixedNow }

	const (
		wsA  = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
		usrA = "11111111-1111-4111-8111-111111111111"
		accA = "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
	)

	if err := svc.RegisterConnectedAccount(ConnectedAccountRecord{
		ConnectedAccountID:    accA,
		WorkspaceID:           wsA,
		Platform:              "tiktok",
		AccountType:           "seller",
		ExternalAccountID:     "tt_shop_1",
		AccountName:           "Shop Viet",
		Status:                "active",
		GrantedScopes:         []string{"seller.order.info"},
		Market:                "VN",
		AccessTokenEncrypted:  []byte("super_secret_access_ciphertext"),
		RefreshTokenEncrypted: []byte("super_secret_refresh_ciphertext"),
		TokenExpiresAt:        fixedNow.Add(48 * time.Hour),
	}); err != nil {
		t.Fatalf("RegisterConnectedAccount: %v", err)
	}

	// Verify native capability for sync_orders with proactive coaching metric (shop_response_rate = 42/50 = 84% < 90%).
	if err := svc.RecordVerification(wsA, accA, ActionAccessVerification{
		Platform:          "tiktok",
		Product:           "TikTok Shop Partner API",
		ActionKey:         "sync_orders",
		AppApprovalStatus: "approved",
		RequiredScopes:    []string{"seller.order.info"},
		GrantedScopes:     []string{"seller.order.info"},
		AccountEligible:   true,
		MarketEligibility: []string{"VN"},
		ProbeEndpoint:     "/order/202309/orders/search",
		ProbeMethod:       "GET",
		ProbeStatus:       "passed",
		CheckedAt:         fixedNow.Add(-1 * time.Minute),
		ValidUntil:        fixedNow.Add(24 * time.Hour),
	}); err != nil {
		t.Fatalf("RecordVerification: %v", err)
	}

	svc.SetHealthMetrics(wsA, accA, HealthMetricsInput{
		AvailabilityPct:       99.0,
		ErrorRatePct:          1.0,
		LatencyP95Ms:          180.0,
		RateLimitRemainingPct: 90.0,
		ShopResponseNumerator: 42,
		ShopResponseDenom:     50,
		BusinessWindowLabel:   "7d",
	})

	ctx := WithActorContext(context.Background(), ActorContext{
		UserID:           usrA,
		WorkspaceID:      wsA,
		WorkspaceRole:    rbac.RoleAdmin,
		WorkspaceActive:  true,
		MembershipActive: true,
	})

	// 1. CheckHealth returns healthy composite score (>=80) + proactive coaching card (42/50 in 7d),
	// and does NOT degrade technical capability!
	healthResp, err := svc.CheckHealth(ctx, connect.NewRequest(&adminv1.ConnectorServiceCheckHealthRequest{
		WorkspaceId:        &commonv1.UUID{Value: wsA},
		ConnectedAccountId: &commonv1.UUID{Value: accA},
	}))
	if err != nil {
		t.Fatalf("CheckHealth: %v", err)
	}
	card := healthResp.Msg.GetHealthScore()
	if card.GetOverallScore() < 80 || card.GetStatusBand() != "healthy" {
		t.Fatalf("expected healthy overall score >= 80, got %d (%s)", card.GetOverallScore(), card.GetStatusBand())
	}
	if len(card.GetCoachingCards()) != 1 {
		t.Fatalf("expected 1 proactive coaching card (PRD §36B), got %d", len(card.GetCoachingCards()))
	}
	cc := card.GetCoachingCards()[0]
	if cc.GetMetricKey() != "shop_response_rate" || cc.GetNumerator() != 42 || cc.GetDenominator() != 50 || cc.GetWindowLabel() != "7d" {
		t.Fatalf("unexpected proactive coaching card: %+v", cc)
	}

	// Technical capability remains StateNative & Executable=true despite business coaching warning!
	eval, err := svc.RequireExecutableCapability(ctx, wsA, accA, "tiktok", "sync_orders", "VN", false)
	if err != nil || eval.State != StateNative || !eval.Executable {
		t.Fatalf("proactive business coaching must never alter technical API capability, got state=%s err=%v", eval.State, err)
	}

	// 2. Degrade health metrics -> emits connector.degraded, then recover -> emits connector.recovered!
	svc.SetHealthMetrics(wsA, accA, HealthMetricsInput{
		AvailabilityPct:       40.0,
		ErrorRatePct:          35.0,
		LatencyP95Ms:          1900.0,
		RateLimitRemainingPct: 10.0,
	})
	degResp, err := svc.CheckHealth(ctx, connect.NewRequest(&adminv1.ConnectorServiceCheckHealthRequest{
		WorkspaceId:        &commonv1.UUID{Value: wsA},
		ConnectedAccountId: &commonv1.UUID{Value: accA},
	}))
	if err != nil {
		t.Fatalf("CheckHealth (degraded): %v", err)
	}
	if degResp.Msg.GetHealthScore().GetOverallScore() >= 50 || degResp.Msg.GetHealthScore().GetStatusBand() != "critical" {
		t.Fatalf("expected critical health score < 50, got %d", degResp.Msg.GetHealthScore().GetOverallScore())
	}

	svc.SetHealthMetrics(wsA, accA, HealthMetricsInput{
		AvailabilityPct:       99.0,
		ErrorRatePct:          0.0,
		LatencyP95Ms:          150.0,
		RateLimitRemainingPct: 95.0,
	})
	recResp, err := svc.CheckHealth(ctx, connect.NewRequest(&adminv1.ConnectorServiceCheckHealthRequest{
		WorkspaceId:        &commonv1.UUID{Value: wsA},
		ConnectedAccountId: &commonv1.UUID{Value: accA},
	}))
	if err != nil || recResp.Msg.GetHealthScore().GetOverallScore() < 80 {
		t.Fatalf("expected recovered health score >= 80, got %v / %v", recResp, err)
	}

	events := svc.EmittedEvents()
	var sawCaptured, sawDegraded, sawRecovered bool
	for _, ev := range events {
		switch ev.EventType {
		case "connector.health_score.captured":
			sawCaptured = true
		case "connector.degraded":
			sawDegraded = true
		case "connector.recovered":
			sawRecovered = true
		}
	}
	if !sawCaptured || !sawDegraded || !sawRecovered {
		t.Fatalf("expected captured/degraded/recovered events, got captured=%v degraded=%v recovered=%v", sawCaptured, sawDegraded, sawRecovered)
	}

	// 3. ConnectorService/List strips encrypted OAuth tokens (RULE-M22-005).
	listResp, err := svc.List(ctx, connect.NewRequest(&adminv1.ConnectorServiceListRequest{
		WorkspaceId: &commonv1.UUID{Value: wsA},
	}))
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	rawJSON, _ := json.Marshal(listResp.Msg)
	if strings.Contains(string(rawJSON), "super_secret") {
		t.Fatalf("RULE-M22-005 violation: encrypted token leaked in ConnectorService/List response: %s", string(rawJSON))
	}

	// 4. Impersonation is strictly read-only: GetMatrix succeeds under IsImpersonation=true, but Disconnect is denied!
	impCtx := WithActorContext(context.Background(), ActorContext{
		UserID:           usrA,
		WorkspaceID:      wsA,
		WorkspaceRole:    rbac.RoleOwner,
		WorkspaceActive:  true,
		MembershipActive: true,
		IsImpersonation:  true,
	})
	if _, err := svc.GetMatrix(impCtx, connect.NewRequest(&adminv1.GetMatrixRequest{
		WorkspaceId: &commonv1.UUID{Value: wsA},
	})); err != nil {
		t.Fatalf("expected read-only GetMatrix to succeed during impersonation, got %v", err)
	}
	_, impWriteErr := svc.Disconnect(impCtx, connect.NewRequest(&adminv1.ConnectorServiceDisconnectRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "imp-disc-1",
			WorkspaceId:    &commonv1.UUID{Value: wsA},
		},
		ConnectedAccountId: &commonv1.UUID{Value: accA},
	}))
	if connect.CodeOf(impWriteErr) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when mutating during impersonation, got %v", impWriteErr)
	}

	// 5. Normal admin Disconnect + idempotent replay + conflict check.
	disc1, err := svc.Disconnect(ctx, connect.NewRequest(&adminv1.ConnectorServiceDisconnectRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "disc-key-1",
			WorkspaceId:    &commonv1.UUID{Value: wsA},
			Reason:         "Rotate TikTok account",
		},
		ConnectedAccountId: &commonv1.UUID{Value: accA},
	}))
	if err != nil || disc1.Msg.GetReplayed() {
		t.Fatalf("Disconnect first call failed: %v", err)
	}
	disc2, err := svc.Disconnect(ctx, connect.NewRequest(&adminv1.ConnectorServiceDisconnectRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "disc-key-1",
			WorkspaceId:    &commonv1.UUID{Value: wsA},
			Reason:         "Rotate TikTok account",
		},
		ConnectedAccountId: &commonv1.UUID{Value: accA},
	}))
	if err != nil || !disc2.Msg.GetReplayed() {
		t.Fatalf("expected Disconnect replay with Replayed=true, got %v / %v", disc2, err)
	}
	_, conflictErr := svc.Disconnect(ctx, connect.NewRequest(&adminv1.ConnectorServiceDisconnectRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "disc-key-1",
			WorkspaceId:    &commonv1.UUID{Value: wsA},
			Reason:         "Different reason payload",
		},
		ConnectedAccountId: &commonv1.UUID{Value: accA},
	}))
	if connect.CodeOf(conflictErr) != connect.CodeAborted {
		t.Fatalf("expected CodeAborted on idempotency conflict, got %v", conflictErr)
	}
}

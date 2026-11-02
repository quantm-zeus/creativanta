package trend

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
)

func testContext(userID, workspaceID, role string) context.Context {
	return WithCallerContext(context.Background(), CallerContext{
		UserID:        userID,
		WorkspaceID:   workspaceID,
		WorkspaceRole: role,
	})
}

// ----------------------------------------------------------------------------
// 1. Multi-Dimensional Scoring Tests (RULE-M02-002)
// ----------------------------------------------------------------------------

func TestMultiDimensionalScoringCalculation(t *testing.T) {
	// Formula: 45% velocity + 35% freshness + 20% (100 - saturation)
	tests := []struct {
		name       string
		vel, fr, s float32
		want       float32
	}{
		{
			name: "all maximum values (zero saturation is best)",
			vel:  100,
			fr:   100,
			s:    0,
			want: 100, // 45 + 35 + 20 = 100
		},
		{
			name: "all zero values (100 saturation is worst)",
			vel:  0,
			fr:   0,
			s:    100,
			want: 0,
		},
		{
			name: "balanced medium values",
			vel:  80, // 36
			fr:   60, // 21
			s:    40, // 12 -> 69
			want: 69,
		},
		{
			name: "high saturation penalizes score",
			vel:  90, // 40.5
			fr:   80, // 28.0
			s:    90, // 2.0 -> 70.5
			want: 70.5,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got := ComputeMultiDimensionalScores(tc.vel, tc.fr, tc.s)
			if got != tc.want {
				t.Fatalf("expected composite score %v, got %v", tc.want, got)
			}
		})
	}
}

// ----------------------------------------------------------------------------
// 2. Acceptance Target 1: Source Unavailable Shows Degraded Data (EC-M02-002)
// ----------------------------------------------------------------------------

func TestAcceptanceTarget1_SourceUnavailableShowsDegradedData(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})
	ctx := testContext("usr-1", "ws-1", "editor")

	// 1. Ingest signal and create trend from TikTok
	sig := IngestedSignal{
		SignalID:          "sig-1",
		WorkspaceID:       "ws-1",
		SourcePlatform:    "tiktok",
		SourceClass:       intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		SignalType:        "keyword_spike",
		NormalizedSummary: "Cơm tấm sườn cay đang viral mạnh trên TikTok",
		Confidence:        intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		FreshnessAt:       time.Now(),
		CollectedAt:       time.Now(),
	}
	if err := store.SaveSignal(ctx, sig); err != nil {
		t.Fatalf("save signal: %v", err)
	}

	trend := StoredTrend{
		TrendID:          "trend-1",
		WorkspaceID:      "ws-1",
		Title:            "Cơm tấm sườn cay Sài Gòn",
		Summary:          "Xu hướng ẩm thực đường phố với lượng xem tăng đột biến",
		Category:         "Ẩm thực",
		Platforms:        []string{"tiktok"},
		StrengthScore:    85,
		VelocityScore:    90,
		FreshnessScore:   85,
		SaturationScore:  20,
		Confidence:       intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		ConfidenceReason: "Dữ liệu chính thức từ TikTok API",
		SourceClass:      intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		SignalIDs:        []string{"sig-1"},
		CreatedAt:        time.Now(),
		UpdatedAt:        time.Now(),
	}
	if err := store.SaveTrend(ctx, trend); err != nil {
		t.Fatalf("save trend: %v", err)
	}

	// In healthy state: high confidence, official source class, not degraded
	resHealthy, err := svc.Get(ctx, connect.NewRequest(&intelligencev1.TrendServiceGetRequest{
		WorkspaceId: "ws-1",
		TrendId:     "trend-1",
	}))
	if err != nil {
		t.Fatalf("healthy get: %v", err)
	}
	if resHealthy.Msg.Trend.IsDegraded {
		t.Fatalf("expected healthy trend not to be degraded")
	}
	if resHealthy.Msg.Trend.Confidence != intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH {
		t.Fatalf("expected HIGH confidence, got %v", resHealthy.Msg.Trend.Confidence)
	}

	// 2. Simulate TikTok disconnected (token expired per EC-M02-002)
	svc.SetSourceStatus("tiktok", true)

	// Now querying trend should return degraded data
	resDegraded, err := svc.Get(ctx, connect.NewRequest(&intelligencev1.TrendServiceGetRequest{
		WorkspaceId: "ws-1",
		TrendId:     "trend-1",
	}))
	if err != nil {
		t.Fatalf("degraded get: %v", err)
	}

	tr := resDegraded.Msg.Trend
	if !tr.IsDegraded {
		t.Fatalf("Acceptance Target 1 Failed: trend MUST be marked is_degraded when source is unavailable")
	}
	if tr.Confidence != intelligencev1.ConfidenceBand_CONFIDENCE_BAND_LOW {
		t.Fatalf("Acceptance Target 1 Failed: degraded confidence MUST be LOW, got %v", tr.Confidence)
	}
	if tr.SourceClass != intelligencev1.SourceClass_SOURCE_CLASS_ESTIMATED {
		t.Fatalf("Acceptance Target 1 Failed: degraded source_class MUST be ESTIMATED, got %v", tr.SourceClass)
	}
	if !strings.Contains(tr.DegradedReason, "tiktok") {
		t.Fatalf("expected degraded reason to mention tiktok, got %q", tr.DegradedReason)
	}
	if !strings.Contains(resDegraded.Msg.ImprovementAdvice, "Kết nối lại") {
		t.Fatalf("expected improvement advice to guide user to reconnect, got %q", resDegraded.Msg.ImprovementAdvice)
	}

	// Also verify List response includes degraded indicator and disconnected list
	listRes, err := svc.List(ctx, connect.NewRequest(&intelligencev1.TrendServiceListRequest{
		WorkspaceId: "ws-1",
	}))
	if err != nil {
		t.Fatalf("list trends: %v", err)
	}
	if !listRes.Msg.SourceDegraded {
		t.Fatalf("list response MUST flag SourceDegraded=true")
	}
	if len(listRes.Msg.DisconnectedSources) != 1 || listRes.Msg.DisconnectedSources[0] != "tiktok" {
		t.Fatalf("expected disconnected source 'tiktok', got %v", listRes.Msg.DisconnectedSources)
	}

	// 3. Reconnecting clears degraded status
	svc.SetSourceStatus("tiktok", false)
	resRestored, err := svc.Get(ctx, connect.NewRequest(&intelligencev1.TrendServiceGetRequest{
		WorkspaceId: "ws-1",
		TrendId:     "trend-1",
	}))
	if err != nil {
		t.Fatalf("restored get: %v", err)
	}
	if resRestored.Msg.Trend.IsDegraded {
		t.Fatalf("expected trend is_degraded=false after reconnecting source")
	}
}

// ----------------------------------------------------------------------------
// 3. Acceptance Target 2: Threshold Alerts Deduplicate (RULE-M02-004 & EC-M02-004)
// ----------------------------------------------------------------------------

func TestAcceptanceTarget2_ThresholdAlertsDeduplicateAndBatchStorms(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{
		Store:                store,
		AlertCooldownMinutes: 60,
	})
	ctx := testContext("usr-1", "ws-1", "editor")

	// 1. Create a watchlist with velocity threshold > 80
	_, err := svc.ManageWatchlist(ctx, connect.NewRequest(&intelligencev1.TrendServiceManageWatchlistRequest{
		WorkspaceId:  "ws-1",
		Action:       "create",
		WatchlistId:  "wl-1",
		Name:         "Hot Trends Watchlist",
		AlertEnabled: true,
		AlertThreshold: &intelligencev1.AlertThreshold{
			MinVelocityScore: 80,
			CooldownMinutes:  60,
		},
	}))
	if err != nil {
		t.Fatalf("create watchlist: %v", err)
	}

	// 2. Create a trend with velocity 90 (breaches threshold)
	trend := StoredTrend{
		TrendID:       "trend-spike-1",
		WorkspaceID:   "ws-1",
		Title:         "AI Content Generation Automation",
		VelocityScore: 90,
		StrengthScore: 85,
		CreatedAt:     time.Now(),
		UpdatedAt:     time.Now(),
	}
	if err := store.SaveTrend(ctx, trend); err != nil {
		t.Fatalf("save trend: %v", err)
	}

	// First evaluation: Alert MUST fire!
	alerts1, err := svc.EvaluateWatchlistAlerts(ctx, "ws-1")
	if err != nil {
		t.Fatalf("evaluate alerts 1: %v", err)
	}
	if len(alerts1) != 1 {
		t.Fatalf("expected exactly 1 alert triggered on first breach, got %d", len(alerts1))
	}
	if alerts1[0].TrendId != "trend-spike-1" {
		t.Fatalf("expected alert for trend-spike-1, got %v", alerts1[0].TrendId)
	}

	// Second evaluation immediately after: Alert MUST DEDUPLICATE (suppressed by cooldown)!
	alerts2, err := svc.EvaluateWatchlistAlerts(ctx, "ws-1")
	if err != nil {
		t.Fatalf("evaluate alerts 2: %v", err)
	}
	if len(alerts2) != 0 {
		t.Fatalf("Acceptance Target 2 Failed: expected 0 alerts due to deduplication, got %d", len(alerts2))
	}

	// 3. Test Alert Storm handling (>5 simultaneous alerts batched per EC-M02-004)
	for i := 2; i <= 8; i++ {
		tStorm := StoredTrend{
			TrendID:       fmt.Sprintf("trend-storm-%d", i),
			WorkspaceID:   "ws-1",
			Title:         fmt.Sprintf("Storm Trend #%d", i),
			VelocityScore: 95,
			StrengthScore: 90,
			CreatedAt:     time.Now(),
			UpdatedAt:     time.Now(),
		}
		if err := store.SaveTrend(ctx, tStorm); err != nil {
			t.Fatalf("save storm trend: %v", err)
		}
	}

	alertsStorm, err := svc.EvaluateWatchlistAlerts(ctx, "ws-1")
	if err != nil {
		t.Fatalf("evaluate storm alerts: %v", err)
	}

	// Should contain a batched summary as the first item!
	if len(alertsStorm) == 0 || !alertsStorm[0].IsBatchedSummary {
		t.Fatalf("EC-M02-004 Failed: expected batched summary notification when >5 alerts fire, got %+v", alertsStorm)
	}
	if alertsStorm[0].BatchedAlertCount != 7 {
		t.Fatalf("expected batched count 7, got %d", alertsStorm[0].BatchedAlertCount)
	}
}

// ----------------------------------------------------------------------------
// 4. Acceptance Target 3: Tenant-Scoped Semantic Search (RLS / Cross-Tenant)
// ----------------------------------------------------------------------------

func TestAcceptanceTarget3_TenantScopedSemanticSearch(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})

	ctxA := testContext("usr-a", "workspace-alpha", "viewer")
	ctxB := testContext("usr-b", "workspace-beta", "viewer")

	// Workspace Alpha trends
	trendA := StoredTrend{
		TrendID:         "trend-alpha-1",
		WorkspaceID:     "workspace-alpha",
		Title:           "Sữa hạt dinh dưỡng cho trẻ nhỏ",
		Summary:         "Công thức sữa hạt organic tự làm tại nhà",
		StrengthScore:   80,
		EmbeddingVector: []float32{0.8, 0.2, 0.1},
		CreatedAt:       time.Now(),
		UpdatedAt:       time.Now(),
	}
	if err := store.SaveTrend(ctxA, trendA); err != nil {
		t.Fatalf("save trend A: %v", err)
	}

	// Workspace Beta trends (contains highly relevant secret competitor trend)
	trendB := StoredTrend{
		TrendID:         "trend-beta-1",
		WorkspaceID:     "workspace-beta",
		Title:           "Sữa hạt dinh dưỡng bí mật công nghệ cao",
		Summary:         "Chiến lược sản phẩm sữa hạt độc quyền đối thủ Beta",
		StrengthScore:   98,
		EmbeddingVector: []float32{0.99, 0.2, 0.1}, // near-perfect match
		CreatedAt:       time.Now(),
		UpdatedAt:       time.Now(),
	}
	if err := store.SaveTrend(ctxB, trendB); err != nil {
		t.Fatalf("save trend B: %v", err)
	}

	// 1. Search in Workspace Alpha for "sữa hạt dinh dưỡng"
	searchReqA := &intelligencev1.TrendServiceSearchRequest{
		WorkspaceId:    "workspace-alpha",
		Query:          "sữa hạt dinh dưỡng",
		QueryEmbedding: []float32{0.9, 0.2, 0.1},
	}
	resA, err := svc.Search(ctxA, connect.NewRequest(searchReqA))
	if err != nil {
		t.Fatalf("search A: %v", err)
	}

	// MUST return trend-alpha-1
	if len(resA.Msg.Results) != 1 {
		t.Fatalf("expected 1 result in workspace-alpha, got %d", len(resA.Msg.Results))
	}
	if resA.Msg.Results[0].TrendId != "trend-alpha-1" {
		t.Fatalf("expected trend-alpha-1, got %v", resA.Msg.Results[0].TrendId)
	}

	// Acceptance Target 3: ABSOLUTELY ZERO LEAKAGE of Workspace Beta's trend!
	for _, res := range resA.Msg.Results {
		if res.WorkspaceId != "workspace-alpha" || res.TrendId == "trend-beta-1" {
			t.Fatalf("CRITICAL SECURITY VIOLATION: Cross-tenant data leakage in semantic search! Trend %s from %s was returned to %s",
				res.TrendId, res.WorkspaceId, "workspace-alpha")
		}
	}

	// 2. Caller from Workspace Alpha attempting to explicitly set workspace_id = "workspace-beta" MUST be REJECTED!
	spoofReq := &intelligencev1.TrendServiceSearchRequest{
		WorkspaceId: "workspace-beta",
		Query:       "sữa hạt",
	}
	_, err = svc.Search(ctxA, connect.NewRequest(spoofReq))
	if err == nil {
		t.Fatalf("expected cross-tenant search attempt to fail closed with PermissionDenied, got nil error")
	}

	// 3. Search in Workspace Beta yields its own trend
	searchReqB := &intelligencev1.TrendServiceSearchRequest{
		WorkspaceId: "workspace-beta",
		Query:       "sữa hạt",
	}
	resB, err := svc.Search(ctxB, connect.NewRequest(searchReqB))
	if err != nil {
		t.Fatalf("search B: %v", err)
	}
	if len(resB.Msg.Results) != 1 || resB.Msg.Results[0].TrendId != "trend-beta-1" {
		t.Fatalf("expected trend-beta-1 in workspace-beta, got %+v", resB.Msg.Results)
	}
}

// ----------------------------------------------------------------------------
// 5. RBAC & Role Permission Enforcement Tests
// ----------------------------------------------------------------------------

func TestRBACPermissions(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})

	// Viewer has trend:read -> CAN list
	ctxViewer := testContext("usr-view", "ws-1", "viewer")
	_, err := svc.List(ctxViewer, connect.NewRequest(&intelligencev1.TrendServiceListRequest{
		WorkspaceId: "ws-1",
	}))
	if err != nil {
		t.Fatalf("viewer should have trend:read: %v", err)
	}

	// Viewer does NOT have trend:watchlist:manage -> MUST BE DENIED
	_, err = svc.ManageWatchlist(ctxViewer, connect.NewRequest(&intelligencev1.TrendServiceManageWatchlistRequest{
		WorkspaceId: "ws-1",
		Action:      "create",
		Name:        "Illegal Watchlist",
	}))
	if err == nil {
		t.Fatalf("expected viewer to be denied trend:watchlist:manage")
	}

	// Editor has trend:watchlist:manage -> CAN create watchlist
	ctxEditor := testContext("usr-edit", "ws-1", "editor")
	_, err = svc.ManageWatchlist(ctxEditor, connect.NewRequest(&intelligencev1.TrendServiceManageWatchlistRequest{
		WorkspaceId: "ws-1",
		Action:      "create",
		Name:        "Editor Watchlist",
	}))
	if err != nil {
		t.Fatalf("editor should be allowed to manage watchlist: %v", err)
	}

	// External role has NO trend permissions -> MUST BE DENIED
	ctxExternal := testContext("usr-ext", "ws-1", "external")
	_, err = svc.List(ctxExternal, connect.NewRequest(&intelligencev1.TrendServiceListRequest{
		WorkspaceId: "ws-1",
	}))
	if err == nil {
		t.Fatalf("external role must be denied trend:read")
	}
}

// ----------------------------------------------------------------------------
// 6. Provenance Lineage and Opportunity Conversion (AC-M02-002)
// ----------------------------------------------------------------------------

func TestLineageAndOpportunityConversion(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})
	ctx := testContext("usr-1", "ws-1", "editor")

	// Save signal
	sig := IngestedSignal{
		SignalID:          "sig-prov-1",
		WorkspaceID:       "ws-1",
		SourcePlatform:    "shopee",
		SourceClass:       intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		NormalizedSummary: "Nồi chiên không dầu mini 2L bán chạy top 1",
		FreshnessAt:       time.Now(),
		CollectedAt:       time.Now(),
	}
	_ = store.SaveSignal(ctx, sig)

	// Save trend with signal lineage
	tr := StoredTrend{
		TrendID:       "trend-pot-1",
		WorkspaceID:   "ws-1",
		Title:         "Nồi chiên không dầu sinh viên",
		StrengthScore: 78,
		SignalIDs:     []string{"sig-prov-1"},
		CreatedAt:     time.Now(),
		UpdatedAt:     time.Now(),
	}
	_ = store.SaveTrend(ctx, tr)

	// Verify Get returns lineage
	resGet, err := svc.Get(ctx, connect.NewRequest(&intelligencev1.TrendServiceGetRequest{
		WorkspaceId: "ws-1",
		TrendId:     "trend-pot-1",
	}))
	if err != nil {
		t.Fatalf("get trend: %v", err)
	}
	if len(resGet.Msg.LineageSignals) != 1 || resGet.Msg.LineageSignals[0].SignalId != "sig-prov-1" {
		t.Fatalf("RULE-M02-003 Failed: trend must retain signal lineage provenance")
	}

	// Convert to Opportunity (AC-M02-002)
	oppID, err := svc.ConvertToOpportunity(ctx, "ws-1", "trend-pot-1", "Review nồi chiên mini sinh viên")
	if err != nil {
		t.Fatalf("convert to opportunity: %v", err)
	}
	if oppID == "" {
		t.Fatalf("expected valid opportunity ID returned")
	}

	opp, exists := store.opportunites[oppID]
	if !exists {
		t.Fatalf("opportunity not saved in store")
	}
	if opp.SourceType != "trend" || opp.SourceID != "trend-pot-1" {
		t.Fatalf("AC-M02-002 Failed: opportunity MUST link back to trend with source_type='trend', got %s:%s",
			opp.SourceType, opp.SourceID)
	}
}

// ----------------------------------------------------------------------------
// 7. Concurrent Ingestion & Evaluation Race Detector Test
// ----------------------------------------------------------------------------

func TestConcurrentTrendOperationsNoRace(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})
	ctx := testContext("usr-concurrent", "ws-concurrent", "editor")

	var wg sync.WaitGroup
	workers := 10

	// Concurrent trend additions
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			tr := StoredTrend{
				TrendID:       fmt.Sprintf("trend-conc-%d", idx),
				WorkspaceID:   "ws-concurrent",
				Title:         fmt.Sprintf("Concurrent Trend #%d", idx),
				VelocityScore: float32(70 + idx),
				StrengthScore: float32(75 + idx),
				CreatedAt:     time.Now(),
				UpdatedAt:     time.Now(),
			}
			_ = store.SaveTrend(ctx, tr)
		}(i)
	}

	// Concurrent searches and watchlist evaluations
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			_, _ = svc.Search(ctx, connect.NewRequest(&intelligencev1.TrendServiceSearchRequest{
				WorkspaceId: "ws-concurrent",
				Query:       "Concurrent",
			}))
			_, _ = svc.EvaluateWatchlistAlerts(ctx, "ws-concurrent")
		}()
	}

	wg.Wait()
}

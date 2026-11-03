package competitor

import (
	"context"
	"errors"
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
// Acceptance Target 1: Inferred Insight Labeled (RULE-M03-001, RULE-M03-002, AC 1)
// ----------------------------------------------------------------------------

func TestAcceptanceTarget1_InferredInsightLabeled(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})
	ctx := testContext("usr-editor", "ws-tenant-a", "editor")

	// 1. Add competitor
	addResp, err := svc.Add(ctx, connect.NewRequest(&intelligencev1.CompetitorServiceAddRequest{
		WorkspaceId:    "ws-tenant-a",
		Platform:       "TikTok",
		ExternalHandle: "@skincare_queen",
		Name:           "Skincare Queen",
		Category:       "Làm đẹp / Skincare",
	}))
	if err != nil {
		t.Fatalf("Add competitor failed: %v", err)
	}
	compID := addResp.Msg.Competitor.CompetitorId

	// 2. Analyze Benchmark
	analyzeResp, err := svc.AnalyzeBenchmark(ctx, connect.NewRequest(&intelligencev1.AnalyzeBenchmarkRequest{
		WorkspaceId:  "ws-tenant-a",
		CompetitorId: compID,
	}))
	if err != nil {
		t.Fatalf("AnalyzeBenchmark failed: %v", err)
	}

	snap := analyzeResp.Msg.Snapshot
	if snap == nil {
		t.Fatal("expected non-nil BenchmarkSnapshot")
	}

	// Invariant RULE-M03-001: Every inferred insight MUST carry source_class = 'inferred'
	if snap.SourceClass != intelligencev1.SourceClass_SOURCE_CLASS_INFERRED {
		t.Fatalf("expected SourceClass = INFERRED, got %v", snap.SourceClass)
	}

	// Invariant RULE-M03-002: Confidence band and Why explanation
	if snap.Confidence == intelligencev1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED {
		t.Fatalf("expected specified ConfidenceBand, got %v", snap.Confidence)
	}

	why := snap.WhyExplanation
	if why == nil {
		t.Fatal("expected non-nil WhyExplanation per RULE-M03-002")
	}
	if len(why.DataSources) == 0 {
		t.Fatal("expected WhyExplanation to contain data sources used")
	}
	if len(why.Limitations) == 0 {
		t.Fatal("expected WhyExplanation to contain limitations")
	}
	if len(why.DataGaps) == 0 {
		t.Fatal("expected WhyExplanation to contain data gaps")
	}
	if why.BasisSummary == "" {
		t.Fatal("expected non-empty WhyExplanation basis summary")
	}

	// Verify White-Space Gaps are also clearly labeled as INFERRED
	if len(analyzeResp.Msg.WhiteSpaceGaps) == 0 {
		t.Fatal("expected white-space gaps to be detected")
	}
	for _, gap := range analyzeResp.Msg.WhiteSpaceGaps {
		if gap.SourceClass != intelligencev1.SourceClass_SOURCE_CLASS_INFERRED {
			t.Fatalf("white-space gap %s has source_class=%v, want INFERRED", gap.GapId, gap.SourceClass)
		}
		if gap.WhyExplanation == nil || len(gap.WhyExplanation.DataSources) == 0 {
			t.Fatalf("white-space gap %s missing why explanation data sources", gap.GapId)
		}
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Stale Snapshots Visible (RULE-M03-004, AC 2)
// ----------------------------------------------------------------------------

func TestAcceptanceTarget2_StaleSnapshotsVisible(t *testing.T) {
	store := NewMemoryStore()
	ctx := testContext("usr-viewer", "ws-tenant-a", "viewer")

	// Case A: Recent snapshot (5 days old) -> NOT stale
	recentSnap := StoredBenchmarkSnapshot{
		SnapshotID:      "snap-recent",
		WorkspaceID:     "ws-tenant-a",
		CompetitorID:    "comp-1",
		SnapshotType:    "benchmark",
		DataPeriodStart: "2026-03-01",
		DataPeriodEnd:   "2026-03-25",
		CapturedAt:      time.Now().AddDate(0, 0, -5), // 5 days old
		CreatedAt:       time.Now().AddDate(0, 0, -5),
		SourceClass:     intelligencev1.SourceClass_SOURCE_CLASS_INFERRED,
		Confidence:      intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
	}
	pbRecent := toPBSnapshot(recentSnap)
	if pbRecent.IsStale {
		t.Fatalf("5-day old snapshot should NOT be marked stale, got is_stale=true")
	}
	if pbRecent.StaleWarning != "" {
		t.Fatalf("expected empty StaleWarning for recent snapshot, got %q", pbRecent.StaleWarning)
	}

	// Case B: Stale snapshot (45 days old > 30 days) -> MUST be marked stale with warning
	staleSnap := StoredBenchmarkSnapshot{
		SnapshotID:      "snap-stale",
		WorkspaceID:     "ws-tenant-a",
		CompetitorID:    "comp-1",
		SnapshotType:    "benchmark",
		DataPeriodStart: "2026-01-01",
		DataPeriodEnd:   "2026-01-30",
		CapturedAt:      time.Now().AddDate(0, 0, -45), // 45 days old (>30 days per RULE-M03-004)
		CreatedAt:       time.Now().AddDate(0, 0, -45),
		SourceClass:     intelligencev1.SourceClass_SOURCE_CLASS_INFERRED,
		Confidence:      intelligencev1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM,
	}
	if err := store.SaveSnapshot(ctx, staleSnap); err != nil {
		t.Fatalf("save stale snapshot: %v", err)
	}

	pbStale := toPBSnapshot(staleSnap)
	if !pbStale.IsStale {
		t.Fatal("45-day old snapshot (>30 days) MUST be marked is_stale=true per RULE-M03-004")
	}
	if !strings.Contains(pbStale.StaleWarning, ">30 ngày") {
		t.Fatalf("expected warning mentioning >30 ngày, got %q", pbStale.StaleWarning)
	}
	if pbStale.DaysSinceCapture < 40 {
		t.Fatalf("expected DaysSinceCapture >= 40, got %d", pbStale.DaysSinceCapture)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: No Assumed Access to Competitor Finance (RULE-M03-003, EC-M03-002, AC 4)
// ----------------------------------------------------------------------------

func TestAcceptanceTarget3_NoAssumedAccessToCompetitorFinance(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})
	ctx := testContext("usr-member", "ws-tenant-a", "viewer")

	// 1. Verify Benchmark Comparison screen strictly hides and caveats revenue
	compareResp, err := svc.Compare(ctx, connect.NewRequest(&intelligencev1.BenchmarkServiceCompareRequest{
		WorkspaceId: "ws-tenant-a",
		Period:      "30d",
	}))
	if err != nil {
		t.Fatalf("Compare benchmarks failed: %v", err)
	}

	guard := compareResp.Msg.Comparison.RevenueMetricGuard
	if guard == nil {
		t.Fatal("expected non-nil RevenueMetricGuard in BenchmarkComparison")
	}
	if guard.Status != "PRIVATE_NOT_COMPARED" {
		t.Fatalf("expected revenue status 'PRIVATE_NOT_COMPARED', got %q", guard.Status)
	}
	if guard.DisplayValue != "—" {
		t.Fatalf("expected revenue display value '—', got %q", guard.DisplayValue)
	}
	if !guard.IsConflationBlocked {
		t.Fatal("expected IsConflationBlocked = true")
	}

	// 2. Verify ValidateNonConflationWithFinance strictly rejects competitor observational pricing in ledger/cost
	errInferredToFinance := ValidateNonConflationWithFinance(intelligencev1.SourceClass_SOURCE_CLASS_INFERRED, "operating_ledger")
	if !errors.Is(errInferredToFinance, ErrFinancialConflation) {
		t.Fatalf("expected ErrFinancialConflation when feeding inferred data to operating_ledger, got %v", errInferredToFinance)
	}

	errEstimatedToCOGS := ValidateNonConflationWithFinance(intelligencev1.SourceClass_SOURCE_CLASS_ESTIMATED, "cogs")
	if !errors.Is(errEstimatedToCOGS, ErrFinancialConflation) {
		t.Fatalf("expected ErrFinancialConflation when feeding estimated data to cogs, got %v", errEstimatedToCOGS)
	}

	// Legitimate operational context (e.g. content planning or opportunity) is allowed
	errValid := ValidateNonConflationWithFinance(intelligencev1.SourceClass_SOURCE_CLASS_INFERRED, "opportunity_board")
	if errValid != nil {
		t.Fatalf("expected non-financial domain to pass validation, got %v", errValid)
	}
}

// ----------------------------------------------------------------------------
// RBAC Authorization Tests (Editor+ for manage, Member+ for read)
// ----------------------------------------------------------------------------

func TestRBACPermissions(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})

	viewerCtx := testContext("usr-viewer", "ws-tenant-a", "viewer")
	editorCtx := testContext("usr-editor", "ws-tenant-a", "editor")

	// 1. Viewer is DENIED on Add
	_, err := svc.Add(viewerCtx, connect.NewRequest(&intelligencev1.CompetitorServiceAddRequest{
		WorkspaceId:    "ws-tenant-a",
		Platform:       "TikTok",
		ExternalHandle: "@unauthorized_test",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for Viewer calling Add, got %v", err)
	}

	// 2. Editor is ALLOWED on Add
	addResp, err := svc.Add(editorCtx, connect.NewRequest(&intelligencev1.CompetitorServiceAddRequest{
		WorkspaceId:    "ws-tenant-a",
		Platform:       "TikTok",
		ExternalHandle: "@authorized_test",
		Name:           "Authorized Test",
	}))
	if err != nil {
		t.Fatalf("Editor Add failed: %v", err)
	}
	compID := addResp.Msg.Competitor.CompetitorId

	// 3. Viewer is ALLOWED on List
	listResp, err := svc.List(viewerCtx, connect.NewRequest(&intelligencev1.CompetitorServiceListRequest{
		WorkspaceId: "ws-tenant-a",
	}))
	if err != nil {
		t.Fatalf("Viewer List failed: %v", err)
	}
	if len(listResp.Msg.Competitors) == 0 {
		t.Fatal("expected at least 1 competitor in list")
	}

	// 4. Viewer is DENIED on SetAlerts
	_, err = svc.SetAlerts(viewerCtx, connect.NewRequest(&intelligencev1.SetAlertsRequest{
		WorkspaceId:  "ws-tenant-a",
		CompetitorId: compID,
		AlertConfig: &intelligencev1.AlertConfig{
			Enabled:            true,
			MinIntervalMinutes: 60,
		},
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for Viewer calling SetAlerts, got %v", err)
	}

	// 5. Viewer is DENIED on AnalyzeBenchmark
	_, err = svc.AnalyzeBenchmark(viewerCtx, connect.NewRequest(&intelligencev1.AnalyzeBenchmarkRequest{
		WorkspaceId:  "ws-tenant-a",
		CompetitorId: compID,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for Viewer calling AnalyzeBenchmark, got %v", err)
	}

	// 6. Viewer is DENIED on Remove
	_, err = svc.Remove(viewerCtx, connect.NewRequest(&intelligencev1.CompetitorServiceRemoveRequest{
		WorkspaceId:  "ws-tenant-a",
		CompetitorId: compID,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for Viewer calling Remove, got %v", err)
	}

	// 7. Editor is ALLOWED on Remove
	remResp, err := svc.Remove(editorCtx, connect.NewRequest(&intelligencev1.CompetitorServiceRemoveRequest{
		WorkspaceId:  "ws-tenant-a",
		CompetitorId: compID,
	}))
	if err != nil {
		t.Fatalf("Editor Remove failed: %v", err)
	}
	if !remResp.Msg.Success {
		t.Fatal("expected remove success=true")
	}
}

// ----------------------------------------------------------------------------
// Multi-Tenant Isolation Tests (RULE-M03-005)
// ----------------------------------------------------------------------------

func TestMultiTenantIsolation(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})

	tenantACtx := testContext("usr-a", "ws-tenant-a", "editor")
	tenantBCtx := testContext("usr-b", "ws-tenant-b", "editor")

	// 1. Tenant A adds competitor
	addRespA, err := svc.Add(tenantACtx, connect.NewRequest(&intelligencev1.CompetitorServiceAddRequest{
		WorkspaceId:    "ws-tenant-a",
		Platform:       "Instagram",
		ExternalHandle: "@secret_competitor_a",
	}))
	if err != nil {
		t.Fatalf("Tenant A add competitor: %v", err)
	}
	compIDA := addRespA.Msg.Competitor.CompetitorId

	// 2. Tenant B lists competitors -> must NOT see Tenant A's competitor
	listRespB, err := svc.List(tenantBCtx, connect.NewRequest(&intelligencev1.CompetitorServiceListRequest{
		WorkspaceId: "ws-tenant-b",
	}))
	if err != nil {
		t.Fatalf("Tenant B list: %v", err)
	}
	for _, c := range listRespB.Msg.Competitors {
		if c.CompetitorId == compIDA {
			t.Fatalf("Cross-tenant leakage: Tenant B saw Tenant A's competitor %s", compIDA)
		}
	}

	// 3. Tenant B tries to explicitly target Tenant A's workspace_id -> DENIED
	_, err = svc.List(tenantBCtx, connect.NewRequest(&intelligencev1.CompetitorServiceListRequest{
		WorkspaceId: "ws-tenant-a", // spoof target
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied for spoofed cross-tenant list, got %v", err)
	}

	// 4. Tenant B tries to remove Tenant A's competitor -> DENIED or Not Found
	_, err = svc.Remove(tenantBCtx, connect.NewRequest(&intelligencev1.CompetitorServiceRemoveRequest{
		WorkspaceId:  "ws-tenant-b",
		CompetitorId: compIDA,
	}))
	if connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when deleting competitor from another workspace, got %v", err)
	}
}

// ----------------------------------------------------------------------------
// Edge Cases & Invariants (EC-M03-004, Duplicate Handle, 60m min interval)
// ----------------------------------------------------------------------------

func TestEdgeCasesAndInvariants(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})
	ctx := testContext("usr-editor", "ws-tenant-a", "editor")

	// 1. Duplicate handle check
	_, err := svc.Add(ctx, connect.NewRequest(&intelligencev1.CompetitorServiceAddRequest{
		WorkspaceId:    "ws-tenant-a",
		Platform:       "TikTok",
		ExternalHandle: "@duplicate_test",
	}))
	if err != nil {
		t.Fatalf("initial add: %v", err)
	}

	_, errDup := svc.Add(ctx, connect.NewRequest(&intelligencev1.CompetitorServiceAddRequest{
		WorkspaceId:    "ws-tenant-a",
		Platform:       "TikTok",
		ExternalHandle: "@duplicate_test", // same handle on same platform
	}))
	if connect.CodeOf(errDup) != connect.CodeAlreadyExists {
		t.Fatalf("expected CodeAlreadyExists for duplicate handle, got %v", errDup)
	}

	// 2. Alert config minimum interval constraint (§27.3: min 60 minutes)
	setAlertResp, err := svc.SetAlerts(ctx, connect.NewRequest(&intelligencev1.SetAlertsRequest{
		WorkspaceId:  "ws-tenant-a",
		CompetitorId: generateDeterministicUUID("ws-tenant-a", "TikTok:@duplicate_test"),
		AlertConfig: &intelligencev1.AlertConfig{
			Enabled:            true,
			MinIntervalMinutes: 15, // Try setting below 60
		},
	}))
	if err != nil {
		t.Fatalf("SetAlerts failed: %v", err)
	}
	if setAlertResp.Msg.AlertConfig.MinIntervalMinutes < 60 {
		t.Fatalf("expected MinIntervalMinutes to be capped at minimum 60 per §27.3, got %d", setAlertResp.Msg.AlertConfig.MinIntervalMinutes)
	}
}

// ----------------------------------------------------------------------------
// Concurrency Race Detector Test
// ----------------------------------------------------------------------------

func TestConcurrentOperationsNoRace(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{Store: store})
	ctx := testContext("usr-editor", "ws-tenant-a", "editor")

	var wg sync.WaitGroup
	const workers = 10

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			handle := strings.TrimSpace(testHandle(workerID))
			_, _ = svc.Add(ctx, connect.NewRequest(&intelligencev1.CompetitorServiceAddRequest{
				WorkspaceId:    "ws-tenant-a",
				Platform:       "TikTok",
				ExternalHandle: handle,
				Name:           "Competitor " + handle,
			}))
			_, _ = svc.List(ctx, connect.NewRequest(&intelligencev1.CompetitorServiceListRequest{
				WorkspaceId: "ws-tenant-a",
			}))
			_, _ = svc.Compare(ctx, connect.NewRequest(&intelligencev1.BenchmarkServiceCompareRequest{
				WorkspaceId: "ws-tenant-a",
			}))
		}(i)
	}

	wg.Wait()
}

func testHandle(id int) string {
	return strings.TrimSpace(testHandleNames[id%len(testHandleNames)])
}

var testHandleNames = []string{
	"@creator_alpha",
	"@creator_beta",
	"@creator_gamma",
	"@creator_delta",
	"@creator_epsilon",
	"@creator_zeta",
	"@creator_eta",
	"@creator_theta",
	"@creator_iota",
	"@creator_kappa",
}

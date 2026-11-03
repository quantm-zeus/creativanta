package intelligence

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
)

func setupTestService() *Service {
	return NewService(nil, nil, nil, nil)
}

// TestAcceptanceTarget1_EveryLiveSourceHasAccessEvidence verifies that every live source
// requires valid access evidence and that unverified/expired sources fail closed or degrade.
func TestAcceptanceTarget1_EveryLiveSourceHasAccessEvidence(t *testing.T) {
	svc := setupTestService()
	ctx := context.Background()
	wsID := "ws-test-tenant-01"
	now := time.Now().UTC()

	// Scenario 1: Fresh workspace with 0 connected accounts -> Fails closed for live queries
	result, err := svc.ValidateLiveSourceAccess(ctx, wsID, "tiktok", "tiktok:profile:read", now)
	if err != ErrUnverifiedLiveAccess {
		t.Fatalf("expected ErrUnverifiedLiveAccess for unconnected platform, got: %v", err)
	}
	if result.IsVerified {
		t.Fatal("unconnected live source must NOT be marked verified")
	}
	if !result.CanFallbackToImport {
		t.Fatal("expected CanFallbackToImport=true when live connector is unavailable")
	}
	if result.SourceClass != intelligencev1.SourceClass_SOURCE_CLASS_UNSPECIFIED {
		t.Fatalf("expected unspecified source class, got %v", result.SourceClass)
	}

	// Scenario 2: Connected account with valid, unexpired ActionAccessVerification
	validProof := AccessProofResult{
		Platform:            "tiktok",
		ActionKey:           "tiktok:profile:read",
		IsVerified:          true,
		IsDegraded:          false,
		SourceClass:         intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		ConfidenceBand:      intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		EvidenceRef:         "ev-obj-tiktok-verified-2026",
		GrantedScopes:       []string{"user.info.basic", "video.list"},
		RequiredScopes:      []string{"user.info.basic"},
		Endpoint:            "https://open.tiktokapis.com/v2/research/user/info/",
		CheckedAt:           now.Add(-2 * time.Hour),
		ValidUntil:          now.Add(24 * time.Hour),
		CanFallbackToImport: true,
	}
	svc.SetConnectedAccountState(wsID, "tiktok", true)
	svc.RegisterAccessVerification(wsID, validProof)

	verifiedRes, err := svc.ValidateLiveSourceAccess(ctx, wsID, "tiktok", "tiktok:profile:read", now)
	if err != nil {
		t.Fatalf("expected verified access to succeed, got: %v", err)
	}
	if !verifiedRes.IsVerified {
		t.Fatal("expected IsVerified=true for valid proof")
	}
	if verifiedRes.SourceClass != intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL {
		t.Fatalf("expected SOURCE_CLASS_OFFICIAL, got %v", verifiedRes.SourceClass)
	}
	if verifiedRes.ConfidenceBand != intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH {
		t.Fatalf("expected CONFIDENCE_BAND_HIGH, got %v", verifiedRes.ConfidenceBand)
	}
	if verifiedRes.EvidenceRef != "ev-obj-tiktok-verified-2026" {
		t.Fatalf("unexpected evidence ref: %s", verifiedRes.EvidenceRef)
	}

	// Scenario 3: Connected account but token/verification EXPIRED
	expiredProof := AccessProofResult{
		Platform:            "shopee",
		ActionKey:           "shopee:product:read",
		IsVerified:          true,
		IsDegraded:          false,
		SourceClass:         intelligencev1.SourceClass_SOURCE_CLASS_OFFICIAL,
		ConfidenceBand:      intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		EvidenceRef:         "ev-obj-shopee-expired",
		GrantedScopes:       []string{"item.read"},
		RequiredScopes:      []string{"item.read"},
		Endpoint:            "https://partner.shopeemobile.com/api/v2/product/get_item_list",
		CheckedAt:           now.Add(-48 * time.Hour),
		ValidUntil:          now.Add(-2 * time.Hour), // EXPIRED
		CanFallbackToImport: true,
	}
	svc.SetConnectedAccountState(wsID, "shopee", true)
	svc.RegisterAccessVerification(wsID, expiredProof)

	expiredRes, err := svc.ValidateLiveSourceAccess(ctx, wsID, "shopee", "shopee:product:read", now)
	if err != nil {
		t.Fatalf("expired proof should return degraded status without hard error, got: %v", err)
	}
	if expiredRes.IsVerified {
		t.Fatal("expired source must NOT be marked verified")
	}
	if !expiredRes.IsDegraded {
		t.Fatal("expired source MUST be flagged IsDegraded=true")
	}
	if expiredRes.ConfidenceBand != intelligencev1.ConfidenceBand_CONFIDENCE_BAND_LOW {
		t.Fatalf("expired source confidence must drop to LOW, got %v", expiredRes.ConfidenceBand)
	}
	if expiredRes.SourceClass != intelligencev1.SourceClass_SOURCE_CLASS_ESTIMATED {
		t.Fatalf("expired source must degrade to SOURCE_CLASS_ESTIMATED, got %v", expiredRes.SourceClass)
	}
	if !expiredRes.ReconnectRequired || expiredRes.ReconnectCTA == "" {
		t.Fatal("expired source must indicate ReconnectRequired with ReconnectCTA")
	}
}

// TestAcceptanceTarget2_FutureConversionsRemainAssignedToLaterTasks verifies that
// conversions create linked drafts with preserved lineage, while downstream generation
// is strictly gated to Phase P3 and Phase P6.
func TestAcceptanceTarget2_FutureConversionsRemainAssignedToLaterTasks(t *testing.T) {
	svc := setupTestService()
	ctx := context.Background()
	caller := CallerContext{
		UserID:        "user-owner-01",
		WorkspaceID:   "ws-test-tenant-01",
		WorkspaceRole: "owner",
	}

	targets := []struct {
		targetType   string
		owningModule string
		owningPhase  string
		taskPrefix   string
	}{
		{targetType: "idea", owningModule: "M05", owningPhase: "P3", taskPrefix: "P3-01"},
		{targetType: "script", owningModule: "M06", owningPhase: "P3", taskPrefix: "P3-02"},
		{targetType: "campaign", owningModule: "M14", owningPhase: "P6", taskPrefix: "P6-01"},
		{targetType: "live_plan", owningModule: "M17", owningPhase: "P6", taskPrefix: "P6-05"},
	}

	for _, tc := range targets {
		t.Run("conversion_target_"+tc.targetType, func(t *testing.T) {
			policy, err := svc.GetDownstreamGatePolicy(tc.targetType)
			if err != nil {
				t.Fatalf("failed to get policy for %s: %v", tc.targetType, err)
			}
			if policy.OwningModule != tc.owningModule {
				t.Errorf("expected module %s, got %s", tc.owningModule, policy.OwningModule)
			}
			if policy.OwningPhase != tc.owningPhase {
				t.Errorf("expected phase %s, got %s", tc.owningPhase, policy.OwningPhase)
			}
			if !policy.IsGated {
				t.Errorf("expected downstream action %s to be gated in P2", tc.targetType)
			}
			if !policy.LineagePreserved {
				t.Errorf("expected lineage preserved for %s", tc.targetType)
			}

			// 1. Normal conversion: records linked draft without executing downstream generation
			opp, gate, err := svc.ConvertWithDownstreamGating(
				ctx,
				caller,
				"opp-1234",
				tc.targetType,
				"Sample Title",
				"Sample Notes",
				false, // attemptExecution = false
			)
			if err != nil {
				t.Fatalf("conversion should succeed as linked draft: %v", err)
			}
			if opp.ConvertedToType != tc.targetType {
				t.Errorf("expected ConvertedToType=%s, got %s", tc.targetType, opp.ConvertedToType)
			}
			if !strings.HasPrefix(opp.ConvertedToID, "draft-"+tc.targetType+"-") {
				t.Errorf("expected draft ID prefix, got %s", opp.ConvertedToID)
			}
			if gate.IsGated != true {
				t.Error("gate policy must indicate is_gated=true")
			}

			// 2. Direct attempt to execute unbuilt generation in Phase P2: FAILS CLOSED
			_, _, err = svc.ConvertWithDownstreamGating(
				ctx,
				caller,
				"opp-1234",
				tc.targetType,
				"Sample Title",
				"Sample Notes",
				true, // attemptExecution = true (attempting live generation)
			)
			if err != ErrDownstreamActionGated {
				t.Fatalf("expected ErrDownstreamActionGated when attempting live execution, got: %v", err)
			}
		})
	}
}

// TestAcceptanceTarget3_EmptyDegradedAndAuditPaths verifies:
// 1. Empty path: clean empty state with CTAs, no synthetic mocks posing as live data.
// 2. Degraded path: token expiration / disconnection surfaced with banners and reconnect CTAs.
// 3. Audit path: provenance integrity, non-conflation, RBAC matrix, and concurrency checks pass.
func TestAcceptanceTarget3_EmptyDegradedAndAuditPaths(t *testing.T) {
	svc := setupTestService()
	ctx := context.Background()
	wsID := "ws-audit-test"

	// 1. Empty Path Verification
	emptySummary := svc.EvaluateWorkspaceEmptyState(ctx, wsID, 0, 0, 0)
	if !emptySummary.TrendRadarEmpty || !emptySummary.CompetitorEmpty || !emptySummary.OpportunityEmpty {
		t.Fatal("expected all intelligence modules to report empty state on 0 counts")
	}
	if emptySummary.TrendCTA == "" || emptySummary.CompetitorCTA == "" || emptySummary.OpportunityCTA == "" {
		t.Fatal("empty states must include actionable CTAs for user guidance")
	}

	// 2. Degraded Path Verification
	svc.SetConnectedAccountState(wsID, "tiktok", false) // Disconnected
	degradedSummary := svc.EvaluateWorkspaceDegradedState(ctx, wsID, []string{"tiktok", "youtube"})
	if !degradedSummary.HasDegradedSources {
		t.Fatal("expected HasDegradedSources=true when TikTok is disconnected")
	}
	if len(degradedSummary.DegradedPlatforms) == 0 {
		t.Fatal("expected degraded platforms list to be non-empty")
	}
	if len(degradedSummary.ReconnectCTAs) == 0 {
		t.Fatal("expected reconnect CTAs for degraded sources")
	}

	// 3. Audit Path Verification
	// Test A: Financial Non-Conflation Gate
	err := svc.ValidateFinancialNonConflation("competitor", true)
	if err != ErrFinancialConflation {
		t.Fatalf("expected ErrFinancialConflation for competitor observational data, got: %v", err)
	}
	err = svc.ValidateFinancialNonConflation("opportunity_estimate", false)
	if err != ErrFinancialConflation {
		t.Fatalf("expected ErrFinancialConflation for estimated opportunity profit, got: %v", err)
	}
	err = svc.ValidateFinancialNonConflation("commerce_order", false)
	if err != nil {
		t.Fatalf("transactional commerce order should pass financial validation, got: %v", err)
	}

	// Test B: RBAC Denial on unauthorized roles
	viewerCaller := CallerContext{UserID: "u-viewer", WorkspaceID: wsID, WorkspaceRole: "viewer"}
	_, _, err = svc.ConvertWithDownstreamGating(ctx, viewerCaller, "opp-1", "idea", "Title", "", false)
	if err != ErrPermissionDenied {
		t.Fatalf("viewer role must be denied opportunity:convert, got: %v", err)
	}

	// Test C: Audit Report execution
	liveRoutes := []AccessProofResult{
		{
			Platform:            "tiktok",
			ActionKey:           "tiktok:profile:read",
			IsVerified:          true,
			CanFallbackToImport: true,
		},
	}
	auditReport := svc.AuditIntelligenceState(
		ctx,
		wsID,
		liveRoutes,
		0,    // 0 orphans
		true, // non-conflation blocked
		true, // RBAC passed
		true, // concurrency passed
		true, // alert storm batching passed
	)
	if !auditReport.Passed {
		t.Fatalf("expected audit report to pass, violations: %v", auditReport.Violations)
	}
	if !auditReport.ProvenanceIntegrityPassed || !auditReport.FinancialNonConflationPassed || !auditReport.RBACPermissionsPassed {
		t.Fatal("audit report component gates failed")
	}
}

// TestOperatingLoop_ZeroConnectorAuthorizedImportToOpportunity verifies the complete
// operating loop with 0 connected accounts: import signals & benchmarks -> cluster -> opportunity -> gated conversion.
func TestOperatingLoop_ZeroConnectorAuthorizedImportToOpportunity(t *testing.T) {
	svc := setupTestService()
	ctx := context.Background()
	caller := CallerContext{
		UserID:        "user-editor-01",
		WorkspaceID:   "ws-zero-connector",
		WorkspaceRole: "editor",
	}

	// 1. Authorized import batch with formula injection attempt
	importReq := AuthorizedImportBatchRequest{
		WorkspaceID:      caller.WorkspaceID,
		SourceProvenance: "manual_csv_import_v1",
		SignalItems: []AuthorizedSignalImportItem{
			{
				SignalType:        "keyword_spike",
				SourceSystem:      "manual_csv",
				NormalizedSummary: "=1+1 Formula injection test", // Malicious formula attempt
				Confidence:        intelligencev1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM,
				FreshnessHours:    12,
			},
			{
				SignalType:        "content_trend",
				SourceSystem:      "manual_csv",
				NormalizedSummary: "Morning skincare 3 buoc trend",
				Confidence:        intelligencev1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM,
				FreshnessHours:    6,
			},
		},
		BenchmarkItems: []AuthorizedBenchmarkImportItem{
			{
				CompetitorName:     "@SUM(1,2) Injected Competitor",
				Platform:           "tiktok",
				ExternalHandle:     "@skincare_guru",
				Category:           "beauty",
				EngagementRate:     0.065,
				FollowersCount:     120000,
				ObservedPriceRange: "150.000 - 300.000 VND",
				Confidence:         intelligencev1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM,
				BasisSummary:       "Observed public engagement data",
			},
		},
	}

	resp, err := svc.ProcessAuthorizedImportBatch(ctx, caller, importReq)
	if err != nil {
		t.Fatalf("failed to process authorized import batch: %v", err)
	}
	if resp.ImportedSignalsCount != 2 {
		t.Fatalf("expected 2 signals imported, got %d", resp.ImportedSignalsCount)
	}
	if resp.ImportedTrendsCount < 1 {
		t.Fatalf("expected at least 1 trend clustered, got %d", resp.ImportedTrendsCount)
	}
	if resp.ImportedCompetitorCount != 1 || resp.ImportedSnapshotsCount != 1 {
		t.Fatalf("expected 1 competitor and 1 snapshot, got %d / %d", resp.ImportedCompetitorCount, resp.ImportedSnapshotsCount)
	}
	if resp.SourceClass != intelligencev1.SourceClass_SOURCE_CLASS_IMPORTED {
		t.Fatalf("expected SOURCE_CLASS_IMPORTED, got %v", resp.SourceClass)
	}

	// 2. Convert clustered opportunity to Idea (M05) -> Linked draft with Phase P3 gating
	opp, gate, err := svc.ConvertWithDownstreamGating(
		ctx,
		caller,
		"opp-clustered-001",
		"idea",
		"Morning Skincare Routine for Oily Skin",
		"Based on imported CSV signal",
		false,
	)
	if err != nil {
		t.Fatalf("conversion should succeed as linked draft: %v", err)
	}
	if opp.PriorityState != intelligencev1.PriorityState_PRIORITY_STATE_CONVERTED {
		t.Fatalf("expected PRIORITY_STATE_CONVERTED, got %v", opp.PriorityState)
	}
	if gate.OwningPhase != "P3" || gate.OwningModule != "M05" {
		t.Fatalf("expected gate OwningPhase=P3 and Module=M05, got %s / %s", gate.OwningPhase, gate.OwningModule)
	}
}

// TestConcurrentIntelligenceOperationsNoRace tests concurrency safety across goroutines.
func TestConcurrentIntelligenceOperationsNoRace(t *testing.T) {
	svc := setupTestService()
	ctx := context.Background()
	wsID := "ws-concurrent-tenant"

	var wg sync.WaitGroup
	for i := 0; i < 20; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			now := time.Now().UTC()
			caller := CallerContext{
				UserID:        "user-concurrent",
				WorkspaceID:   wsID,
				WorkspaceRole: "editor",
			}

			// Validate access
			_, _ = svc.ValidateLiveSourceAccess(ctx, wsID, "tiktok", "tiktok:profile:read", now)

			// Evaluate empty & degraded
			_ = svc.EvaluateWorkspaceEmptyState(ctx, wsID, idx%3, idx%2, idx%4)
			_ = svc.EvaluateWorkspaceDegradedState(ctx, wsID, []string{"tiktok", "shopee"})

			// Policy check
			_, _ = svc.GetDownstreamGatePolicy("idea")

			// Gated conversion
			_, _, _ = svc.ConvertWithDownstreamGating(ctx, caller, fmt.Sprintf("opp-%d", idx), "idea", "Title", "", false)
		}(i)
	}
	wg.Wait()
}

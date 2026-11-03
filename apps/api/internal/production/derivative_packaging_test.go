package production

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
)

func newTestCaller(role, userID, wsID string) CallerContext {
	return CallerContext{
		WorkspaceID:   wsID,
		UserID:        userID,
		WorkspaceRole: role,
	}
}

func setupTestManagers() (*DerivativeManager, *PackagingQAManager, *MemoryStore) {
	st := NewMemoryStore()
	dm := NewDerivativeManager(st)
	pm := NewPackagingQAManager(st)
	return dm, pm, st
}

// ============================================================================
// Acceptance Target 1: 150-Item Partial Batch Results
// ============================================================================

func TestAcceptanceTarget1_150ItemPartialBatchResults(t *testing.T) {
	ctx := context.Background()
	dm, _, st := setupTestManagers()
	caller := newTestCaller("Editor", "user-ed-1", "ws-test-01")

	// Create a parent source asset
	parent := &Asset{
		AssetID:      "source-master-001",
		WorkspaceID:  "ws-test-01",
		Title:        "Original 4K Master",
		QualityState: "passed",
	}
	if err := st.CreateAsset(ctx, parent); err != nil {
		t.Fatalf("failed to create parent asset: %v", err)
	}

	// Create 147 valid derivative items
	var assetIDs []string
	for i := 1; i <= 147; i++ {
		assetID := fmt.Sprintf("asset-batch-%03d", i)
		rec := &DerivativeRecord{
			AssetID:        assetID,
			WorkspaceID:    "ws-test-01",
			ParentAssetID:  "source-master-001",
			Title:          fmt.Sprintf("Variant %d", i),
			DerivativeType: "clip",
			TargetChannel:  "tiktok",
			Tags:           []string{"initial"},
			CreatedAt:      time.Now().UTC(),
			UpdatedAt:      time.Now().UTC(),
		}
		if err := st.SaveDerivative(ctx, rec); err != nil {
			t.Fatalf("failed to seed derivative %d: %v", i, err)
		}
		assetIDs = append(assetIDs, assetID)
	}

	// Append 3 non-existent / invalid asset IDs to make exactly 150 items
	assetIDs = append(assetIDs, "invalid-asset-991", "missing-asset-992", "corrupt-asset-993")
	if len(assetIDs) != 150 {
		t.Fatalf("expected 150 items, got %d", len(assetIDs))
	}

	// Execute BatchTag with 150 items
	res, err := dm.BatchTag(ctx, caller, assetIDs, []string{"campaign-spring", "promo"}, []string{"initial"})
	if err != nil {
		t.Fatalf("BatchTag failed: %v", err)
	}

	// Verify Target 1 requirements
	if res.TotalItems != 150 {
		t.Errorf("expected TotalItems=150, got %d", res.TotalItems)
	}
	if res.SucceededCount != 147 {
		t.Errorf("expected SucceededCount=147, got %d", res.SucceededCount)
	}
	if res.FailedCount != 3 {
		t.Errorf("expected FailedCount=3, got %d", res.FailedCount)
	}
	if len(res.SucceededAssetIDs) != 147 {
		t.Errorf("expected 147 SucceededAssetIDs, got %d", len(res.SucceededAssetIDs))
	}
	if len(res.Failures) != 3 {
		t.Errorf("expected 3 Failures, got %d", len(res.Failures))
	}

	// Check summary message per spec: "147/150 succeeded. 3 failed: [view details]."
	expectedSummaryPrefix := "147/150 succeeded. 3 failed"
	if !strings.HasPrefix(res.Summary, expectedSummaryPrefix) {
		t.Errorf("expected summary to start with %q, got %q", expectedSummaryPrefix, res.Summary)
	}

	// Verify the 3 failures have NOT_FOUND or INVALID_ARGUMENT code
	for _, f := range res.Failures {
		if f.ErrorCode != "NOT_FOUND" && f.ErrorCode != "INVALID_ARGUMENT" {
			t.Errorf("expected failure code NOT_FOUND or INVALID_ARGUMENT for %s, got %s", f.AssetID, f.ErrorCode)
		}
	}

	// Verify tags were actually updated on a succeeded item
	sample, err := st.GetDerivative(ctx, "ws-test-01", "asset-batch-001")
	if err != nil {
		t.Fatalf("failed to get sample derivative: %v", err)
	}
	hasSpring := false
	hasInitial := false
	for _, tag := range sample.Tags {
		if tag == "campaign-spring" {
			hasSpring = true
		}
		if tag == "initial" {
			hasInitial = true
		}
	}
	if !hasSpring {
		t.Errorf("expected tag 'campaign-spring' to be added")
	}
	if hasInitial {
		t.Errorf("expected tag 'initial' to be removed")
	}
}

// ============================================================================
// Acceptance Target 2: No Lineage -> Routing Denied
// ============================================================================

func TestAcceptanceTarget2_NoLineageRoutingDenied(t *testing.T) {
	ctx := context.Background()
	dm, _, st := setupTestManagers()
	caller := newTestCaller("Editor", "user-ed-1", "ws-test-01")

	// 1. Asset with NO lineage (ParentAssetID is empty)
	orphanAsset := &DerivativeRecord{
		AssetID:        "orphan-asset-001",
		WorkspaceID:    "ws-test-01",
		ParentAssetID:  "", // NO LINEAGE
		Title:          "Orphan Asset Without Parent",
		DerivativeType: "clip",
		TargetChannel:  "tiktok",
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	if err := st.SaveDerivative(ctx, orphanAsset); err != nil {
		t.Fatalf("failed to create orphan asset: %v", err)
	}

	// Attempt to route orphan asset to packaging -> MUST BE DENIED
	err := dm.RouteToPackaging(ctx, caller, "orphan-asset-001")
	if err == nil {
		t.Fatalf("expected RouteToPackaging to fail for orphan asset, but it succeeded")
	}
	if !errors.Is(err, ErrMissingLineage) {
		t.Errorf("expected ErrMissingLineage, got %v", err)
	}
	if !strings.Contains(strings.ToLower(err.Error()), "missing source lineage") {
		t.Errorf("expected message containing 'Missing source lineage', got %q", err.Error())
	}

	// 2. Asset WITH valid lineage (ParentAssetID is set to existing source)
	sourceAsset := &Asset{
		AssetID:      "parent-source-002",
		WorkspaceID:  "ws-test-01",
		Title:        "Valid Source Master",
		QualityState: "passed",
	}
	if err := st.CreateAsset(ctx, sourceAsset); err != nil {
		t.Fatalf("failed to create source asset: %v", err)
	}

	validDerivative := &DerivativeRecord{
		AssetID:        "valid-derivative-002",
		WorkspaceID:    "ws-test-01",
		ParentAssetID:  "parent-source-002",
		Title:          "Valid Derivative Clip",
		DerivativeType: "clip",
		TargetChannel:  "tiktok",
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	if err := st.SaveDerivative(ctx, validDerivative); err != nil {
		t.Fatalf("failed to create derivative: %v", err)
	}

	// Routing with lineage -> MUST SUCCEED
	err = dm.RouteToPackaging(ctx, caller, "valid-derivative-002")
	if err != nil {
		t.Fatalf("expected RouteToPackaging to succeed with lineage, got: %v", err)
	}

	// 3. Lineage inspection test: GetLineage confirms hasLineage=false for orphan
	_, _, hasLineage, err := dm.GetLineage(ctx, caller, "orphan-asset-001")
	if err != nil {
		t.Fatalf("GetLineage failed: %v", err)
	}
	if hasLineage {
		t.Errorf("expected hasLineage=false for orphan asset")
	}
}

// ============================================================================
// Acceptance Target 3: Hard Blocks Cannot Be Workspace-Overridden
// ============================================================================

func TestAcceptanceTarget3_HardBlocksCannotBeWorkspaceOverridden(t *testing.T) {
	ctx := context.Background()
	_, pm, st := setupTestManagers()

	editorCaller := newTestCaller("Editor", "user-ed-1", "ws-test-01")
	managerCaller := newTestCaller("Manager", "user-mgr-1", "ws-test-01")
	ownerCaller := newTestCaller("Owner", "user-owner-1", "ws-test-01")

	// Case 1: Commercial content without disclosure -> Hard Block
	reportCommercial, err := pm.Score(
		ctx,
		editorCaller,
		"commercial-asset-001",
		"pub-comm-001",
		"tiktok",
		"Huge Sale Promotion",
		"Buy now at 50% off",
		[]string{"sale", "deals"},
		"Shop Now",
		"",   // MISSING DISCLOSURE on commercial content
		"",   // audio track
		"",   // preset
		true, // isCommercial = true
	)
	if err != nil {
		t.Fatalf("Score failed: %v", err)
	}

	// Verify hard block was triggered
	if !reportCommercial.HasHardBlocks {
		t.Fatalf("expected HasHardBlocks=true for commercial content without disclosure")
	}
	if reportCommercial.ReadyForPackaging {
		t.Errorf("expected ReadyForPackaging=false when hard blocked")
	}
	if reportCommercial.ReadyToPublish {
		t.Errorf("expected ReadyToPublish=false when hard blocked")
	}

	// Verify disclosure component is marked as hard blocked and can_override=false
	var disclosureComponent *PackagingScoreComponent
	for _, c := range reportCommercial.Components {
		if c.ComponentName == "disclosure" {
			disclosureComponent = c
			break
		}
	}
	if disclosureComponent == nil {
		t.Fatalf("disclosure component not found in report")
	}
	if !disclosureComponent.IsHardBlocked {
		t.Errorf("expected disclosure component IsHardBlocked=true")
	}
	if disclosureComponent.CanOverride {
		t.Errorf("expected disclosure component CanOverride=false")
	}

	// Attempt override by Editor -> ErrPermissionDenied
	_, err = pm.OverrideResult(ctx, editorCaller, "commercial-asset-001", "pub-comm-001", "disclosure", "Overriding by editor test")
	if !errors.Is(err, ErrPermissionDenied) {
		t.Errorf("expected ErrPermissionDenied for Editor role, got %v", err)
	}

	// Attempt override by Manager -> MUST BE DENIED with ErrHardBlockCannotBeOverridden
	_, err = pm.OverrideResult(ctx, managerCaller, "commercial-asset-001", "pub-comm-001", "disclosure", "Legitimate business need to proceed without disclosure")
	if err == nil {
		t.Fatalf("expected override on hard block to fail, but it succeeded")
	}
	if !errors.Is(err, ErrHardBlockCannotBeOverridden) {
		t.Errorf("expected ErrHardBlockCannotBeOverridden, got %v", err)
	}

	// Attempt override by Owner -> STILL MUST BE DENIED (workspace users CANNOT override hard blocks)
	_, err = pm.OverrideResult(ctx, ownerCaller, "commercial-asset-001", "pub-comm-001", "disclosure", "Owner override attempt with long reason")
	if !errors.Is(err, ErrHardBlockCannotBeOverridden) {
		t.Errorf("expected ErrHardBlockCannotBeOverridden even for Owner, got %v", err)
	}

	// Case 2: Confirmed copyright violation -> Hard Block
	confirmedViolationAsset := &Asset{
		AssetID:      "copyright-infringing-asset",
		WorkspaceID:  "ws-test-01",
		Title:        "Pirated Music Video",
		QualityState: "passed",
	}
	if err := st.CreateAsset(ctx, confirmedViolationAsset); err != nil {
		t.Fatalf("failed to seed asset: %v", err)
	}

	reportCopyright, err := pm.Score(
		ctx,
		editorCaller,
		"copyright-infringing-asset",
		"pub-cpy-001",
		"tiktok",
		"Best Song Ever",
		"Check out this song",
		[]string{"music"},
		"",
		"",
		"",
		"",
		false,
	)
	if err != nil {
		t.Fatalf("Score failed: %v", err)
	}

	// Mark copyright finding as hard blocked
	for _, c := range reportCopyright.ComplianceDetails {
		if c.Category == "copyright" {
			c.IsHardBlocked = true
			c.CanOverride = false
		}
	}
	reportCopyright.HasHardBlocks = true
	_ = st.SaveQAResult(ctx, reportCopyright)

	// Attempt override by Manager -> MUST BE DENIED
	_, err = pm.OverrideResult(ctx, managerCaller, "copyright-infringing-asset", "pub-cpy-001", "copyright", "We own fair use rights under DMCA safe harbor")
	if !errors.Is(err, ErrHardBlockCannotBeOverridden) {
		t.Errorf("expected ErrHardBlockCannotBeOverridden for copyright violation, got %v", err)
	}

	// Case 3: Reviewable warning (NOT hard blocked) CAN be overridden with Manager role and reason >= 10 chars
	// Short caption produces a warning, not a hard block
	reportWarning, err := pm.Score(
		ctx,
		editorCaller,
		"warning-asset-001",
		"pub-warn-001",
		"tiktok",
		"Great Short Video Hook",
		"Short", // short caption produces warning
		[]string{"fun", "daily"},
		"Follow us",
		"#ad", // disclosure present
		"",
		"",
		true,
	)
	if err != nil {
		t.Fatalf("Score failed: %v", err)
	}

	// Verify no hard blocks
	if reportWarning.HasHardBlocks {
		t.Fatalf("expected HasHardBlocks=false for short caption warning")
	}

	// Attempt override with reason < 10 characters -> ErrOverrideReasonTooShort
	_, err = pm.OverrideResult(ctx, managerCaller, "warning-asset-001", "pub-warn-001", "caption", "too short")
	if !errors.Is(err, ErrOverrideReasonTooShort) {
		t.Errorf("expected ErrOverrideReasonTooShort, got %v", err)
	}

	// Override with valid reason (>= 10 chars) by Manager -> MUST SUCCEED
	validReason := "Client specifically requested a minimalist caption for aesthetic branding"
	updatedReport, err := pm.OverrideResult(ctx, managerCaller, "warning-asset-001", "pub-warn-001", "caption", validReason)
	if err != nil {
		t.Fatalf("expected override to succeed, got: %v", err)
	}

	// Verify audit record was created
	if len(updatedReport.AppliedOverrides) != 1 {
		t.Fatalf("expected 1 audit record, got %d", len(updatedReport.AppliedOverrides))
	}
	audit := updatedReport.AppliedOverrides[0]
	if audit.ActorRole != "Manager" {
		t.Errorf("expected ActorRole=Manager, got %s", audit.ActorRole)
	}
	if audit.Reason != validReason {
		t.Errorf("expected audit reason %q, got %q", validReason, audit.Reason)
	}
}

// ============================================================================
// Lineage Tree & Source Deletion (EC-M09-001)
// ============================================================================

func TestLineageTreeInspectionAndSourceDeletion(t *testing.T) {
	ctx := context.Background()
	dm, _, st := setupTestManagers()
	caller := newTestCaller("Member", "user-mem-1", "ws-test-01")

	// Create root source
	root := &DerivativeRecord{
		AssetID:        "source-root-01",
		WorkspaceID:    "ws-test-01",
		Title:          "Main Master Recording",
		DerivativeType: "master",
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	if err := st.SaveDerivative(ctx, root); err != nil {
		t.Fatalf("failed to create root: %v", err)
	}

	// Create child
	child := &DerivativeRecord{
		AssetID:        "child-clip-01",
		WorkspaceID:    "ws-test-01",
		ParentAssetID:  "source-root-01",
		Title:          "Highlight Clip 1",
		DerivativeType: "clip",
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	if err := st.SaveDerivative(ctx, child); err != nil {
		t.Fatalf("failed to create child: %v", err)
	}

	// Create grandchild
	grandchild := &DerivativeRecord{
		AssetID:        "grandchild-variant-01",
		WorkspaceID:    "ws-test-01",
		ParentAssetID:  "child-clip-01",
		Title:          "9:16 Aspect Variant",
		DerivativeType: "variant",
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	if err := st.SaveDerivative(ctx, grandchild); err != nil {
		t.Fatalf("failed to create grandchild: %v", err)
	}

	// Inspect lineage from grandchild
	rootNode, chain, hasLineage, err := dm.GetLineage(ctx, caller, "grandchild-variant-01")
	if err != nil {
		t.Fatalf("GetLineage failed: %v", err)
	}
	if !hasLineage {
		t.Fatalf("expected hasLineage=true")
	}
	if rootNode == nil || rootNode.AssetID != "source-root-01" {
		t.Errorf("expected rootNode asset_id=source-root-01, got %v", rootNode)
	}
	if len(chain) != 3 {
		t.Errorf("expected chain depth 3, got %d", len(chain))
	}
	if rootNode.IsSourceDeleted {
		t.Errorf("expected IsSourceDeleted=false when root is active")
	}

	// Soft-delete the root source asset (EC-M09-001)
	managerCaller := newTestCaller("Manager", "user-mgr-1", "ws-test-01")
	if err := dm.Delete(ctx, managerCaller, "source-root-01"); err != nil {
		t.Fatalf("Delete failed: %v", err)
	}

	// Re-inspect lineage from child -> verify IsSourceDeleted is now true
	rootNodeAfterDelete, _, _, err := dm.GetLineage(ctx, caller, "child-clip-01")
	if err != nil {
		t.Fatalf("GetLineage after delete failed: %v", err)
	}
	if !rootNodeAfterDelete.IsSourceDeleted {
		t.Errorf("expected IsSourceDeleted=true after parent source deletion")
	}
}

// ============================================================================
// Derivative Performance Stats Aggregation (RULE-M09-003)
// ============================================================================

func TestDerivativePerformanceStatsAggregation(t *testing.T) {
	ctx := context.Background()
	dm, _, st := setupTestManagers()
	caller := newTestCaller("Member", "user-mem-1", "ws-test-01")

	sourceID := "source-perf-001"

	// Create 3 derivatives with different views and CTR
	d1 := &DerivativeRecord{
		AssetID:        "deriv-perf-1",
		WorkspaceID:    "ws-test-01",
		ParentAssetID:  sourceID,
		Title:          "Variant A",
		DerivativeType: "clip",
		Views:          10000,
		CTR:            0.05,
		EngagementRate: 0.08,
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	d2 := &DerivativeRecord{
		AssetID:        "deriv-perf-2",
		WorkspaceID:    "ws-test-01",
		ParentAssetID:  sourceID,
		Title:          "Variant B",
		DerivativeType: "clip",
		Views:          25000,
		CTR:            0.12, // Top CTR
		EngagementRate: 0.15,
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	d3 := &DerivativeRecord{
		AssetID:        "deriv-perf-3",
		WorkspaceID:    "ws-test-01",
		ParentAssetID:  sourceID,
		Title:          "Variant C",
		DerivativeType: "clip",
		Views:          15000,
		CTR:            0.07,
		EngagementRate: 0.10,
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}

	for _, d := range []*DerivativeRecord{d1, d2, d3} {
		if err := st.SaveDerivative(ctx, d); err != nil {
			t.Fatalf("failed to seed derivative: %v", err)
		}
	}

	stats, err := dm.GetStats(ctx, caller, sourceID)
	if err != nil {
		t.Fatalf("GetStats failed: %v", err)
	}

	if stats.TotalDerivatives != 3 {
		t.Errorf("expected TotalDerivatives=3, got %d", stats.TotalDerivatives)
	}
	if stats.AggregateViews != 50000 {
		t.Errorf("expected AggregateViews=50000, got %d", stats.AggregateViews)
	}
	// Average CTR = (0.05 + 0.12 + 0.07) / 3 = 0.08
	expectedAvgCTR := 0.08
	if fmt.Sprintf("%.2f", stats.AverageCTR) != fmt.Sprintf("%.2f", expectedAvgCTR) {
		t.Errorf("expected AvgCTR=0.08, got %.4f", stats.AverageCTR)
	}
	// Top variant should be deriv-perf-2
	if stats.TopPerformingDerivativeID != "deriv-perf-2" {
		t.Errorf("expected TopPerformingDerivativeID=deriv-perf-2, got %s", stats.TopPerformingDerivativeID)
	}
}

// ============================================================================
// A/B Experiment Inconclusive Under 1,000 Impressions (RULE-M10-006)
// ============================================================================

func TestABExperimentInconclusiveUnderEvidenceThreshold(t *testing.T) {
	ctx := context.Background()
	_, pm, st := setupTestManagers()
	caller := newTestCaller("Editor", "user-ed-1", "ws-test-01")

	// Case 1: Under 1000 impressions -> Inconclusive
	dLowA := &DerivativeRecord{
		AssetID:        "deriv-low-a",
		WorkspaceID:    "ws-test-01",
		Title:          "Low Variant A",
		Views:          400,
		CTR:            0.05,
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	dLowB := &DerivativeRecord{
		AssetID:        "deriv-low-b",
		WorkspaceID:    "ws-test-01",
		Title:          "Low Variant B",
		Views:          450,
		CTR:            0.08,
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	_ = st.SaveDerivative(ctx, dLowA)
	_ = st.SaveDerivative(ctx, dLowB)

	lowImpressionExp := &ABExperimentRecord{
		ExperimentID:                  "exp-low-001",
		WorkspaceID:                   "ws-test-01",
		SourceAssetID:                 "asset-ab-001",
		VariantAssetIDs:               []string{"deriv-low-a", "deriv-low-b"},
		VariantCount:                  2,
		MinImpressionsPerVariant:      1000,
		AutoWinnerThresholdMultiplier: 1.2,
		Status:                        "running",
		CreatedAt:                     time.Now().UTC(),
		UpdatedAt:                     time.Now().UTC(),
	}
	if err := st.SaveExperiment(ctx, lowImpressionExp); err != nil {
		t.Fatalf("failed to seed experiment: %v", err)
	}

	resLow, err := pm.EvaluateABExperiment(ctx, caller, "exp-low-001")
	if err != nil {
		t.Fatalf("EvaluateABExperiment failed: %v", err)
	}
	if resLow.ResultStatus != "inconclusive" {
		t.Errorf("expected result_status=inconclusive for <1000 impressions, got %s", resLow.ResultStatus)
	}
	if resLow.WinnerAssetID != "" {
		t.Errorf("expected empty winner asset id for inconclusive test, got %s", resLow.WinnerAssetID)
	}

	// Case 2: Over 1000 impressions with clear statistical lift -> Conclusive winner
	dHighA := &DerivativeRecord{
		AssetID:        "deriv-high-a",
		WorkspaceID:    "ws-test-01",
		Title:          "High Variant A",
		Views:          2000,
		CTR:            0.05,
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	dHighB := &DerivativeRecord{
		AssetID:        "deriv-high-b",
		WorkspaceID:    "ws-test-01",
		Title:          "High Variant B",
		Views:          2200,
		CTR:            0.10, // 100% lift
		CreatedAt:      time.Now().UTC(),
		UpdatedAt:      time.Now().UTC(),
	}
	_ = st.SaveDerivative(ctx, dHighA)
	_ = st.SaveDerivative(ctx, dHighB)

	highImpressionExp := &ABExperimentRecord{
		ExperimentID:                  "exp-high-002",
		WorkspaceID:                   "ws-test-01",
		SourceAssetID:                 "asset-ab-002",
		VariantAssetIDs:               []string{"deriv-high-a", "deriv-high-b"},
		VariantCount:                  2,
		MinImpressionsPerVariant:      1000,
		AutoWinnerThresholdMultiplier: 1.2,
		Status:                        "running",
		CreatedAt:                     time.Now().UTC(),
		UpdatedAt:                     time.Now().UTC(),
	}
	if err := st.SaveExperiment(ctx, highImpressionExp); err != nil {
		t.Fatalf("failed to seed high impression experiment: %v", err)
	}

	resHigh, err := pm.EvaluateABExperiment(ctx, caller, "exp-high-002")
	if err != nil {
		t.Fatalf("EvaluateABExperiment high failed: %v", err)
	}
	if resHigh.ResultStatus != "conclusive" {
		t.Errorf("expected result_status=conclusive for >1000 impressions with lift, got %s", resHigh.ResultStatus)
	}
	if resHigh.WinnerAssetID != "deriv-high-b" {
		t.Errorf("expected WinnerAssetID=deriv-high-b, got %s", resHigh.WinnerAssetID)
	}
}

// ============================================================================
// ConnectRPC Service Server Tests
// ============================================================================

func TestConnectRPC_DerivativeAndPackagingHandlers(t *testing.T) {
	ctx := context.Background()
	svc := NewService(ServiceConfig{})

	// Add caller context to ctx
	ctx = context.WithValue(ctx, "caller_role", "Editor")
	ctx = context.WithValue(ctx, "caller_user_id", "user-rpc-01")

	// Seed source parent asset
	_ = svc.store.CreateAsset(ctx, &Asset{
		AssetID:      "source-master-999",
		WorkspaceID:  "ws-rpc-01",
		Title:        "Master RPC Video",
		QualityState: "passed",
	})

	cmdCtx := &commonv1.CommandContext{
		WorkspaceId: &commonv1.UUID{Value: "ws-rpc-01"},
	}

	// 1. Create a derivative via ConnectRPC
	createReq := connect.NewRequest(&productionv1.DerivativeServiceCreateRequest{
		Context:        cmdCtx,
		ParentAssetId:  "source-master-999",
		DerivativeType: "clip",
		TargetChannel:  "youtube_shorts",
		Title:          "RPC Test Clip",
		Tags:           []string{"rpc", "test"},
	})
	createResp, err := svc.Derivative().Create(ctx, createReq)
	if err != nil {
		t.Fatalf("RPC Derivative.Create failed: %v", err)
	}
	if createResp.Msg.Derivative.Title != "RPC Test Clip" {
		t.Errorf("expected Title='RPC Test Clip', got %s", createResp.Msg.Derivative.Title)
	}
	assetID := createResp.Msg.Derivative.AssetId

	// 2. Score via ConnectRPC
	scoreReq := connect.NewRequest(&productionv1.PackagingServiceScoreRequest{
		Context:        cmdCtx,
		AssetId:        assetID,
		PublishItemId:  "pub-rpc-001",
		TargetPlatform: "youtube_shorts",
		Title:          "YouTube Shorts Quality Title",
		Caption:        "Detailed description of YouTube video with enough characters to pass QA.",
		Hashtags:       []string{"shorts", "trending"},
		Cta:            "Subscribe for more",
		Disclosure:     "#ad",
	})
	scoreResp, err := svc.Packaging().Score(ctx, scoreReq)
	if err != nil {
		t.Fatalf("RPC Packaging.Score failed: %v", err)
	}
	if scoreResp.Msg.Report.OverallPackagingScore <= 0 {
		t.Errorf("expected positive score, got %.2f", scoreResp.Msg.Report.OverallPackagingScore)
	}
	if scoreResp.Msg.Report.HasHardBlocks {
		t.Errorf("expected no hard blocks for valid input")
	}
}

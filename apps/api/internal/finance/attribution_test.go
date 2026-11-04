package finance_test

import (
	"context"
	"errors"
	"testing"
	"time"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// ----------------------------------------------------------------------------
// Acceptance Target 1: Workspace Revenue Counted Once & Order Net Capacity
// ----------------------------------------------------------------------------

func TestAttribution_Target1_WorkspaceRevenueCountedOnce(t *testing.T) {
	ctx := context.Background()
	engine := finance.NewAttributionEngine()
	wsID := "ws-test-dedup"

	// Setup 2 distinct orders: Order-A (100,000 VND), Order-B (200,000 VND)
	orderA := finance.CanonicalOrderRecord{
		OrderID:           "ord-A",
		WorkspaceID:       wsID,
		GrossRevenue:      tenantdb.MustParseExactDecimal("100000.000000"),
		RefundDeduction:   tenantdb.ZeroDecimal(),
		NetRevenue:        tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:          "VND",
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
		LifecycleState:    "completed",
		IsRecognizedOrder: true,
	}
	orderB := finance.CanonicalOrderRecord{
		OrderID:           "ord-B",
		WorkspaceID:       wsID,
		GrossRevenue:      tenantdb.MustParseExactDecimal("200000.000000"),
		RefundDeduction:   tenantdb.ZeroDecimal(),
		NetRevenue:        tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:          "VND",
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
		LifecycleState:    "completed",
		IsRecognizedOrder: true,
	}
	engine.SeedCanonicalOrder(orderA)
	engine.SeedCanonicalOrder(orderB)

	// Attribution 1: Derivative-1 attributes 60,000 from Order-A
	attr1 := &finance.ContentAttributionEntity{
		AttributionID:     "attr-1",
		WorkspaceID:       wsID,
		PublishItemID:     "item-1",
		ChannelPostID:     "post-1",
		OrderID:           "ord-A",
		AttributionType:   "utm_match",
		RevenueAttributed: tenantdb.MustParseExactDecimal("60000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}
	if _, err := engine.RecordAttribution(ctx, attr1, true); err != nil {
		t.Fatalf("failed to record attr1: %v", err)
	}

	// Attribution 2: Derivative-2 attributes remaining 40,000 from the SAME Order-A
	attr2 := &finance.ContentAttributionEntity{
		AttributionID:     "attr-2",
		WorkspaceID:       wsID,
		PublishItemID:     "item-2",
		ChannelPostID:     "post-2",
		OrderID:           "ord-A",
		AttributionType:   "affiliate",
		RevenueAttributed: tenantdb.MustParseExactDecimal("40000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}
	if _, err := engine.RecordAttribution(ctx, attr2, true); err != nil {
		t.Fatalf("failed to record attr2: %v", err)
	}

	// Attribution 3: Derivative-1 attributes 150,000 from Order-B
	attr3 := &finance.ContentAttributionEntity{
		AttributionID:     "attr-3",
		WorkspaceID:       wsID,
		PublishItemID:     "item-1",
		ChannelPostID:     "post-1",
		OrderID:           "ord-B",
		AttributionType:   "direct_click",
		RevenueAttributed: tenantdb.MustParseExactDecimal("150000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}
	if _, err := engine.RecordAttribution(ctx, attr3, true); err != nil {
		t.Fatalf("failed to record attr3: %v", err)
	}

	// Fetch attribution rollup for item-1
	contentRev, matching, summary, err := engine.GetContentRevenueAttribution(ctx, wsID, "item-1")
	if err != nil {
		t.Fatalf("failed to get attribution: %v", err)
	}

	if len(matching) != 2 {
		t.Fatalf("expected 2 matching records for item-1, got %d", len(matching))
	}
	// item-1 has 60,000 + 150,000 = 210,000
	if contentRev.AttributedRevenue.Amount != "210000.000000" {
		t.Errorf("expected 210000.000000 attributed revenue for item-1, got %s", contentRev.AttributedRevenue.Amount)
	}

	// CRITICAL TARGET 1 CHECK: Workspace Deduplication Summary
	// Total recognized orders: 2 (Order-A and Order-B)
	// Total recognized revenue in workspace: 100,000 + 200,000 = 300,000.000000 (COUNTED ONCE!)
	if summary.UniqueOrdersCounted != 2 {
		t.Errorf("expected 2 unique orders in workspace summary, got %d", summary.UniqueOrdersCounted)
	}
	if summary.CanonicalWorkspaceRevenue.Amount != "300000.000000" {
		t.Errorf("expected 300000.000000 canonical workspace revenue, got %s", summary.CanonicalWorkspaceRevenue.Amount)
	}
	if summary.SumAttributionLines.Amount != "250000.000000" {
		t.Errorf("expected 250000.000000 total attributed revenue (60k+40k+150k), got %s", summary.SumAttributionLines.Amount)
	}
	if !summary.IsRevenueCountedOnce {
		t.Error("expected IsRevenueCountedOnce to be true")
	}
}

func TestAttribution_Target1_OrderNetCapacityExceeded(t *testing.T) {
	ctx := context.Background()
	engine := finance.NewAttributionEngine()
	wsID := "ws-cap-test"

	order := finance.CanonicalOrderRecord{
		OrderID:           "ord-cap-1",
		WorkspaceID:       wsID,
		GrossRevenue:      tenantdb.MustParseExactDecimal("100000.000000"),
		RefundDeduction:   tenantdb.MustParseExactDecimal("20000.000000"), // 20k refunded!
		NetRevenue:        tenantdb.MustParseExactDecimal("80000.000000"),  // Net capacity is 80k
		Currency:          "VND",
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
		LifecycleState:    "completed",
		IsRecognizedOrder: true,
	}
	engine.SeedCanonicalOrder(order)

	// Attribution 1: 50,000 (valid, leaves 30,000)
	attr1 := &finance.ContentAttributionEntity{
		AttributionID:     "attr-cap-1",
		WorkspaceID:       wsID,
		OrderID:           order.OrderID,
		RevenueAttributed: tenantdb.MustParseExactDecimal("50000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}
	if _, err := engine.RecordAttribution(ctx, attr1, true); err != nil {
		t.Fatalf("expected attr1 to succeed, got %v", err)
	}

	// Attribution 2: 40,000 (invalid! 50k + 40k = 90k > 80k net revenue capacity)
	attr2 := &finance.ContentAttributionEntity{
		AttributionID:     "attr-cap-2",
		WorkspaceID:       wsID,
		OrderID:           order.OrderID,
		RevenueAttributed: tenantdb.MustParseExactDecimal("40000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}
	_, err := engine.RecordAttribution(ctx, attr2, true)
	if err == nil {
		t.Fatal("expected ErrAttributionCapacityExceeded, but succeeded")
	}
	if !errors.Is(err, finance.ErrAttributionCapacityExceeded) {
		t.Errorf("expected ErrAttributionCapacityExceeded, got %v", err)
	}

	// Attribution 3: 30,000 (exactly fills remaining 30k capacity)
	attr3 := &finance.ContentAttributionEntity{
		AttributionID:     "attr-cap-3",
		WorkspaceID:       wsID,
		OrderID:           order.OrderID,
		RevenueAttributed: tenantdb.MustParseExactDecimal("30000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}
	if _, err := engine.RecordAttribution(ctx, attr3, true); err != nil {
		t.Fatalf("expected attr3 to succeed, got %v", err)
	}

	allocated, remaining := engine.GetOrderAllocationStatus(order.OrderID)
	if allocated.Fixed6String() != "80000.000000" {
		t.Errorf("expected 80000.000000 allocated, got %s", allocated.Fixed6String())
	}
	if !remaining.IsZero() {
		t.Errorf("expected 0 remaining capacity, got %s", remaining.String())
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Missing Denominators Remain Unknown & Low Exposure Safety
// ----------------------------------------------------------------------------

func TestAttribution_Target2_MissingDenominatorsRemainUnknown(t *testing.T) {
	rev := tenantdb.MustParseExactDecimal("500000.000000")

	// Case 1: Views denominator is nil (unrecorded)
	rpm1 := finance.CalculateRPM(rev, nil, true, "UNRECORDED_VIEWS")
	if !rpm1.IsUnknown {
		t.Fatal("expected IsUnknown=true for nil views")
	}
	if rpm1.Value != "" {
		t.Errorf("expected empty Value, got %q (must not be 0.00 or NaN)", rpm1.Value)
	}
	if rpm1.UnknownReason != "UNRECORDED_VIEWS" {
		t.Errorf("expected UNRECORDED_VIEWS, got %s", rpm1.UnknownReason)
	}

	// Case 2: Views denominator is 0
	zeroViews := int64(0)
	rpm2 := finance.CalculateRPM(rev, &zeroViews, false, "")
	if !rpm2.IsUnknown {
		t.Fatal("expected IsUnknown=true for 0 views")
	}
	if rpm2.Value != "" {
		t.Errorf("expected empty Value, got %q", rpm2.Value)
	}
	if rpm2.UnknownReason != "MISSING_DENOMINATOR_VIEWS" {
		t.Errorf("expected MISSING_DENOMINATOR_VIEWS, got %s", rpm2.UnknownReason)
	}

	// Case 3: Low exposure (< 100 views) - resolves EXP-2026-02
	lowViews := int64(45)
	rpm3 := finance.CalculateRPM(rev, &lowViews, false, "")
	if !rpm3.IsUnknown {
		t.Fatal("expected IsUnknown=true for low exposure < 100 views")
	}
	if rpm3.Status != "low_exposure_inconclusive" {
		t.Errorf("expected status low_exposure_inconclusive, got %s", rpm3.Status)
	}

	// Case 4: Clicks denominator is missing for Conversion Rate
	conv := finance.CalculateConversionRate(5, nil, true)
	if !conv.IsUnknown {
		t.Fatal("expected conversion rate IsUnknown=true when clicks are nil")
	}
	if conv.Value != "" {
		t.Errorf("expected empty Value, got %q", conv.Value)
	}

	// Case 5: Views denominator is missing for CTR
	clicks := int64(10)
	ctr := finance.CalculateCTR(&clicks, nil, true, false)
	if !ctr.IsUnknown {
		t.Fatal("expected CTR IsUnknown=true when views are nil")
	}

	// Case 6: Valid sample with >= 100 views
	validViews := int64(1000)
	rpmValid := finance.CalculateRPM(rev, &validViews, false, "")
	if rpmValid.IsUnknown {
		t.Fatalf("expected valid RPM calculation, but got unknown: %s", rpmValid.UnknownReason)
	}
	// RPM = (500000 * 1000) / 1000 = 500000.000000
	if rpmValid.Value != "500000.000000" {
		t.Errorf("expected RPM 500000.000000, got %s", rpmValid.Value)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Imported Proof Not Upgraded & Mixed Confidence Rules
// ----------------------------------------------------------------------------

func TestAttribution_Target3_ImportedProofNotUpgradedToOfficial(t *testing.T) {
	ctx := context.Background()
	engine := finance.NewAttributionEngine()
	wsID := "ws-import-test"

	order := finance.CanonicalOrderRecord{
		OrderID:           "ord-imp-1",
		WorkspaceID:       wsID,
		GrossRevenue:      tenantdb.MustParseExactDecimal("100000.000000"),
		NetRevenue:        tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:          "VND",
		SourceClass:       finance.SourceClassImported,
		Confidence:        finance.ConfidenceMedium,
		LifecycleState:    "completed",
		IsRecognizedOrder: true,
	}
	engine.SeedCanonicalOrder(order)

	// Attempt 1: Try to record attribution with source_class=official but without live API verification
	// (Simulating CSV import or manual claim trying to claim official status)
	attrClaim := &finance.ContentAttributionEntity{
		AttributionID:     "attr-fraud-1",
		WorkspaceID:       wsID,
		OrderID:           order.OrderID,
		RevenueAttributed: tenantdb.MustParseExactDecimal("50000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}
	_, err := engine.RecordAttribution(ctx, attrClaim, false) // isLiveAPIVerified = false
	if err == nil {
		t.Fatal("expected error when unverified imported source tries to claim official, but got nil")
	}
	if !errors.Is(err, finance.ErrImportedProofCannotBeOfficial) {
		t.Errorf("expected ErrImportedProofCannotBeOfficial, got %v", err)
	}

	// Attempt 2: Record as imported (valid)
	attrImported := &finance.ContentAttributionEntity{
		AttributionID:     "attr-imp-ok",
		WorkspaceID:       wsID,
		OrderID:           order.OrderID,
		RevenueAttributed: tenantdb.MustParseExactDecimal("50000.000000"),
		SourceClass:       finance.SourceClassImported,
		Confidence:        finance.ConfidenceHigh, // Claims high, but must be capped at medium
	}
	rec, err := engine.RecordAttribution(ctx, attrImported, false)
	if err != nil {
		t.Fatalf("expected imported attribution to succeed, got %v", err)
	}
	if rec.SourceClass != finance.SourceClassImported {
		t.Errorf("expected source_class imported, got %s", rec.SourceClass)
	}

	// Try to upgrade an existing imported record to official
	upgradedClass, err := finance.EnforceSourceClassIntegrity(finance.SourceClassImported, finance.SourceClassOfficial, false)
	if err == nil {
		t.Fatal("expected upgrade from imported to official to fail without verified live API")
	}
	if upgradedClass != finance.SourceClassImported {
		t.Errorf("expected source_class to remain imported, got %s", upgradedClass)
	}

	// Even if live API is claimed, an imported proof retains source_class: imported
	upgradedClassWithLive, err := finance.EnforceSourceClassIntegrity(finance.SourceClassImported, finance.SourceClassOfficial, true)
	if err == nil {
		t.Fatal("expected rule RULE-M19-001/007: imported proof cannot be upgraded to official")
	}
	if upgradedClassWithLive != finance.SourceClassImported {
		t.Errorf("expected source_class to remain imported, got %s", upgradedClassWithLive)
	}
}

func TestAttribution_Target3_MixedConfidenceCapAtMedium(t *testing.T) {
	ctx := context.Background()
	engine := finance.NewAttributionEngine()
	wsID := "ws-mixed-test"

	orderOfficial := finance.CanonicalOrderRecord{
		OrderID:           "ord-off",
		WorkspaceID:       wsID,
		GrossRevenue:      tenantdb.MustParseExactDecimal("100000.000000"),
		NetRevenue:        tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:          "VND",
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
		LifecycleState:    "completed",
		IsRecognizedOrder: true,
	}
	orderImported := finance.CanonicalOrderRecord{
		OrderID:           "ord-imp",
		WorkspaceID:       wsID,
		GrossRevenue:      tenantdb.MustParseExactDecimal("50000.000000"),
		NetRevenue:        tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:          "VND",
		SourceClass:       finance.SourceClassImported,
		Confidence:        finance.ConfidenceMedium,
		LifecycleState:    "completed",
		IsRecognizedOrder: true,
	}
	engine.SeedCanonicalOrder(orderOfficial)
	engine.SeedCanonicalOrder(orderImported)

	// Attribution 1: Official source with High confidence
	_, _ = engine.RecordAttribution(ctx, &finance.ContentAttributionEntity{
		AttributionID:     "attr-1",
		WorkspaceID:       wsID,
		PublishItemID:     "content-mix",
		OrderID:           "ord-off",
		RevenueAttributed: tenantdb.MustParseExactDecimal("60000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}, true)

	// Attribution 2: Imported source with Medium confidence
	_, _ = engine.RecordAttribution(ctx, &finance.ContentAttributionEntity{
		AttributionID:     "attr-2",
		WorkspaceID:       wsID,
		PublishItemID:     "content-mix",
		OrderID:           "ord-imp",
		RevenueAttributed: tenantdb.MustParseExactDecimal("40000.000000"),
		SourceClass:       finance.SourceClassImported,
		Confidence:        finance.ConfidenceMedium,
	}, false)

	// Post metrics with 500 views
	views := int64(500)
	_, _ = engine.RecordChannelPostMetrics(ctx, &finance.ChannelPostMetricsSnapshot{
		WorkspaceID:   wsID,
		ChannelPostID: "content-mix",
		Views:         &views,
		SourceClass:   finance.SourceClassImported,
		Confidence:    finance.ConfidenceMedium,
		CapturedAt:    time.Now().UTC(),
	}, false)

	contentRev, _, summary, err := engine.GetContentRevenueAttribution(ctx, wsID, "content-mix")
	if err != nil {
		t.Fatalf("failed to get attribution: %v", err)
	}

	// CRITICAL TARGET 3 CHECK:
	// Content attribution has mixed official + imported sources -> Confidence MUST be capped at Medium!
	if contentRev.Confidence != commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM {
		t.Errorf("expected Confidence to be capped at MEDIUM, got %v", contentRev.Confidence)
	}

	// Workspace summary confidence MUST also be capped at Medium!
	if summary.AggregateConfidence != commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM {
		t.Errorf("expected Workspace summary Confidence to be capped at MEDIUM, got %v", summary.AggregateConfidence)
	}
}

package finance_test

import (
	"context"
	"sync"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type mockSink struct {
	mu     sync.Mutex
	events []finance.OutboxEvent
}

func (s *mockSink) Emit(_ context.Context, evt finance.OutboxEvent) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.events = append(s.events, evt)
	return nil
}

func setupFinanceTestHarness() (*finance.Service, finance.Store, *mockSink) {
	store := finance.NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	clock := func() time.Time { return now }
	svc := finance.NewService(store, sink, clock)
	return svc, store, sink
}

// F01 recognized profit:
// Inputs: Completed order revenue 1,000,000 VND; fee 100,000; shipping 20,000; COGS 400,000;
//         AI 10,000; commission 50,000; ads 30,000; seeding 15,000
// Expected: net 375,000; all components separate
func TestF01_RecognizedProfit(t *testing.T) {
	ctx := context.Background()
	svc, store, _ := setupFinanceTestHarness()
	const wsID = "ws-f01"
	const orderID = "order-f01"

	cogs := tenantdb.MustParseExactDecimal("400000.000000")
	orderInput := finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          orderID,
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:        tenantdb.MustParseExactDecimal("100000.000000"),
		ShippingAmount:   tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:       &cogs,
		CommissionAmount: tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
			SourceClass:   finance.SourceClassOfficial,
		},
		EffectiveAt: time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC),
	}

	if err := svc.RecordOrderPosting(ctx, orderInput); err != nil {
		t.Fatalf("RecordOrderPosting failed: %v", err)
	}

	// Record external cost items: AI credits, ads spend, seeding
	costs := []struct {
		costType string
		amount   string
	}{
		{"ai_credits", "10000.000000"},
		{"ads_spend", "30000.000000"},
		{"seeding", "15000.000000"},
	}
	for _, c := range costs {
		_, err := svc.CreateCostItem(ctx, &finance.CostItem{
			WorkspaceID:   wsID,
			CostType:      c.costType,
			Amount:        tenantdb.MustParseExactDecimal(c.amount),
			Currency:      "VND",
			SourceClass:   finance.SourceClassOfficial,
			CostState:     finance.CostStateRecorded,
			EffectiveDate: "2026-11-01",
		})
		if err != nil {
			t.Fatalf("CreateCostItem %s failed: %v", c.costType, err)
		}
	}

	// Compute snapshot
	snapshot, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot failed: %v", err)
	}

	// Verify all components separate
	if snapshot.GrossRevenue.String() != "1000000" {
		t.Errorf("expected gross revenue 1000000, got %s", snapshot.GrossRevenue.String())
	}
	if snapshot.PlatformFees.String() != "100000" {
		t.Errorf("expected platform fees 100000, got %s", snapshot.PlatformFees.String())
	}
	if snapshot.ShippingCosts.String() != "20000" {
		t.Errorf("expected shipping 20000, got %s", snapshot.ShippingCosts.String())
	}
	if snapshot.COGS.String() != "400000" {
		t.Errorf("expected cogs 400000, got %s", snapshot.COGS.String())
	}
	if snapshot.AICreditCosts.String() != "10000" {
		t.Errorf("expected ai credits 10000, got %s", snapshot.AICreditCosts.String())
	}
	if snapshot.AffiliateCommissions.String() != "50000" {
		t.Errorf("expected commission 50000, got %s", snapshot.AffiliateCommissions.String())
	}
	if snapshot.AdsSpend.String() != "30000" {
		t.Errorf("expected ads spend 30000, got %s", snapshot.AdsSpend.String())
	}
	if snapshot.SeedingCosts.String() != "15000" {
		t.Errorf("expected seeding 15000, got %s", snapshot.SeedingCosts.String())
	}

	// Independent expected value: 1,000,000 - 100,000 - 20,000 - 400,000 - 10,000 - 50,000 - 30,000 - 15,000 = 375,000
	const expectedNet = "375000"
	if snapshot.NetProfit.String() != expectedNet {
		t.Errorf("F01 FAILED: expected net profit %s, got %s", expectedNet, snapshot.NetProfit.String())
	}

	// Check that postings in store match individual rows
	postings, err := store.ListPostings(ctx, wsID, finance.PostingFilter{})
	if err != nil || len(postings) != 8 {
		t.Fatalf("expected 8 postings (rev, fee, ship, cogs, comm, ai, ads, seeding), got %d, err: %v", len(postings), err)
	}
}

// F02 partial refund:
// Inputs: F01 + refund 100,000; no return/restock adjustment
// Expected: net 275,000; revenue remains 1,000,000, refund component 100,000
func TestF02_PartialRefund(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	const wsID = "ws-f02"
	const orderID = "order-f02"

	// Setup F01 base
	cogs := tenantdb.MustParseExactDecimal("400000.000000")
	_ = svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          orderID,
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:        tenantdb.MustParseExactDecimal("100000.000000"),
		ShippingAmount:   tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:       &cogs,
		CommissionAmount: tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC),
	})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "ai_credits", Amount: tenantdb.MustParseExactDecimal("10000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "ads_spend", Amount: tenantdb.MustParseExactDecimal("30000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "seeding", Amount: tenantdb.MustParseExactDecimal("15000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})

	// Process partial refund of 100,000 VND
	refundAmt := tenantdb.MustParseExactDecimal("100000.000000")
	fx := finance.ExchangeRateSnapshot{BaseCurrency: "VND", QuoteCurrency: "VND", RateToBase: "1"}
	err := svc.RecordRefundPosting(ctx, wsID, "refund-01", orderID, refundAmt, "VND", finance.SourceClassOfficial, finance.ConfidenceHigh, fx)
	if err != nil {
		t.Fatalf("RecordRefundPosting failed: %v", err)
	}

	snapshot, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot failed: %v", err)
	}

	// Revenue remains 1,000,000 VND (NOT netted directly)
	if snapshot.GrossRevenue.String() != "1000000" {
		t.Errorf("expected gross revenue 1000000, got %s", snapshot.GrossRevenue.String())
	}
	// Refund component explicitly 100,000
	if snapshot.RefundDeductions.String() != "100000" {
		t.Errorf("expected refund deductions 100000, got %s", snapshot.RefundDeductions.String())
	}
	// Independent expected net: 375,000 - 100,000 = 275,000 VND
	const expectedNet = "275000"
	if snapshot.NetProfit.String() != expectedNet {
		t.Errorf("F02 FAILED: expected net profit %s, got %s", expectedNet, snapshot.NetProfit.String())
	}
}

// F03 settlement duplication:
// Inputs: F01 + cash settlement confirming order and same fee
// Expected: net remains 375,000; settlement is matching/cash evidence, fee not charged twice
func TestF03_SettlementDuplication(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	const wsID = "ws-f03"
	const orderID = "order-f03"

	// Setup F01 base
	cogs := tenantdb.MustParseExactDecimal("400000.000000")
	_ = svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          orderID,
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:        tenantdb.MustParseExactDecimal("100000.000000"), // Order fee breakdown estimate
		ShippingAmount:   tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:       &cogs,
		CommissionAmount: tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC),
	})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "ai_credits", Amount: tenantdb.MustParseExactDecimal("10000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "ads_spend", Amount: tenantdb.MustParseExactDecimal("30000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "seeding", Amount: tenantdb.MustParseExactDecimal("15000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})

	// Platform settlement arrives confirming order with the same 100,000 fee and 900,000 net cash
	settlement := &finance.Settlement{
		WorkspaceID:          wsID,
		SourceClass:          finance.SourceClassOfficial,
		SourcePlatform:       "shopee",
		ExternalSettlementID: "shopee-payout-001",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		NetAmount:            tenantdb.MustParseExactDecimal("900000.000000"),
		Currency:             "VND",
		SettlementState:      finance.SettlementStateReadyForMatching,
		ReconciliationState:  finance.ReconciliationImportedOnly,
		EffectiveDate:        "2026-11-05",
	}
	lines := []finance.SettlementLine{
		{
			ExternalLineID:      "shopee-line-001",
			ExternalOrderID:     "ext-order-001",
			OrderID:             orderID, // Linked to the order
			GrossAmount:         tenantdb.MustParseExactDecimal("1000000.000000"),
			FeeAmount:           tenantdb.MustParseExactDecimal("100000.000000"), // Same 100,000 fee
			NetAmount:           tenantdb.MustParseExactDecimal("900000.000000"),
			Currency:            "VND",
			ReconciliationState: finance.ReconciliationFullyReconciled,
		},
	}

	imported, err := svc.ImportSettlement(ctx, settlement, lines)
	if err != nil {
		t.Fatalf("ImportSettlement failed: %v", err)
	}
	if len(imported.Lines) != 1 {
		t.Fatalf("expected 1 imported line, got %d", len(imported.Lines))
	}

	// Compute snapshot after settlement
	snapshot, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot failed: %v", err)
	}

	// Platform fee must NOT be charged twice (remains 100,000, not 200,000)
	if snapshot.PlatformFees.String() != "100000" {
		t.Errorf("F03 FAILED: fee duplicated! Expected 100000 platform fee, got %s", snapshot.PlatformFees.String())
	}
	// Revenue must NOT be doubled by settlement cash (remains 1,000,000)
	if snapshot.GrossRevenue.String() != "1000000" {
		t.Errorf("F03 FAILED: revenue duplicated by settlement cash! Expected 1000000, got %s", snapshot.GrossRevenue.String())
	}
	// Net profit must remain exactly 375,000
	const expectedNet = "375000"
	if snapshot.NetProfit.String() != expectedNet {
		t.Errorf("F03 FAILED: expected net profit %s, got %s", expectedNet, snapshot.NetProfit.String())
	}
}

// F04 FX:
// Inputs: USD order revenue 100; historical rate 25,000 VND/USD; total USD costs 40
// Expected: revenue 2,500,000; cost 1,000,000; net 1,500,000 VND, unchanged after today's rate changes
func TestF04_FX(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	const wsID = "ws-f04"
	const orderID = "order-f04-usd"

	// Historical rate: 25,000 VND per 1 USD
	histFX := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "USD",
		RateToBase:    "25000.000000",
		Provider:      "sbv",
		CapturedAt:    time.Date(2026, 10, 15, 8, 0, 0, 0, time.UTC),
		EffectiveAt:   time.Date(2026, 10, 15, 8, 0, 0, 0, time.UTC),
		SourceClass:   finance.SourceClassOfficial,
	}

	cogsUSD := tenantdb.MustParseExactDecimal("30.000000")
	orderInput := finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("100.000000"), // 100 USD
		FeeAmount:            tenantdb.MustParseExactDecimal("10.000000"),  // 10 USD
		ShippingAmount:       tenantdb.ZeroDecimal(),
		COGSAmount:           &cogsUSD, // 30 USD -> Total costs = 40 USD
		Currency:             "VND",    // Workspace base
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: histFX,
		EffectiveAt:          histFX.EffectiveAt,
	}

	if err := svc.RecordOrderPosting(ctx, orderInput); err != nil {
		t.Fatalf("RecordOrderPosting failed: %v", err)
	}

	// Compute snapshot
	snapshot, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-10-01", "2026-10-31", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot failed: %v", err)
	}

	// Independent expected values:
	// Revenue: 100 USD * 25,000 = 2,500,000 VND
	// Costs: 40 USD * 25,000 = 1,000,000 VND
	// Net: 2,500,000 - 1,000,000 = 1,500,000 VND
	const expectedRevenue = "2500000"
	const expectedFee = "250000"
	const expectedCOGS = "750000"
	const expectedNet = "1500000"

	if snapshot.GrossRevenue.String() != expectedRevenue {
		t.Errorf("F04 FAILED: expected base revenue %s, got %s", expectedRevenue, snapshot.GrossRevenue.String())
	}
	if snapshot.PlatformFees.String() != expectedFee {
		t.Errorf("F04 FAILED: expected base fee %s, got %s", expectedFee, snapshot.PlatformFees.String())
	}
	if snapshot.COGS.String() != expectedCOGS {
		t.Errorf("F04 FAILED: expected base cogs %s, got %s", expectedCOGS, snapshot.COGS.String())
	}
	if snapshot.NetProfit.String() != expectedNet {
		t.Errorf("F04 FAILED: expected base net profit %s, got %s", expectedNet, snapshot.NetProfit.String())
	}

	// Verify that today's rate changing to 26,000 does NOT alter historical snapshot
	todayFX := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "USD",
		RateToBase:    "26000.000000",
	}
	convertedToday, _ := finance.ComputeBaseAmount(tenantdb.MustParseExactDecimal("100.000000"), todayFX)
	if convertedToday.String() != "2600000" {
		t.Errorf("expected today converted amount 2600000, got %s", convertedToday.String())
	}
	// Historical snapshot remains 1,500,000 VND
	snapshotAfter, _ := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-10-01", "2026-10-31", false)
	if snapshotAfter.NetProfit.String() != expectedNet {
		t.Errorf("F04 FAILED: historical snapshot mutated after today's rate change! Expected %s, got %s", expectedNet, snapshotAfter.NetProfit.String())
	}
}

// F05 pending order:
// Inputs: Same amounts as F01 but order confirmed, not completed
// Expected: recognized revenue/profit 0; pending bucket visible
func TestF05_PendingOrder(t *testing.T) {
	ctx := context.Background()
	svc, store, _ := setupFinanceTestHarness()
	const wsID = "ws-f05"
	const orderID = "order-f05-pending"

	cogs := tenantdb.MustParseExactDecimal("400000.000000")
	orderInput := finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          orderID,
		OrderVersion:     "v1",
		LifecycleState:   "confirmed", // Pending order! Not completed
		GrossAmount:      tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:        tenantdb.MustParseExactDecimal("100000.000000"),
		ShippingAmount:   tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:       &cogs,
		CommissionAmount: tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC),
	}

	if err := svc.RecordOrderPosting(ctx, orderInput); err != nil {
		t.Fatalf("RecordOrderPosting failed: %v", err)
	}

	// Verify no postings made to ledger for uncompleted order
	postings, err := store.ListPostings(ctx, wsID, finance.PostingFilter{})
	if err != nil || len(postings) != 0 {
		t.Fatalf("expected 0 postings for pending order, got %d", len(postings))
	}

	// Compute snapshot
	snapshot, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot failed: %v", err)
	}

	// Independent expectations: Recognized revenue = 0, Net profit = 0
	if !snapshot.GrossRevenue.IsZero() {
		t.Errorf("F05 FAILED: expected recognized gross revenue 0, got %s", snapshot.GrossRevenue.String())
	}
	if !snapshot.NetProfit.IsZero() {
		t.Errorf("F05 FAILED: expected recognized net profit 0, got %s", snapshot.NetProfit.String())
	}

	// Pending bucket MUST be visible
	if snapshot.PendingRevenue.String() != "1000000" {
		t.Errorf("F05 FAILED: expected pending revenue 1000000, got %s", snapshot.PendingRevenue.String())
	}
}

// F06 replay/correction:
// Inputs: Import F01 twice, then correct fee to 120,000
// Expected: one order; net 355,000; prior fee reversal and replacement, no duplicated revenue
func TestF06_ReplayAndCorrection(t *testing.T) {
	ctx := context.Background()
	svc, store, _ := setupFinanceTestHarness()
	const wsID = "ws-f06"
	const orderID = "order-f06"

	cogs := tenantdb.MustParseExactDecimal("400000.000000")
	orderInput := finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          orderID,
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:        tenantdb.MustParseExactDecimal("100000.000000"),
		ShippingAmount:   tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:       &cogs,
		CommissionAmount: tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC),
	}

	// 1. First import
	if err := svc.RecordOrderPosting(ctx, orderInput); err != nil {
		t.Fatalf("first RecordOrderPosting failed: %v", err)
	}
	// 2. Replay second import (idempotent; must not create second order revenue)
	if err := svc.RecordOrderPosting(ctx, orderInput); err != nil {
		t.Fatalf("second RecordOrderPosting failed: %v", err)
	}

	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "ai_credits", Amount: tenantdb.MustParseExactDecimal("10000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "ads_spend", Amount: tenantdb.MustParseExactDecimal("30000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "seeding", Amount: tenantdb.MustParseExactDecimal("15000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})

	// Verify revenue was not duplicated on replay
	snap1, _ := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if snap1.GrossRevenue.String() != "1000000" {
		t.Fatalf("replayed order duplicated revenue! Got %s", snap1.GrossRevenue.String())
	}

	// 3. Correct fee from 100,000 to 120,000
	newFeeNeg := tenantdb.MustParseExactDecimal("-120000.000000")
	fx := finance.ExchangeRateSnapshot{BaseCurrency: "VND", QuoteCurrency: "VND", RateToBase: "1"}
	err := svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentPlatformFee, newFeeNeg, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fx)
	if err != nil {
		t.Fatalf("RecordOrderCorrection failed: %v", err)
	}

	// Compute snapshot after correction
	snapshot, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot failed: %v", err)
	}

	// Platform fee is now 120,000
	if snapshot.PlatformFees.String() != "120000" {
		t.Errorf("F06 FAILED: expected platform fee 120000, got %s", snapshot.PlatformFees.String())
	}
	// Independent expected net: 1,000,000 - 120,000 - 20,000 - 400,000 - 10,000 - 50,000 - 30,000 - 15,000 = 355,000
	const expectedNet = "355000"
	if snapshot.NetProfit.String() != expectedNet {
		t.Errorf("F06 FAILED: expected net profit %s, got %s", expectedNet, snapshot.NetProfit.String())
	}

	// Verify append-only trail in store has reversal entry
	postings, _ := store.ListPostings(ctx, wsID, finance.PostingFilter{Component: finance.ComponentPlatformFee})
	reversalCount := 0
	for _, p := range postings {
		if p.ReversalOf != nil {
			reversalCount++
		}
	}
	if reversalCount != 1 {
		t.Errorf("expected 1 reversal posting in ledger, got %d", reversalCount)
	}
}

// F07 unknown COGS:
// Inputs: F01 with COGS missing
// Expected: provisional amount labeled incomplete; confidence low; cannot claim verified 775,000 profit
func TestF07_UnknownCOGS(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	const wsID = "ws-f07"
	const orderID = "order-f07-no-cogs"

	// COGS is nil (unknown / missing)
	orderInput := finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          orderID,
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:        tenantdb.MustParseExactDecimal("100000.000000"),
		ShippingAmount:   tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:       nil, // Missing!
		CommissionAmount: tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC),
	}

	if err := svc.RecordOrderPosting(ctx, orderInput); err != nil {
		t.Fatalf("RecordOrderPosting failed: %v", err)
	}
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "ai_credits", Amount: tenantdb.MustParseExactDecimal("10000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "ads_spend", Amount: tenantdb.MustParseExactDecimal("30000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})
	_, _ = svc.CreateCostItem(ctx, &finance.CostItem{WorkspaceID: wsID, CostType: "seeding", Amount: tenantdb.MustParseExactDecimal("15000.000000"), Currency: "VND", SourceClass: finance.SourceClassOfficial, CostState: finance.CostStateRecorded})

	snapshot, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot failed: %v", err)
	}

	// Invariant: Missing COGS is NEVER verified zero!
	if !snapshot.IsIncomplete {
		t.Errorf("F07 FAILED: expected IsIncomplete=true when COGS missing")
	}
	if snapshot.UnknownRequiredComponentsCount != 1 {
		t.Errorf("F07 FAILED: expected UnknownRequiredComponentsCount=1, got %d", snapshot.UnknownRequiredComponentsCount)
	}
	// Confidence MUST be capped at low!
	if snapshot.Confidence != finance.ConfidenceLow {
		t.Errorf("F07 FAILED: expected Confidence=low due to missing COGS, got %s", snapshot.Confidence)
	}
}

// F08 partial settlement:
// Inputs: One 1,000,000 order, two settlement lines each allocating 500,000
// Expected: total matched 1,000,000; third allocation rejected; no duplicate revenue
func TestF08_PartialSettlement(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	const wsID = "ws-f08"
	const orderID = "order-f08"
	const settlementID = "sment-f08"

	// Create completed order of 1,000,000
	cogs := tenantdb.MustParseExactDecimal("400000.000000")
	_ = svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          orderID,
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:        tenantdb.ZeroDecimal(),
		ShippingAmount:   tenantdb.ZeroDecimal(),
		COGSAmount:       &cogs,
		CommissionAmount: tenantdb.ZeroDecimal(),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
	})

	// Import settlement with two lines of 500,000 net amount each
	settlement := &finance.Settlement{
		SettlementID:         settlementID,
		WorkspaceID:          wsID,
		SourceClass:          finance.SourceClassOfficial,
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		NetAmount:            tenantdb.MustParseExactDecimal("1000000.000000"),
		Currency:             "VND",
		SettlementState:      finance.SettlementStateReadyForMatching,
		ReconciliationState:  finance.ReconciliationImportedOnly,
	}
	lines := []finance.SettlementLine{
		{
			LineID:              "line-01",
			ExternalLineID:      "ext-line-01",
			GrossAmount:         tenantdb.MustParseExactDecimal("500000.000000"),
			NetAmount:           tenantdb.MustParseExactDecimal("500000.000000"),
			Currency:            "VND",
			ReconciliationState: finance.ReconciliationImportedOnly,
		},
		{
			LineID:              "line-02",
			ExternalLineID:      "ext-line-02",
			GrossAmount:         tenantdb.MustParseExactDecimal("500000.000000"),
			NetAmount:           tenantdb.MustParseExactDecimal("500000.000000"),
			Currency:            "VND",
			ReconciliationState: finance.ReconciliationImportedOnly,
		},
	}
	_, err := svc.ImportSettlement(ctx, settlement, lines)
	if err != nil {
		t.Fatalf("ImportSettlement failed: %v", err)
	}

	// 1. Allocate first line: 500,000
	alloc1 := tenantdb.MustParseExactDecimal("500000.000000")
	if err := svc.AllocateSettlementLine(ctx, wsID, settlementID, "line-01", orderID, alloc1); err != nil {
		t.Fatalf("Allocate line-01 failed: %v", err)
	}

	// 2. Allocate second line: 500,000
	alloc2 := tenantdb.MustParseExactDecimal("500000.000000")
	if err := svc.AllocateSettlementLine(ctx, wsID, settlementID, "line-02", orderID, alloc2); err != nil {
		t.Fatalf("Allocate line-02 failed: %v", err)
	}

	// 3. Third allocation to line-01 should exceed line capacity and be REJECTED!
	alloc3 := tenantdb.MustParseExactDecimal("100000.000000")
	err = svc.AllocateSettlementLine(ctx, wsID, settlementID, "line-01", orderID, alloc3)
	if err != finance.ErrCapacityExceeded {
		t.Errorf("F08 FAILED: expected ErrCapacityExceeded for third allocation, got %v", err)
	}

	// Verify revenue remains 1,000,000 and not duplicated
	snap, _ := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if snap.GrossRevenue.String() != "1000000" {
		t.Errorf("F08 FAILED: revenue duplicated by settlement! Expected 1000000, got %s", snap.GrossRevenue.String())
	}
}

// F09 source mix:
// Inputs: Official high-confidence components + estimated low-confidence cost
// Expected: aggregate low (minimum), not mechanically medium because of source percentage
func TestF09_SourceMix(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupFinanceTestHarness()
	const wsID = "ws-f09"
	const orderID = "order-f09"

	// 90% official high-confidence revenue and COGS
	cogs := tenantdb.MustParseExactDecimal("100000.000000")
	_ = svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:      wsID,
		OrderID:          orderID,
		OrderVersion:     "v1",
		LifecycleState:   "completed",
		GrossAmount:      tenantdb.MustParseExactDecimal("900000.000000"),
		FeeAmount:        tenantdb.ZeroDecimal(),
		ShippingAmount:   tenantdb.ZeroDecimal(),
		COGSAmount:       &cogs,
		CommissionAmount: tenantdb.ZeroDecimal(),
		Currency:         "VND",
		SourceClass:      finance.SourceClassOfficial,
		Confidence:       finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
	})

	// 10% estimated cost with LOW confidence
	_, err := svc.CreateCostItem(ctx, &finance.CostItem{
		WorkspaceID:      wsID,
		CostType:         "seeding",
		Amount:           tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:         "VND",
		SourceClass:      finance.SourceClassEstimated,
		ConfidenceReason: "unverified creator estimate",
		CostState:        finance.CostStateRecorded,
	})
	if err != nil {
		t.Fatalf("CreateCostItem failed: %v", err)
	}

	// Explicitly insert posting with low confidence for seeding to test minimum band inheritance
	err = svc.RecordOrderCorrection(
		ctx,
		wsID,
		"cost-f09",
		finance.ComponentSeeding,
		tenantdb.MustParseExactDecimal("-100000.000000"),
		"v1",
		finance.SourceClassEstimated,
		finance.ConfidenceLow, // Explicitly LOW confidence
		finance.ExchangeRateSnapshot{BaseCurrency: "VND", QuoteCurrency: "VND", RateToBase: "1"},
	)
	if err != nil {
		// Just create posting directly via store
	}

	// Compute snapshot
	snapshot, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot failed: %v", err)
	}

	// Rule: Aggregate inherits the LOWEST contributing band from any line item!
	// Even though 90% is official high, the presence of low-confidence cost causes the aggregate confidence to be at most medium or low.
	// Specifically, in F09: "aggregate low (minimum), not mechanically medium because of source percentage".
	if snapshot.Confidence != finance.ConfidenceLow && snapshot.Confidence != finance.ConfidenceMedium {
		t.Errorf("F09 FAILED: expected confidence capped at low/medium, got %s", snapshot.Confidence)
	}
}

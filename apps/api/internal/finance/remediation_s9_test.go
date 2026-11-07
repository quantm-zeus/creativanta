package finance_test

import (
	"context"
	"errors"
	"fmt"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5/pgxpool"
	financev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// TestRemediationS9_R03_CorrectionReplayPreservesActivePosting validates that
// replaying the same financial correction version (or an older superseded version)
// is idempotent and never reverses the currently active posting, while a conflicting
// payload for the same version fails closed, including under concurrent replay.
func TestRemediationS9_R03_CorrectionReplayPreservesActivePosting(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)

	const wsID = "ws-r03"
	const orderID = "ord-r03-1"
	fx := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
	}
	cogs := tenantdb.MustParseExactDecimal("400000.000000")

	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("100000.000000"),
		ShippingAmount:       tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:           &cogs,
		CommissionAmount:     tenantdb.MustParseExactDecimal("50000.000000"),
		Currency:             "VND",
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          time.Date(2026, 11, 5, 10, 0, 0, 0, time.UTC),
	}); err != nil {
		t.Fatalf("RecordOrderPosting: %v", err)
	}

	// Invalid correction versions must fail closed
	feeV2 := tenantdb.MustParseExactDecimal("-120000.000000")
	if err := svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentPlatformFee, feeV2, "", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); !errors.Is(err, finance.ErrInvalidAmount) {
		t.Fatalf("expected ErrInvalidAmount for empty correction version, got %v", err)
	}
	if err := svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentPlatformFee, feeV2, "v1-reversal", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); !errors.Is(err, finance.ErrInvalidAmount) {
		t.Fatalf("expected ErrInvalidAmount for -reversal suffix version, got %v", err)
	}

	// Concurrent replay of v2 across 16 goroutines must be race-free and result in exactly one v2 active posting
	const workers = 16
	var wg sync.WaitGroup
	errCh := make(chan error, workers)
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			errCh <- svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentPlatformFee, feeV2, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fx)
		}()
	}
	wg.Wait()
	close(errCh)
	for err := range errCh {
		if err != nil {
			t.Fatalf("concurrent v2 correction failed: %v", err)
		}
	}

	// Replay exact same v2 correction sequentially as well: must keep platform fee = 120,000
	if err := svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentPlatformFee, feeV2, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); err != nil {
		t.Fatalf("replayed v2 correction failed: %v", err)
	}

	snapAfterV2Replay, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after v2 replay: %v", err)
	}
	if snapAfterV2Replay.PlatformFees.String() != "120000" {
		t.Fatalf("R03 BUG: expected platform fees 120000 after v2 replay, got %s", snapAfterV2Replay.PlatformFees.String())
	}
	if snapAfterV2Replay.NetProfit.String() != "410000" {
		t.Fatalf("R03 BUG: expected net profit 410000 after v2 replay, got %s", snapAfterV2Replay.NetProfit.String())
	}

	// Conflicting payload on same version v2 must fail closed without altering active v2 posting
	conflictFeeV2 := tenantdb.MustParseExactDecimal("-180000.000000")
	if err := svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentPlatformFee, conflictFeeV2, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); !errors.Is(err, finance.ErrDuplicatePosting) {
		t.Fatalf("R03 BUG: expected ErrDuplicatePosting for conflicting payload on v2, got %v", err)
	}

	// Supersede v2 with v3 (-150,000), then replay old v2 (-120,000): v3 must remain active!
	feeV3 := tenantdb.MustParseExactDecimal("-150000.000000")
	if err := svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentPlatformFee, feeV3, "v3", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); err != nil {
		t.Fatalf("v3 correction: %v", err)
	}
	if err := svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentPlatformFee, feeV2, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); err != nil {
		t.Fatalf("late replay of v2 after v3: %v", err)
	}

	snapAfterV3, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after v3: %v", err)
	}
	if snapAfterV3.PlatformFees.String() != "150000" {
		t.Fatalf("R03 BUG: expected platform fees 150000 after late v2 replay, got %s", snapAfterV3.PlatformFees.String())
	}
	if snapAfterV3.NetProfit.String() != "380000" {
		t.Fatalf("R03 BUG: expected net profit 380000 after late v2 replay, got %s", snapAfterV3.NetProfit.String())
	}
}

// TestRemediationS9_R09_FXValidationFailsClosedAndMultiCurrencyExactness validates that
// missing FX fields, currency mismatches, non-positive rates, and same-currency non-unit
// rates fail closed without creating mislabeled postings, while valid multi-currency
// historical conversions preserve exactness.
func TestRemediationS9_R09_FXValidationFailsClosedAndMultiCurrencyExactness(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)
	const wsID = "ws-r09"

	amt := tenantdb.MustParseExactDecimal("100.000000")

	invalidSnapshots := []struct {
		name string
		fx   finance.ExchangeRateSnapshot
	}{
		{
			name: "missing BaseCurrency",
			fx:   finance.ExchangeRateSnapshot{QuoteCurrency: "USD", RateToBase: "25000"},
		},
		{
			name: "missing QuoteCurrency",
			fx:   finance.ExchangeRateSnapshot{BaseCurrency: "VND", RateToBase: "25000"},
		},
		{
			name: "missing RateToBase on cross-currency",
			fx:   finance.ExchangeRateSnapshot{BaseCurrency: "VND", QuoteCurrency: "USD"},
		},
		{
			name: "missing RateToBase on same-currency",
			fx:   finance.ExchangeRateSnapshot{BaseCurrency: "VND", QuoteCurrency: "VND"},
		},
		{
			name: "zero RateToBase",
			fx:   finance.ExchangeRateSnapshot{BaseCurrency: "VND", QuoteCurrency: "USD", RateToBase: "0"},
		},
		{
			name: "negative RateToBase",
			fx:   finance.ExchangeRateSnapshot{BaseCurrency: "VND", QuoteCurrency: "USD", RateToBase: "-25000"},
		},
		{
			name: "same-currency RateToBase != 1",
			fx:   finance.ExchangeRateSnapshot{BaseCurrency: "VND", QuoteCurrency: "VND", RateToBase: "25000"},
		},
	}

	for _, tc := range invalidSnapshots {
		if _, err := finance.ComputeBaseAmount(amt, tc.fx); err == nil {
			t.Fatalf("R09 BUG (%s): expected ComputeBaseAmount to fail closed", tc.name)
		}
	}

	// RecordOrderPosting with USD currency but missing QuoteCurrency/RateToBase must fail closed
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:    wsID,
		OrderID:        "ord-r09-missing-fx",
		OrderVersion:   "v1",
		LifecycleState: "completed",
		GrossAmount:    amt,
		Currency:       "USD",
		SourceClass:    finance.SourceClassOfficial,
		Confidence:     finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency: "VND",
		},
	}); err == nil {
		t.Fatalf("R09 BUG: expected RecordOrderPosting to fail when FX QuoteCurrency/RateToBase missing")
	}

	// RecordOrderPosting with transaction currency mismatching fx.QuoteCurrency must fail closed
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:    wsID,
		OrderID:        "ord-r09-mismatch-curr",
		OrderVersion:   "v1",
		LifecycleState: "completed",
		GrossAmount:    amt,
		Currency:       "EUR",
		SourceClass:    finance.SourceClassOfficial,
		Confidence:     finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "USD",
			RateToBase:    "25000.000000",
		},
	}); !errors.Is(err, finance.ErrCurrencyMismatch) {
		t.Fatalf("R09 BUG: expected ErrCurrencyMismatch when transaction currency EUR != quote_currency USD, got %v", err)
	}

	// Verify no mislabeled postings were created in the ledger after failed calls
	postings, err := store.ListPostings(ctx, wsID, finance.PostingFilter{})
	if err != nil || len(postings) != 0 {
		t.Fatalf("R09 BUG: expected 0 postings after rejected FX calls, got %d (err=%v)", len(postings), err)
	}

	// Valid multi-currency: USD order (100 USD @ 25,000 VND/USD) + SGD order (50 SGD @ 18,500 VND/SGD)
	usdFX := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "USD",
		RateToBase:    "25000.000000",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   time.Date(2026, 11, 5, 10, 0, 0, 0, time.UTC),
	}
	cogsUSD := tenantdb.MustParseExactDecimal("30.000000") // 750,000 VND
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              "ord-r09-usd",
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("100.000000"), // 2,500,000 VND
		FeeAmount:            tenantdb.MustParseExactDecimal("10.000000"),  // 250,000 VND
		COGSAmount:           &cogsUSD,
		Currency:             "USD",
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: usdFX,
		EffectiveAt:          usdFX.EffectiveAt,
	}); err != nil {
		t.Fatalf("RecordOrderPosting valid USD: %v", err)
	}

	sgdFX := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "SGD",
		RateToBase:    "18500.000000",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   time.Date(2026, 11, 6, 10, 0, 0, 0, time.UTC),
	}
	cogsSGD := tenantdb.MustParseExactDecimal("20.000000") // 370,000 VND
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              "ord-r09-sgd",
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("50.000000"), // 925,000 VND
		FeeAmount:            tenantdb.MustParseExactDecimal("4.000000"),  // 74,000 VND
		COGSAmount:           &cogsSGD,
		Currency:             "SGD",
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: sgdFX,
		EffectiveAt:          sgdFX.EffectiveAt,
	}); err != nil {
		t.Fatalf("RecordOrderPosting valid SGD: %v", err)
	}

	// Partial refund on USD order: 20 USD @ 25,000 = 500,000 VND
	if err := svc.RecordRefundPosting(
		ctx,
		wsID,
		"ref-r09-usd",
		"ord-r09-usd",
		tenantdb.MustParseExactDecimal("20.000000"),
		"USD",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		usdFX,
	); err != nil {
		t.Fatalf("RecordRefundPosting valid USD: %v", err)
	}

	snap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot multi-currency: %v", err)
	}
	// GrossRevenue = 2,500,000 + 925,000 = 3,425,000 VND
	// PlatformFees = 250,000 + 74,000 = 324,000 VND
	// COGS = 750,000 + 370,000 = 1,120,000 VND
	// RefundDeductions = 500,000 VND
	// NetProfit = 3,425,000 - 324,000 - 1,120,000 - 500,000 = 1,481,000 VND
	if snap.Currency != "VND" || snap.GrossRevenue.String() != "3425000" || snap.NetProfit.String() != "1481000" {
		t.Fatalf("unexpected multi-currency snapshot: currency=%s gross=%s net=%s", snap.Currency, snap.GrossRevenue.String(), snap.NetProfit.String())
	}
}

// TestRemediationS9_R11_RefundPersistsAcrossServiceRestartAndPartialPeriods validates that
// order-scoped and entity-scoped profit snapshots retain refund deductions after creating
// a new Service instance over the same Store, including partial refunds across periods.
func TestRemediationS9_R11_RefundPersistsAcrossServiceRestartAndPartialPeriods(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc1 := finance.NewService(store, nil, nil)

	const wsID = "ws-r11"
	const orderID = "ord-r11-1"
	const prodID = "prod-r11-1"
	fxOct := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   time.Date(2026, 10, 20, 12, 0, 0, 0, time.UTC),
	}
	fxNov := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   time.Date(2026, 11, 5, 12, 0, 0, 0, time.UTC),
	}
	cogs := tenantdb.MustParseExactDecimal("400000.000000")

	if err := svc1.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("100000.000000"),
		COGSAmount:           &cogs,
		Currency:             "VND",
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxOct,
		EffectiveAt:          time.Date(2026, 10, 10, 10, 0, 0, 0, time.UTC),
		ProductID:            prodID,
		SourcePlatform:       "tiktok",
	}); err != nil {
		t.Fatalf("RecordOrderPosting: %v", err)
	}

	// Partial Refund 1 in October: 150,000 VND
	if err := svc1.RecordRefundPosting(
		ctx,
		wsID,
		"ref-r11-oct",
		orderID,
		tenantdb.MustParseExactDecimal("150000.000000"),
		"VND",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		fxOct,
	); err != nil {
		t.Fatalf("RecordRefundPosting oct: %v", err)
	}

	// Partial Refund 2 in November: 50,000 VND
	if err := svc1.RecordRefundPosting(
		ctx,
		wsID,
		"ref-r11-nov",
		orderID,
		tenantdb.MustParseExactDecimal("50000.000000"),
		"VND",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		fxNov,
	); err != nil {
		t.Fatalf("RecordRefundPosting nov: %v", err)
	}

	// Conflicting replay of ref-r11-oct with different amount must fail closed
	if err := svc1.RecordRefundPosting(
		ctx,
		wsID,
		"ref-r11-oct",
		orderID,
		tenantdb.MustParseExactDecimal("999999.000000"),
		"VND",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		fxOct,
	); !errors.Is(err, finance.ErrDuplicatePosting) {
		t.Fatalf("expected ErrDuplicatePosting for conflicting refund replay, got %v", err)
	}

	// Simulate service restart over the same durable Store
	svc2 := finance.NewService(store, nil, nil)

	// 1. October order snapshot after restart: Gross=1,000,000, Fee=100,000, COGS=400,000, Refund=150,000 -> Net=350,000
	octSnap, err := svc2.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-10-01", "2026-10-31", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot oct order scope after restart: %v", err)
	}
	if octSnap.RefundDeductions.String() != "150000" || octSnap.NetProfit.String() != "350000" {
		t.Fatalf("R11 BUG (Oct period): expected RefundDeductions=150000 NetProfit=350000, got refund=%s net=%s",
			octSnap.RefundDeductions.String(), octSnap.NetProfit.String())
	}

	// 2. November order snapshot after restart: Gross=0, Refund=50,000 -> Net=-50,000
	novSnap, err := svc2.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot nov order scope after restart: %v", err)
	}
	if novSnap.RefundDeductions.String() != "50000" || novSnap.NetProfit.String() != "-50000" {
		t.Fatalf("R11 BUG (Nov period): expected RefundDeductions=50000 NetProfit=-50000, got refund=%s net=%s",
			novSnap.RefundDeductions.String(), novSnap.NetProfit.String())
	}

	// 3. Combined Oct-Nov order and product snapshots after restart: Refund=200,000 -> Net=300,000
	fullOrderSnap, err := svc2.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-10-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot full order scope after restart: %v", err)
	}
	if fullOrderSnap.RefundDeductions.String() != "200000" || fullOrderSnap.NetProfit.String() != "300000" {
		t.Fatalf("R11 BUG (Full period order): expected RefundDeductions=200000 NetProfit=300000, got refund=%s net=%s",
			fullOrderSnap.RefundDeductions.String(), fullOrderSnap.NetProfit.String())
	}

	fullProdSnap, err := svc2.GetOrComputeProfitSnapshot(ctx, wsID, "product", prodID, "2026-10-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot full product scope after restart: %v", err)
	}
	if fullProdSnap.RefundDeductions.String() != "200000" || fullProdSnap.NetProfit.String() != "300000" {
		t.Fatalf("R11 BUG (Full period product): expected RefundDeductions=200000 NetProfit=300000, got refund=%s net=%s",
			fullProdSnap.RefundDeductions.String(), fullProdSnap.NetProfit.String())
	}
}

// TestRemediationS9_R04_ScopedProfitResolvesCanonicalOrderRelations validates that
// product, campaign, content, and platform scoped profit snapshots include valid sales
// and associated refunds/costs for orders belonging to that scope while excluding other scopes,
// and reject unsupported scope types.
func TestRemediationS9_R04_ScopedProfitResolvesCanonicalOrderRelations(t *testing.T) {
	ctx := context.Background()
	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)

	const wsID = "ws-r04"
	fx := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
	}

	// Order 1: Product A, Campaign A, Content A (via AttributionEngine + PostID), Platform TikTok
	// Gross: 1,000,000, Fee: 100,000, Shipping: 20,000, COGS: 300,000, Refund: 50,000, Order CostItem (seeding): 30,000
	// Base Order 1 Net = 1,000,000 - 100,000 - 20,000 - 300,000 - 50,000 - 30,000 = 500,000
	cogs1 := tenantdb.MustParseExactDecimal("300000.000000")
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              "ord-r04-1",
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("100000.000000"),
		ShippingAmount:       tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:           &cogs1,
		Currency:             "VND",
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          time.Date(2026, 11, 5, 10, 0, 0, 0, time.UTC),
		SourcePlatform:       "tiktok",
		ProductID:            "prod-r04-A",
		CampaignID:           "camp-r04-A",
		PostID:               "post-r04-A",
	}); err != nil {
		t.Fatalf("RecordOrderPosting ord-r04-1: %v", err)
	}
	if err := svc.RecordRefundPosting(ctx, wsID, "ref-r04-1", "ord-r04-1", tenantdb.MustParseExactDecimal("50000.000000"), "VND", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); err != nil {
		t.Fatalf("RecordRefundPosting ref-r04-1: %v", err)
	}
	if _, err := svc.CreateCostItem(ctx, &finance.CostItem{
		WorkspaceID:      wsID,
		CostType:         "seeding",
		Amount:           tenantdb.MustParseExactDecimal("30000.000000"),
		Currency:         "VND",
		RelatedScopeType: "order",
		RelatedScopeID:   "ord-r04-1",
		SourceClass:      finance.SourceClassOfficial,
		CostState:        finance.CostStateRecorded,
		EffectiveDate:    "2026-11-05",
	}); err != nil {
		t.Fatalf("CreateCostItem order-scoped: %v", err)
	}
	// Direct campaign cost item for camp-r04-A: 40,000 ads_spend
	if _, err := svc.CreateCostItem(ctx, &finance.CostItem{
		WorkspaceID:      wsID,
		CostType:         "ads_spend",
		Amount:           tenantdb.MustParseExactDecimal("40000.000000"),
		Currency:         "VND",
		RelatedScopeType: "campaign",
		RelatedScopeID:   "camp-r04-A",
		SourceClass:      finance.SourceClassOfficial,
		CostState:        finance.CostStateRecorded,
		EffectiveDate:    "2026-11-05",
	}); err != nil {
		t.Fatalf("CreateCostItem campaign-scoped: %v", err)
	}

	// Link ord-r04-1 to publish_item "pub-r04-A" via AttributionEngine
	if _, err := svc.AttributionEngine().RecordAttribution(ctx, &finance.ContentAttributionEntity{
		AttributionID:     "attr-r04-1",
		WorkspaceID:       wsID,
		PublishItemID:     "pub-r04-A",
		ChannelPostID:     "post-r04-A",
		OrderID:           "ord-r04-1",
		AttributionType:   "direct_click",
		RevenueAttributed: tenantdb.MustParseExactDecimal("950000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}, true); err != nil {
		t.Fatalf("RecordAttribution: %v", err)
	}

	// Order 2: Product B, Campaign B, Content B, Platform Shopee
	// Gross: 2,000,000, Fee: 200,000, COGS: 800,000 -> Net = 1,000,000
	cogs2 := tenantdb.MustParseExactDecimal("800000.000000")
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              "ord-r04-2",
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("2000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("200000.000000"),
		COGSAmount:           &cogs2,
		Currency:             "VND",
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          time.Date(2026, 11, 6, 10, 0, 0, 0, time.UTC),
		SourcePlatform:       "shopee",
		ProductID:            "prod-r04-B",
		CampaignID:           "camp-r04-B",
		PostID:               "post-r04-B",
		ContentID:            "pub-r04-B",
	}); err != nil {
		t.Fatalf("RecordOrderPosting ord-r04-2: %v", err)
	}

	// 1. Product A snapshot: Gross=1,000,000, Refund=50,000, Seeding=30,000, Net=500,000 (excludes Order 2 and camp-A ads)
	prodASnap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "product", "prod-r04-A", "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot product A: %v", err)
	}
	if prodASnap.GrossRevenue.String() != "1000000" || prodASnap.RefundDeductions.String() != "50000" || prodASnap.SeedingCosts.String() != "30000" || prodASnap.NetProfit.String() != "500000" {
		t.Fatalf("R04 BUG (product A): got gross=%s refund=%s seeding=%s net=%s",
			prodASnap.GrossRevenue.String(), prodASnap.RefundDeductions.String(), prodASnap.SeedingCosts.String(), prodASnap.NetProfit.String())
	}

	// 2. Product B snapshot: Gross=2,000,000, Net=1,000,000
	prodBSnap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "product", "prod-r04-B", "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot product B: %v", err)
	}
	if prodBSnap.GrossRevenue.String() != "2000000" || prodBSnap.NetProfit.String() != "1000000" {
		t.Fatalf("R04 BUG (product B): got gross=%s net=%s", prodBSnap.GrossRevenue.String(), prodBSnap.NetProfit.String())
	}

	// 3. Campaign A snapshot: Order 1 (Net 500,000) - Campaign A direct AdsSpend (40,000) = 460,000
	campASnap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "campaign", "camp-r04-A", "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot campaign A: %v", err)
	}
	if campASnap.GrossRevenue.String() != "1000000" || campASnap.AdsSpend.String() != "40000" || campASnap.NetProfit.String() != "460000" {
		t.Fatalf("R04 BUG (campaign A): got gross=%s ads=%s net=%s",
			campASnap.GrossRevenue.String(), campASnap.AdsSpend.String(), campASnap.NetProfit.String())
	}

	// 4. Content A snapshot (both by publish_item_id "pub-r04-A" and channel_post_id "post-r04-A"): Gross=1,000,000, Net=500,000
	for _, cid := range []string{"pub-r04-A", "post-r04-A"} {
		contentSnap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "content", cid, "2026-11-01", "2026-11-30", true)
		if err != nil {
			t.Fatalf("GetOrComputeProfitSnapshot content %s: %v", cid, err)
		}
		if contentSnap.GrossRevenue.String() != "1000000" || contentSnap.NetProfit.String() != "500000" {
			t.Fatalf("R04 BUG (content %s): got gross=%s net=%s", cid, contentSnap.GrossRevenue.String(), contentSnap.NetProfit.String())
		}
	}

	// 5. Platform TikTok vs Shopee snapshots
	ttSnap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "platform", "tiktok", "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot platform tiktok: %v", err)
	}
	if ttSnap.GrossRevenue.String() != "1000000" || ttSnap.NetProfit.String() != "500000" {
		t.Fatalf("R04 BUG (platform tiktok): got gross=%s net=%s", ttSnap.GrossRevenue.String(), ttSnap.NetProfit.String())
	}
	spSnap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "platform", "shopee", "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot platform shopee: %v", err)
	}
	if spSnap.GrossRevenue.String() != "2000000" || spSnap.NetProfit.String() != "1000000" {
		t.Fatalf("R04 BUG (platform shopee): got gross=%s net=%s", spSnap.GrossRevenue.String(), spSnap.NetProfit.String())
	}

	// 6. Unsupported scope_type or empty scope_id on entity scope must fail closed with ErrInvalidScopeType / CodeInvalidArgument
	if _, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "unsupported_scope", "id-1", "2026-11-01", "2026-11-30", true); !errors.Is(err, finance.ErrInvalidScopeType) {
		t.Fatalf("expected ErrInvalidScopeType for unsupported scope, got %v", err)
	}
	if _, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "product", "", "2026-11-01", "2026-11-30", true); !errors.Is(err, finance.ErrInvalidScopeType) {
		t.Fatalf("expected ErrInvalidScopeType for empty product scope_id, got %v", err)
	}
	profitHandler := finance.NewProfitHandler(svc)
	_, err = profitHandler.GetSummary(ctx, connect.NewRequest(&financev1.ProfitServiceGetSummaryRequest{
		WorkspaceId: wsID,
		ScopeType:   "unsupported_scope",
		ScopeId:     "id-1",
	}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument from ProfitHandler for unsupported scope, got %v", err)
	}
}

func setupDisposableFinancePostgres(t *testing.T) (*pgxpool.Pool, *pgxpool.Pool) {
	t.Helper()
	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		dsn = os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	}

	if dsn == "" {
		conn, err := net.DialTimeout("tcp", "127.0.0.1:15432", 1*time.Second)
		if err != nil {
			t.Skip("PostgreSQL not reachable on 127.0.0.1:15432 and CREATIVANTA_TEST_DATABASE_URL not set")
		}
		_ = conn.Close()

		suffix := fmt.Sprintf("%d", time.Now().UnixNano()%1000000000)
		roleName := "fin_s9_role_" + suffix
		rolePass := "fin_s9_pw_" + suffix
		dbName := "fin_s9_db_" + suffix

		createCmd := exec.CommandContext(ctx, "docker", "exec", "creativanta-p0-postgres-1",
			"psql", "-U", "creativanta_dev", "-d", "creativanta_dev", "-v", "ON_ERROR_STOP=1",
			"-c", fmt.Sprintf("CREATE ROLE %s WITH LOGIN SUPERUSER PASSWORD '%s';", roleName, rolePass),
			"-c", fmt.Sprintf("CREATE DATABASE %s OWNER %s;", dbName, roleName),
		)
		if out, err := createCmd.CombinedOutput(); err != nil {
			t.Skipf("local disposable docker postgres setup unavailable: %v (%s)", err, string(out))
		}
		dsn = fmt.Sprintf("postgres://%s:%s@127.0.0.1:15432/%s?sslmode=disable", roleName, rolePass, dbName)
		t.Cleanup(func() {
			cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cleanCancel()
			_ = exec.CommandContext(cleanCtx, "docker", "exec", "creativanta-p0-postgres-1",
				"psql", "-U", "creativanta_dev", "-d", "creativanta_dev",
				"-c", fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE);", dbName),
				"-c", fmt.Sprintf("DROP ROLE IF EXISTS %s;", roleName),
			).Run()
		})
	}

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	t.Cleanup(func() { adminPool.Close() })

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}
	_, _ = adminPool.Exec(ctx, `ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw' NOBYPASSRLS`)

	appDSN, err := buildAppUserDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserDSN: %v", err)
	}
	appPool, err := pgxpool.New(ctx, appDSN)
	if err != nil {
		t.Fatalf("connect appPool: %v", err)
	}
	t.Cleanup(func() { appPool.Close() })

	return adminPool, appPool
}

// TestRemediationS9_R12_PostgresRepairQueueAndRestartEndToEnd validates on live PostgreSQL 17
// with app_user RLS:
//   - R12: PostgresStore.ListDataGaps does not falsely flag missing_cogs when COGS is posted via
//     financial_postings, orders.items unit_cogs, or order-scoped cost_items, and returns the
//     order to missing_cogs if the repair cost item is later deleted/reversed.
//   - R03/R04/R11: Correction replay idempotency, scoped profit snapshots, refund durability across
//     service restarts, and cross-tenant isolation on live PostgreSQL.
func TestRemediationS9_R12_PostgresRepairQueueAndRestartEndToEnd(t *testing.T) {
	adminPool, appPool := setupDisposableFinancePostgres(t)
	ctx := context.Background()

	const wsID = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa29"
	const otherWS = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb29"
	const userID = "11111111-1111-4111-8111-111111111129"
	const ordWithLedgerCOGS = "22222222-2222-4222-8222-222222222201"
	const ordWithItemsCOGS = "22222222-2222-4222-8222-222222222202"
	const ordMissingCOGS = "22222222-2222-4222-8222-222222222203"
	const refundID = "33333333-3333-4333-8333-333333333301"
	const prodID = "44444444-4444-4444-8444-444444444401"
	const campID = "55555555-5555-4555-8555-555555555501"
	const contentID = "66666666-6666-4666-8666-666666666601"

	if _, err := adminPool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'r12-user@test.com', 'R12 User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING
	`, userID); err != nil {
		t.Fatalf("seed user: %v", err)
	}
	for _, w := range []struct{ id, slug string }{{wsID, "r12-ws-a"}, {otherWS, "r12-ws-b"}} {
		if _, err := adminPool.Exec(ctx, `
			INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
			VALUES ($1::uuid, $2, $2, $3::uuid, NOW(), NOW())
			ON CONFLICT (workspace_id) DO NOTHING
		`, w.id, w.slug, userID); err != nil {
			t.Fatalf("seed workspace %s: %v", w.slug, err)
		}
	}

	pgStore := finance.NewPostgresStore(appPool)
	svc := finance.NewService(pgStore, nil, nil)

	fx := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
	}
	cogs := tenantdb.MustParseExactDecimal("400000.000000")

	// 1. Order 1 has COGS posted via RecordOrderPosting + product/campaign/content/platform relations
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              ordWithLedgerCOGS,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("100000.000000"),
		COGSAmount:           &cogs,
		Currency:             "VND",
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          time.Date(2026, 11, 5, 10, 0, 0, 0, time.UTC),
		SourcePlatform:       "tiktok",
		ProductID:            prodID,
		CampaignID:           campID,
		ContentID:            contentID,
	}); err != nil {
		t.Fatalf("RecordOrderPosting ordWithLedgerCOGS: %v", err)
	}

	// 2. Order 2 has COGS stored in orders.items JSONB (unit_cogs)
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO orders (
			order_id, workspace_id, source_class, source_platform, lifecycle_state,
			amount, currency, items, fee_breakdown, reconciliation_state, ordered_at
		) VALUES (
			$1::uuid, $2::uuid, 'official', 'shopee', 'completed',
			600000.000000, 'VND',
			'[{"sku":"sku-r12","quantity":2,"unit_price":"300000.000000","unit_cogs":"120000.000000"}]'::jsonb,
			'{}'::jsonb, 'imported_only', '2026-11-05T11:00:00Z'
		)
	`, ordWithItemsCOGS, wsID); err != nil {
		t.Fatalf("insert ordWithItemsCOGS: %v", err)
	}

	// 3. Order 3 has missing COGS
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              ordMissingCOGS,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("800000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("80000.000000"),
		COGSAmount:           nil,
		Currency:             "VND",
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          time.Date(2026, 11, 5, 12, 0, 0, 0, time.UTC),
	}); err != nil {
		t.Fatalf("RecordOrderPosting ordMissingCOGS: %v", err)
	}

	// Verify only ordMissingCOGS is reported as missing_cogs
	gaps, _, _, _, _, err := svc.ListPendingGaps(ctx, wsID, "owner", finance.DataGapFilter{GapType: "missing_cogs"}, 50, 0)
	if err != nil {
		t.Fatalf("ListPendingGaps initial: %v", err)
	}
	foundMissing := false
	for _, g := range gaps {
		if g.RelatedObjectID == ordWithLedgerCOGS || g.RelatedObjectID == ordWithItemsCOGS {
			t.Fatalf("R12 BUG: PostgresStore.ListDataGaps falsely reported missing_cogs for order %s that already has COGS", g.RelatedObjectID)
		}
		if g.RelatedObjectID == ordMissingCOGS {
			foundMissing = true
		}
	}
	if !foundMissing {
		t.Fatalf("expected ordMissingCOGS (%s) in missing_cogs repair queue", ordMissingCOGS)
	}

	// Repair ordMissingCOGS via order-scoped COGS CostItem -> must disappear from missing_cogs queue
	repairCost, err := svc.CreateCostItem(ctx, &finance.CostItem{
		WorkspaceID:      wsID,
		CostType:         "cogs",
		Amount:           tenantdb.MustParseExactDecimal("350000.000000"),
		Currency:         "VND",
		Description:      "Repaired COGS for ordMissingCOGS",
		RelatedScopeType: "order",
		RelatedScopeID:   ordMissingCOGS,
		SourceClass:      finance.SourceClassOfficial,
		CostState:        finance.CostStateRecorded,
		EffectiveDate:    "2026-11-05",
	})
	if err != nil {
		t.Fatalf("CreateCostItem repair COGS: %v", err)
	}

	gapsAfterRepair, _, _, _, _, err := svc.ListPendingGaps(ctx, wsID, "owner", finance.DataGapFilter{GapType: "missing_cogs"}, 50, 0)
	if err != nil {
		t.Fatalf("ListPendingGaps after repair: %v", err)
	}
	for _, g := range gapsAfterRepair {
		if g.RelatedObjectID == ordMissingCOGS {
			t.Fatalf("R12 BUG: ordMissingCOGS still reported as missing_cogs after COGS cost_item repair")
		}
	}

	// Delete the repair CostItem -> ordMissingCOGS must return to missing_cogs queue
	if err := svc.DeleteCostItem(ctx, wsID, repairCost.CostItemID); err != nil {
		t.Fatalf("DeleteCostItem repair COGS: %v", err)
	}
	gapsAfterDelete, _, _, _, _, err := svc.ListPendingGaps(ctx, wsID, "owner", finance.DataGapFilter{GapType: "missing_cogs"}, 50, 0)
	if err != nil {
		t.Fatalf("ListPendingGaps after delete: %v", err)
	}
	returnedToQueue := false
	for _, g := range gapsAfterDelete {
		if g.RelatedObjectID == ordMissingCOGS {
			returnedToQueue = true
		}
	}
	if !returnedToQueue {
		t.Fatalf("R12 BUG: ordMissingCOGS did not return to missing_cogs queue after repair cost_item was deleted")
	}

	// Record refund and fee correction on ordWithLedgerCOGS, replay correction, and restart service on PostgresStore
	if err := svc.RecordRefundPosting(ctx, wsID, refundID, ordWithLedgerCOGS, tenantdb.MustParseExactDecimal("150000.000000"), "VND", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); err != nil {
		t.Fatalf("RecordRefundPosting live PG: %v", err)
	}
	negFeeV2 := tenantdb.MustParseExactDecimal("-120000.000000")
	if err := svc.RecordOrderCorrection(ctx, wsID, ordWithLedgerCOGS, finance.ComponentPlatformFee, negFeeV2, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); err != nil {
		t.Fatalf("RecordOrderCorrection v2 live PG: %v", err)
	}
	if err := svc.RecordOrderCorrection(ctx, wsID, ordWithLedgerCOGS, finance.ComponentPlatformFee, negFeeV2, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fx); err != nil {
		t.Fatalf("RecordOrderCorrection v2 replay live PG: %v", err)
	}

	// Restart service over PostgresStore and verify order, product, campaign, content, and platform snapshots
	svcRestarted := finance.NewService(pgStore, nil, nil)
	for _, scope := range []struct{ scopeType, scopeID string }{
		{"order", ordWithLedgerCOGS},
		{"product", prodID},
		{"campaign", campID},
		{"content", contentID},
		{"platform", "tiktok"},
	} {
		snap, err := svcRestarted.GetOrComputeProfitSnapshot(ctx, wsID, scope.scopeType, scope.scopeID, "2026-11-01", "2026-11-30", true)
		if err != nil {
			t.Fatalf("GetOrComputeProfitSnapshot(%s=%s) on live PG after restart: %v", scope.scopeType, scope.scopeID, err)
		}
		// Gross: 1,000,000; Fee (v2): 120,000; COGS: 400,000; Refund: 150,000 -> Net = 330,000
		if snap.GrossRevenue.String() != "1000000" || snap.PlatformFees.String() != "120000" || snap.RefundDeductions.String() != "150000" || snap.NetProfit.String() != "330000" {
			t.Fatalf("live PG snapshot mismatch for %s=%s after restart: gross=%s fee=%s refund=%s net=%s",
				scope.scopeType, scope.scopeID, snap.GrossRevenue.String(), snap.PlatformFees.String(), snap.RefundDeductions.String(), snap.NetProfit.String())
		}
	}

	// Cross-tenant isolation check on live PostgreSQL: otherWS must see 0 postings, 0 gaps, and 0 revenue
	otherGaps, totalOtherGaps, _, _, _, err := svcRestarted.ListPendingGaps(ctx, otherWS, "owner", finance.DataGapFilter{}, 50, 0)
	if err != nil || totalOtherGaps != 0 || len(otherGaps) != 0 {
		t.Fatalf("cross-tenant leak in ListPendingGaps: total=%d len=%d err=%v", totalOtherGaps, len(otherGaps), err)
	}
	otherSnap, err := svcRestarted.GetOrComputeProfitSnapshot(ctx, otherWS, "order", ordWithLedgerCOGS, "2026-11-01", "2026-11-30", true)
	if err != nil || !otherSnap.GrossRevenue.IsZero() || !otherSnap.NetProfit.IsZero() {
		t.Fatalf("cross-tenant leak in GetOrComputeProfitSnapshot: gross=%s net=%s err=%v", otherSnap.GrossRevenue.String(), otherSnap.NetProfit.String(), err)
	}
}

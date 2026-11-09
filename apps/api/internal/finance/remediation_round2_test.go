package finance_test

import (
	"context"
	"errors"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	financev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// TestRound2_H01_AttributionTenantIsolationAndUnknownOrderRejection verifies that:
// 1. Tenant B cannot read or attribute against Tenant A's cached OrderID.
// 2. Unknown OrderIDs are rejected with ErrOrderNotFound (and CodeNotFound via handler) instead of fabricating a synthetic order.
// 3. Same OrderID across two tenants remains strictly isolated in cache, refunds, and GetContentRevenueAttribution.
func TestRound2_H01_AttributionTenantIsolationAndUnknownOrderRejection(t *testing.T) {
	ctx := context.Background()
	wsA := "11111111-1111-4111-8111-111111111101"
	wsB := "22222222-2222-4222-8222-222222222202"
	eff := time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC)
	fx := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)
	attrHandler := finance.NewAttributionHandler(svc)

	// 1. Tenant A records a completed order of 5,000,000 VND (warms AttributionEngine cache)
	sharedOrderID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsA,
		OrderID:              sharedOrderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("5000000.000000"),
		COGSAmount:           ptrDec("1000000.000000"),
		Currency:             "VND",
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fx,
	}); err != nil {
		t.Fatalf("Tenant A RecordOrderPosting: %v", err)
	}

	// 2. Tenant B attempts to record attribution referencing Tenant A's OrderID via Engine
	_, err := svc.AttributionEngine().RecordAttribution(ctx, &finance.ContentAttributionEntity{
		WorkspaceID:       wsB,
		OrderID:           sharedOrderID,
		ChannelPostID:     "post-tenant-b",
		AttributionType:   "direct",
		RevenueAttributed: tenantdb.MustParseExactDecimal("1000000.000000"),
		SourceClass:       finance.SourceClassImported,
		Confidence:        finance.ConfidenceMedium,
	}, false)
	if !errors.Is(err, finance.ErrOrderNotFound) {
		t.Fatalf("H01 BUG: expected ErrOrderNotFound when Tenant B references Tenant A's OrderID, got %v", err)
	}

	// 3. Tenant B attempts via AttributionHandler RPC
	_, rpcErr := attrHandler.RecordAttribution(ctx, connect.NewRequest(&financev1.AttributionServiceRecordAttributionRequest{
		WorkspaceId:     wsB,
		OrderId:         sharedOrderID,
		ChannelPostId:   "post-tenant-b",
		AttributionType: "direct",
		RevenueAttributed: &commonv1.Money{
			Amount:   "1000000.000000",
			Currency: "VND",
		},
	}))
	if rpcErr == nil || connect.CodeOf(rpcErr) != connect.CodeNotFound {
		t.Fatalf("H01 BUG: expected CodeNotFound from AttributionHandler when Tenant B references Tenant A's OrderID, got %v", rpcErr)
	}

	// 4. Tenant A's order allocation capacity must remain 100% untouched (0 allocated, 5,000,000 remaining)
	allocA, remA := svc.AttributionEngine().GetOrderAllocationStatus(sharedOrderID)
	if !allocA.IsZero() || remA.String() != "5000000" {
		t.Fatalf("H01 BUG: Tenant B mutated Tenant A's order allocation status: alloc=%s rem=%s", allocA.String(), remA.String())
	}

	// 5. Unknown OrderID in Tenant A must also fail closed with ErrOrderNotFound (never fabricate synthetic order)
	_, err = svc.AttributionEngine().RecordAttribution(ctx, &finance.ContentAttributionEntity{
		WorkspaceID:       wsA,
		OrderID:           "99999999-9999-4999-8999-999999999999",
		ChannelPostID:     "post-tenant-a",
		AttributionType:   "direct",
		RevenueAttributed: tenantdb.MustParseExactDecimal("1234567.000000"),
		SourceClass:       finance.SourceClassImported,
		Confidence:        finance.ConfidenceMedium,
	}, false)
	if !errors.Is(err, finance.ErrOrderNotFound) {
		t.Fatalf("H01 BUG: expected ErrOrderNotFound for unknown OrderID, got %v", err)
	}

	// 6. Now Tenant B legitimately records an order with the SAME OrderID (800,000 VND).
	// Verify that Tenant A (5,000,000) and Tenant B (800,000) caches, attributions, refunds, and RPC queries stay strictly isolated.
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsB,
		OrderID:              sharedOrderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("800000.000000"),
		COGSAmount:           ptrDec("200000.000000"),
		Currency:             "VND",
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fx,
	}); err != nil {
		t.Fatalf("Tenant B RecordOrderPosting: %v", err)
	}

	// Tenant B cannot over-allocate using Tenant A's 5,000,000 order amount
	_, err = svc.AttributionEngine().RecordAttribution(ctx, &finance.ContentAttributionEntity{
		WorkspaceID:       wsB,
		OrderID:           sharedOrderID,
		ChannelPostID:     "post-tenant-b",
		AttributionType:   "direct",
		RevenueAttributed: tenantdb.MustParseExactDecimal("1000000.000000"),
		SourceClass:       finance.SourceClassImported,
		Confidence:        finance.ConfidenceMedium,
	}, false)
	if !errors.Is(err, finance.ErrAttributionCapacityExceeded) {
		t.Fatalf("H01 BUG: expected ErrAttributionCapacityExceeded when Tenant B attributes 1,000,000 on 800,000 order, got %v", err)
	}

	// Valid attributions in both tenants on the same OrderID
	if _, err := svc.AttributionEngine().RecordAttribution(ctx, &finance.ContentAttributionEntity{
		WorkspaceID:       wsA,
		OrderID:           sharedOrderID,
		PublishItemID:     "pub-shared",
		ChannelPostID:     "post-shared",
		AttributionType:   "direct",
		RevenueAttributed: tenantdb.MustParseExactDecimal("5000000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}, true); err != nil {
		t.Fatalf("Tenant A RecordAttribution: %v", err)
	}
	if _, err := svc.AttributionEngine().RecordAttribution(ctx, &finance.ContentAttributionEntity{
		WorkspaceID:       wsB,
		OrderID:           sharedOrderID,
		PublishItemID:     "pub-shared",
		ChannelPostID:     "post-shared",
		AttributionType:   "direct",
		RevenueAttributed: tenantdb.MustParseExactDecimal("800000.000000"),
		SourceClass:       finance.SourceClassOfficial,
		Confidence:        finance.ConfidenceHigh,
	}, true); err != nil {
		t.Fatalf("Tenant B RecordAttribution: %v", err)
	}

	// Refund in Tenant B must not deduct from Tenant A
	svc.AttributionEngine().RecordRefundDeductionForWorkspace(wsB, sharedOrderID, tenantdb.MustParseExactDecimal("200000.000000"))

	respA, err := attrHandler.GetByContent(ctx, connect.NewRequest(&financev1.AttributionServiceGetByContentRequest{
		WorkspaceId:   wsA,
		PublishItemId: "pub-shared",
	}))
	if err != nil {
		t.Fatalf("GetByContent wsA: %v", err)
	}
	if respA.Msg.GetSummary().GetTotalAttributedRevenue().GetAmount() != "5000000.000000" &&
		respA.Msg.GetSummary().GetTotalAttributedRevenue().GetAmount() != "5000000" {
		t.Fatalf("H01 BUG: Tenant A revenue affected by Tenant B: got %s, want 5000000", respA.Msg.GetSummary().GetTotalAttributedRevenue().GetAmount())
	}

	respB, err := attrHandler.GetByContent(ctx, connect.NewRequest(&financev1.AttributionServiceGetByContentRequest{
		WorkspaceId:   wsB,
		PublishItemId: "pub-shared",
	}))
	if err != nil {
		t.Fatalf("GetByContent wsB: %v", err)
	}
	if respB.Msg.GetSummary().GetTotalAttributedRevenue().GetAmount() != "800000.000000" &&
		respB.Msg.GetSummary().GetTotalAttributedRevenue().GetAmount() != "800000" {
		t.Fatalf("H01 BUG: Tenant B attributed revenue got %s, want 800000", respB.Msg.GetSummary().GetTotalAttributedRevenue().GetAmount())
	}
	ordA, okA := svc.AttributionEngine().GetCanonicalOrderForWorkspace(wsA, sharedOrderID)
	ordB, okB := svc.AttributionEngine().GetCanonicalOrderForWorkspace(wsB, sharedOrderID)
	if !okA || !okB || ordA.NetRevenue.String() != "5000000" || ordB.NetRevenue.String() != "600000" {
		t.Fatalf("H01 BUG: cross-tenant refund bleed: ordA.NetRevenue=%s ordB.NetRevenue=%s", ordA.NetRevenue.String(), ordB.NetRevenue.String())
	}
}

// TestRound2_H02_HydratedCOGSAndFeesNotDoubleConvertedFX verifies that:
//  1. An order recorded in pending state in USD (with FX 25,000 VND/USD) and then completed in USD
//     with nil COGSAmount (and omitted fees) hydrates COGS and fees without multiplying by FX a second time.
//  2. Replaying the completed order with nil COGSAmount does not double-convert FX.
//  3. A conflicting replay on the same OrderVersion fails with ErrDuplicatePosting without mutating the stored Order.
func TestRound2_H02_HydratedCOGSAndFeesNotDoubleConvertedFX(t *testing.T) {
	ctx := context.Background()
	wsID := "11111111-1111-4111-8111-111111111102"
	eff := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	fxUSDToVND := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "USD",
		RateToBase:    "25000.000000",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)

	orderID := "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
	// Step 1: Pending order in USD: Gross=100 USD, COGS=30 USD, PlatformFee=2 USD, PaymentFee=3 USD, Shipping=4 USD, Commission=5 USD
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "confirmed",
		GrossAmount:          tenantdb.MustParseExactDecimal("100.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("2.000000"),
		PaymentFeeAmount:     tenantdb.MustParseExactDecimal("3.000000"),
		ShippingAmount:       tenantdb.MustParseExactDecimal("4.000000"),
		COGSAmount:           ptrDec("30.000000"),
		CommissionAmount:     tenantdb.MustParseExactDecimal("5.000000"),
		Currency:             "USD",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxUSDToVND,
	}); err != nil {
		t.Fatalf("pending RecordOrderPosting: %v", err)
	}

	// Step 2: Transition to completed in USD, omitting COGSAmount and fees so they hydrate from existingOrd
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("100.000000"),
		Currency:             "USD",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxUSDToVND,
	}); err != nil {
		t.Fatalf("completed RecordOrderPosting: %v", err)
	}

	snap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot: %v", err)
	}
	// Expected in VND (x25,000 once):
	// GrossRevenue = 2,500,000
	// COGS = 750,000 (NOT 18,750,000,000!)
	// PlatformFees = (2 + 3) * 25,000 = 125,000
	// ShippingCosts = 4 * 25,000 = 100,000
	// AffiliateCommissions = 5 * 25,000 = 125,000
	// NetProfit = 2,500,000 - 750,000 - 125,000 - 100,000 - 125,000 = 1,400,000
	if snap.GrossRevenue.String() != "2500000" ||
		snap.COGS.String() != "750000" ||
		snap.PlatformFees.String() != "125000" ||
		snap.ShippingCosts.String() != "100000" ||
		snap.AffiliateCommissions.String() != "125000" ||
		snap.NetProfit.String() != "1400000" {
		t.Fatalf("H02 BUG: double FX conversion on hydrated components: gross=%s cogs=%s fee=%s ship=%s comm=%s net=%s",
			snap.GrossRevenue.String(), snap.COGS.String(), snap.PlatformFees.String(),
			snap.ShippingCosts.String(), snap.AffiliateCommissions.String(), snap.NetProfit.String())
	}

	// Step 3: Conflicting replay on v1 with GrossAmount=200 USD must return ErrDuplicatePosting and NOT overwrite stored Order.Amount
	err = svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("200.000000"),
		Currency:             "USD",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxUSDToVND,
	})
	if !errors.Is(err, finance.ErrDuplicatePosting) {
		t.Fatalf("expected ErrDuplicatePosting on conflicting v1 replay, got %v", err)
	}
	storedOrd, err := store.GetOrder(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("GetOrder: %v", err)
	}
	if storedOrd.Amount.String() != "2500000" {
		t.Fatalf("H02 BUG: conflicting replay mutated stored Order.Amount to %s", storedOrd.Amount.String())
	}
}

type settlementFaultStore struct {
	finance.Store
	failCreateLineCount    int32
	failCreatePostingAfter int32
	createPostingCalls     int32
}

func (f *settlementFaultStore) CreateSettlementLine(ctx context.Context, line *finance.SettlementLine) error {
	if atomic.AddInt32(&f.failCreateLineCount, -1) >= 0 {
		return errors.New("simulated crash during CreateSettlementLine")
	}
	return f.Store.CreateSettlementLine(ctx, line)
}

func (f *settlementFaultStore) CreatePosting(ctx context.Context, post *finance.FinancialPosting) error {
	callNum := atomic.AddInt32(&f.createPostingCalls, 1)
	if f.failCreatePostingAfter > 0 && callNum == f.failCreatePostingAfter {
		return errors.New("simulated crash during CreatePosting")
	}
	return f.Store.CreatePosting(ctx, post)
}

// TestRound2_H03_InterruptedSettlementImportRecoversLinesAndFeesOnRetry verifies that:
//  1. If ImportSettlement fails after CreateSettlement (before CreateSettlementLine), retry completes lines & fee postings.
//  2. If ImportSettlement fails after reversing the order's platform_fee posting (before creating settlement_line fee posting),
//     retry recovers the missing settlement_line fee posting instead of leaving the order with 0 fees permanently.
func TestRound2_H03_InterruptedSettlementImportRecoversLinesAndFeesOnRetry(t *testing.T) {
	ctx := context.Background()
	wsID := "11111111-1111-4111-8111-111111111103"
	eff := time.Date(2026, 11, 3, 12, 0, 0, 0, time.UTC)
	fx := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	baseStore := finance.NewMemoryStore()
	faultStore := &settlementFaultStore{Store: baseStore}
	svc := finance.NewService(faultStore, nil, nil)

	orderID := "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("100000.000000"),
		COGSAmount:           ptrDec("400000.000000"),
		Currency:             "VND",
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassEstimated,
		Confidence:           finance.ConfidenceMedium,
		ExchangeRateSnapshot: fx,
	}); err != nil {
		t.Fatalf("RecordOrderPosting: %v", err)
	}

	// RecordOrderPosting made 3 CreatePosting calls (revenue, platform_fee, cogs).
	// Next CreatePosting call (#4) in ImportSettlement is the order fee reversal;
	// Call #5 is the replacement settlement_line fee posting.
	// Inject a failure on Call #5 (right after the order's 100,000 fee has been reversed!).
	atomic.StoreInt32(&faultStore.createPostingCalls, 0)
	faultStore.failCreatePostingAfter = 2 // 1st in ImportSettlement = reversal, 2nd = replacement (FAILS!)

	makeSettlement := func() (*finance.Settlement, []finance.SettlementLine) {
		return &finance.Settlement{
			WorkspaceID:          wsID,
			ConnectedAccountID:   "acc-shopee-1",
			ExternalSettlementID: "ext-settle-h03-1",
			ImportFingerprint:    "fp-settle-h03-1",
			SourceClass:          finance.SourceClassOfficial,
			GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
			NetAmount:            tenantdb.MustParseExactDecimal("880000.000000"),
			Currency:             "VND",
			EffectiveDate:        "2026-11-03",
			ExchangeRateSnapshot: fx,
		}, []finance.SettlementLine{
			{
				ExternalLineID:  "line-h03-1",
				OrderID:         orderID,
				ExternalOrderID: "ext-ord-h03-1",
				GrossAmount:     tenantdb.MustParseExactDecimal("1000000.000000"),
				FeeAmount:       tenantdb.MustParseExactDecimal("120000.000000"),
				NetAmount:       tenantdb.MustParseExactDecimal("880000.000000"),
				Currency:        "VND",
			},
		}
	}

	sment1, lines1 := makeSettlement()
	if _, err := svc.ImportSettlement(ctx, sment1, lines1); err == nil {
		t.Fatalf("expected simulated crash on first ImportSettlement attempt")
	}

	// Clear fault injection and retry with the same ExternalSettlementID and ImportFingerprint
	faultStore.failCreatePostingAfter = 0
	sment2, lines2 := makeSettlement()
	res, err := svc.ImportSettlement(ctx, sment2, lines2)
	if err != nil {
		t.Fatalf("retry ImportSettlement failed: %v", err)
	}
	if len(res.Lines) != 1 {
		t.Fatalf("H03 BUG: expected 1 settlement line on retry response, got %d", len(res.Lines))
	}

	// Check profit snapshot: PlatformFees MUST be 120,000 (not 0!), NetProfit MUST be 480,000
	snap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot: %v", err)
	}
	if snap.PlatformFees.String() != "120000" || snap.NetProfit.String() != "480000" {
		t.Fatalf("H03 BUG: settlement retry lost platform fee! got PlatformFees=%s NetProfit=%s (want 120000, 480000)",
			snap.PlatformFees.String(), snap.NetProfit.String())
	}

	// 3rd replay with identical payload must be idempotent and keep PlatformFees = 120,000
	sment3, lines3 := makeSettlement()
	if _, err := svc.ImportSettlement(ctx, sment3, lines3); err != nil {
		t.Fatalf("3rd idempotent ImportSettlement failed: %v", err)
	}
	snapAfterReplay, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after 3rd replay: %v", err)
	}
	if snapAfterReplay.PlatformFees.String() != "120000" || snapAfterReplay.NetProfit.String() != "480000" {
		t.Fatalf("H03 BUG: 3rd replay altered snapshot: PlatformFees=%s NetProfit=%s",
			snapAfterReplay.PlatformFees.String(), snapAfterReplay.NetProfit.String())
	}

	// Conflicting retry with different NetAmount for same ExternalSettlementID must fail closed with ErrDuplicateSettlement
	conflictSment, conflictLines := makeSettlement()
	conflictSment.NetAmount = tenantdb.MustParseExactDecimal("500000.000000")
	if _, err := svc.ImportSettlement(ctx, conflictSment, conflictLines); !errors.Is(err, finance.ErrDuplicateSettlement) {
		t.Fatalf("expected ErrDuplicateSettlement on conflicting settlement retry, got %v", err)
	}
}

// TestRound2_M02_FeeCorrectionPreservesPaymentFeeAndSyncsOrderProjection verifies that:
//  1. Recording an order with both FeeAmount (platform fee = 50,000) and PaymentFeeAmount (payment fee = 20,000)
//     and then calling RecordOrderCorrection for ComponentPlatformFee (changing platform fee to -60,000)
//     preserves the 20,000 payment fee (total PlatformFees = 80,000, NOT 60,000).
//  2. RecordOrderFeeBreakdownCorrection updates both platform fee and payment fee atomically and syncs the Order projection.
//  3. RecordOrderCorrection for ComponentPaymentFee updates only payment_fee and syncs the Order projection.
//  4. Subsequent order hydration reads the updated PlatformFeeAmount and PaymentFeeAmount from the Order projection.
func TestRound2_M02_FeeCorrectionPreservesPaymentFeeAndSyncsOrderProjection(t *testing.T) {
	ctx := context.Background()
	wsID := "11111111-1111-4111-8111-111111111105"
	eff := time.Date(2026, 11, 5, 12, 0, 0, 0, time.UTC)
	fx := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)

	orderID := "dddddddd-dddd-4ddd-8ddd-dddddddddddd"
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("50000.000000"),
		PaymentFeeAmount:     tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:           ptrDec("300000.000000"),
		Currency:             "VND",
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassEstimated,
		Confidence:           finance.ConfidenceMedium,
		ExchangeRateSnapshot: fx,
	}); err != nil {
		t.Fatalf("RecordOrderPosting: %v", err)
	}

	// 1. Correct only PlatformFee sub-component to 60,000 via RecordOrderFeeBreakdownCorrection (leaving PaymentFee = 20,000 intact!)
	if err := svc.RecordOrderFeeBreakdownCorrection(
		ctx,
		wsID,
		orderID,
		ptrDec("60000.000000"),
		nil,
		"corr-plat-1",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		fx,
	); err != nil {
		t.Fatalf("RecordOrderFeeBreakdownCorrection (platform_fee only): %v", err)
	}

	snap1, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after platform_fee correction: %v", err)
	}
	// Total PlatformFees MUST be 60,000 (corrected platform fee) + 20,000 (preserved payment fee) = 80,000!
	if snap1.PlatformFees.String() != "80000" {
		t.Fatalf("M02 BUG: platform_fee correction wiped out payment_fee! got PlatformFees=%s, want 80000", snap1.PlatformFees.String())
	}

	// 2. Correct ComponentPaymentFee to -30,000 (leaving PlatformFee = 60,000 intact!)
	if err := svc.RecordOrderCorrection(
		ctx,
		wsID,
		orderID,
		finance.ComponentPaymentFee,
		tenantdb.MustParseExactDecimal("-30000.000000"),
		"corr-pay-1",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		fx,
	); err != nil {
		t.Fatalf("RecordOrderCorrection (payment_fee): %v", err)
	}

	snap2, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after payment_fee correction: %v", err)
	}
	if snap2.PlatformFees.String() != "90000" {
		t.Fatalf("M02 BUG: after payment_fee correction got PlatformFees=%s, want 90000", snap2.PlatformFees.String())
	}

	// 3. Use RecordOrderFeeBreakdownCorrection to set PlatformFee=55,000 and PaymentFee=25,000 (total 80,000)
	if err := svc.RecordOrderFeeBreakdownCorrection(
		ctx,
		wsID,
		orderID,
		ptrDec("55000.000000"),
		ptrDec("25000.000000"),
		"corr-both-1",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		fx,
	); err != nil {
		t.Fatalf("RecordOrderFeeBreakdownCorrection: %v", err)
	}

	ord, err := store.GetOrder(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("GetOrder: %v", err)
	}
	if ord.PlatformFeeAmount.String() != "55000" || ord.PaymentFeeAmount.String() != "25000" {
		t.Fatalf("M02 BUG: Order projection not synced after fee correction: PlatformFee=%s PaymentFee=%s",
			ord.PlatformFeeAmount.String(), ord.PaymentFeeAmount.String())
	}

	// 4. Subsequent revenue correction on the order preserves the corrected 55,000 + 25,000 = 80,000 fees
	if err := svc.RecordOrderCorrection(
		ctx,
		wsID,
		orderID,
		finance.ComponentRevenue,
		tenantdb.MustParseExactDecimal("1200000.000000"),
		"corr-rev-1",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		fx,
	); err != nil {
		t.Fatalf("RecordOrderCorrection (revenue): %v", err)
	}
	snap3, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after revenue correction: %v", err)
	}
	if snap3.GrossRevenue.String() != "1200000" || snap3.PlatformFees.String() != "80000" || snap3.COGS.String() != "300000" || snap3.NetProfit.String() != "820000" {
		t.Fatalf("M02 BUG: after revenue correction got Gross=%s PlatformFees=%s COGS=%s NetProfit=%s (want 1200000, 80000, 300000, 820000)",
			snap3.GrossRevenue.String(), snap3.PlatformFees.String(), snap3.COGS.String(), snap3.NetProfit.String())
	}
}

type costItemBarrierStore struct {
	finance.Store
	updateReady chan struct{}
	bothRead    chan struct{}
	postDone    chan struct{}
	updateCalls int32
	listCalls   int32
}

func (b *costItemBarrierStore) UpdateCostItem(ctx context.Context, item *finance.CostItem) error {
	call := atomic.AddInt32(&b.updateCalls, 1)
	if call == 2 && b.updateReady != nil {
		select {
		case <-b.updateReady:
		case <-time.After(500 * time.Millisecond):
		}
	}
	err := b.Store.UpdateCostItem(ctx, item)
	if call == 1 && b.updateReady != nil {
		close(b.updateReady)
	}
	return err
}

func (b *costItemBarrierStore) ListPostings(ctx context.Context, workspaceID string, filter finance.PostingFilter) ([]finance.FinancialPosting, error) {
	if filter.OriginType == "cost_item" && b.bothRead != nil {
		call := atomic.AddInt32(&b.listCalls, 1)
		if call <= 2 {
			res, err := b.Store.ListPostings(ctx, workspaceID, filter)
			if call == 2 {
				close(b.bothRead)
				select {
				case <-b.postDone:
				case <-time.After(500 * time.Millisecond):
				}
			} else if call == 1 {
				select {
				case <-b.bothRead:
				case <-time.After(500 * time.Millisecond):
				}
			}
			return res, err
		}
	}
	return b.Store.ListPostings(ctx, workspaceID, filter)
}

func (b *costItemBarrierStore) CreatePosting(ctx context.Context, post *finance.FinancialPosting) error {
	err := b.Store.CreatePosting(ctx, post)
	if post.OriginType == "cost_item" && post.ReversalOf == nil && post.OriginVersion == "v2" && b.postDone != nil {
		select {
		case <-b.postDone:
		default:
			close(b.postDone)
		}
	}
	return err
}

// TestRound2_M04_ConcurrentUpdateCostItemKeepsLedgerConsistentWithCostItem verifies that:
// Two concurrent UpdateCostItem calls cannot succeed with cost_items.amount diverging from the active ledger posting.
func TestRound2_M04_ConcurrentUpdateCostItemKeepsLedgerConsistentWithCostItem(t *testing.T) {
	ctx := context.Background()
	wsID := "11111111-1111-4111-8111-111111111104"

	baseStore := finance.NewMemoryStore()
	barrierStore := &costItemBarrierStore{
		Store:       baseStore,
		updateReady: make(chan struct{}),
		bothRead:    make(chan struct{}),
		postDone:    make(chan struct{}),
	}
	// Use two Service instances sharing the same underlying store to simulate multi-instance concurrency
	svc1 := finance.NewService(barrierStore, nil, nil)
	svc2 := finance.NewService(barrierStore, nil, nil)

	created, err := svc1.CreateCostItem(ctx, &finance.CostItem{
		WorkspaceID:   wsID,
		CostType:      "ads_spend",
		Amount:        tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:      "VND",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveDate: "2026-11-04",
	})
	if err != nil {
		t.Fatalf("CreateCostItem: %v", err)
	}

	var wg sync.WaitGroup
	wg.Add(2)
	go func() {
		defer wg.Done()
		_, _ = svc1.UpdateCostItem(ctx, &finance.CostItem{
			WorkspaceID:   wsID,
			CostItemID:    created.CostItemID,
			CostType:      "ads_spend",
			Amount:        tenantdb.MustParseExactDecimal("120000.000000"),
			Currency:      "VND",
			SourceClass:   finance.SourceClassOfficial,
			EffectiveDate: "2026-11-04",
		})
	}()
	go func() {
		defer wg.Done()
		_, _ = svc2.UpdateCostItem(ctx, &finance.CostItem{
			WorkspaceID:   wsID,
			CostItemID:    created.CostItemID,
			CostType:      "ads_spend",
			Amount:        tenantdb.MustParseExactDecimal("130000.000000"),
			Currency:      "VND",
			SourceClass:   finance.SourceClassOfficial,
			EffectiveDate: "2026-11-04",
		})
	}()
	wg.Wait()

	finalItem, err := baseStore.GetCostItem(ctx, wsID, created.CostItemID)
	if err != nil {
		t.Fatalf("GetCostItem: %v", err)
	}
	postings, err := baseStore.ListPostings(ctx, wsID, finance.PostingFilter{
		OriginType: "cost_item",
		OriginID:   created.CostItemID,
	})
	if err != nil {
		t.Fatalf("ListPostings: %v", err)
	}
	summary, err := finance.SummarizePostings(postings, false)
	if err != nil {
		t.Fatalf("SummarizePostings: %v", err)
	}
	if summary.AdsSpend.Cmp(finalItem.Amount) != 0 {
		t.Fatalf("M04 BUG: cost_items.amount (%s) diverged from active ledger AdsSpend (%s)",
			finalItem.Amount.String(), summary.AdsSpend.String())
	}
}

func TestRound2_LivePostgres_AllFindingsEndToEnd(t *testing.T) {
	adminPool, appPool := setupDisposableFinancePostgres(t)
	ctx := context.Background()

	const (
		userID = "11111111-1111-4111-8111-111111111199"
		wsA    = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa91"
		wsB    = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb92"
		ordH01 = "22222222-2222-4222-8222-222222222291"
		ordH02 = "22222222-2222-4222-8222-222222222292"
		ordM02 = "22222222-2222-4222-8222-222222222294"
	)

	if _, err := adminPool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'round2-pg@test.com', 'Round2 PG User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING
	`, userID); err != nil {
		t.Fatalf("seed user: %v", err)
	}
	for _, w := range []struct{ id, slug string }{{wsA, "r2-ws-a"}, {wsB, "r2-ws-b"}} {
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
	eff := time.Date(2026, 11, 6, 12, 0, 0, 0, time.UTC)
	fxVND := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}
	fxUSD := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "USD",
		RateToBase:    "25000.000000",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	// 1. Live PG H01: Tenant A records order; Tenant B must get ErrOrderNotFound
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsA,
		OrderID:              ordH01,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("3000000.000000"),
		COGSAmount:           ptrDec("1000000.000000"),
		Currency:             "VND",
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxVND,
	}); err != nil {
		t.Fatalf("PG H01 RecordOrderPosting: %v", err)
	}
	if _, err := svc.AttributionEngine().RecordAttribution(ctx, &finance.ContentAttributionEntity{
		WorkspaceID:       wsB,
		OrderID:           ordH01,
		ChannelPostID:     "pg-post-b",
		AttributionType:   "direct",
		RevenueAttributed: tenantdb.MustParseExactDecimal("500000.000000"),
		SourceClass:       finance.SourceClassImported,
		Confidence:        finance.ConfidenceMedium,
	}, false); !errors.Is(err, finance.ErrOrderNotFound) {
		t.Fatalf("PG H01: expected ErrOrderNotFound when wsB attributes wsA order, got %v", err)
	}

	// 2. Live PG H02: Pending order in USD persisted to Postgres, then completed across a fresh Service instance omitting COGS/fees
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsA,
		OrderID:              ordH02,
		OrderVersion:         "v1",
		LifecycleState:       "confirmed",
		GrossAmount:          tenantdb.MustParseExactDecimal("100.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("2.000000"),
		PaymentFeeAmount:     tenantdb.MustParseExactDecimal("3.000000"),
		ShippingAmount:       tenantdb.MustParseExactDecimal("4.000000"),
		COGSAmount:           ptrDec("30.000000"),
		CommissionAmount:     tenantdb.MustParseExactDecimal("5.000000"),
		Currency:             "USD",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxUSD,
	}); err != nil {
		t.Fatalf("PG H02 confirmed RecordOrderPosting: %v", err)
	}

	// Fresh service instance forces hydration from PostgreSQL orders table (not in-memory pendingOrders)
	svcRestarted := finance.NewService(pgStore, nil, nil)
	if err := svcRestarted.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsA,
		OrderID:              ordH02,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("100.000000"),
		Currency:             "USD",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxUSD,
	}); err != nil {
		t.Fatalf("PG H02 completed RecordOrderPosting: %v", err)
	}
	snapH02, err := svcRestarted.GetOrComputeProfitSnapshot(ctx, wsA, "order", ordH02, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("PG H02 GetOrComputeProfitSnapshot: %v", err)
	}
	if snapH02.COGS.String() != "750000" || snapH02.PlatformFees.String() != "125000" || snapH02.NetProfit.String() != "1400000" {
		t.Fatalf("PG H02 BUG: got COGS=%s PlatformFees=%s NetProfit=%s (want 750000, 125000, 1400000)",
			snapH02.COGS.String(), snapH02.PlatformFees.String(), snapH02.NetProfit.String())
	}

	// 3. Live PG M02: Platform fee correction preserves PaymentFeeAmount in PostgreSQL
	if err := svcRestarted.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsA,
		OrderID:              ordM02,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("50000.000000"),
		PaymentFeeAmount:     tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:           ptrDec("300000.000000"),
		Currency:             "VND",
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassEstimated,
		Confidence:           finance.ConfidenceMedium,
		ExchangeRateSnapshot: fxVND,
	}); err != nil {
		t.Fatalf("PG M02 RecordOrderPosting: %v", err)
	}
	if err := svcRestarted.RecordOrderFeeBreakdownCorrection(
		ctx,
		wsA,
		ordM02,
		ptrDec("60000.000000"),
		nil,
		"corr-pg-plat-1",
		finance.SourceClassOfficial,
		finance.ConfidenceHigh,
		fxVND,
	); err != nil {
		t.Fatalf("PG M02 RecordOrderFeeBreakdownCorrection: %v", err)
	}
	snapM02, err := svcRestarted.GetOrComputeProfitSnapshot(ctx, wsA, "order", ordM02, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("PG M02 GetOrComputeProfitSnapshot: %v", err)
	}
	if snapM02.PlatformFees.String() != "80000" {
		t.Fatalf("PG M02 BUG: expected PlatformFees=80000 (60000 + 20000), got %s", snapM02.PlatformFees.String())
	}

	// 4. Live PG M04: Concurrent UpdateCostItem against PostgresStore keeps cost_items and financial_postings in lockstep
	ci, err := svcRestarted.CreateCostItem(ctx, &finance.CostItem{
		WorkspaceID:   wsA,
		CostType:      "ads_spend",
		Amount:        tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:      "VND",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveDate: "2026-11-06",
	})
	if err != nil {
		t.Fatalf("PG M04 CreateCostItem: %v", err)
	}
	var wg sync.WaitGroup
	for _, amt := range []string{"150000.000000", "175000.000000", "200000.000000"} {
		amt := amt
		wg.Add(1)
		go func() {
			defer wg.Done()
			sInst := finance.NewService(pgStore, nil, nil)
			_, _ = sInst.UpdateCostItem(ctx, &finance.CostItem{
				WorkspaceID:   wsA,
				CostItemID:    ci.CostItemID,
				CostType:      "ads_spend",
				Amount:        tenantdb.MustParseExactDecimal(amt),
				Currency:      "VND",
				SourceClass:   finance.SourceClassOfficial,
				EffectiveDate: "2026-11-06",
			})
		}()
	}
	wg.Wait()

	finalCI, err := pgStore.GetCostItem(ctx, wsA, ci.CostItemID)
	if err != nil {
		t.Fatalf("PG M04 GetCostItem: %v", err)
	}
	ciPostings, err := pgStore.ListPostings(ctx, wsA, finance.PostingFilter{
		OriginType: "cost_item",
		OriginID:   ci.CostItemID,
	})
	if err != nil {
		t.Fatalf("PG M04 ListPostings: %v", err)
	}
	ciSummary, err := finance.SummarizePostings(ciPostings, false)
	if err != nil {
		t.Fatalf("PG M04 SummarizePostings: %v", err)
	}
	if ciSummary.AdsSpend.Cmp(finalCI.Amount) != 0 {
		t.Fatalf("PG M04 BUG: cost_items.amount (%s) != ledger AdsSpend (%s)",
			finalCI.Amount.String(), ciSummary.AdsSpend.String())
	}
}

func ptrDec(s string) *tenantdb.ExactDecimal {
	d := tenantdb.MustParseExactDecimal(s)
	return &d
}

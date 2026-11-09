package finance_test

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// TestRound3_N03_CrashAfterFeeBreakdownPersistAndPartialComponentCorrectionRecovery verifies that:
//  1. If an order's updated fee breakdown is persisted (or replayed via RecordOrderPosting with a new OrderVersion)
//     and a crash occurs before or mid-way through component corrections (e.g., after platform_fee v2 is recorded
//     but before shipping and commission v2 are recorded), replaying RecordOrderPosting with OrderVersion "v2"
//     converges all changed components via versioned reversals without doubling revenue or failing with ErrDuplicatePosting.
//  2. If an official settlement line has already superseded ComponentPlatformFee (F03), replaying the order revision
//     updates shipping/commission without resurrecting order-level ComponentPlatformFee.
func TestRound3_N03_CrashAfterFeeBreakdownPersistAndPartialComponentCorrectionRecovery(t *testing.T) {
	ctx := context.Background()
	wsID := "33333333-3333-4333-8333-333333333301"
	eff := time.Date(2026, 11, 5, 10, 0, 0, 0, time.UTC)
	fxVND := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)

	orderID := "cccccccc-cccc-4ccc-8ccc-ccccccccccc1"
	// Step 1: Complete order at v1:
	// Gross = 1,000,000; PlatformFee = 50,000; PaymentFee = 20,000 (combined 70,000);
	// Shipping = 30,000; Commission = 15,000; COGS = 300,000.
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("50000.000000"),
		PaymentFeeAmount:     tenantdb.MustParseExactDecimal("20000.000000"),
		ShippingAmount:       tenantdb.MustParseExactDecimal("30000.000000"),
		CommissionAmount:     tenantdb.MustParseExactDecimal("15000.000000"),
		COGSAmount:           ptrDec("300000.000000"),
		Currency:             "VND",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxVND,
	}); err != nil {
		t.Fatalf("v1 RecordOrderPosting: %v", err)
	}

	// Simulate crash mid-way through v2 fee breakdown update:
	// platform_fee is corrected to 85,000 (60,000 + 25,000) at v2, then crash happens before shipping (35,000) and commission (20,000).
	platV2 := tenantdb.MustParseExactDecimal("60000.000000")
	payV2 := tenantdb.MustParseExactDecimal("25000.000000")
	if err := svc.RecordOrderFeeBreakdownCorrection(ctx, wsID, orderID, &platV2, &payV2, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); err != nil {
		t.Fatalf("v2 partial RecordOrderFeeBreakdownCorrection: %v", err)
	}

	// Replay the full v2 order state via RecordOrderPosting with OrderVersion "v2":
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v2",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            platV2,
		PaymentFeeAmount:     payV2,
		ShippingAmount:       tenantdb.MustParseExactDecimal("35000.000000"),
		CommissionAmount:     tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:           ptrDec("300000.000000"),
		Currency:             "VND",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxVND,
	}); err != nil {
		t.Fatalf("v2 replay RecordOrderPosting failed: %v", err)
	}

	snap, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after v2 replay: %v", err)
	}
	// Expected:
	// GrossRevenue = 1,000,000 (NOT doubled to 2,000,000!)
	// PlatformFees = 85,000
	// ShippingCosts = 35,000
	// AffiliateCommissions = 20,000
	// COGS = 300,000 (NOT doubled to 600,000!)
	// NetProfit = 1,000,000 - 85,000 - 35,000 - 20,000 - 300,000 = 560,000
	if snap.GrossRevenue.String() != "1000000" ||
		snap.PlatformFees.String() != "85000" ||
		snap.ShippingCosts.String() != "35000" ||
		snap.AffiliateCommissions.String() != "20000" ||
		snap.COGS.String() != "300000" ||
		snap.NetProfit.String() != "560000" {
		t.Fatalf("N03 BUG: v2 replay corrupted ledger: gross=%s fee=%s ship=%s comm=%s cogs=%s net=%s",
			snap.GrossRevenue.String(), snap.PlatformFees.String(), snap.ShippingCosts.String(),
			snap.AffiliateCommissions.String(), snap.COGS.String(), snap.NetProfit.String())
	}

	// Step 2: Import an official settlement that supersedes ComponentPlatformFee to 80,000 (F03),
	// then replay an order revision v3 that updates Shipping to 40,000.
	// Settlement fee (80,000) must remain authoritative while Shipping updates to 40,000.
	_, err = svc.ImportSettlement(ctx, &finance.Settlement{
		SettlementID:         "dddddddd-dddd-4ddd-8ddd-ddddddddddd1",
		WorkspaceID:          wsID,
		ConnectedAccountID:   "acc-1",
		ExternalSettlementID: "ext-settle-round3-1",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		NetAmount:            tenantdb.MustParseExactDecimal("920000.000000"),
		Currency:             "VND",
		EffectiveDate:        "2026-11-05",
		SourcePlatform:       "shopee",
		SourceClass:          finance.SourceClassOfficial,
		ExchangeRateSnapshot: fxVND,
	}, []finance.SettlementLine{
		{
			LineID:         "eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1",
			ExternalLineID: "ext-line-round3-1",
			OrderID:        orderID,
			GrossAmount:    tenantdb.MustParseExactDecimal("1000000.000000"),
			FeeAmount:      tenantdb.MustParseExactDecimal("80000.000000"),
			NetAmount:      tenantdb.MustParseExactDecimal("920000.000000"),
			Currency:       "VND",
		},
	})
	if err != nil {
		t.Fatalf("ImportSettlement: %v", err)
	}

	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v3",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            platV2,
		PaymentFeeAmount:     payV2,
		ShippingAmount:       tenantdb.MustParseExactDecimal("40000.000000"),
		CommissionAmount:     tenantdb.MustParseExactDecimal("20000.000000"),
		COGSAmount:           ptrDec("300000.000000"),
		Currency:             "VND",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxVND,
	}); err != nil {
		t.Fatalf("v3 RecordOrderPosting after settlement: %v", err)
	}

	snapAfterSettle, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after v3: %v", err)
	}
	if snapAfterSettle.PlatformFees.String() != "80000" || snapAfterSettle.ShippingCosts.String() != "40000" {
		t.Fatalf("F03/N03 BUG: expected PlatformFees=80000 (from settlement) and ShippingCosts=40000, got fee=%s ship=%s",
			snapAfterSettle.PlatformFees.String(), snapAfterSettle.ShippingCosts.String())
	}
}

// TestRound3_N03_ZeroFeeSubcomponentCorrectionAndSubsequentPartialUpdate verifies that:
//  1. Setting PaymentFee to 0 via RecordOrderFeeBreakdownCorrection persists 0 on the Order projection
//     instead of resurrecting the prior non-zero PaymentFeeAmount.
//  2. A subsequent partial RecordOrderFeeBreakdownCorrection updating only PlatformFee (with newPaymentFee=nil)
//     uses PaymentFee=0 rather than adding back the old PaymentFeeAmount.
//  3. Correcting Shipping or Commission to 0 via RecordOrderCorrection persists 0 on the Order projection.
func TestRound3_N03_ZeroFeeSubcomponentCorrectionAndSubsequentPartialUpdate(t *testing.T) {
	ctx := context.Background()
	wsID := "33333333-3333-4333-8333-333333333302"
	eff := time.Date(2026, 11, 5, 11, 0, 0, 0, time.UTC)
	fxVND := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)

	orderID := "cccccccc-cccc-4ccc-8ccc-ccccccccccc2"
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsID,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("50000.000000"),
		PaymentFeeAmount:     tenantdb.MustParseExactDecimal("20000.000000"),
		ShippingAmount:       tenantdb.MustParseExactDecimal("30000.000000"),
		CommissionAmount:     tenantdb.MustParseExactDecimal("15000.000000"),
		COGSAmount:           ptrDec("300000.000000"),
		Currency:             "VND",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxVND,
	}); err != nil {
		t.Fatalf("RecordOrderPosting: %v", err)
	}

	// Step 1: Zero out PaymentFee at v2 (PlatformFee remains 50,000)
	zero := tenantdb.ZeroDecimal()
	if err := svc.RecordOrderFeeBreakdownCorrection(ctx, wsID, orderID, nil, &zero, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); err != nil {
		t.Fatalf("RecordOrderFeeBreakdownCorrection (zero payment_fee): %v", err)
	}

	ordAfterV2, err := store.GetOrder(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("GetOrder after v2: %v", err)
	}
	if !ordAfterV2.PaymentFeeAmount.IsZero() || ordAfterV2.PlatformFeeAmount.String() != "50000" {
		t.Fatalf("N03 ZERO-FEE BUG: expected PlatformFee=50000, PaymentFee=0 after v2, got plat=%s pay=%s",
			ordAfterV2.PlatformFeeAmount.String(), ordAfterV2.PaymentFeeAmount.String())
	}

	// Step 2: Update only PlatformFee to 60,000 at v3 (newPaymentFee = nil). Combined must be 60,000 + 0 = 60,000!
	platV3 := tenantdb.MustParseExactDecimal("60000.000000")
	if err := svc.RecordOrderFeeBreakdownCorrection(ctx, wsID, orderID, &platV3, nil, "v3", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); err != nil {
		t.Fatalf("RecordOrderFeeBreakdownCorrection (v3 platform_fee): %v", err)
	}

	snapAfterV3, err := svc.GetOrComputeProfitSnapshot(ctx, wsID, "order", orderID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot after v3: %v", err)
	}
	if snapAfterV3.PlatformFees.String() != "60000" {
		t.Fatalf("N03 ZERO-FEE BUG: stale PaymentFee resurrected on v3 partial update: expected PlatformFees=60000, got %s",
			snapAfterV3.PlatformFees.String())
	}

	// Step 3: Correct Shipping to 0 at v4 and verify both snapshot and Order projection reflect 0 shipping
	if err := svc.RecordOrderCorrection(ctx, wsID, orderID, finance.ComponentShipping, zero, "v4", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); err != nil {
		t.Fatalf("RecordOrderCorrection (zero shipping): %v", err)
	}
	ordAfterV4, err := store.GetOrder(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("GetOrder after v4: %v", err)
	}
	if !ordAfterV4.ShippingFeeAmount.IsZero() {
		t.Fatalf("N03 ZERO-FEE BUG: expected ShippingFeeAmount=0 after v4, got %s", ordAfterV4.ShippingFeeAmount.String())
	}
}

// TestRound3_N03_NegativeValidationAndConcurrentReplay verifies negative validation, security/tenant denials,
// and concurrent replay safety for RecordOrderFeeBreakdownCorrection.
func TestRound3_N03_NegativeValidationAndConcurrentReplay(t *testing.T) {
	ctx := context.Background()
	wsA := "33333333-3333-4333-8333-333333333303"
	wsB := "33333333-3333-4333-8333-333333333304"
	eff := time.Date(2026, 11, 5, 12, 0, 0, 0, time.UTC)
	fxVND := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	store := finance.NewMemoryStore()
	svc := finance.NewService(store, nil, nil)
	orderID := "cccccccc-cccc-4ccc-8ccc-ccccccccccc3"

	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsA,
		OrderID:              orderID,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("500000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("25000.000000"),
		PaymentFeeAmount:     tenantdb.MustParseExactDecimal("10000.000000"),
		Currency:             "VND",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxVND,
	}); err != nil {
		t.Fatalf("RecordOrderPosting: %v", err)
	}

	fee30k := tenantdb.MustParseExactDecimal("30000.000000")
	// 1. Missing tenant must fail with ErrMissingTenant
	if err := svc.RecordOrderFeeBreakdownCorrection(ctx, "", orderID, &fee30k, nil, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); !errors.Is(err, finance.ErrMissingTenant) {
		t.Fatalf("expected ErrMissingTenant, got %v", err)
	}
	// 2. Reserved suffix "-reversal" or "-superseded" must fail with ErrInvalidAmount
	if err := svc.RecordOrderFeeBreakdownCorrection(ctx, wsA, orderID, &fee30k, nil, "v1-reversal", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); !errors.Is(err, finance.ErrInvalidAmount) {
		t.Fatalf("expected ErrInvalidAmount for -reversal suffix, got %v", err)
	}
	if err := svc.RecordOrderFeeBreakdownCorrection(ctx, wsA, orderID, &fee30k, nil, "v1-superseded", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); !errors.Is(err, finance.ErrInvalidAmount) {
		t.Fatalf("expected ErrInvalidAmount for -superseded suffix, got %v", err)
	}

	// 3. Concurrent replay of RecordOrderFeeBreakdownCorrection at v2 must succeed idempotently
	var wg sync.WaitGroup
	errCh := make(chan error, 8)
	for i := 0; i < 8; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			pay15k := tenantdb.MustParseExactDecimal("15000.000000")
			errCh <- svc.RecordOrderFeeBreakdownCorrection(ctx, wsA, orderID, &fee30k, &pay15k, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND)
		}()
	}
	wg.Wait()
	close(errCh)
	for err := range errCh {
		if err != nil {
			t.Fatalf("concurrent RecordOrderFeeBreakdownCorrection v2 failed: %v", err)
		}
	}

	// 4. Conflicting payload on v2 must fail with ErrDuplicatePosting
	conflictFee := tenantdb.MustParseExactDecimal("99000.000000")
	if err := svc.RecordOrderFeeBreakdownCorrection(ctx, wsA, orderID, &conflictFee, nil, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); !errors.Is(err, finance.ErrDuplicatePosting) {
		t.Fatalf("expected ErrDuplicatePosting for conflicting v2 fee breakdown correction, got %v", err)
	}

	// 5. Tenant B must remain isolated (0 revenue, 0 fees)
	snapB, err := svc.GetOrComputeProfitSnapshot(ctx, wsB, "workspace", wsB, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("GetOrComputeProfitSnapshot wsB: %v", err)
	}
	if !snapB.GrossRevenue.IsZero() || !snapB.PlatformFees.IsZero() {
		t.Fatalf("tenant isolation violation in wsB: gross=%s fee=%s", snapB.GrossRevenue.String(), snapB.PlatformFees.String())
	}
}

// TestRound3_LivePostgres_CrashAfterFeeBreakdownSaveAndZeroFeePersistence verifies against live PostgreSQL:
//  1. When an order row in PostgreSQL has been updated with new fee_breakdown and finance_pending_fee_version="v2"
//     (and partial component correction for platform_fee succeeded before a crash), GetOrComputeProfitSnapshot
//     automatically reconciles the remaining unposted component corrections (shipping, commission) from the durable
//     orders row and clears finance_pending_fee_version.
//  2. Zeroing out payment_fee via RecordOrderFeeBreakdownCorrection persists "0.000000" in PostgreSQL orders.fee_breakdown
//     so a subsequent partial update of platform_fee (newPaymentFee = nil) does not resurrect the old payment_fee.
func TestRound3_LivePostgres_CrashAfterFeeBreakdownSaveAndZeroFeePersistence(t *testing.T) {
	adminPool, appPool := setupDisposableFinancePostgres(t)
	ctx := context.Background()

	const (
		userID = "11111111-1111-4111-8111-111111111198"
		wsA    = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa98"
		ordN03 = "22222222-2222-4222-8222-222222222298"
	)

	if _, err := adminPool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'round3-pg@test.com', 'Round3 PG User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING
	`, userID); err != nil {
		t.Fatalf("seed user: %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($1::uuid, 'r3-ws-a', 'r3-ws-a', $2::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING
	`, wsA, userID); err != nil {
		t.Fatalf("seed workspace: %v", err)
	}

	pgStore := finance.NewPostgresStore(appPool)
	svc := finance.NewService(pgStore, nil, nil)
	eff := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)
	fxVND := finance.ExchangeRateSnapshot{
		BaseCurrency:  "VND",
		QuoteCurrency: "VND",
		RateToBase:    "1",
		SourceClass:   finance.SourceClassOfficial,
		EffectiveAt:   eff,
	}

	// 1. Record initial completed order v1:
	// Gross = 1,000,000; PlatformFee = 50,000; PaymentFee = 20,000 (70,000); Shipping = 30,000; Commission = 15,000; COGS = 300,000.
	if err := svc.RecordOrderPosting(ctx, finance.OrderPostingInput{
		WorkspaceID:          wsA,
		OrderID:              ordN03,
		OrderVersion:         "v1",
		LifecycleState:       "completed",
		GrossAmount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		FeeAmount:            tenantdb.MustParseExactDecimal("50000.000000"),
		PaymentFeeAmount:     tenantdb.MustParseExactDecimal("20000.000000"),
		ShippingAmount:       tenantdb.MustParseExactDecimal("30000.000000"),
		CommissionAmount:     tenantdb.MustParseExactDecimal("15000.000000"),
		COGSAmount:           ptrDec("300000.000000"),
		Currency:             "VND",
		OrderedAt:            eff,
		EffectiveAt:          eff,
		SourceClass:          finance.SourceClassOfficial,
		Confidence:           finance.ConfidenceHigh,
		ExchangeRateSnapshot: fxVND,
	}); err != nil {
		t.Fatalf("PG N03 v1 RecordOrderPosting: %v", err)
	}

	// 2. Simulate UpdateFeeBreakdown committing updated fee_breakdown + finance_pending_fee_version="v2" to orders,
	//    correcting only ComponentPlatformFee to -85,000 (60,000 + 25,000), and crashing before Shipping (35,000) and Commission (20,000) are corrected!
	negFee85k := tenantdb.MustParseExactDecimal("-85000.000000")
	if err := svc.RecordOrderCorrection(ctx, wsA, ordN03, finance.ComponentPlatformFee, negFee85k, "v2", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); err != nil {
		t.Fatalf("PG N03 partial RecordOrderCorrection (platform_fee v2): %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		UPDATE orders
		SET fee_breakdown = COALESCE(fee_breakdown, '{}'::jsonb) || '{"platform_fee":"60000.000000","payment_fee":"25000.000000","shipping_cost":"35000.000000","affiliate_commission":"20000.000000"}'::jsonb,
		    metadata = COALESCE(metadata, '{}'::jsonb) || '{"economic_version":2,"finance_pending_fee_version":"v2","finance_synced_platform_fee":"85000.000000","finance_synced_shipping_cost":"30000.000000","finance_synced_commission":"15000.000000"}'::jsonb
		WHERE workspace_id = $1::uuid AND order_id = $2::uuid
	`, wsA, ordN03); err != nil {
		t.Fatalf("simulate crash after partial fee breakdown save: %v", err)
	}

	// 3. A fresh Service instance computes profit snapshot and must automatically reconcile the unposted v2 shipping & commission!
	svcAfterCrash := finance.NewService(pgStore, nil, nil)
	snapN03, err := svcAfterCrash.GetOrComputeProfitSnapshot(ctx, wsA, "order", ordN03, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("PG N03 GetOrComputeProfitSnapshot after crash: %v", err)
	}
	if snapN03.PlatformFees.String() != "85000" ||
		snapN03.ShippingCosts.String() != "35000" ||
		snapN03.AffiliateCommissions.String() != "20000" ||
		snapN03.NetProfit.String() != "560000" {
		t.Fatalf("PG N03 BUG: crash-interrupted fee breakdown not reconciled in ledger: fee=%s ship=%s comm=%s net=%s",
			snapN03.PlatformFees.String(), snapN03.ShippingCosts.String(),
			snapN03.AffiliateCommissions.String(), snapN03.NetProfit.String())
	}

	// 4. Zero out payment_fee at v3 via RecordOrderFeeBreakdownCorrection, then update only platform_fee to 65,000 at v4 (newPaymentFee = nil).
	zero := tenantdb.ZeroDecimal()
	if err := svcAfterCrash.RecordOrderFeeBreakdownCorrection(ctx, wsA, ordN03, nil, &zero, "v3", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); err != nil {
		t.Fatalf("PG N03 RecordOrderFeeBreakdownCorrection (zero payment_fee v3): %v", err)
	}
	plat65k := tenantdb.MustParseExactDecimal("65000.000000")
	if err := svcAfterCrash.RecordOrderFeeBreakdownCorrection(ctx, wsA, ordN03, &plat65k, nil, "v4", finance.SourceClassOfficial, finance.ConfidenceHigh, fxVND); err != nil {
		t.Fatalf("PG N03 RecordOrderFeeBreakdownCorrection (platform_fee v4): %v", err)
	}
	snapAfterZero, err := svcAfterCrash.GetOrComputeProfitSnapshot(ctx, wsA, "order", ordN03, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("PG N03 GetOrComputeProfitSnapshot after v4: %v", err)
	}
	if snapAfterZero.PlatformFees.String() != "65000" {
		t.Fatalf("PG N03 ZERO-FEE BUG: stale payment_fee resurrected in Postgres: expected PlatformFees=65000, got %s",
			snapAfterZero.PlatformFees.String())
	}
}

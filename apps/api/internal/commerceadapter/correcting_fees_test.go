package commerceadapter_test

import (
	"context"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// TestTarget2_CorrectingFeesPreserveProof verifies that when platform settlement reports
// corrected fees, the system reverses prior postings via reversal_of, appends corrected
// postings, and recomputes net profit without duplicating gross revenue or losing audit evidence (F06).
func TestTarget2_CorrectingFeesPreserveProof(t *testing.T) {
	ctx := context.Background()
	adapterSvc, orderSvc, invSvc, finSvc := setupAdapterHarness()
	const wsID = "ws-fees-01"
	const locID = "loc-warehouse-01"
	const skuID = "sku-fee-item-1"
	const orderID = "order-fee-proof-01"

	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, time.Now().Add(-1*time.Hour))

	// 1. Ingest order with initial estimated fee breakdown
	initialFees := order.FeeBreakdown{
		PlatformFee:         tenantdb.MustParseExactDecimal("100000.000000"),
		ShippingCost:        tenantdb.MustParseExactDecimal("20000.000000"),
		AffiliateCommission: tenantdb.MustParseExactDecimal("50000.000000"),
	}

	cogsDec := tenantdb.MustParseExactDecimal("400000.000000")
	ord, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:        orderID,
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		SourcePlatform: "shopee",
		LifecycleState: order.StateCreated,
		Amount:         tenantdb.MustParseExactDecimal("1000000.000000"),
		Currency:       "VND",
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Quantity:  1,
				UnitPrice: tenantdb.MustParseExactDecimal("1000000.000000"),
				UnitCogs:  cogsDec,
			},
		},
		FeeBreakdown: initialFees,
	}, locID)
	if err != nil {
		t.Fatalf("ingest order: %v", err)
	}

	// Confirm, fulfill and complete order -> triggers initial financial postings in M19
	_, err = orderSvc.ConfirmOrder(ctx, wsID, ord.OrderID)
	if err != nil {
		t.Fatalf("confirm order: %v", err)
	}
	_, err = orderSvc.FulfillOrder(ctx, wsID, ord.OrderID)
	if err != nil {
		t.Fatalf("fulfill order: %v", err)
	}
	_, err = orderSvc.CompleteOrder(ctx, wsID, ord.OrderID)
	if err != nil {
		t.Fatalf("complete order: %v", err)
	}

	// 2. Initial Snapshot:
	// Revenue: 1,000,000; Fee: 100,000; Ship: 20,000; Comm: 50,000; COGS: 400,000
	// Net = 1,000,000 - 100,000 - 20,000 - 50,000 - 400,000 = 430,000
	snap1, err := finSvc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("snapshot 1: %v", err)
	}
	if snap1.NetProfit.String() != "430000" {
		t.Fatalf("expected initial net profit 430,000, got %s", snap1.NetProfit.String())
	}
	if snap1.PlatformFees.String() != "100000" {
		t.Fatalf("expected initial platform fee 100,000, got %s", snap1.PlatformFees.String())
	}

	// 3. Platform Settlement arrives with corrected fees:
	// Actual Platform Fee: 120,000 (was 100,000)
	// Actual Shipping Cost: 25,000 (was 20,000)
	correctedFees := order.FeeBreakdown{
		PlatformFee:         tenantdb.MustParseExactDecimal("120000.000000"),
		ShippingCost:        tenantdb.MustParseExactDecimal("25000.000000"),
		AffiliateCommission: tenantdb.MustParseExactDecimal("50000.000000"),
	}

	const evidenceRef = "ev-obj-shopee-settlement-nov2026"
	const correctionReason = "Shopee final escrow statement audited fee adjustment"
	const newVersion = "v2"

	updatedOrd, err := adapterSvc.ReconcileSettlementFees(ctx, wsID, orderID, correctedFees, newVersion, evidenceRef, correctionReason)
	if err != nil {
		t.Fatalf("ReconcileSettlementFees failed: %v", err)
	}
	if updatedOrd.FeeBreakdown.PlatformFee.String() != "120000" {
		t.Fatalf("expected order fee updated to 120000, got %s", updatedOrd.FeeBreakdown.PlatformFee.String())
	}

	// 4. Verify Append-Only Postings and Reversal Trail in Financial Ledger:
	// Prior platform fee (100,000) was NOT deleted.
	// A reversal posting exists with reversal_of referencing the prior posting.
	// A new posting exists with origin_version = "v2" and amount -120,000.
	postings, err := finSvc.Store().ListPostings(ctx, wsID, finance.PostingFilter{
		Component: finance.ComponentPlatformFee,
	})
	if err != nil {
		t.Fatalf("list platform fee postings: %v", err)
	}

	var hasReversal bool
	var hasV2Corrected bool
	for _, p := range postings {
		if p.ReversalOf != nil {
			hasReversal = true
		}
		if p.OriginVersion == "v2" && p.Amount.String() == "-120000" {
			hasV2Corrected = true
		}
	}
	if !hasReversal {
		t.Fatalf("expected reversal posting referencing prior posting in financial postings ledger")
	}
	if !hasV2Corrected {
		t.Fatalf("expected v2 corrected posting in financial postings ledger")
	}

	// 5. Verify Recomputed Snapshot after Correction:
	// Expected net = 1,000,000 - 120,000 - 25,000 - 50,000 - 400,000 = 405,000
	snap2, err := finSvc.GetOrComputeProfitSnapshot(ctx, wsID, "workspace", wsID, "2026-11-01", "2026-11-30", true)
	if err != nil {
		t.Fatalf("snapshot 2: %v", err)
	}
	if snap2.GrossRevenue.String() != "1000000" {
		t.Fatalf("gross revenue must NOT be duplicated or altered! Got %s", snap2.GrossRevenue.String())
	}
	if snap2.PlatformFees.String() != "120000" {
		t.Fatalf("expected platform fees 120,000, got %s", snap2.PlatformFees.String())
	}
	if snap2.ShippingCosts.String() != "25000" {
		t.Fatalf("expected shipping costs 25,000, got %s", snap2.ShippingCosts.String())
	}
	if snap2.NetProfit.String() != "405000" {
		t.Fatalf("expected net profit 405,000, got %s", snap2.NetProfit.String())
	}
}

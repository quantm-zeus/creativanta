package commerceadapter_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// TestTarget3_NoDoubleRefundOrRestock verifies that replaying returns and refunds
// never causes duplicate inventory movements or duplicate ledger deductions, and enforces
// cumulative boundaries (Acceptance Target 3, RULE-M13-006).
func TestTarget3_NoDoubleRefundOrRestock(t *testing.T) {
	ctx := context.Background()
	_, orderSvc, invSvc, finSvc := setupAdapterHarness()
	const wsID = "ws-no-double-01"
	const locID = "loc-warehouse-01"
	const skuID = "sku-bound-item-1"
	const orderID = "order-no-double-01"

	// Opening baseline: 10 units
	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, baseHarnessTime.Add(-1*time.Hour))

	// Ingest order for 2 units @ 500,000 each = 1,000,000 total
	ord, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:        orderID,
		WorkspaceID:    wsID,
		SourceClass:    order.SourceClassOfficial,
		SourcePlatform: "tiktok",
		LifecycleState: order.StateCreated,
		Amount:         tenantdb.MustParseExactDecimal("1000000.000000"),
		Currency:       "VND",
		Items: []order.OrderItem{
			{Sku: skuID, Quantity: 2, UnitPrice: tenantdb.MustParseExactDecimal("500000.000000")},
		},
	}, locID)
	if err != nil {
		t.Fatalf("ingest order: %v", err)
	}

	// Confirm, fulfill and complete order
	_, _ = orderSvc.ConfirmOrder(ctx, wsID, ord.OrderID)
	_, _ = orderSvc.FulfillOrder(ctx, wsID, ord.OrderID)
	_, _ = orderSvc.CompleteOrder(ctx, wsID, ord.OrderID)

	// On hand was 10 - 2 = 8
	bal1, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal1.OnHand != 8 {
		t.Fatalf("expected on_hand=8, got %d", bal1.OnHand)
	}

	// ------------------------------------------------------------------------
	// 1. Physical Return Replay (No double restock)
	// ------------------------------------------------------------------------
	const returnID = "ret-physical-01"
	ret, err := orderSvc.CreateReturn(ctx, &order.Return{
		ReturnID:       returnID,
		WorkspaceID:    wsID,
		OrderID:        orderID,
		ReturnType:     "physical",
		Items:          []order.ReturnItem{{Sku: skuID, Quantity: 1, Reason: "Customer change of mind"}},
		LifecycleState: order.ReturnInitiated,
	})
	if err != nil {
		t.Fatalf("create return: %v", err)
	}

	// First receipt -> Restocks +1 unit (on-hand becomes 8 + 1 = 9)
	_, err = orderSvc.ReceiveReturn(ctx, wsID, ret.ReturnID, locID)
	if err != nil {
		t.Fatalf("first receive return failed: %v", err)
	}
	bal2, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal2.OnHand != 9 {
		t.Fatalf("expected on_hand=9 after first return receipt, got %d", bal2.OnHand)
	}

	// Replay duplicate receive return -> Must be IDEMPOTENT, on-hand stays 9!
	_, err = orderSvc.ReceiveReturn(ctx, wsID, ret.ReturnID, locID)
	if err != nil {
		t.Fatalf("replay receive return failed: %v", err)
	}
	bal3, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal3.OnHand != 9 {
		t.Fatalf("double restock occurred on replay! expected on_hand=9, got %d", bal3.OnHand)
	}

	// Verify total movements for return in ledger is exactly 1
	movs, total, _ := invSvc.Store().ListMovements(ctx, wsID, skuID, locID, 10, 0)
	returnMovCount := 0
	for _, m := range movs {
		if m.MovementType == inventory.MovementReturn {
			returnMovCount++
		}
	}
	if returnMovCount != 1 {
		t.Fatalf("expected exactly 1 return movement in ledger, got %d (total %d)", returnMovCount, total)
	}

	// ------------------------------------------------------------------------
	// 2. Financial Refund Replay (No double refund)
	// ------------------------------------------------------------------------
	const refundID = "ref-partial-01"
	ref, _, err := orderSvc.RequestRefund(ctx, &order.Refund{
		RefundID:    refundID,
		WorkspaceID: wsID,
		OrderID:     orderID,
		RefundType:  "partial",
		Amount:      tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:    "VND",
		Reason:      "1 item returned",
	})
	if err != nil {
		t.Fatalf("request refund: %v", err)
	}

	// First approval -> Order transitions to partially_refunded
	_, oAfterRef1, err := orderSvc.ApproveRefund(ctx, wsID, ref.RefundID)
	if err != nil {
		t.Fatalf("approve refund failed: %v", err)
	}
	if oAfterRef1.LifecycleState != order.StatePartiallyRefunded {
		t.Fatalf("expected partially_refunded, got %s", oAfterRef1.LifecycleState)
	}
	if oAfterRef1.RefundedAmount.String() != "500000" {
		t.Fatalf("expected refunded_amount 500,000, got %s", oAfterRef1.RefundedAmount.String())
	}

	// Replay duplicate refund approval -> Must be IDEMPOTENT, refunded total remains 500,000
	_, oAfterRef2, err := orderSvc.ApproveRefund(ctx, wsID, ref.RefundID)
	if err != nil {
		t.Fatalf("replay approve refund failed: %v", err)
	}
	if oAfterRef2.RefundedAmount.String() != "500000" {
		t.Fatalf("double refund occurred on replay! refunded_amount=%s", oAfterRef2.RefundedAmount.String())
	}

	// Verify finance ledger has exactly 1 refund posting
	postings, _ := finSvc.Store().ListPostings(ctx, wsID, finance.PostingFilter{
		Component: finance.ComponentRefund,
	})
	if len(postings) != 1 {
		t.Fatalf("expected exactly 1 refund posting in financial ledger, got %d", len(postings))
	}

	// ------------------------------------------------------------------------
	// 3. Orthogonality (Refund alone does NOT restock; Return alone does NOT refund)
	// ------------------------------------------------------------------------
	// The refund did not alter inventory on-hand:
	bal4, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal4.OnHand != 9 {
		t.Fatalf("refund incorrectly altered inventory stock! on_hand=%d", bal4.OnHand)
	}

	// ------------------------------------------------------------------------
	// 4. Cumulative Return Bounds Enforcement (return quantity <= sold quantity)
	// ------------------------------------------------------------------------
	// Ordered quantity = 2.
	// 1 unit was already returned above.
	// Another return for 1 unit should succeed.
	ret2, err := orderSvc.CreateReturn(ctx, &order.Return{
		ReturnID:       "ret-physical-02",
		WorkspaceID:    wsID,
		OrderID:        orderID,
		ReturnType:     "physical",
		Items:          []order.ReturnItem{{Sku: skuID, Quantity: 1, Reason: "Second unit return"}},
		LifecycleState: order.ReturnInitiated,
	})
	if err != nil {
		t.Fatalf("second return should succeed, got error: %v", err)
	}
	_ = ret2

	// A third return for 1 more unit MUST FAIL because cumulative returns would be 1 + 1 + 1 = 3 > 2!
	_, err = orderSvc.CreateReturn(ctx, &order.Return{
		ReturnID:       "ret-physical-03-excess",
		WorkspaceID:    wsID,
		OrderID:        orderID,
		ReturnType:     "physical",
		Items:          []order.ReturnItem{{Sku: skuID, Quantity: 1, Reason: "Excess return"}},
		LifecycleState: order.ReturnInitiated,
	})
	if err == nil {
		t.Fatalf("expected return exceeding ordered quantity to be rejected, but it succeeded!")
	}
	if !errors.Is(err, order.ErrReturnExceedsOrderQuantity) {
		t.Fatalf("expected ErrReturnExceedsOrderQuantity, got %v", err)
	}

	// ------------------------------------------------------------------------
	// 5. Cumulative Refund Bounds Enforcement (refund amount <= order amount)
	// ------------------------------------------------------------------------
	// Order amount = 1,000,000. Refunded so far = 500,000. Remaining = 500,000.
	// Requesting refund for 600,000 MUST FAIL!
	_, _, err = orderSvc.RequestRefund(ctx, &order.Refund{
		RefundID:    "ref-excess",
		WorkspaceID: wsID,
		OrderID:     orderID,
		Amount:      tenantdb.MustParseExactDecimal("600000.000000"),
		Currency:    "VND",
		Reason:      "Excess refund",
	})
	if err == nil {
		t.Fatalf("expected refund exceeding remaining order amount to fail, but it succeeded!")
	}
	if !errors.Is(err, order.ErrRefundExceedsOrderTotal) {
		t.Fatalf("expected ErrRefundExceedsOrderTotal, got %v", err)
	}

	// Requesting remaining 500,000 succeeds and brings order to StateRefunded
	refFinal, _, err := orderSvc.RequestRefund(ctx, &order.Refund{
		RefundID:    "ref-final",
		WorkspaceID: wsID,
		OrderID:     orderID,
		Amount:      tenantdb.MustParseExactDecimal("500000.000000"),
		Currency:    "VND",
		Reason:      "Final refund",
	})
	if err != nil {
		t.Fatalf("final refund request failed: %v", err)
	}
	_, oFinal, err := orderSvc.ApproveRefund(ctx, wsID, refFinal.RefundID)
	if err != nil {
		t.Fatalf("approve final refund failed: %v", err)
	}
	if oFinal.LifecycleState != order.StateRefunded {
		t.Fatalf("expected order to be fully refunded, got %s", oFinal.LifecycleState)
	}
	if oFinal.RefundedAmount.String() != "1000000" {
		t.Fatalf("expected refunded amount 1,000,000, got %s", oFinal.RefundedAmount.String())
	}
}

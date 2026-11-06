package commerceadapter_test

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/commerceadapter"
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

// COM-02: Stripe charge.refunded carries cumulative amount_refunded; ProcessRefundWebhook must
// book only the incremental delta, ignore duplicate or out-of-order lower cumulative snapshots,
// and deduplicate non-cumulative platform refund webhooks by ExternalRefundID.
func TestStripeCumulativeRefundCallbacksAndWebhookReplayDedup(t *testing.T) {
	ctx := context.Background()
	adapterSvc, orderSvc, _, finSvc := setupAdapterHarness()
	const wsID = "ws-stripe-cum-01"
	const orderID = "ord-stripe-cum-01"

	_, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         orderID,
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  commerceadapter.PlatformStripe,
		ExternalOrderID: "pi_cum_test_01",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("1000000.000000"),
		Currency:        "VND",
	}, "")
	if err != nil {
		t.Fatalf("ingest order failed: %v", err)
	}

	const stripeSecret = "whsec_cum_refund_test"
	nowUnix := time.Now().Unix()
	makeStripeRefundPayload := func(eventID string, amountRefunded int64) ([]byte, string) {
		p := []byte(fmt.Sprintf(`{
			"id": %q,
			"type": "charge.refunded",
			"created": %d,
			"data": {
				"object": {
					"id": "ch_cum_test_01",
					"payment_intent": "pi_cum_test_01",
					"amount_refunded": %d,
					"currency": "vnd",
					"metadata": {"order_id": %q}
				}
			}
		}`, eventID, nowUnix, amountRefunded, orderID))
		sig := fmt.Sprintf("t=%d,v1=%s", nowUnix, computeHMACSHA256(stripeSecret, []byte(fmt.Sprintf("%d.%s", nowUnix, string(p)))))
		return p, sig
	}

	// 1. First partial refund of 300,000 VND (cumulative amount_refunded = 300,000)
	payload1, sig1 := makeStripeRefundPayload("evt_ref_1", 300000)
	ref1, ord1, err := adapterSvc.ProcessRefundWebhook(ctx, commerceadapter.PlatformStripe, wsID, orderID, payload1, sig1, stripeSecret)
	if err != nil {
		t.Fatalf("first Stripe refund webhook failed: %v", err)
	}
	if ref1.Amount.String() != "300000" || ord1.RefundedAmount.String() != "300000" {
		t.Fatalf("expected ref=300000 and ord.RefundedAmount=300000, got ref=%s ord=%s", ref1.Amount.String(), ord1.RefundedAmount.String())
	}

	// 2. Exact replay of first webhook -> must NOT create a second 300,000 refund
	ref1Replay, ord1Replay, err := adapterSvc.ProcessRefundWebhook(ctx, commerceadapter.PlatformStripe, wsID, orderID, payload1, sig1, stripeSecret)
	if err != nil {
		t.Fatalf("replay of first Stripe refund webhook failed: %v", err)
	}
	if ref1Replay.RefundID != ref1.RefundID || ord1Replay.RefundedAmount.String() != "300000" {
		t.Fatalf("expected idempotent replay to keep RefundedAmount=300000, got %s", ord1Replay.RefundedAmount.String())
	}

	// 3. Second partial refund of +200,000 VND (Stripe sends cumulative amount_refunded = 500,000)
	payload2, sig2 := makeStripeRefundPayload("evt_ref_2", 500000)
	ref2, ord2, err := adapterSvc.ProcessRefundWebhook(ctx, commerceadapter.PlatformStripe, wsID, orderID, payload2, sig2, stripeSecret)
	if err != nil {
		t.Fatalf("second Stripe cumulative refund webhook failed: %v", err)
	}
	if ref2.Amount.String() != "200000" {
		t.Fatalf("expected incremental refund delta of 200000, got %s", ref2.Amount.String())
	}
	if ord2.RefundedAmount.String() != "500000" || ord2.LifecycleState != order.StatePartiallyRefunded {
		t.Fatalf("expected cumulative RefundedAmount=500000 and StatePartiallyRefunded, got %s (%s)", ord2.RefundedAmount.String(), ord2.LifecycleState)
	}

	// 4. Out-of-order arrival of earlier snapshot (amount_refunded = 300,000 < 500,000) -> no-op
	_, ordStale, err := adapterSvc.ProcessRefundWebhook(ctx, commerceadapter.PlatformStripe, wsID, orderID, payload1, sig1, stripeSecret)
	if err != nil {
		t.Fatalf("stale snapshot webhook failed: %v", err)
	}
	if ordStale.RefundedAmount.String() != "500000" {
		t.Fatalf("expected stale snapshot to leave RefundedAmount=500000, got %s", ordStale.RefundedAmount.String())
	}

	// 5. Final partial refund of +500,000 VND (cumulative amount_refunded = 1,000,000) -> full refund
	payload3, sig3 := makeStripeRefundPayload("evt_ref_3", 1000000)
	ref3, ord3, err := adapterSvc.ProcessRefundWebhook(ctx, commerceadapter.PlatformStripe, wsID, orderID, payload3, sig3, stripeSecret)
	if err != nil {
		t.Fatalf("third Stripe cumulative refund webhook failed: %v", err)
	}
	if ref3.Amount.String() != "500000" || ord3.RefundedAmount.String() != "1000000" || ord3.LifecycleState != order.StateRefunded {
		t.Fatalf("expected delta=500000, RefundedAmount=1000000, StateRefunded, got delta=%s total=%s state=%s",
			ref3.Amount.String(), ord3.RefundedAmount.String(), ord3.LifecycleState)
	}

	postings, err := finSvc.Store().ListPostings(ctx, wsID, finance.PostingFilter{
		Component: finance.ComponentRefund,
	})
	if err != nil || len(postings) != 3 {
		t.Fatalf("expected 3 incremental refund postings (-300k, -200k, -500k), got %d (err=%v)", len(postings), err)
	}
}

// F11: Duplicate return webhook (when returned qty < ordered qty) and multi-step return progression
// for the same ExternalReturnID must create only 1 Return and restock physical inventory only once.
func TestF11_DuplicateReturnWebhookAndReturnProgressionRestockOnce(t *testing.T) {
	ctx := context.Background()
	adapterSvc, orderSvc, invSvc, _ := setupAdapterHarness()

	const (
		wsID      = "ws-f11-return-dedup"
		locID     = "loc-f11-wh"
		skuID     = "sku-f11-item"
		appSecret = "tiktok_f11_secret"
	)

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline failed: %v", err)
	}

	// Order has 2 units sold -> stock drops from 10 to 8
	ord, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  commerceadapter.PlatformTikTok,
		ExternalOrderID: "tt-order-f11-01",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("200000.000000"),
		Currency:        "VND",
		OrderedAt:       t0.Add(1 * time.Hour),
		Items: []order.OrderItem{
			{
				Sku:       skuID,
				Name:      "Two Unit Item",
				Quantity:  2,
				UnitPrice: tenantdb.MustParseExactDecimal("100000.000000"),
				Total:     tenantdb.MustParseExactDecimal("200000.000000"),
			},
		},
	}, locID)
	if err != nil {
		t.Fatalf("IngestOrder failed: %v", err)
	}

	bal0, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal0.OnHand != 8 {
		t.Fatalf("expected initial OnHand=8 after 2-unit sale, got %d", bal0.OnHand)
	}

	makeReturnPayload := func(status string) ([]byte, string) {
		body := []byte(fmt.Sprintf(`{
			"type": 2,
			"event": "return_status_change",
			"timestamp": 1711800000,
			"shop_id": "shop_1",
			"data": {
				"return_id": "tt-ret-f11-ext-01",
				"order_id": "tt-order-f11-01",
				"return_status": %q,
				"tracking_number": "TRK-F11-01",
				"items": [
					{"sku_id": %q, "quantity": 1, "reason": "damaged"}
				]
			}
		}`, status, skuID))
		sig := computeHMACSHA256(appSecret, body)
		return body, sig
	}

	// 1. Return webhook arrives in REQUESTED state (1 unit of 2 sold) -> creates return, does not restock yet
	reqBody, reqSig := makeReturnPayload("REQUESTED")
	ret1, err := adapterSvc.ProcessReturnWebhook(ctx, commerceadapter.PlatformTikTok, wsID, ord.OrderID, reqBody, reqSig, appSecret, locID)
	if err != nil {
		t.Fatalf("ProcessReturnWebhook(REQUESTED) failed: %v", err)
	}
	balAfterReq, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if balAfterReq.OnHand != 8 {
		t.Fatalf("expected OnHand=8 before physical return received, got %d", balAfterReq.OnHand)
	}

	// 2. Return webhook for SAME return_id arrives in RETURN_RECEIVED state -> restocks 1 unit (OnHand: 8 -> 9)
	recBody, recSig := makeReturnPayload("RETURN_RECEIVED")
	ret2, err := adapterSvc.ProcessReturnWebhook(ctx, commerceadapter.PlatformTikTok, wsID, ord.OrderID, recBody, recSig, appSecret, locID)
	if err != nil {
		t.Fatalf("ProcessReturnWebhook(RETURN_RECEIVED #1) failed: %v", err)
	}
	if ret2.ReturnID != ret1.ReturnID {
		t.Fatalf("expected same ReturnID %s for same external return_id, got %s", ret1.ReturnID, ret2.ReturnID)
	}
	balAfterRec1, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if balAfterRec1.OnHand != 9 {
		t.Fatalf("expected OnHand=9 after receiving 1 returned unit, got %d", balAfterRec1.OnHand)
	}

	// 3. Duplicate RETURN_RECEIVED webhook for SAME return_id arrives again -> must NOT restock a second unit!
	ret3, err := adapterSvc.ProcessReturnWebhook(ctx, commerceadapter.PlatformTikTok, wsID, ord.OrderID, recBody, recSig, appSecret, locID)
	if err != nil {
		t.Fatalf("ProcessReturnWebhook(RETURN_RECEIVED #2 duplicate) failed: %v", err)
	}
	if ret3.ReturnID != ret1.ReturnID {
		t.Fatalf("expected duplicate webhook to return same ReturnID %s, got %s", ret1.ReturnID, ret3.ReturnID)
	}
	balAfterRec2, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if balAfterRec2.OnHand != 9 {
		t.Fatalf("expected OnHand to remain 9 after duplicate return webhook, got %d (double restock bug!)", balAfterRec2.OnHand)
	}
}

// F13: Order webhooks with same external identity advancing through created -> confirmed -> fulfilled -> completed
// must apply each forward transition and its stock/finance effects, ignore duplicates, and reject/ignore backward out-of-order events.
func TestF13_OrderWebhookLifecycleProgressionDuplicateAndOutOfOrder(t *testing.T) {
	ctx := context.Background()
	adapterSvc, _, invSvc, finSvc := setupAdapterHarness()

	const (
		wsID      = "ws-f13-order-lifecycle"
		locID     = "loc-f13-wh"
		skuID     = "sku-f13-item"
		appSecret = "tiktok_f13_secret"
	)

	t0 := time.Date(2026, 3, 25, 10, 0, 0, 0, time.UTC)
	if err := invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, t0); err != nil {
		t.Fatalf("RecordOpeningBaseline failed: %v", err)
	}

	makeOrderPayload := func(status string, ts int64) ([]byte, string) {
		body := []byte(fmt.Sprintf(`{
			"type": 1,
			"event": "order_status_change",
			"timestamp": %d,
			"shop_id": "shop_1",
			"data": {
				"order_id": "tt-ord-f13-001",
				"order_status": %q,
				"total_amount": "300000",
				"currency": "VND",
				"create_time": %d,
				"line_items": [
					{"sku_id": %q, "name": "F13 Product", "quantity": 2, "price": "150000", "unit_cogs": "50000"}
				],
				"fee_breakdown": {
					"platform_fee": "15000"
				}
			}
		}`, ts, status, t0.Add(1*time.Hour).Unix(), skuID))
		sig := computeHMACSHA256(appSecret, body)
		return body, sig
	}

	// 1. UNPAID (created) -> creates order in StateCreated, reserves 2 units (OnHand=10, Reserved=2)
	pCreated, sCreated := makeOrderPayload("100", 1711800100)
	ord1, _, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "conn-f13", pCreated, sCreated, appSecret, locID)
	if err != nil {
		t.Fatalf("ProcessOrderWebhook(created) failed: %v", err)
	}
	if ord1.LifecycleState != order.StateCreated {
		t.Fatalf("expected StateCreated, got %s", ord1.LifecycleState)
	}
	bal, _ := invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 10 || bal.Reserved != 2 {
		t.Fatalf("expected OnHand=10 Reserved=2 after created, got OnHand=%d Reserved=%d", bal.OnHand, bal.Reserved)
	}

	// 2. Duplicate UNPAID (created) -> idempotent no-op
	ord1Dup, _, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "conn-f13", pCreated, sCreated, appSecret, locID)
	if err != nil || ord1Dup.LifecycleState != order.StateCreated {
		t.Fatalf("expected duplicate created to keep StateCreated, got %v (err=%v)", ord1Dup, err)
	}

	// 3. AWAITING_SHIPMENT (confirmed) -> transitions to StateConfirmed, fulfills reservation (OnHand=8, Reserved=0)
	pConfirmed, sConfirmed := makeOrderPayload("111", 1711800200)
	ord2, _, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "conn-f13", pConfirmed, sConfirmed, appSecret, locID)
	if err != nil {
		t.Fatalf("ProcessOrderWebhook(confirmed) failed: %v", err)
	}
	if ord2.LifecycleState != order.StateConfirmed {
		t.Fatalf("expected StateConfirmed after confirmed webhook, got %s", ord2.LifecycleState)
	}
	bal, _ = invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 8 || bal.Reserved != 0 {
		t.Fatalf("expected OnHand=8 Reserved=0 after confirmed, got OnHand=%d Reserved=%d", bal.OnHand, bal.Reserved)
	}

	// 4. Out-of-order UNPAID (created) arriving after confirmed -> must NOT regress state or re-reserve stock
	ordOut1, _, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "conn-f13", pCreated, sCreated, appSecret, locID)
	if err != nil {
		t.Fatalf("out-of-order created webhook failed: %v", err)
	}
	if ordOut1.LifecycleState != order.StateConfirmed {
		t.Fatalf("expected out-of-order created to keep StateConfirmed, got %s", ordOut1.LifecycleState)
	}
	bal, _ = invSvc.Store().GetBalance(ctx, wsID, skuID, locID)
	if bal.OnHand != 8 || bal.Reserved != 0 {
		t.Fatalf("expected OnHand=8 Reserved=0 after out-of-order created, got OnHand=%d Reserved=%d", bal.OnHand, bal.Reserved)
	}

	// 5. IN_TRANSIT (fulfilled) -> transitions to StateFulfilled
	pFulfilled, sFulfilled := makeOrderPayload("121", 1711800300)
	ord3, _, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "conn-f13", pFulfilled, sFulfilled, appSecret, locID)
	if err != nil {
		t.Fatalf("ProcessOrderWebhook(fulfilled) failed: %v", err)
	}
	if ord3.LifecycleState != order.StateFulfilled {
		t.Fatalf("expected StateFulfilled after fulfilled webhook, got %s", ord3.LifecycleState)
	}

	// 6. Out-of-order AWAITING_SHIPMENT (confirmed) arriving after fulfilled -> must NOT regress state
	ordOut2, _, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "conn-f13", pConfirmed, sConfirmed, appSecret, locID)
	if err != nil {
		t.Fatalf("out-of-order confirmed webhook failed: %v", err)
	}
	if ordOut2.LifecycleState != order.StateFulfilled {
		t.Fatalf("expected out-of-order confirmed to keep StateFulfilled, got %s", ordOut2.LifecycleState)
	}

	// 7. COMPLETED -> transitions to StateCompleted and posts revenue/fees/COGS to finance once
	pCompleted, sCompleted := makeOrderPayload("130", 1711800400)
	ord4, _, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "conn-f13", pCompleted, sCompleted, appSecret, locID)
	if err != nil {
		t.Fatalf("ProcessOrderWebhook(completed) failed: %v", err)
	}
	if ord4.LifecycleState != order.StateCompleted {
		t.Fatalf("expected StateCompleted after completed webhook, got %s", ord4.LifecycleState)
	}
	postings, err := finSvc.Store().ListPostings(ctx, wsID, finance.PostingFilter{})
	if err != nil || len(postings) == 0 {
		t.Fatalf("expected finance postings after completed webhook, got %d (err=%v)", len(postings), err)
	}
	postingsCount := len(postings)

	// 8. Duplicate COMPLETED -> idempotent, no extra finance postings or stock deductions
	ord4Dup, _, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "conn-f13", pCompleted, sCompleted, appSecret, locID)
	if err != nil || ord4Dup.LifecycleState != order.StateCompleted {
		t.Fatalf("expected duplicate completed to stay StateCompleted, got %v (err=%v)", ord4Dup, err)
	}
	postingsAfterDup, _ := finSvc.Store().ListPostings(ctx, wsID, finance.PostingFilter{})
	if len(postingsAfterDup) != postingsCount {
		t.Fatalf("expected finance postings count unchanged (%d), got %d", postingsCount, len(postingsAfterDup))
	}
}

// F09 (Multi-instance): Concurrent cumulative Stripe charge.refunded webhooks across multiple
// commerceadapter.Service instances sharing the same OrderService/Store must calculate deltas
// atomically under the store/DB lock and fail closed on missing/invalid webhook credentials.
func TestF09_MultiInstanceConcurrentStripeCumulativeRefundWebhooks(t *testing.T) {
	ctx := context.Background()
	adapter1, orderSvc, invSvc, finSvc := setupAdapterHarness()
	adapter2 := commerceadapter.NewService(orderSvc, invSvc, finSvc, nil)

	const wsID = "ws-f09-multi-01"
	const orderID = "ord-f09-multi-01"
	const stripeSecret = "whsec_f09_multi_test"

	_, _, err := orderSvc.IngestOrder(ctx, &order.Order{
		OrderID:         orderID,
		WorkspaceID:     wsID,
		SourceClass:     order.SourceClassOfficial,
		SourcePlatform:  commerceadapter.PlatformStripe,
		ExternalOrderID: "pi_f09_multi_01",
		LifecycleState:  order.StateCompleted,
		Amount:          tenantdb.MustParseExactDecimal("100000.000000"),
		Currency:        "VND",
	}, "")
	if err != nil {
		t.Fatalf("ingest order failed: %v", err)
	}

	nowUnix := time.Now().Unix()
	makePayload := func(eventID string, amountRefunded int64) ([]byte, string) {
		p := []byte(fmt.Sprintf(`{
			"id": %q,
			"type": "charge.refunded",
			"created": %d,
			"data": {
				"object": {
					"id": "ch_f09_multi_01",
					"payment_intent": "pi_f09_multi_01",
					"amount_refunded": %d,
					"currency": "vnd",
					"metadata": {"order_id": %q}
				}
			}
		}`, eventID, nowUnix, amountRefunded, orderID))
		sig := fmt.Sprintf("t=%d,v1=%s", nowUnix, computeHMACSHA256(stripeSecret, []byte(fmt.Sprintf("%d.%s", nowUnix, string(p)))))
		return p, sig
	}

	p25, s25 := makePayload("evt_multi_25", 25000)
	p60, s60 := makePayload("evt_multi_60", 60000)

	// Negative check: missing secret or invalid signature must fail closed
	if _, _, err := adapter1.ProcessRefundWebhook(ctx, commerceadapter.PlatformStripe, wsID, orderID, p25, s25, ""); !errors.Is(err, commerceadapter.ErrMissingCredentials) {
		t.Fatalf("expected ErrMissingCredentials for empty secret, got %v", err)
	}
	if _, _, err := adapter1.ProcessRefundWebhook(ctx, commerceadapter.PlatformStripe, wsID, orderID, p25, "t=1,v1=bad", stripeSecret); !errors.Is(err, commerceadapter.ErrInvalidSignature) {
		t.Fatalf("expected ErrInvalidSignature for bad signature, got %v", err)
	}

	// Fire 4 concurrent deliveries across adapter1 and adapter2 (two of 25k, two of 60k)
	var wg sync.WaitGroup
	errs := make(chan error, 4)
	call := func(svc *commerceadapter.Service, payload []byte, sig string) {
		defer wg.Done()
		if _, _, cErr := svc.ProcessRefundWebhook(ctx, commerceadapter.PlatformStripe, wsID, orderID, payload, sig, stripeSecret); cErr != nil {
			errs <- cErr
		}
	}
	wg.Add(4)
	go call(adapter1, p25, s25)
	go call(adapter2, p25, s25)
	go call(adapter1, p60, s60)
	go call(adapter2, p60, s60)
	wg.Wait()
	close(errs)
	for e := range errs {
		t.Fatalf("unexpected error in concurrent multi-instance ProcessRefundWebhook: %v", e)
	}

	finalOrd, err := orderSvc.GetOrder(ctx, wsID, orderID)
	if err != nil {
		t.Fatalf("GetOrder failed: %v", err)
	}
	if finalOrd.RefundedAmount.String() != "60000" {
		t.Fatalf("expected final RefundedAmount=60000 after concurrent cumulative 25k & 60k webhooks, got %s", finalOrd.RefundedAmount.String())
	}
	if finalOrd.LifecycleState != order.StatePartiallyRefunded {
		t.Fatalf("expected StatePartiallyRefunded, got %s", finalOrd.LifecycleState)
	}
}

package commerceadapter_test

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/commerceadapter"
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
)

type mockSink struct{}

func (m *mockSink) Emit(_ context.Context, _ order.OutboxEvent) error { return nil }

var baseHarnessTime = time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)

func setupAdapterHarness() (*commerceadapter.Service, *order.Service, *inventory.Service, *finance.Service) {
	clock := func() time.Time { return baseHarnessTime }

	invStore := inventory.NewMemoryStore()
	invSvc := inventory.NewService(invStore, nil, clock)

	finStore := finance.NewMemoryStore()
	finSvc := finance.NewService(finStore, nil, clock)

	orderStore := order.NewMemoryStore()
	orderSvc := order.NewService(orderStore, invSvc, &mockSink{}, clock)
	orderSvc.SetFinance(finSvc)

	adapterSvc := commerceadapter.NewService(orderSvc, invSvc, finSvc, clock)
	return adapterSvc, orderSvc, invSvc, finSvc
}

func computeHMACSHA256(secret string, data []byte) string {
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write(data)
	return hex.EncodeToString(mac.Sum(nil))
}

func TestTikTokAdapter_OrderReturnRefundSettlement(t *testing.T) {
	ctx := context.Background()
	adapterSvc, orderSvc, invSvc, finSvc := setupAdapterHarness()
	const wsID = "ws-tiktok-01"
	const secret = "tiktok-test-app-secret"
	const locID = "loc-warehouse-01"
	const skuID = "sku-tt-item-1"

	// Prepare location and opening inventory of 10 units
	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, time.Now().Add(-1*time.Hour))

	// 1. TikTok Order Webhook Ingestion
	orderPayload := []byte(`{
		"type": 1,
		"event": "ORDER_STATUS_CHANGE",
		"timestamp": 1730000000,
		"shop_id": "shop_vn_8899",
		"data": {
			"order_id": "tt_order_1001",
			"order_status": "AWAITING_SHIPMENT",
			"total_amount": "500000.000000",
			"currency": "VND",
			"line_items": [
				{
					"sku_id": "` + skuID + `",
					"name": "TikTok Viral Cosmetic",
					"quantity": 2,
					"price": "250000.000000",
					"unit_cogs": "100000.000000"
				}
			],
			"fee_breakdown": {
				"platform_fee": "50000.000000",
				"payment_fee": "10000.000000",
				"commission": "25000.000000",
				"shipping_fee": "15000.000000"
			}
		}
	}`)
	sig := computeHMACSHA256(secret, orderPayload)

	ord, created, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformTikTok, wsID, "acc-tt-1", orderPayload, sig, secret, locID)
	if err != nil {
		t.Fatalf("ProcessOrderWebhook failed: %v", err)
	}
	if !created {
		t.Fatalf("expected order to be created")
	}
	if ord.ExternalOrderID != "tt_order_1001" {
		t.Fatalf("unexpected external order id: %s", ord.ExternalOrderID)
	}
	if ord.LifecycleState != order.StateConfirmed {
		t.Fatalf("expected confirmed lifecycle state, got %s", ord.LifecycleState)
	}

	// 2. Physical Return Webhook
	returnPayload := []byte(`{
		"type": 2,
		"event": "RETURN_STATUS_CHANGE",
		"timestamp": 1730000000,
		"data": {
			"return_id": "tt_ret_5001",
			"order_id": "` + ord.OrderID + `",
			"return_status": "RETURN_RECEIVED",
			"tracking_number": "TT_EXPRESS_9988",
			"items": [
				{"sku_id": "` + skuID + `", "quantity": 1, "reason": "Customer change of mind"}
			]
		}
	}`)
	retSig := computeHMACSHA256(secret, returnPayload)
	ret, err := adapterSvc.ProcessReturnWebhook(ctx, commerceadapter.PlatformTikTok, wsID, ord.OrderID, returnPayload, retSig, secret, locID)
	if err != nil {
		t.Fatalf("ProcessReturnWebhook failed: %v", err)
	}
	if ret.LifecycleState != order.ReturnClosed {
		t.Fatalf("expected ReturnClosed after receiving, got %s", ret.LifecycleState)
	}

	// 3. Financial Refund Webhook
	refundPayload := []byte(`{
		"type": 3,
		"event": "REFUND_STATUS_CHANGE",
		"timestamp": 1730000000,
		"data": {
			"refund_id": "tt_ref_8001",
			"order_id": "` + ord.OrderID + `",
			"refund_amount": "250000.000000",
			"currency": "VND",
			"reason": "Return accepted"
		}
	}`)
	refSig := computeHMACSHA256(secret, refundPayload)
	ref, updatedOrd, err := adapterSvc.ProcessRefundWebhook(ctx, commerceadapter.PlatformTikTok, wsID, ord.OrderID, refundPayload, refSig, secret)
	if err != nil {
		t.Fatalf("ProcessRefundWebhook failed: %v", err)
	}
	if ref.LifecycleState != order.RefundCompleted {
		t.Fatalf("expected RefundCompleted, got %s", ref.LifecycleState)
	}
	if updatedOrd.LifecycleState != order.StatePartiallyRefunded {
		t.Fatalf("expected order StatePartiallyRefunded, got %s", updatedOrd.LifecycleState)
	}
	_ = orderSvc
	_ = finSvc
}

func TestShopeeAdapter_OrderAndReturn(t *testing.T) {
	ctx := context.Background()
	adapterSvc, _, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-shopee-01"
	const partnerKey = "shopee-partner-key-99"
	const locID = "loc-warehouse-01"
	const skuID = "sku-sp-item-1"

	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 20, time.Now().Add(-1*time.Hour))

	orderPayload := []byte(`{
		"shop_id": 1234567,
		"code": 3,
		"timestamp": 1730000000,
		"data": {
			"ordersn": "shopee_sn_7766",
			"status": "READY_TO_SHIP",
			"total_amount": "800000.000000",
			"currency": "VND",
			"items": [
				{
					"item_sku": "` + skuID + `",
					"item_name": "Shopee Fashion Dress",
					"model_quantity_purchased": 2,
					"model_discounted_price": "400000.000000",
					"unit_cogs": "150000.000000"
				}
			],
			"escrow_detail": {
				"commission_fee": "40000.000000",
				"service_fee": "24000.000000",
				"shopee_shipping_fee": "30000.000000",
				"transaction_fee": "16000.000000"
			}
		}
	}`)
	base := fmt.Sprintf("https://api.creativanta.local/webhooks/shopee|%s", string(orderPayload))
	sig := computeHMACSHA256(partnerKey, []byte(base))

	ord, created, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformShopee, wsID, "acc-sp-1", orderPayload, sig, partnerKey, locID)
	if err != nil {
		t.Fatalf("Shopee ProcessOrderWebhook failed: %v", err)
	}
	if !created {
		t.Fatalf("expected order created")
	}
	if ord.ExternalOrderID != "shopee_sn_7766" {
		t.Fatalf("unexpected order id: %s", ord.ExternalOrderID)
	}
	if ord.LifecycleState != order.StateConfirmed {
		t.Fatalf("expected confirmed state, got %s", ord.LifecycleState)
	}
	if ord.FeeBreakdown.AffiliateCommission.String() != "40000" {
		t.Fatalf("expected commission 40000, got %s", ord.FeeBreakdown.AffiliateCommission.String())
	}
}

func TestLazadaAdapter_OrderAndReturn(t *testing.T) {
	ctx := context.Background()
	adapterSvc, _, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-lazada-01"
	const appSecret = "lazada-secret-key-12"
	const locID = "loc-warehouse-01"
	const skuID = "sku-lz-item-1"

	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 15, time.Now().Add(-1*time.Hour))

	orderPayload := []byte(`{
		"seller_id": "seller_lz_99",
		"message_type": "order_status",
		"timestamp": 1730000000,
		"data": {
			"order_id": "lz_order_8822",
			"order_status": "ready_to_ship",
			"price": "350000.000000",
			"currency": "VND",
			"order_items": [
				{
					"sku": "` + skuID + `",
					"name": "Lazada Gadget",
					"quantity": 1,
					"paid_price": "350000.000000",
					"unit_cogs": "180000.000000"
				}
			],
			"fees": {
				"commission": "17500.000000",
				"payment_fee": "7000.000000",
				"shipping_fee": "25000.000000"
			}
		}
	}`)
	sig := computeHMACSHA256(appSecret, orderPayload)

	ord, created, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformLazada, wsID, "acc-lz-1", orderPayload, sig, appSecret, locID)
	if err != nil {
		t.Fatalf("Lazada ProcessOrderWebhook failed: %v", err)
	}
	if !created {
		t.Fatalf("expected order created")
	}
	if ord.ExternalOrderID != "lz_order_8822" {
		t.Fatalf("unexpected order id: %s", ord.ExternalOrderID)
	}
	if ord.LifecycleState != order.StateConfirmed {
		t.Fatalf("expected confirmed state, got %s", ord.LifecycleState)
	}
}

func TestStripeAdapter_PaymentIntentAndRefund(t *testing.T) {
	ctx := context.Background()
	adapterSvc, _, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-stripe-01"
	const secret = "whsec_stripe_test_secret"
	const locID = "loc-warehouse-01"

	_ = invSvc

	nowUnix := time.Now().Unix()
	payload := []byte(fmt.Sprintf(`{
		"id": "evt_test_123",
		"type": "payment_intent.succeeded",
		"created": %d,
		"data": {
			"object": {
				"id": "pi_3MtwBwLkdIwHu7ix28a3tqPa",
				"amount": 1000000,
				"currency": "vnd",
				"status": "succeeded",
				"created": %d
			}
		}
	}`, nowUnix, nowUnix))

	signedPayload := fmt.Sprintf("%d.%s", nowUnix, string(payload))
	v1Sig := computeHMACSHA256(secret, []byte(signedPayload))
	sigHeader := fmt.Sprintf("t=%d,v1=%s", nowUnix, v1Sig)

	ord, created, err := adapterSvc.ProcessOrderWebhook(ctx, commerceadapter.PlatformStripe, wsID, "acc-stripe-1", payload, sigHeader, secret, locID)
	if err != nil {
		t.Fatalf("Stripe ProcessOrderWebhook failed: %v", err)
	}
	if !created {
		t.Fatalf("expected order created")
	}
	if ord.ExternalOrderID != "pi_3MtwBwLkdIwHu7ix28a3tqPa" {
		t.Fatalf("unexpected external order id: %s", ord.ExternalOrderID)
	}
	if ord.Amount.String() != "1000000" {
		t.Fatalf("expected amount 1000000, got %s", ord.Amount.String())
	}
}

func TestPlatformStockSync_DeltaCalculation(t *testing.T) {
	ctx := context.Background()
	adapterSvc, _, invSvc, _ := setupAdapterHarness()
	const wsID = "ws-sync-01"
	const locID = "loc-sync-warehouse"
	const skuID = "sku-sync-01"

	// Baseline of 10
	_ = invSvc.RecordOpeningBaseline(ctx, wsID, skuID, locID, 10, time.Now().Add(-1*time.Hour))

	// 1. First sync reports 10 (same as on-hand): must be no-op!
	res1, err := adapterSvc.SyncPlatformStock(ctx, wsID, commerceadapter.PlatformTikTok, locID, skuID, 10, "sync-01")
	if err != nil {
		t.Fatalf("sync 1 failed: %v", err)
	}
	if !res1.IsNoOp || res1.DeltaQuantity != 0 {
		t.Fatalf("expected no-op when stock matches on-hand, got delta=%d, isNoOp=%v", res1.DeltaQuantity, res1.IsNoOp)
	}

	// 2. Second sync reports 15 (+5 units added externally): must append +5 delta movement
	res2, err := adapterSvc.SyncPlatformStock(ctx, wsID, commerceadapter.PlatformTikTok, locID, skuID, 15, "sync-02")
	if err != nil {
		t.Fatalf("sync 2 failed: %v", err)
	}
	if res2.IsNoOp || res2.DeltaQuantity != 5 {
		t.Fatalf("expected delta +5, got delta=%d, isNoOp=%v", res2.DeltaQuantity, res2.IsNoOp)
	}

	// 3. Third sync reports 15 again: must be no-op!
	res3, err := adapterSvc.SyncPlatformStock(ctx, wsID, commerceadapter.PlatformTikTok, locID, skuID, 15, "sync-03")
	if err != nil {
		t.Fatalf("sync 3 failed: %v", err)
	}
	if !res3.IsNoOp || res3.DeltaQuantity != 0 {
		t.Fatalf("repeated absolute count must be no-op! got delta=%d", res3.DeltaQuantity)
	}
}

func TestPlatformCapability_VerifiedVsManualFallback(t *testing.T) {
	adapterSvc, _, _, _ := setupAdapterHarness()

	// Verified credential -> native
	verified := adapterSvc.GetPlatformCapability(commerceadapter.PlatformTikTok, true)
	if !verified.IsNative || verified.Status != "verified" {
		t.Fatalf("expected verified native status, got %+v", verified)
	}

	// Unverified credential -> graceful fallback to manual CSV
	unverified := adapterSvc.GetPlatformCapability(commerceadapter.PlatformTikTok, false)
	if unverified.IsNative || unverified.Status != "manual" {
		t.Fatalf("expected manual fallback, got %+v", unverified)
	}

	// Unknown platform -> unsupported
	unknown := adapterSvc.GetPlatformCapability("unknown_shop", true)
	if unknown.IsNative || unknown.Status != "unsupported" {
		t.Fatalf("expected unsupported status for unknown platform, got %+v", unknown)
	}
}

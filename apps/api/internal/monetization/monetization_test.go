package monetization

import (
	"context"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type mockSink struct {
	mu     sync.Mutex
	events []OutboxEvent
}

func (m *mockSink) Emit(_ context.Context, ev OutboxEvent) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = append(m.events, ev)
	return nil
}

func (m *mockSink) CountType(evType string) int {
	m.mu.Lock()
	defer m.mu.Unlock()
	c := 0
	for _, e := range m.events {
		if e.EventType == evType {
			c++
		}
	}
	return c
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Expired offer rejected at checkout
// ----------------------------------------------------------------------------

func TestAcceptanceTarget1_ExpiredOfferRejectedAtCheckout(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	prodID := newUUID()

	// 1. Create and activate a valid offer with past expiry
	pastTime := now.Add(-1 * time.Hour)
	expiredOffer := &Offer{
		WorkspaceID:     wsID,
		OfferType:       OfferTypeProductOffer,
		ProductID:       &prodID,
		Title:           "Flash Sale Expired",
		PricingValue:    mustDecimal(t, "250000.000000"),
		PricingCurrency: "VND",
		LifecycleState:  OfferStateActive,
		ValidUntil:      &pastTime,
	}
	if err := store.CreateOffer(ctx, expiredOffer); err != nil {
		t.Fatalf("failed to create expired offer: %v", err)
	}

	// 2. Attempt checkout with expired offer -> MUST be rejected
	evalReq := CheckoutRequest{
		WorkspaceID: wsID,
		OfferID:     expiredOffer.OfferID,
		ProductIDs:  []string{prodID},
		OrderAmount: mustDecimal(t, "250000.000000"),
		Currency:    "VND",
	}

	evalRes, err := svc.EvaluateCheckout(ctx, evalReq)
	if err == nil {
		t.Fatalf("expected error for expired offer at checkout, got nil")
	}
	if evalRes == nil || evalRes.Accepted {
		t.Fatalf("expected checkout evaluation to be rejected (Accepted=false), got accepted")
	}
	if evalRes.ErrorCode != "ERR_OFFER_EXPIRED" {
		t.Fatalf("expected ErrorCode 'ERR_OFFER_EXPIRED', got %q", evalRes.ErrorCode)
	}

	// 3. Test explicit OfferStateExpired state
	stateExpiredOffer := &Offer{
		WorkspaceID:     wsID,
		OfferType:       OfferTypeProductOffer,
		ProductID:       &prodID,
		Title:           "Explicitly Expired Offer",
		PricingValue:    mustDecimal(t, "300000.000000"),
		PricingCurrency: "VND",
		LifecycleState:  OfferStateExpired,
	}
	if err := store.CreateOffer(ctx, stateExpiredOffer); err != nil {
		t.Fatalf("failed to create offer: %v", err)
	}

	evalReq2 := CheckoutRequest{
		WorkspaceID: wsID,
		OfferID:     stateExpiredOffer.OfferID,
		ProductIDs:  []string{prodID},
		OrderAmount: mustDecimal(t, "300000.000000"),
		Currency:    "VND",
	}

	evalRes2, err2 := svc.EvaluateCheckout(ctx, evalReq2)
	if err2 == nil || evalRes2.Accepted {
		t.Fatalf("expected checkout to reject explicitly expired offer")
	}
	if evalRes2.ErrorCode != "ERR_OFFER_EXPIRED" {
		t.Fatalf("expected ERR_OFFER_EXPIRED, got %q", evalRes2.ErrorCode)
	}

	// 4. Test Draft/Paused offer rejected
	draftOffer := &Offer{
		WorkspaceID:     wsID,
		OfferType:       OfferTypeProductOffer,
		ProductID:       &prodID,
		Title:           "Draft Offer",
		PricingValue:    mustDecimal(t, "100000.000000"),
		PricingCurrency: "VND",
		LifecycleState:  OfferStateDraft,
	}
	_ = store.CreateOffer(ctx, draftOffer)

	evalRes3, err3 := svc.EvaluateCheckout(ctx, CheckoutRequest{
		WorkspaceID: wsID,
		OfferID:     draftOffer.OfferID,
		OrderAmount: mustDecimal(t, "100000.000000"),
	})
	if err3 == nil || evalRes3.Accepted || evalRes3.ErrorCode != "ERR_OFFER_NOT_ACTIVE" {
		t.Fatalf("expected draft offer to be rejected as not active, got %v, err=%v", evalRes3, err3)
	}

	// 5. Active and valid offer succeeds
	futureTime := now.Add(24 * time.Hour)
	validOffer := &Offer{
		WorkspaceID:     wsID,
		OfferType:       OfferTypeProductOffer,
		ProductID:       &prodID,
		Title:           "Active Promotion",
		PricingValue:    mustDecimal(t, "200000.000000"),
		PricingCurrency: "VND",
		LifecycleState:  OfferStateActive,
		ValidUntil:      &futureTime,
	}
	_ = store.CreateOffer(ctx, validOffer)

	evalRes4, err4 := svc.EvaluateCheckout(ctx, CheckoutRequest{
		WorkspaceID: wsID,
		OfferID:     validOffer.OfferID,
		OrderAmount: mustDecimal(t, "200000.000000"),
		Currency:    "VND",
	})
	if err4 != nil || !evalRes4.Accepted {
		t.Fatalf("expected valid active offer to be accepted at checkout, got err: %v", err4)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Coupon races do not exceed limits
// ----------------------------------------------------------------------------

func TestAcceptanceTarget2_CouponRacesDoNotExceedLimits(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, nil, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	couponCode := "RACE_LIMIT_10"
	maxUses := 10

	// 1. Create a coupon with max_uses = 10
	coupon := &Coupon{
		WorkspaceID:    wsID,
		Code:           couponCode,
		CouponType:     CouponTypeFixedAmount,
		DiscountValue:  mustDecimal(t, "50000.000000"),
		MaxUses:        &maxUses,
		CurrentUses:    0,
		LifecycleState: CouponStateActive,
	}
	if err := store.CreateCoupon(ctx, coupon); err != nil {
		t.Fatalf("failed to create coupon: %v", err)
	}

	// 2. Launch 60 concurrent checkout attempts racing to redeem this coupon
	concurrency := 60
	var wg sync.WaitGroup
	startBarrier := make(chan struct{})

	var successCount int32
	var rejectedCount int32

	for i := 0; i < concurrency; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			<-startBarrier // synchronize start of all goroutines

			res, err := svc.EvaluateCheckout(ctx, CheckoutRequest{
				WorkspaceID: wsID,
				CouponCode:  couponCode,
				OrderAmount: mustDecimal(t, "200000.000000"),
				Currency:    "VND",
			})

			if err == nil && res != nil && res.Accepted && res.DiscountAmount.IsPositive() {
				atomic.AddInt32(&successCount, 1)
			} else {
				atomic.AddInt32(&rejectedCount, 1)
			}
		}(i)
	}

	// Release all goroutines at once to produce maximum concurrency race
	close(startBarrier)
	wg.Wait()

	// 3. Strict Assertions: Exactly 10 succeeded, 50 rejected, current_uses == 10
	if successCount != int32(maxUses) {
		t.Fatalf("RACE CONDITION DETECTED! Expected exactly %d redemptions, got %d", maxUses, successCount)
	}
	expectedRejections := int32(concurrency - maxUses)
	if rejectedCount != expectedRejections {
		t.Fatalf("Expected %d rejections, got %d", expectedRejections, rejectedCount)
	}

	// 4. Verify coupon in store has current_uses == 10 and state == expired
	finalCoupon, err := store.GetCouponByCode(ctx, wsID, couponCode)
	if err != nil {
		t.Fatalf("failed to get coupon: %v", err)
	}
	if finalCoupon.CurrentUses != maxUses {
		t.Fatalf("Expected final CurrentUses == %d, got %d", maxUses, finalCoupon.CurrentUses)
	}
	if finalCoupon.LifecycleState != CouponStateExpired {
		t.Fatalf("Expected coupon state to transition to 'expired' once max uses reached (RULE-M14-003), got %s", finalCoupon.LifecycleState)
	}

	// 5. Subsequent checkout attempt MUST be rejected with limit exceeded/expired
	postRaceRes, postRaceErr := svc.EvaluateCheckout(ctx, CheckoutRequest{
		WorkspaceID: wsID,
		CouponCode:  couponCode,
		OrderAmount: mustDecimal(t, "200000.000000"),
		Currency:    "VND",
	})
	if postRaceErr == nil || postRaceRes.Accepted {
		t.Fatalf("post-race redemption should be rejected, got %v", postRaceRes)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Financial impact reaches ledger
// ----------------------------------------------------------------------------

func TestAcceptanceTarget3_FinancialImpactReachesLedger(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	ledger := NewDefaultLedgerRecorder()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, ledger, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	prodID := newUUID()

	// 1. Create offer
	offer := &Offer{
		WorkspaceID:     wsID,
		OfferType:       OfferTypeProductOffer,
		ProductID:       &prodID,
		Title:           "Product Bundle Offer",
		PricingValue:    mustDecimal(t, "700000.000000"),
		PricingCurrency: "VND",
		LifecycleState:  OfferStateActive,
	}
	_ = store.CreateOffer(ctx, offer)

	// 2. Create 10% discount coupon
	coupon := &Coupon{
		WorkspaceID:    wsID,
		Code:           "LEDGER10",
		CouponType:     CouponTypePercentage,
		DiscountValue:  mustDecimal(t, "10.000000"), // 10%
		LifecycleState: CouponStateActive,
	}
	_ = store.CreateCoupon(ctx, coupon)

	// 3. Evaluate checkout with both Offer and Coupon
	res, err := svc.EvaluateCheckout(ctx, CheckoutRequest{
		WorkspaceID: wsID,
		OfferID:     offer.OfferID,
		CouponCode:  coupon.Code,
		ProductIDs:  []string{prodID},
		OrderAmount: mustDecimal(t, "700000.000000"),
		Currency:    "VND",
	})
	if err != nil {
		t.Fatalf("checkout failed: %v", err)
	}

	// Discount: 700,000 * 10% = 70,000
	// Net payable: 630,000
	expectedDiscount := mustDecimal(t, "70000.000000")
	expectedNet := mustDecimal(t, "630000.000000")

	if res.DiscountAmount.Cmp(expectedDiscount) != 0 {
		t.Fatalf("expected discount %s, got %s", expectedDiscount.String(), res.DiscountAmount.String())
	}
	if res.NetPayableAmount.Cmp(expectedNet) != 0 {
		t.Fatalf("expected net payable %s, got %s", expectedNet.String(), res.NetPayableAmount.String())
	}
	if res.PostingID == "" {
		t.Fatalf("expected posting ID to be returned from ledger")
	}

	// 4. Verify financial impact recorded in ledger
	posting, ok := ledger.postings[res.PostingID]
	if !ok {
		t.Fatalf("expected posting %s in ledger", res.PostingID)
	}
	if posting["order_id"] != res.OrderID {
		t.Fatalf("expected ledger posting order_id %q, got %v", res.OrderID, posting["order_id"])
	}
	if posting["offer_id"] != offer.OfferID {
		t.Fatalf("expected ledger posting offer_id %q, got %v", offer.OfferID, posting["offer_id"])
	}
	if posting["coupon_id"] != coupon.CouponID {
		t.Fatalf("expected ledger posting coupon_id %q, got %v", coupon.CouponID, posting["coupon_id"])
	}
	if posting["net_amount"] != expectedNet.String() {
		t.Fatalf("expected ledger net amount %s, got %v", expectedNet.String(), posting["net_amount"])
	}

	// 5. Test Campaign cost impact reaching ledger
	bgt := mustDecimal(t, "10000000.000000") // 10M VND
	campaign := &Campaign{
		WorkspaceID:    wsID,
		CampaignType:   CampaignTypeContent,
		Title:          "Autumn TikTok Push",
		Status:         CampaignStatusLive,
		Budget:         &bgt,
		BudgetCurrency: "VND",
	}
	_ = store.CreateCampaign(ctx, campaign)

	costRes, err := svc.AddCampaignCost(ctx, &CampaignCostItem{
		WorkspaceID:   wsID,
		CampaignID:    campaign.CampaignID,
		CostType:      "ads_spend",
		Amount:        mustDecimal(t, "4000000.000000"),
		Currency:      "VND",
		Description:   "TikTok Spark Ads initial buy",
		EffectiveDate: "2026-11-04",
	})
	if err != nil {
		t.Fatalf("failed to add campaign cost: %v", err)
	}
	if costRes.TotalSpend.Cmp(mustDecimal(t, "4000000.000000")) != 0 {
		t.Fatalf("expected total spend 4M, got %s", costRes.TotalSpend.String())
	}
}

// ----------------------------------------------------------------------------
// EC-M14-001 & AC 4: Offer activation requires product or declaration
// ----------------------------------------------------------------------------

func TestECM14_001_OfferActivationRequiresProduct(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	svc := NewService(store, nil, nil, nil)
	wsID := "019086a1-7c3e-7000-8000-000000000010"

	// 1. Create offer with NO product and NO product-less declaration
	invalidOffer := &Offer{
		WorkspaceID:     wsID,
		OfferType:       OfferTypeProductOffer,
		Title:           "Invalid Blank Offer",
		PricingValue:    mustDecimal(t, "100000.000000"),
		PricingCurrency: "VND",
		LifecycleState:  OfferStateDraft,
	}
	_ = store.CreateOffer(ctx, invalidOffer)

	// Attempt activation -> MUST fail with ErrOfferProductRequired and stay in draft
	_, err := svc.ActivateOffer(ctx, wsID, invalidOffer.OfferID)
	if err != ErrOfferProductRequired {
		t.Fatalf("expected ErrOfferProductRequired, got %v", err)
	}

	o, _ := store.GetOffer(ctx, wsID, invalidOffer.OfferID)
	if o.LifecycleState != OfferStateDraft {
		t.Fatalf("expected offer to remain in draft, got %s", o.LifecycleState)
	}

	// 2. Product-less declaration allows activation
	digitalOffer := &Offer{
		WorkspaceID:            wsID,
		OfferType:              OfferTypeDigitalOffer,
		ProductLessDeclaration: "digital",
		Title:                  "Digital Ebook",
		PricingValue:           mustDecimal(t, "50000.000000"),
		PricingCurrency:        "VND",
		LifecycleState:         OfferStateDraft,
	}
	_ = store.CreateOffer(ctx, digitalOffer)

	activated, err := svc.ActivateOffer(ctx, wsID, digitalOffer.OfferID)
	if err != nil {
		t.Fatalf("expected product-less offer to activate successfully, got %v", err)
	}
	if activated.LifecycleState != OfferStateActive {
		t.Fatalf("expected offer state active, got %s", activated.LifecycleState)
	}
}

// ----------------------------------------------------------------------------
// EC-M14-003 & AC 3: Campaign budget thresholds (80% warning, 100% alert)
// ----------------------------------------------------------------------------

func TestECM14_003_CampaignBudgetThresholds(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	svc := NewService(store, nil, sink, nil)
	wsID := "019086a1-7c3e-7000-8000-000000000010"

	bgt := mustDecimal(t, "1000.000000") // $1,000 budget
	campaign := &Campaign{
		WorkspaceID:    wsID,
		CampaignType:   CampaignTypeContent,
		Title:          "Threshold Campaign",
		Status:         CampaignStatusLive,
		Budget:         &bgt,
		BudgetCurrency: "USD",
	}
	_ = store.CreateCampaign(ctx, campaign)

	// Step 1: Add $500 cost (50%) -> no warning, no alert
	res1, err := svc.AddCampaignCost(ctx, &CampaignCostItem{
		WorkspaceID: wsID,
		CampaignID:  campaign.CampaignID,
		CostType:    "ads_spend",
		Amount:      mustDecimal(t, "500.000000"),
		Currency:    "USD",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if res1.WarningEmitted || res1.AlertEmitted {
		t.Fatalf("50%% spend should not emit warning or alert")
	}

	// Step 2: Add $300 cost (total $800 = 80%) -> Warning emitted!
	res2, err := svc.AddCampaignCost(ctx, &CampaignCostItem{
		WorkspaceID: wsID,
		CampaignID:  campaign.CampaignID,
		CostType:    "creator_payout",
		Amount:      mustDecimal(t, "300.000000"),
		Currency:    "USD",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !res2.WarningEmitted {
		t.Fatalf("80%% spend MUST emit warning")
	}
	if res2.AlertEmitted {
		t.Fatalf("80%% spend should not emit alert")
	}

	// Step 3: Add $200 cost (total $1,000 = 100%) -> Alert emitted!
	res3, err := svc.AddCampaignCost(ctx, &CampaignCostItem{
		WorkspaceID: wsID,
		CampaignID:  campaign.CampaignID,
		CostType:    "production",
		Amount:      mustDecimal(t, "200.000000"),
		Currency:    "USD",
	})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !res3.AlertEmitted {
		t.Fatalf("100%% spend MUST emit alert")
	}
	if sink.CountType("campaign.budget_exceeded") < 1 {
		t.Fatalf("expected campaign.budget_exceeded event to be emitted")
	}
}

// ----------------------------------------------------------------------------
// Offer & Coupon Lifecycle State Machine Transitions
// ----------------------------------------------------------------------------

func TestOfferAndCouponLifecycle(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	svc := NewService(store, nil, nil, nil)
	wsID := "019086a1-7c3e-7000-8000-000000000010"
	prodID := newUUID()

	// Offer: draft -> active -> paused -> active -> expired -> retired
	offer := &Offer{
		WorkspaceID:    wsID,
		OfferType:      OfferTypeProductOffer,
		ProductID:      &prodID,
		Title:          "Lifecycle Test Offer",
		PricingValue:   mustDecimal(t, "150000.000000"),
		LifecycleState: OfferStateDraft,
	}
	_ = store.CreateOffer(ctx, offer)

	// Activate
	act, err := svc.ActivateOffer(ctx, wsID, offer.OfferID)
	if err != nil || act.LifecycleState != OfferStateActive {
		t.Fatalf("expected active, got %v", act)
	}

	// Pause
	psd, err := svc.PauseOffer(ctx, wsID, offer.OfferID)
	if err != nil || psd.LifecycleState != OfferStatePaused {
		t.Fatalf("expected paused, got %v", psd)
	}

	// Resume
	res, err := svc.ResumeOffer(ctx, wsID, offer.OfferID)
	if err != nil || res.LifecycleState != OfferStateActive {
		t.Fatalf("expected active after resume, got %v", res)
	}

	// Expire
	exp, err := svc.ExpireOffer(ctx, wsID, offer.OfferID)
	if err != nil || exp.LifecycleState != OfferStateExpired {
		t.Fatalf("expected expired, got %v", exp)
	}

	// Retire (terminal)
	ret, err := svc.RetireOffer(ctx, wsID, offer.OfferID)
	if err != nil || ret.LifecycleState != OfferStateRetired {
		t.Fatalf("expected retired, got %v", ret)
	}

	// Cannot reactivate retired offer
	_, err = svc.ActivateOffer(ctx, wsID, offer.OfferID)
	if err != ErrOfferInvalidStateChange {
		t.Fatalf("expected ErrOfferInvalidStateChange on retired offer, got %v", err)
	}
}

func mustDecimal(t *testing.T, s string) tenantdb.ExactDecimal {
	t.Helper()
	d, err := tenantdb.ParseExactDecimal(s)
	if err != nil {
		t.Fatalf("invalid decimal %q: %v", s, err)
	}
	return d
}

package store

import (
	"context"
	"errors"
	"fmt"
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

func mustDecimal(t *testing.T, s string) tenantdb.ExactDecimal {
	t.Helper()
	d, err := tenantdb.ParseExactDecimal(s)
	if err != nil {
		t.Fatalf("failed to parse decimal %q: %v", s, err)
	}
	return d
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Bundle stock atomic
// ----------------------------------------------------------------------------

func TestAcceptanceTarget1_BundleStockAtomic(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	prodA := newUUID()
	prodB := newUUID()

	// 1. Initialize component products and stock
	_ = store.SetProductStock(ctx, wsID, prodA, 10)
	_ = store.SetProductStock(ctx, wsID, prodB, 5)

	bundle := &Bundle{
		WorkspaceID: wsID,
		Title:       "Summer Skincare Duo",
		BundlePrice: mustDecimal(t, "450000.000000"),
		DiscountPct: 15.0,
		Items: []BundleItem{
			{ProductID: prodA, Quantity: 1, ProductTitle: "Hydrating Cleanser"},
			{ProductID: prodB, Quantity: 1, ProductTitle: "Vitamin C Serum"},
		},
	}
	createdBundle, err := svc.CreateBundle(ctx, bundle)
	if err != nil {
		t.Fatalf("failed to create bundle: %v", err)
	}

	// 2. Check initial availability: should be available
	avail, reason, _, err := svc.CheckBundleStock(ctx, wsID, createdBundle.BundleID, 1)
	if err != nil {
		t.Fatalf("check stock failed: %v", err)
	}
	if !avail {
		t.Fatalf("expected bundle to be available, got reason: %s", reason)
	}

	// 3. Set Component B stock to 0 -> Bundle MUST be unavailable with clear explanation
	_ = store.SetProductStock(ctx, wsID, prodB, 0)

	avail2, reason2, _, err := svc.CheckBundleStock(ctx, wsID, createdBundle.BundleID, 1)
	if err != nil {
		t.Fatalf("check stock failed: %v", err)
	}
	if avail2 {
		t.Fatalf("expected bundle to be unavailable when Component B has 0 stock")
	}
	if reason2 == "" || !containsSubstring(reason2, "Temporarily unavailable") || !containsSubstring(reason2, "Vitamin C Serum") {
		t.Fatalf("expected explanation mentioning component out of stock, got: %q", reason2)
	}

	// 4. Attempt checkout with unavailable bundle -> MUST fail atomically
	checkoutReq := CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: newUUID(),
		IdempotencyKey:   "checkout_bundle_failed_01",
		PaymentIntentID:  "pi_bundle_out_of_stock_01",
		BundleID:         createdBundle.BundleID,
		OrderAmount:      mustDecimal(t, "450000.000000"),
		Currency:         "VND",
	}
	_, err = svc.Checkout(ctx, checkoutReq)
	if err == nil {
		t.Fatalf("expected checkout to fail when bundle component is out of stock")
	}

	// Stock for Product A must remain completely untouched (still 10)
	stockA, _ := store.GetProductStock(ctx, wsID, prodA)
	if stockA != 10 {
		t.Fatalf("expected Product A stock to remain 10, got %d", stockA)
	}

	// 5. Concurrency Race Test:
	// Set both Product A and B stock to 10. Run 50 concurrent checkout attempts.
	// Exactly 10 checkouts must succeed. 40 must fail. Remaining stock must be 0.
	_ = store.SetProductStock(ctx, wsID, prodA, 10)
	_ = store.SetProductStock(ctx, wsID, prodB, 10)

	var successCount int32
	var failCount int32
	var wg sync.WaitGroup
	workers := 50

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			req := CheckoutRequest{
				WorkspaceID:      wsID,
				CustomerEntityID: newUUID(),
				IdempotencyKey:   fmt.Sprintf("concurrent_bundle_race_%d", workerID),
				PaymentIntentID:  fmt.Sprintf("pi_concurrent_bundle_%d", workerID),
				BundleID:         createdBundle.BundleID,
				OrderAmount:      mustDecimal(t, "450000.000000"),
				Currency:         "VND",
			}
			res, chkErr := svc.Checkout(ctx, req)
			if chkErr == nil && res != nil && res.Success {
				atomic.AddInt32(&successCount, 1)
			} else {
				atomic.AddInt32(&failCount, 1)
			}
		}(i)
	}
	wg.Wait()

	if successCount != 10 {
		t.Fatalf("expected exactly 10 successful checkouts for stock=10, got %d", successCount)
	}
	if failCount != 40 {
		t.Fatalf("expected exactly 40 failed checkouts, got %d", failCount)
	}

	finalStockA, _ := store.GetProductStock(ctx, wsID, prodA)
	finalStockB, _ := store.GetProductStock(ctx, wsID, prodB)
	if finalStockA != 0 || finalStockB != 0 {
		t.Fatalf("expected final stock to be 0 for both components, got A=%d, B=%d", finalStockA, finalStockB)
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Payment replay no duplicate delivery
// ----------------------------------------------------------------------------

func TestAcceptanceTarget2_PaymentReplayNoDuplicateDelivery(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	customerID := newUUID()
	prodID := newUUID()
	_ = store.SetProductStock(ctx, wsID, prodID, 100)

	idempotencyKey := "stripe_pi_3N9xReplayTest_12345"

	req := CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   idempotencyKey,
		PaymentIntentID:  idempotencyKey,
		ProductIDs:       []string{prodID},
		OrderAmount:      mustDecimal(t, "199000.000000"),
		Currency:         "VND",
	}

	// 1. Initial checkout: must succeed and produce digital delivery
	res1, err := svc.Checkout(ctx, req)
	if err != nil {
		t.Fatalf("initial checkout failed: %v", err)
	}
	if !res1.Success || res1.IsReplayed {
		t.Fatalf("expected initial checkout to be successful and not replayed")
	}
	if len(res1.Deliveries) != 1 {
		t.Fatalf("expected 1 digital delivery record, got %d", len(res1.Deliveries))
	}
	firstOrderID := res1.OrderID

	// 2. Replay the exact same payment request
	res2, err := svc.Checkout(ctx, req)
	if err != nil {
		t.Fatalf("replayed checkout returned error: %v", err)
	}
	if !res2.IsReplayed {
		t.Fatalf("expected IsReplayed to be true on replay")
	}
	if res2.OrderID != firstOrderID {
		t.Fatalf("expected replayed checkout to return same order ID %s, got %s", firstOrderID, res2.OrderID)
	}

	// 3. Verify deliveries in store: must still be exactly 1 delivery! No duplicates!
	deliveries, err := store.ListDeliveriesByCustomer(ctx, wsID, customerID)
	if err != nil {
		t.Fatalf("failed to list deliveries: %v", err)
	}
	if len(deliveries) != 1 {
		t.Fatalf("expected exactly 1 delivery in database, got %d (duplicate delivery detected!)", len(deliveries))
	}

	// 4. Verify financial postings: must still be exactly 1 ledger posting!
	postings, err := store.ListFinancialPostings(ctx, wsID)
	if err != nil {
		t.Fatalf("failed to list postings: %v", err)
	}
	if len(postings) != 1 {
		t.Fatalf("expected exactly 1 financial posting in ledger, got %d", len(postings))
	}

	// 5. Verify events: order.imported fired only once
	if count := sink.CountType("order.imported"); count != 1 {
		t.Fatalf("expected 1 order.imported event, got %d", count)
	}

	// 6. Concurrency Replay Test: 20 simultaneous replay attempts
	var replayWg sync.WaitGroup
	replays := 20
	for i := 0; i < replays; i++ {
		replayWg.Add(1)
		go func() {
			defer replayWg.Done()
			r, replayErr := svc.Checkout(ctx, req)
			if replayErr != nil || r.OrderID != firstOrderID || !r.IsReplayed {
				t.Errorf("concurrent replay failed: %v", replayErr)
			}
		}()
	}
	replayWg.Wait()

	deliveriesAfter, _ := store.ListDeliveriesByCustomer(ctx, wsID, customerID)
	if len(deliveriesAfter) != 1 {
		t.Fatalf("expected 1 delivery after concurrent replays, got %d", len(deliveriesAfter))
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Buyer subscription cannot unlock SaaS privileges
// ----------------------------------------------------------------------------

func TestAcceptanceTarget3_BuyerSubscriptionCannotUnlockSaaSPrivileges(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	customerID := newUUID()

	// 1. Create a Creator Store Membership Plan with audience entitlements
	plan := &MembershipPlan{
		WorkspaceID:     wsID,
		Title:           "VIP Fan Tier",
		Price:           mustDecimal(t, "199000.000000"),
		Currency:        "VND",
		BillingInterval: "monthly",
		Status:          MembershipPlanStatusActive,
		EntitlementConfigJSON: map[string]any{
			"exclusive_content_ids": []any{"post_101", "post_102"},
			"store_discount_pct":    20.0,
			"priority_dm":           true,
		},
	}
	createdPlan, err := svc.CreatePlan(ctx, plan)
	if err != nil {
		t.Fatalf("failed to create plan: %v", err)
	}

	// 2. Buyer subscribes via Store Checkout
	checkoutReq := CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "sub_checkout_buyer_001",
		PaymentIntentID:  "sub_stripe_pi_999",
		MembershipPlanID: createdPlan.PlanID,
		OrderAmount:      mustDecimal(t, "199000.000000"),
		Currency:         "VND",
	}
	res, err := svc.Checkout(ctx, checkoutReq)
	if err != nil {
		t.Fatalf("subscription checkout failed: %v", err)
	}
	if res.Subscription == nil || res.Subscription.Status != MembershipSubscriptionStatusActive {
		t.Fatalf("expected active subscription, got %+v", res.Subscription)
	}

	// 3. Verify buyer entitlements can be queried
	ent, err := svc.GetBuyerEntitlements(ctx, wsID, customerID)
	if err != nil {
		t.Fatalf("failed to get entitlements: %v", err)
	}
	if len(ent.AccessibleContentIDs) != 2 || ent.DiscountPct != 20.0 || !ent.HasPriorityDM {
		t.Fatalf("unexpected entitlements: %+v", ent)
	}

	// 4. Security Verification:
	// Verify that the buyer subscription CANNOT unlock SaaS workspace privileges!
	// (DB Schema §19.4 / §19.4B rule: creator-store entitlements != SaaS workspace privileges)

	restrictedActions := []string{
		"store:manage",
		"product:manage",
		"product:delete",
		"order:manage",
		"campaign:manage",
		"coupon:manage",
		"workspace:admin",
		"identity:manage_members",
		"billing:manage",
	}

	for _, action := range restrictedActions {
		// As buyer/customer: MUST BE FORBIDDEN
		err := svc.ValidateBuyerPrivilegeIsolation("buyer", true, action)
		if err == nil {
			t.Fatalf("SECURITY VIOLATION: buyer membership permitted SaaS action %q!", action)
		}
		if !containsSubstring(err.Error(), "store: buyer store subscription cannot unlock SaaS workspace privileges") {
			t.Fatalf("expected ErrForbiddenSaaSFromBuyerMembership for %q, got: %v", action, err)
		}
	}

	// 5. Legitimate workspace roles (e.g. editor or manager) ARE allowed
	if err := svc.ValidateBuyerPrivilegeIsolation("editor", false, "store:manage"); err != nil {
		t.Fatalf("unexpected failure for editor role: %v", err)
	}
	if err := svc.ValidateBuyerPrivilegeIsolation("manager", false, "product:manage"); err != nil {
		t.Fatalf("unexpected failure for manager role: %v", err)
	}
}

// ----------------------------------------------------------------------------
// Store Page Builder & Publishing (RULE-M15-001 & RULE-M15-004)
// ----------------------------------------------------------------------------

func TestStorePageLifecycleAndPublishing(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	// 1. Create page
	page := &StorePage{
		WorkspaceID: wsID,
		Title:       "Summer Skincare Collection",
		Slug:        "summer-skincare",
		Description: "Glow from within this summer",
		LayoutJSON: map[string]any{
			"sections": []string{"hero", "product_grid", "testimonials"},
		},
	}
	created, err := svc.CreatePage(ctx, page)
	if err != nil {
		t.Fatalf("failed to create page: %v", err)
	}
	if created.Status != StorePageStatusDraft {
		t.Fatalf("expected draft status, got %s", created.Status)
	}

	// 2. Publish page
	published, pubURL, err := svc.PublishPage(ctx, wsID, created.StorePageID)
	if err != nil {
		t.Fatalf("failed to publish page: %v", err)
	}
	if published.Status != StorePageStatusPublished {
		t.Fatalf("expected published status, got %s", published.Status)
	}
	if pubURL != "https://"+wsID+".creativanta.store/summer-skincare" {
		t.Fatalf("unexpected public url: %s", pubURL)
	}

	// Verify domain event emitted
	if count := sink.CountType("store.page_published"); count != 1 {
		t.Fatalf("expected 1 store.page_published event, got %d", count)
	}

	// 3. Stats tracking
	_ = store.RecordPageView(ctx, wsID, created.StorePageID)
	_ = store.RecordPageView(ctx, wsID, created.StorePageID)

	stats, err := svc.GetPageStats(ctx, wsID, created.StorePageID)
	if err != nil {
		t.Fatalf("failed to get stats: %v", err)
	}
	if stats.Views != 2 {
		t.Fatalf("expected 2 page views, got %d", stats.Views)
	}
}

// ----------------------------------------------------------------------------
// Membership Plans & MRR Tracking (RULE-M15-003)
// ----------------------------------------------------------------------------

func TestMembershipPlanAndMRRTracking(t *testing.T) {
	ctx := context.Background()
	store := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(store, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000010"

	// Create plan
	plan := &MembershipPlan{
		WorkspaceID: wsID,
		Title:       "Pro Member",
		Price:       mustDecimal(t, "100000.000000"),
		Currency:    "VND",
	}
	created, err := svc.CreatePlan(ctx, plan)
	if err != nil {
		t.Fatalf("failed to create plan: %v", err)
	}
	if _, err := svc.PublishPlan(ctx, wsID, created.PlanID); err != nil {
		t.Fatalf("failed to publish plan: %v", err)
	}

	// Subscribe 3 members
	for i := 0; i < 3; i++ {
		req := CheckoutRequest{
			WorkspaceID:      wsID,
			CustomerEntityID: newUUID(),
			IdempotencyKey:   fmt.Sprintf("sub_checkout_%d", i),
			PaymentIntentID:  fmt.Sprintf("pi_%d", i),
			MembershipPlanID: created.PlanID,
			OrderAmount:      mustDecimal(t, "100000.000000"),
			Currency:         "VND",
		}
		if _, err := svc.Checkout(ctx, req); err != nil {
			t.Fatalf("sub checkout %d failed: %v", i, err)
		}
	}

	// Verify MRR
	mrr, cur, subs, churn, _, _, err := svc.GetMRRSummary(ctx, wsID)
	if err != nil {
		t.Fatalf("get MRR summary failed: %v", err)
	}
	if subs != 3 {
		t.Fatalf("expected 3 active subscribers, got %d", subs)
	}
	// 3 * 100,000 = 300,000
	if mrr.String() != "300000" {
		t.Fatalf("expected MRR 300000, got %s", mrr.String())
	}
	if cur != "VND" {
		t.Fatalf("expected currency VND, got %s", cur)
	}
	if churn <= 0 {
		t.Fatalf("expected positive churn rate benchmark, got %f", churn)
	}
}

func containsSubstring(s, sub string) bool {
	return len(s) >= len(sub) && (s == sub || (len(sub) > 0 && searchSubstring(s, sub)))
}

func searchSubstring(s, sub string) bool {
	for i := 0; i <= len(s)-len(sub); i++ {
		if s[i:i+len(sub)] == sub {
			return true
		}
	}
	return false
}

// STORE-01: Checkout must never grant digital delivery, activate membership, deduct stock,
// or post revenue without confirmed payment, and must enforce strict idempotency payload matching.
func TestCheckoutRequiresConfirmedPaymentAndEnforcesStrictIdempotency(t *testing.T) {
	ctx := context.Background()
	mem := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc := NewService(mem, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000099"
	customerID := newUUID()
	prodID := newUUID()
	_ = mem.SetProductStock(ctx, wsID, prodID, 5)

	plan, err := svc.CreatePlan(ctx, &MembershipPlan{
		WorkspaceID: wsID,
		Title:       "Creator Plus",
		Price:       mustDecimal(t, "150000.000000"),
		Currency:    "VND",
	})
	if err != nil {
		t.Fatalf("CreatePlan failed: %v", err)
	}
	_, _ = svc.PublishPlan(ctx, wsID, plan.PlanID)

	// 1. Missing PaymentIntentID must fail with ErrPaymentRequired and grant nothing
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "idem_no_pi",
		PaymentIntentID:  "",
		ProductIDs:       []string{prodID},
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPaymentRequired) {
		t.Fatalf("expected ErrPaymentRequired when PaymentIntentID is empty, got %v", err)
	}

	// 2. Failed/declined PaymentIntentID must fail with ErrPaymentFailed and grant nothing
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "idem_failed_pi",
		PaymentIntentID:  "pi_failed_card_declined",
		ProductIDs:       []string{prodID},
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPaymentFailed) {
		t.Fatalf("expected ErrPaymentFailed on declined payment intent, got %v", err)
	}

	// 3. Pending/unconfirmed PaymentIntentID returns pending_payment with zero deliveries, memberships, or postings
	pendingRes, err := svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "idem_pending_then_paid",
		PaymentIntentID:  "pi_pending_3ds_challenge",
		ProductIDs:       []string{prodID},
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if err != nil {
		t.Fatalf("unexpected error on pending payment intent: %v", err)
	}
	if pendingRes.Success || pendingRes.Status != "pending_payment" || len(pendingRes.Deliveries) != 0 || pendingRes.Subscription != nil {
		t.Fatalf("expected pending_payment with no deliveries or subscription, got %+v", pendingRes)
	}
	deliveries, _ := mem.ListDeliveriesByCustomer(ctx, wsID, customerID)
	subs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, customerID)
	postings, _ := mem.ListFinancialPostings(ctx, wsID)
	if len(deliveries) != 0 || len(subs) != 0 || len(postings) != 0 {
		t.Fatalf("expected 0 deliveries, 0 subscriptions, 0 postings before payment confirmation, got deliv=%d subs=%d post=%d",
			len(deliveries), len(subs), len(postings))
	}

	// 4. Price tampering on membership plan must fail with ErrPriceMismatch
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "idem_tampered_price",
		PaymentIntentID:  "pi_succeeded_tampered",
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "1000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPriceMismatch) {
		t.Fatalf("expected ErrPriceMismatch on tampered plan price, got %v", err)
	}

	// 5. Confirmed payment succeeds and grants delivery + active membership
	confirmedRes, err := svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "idem_pending_then_paid",
		PaymentIntentID:  "pi_succeeded_confirmed_01",
		ProductIDs:       []string{prodID},
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if err != nil || !confirmedRes.Success || confirmedRes.Status != "confirmed" {
		t.Fatalf("expected confirmed checkout after payment capture, got res=%+v err=%v", confirmedRes, err)
	}
	if confirmedRes.OrderID != pendingRes.OrderID {
		t.Fatalf("expected pending order ID %s to be preserved on confirmation, got %s", pendingRes.OrderID, confirmedRes.OrderID)
	}

	// 6. Replaying the same IdempotencyKey with a modified payload (e.g. different amount or customer) must return ErrPaymentReplay
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "idem_pending_then_paid",
		PaymentIntentID:  "pi_succeeded_confirmed_01",
		ProductIDs:       []string{prodID},
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "999999.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPaymentReplay) {
		t.Fatalf("expected ErrPaymentReplay when replaying idempotency key with altered amount, got %v", err)
	}

	// 7. Unpublished storefront check: if workspace has only draft pages, checkout must fail with ErrStorefrontNotPublished
	_, err = svc.CreatePage(ctx, &StorePage{
		WorkspaceID: wsID,
		Title:       "Draft Storefront",
		Slug:        "draft-storefront",
	})
	if err != nil {
		t.Fatalf("CreatePage failed: %v", err)
	}
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "idem_unpublished_store",
		PaymentIntentID:  "pi_succeeded_02",
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrStorefrontNotPublished) {
		t.Fatalf("expected ErrStorefrontNotPublished when storefront has only draft pages, got %v", err)
	}
}

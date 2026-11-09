package store

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func syntheticTestPaymentVerifier(_ context.Context, _, paymentIntentID string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
	pi := strings.TrimSpace(paymentIntentID)
	if pi == "" {
		return PaymentStatusFailed, ErrPaymentRequired
	}
	lower := strings.ToLower(pi)
	if strings.HasPrefix(lower, "pi_failed") || strings.HasPrefix(lower, "pi_declined") ||
		strings.HasPrefix(lower, "pi_canceled") || strings.HasPrefix(lower, "pi_cancelled") ||
		strings.HasSuffix(lower, "_failed") || strings.HasSuffix(lower, "_declined") {
		return PaymentStatusFailed, ErrPaymentFailed
	}
	if strings.HasPrefix(lower, "pi_pending") || strings.HasPrefix(lower, "pi_unconfirmed") ||
		strings.HasPrefix(lower, "pi_unknown") || strings.HasPrefix(lower, "pi_requires_") ||
		strings.HasSuffix(lower, "_pending") || strings.HasSuffix(lower, "_unconfirmed") {
		return PaymentStatusPending, nil
	}
	return PaymentStatusSucceeded, nil
}

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
	svc.SetPaymentVerifier(syntheticTestPaymentVerifier)

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
	svc.SetPaymentVerifier(syntheticTestPaymentVerifier)

	wsID := "019086a1-7c3e-7000-8000-000000000010"
	customerID := newUUID()
	prodID := newUUID()
	_ = store.SetProductStock(ctx, wsID, prodID, 100)
	_ = svc.UpsertProduct(ctx, &StoreProduct{
		ProductID:   prodID,
		WorkspaceID: wsID,
		Title:       "Digital Course Pack",
		Price:       mustDecimal(t, "199000.000000"),
		Currency:    "VND",
		Status:      ProductStatusActive,
	})

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
	svc.SetPaymentVerifier(syntheticTestPaymentVerifier)

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
	svc.SetPaymentVerifier(syntheticTestPaymentVerifier)

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
	svc.SetPaymentVerifier(syntheticTestPaymentVerifier)

	wsID := "019086a1-7c3e-7000-8000-000000000099"
	customerID := newUUID()
	prodID := newUUID()
	_ = mem.SetProductStock(ctx, wsID, prodID, 5)
	_ = svc.UpsertProduct(ctx, &StoreProduct{
		ProductID:   prodID,
		WorkspaceID: wsID,
		Title:       "Bonus Member Pack",
		Price:       tenantdb.ZeroDecimal(),
		Currency:    "VND",
		Status:      ProductStatusActive,
	})

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

func TestRemediation_F02_F03_F04_CheckoutSecurityAndAtomicity(t *testing.T) {
	ctx := context.Background()
	mem := NewMemoryStore()
	sink := &mockSink{}
	now := time.Date(2026, 11, 6, 12, 0, 0, 0, time.UTC)
	svc := NewService(mem, sink, func() time.Time { return now })

	wsID := "019086a1-7c3e-7000-8000-000000000777"
	otherWsID := "019086a1-7c3e-7000-8000-000000000888"
	customerID := newUUID()

	plan, err := svc.CreatePlan(ctx, &MembershipPlan{
		WorkspaceID: wsID,
		Title:       "Gold Plan",
		Price:       mustDecimal(t, "150000.000000"),
		Currency:    "VND",
	})
	if err != nil {
		t.Fatalf("CreatePlan failed: %v", err)
	}
	if _, err := svc.PublishPlan(ctx, wsID, plan.PlanID); err != nil {
		t.Fatalf("PublishPlan failed: %v", err)
	}

	// =========================================================================
	// F02: Default payment verifier must fail closed on unverified/mismatched intents
	// =========================================================================

	// 1. Arbitrary unverified PaymentIntentID="anything" is rejected with ErrPaymentNotVerified
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f02_forged_pi",
		PaymentIntentID:  "anything",
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPaymentNotVerified) {
		t.Fatalf("F02: expected ErrPaymentNotVerified on arbitrary PaymentIntentID, got %v", err)
	}

	// 2. PaymentIntent verified for a different workspace is rejected (tenant isolation)
	_ = svc.RecordVerifiedPaymentIntent(ctx, &VerifiedPaymentIntent{
		WorkspaceID:     otherWsID,
		PaymentIntentID: "pi_other_ws",
		Amount:          mustDecimal(t, "150000.000000"),
		Currency:        "VND",
		Status:          PaymentStatusSucceeded,
	})
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f02_cross_tenant_pi",
		PaymentIntentID:  "pi_other_ws",
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPaymentNotVerified) {
		t.Fatalf("F02: expected ErrPaymentNotVerified on cross-tenant PaymentIntentID, got %v", err)
	}

	// 3. PaymentIntent verified for smaller amount (1 VND vs 150,000 VND) or wrong currency (USD vs VND) is rejected
	_ = svc.RecordVerifiedPaymentIntent(ctx, &VerifiedPaymentIntent{
		WorkspaceID:     wsID,
		PaymentIntentID: "pi_wrong_amount",
		Amount:          mustDecimal(t, "1.000000"),
		Currency:        "VND",
		Status:          PaymentStatusSucceeded,
	})
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f02_wrong_amount_pi",
		PaymentIntentID:  "pi_wrong_amount",
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPriceMismatch) {
		t.Fatalf("F02: expected ErrPriceMismatch when verified payment amount != order amount, got %v", err)
	}

	_ = svc.RecordVerifiedPaymentIntent(ctx, &VerifiedPaymentIntent{
		WorkspaceID:     wsID,
		PaymentIntentID: "pi_wrong_currency",
		Amount:          mustDecimal(t, "150000.000000"),
		Currency:        "USD",
		Status:          PaymentStatusSucceeded,
	})
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f02_wrong_currency_pi",
		PaymentIntentID:  "pi_wrong_currency",
		MembershipPlanID: plan.PlanID,
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPriceMismatch) {
		t.Fatalf("F02: expected ErrPriceMismatch when verified payment currency != order currency, got %v", err)
	}

	// =========================================================================
	// F03: Mixed-cart pricing bypass, tenant item resolution, offer & currency checks
	// =========================================================================

	// 1. Adding an unknown or cross-tenant ProductID to a MembershipPlan checkout cannot bypass plan price
	otherTenantProdID := newUUID()
	_ = svc.UpsertProduct(ctx, &StoreProduct{
		ProductID:   otherTenantProdID,
		WorkspaceID: otherWsID,
		Title:       "Other Tenant Product",
		Price:       mustDecimal(t, "50000.000000"),
		Currency:    "VND",
		Status:      ProductStatusActive,
	})
	_ = svc.RecordVerifiedPaymentIntent(ctx, &VerifiedPaymentIntent{
		WorkspaceID:     wsID,
		PaymentIntentID: "pi_1_vnd",
		Amount:          mustDecimal(t, "1.000000"),
		Currency:        "VND",
		Status:          PaymentStatusSucceeded,
	})
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f03_unknown_prod_bypass",
		PaymentIntentID:  "pi_1_vnd",
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{otherTenantProdID},
		OrderAmount:      mustDecimal(t, "1.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrProductNotFound) {
		t.Fatalf("F03: expected ErrProductNotFound for cross-tenant/unknown ProductID, got %v", err)
	}

	// 2. Valid tenant product (50,000 VND) + MembershipPlan (150,000 VND) = 200,000 VND.
	//    Paying 1 VND or 150,000 VND must fail with ErrPriceMismatch!
	validProdID := newUUID()
	_ = svc.UpsertProduct(ctx, &StoreProduct{
		ProductID:   validProdID,
		WorkspaceID: wsID,
		Title:       "Creator LUT Pack",
		Price:       mustDecimal(t, "50000.000000"),
		Currency:    "VND",
		Status:      ProductStatusActive,
	})
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f03_mixed_cart_1vnd",
		PaymentIntentID:  "pi_1_vnd",
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{validProdID},
		OrderAmount:      mustDecimal(t, "1.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPriceMismatch) {
		t.Fatalf("F03: expected ErrPriceMismatch when paying 1 VND for 200,000 VND mixed cart, got %v", err)
	}
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f03_mixed_cart_150k",
		PaymentIntentID:  "pi_150k",
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{validProdID},
		OrderAmount:      mustDecimal(t, "150000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPriceMismatch) {
		t.Fatalf("F03: expected ErrPriceMismatch when omitting product price in mixed cart, got %v", err)
	}

	// 3. Expired offer with normal UUID (no "expired" substring in ID) must be rejected with ErrOfferExpired
	expiredOfferUUID := newUUID()
	pastTime := now.Add(-1 * time.Hour)
	_ = svc.UpsertOffer(ctx, &StoreOffer{
		OfferID:        expiredOfferUUID,
		WorkspaceID:    wsID,
		Title:          "Flash Sale Offer",
		Price:          mustDecimal(t, "25000.000000"),
		Currency:       "VND",
		LifecycleState: OfferStateActive,
		ExpiresAt:      &pastTime,
	})
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f03_expired_uuid_offer",
		PaymentIntentID:  "pi_25k",
		OfferID:          expiredOfferUUID,
		OrderAmount:      mustDecimal(t, "25000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrOfferExpired) {
		t.Fatalf("F03: expected ErrOfferExpired for timestamp-expired UUID offer, got %v", err)
	}

	// 4. Bundle currency mismatch (USD bundle paid in VND) must be rejected with ErrPriceMismatch
	compID := newUUID()
	_ = mem.SetProductStock(ctx, wsID, compID, 10)
	usdBundle, err := svc.CreateBundle(ctx, &Bundle{
		WorkspaceID: wsID,
		Title:       "Global USD Bundle",
		BundlePrice: mustDecimal(t, "99.000000"),
		Currency:    "USD",
		Items:       []BundleItem{{ProductID: compID, Quantity: 1, ProductTitle: "Item 1"}},
	})
	if err != nil {
		t.Fatalf("CreateBundle failed: %v", err)
	}
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f03_bundle_currency_mismatch",
		PaymentIntentID:  "pi_usd_bundle_vnd",
		BundleID:         usdBundle.BundleID,
		OrderAmount:      mustDecimal(t, "99.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPriceMismatch) {
		t.Fatalf("F03: expected ErrPriceMismatch on bundle currency mismatch, got %v", err)
	}

	// =========================================================================
	// F04: Single PaymentIntent cannot grant duplicate entitlements across IdempotencyKeys
	//      or concurrent requests
	// =========================================================================

	activeOfferUUID := newUUID()
	futureTime := now.Add(24 * time.Hour)
	_ = svc.UpsertOffer(ctx, &StoreOffer{
		OfferID:        activeOfferUUID,
		WorkspaceID:    wsID,
		Title:          "Active Addon Offer",
		Price:          mustDecimal(t, "25000.000000"),
		Currency:       "VND",
		LifecycleState: OfferStateActive,
		ExpiresAt:      &futureTime,
	})

	// Total mixed cart = 150,000 (plan) + 50,000 (product) + 25,000 (offer) = 225,000 VND
	verifiedPI := "pi_verified_mixed_225k"
	_ = svc.RecordVerifiedPaymentIntent(ctx, &VerifiedPaymentIntent{
		WorkspaceID:     wsID,
		PaymentIntentID: verifiedPI,
		Amount:          mustDecimal(t, "225000.000000"),
		Currency:        "VND",
		Status:          PaymentStatusSucceeded,
	})

	// Run 20 concurrent requests: 10 with IdempotencyKey="f04_idem_primary" and 10 with distinct IdempotencyKeys
	// all attempting to consume the SAME verified PaymentIntentID!
	var wg sync.WaitGroup
	var firstSuccessCount int32
	var replaySuccessCount int32
	var rejectedReplayCount int32

	for i := 0; i < 20; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			idemKey := "f04_idem_primary"
			if idx >= 10 {
				idemKey = fmt.Sprintf("f04_idem_attacker_%d", idx)
			}
			res, cErr := svc.Checkout(ctx, CheckoutRequest{
				WorkspaceID:      wsID,
				CustomerEntityID: customerID,
				IdempotencyKey:   idemKey,
				PaymentIntentID:  verifiedPI,
				MembershipPlanID: plan.PlanID,
				ProductIDs:       []string{validProdID},
				OfferID:          activeOfferUUID,
				OrderAmount:      mustDecimal(t, "225000.000000"),
				Currency:         "VND",
			})
			if cErr != nil {
				if errors.Is(cErr, ErrPaymentReplay) {
					atomic.AddInt32(&rejectedReplayCount, 1)
				} else {
					t.Errorf("unexpected error in concurrent checkout %d: %v", idx, cErr)
				}
				return
			}
			if res.IsReplayed {
				atomic.AddInt32(&replaySuccessCount, 1)
			} else {
				atomic.AddInt32(&firstSuccessCount, 1)
			}
		}(i)
	}
	wg.Wait()

	if firstSuccessCount != 1 {
		t.Fatalf("F04: expected exactly 1 non-replayed checkout execution for a single PaymentIntentID, got %d (replayed=%d, rejected=%d)",
			firstSuccessCount, replaySuccessCount, rejectedReplayCount)
	}

	// Sequential attempt to reuse the already-settled PaymentIntentID with a fresh IdempotencyKey MUST fail with ErrPaymentReplay
	_, err = svc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: customerID,
		IdempotencyKey:   "f04_fresh_idem_same_pi",
		PaymentIntentID:  verifiedPI,
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{validProdID},
		OfferID:          activeOfferUUID,
		OrderAmount:      mustDecimal(t, "225000.000000"),
		Currency:         "VND",
	})
	if !errors.Is(err, ErrPaymentReplay) {
		t.Fatalf("F04: expected ErrPaymentReplay when reusing PaymentIntentID with a different IdempotencyKey, got %v", err)
	}

	subs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, customerID)
	deliveries, _ := mem.ListDeliveriesByCustomer(ctx, wsID, customerID)
	postings, _ := mem.ListFinancialPostings(ctx, wsID)
	if len(subs) != 1 || len(deliveries) != 1 || len(postings) != 1 {
		t.Fatalf("F04: expected exactly 1 subscription, 1 delivery, 1 financial posting, got subs=%d deliv=%d post=%d",
			len(subs), len(deliveries), len(postings))
	}

	// Partial failure rollback test: if RecordFinancialPosting fails after bundle stock reservation,
	// subscription creation, and digital delivery creation, all mutations must roll back cleanly.
	rollbackCustomerID := newUUID()
	vndBundle, err := svc.CreateBundle(ctx, &Bundle{
		WorkspaceID: wsID,
		Title:       "VND Rollback Bundle",
		BundlePrice: mustDecimal(t, "100000.000000"),
		Currency:    "VND",
		Items:       []BundleItem{{ProductID: compID, Quantity: 2, ProductTitle: "Item 1"}},
	})
	if err != nil {
		t.Fatalf("CreateBundle failed: %v", err)
	}
	_ = svc.RecordVerifiedPaymentIntent(ctx, &VerifiedPaymentIntent{
		WorkspaceID:     wsID,
		PaymentIntentID: "pi_rollback_test_300k",
		Amount:          mustDecimal(t, "300000.000000"),
		Currency:        "VND",
		Status:          PaymentStatusSucceeded,
	})
	failStore := &failingFinancialPostingStore{Store: mem}
	failSvc := NewService(failStore, sink, func() time.Time { return now })
	_, err = failSvc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: rollbackCustomerID,
		IdempotencyKey:   "f04_rollback_on_posting_error",
		PaymentIntentID:  "pi_rollback_test_300k",
		BundleID:         vndBundle.BundleID,
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{validProdID},
		OrderAmount:      mustDecimal(t, "300000.000000"),
		Currency:         "VND",
	})
	if err == nil {
		t.Fatalf("F04: expected checkout to fail when RecordFinancialPosting returns an error")
	}
	stockAfterRollback, _ := mem.GetProductStock(ctx, wsID, compID)
	if stockAfterRollback != 10 {
		t.Fatalf("F04: expected bundle component stock to roll back to 10 after failure, got %d", stockAfterRollback)
	}
	rbSubs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, rollbackCustomerID)
	rbDelivs, _ := mem.ListDeliveriesByCustomer(ctx, wsID, rollbackCustomerID)
	if len(rbSubs) != 0 || len(rbDelivs) != 0 {
		t.Fatalf("F04: expected 0 subscriptions and 0 deliveries after failed checkout rollback, got subs=%d deliv=%d",
			len(rbSubs), len(rbDelivs))
	}
}

type failingFinancialPostingStore struct {
	Store
}

func (f *failingFinancialPostingStore) RecordFinancialPosting(_ context.Context, _ *FinancialPosting) error {
	return errors.New("simulated ledger posting failure")
}

type failingSaveCheckoutStore struct {
	Store
	failSave bool
}

func (f *failingSaveCheckoutStore) SaveCheckoutResult(ctx context.Context, workspaceID, idempotencyKey string, result *CheckoutResult) error {
	if f.failSave {
		return errors.New("simulated SaveCheckoutResult persistence failure")
	}
	return f.Store.SaveCheckoutResult(ctx, workspaceID, idempotencyKey, result)
}

func TestRemediation_R02_CrossInstanceCheckoutIdempotencyAndAtomicCompensation(t *testing.T) {
	ctx := context.Background()
	now := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)
	mem := NewMemoryStore()
	sink := &mockSink{}

	wsID := newUUID()
	customerID := newUUID()
	prodID := newUUID()
	compID := newUUID()

	_ = mem.SetProductStock(ctx, wsID, compID, 5)
	svc1 := NewService(mem, sink, func() time.Time { return now })
	svc2 := NewService(mem, sink, func() time.Time { return now })

	if err := svc1.UpsertProduct(ctx, &StoreProduct{
		ProductID:   prodID,
		WorkspaceID: wsID,
		Title:       "Cross-Instance Digital Pack",
		Price:       mustDecimal(t, "50000.000000"),
		Currency:    "VND",
		Status:      ProductStatusActive,
	}); err != nil {
		t.Fatalf("UpsertProduct failed: %v", err)
	}
	bundle, err := svc1.CreateBundle(ctx, &Bundle{
		WorkspaceID: wsID,
		Title:       "Cross-Instance Bundle",
		BundlePrice: mustDecimal(t, "100000.000000"),
		Currency:    "VND",
		Items:       []BundleItem{{ProductID: compID, Quantity: 1, ProductTitle: "Comp"}},
	})
	if err != nil {
		t.Fatalf("CreateBundle failed: %v", err)
	}
	plan, err := svc1.CreatePlan(ctx, &MembershipPlan{
		WorkspaceID: wsID,
		Title:       "Cross-Instance VIP",
		Price:       mustDecimal(t, "150000.000000"),
		Currency:    "VND",
	})
	if err != nil {
		t.Fatalf("CreatePlan failed: %v", err)
	}
	if _, err := svc1.PublishPlan(ctx, wsID, plan.PlanID); err != nil {
		t.Fatalf("PublishPlan failed: %v", err)
	}

	// Barrier inside PaymentVerifier so both Service instances (svc1 and svc2) pass initial read-only prechecks concurrently.
	var arrived int32
	releaseCh := make(chan struct{})
	barrierVerifier := func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
		if atomic.AddInt32(&arrived, 1) == 2 {
			close(releaseCh)
		}
		select {
		case <-releaseCh:
		case <-time.After(2 * time.Second):
		}
		return PaymentStatusSucceeded, nil
	}
	svc1.SetPaymentVerifier(barrierVerifier)
	svc2.SetPaymentVerifier(barrierVerifier)

	// 1. Two Service instances concurrently attempt checkout with the SAME PaymentIntentID and DIFFERENT IdempotencyKeys.
	const sharedPI = "pi_r02_cross_instance_diff_idem"
	var wg sync.WaitGroup
	errs := make([]error, 2)
	results := make([]*CheckoutResult, 2)

	for idx, inst := range []*Service{svc1, svc2} {
		wg.Add(1)
		go func(i int, s *Service) {
			defer wg.Done()
			results[i], errs[i] = s.Checkout(ctx, CheckoutRequest{
				WorkspaceID:      wsID,
				CustomerEntityID: customerID,
				IdempotencyKey:   fmt.Sprintf("r02-diff-idem-%d", i),
				PaymentIntentID:  sharedPI,
				BundleID:         bundle.BundleID,
				MembershipPlanID: plan.PlanID,
				ProductIDs:       []string{prodID},
				OrderAmount:      mustDecimal(t, "300000.000000"),
				Currency:         "VND",
			})
		}(idx, inst)
	}
	wg.Wait()

	successes := 0
	replayErrors := 0
	for i := 0; i < 2; i++ {
		if errs[i] == nil {
			successes++
		} else if errors.Is(errs[i], ErrPaymentReplay) {
			replayErrors++
		} else {
			t.Fatalf("unexpected error on instance %d: %v", i, errs[i])
		}
	}
	if successes != 1 || replayErrors != 1 {
		t.Fatalf("R02 VIOLATION: expected 1 success and 1 ErrPaymentReplay across two Service instances, got successes=%d replayErrors=%d (res0=%+v, res1=%+v)",
			successes, replayErrors, results[0], results[1])
	}

	subs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, customerID)
	delivs, _ := mem.ListDeliveriesByCustomer(ctx, wsID, customerID)
	postings, _ := mem.ListFinancialPostings(ctx, wsID)
	stock, _ := mem.GetProductStock(ctx, wsID, compID)
	if len(subs) != 1 || len(delivs) != 1 || len(postings) != 1 || stock != 4 {
		t.Fatalf("R02 VIOLATION: expected 1 sub, 1 delivery, 1 posting, stock=4 across instances; got subs=%d delivs=%d postings=%d stock=%d",
			len(subs), len(delivs), len(postings), stock)
	}

	// 2. Two Service instances concurrently attempt checkout with the SAME PaymentIntentID and SAME IdempotencyKey.
	var arrivedSame int32
	releaseSameCh := make(chan struct{})
	sameBarrierVerifier := func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
		if atomic.AddInt32(&arrivedSame, 1) == 2 {
			close(releaseSameCh)
		}
		select {
		case <-releaseSameCh:
		case <-time.After(2 * time.Second):
		}
		return PaymentStatusSucceeded, nil
	}
	svc1.SetPaymentVerifier(sameBarrierVerifier)
	svc2.SetPaymentVerifier(sameBarrierVerifier)

	sameCustID := newUUID()
	const samePI = "pi_r02_cross_instance_same_idem"
	var wgSame sync.WaitGroup
	errsSame := make([]error, 2)
	resultsSame := make([]*CheckoutResult, 2)
	for idx, inst := range []*Service{svc1, svc2} {
		wgSame.Add(1)
		go func(i int, s *Service) {
			defer wgSame.Done()
			resultsSame[i], errsSame[i] = s.Checkout(ctx, CheckoutRequest{
				WorkspaceID:      wsID,
				CustomerEntityID: sameCustID,
				IdempotencyKey:   "r02-same-idem-key",
				PaymentIntentID:  samePI,
				BundleID:         bundle.BundleID,
				MembershipPlanID: plan.PlanID,
				ProductIDs:       []string{prodID},
				OrderAmount:      mustDecimal(t, "300000.000000"),
				Currency:         "VND",
			})
		}(idx, inst)
	}
	wgSame.Wait()

	if errsSame[0] != nil || errsSame[1] != nil {
		t.Fatalf("expected both concurrent same-idempotency checkouts to succeed, got err0=%v err1=%v", errsSame[0], errsSame[1])
	}
	if resultsSame[0].OrderID != resultsSame[1].OrderID {
		t.Fatalf("expected identical OrderID across concurrent same-idempotency calls, got %s vs %s", resultsSame[0].OrderID, resultsSame[1].OrderID)
	}
	if resultsSame[0].IsReplayed == resultsSame[1].IsReplayed {
		t.Fatalf("expected exactly one primary (IsReplayed=false) and one replay (IsReplayed=true), got %v and %v",
			resultsSame[0].IsReplayed, resultsSame[1].IsReplayed)
	}
	sameSubs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, sameCustID)
	sameDelivs, _ := mem.ListDeliveriesByCustomer(ctx, wsID, sameCustID)
	postingsAfterSame, _ := mem.ListFinancialPostings(ctx, wsID)
	stockAfterSame, _ := mem.GetProductStock(ctx, wsID, compID)
	if len(sameSubs) != 1 || len(sameDelivs) != 1 || len(postingsAfterSame) != 2 || stockAfterSame != 3 {
		t.Fatalf("expected 1 sub, 1 delivery for sameCustID, 2 total postings, stock=3; got subs=%d delivs=%d postings=%d stock=%d",
			len(sameSubs), len(sameDelivs), len(postingsAfterSame), stockAfterSame)
	}

	// 3. Direct SaveCheckoutResult defense-in-depth: cannot overwrite an already-bound PaymentIntentID with a different IdempotencyKey.
	if err := mem.SaveCheckoutResult(ctx, wsID, "r02-forged-overwrite-idem", &CheckoutResult{
		Success:            true,
		OrderID:            newUUID(),
		Status:             "confirmed",
		PaymentIntentID:    samePI,
		RequestFingerprint: "fp-forged",
	}); !errors.Is(err, ErrPaymentReplay) {
		t.Fatalf("expected SaveCheckoutResult with conflicting IdempotencyKey for bound PaymentIntentID to fail with ErrPaymentReplay, got %v", err)
	}

	// 4. If SaveCheckoutResult fails after RecordFinancialPosting succeeded, rollback() must compensate FinancialPosting,
	//    DigitalDelivery, MembershipSubscription, BundleStock, AND release the checkout claim so a subsequent retry succeeds!
	rollbackCustID := newUUID()
	failSaveStore := &failingSaveCheckoutStore{Store: mem, failSave: true}
	failSaveSvc := NewService(failSaveStore, sink, func() time.Time { return now })
	_ = svc1.RecordVerifiedPaymentIntent(ctx, &VerifiedPaymentIntent{
		WorkspaceID:     wsID,
		PaymentIntentID: "pi_r02_save_fail",
		Amount:          mustDecimal(t, "300000.000000"),
		Currency:        "VND",
		Status:          PaymentStatusSucceeded,
	})
	_, err = failSaveSvc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: rollbackCustID,
		IdempotencyKey:   "r02-save-fail-idem",
		PaymentIntentID:  "pi_r02_save_fail",
		BundleID:         bundle.BundleID,
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{prodID},
		OrderAmount:      mustDecimal(t, "300000.000000"),
		Currency:         "VND",
	})
	if err == nil {
		t.Fatalf("expected Checkout to fail when SaveCheckoutResult fails")
	}
	postingsAfterSaveFail, _ := mem.ListFinancialPostings(ctx, wsID)
	rbSubs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, rollbackCustID)
	rbDelivs, _ := mem.ListDeliveriesByCustomer(ctx, wsID, rollbackCustID)
	stockAfterSaveFail, _ := mem.GetProductStock(ctx, wsID, compID)
	if len(postingsAfterSaveFail) != 2 || len(rbSubs) != 0 || len(rbDelivs) != 0 || stockAfterSaveFail != 3 {
		t.Fatalf("R02 VIOLATION: orphaned state left behind after SaveCheckoutResult failed! postings=%d (want 2) subs=%d delivs=%d stock=%d (want 3)",
			len(postingsAfterSaveFail), len(rbSubs), len(rbDelivs), stockAfterSaveFail)
	}

	// Retry after store recovers must succeed cleanly.
	failSaveStore.failSave = false
	retryRes, err := failSaveSvc.Checkout(ctx, CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: rollbackCustID,
		IdempotencyKey:   "r02-save-fail-idem",
		PaymentIntentID:  "pi_r02_save_fail",
		BundleID:         bundle.BundleID,
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{prodID},
		OrderAmount:      mustDecimal(t, "300000.000000"),
		Currency:         "VND",
	})
	if err != nil || retryRes == nil || !retryRes.Success {
		t.Fatalf("expected retry after SaveCheckoutResult failure rollback to succeed, got res=%+v err=%v", retryRes, err)
	}
	postingsAfterRetry, _ := mem.ListFinancialPostings(ctx, wsID)
	retrySubs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, rollbackCustID)
	retryDelivs, _ := mem.ListDeliveriesByCustomer(ctx, wsID, rollbackCustID)
	stockAfterRetry, _ := mem.GetProductStock(ctx, wsID, compID)
	if len(postingsAfterRetry) != 3 || len(retrySubs) != 1 || len(retryDelivs) != 1 || stockAfterRetry != 2 {
		t.Fatalf("expected clean state after retry: postings=%d (want 3) subs=%d (want 1) delivs=%d (want 1) stock=%d (want 2)",
			len(postingsAfterRetry), len(retrySubs), len(retryDelivs), stockAfterRetry)
	}

	// 5. Unsettled / unknown PaymentStatus ("requires_payment_method", "requires_action", "canceled", "unknown", "")
	//    must FAIL CLOSED with ErrPaymentNotVerified and grant 0 economic effects (both via store VerifiedPaymentIntent and custom PaymentVerifier).
	svc1.SetPaymentVerifier(nil)
	unsettledCustID := newUUID()
	for i, badStatus := range []PaymentStatus{
		"requires_payment_method",
		"requires_action",
		"canceled",
		"processing",
		"unknown",
		"",
	} {
		badPI := fmt.Sprintf("pi_r02_unsettled_%d", i)
		_ = svc1.RecordVerifiedPaymentIntent(ctx, &VerifiedPaymentIntent{
			WorkspaceID:     wsID,
			PaymentIntentID: badPI,
			Amount:          mustDecimal(t, "300000.000000"),
			Currency:        "VND",
			Status:          badStatus,
		})
		_, err := svc1.Checkout(ctx, CheckoutRequest{
			WorkspaceID:      wsID,
			CustomerEntityID: unsettledCustID,
			IdempotencyKey:   fmt.Sprintf("r02-unsettled-idem-%d", i),
			PaymentIntentID:  badPI,
			BundleID:         bundle.BundleID,
			MembershipPlanID: plan.PlanID,
			ProductIDs:       []string{prodID},
			OrderAmount:      mustDecimal(t, "300000.000000"),
			Currency:         "VND",
		})
		if !errors.Is(err, ErrPaymentNotVerified) {
			t.Fatalf("expected unsettled store PaymentStatus %q to fail closed with ErrPaymentNotVerified, got %v", badStatus, err)
		}

		// Also verify custom PaymentVerifier returning badStatus fails closed
		svc2.SetPaymentVerifier(func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
			return badStatus, nil
		})
		_, err = svc2.Checkout(ctx, CheckoutRequest{
			WorkspaceID:      wsID,
			CustomerEntityID: unsettledCustID,
			IdempotencyKey:   fmt.Sprintf("r02-unsettled-verifier-idem-%d", i),
			PaymentIntentID:  fmt.Sprintf("pi_r02_unsettled_verifier_%d", i),
			BundleID:         bundle.BundleID,
			MembershipPlanID: plan.PlanID,
			ProductIDs:       []string{prodID},
			OrderAmount:      mustDecimal(t, "300000.000000"),
			Currency:         "VND",
		})
		if !errors.Is(err, ErrPaymentNotVerified) {
			t.Fatalf("expected custom PaymentVerifier returning %q to fail closed with ErrPaymentNotVerified, got %v", badStatus, err)
		}
	}
	unsettledSubs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, unsettledCustID)
	unsettledDelivs, _ := mem.ListDeliveriesByCustomer(ctx, wsID, unsettledCustID)
	postingsAfterUnsettled, _ := mem.ListFinancialPostings(ctx, wsID)
	stockAfterUnsettled, _ := mem.GetProductStock(ctx, wsID, compID)
	if len(unsettledSubs) != 0 || len(unsettledDelivs) != 0 || len(postingsAfterUnsettled) != 3 || stockAfterUnsettled != 2 {
		t.Fatalf("R02 VIOLATION: unsettled PaymentStatus granted economic effects! subs=%d delivs=%d postings=%d stock=%d",
			len(unsettledSubs), len(unsettledDelivs), len(postingsAfterUnsettled), stockAfterUnsettled)
	}
}

func TestRemediation_M01_MemoryStoreProcessCrashTakeover(t *testing.T) {
	ctx := context.Background()
	wsID := newUUID()
	custID := newUUID()
	prodID := newUUID()
	compID := newUUID()

	now := time.Date(2026, 3, 25, 16, 0, 0, 0, time.UTC)
	currentNow := now
	clockFn := func() time.Time { return currentNow }

	mem := NewMemoryStore()
	mem.SetCheckoutLeaseTTL(5 * time.Second)
	svc := NewService(mem, &mockSink{}, clockFn)
	_ = mem.SetProductStock(ctx, wsID, compID, 10)
	_ = svc.UpsertProduct(ctx, &StoreProduct{
		ProductID:   prodID,
		WorkspaceID: wsID,
		Title:       "M01 Unit Asset",
		Price:       mustDecimal(t, "50000.000000"),
		Currency:    "VND",
		Status:      ProductStatusActive,
	})
	bundle, err := svc.CreateBundle(ctx, &Bundle{
		WorkspaceID: wsID,
		Title:       "M01 Unit Bundle",
		BundlePrice: mustDecimal(t, "100000.000000"),
		Currency:    "VND",
		Items:       []BundleItem{{ProductID: compID, Quantity: 2, ProductTitle: "Comp"}},
	})
	if err != nil {
		t.Fatalf("CreateBundle: %v", err)
	}
	plan, err := svc.CreatePlan(ctx, &MembershipPlan{
		WorkspaceID:     wsID,
		Title:           "M01 Unit Plan",
		Price:           mustDecimal(t, "150000.000000"),
		Currency:        "VND",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("CreatePlan: %v", err)
	}
	_, _ = svc.PublishPlan(ctx, wsID, plan.PlanID)
	svc.SetPaymentVerifier(func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
		return PaymentStatusSucceeded, nil
	})

	req := CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: custID,
		IdempotencyKey:   "m01-unit-idem-1",
		PaymentIntentID:  "pi_m01_unit_1",
		BundleID:         bundle.BundleID,
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{prodID},
		OrderAmount:      mustDecimal(t, "300000.000000"),
		Currency:         "VND",
	}
	fp := checkoutRequestFingerprint(req)

	// Simulate Process 1 claiming the checkout and partially applying effects, then dying before SaveCheckoutResult.
	_, orderID1, err := mem.ClaimCheckout(ctx, wsID, req.IdempotencyKey, req.PaymentIntentID, fp)
	if err != nil || orderID1 == "" {
		t.Fatalf("ClaimCheckout 1 failed: orderID=%q err=%v", orderID1, err)
	}
	orderCtx := withCheckoutOrderID(ctx, orderID1)
	if err := mem.AtomicallyReserveBundleStock(orderCtx, wsID, bundle.BundleID, 1); err != nil {
		t.Fatalf("AtomicallyReserveBundleStock 1: %v", err)
	}
	if err := mem.CreateSubscription(orderCtx, &MembershipSubscription{
		MembershipID:           newUUID(),
		WorkspaceID:            wsID,
		PlanID:                 plan.PlanID,
		CustomerEntityID:       custID,
		Status:                 MembershipSubscriptionStatusActive,
		ProviderSubscriptionID: req.PaymentIntentID,
		CurrentPeriodStart:     now,
		CurrentPeriodEnd:       now.AddDate(0, 1, 0),
	}); err != nil {
		t.Fatalf("CreateSubscription 1: %v", err)
	}

	// Advance clock past 5s lease TTL and retry via svc.Checkout.
	currentNow = now.Add(6 * time.Second)
	res, err := svc.Checkout(ctx, req)
	if err != nil {
		t.Fatalf("expected Checkout takeover after lease expiry to succeed, got %v", err)
	}
	if res == nil || !res.Success || res.OrderID != orderID1 {
		t.Fatalf("expected recovered checkout to preserve OrderID %q, got %+v", orderID1, res)
	}

	stock, _ := mem.GetProductStock(ctx, wsID, compID)
	subs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, custID)
	delivs, _ := mem.ListDeliveriesByCustomer(ctx, wsID, custID)
	postings, _ := mem.ListFinancialPostings(ctx, wsID)
	if stock != 8 || len(subs) != 1 || len(delivs) != 1 || len(postings) != 1 {
		t.Fatalf("expected reconciled single effects after takeover: stock=%d (want 8) subs=%d delivs=%d postings=%d",
			stock, len(subs), len(delivs), len(postings))
	}
}

type staleLeasePauseStore struct {
	Store
	pauseBeforeSave func()
	failSave        bool
}

func (s *staleLeasePauseStore) SaveCheckoutResult(ctx context.Context, workspaceID, idempotencyKey string, result *CheckoutResult) error {
	if s.pauseBeforeSave != nil {
		s.pauseBeforeSave()
	}
	if s.failSave {
		return errors.New("simulated downstream failure after lease expiry")
	}
	return s.Store.SaveCheckoutResult(ctx, workspaceID, idempotencyKey, result)
}

func TestRemediation_N01_StaleLeaseWorkerCannotRollbackConfirmedCheckout(t *testing.T) {
	ctx := context.Background()
	wsID := newUUID()
	custID := newUUID()
	prodID := newUUID()
	compID := newUUID()

	var clockMu sync.Mutex
	currentNow := time.Date(2026, 3, 25, 16, 0, 0, 0, time.UTC)
	clockFn := func() time.Time {
		clockMu.Lock()
		defer clockMu.Unlock()
		return currentNow
	}
	advanceClock := func(d time.Duration) {
		clockMu.Lock()
		currentNow = currentNow.Add(d)
		clockMu.Unlock()
	}

	mem := NewMemoryStore()
	mem.SetCheckoutLeaseTTL(5 * time.Second)
	mem.SetNowFunc(clockFn)
	_ = mem.SetProductStock(ctx, wsID, compID, 10)

	svcB := NewService(mem, &mockSink{}, clockFn)
	_ = svcB.UpsertProduct(ctx, &StoreProduct{
		ProductID:   prodID,
		WorkspaceID: wsID,
		Title:       "N01 Digital Asset",
		Price:       mustDecimal(t, "50000.000000"),
		Currency:    "VND",
		Status:      ProductStatusActive,
	})
	bundle, err := svcB.CreateBundle(ctx, &Bundle{
		WorkspaceID: wsID,
		Title:       "N01 Bundle",
		BundlePrice: mustDecimal(t, "100000.000000"),
		Currency:    "VND",
		Items:       []BundleItem{{ProductID: compID, Quantity: 2, ProductTitle: "Comp"}},
	})
	if err != nil {
		t.Fatalf("CreateBundle: %v", err)
	}
	plan, err := svcB.CreatePlan(ctx, &MembershipPlan{
		WorkspaceID:     wsID,
		Title:           "N01 Plan",
		Price:           mustDecimal(t, "150000.000000"),
		Currency:        "VND",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("CreatePlan: %v", err)
	}
	_, _ = svcB.PublishPlan(ctx, wsID, plan.PlanID)

	verifier := func(_ context.Context, _ string, _ string, _ tenantdb.ExactDecimal, _ string) (PaymentStatus, error) {
		return PaymentStatusSucceeded, nil
	}
	svcB.SetPaymentVerifier(verifier)

	req := CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: custID,
		IdempotencyKey:   "n01-stale-worker-idem",
		PaymentIntentID:  "pi_n01_stale_worker",
		BundleID:         bundle.BundleID,
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{prodID},
		OrderAmount:      mustDecimal(t, "300000.000000"),
		Currency:         "VND",
	}

	var workerBTakeoverRes *CheckoutResult
	var workerBTakeoverErr error
	slowStoreA := &staleLeasePauseStore{
		Store:    mem,
		failSave: true,
		pauseBeforeSave: func() {
			// Worker A has created all effects (stock, sub, delivery, posting) and now stalls past lease TTL.
			advanceClock(6 * time.Second)
			// Worker B takes over the expired lease and confirms the checkout.
			workerBTakeoverRes, workerBTakeoverErr = svcB.Checkout(ctx, req)
		},
	}
	svcA := NewService(slowStoreA, &mockSink{}, clockFn)
	svcA.SetPaymentVerifier(verifier)

	// Worker A runs Checkout, pauses before SaveCheckoutResult while Worker B takes over and confirms,
	// then Worker A fails SaveCheckoutResult and attempts rollback().
	_, errA := svcA.Checkout(ctx, req)
	if errA == nil {
		t.Fatalf("expected stale Worker A checkout to fail after lease loss")
	}
	if workerBTakeoverErr != nil || workerBTakeoverRes == nil || !workerBTakeoverRes.Success {
		t.Fatalf("expected Worker B takeover checkout to succeed, got res=%+v err=%v", workerBTakeoverRes, workerBTakeoverErr)
	}

	// Verify Worker A's stale rollback did NOT delete Worker B's confirmed checkout effects!
	stock, _ := mem.GetProductStock(ctx, wsID, compID)
	subs, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, custID)
	delivs, _ := mem.ListDeliveriesByCustomer(ctx, wsID, custID)
	postings, _ := mem.ListFinancialPostings(ctx, wsID)
	if stock != 8 || len(subs) != 1 || len(delivs) != 1 || len(postings) != 1 {
		t.Fatalf("N01 VIOLATION: stale Worker A rollback wiped confirmed checkout effects! stock=%d (want 8) subs=%d (want 1) delivs=%d (want 1) postings=%d (want 1)",
			stock, len(subs), len(delivs), len(postings))
	}

	// Sub-scenario 2: Stale Worker A wakes up after lease takeover and tries to call SaveCheckoutResult directly (failSave=false).
	// SaveCheckoutResult itself must fail with ErrCheckoutLeaseLost and rollback() must not wipe Worker B's confirmed effects.
	custID2 := newUUID()
	req2 := CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: custID2,
		IdempotencyKey:   "n01-stale-worker-idem-2",
		PaymentIntentID:  "pi_n01_stale_worker_2",
		BundleID:         bundle.BundleID,
		MembershipPlanID: plan.PlanID,
		ProductIDs:       []string{prodID},
		OrderAmount:      mustDecimal(t, "300000.000000"),
		Currency:         "VND",
	}
	var workerBRes2 *CheckoutResult
	var workerBErr2 error
	slowStoreA2 := &staleLeasePauseStore{
		Store:    mem,
		failSave: false,
		pauseBeforeSave: func() {
			advanceClock(6 * time.Second)
			workerBRes2, workerBErr2 = svcB.Checkout(ctx, req2)
		},
	}
	svcA2 := NewService(slowStoreA2, &mockSink{}, clockFn)
	svcA2.SetPaymentVerifier(verifier)
	_, errA2 := svcA2.Checkout(ctx, req2)
	if !errors.Is(errA2, ErrCheckoutLeaseLost) {
		t.Fatalf("expected stale Worker A2 SaveCheckoutResult to fail with ErrCheckoutLeaseLost, got %v", errA2)
	}
	if workerBErr2 != nil || workerBRes2 == nil || !workerBRes2.Success {
		t.Fatalf("expected Worker B2 takeover to succeed, got res=%+v err=%v", workerBRes2, workerBErr2)
	}
	stock2, _ := mem.GetProductStock(ctx, wsID, compID)
	subs2, _ := mem.ListSubscriptionsByCustomer(ctx, wsID, custID2)
	delivs2, _ := mem.ListDeliveriesByCustomer(ctx, wsID, custID2)
	postings2, _ := mem.ListFinancialPostings(ctx, wsID)
	if stock2 != 6 || len(subs2) != 1 || len(delivs2) != 1 || len(postings2) != 2 {
		t.Fatalf("N01 VIOLATION on sub-scenario 2: stock=%d (want 6) subs=%d (want 1) delivs=%d (want 1) postings=%d (want 2)",
			stock2, len(subs2), len(delivs2), len(postings2))
	}
}

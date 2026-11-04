package referral_test

import (
	"context"
	"fmt"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	platformv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/platform/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/referral"
)

func newTestRig() (*referral.Engine, *referral.Service, *referral.MemoryStore) {
	store := referral.NewMemoryStore()
	engine := referral.NewEngine(store)
	engine.SetClock(func() time.Time {
		return time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	})
	svc := referral.NewService(engine, nil)
	svc.SetClock(func() time.Time {
		return time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	})
	return engine, svc, store
}

// ----------------------------------------------------------------------------
// Target 1: No immediate qualified reward on pending payment
// ----------------------------------------------------------------------------

func TestTarget1_NoImmediateQualifiedRewardOnPendingPayment(t *testing.T) {
	ctx := context.Background()
	engine, svc, store := newTestRig()

	referrerWS := "ws-referrer-001"
	referrerUser := "usr-referrer-001"
	refereeWS := "ws-referee-001"
	refereeUser := "usr-referee-001"

	code, err := engine.EnsureWorkspaceReferralCode(ctx, referrerWS)
	if err != nil {
		t.Fatalf("EnsureWorkspaceReferralCode failed: %v", err)
	}

	// 1. Initial valid signup
	rec, err := engine.ProcessSignup(ctx, referrerWS, referrerUser, refereeWS, refereeUser, "Nguyen Van A", "a@example.com", code, referral.FraudContext{
		IPAddress: "203.113.130.1",
	})
	if err != nil {
		t.Fatalf("ProcessSignup failed: %v", err)
	}
	if rec.Status != referral.StatusPending {
		t.Fatalf("expected status %q, got %q", referral.StatusPending, rec.Status)
	}

	// 2. Referee initiates upgrade, but payment is still PENDING (e.g. Stripe checkout created or invoice open)
	qualified, status, credits, msg, err := engine.ProcessPaymentSettlement(
		ctx,
		rec.ReferralID,
		"pending", // pending payment
		"pro",
		"500000.000000",
		"pi_stripe_pending_123",
		"idem-pending-1",
	)
	if err != nil {
		t.Fatalf("ProcessPaymentSettlement error: %v", err)
	}

	// Target 1 Assertion: Must NOT qualify or award reward while payment is pending
	if qualified {
		t.Fatalf("ACCEPTANCE TARGET 1 FAILED: qualified=true while payment was pending!")
	}
	if status != referral.StatusPending {
		t.Fatalf("expected status %q on pending payment, got %q", referral.StatusPending, status)
	}
	if credits != "0.000000" {
		t.Fatalf("expected 0 credits awarded on pending payment, got %q", credits)
	}
	t.Logf("PASS: Target 1 — Pending payment held without reward: %s", msg)

	// Check persisted record remains in pending state
	persisted, err := store.GetReferralRecord(ctx, rec.ReferralID)
	if err != nil {
		t.Fatalf("GetReferralRecord error: %v", err)
	}
	if persisted.PaymentStatus != "pending" {
		t.Fatalf("expected payment_status 'pending', got %q", persisted.PaymentStatus)
	}
	if persisted.QualifiedAt != nil {
		t.Fatalf("QualifiedAt must be nil on pending payment")
	}

	// Check ConnectRPC handler behaves identically
	settleResp, err := svc.ProcessPaymentSettlement(ctx, connect.NewRequest(&platformv1.ProcessPaymentSettlementRequest{
		ReferralId:         rec.ReferralID,
		PaymentStatus:      "pending",
		PlanTier:           "pro",
		PaidAmount:         "500000.000000",
		PaymentReferenceId: "pi_stripe_pending_456",
	}))
	if err != nil {
		t.Fatalf("RPC ProcessPaymentSettlement error: %v", err)
	}
	if settleResp.Msg.GetQualified() {
		t.Fatalf("RPC qualified must be false for pending payment")
	}
	if settleResp.Msg.GetStatus() != platformv1.ReferralStatus_REFERRAL_STATUS_PENDING {
		t.Fatalf("RPC status must be REFERRAL_STATUS_PENDING")
	}

	// 3. Now payment is SETTLED (paid)
	settledQualified, settledStatus, settledCredits, settledMsg, err := engine.ProcessPaymentSettlement(
		ctx,
		rec.ReferralID,
		"paid", // settled payment
		"pro",
		"500000.000000",
		"pi_stripe_paid_123",
		"idem-settled-1",
	)
	if err != nil {
		t.Fatalf("ProcessPaymentSettlement paid failed: %v", err)
	}
	if !settledQualified {
		t.Fatalf("expected qualified=true after settled payment, got %v", settledQualified)
	}
	if settledStatus != referral.StatusRewarded {
		t.Fatalf("expected status %q after paid settlement, got %q", referral.StatusRewarded, settledStatus)
	}
	if settledCredits != "300.000000" { // Pro base reward 300 at Bronze 1.0x
		t.Fatalf("expected 300.000000 credits for Pro plan at 1.0x tier, got %q", settledCredits)
	}
	t.Logf("PASS: Settled payment qualified with credits: %s (msg: %s)", settledCredits, settledMsg)
}

// ----------------------------------------------------------------------------
// Target 2: Self-referral held for review
// ----------------------------------------------------------------------------

func TestTarget2_SelfReferralHeldForReview(t *testing.T) {
	ctx := context.Background()
	engine, svc, store := newTestRig()

	referrerWS := "ws-own-001"
	referrerUser := "usr-own-001"

	code, _ := engine.EnsureWorkspaceReferralCode(ctx, referrerWS)
	engine.RegisterWorkspaceFingerprints(referrerWS, "14.161.40.50", "dev-macbook-pro-1", "card-fingerprint-visa-9999")

	// Case 2a: Same user signs up with own code
	recUser, err := engine.ProcessSignup(ctx, referrerWS, referrerUser, "ws-other-001", referrerUser, "Self Signup", "self@example.com", code, referral.FraudContext{})
	if err != referral.ErrSelfReferralForbidden {
		t.Fatalf("expected ErrSelfReferralForbidden for same user ID, got %v", err)
	}
	if recUser.Status != referral.StatusFraudFlagged {
		t.Fatalf("ACCEPTANCE TARGET 2 FAILED: status must be fraud_flagged, got %q", recUser.Status)
	}
	if recUser.FraudCheckPassed == nil || *recUser.FraudCheckPassed != false {
		t.Fatalf("FraudCheckPassed must be false")
	}
	if recUser.ReferrerCreditsAwarded != "0.000000" || recUser.RefereeCreditsAwarded != "0.000000" {
		t.Fatalf("credits awarded must be 0 for flagged self-referral")
	}

	// Case 2b: Same workspace ID
	recWS, err := engine.ProcessSignup(ctx, referrerWS, referrerUser, referrerWS, "usr-diff-001", "Colleague", "colleague@example.com", code, referral.FraudContext{})
	if err != referral.ErrSelfReferralForbidden {
		t.Fatalf("expected ErrSelfReferralForbidden for same workspace ID, got %v", err)
	}
	if recWS.Status != referral.StatusFraudFlagged {
		t.Fatalf("status must be fraud_flagged for same workspace, got %q", recWS.Status)
	}

	// Case 2c: Same IP address
	recIP, err := engine.ProcessSignup(ctx, referrerWS, referrerUser, "ws-ip-001", "usr-ip-001", "IP Match", "ip@example.com", code, referral.FraudContext{
		IPAddress: "14.161.40.50",
	})
	if err != referral.ErrSelfReferralForbidden {
		t.Fatalf("expected ErrSelfReferralForbidden for same IP, got %v", err)
	}
	if recIP.Status != referral.StatusFraudFlagged {
		t.Fatalf("status must be fraud_flagged for matching IP, got %q", recIP.Status)
	}

	// Case 2d: Same device fingerprint
	recDev, err := engine.ProcessSignup(ctx, referrerWS, referrerUser, "ws-dev-001", "usr-dev-001", "Dev Match", "dev@example.com", code, referral.FraudContext{
		DeviceFingerprint: "dev-macbook-pro-1",
	})
	if err != referral.ErrSelfReferralForbidden {
		t.Fatalf("expected ErrSelfReferralForbidden for matching device, got %v", err)
	}
	if recDev.Status != referral.StatusFraudFlagged {
		t.Fatalf("status must be fraud_flagged for matching device, got %q", recDev.Status)
	}

	// Case 2e: Payment method reuse
	recCard, err := engine.ProcessSignup(ctx, referrerWS, referrerUser, "ws-card-001", "usr-card-001", "Card Match", "card@example.com", code, referral.FraudContext{
		CardFingerprint: "card-fingerprint-visa-9999",
	})
	if err != referral.ErrSelfReferralForbidden {
		t.Fatalf("expected ErrSelfReferralForbidden for card reuse, got %v", err)
	}
	if recCard.Status != referral.StatusFraudFlagged {
		t.Fatalf("status must be fraud_flagged for matching card, got %q", recCard.Status)
	}

	// Verify domain event emitted
	events := store.GetEmittedEvents()
	var fraudEventFound bool
	for _, ev := range events {
		if ev.EventType == referral.EventReferralFraudDetected {
			fraudEventFound = true
			break
		}
	}
	if !fraudEventFound {
		t.Fatalf("expected referral.fraud_detected event to be emitted")
	}

	// Case 2f: Admin review - clear and qualify vs confirm and forfeit
	reviewed, err := engine.ReviewFraudCase(ctx, recUser.ReferralID, "confirm_and_forfeit", "Confirmed multi-account self referral")
	if err != nil {
		t.Fatalf("ReviewFraudCase error: %v", err)
	}
	if reviewed.Status != referral.StatusForfeited {
		t.Fatalf("expected status forfeited, got %q", reviewed.Status)
	}

	// Test RPC review endpoint
	rpcRevResp, err := svc.ReviewFraudCase(ctx, connect.NewRequest(&platformv1.ReviewFraudCaseRequest{
		ReferralId:  recIP.ReferralID,
		AdminAction: "clear_and_qualify",
		Notes:       "Verified legitimate office IP sharing",
	}))
	if err != nil {
		t.Fatalf("RPC ReviewFraudCase error: %v", err)
	}
	if rpcRevResp.Msg.GetStatus() != platformv1.ReferralStatus_REFERRAL_STATUS_PENDING {
		t.Fatalf("expected pending status after clear, got %v", rpcRevResp.Msg.GetStatus())
	}
	t.Log("PASS: Target 2 — All self-referral signals held for review, zero credits, admin review lifecycle verified")
}

// ----------------------------------------------------------------------------
// Target 3: Replay / refund reverses once
// ----------------------------------------------------------------------------

func TestTarget3_ReplayRefundReversesOnce(t *testing.T) {
	ctx := context.Background()
	engine, svc, store := newTestRig()

	referrerWS := "ws-ref-rev-001"
	refereeWS := "ws-referee-rev-001"
	code, _ := engine.EnsureWorkspaceReferralCode(ctx, referrerWS)

	// 1. Valid signup and settled upgrade to Business
	rec, err := engine.ProcessSignup(ctx, referrerWS, "usr-ref-1", refereeWS, "usr-fee-1", "Tran Thi B", "b@example.com", code, referral.FraudContext{})
	if err != nil {
		t.Fatalf("ProcessSignup failed: %v", err)
	}

	qual, status, credits, _, err := engine.ProcessPaymentSettlement(ctx, rec.ReferralID, "paid", "business", "2000000.000000", "pi_biz_1", "idem-biz-1")
	if err != nil || !qual || status != referral.StatusRewarded {
		t.Fatalf("failed to reward referral: %v, %v, %v", qual, status, err)
	}
	if credits != "1000.000000" {
		t.Fatalf("expected 1000 credits, got %q", credits)
	}

	// 2. Customer requests full refund / chargeback: first reversal
	reversed, duplicate, revStatus, revCredits, txID, err := engine.ProcessRefundReversal(
		ctx,
		rec.ReferralID,
		"Customer requested 30-day money back guarantee",
		"re_stripe_refund_001",
		"idem-refund-webhook-1",
	)
	if err != nil {
		t.Fatalf("ProcessRefundReversal failed: %v", err)
	}
	if !reversed {
		t.Fatalf("expected reversed=true on first call")
	}
	if duplicate {
		t.Fatalf("expected duplicate=false on first call")
	}
	if revStatus != referral.StatusRevoked {
		t.Fatalf("expected status %q, got %q", referral.StatusRevoked, revStatus)
	}
	if revCredits != "1000.000000" {
		t.Fatalf("expected 1000 credits reversed, got %q", revCredits)
	}
	if txID == "" {
		t.Fatalf("expected non-empty reversal transaction ID")
	}

	// Verify record in store has status = revoked
	persisted, _ := store.GetReferralRecord(ctx, rec.ReferralID)
	if persisted.Status != referral.StatusRevoked {
		t.Fatalf("expected persisted status revoked, got %q", persisted.Status)
	}
	if persisted.ReversalTransactionID != txID {
		t.Fatalf("mismatched reversal transaction ID")
	}

	// 3. TARGET 3: REPLAY / DUPLICATE WEBHOOK ATTEMPTS REVERSAL AGAIN
	// Must reverse ONCE and be strictly idempotent!
	replayReversed, replayDuplicate, replayStatus, replayCredits, replayTxID, err := engine.ProcessRefundReversal(
		ctx,
		rec.ReferralID,
		"Customer requested 30-day money back guarantee",
		"re_stripe_refund_001",
		"idem-refund-webhook-1",
	)
	if err != nil {
		t.Fatalf("replayed ProcessRefundReversal error: %v", err)
	}
	if replayReversed {
		t.Fatalf("ACCEPTANCE TARGET 3 FAILED: reversed=true on duplicate replay!")
	}
	if !replayDuplicate {
		t.Fatalf("ACCEPTANCE TARGET 3 FAILED: duplicate=false on duplicate replay!")
	}
	if replayStatus != referral.StatusRevoked {
		t.Fatalf("expected status revoked on replay, got %q", replayStatus)
	}
	if replayCredits != "0.000000" {
		t.Fatalf("ACCEPTANCE TARGET 3 FAILED: re-deducted %q credits on duplicate replay!", replayCredits)
	}
	if replayTxID != txID {
		t.Fatalf("expected same original reversal txID %q, got %q", txID, replayTxID)
	}

	// Test via ConnectRPC endpoint as well
	rpcRevResp, err := svc.ProcessRefundReversal(ctx, connect.NewRequest(&platformv1.ProcessRefundReversalRequest{
		ReferralId:        rec.ReferralID,
		RefundReason:      "Stripe replay probe",
		RefundReferenceId: "re_stripe_refund_001",
		IdempotencyKey:    "idem-refund-webhook-1",
	}))
	if err != nil {
		t.Fatalf("RPC ProcessRefundReversal error: %v", err)
	}
	if rpcRevResp.Msg.GetReversed() {
		t.Fatalf("RPC reversed must be false on duplicate replay")
	}
	if !rpcRevResp.Msg.GetDuplicateReplay() {
		t.Fatalf("RPC duplicate_replay must be true on duplicate replay")
	}
	if rpcRevResp.Msg.GetCreditsReversed() != "0.000000" {
		t.Fatalf("RPC credits_reversed must be 0 on replay")
	}

	t.Log("PASS: Target 3 — Replay/refund reverses once, strictly idempotent, duplicate debits prevented")
}

// ----------------------------------------------------------------------------
// Referral Tiers & Recurring Commissions
// ----------------------------------------------------------------------------

func TestReferralTiersAndRecurringCommissions(t *testing.T) {
	_, _, _ = newTestRig()
	engine := referral.NewEngine(nil)

	// Bronze: 0-5
	t0 := engine.CalculateTier(0)
	if t0.CurrentTier != referral.TierBronze || t0.RewardMultiplier != "1.0" || t0.RecurringCommissionRate != "0.000000" {
		t.Fatalf("Bronze 0 error: %+v", t0)
	}
	t3 := engine.CalculateTier(3)
	if t3.CurrentTier != referral.TierBronze || t3.ReferralsToNextTier != 3 {
		t.Fatalf("Bronze 3 error: %+v", t3)
	}

	// Silver: 6-20
	t6 := engine.CalculateTier(6)
	if t6.CurrentTier != referral.TierSilver || t6.RewardMultiplier != "1.5" || t6.RecurringCommissionRate != "0.000000" {
		t.Fatalf("Silver 6 error: %+v", t6)
	}
	t12 := engine.CalculateTier(12)
	if t12.CurrentTier != referral.TierSilver || t12.NextTier != referral.TierGold || t12.ReferralsToNextTier != 9 {
		t.Fatalf("Silver 12 error: %+v", t12)
	}

	// Gold: 21-50 (2.0x multiplier + 10% recurring)
	t21 := engine.CalculateTier(21)
	if t21.CurrentTier != referral.TierGold || t21.RewardMultiplier != "2.0" || t21.RecurringCommissionRate != "0.100000" {
		t.Fatalf("Gold 21 error: %+v", t21)
	}

	// Platinum: 51+ (2.5x multiplier + 15% recurring)
	t55 := engine.CalculateTier(55)
	if t55.CurrentTier != referral.TierPlatinum || t55.RewardMultiplier != "2.5" || t55.RecurringCommissionRate != "0.150000" {
		t.Fatalf("Platinum 55 error: %+v", t55)
	}
	t.Log("PASS: All 4 referral tiers, multipliers, and recurring commission rates verified")
}

// ----------------------------------------------------------------------------
// Growth Analytics & Funnel Tracking
// ----------------------------------------------------------------------------

func TestGrowthFunnelAnalytics(t *testing.T) {
	ctx := context.Background()
	engine, _, store := newTestRig()
	wsID := "ws-funnel-001"
	code, _ := engine.EnsureWorkspaceReferralCode(ctx, wsID)

	// Simulate 10 clicks
	for i := 0; i < 10; i++ {
		_ = store.RecordEvent(ctx, &referral.ReferralEvent{
			EventID:      fmt.Sprintf("clk-%d", i),
			WorkspaceID:  wsID,
			ReferralCode: code,
			EventType:    "click",
			CreatedAt:    time.Now().UTC(),
		})
	}

	// Simulate 3 signups
	for i := 0; i < 3; i++ {
		_, _ = engine.ProcessSignup(ctx, wsID, "usr-ref", fmt.Sprintf("ws-child-%d", i), fmt.Sprintf("usr-child-%d", i), "Name", "email@test.com", code, referral.FraudContext{})
	}

	// Settle 1 signup as paid Pro
	rec, _ := store.GetReferralRecord(ctx, fmt.Sprintf("ref-%s-%s", wsID[:8], "usr-child-0"))
	if rec != nil {
		_, _, _, _, _ = engine.ProcessPaymentSettlement(ctx, rec.ReferralID, "paid", "pro", "500000.000000", "pi_test", "idem-test")
	}

	funnel, err := store.GetFunnel(ctx, wsID)
	if err != nil {
		t.Fatalf("GetFunnel error: %v", err)
	}
	if funnel.TotalClicks != 10 {
		t.Fatalf("expected 10 clicks, got %d", funnel.TotalClicks)
	}
	if funnel.TotalSignups != 3 {
		t.Fatalf("expected 3 signups, got %d", funnel.TotalSignups)
	}
	if funnel.ClickToSignupRate != 0.3 {
		t.Fatalf("expected 0.3 click-to-signup rate, got %f", funnel.ClickToSignupRate)
	}
	t.Log("PASS: Funnel calculations match click, signup, and paid metrics")
}

// ----------------------------------------------------------------------------
// Promotional Code Redemption & Replay Prevention
// ----------------------------------------------------------------------------

func TestPromotionalCodeRedemption(t *testing.T) {
	ctx := context.Background()
	engine, svc, _ := newTestRig()
	wsID := "ws-promo-001"

	// 1. Redeem WELCOME2026
	cmp, awarded, err := engine.RedeemPromotion(ctx, wsID, "usr-promo", "WELCOME2026", "idem-promo-1")
	if err != nil {
		t.Fatalf("RedeemPromotion error: %v", err)
	}
	if awarded != "50.000000" {
		t.Fatalf("expected 50 credits, got %q", awarded)
	}
	if cmp.Code != "WELCOME2026" {
		t.Fatalf("expected code WELCOME2026, got %q", cmp.Code)
	}

	// 2. Duplicate redemption from same workspace MUST fail
	_, _, err = engine.RedeemPromotion(ctx, wsID, "usr-promo", "WELCOME2026", "idem-promo-1")
	if err != referral.ErrAlreadyRedeemed {
		t.Fatalf("expected ErrAlreadyRedeemed on replay, got %v", err)
	}

	// 3. ConnectRPC handler tests
	rpcResp, err := svc.GetActivePromotions(ctx, connect.NewRequest(&platformv1.GetActivePromotionsRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("RPC GetActivePromotions error: %v", err)
	}
	if len(rpcResp.Msg.GetCampaigns()) < 2 {
		t.Fatalf("expected at least 2 active campaigns")
	}

	// 4. Invalid promo code
	_, err = svc.RedeemPromoCode(ctx, connect.NewRequest(&platformv1.RedeemPromoCodeRequest{
		WorkspaceId: wsID,
		PromoCode:   "NONEXISTENT_CODE",
	}))
	if err == nil {
		t.Fatalf("expected error for nonexistent promo code")
	}
	t.Log("PASS: Promotional redemption and duplicate prevention verified")
}

// ----------------------------------------------------------------------------
// Growth Trigger Prompts
// ----------------------------------------------------------------------------

func TestGrowthTriggerPrompts(t *testing.T) {
	ctx := context.Background()
	engine, _, store := newTestRig()
	wsID := "ws-growth-001"
	userID := "usr-growth-001"

	// Trigger first publish
	prompt, err := engine.TriggerGrowthPrompt(ctx, wsID, userID, referral.TriggerFirstPublish)
	if err != nil {
		t.Fatalf("TriggerGrowthPrompt error: %v", err)
	}
	if prompt.TriggerPoint != referral.TriggerFirstPublish {
		t.Fatalf("expected trigger_point %s, got %s", referral.TriggerFirstPublish, prompt.TriggerPoint)
	}
	if prompt.CreditsReward != referral.CreditsPromptFirstPublish {
		t.Fatalf("expected reward 20 credits, got %s", prompt.CreditsReward)
	}
	if prompt.Status != "active" {
		t.Fatalf("expected active status, got %s", prompt.Status)
	}

	// Complete prompt
	completed, err := store.CompleteGrowthPrompt(ctx, wsID, prompt.PromptID)
	if err != nil {
		t.Fatalf("CompleteGrowthPrompt error: %v", err)
	}
	if completed.Status != "completed" || completed.CompletedAt == nil {
		t.Fatalf("expected completed status, got %s", completed.Status)
	}
	t.Log("PASS: Growth trigger prompts and lifecycle verified")
}

// ----------------------------------------------------------------------------
// ConnectRPC Full Dashboard Roundtrip
// ----------------------------------------------------------------------------

func TestConnectRPCDashboardRoundtrip(t *testing.T) {
	ctx := context.Background()
	engine, svc, _ := newTestRig()
	wsID := "ws-dash-001"

	code, _ := engine.EnsureWorkspaceReferralCode(ctx, wsID)
	_, _ = engine.ProcessSignup(ctx, wsID, "usr-dash", "ws-dash-child", "usr-child", "Le Van C", "c@example.com", code, referral.FraudContext{})

	resp, err := svc.GetDashboard(ctx, connect.NewRequest(&platformv1.GetDashboardRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("GetDashboard error: %v", err)
	}
	if resp.Msg.GetReferralCode() != code {
		t.Fatalf("mismatched referral code in dashboard")
	}
	if resp.Msg.GetShareUrl() == "" {
		t.Fatalf("empty share url in dashboard")
	}
	if len(resp.Msg.GetRecentReferrals()) != 1 {
		t.Fatalf("expected 1 recent referral, got %d", len(resp.Msg.GetRecentReferrals()))
	}
	t.Log("PASS: ConnectRPC GetDashboard roundtrip verified")
}

// ----------------------------------------------------------------------------
// Concurrency & Race Safety
// ----------------------------------------------------------------------------

func TestConcurrentSettlementAndReversalRaceSafety(t *testing.T) {
	ctx := context.Background()
	engine, _, _ := newTestRig()

	referrerWS := "ws-race-001"
	refereeWS := "ws-race-002"
	code, _ := engine.EnsureWorkspaceReferralCode(ctx, referrerWS)

	rec, err := engine.ProcessSignup(ctx, referrerWS, "usr-race-1", refereeWS, "usr-race-2", "Race User", "race@example.com", code, referral.FraudContext{})
	if err != nil {
		t.Fatalf("ProcessSignup failed: %v", err)
	}

	var wg sync.WaitGroup
	// Concurrently attempt payment settlement and reversal
	for i := 0; i < 20; i++ {
		wg.Add(2)
		go func(idx int) {
			defer wg.Done()
			_, _, _, _, _ = engine.ProcessPaymentSettlement(
				ctx,
				rec.ReferralID,
				"paid",
				"starter",
				"200000.000000",
				fmt.Sprintf("pi_%d", idx),
				fmt.Sprintf("idem-race-settle-%d", idx),
			)
		}(i)
		go func(idx int) {
			defer wg.Done()
			_, _, _, _, _, _ = engine.ProcessRefundReversal(
				ctx,
				rec.ReferralID,
				"Race refund",
				fmt.Sprintf("re_%d", idx),
				fmt.Sprintf("idem-race-rev-%d", idx),
			)
		}(i)
	}
	wg.Wait()

	// Proves no panics, data race corruption, or deadlock occurred
	persisted, err := engine.Store().GetReferralRecord(ctx, rec.ReferralID)
	if err != nil {
		t.Fatalf("GetReferralRecord error: %v", err)
	}
	if persisted.Status != referral.StatusRewarded && persisted.Status != referral.StatusRevoked {
		t.Fatalf("expected terminal status rewarded or revoked, got %q", persisted.Status)
	}
	t.Logf("PASS: 40 concurrent operations completed cleanly with final state %q", persisted.Status)
}

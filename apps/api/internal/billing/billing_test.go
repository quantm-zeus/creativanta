package billing

import (
	"context"
	"errors"
	"fmt"
	"path/filepath"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	testWorkspaceA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
	testUserOwner  = "11111111-1111-4111-8111-111111111111"
	testUserEditor = "22222222-2222-4222-8222-222222222222"
)

func loadTestRBAC(t *testing.T) *rbac.Registry {
	t.Helper()
	repoRoot := filepath.Join("..", "..", "..", "..")
	reg, err := rbac.LoadCanonicalBindings(repoRoot)
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	return reg
}

// TestConcurrentHoldsCannotOverspend verifies Acceptance Target #1:
//   - Two simultaneous 8-credit reservations against 10 available credits -> exactly one succeeds
//     and the other fails with ErrInsufficientCredits (BILLING_LIMIT_001).
//   - Remaining credits stay 10 (no debit at reserve time), reserved becomes 8, available becomes 2.
//   - Max 5 active reservations per workspace cap is enforced under concurrency.
func TestConcurrentHoldsCannotOverspend(t *testing.T) {
	now := time.Date(2026, 11, 2, 8, 0, 0, 0, time.UTC)
	store := NewMemoryStore(now)
	// Register a deterministic rate card where 1 unit = $0.060000 -> cost_ceiling_usd = 0.060000
	// quoted_credits = ceil(0.060000 / (0.015000 * 0.5000)) = ceil(0.060000 / 0.007500) = 8 credits.
	store.UpsertRateCard(ProviderRateCard{
		RateID:     "10000000-0000-4000-8000-000000000099",
		Provider:   "google",
		ModelID:    "veo-8cred",
		Version:    "rate-2026-10-30-v1",
		Currency:   "USD",
		UnitRates:  map[string]string{"clip": "0.060000"},
		SourceURL:  "https://cloud.google.com/vertex-ai/pricing",
		VerifiedAt: now,
		ValidUntil: now.Add(48 * time.Hour),
		Enabled:    true,
	})
	engine := NewEngine(store)

	// Grant exactly 10 available credits.
	exp := now.Add(30 * 24 * time.Hour)
	_, created, err := engine.GrantLot(
		testWorkspaceA,
		testUserOwner,
		SourceSubscription,
		tenantdb.MustParseExactDecimal("10"),
		&exp,
		"sub_alloc:sub_1:2026-11",
		"10 credits initial allocation",
		now,
	)
	if err != nil || !created {
		t.Fatalf("GrantLot(10) failed: created=%v, err=%v", created, err)
	}

	// Create two valid 8-credit quotes.
	q1, err := engine.CreateQuote(QuoteInput{
		WorkspaceID:         testWorkspaceA,
		OperationType:       "ai_video_gen",
		Provider:            "google",
		ModelID:             "veo-8cred",
		MaxProviderAttempts: 1,
		MeasuredUnits:       map[string]string{"clip": "1"},
	}, now)
	if err != nil || q1.QuotedCredits.String() != "8" {
		t.Fatalf("expected 8-credit quote q1, got %s, err=%v", q1.QuotedCredits.String(), err)
	}
	q2, err := engine.CreateQuote(QuoteInput{
		WorkspaceID:         testWorkspaceA,
		OperationType:       "ai_video_gen",
		Provider:            "google",
		ModelID:             "veo-8cred",
		MaxProviderAttempts: 1,
		MeasuredUnits:       map[string]string{"clip": "1"},
	}, now)
	if err != nil || q2.QuotedCredits.String() != "8" {
		t.Fatalf("expected 8-credit quote q2, got %s, err=%v", q2.QuotedCredits.String(), err)
	}

	// Launch two simultaneous 8-credit reservations against 10 available credits.
	startBarrier := make(chan struct{})
	var wg sync.WaitGroup
	var successCount int32
	var insufficientCount int32
	errs := make([]error, 2)

	quotes := []tenantdb.CreditQuoteRow{q1, q2}
	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			<-startBarrier
			_, rErr := engine.Reserve(ReserveRequest{
				WorkspaceID:      testWorkspaceA,
				UserID:           testUserOwner,
				QuoteID:          quotes[idx].QuoteID,
				IdempotencyKey:   fmt.Sprintf("concurrent-hold-%d", idx),
				RequestHash:      quotes[idx].RequestHash,
				ConfirmedCredits: tenantdb.MustParseExactDecimal("8"),
				Now:              now,
			})
			errs[idx] = rErr
			if rErr == nil {
				atomic.AddInt32(&successCount, 1)
			} else if errors.Is(rErr, ErrInsufficientCredits) {
				atomic.AddInt32(&insufficientCount, 1)
			}
		}(i)
	}
	close(startBarrier)
	wg.Wait()

	if successCount != 1 || insufficientCount != 1 {
		t.Fatalf("expected 1 success and 1 ErrInsufficientCredits, got success=%d insufficient=%d errs=%v",
			successCount, insufficientCount, errs)
	}

	bal, err := engine.GetBalance(testWorkspaceA, now)
	if err != nil {
		t.Fatalf("GetBalance failed: %v", err)
	}
	if bal.TotalRemaining.String() != "10" || bal.Reserved.String() != "8" || bal.Available.String() != "2" {
		t.Fatalf("unexpected balance after concurrent holds: remaining=%s reserved=%s available=%s (want 10, 8, 2)",
			bal.TotalRemaining.String(), bal.Reserved.String(), bal.Available.String())
	}

	// Verify max 5 active reservations per workspace cap even when plenty of credits exist.
	_, _, err = engine.GrantLot(
		testWorkspaceA,
		testUserOwner,
		SourcePurchased,
		tenantdb.MustParseExactDecimal("500"),
		nil,
		"topup:500",
		"500 purchased credits",
		now,
	)
	if err != nil {
		t.Fatalf("GrantLot(500) failed: %v", err)
	}
	// 1 active hold already exists; 4 more should succeed (total 5), and the 6th must fail with ErrMaxActiveReservations.
	for i := 2; i <= 5; i++ {
		q, err := engine.CreateQuote(QuoteInput{
			WorkspaceID:         testWorkspaceA,
			OperationType:       "ai_video_gen",
			Provider:            "google",
			ModelID:             "veo-8cred",
			MaxProviderAttempts: 1,
			MeasuredUnits:       map[string]string{"clip": "1"},
		}, now)
		if err != nil {
			t.Fatalf("CreateQuote %d failed: %v", i, err)
		}
		if _, err := engine.Reserve(ReserveRequest{
			WorkspaceID:      testWorkspaceA,
			UserID:           testUserOwner,
			QuoteID:          q.QuoteID,
			IdempotencyKey:   fmt.Sprintf("hold-slot-%d", i),
			RequestHash:      q.RequestHash,
			ConfirmedCredits: q.QuotedCredits,
			Now:              now,
		}); err != nil {
			t.Fatalf("expected hold #%d to succeed, got %v", i, err)
		}
	}
	q6, _ := engine.CreateQuote(QuoteInput{
		WorkspaceID:         testWorkspaceA,
		OperationType:       "ai_video_gen",
		Provider:            "google",
		ModelID:             "veo-8cred",
		MaxProviderAttempts: 1,
		MeasuredUnits:       map[string]string{"clip": "1"},
	}, now)
	if _, err := engine.Reserve(ReserveRequest{
		WorkspaceID:      testWorkspaceA,
		UserID:           testUserOwner,
		QuoteID:          q6.QuoteID,
		IdempotencyKey:   "hold-slot-6",
		RequestHash:      q6.RequestHash,
		ConfirmedCredits: q6.QuotedCredits,
		Now:              now,
	}); !errors.Is(err, ErrMaxActiveReservations) {
		t.Fatalf("expected 6th active reservation to fail with ErrMaxActiveReservations, got %v", err)
	}
}

// TestLateResultAndCycleBoundaryPreserveLots verifies Acceptance Target #2:
//  1. Sweeper expires only 'held' reservations past 30m TTL, never 'in_flight' or 'reconciling'.
//  2. Late provider result arriving after 'released' or 'expired' never debits customer credits;
//     output is quarantined and recorded as platform loss.
//  3. Billing cycle boundary preserves 'purchased' lots untouched, computes 20% rollover once for Pro/Business,
//     keeps 'in_flight' reservations bound to their source lot across the boundary, expires any unused
//     remainder from an expired subscription lot upon late release or partial commit rather than turning it
//     into purchased or current-cycle credit, and prevents duplicate renewal grants on replay.
func TestLateResultAndCycleBoundaryPreserveLots(t *testing.T) {
	now := time.Date(2026, 11, 1, 12, 0, 0, 0, time.UTC)
	store := NewMemoryStore(now)
	engine := NewEngine(store)

	// Configure workspace as "pro" tier (2,000 monthly credits, 20% rollover).
	_ = store.WithWorkspaceTx(testWorkspaceA, func(st *WorkspaceBillingState) error {
		st.SubscriptionTier = "pro"
		return nil
	})

	period1End := now.Add(24 * time.Hour)
	// Grant 1,000 subscription credits for Period 1 and 300 purchased credits (never expire).
	subLot1, _, err := engine.GrantLot(
		testWorkspaceA,
		testUserOwner,
		SourceSubscription,
		tenantdb.MustParseExactDecimal("1000"),
		&period1End,
		"sub_alloc:sub_pro:2026-10",
		"Period 1 subscription credits",
		now,
	)
	if err != nil {
		t.Fatalf("GrantLot subscription failed: %v", err)
	}
	_, _, err = engine.GrantLot(
		testWorkspaceA,
		testUserOwner,
		SourcePurchased,
		tenantdb.MustParseExactDecimal("300"),
		nil,
		"stripe_pack:cs_topup_300",
		"Purchased 300 credits",
		now,
	)
	if err != nil {
		t.Fatalf("GrantLot purchased failed: %v", err)
	}

	// Create two 80-credit quotes (veo-2: 15s * $0.04 = $0.60 -> 80 credits).
	qHeld, err := engine.CreateQuote(QuoteInput{
		WorkspaceID:         testWorkspaceA,
		OperationType:       "ai_video_gen",
		Provider:            "google",
		ModelID:             "veo-2",
		MaxProviderAttempts: 1,
		MeasuredUnits:       map[string]string{"video_second": "15"},
	}, now)
	if err != nil || qHeld.QuotedCredits.String() != "80" {
		t.Fatalf("CreateQuote qHeld failed: got %s, err=%v", qHeld.QuotedCredits.String(), err)
	}
	qInFlight, err := engine.CreateQuote(QuoteInput{
		WorkspaceID:         testWorkspaceA,
		OperationType:       "ai_video_gen",
		Provider:            "google",
		ModelID:             "veo-2",
		MaxProviderAttempts: 1,
		MeasuredUnits:       map[string]string{"video_second": "15"},
	}, now)
	if err != nil {
		t.Fatalf("CreateQuote qInFlight failed: %v", err)
	}

	// Reserve both (80 + 80 = 160 reserved from Period 1 subscription lot).
	resHeld, err := engine.Reserve(ReserveRequest{
		WorkspaceID:      testWorkspaceA,
		UserID:           testUserOwner,
		QuoteID:          qHeld.QuoteID,
		IdempotencyKey:   "res-unsubmitted-held",
		RequestHash:      qHeld.RequestHash,
		ConfirmedCredits: qHeld.QuotedCredits,
		Now:              now,
	})
	if err != nil {
		t.Fatalf("Reserve resHeld failed: %v", err)
	}
	resFlight, err := engine.Reserve(ReserveRequest{
		WorkspaceID:      testWorkspaceA,
		UserID:           testUserOwner,
		QuoteID:          qInFlight.QuoteID,
		IdempotencyKey:   "res-submitted-inflight",
		RequestHash:      qInFlight.RequestHash,
		ConfirmedCredits: qInFlight.QuotedCredits,
		Now:              now,
	})
	if err != nil {
		t.Fatalf("Reserve resFlight failed: %v", err)
	}

	// Transition resFlight to in_flight before 30m TTL expires.
	if _, err := engine.MarkInFlight(testWorkspaceA, resFlight.Reservation.ReservationID, "prov_req_inflight_1", now.Add(1*time.Minute)); err != nil {
		t.Fatalf("MarkInFlight failed: %v", err)
	}

	// Advance 35 minutes: sweeper must expire resHeld (unsubmitted) and MUST NOT expire resFlight (in_flight)!
	afterHoldTTL := now.Add(35 * time.Minute)
	swept, err := engine.SweepExpiredHeld(testWorkspaceA, afterHoldTTL)
	if err != nil || swept != 1 {
		t.Fatalf("expected SweepExpiredHeld to expire 1 held reservation, got swept=%d err=%v", swept, err)
	}

	// Late provider completion arrives for the expired resHeld -> MUST NOT debit customer credits!
	_, lateCommitErr := engine.Commit(CommitRequest{
		WorkspaceID:          testWorkspaceA,
		UserID:               testUserOwner,
		ReservationID:        resHeld.Reservation.ReservationID,
		ExecutedProvider:     "google",
		ExecutedModelID:      "veo-2",
		ProviderAttemptCount: 1,
		MeasuredUnits:        map[string]string{"video_second": "15"},
		ProviderRequestID:    "late_provider_req_99",
		Now:                  afterHoldTTL.Add(1 * time.Minute),
	})
	if !errors.Is(lateCommitErr, ErrLateResultAfterTerminalState) {
		t.Fatalf("expected ErrLateResultAfterTerminalState on late result after expiry, got %v", lateCommitErr)
	}

	// Verify balance before cycle boundary:
	// Period 1 subscription lot has 1000 remaining, 80 reserved (from resFlight) -> 920 unheld subscription remaining.
	// Purchased lot has 300 remaining -> total available = 920 + 300 = 1220.
	balBeforeCycle, err := engine.GetBalance(testWorkspaceA, afterHoldTTL.Add(2*time.Minute))
	if err != nil {
		t.Fatalf("GetBalance before cycle failed: %v", err)
	}
	if balBeforeCycle.SubscriptionRemaining.String() != "920" || balBeforeCycle.PurchasedRemaining.String() != "300" || balBeforeCycle.Reserved.String() != "80" {
		t.Fatalf("unexpected balance before cycle: sub=%s pur=%s res=%s",
			balBeforeCycle.SubscriptionRemaining.String(), balBeforeCycle.PurchasedRemaining.String(), balBeforeCycle.Reserved.String())
	}

	// Advance past Period 1 end (cycle boundary while resFlight is STILL in_flight!).
	cycleBoundaryTime := period1End.Add(1 * time.Minute)
	period2End := cycleBoundaryTime.Add(30 * 24 * time.Hour)
	cycleRes, err := engine.RunCycleBoundary(CycleBoundaryRequest{
		WorkspaceID:    testWorkspaceA,
		SubscriptionID: "sub_pro",
		PeriodKey:      "2026-11",
		NextPeriodEnd:  period2End,
		Now:            cycleBoundaryTime,
	})
	if err != nil {
		t.Fatalf("RunCycleBoundary failed: %v", err)
	}
	// Unheld subscription remaining on Period 1 lot was 920.
	// 20% rollover of 920 = 184 credits (within Pro's 400 cap).
	// All 920 unheld credits on Period 1 lot expire, leaving 80 reserved on Period 1 lot for resFlight!
	// Purchased 300 credits are preserved untouched!
	// New Period 2 allocation = 2000 credits.
	if cycleRes.ExpiredCreditsTotal.String() != "920" {
		t.Fatalf("expected 920 expired unheld subscription credits, got %s", cycleRes.ExpiredCreditsTotal.String())
	}
	if cycleRes.RolloverCreditsGranted.String() != "184" {
		t.Fatalf("expected 184 rollover credits (20%% of 920), got %s", cycleRes.RolloverCreditsGranted.String())
	}
	if cycleRes.NewMonthlyAllocation.String() != "2000" {
		t.Fatalf("expected 2000 new monthly allocation, got %s", cycleRes.NewMonthlyAllocation.String())
	}
	if cycleRes.PreservedPurchasedTotal.String() != "300" {
		t.Fatalf("expected 300 preserved purchased credits, got %s", cycleRes.PreservedPurchasedTotal.String())
	}
	if cycleRes.PreservedInFlightHeld.String() != "80" {
		t.Fatalf("expected 80 preserved in-flight held credits on source lot, got %s", cycleRes.PreservedInFlightHeld.String())
	}

	// Replay RunCycleBoundary with the same PeriodKey -> must be idempotent (no duplicate renewal!).
	replayCycle, err := engine.RunCycleBoundary(CycleBoundaryRequest{
		WorkspaceID:    testWorkspaceA,
		SubscriptionID: "sub_pro",
		PeriodKey:      "2026-11",
		NextPeriodEnd:  period2End,
		Now:            cycleBoundaryTime.Add(10 * time.Second),
	})
	if err != nil || !replayCycle.AlreadyProcessedPeriod {
		t.Fatalf("expected duplicate RunCycleBoundary to be a no-op with AlreadyProcessedPeriod=true, got %+v, err=%v", replayCycle, err)
	}

	// Now resFlight (which held 80 credits on the expired Period 1 subscription lot) completes after the cycle boundary
	// with actual measured duration of 9 seconds (9 * $0.04 = $0.36 -> 48 credits, leaving 32 unused credits from the expired lot).
	// Those 32 unused credits from the expired Period 1 lot MUST expire rather than inflating Period 2 or purchased credits!
	commitAfterBoundary, err := engine.Commit(CommitRequest{
		WorkspaceID:          testWorkspaceA,
		UserID:               testUserOwner,
		ReservationID:        resFlight.Reservation.ReservationID,
		ExecutedProvider:     "google",
		ExecutedModelID:      "veo-2",
		ProviderAttemptCount: 1,
		MeasuredUnits:        map[string]string{"video_second": "9"},
		ProviderRequestID:    "prov_req_inflight_1",
		Now:                  cycleBoundaryTime.Add(2 * time.Minute),
	})
	if err != nil {
		t.Fatalf("Commit of in-flight reservation after cycle boundary failed: %v", err)
	}
	if commitAfterBoundary.ActualCharge.String() != "48" {
		t.Fatalf("expected actual charge of 48 credits, got %s", commitAfterBoundary.ActualCharge.String())
	}
	if commitAfterBoundary.Transactions[0].LotID != subLot1.LotID {
		t.Fatalf("expected in-flight commit to debit original source lot %s, got %s", subLot1.LotID, commitAfterBoundary.Transactions[0].LotID)
	}

	// Verify final balance after in-flight commit:
	// - Period 1 lot: 0 remaining, 0 reserved (48 debited + 32 expired = 80 resolved)
	// - Period 2 subscription + rollover: 2000 + 184 = 2184
	// - Purchased lot: still 300 untouched!
	// - Total available: 2184 + 300 = 2484
	balAfterCommit, err := engine.GetBalance(testWorkspaceA, cycleBoundaryTime.Add(3*time.Minute))
	if err != nil {
		t.Fatalf("GetBalance after post-cycle commit failed: %v", err)
	}
	if balAfterCommit.PurchasedRemaining.String() != "300" {
		t.Fatalf("expected purchased credits to remain 300, got %s", balAfterCommit.PurchasedRemaining.String())
	}
	if balAfterCommit.SubscriptionRemaining.String() != "2184" {
		t.Fatalf("expected subscription credits to be 2184 (2000 + 184 rollover, with 0 leaked from expired Period 1 lot), got %s",
			balAfterCommit.SubscriptionRemaining.String())
	}
	if balAfterCommit.Available.String() != "2484" || balAfterCommit.Reserved.String() != "0" {
		t.Fatalf("expected available=2484 reserved=0, got available=%s reserved=%s",
			balAfterCommit.Available.String(), balAfterCommit.Reserved.String())
	}
}

// TestPaidRetryCannotExceedConfirmedQuote verifies Acceptance Target #3:
//  1. Canonical quote formula: cost_ceiling_usd = 0.600000 -> 80 credits.
//  2. Unverified, disabled, or stale (>7d) rate cards fail closed.
//  3. Bounded retry/fallback included in the quote (e.g. primary failed, fallback succeeded on attempt 2,
//     or measured units slightly higher) never charges the customer above confirmed quote (reserved_credits).
//  4. Attempting a 3rd paid retry when max_provider_attempts=2, or switching to an unquoted provider/model,
//     fails closed with ErrPaidRetryExceedsQuote (BILLING_CONFLICT_002) requiring a new quote and consent.
func TestPaidRetryCannotExceedConfirmedQuote(t *testing.T) {
	now := time.Date(2026, 11, 2, 10, 0, 0, 0, time.UTC)
	store := NewMemoryStore(now)
	engine := NewEngine(store)

	// 1. Disabled or stale (>7 days from verified_at) rate cards must fail closed.
	store.UpsertRateCard(ProviderRateCard{
		RateID:     "10000000-0000-4000-8000-000000000088",
		Provider:   "stale-prov",
		ModelID:    "stale-model",
		Version:    "v1",
		Currency:   "USD",
		UnitRates:  map[string]string{"video_second": "0.040000"},
		SourceURL:  "https://example.com/pricing",
		VerifiedAt: now.Add(-10 * 24 * time.Hour),
		ValidUntil: now.Add(24 * time.Hour), // 11 days > 7-day freshness limit
		Enabled:    true,
	})
	if _, err := engine.CreateQuote(QuoteInput{
		WorkspaceID:   testWorkspaceA,
		OperationType: "ai_video_gen",
		Provider:      "stale-prov",
		ModelID:       "stale-model",
		MeasuredUnits: map[string]string{"video_second": "10"},
	}, now); !errors.Is(err, ErrRateCardStaleOrDisabled) {
		t.Fatalf("expected stale rate card (>7d window) to fail with ErrRateCardStaleOrDisabled, got %v", err)
	}

	// 2. Grant 500 credits and create a bounded 2-attempt quote (primary kling-2.1 @ $0.03/s, fallback veo-2 @ $0.04/s, 10s).
	// Worst-case single attempt = max($0.30, $0.40) = $0.40.
	// With max_provider_attempts = 2 -> cost_ceiling_usd = $0.800000.
	// quoted_credits = ceil(0.800000 / 0.007500) = ceil(106.666...) = 107 credits.
	_, _, err := engine.GrantLot(
		testWorkspaceA,
		testUserOwner,
		SourcePurchased,
		tenantdb.MustParseExactDecimal("500"),
		nil,
		"topup:retry_test",
		"500 credits",
		now,
	)
	if err != nil {
		t.Fatalf("GrantLot failed: %v", err)
	}

	quote, err := engine.CreateQuote(QuoteInput{
		WorkspaceID:         testWorkspaceA,
		OperationType:       "ai_video_gen",
		Provider:            "kling",
		ModelID:             "kling-2.1",
		FallbackProvider:    "google",
		FallbackModelID:     "veo-2",
		MaxProviderAttempts: 2,
		MeasuredUnits:       map[string]string{"video_second": "10"},
	}, now)
	if err != nil {
		t.Fatalf("CreateQuote with bounded fallback failed: %v", err)
	}
	if quote.CostCeilingUSD.Fixed6String() != "0.800000" || quote.QuotedCredits.String() != "107" {
		t.Fatalf("expected cost_ceiling_usd=0.800000 and quoted_credits=107, got cost=%s credits=%s",
			quote.CostCeilingUSD.Fixed6String(), quote.QuotedCredits.String())
	}

	res, err := engine.Reserve(ReserveRequest{
		WorkspaceID:      testWorkspaceA,
		UserID:           testUserOwner,
		QuoteID:          quote.QuoteID,
		IdempotencyKey:   "res-bounded-retry",
		RequestHash:      quote.RequestHash,
		ConfirmedCredits: quote.QuotedCredits,
		Now:              now,
	})
	if err != nil {
		t.Fatalf("Reserve failed: %v", err)
	}
	if _, err := engine.MarkInFlight(testWorkspaceA, res.Reservation.ReservationID, "req_attempt_1", now); err != nil {
		t.Fatalf("MarkInFlight failed: %v", err)
	}

	// 3. Attempting an additional paid retry beyond max_provider_attempts (attempt 3 > 2) MUST fail closed!
	if _, err := engine.Commit(CommitRequest{
		WorkspaceID:          testWorkspaceA,
		UserID:               testUserOwner,
		ReservationID:        res.Reservation.ReservationID,
		ExecutedProvider:     "google",
		ExecutedModelID:      "veo-2",
		ProviderAttemptCount: 3, // exceeds max_provider_attempts = 2
		MeasuredUnits:        map[string]string{"video_second": "10"},
		Now:                  now.Add(1 * time.Minute),
	}); !errors.Is(err, ErrPaidRetryExceedsQuote) {
		t.Fatalf("expected attempt 3 (> max 2) to fail with ErrPaidRetryExceedsQuote, got %v", err)
	}

	// 4. Attempting an unquoted model ("openai/gpt-4o") MUST fail closed!
	if _, err := engine.Commit(CommitRequest{
		WorkspaceID:          testWorkspaceA,
		UserID:               testUserOwner,
		ReservationID:        res.Reservation.ReservationID,
		ExecutedProvider:     "openai",
		ExecutedModelID:      "gpt-4o",
		ProviderAttemptCount: 2,
		MeasuredUnits:        map[string]string{"generation_call": "1"},
		Now:                  now.Add(1 * time.Minute),
	}); !errors.Is(err, ErrPaidRetryExceedsQuote) {
		t.Fatalf("expected unquoted fallback model to fail with ErrPaidRetryExceedsQuote, got %v", err)
	}

	// 5. Committing within the bounded plan on attempt 2 (fallback google/veo-2) even if measured units were 30s
	// ($1.20 -> 160 credits raw) MUST cap the customer charge at the confirmed quote (107 credits)!
	committed, err := engine.Commit(CommitRequest{
		WorkspaceID:          testWorkspaceA,
		UserID:               testUserOwner,
		ReservationID:        res.Reservation.ReservationID,
		ExecutedProvider:     "google",
		ExecutedModelID:      "veo-2",
		ProviderAttemptCount: 2,
		MeasuredUnits:        map[string]string{"video_second": "30"},
		ProviderRequestID:    "req_attempt_2_fallback",
		Now:                  now.Add(2 * time.Minute),
	})
	if err != nil {
		t.Fatalf("Commit on bounded fallback attempt 2 failed: %v", err)
	}
	if committed.ActualCharge.String() != "107" {
		t.Fatalf("expected actual customer charge to be capped at confirmed quote 107, got %s", committed.ActualCharge.String())
	}
}

// TestLotConsumptionPriorityRefundAndBillingSandbox verifies:
//   - Lot consumption priority: promotional (earliest expiry) -> subscription -> purchased -> overage
//   - Append-only compensating refund referencing reference_transaction_id
//   - RBAC enforcement (Owner-only mutations; Member read balance/quote; Editor denied PurchaseCredits/ChangePlan)
//   - Checkout sessions never grant credits until verified Stripe webhook settles; duplicate webhooks are ignored
//   - Plan downgrade usage check and EC-M23-001 last payment method removal guard (BILLING_CONFLICT_001)
func TestLotConsumptionPriorityRefundAndBillingSandbox(t *testing.T) {
	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	store := NewMemoryStore(now)
	engine := NewEngine(store)
	svc := NewService(reg, engine, "whsec_test_secret_p0_06")
	svc.SetClock(func() time.Time { return now })

	ownerCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	})
	editorCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserEditor,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleEditor,
	})

	// 1. RBAC: Editor can call EstimateCost and GetCreditBalance, but is denied PurchaseCredits and ChangePlan.
	if _, err := svc.PurchaseCredits(editorCtx, &adminv1.PurchaseCreditsRequest{
		Context:  &commonv1.CommandContext{IdempotencyKey: "ed-1"},
		PackCode: "small",
	}); !errors.Is(err, rbac.ErrPermissionDenied) {
		t.Fatalf("expected Editor to be denied PurchaseCredits, got %v", err)
	}
	if _, err := svc.ChangePlan(editorCtx, &adminv1.ChangePlanRequest{
		Context:    &commonv1.CommandContext{IdempotencyKey: "ed-2"},
		TargetPlan: "pro",
	}); !errors.Is(err, rbac.ErrPermissionDenied) {
		t.Fatalf("expected Editor to be denied ChangePlan, got %v", err)
	}

	// 2. Owner upgrades to Business tier and adds a payment method.
	bizUpgradeResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "up-biz-1"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
		Currency:        "USD",
		Addons:          []string{"commerce_intelligence"},
	})
	if err != nil {
		t.Fatalf("Owner ChangePlan to business failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_settle_up_biz_1",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: bizUpgradeResp.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("SettleStripeWebhook for business upgrade failed: %v", err)
	}
	if _, err := svc.UpdatePaymentMethod(ownerCtx, &adminv1.UpdatePaymentMethodRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "pm-add-1"},
		StripePaymentMethodId: "pm_visa_4242",
		SetDefault:            true,
	}); err != nil {
		t.Fatalf("UpdatePaymentMethod add failed: %v", err)
	}

	// 3. EC-M23-001: Removing the ONLY payment method on an active paid plan must fail with ErrLastPaymentMethodOnPaidPlan (BILLING_CONFLICT_001).
	if _, err := svc.UpdatePaymentMethod(ownerCtx, &adminv1.UpdatePaymentMethodRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "pm-rem-1"},
		StripePaymentMethodId: "pm_visa_4242",
		Remove:                true,
	}); !errors.Is(err, ErrLastPaymentMethodOnPaidPlan) {
		t.Fatalf("expected ErrLastPaymentMethodOnPaidPlan (EC-M23-001), got %v", err)
	}

	// 4. Credit purchase creates pending checkout session WITHOUT granting credits before webhook settlement.
	purchaseResp, err := svc.PurchaseCredits(ownerCtx, &adminv1.PurchaseCreditsRequest{
		Context:  &commonv1.CommandContext{IdempotencyKey: "buy-small-1"},
		PackCode: "small",
		Currency: "USD",
	})
	if err != nil {
		t.Fatalf("PurchaseCredits failed: %v", err)
	}
	balPreWebhook, _ := svc.GetCreditBalance(editorCtx, &adminv1.GetCreditBalanceRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
	})
	if balPreWebhook.GetBalance().GetPurchasedRemaining() != "0" {
		t.Fatalf("expected 0 purchased credits before webhook settlement, got %s", balPreWebhook.GetBalance().GetPurchasedRemaining())
	}

	// Settle via verified Stripe webhook -> grants 100 purchased credits once; duplicate webhook is a no-op!
	settle1, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_stripe_1001",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: purchaseResp.GetCheckoutSessionId(),
		OccurredAt:        now,
	})
	if err != nil || settle1.Duplicate || settle1.GrantedLot == nil || settle1.GrantedLot.GrantedCredits.String() != "100" {
		t.Fatalf("SettleStripeWebhook first call failed: %+v, err=%v", settle1, err)
	}
	settleDup, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_stripe_1001",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: purchaseResp.GetCheckoutSessionId(),
		OccurredAt:        now,
	})
	if err != nil || !settleDup.Duplicate {
		t.Fatalf("expected duplicate webhook evt_stripe_1001 to be ignored with Duplicate=true, got %+v, err=%v", settleDup, err)
	}

	// 5. Grant promotional (30 credits) and subscription (40 credits) lots and verify consumption order:
	//    promotional (30) -> subscription (40) -> purchased (10 from the 100 purchased lot) for an 80-credit job!
	promoExp := now.Add(5 * 24 * time.Hour)
	subExp := now.Add(20 * 24 * time.Hour)
	_, _, _ = engine.GrantLot(testWorkspaceA, testUserOwner, SourcePromotional, tenantdb.MustParseExactDecimal("30"), &promoExp, "promo:welcome_30", "Promo 30", now)
	_, _, _ = engine.GrantLot(testWorkspaceA, testUserOwner, SourceSubscription, tenantdb.MustParseExactDecimal("40"), &subExp, "sub_alloc:biz:partial", "Sub 40", now)

	estResp, err := svc.EstimateCost(editorCtx, &adminv1.EstimateCostRequest{
		Context:             &commonv1.CommandContext{IdempotencyKey: "est-80"},
		OperationType:       "ai_video_gen",
		Provider:            "google",
		ModelId:             "veo-2",
		MaxProviderAttempts: 1,
		MeasuredUnits:       map[string]string{"video_second": "15"}, // 15 * $0.04 = $0.60 -> 80 credits
	})
	if err != nil || estResp.GetQuote().GetQuotedCredits() != "80" || !estResp.GetSufficientCredits() {
		t.Fatalf("EstimateCost failed: %+v, err=%v", estResp, err)
	}

	res80, err := engine.Reserve(ReserveRequest{
		WorkspaceID:      testWorkspaceA,
		UserID:           testUserEditor,
		QuoteID:          estResp.GetQuote().GetQuoteId().GetValue(),
		IdempotencyKey:   "res-priority-80",
		RequestHash:      estResp.GetQuote().GetRequestHash(),
		ConfirmedCredits: tenantdb.MustParseExactDecimal("80"),
		Now:              now,
	})
	if err != nil {
		t.Fatalf("Reserve 80 across 3 lots failed: %v", err)
	}
	if len(res80.Allocations) != 3 {
		t.Fatalf("expected 3 lot allocations (promo 30 + sub 40 + purchased 10), got %d", len(res80.Allocations))
	}
	if _, err := engine.MarkInFlight(testWorkspaceA, res80.Reservation.ReservationID, "prov_80", now); err != nil {
		t.Fatalf("MarkInFlight failed: %v", err)
	}
	com80, err := engine.Commit(CommitRequest{
		WorkspaceID:          testWorkspaceA,
		UserID:               testUserEditor,
		ReservationID:        res80.Reservation.ReservationID,
		ExecutedProvider:     "google",
		ExecutedModelID:      "veo-2",
		ProviderAttemptCount: 1,
		MeasuredUnits:        map[string]string{"video_second": "15"},
		Now:                  now,
	})
	if err != nil || len(com80.Transactions) != 3 {
		t.Fatalf("Commit 80 across 3 lots failed: %+v, err=%v", com80, err)
	}
	// Remaining should be: promotional=0, subscription=0, purchased=90.
	balAfter80, _ := engine.GetBalance(testWorkspaceA, now)
	if balAfter80.PromotionalRemaining.String() != "0" || balAfter80.SubscriptionRemaining.String() != "0" || balAfter80.PurchasedRemaining.String() != "90" {
		t.Fatalf("unexpected lot balances after priority consumption: promo=%s sub=%s pur=%s (want 0, 0, 90)",
			balAfter80.PromotionalRemaining.String(), balAfter80.SubscriptionRemaining.String(), balAfter80.PurchasedRemaining.String())
	}

	// 6. Refund the 10-credit purchased debit -> appends compensating positive entry referencing ReferenceTransactionID
	// and restores purchased balance to 100 without deleting the debit entry!
	purchasedDebitTx := com80.Transactions[2]
	refundTx, err := engine.RefundTransaction(testWorkspaceA, testUserOwner, purchasedDebitTx.TransactionID, "compensating refund test", now)
	if err != nil {
		t.Fatalf("RefundTransaction failed: %v", err)
	}
	if refundTx.CreditsDelta.String() != "10" || refundTx.ReferenceTransactionID != purchasedDebitTx.TransactionID {
		t.Fatalf("unexpected refundTx: %+v", refundTx)
	}
	balAfterRefund, _ := engine.GetBalance(testWorkspaceA, now)
	if balAfterRefund.PurchasedRemaining.String() != "100" {
		t.Fatalf("expected purchased balance restored to 100 after refund, got %s", balAfterRefund.PurchasedRemaining.String())
	}
}

// TestP105PaymentReplayCannotDoubleGrant verifies P1-05 Acceptance Target #3:
//   - Unsettled payment_status ("unpaid" / "requires_payment_method") is rejected and grants 0 credits.
//   - Replaying the exact same Stripe EventID for a credit pack top-up is a no-op.
//   - Replaying with a DIFFERENT Stripe EventID for the same CheckoutSessionID is a no-op (session_already_settled).
//   - Cross-event replay (checkout.session.completed followed by invoice.paid for the same checkout session) is a no-op.
//   - Subscription invoice.paid grants monthly credits once; replaying invoice.paid with the same EventID or a DIFFERENT
//     EventID for the same (subscription_id, period_key) or stripe_invoice_id is a no-op.
//   - 10 concurrent webhook replays for the same payment settle exactly once under -race.
func TestP105PaymentReplayCannotDoubleGrant(t *testing.T) {
	now := time.Date(2026, 11, 2, 14, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	store := NewMemoryStore(now)
	engine := NewEngine(store)
	svc := NewService(reg, engine, "whsec_p1_05_replay_secret")
	svc.SetClock(func() time.Time { return now })

	ownerCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	})

	// 1. Upgrade workspace to Pro (2,000 monthly credits) and create a Medium credit pack checkout session (500 credits).
	if _, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "p105-plan-pro"},
		TargetPlan:      "pro",
		BillingInterval: "monthly",
		Currency:        "USD",
	}); err != nil {
		t.Fatalf("ChangePlan failed: %v", err)
	}

	purchaseResp, err := svc.PurchaseCredits(ownerCtx, &adminv1.PurchaseCreditsRequest{
		Context:  &commonv1.CommandContext{IdempotencyKey: "p105-buy-medium"},
		PackCode: "medium",
		Currency: "USD",
	})
	if err != nil {
		t.Fatalf("PurchaseCredits failed: %v", err)
	}
	sessID := purchaseResp.GetCheckoutSessionId()

	// 2. Unsettled payment must be rejected and grant zero credits.
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_unsettled_001",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: sessID,
		PaymentStatus:     "unpaid",
		OccurredAt:        now,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected unsettled payment_status='unpaid' to fail with ErrInvalidBillingInput, got %v", err)
	}
	balAfterUnpaid, _ := engine.GetBalance(testWorkspaceA, now)
	if !balAfterUnpaid.Available.IsZero() {
		t.Fatalf("expected 0 available credits after rejected unpaid webhook, got %s", balAfterUnpaid.Available.String())
	}

	// 3. Concurrent webhook replay storm for the credit pack checkout session (some with same EventID, some with distinct EventIDs).
	startCh := make(chan struct{})
	var wg sync.WaitGroup
	var settledCount int32
	var duplicateCount int32

	for i := 0; i < 8; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			<-startCh
			evtID := "evt_pack_primary"
			evtType := "checkout.session.completed"
			if idx >= 3 && idx < 6 {
				evtID = fmt.Sprintf("evt_pack_redelivery_%d", idx)
			} else if idx >= 6 {
				evtID = fmt.Sprintf("evt_pack_invoice_paid_%d", idx)
				evtType = "invoice.paid"
			}
			res, wErr := svc.SettleStripeWebhook(StripeWebhookEvent{
				EventID:           evtID,
				EventType:         evtType,
				WorkspaceID:       testWorkspaceA,
				CheckoutSessionID: sessID,
				StripeInvoiceID:   "in_" + sessID,
				PaymentStatus:     "paid",
				OccurredAt:        now,
			})
			if wErr != nil {
				t.Errorf("SettleStripeWebhook goroutine %d failed: %v", idx, wErr)
				return
			}
			if res.Duplicate {
				atomic.AddInt32(&duplicateCount, 1)
			} else {
				atomic.AddInt32(&settledCount, 1)
			}
		}(i)
	}
	close(startCh)
	wg.Wait()

	if settledCount != 1 || duplicateCount != 7 {
		t.Fatalf("expected exactly 1 primary settlement and 7 duplicates across concurrent pack replays, got settled=%d duplicate=%d", settledCount, duplicateCount)
	}

	balAfterPack, _ := engine.GetBalance(testWorkspaceA, now)
	if balAfterPack.PurchasedRemaining.String() != "500" || balAfterPack.Available.String() != "500" {
		t.Fatalf("expected exactly 500 purchased credits after replay storm, got purchased=%s available=%s",
			balAfterPack.PurchasedRemaining.String(), balAfterPack.Available.String())
	}

	// 4. Subscription invoice.paid settlement + replays with same EventID, new EventID for same period_key,
	//    new EventID for same stripe_invoice_id, and Engine.RunCycleBoundary for the same period_key.
	subSettle1, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_sub_inv_2026_11_a",
		EventType:       "invoice.paid",
		WorkspaceID:     testWorkspaceA,
		SubscriptionID:  "90000000-0000-4000-8000-000000000001",
		PeriodKey:       "2026-11",
		StripeInvoiceID: "in_sub_pro_2026_11",
		PaymentStatus:   "paid",
		NextPeriodEnd:   now.Add(30 * 24 * time.Hour),
		OccurredAt:      now,
	})
	if err != nil || subSettle1.Duplicate || subSettle1.GrantedLot == nil || subSettle1.GrantedLot.GrantedCredits.String() != "2000" {
		t.Fatalf("expected first subscription invoice.paid to grant 2000 Pro credits, got %+v, err=%v", subSettle1, err)
	}

	// Replay with a DIFFERENT EventID for the same (subscription_id, period_key):
	subReplayDiffEvt, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_sub_inv_2026_11_b_resent",
		EventType:       "invoice.paid",
		WorkspaceID:     testWorkspaceA,
		SubscriptionID:  "90000000-0000-4000-8000-000000000001",
		PeriodKey:       "2026-11",
		StripeInvoiceID: "in_sub_pro_2026_11",
		PaymentStatus:   "paid",
		NextPeriodEnd:   now.Add(30 * 24 * time.Hour),
		OccurredAt:      now.Add(1 * time.Minute),
	})
	if err != nil || !subReplayDiffEvt.Duplicate || subReplayDiffEvt.Status != "invoice_already_settled" {
		t.Fatalf("expected subscription invoice replay with new EventID to return Duplicate=true (invoice_already_settled), got %+v, err=%v", subReplayDiffEvt, err)
	}

	// Replay via RunCycleBoundary for the same period_key:
	cycleReplay, err := engine.RunCycleBoundary(CycleBoundaryRequest{
		WorkspaceID:    testWorkspaceA,
		SubscriptionID: "90000000-0000-4000-8000-000000000001",
		PeriodKey:      "2026-11",
		NextPeriodEnd:  now.Add(30 * 24 * time.Hour),
		Now:            now.Add(2 * time.Minute),
	})
	if err != nil || !cycleReplay.AlreadyProcessedPeriod {
		t.Fatalf("expected RunCycleBoundary for already-settled period 2026-11 to report AlreadyProcessedPeriod=true, got %+v, err=%v", cycleReplay, err)
	}

	// Verify final balance is 2000 (subscription) + 500 (purchased) = 2500 credits, with exactly 2 lots, 2 transactions, and 2 invoices.
	finalBal, _ := engine.GetBalance(testWorkspaceA, now)
	if finalBal.SubscriptionRemaining.String() != "2000" || finalBal.PurchasedRemaining.String() != "500" || finalBal.Available.String() != "2500" {
		t.Fatalf("unexpected final balance after all payment replays: sub=%s pur=%s avail=%s (want 2000, 500, 2500)",
			finalBal.SubscriptionRemaining.String(), finalBal.PurchasedRemaining.String(), finalBal.Available.String())
	}

	ledgerResp, err := svc.GetCreditLedger(ownerCtx, &adminv1.GetCreditLedgerRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
	})
	if err != nil || len(ledgerResp.GetEntries()) != 2 {
		t.Fatalf("expected exactly 2 positive credit ledger transactions (1 pack + 1 sub), got %d (err=%v)", len(ledgerResp.GetEntries()), err)
	}
	summaryResp, err := svc.GetBillingSummary(ownerCtx, &adminv1.GetBillingSummaryRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
	})
	if err != nil || len(summaryResp.GetRecentInvoices()) != 2 {
		t.Fatalf("expected exactly 2 invoices (1 pack + 1 sub), got %d (err=%v)", len(summaryResp.GetRecentInvoices()), err)
	}
}

// TestP802Target1CancellationDiffersFromDunningTrialAndPause verifies P8-02 Acceptance Target #1:
//   - 14-day Pro trial (200 credits, no card required) -> converts to Free (50 credits/mo) if no payment method added; cannot start a second trial.
//   - Dunning schedule: Day 0, 1, 3, 5 retries keep full access (past_due, read_only_mode=false); Day 7–13 enters read-only grace period (blocking credit spending); Day 14 auto-downgrades workspace to Free tier (read_only_mode=false, retention_phase=active) preserving all workspace data and all purchased credits.
//   - Business+ pause: up to 90 days read-only pause, Day 83 7-day auto-resume warning, Day 90 auto-resume.
//   - Voluntary cancellation: keeps paid plan active until current_period_end (cancel_scheduled, read_only_mode=false), and after period end enters Phase 1 (0–30d read-only quarantine) -> Phase 2 (30–90d soft delete) -> Phase 3 (90d+ hard delete), proving cancellation differs from dunning.
func TestP802Target1CancellationDiffersFromDunningTrialAndPause(t *testing.T) {
	now := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	store := NewMemoryStore(now)
	engine := NewEngine(store)
	svc := NewService(reg, engine, "whsec_p8_02_test")
	svc.SetClock(func() time.Time { return now })

	ownerCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	})

	// 1. Start 14-day Pro trial without a credit card -> grants 200 promotional trial credits.
	trialResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:    &commonv1.CommandContext{IdempotencyKey: "p802-trial-start"},
		TargetPlan: "pro",
		StartTrial: true,
	})
	if err != nil {
		t.Fatalf("StartProTrial via ChangePlan failed: %v", err)
	}
	if trialResp.GetSubscription().GetStatus() != adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_TRIALING {
		t.Fatalf("expected TRIALING status, got %v", trialResp.GetSubscription().GetStatus())
	}
	balTrial, _ := engine.GetBalance(testWorkspaceA, now)
	if balTrial.PromotionalRemaining.String() != "200" {
		t.Fatalf("expected 200 trial credits, got %s", balTrial.PromotionalRemaining.String())
	}

	// Starting a second trial on the same workspace must be rejected.
	if _, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:    &commonv1.CommandContext{IdempotencyKey: "p802-trial-dup"},
		TargetPlan: "pro",
		StartTrial: true,
	}); !errors.Is(err, ErrTrialAlreadyConsumed) {
		t.Fatalf("expected ErrTrialAlreadyConsumed on second trial attempt, got %v", err)
	}

	// Expire trial at Day 14 without payment method -> converts to Free tier (50 subscription credits).
	subAfterTrialExp, err := svc.ExpireTrialWithoutPayment(testWorkspaceA, now.Add(14*24*time.Hour))
	if err != nil {
		t.Fatalf("ExpireTrialWithoutPayment failed: %v", err)
	}
	if subAfterTrialExp.GetPlan() != "free" || subAfterTrialExp.GetStatus() != adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_ACTIVE {
		t.Fatalf("expected active free plan after trial expiry without card, got plan=%s status=%v", subAfterTrialExp.GetPlan(), subAfterTrialExp.GetStatus())
	}

	// 2. Upgrade to Pro, grant 300 purchased credits, and run Dunning schedule (Day 0 -> 1 -> 3 -> 5 -> 7 -> 14).
	proUpResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "p802-upgrade-pro"},
		TargetPlan:      "pro",
		BillingInterval: "monthly",
		Currency:        "USD",
	})
	if err != nil {
		t.Fatalf("ChangePlan to pro failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_settle_p802_pro",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: proUpResp.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("SettleStripeWebhook for pro upgrade failed: %v", err)
	}
	_, _, err = engine.GrantLot(testWorkspaceA, testUserOwner, SourcePurchased, tenantdb.MustParseExactDecimal("300"), nil, "purchased:dunning_test_300", "Purchased 300 credits", now)
	if err != nil {
		t.Fatalf("GrantLot purchased failed: %v", err)
	}

	for _, retryDay := range []int32{0, 1, 3, 5} {
		subDunning, dErr := svc.AdvanceDunning(testWorkspaceA, retryDay, now.Add(time.Duration(retryDay)*24*time.Hour))
		if dErr != nil {
			t.Fatalf("AdvanceDunning day %d failed: %v", retryDay, dErr)
		}
		if subDunning.GetStatus() != adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_PAST_DUE || subDunning.GetReadOnlyMode() {
			t.Fatalf("expected past_due with read_only_mode=false on retry day %d, got status=%v read_only=%v",
				retryDay, subDunning.GetStatus(), subDunning.GetReadOnlyMode())
		}
	}

	// Day 7: enters 7-day grace period in read-only mode (credit spending blocked, purchased credits preserved).
	subDay7, err := svc.AdvanceDunning(testWorkspaceA, 7, now.Add(7*24*time.Hour))
	if err != nil {
		t.Fatalf("AdvanceDunning day 7 failed: %v", err)
	}
	if !subDay7.GetReadOnlyMode() || subDay7.GetReadOnlyReason() != "dunning_grace_period" {
		t.Fatalf("expected read_only_mode=true (dunning_grace_period) on day 7, got %+v", subDay7)
	}

	quote, err := engine.CreateQuote(QuoteInput{
		WorkspaceID:         testWorkspaceA,
		OperationType:       "ai_video_gen",
		Provider:            "google",
		ModelID:             "veo-2",
		MaxProviderAttempts: 1,
		MeasuredUnits:       map[string]string{"video_second": "5"},
	}, now)
	if err != nil {
		t.Fatalf("CreateQuote failed: %v", err)
	}
	if _, err := engine.Reserve(ReserveRequest{
		WorkspaceID:      testWorkspaceA,
		UserID:           testUserOwner,
		QuoteID:          quote.QuoteID,
		IdempotencyKey:   "res-blocked-during-dunning-grace",
		RequestHash:      quote.RequestHash,
		ConfirmedCredits: quote.QuotedCredits,
		Now:              now,
	}); !errors.Is(err, ErrWorkspaceReadOnlyOrSuspended) {
		t.Fatalf("expected Reserve during Day 7 dunning grace to fail with ErrWorkspaceReadOnlyOrSuspended, got %v", err)
	}

	// Day 14: Dunning auto-downgrades workspace to Free tier (NOT quarantined/deleted!), clears read_only_mode,
	// and preserves all 300 purchased credits so they can be spent immediately on the Free tier.
	subDay14, err := svc.AdvanceDunning(testWorkspaceA, 14, now.Add(14*24*time.Hour))
	if err != nil {
		t.Fatalf("AdvanceDunning day 14 failed: %v", err)
	}
	if subDay14.GetPlan() != "free" || subDay14.GetReadOnlyMode() || subDay14.GetRetentionPhase() != RetentionPhaseActive {
		t.Fatalf("expected Day 14 dunning to downgrade to active Free tier (read_only=false), got plan=%s read_only=%v phase=%s",
			subDay14.GetPlan(), subDay14.GetReadOnlyMode(), subDay14.GetRetentionPhase())
	}
	if subDay14.GetPreservedPurchasedCredits() != "300" {
		t.Fatalf("expected 300 preserved purchased credits after Day 14 dunning downgrade, got %s", subDay14.GetPreservedPurchasedCredits())
	}
	// Verify spending works immediately on Free tier after Day 14 dunning downgrade!
	if _, err := engine.Reserve(ReserveRequest{
		WorkspaceID:      testWorkspaceA,
		UserID:           testUserOwner,
		QuoteID:          quote.QuoteID,
		IdempotencyKey:   "res-allowed-after-dunning-day14-free",
		RequestHash:      quote.RequestHash,
		ConfirmedCredits: quote.QuotedCredits,
		Now:              now,
	}); err != nil {
		t.Fatalf("expected Reserve to succeed on Free tier after Day 14 dunning downgrade, got %v", err)
	}

	// 3. Upgrade to Business tier, test 90-day Pause (Day 83 warning, Day 90 auto-resume) and 30% retention offer.
	bizUpResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "p802-upgrade-biz"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
		Currency:        "USD",
	})
	if err != nil {
		t.Fatalf("ChangePlan to business failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_settle_p802_biz",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: bizUpResp.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("SettleStripeWebhook for business upgrade failed: %v", err)
	}

	// Apply 30% retention discount for 3 months (1st time succeeds, 2nd time rejected).
	retOfferResp, err := svc.CancelSubscription(ownerCtx, &adminv1.CancelSubscriptionRequest{
		Context:              &commonv1.CommandContext{IdempotencyKey: "p802-ret-offer-1"},
		AcceptRetentionOffer: true,
	})
	if err != nil || !retOfferResp.GetRetentionOfferApplied() || retOfferResp.GetSubscription().GetAmount().GetAmount() != "140" {
		t.Fatalf("expected 30%% retention offer to reduce $200 Business plan to $140, got %+v (err=%v)", retOfferResp, err)
	}
	if _, err := svc.CancelSubscription(ownerCtx, &adminv1.CancelSubscriptionRequest{
		Context:              &commonv1.CommandContext{IdempotencyKey: "p802-ret-offer-2"},
		AcceptRetentionOffer: true,
	}); !errors.Is(err, ErrRetentionOfferAlreadyUsed) {
		t.Fatalf("expected second retention offer to fail with ErrRetentionOfferAlreadyUsed, got %v", err)
	}

	// Pause Business subscription for 90 days -> read_only_mode=true, Day 83 notification, Day 90 auto-resume.
	pauseResp, err := svc.CancelSubscription(ownerCtx, &adminv1.CancelSubscriptionRequest{
		Context:      &commonv1.CommandContext{IdempotencyKey: "p802-pause-90d"},
		PauseInstead: true,
		PauseDays:    90,
	})
	if err != nil || pauseResp.GetSubscription().GetStatus() != adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_PAUSED || !pauseResp.GetSubscription().GetReadOnlyMode() {
		t.Fatalf("expected paused Business subscription in read-only mode, got %+v (err=%v)", pauseResp, err)
	}
	if _, err := svc.CheckPauseLifecycle(testWorkspaceA, 83, now.Add(83*24*time.Hour)); err != nil {
		t.Fatalf("CheckPauseLifecycle day 83 failed: %v", err)
	}
	resumedSub, err := svc.CheckPauseLifecycle(testWorkspaceA, 90, now.Add(90*24*time.Hour))
	if err != nil || resumedSub.GetStatus() != adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_ACTIVE || resumedSub.GetReadOnlyMode() {
		t.Fatalf("expected Day 90 auto-resume to restore ACTIVE status and read_only_mode=false, got %+v (err=%v)", resumedSub, err)
	}

	// 4. Voluntary Cancellation differs from Dunning:
	//    - At cancel request: remains active until current_period_end (cancel_scheduled, read_only_mode=false).
	//    - After period end: Day 0–29 = phase_1_read_only_quarantine; Day 30–89 = phase_2_soft_delete; Day 90+ = phase_3_hard_deleted.
	cancelResp, err := svc.CancelSubscription(ownerCtx, &adminv1.CancelSubscriptionRequest{
		Context:            &commonv1.CommandContext{IdempotencyKey: "p802-voluntary-cancel"},
		CancellationReason: "seasonal_break",
	})
	if err != nil {
		t.Fatalf("CancelSubscription failed: %v", err)
	}
	if !cancelResp.GetSubscription().GetCancelAtPeriodEnd() || cancelResp.GetSubscription().GetReadOnlyMode() || cancelResp.GetRetentionPhase() != "cancel_scheduled" {
		t.Fatalf("expected voluntary cancellation to stay active (read_only=false, phase=cancel_scheduled) until period end, got %+v", cancelResp)
	}

	evPhase1, err := svc.AdvanceCancellationRetention(testWorkspaceA, testUserOwner, 5, now.Add(35*24*time.Hour))
	if err != nil || evPhase1.RetentionPhase != RetentionPhase1Quarantine {
		t.Fatalf("expected Phase 1 quarantine at Day 5 after period end, got %+v (err=%v)", evPhase1, err)
	}
	evPhase2, err := svc.AdvanceCancellationRetention(testWorkspaceA, testUserOwner, 45, now.Add(75*24*time.Hour))
	if err != nil || evPhase2.RetentionPhase != RetentionPhase2SoftDelete {
		t.Fatalf("expected Phase 2 soft delete at Day 45 after period end, got %+v (err=%v)", evPhase2, err)
	}
}

// TestP802Target2PurchasedCreditsPreservedAccessGatesAddonsAndOverage verifies P8-02 Acceptance Target #2:
//   - All 6 payment methods behind access gates: card enabled by default; momo, zalopay, vnpay, paypal, bank_transfer gated until granted.
//   - Starter+ add-ons: mid-cycle addition computes exact proration; mid-cycle removal schedules removal for next billing cycle and takes effect at RunCycleBoundary.
//   - Business+ authorized overage (BIZ-002): allows up to 110% of monthly credit allocation when payment method on file and overage terms accepted.
//   - Purchased credit lots (expires_at = NULL) are preserved across cycle boundaries, dunning, pause, cancellation quarantine, and soft-delete restoration.
func TestP802Target2PurchasedCreditsPreservedAccessGatesAddonsAndOverage(t *testing.T) {
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	store := NewMemoryStore(now)
	engine := NewEngine(store)
	svc := NewService(reg, engine, "whsec_p8_02_target2")
	svc.SetClock(func() time.Time { return now })

	ownerCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	})

	// 1. Upgrade to Starter tier and verify Starter+ add-on eligibility, mid-cycle proration, and next-cycle removal.
	starterPlan, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "p802-starter-base"},
		TargetPlan:      "starter",
		BillingInterval: "monthly",
		Currency:        "USD",
	})
	if err != nil {
		t.Fatalf("ChangePlan starter failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_settle_p802_starter_base",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: starterPlan.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("SettleStripeWebhook starter failed: %v", err)
	}
	subsStarter, _ := svc.ListSubscriptions(ownerCtx, &adminv1.ListSubscriptionsRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
	})
	if len(subsStarter.GetSubscriptions()) != 1 || subsStarter.GetSubscriptions()[0].GetPlan() != "starter" {
		t.Fatalf("expected starter plan after settlement, got %+v", subsStarter.GetSubscriptions())
	}

	// Advance clock 15 days into the 30-day cycle and add commerce_intelligence ($39/mo) -> prorated $19.5.
	midCycle := now.Add(15 * 24 * time.Hour)
	svc.SetClock(func() time.Time { return midCycle })
	addonAddResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "p802-starter-addon-add"},
		TargetPlan:      "starter",
		BillingInterval: "monthly",
		Currency:        "USD",
		Addons:          []string{"commerce_intelligence"},
	})
	if err != nil {
		t.Fatalf("ChangePlan add starter addon failed: %v", err)
	}
	if addonAddResp.GetProratedAddonCharge().GetAmount() != "19.5" {
		t.Fatalf("expected mid-cycle (15/30 days) prorated charge of 19.5 USD for $39 add-on, got %s", addonAddResp.GetProratedAddonCharge().GetAmount())
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_settle_p802_starter_addon",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: addonAddResp.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        midCycle,
	}); err != nil {
		t.Fatalf("SettleStripeWebhook starter addon failed: %v", err)
	}

	// Request add-on removal mid-cycle -> remains in active Addons until RunCycleBoundary, recorded in ScheduledAddonRemovals.
	addonRemResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "p802-starter-addon-rem"},
		TargetPlan:      "starter",
		BillingInterval: "monthly",
		Currency:        "USD",
		RemoveAddons:    []string{"commerce_intelligence"},
	})
	if err != nil {
		t.Fatalf("ChangePlan remove addon failed: %v", err)
	}
	if len(addonRemResp.GetSubscription().GetAddons()) != 1 || len(addonRemResp.GetScheduledAddonRemovals()) != 1 {
		t.Fatalf("expected add-on to stay active until period end with ScheduledAddonRemovals=[commerce_intelligence], got %+v", addonRemResp)
	}

	// 2. Payment Method Access Gates:
	//    - Adding 'card' succeeds by default.
	//    - Adding 'momo' fails with ErrPaymentMethodAccessGated until GrantPaymentMethodAccessGate("momo") is called.
	//    - Adding 'bank_transfer' on Starter fails even if gate granted because bank_transfer requires Business/Enterprise.
	if _, err := svc.UpdatePaymentMethod(ownerCtx, &adminv1.UpdatePaymentMethodRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "p802-pm-card"},
		StripePaymentMethodId: "pm_card_visa_4242",
		MethodType:            "card",
		SetDefault:            true,
	}); err != nil {
		t.Fatalf("expected default card payment method to succeed, got %v", err)
	}
	if _, err := svc.UpdatePaymentMethod(ownerCtx, &adminv1.UpdatePaymentMethodRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "p802-pm-momo-blocked"},
		StripePaymentMethodId: "pm_momo_9999",
		MethodType:            "momo",
	}); !errors.Is(err, ErrPaymentMethodAccessGated) {
		t.Fatalf("expected momo payment method to be blocked behind access gate, got %v", err)
	}
	if err := svc.GrantPaymentMethodAccessGate(testWorkspaceA, "momo"); err != nil {
		t.Fatalf("GrantPaymentMethodAccessGate momo failed: %v", err)
	}
	if _, err := svc.UpdatePaymentMethod(ownerCtx, &adminv1.UpdatePaymentMethodRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "p802-pm-momo-allowed"},
		StripePaymentMethodId: "pm_momo_9999",
		MethodType:            "momo",
	}); err != nil {
		t.Fatalf("expected momo payment method to succeed after gate grant, got %v", err)
	}
	if err := svc.GrantPaymentMethodAccessGate(testWorkspaceA, "bank_transfer"); err != nil {
		t.Fatalf("GrantPaymentMethodAccessGate bank_transfer failed: %v", err)
	}
	if _, err := svc.UpdatePaymentMethod(ownerCtx, &adminv1.UpdatePaymentMethodRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "p802-pm-bank-tier-blocked"},
		StripePaymentMethodId: "pm_bank_1111",
		MethodType:            "bank_transfer",
	}); !errors.Is(err, ErrPaymentMethodAccessGated) {
		t.Fatalf("expected bank_transfer on Starter tier to fail tier eligibility check, got %v", err)
	}

	// 3. Grant 500 purchased credits (expires_at = NULL) and run cycle boundary -> scheduled add-on removal applies,
	//    and all 500 purchased credits are preserved untouched!
	_, _, err = engine.GrantLot(testWorkspaceA, testUserOwner, SourcePurchased, tenantdb.MustParseExactDecimal("500"), nil, "purchased:pack_500", "Purchased 500", midCycle)
	if err != nil {
		t.Fatalf("GrantLot purchased 500 failed: %v", err)
	}
	cycleEnd := now.Add(30 * 24 * time.Hour)
	cycleRes, err := engine.RunCycleBoundary(CycleBoundaryRequest{
		WorkspaceID:    testWorkspaceA,
		SubscriptionID: addonRemResp.GetSubscription().GetSubscriptionId().GetValue(),
		PeriodKey:      "2026-12",
		NextPeriodEnd:  cycleEnd.Add(30 * 24 * time.Hour),
		Now:            cycleEnd,
	})
	if err != nil {
		t.Fatalf("RunCycleBoundary failed: %v", err)
	}
	if cycleRes.PreservedPurchasedTotal.String() != "500" {
		t.Fatalf("expected 500 purchased credits preserved across cycle boundary, got %s", cycleRes.PreservedPurchasedTotal.String())
	}
	subAfterCycle, _ := svc.ListSubscriptions(ownerCtx, &adminv1.ListSubscriptionsRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
	})
	if len(subAfterCycle.GetSubscriptions()[0].GetAddons()) != 0 {
		t.Fatalf("expected scheduled add-on removal to take effect at cycle boundary, got addons=%v", subAfterCycle.GetSubscriptions()[0].GetAddons())
	}

	// 4. Upgrade to Business with AcceptOverageTerms=true -> bank_transfer now allowed, and BIZ-002 overage up to 10% of 10,000 (=1,000 credits) works.
	bizOverageResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:            &commonv1.CommandContext{IdempotencyKey: "p802-biz-overage"},
		TargetPlan:         "business",
		BillingInterval:    "monthly",
		Currency:           "USD",
		AcceptOverageTerms: true,
	})
	if err != nil {
		t.Fatalf("ChangePlan to business with overage failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_settle_p802_biz_overage",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: bizOverageResp.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        cycleEnd,
	}); err != nil {
		t.Fatalf("SettleStripeWebhook business overage failed: %v", err)
	}
	if _, err := svc.UpdatePaymentMethod(ownerCtx, &adminv1.UpdatePaymentMethodRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "p802-pm-bank-allowed"},
		StripePaymentMethodId: "pm_bank_1111",
		MethodType:            "bank_transfer",
	}); err != nil {
		t.Fatalf("expected bank_transfer to succeed on Business tier with gate granted, got %v", err)
	}

	// Consume the 500 starter subscription credits + 500 purchased credits + 400 Business overage credits (total 1,400 credits).
	// Refresh verified rate cards for the new cycleEnd timestamp before quoting 1,400 credits (video_second = 262.5 -> $10.50 -> 1,400 credits).
	for _, card := range DefaultVerifiedRateCards(cycleEnd) {
		store.UpsertRateCard(card)
	}
	q1400, err := engine.CreateQuote(QuoteInput{
		WorkspaceID:         testWorkspaceA,
		OperationType:       "ai_video_gen",
		Provider:            "google",
		ModelID:             "veo-2",
		MaxProviderAttempts: 1,
		MeasuredUnits:       map[string]string{"video_second": "262.5"},
	}, cycleEnd)
	if err != nil || q1400.QuotedCredits.String() != "1400" {
		t.Fatalf("CreateQuote 1400 failed: %+v, err=%v", q1400, err)
	}
	res1400, err := engine.Reserve(ReserveRequest{
		WorkspaceID:      testWorkspaceA,
		UserID:           testUserOwner,
		QuoteID:          q1400.QuoteID,
		IdempotencyKey:   "res-overage-1400",
		RequestHash:      q1400.RequestHash,
		ConfirmedCredits: q1400.QuotedCredits,
		Now:              cycleEnd,
	})
	if err != nil {
		t.Fatalf("expected Business overage reservation of 1400 credits (500 sub + 500 purchased + 400 overage) to succeed, got %v", err)
	}
	// Release the hold so the 500 purchased credits remain intact, then test preservation through cancellation & Phase 2 restore!
	if _, err := engine.Release(testWorkspaceA, res1400.Reservation.ReservationID, "test_release_before_cancel", cycleEnd); err != nil {
		t.Fatalf("Release failed: %v", err)
	}
	if _, err := svc.AdvanceCancellationRetention(testWorkspaceA, testUserOwner, 40, cycleEnd.Add(40*24*time.Hour)); err != nil {
		t.Fatalf("AdvanceCancellationRetention Phase 2 failed: %v", err)
	}
	restoredEv, err := svc.RestoreWorkspace(ownerCtx, testWorkspaceA, "pro", "SUP-2026-9001", true)
	if err != nil {
		t.Fatalf("RestoreWorkspace from Phase 2 failed: %v", err)
	}
	if restoredEv.PreservedPurchasedCredits.String() != "500" {
		t.Fatalf("expected 500 purchased credits preserved after Phase 2 restoration, got %s", restoredEv.PreservedPurchasedCredits.String())
	}
}

// TestP802Target3RestoreExportAndEraseEvidence verifies P8-02 Acceptance Target #3:
//   - DataService/RequestExport and DataService/GetExportUrl with SHA-512 hash and 7-day URL TTL.
//   - EC-M23-002 multi-member deletion guard requiring ownership transfer or member removal first.
//   - Phase 1 self-restore and Phase 2 support+payment restore with SHA-512 audit evidence.
//   - Phase 3 hard delete & GDPR/PDPA Right to Erasure with 7y/5y/3y anonymized retention schedule and SHA-512 evidence.
func TestP802Target3RestoreExportAndEraseEvidence(t *testing.T) {
	now := time.Date(2026, 11, 4, 15, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	store := NewMemoryStore(now)
	engine := NewEngine(store)
	svc := NewService(reg, engine, "whsec_p8_02_target3")
	svc.SetClock(func() time.Time { return now })

	ownerCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	})

	_, _, err := engine.GrantLot(testWorkspaceA, testUserOwner, SourcePurchased, tenantdb.MustParseExactDecimal("250"), nil, "purchased:target3_250", "Purchased 250", now)
	if err != nil {
		t.Fatalf("GrantLot failed: %v", err)
	}

	// 1. EC-M23-002: Multi-member workspace deletion without ownership transfer must be blocked.
	if _, err := svc.InitiateWorkspaceDeletion(ownerCtx, testWorkspaceA, "Studio Alpha", "Studio Alpha", 3, false); !errors.Is(err, ErrMultiMemberDeletionRequiresTransfer) {
		t.Fatalf("expected EC-M23-002 ErrMultiMemberDeletionRequiresTransfer when activeMemberCount=3 and ownershipTransferred=false, got %v", err)
	}

	// With ownershipTransferred=true (or single member), deletion enters Phase 1 (30-day read-only quarantine) with SHA-512 evidence.
	delEv, err := svc.InitiateWorkspaceDeletion(ownerCtx, testWorkspaceA, "Studio Alpha", "Studio Alpha", 1, true)
	if err != nil {
		t.Fatalf("InitiateWorkspaceDeletion failed: %v", err)
	}
	if delEv.RetentionPhase != RetentionPhase1Quarantine || len(delEv.EvidenceHashSHA512) != 128 {
		t.Fatalf("expected Phase 1 quarantine with 128-hex SHA-512 evidence hash, got %+v", delEv)
	}

	// 2. RequestExport is allowed during Phase 1 read-only quarantine and produces a 7-day signed URL + SHA-512 hash.
	expResp, err := svc.RequestExport(ownerCtx, &adminv1.RequestExportRequest{
		Context:    &commonv1.CommandContext{IdempotencyKey: "p802-export-1"},
		ExportType: "full_workspace",
		Format:     "json_zip",
	})
	if err != nil {
		t.Fatalf("RequestExport failed: %v", err)
	}
	exportID := expResp.GetExportJob().GetExportId().GetValue()
	if len(expResp.GetExportJob().GetContentHashSha512()) != 128 || expResp.GetExportJob().GetStatus() != "completed" {
		t.Fatalf("expected completed export job with 128-hex SHA-512 hash, got %+v", expResp.GetExportJob())
	}

	// GetExportUrl within 7 days succeeds; after 7 days fails with ErrExportExpiredOrNotFound.
	urlResp, err := svc.GetExportUrl(ownerCtx, &adminv1.GetExportUrlRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
		ExportId:    &commonv1.UUID{Value: exportID},
	})
	if err != nil || urlResp.GetDownloadUrl() == "" {
		t.Fatalf("GetExportUrl within 7-day TTL failed: %+v, err=%v", urlResp, err)
	}
	svc.SetClock(func() time.Time { return now.Add(8 * 24 * time.Hour) })
	if _, err := svc.GetExportUrl(ownerCtx, &adminv1.GetExportUrlRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
		ExportId:    &commonv1.UUID{Value: exportID},
	}); !errors.Is(err, ErrExportExpiredOrNotFound) {
		t.Fatalf("expected GetExportUrl after 8 days (>7d TTL) to fail with ErrExportExpiredOrNotFound, got %v", err)
	}
	svc.SetClock(func() time.Time { return now })

	// 3. Restore from Phase 1 (self-service by Owner) -> restores active state & 250 purchased credits.
	restore1Ev, err := svc.RestoreWorkspace(ownerCtx, testWorkspaceA, "pro", "", false)
	if err != nil || restore1Ev.Action != "phase_1_restored" || restore1Ev.PreservedPurchasedCredits.String() != "250" {
		t.Fatalf("RestoreWorkspace Phase 1 failed: %+v, err=%v", restore1Ev, err)
	}

	// 4. Advance to Phase 2 (Day 45 soft delete): restore without support ticket fails; restore with ticket + payment succeeds.
	if _, err := svc.AdvanceCancellationRetention(testWorkspaceA, testUserOwner, 45, now.Add(45*24*time.Hour)); err != nil {
		t.Fatalf("AdvanceCancellationRetention Phase 2 failed: %v", err)
	}
	if _, err := svc.RestoreWorkspace(ownerCtx, testWorkspaceA, "pro", "", false); !errors.Is(err, ErrSupportTicketAndPaymentRequired) {
		t.Fatalf("expected Phase 2 restore without support ticket/payment to fail with ErrSupportTicketAndPaymentRequired, got %v", err)
	}
	restore2Ev, err := svc.RestoreWorkspace(ownerCtx, testWorkspaceA, "pro", "SUP-9912", true)
	if err != nil || restore2Ev.Action != "phase_2_restored" || len(restore2Ev.EvidenceHashSHA512) != 128 {
		t.Fatalf("RestoreWorkspace Phase 2 with ticket+payment failed: %+v, err=%v", restore2Ev, err)
	}

	// 5. Phase 3 Hard Delete (Day 90+) and GDPR Right to Erasure:
	//    Purges PII/content/AI/token data, anonymizes financial records (7y), consent (5y), DMCA/AUP (5y), audit logs (3y),
	//    blocks any subsequent restore or export with ErrWorkspacePermanentlyPurged, and emits SHA-512 evidence.
	eraseEv, err := svc.ExecuteRightToErasure(ownerCtx, testWorkspaceA)
	if err != nil {
		t.Fatalf("ExecuteRightToErasure failed: %v", err)
	}
	if eraseEv.RetentionPhase != RetentionPhase3HardDeleted ||
		eraseEv.RetentionSchedule["financial_records"] != "7_years_anonymized" ||
		eraseEv.RetentionSchedule["consent_records"] != "5_years" ||
		eraseEv.RetentionSchedule["dmca_aup_violations"] != "5_years" ||
		eraseEv.RetentionSchedule["audit_logs"] != "3_years_anonymized" ||
		len(eraseEv.PurgedCategories) != 4 ||
		len(eraseEv.EvidenceHashSHA512) != 128 {
		t.Fatalf("unexpected erase evidence: %+v", eraseEv)
	}
	if _, err := svc.RestoreWorkspace(ownerCtx, testWorkspaceA, "pro", "SUP-9999", true); !errors.Is(err, ErrWorkspacePermanentlyPurged) {
		t.Fatalf("expected RestoreWorkspace after hard delete/erasure to fail with ErrWorkspacePermanentlyPurged, got %v", err)
	}
	evidences, err := svc.GetLifecycleEvidences(testWorkspaceA)
	if err != nil || len(evidences) < 5 {
		t.Fatalf("expected at least 5 lifecycle evidence records in audit trail, got %d (err=%v)", len(evidences), err)
	}
}

func TestRemediation_F06_F21_F22_BillingLifecycleAndAccounting(t *testing.T) {
	now := time.Date(2026, 11, 6, 12, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	store := NewMemoryStore(now)
	engine := NewEngine(store)
	svc := NewService(reg, engine, "whsec_remediation_r2")
	svc.SetClock(func() time.Time { return now })

	ownerCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	})

	// =========================================================================
	// F06: Paid tier upgrade & add-ons must NOT activate before verified payment
	// =========================================================================

	// 1. Request upgrade from Free to Business -> returns pending_payment session; workspace stays Free
	abandonedResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "f06-abandoned-upgrade"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
		Currency:        "USD",
		Addons:          []string{"commerce_intelligence"},
	})
	if err != nil {
		t.Fatalf("ChangePlan returned unexpected error: %v", err)
	}
	if abandonedResp.GetEffectiveMode() != "pending_payment" {
		t.Fatalf("F06: expected EffectiveMode=pending_payment, got %q", abandonedResp.GetEffectiveMode())
	}
	if abandonedResp.GetSubscription().GetStatus() != adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_INCOMPLETE {
		t.Fatalf("F06: expected SUBSCRIPTION_STATUS_INCOMPLETE before payment, got %v", abandonedResp.GetSubscription().GetStatus())
	}
	subsList, err := svc.ListSubscriptions(ownerCtx, &adminv1.ListSubscriptionsRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
	})
	if err != nil {
		t.Fatalf("ListSubscriptions failed: %v", err)
	}
	if len(subsList.GetSubscriptions()) != 0 {
		t.Fatalf("F06: expected 0 active subscriptions before payment settlement, got %+v", subsList.GetSubscriptions())
	}

	// 2. Unsettled / declined payment_status on checkout.session.completed must fail and keep tier Free
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_f06_unpaid",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: abandonedResp.GetCheckoutSessionId(),
		PaymentStatus:     "unpaid",
		OccurredAt:        now,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("F06: expected ErrInvalidBillingInput for unpaid checkout session, got %v", err)
	}

	// 3. Expired checkout session cannot be settled later
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_f06_expired",
		EventType:         "checkout.session.expired",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: abandonedResp.GetCheckoutSessionId(),
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("checkout.session.expired webhook failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_f06_late_after_expiry",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: abandonedResp.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("F06: expected expired checkout session to reject late settlement, got %v", err)
	}

	// 4. Fresh upgrade request settled via verified paid webhook activates Business tier idempotently
	paidUpResp, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "f06-paid-upgrade"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
		Currency:        "USD",
		Addons:          []string{"commerce_intelligence"},
	})
	if err != nil {
		t.Fatalf("ChangePlan failed: %v", err)
	}
	settle1, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_f06_settled_1",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: paidUpResp.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        now,
	})
	if err != nil || settle1.Duplicate || settle1.Status != "settled_subscription_plan" {
		t.Fatalf("F06: expected first settlement to succeed, got %+v err=%v", settle1, err)
	}
	// Replay with a different EventID for the same CheckoutSessionID must be a no-op duplicate
	settleReplay, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_f06_settled_replay_2",
		EventType:         "invoice.paid",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: paidUpResp.GetCheckoutSessionId(),
		PaymentStatus:     "paid",
		OccurredAt:        now,
	})
	if err != nil || !settleReplay.Duplicate {
		t.Fatalf("F06: expected replay of settled plan session to return Duplicate=true, got %+v err=%v", settleReplay, err)
	}
	subsAfterPaid, _ := svc.ListSubscriptions(ownerCtx, &adminv1.ListSubscriptionsRequest{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceA},
	})
	if len(subsAfterPaid.GetSubscriptions()) != 1 ||
		subsAfterPaid.GetSubscriptions()[0].GetPlan() != "business" ||
		subsAfterPaid.GetSubscriptions()[0].GetStatus() != adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_ACTIVE {
		t.Fatalf("F06: expected active business subscription after verified settlement, got %+v", subsAfterPaid.GetSubscriptions())
	}

	// =========================================================================
	// F21: invoice.paid vs RunCycleBoundary arrival order must preserve 20% rollover
	// =========================================================================

	const wsInvoiceFirst = "11111111-1111-4111-8111-111111111111"
	const wsWorkerFirst = "22222222-2222-4222-8222-222222222222"
	cycleStart := now
	cycleEnd := now.Add(30 * 24 * time.Hour)
	nextCycleEnd := cycleEnd.Add(30 * 24 * time.Hour)

	setupProWorkspaceForRollover := func(ws string) string {
		wsCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
			ActorUserID: testUserOwner,
			WorkspaceID: ws,
			Role:        rbac.RoleOwner,
		})
		resp, cErr := svc.ChangePlan(wsCtx, &adminv1.ChangePlanRequest{
			Context:         &commonv1.CommandContext{IdempotencyKey: "f21-pro-" + ws[:8]},
			TargetPlan:      "pro",
			BillingInterval: "monthly",
			Currency:        "USD",
		})
		if cErr != nil {
			t.Fatalf("ChangePlan failed: %v", cErr)
		}
		// Settle initial period 2026-11 via invoice.paid (grants 2,000 Pro subscription credits expiring at cycleEnd)
		if _, wErr := svc.SettleStripeWebhook(StripeWebhookEvent{
			EventID:        "evt_init_" + ws[:8],
			EventType:      "invoice.paid",
			WorkspaceID:    ws,
			SubscriptionID: "sub_" + ws[:8],
			PeriodKey:      "2026-11",
			PaymentStatus:  "paid",
			NextPeriodEnd:  cycleEnd,
			OccurredAt:     cycleStart,
		}); wErr != nil {
			t.Fatalf("initial invoice.paid failed: %v", wErr)
		}
		_ = resp
		return "sub_" + ws[:8]
	}

	sub1 := setupProWorkspaceForRollover(wsInvoiceFirst)
	sub2 := setupProWorkspaceForRollover(wsWorkerFirst)

	// Workspace 1: invoice.paid for 2026-12 arrives FIRST, then RunCycleBoundary runs SECOND.
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_f21_inv_first",
		EventType:       "invoice.paid",
		WorkspaceID:     wsInvoiceFirst,
		SubscriptionID:  sub1,
		StripeInvoiceID: "in_f21_ws1_2026_12",
		PeriodKey:       "2026-12",
		PaymentStatus:   "paid",
		NextPeriodEnd:   nextCycleEnd,
		OccurredAt:      cycleEnd,
	}); err != nil {
		t.Fatalf("F21 ws1 invoice.paid failed: %v", err)
	}
	cbRes1, err := engine.RunCycleBoundary(CycleBoundaryRequest{
		WorkspaceID:    wsInvoiceFirst,
		SubscriptionID: sub1,
		PeriodKey:      "2026-12",
		NextPeriodEnd:  nextCycleEnd,
		Now:            cycleEnd,
	})
	if err != nil {
		t.Fatalf("F21 ws1 RunCycleBoundary failed: %v", err)
	}

	// Workspace 2: RunCycleBoundary for 2026-12 runs FIRST, then invoice.paid arrives SECOND.
	cbRes2, err := engine.RunCycleBoundary(CycleBoundaryRequest{
		WorkspaceID:    wsWorkerFirst,
		SubscriptionID: sub2,
		PeriodKey:      "2026-12",
		NextPeriodEnd:  nextCycleEnd,
		Now:            cycleEnd,
	})
	if err != nil {
		t.Fatalf("F21 ws2 RunCycleBoundary failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_f21_worker_first",
		EventType:       "invoice.paid",
		WorkspaceID:     wsWorkerFirst,
		SubscriptionID:  sub2,
		StripeInvoiceID: "in_f21_ws2_2026_12",
		PeriodKey:       "2026-12",
		PaymentStatus:   "paid",
		NextPeriodEnd:   nextCycleEnd,
		OccurredAt:      cycleEnd,
	}); err != nil {
		t.Fatalf("F21 ws2 invoice.paid failed: %v", err)
	}

	// Both workspaces had 2,000 unspent Pro credits from 2026-11 -> 20% rollover = 400 credits + 2,000 new allocation = 2,400 credits!
	bal1, _ := engine.GetBalance(wsInvoiceFirst, cycleEnd)
	bal2, _ := engine.GetBalance(wsWorkerFirst, cycleEnd)
	if bal1.Available.String() != "2400" || bal2.Available.String() != "2400" {
		t.Fatalf("F21: expected both arrival orders to yield Available=2400 (400 rollover + 2000 allocation), got invFirst=%s workerFirst=%s",
			bal1.Available.String(), bal2.Available.String())
	}
	if cbRes1.RolloverCreditsGranted.String() != "400" || cbRes2.RolloverCreditsGranted.String() != "400" {
		t.Fatalf("F21: expected RolloverCreditsGranted=400 in both orders, got cb1=%s cb2=%s",
			cbRes1.RolloverCreditsGranted.String(), cbRes2.RolloverCreditsGranted.String())
	}

	// =========================================================================
	// F22: Free credit grants on trial expiry and Day 14 dunning must record ledger transactions
	// =========================================================================

	const wsTrialFree = "33333333-3333-4333-8333-333333333333"
	trialCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: wsTrialFree,
		Role:        rbac.RoleOwner,
	})
	if _, err := svc.ChangePlan(trialCtx, &adminv1.ChangePlanRequest{
		Context:    &commonv1.CommandContext{IdempotencyKey: "f22-start-trial"},
		TargetPlan: "pro",
		StartTrial: true,
	}); err != nil {
		t.Fatalf("StartTrial failed: %v", err)
	}
	trialExpTime := now.Add(14 * 24 * time.Hour)
	if _, err := svc.ExpireTrialWithoutPayment(wsTrialFree, trialExpTime); err != nil {
		t.Fatalf("ExpireTrialWithoutPayment failed: %v", err)
	}
	balTrialFree, _ := engine.GetBalance(wsTrialFree, trialExpTime)
	if balTrialFree.Available.String() != "50" {
		t.Fatalf("F22: expected 50 available Free credits after trial expiry, got %s", balTrialFree.Available.String())
	}
	histTrial, err := svc.GetCreditLedger(trialCtx, &adminv1.GetCreditLedgerRequest{
		WorkspaceId: &commonv1.UUID{Value: wsTrialFree},
	})
	if err != nil {
		t.Fatalf("GetCreditLedger failed: %v", err)
	}
	txSumTrial := tenantdb.ZeroDecimal()
	foundTrialFreeGrantTx := false
	for _, tx := range histTrial.GetEntries() {
		d, _ := tenantdb.ParseExactDecimal(tx.GetCreditsDelta())
		txSumTrial, _ = txSumTrial.Add(d)
		if tx.GetOperationType() == "subscription_allocation" && tx.GetCreditsDelta() == "50" {
			foundTrialFreeGrantTx = true
		}
	}
	if !foundTrialFreeGrantTx {
		t.Fatalf("F22: missing positive 50-credit subscription_allocation ledger transaction on trial expiry! txs=%+v", histTrial.GetEntries())
	}
	if txSumTrial.Cmp(balTrialFree.Available) != 0 {
		t.Fatalf("F22: ledger sum (%s) does not reconcile with available lot balance (%s) after trial expiry",
			txSumTrial.String(), balTrialFree.Available.String())
	}

	// Day 14 dunning downgrade on wsInvoiceFirst -> must also record positive 50-credit subscription_allocation transaction
	dunningDay14Time := nextCycleEnd.Add(14 * 24 * time.Hour)
	if _, err := svc.AdvanceDunning(wsInvoiceFirst, 14, dunningDay14Time); err != nil {
		t.Fatalf("AdvanceDunning Day 14 failed: %v", err)
	}
	ws1Ctx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: wsInvoiceFirst,
		Role:        rbac.RoleOwner,
	})
	histDunning, err := svc.GetCreditLedger(ws1Ctx, &adminv1.GetCreditLedgerRequest{
		WorkspaceId: &commonv1.UUID{Value: wsInvoiceFirst},
	})
	if err != nil {
		t.Fatalf("GetCreditLedger after Day 14 dunning failed: %v", err)
	}
	foundDunningFreeGrantTx := false
	for _, tx := range histDunning.GetEntries() {
		if tx.GetOperationType() == "subscription_allocation" && tx.GetCreditsDelta() == "50" {
			foundDunningFreeGrantTx = true
			break
		}
	}
	if !foundDunningFreeGrantTx {
		t.Fatalf("F22: missing positive 50-credit subscription_allocation ledger transaction after Day 14 dunning downgrade! txs=%+v", histDunning.GetEntries())
	}
}

func TestRemediation_R01_UnrelatedInvoicePaidDoesNotActivatePendingPlan(t *testing.T) {
	now := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	store := NewMemoryStore(now)
	engine := NewEngine(store)
	svc := NewService(reg, engine, "whsec_test_secret_r01")
	svc.SetClock(func() time.Time { return now })
	ctx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	})

	// 1. Upgrade workspace from Free to Starter and settle initial Starter checkout session.
	starterInit, err := svc.ChangePlan(ctx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-starter-init"},
		TargetPlan:      "starter",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("ChangePlan starter failed: %v", err)
	}
	starterSessID := starterInit.GetCheckoutSessionId()
	starterSubID := starterInit.GetSubscription().GetSubscriptionId().GetValue()
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_r01_starter_init",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: starterSessID,
		SubscriptionID:    starterSubID,
		StripeInvoiceID:   "in_r01_starter_2026_11",
		PeriodKey:         "2026-11",
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("SettleStripeWebhook starter init failed: %v", err)
	}

	// 2. Initiate an upgrade to Business ($200/mo), creating a pending checkout session, then abandon checkout.
	bizPending, err := svc.ChangePlan(ctx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-biz-abandoned"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("ChangePlan business pending failed: %v", err)
	}
	bizSessID := bizPending.GetCheckoutSessionId()
	if bizSessID == "" {
		t.Fatalf("expected non-empty checkout_session_id for business upgrade")
	}

	// 3. Next cycle (2026-12): an invoice.paid webhook arrives for the active Starter subscription renewal
	// (no CheckoutSessionID for the abandoned Business checkout).
	renewalTime := now.Add(30 * 24 * time.Hour)
	settleRenewal, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_r01_starter_renewal_2026_12",
		EventType:       "invoice.paid",
		WorkspaceID:     testWorkspaceA,
		SubscriptionID:  starterSubID,
		StripeInvoiceID: "in_r01_starter_2026_12",
		PeriodKey:       "2026-12",
		PaymentStatus:   "paid",
		NextPeriodEnd:   renewalTime.Add(30 * 24 * time.Hour),
		OccurredAt:      renewalTime,
	})
	if err != nil {
		t.Fatalf("Starter renewal invoice.paid failed: %v", err)
	}
	if settleRenewal.Duplicate {
		t.Fatalf("expected Starter renewal invoice.paid not to be duplicate, got %+v", settleRenewal)
	}

	// Workspace MUST remain on Starter (not upgraded to Business by an unrelated Starter renewal invoice!).
	_ = store.WithWorkspaceTx(testWorkspaceA, func(st *WorkspaceBillingState) error {
		if st.SubscriptionTier != "starter" || st.Subscription.Plan != "starter" {
			t.Fatalf("R01 VIOLATION: unrelated Starter renewal invoice.paid activated abandoned pending plan (tier=%q, plan=%q, expected starter)",
				st.SubscriptionTier, st.Subscription.Plan)
		}
		if st.CheckoutSessions[bizSessID].Status != "pending" {
			t.Fatalf("R01 VIOLATION: abandoned Business checkout session %s should remain pending, got %s",
				bizSessID, st.CheckoutSessions[bizSessID].Status)
		}
		return nil
	})

	// 4. Replaying an already-settled invoice with a new EventID must be caught BEFORE mutating any pending plan session.
	replayOldInv, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_r01_starter_renewal_2026_12_replay",
		EventType:       "invoice.paid",
		WorkspaceID:     testWorkspaceA,
		SubscriptionID:  starterSubID,
		StripeInvoiceID: "in_r01_starter_2026_12",
		PeriodKey:       "2026-12",
		PaymentStatus:   "paid",
		OccurredAt:      renewalTime.Add(5 * time.Minute),
	})
	if err != nil || !replayOldInv.Duplicate || replayOldInv.Status != "invoice_already_settled" {
		t.Fatalf("expected replayed invoice to return Duplicate=true (invoice_already_settled), got %+v err=%v", replayOldInv, err)
	}
	_ = store.WithWorkspaceTx(testWorkspaceA, func(st *WorkspaceBillingState) error {
		if st.SubscriptionTier != "starter" || st.CheckoutSessions[bizSessID].Status != "pending" {
			t.Fatalf("replayed invoice must not activate pending Business plan: tier=%q session=%s",
				st.SubscriptionTier, st.CheckoutSessions[bizSessID].Status)
		}
		return nil
	})

	// 5. Negative tests: unknown CheckoutSessionID, unrelated SubscriptionID, mismatched AmountPaid / Currency / TargetPlan / BillingInterval must fail closed.
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_r01_unknown_session_on_inv_paid",
		EventType:         "invoice.paid",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: "cs_plan_unknown_cross_tenant",
		PaymentStatus:     "paid",
		OccurredAt:        renewalTime,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected unknown CheckoutSessionID on invoice.paid to fail with ErrInvalidBillingInput, got %v", err)
	}

	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_r01_wrong_sub_id",
		EventType:       "invoice.paid",
		WorkspaceID:     testWorkspaceA,
		SubscriptionID:  "sub_unrelated_external_999",
		StripeInvoiceID: "in_unrelated_999",
		PeriodKey:       "2027-01",
		PaymentStatus:   "paid",
		OccurredAt:      renewalTime,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected unrelated SubscriptionID on invoice.paid to fail with ErrInvalidBillingInput, got %v", err)
	}

	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_r01_wrong_amount",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: bizSessID,
		AmountPaid:        tenantdb.MustParseExactDecimal("20"), // Starter $20 instead of Business $200
		Currency:          "USD",
		PaymentStatus:     "paid",
		OccurredAt:        renewalTime,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected mismatched AmountPaid ($20 vs $200) to fail with ErrInvalidBillingInput, got %v", err)
	}

	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_r01_wrong_currency",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: bizSessID,
		AmountPaid:        tenantdb.MustParseExactDecimal("200"),
		Currency:          "EUR",
		PaymentStatus:     "paid",
		OccurredAt:        renewalTime,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected mismatched Currency (EUR vs USD) to fail with ErrInvalidBillingInput, got %v", err)
	}

	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_r01_wrong_target_plan",
		EventType:         "checkout.session.completed",
		WorkspaceID:       testWorkspaceA,
		CheckoutSessionID: bizSessID,
		TargetPlan:        "starter",
		AmountPaid:        tenantdb.MustParseExactDecimal("200"),
		Currency:          "USD",
		PaymentStatus:     "paid",
		OccurredAt:        renewalTime,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected mismatched TargetPlan (starter vs business) to fail with ErrInvalidBillingInput, got %v", err)
	}

	// 6. Multiple pending plan upgrades on a Free workspace: unbound invoice.paid must fail closed;
	//    settling one exact session via CheckoutSessionID must leave the other pending session untouched.
	const wsMultiPending = "44444444-4444-4444-8444-444444444444"
	multiCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: wsMultiPending,
		Role:        rbac.RoleOwner,
	})
	proPending, err := svc.ChangePlan(multiCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-multi-pro"},
		TargetPlan:      "pro",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("ChangePlan pro pending failed: %v", err)
	}
	bizPending2, err := svc.ChangePlan(multiCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-multi-biz"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("ChangePlan business pending failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_r01_ambiguous_multi_pending",
		EventType:       "invoice.paid",
		WorkspaceID:     wsMultiPending,
		SubscriptionID:  "sub_multi_1",
		StripeInvoiceID: "in_multi_ambiguous",
		PeriodKey:       "2026-11",
		PaymentStatus:   "paid",
		OccurredAt:      now,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected ambiguous invoice.paid with multiple pending sessions to fail with ErrInvalidBillingInput, got %v", err)
	}

	// Settle only the Pro session via its exact CheckoutSessionID; Business session must stay pending.
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_r01_settle_only_pro",
		EventType:         "checkout.session.completed",
		WorkspaceID:       wsMultiPending,
		CheckoutSessionID: proPending.GetCheckoutSessionId(),
		TargetPlan:        "pro",
		BillingInterval:   "monthly",
		AmountPaid:        tenantdb.MustParseExactDecimal("60"),
		Currency:          "USD",
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("expected exact Pro session settlement to succeed, got %v", err)
	}
	_ = store.WithWorkspaceTx(wsMultiPending, func(st *WorkspaceBillingState) error {
		if st.SubscriptionTier != "pro" || st.Subscription.Plan != "pro" {
			t.Fatalf("expected wsMultiPending to be on pro, got tier=%q plan=%q", st.SubscriptionTier, st.Subscription.Plan)
		}
		if st.CheckoutSessions[bizPending2.GetCheckoutSessionId()].Status != "pending" {
			t.Fatalf("expected unselected Business session to remain pending, got %s",
				st.CheckoutSessions[bizPending2.GetCheckoutSessionId()].Status)
		}
		return nil
	})
}

func TestR01_InvoicePaidGuardrailEdgeCases(t *testing.T) {
	now := time.Date(2026, 11, 2, 10, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	store := NewMemoryStore(now)
	engine := NewEngine(store)
	svc := NewService(reg, engine, "whsec_test_secret_r01_edge")
	svc.SetClock(func() time.Time { return now })

	// Case 1: Active Starter subscription ($20) with pending Business upgrade ($200).
	// An invoice.paid carrying StripePriceID="price_business_monthly_usd", TargetPlan="", and AmountPaid=20
	// must NOT silently renew Starter with a mismatched StripePriceID or activate Business.
	const wsActive = "55555555-5555-4555-8555-555555555551"
	activeCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: wsActive,
		Role:        rbac.RoleOwner,
	})
	starterSess, err := svc.ChangePlan(activeCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-edge-starter"},
		TargetPlan:      "starter",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("ChangePlan starter failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_edge_activate_starter",
		EventType:         "invoice.paid",
		WorkspaceID:       wsActive,
		SubscriptionID:    "sub_edge_starter",
		StripeInvoiceID:   "in_edge_starter_1",
		CheckoutSessionID: starterSess.GetCheckoutSessionId(),
		TargetPlan:        "starter",
		BillingInterval:   "monthly",
		PeriodKey:         "2026-11",
		AmountPaid:        tenantdb.MustParseExactDecimal("20"),
		Currency:          "USD",
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("activate starter failed: %v", err)
	}

	// Replaying ChangePlan with the same IdempotencyKey after settlement must NOT reset session status to "pending",
	// and replaying with a different TargetPlan must fail closed with ErrInvalidBillingInput.
	if _, err := svc.ChangePlan(activeCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-edge-starter"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected ChangePlan replay with conflicting TargetPlan to fail with ErrInvalidBillingInput, got %v", err)
	}
	if _, err := svc.ChangePlan(activeCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-edge-starter"},
		TargetPlan:      "starter",
		BillingInterval: "monthly",
	}); err != nil {
		t.Fatalf("expected ChangePlan replay with identical parameters to succeed idempotently, got %v", err)
	}
	_ = store.WithWorkspaceTx(wsActive, func(st *WorkspaceBillingState) error {
		if st.CheckoutSessions[starterSess.GetCheckoutSessionId()].Status != "settled" {
			t.Fatalf("expected settled checkout session to remain settled after idempotent replay, got %s",
				st.CheckoutSessions[starterSess.GetCheckoutSessionId()].Status)
		}
		return nil
	})

	// Create pending Business upgrade on wsActive
	if _, err := svc.ChangePlan(activeCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-edge-biz-pending"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
	}); err != nil {
		t.Fatalf("ChangePlan business failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_edge_mismatched_price_id",
		EventType:       "invoice.paid",
		WorkspaceID:     wsActive,
		SubscriptionID:  "sub_edge_starter",
		StripeInvoiceID: "in_edge_mismatched_price",
		StripePriceID:   "price_business_monthly_usd",
		PeriodKey:       "2026-12",
		AmountPaid:      tenantdb.MustParseExactDecimal("20"),
		Currency:        "USD",
		PaymentStatus:   "paid",
		OccurredAt:      now.Add(24 * time.Hour),
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected invoice.paid with business StripePriceID and starter AmountPaid ($20) to fail with ErrInvalidBillingInput, got %v", err)
	}

	// Case 2: Trialing Pro subscription (Amount=0 initially) must reject invoice.paid with wrong AmountPaid ($20),
	// and when settled after trial expiry (downgraded to free) with an abandoned pending Business session,
	// an unbound invoice.paid must NOT activate Business!
	const wsTrial = "55555555-5555-4555-8555-555555555552"
	trialCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: wsTrial,
		Role:        rbac.RoleOwner,
	})
	trialSub, err := svc.StartProTrial(trialCtx, wsTrial)
	if err != nil {
		t.Fatalf("StartProTrial failed: %v", err)
	}
	trialSubID := trialSub.GetSubscriptionId().GetValue()
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_edge_trial_underpaid",
		EventType:       "invoice.paid",
		WorkspaceID:     wsTrial,
		SubscriptionID:  trialSubID,
		StripeInvoiceID: "in_edge_trial_underpaid",
		PeriodKey:       "2026-11",
		AmountPaid:      tenantdb.MustParseExactDecimal("20"),
		Currency:        "USD",
		PaymentStatus:   "paid",
		OccurredAt:      now,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected trialing Pro subscription to reject underpaid ($20 vs $60) invoice.paid, got %v", err)
	}

	// Owner initiates a pending Business upgrade during trial, then trial expires without payment -> downgraded to free.
	if _, err := svc.ChangePlan(trialCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-edge-trial-biz"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
	}); err != nil {
		t.Fatalf("ChangePlan business on trial failed: %v", err)
	}
	if _, err := svc.ExpireTrialWithoutPayment(wsTrial, now.Add(14*24*time.Hour)); err != nil {
		t.Fatalf("ExpireTrialWithoutPayment failed: %v", err)
	}
	// Unbound invoice.paid with no CheckoutSessionID/TargetPlan/StripePriceID/AmountPaid must fail closed on downgraded free workspace.
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_edge_downgraded_free_unbound",
		EventType:       "invoice.paid",
		WorkspaceID:     wsTrial,
		SubscriptionID:  trialSubID,
		StripeInvoiceID: "in_edge_downgraded_unbound",
		PeriodKey:       "2026-11",
		PaymentStatus:   "paid",
		OccurredAt:      now,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected unbound invoice.paid on downgraded free workspace with pending Business session to fail with ErrInvalidBillingInput, got %v", err)
	}
	_ = store.WithWorkspaceTx(wsTrial, func(st *WorkspaceBillingState) error {
		if st.SubscriptionTier != "free" {
			t.Fatalf("expected downgraded workspace to remain on free tier, got %s", st.SubscriptionTier)
		}
		return nil
	})

	// Case 3: Fresh workspace with pending Pro upgrade: invoice.paid with empty SubscriptionID and empty CheckoutSessionID
	// (or with a credit-pack invoice ID) must fail closed instead of inventing "default_sub" and activating Pro.
	const wsFresh = "55555555-5555-4555-8555-555555555553"
	freshCtx := rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: wsFresh,
		Role:        rbac.RoleOwner,
	})
	if _, err := svc.ChangePlan(freshCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "r01-edge-fresh-pro"},
		TargetPlan:      "pro",
		BillingInterval: "monthly",
	}); err != nil {
		t.Fatalf("ChangePlan pro on fresh workspace failed: %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_edge_fresh_no_sub_id",
		EventType:       "invoice.paid",
		WorkspaceID:     wsFresh,
		StripeInvoiceID: "in_edge_fresh_no_sub",
		PeriodKey:       "2026-11",
		PaymentStatus:   "paid",
		OccurredAt:      now,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected invoice.paid with empty SubscriptionID and empty CheckoutSessionID to fail with ErrInvalidBillingInput, got %v", err)
	}
	if _, err := svc.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_edge_fresh_pack_invoice",
		EventType:       "invoice.paid",
		WorkspaceID:     wsFresh,
		SubscriptionID:  "sub_fresh_1",
		StripeInvoiceID: "in_cs_pack_unrelated",
		PeriodKey:       "2026-11",
		PaymentStatus:   "paid",
		OccurredAt:      now,
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected invoice.paid with credit-pack StripeInvoiceID (in_cs_pack_*) to fail with ErrInvalidBillingInput, got %v", err)
	}
}

func TestRemediation_N05_MultiInstanceMultiTenantUUIDUniqueness(t *testing.T) {
	now := time.Date(2026, 11, 9, 10, 0, 0, 0, time.UTC)
	reg := loadTestRBAC(t)
	const wsB = "00000000-0000-4000-8000-000000000002"

	storeA := NewMemoryStore(now)
	storeB := NewMemoryStore(now)
	svcA := NewService(reg, NewEngine(storeA), "whsec_n05_a")
	svcB := NewService(reg, NewEngine(storeB), "whsec_n05_b")
	svcA.SetClock(func() time.Time { return now })
	svcB.SetClock(func() time.Time { return now })

	subA, err := svcA.StartProTrial(rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: testWorkspaceA,
		Role:        rbac.RoleOwner,
	}), testWorkspaceA)
	if err != nil {
		t.Fatalf("StartProTrial A failed: %v", err)
	}
	subB, err := svcB.StartProTrial(rbac.WithPolicyContext(context.Background(), rbac.PolicyContext{
		ActorUserID: testUserOwner,
		WorkspaceID: wsB,
		Role:        rbac.RoleOwner,
	}), wsB)
	if err != nil {
		t.Fatalf("StartProTrial B failed: %v", err)
	}

	if subA.GetSubscriptionId().GetValue() == subB.GetSubscriptionId().GetValue() {
		t.Fatalf("N05 VIOLATION: cross-tenant SubscriptionID collision: %s", subA.GetSubscriptionId().GetValue())
	}

	var lotA, txA, lotB, txB string
	_ = storeA.WithWorkspaceTx(testWorkspaceA, func(st *WorkspaceBillingState) error {
		lotA = st.Lots[0].LotID
		txA = st.Transactions[0].TransactionID
		return nil
	})
	_ = storeB.WithWorkspaceTx(wsB, func(st *WorkspaceBillingState) error {
		lotB = st.Lots[0].LotID
		txB = st.Transactions[0].TransactionID
		return nil
	})
	if lotA == lotB || txA == txB {
		t.Fatalf("N05 VIOLATION: cross-instance/tenant UUID collision: lotA=%s lotB=%s txA=%s txB=%s", lotA, lotB, txA, txB)
	}
}

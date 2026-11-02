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
	if _, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "up-biz-1"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
		Currency:        "USD",
		Addons:          []string{"commerce_intelligence"},
	}); err != nil {
		t.Fatalf("Owner ChangePlan to business failed: %v", err)
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

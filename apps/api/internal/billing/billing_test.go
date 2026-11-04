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
	if _, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "p802-upgrade-pro"},
		TargetPlan:      "pro",
		BillingInterval: "monthly",
		Currency:        "USD",
	}); err != nil {
		t.Fatalf("ChangePlan to pro failed: %v", err)
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
	if _, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "p802-upgrade-biz"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
		Currency:        "USD",
	}); err != nil {
		t.Fatalf("ChangePlan to business failed: %v", err)
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
	if starterPlan.GetSubscription().GetPlan() != "starter" {
		t.Fatalf("expected starter plan, got %s", starterPlan.GetSubscription().GetPlan())
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
	if _, err := svc.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:            &commonv1.CommandContext{IdempotencyKey: "p802-biz-overage"},
		TargetPlan:         "business",
		BillingInterval:    "monthly",
		Currency:           "USD",
		AcceptOverageTerms: true,
	}); err != nil {
		t.Fatalf("ChangePlan to business with overage failed: %v", err)
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

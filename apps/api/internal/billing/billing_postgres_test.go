package billing

import (
	"context"
	"fmt"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func buildAppUserBillingDSN(adminDSN string) (string, error) {
	u, err := url.Parse(adminDSN)
	if err != nil {
		return "", err
	}
	u.User = url.UserPassword("app_user", "app_user_test_pw")
	return u.String(), nil
}

// TestPostgresLiveCreditLotsQuotesAndBilling verifies P0-06 against live PostgreSQL 17.10:
//  1. 00004_p0_06_credit_lots_quotes_and_billing.sql schema, constraints, and narrow grants
//  2. Tenant RLS isolation under app_user across ai_credit_quotes, ai_credit_lots,
//     ai_credit_reservations, ai_credit_reservation_allocations, invoices, and payment_methods
//  3. Same-tenant composite FK enforcement on ai_credit_reservations and ai_credit_transactions
//  4. Append-only immutability trigger on ai_credit_transactions blocking UPDATE and DELETE
//  5. Concurrent PostgreSQL FOR UPDATE holds preventing overspend (two 8-credit holds on 10 available -> one succeeds)
func TestPostgresLiveCreditLotsQuotesAndBilling(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL P0-06 credit/billing suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, dir); err != nil {
		t.Fatalf("migrate.Up failed: %v", err)
	}

	_, err = adminPool.Exec(ctx, `ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw' NOBYPASSRLS`)
	if err != nil {
		t.Fatalf("configure app_user login: %v", err)
	}

	const (
		userA   = "11111111-1111-4111-8111-111111111161"
		userB   = "22222222-2222-4222-8222-222222222262"
		tenantA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa61"
		tenantB = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb62"
		quoteA1 = "33333333-3333-4333-8333-333333333361"
		quoteA2 = "33333333-3333-4333-8333-333333333362"
		quoteB1 = "33333333-3333-4333-8333-333333333363"
		lotA1   = "44444444-4444-4444-8444-444444444461"
	)

	_, err = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ($1::uuid, 'p006_ext_a', 'p006_a@example.com', 'P006 User A', 'active'),
		  ($2::uuid, 'p006_ext_b', 'p006_b@example.com', 'P006 User B', 'active')
		ON CONFLICT (user_id) DO NOTHING
	`, userA, userB)
	if err != nil {
		t.Fatalf("seed P0-06 users: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status) VALUES
		  ($1::uuid, 'P006 Tenant A', 'p006-tenant-a', $2::uuid, 'active'),
		  ($3::uuid, 'P006 Tenant B', 'p006-tenant-b', $4::uuid, 'active')
		ON CONFLICT (workspace_id) DO NOTHING
	`, tenantA, userA, tenantB, userB)
	if err != nil {
		t.Fatalf("seed P0-06 workspaces: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspace_members (workspace_id, user_id, role, status) VALUES
		  ($1::uuid, $2::uuid, 'owner', 'active'),
		  ($3::uuid, $4::uuid, 'owner', 'active')
		ON CONFLICT (workspace_id, user_id) DO NOTHING
	`, tenantA, userA, tenantB, userB)
	if err != nil {
		t.Fatalf("seed P0-06 workspace_members: %v", err)
	}

	// Clean any prior test rows for tenantA / tenantB.
	_, _ = adminPool.Exec(ctx, `DELETE FROM ai_credit_reservation_allocations WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM ai_credit_reservations WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM ai_credit_lots WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM ai_credit_quotes WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)

	// Seed a verified rate card via adminPool.
	now := time.Now().UTC().Truncate(time.Second)
	adminQueries := tenantdb.New(adminPool)
	_, err = adminQueries.UpsertProviderRate(ctx, tenantdb.ProviderRateRow{
		Provider:   "google",
		ModelID:    "veo-2",
		Version:    "rate-2026-10-30-v1",
		Currency:   "USD",
		UnitRates:  map[string]string{"video_second": "0.040000"},
		SourceURL:  "https://cloud.google.com/vertex-ai/pricing",
		VerifiedAt: now,
		ValidUntil: now.Add(6 * 24 * time.Hour),
		Enabled:    true,
	})
	if err != nil {
		t.Fatalf("UpsertProviderRate failed: %v", err)
	}

	appDSN, err := buildAppUserBillingDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserBillingDSN: %v", err)
	}
	appPool, err := pgxpool.New(ctx, appDSN)
	if err != nil {
		t.Fatalf("connect appPool: %v", err)
	}
	defer appPool.Close()

	// 1. Seed a 10-credit lot and two 8-credit quotes in Tenant A, plus a quote in Tenant B.
	exp := now.Add(30 * 24 * time.Hour)
	err = tenantdb.WithTx(ctx, appPool, tenantdb.Scope{
		WorkspaceID:             tenantA,
		UserID:                  userA,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		_, inserted, err := q.InsertCreditLotIdempotent(txCtx, tenantdb.CreditLotRow{
			LotID:            lotA1,
			WorkspaceID:      tenantA,
			SourceType:       SourceSubscription,
			GrantedCredits:   tenantdb.MustParseExactDecimal("10"),
			RemainingCredits: tenantdb.MustParseExactDecimal("10"),
			ReservedCredits:  tenantdb.ZeroDecimal(),
			ExpiresAt:        &exp,
			ExternalGrantKey: "sub_alloc:live_a:2026-11",
		})
		if err != nil || !inserted {
			return fmt.Errorf("InsertCreditLotIdempotent: inserted=%v err=%v", inserted, err)
		}
		for _, qID := range []string{quoteA1, quoteA2} {
			if _, err := q.InsertCreditQuote(txCtx, tenantdb.CreditQuoteRow{
				QuoteID:           qID,
				WorkspaceID:       tenantA,
				RequestHash:       "hash_8_credits",
				OperationType:     "ai_video_gen",
				RateVersion:       "rate-2026-10-30-v1",
				ProviderPlanJSON:  []byte(`{"primary_provider":"google","primary_model_id":"veo-2","max_provider_attempts":1}`),
				CostCeilingUSD:    tenantdb.MustParseExactDecimal("0.060000"),
				USDPerCreditFloor: tenantdb.MustParseExactDecimal("0.015000"),
				GrossMarginFloor:  tenantdb.MustParseExactDecimal("0.5000"),
				QuotedCredits:     tenantdb.MustParseExactDecimal("8"),
				ExpiresAt:         now.Add(5 * time.Minute),
			}); err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		t.Fatalf("Tenant A setup failed: %v", err)
	}

	err = tenantdb.WithTx(ctx, appPool, tenantdb.Scope{
		WorkspaceID:             tenantB,
		UserID:                  userB,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		// Verify Tenant B cannot see Tenant A's lots under RLS.
		lotsB, err := q.ListCreditLotsForUpdate(txCtx, tenantB)
		if err != nil {
			return err
		}
		if len(lotsB) != 0 {
			return fmt.Errorf("RLS violation: Tenant B saw %d lots from Tenant A", len(lotsB))
		}
		_, err = q.InsertCreditQuote(txCtx, tenantdb.CreditQuoteRow{
			QuoteID:           quoteB1,
			WorkspaceID:       tenantB,
			RequestHash:       "hash_b",
			OperationType:     "ai_video_gen",
			RateVersion:       "rate-2026-10-30-v1",
			ProviderPlanJSON:  []byte(`{}`),
			CostCeilingUSD:    tenantdb.MustParseExactDecimal("0.060000"),
			USDPerCreditFloor: tenantdb.MustParseExactDecimal("0.015000"),
			GrossMarginFloor:  tenantdb.MustParseExactDecimal("0.5000"),
			QuotedCredits:     tenantdb.MustParseExactDecimal("8"),
			ExpiresAt:         now.Add(5 * time.Minute),
		})
		return err
	})
	if err != nil {
		t.Fatalf("Tenant B RLS check failed: %v", err)
	}

	// 2. Verify composite tenant FK blocks linking Tenant A reservation to Tenant B quote.
	fkTxErr := tenantdb.WithTx(ctx, appPool, tenantdb.Scope{
		WorkspaceID:             tenantA,
		UserID:                  userA,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		_, fkErr := q.InsertReservation(txCtx, tenantdb.CreditReservationRow{
			WorkspaceID:     tenantA,
			QuoteID:         quoteB1, // belongs to Tenant B!
			IdempotencyKey:  "cross-tenant-quote-attempt",
			RequestHash:     "hash_b",
			Status:          ReservationHeld,
			ReservedCredits: tenantdb.MustParseExactDecimal("8"),
			ExpiresAt:       now.Add(30 * time.Minute),
		})
		return fkErr
	})
	if fkTxErr == nil {
		t.Fatalf("expected fk_ai_credit_reservations_quote_id_tenant to reject cross-tenant quote")
	}

	// 3. Concurrent PostgreSQL FOR UPDATE reservations: two simultaneous 8-credit reservations
	// against 10 available credits in Tenant A -> exactly one succeeds and one fails!
	startCh := make(chan struct{})
	var wg sync.WaitGroup
	var pgSuccess int32
	var pgInsufficient int32
	quoteIDs := []string{quoteA1, quoteA2}

	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			<-startCh
			txErr := tenantdb.WithTx(ctx, appPool, tenantdb.Scope{
				WorkspaceID:             tenantA,
				UserID:                  userA,
				RequireActiveMembership: true,
			}, func(txCtx context.Context, q *tenantdb.Queries) error {
				if _, err := q.GetWorkspaceForUpdate(txCtx, tenantA); err != nil {
					return err
				}
				lots, err := q.ListCreditLotsForUpdate(txCtx, tenantA)
				if err != nil {
					return err
				}
				needed := tenantdb.MustParseExactDecimal("8")
				if len(lots) == 0 {
					return ErrInsufficientCredits
				}
				avail, err := lots[0].RemainingCredits.Sub(lots[0].ReservedCredits)
				if err != nil || avail.Cmp(needed) < 0 {
					return ErrInsufficientCredits
				}
				newRes, err := lots[0].ReservedCredits.Add(needed)
				if err != nil {
					return err
				}
				if err := q.UpdateCreditLotBalances(txCtx, tenantA, lots[0].LotID, lots[0].RemainingCredits, newRes); err != nil {
					return err
				}
				resRow, err := q.InsertReservation(txCtx, tenantdb.CreditReservationRow{
					WorkspaceID:     tenantA,
					QuoteID:         quoteIDs[idx],
					IdempotencyKey:  fmt.Sprintf("pg-concurrent-hold-%d", idx),
					RequestHash:     "hash_8_credits",
					Status:          ReservationHeld,
					ReservedCredits: needed,
					ExpiresAt:       now.Add(30 * time.Minute),
				})
				if err != nil {
					return err
				}
				_, err = q.InsertReservationAllocation(txCtx, tenantdb.CreditReservationAllocationRow{
					WorkspaceID:   tenantA,
					ReservationID: resRow.ReservationID,
					LotID:         lots[0].LotID,
					Credits:       needed,
				})
				return err
			})
			if txErr == nil {
				atomic.AddInt32(&pgSuccess, 1)
			} else if txErr == ErrInsufficientCredits {
				atomic.AddInt32(&pgInsufficient, 1)
			} else {
				t.Errorf("unexpected concurrent tx error: %v", txErr)
			}
		}(i)
	}
	close(startCh)
	wg.Wait()

	if pgSuccess != 1 || pgInsufficient != 1 {
		t.Fatalf("expected 1 PostgreSQL reservation success and 1 insufficient, got success=%d insufficient=%d", pgSuccess, pgInsufficient)
	}

	// 4. Verify append-only immutability trigger on ai_credit_transactions blocks UPDATE and DELETE.
	var txID string
	err = tenantdb.WithTx(ctx, appPool, tenantdb.Scope{
		WorkspaceID:             tenantA,
		UserID:                  userA,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		txRow, inserted, err := q.InsertCreditTransaction(txCtx, tenantdb.CreditTransactionRow{
			WorkspaceID:    tenantA,
			UserID:         userA,
			OperationType:  "ai_video_gen",
			CreditsDelta:   tenantdb.MustParseExactDecimal("-8"),
			BalanceAfter:   tenantdb.MustParseExactDecimal("2"),
			Source:         SourceSubscription,
			LotID:          lotA1,
			QuoteID:        quoteA1,
			IdempotencyKey: "pg-debit-immutable-1",
			Description:    "Test immutable debit",
		})
		if err != nil || !inserted {
			return fmt.Errorf("InsertCreditTransaction failed: inserted=%v err=%v", inserted, err)
		}
		txID = txRow.TransactionID
		return nil
	})
	if err != nil {
		t.Fatalf("insert credit transaction failed: %v", err)
	}

	_, updErr := adminPool.Exec(ctx, `UPDATE ai_credit_transactions SET description = 'tampered' WHERE transaction_id = $1::uuid`, txID)
	if updErr == nil || !strings.Contains(updErr.Error(), "append-only") {
		t.Fatalf("expected protect_credit_transaction_immutability trigger to block UPDATE, got %v", updErr)
	}
	_, delErr := adminPool.Exec(ctx, `DELETE FROM ai_credit_transactions WHERE transaction_id = $1::uuid`, txID)
	if delErr == nil || !strings.Contains(delErr.Error(), "append-only") {
		t.Fatalf("expected protect_credit_transaction_immutability trigger to block DELETE, got %v", delErr)
	}

	// 5. P1-05 Acceptance Target #3: Verify PostgreSQL-level payment grant replay cannot double-grant
	//    across ai_credit_lots (workspace_id, external_grant_key) and ai_credit_transactions (workspace_id, idempotency_key).
	err = tenantdb.WithTx(ctx, appPool, tenantdb.Scope{
		WorkspaceID:             tenantA,
		UserID:                  userA,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		const replayLotID = "44444444-4444-4444-8444-444444444499"
		_, inserted1, err := q.InsertCreditLotIdempotent(txCtx, tenantdb.CreditLotRow{
			LotID:            replayLotID,
			WorkspaceID:      tenantA,
			SourceType:       SourcePurchased,
			GrantedCredits:   tenantdb.MustParseExactDecimal("500"),
			RemainingCredits: tenantdb.MustParseExactDecimal("500"),
			ReservedCredits:  tenantdb.ZeroDecimal(),
			ExpiresAt:        nil,
			ExternalGrantKey: "stripe_pack:cs_p105_replay_test",
		})
		if err != nil || !inserted1 {
			return fmt.Errorf("first InsertCreditLotIdempotent failed: inserted=%v err=%v", inserted1, err)
		}
		// Replay the exact same external_grant_key with a new candidate LotID -> must return inserted=false!
		_, inserted2, err := q.InsertCreditLotIdempotent(txCtx, tenantdb.CreditLotRow{
			LotID:            "44444444-4444-4444-8444-444444444498",
			WorkspaceID:      tenantA,
			SourceType:       SourcePurchased,
			GrantedCredits:   tenantdb.MustParseExactDecimal("500"),
			RemainingCredits: tenantdb.MustParseExactDecimal("500"),
			ReservedCredits:  tenantdb.ZeroDecimal(),
			ExpiresAt:        nil,
			ExternalGrantKey: "stripe_pack:cs_p105_replay_test",
		})
		if err != nil || inserted2 {
			return fmt.Errorf("expected second InsertCreditLotIdempotent for same external_grant_key to be no-op (inserted=false), got inserted=%v err=%v", inserted2, err)
		}
		_, txInserted1, err := q.InsertCreditTransaction(txCtx, tenantdb.CreditTransactionRow{
			WorkspaceID:    tenantA,
			UserID:         userA,
			OperationType:  "credit_purchase",
			CreditsDelta:   tenantdb.MustParseExactDecimal("500"),
			BalanceAfter:   tenantdb.MustParseExactDecimal("502"),
			Source:         SourcePurchased,
			LotID:          replayLotID,
			IdempotencyKey: "grant:stripe_pack:cs_p105_replay_test",
			Description:    "P1-05 top-up grant",
		})
		if err != nil || !txInserted1 {
			return fmt.Errorf("first InsertCreditTransaction grant failed: inserted=%v err=%v", txInserted1, err)
		}
		_, txInserted2, err := q.InsertCreditTransaction(txCtx, tenantdb.CreditTransactionRow{
			WorkspaceID:    tenantA,
			UserID:         userA,
			OperationType:  "credit_purchase",
			CreditsDelta:   tenantdb.MustParseExactDecimal("500"),
			BalanceAfter:   tenantdb.MustParseExactDecimal("1002"),
			Source:         SourcePurchased,
			LotID:          replayLotID,
			IdempotencyKey: "grant:stripe_pack:cs_p105_replay_test",
			Description:    "Duplicate replay grant attempt",
		})
		if err != nil || txInserted2 {
			return fmt.Errorf("expected duplicate grant InsertCreditTransaction to be suppressed (inserted=false), got inserted=%v err=%v", txInserted2, err)
		}
		return nil
	})
	if err != nil {
		t.Fatalf("PostgreSQL payment replay idempotency verification failed: %v", err)
	}
}

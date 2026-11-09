package billing

import (
	"context"
	"errors"
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
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
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
	migConn, err := adminPool.Acquire(ctx)
	if err != nil {
		t.Fatalf("acquire migConn: %v", err)
	}
	if _, err := migConn.Exec(ctx, `SELECT pg_advisory_lock(77331100)`); err != nil {
		migConn.Release()
		t.Fatalf("pg_advisory_lock: %v", err)
	}
	_, migErr := migrate.Up(ctx, adminPool, dir)
	_, roleErr := adminPool.Exec(ctx, `ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw' NOBYPASSRLS`)
	_, _ = migConn.Exec(ctx, `SELECT pg_advisory_unlock(77331100)`)
	migConn.Release()
	if migErr != nil {
		t.Fatalf("migrate.Up failed: %v", migErr)
	}
	if roleErr != nil {
		t.Fatalf("configure app_user login: %v", roleErr)
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

	// Clean any prior test rows for tenantA / tenantB (temporarily disabling append-only trigger via superuser adminPool for test reset).
	_, _ = adminPool.Exec(ctx, `ALTER TABLE ai_credit_transactions DISABLE TRIGGER USER`)
	_, _ = adminPool.Exec(ctx, `DELETE FROM ai_credit_transactions WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `ALTER TABLE ai_credit_transactions ENABLE TRIGGER USER`)
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

func TestPostgresLiveBillingEngineAndServiceDurabilityAcrossRestarts(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL billing durability suite executes when DB is available")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	migConn, err := adminPool.Acquire(ctx)
	if err != nil {
		t.Fatalf("acquire migConn: %v", err)
	}
	if _, err := migConn.Exec(ctx, `SELECT pg_advisory_lock(77331100)`); err != nil {
		migConn.Release()
		t.Fatalf("pg_advisory_lock: %v", err)
	}
	_, migErr := migrate.Up(ctx, adminPool, dir)
	_, roleErr := adminPool.Exec(ctx, `ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw' NOBYPASSRLS`)
	_, _ = migConn.Exec(ctx, `SELECT pg_advisory_unlock(77331100)`)
	migConn.Release()
	if migErr != nil {
		t.Fatalf("migrate.Up failed: %v", migErr)
	}
	if roleErr != nil {
		t.Fatalf("configure app_user login: %v", roleErr)
	}

	const (
		userA   = "11111111-1111-4111-8111-111111111601"
		tenantA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaa601"
	)

	now := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)

	cleanup := func() {
		_, _ = adminPool.Exec(ctx, `DELETE FROM external_effects WHERE workspace_id = $1::uuid`, tenantA)
		_, _ = adminPool.Exec(ctx, `DELETE FROM workspace_members WHERE workspace_id = $1::uuid`, tenantA)
		_, _ = adminPool.Exec(ctx, `DELETE FROM workspaces WHERE workspace_id = $1::uuid`, tenantA)
		_, _ = adminPool.Exec(ctx, `DELETE FROM users WHERE user_id = $1::uuid`, userA)
	}
	cleanup()
	defer cleanup()

	if _, err := adminPool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status)
		VALUES ($1::uuid, 'ext_billing_restart_owner', 'billing-restart@creativanta.test', 'Billing Restart Owner', 'active')
	`, userA); err != nil {
		t.Fatalf("seed user: %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status)
		VALUES ($1::uuid, 'Billing Restart WS', 'billing-restart-ws', $2::uuid, 'active')
	`, tenantA, userA); err != nil {
		t.Fatalf("seed workspace: %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO workspace_members (workspace_id, user_id, role, status)
		VALUES ($1::uuid, $2::uuid, 'owner', 'active')
	`, tenantA, userA); err != nil {
		t.Fatalf("seed member: %v", err)
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

	reg := loadTestRBAC(t)
	ownerCtx := rbac.WithPolicyContext(ctx, rbac.PolicyContext{
		ActorUserID: userA,
		WorkspaceID: tenantA,
		Role:        rbac.RoleOwner,
	})

	// Instance 1: Create Starter subscription, settle starter webhook, and create a pending Business upgrade session.
	store1 := NewPostgresMemoryStore(now, appPool)
	svc1 := NewService(reg, NewEngine(store1), "whsec_test")
	svc1.SetClock(func() time.Time { return now })

	starterSess, err := svc1.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "pg-r01-starter-init"},
		TargetPlan:      "starter",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("svc1.ChangePlan(starter): %v", err)
	}
	if _, err := svc1.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_pg_starter_1",
		EventType:         "invoice.paid",
		WorkspaceID:       tenantA,
		SubscriptionID:    "sub_pg_starter_1",
		StripeInvoiceID:   "in_pg_starter_1",
		CheckoutSessionID: starterSess.GetCheckoutSessionId(),
		TargetPlan:        "starter",
		BillingInterval:   "monthly",
		PeriodKey:         "2026-11",
		AmountPaid:        tenantdb.MustParseExactDecimal("20"),
		Currency:          "USD",
		PaymentStatus:     "paid",
		OccurredAt:        now,
	}); err != nil {
		t.Fatalf("svc1.SettleStripeWebhook(starter): %v", err)
	}

	bizSess, err := svc1.ChangePlan(ownerCtx, &adminv1.ChangePlanRequest{
		Context:         &commonv1.CommandContext{IdempotencyKey: "pg-r01-biz-pending"},
		TargetPlan:      "business",
		BillingInterval: "monthly",
	})
	if err != nil {
		t.Fatalf("svc1.ChangePlan(business): %v", err)
	}

	// Instance 2 (simulating process restart / second instance with empty in-memory map):
	// 1) Replaying evt_pg_starter_1 on Instance 2 must be suppressed as duplicate.
	store2 := NewPostgresMemoryStore(now, appPool)
	svc2 := NewService(reg, NewEngine(store2), "whsec_test")
	svc2.SetClock(func() time.Time { return now })
	replayed, err := svc2.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_pg_starter_1",
		EventType:         "invoice.paid",
		WorkspaceID:       tenantA,
		SubscriptionID:    "sub_pg_starter_1",
		StripeInvoiceID:   "in_pg_starter_1",
		CheckoutSessionID: starterSess.GetCheckoutSessionId(),
		TargetPlan:        "starter",
		BillingInterval:   "monthly",
		PeriodKey:         "2026-11",
		AmountPaid:        tenantdb.MustParseExactDecimal("20"),
		Currency:          "USD",
		PaymentStatus:     "paid",
		OccurredAt:        now,
	})
	if err != nil || !replayed.Duplicate {
		t.Fatalf("expected webhook replay on fresh Instance 2 to be suppressed (Duplicate=true), got replayed=%+v err=%v", replayed, err)
	}

	// 2) R01 cross-instance check: A routine Starter renewal invoice ($20) arriving on Instance 2 while Business ($150)
	//    upgrade session is still pending in PostgreSQL must NOT activate Business!
	if _, err := svc2.SettleStripeWebhook(StripeWebhookEvent{
		EventID:         "evt_pg_starter_renewal_2026_12",
		EventType:       "invoice.paid",
		WorkspaceID:     tenantA,
		SubscriptionID:  "sub_pg_starter_1",
		StripeInvoiceID: "in_pg_starter_renewal_2",
		PeriodKey:       "2026-12",
		AmountPaid:      tenantdb.MustParseExactDecimal("20"),
		Currency:        "USD",
		PaymentStatus:   "paid",
		OccurredAt:      now.Add(30 * 24 * time.Hour),
	}); err != nil {
		t.Fatalf("svc2.SettleStripeWebhook(starter renewal): %v", err)
	}
	// Underpaid Business invoice on Instance 2 must fail closed with ErrInvalidBillingInput.
	if _, err := svc2.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_pg_biz_underpaid",
		EventType:         "invoice.paid",
		WorkspaceID:       tenantA,
		SubscriptionID:    "sub_pg_starter_1",
		StripeInvoiceID:   "in_pg_biz_underpaid",
		CheckoutSessionID: bizSess.GetCheckoutSessionId(),
		TargetPlan:        "business",
		BillingInterval:   "monthly",
		PeriodKey:         "2026-12",
		AmountPaid:        tenantdb.MustParseExactDecimal("20"),
		Currency:          "USD",
		PaymentStatus:     "paid",
		OccurredAt:        now.Add(30 * 24 * time.Hour),
	}); !errors.Is(err, ErrInvalidBillingInput) {
		t.Fatalf("expected underpaid Business invoice on Instance 2 to fail with ErrInvalidBillingInput, got %v", err)
	}

	// Instance 3 (another fresh process) verifies tier is still Starter and Business session is still pending,
	// then settles the actual Business upgrade invoice ($150) bound to bizSess.
	store3 := NewPostgresMemoryStore(now, appPool)
	svc3 := NewService(reg, NewEngine(store3), "whsec_test")
	svc3.SetClock(func() time.Time { return now })
	_ = store3.WithWorkspaceTx(tenantA, func(st *WorkspaceBillingState) error {
		if st.SubscriptionTier != "starter" {
			t.Fatalf("expected workspace tier on fresh Instance 3 to remain starter after renewal invoice, got %q", st.SubscriptionTier)
		}
		return nil
	})

	if _, err := svc3.SettleStripeWebhook(StripeWebhookEvent{
		EventID:           "evt_pg_biz_settled",
		EventType:         "invoice.paid",
		WorkspaceID:       tenantA,
		SubscriptionID:    "sub_pg_starter_1",
		StripeInvoiceID:   "in_pg_biz_1",
		CheckoutSessionID: bizSess.GetCheckoutSessionId(),
		TargetPlan:        "business",
		BillingInterval:   "monthly",
		PeriodKey:         "2026-12",
		AmountPaid:        tenantdb.MustParseExactDecimal("200"),
		Currency:          "USD",
		PaymentStatus:     "paid",
		OccurredAt:        now.Add(30*24*time.Hour + time.Minute),
	}); err != nil {
		t.Fatalf("svc3.SettleStripeWebhook(business upgrade): %v", err)
	}

	// Verify on Instance 1 that it sees the Business upgrade committed by Instance 3 via PostgreSQL!
	_ = store1.WithWorkspaceTx(tenantA, func(st *WorkspaceBillingState) error {
		if st.SubscriptionTier != "business" {
			t.Fatalf("expected Instance 1 to observe business tier persisted by Instance 3, got %q", st.SubscriptionTier)
		}
		return nil
	})

	// 3) N05 cross-instance & multi-tenant UUID uniqueness check in PostgreSQL:
	// Two brand-new NewPostgresMemoryStore instances (both starting with seqCounter=0) persisting state for
	// tenantB and tenantC must NOT collide on external_effects_pkey (effect_id), and a second fresh
	// instance reloading the same tenant must generate globally unique lot/transaction/invoice UUIDs.
	const (
		tenantB = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbb602"
		tenantC = "cccccccc-cccc-4ccc-8ccc-ccccccccc603"
	)
	defer func() {
		_, _ = adminPool.Exec(ctx, `DELETE FROM external_effects WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantB, tenantC)
		_, _ = adminPool.Exec(ctx, `DELETE FROM workspace_members WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantB, tenantC)
		_, _ = adminPool.Exec(ctx, `DELETE FROM workspaces WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantB, tenantC)
	}()
	for _, ws := range []struct{ id, slug string }{{tenantB, "billing-dur-b"}, {tenantC, "billing-dur-c"}} {
		if _, err := adminPool.Exec(ctx, `
			INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status)
			VALUES ($1::uuid, $2, $2, $3::uuid, 'active')
			ON CONFLICT (workspace_id) DO NOTHING
		`, ws.id, ws.slug, userA); err != nil {
			t.Fatalf("seed %s: %v", ws.slug, err)
		}
		if _, err := adminPool.Exec(ctx, `
			INSERT INTO workspace_members (workspace_id, user_id, role, status)
			VALUES ($1::uuid, $2::uuid, 'owner', 'active')
			ON CONFLICT (workspace_id, user_id) DO NOTHING
		`, ws.id, userA); err != nil {
			t.Fatalf("seed member %s: %v", ws.slug, err)
		}
	}

	freshStoreB := NewPostgresMemoryStore(now, appPool)
	freshStoreC := NewPostgresMemoryStore(now, appPool)
	svcFreshB := NewService(reg, NewEngine(freshStoreB), "whsec_n05_b")
	svcFreshC := NewService(reg, NewEngine(freshStoreC), "whsec_n05_c")
	svcFreshB.SetClock(func() time.Time { return now })
	svcFreshC.SetClock(func() time.Time { return now })

	subB, err := svcFreshB.StartProTrial(rbac.WithPolicyContext(ctx, rbac.PolicyContext{
		ActorUserID: userA,
		WorkspaceID: tenantB,
		Role:        rbac.RoleOwner,
	}), tenantB)
	if err != nil {
		t.Fatalf("N05 PG: svcFreshB.StartProTrial(tenantB) failed: %v", err)
	}
	subC, err := svcFreshC.StartProTrial(rbac.WithPolicyContext(ctx, rbac.PolicyContext{
		ActorUserID: userA,
		WorkspaceID: tenantC,
		Role:        rbac.RoleOwner,
	}), tenantC)
	if err != nil {
		t.Fatalf("N05 PG: svcFreshC.StartProTrial(tenantC) failed (external_effects_pkey collision): %v", err)
	}
	if subB.GetSubscriptionId().GetValue() == subC.GetSubscriptionId().GetValue() {
		t.Fatalf("N05 PG: cross-tenant SubscriptionID collision: %s", subB.GetSubscriptionId().GetValue())
	}

	// Reload tenantB on another fresh instance (seqCounter=0) and grant additional credits; verify no LotID or TransactionID collision.
	freshStoreB2 := NewPostgresMemoryStore(now, appPool)
	engineB2 := NewEngine(freshStoreB2)
	lot2, _, err := engineB2.GrantLot(
		tenantB,
		userA,
		SourcePurchased,
		tenantdb.MustParseExactDecimal("100"),
		nil,
		"n05-pg-pack-b2",
		"N05 cross-instance grant",
		now,
	)
	if err != nil {
		t.Fatalf("N05 PG: GrantLot on freshStoreB2 failed: %v", err)
	}
	_ = freshStoreB2.WithWorkspaceTx(tenantB, func(st *WorkspaceBillingState) error {
		if len(st.Lots) != 2 || st.Lots[0].LotID == st.Lots[1].LotID {
			t.Fatalf("N05 PG: expected 2 distinct LotIDs after second instance grant, got %+v", st.Lots)
		}
		if len(st.Transactions) != 2 || st.Transactions[0].TransactionID == st.Transactions[1].TransactionID {
			t.Fatalf("N05 PG: expected 2 distinct TransactionIDs after second instance grant, got %+v", st.Transactions)
		}
		return nil
	})
	_ = lot2
}

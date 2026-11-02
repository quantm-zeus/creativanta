package outbox

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func TestPostgresLiveOutboxInboxAndExternalEffects(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL 17.10 outbox/inbox/external_effects suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	_, _ = adminPool.Exec(ctx, `DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO CURRENT_USER; GRANT USAGE ON SCHEMA public TO PUBLIC;`)
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, dir); err != nil {
		t.Fatalf("migrate.Up failed: %v", err)
	}

	seedSQL := `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ('11111111-1111-4111-8111-111111111111', 'user_ext_a', 'a@example.com', 'User A', 'active'),
		  ('22222222-2222-4222-8222-222222222222', 'user_ext_b', 'b@example.com', 'User B', 'active');

		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Tenant A', 'tenant-a', '11111111-1111-4111-8111-111111111111', 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Tenant B', 'tenant-b', '22222222-2222-4222-8222-222222222222', 'active');

		INSERT INTO workspace_members (workspace_id, user_id, role, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '11111111-1111-4111-8111-111111111111', 'owner', 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '22222222-2222-4222-8222-222222222222', 'owner', 'active');
	`
	if _, err := adminPool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seedSQL failed: %v", err)
	}

	scopeA := tenantdb.Scope{WorkspaceID: testWorkspaceA, UserID: testUserA, RequireActiveMembership: true}

	// 1. Enqueue event to event_outbox inside tenant transaction.
	err = tenantdb.WithTx(ctx, adminPool, scopeA, func(txCtx context.Context, q *tenantdb.Queries) error {
		return q.EnqueueOutboxEvent(txCtx, tenantdb.EnqueueOutboxEventParams{
			EventID:       testEvent1,
			EventType:     "publish.scheduled",
			TargetStream:  string(QueuePublishJobs),
			AggregateType: "publish_job",
			AggregateID:   testAgg1,
			WorkspaceID:   testWorkspaceA,
			Payload:       []byte(`{"publish_job_id":"a1111111-1111-4111-8111-111111111111"}`),
		})
	})
	if err != nil {
		t.Fatalf("EnqueueOutboxEvent failed: %v", err)
	}

	// 2. Poll using PgOutboxStore as outbox_poller role: simulate lease expiry takeover.
	pgOutbox := NewPgOutboxStore(adminPool, true)
	now := time.Now().UTC()

	claimedA, err := pgOutbox.ClaimBatch(ctx, "poller-a", now, 30*time.Second, 10)
	if err != nil {
		t.Fatalf("pgOutbox.ClaimBatch(poller-a) failed: %v", err)
	}
	if len(claimedA) != 1 || claimedA[0].EventID != testEvent1 || claimedA[0].AttemptCount != 1 {
		t.Fatalf("unexpected claimedA: %+v", claimedA)
	}

	// Poller B polls 10s later (while Poller A's 30s lease is active) -> 0 rows claimed.
	claimedEarly, err := pgOutbox.ClaimBatch(ctx, "poller-b", now.Add(10*time.Second), 30*time.Second, 10)
	if err != nil {
		t.Fatalf("pgOutbox.ClaimBatch(poller-b early) failed: %v", err)
	}
	if len(claimedEarly) != 0 {
		t.Fatalf("expected 0 rows claimed while lease is active, got %d", len(claimedEarly))
	}

	// Poller B polls 35s later (after Poller A's lease expired) -> reclaims row with attempt_count=2.
	claimedB, err := pgOutbox.ClaimBatch(ctx, "poller-b", now.Add(35*time.Second), 30*time.Second, 10)
	if err != nil {
		t.Fatalf("pgOutbox.ClaimBatch(poller-b takeover) failed: %v", err)
	}
	if len(claimedB) != 1 || claimedB[0].AttemptCount != 2 || claimedB[0].LeaseOwner != "poller-b" {
		t.Fatalf("expected reclaimed row with attempt_count=2 and lease_owner=poller-b, got %+v", claimedB)
	}

	// Stale Poller A attempts MarkPublished -> must fail with ErrStaleOutboxLease!
	if err := pgOutbox.MarkPublished(ctx, claimedA[0].OutboxID, "poller-a", now.Add(36*time.Second)); !errors.Is(err, ErrStaleOutboxLease) {
		t.Fatalf("expected ErrStaleOutboxLease for stale poller-a on PostgreSQL, got %v", err)
	}

	// Active Poller B marks published -> succeeds.
	if err := pgOutbox.MarkPublished(ctx, claimedB[0].OutboxID, "poller-b", now.Add(36*time.Second)); err != nil {
		t.Fatalf("pgOutbox.MarkPublished(poller-b) failed: %v", err)
	}

	// 3. Consumer inbox deduplication and external_effects lifecycle under RLS.
	const inboxID1 = "c1111111-1111-4111-8111-111111111111"
	const inboxID2 = "c2222222-2222-4222-8222-222222222222"
	err = tenantdb.WithTx(ctx, adminPool, scopeA, func(txCtx context.Context, q *tenantdb.Queries) error {
		inserted1, err := q.TryInsertConsumerInbox(txCtx, inboxID1, testWorkspaceA, "cg_publish", testEvent1)
		if err != nil {
			return err
		}
		if !inserted1 {
			t.Fatalf("expected first TryInsertConsumerInbox to return true")
		}
		inserted2, err := q.TryInsertConsumerInbox(txCtx, inboxID2, testWorkspaceA, "cg_publish", testEvent1)
		if err != nil {
			return err
		}
		if inserted2 {
			t.Fatalf("expected duplicate TryInsertConsumerInbox to return false")
		}

		eff, err := q.InsertPreparedExternalEffect(txCtx, tenantdb.PrepareExternalEffectParams{
			EffectID:      testEvent1,
			WorkspaceID:   testWorkspaceA,
			OperationKey:  "publish:tiktok:live_pg_1",
			Provider:      "tiktok",
			AggregateType: "publish_job",
			AggregateID:   testAgg1,
		})
		if err != nil {
			return err
		}
		if eff.Status != "prepared" {
			t.Fatalf("expected status=prepared, got %s", eff.Status)
		}

		effUnk, err := q.UpdateExternalEffectStatus(txCtx, tenantdb.UpdateExternalEffectStatusParams{
			WorkspaceID:       testWorkspaceA,
			OperationKey:      "publish:tiktok:live_pg_1",
			Status:            "unknown",
			ProviderRequestID: "tt_req_pg_1",
			ResultPayload:     []byte(`{"error":"timeout"}`),
		})
		if err != nil {
			return err
		}
		if effUnk.Status != "unknown" {
			t.Fatalf("expected status=unknown, got %s", effUnk.Status)
		}

		diag, err := q.InsertDiagnosticRecord(txCtx, tenantdb.InsertDiagnosticRecordParams{
			DiagnosticsID:         testDiag1,
			WorkspaceID:           testWorkspaceA,
			ScopeType:             "publish_job",
			ScopeID:               testAgg1,
			ErrorType:             "external_effect_outcome_unknown",
			Severity:              "warning",
			UserFacingExplanation: "Kết nối đối tác bị gián đoạn trước khi xác nhận.",
			LikelyCauses:          []string{"Timeout mạng"},
			SuggestedActions:      []string{"Xác minh trên nền tảng trước khi gửi lại"},
			RepairPath:            "reconcile_external_effect:publish:tiktok:live_pg_1",
		})
		if err != nil {
			return err
		}
		if diag.Status != "open" {
			t.Fatalf("expected open diagnostic record, got %s", diag.Status)
		}
		return nil
	})
	if err != nil {
		t.Fatalf("consumer_inbox / external_effects / diagnostics_records transaction failed: %v", err)
	}
}

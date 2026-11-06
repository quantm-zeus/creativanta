package outbox_test

import (
	"bufio"
	"bytes"
	"context"
	"crypto/rand"
	"crypto/rsa"
	"crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	durableTestWsA    = "11111111-2222-4333-8444-555555555501"
	durableTestWsB    = "11111111-2222-4333-8444-555555555502"
	durableTestOwnerA = "aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeee01"
	durableTestOwnerB = "aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeee02"
)

func setupDisposableOutboxDB(t *testing.T) (*pgxpool.Pool, string) {
	t.Helper()

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	var randBytes [6]byte
	_, _ = rand.Read(randBytes[:])
	suffix := fmt.Sprintf("%d_%s", time.Now().UnixNano(), hex.EncodeToString(randBytes[:]))
	dbName := "creativanta_outbox_test_" + suffix
	roleName := "creativanta_outbox_role_" + suffix
	rolePass := "tmp_pw_" + hex.EncodeToString(randBytes[:])

	var disposableDSN string
	var cleanupDB func()

	if baseDSN := strings.TrimSpace(os.Getenv("CREATIVANTA_TEST_DATABASE_URL")); baseDSN != "" {
		adminPool, err := pgxpool.New(ctx, baseDSN)
		if err != nil {
			t.Fatalf("connect admin pool: %v", err)
		}
		if _, err := adminPool.Exec(ctx, fmt.Sprintf("CREATE DATABASE %s", dbName)); err != nil {
			adminPool.Close()
			t.Fatalf("create disposable database %s: %v", dbName, err)
		}
		parsedURL, err := url.Parse(baseDSN)
		if err != nil {
			adminPool.Close()
			t.Fatalf("parse base DSN: %v", err)
		}
		parsedURL.Path = "/" + dbName
		disposableDSN = parsedURL.String()
		cleanupDB = func() {
			cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cleanCancel()
			_, _ = adminPool.Exec(cleanCtx, fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE)", dbName))
			adminPool.Close()
		}
	} else {
		conn, err := net.DialTimeout("tcp", "127.0.0.1:15432", 1*time.Second)
		if err != nil {
			t.Skip("PostgreSQL not reachable on 127.0.0.1:15432 and CREATIVANTA_TEST_DATABASE_URL not set")
		}
		_ = conn.Close()

		createRoleCmd := exec.CommandContext(ctx, "docker", "exec", "creativanta-p0-postgres-1",
			"psql", "-U", "creativanta_dev", "-d", "creativanta_dev", "-v", "ON_ERROR_STOP=1",
			"-c", fmt.Sprintf("CREATE ROLE %s WITH LOGIN SUPERUSER PASSWORD '%s';", roleName, rolePass),
			"-c", fmt.Sprintf("CREATE DATABASE %s OWNER %s;", dbName, roleName),
		)
		if out, err := createRoleCmd.CombinedOutput(); err != nil {
			t.Skipf("local disposable docker postgres setup unavailable: %v (%s)", err, string(out))
		}
		disposableDSN = fmt.Sprintf("postgres://%s:%s@127.0.0.1:15432/%s?sslmode=disable", roleName, rolePass, dbName)
		cleanupDB = func() {
			cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cleanCancel()
			_ = exec.CommandContext(cleanCtx, "docker", "exec", "creativanta-p0-postgres-1",
				"psql", "-U", "creativanta_dev", "-d", "creativanta_dev",
				"-c", fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE);", dbName),
				"-c", fmt.Sprintf("DROP ROLE IF EXISTS %s;", roleName),
			).Run()
		}
	}

	pool, err := pgxpool.New(ctx, disposableDSN)
	if err != nil {
		cleanupDB()
		t.Fatalf("connect disposable DB: %v", err)
	}

	t.Cleanup(func() {
		pool.Close()
		cleanupDB()
	})

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, pool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up on disposable DB failed: %v", err)
	}

	seedSQL := fmt.Sprintf(`
		INSERT INTO users (user_id, clerk_id, email, display_name, status)
		VALUES
			('%s'::uuid, 'clerk_durable_owner_a', 'owner_a@example.com', 'Owner A', 'active'),
			('%s'::uuid, 'clerk_durable_owner_b', 'owner_b@example.com', 'Owner B', 'active')
		ON CONFLICT (user_id) DO NOTHING;

		INSERT INTO workspaces (
			workspace_id, name, slug, owner_user_id, subscription_tier,
			default_mode, enabled_modes, locale, timezone, status
		)
		VALUES
			('%s'::uuid, 'Durable Test Workspace A', 'durable-ws-a', '%s'::uuid, 'pro', 'seller'::operator_mode, ARRAY['seller']::operator_mode[], 'vi-VN', 'Asia/Ho_Chi_Minh', 'active'),
			('%s'::uuid, 'Durable Test Workspace B', 'durable-ws-b', '%s'::uuid, 'free', 'creator'::operator_mode, ARRAY['creator']::operator_mode[], 'en-US', 'UTC', 'active')
		ON CONFLICT (workspace_id) DO NOTHING;

		INSERT INTO workspace_members (workspace_id, user_id, role, status)
		VALUES
			('%s'::uuid, '%s'::uuid, 'owner', 'active'),
			('%s'::uuid, '%s'::uuid, 'owner', 'active')
		ON CONFLICT (workspace_id, user_id) DO UPDATE SET role = EXCLUDED.role, status = EXCLUDED.status;
	`,
		durableTestOwnerA, durableTestOwnerB,
		durableTestWsA, durableTestOwnerA,
		durableTestWsB, durableTestOwnerB,
		durableTestWsA, durableTestOwnerA,
		durableTestWsB, durableTestOwnerB,
	)
	if _, err := pool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seed disposable DB failed: %v", err)
	}

	return pool, disposableDSN
}

func enqueueTenantOutboxEvent(
	t *testing.T,
	ctx context.Context,
	pool *pgxpool.Pool,
	workspaceID, userID, eventID, eventType string,
	stream outbox.QueueName,
	aggregateType, aggregateID string,
	payload map[string]any,
	meta map[string]any,
) {
	t.Helper()
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		t.Fatalf("marshal payload: %v", err)
	}
	metaBytes, err := json.Marshal(meta)
	if err != nil {
		t.Fatalf("marshal metadata: %v", err)
	}

	err = tenantdb.WithTx(ctx, pool, tenantdb.Scope{
		WorkspaceID:             workspaceID,
		UserID:                  userID,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		return q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
			EventID:       eventID,
			EventType:     eventType,
			TargetStream:  string(stream),
			AggregateType: aggregateType,
			AggregateID:   aggregateID,
			WorkspaceID:   workspaceID,
			PayloadJSON:   payloadBytes,
			MetadataJSON:  metaBytes,
		})
	})
	if err != nil {
		t.Fatalf("InsertOutboxEvent failed: %v", err)
	}
}

// TestMultiProcessOutboxPollerToWorkerDurableHandoff verifies IQ-02, IQ-03, ASYNC-01, and R11:
//  1. OS Process 1 (`cmd/outbox poll-once`) claims an unpublished event_outbox row from PostgreSQL,
//     publishes it to the shared durable broker, marks it published, and terminates.
//  2. The event survives Process 1 termination without in-memory loss.
//  3. OS Process 2 (`cmd/worker run-once`) starts in a separate process, reads the event from the
//     shared durable broker, verifies live RBAC & tenant membership in PostgreSQL, records
//     consumer_inbox + external_effects + diagnostics_records + audit_events atomically inside
//     tenantdb.WithTx, and XAck's the broker entry.
//  4. OS Process 3 (`cmd/worker run-once`) finds 0 pending messages and causes zero duplicate effects.
func TestMultiProcessOutboxPollerToWorkerDurableHandoff(t *testing.T) {
	pool, dsn := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	const (
		eventID     = "0195f000-0000-7000-8000-000000000101"
		aggregateID = "0195f000-0000-7000-8000-000000000201"
	)

	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		eventID, "product.created", outbox.QueueSearchIndexing,
		"product", aggregateID,
		map[string]any{
			"product_id":   aggregateID,
			"workspace_id": durableTestWsA,
			"title":        "Áo Khoác Dù Chống Nước",
			"priority":     "normal",
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "product:manage",
		},
	)

	binDir := t.TempDir()
	outboxBin := filepath.Join(binDir, "outbox")
	workerBin := filepath.Join(binDir, "worker")

	buildOutbox := exec.CommandContext(ctx, "go", "build", "-o", outboxBin, "../../cmd/outbox")
	if out, err := buildOutbox.CombinedOutput(); err != nil {
		t.Fatalf("build cmd/outbox failed: %v\n%s", err, string(out))
	}
	buildWorker := exec.CommandContext(ctx, "go", "build", "-o", workerBin, "../../cmd/worker")
	if out, err := buildWorker.CombinedOutput(); err != nil {
		t.Fatalf("build cmd/worker failed: %v\n%s", err, string(out))
	}

	// Process 1: outbox poll-once
	pollCmd := exec.CommandContext(ctx, outboxBin, "poll-once")
	pollCmd.Env = append(os.Environ(),
		"CREATIVANTA_OUTBOX_DATABASE_URL="+dsn,
		"CREATIVANTA_REDIS_URL=",
	)
	pollOut, err := pollCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("outbox poll-once failed: %v\n%s", err, string(pollOut))
	}
	if !strings.Contains(string(pollOut), "claimed=1 published=1 retried=0") {
		t.Fatalf("unexpected outbox poll-once output: %s", string(pollOut))
	}

	// Verify row is marked published in PostgreSQL and queued in durable PgStreamBroker,
	// while consumer_inbox is still empty before worker runs.
	var published bool
	if err := pool.QueryRow(ctx, `SELECT published FROM event_outbox WHERE event_id = $1::uuid`, eventID).Scan(&published); err != nil {
		t.Fatalf("query event_outbox published: %v", err)
	}
	if !published {
		t.Fatalf("expected event_outbox row to be marked published after outbox poll-once")
	}

	var inboxBefore int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM consumer_inbox WHERE event_id = $1::uuid`, eventID).Scan(&inboxBefore); err != nil {
		t.Fatalf("query consumer_inbox before worker: %v", err)
	}
	if inboxBefore != 0 {
		t.Fatalf("expected 0 consumer_inbox rows before worker runs, got %d", inboxBefore)
	}

	// Process 2: worker run-once (separate OS process)
	workerCmd := exec.CommandContext(ctx, workerBin, "run-once")
	workerCmd.Env = append(os.Environ(),
		"CREATIVANTA_WORKER_DATABASE_URL="+dsn,
		"CREATIVANTA_WORKER_GROUP=worker-main",
		"CREATIVANTA_REDIS_URL=",
	)
	workerOut, err := workerCmd.CombinedOutput()
	if err != nil {
		t.Fatalf("worker run-once failed: %v\n%s", err, string(workerOut))
	}
	if !strings.Contains(string(workerOut), "executed_count=1") {
		t.Fatalf("unexpected worker run-once output: %s", string(workerOut))
	}

	// Verify durable state changes in PostgreSQL after Process 2 exits:
	var inboxAfter, effectsCount, diagCount, auditCount int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM consumer_inbox WHERE consumer_name = 'worker-main' AND event_id = $1::uuid`, eventID).Scan(&inboxAfter); err != nil {
		t.Fatalf("query consumer_inbox after worker: %v", err)
	}
	if inboxAfter != 1 {
		t.Fatalf("expected 1 consumer_inbox row after worker run-once, got %d", inboxAfter)
	}

	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM external_effects WHERE workspace_id = $1::uuid AND status = 'succeeded'`, durableTestWsA).Scan(&effectsCount); err != nil {
		t.Fatalf("query external_effects: %v", err)
	}
	if effectsCount != 1 {
		t.Fatalf("expected 1 succeeded external_effects row, got %d", effectsCount)
	}

	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM diagnostics_records WHERE workspace_id = $1::uuid AND error_type = 'domain_event_processed:product.created' AND status = 'resolved'`, durableTestWsA).Scan(&diagCount); err != nil {
		t.Fatalf("query diagnostics_records: %v", err)
	}
	if diagCount != 1 {
		t.Fatalf("expected 1 resolved diagnostics_records row, got %d", diagCount)
	}

	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM audit_events WHERE workspace_id = $1::uuid AND action = 'consumer.processed:product.created'`, durableTestWsA).Scan(&auditCount); err != nil {
		t.Fatalf("query audit_events: %v", err)
	}
	if auditCount != 1 {
		t.Fatalf("expected 1 processed audit_events row, got %d", auditCount)
	}

	pgBroker := outbox.NewPgStreamBroker(pool, false)
	pending := pgBroker.PendingCount(outbox.QueueSearchIndexing, "worker-main")
	if pending != 0 {
		t.Fatalf("expected PendingCount=0 after durable XAck, got %d", pending)
	}

	// Process 3: running worker run-once again must process 0 messages and create no duplicate rows.
	workerCmd2 := exec.CommandContext(ctx, workerBin, "run-once")
	workerCmd2.Env = append(os.Environ(),
		"CREATIVANTA_WORKER_DATABASE_URL="+dsn,
		"CREATIVANTA_WORKER_GROUP=worker-main",
		"CREATIVANTA_REDIS_URL=",
	)
	workerOut2, err := workerCmd2.CombinedOutput()
	if err != nil {
		t.Fatalf("second worker run-once failed: %v\n%s", err, string(workerOut2))
	}
	if !strings.Contains(string(workerOut2), "executed_count=0") {
		t.Fatalf("expected second worker run-once to report executed_count=0, got: %s", string(workerOut2))
	}
}

// TestCrashBetweenCommitAndXAckRecoveryAndReplayProtection verifies IQ-02, IQ-03, and ASYNC-01:
// When a worker crashes after committing consumer_inbox + domain side effects to PostgreSQL
// but BEFORE sending XAck to the broker, a subsequent worker reclaims the stuck message via
// XAutoClaim after 60s idle, detects the duplicate in consumer_inbox, skips re-executing the
// domain handler, and XAck's the message cleanly.
func TestCrashBetweenCommitAndXAckRecoveryAndReplayProtection(t *testing.T) {
	pool, _ := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	const (
		eventID     = "0195f000-0000-7000-8000-000000000102"
		aggregateID = "0195f000-0000-7000-8000-000000000202"
	)

	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		eventID, "product.created", outbox.QueueSearchIndexing,
		"product", aggregateID,
		map[string]any{"product_id": aggregateID, "workspace_id": durableTestWsA},
		map[string]any{"actor_id": durableTestOwnerA, "actor_type": "user", "required_perm": "product:manage"},
	)

	now := time.Now().UTC().Truncate(time.Millisecond)
	store := outbox.NewPgOutboxStore(pool, false)
	broker := outbox.NewPgStreamBroker(pool, false)

	poller := outbox.NewOutboxPoller("poller-crash-test", store, broker)
	res, err := poller.PollOnce(ctx, now)
	if err != nil || res.PublishedCount != 1 {
		t.Fatalf("PollOnce failed: res=%+v err=%v", res, err)
	}

	inboxEngine := outbox.NewPgConsumerInboxEngine(pool)
	authVerifier := outbox.NewPgLiveAuthVerifier(pool)
	domainHandler := outbox.NewPgDomainActionHandler()

	var handlerCalls int
	countingHandler := func(hCtx context.Context, msg outbox.StreamMessage) error {
		handlerCalls++
		return domainHandler.Handle(hCtx, msg)
	}

	errCrashAfterCommit := errors.New("simulated worker crash after DB commit before XAck")
	worker1 := outbox.NewConsumerWorker(outbox.QueueSearchIndexing, "worker-main", "worker-crashed", broker, inboxEngine)
	worker1.AuthVerifier = authVerifier
	worker1.Faults = outbox.ConsumerFaultHooks{
		AfterTxCommitBeforeAck: func(msg outbox.StreamMessage) error {
			return errCrashAfterCommit
		},
	}

	outcomes1, err := worker1.ProcessNext(ctx, now, 10, countingHandler)
	if !errors.Is(err, errCrashAfterCommit) {
		t.Fatalf("expected errCrashAfterCommit, got outcomes=%+v err=%v", outcomes1, err)
	}
	if handlerCalls != 1 {
		t.Fatalf("expected handlerCalls=1 before crash, got %d", handlerCalls)
	}

	// Message must remain in PEL (PendingCount == 1) because XAck was not reached.
	pending1 := broker.PendingCount(outbox.QueueSearchIndexing, "worker-main")
	if pending1 != 1 {
		t.Fatalf("expected PendingCount=1 after crash before XAck, got %d", pending1)
	}

	// Advance clock past DefaultConsumerIdleClaimTimeout (60s) and run recovery worker.
	now = now.Add(65 * time.Second)
	worker2 := outbox.NewConsumerWorker(outbox.QueueSearchIndexing, "worker-main", "worker-recovery", broker, inboxEngine)
	worker2.AuthVerifier = authVerifier

	outcomes2, err := worker2.ProcessNext(ctx, now, 10, countingHandler)
	if err != nil {
		t.Fatalf("recovery worker ProcessNext failed: %v", err)
	}
	if len(outcomes2) != 1 || !outcomes2[0].Deduplicated || !outcomes2[0].Acked {
		t.Fatalf("expected 1 Deduplicated+Acked outcome on recovery, got %+v", outcomes2)
	}
	if handlerCalls != 1 {
		t.Fatalf("replay protection failed: handler executed %d times (expected strictly 1)", handlerCalls)
	}

	pending2 := broker.PendingCount(outbox.QueueSearchIndexing, "worker-main")
	if pending2 != 0 {
		t.Fatalf("expected PendingCount=0 after recovery XAck, got %d", pending2)
	}

	var effectsCount int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM external_effects WHERE workspace_id = $1::uuid`, durableTestWsA).Scan(&effectsCount); err != nil {
		t.Fatalf("query external_effects: %v", err)
	}
	if effectsCount != 1 {
		t.Fatalf("expected strictly 1 external_effects row after recovery, got %d", effectsCount)
	}
}

// TestLiveAuthRevocationAbortsQueuedJobInPostgres verifies ASYNC-01:
// When a user's workspace membership or role is revoked in PostgreSQL AFTER an event is published
// to the broker but BEFORE the worker executes it, PgLiveAuthVerifier aborts execution, writes an
// aborted audit_events record, and XAck's the message without executing domain side effects.
func TestLiveAuthRevocationAbortsQueuedJobInPostgres(t *testing.T) {
	pool, _ := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	const (
		eventID     = "0195f000-0000-7000-8000-000000000103"
		aggregateID = "0195f000-0000-7000-8000-000000000203"
	)

	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		eventID, "product.created", outbox.QueueSearchIndexing,
		"product", aggregateID,
		map[string]any{"product_id": aggregateID, "workspace_id": durableTestWsA},
		map[string]any{"actor_id": durableTestOwnerA, "actor_type": "user", "required_perm": "product:manage"},
	)

	now := time.Now().UTC()
	poller := outbox.NewOutboxPoller("poller-auth-revoke", outbox.NewPgOutboxStore(pool, false), outbox.NewPgStreamBroker(pool, false))
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce: %v", err)
	}

	// Downgrade ownerA to viewer in PostgreSQL before worker processes the message.
	if _, err := pool.Exec(ctx, `
		UPDATE workspace_members
		SET role = 'viewer'
		WHERE workspace_id = $1::uuid AND user_id = $2::uuid
	`, durableTestWsA, durableTestOwnerA); err != nil {
		t.Fatalf("downgrade member role: %v", err)
	}

	var handlerCalled bool
	worker := outbox.NewConsumerWorker(
		outbox.QueueSearchIndexing,
		"worker-main",
		"worker-auth-check",
		outbox.NewPgStreamBroker(pool, false),
		outbox.NewPgConsumerInboxEngine(pool),
	)
	worker.AuthVerifier = outbox.NewPgLiveAuthVerifier(pool)

	outcomes, err := worker.ProcessNext(ctx, now, 10, func(ctx context.Context, msg outbox.StreamMessage) error {
		handlerCalled = true
		return nil
	})
	if err != nil {
		t.Fatalf("ProcessNext failed: %v", err)
	}
	if len(outcomes) != 1 || !outcomes[0].AbortedAuth || !outcomes[0].Acked {
		t.Fatalf("expected AbortedAuth+Acked outcome, got %+v", outcomes)
	}
	if handlerCalled {
		t.Fatalf("domain handler must NOT be invoked when live RBAC permission is revoked")
	}

	var abortedAudits int
	if err := pool.QueryRow(ctx, `
		SELECT COUNT(*) FROM audit_events
		WHERE workspace_id = $1::uuid
		  AND action = 'consumer.aborted:product.created'
	`, durableTestWsA).Scan(&abortedAudits); err != nil {
		t.Fatalf("query aborted audit_events: %v", err)
	}
	if abortedAudits != 1 {
		t.Fatalf("expected 1 aborted audit_events record, got %d", abortedAudits)
	}
}

// TestUnknownExternalEffectBlocksBlindRetryAndUnreachableBrokerFailsClosed verifies:
//  1. An external_effects row in 'unknown' state blocks blind retry with ErrExternalOutcomeUnresolved
//     and leaves the message un-ACKed for reconciliation rather than duplicating external mutations.
//  2. When the shared broker is unreachable, OutboxPoller never marks event_outbox rows published.
func TestUnknownExternalEffectBlocksBlindRetryAndUnreachableBrokerFailsClosed(t *testing.T) {
	pool, dsn := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	const (
		eventID     = "0195f000-0000-7000-8000-000000000104"
		aggregateID = "0195f000-0000-7000-8000-000000000204"
	)

	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		eventID, "product.created", outbox.QueueSearchIndexing,
		"product", aggregateID,
		map[string]any{"product_id": aggregateID, "workspace_id": durableTestWsA},
		map[string]any{"actor_id": durableTestOwnerA, "actor_type": "user", "required_perm": "product:manage"},
	)

	now := time.Now().UTC()

	// Part 1: Unreachable Redis broker must fail closed and NEVER mark event_outbox published.
	unreachableRedis, err := outbox.NewRedisStreamBroker("redis://127.0.0.1:1/0", "")
	if err != nil {
		t.Fatalf("NewRedisStreamBroker: %v", err)
	}
	failingPoller := outbox.NewOutboxPoller("poller-unreachable-broker", outbox.NewPgOutboxStore(pool, false), unreachableRedis)
	res, err := failingPoller.PollOnce(ctx, now)
	if err != nil {
		t.Fatalf("PollOnce with unreachable broker returned unexpected fatal err: %v", err)
	}
	if res.PublishedCount != 0 || res.RetriedCount != 1 {
		t.Fatalf("expected PublishedCount=0 RetriedCount=1 when broker is unreachable, got %+v", res)
	}

	var published bool
	if err := pool.QueryRow(ctx, `SELECT published FROM event_outbox WHERE event_id = $1::uuid`, eventID).Scan(&published); err != nil {
		t.Fatalf("query event_outbox: %v", err)
	}
	if published {
		t.Fatalf("CRITICAL: event_outbox row was falsely marked published while broker was unreachable")
	}

	// Reset next_attempt_at so the healthy poller can claim it immediately.
	if _, err := pool.Exec(ctx, `UPDATE event_outbox SET next_attempt_at = now() - interval '1 minute' WHERE event_id = $1::uuid`, eventID); err != nil {
		t.Fatalf("reset next_attempt_at: %v", err)
	}

	// Part 2: Pre-seed an 'unknown' external_effects row for this event and verify worker blocks blind retry.
	effectKey := fmt.Sprintf("worker:product.created:product:%s:%s", aggregateID, eventID)
	err = tenantdb.WithTx(ctx, pool, tenantdb.Scope{
		WorkspaceID:             durableTestWsA,
		UserID:                  durableTestOwnerA,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		if _, err := q.InsertPreparedExternalEffect(txCtx, tenantdb.PrepareExternalEffectParams{
			EffectID:      "0195f000-0000-7000-8000-000000000304",
			WorkspaceID:   durableTestWsA,
			OperationKey:  effectKey,
			Provider:      "internal_worker",
			AggregateType: "product",
			AggregateID:   aggregateID,
		}); err != nil {
			return err
		}
		_, err := q.UpdateExternalEffectStatus(txCtx, tenantdb.UpdateExternalEffectStatusParams{
			WorkspaceID:       durableTestWsA,
			OperationKey:      effectKey,
			Status:            "unknown",
			ProviderRequestID: "req_timeout_preseeded",
			ResultPayload:     []byte(`{"error":"provider timeout"}`),
		})
		return err
	})
	if err != nil {
		t.Fatalf("seed unknown external_effect: %v", err)
	}

	broker := outbox.NewPgStreamBroker(pool, false)
	healthyPoller := outbox.NewOutboxPoller("poller-healthy", outbox.NewPgOutboxStore(pool, false), broker)
	if _, err := healthyPoller.PollOnce(ctx, time.Now().UTC()); err != nil {
		t.Fatalf("healthy PollOnce: %v", err)
	}

	worker := outbox.NewConsumerWorker(
		outbox.QueueSearchIndexing,
		"worker-main",
		"worker-unknown-effect",
		broker,
		outbox.NewPgConsumerInboxEngine(pool),
	)
	worker.AuthVerifier = outbox.NewPgLiveAuthVerifier(pool)

	_, err = worker.ProcessNext(ctx, time.Now().UTC(), 10, outbox.NewPgDomainActionHandler().Handle)
	if !errors.Is(err, outbox.ErrExternalOutcomeUnresolved) {
		t.Fatalf("expected ErrExternalOutcomeUnresolved for unknown external effect, got %v", err)
	}

	// Verify message remains in PEL (un-ACKed) and consumer_inbox rolled back.
	pending := broker.PendingCount(outbox.QueueSearchIndexing, "worker-main")
	if pending != 1 {
		t.Fatalf("expected PendingCount=1 when external effect is unknown, got %d", pending)
	}
	_ = dsn
}

// TestPgStreamBrokerMultiInstanceUniqueStreamEntryIDsAndSelectiveXAck verifies R1 Issue 6:
// Two separate PgStreamBroker instances publishing different events at the exact same millisecond
// timestamp must allocate globally unique StreamEntryIDs from PostgreSQL, and XAck must acknowledge
// only the targeted entry (failing closed if an unknown StreamEntryID is passed).
func TestPgStreamBrokerMultiInstanceUniqueStreamEntryIDsAndSelectiveXAck(t *testing.T) {
	pool, _ := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	brokerInstance1 := outbox.NewPgStreamBroker(pool, false)
	brokerInstance2 := outbox.NewPgStreamBroker(pool, false)

	sameTimestamp := time.Date(2026, 11, 6, 17, 0, 0, 0, time.UTC)
	const (
		eventID1 = "0195f000-0000-7000-8000-000000000401"
		eventID2 = "0195f000-0000-7000-8000-000000000402"
	)

	entryID1, err := brokerInstance1.XAdd(ctx, outbox.QueueSearchIndexing, outbox.StreamMessage{
		EventID:       eventID1,
		EventType:     "product.created",
		TargetStream:  outbox.QueueSearchIndexing,
		AggregateType: "product",
		AggregateID:   eventID1,
		WorkspaceID:   durableTestWsA,
		ActorID:       durableTestOwnerA,
		ActorType:     "user",
		Payload:       json.RawMessage(`{"product_id":"0195f000-0000-7000-8000-000000000401"}`),
		PublishedAt:   sameTimestamp,
	})
	if err != nil {
		t.Fatalf("brokerInstance1.XAdd: %v", err)
	}

	entryID2, err := brokerInstance2.XAdd(ctx, outbox.QueueSearchIndexing, outbox.StreamMessage{
		EventID:       eventID2,
		EventType:     "product.created",
		TargetStream:  outbox.QueueSearchIndexing,
		AggregateType: "product",
		AggregateID:   eventID2,
		WorkspaceID:   durableTestWsA,
		ActorID:       durableTestOwnerA,
		ActorType:     "user",
		Payload:       json.RawMessage(`{"product_id":"0195f000-0000-7000-8000-000000000402"}`),
		PublishedAt:   sameTimestamp,
	})
	if err != nil {
		t.Fatalf("brokerInstance2.XAdd: %v", err)
	}

	if entryID1 == entryID2 {
		t.Fatalf("CRITICAL: separate PgStreamBroker instances generated colliding StreamEntryID %q", entryID1)
	}

	msgs, err := brokerInstance1.XReadGroup(ctx, outbox.QueueSearchIndexing, "cg-multi-instance", "consumer-1", sameTimestamp, 10)
	if err != nil {
		t.Fatalf("XReadGroup: %v", err)
	}
	if len(msgs) != 2 {
		t.Fatalf("expected 2 messages from XReadGroup, got %d", len(msgs))
	}
	if pending := brokerInstance1.PendingCount(outbox.QueueSearchIndexing, "cg-multi-instance"); pending != 2 {
		t.Fatalf("expected PendingCount=2 before XAck, got %d", pending)
	}

	// Acknowledge only entryID1; entryID2 must remain pending in the PEL.
	if err := brokerInstance2.XAck(ctx, outbox.QueueSearchIndexing, "cg-multi-instance", entryID1); err != nil {
		t.Fatalf("XAck(entryID1) failed: %v", err)
	}
	if pending := brokerInstance1.PendingCount(outbox.QueueSearchIndexing, "cg-multi-instance"); pending != 1 {
		t.Fatalf("expected PendingCount=1 after ACKing only entryID1, got %d", pending)
	}

	// Unknown StreamEntryID must return an error instead of silently succeeding.
	if err := brokerInstance1.XAck(ctx, outbox.QueueSearchIndexing, "cg-multi-instance", "9999999999999-999999"); err == nil {
		t.Fatalf("expected XAck with unknown StreamEntryID to return an error")
	}

	if err := brokerInstance1.XAck(ctx, outbox.QueueSearchIndexing, "cg-multi-instance", entryID2); err != nil {
		t.Fatalf("XAck(entryID2) failed: %v", err)
	}
	if pending := brokerInstance1.PendingCount(outbox.QueueSearchIndexing, "cg-multi-instance"); pending != 0 {
		t.Fatalf("expected PendingCount=0 after ACKing both entries, got %d", pending)
	}
}

type failingTxBeginner struct {
	err error
}

func (f failingTxBeginner) Begin(_ context.Context) (pgx.Tx, error) {
	return nil, f.err
}

// TestLiveAuthInfrastructureErrorPreservesMessageInPELWithoutAck verifies R1 Issue 5:
//  1. When PgLiveAuthVerifier encounters a transient DB/network outage (rather than an actual
//     membership/permission revocation), it returns a non-revocation error and ConsumerWorker
//     leaves the message un-ACKed in the PEL for retry.
//  2. When live auth is genuinely revoked but RecordAbortedAudit fails due to a DB outage,
//     ConsumerWorker does NOT XAck the message until the mandatory aborted audit record is persisted.
func TestLiveAuthInfrastructureErrorPreservesMessageInPELWithoutAck(t *testing.T) {
	pool, _ := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	const (
		eventID     = "0195f000-0000-7000-8000-000000000501"
		aggregateID = "0195f000-0000-7000-8000-000000000502"
	)

	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		eventID, "product.created", outbox.QueueSearchIndexing,
		"product", aggregateID,
		map[string]any{"product_id": aggregateID, "workspace_id": durableTestWsA},
		map[string]any{"actor_id": durableTestOwnerA, "actor_type": "user", "required_perm": "product:manage"},
	)

	now := time.Now().UTC().Truncate(time.Millisecond)
	broker := outbox.NewPgStreamBroker(pool, false)
	poller := outbox.NewOutboxPoller("poller-auth-infra", outbox.NewPgOutboxStore(pool, false), broker)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce: %v", err)
	}

	// Simulate transient database outage in PgLiveAuthVerifier.
	transientDBErr := errors.New("simulated pg connection reset during live auth check")
	brokenVerifier := outbox.NewPgLiveAuthVerifier(failingTxBeginner{err: transientDBErr})
	healthyInbox := outbox.NewPgConsumerInboxEngine(pool)

	worker := outbox.NewConsumerWorker(outbox.QueueSearchIndexing, "worker-main", "worker-infra-err", broker, healthyInbox)
	worker.AuthVerifier = brokenVerifier

	_, err := worker.ProcessNext(ctx, now, 10, outbox.NewPgDomainActionHandler().Handle)
	if !errors.Is(err, transientDBErr) {
		t.Fatalf("expected transientDBErr from ProcessNext, got %v", err)
	}
	if errors.Is(err, outbox.ErrLiveActorAuthorizationRevoked) {
		t.Fatalf("transient DB outage must NOT be classified as ErrLiveActorAuthorizationRevoked")
	}
	if pending := broker.PendingCount(outbox.QueueSearchIndexing, "worker-main"); pending != 1 {
		t.Fatalf("expected PendingCount=1 after transient auth DB error (must not XAck), got %d", pending)
	}

	// Restore healthy PgLiveAuthVerifier, advance clock past 60s idle claim timeout, and verify retry succeeds.
	now = now.Add(65 * time.Second)
	worker.AuthVerifier = outbox.NewPgLiveAuthVerifier(pool)
	outcomes, err := worker.ProcessNext(ctx, now, 10, outbox.NewPgDomainActionHandler().Handle)
	if err != nil {
		t.Fatalf("ProcessNext after DB recovery failed: %v", err)
	}
	if len(outcomes) != 1 || !outcomes[0].Executed || !outcomes[0].Acked {
		t.Fatalf("expected Executed+Acked outcome after recovery, got %+v", outcomes)
	}
	if pending := broker.PendingCount(outbox.QueueSearchIndexing, "worker-main"); pending != 0 {
		t.Fatalf("expected PendingCount=0 after recovery execution, got %d", pending)
	}
}

// TestWorkerFailsClosedWhenNoDomainOrProviderExecutorRegistered verifies R1 Issue 4:
// Messages for unimplemented domain queues or external providers without a registered executor
// must fail closed with ErrNoDomainExecutorRegistered, rolling back consumer_inbox, leaving
// external_effects with 0 succeeded rows, and keeping the message un-ACKed in the PEL.
func TestWorkerFailsClosedWhenNoDomainOrProviderExecutorRegistered(t *testing.T) {
	pool, _ := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	const (
		publishEventID = "0195f000-0000-7000-8000-000000000601"
		publishAggID   = "0195f000-0000-7000-8000-000000000602"
	)

	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		publishEventID, "publish.scheduled", outbox.QueuePublishJobs,
		"publish_job", publishAggID,
		map[string]any{
			"publish_job_id": publishAggID,
			"workspace_id":   durableTestWsA,
			"provider":       "tiktok_shop",
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "publish:schedule",
		},
	)

	now := time.Now().UTC().Truncate(time.Millisecond)
	broker := outbox.NewPgStreamBroker(pool, false)
	poller := outbox.NewOutboxPoller("poller-fail-closed", outbox.NewPgOutboxStore(pool, false), broker)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce: %v", err)
	}

	handler := outbox.NewPgDomainActionHandler()
	worker := outbox.NewConsumerWorker(
		outbox.QueuePublishJobs,
		"worker-main",
		"worker-publish-fail-closed",
		broker,
		outbox.NewPgConsumerInboxEngine(pool),
	)
	worker.AuthVerifier = outbox.NewPgLiveAuthVerifier(pool)

	_, err := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if !errors.Is(err, outbox.ErrNoDomainExecutorRegistered) {
		t.Fatalf("expected ErrNoDomainExecutorRegistered when no publish/provider executor is registered, got %v", err)
	}

	// Verify zero succeeded external_effects, zero consumer_inbox rows, and message still pending in PEL.
	var succeededEffects, inboxRows int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM external_effects WHERE workspace_id = $1::uuid AND status = 'succeeded'`, durableTestWsA).Scan(&succeededEffects); err != nil {
		t.Fatalf("query external_effects: %v", err)
	}
	if succeededEffects != 0 {
		t.Fatalf("CRITICAL: worker falsely marked external_effects succeeded (%d rows) without a domain executor", succeededEffects)
	}
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM consumer_inbox WHERE event_id = $1::uuid`, publishEventID).Scan(&inboxRows); err != nil {
		t.Fatalf("query consumer_inbox: %v", err)
	}
	if inboxRows != 0 {
		t.Fatalf("expected consumer_inbox rollback (0 rows) on missing executor, got %d", inboxRows)
	}
	if pending := broker.PendingCount(outbox.QueuePublishJobs, "worker-main"); pending != 1 {
		t.Fatalf("expected PendingCount=1 when domain executor is missing, got %d", pending)
	}

	// Register an authorized provider executor and verify retry succeeds after idle reclaim window.
	var executorInvoked bool
	handler.RegisterProviderExecutor("tiktok_shop", func(execCtx context.Context, q *tenantdb.Queries, msg outbox.StreamMessage) (outbox.DomainActionResult, error) {
		executorInvoked = true
		if _, err := q.GetWorkspace(execCtx, msg.WorkspaceID); err != nil {
			return outbox.DomainActionResult{}, err
		}
		return outbox.DomainActionResult{
			ProviderRequestID: "tiktok_pub_receipt_601",
			ResultPayload:     json.RawMessage(`{"platform":"tiktok_shop","status":"published"}`),
		}, nil
	})

	now = now.Add(65 * time.Second)
	outcomes, err := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if err != nil {
		t.Fatalf("ProcessNext with registered provider executor failed: %v", err)
	}
	if !executorInvoked || len(outcomes) != 1 || !outcomes[0].Executed || !outcomes[0].Acked {
		t.Fatalf("expected registered executor to run and ACK, got invoked=%v outcomes=%+v", executorInvoked, outcomes)
	}
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM external_effects WHERE workspace_id = $1::uuid AND status = 'succeeded' AND provider_request_id = 'tiktok_pub_receipt_601'`, durableTestWsA).Scan(&succeededEffects); err != nil {
		t.Fatalf("query succeeded external_effects: %v", err)
	}
	if succeededEffects != 1 {
		t.Fatalf("expected 1 succeeded external_effects row with real provider receipt, got %d", succeededEffects)
	}
}

// TestRedisStreamBrokerTLSHandshakeAndCredentialSafeErrors verifies R1 Issue 7:
//  1. Invalid Redis URLs never leak passwords or raw URLs in error messages.
//  2. rediss:// connections perform a TLS 1.2+ handshake BEFORE sending AUTH; if connected to a
//     plaintext TCP listener, AUTH credentials are never transmitted in cleartext.
//  3. rediss:// connections succeed against a valid TLS RESP2 endpoint with AUTH + PING.
func TestRedisStreamBrokerTLSHandshakeAndCredentialSafeErrors(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	const secretPassword = "super_secret_redis_password_do_not_leak_98765"
	badURLs := []string{
		"http://default:" + secretPassword + "@127.0.0.1:6379/0",
		"://default:" + secretPassword + "@127.0.0.1:6379/0",
		"redis://default:" + secretPassword + "@:6379/0",
		"redis://default:" + secretPassword + "@127.0.0.1:99999/0",
		"redis://default:" + secretPassword + "@127.0.0.1:6379/notanumber",
		"rediss://default:" + secretPassword + "@127.0.0.1:6379/0 extra",
	}
	for _, rawURL := range badURLs {
		_, err := outbox.NewRedisStreamBroker(rawURL, "")
		if err == nil {
			t.Fatalf("expected error for invalid redis URL, got nil")
		}
		if strings.Contains(err.Error(), secretPassword) {
			t.Fatalf("CRITICAL: NewRedisStreamBroker leaked secret password in error: %v", err)
		}
	}

	// Part 2: Plaintext TCP listener receiving a rediss:// client must fail in TLS handshake
	// and never receive cleartext AUTH credentials.
	plainLn, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("net.Listen plaintext: %v", err)
	}
	defer plainLn.Close()

	var capturedMu sync.Mutex
	var capturedPlaintext bytes.Buffer
	go func() {
		conn, acceptErr := plainLn.Accept()
		if acceptErr != nil {
			return
		}
		defer conn.Close()
		_ = conn.SetDeadline(time.Now().Add(2 * time.Second))
		buf := make([]byte, 512)
		n, _ := conn.Read(buf)
		capturedMu.Lock()
		capturedPlaintext.Write(buf[:n])
		capturedMu.Unlock()
		_, _ = conn.Write([]byte("-ERR plaintext server\r\n"))
	}()

	redissPlainBroker, err := outbox.NewRedisStreamBroker("rediss://default:"+secretPassword+"@"+plainLn.Addr().String()+"/0", "")
	if err != nil {
		t.Fatalf("NewRedisStreamBroker rediss: %v", err)
	}
	if err := redissPlainBroker.Ping(ctx); err == nil {
		t.Fatalf("expected rediss:// Ping against plaintext TCP listener to fail TLS handshake")
	}
	capturedMu.Lock()
	wireBytes := capturedPlaintext.String()
	capturedMu.Unlock()
	if strings.Contains(wireBytes, secretPassword) || strings.Contains(wireBytes, "AUTH") {
		t.Fatalf("CRITICAL: rediss:// sent cleartext AUTH or password before TLS handshake! wire=%q", wireBytes)
	}

	// Part 3: Valid TLS 1.2+ RESP2 listener with ephemeral certificate verifies TLS handshake + AUTH + PING.
	privKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatalf("rsa.GenerateKey: %v", err)
	}
	certTmpl := &x509.Certificate{
		SerialNumber: big.NewInt(20261106),
		Subject:      pkix.Name{CommonName: "127.0.0.1"},
		NotBefore:    time.Now().Add(-1 * time.Hour),
		NotAfter:     time.Now().Add(24 * time.Hour),
		KeyUsage:     x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
		ExtKeyUsage:  []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		IPAddresses:  []net.IP{net.ParseIP("127.0.0.1")},
	}
	certDER, err := x509.CreateCertificate(rand.Reader, certTmpl, certTmpl, &privKey.PublicKey, privKey)
	if err != nil {
		t.Fatalf("x509.CreateCertificate: %v", err)
	}
	leafCert, err := x509.ParseCertificate(certDER)
	if err != nil {
		t.Fatalf("x509.ParseCertificate: %v", err)
	}
	rootPool := x509.NewCertPool()
	rootPool.AddCert(leafCert)

	serverTLS := &tls.Config{
		MinVersion: tls.VersionTLS12,
		Certificates: []tls.Certificate{
			{
				Certificate: [][]byte{certDER},
				PrivateKey:  privKey,
			},
		},
	}
	tlsLn, err := tls.Listen("tcp", "127.0.0.1:0", serverTLS)
	if err != nil {
		t.Fatalf("tls.Listen: %v", err)
	}
	defer tlsLn.Close()

	go func() {
		for {
			conn, acceptErr := tlsLn.Accept()
			if acceptErr != nil {
				return
			}
			go func(c net.Conn) {
				defer c.Close()
				_ = c.SetDeadline(time.Now().Add(5 * time.Second))
				br := bufio.NewReader(c)
				authed := false
				for {
					line, err := br.ReadString('\n')
					if err != nil {
						return
					}
					line = strings.TrimSpace(line)
					if !strings.HasPrefix(line, "*") {
						return
					}
					var count int
					_, _ = fmt.Sscanf(line, "*%d", &count)
					args := make([]string, 0, count)
					for i := 0; i < count; i++ {
						lenLine, err := br.ReadString('\n')
						if err != nil {
							return
						}
						var argLen int
						_, _ = fmt.Sscanf(strings.TrimSpace(lenLine), "$%d", &argLen)
						buf := make([]byte, argLen+2)
						if _, err := io.ReadFull(br, buf); err != nil {
							return
						}
						args = append(args, string(buf[:argLen]))
					}
					if len(args) == 0 {
						return
					}
					switch strings.ToUpper(args[0]) {
					case "AUTH":
						if len(args) == 2 && args[1] == secretPassword {
							authed = true
							_, _ = c.Write([]byte("+OK\r\n"))
						} else {
							_, _ = c.Write([]byte("-ERR invalid password\r\n"))
						}
					case "PING":
						if !authed {
							_, _ = c.Write([]byte("-NOAUTH Authentication required.\r\n"))
							return
						}
						_, _ = c.Write([]byte("+PONG\r\n"))
						return
					default:
						_, _ = c.Write([]byte("+OK\r\n"))
					}
				}
			}(conn)
		}
	}()

	redissTLSBroker, err := outbox.NewRedisStreamBroker("rediss://default:"+secretPassword+"@"+tlsLn.Addr().String()+"/0", "")
	if err != nil {
		t.Fatalf("NewRedisStreamBroker TLS: %v", err)
	}
	// Without trusting the ephemeral self-signed CA, TLS verification must fail closed.
	if err := redissTLSBroker.Ping(ctx); err == nil {
		t.Fatalf("expected rediss:// Ping with untrusted self-signed cert to fail verification")
	}

	// With RootCAs configured for the test listener, TLS handshake + AUTH + PING must succeed.
	redissTLSBroker.SetTLSConfig(&tls.Config{
		MinVersion: tls.VersionTLS12,
		RootCAs:    rootPool,
		ServerName: "127.0.0.1",
	})
	if err := redissTLSBroker.Ping(ctx); err != nil {
		t.Fatalf("expected rediss:// Ping over verified TLS to succeed, got: %v", err)
	}
}

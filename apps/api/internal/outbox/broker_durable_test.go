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
	"net/http"
	"net/http/httptest"
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

	skipSeed, _ := payload["skip_product_seed"].(bool)
	if aggregateType == "product" && !skipSeed && tenantdb.IsValidNonZeroUUID(aggregateID) {
		title := "Catalog Product " + aggregateID[:8]
		if rawTitle, ok := payload["title"].(string); ok && strings.TrimSpace(rawTitle) != "" {
			title = strings.TrimSpace(rawTitle)
		}
		status := "active"
		if rawStatus, ok := payload["catalog_status"].(string); ok && strings.TrimSpace(rawStatus) != "" {
			status = strings.TrimSpace(rawStatus)
		}
		prodType := "physical"
		if rawType, ok := payload["product_type"].(string); ok && strings.TrimSpace(rawType) != "" {
			prodType = strings.TrimSpace(rawType)
		}
		category := "apparel"
		if rawCat, ok := payload["category"].(string); ok && strings.TrimSpace(rawCat) != "" {
			category = strings.TrimSpace(rawCat)
		}
		basePrice := "250000.000000"
		if rawPrice, ok := payload["base_price"].(string); ok && strings.TrimSpace(rawPrice) != "" {
			basePrice = strings.TrimSpace(rawPrice)
		}
		desc := "Durable catalog test product description"
		if rawDesc, ok := payload["description"].(string); ok && strings.TrimSpace(rawDesc) != "" {
			desc = strings.TrimSpace(rawDesc)
		}
		if _, err := pool.Exec(ctx, `
			INSERT INTO products (
				product_id, workspace_id, product_type, title, description,
				category, base_price, currency, catalog_status, inventory_enabled
			) VALUES (
				$1::uuid, $2::uuid, $3, $4, $5,
				$6, $7::numeric(18,6), 'VND', $8, true
			)
			ON CONFLICT (product_id) DO UPDATE SET
				title = EXCLUDED.title,
				description = EXCLUDED.description,
				category = EXCLUDED.category,
				base_price = EXCLUDED.base_price,
				catalog_status = EXCLUDED.catalog_status
		`, aggregateID, workspaceID, prodType, title, desc, category, basePrice, status); err != nil {
			t.Fatalf("seed product row for outbox event: %v", err)
		}
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

	// Verify malformed CREATIVANTA_REDIS_URL fails closed in both cmd/outbox and cmd/worker
	// without leaking credentials to stdout/stderr.
	const redisSecret = "redis_cli_stderr_secret_token_778899"
	for _, bin := range []struct {
		path   string
		subcmd string
		dbEnv  string
	}{
		{outboxBin, "poll-once", "CREATIVANTA_OUTBOX_DATABASE_URL=" + dsn},
		{workerBin, "run-once", "CREATIVANTA_WORKER_DATABASE_URL=" + dsn},
	} {
		badRedisCmd := exec.CommandContext(ctx, bin.path, bin.subcmd)
		badRedisCmd.Env = append(os.Environ(),
			bin.dbEnv,
			"CREATIVANTA_REDIS_URL=redis://default:"+redisSecret+"@127.0.0.1:6379/\x7f",
		)
		badOut, badErr := badRedisCmd.CombinedOutput()
		if badErr == nil {
			t.Fatalf("expected %s %s with malformed CREATIVANTA_REDIS_URL to fail closed", bin.path, bin.subcmd)
		}
		if strings.Contains(string(badOut), redisSecret) {
			t.Fatalf("CRITICAL: %s %s leaked Redis password to stderr/stdout: %s", bin.path, bin.subcmd, string(badOut))
		}
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

	// Verify the worker process durably indexed the product into the catalog search index
	// and that querying the index under tenant RLS returns the indexed product document.
	indexedDoc, err := outbox.GetCatalogSearchDocument(ctx, pool, durableTestWsA, aggregateID)
	if err != nil {
		t.Fatalf("GetCatalogSearchDocument after worker run-once failed: %v", err)
	}
	if indexedDoc.Title != "Áo Khoác Dù Chống Nước" || indexedDoc.CatalogStatus != "active" || indexedDoc.LastEventID != eventID {
		t.Fatalf("unexpected indexed search document after worker run-once: %+v", indexedDoc)
	}
	searchHits, err := outbox.SearchCatalogProducts(ctx, pool, durableTestWsA, outbox.CatalogSearchQuery{
		Query:         "chống nước",
		CatalogStatus: "active",
	})
	if err != nil || len(searchHits) != 1 || searchHits[0].ProductID != aggregateID {
		t.Fatalf("expected 1 search hit for indexed product, got hits=%+v err=%v", searchHits, err)
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
		"redis://default:" + secretPassword + "@127.0.0.1:6379/\x7f",
		secretPassword + ":1234@127.0.0.1:6379/0",
	}
	for _, rawURL := range badURLs {
		_, err := outbox.NewRedisStreamBroker(rawURL, "")
		if err == nil {
			t.Fatalf("expected error for invalid redis URL, got nil")
		}
		if strings.Contains(err.Error(), secretPassword) {
			t.Fatalf("CRITICAL: NewRedisStreamBroker leaked secret password in error: %v", err)
		}
		_, sharedErr := outbox.OpenSharedStreamBroker(ctx, nil, false, rawURL)
		if sharedErr == nil {
			t.Fatalf("expected error from OpenSharedStreamBroker for invalid redis URL, got nil")
		}
		if strings.Contains(sharedErr.Error(), secretPassword) {
			t.Fatalf("CRITICAL: OpenSharedStreamBroker leaked secret password in error: %v", sharedErr)
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
						if (len(args) == 3 && args[1] == "default" && args[2] == secretPassword) ||
							(len(args) == 2 && args[1] == secretPassword) {
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

// TestRedisStreamBrokerACLUsernamePasswordAndTLS verifies Release F5:
//  1. Redis 6+ / Dragonfly ACL URLs with username:password (both redis:// and rediss://) send
//     3-argument AUTH <username> <password> so named ACL users succeed when default is disabled.
//  2. Password-only URLs (redis://:password@host) send 2-argument AUTH <password>.
//  3. URLs with a username but missing/empty password fail closed without leaking the username.
//  4. Authentication failures never leak either the ACL username or password in error messages.
func TestRedisStreamBrokerACLUsernamePasswordAndTLS(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	const (
		aclUser     = "creativanta_worker_acl_user"
		aclPassword = "acl_secret_password_do_not_leak_445566"
	)

	// Part 1: URLs with username or empty userinfo without non-empty password must fail closed without leaking username.
	for _, invalidACLURL := range []string{
		"redis://" + aclUser + "@127.0.0.1:6379/0",
		"redis://" + aclUser + ":@127.0.0.1:6379/0",
		"redis://:@127.0.0.1:6379/0",
		"rediss://" + aclUser + "@127.0.0.1:6379/0",
		"rediss://" + aclUser + ":@127.0.0.1:6379/0",
		"rediss://:@127.0.0.1:6379/0",
	} {
		_, err := outbox.NewRedisStreamBroker(invalidACLURL, "")
		if err == nil {
			t.Fatalf("expected error for ACL username without password (%s), got nil", invalidACLURL)
		}
		if strings.Contains(err.Error(), aclUser) || strings.Contains(err.Error(), aclPassword) {
			t.Fatalf("CRITICAL: NewRedisStreamBroker leaked ACL credentials in error: %v", err)
		}
	}

	// Part 2: Mock RESP2 server where 'default' user is disabled and only (aclUser, aclPassword)
	// via 3-arg AUTH or password-only via 2-arg AUTH (for legacy :password@ URLs) is tested,
	// plus full XADD / XREADGROUP / XPENDING / XACK / NOPERM redaction.
	var streamMu sync.Mutex
	var storedEnvelope string
	var pendingCount int64
	handleACLConn := func(c net.Conn, allowPasswordOnly bool) {
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
				if len(args) == 3 && args[1] == aclUser && args[2] == aclPassword {
					authed = true
					_, _ = c.Write([]byte("+OK\r\n"))
				} else if allowPasswordOnly && len(args) == 2 && args[1] == aclPassword {
					authed = true
					_, _ = c.Write([]byte("+OK\r\n"))
				} else {
					_, _ = c.Write([]byte("-WRONGPASS invalid username-password pair or user is disabled.\r\n"))
				}
			case "PING":
				if !authed {
					_, _ = c.Write([]byte("-NOAUTH Authentication required.\r\n"))
					return
				}
				_, _ = c.Write([]byte("+PONG\r\n"))
				return
			case "XGROUP":
				_, _ = c.Write([]byte("+OK\r\n"))
				return
			case "XADD":
				if len(args) >= 5 {
					if strings.Contains(args[1], "forbidden_acl_stream") {
						_, _ = c.Write([]byte(fmt.Sprintf("-NOPERM user %s has no permissions to access key with token %s\r\n", aclUser, aclPassword)))
						return
					}
					streamMu.Lock()
					storedEnvelope = args[4]
					pendingCount = 1
					streamMu.Unlock()
				}
				_, _ = c.Write([]byte("$15\r\n1700000000000-1\r\n"))
				return
			case "XREADGROUP":
				streamMu.Lock()
				env := storedEnvelope
				streamMu.Unlock()
				streamName := "creativanta:stream:analytics_events"
				resp := fmt.Sprintf(
					"*1\r\n*2\r\n$%d\r\n%s\r\n*1\r\n*2\r\n$15\r\n1700000000000-1\r\n*2\r\n$8\r\nenvelope\r\n$%d\r\n%s\r\n",
					len(streamName), streamName, len(env), env,
				)
				_, _ = c.Write([]byte(resp))
				return
			case "XPENDING":
				streamMu.Lock()
				pc := pendingCount
				streamMu.Unlock()
				_, _ = c.Write([]byte(fmt.Sprintf("*4\r\n:%d\r\n$-1\r\n$-1\r\n*-1\r\n", pc)))
				return
			case "XACK":
				if len(args) >= 4 && args[3] == "1700000000000-1" {
					streamMu.Lock()
					pendingCount = 0
					streamMu.Unlock()
					_, _ = c.Write([]byte(":1\r\n"))
				} else {
					_, _ = c.Write([]byte(":0\r\n"))
				}
				return
			default:
				_, _ = c.Write([]byte("+OK\r\n"))
			}
		}
	}

	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("net.Listen: %v", err)
	}
	defer ln.Close()

	go func() {
		for {
			conn, acceptErr := ln.Accept()
			if acceptErr != nil {
				return
			}
			go handleACLConn(conn, true)
		}
	}()

	// Valid ACL username:password over redis://
	aclBroker, err := outbox.NewRedisStreamBroker("redis://"+aclUser+":"+aclPassword+"@"+ln.Addr().String()+"/0", "")
	if err != nil {
		t.Fatalf("NewRedisStreamBroker ACL: %v", err)
	}
	if err := aclBroker.Ping(ctx); err != nil {
		t.Fatalf("Release F5 regression: expected Redis ACL AUTH <username> <password> to succeed, got: %v", err)
	}

	// Valid password-only (:password@) over redis://
	pwOnlyBroker, err := outbox.NewRedisStreamBroker("redis://:"+aclPassword+"@"+ln.Addr().String()+"/0", "")
	if err != nil {
		t.Fatalf("NewRedisStreamBroker password-only: %v", err)
	}
	if err := pwOnlyBroker.Ping(ctx); err != nil {
		t.Fatalf("expected password-only Redis AUTH <password> to succeed, got: %v", err)
	}

	// Wrong ACL username or wrong password must fail closed and never leak credentials.
	for _, badCredURL := range []string{
		"redis://wrong_user_" + aclUser + ":" + aclPassword + "@" + ln.Addr().String() + "/0",
		"redis://" + aclUser + ":wrong_pw_" + aclPassword + "@" + ln.Addr().String() + "/0",
	} {
		badBroker, err := outbox.NewRedisStreamBroker(badCredURL, "")
		if err != nil {
			t.Fatalf("NewRedisStreamBroker badCredURL: %v", err)
		}
		pingErr := badBroker.Ping(ctx)
		if pingErr == nil {
			t.Fatalf("expected Ping with invalid ACL credentials to fail")
		}
		if strings.Contains(pingErr.Error(), aclUser) || strings.Contains(pingErr.Error(), aclPassword) {
			t.Fatalf("CRITICAL: Ping error leaked ACL credentials: %v", pingErr)
		}
	}

	// Part 3: Valid ACL username:password over rediss:// (TLS 1.2+).
	privKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatalf("rsa.GenerateKey: %v", err)
	}
	certTmpl := &x509.Certificate{
		SerialNumber: big.NewInt(20261107),
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

	tlsLn, err := tls.Listen("tcp", "127.0.0.1:0", &tls.Config{
		MinVersion: tls.VersionTLS12,
		Certificates: []tls.Certificate{
			{
				Certificate: [][]byte{certDER},
				PrivateKey:  privKey,
			},
		},
	})
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
			go handleACLConn(conn, false)
		}
	}()

	redissACLBroker, err := outbox.NewRedisStreamBroker("rediss://"+aclUser+":"+aclPassword+"@"+tlsLn.Addr().String()+"/0", "")
	if err != nil {
		t.Fatalf("NewRedisStreamBroker rediss ACL: %v", err)
	}
	redissACLBroker.SetTLSConfig(&tls.Config{
		MinVersion: tls.VersionTLS12,
		RootCAs:    rootPool,
		ServerName: "127.0.0.1",
	})
	if err := redissACLBroker.Ping(ctx); err != nil {
		t.Fatalf("expected rediss:// ACL AUTH <username> <password> over TLS 1.2+ to succeed, got: %v", err)
	}

	// Part 4: Verify full XAdd / XReadGroup / PendingCount / XAck and NOPERM error credential redaction over ACL.
	_, nopermErr := aclBroker.XAdd(ctx, outbox.QueueName("forbidden_acl_stream"), outbox.StreamMessage{
		EventID:     "0195f000-0000-7000-8000-000000000991",
		EventType:   "inventory.stock_moved",
		WorkspaceID: durableTestWsA,
		Payload:     json.RawMessage(`{"delta":5}`),
	})
	if nopermErr == nil {
		t.Fatalf("expected NOPERM error from forbidden_acl_stream")
	}
	if strings.Contains(nopermErr.Error(), aclUser) || strings.Contains(nopermErr.Error(), aclPassword) {
		t.Fatalf("CRITICAL: NOPERM error leaked ACL username or password: %v", nopermErr)
	}

	entryID, err := aclBroker.XAdd(ctx, outbox.QueueAnalyticsEvents, outbox.StreamMessage{
		EventID:       "0195f000-0000-7000-8000-000000000992",
		EventType:     "inventory.stock_moved",
		AggregateType: "product_sku",
		AggregateID:   "0195f000-0000-7000-8000-000000000993",
		WorkspaceID:   durableTestWsA,
		Payload:       json.RawMessage(`{"sku_id":"0195f000-0000-7000-8000-000000000993","delta":7}`),
		Metadata:      json.RawMessage(`{"actor_id":"` + durableTestOwnerA + `","actor_type":"user","required_perm":"inventory:adjust"}`),
	})
	if err != nil || entryID != "1700000000000-1" {
		t.Fatalf("expected XAdd over ACL to return 1700000000000-1, got id=%q err=%v", entryID, err)
	}
	readMsgs, err := aclBroker.XReadGroup(ctx, outbox.QueueAnalyticsEvents, "worker-main", "consumer-acl", time.Now().UTC(), 10)
	if err != nil || len(readMsgs) != 1 {
		t.Fatalf("expected 1 message from XReadGroup over ACL, got len=%d err=%v", len(readMsgs), err)
	}
	if readMsgs[0].RequiredPerm != "product:manage" {
		t.Fatalf("expected XReadGroup over ACL to normalize RequiredPerm to product:manage, got %q", readMsgs[0].RequiredPerm)
	}
	if pc := aclBroker.PendingCount(outbox.QueueAnalyticsEvents, "worker-main"); pc != 1 {
		t.Fatalf("expected PendingCount=1 before XAck over ACL, got %d", pc)
	}
	if err := aclBroker.XAck(ctx, outbox.QueueAnalyticsEvents, "worker-main", "9999999999999-999"); err == nil {
		t.Fatalf("expected XAck of unknown entry ID over RedisStreamBroker to return an error")
	}
	if err := aclBroker.XAck(ctx, outbox.QueueAnalyticsEvents, "worker-main", entryID); err != nil {
		t.Fatalf("expected XAck of valid entry ID over ACL to succeed, got: %v", err)
	}
	if pc := aclBroker.PendingCount(outbox.QueueAnalyticsEvents, "worker-main"); pc != 0 {
		t.Fatalf("expected PendingCount=0 after XAck over ACL, got %d", pc)
	}
}

type mockExternalSearchBackend struct {
	mu          sync.Mutex
	docs        map[string]outbox.CatalogSearchDocument
	failUpsert  bool
	staleGetVer string
}

func (m *mockExternalSearchBackend) ProviderName() string {
	return "mock_meilisearch"
}

func (m *mockExternalSearchBackend) UpsertProductDocument(_ context.Context, doc outbox.CatalogSearchDocument) (string, error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if m.failUpsert {
		return "", errors.New("mock meilisearch index unavailable")
	}
	if m.docs == nil {
		m.docs = make(map[string]outbox.CatalogSearchDocument)
	}
	m.docs[doc.WorkspaceID+":"+doc.ProductID] = doc
	return "meili_task_" + doc.DocumentVersion[:12], nil
}

func (m *mockExternalSearchBackend) GetProductDocument(_ context.Context, workspaceID, productID string) (*outbox.CatalogSearchDocument, error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	doc, ok := m.docs[workspaceID+":"+productID]
	if !ok {
		return nil, errors.New("document not found in mock meilisearch")
	}
	if m.staleGetVer != "" {
		doc.DocumentVersion = m.staleGetVer
	}
	return &doc, nil
}

// TestUpdateStockOutboxPolicyAndAuthorizedExecutor verifies Data F3:
//  1. inventory.stock_moved emitted with required_perm="inventory:adjust" on QueueAnalyticsEvents
//     for an active Owner/Editor is NOT misclassified as ErrLiveActorAuthorizationRevoked and
//     is NOT silently dropped/ACKed via consumer.aborted.
//  2. The bound inventory.stock_moved executor verifies the SKU in product_skus and the committed
//     ledger entry in stock_movements under tenant RLS, synchronizes the parent product's durable
//     catalog search index projection, and records a succeeded external_effects row.
//  3. An actor with insufficient permission (e.g. Viewer) IS rejected with ErrLiveActorAuthorizationRevoked,
//     recorded in consumer.aborted audit, and ACKed.
//  4. Unknown/misconfigured permission keys in event metadata return ErrInvalidEventPermissionPolicy
//     (NOT ErrLiveActorAuthorizationRevoked) and do NOT ACK/drop the message from the PEL.
//  5. Missing SKU or missing stock_movements ledger row fails closed without ACKing.
func TestUpdateStockOutboxPolicyAndAuthorizedExecutor(t *testing.T) {
	pool, _ := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	const (
		editorUserID  = "aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeee03"
		viewerUserID  = "aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeee04"
		stockProdID   = "0195f000-0000-7000-8000-000000000701"
		stockSkuID    = "0195f000-0000-7000-8000-000000000702"
		stockLocID    = "0195f000-0000-7000-8000-000000000703"
		stockMoveID   = "0195f000-0000-7000-8000-000000000704"
		stockEventID  = "0195f000-0000-7000-8000-000000000705"
		viewerEventID = "0195f000-0000-7000-8000-000000000706"
		bogusEventID  = "0195f000-0000-7000-8000-000000000707"
		noSkuEventID  = "0195f000-0000-7000-8000-000000000708"
		missingSkuID  = "0195f000-0000-7000-8000-000000000799"
	)

	// Seed editor and viewer members, plus product, SKU, inventory_location, and stock_movements ledger row.
	seedStockSQL := fmt.Sprintf(`
		INSERT INTO users (user_id, clerk_id, email, display_name, status)
		VALUES
			('%s'::uuid, 'clerk_editor_a', 'editor_a@example.com', 'Editor A', 'active'),
			('%s'::uuid, 'clerk_viewer_a', 'viewer_a@example.com', 'Viewer A', 'active')
		ON CONFLICT (user_id) DO NOTHING;

		INSERT INTO workspace_members (workspace_id, user_id, role, status)
		VALUES
			('%s'::uuid, '%s'::uuid, 'editor', 'active'),
			('%s'::uuid, '%s'::uuid, 'viewer', 'active')
		ON CONFLICT (workspace_id, user_id) DO UPDATE SET role = EXCLUDED.role, status = EXCLUDED.status;

		INSERT INTO products (
			product_id, workspace_id, product_type, title, description,
			category, base_price, currency, catalog_status, inventory_enabled
		) VALUES (
			'%s'::uuid, '%s'::uuid, 'physical', 'Micro Thu Âm Không Dây Dual-Channel', 'Micro livestream chống ồn chủ động',
			'audio', 1590000.000000, 'VND', 'active', true
		);

		INSERT INTO product_skus (
			sku_id, workspace_id, product_id, sku_code, stock_quantity, stock_reserved, low_stock_threshold, is_active
		) VALUES (
			'%s'::uuid, '%s'::uuid, '%s'::uuid, 'MIC-DUAL-PRO', 25, 3, 5, true
		);

		INSERT INTO inventory_locations (
			location_id, workspace_id, name, location_type, is_default, status
		) VALUES (
			'%s'::uuid, '%s'::uuid, 'HCM Main Warehouse', 'warehouse', true, 'active'
		);

		INSERT INTO stock_movements (
			movement_id, workspace_id, sku_id, location_id, movement_type, movement_key, quantity, reason
		) VALUES (
			'%s'::uuid, '%s'::uuid, '%s'::uuid, '%s'::uuid, 'adjustment', 'adj:test-stock-move-704', 10, 'restock_batch_01'
		);
	`,
		editorUserID, viewerUserID,
		durableTestWsA, editorUserID,
		durableTestWsA, viewerUserID,
		stockProdID, durableTestWsA,
		stockSkuID, durableTestWsA, stockProdID,
		stockLocID, durableTestWsA,
		stockMoveID, durableTestWsA, stockSkuID, stockLocID,
	)
	if _, err := pool.Exec(ctx, seedStockSQL); err != nil {
		t.Fatalf("seed stock movement test fixtures: %v", err)
	}

	now := time.Now().UTC().Truncate(time.Millisecond)
	verifier := outbox.NewPgLiveAuthVerifier(pool)

	// 1. Both Owner and Editor must pass VerifyActorAndApproval for required_perm="inventory:adjust".
	for _, actorID := range []string{durableTestOwnerA, editorUserID} {
		if err := verifier.VerifyActorAndApproval(ctx, durableTestWsA, actorID, "inventory:adjust", "", now); err != nil {
			t.Fatalf("Data F3 regression: VerifyActorAndApproval rejected valid actor %s for inventory:adjust: %v", actorID, err)
		}
	}

	// 2. Viewer must be denied with ErrLiveActorAuthorizationRevoked.
	viewerErr := verifier.VerifyActorAndApproval(ctx, durableTestWsA, viewerUserID, "inventory:adjust", "", now)
	if !errors.Is(viewerErr, outbox.ErrLiveActorAuthorizationRevoked) {
		t.Fatalf("expected Viewer to fail with ErrLiveActorAuthorizationRevoked, got: %v", viewerErr)
	}

	// 3. Unknown permission policy key must return ErrInvalidEventPermissionPolicy (NOT ErrLiveActorAuthorizationRevoked),
	// including when actorID is a user UUID, "system", or empty.
	for _, act := range []string{durableTestOwnerA, "system", ""} {
		bogusErr := verifier.VerifyActorAndApproval(ctx, durableTestWsA, act, "bogus:unknown_perm_key", "", now)
		if !errors.Is(bogusErr, outbox.ErrInvalidEventPermissionPolicy) {
			t.Fatalf("expected ErrInvalidEventPermissionPolicy for unknown permission key (actor=%q), got: %v", act, bogusErr)
		}
		if errors.Is(bogusErr, outbox.ErrLiveActorAuthorizationRevoked) {
			t.Fatalf("CRITICAL: unknown permission key must NOT wrap ErrLiveActorAuthorizationRevoked")
		}
	}
	// Missing actorID when a valid permission is required must fail closed with ErrLiveActorAuthorizationRevoked.
	if missingActorErr := verifier.VerifyActorAndApproval(ctx, durableTestWsA, "", "inventory:adjust", "", now); !errors.Is(missingActorErr, outbox.ErrLiveActorAuthorizationRevoked) {
		t.Fatalf("expected ErrLiveActorAuthorizationRevoked for empty actorID with required permission, got: %v", missingActorErr)
	}

	// 4. End-to-end outbox poller -> QueueAnalyticsEvents worker execution for valid Editor inventory.stock_moved.
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, editorUserID,
		stockEventID, "inventory.stock_moved", outbox.QueueAnalyticsEvents,
		"product_sku", stockSkuID,
		map[string]any{
			"sku_id":       stockSkuID,
			"workspace_id": durableTestWsA,
			"delta":        10,
			"reason":       "restock_batch_01",
			"new_quantity": 25,
		},
		map[string]any{
			"actor_id":      editorUserID,
			"actor_type":    "user",
			"required_perm": "inventory:adjust",
		},
	)

	store := outbox.NewPgOutboxStore(pool, false)
	broker := outbox.NewPgStreamBroker(pool, false)
	poller := outbox.NewOutboxPoller("poller-f3", store, broker)
	now = time.Now().UTC().Add(1 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce: %v", err)
	}

	// Verify event_outbox payload & metadata were enriched and normalized to canonical schema (domain_event_catalog.md + rbac_permission_matrix.md).
	var enrichedPayloadRaw, enrichedMetaRaw []byte
	if err := pool.QueryRow(ctx, `SELECT payload, metadata FROM event_outbox WHERE event_id = $1::uuid`, stockEventID).Scan(&enrichedPayloadRaw, &enrichedMetaRaw); err != nil {
		t.Fatalf("query enriched event_outbox row: %v", err)
	}
	var enrichedPayload, enrichedMeta map[string]any
	if err := json.Unmarshal(enrichedPayloadRaw, &enrichedPayload); err != nil {
		t.Fatalf("unmarshal enrichedPayload: %v", err)
	}
	if err := json.Unmarshal(enrichedMetaRaw, &enrichedMeta); err != nil {
		t.Fatalf("unmarshal enrichedMeta: %v", err)
	}
	if enrichedMeta["required_perm"] != "product:manage" {
		t.Fatalf("expected event_outbox metadata.required_perm normalized to product:manage, got %v", enrichedMeta["required_perm"])
	}
	if enrichedPayload["movement_id"] != stockMoveID ||
		enrichedPayload["location_id"] != stockLocID ||
		enrichedPayload["movement_type"] != "adjustment" ||
		fmt.Sprintf("%v", enrichedPayload["quantity"]) != "10" {
		t.Fatalf("expected event_outbox payload enriched with canonical movement_id/location_id/movement_type/quantity, got %+v", enrichedPayload)
	}

	inboxEngine := outbox.NewPgConsumerInboxEngine(pool)
	domainHandler := outbox.NewPgDomainActionHandler()
	worker := outbox.NewConsumerWorker(outbox.QueueAnalyticsEvents, "worker-main", "worker-f3", broker, inboxEngine)
	worker.AuthVerifier = verifier

	// Negative check before execution: if inventory.stock_moved executor is unregistered, worker must fail closed
	// with ErrNoDomainExecutorRegistered and keep the message pending in the PEL without ACKing or abort-dropping.
	domainHandler.UnregisterExecutor(outbox.QueueAnalyticsEvents, "inventory.stock_moved")
	unregOutcomes, unregErr := worker.ProcessNext(ctx, now, 10, domainHandler.Handle)
	if !errors.Is(unregErr, outbox.ErrNoDomainExecutorRegistered) {
		t.Fatalf("expected ErrNoDomainExecutorRegistered when inventory.stock_moved executor is unregistered, got outcomes=%+v err=%v", unregOutcomes, unregErr)
	}
	if len(unregOutcomes) != 1 || unregOutcomes[0].Acked || unregOutcomes[0].AbortedAuth || unregOutcomes[0].Executed {
		t.Fatalf("expected unregistered executor to leave message un-ACKed and un-aborted, got %+v", unregOutcomes)
	}
	if pending := broker.PendingCount(outbox.QueueAnalyticsEvents, "worker-main"); pending != 1 {
		t.Fatalf("expected PendingCount=1 when executor is unregistered, got %d", pending)
	}

	// Re-register canonical executor and advance clock past 60s idle claim window so retry executes and ACKs.
	domainHandler = outbox.NewPgDomainActionHandler()
	now = now.Add(65 * time.Second)
	outcomes, err := worker.ProcessNext(ctx, now, 10, domainHandler.Handle)
	if err != nil {
		t.Fatalf("Data F3 regression: worker ProcessNext for inventory.stock_moved failed: %v", err)
	}
	if len(outcomes) != 1 || !outcomes[0].Executed || outcomes[0].AbortedAuth || !outcomes[0].Acked {
		t.Fatalf("expected inventory.stock_moved to execute and ACK, got outcomes=%+v", outcomes)
	}

	var abortedCount, processedCount int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM audit_events WHERE workspace_id = $1::uuid AND action = 'consumer.aborted:inventory.stock_moved'`, durableTestWsA).Scan(&abortedCount); err != nil {
		t.Fatalf("query aborted audit_events: %v", err)
	}
	if abortedCount != 0 {
		t.Fatalf("Data F3 regression: expected 0 consumer.aborted:inventory.stock_moved rows, got %d", abortedCount)
	}
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM audit_events WHERE workspace_id = $1::uuid AND action = 'consumer.processed:inventory.stock_moved'`, durableTestWsA).Scan(&processedCount); err != nil {
		t.Fatalf("query processed audit_events: %v", err)
	}
	if processedCount != 1 {
		t.Fatalf("expected 1 consumer.processed:inventory.stock_moved row, got %d", processedCount)
	}

	// Verify parent product search index was synchronized with the SKU's stock!
	doc, err := outbox.GetCatalogSearchDocument(ctx, pool, durableTestWsA, stockProdID)
	if err != nil {
		t.Fatalf("GetCatalogSearchDocument after inventory.stock_moved failed: %v", err)
	}
	if doc.TotalStock != 25 || doc.ReservedStock != 3 || doc.AvailableStock != 22 || !doc.InStock || doc.LastEventID != stockEventID {
		t.Fatalf("unexpected catalog search document after stock movement: %+v", doc)
	}

	// 5. Negative test: Viewer actor on inventory.stock_moved is aborted, audited, and ACKed.
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, viewerUserID,
		viewerEventID, "inventory.stock_moved", outbox.QueueAnalyticsEvents,
		"product_sku", stockSkuID,
		map[string]any{
			"sku_id":       stockSkuID,
			"workspace_id": durableTestWsA,
			"delta":        5,
			"reason":       "unauthorized_viewer_attempt",
			"new_quantity": 30,
		},
		map[string]any{
			"actor_id":      viewerUserID,
			"actor_type":    "user",
			"required_perm": "inventory:adjust",
		},
	)
	now = now.Add(2 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce viewer event: %v", err)
	}
	viewerOutcomes, err := worker.ProcessNext(ctx, now, 10, domainHandler.Handle)
	if err != nil {
		t.Fatalf("ProcessNext viewer event failed: %v", err)
	}
	if len(viewerOutcomes) != 1 || !viewerOutcomes[0].AbortedAuth || !viewerOutcomes[0].Acked || viewerOutcomes[0].Executed {
		t.Fatalf("expected Viewer inventory.stock_moved to abort and ACK without executing, got %+v", viewerOutcomes)
	}

	// 6. Negative test: Unknown permission policy key must NOT ACK or abort-drop the message!
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		bogusEventID, "inventory.stock_moved", outbox.QueueAnalyticsEvents,
		"product_sku", stockSkuID,
		map[string]any{
			"sku_id":       stockSkuID,
			"workspace_id": durableTestWsA,
			"delta":        10,
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "bogus:nonexistent_permission",
		},
	)
	now = now.Add(2 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce bogus perm event: %v", err)
	}
	bogusOutcomes, err := worker.ProcessNext(ctx, now, 10, domainHandler.Handle)
	if !errors.Is(err, outbox.ErrInvalidEventPermissionPolicy) {
		t.Fatalf("expected ErrInvalidEventPermissionPolicy from ProcessNext, got outcomes=%+v err=%v", bogusOutcomes, err)
	}
	if len(bogusOutcomes) != 1 || bogusOutcomes[0].AbortedAuth || bogusOutcomes[0].Acked {
		t.Fatalf("CRITICAL: unknown permission policy error must leave message un-ACKed, got %+v", bogusOutcomes)
	}
	if pending := broker.PendingCount(outbox.QueueAnalyticsEvents, "worker-main"); pending != 1 {
		t.Fatalf("expected 1 message remaining in PEL after unknown permission policy error, got %d", pending)
	}

	// 7. Negative test: inventory.stock_moved for a nonexistent SKU fails closed without ACKing.
	// First ACK the bogus message so we isolate the missing-SKU test.
	if err := broker.XAck(ctx, outbox.QueueAnalyticsEvents, "worker-main", bogusOutcomes[0].StreamEntryID); err != nil {
		t.Fatalf("XAck bogus message: %v", err)
	}

	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		noSkuEventID, "inventory.stock_moved", outbox.QueueAnalyticsEvents,
		"product_sku", missingSkuID,
		map[string]any{
			"sku_id":       missingSkuID,
			"workspace_id": durableTestWsA,
			"delta":        5,
			"reason":       "missing_sku",
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "inventory:adjust",
		},
	)
	now = now.Add(2 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce missing SKU event: %v", err)
	}
	noSkuOutcomes, err := worker.ProcessNext(ctx, now, 10, domainHandler.Handle)
	if !errors.Is(err, outbox.ErrInventoryMovementNotFound) {
		t.Fatalf("expected ErrInventoryMovementNotFound for missing SKU, got outcomes=%+v err=%v", noSkuOutcomes, err)
	}
	if len(noSkuOutcomes) != 1 || noSkuOutcomes[0].Acked || noSkuOutcomes[0].Executed {
		t.Fatalf("expected missing SKU event to remain un-ACKed and unexecuted, got %+v", noSkuOutcomes)
	}
	if err := broker.XAck(ctx, outbox.QueueAnalyticsEvents, "worker-main", noSkuOutcomes[0].StreamEntryID); err != nil {
		t.Fatalf("XAck missing SKU message: %v", err)
	}

	// 8. Negative test: inventory.stock_moved whose delta mismatches stock_movements.quantity fails closed with ErrInventoryMovementNotFound.
	const mismatchEventID = "0195f000-0000-7000-8000-000000000709"
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		mismatchEventID, "inventory.stock_moved", outbox.QueueAnalyticsEvents,
		"product_sku", stockSkuID,
		map[string]any{
			"sku_id":       stockSkuID,
			"workspace_id": durableTestWsA,
			"delta":        999,
			"reason":       "tampered_delta",
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "inventory:adjust",
		},
	)
	now = now.Add(2 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce mismatch event: %v", err)
	}
	mismatchOutcomes, err := worker.ProcessNext(ctx, now, 10, domainHandler.Handle)
	if !errors.Is(err, outbox.ErrInventoryMovementNotFound) {
		t.Fatalf("expected ErrInventoryMovementNotFound when delta mismatches stock_movements ledger quantity, got outcomes=%+v err=%v", mismatchOutcomes, err)
	}
	if len(mismatchOutcomes) != 1 || mismatchOutcomes[0].Acked || mismatchOutcomes[0].Executed {
		t.Fatalf("expected mismatched delta event to remain un-ACKed, got %+v", mismatchOutcomes)
	}
}

// TestCatalogSearchIndexingRequiresRealProductAndVerifiesDurableIndex verifies Data F4 / Agent F14 / Release F2:
//  1. Enqueueing product.created for a product_id that does NOT exist in PostgreSQL `products`
//     must FAIL CLOSED (0 succeeded external_effects, 0 consumer_inbox rows, message remains in PEL)
//     instead of hashing the payload and marking external_effects succeeded.
//  2. Full catalog search lifecycle (product.created -> product.updated -> product.catalog_status_changed)
//     reads authoritative PostgreSQL product & SKU state, persists the searchable document, verifies
//     read-after-write, enforces tenant RLS isolation, and preserves exact NUMERIC(18,6) money sorting.
//  3. External SearchIndexBackend failure or read-after-write mismatch fails closed without ACKing,
//     and succeeds on retry once the backend returns a verified document.
func TestCatalogSearchIndexingRequiresRealProductAndVerifiesDurableIndex(t *testing.T) {
	pool, _ := setupDisposableOutboxDB(t)
	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	const (
		missingEventID   = "0195f000-0000-7000-8000-000000000711"
		missingProductID = "0195f000-0000-7000-8000-000000000811"
		realProductID    = "0195f000-0000-7000-8000-000000000812"
		realSkuID        = "0195f000-0000-7000-8000-000000000813"
		createEventID    = "0195f000-0000-7000-8000-000000000712"
		updateEventID    = "0195f000-0000-7000-8000-000000000713"
		archiveEventID   = "0195f000-0000-7000-8000-000000000714"
		extEventID       = "0195f000-0000-7000-8000-000000000715"
	)

	// Part 1: Phantom product (not in `products`) must fail closed with ErrSearchIndexTargetNotFound.
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		missingEventID, "product.created", outbox.QueueSearchIndexing,
		"product", missingProductID,
		map[string]any{
			"product_id":        missingProductID,
			"workspace_id":      durableTestWsA,
			"title":             "Nonexistent Phantom Product",
			"skip_product_seed": true,
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "product:manage",
		},
	)

	store := outbox.NewPgOutboxStore(pool, false)
	broker := outbox.NewPgStreamBroker(pool, false)
	poller := outbox.NewOutboxPoller("poller-search-f4", store, broker)
	now := time.Now().UTC().Add(1 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce: %v", err)
	}

	inboxEngine := outbox.NewPgConsumerInboxEngine(pool)
	handler := outbox.NewPgDomainActionHandler()
	worker := outbox.NewConsumerWorker(outbox.QueueSearchIndexing, "worker-main", "worker-search-f4", broker, inboxEngine)
	worker.AuthVerifier = outbox.NewPgLiveAuthVerifier(pool)

	outcomes, err := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if !errors.Is(err, outbox.ErrSearchIndexTargetNotFound) {
		t.Fatalf("Data F4 / Agent F14 / Release F2 regression: expected ErrSearchIndexTargetNotFound for nonexistent product, got outcomes=%+v err=%v", outcomes, err)
	}
	if len(outcomes) != 1 || outcomes[0].Acked || outcomes[0].Executed {
		t.Fatalf("expected phantom product message to remain un-ACKed and unexecuted, got %+v", outcomes)
	}

	var succeededEffects, inboxRows int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM external_effects WHERE workspace_id = $1::uuid AND status = 'succeeded'`, durableTestWsA).Scan(&succeededEffects); err != nil {
		t.Fatalf("count external_effects: %v", err)
	}
	if succeededEffects != 0 {
		t.Fatalf("CRITICAL: phantom product marked %d external_effects rows succeeded", succeededEffects)
	}
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM consumer_inbox WHERE workspace_id = $1::uuid`, durableTestWsA).Scan(&inboxRows); err != nil {
		t.Fatalf("count consumer_inbox: %v", err)
	}
	if inboxRows != 0 {
		t.Fatalf("CRITICAL: phantom product committed %d consumer_inbox rows", inboxRows)
	}
	if pending := broker.PendingCount(outbox.QueueSearchIndexing, "worker-main"); pending != 1 {
		t.Fatalf("expected phantom product message to remain in PEL (PendingCount=1), got %d", pending)
	}

	// Drain the phantom message from PEL so we can test the full Create -> Update -> Archive lifecycle.
	if err := broker.XAck(ctx, outbox.QueueSearchIndexing, "worker-main", outcomes[0].StreamEntryID); err != nil {
		t.Fatalf("XAck phantom message: %v", err)
	}

	// Part 2: Seed a real product + SKU in PostgreSQL. Before the worker runs, it must NOT be in the search index.
	seedProdSQL := fmt.Sprintf(`
		INSERT INTO products (
			product_id, workspace_id, product_type, title, description,
			category, base_price, currency, catalog_status, inventory_enabled
		) VALUES (
			'%s'::uuid, '%s'::uuid, 'physical', 'Máy Ảnh Mirrorless 4K Vlog', 'Quay video 4K 60fps chuyên nghiệp',
			'camera', 18500000.500000, 'VND', 'active', true
		);
		INSERT INTO product_skus (
			sku_id, workspace_id, product_id, sku_code, stock_quantity, stock_reserved, low_stock_threshold, is_active
		) VALUES (
			'%s'::uuid, '%s'::uuid, '%s'::uuid, 'CAM-4K-BLK', 12, 2, 3, true
		);
	`, realProductID, durableTestWsA, realSkuID, durableTestWsA, realProductID)
	if _, err := pool.Exec(ctx, seedProdSQL); err != nil {
		t.Fatalf("seed real product and SKU: %v", err)
	}

	if _, err := outbox.GetCatalogSearchDocument(ctx, pool, durableTestWsA, realProductID); !errors.Is(err, outbox.ErrSearchDocumentNotIndexed) {
		t.Fatalf("expected ErrSearchDocumentNotIndexed before worker runs, got: %v", err)
	}

	// Enqueue & process product.created
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		createEventID, "product.created", outbox.QueueSearchIndexing,
		"product", realProductID,
		map[string]any{
			"product_id":        realProductID,
			"workspace_id":      durableTestWsA,
			"skip_product_seed": true,
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "product:manage",
		},
	)
	now = time.Now().UTC().Add(2 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce product.created: %v", err)
	}
	if _, err := worker.ProcessNext(ctx, now, 10, handler.Handle); err != nil {
		t.Fatalf("ProcessNext product.created: %v", err)
	}

	createdDoc, err := outbox.GetCatalogSearchDocument(ctx, pool, durableTestWsA, realProductID)
	if err != nil {
		t.Fatalf("GetCatalogSearchDocument after product.created: %v", err)
	}
	if createdDoc.Title != "Máy Ảnh Mirrorless 4K Vlog" ||
		createdDoc.CatalogStatus != "active" ||
		createdDoc.BasePrice != "18500000.500000" ||
		createdDoc.TotalStock != 12 ||
		createdDoc.AvailableStock != 10 ||
		len(createdDoc.SKUCodes) != 1 ||
		createdDoc.SKUCodes[0] != "CAM-4K-BLK" {
		t.Fatalf("unexpected indexed document after product.created: %+v", createdDoc)
	}

	// Cross-tenant RLS isolation: Workspace B must NOT see Workspace A's indexed document.
	if _, err := outbox.GetCatalogSearchDocument(ctx, pool, durableTestWsB, realProductID); !errors.Is(err, outbox.ErrSearchIndexTargetNotFound) {
		t.Fatalf("expected cross-tenant GetCatalogSearchDocument to fail with ErrSearchIndexTargetNotFound, got: %v", err)
	}
	wsBHits, err := outbox.SearchCatalogProducts(ctx, pool, durableTestWsB, outbox.CatalogSearchQuery{Query: "mirrorless"})
	if err != nil || len(wsBHits) != 0 {
		t.Fatalf("expected 0 cross-tenant search hits in Workspace B, got hits=%+v err=%v", wsBHits, err)
	}

	// Update product title & price in PostgreSQL, then enqueue & process product.updated.
	if _, err := pool.Exec(ctx, `
		UPDATE products
		SET title = 'Máy Ảnh Mirrorless 8K Cinema Pro', base_price = 24900000.750000
		WHERE workspace_id = $1::uuid AND product_id = $2::uuid
	`, durableTestWsA, realProductID); err != nil {
		t.Fatalf("update product in DB: %v", err)
	}
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		updateEventID, "product.updated", outbox.QueueSearchIndexing,
		"product", realProductID,
		map[string]any{
			"product_id":        realProductID,
			"workspace_id":      durableTestWsA,
			"skip_product_seed": true,
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "product:manage",
		},
	)
	now = time.Now().UTC().Add(3 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce product.updated: %v", err)
	}
	if _, err := worker.ProcessNext(ctx, now, 10, handler.Handle); err != nil {
		t.Fatalf("ProcessNext product.updated: %v", err)
	}

	oldHits, err := outbox.SearchCatalogProducts(ctx, pool, durableTestWsA, outbox.CatalogSearchQuery{Query: "vlog"})
	if err != nil || len(oldHits) != 0 {
		t.Fatalf("expected 0 hits for replaced title token 'vlog', got %+v (err=%v)", oldHits, err)
	}
	newHits, err := outbox.SearchCatalogProducts(ctx, pool, durableTestWsA, outbox.CatalogSearchQuery{
		Query:         "8k cinema cam-4k-blk",
		CatalogStatus: "active",
	})
	if err != nil || len(newHits) != 1 || newHits[0].BasePrice != "24900000.750000" {
		t.Fatalf("expected 1 updated search hit with BasePrice=24900000.750000, got %+v (err=%v)", newHits, err)
	}

	// Archive product in PostgreSQL, then enqueue & process product.catalog_status_changed.
	if _, err := pool.Exec(ctx, `
		UPDATE products
		SET catalog_status = 'archived'
		WHERE workspace_id = $1::uuid AND product_id = $2::uuid
	`, durableTestWsA, realProductID); err != nil {
		t.Fatalf("archive product in DB: %v", err)
	}
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		archiveEventID, "product.catalog_status_changed", outbox.QueueSearchIndexing,
		"product", realProductID,
		map[string]any{
			"product_id":        realProductID,
			"workspace_id":      durableTestWsA,
			"from":              "active",
			"to":                "archived",
			"catalog_status":    "archived",
			"skip_product_seed": true,
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "product:manage",
		},
	)
	now = time.Now().UTC().Add(4 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce product.catalog_status_changed: %v", err)
	}
	if _, err := worker.ProcessNext(ctx, now, 10, handler.Handle); err != nil {
		t.Fatalf("ProcessNext product.catalog_status_changed: %v", err)
	}

	activeHits, err := outbox.SearchCatalogProducts(ctx, pool, durableTestWsA, outbox.CatalogSearchQuery{CatalogStatus: "active"})
	if err != nil || len(activeHits) != 0 {
		t.Fatalf("expected 0 active search hits after archive, got %+v (err=%v)", activeHits, err)
	}
	archivedHits, err := outbox.SearchCatalogProducts(ctx, pool, durableTestWsA, outbox.CatalogSearchQuery{CatalogStatus: "archived"})
	if err != nil || len(archivedHits) != 1 || archivedHits[0].CatalogStatus != "archived" {
		t.Fatalf("expected 1 archived search hit after archive, got %+v (err=%v)", archivedHits, err)
	}

	// Part 3: External SearchIndexBackend failure / verification mismatch must fail closed without ACKing,
	// then succeed on retry when the backend returns a verified document.
	mockBackend := &mockExternalSearchBackend{
		staleGetVer: "stale_version_mismatch_0000",
	}
	handler.SetSearchIndexBackend(mockBackend)

	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		extEventID, "product.updated", outbox.QueueSearchIndexing,
		"product", realProductID,
		map[string]any{
			"product_id":        realProductID,
			"workspace_id":      durableTestWsA,
			"skip_product_seed": true,
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "product:manage",
		},
	)
	now = time.Now().UTC().Add(5 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce extEventID: %v", err)
	}
	extOutcomes, err := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if !errors.Is(err, outbox.ErrSearchIndexVerificationFailed) {
		t.Fatalf("expected ErrSearchIndexVerificationFailed when external backend returns stale version, got outcomes=%+v err=%v", extOutcomes, err)
	}
	if len(extOutcomes) != 1 || extOutcomes[0].Acked || extOutcomes[0].Executed {
		t.Fatalf("expected unverified external backend indexing to remain un-ACKed, got %+v", extOutcomes)
	}
	if pending := broker.PendingCount(outbox.QueueSearchIndexing, "worker-main"); pending != 1 {
		t.Fatalf("expected PendingCount=1 after external backend verification failure, got %d", pending)
	}

	// Fix the mock backend and advance clock past idle claim timeout to verify retry succeeds and ACKs.
	mockBackend.mu.Lock()
	mockBackend.staleGetVer = ""
	mockBackend.mu.Unlock()
	now = now.Add(65 * time.Second)

	retryOutcomes, err := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if err != nil {
		t.Fatalf("expected retry with healthy external SearchIndexBackend to succeed, got: %v", err)
	}
	if len(retryOutcomes) != 1 || !retryOutcomes[0].Executed || !retryOutcomes[0].Acked {
		t.Fatalf("expected retry outcome Executed+Acked, got %+v", retryOutcomes)
	}
	if pending := broker.PendingCount(outbox.QueueSearchIndexing, "worker-main"); pending != 0 {
		t.Fatalf("expected PendingCount=0 after successful retry, got %d", pending)
	}

	// Part 4: Real HTTP MeilisearchIndexBackend adapter verification (Release F2 / Data F4):
	//  - Invalid URLs with embedded userinfo or bad schemes fail closed without leaking secrets.
	//  - When RequireExternalSearchBackend is true and no backend is set, worker fails closed with
	//    ErrNoDomainExecutorRegistered and keeps message pending in PEL.
	//  - HTTP 401/500 or cross-tenant workspace_id mismatch from Meilisearch fails closed with
	//    ErrSearchIndexVerificationFailed without leaking the API key.
	//  - Valid Meilisearch HTTP upsert + read-after-write verification succeeds, records the task receipt,
	//    and supports Vietnamese/English synonym search ("sản phẩm" <-> "product").
	const meiliSecretKey = "meili_master_secret_api_key_do_not_leak_998877"
	for _, badMeiliURL := range []string{
		"",
		"ftp://127.0.0.1:7700",
		"http://admin:" + meiliSecretKey + "@127.0.0.1:7700",
		"https://:7700",
		"http://127.0.0.1:99999",
	} {
		_, mErr := outbox.NewMeilisearchIndexBackend(badMeiliURL, meiliSecretKey, "")
		if mErr == nil {
			t.Fatalf("expected error for invalid Meilisearch URL %q", badMeiliURL)
		}
		if strings.Contains(mErr.Error(), meiliSecretKey) {
			t.Fatalf("CRITICAL: NewMeilisearchIndexBackend leaked secret in error: %v", mErr)
		}
	}

	var meiliMu sync.Mutex
	meiliStore := make(map[string]outbox.CatalogSearchDocument)
	meiliForceStatus := http.StatusAccepted
	meiliTamperWorkspace := ""

	meiliServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("Authorization") != "Bearer "+meiliSecretKey {
			w.WriteHeader(http.StatusUnauthorized)
			_, _ = w.Write([]byte(`{"message":"The provided API key is invalid."}`))
			return
		}
		meiliMu.Lock()
		forceStatus := meiliForceStatus
		tamperWs := meiliTamperWorkspace
		meiliMu.Unlock()

		if forceStatus >= 400 {
			w.WriteHeader(forceStatus)
			_, _ = w.Write([]byte(`{"message":"simulated meilisearch failure"}`))
			return
		}

		switch r.Method {
		case http.MethodPost:
			var docs []outbox.CatalogSearchDocument
			if err := json.NewDecoder(r.Body).Decode(&docs); err != nil || len(docs) == 0 {
				w.WriteHeader(http.StatusBadRequest)
				return
			}
			meiliMu.Lock()
			for _, d := range docs {
				meiliStore[d.ProductID] = d
			}
			meiliMu.Unlock()
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusAccepted)
			_, _ = w.Write([]byte(`{"taskUid":4201,"indexUid":"creativanta_products","status":"enqueued"}`))
		case http.MethodGet:
			parts := strings.Split(strings.Trim(r.URL.Path, "/"), "/")
			docID := parts[len(parts)-1]
			meiliMu.Lock()
			doc, ok := meiliStore[docID]
			meiliMu.Unlock()
			if !ok {
				w.WriteHeader(http.StatusNotFound)
				return
			}
			if tamperWs != "" {
				doc.WorkspaceID = tamperWs
			}
			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(doc)
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}))
	defer meiliServer.Close()

	// Update product title to include Vietnamese term "Sản phẩm đơn hàng" and test synonym search + Meilisearch HTTP backend.
	if _, err := pool.Exec(ctx, `
		UPDATE products
		SET title = 'Sản phẩm Máy Ảnh Đơn Hàng Pro', catalog_status = 'active'
		WHERE workspace_id = $1::uuid AND product_id = $2::uuid
	`, durableTestWsA, realProductID); err != nil {
		t.Fatalf("update product for Meilisearch test: %v", err)
	}

	const meiliEventID = "0195f000-0000-7000-8000-000000000716"
	enqueueTenantOutboxEvent(
		t, ctx, pool,
		durableTestWsA, durableTestOwnerA,
		meiliEventID, "product.updated", outbox.QueueSearchIndexing,
		"product", realProductID,
		map[string]any{
			"product_id":        realProductID,
			"workspace_id":      durableTestWsA,
			"skip_product_seed": true,
		},
		map[string]any{
			"actor_id":      durableTestOwnerA,
			"actor_type":    "user",
			"required_perm": "product:manage",
		},
	)
	now = now.Add(5 * time.Second)
	if _, err := poller.PollOnce(ctx, now); err != nil {
		t.Fatalf("PollOnce meiliEventID: %v", err)
	}

	// 4a. RequireExternalSearchBackend=true with nil backend must fail closed with ErrNoDomainExecutorRegistered.
	handler.SetSearchIndexBackend(nil)
	handler.SetRequireExternalSearchBackend(true)
	noBackendOutcomes, err := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if !errors.Is(err, outbox.ErrNoDomainExecutorRegistered) {
		t.Fatalf("expected ErrNoDomainExecutorRegistered when external search backend is required but nil, got outcomes=%+v err=%v", noBackendOutcomes, err)
	}
	if len(noBackendOutcomes) != 1 || noBackendOutcomes[0].Acked || noBackendOutcomes[0].Executed {
		t.Fatalf("expected message to remain un-ACKed when required external search backend is missing, got %+v", noBackendOutcomes)
	}

	// 4b. Configure real MeilisearchIndexBackend with wrong API key -> fails closed with HTTP 401 and no secret leak.
	badKeyBackend, err := outbox.NewMeilisearchIndexBackend(meiliServer.URL, "wrong_"+meiliSecretKey, "")
	if err != nil {
		t.Fatalf("NewMeilisearchIndexBackend: %v", err)
	}
	handler.SetSearchIndexBackend(badKeyBackend)
	now = now.Add(65 * time.Second)
	_, badKeyErr := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if !errors.Is(badKeyErr, outbox.ErrSearchIndexVerificationFailed) {
		t.Fatalf("expected ErrSearchIndexVerificationFailed on Meilisearch 401, got: %v", badKeyErr)
	}
	if strings.Contains(badKeyErr.Error(), meiliSecretKey) {
		t.Fatalf("CRITICAL: Meilisearch error leaked API key: %v", badKeyErr)
	}

	// 4c. Configure valid API key, but simulate cross-tenant workspace_id tamper on Meilisearch readback -> fails closed.
	goodMeiliBackend, err := outbox.NewMeilisearchIndexBackend(meiliServer.URL, meiliSecretKey, "")
	if err != nil {
		t.Fatalf("NewMeilisearchIndexBackend valid: %v", err)
	}
	handler.SetSearchIndexBackend(goodMeiliBackend)
	meiliMu.Lock()
	meiliTamperWorkspace = durableTestWsB
	meiliMu.Unlock()

	now = now.Add(65 * time.Second)
	_, tamperErr := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if !errors.Is(tamperErr, outbox.ErrSearchIndexVerificationFailed) {
		t.Fatalf("expected ErrSearchIndexVerificationFailed on cross-tenant Meilisearch document mismatch, got: %v", tamperErr)
	}

	// 4d. Restore valid tenant workspace on Meilisearch server -> retry succeeds, verifies read-after-write, and ACKs.
	meiliMu.Lock()
	meiliTamperWorkspace = ""
	meiliMu.Unlock()

	now = now.Add(65 * time.Second)
	meiliOutcomes, err := worker.ProcessNext(ctx, now, 10, handler.Handle)
	if err != nil {
		t.Fatalf("expected ProcessNext with healthy MeilisearchIndexBackend to succeed, got: %v", err)
	}
	if len(meiliOutcomes) != 1 || !meiliOutcomes[0].Executed || !meiliOutcomes[0].Acked {
		t.Fatalf("expected Executed+Acked with MeilisearchIndexBackend, got %+v", meiliOutcomes)
	}

	// Verify Vietnamese <-> English synonym search ("product" and "order" match "Sản phẩm ... Đơn Hàng").
	for _, synQuery := range []string{"product", "hàng hóa", "order", "hoá đơn", "sản phẩm"} {
		synHits, synErr := outbox.SearchCatalogProducts(ctx, pool, durableTestWsA, outbox.CatalogSearchQuery{
			Query:         synQuery,
			CatalogStatus: "active",
		})
		if synErr != nil || len(synHits) != 1 || synHits[0].ProductID != realProductID {
			t.Fatalf("expected Vietnamese/English synonym query %q to match indexed product, got hits=%+v err=%v", synQuery, synHits, synErr)
		}
	}
}

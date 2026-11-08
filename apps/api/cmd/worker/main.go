// Command worker runs the Creativanta background queue & consumer inbox worker (P0-05)
// backed by PostgreSQL consumer_inbox deduplication, live actor/approval verification,
// and a shared recoverable StreamBroker.
// It fails closed (exit code 2) when invoked without a subcommand or CREATIVANTA_WORKER_DATABASE_URL,
// and exits 1 if PostgreSQL or the shared broker is unreachable.
package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
)

func main() {
	args := os.Args[1:]
	dbURL := strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_DATABASE_URL"))
	if len(args) == 0 || dbURL == "" {
		slog.Error("worker: unconfigured invocation not implemented; require subcommand (list-queues|run-once|run) and CREATIVANTA_WORKER_DATABASE_URL")
		os.Exit(2)
	}

	subcmd := args[0]
	switch subcmd {
	case "list-queues":
		for _, spec := range outbox.AllQueueSpecs() {
			fmt.Printf("queue=%s concurrency=%d timeout=%s max_retries=%d\n",
				spec.Name, spec.WorkerConcurrency, spec.JobTimeout, spec.MaxRetries)
		}
		return
	case "run-once", "run":
	default:
		slog.Error("worker: unknown subcommand not implemented", "subcommand", subcmd)
		os.Exit(2)
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	pool, err := pgxpool.New(ctx, dbURL)
	if err != nil {
		slog.Error("worker: invalid database pool configuration")
		os.Exit(1)
	}
	defer pool.Close()

	pingCtx, cancelPing := context.WithTimeout(ctx, 5*time.Second)
	if err := pool.Ping(pingCtx); err != nil {
		cancelPing()
		slog.Error("worker: database connectivity check failed", "error", err)
		os.Exit(1)
	}
	cancelPing()

	setRole := !strings.EqualFold(strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_BROKER_SET_ROLE")), "false")
	broker, err := outbox.OpenSharedStreamBroker(ctx, pool, setRole, os.Getenv("CREATIVANTA_REDIS_URL"))
	if err != nil {
		slog.Error("worker: shared durable stream broker initialization failed", "error", err)
		os.Exit(1)
	}

	engine := outbox.NewPgConsumerInboxEngine(pool)
	authVerifier := outbox.NewPgLiveAuthVerifier(pool)
	domainHandler := outbox.NewPgDomainActionHandler()

	if strings.EqualFold(strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_REQUIRE_EXTERNAL_SEARCH")), "true") {
		domainHandler.SetRequireExternalSearchBackend(true)
	}
	searchURL := strings.TrimSpace(os.Getenv("CREATIVANTA_MEILISEARCH_URL"))
	if searchURL == "" {
		searchURL = strings.TrimSpace(os.Getenv("CREATIVANTA_SEARCH_BACKEND_URL"))
	}
	if searchURL != "" {
		searchAPIKey := strings.TrimSpace(os.Getenv("CREATIVANTA_MEILISEARCH_API_KEY"))
		if searchAPIKey == "" {
			searchAPIKey = strings.TrimSpace(os.Getenv("CREATIVANTA_SEARCH_BACKEND_API_KEY"))
		}
		searchIndex := strings.TrimSpace(os.Getenv("CREATIVANTA_MEILISEARCH_INDEX"))
		meiliBackend, mErr := outbox.NewMeilisearchIndexBackend(searchURL, searchAPIKey, searchIndex)
		if mErr != nil {
			slog.Error("worker: search index backend configuration invalid", "error", mErr)
			os.Exit(1)
		}
		domainHandler.SetSearchIndexBackend(meiliBackend)
	}

	groupName := strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_GROUP"))
	if groupName == "" {
		groupName = "cg_worker_default"
	}
	consumerID := strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_ID"))
	if consumerID == "" {
		consumerID = "worker-1"
	}
	idleTimeout := outbox.DefaultConsumerIdleClaimTimeout
	if rawIdle := strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_IDLE_TIMEOUT")); rawIdle != "" {
		if d, dErr := time.ParseDuration(rawIdle); dErr == nil && d > 0 {
			idleTimeout = d
		}
	}

	var queues []outbox.QueueName
	if qFilter := strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_QUEUE")); qFilter != "" {
		qName := outbox.QueueName(qFilter)
		if _, ok := outbox.GetQueueSpec(qName); !ok {
			slog.Error("worker: unknown queue in CREATIVANTA_WORKER_QUEUE", "queue", qFilter)
			os.Exit(2)
		}
		queues = []outbox.QueueName{qName}
	} else {
		for _, spec := range outbox.AllQueueSpecs() {
			queues = append(queues, spec.Name)
		}
	}

	runPass := func(passNow time.Time) (int, int, int, int, error) {
		var totalProcessed, totalExecuted, totalDeduplicated, totalAborted int
		for _, qName := range queues {
			w := outbox.NewConsumerWorker(qName, groupName, consumerID, broker, engine)
			w.AuthVerifier = authVerifier
			w.IdleTimeout = idleTimeout
			if strings.EqualFold(strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_FAULT_BEFORE_COMMIT")), "true") {
				w.Faults.BeforeTxCommit = func(msg outbox.StreamMessage) error {
					return errors.New("worker: simulated crash before consumer DB commit")
				}
			}
			if strings.EqualFold(strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_FAULT_AFTER_COMMIT_BEFORE_ACK")), "true") {
				w.Faults.AfterTxCommitBeforeAck = func(msg outbox.StreamMessage) error {
					return errors.New("worker: simulated crash after consumer DB commit before XACK")
				}
			}

			outcomes, err := w.ProcessNext(ctx, passNow, 10, domainHandler.Handle)
			for _, o := range outcomes {
				totalProcessed++
				if o.Executed {
					totalExecuted++
				}
				if o.Deduplicated {
					totalDeduplicated++
				}
				if o.AbortedAuth {
					totalAborted++
				}
			}
			if err != nil {
				return totalProcessed, totalExecuted, totalDeduplicated, totalAborted, err
			}
		}
		return totalProcessed, totalExecuted, totalDeduplicated, totalAborted, nil
	}

	now := time.Now().UTC()
	if rawNow := strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_NOW_RFC3339")); rawNow != "" {
		if parsed, parseErr := time.Parse(time.RFC3339Nano, rawNow); parseErr == nil {
			now = parsed.UTC()
		}
	}

	switch subcmd {
	case "run-once":
		processed, executed, dedup, aborted, err := runPass(now)
		if err != nil {
			slog.Error("worker: run-once failed",
				"processed_count", processed,
				"executed_count", executed,
				"deduplicated_count", dedup,
				"aborted_auth_count", aborted,
				"error", err,
			)
			os.Exit(1)
		}
		slog.Info("worker: run-once completed",
			"consumer_id", consumerID,
			"group", groupName,
			"processed_count", processed,
			"executed_count", executed,
			"deduplicated_count", dedup,
			"aborted_auth_count", aborted,
		)
	case "run":
		interval := 500 * time.Millisecond
		if ms, convErr := strconv.Atoi(strings.TrimSpace(os.Getenv("CREATIVANTA_WORKER_POLL_INTERVAL_MS"))); convErr == nil && ms > 0 {
			interval = time.Duration(ms) * time.Millisecond
		}
		if _, _, _, _, err := runPass(time.Now().UTC()); err != nil {
			slog.Warn("worker: initial pass error", "error", err)
		}
		ticker := time.NewTicker(interval)
		defer ticker.Stop()
		for {
			select {
			case <-ctx.Done():
				return
			case tickNow := <-ticker.C:
				if _, _, _, _, err := runPass(tickNow.UTC()); err != nil {
					slog.Warn("worker: pass error", "error", err)
				}
			}
		}
	}
}

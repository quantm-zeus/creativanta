// Command outbox runs the Creativanta transactional outbox poller (P0-05) using the dedicated outbox_poller role
// and a shared recoverable StreamBroker (PgStreamBroker or RedisStreamBroker).
// It fails closed (exit code 2) when invoked without a subcommand or CREATIVANTA_OUTBOX_DATABASE_URL,
// and exits 1 if the database or shared broker is unreachable.
package main

import (
	"context"
	"errors"
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
	dbURL := strings.TrimSpace(os.Getenv("CREATIVANTA_OUTBOX_DATABASE_URL"))
	if len(args) == 0 || dbURL == "" {
		slog.Error("outbox: unconfigured invocation not implemented; require subcommand (poll-once|run) and CREATIVANTA_OUTBOX_DATABASE_URL")
		os.Exit(2)
	}

	subcmd := args[0]
	if subcmd != "poll-once" && subcmd != "run" {
		slog.Error("outbox: unknown subcommand not implemented", "subcommand", subcmd)
		os.Exit(2)
	}

	pollerID := strings.TrimSpace(os.Getenv("CREATIVANTA_OUTBOX_POLLER_ID"))
	if pollerID == "" {
		pollerID = "outbox-poller-1"
	}
	setRole := !strings.EqualFold(strings.TrimSpace(os.Getenv("CREATIVANTA_OUTBOX_SET_ROLE")), "false")

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	pool, err := pgxpool.New(ctx, dbURL)
	if err != nil {
		slog.Error("outbox: invalid database pool configuration")
		os.Exit(1)
	}
	defer pool.Close()

	pingCtx, cancelPing := context.WithTimeout(ctx, 5*time.Second)
	if err := pool.Ping(pingCtx); err != nil {
		cancelPing()
		slog.Error("outbox: database connectivity check failed", "error", err)
		os.Exit(1)
	}
	cancelPing()

	broker, err := outbox.OpenSharedStreamBroker(ctx, pool, setRole, os.Getenv("CREATIVANTA_REDIS_URL"))
	if err != nil {
		slog.Error("outbox: shared durable stream broker initialization failed", "error", err)
		os.Exit(1)
	}

	store := outbox.NewPgOutboxStore(pool, setRole)
	poller := outbox.NewOutboxPoller(pollerID, store, broker)
	if strings.EqualFold(strings.TrimSpace(os.Getenv("CREATIVANTA_OUTBOX_FAULT_AFTER_PUBLISH_BEFORE_MARK")), "true") {
		poller.Faults.AfterPublishBeforeMarkSaved = func(row outbox.OutboxRow, streamEntryID string) error {
			return errors.New("outbox: simulated process crash after broker XADD before MarkPublished")
		}
	}

	now := time.Now().UTC()
	if rawNow := strings.TrimSpace(os.Getenv("CREATIVANTA_OUTBOX_NOW_RFC3339")); rawNow != "" {
		if parsed, parseErr := time.Parse(time.RFC3339Nano, rawNow); parseErr == nil {
			now = parsed.UTC()
		}
	}

	switch subcmd {
	case "poll-once":
		res, err := poller.PollOnce(ctx, now)
		if err != nil {
			slog.Error("outbox: poll-once failed", "error", err)
			os.Exit(1)
		}
		slog.Info("outbox: poll-once completed",
			"poller_id", pollerID,
			"claimed", res.ClaimedCount,
			"published", res.PublishedCount,
			"retried", res.RetriedCount,
		)
	case "run":
		interval := 500 * time.Millisecond
		if ms, convErr := strconv.Atoi(strings.TrimSpace(os.Getenv("CREATIVANTA_OUTBOX_POLL_INTERVAL_MS"))); convErr == nil && ms > 0 {
			interval = time.Duration(ms) * time.Millisecond
		}
		if _, err := poller.PollOnce(ctx, time.Now().UTC()); err != nil {
			slog.Warn("outbox: initial poll iteration error", "error", err)
		}
		ticker := time.NewTicker(interval)
		defer ticker.Stop()
		for {
			select {
			case <-ctx.Done():
				return
			case tickNow := <-ticker.C:
				if _, err := poller.PollOnce(ctx, tickNow.UTC()); err != nil {
					slog.Warn("outbox: poll iteration error", "error", err)
				}
			}
		}
	}
}

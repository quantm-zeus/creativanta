// Command outbox runs the Creativanta transactional outbox poller (P0-05) using the dedicated outbox_poller role.
// It fails closed (exit code 2) when invoked without a subcommand or CREATIVANTA_OUTBOX_DATABASE_URL.
package main

import (
	"context"
	"log/slog"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
)

func main() {
	args := os.Args[1:]
	dbURL := os.Getenv("CREATIVANTA_OUTBOX_DATABASE_URL")
	if len(args) == 0 || dbURL == "" {
		slog.Error("outbox: unconfigured invocation not implemented; require subcommand (poll-once|run) and CREATIVANTA_OUTBOX_DATABASE_URL")
		os.Exit(2)
	}

	subcmd := args[0]
	pollerID := os.Getenv("CREATIVANTA_OUTBOX_POLLER_ID")
	if pollerID == "" {
		pollerID = "outbox-poller-1"
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	pool, err := pgxpool.New(ctx, dbURL)
	if err != nil {
		slog.Error("outbox: database pool configuration failed", "error", err)
		os.Exit(1)
	}
	defer pool.Close()

	store := outbox.NewPgOutboxStore(pool, true)
	broker := outbox.NewMemoryStreamBroker()
	poller := outbox.NewOutboxPoller(pollerID, store, broker)

	switch subcmd {
	case "poll-once":
		res, err := poller.PollOnce(ctx, time.Now().UTC())
		if err != nil {
			slog.Error("outbox: poll-once failed", "error", err)
			os.Exit(1)
		}
		slog.Info("outbox: poll-once completed",
			"claimed", res.ClaimedCount,
			"published", res.PublishedCount,
			"retried", res.RetriedCount,
		)
	case "run":
		ticker := time.NewTicker(500 * time.Millisecond)
		defer ticker.Stop()
		for {
			select {
			case <-ctx.Done():
				return
			case now := <-ticker.C:
				if _, err := poller.PollOnce(ctx, now.UTC()); err != nil {
					slog.Warn("outbox: poll iteration error", "error", err)
				}
			}
		}
	default:
		slog.Error("outbox: unknown subcommand not implemented", "subcommand", subcmd)
		os.Exit(2)
	}
}

// Command worker runs the Creativanta background queue & consumer inbox worker (P0-05).
// It fails closed (exit code 2) when invoked without a subcommand or CREATIVANTA_WORKER_DATABASE_URL.
package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
)

func main() {
	args := os.Args[1:]
	dbURL := os.Getenv("CREATIVANTA_WORKER_DATABASE_URL")
	if len(args) == 0 || dbURL == "" {
		slog.Error("worker: unconfigured invocation not implemented; require subcommand (list-queues|run-once) and CREATIVANTA_WORKER_DATABASE_URL")
		os.Exit(2)
	}

	subcmd := args[0]
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	switch subcmd {
	case "list-queues":
		for _, spec := range outbox.AllQueueSpecs() {
			fmt.Printf("queue=%s concurrency=%d timeout=%s max_retries=%d\n",
				spec.Name, spec.WorkerConcurrency, spec.JobTimeout, spec.MaxRetries)
		}
	case "run-once":
		broker := outbox.NewMemoryStreamBroker()
		engine := outbox.NewMemoryConsumerInboxEngine()
		w := outbox.NewConsumerWorker(outbox.QueuePublishJobs, "cg_publish_default", "worker-1", broker, engine)
		outcomes, err := w.ProcessNext(ctx, time.Now().UTC(), 10, func(ctx context.Context, msg outbox.StreamMessage) error {
			return nil
		})
		if err != nil {
			slog.Error("worker: run-once failed", "error", err)
			os.Exit(1)
		}
		slog.Info("worker: run-once completed", "processed_count", len(outcomes))
	default:
		slog.Error("worker: unknown subcommand not implemented", "subcommand", subcmd)
		os.Exit(2)
	}
}

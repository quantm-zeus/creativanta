// Command migrate executes Goose-compatible versioned SQL migrations for Creativanta.
// It fails closed (exit code 2) when invoked without a subcommand or migration database URL.
package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
)

func main() {
	args := os.Args[1:]
	dbURL := os.Getenv("CREATIVANTA_MIGRATE_DATABASE_URL")
	if len(args) == 0 || dbURL == "" {
		slog.Error("migrate: unconfigured invocation not implemented; require subcommand (up|status|down) and CREATIVANTA_MIGRATE_DATABASE_URL")
		os.Exit(2)
	}

	subcmd := args[0]
	migrationsDir := os.Getenv("CREATIVANTA_MIGRATIONS_DIR")
	if migrationsDir == "" {
		migrationsDir = filepath.Join("..", "..", "infra", "migrations")
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	ctx, cancel := context.WithTimeout(ctx, 60*time.Second)
	defer cancel()

	pool, err := pgxpool.New(ctx, dbURL)
	if err != nil {
		slog.Error("migrate: database pool configuration failed", "error", err)
		os.Exit(1)
	}
	defer pool.Close()

	switch subcmd {
	case "up":
		applied, err := migrate.Up(ctx, pool, migrationsDir)
		if err != nil {
			slog.Error("migrate: up failed", "error", err)
			os.Exit(1)
		}
		slog.Info("migrate: up completed", "applied_versions", applied)
	case "status":
		statuses, err := migrate.Status(ctx, pool, migrationsDir)
		if err != nil {
			slog.Error("migrate: status failed", "error", err)
			os.Exit(1)
		}
		for _, st := range statuses {
			fmt.Printf("version=%d name=%s applied=%t checksum=%s\n", st.Version, st.Name, st.Applied, st.Checksum)
		}
	case "down":
		allowRollback := os.Getenv("CREATIVANTA_MIGRATE_ALLOW_LOCAL_ROLLBACK") == "true"
		rolledBack, err := migrate.Down(ctx, pool, migrationsDir, allowRollback)
		if err != nil {
			slog.Error("migrate: down failed", "error", err)
			os.Exit(1)
		}
		slog.Info("migrate: down completed", "rolled_back_version", rolledBack)
	default:
		slog.Error("migrate: unknown subcommand not implemented", "subcommand", subcmd)
		os.Exit(2)
	}
}

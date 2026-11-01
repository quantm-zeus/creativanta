// Command admin-api exposes only loopback health and fail-closed readiness during P0-01.
package main

import (
	"context"
	"github.com/quantm-zeus/creativanta/apps/api/internal/bootstrap"
	"log/slog"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	h, err := bootstrap.NewHandler(bootstrap.RoleAdminAPI, nil)
	if err != nil {
		slog.Error("handler configuration", "error", err)
		os.Exit(1)
	}
	addr := os.Getenv("CREATIVANTA_ADMIN_LISTEN_ADDR")
	if addr == "" {
		addr = "127.0.0.1:3001"
	}
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	if err := bootstrap.Serve(ctx, addr, h); err != nil {
		slog.Error("bootstrap listener failed", "error", err)
		os.Exit(1)
	}
}

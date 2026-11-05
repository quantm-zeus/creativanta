package main

import (
	"context"
	"os"
	"os/signal"
	"syscall"

	"github.com/quantm-zeus/creativanta/apps/api/internal/bootstrap"
	"github.com/quantm-zeus/creativanta/apps/api/internal/runtimeassembly"
)

func main() {
	addr := os.Getenv("CREATIVANTA_API_LISTEN_ADDR")
	if addr == "" {
		addr = "127.0.0.1:3000"
	}
	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	handler, cleanup, err := runtimeassembly.NewServerHandler(ctx, bootstrap.RoleAPI)
	if err != nil {
		_, _ = os.Stderr.WriteString("api: " + err.Error() + "\n")
		os.Exit(1)
	}
	defer cleanup()

	if err := bootstrap.Serve(ctx, addr, handler); err != nil {
		_, _ = os.Stderr.WriteString("api: " + err.Error() + "\n")
		os.Exit(1)
	}
}

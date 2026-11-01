package main

import (
	"context"
	"errors"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/transportfixture"
)

func main() {
	addr := os.Getenv("CV_FIXTURE_LISTEN_ADDR")
	if addr == "" {
		addr = "127.0.0.1:18096"
	}

	host, _, err := net.SplitHostPort(addr)
	if err != nil {
		host = addr
	}
	if host != "127.0.0.1" && host != "::1" && host != "localhost" {
		log.Fatalf("[TEST_ONLY] fatal: transport fixture must strictly bind loopback (127.0.0.1 or ::1), rejected address: %s", addr)
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	handler := transportfixture.NewTestHandler()

	server := &http.Server{
		Addr:              addr,
		Handler:           handler,
		ReadHeaderTimeout: 5 * time.Second,
	}

	serverErr := make(chan error, 1)
	go func() {
		log.Printf("[TEST_ONLY] transport fixture service listening on %s (loopback only)", addr)
		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			serverErr <- err
		}
	}()

	select {
	case err := <-serverErr:
		log.Fatalf("[TEST_ONLY] fatal: server encountered error: %v", err)
	case <-ctx.Done():
		log.Println("[TEST_ONLY] shutdown signal received, initiating graceful shutdown")
	}

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := server.Shutdown(shutdownCtx); err != nil {
		log.Printf("[TEST_ONLY] warning: graceful shutdown error: %v", err)
	} else {
		log.Println("[TEST_ONLY] server shutdown completed successfully")
	}
}

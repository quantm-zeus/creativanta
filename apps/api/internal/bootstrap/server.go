// Package bootstrap provides the minimal loopback-only HTTP health and readiness
// surface for the api and admin-api processes.
//
// Scope notice: This package implements only the foundational bootstrap process
// skeleton and explicitly does NOT claim P0-01 slice runtime acceptance.
package bootstrap

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"net/http"
	"strconv"
	"time"
)

const (
	// RoleAPI identifies the tenant-facing API process role.
	RoleAPI = "api"
	// RoleAdminAPI identifies the isolated admin API process role.
	RoleAdminAPI = "admin-api"

	shutdownTimeout   = 4 * time.Second
	readHeaderTimeout = 5 * time.Second
	readTimeout       = 10 * time.Second
	writeTimeout      = 10 * time.Second
	idleTimeout       = 60 * time.Second
)

var (
	// ErrInvalidRole is returned when the configured service role is not allowed.
	ErrInvalidRole = errors.New("bootstrap: invalid role; must be api or admin-api")
	// ErrNonLoopbackAddr is returned when Serve is given a non-loopback bind address.
	ErrNonLoopbackAddr = errors.New("bootstrap: bind address must be loopback (127.0.0.1 or ::1)")
	// ErrNilContext is returned when Serve is called with a nil context.
	ErrNilContext = errors.New("bootstrap: context must not be nil")
	// ErrNilHandler is returned when Serve is called with a nil HTTP handler.
	ErrNilHandler = errors.New("bootstrap: handler must not be nil")
)

type healthResponse struct {
	Status string `json:"status"`
	Role   string `json:"role"`
}

type readyResponse struct {
	Status string `json:"status"`
}

type errorResponse struct {
	Error string `json:"error"`
}

// ValidateRole checks that role is strictly RoleAPI or RoleAdminAPI.
func ValidateRole(role string) error {
	if role != RoleAPI && role != RoleAdminAPI {
		return fmt.Errorf("%w: %q", ErrInvalidRole, role)
	}
	return nil
}

type handler struct {
	role      string
	readiness func(context.Context) bool
	routes    http.Handler
}

// NewHandler constructs the bootstrap HTTP handler for the given role and readiness probe.
// Role validation fails closed: any role other than "api" or "admin-api" returns ErrInvalidRole.
// A nil readiness function is treated as not ready (HTTP 503).
func NewHandler(role string, readiness func(context.Context) bool) (http.Handler, error) {
	return NewHandlerWithRoutes(role, readiness, nil)
}

// NewHandlerWithRoutes constructs the bootstrap HTTP handler for the given role, readiness probe,
// and composed route handler. /healthz and /readyz are always served by the bootstrap layer;
// all other paths are delegated to routes when non-nil, or return 404 JSON fail-closed when nil.
func NewHandlerWithRoutes(role string, readiness func(context.Context) bool, routes http.Handler) (http.Handler, error) {
	if err := ValidateRole(role); err != nil {
		return nil, err
	}
	return &handler{
		role:      role,
		readiness: readiness,
		routes:    routes,
	}, nil
}

func (h *handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if h == nil || ValidateRole(h.role) != nil {
		writeJSON(w, http.StatusServiceUnavailable, readyResponse{Status: "not_ready"})
		return
	}

	switch r.URL.Path {
	case "/healthz":
		if r.Method != http.MethodGet {
			w.Header().Set("Allow", http.MethodGet)
			writeJSON(w, http.StatusMethodNotAllowed, errorResponse{Error: "method_not_allowed"})
			return
		}
		writeJSON(w, http.StatusOK, healthResponse{
			Status: "alive",
			Role:   h.role,
		})
	case "/readyz":
		if r.Method != http.MethodGet {
			w.Header().Set("Allow", http.MethodGet)
			writeJSON(w, http.StatusMethodNotAllowed, errorResponse{Error: "method_not_allowed"})
			return
		}
		if h.readiness == nil || !h.readiness(r.Context()) {
			writeJSON(w, http.StatusServiceUnavailable, readyResponse{Status: "not_ready"})
			return
		}
		writeJSON(w, http.StatusOK, readyResponse{Status: "ready"})
	default:
		if h.routes != nil {
			h.routes.ServeHTTP(w, r)
			return
		}
		writeJSON(w, http.StatusNotFound, errorResponse{Error: "not_found"})
	}
}

func writeJSON(w http.ResponseWriter, statusCode int, payload any) {
	body, err := json.Marshal(payload)
	if err != nil {
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Cache-Control", "no-store")
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.WriteHeader(http.StatusInternalServerError)
		_, _ = w.Write([]byte(`{"error":"internal_error"}`))
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Cache-Control", "no-store")
	w.Header().Set("X-Content-Type-Options", "nosniff")
	w.WriteHeader(statusCode)
	_, _ = w.Write(body)
}

func validateLoopbackAddr(addr string) error {
	host, portStr, err := net.SplitHostPort(addr)
	if err != nil {
		return fmt.Errorf("%w: %v", ErrNonLoopbackAddr, err)
	}
	if host != "127.0.0.1" && host != "::1" {
		return fmt.Errorf("%w: got host %q", ErrNonLoopbackAddr, host)
	}
	port, err := strconv.Atoi(portStr)
	if err != nil || port < 0 || port > 65535 {
		return fmt.Errorf("%w: invalid port %q", ErrNonLoopbackAddr, portStr)
	}
	return nil
}

// Serve binds a TCP listener strictly on a loopback address (127.0.0.1 or ::1)
// and serves HTTP requests until ctx is cancelled or an unexpected error occurs.
// On context cancellation, Serve shuts down gracefully within 4 seconds.
func Serve(ctx context.Context, addr string, h http.Handler) error {
	if ctx == nil {
		return ErrNilContext
	}
	if h == nil {
		return ErrNilHandler
	}
	if err := validateLoopbackAddr(addr); err != nil {
		return err
	}

	ln, err := net.Listen("tcp", addr)
	if err != nil {
		return err
	}

	srv := &http.Server{
		Addr:              ln.Addr().String(),
		Handler:           h,
		ReadHeaderTimeout: readHeaderTimeout,
		ReadTimeout:       readTimeout,
		WriteTimeout:      writeTimeout,
		IdleTimeout:       idleTimeout,
		BaseContext: func(net.Listener) context.Context {
			return ctx
		},
	}

	serveErrCh := make(chan error, 1)
	go func() {
		serveErrCh <- srv.Serve(ln)
	}()

	select {
	case serveErr := <-serveErrCh:
		if errors.Is(serveErr, http.ErrServerClosed) {
			return nil
		}
		return serveErr
	case <-ctx.Done():
		shutdownCtx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
		defer cancel()

		shutdownErr := srv.Shutdown(shutdownCtx)
		if shutdownErr != nil {
			_ = srv.Close()
		}
		serveErr := <-serveErrCh
		if shutdownErr != nil {
			return shutdownErr
		}
		if serveErr != nil && !errors.Is(serveErr, http.ErrServerClosed) {
			return serveErr
		}
		return nil
	}
}

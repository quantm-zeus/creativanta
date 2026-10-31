package bootstrap

import (
	"context"
	"errors"
	"net"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

func TestHealthz_200(t *testing.T) {
	tests := []struct {
		name     string
		role     string
		wantBody string
	}{
		{
			name:     "api role",
			role:     RoleAPI,
			wantBody: `{"status":"alive","role":"api"}`,
		},
		{
			name:     "admin-api role",
			role:     RoleAdminAPI,
			wantBody: `{"status":"alive","role":"admin-api"}`,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			h, err := NewHandler(tc.role, nil)
			if err != nil {
				t.Fatalf("NewHandler(%q) unexpected error: %v", tc.role, err)
			}

			req := httptest.NewRequest(http.MethodGet, "/healthz", nil)
			rec := httptest.NewRecorder()
			h.ServeHTTP(rec, req)

			if rec.Code != http.StatusOK {
				t.Fatalf("status = %d, want %d", rec.Code, http.StatusOK)
			}
			if ct := rec.Header().Get("Content-Type"); !strings.HasPrefix(ct, "application/json") {
				t.Fatalf("Content-Type = %q, want application/json", ct)
			}
			if got := strings.TrimSpace(rec.Body.String()); got != tc.wantBody {
				t.Fatalf("body = %s, want %s", got, tc.wantBody)
			}
		})
	}
}

func TestRoleValidation_FailsClosed(t *testing.T) {
	invalidRoles := []string{"", "worker", "API", "ADMIN-API", "public", "default"}
	for _, role := range invalidRoles {
		h, err := NewHandler(role, func(context.Context) bool { return true })
		if err == nil {
			t.Fatalf("NewHandler(%q) expected error, got nil", role)
		}
		if !errors.Is(err, ErrInvalidRole) {
			t.Fatalf("NewHandler(%q) error = %v, want ErrInvalidRole", role, err)
		}
		if h != nil {
			t.Fatalf("NewHandler(%q) expected nil handler on error", role)
		}
	}
}

func TestReadyz_503WhenNilOrFalse(t *testing.T) {
	tests := []struct {
		name      string
		readiness func(context.Context) bool
	}{
		{
			name:      "nil readiness func",
			readiness: nil,
		},
		{
			name:      "false readiness func",
			readiness: func(context.Context) bool { return false },
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			h, err := NewHandler(RoleAPI, tc.readiness)
			if err != nil {
				t.Fatalf("NewHandler unexpected error: %v", err)
			}

			req := httptest.NewRequest(http.MethodGet, "/readyz", nil)
			rec := httptest.NewRecorder()
			h.ServeHTTP(rec, req)

			if rec.Code != http.StatusServiceUnavailable {
				t.Fatalf("status = %d, want %d", rec.Code, http.StatusServiceUnavailable)
			}
			if ct := rec.Header().Get("Content-Type"); !strings.HasPrefix(ct, "application/json") {
				t.Fatalf("Content-Type = %q, want application/json", ct)
			}
			want := `{"status":"not_ready"}`
			if got := strings.TrimSpace(rec.Body.String()); got != want {
				t.Fatalf("body = %s, want %s", got, want)
			}
		})
	}
}

func TestReadyz_200WhenTrue(t *testing.T) {
	h, err := NewHandler(RoleAdminAPI, func(context.Context) bool { return true })
	if err != nil {
		t.Fatalf("NewHandler unexpected error: %v", err)
	}

	req := httptest.NewRequest(http.MethodGet, "/readyz", nil)
	rec := httptest.NewRecorder()
	h.ServeHTTP(rec, req)

	if rec.Code != http.StatusOK {
		t.Fatalf("status = %d, want %d", rec.Code, http.StatusOK)
	}
	if ct := rec.Header().Get("Content-Type"); !strings.HasPrefix(ct, "application/json") {
		t.Fatalf("Content-Type = %q, want application/json", ct)
	}
	want := `{"status":"ready"}`
	if got := strings.TrimSpace(rec.Body.String()); got != want {
		t.Fatalf("body = %s, want %s", got, want)
	}
}

func TestMethodRestrictions_405(t *testing.T) {
	h, err := NewHandler(RoleAPI, func(context.Context) bool { return true })
	if err != nil {
		t.Fatalf("NewHandler unexpected error: %v", err)
	}

	methods := []string{
		http.MethodPost,
		http.MethodPut,
		http.MethodDelete,
		http.MethodPatch,
		http.MethodOptions,
		http.MethodHead,
	}
	paths := []string{"/healthz", "/readyz"}

	for _, path := range paths {
		for _, method := range methods {
			req := httptest.NewRequest(method, path, nil)
			rec := httptest.NewRecorder()
			h.ServeHTTP(rec, req)

			if rec.Code != http.StatusMethodNotAllowed {
				t.Fatalf("%s %s: status = %d, want %d", method, path, rec.Code, http.StatusMethodNotAllowed)
			}
			if allow := rec.Header().Get("Allow"); allow != http.MethodGet {
				t.Fatalf("%s %s: Allow = %q, want %q", method, path, allow, http.MethodGet)
			}
		}
	}
}

func TestUnknownPath_404(t *testing.T) {
	h, err := NewHandler(RoleAPI, func(context.Context) bool { return true })
	if err != nil {
		t.Fatalf("NewHandler unexpected error: %v", err)
	}

	unknownPaths := []string{
		"/",
		"/health",
		"/ready",
		"/healthz/deep",
		"/readyz/deep",
		"/v1/workspaces",
		"/admin",
	}

	for _, path := range unknownPaths {
		req := httptest.NewRequest(http.MethodGet, path, nil)
		rec := httptest.NewRecorder()
		h.ServeHTTP(rec, req)

		if rec.Code != http.StatusNotFound {
			t.Fatalf("GET %s: status = %d, want %d", path, rec.Code, http.StatusNotFound)
		}
	}
}

func TestServe_PublicBindRefusal(t *testing.T) {
	h, err := NewHandler(RoleAPI, nil)
	if err != nil {
		t.Fatalf("NewHandler unexpected error: %v", err)
	}

	rejectedAddrs := []string{
		"",
		":8080",
		"0.0.0.0:8080",
		"[::]:8080",
		"192.168.1.10:8080",
		"10.0.0.1:8080",
		"localhost:8080",
		"127.0.0.2:8080",
		"127.0.0.1:notaport",
		"127.0.0.1:-1",
		"127.0.0.1:70000",
	}

	for _, addr := range rejectedAddrs {
		err := Serve(context.Background(), addr, h)
		if err == nil {
			t.Fatalf("Serve(%q) expected error, got nil", addr)
		}
		if !errors.Is(err, ErrNonLoopbackAddr) {
			t.Fatalf("Serve(%q) error = %v, want ErrNonLoopbackAddr", addr, err)
		}
	}
}

func TestServe_CancelledContext(t *testing.T) {
	h, err := NewHandler(RoleAPI, func(context.Context) bool { return true })
	if err != nil {
		t.Fatalf("NewHandler unexpected error: %v", err)
	}

	ctx, cancel := context.WithCancel(context.Background())
	errCh := make(chan error, 1)

	go func() {
		errCh <- Serve(ctx, "127.0.0.1:0", h)
	}()

	time.Sleep(30 * time.Millisecond)
	cancel()

	select {
	case serveErr := <-errCh:
		if serveErr != nil {
			t.Fatalf("Serve returned unexpected error on context cancellation: %v", serveErr)
		}
	case <-time.After(4 * time.Second):
		t.Fatal("Serve did not shut down within 4s after context cancellation")
	}
}

func TestServe_PropagatesUnexpectedError(t *testing.T) {
	h, err := NewHandler(RoleAPI, nil)
	if err != nil {
		t.Fatalf("NewHandler unexpected error: %v", err)
	}

	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("net.Listen failed: %v", err)
	}
	defer ln.Close()

	err = Serve(context.Background(), ln.Addr().String(), h)
	if err == nil {
		t.Fatal("expected Serve to fail when binding an already-occupied port, got nil")
	}
}

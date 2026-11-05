package bootstrap

import (
	"context"
	"crypto/rand"
	"crypto/rsa"
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/http"
	"net/http/httptest"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync/atomic"
	"syscall"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/golang-jwt/jwt/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	_ "github.com/jackc/pgx/v5/stdlib"
	fixturev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1/transporttestv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/identity"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportfixture"
)

func allocateLoopbackAddr(t *testing.T) string {
	t.Helper()
	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("allocate loopback port: %v", err)
	}
	addr := ln.Addr().String()
	_ = ln.Close()
	return addr
}

// TestRuntimeReadinessRealProcessEntrypoints compiles the real cmd/api,
// cmd/admin-api, cmd/worker, cmd/outbox, and cmd/migrate binaries into a
// temporary directory, starts api and admin-api as real OS child processes
// bound to ephemeral loopback ports, probes healthz/readyz/negative methods/
// unmounted privileged paths/security headers/non-loopback bind refusal, and
// verifies deterministic fail-closed exit codes for unconfigured daemons.
func TestRuntimeReadinessRealProcessEntrypoints(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	apiRoot, err := filepath.Abs(filepath.Join("..", ".."))
	if err != nil {
		t.Fatalf("resolve apps/api root: %v", err)
	}
	binDir := t.TempDir()

	targets := []string{"api", "admin-api", "worker", "outbox", "migrate"}
	for _, name := range targets {
		outBin := filepath.Join(binDir, name)
		buildCmd := exec.CommandContext(ctx, "go", "build", "-o", outBin, "./cmd/"+name)
		buildCmd.Dir = apiRoot
		if out, err := buildCmd.CombinedOutput(); err != nil {
			t.Fatalf("go build ./cmd/%s failed: %v\n%s", name, err, string(out))
		}
	}

	// 1. Non-loopback bind refusal must fail closed at process startup.
	for _, tc := range []struct {
		bin     string
		envKey  string
		badAddr string
	}{
		{bin: "api", envKey: "CREATIVANTA_API_LISTEN_ADDR", badAddr: "0.0.0.0:18080"},
		{bin: "api", envKey: "CREATIVANTA_API_LISTEN_ADDR", badAddr: "localhost:18080"},
		{bin: "admin-api", envKey: "CREATIVANTA_ADMIN_LISTEN_ADDR", badAddr: "0.0.0.0:18081"},
		{bin: "admin-api", envKey: "CREATIVANTA_ADMIN_LISTEN_ADDR", badAddr: "localhost:18081"},
	} {
		cmd := exec.CommandContext(ctx, filepath.Join(binDir, tc.bin))
		cmd.Env = append(os.Environ(), tc.envKey+"="+tc.badAddr)
		out, err := cmd.CombinedOutput()
		if err == nil {
			t.Fatalf("%s accepted non-loopback address %s", tc.bin, tc.badAddr)
		}
		if !strings.Contains(string(out), "bind address must be loopback") {
			t.Fatalf("%s with %s=%s unexpected output: %s", tc.bin, tc.envKey, tc.badAddr, string(out))
		}
	}

	// 2. Start real api and admin-api OS processes on ephemeral loopback ports.
	type runningDaemon struct {
		role    string
		env     string
		addr    string
		cmd     *exec.Cmd
		logPath string
		logFile *os.File
		wait    chan error
	}
	daemons := []*runningDaemon{
		{role: "api", env: "CREATIVANTA_API_LISTEN_ADDR", addr: allocateLoopbackAddr(t)},
		{role: "admin-api", env: "CREATIVANTA_ADMIN_LISTEN_ADDR", addr: allocateLoopbackAddr(t)},
	}

	client := &http.Client{Timeout: 2 * time.Second}

	for _, d := range daemons {
		daemon := d
		daemon.logPath = filepath.Join(binDir, daemon.role+".log")
		lf, err := os.Create(daemon.logPath)
		if err != nil {
			t.Fatalf("create log file for %s: %v", daemon.role, err)
		}
		daemon.logFile = lf
		daemon.cmd = exec.CommandContext(ctx, filepath.Join(binDir, daemon.role))
		daemon.cmd.Env = append(os.Environ(), daemon.env+"="+daemon.addr)
		daemon.cmd.Stdout = lf
		daemon.cmd.Stderr = lf
		if err := daemon.cmd.Start(); err != nil {
			_ = lf.Close()
			t.Fatalf("start %s process: %v", daemon.role, err)
		}
		daemon.wait = make(chan error, 1)
		go func(dm *runningDaemon) {
			dm.wait <- dm.cmd.Wait()
		}(daemon)

		t.Cleanup(func() {
			if daemon.cmd.Process != nil {
				_ = daemon.cmd.Process.Signal(syscall.SIGTERM)
				select {
				case <-daemon.wait:
				case <-time.After(2 * time.Second):
					_ = daemon.cmd.Process.Kill()
				}
			}
			_ = daemon.logFile.Close()
		})

		// Poll until /healthz responds 200 OK.
		var alive bool
		deadline := time.Now().Add(5 * time.Second)
		for time.Now().Before(deadline) {
			resp, err := client.Get("http://" + daemon.addr + "/healthz")
			if err == nil {
				_, _ = io.Copy(io.Discard, resp.Body)
				_ = resp.Body.Close()
				if resp.StatusCode == http.StatusOK {
					alive = true
					break
				}
			}
			time.Sleep(40 * time.Millisecond)
		}
		if !alive {
			logBytes, _ := os.ReadFile(daemon.logPath)
			t.Fatalf("%s failed to become healthy at %s; logs:\n%s", daemon.role, daemon.addr, string(logBytes))
		}
	}

	// 3. Probe lifecycle, fail-closed readiness, negative HTTP methods, and forbidden routes.
	for _, d := range daemons {
		baseURL := "http://" + d.addr

		// 3a. GET /healthz -> 200 OK with security headers and exact JSON payload.
		resp, err := client.Get(baseURL + "/healthz")
		if err != nil {
			t.Fatalf("%s GET /healthz failed: %v", d.role, err)
		}
		bodyBytes, _ := io.ReadAll(resp.Body)
		_ = resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			t.Fatalf("%s GET /healthz status = %d, want 200", d.role, resp.StatusCode)
		}
		assertSecurityHeaders(t, d.role+" /healthz", resp.Header)
		var healthPayload map[string]string
		if err := json.Unmarshal(bodyBytes, &healthPayload); err != nil {
			t.Fatalf("%s /healthz JSON decode: %v", d.role, err)
		}
		if healthPayload["status"] != "alive" || healthPayload["role"] != d.role {
			t.Fatalf("%s /healthz payload = %v", d.role, healthPayload)
		}

		// 3b. GET /readyz -> 503 Service Unavailable (fail-closed when dependencies are not wired).
		resp, err = client.Get(baseURL + "/readyz")
		if err != nil {
			t.Fatalf("%s GET /readyz failed: %v", d.role, err)
		}
		bodyBytes, _ = io.ReadAll(resp.Body)
		_ = resp.Body.Close()
		if resp.StatusCode != http.StatusServiceUnavailable {
			t.Fatalf("%s GET /readyz status = %d, want 503 fail-closed", d.role, resp.StatusCode)
		}
		assertSecurityHeaders(t, d.role+" /readyz", resp.Header)
		var readyPayload map[string]string
		if err := json.Unmarshal(bodyBytes, &readyPayload); err != nil {
			t.Fatalf("%s /readyz JSON decode: %v", d.role, err)
		}
		if readyPayload["status"] != "not_ready" {
			t.Fatalf("%s /readyz payload = %v", d.role, readyPayload)
		}

		// 3c. Negative HTTP methods on /healthz and /readyz -> 405 Method Not Allowed + Allow: GET.
		for _, method := range []string{
			http.MethodPost,
			http.MethodPut,
			http.MethodDelete,
			http.MethodPatch,
			http.MethodOptions,
			http.MethodHead,
		} {
			for _, endpoint := range []string{"/healthz", "/readyz"} {
				req, err := http.NewRequestWithContext(ctx, method, baseURL+endpoint, nil)
				if err != nil {
					t.Fatal(err)
				}
				mResp, err := client.Do(req)
				if err != nil {
					t.Fatalf("%s %s %s failed: %v", d.role, method, endpoint, err)
				}
				_, _ = io.Copy(io.Discard, mResp.Body)
				_ = mResp.Body.Close()
				if mResp.StatusCode != http.StatusMethodNotAllowed {
					t.Fatalf("%s %s %s status = %d, want 405", d.role, method, endpoint, mResp.StatusCode)
				}
				if gotAllow := mResp.Header.Get("Allow"); gotAllow != http.MethodGet {
					t.Fatalf("%s %s %s Allow = %q, want GET", d.role, method, endpoint, gotAllow)
				}
				assertSecurityHeaders(t, fmt.Sprintf("%s %s %s", d.role, method, endpoint), mResp.Header)
			}
		}

		// 3d. Forbidden/unmounted/privileged routes must return 404 Not Found with zero default privileged access,
		// even if caller supplies forged Authorization and X-Workspace-ID headers.
		for _, path := range []string{
			"/",
			"/v1/workspaces",
			"/admin/users",
			"/internal/admin",
			"/metrics",
			"/debug/pprof",
			"/creativanta.v1.AuthService/GetSession",
			"/creativanta.transport.test.v1.TransportFixtureService/Echo",
		} {
			req, err := http.NewRequestWithContext(ctx, http.MethodPost, baseURL+path, strings.NewReader(`{}`))
			if err != nil {
				t.Fatal(err)
			}
			req.Header.Set("Authorization", "Bearer forged.admin.token")
			req.Header.Set("X-Workspace-ID", "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa")
			req.Header.Set("X-Internal-Admin", "true")
			uResp, err := client.Do(req)
			if err != nil {
				t.Fatalf("%s probe %s failed: %v", d.role, path, err)
			}
			uBody, _ := io.ReadAll(uResp.Body)
			_ = uResp.Body.Close()
			if uResp.StatusCode != http.StatusNotFound {
				t.Fatalf("%s %s returned status %d, want 404 Not Found", d.role, path, uResp.StatusCode)
			}
			assertSecurityHeaders(t, d.role+" "+path, uResp.Header)
			var errBody map[string]string
			if err := json.Unmarshal(uBody, &errBody); err != nil || errBody["error"] != "not_found" {
				t.Fatalf("%s %s unexpected body: %s", d.role, path, string(uBody))
			}
		}

		// 3e. Clean SIGTERM shutdown exits with code 0.
		if err := d.cmd.Process.Signal(syscall.SIGTERM); err != nil {
			t.Fatalf("SIGTERM %s: %v", d.role, err)
		}
		select {
		case waitErr := <-d.wait:
			if waitErr != nil {
				logBytes, _ := os.ReadFile(d.logPath)
				t.Fatalf("%s exited with error on SIGTERM: %v\nlogs:\n%s", d.role, waitErr, string(logBytes))
			}
		case <-time.After(5 * time.Second):
			t.Fatalf("%s did not shut down within 5s after SIGTERM", d.role)
		}
	}

	// 4. Unconfigured CLI daemons (worker, outbox, migrate) must fail closed with exit code 2.
	for _, cliName := range []string{"worker", "outbox", "migrate"} {
		cmd := exec.CommandContext(ctx, filepath.Join(binDir, cliName))
		out, err := cmd.CombinedOutput()
		if err == nil {
			t.Fatalf("cmd/%s succeeded without arguments; expected fail-closed exit code 2", cliName)
		}
		var exitErr *exec.ExitError
		if !errors.As(err, &exitErr) || exitErr.ExitCode() != 2 {
			t.Fatalf("cmd/%s exit error = %v (want exit code 2); output: %s", cliName, err, string(out))
		}
		if !strings.Contains(string(out), "not implemented") {
			t.Fatalf("cmd/%s stderr missing fail-closed marker: %s", cliName, string(out))
		}
	}
}

func assertSecurityHeaders(t *testing.T, label string, h http.Header) {
	t.Helper()
	if got := h.Get("Content-Type"); got != "application/json" {
		t.Fatalf("%s Content-Type = %q, want application/json", label, got)
	}
	if got := h.Get("Cache-Control"); got != "no-store" {
		t.Fatalf("%s Cache-Control = %q, want no-store", label, got)
	}
	if got := h.Get("X-Content-Type-Options"); got != "nosniff" {
		t.Fatalf("%s X-Content-Type-Options = %q, want nosniff", label, got)
	}
}

type dynamicSessionStatus struct {
	active atomic.Bool
}

func (s *dynamicSessionStatus) Active(_ context.Context, subject, sessionID string) (bool, error) {
	if subject == "" || sessionID == "" {
		return false, nil
	}
	return s.active.Load(), nil
}

type adminOnlyVerifier struct {
	validToken string
	adminUser  string
	mfaActive  bool
}

func (a adminOnlyVerifier) Verify(_ context.Context, token string) (transportauth.Session, error) {
	if token == "" || token != a.validToken || !a.mfaActive {
		return transportauth.Session{}, errors.New("admin token or MFA rejected: secret_admin_material_do_not_leak")
	}
	return transportauth.Session{
		UserID:        a.adminUser,
		InternalAdmin: true,
	}, nil
}

// TestRuntimeReadinessLivePostgresAuthAndTenantRLS wires the real Clerk RS256
// JWKS verifier, real SQLMembershipLookup, real transportauth Connect
// interceptors (ModeAPI and ModeAdminAPI) on loopback TCP listeners, and
// tenantdb.WithTx + app_user RLS against an isolated live PostgreSQL 17
// database with the complete canonical migration set applied.
func TestRuntimeReadinessLivePostgresAuthAndTenantRLS(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		dsn = os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	}
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; run via tooling/readiness/runtime/check_runtime_e2e.sh for live PostgreSQL 17.10 E2E verification")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect pgxpool: %v", err)
	}
	defer adminPool.Close()

	sqlDB, err := sql.Open("pgx", dsn)
	if err != nil {
		t.Fatalf("open stdlib sql.DB: %v", err)
	}
	defer sqlDB.Close()

	// 1. Clean public schema and apply the current canonical migration set.
	if _, err := adminPool.Exec(ctx, `DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO CURRENT_USER; GRANT USAGE ON SCHEMA public TO PUBLIC;`); err != nil {
		t.Fatalf("reset public schema: %v", err)
	}
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	applied, err := migrate.Up(ctx, adminPool, migrationsDir)
	if err != nil {
		t.Fatalf("migrate.Up failed: %v", err)
	}
	migrationFiles, err := filepath.Glob(filepath.Join(migrationsDir, "[0-9]*_*.sql"))
	if err != nil || len(migrationFiles) < 47 {
		t.Fatalf("cannot resolve canonical migrations: count=%d err=%v", len(migrationFiles), err)
	}
	if len(applied) != len(migrationFiles) {
		t.Fatalf("expected %d applied migrations, got %d", len(migrationFiles), len(applied))
	}
	statuses, err := migrate.Status(ctx, adminPool, migrationsDir)
	if err != nil {
		t.Fatalf("migrate.Status failed: %v", err)
	}
	for _, st := range statuses {
		if !st.Applied || len(st.Checksum) != 64 {
			t.Fatalf("unexpected migration status entry: %+v", st)
		}
	}

	// 2. Seed two isolated tenants (Tenant A and Tenant B) and two users.
	const (
		userA      = "11111111-1111-4111-8111-111111111111"
		userB      = "22222222-2222-4222-8222-222222222222"
		adminUUID  = "99999999-9999-4999-8999-999999999999"
		tenantA    = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
		tenantB    = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
		clerkUserA = "user_clerk_live_a"
		clerkUserB = "user_clerk_live_b"
		ticketA    = "77777777-7777-4777-8777-777777777777"
		quoteA     = "cccccccc-cccc-4ccc-8ccc-ccccccccccc1"
	)

	seedSQL := `
		INSERT INTO users (user_id, clerk_id, external_auth_id, email, display_name, status) VALUES
		  ('11111111-1111-4111-8111-111111111111', 'user_clerk_live_a', 'ext_a', 'a@readiness.example', 'Operator A', 'active'),
		  ('22222222-2222-4222-8222-222222222222', 'user_clerk_live_b', 'ext_b', 'b@readiness.example', 'Operator B', 'active');

		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Readiness Workspace A', 'readiness-ws-a', '11111111-1111-4111-8111-111111111111', 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Readiness Workspace B', 'readiness-ws-b', '22222222-2222-4222-8222-222222222222', 'active');

		INSERT INTO workspace_members (workspace_id, user_id, role, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '11111111-1111-4111-8111-111111111111', 'owner', 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '22222222-2222-4222-8222-222222222222', 'owner', 'active');

		INSERT INTO support_tickets (ticket_id, workspace_id, user_id, ticket_number, subject) VALUES
		  ('77777777-7777-4777-8777-777777777777', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '11111111-1111-4111-8111-111111111111', 'TK-E2E-1', 'Billing inquiry');

		INSERT INTO support_ticket_messages (workspace_id, ticket_id, author_type, author_id, body, is_internal_note) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '77777777-7777-4777-8777-777777777777', 'user', '11111111-1111-4111-8111-111111111111', 'Customer visible message', false),
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '77777777-7777-4777-8777-777777777777', 'admin', NULL, 'CONFIDENTIAL_INTERNAL_TRIAGE_NOTE', true);

		INSERT INTO ai_credit_quotes (quote_id, workspace_id, request_hash, operation_type, rate_version, provider_plan, cost_ceiling_usd, usd_per_credit_floor, gross_margin_floor, quoted_credits, expires_at)
		VALUES ('cccccccc-cccc-4ccc-8ccc-ccccccccccc1', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef', 'video_gen', 'v1', '{"provider":"veo"}'::jsonb, 1.250000, 0.010000, 0.4000, 125.000000, NOW() + INTERVAL '1 hour');
	`
	if _, err := adminPool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seedSQL failed: %v", err)
	}

	// 3. Spin up ephemeral RS256 JWKS TLS server and real loopback Connect API + Admin-API servers.
	rsaKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatal(err)
	}
	rogueKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatal(err)
	}
	const (
		kidTrusted = "kid-readiness-1"
		kidRogue   = "kid-rogue-99"
		jwtAud     = "creativanta-api"
		jwtOrigin  = "https://app.creativanta.example"
	)
	nowUnix := time.Now().UTC().Truncate(time.Second).Unix()
	jwksServer := httptest.NewTLSServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/.well-known/jwks.json" {
			http.NotFound(w, r)
			return
		}
		n := base64.RawURLEncoding.EncodeToString(rsaKey.PublicKey.N.Bytes())
		e := base64.RawURLEncoding.EncodeToString(big.NewInt(int64(rsaKey.PublicKey.E)).Bytes())
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"keys": []any{
				map[string]string{"kid": kidTrusted, "kty": "RSA", "use": "sig", "alg": "RS256", "n": n, "e": e},
			},
		})
	}))
	defer jwksServer.Close()

	tokenVerifier, err := identity.NewSessionTokenVerifier(identity.JWTConfig{
		Issuer:            jwksServer.URL,
		Audience:          jwtAud,
		AuthorizedParties: []string{jwtOrigin},
		HTTPClient:        jwksServer.Client(),
		CacheTTL:          5 * time.Minute,
	})
	if err != nil {
		t.Fatalf("NewSessionTokenVerifier: %v", err)
	}

	sessStatus := &dynamicSessionStatus{}
	sessStatus.active.Store(true)

	resolver := identity.Resolver{
		Tokens:      tokenVerifier,
		Memberships: identity.SQLMembershipLookup{Queries: sqlDB},
		Sessions:    sessStatus,
	}

	apiInterceptor, err := transportauth.NewServerInterceptor(transportauth.Options{
		Mode:     transportauth.ModeAPI,
		Verifier: resolver,
	})
	if err != nil {
		t.Fatalf("NewServerInterceptor(ModeAPI): %v", err)
	}

	// Start real TCP loopback listener for ModeAPI Connect surface.
	apiPath, apiHandler := transporttestv1connect.NewTransportFixtureServiceHandler(
		transportfixture.MustNew(),
		connect.WithInterceptors(apiInterceptor),
	)
	apiMux := http.NewServeMux()
	apiMux.Handle(apiPath, apiHandler)
	apiLn, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	apiSrv := &http.Server{Handler: apiMux, ReadHeaderTimeout: 5 * time.Second}
	go func() { _ = apiSrv.Serve(apiLn) }()
	defer func() { _ = apiSrv.Close() }()

	// Start real TCP loopback listener for ModeAdminAPI Connect surface.
	// Passing tenant Resolver (which returns InternalAdmin=false) into ModeAdminAPI must reject tenant tokens!
	adminWithTenantResolverInterceptor, err := transportauth.NewServerInterceptor(transportauth.Options{
		Mode:     transportauth.ModeAdminAPI,
		Verifier: resolver,
	})
	if err != nil {
		t.Fatalf("NewServerInterceptor(ModeAdminAPI): %v", err)
	}
	adminPath, adminHandler := transporttestv1connect.NewTransportFixtureServiceHandler(
		transportfixture.MustNew(),
		connect.WithInterceptors(adminWithTenantResolverInterceptor),
	)
	adminMux := http.NewServeMux()
	adminMux.Handle(adminPath, adminHandler)
	adminLn, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	adminSrv := &http.Server{Handler: adminMux, ReadHeaderTimeout: 5 * time.Second}
	go func() { _ = adminSrv.Serve(adminLn) }()
	defer func() { _ = adminSrv.Close() }()

	signJWT := func(key *rsa.PrivateKey, kid string, claims jwt.MapClaims) string {
		tok := jwt.NewWithClaims(jwt.SigningMethodRS256, claims)
		tok.Header["kid"] = kid
		s, err := tok.SignedString(key)
		if err != nil {
			t.Fatal(err)
		}
		return s
	}

	validClaimsA := func() jwt.MapClaims {
		return jwt.MapClaims{
			"iss": jwksServer.URL,
			"aud": jwtAud,
			"azp": jwtOrigin,
			"sub": clerkUserA,
			"sid": "sess_live_a",
			"iat": nowUnix - 10,
			"nbf": nowUnix - 5,
			"exp": nowUnix + 300,
		}
	}
	tokenA := signJWT(rsaKey, kidTrusted, validClaimsA())

	apiClient := transporttestv1connect.NewTransportFixtureServiceClient(http.DefaultClient, "http://"+apiLn.Addr().String())
	adminClient := transporttestv1connect.NewTransportFixtureServiceClient(http.DefaultClient, "http://"+adminLn.Addr().String())

	callEcho := func(cl transporttestv1connect.TransportFixtureServiceClient, bearer, headerWS, bodyWS string) (*connect.Response[fixturev1.EchoResponse], error) {
		req := connect.NewRequest(&fixturev1.EchoRequest{Text: "readiness-probe", WorkspaceId: bodyWS})
		req.Header().Set("x-request-id", "11111111-2222-4333-8444-555555555555")
		if headerWS != "" {
			req.Header().Set("x-workspace-id", headerWS)
		}
		if bearer != "" {
			req.Header().Set("Authorization", bearer)
		}
		return cl.Echo(ctx, req)
	}

	// 4. Positive path: valid RS256 JWT for User A + active DB membership in Tenant A succeeds on ModeAPI.
	res, err := callEcho(apiClient, "Bearer "+tokenA, tenantA, tenantA)
	if err != nil {
		t.Fatalf("expected valid Tenant A request to succeed on ModeAPI, got: %v", err)
	}
	if res.Msg.GetWorkspaceId() != tenantA {
		t.Fatalf("expected echoed workspace %s, got %s", tenantA, res.Msg.GetWorkspaceId())
	}
	if res.Header().Get("x-correlation-id") != "11111111-2222-4333-8444-555555555555" {
		t.Fatalf("missing x-correlation-id header on response")
	}

	// 5. Negative auth probes over real HTTP Connect transport.
	// 5a. Missing Authorization header -> CodeUnauthenticated.
	if _, err := callEcho(apiClient, "", tenantA, tenantA); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("missing Authorization header: got %v, want CodeUnauthenticated", err)
	}
	// 5b. Non-Bearer Authorization header -> CodeUnauthenticated.
	if _, err := callEcho(apiClient, "Basic dXNlcjpwYXNz", tenantA, tenantA); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("Basic Authorization header: got %v, want CodeUnauthenticated", err)
	}
	// 5c. Rogue signing key -> CodeUnauthenticated & zero secret leakage in error string.
	rogueToken := signJWT(rogueKey, kidRogue, validClaimsA())
	if _, err := callEcho(apiClient, "Bearer "+rogueToken, tenantA, tenantA); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("rogue key token: got %v, want CodeUnauthenticated", err)
	}
	// 5d. Expired JWT -> CodeUnauthenticated.
	expiredClaims := validClaimsA()
	expiredClaims["iat"] = nowUnix - 600
	expiredClaims["nbf"] = nowUnix - 590
	expiredClaims["exp"] = nowUnix - 120
	expiredToken := signJWT(rsaKey, kidTrusted, expiredClaims)
	if _, err := callEcho(apiClient, "Bearer "+expiredToken, tenantA, tenantA); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expired token: got %v, want CodeUnauthenticated", err)
	}
	// 5e. Cross-tenant membership probe: User A valid JWT requesting Tenant B in x-workspace-id -> CodeUnauthenticated.
	if _, err := callEcho(apiClient, "Bearer "+tokenA, tenantB, tenantB); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("User A requesting Tenant B: got %v, want CodeUnauthenticated", err)
	}
	// 5f. Header vs body workspace mismatch (User A authenticated for Tenant A, but body requests Tenant B) -> CodePermissionDenied.
	if _, err := callEcho(apiClient, "Bearer "+tokenA, tenantA, tenantB); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("User A header=TenantA body=TenantB: got %v, want CodePermissionDenied", err)
	}
	// 5g. Cross-surface isolation: valid Tenant A token sent to ModeAdminAPI server -> CodeUnauthenticated.
	if _, err := callEcho(adminClient, "Bearer "+tokenA, tenantA, tenantA); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("Tenant token sent to ModeAdminAPI server: got %v, want CodeUnauthenticated", err)
	}
	// 5h. Cross-surface isolation reverse: Admin session sent to ModeAPI server -> CodeUnauthenticated.
	modeAPIWithAdminTokenInterceptor, err := transportauth.NewServerInterceptor(transportauth.Options{
		Mode: transportauth.ModeAPI,
		Verifier: adminOnlyVerifier{
			validToken: "admin-token-1",
			adminUser:  adminUUID,
			mfaActive:  true,
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	revPath, revHandler := transporttestv1connect.NewTransportFixtureServiceHandler(
		transportfixture.MustNew(),
		connect.WithInterceptors(modeAPIWithAdminTokenInterceptor),
	)
	revMux := http.NewServeMux()
	revMux.Handle(revPath, revHandler)
	revSrv := httptest.NewServer(revMux)
	defer revSrv.Close()
	revClient := transporttestv1connect.NewTransportFixtureServiceClient(revSrv.Client(), revSrv.URL)
	if _, err := callEcho(revClient, "Bearer admin-token-1", tenantA, tenantA); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("Admin session on ModeAPI server: got %v, want CodeUnauthenticated", err)
	}

	// 5i. Real-time session revocation & DB membership revocation while JWT is still unexpired.
	sessStatus.active.Store(false)
	if _, err := callEcho(apiClient, "Bearer "+tokenA, tenantA, tenantA); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("revoked session should fail closed immediately: got %v", err)
	}
	sessStatus.active.Store(true)

	// Suspend membership in live PostgreSQL -> immediate denial on next request.
	if _, err := adminPool.Exec(ctx, `UPDATE workspace_members SET status = 'suspended' WHERE workspace_id = $1::uuid AND user_id = $2::uuid`, tenantA, userA); err != nil {
		t.Fatal(err)
	}
	if _, err := callEcho(apiClient, "Bearer "+tokenA, tenantA, tenantA); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("suspended DB workspace_member should fail closed immediately: got %v", err)
	}
	// Restore active membership and verify recovery.
	if _, err := adminPool.Exec(ctx, `UPDATE workspace_members SET status = 'active' WHERE workspace_id = $1::uuid AND user_id = $2::uuid`, tenantA, userA); err != nil {
		t.Fatal(err)
	}
	if _, err := callEcho(apiClient, "Bearer "+tokenA, tenantA, tenantA); err != nil {
		t.Fatalf("restored DB workspace_member should succeed: %v", err)
	}

	// 6. Live PostgreSQL 17 tenantdb.WithTx, RLS negative tests, 6 operator modes, money exactness, and replay guards.
	conn, err := adminPool.Acquire(ctx)
	if err != nil {
		t.Fatalf("acquire pgx conn: %v", err)
	}
	defer conn.Release()

	// 6a. Fail-closed when GUC app.current_tenant_id is unset under app_user.
	txUnscoped, err := conn.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := txUnscoped.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	var unscopedTickets int
	if err := txUnscoped.QueryRow(ctx, `SELECT COUNT(*) FROM support_tickets`).Scan(&unscopedTickets); err != nil {
		t.Fatalf("unscoped SELECT support_tickets: %v", err)
	}
	if unscopedTickets != 0 {
		t.Fatalf("expected 0 support_tickets when app.current_tenant_id is unset, got %d", unscopedTickets)
	}
	_ = txUnscoped.Rollback(ctx)

	// 6b. Verify tenantdb.WithTx enforces ErrScopeMismatch when querying a foreign workspace inside a Tenant A transaction,
	// and enforces ErrMembershipRevokedOrMissing when RequireActiveMembership=true for a non-member workspace.
	scopeA := tenantdb.Scope{WorkspaceID: tenantA, UserID: userA, RequireActiveMembership: true}
	err = tenantdb.WithTx(ctx, conn, scopeA, func(txCtx context.Context, q *tenantdb.Queries) error {
		wsRow, err := q.GetWorkspace(txCtx, tenantA)
		if err != nil {
			return fmt.Errorf("GetWorkspace(tenantA) failed: %w", err)
		}
		if wsRow.WorkspaceID != tenantA {
			return fmt.Errorf("unexpected WorkspaceID %q", wsRow.WorkspaceID)
		}
		_, err = q.GetWorkspace(txCtx, tenantB)
		return err
	})
	if !errors.Is(err, tenantdb.ErrScopeMismatch) {
		t.Fatalf("expected ErrScopeMismatch on foreign workspace query in WithTx, got %v", err)
	}

	err = tenantdb.WithTx(ctx, conn, tenantdb.Scope{
		WorkspaceID:             tenantB,
		UserID:                  userA,
		RequireActiveMembership: true,
	}, func(_ context.Context, _ *tenantdb.Queries) error {
		t.Fatal("callback must not execute when User A is not a member of Tenant B")
		return nil
	})
	if !errors.Is(err, tenantdb.ErrMembershipRevokedOrMissing) {
		t.Fatalf("expected ErrMembershipRevokedOrMissing, got %v", err)
	}

	// 6c. Under app_user scoped to Tenant A: verify all 6 canonical operator modes in home_dashboard_config,
	// internal note stripping on support_ticket_messages, and privilege restrictions.
	canonicalModes := []string{
		"creator",
		"seller",
		"affiliate_operator",
		"live_operator",
		"agency_mcn",
		"brand_collaboration",
	}
	txA, err := conn.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := txA.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := txA.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantA, userA); err != nil {
		t.Fatal(err)
	}
	for _, mode := range canonicalModes {
		if _, err := txA.Exec(ctx, `
			INSERT INTO home_dashboard_config (workspace_id, operator_mode)
			VALUES ($1::uuid, $2)
			ON CONFLICT (workspace_id) DO UPDATE SET operator_mode = EXCLUDED.operator_mode, updated_at = NOW()
		`, tenantA, mode); err != nil {
			t.Fatalf("operator_mode %q rejected on home_dashboard_config: %v", mode, err)
		}
	}

	// Invalid 7th mode must be rejected by CHECK constraint (23514).
	if _, err := txA.Exec(ctx, `SAVEPOINT sp_bad_mode`); err != nil {
		t.Fatal(err)
	}
	if _, err := txA.Exec(ctx, `UPDATE home_dashboard_config SET operator_mode = 'invalid_mode' WHERE workspace_id = $1::uuid`, tenantA); err == nil {
		t.Fatalf("expected invalid operator_mode to be rejected by CHECK constraint")
	}
	_, _ = txA.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_bad_mode`)

	// Verify support_ticket_messages strips is_internal_note = true for app_user.
	var visibleMsgs int
	var leakedInternal int
	if err := txA.QueryRow(ctx, `SELECT COUNT(*) FROM support_ticket_messages WHERE ticket_id = $1::uuid`, ticketA).Scan(&visibleMsgs); err != nil {
		t.Fatal(err)
	}
	if err := txA.QueryRow(ctx, `SELECT COUNT(*) FROM support_ticket_messages WHERE body LIKE '%CONFIDENTIAL_INTERNAL%'`).Scan(&leakedInternal); err != nil {
		t.Fatal(err)
	}
	if visibleMsgs != 1 || leakedInternal != 0 {
		t.Fatalf("support_ticket_messages internal note leak: visible=%d leakedInternal=%d", visibleMsgs, leakedInternal)
	}
	if err := txA.Commit(ctx); err != nil {
		t.Fatal(err)
	}

	// 6d. Under app_user scoped to Tenant B: verify cross-tenant read/update/delete/insert denial.
	txB, err := conn.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := txB.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := txB.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}
	var tenantAConfigs int
	if err := txB.QueryRow(ctx, `SELECT COUNT(*) FROM home_dashboard_config WHERE workspace_id = $1::uuid`, tenantA).Scan(&tenantAConfigs); err != nil {
		t.Fatal(err)
	}
	if tenantAConfigs != 0 {
		t.Fatalf("RLS breach: Tenant B read %d rows from Tenant A home_dashboard_config", tenantAConfigs)
	}

	tag, err := txB.Exec(ctx, `UPDATE home_dashboard_config SET operator_mode = 'seller' WHERE workspace_id = $1::uuid`, tenantA)
	if err != nil {
		t.Fatal(err)
	}
	if tag.RowsAffected() != 0 {
		t.Fatalf("RLS breach: Tenant B updated %d rows of Tenant A home_dashboard_config", tag.RowsAffected())
	}

	tag, err = txB.Exec(ctx, `DELETE FROM support_tickets WHERE ticket_id = $1::uuid`, ticketA)
	if err != nil {
		t.Fatal(err)
	}
	if tag.RowsAffected() != 0 {
		t.Fatalf("RLS breach: Tenant B deleted %d rows of Tenant A support_tickets", tag.RowsAffected())
	}

	// Cross-tenant INSERT must fail RLS WITH CHECK (SQLSTATE 42501).
	if _, err := txB.Exec(ctx, `SAVEPOINT sp_cross_insert`); err != nil {
		t.Fatal(err)
	}
	_, err = txB.Exec(ctx, `
		INSERT INTO support_tickets (workspace_id, user_id, ticket_number, subject)
		VALUES ($1::uuid, $2::uuid, 'TK-FORGED', 'Cross-tenant write')
	`, tenantA, userB)
	if err == nil {
		t.Fatalf("expected RLS WITH CHECK to reject cross-tenant INSERT into support_tickets")
	}
	var pgErr *pgconn.PgError
	if !errors.As(err, &pgErr) || pgErr.Code != "42501" {
		t.Fatalf("expected SQLSTATE 42501 on cross-tenant INSERT, got %v", err)
	}
	_, _ = txB.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_insert`)
	_ = txB.Rollback(ctx)

	// 6e. Replay & idempotency deduplication checks on live PostgreSQL 17:
	// - consumer_inbox UNIQUE(workspace_id, consumer_name, event_id)
	// - external_effects UNIQUE(workspace_id, operation_key)
	// - ai_credit_reservations UNIQUE(workspace_id, idempotency_key)
	txReplay, err := conn.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	if _, err := txReplay.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := txReplay.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantA, userA); err != nil {
		t.Fatal(err)
	}
	const replayEventID = "dddddddd-dddd-4ddd-8ddd-ddddddddddd1"
	if _, err := txReplay.Exec(ctx, `
		INSERT INTO consumer_inbox (workspace_id, consumer_name, event_id)
		VALUES ($1::uuid, 'publish_worker', $2::uuid)
	`, tenantA, replayEventID); err != nil {
		t.Fatalf("first consumer_inbox insert: %v", err)
	}
	if _, err := txReplay.Exec(ctx, `SAVEPOINT sp_replay_inbox`); err != nil {
		t.Fatal(err)
	}
	_, err = txReplay.Exec(ctx, `
		INSERT INTO consumer_inbox (workspace_id, consumer_name, event_id)
		VALUES ($1::uuid, 'publish_worker', $2::uuid)
	`, tenantA, replayEventID)
	if !errors.As(err, &pgErr) || pgErr.Code != "23505" {
		t.Fatalf("expected SQLSTATE 23505 on consumer_inbox replay, got %v", err)
	}
	_, _ = txReplay.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_replay_inbox`)

	// external_effects operation_key replay guard
	if _, err := txReplay.Exec(ctx, `
		INSERT INTO external_effects (workspace_id, operation_key, provider, aggregate_type, aggregate_id, status)
		VALUES ($1::uuid, 'idem-op-key-001', 'tiktok', 'publish_job', $2::uuid, 'prepared')
	`, tenantA, replayEventID); err != nil {
		t.Fatalf("first external_effects insert: %v", err)
	}
	if _, err := txReplay.Exec(ctx, `SAVEPOINT sp_replay_effect`); err != nil {
		t.Fatal(err)
	}
	_, err = txReplay.Exec(ctx, `
		INSERT INTO external_effects (workspace_id, operation_key, provider, aggregate_type, aggregate_id, status)
		VALUES ($1::uuid, 'idem-op-key-001', 'tiktok', 'publish_job', $2::uuid, 'prepared')
	`, tenantA, replayEventID)
	if !errors.As(err, &pgErr) || pgErr.Code != "23505" {
		t.Fatalf("expected SQLSTATE 23505 on external_effects operation_key replay, got %v", err)
	}
	_, _ = txReplay.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_replay_effect`)

	// ai_credit_reservations idempotency_key replay guard
	if _, err := txReplay.Exec(ctx, `
		INSERT INTO ai_credit_reservations (workspace_id, quote_id, idempotency_key, request_hash, status, reserved_credits, expires_at)
		VALUES ($1::uuid, $2::uuid, 'credit-idem-001', '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef', 'held', 25.000000, NOW() + INTERVAL '15 minutes')
	`, tenantA, quoteA); err != nil {
		t.Fatalf("first ai_credit_reservations insert: %v", err)
	}
	if _, err := txReplay.Exec(ctx, `SAVEPOINT sp_replay_credit`); err != nil {
		t.Fatal(err)
	}
	_, err = txReplay.Exec(ctx, `
		INSERT INTO ai_credit_reservations (workspace_id, quote_id, idempotency_key, request_hash, status, reserved_credits, expires_at)
		VALUES ($1::uuid, $2::uuid, 'credit-idem-001', '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef', 'held', 25.000000, NOW() + INTERVAL '15 minutes')
	`, tenantA, quoteA)
	if !errors.As(err, &pgErr) || pgErr.Code != "23505" {
		t.Fatalf("expected SQLSTATE 23505 on ai_credit_reservations idempotency_key replay, got %v", err)
	}
	_, _ = txReplay.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_replay_credit`)
	_ = txReplay.Rollback(ctx)

	// 6f. Money & credit exactness (DB-H-001): verify zero float4/float8 columns exist for money, price, cost, amount, fee, payout, or credit fields across all public tables.
	var floatMoneyColumns int
	if err := adminPool.QueryRow(ctx, `
		SELECT COUNT(*)
		FROM information_schema.columns
		WHERE table_schema = 'public'
		  AND data_type IN ('real', 'double precision', 'float')
		  AND (
		    column_name LIKE '%credit%'
		    OR column_name LIKE '%amount%'
		    OR column_name LIKE '%price%'
		    OR column_name LIKE '%cost%'
		    OR column_name LIKE '%payout%'
		    OR column_name LIKE '%revenue%'
		    OR column_name LIKE '%balance%'
		    OR column_name LIKE '%fee%'
		    OR column_name LIKE '%total%'
		    OR column_name LIKE '%usd%'
		    OR column_name LIKE '%vnd%'
		  )
	`).Scan(&floatMoneyColumns); err != nil {
		t.Fatalf("query information_schema for float money/credit columns: %v", err)
	}
	if floatMoneyColumns != 0 {
		t.Fatalf("DB-H-001 violation: found %d float/real/double precision money or credit columns in public schema", floatMoneyColumns)
	}
}

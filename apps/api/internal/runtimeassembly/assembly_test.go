package runtimeassembly_test

import (
	"context"
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/tls"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"math/big"
	"net"
	"net/http"
	"net/http/httptest"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5/pgxpool"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/bootstrap"
	"github.com/quantm-zeus/creativanta/apps/api/internal/internaladmin"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/runtimeassembly"
)

const (
	testWsA      = "22222222-3333-4444-8555-666666666601"
	testWsB      = "22222222-3333-4444-8555-666666666602"
	testOwnerA   = "bbbbbbbb-cccc-4ddd-8eee-ffffffffff01"
	testViewerA  = "bbbbbbbb-cccc-4ddd-8eee-ffffffffff02"
	testOwnerB   = "bbbbbbbb-cccc-4ddd-8eee-ffffffffff03"
	testSysAdmin = "bbbbbbbb-cccc-4ddd-8eee-ffffffffff04"

	testClerkSecretKey    = "sk_test_runtime_e2e_secret_key"
	testAdminValidToken   = "adm_sess_valid_token_99990001_verified"
	testAdminNoMFAToken   = "adm_sess_no_mfa_token_99990002_unverified"
	testAdminNoVPNToken   = "adm_sess_no_vpn_token_99990003_unverified"
	testAdminRevokedToken = "adm_sess_revoked_token_99990004_revoked"
)

type testSessionRecord struct {
	subject string
	status  string
}

type testJWKSProvider struct {
	server   *httptest.Server
	priv     *rsa.PrivateKey
	kid      string
	issuer   string
	mu       sync.Mutex
	sessions map[string]testSessionRecord
}

func newTestJWKSProvider(t *testing.T) *testJWKSProvider {
	t.Helper()
	priv, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatalf("rsa.GenerateKey: %v", err)
	}
	kid := "test-key-runtime-1"
	nB64 := base64.RawURLEncoding.EncodeToString(priv.PublicKey.N.Bytes())
	eB64 := base64.RawURLEncoding.EncodeToString(big.NewInt(int64(priv.PublicKey.E)).Bytes())

	p := &testJWKSProvider{
		priv:     priv,
		kid:      kid,
		sessions: make(map[string]testSessionRecord),
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/.well-known/jwks.json", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"keys": []map[string]any{
				{
					"kty": "RSA",
					"use": "sig",
					"alg": "RS256",
					"kid": kid,
					"n":   nB64,
					"e":   eB64,
				},
			},
		})
	})
	mux.HandleFunc("/v1/sessions/", func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("Authorization") != "Bearer "+testClerkSecretKey {
			w.WriteHeader(http.StatusUnauthorized)
			return
		}
		sid := strings.TrimPrefix(r.URL.Path, "/v1/sessions/")
		p.mu.Lock()
		rec, ok := p.sessions[sid]
		p.mu.Unlock()
		if !ok {
			w.WriteHeader(http.StatusNotFound)
			return
		}
		now := time.Now().UTC()
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"id":             sid,
			"user_id":        rec.subject,
			"status":         rec.status,
			"expire_at":      now.Add(15 * time.Minute).UnixMilli(),
			"abandon_at":     now.Add(30 * time.Minute).UnixMilli(),
			"last_active_at": now.UnixMilli(),
			"updated_at":     now.UnixMilli(),
			"created_at":     now.Add(-5 * time.Minute).UnixMilli(),
		})
	})

	srv := httptest.NewTLSServer(mux)
	t.Cleanup(srv.Close)

	p.server = srv
	p.issuer = srv.URL
	return p
}

func (p *testJWKSProvider) setSessionStatus(sessionID, status string) {
	p.mu.Lock()
	defer p.mu.Unlock()
	rec := p.sessions[sessionID]
	rec.status = status
	p.sessions[sessionID] = rec
}

func (p *testJWKSProvider) signToken(t *testing.T, subject, sessionID string) string {
	t.Helper()
	status := "active"
	if strings.Contains(strings.ToLower(sessionID), "revoked") {
		status = "revoked"
	}
	p.mu.Lock()
	p.sessions[sessionID] = testSessionRecord{
		subject: subject,
		status:  status,
	}
	p.mu.Unlock()
	now := time.Now().UTC()
	headerJSON, _ := json.Marshal(map[string]any{
		"alg": "RS256",
		"typ": "JWT",
		"kid": p.kid,
	})
	claimsJSON, _ := json.Marshal(map[string]any{
		"iss": p.issuer,
		"sub": subject,
		"sid": sessionID,
		"aud": []string{"creativanta-api"},
		"azp": "http://localhost:3000",
		"iat": now.Add(-1 * time.Minute).Unix(),
		"nbf": now.Add(-1 * time.Minute).Unix(),
		"exp": now.Add(15 * time.Minute).Unix(),
	})

	unsigned := base64.RawURLEncoding.EncodeToString(headerJSON) + "." + base64.RawURLEncoding.EncodeToString(claimsJSON)
	digest := sha256.Sum256([]byte(unsigned))
	sig, err := rsa.SignPKCS1v15(rand.Reader, p.priv, crypto.SHA256, digest[:])
	if err != nil {
		t.Fatalf("rsa.SignPKCS1v15: %v", err)
	}
	return unsigned + "." + base64.RawURLEncoding.EncodeToString(sig)
}

type disposableRuntimeDB struct {
	Pool            *pgxpool.Pool
	MigratorDSN     string
	SchemaCreateDSN string
	BypassRLSDSN    string
	APIDSN          string
	AdminAPIDSN     string
	OutboxDSN       string
	WorkerDSN       string
	APILoginRole    string
}

func dsnWithUserPass(baseDSN, user, pass string) string {
	u, err := url.Parse(baseDSN)
	if err != nil {
		return baseDSN
	}
	u.User = url.UserPassword(user, pass)
	return u.String()
}

func setupDisposableRuntimeDB(t *testing.T) disposableRuntimeDB {
	t.Helper()

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	var randBytes [6]byte
	_, _ = rand.Read(randBytes[:])
	suffix := fmt.Sprintf("%d_%s", time.Now().UnixNano(), hex.EncodeToString(randBytes[:]))
	dbName := "creativanta_runtime_test_" + suffix
	roleName := "creativanta_runtime_role_" + suffix
	apiLoginRole := "creativanta_api_role_" + suffix
	adminLoginRole := "creativanta_admin_role_" + suffix
	outboxLoginRole := "creativanta_outbox_role_" + suffix
	workerLoginRole := "creativanta_worker_role_" + suffix
	schemaCreateRole := "creativanta_migrator_role_" + suffix
	bypassRLSRole := "creativanta_bypass_role_" + suffix
	rolePass := "tmp_pw_" + hex.EncodeToString(randBytes[:])

	var disposableDSN string
	var cleanupDB func()

	if baseDSN := strings.TrimSpace(os.Getenv("CREATIVANTA_TEST_DATABASE_URL")); baseDSN != "" {
		adminPool, err := pgxpool.New(ctx, baseDSN)
		if err != nil {
			t.Fatalf("connect admin pool: %v", err)
		}
		if _, err := adminPool.Exec(ctx, fmt.Sprintf("CREATE DATABASE %s", dbName)); err != nil {
			adminPool.Close()
			t.Fatalf("create disposable DB %s: %v", dbName, err)
		}
		parsedURL, err := url.Parse(baseDSN)
		if err != nil {
			adminPool.Close()
			t.Fatalf("parse base DSN: %v", err)
		}
		parsedURL.Path = "/" + dbName
		disposableDSN = parsedURL.String()
		cleanupDB = func() {
			cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cleanCancel()
			_, _ = adminPool.Exec(cleanCtx, fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE)", dbName))
			for _, r := range []string{apiLoginRole, adminLoginRole, outboxLoginRole, workerLoginRole, schemaCreateRole, bypassRLSRole} {
				_, _ = adminPool.Exec(cleanCtx, fmt.Sprintf("DROP ROLE IF EXISTS %s", r))
			}
			adminPool.Close()
		}
	} else {
		conn, err := net.DialTimeout("tcp", "127.0.0.1:15432", 1*time.Second)
		if err != nil {
			t.Skip("PostgreSQL not reachable on 127.0.0.1:15432 and CREATIVANTA_TEST_DATABASE_URL not set")
		}
		_ = conn.Close()

		createRoleCmd := exec.CommandContext(ctx, "docker", "exec", "creativanta-p0-postgres-1",
			"psql", "-U", "creativanta_dev", "-d", "creativanta_dev", "-v", "ON_ERROR_STOP=1",
			"-c", fmt.Sprintf("CREATE ROLE %s WITH LOGIN SUPERUSER PASSWORD '%s';", roleName, rolePass),
			"-c", fmt.Sprintf("CREATE DATABASE %s OWNER %s;", dbName, roleName),
		)
		if out, err := createRoleCmd.CombinedOutput(); err != nil {
			t.Skipf("local disposable docker postgres setup unavailable: %v (%s)", err, string(out))
		}
		disposableDSN = fmt.Sprintf("postgres://%s:%s@127.0.0.1:15432/%s?sslmode=disable", roleName, rolePass, dbName)
		cleanupDB = func() {
			cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cleanCancel()
			_ = exec.CommandContext(cleanCtx, "docker", "exec", "creativanta-p0-postgres-1",
				"psql", "-U", "creativanta_dev", "-d", "creativanta_dev",
				"-c", fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE);", dbName),
				"-c", fmt.Sprintf("DROP ROLE IF EXISTS %s, %s, %s, %s, %s, %s, %s;", roleName, apiLoginRole, adminLoginRole, outboxLoginRole, workerLoginRole, schemaCreateRole, bypassRLSRole),
			).Run()
		}
	}

	pool, err := pgxpool.New(ctx, disposableDSN)
	if err != nil {
		cleanupDB()
		t.Fatalf("connect disposable DB: %v", err)
	}

	t.Cleanup(func() {
		pool.Close()
		cleanupDB()
	})

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, pool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up on disposable DB failed: %v", err)
	}

	rolesSQL := fmt.Sprintf(`
		CREATE ROLE %s WITH LOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION INHERIT PASSWORD '%s';
		GRANT app_user TO %s;

		CREATE ROLE %s WITH LOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION INHERIT PASSWORD '%s';
		GRANT admin_user TO %s;

		CREATE ROLE %s WITH LOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION INHERIT PASSWORD '%s';
		GRANT outbox_poller TO %s;

		CREATE ROLE %s WITH LOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION INHERIT PASSWORD '%s';
		GRANT app_user, outbox_poller TO %s;

		CREATE ROLE %s WITH LOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION INHERIT PASSWORD '%s';
		GRANT app_user, admin_user TO %s;
		GRANT CREATE ON SCHEMA public TO %s;

		CREATE ROLE %s WITH LOGIN NOSUPERUSER BYPASSRLS NOCREATEDB NOCREATEROLE NOREPLICATION INHERIT PASSWORD '%s';
		GRANT app_user TO %s;
	`,
		apiLoginRole, rolePass, apiLoginRole,
		adminLoginRole, rolePass, adminLoginRole,
		outboxLoginRole, rolePass, outboxLoginRole,
		workerLoginRole, rolePass, workerLoginRole,
		schemaCreateRole, rolePass, schemaCreateRole, schemaCreateRole,
		bypassRLSRole, rolePass, bypassRLSRole,
	)
	if _, err := pool.Exec(ctx, rolesSQL); err != nil {
		t.Fatalf("provision least-privilege runtime DB roles failed: %v", err)
	}

	seedSQL := fmt.Sprintf(`
		INSERT INTO users (user_id, clerk_id, email, display_name, status)
		VALUES
			('%s'::uuid, 'user_api_owner_a', 'owner_a@creativanta.test', 'Owner A', 'active'),
			('%s'::uuid, 'user_api_viewer_a', 'viewer_a@creativanta.test', 'Viewer A', 'active'),
			('%s'::uuid, 'user_api_owner_b', 'owner_b@creativanta.test', 'Owner B', 'active'),
			('%s'::uuid, 'user_api_sysadmin', 'sysadmin@creativanta.test', 'Internal Admin', 'active')
		ON CONFLICT (user_id) DO NOTHING;

		INSERT INTO internal_admins (admin_id, email, display_name, password_hash, role, status, mfa_enabled)
		VALUES
			('%s'::uuid, 'sysadmin@creativanta.test', 'Internal Admin', '$2a$12$test_hash_only', 'super_admin', 'active', true)
		ON CONFLICT (admin_id) DO NOTHING;

		INSERT INTO admin_sessions (
			session_id, admin_id, ip_address, user_agent,
			vpn_verified, mfa_verified, expired_at, revoked_at, session_token_hash
		)
		VALUES
			('99990000-0000-4000-8000-000000000001'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'runtime-e2e', true, true, NOW() + INTERVAL '4 hours', NULL, '%s'),
			('99990000-0000-4000-8000-000000000002'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'runtime-e2e', true, false, NOW() + INTERVAL '4 hours', NULL, '%s'),
			('99990000-0000-4000-8000-000000000003'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'runtime-e2e', false, true, NOW() + INTERVAL '4 hours', NULL, '%s'),
			('99990000-0000-4000-8000-000000000004'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'runtime-e2e', true, true, NOW() + INTERVAL '4 hours', NOW() - INTERVAL '1 minute', '%s')
		ON CONFLICT (session_id) DO NOTHING;

		INSERT INTO workspaces (
			workspace_id, name, slug, owner_user_id, subscription_tier,
			default_mode, enabled_modes, locale, timezone, status
		)
		VALUES
			('%s'::uuid, 'Runtime Workspace A', 'runtime-ws-a', '%s'::uuid, 'pro', 'seller'::operator_mode, ARRAY['seller','creator']::operator_mode[], 'vi-VN', 'Asia/Ho_Chi_Minh', 'active'),
			('%s'::uuid, 'Runtime Workspace B', 'runtime-ws-b', '%s'::uuid, 'free', 'creator'::operator_mode, ARRAY['creator']::operator_mode[], 'en-US', 'UTC', 'active')
		ON CONFLICT (workspace_id) DO NOTHING;

		INSERT INTO workspace_members (workspace_id, user_id, role, status)
		VALUES
			('%s'::uuid, '%s'::uuid, 'owner', 'active'),
			('%s'::uuid, '%s'::uuid, 'viewer', 'active'),
			('%s'::uuid, '%s'::uuid, 'owner', 'active')
		ON CONFLICT (workspace_id, user_id) DO UPDATE SET role = EXCLUDED.role, status = EXCLUDED.status;
	`,
		testOwnerA, testViewerA, testOwnerB, testSysAdmin,
		testSysAdmin,
		testSysAdmin, internaladmin.HashSessionToken(testAdminValidToken),
		testSysAdmin, internaladmin.HashSessionToken(testAdminNoMFAToken),
		testSysAdmin, internaladmin.HashSessionToken(testAdminNoVPNToken),
		testSysAdmin, internaladmin.HashSessionToken(testAdminRevokedToken),
		testWsA, testOwnerA,
		testWsB, testOwnerB,
		testWsA, testOwnerA,
		testWsA, testViewerA,
		testWsB, testOwnerB,
	)
	if _, err := pool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seed disposable DB failed: %v", err)
	}

	return disposableRuntimeDB{
		Pool:            pool,
		MigratorDSN:     disposableDSN,
		SchemaCreateDSN: dsnWithUserPass(disposableDSN, schemaCreateRole, rolePass),
		BypassRLSDSN:    dsnWithUserPass(disposableDSN, bypassRLSRole, rolePass),
		APIDSN:          dsnWithUserPass(disposableDSN, apiLoginRole, rolePass),
		AdminAPIDSN:     dsnWithUserPass(disposableDSN, adminLoginRole, rolePass),
		OutboxDSN:       dsnWithUserPass(disposableDSN, outboxLoginRole, rolePass),
		WorkerDSN:       dsnWithUserPass(disposableDSN, workerLoginRole, rolePass),
		APILoginRole:    apiLoginRole,
	}
}

func allocateFreeLoopbackAddr(t *testing.T) string {
	t.Helper()
	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("allocate free loopback port: %v", err)
	}
	addr := ln.Addr().String()
	_ = ln.Close()
	return addr
}

func waitForHTTPStatus(t *testing.T, urlStr string, expectedStatus int, timeout time.Duration) {
	t.Helper()
	deadline := time.Now().Add(timeout)
	client := &http.Client{Timeout: 1 * time.Second}
	for time.Now().Before(deadline) {
		resp, err := client.Get(urlStr)
		if err == nil {
			_ = resp.Body.Close()
			if resp.StatusCode == expectedStatus {
				return
			}
		}
		time.Sleep(100 * time.Millisecond)
	}
	t.Fatalf("timed out waiting for %s to return HTTP %d", urlStr, expectedStatus)
}

type headerRoundTripper struct {
	base        http.RoundTripper
	bearerToken string
	workspaceID string
}

func (rt *headerRoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	clone := req.Clone(req.Context())
	if rt.bearerToken != "" {
		clone.Header.Set("Authorization", "Bearer "+rt.bearerToken)
	}
	if rt.workspaceID != "" {
		clone.Header.Set("x-workspace-id", rt.workspaceID)
	}
	base := rt.base
	if base == nil {
		base = http.DefaultTransport
	}
	return base.RoundTrip(clone)
}

func newAuthHTTPClient(bearerToken, workspaceID string) *http.Client {
	return &http.Client{
		Timeout: 10 * time.Second,
		Transport: &headerRoundTripper{
			bearerToken: bearerToken,
			workspaceID: workspaceID,
		},
	}
}

func TestUnconfiguredAPIAndAdminAPIFailClosed(t *testing.T) {
	// Verify ConfigFromEnv(RoleAdminAPI) does NOT fall back to CREATIVANTA_API_DATABASE_URL.
	t.Setenv("CREATIVANTA_API_DATABASE_URL", "postgres://app_user:pw@127.0.0.1:5432/creativanta?sslmode=disable")
	t.Setenv("CREATIVANTA_ADMIN_DATABASE_URL", "")
	adminCfg := runtimeassembly.ConfigFromEnv(bootstrap.RoleAdminAPI)
	if adminCfg.DatabaseURL != "" {
		t.Fatalf("expected ConfigFromEnv(RoleAdminAPI) not to fall back to CREATIVANTA_API_DATABASE_URL, got %q", adminCfg.DatabaseURL)
	}

	ctx := context.Background()
	for _, role := range []string{bootstrap.RoleAPI, bootstrap.RoleAdminAPI} {
		handler, cleanup, err := runtimeassembly.NewHandlerFromConfig(ctx, runtimeassembly.Config{
			Role: role,
		})
		if err != nil {
			t.Fatalf("NewHandlerFromConfig(%s): %v", role, err)
		}
		defer cleanup()

		srv := httptest.NewServer(handler)
		defer srv.Close()

		respHealth, err := http.Get(srv.URL + "/healthz")
		if err != nil || respHealth.StatusCode != http.StatusOK {
			t.Fatalf("%s /healthz: status=%v err=%v", role, respHealth.StatusCode, err)
		}
		_ = respHealth.Body.Close()

		respReady, err := http.Get(srv.URL + "/readyz")
		if err != nil || respReady.StatusCode != http.StatusServiceUnavailable {
			t.Fatalf("%s unconfigured /readyz expected 503, got status=%v err=%v", role, respReady.StatusCode, err)
		}
		_ = respReady.Body.Close()

		respBiz, err := http.Get(srv.URL + "/api/workspaces/discovery")
		if err != nil || respBiz.StatusCode != http.StatusNotFound {
			t.Fatalf("%s unconfigured business route expected 404, got status=%v err=%v", role, respBiz.StatusCode, err)
		}
		_ = respBiz.Body.Close()
	}
}

// TestRealProcessAPIAndAdminAPIRuntimeAndOutboxWorkerPipeline verifies IQ-01, IQ-02, IQ-03,
// RUNTIME-01, ASYNC-01, AI-01, R01, and R11 across real OS processes (`cmd/api`, `cmd/admin-api`,
// `cmd/outbox`, and `cmd/worker`) backed by a disposable PostgreSQL database with RLS enforced.
func TestRealProcessAPIAndAdminAPIRuntimeAndOutboxWorkerPipeline(t *testing.T) {
	rtDB := setupDisposableRuntimeDB(t)
	pool := rtDB.Pool
	jwks := newTestJWKSProvider(t)

	ctx, cancel := context.WithTimeout(context.Background(), 90*time.Second)
	defer cancel()

	// Build all 4 production entrypoints into temporary binaries.
	binDir := t.TempDir()
	apiBin := filepath.Join(binDir, "api")
	adminBin := filepath.Join(binDir, "admin-api")
	outboxBin := filepath.Join(binDir, "outbox")
	workerBin := filepath.Join(binDir, "worker")

	for _, target := range []struct {
		out string
		pkg string
	}{
		{apiBin, "../../cmd/api"},
		{adminBin, "../../cmd/admin-api"},
		{outboxBin, "../../cmd/outbox"},
		{workerBin, "../../cmd/worker"},
	} {
		cmd := exec.CommandContext(ctx, "go", "build", "-o", target.out, target.pkg)
		if out, err := cmd.CombinedOutput(); err != nil {
			t.Fatalf("build %s failed: %v\n%s", target.pkg, err, string(out))
		}
	}

	apiAddr := allocateFreeLoopbackAddr(t)
	adminAddr := allocateFreeLoopbackAddr(t)

	// 0. Verify db_active session mode is strictly forbidden and fails closed at startup.
	if _, _, err := runtimeassembly.NewHandlerFromConfig(ctx, runtimeassembly.Config{
		Role:        bootstrap.RoleAPI,
		DatabaseURL: rtDB.APIDSN,
		SessionMode: "db_active",
	}); err == nil {
		t.Fatalf("expected SessionMode=db_active to be rejected at startup")
	}

	// 0b. Verify least-privilege DB role boundary enforcement at startup and /readyz:
	// Superuser, BYPASSRLS, migrator (CREATE ON SCHEMA public), outbox_poller, and cross-plane
	// credentials (admin_user on RoleAPI, app_user on RoleAdminAPI) MUST fail closed!
	for _, badCfg := range []struct {
		name string
		role string
		dsn  string
	}{
		{"api with superuser/owner DSN", bootstrap.RoleAPI, rtDB.MigratorDSN},
		{"api with BYPASSRLS DSN", bootstrap.RoleAPI, rtDB.BypassRLSDSN},
		{"api with schema CREATE (migrator) DSN", bootstrap.RoleAPI, rtDB.SchemaCreateDSN},
		{"api with outbox_poller DSN", bootstrap.RoleAPI, rtDB.OutboxDSN},
		{"api with worker (app_user+outbox_poller) DSN", bootstrap.RoleAPI, rtDB.WorkerDSN},
		{"api with cross-plane admin_user DSN", bootstrap.RoleAPI, rtDB.AdminAPIDSN},
		{"admin-api with superuser/owner DSN", bootstrap.RoleAdminAPI, rtDB.MigratorDSN},
		{"admin-api with BYPASSRLS DSN", bootstrap.RoleAdminAPI, rtDB.BypassRLSDSN},
		{"admin-api with schema CREATE (migrator) DSN", bootstrap.RoleAdminAPI, rtDB.SchemaCreateDSN},
		{"admin-api with cross-plane app_user DSN", bootstrap.RoleAdminAPI, rtDB.APIDSN},
	} {
		if _, _, err := runtimeassembly.NewHandlerFromConfig(ctx, runtimeassembly.Config{
			Role:        badCfg.role,
			DatabaseURL: badCfg.dsn,
		}); err == nil {
			t.Fatalf("expected NewHandlerFromConfig(%s) to reject privileged/cross-plane DB credential", badCfg.name)
		}
	}

	commonEnv := append(os.Environ(),
		"CREATIVANTA_API_DATABASE_URL="+rtDB.APIDSN,
		"CREATIVANTA_ADMIN_DATABASE_URL="+rtDB.AdminAPIDSN,
		"CREATIVANTA_OUTBOX_DATABASE_URL="+rtDB.OutboxDSN,
		"CREATIVANTA_WORKER_DATABASE_URL="+rtDB.WorkerDSN,
		"CREATIVANTA_REDIS_URL=",
		"CREATIVANTA_CLERK_ISSUER="+jwks.issuer,
		"CREATIVANTA_CLERK_AUDIENCE=creativanta-api",
		"CREATIVANTA_CLERK_AUTHORIZED_PARTIES=http://localhost:3000",
		"CREATIVANTA_CLERK_SECRET_KEY="+testClerkSecretKey,
		"CREATIVANTA_CLERK_SESSION_URL="+jwks.server.URL+"/v1/sessions/",
		"CREATIVANTA_CLERK_JWKS_INSECURE_TLS=true",
		"CREATIVANTA_API_LISTEN_ADDR="+apiAddr,
		"CREATIVANTA_ADMIN_LISTEN_ADDR="+adminAddr,
	)

	apiCmd := exec.CommandContext(ctx, apiBin)
	apiCmd.Env = commonEnv
	if err := apiCmd.Start(); err != nil {
		t.Fatalf("start cmd/api process: %v", err)
	}
	t.Cleanup(func() {
		if apiCmd.Process != nil {
			_ = apiCmd.Process.Kill()
			_, _ = apiCmd.Process.Wait()
		}
	})

	adminCmd := exec.CommandContext(ctx, adminBin)
	adminCmd.Env = commonEnv
	if err := adminCmd.Start(); err != nil {
		t.Fatalf("start cmd/admin-api process: %v", err)
	}
	t.Cleanup(func() {
		if adminCmd.Process != nil {
			_ = adminCmd.Process.Kill()
			_, _ = adminCmd.Process.Wait()
		}
	})

	apiBaseURL := "http://" + apiAddr
	adminBaseURL := "http://" + adminAddr

	// 1. Verify /healthz and /readyz on both real processes.
	waitForHTTPStatus(t, apiBaseURL+"/healthz", http.StatusOK, 10*time.Second)
	waitForHTTPStatus(t, apiBaseURL+"/readyz", http.StatusOK, 10*time.Second)
	waitForHTTPStatus(t, adminBaseURL+"/healthz", http.StatusOK, 10*time.Second)
	waitForHTTPStatus(t, adminBaseURL+"/readyz", http.StatusOK, 10*time.Second)

	// 1b. Verify live /readyz fails closed with HTTP 503 if the API DB role is granted privileged CREATE ON SCHEMA public,
	// and recovers to HTTP 200 once revoked!
	if _, err := pool.Exec(ctx, fmt.Sprintf("GRANT CREATE ON SCHEMA public TO %s", rtDB.APILoginRole)); err != nil {
		t.Fatalf("grant CREATE ON SCHEMA public to %s: %v", rtDB.APILoginRole, err)
	}
	waitForHTTPStatus(t, apiBaseURL+"/readyz", http.StatusServiceUnavailable, 5*time.Second)
	if _, err := pool.Exec(ctx, fmt.Sprintf("REVOKE CREATE ON SCHEMA public FROM %s", rtDB.APILoginRole)); err != nil {
		t.Fatalf("revoke CREATE ON SCHEMA public from %s: %v", rtDB.APILoginRole, err)
	}
	waitForHTTPStatus(t, apiBaseURL+"/readyz", http.StatusOK, 5*time.Second)

	ownerAToken := jwks.signToken(t, "user_api_owner_a", "sess_owner_a")
	viewerAToken := jwks.signToken(t, "user_api_viewer_a", "sess_viewer_a")
	ownerBToken := jwks.signToken(t, "user_api_owner_b", "sess_owner_b")
	sysAdminClerkToken := jwks.signToken(t, "user_api_sysadmin", "sess_sysadmin")
	revokedToken := jwks.signToken(t, "user_api_owner_a", "sess_revoked_1")
	_ = tls.VersionTLS13

	// 2. Verify /api/workspaces/discovery on real cmd/api process under app_user RLS (owner + non-owner viewer).
	unauthDiscResp, err := http.Get(apiBaseURL + "/api/workspaces/discovery")
	if err != nil {
		t.Fatalf("unauthenticated discovery request: %v", err)
	}
	_ = unauthDiscResp.Body.Close()
	if unauthDiscResp.StatusCode != http.StatusUnauthorized {
		t.Fatalf("expected 401 for unauthenticated discovery, got %d", unauthDiscResp.StatusCode)
	}

	discReq, _ := http.NewRequestWithContext(ctx, http.MethodGet, apiBaseURL+"/api/workspaces/discovery", nil)
	discReq.Header.Set("Authorization", "Bearer "+ownerAToken)
	discResp, err := http.DefaultClient.Do(discReq)
	if err != nil {
		t.Fatalf("authenticated discovery request: %v", err)
	}
	var discBody struct {
		Workspaces []struct {
			ID                  string `json:"workspace_id"`
			Name                string `json:"name"`
			DisplayName         string `json:"display_name"`
			Role                string `json:"role"`
			DefaultMode         string `json:"default_mode"`
			DefaultOperatorMode string `json:"default_operator_mode"`
		} `json:"workspaces"`
	}
	if err := json.NewDecoder(discResp.Body).Decode(&discBody); err != nil {
		_ = discResp.Body.Close()
		t.Fatalf("decode discovery response: %v", err)
	}
	_ = discResp.Body.Close()
	if discResp.StatusCode != http.StatusOK || len(discBody.Workspaces) != 1 || discBody.Workspaces[0].ID != testWsA || discBody.Workspaces[0].Role != "owner" {
		t.Fatalf("unexpected owner discovery payload: status=%d body=%+v", discResp.StatusCode, discBody)
	}

	// Non-owner viewer discovery under app_user RLS must also succeed and isolate foreign workspaces.
	viewerDiscReq, _ := http.NewRequestWithContext(ctx, http.MethodGet, apiBaseURL+"/api/workspaces/discovery", nil)
	viewerDiscReq.Header.Set("Authorization", "Bearer "+viewerAToken)
	viewerDiscResp, err := http.DefaultClient.Do(viewerDiscReq)
	if err != nil {
		t.Fatalf("viewer discovery request: %v", err)
	}
	var viewerDiscBody struct {
		Workspaces []struct {
			ID                  string `json:"workspace_id"`
			Name                string `json:"name"`
			DisplayName         string `json:"display_name"`
			Role                string `json:"role"`
			DefaultMode         string `json:"default_mode"`
			DefaultOperatorMode string `json:"default_operator_mode"`
		} `json:"workspaces"`
	}
	if err := json.NewDecoder(viewerDiscResp.Body).Decode(&viewerDiscBody); err != nil {
		_ = viewerDiscResp.Body.Close()
		t.Fatalf("decode viewer discovery response: %v", err)
	}
	_ = viewerDiscResp.Body.Close()
	if viewerDiscResp.StatusCode != http.StatusOK || len(viewerDiscBody.Workspaces) != 1 ||
		viewerDiscBody.Workspaces[0].ID != testWsA || viewerDiscBody.Workspaces[0].Role != "viewer" ||
		viewerDiscBody.Workspaces[0].DisplayName != "Runtime Workspace A" || viewerDiscBody.Workspaces[0].DefaultOperatorMode != "seller" {
		t.Fatalf("unexpected viewer discovery payload under app_user RLS: status=%d body=%+v", viewerDiscResp.StatusCode, viewerDiscBody)
	}

	// 3. Real-process authorized business RPC -> disposable PostgreSQL mutation -> readback!
	ownerAProductClient := commercev1connect.NewProductServiceClient(
		newAuthHTTPClient(ownerAToken, testWsA),
		apiBaseURL,
	)

	createResp, err := ownerAProductClient.Create(ctx, connect.NewRequest(&commercev1.CreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWsA},
			IdempotencyKey: "idem-prod-create-001",
		},
		ProductType:      commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:            "Bộ Đèn Livestream Studio Pro 65W",
		Description:      "Đèn LED nhiệt màu chuẩn CRI 97+ cho phòng live",
		Category:         "studio_gear",
		Currency:         "VND",
		CatalogStatus:    commercev1.CatalogStatus_CATALOG_STATUS_ACTIVE,
		InventoryEnabled: true,
		BasePrice: &commonv1.Money{
			Amount:   "1250000.000000",
			Currency: "VND",
		},
		Cogs: &commonv1.Money{
			Amount:   "750000.000000",
			Currency: "VND",
		},
		InitialSkus: []*commercev1.ProductSku{
			{
				SkuCode: "LAMP-65W-PRO",
				VariantAttributes: map[string]string{
					"wattage": "65W",
				},
				Currency:          "VND",
				LowStockThreshold: 5,
				IsActive:          true,
			},
		},
	}))
	if err != nil {
		t.Fatalf("ProductService/Create as ownerA failed: %v", err)
	}
	createdProductID := createResp.Msg.GetProduct().GetProductId()
	if createdProductID == "" || len(createResp.Msg.GetProduct().GetSkus()) != 1 {
		t.Fatalf("expected non-empty product_id and 1 initial SKU, got %+v", createResp.Msg)
	}

	// Readback via ProductService/Get and ProductService/List over HTTP/Connect:
	getResp, err := ownerAProductClient.Get(ctx, connect.NewRequest(&commercev1.GetRequest{
		ProductId: createdProductID,
	}))
	if err != nil {
		t.Fatalf("ProductService/Get readback failed: %v", err)
	}
	if getResp.Msg.GetProduct().GetTitle() != "Bộ Đèn Livestream Studio Pro 65W" {
		t.Fatalf("ProductService/Get title mismatch: %q", getResp.Msg.GetProduct().GetTitle())
	}
	if len(getResp.Msg.GetProduct().GetSkus()) != 1 || getResp.Msg.GetProduct().GetSkus()[0].GetSkuCode() != "LAMP-65W-PRO" {
		t.Fatalf("ProductService/Get SKUs mismatch: %+v", getResp.Msg.GetProduct().GetSkus())
	}

	listResp, err := ownerAProductClient.List(ctx, connect.NewRequest(&commercev1.ListRequest{}))
	if err != nil {
		t.Fatalf("ProductService/List readback failed: %v", err)
	}
	if len(listResp.Msg.GetProducts()) != 1 || listResp.Msg.GetProducts()[0].GetProductId() != createdProductID {
		t.Fatalf("ProductService/List mismatch: %+v", listResp.Msg.GetProducts())
	}

	// Verify direct PostgreSQL state for products, product_skus, event_outbox (including canonical "type" field), and audit_events:
	var dbProdCount, dbOutboxCount, dbAuditCount int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM products WHERE workspace_id = $1::uuid AND product_id = $2::uuid`, testWsA, createdProductID).Scan(&dbProdCount); err != nil {
		t.Fatalf("query products: %v", err)
	}
	if dbProdCount != 1 {
		t.Fatalf("expected 1 persisted row in products, got %d", dbProdCount)
	}
	var createdOutboxPayload []byte
	if err := pool.QueryRow(ctx, `SELECT COUNT(*), MAX(payload::text)::bytea FROM event_outbox WHERE workspace_id = $1::uuid AND aggregate_id = $2::uuid AND event_type = 'product.created' AND published = false`, testWsA, createdProductID).Scan(&dbOutboxCount, &createdOutboxPayload); err != nil {
		t.Fatalf("query event_outbox: %v", err)
	}
	if dbOutboxCount != 1 {
		t.Fatalf("expected 1 unpublished event_outbox row from ProductService/Create, got %d", dbOutboxCount)
	}
	var createdEventMap map[string]any
	if err := json.Unmarshal(createdOutboxPayload, &createdEventMap); err != nil || createdEventMap["type"] != "physical" || createdEventMap["product_id"] != createdProductID {
		t.Fatalf("expected canonical product.created outbox payload with type=physical, got %s (err=%v)", string(createdOutboxPayload), err)
	}
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM audit_events WHERE workspace_id = $1::uuid AND resource_id = $2::uuid AND action = 'product.created'`, testWsA, createdProductID).Scan(&dbAuditCount); err != nil {
		t.Fatalf("query audit_events: %v", err)
	}
	if dbAuditCount != 1 {
		t.Fatalf("expected 1 audit_events row from ProductService/Create, got %d", dbAuditCount)
	}

	// 4. Run cmd/outbox poll-once and cmd/worker run-once processes to process the API's outbox event,
	//    and verify DiagnosticsService + CapabilityService on cmd/api!
	pollCmd := exec.CommandContext(ctx, outboxBin, "poll-once")
	pollCmd.Env = commonEnv
	if out, err := pollCmd.CombinedOutput(); err != nil {
		t.Fatalf("outbox poll-once failed: %v\n%s", err, string(out))
	}

	workerCmd := exec.CommandContext(ctx, workerBin, "run-once")
	workerCmd.Env = commonEnv
	if out, err := workerCmd.CombinedOutput(); err != nil {
		t.Fatalf("worker run-once failed: %v\n%s", err, string(out))
	}

	var workerDiagCount int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM diagnostics_records WHERE workspace_id = $1::uuid AND scope_id = $2::uuid AND status = 'resolved'`, testWsA, createdProductID).Scan(&workerDiagCount); err != nil {
		t.Fatalf("query worker diagnostics_records: %v", err)
	}
	if workerDiagCount != 1 {
		t.Fatalf("expected 1 resolved diagnostics_records row from worker for product %s, got %d", createdProductID, workerDiagCount)
	}

	diagClient := adminv1connect.NewDiagnosticsServiceClient(
		newAuthHTTPClient(ownerAToken, testWsA),
		apiBaseURL,
	)
	diagOverviewResp, err := diagClient.GetOverview(ctx, connect.NewRequest(&adminv1.GetOverviewRequest{
		WorkspaceId: &commonv1.UUID{Value: testWsA},
	}))
	if err != nil || diagOverviewResp.Msg.GetTotalCategoriesCount() == 0 {
		t.Fatalf("DiagnosticsService/GetOverview failed: resp=%+v err=%v", diagOverviewResp, err)
	}

	// Verify DiagnosticsService/ListIssues on cmd/api returns the durable PostgreSQL diagnostics_records row written by cmd/worker!
	diagListResp, err := diagClient.ListIssues(ctx, connect.NewRequest(&adminv1.ListIssuesRequest{
		WorkspaceId: &commonv1.UUID{Value: testWsA},
	}))
	if err != nil {
		t.Fatalf("DiagnosticsService/ListIssues failed: %v", err)
	}
	foundWorkerDiag := false
	for _, iss := range diagListResp.Msg.GetIssues() {
		if iss.GetScopeId().GetValue() == createdProductID && iss.GetStatus() == adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_RESOLVED {
			foundWorkerDiag = true
			break
		}
	}
	if !foundWorkerDiag {
		t.Fatalf("expected DiagnosticsService/ListIssues to return durable worker diagnostics_records row for product %s, got %+v", createdProductID, diagListResp.Msg.GetIssues())
	}

	// 4b. Verify ProductService/Update and BulkArchive canonical event_outbox behavior:
	// Updating only Title (keeping status ACTIVE) must NOT emit product.catalog_status_changed.
	updatedTitle := "Bộ Đèn Livestream Studio Pro 65W V2"
	statusActive := commercev1.CatalogStatus_CATALOG_STATUS_ACTIVE
	statusDraft := commercev1.CatalogStatus_CATALOG_STATUS_DRAFT
	if _, err := ownerAProductClient.Update(ctx, connect.NewRequest(&commercev1.UpdateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWsA},
			IdempotencyKey: "idem-prod-update-title-001",
		},
		ProductId:     createdProductID,
		Title:         &updatedTitle,
		CatalogStatus: &statusActive,
	})); err != nil {
		t.Fatalf("ProductService/Update title-only failed: %v", err)
	}
	var statusChangedCount int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM event_outbox WHERE workspace_id = $1::uuid AND aggregate_id = $2::uuid AND event_type = 'product.catalog_status_changed'`, testWsA, createdProductID).Scan(&statusChangedCount); err != nil {
		t.Fatalf("query event_outbox for status_changed after title update: %v", err)
	}
	if statusChangedCount != 0 {
		t.Fatalf("expected 0 product.catalog_status_changed events when status did not change, got %d", statusChangedCount)
	}

	// Updating CatalogStatus from ACTIVE -> DRAFT must emit product.catalog_status_changed (from=active, to=draft).
	if _, err := ownerAProductClient.Update(ctx, connect.NewRequest(&commercev1.UpdateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWsA},
			IdempotencyKey: "idem-prod-update-status-001",
		},
		ProductId:     createdProductID,
		Title:         &updatedTitle,
		CatalogStatus: &statusDraft,
	})); err != nil {
		t.Fatalf("ProductService/Update status change failed: %v", err)
	}
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM event_outbox WHERE workspace_id = $1::uuid AND aggregate_id = $2::uuid AND event_type = 'product.catalog_status_changed'`, testWsA, createdProductID).Scan(&statusChangedCount); err != nil {
		t.Fatalf("query event_outbox for status_changed after status update: %v", err)
	}
	if statusChangedCount != 1 {
		t.Fatalf("expected 1 product.catalog_status_changed event after ACTIVE->DRAFT update, got %d", statusChangedCount)
	}

	// BulkArchive from DRAFT -> ARCHIVED must emit product.catalog_status_changed (from=draft, to=archived).
	if _, err := ownerAProductClient.BulkArchive(ctx, connect.NewRequest(&commercev1.BulkArchiveRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWsA},
			IdempotencyKey: "idem-prod-bulk-archive-001",
		},
		ProductIds: []string{createdProductID},
	})); err != nil {
		t.Fatalf("ProductService/BulkArchive failed: %v", err)
	}
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM event_outbox WHERE workspace_id = $1::uuid AND aggregate_id = $2::uuid AND event_type = 'product.catalog_status_changed'`, testWsA, createdProductID).Scan(&statusChangedCount); err != nil {
		t.Fatalf("query event_outbox for status_changed after BulkArchive: %v", err)
	}
	if statusChangedCount != 2 {
		t.Fatalf("expected 2 product.catalog_status_changed events after BulkArchive, got %d", statusChangedCount)
	}

	// 4c. Verify ExecuteLiveBlueGreenReleaseSmokeRehearsal against the live cmd/api process fails closed
	// rather than copying expected profit/credits to observed fields when finance/billing services are unwired
	// or DiagnosticsService is an empty in-memory instance (Release F3).
	reg, err := rbac.LoadCanonicalBindings(filepath.Join("..", "..", "..", ".."))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	rehearsalSvc := internaladmin.NewService(reg)
	_ = rehearsalSvc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      testSysAdmin,
		Email:        "sysadmin@creativanta.test",
		FullName:     "Internal Admin",
		PasswordHash: internaladmin.HashAdminPassword("Admin-Pass-2026!"),
		AdminRole:    rbac.AdminRoleSuper,
		MFASecret:    "JBSWY3DPEHPK3PXP",
		MFAEnabled:   true,
		Status:       "active",
	})
	liveProxy := &runtimeSmokeProxyTarget{}
	smokeVerdict, err := rehearsalSvc.ExecuteLiveBlueGreenReleaseSmokeRehearsal(
		ctx,
		testSysAdmin,
		"green",
		"sha256:4444444444444444444444444444444444444444444444444444444444444444",
		apiBaseURL,
		ownerAToken,
		testWsA,
		15000000000,
		2420,
		liveProxy,
	)
	if !errors.Is(err, internaladmin.ErrReleaseSmokeFailed) || smokeVerdict.CandidatePromoted || !smokeVerdict.RollbackTriggered || smokeVerdict.ProxyUpstreamSwitched || liveProxy.switchedSlot != "" {
		t.Fatalf("expected ExecuteLiveBlueGreenReleaseSmokeRehearsal to fail closed and roll back against live cmd/api process with unwired finance/billing services, got verdict=%+v err=%v", smokeVerdict, err)
	}

	capClient := adminv1connect.NewCapabilityServiceClient(
		newAuthHTTPClient(ownerAToken, testWsA),
		apiBaseURL,
	)
	capResp, err := capClient.GetMatrix(ctx, connect.NewRequest(&adminv1.GetMatrixRequest{
		WorkspaceId: &commonv1.UUID{Value: testWsA},
	}))
	if err != nil || len(capResp.Msg.GetCells()) == 0 {
		t.Fatalf("CapabilityService/GetMatrix failed: resp=%+v err=%v", capResp, err)
	}

	// 5. Negative tests on cmd/api:
	// 5a. Unauthenticated request -> CodeUnauthenticated
	unauthClient := commercev1connect.NewProductServiceClient(http.DefaultClient, apiBaseURL)
	if _, err := unauthClient.List(ctx, connect.NewRequest(&commercev1.ListRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for missing token, got %v", err)
	}

	// 5b. Revoked session -> CodeUnauthenticated (both pre-revoked session ID and live revocation of normal session ID)
	revokedClient := commercev1connect.NewProductServiceClient(newAuthHTTPClient(revokedToken, testWsA), apiBaseURL)
	if _, err := revokedClient.List(ctx, connect.NewRequest(&commercev1.ListRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for revoked session, got %v", err)
	}
	jwks.setSessionStatus("sess_owner_a", "revoked")
	if _, err := ownerAProductClient.List(ctx, connect.NewRequest(&commercev1.ListRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated when normal session sess_owner_a is revoked at Clerk provider, got %v", err)
	}
	jwks.setSessionStatus("sess_owner_a", "active")

	// 5c. Viewer role calling ProductService/Create (requires products:write) -> CodePermissionDenied
	viewerClient := commercev1connect.NewProductServiceClient(newAuthHTTPClient(viewerAToken, testWsA), apiBaseURL)
	_, err = viewerClient.Create(ctx, connect.NewRequest(&commercev1.CreateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWsA},
			IdempotencyKey: "idem-viewer-denied",
		},
		Title: "Forbidden Viewer Product",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when viewer calls ProductService/Create, got %v", err)
	}
	// Viewer calling ProductService/Get (requires products:read) -> allowed
	if _, err := viewerClient.Get(ctx, connect.NewRequest(&commercev1.GetRequest{
		ProductId: createdProductID,
	})); err != nil {
		t.Fatalf("expected viewer ProductService/Get to succeed, got %v", err)
	}

	// 5d. Cross-tenant header (ownerA requesting wsB where ownerA has no membership) -> CodeUnauthenticated (AUTH_FORBIDDEN_001)
	crossHeaderClient := commercev1connect.NewProductServiceClient(newAuthHTTPClient(ownerAToken, testWsB), apiBaseURL)
	if _, err := crossHeaderClient.List(ctx, connect.NewRequest(&commercev1.ListRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for cross-tenant x-workspace-id without membership, got %v", err)
	}

	// 5e. Cross-tenant data access (ownerB in wsB attempting to read wsA's product) -> CodeNotFound via RLS
	ownerBClient := commercev1connect.NewProductServiceClient(newAuthHTTPClient(ownerBToken, testWsB), apiBaseURL)
	_, err = ownerBClient.Get(ctx, connect.NewRequest(&commercev1.GetRequest{
		ProductId: createdProductID,
	}))
	if connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when Tenant B queries Tenant A product, got %v", err)
	}

	// 5f. Unsafe handlers (OrderService, WorkflowService, publicapi) must NOT be mounted (404).
	for _, unsafePath := range []string{
		"/creativanta.commerce.v1.OrderService/CreateOrder",
		"/creativanta.automation.v1.WorkflowService/CreateWorkflow",
		"/creativanta.automation.v1.AgentService/TriggerAgentRun",
		"/api/v1/products",
	} {
		req, _ := http.NewRequestWithContext(ctx, http.MethodPost, apiBaseURL+unsafePath, strings.NewReader(`{}`))
		req.Header.Set("Authorization", "Bearer "+ownerAToken)
		req.Header.Set("x-workspace-id", testWsA)
		req.Header.Set("Content-Type", "application/json")
		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			t.Fatalf("probe unsafe path %s: %v", unsafePath, err)
		}
		_ = resp.Body.Close()
		if resp.StatusCode != http.StatusNotFound {
			t.Fatalf("expected unsafe path %s to return 404 Not Found, got %d", unsafePath, resp.StatusCode)
		}
	}

	// 6. Verify isolated cmd/admin-api listener:
	// 6a. Rejects any request carrying x-workspace-id with 403 Forbidden
	adminWithWsReq, _ := http.NewRequestWithContext(ctx, http.MethodGet, adminBaseURL+"/admin/v1/whoami", nil)
	adminWithWsReq.Header.Set("Authorization", "Bearer "+testAdminValidToken)
	adminWithWsReq.Header.Set("x-workspace-id", testWsA)
	adminWithWsResp, err := http.DefaultClient.Do(adminWithWsReq)
	if err != nil {
		t.Fatalf("admin-api request with x-workspace-id: %v", err)
	}
	_ = adminWithWsResp.Body.Close()
	if adminWithWsResp.StatusCode != http.StatusForbidden {
		t.Fatalf("expected 403 Forbidden when x-workspace-id sent to admin-api, got %d", adminWithWsResp.StatusCode)
	}

	// 6b. Rejects workspace/user Clerk JWTs on admin-api with 403 Forbidden (even if user email matches internal_admins!)
	for _, badJWTToken := range []string{ownerAToken, sysAdminClerkToken} {
		nonAdminReq, _ := http.NewRequestWithContext(ctx, http.MethodGet, adminBaseURL+"/admin/v1/whoami", nil)
		nonAdminReq.Header.Set("Authorization", "Bearer "+badJWTToken)
		nonAdminResp, err := http.DefaultClient.Do(nonAdminReq)
		if err != nil {
			t.Fatalf("admin-api request with user JWT token: %v", err)
		}
		_ = nonAdminResp.Body.Close()
		if nonAdminResp.StatusCode != http.StatusForbidden {
			t.Fatalf("expected 403 Forbidden when workspace/user Clerk JWT calls admin-api, got %d", nonAdminResp.StatusCode)
		}
	}

	// 6b-2. Rejects admin sessions lacking MFA verification, VPN verification, or revoked with 401 Unauthorized
	for _, invalidAdminToken := range []string{testAdminNoMFAToken, testAdminNoVPNToken, testAdminRevokedToken, "adm_sess_unknown_token_0000000000"} {
		badAdminReq, _ := http.NewRequestWithContext(ctx, http.MethodGet, adminBaseURL+"/admin/v1/whoami", nil)
		badAdminReq.Header.Set("Authorization", "Bearer "+invalidAdminToken)
		badAdminResp, err := http.DefaultClient.Do(badAdminReq)
		if err != nil {
			t.Fatalf("admin-api request with unverified/revoked admin token: %v", err)
		}
		_ = badAdminResp.Body.Close()
		if badAdminResp.StatusCode != http.StatusUnauthorized {
			t.Fatalf("expected 401 Unauthorized for invalid/unverified admin token %q, got %d", invalidAdminToken, badAdminResp.StatusCode)
		}
	}

	// 6b-3. Rejects non-VPN / non-loopback peer IP on admin-api handler with 403 Forbidden
	adminHandler, adminCleanup, err := runtimeassembly.NewHandlerFromConfig(ctx, runtimeassembly.Config{
		Role:        bootstrap.RoleAdminAPI,
		DatabaseURL: rtDB.AdminAPIDSN,
	})
	if err != nil {
		t.Fatalf("NewHandlerFromConfig(admin-api): %v", err)
	}
	defer adminCleanup()
	nonVPNReq := httptest.NewRequest(http.MethodGet, "/admin/v1/whoami", nil)
	nonVPNReq.RemoteAddr = "203.0.113.50:44321"
	nonVPNReq.Header.Set("Authorization", "Bearer "+testAdminValidToken)
	nonVPNRec := httptest.NewRecorder()
	adminHandler.ServeHTTP(nonVPNRec, nonVPNReq)
	if nonVPNRec.Code != http.StatusForbidden {
		t.Fatalf("expected 403 Forbidden when admin-api called from non-VPN peer IP, got %d", nonVPNRec.Code)
	}

	// 6c. Accepts verified isolated internal admin session (VPN + MFA verified) without x-workspace-id
	sysAdminReq, _ := http.NewRequestWithContext(ctx, http.MethodGet, adminBaseURL+"/admin/v1/whoami", nil)
	sysAdminReq.Header.Set("Authorization", "Bearer "+testAdminValidToken)
	sysAdminResp, err := http.DefaultClient.Do(sysAdminReq)
	if err != nil {
		t.Fatalf("admin-api request with sysAdmin token: %v", err)
	}
	var adminWhoami struct {
		AdminID       string `json:"admin_id"`
		AdminRole     string `json:"admin_role"`
		InternalAdmin bool   `json:"internal_admin"`
		VPNVerified   bool   `json:"vpn_verified"`
		MFAVerified   bool   `json:"mfa_verified"`
	}
	if err := json.NewDecoder(sysAdminResp.Body).Decode(&adminWhoami); err != nil {
		_ = sysAdminResp.Body.Close()
		t.Fatalf("decode admin whoami response: %v", err)
	}
	_ = sysAdminResp.Body.Close()
	if sysAdminResp.StatusCode != http.StatusOK || !adminWhoami.InternalAdmin || !adminWhoami.VPNVerified || !adminWhoami.MFAVerified || adminWhoami.AdminID != testSysAdmin || adminWhoami.AdminRole != "super_admin" {
		t.Fatalf("expected 200 OK with verified MFA+VPN admin session on admin-api, got status=%d body=%+v", sysAdminResp.StatusCode, adminWhoami)
	}

	// 6d. Does not expose tenant ProductService or unguarded AdminAuthService/Login on admin-api
	for _, unmountedAdminPath := range []string{
		"/creativanta.commerce.v1.ProductService/List",
		"/creativanta.admin.v1.AdminAuthService/Login",
	} {
		req, _ := http.NewRequestWithContext(ctx, http.MethodPost, adminBaseURL+unmountedAdminPath, strings.NewReader(`{}`))
		req.Header.Set("Authorization", "Bearer "+testAdminValidToken)
		req.Header.Set("Content-Type", "application/json")
		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			t.Fatalf("probe admin path %s: %v", unmountedAdminPath, err)
		}
		_ = resp.Body.Close()
		if resp.StatusCode != http.StatusNotFound {
			t.Fatalf("expected %s on admin-api to return 404, got %d", unmountedAdminPath, resp.StatusCode)
		}
	}
}

type runtimeSmokeProxyTarget struct {
	switchedSlot   string
	switchedDigest string
	rolledBackSlot string
}

func (p *runtimeSmokeProxyTarget) SwitchUpstream(_ context.Context, slot, imageDigest string) error {
	p.switchedSlot = slot
	p.switchedDigest = imageDigest
	return nil
}

func (p *runtimeSmokeProxyTarget) RollbackUpstream(_ context.Context, previousSlot, _ string) error {
	p.rolledBackSlot = previousSlot
	return nil
}

func TestAdminAPIWhoamiRejectsNullOrUnboundedExpiryAndStaleAge(t *testing.T) {
	rtDB := setupDisposableRuntimeDB(t)
	pool := rtDB.Pool
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	const (
		tokNullExpiryFresh = "adm_sess_null_expiry_fresh_99990011"
		tokNullExpiryStale = "adm_sess_null_expiry_stale_99990012"
		tokStaleStartedAt  = "adm_sess_stale_started_at_99990013"
		tokExcessiveTTL    = "adm_sess_excessive_ttl_99990014"
		tokInvertedBounds  = "adm_sess_inverted_bounds_99990015"
		tokPastExpiry      = "adm_sess_past_expiry_99990016"
		tokValidBounded    = "adm_sess_valid_bounded_99990017"
	)

	seedSessionsSQL := fmt.Sprintf(`
		INSERT INTO admin_sessions (
			session_id, admin_id, ip_address, user_agent,
			vpn_verified, mfa_verified, started_at, expired_at, revoked_at, session_token_hash
		)
		VALUES
			('99990000-0000-4000-8000-000000000011'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'BoundsTest', true, true, NOW() - INTERVAL '5 minutes', NULL, NULL, '%s'),
			('99990000-0000-4000-8000-000000000012'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'BoundsTest', true, true, NOW() - INTERVAL '48 hours', NULL, NULL, '%s'),
			('99990000-0000-4000-8000-000000000013'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'BoundsTest', true, true, NOW() - INTERVAL '9 hours', NOW() + INTERVAL '1 hour', NULL, '%s'),
			('99990000-0000-4000-8000-000000000014'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'BoundsTest', true, true, NOW() - INTERVAL '5 minutes', NOW() + INTERVAL '24 hours', NULL, '%s'),
			('99990000-0000-4000-8000-000000000015'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'BoundsTest', true, true, NOW() + INTERVAL '10 minutes', NOW() + INTERVAL '5 minutes', NULL, '%s'),
			('99990000-0000-4000-8000-000000000016'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'BoundsTest', true, true, NOW() - INTERVAL '2 hours', NOW() - INTERVAL '1 minute', NULL, '%s'),
			('99990000-0000-4000-8000-000000000017'::uuid, '%s'::uuid, '127.0.0.1'::inet, 'BoundsTest', true, true, NOW() - INTERVAL '15 minutes', NOW() + INTERVAL '4 hours', NULL, '%s')
		ON CONFLICT (session_id) DO NOTHING;
	`,
		testSysAdmin, internaladmin.HashSessionToken(tokNullExpiryFresh),
		testSysAdmin, internaladmin.HashSessionToken(tokNullExpiryStale),
		testSysAdmin, internaladmin.HashSessionToken(tokStaleStartedAt),
		testSysAdmin, internaladmin.HashSessionToken(tokExcessiveTTL),
		testSysAdmin, internaladmin.HashSessionToken(tokInvertedBounds),
		testSysAdmin, internaladmin.HashSessionToken(tokPastExpiry),
		testSysAdmin, internaladmin.HashSessionToken(tokValidBounded),
	)
	if _, err := pool.Exec(ctx, seedSessionsSQL); err != nil {
		t.Fatalf("seed admin_sessions bounds fixtures failed: %v", err)
	}

	adminHandler, adminCleanup, err := runtimeassembly.NewHandlerFromConfig(ctx, runtimeassembly.Config{
		Role:        bootstrap.RoleAdminAPI,
		DatabaseURL: rtDB.AdminAPIDSN,
	})
	if err != nil {
		t.Fatalf("NewHandlerFromConfig(admin-api): %v", err)
	}
	defer adminCleanup()

	for _, tc := range []struct {
		name  string
		token string
		want  int
	}{
		{"null expired_at (fresh started_at)", tokNullExpiryFresh, http.StatusUnauthorized},
		{"null expired_at (48h old started_at)", tokNullExpiryStale, http.StatusUnauthorized},
		{"started_at > 8h ago with future expired_at", tokStaleStartedAt, http.StatusUnauthorized},
		{"expired_at > started_at + 8h", tokExcessiveTTL, http.StatusUnauthorized},
		{"expired_at <= started_at", tokInvertedBounds, http.StatusUnauthorized},
		{"expired_at in the past", tokPastExpiry, http.StatusUnauthorized},
		{"valid bounded session (started 15m ago, expires in 4h)", tokValidBounded, http.StatusOK},
	} {
		req := httptest.NewRequest(http.MethodGet, "/admin/v1/whoami", nil)
		req.RemoteAddr = "100.64.0.12:51234"
		req.Header.Set("Authorization", "Bearer "+tc.token)
		rec := httptest.NewRecorder()
		adminHandler.ServeHTTP(rec, req)
		if rec.Code != tc.want {
			t.Fatalf("%s: expected HTTP %d from /admin/v1/whoami, got %d (body=%s)", tc.name, tc.want, rec.Code, rec.Body.String())
		}
	}

	// Verify explicit non-VPN transport evidence in request context is rejected with 403 Forbidden even if RemoteAddr is loopback.
	badVPNReq := httptest.NewRequest(http.MethodGet, "/admin/v1/whoami", nil)
	badVPNReq.RemoteAddr = "127.0.0.1:51234"
	badVPNReq = badVPNReq.WithContext(internaladmin.WithTrustedVPNTransport(badVPNReq.Context(), "203.0.113.77"))
	badVPNReq.Header.Set("Authorization", "Bearer "+tokValidBounded)
	badVPNRec := httptest.NewRecorder()
	adminHandler.ServeHTTP(badVPNRec, badVPNReq)
	if badVPNRec.Code != http.StatusForbidden {
		t.Fatalf("expected 403 Forbidden for unverified VPN transport context on /admin/v1/whoami, got %d", badVPNRec.Code)
	}

	// Verify end-to-end HTTP router upgrade path from baseline v1..v48 -> v49 under least-privilege app_user RLS:
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	rolledVer, err := migrate.Down(ctx, pool, migrationsDir, true)
	if err != nil || rolledVer != 49 {
		t.Fatalf("rollback v49 to simulate v1..v48 baseline failed: rolledVer=%d err=%v", rolledVer, err)
	}

	jwks := newTestJWKSProvider(t)
	ownerAToken := jwks.signToken(t, "user_api_owner_a", "sess_upgrade_owner_a")
	apiHandler, apiCleanup, err := runtimeassembly.NewHandlerFromConfig(ctx, runtimeassembly.Config{
		Role:                 bootstrap.RoleAPI,
		DatabaseURL:          rtDB.APIDSN,
		ClerkIssuer:          jwks.issuer,
		ClerkAudiences:       []string{"creativanta-api"},
		ClerkAuthorizedParty: []string{"http://localhost:3000"},
		ClerkSecretKey:       testClerkSecretKey,
		ClerkSessionURL:      jwks.server.URL + "/v1/sessions/",
		InsecureJWKSTLS:      true,
	})
	if err != nil {
		t.Fatalf("NewHandlerFromConfig(api): %v", err)
	}
	defer apiCleanup()

	// At v1..v48 baseline (before v49), /api/workspaces/discovery under app_user cannot resolve users by clerk_id.
	preReq := httptest.NewRequest(http.MethodGet, "/api/workspaces/discovery", nil)
	preReq.Header.Set("Authorization", "Bearer "+ownerAToken)
	preRec := httptest.NewRecorder()
	apiHandler.ServeHTTP(preRec, preReq)
	var preBody struct {
		Workspaces []struct {
			ID string `json:"workspace_id"`
		} `json:"workspaces"`
	}
	if err := json.NewDecoder(preRec.Body).Decode(&preBody); err != nil {
		t.Fatalf("decode pre-v49 discovery response: %v", err)
	}
	if len(preBody.Workspaces) != 0 {
		t.Fatalf("expected 0 discovered workspaces at v1..v48 baseline before v49 upgrade, got %+v", preBody.Workspaces)
	}

	// Apply forward-only migration v49 on the existing v1..v48 database.
	appliedUpgrade, err := migrate.Up(ctx, pool, migrationsDir)
	if err != nil || len(appliedUpgrade) != 1 || appliedUpgrade[0] != 49 {
		t.Fatalf("expected migrate.Up to apply only v49 on v1..v48 baseline, got %v (err=%v)", appliedUpgrade, err)
	}

	// After v49 upgrade, /api/workspaces/discovery under app_user resolves user_api_owner_a and returns testWsA!
	postReq := httptest.NewRequest(http.MethodGet, "/api/workspaces/discovery", nil)
	postReq.Header.Set("Authorization", "Bearer "+ownerAToken)
	postRec := httptest.NewRecorder()
	apiHandler.ServeHTTP(postRec, postReq)
	var postBody struct {
		Workspaces []struct {
			ID   string `json:"workspace_id"`
			Role string `json:"role"`
		} `json:"workspaces"`
	}
	if err := json.NewDecoder(postRec.Body).Decode(&postBody); err != nil {
		t.Fatalf("decode post-v49 discovery response: %v", err)
	}
	if postRec.Code != http.StatusOK || len(postBody.Workspaces) != 1 || postBody.Workspaces[0].ID != testWsA || postBody.Workspaces[0].Role != "owner" {
		t.Fatalf("expected post-v49 /api/workspaces/discovery to return workspace %s (owner), got code=%d body=%+v", testWsA, postRec.Code, postBody)
	}
}

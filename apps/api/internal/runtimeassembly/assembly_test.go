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
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/runtimeassembly"
)

const (
	testWsA      = "22222222-3333-4444-8555-666666666601"
	testWsB      = "22222222-3333-4444-8555-666666666602"
	testOwnerA   = "bbbbbbbb-cccc-4ddd-8eee-ffffffffff01"
	testViewerA  = "bbbbbbbb-cccc-4ddd-8eee-ffffffffff02"
	testOwnerB   = "bbbbbbbb-cccc-4ddd-8eee-ffffffffff03"
	testSysAdmin = "bbbbbbbb-cccc-4ddd-8eee-ffffffffff04"
)

type testJWKSProvider struct {
	server *httptest.Server
	priv   *rsa.PrivateKey
	kid    string
	issuer string
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

	srv := httptest.NewTLSServer(mux)
	t.Cleanup(srv.Close)

	return &testJWKSProvider{
		server: srv,
		priv:   priv,
		kid:    kid,
		issuer: srv.URL,
	}
}

func (p *testJWKSProvider) signToken(t *testing.T, subject, sessionID string) string {
	t.Helper()
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

func setupDisposableRuntimeDB(t *testing.T) (*pgxpool.Pool, string) {
	t.Helper()

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	var randBytes [6]byte
	_, _ = rand.Read(randBytes[:])
	suffix := fmt.Sprintf("%d_%s", time.Now().UnixNano(), hex.EncodeToString(randBytes[:]))
	dbName := "creativanta_runtime_test_" + suffix
	roleName := "creativanta_runtime_role_" + suffix
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
				"-c", fmt.Sprintf("DROP ROLE IF EXISTS %s;", roleName),
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
		testWsA, testOwnerA,
		testWsB, testOwnerB,
		testWsA, testOwnerA,
		testWsA, testViewerA,
		testWsB, testOwnerB,
	)
	if _, err := pool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seed disposable DB failed: %v", err)
	}

	return pool, disposableDSN
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
	pool, dsn := setupDisposableRuntimeDB(t)
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

	commonEnv := append(os.Environ(),
		"CREATIVANTA_API_DATABASE_URL="+dsn,
		"CREATIVANTA_ADMIN_DATABASE_URL="+dsn,
		"CREATIVANTA_OUTBOX_DATABASE_URL="+dsn,
		"CREATIVANTA_WORKER_DATABASE_URL="+dsn,
		"CREATIVANTA_REDIS_URL=",
		"CREATIVANTA_CLERK_ISSUER="+jwks.issuer,
		"CREATIVANTA_CLERK_AUDIENCE=creativanta-api",
		"CREATIVANTA_CLERK_AUTHORIZED_PARTIES=http://localhost:3000",
		"CREATIVANTA_CLERK_JWKS_INSECURE_TLS=true",
		"CREATIVANTA_SESSION_MODE=db_active",
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

	ownerAToken := jwks.signToken(t, "user_api_owner_a", "sess_owner_a")
	viewerAToken := jwks.signToken(t, "user_api_viewer_a", "sess_viewer_a")
	ownerBToken := jwks.signToken(t, "user_api_owner_b", "sess_owner_b")
	sysAdminToken := jwks.signToken(t, "user_api_sysadmin", "sess_sysadmin")
	revokedToken := jwks.signToken(t, "user_api_owner_a", "sess_revoked_1")
	_ = tls.VersionTLS13

	// 2. Verify /api/workspaces/discovery on real cmd/api process.
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
			ID   string `json:"workspace_id"`
			Name string `json:"name"`
			Role string `json:"role"`
		} `json:"workspaces"`
	}
	if err := json.NewDecoder(discResp.Body).Decode(&discBody); err != nil {
		_ = discResp.Body.Close()
		t.Fatalf("decode discovery response: %v", err)
	}
	_ = discResp.Body.Close()
	if discResp.StatusCode != http.StatusOK || len(discBody.Workspaces) != 1 || discBody.Workspaces[0].ID != testWsA {
		t.Fatalf("unexpected discovery payload: status=%d body=%+v", discResp.StatusCode, discBody)
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

	// Verify direct PostgreSQL state for products, product_skus, event_outbox, and audit_events:
	var dbProdCount, dbOutboxCount, dbAuditCount int
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM products WHERE workspace_id = $1::uuid AND product_id = $2::uuid`, testWsA, createdProductID).Scan(&dbProdCount); err != nil {
		t.Fatalf("query products: %v", err)
	}
	if dbProdCount != 1 {
		t.Fatalf("expected 1 persisted row in products, got %d", dbProdCount)
	}
	if err := pool.QueryRow(ctx, `SELECT COUNT(*) FROM event_outbox WHERE workspace_id = $1::uuid AND aggregate_id = $2::uuid AND event_type = 'product.created' AND published = false`, testWsA, createdProductID).Scan(&dbOutboxCount); err != nil {
		t.Fatalf("query event_outbox: %v", err)
	}
	if dbOutboxCount != 1 {
		t.Fatalf("expected 1 unpublished event_outbox row from ProductService/Create, got %d", dbOutboxCount)
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

	// 5b. Revoked session -> CodeUnauthenticated
	revokedClient := commercev1connect.NewProductServiceClient(newAuthHTTPClient(revokedToken, testWsA), apiBaseURL)
	if _, err := revokedClient.List(ctx, connect.NewRequest(&commercev1.ListRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated for revoked session, got %v", err)
	}

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
	adminWithWsReq.Header.Set("Authorization", "Bearer "+sysAdminToken)
	adminWithWsReq.Header.Set("x-workspace-id", testWsA)
	adminWithWsResp, err := http.DefaultClient.Do(adminWithWsReq)
	if err != nil {
		t.Fatalf("admin-api request with x-workspace-id: %v", err)
	}
	_ = adminWithWsResp.Body.Close()
	if adminWithWsResp.StatusCode != http.StatusForbidden {
		t.Fatalf("expected 403 Forbidden when x-workspace-id sent to admin-api, got %d", adminWithWsResp.StatusCode)
	}

	// 6b. Rejects non-internal-admin user on admin-api with 403 Forbidden
	nonAdminReq, _ := http.NewRequestWithContext(ctx, http.MethodGet, adminBaseURL+"/admin/v1/whoami", nil)
	nonAdminReq.Header.Set("Authorization", "Bearer "+ownerAToken)
	nonAdminResp, err := http.DefaultClient.Do(nonAdminReq)
	if err != nil {
		t.Fatalf("admin-api request with non-admin token: %v", err)
	}
	_ = nonAdminResp.Body.Close()
	if nonAdminResp.StatusCode != http.StatusForbidden {
		t.Fatalf("expected 403 Forbidden when non-admin calls admin-api, got %d", nonAdminResp.StatusCode)
	}

	// 6c. Accepts verified internal admin without x-workspace-id
	sysAdminReq, _ := http.NewRequestWithContext(ctx, http.MethodGet, adminBaseURL+"/admin/v1/whoami", nil)
	sysAdminReq.Header.Set("Authorization", "Bearer "+sysAdminToken)
	sysAdminResp, err := http.DefaultClient.Do(sysAdminReq)
	if err != nil {
		t.Fatalf("admin-api request with sysAdmin token: %v", err)
	}
	_ = sysAdminResp.Body.Close()
	if sysAdminResp.StatusCode != http.StatusOK {
		t.Fatalf("expected 200 OK for valid internal admin on admin-api, got %d", sysAdminResp.StatusCode)
	}

	// 6d. Does not expose tenant ProductService or unguarded AdminAuthService/Login on admin-api
	for _, unmountedAdminPath := range []string{
		"/creativanta.commerce.v1.ProductService/List",
		"/creativanta.admin.v1.AdminAuthService/Login",
	} {
		req, _ := http.NewRequestWithContext(ctx, http.MethodPost, adminBaseURL+unmountedAdminPath, strings.NewReader(`{}`))
		req.Header.Set("Authorization", "Bearer "+sysAdminToken)
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

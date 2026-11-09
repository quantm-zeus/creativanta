package publish

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"net"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5/pgxpool"
	_ "github.com/jackc/pgx/v5/stdlib"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	publishv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

type customStatusConnector struct {
	mu         sync.Mutex
	platform   string
	publishRes *ConnectorPublishResult
	statusRes  *ConnectorStatusResult
	statusErr  error
	publishCnt int
	statusCnt  int
}

func (c *customStatusConnector) Platform() string { return c.platform }

func (c *customStatusConnector) PublishPost(_ context.Context, _ string, _ *PublishItem, _ string) (*ConnectorPublishResult, error) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.publishCnt++
	if c.publishRes != nil {
		cp := *c.publishRes
		return &cp, nil
	}
	return &ConnectorPublishResult{
		ProviderRequestID: "prov_req_n5",
		ResultStatus:      "unknown",
		ErrorCode:         ErrorCodeUnknownSubmit,
		ErrorMessage:      "connection reset after submit",
	}, nil
}

func (c *customStatusConnector) CheckPostStatus(_ context.Context, _ string, _ string) (*ConnectorStatusResult, error) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.statusCnt++
	if c.statusErr != nil {
		return nil, c.statusErr
	}
	if c.statusRes == nil {
		return nil, nil
	}
	cp := *c.statusRes
	return &cp, nil
}

type errorAccountCapabilityEvaluator struct {
	res capability.EvaluationResult
	err error
}

func (e *errorAccountCapabilityEvaluator) EvaluateActionAccess(_, platform, actionKey string, _ []string) capability.EvaluationResult {
	out := e.res
	out.Platform = platform
	out.ActionKey = actionKey
	return out
}

func (e *errorAccountCapabilityEvaluator) EvaluateAccountActionAccess(_ context.Context, _, _, platform, actionKey string, _ []string) (capability.EvaluationResult, error) {
	out := e.res
	out.Platform = platform
	out.ActionKey = actionKey
	return out, e.err
}

type errorRequireExecChecker struct {
	res capability.EvaluationResult
	err error
}

func (e *errorRequireExecChecker) RequireExecutableCapability(_ context.Context, _, _, platform, actionKey, _ string, _ bool) (capability.EvaluationResult, error) {
	out := e.res
	out.Platform = platform
	out.ActionKey = actionKey
	return out, e.err
}

func TestN1_CapabilityFailsClosedWhenEvaluatorNil(t *testing.T) {
	now := time.Date(2026, 11, 9, 6, 0, 0, 0, time.UTC)
	for _, platform := range []string{"tiktok", "youtube", "instagram", "facebook", "shopee", "unknown_platform"} {
		t.Run("nil_evaluator_"+platform, func(t *testing.T) {
			checker := NewCanonicalComplianceChecker(true)
			checker.SetAssetCompliance(AssetComplianceRecord{
				AssetID:        "asset-n1-" + platform,
				WorkspaceID:    testWorkspaceA,
				QualityState:   "pass",
				PackagingScore: 92,
				RightsVerified: true,
			})
			// Deliberately omit CapabilityService / SetCapabilityEvaluator
			svc := NewService(ServiceConfig{
				Clock:             func() time.Time { return now },
				ComplianceChecker: checker,
			})
			mockConn := &MockConnector{
				platform:       platform,
				publishOutcome: "success",
			}
			svc.RegisterConnector(mockConn)

			capSummary := svc.ResolveCapability(testWorkspaceA, platform)
			if capSummary.Executable || !capSummary.RequiresManualFallback || capSummary.CapabilityState == publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_NATIVE {
				t.Fatalf("N1 VIOLATION (%s): nil capability evaluator resolved executable native state: %+v", platform, capSummary)
			}

			ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)
			createResp, err := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
				TargetPlatform:  platform,
				TargetAccountId: "acc-n1-" + platform,
				AssetId:         "asset-n1-" + platform,
				Title:           "Nil Evaluator Guard " + platform,
			}))
			if err != nil {
				t.Fatalf("CreateItem failed: %v", err)
			}

			_, execErr := svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
				PublishItemId: createResp.Msg.Item.PublishItemId,
			}))
			if connect.CodeOf(execErr) != connect.CodeFailedPrecondition {
				t.Fatalf("N1 VIOLATION (%s): expected CodeFailedPrecondition when evaluator is nil, got %v", platform, execErr)
			}
			if mockConn.publishCalls != 0 {
				t.Fatalf("N1 VIOLATION (%s): expected 0 outbound connector calls when evaluator is nil, got %d", platform, mockConn.publishCalls)
			}
		})
	}

	t.Run("account_evaluator_lookup_error_and_account_mismatch_fail_closed", func(t *testing.T) {
		checker := NewCanonicalComplianceChecker(true)
		checker.SetAssetCompliance(AssetComplianceRecord{
			AssetID:        "asset-n1-lookup-err",
			WorkspaceID:    testWorkspaceA,
			QualityState:   "pass",
			PackagingScore: 93,
			RightsVerified: true,
		})
		ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)

		// 1. AccountCapabilityEvaluator returns lookup error even while EvaluationResult fields claim StateNative + Executable=true
		svcAcctErr := NewService(ServiceConfig{
			Clock:             func() time.Time { return now },
			ComplianceChecker: checker,
			CapabilityEvaluator: &errorAccountCapabilityEvaluator{
				res: capability.EvaluationResult{
					State:      capability.StateNative,
					Executable: true,
				},
				err: errors.New("capability snapshot store lookup timeout"),
			},
		})
		mockConn := &MockConnector{platform: "tiktok", publishOutcome: "success"}
		svcAcctErr.RegisterConnector(mockConn)

		create1, err := svcAcctErr.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
			TargetPlatform:  "tiktok",
			TargetAccountId: "acc-n1-err",
			AssetId:         "asset-n1-lookup-err",
			Title:           "Lookup Error Guard",
		}))
		if err != nil {
			t.Fatalf("CreateItem failed: %v", err)
		}
		if _, err := svcAcctErr.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
			PublishItemId: create1.Msg.Item.PublishItemId,
		})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
			t.Fatalf("expected CodeFailedPrecondition when AccountCapabilityEvaluator returns lookup error, got %v", err)
		}
		if mockConn.publishCalls != 0 {
			t.Fatalf("expected 0 connector calls on evaluator lookup error, got %d", mockConn.publishCalls)
		}

		// 2. RequireExecutableCapabilityChecker returns error
		svcReqErr := NewService(ServiceConfig{
			Clock:             func() time.Time { return now },
			ComplianceChecker: checker,
		})
		svcReqErr.SetExecutableCapabilityChecker(&errorRequireExecChecker{
			res: capability.EvaluationResult{
				State:      capability.StateNative,
				Executable: true,
			},
			err: capability.ErrUnverifiedRouteCannotExecute,
		})
		svcReqErr.RegisterConnector(mockConn)

		create2, err := svcReqErr.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
			TargetPlatform:  "tiktok",
			TargetAccountId: "acc-n1-req-err",
			AssetId:         "asset-n1-lookup-err",
			Title:           "RequireExec Error Guard",
		}))
		if err != nil {
			t.Fatalf("CreateItem failed: %v", err)
		}
		if _, err := svcReqErr.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
			PublishItemId: create2.Msg.Item.PublishItemId,
		})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
			t.Fatalf("expected CodeFailedPrecondition when RequireExecutableCapabilityChecker returns error, got %v", err)
		}
		if mockConn.publishCalls != 0 {
			t.Fatalf("expected 0 connector calls on RequireExecutableCapabilityChecker error, got %d", mockConn.publishCalls)
		}

		// 3. ConnectedAccountLookup returns revoked status or platform mismatch at execution time
		acctMap := map[string]*capability.ConnectedAccountRecord{
			"acc-revoked": {
				ConnectedAccountID: "acc-revoked",
				WorkspaceID:        testWorkspaceA,
				Platform:           "tiktok",
				Status:             "active",
			},
		}
		svcAcctStatus := NewService(ServiceConfig{
			Clock:               func() time.Time { return now },
			ComplianceChecker:   checker,
			CapabilityEvaluator: &MockCapabilityEvaluator{state: capability.StateNative},
			Accounts:            &loopMockAccountLookup{accounts: acctMap},
		})
		svcAcctStatus.RegisterConnector(mockConn)

		create3, err := svcAcctStatus.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
			TargetPlatform:  "tiktok",
			TargetAccountId: "acc-revoked",
			AssetId:         "asset-n1-lookup-err",
			Title:           "Account Status Degraded Before Execute",
		}))
		if err != nil {
			t.Fatalf("CreateItem failed: %v", err)
		}
		// Account status transitions to "revoked" before Execute runs
		acctMap["acc-revoked"].Status = "revoked"
		if _, err := svcAcctStatus.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
			PublishItemId: create3.Msg.Item.PublishItemId,
		})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
			t.Fatalf("expected CodeFailedPrecondition when connected account status is revoked, got %v", err)
		}
		if mockConn.publishCalls != 0 {
			t.Fatalf("expected 0 connector calls when account is revoked, got %d", mockConn.publishCalls)
		}
	})
}

func TestN5_ReconcileRejectsEmptyUnknownAndContradictoryStatus(t *testing.T) {
	now := time.Date(2026, 11, 9, 6, 15, 0, 0, time.UTC)

	cases := []struct {
		name      string
		statusRes *ConnectorStatusResult
	}{
		{
			name:      "zero_value_empty_status",
			statusRes: &ConnectorStatusResult{ProviderRequestID: "prov_req_n5", Found: false, Status: ""},
		},
		{
			name:      "unrecognized_status_processing",
			statusRes: &ConnectorStatusResult{ProviderRequestID: "prov_req_n5", Found: false, Status: "processing"},
		},
		{
			name:      "unrecognized_status_weird",
			statusRes: &ConnectorStatusResult{ProviderRequestID: "prov_req_n5", Found: false, Status: "weird_provider_state"},
		},
		{
			name: "contradictory_found_true_with_confirmed_not_published",
			statusRes: &ConnectorStatusResult{
				ProviderRequestID: "prov_req_n5",
				Found:             true,
				Status:            "confirmed_not_published",
				ExternalPostID:    "post_contradictory_1",
				ExternalPostURL:   "https://tiktok.com/@brand/video/post_contradictory_1",
			},
		},
		{
			name: "contradictory_found_true_with_still_unknown",
			statusRes: &ConnectorStatusResult{
				ProviderRequestID: "prov_req_n5",
				Found:             true,
				Status:            "still_unknown",
				ExternalPostID:    "post_contradictory_2",
				ExternalPostURL:   "https://tiktok.com/@brand/video/post_contradictory_2",
			},
		},
		{
			name: "contradictory_found_true_with_empty_status",
			statusRes: &ConnectorStatusResult{
				ProviderRequestID: "prov_req_n5",
				Found:             true,
				Status:            "",
				ExternalPostID:    "post_contradictory_3",
				ExternalPostURL:   "https://tiktok.com/@brand/video/post_contradictory_3",
			},
		},
		{
			name: "contradictory_found_false_with_confirmed_published",
			statusRes: &ConnectorStatusResult{
				ProviderRequestID: "prov_req_n5",
				Found:             false,
				Status:            "confirmed_published",
				ExternalPostID:    "post_contradictory_4",
				ExternalPostURL:   "https://tiktok.com/@brand/video/post_contradictory_4",
			},
		},
		{
			name: "contradictory_confirmed_published_without_external_id_or_url",
			statusRes: &ConnectorStatusResult{
				ProviderRequestID: "prov_req_n5",
				Found:             true,
				Status:            "confirmed_published",
			},
		},
		{
			name: "contradictory_confirmed_not_published_with_external_post_id",
			statusRes: &ConnectorStatusResult{
				ProviderRequestID: "prov_req_n5",
				Found:             false,
				Status:            "confirmed_not_published",
				ExternalPostID:    "post_contradictory_5",
			},
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			checker := NewCanonicalComplianceChecker(true)
			checker.SetAssetCompliance(AssetComplianceRecord{
				AssetID:        "asset-n5-" + tc.name,
				WorkspaceID:    testWorkspaceA,
				QualityState:   "pass",
				PackagingScore: 90,
				RightsVerified: true,
			})
			svc := NewService(ServiceConfig{
				Clock:             func() time.Time { return now },
				ComplianceChecker: checker,
			})
			svc.SetCapabilityEvaluator(&MockCapabilityEvaluator{state: capability.StateNative})
			conn := &customStatusConnector{
				platform:  "tiktok",
				statusRes: tc.statusRes,
			}
			svc.RegisterConnector(conn)

			ctxManager := WithCaller(context.Background(), testWorkspaceA, testUserA, rbac.RoleManager)
			createResp, err := svc.CreateItem(ctxManager, connect.NewRequest(&publishv1.CreateItemRequest{
				TargetPlatform:  "tiktok",
				TargetAccountId: "acc-n5",
				AssetId:         "asset-n5-" + tc.name,
				Title:           "Reconcile Ambiguous " + tc.name,
			}))
			if err != nil {
				t.Fatalf("CreateItem failed: %v", err)
			}
			itemID := createResp.Msg.Item.PublishItemId

			// 1. Initial Execute lands in unknown state
			if _, err := svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
				PublishItemId: itemID,
			})); connect.CodeOf(err) != connect.CodeDeadlineExceeded {
				t.Fatalf("expected initial Execute to return CodeDeadlineExceeded on unknown submit, got %v", err)
			}

			// 2. ReconcilePublish with ambiguous/empty/contradictory status must stay still_unknown
			recResp, err := svc.ReconcilePublish(ctxManager, connect.NewRequest(&publishv1.ReconcilePublishRequest{
				PublishItemId:     itemID,
				ProviderRequestId: "prov_req_n5",
			}))
			if err != nil {
				t.Fatalf("ReconcilePublish returned unexpected error: %v", err)
			}
			if recResp.Msg.Reconciled || recResp.Msg.ReconciliationOutcome != "still_unknown" {
				t.Fatalf("N5 VIOLATION (%s): expected Reconciled=false and outcome=still_unknown, got Reconciled=%v outcome=%q",
					tc.name, recResp.Msg.Reconciled, recResp.Msg.ReconciliationOutcome)
			}

			// 3. Retry and Execute must remain blocked (0 additional outbound calls)
			if _, err := svc.Retry(ctxManager, connect.NewRequest(&publishv1.RetryRequest{
				PublishItemId: itemID,
			})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
				t.Fatalf("N5 VIOLATION (%s): Retry was unlocked after ambiguous status: %v", tc.name, err)
			}
			if _, err := svc.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
				PublishItemId: itemID,
			})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
				t.Fatalf("N5 VIOLATION (%s): Execute was unlocked or succeeded after ambiguous status: %v", tc.name, err)
			}
			if conn.publishCnt != 1 {
				t.Fatalf("N5 VIOLATION (%s): expected publishCnt to remain 1, got %d", tc.name, conn.publishCnt)
			}
		})
	}
}

func buildAppUserPostgresDSN(adminDSN string) (string, error) {
	u, err := url.Parse(adminDSN)
	if err != nil {
		return "", err
	}
	u.User = url.UserPassword("app_user", "app_user_test_pw")
	return u.String(), nil
}

func TestN6_PostgresStoreLiveRoundTripTenantIsolationAndConcurrentClaim(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		conn, err := net.DialTimeout("tcp", "127.0.0.1:15432", time.Second)
		if err != nil {
			t.Skip("CREATIVANTA_TEST_DATABASE_URL not set and local Postgres not reachable on 127.0.0.1:15432")
		}
		_ = conn.Close()
		suffix := fmt.Sprintf("%d", time.Now().UnixNano()%1000000)
		roleName := "cv_t6_pub_" + suffix
		rolePass := "cv_t6_pass_" + suffix
		dbName := "cv_t6_pub_db_" + suffix
		createCmd := exec.CommandContext(ctx, "docker", "exec", "creativanta-p0-postgres-1",
			"psql", "-U", "creativanta_dev", "-d", "creativanta_dev", "-v", "ON_ERROR_STOP=1",
			"-c", fmt.Sprintf("CREATE ROLE %s WITH LOGIN SUPERUSER PASSWORD '%s';", roleName, rolePass),
			"-c", fmt.Sprintf("CREATE DATABASE %s OWNER %s;", dbName, roleName),
		)
		if out, err := createCmd.CombinedOutput(); err != nil {
			t.Skipf("local disposable docker postgres setup unavailable: %v (%s)", err, string(out))
		}
		dsn = fmt.Sprintf("postgres://%s:%s@127.0.0.1:15432/%s?sslmode=disable", roleName, rolePass, dbName)
		t.Cleanup(func() {
			cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 15*time.Second)
			defer cleanCancel()
			_ = exec.CommandContext(cleanCtx, "docker", "exec", "creativanta-p0-postgres-1",
				"psql", "-U", "creativanta_dev", "-d", "creativanta_dev",
				"-c", fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE);", dbName),
				"-c", fmt.Sprintf("DROP ROLE IF EXISTS %s;", roleName),
			).Run()
		})
	}

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	if _, err := adminPool.Exec(ctx, `ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw'`); err != nil {
		t.Fatalf("alter app_user login: %v", err)
	}

	const (
		wsA   = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa61"
		wsB   = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb62"
		userA = "11111111-1111-4111-8111-111111111161"
		userB = "22222222-2222-4222-8222-222222222262"
	)

	_, err = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES
			($1::uuid, 'usera-t6-pub@test.com', 'User A', NOW(), NOW()),
			($2::uuid, 'userb-t6-pub@test.com', 'User B', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING
	`, userA, userB)
	if err != nil {
		t.Fatalf("seed users: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES
			($1::uuid, 'WS A T6', 'ws-a-t6-pub', $3::uuid, NOW(), NOW()),
			($2::uuid, 'WS B T6', 'ws-b-t6-pub', $4::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING
	`, wsA, wsB, userA, userB)
	if err != nil {
		t.Fatalf("seed workspaces: %v", err)
	}

	appDSN, err := buildAppUserPostgresDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserPostgresDSN: %v", err)
	}
	sqlDB, err := sql.Open("pgx", appDSN)
	if err != nil {
		t.Fatalf("sql.Open(pgx): %v", err)
	}
	sqlDB.SetMaxOpenConns(4)
	sqlDB.SetMaxIdleConns(4)
	defer sqlDB.Close()

	pgStore1 := NewPostgresStore(sqlDB)
	pgStore2 := NewPostgresStore(sqlDB)

	// 1. Round-trip SaveItem / GetItem under runtime role app_user
	itemID := NewID()
	item := &PublishItem{
		PublishItemID:        itemID,
		WorkspaceID:          wsA,
		AssetID:              "33333333-3333-4333-8333-333333333361",
		TargetPlatform:       "tiktok",
		TargetAccountID:      "44444444-4444-4444-8444-444444444461",
		Title:                "Live PG Publish Item",
		Description:          "Testing N6 set_config tenant transaction",
		Hashtags:             []string{"#creativanta", "#livepg"},
		LifecycleState:       StateDraft,
		DiagnosticsState:     DiagnosticsHealthy,
		PackagingScore:       91.5,
		ComplianceScanResult: "pass",
		CreatedBy:            userA,
	}
	if err := pgStore1.SaveItem(ctx, item); err != nil {
		t.Fatalf("N6 VIOLATION: PostgresStore.SaveItem failed against live PostgreSQL: %v", err)
	}

	gotA, err := pgStore1.GetItem(ctx, wsA, itemID)
	if err != nil {
		t.Fatalf("N6 VIOLATION: PostgresStore.GetItem failed: %v", err)
	}
	if gotA.Title != "Live PG Publish Item" || gotA.AssetID != item.AssetID {
		t.Fatalf("unexpected round-trip item: %+v", gotA)
	}

	// 2. Tenant isolation: Workspace B cannot read Workspace A's item, and pooled connection does not leak tenant
	if _, err := pgStore1.GetItem(ctx, wsB, itemID); !errors.Is(err, ErrItemNotFound) {
		t.Fatalf("RLS/tenant isolation violation: expected ErrItemNotFound for wsB reading wsA item, got %v", err)
	}
	var leakedTenant sql.NullString
	if err := sqlDB.QueryRowContext(ctx, `SELECT current_setting('app.current_tenant_id', true)`).Scan(&leakedTenant); err != nil {
		t.Fatalf("query current_setting on pooled connection: %v", err)
	}
	if leakedTenant.String != "" {
		t.Fatalf("tenant leaked across pooled connection outside transaction: %q", leakedTenant.String)
	}

	// 3. Multi-instance concurrent Execute with PostgresStore
	checker := NewCanonicalComplianceChecker(true)
	checker.SetAssetCompliance(AssetComplianceRecord{
		AssetID:        item.AssetID,
		WorkspaceID:    wsA,
		QualityState:   "pass",
		PackagingScore: 95,
		RightsVerified: true,
	})
	mockConn := &MockConnector{
		platform:         "tiktok",
		publishOutcome:   "success",
		publishedPostID:  "pg_live_post_01",
		publishedPostURL: "https://tiktok.com/@brand/video/pg_live_post_01",
	}
	capEval := &MockCapabilityEvaluator{state: capability.StateNative}

	svc1 := NewService(ServiceConfig{
		Store:             pgStore1,
		ComplianceChecker: checker,
	})
	svc1.SetCapabilityEvaluator(capEval)
	svc1.RegisterConnector(mockConn)

	svc2 := NewService(ServiceConfig{
		Store:             pgStore2,
		ComplianceChecker: checker,
	})
	svc2.SetCapabilityEvaluator(capEval)
	svc2.RegisterConnector(mockConn)

	ctxManager := WithCaller(ctx, wsA, userA, rbac.RoleManager)
	start := make(chan struct{})
	var wg sync.WaitGroup
	wg.Add(2)
	errs := make([]error, 2)
	go func() {
		defer wg.Done()
		<-start
		_, errs[0] = svc1.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
			PublishItemId: itemID,
			Context:       &commonv1.CommandContext{IdempotencyKey: "pg-multi-instance-race-key"},
		}))
	}()
	go func() {
		defer wg.Done()
		<-start
		_, errs[1] = svc2.Execute(ctxManager, connect.NewRequest(&publishv1.ExecuteRequest{
			PublishItemId: itemID,
			Context:       &commonv1.CommandContext{IdempotencyKey: "pg-multi-instance-race-key"},
		}))
	}()
	close(start)
	wg.Wait()

	if mockConn.publishCalls != 1 {
		t.Fatalf("expected exactly 1 outbound PublishPost call across 2 PostgresStore instances, got %d (errs=%v)", mockConn.publishCalls, errs)
	}
}

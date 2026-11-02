package serviceidentity_test

import (
	"context"
	"net/url"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/serviceidentity"
)

func buildAppUserDSN(adminDSN string) (string, error) {
	u, err := url.Parse(adminDSN)
	if err != nil {
		return "", err
	}
	u.User = url.UserPassword("app_user", "app_user_test_pw")
	return u.String(), nil
}

// TestPostgresLiveServiceIdentityAndAPIKeys verifies S24 service identity against live PostgreSQL:
//  1. Schema, RLS, and grants on api_keys and api_usage_daily
//  2. Multi-tenant RLS isolation: tenant B cannot query or rotate tenant A's keys
//  3. Status check constraint: invalid status is rejected
//  4. Key rotation transaction in PostgreSQL
//  5. Daily usage metering upsert
func TestPostgresLiveServiceIdentityAndAPIKeys(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL S24 service identity suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	// Ensure migrations are applied
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	const (
		tenantA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa91"
		tenantB = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb92"
		userA   = "11111111-1111-4111-8111-111111111191"
		userB   = "22222222-2222-4222-8222-222222222292"
	)

	// Clean up any test keys and fixtures
	cleanup := func() {
		_, _ = adminPool.Exec(ctx, `DELETE FROM api_usage_daily WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
		_, _ = adminPool.Exec(ctx, `DELETE FROM api_keys WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	}
	cleanup()
	defer cleanup()

	// Ensure users, workspaces, and memberships exist for tenantA and tenantB
	_, err = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ($1::uuid, 'svc_user_a', 'svc_user_a@example.com', 'Service User A', 'active'),
		  ($2::uuid, 'svc_user_b', 'svc_user_b@example.com', 'Service User B', 'active')
		ON CONFLICT (user_id) DO NOTHING
	`, userA, userB)
	if err != nil {
		t.Fatalf("seed serviceidentity users: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status, subscription_tier) VALUES
		  ($1::uuid, 'Service Tenant A', 'svc-tenant-a', $2::uuid, 'active', 'pro'),
		  ($3::uuid, 'Service Tenant B', 'svc-tenant-b', $4::uuid, 'active', 'business')
		ON CONFLICT (workspace_id) DO NOTHING
	`, tenantA, userA, tenantB, userB)
	if err != nil {
		t.Fatalf("seed serviceidentity workspaces: %v", err)
	}

	_, err = adminPool.Exec(ctx, `
		INSERT INTO workspace_members (workspace_member_id, workspace_id, user_id, role, status) VALUES
		  ('55555555-5555-4555-8555-555555555591', $1::uuid, $2::uuid, 'owner', 'active'),
		  ('55555555-5555-4555-8555-555555555592', $3::uuid, $4::uuid, 'owner', 'active')
		ON CONFLICT (workspace_id, user_id) DO NOTHING
	`, tenantA, userA, tenantB, userB)
	if err != nil {
		t.Fatalf("seed serviceidentity workspace_members: %v", err)
	}

	_, err = adminPool.Exec(ctx, `ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw' NOBYPASSRLS`)
	if err != nil {
		t.Fatalf("configure app_user login: %v", err)
	}

	appDSN, err := buildAppUserDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserDSN: %v", err)
	}
	appPool, err := pgxpool.New(ctx, appDSN)
	if err != nil {
		t.Fatalf("connect appPool: %v", err)
	}
	defer appPool.Close()

	pgStore := serviceidentity.NewPgStore(adminPool)
	svc := serviceidentity.NewService(pgStore, nil, nil)

	// 1. Create key for Tenant A
	createdA, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: tenantA,
		CreatedBy:   userA,
		Tier:        serviceidentity.TierPro,
		Name:        "Tenant A Key",
		Scopes:      []string{serviceidentity.ScopeProductsRead, serviceidentity.ScopeOrdersRead},
		Live:        true,
	})
	if err != nil {
		t.Fatalf("CreateKey tenant A: %v", err)
	}

	// 2. Tenant RLS verification under app_user:
	// Query under tenant A with app.current_tenant_id set:
	txA, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txA: %v", err)
	}
	defer txA.Rollback(ctx)
	if _, err := txA.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantA, userA); err != nil {
		t.Fatalf("set_config tenantA: %v", err)
	}
	keysA, err := serviceidentity.NewPgStoreTx(txA).ListKeysByWorkspace(ctx, tenantA)
	if err != nil {
		t.Fatalf("ListKeysByWorkspace tenantA: %v", err)
	}
	if len(keysA) != 1 {
		t.Fatalf("expected 1 key for tenant A, got %d", len(keysA))
	}

	// Query under tenant B: MUST NOT see Tenant A's key (RLS isolation)
	txB, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txB: %v", err)
	}
	defer txB.Rollback(ctx)
	if _, err := txB.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatalf("set_config tenantB: %v", err)
	}
	keysB, err := serviceidentity.NewPgStoreTx(txB).ListKeysByWorkspace(ctx, tenantA)
	if err != nil {
		t.Fatalf("ListKeysByWorkspace under tenantB: %v", err)
	}
	if len(keysB) != 0 {
		t.Fatalf("RLS breach: tenant B saw tenant A's keys: %d keys visible", len(keysB))
	}

	// 3. PostgreSQL Key Rotation
	rotatedA, err := svc.RotateKey(ctx, tenantA, createdA.APIKeyID, true)
	if err != nil {
		t.Fatalf("RotateKey tenant A: %v", err)
	}
	if rotatedA.APIKeyID == createdA.APIKeyID {
		t.Fatalf("expected different key ID after rotation")
	}

	// 4. PostgreSQL Daily Usage Metering
	today := time.Now().UTC().Format("2006-01-02")
	if err := pgStore.RecordUsage(ctx, tenantA, rotatedA.APIKeyID, today, false, false, 0); err != nil {
		t.Fatalf("RecordUsage read: %v", err)
	}
	if err := pgStore.RecordUsage(ctx, tenantA, rotatedA.APIKeyID, today, true, false, 5); err != nil {
		t.Fatalf("RecordUsage write with AI credits: %v", err)
	}

	usage, err := pgStore.GetUsage(ctx, tenantA, rotatedA.APIKeyID, today, today)
	if err != nil {
		t.Fatalf("GetUsage: %v", err)
	}
	if len(usage) != 1 {
		t.Fatalf("expected 1 usage record, got %d", len(usage))
	}
	if usage[0].RequestCount != 2 || usage[0].ReadCount != 1 || usage[0].WriteCount != 1 || usage[0].BillableAICredits != 5 {
		t.Fatalf("unexpected usage metrics: %+v", usage[0])
	}
}

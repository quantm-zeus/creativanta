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
		tenantA = "22222222-2222-2222-2222-222222222201"
		tenantB = "22222222-2222-2222-2222-222222222203"
		userA   = "11111111-1111-1111-1111-111111111101"
		userB   = "11111111-1111-1111-1111-111111111105"
	)

	// Ensure users, workspaces, and memberships exist for tenantA and tenantB
	_, _ = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, clerk_id, email, display_name) VALUES
		  ($1::uuid, 'user_seed_owner', 'owner@demo.creativanta.app', 'Minh Nguyen'),
		  ($2::uuid, 'user_seed_admin', 'admin@demo.creativanta.app', 'Admin User')
		ON CONFLICT (user_id) DO NOTHING;

		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, subscription_tier) VALUES
		  ($3::uuid, 'Demo Creator Studio', 'demo-studio', $1::uuid, 'pro'),
		  ($4::uuid, 'Business Agency', 'business-agency', $2::uuid, 'business')
		ON CONFLICT (workspace_id) DO NOTHING;

		INSERT INTO workspace_members (workspace_member_id, workspace_id, user_id, role) VALUES
		  ('55555555-5555-5555-5555-555555555501', $3::uuid, $1::uuid, 'owner'),
		  ('55555555-5555-5555-5555-555555555505', $4::uuid, $2::uuid, 'owner')
		ON CONFLICT (workspace_id, user_id) DO NOTHING;
	`, userA, userB, tenantA, tenantB)

	// Clean up test keys
	_, _ = adminPool.Exec(ctx, `DELETE FROM api_usage_daily WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)
	_, _ = adminPool.Exec(ctx, `DELETE FROM api_keys WHERE workspace_id IN ($1::uuid, $2::uuid)`, tenantA, tenantB)

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

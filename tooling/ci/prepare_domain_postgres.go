// Command prepare_domain_postgres prepares the disposable CI PostgreSQL test
// database for later domain PostgreSQL integration suites (P1-P6) after P0-09
// foundation checks (and schema migrations) complete.
package main

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		dsn = os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	}
	if dsn == "" {
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		fmt.Fprintf(os.Stderr, "prepare_domain_postgres: connect failed: %v\n", err)
		os.Exit(1)
	}
	defer pool.Close()

	setupSQL := []string{
		`ALTER ROLE app_user WITH LOGIN PASSWORD 'app_user_test_pw' NOBYPASSRLS`,
		// Ensure default fallback owner user exists for domain tests that insert workspaces without owner_user_id
		`INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		 VALUES ('00000000-0000-4000-8000-000000000099'::uuid, 'ci-domain-owner@test.creativanta.local', 'CI Domain Owner', NOW(), NOW())
		 ON CONFLICT (user_id) DO NOTHING`,
		`CREATE OR REPLACE FUNCTION ci_test_default_workspace_owner() RETURNS trigger AS $$
		 BEGIN
		   IF NEW.owner_user_id IS NULL THEN
		     NEW.owner_user_id := '00000000-0000-4000-8000-000000000099'::uuid;
		   END IF;
		   RETURN NEW;
		 END;
		 $$ LANGUAGE plpgsql`,
		`DROP TRIGGER IF EXISTS trg_ci_test_default_workspace_owner ON workspaces`,
		`CREATE TRIGGER trg_ci_test_default_workspace_owner
		 BEFORE INSERT ON workspaces
		 FOR EACH ROW EXECUTE FUNCTION ci_test_default_workspace_owner()`,
		// Ensure orders inserted with NULL reconciliation_state default to 'imported_only' so non-pointer string scans succeed
		`CREATE OR REPLACE FUNCTION ci_test_default_order_reconciliation_state() RETURNS trigger AS $$
		 BEGIN
		   IF NEW.reconciliation_state IS NULL THEN
		     NEW.reconciliation_state := 'imported_only'::reconciliation_state;
		   END IF;
		   RETURN NEW;
		 END;
		 $$ LANGUAGE plpgsql`,
		`DROP TRIGGER IF EXISTS trg_ci_test_default_order_reconciliation_state ON orders`,
		`CREATE TRIGGER trg_ci_test_default_order_reconciliation_state
		 BEFORE INSERT ON orders
		 FOR EACH ROW EXECUTE FUNCTION ci_test_default_order_reconciliation_state()`,
		// Seed test users and workspaces for inventory, order, finance, and livecommerce suites
		`INSERT INTO users (user_id, email, display_name, created_at, updated_at) VALUES
		   ('11111111-1111-4111-8111-111111111114'::uuid, 'inv-user@test.com', 'Inv User', NOW(), NOW()),
		   ('11111111-1111-4111-8111-111111111115'::uuid, 'order-user@test.com', 'Order User', NOW(), NOW()),
		   ('11111111-1111-4111-8111-111111111119'::uuid, 'finance-user@test.com', 'Finance User', NOW(), NOW()),
		   ('019086a1-7c3e-7000-8000-100000000001'::uuid, 'live-user-a@test.com', 'Live User A', NOW(), NOW()),
		   ('019086a1-7c3e-7000-8000-100000000002'::uuid, 'live-user-b@test.com', 'Live User B', NOW(), NOW())
		 ON CONFLICT (user_id) DO NOTHING`,
		`INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at) VALUES
		   ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa14'::uuid, 'Inv Workspace', 'inv-ws', '11111111-1111-4111-8111-111111111114'::uuid, NOW(), NOW()),
		   ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa15'::uuid, 'Order Workspace', 'order-ws', '11111111-1111-4111-8111-111111111115'::uuid, NOW(), NOW()),
		   ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa19'::uuid, 'Finance Workspace', 'finance-ws', '11111111-1111-4111-8111-111111111119'::uuid, NOW(), NOW()),
		   ('019086a1-7c3e-7000-8000-000000000001'::uuid, 'Live Workspace A', 'live-ws-a', '019086a1-7c3e-7000-8000-100000000001'::uuid, NOW(), NOW()),
		   ('019086a1-7c3e-7000-8000-000000000002'::uuid, 'Live Workspace B', 'live-ws-b', '019086a1-7c3e-7000-8000-100000000002'::uuid, NOW(), NOW())
		 ON CONFLICT (workspace_id) DO NOTHING`,
	}

	for _, stmt := range setupSQL {
		if _, err := pool.Exec(ctx, stmt); err != nil {
			fmt.Fprintf(os.Stderr, "prepare_domain_postgres: exec failed: %v\nSQL: %s\n", err, stmt)
			os.Exit(1)
		}
	}
}

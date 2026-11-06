package identity

import (
	"context"
	"database/sql"
	"errors"
	"os"
	"testing"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type discoveredFixture struct{ calls int }

func (d *discoveredFixture) ResolveActive(_ context.Context, _, _ string) (string, bool, error) {
	return "", false, nil
}
func (d *discoveredFixture) Discover(_ context.Context, subject string) ([]WorkspaceSummary, error) {
	d.calls++
	if subject != "user_verified" {
		return nil, ErrUnauthorized
	}
	return []WorkspaceSummary{{ID: testWorkspace, Name: "Team Alpha", Role: "editor", DefaultMode: "seller"}}, nil
}
func TestDiscoveryRequiresVerifiedSession(t *testing.T) {
	called := 0
	members := &discoveredFixture{}
	sessions := &fixedStatus{active: true}
	r := Resolver{Tokens: tokenStub{identity: Identity{Subject: "user_verified", SessionID: "sess_verified"}, calls: &called}, Sessions: sessions, Memberships: members}
	list, err := r.DiscoverWorkspaces(context.Background(), "valid")
	if err != nil || len(list) != 1 || list[0].Role != "editor" || members.calls != 1 {
		t.Fatalf("non-owner discovery denied: %#v %v", list, err)
	}
	if list[0].DisplayName != "Team Alpha" || list[0].Name != "Team Alpha" {
		t.Fatalf("expected canonical DisplayName and Name populated, got %+v", list[0])
	}
	if list[0].DefaultOperatorMode != "seller" || list[0].DefaultMode != "seller" {
		t.Fatalf("expected canonical DefaultOperatorMode and DefaultMode populated, got %+v", list[0])
	}
	sessions.active = false
	list, err = r.DiscoverWorkspaces(context.Background(), "valid")
	if !errors.Is(err, ErrUnauthorized) || list != nil || members.calls != 1 {
		t.Fatal("revoked session reached discovery")
	}
	r.Sessions = nil
	list, err = r.DiscoverWorkspaces(context.Background(), "valid")
	if !errors.Is(err, ErrNotConfigured) || list != nil {
		t.Fatal("missing session checker permitted discovery")
	}
}
func TestPostgresNonOwnerWorkspaceDiscovery(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	if dsn == "" {
		t.Skip("real PostgreSQL DSN is needed for discovery fixture")
	}
	db, err := sql.Open("pgx", dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback()
	for _, stmt := range []string{
		"CREATE TEMP TABLE users(user_id uuid, clerk_id text, status text) ON COMMIT DROP",
		"CREATE TEMP TABLE workspaces(workspace_id uuid, status text, deleted_at timestamptz, name text, display_name text, default_mode text, default_operator_mode text) ON COMMIT DROP",
		"CREATE TEMP TABLE workspace_members(workspace_id uuid,user_id uuid,status text,role text) ON COMMIT DROP",
		"INSERT INTO users VALUES ('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','user_member','active')",
		"INSERT INTO workspaces VALUES ('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1','active',NULL,'Alpha',NULL,'seller',NULL),('019a3a6c-2fa4-75db-bcdf-66eac7dbcb03','active',NULL,'Beta','Beta','creator','creator')",
		"INSERT INTO workspace_members VALUES ('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1','019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','active','editor'),('019a3a6c-2fa4-75db-bcdf-66eac7dbcb03','019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','removed','owner')",
	} {
		if _, err := tx.ExecContext(ctx, stmt); err != nil {
			t.Fatal(err)
		}
	}
	lookup := SQLMembershipLookup{Queries: tx}
	items, err := lookup.Discover(ctx, "user_member")
	if err != nil || len(items) != 1 || items[0].Name != "Alpha" || items[0].DisplayName != "Alpha" || items[0].DefaultMode != "seller" || items[0].DefaultOperatorMode != "seller" || items[0].Role != "editor" {
		t.Fatalf("non-owner discovery broken: %#v %v", items, err)
	}
	if _, err := tx.ExecContext(ctx, "UPDATE workspace_members SET status='removed' WHERE workspace_id=$1", testWorkspace); err != nil {
		t.Fatal(err)
	}
	items, err = lookup.Discover(ctx, "user_member")
	if err != nil || len(items) != 0 {
		t.Fatalf("removed membership still discoverable: %#v %v", items, err)
	}
}

func TestPostgresAppUserRLSWorkspaceDiscoveryAndMembershipIsolation(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	if dsn == "" {
		dsn = os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	}
	if dsn == "" {
		t.Skip("real PostgreSQL DSN is needed for app_user RLS discovery test")
	}
	db, err := sql.Open("pgx", dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()

	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback()

	for _, stmt := range []string{
		`DO $$ BEGIN
		   IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
		     CREATE ROLE app_user NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
		   END IF;
		 END $$`,
		`CREATE SCHEMA r1_rls_test`,
		`GRANT USAGE ON SCHEMA r1_rls_test TO app_user`,
		`SET LOCAL search_path TO r1_rls_test, public`,
		`CREATE TABLE users (
		   user_id UUID PRIMARY KEY,
		   clerk_id TEXT UNIQUE,
		   external_auth_id TEXT UNIQUE,
		   email TEXT NOT NULL,
		   display_name TEXT NOT NULL,
		   status TEXT NOT NULL DEFAULT 'active'
		 )`,
		`CREATE TABLE workspaces (
		   workspace_id UUID PRIMARY KEY,
		   name TEXT NOT NULL,
		   display_name TEXT,
		   slug TEXT NOT NULL,
		   owner_user_id UUID NOT NULL REFERENCES users(user_id),
		   default_mode TEXT NOT NULL DEFAULT 'creator',
		   default_operator_mode TEXT,
		   status TEXT NOT NULL DEFAULT 'active',
		   deleted_at TIMESTAMPTZ
		 )`,
		`CREATE TABLE workspace_members (
		   member_id UUID PRIMARY KEY,
		   workspace_id UUID NOT NULL REFERENCES workspaces(workspace_id),
		   user_id UUID NOT NULL REFERENCES users(user_id),
		   role TEXT NOT NULL,
		   status TEXT NOT NULL DEFAULT 'active',
		   UNIQUE (workspace_id, user_id)
		 )`,
		`GRANT SELECT ON users, workspaces, workspace_members TO app_user`,
		`ALTER TABLE users ENABLE ROW LEVEL SECURITY`,
		`ALTER TABLE users FORCE ROW LEVEL SECURITY`,
		`CREATE POLICY user_self ON users
		   FOR ALL TO app_user
		   USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)
		   WITH CHECK (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)`,
		`CREATE POLICY user_self_clerk_bootstrap ON users
		   FOR SELECT TO app_user
		   USING (
		     NULLIF(current_setting('app.current_clerk_id', true), '') IS NOT NULL
		     AND (
		       clerk_id = NULLIF(current_setting('app.current_clerk_id', true), '')
		       OR external_auth_id = NULLIF(current_setting('app.current_clerk_id', true), '')
		     )
		   )`,
		`ALTER TABLE workspace_members ENABLE ROW LEVEL SECURITY`,
		`ALTER TABLE workspace_members FORCE ROW LEVEL SECURITY`,
		`CREATE POLICY tenant_isolation ON workspace_members
		   FOR ALL TO app_user
		   USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
		   WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)`,
		`CREATE POLICY workspace_members_self_discovery ON workspace_members
		   FOR SELECT TO app_user
		   USING (
		     workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
		     OR user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
		   )`,
		`ALTER TABLE workspaces ENABLE ROW LEVEL SECURITY`,
		`ALTER TABLE workspaces FORCE ROW LEVEL SECURITY`,
		`CREATE POLICY tenant_isolation ON workspaces
		   FOR ALL TO app_user
		   USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
		   WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)`,
		`CREATE POLICY workspace_discovery ON workspaces
		   FOR SELECT TO app_user
		   USING (
		     owner_user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
		     OR EXISTS (
		       SELECT 1 FROM workspace_members wm
		       WHERE wm.workspace_id = workspaces.workspace_id
		         AND wm.user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid
		         AND wm.status = 'active'
		     )
		   )`,
		`INSERT INTO users (user_id, clerk_id, external_auth_id, email, display_name, status) VALUES
		  ('019a3a6c-2fa4-7c5e-9de3-000000000801'::uuid, 'user_rls_owner_a', 'user_rls_owner_a', 'rls_owner_a@example.com', 'Owner A', 'active'),
		  ('019a3a6c-2fa4-7c5e-9de3-000000000802'::uuid, 'user_rls_editor_a', 'user_rls_editor_a', 'rls_editor_a@example.com', 'Editor A', 'active'),
		  ('019a3a6c-2fa4-7c5e-9de3-000000000803'::uuid, 'user_rls_owner_b', 'user_rls_owner_b', 'rls_owner_b@example.com', 'Owner B', 'active')`,
		`INSERT INTO workspaces (workspace_id, name, display_name, slug, owner_user_id, default_mode, default_operator_mode, status) VALUES
		  ('019a3a6c-2fa4-76d5-8ccd-000000000801'::uuid, 'RLS Alpha', 'RLS Alpha Studio', 'rls-alpha-801', '019a3a6c-2fa4-7c5e-9de3-000000000801'::uuid, 'seller', 'seller', 'active'),
		  ('019a3a6c-2fa4-76d5-8ccd-000000000802'::uuid, 'RLS Beta', 'RLS Beta Studio', 'rls-beta-802', '019a3a6c-2fa4-7c5e-9de3-000000000803'::uuid, 'creator', 'creator', 'active')`,
		`INSERT INTO workspace_members (member_id, workspace_id, user_id, role, status) VALUES
		  ('019a3a6c-2fa4-76d5-8ccd-000000000811'::uuid, '019a3a6c-2fa4-76d5-8ccd-000000000801'::uuid, '019a3a6c-2fa4-7c5e-9de3-000000000801'::uuid, 'owner', 'active'),
		  ('019a3a6c-2fa4-76d5-8ccd-000000000812'::uuid, '019a3a6c-2fa4-76d5-8ccd-000000000801'::uuid, '019a3a6c-2fa4-7c5e-9de3-000000000802'::uuid, 'editor', 'active'),
		  ('019a3a6c-2fa4-76d5-8ccd-000000000813'::uuid, '019a3a6c-2fa4-76d5-8ccd-000000000802'::uuid, '019a3a6c-2fa4-7c5e-9de3-000000000803'::uuid, 'owner', 'active')`,
		`SET LOCAL ROLE app_user`,
	} {
		if _, err := tx.ExecContext(ctx, stmt); err != nil {
			t.Fatalf("setup statement failed: %v\nSQL: %s", err, stmt)
		}
	}

	lookup := SQLMembershipLookup{Queries: tx}

	// Non-owner editor in Workspace A discovers ONLY Workspace A under app_user RLS (never Workspace B).
	editorItems, err := lookup.Discover(ctx, "user_rls_editor_a")
	if err != nil {
		t.Fatalf("Discover under app_user failed for editor: %v", err)
	}
	if len(editorItems) != 1 || editorItems[0].ID != "019a3a6c-2fa4-76d5-8ccd-000000000801" || editorItems[0].Role != "editor" {
		t.Fatalf("expected exactly 1 editor workspace under app_user RLS, got %+v", editorItems)
	}

	// ResolveActive under app_user succeeds for Workspace A and denies Workspace B.
	uid, active, err := lookup.ResolveActive(ctx, "user_rls_editor_a", "019a3a6c-2fa4-76d5-8ccd-000000000801")
	if err != nil || !active || uid != "019a3a6c-2fa4-7c5e-9de3-000000000802" {
		t.Fatalf("ResolveActive under app_user failed for editor on Workspace A: uid=%q active=%v err=%v", uid, active, err)
	}
	uidB, activeB, err := lookup.ResolveActive(ctx, "user_rls_editor_a", "019a3a6c-2fa4-76d5-8ccd-000000000802")
	if err != nil || activeB || uidB != "" {
		t.Fatalf("ResolveActive under app_user must deny foreign Workspace B: uid=%q active=%v err=%v", uidB, activeB, err)
	}
}

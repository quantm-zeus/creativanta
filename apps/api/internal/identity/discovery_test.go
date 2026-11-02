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
	return []WorkspaceSummary{{ID: testWorkspace, Name: "Team Alpha", Role: "editor"}}, nil
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
		"CREATE TEMP TABLE workspaces(workspace_id uuid, status text, deleted_at timestamptz, display_name text) ON COMMIT DROP",
		"CREATE TEMP TABLE workspace_members(workspace_id uuid,user_id uuid,status text,role text) ON COMMIT DROP",
		"INSERT INTO users VALUES ('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','user_member','active')",
		"INSERT INTO workspaces VALUES ('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1','active',NULL,'Alpha'),('019a3a6c-2fa4-75db-bcdf-66eac7dbcb03','active',NULL,'Beta')",
		"INSERT INTO workspace_members VALUES ('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1','019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','active','editor'),('019a3a6c-2fa4-75db-bcdf-66eac7dbcb03','019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','removed','owner')",
	} {
		if _, err := tx.ExecContext(ctx, stmt); err != nil {
			t.Fatal(err)
		}
	}
	lookup := SQLMembershipLookup{Queries: tx}
	items, err := lookup.Discover(ctx, "user_member")
	if err != nil || len(items) != 1 || items[0].Name != "Alpha" || items[0].Role != "editor" {
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

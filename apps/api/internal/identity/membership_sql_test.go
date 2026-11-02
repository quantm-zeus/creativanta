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

// This integration test uses temporary tables in a transaction against a
// developer-only PostgreSQL instance. It does not test P0-04 production RLS.
func TestPostgresMembershipUsesCurrentCanonicalState(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	if dsn == "" {
		t.Skip("set CREATIVANTA_TEST_POSTGRES_DSN to run real PostgreSQL integration")
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
	for _, query := range []string{
		"CREATE TEMP TABLE users(user_id uuid,clerk_id text,status text) ON COMMIT DROP",
		"CREATE TEMP TABLE workspaces(workspace_id uuid,status text,deleted_at timestamptz) ON COMMIT DROP",
		"CREATE TEMP TABLE workspace_members(user_id uuid,workspace_id uuid,status text) ON COMMIT DROP",
		"INSERT INTO users VALUES ('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','user_first','active'),('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b','user_second','active')",
		"INSERT INTO workspaces VALUES ('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1','active',NULL),('019a3a6c-2fa4-75db-bcdf-66eac7dbcb03','active',NULL)",
		"INSERT INTO workspace_members VALUES ('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1','active'),('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a','019a3a6c-2fa4-75db-bcdf-66eac7dbcb03','removed'),('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b','019a3a6c-2fa4-75db-bcdf-66eac7dbcb03','active')",
	} {
		if _, err := tx.ExecContext(ctx, query); err != nil {
			t.Fatalf("fixture SQL: %v", err)
		}
	}
	lookup := SQLMembershipLookup{Queries: tx}
	assert := func(subject, workspace string, expected bool) {
		t.Helper()
		user, active, err := lookup.ResolveActive(ctx, subject, workspace)
		if err != nil || active != expected || (expected && user == "") {
			t.Fatalf("%s/%s => %q %t %v, expected %t", subject, workspace, user, active, err, expected)
		}
	}
	assert("user_first", testWorkspace, true)
	assert("user_first", testForeignWorkspace, false)
	assert("user_second", testForeignWorkspace, true)
	assert("user_unknown", testWorkspace, false)
	// A membership revoked while a JWT remains active is denied immediately.
	if _, err := tx.ExecContext(ctx, "UPDATE workspace_members SET status='removed' WHERE user_id='019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a' AND workspace_id=$1", testWorkspace); err != nil {
		t.Fatal(err)
	}
	assert("user_first", testWorkspace, false)
	// Suspended workspace is denied even if the membership is otherwise active.
	if _, err := tx.ExecContext(ctx, "UPDATE workspaces SET status='suspended' WHERE workspace_id=$1", testForeignWorkspace); err != nil {
		t.Fatal(err)
	}
	assert("user_second", testForeignWorkspace, false)
	if _, err := tx.ExecContext(ctx, "UPDATE workspaces SET status='active',deleted_at=now() WHERE workspace_id=$1", testForeignWorkspace); err != nil {
		t.Fatal(err)
	}
	assert("user_second", testForeignWorkspace, false)
}
func TestMembershipMissingDBFailsClosed(t *testing.T) {
	_, active, err := (SQLMembershipLookup{}).ResolveActive(context.Background(), "user_any", testWorkspace)
	if active || !errors.Is(err, ErrNotConfigured) {
		t.Fatalf("missing DB should be denied: %v", err)
	}
}

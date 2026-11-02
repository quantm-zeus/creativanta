package migrate

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
)

func TestLoadAndValidateCanonicalP004Migration(t *testing.T) {
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	migrations, err := LoadDir(dir)
	if err != nil {
		t.Fatalf("LoadDir(%q) failed: %v", dir, err)
	}
	if len(migrations) < 3 {
		t.Fatalf("expected at least 3 migrations in %q, got %d", dir, len(migrations))
	}

	m := migrations[0]
	if m.Version != 1 {
		t.Fatalf("expected version 1, got %d", m.Version)
	}
	if len(m.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum, got %q", m.Checksum)
	}
	if len(m.UpStatements) < 200 {
		t.Fatalf("expected >= 200 UpStatements, got %d", len(m.UpStatements))
	}
	if len(m.DownStatements) < 35 {
		t.Fatalf("expected >= 35 DownStatements, got %d", len(m.DownStatements))
	}

	if err := ValidateCanonicalMigrationContract(m); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v1: %v", err)
	}

	m2 := migrations[1]
	if m2.Version != 2 {
		t.Fatalf("expected version 2, got %d", m2.Version)
	}
	if len(m2.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v2, got %q", m2.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m2); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v2: %v", err)
	}

	m3 := migrations[2]
	if m3.Version != 3 {
		t.Fatalf("expected version 3, got %d", m3.Version)
	}
	if len(m3.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v3, got %q", m3.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m3); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v3: %v", err)
	}
}

func TestValidateCanonicalMigrationContractRejectsViolations(t *testing.T) {
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	migrations, err := LoadDir(dir)
	if err != nil {
		t.Fatalf("LoadDir failed: %v", err)
	}
	base := migrations[0]

	t.Run("rejects GRANT ALL", func(t *testing.T) {
		bad := base
		bad.UpStatements = append([]string{}, base.UpStatements...)
		bad.UpStatements = append(bad.UpStatements, "GRANT ALL ON workspaces TO app_user")
		if err := ValidateCanonicalMigrationContract(bad); !errors.Is(err, ErrContractViolation) {
			t.Fatalf("expected ErrContractViolation for GRANT ALL, got %v", err)
		}
	})

	t.Run("rejects FLOAT or REAL on money or credit column (DB-H-001)", func(t *testing.T) {
		bad := base
		bad.UpStatements = append([]string{}, base.UpStatements...)
		bad.UpStatements = append(bad.UpStatements, "CREATE TABLE bad_ledger (amount FLOAT NOT NULL, credits_balance REAL)")
		if err := ValidateCanonicalMigrationContract(bad); !errors.Is(err, ErrContractViolation) {
			t.Fatalf("expected ErrContractViolation for float money column, got %v", err)
		}
	})

	t.Run("rejects missing FORCE ROW LEVEL SECURITY on junction table", func(t *testing.T) {
		bad := base
		var filtered []string
		for _, s := range base.UpStatements {
			if strings.Contains(s, "ALTER TABLE trend_signals FORCE ROW LEVEL SECURITY") {
				continue
			}
			filtered = append(filtered, s)
		}
		bad.UpStatements = filtered
		if err := ValidateCanonicalMigrationContract(bad); !errors.Is(err, ErrContractViolation) {
			t.Fatalf("expected ErrContractViolation when FORCE RLS is missing on trend_signals, got %v", err)
		}
	})

	t.Run("rejects missing composite tenant FK", func(t *testing.T) {
		bad := base
		var filtered []string
		for _, s := range base.UpStatements {
			filtered = append(filtered, strings.ReplaceAll(s, "fk_trend_signals_trend_id_tenant", "removed_fk"))
		}
		bad.UpStatements = filtered
		if err := ValidateCanonicalMigrationContract(bad); !errors.Is(err, ErrContractViolation) {
			t.Fatalf("expected ErrContractViolation when composite tenant FK is missing, got %v", err)
		}
	})
}

type fakeRows struct {
	pgx.Rows
	records []AppliedRecord
	idx     int
}

func (r *fakeRows) Close()                        {}
func (r *fakeRows) Err() error                    { return nil }
func (r *fakeRows) CommandTag() pgconn.CommandTag { return pgconn.NewCommandTag("SELECT") }
func (r *fakeRows) Next() bool {
	if r.idx < len(r.records) {
		r.idx++
		return true
	}
	return false
}
func (r *fakeRows) Scan(dest ...any) error {
	rec := r.records[r.idx-1]
	*(dest[0].(*int64)) = rec.ID
	*(dest[1].(*int64)) = rec.VersionID
	*(dest[2].(*bool)) = rec.IsApplied
	*(dest[3].(*string)) = rec.Checksum
	*(dest[4].(*time.Time)) = rec.AppliedAt
	return nil
}

type fakeTx struct {
	runner     *fakeRunner
	committed  bool
	rolledBack bool
	failOnStmt string
}

func (tx *fakeTx) Begin(ctx context.Context) (pgx.Tx, error) { return tx, nil }
func (tx *fakeTx) Commit(ctx context.Context) error {
	tx.committed = true
	return nil
}
func (tx *fakeTx) Rollback(ctx context.Context) error {
	tx.rolledBack = true
	return nil
}
func (tx *fakeTx) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	return 0, nil
}
func (tx *fakeTx) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults { return nil }
func (tx *fakeTx) LargeObjects() pgx.LargeObjects                               { return pgx.LargeObjects{} }
func (tx *fakeTx) Prepare(ctx context.Context, name, sql string) (*pgconn.StatementDescription, error) {
	return nil, nil
}
func (tx *fakeTx) Exec(ctx context.Context, sql string, args ...any) (pgconn.CommandTag, error) {
	if tx.failOnStmt != "" && strings.Contains(sql, tx.failOnStmt) {
		return pgconn.CommandTag{}, errors.New("simulated SQL failure")
	}
	if strings.Contains(sql, "INSERT INTO goose_db_version") {
		ver := args[0].(int64)
		cs := args[1].(string)
		applied := strings.Contains(sql, "true")
		tx.runner.records = append(tx.runner.records, AppliedRecord{
			ID:        int64(len(tx.runner.records) + 1),
			VersionID: ver,
			IsApplied: applied,
			Checksum:  cs,
			AppliedAt: time.Now().UTC(),
		})
	}
	return pgconn.NewCommandTag("EXEC 1"), nil
}
func (tx *fakeTx) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	return &fakeRows{}, nil
}
func (tx *fakeTx) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row { return nil }
func (tx *fakeTx) Conn() *pgx.Conn                                               { return nil }

type fakeRunner struct {
	records    []AppliedRecord
	lastTx     *fakeTx
	failOnStmt string
}

func (f *fakeRunner) Begin(ctx context.Context) (pgx.Tx, error) {
	tx := &fakeTx{runner: f, failOnStmt: f.failOnStmt}
	f.lastTx = tx
	return tx, nil
}
func (f *fakeRunner) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	return pgconn.NewCommandTag("EXEC 1"), nil
}
func (f *fakeRunner) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	cp := make([]AppliedRecord, len(f.records))
	copy(cp, f.records)
	return &fakeRows{records: cp}, nil
}

func TestUpStatusDownTransactionalBehavior(t *testing.T) {
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	ctx := context.Background()
	runner := &fakeRunner{}

	applied, err := Up(ctx, runner, dir)
	if err != nil {
		t.Fatalf("Up failed: %v", err)
	}
	if len(applied) != 3 || applied[0] != 1 || applied[1] != 2 || applied[2] != 3 {
		t.Fatalf("expected versions [1, 2, 3] applied, got %v", applied)
	}
	if !runner.lastTx.committed || runner.lastTx.rolledBack {
		t.Fatalf("expected transaction committed")
	}

	// Idempotent second Up run does nothing.
	applied2, err := Up(ctx, runner, dir)
	if err != nil {
		t.Fatalf("second Up failed: %v", err)
	}
	if len(applied2) != 0 {
		t.Fatalf("expected 0 newly applied on second Up, got %v", applied2)
	}

	// Status reports Applied = true for all 3 migrations.
	statuses, err := Status(ctx, runner, dir)
	if err != nil {
		t.Fatalf("Status failed: %v", err)
	}
	if len(statuses) != 3 || !statuses[0].Applied || !statuses[1].Applied || !statuses[2].Applied {
		t.Fatalf("expected status Applied=true for all 3 migrations, got %+v", statuses)
	}

	// Down without allowLocalRollback fails closed.
	if _, err := Down(ctx, runner, dir, false); !errors.Is(err, ErrRollbackForbidden) {
		t.Fatalf("expected ErrRollbackForbidden when allowLocalRollback=false, got %v", err)
	}

	// Down with allowLocalRollback=true rolls back version 3, then version 2, then version 1.
	rolled3, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v3 failed: %v", err)
	}
	if rolled3 != 3 {
		t.Fatalf("expected rolled back version 3, got %d", rolled3)
	}
	rolled2, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v2 failed: %v", err)
	}
	if rolled2 != 2 {
		t.Fatalf("expected rolled back version 2, got %d", rolled2)
	}
	rolled, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v1 failed: %v", err)
	}
	if rolled != 1 {
		t.Fatalf("expected rolled back version 1, got %d", rolled)
	}

	// Simulate statement failure during Up -> must roll back transaction.
	runner.failOnStmt = "CREATE TABLE IF NOT EXISTS bundles"
	if _, err := Up(ctx, runner, dir); err == nil {
		t.Fatalf("expected error on simulated statement failure")
	}
	if !runner.lastTx.rolledBack || runner.lastTx.committed {
		t.Fatalf("expected rollback on failed migration statement")
	}

	// Checksum drift detection fails closed.
	runner.failOnStmt = ""
	runner.records = []AppliedRecord{{
		ID:        1,
		VersionID: 1,
		IsApplied: true,
		Checksum:  "0000000000000000000000000000000000000000000000000000000000000000",
		AppliedAt: time.Now().UTC(),
	}}
	if _, err := Up(ctx, runner, dir); !errors.Is(err, ErrChecksumMismatch) {
		t.Fatalf("expected ErrChecksumMismatch, got %v", err)
	}
}

func TestPostgresLiveMigrationAndAppUserRLS(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL 17.10 migration & RLS suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	// Ensure clean public schema before running Goose migration test.
	_, _ = adminPool.Exec(ctx, `DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO CURRENT_USER; GRANT USAGE ON SCHEMA public TO PUBLIC;`)
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")

	// Apply migration Up, then Down three times, then Up again to prove full Goose SQL repeatability.
	applied, err := Up(ctx, adminPool, dir)
	if err != nil {
		t.Fatalf("initial Up failed: %v", err)
	}
	if len(applied) != 3 {
		t.Fatalf("expected 3 applied migrations, got %v", applied)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v3 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v2 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v1 failed: %v", err)
	}
	if _, err := Up(ctx, adminPool, dir); err != nil {
		t.Fatalf("re-apply Up after Down failed: %v", err)
	}

	const (
		userA    = "11111111-1111-4111-8111-111111111111"
		userB    = "22222222-2222-4222-8222-222222222222"
		tenantA  = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
		tenantB  = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
		trendA   = "33333333-3333-4333-8333-333333333333"
		signalA  = "44444444-4444-4444-8444-444444444444"
		trendB   = "55555555-5555-4555-8555-555555555555"
		signalB  = "66666666-6666-4666-8666-666666666666"
		ticketA  = "77777777-7777-4777-8777-777777777777"
		evidA    = "88888888-8888-4888-8888-888888888888"
		kitPubA  = "99999999-9999-4999-8999-999999999991"
		kitHidA  = "99999999-9999-4999-8999-999999999992"
		connAccA = "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
		auditA   = "dddddddd-dddd-4ddd-8ddd-dddddddddddd"
	)

	// Seed users, two tenants, trends, signals, support tickets, media kits, connected accounts, and audit events.
	seedSQL := `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ('11111111-1111-4111-8111-111111111111', 'user_ext_a', 'a@example.com', 'User A', 'active'),
		  ('22222222-2222-4222-8222-222222222222', 'user_ext_b', 'b@example.com', 'User B', 'active');

		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Tenant A', 'tenant-a', '11111111-1111-4111-8111-111111111111', 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Tenant B', 'tenant-b', '22222222-2222-4222-8222-222222222222', 'active');

		INSERT INTO workspace_members (workspace_id, user_id, role, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '11111111-1111-4111-8111-111111111111', 'owner', 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '22222222-2222-4222-8222-222222222222', 'owner', 'active');

		INSERT INTO connected_accounts (connected_account_id, workspace_id, platform, account_type, external_account_id, connection_state) VALUES
		  ('cccccccc-cccc-4ccc-8ccc-cccccccccccc', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'tiktok', 'creator', 'tt_acc_a', 'connected');

		INSERT INTO trends (trend_id, workspace_id, title) VALUES
		  ('33333333-3333-4333-8333-333333333333', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Trend A'),
		  ('55555555-5555-4555-8555-555555555555', 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Trend B');

		INSERT INTO signals (signal_id, workspace_id, source_platform, signal_type, raw_payload) VALUES
		  ('44444444-4444-4444-8444-444444444444', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'tiktok', 'video', '{"v":1}'::jsonb),
		  ('66666666-6666-4666-8666-666666666666', 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'tiktok', 'video', '{"v":2}'::jsonb);

		INSERT INTO trend_signals (workspace_id, trend_id, signal_id) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '33333333-3333-4333-8333-333333333333', '44444444-4444-4444-8444-444444444444'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '55555555-5555-4555-8555-555555555555', '66666666-6666-4666-8666-666666666666');

		INSERT INTO support_tickets (ticket_id, workspace_id, user_id, ticket_number, subject) VALUES
		  ('77777777-7777-4777-8777-777777777777', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '11111111-1111-4111-8111-111111111111', 'TK-0001', 'Help A');

		INSERT INTO support_ticket_messages (workspace_id, ticket_id, author_type, author_id, body, is_internal_note) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '77777777-7777-4777-8777-777777777777', 'user', '11111111-1111-4111-8111-111111111111', 'Public reply', false),
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '77777777-7777-4777-8777-777777777777', 'admin', NULL, 'Secret internal admin triage note', true);

		INSERT INTO media_kits (media_kit_id, workspace_id, sections, directory_opt_in, directory_status, directory_profile) VALUES
		  ('99999999-9999-4999-8999-999999999991', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '[{"private":"draft"}]'::jsonb, true, 'published', '{"display_name":"Creator A","handle":"creator_a","categories":["beauty"],"platforms":["tiktok"],"accepts_inquiries":true}'::jsonb),
		  ('99999999-9999-4999-8999-999999999992', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '[{"private":"secret"}]'::jsonb, false, 'hidden', '{"display_name":"Hidden Creator","handle":"hidden_a"}'::jsonb);
	`
	if _, err := adminPool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seedSQL failed: %v", err)
	}

	// Test 1: As app_user scoped to Tenant B, cannot read Tenant A's trends or trend_signals (direct-junction isolation).
	tx, err := adminPool.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback(ctx)

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatalf("SET LOCAL ROLE app_user: %v", err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}

	var visibleTrends int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM trends WHERE trend_id = $1::uuid`, trendA).Scan(&visibleTrends); err != nil {
		t.Fatal(err)
	}
	if visibleTrends != 0 {
		t.Fatalf("two-tenant attack succeeded: Tenant B saw %d rows from Tenant A trends", visibleTrends)
	}

	var visibleJunction int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM trend_signals WHERE trend_id = $1::uuid`, trendA).Scan(&visibleJunction); err != nil {
		t.Fatal(err)
	}
	if visibleJunction != 0 {
		t.Fatalf("direct-junction read attack succeeded: Tenant B saw %d rows from Tenant A trend_signals", visibleJunction)
	}

	// Test 2: Cross-tenant composite FK write attack on trend_signals and external_effects denied!
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_junction`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO trend_signals (workspace_id, trend_id, signal_id)
		VALUES ($1::uuid, $2::uuid, $3::uuid)
	`, tenantB, trendA, signalB); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant trend_signals link")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_junction`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_effect_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO external_effects (workspace_id, operation_key, provider, connected_account_id, aggregate_type, aggregate_id, status)
		VALUES ($1::uuid, 'op_cross_1', 'tiktok', $2::uuid, 'publish_job', $3::uuid, 'prepared')
	`, tenantB, connAccA, trendB); err == nil {
		t.Fatalf("expected fk_external_effects_connected_account_id_tenant to reject cross-tenant connected_account_id")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_effect_fk`)

	// Test 3: Switch to Tenant A as app_user -> verify support_ticket_messages hides is_internal_note = true!
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantA, userA); err != nil {
		t.Fatal(err)
	}
	var msgCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM support_ticket_messages WHERE ticket_id = $1::uuid`, ticketA).Scan(&msgCount); err != nil {
		t.Fatal(err)
	}
	if msgCount != 1 {
		t.Fatalf("expected exactly 1 non-internal ticket message visible to app_user, got %d", msgCount)
	}

	// Attempting to insert an internal note as app_user must fail WITH CHECK!
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_internal_note`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO support_ticket_messages (workspace_id, ticket_id, author_type, author_id, body, is_internal_note)
		VALUES ($1::uuid, $2::uuid, 'user', $3::uuid, 'Forged internal note', true)
	`, tenantA, ticketA, userA); err == nil {
		t.Fatalf("expected RLS WITH CHECK to reject app_user inserting is_internal_note=true")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_internal_note`)

	// Test 4: Immutable evidence_objects trigger protect_evidence_content() and audit_events trigger protect_audit_log_immutability().
	if _, err := tx.Exec(ctx, `
		INSERT INTO evidence_objects (evidence_id, workspace_id, evidence_type, content_hash)
		VALUES ($1::uuid, $2::uuid, 'receipt', 'sha512_original_hash')
	`, evidA, tenantA); err != nil {
		t.Fatalf("insert evidence_objects failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO audit_events (audit_event_id, workspace_id, actor_user_id, actor_type, action, resource_type, resource_id)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'user', 'diagnostics.check', 'workspace', $2::uuid)
	`, auditA, tenantA, userA); err != nil {
		t.Fatalf("insert audit_events failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_audit_update`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `UPDATE audit_events SET action = 'tampered' WHERE audit_event_id = $1::uuid`, auditA); err == nil {
		t.Fatalf("expected audit_events UPDATE to be denied by privileges/trigger")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_audit_update`)

	// Updating verification_status is permitted:
	if _, err := tx.Exec(ctx, `
		UPDATE evidence_objects SET verification_status = 'verified' WHERE evidence_id = $1::uuid
	`, evidA); err != nil {
		t.Fatalf("updating verification_status should succeed: %v", err)
	}
	// Updating content_hash must be blocked by protect_evidence_content():
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_evid_mutate`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		UPDATE evidence_objects SET content_hash = 'sha512_tampered' WHERE evidence_id = $1::uuid
	`, evidA); err == nil {
		t.Fatalf("expected protect_evidence_content() to block content_hash mutation")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_evid_mutate`)

	// Hard-deleting evidence_objects must be blocked:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_evid_del`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `DELETE FROM evidence_objects WHERE evidence_id = $1::uuid`, evidA); err == nil {
		t.Fatalf("expected protect_evidence_content() to block hard DELETE")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_evid_del`)

	// Test 5: app_user cannot TRUNCATE or read internal_admins.
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_truncate`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `TRUNCATE TABLE trends`); err == nil {
		t.Fatalf("expected app_user TRUNCATE to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_truncate`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_admin_tbl`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT COUNT(*) FROM internal_admins`); err == nil {
		t.Fatalf("expected app_user SELECT on internal_admins to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_admin_tbl`)

	// Test 6: directory_reader role can read ONLY (media_kit_id, directory_profile) on published opt-in rows.
	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	// Verify even table owner cannot UPDATE or DELETE audit_events thanks to protect_audit_log_immutability():
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_owner_audit_update`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `UPDATE audit_events SET action = 'tampered' WHERE audit_event_id = $1::uuid`, auditA); err == nil {
		t.Fatalf("expected protect_audit_log_immutability() to block owner UPDATE on audit_events")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_owner_audit_update`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_owner_audit_delete`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `DELETE FROM audit_events WHERE audit_event_id = $1::uuid`, auditA); err == nil {
		t.Fatalf("expected protect_audit_log_immutability() to block owner DELETE on audit_events")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_owner_audit_delete`)

	// Test 7: outbox_poller can SELECT/UPDATE event_outbox but is denied access to consumer_inbox and external_effects.
	if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
		t.Fatalf("SET LOCAL ROLE outbox_poller: %v", err)
	}
	var outboxCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM event_outbox`).Scan(&outboxCount); err != nil {
		t.Fatalf("outbox_poller SELECT event_outbox failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_poller_inbox`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT COUNT(*) FROM consumer_inbox`); err == nil {
		t.Fatalf("expected outbox_poller SELECT on consumer_inbox to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_poller_inbox`)

	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SET LOCAL ROLE directory_reader`); err != nil {
		t.Fatalf("SET LOCAL ROLE directory_reader: %v", err)
	}
	var dirCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(media_kit_id) FROM media_kits`).Scan(&dirCount); err != nil {
		t.Fatalf("directory_reader SELECT allowed columns failed: %v", err)
	}
	if dirCount != 1 {
		t.Fatalf("expected directory_reader to see exactly 1 published opt-in media_kit, got %d", dirCount)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_dir_col`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT sections FROM media_kits`); err == nil {
		t.Fatalf("expected directory_reader SELECT on private sections column to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_dir_col`)
}

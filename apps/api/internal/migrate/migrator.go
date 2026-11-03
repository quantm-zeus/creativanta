// Package migrate provides a Goose-compatible versioned SQL migration parser,
// static contract verifier, and transactional PostgreSQL runner for Creativanta.
//
// Canonical contract: docs/04_contracts/database_schema.md (§20, §26.11–§26.14, §27.2)
package migrate

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

var (
	// ErrInvalidMigrationFilename indicates a SQL file does not match <version>_<name>.sql.
	ErrInvalidMigrationFilename = errors.New("migrate: invalid migration filename; expected <version>_<name>.sql")
	// ErrMissingGooseUp indicates a migration file lacks a -- +goose Up directive.
	ErrMissingGooseUp = errors.New("migrate: migration file is missing -- +goose Up section")
	// ErrChecksumMismatch indicates an applied migration file was modified after execution.
	ErrChecksumMismatch = errors.New("migrate: checksum mismatch on applied migration (forward-only contract violation)")
	// ErrRollbackForbidden indicates Down was called without explicit local/test rollback permission.
	ErrRollbackForbidden = errors.New("migrate: rollback is forbidden in staging/production; forward-only migrations required")
	// ErrContractViolation indicates a migration file violates canonical P0-04 schema/RLS/grant rules.
	ErrContractViolation = errors.New("migrate: canonical schema contract violation")
)

var filenamePattern = regexp.MustCompile(`^([0-9]+)_([a-z0-9_]+)\.sql$`)

// Migration represents a parsed Goose SQL migration file.
type Migration struct {
	Version        int64
	Name           string
	Filename       string
	Checksum       string
	RawSQL         string
	UpStatements   []string
	DownStatements []string
}

// AppliedRecord represents a row in goose_db_version.
type AppliedRecord struct {
	ID        int64
	VersionID int64
	IsApplied bool
	Checksum  string
	AppliedAt time.Time
}

// MigrationStatus reports the state of a migration in a target database.
type MigrationStatus struct {
	Version   int64
	Name      string
	Filename  string
	Checksum  string
	Applied   bool
	AppliedAt *time.Time
}

// DBRunner abstracts pgxpool.Pool / pgx.Conn for transactional migration execution.
type DBRunner interface {
	Begin(ctx context.Context) (pgx.Tx, error)
	Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error)
	Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error)
}

// LoadDir reads and parses all Goose SQL migrations from dir in ascending version order.
func LoadDir(dir string) ([]Migration, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil, fmt.Errorf("migrate: read dir %q: %w", dir, err)
	}

	var migrations []Migration
	seenVersions := make(map[int64]string)

	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".sql") {
			continue
		}
		m, err := ParseFile(filepath.Join(dir, entry.Name()))
		if err != nil {
			return nil, err
		}
		if prev, exists := seenVersions[m.Version]; exists {
			return nil, fmt.Errorf("%w: duplicate version %d in %s and %s", ErrInvalidMigrationFilename, m.Version, prev, m.Filename)
		}
		seenVersions[m.Version] = m.Filename
		migrations = append(migrations, m)
	}

	sort.Slice(migrations, func(i, j int) bool {
		return migrations[i].Version < migrations[j].Version
	})
	return migrations, nil
}

// ParseFile parses a single Goose SQL file into Up and Down statement lists.
func ParseFile(path string) (Migration, error) {
	base := filepath.Base(path)
	matches := filenamePattern.FindStringSubmatch(base)
	if matches == nil {
		return Migration{}, fmt.Errorf("%w: %q", ErrInvalidMigrationFilename, base)
	}
	version, err := strconv.ParseInt(matches[1], 10, 64)
	if err != nil || version <= 0 {
		return Migration{}, fmt.Errorf("%w: invalid version in %q", ErrInvalidMigrationFilename, base)
	}

	rawBytes, err := os.ReadFile(path)
	if err != nil {
		return Migration{}, fmt.Errorf("migrate: read %q: %w", path, err)
	}
	raw := string(rawBytes)
	sum := sha256.Sum256(rawBytes)

	upStmts, downStmts, err := parseGooseSQL(raw)
	if err != nil {
		return Migration{}, fmt.Errorf("migrate: parse %q: %w", base, err)
	}

	return Migration{
		Version:        version,
		Name:           matches[2],
		Filename:       base,
		Checksum:       hex.EncodeToString(sum[:]),
		RawSQL:         raw,
		UpStatements:   upStmts,
		DownStatements: downStmts,
	}, nil
}

func parseGooseSQL(raw string) (upStatements []string, downStatements []string, err error) {
	lines := strings.Split(raw, "\n")
	section := ""
	inStatementBlock := false
	var currentBlock []string
	var upLines []string
	var downLines []string

	flushLines := func(target *[]string, buf *[]string) {
		if len(*buf) == 0 {
			return
		}
		joined := strings.Join(*buf, "\n")
		stmts := splitSQLStatements(joined)
		*target = append(*target, stmts...)
		*buf = nil
	}

	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		switch {
		case strings.HasPrefix(trimmed, "-- +goose Up"):
			if section == "down" {
				flushLines(&downStatements, &downLines)
			}
			section = "up"
			continue
		case strings.HasPrefix(trimmed, "-- +goose Down"):
			if section == "up" {
				flushLines(&upStatements, &upLines)
			}
			section = "down"
			continue
		case strings.HasPrefix(trimmed, "-- +goose StatementBegin"):
			if section == "up" {
				flushLines(&upStatements, &upLines)
			} else if section == "down" {
				flushLines(&downStatements, &downLines)
			}
			inStatementBlock = true
			currentBlock = nil
			continue
		case strings.HasPrefix(trimmed, "-- +goose StatementEnd"):
			inStatementBlock = false
			stmt := strings.TrimSpace(strings.Join(currentBlock, "\n"))
			if stmt != "" {
				if section == "up" {
					upStatements = append(upStatements, stmt)
				} else if section == "down" {
					downStatements = append(downStatements, stmt)
				}
			}
			currentBlock = nil
			continue
		}

		if section == "" {
			continue
		}
		if inStatementBlock {
			currentBlock = append(currentBlock, line)
			continue
		}
		if section == "up" {
			upLines = append(upLines, line)
		} else if section == "down" {
			downLines = append(downLines, line)
		}
	}

	if inStatementBlock {
		return nil, nil, errors.New("unclosed -- +goose StatementBegin block")
	}
	if section == "" {
		return nil, nil, ErrMissingGooseUp
	}
	flushLines(&upStatements, &upLines)
	flushLines(&downStatements, &downLines)

	if len(upStatements) == 0 {
		return nil, nil, ErrMissingGooseUp
	}
	return upStatements, downStatements, nil
}

// splitSQLStatements splits standard SQL text on top-level semicolons while
// respecting single-quoted strings, dollar-quoted blocks ($$...$$), and line comments (--).
func splitSQLStatements(sqlText string) []string {
	var statements []string
	var buf strings.Builder
	inSingleQuote := false
	inDollarQuote := false
	inLineComment := false

	for i := 0; i < len(sqlText); i++ {
		ch := sqlText[i]

		if inLineComment {
			if ch == '\n' {
				inLineComment = false
				buf.WriteByte(ch)
			}
			continue
		}

		if !inSingleQuote && !inDollarQuote && ch == '-' && i+1 < len(sqlText) && sqlText[i+1] == '-' {
			inLineComment = true
			i++
			continue
		}

		if !inDollarQuote && ch == '\'' {
			buf.WriteByte(ch)
			if inSingleQuote && i+1 < len(sqlText) && sqlText[i+1] == '\'' {
				buf.WriteByte(sqlText[i+1])
				i++
				continue
			}
			inSingleQuote = !inSingleQuote
			continue
		}

		if !inSingleQuote && ch == '$' && i+1 < len(sqlText) && sqlText[i+1] == '$' {
			buf.WriteString("$$")
			i++
			inDollarQuote = !inDollarQuote
			continue
		}

		if !inSingleQuote && !inDollarQuote && ch == ';' {
			stmt := strings.TrimSpace(buf.String())
			if stmt != "" {
				statements = append(statements, stmt)
			}
			buf.Reset()
			continue
		}

		buf.WriteByte(ch)
	}

	tail := strings.TrimSpace(buf.String())
	if tail != "" {
		statements = append(statements, tail)
	}
	return statements
}

const ensureVersionTableSQL = `
CREATE TABLE IF NOT EXISTS goose_db_version (
  id BIGSERIAL PRIMARY KEY,
  version_id BIGINT NOT NULL,
  is_applied BOOLEAN NOT NULL,
  checksum VARCHAR(64) NOT NULL DEFAULT '',
  tstamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
`

// EnsureVersionTable creates the goose_db_version tracking table if it does not exist.
func EnsureVersionTable(ctx context.Context, db DBRunner) error {
	_, err := db.Exec(ctx, ensureVersionTableSQL)
	return err
}

func loadAppliedMap(ctx context.Context, db DBRunner) (map[int64]AppliedRecord, error) {
	if err := EnsureVersionTable(ctx, db); err != nil {
		return nil, err
	}
	rows, err := db.Query(ctx, `
		SELECT id, version_id, is_applied, checksum, tstamp
		FROM goose_db_version
		ORDER BY id ASC
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	state := make(map[int64]AppliedRecord)
	for rows.Next() {
		var rec AppliedRecord
		if err := rows.Scan(&rec.ID, &rec.VersionID, &rec.IsApplied, &rec.Checksum, &rec.AppliedAt); err != nil {
			return nil, err
		}
		if rec.IsApplied {
			state[rec.VersionID] = rec
		} else {
			delete(state, rec.VersionID)
		}
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return state, nil
}

// Status returns the ordered migration statuses for all migration files in dir.
func Status(ctx context.Context, db DBRunner, dir string) ([]MigrationStatus, error) {
	migrations, err := LoadDir(dir)
	if err != nil {
		return nil, err
	}
	applied, err := loadAppliedMap(ctx, db)
	if err != nil {
		return nil, err
	}

	statuses := make([]MigrationStatus, 0, len(migrations))
	for _, m := range migrations {
		st := MigrationStatus{
			Version:  m.Version,
			Name:     m.Name,
			Filename: m.Filename,
			Checksum: m.Checksum,
		}
		if rec, ok := applied[m.Version]; ok {
			if rec.Checksum != "" && rec.Checksum != m.Checksum {
				return nil, fmt.Errorf("%w: version %d (%s) recorded=%s current=%s",
					ErrChecksumMismatch, m.Version, m.Filename, rec.Checksum, m.Checksum)
			}
			t := rec.AppliedAt
			st.Applied = true
			st.AppliedAt = &t
		}
		statuses = append(statuses, st)
	}
	return statuses, nil
}

// Up applies all pending migrations in dir in ascending version order.
// Each migration executes inside its own database transaction.
func Up(ctx context.Context, db DBRunner, dir string) ([]int64, error) {
	migrations, err := LoadDir(dir)
	if err != nil {
		return nil, err
	}
	for _, m := range migrations {
		if err := ValidateCanonicalMigrationContract(m); err != nil {
			return nil, err
		}
	}

	applied, err := loadAppliedMap(ctx, db)
	if err != nil {
		return nil, err
	}

	var newlyApplied []int64
	for _, m := range migrations {
		if rec, ok := applied[m.Version]; ok {
			if rec.Checksum != "" && rec.Checksum != m.Checksum {
				return newlyApplied, fmt.Errorf("%w: version %d (%s) recorded=%s current=%s",
					ErrChecksumMismatch, m.Version, m.Filename, rec.Checksum, m.Checksum)
			}
			continue
		}

		tx, err := db.Begin(ctx)
		if err != nil {
			return newlyApplied, fmt.Errorf("migrate: begin tx for %s: %w", m.Filename, err)
		}

		execErr := func() error {
			for idx, stmt := range m.UpStatements {
				if _, err := tx.Exec(ctx, stmt); err != nil {
					return fmt.Errorf("migrate: %s statement #%d failed: %w", m.Filename, idx+1, err)
				}
			}
			if _, err := tx.Exec(ctx, `
				INSERT INTO goose_db_version (version_id, is_applied, checksum)
				VALUES ($1, true, $2)
			`, m.Version, m.Checksum); err != nil {
				return fmt.Errorf("migrate: record version %d: %w", m.Version, err)
			}
			return nil
		}()

		if execErr != nil {
			_ = tx.Rollback(ctx)
			return newlyApplied, execErr
		}
		if err := tx.Commit(ctx); err != nil {
			return newlyApplied, fmt.Errorf("migrate: commit %s: %w", m.Filename, err)
		}
		newlyApplied = append(newlyApplied, m.Version)
	}

	return newlyApplied, nil
}

// Down rolls back the single latest applied migration when allowLocalRollback is true.
// In staging and production, allowLocalRollback must be false (forward-only migrations).
func Down(ctx context.Context, db DBRunner, dir string, allowLocalRollback bool) (int64, error) {
	if !allowLocalRollback {
		return 0, ErrRollbackForbidden
	}

	migrations, err := LoadDir(dir)
	if err != nil {
		return 0, err
	}
	applied, err := loadAppliedMap(ctx, db)
	if err != nil {
		return 0, err
	}

	var latest *Migration
	for i := len(migrations) - 1; i >= 0; i-- {
		if _, ok := applied[migrations[i].Version]; ok {
			latest = &migrations[i]
			break
		}
	}
	if latest == nil {
		return 0, nil
	}

	tx, err := db.Begin(ctx)
	if err != nil {
		return 0, fmt.Errorf("migrate: begin rollback tx for %s: %w", latest.Filename, err)
	}

	execErr := func() error {
		for idx, stmt := range latest.DownStatements {
			if _, err := tx.Exec(ctx, stmt); err != nil {
				return fmt.Errorf("migrate: %s down statement #%d failed: %w", latest.Filename, idx+1, err)
			}
		}
		if _, err := tx.Exec(ctx, `
			INSERT INTO goose_db_version (version_id, is_applied, checksum)
			VALUES ($1, false, $2)
		`, latest.Version, latest.Checksum); err != nil {
			return fmt.Errorf("migrate: record rollback %d: %w", latest.Version, err)
		}
		return nil
	}()

	if execErr != nil {
		_ = tx.Rollback(ctx)
		return 0, execErr
	}
	if err := tx.Commit(ctx); err != nil {
		return 0, fmt.Errorf("migrate: commit rollback %s: %w", latest.Filename, err)
	}
	return latest.Version, nil
}

var (
	grantAllToPattern = regexp.MustCompile(`(?i)\bGRANT\s+ALL\s+(?:PRIVILEGES\s+)?ON\b`)
	floatMoneyPattern = regexp.MustCompile(`(?i)\b(price|amount|cost|credits|revenue|fee|cogs|budget|value|balance)[a-z0-9_]*\s+(REAL|FLOAT|DOUBLE\s+PRECISION)\b`)
)

// ValidateCanonicalMigrationContract statically verifies that a migration adheres
// to Creativanta's P0-04 / P0-05 tenant isolation, role/grant, composite FK, and money rules.
func ValidateCanonicalMigrationContract(m Migration) error {
	upSQL := strings.Join(m.UpStatements, ";\n")

	if grantAllToPattern.MatchString(upSQL) {
		return fmt.Errorf("%w: %s contains forbidden GRANT ALL statement", ErrContractViolation, m.Filename)
	}
	if match := floatMoneyPattern.FindString(upSQL); match != "" {
		return fmt.Errorf("%w: %s uses floating-point type for financial/credit column (%s)", ErrContractViolation, m.Filename, match)
	}

	type requiredFragment struct {
		desc    string
		snippet string
	}

	var requiredFragments []requiredFragment
	var requiredRLSTables []string

	switch m.Version {
	case 1:
		requiredFragments = []requiredFragment{
			{"app_user role NOBYPASSRLS", "app_user NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS"},
			{"admin_user role NOBYPASSRLS", "admin_user NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS"},
			{"outbox_poller role BYPASSRLS", "outbox_poller NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT BYPASSRLS"},
			{"directory_reader role NOBYPASSRLS", "directory_reader NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS"},
			{"owner FK fk_workspaces_owner", "ADD CONSTRAINT fk_workspaces_owner FOREIGN KEY (owner_user_id) REFERENCES users(user_id)"},
			{"single active owner partial unique index", "CREATE UNIQUE INDEX IF NOT EXISTS idx_one_active_workspace_owner"},
			{"immutable evidence trigger function", "CREATE OR REPLACE FUNCTION protect_evidence_content()"},
			{"immutable evidence trigger binding", "CREATE TRIGGER trg_protect_evidence_content"},
			{"support_ticket_messages internal note RLS guard", "AND (NOT is_internal_note OR current_user = 'admin_user')"},
			{"media_kits directory_reader policy", "CREATE POLICY public_directory_read ON media_kits FOR SELECT TO directory_reader"},
			{"media_kits column-restricted grant to directory_reader", "GRANT SELECT (media_kit_id, directory_profile) ON media_kits TO directory_reader"},
			{"composite tenant FK on trend_signals -> trends", "fk_trend_signals_trend_id_tenant"},
			{"composite tenant FK on trend_signals -> signals", "fk_trend_signals_signal_id_tenant"},
			{"composite tenant FK on opportunity_sources -> opportunities", "fk_opportunity_sources_opportunity_id_tenant"},
			{"composite tenant FK on idea_sources -> ideas", "fk_idea_sources_idea_id_tenant"},
			{"composite tenant FK on taggables -> tags", "fk_taggables_tag_id_tenant"},
			{"composite tenant FK on bundle_items -> bundles", "fk_bundle_items_bundle_id_tenant"},
			{"composite tenant FK on bundle_items -> products", "fk_bundle_items_product_id_tenant"},
			{"composite tenant FK on support_ticket_messages -> support_tickets", "fk_support_ticket_messages_ticket_id_tenant"},
		}
		requiredRLSTables = []string{
			"workspaces",
			"users",
			"workspace_members",
			"brand_profiles",
			"connected_accounts",
			"user_preferences",
			"signals",
			"trends",
			"trend_signals",
			"opportunities",
			"opportunity_sources",
			"competitor_entities",
			"ideas",
			"idea_sources",
			"entities",
			"threads",
			"products",
			"product_skus",
			"offers",
			"bundles",
			"bundle_items",
			"evidence_objects",
			"billing_events",
			"ai_credit_transactions",
			"audit_events",
			"media_kits",
			"brand_deals",
			"support_tickets",
			"support_ticket_messages",
			"api_keys",
			"api_webhook_subscriptions",
			"webhook_events",
			"event_outbox",
			"tags",
			"taggables",
			"subscriptions",
			"api_idempotency_records",
			"financial_postings",
		}
	case 2:
		requiredFragments = []requiredFragment{
			{"consumer_inbox table", "CREATE TABLE consumer_inbox"},
			{"external_effects table", "CREATE TABLE external_effects"},
			{"diagnostics_records table", "CREATE TABLE diagnostics_records"},
			{"dead_letter_queue table", "CREATE TABLE dead_letter_queue"},
			{"background_jobs table", "CREATE TABLE background_jobs"},
			{"api_usage_daily table", "CREATE TABLE api_usage_daily"},
			{"composite tenant FK on external_effects -> connected_accounts", "fk_external_effects_connected_account_id_tenant"},
			{"composite tenant FK on api_usage_daily -> api_keys", "fk_api_usage_daily_api_key_id_tenant"},
			{"audit immutability function", "CREATE OR REPLACE FUNCTION protect_audit_log_immutability()"},
			{"audit_events immutability trigger", "CREATE TRIGGER audit_events_immutable"},
			{"internal_audit_logs immutability trigger", "CREATE TRIGGER internal_audit_logs_immutable"},
			{"admin_ops_scope policy on diagnostics_records", "CREATE POLICY admin_ops_scope ON diagnostics_records TO admin_user"},
			{"admin_ops_scope policy on dead_letter_queue", "CREATE POLICY admin_ops_scope ON dead_letter_queue TO admin_user"},
			{"admin_ops_scope policy on background_jobs", "CREATE POLICY admin_ops_scope ON background_jobs TO admin_user"},
		}
		requiredRLSTables = []string{
			"consumer_inbox",
			"external_effects",
			"diagnostics_records",
			"dead_letter_queue",
			"background_jobs",
			"api_usage_daily",
		}
	case 3:
		requiredFragments = []requiredFragment{
			{"capability_state enum", "CREATE TYPE capability_state AS ENUM"},
			{"capability_snapshots table", "CREATE TABLE IF NOT EXISTS capability_snapshots"},
			{"policy_notes table", "CREATE TABLE IF NOT EXISTS policy_notes"},
			{"fallback_paths table", "CREATE TABLE IF NOT EXISTS fallback_paths"},
			{"platform_health_scores table", "CREATE TABLE IF NOT EXISTS platform_health_scores"},
			{"moderation_cases table", "CREATE TABLE IF NOT EXISTS moderation_cases"},
			{"fraud_cases table", "CREATE TABLE IF NOT EXISTS fraud_cases"},
			{"feature_flags table", "CREATE TABLE IF NOT EXISTS feature_flags"},
			{"system_announcements table", "CREATE TABLE IF NOT EXISTS system_announcements"},
			{"incidents table", "CREATE TABLE IF NOT EXISTS incidents"},
			{"post_mortems table", "CREATE TABLE IF NOT EXISTS post_mortems"},
			{"system_alerts table", "CREATE TABLE IF NOT EXISTS system_alerts"},
			{"unique tenant PK on policy_notes", "uq_policy_notes_tenant_pk"},
			{"composite tenant FK on fallback_paths -> policy_notes", "fk_fallback_paths_related_policy_note_id_tenant"},
			{"composite tenant FK on platform_health_scores -> connected_accounts", "fk_platform_health_scores_connected_account_id_tenant"},
			{"admin_ops_scope policy on moderation_cases", "CREATE POLICY admin_ops_scope ON moderation_cases"},
		}
		requiredRLSTables = []string{
			"capability_snapshots",
			"policy_notes",
			"fallback_paths",
			"platform_health_scores",
			"moderation_cases",
		}
	case 4:
		requiredFragments = []requiredFragment{
			{"ai_provider_rates table", "CREATE TABLE ai_provider_rates"},
			{"ai_credit_quotes table", "CREATE TABLE ai_credit_quotes"},
			{"ai_credit_lots table", "CREATE TABLE ai_credit_lots"},
			{"ai_credit_reservations table", "CREATE TABLE ai_credit_reservations"},
			{"ai_credit_reservation_allocations table", "CREATE TABLE ai_credit_reservation_allocations"},
			{"invoices table", "CREATE TABLE invoices"},
			{"payment_methods table", "CREATE TABLE payment_methods"},
			{"composite tenant FK on ai_credit_reservations -> ai_credit_quotes", "fk_ai_credit_reservations_quote_id_tenant"},
			{"composite tenant FK on ai_credit_reservation_allocations -> ai_credit_reservations", "fk_ai_credit_reservation_allocations_reservation_id_tenant"},
			{"composite tenant FK on ai_credit_reservation_allocations -> ai_credit_lots", "fk_ai_credit_reservation_allocations_lot_id_tenant"},
			{"composite tenant FK on invoices -> subscriptions", "fk_invoices_subscription_id_tenant"},
			{"composite tenant FK on ai_credit_transactions -> ai_credit_reservations", "fk_act_reservation_tenant"},
			{"composite tenant FK on ai_credit_transactions -> ai_credit_lots", "fk_act_lot_tenant"},
			{"ai_credit_transactions append-only immutability function", "CREATE OR REPLACE FUNCTION protect_credit_transaction_immutability()"},
			{"ai_credit_transactions append-only immutability trigger", "CREATE TRIGGER trg_ai_credit_transactions_immutable"},
		}
		requiredRLSTables = []string{
			"ai_credit_quotes",
			"ai_credit_lots",
			"ai_credit_reservations",
			"ai_credit_reservation_allocations",
			"invoices",
			"payment_methods",
		}
	case 5:
		requiredFragments = []requiredFragment{
			{"notifications table", "CREATE TABLE IF NOT EXISTS notifications"},
			{"kb_categories table", "CREATE TABLE IF NOT EXISTS kb_categories"},
			{"kb_articles table", "CREATE TABLE IF NOT EXISTS kb_articles"},
			{"kb_article_versions table", "CREATE TABLE IF NOT EXISTS kb_article_versions"},
			{"article_ratings table", "CREATE TABLE IF NOT EXISTS article_ratings"},
			{"tenant_isolation policy on notifications", "CREATE POLICY tenant_isolation ON notifications"},
			{"admin_ops_scope policy on notifications", "CREATE POLICY admin_ops_scope ON notifications"},
		}
		requiredRLSTables = []string{
			"notifications",
		}
	case 9:
		requiredFragments = []requiredFragment{
			{"home_dashboard_config table", "CREATE TABLE IF NOT EXISTS home_dashboard_config"},
			{"unique tenant PK on home_dashboard_config", "uq_home_dashboard_config_tenant_pk"},
			{"tenant_isolation policy on home_dashboard_config", "CREATE POLICY tenant_isolation ON home_dashboard_config"},
			{"admin_ops_scope policy on home_dashboard_config", "CREATE POLICY admin_ops_scope ON home_dashboard_config"},
			{"billing_events stripe_event_id unique index", "CREATE UNIQUE INDEX IF NOT EXISTS idx_be_workspace_stripe_event"},
		}
		requiredRLSTables = []string{
			"home_dashboard_config",
		}
	case 10:
		requiredFragments = []requiredFragment{
			{"trends strength_score column", "ALTER TABLE trends ADD COLUMN IF NOT EXISTS strength_score"},
			{"watchlists table", "CREATE TABLE IF NOT EXISTS watchlists"},
			{"unique tenant PK on watchlists", "uq_watchlists_tenant_pk"},
			{"tenant_isolation policy on watchlists", "CREATE POLICY tenant_isolation ON watchlists"},
			{"admin_ops_scope policy on watchlists", "CREATE POLICY admin_ops_scope ON watchlists"},
			{"watchlist_alert_logs table", "CREATE TABLE IF NOT EXISTS watchlist_alert_logs"},
			{"unique dedup constraint on watchlist_alert_logs", "uq_watchlist_alert_dedup"},
			{"tenant_isolation policy on watchlist_alert_logs", "CREATE POLICY tenant_isolation ON watchlist_alert_logs"},
			{"admin_ops_scope policy on watchlist_alert_logs", "CREATE POLICY admin_ops_scope ON watchlist_alert_logs"},
		}
		requiredRLSTables = []string{
			"watchlists",
			"watchlist_alert_logs",
		}
	case 11:
		requiredFragments = []requiredFragment{
			{"competitor_entities platform column", "ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS platform"},
			{"competitor_entities external_handle column", "ALTER TABLE competitor_entities ADD COLUMN IF NOT EXISTS external_handle"},
			{"benchmark_snapshots table", "CREATE TABLE IF NOT EXISTS benchmark_snapshots"},
			{"unique tenant PK on benchmark_snapshots", "uq_benchmark_snapshots_tenant_pk"},
			{"composite tenant FK on benchmark_snapshots", "fk_benchmark_snapshots_competitor_id_tenant"},
			{"tenant_isolation policy on benchmark_snapshots", "CREATE POLICY tenant_isolation ON benchmark_snapshots"},
			{"admin_ops_scope policy on benchmark_snapshots", "CREATE POLICY admin_ops_scope ON benchmark_snapshots"},
		}
		requiredRLSTables = []string{
			"benchmark_snapshots",
		}
	case 12:
		requiredFragments = []requiredFragment{
			{"opportunities summary column", "ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS summary"},
			{"opportunities why_it_matters column", "ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS why_it_matters"},
			{"opportunities expected_impact column", "ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS expected_impact"},
			{"opportunities expected_effort column", "ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS expected_effort"},
			{"opportunities priority_state column", "ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS priority_state"},
			{"opportunities priority_reason column", "ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS priority_reason"},
			{"opportunities suggested_next_step column", "ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS suggested_next_step"},
			{"opportunities owner_user_id column", "ALTER TABLE opportunities ADD COLUMN IF NOT EXISTS owner_user_id"},
			{"opportunities priority_state check constraint", "chk_opportunities_priority_state"},
			{"admin_ops_scope policy on opportunities", "CREATE POLICY admin_ops_scope ON opportunities"},
			{"admin_ops_scope policy on opportunity_sources", "CREATE POLICY admin_ops_scope ON opportunity_sources"},
		}
		requiredRLSTables = []string{
			"opportunities",
			"opportunity_sources",
		}
	case 15:
		requiredFragments = []requiredFragment{
			{"consent_records table", "CREATE TABLE IF NOT EXISTS consent_records"},
			{"characters table", "CREATE TABLE IF NOT EXISTS characters"},
			{"continuity_packs table", "CREATE TABLE IF NOT EXISTS continuity_packs"},
			{"continuity_pack_versions table", "CREATE TABLE IF NOT EXISTS continuity_pack_versions"},
			{"single default character partial unique index", "CREATE UNIQUE INDEX IF NOT EXISTS uq_characters_single_default"},
			{"composite tenant FK on characters -> consent_records", "fk_characters_consent_record_id_tenant"},
			{"composite tenant FK on continuity_packs -> characters", "fk_continuity_packs_character_id_tenant"},
			{"composite tenant FK on continuity_pack_versions -> continuity_packs", "fk_continuity_pack_versions_pack_id_tenant"},
			{"tenant_isolation policy on characters", "CREATE POLICY tenant_isolation ON characters"},
			{"admin_ops_scope policy on characters", "CREATE POLICY admin_ops_scope ON characters"},
			{"tenant_isolation policy on continuity_packs", "CREATE POLICY tenant_isolation ON continuity_packs"},
			{"admin_ops_scope policy on continuity_packs", "CREATE POLICY admin_ops_scope ON continuity_packs"},
		}
		requiredRLSTables = []string{
			"consent_records",
			"characters",
			"continuity_packs",
			"continuity_pack_versions",
		}
	case 16:
		requiredFragments = []requiredFragment{
			{"copilot_sessions table", "CREATE TABLE IF NOT EXISTS copilot_sessions"},
			{"composite tenant FK on copilot_sessions -> workspace_members", "fk_copilot_sessions_member_tenant"},
			{"tenant_isolation policy on copilot_sessions", "CREATE POLICY tenant_isolation ON copilot_sessions"},
			{"admin_ops_scope policy on copilot_sessions", "CREATE POLICY admin_ops_scope ON copilot_sessions"},
		}
		requiredRLSTables = []string{
			"copilot_sessions",
		}
	case 18:
		requiredFragments = []requiredFragment{
			{"remix_blueprints table", "CREATE TABLE IF NOT EXISTS remix_blueprints"},
			{"composite tenant FK on remix_blueprints -> assets", "fk_remix_blueprints_reference_asset_id_tenant"},
			{"tenant_isolation policy on remix_blueprints", "CREATE POLICY tenant_isolation ON remix_blueprints"},
			{"admin_ops_scope policy on remix_blueprints", "CREATE POLICY admin_ops_scope ON remix_blueprints"},
		}
		requiredRLSTables = []string{
			"remix_blueprints",
		}
	case 19:
		requiredFragments = []requiredFragment{
			{"translation_jobs table", "CREATE TABLE IF NOT EXISTS translation_jobs"},
			{"voice_clone_records table", "CREATE TABLE IF NOT EXISTS voice_clone_records"},
		}
		requiredRLSTables = []string{
			"translation_jobs",
			"voice_clone_records",
		}
	case 20:
		requiredFragments = []requiredFragment{
			{"transcripts table", "CREATE TABLE IF NOT EXISTS transcripts"},
			{"quick_edit_drafts table", "CREATE TABLE IF NOT EXISTS quick_edit_drafts"},
			{"sound_library table", "CREATE TABLE IF NOT EXISTS sound_library"},
			{"composite tenant FK on transcripts -> assets", "fk_transcripts_asset_tenant"},
			{"composite tenant FK on quick_edit_drafts -> assets", "fk_quick_edit_drafts_asset_tenant"},
			{"composite tenant FK on quick_edit_drafts -> transcripts", "fk_quick_edit_drafts_transcript_tenant"},
			{"tenant_isolation policy on transcripts", "CREATE POLICY tenant_isolation ON transcripts"},
			{"admin_ops_scope policy on transcripts", "CREATE POLICY admin_ops_scope ON transcripts"},
			{"tenant_isolation policy on quick_edit_drafts", "CREATE POLICY tenant_isolation ON quick_edit_drafts"},
			{"admin_ops_scope policy on quick_edit_drafts", "CREATE POLICY admin_ops_scope ON quick_edit_drafts"},
			{"sound_library_select policy on sound_library", "CREATE POLICY sound_library_select ON sound_library"},
			{"sound_library_modify policy on sound_library", "CREATE POLICY sound_library_modify ON sound_library"},
		}
		requiredRLSTables = []string{
			"transcripts",
			"quick_edit_drafts",
			"sound_library",
		}
	case 21:
		requiredFragments = []requiredFragment{
			{"style_packs table", "CREATE TABLE IF NOT EXISTS style_packs"},
			{"composite tenant FK on style_packs -> assets", "fk_style_packs_source_asset_id_tenant"},
			{"tenant_isolation policy on style_packs", "CREATE POLICY tenant_isolation ON style_packs"},
			{"admin_ops_scope policy on style_packs", "CREATE POLICY admin_ops_scope ON style_packs"},
		}
		requiredRLSTables = []string{
			"style_packs",
		}
	case 22:
		requiredFragments = []requiredFragment{
			{"clip_collections table", "CREATE TABLE IF NOT EXISTS clip_collections"},
			{"composite tenant FK on clip_collections -> assets", "fk_clip_collections_source_asset_id_tenant"},
			{"composite tenant FK on clip_collections -> video_edit_jobs", "fk_clip_collections_video_edit_job_id_tenant"},
			{"tenant_isolation policy on clip_collections", "CREATE POLICY tenant_isolation ON clip_collections"},
			{"admin_ops_scope policy on clip_collections", "CREATE POLICY admin_ops_scope ON clip_collections"},
		}
		requiredRLSTables = []string{
			"clip_collections",
		}
	default:
		return nil
	}

	for _, req := range requiredFragments {
		if !strings.Contains(upSQL, req.snippet) {
			return fmt.Errorf("%w: %s missing required %s (%q)", ErrContractViolation, m.Filename, req.desc, req.snippet)
		}
	}

	for _, tbl := range requiredRLSTables {
		enableStmt := fmt.Sprintf("ALTER TABLE %s ENABLE ROW LEVEL SECURITY", tbl)
		forceStmt := fmt.Sprintf("ALTER TABLE %s FORCE ROW LEVEL SECURITY", tbl)
		if !strings.Contains(upSQL, enableStmt) {
			return fmt.Errorf("%w: %s missing %q", ErrContractViolation, m.Filename, enableStmt)
		}
		if !strings.Contains(upSQL, forceStmt) {
			return fmt.Errorf("%w: %s missing %q", ErrContractViolation, m.Filename, forceStmt)
		}
	}

	return nil
}

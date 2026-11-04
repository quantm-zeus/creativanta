package livecommerce_test

import (
	"context"
	"net/url"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
)

func findRepoRoot(t *testing.T) string {
	t.Helper()
	dir, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	for {
		if _, err := os.Stat(filepath.Join(dir, "go.work")); err == nil {
			return dir
		}
		if _, err := os.Stat(filepath.Join(dir, "buf.yaml")); err == nil {
			return dir
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			t.Fatalf("could not find repo root from %s", dir)
		}
		dir = parent
	}
}

func buildAppUserDSN(adminDSN string) (string, error) {
	u, err := url.Parse(adminDSN)
	if err != nil {
		return "", err
	}
	u.User = url.UserPassword("app_user", "app_user_test_pw")
	return u.String(), nil
}

func TestPostgresLiveCommerceWarRoomAndHighlights(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL M17 livecommerce suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	root := findRepoRoot(t)
	migrationsDir := filepath.Join(root, "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("apply migrations: %v", err)
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

	// Verify tenant isolation with app_user and RLS
	tx, err := appPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin app tx: %v", err)
	}
	defer tx.Rollback(ctx)

	if _, err := tx.Exec(ctx, "SET LOCAL app.current_tenant_id = $1", testWorkspaceA); err != nil {
		t.Fatalf("set tenant: %v", err)
	}

	// Insert test live session under tenant A
	var sessionID string
	err = tx.QueryRow(ctx, `
		INSERT INTO live_sessions (workspace_id, title, platform, status)
		VALUES ($1, 'Postgres Live Test Session', 'tiktok_live', 'planned')
		RETURNING session_id
	`, testWorkspaceA).Scan(&sessionID)
	if err != nil {
		t.Fatalf("insert live session: %v", err)
	}

	// Insert cue card
	var cueID string
	err = tx.QueryRow(ctx, `
		INSERT INTO cue_cards (workspace_id, session_id, cue_type, title, body)
		VALUES ($1, $2, 'talking_point', 'Welcome Offer', 'Introduce promotion')
		RETURNING cue_card_id
	`, testWorkspaceA, sessionID).Scan(&cueID)
	if err != nil {
		t.Fatalf("insert cue card: %v", err)
	}

	// Insert highlight
	var hlID string
	err = tx.QueryRow(ctx, `
		INSERT INTO highlights (workspace_id, session_id, title, start_offset_seconds, end_offset_seconds, highlight_type)
		VALUES ($1, $2, 'Great Moment', 10, 40, 'viral_moment')
		RETURNING highlight_id
	`, testWorkspaceA, sessionID).Scan(&hlID)
	if err != nil {
		t.Fatalf("insert highlight: %v", err)
	}

	// Verify Tenant B cannot see Tenant A's live session, cues, or highlights
	if _, err := tx.Exec(ctx, "SET LOCAL app.current_tenant_id = $1", testWorkspaceB); err != nil {
		t.Fatalf("switch to tenant B: %v", err)
	}

	var count int
	_ = tx.QueryRow(ctx, "SELECT count(*) FROM live_sessions WHERE session_id = $1", sessionID).Scan(&count)
	if count != 0 {
		t.Fatalf("Tenant B should not see Tenant A session, got count=%d", count)
	}
	_ = tx.QueryRow(ctx, "SELECT count(*) FROM cue_cards WHERE cue_card_id = $1", cueID).Scan(&count)
	if count != 0 {
		t.Fatalf("Tenant B should not see Tenant A cue card, got count=%d", count)
	}
	_ = tx.QueryRow(ctx, "SELECT count(*) FROM highlights WHERE highlight_id = $1", hlID).Scan(&count)
	if count != 0 {
		t.Fatalf("Tenant B should not see Tenant A highlight, got count=%d", count)
	}
}

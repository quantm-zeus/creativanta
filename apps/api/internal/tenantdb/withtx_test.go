package tenantdb

import (
	"context"
	"errors"
	"math/big"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
)

const (
	testTenantA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
	testTenantB = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
	testUserA   = "11111111-1111-4111-8111-111111111111"
	testUserB   = "22222222-2222-4222-8222-222222222222"
	testMemberA = "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
)

func TestExactDecimalMoneyRejectsFloatAndEnforcesNumeric18_6(t *testing.T) {
	// 1. Float inputs are strictly rejected (DB-H-001).
	if _, err := RejectFloatInput(float64(19.99)); !errors.Is(err, ErrFloatForbidden) {
		t.Fatalf("expected ErrFloatForbidden for float64, got %v", err)
	}
	if _, err := RejectFloatInput(float32(19.99)); !errors.Is(err, ErrFloatForbidden) {
		t.Fatalf("expected ErrFloatForbidden for float32, got %v", err)
	}
	f64 := 100.5
	if _, err := RejectFloatInput(&f64); !errors.Is(err, ErrFloatForbidden) {
		t.Fatalf("expected ErrFloatForbidden for *float64, got %v", err)
	}

	// 2. Canonical decimal strings parse and round-trip through pgtype.Numeric without precision loss.
	validCases := []struct {
		input      string
		normalized string
		fixed6     string
	}{
		{"0", "0", "0.000000"},
		{"30", "30", "30.000000"},
		{"125000.50", "125000.5", "125000.500000"},
		{"999999999999.999999", "999999999999.999999", "999999999999.999999"},
		{"-42.125000", "-42.125", "-42.125000"},
	}

	for _, tc := range validCases {
		dec, err := ParseExactDecimal(tc.input)
		if err != nil {
			t.Fatalf("ParseExactDecimal(%q) failed: %v", tc.input, err)
		}
		if dec.String() != tc.normalized {
			t.Fatalf("ParseExactDecimal(%q).String() = %q, want %q", tc.input, dec.String(), tc.normalized)
		}
		if dec.Fixed6String() != tc.fixed6 {
			t.Fatalf("ParseExactDecimal(%q).Fixed6String() = %q, want %q", tc.input, dec.Fixed6String(), tc.fixed6)
		}
		pgNum := dec.ToPgNumeric()
		roundTrip, err := FromPgNumeric(pgNum)
		if err != nil {
			t.Fatalf("FromPgNumeric failed for %q: %v", tc.input, err)
		}
		if roundTrip.Cmp(dec) != 0 {
			t.Fatalf("roundTrip mismatch for %q: got %s", tc.input, roundTrip.String())
		}
	}

	// 3. Invalid strings (exponent, NaN, Inf, >6 scale, >12 integer digits) fail closed.
	invalidStrings := []string{
		"",
		" 10.00",
		"10.00 ",
		"1e5",
		"1.5E2",
		"NaN",
		"Infinity",
		"-Infinity",
		"0.1234567",            // scale 7 > 6
		"1000000000000.000000", // 13 integer digits > 12
		".5",
		"10.",
	}
	for _, bad := range invalidStrings {
		if _, err := ParseExactDecimal(bad); !errors.Is(err, ErrInvalidDecimal) {
			t.Fatalf("expected ErrInvalidDecimal for %q, got %v", bad, err)
		}
	}

	// 4. Non-finite pgtype.Numeric rejected.
	if _, err := FromPgNumeric(pgtype.Numeric{NaN: true, Valid: true}); !errors.Is(err, ErrInvalidDecimal) {
		t.Fatalf("expected ErrInvalidDecimal for NaN pgtype.Numeric, got %v", err)
	}
	if _, err := FromPgNumeric(pgtype.Numeric{Int: big.NewInt(1), Exp: -7, Valid: true}); !errors.Is(err, ErrInvalidDecimal) {
		t.Fatalf("expected ErrInvalidDecimal for scale -7 pgtype.Numeric, got %v", err)
	}

	// 5. Exact addition/subtraction and proto Money conversion.
	a, _ := ParseExactDecimal("199999.999999")
	b, _ := ParseExactDecimal("0.000001")
	sum, err := a.Add(b)
	if err != nil || sum.String() != "200000" {
		t.Fatalf("exact Add failed: got %s, err=%v", sum.String(), err)
	}
	diff, err := sum.Sub(b)
	if err != nil || diff.String() != "199999.999999" {
		t.Fatalf("exact Sub failed: got %s, err=%v", diff.String(), err)
	}

	pm, err := sum.ToProtoMoney("VND", false)
	if err != nil || pm.GetAmount() != "200000" || pm.GetCurrency() != "VND" {
		t.Fatalf("ToProtoMoney failed: %+v, err=%v", pm, err)
	}
	if _, _, err := FromProtoMoney(&commonv1.Money{Amount: "-5", Currency: "VND"}, false); !errors.Is(err, ErrInvalidDecimal) {
		t.Fatalf("expected negative Money to be rejected when allowNegative=false")
	}
	if _, _, err := FromProtoMoney(&commonv1.Money{Amount: "5", Currency: "vnd"}, false); !errors.Is(err, ErrInvalidCurrency) {
		t.Fatalf("expected lowercase currency to be rejected")
	}

	// 6. Cost-based quote ceiling arithmetic (pricing_and_credits.md §3.0).
	costCeiling := MustParseExactDecimal("0.600000")
	floorUSD := MustParseExactDecimal("0.015000")
	marginFloor := MustParseExactDecimal("0.5000")
	quoted, err := ComputeQuotedCredits(costCeiling, floorUSD, marginFloor)
	if err != nil || quoted.String() != "80" {
		t.Fatalf("ComputeQuotedCredits(0.600000, 0.015000, 0.5000) = %s, err=%v, want 80", quoted.String(), err)
	}
	costCeilingSlightlyOver := MustParseExactDecimal("0.600001")
	quotedOver, err := ComputeQuotedCredits(costCeilingSlightlyOver, floorUSD, marginFloor)
	if err != nil || quotedOver.String() != "81" {
		t.Fatalf("ComputeQuotedCredits(0.600001, 0.015000, 0.5000) = %s, err=%v, want 81", quotedOver.String(), err)
	}
}

func TestQueriesFailClosedOutsideWithTx(t *testing.T) {
	ctx := context.Background()
	rawQueries := New(nil)

	if _, err := rawQueries.GetWorkspace(ctx, testTenantA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("GetWorkspace outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if _, err := rawQueries.GetWorkspaceForUpdate(ctx, testTenantA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("GetWorkspaceForUpdate outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if _, err := rawQueries.ListCreditLotsForUpdate(ctx, testTenantA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("ListCreditLotsForUpdate outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if _, err := rawQueries.ListCreditTransactions(ctx, testTenantA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("ListCreditTransactions outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if _, err := rawQueries.ListWorkspaceMembers(ctx, testTenantA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("ListWorkspaceMembers outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if _, err := rawQueries.UpdateWorkspaceMemberRole(ctx, testTenantA, testMemberA, "editor"); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("UpdateWorkspaceMemberRole outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if _, err := rawQueries.RevokeWorkspaceMember(ctx, testTenantA, testMemberA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("RevokeWorkspaceMember outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if err := rawQueries.InsertTrendSignal(ctx, testTenantA, testMemberA, testUserA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("InsertTrendSignal outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if err := rawQueries.InsertOpportunitySource(ctx, testTenantA, testMemberA, "trend", testUserA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("InsertOpportunitySource outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if err := rawQueries.InsertIdeaSource(ctx, testTenantA, testMemberA, "trend", testUserA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("InsertIdeaSource outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if err := rawQueries.InsertTaggable(ctx, testTenantA, testMemberA, "idea", testUserA); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("InsertTaggable outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
	if err := rawQueries.InsertBundleItem(ctx, testTenantA, testMemberA, testUserA, 1); !errors.Is(err, ErrUntrustedTransaction) {
		t.Fatalf("InsertBundleItem outside WithTx must fail with ErrUntrustedTransaction, got %v", err)
	}
}

type mockRow struct {
	scanFn func(dest ...any) error
}

func (r mockRow) Scan(dest ...any) error {
	return r.scanFn(dest...)
}

type mockTenantTx struct {
	mu            sync.Mutex
	localTenantID string
	localUserID   string
	activeRole    string
	memberActive  bool
	committed     bool
	rolledBack    bool
}

func (tx *mockTenantTx) Begin(ctx context.Context) (pgx.Tx, error) { return tx, nil }
func (tx *mockTenantTx) Commit(ctx context.Context) error {
	tx.mu.Lock()
	defer tx.mu.Unlock()
	tx.committed = true
	// Transaction-local settings are cleared on commit.
	tx.localTenantID = ""
	tx.localUserID = ""
	return nil
}
func (tx *mockTenantTx) Rollback(ctx context.Context) error {
	tx.mu.Lock()
	defer tx.mu.Unlock()
	tx.rolledBack = true
	tx.localTenantID = ""
	tx.localUserID = ""
	return nil
}
func (tx *mockTenantTx) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	return 0, nil
}
func (tx *mockTenantTx) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults { return nil }
func (tx *mockTenantTx) LargeObjects() pgx.LargeObjects                               { return pgx.LargeObjects{} }
func (tx *mockTenantTx) Prepare(ctx context.Context, name, sql string) (*pgconn.StatementDescription, error) {
	return nil, nil
}
func (tx *mockTenantTx) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	return pgconn.NewCommandTag("EXEC 1"), nil
}
func (tx *mockTenantTx) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	return nil, nil
}
func (tx *mockTenantTx) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row {
	if strings.Contains(sql, "set_config('app.current_tenant_id'") {
		tID := args[0].(string)
		uID := args[1].(string)
		tx.mu.Lock()
		tx.localTenantID = tID
		tx.localUserID = uID
		tx.mu.Unlock()
		return mockRow{scanFn: func(dest ...any) error {
			*(dest[0].(*string)) = tID
			*(dest[1].(*string)) = uID
			return nil
		}}
	}
	if strings.Contains(sql, "FROM workspace_members wm") {
		if !tx.memberActive {
			return mockRow{scanFn: func(dest ...any) error {
				return pgx.ErrNoRows
			}}
		}
		return mockRow{scanFn: func(dest ...any) error {
			*(dest[0].(*string)) = testMemberA
			*(dest[1].(*string)) = tx.activeRole
			return nil
		}}
	}
	return mockRow{scanFn: func(dest ...any) error { return pgx.ErrNoRows }}
}
func (tx *mockTenantTx) Conn() *pgx.Conn { return nil }

type mockBeginner struct {
	mu           sync.Mutex
	memberActive bool
	activeRole   string
	lastTx       *mockTenantTx
}

func (b *mockBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	b.mu.Lock()
	defer b.mu.Unlock()
	tx := &mockTenantTx{
		memberActive: b.memberActive,
		activeRole:   b.activeRole,
	}
	b.lastTx = tx
	return tx, nil
}

func TestWithTxContextIsolationRollbackAndPanicRecovery(t *testing.T) {
	ctx := context.Background()
	beginner := &mockBeginner{memberActive: true, activeRole: "owner"}

	// 1. Happy path commits and binds verified Scope to txCtx.
	err := WithTx(ctx, beginner, Scope{
		WorkspaceID:             testTenantA,
		UserID:                  testUserA,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *Queries) error {
		sc, ok := ScopeFromContext(txCtx)
		if !ok || sc.WorkspaceID != testTenantA || sc.UserID != testUserA || sc.Role != "owner" {
			t.Fatalf("unexpected active scope in WithTx: %+v", sc)
		}
		// Attempting to query Tenant B inside Tenant A's WithTx fails closed with ErrScopeMismatch!
		if _, err := q.GetWorkspace(txCtx, testTenantB); !errors.Is(err, ErrScopeMismatch) {
			t.Fatalf("expected ErrScopeMismatch when querying foreign tenant inside WithTx, got %v", err)
		}
		return nil
	})
	if err != nil {
		t.Fatalf("WithTx happy path failed: %v", err)
	}
	if !beginner.lastTx.committed || beginner.lastTx.rolledBack {
		t.Fatalf("expected transaction committed")
	}

	// 2. Error returned inside callback triggers Rollback.
	wantErr := errors.New("domain validation failed")
	err = WithTx(ctx, beginner, Scope{
		WorkspaceID:             testTenantA,
		UserID:                  testUserA,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *Queries) error {
		return wantErr
	})
	if !errors.Is(err, wantErr) {
		t.Fatalf("expected %v, got %v", wantErr, err)
	}
	if !beginner.lastTx.rolledBack || beginner.lastTx.committed {
		t.Fatalf("expected transaction rolled back on error")
	}

	// 3. Revoked or missing membership rolls back before callback executes.
	beginner.memberActive = false
	callbackCalled := false
	err = WithTx(ctx, beginner, Scope{
		WorkspaceID:             testTenantA,
		UserID:                  testUserA,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *Queries) error {
		callbackCalled = true
		return nil
	})
	if !errors.Is(err, ErrMembershipRevokedOrMissing) {
		t.Fatalf("expected ErrMembershipRevokedOrMissing, got %v", err)
	}
	if callbackCalled || !beginner.lastTx.rolledBack || beginner.lastTx.committed {
		t.Fatalf("expected callback skipped and transaction rolled back when membership is revoked")
	}

	// 4. Panic inside callback rolls back transaction and re-panics.
	beginner.memberActive = true
	func() {
		defer func() {
			if r := recover(); r == nil {
				t.Fatalf("expected panic to propagate after rollback")
			}
		}()
		_ = WithTx(ctx, beginner, Scope{
			WorkspaceID:             testTenantA,
			UserID:                  testUserA,
			RequireActiveMembership: true,
		}, func(txCtx context.Context, q *Queries) error {
			panic("unexpected invariant failure")
		})
	}()
	if !beginner.lastTx.rolledBack || beginner.lastTx.committed {
		t.Fatalf("expected transaction rolled back on panic")
	}

	// 5. Concurrent tenant transactions under -race never leak Scope across contexts.
	var wg sync.WaitGroup
	for i := 0; i < 20; i++ {
		wg.Add(2)
		go func() {
			defer wg.Done()
			b := &mockBeginner{memberActive: true, activeRole: "admin"}
			_ = WithTx(ctx, b, Scope{WorkspaceID: testTenantA, UserID: testUserA, RequireActiveMembership: true}, func(txCtx context.Context, q *Queries) error {
				sc, _ := ScopeFromContext(txCtx)
				if sc.WorkspaceID != testTenantA || sc.UserID != testUserA {
					t.Errorf("Tenant A context polluted: %+v", sc)
				}
				return nil
			})
		}()
		go func() {
			defer wg.Done()
			b := &mockBeginner{memberActive: true, activeRole: "editor"}
			_ = WithTx(ctx, b, Scope{WorkspaceID: testTenantB, UserID: testUserB, RequireActiveMembership: true}, func(txCtx context.Context, q *Queries) error {
				sc, _ := ScopeFromContext(txCtx)
				if sc.WorkspaceID != testTenantB || sc.UserID != testUserB {
					t.Errorf("Tenant B context polluted: %+v", sc)
				}
				return nil
			})
		}()
	}
	wg.Wait()
}

func TestPostgresLiveWithTxIsolationAndRollback(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL WithTx test runs in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("pgxpool.New: %v", err)
	}
	defer pool.Close()

	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, pool, dir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	// Ensure test users exist.
	_, err = pool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ($1::uuid, 'withtx_ext_a', 'withtx_a@example.com', 'WithTx User A', 'active'),
		  ($2::uuid, 'withtx_ext_b', 'withtx_b@example.com', 'WithTx User B', 'active')
		ON CONFLICT (user_id) DO NOTHING
	`, testUserA, testUserB)
	if err != nil {
		t.Fatalf("seed users: %v", err)
	}

	const wsLiveA = "aaaa1111-1111-4111-8111-111111111111"
	const memLiveA = "aaaa2222-2222-4222-8222-222222222222"
	credits30, _ := ParseExactDecimal("30")

	// Create workspace via WithUserBootstrapTx, then test rollback on error in WithTx.
	err = WithUserBootstrapTx(ctx, pool, testUserA, func(txCtx context.Context, q *Queries) error {
		_, err := q.CreateWorkspace(txCtx, CreateWorkspaceParams{
			WorkspaceID:    wsLiveA,
			Name:           "Live WithTx Workspace",
			Slug:           "live-withtx-ws",
			OwnerUserID:    testUserA,
			DefaultMode:    "creator",
			EnabledModes:   []string{"creator"},
			InitialCredits: credits30,
			MonthlyLimit:   credits30,
			OwnerMemberID:  memLiveA,
		})
		return err
	})
	if err != nil && !strings.Contains(err.Error(), "duplicate key") {
		t.Fatalf("WithUserBootstrapTx CreateWorkspace failed: %v", err)
	}

	// Update workspace inside WithTx and return an error -> verify name update rolled back!
	_ = WithTx(ctx, pool, Scope{WorkspaceID: wsLiveA, UserID: testUserA, RequireActiveMembership: true}, func(txCtx context.Context, q *Queries) error {
		_, err := q.UpdateWorkspace(txCtx, UpdateWorkspaceParams{
			WorkspaceID: wsLiveA,
			Name:        "Should Rollback Name",
			DefaultMode: "creator",
			Locale:      "vi-VN",
			Timezone:    "Asia/Ho_Chi_Minh",
		})
		if err != nil {
			return err
		}
		return errors.New("force rollback")
	})

	err = WithTx(ctx, pool, Scope{WorkspaceID: wsLiveA, UserID: testUserA, RequireActiveMembership: true}, func(txCtx context.Context, q *Queries) error {
		row, err := q.GetWorkspace(txCtx, wsLiveA)
		if err != nil {
			return err
		}
		if row.Name == "Should Rollback Name" {
			t.Fatalf("expected rolled-back update not to persist")
		}
		if row.AICreditsRemaining.String() != "30" {
			t.Fatalf("expected exact decimal credits 30, got %s", row.AICreditsRemaining.String())
		}
		return nil
	})
	if err != nil {
		t.Fatalf("WithTx GetWorkspace failed: %v", err)
	}
}

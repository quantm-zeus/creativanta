package finance_test

import (
	"context"
	"errors"
	"net/url"
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
	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func buildAppUserDSN(adminDSN string) (string, error) {
	u, err := url.Parse(adminDSN)
	if err != nil {
		return "", err
	}
	u.User = url.UserPassword("app_user", "app_user_test_pw")
	return u.String(), nil
}

func TestMigrationsDirectoryResolvable(t *testing.T) {
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	entries, err := os.ReadDir(migrationsDir)
	if err != nil || len(entries) == 0 {
		t.Fatalf("expected non-empty migrations directory at %s, err: %v", migrationsDir, err)
	}
}

type fakeFinanceRow struct {
	scanFn func(dest ...any) error
}

func (r fakeFinanceRow) Scan(dest ...any) error {
	return r.scanFn(dest...)
}

type fakeFinanceTx struct {
	mu          sync.Mutex
	tenantID    string
	userID      string
	committed   bool
	rolledBack  bool
	execQueries []string
}

func (f *fakeFinanceTx) Begin(ctx context.Context) (pgx.Tx, error) { return f, nil }
func (f *fakeFinanceTx) Commit(ctx context.Context) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.committed = true
	f.tenantID = ""
	f.userID = ""
	return nil
}
func (f *fakeFinanceTx) Rollback(ctx context.Context) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.rolledBack = true
	f.tenantID = ""
	f.userID = ""
	return nil
}
func (f *fakeFinanceTx) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	return 0, nil
}
func (f *fakeFinanceTx) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults { return nil }
func (f *fakeFinanceTx) LargeObjects() pgx.LargeObjects                               { return pgx.LargeObjects{} }
func (f *fakeFinanceTx) Prepare(ctx context.Context, name, sql string) (*pgconn.StatementDescription, error) {
	return nil, nil
}
func (f *fakeFinanceTx) Conn() *pgx.Conn { return nil }

func (f *fakeFinanceTx) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	if f.tenantID == "" {
		return pgconn.CommandTag{}, errors.New("RLS violation: app.current_tenant_id not set in transaction")
	}
	f.execQueries = append(f.execQueries, sql)
	return pgconn.NewCommandTag("INSERT 0 1"), nil
}

func (f *fakeFinanceTx) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	if f.tenantID == "" {
		return nil, errors.New("RLS violation: app.current_tenant_id not set in transaction")
	}
	return nil, errors.New("unexpected Query in unit test")
}

func (f *fakeFinanceTx) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row {
	if strings.Contains(sql, "set_config('app.current_tenant_id'") {
		tID := args[0].(string)
		uID := args[1].(string)
		f.mu.Lock()
		f.tenantID = tID
		f.userID = uID
		f.mu.Unlock()
		return fakeFinanceRow{scanFn: func(dest ...any) error {
			*(dest[0].(*string)) = tID
			*(dest[1].(*string)) = uID
			return nil
		}}
	}
	f.mu.Lock()
	hasTenant := f.tenantID != ""
	activeTenant := f.tenantID
	f.mu.Unlock()
	if !hasTenant {
		return fakeFinanceRow{scanFn: func(dest ...any) error {
			return errors.New("RLS violation: app.current_tenant_id not set in transaction")
		}}
	}
	if strings.Contains(sql, "FROM financial_postings") {
		return fakeFinanceRow{scanFn: func(dest ...any) error {
			if args[0].(string) != activeTenant {
				return pgx.ErrNoRows
			}
			amt := tenantdb.MustParseExactDecimal("1500000.000000").ToPgNumeric()
			*(dest[0].(*string)) = args[1].(string)
			*(dest[1].(*string)) = activeTenant
			*(dest[2].(*string)) = "order"
			*(dest[3].(*string)) = "ord-1"
			*(dest[4].(*string)) = "v1"
			*(dest[5].(*string)) = finance.ComponentRevenue
			*(dest[6].(*pgtype.Numeric)) = amt
			*(dest[7].(*string)) = "VND"
			*(dest[8].(*string)) = finance.SourceClassOfficial
			*(dest[9].(*string)) = finance.ConfidenceHigh
			*(dest[10].(*[]byte)) = []byte(`{"base_currency":"VND","quote_currency":"VND","rate_to_base":"1"}`)
			*(dest[11].(**string)) = nil
			*(dest[12].(*time.Time)) = time.Now().UTC()
			*(dest[13].(*time.Time)) = time.Now().UTC()
			return nil
		}}
	}
	return fakeFinanceRow{scanFn: func(dest ...any) error {
		return pgx.ErrNoRows
	}}
}

type fakeFinanceBeginner struct {
	mu  sync.Mutex
	txs []*fakeFinanceTx
}

func (b *fakeFinanceBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	b.mu.Lock()
	defer b.mu.Unlock()
	tx := &fakeFinanceTx{}
	b.txs = append(b.txs, tx)
	return tx, nil
}

func TestPostgresStoreEnforcesTenantTxAndRollback(t *testing.T) {
	ctx := context.Background()
	fb := &fakeFinanceBeginner{}
	store := finance.NewPostgresStoreWithBeginner(fb)

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa19"
	postID := "11111111-1111-1111-1111-111111111101"

	// 1. Missing tenant fails closed without beginning transaction
	if _, err := store.GetPosting(ctx, "", postID); !errors.Is(err, finance.ErrMissingTenant) {
		t.Fatalf("expected ErrMissingTenant, got %v", err)
	}
	if len(fb.txs) != 0 {
		t.Fatalf("expected 0 transactions started, got %d", len(fb.txs))
	}

	// 2. CreatePosting & GetPosting execute inside tenant-scoped transactions
	posting := &finance.FinancialPosting{
		PostingID:     postID,
		WorkspaceID:   wsID,
		OriginType:    "order",
		OriginID:      "ord-1",
		OriginVersion: "v1",
		Component:     finance.ComponentRevenue,
		Amount:        tenantdb.MustParseExactDecimal("1500000.000000"),
		Currency:      "VND",
		SourceClass:   finance.SourceClassOfficial,
		Confidence:    finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Now().UTC(),
		CreatedAt:   time.Now().UTC(),
	}
	if err := store.CreatePosting(ctx, posting); err != nil {
		t.Fatalf("CreatePosting failed: %v", err)
	}
	if len(fb.txs) != 1 || !fb.txs[0].committed {
		t.Fatalf("expected CreatePosting transaction to commit")
	}

	got, err := store.GetPosting(ctx, wsID, postID)
	if err != nil || got.Amount.String() != "1500000" {
		t.Fatalf("GetPosting failed: %v", err)
	}

	// 3. AtomicMatch rolls back cleanly when target row does not exist
	_, _, _, err = store.AtomicMatch(ctx, wsID, "s-1", "l-1", "o-1", "", tenantdb.MustParseExactDecimal("100.000000"))
	if err == nil {
		t.Fatalf("expected AtomicMatch on missing row to fail")
	}
	lastTx := fb.txs[len(fb.txs)-1]
	if !lastTx.rolledBack || lastTx.committed {
		t.Fatalf("expected failed AtomicMatch transaction to roll back")
	}
}

func TestPostgresLiveFinanceStore(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL finance suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect pgxpool: %v", err)
	}
	defer adminPool.Close()

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	wsID := "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa19"
	otherWS := "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb19"
	userID := "11111111-1111-4111-8111-111111111119"

	_, _ = adminPool.Exec(ctx, `
		INSERT INTO users (user_id, email, display_name, created_at, updated_at)
		VALUES ($1::uuid, 'finance-user@test.com', 'Finance User', NOW(), NOW())
		ON CONFLICT (user_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($2::uuid, 'Finance Workspace', 'finance-ws', $1::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, created_at, updated_at)
		VALUES ($3::uuid, 'Other Finance Workspace', 'other-finance-ws', $1::uuid, NOW(), NOW())
		ON CONFLICT (workspace_id) DO NOTHING;
	`, userID, wsID, otherWS)

	appDSN, err := buildAppUserDSN(dsn)
	if err != nil {
		t.Fatalf("buildAppUserDSN: %v", err)
	}
	appPool, err := pgxpool.New(ctx, appDSN)
	if err != nil {
		t.Fatalf("connect app_user pool: %v", err)
	}
	defer appPool.Close()

	store := finance.NewPostgresStore(appPool)

	// 1. Test Posting creation under app_user
	posting := &finance.FinancialPosting{
		PostingID:     "11111111-1111-1111-1111-111111111101",
		WorkspaceID:   wsID,
		OriginType:    "order",
		OriginID:      "22222222-2222-2222-2222-222222222201",
		OriginVersion: "v1",
		Component:     finance.ComponentRevenue,
		Amount:        tenantdb.MustParseExactDecimal("1500000.000000"),
		Currency:      "VND",
		SourceClass:   finance.SourceClassOfficial,
		Confidence:    finance.ConfidenceHigh,
		ExchangeRateSnapshot: finance.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "1",
		},
		EffectiveAt: time.Now().UTC(),
		CreatedAt:   time.Now().UTC(),
	}
	if err := store.CreatePosting(ctx, posting); err != nil {
		t.Fatalf("CreatePosting live PG failed: %v", err)
	}

	gotPosting, err := store.GetPosting(ctx, wsID, posting.PostingID)
	if err != nil || gotPosting.Amount.String() != "1500000" {
		t.Fatalf("GetPosting live PG failed: %v", err)
	}

	// Cross-tenant read under app_user must fail closed
	if _, err := store.GetPosting(ctx, otherWS, posting.PostingID); !errors.Is(err, finance.ErrPostingNotFound) {
		t.Fatalf("expected ErrPostingNotFound for cross-tenant read, got %v", err)
	}

	// 2. Test Cost Item creation & list
	costItem := &finance.CostItem{
		CostItemID:    "33333333-3333-3333-3333-333333333301",
		WorkspaceID:   wsID,
		CostType:      "ads_spend",
		Amount:        tenantdb.MustParseExactDecimal("250000.000000"),
		Currency:      "VND",
		Description:   "TikTok Ads boost",
		SourceClass:   finance.SourceClassOfficial,
		CostState:     finance.CostStateRecorded,
		EffectiveDate: "2026-11-01",
	}
	if err := store.CreateCostItem(ctx, costItem); err != nil {
		t.Fatalf("CreateCostItem live PG failed: %v", err)
	}

	costItems, total, err := store.ListCostItems(ctx, wsID, finance.CostItemFilter{CostType: "ads_spend"}, 10, 0)
	if err != nil || total < 1 || len(costItems) < 1 {
		t.Fatalf("ListCostItems live PG failed: %v, total: %d", err, total)
	}

	// 3. Test Settlement creation
	settlement := &finance.Settlement{
		SettlementID:         "44444444-4444-4444-4444-444444444401",
		WorkspaceID:          wsID,
		SourceClass:          finance.SourceClassOfficial,
		SourcePlatform:       "tiktok",
		ExternalSettlementID: "tt-settle-001",
		GrossAmount:          tenantdb.MustParseExactDecimal("1500000.000000"),
		NetAmount:            tenantdb.MustParseExactDecimal("1350000.000000"),
		Currency:             "VND",
		SettlementState:      finance.SettlementStateImported,
		ReconciliationState:  finance.ReconciliationImportedOnly,
		EffectiveDate:        "2026-11-01",
	}
	if err := store.CreateSettlement(ctx, settlement); err != nil {
		t.Fatalf("CreateSettlement live PG failed: %v", err)
	}

	gotSment, err := store.GetSettlement(ctx, wsID, settlement.SettlementID)
	if err != nil || gotSment.NetAmount.String() != "1350000" {
		t.Fatalf("GetSettlement live PG failed: %v", err)
	}
}

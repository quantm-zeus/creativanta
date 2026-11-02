package finance

import (
	"context"
	"crypto/rand"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func newUUID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

type PostingFilter struct {
	OriginType  string
	OriginID    string
	Component   string
	PeriodStart *time.Time
	PeriodEnd   *time.Time
}

type CostItemFilter struct {
	CostType         string
	RelatedScopeType string
	RelatedScopeID   string
	PeriodStart      string
	PeriodEnd        string
}

type SettlementFilter struct {
	SourcePlatform      string
	SettlementState     string
	ReconciliationState string
}

type Store interface {
	// Postings (append-only ledger)
	CreatePosting(ctx context.Context, p *FinancialPosting) error
	GetPosting(ctx context.Context, workspaceID, postingID string) (*FinancialPosting, error)
	ListPostings(ctx context.Context, workspaceID string, filter PostingFilter) ([]FinancialPosting, error)
	FindPostingByOrigin(ctx context.Context, workspaceID, originType, originID, component string) (*FinancialPosting, error)

	// Cost items
	CreateCostItem(ctx context.Context, item *CostItem) error
	GetCostItem(ctx context.Context, workspaceID, costItemID string) (*CostItem, error)
	ListCostItems(ctx context.Context, workspaceID string, filter CostItemFilter, limit, offset int) ([]CostItem, int64, error)
	UpdateCostItem(ctx context.Context, item *CostItem) error
	DeleteCostItem(ctx context.Context, workspaceID, costItemID string) error

	// Settlements & Lines
	CreateSettlement(ctx context.Context, s *Settlement) error
	GetSettlement(ctx context.Context, workspaceID, settlementID string) (*Settlement, error)
	ListSettlements(ctx context.Context, workspaceID string, filter SettlementFilter, limit, offset int) ([]Settlement, int64, error)
	FindSettlementByExternalID(ctx context.Context, workspaceID, accountID, externalID string) (*Settlement, error)
	FindSettlementByFingerprint(ctx context.Context, workspaceID, fingerprint string) (*Settlement, error)

	CreateSettlementLine(ctx context.Context, line *SettlementLine) error
	ListSettlementLines(ctx context.Context, workspaceID, settlementID string) ([]SettlementLine, error)
	GetSettlementLine(ctx context.Context, workspaceID, settlementID, lineID string) (*SettlementLine, error)
	UpdateSettlementLineMatched(ctx context.Context, workspaceID, lineID string, matchedAmount tenantdb.ExactDecimal, newState string) error

	// Profit Snapshots
	CreateSnapshot(ctx context.Context, s *ProfitSnapshot) error
	GetSnapshot(ctx context.Context, workspaceID, snapshotID string) (*ProfitSnapshot, error)
	GetLatestSnapshot(ctx context.Context, workspaceID, scopeType, scopeID, periodStart, periodEnd string) (*ProfitSnapshot, error)
	ListSnapshots(ctx context.Context, workspaceID, scopeType string, limit int) ([]ProfitSnapshot, error)
}

// ============================================================================
// MemoryStore Implementation
// ============================================================================

type MemoryStore struct {
	mu          sync.RWMutex
	postings    map[string]*FinancialPosting    // postingID -> posting
	costItems   map[string]*CostItem            // costItemID -> item
	settlements map[string]*Settlement          // settlementID -> settlement
	lines       map[string]*SettlementLine      // lineID -> line
	snapshots   map[string]*ProfitSnapshot      // snapshotID -> snapshot
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		postings:    make(map[string]*FinancialPosting),
		costItems:   make(map[string]*CostItem),
		settlements: make(map[string]*Settlement),
		lines:       make(map[string]*SettlementLine),
		snapshots:   make(map[string]*ProfitSnapshot),
	}
}

func (m *MemoryStore) CreatePosting(_ context.Context, p *FinancialPosting) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if p.PostingID == "" {
		p.PostingID = newUUID()
	}
	if p.CreatedAt.IsZero() {
		p.CreatedAt = time.Now().UTC()
	}

	// Check unique (workspace_id, origin_type, origin_id, origin_version, component)
	for _, existing := range m.postings {
		if existing.WorkspaceID == p.WorkspaceID &&
			existing.OriginType == p.OriginType &&
			existing.OriginID == p.OriginID &&
			existing.OriginVersion == p.OriginVersion &&
			existing.Component == p.Component {
			return ErrDuplicatePosting
		}
	}

	cp := *p
	m.postings[p.PostingID] = &cp
	return nil
}

func (m *MemoryStore) GetPosting(_ context.Context, workspaceID, postingID string) (*FinancialPosting, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, ok := m.postings[postingID]
	if !ok || p.WorkspaceID != workspaceID {
		return nil, ErrPostingNotFound
	}
	cp := *p
	return &cp, nil
}

func (m *MemoryStore) ListPostings(_ context.Context, workspaceID string, filter PostingFilter) ([]FinancialPosting, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []FinancialPosting
	for _, p := range m.postings {
		if p.WorkspaceID != workspaceID {
			continue
		}
		if filter.OriginType != "" && p.OriginType != filter.OriginType {
			continue
		}
		if filter.OriginID != "" && p.OriginID != filter.OriginID {
			continue
		}
		if filter.Component != "" && p.Component != filter.Component {
			continue
		}
		if filter.PeriodStart != nil && p.EffectiveAt.Before(*filter.PeriodStart) {
			continue
		}
		if filter.PeriodEnd != nil && p.EffectiveAt.After(*filter.PeriodEnd) {
			continue
		}
		result = append(result, *p)
	}
	return result, nil
}

func (m *MemoryStore) FindPostingByOrigin(_ context.Context, workspaceID, originType, originID, component string) (*FinancialPosting, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, p := range m.postings {
		if p.WorkspaceID == workspaceID &&
			p.OriginType == originType &&
			p.OriginID == originID &&
			p.Component == component {
			cp := *p
			return &cp, nil
		}
	}
	return nil, ErrPostingNotFound
}

func (m *MemoryStore) CreateCostItem(_ context.Context, item *CostItem) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if item.CostItemID == "" {
		item.CostItemID = newUUID()
	}
	now := time.Now().UTC()
	if item.CreatedAt.IsZero() {
		item.CreatedAt = now
	}
	item.UpdatedAt = now
	if item.CostState == "" {
		item.CostState = CostStateRecorded
	}
	if item.SourceClass == "" {
		item.SourceClass = SourceClassEstimated
	}

	cp := *item
	m.costItems[item.CostItemID] = &cp
	return nil
}

func (m *MemoryStore) GetCostItem(_ context.Context, workspaceID, costItemID string) (*CostItem, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	item, ok := m.costItems[costItemID]
	if !ok || item.WorkspaceID != workspaceID {
		return nil, ErrCostItemNotFound
	}
	cp := *item
	return &cp, nil
}

func (m *MemoryStore) ListCostItems(_ context.Context, workspaceID string, filter CostItemFilter, limit, offset int) ([]CostItem, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matched []CostItem
	for _, item := range m.costItems {
		if item.WorkspaceID != workspaceID {
			continue
		}
		if filter.CostType != "" && item.CostType != filter.CostType {
			continue
		}
		if filter.RelatedScopeType != "" && item.RelatedScopeType != filter.RelatedScopeType {
			continue
		}
		if filter.RelatedScopeID != "" && item.RelatedScopeID != filter.RelatedScopeID {
			continue
		}
		if filter.PeriodStart != "" && item.EffectiveDate < filter.PeriodStart {
			continue
		}
		if filter.PeriodEnd != "" && item.EffectiveDate > filter.PeriodEnd {
			continue
		}
		matched = append(matched, *item)
	}

	total := int64(len(matched))
	if offset >= len(matched) {
		return []CostItem{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matched) {
		end = len(matched)
	}
	return matched[offset:end], total, nil
}

func (m *MemoryStore) UpdateCostItem(_ context.Context, item *CostItem) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.costItems[item.CostItemID]
	if !ok || existing.WorkspaceID != item.WorkspaceID {
		return ErrCostItemNotFound
	}

	item.UpdatedAt = time.Now().UTC()
	cp := *item
	m.costItems[item.CostItemID] = &cp
	return nil
}

func (m *MemoryStore) DeleteCostItem(_ context.Context, workspaceID, costItemID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.costItems[costItemID]
	if !ok || existing.WorkspaceID != workspaceID {
		return ErrCostItemNotFound
	}
	delete(m.costItems, costItemID)
	return nil
}

func (m *MemoryStore) CreateSettlement(_ context.Context, s *Settlement) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if s.SettlementID == "" {
		s.SettlementID = newUUID()
	}
	now := time.Now().UTC()
	if s.CreatedAt.IsZero() {
		s.CreatedAt = now
	}
	s.UpdatedAt = now
	if s.SettlementState == "" {
		s.SettlementState = SettlementStateImported
	}
	if s.ReconciliationState == "" {
		s.ReconciliationState = ReconciliationImportedOnly
	}

	// Unique check for external settlement ID or fingerprint
	for _, existing := range m.settlements {
		if existing.WorkspaceID == s.WorkspaceID {
			if s.ExternalSettlementID != "" && s.ConnectedAccountID != "" &&
				existing.ExternalSettlementID == s.ExternalSettlementID &&
				existing.ConnectedAccountID == s.ConnectedAccountID {
				return ErrDuplicateSettlement
			}
			if s.ImportFingerprint != "" && existing.ImportFingerprint == s.ImportFingerprint {
				return ErrDuplicateSettlement
			}
		}
	}

	cp := *s
	m.settlements[s.SettlementID] = &cp
	return nil
}

func (m *MemoryStore) GetSettlement(_ context.Context, workspaceID, settlementID string) (*Settlement, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	s, ok := m.settlements[settlementID]
	if !ok || s.WorkspaceID != workspaceID {
		return nil, ErrSettlementNotFound
	}
	cp := *s

	// Attach lines
	var lines []SettlementLine
	for _, line := range m.lines {
		if line.WorkspaceID == workspaceID && line.SettlementID == settlementID {
			lines = append(lines, *line)
		}
	}
	cp.Lines = lines
	return &cp, nil
}

func (m *MemoryStore) ListSettlements(_ context.Context, workspaceID string, filter SettlementFilter, limit, offset int) ([]Settlement, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matched []Settlement
	for _, s := range m.settlements {
		if s.WorkspaceID != workspaceID {
			continue
		}
		if filter.SourcePlatform != "" && s.SourcePlatform != filter.SourcePlatform {
			continue
		}
		if filter.SettlementState != "" && s.SettlementState != filter.SettlementState {
			continue
		}
		if filter.ReconciliationState != "" && s.ReconciliationState != filter.ReconciliationState {
			continue
		}
		cp := *s
		matched = append(matched, cp)
	}

	total := int64(len(matched))
	if offset >= len(matched) {
		return []Settlement{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matched) {
		end = len(matched)
	}
	return matched[offset:end], total, nil
}

func (m *MemoryStore) FindSettlementByExternalID(_ context.Context, workspaceID, accountID, externalID string) (*Settlement, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, s := range m.settlements {
		if s.WorkspaceID == workspaceID && s.ConnectedAccountID == accountID && s.ExternalSettlementID == externalID {
			cp := *s
			return &cp, nil
		}
	}
	return nil, ErrSettlementNotFound
}

func (m *MemoryStore) FindSettlementByFingerprint(_ context.Context, workspaceID, fingerprint string) (*Settlement, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, s := range m.settlements {
		if s.WorkspaceID == workspaceID && s.ImportFingerprint == fingerprint {
			cp := *s
			return &cp, nil
		}
	}
	return nil, ErrSettlementNotFound
}

func (m *MemoryStore) CreateSettlementLine(_ context.Context, line *SettlementLine) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if line.LineID == "" {
		line.LineID = newUUID()
	}
	if line.CreatedAt.IsZero() {
		line.CreatedAt = time.Now().UTC()
	}
	if line.ReconciliationState == "" {
		line.ReconciliationState = ReconciliationImportedOnly
	}

	cp := *line
	m.lines[line.LineID] = &cp
	return nil
}

func (m *MemoryStore) ListSettlementLines(_ context.Context, workspaceID, settlementID string) ([]SettlementLine, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []SettlementLine
	for _, l := range m.lines {
		if l.WorkspaceID == workspaceID && l.SettlementID == settlementID {
			result = append(result, *l)
		}
	}
	return result, nil
}

func (m *MemoryStore) GetSettlementLine(_ context.Context, workspaceID, settlementID, lineID string) (*SettlementLine, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	l, ok := m.lines[lineID]
	if !ok || l.WorkspaceID != workspaceID || l.SettlementID != settlementID {
		return nil, errors.New("finance: settlement line not found")
	}
	cp := *l
	return &cp, nil
}

func (m *MemoryStore) UpdateSettlementLineMatched(_ context.Context, workspaceID, lineID string, matchedAmount tenantdb.ExactDecimal, newState string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	l, ok := m.lines[lineID]
	if !ok || l.WorkspaceID != workspaceID {
		return errors.New("finance: settlement line not found")
	}

	// Capacity check: matchedAmount cannot exceed net_amount
	if matchedAmount.Cmp(l.NetAmount) > 0 {
		return ErrCapacityExceeded
	}

	l.MatchedAmount = matchedAmount
	if newState != "" {
		l.ReconciliationState = newState
	}
	return nil
}

func (m *MemoryStore) CreateSnapshot(_ context.Context, s *ProfitSnapshot) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if s.SnapshotID == "" {
		s.SnapshotID = newUUID()
	}
	now := time.Now().UTC()
	if s.CreatedAt.IsZero() {
		s.CreatedAt = now
	}
	if s.FreshnessAt.IsZero() {
		s.FreshnessAt = now
	}

	cp := *s
	m.snapshots[s.SnapshotID] = &cp
	return nil
}

func (m *MemoryStore) GetSnapshot(_ context.Context, workspaceID, snapshotID string) (*ProfitSnapshot, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	s, ok := m.snapshots[snapshotID]
	if !ok || s.WorkspaceID != workspaceID {
		return nil, errors.New("finance: profit snapshot not found")
	}
	cp := *s
	return &cp, nil
}

func (m *MemoryStore) GetLatestSnapshot(_ context.Context, workspaceID, scopeType, scopeID, periodStart, periodEnd string) (*ProfitSnapshot, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var latest *ProfitSnapshot
	for _, s := range m.snapshots {
		if s.WorkspaceID != workspaceID {
			continue
		}
		if scopeType != "" && s.ScopeType != scopeType {
			continue
		}
		if scopeID != "" && s.ScopeID != scopeID {
			continue
		}
		if periodStart != "" && s.PeriodStart != periodStart {
			continue
		}
		if periodEnd != "" && s.PeriodEnd != periodEnd {
			continue
		}
		if latest == nil || !s.FreshnessAt.Before(latest.FreshnessAt) {
			cp := *s
			latest = &cp
		}
	}

	if latest == nil {
		return nil, errors.New("finance: no profit snapshot found")
	}
	return latest, nil
}

func (m *MemoryStore) ListSnapshots(_ context.Context, workspaceID, scopeType string, limit int) ([]ProfitSnapshot, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []ProfitSnapshot
	for _, s := range m.snapshots {
		if s.WorkspaceID == workspaceID {
			if scopeType == "" || s.ScopeType == scopeType {
				result = append(result, *s)
			}
		}
	}
	if limit > 0 && len(result) > limit {
		result = result[:limit]
	}
	return result, nil
}

// ============================================================================
// PostgresStore Implementation
// ============================================================================

type PostgresStore struct {
	pool *pgxpool.Pool
}

func NewPostgresStore(pool *pgxpool.Pool) *PostgresStore {
	return &PostgresStore{pool: pool}
}

func (p *PostgresStore) CreatePosting(ctx context.Context, post *FinancialPosting) error {
	if post.PostingID == "" {
		post.PostingID = newUUID()
	}
	if post.CreatedAt.IsZero() {
		post.CreatedAt = time.Now().UTC()
	}

	fxJSON, err := json.Marshal(post.ExchangeRateSnapshot)
	if err != nil {
		return fmt.Errorf("marshal fx snapshot: %w", err)
	}

	query := `
		INSERT INTO financial_postings (
			posting_id, workspace_id, origin_type, origin_id, origin_version,
			component, amount, currency, source_class, confidence,
			exchange_rate_snapshot, reversal_of, effective_at, created_at
		) VALUES (
			$1, $2, $3, $4, $5,
			$6, $7, $8, $9, $10,
			$11, $12, $13, $14
		)
	`
	_, err = p.pool.Exec(ctx, query,
		post.PostingID, post.WorkspaceID, post.OriginType, post.OriginID, post.OriginVersion,
		post.Component, post.Amount.ToPgNumeric(), post.Currency, post.SourceClass, post.Confidence,
		fxJSON, post.ReversalOf, post.EffectiveAt, post.CreatedAt,
	)
	if err != nil {
		if strings.Contains(err.Error(), "duplicate key") || strings.Contains(err.Error(), "unique constraint") {
			return ErrDuplicatePosting
		}
		return fmt.Errorf("create financial posting: %w", err)
	}
	return nil
}

func (p *PostgresStore) GetPosting(ctx context.Context, workspaceID, postingID string) (*FinancialPosting, error) {
	query := `
		SELECT posting_id, workspace_id, origin_type, origin_id, origin_version,
		       component, amount, currency, source_class, confidence,
		       exchange_rate_snapshot, reversal_of, effective_at, created_at
		FROM financial_postings
		WHERE workspace_id = $1 AND posting_id = $2
	`
	row := p.pool.QueryRow(ctx, query, workspaceID, postingID)
	return scanPosting(row)
}

func (p *PostgresStore) ListPostings(ctx context.Context, workspaceID string, filter PostingFilter) ([]FinancialPosting, error) {
	query := `
		SELECT posting_id, workspace_id, origin_type, origin_id, origin_version,
		       component, amount, currency, source_class, confidence,
		       exchange_rate_snapshot, reversal_of, effective_at, created_at
		FROM financial_postings
		WHERE workspace_id = $1
	`
	args := []any{workspaceID}
	idx := 2

	if filter.OriginType != "" {
		query += fmt.Sprintf(" AND origin_type = $%d", idx)
		args = append(args, filter.OriginType)
		idx++
	}
	if filter.OriginID != "" {
		query += fmt.Sprintf(" AND origin_id = $%d", idx)
		args = append(args, filter.OriginID)
		idx++
	}
	if filter.Component != "" {
		query += fmt.Sprintf(" AND component = $%d", idx)
		args = append(args, filter.Component)
		idx++
	}
	if filter.PeriodStart != nil {
		query += fmt.Sprintf(" AND effective_at >= $%d", idx)
		args = append(args, *filter.PeriodStart)
		idx++
	}
	if filter.PeriodEnd != nil {
		query += fmt.Sprintf(" AND effective_at <= $%d", idx)
		args = append(args, *filter.PeriodEnd)
		idx++
	}
	query += " ORDER BY effective_at ASC, created_at ASC"

	rows, err := p.pool.Query(ctx, query, args...)
	if err != nil {
		return nil, fmt.Errorf("list postings: %w", err)
	}
	defer rows.Close()

	var result []FinancialPosting
	for rows.Next() {
		item, err := scanPostingRow(rows)
		if err != nil {
			return nil, err
		}
		result = append(result, *item)
	}
	return result, nil
}

func (p *PostgresStore) FindPostingByOrigin(ctx context.Context, workspaceID, originType, originID, component string) (*FinancialPosting, error) {
	query := `
		SELECT posting_id, workspace_id, origin_type, origin_id, origin_version,
		       component, amount, currency, source_class, confidence,
		       exchange_rate_snapshot, reversal_of, effective_at, created_at
		FROM financial_postings
		WHERE workspace_id = $1 AND origin_type = $2 AND origin_id = $3 AND component = $4
		ORDER BY created_at DESC
		LIMIT 1
	`
	row := p.pool.QueryRow(ctx, query, workspaceID, originType, originID, component)
	return scanPosting(row)
}

func scanPosting(row pgx.Row) (*FinancialPosting, error) {
	var post FinancialPosting
	var num pgtype.Numeric
	var fxBytes []byte

	err := row.Scan(
		&post.PostingID, &post.WorkspaceID, &post.OriginType, &post.OriginID, &post.OriginVersion,
		&post.Component, &num, &post.Currency, &post.SourceClass, &post.Confidence,
		&fxBytes, &post.ReversalOf, &post.EffectiveAt, &post.CreatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrPostingNotFound
		}
		return nil, err
	}

	post.Amount, err = tenantdb.FromPgNumeric(num)
	if err != nil {
		return nil, err
	}
	if len(fxBytes) > 0 {
		_ = json.Unmarshal(fxBytes, &post.ExchangeRateSnapshot)
	}
	return &post, nil
}

func scanPostingRow(rows pgx.Rows) (*FinancialPosting, error) {
	var post FinancialPosting
	var num pgtype.Numeric
	var fxBytes []byte

	err := rows.Scan(
		&post.PostingID, &post.WorkspaceID, &post.OriginType, &post.OriginID, &post.OriginVersion,
		&post.Component, &num, &post.Currency, &post.SourceClass, &post.Confidence,
		&fxBytes, &post.ReversalOf, &post.EffectiveAt, &post.CreatedAt,
	)
	if err != nil {
		return nil, err
	}
	post.Amount, err = tenantdb.FromPgNumeric(num)
	if err != nil {
		return nil, err
	}
	if len(fxBytes) > 0 {
		_ = json.Unmarshal(fxBytes, &post.ExchangeRateSnapshot)
	}
	return &post, nil
}

func (p *PostgresStore) CreateCostItem(ctx context.Context, item *CostItem) error {
	if item.CostItemID == "" {
		item.CostItemID = newUUID()
	}
	now := time.Now().UTC()
	if item.CreatedAt.IsZero() {
		item.CreatedAt = now
	}
	item.UpdatedAt = now

	query := `
		INSERT INTO cost_items (
			cost_item_id, workspace_id, cost_type, amount, currency,
			description, related_scope_type, related_scope_id, source_class,
			evidence_id, confidence_reason, cost_state, effective_date,
			created_at, updated_at
		) VALUES (
			$1, $2, $3, $4, $5,
			$6, $7, $8, $9,
			$10, $11, $12, $13,
			$14, $15
		)
	`
	_, err := p.pool.Exec(ctx, query,
		item.CostItemID, item.WorkspaceID, item.CostType, item.Amount.ToPgNumeric(), item.Currency,
		item.Description, item.RelatedScopeType, item.RelatedScopeID, item.SourceClass,
		item.EvidenceID, item.ConfidenceReason, item.CostState, item.EffectiveDate,
		item.CreatedAt, item.UpdatedAt,
	)
	return err
}

func (p *PostgresStore) GetCostItem(ctx context.Context, workspaceID, costItemID string) (*CostItem, error) {
	query := `
		SELECT cost_item_id, workspace_id, cost_type, amount, currency,
		       description, related_scope_type, related_scope_id, source_class,
		       evidence_id, confidence_reason, cost_state, effective_date,
		       created_at, updated_at
		FROM cost_items
		WHERE workspace_id = $1 AND cost_item_id = $2 AND deleted_at IS NULL
	`
	var item CostItem
	var num pgtype.Numeric
	err := p.pool.QueryRow(ctx, query, workspaceID, costItemID).Scan(
		&item.CostItemID, &item.WorkspaceID, &item.CostType, &num, &item.Currency,
		&item.Description, &item.RelatedScopeType, &item.RelatedScopeID, &item.SourceClass,
		&item.EvidenceID, &item.ConfidenceReason, &item.CostState, &item.EffectiveDate,
		&item.CreatedAt, &item.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrCostItemNotFound
		}
		return nil, err
	}
	item.Amount, err = tenantdb.FromPgNumeric(num)
	return &item, err
}

func (p *PostgresStore) ListCostItems(ctx context.Context, workspaceID string, filter CostItemFilter, limit, offset int) ([]CostItem, int64, error) {
	baseQuery := `FROM cost_items WHERE workspace_id = $1 AND deleted_at IS NULL`
	args := []any{workspaceID}
	idx := 2

	if filter.CostType != "" {
		baseQuery += fmt.Sprintf(" AND cost_type = $%d", idx)
		args = append(args, filter.CostType)
		idx++
	}
	if filter.RelatedScopeType != "" {
		baseQuery += fmt.Sprintf(" AND related_scope_type = $%d", idx)
		args = append(args, filter.RelatedScopeType)
		idx++
	}
	if filter.RelatedScopeID != "" {
		baseQuery += fmt.Sprintf(" AND related_scope_id = $%d", idx)
		args = append(args, filter.RelatedScopeID)
		idx++
	}
	if filter.PeriodStart != "" {
		baseQuery += fmt.Sprintf(" AND effective_date >= $%d", idx)
		args = append(args, filter.PeriodStart)
		idx++
	}
	if filter.PeriodEnd != "" {
		baseQuery += fmt.Sprintf(" AND effective_date <= $%d", idx)
		args = append(args, filter.PeriodEnd)
		idx++
	}

	countQuery := "SELECT count(*) " + baseQuery
	var total int64
	if err := p.pool.QueryRow(ctx, countQuery, args...).Scan(&total); err != nil {
		return nil, 0, err
	}

	dataQuery := `
		SELECT cost_item_id, workspace_id, cost_type, amount, currency,
		       description, related_scope_type, related_scope_id, source_class,
		       evidence_id, confidence_reason, cost_state, effective_date,
		       created_at, updated_at ` + baseQuery + fmt.Sprintf(" ORDER BY effective_date DESC, created_at DESC LIMIT $%d OFFSET $%d", idx, idx+1)
	args = append(args, limit, offset)

	rows, err := p.pool.Query(ctx, dataQuery, args...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var result []CostItem
	for rows.Next() {
		var item CostItem
		var num pgtype.Numeric
		if err := rows.Scan(
			&item.CostItemID, &item.WorkspaceID, &item.CostType, &num, &item.Currency,
			&item.Description, &item.RelatedScopeType, &item.RelatedScopeID, &item.SourceClass,
			&item.EvidenceID, &item.ConfidenceReason, &item.CostState, &item.EffectiveDate,
			&item.CreatedAt, &item.UpdatedAt,
		); err != nil {
			return nil, 0, err
		}
		item.Amount, err = tenantdb.FromPgNumeric(num)
		if err != nil {
			return nil, 0, err
		}
		result = append(result, item)
	}
	return result, total, nil
}

func (p *PostgresStore) UpdateCostItem(ctx context.Context, item *CostItem) error {
	item.UpdatedAt = time.Now().UTC()
	query := `
		UPDATE cost_items
		SET amount = $1, description = $2, cost_type = $3, source_class = $4,
		    cost_state = $5, updated_at = $6
		WHERE workspace_id = $7 AND cost_item_id = $8 AND deleted_at IS NULL
	`
	cmd, err := p.pool.Exec(ctx, query,
		item.Amount.ToPgNumeric(), item.Description, item.CostType, item.SourceClass,
		item.CostState, item.UpdatedAt, item.WorkspaceID, item.CostItemID,
	)
	if err != nil {
		return err
	}
	if cmd.RowsAffected() == 0 {
		return ErrCostItemNotFound
	}
	return nil
}

func (p *PostgresStore) DeleteCostItem(ctx context.Context, workspaceID, costItemID string) error {
	query := `
		UPDATE cost_items
		SET deleted_at = NOW(), updated_at = NOW()
		WHERE workspace_id = $1 AND cost_item_id = $2 AND deleted_at IS NULL
	`
	cmd, err := p.pool.Exec(ctx, query, workspaceID, costItemID)
	if err != nil {
		return err
	}
	if cmd.RowsAffected() == 0 {
		return ErrCostItemNotFound
	}
	return nil
}

func (p *PostgresStore) CreateSettlement(ctx context.Context, s *Settlement) error {
	if s.SettlementID == "" {
		s.SettlementID = newUUID()
	}
	now := time.Now().UTC()
	if s.CreatedAt.IsZero() {
		s.CreatedAt = now
	}
	s.UpdatedAt = now

	fxJSON, _ := json.Marshal(s.ExchangeRateSnapshot)
	feesJSON, _ := json.Marshal(s.Fees)
	dedJSON, _ := json.Marshal(s.Deductions)

	query := `
		INSERT INTO settlements (
			settlement_id, workspace_id, source_class, source_platform,
			external_settlement_id, connected_account_id, exchange_rate_snapshot,
			import_fingerprint, gross_amount, net_amount, fees, deductions,
			currency, settlement_state, reconciliation_state, related_order_ids,
			effective_date, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7,
			$8, $9, $10, $11, $12,
			$13, $14, $15, $16,
			$17, $18, $19
		)
	`
	_, err := p.pool.Exec(ctx, query,
		s.SettlementID, s.WorkspaceID, s.SourceClass, s.SourcePlatform,
		s.ExternalSettlementID, s.ConnectedAccountID, fxJSON,
		s.ImportFingerprint, s.GrossAmount.ToPgNumeric(), s.NetAmount.ToPgNumeric(), feesJSON, dedJSON,
		s.Currency, s.SettlementState, s.ReconciliationState, s.RelatedOrderIDs,
		s.EffectiveDate, s.CreatedAt, s.UpdatedAt,
	)
	if err != nil {
		if strings.Contains(err.Error(), "duplicate key") || strings.Contains(err.Error(), "unique constraint") {
			return ErrDuplicateSettlement
		}
		return err
	}
	return nil
}

func (p *PostgresStore) GetSettlement(ctx context.Context, workspaceID, settlementID string) (*Settlement, error) {
	query := `
		SELECT settlement_id, workspace_id, source_class, source_platform,
		       external_settlement_id, connected_account_id, exchange_rate_snapshot,
		       import_fingerprint, gross_amount, net_amount, fees, deductions,
		       currency, settlement_state, reconciliation_state, related_order_ids,
		       effective_date, created_at, updated_at
		FROM settlements
		WHERE workspace_id = $1 AND settlement_id = $2 AND deleted_at IS NULL
	`
	var s Settlement
	var grossNum, netNum pgtype.Numeric
	var fxBytes, feesBytes, dedBytes []byte

	err := p.pool.QueryRow(ctx, query, workspaceID, settlementID).Scan(
		&s.SettlementID, &s.WorkspaceID, &s.SourceClass, &s.SourcePlatform,
		&s.ExternalSettlementID, &s.ConnectedAccountID, &fxBytes,
		&s.ImportFingerprint, &grossNum, &netNum, &feesBytes, &dedBytes,
		&s.Currency, &s.SettlementState, &s.ReconciliationState, &s.RelatedOrderIDs,
		&s.EffectiveDate, &s.CreatedAt, &s.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrSettlementNotFound
		}
		return nil, err
	}
	s.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
	s.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
	_ = json.Unmarshal(fxBytes, &s.ExchangeRateSnapshot)
	_ = json.Unmarshal(feesBytes, &s.Fees)
	_ = json.Unmarshal(dedBytes, &s.Deductions)

	lines, err := p.ListSettlementLines(ctx, workspaceID, settlementID)
	if err == nil {
		s.Lines = lines
	}
	return &s, nil
}

func (p *PostgresStore) ListSettlements(ctx context.Context, workspaceID string, filter SettlementFilter, limit, offset int) ([]Settlement, int64, error) {
	baseQuery := `FROM settlements WHERE workspace_id = $1 AND deleted_at IS NULL`
	args := []any{workspaceID}
	idx := 2

	if filter.SourcePlatform != "" {
		baseQuery += fmt.Sprintf(" AND source_platform = $%d", idx)
		args = append(args, filter.SourcePlatform)
		idx++
	}
	if filter.SettlementState != "" {
		baseQuery += fmt.Sprintf(" AND settlement_state = $%d", idx)
		args = append(args, filter.SettlementState)
		idx++
	}
	if filter.ReconciliationState != "" {
		baseQuery += fmt.Sprintf(" AND reconciliation_state = $%d", idx)
		args = append(args, filter.ReconciliationState)
		idx++
	}

	countQuery := "SELECT count(*) " + baseQuery
	var total int64
	if err := p.pool.QueryRow(ctx, countQuery, args...).Scan(&total); err != nil {
		return nil, 0, err
	}

	dataQuery := `
		SELECT settlement_id, workspace_id, source_class, source_platform,
		       external_settlement_id, connected_account_id, exchange_rate_snapshot,
		       import_fingerprint, gross_amount, net_amount, fees, deductions,
		       currency, settlement_state, reconciliation_state, related_order_ids,
		       effective_date, created_at, updated_at ` + baseQuery + fmt.Sprintf(" ORDER BY effective_date DESC, created_at DESC LIMIT $%d OFFSET $%d", idx, idx+1)
	args = append(args, limit, offset)

	rows, err := p.pool.Query(ctx, dataQuery, args...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var result []Settlement
	for rows.Next() {
		var s Settlement
		var grossNum, netNum pgtype.Numeric
		var fxBytes, feesBytes, dedBytes []byte
		if err := rows.Scan(
			&s.SettlementID, &s.WorkspaceID, &s.SourceClass, &s.SourcePlatform,
			&s.ExternalSettlementID, &s.ConnectedAccountID, &fxBytes,
			&s.ImportFingerprint, &grossNum, &netNum, &feesBytes, &dedBytes,
			&s.Currency, &s.SettlementState, &s.ReconciliationState, &s.RelatedOrderIDs,
			&s.EffectiveDate, &s.CreatedAt, &s.UpdatedAt,
		); err != nil {
			return nil, 0, err
		}
		s.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
		s.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
		_ = json.Unmarshal(fxBytes, &s.ExchangeRateSnapshot)
		_ = json.Unmarshal(feesBytes, &s.Fees)
		_ = json.Unmarshal(dedBytes, &s.Deductions)
		result = append(result, s)
	}
	return result, total, nil
}

func (p *PostgresStore) FindSettlementByExternalID(ctx context.Context, workspaceID, accountID, externalID string) (*Settlement, error) {
	query := `
		SELECT settlement_id, workspace_id, source_class, source_platform,
		       external_settlement_id, connected_account_id, exchange_rate_snapshot,
		       import_fingerprint, gross_amount, net_amount, fees, deductions,
		       currency, settlement_state, reconciliation_state, related_order_ids,
		       effective_date, created_at, updated_at
		FROM settlements
		WHERE workspace_id = $1 AND connected_account_id = $2 AND external_settlement_id = $3 AND deleted_at IS NULL
	`
	var s Settlement
	var grossNum, netNum pgtype.Numeric
	var fxBytes, feesBytes, dedBytes []byte

	err := p.pool.QueryRow(ctx, query, workspaceID, accountID, externalID).Scan(
		&s.SettlementID, &s.WorkspaceID, &s.SourceClass, &s.SourcePlatform,
		&s.ExternalSettlementID, &s.ConnectedAccountID, &fxBytes,
		&s.ImportFingerprint, &grossNum, &netNum, &feesBytes, &dedBytes,
		&s.Currency, &s.SettlementState, &s.ReconciliationState, &s.RelatedOrderIDs,
		&s.EffectiveDate, &s.CreatedAt, &s.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrSettlementNotFound
		}
		return nil, err
	}
	s.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
	s.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
	_ = json.Unmarshal(fxBytes, &s.ExchangeRateSnapshot)
	_ = json.Unmarshal(feesBytes, &s.Fees)
	_ = json.Unmarshal(dedBytes, &s.Deductions)
	return &s, nil
}

func (p *PostgresStore) FindSettlementByFingerprint(ctx context.Context, workspaceID, fingerprint string) (*Settlement, error) {
	query := `
		SELECT settlement_id, workspace_id, source_class, source_platform,
		       external_settlement_id, connected_account_id, exchange_rate_snapshot,
		       import_fingerprint, gross_amount, net_amount, fees, deductions,
		       currency, settlement_state, reconciliation_state, related_order_ids,
		       effective_date, created_at, updated_at
		FROM settlements
		WHERE workspace_id = $1 AND import_fingerprint = $2 AND deleted_at IS NULL
	`
	var s Settlement
	var grossNum, netNum pgtype.Numeric
	var fxBytes, feesBytes, dedBytes []byte

	err := p.pool.QueryRow(ctx, query, workspaceID, fingerprint).Scan(
		&s.SettlementID, &s.WorkspaceID, &s.SourceClass, &s.SourcePlatform,
		&s.ExternalSettlementID, &s.ConnectedAccountID, &fxBytes,
		&s.ImportFingerprint, &grossNum, &netNum, &feesBytes, &dedBytes,
		&s.Currency, &s.SettlementState, &s.ReconciliationState, &s.RelatedOrderIDs,
		&s.EffectiveDate, &s.CreatedAt, &s.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrSettlementNotFound
		}
		return nil, err
	}
	s.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
	s.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
	_ = json.Unmarshal(fxBytes, &s.ExchangeRateSnapshot)
	_ = json.Unmarshal(feesBytes, &s.Fees)
	_ = json.Unmarshal(dedBytes, &s.Deductions)
	return &s, nil
}

func (p *PostgresStore) CreateSettlementLine(ctx context.Context, line *SettlementLine) error {
	if line.LineID == "" {
		line.LineID = newUUID()
	}
	if line.CreatedAt.IsZero() {
		line.CreatedAt = time.Now().UTC()
	}

	query := `
		INSERT INTO settlement_lines (
			line_id, workspace_id, settlement_id, external_line_id,
			external_order_id, order_id, gross_amount, fee_amount,
			refund_amount, net_amount, matched_amount, currency,
			reconciliation_state, created_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7, $8,
			$9, $10, $11, $12,
			$13, $14
		)
	`
	_, err := p.pool.Exec(ctx, query,
		line.LineID, line.WorkspaceID, line.SettlementID, line.ExternalLineID,
		line.ExternalOrderID, line.OrderID, line.GrossAmount.ToPgNumeric(), line.FeeAmount.ToPgNumeric(),
		line.RefundAmount.ToPgNumeric(), line.NetAmount.ToPgNumeric(), line.MatchedAmount.ToPgNumeric(), line.Currency,
		line.ReconciliationState, line.CreatedAt,
	)
	return err
}

func (p *PostgresStore) ListSettlementLines(ctx context.Context, workspaceID, settlementID string) ([]SettlementLine, error) {
	query := `
		SELECT line_id, workspace_id, settlement_id, external_line_id,
		       external_order_id, order_id, gross_amount, fee_amount,
		       refund_amount, net_amount, matched_amount, currency,
		       reconciliation_state, created_at
		FROM settlement_lines
		WHERE workspace_id = $1 AND settlement_id = $2
		ORDER BY created_at ASC
	`
	rows, err := p.pool.Query(ctx, query, workspaceID, settlementID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []SettlementLine
	for rows.Next() {
		var l SettlementLine
		var grossNum, feeNum, refNum, netNum, matchNum pgtype.Numeric
		var extOrder, orderID *string

		if err := rows.Scan(
			&l.LineID, &l.WorkspaceID, &l.SettlementID, &l.ExternalLineID,
			&extOrder, &orderID, &grossNum, &feeNum,
			&refNum, &netNum, &matchNum, &l.Currency,
			&l.ReconciliationState, &l.CreatedAt,
		); err != nil {
			return nil, err
		}
		if extOrder != nil {
			l.ExternalOrderID = *extOrder
		}
		if orderID != nil {
			l.OrderID = *orderID
		}
		l.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
		l.FeeAmount, _ = tenantdb.FromPgNumeric(feeNum)
		l.RefundAmount, _ = tenantdb.FromPgNumeric(refNum)
		l.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
		l.MatchedAmount, _ = tenantdb.FromPgNumeric(matchNum)
		result = append(result, l)
	}
	return result, nil
}

func (p *PostgresStore) GetSettlementLine(ctx context.Context, workspaceID, settlementID, lineID string) (*SettlementLine, error) {
	query := `
		SELECT line_id, workspace_id, settlement_id, external_line_id,
		       external_order_id, order_id, gross_amount, fee_amount,
		       refund_amount, net_amount, matched_amount, currency,
		       reconciliation_state, created_at
		FROM settlement_lines
		WHERE workspace_id = $1 AND settlement_id = $2 AND line_id = $3
	`
	var l SettlementLine
	var grossNum, feeNum, refNum, netNum, matchNum pgtype.Numeric
	var extOrder, orderID *string

	err := p.pool.QueryRow(ctx, query, workspaceID, settlementID, lineID).Scan(
		&l.LineID, &l.WorkspaceID, &l.SettlementID, &l.ExternalLineID,
		&extOrder, &orderID, &grossNum, &feeNum,
		&refNum, &netNum, &matchNum, &l.Currency,
		&l.ReconciliationState, &l.CreatedAt,
	)
	if err != nil {
		return nil, err
	}
	if extOrder != nil {
		l.ExternalOrderID = *extOrder
	}
	if orderID != nil {
		l.OrderID = *orderID
	}
	l.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
	l.FeeAmount, _ = tenantdb.FromPgNumeric(feeNum)
	l.RefundAmount, _ = tenantdb.FromPgNumeric(refNum)
	l.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
	l.MatchedAmount, _ = tenantdb.FromPgNumeric(matchNum)
	return &l, nil
}

func (p *PostgresStore) UpdateSettlementLineMatched(ctx context.Context, workspaceID, lineID string, matchedAmount tenantdb.ExactDecimal, newState string) error {
	query := `
		UPDATE settlement_lines
		SET matched_amount = $1, reconciliation_state = $2
		WHERE workspace_id = $3 AND line_id = $4
	`
	_, err := p.pool.Exec(ctx, query, matchedAmount.ToPgNumeric(), newState, workspaceID, lineID)
	return err
}

func (p *PostgresStore) CreateSnapshot(ctx context.Context, s *ProfitSnapshot) error {
	if s.SnapshotID == "" {
		s.SnapshotID = newUUID()
	}
	now := time.Now().UTC()
	if s.CreatedAt.IsZero() {
		s.CreatedAt = now
	}
	if s.FreshnessAt.IsZero() {
		s.FreshnessAt = now
	}

	mixJSON, _ := json.Marshal(s.SourceClassMix)
	var marginNum pgtype.Numeric
	if s.MarginPct != nil {
		marginNum = s.MarginPct.ToPgNumeric()
	}

	query := `
		INSERT INTO profit_snapshots (
			snapshot_id, workspace_id, scope_type, scope_id, period_start, period_end,
			gross_revenue, platform_fees, shipping_costs, affiliate_commissions, refund_deductions,
			cogs, ads_spend, ai_credit_costs, seeding_costs, other_costs,
			net_profit, margin_pct, source_class_mix, confidence, freshness_at,
			currency, created_at
		) VALUES (
			$1, $2, $3, $4, $5, $6,
			$7, $8, $9, $10, $11,
			$12, $13, $14, $15, $16,
			$17, $18, $19, $20, $21,
			$22, $23
		)
	`
	_, err := p.pool.Exec(ctx, query,
		s.SnapshotID, s.WorkspaceID, s.ScopeType, s.ScopeID, s.PeriodStart, s.PeriodEnd,
		s.GrossRevenue.ToPgNumeric(), s.PlatformFees.ToPgNumeric(), s.ShippingCosts.ToPgNumeric(),
		s.AffiliateCommissions.ToPgNumeric(), s.RefundDeductions.ToPgNumeric(),
		s.COGS.ToPgNumeric(), s.AdsSpend.ToPgNumeric(), s.AICreditCosts.ToPgNumeric(),
		s.SeedingCosts.ToPgNumeric(), s.OtherCosts.ToPgNumeric(),
		s.NetProfit.ToPgNumeric(), marginNum, mixJSON, s.Confidence, s.FreshnessAt,
		s.Currency, s.CreatedAt,
	)
	return err
}

func (p *PostgresStore) GetSnapshot(ctx context.Context, workspaceID, snapshotID string) (*ProfitSnapshot, error) {
	query := `
		SELECT snapshot_id, workspace_id, scope_type, scope_id, period_start, period_end,
		       gross_revenue, platform_fees, shipping_costs, affiliate_commissions, refund_deductions,
		       cogs, ads_spend, ai_credit_costs, seeding_costs, other_costs,
		       net_profit, margin_pct, source_class_mix, confidence, freshness_at,
		       currency, created_at
		FROM profit_snapshots
		WHERE workspace_id = $1 AND snapshot_id = $2
	`
	row := p.pool.QueryRow(ctx, query, workspaceID, snapshotID)
	return scanSnapshot(row)
}

func (p *PostgresStore) GetLatestSnapshot(ctx context.Context, workspaceID, scopeType, scopeID, periodStart, periodEnd string) (*ProfitSnapshot, error) {
	query := `
		SELECT snapshot_id, workspace_id, scope_type, scope_id, period_start, period_end,
		       gross_revenue, platform_fees, shipping_costs, affiliate_commissions, refund_deductions,
		       cogs, ads_spend, ai_credit_costs, seeding_costs, other_costs,
		       net_profit, margin_pct, source_class_mix, confidence, freshness_at,
		       currency, created_at
		FROM profit_snapshots
		WHERE workspace_id = $1
	`
	args := []any{workspaceID}
	idx := 2

	if scopeType != "" {
		query += fmt.Sprintf(" AND scope_type = $%d", idx)
		args = append(args, scopeType)
		idx++
	}
	if scopeID != "" {
		query += fmt.Sprintf(" AND scope_id = $%d", idx)
		args = append(args, scopeID)
		idx++
	}
	if periodStart != "" {
		query += fmt.Sprintf(" AND period_start = $%d", idx)
		args = append(args, periodStart)
		idx++
	}
	if periodEnd != "" {
		query += fmt.Sprintf(" AND period_end = $%d", idx)
		args = append(args, periodEnd)
		idx++
	}
	query += " ORDER BY freshness_at DESC LIMIT 1"

	row := p.pool.QueryRow(ctx, query, args...)
	return scanSnapshot(row)
}

func (p *PostgresStore) ListSnapshots(ctx context.Context, workspaceID, scopeType string, limit int) ([]ProfitSnapshot, error) {
	query := `
		SELECT snapshot_id, workspace_id, scope_type, scope_id, period_start, period_end,
		       gross_revenue, platform_fees, shipping_costs, affiliate_commissions, refund_deductions,
		       cogs, ads_spend, ai_credit_costs, seeding_costs, other_costs,
		       net_profit, margin_pct, source_class_mix, confidence, freshness_at,
		       currency, created_at
		FROM profit_snapshots
		WHERE workspace_id = $1
	`
	args := []any{workspaceID}
	if scopeType != "" {
		query += " AND scope_type = $2"
		args = append(args, scopeType)
	}
	query += " ORDER BY period_end DESC, freshness_at DESC"
	if limit > 0 {
		query += fmt.Sprintf(" LIMIT %d", limit)
	}

	rows, err := p.pool.Query(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []ProfitSnapshot
	for rows.Next() {
		s, err := scanSnapshotRow(rows)
		if err != nil {
			return nil, err
		}
		result = append(result, *s)
	}
	return result, nil
}

func scanSnapshot(row pgx.Row) (*ProfitSnapshot, error) {
	var s ProfitSnapshot
	var revNum, feeNum, shipNum, commNum, refNum, cogsNum, adsNum, aiNum, seedNum, otherNum, netNum, marginNum pgtype.Numeric
	var mixBytes []byte
	var scopeID *string

	err := row.Scan(
		&s.SnapshotID, &s.WorkspaceID, &s.ScopeType, &scopeID, &s.PeriodStart, &s.PeriodEnd,
		&revNum, &feeNum, &shipNum, &commNum, &refNum,
		&cogsNum, &adsNum, &aiNum, &seedNum, &otherNum,
		&netNum, &marginNum, &mixBytes, &s.Confidence, &s.FreshnessAt,
		&s.Currency, &s.CreatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errors.New("finance: profit snapshot not found")
		}
		return nil, err
	}
	if scopeID != nil {
		s.ScopeID = *scopeID
	}
	s.GrossRevenue, _ = tenantdb.FromPgNumeric(revNum)
	s.PlatformFees, _ = tenantdb.FromPgNumeric(feeNum)
	s.ShippingCosts, _ = tenantdb.FromPgNumeric(shipNum)
	s.AffiliateCommissions, _ = tenantdb.FromPgNumeric(commNum)
	s.RefundDeductions, _ = tenantdb.FromPgNumeric(refNum)
	s.COGS, _ = tenantdb.FromPgNumeric(cogsNum)
	s.AdsSpend, _ = tenantdb.FromPgNumeric(adsNum)
	s.AICreditCosts, _ = tenantdb.FromPgNumeric(aiNum)
	s.SeedingCosts, _ = tenantdb.FromPgNumeric(seedNum)
	s.OtherCosts, _ = tenantdb.FromPgNumeric(otherNum)
	s.NetProfit, _ = tenantdb.FromPgNumeric(netNum)
	if marginNum.Valid {
		m, err := tenantdb.FromPgNumeric(marginNum)
		if err == nil {
			s.MarginPct = &m
		}
	}
	if len(mixBytes) > 0 {
		_ = json.Unmarshal(mixBytes, &s.SourceClassMix)
	}
	return &s, nil
}

func scanSnapshotRow(rows pgx.Rows) (*ProfitSnapshot, error) {
	var s ProfitSnapshot
	var revNum, feeNum, shipNum, commNum, refNum, cogsNum, adsNum, aiNum, seedNum, otherNum, netNum, marginNum pgtype.Numeric
	var mixBytes []byte
	var scopeID *string

	err := rows.Scan(
		&s.SnapshotID, &s.WorkspaceID, &s.ScopeType, &scopeID, &s.PeriodStart, &s.PeriodEnd,
		&revNum, &feeNum, &shipNum, &commNum, &refNum,
		&cogsNum, &adsNum, &aiNum, &seedNum, &otherNum,
		&netNum, &marginNum, &mixBytes, &s.Confidence, &s.FreshnessAt,
		&s.Currency, &s.CreatedAt,
	)
	if err != nil {
		return nil, err
	}
	if scopeID != nil {
		s.ScopeID = *scopeID
	}
	s.GrossRevenue, _ = tenantdb.FromPgNumeric(revNum)
	s.PlatformFees, _ = tenantdb.FromPgNumeric(feeNum)
	s.ShippingCosts, _ = tenantdb.FromPgNumeric(shipNum)
	s.AffiliateCommissions, _ = tenantdb.FromPgNumeric(commNum)
	s.RefundDeductions, _ = tenantdb.FromPgNumeric(refNum)
	s.COGS, _ = tenantdb.FromPgNumeric(cogsNum)
	s.AdsSpend, _ = tenantdb.FromPgNumeric(adsNum)
	s.AICreditCosts, _ = tenantdb.FromPgNumeric(aiNum)
	s.SeedingCosts, _ = tenantdb.FromPgNumeric(seedNum)
	s.OtherCosts, _ = tenantdb.FromPgNumeric(otherNum)
	s.NetProfit, _ = tenantdb.FromPgNumeric(netNum)
	if marginNum.Valid {
		m, err := tenantdb.FromPgNumeric(marginNum)
		if err == nil {
			s.MarginPct = &m
		}
	}
	if len(mixBytes) > 0 {
		_ = json.Unmarshal(mixBytes, &s.SourceClassMix)
	}
	return &s, nil
}

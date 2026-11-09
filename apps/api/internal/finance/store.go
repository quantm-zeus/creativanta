package finance

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
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

	// Reconciliation & Matching (M19 / P1-04)
	CreateOrder(ctx context.Context, o *Order) error
	GetOrder(ctx context.Context, workspaceID, orderID string) (*Order, error)
	UpdateOrderMatched(ctx context.Context, workspaceID, orderID string, matchedAmount tenantdb.ExactDecimal, newState string) error
	CreateReconciliationRecord(ctx context.Context, r *ReconciliationRecord) error
	GetReconciliationRecord(ctx context.Context, workspaceID, recordID string) (*ReconciliationRecord, error)
	ListReconciliationRecords(ctx context.Context, workspaceID string, filter ReconciliationFilter, limit, offset int) ([]ReconciliationRecord, int64, error)
	UpdateReconciliationRecord(ctx context.Context, r *ReconciliationRecord) error
	CreateReconciliationMatch(ctx context.Context, m *ReconciliationMatch) error
	ListReconciliationMatches(ctx context.Context, workspaceID, recordID string) ([]ReconciliationMatch, error)
	AtomicMatch(ctx context.Context, workspaceID, settlementID, lineID, orderID, recordID string, allocAmount tenantdb.ExactDecimal) (*SettlementLine, *Order, *ReconciliationMatch, error)

	// Evidence Objects (§11.4 & RULE-M19-005)
	CreateEvidence(ctx context.Context, e *EvidenceObject) error
	GetEvidence(ctx context.Context, workspaceID, evidenceID string) (*EvidenceObject, error)
	ListEvidence(ctx context.Context, workspaceID string, filter EvidenceFilter, limit, offset int) ([]EvidenceObject, int64, error)
	UpdateEvidence(ctx context.Context, e *EvidenceObject) error
	DeleteEvidence(ctx context.Context, workspaceID, evidenceID string) error

	// Proof Bundles (§11.5 & RULE-M19-006)
	CreateProofBundle(ctx context.Context, pb *ProofBundle) error
	GetProofBundle(ctx context.Context, workspaceID, bundleID string) (*ProofBundle, error)
	ListProofBundles(ctx context.Context, workspaceID string, filter ProofBundleFilter, limit, offset int) ([]ProofBundle, int64, error)

	// Data Gaps & Repair Queue (M19 / M01)
	ListDataGaps(ctx context.Context, workspaceID string, filter DataGapFilter, limit, offset int) ([]DataGapItem, int64, error)
}

// ============================================================================
// MemoryStore Implementation
// ============================================================================

type MemoryStore struct {
	mu          sync.RWMutex
	postings    map[string]*FinancialPosting     // postingID -> posting
	costItems   map[string]*CostItem             // costItemID -> item
	settlements map[string]*Settlement           // settlementID -> settlement
	lines       map[string]*SettlementLine       // lineID -> line
	snapshots   map[string]*ProfitSnapshot       // snapshotID -> snapshot
	records     map[string]*ReconciliationRecord // recordID -> record
	matches     map[string]*ReconciliationMatch  // matchID -> match
	orders      map[string]*Order                // orderID -> order
	evidence    map[string]*EvidenceObject       // evidenceID -> evidence
	bundles     map[string]*ProofBundle          // bundleID -> bundle
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		postings:    make(map[string]*FinancialPosting),
		costItems:   make(map[string]*CostItem),
		settlements: make(map[string]*Settlement),
		lines:       make(map[string]*SettlementLine),
		snapshots:   make(map[string]*ProfitSnapshot),
		records:     make(map[string]*ReconciliationRecord),
		matches:     make(map[string]*ReconciliationMatch),
		orders:      make(map[string]*Order),
		evidence:    make(map[string]*EvidenceObject),
		bundles:     make(map[string]*ProofBundle),
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
	// and ensure the same target posting is never reversed more than once.
	for _, existing := range m.postings {
		if existing.WorkspaceID == p.WorkspaceID &&
			existing.OriginType == p.OriginType &&
			existing.OriginID == p.OriginID &&
			existing.OriginVersion == p.OriginVersion &&
			existing.Component == p.Component {
			return ErrDuplicatePosting
		}
		if p.ReversalOf != nil && *p.ReversalOf != "" &&
			existing.WorkspaceID == p.WorkspaceID &&
			existing.ReversalOf != nil && *existing.ReversalOf == *p.ReversalOf {
			return ErrDuplicatePosting
		}
	}

	cp := *p
	m.postings[p.PostingID] = &cp
	return nil
}

// RecordCorrectionAtomic atomically checks correction version idempotency/conflict,
// reverses the currently active posting (if any), and appends the replacement posting.
func (m *MemoryStore) RecordCorrectionAtomic(
	_ context.Context,
	workspaceID, originType, originID, component, normVersion string,
	baseNewAmount tenantdb.ExactDecimal,
	baseCurrency, sourceClass, confidence string,
	fx ExchangeRateSnapshot,
	defaultEffectiveAt, now time.Time,
) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	reversedIDs := make(map[string]bool)
	for _, p := range m.postings {
		if p.WorkspaceID == workspaceID && p.ReversalOf != nil && *p.ReversalOf != "" {
			reversedIDs[*p.ReversalOf] = true
		}
	}

	var existing *FinancialPosting
	for _, p := range m.postings {
		if p.WorkspaceID != workspaceID || p.OriginType != originType || p.OriginID != originID || p.Component != component {
			continue
		}
		if p.OriginVersion == normVersion {
			if p.Amount.Cmp(baseNewAmount) != 0 ||
				!strings.EqualFold(strings.TrimSpace(p.Currency), baseCurrency) ||
				(sourceClass != "" && p.SourceClass != "" && !strings.EqualFold(p.SourceClass, sourceClass)) {
				return fmt.Errorf("%w: conflicting payload for correction version %s on %s %s component %s", ErrDuplicatePosting, normVersion, originType, originID, component)
			}
			return nil
		}
		if p.ReversalOf == nil && !reversedIDs[p.PostingID] {
			if existing == nil || p.CreatedAt.After(existing.CreatedAt) || (p.CreatedAt.Equal(existing.CreatedAt) && p.PostingID > existing.PostingID) {
				cp := *p
				existing = &cp
			}
		}
	}

	effectiveAt := defaultEffectiveAt
	currency := baseCurrency

	if existing != nil {
		if existing.Currency != "" && !strings.EqualFold(existing.Currency, baseCurrency) {
			return fmt.Errorf("%w: correction currency %s does not match existing posting currency %s", ErrCurrencyMismatch, baseCurrency, existing.Currency)
		}
		if fx.EffectiveAt.IsZero() {
			effectiveAt = existing.EffectiveAt
		}
		currency = existing.Currency

		reversalAmount, _ := tenantdb.ZeroDecimal().Sub(existing.Amount)
		revID := existing.PostingID
		reversal := &FinancialPosting{
			PostingID:            newUUID(),
			WorkspaceID:          workspaceID,
			OriginType:           originType,
			OriginID:             originID,
			OriginVersion:        existing.OriginVersion + "-reversal",
			Component:            component,
			Amount:               reversalAmount,
			Currency:             existing.Currency,
			SourceClass:          sourceClass,
			Confidence:           confidence,
			ExchangeRateSnapshot: fx,
			ReversalOf:           &revID,
			EffectiveAt:          existing.EffectiveAt,
			CreatedAt:            now,
		}
		m.postings[reversal.PostingID] = reversal
	}

	corrected := &FinancialPosting{
		PostingID:            newUUID(),
		WorkspaceID:          workspaceID,
		OriginType:           originType,
		OriginID:             originID,
		OriginVersion:        normVersion,
		Component:            component,
		Amount:               baseNewAmount,
		Currency:             currency,
		SourceClass:          sourceClass,
		Confidence:           confidence,
		ExchangeRateSnapshot: fx,
		EffectiveAt:          effectiveAt,
		CreatedAt:            now,
	}
	m.postings[corrected.PostingID] = corrected

	if originType == "order" && component == ComponentCOGS && !baseNewAmount.IsZero() {
		if ord := m.findOrderUnlocked(workspaceID, originID); ord != nil {
			absCOGS := baseNewAmount
			if absCOGS.IsNegative() {
				absCOGS = absCOGS.Neg()
			}
			ord.COGSAmount = &absCOGS
		}
	}
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

	reversedIDs := make(map[string]bool)
	for _, p := range m.postings {
		if p.WorkspaceID == workspaceID && p.ReversalOf != nil && *p.ReversalOf != "" {
			reversedIDs[*p.ReversalOf] = true
		}
	}

	var best *FinancialPosting
	for _, p := range m.postings {
		if p.WorkspaceID == workspaceID &&
			p.OriginType == originType &&
			p.OriginID == originID &&
			(component == "" || p.Component == component) &&
			p.ReversalOf == nil &&
			!reversedIDs[p.PostingID] {
			if best == nil || p.CreatedAt.After(best.CreatedAt) || (p.CreatedAt.Equal(best.CreatedAt) && p.PostingID > best.PostingID) {
				cp := *p
				best = &cp
			}
		}
	}
	if best == nil {
		return nil, ErrPostingNotFound
	}
	return best, nil
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

// ----------------------------------------------------------------------------
// MemoryStore: Orders
// ----------------------------------------------------------------------------

func orderStoreKey(workspaceID, orderID string) string {
	if workspaceID == "" {
		return orderID
	}
	return workspaceID + ":" + orderID
}

func (m *MemoryStore) findOrderUnlocked(workspaceID, orderID string) *Order {
	if o, ok := m.orders[orderStoreKey(workspaceID, orderID)]; ok && o.WorkspaceID == workspaceID {
		return o
	}
	if o, ok := m.orders[orderID]; ok && o.WorkspaceID == workspaceID {
		return o
	}
	return nil
}

func cloneOrder(o *Order) Order {
	if o == nil {
		return Order{}
	}
	cp := *o
	if o.COGSAmount != nil {
		cogsCopy := *o.COGSAmount
		cp.COGSAmount = &cogsCopy
	}
	if o.RecognizedAt != nil {
		recCopy := o.RecognizedAt.UTC()
		cp.RecognizedAt = &recCopy
	}
	if o.SourceUpdatedAt != nil {
		updCopy := o.SourceUpdatedAt.UTC()
		cp.SourceUpdatedAt = &updCopy
	}
	if len(o.ProductIDs) > 0 {
		cp.ProductIDs = append([]string(nil), o.ProductIDs...)
	}
	if len(o.CampaignIDs) > 0 {
		cp.CampaignIDs = append([]string(nil), o.CampaignIDs...)
	}
	if len(o.PostIDs) > 0 {
		cp.PostIDs = append([]string(nil), o.PostIDs...)
	}
	if len(o.ContentIDs) > 0 {
		cp.ContentIDs = append([]string(nil), o.ContentIDs...)
	}
	return cp
}

func (m *MemoryStore) CreateOrder(_ context.Context, o *Order) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if o.OrderID == "" {
		o.OrderID = newUUID()
	}
	cp := cloneOrder(o)
	if existing := m.findOrderUnlocked(o.WorkspaceID, o.OrderID); existing != nil {
		if cp.MatchedAmount.IsZero() && !existing.MatchedAmount.IsZero() {
			cp.MatchedAmount = existing.MatchedAmount
		}
		if (cp.ReconciliationState == "" || cp.ReconciliationState == ReconciliationImportedOnly) &&
			existing.ReconciliationState != "" && existing.ReconciliationState != ReconciliationImportedOnly {
			cp.ReconciliationState = existing.ReconciliationState
		}
		if cp.COGSAmount == nil && existing.COGSAmount != nil {
			cogsCopy := *existing.COGSAmount
			cp.COGSAmount = &cogsCopy
		}
		if !cp.ZeroCOGSWithReason && existing.ZeroCOGSWithReason {
			cp.ZeroCOGSWithReason = existing.ZeroCOGSWithReason
		}
		if cp.COGSReason == "" {
			cp.COGSReason = existing.COGSReason
		}
		if cp.PlatformFeeAmount.IsZero() && !existing.PlatformFeeAmount.IsZero() {
			cp.PlatformFeeAmount = existing.PlatformFeeAmount
		}
		if cp.PaymentFeeAmount.IsZero() && !existing.PaymentFeeAmount.IsZero() {
			cp.PaymentFeeAmount = existing.PaymentFeeAmount
		}
		if cp.ShippingFeeAmount.IsZero() && !existing.ShippingFeeAmount.IsZero() {
			cp.ShippingFeeAmount = existing.ShippingFeeAmount
		}
		if cp.CommissionAmount.IsZero() && !existing.CommissionAmount.IsZero() {
			cp.CommissionAmount = existing.CommissionAmount
		}
		if cp.ExchangeRateSnapshot.IsEmpty() && !existing.ExchangeRateSnapshot.IsEmpty() {
			cp.ExchangeRateSnapshot = existing.ExchangeRateSnapshot
		}
		if cp.RecognizedAt == nil && existing.RecognizedAt != nil {
			recCopy := existing.RecognizedAt.UTC()
			cp.RecognizedAt = &recCopy
		}
		if cp.SourceUpdatedAt == nil && existing.SourceUpdatedAt != nil {
			updCopy := existing.SourceUpdatedAt.UTC()
			cp.SourceUpdatedAt = &updCopy
		}
		if !existing.OrderedAt.IsZero() && (cp.OrderedAt.IsZero() || cp.OrderedAt.After(existing.OrderedAt)) {
			cp.OrderedAt = existing.OrderedAt
		}
		if cp.SourcePlatform == "" {
			cp.SourcePlatform = existing.SourcePlatform
		}
		if cp.ProductID == "" {
			cp.ProductID = existing.ProductID
		}
		for _, id := range existing.ProductIDs {
			cp.ProductIDs = appendUniqueString(cp.ProductIDs, id)
		}
		if cp.CampaignID == "" {
			cp.CampaignID = existing.CampaignID
		}
		for _, id := range existing.CampaignIDs {
			cp.CampaignIDs = appendUniqueString(cp.CampaignIDs, id)
		}
		if cp.PostID == "" {
			cp.PostID = existing.PostID
		}
		for _, id := range existing.PostIDs {
			cp.PostIDs = appendUniqueString(cp.PostIDs, id)
		}
		if cp.ContentID == "" {
			cp.ContentID = existing.ContentID
		}
		for _, id := range existing.ContentIDs {
			cp.ContentIDs = appendUniqueString(cp.ContentIDs, id)
		}
	}
	if cp.OrderedAt.IsZero() {
		if cp.RecognizedAt != nil && !cp.RecognizedAt.IsZero() {
			cp.OrderedAt = cp.RecognizedAt.UTC()
		} else {
			cp.OrderedAt = time.Now().UTC()
		}
	}
	cp.ProductIDs = appendUniqueString(cp.ProductIDs, cp.ProductID)
	cp.CampaignIDs = appendUniqueString(cp.CampaignIDs, cp.CampaignID)
	cp.PostIDs = appendUniqueString(cp.PostIDs, cp.PostID)
	cp.ContentIDs = appendUniqueString(cp.ContentIDs, cp.ContentID)
	m.orders[orderStoreKey(o.WorkspaceID, o.OrderID)] = &cp
	return nil
}

func (m *MemoryStore) GetOrder(_ context.Context, workspaceID, orderID string) (*Order, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	o := m.findOrderUnlocked(workspaceID, orderID)
	if o == nil {
		return nil, ErrOrderNotFound
	}
	cp := cloneOrder(o)
	return &cp, nil
}

func (m *MemoryStore) ListOrders(_ context.Context, workspaceID string) ([]Order, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []Order
	for _, o := range m.orders {
		if o.WorkspaceID == workspaceID {
			result = append(result, cloneOrder(o))
		}
	}
	return result, nil
}

func (m *MemoryStore) ResolveRefundOrderID(_ context.Context, workspaceID, refundID string) (string, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, p := range m.postings {
		if p.WorkspaceID == workspaceID && p.OriginType == "refund" && p.OriginID == refundID && p.RelatedOrderID != "" {
			return p.RelatedOrderID, nil
		}
	}
	return "", nil
}

func (m *MemoryStore) UpdateOrderMatched(_ context.Context, workspaceID, orderID string, matchedAmount tenantdb.ExactDecimal, newState string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	o := m.findOrderUnlocked(workspaceID, orderID)
	if o == nil {
		return ErrOrderNotFound
	}
	if matchedAmount.Cmp(o.Amount) > 0 {
		return ErrOrderCapacityExceeded
	}
	o.MatchedAmount = matchedAmount
	if newState != "" {
		o.ReconciliationState = newState
	}
	return nil
}

// ----------------------------------------------------------------------------
// MemoryStore: Reconciliation Records & Matches
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateReconciliationRecord(_ context.Context, r *ReconciliationRecord) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if r.RecordID == "" {
		r.RecordID = newUUID()
	}
	now := time.Now().UTC()
	if r.CreatedAt.IsZero() {
		r.CreatedAt = now
	}
	if r.UpdatedAt.IsZero() {
		r.UpdatedAt = now
	}
	if r.ReconciliationState == "" {
		r.ReconciliationState = ReconciliationImportedOnly
	}
	cp := *r
	m.records[r.RecordID] = &cp
	return nil
}

func (m *MemoryStore) GetReconciliationRecord(_ context.Context, workspaceID, recordID string) (*ReconciliationRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	r, ok := m.records[recordID]
	if !ok || r.WorkspaceID != workspaceID {
		return nil, ErrRecordNotFound
	}
	cp := *r
	return &cp, nil
}

func (m *MemoryStore) ListReconciliationRecords(_ context.Context, workspaceID string, filter ReconciliationFilter, limit, offset int) ([]ReconciliationRecord, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matched []ReconciliationRecord
	for _, r := range m.records {
		if r.WorkspaceID != workspaceID {
			continue
		}
		if filter.ReconciliationState != "" && r.ReconciliationState != filter.ReconciliationState {
			continue
		}
		if filter.PeriodStart != "" && r.PeriodStart < filter.PeriodStart {
			continue
		}
		if filter.PeriodEnd != "" && r.PeriodEnd > filter.PeriodEnd {
			continue
		}
		matched = append(matched, *r)
	}

	sort.Slice(matched, func(i, j int) bool {
		return matched[i].CreatedAt.After(matched[j].CreatedAt)
	})

	total := int64(len(matched))
	if offset > len(matched) {
		return nil, total, nil
	}
	matched = matched[offset:]
	if limit > 0 && len(matched) > limit {
		matched = matched[:limit]
	}
	return matched, total, nil
}

func (m *MemoryStore) UpdateReconciliationRecord(_ context.Context, r *ReconciliationRecord) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.records[r.RecordID]
	if !ok || existing.WorkspaceID != r.WorkspaceID {
		return ErrRecordNotFound
	}
	r.UpdatedAt = time.Now().UTC()
	cp := *r
	m.records[r.RecordID] = &cp
	return nil
}

func (m *MemoryStore) CreateReconciliationMatch(_ context.Context, match *ReconciliationMatch) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if match.MatchID == "" {
		match.MatchID = newUUID()
	}
	if match.CreatedAt.IsZero() {
		match.CreatedAt = time.Now().UTC()
	}
	cp := *match
	m.matches[match.MatchID] = &cp
	return nil
}

func (m *MemoryStore) ListReconciliationMatches(_ context.Context, workspaceID, recordID string) ([]ReconciliationMatch, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []ReconciliationMatch
	for _, match := range m.matches {
		if match.WorkspaceID == workspaceID {
			if recordID == "" || match.RecordID == recordID {
				result = append(result, *match)
			}
		}
	}
	sort.Slice(result, func(i, j int) bool {
		return result[i].CreatedAt.Before(result[j].CreatedAt)
	})
	return result, nil
}

// AtomicMatch executes a concurrent-safe partial match enforcing remaining capacity on BOTH the line and order.
func (m *MemoryStore) AtomicMatch(
	_ context.Context,
	workspaceID, settlementID, lineID, orderID, recordID string,
	allocAmount tenantdb.ExactDecimal,
) (*SettlementLine, *Order, *ReconciliationMatch, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	line, ok := m.lines[lineID]
	if !ok || line.WorkspaceID != workspaceID {
		return nil, nil, nil, errors.New("finance: settlement line not found")
	}

	order := m.findOrderUnlocked(workspaceID, orderID)
	if order == nil {
		return nil, nil, nil, ErrOrderNotFound
	}

	// 1. Enforce settlement line capacity
	newLineMatched, err := line.MatchedAmount.Add(allocAmount)
	if err != nil {
		return nil, nil, nil, err
	}
	if newLineMatched.Cmp(line.NetAmount) > 0 {
		return nil, nil, nil, ErrCapacityExceeded
	}

	// 2. Enforce order capacity
	newOrderMatched, err := order.MatchedAmount.Add(allocAmount)
	if err != nil {
		return nil, nil, nil, err
	}
	if newOrderMatched.Cmp(order.Amount) > 0 {
		return nil, nil, nil, ErrOrderCapacityExceeded
	}

	// 3. Update settlement line state
	line.MatchedAmount = newLineMatched
	if newLineMatched.Cmp(line.NetAmount) == 0 {
		line.ReconciliationState = ReconciliationFullyReconciled
	} else {
		line.ReconciliationState = ReconciliationPartiallyReconciled
	}

	// 4. Update order state
	order.MatchedAmount = newOrderMatched
	if newOrderMatched.Cmp(order.Amount) == 0 {
		order.ReconciliationState = ReconciliationFullyReconciled
	} else {
		order.ReconciliationState = ReconciliationPartiallyReconciled
	}

	// 5. Create durable match link
	match := &ReconciliationMatch{
		MatchID:         newUUID(),
		WorkspaceID:     workspaceID,
		RecordID:        recordID,
		SettlementID:    settlementID,
		LineID:          lineID,
		OrderID:         orderID,
		AllocatedAmount: allocAmount,
		Currency:        line.Currency,
		CreatedAt:       time.Now().UTC(),
	}
	m.matches[match.MatchID] = match

	// 6. Update batch record if supplied
	if recordID != "" {
		if rec, ok := m.records[recordID]; ok && rec.WorkspaceID == workspaceID {
			rec.MatchedAmount, _ = rec.MatchedAmount.Add(allocAmount)
			rec.UpdatedAt = time.Now().UTC()
		}
	}

	lineCopy := *line
	orderCopy := *order
	matchCopy := *match
	return &lineCopy, &orderCopy, &matchCopy, nil
}

// ----------------------------------------------------------------------------
// MemoryStore: Evidence Objects (§11.4 & RULE-M19-005)
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateEvidence(_ context.Context, e *EvidenceObject) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if e.EvidenceID == "" {
		e.EvidenceID = newUUID()
	}
	now := time.Now().UTC()
	if e.CollectedAt.IsZero() {
		e.CollectedAt = now
	}
	if e.CreatedAt.IsZero() {
		e.CreatedAt = now
	}
	if e.VerificationStatus == "" {
		e.VerificationStatus = VerificationStatusPending
	}
	cp := *e
	m.evidence[e.EvidenceID] = &cp
	return nil
}

func (m *MemoryStore) GetEvidence(_ context.Context, workspaceID, evidenceID string) (*EvidenceObject, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	e, ok := m.evidence[evidenceID]
	if !ok || e.WorkspaceID != workspaceID {
		return nil, ErrEvidenceNotFound
	}
	cp := *e
	return &cp, nil
}

func (m *MemoryStore) ListEvidence(_ context.Context, workspaceID string, filter EvidenceFilter, limit, offset int) ([]EvidenceObject, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matched []EvidenceObject
	for _, e := range m.evidence {
		if e.WorkspaceID != workspaceID || e.DeletedAt != nil {
			continue
		}
		if filter.EvidenceType != "" && e.EvidenceType != filter.EvidenceType {
			continue
		}
		if filter.VerificationStatus != "" && e.VerificationStatus != filter.VerificationStatus {
			continue
		}
		matched = append(matched, *e)
	}

	sort.Slice(matched, func(i, j int) bool {
		return matched[i].CreatedAt.After(matched[j].CreatedAt)
	})

	total := int64(len(matched))
	if offset > len(matched) {
		return nil, total, nil
	}
	matched = matched[offset:]
	if limit > 0 && len(matched) > limit {
		matched = matched[:limit]
	}
	return matched, total, nil
}

// UpdateEvidence strictly enforces evidence immutability (RULE-M19-005).
// Only VerificationStatus may be updated; altering content fields is rejected.
func (m *MemoryStore) UpdateEvidence(_ context.Context, e *EvidenceObject) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.evidence[e.EvidenceID]
	if !ok || existing.WorkspaceID != e.WorkspaceID {
		return ErrEvidenceNotFound
	}

	// Invariant: Content fields CANNOT be modified!
	if existing.WorkspaceID != e.WorkspaceID ||
		existing.EvidenceType != e.EvidenceType ||
		existing.SourceProvenance != e.SourceProvenance ||
		existing.ContentHash != e.ContentHash ||
		existing.FileURL != e.FileURL ||
		existing.PayloadJSON != e.PayloadJSON {
		return ErrEvidenceImmutable
	}

	existing.VerificationStatus = e.VerificationStatus
	return nil
}

// DeleteEvidence rejects hard deletion (RULE-M19-005).
func (m *MemoryStore) DeleteEvidence(_ context.Context, workspaceID, evidenceID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	e, ok := m.evidence[evidenceID]
	if !ok || e.WorkspaceID != workspaceID {
		return ErrEvidenceNotFound
	}

	// Invariant: Evidence objects cannot be hard-deleted
	return ErrEvidenceImmutable
}

// ----------------------------------------------------------------------------
// MemoryStore: Proof Bundles (§11.5 & RULE-M19-006)
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateProofBundle(_ context.Context, pb *ProofBundle) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if pb.ProofBundleID == "" {
		pb.ProofBundleID = newUUID()
	}
	now := time.Now().UTC()
	if pb.CreatedAt.IsZero() {
		pb.CreatedAt = now
	}
	if pb.UpdatedAt.IsZero() {
		pb.UpdatedAt = now
	}
	if pb.Confidence == "" {
		pb.Confidence = ConfidenceMedium
	}
	cp := *pb
	m.bundles[pb.ProofBundleID] = &cp
	return nil
}

func (m *MemoryStore) GetProofBundle(_ context.Context, workspaceID, bundleID string) (*ProofBundle, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	pb, ok := m.bundles[bundleID]
	if !ok || pb.WorkspaceID != workspaceID || pb.DeletedAt != nil {
		return nil, ErrProofBundleNotFound
	}
	cp := *pb
	return &cp, nil
}

func (m *MemoryStore) ListProofBundles(_ context.Context, workspaceID string, filter ProofBundleFilter, limit, offset int) ([]ProofBundle, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matched []ProofBundle
	for _, pb := range m.bundles {
		if pb.WorkspaceID != workspaceID || pb.DeletedAt != nil {
			continue
		}
		if filter.ClaimScope != "" && pb.ClaimScope != filter.ClaimScope {
			continue
		}
		matched = append(matched, *pb)
	}

	sort.Slice(matched, func(i, j int) bool {
		return matched[i].CreatedAt.After(matched[j].CreatedAt)
	})

	total := int64(len(matched))
	if offset > len(matched) {
		return nil, total, nil
	}
	matched = matched[offset:]
	if limit > 0 && len(matched) > limit {
		matched = matched[:limit]
	}
	return matched, total, nil
}

// ----------------------------------------------------------------------------
// MemoryStore: Data Gaps & Repair Queue (M19 / M01)
// ----------------------------------------------------------------------------

func (m *MemoryStore) orderHasActiveCOGSUnlocked(workspaceID, orderID string, reversedIDs map[string]bool) bool {
	if o := m.findOrderUnlocked(workspaceID, orderID); o != nil {
		if (o.COGSAmount != nil && !o.COGSAmount.IsZero()) || o.HasConfirmedZeroCOGS() {
			return true
		}
	}
	for _, ci := range m.costItems {
		if ci.WorkspaceID == workspaceID &&
			ci.CostState != CostStateSuperseded &&
			strings.EqualFold(ci.CostType, "cogs") &&
			strings.EqualFold(ci.RelatedScopeType, "order") &&
			ci.RelatedScopeID == orderID {
			if !ci.Amount.IsZero() || strings.TrimSpace(ci.ConfidenceReason) != "" {
				return true
			}
		}
	}
	for _, p := range m.postings {
		if p.WorkspaceID != workspaceID || p.ReversalOf != nil || reversedIDs[p.PostingID] || p.Component != ComponentCOGS {
			continue
		}
		if p.OriginType == "order" && p.OriginID == orderID && !p.Amount.IsZero() {
			return true
		}
		if p.OriginType == "cost_item" && !p.Amount.IsZero() {
			if ci, ok := m.costItems[p.OriginID]; ok &&
				ci.WorkspaceID == workspaceID &&
				ci.CostState != CostStateSuperseded &&
				strings.EqualFold(ci.RelatedScopeType, "order") &&
				ci.RelatedScopeID == orderID {
				return true
			}
		}
	}
	return false
}

func (m *MemoryStore) ListDataGaps(_ context.Context, workspaceID string, filter DataGapFilter, limit, offset int) ([]DataGapItem, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var items []DataGapItem

	reversedIDs := make(map[string]bool)
	for _, p := range m.postings {
		if p.WorkspaceID == workspaceID && p.ReversalOf != nil && *p.ReversalOf != "" {
			reversedIDs[*p.ReversalOf] = true
		}
	}

	// 1. Missing COGS on completed orders (both stored orders and recognized order revenue postings)
	seenMissingCOGSOrders := make(map[string]bool)
	for _, order := range m.orders {
		if order.WorkspaceID != workspaceID {
			continue
		}
		if order.LifecycleState == "completed" && !m.orderHasActiveCOGSUnlocked(workspaceID, order.OrderID, reversedIDs) {
			seenMissingCOGSOrders[order.OrderID] = true
			items = append(items, DataGapItem{
				GapID:              "gap-cogs-" + order.OrderID,
				GapType:            "missing_cogs",
				Severity:           "critical",
				Title:              "Đơn hàng thiếu giá vốn (COGS)",
				Description:        "Đơn hàng hoàn tất nhưng chưa có bản ghi giá vốn thực tế.",
				RelatedObjectType:  "order",
				RelatedObjectID:    order.OrderID,
				MonetaryAmount:     order.Amount,
				UnresolvedSince:    order.EffectiveTime(),
				RepairCTALabel:     "Nhập giá vốn",
				RepairCTARoute:     "/finance/costs?order_id=" + order.OrderID,
				RequiredPermission: "cost:manage",
			})
		}
	}
	for _, p := range m.postings {
		if p.WorkspaceID != workspaceID || p.ReversalOf != nil || reversedIDs[p.PostingID] {
			continue
		}
		if p.OriginType == "order" && p.Component == ComponentRevenue && !seenMissingCOGSOrders[p.OriginID] {
			if !m.orderHasActiveCOGSUnlocked(workspaceID, p.OriginID, reversedIDs) {
				seenMissingCOGSOrders[p.OriginID] = true
				items = append(items, DataGapItem{
					GapID:              "gap-cogs-" + p.OriginID,
					GapType:            "missing_cogs",
					Severity:           "critical",
					Title:              "Đơn hàng thiếu giá vốn (COGS)",
					Description:        "Đơn hàng hoàn tất nhưng chưa có bản ghi giá vốn thực tế.",
					RelatedObjectType:  "order",
					RelatedObjectID:    p.OriginID,
					MonetaryAmount:     p.Amount,
					UnresolvedSince:    p.EffectiveAt,
					RepairCTALabel:     "Nhập giá vốn",
					RepairCTARoute:     "/finance/costs?order_id=" + p.OriginID,
					RequiredPermission: "cost:manage",
				})
			}
		}
	}

	// 2. Unreconciled settlement lines
	for _, line := range m.lines {
		if line.WorkspaceID != workspaceID {
			continue
		}
		if line.ReconciliationState == ReconciliationImportedOnly ||
			line.ReconciliationState == ReconciliationPartiallyReconciled ||
			line.ReconciliationState == ReconciliationAwaitingEvidence {
			rem, _ := line.NetAmount.Sub(line.MatchedAmount)
			if rem.Cmp(tenantdb.ZeroDecimal()) > 0 {
				items = append(items, DataGapItem{
					GapID:              "gap-sment-" + line.LineID,
					GapType:            "unreconciled_settlement",
					Severity:           "warning",
					Title:              "Khoản thanh toán chưa đối soát",
					Description:        "Khoản tiền sàn đã giải ngân nhưng chưa khớp với đơn hàng tương ứng.",
					RelatedObjectType:  "settlement_line",
					RelatedObjectID:    line.LineID,
					MonetaryAmount:     rem,
					UnresolvedSince:    line.CreatedAt,
					RepairCTALabel:     "Khớp đối soát",
					RepairCTARoute:     "/finance/reconciliation?line_id=" + line.LineID,
					RequiredPermission: "reconciliation:manage",
				})
			}
		}
	}

	// 3. Cost items pending evidence
	for _, item := range m.costItems {
		if item.WorkspaceID != workspaceID {
			continue
		}
		if item.CostState == CostStatePendingEvidence {
			items = append(items, DataGapItem{
				GapID:              "gap-cost-" + item.CostItemID,
				GapType:            "missing_evidence",
				Severity:           "warning",
				Title:              "Chi phí chưa có chứng từ hợp lệ",
				Description:        "Chi phí được ghi nhận ước tính nhưng chưa đính kèm chứng từ.",
				RelatedObjectType:  "cost_item",
				RelatedObjectID:    item.CostItemID,
				MonetaryAmount:     item.Amount,
				UnresolvedSince:    item.CreatedAt,
				RepairCTALabel:     "Tải lên chứng từ",
				RepairCTARoute:     "/finance/evidence?cost_id=" + item.CostItemID,
				RequiredPermission: "evidence:submit",
			})
		}
	}

	// Severity ranking: critical (1) > warning (2) > info (3)
	severityRank := func(s string) int {
		switch s {
		case "critical":
			return 1
		case "warning":
			return 2
		default:
			return 3
		}
	}

	// Sort by: explicit severity, oldest unresolved timestamp, then stable object identity (§RULE-M19-001)
	sort.Slice(items, func(i, j int) bool {
		rI := severityRank(items[i].Severity)
		rJ := severityRank(items[j].Severity)
		if rI != rJ {
			return rI < rJ
		}
		if !items[i].UnresolvedSince.Equal(items[j].UnresolvedSince) {
			return items[i].UnresolvedSince.Before(items[j].UnresolvedSince)
		}
		return items[i].GapID < items[j].GapID
	})

	// Filtering
	startUTC, endUTC, _ := parseReportPeriodBounds(filter.PeriodStart, filter.PeriodEnd)
	filterProdID := strings.TrimSpace(filter.ProductID)
	var filtered []DataGapItem
	for _, item := range items {
		if filter.Severity != "" && item.Severity != filter.Severity {
			continue
		}
		if filter.GapType != "" && item.GapType != filter.GapType {
			continue
		}
		if (startUTC != nil || endUTC != nil) && !timeWithinPeriodBounds(item.UnresolvedSince, startUTC, endUTC) {
			continue
		}
		if filterProdID != "" && item.RelatedObjectType == "order" {
			ord := m.findOrderUnlocked(workspaceID, item.RelatedObjectID)
			if ord == nil || !orderMatchesProduct(*ord, filterProdID) {
				continue
			}
		}
		filtered = append(filtered, item)
	}

	total := int64(len(filtered))
	if offset > len(filtered) {
		return nil, total, nil
	}
	filtered = filtered[offset:]
	if limit > 0 && len(filtered) > limit {
		filtered = filtered[:limit]
	}
	return filtered, total, nil
}

// ============================================================================
// PostgresStore Implementation
// ============================================================================

const defaultServiceUserID = "00000000-0000-4000-8000-000000000001"

const setLocalTenantContextSQL = `
SELECT
  set_config('app.current_tenant_id', $1, true),
  set_config('app.current_user_id', $2, true)
`

type activeTxContextKey struct{}

type activeTenantTx struct {
	tx          pgx.Tx
	workspaceID string
}

type PostgresStore struct {
	pool     *pgxpool.Pool
	beginner tenantdb.TxBeginner
}

func NewPostgresStore(pool *pgxpool.Pool) *PostgresStore {
	var b tenantdb.TxBeginner
	if pool != nil {
		b = pool
	}
	return &PostgresStore{pool: pool, beginner: b}
}

func NewPostgresStoreWithBeginner(beginner tenantdb.TxBeginner) *PostgresStore {
	return &PostgresStore{beginner: beginner}
}

func (p *PostgresStore) txBeginner() tenantdb.TxBeginner {
	if p.beginner != nil {
		return p.beginner
	}
	if p.pool != nil {
		return p.pool
	}
	return nil
}

func (p *PostgresStore) withTenantTx(ctx context.Context, workspaceID string, fn func(ctx context.Context, tx pgx.Tx) error) (retErr error) {
	if ctx == nil {
		return tenantdb.ErrNilContext
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	wsID := strings.TrimSpace(workspaceID)
	if wsID == "" {
		return ErrMissingTenant
	}
	userID := defaultServiceUserID
	if sc, ok := tenantdb.ScopeFromContext(ctx); ok {
		if sc.WorkspaceID != "" && sc.WorkspaceID != wsID {
			return tenantdb.ErrScopeMismatch
		}
		if sc.UserID != "" {
			userID = sc.UserID
		}
	}
	if active, ok := ctx.Value(activeTxContextKey{}).(activeTenantTx); ok && active.tx != nil {
		if active.workspaceID != wsID {
			return tenantdb.ErrScopeMismatch
		}
		return fn(ctx, active.tx)
	}
	b := p.txBeginner()
	if b == nil {
		return tenantdb.ErrNilBeginner
	}
	tx, err := b.Begin(ctx)
	if err != nil {
		return fmt.Errorf("finance: begin tenant transaction: %w", err)
	}
	committed := false
	defer func() {
		if rec := recover(); rec != nil {
			_ = tx.Rollback(context.Background())
			panic(rec)
		}
		if !committed {
			_ = tx.Rollback(context.Background())
		}
	}()

	var configuredTenant, configuredUser string
	if err := tx.QueryRow(ctx, setLocalTenantContextSQL, wsID, userID).Scan(&configuredTenant, &configuredUser); err != nil {
		return fmt.Errorf("finance: set local tenant context: %w", err)
	}
	if configuredTenant != wsID || configuredUser != userID {
		return fmt.Errorf("%w: set_config verification mismatch", tenantdb.ErrInvalidTenantScope)
	}

	txCtx := context.WithValue(ctx, activeTxContextKey{}, activeTenantTx{
		tx:          tx,
		workspaceID: wsID,
	})
	if err := fn(txCtx, tx); err != nil {
		return err
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("finance: commit tenant transaction: %w", err)
	}
	committed = true
	return nil
}

type postingSnapshotEnvelope struct {
	ExchangeRateSnapshot
	RelatedOrderID string `json:"related_order_id,omitempty"`
}

func (p *PostgresStore) CreatePosting(ctx context.Context, post *FinancialPosting) error {
	if post.PostingID == "" {
		post.PostingID = newUUID()
	}
	if post.CreatedAt.IsZero() {
		post.CreatedAt = time.Now().UTC()
	}

	fxJSON, err := json.Marshal(postingSnapshotEnvelope{
		ExchangeRateSnapshot: post.ExchangeRateSnapshot,
		RelatedOrderID:       post.RelatedOrderID,
	})
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
	return p.withTenantTx(ctx, post.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if post.ReversalOf != nil && strings.TrimSpace(*post.ReversalOf) != "" {
			var existingRev int
			revCheckErr := tx.QueryRow(txCtx, `
				SELECT 1 FROM financial_postings
				WHERE workspace_id = $1 AND reversal_of = $2
				LIMIT 1
			`, post.WorkspaceID, *post.ReversalOf).Scan(&existingRev)
			if revCheckErr == nil {
				return ErrDuplicatePosting
			}
		}
		_, err := tx.Exec(txCtx, query,
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
	})
}

// RecordCorrectionAtomic atomically locks existing postings for the origin/component in PostgreSQL,
// checks version idempotency/conflict, inserts a reversal of the active posting (if any), and inserts
// the replacement posting in a single tenant-scoped transaction.
func (p *PostgresStore) RecordCorrectionAtomic(
	ctx context.Context,
	workspaceID, originType, originID, component, normVersion string,
	baseNewAmount tenantdb.ExactDecimal,
	baseCurrency, sourceClass, confidence string,
	fx ExchangeRateSnapshot,
	defaultEffectiveAt, now time.Time,
) error {
	fxJSON, err := json.Marshal(postingSnapshotEnvelope{
		ExchangeRateSnapshot: fx,
	})
	if err != nil {
		return fmt.Errorf("marshal fx snapshot: %w", err)
	}

	return p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if _, lockErr := tx.Exec(txCtx, `
			SELECT pg_advisory_xact_lock(hashtext($1), hashtext($2 || ':' || $3 || ':' || $4))
		`, workspaceID, originType, originID, component); lockErr != nil {
			return fmt.Errorf("acquire correction advisory lock: %w", lockErr)
		}
		rows, err := tx.Query(txCtx, `
			SELECT posting_id, workspace_id, origin_type, origin_id, origin_version,
			       component, amount, currency, source_class, confidence,
			       exchange_rate_snapshot, reversal_of, effective_at, created_at
			FROM financial_postings
			WHERE workspace_id = $1 AND origin_type = $2 AND origin_id = $3 AND component = $4
			ORDER BY created_at ASC, posting_id ASC
		`, workspaceID, originType, originID, component)
		if err != nil {
			return fmt.Errorf("lock postings for correction: %w", err)
		}
		var history []FinancialPosting
		for rows.Next() {
			item, scanErr := scanPostingRow(rows)
			if scanErr != nil {
				rows.Close()
				return scanErr
			}
			history = append(history, *item)
		}
		if err := rows.Err(); err != nil {
			rows.Close()
			return err
		}
		rows.Close()

		reversedIDs := make(map[string]bool)
		for _, h := range history {
			if h.ReversalOf != nil && *h.ReversalOf != "" {
				reversedIDs[*h.ReversalOf] = true
			}
		}

		var existing *FinancialPosting
		for i := range history {
			h := history[i]
			if h.OriginVersion == normVersion {
				if h.Amount.Cmp(baseNewAmount) != 0 ||
					!strings.EqualFold(strings.TrimSpace(h.Currency), baseCurrency) ||
					(sourceClass != "" && h.SourceClass != "" && !strings.EqualFold(h.SourceClass, sourceClass)) {
					return fmt.Errorf("%w: conflicting payload for correction version %s on %s %s component %s", ErrDuplicatePosting, normVersion, originType, originID, component)
				}
				return nil
			}
			if h.ReversalOf == nil && !reversedIDs[h.PostingID] {
				cp := h
				existing = &cp
			}
		}

		effectiveAt := defaultEffectiveAt
		currency := baseCurrency

		insertQuery := `
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

		if existing != nil {
			if existing.Currency != "" && !strings.EqualFold(existing.Currency, baseCurrency) {
				return fmt.Errorf("%w: correction currency %s does not match existing posting currency %s", ErrCurrencyMismatch, baseCurrency, existing.Currency)
			}
			if fx.EffectiveAt.IsZero() {
				effectiveAt = existing.EffectiveAt
			}
			currency = existing.Currency

			reversalAmount, _ := tenantdb.ZeroDecimal().Sub(existing.Amount)
			revID := existing.PostingID
			_, err := tx.Exec(txCtx, insertQuery,
				newUUID(), workspaceID, originType, originID, existing.OriginVersion+"-reversal",
				component, reversalAmount.ToPgNumeric(), existing.Currency, sourceClass, confidence,
				fxJSON, &revID, existing.EffectiveAt, now,
			)
			if err != nil {
				if strings.Contains(err.Error(), "duplicate key") || strings.Contains(err.Error(), "unique constraint") {
					return ErrDuplicatePosting
				}
				return fmt.Errorf("create reversal posting: %w", err)
			}
		}

		_, err = tx.Exec(txCtx, insertQuery,
			newUUID(), workspaceID, originType, originID, normVersion,
			component, baseNewAmount.ToPgNumeric(), currency, sourceClass, confidence,
			fxJSON, (*string)(nil), effectiveAt, now,
		)
		if err != nil {
			if strings.Contains(err.Error(), "duplicate key") || strings.Contains(err.Error(), "unique constraint") {
				return ErrDuplicatePosting
			}
			return fmt.Errorf("create corrected posting: %w", err)
		}

		if originType == "order" && component == ComponentCOGS && !baseNewAmount.IsZero() {
			absCOGS := baseNewAmount
			if absCOGS.IsNegative() {
				absCOGS = absCOGS.Neg()
			}
			cogsPatch, _ := json.Marshal(map[string]any{"cogs": absCOGS.Fixed6String()})
			_, _ = tx.Exec(txCtx, `
				UPDATE orders
				SET fee_breakdown = COALESCE(fee_breakdown, '{}'::jsonb) || $1::jsonb,
				    updated_at = NOW()
				WHERE workspace_id = $2 AND order_id::text = $3
			`, cogsPatch, workspaceID, originID)
		}
		return nil
	})
}

func (p *PostgresStore) GetPosting(ctx context.Context, workspaceID, postingID string) (*FinancialPosting, error) {
	query := `
		SELECT posting_id, workspace_id, origin_type, origin_id, origin_version,
		       component, amount, currency, source_class, confidence,
		       exchange_rate_snapshot, reversal_of, effective_at, created_at
		FROM financial_postings
		WHERE workspace_id = $1 AND posting_id = $2
	`
	var post *FinancialPosting
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		post, scanErr = scanPosting(tx.QueryRow(txCtx, query, workspaceID, postingID))
		return scanErr
	})
	return post, err
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

	var result []FinancialPosting
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, query, args...)
		if err != nil {
			return fmt.Errorf("list postings: %w", err)
		}
		defer rows.Close()

		for rows.Next() {
			item, err := scanPostingRow(rows)
			if err != nil {
				return err
			}
			result = append(result, *item)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
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
		  AND reversal_of IS NULL
		  AND NOT EXISTS (
		      SELECT 1 FROM financial_postings r
		      WHERE r.workspace_id = financial_postings.workspace_id
		        AND r.reversal_of = financial_postings.posting_id
		  )
		ORDER BY created_at DESC
		LIMIT 1
	`
	var post *FinancialPosting
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		post, scanErr = scanPosting(tx.QueryRow(txCtx, query, workspaceID, originType, originID, component))
		return scanErr
	})
	return post, err
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
		var env postingSnapshotEnvelope
		if json.Unmarshal(fxBytes, &env) == nil {
			post.ExchangeRateSnapshot = env.ExchangeRateSnapshot
			post.RelatedOrderID = env.RelatedOrderID
		}
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
		var env postingSnapshotEnvelope
		if json.Unmarshal(fxBytes, &env) == nil {
			post.ExchangeRateSnapshot = env.ExchangeRateSnapshot
			post.RelatedOrderID = env.RelatedOrderID
		}
	}
	return &post, nil
}

func nullableString(s string) *string {
	trimmed := strings.TrimSpace(s)
	if trimmed == "" {
		return nil
	}
	return &trimmed
}

func isUUIDFormat(s string) bool {
	if len(s) != 36 {
		return false
	}
	for i := 0; i < len(s); i++ {
		c := s[i]
		if i == 8 || i == 13 || i == 18 || i == 23 {
			if c != '-' {
				return false
			}
			continue
		}
		if !((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')) {
			return false
		}
	}
	return true
}

func nullableUUIDString(s string) *string {
	trimmed := strings.TrimSpace(s)
	if !isUUIDFormat(trimmed) {
		return nil
	}
	return &trimmed
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
	if strings.TrimSpace(item.EffectiveDate) == "" {
		item.EffectiveDate = now.Format("2006-01-02")
	}

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
	return p.withTenantTx(ctx, item.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			item.CostItemID, item.WorkspaceID, item.CostType, item.Amount.ToPgNumeric(), item.Currency,
			nullableString(item.Description), nullableString(item.RelatedScopeType), nullableUUIDString(item.RelatedScopeID), item.SourceClass,
			nullableUUIDString(item.EvidenceID), nullableString(item.ConfidenceReason), item.CostState, item.EffectiveDate,
			item.CreatedAt, item.UpdatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetCostItem(ctx context.Context, workspaceID, costItemID string) (*CostItem, error) {
	query := `
		SELECT cost_item_id::text, workspace_id::text, cost_type, amount, currency,
		       COALESCE(description, ''), COALESCE(related_scope_type, ''),
		       COALESCE(related_scope_id::text, ''), source_class::text,
		       COALESCE(evidence_id::text, ''), COALESCE(confidence_reason, ''),
		       cost_state, COALESCE(effective_date::text, ''),
		       created_at, updated_at
		FROM cost_items
		WHERE workspace_id = $1 AND cost_item_id = $2 AND deleted_at IS NULL
	`
	var item CostItem
	var num pgtype.Numeric
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, query, workspaceID, costItemID).Scan(
			&item.CostItemID, &item.WorkspaceID, &item.CostType, &num, &item.Currency,
			&item.Description, &item.RelatedScopeType, &item.RelatedScopeID, &item.SourceClass,
			&item.EvidenceID, &item.ConfidenceReason, &item.CostState, &item.EffectiveDate,
			&item.CreatedAt, &item.UpdatedAt,
		)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrCostItemNotFound
			}
			return err
		}
		return nil
	})
	if err != nil {
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
		baseQuery += fmt.Sprintf(" AND related_scope_id::text = $%d", idx)
		args = append(args, filter.RelatedScopeID)
		idx++
	}
	if filter.PeriodStart != "" {
		baseQuery += fmt.Sprintf(" AND effective_date >= $%d::date", idx)
		args = append(args, filter.PeriodStart)
		idx++
	}
	if filter.PeriodEnd != "" {
		baseQuery += fmt.Sprintf(" AND effective_date <= $%d::date", idx)
		args = append(args, filter.PeriodEnd)
		idx++
	}

	countQuery := "SELECT count(*) " + baseQuery
	dataQuery := `
		SELECT cost_item_id::text, workspace_id::text, cost_type, amount, currency,
		       COALESCE(description, ''), COALESCE(related_scope_type, ''),
		       COALESCE(related_scope_id::text, ''), source_class::text,
		       COALESCE(evidence_id::text, ''), COALESCE(confidence_reason, ''),
		       cost_state, COALESCE(effective_date::text, ''),
		       created_at, updated_at ` + baseQuery + fmt.Sprintf(" ORDER BY effective_date DESC, created_at DESC LIMIT $%d OFFSET $%d", idx, idx+1)
	dataArgs := append(append([]any{}, args...), limit, offset)

	var total int64
	var result []CostItem
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, countQuery, args...).Scan(&total); err != nil {
			return err
		}
		rows, err := tx.Query(txCtx, dataQuery, dataArgs...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var item CostItem
			var num pgtype.Numeric
			if err := rows.Scan(
				&item.CostItemID, &item.WorkspaceID, &item.CostType, &num, &item.Currency,
				&item.Description, &item.RelatedScopeType, &item.RelatedScopeID, &item.SourceClass,
				&item.EvidenceID, &item.ConfidenceReason, &item.CostState, &item.EffectiveDate,
				&item.CreatedAt, &item.UpdatedAt,
			); err != nil {
				return err
			}
			item.Amount, err = tenantdb.FromPgNumeric(num)
			if err != nil {
				return err
			}
			result = append(result, item)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, 0, err
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
	return p.withTenantTx(ctx, item.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		cmd, err := tx.Exec(txCtx, query,
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
	})
}

func (p *PostgresStore) DeleteCostItem(ctx context.Context, workspaceID, costItemID string) error {
	query := `
		UPDATE cost_items
		SET deleted_at = NOW(), updated_at = NOW()
		WHERE workspace_id = $1 AND cost_item_id = $2 AND deleted_at IS NULL
	`
	return p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		cmd, err := tx.Exec(txCtx, query, workspaceID, costItemID)
		if err != nil {
			return err
		}
		if cmd.RowsAffected() == 0 {
			return ErrCostItemNotFound
		}
		return nil
	})
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
	relatedOrders := []string{}
	for _, id := range s.RelatedOrderIDs {
		if isUUIDFormat(strings.TrimSpace(id)) {
			relatedOrders = append(relatedOrders, strings.TrimSpace(id))
		}
	}

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
	return p.withTenantTx(ctx, s.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			s.SettlementID, s.WorkspaceID, s.SourceClass, nullableString(s.SourcePlatform),
			nullableString(s.ExternalSettlementID), nullableUUIDString(s.ConnectedAccountID), fxJSON,
			nullableString(s.ImportFingerprint), s.GrossAmount.ToPgNumeric(), s.NetAmount.ToPgNumeric(), feesJSON, dedJSON,
			s.Currency, s.SettlementState, toPgReconciliationState(s.ReconciliationState), relatedOrders,
			nullableString(s.EffectiveDate), s.CreatedAt, s.UpdatedAt,
		)
		if err != nil {
			if strings.Contains(err.Error(), "duplicate key") || strings.Contains(err.Error(), "unique constraint") {
				return ErrDuplicateSettlement
			}
			return err
		}
		return nil
	})
}

func (p *PostgresStore) GetSettlement(ctx context.Context, workspaceID, settlementID string) (*Settlement, error) {
	query := `
		SELECT settlement_id::text, workspace_id::text, source_class::text, COALESCE(source_platform, ''),
		       COALESCE(external_settlement_id, ''), COALESCE(connected_account_id::text, ''), exchange_rate_snapshot,
		       COALESCE(import_fingerprint, ''), gross_amount, net_amount, COALESCE(fees, '{}'::jsonb), COALESCE(deductions, '{}'::jsonb),
		       currency, settlement_state, reconciliation_state::text, COALESCE(related_order_ids::text[], '{}'::text[]),
		       COALESCE(effective_date::text, ''), created_at, updated_at
		FROM settlements
		WHERE workspace_id = $1 AND settlement_id = $2 AND deleted_at IS NULL
	`
	var s Settlement
	var grossNum, netNum pgtype.Numeric
	var fxBytes, feesBytes, dedBytes []byte

	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, query, workspaceID, settlementID).Scan(
			&s.SettlementID, &s.WorkspaceID, &s.SourceClass, &s.SourcePlatform,
			&s.ExternalSettlementID, &s.ConnectedAccountID, &fxBytes,
			&s.ImportFingerprint, &grossNum, &netNum, &feesBytes, &dedBytes,
			&s.Currency, &s.SettlementState, &s.ReconciliationState, &s.RelatedOrderIDs,
			&s.EffectiveDate, &s.CreatedAt, &s.UpdatedAt,
		)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrSettlementNotFound
			}
			return err
		}
		s.ReconciliationState = fromPgReconciliationState(s.ReconciliationState)
		s.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
		s.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
		_ = json.Unmarshal(fxBytes, &s.ExchangeRateSnapshot)
		_ = json.Unmarshal(feesBytes, &s.Fees)
		_ = json.Unmarshal(dedBytes, &s.Deductions)

		lines, err := p.ListSettlementLines(txCtx, workspaceID, settlementID)
		if err == nil {
			s.Lines = lines
		}
		return nil
	})
	if err != nil {
		return nil, err
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
		baseQuery += fmt.Sprintf(" AND reconciliation_state::text = $%d", idx)
		args = append(args, toPgReconciliationState(filter.ReconciliationState))
		idx++
	}

	countQuery := "SELECT count(*) " + baseQuery
	dataQuery := `
		SELECT settlement_id::text, workspace_id::text, source_class::text, COALESCE(source_platform, ''),
		       COALESCE(external_settlement_id, ''), COALESCE(connected_account_id::text, ''), exchange_rate_snapshot,
		       COALESCE(import_fingerprint, ''), gross_amount, net_amount, COALESCE(fees, '{}'::jsonb), COALESCE(deductions, '{}'::jsonb),
		       currency, settlement_state, reconciliation_state::text, COALESCE(related_order_ids::text[], '{}'::text[]),
		       COALESCE(effective_date::text, ''), created_at, updated_at ` + baseQuery + fmt.Sprintf(" ORDER BY effective_date DESC, created_at DESC LIMIT $%d OFFSET $%d", idx, idx+1)
	dataArgs := append(append([]any{}, args...), limit, offset)

	var total int64
	var result []Settlement
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, countQuery, args...).Scan(&total); err != nil {
			return err
		}
		rows, err := tx.Query(txCtx, dataQuery, dataArgs...)
		if err != nil {
			return err
		}
		defer rows.Close()

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
				return err
			}
			s.ReconciliationState = fromPgReconciliationState(s.ReconciliationState)
			s.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
			s.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
			_ = json.Unmarshal(fxBytes, &s.ExchangeRateSnapshot)
			_ = json.Unmarshal(feesBytes, &s.Fees)
			_ = json.Unmarshal(dedBytes, &s.Deductions)
			result = append(result, s)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, 0, err
	}
	return result, total, nil
}

func (p *PostgresStore) FindSettlementByExternalID(ctx context.Context, workspaceID, accountID, externalID string) (*Settlement, error) {
	query := `
		SELECT settlement_id::text, workspace_id::text, source_class::text, COALESCE(source_platform, ''),
		       COALESCE(external_settlement_id, ''), COALESCE(connected_account_id::text, ''), exchange_rate_snapshot,
		       COALESCE(import_fingerprint, ''), gross_amount, net_amount, COALESCE(fees, '{}'::jsonb), COALESCE(deductions, '{}'::jsonb),
		       currency, settlement_state, reconciliation_state::text, COALESCE(related_order_ids::text[], '{}'::text[]),
		       COALESCE(effective_date::text, ''), created_at, updated_at
		FROM settlements
		WHERE workspace_id = $1 AND COALESCE(connected_account_id::text, '') = $2 AND external_settlement_id = $3 AND deleted_at IS NULL
	`
	var s Settlement
	var grossNum, netNum pgtype.Numeric
	var fxBytes, feesBytes, dedBytes []byte

	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, query, workspaceID, accountID, externalID).Scan(
			&s.SettlementID, &s.WorkspaceID, &s.SourceClass, &s.SourcePlatform,
			&s.ExternalSettlementID, &s.ConnectedAccountID, &fxBytes,
			&s.ImportFingerprint, &grossNum, &netNum, &feesBytes, &dedBytes,
			&s.Currency, &s.SettlementState, &s.ReconciliationState, &s.RelatedOrderIDs,
			&s.EffectiveDate, &s.CreatedAt, &s.UpdatedAt,
		)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrSettlementNotFound
			}
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	s.ReconciliationState = fromPgReconciliationState(s.ReconciliationState)
	s.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
	s.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
	_ = json.Unmarshal(fxBytes, &s.ExchangeRateSnapshot)
	_ = json.Unmarshal(feesBytes, &s.Fees)
	_ = json.Unmarshal(dedBytes, &s.Deductions)
	return &s, nil
}

func (p *PostgresStore) FindSettlementByFingerprint(ctx context.Context, workspaceID, fingerprint string) (*Settlement, error) {
	query := `
		SELECT settlement_id::text, workspace_id::text, source_class::text, COALESCE(source_platform, ''),
		       COALESCE(external_settlement_id, ''), COALESCE(connected_account_id::text, ''), exchange_rate_snapshot,
		       COALESCE(import_fingerprint, ''), gross_amount, net_amount, COALESCE(fees, '{}'::jsonb), COALESCE(deductions, '{}'::jsonb),
		       currency, settlement_state, reconciliation_state::text, COALESCE(related_order_ids::text[], '{}'::text[]),
		       COALESCE(effective_date::text, ''), created_at, updated_at
		FROM settlements
		WHERE workspace_id = $1 AND import_fingerprint = $2 AND deleted_at IS NULL
	`
	var s Settlement
	var grossNum, netNum pgtype.Numeric
	var fxBytes, feesBytes, dedBytes []byte

	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, query, workspaceID, fingerprint).Scan(
			&s.SettlementID, &s.WorkspaceID, &s.SourceClass, &s.SourcePlatform,
			&s.ExternalSettlementID, &s.ConnectedAccountID, &fxBytes,
			&s.ImportFingerprint, &grossNum, &netNum, &feesBytes, &dedBytes,
			&s.Currency, &s.SettlementState, &s.ReconciliationState, &s.RelatedOrderIDs,
			&s.EffectiveDate, &s.CreatedAt, &s.UpdatedAt,
		)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrSettlementNotFound
			}
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	s.ReconciliationState = fromPgReconciliationState(s.ReconciliationState)
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
	return p.withTenantTx(ctx, line.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			line.LineID, line.WorkspaceID, line.SettlementID, line.ExternalLineID,
			nullableString(line.ExternalOrderID), nullableUUIDString(line.OrderID), line.GrossAmount.ToPgNumeric(), line.FeeAmount.ToPgNumeric(),
			line.RefundAmount.ToPgNumeric(), line.NetAmount.ToPgNumeric(), line.MatchedAmount.ToPgNumeric(), line.Currency,
			toPgReconciliationState(line.ReconciliationState), line.CreatedAt,
		)
		return err
	})
}

func (p *PostgresStore) ListSettlementLines(ctx context.Context, workspaceID, settlementID string) ([]SettlementLine, error) {
	query := `
		SELECT line_id::text, workspace_id::text, settlement_id::text, external_line_id,
		       external_order_id, order_id::text, gross_amount, fee_amount,
		       refund_amount, net_amount, matched_amount, currency,
		       reconciliation_state::text, created_at
		FROM settlement_lines
		WHERE workspace_id = $1 AND settlement_id = $2
		ORDER BY created_at ASC
	`
	var result []SettlementLine
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, query, workspaceID, settlementID)
		if err != nil {
			return err
		}
		defer rows.Close()

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
				return err
			}
			l.ReconciliationState = fromPgReconciliationState(l.ReconciliationState)
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
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	return result, nil
}

func (p *PostgresStore) GetSettlementLine(ctx context.Context, workspaceID, settlementID, lineID string) (*SettlementLine, error) {
	query := `
		SELECT line_id::text, workspace_id::text, settlement_id::text, external_line_id,
		       external_order_id, order_id::text, gross_amount, fee_amount,
		       refund_amount, net_amount, matched_amount, currency,
		       reconciliation_state::text, created_at
		FROM settlement_lines
		WHERE workspace_id = $1 AND settlement_id = $2 AND line_id = $3
	`
	var l SettlementLine
	var grossNum, feeNum, refNum, netNum, matchNum pgtype.Numeric
	var extOrder, orderID *string

	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		return tx.QueryRow(txCtx, query, workspaceID, settlementID, lineID).Scan(
			&l.LineID, &l.WorkspaceID, &l.SettlementID, &l.ExternalLineID,
			&extOrder, &orderID, &grossNum, &feeNum,
			&refNum, &netNum, &matchNum, &l.Currency,
			&l.ReconciliationState, &l.CreatedAt,
		)
	})
	if err != nil {
		return nil, err
	}
	l.ReconciliationState = fromPgReconciliationState(l.ReconciliationState)
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
	return p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query, matchedAmount.ToPgNumeric(), toPgReconciliationState(newState), workspaceID, lineID)
		return err
	})
}

func scopeUUIDString(scopeType, scopeID string) *string {
	trimmed := strings.TrimSpace(scopeID)
	if trimmed == "" {
		return nil
	}
	if isUUIDFormat(trimmed) {
		return &trimmed
	}
	sum := sha256.Sum256([]byte(strings.ToLower(strings.TrimSpace(scopeType)) + ":" + trimmed))
	b := sum[:16]
	b[6] = (b[6] & 0x0f) | 0x50
	b[8] = (b[8] & 0x3f) | 0x80
	derived := fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
	return &derived
}

func marshalSnapshotSourceClassMix(mix map[string]tenantdb.ExactDecimal, scopeID string) ([]byte, error) {
	payload := make(map[string]any, len(mix)+1)
	for k, v := range mix {
		payload[k] = v
	}
	if trimmed := strings.TrimSpace(scopeID); trimmed != "" && !isUUIDFormat(trimmed) {
		payload["_raw_scope_id"] = trimmed
	}
	return json.Marshal(payload)
}

func unmarshalSnapshotSourceClassMix(mixBytes []byte, s *ProfitSnapshot) {
	if len(mixBytes) == 0 || s == nil {
		return
	}
	var rawMap map[string]json.RawMessage
	if err := json.Unmarshal(mixBytes, &rawMap); err != nil {
		return
	}
	if rawScope, ok := rawMap["_raw_scope_id"]; ok {
		var scopeStr string
		if json.Unmarshal(rawScope, &scopeStr) == nil && strings.TrimSpace(scopeStr) != "" {
			s.ScopeID = strings.TrimSpace(scopeStr)
		}
		delete(rawMap, "_raw_scope_id")
	}
	if len(rawMap) > 0 {
		s.SourceClassMix = make(map[string]tenantdb.ExactDecimal, len(rawMap))
		for k, rawVal := range rawMap {
			var dec tenantdb.ExactDecimal
			if json.Unmarshal(rawVal, &dec) == nil {
				s.SourceClassMix[k] = dec
			}
		}
	}
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
	periodStart := strings.TrimSpace(s.PeriodStart)
	if periodStart == "" {
		periodStart = "1970-01-01"
	}
	periodEnd := strings.TrimSpace(s.PeriodEnd)
	if periodEnd == "" {
		periodEnd = "2099-12-31"
	}

	mixJSON, _ := marshalSnapshotSourceClassMix(s.SourceClassMix, s.ScopeID)
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
			$1, $2, $3, $4, $5::date, $6::date,
			$7, $8, $9, $10, $11,
			$12, $13, $14, $15, $16,
			$17, $18, $19, $20, $21,
			$22, $23
		)
	`
	return p.withTenantTx(ctx, s.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			s.SnapshotID, s.WorkspaceID, s.ScopeType, scopeUUIDString(s.ScopeType, s.ScopeID), periodStart, periodEnd,
			s.GrossRevenue.ToPgNumeric(), s.PlatformFees.ToPgNumeric(), s.ShippingCosts.ToPgNumeric(),
			s.AffiliateCommissions.ToPgNumeric(), s.RefundDeductions.ToPgNumeric(),
			s.COGS.ToPgNumeric(), s.AdsSpend.ToPgNumeric(), s.AICreditCosts.ToPgNumeric(),
			s.SeedingCosts.ToPgNumeric(), s.OtherCosts.ToPgNumeric(),
			s.NetProfit.ToPgNumeric(), marginNum, mixJSON, s.Confidence, s.FreshnessAt,
			s.Currency, s.CreatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetSnapshot(ctx context.Context, workspaceID, snapshotID string) (*ProfitSnapshot, error) {
	query := `
		SELECT snapshot_id::text, workspace_id::text, scope_type, scope_id::text, period_start::text, period_end::text,
		       gross_revenue, platform_fees, shipping_costs, affiliate_commissions, refund_deductions,
		       cogs, ads_spend, ai_credit_costs, seeding_costs, other_costs,
		       net_profit, margin_pct, source_class_mix, confidence::text, freshness_at,
		       currency, created_at
		FROM profit_snapshots
		WHERE workspace_id = $1 AND snapshot_id = $2
	`
	var snap *ProfitSnapshot
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		snap, scanErr = scanSnapshot(tx.QueryRow(txCtx, query, workspaceID, snapshotID))
		return scanErr
	})
	return snap, err
}

func (p *PostgresStore) GetLatestSnapshot(ctx context.Context, workspaceID, scopeType, scopeID, periodStart, periodEnd string) (*ProfitSnapshot, error) {
	query := `
		SELECT snapshot_id::text, workspace_id::text, scope_type, scope_id::text, period_start::text, period_end::text,
		       gross_revenue, platform_fees, shipping_costs, affiliate_commissions, refund_deductions,
		       cogs, ads_spend, ai_credit_costs, seeding_costs, other_costs,
		       net_profit, margin_pct, source_class_mix, confidence::text, freshness_at,
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
		resolvedScopeID := scopeID
		if u := scopeUUIDString(scopeType, scopeID); u != nil {
			resolvedScopeID = *u
		}
		query += fmt.Sprintf(" AND scope_id::text = $%d", idx)
		args = append(args, resolvedScopeID)
		idx++
	}
	if periodStart != "" {
		query += fmt.Sprintf(" AND period_start = $%d::date", idx)
		args = append(args, periodStart)
		idx++
	}
	if periodEnd != "" {
		query += fmt.Sprintf(" AND period_end = $%d::date", idx)
		args = append(args, periodEnd)
		idx++
	}
	query += " ORDER BY freshness_at DESC LIMIT 1"

	var snap *ProfitSnapshot
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		snap, scanErr = scanSnapshot(tx.QueryRow(txCtx, query, args...))
		return scanErr
	})
	return snap, err
}

func (p *PostgresStore) ListSnapshots(ctx context.Context, workspaceID, scopeType string, limit int) ([]ProfitSnapshot, error) {
	query := `
		SELECT snapshot_id::text, workspace_id::text, scope_type, scope_id::text, period_start::text, period_end::text,
		       gross_revenue, platform_fees, shipping_costs, affiliate_commissions, refund_deductions,
		       cogs, ads_spend, ai_credit_costs, seeding_costs, other_costs,
		       net_profit, margin_pct, source_class_mix, confidence::text, freshness_at,
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

	var result []ProfitSnapshot
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, query, args...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			s, err := scanSnapshotRow(rows)
			if err != nil {
				return err
			}
			result = append(result, *s)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
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
	unmarshalSnapshotSourceClassMix(mixBytes, &s)
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
	unmarshalSnapshotSourceClassMix(mixBytes, &s)
	return &s, nil
}

func toPgReconciliationState(state string) string {
	switch strings.ToLower(strings.TrimSpace(state)) {
	case "", ReconciliationImportedOnly:
		return "imported_only"
	case ReconciliationAwaitingEvidence:
		return "awaiting_evidence"
	case ReconciliationInferredPendingConfirmation:
		return "estimated"
	case ReconciliationPartiallyReconciled, "partially_matched":
		return "partially_matched"
	case ReconciliationFullyReconciled, "reconciled":
		return "reconciled"
	case ReconciliationConflictDetected, "disputed":
		return "disputed"
	case ReconciliationManuallyOverridden, "adjusted":
		return "adjusted"
	default:
		return "imported_only"
	}
}

func fromPgReconciliationState(state string) string {
	switch strings.ToLower(strings.TrimSpace(state)) {
	case "partially_matched", ReconciliationPartiallyReconciled:
		return ReconciliationPartiallyReconciled
	case "reconciled", ReconciliationFullyReconciled:
		return ReconciliationFullyReconciled
	case "disputed", ReconciliationConflictDetected:
		return ReconciliationConflictDetected
	case "adjusted", ReconciliationManuallyOverridden:
		return ReconciliationManuallyOverridden
	case "estimated":
		return ReconciliationInferredPendingConfirmation
	case "awaiting_evidence":
		return ReconciliationAwaitingEvidence
	default:
		return ReconciliationImportedOnly
	}
}

func appendUniqueString(list []string, val string) []string {
	val = strings.TrimSpace(val)
	if val == "" {
		return list
	}
	for _, existing := range list {
		if strings.EqualFold(existing, val) {
			return list
		}
	}
	return append(list, val)
}

func orderMatchesProduct(o Order, productID string) bool {
	pid := strings.TrimSpace(productID)
	if pid == "" {
		return false
	}
	if strings.EqualFold(strings.TrimSpace(o.ProductID), pid) {
		return true
	}
	for _, id := range o.ProductIDs {
		if strings.EqualFold(strings.TrimSpace(id), pid) {
			return true
		}
	}
	return false
}

func parseMapDecimal(m map[string]any, keys ...string) (tenantdb.ExactDecimal, bool) {
	for _, k := range keys {
		raw, ok := m[k]
		if !ok || raw == nil {
			continue
		}
		switch v := raw.(type) {
		case string:
			if d, err := tenantdb.ParseExactDecimal(strings.TrimSpace(v)); err == nil {
				return d, true
			}
		case float64:
			if d, err := tenantdb.ParseExactDecimal(fmt.Sprintf("%.6f", v)); err == nil {
				return d, true
			}
		}
	}
	return tenantdb.ZeroDecimal(), false
}

func hydrateOrderDetails(o *Order, itemsBytes, feeBytes, metaBytes []byte) {
	if o == nil {
		return
	}
	if o.ProductID != "" {
		o.ProductIDs = appendUniqueString(o.ProductIDs, o.ProductID)
	}
	if o.CampaignID != "" {
		o.CampaignIDs = appendUniqueString(o.CampaignIDs, o.CampaignID)
	}
	if o.PostID != "" {
		o.PostIDs = appendUniqueString(o.PostIDs, o.PostID)
	}
	if o.ContentID != "" {
		o.ContentIDs = appendUniqueString(o.ContentIDs, o.ContentID)
	}
	if len(metaBytes) > 0 {
		var meta map[string]any
		if json.Unmarshal(metaBytes, &meta) == nil {
			if o.SourcePlatform == "" {
				if v, ok := meta["source_platform"].(string); ok {
					o.SourcePlatform = strings.TrimSpace(v)
				}
			}
			if v, ok := meta["product_id"].(string); ok && strings.TrimSpace(v) != "" {
				if o.ProductID == "" {
					o.ProductID = strings.TrimSpace(v)
				}
				o.ProductIDs = appendUniqueString(o.ProductIDs, v)
			}
			if rawIDs, ok := meta["product_ids"].([]any); ok {
				for _, elem := range rawIDs {
					if s, ok := elem.(string); ok {
						o.ProductIDs = appendUniqueString(o.ProductIDs, s)
					}
				}
			}
			if v, ok := meta["campaign_id"].(string); ok && strings.TrimSpace(v) != "" {
				if o.CampaignID == "" {
					o.CampaignID = strings.TrimSpace(v)
				}
				o.CampaignIDs = appendUniqueString(o.CampaignIDs, v)
			}
			if rawIDs, ok := meta["campaign_ids"].([]any); ok {
				for _, elem := range rawIDs {
					if s, ok := elem.(string); ok {
						if o.CampaignID == "" {
							o.CampaignID = strings.TrimSpace(s)
						}
						o.CampaignIDs = appendUniqueString(o.CampaignIDs, s)
					}
				}
			}
			if v, ok := meta["post_id"].(string); ok && strings.TrimSpace(v) != "" {
				if o.PostID == "" {
					o.PostID = strings.TrimSpace(v)
				}
				o.PostIDs = appendUniqueString(o.PostIDs, v)
			}
			if rawIDs, ok := meta["post_ids"].([]any); ok {
				for _, elem := range rawIDs {
					if s, ok := elem.(string); ok {
						if o.PostID == "" {
							o.PostID = strings.TrimSpace(s)
						}
						o.PostIDs = appendUniqueString(o.PostIDs, s)
					}
				}
			}
			for _, key := range []string{"content_id", "publish_item_id"} {
				if v, ok := meta[key].(string); ok && strings.TrimSpace(v) != "" {
					if o.ContentID == "" {
						o.ContentID = strings.TrimSpace(v)
					}
					o.ContentIDs = appendUniqueString(o.ContentIDs, v)
				}
			}
			if rawIDs, ok := meta["content_ids"].([]any); ok {
				for _, elem := range rawIDs {
					if s, ok := elem.(string); ok {
						if o.ContentID == "" {
							o.ContentID = strings.TrimSpace(s)
						}
						o.ContentIDs = appendUniqueString(o.ContentIDs, s)
					}
				}
			}
			if o.RecognizedAt == nil {
				if recStr, ok := meta["recognized_at"].(string); ok && strings.TrimSpace(recStr) != "" {
					if parsed, err := time.Parse(time.RFC3339, strings.TrimSpace(recStr)); err == nil {
						u := parsed.UTC()
						o.RecognizedAt = &u
					}
				}
			}
			if b, ok := meta["zero_cogs_with_reason"].(bool); ok && b {
				o.ZeroCOGSWithReason = true
			}
			if r, ok := meta["cogs_reason"].(string); ok && strings.TrimSpace(r) != "" && o.COGSReason == "" {
				o.COGSReason = strings.TrimSpace(r)
			}
			if o.ExchangeRateSnapshot.IsEmpty() {
				if rawFX, ok := meta["exchange_rate_snapshot"]; ok && rawFX != nil {
					if fxB, err := json.Marshal(rawFX); err == nil {
						var fx ExchangeRateSnapshot
						if json.Unmarshal(fxB, &fx) == nil && !fx.IsEmpty() {
							o.ExchangeRateSnapshot = fx
						}
					}
				}
			}
		}
	}
	if len(feeBytes) > 0 {
		var fees map[string]any
		if json.Unmarshal(feeBytes, &fees) == nil {
			if d, ok := parseMapDecimal(fees, "cogs"); ok && !d.IsZero() {
				o.COGSAmount = &d
			}
			if b, ok := fees["zero_cogs_with_reason"].(bool); ok && b {
				o.ZeroCOGSWithReason = true
			}
			if r, ok := fees["cogs_reason"].(string); ok && strings.TrimSpace(r) != "" && o.COGSReason == "" {
				o.COGSReason = strings.TrimSpace(r)
			}
			if d, ok := parseMapDecimal(fees, "platform_fee"); ok && !d.IsZero() && o.PlatformFeeAmount.IsZero() {
				o.PlatformFeeAmount = d
			}
			if d, ok := parseMapDecimal(fees, "payment_fee", "transaction_fee"); ok && !d.IsZero() && o.PaymentFeeAmount.IsZero() {
				o.PaymentFeeAmount = d
			}
			if d, ok := parseMapDecimal(fees, "shipping_cost", "shipping_fee"); ok && !d.IsZero() && o.ShippingFeeAmount.IsZero() {
				o.ShippingFeeAmount = d
			}
			if d, ok := parseMapDecimal(fees, "affiliate_commission", "commission"); ok && !d.IsZero() && o.CommissionAmount.IsZero() {
				o.CommissionAmount = d
			}
		}
	}
	if len(itemsBytes) > 0 {
		var rawItems []map[string]any
		if json.Unmarshal(itemsBytes, &rawItems) == nil {
			itemCOGSSum := tenantdb.ZeroDecimal()
			hasItemCOGS := false
			for _, item := range rawItems {
				for _, key := range []string{"product_id", "sku_id", "sku", "offer_id"} {
					if s, ok := item[key].(string); ok && strings.TrimSpace(s) != "" {
						if o.ProductID == "" && key == "product_id" {
							o.ProductID = strings.TrimSpace(s)
						}
						o.ProductIDs = appendUniqueString(o.ProductIDs, s)
					}
				}
				if b, ok := item["zero_cogs_with_reason"].(bool); ok && b {
					o.ZeroCOGSWithReason = true
				}
				if r, ok := item["cogs_reason"].(string); ok && strings.TrimSpace(r) != "" && o.COGSReason == "" {
					o.COGSReason = strings.TrimSpace(r)
				}
				unitCOGS, parsedCOGS := parseMapDecimal(item, "unit_cogs")
				if parsedCOGS && !unitCOGS.IsZero() {
					qty := int64(1)
					if rawQty, ok := item["quantity"].(float64); ok && int64(rawQty) > 0 {
						qty = int64(rawQty)
					}
					qtyDec := tenantdb.MustParseExactDecimal(fmt.Sprintf("%d.000000", qty))
					lineCOGS, err := ComputeBaseAmount(unitCOGS, ExchangeRateSnapshot{
						BaseCurrency:  "VND",
						QuoteCurrency: "USD",
						RateToBase:    qtyDec.Fixed6String(),
					})
					if err == nil && !lineCOGS.IsZero() {
						itemCOGSSum, _ = itemCOGSSum.Add(lineCOGS)
						hasItemCOGS = true
					}
				}
			}
			if o.COGSAmount == nil && hasItemCOGS && !itemCOGSSum.IsZero() {
				o.COGSAmount = &itemCOGSSum
			}
		}
	}
}

func enrichOrdersFromRelationsTx(txCtx context.Context, tx pgx.Tx, workspaceID string, orders []Order) {
	if len(orders) == 0 {
		return
	}
	orderIdx := make(map[string]int, len(orders))
	for i := range orders {
		orderIdx[orders[i].OrderID] = i
	}

	// 1. Enrich with all content_attribution_records links in the workspace
	attrRows, attrErr := tx.Query(txCtx, `
		SELECT order_id::text,
		       COALESCE(publish_item_id::text, ''),
		       COALESCE(channel_post_id::text, ''),
		       COALESCE(utm_campaign, ''),
		       COALESCE(metadata->>'utm_content', '')
		FROM content_attribution_records
		WHERE workspace_id = $1 AND order_id IS NOT NULL
	`, workspaceID)
	if attrErr == nil {
		for attrRows.Next() {
			var ordID, pubID, postID, utmCamp, utmContent string
			if attrRows.Scan(&ordID, &pubID, &postID, &utmCamp, &utmContent) == nil {
				if idx, ok := orderIdx[ordID]; ok {
					if pubID != "" {
						if orders[idx].ContentID == "" {
							orders[idx].ContentID = pubID
						}
						orders[idx].ContentIDs = appendUniqueString(orders[idx].ContentIDs, pubID)
					}
					if utmContent != "" {
						if orders[idx].ContentID == "" {
							orders[idx].ContentID = utmContent
						}
						orders[idx].ContentIDs = appendUniqueString(orders[idx].ContentIDs, utmContent)
					}
					if postID != "" {
						if orders[idx].PostID == "" {
							orders[idx].PostID = postID
						}
						orders[idx].PostIDs = appendUniqueString(orders[idx].PostIDs, postID)
					}
					if utmCamp != "" {
						if orders[idx].CampaignID == "" {
							orders[idx].CampaignID = utmCamp
						}
						orders[idx].CampaignIDs = appendUniqueString(orders[idx].CampaignIDs, utmCamp)
					}
				}
			}
		}
		attrRows.Close()
	}

	// 2. Enrich SKU / offer references to product_id from product_skus and offers
	skuToProduct := make(map[string]string)
	skuRows, skuErr := tx.Query(txCtx, `
		SELECT sku_id::text, COALESCE(sku_code, ''), product_id::text
		FROM product_skus
		WHERE workspace_id = $1 AND deleted_at IS NULL
	`, workspaceID)
	if skuErr == nil {
		for skuRows.Next() {
			var skuID, skuCode, prodID string
			if skuRows.Scan(&skuID, &skuCode, &prodID) == nil && prodID != "" {
				if skuID != "" {
					skuToProduct[strings.ToLower(strings.TrimSpace(skuID))] = prodID
				}
				if skuCode != "" {
					skuToProduct[strings.ToLower(strings.TrimSpace(skuCode))] = prodID
				}
			}
		}
		skuRows.Close()
	}

	offerRows, offerErr := tx.Query(txCtx, `
		SELECT offer_id::text, COALESCE(product_id::text, '')
		FROM offers
		WHERE workspace_id = $1 AND deleted_at IS NULL
	`, workspaceID)
	if offerErr == nil {
		for offerRows.Next() {
			var offerID, prodID string
			if offerRows.Scan(&offerID, &prodID) == nil && offerID != "" && prodID != "" {
				skuToProduct[strings.ToLower(strings.TrimSpace(offerID))] = prodID
			}
		}
		offerRows.Close()
	}

	if len(skuToProduct) > 0 {
		for i := range orders {
			existingIDs := append([]string(nil), orders[i].ProductIDs...)
			for _, candidate := range existingIDs {
				if resolvedProdID, ok := skuToProduct[strings.ToLower(strings.TrimSpace(candidate))]; ok && resolvedProdID != "" {
					if orders[i].ProductID == "" {
						orders[i].ProductID = resolvedProdID
					}
					orders[i].ProductIDs = appendUniqueString(orders[i].ProductIDs, resolvedProdID)
				}
			}
		}
	}
}

func (p *PostgresStore) CreateOrder(ctx context.Context, o *Order) error {
	if o.OrderID == "" {
		o.OrderID = newUUID()
	}
	if o.OrderedAt.IsZero() {
		if o.RecognizedAt != nil && !o.RecognizedAt.IsZero() {
			o.OrderedAt = o.RecognizedAt.UTC()
		} else {
			o.OrderedAt = time.Now().UTC()
		}
	}
	feeMap := map[string]any{}
	if o.COGSAmount != nil {
		feeMap["cogs"] = o.COGSAmount.Fixed6String()
	}
	if o.ZeroCOGSWithReason {
		feeMap["zero_cogs_with_reason"] = true
	}
	if o.COGSReason != "" {
		feeMap["cogs_reason"] = o.COGSReason
	}
	if !o.PlatformFeeAmount.IsZero() {
		feeMap["platform_fee"] = o.PlatformFeeAmount.Fixed6String()
	}
	if !o.PaymentFeeAmount.IsZero() {
		feeMap["payment_fee"] = o.PaymentFeeAmount.Fixed6String()
	}
	if !o.ShippingFeeAmount.IsZero() {
		feeMap["shipping_cost"] = o.ShippingFeeAmount.Fixed6String()
	}
	if !o.CommissionAmount.IsZero() {
		feeMap["affiliate_commission"] = o.CommissionAmount.Fixed6String()
	}
	feeJSON, _ := json.Marshal(feeMap)

	metaMap := map[string]any{}
	if o.SourcePlatform != "" {
		metaMap["source_platform"] = o.SourcePlatform
	}
	if o.ProductID != "" {
		metaMap["product_id"] = o.ProductID
	}
	if len(o.ProductIDs) > 0 {
		metaMap["product_ids"] = o.ProductIDs
	}
	if o.CampaignID != "" {
		metaMap["campaign_id"] = o.CampaignID
	}
	if len(o.CampaignIDs) > 0 {
		metaMap["campaign_ids"] = o.CampaignIDs
	}
	if o.PostID != "" {
		metaMap["post_id"] = o.PostID
	}
	if len(o.PostIDs) > 0 {
		metaMap["post_ids"] = o.PostIDs
	}
	if o.ContentID != "" {
		metaMap["content_id"] = o.ContentID
	}
	if len(o.ContentIDs) > 0 {
		metaMap["content_ids"] = o.ContentIDs
	}
	if o.RecognizedAt != nil && !o.RecognizedAt.IsZero() {
		metaMap["recognized_at"] = o.RecognizedAt.UTC().Format(time.RFC3339)
	}
	if o.ZeroCOGSWithReason {
		metaMap["zero_cogs_with_reason"] = true
	}
	if o.COGSReason != "" {
		metaMap["cogs_reason"] = o.COGSReason
	}
	if !o.ExchangeRateSnapshot.IsEmpty() {
		metaMap["exchange_rate_snapshot"] = o.ExchangeRateSnapshot
	}
	metaJSON, _ := json.Marshal(metaMap)

	pgRecState := toPgReconciliationState(o.ReconciliationState)
	query := `
		INSERT INTO orders (
			order_id, workspace_id, amount, matched_amount, currency,
			lifecycle_state, reconciliation_state, source_platform,
			fee_breakdown, metadata, ordered_at, recognized_at, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4, $5,
			$6, $7, NULLIF($8, ''),
			$9::jsonb, $10::jsonb, $11, $12, NOW(), NOW()
		)
		ON CONFLICT (workspace_id, order_id) DO UPDATE SET
			amount = EXCLUDED.amount,
			currency = EXCLUDED.currency,
			lifecycle_state = EXCLUDED.lifecycle_state,
			ordered_at = LEAST(orders.ordered_at, EXCLUDED.ordered_at),
			recognized_at = COALESCE(EXCLUDED.recognized_at, orders.recognized_at),
			source_platform = COALESCE(NULLIF(EXCLUDED.source_platform, ''), orders.source_platform),
			fee_breakdown = COALESCE(orders.fee_breakdown, '{}'::jsonb) || EXCLUDED.fee_breakdown,
			metadata = COALESCE(orders.metadata, '{}'::jsonb) || EXCLUDED.metadata,
			updated_at = NOW()
	`
	return p.withTenantTx(ctx, o.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			o.OrderID, o.WorkspaceID, o.Amount.ToPgNumeric(), o.MatchedAmount.ToPgNumeric(),
			o.Currency, o.LifecycleState, pgRecState, o.SourcePlatform,
			feeJSON, metaJSON, o.OrderedAt, o.RecognizedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetOrder(ctx context.Context, workspaceID, orderID string) (*Order, error) {
	query := `
		SELECT order_id::text, workspace_id::text, amount, matched_amount, currency,
		       lifecycle_state, COALESCE(reconciliation_state::text, 'imported_only'),
		       ordered_at, recognized_at, source_updated_at,
		       COALESCE(source_platform, ''),
		       COALESCE(product_id::text, ''),
		       COALESCE(offer_id::text, ''),
		       COALESCE(campaign_id::text, ''),
		       COALESCE(post_id::text, ''),
		       COALESCE(items, '[]'::jsonb),
		       COALESCE(fee_breakdown, '{}'::jsonb),
		       COALESCE(metadata, '{}'::jsonb)
		FROM orders
		WHERE workspace_id = $1 AND order_id = $2 AND deleted_at IS NULL
	`
	var o Order
	var amtNum, matchNum pgtype.Numeric
	var rawRecState, offerID string
	var itemsBytes, feeBytes, metaBytes []byte
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, query, workspaceID, orderID).Scan(
			&o.OrderID, &o.WorkspaceID, &amtNum, &matchNum, &o.Currency,
			&o.LifecycleState, &rawRecState,
			&o.OrderedAt, &o.RecognizedAt, &o.SourceUpdatedAt,
			&o.SourcePlatform, &o.ProductID, &offerID, &o.CampaignID, &o.PostID,
			&itemsBytes, &feeBytes, &metaBytes,
		)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrOrderNotFound
			}
			return err
		}
		o.Amount, _ = tenantdb.FromPgNumeric(amtNum)
		o.MatchedAmount, _ = tenantdb.FromPgNumeric(matchNum)
		o.ReconciliationState = fromPgReconciliationState(rawRecState)
		if offerID != "" {
			o.ProductIDs = appendUniqueString(o.ProductIDs, offerID)
		}
		hydrateOrderDetails(&o, itemsBytes, feeBytes, metaBytes)
		slice := []Order{o}
		enrichOrdersFromRelationsTx(txCtx, tx, workspaceID, slice)
		o = slice[0]
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &o, nil
}

func (p *PostgresStore) ListOrders(ctx context.Context, workspaceID string) ([]Order, error) {
	query := `
		SELECT order_id::text, workspace_id::text, amount, matched_amount, currency,
		       lifecycle_state, COALESCE(reconciliation_state::text, 'imported_only'),
		       ordered_at, recognized_at, source_updated_at,
		       COALESCE(source_platform, ''),
		       COALESCE(product_id::text, ''),
		       COALESCE(offer_id::text, ''),
		       COALESCE(campaign_id::text, ''),
		       COALESCE(post_id::text, ''),
		       COALESCE(items, '[]'::jsonb),
		       COALESCE(fee_breakdown, '{}'::jsonb),
		       COALESCE(metadata, '{}'::jsonb)
		FROM orders
		WHERE workspace_id = $1 AND deleted_at IS NULL
		ORDER BY ordered_at ASC
	`
	var result []Order
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, query, workspaceID)
		if err != nil {
			return err
		}
		defer rows.Close()
		for rows.Next() {
			var o Order
			var amtNum, matchNum pgtype.Numeric
			var rawRecState, offerID string
			var itemsBytes, feeBytes, metaBytes []byte
			if err := rows.Scan(
				&o.OrderID, &o.WorkspaceID, &amtNum, &matchNum, &o.Currency,
				&o.LifecycleState, &rawRecState,
				&o.OrderedAt, &o.RecognizedAt, &o.SourceUpdatedAt,
				&o.SourcePlatform, &o.ProductID, &offerID, &o.CampaignID, &o.PostID,
				&itemsBytes, &feeBytes, &metaBytes,
			); err != nil {
				return err
			}
			o.Amount, _ = tenantdb.FromPgNumeric(amtNum)
			o.MatchedAmount, _ = tenantdb.FromPgNumeric(matchNum)
			o.ReconciliationState = fromPgReconciliationState(rawRecState)
			if offerID != "" {
				o.ProductIDs = appendUniqueString(o.ProductIDs, offerID)
			}
			hydrateOrderDetails(&o, itemsBytes, feeBytes, metaBytes)
			result = append(result, o)
		}
		if err := rows.Err(); err != nil {
			return err
		}
		enrichOrdersFromRelationsTx(txCtx, tx, workspaceID, result)
		return nil
	})
	if err != nil {
		return nil, err
	}
	return result, nil
}

func (p *PostgresStore) ResolveRefundOrderID(ctx context.Context, workspaceID, refundID string) (string, error) {
	var orderID string
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		err := tx.QueryRow(txCtx, `
			SELECT order_id::text
			FROM refunds
			WHERE workspace_id = $1
			  AND (refund_id::text = $2 OR COALESCE(external_refund_id, '') = $2)
			LIMIT 1
		`, workspaceID, refundID).Scan(&orderID)
		if errors.Is(err, pgx.ErrNoRows) {
			_ = tx.QueryRow(txCtx, `
				SELECT COALESCE(exchange_rate_snapshot->>'related_order_id', '')
				FROM financial_postings
				WHERE workspace_id = $1 AND origin_type = 'refund' AND origin_id::text = $2
				LIMIT 1
			`, workspaceID, refundID).Scan(&orderID)
			return nil
		}
		return err
	})
	return orderID, err
}

func (p *PostgresStore) UpdateOrderMatched(ctx context.Context, workspaceID, orderID string, matchedAmount tenantdb.ExactDecimal, newState string) error {
	query := `
		UPDATE orders
		SET matched_amount = $1, reconciliation_state = $2, updated_at = NOW()
		WHERE workspace_id = $3 AND order_id = $4
	`
	pgState := toPgReconciliationState(newState)
	return p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query, matchedAmount.ToPgNumeric(), pgState, workspaceID, orderID)
		return err
	})
}

func (p *PostgresStore) CreateReconciliationRecord(ctx context.Context, r *ReconciliationRecord) error {
	if r.RecordID == "" {
		r.RecordID = newUUID()
	}
	now := time.Now().UTC()
	if r.CreatedAt.IsZero() {
		r.CreatedAt = now
	}
	if r.UpdatedAt.IsZero() {
		r.UpdatedAt = now
	}
	query := `
		INSERT INTO reconciliation_records (
			record_id, workspace_id, scope_type, scope_description,
			related_order_ids, related_settlement_ids, matched_amount,
			discrepancy_amount, discrepancy_reason, reconciliation_state,
			currency, mismatches, override_reason, override_by, override_at,
			period_start, period_end, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7,
			$8, $9, $10,
			$11, $12, $13, $14, $15,
			$16, $17, $18, $19
		)
	`
	mismatchesJSON := r.MismatchesJSON
	if mismatchesJSON == "" {
		mismatchesJSON = "[]"
	}
	var pStart, pEnd *string
	if r.PeriodStart != "" {
		pStart = &r.PeriodStart
	}
	if r.PeriodEnd != "" {
		pEnd = &r.PeriodEnd
	}
	var overrideBy *string
	if r.OverrideBy != "" {
		overrideBy = &r.OverrideBy
	}

	return p.withTenantTx(ctx, r.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			r.RecordID, r.WorkspaceID, r.ScopeType, r.ScopeDescription,
			r.RelatedOrderIDs, r.RelatedSettlementIDs, r.MatchedAmount.ToPgNumeric(),
			r.DiscrepancyAmount.ToPgNumeric(), r.DiscrepancyReason, toPgReconciliationState(r.ReconciliationState),
			r.Currency, []byte(mismatchesJSON), r.OverrideReason, overrideBy, r.OverrideAt,
			pStart, pEnd, r.CreatedAt, r.UpdatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetReconciliationRecord(ctx context.Context, workspaceID, recordID string) (*ReconciliationRecord, error) {
	query := `
		SELECT record_id, workspace_id, scope_type, scope_description,
		       related_order_ids, related_settlement_ids, matched_amount,
		       discrepancy_amount, discrepancy_reason, reconciliation_state::text,
		       currency, mismatches, override_reason, override_by, override_at,
		       period_start, period_end, created_at, updated_at
		FROM reconciliation_records
		WHERE workspace_id = $1 AND record_id = $2
	`
	var rec *ReconciliationRecord
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		rec, scanErr = scanReconciliationRecord(tx.QueryRow(txCtx, query, workspaceID, recordID))
		return scanErr
	})
	return rec, err
}

func (p *PostgresStore) ListReconciliationRecords(ctx context.Context, workspaceID string, filter ReconciliationFilter, limit, offset int) ([]ReconciliationRecord, int64, error) {
	where := "WHERE workspace_id = $1"
	args := []any{workspaceID}
	idx := 2

	if filter.ReconciliationState != "" {
		where += fmt.Sprintf(" AND reconciliation_state = $%d", idx)
		args = append(args, toPgReconciliationState(filter.ReconciliationState))
		idx++
	}
	if filter.PeriodStart != "" {
		where += fmt.Sprintf(" AND period_start >= $%d", idx)
		args = append(args, filter.PeriodStart)
		idx++
	}
	if filter.PeriodEnd != "" {
		where += fmt.Sprintf(" AND period_end <= $%d", idx)
		args = append(args, filter.PeriodEnd)
		idx++
	}

	countQuery := "SELECT COUNT(*) FROM reconciliation_records " + where
	query := fmt.Sprintf(`
		SELECT record_id, workspace_id, scope_type, scope_description,
		       related_order_ids, related_settlement_ids, matched_amount,
		       discrepancy_amount, discrepancy_reason, reconciliation_state::text,
		       currency, mismatches, override_reason, override_by, override_at,
		       period_start, period_end, created_at, updated_at
		FROM reconciliation_records
		%s
		ORDER BY created_at DESC
	`, where)

	if limit > 0 {
		query += fmt.Sprintf(" LIMIT %d", limit)
	}
	if offset > 0 {
		query += fmt.Sprintf(" OFFSET %d", offset)
	}

	var total int64
	var records []ReconciliationRecord
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, countQuery, args...).Scan(&total); err != nil {
			return err
		}
		rows, err := tx.Query(txCtx, query, args...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			r, err := scanReconciliationRecordRow(rows)
			if err != nil {
				return err
			}
			records = append(records, *r)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, 0, err
	}
	return records, total, nil
}

func (p *PostgresStore) UpdateReconciliationRecord(ctx context.Context, r *ReconciliationRecord) error {
	mismatchesJSON := r.MismatchesJSON
	if mismatchesJSON == "" {
		mismatchesJSON = "[]"
	}
	var overrideBy *string
	if r.OverrideBy != "" {
		overrideBy = &r.OverrideBy
	}

	query := `
		UPDATE reconciliation_records
		SET scope_type = $1, scope_description = $2, related_order_ids = $3,
		    related_settlement_ids = $4, matched_amount = $5, discrepancy_amount = $6,
		    discrepancy_reason = $7, reconciliation_state = $8, mismatches = $9,
		    override_reason = $10, override_by = $11, override_at = $12, updated_at = NOW()
		WHERE workspace_id = $13 AND record_id = $14
	`
	return p.withTenantTx(ctx, r.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			r.ScopeType, r.ScopeDescription, r.RelatedOrderIDs,
			r.RelatedSettlementIDs, r.MatchedAmount.ToPgNumeric(), r.DiscrepancyAmount.ToPgNumeric(),
			r.DiscrepancyReason, toPgReconciliationState(r.ReconciliationState), []byte(mismatchesJSON),
			r.OverrideReason, overrideBy, r.OverrideAt,
			r.WorkspaceID, r.RecordID,
		)
		return err
	})
}

func (p *PostgresStore) CreateReconciliationMatch(ctx context.Context, m *ReconciliationMatch) error {
	if m.MatchID == "" {
		m.MatchID = newUUID()
	}
	if m.CreatedAt.IsZero() {
		m.CreatedAt = time.Now().UTC()
	}
	var recordID *string
	if m.RecordID != "" {
		recordID = &m.RecordID
	}

	query := `
		INSERT INTO reconciliation_matches (
			match_id, workspace_id, record_id, settlement_id,
			line_id, order_id, allocated_amount, currency, created_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7, $8, $9
		)
	`
	return p.withTenantTx(ctx, m.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			m.MatchID, m.WorkspaceID, recordID, m.SettlementID,
			m.LineID, m.OrderID, m.AllocatedAmount.ToPgNumeric(), m.Currency, m.CreatedAt,
		)
		return err
	})
}

func (p *PostgresStore) ListReconciliationMatches(ctx context.Context, workspaceID, recordID string) ([]ReconciliationMatch, error) {
	query := `
		SELECT match_id, workspace_id, record_id, settlement_id,
		       line_id, order_id, allocated_amount, currency, created_at
		FROM reconciliation_matches
		WHERE workspace_id = $1
	`
	args := []any{workspaceID}
	if recordID != "" {
		query += " AND record_id = $2"
		args = append(args, recordID)
	}
	query += " ORDER BY created_at ASC"

	var matches []ReconciliationMatch
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, query, args...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var m ReconciliationMatch
			var allocNum pgtype.Numeric
			var recID *string
			if err := rows.Scan(
				&m.MatchID, &m.WorkspaceID, &recID, &m.SettlementID,
				&m.LineID, &m.OrderID, &allocNum, &m.Currency, &m.CreatedAt,
			); err != nil {
				return err
			}
			if recID != nil {
				m.RecordID = *recID
			}
			m.AllocatedAmount, _ = tenantdb.FromPgNumeric(allocNum)
			matches = append(matches, m)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	return matches, nil
}

func (p *PostgresStore) AtomicMatch(
	ctx context.Context,
	workspaceID, settlementID, lineID, orderID, recordID string,
	allocAmount tenantdb.ExactDecimal,
) (*SettlementLine, *Order, *ReconciliationMatch, error) {
	var l SettlementLine
	var o Order
	var match *ReconciliationMatch

	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		// 1. Lock and read settlement line
		lineQuery := `
			SELECT line_id::text, workspace_id::text, settlement_id::text, external_line_id,
			       external_order_id, order_id::text, gross_amount, fee_amount,
			       refund_amount, net_amount, matched_amount, currency,
			       COALESCE(reconciliation_state::text, 'imported_only'), created_at
			FROM settlement_lines
			WHERE workspace_id = $1 AND settlement_id = $2 AND line_id = $3
			FOR UPDATE
		`
		var grossNum, feeNum, refNum, netNum, matchNum pgtype.Numeric
		var extOrder, ordID *string
		var rawLineState string

		err := tx.QueryRow(txCtx, lineQuery, workspaceID, settlementID, lineID).Scan(
			&l.LineID, &l.WorkspaceID, &l.SettlementID, &l.ExternalLineID,
			&extOrder, &ordID, &grossNum, &feeNum,
			&refNum, &netNum, &matchNum, &l.Currency,
			&rawLineState, &l.CreatedAt,
		)
		if err != nil {
			return fmt.Errorf("lock settlement line: %w", err)
		}
		l.ReconciliationState = fromPgReconciliationState(rawLineState)
		if extOrder != nil {
			l.ExternalOrderID = *extOrder
		}
		if ordID != nil {
			l.OrderID = *ordID
		}
		l.GrossAmount, _ = tenantdb.FromPgNumeric(grossNum)
		l.FeeAmount, _ = tenantdb.FromPgNumeric(feeNum)
		l.RefundAmount, _ = tenantdb.FromPgNumeric(refNum)
		l.NetAmount, _ = tenantdb.FromPgNumeric(netNum)
		l.MatchedAmount, _ = tenantdb.FromPgNumeric(matchNum)

		newLineMatched, err := l.MatchedAmount.Add(allocAmount)
		if err != nil {
			return err
		}
		if newLineMatched.Cmp(l.NetAmount) > 0 {
			return ErrCapacityExceeded
		}

		// 2. Lock and read order
		orderQuery := `
			SELECT order_id::text, workspace_id::text, amount, matched_amount, currency,
			       lifecycle_state, COALESCE(reconciliation_state::text, 'imported_only'), ordered_at
			FROM orders
			WHERE workspace_id = $1 AND order_id = $2
			FOR UPDATE
		`
		var oAmtNum, oMatchNum pgtype.Numeric
		var rawOrdState string
		err = tx.QueryRow(txCtx, orderQuery, workspaceID, orderID).Scan(
			&o.OrderID, &o.WorkspaceID, &oAmtNum, &oMatchNum, &o.Currency,
			&o.LifecycleState, &rawOrdState, &o.OrderedAt,
		)
		if err != nil {
			return ErrOrderNotFound
		}
		o.ReconciliationState = fromPgReconciliationState(rawOrdState)
		o.Amount, _ = tenantdb.FromPgNumeric(oAmtNum)
		o.MatchedAmount, _ = tenantdb.FromPgNumeric(oMatchNum)

		newOrderMatched, err := o.MatchedAmount.Add(allocAmount)
		if err != nil {
			return err
		}
		if newOrderMatched.Cmp(o.Amount) > 0 {
			return ErrOrderCapacityExceeded
		}

		// 3. Update line
		l.MatchedAmount = newLineMatched
		if newLineMatched.Cmp(l.NetAmount) == 0 {
			l.ReconciliationState = ReconciliationFullyReconciled
		} else {
			l.ReconciliationState = ReconciliationPartiallyReconciled
		}
		_, err = tx.Exec(txCtx, `
			UPDATE settlement_lines
			SET matched_amount = $1, reconciliation_state = $2
			WHERE workspace_id = $3 AND line_id = $4
		`, l.MatchedAmount.ToPgNumeric(), toPgReconciliationState(l.ReconciliationState), workspaceID, lineID)
		if err != nil {
			return err
		}

		// 4. Update order
		o.MatchedAmount = newOrderMatched
		if newOrderMatched.Cmp(o.Amount) == 0 {
			o.ReconciliationState = ReconciliationFullyReconciled
		} else {
			o.ReconciliationState = ReconciliationPartiallyReconciled
		}
		_, err = tx.Exec(txCtx, `
			UPDATE orders
			SET matched_amount = $1, reconciliation_state = $2, updated_at = NOW()
			WHERE workspace_id = $3 AND order_id = $4
		`, o.MatchedAmount.ToPgNumeric(), toPgReconciliationState(o.ReconciliationState), workspaceID, orderID)
		if err != nil {
			return err
		}

		// 5. Create match
		match = &ReconciliationMatch{
			MatchID:         newUUID(),
			WorkspaceID:     workspaceID,
			RecordID:        recordID,
			SettlementID:    settlementID,
			LineID:          lineID,
			OrderID:         orderID,
			AllocatedAmount: allocAmount,
			Currency:        l.Currency,
			CreatedAt:       time.Now().UTC(),
		}
		var recIDParam *string
		if recordID != "" {
			recIDParam = &recordID
		}
		_, err = tx.Exec(txCtx, `
			INSERT INTO reconciliation_matches (
				match_id, workspace_id, record_id, settlement_id,
				line_id, order_id, allocated_amount, currency, created_at
			) VALUES (
				$1, $2, $3, $4,
				$5, $6, $7, $8, $9
			)
		`, match.MatchID, workspaceID, recIDParam, settlementID, lineID, orderID, allocAmount.ToPgNumeric(), match.Currency, match.CreatedAt)
		if err != nil {
			return err
		}

		// 6. Update batch record if supplied
		if recordID != "" {
			_, err = tx.Exec(txCtx, `
				UPDATE reconciliation_records
				SET matched_amount = matched_amount + $1, updated_at = NOW()
				WHERE workspace_id = $2 AND record_id = $3
			`, allocAmount.ToPgNumeric(), workspaceID, recordID)
			if err != nil {
				return err
			}
		}

		return nil
	})
	if err != nil {
		return nil, nil, nil, err
	}
	return &l, &o, match, nil
}

func (p *PostgresStore) CreateEvidence(ctx context.Context, e *EvidenceObject) error {
	if e.EvidenceID == "" {
		e.EvidenceID = newUUID()
	}
	now := time.Now().UTC()
	if e.CollectedAt.IsZero() {
		e.CollectedAt = now
	}
	if e.CreatedAt.IsZero() {
		e.CreatedAt = now
	}
	if e.VerificationStatus == "" {
		e.VerificationStatus = VerificationStatusPending
	}
	var payloadBytes []byte
	if e.PayloadJSON != "" {
		payloadBytes = []byte(e.PayloadJSON)
	}
	refsBytes, _ := json.Marshal(e.RelatedObjectRefs)

	query := `
		INSERT INTO evidence_objects (
			evidence_id, workspace_id, evidence_type, source_provenance,
			content_hash, file_url, payload, collected_at,
			verification_status, related_object_refs, created_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7, $8,
			$9, $10, $11
		)
	`
	return p.withTenantTx(ctx, e.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			e.EvidenceID, e.WorkspaceID, e.EvidenceType, e.SourceProvenance,
			e.ContentHash, e.FileURL, payloadBytes, e.CollectedAt,
			e.VerificationStatus, refsBytes, e.CreatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetEvidence(ctx context.Context, workspaceID, evidenceID string) (*EvidenceObject, error) {
	query := `
		SELECT evidence_id, workspace_id, evidence_type, source_provenance,
		       content_hash, file_url, payload, collected_at,
		       verification_status, related_object_refs, created_at, deleted_at
		FROM evidence_objects
		WHERE workspace_id = $1 AND evidence_id = $2
	`
	var ev *EvidenceObject
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		ev, scanErr = scanEvidence(tx.QueryRow(txCtx, query, workspaceID, evidenceID))
		return scanErr
	})
	return ev, err
}

func (p *PostgresStore) ListEvidence(ctx context.Context, workspaceID string, filter EvidenceFilter, limit, offset int) ([]EvidenceObject, int64, error) {
	where := "WHERE workspace_id = $1 AND deleted_at IS NULL"
	args := []any{workspaceID}
	idx := 2

	if filter.EvidenceType != "" {
		where += fmt.Sprintf(" AND evidence_type = $%d", idx)
		args = append(args, filter.EvidenceType)
		idx++
	}
	if filter.VerificationStatus != "" {
		where += fmt.Sprintf(" AND verification_status = $%d", idx)
		args = append(args, filter.VerificationStatus)
		idx++
	}

	countQuery := "SELECT COUNT(*) FROM evidence_objects " + where
	query := fmt.Sprintf(`
		SELECT evidence_id, workspace_id, evidence_type, source_provenance,
		       content_hash, file_url, payload, collected_at,
		       verification_status, related_object_refs, created_at, deleted_at
		FROM evidence_objects
		%s
		ORDER BY created_at DESC
	`, where)

	if limit > 0 {
		query += fmt.Sprintf(" LIMIT %d", limit)
	}
	if offset > 0 {
		query += fmt.Sprintf(" OFFSET %d", offset)
	}

	var total int64
	var items []EvidenceObject
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, countQuery, args...).Scan(&total); err != nil {
			return err
		}
		rows, err := tx.Query(txCtx, query, args...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			e, err := scanEvidenceRow(rows)
			if err != nil {
				return err
			}
			items = append(items, *e)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, 0, err
	}
	return items, total, nil
}

func (p *PostgresStore) UpdateEvidence(ctx context.Context, e *EvidenceObject) error {
	return p.withTenantTx(ctx, e.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		existing, err := p.GetEvidence(txCtx, e.WorkspaceID, e.EvidenceID)
		if err != nil {
			return err
		}
		// RULE-M19-005 Immutability check
		if existing.WorkspaceID != e.WorkspaceID ||
			existing.EvidenceType != e.EvidenceType ||
			existing.SourceProvenance != e.SourceProvenance ||
			existing.ContentHash != e.ContentHash ||
			existing.FileURL != e.FileURL ||
			existing.PayloadJSON != e.PayloadJSON {
			return ErrEvidenceImmutable
		}
		query := `
			UPDATE evidence_objects
			SET verification_status = $1
			WHERE workspace_id = $2 AND evidence_id = $3
		`
		_, err = tx.Exec(txCtx, query, e.VerificationStatus, e.WorkspaceID, e.EvidenceID)
		return err
	})
}

func (p *PostgresStore) DeleteEvidence(_ context.Context, _, _ string) error {
	// RULE-M19-005: Evidence objects cannot be deleted
	return ErrEvidenceImmutable
}

func (p *PostgresStore) CreateProofBundle(ctx context.Context, pb *ProofBundle) error {
	if pb.ProofBundleID == "" {
		pb.ProofBundleID = newUUID()
	}
	now := time.Now().UTC()
	if pb.CreatedAt.IsZero() {
		pb.CreatedAt = now
	}
	if pb.UpdatedAt.IsZero() {
		pb.UpdatedAt = now
	}
	if pb.Confidence == "" {
		pb.Confidence = ConfidenceMedium
	}
	ctxJSON, _ := json.Marshal(pb.SourceClassContext)

	query := `
		INSERT INTO proof_bundles (
			proof_bundle_id, workspace_id, claim_scope, claim_summary,
			supporting_evidence_ids, source_class_context, confidence,
			coverage_summary, unresolved_gaps, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7,
			$8, $9, $10, $11
		)
	`
	return p.withTenantTx(ctx, pb.WorkspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			pb.ProofBundleID, pb.WorkspaceID, pb.ClaimScope, pb.ClaimSummary,
			pb.SupportingEvidenceIDs, ctxJSON, pb.Confidence,
			pb.CoverageSummary, pb.UnresolvedGaps, pb.CreatedAt, pb.UpdatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetProofBundle(ctx context.Context, workspaceID, bundleID string) (*ProofBundle, error) {
	query := `
		SELECT proof_bundle_id, workspace_id, claim_scope, claim_summary,
		       supporting_evidence_ids, source_class_context, confidence,
		       coverage_summary, unresolved_gaps, created_at, updated_at, deleted_at
		FROM proof_bundles
		WHERE workspace_id = $1 AND proof_bundle_id = $2 AND deleted_at IS NULL
	`
	var pb *ProofBundle
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		var scanErr error
		pb, scanErr = scanProofBundle(tx.QueryRow(txCtx, query, workspaceID, bundleID))
		return scanErr
	})
	return pb, err
}

func (p *PostgresStore) ListProofBundles(ctx context.Context, workspaceID string, filter ProofBundleFilter, limit, offset int) ([]ProofBundle, int64, error) {
	where := "WHERE workspace_id = $1 AND deleted_at IS NULL"
	args := []any{workspaceID}
	idx := 2

	if filter.ClaimScope != "" {
		where += fmt.Sprintf(" AND claim_scope = $%d", idx)
		args = append(args, filter.ClaimScope)
		idx++
	}

	countQuery := "SELECT COUNT(*) FROM proof_bundles " + where
	query := fmt.Sprintf(`
		SELECT proof_bundle_id, workspace_id, claim_scope, claim_summary,
		       supporting_evidence_ids, source_class_context, confidence,
		       coverage_summary, unresolved_gaps, created_at, updated_at, deleted_at
		FROM proof_bundles
		%s
		ORDER BY created_at DESC
	`, where)

	if limit > 0 {
		query += fmt.Sprintf(" LIMIT %d", limit)
	}
	if offset > 0 {
		query += fmt.Sprintf(" OFFSET %d", offset)
	}

	var total int64
	var bundles []ProofBundle
	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, countQuery, args...).Scan(&total); err != nil {
			return err
		}
		rows, err := tx.Query(txCtx, query, args...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			b, err := scanProofBundleRow(rows)
			if err != nil {
				return err
			}
			bundles = append(bundles, *b)
		}
		return rows.Err()
	})
	if err != nil {
		return nil, 0, err
	}
	return bundles, total, nil
}

func (p *PostgresStore) ListDataGaps(ctx context.Context, workspaceID string, filter DataGapFilter, limit, offset int) ([]DataGapItem, int64, error) {
	var items []DataGapItem
	ordersByID := make(map[string]Order)

	err := p.withTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx) error {
		type rawPosting struct {
			postingID   string
			originType  string
			originID    string
			component   string
			amount      tenantdb.ExactDecimal
			reversalOf  *string
			effectiveAt time.Time
		}
		var postings []rawPosting
		reversedIDs := make(map[string]bool)

		pRows, err := tx.Query(txCtx, `
			SELECT posting_id::text, origin_type, origin_id::text, component, amount, reversal_of::text, effective_at
			FROM financial_postings
			WHERE workspace_id = $1
		`, workspaceID)
		if err != nil {
			return fmt.Errorf("list postings for data gaps: %w", err)
		}
		for pRows.Next() {
			var rp rawPosting
			var amtNum pgtype.Numeric
			if err := pRows.Scan(&rp.postingID, &rp.originType, &rp.originID, &rp.component, &amtNum, &rp.reversalOf, &rp.effectiveAt); err != nil {
				pRows.Close()
				return err
			}
			rp.amount, _ = tenantdb.FromPgNumeric(amtNum)
			if rp.reversalOf != nil && *rp.reversalOf != "" {
				reversedIDs[*rp.reversalOf] = true
			}
			postings = append(postings, rp)
		}
		if err := pRows.Err(); err != nil {
			pRows.Close()
			return err
		}
		pRows.Close()

		type rawCostItem struct {
			costItemID       string
			costType         string
			amount           tenantdb.ExactDecimal
			costState        string
			confidenceReason string
			relatedScopeType string
			relatedScopeID   string
			createdAt        time.Time
		}
		costItemsByID := make(map[string]rawCostItem)
		cRows, err := tx.Query(txCtx, `
			SELECT cost_item_id::text, cost_type, amount, cost_state,
			       COALESCE(confidence_reason, ''), COALESCE(related_scope_type, ''), COALESCE(related_scope_id::text, ''), created_at
			FROM cost_items
			WHERE workspace_id = $1 AND deleted_at IS NULL
		`, workspaceID)
		if err != nil {
			return fmt.Errorf("list cost items for data gaps: %w", err)
		}
		for cRows.Next() {
			var ci rawCostItem
			var amtNum pgtype.Numeric
			if err := cRows.Scan(&ci.costItemID, &ci.costType, &amtNum, &ci.costState, &ci.confidenceReason, &ci.relatedScopeType, &ci.relatedScopeID, &ci.createdAt); err != nil {
				cRows.Close()
				return err
			}
			ci.amount, _ = tenantdb.FromPgNumeric(amtNum)
			costItemsByID[ci.costItemID] = ci
		}
		if err := cRows.Err(); err != nil {
			cRows.Close()
			return err
		}
		cRows.Close()

		// Identify orders that have active COGS in financial_postings or order-scoped cost_items
		ordersWithCOGS := make(map[string]bool)
		for _, ci := range costItemsByID {
			if ci.costState != CostStateSuperseded &&
				strings.EqualFold(ci.costType, "cogs") &&
				strings.EqualFold(ci.relatedScopeType, "order") &&
				ci.relatedScopeID != "" {
				if !ci.amount.IsZero() || strings.TrimSpace(ci.confidenceReason) != "" {
					ordersWithCOGS[ci.relatedScopeID] = true
				}
			}
		}
		for _, rp := range postings {
			if rp.reversalOf != nil || reversedIDs[rp.postingID] || rp.component != ComponentCOGS || rp.amount.IsZero() {
				continue
			}
			if rp.originType == "order" {
				ordersWithCOGS[rp.originID] = true
			} else if rp.originType == "cost_item" {
				if ci, ok := costItemsByID[rp.originID]; ok &&
					ci.costState != CostStateSuperseded &&
					strings.EqualFold(ci.relatedScopeType, "order") &&
					ci.relatedScopeID != "" {
					ordersWithCOGS[ci.relatedScopeID] = true
				}
			}
		}

		// 1. Missing COGS on completed orders (both stored orders and recognized order revenue postings)
		seenMissingCOGSOrders := make(map[string]bool)
		orderRows, err := tx.Query(txCtx, `
			SELECT order_id::text, amount, ordered_at, recognized_at,
			       COALESCE(product_id::text, ''),
			       COALESCE(offer_id::text, ''),
			       COALESCE(items, '[]'::jsonb),
			       COALESCE(fee_breakdown, '{}'::jsonb),
			       COALESCE(metadata, '{}'::jsonb)
			FROM orders
			WHERE workspace_id = $1 AND deleted_at IS NULL AND lifecycle_state = 'completed'
		`, workspaceID)
		if err != nil {
			return fmt.Errorf("list orders for data gaps: %w", err)
		}
		var completedOrders []Order
		for orderRows.Next() {
			var o Order
			var amtNum pgtype.Numeric
			var offerID string
			var itemsBytes, feeBytes, metaBytes []byte
			if err := orderRows.Scan(&o.OrderID, &amtNum, &o.OrderedAt, &o.RecognizedAt, &o.ProductID, &offerID, &itemsBytes, &feeBytes, &metaBytes); err != nil {
				orderRows.Close()
				return err
			}
			o.WorkspaceID = workspaceID
			o.LifecycleState = "completed"
			o.Amount, _ = tenantdb.FromPgNumeric(amtNum)
			if offerID != "" {
				o.ProductIDs = appendUniqueString(o.ProductIDs, offerID)
			}
			hydrateOrderDetails(&o, itemsBytes, feeBytes, metaBytes)
			if (o.COGSAmount != nil && !o.COGSAmount.IsZero()) || o.HasConfirmedZeroCOGS() {
				ordersWithCOGS[o.OrderID] = true
			}
			completedOrders = append(completedOrders, o)
		}
		if err := orderRows.Err(); err != nil {
			orderRows.Close()
			return err
		}
		orderRows.Close()

		enrichOrdersFromRelationsTx(txCtx, tx, workspaceID, completedOrders)
		for _, o := range completedOrders {
			ordersByID[o.OrderID] = o
			if !ordersWithCOGS[o.OrderID] {
				seenMissingCOGSOrders[o.OrderID] = true
				items = append(items, DataGapItem{
					GapID:              "gap-cogs-" + o.OrderID,
					GapType:            "missing_cogs",
					Severity:           "critical",
					Title:              "Đơn hàng thiếu giá vốn (COGS)",
					Description:        "Đơn hàng hoàn tất nhưng chưa có bản ghi giá vốn thực tế.",
					RelatedObjectType:  "order",
					RelatedObjectID:    o.OrderID,
					MonetaryAmount:     o.Amount,
					UnresolvedSince:    o.EffectiveTime(),
					RepairCTALabel:     "Nhập giá vốn",
					RepairCTARoute:     "/finance/costs?order_id=" + o.OrderID,
					RequiredPermission: "cost:manage",
				})
			}
		}

		for _, rp := range postings {
			if rp.reversalOf != nil || reversedIDs[rp.postingID] {
				continue
			}
			if rp.originType == "order" && rp.component == ComponentRevenue && !seenMissingCOGSOrders[rp.originID] && !ordersWithCOGS[rp.originID] {
				seenMissingCOGSOrders[rp.originID] = true
				items = append(items, DataGapItem{
					GapID:              "gap-cogs-" + rp.originID,
					GapType:            "missing_cogs",
					Severity:           "critical",
					Title:              "Đơn hàng thiếu giá vốn (COGS)",
					Description:        "Đơn hàng hoàn tất nhưng chưa có bản ghi giá vốn thực tế.",
					RelatedObjectType:  "order",
					RelatedObjectID:    rp.originID,
					MonetaryAmount:     rp.amount,
					UnresolvedSince:    rp.effectiveAt,
					RepairCTALabel:     "Nhập giá vốn",
					RepairCTARoute:     "/finance/costs?order_id=" + rp.originID,
					RequiredPermission: "cost:manage",
				})
			}
		}

		// 2. Unreconciled settlement lines
		lineRows, err := tx.Query(txCtx, `
			SELECT line_id::text, (net_amount - matched_amount) AS rem_amount, created_at
			FROM settlement_lines
			WHERE workspace_id = $1
			  AND reconciliation_state::text IN ('imported_only', 'partially_reconciled', 'partially_matched', 'awaiting_evidence')
			  AND net_amount > matched_amount
		`, workspaceID)
		if err != nil {
			return fmt.Errorf("list settlement lines for data gaps: %w", err)
		}
		for lineRows.Next() {
			var lID string
			var remNum pgtype.Numeric
			var cAt time.Time
			if err := lineRows.Scan(&lID, &remNum, &cAt); err != nil {
				lineRows.Close()
				return err
			}
			rem, _ := tenantdb.FromPgNumeric(remNum)
			items = append(items, DataGapItem{
				GapID:              "gap-sment-" + lID,
				GapType:            "unreconciled_settlement",
				Severity:           "warning",
				Title:              "Khoản thanh toán chưa đối soát",
				Description:        "Khoản tiền sàn đã giải ngân nhưng chưa khớp với đơn hàng tương ứng.",
				RelatedObjectType:  "settlement_line",
				RelatedObjectID:    lID,
				MonetaryAmount:     rem,
				UnresolvedSince:    cAt,
				RepairCTALabel:     "Khớp đối soát",
				RepairCTARoute:     "/finance/reconciliation?line_id=" + lID,
				RequiredPermission: "reconciliation:manage",
			})
		}
		if err := lineRows.Err(); err != nil {
			lineRows.Close()
			return err
		}
		lineRows.Close()

		// 3. Cost items pending evidence
		for _, ci := range costItemsByID {
			if ci.costState == CostStatePendingEvidence {
				items = append(items, DataGapItem{
					GapID:              "gap-cost-" + ci.costItemID,
					GapType:            "missing_evidence",
					Severity:           "warning",
					Title:              "Chi phí chưa có chứng từ hợp lệ",
					Description:        "Chi phí được ghi nhận ước tính nhưng chưa đính kèm chứng từ.",
					RelatedObjectType:  "cost_item",
					RelatedObjectID:    ci.costItemID,
					MonetaryAmount:     ci.amount,
					UnresolvedSince:    ci.createdAt,
					RepairCTALabel:     "Tải lên chứng từ",
					RepairCTARoute:     "/finance/evidence?cost_id=" + ci.costItemID,
					RequiredPermission: "evidence:submit",
				})
			}
		}
		return nil
	})
	if err != nil {
		return nil, 0, err
	}

	severityRank := func(s string) int {
		switch s {
		case "critical":
			return 1
		case "warning":
			return 2
		default:
			return 3
		}
	}

	sort.Slice(items, func(i, j int) bool {
		rI := severityRank(items[i].Severity)
		rJ := severityRank(items[j].Severity)
		if rI != rJ {
			return rI < rJ
		}
		if !items[i].UnresolvedSince.Equal(items[j].UnresolvedSince) {
			return items[i].UnresolvedSince.Before(items[j].UnresolvedSince)
		}
		return items[i].GapID < items[j].GapID
	})

	startUTC, endUTC, _ := parseReportPeriodBounds(filter.PeriodStart, filter.PeriodEnd)
	filterProdID := strings.TrimSpace(filter.ProductID)
	var filtered []DataGapItem
	for _, item := range items {
		if filter.Severity != "" && item.Severity != filter.Severity {
			continue
		}
		if filter.GapType != "" && item.GapType != filter.GapType {
			continue
		}
		if (startUTC != nil || endUTC != nil) && !timeWithinPeriodBounds(item.UnresolvedSince, startUTC, endUTC) {
			continue
		}
		if filterProdID != "" && item.RelatedObjectType == "order" {
			ord, ok := ordersByID[item.RelatedObjectID]
			if !ok || !orderMatchesProduct(ord, filterProdID) {
				continue
			}
		}
		filtered = append(filtered, item)
	}

	total := int64(len(filtered))
	if offset > len(filtered) {
		return nil, total, nil
	}
	filtered = filtered[offset:]
	if limit > 0 && len(filtered) > limit {
		filtered = filtered[:limit]
	}
	return filtered, total, nil
}

func scanReconciliationRecord(row pgx.Row) (*ReconciliationRecord, error) {
	var r ReconciliationRecord
	var matchNum, discNum pgtype.Numeric
	var mismatchesBytes []byte
	var pStart, pEnd, overReason, overBy *string
	var overAt *time.Time

	err := row.Scan(
		&r.RecordID, &r.WorkspaceID, &r.ScopeType, &r.ScopeDescription,
		&r.RelatedOrderIDs, &r.RelatedSettlementIDs, &matchNum,
		&discNum, &r.DiscrepancyReason, &r.ReconciliationState,
		&r.Currency, &mismatchesBytes, &overReason, &overBy, &overAt,
		&pStart, &pEnd, &r.CreatedAt, &r.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrRecordNotFound
		}
		return nil, err
	}
	r.ReconciliationState = fromPgReconciliationState(r.ReconciliationState)
	r.MatchedAmount, _ = tenantdb.FromPgNumeric(matchNum)
	r.DiscrepancyAmount, _ = tenantdb.FromPgNumeric(discNum)
	if len(mismatchesBytes) > 0 {
		r.MismatchesJSON = string(mismatchesBytes)
	}
	if overReason != nil {
		r.OverrideReason = *overReason
	}
	if overBy != nil {
		r.OverrideBy = *overBy
	}
	r.OverrideAt = overAt
	if pStart != nil {
		r.PeriodStart = *pStart
	}
	if pEnd != nil {
		r.PeriodEnd = *pEnd
	}
	return &r, nil
}

func scanReconciliationRecordRow(rows pgx.Rows) (*ReconciliationRecord, error) {
	var r ReconciliationRecord
	var matchNum, discNum pgtype.Numeric
	var mismatchesBytes []byte
	var pStart, pEnd, overReason, overBy *string
	var overAt *time.Time

	err := rows.Scan(
		&r.RecordID, &r.WorkspaceID, &r.ScopeType, &r.ScopeDescription,
		&r.RelatedOrderIDs, &r.RelatedSettlementIDs, &matchNum,
		&discNum, &r.DiscrepancyReason, &r.ReconciliationState,
		&r.Currency, &mismatchesBytes, &overReason, &overBy, &overAt,
		&pStart, &pEnd, &r.CreatedAt, &r.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}
	r.ReconciliationState = fromPgReconciliationState(r.ReconciliationState)
	r.MatchedAmount, _ = tenantdb.FromPgNumeric(matchNum)
	r.DiscrepancyAmount, _ = tenantdb.FromPgNumeric(discNum)
	if len(mismatchesBytes) > 0 {
		r.MismatchesJSON = string(mismatchesBytes)
	}
	if overReason != nil {
		r.OverrideReason = *overReason
	}
	if overBy != nil {
		r.OverrideBy = *overBy
	}
	r.OverrideAt = overAt
	if pStart != nil {
		r.PeriodStart = *pStart
	}
	if pEnd != nil {
		r.PeriodEnd = *pEnd
	}
	return &r, nil
}

func scanEvidence(row pgx.Row) (*EvidenceObject, error) {
	var e EvidenceObject
	var payloadBytes, refsBytes []byte
	var fileURL, prov *string

	err := row.Scan(
		&e.EvidenceID, &e.WorkspaceID, &e.EvidenceType, &prov,
		&e.ContentHash, &fileURL, &payloadBytes, &e.CollectedAt,
		&e.VerificationStatus, &refsBytes, &e.CreatedAt, &e.DeletedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrEvidenceNotFound
		}
		return nil, err
	}
	if prov != nil {
		e.SourceProvenance = *prov
	}
	if fileURL != nil {
		e.FileURL = *fileURL
	}
	if len(payloadBytes) > 0 {
		e.PayloadJSON = string(payloadBytes)
	}
	if len(refsBytes) > 0 {
		_ = json.Unmarshal(refsBytes, &e.RelatedObjectRefs)
	}
	return &e, nil
}

func scanEvidenceRow(rows pgx.Rows) (*EvidenceObject, error) {
	var e EvidenceObject
	var payloadBytes, refsBytes []byte
	var fileURL, prov *string

	err := rows.Scan(
		&e.EvidenceID, &e.WorkspaceID, &e.EvidenceType, &prov,
		&e.ContentHash, &fileURL, &payloadBytes, &e.CollectedAt,
		&e.VerificationStatus, &refsBytes, &e.CreatedAt, &e.DeletedAt,
	)
	if err != nil {
		return nil, err
	}
	if prov != nil {
		e.SourceProvenance = *prov
	}
	if fileURL != nil {
		e.FileURL = *fileURL
	}
	if len(payloadBytes) > 0 {
		e.PayloadJSON = string(payloadBytes)
	}
	if len(refsBytes) > 0 {
		_ = json.Unmarshal(refsBytes, &e.RelatedObjectRefs)
	}
	return &e, nil
}

func scanProofBundle(row pgx.Row) (*ProofBundle, error) {
	var pb ProofBundle
	var ctxBytes []byte
	var cov, gaps *string

	err := row.Scan(
		&pb.ProofBundleID, &pb.WorkspaceID, &pb.ClaimScope, &pb.ClaimSummary,
		&pb.SupportingEvidenceIDs, &ctxBytes, &pb.Confidence,
		&cov, &gaps, &pb.CreatedAt, &pb.UpdatedAt, &pb.DeletedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrProofBundleNotFound
		}
		return nil, err
	}
	if cov != nil {
		pb.CoverageSummary = *cov
	}
	if gaps != nil {
		pb.UnresolvedGaps = *gaps
	}
	if len(ctxBytes) > 0 {
		_ = json.Unmarshal(ctxBytes, &pb.SourceClassContext)
	}
	return &pb, nil
}

func scanProofBundleRow(rows pgx.Rows) (*ProofBundle, error) {
	var pb ProofBundle
	var ctxBytes []byte
	var cov, gaps *string

	err := rows.Scan(
		&pb.ProofBundleID, &pb.WorkspaceID, &pb.ClaimScope, &pb.ClaimSummary,
		&pb.SupportingEvidenceIDs, &ctxBytes, &pb.Confidence,
		&cov, &gaps, &pb.CreatedAt, &pb.UpdatedAt, &pb.DeletedAt,
	)
	if err != nil {
		return nil, err
	}
	if cov != nil {
		pb.CoverageSummary = *cov
	}
	if gaps != nil {
		pb.UnresolvedGaps = *gaps
	}
	if len(ctxBytes) > 0 {
		_ = json.Unmarshal(ctxBytes, &pb.SourceClassContext)
	}
	return &pb, nil
}

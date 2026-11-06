package product

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type Store interface {
	CreateProduct(ctx context.Context, p *Product) error
	GetProduct(ctx context.Context, workspaceID, productID string) (*Product, error)
	ListProducts(ctx context.Context, workspaceID string, filter ListFilter, limit, offset int) ([]*Product, int64, error)
	UpdateProduct(ctx context.Context, p *Product) error
	DeleteProduct(ctx context.Context, workspaceID, productID string) error
	ArchiveProduct(ctx context.Context, workspaceID, productID string) error
	BulkArchiveProducts(ctx context.Context, workspaceID string, productIDs []string) (int, error)
	FindProductByExternalID(ctx context.Context, workspaceID, platform, externalID, connectedAccountID string) (*Product, error)

	CreateSku(ctx context.Context, sku *ProductSku) error
	GetSku(ctx context.Context, workspaceID, skuID string) (*ProductSku, error)
	ListSkusByProduct(ctx context.Context, workspaceID, productID string) ([]ProductSku, error)
	UpdateSkuStock(ctx context.Context, workspaceID, skuID string, delta int32) (int32, error)
	SetSkuAlertThreshold(ctx context.Context, workspaceID, skuID string, threshold int32) error

	LinkContent(ctx context.Context, workspaceID, productID string, ref ContentRef) error
	GetLinkedContent(ctx context.Context, workspaceID, productID string) ([]ContentRef, error)
	BatchTag(ctx context.Context, workspaceID string, productIDs []string, tagsToAdd []string, tagsToRemove []string) (int, error)

	GetIdempotencyRecord(ctx context.Context, workspaceID, idempotencyKey string) (*IdempotencyRecord, error)
	SaveIdempotencyRecord(ctx context.Context, rec IdempotencyRecord) error
	GetProductSalesSummary(ctx context.Context, workspaceID, productID string) (*ProductSalesSummary, error)
	GetProductSalesChart(ctx context.Context, workspaceID, productID string, days int) ([]SalesChartDataPoint, error)
	GetProductRank(ctx context.Context, workspaceID, productID string) (*ProductRankSummary, error)
}

type MemoryStore struct {
	mu          sync.RWMutex
	products    map[string]*Product          // key: productID
	skus        map[string]*ProductSku       // key: skuID
	movements   []StockMovementRecord        // append-only ledger
	idempotency map[string]IdempotencyRecord // key: workspaceID + ":" + idempotencyKey
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		products:    make(map[string]*Product),
		skus:        make(map[string]*ProductSku),
		idempotency: make(map[string]IdempotencyRecord),
	}
}

func (m *MemoryStore) ListStockMovements(workspaceID, skuID string) []StockMovementRecord {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var out []StockMovementRecord
	for _, mv := range m.movements {
		if mv.WorkspaceID == workspaceID && (skuID == "" || mv.SkuID == skuID) {
			out = append(out, mv)
		}
	}
	return out
}

func (m *MemoryStore) CreateProduct(_ context.Context, p *Product) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if _, exists := m.products[p.ProductID]; exists {
		return fmt.Errorf("%w: product already exists", ErrInvalidInput)
	}
	cp := cloneProduct(p)
	m.products[p.ProductID] = cp
	for _, sku := range cp.SKUs {
		skuCp := sku
		skuCp.ProductID = p.ProductID
		skuCp.WorkspaceID = p.WorkspaceID
		m.skus[sku.SkuID] = &skuCp
	}
	return nil
}

func (m *MemoryStore) GetProduct(_ context.Context, workspaceID, productID string) (*Product, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrProductNotFound
	}
	res := cloneProduct(p)
	res.SKUs = m.getSkusForProductLocked(workspaceID, productID)
	return res, nil
}

func (m *MemoryStore) getSkusForProductLocked(workspaceID, productID string) []ProductSku {
	var list []ProductSku
	for _, s := range m.skus {
		if s.WorkspaceID == workspaceID && s.ProductID == productID && s.DeletedAt == nil {
			list = append(list, *cloneSku(s))
		}
	}
	sort.Slice(list, func(i, j int) bool {
		if !list[i].CreatedAt.Equal(list[j].CreatedAt) {
			return list[i].CreatedAt.Before(list[j].CreatedAt)
		}
		return list[i].SkuID < list[j].SkuID
	})
	return list
}

func (m *MemoryStore) ListProducts(_ context.Context, workspaceID string, filter ListFilter, limit, offset int) ([]*Product, int64, error) {
	if offset < 0 {
		return nil, 0, fmt.Errorf("%w: offset cannot be negative", ErrInvalidInput)
	}
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matched []*Product
	for _, p := range m.products {
		if p.WorkspaceID != workspaceID || p.DeletedAt != nil {
			continue
		}
		if filter.Status != "" && !strings.EqualFold(p.CatalogStatus, filter.Status) {
			continue
		}
		if filter.Type != "" && !strings.EqualFold(p.ProductType, filter.Type) {
			continue
		}
		if filter.Category != "" && !strings.EqualFold(p.Category, filter.Category) {
			continue
		}
		if filter.SearchQuery != "" {
			q := strings.ToLower(filter.SearchQuery)
			if !strings.Contains(strings.ToLower(p.Title), q) && !strings.Contains(strings.ToLower(p.Description), q) {
				continue
			}
		}
		matched = append(matched, cloneProduct(p))
	}

	sort.Slice(matched, func(i, j int) bool {
		if !matched[i].CreatedAt.Equal(matched[j].CreatedAt) {
			return matched[i].CreatedAt.After(matched[j].CreatedAt)
		}
		return matched[i].ProductID > matched[j].ProductID
	})

	total := int64(len(matched))

	if filter.CursorCreatedAt != nil && filter.CursorProductID != "" {
		cursorTS := filter.CursorCreatedAt.UTC()
		var afterCursor []*Product
		for _, p := range matched {
			pTS := p.CreatedAt.UTC()
			if pTS.Before(cursorTS) || (pTS.Equal(cursorTS) && p.ProductID < filter.CursorProductID) {
				afterCursor = append(afterCursor, p)
			}
		}
		matched = afterCursor
		offset = 0
	}

	if offset >= len(matched) {
		return []*Product{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matched) {
		end = len(matched)
	}
	sliced := matched[offset:end]
	for _, p := range sliced {
		p.SKUs = m.getSkusForProductLocked(workspaceID, p.ProductID)
	}
	return sliced, total, nil
}

func (m *MemoryStore) UpdateProduct(_ context.Context, p *Product) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, exists := m.products[p.ProductID]
	if !exists || existing.WorkspaceID != p.WorkspaceID || existing.DeletedAt != nil {
		return ErrProductNotFound
	}
	if p.ExpectedUpdatedAt != nil {
		if !existing.UpdatedAt.UTC().Truncate(time.Microsecond).Equal(p.ExpectedUpdatedAt.UTC().Truncate(time.Microsecond)) {
			return ErrConcurrencyConflict
		}
	}
	cp := cloneProduct(p)
	if !cp.UpdatedAt.After(existing.UpdatedAt) {
		cp.UpdatedAt = existing.UpdatedAt.Add(time.Microsecond)
	}
	p.UpdatedAt = cp.UpdatedAt
	m.products[p.ProductID] = cp
	return nil
}

func (m *MemoryStore) DeleteProduct(_ context.Context, workspaceID, productID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return ErrProductNotFound
	}
	now := time.Now().UTC()
	p.DeletedAt = &now
	for _, s := range m.skus {
		if s.ProductID == productID {
			s.DeletedAt = &now
		}
	}
	return nil
}

func (m *MemoryStore) ArchiveProduct(_ context.Context, workspaceID, productID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return ErrProductNotFound
	}
	p.CatalogStatus = StatusArchived
	now := time.Now().UTC()
	if !now.After(p.UpdatedAt) {
		now = p.UpdatedAt.Add(time.Microsecond)
	}
	p.UpdatedAt = now
	return nil
}

func (m *MemoryStore) BulkArchiveProducts(_ context.Context, workspaceID string, productIDs []string) (int, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	count := 0
	now := time.Now().UTC()
	for _, pid := range productIDs {
		p, exists := m.products[pid]
		if exists && p.WorkspaceID == workspaceID && p.DeletedAt == nil {
			p.CatalogStatus = StatusArchived
			if !now.After(p.UpdatedAt) {
				p.UpdatedAt = p.UpdatedAt.Add(time.Microsecond)
			} else {
				p.UpdatedAt = now
			}
			count++
		}
	}
	return count, nil
}

func (m *MemoryStore) FindProductByExternalID(_ context.Context, workspaceID, platform, externalID, connectedAccountID string) (*Product, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, p := range m.products {
		if p.WorkspaceID != workspaceID || p.DeletedAt != nil {
			continue
		}
		for _, ref := range p.ExternalRefs {
			if strings.EqualFold(ref.Platform, platform) && ref.ExternalID == externalID {
				// Deduplication scopes by connected_account_id if provided
				if connectedAccountID != "" && ref.ConnectedAccountID != "" && ref.ConnectedAccountID != connectedAccountID {
					continue
				}
				res := cloneProduct(p)
				res.SKUs = m.getSkusForProductLocked(workspaceID, p.ProductID)
				return res, nil
			}
		}
	}
	return nil, ErrProductNotFound
}

func (m *MemoryStore) CreateSku(_ context.Context, sku *ProductSku) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	p, exists := m.products[sku.ProductID]
	if !exists || p.WorkspaceID != sku.WorkspaceID || p.DeletedAt != nil {
		return ErrProductNotFound
	}
	for _, s := range m.skus {
		if s.WorkspaceID == sku.WorkspaceID && s.ProductID == sku.ProductID && s.SkuCode == sku.SkuCode && s.DeletedAt == nil {
			return ErrDuplicateSkuCode
		}
	}
	cp := cloneSku(sku)
	m.skus[sku.SkuID] = cp
	return nil
}

func (m *MemoryStore) GetSku(_ context.Context, workspaceID, skuID string) (*ProductSku, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	s, exists := m.skus[skuID]
	if !exists || s.WorkspaceID != workspaceID || s.DeletedAt != nil {
		return nil, ErrSkuNotFound
	}
	return cloneSku(s), nil
}

func (m *MemoryStore) ListSkusByProduct(_ context.Context, workspaceID, productID string) ([]ProductSku, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	return m.getSkusForProductLocked(workspaceID, productID), nil
}

func (m *MemoryStore) UpdateSkuStock(ctx context.Context, workspaceID, skuID string, delta int32) (int32, error) {
	if delta == 0 {
		return 0, fmt.Errorf("%w: stock delta cannot be zero", ErrInvalidInput)
	}
	meta, _ := StockAdjustmentMetaFromContext(ctx)
	reason := strings.TrimSpace(meta.Reason)
	if reason == "" {
		reason = "manual_adjustment"
	}
	movementKey := strings.TrimSpace(meta.MovementKey)
	if movementKey == "" {
		movementKey = "adj:" + newUUID()
	}

	m.mu.Lock()
	defer m.mu.Unlock()

	s, exists := m.skus[skuID]
	if !exists || s.WorkspaceID != workspaceID || s.DeletedAt != nil {
		return 0, ErrSkuNotFound
	}

	for _, mv := range m.movements {
		if mv.WorkspaceID == workspaceID && mv.MovementKey == movementKey {
			if mv.SkuID != skuID || mv.Quantity != delta || mv.Reason != reason {
				return 0, ErrIdempotencyConflict
			}
			return s.StockQuantity, nil
		}
	}

	newQty := s.StockQuantity + delta
	if newQty < 0 {
		return s.StockQuantity, fmt.Errorf("%w: stock quantity cannot be negative", ErrInsufficientStock)
	}
	if newQty < s.StockReserved {
		return s.StockQuantity, fmt.Errorf("%w: stock quantity (%d) cannot be less than reserved stock (%d)", ErrInsufficientStock, newQty, s.StockReserved)
	}
	now := time.Now().UTC()
	s.StockQuantity = newQty
	s.UpdatedAt = now
	m.movements = append(m.movements, StockMovementRecord{
		MovementID:   newUUID(),
		WorkspaceID:  workspaceID,
		SkuID:        skuID,
		LocationID:   "default-loc-" + workspaceID,
		MovementType: "adjustment",
		Quantity:     delta,
		Reason:       reason,
		MovementKey:  movementKey,
		CreatedAt:    now,
	})
	return newQty, nil
}

func (m *MemoryStore) SetSkuAlertThreshold(_ context.Context, workspaceID, skuID string, threshold int32) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	s, exists := m.skus[skuID]
	if !exists || s.WorkspaceID != workspaceID || s.DeletedAt != nil {
		return ErrSkuNotFound
	}
	if threshold < 0 {
		return fmt.Errorf("%w: threshold cannot be negative", ErrInvalidInput)
	}
	s.LowStockThreshold = threshold
	s.UpdatedAt = time.Now().UTC()
	return nil
}

func (m *MemoryStore) LinkContent(_ context.Context, workspaceID, productID string, ref ContentRef) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return ErrProductNotFound
	}
	if p.Metadata == nil {
		p.Metadata = make(map[string]any)
	}
	raw, ok := p.Metadata["linked_content"]
	var list []ContentRef
	if ok {
		if bytes, err := json.Marshal(raw); err == nil {
			_ = json.Unmarshal(bytes, &list)
		}
	}
	now := time.Now().UTC()
	if !now.After(p.UpdatedAt) {
		now = p.UpdatedAt.Add(time.Microsecond)
	}
	// Check if already linked
	for i, existing := range list {
		if existing.ContentID == ref.ContentID {
			list[i] = ref // Update
			p.Metadata["linked_content"] = list
			p.UpdatedAt = now
			return nil
		}
	}
	list = append(list, ref)
	p.Metadata["linked_content"] = list
	p.UpdatedAt = now
	return nil
}

func (m *MemoryStore) GetLinkedContent(_ context.Context, workspaceID, productID string) ([]ContentRef, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrProductNotFound
	}
	if p.Metadata == nil {
		return []ContentRef{}, nil
	}
	raw, ok := p.Metadata["linked_content"]
	if !ok || raw == nil {
		return []ContentRef{}, nil
	}
	bytes, err := json.Marshal(raw)
	if err != nil {
		return []ContentRef{}, nil
	}
	var list []ContentRef
	if err := json.Unmarshal(bytes, &list); err != nil {
		return []ContentRef{}, nil
	}
	return list, nil
}

func (m *MemoryStore) BatchTag(_ context.Context, workspaceID string, productIDs []string, tagsToAdd []string, tagsToRemove []string) (int, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	count := 0
	removeSet := make(map[string]bool)
	for _, t := range tagsToRemove {
		removeSet[t] = true
	}

	for _, pid := range productIDs {
		p, exists := m.products[pid]
		if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
			continue
		}
		if p.Metadata == nil {
			p.Metadata = make(map[string]any)
		}
		currentTags := make(map[string]bool)
		if rawTags, ok := p.Metadata["tags"].([]any); ok {
			for _, rt := range rawTags {
				if s, ok := rt.(string); ok {
					currentTags[s] = true
				}
			}
		} else if strTags, ok := p.Metadata["tags"].([]string); ok {
			for _, s := range strTags {
				currentTags[s] = true
			}
		}
		for _, add := range tagsToAdd {
			currentTags[add] = true
		}
		for rem := range removeSet {
			delete(currentTags, rem)
		}
		var tagList []string
		for t := range currentTags {
			tagList = append(tagList, t)
		}
		sort.Strings(tagList)
		p.Metadata["tags"] = tagList
		now := time.Now().UTC()
		if !now.After(p.UpdatedAt) {
			now = p.UpdatedAt.Add(time.Microsecond)
		}
		p.UpdatedAt = now
		count++
	}
	return count, nil
}

func (m *MemoryStore) GetIdempotencyRecord(_ context.Context, workspaceID, idempotencyKey string) (*IdempotencyRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	rec, exists := m.idempotency[workspaceID+":"+idempotencyKey]
	if !exists {
		return nil, nil
	}
	if !rec.ExpiresAt.IsZero() && time.Now().UTC().After(rec.ExpiresAt) {
		return nil, nil
	}
	cp := rec
	if rec.ResponseBody != nil {
		cp.ResponseBody = append([]byte(nil), rec.ResponseBody...)
	}
	return &cp, nil
}

func (m *MemoryStore) SaveIdempotencyRecord(_ context.Context, rec IdempotencyRecord) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	key := rec.WorkspaceID + ":" + rec.IdempotencyKey
	now := time.Now().UTC()
	if existing, ok := m.idempotency[key]; ok {
		if existing.ExpiresAt.IsZero() || now.Before(existing.ExpiresAt) {
			if existing.RequestHash != rec.RequestHash {
				return ErrIdempotencyConflict
			}
			return nil
		}
	}
	cp := rec
	if cp.CreatedAt.IsZero() {
		cp.CreatedAt = now
	}
	if cp.ExpiresAt.IsZero() {
		cp.ExpiresAt = cp.CreatedAt.Add(24 * time.Hour)
	}
	if rec.ResponseBody != nil {
		cp.ResponseBody = append([]byte(nil), rec.ResponseBody...)
	}
	m.idempotency[key] = cp
	return nil
}

func (m *MemoryStore) GetProductSalesSummary(_ context.Context, workspaceID, productID string) (*ProductSalesSummary, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrProductNotFound
	}
	skus := m.getSkusForProductLocked(workspaceID, productID)
	skuSet := make(map[string]bool, len(skus))
	var lowStockCount int32
	for _, s := range skus {
		skuSet[s.SkuID] = true
		if s.IsActive && s.StockQuantity <= s.LowStockThreshold {
			lowStockCount++
		}
	}
	var mvCount int32
	for _, mv := range m.movements {
		if mv.WorkspaceID == workspaceID && skuSet[mv.SkuID] {
			mvCount++
		}
	}
	zero, _ := tenantdb.ParseExactDecimal("0")
	curr := p.Currency
	if curr == "" {
		curr = "VND"
	}
	return &ProductSalesSummary{
		ProductID:          productID,
		UnitsSold:          0,
		GrossRevenue:       zero,
		NetRevenue:         zero,
		TotalCOGS:          zero,
		TotalProfit:        zero,
		Currency:           curr,
		StockMovements:     mvCount,
		LowStockAlertCount: lowStockCount,
	}, nil
}

func (m *MemoryStore) GetProductSalesChart(_ context.Context, workspaceID, productID string, _ int) ([]SalesChartDataPoint, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrProductNotFound
	}
	return []SalesChartDataPoint{}, nil
}

func (m *MemoryStore) GetProductRank(_ context.Context, workspaceID, productID string) (*ProductRankSummary, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	target, exists := m.products[productID]
	if !exists || target.WorkspaceID != workspaceID || target.DeletedAt != nil {
		return nil, ErrProductNotFound
	}
	var allWs []*Product
	for _, p := range m.products {
		if p.WorkspaceID == workspaceID && p.DeletedAt == nil {
			allWs = append(allWs, p)
		}
	}
	sort.Slice(allWs, func(i, j int) bool {
		if !allWs[i].CreatedAt.Equal(allWs[j].CreatedAt) {
			return allWs[i].CreatedAt.Before(allWs[j].CreatedAt)
		}
		return allWs[i].ProductID < allWs[j].ProductID
	})
	var wsRank, catRank int32
	var catIdx int32
	for idx, p := range allWs {
		if strings.EqualFold(p.Category, target.Category) {
			catIdx++
		}
		if p.ProductID == productID {
			wsRank = int32(idx + 1)
			catRank = catIdx
			break
		}
	}
	if wsRank == 0 {
		wsRank = 1
	}
	if catRank == 0 {
		catRank = 1
	}
	return &ProductRankSummary{
		WorkspaceRank: wsRank,
		CategoryRank:  catRank,
	}, nil
}

// Helpers for deep copying memory store entries
func cloneProduct(p *Product) *Product {
	if p == nil {
		return nil
	}
	cp := *p
	if p.BasePrice != nil {
		bp := *p.BasePrice
		cp.BasePrice = &bp
	}
	if p.COGS != nil {
		cg := *p.COGS
		cp.COGS = &cg
	}
	if p.ExternalRefs != nil {
		cp.ExternalRefs = make([]ExternalRef, len(p.ExternalRefs))
		copy(cp.ExternalRefs, p.ExternalRefs)
	}
	if p.Images != nil {
		cp.Images = make([]string, len(p.Images))
		copy(cp.Images, p.Images)
	}
	if p.Metadata != nil {
		cp.Metadata = make(map[string]any, len(p.Metadata))
		for k, v := range p.Metadata {
			cp.Metadata[k] = v
		}
	}
	return &cp
}

func cloneSku(s *ProductSku) *ProductSku {
	if s == nil {
		return nil
	}
	cp := *s
	if s.PriceOverride != nil {
		po := *s.PriceOverride
		cp.PriceOverride = &po
	}
	if s.CogsOverride != nil {
		co := *s.CogsOverride
		cp.CogsOverride = &co
	}
	if s.VariantAttributes != nil {
		cp.VariantAttributes = make(map[string]string, len(s.VariantAttributes))
		for k, v := range s.VariantAttributes {
			cp.VariantAttributes[k] = v
		}
	}
	if s.ExternalRefs != nil {
		cp.ExternalRefs = make([]ExternalRef, len(s.ExternalRefs))
		copy(cp.ExternalRefs, s.ExternalRefs)
	}
	return &cp
}

// ============================================================================
// PostgresStore implementation
// ============================================================================

type DBTX interface {
	Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error)
	Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error)
	QueryRow(ctx context.Context, sql string, args ...any) pgx.Row
}

type PostgresStore struct {
	pool *pgxpool.Pool
	db   DBTX
}

func NewPostgresStore(pool *pgxpool.Pool) *PostgresStore {
	return &PostgresStore{pool: pool, db: pool}
}

func NewPostgresStoreTx(db DBTX) *PostgresStore {
	return &PostgresStore{pool: nil, db: db}
}

func (s *PostgresStore) CreateProduct(ctx context.Context, p *Product) error {
	extJSON, err := json.Marshal(p.ExternalRefs)
	if err != nil {
		return fmt.Errorf("marshal external_refs: %w", err)
	}
	imgJSON, err := json.Marshal(p.Images)
	if err != nil {
		return fmt.Errorf("marshal images: %w", err)
	}
	metaJSON, err := json.Marshal(p.Metadata)
	if err != nil {
		return fmt.Errorf("marshal metadata: %w", err)
	}

	var basePriceStr *string
	if p.BasePrice != nil {
		str := p.BasePrice.String()
		basePriceStr = &str
	}
	var cogsStr *string
	if p.COGS != nil {
		str := p.COGS.String()
		cogsStr = &str
	}

	query := `
		INSERT INTO products (
			product_id, workspace_id, product_type, title, description,
			category, base_price, currency, cogs, catalog_status,
			inventory_enabled, external_refs, images, metadata, created_at, updated_at
		) VALUES (
			$1::uuid, $2::uuid, $3, $4, $5,
			$6, $7::numeric(18,6), $8, $9::numeric(18,6), $10,
			$11, $12::jsonb, $13::jsonb, $14::jsonb, $15, $16
		)
	`
	_, err = s.db.Exec(ctx, query,
		p.ProductID, p.WorkspaceID, p.ProductType, p.Title, p.Description,
		p.Category, basePriceStr, p.Currency, cogsStr, p.CatalogStatus,
		p.InventoryEnabled, extJSON, imgJSON, metaJSON, p.CreatedAt, p.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("insert product: %w", err)
	}

	for _, sku := range p.SKUs {
		sku.ProductID = p.ProductID
		sku.WorkspaceID = p.WorkspaceID
		if err := s.CreateSku(ctx, &sku); err != nil {
			return err
		}
	}
	return nil
}

func (s *PostgresStore) GetProduct(ctx context.Context, workspaceID, productID string) (*Product, error) {
	query := `
		SELECT product_id, workspace_id, product_type, title, description,
		       category, base_price, currency, cogs, catalog_status,
		       inventory_enabled, external_refs, images, metadata, created_at, updated_at, deleted_at
		FROM products
		WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL
	`
	row := s.db.QueryRow(ctx, query, workspaceID, productID)
	p, err := scanProduct(row)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrProductNotFound
		}
		return nil, err
	}
	skus, err := s.ListSkusByProduct(ctx, workspaceID, productID)
	if err != nil {
		return nil, err
	}
	p.SKUs = skus
	return p, nil
}

func (s *PostgresStore) ListProducts(ctx context.Context, workspaceID string, filter ListFilter, limit, offset int) ([]*Product, int64, error) {
	if offset < 0 {
		return nil, 0, fmt.Errorf("%w: offset cannot be negative", ErrInvalidInput)
	}
	baseQuery := `
		FROM products
		WHERE workspace_id = $1::uuid AND deleted_at IS NULL
	`
	args := []any{workspaceID}
	argIdx := 2

	if filter.Status != "" {
		baseQuery += fmt.Sprintf(" AND catalog_status = $%d", argIdx)
		args = append(args, filter.Status)
		argIdx++
	}
	if filter.Type != "" {
		baseQuery += fmt.Sprintf(" AND product_type = $%d", argIdx)
		args = append(args, filter.Type)
		argIdx++
	}
	if filter.Category != "" {
		baseQuery += fmt.Sprintf(" AND category = $%d", argIdx)
		args = append(args, filter.Category)
		argIdx++
	}
	if filter.SearchQuery != "" {
		baseQuery += fmt.Sprintf(" AND (title ILIKE $%d OR description ILIKE $%d)", argIdx, argIdx)
		args = append(args, "%"+filter.SearchQuery+"%")
		argIdx++
	}

	var total int64
	countQuery := "SELECT COUNT(*) " + baseQuery
	if err := s.db.QueryRow(ctx, countQuery, args...).Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count products: %w", err)
	}

	if filter.CursorCreatedAt != nil && filter.CursorProductID != "" {
		baseQuery += fmt.Sprintf(" AND (created_at < $%d::timestamptz OR (created_at = $%d::timestamptz AND product_id < $%d::uuid))", argIdx, argIdx, argIdx+1)
		args = append(args, filter.CursorCreatedAt.UTC(), filter.CursorProductID)
		argIdx += 2
		offset = 0
	}

	selectQuery := fmt.Sprintf(`
		SELECT product_id, workspace_id, product_type, title, description,
		       category, base_price, currency, cogs, catalog_status,
		       inventory_enabled, external_refs, images, metadata, created_at, updated_at, deleted_at
		%s
		ORDER BY created_at DESC, product_id DESC
		LIMIT $%d OFFSET $%d
	`, baseQuery, argIdx, argIdx+1)
	args = append(args, limit, offset)

	rows, err := s.db.Query(ctx, selectQuery, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("query products: %w", err)
	}
	defer rows.Close()

	var products []*Product
	for rows.Next() {
		p, err := scanProduct(rows)
		if err != nil {
			return nil, 0, err
		}
		products = append(products, p)
	}
	if err := rows.Err(); err != nil {
		return nil, 0, err
	}
	for _, p := range products {
		skus, err := s.ListSkusByProduct(ctx, workspaceID, p.ProductID)
		if err != nil {
			return nil, 0, err
		}
		p.SKUs = skus
	}
	return products, total, nil
}

func (s *PostgresStore) UpdateProduct(ctx context.Context, p *Product) error {
	extJSON, err := json.Marshal(p.ExternalRefs)
	if err != nil {
		return fmt.Errorf("marshal external_refs: %w", err)
	}
	imgJSON, err := json.Marshal(p.Images)
	if err != nil {
		return fmt.Errorf("marshal images: %w", err)
	}
	metaJSON, err := json.Marshal(p.Metadata)
	if err != nil {
		return fmt.Errorf("marshal metadata: %w", err)
	}

	var basePriceStr *string
	if p.BasePrice != nil {
		str := p.BasePrice.String()
		basePriceStr = &str
	}
	var cogsStr *string
	if p.COGS != nil {
		str := p.COGS.String()
		cogsStr = &str
	}

	if p.ExpectedUpdatedAt != nil {
		query := `
			UPDATE products
			SET title = $1, description = $2, category = $3,
			    base_price = $4::numeric(18,6), currency = $5, cogs = $6::numeric(18,6),
			    catalog_status = $7, inventory_enabled = $8, external_refs = $9::jsonb,
			    images = $10::jsonb, metadata = $11::jsonb,
			    updated_at = CASE WHEN $12::timestamptz > updated_at THEN $12::timestamptz ELSE updated_at + interval '1 microsecond' END
			WHERE workspace_id = $13::uuid AND product_id = $14::uuid AND deleted_at IS NULL
			  AND date_trunc('microseconds', updated_at) = date_trunc('microseconds', $15::timestamptz)
			RETURNING updated_at
		`
		var newUpdatedAt time.Time
		err = s.db.QueryRow(ctx, query,
			p.Title, p.Description, p.Category,
			basePriceStr, p.Currency, cogsStr,
			p.CatalogStatus, p.InventoryEnabled, extJSON,
			imgJSON, metaJSON, p.UpdatedAt.UTC(),
			p.WorkspaceID, p.ProductID, p.ExpectedUpdatedAt.UTC(),
		).Scan(&newUpdatedAt)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				var exists bool
				checkErr := s.db.QueryRow(ctx,
					`SELECT EXISTS(SELECT 1 FROM products WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL)`,
					p.WorkspaceID, p.ProductID,
				).Scan(&exists)
				if checkErr == nil && exists {
					return ErrConcurrencyConflict
				}
				return ErrProductNotFound
			}
			return fmt.Errorf("update product: %w", err)
		}
		p.UpdatedAt = newUpdatedAt.UTC()
		return nil
	}

	query := `
		UPDATE products
		SET title = $1, description = $2, category = $3,
		    base_price = $4::numeric(18,6), currency = $5, cogs = $6::numeric(18,6),
		    catalog_status = $7, inventory_enabled = $8, external_refs = $9::jsonb,
		    images = $10::jsonb, metadata = $11::jsonb,
		    updated_at = CASE WHEN $12::timestamptz > updated_at THEN $12::timestamptz ELSE updated_at + interval '1 microsecond' END
		WHERE workspace_id = $13::uuid AND product_id = $14::uuid AND deleted_at IS NULL
		RETURNING updated_at
	`
	var newUpdatedAt time.Time
	err = s.db.QueryRow(ctx, query,
		p.Title, p.Description, p.Category,
		basePriceStr, p.Currency, cogsStr,
		p.CatalogStatus, p.InventoryEnabled, extJSON,
		imgJSON, metaJSON, p.UpdatedAt.UTC(),
		p.WorkspaceID, p.ProductID,
	).Scan(&newUpdatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrProductNotFound
		}
		return fmt.Errorf("update product: %w", err)
	}
	p.UpdatedAt = newUpdatedAt.UTC()
	return nil
}

func (s *PostgresStore) DeleteProduct(ctx context.Context, workspaceID, productID string) error {
	now := time.Now().UTC()
	query := `
		UPDATE products
		SET deleted_at = $1
		WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL
	`
	tag, err := s.db.Exec(ctx, query, now, workspaceID, productID)
	if err != nil {
		return fmt.Errorf("delete product: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrProductNotFound
	}
	// Also soft-delete associated SKUs
	_, _ = s.db.Exec(ctx, `UPDATE product_skus SET deleted_at = $1 WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL`, now, workspaceID, productID)
	return nil
}

func (s *PostgresStore) ArchiveProduct(ctx context.Context, workspaceID, productID string) error {
	now := time.Now().UTC()
	query := `
		UPDATE products
		SET catalog_status = 'archived', updated_at = $1
		WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL
	`
	tag, err := s.db.Exec(ctx, query, now, workspaceID, productID)
	if err != nil {
		return fmt.Errorf("archive product: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrProductNotFound
	}
	return nil
}

func (s *PostgresStore) BulkArchiveProducts(ctx context.Context, workspaceID string, productIDs []string) (int, error) {
	now := time.Now().UTC()
	query := `
		UPDATE products
		SET catalog_status = 'archived', updated_at = $1
		WHERE workspace_id = $2::uuid AND product_id = ANY($3::uuid[]) AND deleted_at IS NULL
	`
	tag, err := s.db.Exec(ctx, query, now, workspaceID, productIDs)
	if err != nil {
		return 0, fmt.Errorf("bulk archive products: %w", err)
	}
	return int(tag.RowsAffected()), nil
}

func (s *PostgresStore) FindProductByExternalID(ctx context.Context, workspaceID, platform, externalID, connectedAccountID string) (*Product, error) {
	query := `
		SELECT product_id, workspace_id, product_type, title, description,
		       category, base_price, currency, cogs, catalog_status,
		       inventory_enabled, external_refs, images, metadata, created_at, updated_at, deleted_at
		FROM products
		WHERE workspace_id = $1::uuid AND deleted_at IS NULL
		  AND external_refs @> $2::jsonb
		LIMIT 1
	`
	matchObj := map[string]string{
		"platform":    platform,
		"external_id": externalID,
	}
	if connectedAccountID != "" {
		matchObj["connected_account_id"] = connectedAccountID
	}
	matchJSON, _ := json.Marshal([]map[string]string{matchObj})

	row := s.db.QueryRow(ctx, query, workspaceID, matchJSON)
	p, err := scanProduct(row)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrProductNotFound
		}
		return nil, err
	}
	skus, err := s.ListSkusByProduct(ctx, workspaceID, p.ProductID)
	if err != nil {
		return nil, err
	}
	p.SKUs = skus
	return p, nil
}

func (s *PostgresStore) CreateSku(ctx context.Context, sku *ProductSku) error {
	varAttrJSON, err := json.Marshal(sku.VariantAttributes)
	if err != nil {
		return fmt.Errorf("marshal variant_attributes: %w", err)
	}
	extJSON, err := json.Marshal(sku.ExternalRefs)
	if err != nil {
		return fmt.Errorf("marshal external_refs: %w", err)
	}

	var priceStr, cogsStr *string
	if sku.PriceOverride != nil {
		str := sku.PriceOverride.String()
		priceStr = &str
	}
	if sku.CogsOverride != nil {
		str := sku.CogsOverride.String()
		cogsStr = &str
	}

	query := `
		INSERT INTO product_skus (
			sku_id, workspace_id, product_id, sku_code, variant_attributes,
			price_override, cogs_override, currency, stock_quantity, stock_reserved,
			low_stock_threshold, barcode, weight_grams, is_active, external_refs,
			created_at, updated_at
		) VALUES (
			$1::uuid, $2::uuid, $3::uuid, $4, $5::jsonb,
			$6::numeric(18,6), $7::numeric(18,6), $8, $9, $10,
			$11, $12, $13, $14, $15::jsonb,
			$16, $17
		)
	`
	_, err = s.db.Exec(ctx, query,
		sku.SkuID, sku.WorkspaceID, sku.ProductID, sku.SkuCode, varAttrJSON,
		priceStr, cogsStr, sku.Currency, sku.StockQuantity, sku.StockReserved,
		sku.LowStockThreshold, sku.Barcode, sku.WeightGrams, sku.IsActive, extJSON,
		sku.CreatedAt, sku.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("insert sku: %w", err)
	}
	return nil
}

func (s *PostgresStore) GetSku(ctx context.Context, workspaceID, skuID string) (*ProductSku, error) {
	query := `
		SELECT sku_id, workspace_id, product_id, sku_code, variant_attributes,
		       price_override, cogs_override, currency, stock_quantity, stock_reserved,
		       low_stock_threshold, barcode, weight_grams, is_active, external_refs,
		       created_at, updated_at, deleted_at
		FROM product_skus
		WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND deleted_at IS NULL
	`
	row := s.db.QueryRow(ctx, query, workspaceID, skuID)
	return scanSku(row)
}

func (s *PostgresStore) ListSkusByProduct(ctx context.Context, workspaceID, productID string) ([]ProductSku, error) {
	query := `
		SELECT sku_id, workspace_id, product_id, sku_code, variant_attributes,
		       price_override, cogs_override, currency, stock_quantity, stock_reserved,
		       low_stock_threshold, barcode, weight_grams, is_active, external_refs,
		       created_at, updated_at, deleted_at
		FROM product_skus
		WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL
		ORDER BY created_at ASC
	`
	rows, err := s.db.Query(ctx, query, workspaceID, productID)
	if err != nil {
		return nil, fmt.Errorf("query skus: %w", err)
	}
	defer rows.Close()

	var list []ProductSku
	for rows.Next() {
		sku, err := scanSku(rows)
		if err != nil {
			return nil, err
		}
		list = append(list, *sku)
	}
	return list, nil
}

func (s *PostgresStore) withTx(ctx context.Context, workspaceID string, fn func(db DBTX) error) error {
	if s.pool == nil {
		return fn(s.db)
	}
	tx, err := s.pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("begin tx: %w", err)
	}
	defer func() { _ = tx.Rollback(ctx) }()
	if _, err := tx.Exec(ctx, "SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_workspace_id', $1, true)", workspaceID); err != nil {
		return fmt.Errorf("set workspace rls context: %w", err)
	}
	if err := fn(tx); err != nil {
		return err
	}
	return tx.Commit(ctx)
}

func (s *PostgresStore) UpdateSkuStock(ctx context.Context, workspaceID, skuID string, delta int32) (int32, error) {
	if delta == 0 {
		return 0, fmt.Errorf("%w: stock delta cannot be zero", ErrInvalidInput)
	}
	meta, _ := StockAdjustmentMetaFromContext(ctx)
	reason := strings.TrimSpace(meta.Reason)
	if reason == "" {
		reason = "manual_adjustment"
	}
	movementKey := strings.TrimSpace(meta.MovementKey)
	if movementKey == "" {
		movementKey = "adj:" + newUUID()
	}

	var resultQty int32
	err := s.withTx(ctx, workspaceID, func(db DBTX) error {
		var existingSkuID string
		var existingQty int32
		var existingReason string
		err := db.QueryRow(ctx, `
			SELECT sku_id::text, quantity, COALESCE(reason, '')
			FROM stock_movements
			WHERE workspace_id = $1::uuid AND movement_key = $2
		`, workspaceID, movementKey).Scan(&existingSkuID, &existingQty, &existingReason)
		if err == nil {
			if existingSkuID != skuID || existingQty != delta || existingReason != reason {
				return ErrIdempotencyConflict
			}
			return db.QueryRow(ctx, `
				SELECT stock_quantity
				FROM product_skus
				WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND deleted_at IS NULL
			`, workspaceID, skuID).Scan(&resultQty)
		} else if !errors.Is(err, pgx.ErrNoRows) {
			return fmt.Errorf("check movement key: %w", err)
		}

		var currentQty, currentReserved int32
		err = db.QueryRow(ctx, `
			SELECT stock_quantity, stock_reserved
			FROM product_skus
			WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND deleted_at IS NULL
			FOR UPDATE
		`, workspaceID, skuID).Scan(&currentQty, &currentReserved)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrSkuNotFound
			}
			return fmt.Errorf("lock sku: %w", err)
		}

		newQty := currentQty + delta
		if newQty < 0 {
			return fmt.Errorf("%w: stock quantity cannot be negative", ErrInsufficientStock)
		}
		if newQty < currentReserved {
			return fmt.Errorf("%w: stock quantity (%d) cannot be less than reserved stock (%d)", ErrInsufficientStock, newQty, currentReserved)
		}

		var locationID string
		err = db.QueryRow(ctx, `
			SELECT location_id::text
			FROM inventory_locations
			WHERE workspace_id = $1::uuid AND status = 'active'
			ORDER BY is_default DESC, created_at ASC, location_id ASC
			LIMIT 1
		`, workspaceID).Scan(&locationID)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				err = db.QueryRow(ctx, `
					INSERT INTO inventory_locations (workspace_id, name, location_type, is_default, status)
					VALUES ($1::uuid, 'Default Warehouse', 'warehouse', true, 'active')
					RETURNING location_id::text
				`, workspaceID).Scan(&locationID)
				if err != nil {
					return fmt.Errorf("create default inventory location: %w", err)
				}
			} else {
				return fmt.Errorf("resolve inventory location: %w", err)
			}
		}

		var balOnHand, balReserved int32
		err = db.QueryRow(ctx, `
			SELECT on_hand, reserved
			FROM inventory_balances
			WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND location_id = $3::uuid
			FOR UPDATE
		`, workspaceID, skuID, locationID).Scan(&balOnHand, &balReserved)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				_, err = db.Exec(ctx, `
					INSERT INTO inventory_balances (workspace_id, sku_id, location_id, on_hand, reserved, updated_at)
					VALUES ($1::uuid, $2::uuid, $3::uuid, $4, $5, NOW())
				`, workspaceID, skuID, locationID, newQty, currentReserved)
				if err != nil {
					return fmt.Errorf("insert inventory balance: %w", err)
				}
			} else {
				return fmt.Errorf("lock inventory balance: %w", err)
			}
		} else {
			newBalOnHand := balOnHand + delta
			if newBalOnHand < 0 || newBalOnHand < balReserved {
				return fmt.Errorf("%w: location stock balance (%d) cannot be less than reserved (%d)", ErrInsufficientStock, newBalOnHand, balReserved)
			}
			_, err = db.Exec(ctx, `
				UPDATE inventory_balances
				SET on_hand = $4, updated_at = NOW()
				WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND location_id = $3::uuid
			`, workspaceID, skuID, locationID, newBalOnHand)
			if err != nil {
				return fmt.Errorf("update inventory balance: %w", err)
			}
		}

		_, err = db.Exec(ctx, `
			INSERT INTO stock_movements (
				movement_id, workspace_id, sku_id, location_id,
				movement_type, quantity, reason, movement_key, created_at
			) VALUES (
				$1::uuid, $2::uuid, $3::uuid, $4::uuid,
				'adjustment', $5, $6, $7, NOW()
			)
		`, newUUID(), workspaceID, skuID, locationID, delta, reason, movementKey)
		if err != nil {
			return fmt.Errorf("insert stock movement: %w", err)
		}

		err = db.QueryRow(ctx, `
			UPDATE product_skus
			SET stock_quantity = COALESCE((
				SELECT SUM(on_hand) FROM inventory_balances WHERE workspace_id = $1::uuid AND sku_id = $2::uuid
			), $3), updated_at = NOW()
			WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND deleted_at IS NULL
			RETURNING stock_quantity
		`, workspaceID, skuID, newQty).Scan(&resultQty)
		if err != nil {
			return fmt.Errorf("update sku stock_quantity: %w", err)
		}
		return nil
	})
	if err != nil {
		return 0, err
	}
	return resultQty, nil
}

func (s *PostgresStore) SetSkuAlertThreshold(ctx context.Context, workspaceID, skuID string, threshold int32) error {
	query := `
		UPDATE product_skus
		SET low_stock_threshold = $1, updated_at = NOW()
		WHERE workspace_id = $2::uuid AND sku_id = $3::uuid AND deleted_at IS NULL
	`
	tag, err := s.db.Exec(ctx, query, threshold, workspaceID, skuID)
	if err != nil {
		return fmt.Errorf("set alert threshold: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrSkuNotFound
	}
	return nil
}

func (s *PostgresStore) LinkContent(ctx context.Context, workspaceID, productID string, ref ContentRef) error {
	// Fetch product, update metadata["linked_content"] atomically
	p, err := s.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return err
	}
	prevUpdated := p.UpdatedAt
	p.ExpectedUpdatedAt = &prevUpdated
	p.PreviousCatalogStatus = p.CatalogStatus
	if p.Metadata == nil {
		p.Metadata = make(map[string]any)
	}
	var list []ContentRef
	if raw, ok := p.Metadata["linked_content"]; ok && raw != nil {
		if bytes, err := json.Marshal(raw); err == nil {
			_ = json.Unmarshal(bytes, &list)
		}
	}
	updated := false
	for i, existing := range list {
		if existing.ContentID == ref.ContentID {
			list[i] = ref
			updated = true
			break
		}
	}
	if !updated {
		list = append(list, ref)
	}
	p.Metadata["linked_content"] = list
	p.UpdatedAt = time.Now().UTC()
	return s.UpdateProduct(ctx, p)
}

func (s *PostgresStore) GetLinkedContent(ctx context.Context, workspaceID, productID string) ([]ContentRef, error) {
	p, err := s.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return nil, err
	}
	if p.Metadata == nil {
		return []ContentRef{}, nil
	}
	raw, ok := p.Metadata["linked_content"]
	if !ok || raw == nil {
		return []ContentRef{}, nil
	}
	bytes, err := json.Marshal(raw)
	if err != nil {
		return []ContentRef{}, nil
	}
	var list []ContentRef
	if err := json.Unmarshal(bytes, &list); err != nil {
		return []ContentRef{}, nil
	}
	return list, nil
}

func (s *PostgresStore) BatchTag(ctx context.Context, workspaceID string, productIDs []string, tagsToAdd []string, tagsToRemove []string) (int, error) {
	count := 0
	removeSet := make(map[string]bool)
	for _, t := range tagsToRemove {
		removeSet[t] = true
	}
	for _, pid := range productIDs {
		p, err := s.GetProduct(ctx, workspaceID, pid)
		if err != nil {
			continue
		}
		prevUpdated := p.UpdatedAt
		p.ExpectedUpdatedAt = &prevUpdated
		p.PreviousCatalogStatus = p.CatalogStatus
		if p.Metadata == nil {
			p.Metadata = make(map[string]any)
		}
		currentTags := make(map[string]bool)
		if rawTags, ok := p.Metadata["tags"].([]any); ok {
			for _, rt := range rawTags {
				if str, ok := rt.(string); ok {
					currentTags[str] = true
				}
			}
		}
		for _, add := range tagsToAdd {
			currentTags[add] = true
		}
		for rem := range removeSet {
			delete(currentTags, rem)
		}
		var tagList []string
		for t := range currentTags {
			tagList = append(tagList, t)
		}
		sort.Strings(tagList)
		p.Metadata["tags"] = tagList
		p.UpdatedAt = time.Now().UTC()
		if err := s.UpdateProduct(ctx, p); err == nil {
			count++
		}
	}
	return count, nil
}

func (s *PostgresStore) GetIdempotencyRecord(ctx context.Context, workspaceID, idempotencyKey string) (*IdempotencyRecord, error) {
	var rec IdempotencyRecord
	err := s.db.QueryRow(ctx, `
		SELECT workspace_id::text, idempotency_key, request_hash, COALESCE(response_code, 200), COALESCE(response_body, response_payload, '{}'::jsonb), created_at, expires_at
		FROM api_idempotency_records
		WHERE workspace_id = $1::uuid AND actor_id = $1::uuid AND rpc = 'product.mutation' AND idempotency_key = $2 AND expires_at > NOW()
	`, workspaceID, idempotencyKey).Scan(
		&rec.WorkspaceID, &rec.IdempotencyKey, &rec.RequestHash,
		&rec.ResponseStatus, &rec.ResponseBody, &rec.CreatedAt, &rec.ExpiresAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil
		}
		return nil, fmt.Errorf("get idempotency record: %w", err)
	}
	return &rec, nil
}

func (s *PostgresStore) SaveIdempotencyRecord(ctx context.Context, rec IdempotencyRecord) error {
	now := time.Now().UTC()
	createdAt := rec.CreatedAt
	if createdAt.IsZero() {
		createdAt = now
	}
	expiresAt := rec.ExpiresAt
	if expiresAt.IsZero() {
		expiresAt = createdAt.Add(24 * time.Hour)
	}
	bodyJSON := rec.ResponseBody
	if len(bodyJSON) == 0 {
		bodyJSON = []byte("{}")
	}
	statusCode := rec.ResponseStatus
	if statusCode == 0 {
		statusCode = 200
	}
	tag, err := s.db.Exec(ctx, `
		INSERT INTO api_idempotency_records (
			workspace_id, actor_id, rpc, idempotency_key,
			request_hash, status, response_code, response_body, response_payload, created_at, expires_at
		) VALUES (
			$1::uuid, $1::uuid, 'product.mutation', $2,
			$3, 'completed', $4, $5::jsonb, $5::jsonb, $6, $7
		)
		ON CONFLICT (workspace_id, actor_id, rpc, idempotency_key) DO UPDATE
		SET request_hash = EXCLUDED.request_hash,
		    response_code = EXCLUDED.response_code,
		    response_body = EXCLUDED.response_body,
		    response_payload = EXCLUDED.response_payload,
		    created_at = EXCLUDED.created_at,
		    expires_at = EXCLUDED.expires_at
		WHERE api_idempotency_records.expires_at <= NOW()
	`, rec.WorkspaceID, rec.IdempotencyKey, rec.RequestHash, statusCode, bodyJSON, createdAt, expiresAt)
	if err != nil {
		return fmt.Errorf("save idempotency record: %w", err)
	}
	if tag.RowsAffected() == 0 {
		var existingHash string
		err := s.db.QueryRow(ctx, `
			SELECT request_hash
			FROM api_idempotency_records
			WHERE workspace_id = $1::uuid AND actor_id = $1::uuid AND rpc = 'product.mutation' AND idempotency_key = $2
		`, rec.WorkspaceID, rec.IdempotencyKey).Scan(&existingHash)
		if err != nil {
			return fmt.Errorf("query existing idempotency record: %w", err)
		}
		if existingHash != rec.RequestHash {
			return ErrIdempotencyConflict
		}
	}
	return nil
}

func (s *PostgresStore) GetProductSalesSummary(ctx context.Context, workspaceID, productID string) (*ProductSalesSummary, error) {
	p, err := s.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return nil, err
	}

	var lowStockCount int32
	for _, sku := range p.SKUs {
		if sku.IsActive && sku.StockQuantity <= sku.LowStockThreshold {
			lowStockCount++
		}
	}

	var mvCount int32
	_ = s.db.QueryRow(ctx, `
		SELECT COUNT(*)::int4
		FROM stock_movements sm
		JOIN product_skus ps ON ps.workspace_id = sm.workspace_id AND ps.sku_id = sm.sku_id
		WHERE sm.workspace_id = $1::uuid AND ps.product_id = $2::uuid AND ps.deleted_at IS NULL
	`, workspaceID, productID).Scan(&mvCount)

	baseCogsStr := "0"
	if p.COGS != nil {
		baseCogsStr = p.COGS.String()
	}

	var orderCount, unitsSold, refundCount int32
	var grossStr, netStr, cogsStr string
	err = s.db.QueryRow(ctx, `
		WITH product_sku_keys AS (
			SELECT sku_id::text AS k
			FROM product_skus
			WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL
			UNION
			SELECT sku_code AS k
			FROM product_skus
			WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL
		),
		item_matches AS (
			SELECT
				o.order_id,
				COALESCE((li.val->>'quantity')::bigint, 0) AS qty,
				COALESCE(
					NULLIF(li.val->>'total', '')::numeric(18,6),
					COALESCE(NULLIF(li.val->>'unit_price', '')::numeric(18,6), 0) * COALESCE((li.val->>'quantity')::numeric(18,6), 0) - COALESCE(NULLIF(li.val->>'discount', '')::numeric(18,6), 0)
				) AS gross_rev,
				COALESCE(
					NULLIF(li.val->>'unit_cogs', '')::numeric(18,6),
					$3::numeric(18,6),
					0::numeric(18,6)
				) * COALESCE((li.val->>'quantity')::numeric(18,6), 0) AS item_cogs
			FROM orders o
			CROSS JOIN LATERAL jsonb_array_elements(COALESCE(o.items, '[]'::jsonb)) AS li(val)
			WHERE o.workspace_id = $1::uuid
			  AND o.deleted_at IS NULL
			  AND o.lifecycle_state NOT IN ('cancelled', 'refunded')
			  AND (
			      li.val->>'product_id' = $2::text
			      OR COALESCE(li.val->>'sku_id', li.val->>'sku') IN (SELECT k FROM product_sku_keys)
			  )
		),
		direct_order_matches AS (
			SELECT
				o.order_id,
				1::bigint AS qty,
				o.amount AS gross_rev,
				COALESCE($3::numeric(18,6), 0::numeric(18,6)) AS item_cogs
			FROM orders o
			WHERE o.workspace_id = $1::uuid
			  AND o.deleted_at IS NULL
			  AND o.lifecycle_state NOT IN ('cancelled', 'refunded')
			  AND o.product_id = $2::uuid
			  AND jsonb_array_length(COALESCE(o.items, '[]'::jsonb)) = 0
		),
		matched_items AS (
			SELECT * FROM item_matches
			UNION ALL
			SELECT * FROM direct_order_matches
		),
		order_refunds AS (
			SELECT
				COUNT(*)::int4 AS refund_cnt,
				COALESCE(SUM(r.amount), 0::numeric(18,6)) AS total_refunded
			FROM refunds r
			WHERE r.workspace_id = $1::uuid
			  AND r.deleted_at IS NULL
			  AND r.lifecycle_state = 'completed'
			  AND r.order_id IN (SELECT DISTINCT order_id FROM matched_items)
		)
		SELECT
			COUNT(DISTINCT m.order_id)::int4,
			COALESCE(SUM(m.qty), 0)::int4,
			COALESCE((SELECT refund_cnt FROM order_refunds), 0)::int4,
			COALESCE(SUM(m.gross_rev), 0::numeric(18,6))::numeric(18,6)::text,
			GREATEST(COALESCE(SUM(m.gross_rev), 0::numeric(18,6)) - COALESCE((SELECT total_refunded FROM order_refunds), 0::numeric(18,6)), 0::numeric(18,6))::numeric(18,6)::text,
			COALESCE(SUM(m.item_cogs), 0::numeric(18,6))::numeric(18,6)::text
		FROM matched_items m
	`, workspaceID, productID, baseCogsStr).Scan(&orderCount, &unitsSold, &refundCount, &grossStr, &netStr, &cogsStr)
	if err != nil {
		return nil, fmt.Errorf("query product sales summary: %w", err)
	}

	grossDec, _ := tenantdb.ParseExactDecimal(grossStr)
	netDec, _ := tenantdb.ParseExactDecimal(netStr)
	cogsDec, _ := tenantdb.ParseExactDecimal(cogsStr)
	profitDec, _ := netDec.Sub(cogsDec)

	curr := p.Currency
	if curr == "" {
		curr = "VND"
	}

	return &ProductSalesSummary{
		ProductID:          productID,
		OrderCount:         orderCount,
		UnitsSold:          unitsSold,
		RefundCount:        refundCount,
		GrossRevenue:       grossDec,
		NetRevenue:         netDec,
		TotalCOGS:          cogsDec,
		TotalProfit:        profitDec,
		Currency:           curr,
		StockMovements:     mvCount,
		LowStockAlertCount: lowStockCount,
	}, nil
}

func (s *PostgresStore) GetProductSalesChart(ctx context.Context, workspaceID, productID string, days int) ([]SalesChartDataPoint, error) {
	if _, err := s.GetProduct(ctx, workspaceID, productID); err != nil {
		return nil, err
	}
	if days <= 0 {
		days = 30
	}

	rows, err := s.db.Query(ctx, `
		WITH product_sku_keys AS (
			SELECT sku_id::text AS k
			FROM product_skus
			WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL
			UNION
			SELECT sku_code AS k
			FROM product_skus
			WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL
		),
		matched_rows AS (
			SELECT
				DATE_TRUNC('day', COALESCE(o.ordered_at, o.created_at)) AS bucket_day,
				COALESCE((li.val->>'quantity')::bigint, 0) AS qty,
				COALESCE(
					NULLIF(li.val->>'total', '')::numeric(18,6),
					COALESCE(NULLIF(li.val->>'unit_price', '')::numeric(18,6), 0) * COALESCE((li.val->>'quantity')::numeric(18,6), 0) - COALESCE(NULLIF(li.val->>'discount', '')::numeric(18,6), 0)
				) AS rev
			FROM orders o
			CROSS JOIN LATERAL jsonb_array_elements(COALESCE(o.items, '[]'::jsonb)) AS li(val)
			WHERE o.workspace_id = $1::uuid
			  AND o.deleted_at IS NULL
			  AND o.lifecycle_state NOT IN ('cancelled', 'refunded')
			  AND COALESCE(o.ordered_at, o.created_at) >= NOW() - ($3::int * interval '1 day')
			  AND (
			      li.val->>'product_id' = $2::text
			      OR COALESCE(li.val->>'sku_id', li.val->>'sku') IN (SELECT k FROM product_sku_keys)
			  )
			UNION ALL
			SELECT
				DATE_TRUNC('day', COALESCE(o.ordered_at, o.created_at)) AS bucket_day,
				1::bigint AS qty,
				o.amount AS rev
			FROM orders o
			WHERE o.workspace_id = $1::uuid
			  AND o.deleted_at IS NULL
			  AND o.lifecycle_state NOT IN ('cancelled', 'refunded')
			  AND COALESCE(o.ordered_at, o.created_at) >= NOW() - ($3::int * interval '1 day')
			  AND o.product_id = $2::uuid
			  AND jsonb_array_length(COALESCE(o.items, '[]'::jsonb)) = 0
		)
		SELECT
			bucket_day,
			COALESCE(SUM(qty), 0)::int4 AS units_sold,
			COALESCE(SUM(rev), 0::numeric(18,6))::numeric(18,6)::text AS revenue
		FROM matched_rows
		GROUP BY bucket_day
		ORDER BY bucket_day ASC
	`, workspaceID, productID, days)
	if err != nil {
		return nil, fmt.Errorf("query product sales chart: %w", err)
	}
	defer rows.Close()

	var points []SalesChartDataPoint
	for rows.Next() {
		var pt SalesChartDataPoint
		var revStr string
		if err := rows.Scan(&pt.Date, &pt.UnitsSold, &revStr); err != nil {
			return nil, err
		}
		pt.Revenue, _ = tenantdb.ParseExactDecimal(revStr)
		points = append(points, pt)
	}
	return points, rows.Err()
}

func (s *PostgresStore) GetProductRank(ctx context.Context, workspaceID, productID string) (*ProductRankSummary, error) {
	if _, err := s.GetProduct(ctx, workspaceID, productID); err != nil {
		return nil, err
	}

	var wsRank, catRank int32
	err := s.db.QueryRow(ctx, `
		WITH sku_map AS (
			SELECT product_id, sku_id::text AS k
			FROM product_skus
			WHERE workspace_id = $1::uuid AND deleted_at IS NULL
			UNION
			SELECT product_id, sku_code AS k
			FROM product_skus
			WHERE workspace_id = $1::uuid AND deleted_at IS NULL
		),
		order_lines AS (
			SELECT
				li.val->>'product_id' AS line_product_id,
				COALESCE(li.val->>'sku_id', li.val->>'sku') AS line_sku,
				COALESCE((li.val->>'quantity')::bigint, 0) AS qty,
				COALESCE(
					NULLIF(li.val->>'total', '')::numeric(18,6),
					COALESCE(NULLIF(li.val->>'unit_price', '')::numeric(18,6), 0) * COALESCE((li.val->>'quantity')::numeric(18,6), 0) - COALESCE(NULLIF(li.val->>'discount', '')::numeric(18,6), 0)
				) AS rev
			FROM orders o
			CROSS JOIN LATERAL jsonb_array_elements(COALESCE(o.items, '[]'::jsonb)) AS li(val)
			WHERE o.workspace_id = $1::uuid
			  AND o.deleted_at IS NULL
			  AND o.lifecycle_state NOT IN ('cancelled', 'refunded')
			UNION ALL
			SELECT
				o.product_id::text AS line_product_id,
				'' AS line_sku,
				1::bigint AS qty,
				o.amount AS rev
			FROM orders o
			WHERE o.workspace_id = $1::uuid
			  AND o.deleted_at IS NULL
			  AND o.lifecycle_state NOT IN ('cancelled', 'refunded')
			  AND o.product_id IS NOT NULL
			  AND jsonb_array_length(COALESCE(o.items, '[]'::jsonb)) = 0
		),
		product_perf AS (
			SELECT
				p.product_id,
				COALESCE(p.category, '') AS category,
				p.created_at,
				COALESCE(SUM(ol.qty), 0) AS units_sold,
				COALESCE(SUM(ol.rev), 0::numeric(18,6)) AS gross_rev
			FROM products p
			LEFT JOIN order_lines ol
			  ON ol.line_product_id = p.product_id::text
			  OR EXISTS (
			      SELECT 1 FROM sku_map sm
			      WHERE sm.product_id = p.product_id AND sm.k = ol.line_sku
			  )
			WHERE p.workspace_id = $1::uuid AND p.deleted_at IS NULL
			GROUP BY p.product_id, p.category, p.created_at
		),
		ranked AS (
			SELECT
				product_id,
				RANK() OVER (ORDER BY units_sold DESC, gross_rev DESC, created_at ASC, product_id ASC)::int4 AS ws_rank,
				RANK() OVER (PARTITION BY LOWER(category) ORDER BY units_sold DESC, gross_rev DESC, created_at ASC, product_id ASC)::int4 AS cat_rank
			FROM product_perf
		)
		SELECT ws_rank, cat_rank
		FROM ranked
		WHERE product_id = $2::uuid
	`, workspaceID, productID).Scan(&wsRank, &catRank)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrProductNotFound
		}
		return nil, fmt.Errorf("query product rank: %w", err)
	}
	return &ProductRankSummary{
		WorkspaceRank: wsRank,
		CategoryRank:  catRank,
	}, nil
}

type rowScanner interface {
	Scan(dest ...any) error
}

func scanProduct(scanner rowScanner) (*Product, error) {
	var (
		p            Product
		basePriceStr *string
		cogsStr      *string
		extRefsJSON  []byte
		imagesJSON   []byte
		metadataJSON []byte
	)
	err := scanner.Scan(
		&p.ProductID, &p.WorkspaceID, &p.ProductType, &p.Title, &p.Description,
		&p.Category, &basePriceStr, &p.Currency, &cogsStr, &p.CatalogStatus,
		&p.InventoryEnabled, &extRefsJSON, &imagesJSON, &metadataJSON,
		&p.CreatedAt, &p.UpdatedAt, &p.DeletedAt,
	)
	if err != nil {
		return nil, err
	}
	if basePriceStr != nil {
		if dec, err := tenantdb.ParseExactDecimal(*basePriceStr); err == nil {
			p.BasePrice = &dec
		}
	}
	if cogsStr != nil {
		if dec, err := tenantdb.ParseExactDecimal(*cogsStr); err == nil {
			p.COGS = &dec
		}
	}
	if len(extRefsJSON) > 0 {
		_ = json.Unmarshal(extRefsJSON, &p.ExternalRefs)
	}
	if len(imagesJSON) > 0 {
		_ = json.Unmarshal(imagesJSON, &p.Images)
	}
	if len(metadataJSON) > 0 {
		_ = json.Unmarshal(metadataJSON, &p.Metadata)
	}
	return &p, nil
}

func scanSku(scanner rowScanner) (*ProductSku, error) {
	var (
		s           ProductSku
		priceStr    *string
		cogsStr     *string
		varAttrJSON []byte
		extRefsJSON []byte
	)
	err := scanner.Scan(
		&s.SkuID, &s.WorkspaceID, &s.ProductID, &s.SkuCode, &varAttrJSON,
		&priceStr, &cogsStr, &s.Currency, &s.StockQuantity, &s.StockReserved,
		&s.LowStockThreshold, &s.Barcode, &s.WeightGrams, &s.IsActive, &extRefsJSON,
		&s.CreatedAt, &s.UpdatedAt, &s.DeletedAt,
	)
	if err != nil {
		return nil, err
	}
	if priceStr != nil {
		if dec, err := tenantdb.ParseExactDecimal(*priceStr); err == nil {
			s.PriceOverride = &dec
		}
	}
	if cogsStr != nil {
		if dec, err := tenantdb.ParseExactDecimal(*cogsStr); err == nil {
			s.CogsOverride = &dec
		}
	}
	if len(varAttrJSON) > 0 {
		_ = json.Unmarshal(varAttrJSON, &s.VariantAttributes)
	}
	if len(extRefsJSON) > 0 {
		_ = json.Unmarshal(extRefsJSON, &s.ExternalRefs)
	}
	return &s, nil
}

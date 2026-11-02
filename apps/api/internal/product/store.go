package product

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
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
}

type MemoryStore struct {
	mu       sync.RWMutex
	products map[string]*Product    // key: productID
	skus     map[string]*ProductSku // key: skuID
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		products: make(map[string]*Product),
		skus:     make(map[string]*ProductSku),
	}
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
	return list
}

func (m *MemoryStore) ListProducts(_ context.Context, workspaceID string, filter ListFilter, limit, offset int) ([]*Product, int64, error) {
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

	total := int64(len(matched))
	if offset > len(matched) {
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
	cp := cloneProduct(p)
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
	p.UpdatedAt = time.Now().UTC()
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
			p.UpdatedAt = now
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

func (m *MemoryStore) UpdateSkuStock(_ context.Context, workspaceID, skuID string, delta int32) (int32, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	s, exists := m.skus[skuID]
	if !exists || s.WorkspaceID != workspaceID || s.DeletedAt != nil {
		return 0, ErrSkuNotFound
	}
	newQty := s.StockQuantity + delta
	if newQty < 0 {
		return s.StockQuantity, fmt.Errorf("%w: stock quantity cannot be negative", ErrInvalidInput)
	}
	s.StockQuantity = newQty
	s.UpdatedAt = time.Now().UTC()
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
	// Check if already linked
	for i, existing := range list {
		if existing.ContentID == ref.ContentID {
			list[i] = ref // Update
			p.Metadata["linked_content"] = list
			p.UpdatedAt = time.Now().UTC()
			return nil
		}
	}
	list = append(list, ref)
	p.Metadata["linked_content"] = list
	p.UpdatedAt = time.Now().UTC()
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
		p.Metadata["tags"] = tagList
		p.UpdatedAt = time.Now().UTC()
		count++
	}
	return count, nil
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

	selectQuery := fmt.Sprintf(`
		SELECT product_id, workspace_id, product_type, title, description,
		       category, base_price, currency, cogs, catalog_status,
		       inventory_enabled, external_refs, images, metadata, created_at, updated_at, deleted_at
		%s
		ORDER BY created_at DESC
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

	query := `
		UPDATE products
		SET title = $1, description = $2, category = $3,
		    base_price = $4::numeric(18,6), currency = $5, cogs = $6::numeric(18,6),
		    catalog_status = $7, inventory_enabled = $8, external_refs = $9::jsonb,
		    images = $10::jsonb, metadata = $11::jsonb, updated_at = $12
		WHERE workspace_id = $13::uuid AND product_id = $14::uuid AND deleted_at IS NULL
	`
	tag, err := s.db.Exec(ctx, query,
		p.Title, p.Description, p.Category,
		basePriceStr, p.Currency, cogsStr,
		p.CatalogStatus, p.InventoryEnabled, extJSON,
		imgJSON, metaJSON, p.UpdatedAt,
		p.WorkspaceID, p.ProductID,
	)
	if err != nil {
		return fmt.Errorf("update product: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrProductNotFound
	}
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

func (s *PostgresStore) UpdateSkuStock(ctx context.Context, workspaceID, skuID string, delta int32) (int32, error) {
	query := `
		UPDATE product_skus
		SET stock_quantity = stock_quantity + $1, updated_at = NOW()
		WHERE workspace_id = $2::uuid AND sku_id = $3::uuid AND deleted_at IS NULL
		  AND stock_quantity + $1 >= 0
		RETURNING stock_quantity
	`
	var newQty int32
	err := s.db.QueryRow(ctx, query, delta, workspaceID, skuID).Scan(&newQty)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return 0, fmt.Errorf("%w: invalid sku or insufficient stock", ErrInvalidInput)
		}
		return 0, fmt.Errorf("update stock: %w", err)
	}
	return newQty, nil
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
	for _, pid := range productIDs {
		p, err := s.GetProduct(ctx, workspaceID, pid)
		if err != nil {
			continue
		}
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
		for _, rem := range tagsToRemove {
			delete(currentTags, rem)
		}
		var tagList []string
		for t := range currentTags {
			tagList = append(tagList, t)
		}
		p.Metadata["tags"] = tagList
		p.UpdatedAt = time.Now().UTC()
		if err := s.UpdateProduct(ctx, p); err == nil {
			count++
		}
	}
	return count, nil
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

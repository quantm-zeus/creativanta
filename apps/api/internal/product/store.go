package product

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"math/big"
	"reflect"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"time"
	"unsafe"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
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

type locationBalance struct {
	OnHand   int32
	Reserved int32
}

type MemoryStore struct {
	mu               sync.RWMutex
	products         map[string]*Product                   // key: productID
	skus             map[string]*ProductSku                // key: skuID
	balances         map[string]map[string]locationBalance // key: workspaceID+":"+skuID -> locationID -> balance
	defaultLocations map[string]string                     // key: workspaceID -> locationID
	movements        []StockMovementRecord                 // append-only ledger
	idempotency      map[string]IdempotencyRecord          // key: workspaceID + ":" + idempotencyKey
	orders           []AnalyticsOrder
	refunds          []AnalyticsRefund
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		products:         make(map[string]*Product),
		skus:             make(map[string]*ProductSku),
		balances:         make(map[string]map[string]locationBalance),
		defaultLocations: make(map[string]string),
		idempotency:      make(map[string]IdempotencyRecord),
	}
}

func (m *MemoryStore) defaultLocationLocked(workspaceID string) string {
	if loc, ok := m.defaultLocations[workspaceID]; ok && loc != "" {
		return loc
	}
	return "default-loc-" + workspaceID
}

func (m *MemoryStore) SetDefaultLocation(workspaceID, locationID string) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if m.defaultLocations == nil {
		m.defaultLocations = make(map[string]string)
	}
	m.defaultLocations[workspaceID] = strings.TrimSpace(locationID)
}

func (m *MemoryStore) SetLocationBalance(workspaceID, skuID, locationID string, onHand, reserved int32) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if m.balances == nil {
		m.balances = make(map[string]map[string]locationBalance)
	}
	skuKey := workspaceID + ":" + skuID
	if m.balances[skuKey] == nil {
		m.balances[skuKey] = make(map[string]locationBalance)
	}
	prev := m.balances[skuKey][locationID]
	m.balances[skuKey][locationID] = locationBalance{OnHand: onHand, Reserved: reserved}
	delta := onHand - prev.OnHand
	if delta != 0 {
		m.movements = append(m.movements, StockMovementRecord{
			MovementID:   newUUID(),
			WorkspaceID:  workspaceID,
			SkuID:        skuID,
			LocationID:   locationID,
			MovementType: "opening_balance",
			Quantity:     delta,
			Reason:       "opening_balance",
			MovementKey:  fmt.Sprintf("opening:%s:%s:%d", skuID, locationID, len(m.movements)+1),
			CreatedAt:    time.Now().UTC(),
		})
	}
	if s, ok := m.skus[skuID]; ok && s.WorkspaceID == workspaceID {
		var sumOnHand, sumReserved int32
		for _, bal := range m.balances[skuKey] {
			sumOnHand += bal.OnHand
			sumReserved += bal.Reserved
		}
		s.StockQuantity = sumOnHand
		s.StockReserved = sumReserved
	}
}

func (m *MemoryStore) GetLocationBalance(workspaceID, skuID, locationID string) (int32, int32) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	skuKey := workspaceID + ":" + skuID
	if locMap, ok := m.balances[skuKey]; ok {
		if bal, exists := locMap[locationID]; exists {
			return bal.OnHand, bal.Reserved
		}
	}
	return 0, 0
}

func (m *MemoryStore) SeedOrder(ord AnalyticsOrder) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if ord.OrderID == "" {
		ord.OrderID = newUUID()
	}
	if ord.OrderedAt.IsZero() {
		ord.OrderedAt = time.Now().UTC()
	}
	if ord.LifecycleState == "" {
		ord.LifecycleState = "completed"
	}
	for i := range m.orders {
		if m.orders[i].WorkspaceID == ord.WorkspaceID && m.orders[i].OrderID == ord.OrderID {
			m.orders[i] = ord
			return
		}
	}
	m.orders = append(m.orders, ord)
}

func (m *MemoryStore) SeedRefund(ref AnalyticsRefund) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if ref.RefundID == "" {
		ref.RefundID = newUUID()
	}
	if ref.CreatedAt.IsZero() {
		ref.CreatedAt = time.Now().UTC()
	}
	if ref.LifecycleState == "" {
		ref.LifecycleState = "completed"
	}
	for i := range m.refunds {
		if m.refunds[i].WorkspaceID == ref.WorkspaceID && m.refunds[i].RefundID == ref.RefundID {
			m.refunds[i] = ref
			return
		}
	}
	m.refunds = append(m.refunds, ref)
}

func (m *MemoryStore) seedOpeningSkuLocked(sku *ProductSku) {
	if sku == nil || (sku.StockQuantity == 0 && sku.StockReserved == 0) {
		return
	}
	if m.balances == nil {
		m.balances = make(map[string]map[string]locationBalance)
	}
	skuKey := sku.WorkspaceID + ":" + sku.SkuID
	if m.balances[skuKey] == nil {
		m.balances[skuKey] = make(map[string]locationBalance)
	}
	locID := m.defaultLocationLocked(sku.WorkspaceID)
	m.balances[skuKey][locID] = locationBalance{
		OnHand:   sku.StockQuantity,
		Reserved: sku.StockReserved,
	}
	if sku.StockQuantity > 0 {
		createdAt := sku.CreatedAt
		if createdAt.IsZero() {
			createdAt = time.Now().UTC()
		}
		m.movements = append(m.movements, StockMovementRecord{
			MovementID:   newUUID(),
			WorkspaceID:  sku.WorkspaceID,
			SkuID:        sku.SkuID,
			LocationID:   locID,
			MovementType: "opening_balance",
			Quantity:     sku.StockQuantity,
			Reason:       "opening_balance",
			MovementKey:  "opening:" + sku.SkuID,
			CreatedAt:    createdAt,
		})
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
		m.seedOpeningSkuLocked(&skuCp)
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
	cp.SKUs = m.getSkusForProductLocked(cp.WorkspaceID, cp.ProductID)
	if existing.Metadata != nil {
		if existingIdx, hasIdx := existing.Metadata["search_index"]; hasIdx && existingIdx != nil {
			if cp.Metadata == nil {
				cp.Metadata = make(map[string]any)
			}
			if _, stillHasIdx := cp.Metadata["search_index"]; !stillHasIdx {
				cp.Metadata["search_index"] = existingIdx
			}
		}
	}
	refreshProductSearchIndexMetadata(cp)
	p.UpdatedAt = cp.UpdatedAt
	p.Metadata = cp.Metadata
	m.products[p.ProductID] = cp
	return nil
}

func (m *MemoryStore) DeleteProduct(ctx context.Context, workspaceID, productID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return ErrProductNotFound
	}
	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		if !p.UpdatedAt.UTC().Truncate(time.Microsecond).Equal(expectedTS.UTC().Truncate(time.Microsecond)) {
			return ErrConcurrencyConflict
		}
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

func (m *MemoryStore) ArchiveProduct(ctx context.Context, workspaceID, productID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return ErrProductNotFound
	}
	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		if !p.UpdatedAt.UTC().Truncate(time.Microsecond).Equal(expectedTS.UTC().Truncate(time.Microsecond)) {
			return ErrConcurrencyConflict
		}
	}
	p.CatalogStatus = StatusArchived
	now := time.Now().UTC()
	if !now.After(p.UpdatedAt) {
		now = p.UpdatedAt.Add(time.Microsecond)
	}
	p.UpdatedAt = now
	p.SKUs = m.getSkusForProductLocked(workspaceID, productID)
	refreshProductSearchIndexMetadata(p)
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
			p.SKUs = m.getSkusForProductLocked(workspaceID, pid)
			refreshProductSearchIndexMetadata(p)
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
	m.seedOpeningSkuLocked(cp)
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
			if meta.Result != nil {
				meta.Result.MovementID = mv.MovementID
				meta.Result.LocationID = mv.LocationID
				meta.Result.MovementType = mv.MovementType
			}
			return s.StockQuantity, nil
		}
	}

	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		if !s.UpdatedAt.UTC().Truncate(time.Microsecond).Equal(expectedTS.UTC().Truncate(time.Microsecond)) {
			return 0, ErrConcurrencyConflict
		}
	}

	locID := strings.TrimSpace(meta.LocationID)
	if locID == "" {
		locID = m.defaultLocationLocked(workspaceID)
	}
	if m.balances == nil {
		m.balances = make(map[string]map[string]locationBalance)
	}
	skuKey := workspaceID + ":" + skuID
	if m.balances[skuKey] == nil {
		m.balances[skuKey] = make(map[string]locationBalance)
	}

	now := time.Now().UTC()
	if !now.After(s.UpdatedAt) {
		now = s.UpdatedAt.Add(time.Microsecond)
	}

	// Only seed unallocated SKU stock if zero location balances and zero movements exist for this SKU.
	if len(m.balances[skuKey]) == 0 && (s.StockQuantity > 0 || s.StockReserved > 0) {
		var hasMovements bool
		for _, mv := range m.movements {
			if mv.WorkspaceID == workspaceID && mv.SkuID == skuID {
				hasMovements = true
				break
			}
		}
		if !hasMovements {
			m.balances[skuKey][locID] = locationBalance{
				OnHand:   s.StockQuantity,
				Reserved: s.StockReserved,
			}
			if s.StockQuantity > 0 {
				m.movements = append(m.movements, StockMovementRecord{
					MovementID:   newUUID(),
					WorkspaceID:  workspaceID,
					SkuID:        skuID,
					LocationID:   locID,
					MovementType: "opening_balance",
					Quantity:     s.StockQuantity,
					Reason:       "opening_balance",
					MovementKey:  "opening:" + skuID,
					CreatedAt:    now,
				})
			}
		}
	}

	locBal := m.balances[skuKey][locID]
	newLocOnHand, err := checkedAddInt32(locBal.OnHand, delta)
	if err != nil {
		return s.StockQuantity, err
	}
	if newLocOnHand < 0 {
		return s.StockQuantity, fmt.Errorf("%w: stock quantity cannot be negative", ErrInsufficientStock)
	}
	if newLocOnHand < locBal.Reserved {
		return s.StockQuantity, fmt.Errorf("%w: stock quantity (%d) cannot be less than reserved stock (%d)", ErrInsufficientStock, newLocOnHand, locBal.Reserved)
	}

	totalOnHand := newLocOnHand
	totalReserved := locBal.Reserved
	for k, bal := range m.balances[skuKey] {
		if k == locID {
			continue
		}
		var sumErr error
		totalOnHand, sumErr = checkedAddInt32(totalOnHand, bal.OnHand)
		if sumErr != nil {
			return s.StockQuantity, sumErr
		}
		totalReserved, sumErr = checkedAddInt32(totalReserved, bal.Reserved)
		if sumErr != nil {
			return s.StockQuantity, sumErr
		}
	}
	if totalOnHand < s.StockReserved {
		return s.StockQuantity, fmt.Errorf("%w: stock quantity (%d) cannot be less than reserved stock (%d)", ErrInsufficientStock, totalOnHand, s.StockReserved)
	}
	locBal.OnHand = newLocOnHand
	m.balances[skuKey][locID] = locBal
	if totalReserved > s.StockReserved {
		s.StockReserved = totalReserved
	}
	s.StockQuantity = totalOnHand
	s.UpdatedAt = now
	movementID := newUUID()
	m.movements = append(m.movements, StockMovementRecord{
		MovementID:   movementID,
		WorkspaceID:  workspaceID,
		SkuID:        skuID,
		LocationID:   locID,
		MovementType: "adjustment",
		Quantity:     delta,
		Reason:       reason,
		MovementKey:  movementKey,
		CreatedAt:    now,
	})
	if meta.Result != nil {
		meta.Result.MovementID = movementID
		meta.Result.LocationID = locID
		meta.Result.MovementType = "adjustment"
	}
	if p, ok := m.products[s.ProductID]; ok && p != nil && p.WorkspaceID == workspaceID && p.DeletedAt == nil {
		p.SKUs = m.getSkusForProductLocked(workspaceID, p.ProductID)
		refreshProductSearchIndexMetadata(p)
	}
	return totalOnHand, nil
}

func (m *MemoryStore) SetSkuAlertThreshold(ctx context.Context, workspaceID, skuID string, threshold int32) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	s, exists := m.skus[skuID]
	if !exists || s.WorkspaceID != workspaceID || s.DeletedAt != nil {
		return ErrSkuNotFound
	}
	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		if !s.UpdatedAt.UTC().Truncate(time.Microsecond).Equal(expectedTS.UTC().Truncate(time.Microsecond)) {
			return ErrConcurrencyConflict
		}
	}
	if threshold < 0 {
		return fmt.Errorf("%w: threshold cannot be negative", ErrInvalidInput)
	}
	now := time.Now().UTC()
	if !now.After(s.UpdatedAt) {
		now = s.UpdatedAt.Add(time.Microsecond)
	}
	s.LowStockThreshold = threshold
	s.UpdatedAt = now
	return nil
}

func (m *MemoryStore) LinkContent(ctx context.Context, workspaceID, productID string, ref ContentRef) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return ErrProductNotFound
	}
	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		if !p.UpdatedAt.UTC().Truncate(time.Microsecond).Equal(expectedTS.UTC().Truncate(time.Microsecond)) {
			return ErrConcurrencyConflict
		}
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

func (m *MemoryStore) GetIdempotencyRecord(ctx context.Context, workspaceID, idempotencyKey string) (*IdempotencyRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	rec, exists := m.idempotency[workspaceID+":"+idempotencyKey]
	if !exists {
		return nil, nil
	}
	now := time.Now().UTC()
	if ctxNow, ok := IdempotencyNowFromContext(ctx); ok {
		now = ctxNow
	}
	if !rec.ExpiresAt.IsZero() && now.After(rec.ExpiresAt) {
		return nil, nil
	}
	cp := rec
	if rec.ResponseBody != nil {
		cp.ResponseBody = append([]byte(nil), rec.ResponseBody...)
	}
	return &cp, nil
}

func (m *MemoryStore) SaveIdempotencyRecord(ctx context.Context, rec IdempotencyRecord) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	key := rec.WorkspaceID + ":" + rec.IdempotencyKey
	now := time.Now().UTC()
	if ctxNow, ok := IdempotencyNowFromContext(ctx); ok {
		now = ctxNow
	} else if !rec.CreatedAt.IsZero() {
		now = rec.CreatedAt.UTC()
	}
	if existing, ok := m.idempotency[key]; ok {
		if existing.ExpiresAt.IsZero() || now.Before(existing.ExpiresAt) {
			if existing.RequestHash != rec.RequestHash {
				return ErrIdempotencyConflict
			}
			cpExisting := existing
			if existing.ResponseBody != nil {
				cpExisting.ResponseBody = append([]byte(nil), existing.ResponseBody...)
			}
			return &idempotencyAlreadyCommittedError{Record: cpExisting}
		}
	}
	cp := rec
	if cp.CreatedAt.IsZero() {
		cp.CreatedAt = now
	}
	if cp.ExpiresAt.IsZero() {
		cp.ExpiresAt = cp.CreatedAt.Add(7 * 24 * time.Hour)
	}
	if rec.ResponseBody != nil {
		cp.ResponseBody = append([]byte(nil), rec.ResponseBody...)
	}
	m.idempotency[key] = cp
	return nil
}

func (m *MemoryStore) GetProductSalesSummary(ctx context.Context, workspaceID, productID string) (*ProductSalesSummary, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrProductNotFound
	}
	skus := m.getSkusForProductLocked(workspaceID, productID)
	skuSet := make(map[string]bool, len(skus)*2)
	var lowStockCount int32
	for _, s := range skus {
		skuSet[s.SkuID] = true
		if s.SkuCode != "" {
			skuSet[s.SkuCode] = true
		}
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
	prodCopy := cloneProduct(p)
	prodCopy.SKUs = skus

	var wsOrders []AnalyticsOrder
	for _, o := range m.orders {
		if o.WorkspaceID == workspaceID {
			wsOrders = append(wsOrders, o)
		}
	}
	var wsRefunds []AnalyticsRefund
	for _, r := range m.refunds {
		if r.WorkspaceID == workspaceID {
			wsRefunds = append(wsRefunds, r)
		}
	}
	filter, _ := SalesStatsFilterFromContext(ctx)
	return computeProductSalesSummary(prodCopy, mvCount, lowStockCount, wsOrders, wsRefunds, filter)
}

func (m *MemoryStore) GetProductSalesChart(ctx context.Context, workspaceID, productID string, days int) ([]SalesChartDataPoint, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, exists := m.products[productID]
	if !exists || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrProductNotFound
	}
	prodCopy := cloneProduct(p)
	prodCopy.SKUs = m.getSkusForProductLocked(workspaceID, productID)

	var wsOrders []AnalyticsOrder
	for _, o := range m.orders {
		if o.WorkspaceID == workspaceID {
			wsOrders = append(wsOrders, o)
		}
	}
	filter, _ := SalesStatsFilterFromContext(ctx)
	return computeProductSalesChart(prodCopy, days, wsOrders, filter)
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
			cp := cloneProduct(p)
			cp.SKUs = m.getSkusForProductLocked(workspaceID, p.ProductID)
			allWs = append(allWs, cp)
		}
	}
	var wsOrders []AnalyticsOrder
	for _, o := range m.orders {
		if o.WorkspaceID == workspaceID {
			wsOrders = append(wsOrders, o)
		}
	}
	return computeProductRank(allWs, productID, wsOrders)
}

type memoryStoreSnapshot struct {
	products    map[string]*Product
	skus        map[string]*ProductSku
	balances    map[string]map[string]locationBalance
	movements   []StockMovementRecord
	idempotency map[string]IdempotencyRecord
}

func (m *MemoryStore) takeSnapshot() memoryStoreSnapshot {
	m.mu.RLock()
	defer m.mu.RUnlock()

	snap := memoryStoreSnapshot{
		products:    make(map[string]*Product, len(m.products)),
		skus:        make(map[string]*ProductSku, len(m.skus)),
		balances:    make(map[string]map[string]locationBalance, len(m.balances)),
		movements:   make([]StockMovementRecord, len(m.movements)),
		idempotency: make(map[string]IdempotencyRecord, len(m.idempotency)),
	}
	for k, v := range m.products {
		snap.products[k] = cloneProduct(v)
	}
	for k, v := range m.skus {
		snap.skus[k] = cloneSku(v)
	}
	for k, locMap := range m.balances {
		cpMap := make(map[string]locationBalance, len(locMap))
		for locID, bal := range locMap {
			cpMap[locID] = bal
		}
		snap.balances[k] = cpMap
	}
	copy(snap.movements, m.movements)
	for k, rec := range m.idempotency {
		cp := rec
		if rec.ResponseBody != nil {
			cp.ResponseBody = append([]byte(nil), rec.ResponseBody...)
		}
		snap.idempotency[k] = cp
	}
	return snap
}

func (m *MemoryStore) restoreSnapshot(snap memoryStoreSnapshot) {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.products = snap.products
	m.skus = snap.skus
	m.balances = snap.balances
	m.movements = snap.movements
	m.idempotency = snap.idempotency
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

type pgTxContextKey struct{}

var savepointSeq uint64

func nextSavepointName() string {
	n := atomic.AddUint64(&savepointSeq, 1)
	return fmt.Sprintf("sp_product_%d", n)
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

func (s *PostgresStore) dbFromContext(ctx context.Context) DBTX {
	if ctx != nil {
		if tx, ok := ctx.Value(pgTxContextKey{}).(DBTX); ok && tx != nil {
			return tx
		}
	}
	return s.db
}

func (s *PostgresStore) resolveDefaultLocationTx(ctx context.Context, db DBTX, workspaceID string) (string, error) {
	var locationID string
	err := db.QueryRow(ctx, `
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
				return "", fmt.Errorf("create default inventory location: %w", err)
			}
			return locationID, nil
		}
		return "", fmt.Errorf("resolve inventory location: %w", err)
	}
	return locationID, nil
}

func (s *PostgresStore) CreateProduct(ctx context.Context, p *Product) error {
	db := s.dbFromContext(ctx)
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
	_, err = db.Exec(ctx, query,
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
	db := s.dbFromContext(ctx)
	query := `
		SELECT product_id, workspace_id, product_type, title, description,
		       category, base_price, currency, cogs, catalog_status,
		       inventory_enabled, external_refs, images, metadata, created_at, updated_at, deleted_at
		FROM products
		WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL
	`
	row := db.QueryRow(ctx, query, workspaceID, productID)
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
	db := s.dbFromContext(ctx)
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
	if err := db.QueryRow(ctx, countQuery, args...).Scan(&total); err != nil {
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

	rows, err := db.Query(ctx, selectQuery, args...)
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
	db := s.dbFromContext(ctx)
	if len(p.SKUs) == 0 && p.Metadata != nil && p.Metadata["search_index"] != nil {
		if skus, skuErr := s.ListSkusByProduct(ctx, p.WorkspaceID, p.ProductID); skuErr == nil {
			p.SKUs = skus
		}
	}
	refreshProductSearchIndexMetadata(p)
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
		err = db.QueryRow(ctx, query,
			p.Title, p.Description, p.Category,
			basePriceStr, p.Currency, cogsStr,
			p.CatalogStatus, p.InventoryEnabled, extJSON,
			imgJSON, metaJSON, p.UpdatedAt.UTC(),
			p.WorkspaceID, p.ProductID, p.ExpectedUpdatedAt.UTC(),
		).Scan(&newUpdatedAt)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				var exists bool
				checkErr := db.QueryRow(ctx,
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
	err = db.QueryRow(ctx, query,
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
	db := s.dbFromContext(ctx)
	now := time.Now().UTC()
	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		tag, err := db.Exec(ctx, `
			UPDATE products
			SET deleted_at = $1,
			    updated_at = CASE WHEN $1::timestamptz > updated_at THEN $1::timestamptz ELSE updated_at + interval '1 microsecond' END
			WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL
			  AND date_trunc('microseconds', updated_at) = date_trunc('microseconds', $4::timestamptz)
		`, now, workspaceID, productID, expectedTS.UTC())
		if err != nil {
			return fmt.Errorf("delete product: %w", err)
		}
		if tag.RowsAffected() == 0 {
			var exists bool
			checkErr := db.QueryRow(ctx,
				`SELECT EXISTS(SELECT 1 FROM products WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL)`,
				workspaceID, productID,
			).Scan(&exists)
			if checkErr == nil && exists {
				return ErrConcurrencyConflict
			}
			return ErrProductNotFound
		}
		_, _ = db.Exec(ctx, `UPDATE product_skus SET deleted_at = $1 WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL`, now, workspaceID, productID)
		return nil
	}

	query := `
		UPDATE products
		SET deleted_at = $1
		WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL
	`
	tag, err := db.Exec(ctx, query, now, workspaceID, productID)
	if err != nil {
		return fmt.Errorf("delete product: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrProductNotFound
	}
	// Also soft-delete associated SKUs
	_, _ = db.Exec(ctx, `UPDATE product_skus SET deleted_at = $1 WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL`, now, workspaceID, productID)
	return nil
}

func (s *PostgresStore) ArchiveProduct(ctx context.Context, workspaceID, productID string) error {
	db := s.dbFromContext(ctx)
	now := time.Now().UTC()
	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		tag, err := db.Exec(ctx, `
			UPDATE products
			SET catalog_status = 'archived',
			    updated_at = CASE WHEN $1::timestamptz > updated_at THEN $1::timestamptz ELSE updated_at + interval '1 microsecond' END
			WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL
			  AND date_trunc('microseconds', updated_at) = date_trunc('microseconds', $4::timestamptz)
		`, now, workspaceID, productID, expectedTS.UTC())
		if err != nil {
			return fmt.Errorf("archive product: %w", err)
		}
		if tag.RowsAffected() == 0 {
			var exists bool
			checkErr := db.QueryRow(ctx,
				`SELECT EXISTS(SELECT 1 FROM products WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL)`,
				workspaceID, productID,
			).Scan(&exists)
			if checkErr == nil && exists {
				return ErrConcurrencyConflict
			}
			return ErrProductNotFound
		}
		return nil
	}

	query := `
		UPDATE products
		SET catalog_status = 'archived',
		    updated_at = CASE WHEN $1::timestamptz > updated_at THEN $1::timestamptz ELSE updated_at + interval '1 microsecond' END
		WHERE workspace_id = $2::uuid AND product_id = $3::uuid AND deleted_at IS NULL
	`
	tag, err := db.Exec(ctx, query, now, workspaceID, productID)
	if err != nil {
		return fmt.Errorf("archive product: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrProductNotFound
	}
	return nil
}

func (s *PostgresStore) BulkArchiveProducts(ctx context.Context, workspaceID string, productIDs []string) (int, error) {
	db := s.dbFromContext(ctx)
	now := time.Now().UTC()
	query := `
		UPDATE products
		SET catalog_status = 'archived', updated_at = $1
		WHERE workspace_id = $2::uuid AND product_id = ANY($3::uuid[]) AND deleted_at IS NULL
	`
	tag, err := db.Exec(ctx, query, now, workspaceID, productIDs)
	if err != nil {
		return 0, fmt.Errorf("bulk archive products: %w", err)
	}
	return int(tag.RowsAffected()), nil
}

func (s *PostgresStore) FindProductByExternalID(ctx context.Context, workspaceID, platform, externalID, connectedAccountID string) (*Product, error) {
	db := s.dbFromContext(ctx)
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

	row := db.QueryRow(ctx, query, workspaceID, matchJSON)
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
	db := s.dbFromContext(ctx)
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
	_, err = db.Exec(ctx, query,
		sku.SkuID, sku.WorkspaceID, sku.ProductID, sku.SkuCode, varAttrJSON,
		priceStr, cogsStr, sku.Currency, sku.StockQuantity, sku.StockReserved,
		sku.LowStockThreshold, sku.Barcode, sku.WeightGrams, sku.IsActive, extJSON,
		sku.CreatedAt, sku.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("insert sku: %w", err)
	}

	// If opening stock is provided at SKU creation, record the opening balance & movement on the default location.
	if sku.StockQuantity > 0 || sku.StockReserved > 0 {
		locationID, locErr := s.resolveDefaultLocationTx(ctx, db, sku.WorkspaceID)
		if locErr != nil {
			return locErr
		}
		createdAt := sku.CreatedAt
		if createdAt.IsZero() {
			createdAt = time.Now().UTC()
		}
		_, err = db.Exec(ctx, `
			INSERT INTO inventory_balances (workspace_id, sku_id, location_id, on_hand, reserved, opening_at, updated_at)
			VALUES ($1::uuid, $2::uuid, $3::uuid, $4, $5, $6, $6)
			ON CONFLICT (workspace_id, sku_id, location_id) DO UPDATE
			SET on_hand = EXCLUDED.on_hand,
			    reserved = EXCLUDED.reserved,
			    opening_at = COALESCE(inventory_balances.opening_at, EXCLUDED.opening_at),
			    updated_at = EXCLUDED.updated_at
		`, sku.WorkspaceID, sku.SkuID, locationID, sku.StockQuantity, sku.StockReserved, createdAt)
		if err != nil {
			return fmt.Errorf("insert opening inventory balance: %w", err)
		}
		if sku.StockQuantity > 0 {
			_, err = db.Exec(ctx, `
				INSERT INTO stock_movements (
					movement_id, workspace_id, sku_id, location_id,
					movement_type, quantity, reason, movement_key, created_at
				) VALUES (
					$1::uuid, $2::uuid, $3::uuid, $4::uuid,
					'opening_balance', $5, 'opening_balance', $6, $7
				)
				ON CONFLICT (workspace_id, movement_key) DO NOTHING
			`, newUUID(), sku.WorkspaceID, sku.SkuID, locationID, sku.StockQuantity, "opening:"+sku.SkuID, createdAt)
			if err != nil {
				return fmt.Errorf("insert opening stock movement: %w", err)
			}
		}
	}
	return nil
}

func (s *PostgresStore) GetSku(ctx context.Context, workspaceID, skuID string) (*ProductSku, error) {
	db := s.dbFromContext(ctx)
	query := `
		SELECT sku_id, workspace_id, product_id, sku_code, variant_attributes,
		       price_override, cogs_override, currency, stock_quantity, stock_reserved,
		       low_stock_threshold, barcode, weight_grams, is_active, external_refs,
		       created_at, updated_at, deleted_at
		FROM product_skus
		WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND deleted_at IS NULL
	`
	row := db.QueryRow(ctx, query, workspaceID, skuID)
	sku, err := scanSku(row)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrSkuNotFound
		}
		return nil, err
	}
	return sku, nil
}

func (s *PostgresStore) ListSkusByProduct(ctx context.Context, workspaceID, productID string) ([]ProductSku, error) {
	db := s.dbFromContext(ctx)
	query := `
		SELECT sku_id, workspace_id, product_id, sku_code, variant_attributes,
		       price_override, cogs_override, currency, stock_quantity, stock_reserved,
		       low_stock_threshold, barcode, weight_grams, is_active, external_refs,
		       created_at, updated_at, deleted_at
		FROM product_skus
		WHERE workspace_id = $1::uuid AND product_id = $2::uuid AND deleted_at IS NULL
		ORDER BY created_at ASC
	`
	rows, err := db.Query(ctx, query, workspaceID, productID)
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
	if ctx != nil {
		if activeTx, ok := ctx.Value(pgTxContextKey{}).(DBTX); ok && activeTx != nil {
			sp := nextSavepointName()
			if _, err := activeTx.Exec(ctx, "SAVEPOINT "+sp); err != nil {
				return fn(activeTx)
			}
			if err := fn(activeTx); err != nil {
				_, _ = activeTx.Exec(ctx, "ROLLBACK TO SAVEPOINT "+sp)
				_, _ = activeTx.Exec(ctx, "RELEASE SAVEPOINT "+sp)
				return err
			}
			_, _ = activeTx.Exec(ctx, "RELEASE SAVEPOINT "+sp)
			return nil
		}
	}
	if s.pool == nil {
		sp := nextSavepointName()
		if _, err := s.db.Exec(ctx, "SAVEPOINT "+sp); err != nil {
			return fn(s.db)
		}
		if err := fn(s.db); err != nil {
			_, _ = s.db.Exec(ctx, "ROLLBACK TO SAVEPOINT "+sp)
			_, _ = s.db.Exec(ctx, "RELEASE SAVEPOINT "+sp)
			return err
		}
		_, _ = s.db.Exec(ctx, "RELEASE SAVEPOINT "+sp)
		return nil
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
		var existingMovementID, existingLocationID, existingMovementType string
		var existingSkuID string
		var existingQty int32
		var existingReason string
		err := db.QueryRow(ctx, `
			SELECT movement_id::text, location_id::text, movement_type::text, sku_id::text, quantity, COALESCE(reason, '')
			FROM stock_movements
			WHERE workspace_id = $1::uuid AND movement_key = $2
		`, workspaceID, movementKey).Scan(&existingMovementID, &existingLocationID, &existingMovementType, &existingSkuID, &existingQty, &existingReason)
		if err == nil {
			if existingSkuID != skuID || existingQty != delta || existingReason != reason {
				return ErrIdempotencyConflict
			}
			if meta.Result != nil {
				meta.Result.MovementID = existingMovementID
				meta.Result.LocationID = existingLocationID
				meta.Result.MovementType = existingMovementType
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
		var currentUpdatedAt time.Time
		err = db.QueryRow(ctx, `
			SELECT stock_quantity, stock_reserved, updated_at
			FROM product_skus
			WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND deleted_at IS NULL
			FOR UPDATE
		`, workspaceID, skuID).Scan(&currentQty, &currentReserved, &currentUpdatedAt)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrSkuNotFound
			}
			return fmt.Errorf("lock sku: %w", err)
		}

		if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
			if !currentUpdatedAt.UTC().Truncate(time.Microsecond).Equal(expectedTS.UTC().Truncate(time.Microsecond)) {
				return ErrConcurrencyConflict
			}
		}

		var locationID string
		if strings.TrimSpace(meta.LocationID) != "" {
			err = db.QueryRow(ctx, `
				SELECT location_id::text
				FROM inventory_locations
				WHERE workspace_id = $1::uuid AND location_id = $2::uuid AND status = 'active'
			`, workspaceID, strings.TrimSpace(meta.LocationID)).Scan(&locationID)
			if err != nil {
				if errors.Is(err, pgx.ErrNoRows) {
					return fmt.Errorf("%w: inventory location not found or inactive", ErrInvalidInput)
				}
				return fmt.Errorf("resolve specified inventory location: %w", err)
			}
		} else {
			locationID, err = s.resolveDefaultLocationTx(ctx, db, workspaceID)
			if err != nil {
				return err
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
				// Data F2 fix: never initialize a new location's balance from aggregate SKU stock
				// when other locations already hold balances for this SKU.
				var existingBalanceCount, existingMovementCount int
				_ = db.QueryRow(ctx, `
					SELECT
						(SELECT COUNT(*)::int FROM inventory_balances WHERE workspace_id = $1::uuid AND sku_id = $2::uuid),
						(SELECT COUNT(*)::int FROM stock_movements WHERE workspace_id = $1::uuid AND sku_id = $2::uuid)
				`, workspaceID, skuID).Scan(&existingBalanceCount, &existingMovementCount)

				balOnHand = 0
				balReserved = 0
				if existingBalanceCount == 0 && existingMovementCount == 0 && (currentQty > 0 || currentReserved > 0) {
					balOnHand = currentQty
					balReserved = currentReserved
					if currentQty > 0 {
						_, err = db.Exec(ctx, `
							INSERT INTO stock_movements (
								movement_id, workspace_id, sku_id, location_id,
								movement_type, quantity, reason, movement_key, created_at
							) VALUES (
								$1::uuid, $2::uuid, $3::uuid, $4::uuid,
								'opening_balance', $5, 'opening_balance', $6, NOW()
							)
							ON CONFLICT (workspace_id, movement_key) DO NOTHING
						`, newUUID(), workspaceID, skuID, locationID, currentQty, "opening:"+skuID)
						if err != nil {
							return fmt.Errorf("insert opening stock movement: %w", err)
						}
					}
				}

				newBalOnHand, addErr := checkedAddInt32(balOnHand, delta)
				if addErr != nil {
					return addErr
				}
				if newBalOnHand < 0 || newBalOnHand < balReserved {
					return fmt.Errorf("%w: location stock balance (%d) cannot be less than reserved (%d)", ErrInsufficientStock, newBalOnHand, balReserved)
				}
				_, err = db.Exec(ctx, `
					INSERT INTO inventory_balances (workspace_id, sku_id, location_id, on_hand, reserved, opening_at, updated_at)
					VALUES ($1::uuid, $2::uuid, $3::uuid, $4, $5, NOW(), NOW())
				`, workspaceID, skuID, locationID, newBalOnHand, balReserved)
				if err != nil {
					return fmt.Errorf("insert inventory balance: %w", err)
				}
			} else {
				return fmt.Errorf("lock inventory balance: %w", err)
			}
		} else {
			newBalOnHand, addErr := checkedAddInt32(balOnHand, delta)
			if addErr != nil {
				return addErr
			}
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

		movementID := newUUID()
		_, err = db.Exec(ctx, `
			INSERT INTO stock_movements (
				movement_id, workspace_id, sku_id, location_id,
				movement_type, quantity, reason, movement_key, created_at
			) VALUES (
				$1::uuid, $2::uuid, $3::uuid, $4::uuid,
				'adjustment', $5, $6, $7, NOW()
			)
		`, movementID, workspaceID, skuID, locationID, delta, reason, movementKey)
		if err != nil {
			return fmt.Errorf("insert stock movement: %w", err)
		}
		if meta.Result != nil {
			meta.Result.MovementID = movementID
			meta.Result.LocationID = locationID
			meta.Result.MovementType = "adjustment"
		}

		var sumOnHand64, sumReserved64 int64
		err = db.QueryRow(ctx, `
			SELECT COALESCE(SUM(on_hand), 0), COALESCE(SUM(reserved), 0)
			FROM inventory_balances
			WHERE workspace_id = $1::uuid AND sku_id = $2::uuid
		`, workspaceID, skuID).Scan(&sumOnHand64, &sumReserved64)
		if err != nil {
			return fmt.Errorf("sum inventory balances: %w", err)
		}
		if sumOnHand64 > math.MaxInt32 || sumOnHand64 < math.MinInt32 || sumReserved64 > math.MaxInt32 || sumReserved64 < math.MinInt32 {
			return fmt.Errorf("%w: total stock quantity overflows int32 bounds", ErrInvalidInput)
		}
		totalOnHand := int32(sumOnHand64)
		totalReserved := int32(sumReserved64)
		if totalReserved < currentReserved {
			totalReserved = currentReserved
		}
		if totalOnHand < 0 || totalOnHand < totalReserved {
			return fmt.Errorf("%w: stock quantity (%d) cannot be less than reserved stock (%d)", ErrInsufficientStock, totalOnHand, totalReserved)
		}

		err = db.QueryRow(ctx, `
			UPDATE product_skus
			SET stock_quantity = $3,
			    stock_reserved = $4,
			    updated_at = CASE WHEN NOW() > updated_at THEN NOW() ELSE updated_at + interval '1 microsecond' END
			WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND deleted_at IS NULL
			RETURNING stock_quantity
		`, workspaceID, skuID, totalOnHand, totalReserved).Scan(&resultQty)
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
	if threshold < 0 {
		return fmt.Errorf("%w: threshold cannot be negative", ErrInvalidInput)
	}
	db := s.dbFromContext(ctx)
	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		tag, err := db.Exec(ctx, `
			UPDATE product_skus
			SET low_stock_threshold = $1,
			    updated_at = CASE WHEN NOW() > updated_at THEN NOW() ELSE updated_at + interval '1 microsecond' END
			WHERE workspace_id = $2::uuid AND sku_id = $3::uuid AND deleted_at IS NULL
			  AND date_trunc('microseconds', updated_at) = date_trunc('microseconds', $4::timestamptz)
		`, threshold, workspaceID, skuID, expectedTS.UTC())
		if err != nil {
			return fmt.Errorf("set alert threshold: %w", err)
		}
		if tag.RowsAffected() == 0 {
			var exists bool
			checkErr := db.QueryRow(ctx,
				`SELECT EXISTS(SELECT 1 FROM product_skus WHERE workspace_id = $1::uuid AND sku_id = $2::uuid AND deleted_at IS NULL)`,
				workspaceID, skuID,
			).Scan(&exists)
			if checkErr == nil && exists {
				return ErrConcurrencyConflict
			}
			return ErrSkuNotFound
		}
		return nil
	}

	query := `
		UPDATE product_skus
		SET low_stock_threshold = $1,
		    updated_at = CASE WHEN NOW() > updated_at THEN NOW() ELSE updated_at + interval '1 microsecond' END
		WHERE workspace_id = $2::uuid AND sku_id = $3::uuid AND deleted_at IS NULL
	`
	tag, err := db.Exec(ctx, query, threshold, workspaceID, skuID)
	if err != nil {
		return fmt.Errorf("set alert threshold: %w", err)
	}
	if tag.RowsAffected() == 0 {
		return ErrSkuNotFound
	}
	return nil
}

func (s *PostgresStore) LinkContent(ctx context.Context, workspaceID, productID string, ref ContentRef) error {
	// Fetch product, update metadata["linked_content"] atomically with CAS
	p, err := s.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return err
	}
	if expectedTS, ok := ExpectedUpdatedAtFromContext(ctx); ok {
		if !p.UpdatedAt.UTC().Truncate(time.Microsecond).Equal(expectedTS.UTC().Truncate(time.Microsecond)) {
			return ErrConcurrencyConflict
		}
		p.ExpectedUpdatedAt = expectedTS
	} else {
		prevUpdated := p.UpdatedAt
		p.ExpectedUpdatedAt = &prevUpdated
	}
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
	db := s.dbFromContext(ctx)
	now := time.Now().UTC()
	if ctxNow, ok := IdempotencyNowFromContext(ctx); ok {
		now = ctxNow
	}
	var rec IdempotencyRecord
	err := db.QueryRow(ctx, `
		SELECT workspace_id::text, idempotency_key, request_hash, COALESCE(response_code, 200), COALESCE(response_body, response_payload, '{}'::jsonb), created_at, expires_at
		FROM api_idempotency_records
		WHERE workspace_id = $1::uuid AND actor_id = $1::uuid AND rpc = 'product.mutation' AND idempotency_key = $2 AND expires_at > $3
	`, workspaceID, idempotencyKey, now).Scan(
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
	db := s.dbFromContext(ctx)
	now := time.Now().UTC()
	if ctxNow, ok := IdempotencyNowFromContext(ctx); ok {
		now = ctxNow
	}
	createdAt := rec.CreatedAt
	if createdAt.IsZero() {
		createdAt = now
	}
	expiresAt := rec.ExpiresAt
	if expiresAt.IsZero() {
		expiresAt = createdAt.Add(7 * 24 * time.Hour)
	}
	bodyJSON := rec.ResponseBody
	if len(bodyJSON) == 0 {
		bodyJSON = []byte("{}")
	}
	statusCode := rec.ResponseStatus
	if statusCode == 0 {
		statusCode = 200
	}
	tag, err := db.Exec(ctx, `
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
		WHERE api_idempotency_records.expires_at <= $6
	`, rec.WorkspaceID, rec.IdempotencyKey, rec.RequestHash, statusCode, bodyJSON, createdAt, expiresAt)
	if err != nil {
		return fmt.Errorf("save idempotency record: %w", err)
	}
	if tag.RowsAffected() == 0 {
		var existing IdempotencyRecord
		err := db.QueryRow(ctx, `
			SELECT workspace_id::text, idempotency_key, request_hash, COALESCE(response_code, 200), COALESCE(response_body, response_payload, '{}'::jsonb), created_at, expires_at
			FROM api_idempotency_records
			WHERE workspace_id = $1::uuid AND actor_id = $1::uuid AND rpc = 'product.mutation' AND idempotency_key = $2
		`, rec.WorkspaceID, rec.IdempotencyKey).Scan(
			&existing.WorkspaceID, &existing.IdempotencyKey, &existing.RequestHash,
			&existing.ResponseStatus, &existing.ResponseBody, &existing.CreatedAt, &existing.ExpiresAt,
		)
		if err != nil {
			return fmt.Errorf("query existing idempotency record: %w", err)
		}
		if existing.RequestHash != rec.RequestHash {
			return ErrIdempotencyConflict
		}
		return &idempotencyAlreadyCommittedError{Record: existing}
	}
	return nil
}

func (s *PostgresStore) loadWorkspaceAnalyticsData(ctx context.Context, workspaceID string) ([]AnalyticsOrder, []AnalyticsRefund, error) {
	db := s.dbFromContext(ctx)
	orderRows, err := db.Query(ctx, `
		SELECT
			order_id::text,
			workspace_id::text,
			COALESCE(product_id::text, ''),
			amount::numeric(18,6)::text,
			COALESCE(currency, ''),
			COALESCE(exchange_rate_snapshot, '{}'::jsonb),
			COALESCE(items, '[]'::jsonb),
			COALESCE(lifecycle_state, ''),
			COALESCE(ordered_at, created_at)
		FROM orders
		WHERE workspace_id = $1::uuid
		  AND deleted_at IS NULL
		  AND lifecycle_state != 'cancelled'
		ORDER BY COALESCE(ordered_at, created_at) ASC, order_id ASC
	`, workspaceID)
	if err != nil {
		return nil, nil, fmt.Errorf("query workspace orders: %w", err)
	}
	defer orderRows.Close()

	var orders []AnalyticsOrder
	for orderRows.Next() {
		var (
			ord       AnalyticsOrder
			amountStr string
			fxBytes   []byte
			itemsJSON []byte
		)
		if err := orderRows.Scan(
			&ord.OrderID,
			&ord.WorkspaceID,
			&ord.ProductID,
			&amountStr,
			&ord.Currency,
			&fxBytes,
			&itemsJSON,
			&ord.LifecycleState,
			&ord.OrderedAt,
		); err != nil {
			return nil, nil, fmt.Errorf("scan workspace order: %w", err)
		}
		ord.Amount, _ = tenantdb.ParseExactDecimal(amountStr)
		if len(fxBytes) > 0 {
			var fx ExchangeRateSnapshot
			if err := json.Unmarshal(fxBytes, &fx); err == nil {
				if fx.BaseCurrency != "" || fx.QuoteCurrency != "" || fx.RateToBase != "" {
					ord.ExchangeRateSnapshot = &fx
				}
			}
		}
		if len(itemsJSON) > 0 {
			var rawItems []map[string]any
			if err := json.Unmarshal(itemsJSON, &rawItems); err == nil {
				for _, ri := range rawItems {
					var line AnalyticsOrderLine
					if v, ok := ri["product_id"].(string); ok {
						line.ProductID = v
					}
					if v, ok := ri["sku_id"].(string); ok {
						line.SkuID = v
					}
					if v, ok := ri["sku"].(string); ok {
						line.Sku = v
					}
					switch qv := ri["quantity"].(type) {
					case float64:
						line.Quantity = int64(qv)
					case string:
						if d, err := tenantdb.ParseExactDecimal(qv); err == nil {
							line.Quantity = d.ToPgNumeric().Int.Int64() / 1_000_000
						}
					}
					if v := parseAnyExactDecimalPtr(ri["unit_price"]); v != nil {
						line.UnitPrice = v
					}
					if v := parseAnyExactDecimalPtr(ri["discount"]); v != nil {
						line.Discount = v
					}
					if v := parseAnyExactDecimalPtr(ri["total"]); v != nil {
						line.Total = v
					}
					if v := parseAnyExactDecimalPtr(ri["unit_cogs"]); v != nil {
						line.UnitCOGS = v
					}
					ord.Items = append(ord.Items, line)
				}
			}
		}
		orders = append(orders, ord)
	}
	if err := orderRows.Err(); err != nil {
		return nil, nil, err
	}

	refundRows, err := db.Query(ctx, `
		SELECT
			refund_id::text,
			workspace_id::text,
			order_id::text,
			amount::numeric(18,6)::text,
			COALESCE(currency, ''),
			COALESCE(lifecycle_state, ''),
			created_at
		FROM refunds
		WHERE workspace_id = $1::uuid
		  AND deleted_at IS NULL
		  AND lifecycle_state = 'completed'
		ORDER BY created_at ASC, refund_id ASC
	`, workspaceID)
	if err != nil {
		return nil, nil, fmt.Errorf("query workspace refunds: %w", err)
	}
	defer refundRows.Close()

	var refunds []AnalyticsRefund
	for refundRows.Next() {
		var (
			ref       AnalyticsRefund
			amountStr string
		)
		if err := refundRows.Scan(
			&ref.RefundID,
			&ref.WorkspaceID,
			&ref.OrderID,
			&amountStr,
			&ref.Currency,
			&ref.LifecycleState,
			&ref.CreatedAt,
		); err != nil {
			return nil, nil, fmt.Errorf("scan workspace refund: %w", err)
		}
		ref.Amount, _ = tenantdb.ParseExactDecimal(amountStr)
		refunds = append(refunds, ref)
	}
	if err := refundRows.Err(); err != nil {
		return nil, nil, err
	}
	return orders, refunds, nil
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

	db := s.dbFromContext(ctx)
	var mvCount int32
	_ = db.QueryRow(ctx, `
		SELECT COUNT(*)::int4
		FROM stock_movements sm
		JOIN product_skus ps ON ps.workspace_id = sm.workspace_id AND ps.sku_id = sm.sku_id
		WHERE sm.workspace_id = $1::uuid AND ps.product_id = $2::uuid AND ps.deleted_at IS NULL
	`, workspaceID, productID).Scan(&mvCount)

	orders, refunds, err := s.loadWorkspaceAnalyticsData(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	filter, _ := SalesStatsFilterFromContext(ctx)
	return computeProductSalesSummary(p, mvCount, lowStockCount, orders, refunds, filter)
}

func (s *PostgresStore) GetProductSalesChart(ctx context.Context, workspaceID, productID string, days int) ([]SalesChartDataPoint, error) {
	p, err := s.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return nil, err
	}
	orders, _, err := s.loadWorkspaceAnalyticsData(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	filter, _ := SalesStatsFilterFromContext(ctx)
	return computeProductSalesChart(p, days, orders, filter)
}

func (s *PostgresStore) GetProductRank(ctx context.Context, workspaceID, productID string) (*ProductRankSummary, error) {
	if _, err := s.GetProduct(ctx, workspaceID, productID); err != nil {
		return nil, err
	}
	allProducts, _, err := s.ListProducts(ctx, workspaceID, ListFilter{}, 10000, 0)
	if err != nil {
		return nil, err
	}
	orders, _, err := s.loadWorkspaceAnalyticsData(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	return computeProductRank(allProducts, productID, orders)
}

// ============================================================================
// Shared ExactDecimal Analytics Engine (Data F6, F7, F8)
// ============================================================================

var (
	microScaleInt = big.NewInt(1_000_000)
	halfMicroInt  = big.NewInt(500_000)
)

func parseAnyExactDecimalPtr(v any) *tenantdb.ExactDecimal {
	if v == nil {
		return nil
	}
	switch val := v.(type) {
	case string:
		if strings.TrimSpace(val) == "" {
			return nil
		}
		if d, err := tenantdb.ParseExactDecimal(val); err == nil {
			return &d
		}
	case float64:
		if d, err := tenantdb.ParseExactDecimal(fmt.Sprintf("%.6f", val)); err == nil {
			return &d
		}
	}
	return nil
}

func decToMicro(d tenantdb.ExactDecimal) *big.Int {
	n := d.ToPgNumeric()
	if !n.Valid || n.Int == nil {
		return big.NewInt(0)
	}
	return new(big.Int).Set(n.Int)
}

func microToDec(m *big.Int) tenantdb.ExactDecimal {
	if m == nil {
		return tenantdb.ZeroDecimal()
	}
	d, err := tenantdb.FromPgNumeric(pgtype.Numeric{
		Int:   new(big.Int).Set(m),
		Exp:   -tenantdb.MaxDecimalScale,
		Valid: true,
	})
	if err != nil {
		return tenantdb.ZeroDecimal()
	}
	return d
}

// resolveOrderRateMicro returns the FX multiplier in micro-units (10^6 = 1.000000)
// to convert amounts in orderCurrency into targetCurrency.
// Fails closed with ErrCurrencyMismatch when orderCurrency != targetCurrency and a valid
// positive ExchangeRateSnapshot for (quote=orderCurrency, base=targetCurrency) is absent.
func resolveOrderRateMicro(orderID, orderCurrency, targetCurrency string, fx *ExchangeRateSnapshot) (*big.Int, error) {
	targetCurr := strings.ToUpper(strings.TrimSpace(targetCurrency))
	if targetCurr == "" {
		targetCurr = "VND"
	}
	ordCurr := strings.ToUpper(strings.TrimSpace(orderCurrency))
	if ordCurr == "" {
		ordCurr = targetCurr
	}
	if fx != nil {
		baseCurr := strings.ToUpper(strings.TrimSpace(fx.BaseCurrency))
		quoteCurr := strings.ToUpper(strings.TrimSpace(fx.QuoteCurrency))
		rateStr := strings.TrimSpace(fx.RateToBase)
		if baseCurr != "" || quoteCurr != "" || rateStr != "" {
			if baseCurr == "" || quoteCurr == "" || rateStr == "" {
				return nil, fmt.Errorf("%w: order %s has incomplete exchange_rate_snapshot", ErrCurrencyMismatch, orderID)
			}
			if quoteCurr != ordCurr && baseCurr != ordCurr {
				return nil, fmt.Errorf("%w: order %s exchange_rate_snapshot (%s->%s) does not match order currency %s", ErrCurrencyMismatch, orderID, quoteCurr, baseCurr, ordCurr)
			}
			rateDec, err := tenantdb.ParseExactDecimal(rateStr)
			if err != nil || rateDec.IsZero() || rateDec.IsNegative() {
				return nil, fmt.Errorf("%w: order %s has invalid rate_to_base %q", ErrCurrencyMismatch, orderID, fx.RateToBase)
			}
			rateMicro := decToMicro(rateDec)
			if baseCurr == quoteCurr && rateMicro.Cmp(microScaleInt) != 0 {
				return nil, fmt.Errorf("%w: order %s same-currency exchange_rate_snapshot must have rate 1, got %q", ErrCurrencyMismatch, orderID, fx.RateToBase)
			}
			if ordCurr == targetCurr {
				return new(big.Int).Set(microScaleInt), nil
			}
			if baseCurr != targetCurr || quoteCurr != ordCurr {
				return nil, fmt.Errorf("%w: order %s exchange_rate_snapshot (%s->%s) does not match (%s->%s)", ErrCurrencyMismatch, orderID, quoteCurr, baseCurr, ordCurr, targetCurr)
			}
			return rateMicro, nil
		}
	}
	if ordCurr == targetCurr {
		return new(big.Int).Set(microScaleInt), nil
	}
	return nil, fmt.Errorf("%w: order %s currency %s != target currency %s and exchange_rate_snapshot is missing", ErrCurrencyMismatch, orderID, ordCurr, targetCurr)
}

func mulMicro(amountMicro, rateMicro *big.Int) *big.Int {
	if amountMicro == nil || rateMicro == nil || amountMicro.Sign() == 0 {
		return big.NewInt(0)
	}
	if rateMicro.Cmp(microScaleInt) == 0 {
		return new(big.Int).Set(amountMicro)
	}
	prod := new(big.Int).Mul(amountMicro, rateMicro)
	if prod.Sign() >= 0 {
		prod.Add(prod, halfMicroInt)
	} else {
		prod.Sub(prod, halfMicroInt)
	}
	return prod.Quo(prod, microScaleInt)
}

func lineGrossMicro(li AnalyticsOrderLine) *big.Int {
	if li.Total != nil {
		return decToMicro(*li.Total)
	}
	unitMicro := big.NewInt(0)
	if li.UnitPrice != nil {
		unitMicro = decToMicro(*li.UnitPrice)
	}
	discMicro := big.NewInt(0)
	if li.Discount != nil {
		discMicro = decToMicro(*li.Discount)
	}
	qty := li.Quantity
	if qty < 0 {
		qty = 0
	}
	gross := new(big.Int).Mul(unitMicro, big.NewInt(qty))
	gross.Sub(gross, discMicro)
	return gross
}

func buildSkuKeySet(skus []ProductSku) map[string]bool {
	set := make(map[string]bool, len(skus)*2)
	for _, s := range skus {
		if s.SkuID != "" {
			set[s.SkuID] = true
		}
		if s.SkuCode != "" {
			set[s.SkuCode] = true
		}
	}
	return set
}

func lineMatchesProduct(li AnalyticsOrderLine, productID string, skuKeys map[string]bool) bool {
	if li.ProductID != "" && li.ProductID == productID {
		return true
	}
	if li.SkuID != "" && skuKeys[li.SkuID] {
		return true
	}
	if li.Sku != "" && skuKeys[li.Sku] {
		return true
	}
	return false
}

func computeProductSalesSummary(
	p *Product,
	mvCount int32,
	lowStockCount int32,
	orders []AnalyticsOrder,
	refunds []AnalyticsRefund,
	filter SalesStatsFilter,
) (*ProductSalesSummary, error) {
	targetCurr := strings.ToUpper(strings.TrimSpace(p.Currency))
	if targetCurr == "" {
		targetCurr = "VND"
	}
	skuKeys := buildSkuKeySet(p.SKUs)
	baseCogsMicro := big.NewInt(0)
	if p.COGS != nil {
		baseCogsMicro = decToMicro(*p.COGS)
	}

	refundsByOrder := make(map[string][]AnalyticsRefund)
	for _, r := range refunds {
		if strings.EqualFold(r.LifecycleState, "completed") || strings.EqualFold(r.LifecycleState, "succeeded") {
			refundsByOrder[r.OrderID] = append(refundsByOrder[r.OrderID], r)
		}
	}

	var (
		orderCount  int32
		unitsSold   int32
		refundCount int32
	)
	totalGrossMicro := big.NewInt(0)
	totalRefundAllocatedMicro := big.NewInt(0)
	totalCogsMicro := big.NewInt(0)

	for _, o := range orders {
		state := strings.ToLower(strings.TrimSpace(o.LifecycleState))
		if state == "cancelled" {
			continue
		}
		if filter.Since != nil || filter.Until != nil {
			if o.OrderedAt.IsZero() {
				continue
			}
			if filter.Since != nil && o.OrderedAt.Before(*filter.Since) {
				continue
			}
			if filter.Until != nil && o.OrderedAt.After(*filter.Until) {
				continue
			}
		}

		var lines []AnalyticsOrderLine
		if len(o.Items) > 0 {
			lines = o.Items
		} else if o.ProductID != "" {
			amt := o.Amount
			lines = []AnalyticsOrderLine{{
				ProductID: o.ProductID,
				Quantity:  1,
				Total:     &amt,
			}}
		}
		if len(lines) == 0 {
			continue
		}

		ordTotalGrossMicro := big.NewInt(0)
		prodOrderGrossOrdMicro := big.NewInt(0)
		prodOrderCogsTargetMicro := big.NewInt(0)
		var prodOrderUnits int64
		matched := false

		type prodBucket struct {
			key      string
			firstIdx int
			grossOrd *big.Int
		}
		var buckets []*prodBucket
		bucketByKey := make(map[string]*prodBucket)

		// Check if any line in this order matches the product first
		for idx, li := range lines {
			lg := lineGrossMicro(li)
			ordTotalGrossMicro.Add(ordTotalGrossMicro, lg)
			bKey := strings.TrimSpace(li.ProductID)
			if lineMatchesProduct(li, p.ProductID, skuKeys) {
				matched = true
				prodOrderUnits += li.Quantity
				prodOrderGrossOrdMicro.Add(prodOrderGrossOrdMicro, lg)
				bKey = p.ProductID
			} else if bKey == "" {
				if strings.TrimSpace(li.SkuID) != "" {
					bKey = strings.TrimSpace(li.SkuID)
				} else if strings.TrimSpace(li.Sku) != "" {
					bKey = strings.TrimSpace(li.Sku)
				} else {
					bKey = fmt.Sprintf("line-%d", idx)
				}
			}
			b, ok := bucketByKey[bKey]
			if !ok {
				b = &prodBucket{key: bKey, firstIdx: idx, grossOrd: big.NewInt(0)}
				bucketByKey[bKey] = b
				buckets = append(buckets, b)
			}
			b.grossOrd.Add(b.grossOrd, lg)
		}
		if !matched {
			continue
		}
		if ordTotalGrossMicro.Sign() <= 0 {
			ordTotalGrossMicro.Set(decToMicro(o.Amount))
		}

		rateMicro, err := resolveOrderRateMicro(o.OrderID, o.Currency, targetCurr, o.ExchangeRateSnapshot)
		if err != nil {
			return nil, err
		}

		for _, li := range lines {
			if !lineMatchesProduct(li, p.ProductID, skuKeys) {
				continue
			}
			var lineCogsTarget *big.Int
			if li.UnitCOGS != nil {
				unitCogsTarget := mulMicro(decToMicro(*li.UnitCOGS), rateMicro)
				lineCogsTarget = new(big.Int).Mul(unitCogsTarget, big.NewInt(li.Quantity))
			} else {
				lineCogsTarget = new(big.Int).Mul(baseCogsMicro, big.NewInt(li.Quantity))
			}
			prodOrderCogsTargetMicro.Add(prodOrderCogsTargetMicro, lineCogsTarget)
		}

		prodGrossTargetMicro := mulMicro(prodOrderGrossOrdMicro, rateMicro)
		ordTotalGrossTargetMicro := mulMicro(ordTotalGrossMicro, rateMicro)

		// Compute allocated refund for this product in this order (Data F6)
		ordRefunds := refundsByOrder[o.OrderID]
		orderLevelRefundTargetMicro := big.NewInt(0)
		directProductRefundTargetMicro := big.NewInt(0)
		var ordRefundCnt int32

		for _, r := range ordRefunds {
			rCurr := strings.ToUpper(strings.TrimSpace(r.Currency))
			var rTargetMicro *big.Int
			if rCurr == "" || strings.EqualFold(rCurr, o.Currency) {
				rTargetMicro = mulMicro(decToMicro(r.Amount), rateMicro)
			} else if rCurr == targetCurr {
				rTargetMicro = decToMicro(r.Amount)
			} else {
				return nil, fmt.Errorf("%w: refund %s currency %s mismatches order currency %s", ErrCurrencyMismatch, r.RefundID, r.Currency, o.Currency)
			}

			if r.ProductID != "" {
				if r.ProductID == p.ProductID {
					directProductRefundTargetMicro.Add(directProductRefundTargetMicro, rTargetMicro)
					ordRefundCnt++
				}
			} else {
				orderLevelRefundTargetMicro.Add(orderLevelRefundTargetMicro, rTargetMicro)
				ordRefundCnt++
			}
		}

		// If the order is in 'refunded' state without explicit refund rows, treat as 100% refunded
		if state == "refunded" && len(ordRefunds) == 0 {
			orderLevelRefundTargetMicro.Set(ordTotalGrossTargetMicro)
			ordRefundCnt = 1
		}

		allocatedRefundMicro := new(big.Int).Set(directProductRefundTargetMicro)
		if orderLevelRefundTargetMicro.Sign() > 0 && ordTotalGrossTargetMicro.Sign() > 0 && prodGrossTargetMicro.Sign() > 0 {
			refundPool := new(big.Int).Set(orderLevelRefundTargetMicro)
			if refundPool.Cmp(ordTotalGrossTargetMicro) > 0 {
				refundPool.Set(ordTotalGrossTargetMicro)
			}
			// Largest-remainder exact micro allocation across distinct product buckets in the order
			type allocEntry struct {
				key      string
				firstIdx int
				gross    *big.Int
				quotient *big.Int
				rem      *big.Int
			}
			allocs := make([]allocEntry, 0, len(buckets))
			sumQuot := big.NewInt(0)
			for _, b := range buckets {
				bGross := mulMicro(b.grossOrd, rateMicro)
				num := new(big.Int).Mul(refundPool, bGross)
				q, r := new(big.Int).QuoRem(num, ordTotalGrossTargetMicro, new(big.Int))
				sumQuot.Add(sumQuot, q)
				allocs = append(allocs, allocEntry{
					key:      b.key,
					firstIdx: b.firstIdx,
					gross:    bGross,
					quotient: q,
					rem:      r,
				})
			}
			leftover := new(big.Int).Sub(refundPool, sumQuot).Int64()
			if leftover > 0 {
				sort.Slice(allocs, func(i, j int) bool {
					if cmp := allocs[i].rem.Cmp(allocs[j].rem); cmp != 0 {
						return cmp > 0
					}
					if cmp := allocs[i].gross.Cmp(allocs[j].gross); cmp != 0 {
						return cmp > 0
					}
					return allocs[i].firstIdx < allocs[j].firstIdx
				})
				for i := int64(0); i < leftover && int(i) < len(allocs); i++ {
					allocs[i].quotient.Add(allocs[i].quotient, big.NewInt(1))
				}
			}
			for _, a := range allocs {
				if a.key == p.ProductID {
					allocatedRefundMicro.Add(allocatedRefundMicro, a.quotient)
					break
				}
			}
		}
		if allocatedRefundMicro.Cmp(prodGrossTargetMicro) > 0 {
			allocatedRefundMicro.Set(prodGrossTargetMicro)
		}

		orderCount++
		unitsSold += int32(prodOrderUnits)
		refundCount += ordRefundCnt
		totalGrossMicro.Add(totalGrossMicro, prodGrossTargetMicro)
		totalRefundAllocatedMicro.Add(totalRefundAllocatedMicro, allocatedRefundMicro)
		totalCogsMicro.Add(totalCogsMicro, prodOrderCogsTargetMicro)
	}

	netMicro := new(big.Int).Sub(totalGrossMicro, totalRefundAllocatedMicro)
	if netMicro.Sign() < 0 {
		netMicro = big.NewInt(0)
	}
	profitMicro := new(big.Int).Sub(netMicro, totalCogsMicro)

	return &ProductSalesSummary{
		ProductID:          p.ProductID,
		OrderCount:         orderCount,
		UnitsSold:          unitsSold,
		RefundCount:        refundCount,
		GrossRevenue:       microToDec(totalGrossMicro),
		NetRevenue:         microToDec(netMicro),
		TotalCOGS:          microToDec(totalCogsMicro),
		TotalProfit:        microToDec(profitMicro),
		Currency:           targetCurr,
		StockMovements:     mvCount,
		LowStockAlertCount: lowStockCount,
	}, nil
}

func computeProductSalesChart(
	p *Product,
	days int,
	orders []AnalyticsOrder,
	filter SalesStatsFilter,
) ([]SalesChartDataPoint, error) {
	if days <= 0 {
		days = 30
	}
	targetCurr := strings.ToUpper(strings.TrimSpace(p.Currency))
	if targetCurr == "" {
		targetCurr = "VND"
	}
	skuKeys := buildSkuKeySet(p.SKUs)

	refNow := time.Now().UTC()
	if filter.Until != nil && !filter.Until.IsZero() {
		refNow = filter.Until.UTC()
	}
	cutoff := refNow.Add(-time.Duration(days) * 24 * time.Hour)

	type dayAgg struct {
		day       time.Time
		unitsSold int32
		revMicro  *big.Int
	}
	buckets := make(map[string]*dayAgg)

	for _, o := range orders {
		state := strings.ToLower(strings.TrimSpace(o.LifecycleState))
		if state == "cancelled" || state == "refunded" {
			continue
		}
		if o.OrderedAt.IsZero() || o.OrderedAt.Before(cutoff) || o.OrderedAt.After(refNow) {
			continue
		}
		var lines []AnalyticsOrderLine
		if len(o.Items) > 0 {
			lines = o.Items
		} else if o.ProductID != "" {
			amt := o.Amount
			lines = []AnalyticsOrderLine{{
				ProductID: o.ProductID,
				Quantity:  1,
				Total:     &amt,
			}}
		}
		var matchedLines []AnalyticsOrderLine
		for _, li := range lines {
			if lineMatchesProduct(li, p.ProductID, skuKeys) {
				matchedLines = append(matchedLines, li)
			}
		}
		if len(matchedLines) == 0 {
			continue
		}

		rateMicro, err := resolveOrderRateMicro(o.OrderID, o.Currency, targetCurr, o.ExchangeRateSnapshot)
		if err != nil {
			return nil, err
		}

		bucketDay := o.OrderedAt.UTC().Truncate(24 * time.Hour)
		key := bucketDay.Format("2006-01-02")
		agg, ok := buckets[key]
		if !ok {
			agg = &dayAgg{day: bucketDay, revMicro: big.NewInt(0)}
			buckets[key] = agg
		}
		for _, li := range matchedLines {
			agg.unitsSold += int32(li.Quantity)
			agg.revMicro.Add(agg.revMicro, mulMicro(lineGrossMicro(li), rateMicro))
		}
	}

	var keys []string
	for k := range buckets {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	points := make([]SalesChartDataPoint, 0, len(keys))
	for _, k := range keys {
		agg := buckets[k]
		points = append(points, SalesChartDataPoint{
			Date:      agg.day,
			UnitsSold: agg.unitsSold,
			Revenue:   microToDec(agg.revMicro),
		})
	}
	return points, nil
}

func computeProductRank(
	allProducts []*Product,
	targetProductID string,
	orders []AnalyticsOrder,
) (*ProductRankSummary, error) {
	var target *Product
	for _, p := range allProducts {
		if p.ProductID == targetProductID {
			target = p
			break
		}
	}
	if target == nil {
		return nil, ErrProductNotFound
	}

	normCurrency := strings.ToUpper(strings.TrimSpace(target.Currency))
	if normCurrency == "" {
		normCurrency = "VND"
	}

	type perfEntry struct {
		product    *Product
		skuKeys    map[string]bool
		unitsSold  int64
		grossMicro *big.Int
	}
	entries := make([]*perfEntry, 0, len(allProducts))
	for _, p := range allProducts {
		entries = append(entries, &perfEntry{
			product:    p,
			skuKeys:    buildSkuKeySet(p.SKUs),
			grossMicro: big.NewInt(0),
		})
	}

	for _, o := range orders {
		state := strings.ToLower(strings.TrimSpace(o.LifecycleState))
		if state == "cancelled" || state == "refunded" {
			continue
		}
		var lines []AnalyticsOrderLine
		if len(o.Items) > 0 {
			lines = o.Items
		} else if o.ProductID != "" {
			amt := o.Amount
			lines = []AnalyticsOrderLine{{
				ProductID: o.ProductID,
				Quantity:  1,
				Total:     &amt,
			}}
		}
		if len(lines) == 0 {
			continue
		}

		// Check if any product in workspace matches this order
		var orderMatched bool
		for _, li := range lines {
			for _, ent := range entries {
				if lineMatchesProduct(li, ent.product.ProductID, ent.skuKeys) {
					orderMatched = true
					break
				}
			}
			if orderMatched {
				break
			}
		}
		if !orderMatched {
			continue
		}

		rateMicro, err := resolveOrderRateMicro(o.OrderID, o.Currency, normCurrency, o.ExchangeRateSnapshot)
		if err != nil {
			return nil, err
		}

		for _, li := range lines {
			lgTarget := mulMicro(lineGrossMicro(li), rateMicro)
			for _, ent := range entries {
				if lineMatchesProduct(li, ent.product.ProductID, ent.skuKeys) {
					ent.unitsSold += li.Quantity
					ent.grossMicro.Add(ent.grossMicro, lgTarget)
				}
			}
		}
	}

	sort.Slice(entries, func(i, j int) bool {
		if entries[i].unitsSold != entries[j].unitsSold {
			return entries[i].unitsSold > entries[j].unitsSold
		}
		if cmp := entries[i].grossMicro.Cmp(entries[j].grossMicro); cmp != 0 {
			return cmp > 0
		}
		if !entries[i].product.CreatedAt.Equal(entries[j].product.CreatedAt) {
			return entries[i].product.CreatedAt.Before(entries[j].product.CreatedAt)
		}
		return entries[i].product.ProductID < entries[j].product.ProductID
	})

	var wsRank, catRank int32
	var catIdx int32
	for idx, ent := range entries {
		if strings.EqualFold(ent.product.Category, target.Category) {
			catIdx++
		}
		if ent.product.ProductID == targetProductID {
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

// ============================================================================
// Atomic Idempotent Mutation Transaction Support (Data F1)
// ============================================================================

type txEventBufferKey struct{}
type txStoreContextKey struct{}

func storeFromContext(ctx context.Context, fallback Store) Store {
	if ctx != nil {
		if st, ok := ctx.Value(txStoreContextKey{}).(Store); ok && st != nil {
			return st
		}
	}
	return fallback
}

type txEventBuffer struct {
	mu     sync.Mutex
	events []OutboxEvent
}

func withTxEventBuffer(ctx context.Context) (context.Context, *txEventBuffer) {
	buf := &txEventBuffer{}
	return context.WithValue(ctx, txEventBufferKey{}, buf), buf
}

func txEventBufferFromContext(ctx context.Context) (*txEventBuffer, bool) {
	if ctx == nil {
		return nil, false
	}
	buf, ok := ctx.Value(txEventBufferKey{}).(*txEventBuffer)
	return buf, ok && buf != nil
}

func unwrapConcreteStore(store Store) any {
	if store == nil {
		return nil
	}
	switch st := store.(type) {
	case *PostgresStore:
		return st
	case *MemoryStore:
		return st
	}
	v := reflect.ValueOf(store)
	for v.IsValid() && (v.Kind() == reflect.Ptr || v.Kind() == reflect.Interface) {
		if v.IsNil() {
			return nil
		}
		if v.CanInterface() {
			switch st := v.Interface().(type) {
			case *PostgresStore:
				return st
			case *MemoryStore:
				return st
			}
		}
		v = v.Elem()
	}
	if v.IsValid() && v.Kind() == reflect.Struct {
		for i := 0; i < v.NumField(); i++ {
			f := v.Field(i)
			if f.CanInterface() {
				if inner, ok := f.Interface().(Store); ok && inner != nil {
					if res := unwrapConcreteStore(inner); res != nil {
						return res
					}
				}
			}
		}
	}
	return nil
}

func unwrapStorePool(store Store) *pgxpool.Pool {
	if store == nil {
		return nil
	}
	v := reflect.ValueOf(store)
	for v.IsValid() && (v.Kind() == reflect.Ptr || v.Kind() == reflect.Interface) {
		if v.IsNil() {
			return nil
		}
		v = v.Elem()
	}
	if !v.IsValid() || v.Kind() != reflect.Struct {
		return nil
	}
	if !v.CanAddr() {
		cp := reflect.New(v.Type()).Elem()
		cp.Set(v)
		v = cp
	}
	poolType := reflect.TypeOf((*pgxpool.Pool)(nil))
	for i := 0; i < v.NumField(); i++ {
		f := v.Field(i)
		if f.Type() == poolType {
			if f.CanInterface() {
				if p, ok := f.Interface().(*pgxpool.Pool); ok && p != nil {
					return p
				}
			} else if f.CanAddr() {
				p := *(**pgxpool.Pool)(unsafe.Pointer(f.UnsafeAddr()))
				if p != nil {
					return p
				}
			}
		}
		if f.CanInterface() {
			if inner, ok := f.Interface().(Store); ok && inner != nil {
				if p := unwrapStorePool(inner); p != nil {
					return p
				}
			}
		}
	}
	return nil
}

type txPoolProductStore struct {
	*PostgresStore
	tx          pgx.Tx
	workspaceID string
	actorUserID string
}

func (s *txPoolProductStore) insertOutboxEventTx(
	ctx context.Context,
	targetStream, eventType, aggregateType, aggregateID, workspaceID string,
	payloadJSON, metaJSON []byte,
) error {
	if len(payloadJSON) == 0 {
		payloadJSON = []byte(`{}`)
	}
	if len(metaJSON) == 0 {
		metaJSON = []byte(`{}`)
	}
	_, err := s.tx.Exec(ctx, `
		INSERT INTO event_outbox (
			event_id, event_type, target_stream, aggregate_type, aggregate_id,
			workspace_id, payload, metadata
		) VALUES (
			$1::uuid, $2, $3, $4, $5::uuid,
			$6::uuid, $7::jsonb, $8::jsonb
		)
	`, newUUID(), eventType, targetStream, aggregateType, aggregateID, workspaceID, payloadJSON, metaJSON)
	return err
}

func (s *txPoolProductStore) insertAuditEventTx(
	ctx context.Context,
	workspaceID, action, resourceType, resourceID string,
	changesJSON []byte,
) error {
	if len(changesJSON) == 0 {
		changesJSON = []byte(`{}`)
	}
	_, err := s.tx.Exec(ctx, `
		INSERT INTO audit_events (
			audit_event_id, workspace_id, actor_user_id, actor_type,
			action, resource_type, resource_id, changes, reason
		) VALUES (
			$1::uuid, $2::uuid, $3::uuid, 'user',
			$4, $5, $6::uuid, $7::jsonb, ''
		)
	`, newUUID(), workspaceID, s.actorUserID, action, resourceType, resourceID, changesJSON)
	return err
}

func (s *txPoolProductStore) CreateProduct(ctx context.Context, p *Product) error {
	if p == nil {
		return ErrInvalidInput
	}
	if err := s.PostgresStore.CreateProduct(ctx, p); err != nil {
		return err
	}
	payloadBytes, err := json.Marshal(map[string]any{
		"product_id":     p.ProductID,
		"workspace_id":   p.WorkspaceID,
		"type":           string(p.ProductType),
		"title":          p.Title,
		"catalog_status": string(p.CatalogStatus),
		"sku_count":      len(p.SKUs),
	})
	if err != nil {
		return err
	}
	metaBytes, err := json.Marshal(map[string]any{
		"actor_id":      s.actorUserID,
		"actor_type":    "user",
		"required_perm": "product:manage",
	})
	if err != nil {
		return err
	}
	if err := s.insertOutboxEventTx(ctx, "search_indexing", "product.created", "product", p.ProductID, p.WorkspaceID, payloadBytes, metaBytes); err != nil {
		return err
	}
	return s.insertAuditEventTx(ctx, p.WorkspaceID, "product.created", "product", p.ProductID, payloadBytes)
}

func (s *txPoolProductStore) UpdateProduct(ctx context.Context, p *Product) error {
	if p == nil {
		return ErrInvalidInput
	}
	prevStatus := p.PreviousCatalogStatus
	if prevStatus == "" {
		if existing, err := s.PostgresStore.GetProduct(ctx, p.WorkspaceID, p.ProductID); err == nil && existing != nil {
			prevStatus = existing.CatalogStatus
		}
	}
	if err := s.PostgresStore.UpdateProduct(ctx, p); err != nil {
		return err
	}
	if prevStatus != "" && prevStatus != p.CatalogStatus {
		payloadBytes, _ := json.Marshal(map[string]any{
			"product_id":     p.ProductID,
			"workspace_id":   p.WorkspaceID,
			"from":           prevStatus,
			"to":             string(p.CatalogStatus),
			"catalog_status": string(p.CatalogStatus),
		})
		metaBytes, _ := json.Marshal(map[string]any{
			"actor_id":      s.actorUserID,
			"actor_type":    "user",
			"required_perm": "product:manage",
		})
		if err := s.insertOutboxEventTx(ctx, "search_indexing", "product.catalog_status_changed", "product", p.ProductID, p.WorkspaceID, payloadBytes, metaBytes); err != nil {
			return err
		}
	}
	return nil
}

func (s *txPoolProductStore) ArchiveProduct(ctx context.Context, workspaceID, productID string) error {
	existing, err := s.PostgresStore.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return err
	}
	if err := s.PostgresStore.ArchiveProduct(ctx, workspaceID, productID); err != nil {
		return err
	}
	if existing.CatalogStatus != StatusArchived {
		payloadBytes, _ := json.Marshal(map[string]any{
			"product_id":     productID,
			"workspace_id":   workspaceID,
			"from":           existing.CatalogStatus,
			"to":             StatusArchived,
			"catalog_status": StatusArchived,
		})
		metaBytes, _ := json.Marshal(map[string]any{
			"actor_id":      s.actorUserID,
			"actor_type":    "user",
			"required_perm": "product:manage",
		})
		if err := s.insertOutboxEventTx(ctx, "search_indexing", "product.catalog_status_changed", "product", productID, workspaceID, payloadBytes, metaBytes); err != nil {
			return err
		}
	}
	return nil
}

func (s *txPoolProductStore) BulkArchiveProducts(ctx context.Context, workspaceID string, productIDs []string) (int, error) {
	type priorProductState struct {
		productID string
		status    string
	}
	var priorStates []priorProductState
	seen := make(map[string]struct{}, len(productIDs))
	for _, pid := range productIDs {
		if _, dup := seen[pid]; dup {
			continue
		}
		seen[pid] = struct{}{}
		if existing, err := s.PostgresStore.GetProduct(ctx, workspaceID, pid); err == nil && existing != nil && existing.CatalogStatus != StatusArchived {
			priorStates = append(priorStates, priorProductState{
				productID: existing.ProductID,
				status:    string(existing.CatalogStatus),
			})
		}
	}
	count, err := s.PostgresStore.BulkArchiveProducts(ctx, workspaceID, productIDs)
	if err != nil {
		return 0, err
	}
	for _, prior := range priorStates {
		payloadBytes, _ := json.Marshal(map[string]any{
			"product_id":     prior.productID,
			"workspace_id":   workspaceID,
			"from":           prior.status,
			"to":             StatusArchived,
			"catalog_status": StatusArchived,
		})
		metaBytes, _ := json.Marshal(map[string]any{
			"actor_id":      s.actorUserID,
			"actor_type":    "user",
			"required_perm": "product:manage",
		})
		if err := s.insertOutboxEventTx(ctx, "search_indexing", "product.catalog_status_changed", "product", prior.productID, workspaceID, payloadBytes, metaBytes); err != nil {
			return 0, err
		}
	}
	return count, nil
}

func (s *txPoolProductStore) UpdateSkuStock(ctx context.Context, workspaceID, skuID string, delta int32) (int32, error) {
	newQty, err := s.PostgresStore.UpdateSkuStock(ctx, workspaceID, skuID, delta)
	if err != nil {
		return 0, err
	}
	meta, _ := StockAdjustmentMetaFromContext(ctx)
	reason := meta.Reason
	if reason == "" {
		reason = "manual_adjustment"
	}
	payloadMap := map[string]any{
		"sku_id":        skuID,
		"workspace_id":  workspaceID,
		"movement_type": "adjustment",
		"quantity":      delta,
		"delta":         delta,
		"reason":        reason,
		"new_quantity":  newQty,
	}
	if meta.Result != nil {
		if meta.Result.MovementID != "" {
			payloadMap["movement_id"] = meta.Result.MovementID
		}
		if meta.Result.LocationID != "" {
			payloadMap["location_id"] = meta.Result.LocationID
		}
		if meta.Result.MovementType != "" {
			payloadMap["movement_type"] = meta.Result.MovementType
		}
	}
	payloadBytes, _ := json.Marshal(payloadMap)
	metaBytes, _ := json.Marshal(map[string]any{
		"actor_id":      s.actorUserID,
		"actor_type":    "user",
		"required_perm": "inventory:adjust",
	})
	if err := s.insertOutboxEventTx(ctx, "analytics_events", "inventory.stock_moved", "product_sku", skuID, workspaceID, payloadBytes, metaBytes); err != nil {
		return 0, err
	}
	if err := s.insertAuditEventTx(ctx, workspaceID, "inventory.stock_moved", "product_sku", skuID, payloadBytes); err != nil {
		return 0, err
	}
	return newQty, nil
}

var productVietnameseSearchSynonyms = []struct {
	triggers []string
	phrases  string
}{
	{
		triggers: []string{"đơn hàng", "don hang", "hoá đơn", "hóa đơn", "hoa don", "order"},
		phrases:  "order đơn hàng hoá đơn hóa đơn don hang hoa don",
	},
	{
		triggers: []string{"sản phẩm", "san pham", "hàng hóa", "hàng hoá", "hang hoa", "product"},
		phrases:  "product sản phẩm hàng hóa hàng hoá san pham hang hoa",
	},
	{
		triggers: []string{"khách hàng", "khach hang", "người mua", "nguoi mua", "customer"},
		phrases:  "customer khách hàng người mua khach hang nguoi mua",
	},
}

func splitProductSearchWords(input string) []string {
	return strings.FieldsFunc(strings.ToLower(strings.TrimSpace(input)), func(r rune) bool {
		return r == ' ' || r == '\t' || r == '\n' || r == '\r' || r == ',' || r == ';' || r == '.' || r == ':' || r == '/' || r == '\\'
	})
}

func buildProductSearchTokens(parts ...string) ([]string, string) {
	seen := make(map[string]struct{})
	var ordered []string
	var rawBuilder strings.Builder
	addPhrase := func(phrase string) {
		trimmed := strings.TrimSpace(phrase)
		if trimmed == "" {
			return
		}
		lower := strings.ToLower(trimmed)
		if rawBuilder.Len() > 0 {
			rawBuilder.WriteByte(' ')
		}
		rawBuilder.WriteString(lower)
		for _, tok := range splitProductSearchWords(lower) {
			if tok == "" {
				continue
			}
			if _, exists := seen[tok]; !exists {
				seen[tok] = struct{}{}
				ordered = append(ordered, tok)
			}
		}
	}
	for _, p := range parts {
		addPhrase(p)
	}
	baseText := rawBuilder.String()
	for _, grp := range productVietnameseSearchSynonyms {
		matched := false
		for _, trig := range grp.triggers {
			if strings.Contains(trig, " ") {
				if strings.Contains(baseText, trig) {
					matched = true
					break
				}
			} else if _, hasTok := seen[trig]; hasTok {
				matched = true
				break
			}
		}
		if matched {
			addPhrase(grp.phrases)
		}
	}
	return ordered, rawBuilder.String()
}

func formatSearchDecimal6(d *tenantdb.ExactDecimal) string {
	if d == nil {
		return "0.000000"
	}
	s := strings.TrimSpace(d.String())
	if s == "" {
		return "0.000000"
	}
	if !strings.Contains(s, ".") {
		return s + ".000000"
	}
	parts := strings.SplitN(s, ".", 2)
	frac := parts[1]
	for len(frac) < 6 {
		frac += "0"
	}
	if len(frac) > 6 {
		frac = frac[:6]
	}
	return parts[0] + "." + frac
}

func refreshProductSearchIndexMetadata(p *Product) {
	if p == nil || p.Metadata == nil {
		return
	}
	rawIdx, exists := p.Metadata["search_index"]
	if !exists || rawIdx == nil {
		return
	}
	var existingMap map[string]any
	if m, ok := rawIdx.(map[string]any); ok {
		existingMap = m
	} else if b, err := json.Marshal(rawIdx); err == nil {
		_ = json.Unmarshal(b, &existingMap)
	}

	skuCodes := make([]string, 0)
	var totalStock, reservedStock int64
	var activeSKUs, lowStockSKUs int
	if len(p.SKUs) > 0 {
		for _, sku := range p.SKUs {
			if !sku.IsActive {
				continue
			}
			activeSKUs++
			skuCodes = append(skuCodes, sku.SkuCode)
			totalStock += int64(sku.StockQuantity)
			reservedStock += int64(sku.StockReserved)
			if int64(sku.StockQuantity)-int64(sku.StockReserved) <= int64(sku.LowStockThreshold) {
				lowStockSKUs++
			}
		}
	} else if existingMap != nil {
		if codes, ok := existingMap["sku_codes"].([]any); ok {
			for _, c := range codes {
				if s, ok := c.(string); ok {
					skuCodes = append(skuCodes, s)
				}
			}
		} else if codes, ok := existingMap["sku_codes"].([]string); ok {
			skuCodes = append(skuCodes, codes...)
		}
		if v, ok := existingMap["sku_count"].(float64); ok {
			activeSKUs = int(v)
		} else if v, ok := existingMap["sku_count"].(int); ok {
			activeSKUs = v
		}
		if v, ok := existingMap["total_stock"].(float64); ok {
			totalStock = int64(v)
		} else if v, ok := existingMap["total_stock"].(int64); ok {
			totalStock = v
		}
		if v, ok := existingMap["reserved_stock"].(float64); ok {
			reservedStock = int64(v)
		} else if v, ok := existingMap["reserved_stock"].(int64); ok {
			reservedStock = v
		}
		if v, ok := existingMap["low_stock_sku_count"].(float64); ok {
			lowStockSKUs = int(v)
		} else if v, ok := existingMap["low_stock_sku_count"].(int); ok {
			lowStockSKUs = v
		}
	}

	availableStock := totalStock - reservedStock
	inStock := !p.InventoryEnabled || availableStock > 0
	basePriceStr := formatSearchDecimal6(p.BasePrice)
	curr := strings.TrimSpace(p.Currency)
	if curr == "" {
		curr = "VND"
	}
	tokenParts := append([]string{p.Title, p.Description, p.Category, p.ProductType}, skuCodes...)
	tokens, searchableText := buildProductSearchTokens(tokenParts...)

	lastEventID := ""
	if existingMap != nil {
		if s, ok := existingMap["last_event_id"].(string); ok {
			lastEventID = s
		}
	}
	if lastEventID == "" {
		prefix := p.ProductID
		if len(prefix) > 8 {
			prefix = prefix[:8]
		}
		lastEventID = "sync_" + prefix
	}

	versionSum := sha256.Sum256([]byte(fmt.Sprintf(
		"%s|%s|%s|%s|%s|%s|%s|%s|%t|%d|%d|%d|%s|%s",
		p.WorkspaceID,
		p.ProductID,
		p.Title,
		p.Description,
		p.Category,
		p.ProductType,
		p.CatalogStatus,
		basePriceStr,
		p.InventoryEnabled,
		activeSKUs,
		totalStock,
		reservedStock,
		strings.Join(skuCodes, ","),
		lastEventID,
	)))
	docVersion := hex.EncodeToString(versionSum[:16])
	updatedUTC := p.UpdatedAt.UTC()
	if updatedUTC.IsZero() {
		updatedUTC = time.Now().UTC()
	}
	createdUTC := p.CreatedAt.UTC()
	if createdUTC.IsZero() {
		createdUTC = updatedUTC
	}

	p.Metadata["search_index"] = map[string]any{
		"document_id":         p.ProductID,
		"workspace_id":        p.WorkspaceID,
		"product_id":          p.ProductID,
		"title":               p.Title,
		"description":         p.Description,
		"category":            p.Category,
		"product_type":        p.ProductType,
		"catalog_status":      p.CatalogStatus,
		"base_price":          basePriceStr,
		"currency":            curr,
		"inventory_enabled":   p.InventoryEnabled,
		"sku_count":           activeSKUs,
		"sku_codes":           skuCodes,
		"total_stock":         totalStock,
		"reserved_stock":      reservedStock,
		"available_stock":     availableStock,
		"low_stock_sku_count": lowStockSKUs,
		"in_stock":            inStock,
		"search_tokens":       tokens,
		"searchable_text":     searchableText,
		"last_event_id":       lastEventID,
		"last_event_type":     "product.updated",
		"document_version":    docVersion,
		"product_created_at":  createdUTC,
		"product_updated_at":  updatedUTC,
		"indexed_at":          updatedUTC.Truncate(time.Microsecond),
	}
}

func beginStoreMutationTx(
	ctx context.Context,
	store Store,
	workspaceID string,
	idempotencyKey string,
) (context.Context, func() error, func(), error) {
	txCtx, evtBuf := withTxEventBuffer(ctx)
	concrete := unwrapConcreteStore(store)

	switch st := concrete.(type) {
	case *PostgresStore:
		lockKey := workspaceID + ":" + idempotencyKey
		if st.pool != nil {
			tx, err := st.pool.Begin(txCtx)
			if err != nil {
				return ctx, nil, nil, fmt.Errorf("begin idempotency tx: %w", err)
			}
			if _, err := tx.Exec(txCtx, "SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_workspace_id', $1, true)", workspaceID); err != nil {
				_ = tx.Rollback(txCtx)
				return ctx, nil, nil, fmt.Errorf("set workspace rls context: %w", err)
			}
			if _, err := tx.Exec(txCtx, "SELECT pg_advisory_xact_lock(hashtext($1))", lockKey); err != nil {
				_ = tx.Rollback(txCtx)
				return ctx, nil, nil, fmt.Errorf("acquire idempotency advisory lock: %w", err)
			}
			txCtx = context.WithValue(txCtx, pgTxContextKey{}, DBTX(tx))
			committed := false
			commitFn := func() error {
				if err := tx.Commit(txCtx); err != nil {
					return err
				}
				committed = true
				return nil
			}
			rollbackFn := func() {
				if !committed {
					evtBuf.mu.Lock()
					evtBuf.events = nil
					evtBuf.mu.Unlock()
					_ = tx.Rollback(txCtx)
				}
			}
			return txCtx, commitFn, rollbackFn, nil
		}
		// st.pool == nil (running inside an existing DBTX connection/transaction)
		db := st.dbFromContext(txCtx)
		sp := nextSavepointName()
		hasSavepoint := false
		if _, err := db.Exec(txCtx, "SAVEPOINT "+sp); err == nil {
			hasSavepoint = true
			_, _ = db.Exec(txCtx, "SELECT pg_advisory_xact_lock(hashtext($1))", lockKey)
		}
		txCtx = context.WithValue(txCtx, pgTxContextKey{}, db)
		committed := false
		commitFn := func() error {
			if hasSavepoint {
				if _, err := db.Exec(txCtx, "RELEASE SAVEPOINT "+sp); err != nil {
					return err
				}
			}
			committed = true
			return nil
		}
		rollbackFn := func() {
			if !committed {
				evtBuf.mu.Lock()
				evtBuf.events = nil
				evtBuf.mu.Unlock()
				if hasSavepoint {
					_, _ = db.Exec(txCtx, "ROLLBACK TO SAVEPOINT "+sp)
					_, _ = db.Exec(txCtx, "RELEASE SAVEPOINT "+sp)
				}
			}
		}
		return txCtx, commitFn, rollbackFn, nil

	case *MemoryStore:
		snap := st.takeSnapshot()
		committed := false
		commitFn := func() error {
			committed = true
			return nil
		}
		rollbackFn := func() {
			if !committed {
				evtBuf.mu.Lock()
				evtBuf.events = nil
				evtBuf.mu.Unlock()
				st.restoreSnapshot(snap)
			}
		}
		return txCtx, commitFn, rollbackFn, nil

	default:
		pool := unwrapStorePool(store)
		if pool == nil {
			return ctx, nil, nil, fmt.Errorf("%w: store does not support atomic idempotent transactions", ErrInvalidInput)
		}
		var principalWS, userID string
		requireMembership := true
		if principal, ok := transportauth.PrincipalFromContext(txCtx); ok && strings.TrimSpace(principal.UserID) != "" && strings.TrimSpace(principal.WorkspaceID) != "" {
			principalWS = strings.TrimSpace(principal.WorkspaceID)
			userID = strings.TrimSpace(principal.UserID)
			requireMembership = !principal.InternalAdmin
		} else if pctx, ok := rbac.PolicyContextFromContext(txCtx); ok && strings.TrimSpace(pctx.ActorUserID) != "" && strings.TrimSpace(pctx.WorkspaceID) != "" {
			principalWS = strings.TrimSpace(pctx.WorkspaceID)
			userID = strings.TrimSpace(pctx.ActorUserID)
		} else {
			return ctx, nil, nil, errors.New("unauthenticated workspace context")
		}
		if workspaceID != "" && principalWS != workspaceID {
			return ctx, nil, nil, ErrProductNotFound
		}
		if !tenantdb.IsValidNonZeroUUID(principalWS) || !tenantdb.IsValidNonZeroUUID(userID) {
			return ctx, nil, nil, fmt.Errorf("%w: workspace=%q user=%q", tenantdb.ErrInvalidTenantScope, principalWS, userID)
		}

		tx, err := pool.Begin(txCtx)
		if err != nil {
			return ctx, nil, nil, fmt.Errorf("tenantdb: begin transaction: %w", err)
		}
		if _, err := tx.Exec(txCtx, `SET LOCAL ROLE app_user`); err != nil {
			_ = tx.Rollback(txCtx)
			return ctx, nil, nil, fmt.Errorf("tenantdb: set local role app_user: %w", err)
		}
		var configuredTenant, configuredUser, configuredWS string
		if err := tx.QueryRow(txCtx, `
			SELECT
				set_config('app.current_tenant_id', $1, true),
				set_config('app.current_user_id', $2, true),
				set_config('app.current_workspace_id', $1, true)
		`, principalWS, userID).Scan(&configuredTenant, &configuredUser, &configuredWS); err != nil {
			_ = tx.Rollback(txCtx)
			return ctx, nil, nil, fmt.Errorf("tenantdb: set local tenant context: %w", err)
		}
		if configuredTenant != principalWS || configuredUser != userID || configuredWS != principalWS {
			_ = tx.Rollback(txCtx)
			return ctx, nil, nil, fmt.Errorf("%w: set_config verification mismatch", tenantdb.ErrInvalidTenantScope)
		}
		if requireMembership {
			var memberID, role string
			if err := tx.QueryRow(txCtx, `
				SELECT wm.member_id::text, wm.role
				FROM workspace_members wm
				JOIN workspaces w ON w.workspace_id = wm.workspace_id
				JOIN users u ON u.user_id = wm.user_id
				WHERE wm.workspace_id = $1::uuid
				  AND wm.user_id = $2::uuid
				  AND wm.status = 'active'
				  AND w.status = 'active'
				  AND u.status = 'active'
				LIMIT 1
			`, principalWS, userID).Scan(&memberID, &role); err != nil {
				_ = tx.Rollback(txCtx)
				if errors.Is(err, pgx.ErrNoRows) {
					return ctx, nil, nil, tenantdb.ErrMembershipRevokedOrMissing
				}
				return ctx, nil, nil, fmt.Errorf("tenantdb: verify active membership: %w", err)
			}
		}
		lockKey := principalWS + ":" + idempotencyKey
		if _, err := tx.Exec(txCtx, "SELECT pg_advisory_xact_lock(hashtext($1))", lockKey); err != nil {
			_ = tx.Rollback(txCtx)
			return ctx, nil, nil, fmt.Errorf("acquire idempotency advisory lock: %w", err)
		}
		txStore := &txPoolProductStore{
			PostgresStore: NewPostgresStoreTx(tx),
			tx:            tx,
			workspaceID:   principalWS,
			actorUserID:   userID,
		}
		txCtx = context.WithValue(txCtx, txStoreContextKey{}, Store(txStore))
		txCtx = context.WithValue(txCtx, pgTxContextKey{}, DBTX(tx))
		committed := false
		commitFn := func() error {
			if err := tx.Commit(txCtx); err != nil {
				return err
			}
			committed = true
			return nil
		}
		rollbackFn := func() {
			if !committed {
				evtBuf.mu.Lock()
				evtBuf.events = nil
				evtBuf.mu.Unlock()
				_ = tx.Rollback(context.Background())
			}
		}
		return txCtx, commitFn, rollbackFn, nil
	}
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

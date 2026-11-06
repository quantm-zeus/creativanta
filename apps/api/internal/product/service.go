package product

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type OutboxEvent struct {
	EventID       string
	EventType     string
	AggregateType string
	AggregateID   string
	WorkspaceID   string
	PayloadJSON   []byte
	CreatedAt     time.Time
}

type EventSink interface {
	Emit(ctx context.Context, evt OutboxEvent) error
}

type MemoryEventSink struct {
	mu     sync.RWMutex
	events []OutboxEvent
}

func NewMemoryEventSink() *MemoryEventSink {
	return &MemoryEventSink{events: make([]OutboxEvent, 0)}
}

func (s *MemoryEventSink) Emit(_ context.Context, evt OutboxEvent) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.events = append(s.events, evt)
	return nil
}

func (s *MemoryEventSink) Events() []OutboxEvent {
	s.mu.RLock()
	defer s.mu.RUnlock()
	cp := make([]OutboxEvent, len(s.events))
	copy(cp, s.events)
	return cp
}

type Clock func() time.Time

type Service struct {
	store          Store
	importEngine   *ImportEngine
	eventSink      EventSink
	clock          Clock
	productLocksMu sync.Mutex
	productLocks   map[string]*sync.Mutex
	idemLocksMu    sync.Mutex
	idemLocks      map[string]*sync.Mutex
}

func NewService(store Store, sink EventSink, clock Clock) *Service {
	if clock == nil {
		clock = func() time.Time { return time.Now().UTC() }
	}
	if sink == nil {
		sink = NewMemoryEventSink()
	}
	return &Service{
		store:        store,
		importEngine: NewImportEngine(store),
		eventSink:    sink,
		clock:        clock,
		productLocks: make(map[string]*sync.Mutex),
		idemLocks:    make(map[string]*sync.Mutex),
	}
}

func (s *Service) lockProduct(workspaceID, productID string) func() {
	key := workspaceID + ":" + productID
	s.productLocksMu.Lock()
	if s.productLocks == nil {
		s.productLocks = make(map[string]*sync.Mutex)
	}
	mu, ok := s.productLocks[key]
	if !ok {
		mu = &sync.Mutex{}
		s.productLocks[key] = mu
	}
	s.productLocksMu.Unlock()
	mu.Lock()
	return mu.Unlock
}

func (s *Service) lockIdempotency(workspaceID, idempotencyKey string) func() {
	key := workspaceID + ":" + idempotencyKey
	s.idemLocksMu.Lock()
	if s.idemLocks == nil {
		s.idemLocks = make(map[string]*sync.Mutex)
	}
	mu, ok := s.idemLocks[key]
	if !ok {
		mu = &sync.Mutex{}
		s.idemLocks[key] = mu
	}
	s.idemLocksMu.Unlock()
	mu.Lock()
	return mu.Unlock
}

func (s *Service) CreateProduct(ctx context.Context, p *Product) (*Product, error) {
	if p.ProductID == "" {
		p.ProductID = newUUID()
	}
	now := s.clock()
	p.CreatedAt = now
	p.UpdatedAt = now

	if err := p.Validate(); err != nil {
		return nil, err
	}

	// Default SKU if none provided
	if len(p.SKUs) == 0 {
		p.SKUs = []ProductSku{
			{
				SkuID:             newUUID(),
				WorkspaceID:       p.WorkspaceID,
				ProductID:         p.ProductID,
				SkuCode:           fmt.Sprintf("SKU-%s", p.ProductID[:8]),
				VariantAttributes: map[string]string{"type": "standard"},
				Currency:          p.Currency,
				PriceOverride:     p.BasePrice,
				CogsOverride:      p.COGS,
				LowStockThreshold: 5,
				IsActive:          true,
				CreatedAt:         now,
				UpdatedAt:         now,
			},
		}
	} else {
		for i := range p.SKUs {
			if p.SKUs[i].SkuID == "" {
				p.SKUs[i].SkuID = newUUID()
			}
			p.SKUs[i].ProductID = p.ProductID
			p.SKUs[i].WorkspaceID = p.WorkspaceID
			if p.SKUs[i].Currency == "" {
				p.SKUs[i].Currency = p.Currency
			}
			p.SKUs[i].CreatedAt = now
			p.SKUs[i].UpdatedAt = now
		}
	}

	if err := s.store.CreateProduct(ctx, p); err != nil {
		return nil, err
	}

	// Emit product.created domain event (§8)
	payload, _ := json.Marshal(map[string]any{
		"product_id": p.ProductID,
		"type":       p.ProductType,
	})
	_ = s.eventSink.Emit(ctx, OutboxEvent{
		EventID:       newUUID(),
		EventType:     "product.created",
		AggregateType: "product",
		AggregateID:   p.ProductID,
		WorkspaceID:   p.WorkspaceID,
		PayloadJSON:   payload,
		CreatedAt:     now,
	})

	return s.store.GetProduct(ctx, p.WorkspaceID, p.ProductID)
}

func (s *Service) GetProduct(ctx context.Context, workspaceID, productID string) (*Product, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetProduct(ctx, workspaceID, productID)
}

func (s *Service) ListProducts(ctx context.Context, workspaceID string, filter ListFilter, limit, offset int) ([]*Product, int64, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, 0, ErrMissingTenant
	}
	if limit <= 0 {
		limit = 20
	}
	if limit > 101 {
		limit = 101
	}
	if offset < 0 {
		offset = 0
	}
	return s.store.ListProducts(ctx, workspaceID, filter, limit, offset)
}

func (s *Service) UpdateProduct(ctx context.Context, p *Product) (*Product, error) {
	if strings.TrimSpace(p.WorkspaceID) == "" {
		return nil, ErrMissingTenant
	}
	if strings.TrimSpace(p.ProductID) == "" {
		return nil, fmt.Errorf("%w: product_id is required", ErrInvalidInput)
	}

	unlock := s.lockProduct(p.WorkspaceID, p.ProductID)
	defer unlock()

	existing, err := s.store.GetProduct(ctx, p.WorkspaceID, p.ProductID)
	if err != nil {
		return nil, err
	}

	if p.ExpectedUpdatedAt != nil {
		if !existing.UpdatedAt.UTC().Truncate(time.Microsecond).Equal(p.ExpectedUpdatedAt.UTC().Truncate(time.Microsecond)) {
			return nil, ErrConcurrencyConflict
		}
	}

	prevUpdatedAt := existing.UpdatedAt
	oldStatus := existing.CatalogStatus
	now := s.clock()
	if !now.After(prevUpdatedAt) {
		now = prevUpdatedAt.Add(time.Microsecond)
	}

	if p.Title != "" {
		existing.Title = p.Title
	}
	if p.Description != "" {
		existing.Description = p.Description
	}
	if p.Category != "" {
		existing.Category = p.Category
	}
	if p.BasePrice != nil {
		existing.BasePrice = p.BasePrice
	}
	if p.COGS != nil {
		existing.COGS = p.COGS
	}
	if p.CatalogStatus != "" && IsValidCatalogStatus(p.CatalogStatus) {
		existing.CatalogStatus = p.CatalogStatus
	}
	if len(p.ExternalRefs) > 0 {
		existing.ExternalRefs = p.ExternalRefs
	}
	if len(p.Images) > 0 {
		existing.Images = p.Images
	}
	if p.Metadata != nil {
		if existing.Metadata == nil {
			existing.Metadata = make(map[string]any)
		}
		for k, v := range p.Metadata {
			existing.Metadata[k] = v
		}
	}
	existing.ExpectedUpdatedAt = &prevUpdatedAt
	existing.PreviousCatalogStatus = oldStatus
	existing.UpdatedAt = now

	if err := existing.Validate(); err != nil {
		return nil, err
	}

	if err := s.store.UpdateProduct(ctx, existing); err != nil {
		return nil, err
	}

	// Check if catalog status changed -> emit product.catalog_status_changed
	if existing.CatalogStatus != oldStatus {
		payload, _ := json.Marshal(map[string]any{
			"product_id": existing.ProductID,
			"from":       oldStatus,
			"to":         existing.CatalogStatus,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "product.catalog_status_changed",
			AggregateType: "product",
			AggregateID:   existing.ProductID,
			WorkspaceID:   existing.WorkspaceID,
			PayloadJSON:   payload,
			CreatedAt:     now,
		})
	}

	return s.store.GetProduct(ctx, p.WorkspaceID, p.ProductID)
}

func (s *Service) DeleteProduct(ctx context.Context, workspaceID, productID string) error {
	if strings.TrimSpace(workspaceID) == "" {
		return ErrMissingTenant
	}
	unlock := s.lockProduct(workspaceID, productID)
	defer unlock()
	return s.store.DeleteProduct(ctx, workspaceID, productID)
}

func (s *Service) ArchiveProduct(ctx context.Context, workspaceID, productID string) (*Product, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	unlock := s.lockProduct(workspaceID, productID)
	defer unlock()

	existing, err := s.store.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return nil, err
	}
	oldStatus := existing.CatalogStatus
	if err := s.store.ArchiveProduct(ctx, workspaceID, productID); err != nil {
		return nil, err
	}
	now := s.clock()
	if oldStatus != StatusArchived {
		payload, _ := json.Marshal(map[string]any{
			"product_id": productID,
			"from":       oldStatus,
			"to":         StatusArchived,
		})
		_ = s.eventSink.Emit(ctx, OutboxEvent{
			EventID:       newUUID(),
			EventType:     "product.catalog_status_changed",
			AggregateType: "product",
			AggregateID:   productID,
			WorkspaceID:   workspaceID,
			PayloadJSON:   payload,
			CreatedAt:     now,
		})
	}
	return s.store.GetProduct(ctx, workspaceID, productID)
}

func (s *Service) BulkArchiveProducts(ctx context.Context, workspaceID string, productIDs []string) (int, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return 0, ErrMissingTenant
	}
	return s.store.BulkArchiveProducts(ctx, workspaceID, productIDs)
}

func (s *Service) BatchTagProducts(ctx context.Context, workspaceID string, productIDs, tagsToAdd, tagsToRemove []string) (int, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return 0, ErrMissingTenant
	}
	return s.store.BatchTag(ctx, workspaceID, productIDs, tagsToAdd, tagsToRemove)
}

func (s *Service) Import(
	ctx context.Context,
	workspaceID string,
	platform string,
	connectedAccountID string,
	rawData string,
	columnMappings map[string]string,
	defaultCurrency string,
	previewOnly bool,
	previewToken string,
) (*ImportResult, error) {
	res, err := s.importEngine.Process(
		ctx, workspaceID, platform, connectedAccountID, rawData,
		columnMappings, defaultCurrency, previewOnly, previewToken,
	)
	if err != nil {
		return res, err
	}

	// For committed products, emit product.created events
	if !previewOnly {
		now := s.clock()
		for _, p := range res.CreatedProducts {
			payload, _ := json.Marshal(map[string]any{
				"product_id": p.ProductID,
				"type":       p.ProductType,
			})
			_ = s.eventSink.Emit(ctx, OutboxEvent{
				EventID:       newUUID(),
				EventType:     "product.created",
				AggregateType: "product",
				AggregateID:   p.ProductID,
				WorkspaceID:   p.WorkspaceID,
				PayloadJSON:   payload,
				CreatedAt:     now,
			})
		}
	}
	return res, nil
}

func (s *Service) SearchProducts(ctx context.Context, workspaceID, query string, limit, offset int) ([]*Product, int64, error) {
	return s.ListProducts(ctx, workspaceID, ListFilter{SearchQuery: query}, limit, offset)
}

func (s *Service) GetLinkedContent(ctx context.Context, workspaceID, productID string) ([]ContentRef, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetLinkedContent(ctx, workspaceID, productID)
}

func (s *Service) LinkContent(ctx context.Context, workspaceID, productID string, ref ContentRef) (ContentRef, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return ContentRef{}, ErrMissingTenant
	}
	if ref.ContentID == "" {
		return ContentRef{}, fmt.Errorf("%w: content_id is required", ErrInvalidInput)
	}
	if ref.ContentType == "" {
		ref.ContentType = "general"
	}
	if ref.LinkedAt.IsZero() {
		ref.LinkedAt = s.clock()
	}
	unlock := s.lockProduct(workspaceID, productID)
	defer unlock()
	if err := s.store.LinkContent(ctx, workspaceID, productID, ref); err != nil {
		return ContentRef{}, err
	}
	return ref, nil
}

func (s *Service) UpdateStock(ctx context.Context, workspaceID, skuID string, delta int32, reason string) (int32, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return 0, ErrMissingTenant
	}
	if strings.TrimSpace(skuID) == "" {
		return 0, fmt.Errorf("%w: sku_id is required", ErrInvalidInput)
	}
	if delta == 0 {
		return 0, fmt.Errorf("%w: stock delta cannot be zero", ErrInvalidInput)
	}
	cleanReason := strings.TrimSpace(reason)
	if cleanReason == "" {
		return 0, fmt.Errorf("%w: stock adjustment reason is required", ErrInvalidInput)
	}

	meta, _ := StockAdjustmentMetaFromContext(ctx)
	ctx = WithStockAdjustmentMeta(ctx, cleanReason, meta.MovementKey)

	newQty, err := s.store.UpdateSkuStock(ctx, workspaceID, skuID, delta)
	if err != nil {
		return 0, err
	}

	payload, _ := json.Marshal(map[string]any{
		"sku_id":       skuID,
		"workspace_id": workspaceID,
		"delta":        delta,
		"reason":       cleanReason,
		"new_quantity": newQty,
	})
	_ = s.eventSink.Emit(ctx, OutboxEvent{
		EventID:       newUUID(),
		EventType:     "inventory.stock_moved",
		AggregateType: "product_sku",
		AggregateID:   skuID,
		WorkspaceID:   workspaceID,
		PayloadJSON:   payload,
		CreatedAt:     s.clock(),
	})

	return newQty, nil
}

func (s *Service) SetAlertThreshold(ctx context.Context, workspaceID, skuID string, threshold int32) error {
	if strings.TrimSpace(workspaceID) == "" {
		return ErrMissingTenant
	}
	return s.store.SetSkuAlertThreshold(ctx, workspaceID, skuID, threshold)
}

// Projections for extended commerce RPCs
func (s *Service) GetStats(ctx context.Context, workspaceID, productID string) (int32, *tenantdb.ExactDecimal, int32, int32, int32, error) {
	p, err := s.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return 0, nil, 0, 0, 0, err
	}
	var onHand, reserved, activeSkus int32
	for _, sku := range p.SKUs {
		if sku.IsActive {
			activeSkus++
		}
		onHand += sku.StockQuantity
		reserved += sku.StockReserved
	}
	summary, err := s.store.GetProductSalesSummary(ctx, workspaceID, productID)
	if err != nil {
		return 0, nil, 0, 0, 0, err
	}
	gross := summary.GrossRevenue
	return summary.UnitsSold, &gross, activeSkus, onHand, reserved, nil
}

func (s *Service) GetSalesSummary(ctx context.Context, workspaceID, productID string) (*ProductSalesSummary, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetProductSalesSummary(ctx, workspaceID, productID)
}

func (s *Service) GetSalesChart(ctx context.Context, workspaceID, productID string, days int) ([]SalesChartDataPoint, string, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, "", ErrMissingTenant
	}
	p, err := s.GetProduct(ctx, workspaceID, productID)
	if err != nil {
		return nil, "", err
	}
	pts, err := s.store.GetProductSalesChart(ctx, workspaceID, productID, days)
	if err != nil {
		return nil, "", err
	}
	curr := p.Currency
	if curr == "" {
		curr = "VND"
	}
	return pts, curr, nil
}

func (s *Service) GetRank(ctx context.Context, workspaceID, productID string) (*ProductRankSummary, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetProductRank(ctx, workspaceID, productID)
}

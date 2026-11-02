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
	store        Store
	importEngine *ImportEngine
	eventSink    EventSink
	clock        Clock
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
	}
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
	if limit > 100 {
		limit = 100
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
	existing, err := s.store.GetProduct(ctx, p.WorkspaceID, p.ProductID)
	if err != nil {
		return nil, err
	}

	oldStatus := existing.CatalogStatus
	now := s.clock()

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
	return s.store.DeleteProduct(ctx, workspaceID, productID)
}

func (s *Service) ArchiveProduct(ctx context.Context, workspaceID, productID string) (*Product, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
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
	if err := s.store.LinkContent(ctx, workspaceID, productID, ref); err != nil {
		return ContentRef{}, err
	}
	return ref, nil
}

func (s *Service) UpdateStock(ctx context.Context, workspaceID, skuID string, delta int32, _ string) (int32, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return 0, ErrMissingTenant
	}
	return s.store.UpdateSkuStock(ctx, workspaceID, skuID, delta)
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
	zero := tenantdb.ZeroDecimal()
	return 0, &zero, activeSkus, onHand, reserved, nil
}

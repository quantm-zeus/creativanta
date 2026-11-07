package product

import (
	"context"
	"crypto/rand"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func newUUID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

var (
	ErrProductNotFound         = errors.New("product: not found")
	ErrSkuNotFound             = errors.New("product sku: not found")
	ErrInvalidInput            = errors.New("product: invalid input")
	ErrMissingTenant           = errors.New("product: missing tenant workspace ID")
	ErrMappingCorrectionNeeded = errors.New("product import: invalid mapping, correction required")
	ErrDuplicateImportToken    = errors.New("product import: preview token mismatch or expired")
	ErrUnauthorizedAction      = errors.New("product: unauthorized action")
	ErrDuplicateSkuCode        = errors.New("product: duplicate sku_code under this product")
	ErrProductArchived         = errors.New("product: cannot modify archived or deleted product")
	ErrInsufficientStock       = errors.New("product: insufficient stock for adjustment")
	ErrIdempotencyConflict     = errors.New("SYSTEM_CONFLICT_001: idempotency key already used with different request payload")
	ErrConcurrencyConflict     = errors.New("SYSTEM_CONFLICT_001: product was modified concurrently; expected_updated_at mismatch")
	ErrCurrencyMismatch        = errors.New("product: cross-currency order missing valid exchange_rate_snapshot")
)

const (
	TypePhysical   = "physical"
	TypeDigital    = "digital"
	TypeService    = "service"
	TypeMembership = "membership"
	TypeBundle     = "bundle"

	StatusDraft        = "draft"
	StatusActive       = "active"
	StatusArchived     = "archived"
	StatusDiscontinued = "discontinued"
)

func IsValidProductType(t string) bool {
	switch strings.ToLower(strings.TrimSpace(t)) {
	case TypePhysical, TypeDigital, TypeService, TypeMembership, TypeBundle:
		return true
	default:
		return false
	}
}

func IsValidCatalogStatus(s string) bool {
	switch strings.ToLower(strings.TrimSpace(s)) {
	case StatusDraft, StatusActive, StatusArchived, StatusDiscontinued:
		return true
	default:
		return false
	}
}

type ExternalRef struct {
	Platform           string `json:"platform"`
	ExternalID         string `json:"external_id"`
	URL                string `json:"url,omitempty"`
	ConnectedAccountID string `json:"connected_account_id,omitempty"`
}

type ContentRef struct {
	ContentID   string         `json:"content_id"`
	ContentType string         `json:"content_type"`
	Title       string         `json:"title,omitempty"`
	URL         string         `json:"url,omitempty"`
	LinkedAt    time.Time      `json:"linked_at"`
	Metadata    map[string]any `json:"metadata,omitempty"`
}

type ProductSku struct {
	SkuID             string                 `json:"sku_id"`
	WorkspaceID       string                 `json:"workspace_id"`
	ProductID         string                 `json:"product_id"`
	SkuCode           string                 `json:"sku_code"`
	VariantAttributes map[string]string      `json:"variant_attributes"`
	PriceOverride     *tenantdb.ExactDecimal `json:"price_override,omitempty"`
	CogsOverride      *tenantdb.ExactDecimal `json:"cogs_override,omitempty"`
	Currency          string                 `json:"currency"`
	StockQuantity     int32                  `json:"stock_quantity"`
	StockReserved     int32                  `json:"stock_reserved"`
	LowStockThreshold int32                  `json:"low_stock_threshold"`
	Barcode           string                 `json:"barcode,omitempty"`
	WeightGrams       int32                  `json:"weight_grams,omitempty"`
	IsActive          bool                   `json:"is_active"`
	ExternalRefs      []ExternalRef          `json:"external_refs"`
	CreatedAt         time.Time              `json:"created_at"`
	UpdatedAt         time.Time              `json:"updated_at"`
	DeletedAt         *time.Time             `json:"deleted_at,omitempty"`
}

type Product struct {
	ProductID             string                 `json:"product_id"`
	WorkspaceID           string                 `json:"workspace_id"`
	ProductType           string                 `json:"product_type"`
	Title                 string                 `json:"title"`
	Description           string                 `json:"description,omitempty"`
	Category              string                 `json:"category,omitempty"`
	BasePrice             *tenantdb.ExactDecimal `json:"base_price,omitempty"`
	Currency              string                 `json:"currency"`
	COGS                  *tenantdb.ExactDecimal `json:"cogs,omitempty"`
	CatalogStatus         string                 `json:"catalog_status"`
	InventoryEnabled      bool                   `json:"inventory_enabled"`
	ExternalRefs          []ExternalRef          `json:"external_refs"`
	Images                []string               `json:"images"`
	Metadata              map[string]any         `json:"metadata"`
	SKUs                  []ProductSku           `json:"skus,omitempty"`
	CreatedAt             time.Time              `json:"created_at"`
	UpdatedAt             time.Time              `json:"updated_at"`
	DeletedAt             *time.Time             `json:"deleted_at,omitempty"`
	ExpectedUpdatedAt     *time.Time             `json:"expected_updated_at,omitempty"`
	PreviousCatalogStatus string                 `json:"-"`
	PatchTitle            *string                `json:"-"`
	PatchDescription      *string                `json:"-"`
	PatchCategory         *string                `json:"-"`
	PatchInventoryEnabled *bool                  `json:"-"`
	PatchMetadata         map[string]any         `json:"-"`
	HasPatchMetadata      bool                   `json:"-"`
}

type ListFilter struct {
	Status          string
	Type            string
	Category        string
	SearchQuery     string
	CursorCreatedAt *time.Time
	CursorProductID string
}

type stockAdjContextKey struct{}

type StockAdjustmentMeta struct {
	Reason      string
	MovementKey string
	LocationID  string
}

func WithStockAdjustmentMeta(ctx context.Context, reason, movementKey string) context.Context {
	existing, _ := StockAdjustmentMetaFromContext(ctx)
	return context.WithValue(ctx, stockAdjContextKey{}, StockAdjustmentMeta{
		Reason:      reason,
		MovementKey: movementKey,
		LocationID:  existing.LocationID,
	})
}

func WithStockAdjustmentLocation(ctx context.Context, locationID string) context.Context {
	existing, _ := StockAdjustmentMetaFromContext(ctx)
	existing.LocationID = strings.TrimSpace(locationID)
	return context.WithValue(ctx, stockAdjContextKey{}, existing)
}

func StockAdjustmentMetaFromContext(ctx context.Context) (StockAdjustmentMeta, bool) {
	if ctx == nil {
		return StockAdjustmentMeta{}, false
	}
	meta, ok := ctx.Value(stockAdjContextKey{}).(StockAdjustmentMeta)
	return meta, ok
}

type expectedUpdatedAtContextKey struct{}

func WithExpectedUpdatedAt(ctx context.Context, ts *time.Time) context.Context {
	if ts == nil {
		return ctx
	}
	t := ts.UTC()
	return context.WithValue(ctx, expectedUpdatedAtContextKey{}, &t)
}

func ExpectedUpdatedAtFromContext(ctx context.Context) (*time.Time, bool) {
	if ctx == nil {
		return nil, false
	}
	ts, ok := ctx.Value(expectedUpdatedAtContextKey{}).(*time.Time)
	return ts, ok && ts != nil
}

type salesStatsFilterContextKey struct{}

type SalesStatsFilter struct {
	Period string
	Since  *time.Time
	Until  *time.Time
}

func WithSalesStatsFilter(ctx context.Context, filter SalesStatsFilter) context.Context {
	return context.WithValue(ctx, salesStatsFilterContextKey{}, filter)
}

func SalesStatsFilterFromContext(ctx context.Context) (SalesStatsFilter, bool) {
	if ctx == nil {
		return SalesStatsFilter{}, false
	}
	f, ok := ctx.Value(salesStatsFilterContextKey{}).(SalesStatsFilter)
	return f, ok
}

type ExchangeRateSnapshot struct {
	BaseCurrency  string `json:"base_currency"`
	QuoteCurrency string `json:"quote_currency"`
	RateToBase    string `json:"rate_to_base"`
	Provider      string `json:"provider,omitempty"`
	SourceClass   string `json:"source_class,omitempty"`
}

type AnalyticsOrderLine struct {
	ProductID string                 `json:"product_id"`
	SkuID     string                 `json:"sku_id,omitempty"`
	Sku       string                 `json:"sku,omitempty"`
	Quantity  int64                  `json:"quantity"`
	UnitPrice *tenantdb.ExactDecimal `json:"unit_price,omitempty"`
	Discount  *tenantdb.ExactDecimal `json:"discount,omitempty"`
	Total     *tenantdb.ExactDecimal `json:"total,omitempty"`
	UnitCOGS  *tenantdb.ExactDecimal `json:"unit_cogs,omitempty"`
}

type AnalyticsOrder struct {
	OrderID              string
	WorkspaceID          string
	ProductID            string
	Amount               tenantdb.ExactDecimal
	Currency             string
	ExchangeRateSnapshot *ExchangeRateSnapshot
	Items                []AnalyticsOrderLine
	LifecycleState       string
	OrderedAt            time.Time
}

type AnalyticsRefund struct {
	RefundID       string
	WorkspaceID    string
	OrderID        string
	ProductID      string
	Amount         tenantdb.ExactDecimal
	Currency       string
	LifecycleState string
	CreatedAt      time.Time
}

type StockMovementRecord struct {
	MovementID   string    `json:"movement_id"`
	WorkspaceID  string    `json:"workspace_id"`
	SkuID        string    `json:"sku_id"`
	LocationID   string    `json:"location_id"`
	MovementType string    `json:"movement_type"`
	Quantity     int32     `json:"quantity"`
	Reason       string    `json:"reason"`
	MovementKey  string    `json:"movement_key"`
	CreatedAt    time.Time `json:"created_at"`
}

type IdempotencyRecord struct {
	WorkspaceID    string
	IdempotencyKey string
	RequestHash    string
	ResponseStatus int
	ResponseBody   []byte
	CreatedAt      time.Time
	ExpiresAt      time.Time
}

type ProductSalesSummary struct {
	ProductID          string
	OrderCount         int32
	UnitsSold          int32
	RefundCount        int32
	GrossRevenue       tenantdb.ExactDecimal
	NetRevenue         tenantdb.ExactDecimal
	TotalCOGS          tenantdb.ExactDecimal
	TotalProfit        tenantdb.ExactDecimal
	Currency           string
	StockMovements     int32
	LowStockAlertCount int32
}

type SalesChartDataPoint struct {
	Date      time.Time
	UnitsSold int32
	Revenue   tenantdb.ExactDecimal
}

type ProductRankSummary struct {
	WorkspaceRank int32
	CategoryRank  int32
}

func (p *Product) Validate() error {
	if strings.TrimSpace(p.WorkspaceID) == "" {
		return ErrMissingTenant
	}
	p.Title = strings.TrimSpace(p.Title)
	if p.Title == "" {
		return fmt.Errorf("%w: title is required", ErrInvalidInput)
	}
	if len(p.Title) > 500 {
		return fmt.Errorf("%w: title exceeds 500 characters", ErrInvalidInput)
	}
	p.ProductType = strings.ToLower(strings.TrimSpace(p.ProductType))
	if !IsValidProductType(p.ProductType) {
		return fmt.Errorf("%w: invalid product_type %q", ErrInvalidInput, p.ProductType)
	}
	if p.CatalogStatus == "" {
		p.CatalogStatus = StatusDraft
	}
	p.CatalogStatus = strings.ToLower(strings.TrimSpace(p.CatalogStatus))
	if !IsValidCatalogStatus(p.CatalogStatus) {
		return fmt.Errorf("%w: invalid catalog_status %q", ErrInvalidInput, p.CatalogStatus)
	}
	if p.Currency == "" {
		p.Currency = "VND"
	}
	p.Currency = strings.ToUpper(strings.TrimSpace(p.Currency))
	if len(p.Currency) != 3 {
		return fmt.Errorf("%w: currency must be 3-letter ISO code", ErrInvalidInput)
	}
	if p.BasePrice != nil && p.BasePrice.IsNegative() {
		return fmt.Errorf("%w: base_price cannot be negative", ErrInvalidInput)
	}
	if p.COGS != nil && p.COGS.IsNegative() {
		return fmt.Errorf("%w: cogs cannot be negative", ErrInvalidInput)
	}
	return nil
}

package product

import (
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
	ProductID        string                 `json:"product_id"`
	WorkspaceID      string                 `json:"workspace_id"`
	ProductType      string                 `json:"product_type"`
	Title            string                 `json:"title"`
	Description      string                 `json:"description,omitempty"`
	Category         string                 `json:"category,omitempty"`
	BasePrice        *tenantdb.ExactDecimal `json:"base_price,omitempty"`
	Currency         string                 `json:"currency"`
	COGS             *tenantdb.ExactDecimal `json:"cogs,omitempty"`
	CatalogStatus    string                 `json:"catalog_status"`
	InventoryEnabled bool                   `json:"inventory_enabled"`
	ExternalRefs     []ExternalRef          `json:"external_refs"`
	Images           []string               `json:"images"`
	Metadata         map[string]any         `json:"metadata"`
	SKUs             []ProductSku           `json:"skus,omitempty"`
	CreatedAt        time.Time              `json:"created_at"`
	UpdatedAt        time.Time              `json:"updated_at"`
	DeletedAt        *time.Time             `json:"deleted_at,omitempty"`
}

type ListFilter struct {
	Status      string
	Type        string
	Category    string
	SearchQuery string
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

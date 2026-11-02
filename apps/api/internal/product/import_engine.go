package product

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/csv"
	"encoding/hex"
	"fmt"
	"io"
	"sort"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	MaxImportRows     = 10000
	MaxImportBytes    = 10 * 1024 * 1024 // 10 MiB per docs/06_quality_ops/data_migration_strategy.md §7
	TemplateVersionV1 = "m13-product-import-v1"
)

// Known header aliases mapping to canonical fields.
var headerAliases = map[string]string{
	"title":         "title",
	"product_title": "title",
	"name":          "title",
	"product_name":  "title",
	"ten_san_pham":  "title",
	"ten":           "title",

	"product_type":  "product_type",
	"type":          "product_type",
	"loai":          "product_type",
	"loai_san_pham": "product_type",

	"base_price": "base_price",
	"price":      "base_price",
	"gia":        "base_price",
	"don_gia":    "base_price",

	"cogs":    "cogs",
	"cost":    "cogs",
	"gia_von": "cogs",

	"currency":  "currency",
	"tien_te":   "currency",
	"loai_tien": "currency",

	"category":  "category",
	"danh_muc":  "category",
	"nhom_hang": "category",

	"sku":      "sku_code",
	"sku_code": "sku_code",
	"ma_sku":   "sku_code",

	"external_id": "external_id",
	"source_id":   "external_id",
	"id":          "external_id",
	"ma_nguon":    "external_id",

	"description": "description",
	"mo_ta":       "description",
	"images_url":  "images_url",
	"image":       "images_url",
}

type ImportRowOutcome struct {
	RowNumber    int
	SourceID     string
	Title        string
	Action       string // "create", "update", "unchanged", "error"
	ErrorMessage string
	ProductID    string
	SkuCode      string
	ProductData  *Product
}

type ImportResult struct {
	IsPreview                 bool
	PreviewToken              string
	ImportFingerprint         string
	TotalRows                 int
	CreateCount               int
	UpdateCount               int
	UnchangedCount            int
	ErrorCount                int
	RequiresMappingCorrection bool
	MappingErrors             []string
	Rows                      []ImportRowOutcome
	CreatedProducts           []*Product
	DownloadableErrorCSV      string
}

type ImportEngine struct {
	store Store
}

func NewImportEngine(store Store) *ImportEngine {
	return &ImportEngine{store: store}
}

// NeutralizeFormula prevents CSV/Spreadsheet injection per docs/06_quality_ops/data_migration_strategy.md §7.
func NeutralizeFormula(val string) string {
	trimmed := strings.TrimSpace(val)
	if len(trimmed) > 0 {
		switch trimmed[0] {
		case '=', '+', '-', '@':
			return "'" + val
		}
	}
	return val
}

// ComputeFingerprint hashes the raw payload, mappings, and shop scope to create a reproducible commit token.
func ComputeFingerprint(workspaceID, connectedAccountID, platform, rawData string, mappings map[string]string) string {
	h := sha256.New()
	h.Write([]byte(TemplateVersionV1))
	h.Write([]byte(workspaceID))
	h.Write([]byte(connectedAccountID))
	h.Write([]byte(platform))
	h.Write([]byte(rawData))
	if len(mappings) > 0 {
		var keys []string
		for k := range mappings {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, k := range keys {
			h.Write([]byte(k + ":" + mappings[k] + ";"))
		}
	}
	return hex.EncodeToString(h.Sum(nil))
}

// Process processes CSV data for preview or commit.
func (e *ImportEngine) Process(
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
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	if len(rawData) > MaxImportBytes {
		return nil, fmt.Errorf("%w: file size exceeds 10 MiB bound", ErrInvalidInput)
	}

	platform = strings.ToLower(strings.TrimSpace(platform))
	if platform == "" {
		platform = "csv"
	}
	defaultCurrency = strings.ToUpper(strings.TrimSpace(defaultCurrency))
	if defaultCurrency == "" {
		defaultCurrency = "VND"
	}

	fingerprint := ComputeFingerprint(workspaceID, connectedAccountID, platform, rawData, columnMappings)

	// If committing (previewOnly = false) and previewToken was provided, verify it matches
	if !previewOnly && previewToken != "" && previewToken != fingerprint {
		return nil, ErrDuplicateImportToken
	}

	r := csv.NewReader(strings.NewReader(rawData))
	r.FieldsPerRecord = -1
	r.LazyQuotes = true
	r.TrimLeadingSpace = true

	headers, err := r.Read()
	if err != nil {
		return nil, fmt.Errorf("%w: failed to read CSV header: %v", ErrInvalidInput, err)
	}

	// 1. Resolve header mapping
	fieldMap, mappingErrors := resolveFieldMapping(headers, columnMappings, defaultCurrency)
	requiresCorrection := len(mappingErrors) > 0

	res := &ImportResult{
		IsPreview:                 previewOnly,
		PreviewToken:              fingerprint,
		ImportFingerprint:         fingerprint,
		RequiresMappingCorrection: requiresCorrection,
		MappingErrors:             mappingErrors,
	}

	// If committing and mapping requires correction, refuse commit!
	if !previewOnly && requiresCorrection {
		return res, fmt.Errorf("%w: cannot commit import with mapping errors: %s",
			ErrMappingCorrectionNeeded, strings.Join(mappingErrors, "; "))
	}

	var parsedRows []map[string]string
	rowNum := 1 // header is line 1

	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("%w: read row %d: %v", ErrInvalidInput, rowNum+1, err)
		}
		rowNum++
		if rowNum > MaxImportRows+1 {
			return nil, fmt.Errorf("%w: exceeds maximum 10,000 rows limit", ErrInvalidInput)
		}

		rowFields := make(map[string]string)
		for idx, colName := range headers {
			if idx < len(record) {
				canonField := fieldMap[strings.ToLower(strings.TrimSpace(colName))]
				if canonField != "" {
					rowFields[canonField] = strings.TrimSpace(record[idx])
				}
			}
		}
		parsedRows = append(parsedRows, rowFields)
	}

	res.TotalRows = len(parsedRows)

	// In-batch deduplication tracking to ensure repeated rows inside the same file no-op
	seenBatchKeys := make(map[string]bool)

	// Process each row
	for i, rowData := range parsedRows {
		actualLine := i + 2
		outcome := ImportRowOutcome{
			RowNumber: actualLine,
			SourceID:  rowData["external_id"],
			Title:     rowData["title"],
		}

		// Validation of required row fields
		title := rowData["title"]
		if title == "" {
			outcome.Action = "error"
			outcome.ErrorMessage = "title is required"
			res.ErrorCount++
			res.Rows = append(res.Rows, outcome)
			continue
		}

		pType := strings.ToLower(rowData["product_type"])
		if pType == "" {
			pType = TypePhysical // default
		}
		if !IsValidProductType(pType) {
			outcome.Action = "error"
			outcome.ErrorMessage = fmt.Sprintf("invalid product_type %q", pType)
			res.ErrorCount++
			res.Rows = append(res.Rows, outcome)
			continue
		}

		curr := strings.ToUpper(rowData["currency"])
		if curr == "" {
			curr = defaultCurrency
		}
		if len(curr) != 3 {
			outcome.Action = "error"
			outcome.ErrorMessage = fmt.Sprintf("invalid currency %q", curr)
			res.ErrorCount++
			res.Rows = append(res.Rows, outcome)
			continue
		}

		var basePriceDec *tenantdb.ExactDecimal
		if rawPrice := rowData["base_price"]; rawPrice != "" {
			pDec, err := tenantdb.ParseExactDecimal(rawPrice)
			if err != nil {
				outcome.Action = "error"
				outcome.ErrorMessage = fmt.Sprintf("invalid base_price %q: %v", rawPrice, err)
				res.ErrorCount++
				res.Rows = append(res.Rows, outcome)
				continue
			}
			if pDec.IsNegative() {
				outcome.Action = "error"
				outcome.ErrorMessage = "base_price cannot be negative"
				res.ErrorCount++
				res.Rows = append(res.Rows, outcome)
				continue
			}
			basePriceDec = &pDec
		}

		var cogsDec *tenantdb.ExactDecimal
		if rawCogs := rowData["cogs"]; rawCogs != "" {
			cDec, err := tenantdb.ParseExactDecimal(rawCogs)
			if err != nil {
				outcome.Action = "error"
				outcome.ErrorMessage = fmt.Sprintf("invalid cogs %q: %v", rawCogs, err)
				res.ErrorCount++
				res.Rows = append(res.Rows, outcome)
				continue
			}
			if cDec.IsNegative() {
				outcome.Action = "error"
				outcome.ErrorMessage = "cogs cannot be negative"
				res.ErrorCount++
				res.Rows = append(res.Rows, outcome)
				continue
			}
			cogsDec = &cDec
		}

		extID := rowData["external_id"]
		if extID == "" {
			// Auto-generate a deterministic source ID if none provided
			extID = fmt.Sprintf("imp-%s-%d", fingerprint[:8], actualLine)
		}
		outcome.SourceID = extID

		skuCode := rowData["sku_code"]
		if skuCode == "" {
			skuCode = extID
		}
		outcome.SkuCode = skuCode

		// Batch duplicate check: repeated identical rows inside the same file no-op
		batchDedupKey := fmt.Sprintf("%s:%s:%s", extID, title, skuCode)
		if seenBatchKeys[batchDedupKey] {
			outcome.Action = "unchanged"
			res.UnchangedCount++
			res.Rows = append(res.Rows, outcome)
			continue
		}
		seenBatchKeys[batchDedupKey] = true

		// ACCEPTANCE TARGET 1: Scoped by workspace_id + connected_account_id + platform + external_id
		// Two shops with same source ID remain separate because connectedAccountID is isolated!
		existing, err := e.store.FindProductByExternalID(ctx, workspaceID, platform, extID, connectedAccountID)
		if err == nil && existing != nil {
			outcome.ProductID = existing.ProductID
			// ACCEPTANCE TARGET 2: Repeated rows no-op if identical
			if isProductIdentical(existing, title, pType, curr, basePriceDec, cogsDec, rowData["category"], rowData["description"]) {
				outcome.Action = "unchanged"
				res.UnchangedCount++
			} else {
				// Changed row is an update
				outcome.Action = "update"
				res.UpdateCount++
				if !previewOnly {
					existing.Title = title
					existing.ProductType = pType
					existing.Currency = curr
					existing.BasePrice = basePriceDec
					existing.COGS = cogsDec
					if cat := rowData["category"]; cat != "" {
						existing.Category = cat
					}
					if desc := rowData["description"]; desc != "" {
						existing.Description = desc
					}
					existing.UpdatedAt = time.Now().UTC()
					_ = e.store.UpdateProduct(ctx, existing)
				}
			}
			res.Rows = append(res.Rows, outcome)
			continue
		}

		// New product row
		outcome.Action = "create"
		res.CreateCount++

		prodID := newUUID()
		outcome.ProductID = prodID

		newProd := &Product{
			ProductID:        prodID,
			WorkspaceID:      workspaceID,
			ProductType:      pType,
			Title:            title,
			Description:      rowData["description"],
			Category:         rowData["category"],
			BasePrice:        basePriceDec,
			Currency:         curr,
			COGS:             cogsDec,
			CatalogStatus:    StatusActive,
			InventoryEnabled: true,
			ExternalRefs: []ExternalRef{
				{
					Platform:           platform,
					ExternalID:         extID,
					ConnectedAccountID: connectedAccountID,
				},
			},
			Images:    []string{},
			Metadata:  map[string]any{"import_fingerprint": fingerprint},
			CreatedAt: time.Now().UTC(),
			UpdatedAt: time.Now().UTC(),
		}

		if img := rowData["images_url"]; img != "" {
			newProd.Images = append(newProd.Images, img)
		}

		// Initial SKU
		newSku := ProductSku{
			SkuID:             newUUID(),
			WorkspaceID:       workspaceID,
			ProductID:         prodID,
			SkuCode:           skuCode,
			VariantAttributes: map[string]string{"default": "standard"},
			Currency:          curr,
			PriceOverride:     basePriceDec,
			CogsOverride:      cogsDec,
			StockQuantity:     0,
			LowStockThreshold: 5,
			IsActive:          true,
			CreatedAt:         time.Now().UTC(),
			UpdatedAt:         time.Now().UTC(),
		}
		newProd.SKUs = []ProductSku{newSku}
		outcome.ProductData = newProd

		if !previewOnly {
			if err := e.store.CreateProduct(ctx, newProd); err != nil {
				outcome.Action = "error"
				outcome.ErrorMessage = fmt.Sprintf("database write error: %v", err)
				res.CreateCount--
				res.ErrorCount++
			} else {
				res.CreatedProducts = append(res.CreatedProducts, newProd)
			}
		}

		res.Rows = append(res.Rows, outcome)
	}

	// Generate downloadable error CSV if errors occurred
	if res.ErrorCount > 0 {
		res.DownloadableErrorCSV = generateErrorCSV(res.Rows)
	}

	return res, nil
}

func isProductIdentical(
	p *Product,
	title, pType, curr string,
	basePrice, cogs *tenantdb.ExactDecimal,
	cat, desc string,
) bool {
	if p.Title != title || p.ProductType != pType || p.Currency != curr {
		return false
	}
	if (p.BasePrice == nil && basePrice != nil) || (p.BasePrice != nil && basePrice == nil) {
		return false
	}
	if p.BasePrice != nil && basePrice != nil && p.BasePrice.Cmp(*basePrice) != 0 {
		return false
	}
	if (p.COGS == nil && cogs != nil) || (p.COGS != nil && cogs == nil) {
		return false
	}
	if p.COGS != nil && cogs != nil && p.COGS.Cmp(*cogs) != 0 {
		return false
	}
	if cat != "" && p.Category != cat {
		return false
	}
	if desc != "" && p.Description != desc {
		return false
	}
	return true
}

func resolveFieldMapping(headers []string, customMappings map[string]string, defaultCurrency string) (map[string]string, []string) {
	fieldMap := make(map[string]string)
	var errors []string

	mappedCanonical := make(map[string]string) // canonical -> source column

	for _, h := range headers {
		normH := strings.ToLower(strings.TrimSpace(h))
		if customField, ok := customMappings[normH]; ok && customField != "" {
			canon := strings.ToLower(strings.TrimSpace(customField))
			fieldMap[normH] = canon
			mappedCanonical[canon] = h
			continue
		}
		if canon, ok := headerAliases[normH]; ok {
			fieldMap[normH] = canon
			mappedCanonical[canon] = h
		}
	}

	// ACCEPTANCE TARGET 3: Invalid mappings need correction
	// Required fields: title
	if mappedCanonical["title"] == "" {
		errors = append(errors, "missing required column mapping: 'title' (or alias 'product_title', 'name', 'ten_san_pham')")
	}

	// Currency required if neither present in columns nor valid default
	if mappedCanonical["currency"] == "" && defaultCurrency == "" {
		errors = append(errors, "missing currency mapping and no default currency provided")
	}

	return fieldMap, errors
}

func generateErrorCSV(rows []ImportRowOutcome) string {
	var buf bytes.Buffer
	w := csv.NewWriter(&buf)
	_ = w.Write([]string{"row_number", "source_id", "title", "error_message"})
	for _, r := range rows {
		if r.Action == "error" {
			_ = w.Write([]string{
				fmt.Sprintf("%d", r.RowNumber),
				NeutralizeFormula(r.SourceID),
				NeutralizeFormula(r.Title),
				NeutralizeFormula(r.ErrorMessage),
			})
		}
	}
	w.Flush()
	return buf.String()
}

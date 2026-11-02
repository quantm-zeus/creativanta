package product

import (
	"context"
	"encoding/json"
	"errors"
	"strings"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Handler struct {
	service *Service
}

func NewHandler(service *Service) *Handler {
	return &Handler{service: service}
}

var _ commercev1connect.ProductServiceHandler = (*Handler)(nil)

func resolveTenantContext(ctx context.Context, cmdCtx *commonv1.CommandContext) (string, error) {
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.WorkspaceID != "" {
		if cmdCtx != nil && cmdCtx.WorkspaceId != nil && cmdCtx.WorkspaceId.Value != "" {
			if cmdCtx.WorkspaceId.Value != session.WorkspaceID && !session.InternalAdmin {
				return "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
			}
		}
		return session.WorkspaceID, nil
	}
	if cmdCtx != nil && cmdCtx.WorkspaceId != nil && cmdCtx.WorkspaceId.Value != "" {
		return cmdCtx.WorkspaceId.Value, nil
	}
	return "", connect.NewError(connect.CodeUnauthenticated, ErrMissingTenant)
}

func (h *Handler) Create(
	ctx context.Context,
	req *connect.Request[commercev1.CreateRequest],
) (*connect.Response[commercev1.CreateResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}

	p := &Product{
		WorkspaceID:      wsID,
		ProductType:      fromProtoProductType(msg.ProductType),
		Title:            msg.Title,
		Description:      msg.Description,
		Category:         msg.Category,
		Currency:         msg.Currency,
		CatalogStatus:    fromProtoCatalogStatus(msg.CatalogStatus),
		InventoryEnabled: msg.InventoryEnabled,
		Images:           msg.Images,
		Metadata:         make(map[string]any),
	}
	if msg.BasePrice != nil {
		dec, err := tenantdb.ParseExactDecimal(msg.BasePrice.Amount)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		p.BasePrice = &dec
		if p.Currency == "" {
			p.Currency = msg.BasePrice.Currency
		}
	}
	if msg.Cogs != nil {
		dec, err := tenantdb.ParseExactDecimal(msg.Cogs.Amount)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		p.COGS = &dec
	}
	for _, ref := range msg.ExternalRefs {
		p.ExternalRefs = append(p.ExternalRefs, ExternalRef{
			Platform:           ref.Platform,
			ExternalID:         ref.ExternalId,
			URL:                ref.Url,
			ConnectedAccountID: ref.ConnectedAccountId,
		})
	}
	if msg.MetadataJson != "" {
		_ = json.Unmarshal([]byte(msg.MetadataJson), &p.Metadata)
	}
	for _, sku := range msg.InitialSkus {
		pSku := ProductSku{
			SkuCode:           sku.SkuCode,
			VariantAttributes: sku.VariantAttributes,
			Currency:          sku.Currency,
			LowStockThreshold: sku.LowStockThreshold,
			Barcode:           sku.Barcode,
			WeightGrams:       sku.WeightGrams,
			IsActive:          sku.IsActive,
		}
		if sku.PriceOverride != nil {
			dec, err := tenantdb.ParseExactDecimal(sku.PriceOverride.Amount)
			if err == nil {
				pSku.PriceOverride = &dec
			}
		}
		if sku.CogsOverride != nil {
			dec, err := tenantdb.ParseExactDecimal(sku.CogsOverride.Amount)
			if err == nil {
				pSku.CogsOverride = &dec
			}
		}
		p.SKUs = append(p.SKUs, pSku)
	}

	created, err := h.service.CreateProduct(ctx, p)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.CreateResponse{
		Product: toProtoProduct(created),
	}), nil
}

func (h *Handler) Get(
	ctx context.Context,
	req *connect.Request[commercev1.GetRequest],
) (*connect.Response[commercev1.GetResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, nil)
	if err != nil {
		return nil, err
	}

	p, err := h.service.GetProduct(ctx, wsID, msg.ProductId)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.GetResponse{
		Product: toProtoProduct(p),
	}), nil
}

func (h *Handler) List(
	ctx context.Context,
	req *connect.Request[commercev1.ListRequest],
) (*connect.Response[commercev1.ListResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, nil)
	if err != nil {
		return nil, err
	}

	filter := ListFilter{
		Status:      fromProtoCatalogStatus(msg.StatusFilter),
		Type:        fromProtoProductType(msg.TypeFilter),
		Category:    msg.CategoryFilter,
		SearchQuery: msg.SearchQuery,
	}
	limit := 20
	offset := 0
	if msg.Pagination != nil {
		if msg.Pagination.PageSize > 0 {
			limit = int(msg.Pagination.PageSize)
		}
	}

	products, total, err := h.service.ListProducts(ctx, wsID, filter, limit, offset)
	if err != nil {
		return nil, mapError(err)
	}

	var protoList []*commercev1.Product
	for _, p := range products {
		protoList = append(protoList, toProtoProduct(p))
	}

	return connect.NewResponse(&commercev1.ListResponse{
		Products: protoList,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+limit) < total,
		},
	}), nil
}

func (h *Handler) Update(
	ctx context.Context,
	req *connect.Request[commercev1.UpdateRequest],
) (*connect.Response[commercev1.UpdateResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}

	p := &Product{
		ProductID:   msg.ProductId,
		WorkspaceID: wsID,
	}
	if msg.Title != nil {
		p.Title = *msg.Title
	}
	if msg.Description != nil {
		p.Description = *msg.Description
	}
	if msg.Category != nil {
		p.Category = *msg.Category
	}
	if msg.BasePrice != nil {
		dec, err := tenantdb.ParseExactDecimal(msg.BasePrice.Amount)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		p.BasePrice = &dec
		p.Currency = msg.BasePrice.Currency
	}
	if msg.Cogs != nil {
		dec, err := tenantdb.ParseExactDecimal(msg.Cogs.Amount)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		p.COGS = &dec
	}
	if msg.CatalogStatus != nil {
		p.CatalogStatus = fromProtoCatalogStatus(*msg.CatalogStatus)
	}
	if len(msg.ExternalRefs) > 0 {
		for _, ref := range msg.ExternalRefs {
			p.ExternalRefs = append(p.ExternalRefs, ExternalRef{
				Platform:           ref.Platform,
				ExternalID:         ref.ExternalId,
				URL:                ref.Url,
				ConnectedAccountID: ref.ConnectedAccountId,
			})
		}
	}
	if len(msg.Images) > 0 {
		p.Images = msg.Images
	}
	if msg.MetadataJson != nil && *msg.MetadataJson != "" {
		p.Metadata = make(map[string]any)
		_ = json.Unmarshal([]byte(*msg.MetadataJson), &p.Metadata)
	}

	updated, err := h.service.UpdateProduct(ctx, p)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.UpdateResponse{
		Product: toProtoProduct(updated),
	}), nil
}

func (h *Handler) Delete(
	ctx context.Context,
	req *connect.Request[commercev1.DeleteRequest],
) (*connect.Response[commercev1.DeleteResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}
	if err := h.service.DeleteProduct(ctx, wsID, msg.ProductId); err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.DeleteResponse{Success: true}), nil
}

func (h *Handler) Archive(
	ctx context.Context,
	req *connect.Request[commercev1.ArchiveRequest],
) (*connect.Response[commercev1.ArchiveResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}
	archived, err := h.service.ArchiveProduct(ctx, wsID, msg.ProductId)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.ArchiveResponse{
		Product: toProtoProduct(archived),
	}), nil
}

func (h *Handler) BatchTag(
	ctx context.Context,
	req *connect.Request[commercev1.BatchTagRequest],
) (*connect.Response[commercev1.BatchTagResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}
	count, err := h.service.BatchTagProducts(ctx, wsID, msg.ProductIds, msg.TagsToAdd, msg.TagsToRemove)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.BatchTagResponse{UpdatedCount: int32(count)}), nil
}

func (h *Handler) Import(
	ctx context.Context,
	req *connect.Request[commercev1.ImportRequest],
) (*connect.Response[commercev1.ImportResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}

	result, err := h.service.Import(
		ctx,
		wsID,
		msg.SourcePlatform,
		msg.ConnectedAccountId,
		msg.RawData,
		msg.ColumnMappings,
		msg.DefaultCurrency,
		msg.PreviewOnly,
		msg.PreviewToken,
	)
	if err != nil && result == nil {
		return nil, mapError(err)
	}

	var protoRows []*commercev1.ImportRowResult
	if result != nil {
		for _, r := range result.Rows {
			protoRows = append(protoRows, &commercev1.ImportRowResult{
				RowNumber:    int32(r.RowNumber),
				SourceId:     r.SourceID,
				Title:        r.Title,
				Action:       r.Action,
				ErrorMessage: r.ErrorMessage,
				ProductId:    r.ProductID,
				SkuCode:      r.SkuCode,
			})
		}
	}

	var createdProtos []*commercev1.Product
	if result != nil {
		for _, cp := range result.CreatedProducts {
			createdProtos = append(createdProtos, toProtoProduct(cp))
		}
	}

	resp := &commercev1.ImportResponse{
		IsPreview:                 result.IsPreview,
		PreviewToken:              result.PreviewToken,
		TotalRows:                 int32(result.TotalRows),
		CreateCount:               int32(result.CreateCount),
		UpdateCount:               int32(result.UpdateCount),
		UnchangedCount:            int32(result.UnchangedCount),
		ErrorCount:                int32(result.ErrorCount),
		RequiresMappingCorrection: result.RequiresMappingCorrection,
		MappingErrors:             result.MappingErrors,
		Rows:                      protoRows,
		CreatedProducts:           createdProtos,
		ImportFingerprint:         result.ImportFingerprint,
		DownloadableErrorCsv:      result.DownloadableErrorCSV,
	}

	if err != nil {
		return connect.NewResponse(resp), mapError(err)
	}
	return connect.NewResponse(resp), nil
}

func (h *Handler) Search(
	ctx context.Context,
	req *connect.Request[commercev1.SearchRequest],
) (*connect.Response[commercev1.SearchResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, nil)
	if err != nil {
		return nil, err
	}
	limit := 20
	offset := 0
	if msg.Pagination != nil && msg.Pagination.PageSize > 0 {
		limit = int(msg.Pagination.PageSize)
	}
	products, total, err := h.service.SearchProducts(ctx, wsID, msg.Query, limit, offset)
	if err != nil {
		return nil, mapError(err)
	}
	var protoList []*commercev1.Product
	for _, p := range products {
		protoList = append(protoList, toProtoProduct(p))
	}
	return connect.NewResponse(&commercev1.SearchResponse{
		Products: protoList,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+limit) < total,
		},
	}), nil
}

func (h *Handler) GetStats(
	ctx context.Context,
	req *connect.Request[commercev1.GetStatsRequest],
) (*connect.Response[commercev1.GetStatsResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, nil)
	if err != nil {
		return nil, err
	}
	orders, rev, skus, onHand, reserved, err := h.service.GetStats(ctx, wsID, msg.ProductId)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.GetStatsResponse{
		ProductId:       msg.ProductId,
		TotalOrders:     orders,
		TotalRevenue:    &commonv1.Money{Amount: rev.String(), Currency: "VND"},
		ActiveSkusCount: skus,
		OnHandStock:     onHand,
		ReservedStock:   reserved,
	}), nil
}

func (h *Handler) GetSalesStats(
	_ context.Context,
	req *connect.Request[commercev1.GetSalesStatsRequest],
) (*connect.Response[commercev1.GetSalesStatsResponse], error) {
	msg := req.Msg
	return connect.NewResponse(&commercev1.GetSalesStatsResponse{
		ProductId:   msg.ProductId,
		GrossSales:  &commonv1.Money{Amount: "0.000000", Currency: "VND"},
		NetSales:    &commonv1.Money{Amount: "0.000000", Currency: "VND"},
		UnitsSold:   0,
		RefundCount: 0,
	}), nil
}

func (h *Handler) GetSalesChart(
	_ context.Context,
	req *connect.Request[commercev1.GetSalesChartRequest],
) (*connect.Response[commercev1.GetSalesChartResponse], error) {
	msg := req.Msg
	return connect.NewResponse(&commercev1.GetSalesChartResponse{
		ProductId:  msg.ProductId,
		DataPoints: []*commercev1.SalesChartPoint{},
	}), nil
}

func (h *Handler) GetReviews(
	_ context.Context,
	req *connect.Request[commercev1.GetReviewsRequest],
) (*connect.Response[commercev1.GetReviewsResponse], error) {
	return connect.NewResponse(&commercev1.GetReviewsResponse{
		Reviews:    []*commercev1.ProductReviewItem{},
		Pagination: &commonv1.PaginatedResponse{},
	}), nil
}

func (h *Handler) GetRank(
	_ context.Context,
	req *connect.Request[commercev1.GetRankRequest],
) (*connect.Response[commercev1.GetRankResponse], error) {
	msg := req.Msg
	return connect.NewResponse(&commercev1.GetRankResponse{
		ProductId:       msg.ProductId,
		RankInCategory:  1,
		RankInWorkspace: 1,
	}), nil
}

func (h *Handler) GetLinkedContent(
	ctx context.Context,
	req *connect.Request[commercev1.GetLinkedContentRequest],
) (*connect.Response[commercev1.GetLinkedContentResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, nil)
	if err != nil {
		return nil, err
	}
	links, err := h.service.GetLinkedContent(ctx, wsID, msg.ProductId)
	if err != nil {
		return nil, mapError(err)
	}
	var protoRefs []*commercev1.ContentRef
	for _, l := range links {
		metaJSON, _ := json.Marshal(l.Metadata)
		protoRefs = append(protoRefs, &commercev1.ContentRef{
			ContentId:    l.ContentID,
			ContentType:  l.ContentType,
			Title:        l.Title,
			Url:          l.URL,
			LinkedAt:     timestamppb.New(l.LinkedAt),
			MetadataJson: string(metaJSON),
		})
	}
	return connect.NewResponse(&commercev1.GetLinkedContentResponse{
		ProductId:      msg.ProductId,
		LinkedContents: protoRefs,
	}), nil
}

func (h *Handler) LinkContent(
	ctx context.Context,
	req *connect.Request[commercev1.LinkContentRequest],
) (*connect.Response[commercev1.LinkContentResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" || msg.ContentId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}
	ref := ContentRef{
		ContentID:   msg.ContentId,
		ContentType: msg.ContentType,
		Title:       msg.Title,
		URL:         msg.Url,
	}
	if msg.MetadataJson != "" {
		_ = json.Unmarshal([]byte(msg.MetadataJson), &ref.Metadata)
	}
	saved, err := h.service.LinkContent(ctx, wsID, msg.ProductId, ref)
	if err != nil {
		return nil, mapError(err)
	}
	metaJSON, _ := json.Marshal(saved.Metadata)
	return connect.NewResponse(&commercev1.LinkContentResponse{
		Success: true,
		LinkedContent: &commercev1.ContentRef{
			ContentId:    saved.ContentID,
			ContentType:  saved.ContentType,
			Title:        saved.Title,
			Url:          saved.URL,
			LinkedAt:     timestamppb.New(saved.LinkedAt),
			MetadataJson: string(metaJSON),
		},
	}), nil
}

func (h *Handler) UpdateStock(
	ctx context.Context,
	req *connect.Request[commercev1.UpdateStockRequest],
) (*connect.Response[commercev1.UpdateStockResponse], error) {
	msg := req.Msg
	if msg == nil || msg.SkuId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}
	newQty, err := h.service.UpdateStock(ctx, wsID, msg.SkuId, msg.DeltaQuantity, msg.Reason)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.UpdateStockResponse{
		SkuId:            msg.SkuId,
		NewStockQuantity: newQty,
	}), nil
}

func (h *Handler) SetAlertThreshold(
	ctx context.Context,
	req *connect.Request[commercev1.SetAlertThresholdRequest],
) (*connect.Response[commercev1.SetAlertThresholdResponse], error) {
	msg := req.Msg
	if msg == nil || msg.SkuId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}
	if err := h.service.SetAlertThreshold(ctx, wsID, msg.SkuId, msg.LowStockThreshold); err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.SetAlertThresholdResponse{
		SkuId:             msg.SkuId,
		LowStockThreshold: msg.LowStockThreshold,
	}), nil
}

func (h *Handler) BulkArchive(
	ctx context.Context,
	req *connect.Request[commercev1.BulkArchiveRequest],
) (*connect.Response[commercev1.BulkArchiveResponse], error) {
	msg := req.Msg
	if msg == nil || len(msg.ProductIds) == 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := resolveTenantContext(ctx, msg.Context)
	if err != nil {
		return nil, err
	}
	count, err := h.service.BulkArchiveProducts(ctx, wsID, msg.ProductIds)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.BulkArchiveResponse{ArchivedCount: int32(count)}), nil
}

func mapError(err error) error {
	switch {
	case errors.Is(err, ErrProductNotFound), errors.Is(err, ErrSkuNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrInvalidInput):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, ErrMappingCorrectionNeeded):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, ErrDuplicateImportToken):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, ErrMissingTenant):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, ErrUnauthorizedAction):
		return connect.NewError(connect.CodePermissionDenied, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

func toProtoProduct(p *Product) *commercev1.Product {
	if p == nil {
		return nil
	}
	metaJSON, _ := json.Marshal(p.Metadata)
	protoProd := &commercev1.Product{
		ProductId:        p.ProductID,
		WorkspaceId:      p.WorkspaceID,
		ProductType:      toProtoProductType(p.ProductType),
		Title:            p.Title,
		Description:      p.Description,
		Category:         p.Category,
		Currency:         p.Currency,
		CatalogStatus:    toProtoCatalogStatus(p.CatalogStatus),
		InventoryEnabled: p.InventoryEnabled,
		Images:           p.Images,
		MetadataJson:     string(metaJSON),
		CreatedAt:        timestamppb.New(p.CreatedAt),
		UpdatedAt:        timestamppb.New(p.UpdatedAt),
	}
	if p.BasePrice != nil {
		protoProd.BasePrice = &commonv1.Money{Amount: p.BasePrice.String(), Currency: p.Currency}
	}
	if p.COGS != nil {
		protoProd.Cogs = &commonv1.Money{Amount: p.COGS.String(), Currency: p.Currency}
	}
	if p.DeletedAt != nil {
		protoProd.DeletedAt = timestamppb.New(*p.DeletedAt)
	}
	for _, ref := range p.ExternalRefs {
		protoProd.ExternalRefs = append(protoProd.ExternalRefs, &commercev1.ExternalRef{
			Platform:           ref.Platform,
			ExternalId:         ref.ExternalID,
			Url:                ref.URL,
			ConnectedAccountId: ref.ConnectedAccountID,
		})
	}
	for _, sku := range p.SKUs {
		protoProd.Skus = append(protoProd.Skus, toProtoSku(&sku))
	}
	return protoProd
}

func toProtoSku(s *ProductSku) *commercev1.ProductSku {
	if s == nil {
		return nil
	}
	protoSku := &commercev1.ProductSku{
		SkuId:             s.SkuID,
		WorkspaceId:       s.WorkspaceID,
		ProductId:         s.ProductID,
		SkuCode:           s.SkuCode,
		VariantAttributes: s.VariantAttributes,
		Currency:          s.Currency,
		StockQuantity:     s.StockQuantity,
		StockReserved:     s.StockReserved,
		LowStockThreshold: s.LowStockThreshold,
		Barcode:           s.Barcode,
		WeightGrams:       s.WeightGrams,
		IsActive:          s.IsActive,
		CreatedAt:         timestamppb.New(s.CreatedAt),
		UpdatedAt:         timestamppb.New(s.UpdatedAt),
	}
	if s.PriceOverride != nil {
		protoSku.PriceOverride = &commonv1.Money{Amount: s.PriceOverride.String(), Currency: s.Currency}
	}
	if s.CogsOverride != nil {
		protoSku.CogsOverride = &commonv1.Money{Amount: s.CogsOverride.String(), Currency: s.Currency}
	}
	if s.DeletedAt != nil {
		protoSku.DeletedAt = timestamppb.New(*s.DeletedAt)
	}
	for _, ref := range s.ExternalRefs {
		protoSku.ExternalRefs = append(protoSku.ExternalRefs, &commercev1.ExternalRef{
			Platform:           ref.Platform,
			ExternalId:         ref.ExternalID,
			Url:                ref.URL,
			ConnectedAccountId: ref.ConnectedAccountID,
		})
	}
	return protoSku
}

func toProtoProductType(t string) commercev1.ProductType {
	switch strings.ToLower(t) {
	case TypePhysical:
		return commercev1.ProductType_PRODUCT_TYPE_PHYSICAL
	case TypeDigital:
		return commercev1.ProductType_PRODUCT_TYPE_DIGITAL
	case TypeService:
		return commercev1.ProductType_PRODUCT_TYPE_SERVICE
	case TypeMembership:
		return commercev1.ProductType_PRODUCT_TYPE_MEMBERSHIP
	case TypeBundle:
		return commercev1.ProductType_PRODUCT_TYPE_BUNDLE
	default:
		return commercev1.ProductType_PRODUCT_TYPE_UNSPECIFIED
	}
}

func fromProtoProductType(pt commercev1.ProductType) string {
	switch pt {
	case commercev1.ProductType_PRODUCT_TYPE_PHYSICAL:
		return TypePhysical
	case commercev1.ProductType_PRODUCT_TYPE_DIGITAL:
		return TypeDigital
	case commercev1.ProductType_PRODUCT_TYPE_SERVICE:
		return TypeService
	case commercev1.ProductType_PRODUCT_TYPE_MEMBERSHIP:
		return TypeMembership
	case commercev1.ProductType_PRODUCT_TYPE_BUNDLE:
		return TypeBundle
	default:
		return ""
	}
}

func toProtoCatalogStatus(s string) commercev1.CatalogStatus {
	switch strings.ToLower(s) {
	case StatusDraft:
		return commercev1.CatalogStatus_CATALOG_STATUS_DRAFT
	case StatusActive:
		return commercev1.CatalogStatus_CATALOG_STATUS_ACTIVE
	case StatusArchived:
		return commercev1.CatalogStatus_CATALOG_STATUS_ARCHIVED
	case StatusDiscontinued:
		return commercev1.CatalogStatus_CATALOG_STATUS_DISCONTINUED
	default:
		return commercev1.CatalogStatus_CATALOG_STATUS_UNSPECIFIED
	}
}

func fromProtoCatalogStatus(cs commercev1.CatalogStatus) string {
	switch cs {
	case commercev1.CatalogStatus_CATALOG_STATUS_DRAFT:
		return StatusDraft
	case commercev1.CatalogStatus_CATALOG_STATUS_ACTIVE:
		return StatusActive
	case commercev1.CatalogStatus_CATALOG_STATUS_ARCHIVED:
		return StatusArchived
	case commercev1.CatalogStatus_CATALOG_STATUS_DISCONTINUED:
		return StatusDiscontinued
	default:
		return ""
	}
}

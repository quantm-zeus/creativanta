package product

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Handler struct {
	service *Service
}

func NewHandler(service *Service) *Handler {
	return &Handler{service: service}
}

var _ commercev1connect.ProductServiceHandler = (*Handler)(nil)

type productRPCBinding struct {
	permissionKey string
	roleEnvelope  string
}

var productRPCBindings = map[string]productRPCBinding{
	"ProductService/Create":            {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"ProductService/Get":               {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/List":              {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/Update":            {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"ProductService/Delete":            {permissionKey: "product:delete", roleEnvelope: "Admin+"},
	"ProductService/Archive":           {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"ProductService/BatchTag":          {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"ProductService/Import":            {permissionKey: "product:import", roleEnvelope: "Admin+"},
	"ProductService/Search":            {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/GetStats":          {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/GetSalesStats":     {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/GetSalesChart":     {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/GetReviews":        {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/GetRank":           {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/GetLinkedContent":  {permissionKey: "product:read", roleEnvelope: "Member"},
	"ProductService/LinkContent":       {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"ProductService/UpdateStock":       {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"ProductService/SetAlertThreshold": {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"ProductService/BulkArchive":       {permissionKey: "product:manage", roleEnvelope: "Manager+"},
}

var productRoleRank = map[string]int{
	rbac.RoleOwner:       7,
	rbac.RoleAdmin:       6,
	rbac.RoleManager:     5,
	rbac.RoleEditor:      4,
	rbac.RoleContributor: 3,
	rbac.RoleViewer:      2,
	rbac.RoleExternal:    1,
}

func checkProductRoleEnvelope(role, envelope string) error {
	rank, ok := productRoleRank[role]
	if !ok {
		return ErrUnauthorizedAction
	}
	switch envelope {
	case "Owner":
		if rank < productRoleRank[rbac.RoleOwner] {
			return ErrUnauthorizedAction
		}
	case "Admin+":
		if rank < productRoleRank[rbac.RoleAdmin] {
			return ErrUnauthorizedAction
		}
	case "Manager+":
		if rank < productRoleRank[rbac.RoleManager] {
			return ErrUnauthorizedAction
		}
	case "Editor+":
		if rank < productRoleRank[rbac.RoleEditor] {
			return ErrUnauthorizedAction
		}
	case "Contributor+":
		if rank < productRoleRank[rbac.RoleContributor] {
			return ErrUnauthorizedAction
		}
	case "Viewer+", "Member":
		if rank < productRoleRank[rbac.RoleViewer] {
			return ErrUnauthorizedAction
		}
	}
	return nil
}

// WithCaller injects an authenticated workspace caller into ctx for direct handler tests.
func WithCaller(ctx context.Context, workspaceID, userID, role string) context.Context {
	if role == "" {
		role = rbac.RoleOwner
	}
	if userID == "" {
		userID = "user-product-default"
	}
	return rbac.WithPolicyContext(ctx, rbac.PolicyContext{
		ActorUserID: userID,
		WorkspaceID: workspaceID,
		Role:        role,
	})
}

func checkProductAccess(rpcMethod string, pctx rbac.PolicyContext) error {
	binding, ok := productRPCBindings[rpcMethod]
	if !ok {
		return ErrUnauthorizedAction
	}
	if err := rbac.CheckWorkspacePermission(binding.permissionKey, pctx); err != nil {
		return ErrUnauthorizedAction
	}
	return checkProductRoleEnvelope(pctx.Role, binding.roleEnvelope)
}

func authorizeProductRPC(ctx context.Context, rpcMethod string, cmdCtx *commonv1.CommandContext) (string, error) {
	var cmdWS string
	if cmdCtx != nil && cmdCtx.WorkspaceId != nil {
		cmdWS = strings.TrimSpace(cmdCtx.WorkspaceId.Value)
	}

	if session, ok := transportauth.PrincipalFromContext(ctx); ok && strings.TrimSpace(session.WorkspaceID) != "" {
		wsID := strings.TrimSpace(session.WorkspaceID)
		if cmdWS != "" && cmdWS != wsID && !session.InternalAdmin {
			return "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
		}
		if !session.InternalAdmin {
			pctx, hasPolicy := rbac.PolicyContextFromContext(ctx)
			if !hasPolicy {
				pctx = rbac.PolicyContext{
					ActorUserID: session.UserID,
					WorkspaceID: wsID,
					Role:        rbac.RoleOwner,
				}
			}
			if err := checkProductAccess(rpcMethod, pctx); err != nil {
				return "", connect.NewError(connect.CodePermissionDenied, ErrUnauthorizedAction)
			}
		}
		return wsID, nil
	}

	if pctx, ok := rbac.PolicyContextFromContext(ctx); ok && strings.TrimSpace(pctx.WorkspaceID) != "" {
		wsID := strings.TrimSpace(pctx.WorkspaceID)
		if cmdWS != "" && cmdWS != wsID {
			return "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
		}
		if err := checkProductAccess(rpcMethod, pctx); err != nil {
			return "", connect.NewError(connect.CodePermissionDenied, ErrUnauthorizedAction)
		}
		return wsID, nil
	}

	if cmdWS != "" {
		return cmdWS, nil
	}
	return "", connect.NewError(connect.CodeUnauthenticated, ErrMissingTenant)
}

var productPageCursorHMACKey = []byte("creativanta-product-page-cursor-hmac-v1")

type productPageCursor struct {
	WorkspaceID       string `json:"ws"`
	RPC               string `json:"rpc"`
	Status            string `json:"st,omitempty"`
	Type              string `json:"tp,omitempty"`
	Category          string `json:"cat,omitempty"`
	SearchQuery       string `json:"q,omitempty"`
	CursorCreatedAtNs int64  `json:"ts,omitempty"`
	CursorProductID   string `json:"pid,omitempty"`
	Offset            int    `json:"off,omitempty"`
}

func encodeProductPageToken(c productPageCursor) (string, error) {
	raw, err := json.Marshal(c)
	if err != nil {
		return "", err
	}
	payloadB64 := base64.RawURLEncoding.EncodeToString(raw)
	mac := hmac.New(sha256.New, productPageCursorHMACKey)
	mac.Write([]byte(payloadB64))
	sig := hex.EncodeToString(mac.Sum(nil))
	return payloadB64 + "." + sig, nil
}

func decodeProductPageToken(token string, expected productPageCursor) (productPageCursor, error) {
	if token == "" {
		return productPageCursor{}, nil
	}
	if len(token) > 512 || strings.TrimSpace(token) != token {
		return productPageCursor{}, fmt.Errorf("%w: malformed page_token", ErrInvalidInput)
	}
	parts := strings.Split(token, ".")
	if len(parts) != 2 || parts[0] == "" || parts[1] == "" {
		return productPageCursor{}, fmt.Errorf("%w: invalid page_token format", ErrInvalidInput)
	}
	mac := hmac.New(sha256.New, productPageCursorHMACKey)
	mac.Write([]byte(parts[0]))
	expectedSig := hex.EncodeToString(mac.Sum(nil))
	if !hmac.Equal([]byte(parts[1]), []byte(expectedSig)) {
		return productPageCursor{}, fmt.Errorf("%w: invalid page_token signature", ErrInvalidInput)
	}
	raw, err := base64.RawURLEncoding.DecodeString(parts[0])
	if err != nil {
		return productPageCursor{}, fmt.Errorf("%w: invalid page_token encoding", ErrInvalidInput)
	}
	var decoded productPageCursor
	if err := json.Unmarshal(raw, &decoded); err != nil {
		return productPageCursor{}, fmt.Errorf("%w: invalid page_token payload", ErrInvalidInput)
	}
	hasKeyset := decoded.CursorProductID != "" && decoded.CursorCreatedAtNs > 0
	if !hasKeyset && decoded.Offset <= 0 {
		return productPageCursor{}, fmt.Errorf("%w: invalid page_token cursor", ErrInvalidInput)
	}
	if decoded.WorkspaceID != expected.WorkspaceID {
		return productPageCursor{}, fmt.Errorf("%w: page_token tenant mismatch", ErrInvalidInput)
	}
	if decoded.RPC != expected.RPC ||
		!strings.EqualFold(decoded.Status, expected.Status) ||
		!strings.EqualFold(decoded.Type, expected.Type) ||
		!strings.EqualFold(decoded.Category, expected.Category) ||
		decoded.SearchQuery != expected.SearchQuery {
		return productPageCursor{}, fmt.Errorf("%w: page_token filter mismatch", ErrInvalidInput)
	}
	return decoded, nil
}

func hashCommandPayload(rpcName string, payload any) string {
	raw, _ := json.Marshal(map[string]any{
		"rpc":     rpcName,
		"payload": payload,
	})
	sum := sha256.Sum256(raw)
	return hex.EncodeToString(sum[:])
}

func executeIdempotentMutation[T any](
	ctx context.Context,
	h *Handler,
	wsID string,
	rpcName string,
	cmdCtx *commonv1.CommandContext,
	reqPayload any,
	newResp func() *T,
	execFn func(idemKey string) (*T, error),
) (*connect.Response[T], error) {
	var idemKey string
	if cmdCtx != nil {
		idemKey = strings.TrimSpace(cmdCtx.IdempotencyKey)
	}
	if idemKey == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: idempotency_key is required for mutating command %s", ErrInvalidInput, rpcName))
	}

	unlock := h.service.lockIdempotency(wsID, idemKey)
	defer unlock()

	reqHash := hashCommandPayload(rpcName, reqPayload)
	existing, err := h.service.store.GetIdempotencyRecord(ctx, wsID, idemKey)
	if err != nil {
		return nil, mapError(err)
	}
	if existing != nil {
		if existing.RequestHash != reqHash {
			return nil, connect.NewError(connect.CodeAlreadyExists, ErrIdempotencyConflict)
		}
		respMsg := newResp()
		if len(existing.ResponseBody) > 0 {
			if pm, ok := any(respMsg).(proto.Message); ok {
				if err := protojson.Unmarshal(existing.ResponseBody, pm); err != nil {
					return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("unmarshal cached idempotency response: %w", err))
				}
			}
		}
		return connect.NewResponse(respMsg), nil
	}

	respMsg, err := execFn(idemKey)
	if err != nil {
		return nil, err
	}

	var respBytes []byte
	if pm, ok := any(respMsg).(proto.Message); ok {
		respBytes, err = protojson.Marshal(pm)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("marshal idempotency response: %w", err))
		}
	}
	now := h.service.clock()
	if err := h.service.store.SaveIdempotencyRecord(ctx, IdempotencyRecord{
		WorkspaceID:    wsID,
		IdempotencyKey: idemKey,
		RequestHash:    reqHash,
		ResponseStatus: 200,
		ResponseBody:   respBytes,
		CreatedAt:      now,
		ExpiresAt:      now.Add(24 * time.Hour),
	}); err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(respMsg), nil
}

func checkProductExpectedUpdatedAt(ctx context.Context, h *Handler, wsID, productID string, cmdCtx *commonv1.CommandContext) error {
	if cmdCtx == nil || cmdCtx.ExpectedUpdatedAt == nil {
		return nil
	}
	existing, err := h.service.GetProduct(ctx, wsID, productID)
	if err != nil {
		return err
	}
	expected := cmdCtx.ExpectedUpdatedAt.AsTime().UTC().Truncate(time.Microsecond)
	actual := existing.UpdatedAt.UTC().Truncate(time.Microsecond)
	if !actual.Equal(expected) {
		return ErrConcurrencyConflict
	}
	return nil
}

func checkSkuExpectedUpdatedAt(ctx context.Context, h *Handler, wsID, skuID string, cmdCtx *commonv1.CommandContext) error {
	if cmdCtx == nil || cmdCtx.ExpectedUpdatedAt == nil {
		return nil
	}
	existing, err := h.service.store.GetSku(ctx, wsID, skuID)
	if err != nil {
		return err
	}
	expected := cmdCtx.ExpectedUpdatedAt.AsTime().UTC().Truncate(time.Microsecond)
	actual := existing.UpdatedAt.UTC().Truncate(time.Microsecond)
	if !actual.Equal(expected) {
		return ErrConcurrencyConflict
	}
	return nil
}

func (h *Handler) Create(
	ctx context.Context,
	req *connect.Request[commercev1.CreateRequest],
) (*connect.Response[commercev1.CreateResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/Create", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"product_type":      msg.ProductType,
		"title":             msg.Title,
		"description":       msg.Description,
		"category":          msg.Category,
		"base_price":        msg.BasePrice,
		"currency":          msg.Currency,
		"cogs":              msg.Cogs,
		"catalog_status":    msg.CatalogStatus,
		"inventory_enabled": msg.InventoryEnabled,
		"external_refs":     msg.ExternalRefs,
		"images":            msg.Images,
		"metadata_json":     msg.MetadataJson,
		"initial_skus":      msg.InitialSkus,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/Create",
		msg.Context,
		reqPayload,
		func() *commercev1.CreateResponse { return &commercev1.CreateResponse{} },
		func(_ string) (*commercev1.CreateResponse, error) {
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
			return &commercev1.CreateResponse{
				Product: toProtoProduct(created),
			}, nil
		},
	)
}

func (h *Handler) Get(
	ctx context.Context,
	req *connect.Request[commercev1.GetRequest],
) (*connect.Response[commercev1.GetResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/Get", nil)
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
	wsID, err := authorizeProductRPC(ctx, "ProductService/List", nil)
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
	expectedCursor := productPageCursor{
		WorkspaceID: wsID,
		RPC:         "List",
		Status:      filter.Status,
		Type:        filter.Type,
		Category:    filter.Category,
		SearchQuery: filter.SearchQuery,
	}
	if msg.Pagination != nil {
		if msg.Pagination.PageSize < 0 {
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: page_size cannot be negative", ErrInvalidInput))
		}
		if msg.Pagination.PageSize > 0 {
			limit = int(msg.Pagination.PageSize)
			if limit > 100 {
				limit = 100
			}
		}
		if msg.Pagination.PageToken != "" {
			decoded, err := decodeProductPageToken(msg.Pagination.PageToken, expectedCursor)
			if err != nil {
				return nil, connect.NewError(connect.CodeInvalidArgument, err)
			}
			if decoded.CursorProductID != "" && decoded.CursorCreatedAtNs > 0 {
				ts := time.Unix(0, decoded.CursorCreatedAtNs).UTC()
				filter.CursorCreatedAt = &ts
				filter.CursorProductID = decoded.CursorProductID
			} else {
				offset = decoded.Offset
			}
		}
	}

	products, total, err := h.service.ListProducts(ctx, wsID, filter, limit+1, offset)
	if err != nil {
		return nil, mapError(err)
	}

	hasMore := false
	if len(products) > limit {
		hasMore = true
		products = products[:limit]
	}

	var protoList []*commercev1.Product
	for _, p := range products {
		protoList = append(protoList, toProtoProduct(p))
	}

	var nextPageToken string
	if hasMore && len(products) > 0 {
		last := products[len(products)-1]
		expectedCursor.CursorCreatedAtNs = last.CreatedAt.UTC().UnixNano()
		expectedCursor.CursorProductID = last.ProductID
		expectedCursor.Offset = offset + len(products)
		tok, err := encodeProductPageToken(expectedCursor)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		nextPageToken = tok
	}

	return connect.NewResponse(&commercev1.ListResponse{
		Products: protoList,
		Pagination: &commonv1.PaginatedResponse{
			NextPageToken: nextPageToken,
			TotalCount:    &total,
			HasMore:       hasMore,
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
	wsID, err := authorizeProductRPC(ctx, "ProductService/Update", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"product_id":     msg.ProductId,
		"title":          msg.Title,
		"description":    msg.Description,
		"category":       msg.Category,
		"base_price":     msg.BasePrice,
		"cogs":           msg.Cogs,
		"catalog_status": msg.CatalogStatus,
		"external_refs":  msg.ExternalRefs,
		"images":         msg.Images,
		"metadata_json":  msg.MetadataJson,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/Update",
		msg.Context,
		reqPayload,
		func() *commercev1.UpdateResponse { return &commercev1.UpdateResponse{} },
		func(_ string) (*commercev1.UpdateResponse, error) {
			p := &Product{
				ProductID:   msg.ProductId,
				WorkspaceID: wsID,
			}
			if msg.Context != nil && msg.Context.ExpectedUpdatedAt != nil {
				exp := msg.Context.ExpectedUpdatedAt.AsTime().UTC()
				p.ExpectedUpdatedAt = &exp
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
			return &commercev1.UpdateResponse{
				Product: toProtoProduct(updated),
			}, nil
		},
	)
}

func (h *Handler) Delete(
	ctx context.Context,
	req *connect.Request[commercev1.DeleteRequest],
) (*connect.Response[commercev1.DeleteResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/Delete", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"product_id": msg.ProductId,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/Delete",
		msg.Context,
		reqPayload,
		func() *commercev1.DeleteResponse { return &commercev1.DeleteResponse{} },
		func(_ string) (*commercev1.DeleteResponse, error) {
			if err := checkProductExpectedUpdatedAt(ctx, h, wsID, msg.ProductId, msg.Context); err != nil {
				return nil, mapError(err)
			}
			if err := h.service.DeleteProduct(ctx, wsID, msg.ProductId); err != nil {
				return nil, mapError(err)
			}
			return &commercev1.DeleteResponse{Success: true}, nil
		},
	)
}

func (h *Handler) Archive(
	ctx context.Context,
	req *connect.Request[commercev1.ArchiveRequest],
) (*connect.Response[commercev1.ArchiveResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/Archive", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"product_id": msg.ProductId,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/Archive",
		msg.Context,
		reqPayload,
		func() *commercev1.ArchiveResponse { return &commercev1.ArchiveResponse{} },
		func(_ string) (*commercev1.ArchiveResponse, error) {
			if err := checkProductExpectedUpdatedAt(ctx, h, wsID, msg.ProductId, msg.Context); err != nil {
				return nil, mapError(err)
			}
			archived, err := h.service.ArchiveProduct(ctx, wsID, msg.ProductId)
			if err != nil {
				return nil, mapError(err)
			}
			return &commercev1.ArchiveResponse{
				Product: toProtoProduct(archived),
			}, nil
		},
	)
}

func (h *Handler) BatchTag(
	ctx context.Context,
	req *connect.Request[commercev1.BatchTagRequest],
) (*connect.Response[commercev1.BatchTagResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/BatchTag", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"product_ids":    msg.ProductIds,
		"tags_to_add":    msg.TagsToAdd,
		"tags_to_remove": msg.TagsToRemove,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/BatchTag",
		msg.Context,
		reqPayload,
		func() *commercev1.BatchTagResponse { return &commercev1.BatchTagResponse{} },
		func(_ string) (*commercev1.BatchTagResponse, error) {
			count, err := h.service.BatchTagProducts(ctx, wsID, msg.ProductIds, msg.TagsToAdd, msg.TagsToRemove)
			if err != nil {
				return nil, mapError(err)
			}
			return &commercev1.BatchTagResponse{UpdatedCount: int32(count)}, nil
		},
	)
}

func buildImportProtoResponse(result *ImportResult) *commercev1.ImportResponse {
	if result == nil {
		return &commercev1.ImportResponse{}
	}
	var protoRows []*commercev1.ImportRowResult
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
	var createdProtos []*commercev1.Product
	for _, cp := range result.CreatedProducts {
		createdProtos = append(createdProtos, toProtoProduct(cp))
	}
	return &commercev1.ImportResponse{
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
}

func (h *Handler) Import(
	ctx context.Context,
	req *connect.Request[commercev1.ImportRequest],
) (*connect.Response[commercev1.ImportResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/Import", msg.Context)
	if err != nil {
		return nil, err
	}

	isPreview := msg.PreviewOnly || msg.DryRun
	hasIdemKey := msg.Context != nil && strings.TrimSpace(msg.Context.IdempotencyKey) != ""

	if isPreview && !hasIdemKey {
		result, err := h.service.Import(
			ctx,
			wsID,
			msg.SourcePlatform,
			msg.ConnectedAccountId,
			msg.RawData,
			msg.ColumnMappings,
			msg.DefaultCurrency,
			true,
			msg.PreviewToken,
		)
		if err != nil && result == nil {
			return nil, mapError(err)
		}
		resp := buildImportProtoResponse(result)
		if err != nil {
			return connect.NewResponse(resp), mapError(err)
		}
		return connect.NewResponse(resp), nil
	}

	reqPayload := map[string]any{
		"source_platform":      msg.SourcePlatform,
		"connected_account_id": msg.ConnectedAccountId,
		"raw_data":             msg.RawData,
		"column_mappings":      msg.ColumnMappings,
		"default_currency":     msg.DefaultCurrency,
		"is_preview":           isPreview,
		"preview_token":        msg.PreviewToken,
	}

	var partialMappingResp *commercev1.ImportResponse
	resp, err := executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/Import",
		msg.Context,
		reqPayload,
		func() *commercev1.ImportResponse { return &commercev1.ImportResponse{} },
		func(_ string) (*commercev1.ImportResponse, error) {
			result, err := h.service.Import(
				ctx,
				wsID,
				msg.SourcePlatform,
				msg.ConnectedAccountId,
				msg.RawData,
				msg.ColumnMappings,
				msg.DefaultCurrency,
				isPreview,
				msg.PreviewToken,
			)
			if err != nil && result == nil {
				return nil, mapError(err)
			}
			built := buildImportProtoResponse(result)
			if err != nil {
				partialMappingResp = built
				return nil, mapError(err)
			}
			return built, nil
		},
	)
	if err != nil && partialMappingResp != nil {
		return connect.NewResponse(partialMappingResp), err
	}
	return resp, err
}

func (h *Handler) Search(
	ctx context.Context,
	req *connect.Request[commercev1.SearchRequest],
) (*connect.Response[commercev1.SearchResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/Search", nil)
	if err != nil {
		return nil, err
	}
	filter := ListFilter{
		SearchQuery: msg.Query,
	}
	limit := 20
	offset := 0
	expectedCursor := productPageCursor{
		WorkspaceID: wsID,
		RPC:         "Search",
		SearchQuery: msg.Query,
	}
	if msg.Pagination != nil {
		if msg.Pagination.PageSize < 0 {
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: page_size cannot be negative", ErrInvalidInput))
		}
		if msg.Pagination.PageSize > 0 {
			limit = int(msg.Pagination.PageSize)
			if limit > 100 {
				limit = 100
			}
		}
		if msg.Pagination.PageToken != "" {
			decoded, err := decodeProductPageToken(msg.Pagination.PageToken, expectedCursor)
			if err != nil {
				return nil, connect.NewError(connect.CodeInvalidArgument, err)
			}
			if decoded.CursorProductID != "" && decoded.CursorCreatedAtNs > 0 {
				ts := time.Unix(0, decoded.CursorCreatedAtNs).UTC()
				filter.CursorCreatedAt = &ts
				filter.CursorProductID = decoded.CursorProductID
			} else {
				offset = decoded.Offset
			}
		}
	}
	products, total, err := h.service.ListProducts(ctx, wsID, filter, limit+1, offset)
	if err != nil {
		return nil, mapError(err)
	}
	hasMore := false
	if len(products) > limit {
		hasMore = true
		products = products[:limit]
	}
	var protoList []*commercev1.Product
	for _, p := range products {
		protoList = append(protoList, toProtoProduct(p))
	}
	var nextPageToken string
	if hasMore && len(products) > 0 {
		last := products[len(products)-1]
		expectedCursor.CursorCreatedAtNs = last.CreatedAt.UTC().UnixNano()
		expectedCursor.CursorProductID = last.ProductID
		expectedCursor.Offset = offset + len(products)
		tok, err := encodeProductPageToken(expectedCursor)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		nextPageToken = tok
	}
	return connect.NewResponse(&commercev1.SearchResponse{
		Products: protoList,
		Pagination: &commonv1.PaginatedResponse{
			NextPageToken: nextPageToken,
			TotalCount:    &total,
			HasMore:       hasMore,
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
	wsID, err := authorizeProductRPC(ctx, "ProductService/GetStats", nil)
	if err != nil {
		return nil, err
	}
	p, err := h.service.GetProduct(ctx, wsID, msg.ProductId)
	if err != nil {
		return nil, mapError(err)
	}
	orders, rev, skus, onHand, reserved, err := h.service.GetStats(ctx, wsID, msg.ProductId)
	if err != nil {
		return nil, mapError(err)
	}
	curr := p.Currency
	if curr == "" {
		curr = "VND"
	}
	return connect.NewResponse(&commercev1.GetStatsResponse{
		ProductId:       msg.ProductId,
		TotalOrders:     orders,
		TotalRevenue:    &commonv1.Money{Amount: rev.String(), Currency: curr},
		ActiveSkusCount: skus,
		OnHandStock:     onHand,
		ReservedStock:   reserved,
	}), nil
}

func (h *Handler) GetSalesStats(
	ctx context.Context,
	req *connect.Request[commercev1.GetSalesStatsRequest],
) (*connect.Response[commercev1.GetSalesStatsResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/GetSalesStats", nil)
	if err != nil {
		return nil, err
	}
	summary, err := h.service.GetSalesSummary(ctx, wsID, msg.ProductId)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.GetSalesStatsResponse{
		ProductId:   msg.ProductId,
		GrossSales:  &commonv1.Money{Amount: summary.GrossRevenue.String(), Currency: summary.Currency},
		NetSales:    &commonv1.Money{Amount: summary.NetRevenue.String(), Currency: summary.Currency},
		UnitsSold:   summary.UnitsSold,
		RefundCount: summary.RefundCount,
	}), nil
}

func (h *Handler) GetSalesChart(
	ctx context.Context,
	req *connect.Request[commercev1.GetSalesChartRequest],
) (*connect.Response[commercev1.GetSalesChartResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/GetSalesChart", nil)
	if err != nil {
		return nil, err
	}
	days := 30
	switch strings.ToLower(strings.TrimSpace(msg.Interval)) {
	case "week", "7d":
		days = 7
	case "month", "90d":
		days = 90
	}
	pts, curr, err := h.service.GetSalesChart(ctx, wsID, msg.ProductId, days)
	if err != nil {
		return nil, mapError(err)
	}
	protoPts := make([]*commercev1.SalesChartPoint, 0, len(pts))
	for _, pt := range pts {
		protoPts = append(protoPts, &commercev1.SalesChartPoint{
			Timestamp:  pt.Date.UTC().Format(time.RFC3339),
			Amount:     &commonv1.Money{Amount: pt.Revenue.String(), Currency: curr},
			OrderCount: pt.UnitsSold,
		})
	}
	return connect.NewResponse(&commercev1.GetSalesChartResponse{
		ProductId:  msg.ProductId,
		DataPoints: protoPts,
	}), nil
}

func (h *Handler) GetReviews(
	ctx context.Context,
	req *connect.Request[commercev1.GetReviewsRequest],
) (*connect.Response[commercev1.GetReviewsResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/GetReviews", nil)
	if err != nil {
		return nil, err
	}
	if _, err := h.service.GetProduct(ctx, wsID, msg.ProductId); err != nil {
		return nil, mapError(err)
	}
	if msg.Pagination != nil && msg.Pagination.PageToken != "" {
		expectedCursor := productPageCursor{
			WorkspaceID: wsID,
			RPC:         "GetReviews",
			Category:    msg.ProductId,
		}
		if _, err := decodeProductPageToken(msg.Pagination.PageToken, expectedCursor); err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
	}
	var total int64
	return connect.NewResponse(&commercev1.GetReviewsResponse{
		ProductId: msg.ProductId,
		Reviews:   []*commercev1.ProductReviewItem{},
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    false,
		},
	}), nil
}

func (h *Handler) GetRank(
	ctx context.Context,
	req *connect.Request[commercev1.GetRankRequest],
) (*connect.Response[commercev1.GetRankResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ProductId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/GetRank", nil)
	if err != nil {
		return nil, err
	}
	rank, err := h.service.GetRank(ctx, wsID, msg.ProductId)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.GetRankResponse{
		ProductId:       msg.ProductId,
		RankInCategory:  rank.CategoryRank,
		RankInWorkspace: rank.WorkspaceRank,
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
	wsID, err := authorizeProductRPC(ctx, "ProductService/GetLinkedContent", nil)
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
	wsID, err := authorizeProductRPC(ctx, "ProductService/LinkContent", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"product_id":    msg.ProductId,
		"content_id":    msg.ContentId,
		"content_type":  msg.ContentType,
		"title":         msg.Title,
		"url":           msg.Url,
		"metadata_json": msg.MetadataJson,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/LinkContent",
		msg.Context,
		reqPayload,
		func() *commercev1.LinkContentResponse { return &commercev1.LinkContentResponse{} },
		func(_ string) (*commercev1.LinkContentResponse, error) {
			if err := checkProductExpectedUpdatedAt(ctx, h, wsID, msg.ProductId, msg.Context); err != nil {
				return nil, mapError(err)
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
			return &commercev1.LinkContentResponse{
				Success: true,
				LinkedContent: &commercev1.ContentRef{
					ContentId:    saved.ContentID,
					ContentType:  saved.ContentType,
					Title:        saved.Title,
					Url:          saved.URL,
					LinkedAt:     timestamppb.New(saved.LinkedAt),
					MetadataJson: string(metaJSON),
				},
			}, nil
		},
	)
}

func (h *Handler) UpdateStock(
	ctx context.Context,
	req *connect.Request[commercev1.UpdateStockRequest],
) (*connect.Response[commercev1.UpdateStockResponse], error) {
	msg := req.Msg
	if msg == nil || msg.SkuId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/UpdateStock", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"sku_id":         msg.SkuId,
		"delta_quantity": msg.DeltaQuantity,
		"reason":         msg.Reason,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/UpdateStock",
		msg.Context,
		reqPayload,
		func() *commercev1.UpdateStockResponse { return &commercev1.UpdateStockResponse{} },
		func(idemKey string) (*commercev1.UpdateStockResponse, error) {
			if err := checkSkuExpectedUpdatedAt(ctx, h, wsID, msg.SkuId, msg.Context); err != nil {
				return nil, mapError(err)
			}
			adjCtx := WithStockAdjustmentMeta(ctx, msg.Reason, "rpc:"+idemKey)
			newQty, err := h.service.UpdateStock(adjCtx, wsID, msg.SkuId, msg.DeltaQuantity, msg.Reason)
			if err != nil {
				return nil, mapError(err)
			}
			return &commercev1.UpdateStockResponse{
				SkuId:            msg.SkuId,
				NewStockQuantity: newQty,
			}, nil
		},
	)
}

func (h *Handler) SetAlertThreshold(
	ctx context.Context,
	req *connect.Request[commercev1.SetAlertThresholdRequest],
) (*connect.Response[commercev1.SetAlertThresholdResponse], error) {
	msg := req.Msg
	if msg == nil || msg.SkuId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/SetAlertThreshold", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"sku_id":              msg.SkuId,
		"low_stock_threshold": msg.LowStockThreshold,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/SetAlertThreshold",
		msg.Context,
		reqPayload,
		func() *commercev1.SetAlertThresholdResponse { return &commercev1.SetAlertThresholdResponse{} },
		func(_ string) (*commercev1.SetAlertThresholdResponse, error) {
			if err := checkSkuExpectedUpdatedAt(ctx, h, wsID, msg.SkuId, msg.Context); err != nil {
				return nil, mapError(err)
			}
			if err := h.service.SetAlertThreshold(ctx, wsID, msg.SkuId, msg.LowStockThreshold); err != nil {
				return nil, mapError(err)
			}
			return &commercev1.SetAlertThresholdResponse{
				SkuId:             msg.SkuId,
				LowStockThreshold: msg.LowStockThreshold,
			}, nil
		},
	)
}

func (h *Handler) BulkArchive(
	ctx context.Context,
	req *connect.Request[commercev1.BulkArchiveRequest],
) (*connect.Response[commercev1.BulkArchiveResponse], error) {
	msg := req.Msg
	if msg == nil || len(msg.ProductIds) == 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	wsID, err := authorizeProductRPC(ctx, "ProductService/BulkArchive", msg.Context)
	if err != nil {
		return nil, err
	}

	reqPayload := map[string]any{
		"product_ids": msg.ProductIds,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/BulkArchive",
		msg.Context,
		reqPayload,
		func() *commercev1.BulkArchiveResponse { return &commercev1.BulkArchiveResponse{} },
		func(_ string) (*commercev1.BulkArchiveResponse, error) {
			count, err := h.service.BulkArchiveProducts(ctx, wsID, msg.ProductIds)
			if err != nil {
				return nil, mapError(err)
			}
			return &commercev1.BulkArchiveResponse{ArchivedCount: int32(count)}, nil
		},
	)
}

func mapError(err error) error {
	switch {
	case errors.Is(err, ErrProductNotFound), errors.Is(err, ErrSkuNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrInvalidInput):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, ErrMappingCorrectionNeeded):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, ErrIdempotencyConflict), errors.Is(err, ErrDuplicateSkuCode):
		return connect.NewError(connect.CodeAlreadyExists, err)
	case errors.Is(err, ErrConcurrencyConflict), errors.Is(err, ErrInsufficientStock), errors.Is(err, ErrDuplicateImportToken), errors.Is(err, ErrProductArchived):
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

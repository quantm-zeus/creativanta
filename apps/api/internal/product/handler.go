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
	FilterHash        string `json:"fh,omitempty"`
	Status            string `json:"-"`
	Type              string `json:"-"`
	Category          string `json:"-"`
	SearchQuery       string `json:"-"`
	CursorCreatedAtNs int64  `json:"ts,omitempty"`
	CursorProductID   string `json:"pid,omitempty"`
	Offset            int    `json:"off,omitempty"`
}

func computeCursorFilterHash(c productPageCursor) string {
	h := sha256.New()
	_, _ = fmt.Fprintf(h, "%s\x00%s\x00%s\x00%s\x00%s",
		strings.TrimSpace(c.RPC),
		strings.ToLower(strings.TrimSpace(c.Status)),
		strings.ToLower(strings.TrimSpace(c.Type)),
		strings.ToLower(strings.TrimSpace(c.Category)),
		c.SearchQuery,
	)
	sum := h.Sum(nil)
	return hex.EncodeToString(sum[:16])
}

func encodeProductPageToken(c productPageCursor) (string, error) {
	c.FilterHash = computeCursorFilterHash(c)
	raw, err := json.Marshal(c)
	if err != nil {
		return "", err
	}
	payloadB64 := base64.RawURLEncoding.EncodeToString(raw)
	mac := hmac.New(sha256.New, productPageCursorHMACKey)
	mac.Write([]byte(payloadB64))
	sig := hex.EncodeToString(mac.Sum(nil))
	token := payloadB64 + "." + sig
	if len(token) > 512 {
		return "", fmt.Errorf("%w: generated page_token exceeds 512 characters", ErrInvalidInput)
	}
	return token, nil
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
	expectedFilterHash := computeCursorFilterHash(expected)
	if decoded.RPC != expected.RPC || decoded.FilterHash != expectedFilterHash {
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
	execFn func(txCtx context.Context, idemKey string) (*T, error),
) (*connect.Response[T], error) {
	var idemKey string
	if cmdCtx != nil {
		idemKey = strings.TrimSpace(cmdCtx.IdempotencyKey)
		if len(cmdCtx.Reason) > 2000 {
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: reason exceeds 2000 characters", ErrInvalidInput))
		}
	}
	if idemKey == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: idempotency_key is required for mutating command %s", ErrInvalidInput, rpcName))
	}
	if len(idemKey) > 255 {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: idempotency_key exceeds 255 characters", ErrInvalidInput))
	}

	unlock := h.service.lockIdempotency(wsID, idemKey)
	defer unlock()

	now := h.service.clock().UTC()
	ctx = WithIdempotencyNow(ctx, now)

	txCtx, commitTx, rollbackTx, err := beginStoreMutationTx(ctx, h.service.store, wsID, idemKey)
	if err != nil {
		return nil, mapError(err)
	}
	defer rollbackTx()

	txStore := h.service.txStore(txCtx)

	hashPayload := reqPayload
	if cmdCtx != nil && cmdCtx.ExpectedUpdatedAt != nil {
		hashPayload = map[string]any{
			"payload":             reqPayload,
			"expected_updated_at": cmdCtx.ExpectedUpdatedAt.AsTime().UTC().Truncate(time.Microsecond).Format(time.RFC3339Nano),
		}
	}
	reqHash := hashCommandPayload(rpcName, hashPayload)
	existing, err := txStore.GetIdempotencyRecord(txCtx, wsID, idemKey)
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
		if err := commitTx(); err != nil {
			return nil, mapError(err)
		}
		return connect.NewResponse(respMsg), nil
	}

	if cmdCtx != nil && cmdCtx.ExpectedUpdatedAt != nil {
		exp := cmdCtx.ExpectedUpdatedAt.AsTime().UTC()
		txCtx = WithExpectedUpdatedAt(txCtx, &exp)
	}

	respMsg, err := execFn(txCtx, idemKey)
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
	if err := txStore.SaveIdempotencyRecord(txCtx, IdempotencyRecord{
		WorkspaceID:    wsID,
		IdempotencyKey: idemKey,
		RequestHash:    reqHash,
		ResponseStatus: 200,
		ResponseBody:   respBytes,
		CreatedAt:      now,
		ExpiresAt:      now.Add(7 * 24 * time.Hour),
	}); err != nil {
		var alreadyCommitted *idempotencyAlreadyCommittedError
		if errors.As(err, &alreadyCommitted) {
			rollbackTx()
			replayMsg := newResp()
			if len(alreadyCommitted.Record.ResponseBody) > 0 {
				if pm, ok := any(replayMsg).(proto.Message); ok {
					if uErr := protojson.Unmarshal(alreadyCommitted.Record.ResponseBody, pm); uErr != nil {
						return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("unmarshal cached idempotency response: %w", uErr))
					}
				}
			}
			return connect.NewResponse(replayMsg), nil
		}
		return nil, mapError(err)
	}

	if err := commitTx(); err != nil {
		return nil, mapError(err)
	}
	h.service.flushBufferedEvents(txCtx)

	return connect.NewResponse(respMsg), nil
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
		func(txCtx context.Context, _ string) (*commercev1.CreateResponse, error) {
			p := &Product{
				WorkspaceID:      wsID,
				ProductType:      fromProtoProductType(msg.ProductType),
				Title:            msg.Title,
				Description:      msg.Description,
				Category:         msg.Category,
				Currency:         strings.ToUpper(strings.TrimSpace(msg.Currency)),
				CatalogStatus:    fromProtoCatalogStatus(msg.CatalogStatus),
				InventoryEnabled: msg.InventoryEnabled,
				Images:           msg.Images,
				Metadata:         make(map[string]any),
			}
			if p.Currency != "" && !IsValidISOCurrency(p.Currency) {
				return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: currency must be a 3-letter ISO code", ErrInvalidInput))
			}
			if msg.BasePrice != nil {
				bpCurr := strings.ToUpper(strings.TrimSpace(msg.BasePrice.Currency))
				if !IsValidISOCurrency(bpCurr) {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: base_price.currency must be a 3-letter ISO code", ErrInvalidInput))
				}
				if p.Currency != "" && p.Currency != bpCurr {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: base_price.currency %q does not match product currency %q", ErrInvalidInput, bpCurr, p.Currency))
				}
				p.Currency = bpCurr
				dec, err := tenantdb.ParseExactDecimal(msg.BasePrice.Amount)
				if err != nil {
					return nil, connect.NewError(connect.CodeInvalidArgument, err)
				}
				p.BasePrice = &dec
			}
			if p.Currency == "" {
				p.Currency = "VND"
			}
			if msg.Cogs != nil {
				cogsCurr := strings.ToUpper(strings.TrimSpace(msg.Cogs.Currency))
				if !IsValidISOCurrency(cogsCurr) {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: cogs.currency must be a 3-letter ISO code", ErrInvalidInput))
				}
				if cogsCurr != p.Currency {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: cogs.currency %q does not match product currency %q", ErrInvalidInput, cogsCurr, p.Currency))
				}
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
			if strings.TrimSpace(msg.MetadataJson) != "" {
				if err := json.Unmarshal([]byte(msg.MetadataJson), &p.Metadata); err != nil {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: invalid metadata_json: %v", ErrInvalidInput, err))
				}
			}
			for _, sku := range msg.InitialSkus {
				skuCurr := strings.ToUpper(strings.TrimSpace(sku.Currency))
				if skuCurr != "" && (!IsValidISOCurrency(skuCurr) || skuCurr != p.Currency) {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: sku currency %q does not match product currency %q", ErrInvalidInput, sku.Currency, p.Currency))
				}
				pSku := ProductSku{
					SkuCode:           sku.SkuCode,
					VariantAttributes: sku.VariantAttributes,
					Currency:          p.Currency,
					LowStockThreshold: sku.LowStockThreshold,
					Barcode:           sku.Barcode,
					WeightGrams:       sku.WeightGrams,
					IsActive:          sku.IsActive,
				}
				if sku.PriceOverride != nil {
					poCurr := strings.ToUpper(strings.TrimSpace(sku.PriceOverride.Currency))
					if !IsValidISOCurrency(poCurr) || poCurr != p.Currency {
						return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: sku price_override.currency %q does not match product currency %q", ErrInvalidInput, sku.PriceOverride.Currency, p.Currency))
					}
					dec, err := tenantdb.ParseExactDecimal(sku.PriceOverride.Amount)
					if err != nil {
						return nil, connect.NewError(connect.CodeInvalidArgument, err)
					}
					pSku.PriceOverride = &dec
				}
				if sku.CogsOverride != nil {
					coCurr := strings.ToUpper(strings.TrimSpace(sku.CogsOverride.Currency))
					if !IsValidISOCurrency(coCurr) || coCurr != p.Currency {
						return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: sku cogs_override.currency %q does not match product currency %q", ErrInvalidInput, sku.CogsOverride.Currency, p.Currency))
					}
					dec, err := tenantdb.ParseExactDecimal(sku.CogsOverride.Amount)
					if err != nil {
						return nil, connect.NewError(connect.CodeInvalidArgument, err)
					}
					pSku.CogsOverride = &dec
				}
				p.SKUs = append(p.SKUs, pSku)
			}

			created, err := h.service.CreateProduct(txCtx, p)
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
		"product_id":        msg.ProductId,
		"title":             msg.Title,
		"description":       msg.Description,
		"category":          msg.Category,
		"base_price":        msg.BasePrice,
		"cogs":              msg.Cogs,
		"catalog_status":    msg.CatalogStatus,
		"inventory_enabled": msg.InventoryEnabled,
		"external_refs":     msg.ExternalRefs,
		"images":            msg.Images,
		"metadata_json":     msg.MetadataJson,
	}

	return executeIdempotentMutation(
		ctx,
		h,
		wsID,
		"ProductService/Update",
		msg.Context,
		reqPayload,
		func() *commercev1.UpdateResponse { return &commercev1.UpdateResponse{} },
		func(txCtx context.Context, _ string) (*commercev1.UpdateResponse, error) {
			p := &Product{
				ProductID:             msg.ProductId,
				WorkspaceID:           wsID,
				PatchTitle:            msg.Title,
				PatchDescription:      msg.Description,
				PatchCategory:         msg.Category,
				PatchInventoryEnabled: msg.InventoryEnabled,
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
			if msg.InventoryEnabled != nil {
				p.InventoryEnabled = *msg.InventoryEnabled
			}
			if msg.BasePrice != nil {
				bpCurr := strings.ToUpper(strings.TrimSpace(msg.BasePrice.Currency))
				if !IsValidISOCurrency(bpCurr) {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: base_price.currency must be a 3-letter ISO code", ErrInvalidInput))
				}
				dec, err := tenantdb.ParseExactDecimal(msg.BasePrice.Amount)
				if err != nil {
					return nil, connect.NewError(connect.CodeInvalidArgument, err)
				}
				p.BasePrice = &dec
				p.Currency = bpCurr
			}
			if msg.Cogs != nil {
				cogsCurr := strings.ToUpper(strings.TrimSpace(msg.Cogs.Currency))
				if !IsValidISOCurrency(cogsCurr) {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: cogs.currency must be a 3-letter ISO code", ErrInvalidInput))
				}
				if p.Currency != "" && p.Currency != cogsCurr {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: cogs.currency %q does not match base_price.currency %q", ErrInvalidInput, cogsCurr, p.Currency))
				}
				dec, err := tenantdb.ParseExactDecimal(msg.Cogs.Amount)
				if err != nil {
					return nil, connect.NewError(connect.CodeInvalidArgument, err)
				}
				p.COGS = &dec
				if p.Currency == "" {
					p.Currency = cogsCurr
				}
			}
			if msg.CatalogStatus != nil {
				mapped := fromProtoCatalogStatus(*msg.CatalogStatus)
				if mapped == "" {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: invalid catalog_status %v", ErrInvalidInput, *msg.CatalogStatus))
				}
				p.CatalogStatus = mapped
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
			if msg.MetadataJson != nil {
				p.HasPatchMetadata = true
				p.PatchMetadata = make(map[string]any)
				if strings.TrimSpace(*msg.MetadataJson) != "" {
					if err := json.Unmarshal([]byte(*msg.MetadataJson), &p.PatchMetadata); err != nil {
						return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: invalid metadata_json: %v", ErrInvalidInput, err))
					}
					p.Metadata = p.PatchMetadata
				}
			}

			updated, err := h.service.UpdateProduct(txCtx, p)
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
		func(txCtx context.Context, _ string) (*commercev1.DeleteResponse, error) {
			if err := h.service.DeleteProduct(txCtx, wsID, msg.ProductId); err != nil {
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
		func(txCtx context.Context, _ string) (*commercev1.ArchiveResponse, error) {
			archived, err := h.service.ArchiveProduct(txCtx, wsID, msg.ProductId)
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
		func(txCtx context.Context, _ string) (*commercev1.BatchTagResponse, error) {
			count, err := h.service.BatchTagProducts(txCtx, wsID, msg.ProductIds, msg.TagsToAdd, msg.TagsToRemove)
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
		func(txCtx context.Context, _ string) (*commercev1.ImportResponse, error) {
			result, err := h.service.Import(
				txCtx,
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
	summary, err := h.service.GetSalesSummaryWithPeriod(ctx, wsID, msg.ProductId, msg.Period)
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
	case "", "day", "daily", "30d":
		days = 30
	case "week", "weekly", "7d":
		days = 7
	case "month", "monthly", "90d":
		days = 90
	default:
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: unsupported chart interval %q", ErrInvalidInput, msg.Interval))
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
		func(txCtx context.Context, _ string) (*commercev1.LinkContentResponse, error) {
			ref := ContentRef{
				ContentID:   msg.ContentId,
				ContentType: msg.ContentType,
				Title:       msg.Title,
				URL:         msg.Url,
			}
			if strings.TrimSpace(msg.MetadataJson) != "" {
				if err := json.Unmarshal([]byte(msg.MetadataJson), &ref.Metadata); err != nil {
					return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: invalid metadata_json: %v", ErrInvalidInput, err))
				}
			}
			saved, err := h.service.LinkContent(txCtx, wsID, msg.ProductId, ref)
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
	if len(msg.Reason) > 2000 {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: reason exceeds 2000 characters", ErrInvalidInput))
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
		func(txCtx context.Context, idemKey string) (*commercev1.UpdateStockResponse, error) {
			adjCtx := WithStockAdjustmentMeta(txCtx, msg.Reason, "rpc:"+idemKey)
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
		func(txCtx context.Context, _ string) (*commercev1.SetAlertThresholdResponse, error) {
			if err := h.service.SetAlertThreshold(txCtx, wsID, msg.SkuId, msg.LowStockThreshold); err != nil {
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
		func(txCtx context.Context, _ string) (*commercev1.BulkArchiveResponse, error) {
			count, err := h.service.BulkArchiveProducts(txCtx, wsID, msg.ProductIds)
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
	case errors.Is(err, ErrConcurrencyConflict), errors.Is(err, ErrInsufficientStock), errors.Is(err, ErrDuplicateImportToken), errors.Is(err, ErrProductArchived), errors.Is(err, ErrCurrencyMismatch):
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

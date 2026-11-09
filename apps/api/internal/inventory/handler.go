package inventory

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"strings"
	"sync"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type inventoryRPCBinding struct {
	permissionKey string
	roleEnvelope  string
}

var inventoryRPCBindings = map[string]inventoryRPCBinding{
	"InventoryService/GetSummary":          {permissionKey: "product:read", roleEnvelope: "Member"},
	"InventoryService/ListStock":           {permissionKey: "product:read", roleEnvelope: "Member"},
	"InventoryService/ListMovements":       {permissionKey: "product:read", roleEnvelope: "Member"},
	"InventoryService/CreateStockMovement": {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"InventoryService/BulkStockIn":         {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"InventoryService/GetAlerts":           {permissionKey: "product:read", roleEnvelope: "Member"},
	"InventoryService/UpdateThresholds":    {permissionKey: "product:manage", roleEnvelope: "Editor+"},
	"InventoryService/Export":              {permissionKey: "product:read", roleEnvelope: "Editor+"},
}

var inventoryRoleRank = map[string]int{
	rbac.RoleOwner:       7,
	rbac.RoleAdmin:       6,
	rbac.RoleManager:     5,
	rbac.RoleEditor:      4,
	rbac.RoleContributor: 3,
	rbac.RoleViewer:      2,
	rbac.RoleExternal:    1,
}

func checkInventoryRoleEnvelope(role, envelope string) error {
	rank, ok := inventoryRoleRank[strings.ToLower(strings.TrimSpace(role))]
	if !ok {
		return errors.New("inventory: caller lacks required role permission")
	}
	switch envelope {
	case "Owner":
		if rank < inventoryRoleRank[rbac.RoleOwner] {
			return errors.New("inventory: caller lacks required role permission")
		}
	case "Admin+":
		if rank < inventoryRoleRank[rbac.RoleAdmin] {
			return errors.New("inventory: caller lacks required role permission")
		}
	case "Manager+":
		if rank < inventoryRoleRank[rbac.RoleManager] {
			return errors.New("inventory: caller lacks required role permission")
		}
	case "Editor+":
		if rank < inventoryRoleRank[rbac.RoleEditor] {
			return errors.New("inventory: caller lacks required role permission")
		}
	case "Contributor+":
		if rank < inventoryRoleRank[rbac.RoleContributor] {
			return errors.New("inventory: caller lacks required role permission")
		}
	case "Viewer+", "Member":
		if rank < inventoryRoleRank[rbac.RoleViewer] {
			return errors.New("inventory: caller lacks required role permission")
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
		userID = "user-inventory-default"
	}
	return rbac.WithPolicyContext(ctx, rbac.PolicyContext{
		ActorUserID: userID,
		WorkspaceID: workspaceID,
		Role:        role,
	})
}

func authorizeInventoryRPC(ctx context.Context, rpcName string, cmdCtx *commonv1.CommandContext) (string, error) {
	binding, hasBinding := inventoryRPCBindings[rpcName]

	if pctx, ok := rbac.PolicyContextFromContext(ctx); ok && strings.TrimSpace(pctx.WorkspaceID) != "" {
		if cmdCtx != nil && cmdCtx.WorkspaceId != nil && strings.TrimSpace(cmdCtx.WorkspaceId.Value) != "" {
			if strings.TrimSpace(cmdCtx.WorkspaceId.Value) != strings.TrimSpace(pctx.WorkspaceID) {
				return "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
			}
		}
		if hasBinding {
			if err := rbac.CheckWorkspacePermission(binding.permissionKey, pctx); err != nil {
				return "", connect.NewError(connect.CodePermissionDenied, err)
			}
			if err := checkInventoryRoleEnvelope(pctx.Role, binding.roleEnvelope); err != nil {
				return "", connect.NewError(connect.CodePermissionDenied, err)
			}
		}
		return strings.TrimSpace(pctx.WorkspaceID), nil
	}

	if session, ok := transportauth.PrincipalFromContext(ctx); ok && strings.TrimSpace(session.WorkspaceID) != "" {
		if cmdCtx != nil && cmdCtx.WorkspaceId != nil && strings.TrimSpace(cmdCtx.WorkspaceId.Value) != "" {
			if strings.TrimSpace(cmdCtx.WorkspaceId.Value) != strings.TrimSpace(session.WorkspaceID) && !session.InternalAdmin {
				return "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
			}
		}
		role := rbac.RoleOwner
		if pctx, hasPolicy := rbac.PolicyContextFromContext(ctx); hasPolicy && strings.TrimSpace(pctx.Role) != "" {
			role = strings.ToLower(strings.TrimSpace(pctx.Role))
		}
		if hasBinding && !session.InternalAdmin {
			pctx := rbac.PolicyContext{
				ActorUserID: session.UserID,
				WorkspaceID: session.WorkspaceID,
				Role:        role,
			}
			if err := rbac.CheckWorkspacePermission(binding.permissionKey, pctx); err != nil {
				return "", connect.NewError(connect.CodePermissionDenied, err)
			}
			if err := checkInventoryRoleEnvelope(role, binding.roleEnvelope); err != nil {
				return "", connect.NewError(connect.CodePermissionDenied, err)
			}
		}
		return strings.TrimSpace(session.WorkspaceID), nil
	}

	return "", connect.NewError(connect.CodeUnauthenticated, ErrMissingTenant)
}

func validateCommandIdempotencyKey(cmdCtx *commonv1.CommandContext, rpcName string) (string, error) {
	if cmdCtx == nil {
		return "", connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("inventory: idempotency_key is required for %s", rpcName))
	}
	if len(cmdCtx.Reason) > 2000 {
		return "", connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: reason exceeds 2000 characters"))
	}
	key := strings.TrimSpace(cmdCtx.IdempotencyKey)
	if key == "" {
		return "", connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("inventory: idempotency_key is required for %s", rpcName))
	}
	if len(key) > 255 {
		return "", connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: idempotency_key exceeds 255 characters"))
	}
	return key, nil
}

func toProtoMovementType(mt string) commercev1.StockMovementType {
	switch mt {
	case MovementPurchase:
		return commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_PURCHASE
	case MovementSale:
		return commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_SALE
	case MovementReturn:
		return commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_RETURN
	case MovementAdjustment:
		return commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_ADJUSTMENT
	case MovementTransfer:
		return commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_TRANSFER
	case MovementDamage:
		return commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_DAMAGE
	case MovementPlatformSync:
		return commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_PLATFORM_SYNC
	default:
		return commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_UNSPECIFIED
	}
}

func fromProtoMovementType(pmt commercev1.StockMovementType) string {
	switch pmt {
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_PURCHASE:
		return MovementPurchase
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_SALE:
		return MovementSale
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_RETURN:
		return MovementReturn
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_ADJUSTMENT:
		return MovementAdjustment
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_TRANSFER:
		return MovementTransfer
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_DAMAGE:
		return MovementDamage
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_PLATFORM_SYNC:
		return MovementPlatformSync
	default:
		return MovementAdjustment
	}
}

func toProtoMovement(m *Movement) *commercev1.StockMovement {
	if m == nil {
		return nil
	}
	metaJSON, _ := json.Marshal(m.Metadata)
	pm := &commercev1.StockMovement{
		MovementId:    m.MovementID,
		WorkspaceId:   m.WorkspaceID,
		SkuId:         m.SkuID,
		LocationId:    m.LocationID,
		MovementType:  toProtoMovementType(m.MovementType),
		MovementKey:   m.MovementKey,
		Quantity:      m.Quantity,
		ReferenceType: m.ReferenceType,
		ReferenceId:   m.ReferenceID,
		Reason:        m.Reason,
		MetadataJson:  string(metaJSON),
		CreatedAt:     timestamppb.New(m.CreatedAt),
	}
	if m.SourceCreatedAt != nil {
		pm.SourceCreatedAt = timestamppb.New(*m.SourceCreatedAt)
	}
	return pm
}

func toProtoBalance(b *Balance) *commercev1.InventoryBalance {
	if b == nil {
		return nil
	}
	pb := &commercev1.InventoryBalance{
		BalanceId:   b.BalanceID,
		WorkspaceId: b.WorkspaceID,
		SkuId:       b.SkuID,
		LocationId:  b.LocationID,
		OnHand:      b.OnHand,
		Reserved:    b.Reserved,
		UpdatedAt:   timestamppb.New(b.UpdatedAt),
	}
	if b.OpeningAt != nil {
		pb.OpeningAt = timestamppb.New(*b.OpeningAt)
	}
	return pb
}

type Handler struct {
	service    *Service
	mu         sync.RWMutex
	thresholds map[string]int32
}

func NewHandler(service *Service) *Handler {
	return &Handler{
		service:    service,
		thresholds: make(map[string]int32),
	}
}

var _ commercev1connect.InventoryServiceHandler = (*Handler)(nil)

func (h *Handler) GetSummary(ctx context.Context, _ *connect.Request[commercev1.InventoryServiceGetSummaryRequest]) (*connect.Response[commercev1.InventoryServiceGetSummaryResponse], error) {
	wsID, err := authorizeInventoryRPC(ctx, "InventoryService/GetSummary", nil)
	if err != nil {
		return nil, err
	}

	balances, total, err := h.service.store.ListBalances(ctx, wsID, "", 1000, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var totalOnHand64, totalReserved64 int64
	lowStockAlerts := int32(0)

	for _, b := range balances {
		totalOnHand64 += int64(b.OnHand)
		totalReserved64 += int64(b.Reserved)
		threshold := h.getSkuThreshold(wsID, b.SkuID)
		if int64(b.OnHand)-int64(b.Reserved) <= int64(threshold) {
			lowStockAlerts++
		}
	}
	clampInt32 := func(v int64) int32 {
		if v > math.MaxInt32 {
			return math.MaxInt32
		}
		if v < math.MinInt32 {
			return math.MinInt32
		}
		return int32(v)
	}

	return connect.NewResponse(&commercev1.InventoryServiceGetSummaryResponse{
		TotalSkus:      int32(total),
		TotalOnHand:    clampInt32(totalOnHand64),
		TotalReserved:  clampInt32(totalReserved64),
		LowStockAlerts: lowStockAlerts,
	}), nil
}

func (h *Handler) ListStock(ctx context.Context, req *connect.Request[commercev1.InventoryServiceListStockRequest]) (*connect.Response[commercev1.InventoryServiceListStockResponse], error) {
	wsID, err := authorizeInventoryRPC(ctx, "InventoryService/ListStock", nil)
	if err != nil {
		return nil, err
	}
	msg := req.Msg
	limit := 50
	offset := 0
	if msg.Pagination != nil && msg.Pagination.PageSize > 0 {
		limit = int(msg.Pagination.PageSize)
		if limit > 100 {
			limit = 100
		}
	}

	balances, total, err := h.service.store.ListBalances(ctx, wsID, msg.LocationId, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoBalances []*commercev1.InventoryBalance
	for _, b := range balances {
		protoBalances = append(protoBalances, toProtoBalance(b))
	}

	return connect.NewResponse(&commercev1.InventoryServiceListStockResponse{
		Items: protoBalances,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(balances)) < total,
		},
	}), nil
}

func (h *Handler) ListMovements(ctx context.Context, req *connect.Request[commercev1.InventoryServiceListMovementsRequest]) (*connect.Response[commercev1.InventoryServiceListMovementsResponse], error) {
	wsID, err := authorizeInventoryRPC(ctx, "InventoryService/ListMovements", nil)
	if err != nil {
		return nil, err
	}
	msg := req.Msg
	limit := 50
	offset := 0
	if msg.Pagination != nil && msg.Pagination.PageSize > 0 {
		limit = int(msg.Pagination.PageSize)
		if limit > 100 {
			limit = 100
		}
	}

	movements, total, err := h.service.store.ListMovements(ctx, wsID, msg.SkuId, msg.LocationId, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoMovements []*commercev1.StockMovement
	for _, m := range movements {
		protoMovements = append(protoMovements, toProtoMovement(m))
	}

	return connect.NewResponse(&commercev1.InventoryServiceListMovementsResponse{
		Movements: protoMovements,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(movements)) < total,
		},
	}), nil
}

func isAllowedManualAdjustmentType(pmt commercev1.StockMovementType) (string, bool) {
	switch pmt {
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_PURCHASE:
		return MovementPurchase, true
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_ADJUSTMENT:
		return MovementAdjustment, true
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_DAMAGE:
		return MovementDamage, true
	case commercev1.StockMovementType_STOCK_MOVEMENT_TYPE_PLATFORM_SYNC:
		return MovementPlatformSync, true
	default:
		// Reject direct sale/return/transfer/unspecified fabrication on generic manual adjustment endpoint
		return "", false
	}
}

func mapInventoryHandlerError(err error) error {
	if err == nil {
		return nil
	}
	var connErr *connect.Error
	if errors.As(err, &connErr) {
		return connErr
	}
	switch {
	case errors.Is(err, ErrMissingTenant):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, ErrInvalidQuantity),
		errors.Is(err, ErrInvalidInput):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, ErrInsufficientStock),
		errors.Is(err, ErrNegativeSellable),
		errors.Is(err, ErrReservationConflict),
		errors.Is(err, ErrReservationExpired),
		errors.Is(err, ErrDiscrepancy),
		errors.Is(err, ErrReturnExceedsSold),
		errors.Is(err, ErrMovementImmutable):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, ErrMovementDuplicate):
		return connect.NewError(connect.CodeAlreadyExists, err)
	case errors.Is(err, ErrLocationNotFound),
		errors.Is(err, ErrSkuNotInitialized),
		errors.Is(err, ErrReservationNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

func (h *Handler) CreateStockMovement(ctx context.Context, req *connect.Request[commercev1.InventoryServiceCreateStockMovementRequest]) (*connect.Response[commercev1.InventoryServiceCreateStockMovementResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: request is required"))
	}
	wsID, err := authorizeInventoryRPC(ctx, "InventoryService/CreateStockMovement", msg.Context)
	if err != nil {
		return nil, err
	}
	idemKey, err := validateCommandIdempotencyKey(msg.Context, "InventoryService/CreateStockMovement")
	if err != nil {
		return nil, err
	}
	skuID := strings.TrimSpace(msg.SkuId)
	locID := strings.TrimSpace(msg.LocationId)
	if skuID == "" || locID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: sku_id and location_id are required"))
	}
	if msg.Quantity == 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidQuantity)
	}
	if len(msg.Reason) > 2000 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: reason exceeds 2000 characters"))
	}
	movType, ok := isAllowedManualAdjustmentType(msg.MovementType)
	if !ok {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("inventory: movement_type %v is not permitted on manual adjustment RPC", msg.MovementType))
	}

	movKey := fmt.Sprintf("manual:%s", idemKey)
	now := h.service.clock().UTC()
	mov := &Movement{
		MovementID:    newUUID(),
		WorkspaceID:   wsID,
		SkuID:         skuID,
		LocationID:    locID,
		MovementType:  movType,
		MovementKey:   movKey,
		Quantity:      msg.Quantity,
		ReferenceType: strings.TrimSpace(msg.ReferenceType),
		ReferenceID:   strings.TrimSpace(msg.ReferenceId),
		Reason:        msg.Reason,
		CreatedAt:     now,
	}

	pairs := []SkuLocPair{{SkuID: skuID, LocationID: locID}}
	var resultMov *Movement
	err = h.service.store.AtomicExecute(ctx, wsID, pairs, func(tx StoreTx) error {
		existing, err := tx.FindMovementByKey(ctx, wsID, movKey)
		if err != nil {
			return err
		}
		if existing != nil {
			if existing.SkuID != skuID || existing.LocationID != locID || existing.MovementType != movType || existing.Quantity != msg.Quantity {
				return ErrMovementDuplicate
			}
			resultMov = existing
			return nil
		}

		bal, err := tx.GetBalanceForUpdate(ctx, wsID, skuID, locID)
		if err != nil {
			return err
		}
		newOnHand, err := checkedAddInt32(bal.OnHand, msg.Quantity)
		if err != nil {
			return err
		}
		if newOnHand < 0 || int64(newOnHand)-int64(bal.Reserved) < 0 {
			return ErrInsufficientStock
		}
		bal.OnHand = newOnHand
		bal.UpdatedAt = now
		if err := tx.UpdateBalance(ctx, bal); err != nil {
			return err
		}
		if err := tx.AppendMovement(ctx, mov); err != nil {
			return err
		}
		resultMov = mov
		return nil
	})
	if err != nil {
		return nil, mapInventoryHandlerError(err)
	}

	bal, _ := h.service.store.GetBalance(ctx, wsID, skuID, locID)
	return connect.NewResponse(&commercev1.InventoryServiceCreateStockMovementResponse{
		Movement:   toProtoMovement(resultMov),
		NewBalance: toProtoBalance(bal),
	}), nil
}

func (h *Handler) BulkStockIn(ctx context.Context, req *connect.Request[commercev1.InventoryServiceBulkStockInRequest]) (*connect.Response[commercev1.InventoryServiceBulkStockInResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: request is required"))
	}
	wsID, err := authorizeInventoryRPC(ctx, "InventoryService/BulkStockIn", msg.Context)
	if err != nil {
		return nil, err
	}
	idemKey, err := validateCommandIdempotencyKey(msg.Context, "InventoryService/BulkStockIn")
	if err != nil {
		return nil, err
	}
	locID := strings.TrimSpace(msg.LocationId)
	if locID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: location_id is required"))
	}
	if len(msg.Items) == 0 || len(msg.Items) > 100 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: bulk stock-in items count must be between 1 and 100"))
	}
	if len(msg.Reason) > 2000 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: reason exceeds 2000 characters"))
	}

	pairs := make([]SkuLocPair, 0, len(msg.Items))
	sumBySku := make(map[string]int64, len(msg.Items))
	for _, item := range msg.Items {
		if item == nil || strings.TrimSpace(item.SkuId) == "" || item.Quantity <= 0 {
			return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidQuantity)
		}
		skuID := strings.TrimSpace(item.SkuId)
		sumBySku[skuID] += int64(item.Quantity)
		if sumBySku[skuID] <= 0 || sumBySku[skuID] > math.MaxInt32 {
			return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidQuantity)
		}
		pairs = append(pairs, SkuLocPair{
			SkuID:      skuID,
			LocationID: locID,
		})
	}

	now := h.service.clock().UTC()
	recorded := make([]*Movement, 0, len(msg.Items))
	err = h.service.store.AtomicExecute(ctx, wsID, pairs, func(tx StoreTx) error {
		existingByIdx := make(map[int]*Movement, len(msg.Items))
		projectedOnHandBySku := make(map[string]int32, len(sumBySku))
		for idx, item := range msg.Items {
			skuID := strings.TrimSpace(item.SkuId)
			movKey := fmt.Sprintf("bulk_stock_in:%s:%d", idemKey, idx)
			existing, err := tx.FindMovementByKey(ctx, wsID, movKey)
			if err != nil {
				return err
			}
			if existing != nil {
				if existing.SkuID != skuID || existing.LocationID != locID || existing.Quantity != item.Quantity {
					return ErrMovementDuplicate
				}
				existingByIdx[idx] = existing
				continue
			}

			currOnHand, loaded := projectedOnHandBySku[skuID]
			if !loaded {
				bal, err := tx.GetBalanceForUpdate(ctx, wsID, skuID, locID)
				if err != nil {
					return err
				}
				currOnHand = bal.OnHand
			}
			nextOnHand, err := checkedAddPositiveInt32(currOnHand, item.Quantity)
			if currOnHand == 0 {
				nextOnHand = item.Quantity
				err = nil
			} else if currOnHand < 0 {
				nextOnHand, err = checkedAddInt32(currOnHand, item.Quantity)
			}
			if err != nil {
				return err
			}
			projectedOnHandBySku[skuID] = nextOnHand
		}

		for idx, item := range msg.Items {
			if existing, ok := existingByIdx[idx]; ok {
				recorded = append(recorded, existing)
				continue
			}
			skuID := strings.TrimSpace(item.SkuId)
			movKey := fmt.Sprintf("bulk_stock_in:%s:%d", idemKey, idx)

			bal, err := tx.GetBalanceForUpdate(ctx, wsID, skuID, locID)
			if err != nil {
				return err
			}
			newOnHand, err := checkedAddInt32(bal.OnHand, item.Quantity)
			if err != nil {
				return err
			}
			bal.OnHand = newOnHand
			bal.UpdatedAt = now
			if err := tx.UpdateBalance(ctx, bal); err != nil {
				return err
			}

			mov := &Movement{
				MovementID:    newUUID(),
				WorkspaceID:   wsID,
				SkuID:         skuID,
				LocationID:    locID,
				MovementType:  MovementPurchase,
				MovementKey:   movKey,
				Quantity:      item.Quantity,
				ReferenceType: "bulk_stock_in",
				ReferenceID:   idemKey,
				Reason:        msg.Reason,
				CreatedAt:     now,
			}
			if err := tx.AppendMovement(ctx, mov); err != nil {
				return err
			}
			recorded = append(recorded, mov)
		}
		return nil
	})
	if err != nil {
		return nil, mapInventoryHandlerError(err)
	}

	protoMovements := make([]*commercev1.StockMovement, 0, len(recorded))
	for _, m := range recorded {
		protoMovements = append(protoMovements, toProtoMovement(m))
	}
	return connect.NewResponse(&commercev1.InventoryServiceBulkStockInResponse{
		ProcessedCount: int32(len(protoMovements)),
		Movements:      protoMovements,
	}), nil
}

func (h *Handler) getSkuThreshold(wsID, skuID string) int32 {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if t, ok := h.thresholds[wsID+":"+skuID]; ok {
		return t
	}
	return 5
}

func (h *Handler) GetAlerts(ctx context.Context, _ *connect.Request[commercev1.InventoryServiceGetAlertsRequest]) (*connect.Response[commercev1.InventoryServiceGetAlertsResponse], error) {
	wsID, err := authorizeInventoryRPC(ctx, "InventoryService/GetAlerts", nil)
	if err != nil {
		return nil, err
	}
	balances, _, err := h.service.store.ListBalances(ctx, wsID, "", 1000, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	var alerts []*commercev1.InventoryAlert
	for _, b := range balances {
		sellable := b.OnHand - b.Reserved
		threshold := h.getSkuThreshold(wsID, b.SkuID)
		if sellable <= threshold {
			level := "low_stock"
			if sellable <= 0 {
				level = "out_of_stock"
			}
			alerts = append(alerts, &commercev1.InventoryAlert{
				SkuId:        b.SkuID,
				SkuCode:      b.SkuID,
				CurrentStock: sellable,
				Threshold:    threshold,
				AlertLevel:   level,
			})
		}
	}
	return connect.NewResponse(&commercev1.InventoryServiceGetAlertsResponse{
		Alerts: alerts,
	}), nil
}

func (h *Handler) UpdateThresholds(ctx context.Context, req *connect.Request[commercev1.InventoryServiceUpdateThresholdsRequest]) (*connect.Response[commercev1.InventoryServiceUpdateThresholdsResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: request is required"))
	}
	wsID, err := authorizeInventoryRPC(ctx, "InventoryService/UpdateThresholds", msg.Context)
	if err != nil {
		return nil, err
	}
	if _, err := validateCommandIdempotencyKey(msg.Context, "InventoryService/UpdateThresholds"); err != nil {
		return nil, err
	}
	skuID := strings.TrimSpace(msg.SkuId)
	if skuID == "" || msg.LowStockThreshold < 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("inventory: valid sku_id and non-negative low_stock_threshold are required"))
	}
	h.mu.Lock()
	h.thresholds[wsID+":"+skuID] = msg.LowStockThreshold
	h.mu.Unlock()
	return connect.NewResponse(&commercev1.InventoryServiceUpdateThresholdsResponse{
		SkuId:             skuID,
		LowStockThreshold: msg.LowStockThreshold,
	}), nil
}

func (h *Handler) Export(ctx context.Context, req *connect.Request[commercev1.InventoryServiceExportRequest]) (*connect.Response[commercev1.InventoryServiceExportResponse], error) {
	wsID, err := authorizeInventoryRPC(ctx, "InventoryService/Export", nil)
	if err != nil {
		return nil, err
	}
	msg := req.Msg
	format := "csv"
	locID := ""
	if msg != nil {
		locID = strings.TrimSpace(msg.LocationId)
		if f := strings.ToLower(strings.TrimSpace(msg.Format)); f != "" {
			if f != "csv" && f != "json" {
				return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("inventory: unsupported export format %q", msg.Format))
			}
			format = f
		}
	}
	balances, _, err := h.service.store.ListBalances(ctx, wsID, locID, 1000, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&commercev1.InventoryServiceExportResponse{
		DownloadUrl: fmt.Sprintf("/exports/inventory.%s", format),
		RowCount:    int32(len(balances)),
	}), nil
}

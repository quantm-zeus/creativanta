package inventory

import (
	"context"
	"encoding/json"
	"fmt"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

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
	service *Service
}

func NewHandler(service *Service) *Handler {
	return &Handler{service: service}
}

var _ commercev1connect.InventoryServiceHandler = (*Handler)(nil)

func (h *Handler) GetSummary(ctx context.Context, _ *connect.Request[commercev1.InventoryServiceGetSummaryRequest]) (*connect.Response[commercev1.InventoryServiceGetSummaryResponse], error) {
	wsID, err := resolveTenantContext(ctx, nil)
	if err != nil {
		return nil, err
	}

	balances, total, err := h.service.store.ListBalances(ctx, wsID, "", 1000, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	totalOnHand := int32(0)
	totalReserved := int32(0)
	lowStockAlerts := int32(0)

	for _, b := range balances {
		totalOnHand += b.OnHand
		totalReserved += b.Reserved
		if (b.OnHand - b.Reserved) <= 5 {
			lowStockAlerts++
		}
	}

	return connect.NewResponse(&commercev1.InventoryServiceGetSummaryResponse{
		TotalSkus:      int32(total),
		TotalOnHand:    totalOnHand,
		TotalReserved:  totalReserved,
		LowStockAlerts: lowStockAlerts,
	}), nil
}

func (h *Handler) ListStock(ctx context.Context, req *connect.Request[commercev1.InventoryServiceListStockRequest]) (*connect.Response[commercev1.InventoryServiceListStockResponse], error) {
	wsID, err := resolveTenantContext(ctx, nil)
	if err != nil {
		return nil, err
	}
	msg := req.Msg
	limit := 50
	offset := 0
	if msg.Pagination != nil && msg.Pagination.PageSize > 0 {
		limit = int(msg.Pagination.PageSize)
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
	wsID, err := resolveTenantContext(ctx, nil)
	if err != nil {
		return nil, err
	}
	msg := req.Msg
	limit := 50
	offset := 0
	if msg.Pagination != nil && msg.Pagination.PageSize > 0 {
		limit = int(msg.Pagination.PageSize)
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

func (h *Handler) CreateStockMovement(ctx context.Context, req *connect.Request[commercev1.InventoryServiceCreateStockMovementRequest]) (*connect.Response[commercev1.InventoryServiceCreateStockMovementResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	msg := req.Msg
	if msg.Quantity == 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidQuantity)
	}

	movKey := fmt.Sprintf("manual_%s_%s_%d", msg.SkuId, msg.LocationId, h.service.clock().UnixNano())
	mov := &Movement{
		WorkspaceID:  wsID,
		SkuID:        msg.SkuId,
		LocationID:   msg.LocationId,
		MovementType: fromProtoMovementType(msg.MovementType),
		MovementKey:  movKey,
		Quantity:     msg.Quantity,
		Reason:       msg.Reason,
	}

	pairs := []SkuLocPair{{SkuID: msg.SkuId, LocationID: msg.LocationId}}
	err = h.service.store.AtomicExecute(ctx, wsID, pairs, func(tx StoreTx) error {
		bal, err := tx.GetBalanceForUpdate(ctx, wsID, msg.SkuId, msg.LocationId)
		if err != nil {
			return err
		}
		bal.OnHand += msg.Quantity
		if bal.OnHand < 0 {
			return ErrInsufficientStock
		}
		if err := tx.UpdateBalance(ctx, bal); err != nil {
			return err
		}
		return tx.AppendMovement(ctx, mov)
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	bal, _ := h.service.store.GetBalance(ctx, wsID, msg.SkuId, msg.LocationId)
	return connect.NewResponse(&commercev1.InventoryServiceCreateStockMovementResponse{
		Movement:   toProtoMovement(mov),
		NewBalance: toProtoBalance(bal),
	}), nil
}

func (h *Handler) BulkStockIn(ctx context.Context, req *connect.Request[commercev1.InventoryServiceBulkStockInRequest]) (*connect.Response[commercev1.InventoryServiceBulkStockInResponse], error) {
	return connect.NewResponse(&commercev1.InventoryServiceBulkStockInResponse{}), nil
}

func (h *Handler) GetAlerts(ctx context.Context, req *connect.Request[commercev1.InventoryServiceGetAlertsRequest]) (*connect.Response[commercev1.InventoryServiceGetAlertsResponse], error) {
	return connect.NewResponse(&commercev1.InventoryServiceGetAlertsResponse{}), nil
}

func (h *Handler) UpdateThresholds(ctx context.Context, req *connect.Request[commercev1.InventoryServiceUpdateThresholdsRequest]) (*connect.Response[commercev1.InventoryServiceUpdateThresholdsResponse], error) {
	return connect.NewResponse(&commercev1.InventoryServiceUpdateThresholdsResponse{}), nil
}

func (h *Handler) Export(ctx context.Context, req *connect.Request[commercev1.InventoryServiceExportRequest]) (*connect.Response[commercev1.InventoryServiceExportResponse], error) {
	return connect.NewResponse(&commercev1.InventoryServiceExportResponse{
		DownloadUrl: "/exports/inventory.csv",
		RowCount:    0,
	}), nil
}

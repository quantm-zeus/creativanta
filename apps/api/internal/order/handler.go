package order

import (
	"context"
	"encoding/json"
	"errors"
	"strings"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/publicapi"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// MembershipRoleResolver looks up a user's active membership role in a workspace.
type MembershipRoleResolver func(ctx context.Context, workspaceID, userID string) (role string, active bool, err error)

func authorizeTenantOrderOperation(
	ctx context.Context,
	cmdCtx *commonv1.CommandContext,
	roleResolver MembershipRoleResolver,
	requiredPermission string,
	requiredAPIScope string,
) (string, error) {
	session, ok := transportauth.PrincipalFromContext(ctx)
	apiKey, hasAPIKey := publicapi.AuthenticatedKeyFromContext(ctx)
	if !ok && hasAPIKey {
		session = transportauth.Session{
			UserID:       apiKey.APIKeyID,
			WorkspaceID:  apiKey.WorkspaceID,
			ScopesCSV:    transportauth.JoinScopes(apiKey.Scopes),
			ServiceKeyID: apiKey.APIKeyID,
		}
		ok = true
	}
	if !ok || !tenantdb.IsValidNonZeroUUID(session.WorkspaceID) {
		return "", connect.NewError(connect.CodeUnauthenticated, ErrMissingTenant)
	}
	if hasAPIKey && apiKey.WorkspaceID != session.WorkspaceID {
		return "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}
	if cmdCtx != nil && cmdCtx.WorkspaceId != nil && cmdCtx.WorkspaceId.Value != "" {
		if cmdCtx.WorkspaceId.Value != session.WorkspaceID {
			return "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
		}
	}

	// Service / Public API key caller: enforce exact scope and read-only rules
	if session.ServiceKeyID != "" || hasAPIKey {
		scopes := session.ScopeList()
		if len(scopes) == 0 && hasAPIKey {
			scopes = apiKey.Scopes
		}
		if strings.HasPrefix(requiredAPIScope, "write:") && publicapi.IsReadOnlyScopes(scopes) {
			return "", connect.NewError(connect.CodePermissionDenied, publicapi.ErrReadOnlyMutationForbidden)
		}
		if !publicapi.HasScope(scopes, requiredAPIScope) {
			return "", connect.NewError(connect.CodePermissionDenied, publicapi.ErrScopeUnauthorized)
		}
		return session.WorkspaceID, nil
	}

	if session.InternalAdmin {
		return "", connect.NewError(connect.CodePermissionDenied, rbac.ErrPermissionDenied)
	}
	if !tenantdb.IsValidNonZeroUUID(session.UserID) {
		return "", connect.NewError(connect.CodeUnauthenticated, ErrMissingTenant)
	}

	role := strings.ToLower(strings.TrimSpace(session.Role))
	if roleResolver != nil {
		resolvedRole, active, err := roleResolver(ctx, session.WorkspaceID, session.UserID)
		if err != nil || !active {
			return "", connect.NewError(connect.CodePermissionDenied, rbac.ErrPermissionDenied)
		}
		role = strings.ToLower(strings.TrimSpace(resolvedRole))
	}
	if role == "" {
		return "", connect.NewError(connect.CodePermissionDenied, rbac.ErrPermissionDenied)
	}
	if err := rbac.CheckWorkspacePermission(requiredPermission, rbac.PolicyContext{
		Role:        role,
		ActorUserID: session.UserID,
	}); err != nil {
		return "", connect.NewError(connect.CodePermissionDenied, err)
	}
	return session.WorkspaceID, nil
}

func toProtoLifecycleState(s LifecycleState) commercev1.OrderLifecycleState {
	switch s {
	case StateCreated:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_CREATED
	case StateConfirmed:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_CONFIRMED
	case StateFulfilled:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_FULFILLED
	case StateCompleted:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_COMPLETED
	case StatePartiallyRefunded:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_PARTIALLY_REFUNDED
	case StateRefunded:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_REFUNDED
	case StateReturned:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_RETURNED
	case StateCancelled:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_CANCELLED
	default:
		return commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func fromProtoLifecycleState(s commercev1.OrderLifecycleState) LifecycleState {
	switch s {
	case commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_CREATED:
		return StateCreated
	case commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_CONFIRMED:
		return StateConfirmed
	case commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_FULFILLED:
		return StateFulfilled
	case commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_COMPLETED:
		return StateCompleted
	case commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_PARTIALLY_REFUNDED:
		return StatePartiallyRefunded
	case commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_REFUNDED:
		return StateRefunded
	case commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_RETURNED:
		return StateReturned
	case commercev1.OrderLifecycleState_ORDER_LIFECYCLE_STATE_CANCELLED:
		return StateCancelled
	default:
		return ""
	}
}

func toProtoRefundState(s RefundState) commercev1.RefundLifecycleState {
	switch s {
	case RefundRequested:
		return commercev1.RefundLifecycleState_REFUND_LIFECYCLE_STATE_REQUESTED
	case RefundApproved:
		return commercev1.RefundLifecycleState_REFUND_LIFECYCLE_STATE_APPROVED
	case RefundRejected:
		return commercev1.RefundLifecycleState_REFUND_LIFECYCLE_STATE_REJECTED
	case RefundProcessing:
		return commercev1.RefundLifecycleState_REFUND_LIFECYCLE_STATE_PROCESSING
	case RefundCompleted:
		return commercev1.RefundLifecycleState_REFUND_LIFECYCLE_STATE_COMPLETED
	case RefundFailed:
		return commercev1.RefundLifecycleState_REFUND_LIFECYCLE_STATE_FAILED
	case RefundCancelled:
		return commercev1.RefundLifecycleState_REFUND_LIFECYCLE_STATE_CANCELLED
	default:
		return commercev1.RefundLifecycleState_REFUND_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func toProtoSourceClass(sc SourceClass) commercev1.OrderSourceClass {
	switch sc {
	case SourceClassOfficial:
		return commercev1.OrderSourceClass_ORDER_SOURCE_CLASS_OFFICIAL
	case SourceClassImported:
		return commercev1.OrderSourceClass_ORDER_SOURCE_CLASS_IMPORTED
	case SourceClassInferred:
		return commercev1.OrderSourceClass_ORDER_SOURCE_CLASS_INFERRED
	case SourceClassEstimated:
		return commercev1.OrderSourceClass_ORDER_SOURCE_CLASS_ESTIMATED
	case SourceClassUnreconciled:
		return commercev1.OrderSourceClass_ORDER_SOURCE_CLASS_UNRECONCILED
	default:
		return commercev1.OrderSourceClass_ORDER_SOURCE_CLASS_UNSPECIFIED
	}
}

func toProtoOrder(o *Order) *commercev1.Order {
	if o == nil {
		return nil
	}

	var protoItems []*commercev1.OrderItem
	for _, it := range o.Items {
		protoItems = append(protoItems, &commercev1.OrderItem{
			Sku:             it.Sku,
			ProductId:       it.ProductID,
			Name:            it.Name,
			Quantity:        it.Quantity,
			UnitPrice:       &commonv1.Money{Amount: it.UnitPrice.Fixed6String(), Currency: o.Currency},
			Discount:        &commonv1.Money{Amount: it.Discount.Fixed6String(), Currency: o.Currency},
			Total:           &commonv1.Money{Amount: it.Total.Fixed6String(), Currency: o.Currency},
			UnitCogs:        &commonv1.Money{Amount: it.UnitCogs.Fixed6String(), Currency: o.Currency},
			CogsSourceClass: toProtoSourceClass(it.CogsSourceClass),
			Variation:       it.Variation,
			PlatformItemId:  it.PlatformItemID,
		})
	}

	rateJSON, _ := json.Marshal(o.ExchangeRateSnapshot)
	shipJSON, _ := json.Marshal(o.ShippingAddress)
	metaJSON, _ := json.Marshal(o.Metadata)

	var protoOtherFees []*commercev1.OtherFee
	for _, of := range o.FeeBreakdown.OtherFees {
		protoOtherFees = append(protoOtherFees, &commercev1.OtherFee{
			Name:   of.Name,
			Amount: &commonv1.Money{Amount: of.Amount.Fixed6String(), Currency: o.Currency},
		})
	}

	po := &commercev1.Order{
		OrderId:                  o.OrderID,
		WorkspaceId:              o.WorkspaceID,
		SourceClass:              toProtoSourceClass(o.SourceClass),
		SourcePlatform:           o.SourcePlatform,
		ExternalOrderId:          o.ExternalOrderID,
		ConnectedAccountId:       o.ConnectedAccountID,
		TaxAmount:                &commonv1.Money{Amount: o.TaxAmount.Fixed6String(), Currency: o.Currency},
		TaxJurisdiction:          o.TaxJurisdiction,
		TaxNote:                  o.TaxNote,
		ExchangeRateSnapshotJson: string(rateJSON),
		ImportFingerprint:        o.ImportFingerprint,
		LifecycleState:           toProtoLifecycleState(o.LifecycleState),
		Amount:                   &commonv1.Money{Amount: o.Amount.Fixed6String(), Currency: o.Currency},
		Currency:                 o.Currency,
		ProductId:                o.ProductID,
		OfferId:                  o.OfferID,
		CampaignId:               o.CampaignID,
		PostId:                   o.PostID,
		LiveSessionId:            o.LiveSessionID,
		CustomerEntityId:         o.CustomerEntityID,
		Items:                    protoItems,
		FeeBreakdown: &commercev1.FeeBreakdown{
			PlatformFee:          &commonv1.Money{Amount: o.FeeBreakdown.PlatformFee.Fixed6String(), Currency: o.Currency},
			PaymentProcessingFee: &commonv1.Money{Amount: o.FeeBreakdown.PaymentFee.Fixed6String(), Currency: o.Currency},
			Commission:           &commonv1.Money{Amount: o.FeeBreakdown.AffiliateCommission.Fixed6String(), Currency: o.Currency},
			ShippingFee:          &commonv1.Money{Amount: o.FeeBreakdown.ShippingCost.Fixed6String(), Currency: o.Currency},
			Tax:                  &commonv1.Money{Amount: o.FeeBreakdown.VatAmount.Fixed6String(), Currency: o.Currency},
			OtherFees:            protoOtherFees,
			Currency:             o.Currency,
		},
		ShippingAddressJson: string(shipJSON),
		ReconciliationState: o.ReconciliationState,
		EvidenceRefs:        o.EvidenceRefs,
		MetadataJson:        string(metaJSON),
		OrderedAt:           timestamppb.New(o.OrderedAt),
		CreatedAt:           timestamppb.New(o.CreatedAt),
		UpdatedAt:           timestamppb.New(o.UpdatedAt),
	}
	if o.RecognizedAt != nil {
		po.RecognizedAt = timestamppb.New(*o.RecognizedAt)
	}
	if o.SourceUpdatedAt != nil {
		po.SourceUpdatedAt = timestamppb.New(*o.SourceUpdatedAt)
	}
	if o.DeletedAt != nil {
		po.DeletedAt = timestamppb.New(*o.DeletedAt)
	}
	return po
}

func toProtoRefund(r *Refund) *commercev1.Refund {
	if r == nil {
		return nil
	}
	pr := &commercev1.Refund{
		RefundId:         r.RefundID,
		WorkspaceId:      r.WorkspaceID,
		OrderId:          r.OrderID,
		RefundType:       r.RefundType,
		Amount:           &commonv1.Money{Amount: r.Amount.Fixed6String(), Currency: r.Currency},
		Currency:         r.Currency,
		Reason:           r.Reason,
		LifecycleState:   toProtoRefundState(r.LifecycleState),
		SourceClass:      toProtoSourceClass(r.SourceClass),
		SourcePlatform:   r.SourcePlatform,
		ExternalRefundId: r.ExternalRefundID,
		SettlementId:     r.SettlementID,
		EvidenceRefs:     r.EvidenceRefs,
		CreatedAt:        timestamppb.New(r.CreatedAt),
		UpdatedAt:        timestamppb.New(r.UpdatedAt),
	}
	if r.DeletedAt != nil {
		pr.DeletedAt = timestamppb.New(*r.DeletedAt)
	}
	return pr
}

// ----------------------------------------------------------------------------
// OrderService Handler
// ----------------------------------------------------------------------------

type OrderHandler struct {
	service      *Service
	roleResolver MembershipRoleResolver
}

func NewOrderHandler(service *Service) *OrderHandler {
	return &OrderHandler{service: service}
}

func (h *OrderHandler) WithMembershipRoleResolver(resolver MembershipRoleResolver) *OrderHandler {
	h.roleResolver = resolver
	return h
}

var _ commercev1connect.OrderServiceHandler = (*OrderHandler)(nil)

func (h *OrderHandler) List(ctx context.Context, req *connect.Request[commercev1.OrderServiceListRequest]) (*connect.Response[commercev1.OrderServiceListResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "order:read", "read:orders")
	if err != nil {
		return nil, err
	}
	msg := req.Msg
	limit := 50
	offset := 0
	if msg.Pagination != nil && msg.Pagination.PageSize > 0 {
		limit = int(msg.Pagination.PageSize)
	}
	filter := OrderFilter{
		State:          fromProtoLifecycleState(msg.State),
		SourcePlatform: msg.SourcePlatform,
	}
	if msg.DateFrom != "" {
		if t, err := time.Parse(time.RFC3339, msg.DateFrom); err == nil {
			filter.DateFrom = &t
		}
	}
	if msg.DateTo != "" {
		if t, err := time.Parse(time.RFC3339, msg.DateTo); err == nil {
			filter.DateTo = &t
		}
	}

	orders, total, err := h.service.store.ListOrders(ctx, wsID, filter, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoOrders []*commercev1.Order
	for _, o := range orders {
		protoOrders = append(protoOrders, toProtoOrder(o))
	}

	return connect.NewResponse(&commercev1.OrderServiceListResponse{
		Orders: protoOrders,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(orders)) < total,
		},
	}), nil
}

func (h *OrderHandler) Get(ctx context.Context, req *connect.Request[commercev1.OrderServiceGetRequest]) (*connect.Response[commercev1.OrderServiceGetResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "order:read", "read:orders")
	if err != nil {
		return nil, err
	}
	o, err := h.service.store.GetOrder(ctx, wsID, req.Msg.OrderId)
	if err != nil {
		if errors.Is(err, ErrOrderNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	refunds, _ := h.service.store.ListRefundsByOrder(ctx, wsID, req.Msg.OrderId)
	var protoRefunds []*commercev1.Refund
	for _, r := range refunds {
		protoRefunds = append(protoRefunds, toProtoRefund(r))
	}

	return connect.NewResponse(&commercev1.OrderServiceGetResponse{
		Order:   toProtoOrder(o),
		Refunds: protoRefunds,
	}), nil
}

func (h *OrderHandler) Import(ctx context.Context, req *connect.Request[commercev1.OrderServiceImportRequest]) (*connect.Response[commercev1.OrderServiceImportResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, req.Msg.Context, h.roleResolver, "order:manage", "write:orders")
	if err != nil {
		return nil, err
	}
	_ = wsID
	return connect.NewResponse(&commercev1.OrderServiceImportResponse{
		TotalRows:      0,
		CreateCount:    0,
		UpdateCount:    0,
		UnchangedCount: 0,
	}), nil
}

func (h *OrderHandler) Export(ctx context.Context, req *connect.Request[commercev1.OrderServiceExportRequest]) (*connect.Response[commercev1.OrderServiceExportResponse], error) {
	if _, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "order:export", "read:orders"); err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.OrderServiceExportResponse{
		DownloadUrl: "/exports/orders.csv",
		RowCount:    0,
	}), nil
}

func (h *OrderHandler) UpdateStatus(ctx context.Context, req *connect.Request[commercev1.OrderServiceUpdateStatusRequest]) (*connect.Response[commercev1.OrderServiceUpdateStatusResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, req.Msg.Context, h.roleResolver, "order:manage", "write:orders")
	if err != nil {
		return nil, err
	}
	targetState := fromProtoLifecycleState(req.Msg.TargetState)
	var o *Order
	switch targetState {
	case StateConfirmed:
		o, err = h.service.ConfirmOrder(ctx, wsID, req.Msg.OrderId)
	case StateFulfilled:
		o, err = h.service.FulfillOrder(ctx, wsID, req.Msg.OrderId)
	case StateCompleted:
		o, err = h.service.CompleteOrder(ctx, wsID, req.Msg.OrderId)
	case StateCancelled:
		o, err = h.service.CancelOrder(ctx, wsID, req.Msg.OrderId, req.Msg.Reason)
	default:
		err = connect.NewError(connect.CodeInvalidArgument, ErrInvalidOrderTransition)
	}
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.OrderServiceUpdateStatusResponse{
		Order: toProtoOrder(o),
	}), nil
}

func (h *OrderHandler) Search(ctx context.Context, req *connect.Request[commercev1.OrderServiceSearchRequest]) (*connect.Response[commercev1.OrderServiceSearchResponse], error) {
	if _, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "order:read", "read:orders"); err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.OrderServiceSearchResponse{}), nil
}

func (h *OrderHandler) Confirm(ctx context.Context, req *connect.Request[commercev1.OrderServiceConfirmRequest]) (*connect.Response[commercev1.OrderServiceConfirmResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, req.Msg.Context, h.roleResolver, "order:manage", "write:orders")
	if err != nil {
		return nil, err
	}
	o, err := h.service.ConfirmOrder(ctx, wsID, req.Msg.OrderId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	return connect.NewResponse(&commercev1.OrderServiceConfirmResponse{
		Order: toProtoOrder(o),
	}), nil
}

func (h *OrderHandler) GetTodayStats(ctx context.Context, req *connect.Request[commercev1.OrderServiceGetTodayStatsRequest]) (*connect.Response[commercev1.OrderServiceGetTodayStatsResponse], error) {
	if _, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "order:read", "read:orders"); err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.OrderServiceGetTodayStatsResponse{}), nil
}

func (h *OrderHandler) GetDailyStats(ctx context.Context, req *connect.Request[commercev1.OrderServiceGetDailyStatsRequest]) (*connect.Response[commercev1.OrderServiceGetDailyStatsResponse], error) {
	if _, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "order:read", "read:orders"); err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.OrderServiceGetDailyStatsResponse{}), nil
}

func (h *OrderHandler) GetLabel(ctx context.Context, req *connect.Request[commercev1.OrderServiceGetLabelRequest]) (*connect.Response[commercev1.OrderServiceGetLabelResponse], error) {
	if _, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "order:read", "read:orders"); err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.OrderServiceGetLabelResponse{}), nil
}

func (h *OrderHandler) ListRecent(ctx context.Context, req *connect.Request[commercev1.OrderServiceListRecentRequest]) (*connect.Response[commercev1.OrderServiceListRecentResponse], error) {
	if _, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "order:read", "read:orders"); err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.OrderServiceListRecentResponse{}), nil
}

func (h *OrderHandler) BulkCancel(ctx context.Context, req *connect.Request[commercev1.OrderServiceBulkCancelRequest]) (*connect.Response[commercev1.OrderServiceBulkCancelResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, req.Msg.Context, h.roleResolver, "order:manage", "write:orders")
	if err != nil {
		return nil, err
	}
	successCount := int32(0)
	for _, id := range req.Msg.OrderIds {
		if _, err := h.service.CancelOrder(ctx, wsID, id, req.Msg.Reason); err == nil {
			successCount++
		}
	}
	return connect.NewResponse(&commercev1.OrderServiceBulkCancelResponse{
		CancelledCount: successCount,
	}), nil
}

func (h *OrderHandler) BulkUpdateStatus(ctx context.Context, req *connect.Request[commercev1.OrderServiceBulkUpdateStatusRequest]) (*connect.Response[commercev1.OrderServiceBulkUpdateStatusResponse], error) {
	if _, err := authorizeTenantOrderOperation(ctx, req.Msg.Context, h.roleResolver, "order:manage", "write:orders"); err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.OrderServiceBulkUpdateStatusResponse{}), nil
}

// ----------------------------------------------------------------------------
// RefundService Handler
// ----------------------------------------------------------------------------

type RefundHandler struct {
	service      *Service
	roleResolver MembershipRoleResolver
}

func NewRefundHandler(service *Service) *RefundHandler {
	return &RefundHandler{service: service}
}

func (h *RefundHandler) WithMembershipRoleResolver(resolver MembershipRoleResolver) *RefundHandler {
	h.roleResolver = resolver
	return h
}

var _ commercev1connect.RefundServiceHandler = (*RefundHandler)(nil)

func (h *RefundHandler) Create(ctx context.Context, req *connect.Request[commercev1.RefundServiceCreateRequest]) (*connect.Response[commercev1.RefundServiceCreateResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, req.Msg.Context, h.roleResolver, "refund:manage", "write:orders")
	if err != nil {
		return nil, err
	}
	msg := req.Msg
	if msg.Amount == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidAmount)
	}
	amt, err := tenantdb.ParseExactDecimal(msg.Amount.Amount)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	r := &Refund{
		WorkspaceID: wsID,
		OrderID:     msg.OrderId,
		Amount:      amt,
		Currency:    msg.Amount.Currency,
		Reason:      msg.Reason,
		RefundType:  msg.RefundType,
	}

	createdRef, updatedOrd, err := h.service.RequestRefund(ctx, r)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.RefundServiceCreateResponse{
		Refund:       toProtoRefund(createdRef),
		UpdatedOrder: toProtoOrder(updatedOrd),
	}), nil
}

func (h *RefundHandler) Get(ctx context.Context, req *connect.Request[commercev1.RefundServiceGetRequest]) (*connect.Response[commercev1.RefundServiceGetResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "refund:read", "read:orders")
	if err != nil {
		return nil, err
	}
	r, err := h.service.store.GetRefund(ctx, wsID, req.Msg.RefundId)
	if err != nil {
		if errors.Is(err, ErrRefundNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&commercev1.RefundServiceGetResponse{
		Refund: toProtoRefund(r),
	}), nil
}

func (h *RefundHandler) List(ctx context.Context, req *connect.Request[commercev1.RefundServiceListRequest]) (*connect.Response[commercev1.RefundServiceListResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "refund:read", "read:orders")
	if err != nil {
		return nil, err
	}
	refunds, err := h.service.store.ListRefundsByOrder(ctx, wsID, req.Msg.OrderId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	var protoRefunds []*commercev1.Refund
	for _, r := range refunds {
		protoRefunds = append(protoRefunds, toProtoRefund(r))
	}
	totalCount := int64(len(refunds))
	return connect.NewResponse(&commercev1.RefundServiceListResponse{
		Refunds: protoRefunds,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &totalCount,
			HasMore:    false,
		},
	}), nil
}

func (h *RefundHandler) Approve(ctx context.Context, req *connect.Request[commercev1.RefundServiceApproveRequest]) (*connect.Response[commercev1.RefundServiceApproveResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, req.Msg.Context, h.roleResolver, "refund:manage", "write:orders")
	if err != nil {
		return nil, err
	}
	appRef, updatedOrd, err := h.service.ApproveRefund(ctx, wsID, req.Msg.RefundId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	return connect.NewResponse(&commercev1.RefundServiceApproveResponse{
		Refund:       toProtoRefund(appRef),
		UpdatedOrder: toProtoOrder(updatedOrd),
	}), nil
}

func (h *RefundHandler) Reject(ctx context.Context, req *connect.Request[commercev1.RefundServiceRejectRequest]) (*connect.Response[commercev1.RefundServiceRejectResponse], error) {
	wsID, err := authorizeTenantOrderOperation(ctx, req.Msg.Context, h.roleResolver, "refund:manage", "write:orders")
	if err != nil {
		return nil, err
	}
	if err := h.service.store.UpdateRefundStatus(ctx, wsID, req.Msg.RefundId, RefundRejected); err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}
	r, err := h.service.store.GetRefund(ctx, wsID, req.Msg.RefundId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&commercev1.RefundServiceRejectResponse{
		Refund: toProtoRefund(r),
	}), nil
}

func (h *RefundHandler) GetStats(ctx context.Context, req *connect.Request[commercev1.RefundServiceGetStatsRequest]) (*connect.Response[commercev1.RefundServiceGetStatsResponse], error) {
	if _, err := authorizeTenantOrderOperation(ctx, nil, h.roleResolver, "refund:read", "read:orders"); err != nil {
		return nil, err
	}
	return connect.NewResponse(&commercev1.RefundServiceGetStatsResponse{}), nil
}

package publicapi

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	v1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/platform/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/platform/v1/platformv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

// MembershipRoleResolver looks up a user's active membership role in a workspace.
type MembershipRoleResolver func(ctx context.Context, workspaceID, userID string) (role string, active bool, err error)

// Handler implements platformv1connect.APIKeyServiceHandler and WebhookSubscriptionServiceHandler.
type Handler struct {
	service      *Service
	dispatcher   *OutboundDispatcher
	roleResolver MembershipRoleResolver
}

func NewHandler(service *Service, dispatcher *OutboundDispatcher) *Handler {
	return &Handler{
		service:    service,
		dispatcher: dispatcher,
	}
}

// WithMembershipRoleResolver configures server-side active membership role resolution for API key management.
func (h *Handler) WithMembershipRoleResolver(resolver MembershipRoleResolver) *Handler {
	h.roleResolver = resolver
	return h
}

var _ platformv1connect.APIKeyServiceHandler = (*Handler)(nil)
var _ platformv1connect.WebhookSubscriptionServiceHandler = (*Handler)(nil)

// resolveAdminCaller checks caller is an authenticated workspace member with api_key:manage (Owner or Admin)
// and never accepts unauthenticated/synthetic workspace fallbacks or service keys (AUTH-01).
func (h *Handler) resolveAdminCaller(ctx context.Context, explicitWorkspaceID string) (userID, workspaceID string, err error) {
	session, ok := transportauth.PrincipalFromContext(ctx)
	if !ok || !tenantdb.IsValidNonZeroUUID(session.UserID) || !tenantdb.IsValidNonZeroUUID(session.WorkspaceID) {
		return "", "", connect.NewError(connect.CodeUnauthenticated, errors.New("unauthenticated: verified user principal required"))
	}
	if session.ServiceKeyID != "" || session.InternalAdmin {
		return "", "", connect.NewError(connect.CodePermissionDenied, rbac.ErrPermissionDenied)
	}
	if explicitWorkspaceID != "" && explicitWorkspaceID != session.WorkspaceID {
		return "", "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}

	role := strings.ToLower(strings.TrimSpace(session.Role))
	if h != nil && h.roleResolver != nil {
		resolvedRole, active, err := h.roleResolver(ctx, session.WorkspaceID, session.UserID)
		if err != nil || !active {
			return "", "", connect.NewError(connect.CodePermissionDenied, rbac.ErrPermissionDenied)
		}
		role = strings.ToLower(strings.TrimSpace(resolvedRole))
	}
	if role == "" {
		return "", "", connect.NewError(connect.CodePermissionDenied, rbac.ErrPermissionDenied)
	}
	if err := rbac.CheckWorkspacePermission("api_key:manage", rbac.PolicyContext{
		Role:        role,
		ActorUserID: session.UserID,
	}); err != nil {
		return "", "", connect.NewError(connect.CodePermissionDenied, err)
	}

	return session.UserID, session.WorkspaceID, nil
}

// =============================================================================
// APIKeyServiceHandler Implementation
// =============================================================================

func (h *Handler) Create(ctx context.Context, req *connect.Request[v1.CreateRequest]) (*connect.Response[v1.CreateResponse], error) {
	userID, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	entity, rawKey, err := h.service.CreateKey(ctx, wsID, req.Msg.Name, req.Msg.Scopes, int(req.Msg.RateLimitOverride), int(req.Msg.ExpiryDays), userID)
	if err != nil {
		if errors.Is(err, ErrTierKeyCapExceeded) {
			return nil, connect.NewError(connect.CodeResourceExhausted, err)
		}
		if errors.Is(err, ErrTierModeViolation) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	protoKey := mapEntityToProto(entity)
	protoKey.SecretKey = rawKey

	return connect.NewResponse(&v1.CreateResponse{
		ApiKey:    protoKey,
		SecretKey: rawKey,
	}), nil
}

func (h *Handler) List(ctx context.Context, req *connect.Request[v1.ListRequest]) (*connect.Response[v1.ListResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	keys, err := h.service.ListKeys(ctx, wsID, req.Msg.StatusFilter)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoKeys []*v1.APIKey
	for _, k := range keys {
		protoKeys = append(protoKeys, mapEntityToProto(k))
	}

	return connect.NewResponse(&v1.ListResponse{
		ApiKeys:    protoKeys,
		TotalCount: int32(len(protoKeys)),
	}), nil
}

func (h *Handler) Revoke(ctx context.Context, req *connect.Request[v1.RevokeRequest]) (*connect.Response[v1.RevokeResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	entity, err := h.service.RevokeKey(ctx, wsID, req.Msg.ApiKeyId, req.Msg.Reason)
	if err != nil {
		if errors.Is(err, ErrKeyNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&v1.RevokeResponse{
		ApiKey: mapEntityToProto(entity),
	}), nil
}

func (h *Handler) Rotate(ctx context.Context, req *connect.Request[v1.RotateRequest]) (*connect.Response[v1.RotateResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	oldKey, newKey, newRawKey, graceEnds, err := h.service.RotateKey(ctx, wsID, req.Msg.ApiKeyId)
	if err != nil {
		if errors.Is(err, ErrKeyNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		if errors.Is(err, ErrKeyRevoked) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoNewKey := mapEntityToProto(newKey)
	protoNewKey.SecretKey = newRawKey

	return connect.NewResponse(&v1.RotateResponse{
		OldKey:       mapEntityToProto(oldKey),
		NewKey:       protoNewKey,
		NewSecretKey: newRawKey,
		GraceEndsAt:  timestamppb.New(graceEnds),
	}), nil
}

func (h *Handler) GetUsage(ctx context.Context, req *connect.Request[v1.GetUsageRequest]) (*connect.Response[v1.GetUsageResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	monthReqs, quota, readRPM, writeRPM, billableAI, err := h.service.GetUsage(ctx, wsID, req.Msg.ApiKeyId)
	if err != nil {
		if errors.Is(err, ErrKeyNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&v1.GetUsageResponse{
		WorkspaceId:           wsID,
		ApiKeyId:              req.Msg.ApiKeyId,
		CurrentMonthRequests:  monthReqs,
		MonthlyQuota:          quota,
		ReadRateLimitRpm:      int32(readRPM),
		WriteRateLimitRpm:     int32(writeRPM),
		BillableAiCreditsUsed: billableAI,
	}), nil
}

func (h *Handler) GetUsageStats(ctx context.Context, req *connect.Request[v1.GetUsageStatsRequest]) (*connect.Response[v1.GetUsageStatsResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	stats, err := h.service.GetUsageStats(ctx, wsID, req.Msg.ApiKeyId, req.Msg.StartDate, req.Msg.EndDate)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var totalReqs int64
	var totalAI float64
	var protoDaily []*v1.APIUsageDaily

	for _, s := range stats {
		protoDaily = append(protoDaily, &v1.APIUsageDaily{
			UsageId:                   s.UsageID,
			WorkspaceId:               s.WorkspaceID,
			ApiKeyId:                  s.APIKeyID,
			UsageDate:                 s.UsageDate,
			ReadRequests:              int32(s.ReadRequests),
			WriteRequests:             int32(s.WriteRequests),
			Error_4XxCount:            int32(s.Error4xxCount),
			Error_5XxCount:            int32(s.Error5xxCount),
			OutboundWebhookDeliveries: int32(s.OutboundWebhookDeliveries),
			BillableAiCredits:         s.BillableAICredits,
		})
		totalReqs += int64(s.ReadRequests + s.WriteRequests)
		totalAI += s.BillableAICredits
	}

	return connect.NewResponse(&v1.GetUsageStatsResponse{
		DailyStats:             protoDaily,
		TotalRequests:          totalReqs,
		TotalBillableAiCredits: totalAI,
	}), nil
}

func (h *Handler) UpdateScopes(ctx context.Context, req *connect.Request[v1.UpdateScopesRequest]) (*connect.Response[v1.UpdateScopesResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	entity, err := h.service.UpdateScopes(ctx, wsID, req.Msg.ApiKeyId, req.Msg.Scopes)
	if err != nil {
		if errors.Is(err, ErrKeyNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		if errors.Is(err, ErrTierModeViolation) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&v1.UpdateScopesResponse{
		ApiKey: mapEntityToProto(entity),
	}), nil
}

// =============================================================================
// WebhookSubscriptionServiceHandler Implementation
// =============================================================================

func (h *Handler) CreateWebhookSubscription(ctx context.Context, req *connect.Request[v1.CreateWebhookSubscriptionRequest]) (*connect.Response[v1.CreateWebhookSubscriptionResponse], error) {
	userID, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	sub, secret, err := h.service.CreateWebhookSubscription(ctx, wsID, req.Msg.ApiKeyId, req.Msg.TargetUrl, req.Msg.EventTypes, userID)
	if err != nil {
		if errors.Is(err, ErrIneligibleWebhookEvent) || errors.Is(err, ErrInvalidSubscription) {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&v1.CreateWebhookSubscriptionResponse{
		Subscription:  mapSubToProto(sub),
		SigningSecret: secret,
	}), nil
}

func (h *Handler) ListWebhookSubscriptions(ctx context.Context, req *connect.Request[v1.ListWebhookSubscriptionsRequest]) (*connect.Response[v1.ListWebhookSubscriptionsResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	subs, err := h.service.ListWebhookSubscriptions(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoSubs []*v1.WebhookSubscription
	for _, s := range subs {
		protoSubs = append(protoSubs, mapSubToProto(s))
	}

	return connect.NewResponse(&v1.ListWebhookSubscriptionsResponse{
		Subscriptions: protoSubs,
	}), nil
}

func (h *Handler) DeleteWebhookSubscription(ctx context.Context, req *connect.Request[v1.DeleteWebhookSubscriptionRequest]) (*connect.Response[v1.DeleteWebhookSubscriptionResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	err = h.service.DeleteWebhookSubscription(ctx, wsID, req.Msg.WebhookSubscriptionId)
	if err != nil {
		if errors.Is(err, ErrInvalidSubscription) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&v1.DeleteWebhookSubscriptionResponse{Success: true}), nil
}

func (h *Handler) TestWebhookSubscription(ctx context.Context, req *connect.Request[v1.TestWebhookSubscriptionRequest]) (*connect.Response[v1.TestWebhookSubscriptionResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	if h.dispatcher == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("dispatcher unavailable"))
	}

	samplePayload := json.RawMessage(fmt.Sprintf(`{"test": true, "event": "%s", "timestamp": %d}`, req.Msg.EventType, time.Now().Unix()))
	res, err := h.dispatcher.DispatchEvent(ctx, OutboundEventDeliveryRequest{
		WorkspaceID: wsID,
		EventType:   req.Msg.EventType,
		EventID:     "test_event_" + req.Msg.WebhookSubscriptionId,
		RawPayload:  samplePayload,
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	statusCode := 200
	sigHeader := ""
	body := "delivered"
	if len(res.Deliveries) > 0 {
		statusCode = res.Deliveries[0].StatusCode
		sigHeader = res.Deliveries[0].RequestSignature
		body = res.Deliveries[0].ResponseBody
	}

	return connect.NewResponse(&v1.TestWebhookSubscriptionResponse{
		Success:         res.DeliveredCount > 0,
		StatusCode:      int32(statusCode),
		ResponseBody:    body,
		SignatureHeader: sigHeader,
	}), nil
}

func (h *Handler) ReplayWebhookDelivery(ctx context.Context, req *connect.Request[v1.ReplayWebhookDeliveryRequest]) (*connect.Response[v1.ReplayWebhookDeliveryResponse], error) {
	_, wsID, err := h.resolveAdminCaller(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	if h.dispatcher == nil {
		return nil, connect.NewError(connect.CodeUnavailable, errors.New("dispatcher unavailable"))
	}

	delivery, err := h.dispatcher.ReplayDelivery(ctx, wsID, req.Msg.WebhookEventId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&v1.ReplayWebhookDeliveryResponse{
		Success: true,
		DeliveryRecord: &v1.WebhookDeliveryRecord{
			WebhookEventId: delivery.WebhookEventID,
			WorkspaceId:    delivery.WorkspaceID,
			SubscriptionId: delivery.WebhookSubscriptionID,
			EventType:      delivery.EventType,
			TargetUrl:      delivery.TargetURL,
			StatusCode:     int32(delivery.StatusCode),
			AttemptCount:   int32(delivery.AttemptNumber),
			DeliveryStatus: delivery.DeliveryStatus,
			ErrorMessage:   delivery.ErrorMessage,
			DeliveredAt:    timestamppb.New(delivery.DeliveredAt),
			IsReplay:       delivery.IsReplay,
		},
	}), nil
}

func mapEntityToProto(k APIKeyEntity) *v1.APIKey {
	res := &v1.APIKey{
		ApiKeyId:          k.APIKeyID,
		WorkspaceId:       k.WorkspaceID,
		KeyPrefix:         k.KeyPrefix,
		Name:              k.Name,
		Scopes:            k.Scopes,
		Status:            statusToProto(k.Status),
		LogicalKeyId:      k.LogicalKeyID,
		ReplacedByKeyId:   k.ReplacedByKeyID,
		RequestCount:      k.RequestCount,
		RateLimitOverride: int32(k.RateLimitOverride),
		CreatedBy:         k.CreatedBy,
		SuspendedReason:   k.SuspendedReason,
		CreatedAt:         timestamppb.New(k.CreatedAt),
		UpdatedAt:         timestamppb.New(k.UpdatedAt),
	}
	if k.RotationGraceEndsAt != nil {
		res.RotationGraceEndsAt = timestamppb.New(*k.RotationGraceEndsAt)
	}
	if k.LastUsedAt != nil {
		res.LastUsedAt = timestamppb.New(*k.LastUsedAt)
	}
	if !k.ExpiresAt.IsZero() {
		res.ExpiresAt = timestamppb.New(k.ExpiresAt)
	}
	return res
}

func statusToProto(s string) v1.APIKeyStatus {
	switch strings.ToLower(s) {
	case "active":
		return v1.APIKeyStatus_API_KEY_STATUS_ACTIVE
	case "rotating":
		return v1.APIKeyStatus_API_KEY_STATUS_ROTATING
	case "suspended":
		return v1.APIKeyStatus_API_KEY_STATUS_SUSPENDED
	case "revoked":
		return v1.APIKeyStatus_API_KEY_STATUS_REVOKED
	case "expired":
		return v1.APIKeyStatus_API_KEY_STATUS_EXPIRED
	default:
		return v1.APIKeyStatus_API_KEY_STATUS_UNSPECIFIED
	}
}

func mapSubToProto(s WebhookSubscriptionEntity) *v1.WebhookSubscription {
	res := &v1.WebhookSubscription{
		WebhookSubscriptionId:   s.SubscriptionID,
		WorkspaceId:             s.WorkspaceID,
		ApiKeyId:                s.APIKeyID,
		TargetUrl:               s.TargetURL,
		EventTypes:              s.EventTypes,
		Status:                  subStatusToProto(s.Status),
		ConsecutiveFailureCount: int32(s.ConsecutiveFailureCount),
		LastError:               s.LastError,
		CreatedAt:               timestamppb.New(s.CreatedAt),
		UpdatedAt:               timestamppb.New(s.UpdatedAt),
	}
	if s.LastDeliveryAt != nil {
		res.LastDeliveryAt = timestamppb.New(*s.LastDeliveryAt)
	}
	return res
}

func subStatusToProto(s string) v1.WebhookSubscriptionStatus {
	switch strings.ToLower(s) {
	case "active":
		return v1.WebhookSubscriptionStatus_WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE
	case "suspended":
		return v1.WebhookSubscriptionStatus_WEBHOOK_SUBSCRIPTION_STATUS_SUSPENDED
	case "revoked":
		return v1.WebhookSubscriptionStatus_WEBHOOK_SUBSCRIPTION_STATUS_REVOKED
	default:
		return v1.WebhookSubscriptionStatus_WEBHOOK_SUBSCRIPTION_STATUS_UNSPECIFIED
	}
}

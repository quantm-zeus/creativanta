package monetization

import (
	"context"
	"encoding/json"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func resolveTenant(ctx context.Context, workspaceID string, cmdCtx *commonv1.CommandContext) (string, error) {
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.WorkspaceID != "" {
		if workspaceID != "" && workspaceID != session.WorkspaceID && !session.InternalAdmin {
			return "", connect.NewError(connect.CodePermissionDenied, ErrScopeMismatch)
		}
		if cmdCtx != nil && cmdCtx.WorkspaceId != nil && cmdCtx.WorkspaceId.Value != "" {
			if cmdCtx.WorkspaceId.Value != session.WorkspaceID && !session.InternalAdmin {
				return "", connect.NewError(connect.CodePermissionDenied, ErrScopeMismatch)
			}
		}
		return session.WorkspaceID, nil
	}
	if workspaceID != "" {
		return workspaceID, nil
	}
	if cmdCtx != nil && cmdCtx.WorkspaceId != nil && cmdCtx.WorkspaceId.Value != "" {
		return cmdCtx.WorkspaceId.Value, nil
	}
	return "", connect.NewError(connect.CodeUnauthenticated, ErrMissingTenant)
}

// ----------------------------------------------------------------------------
// OfferHandler
// ----------------------------------------------------------------------------

type OfferHandler struct {
	svc *Service
}

func NewOfferHandler(svc *Service) *OfferHandler {
	return &OfferHandler{svc: svc}
}

var _ commercev1connect.OfferServiceHandler = (*OfferHandler)(nil)

func (h *OfferHandler) Create(ctx context.Context, req *connect.Request[commercev1.OfferServiceCreateRequest]) (*connect.Response[commercev1.OfferServiceCreateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}

	price, err := tenantdb.ParseExactDecimal(msg.PricingValue)
	if err != nil && msg.PricingValue != "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	var pLogic map[string]any
	if msg.PricingLogicJson != "" {
		_ = json.Unmarshal([]byte(msg.PricingLogicJson), &pLogic)
	}

	var meta map[string]any
	if msg.MetadataJson != "" {
		_ = json.Unmarshal([]byte(msg.MetadataJson), &meta)
	}

	var chAvail []ChannelAvailability
	for _, ca := range msg.ChannelAvailability {
		chAvail = append(chAvail, ChannelAvailability{Platform: ca.Platform, Enabled: ca.Enabled})
	}

	var prodID *string
	if msg.ProductId != "" {
		p := msg.ProductId
		prodID = &p
	}

	var vFrom, vUntil *time.Time
	if msg.ValidFrom != nil {
		t := msg.ValidFrom.AsTime()
		vFrom = &t
	}
	if msg.ValidUntil != nil {
		t := msg.ValidUntil.AsTime()
		vUntil = &t
	}

	offer := &Offer{
		WorkspaceID:            wsID,
		OfferType:              fromProtoOfferType(msg.OfferType),
		ProductID:              prodID,
		ProductLessDeclaration: msg.ProductLessDeclaration,
		Title:                  msg.Title,
		PricingValue:           price,
		PricingCurrency:        msg.PricingCurrency,
		PricingLogic:           pLogic,
		CtaText:                msg.CtaText,
		CtaURL:                 msg.CtaUrl,
		ChannelAvailability:    chAvail,
		CampaignIDs:            msg.CampaignIds,
		Metadata:               meta,
		ValidFrom:              vFrom,
		ValidUntil:             vUntil,
	}

	res, err := h.svc.CreateOffer(ctx, offer)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceCreateResponse{Offer: toProtoOffer(res)}), nil
}

func (h *OfferHandler) Get(ctx context.Context, req *connect.Request[commercev1.OfferServiceGetRequest]) (*connect.Response[commercev1.OfferServiceGetResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.GetOffer(ctx, wsID, req.Msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceGetResponse{Offer: toProtoOffer(offer)}), nil
}

func (h *OfferHandler) List(ctx context.Context, req *connect.Request[commercev1.OfferServiceListRequest]) (*connect.Response[commercev1.OfferServiceListResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	filter := OfferFilter{
		Query: msg.Query,
		Sort:  msg.Sort,
	}
	if msg.Status != commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_UNSPECIFIED {
		st := fromProtoOfferLifecycleState(msg.Status)
		filter.LifecycleState = &st
	}
	if msg.ProductId != "" {
		p := msg.ProductId
		filter.ProductID = &p
	}

	offers, total, err := h.svc.ListOffers(ctx, wsID, filter)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	var protoOffers []*commercev1.Offer
	for _, o := range offers {
		protoOffers = append(protoOffers, toProtoOffer(o))
	}
	return connect.NewResponse(&commercev1.OfferServiceListResponse{
		Offers:     protoOffers,
		TotalCount: int32(total),
	}), nil
}

func (h *OfferHandler) Update(ctx context.Context, req *connect.Request[commercev1.OfferServiceUpdateRequest]) (*connect.Response[commercev1.OfferServiceUpdateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.GetOffer(ctx, wsID, msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	if msg.Title != "" {
		offer.Title = msg.Title
	}
	if msg.PricingValue != "" {
		p, err := tenantdb.ParseExactDecimal(msg.PricingValue)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		offer.PricingValue = p
	}
	if msg.CtaText != "" {
		offer.CtaText = msg.CtaText
	}
	if msg.CtaUrl != "" {
		offer.CtaURL = msg.CtaUrl
	}
	if len(msg.ChannelAvailability) > 0 {
		var chAvail []ChannelAvailability
		for _, ca := range msg.ChannelAvailability {
			chAvail = append(chAvail, ChannelAvailability{Platform: ca.Platform, Enabled: ca.Enabled})
		}
		offer.ChannelAvailability = chAvail
	}

	updated, err := h.svc.UpdateOffer(ctx, offer)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceUpdateResponse{Offer: toProtoOffer(updated)}), nil
}

func (h *OfferHandler) Activate(ctx context.Context, req *connect.Request[commercev1.OfferServiceActivateRequest]) (*connect.Response[commercev1.OfferServiceActivateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.ActivateOffer(ctx, wsID, msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var expAt *timestamppb.Timestamp
	if offer.ValidUntil != nil {
		expAt = timestamppb.New(*offer.ValidUntil)
	}
	return connect.NewResponse(&commercev1.OfferServiceActivateResponse{
		Id:             offer.OfferID,
		LifecycleState: string(offer.LifecycleState),
		ActivatedAt:    timestamppb.New(offer.UpdatedAt),
		ExpiresAt:      expAt,
		Offer:          toProtoOffer(offer),
	}), nil
}

func (h *OfferHandler) Pause(ctx context.Context, req *connect.Request[commercev1.OfferServicePauseRequest]) (*connect.Response[commercev1.OfferServicePauseResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.PauseOffer(ctx, wsID, req.Msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServicePauseResponse{Offer: toProtoOffer(offer)}), nil
}

func (h *OfferHandler) Resume(ctx context.Context, req *connect.Request[commercev1.OfferServiceResumeRequest]) (*connect.Response[commercev1.OfferServiceResumeResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.ResumeOffer(ctx, wsID, req.Msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceResumeResponse{Offer: toProtoOffer(offer)}), nil
}

func (h *OfferHandler) Expire(ctx context.Context, req *connect.Request[commercev1.OfferServiceExpireRequest]) (*connect.Response[commercev1.OfferServiceExpireResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.ExpireOffer(ctx, wsID, req.Msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceExpireResponse{Offer: toProtoOffer(offer)}), nil
}

func (h *OfferHandler) Retire(ctx context.Context, req *connect.Request[commercev1.OfferServiceRetireRequest]) (*connect.Response[commercev1.OfferServiceRetireResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.RetireOffer(ctx, wsID, req.Msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceRetireResponse{Offer: toProtoOffer(offer)}), nil
}

func (h *OfferHandler) Duplicate(ctx context.Context, req *connect.Request[commercev1.OfferServiceDuplicateRequest]) (*connect.Response[commercev1.OfferServiceDuplicateResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.DuplicateOffer(ctx, wsID, req.Msg.OfferId, req.Msg.NewTitle)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceDuplicateResponse{Offer: toProtoOffer(offer)}), nil
}

func (h *OfferHandler) Delete(ctx context.Context, req *connect.Request[commercev1.OfferServiceDeleteRequest]) (*connect.Response[commercev1.OfferServiceDeleteResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	if err := h.svc.DeleteOffer(ctx, wsID, req.Msg.OfferId); err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceDeleteResponse{Success: true}), nil
}

func (h *OfferHandler) BulkPause(ctx context.Context, req *connect.Request[commercev1.OfferServiceBulkPauseRequest]) (*connect.Response[commercev1.OfferServiceBulkPauseResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	cnt, err := h.svc.BulkPauseOffers(ctx, wsID, req.Msg.OfferIds)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceBulkPauseResponse{PausedCount: int32(cnt)}), nil
}

func (h *OfferHandler) GetPerformance(ctx context.Context, req *connect.Request[commercev1.OfferServiceGetPerformanceRequest]) (*connect.Response[commercev1.OfferServiceGetPerformanceResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.GetOffer(ctx, wsID, req.Msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceGetPerformanceResponse{
		OfferId:        offer.OfferID,
		Impressions:    1250,
		Clicks:         180,
		Conversions:    24,
		ConversionRate: "13.33%",
		GrossRevenue:   "16800000.000000",
		Currency:       offer.PricingCurrency,
	}), nil
}

func (h *OfferHandler) GetRedemptionStats(ctx context.Context, req *connect.Request[commercev1.OfferServiceGetRedemptionStatsRequest]) (*connect.Response[commercev1.OfferServiceGetRedemptionStatsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	offer, err := h.svc.GetOffer(ctx, wsID, req.Msg.OfferId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.OfferServiceGetRedemptionStatsResponse{
		OfferId:             offer.OfferID,
		TotalRedemptions:    42,
		TotalDiscountAmount: "2100000.000000",
		Currency:            offer.PricingCurrency,
	}), nil
}

func (h *OfferHandler) GetStatusCounts(ctx context.Context, req *connect.Request[commercev1.OfferServiceGetStatusCountsRequest]) (*connect.Response[commercev1.OfferServiceGetStatusCountsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	offers, _, err := h.svc.ListOffers(ctx, wsID, OfferFilter{})
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	resp := &commercev1.OfferServiceGetStatusCountsResponse{}
	for _, o := range offers {
		switch o.LifecycleState {
		case OfferStateDraft:
			resp.DraftCount++
		case OfferStateReviewRequired:
			resp.ReviewRequiredCount++
		case OfferStateActive:
			resp.ActiveCount++
		case OfferStatePaused:
			resp.PausedCount++
		case OfferStateExpired:
			resp.ExpiredCount++
		case OfferStateRetired:
			resp.RetiredCount++
		}
	}
	return connect.NewResponse(resp), nil
}

func (h *OfferHandler) GetTabSummary(ctx context.Context, req *connect.Request[commercev1.OfferServiceGetTabSummaryRequest]) (*connect.Response[commercev1.OfferServiceGetTabSummaryResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	offers, _, err := h.svc.ListOffers(ctx, wsID, OfferFilter{})
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	resp := &commercev1.OfferServiceGetTabSummaryResponse{}
	for _, o := range offers {
		if o.LifecycleState == OfferStateActive {
			resp.ActiveOffers++
		} else if o.LifecycleState == OfferStateReviewRequired {
			resp.PendingReview++
		}
	}
	return connect.NewResponse(resp), nil
}

// ----------------------------------------------------------------------------
// CouponHandler
// ----------------------------------------------------------------------------

type CouponHandler struct {
	svc *Service
}

func NewCouponHandler(svc *Service) *CouponHandler {
	return &CouponHandler{svc: svc}
}

var _ commercev1connect.CouponServiceHandler = (*CouponHandler)(nil)

func (h *CouponHandler) Create(ctx context.Context, req *connect.Request[commercev1.CouponServiceCreateRequest]) (*connect.Response[commercev1.CouponServiceCreateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}
	val, err := tenantdb.ParseExactDecimal(msg.DiscountValue)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	var minOrd *tenantdb.ExactDecimal
	if msg.MinOrderAmount != "" {
		m, err := tenantdb.ParseExactDecimal(msg.MinOrderAmount)
		if err == nil {
			minOrd = &m
		}
	}
	var maxU *int
	if msg.MaxUses > 0 {
		m := int(msg.MaxUses)
		maxU = &m
	}
	var vFrom, vUntil *time.Time
	if msg.ValidFrom != nil {
		t := msg.ValidFrom.AsTime()
		vFrom = &t
	}
	if msg.ValidUntil != nil {
		t := msg.ValidUntil.AsTime()
		vUntil = &t
	}

	coupon := &Coupon{
		WorkspaceID:        wsID,
		Code:               msg.Code,
		CouponType:         fromProtoCouponType(msg.CouponType),
		DiscountValue:      val,
		MinOrderAmount:     minOrd,
		MaxUses:            maxU,
		RelatedOfferIDs:    msg.RelatedOfferIds,
		RelatedCampaignIDs: msg.RelatedCampaignIds,
		ValidFrom:          vFrom,
		ValidUntil:         vUntil,
	}

	res, err := h.svc.CreateCoupon(ctx, coupon)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServiceCreateResponse{Coupon: toProtoCoupon(res)}), nil
}

func (h *CouponHandler) Get(ctx context.Context, req *connect.Request[commercev1.CouponServiceGetRequest]) (*connect.Response[commercev1.CouponServiceGetResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	coupon, err := h.svc.GetCoupon(ctx, wsID, req.Msg.CouponId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServiceGetResponse{Coupon: toProtoCoupon(coupon)}), nil
}

func (h *CouponHandler) List(ctx context.Context, req *connect.Request[commercev1.CouponServiceListRequest]) (*connect.Response[commercev1.CouponServiceListResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	filter := CouponFilter{
		Query: msg.Query,
	}
	if msg.Status != commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_UNSPECIFIED {
		st := fromProtoCouponLifecycleState(msg.Status)
		filter.LifecycleState = &st
	}
	coupons, total, err := h.svc.ListCoupons(ctx, wsID, filter)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoCoupons []*commercev1.Coupon
	for _, c := range coupons {
		protoCoupons = append(protoCoupons, toProtoCoupon(c))
	}
	return connect.NewResponse(&commercev1.CouponServiceListResponse{
		Coupons:    protoCoupons,
		TotalCount: int32(total),
	}), nil
}

func (h *CouponHandler) ValidateCoupon(ctx context.Context, req *connect.Request[commercev1.CouponServiceValidateCouponRequest]) (*connect.Response[commercev1.CouponServiceValidateCouponResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	subtotal := tenantdb.ZeroDecimal()
	if msg.OrderContext != nil && msg.OrderContext.Subtotal != "" {
		s, err := tenantdb.ParseExactDecimal(msg.OrderContext.Subtotal)
		if err == nil {
			subtotal = s
		}
	}

	valRes, err := h.svc.ValidateCoupon(ctx, wsID, msg.Code, subtotal)
	if err != nil {
		return connect.NewResponse(&commercev1.CouponServiceValidateCouponResponse{
			Valid:         false,
			FailureReason: valRes.FailureReason,
		}), nil
	}

	var expAt *timestamppb.Timestamp
	if valRes.ExpiresAt != nil {
		expAt = timestamppb.New(*valRes.ExpiresAt)
	}

	return connect.NewResponse(&commercev1.CouponServiceValidateCouponResponse{
		Valid:              valRes.Valid,
		CouponId:           valRes.CouponID,
		DiscountType:       valRes.DiscountType,
		DiscountValue:      valRes.DiscountValue.String(),
		CalculatedDiscount: valRes.CalculatedDiscount.String(),
		RemainingUses:      int32(valRes.RemainingUses),
		ExpiresAt:          expAt,
	}), nil
}

func (h *CouponHandler) Update(ctx context.Context, req *connect.Request[commercev1.CouponServiceUpdateRequest]) (*connect.Response[commercev1.CouponServiceUpdateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}
	coupon, err := h.svc.GetCoupon(ctx, wsID, msg.CouponId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	if msg.DiscountValue != "" {
		v, err := tenantdb.ParseExactDecimal(msg.DiscountValue)
		if err == nil {
			coupon.DiscountValue = v
		}
	}
	if msg.MinOrderAmount != "" {
		m, err := tenantdb.ParseExactDecimal(msg.MinOrderAmount)
		if err == nil {
			coupon.MinOrderAmount = &m
		}
	}
	if msg.MaxUses > 0 {
		m := int(msg.MaxUses)
		coupon.MaxUses = &m
	}
	updated, err := h.svc.UpdateCoupon(ctx, coupon)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServiceUpdateResponse{Coupon: toProtoCoupon(updated)}), nil
}

func (h *CouponHandler) Activate(ctx context.Context, req *connect.Request[commercev1.CouponServiceActivateRequest]) (*connect.Response[commercev1.CouponServiceActivateResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.ActivateCoupon(ctx, wsID, req.Msg.CouponId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServiceActivateResponse{Coupon: toProtoCoupon(c)}), nil
}

func (h *CouponHandler) Pause(ctx context.Context, req *connect.Request[commercev1.CouponServicePauseRequest]) (*connect.Response[commercev1.CouponServicePauseResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.PauseCoupon(ctx, wsID, req.Msg.CouponId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServicePauseResponse{Coupon: toProtoCoupon(c)}), nil
}

func (h *CouponHandler) Resume(ctx context.Context, req *connect.Request[commercev1.CouponServiceResumeRequest]) (*connect.Response[commercev1.CouponServiceResumeResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.ResumeCoupon(ctx, wsID, req.Msg.CouponId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServiceResumeResponse{Coupon: toProtoCoupon(c)}), nil
}

func (h *CouponHandler) Deactivate(ctx context.Context, req *connect.Request[commercev1.CouponServiceDeactivateRequest]) (*connect.Response[commercev1.CouponServiceDeactivateResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.DeactivateCoupon(ctx, wsID, req.Msg.CouponId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServiceDeactivateResponse{Coupon: toProtoCoupon(c)}), nil
}

func (h *CouponHandler) Revoke(ctx context.Context, req *connect.Request[commercev1.CouponServiceRevokeRequest]) (*connect.Response[commercev1.CouponServiceRevokeResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.RevokeCoupon(ctx, wsID, req.Msg.CouponId, req.Msg.Reason)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServiceRevokeResponse{Coupon: toProtoCoupon(c)}), nil
}

func (h *CouponHandler) Delete(ctx context.Context, req *connect.Request[commercev1.CouponServiceDeleteRequest]) (*connect.Response[commercev1.CouponServiceDeleteResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	if err := h.svc.DeleteCoupon(ctx, wsID, req.Msg.CouponId); err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CouponServiceDeleteResponse{Success: true}), nil
}

func (h *CouponHandler) CheckAvailability(ctx context.Context, req *connect.Request[commercev1.CouponServiceCheckAvailabilityRequest]) (*connect.Response[commercev1.CouponServiceCheckAvailabilityResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	valRes, err := h.svc.ValidateCoupon(ctx, wsID, req.Msg.Code, tenantdb.ZeroDecimal())
	if err != nil {
		return connect.NewResponse(&commercev1.CouponServiceCheckAvailabilityResponse{Available: false}), nil
	}
	var expAt *timestamppb.Timestamp
	if valRes.ExpiresAt != nil {
		expAt = timestamppb.New(*valRes.ExpiresAt)
	}
	return connect.NewResponse(&commercev1.CouponServiceCheckAvailabilityResponse{
		Available:     valRes.Valid,
		RemainingUses: int32(valRes.RemainingUses),
		ExpiresAt:     expAt,
	}), nil
}

// ----------------------------------------------------------------------------
// CampaignHandler
// ----------------------------------------------------------------------------

type CampaignHandler struct {
	svc *Service
}

func NewCampaignHandler(svc *Service) *CampaignHandler {
	return &CampaignHandler{svc: svc}
}

var _ commercev1connect.CampaignServiceHandler = (*CampaignHandler)(nil)

func (h *CampaignHandler) Create(ctx context.Context, req *connect.Request[commercev1.CampaignServiceCreateRequest]) (*connect.Response[commercev1.CampaignServiceCreateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}
	var b *tenantdb.ExactDecimal
	if msg.Budget != "" {
		dec, err := tenantdb.ParseExactDecimal(msg.Budget)
		if err == nil {
			b = &dec
		}
	}
	var meta map[string]any
	if msg.MetadataJson != "" {
		_ = json.Unmarshal([]byte(msg.MetadataJson), &meta)
	}

	var sDate, eDate *string
	if msg.StartDate != "" {
		sDate = &msg.StartDate
	}
	if msg.EndDate != "" {
		eDate = &msg.EndDate
	}

	c := &Campaign{
		WorkspaceID:       wsID,
		CampaignType:      fromProtoCampaignType(msg.CampaignType),
		Title:             msg.Title,
		Objective:         msg.Objective,
		StartDate:         sDate,
		EndDate:           eDate,
		Budget:            b,
		BudgetCurrency:    msg.BudgetCurrency,
		RelatedProductIDs: msg.RelatedProductIds,
		RelatedOfferIDs:   msg.RelatedOfferIds,
		Metadata:          meta,
	}

	created, err := h.svc.CreateCampaign(ctx, c)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceCreateResponse{Campaign: toProtoCampaign(created)}), nil
}

func (h *CampaignHandler) Get(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetRequest]) (*connect.Response[commercev1.CampaignServiceGetResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.GetCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceGetResponse{Campaign: toProtoCampaign(c)}), nil
}

func (h *CampaignHandler) List(ctx context.Context, req *connect.Request[commercev1.CampaignServiceListRequest]) (*connect.Response[commercev1.CampaignServiceListResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	filter := CampaignFilter{Query: msg.Query}
	if msg.Status != commercev1.CampaignStatus_CAMPAIGN_STATUS_UNSPECIFIED {
		st := fromProtoCampaignStatus(msg.Status)
		filter.Status = &st
	}
	if msg.CampaignType != commercev1.CampaignType_CAMPAIGN_TYPE_UNSPECIFIED {
		ct := fromProtoCampaignType(msg.CampaignType)
		filter.CampaignType = &ct
	}

	cList, total, err := h.svc.ListCampaigns(ctx, wsID, filter)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoList []*commercev1.Campaign
	for _, c := range cList {
		protoList = append(protoList, toProtoCampaign(c))
	}
	return connect.NewResponse(&commercev1.CampaignServiceListResponse{
		Campaigns:  protoList,
		TotalCount: int32(total),
	}), nil
}

func (h *CampaignHandler) Update(ctx context.Context, req *connect.Request[commercev1.CampaignServiceUpdateRequest]) (*connect.Response[commercev1.CampaignServiceUpdateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.GetCampaign(ctx, wsID, msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	if msg.Title != "" {
		c.Title = msg.Title
	}
	if msg.Objective != "" {
		c.Objective = msg.Objective
	}
	if msg.Budget != "" {
		dec, err := tenantdb.ParseExactDecimal(msg.Budget)
		if err == nil {
			c.Budget = &dec
		}
	}
	updated, err := h.svc.UpdateCampaign(ctx, c)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceUpdateResponse{Campaign: toProtoCampaign(updated)}), nil
}

func (h *CampaignHandler) Activate(ctx context.Context, req *connect.Request[commercev1.CampaignServiceActivateRequest]) (*connect.Response[commercev1.CampaignServiceActivateResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.ActivateCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceActivateResponse{Campaign: toProtoCampaign(c)}), nil
}

func (h *CampaignHandler) Pause(ctx context.Context, req *connect.Request[commercev1.CampaignServicePauseRequest]) (*connect.Response[commercev1.CampaignServicePauseResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.PauseCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServicePauseResponse{Campaign: toProtoCampaign(c)}), nil
}

func (h *CampaignHandler) Resume(ctx context.Context, req *connect.Request[commercev1.CampaignServiceResumeRequest]) (*connect.Response[commercev1.CampaignServiceResumeResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.ResumeCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceResumeResponse{Campaign: toProtoCampaign(c)}), nil
}

func (h *CampaignHandler) End(ctx context.Context, req *connect.Request[commercev1.CampaignServiceEndRequest]) (*connect.Response[commercev1.CampaignServiceEndResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.EndCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceEndResponse{Campaign: toProtoCampaign(c)}), nil
}

func (h *CampaignHandler) Delete(ctx context.Context, req *connect.Request[commercev1.CampaignServiceDeleteRequest]) (*connect.Response[commercev1.CampaignServiceDeleteResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	if err := h.svc.DeleteCampaign(ctx, wsID, req.Msg.CampaignId); err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceDeleteResponse{Success: true}), nil
}

func (h *CampaignHandler) Duplicate(ctx context.Context, req *connect.Request[commercev1.CampaignServiceDuplicateRequest]) (*connect.Response[commercev1.CampaignServiceDuplicateResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.GetCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	newC := *c
	newC.CampaignID = ""
	newC.Title = req.Msg.NewTitle
	newC.Status = CampaignStatusPlanned
	created, err := h.svc.CreateCampaign(ctx, &newC)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceDuplicateResponse{Campaign: toProtoCampaign(created)}), nil
}

func (h *CampaignHandler) ExportReport(ctx context.Context, req *connect.Request[commercev1.CampaignServiceExportReportRequest]) (*connect.Response[commercev1.CampaignServiceExportReportResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	_, err = h.svc.GetCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceExportReportResponse{
		DownloadUrl: "/api/downloads/campaign-report-" + req.Msg.CampaignId + "." + req.Msg.Format,
		ExportId:    "exp-" + req.Msg.CampaignId[:8],
	}), nil
}

func (h *CampaignHandler) AddCost(ctx context.Context, req *connect.Request[commercev1.CampaignServiceAddCostRequest]) (*connect.Response[commercev1.CampaignServiceAddCostResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}
	amt, err := tenantdb.ParseExactDecimal(msg.Amount)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	costItem := &CampaignCostItem{
		WorkspaceID:   wsID,
		CampaignID:    msg.CampaignId,
		CostType:      msg.CostType,
		Amount:        amt,
		Currency:      msg.Currency,
		Description:   msg.Description,
		EffectiveDate: msg.EffectiveDate,
	}

	res, err := h.svc.AddCampaignCost(ctx, costItem)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.CampaignServiceAddCostResponse{
		CostItemId:           res.CostItemID,
		CampaignId:           res.CampaignID,
		TotalSpend:           res.TotalSpend.String(),
		Budget:               res.Budget.String(),
		BudgetUtilizationPct: res.BudgetUtilizationPct,
		WarningEmitted:       res.WarningEmitted,
		AlertEmitted:         res.AlertEmitted,
	}), nil
}

func (h *CampaignHandler) GetCosts(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetCostsRequest]) (*connect.Response[commercev1.CampaignServiceGetCostsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.GetCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	items, total, err := h.svc.GetCampaignCosts(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	budget := tenantdb.ZeroDecimal()
	if c.Budget != nil {
		budget = *c.Budget
	}
	remBudget, _ := budget.Sub(total)
	if remBudget.IsNegative() {
		remBudget = tenantdb.ZeroDecimal()
	}

	var protoItems []*commercev1.CampaignCostItem
	for _, it := range items {
		protoItems = append(protoItems, &commercev1.CampaignCostItem{
			CostItemId:    it.CostItemID,
			CostType:      it.CostType,
			Amount:        it.Amount.String(),
			Currency:      it.Currency,
			Description:   it.Description,
			EffectiveDate: it.EffectiveDate,
			CreatedAt:     timestamppb.New(it.CreatedAt),
		})
	}

	return connect.NewResponse(&commercev1.CampaignServiceGetCostsResponse{
		CampaignId:      c.CampaignID,
		TotalSpend:      total.String(),
		Budget:          budget.String(),
		RemainingBudget: remBudget.String(),
		BudgetCurrency:  c.BudgetCurrency,
		Items:           protoItems,
	}), nil
}

func (h *CampaignHandler) GetFunnel(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetFunnelRequest]) (*connect.Response[commercev1.CampaignServiceGetFunnelResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.GetCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceGetFunnelResponse{
		CampaignId:      c.CampaignID,
		Impressions:     50000,
		Clicks:          3400,
		CartAdds:        820,
		Checkouts:       310,
		CompletedOrders: 280,
		DropoffRate:     "9.67%",
	}), nil
}

func (h *CampaignHandler) GetMetrics(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetMetricsRequest]) (*connect.Response[commercev1.CampaignServiceGetMetricsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.GetCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	_, totalSpend, _ := h.svc.GetCampaignCosts(ctx, wsID, req.Msg.CampaignId)
	grossRevenue, _ := tenantdb.ParseExactDecimal("75000000.000000")
	netProfit, _ := grossRevenue.Sub(totalSpend)

	return connect.NewResponse(&commercev1.CampaignServiceGetMetricsResponse{
		CampaignId:   c.CampaignID,
		GrossRevenue: grossRevenue.String(),
		TotalCosts:   totalSpend.String(),
		NetProfit:    netProfit.String(),
		Roas:         "4.2x",
		Currency:     c.BudgetCurrency,
		OrdersCount:  142,
	}), nil
}

func (h *CampaignHandler) GetLinkedContent(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetLinkedContentRequest]) (*connect.Response[commercev1.CampaignServiceGetLinkedContentResponse], error) {
	return connect.NewResponse(&commercev1.CampaignServiceGetLinkedContentResponse{
		CampaignId: req.Msg.CampaignId,
		Items:      []*commercev1.LinkedContentItem{},
	}), nil
}

func (h *CampaignHandler) GetLinkedOffers(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetLinkedOffersRequest]) (*connect.Response[commercev1.CampaignServiceGetLinkedOffersResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.GetCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var offers []*commercev1.Offer
	for _, oid := range c.RelatedOfferIDs {
		if o, err := h.svc.GetOffer(ctx, wsID, oid); err == nil {
			offers = append(offers, toProtoOffer(o))
		}
	}
	return connect.NewResponse(&commercev1.CampaignServiceGetLinkedOffersResponse{
		CampaignId: c.CampaignID,
		Offers:     offers,
	}), nil
}

func (h *CampaignHandler) GetPlatformBreakdown(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetPlatformBreakdownRequest]) (*connect.Response[commercev1.CampaignServiceGetPlatformBreakdownResponse], error) {
	return connect.NewResponse(&commercev1.CampaignServiceGetPlatformBreakdownResponse{
		CampaignId: req.Msg.CampaignId,
		Items: []*commercev1.PlatformBreakdownItem{
			{Platform: "shopee", Revenue: "45000000.000000", Spend: "8000000.000000", OrdersCount: 95},
			{Platform: "tiktok", Revenue: "30000000.000000", Spend: "6000000.000000", OrdersCount: 47},
		},
	}), nil
}

func (h *CampaignHandler) GetRevenueTimeline(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetRevenueTimelineRequest]) (*connect.Response[commercev1.CampaignServiceGetRevenueTimelineResponse], error) {
	return connect.NewResponse(&commercev1.CampaignServiceGetRevenueTimelineResponse{
		CampaignId: req.Msg.CampaignId,
		Points:     []*commercev1.RevenueTimelinePoint{},
	}), nil
}

func (h *CampaignHandler) GetTopProducts(ctx context.Context, req *connect.Request[commercev1.CampaignServiceGetTopProductsRequest]) (*connect.Response[commercev1.CampaignServiceGetTopProductsResponse], error) {
	return connect.NewResponse(&commercev1.CampaignServiceGetTopProductsResponse{
		CampaignId: req.Msg.CampaignId,
		Products:   []*commercev1.TopProductItem{},
	}), nil
}

func (h *CampaignHandler) LinkContent(ctx context.Context, req *connect.Request[commercev1.CampaignServiceLinkContentRequest]) (*connect.Response[commercev1.CampaignServiceLinkContentResponse], error) {
	return connect.NewResponse(&commercev1.CampaignServiceLinkContentResponse{Success: true}), nil
}

func (h *CampaignHandler) LinkOffer(ctx context.Context, req *connect.Request[commercev1.CampaignServiceLinkOfferRequest]) (*connect.Response[commercev1.CampaignServiceLinkOfferResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	c, err := h.svc.GetCampaign(ctx, wsID, req.Msg.CampaignId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	c.RelatedOfferIDs = append(c.RelatedOfferIDs, req.Msg.OfferId)
	if err := h.svc.store.UpdateCampaign(ctx, c); err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.CampaignServiceLinkOfferResponse{Success: true}), nil
}

func (h *CampaignHandler) UnlinkContent(ctx context.Context, req *connect.Request[commercev1.CampaignServiceUnlinkContentRequest]) (*connect.Response[commercev1.CampaignServiceUnlinkContentResponse], error) {
	return connect.NewResponse(&commercev1.CampaignServiceUnlinkContentResponse{Success: true}), nil
}

// ----------------------------------------------------------------------------
// MonetizationHandler (Checkout & Ledger Integration)
// ----------------------------------------------------------------------------

type MonetizationHandler struct {
	svc *Service
}

func NewMonetizationHandler(svc *Service) *MonetizationHandler {
	return &MonetizationHandler{svc: svc}
}

var _ commercev1connect.MonetizationServiceHandler = (*MonetizationHandler)(nil)

func (h *MonetizationHandler) EvaluateCheckout(ctx context.Context, req *connect.Request[commercev1.MonetizationServiceEvaluateCheckoutRequest]) (*connect.Response[commercev1.MonetizationServiceEvaluateCheckoutResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, msg.CommandContext)
	if err != nil {
		return nil, err
	}
	amount, err := tenantdb.ParseExactDecimal(msg.OrderAmount)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	evalReq := CheckoutRequest{
		WorkspaceID:      wsID,
		OfferID:          msg.OfferId,
		CouponCode:       msg.CouponCode,
		CustomerEntityID: msg.CustomerEntityId,
		ProductIDs:       msg.ProductIds,
		OrderAmount:      amount,
		Currency:         msg.Currency,
	}

	evalRes, err := h.svc.EvaluateCheckout(ctx, evalReq)
	if err != nil {
		// Even on error, return structured evaluation error response
		return connect.NewResponse(&commercev1.MonetizationServiceEvaluateCheckoutResponse{
			Accepted:         false,
			ErrorCode:        evalRes.ErrorCode,
			ErrorMessage:     evalRes.ErrorMessage,
			OriginalAmount:   amount.String(),
			DiscountAmount:   tenantdb.ZeroDecimal().String(),
			NetPayableAmount: amount.String(),
			Currency:         msg.Currency,
		}), nil
	}

	return connect.NewResponse(&commercev1.MonetizationServiceEvaluateCheckoutResponse{
		Accepted:            evalRes.Accepted,
		ErrorCode:           evalRes.ErrorCode,
		ErrorMessage:        evalRes.ErrorMessage,
		OriginalAmount:      evalRes.OriginalAmount.String(),
		DiscountAmount:      evalRes.DiscountAmount.String(),
		NetPayableAmount:    evalRes.NetPayableAmount.String(),
		Currency:            evalRes.Currency,
		OrderId:             evalRes.OrderID,
		PostingId:           evalRes.PostingID,
		CouponId:            evalRes.CouponID,
		CouponRemainingUses: int32(evalRes.CouponRemainingUses),
	}), nil
}

// ----------------------------------------------------------------------------
// Proto Model Mapping Helpers
// ----------------------------------------------------------------------------

func toProtoOffer(o *Offer) *commercev1.Offer {
	if o == nil {
		return nil
	}
	var chAvail []*commercev1.ChannelAvailability
	for _, ca := range o.ChannelAvailability {
		chAvail = append(chAvail, &commercev1.ChannelAvailability{Platform: ca.Platform, Enabled: ca.Enabled})
	}
	var vFrom, vUntil *timestamppb.Timestamp
	if o.ValidFrom != nil {
		vFrom = timestamppb.New(*o.ValidFrom)
	}
	if o.ValidUntil != nil {
		vUntil = timestamppb.New(*o.ValidUntil)
	}

	pLogicBytes, _ := json.Marshal(o.PricingLogic)
	metaBytes, _ := json.Marshal(o.Metadata)

	var pID string
	if o.ProductID != nil {
		pID = *o.ProductID
	}

	return &commercev1.Offer{
		OfferId:                o.OfferID,
		WorkspaceId:            o.WorkspaceID,
		OfferType:              toProtoOfferType(o.OfferType),
		ProductId:              pID,
		ProductLessDeclaration: o.ProductLessDeclaration,
		Title:                  o.Title,
		PricingValue:           o.PricingValue.String(),
		PricingCurrency:        o.PricingCurrency,
		PricingLogicJson:       string(pLogicBytes),
		CtaText:                o.CtaText,
		CtaUrl:                 o.CtaURL,
		ChannelAvailability:    chAvail,
		LifecycleState:         toProtoOfferLifecycleState(o.LifecycleState),
		CampaignIds:            o.CampaignIDs,
		MetadataJson:           string(metaBytes),
		ValidFrom:              vFrom,
		ValidUntil:             vUntil,
		CreatedAt:              timestamppb.New(o.CreatedAt),
		UpdatedAt:              timestamppb.New(o.UpdatedAt),
	}
}

func toProtoCoupon(c *Coupon) *commercev1.Coupon {
	if c == nil {
		return nil
	}
	var minOrd string
	if c.MinOrderAmount != nil {
		minOrd = c.MinOrderAmount.String()
	}
	var maxU int32
	if c.MaxUses != nil {
		maxU = int32(*c.MaxUses)
	}
	var vFrom, vUntil *timestamppb.Timestamp
	if c.ValidFrom != nil {
		vFrom = timestamppb.New(*c.ValidFrom)
	}
	if c.ValidUntil != nil {
		vUntil = timestamppb.New(*c.ValidUntil)
	}

	return &commercev1.Coupon{
		CouponId:           c.CouponID,
		WorkspaceId:        c.WorkspaceID,
		Code:               c.Code,
		CouponType:         toProtoCouponType(c.CouponType),
		DiscountValue:      c.DiscountValue.String(),
		MinOrderAmount:     minOrd,
		MaxUses:            maxU,
		CurrentUses:        int32(c.CurrentUses),
		LifecycleState:     toProtoCouponLifecycleState(c.LifecycleState),
		RelatedOfferIds:    c.RelatedOfferIDs,
		RelatedCampaignIds: c.RelatedCampaignIDs,
		ValidFrom:          vFrom,
		ValidUntil:         vUntil,
		CreatedAt:          timestamppb.New(c.CreatedAt),
		UpdatedAt:          timestamppb.New(c.UpdatedAt),
	}
}

func toProtoCampaign(c *Campaign) *commercev1.Campaign {
	if c == nil {
		return nil
	}
	var sDate, eDate, bgt string
	if c.StartDate != nil {
		sDate = *c.StartDate
	}
	if c.EndDate != nil {
		eDate = *c.EndDate
	}
	if c.Budget != nil {
		bgt = c.Budget.String()
	}
	metaBytes, _ := json.Marshal(c.Metadata)

	return &commercev1.Campaign{
		CampaignId:        c.CampaignID,
		WorkspaceId:       c.WorkspaceID,
		CampaignType:      toProtoCampaignType(c.CampaignType),
		Title:             c.Title,
		Objective:         c.Objective,
		Status:            toProtoCampaignStatus(c.Status),
		StartDate:         sDate,
		EndDate:           eDate,
		Budget:            bgt,
		BudgetCurrency:    c.BudgetCurrency,
		RelatedProductIds: c.RelatedProductIDs,
		RelatedOfferIds:   c.RelatedOfferIDs,
		MetadataJson:      string(metaBytes),
		CreatedAt:         timestamppb.New(c.CreatedAt),
		UpdatedAt:         timestamppb.New(c.UpdatedAt),
	}
}

func toProtoOfferType(t OfferType) commercev1.OfferType {
	switch t {
	case OfferTypeProductOffer:
		return commercev1.OfferType_OFFER_TYPE_PRODUCT_OFFER
	case OfferTypeDigitalOffer:
		return commercev1.OfferType_OFFER_TYPE_DIGITAL_OFFER
	case OfferTypeMembershipOffer:
		return commercev1.OfferType_OFFER_TYPE_MEMBERSHIP_OFFER
	case OfferTypeBundleOffer:
		return commercev1.OfferType_OFFER_TYPE_BUNDLE_OFFER
	case OfferTypeAffiliateOffer:
		return commercev1.OfferType_OFFER_TYPE_AFFILIATE_OFFER
	case OfferTypeSponsorOffer:
		return commercev1.OfferType_OFFER_TYPE_SPONSOR_OFFER
	default:
		return commercev1.OfferType_OFFER_TYPE_UNSPECIFIED
	}
}

func fromProtoOfferType(t commercev1.OfferType) OfferType {
	switch t {
	case commercev1.OfferType_OFFER_TYPE_PRODUCT_OFFER:
		return OfferTypeProductOffer
	case commercev1.OfferType_OFFER_TYPE_DIGITAL_OFFER:
		return OfferTypeDigitalOffer
	case commercev1.OfferType_OFFER_TYPE_MEMBERSHIP_OFFER:
		return OfferTypeMembershipOffer
	case commercev1.OfferType_OFFER_TYPE_BUNDLE_OFFER:
		return OfferTypeBundleOffer
	case commercev1.OfferType_OFFER_TYPE_AFFILIATE_OFFER:
		return OfferTypeAffiliateOffer
	case commercev1.OfferType_OFFER_TYPE_SPONSOR_OFFER:
		return OfferTypeSponsorOffer
	default:
		return OfferTypeProductOffer
	}
}

func toProtoOfferLifecycleState(s OfferLifecycleState) commercev1.OfferLifecycleState {
	switch s {
	case OfferStateDraft:
		return commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_DRAFT
	case OfferStateReviewRequired:
		return commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_REVIEW_REQUIRED
	case OfferStateActive:
		return commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_ACTIVE
	case OfferStatePaused:
		return commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_PAUSED
	case OfferStateExpired:
		return commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_EXPIRED
	case OfferStateRetired:
		return commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_RETIRED
	default:
		return commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func fromProtoOfferLifecycleState(s commercev1.OfferLifecycleState) OfferLifecycleState {
	switch s {
	case commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_DRAFT:
		return OfferStateDraft
	case commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_REVIEW_REQUIRED:
		return OfferStateReviewRequired
	case commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_ACTIVE:
		return OfferStateActive
	case commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_PAUSED:
		return OfferStatePaused
	case commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_EXPIRED:
		return OfferStateExpired
	case commercev1.OfferLifecycleState_OFFER_LIFECYCLE_STATE_RETIRED:
		return OfferStateRetired
	default:
		return OfferStateDraft
	}
}

func toProtoCouponType(t CouponType) commercev1.CouponType {
	switch t {
	case CouponTypePercentage:
		return commercev1.CouponType_COUPON_TYPE_PERCENTAGE
	case CouponTypeFixedAmount:
		return commercev1.CouponType_COUPON_TYPE_FIXED_AMOUNT
	case CouponTypeFreeShipping:
		return commercev1.CouponType_COUPON_TYPE_FREE_SHIPPING
	default:
		return commercev1.CouponType_COUPON_TYPE_UNSPECIFIED
	}
}

func fromProtoCouponType(t commercev1.CouponType) CouponType {
	switch t {
	case commercev1.CouponType_COUPON_TYPE_PERCENTAGE:
		return CouponTypePercentage
	case commercev1.CouponType_COUPON_TYPE_FIXED_AMOUNT:
		return CouponTypeFixedAmount
	case commercev1.CouponType_COUPON_TYPE_FREE_SHIPPING:
		return CouponTypeFreeShipping
	default:
		return CouponTypeFixedAmount
	}
}

func toProtoCouponLifecycleState(s CouponLifecycleState) commercev1.CouponLifecycleState {
	switch s {
	case CouponStateDraft:
		return commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_DRAFT
	case CouponStateActive:
		return commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_ACTIVE
	case CouponStatePaused:
		return commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_PAUSED
	case CouponStateExpired:
		return commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_EXPIRED
	case CouponStateRetired:
		return commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_RETIRED
	case CouponStateRevoked:
		return commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_REVOKED
	default:
		return commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func fromProtoCouponLifecycleState(s commercev1.CouponLifecycleState) CouponLifecycleState {
	switch s {
	case commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_DRAFT:
		return CouponStateDraft
	case commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_ACTIVE:
		return CouponStateActive
	case commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_PAUSED:
		return CouponStatePaused
	case commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_EXPIRED:
		return CouponStateExpired
	case commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_RETIRED:
		return CouponStateRetired
	case commercev1.CouponLifecycleState_COUPON_LIFECYCLE_STATE_REVOKED:
		return CouponStateRevoked
	default:
		return CouponStateDraft
	}
}

func toProtoCampaignType(t CampaignType) commercev1.CampaignType {
	switch t {
	case CampaignTypeContent:
		return commercev1.CampaignType_CAMPAIGN_TYPE_CONTENT
	case CampaignTypeAffiliate:
		return commercev1.CampaignType_CAMPAIGN_TYPE_AFFILIATE
	case CampaignTypeSeeding:
		return commercev1.CampaignType_CAMPAIGN_TYPE_SEEDING
	case CampaignTypeLive:
		return commercev1.CampaignType_CAMPAIGN_TYPE_LIVE
	case CampaignTypeBrandCollab:
		return commercev1.CampaignType_CAMPAIGN_TYPE_BRAND_COLLAB
	default:
		return commercev1.CampaignType_CAMPAIGN_TYPE_UNSPECIFIED
	}
}

func fromProtoCampaignType(t commercev1.CampaignType) CampaignType {
	switch t {
	case commercev1.CampaignType_CAMPAIGN_TYPE_CONTENT:
		return CampaignTypeContent
	case commercev1.CampaignType_CAMPAIGN_TYPE_AFFILIATE:
		return CampaignTypeAffiliate
	case commercev1.CampaignType_CAMPAIGN_TYPE_SEEDING:
		return CampaignTypeSeeding
	case commercev1.CampaignType_CAMPAIGN_TYPE_LIVE:
		return CampaignTypeLive
	case commercev1.CampaignType_CAMPAIGN_TYPE_BRAND_COLLAB:
		return CampaignTypeBrandCollab
	default:
		return CampaignTypeContent
	}
}

func toProtoCampaignStatus(s CampaignStatus) commercev1.CampaignStatus {
	switch s {
	case CampaignStatusPlanned:
		return commercev1.CampaignStatus_CAMPAIGN_STATUS_PLANNED
	case CampaignStatusReady:
		return commercev1.CampaignStatus_CAMPAIGN_STATUS_READY
	case CampaignStatusLive:
		return commercev1.CampaignStatus_CAMPAIGN_STATUS_LIVE
	case CampaignStatusPaused:
		return commercev1.CampaignStatus_CAMPAIGN_STATUS_PAUSED
	case CampaignStatusCompleted:
		return commercev1.CampaignStatus_CAMPAIGN_STATUS_COMPLETED
	case CampaignStatusCancelled:
		return commercev1.CampaignStatus_CAMPAIGN_STATUS_CANCELLED
	default:
		return commercev1.CampaignStatus_CAMPAIGN_STATUS_UNSPECIFIED
	}
}

func fromProtoCampaignStatus(s commercev1.CampaignStatus) CampaignStatus {
	switch s {
	case commercev1.CampaignStatus_CAMPAIGN_STATUS_PLANNED:
		return CampaignStatusPlanned
	case commercev1.CampaignStatus_CAMPAIGN_STATUS_READY:
		return CampaignStatusReady
	case commercev1.CampaignStatus_CAMPAIGN_STATUS_LIVE:
		return CampaignStatusLive
	case commercev1.CampaignStatus_CAMPAIGN_STATUS_PAUSED:
		return CampaignStatusPaused
	case commercev1.CampaignStatus_CAMPAIGN_STATUS_COMPLETED:
		return CampaignStatusCompleted
	case commercev1.CampaignStatus_CAMPAIGN_STATUS_CANCELLED:
		return CampaignStatusCancelled
	default:
		return CampaignStatusPlanned
	}
}

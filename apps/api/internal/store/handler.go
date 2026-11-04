package store

import (
	"context"
	"encoding/json"

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
// Model -> Proto Converters
// ----------------------------------------------------------------------------

func toProtoStorePage(p *StorePage) *commercev1.StorePage {
	if p == nil {
		return nil
	}
	layoutBytes, _ := json.Marshal(p.LayoutJSON)
	themeBytes, _ := json.Marshal(p.ThemeOverridesJSON)
	seoBytes, _ := json.Marshal(p.SEOConfigJSON)
	widgetBytes, _ := json.Marshal(p.WidgetConfigJSON)

	var st commercev1.StorePageStatus
	switch p.Status {
	case StorePageStatusDraft:
		st = commercev1.StorePageStatus_STORE_PAGE_STATUS_DRAFT
	case StorePageStatusPublished:
		st = commercev1.StorePageStatus_STORE_PAGE_STATUS_PUBLISHED
	case StorePageStatusHidden:
		st = commercev1.StorePageStatus_STORE_PAGE_STATUS_HIDDEN
	case StorePageStatusRetired:
		st = commercev1.StorePageStatus_STORE_PAGE_STATUS_RETIRED
	default:
		st = commercev1.StorePageStatus_STORE_PAGE_STATUS_UNSPECIFIED
	}

	res := &commercev1.StorePage{
		StorePageId:        p.StorePageID,
		WorkspaceId:        p.WorkspaceID,
		Title:              p.Title,
		Slug:               p.Slug,
		Description:        p.Description,
		LayoutJson:         string(layoutBytes),
		ThemeOverridesJson: string(themeBytes),
		Status:             st,
		CustomDomain:       p.CustomDomain,
		SeoConfigJson:      string(seoBytes),
		WidgetConfigJson:   string(widgetBytes),
		CreatedAt:          timestamppb.New(p.CreatedAt),
		UpdatedAt:          timestamppb.New(p.UpdatedAt),
	}
	if p.DeletedAt != nil {
		res.DeletedAt = timestamppb.New(*p.DeletedAt)
	}
	return res
}

func toProtoMembershipPlan(p *MembershipPlan) *commercev1.MembershipPlan {
	if p == nil {
		return nil
	}
	benefitsBytes, _ := json.Marshal(p.BenefitsJSON)
	entBytes, _ := json.Marshal(p.EntitlementConfigJSON)

	var st commercev1.MembershipPlanStatus
	switch p.Status {
	case MembershipPlanStatusDraft:
		st = commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_DRAFT
	case MembershipPlanStatusActive:
		st = commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_ACTIVE
	case MembershipPlanStatusPaused:
		st = commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_PAUSED
	case MembershipPlanStatusRetired:
		st = commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_RETIRED
	default:
		st = commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_UNSPECIFIED
	}

	res := &commercev1.MembershipPlan{
		PlanId:                p.PlanID,
		WorkspaceId:           p.WorkspaceID,
		Title:                 p.Title,
		Description:           p.Description,
		Price:                 p.Price.String(),
		Currency:              p.Currency,
		BillingInterval:       p.BillingInterval,
		BenefitsJson:          string(benefitsBytes),
		EntitlementConfigJson: string(entBytes),
		Status:                st,
		SubscriberCount:       p.SubscriberCount,
		CreatedAt:             timestamppb.New(p.CreatedAt),
		UpdatedAt:             timestamppb.New(p.UpdatedAt),
	}
	if p.DeletedAt != nil {
		res.DeletedAt = timestamppb.New(*p.DeletedAt)
	}
	return res
}

func toProtoBundle(b *Bundle) *commercev1.Bundle {
	if b == nil {
		return nil
	}
	var items []*commercev1.BundleItem
	for _, it := range b.Items {
		items = append(items, &commercev1.BundleItem{
			BundleId:       it.BundleID,
			ProductId:      it.ProductID,
			Quantity:       it.Quantity,
			ProductTitle:   it.ProductTitle,
			AvailableStock: it.AvailableStock,
		})
	}
	return &commercev1.Bundle{
		BundleId:          b.BundleID,
		WorkspaceId:       b.WorkspaceID,
		Title:             b.Title,
		OfferId:           b.OfferID,
		BundlePrice:       b.BundlePrice.String(),
		DiscountPct:       b.DiscountPct,
		Status:            b.Status,
		Items:             items,
		IsAvailable:       b.IsAvailable,
		UnavailableReason: b.UnavailableReason,
		CreatedAt:         timestamppb.New(b.CreatedAt),
	}
}

func toProtoDelivery(d *DigitalDelivery) *commercev1.DigitalDelivery {
	if d == nil {
		return nil
	}
	entBytes, _ := json.Marshal(d.EntitlementPayloadJSON)
	var dt commercev1.DeliveryType
	switch d.DeliveryType {
	case DeliveryTypeDownloadLink:
		dt = commercev1.DeliveryType_DELIVERY_TYPE_DOWNLOAD_LINK
	case DeliveryTypeLicenseKey:
		dt = commercev1.DeliveryType_DELIVERY_TYPE_LICENSE_KEY
	case DeliveryTypeAccessGrant:
		dt = commercev1.DeliveryType_DELIVERY_TYPE_ACCESS_GRANT
	default:
		dt = commercev1.DeliveryType_DELIVERY_TYPE_UNSPECIFIED
	}
	var ds commercev1.DeliveryStatus
	switch d.Status {
	case DeliveryStatusPending:
		ds = commercev1.DeliveryStatus_DELIVERY_STATUS_PENDING
	case DeliveryStatusDelivered:
		ds = commercev1.DeliveryStatus_DELIVERY_STATUS_DELIVERED
	case DeliveryStatusRevoked:
		ds = commercev1.DeliveryStatus_DELIVERY_STATUS_REVOKED
	default:
		ds = commercev1.DeliveryStatus_DELIVERY_STATUS_UNSPECIFIED
	}

	res := &commercev1.DigitalDelivery{
		DeliveryId:             d.DeliveryID,
		WorkspaceId:            d.WorkspaceID,
		OrderId:                d.OrderID,
		CustomerEntityId:       d.CustomerEntityID,
		ProductId:              d.ProductID,
		OfferId:                d.OfferID,
		DeliveryType:           dt,
		EntitlementPayloadJson: string(entBytes),
		Status:                 ds,
		IdempotencyKey:         d.IdempotencyKey,
		DownloadCount:          d.DownloadCount,
		MaxDownloads:           d.MaxDownloads,
		CreatedAt:              timestamppb.New(d.CreatedAt),
	}
	if d.ExpiresAt != nil {
		res.ExpiresAt = timestamppb.New(*d.ExpiresAt)
	}
	return res
}

func toProtoSubscription(s *MembershipSubscription) *commercev1.MembershipSubscription {
	if s == nil {
		return nil
	}
	entBytes, _ := json.Marshal(s.EntitlementSnapshotJSON)
	var st commercev1.MembershipSubscriptionStatus
	switch s.Status {
	case MembershipSubscriptionStatusActive:
		st = commercev1.MembershipSubscriptionStatus_MEMBERSHIP_SUBSCRIPTION_STATUS_ACTIVE
	case MembershipSubscriptionStatusCancelled:
		st = commercev1.MembershipSubscriptionStatus_MEMBERSHIP_SUBSCRIPTION_STATUS_CANCELLED
	case MembershipSubscriptionStatusExpired:
		st = commercev1.MembershipSubscriptionStatus_MEMBERSHIP_SUBSCRIPTION_STATUS_EXPIRED
	default:
		st = commercev1.MembershipSubscriptionStatus_MEMBERSHIP_SUBSCRIPTION_STATUS_UNSPECIFIED
	}

	return &commercev1.MembershipSubscription{
		MembershipId:            s.MembershipID,
		WorkspaceId:             s.WorkspaceID,
		PlanId:                  s.PlanID,
		CustomerEntityId:        s.CustomerEntityID,
		Status:                  st,
		ProviderSubscriptionId:  s.ProviderSubscriptionID,
		CurrentPeriodStart:      timestamppb.New(s.CurrentPeriodStart),
		CurrentPeriodEnd:        timestamppb.New(s.CurrentPeriodEnd),
		EntitlementSnapshotJson: string(entBytes),
		CreatedAt:               timestamppb.New(s.CreatedAt),
		UpdatedAt:               timestamppb.New(s.UpdatedAt),
	}
}

// ----------------------------------------------------------------------------
// StoreServiceHandler Implementation
// ----------------------------------------------------------------------------

type StoreHandler struct {
	svc *Service
}

func NewStoreHandler(svc *Service) *StoreHandler {
	return &StoreHandler{svc: svc}
}

var _ commercev1connect.StoreServiceHandler = (*StoreHandler)(nil)

func (h *StoreHandler) CreatePage(ctx context.Context, req *connect.Request[commercev1.StoreServiceCreatePageRequest]) (*connect.Response[commercev1.StoreServiceCreatePageResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	var layout map[string]any
	if req.Msg.LayoutJson != "" {
		_ = json.Unmarshal([]byte(req.Msg.LayoutJson), &layout)
	}
	var theme map[string]any
	if req.Msg.ThemeOverridesJson != "" {
		_ = json.Unmarshal([]byte(req.Msg.ThemeOverridesJson), &theme)
	}

	page := &StorePage{
		WorkspaceID:        wsID,
		Title:              req.Msg.Title,
		Slug:               req.Msg.Slug,
		Description:        req.Msg.Description,
		LayoutJSON:         layout,
		ThemeOverridesJSON: theme,
		CustomDomain:       req.Msg.CustomDomain,
	}
	created, err := h.svc.CreatePage(ctx, page)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.StoreServiceCreatePageResponse{Page: toProtoStorePage(created)}), nil
}

func (h *StoreHandler) Get(ctx context.Context, req *connect.Request[commercev1.StoreServiceGetRequest]) (*connect.Response[commercev1.StoreServiceGetResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	page, bundles, err := h.svc.GetPage(ctx, wsID, req.Msg.StorePageId, req.Msg.Slug)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoBundles []*commercev1.Bundle
	for _, b := range bundles {
		protoBundles = append(protoBundles, toProtoBundle(&b))
	}
	return connect.NewResponse(&commercev1.StoreServiceGetResponse{
		Page:            toProtoStorePage(page),
		FeaturedBundles: protoBundles,
	}), nil
}

func (h *StoreHandler) GetPage(ctx context.Context, req *connect.Request[commercev1.StoreServiceGetPageRequest]) (*connect.Response[commercev1.StoreServiceGetPageResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	page, bundles, err := h.svc.GetPage(ctx, wsID, req.Msg.StorePageId, req.Msg.Slug)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoBundles []*commercev1.Bundle
	for _, b := range bundles {
		protoBundles = append(protoBundles, toProtoBundle(&b))
	}
	return connect.NewResponse(&commercev1.StoreServiceGetPageResponse{
		Page:            toProtoStorePage(page),
		FeaturedBundles: protoBundles,
	}), nil
}

func (h *StoreHandler) List(ctx context.Context, req *connect.Request[commercev1.StoreServiceListRequest]) (*connect.Response[commercev1.StoreServiceListResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	var status StorePageStatus
	switch req.Msg.StatusFilter {
	case commercev1.StorePageStatus_STORE_PAGE_STATUS_DRAFT:
		status = StorePageStatusDraft
	case commercev1.StorePageStatus_STORE_PAGE_STATUS_PUBLISHED:
		status = StorePageStatusPublished
	}
	pages, err := h.svc.ListPages(ctx, wsID, status)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoPages []*commercev1.StorePage
	for _, p := range pages {
		protoPages = append(protoPages, toProtoStorePage(&p))
	}
	return connect.NewResponse(&commercev1.StoreServiceListResponse{
		Pages:      protoPages,
		TotalCount: int64(len(protoPages)),
	}), nil
}

func (h *StoreHandler) ListPages(ctx context.Context, req *connect.Request[commercev1.StoreServiceListPagesRequest]) (*connect.Response[commercev1.StoreServiceListPagesResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	var status StorePageStatus
	switch req.Msg.StatusFilter {
	case commercev1.StorePageStatus_STORE_PAGE_STATUS_DRAFT:
		status = StorePageStatusDraft
	case commercev1.StorePageStatus_STORE_PAGE_STATUS_PUBLISHED:
		status = StorePageStatusPublished
	}
	pages, err := h.svc.ListPages(ctx, wsID, status)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoPages []*commercev1.StorePage
	for _, p := range pages {
		protoPages = append(protoPages, toProtoStorePage(&p))
	}
	return connect.NewResponse(&commercev1.StoreServiceListPagesResponse{
		Pages:      protoPages,
		TotalCount: int64(len(protoPages)),
	}), nil
}

func (h *StoreHandler) UpdatePage(ctx context.Context, req *connect.Request[commercev1.StoreServiceUpdatePageRequest]) (*connect.Response[commercev1.StoreServiceUpdatePageResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	var layout map[string]any
	if req.Msg.LayoutJson != "" {
		_ = json.Unmarshal([]byte(req.Msg.LayoutJson), &layout)
	}
	var theme map[string]any
	if req.Msg.ThemeOverridesJson != "" {
		_ = json.Unmarshal([]byte(req.Msg.ThemeOverridesJson), &theme)
	}

	page := &StorePage{
		StorePageID:        req.Msg.StorePageId,
		WorkspaceID:        wsID,
		Title:              req.Msg.Title,
		Slug:               req.Msg.Slug,
		Description:        req.Msg.Description,
		LayoutJSON:         layout,
		ThemeOverridesJSON: theme,
		CustomDomain:       req.Msg.CustomDomain,
	}
	updated, err := h.svc.UpdatePage(ctx, page)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.StoreServiceUpdatePageResponse{Page: toProtoStorePage(updated)}), nil
}

func (h *StoreHandler) PublishPage(ctx context.Context, req *connect.Request[commercev1.StoreServicePublishPageRequest]) (*connect.Response[commercev1.StoreServicePublishPageResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	page, pubURL, err := h.svc.PublishPage(ctx, wsID, req.Msg.StorePageId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.StoreServicePublishPageResponse{
		Page:      toProtoStorePage(page),
		PublicUrl: pubURL,
	}), nil
}

func (h *StoreHandler) Publish(ctx context.Context, req *connect.Request[commercev1.StoreServicePublishRequest]) (*connect.Response[commercev1.StoreServicePublishResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	page, pubURL, err := h.svc.PublishPage(ctx, wsID, req.Msg.StorePageId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.StoreServicePublishResponse{
		Page:      toProtoStorePage(page),
		PublicUrl: pubURL,
	}), nil
}

func (h *StoreHandler) Unpublish(ctx context.Context, req *connect.Request[commercev1.StoreServiceUnpublishRequest]) (*connect.Response[commercev1.StoreServiceUnpublishResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	page, err := h.svc.UnpublishPage(ctx, wsID, req.Msg.StorePageId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.StoreServiceUnpublishResponse{Page: toProtoStorePage(page)}), nil
}

func (h *StoreHandler) DeletePage(ctx context.Context, req *connect.Request[commercev1.StoreServiceDeletePageRequest]) (*connect.Response[commercev1.StoreServiceDeletePageResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	if err := h.svc.DeletePage(ctx, wsID, req.Msg.StorePageId); err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.StoreServiceDeletePageResponse{Success: true}), nil
}

func (h *StoreHandler) DuplicatePage(ctx context.Context, req *connect.Request[commercev1.StoreServiceDuplicatePageRequest]) (*connect.Response[commercev1.StoreServiceDuplicatePageResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	page, err := h.svc.DuplicatePage(ctx, wsID, req.Msg.StorePageId, req.Msg.NewTitle, req.Msg.NewSlug)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.StoreServiceDuplicatePageResponse{Page: toProtoStorePage(page)}), nil
}

func (h *StoreHandler) GetThemes(ctx context.Context, req *connect.Request[commercev1.StoreServiceGetThemesRequest]) (*connect.Response[commercev1.StoreServiceGetThemesResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	themes, err := h.svc.GetThemes(ctx, wsID)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoThemes []*commercev1.StoreTheme
	for _, th := range themes {
		protoThemes = append(protoThemes, &commercev1.StoreTheme{
			ThemeId:      th.ThemeID,
			Name:         th.Name,
			PrimaryColor: th.PrimaryColor,
			FontFamily:   th.FontFamily,
			BorderRadius: th.BorderRadius,
			IsDefault:    th.IsDefault,
		})
	}
	return connect.NewResponse(&commercev1.StoreServiceGetThemesResponse{Themes: protoThemes}), nil
}

func (h *StoreHandler) GetPageStats(ctx context.Context, req *connect.Request[commercev1.StoreServiceGetPageStatsRequest]) (*connect.Response[commercev1.StoreServiceGetPageStatsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	stats, err := h.svc.GetPageStats(ctx, wsID, req.Msg.StorePageId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.StoreServiceGetPageStatsResponse{
		Stats: &commercev1.PageStats{
			StorePageId:    stats.StorePageID,
			Views:          stats.Views,
			Orders:         stats.Orders,
			ConversionRate: stats.ConversionRate,
			Revenue:        stats.Revenue.String(),
			Currency:       stats.Currency,
		},
	}), nil
}

func (h *StoreHandler) Checkout(ctx context.Context, req *connect.Request[commercev1.StoreServiceCheckoutRequest]) (*connect.Response[commercev1.StoreServiceCheckoutResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	orderAmt, err := tenantdb.ParseExactDecimal(req.Msg.OrderAmount)
	if err != nil && req.Msg.OrderAmount != "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	checkoutReq := CheckoutRequest{
		WorkspaceID:      wsID,
		CustomerEntityID: req.Msg.CustomerEntityId,
		IdempotencyKey:   req.Msg.IdempotencyKey,
		PaymentIntentID:  req.Msg.PaymentIntentId,
		OfferID:          req.Msg.OfferId,
		BundleID:         req.Msg.BundleId,
		MembershipPlanID: req.Msg.MembershipPlanId,
		ProductIDs:       req.Msg.ProductIds,
		OrderAmount:      orderAmt,
		Currency:         req.Msg.Currency,
	}

	res, err := h.svc.Checkout(ctx, checkoutReq)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	var protoDeliveries []*commercev1.DigitalDelivery
	for _, d := range res.Deliveries {
		protoDeliveries = append(protoDeliveries, toProtoDelivery(&d))
	}

	return connect.NewResponse(&commercev1.StoreServiceCheckoutResponse{
		Success:      res.Success,
		OrderId:      res.OrderID,
		Status:       res.Status,
		Deliveries:   protoDeliveries,
		Subscription: toProtoSubscription(res.Subscription),
		IsReplayed:   res.IsReplayed,
	}), nil
}

func (h *StoreHandler) GetBuyerEntitlements(ctx context.Context, req *connect.Request[commercev1.StoreServiceGetBuyerEntitlementsRequest]) (*connect.Response[commercev1.StoreServiceGetBuyerEntitlementsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	ent, err := h.svc.GetBuyerEntitlements(ctx, wsID, req.Msg.CustomerEntityId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoDeliveries []*commercev1.DigitalDelivery
	for _, d := range ent.Deliveries {
		protoDeliveries = append(protoDeliveries, toProtoDelivery(&d))
	}
	var protoSubs []*commercev1.MembershipSubscription
	for _, s := range ent.ActiveSubscriptions {
		protoSubs = append(protoSubs, toProtoSubscription(&s))
	}

	return connect.NewResponse(&commercev1.StoreServiceGetBuyerEntitlementsResponse{
		Entitlements: &commercev1.BuyerEntitlements{
			CustomerEntityId:     ent.CustomerEntityID,
			WorkspaceId:          ent.WorkspaceID,
			AccessibleContentIds: ent.AccessibleContentIDs,
			DiscountPct:          ent.DiscountPct,
			HasPriorityDm:        ent.HasPriorityDM,
			Deliveries:           protoDeliveries,
			ActiveSubscriptions:  protoSubs,
		},
	}), nil
}

// ----------------------------------------------------------------------------
// MembershipServiceHandler Implementation
// ----------------------------------------------------------------------------

type MembershipHandler struct {
	svc *Service
}

func NewMembershipHandler(svc *Service) *MembershipHandler {
	return &MembershipHandler{svc: svc}
}

var _ commercev1connect.MembershipServiceHandler = (*MembershipHandler)(nil)

func (h *MembershipHandler) CreatePlan(ctx context.Context, req *connect.Request[commercev1.MembershipServiceCreatePlanRequest]) (*connect.Response[commercev1.MembershipServiceCreatePlanResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	price, err := tenantdb.ParseExactDecimal(req.Msg.Price)
	if err != nil && req.Msg.Price != "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	var benefits []map[string]any
	if req.Msg.BenefitsJson != "" {
		_ = json.Unmarshal([]byte(req.Msg.BenefitsJson), &benefits)
	}
	var entitlements map[string]any
	if req.Msg.EntitlementConfigJson != "" {
		_ = json.Unmarshal([]byte(req.Msg.EntitlementConfigJson), &entitlements)
	}

	plan := &MembershipPlan{
		WorkspaceID:           wsID,
		Title:                 req.Msg.Title,
		Description:           req.Msg.Description,
		Price:                 price,
		Currency:              req.Msg.Currency,
		BillingInterval:       req.Msg.BillingInterval,
		BenefitsJSON:          benefits,
		EntitlementConfigJSON: entitlements,
	}
	created, err := h.svc.CreatePlan(ctx, plan)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServiceCreatePlanResponse{Plan: toProtoMembershipPlan(created)}), nil
}

func (h *MembershipHandler) GetPlan(ctx context.Context, req *connect.Request[commercev1.MembershipServiceGetPlanRequest]) (*connect.Response[commercev1.MembershipServiceGetPlanResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	plan, err := h.svc.GetPlan(ctx, wsID, req.Msg.PlanId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServiceGetPlanResponse{Plan: toProtoMembershipPlan(plan)}), nil
}

func (h *MembershipHandler) ListPlans(ctx context.Context, req *connect.Request[commercev1.MembershipServiceListPlansRequest]) (*connect.Response[commercev1.MembershipServiceListPlansResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	var status MembershipPlanStatus
	switch req.Msg.StatusFilter {
	case commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_DRAFT:
		status = MembershipPlanStatusDraft
	case commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_ACTIVE:
		status = MembershipPlanStatusActive
	case commercev1.MembershipPlanStatus_MEMBERSHIP_PLAN_STATUS_PAUSED:
		status = MembershipPlanStatusPaused
	}
	plans, err := h.svc.ListPlans(ctx, wsID, status)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoPlans []*commercev1.MembershipPlan
	for _, p := range plans {
		protoPlans = append(protoPlans, toProtoMembershipPlan(&p))
	}
	return connect.NewResponse(&commercev1.MembershipServiceListPlansResponse{
		Plans:      protoPlans,
		TotalCount: int64(len(protoPlans)),
	}), nil
}

func (h *MembershipHandler) UpdatePlan(ctx context.Context, req *connect.Request[commercev1.MembershipServiceUpdatePlanRequest]) (*connect.Response[commercev1.MembershipServiceUpdatePlanResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	price, err := tenantdb.ParseExactDecimal(req.Msg.Price)
	if err != nil && req.Msg.Price != "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	var benefits []map[string]any
	if req.Msg.BenefitsJson != "" {
		_ = json.Unmarshal([]byte(req.Msg.BenefitsJson), &benefits)
	}
	var entitlements map[string]any
	if req.Msg.EntitlementConfigJson != "" {
		_ = json.Unmarshal([]byte(req.Msg.EntitlementConfigJson), &entitlements)
	}

	plan := &MembershipPlan{
		PlanID:                req.Msg.PlanId,
		WorkspaceID:           wsID,
		Title:                 req.Msg.Title,
		Description:           req.Msg.Description,
		Price:                 price,
		Currency:              req.Msg.Currency,
		BillingInterval:       req.Msg.BillingInterval,
		BenefitsJSON:          benefits,
		EntitlementConfigJSON: entitlements,
	}
	updated, err := h.svc.UpdatePlan(ctx, plan)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServiceUpdatePlanResponse{Plan: toProtoMembershipPlan(updated)}), nil
}

func (h *MembershipHandler) DuplicatePlan(ctx context.Context, req *connect.Request[commercev1.MembershipServiceDuplicatePlanRequest]) (*connect.Response[commercev1.MembershipServiceDuplicatePlanResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	plan, err := h.svc.DuplicatePlan(ctx, wsID, req.Msg.PlanId, req.Msg.NewTitle)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServiceDuplicatePlanResponse{Plan: toProtoMembershipPlan(plan)}), nil
}

func (h *MembershipHandler) Delete(ctx context.Context, req *connect.Request[commercev1.MembershipServiceDeleteRequest]) (*connect.Response[commercev1.MembershipServiceDeleteResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	if err := h.svc.DeletePlan(ctx, wsID, req.Msg.PlanId); err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServiceDeleteResponse{Success: true}), nil
}

func (h *MembershipHandler) Archive(ctx context.Context, req *connect.Request[commercev1.MembershipServiceArchiveRequest]) (*connect.Response[commercev1.MembershipServiceArchiveResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	plan, err := h.svc.ArchivePlan(ctx, wsID, req.Msg.PlanId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServiceArchiveResponse{Plan: toProtoMembershipPlan(plan)}), nil
}

func (h *MembershipHandler) Publish(ctx context.Context, req *connect.Request[commercev1.MembershipServicePublishRequest]) (*connect.Response[commercev1.MembershipServicePublishResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	plan, err := h.svc.PublishPlan(ctx, wsID, req.Msg.PlanId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServicePublishResponse{Plan: toProtoMembershipPlan(plan)}), nil
}

func (h *MembershipHandler) Pause(ctx context.Context, req *connect.Request[commercev1.MembershipServicePauseRequest]) (*connect.Response[commercev1.MembershipServicePauseResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	plan, err := h.svc.PausePlan(ctx, wsID, req.Msg.PlanId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServicePauseResponse{Plan: toProtoMembershipPlan(plan)}), nil
}

func (h *MembershipHandler) Resume(ctx context.Context, req *connect.Request[commercev1.MembershipServiceResumeRequest]) (*connect.Response[commercev1.MembershipServiceResumeResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	plan, err := h.svc.ResumePlan(ctx, wsID, req.Msg.PlanId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServiceResumeResponse{Plan: toProtoMembershipPlan(plan)}), nil
}

func (h *MembershipHandler) GetMRRSummary(ctx context.Context, req *connect.Request[commercev1.MembershipServiceGetMRRSummaryRequest]) (*connect.Response[commercev1.MembershipServiceGetMRRSummaryResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	mrr, cur, subs, churn, ltv, trial, err := h.svc.GetMRRSummary(ctx, wsID)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.MembershipServiceGetMRRSummaryResponse{
		CurrentMrr:          mrr.String(),
		Currency:            cur,
		ActiveSubscribers:   subs,
		ChurnRate:           churn,
		AverageLtv:          ltv.String(),
		TrialConversionRate: trial,
	}), nil
}

func (h *MembershipHandler) GetMRRTrend(ctx context.Context, req *connect.Request[commercev1.MembershipServiceGetMRRTrendRequest]) (*connect.Response[commercev1.MembershipServiceGetMRRTrendResponse], error) {
	_, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	// Return illustrative 6-month historical trend
	return connect.NewResponse(&commercev1.MembershipServiceGetMRRTrendResponse{
		TrendPoints: []*commercev1.MRRMonthPoint{
			{MonthLabel: "2026-06", Mrr: "32000000.000000", Subscribers: 210},
			{MonthLabel: "2026-07", Mrr: "35500000.000000", Subscribers: 240},
			{MonthLabel: "2026-08", Mrr: "38900000.000000", Subscribers: 265},
			{MonthLabel: "2026-09", Mrr: "41200000.000000", Subscribers: 285},
			{MonthLabel: "2026-10", Mrr: "44800000.000000", Subscribers: 308},
			{MonthLabel: "2026-11", Mrr: "46600000.000000", Subscribers: 323},
		},
	}), nil
}

// ----------------------------------------------------------------------------
// BundleServiceHandler Implementation
// ----------------------------------------------------------------------------

type BundleHandler struct {
	svc *Service
}

func NewBundleHandler(svc *Service) *BundleHandler {
	return &BundleHandler{svc: svc}
}

var _ commercev1connect.BundleServiceHandler = (*BundleHandler)(nil)

func (h *BundleHandler) CreateBundle(ctx context.Context, req *connect.Request[commercev1.BundleServiceCreateBundleRequest]) (*connect.Response[commercev1.BundleServiceCreateBundleResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, req.Msg.CommandContext)
	if err != nil {
		return nil, err
	}
	price, err := tenantdb.ParseExactDecimal(req.Msg.BundlePrice)
	if err != nil && req.Msg.BundlePrice != "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	var items []BundleItem
	for _, it := range req.Msg.Items {
		items = append(items, BundleItem{
			ProductID:    it.ProductId,
			Quantity:     it.Quantity,
			ProductTitle: it.ProductTitle,
		})
	}

	bundle := &Bundle{
		WorkspaceID: wsID,
		Title:       req.Msg.Title,
		OfferID:     req.Msg.OfferId,
		BundlePrice: price,
		DiscountPct: req.Msg.DiscountPct,
		Status:      "active",
		Items:       items,
	}

	created, err := h.svc.CreateBundle(ctx, bundle)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.BundleServiceCreateBundleResponse{Bundle: toProtoBundle(created)}), nil
}

func (h *BundleHandler) GetBundle(ctx context.Context, req *connect.Request[commercev1.BundleServiceGetBundleRequest]) (*connect.Response[commercev1.BundleServiceGetBundleResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	bundle, err := h.svc.GetBundle(ctx, wsID, req.Msg.BundleId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&commercev1.BundleServiceGetBundleResponse{Bundle: toProtoBundle(bundle)}), nil
}

func (h *BundleHandler) ListBundles(ctx context.Context, req *connect.Request[commercev1.BundleServiceListBundlesRequest]) (*connect.Response[commercev1.BundleServiceListBundlesResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	bundles, err := h.svc.ListBundles(ctx, wsID)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoBundles []*commercev1.Bundle
	for _, b := range bundles {
		protoBundles = append(protoBundles, toProtoBundle(&b))
	}
	return connect.NewResponse(&commercev1.BundleServiceListBundlesResponse{Bundles: protoBundles}), nil
}

func (h *BundleHandler) CheckBundleStock(ctx context.Context, req *connect.Request[commercev1.BundleServiceCheckBundleStockRequest]) (*connect.Response[commercev1.BundleServiceCheckBundleStockResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}
	avail, reason, breakdown, err := h.svc.CheckBundleStock(ctx, wsID, req.Msg.BundleId, req.Msg.RequestedQuantity)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var protoItems []*commercev1.BundleItem
	for _, it := range breakdown {
		protoItems = append(protoItems, &commercev1.BundleItem{
			BundleId:       it.BundleID,
			ProductId:      it.ProductID,
			Quantity:       it.Quantity,
			ProductTitle:   it.ProductTitle,
			AvailableStock: it.AvailableStock,
		})
	}
	return connect.NewResponse(&commercev1.BundleServiceCheckBundleStockResponse{
		BundleId:       req.Msg.BundleId,
		IsAvailable:    avail,
		Reason:         reason,
		StockBreakdown: protoItems,
	}), nil
}

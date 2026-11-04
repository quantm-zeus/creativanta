package creatorpro

import (
	"context"
	"encoding/json"
	"errors"
	"strings"
	"time"

	"connectrpc.com/connect"
	v1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func resolveTenant(ctx context.Context, workspaceID string) (string, error) {
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.WorkspaceID != "" {
		if workspaceID != "" && workspaceID != session.WorkspaceID && !session.InternalAdmin {
			return "", connect.NewError(connect.CodePermissionDenied, ErrScopeMismatch)
		}
		return session.WorkspaceID, nil
	}
	if workspaceID != "" {
		return workspaceID, nil
	}
	return "", connect.NewError(connect.CodeUnauthenticated, ErrMissingTenant)
}

// ----------------------------------------------------------------------------
// LinkInBioHandler
// ----------------------------------------------------------------------------

type LinkInBioHandler struct {
	commercev1connect.UnimplementedLinkInBioServiceHandler
	svc *Service
}

func NewLinkInBioHandler(svc *Service) *LinkInBioHandler {
	return &LinkInBioHandler{svc: svc}
}

func (h *LinkInBioHandler) CreatePage(ctx context.Context, req *connect.Request[v1.CreatePageRequest]) (*connect.Response[v1.CreatePageResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	page := &LinkInBioPage{
		WorkspaceID: wsID,
		Slug:        req.Msg.Slug,
		Title:       req.Msg.Title,
		Bio:         req.Msg.Bio,
		AvatarURL:   req.Msg.AvatarUrl,
		Theme:       req.Msg.Theme,
	}
	created, err := h.svc.CreatePage(ctx, page)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.CreatePageResponse{Page: toProtoLinkInBioPage(created)}), nil
}

func (h *LinkInBioHandler) GetPage(ctx context.Context, req *connect.Request[v1.GetPageRequest]) (*connect.Response[v1.GetPageResponse], error) {
	wsID := req.Msg.WorkspaceId
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.WorkspaceID != "" {
		wsID = session.WorkspaceID
	}
	page, err := h.svc.GetPage(ctx, wsID, req.Msg.PageId, req.Msg.Slug)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.GetPageResponse{Page: toProtoLinkInBioPage(page)}), nil
}

func (h *LinkInBioHandler) UpdatePage(ctx context.Context, req *connect.Request[v1.UpdatePageRequest]) (*connect.Response[v1.UpdatePageResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	page := &LinkInBioPage{
		WorkspaceID:  wsID,
		PageID:       req.Msg.PageId,
		Title:        req.Msg.Title,
		Bio:          req.Msg.Bio,
		AvatarURL:    req.Msg.AvatarUrl,
		Theme:        req.Msg.Theme,
		CustomDomain: req.Msg.CustomDomain,
	}
	updated, err := h.svc.UpdatePage(ctx, page)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.UpdatePageResponse{Page: toProtoLinkInBioPage(updated)}), nil
}

func (h *LinkInBioHandler) Save(ctx context.Context, req *connect.Request[v1.LinkInBioServiceSaveRequest]) (*connect.Response[v1.LinkInBioServiceSaveResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	page := &LinkInBioPage{
		WorkspaceID: wsID,
		PageID:      req.Msg.PageId,
		Title:       req.Msg.Title,
		Bio:         req.Msg.Bio,
	}
	saved, err := h.svc.SavePage(ctx, page)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.LinkInBioServiceSaveResponse{Page: toProtoLinkInBioPage(saved)}), nil
}

func (h *LinkInBioHandler) GetAnalytics(ctx context.Context, req *connect.Request[v1.GetAnalyticsRequest]) (*connect.Response[v1.GetAnalyticsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	page, err := h.svc.GetPage(ctx, wsID, req.Msg.PageId, "")
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var totalClicks int32
	metrics := make([]*v1.LinkItemMetric, 0, len(page.Items))
	for _, it := range page.Items {
		totalClicks += it.Clicks
		metrics = append(metrics, &v1.LinkItemMetric{
			LinkItemId: it.LinkItemID,
			Label:      it.Label,
			Url:        it.URL,
			Clicks:     it.Clicks,
		})
	}
	var ctr float64
	if page.TotalViews > 0 {
		ctr = float64(totalClicks) / float64(page.TotalViews) * 100.0
	}
	return connect.NewResponse(&v1.GetAnalyticsResponse{
		Analytics: &v1.LinkInBioAnalytics{
			PageId:           page.PageID,
			WorkspaceId:      page.WorkspaceID,
			TotalViews:       page.TotalViews,
			TotalClicks:      totalClicks,
			ClickThroughRate: ctr,
			ItemMetrics:      metrics,
		},
	}), nil
}

func (h *LinkInBioHandler) Reorder(ctx context.Context, req *connect.Request[v1.LinkInBioServiceReorderRequest]) (*connect.Response[v1.LinkInBioServiceReorderResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	items, err := h.svc.ReorderLinks(ctx, wsID, req.Msg.PageId, req.Msg.ItemIdsInOrder)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoItems := make([]*v1.LinkItem, 0, len(items))
	for _, it := range items {
		protoItems = append(protoItems, toProtoLinkItem(&it))
	}
	return connect.NewResponse(&v1.LinkInBioServiceReorderResponse{Items: protoItems}), nil
}

func (h *LinkInBioHandler) ToggleLink(ctx context.Context, req *connect.Request[v1.ToggleLinkRequest]) (*connect.Response[v1.ToggleLinkResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	item, err := h.svc.ToggleLink(ctx, wsID, req.Msg.LinkItemId, req.Msg.IsActive)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.ToggleLinkResponse{Item: toProtoLinkItem(item)}), nil
}

func (h *LinkInBioHandler) UpdateTheme(ctx context.Context, req *connect.Request[v1.UpdateThemeRequest]) (*connect.Response[v1.UpdateThemeResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	page, err := h.svc.GetPage(ctx, wsID, req.Msg.PageId, "")
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	page.Theme = req.Msg.Theme
	updated, err := h.svc.UpdatePage(ctx, page)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.UpdateThemeResponse{Page: toProtoLinkInBioPage(updated)}), nil
}

func (h *LinkInBioHandler) ScanLink(ctx context.Context, req *connect.Request[v1.ScanLinkRequest]) (*connect.Response[v1.ScanLinkResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	scan, err := h.svc.ScanLink(ctx, wsID, req.Msg.Url)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	var scanStatus v1.LinkSecurityScanStatus
	switch scan.ScanStatus {
	case LinkSecurityScanStatusSafe:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_SAFE
	case LinkSecurityScanStatusSuspicious:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_SUSPICIOUS
	case LinkSecurityScanStatusPhishing:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_PHISHING
	case LinkSecurityScanStatusMalware:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_MALWARE
	default:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_BLOCKED
	}
	return connect.NewResponse(&v1.ScanLinkResponse{
		Url:              scan.URL,
		ScanStatus:       scanStatus,
		PhishingDetected: scan.PhishingDetected,
		ThreatDetails:    scan.ThreatDetails,
		CanBePublished:   !scan.BlockedFromPublishing,
	}), nil
}

func (h *LinkInBioHandler) ReportLink(ctx context.Context, req *connect.Request[v1.ReportLinkRequest]) (*connect.Response[v1.ReportLinkResponse], error) {
	return connect.NewResponse(&v1.ReportLinkResponse{
		Accepted:   true,
		IncidentId: newUUID(),
	}), nil
}

func (h *LinkInBioHandler) VerifyCustomDomain(ctx context.Context, req *connect.Request[v1.VerifyCustomDomainRequest]) (*connect.Response[v1.VerifyCustomDomainResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	verified, msg, ssl, err := h.svc.VerifyCustomDomain(ctx, wsID, req.Msg.PageId, req.Msg.CustomDomain)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.VerifyCustomDomainResponse{
		Verified:       verified,
		StatusMessage:  msg,
		SslProvisioned: ssl,
	}), nil
}

// ----------------------------------------------------------------------------
// MediaKitHandler
// ----------------------------------------------------------------------------

type MediaKitHandler struct {
	commercev1connect.UnimplementedMediaKitServiceHandler
	svc *Service
}

func NewMediaKitHandler(svc *Service) *MediaKitHandler {
	return &MediaKitHandler{svc: svc}
}

func (h *MediaKitHandler) Generate(ctx context.Context, req *connect.Request[v1.MediaKitServiceGenerateRequest]) (*connect.Response[v1.MediaKitServiceGenerateResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	kit, err := h.svc.GenerateMediaKit(ctx, wsID, req.Msg.Template, req.Msg.BrandProfileId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.MediaKitServiceGenerateResponse{MediaKit: toProtoMediaKit(kit)}), nil
}

func (h *MediaKitHandler) Get(ctx context.Context, req *connect.Request[v1.MediaKitServiceGetRequest]) (*connect.Response[v1.MediaKitServiceGetResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	kit, err := h.svc.store.GetMediaKit(ctx, wsID, req.Msg.MediaKitId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.MediaKitServiceGetResponse{MediaKit: toProtoMediaKit(kit)}), nil
}

func (h *MediaKitHandler) GetKit(ctx context.Context, req *connect.Request[v1.GetKitRequest]) (*connect.Response[v1.GetKitResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	kit, err := h.svc.store.GetMediaKit(ctx, wsID, req.Msg.MediaKitId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.GetKitResponse{MediaKit: toProtoMediaKit(kit)}), nil
}

func (h *MediaKitHandler) Export(ctx context.Context, req *connect.Request[v1.MediaKitServiceExportRequest]) (*connect.Response[v1.MediaKitServiceExportResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	kit, err := h.svc.store.GetMediaKit(ctx, wsID, req.Msg.MediaKitId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.MediaKitServiceExportResponse{
		ExportUrl: kit.ShareURL,
		FileName:  "media_kit.pdf",
	}), nil
}

func (h *MediaKitHandler) SetDirectoryProfile(ctx context.Context, req *connect.Request[v1.SetDirectoryProfileRequest]) (*connect.Response[v1.SetDirectoryProfileResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var prof *PublicCreatorProfile
	if req.Msg.Profile != nil {
		rates := make([]PublicRateItem, len(req.Msg.Profile.PublicRates))
		for i, r := range req.Msg.Profile.PublicRates {
			rates[i] = PublicRateItem{
				ServiceType: r.ServiceType,
				Amount:      r.Amount,
				Currency:    r.Currency,
			}
		}
		prof = &PublicCreatorProfile{
			DisplayName:   req.Msg.Profile.DisplayName,
			Bio:           req.Msg.Profile.Bio,
			Categories:    req.Msg.Profile.Categories,
			Languages:     req.Msg.Profile.Languages,
			PortfolioURLs: req.Msg.Profile.PortfolioUrls,
			PublicRates:   rates,
		}
	} else if req.Msg.DirectoryProfileJson != "" {
		var p PublicCreatorProfile
		if err := json.Unmarshal([]byte(req.Msg.DirectoryProfileJson), &p); err == nil {
			prof = &p
		}
	}

	kit, err := h.svc.SetDirectoryProfile(ctx, wsID, req.Msg.MediaKitId, req.Msg.DirectoryOptIn, prof)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	var status v1.MediaKitDirectoryStatus
	switch kit.DirectoryStatus {
	case MediaKitDirectoryStatusPublished:
		status = v1.MediaKitDirectoryStatus_MEDIA_KIT_DIRECTORY_STATUS_PUBLISHED
	case MediaKitDirectoryStatusPendingReview:
		status = v1.MediaKitDirectoryStatus_MEDIA_KIT_DIRECTORY_STATUS_PENDING_REVIEW
	default:
		status = v1.MediaKitDirectoryStatus_MEDIA_KIT_DIRECTORY_STATUS_HIDDEN
	}

	return connect.NewResponse(&v1.SetDirectoryProfileResponse{
		MediaKit:        toProtoMediaKit(kit),
		MediaKitId:      kit.MediaKitID,
		DirectoryStatus: status,
	}), nil
}

// ----------------------------------------------------------------------------
// RateCardHandler
// ----------------------------------------------------------------------------

type RateCardHandler struct {
	commercev1connect.UnimplementedRateCardServiceHandler
	svc *Service
}

func NewRateCardHandler(svc *Service) *RateCardHandler {
	return &RateCardHandler{svc: svc}
}

func (h *RateCardHandler) Create(ctx context.Context, req *connect.Request[v1.RateCardServiceCreateRequest]) (*connect.Response[v1.RateCardServiceCreateResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	items := make([]RateCardItem, 0, len(req.Msg.Items))
	for _, it := range req.Msg.Items {
		items = append(items, RateCardItem{
			ServiceType:      it.ServiceType,
			PriceMin:         it.PriceMin,
			PriceMax:         it.PriceMax,
			AISuggestedPrice: it.AiSuggestedPrice,
			Description:      it.Description,
			DeliveryTime:     it.DeliveryTime,
			Position:         it.Position,
		})
	}
	card := &RateCard{
		WorkspaceID: wsID,
		Currency:    req.Msg.Currency,
		CustomNote:  req.Msg.CustomNote,
		Items:       items,
	}
	created, err := h.svc.CreateRateCard(ctx, card)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.RateCardServiceCreateResponse{RateCard: toProtoRateCard(created)}), nil
}

func (h *RateCardHandler) GetRateCard(ctx context.Context, req *connect.Request[v1.GetRateCardRequest]) (*connect.Response[v1.GetRateCardResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	card, err := h.svc.store.GetRateCard(ctx, wsID, req.Msg.RateCardId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.GetRateCardResponse{RateCard: toProtoRateCard(card)}), nil
}

func (h *RateCardHandler) List(ctx context.Context, req *connect.Request[v1.RateCardServiceListRequest]) (*connect.Response[v1.RateCardServiceListResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	cards, err := h.svc.store.ListRateCards(ctx, wsID)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoCards := make([]*v1.RateCard, 0, len(cards))
	for _, c := range cards {
		protoCards = append(protoCards, toProtoRateCard(&c))
	}
	return connect.NewResponse(&v1.RateCardServiceListResponse{RateCards: protoCards}), nil
}

func (h *RateCardHandler) Save(ctx context.Context, req *connect.Request[v1.RateCardServiceSaveRequest]) (*connect.Response[v1.RateCardServiceSaveResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	card, err := h.svc.store.GetRateCard(ctx, wsID, req.Msg.RateCardId)
	if err != nil {
		items := make([]RateCardItem, 0, len(req.Msg.Items))
		for _, it := range req.Msg.Items {
			items = append(items, RateCardItem{
				ServiceType:  it.ServiceType,
				PriceMin:     it.PriceMin,
				PriceMax:     it.PriceMax,
				Description:  it.Description,
				DeliveryTime: it.DeliveryTime,
			})
		}
		newCard := &RateCard{
			WorkspaceID: wsID,
			RateCardID:  req.Msg.RateCardId,
			Currency:    req.Msg.Currency,
			CustomNote:  req.Msg.CustomNote,
			Items:       items,
		}
		created, err := h.svc.CreateRateCard(ctx, newCard)
		if err != nil {
			return nil, MapErrorToConnect(err)
		}
		return connect.NewResponse(&v1.RateCardServiceSaveResponse{RateCard: toProtoRateCard(created)}), nil
	}
	card.Currency = req.Msg.Currency
	card.CustomNote = req.Msg.CustomNote
	card.UpdatedAt = h.svc.nowFunc()
	_ = h.svc.store.UpdateRateCard(ctx, card)
	return connect.NewResponse(&v1.RateCardServiceSaveResponse{RateCard: toProtoRateCard(card)}), nil
}

func (h *RateCardHandler) DeleteItem(ctx context.Context, req *connect.Request[v1.RateCardServiceDeleteItemRequest]) (*connect.Response[v1.RateCardServiceDeleteItemResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	err = h.svc.store.DeleteRateCardItem(ctx, wsID, req.Msg.ItemId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.RateCardServiceDeleteItemResponse{Deleted: true}), nil
}

func (h *RateCardHandler) Reorder(ctx context.Context, req *connect.Request[v1.RateCardServiceReorderRequest]) (*connect.Response[v1.RateCardServiceReorderResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	card, err := h.svc.store.GetRateCard(ctx, wsID, req.Msg.RateCardId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoItems := make([]*v1.RateCardItem, 0, len(card.Items))
	for _, it := range card.Items {
		protoItems = append(protoItems, toProtoRateCardItem(&it))
	}
	return connect.NewResponse(&v1.RateCardServiceReorderResponse{Items: protoItems}), nil
}

func (h *RateCardHandler) CompareScope(ctx context.Context, req *connect.Request[v1.CompareScopeRequest]) (*connect.Response[v1.CompareScopeResponse], error) {
	return connect.NewResponse(&v1.CompareScopeResponse{
		ServiceType:  req.Msg.ServiceType,
		BenchmarkMin: 2000000.0,
		BenchmarkAvg: 3500000.0,
		BenchmarkMax: 6000000.0,
		Currency:     "VND",
	}), nil
}

func (h *RateCardHandler) AISuggest(ctx context.Context, req *connect.Request[v1.RateCardServiceAISuggestRequest]) (*connect.Response[v1.RateCardServiceAISuggestResponse], error) {
	suggested, low, high, rationale := h.svc.AISuggestRates(ctx, req.Msg.WorkspaceId, req.Msg.Platform, req.Msg.ServiceType)
	return connect.NewResponse(&v1.RateCardServiceAISuggestResponse{
		SuggestedPrice: suggested,
		PriceRangeLow:  low,
		PriceRangeHigh: high,
		Rationale:      rationale,
		Currency:       "VND",
	}), nil
}

// ----------------------------------------------------------------------------
// BrandDealHandler
// ----------------------------------------------------------------------------

type BrandDealHandler struct {
	commercev1connect.UnimplementedBrandDealServiceHandler
	svc *Service
}

func NewBrandDealHandler(svc *Service) *BrandDealHandler {
	return &BrandDealHandler{svc: svc}
}

func (h *BrandDealHandler) Create(ctx context.Context, req *connect.Request[v1.BrandDealServiceCreateRequest]) (*connect.Response[v1.BrandDealServiceCreateResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	deal := &BrandDeal{
		WorkspaceID:     wsID,
		BrandName:       req.Msg.BrandName,
		ContactEmail:    req.Msg.ContactEmail,
		Value:           req.Msg.Value,
		Currency:        req.Msg.Currency,
		Deadline:        req.Msg.Deadline,
		Deliverables:    req.Msg.Deliverables,
		InquiryThreadID: req.Msg.InquiryThreadId,
		Notes:           req.Msg.Notes,
	}
	switch req.Msg.DealType {
	case v1.BrandDealType_BRAND_DEAL_TYPE_SPONSORED_POST:
		deal.DealType = BrandDealTypeSponsoredPost
	case v1.BrandDealType_BRAND_DEAL_TYPE_PRODUCT_REVIEW:
		deal.DealType = BrandDealTypeProductReview
	case v1.BrandDealType_BRAND_DEAL_TYPE_AMBASSADOR:
		deal.DealType = BrandDealTypeAmbassador
	case v1.BrandDealType_BRAND_DEAL_TYPE_AFFILIATE:
		deal.DealType = BrandDealTypeAffiliate
	default:
		deal.DealType = BrandDealTypeCustom
	}
	created, err := h.svc.CreateBrandDeal(ctx, deal)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.BrandDealServiceCreateResponse{Deal: toProtoBrandDeal(created)}), nil
}

func (h *BrandDealHandler) UpdateStatus(ctx context.Context, req *connect.Request[v1.BrandDealServiceUpdateStatusRequest]) (*connect.Response[v1.BrandDealServiceUpdateStatusResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	var targetStatus BrandDealStatus
	switch req.Msg.TargetStatus {
	case v1.BrandDealStatus_BRAND_DEAL_STATUS_NEGOTIATING:
		targetStatus = BrandDealStatusNegotiating
	case v1.BrandDealStatus_BRAND_DEAL_STATUS_AGREED:
		targetStatus = BrandDealStatusAgreed
	case v1.BrandDealStatus_BRAND_DEAL_STATUS_IN_PROGRESS:
		targetStatus = BrandDealStatusInProgress
	case v1.BrandDealStatus_BRAND_DEAL_STATUS_DELIVERED:
		targetStatus = BrandDealStatusDelivered
	case v1.BrandDealStatus_BRAND_DEAL_STATUS_PAID:
		targetStatus = BrandDealStatusPaid
	case v1.BrandDealStatus_BRAND_DEAL_STATUS_COMPLETED:
		targetStatus = BrandDealStatusCompleted
	case v1.BrandDealStatus_BRAND_DEAL_STATUS_CANCELLED:
		targetStatus = BrandDealStatusCancelled
	default:
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidStateTransition)
	}

	var expectedUpdatedAt *time.Time
	if req.Msg.ExpectedUpdatedAt != nil {
		t := req.Msg.ExpectedUpdatedAt.AsTime()
		expectedUpdatedAt = &t
	}

	updated, err := h.svc.UpdateBrandDealStatusWithCAS(ctx, wsID, req.Msg.DealId, targetStatus, req.Msg.CancellationReason, req.Msg.RequiresFinancialReversal, expectedUpdatedAt)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.BrandDealServiceUpdateStatusResponse{Deal: toProtoBrandDeal(updated)}), nil
}

func (h *BrandDealHandler) List(ctx context.Context, req *connect.Request[v1.BrandDealServiceListRequest]) (*connect.Response[v1.BrandDealServiceListResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	var stFilter BrandDealStatus
	if req.Msg.StatusFilter != v1.BrandDealStatus_BRAND_DEAL_STATUS_UNSPECIFIED {
		stFilter = BrandDealStatus(req.Msg.StatusFilter.String())
	}
	deals, err := h.svc.ListBrandDeals(ctx, wsID, stFilter)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoDeals := make([]*v1.BrandDeal, 0, len(deals))
	for _, d := range deals {
		protoDeals = append(protoDeals, toProtoBrandDeal(&d))
	}
	return connect.NewResponse(&v1.BrandDealServiceListResponse{Deals: protoDeals}), nil
}

func (h *BrandDealHandler) ListDeals(ctx context.Context, req *connect.Request[v1.ListDealsRequest]) (*connect.Response[v1.ListDealsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	deals, err := h.svc.ListBrandDeals(ctx, wsID, "")
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoDeals := make([]*v1.BrandDeal, 0, len(deals))
	for _, d := range deals {
		protoDeals = append(protoDeals, toProtoBrandDeal(&d))
	}
	return connect.NewResponse(&v1.ListDealsResponse{Deals: protoDeals}), nil
}

func (h *BrandDealHandler) ListPartnerships(ctx context.Context, req *connect.Request[v1.ListPartnershipsRequest]) (*connect.Response[v1.ListPartnershipsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	deals, err := h.svc.ListBrandDeals(ctx, wsID, "")
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoDeals := make([]*v1.BrandDeal, 0, len(deals))
	for _, d := range deals {
		protoDeals = append(protoDeals, toProtoBrandDeal(&d))
	}
	return connect.NewResponse(&v1.ListPartnershipsResponse{Partnerships: protoDeals}), nil
}

func (h *BrandDealHandler) GetPipelineStats(ctx context.Context, req *connect.Request[v1.GetPipelineStatsRequest]) (*connect.Response[v1.GetPipelineStatsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	stats, err := h.svc.GetPipelineStats(ctx, wsID)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.GetPipelineStatsResponse{
		Stats: &v1.BrandDealPipelineStats{
			WorkspaceId:         stats.WorkspaceID,
			NegotiatingCount:    stats.NegotiatingCount,
			AgreedCount:         stats.AgreedCount,
			InProgressCount:     stats.InProgressCount,
			DeliveredCount:      stats.DeliveredCount,
			PaidCount:           stats.PaidCount,
			CompletedCount:      stats.CompletedCount,
			CancelledCount:      stats.CancelledCount,
			TotalActiveValue:    stats.TotalActiveValue,
			TotalCompletedValue: stats.TotalCompletedValue,
			Currency:            stats.Currency,
		},
	}), nil
}

func (h *BrandDealHandler) GetSummary(ctx context.Context, req *connect.Request[v1.BrandDealServiceGetSummaryRequest]) (*connect.Response[v1.BrandDealServiceGetSummaryResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	deal, err := h.svc.store.GetBrandDeal(ctx, wsID, req.Msg.DealId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.BrandDealServiceGetSummaryResponse{Deal: toProtoBrandDeal(deal)}), nil
}

func (h *BrandDealHandler) UpdateDeliverable(ctx context.Context, req *connect.Request[v1.UpdateDeliverableRequest]) (*connect.Response[v1.UpdateDeliverableResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	deal, err := h.svc.UpdateDeliverable(ctx, wsID, req.Msg.DealId, req.Msg.Deliverables, req.Msg.ProofPublishItemId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.UpdateDeliverableResponse{Deal: toProtoBrandDeal(deal)}), nil
}

func (h *BrandDealHandler) UpdatePayment(ctx context.Context, req *connect.Request[v1.UpdatePaymentRequest]) (*connect.Response[v1.UpdatePaymentResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	deal, err := h.svc.UpdatePayment(ctx, wsID, req.Msg.DealId, req.Msg.AmountPaid, req.Msg.SettlementReference)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.UpdatePaymentResponse{Deal: toProtoBrandDeal(deal)}), nil
}

func (h *BrandDealHandler) ListContractTemplates(ctx context.Context, req *connect.Request[v1.ListContractTemplatesRequest]) (*connect.Response[v1.ListContractTemplatesResponse], error) {
	_, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	templates, err := h.svc.store.ListContractTemplates(ctx)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoTemplates := make([]*v1.ContractTemplate, len(templates))
	for i, tmpl := range templates {
		protoTemplates[i] = &v1.ContractTemplate{
			TemplateId:      tmpl.TemplateID,
			Title:           tmpl.Title,
			Description:     tmpl.Description,
			DefaultTerms:    tmpl.DefaultTerms,
			Version:         tmpl.Version,
			SourceArticleId: tmpl.SourceArticleID,
			BodyMarkdown:    tmpl.BodyMarkdown,
			Disclaimer:      tmpl.Disclaimer,
		}
	}
	return connect.NewResponse(&v1.ListContractTemplatesResponse{
		Templates:  protoTemplates,
		Disclaimer: "Tài liệu mẫu mang tính chất tham khảo dự thảo hợp đồng. Creativanta không cung cấp tư vấn pháp lý hay dịch vụ chữ ký số điện tử. Vui lòng tham khảo ý kiến luật sư trước khi ký kết.",
	}), nil
}

func (h *BrandDealHandler) AttachContract(ctx context.Context, req *connect.Request[v1.AttachContractRequest]) (*connect.Response[v1.AttachContractResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	deal, err := h.svc.AttachContract(ctx, wsID, req.Msg.DealId, req.Msg.EvidenceId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.AttachContractResponse{Deal: toProtoBrandDeal(deal)}), nil
}

// ----------------------------------------------------------------------------
// SponsorInquiryHandler
// ----------------------------------------------------------------------------

type SponsorInquiryHandler struct {
	commercev1connect.UnimplementedSponsorInquiryServiceHandler
	svc *Service
}

func NewSponsorInquiryHandler(svc *Service) *SponsorInquiryHandler {
	return &SponsorInquiryHandler{svc: svc}
}

func (h *SponsorInquiryHandler) ListInquiries(ctx context.Context, req *connect.Request[v1.ListInquiriesRequest]) (*connect.Response[v1.ListInquiriesResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	inqs, err := h.svc.store.ListInquiries(ctx, wsID)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoInqs := make([]*v1.SponsorInquiry, 0, len(inqs))
	for _, inq := range inqs {
		protoInqs = append(protoInqs, &v1.SponsorInquiry{
			InquiryId:       inq.InquiryID,
			WorkspaceId:     inq.WorkspaceID,
			BrandName:       inq.BrandName,
			ContactEmail:    inq.ContactEmail,
			Message:         inq.Message,
			EstimatedBudget: inq.EstimatedBudget,
			Status:          inq.Status,
			ThreadId:        inq.ThreadID,
			ReceivedAt:      timestamppb.New(inq.ReceivedAt),
		})
	}
	return connect.NewResponse(&v1.ListInquiriesResponse{Inquiries: protoInqs}), nil
}

func (h *SponsorInquiryHandler) Accept(ctx context.Context, req *connect.Request[v1.SponsorInquiryServiceAcceptRequest]) (*connect.Response[v1.SponsorInquiryServiceAcceptResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	inq, err := h.svc.store.GetInquiry(ctx, wsID, req.Msg.InquiryId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	_ = h.svc.store.UpdateInquiryStatus(ctx, wsID, req.Msg.InquiryId, "accepted")
	inq.Status = "accepted"

	// Create deal linked to inquiry thread
	deal := &BrandDeal{
		WorkspaceID:     wsID,
		BrandName:       inq.BrandName,
		ContactEmail:    inq.ContactEmail,
		Value:           req.Msg.AgreedValue,
		InquiryThreadID: inq.ThreadID,
		DealType:        BrandDealTypeSponsoredPost,
	}
	createdDeal, _ := h.svc.CreateBrandDeal(ctx, deal)

	return connect.NewResponse(&v1.SponsorInquiryServiceAcceptResponse{
		Inquiry: &v1.SponsorInquiry{
			InquiryId:       inq.InquiryID,
			WorkspaceId:     inq.WorkspaceID,
			BrandName:       inq.BrandName,
			ContactEmail:    inq.ContactEmail,
			Message:         inq.Message,
			EstimatedBudget: inq.EstimatedBudget,
			Status:          inq.Status,
			ThreadId:        inq.ThreadID,
		},
		Deal: toProtoBrandDeal(createdDeal),
	}), nil
}

func (h *SponsorInquiryHandler) Decline(ctx context.Context, req *connect.Request[v1.SponsorInquiryServiceDeclineRequest]) (*connect.Response[v1.SponsorInquiryServiceDeclineResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	inq, err := h.svc.store.GetInquiry(ctx, wsID, req.Msg.InquiryId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	_ = h.svc.store.UpdateInquiryStatus(ctx, wsID, req.Msg.InquiryId, "declined")
	inq.Status = "declined"
	return connect.NewResponse(&v1.SponsorInquiryServiceDeclineResponse{
		Inquiry: &v1.SponsorInquiry{
			InquiryId: inq.InquiryID,
			Status:    inq.Status,
		},
	}), nil
}

func (h *SponsorInquiryHandler) Flag(ctx context.Context, req *connect.Request[v1.SponsorInquiryServiceFlagRequest]) (*connect.Response[v1.SponsorInquiryServiceFlagResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	inq, err := h.svc.store.GetInquiry(ctx, wsID, req.Msg.InquiryId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	_ = h.svc.store.UpdateInquiryStatus(ctx, wsID, req.Msg.InquiryId, "flagged")
	inq.Status = "flagged"
	return connect.NewResponse(&v1.SponsorInquiryServiceFlagResponse{
		Inquiry: &v1.SponsorInquiry{
			InquiryId: inq.InquiryID,
			Status:    inq.Status,
		},
	}), nil
}

func (h *SponsorInquiryHandler) GetStats(ctx context.Context, req *connect.Request[v1.SponsorInquiryServiceGetStatsRequest]) (*connect.Response[v1.SponsorInquiryServiceGetStatsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	inqs, _ := h.svc.store.ListInquiries(ctx, wsID)
	var pending, converted, declined int32
	for _, inq := range inqs {
		switch inq.Status {
		case "pending":
			pending++
		case "accepted":
			converted++
		case "declined":
			declined++
		}
	}
	return connect.NewResponse(&v1.SponsorInquiryServiceGetStatsResponse{
		TotalInquiries:     int32(len(inqs)),
		PendingInquiries:   pending,
		ConvertedInquiries: converted,
		DeclinedInquiries:  declined,
	}), nil
}

func (h *SponsorInquiryHandler) Submit(ctx context.Context, req *connect.Request[v1.SponsorInquiryServiceSubmitRequest]) (*connect.Response[v1.SponsorInquiryServiceSubmitResponse], error) {
	// Acceptance Target 3: If media_kit_id is provided, resolve target workspace server-side
	// without accepting public caller's workspace_id and without leaking private workspace identity.
	if req.Msg.MediaKitId != "" {
		inq, receipt, err := h.svc.SubmitSponsorInquiry(ctx, req.Msg.MediaKitId, req.Msg.BrandName, req.Msg.ContactEmail, req.Msg.Message, req.Msg.ProposedBudget, req.Msg.ChallengeToken, req.Msg.IdempotencyKey)
		if err != nil {
			return nil, MapErrorToConnect(err)
		}
		return connect.NewResponse(&v1.SponsorInquiryServiceSubmitResponse{
			Accepted:          true,
			InquiryId:         inq.InquiryID,
			SubmissionReceipt: receipt,
			Status:            "received",
		}), nil
	}

	inq := &SponsorInquiry{
		InquiryID:       newUUID(),
		WorkspaceID:     req.Msg.WorkspaceId,
		BrandName:       req.Msg.BrandName,
		ContactEmail:    req.Msg.ContactEmail,
		Message:         req.Msg.Message,
		EstimatedBudget: req.Msg.ProposedBudget,
		Status:          "pending",
		ThreadID:        newUUID(),
		ReceivedAt:      h.svc.nowFunc(),
	}
	_ = h.svc.store.CreateInquiry(ctx, inq)
	return connect.NewResponse(&v1.SponsorInquiryServiceSubmitResponse{
		Accepted:          true,
		InquiryId:         inq.InquiryID,
		SubmissionReceipt: "rec_" + inq.InquiryID,
		Status:            "received",
	}), nil
}

// ----------------------------------------------------------------------------
// RevenueTrackerHandler
// ----------------------------------------------------------------------------

type RevenueTrackerHandler struct {
	commercev1connect.UnimplementedRevenueTrackerServiceHandler
	svc *Service
}

func NewRevenueTrackerHandler(svc *Service) *RevenueTrackerHandler {
	return &RevenueTrackerHandler{svc: svc}
}

func (h *RevenueTrackerHandler) GetPerContent(ctx context.Context, req *connect.Request[v1.GetPerContentRequest]) (*connect.Response[v1.GetPerContentResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	metrics, err := h.svc.GetContentMetrics(ctx, wsID, req.Msg.Platform)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoMetrics := make([]*v1.ContentROIMetric, 0, len(metrics))
	for _, m := range metrics {
		protoMetrics = append(protoMetrics, toProtoContentMetric(&m))
	}
	return connect.NewResponse(&v1.GetPerContentResponse{Metrics: protoMetrics}), nil
}

func (h *RevenueTrackerHandler) GetRPMTrends(ctx context.Context, req *connect.Request[v1.GetRPMTrendsRequest]) (*connect.Response[v1.GetRPMTrendsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	points, avg, alert, err := h.svc.GetRPMTrends(ctx, wsID, req.Msg.Platform, req.Msg.Periods)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoPoints := make([]*v1.RPMTrendPoint, 0, len(points))
	for _, p := range points {
		protoPoints = append(protoPoints, &v1.RPMTrendPoint{
			PeriodLabel:        p.PeriodLabel,
			Platform:           p.Platform,
			Rpm:                p.RPM,
			RpmIsUndefined:     p.RPMIsUndefined,
			Views:              p.Views,
			Revenue:            p.Revenue,
			ChangePercent:      p.ChangePercent,
			DropAlertTriggered: p.DropAlertTriggered,
		})
	}
	return connect.NewResponse(&v1.GetRPMTrendsResponse{
		TrendPoints: protoPoints,
		AverageRpm:  avg,
		AlertActive: alert,
	}), nil
}

func (h *RevenueTrackerHandler) GetROI(ctx context.Context, req *connect.Request[v1.GetROIRequest]) (*connect.Response[v1.GetROIResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	metric, err := h.svc.store.GetContentMetric(ctx, wsID, req.Msg.ContentId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.GetROIResponse{Metric: toProtoContentMetric(metric)}), nil
}

func (h *RevenueTrackerHandler) GetTopPerformers(ctx context.Context, req *connect.Request[v1.GetTopPerformersRequest]) (*connect.Response[v1.GetTopPerformersResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	metrics, err := h.svc.GetContentMetrics(ctx, wsID, "")
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	protoMetrics := make([]*v1.ContentROIMetric, 0, len(metrics))
	for _, m := range metrics {
		protoMetrics = append(protoMetrics, toProtoContentMetric(&m))
	}
	return connect.NewResponse(&v1.GetTopPerformersResponse{TopPerformers: protoMetrics}), nil
}

// ----------------------------------------------------------------------------
// TaxReportHandler
// ----------------------------------------------------------------------------

type TaxReportHandler struct {
	commercev1connect.UnimplementedTaxReportServiceHandler
	svc *Service
}

func NewTaxReportHandler(svc *Service) *TaxReportHandler {
	return &TaxReportHandler{svc: svc}
}

func (h *TaxReportHandler) GetReport(ctx context.Context, req *connect.Request[v1.TaxReportServiceGetReportRequest]) (*connect.Response[v1.TaxReportServiceGetReportResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	period := TaxReportPeriodMonthly
	if req.Msg.Period == v1.TaxReportPeriod_TAX_REPORT_PERIOD_QUARTERLY {
		period = TaxReportPeriodQuarterly
	} else if req.Msg.Period == v1.TaxReportPeriod_TAX_REPORT_PERIOD_YEARLY {
		period = TaxReportPeriodYearly
	}
	rep, _, _, err := h.svc.GenerateTaxReport(ctx, wsID, period, req.Msg.Year, req.Msg.PeriodNumber, TaxReportFormatXLSX)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.TaxReportServiceGetReportResponse{Summary: toProtoTaxReportSummary(rep)}), nil
}

func (h *TaxReportHandler) ExportTaxReport(ctx context.Context, req *connect.Request[v1.ExportTaxReportRequest]) (*connect.Response[v1.ExportTaxReportResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	period := TaxReportPeriodMonthly
	if req.Msg.Period == v1.TaxReportPeriod_TAX_REPORT_PERIOD_QUARTERLY {
		period = TaxReportPeriodQuarterly
	} else if req.Msg.Period == v1.TaxReportPeriod_TAX_REPORT_PERIOD_YEARLY {
		period = TaxReportPeriodYearly
	}
	fmtType := TaxReportFormatXLSX
	if req.Msg.Format == v1.TaxReportFormat_TAX_REPORT_FORMAT_PDF {
		fmtType = TaxReportFormatPDF
	} else if req.Msg.Format == v1.TaxReportFormat_TAX_REPORT_FORMAT_CSV {
		fmtType = TaxReportFormatCSV
	}

	rep, data, fileName, err := h.svc.GenerateTaxReport(ctx, wsID, period, req.Msg.Year, req.Msg.PeriodNumber, fmtType)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}
	return connect.NewResponse(&v1.ExportTaxReportResponse{
		Summary:    toProtoTaxReportSummary(rep),
		ReportData: data,
		FileName:   fileName,
	}), nil
}

// ----------------------------------------------------------------------------
// Model -> Proto Helpers
// ----------------------------------------------------------------------------

func toProtoLinkInBioPage(p *LinkInBioPage) *v1.LinkInBioPage {
	if p == nil {
		return nil
	}
	items := make([]*v1.LinkItem, 0, len(p.Items))
	for _, it := range p.Items {
		items = append(items, toProtoLinkItem(&it))
	}
	var st v1.LinkInBioPageStatus
	switch p.Status {
	case LinkInBioPageStatusActive:
		st = v1.LinkInBioPageStatus_LINK_IN_BIO_PAGE_STATUS_ACTIVE
	case LinkInBioPageStatusSuspended:
		st = v1.LinkInBioPageStatus_LINK_IN_BIO_PAGE_STATUS_SUSPENDED
	case LinkInBioPageStatusArchived:
		st = v1.LinkInBioPageStatus_LINK_IN_BIO_PAGE_STATUS_ARCHIVED
	}
	return &v1.LinkInBioPage{
		PageId:               p.PageID,
		WorkspaceId:          p.WorkspaceID,
		Slug:                 p.Slug,
		Title:                p.Title,
		Bio:                  p.Bio,
		AvatarUrl:            p.AvatarURL,
		Theme:                p.Theme,
		CustomDomain:         p.CustomDomain,
		CustomDomainVerified: p.CustomDomainVerified,
		AnalyticsEnabled:     p.AnalyticsEnabled,
		TotalViews:           p.TotalViews,
		Status:               st,
		CreatedAt:            timestamppb.New(p.CreatedAt),
		UpdatedAt:            timestamppb.New(p.UpdatedAt),
		Items:                items,
	}
}

func toProtoLinkItem(it *LinkItem) *v1.LinkItem {
	if it == nil {
		return nil
	}
	var linkType v1.LinkType
	switch it.LinkType {
	case LinkTypeURL:
		linkType = v1.LinkType_LINK_TYPE_URL
	case LinkTypeProduct:
		linkType = v1.LinkType_LINK_TYPE_PRODUCT
	case LinkTypeVideo:
		linkType = v1.LinkType_LINK_TYPE_VIDEO
	case LinkTypeSocial:
		linkType = v1.LinkType_LINK_TYPE_SOCIAL
	case LinkTypeDownload:
		linkType = v1.LinkType_LINK_TYPE_DOWNLOAD
	case LinkTypeEmail:
		linkType = v1.LinkType_LINK_TYPE_EMAIL
	default:
		linkType = v1.LinkType_LINK_TYPE_URL
	}

	var scanStatus v1.LinkSecurityScanStatus
	switch it.ScanStatus {
	case LinkSecurityScanStatusSafe:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_SAFE
	case LinkSecurityScanStatusSuspicious:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_SUSPICIOUS
	case LinkSecurityScanStatusPhishing:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_PHISHING
	case LinkSecurityScanStatusMalware:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_MALWARE
	default:
		scanStatus = v1.LinkSecurityScanStatus_LINK_SECURITY_SCAN_STATUS_SAFE
	}

	return &v1.LinkItem{
		LinkItemId:        it.LinkItemID,
		PageId:            it.PageID,
		WorkspaceId:       it.WorkspaceID,
		LinkType:          linkType,
		Label:             it.Label,
		Url:               it.URL,
		Icon:              it.Icon,
		ThumbnailUrl:      it.ThumbnailURL,
		Position:          it.Position,
		Clicks:            it.Clicks,
		IsActive:          it.IsActive,
		ScanStatus:        scanStatus,
		PhishingDetected:  it.PhishingDetected,
		ScanThreatDetails: it.ScanThreatDetails,
		CreatedAt:         timestamppb.New(it.CreatedAt),
	}
}

func toProtoMediaKit(k *MediaKit) *v1.MediaKit {
	if k == nil {
		return nil
	}
	var dirSt v1.MediaKitDirectoryStatus
	switch k.DirectoryStatus {
	case MediaKitDirectoryStatusHidden:
		dirSt = v1.MediaKitDirectoryStatus_MEDIA_KIT_DIRECTORY_STATUS_HIDDEN
	case MediaKitDirectoryStatusPendingReview:
		dirSt = v1.MediaKitDirectoryStatus_MEDIA_KIT_DIRECTORY_STATUS_PENDING_REVIEW
	case MediaKitDirectoryStatusPublished:
		dirSt = v1.MediaKitDirectoryStatus_MEDIA_KIT_DIRECTORY_STATUS_PUBLISHED
	}
	res := &v1.MediaKit{
		MediaKitId:            k.MediaKitID,
		WorkspaceId:           k.WorkspaceID,
		Template:              k.Template,
		SectionsJson:          k.SectionsJSON,
		BrandProfileId:        k.BrandProfileID,
		ShareUrl:              k.ShareURL,
		DirectoryOptIn:        k.DirectoryOptIn,
		DirectoryStatus:       dirSt,
		DirectoryProfileJson:  k.DirectoryProfileJSON,
		GenerationCreditsUsed: k.GenerationCreditsUsed,
		CreatedAt:             timestamppb.New(k.CreatedAt),
		UpdatedAt:             timestamppb.New(k.UpdatedAt),
	}
	if k.DirectoryConsentedAt != nil {
		res.DirectoryConsentedAt = timestamppb.New(*k.DirectoryConsentedAt)
	}
	if k.LastGeneratedAt != nil {
		res.LastGeneratedAt = timestamppb.New(*k.LastGeneratedAt)
	}
	return res
}

func toProtoRateCard(c *RateCard) *v1.RateCard {
	if c == nil {
		return nil
	}
	items := make([]*v1.RateCardItem, 0, len(c.Items))
	for _, it := range c.Items {
		items = append(items, toProtoRateCardItem(&it))
	}
	res := &v1.RateCard{
		RateCardId:  c.RateCardID,
		WorkspaceId: c.WorkspaceID,
		Currency:    c.Currency,
		CustomNote:  c.CustomNote,
		Items:       items,
		CreatedAt:   timestamppb.New(c.CreatedAt),
		UpdatedAt:   timestamppb.New(c.UpdatedAt),
	}
	if c.AISuggestedAt != nil {
		res.AiSuggestedAt = timestamppb.New(*c.AISuggestedAt)
	}
	return res
}

func toProtoRateCardItem(it *RateCardItem) *v1.RateCardItem {
	if it == nil {
		return nil
	}
	return &v1.RateCardItem{
		ItemId:           it.ItemID,
		RateCardId:       it.RateCardID,
		WorkspaceId:      it.WorkspaceID,
		ServiceType:      it.ServiceType,
		PriceMin:         it.PriceMin,
		PriceMax:         it.PriceMax,
		AiSuggestedPrice: it.AISuggestedPrice,
		Description:      it.Description,
		DeliveryTime:     it.DeliveryTime,
		Position:         it.Position,
		CreatedAt:        timestamppb.New(it.CreatedAt),
		UpdatedAt:        timestamppb.New(it.UpdatedAt),
	}
}

func toProtoBrandDeal(d *BrandDeal) *v1.BrandDeal {
	if d == nil {
		return nil
	}
	var dealType v1.BrandDealType
	switch d.DealType {
	case BrandDealTypeSponsoredPost:
		dealType = v1.BrandDealType_BRAND_DEAL_TYPE_SPONSORED_POST
	case BrandDealTypeProductReview:
		dealType = v1.BrandDealType_BRAND_DEAL_TYPE_PRODUCT_REVIEW
	case BrandDealTypeAmbassador:
		dealType = v1.BrandDealType_BRAND_DEAL_TYPE_AMBASSADOR
	case BrandDealTypeAffiliate:
		dealType = v1.BrandDealType_BRAND_DEAL_TYPE_AFFILIATE
	default:
		dealType = v1.BrandDealType_BRAND_DEAL_TYPE_CUSTOM
	}

	var st v1.BrandDealStatus
	switch d.Status {
	case BrandDealStatusNegotiating:
		st = v1.BrandDealStatus_BRAND_DEAL_STATUS_NEGOTIATING
	case BrandDealStatusAgreed:
		st = v1.BrandDealStatus_BRAND_DEAL_STATUS_AGREED
	case BrandDealStatusInProgress:
		st = v1.BrandDealStatus_BRAND_DEAL_STATUS_IN_PROGRESS
	case BrandDealStatusDelivered:
		st = v1.BrandDealStatus_BRAND_DEAL_STATUS_DELIVERED
	case BrandDealStatusPaid:
		st = v1.BrandDealStatus_BRAND_DEAL_STATUS_PAID
	case BrandDealStatusCompleted:
		st = v1.BrandDealStatus_BRAND_DEAL_STATUS_COMPLETED
	case BrandDealStatusCancelled:
		st = v1.BrandDealStatus_BRAND_DEAL_STATUS_CANCELLED
	default:
		st = v1.BrandDealStatus_BRAND_DEAL_STATUS_NEGOTIATING
	}

	return &v1.BrandDeal{
		DealId:              d.DealID,
		WorkspaceId:         d.WorkspaceID,
		BrandName:           d.BrandName,
		ContactEmail:        d.ContactEmail,
		DealType:            dealType,
		Value:               d.Value,
		Currency:            d.Currency,
		Status:              st,
		Deadline:            d.Deadline,
		Deliverables:        d.Deliverables,
		ContractEvidenceIds: d.ContractEvidenceIDs,
		InquiryThreadId:     d.InquiryThreadID,
		Notes:               d.Notes,
		CreatedAt:           timestamppb.New(d.CreatedAt),
		UpdatedAt:           timestamppb.New(d.UpdatedAt),
	}
}

func toProtoContentMetric(m *ContentROIMetric) *v1.ContentROIMetric {
	if m == nil {
		return nil
	}
	return &v1.ContentROIMetric{
		ContentId:              m.ContentID,
		Title:                  m.Title,
		Platform:               m.Platform,
		Views:                  m.Views,
		Engagement:             m.Engagement,
		LinkClicks:             m.LinkClicks,
		OrdersAttributed:       m.OrdersAttributed,
		RevenueAttributed:      m.RevenueAttributed,
		CostToProduce:          m.CostToProduce,
		RoiPercentage:          m.ROIPercentage,
		Rpm:                    m.RPM,
		RpmIsUndefined:         m.RPMIsUndefined,
		ProductionMode:         m.ProductionMode,
		IsDerivative:           m.IsDerivative,
		SourceContentId:        m.SourceContentID,
		DerivativeCount:        m.DerivativeCount,
		DerivativeTotalRevenue: m.DerivativeTotalRevenue,
		PublishedAt:            timestamppb.New(m.PublishedAt),
	}
}

func toProtoTaxReportSummary(s *TaxReportSummary) *v1.TaxReportSummary {
	if s == nil {
		return nil
	}
	var period v1.TaxReportPeriod
	switch s.Period {
	case TaxReportPeriodMonthly:
		period = v1.TaxReportPeriod_TAX_REPORT_PERIOD_MONTHLY
	case TaxReportPeriodQuarterly:
		period = v1.TaxReportPeriod_TAX_REPORT_PERIOD_QUARTERLY
	case TaxReportPeriodYearly:
		period = v1.TaxReportPeriod_TAX_REPORT_PERIOD_YEARLY
	}
	var fmtType v1.TaxReportFormat
	switch s.Format {
	case TaxReportFormatPDF:
		fmtType = v1.TaxReportFormat_TAX_REPORT_FORMAT_PDF
	case TaxReportFormatXLSX:
		fmtType = v1.TaxReportFormat_TAX_REPORT_FORMAT_XLSX
	case TaxReportFormatCSV:
		fmtType = v1.TaxReportFormat_TAX_REPORT_FORMAT_CSV
	}
	return &v1.TaxReportSummary{
		ReportId:             s.ReportID,
		WorkspaceId:          s.WorkspaceID,
		Period:               period,
		Year:                 s.TaxYear,
		PeriodNumber:         s.PeriodNumber,
		TotalRevenue:         s.TotalRevenue,
		AffiliateRevenue:     s.AffiliateRevenue,
		SponsorshipRevenue:   s.SponsorshipRevenue,
		ProductSalesRevenue:  s.ProductSalesRevenue,
		AiCreditExpenses:     s.AICreditExpenses,
		SubscriptionExpenses: s.SubscriptionExpenses,
		NetIncomeBeforeTax:   s.NetIncomeBeforeTax,
		Currency:             s.Currency,
		Format:               fmtType,
		DownloadUrl:          s.DownloadURL,
		GeneratedAt:          timestamppb.New(s.GeneratedAt),
	}
}

// ----------------------------------------------------------------------------
// CreatorDirectoryHandler (Public Opt-In Creator Directory per §27.2)
// ----------------------------------------------------------------------------

type CreatorDirectoryHandler struct {
	commercev1connect.UnimplementedCreatorDirectoryServiceHandler
	svc *Service
}

func NewCreatorDirectoryHandler(svc *Service) *CreatorDirectoryHandler {
	return &CreatorDirectoryHandler{svc: svc}
}

func (h *CreatorDirectoryHandler) Search(ctx context.Context, req *connect.Request[v1.CreatorDirectoryServiceSearchRequest]) (*connect.Response[v1.CreatorDirectoryServiceSearchResponse], error) {
	// Public endpoint - search only explicitly consented published snapshots
	query := req.Msg.Query
	if len(query) > 120 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("search query cannot exceed 120 characters"))
	}

	pageSize := req.Msg.PageSize
	if pageSize <= 0 {
		pageSize = 20
	}
	if pageSize > 20 {
		pageSize = 20
	}

	entries, nextToken, hasMore, total, err := h.svc.store.SearchDirectory(ctx, query, req.Msg.Categories, req.Msg.Languages, int(pageSize), req.Msg.PageToken)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	protoEntries := make([]*v1.CreatorDirectoryEntry, len(entries))
	for i, e := range entries {
		protoEntries[i] = toProtoDirectoryEntry(e)
	}

	return connect.NewResponse(&v1.CreatorDirectoryServiceSearchResponse{
		Entries:       protoEntries,
		NextPageToken: nextToken,
		HasMore:       hasMore,
		TotalCount:    total,
	}), nil
}

func (h *CreatorDirectoryHandler) Get(ctx context.Context, req *connect.Request[v1.CreatorDirectoryServiceGetRequest]) (*connect.Response[v1.CreatorDirectoryServiceGetResponse], error) {
	if strings.TrimSpace(req.Msg.MediaKitId) == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("media_kit_id is required"))
	}

	entry, err := h.svc.store.GetDirectoryEntry(ctx, req.Msg.MediaKitId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&v1.CreatorDirectoryServiceGetResponse{
		Entry: toProtoDirectoryEntry(*entry),
	}), nil
}

func toProtoDirectoryEntry(e CreatorDirectoryEntry) *v1.CreatorDirectoryEntry {
	rates := make([]*v1.PublicRateItem, len(e.Profile.PublicRates))
	for i, r := range e.Profile.PublicRates {
		rates[i] = &v1.PublicRateItem{
			ServiceType: r.ServiceType,
			Amount:      r.Amount,
			Currency:    r.Currency,
		}
	}

	return &v1.CreatorDirectoryEntry{
		MediaKitId: e.MediaKitID,
		Profile: &v1.PublicCreatorProfile{
			DisplayName:   e.Profile.DisplayName,
			Bio:           e.Profile.Bio,
			Categories:    e.Profile.Categories,
			Languages:     e.Profile.Languages,
			PortfolioUrls: e.Profile.PortfolioURLs,
			PublicRates:   rates,
		},
		PublishedAt: timestamppb.New(e.PublishedAt),
	}
}

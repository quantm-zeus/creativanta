package livecommerce

import (
	"context"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
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

// LiveCommerceHandler implements commercev1connect.LiveCommerceServiceHandler.
type LiveCommerceHandler struct {
	svc *Service
}

func NewLiveCommerceHandler(svc *Service) *LiveCommerceHandler {
	return &LiveCommerceHandler{svc: svc}
}

var _ commercev1connect.LiveCommerceServiceHandler = (*LiveCommerceHandler)(nil)

func (h *LiveCommerceHandler) CreateSession(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceCreateSessionRequest]) (*connect.Response[commercev1.LiveCommerceServiceCreateSessionResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	var plannedStart *time.Time
	if msg.PlannedStartAt != nil {
		t := msg.PlannedStartAt.AsTime()
		plannedStart = &t
	}

	var rosItems []RunOfShowItem
	for _, it := range msg.RunOfShow {
		var execAt *time.Time
		if it.ExecutedAt != nil {
			t := it.ExecutedAt.AsTime()
			execAt = &t
		}
		rosItems = append(rosItems, RunOfShowItem{
			TimeOffsetMin: it.TimeOffsetMin,
			Type:          it.Type,
			Title:         it.Title,
			ProductID:     it.ProductId,
			OfferID:       it.OfferId,
			Notes:         it.Notes,
			DurationMin:   it.DurationMin,
			Executed:      it.Executed,
			ExecutedAt:    execAt,
			CueCardIDs:    it.CueCardIds,
		})
	}

	meta := make(map[string]any)
	for k, v := range msg.Metadata {
		meta[k] = v
	}

	session, isDup, err := h.svc.CreateSession(ctx, wsID, idempotencyKey, msg.Title, msg.Platform, msg.ConnectedAccountId, plannedStart, rosItems, meta)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceCreateSessionResponse{
		Session:     toProtoLiveSession(session),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) Get(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceGetRequest]) (*connect.Response[commercev1.LiveCommerceServiceGetResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}

	session, cues, hls, err := h.svc.GetSession(ctx, wsID, msg.SessionId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	var protoCues []*commercev1.CueCard
	for _, c := range cues {
		protoCues = append(protoCues, toProtoCueCard(c))
	}

	var protoHls []*commercev1.Highlight
	for _, hl := range hls {
		protoHls = append(protoHls, toProtoHighlight(hl))
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceGetResponse{
		Session:    toProtoLiveSession(session),
		CueCards:   protoCues,
		Highlights: protoHls,
	}), nil
}

func (h *LiveCommerceHandler) List(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceListRequest]) (*connect.Response[commercev1.LiveCommerceServiceListResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}

	limit := 20
	offset := 0
	if msg.Pagination != nil {
		if msg.Pagination.PageSize > 0 {
			limit = int(msg.Pagination.PageSize)
		}
	}

	sessions, total, err := h.svc.ListSessions(ctx, wsID, msg.Status, msg.Platform, limit, offset)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	var protoSessions []*commercev1.LiveSession
	for _, s := range sessions {
		protoSessions = append(protoSessions, toProtoLiveSession(s))
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceListResponse{
		Sessions: protoSessions,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(sessions)) < total,
		},
	}), nil
}

func (h *LiveCommerceHandler) StartSession(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceStartSessionRequest]) (*connect.Response[commercev1.LiveCommerceServiceStartSessionResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	session, isDup, err := h.svc.StartSession(ctx, wsID, msg.SessionId, idempotencyKey)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceStartSessionResponse{
		Session:     toProtoLiveSession(session),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) EndSession(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceEndSessionRequest]) (*connect.Response[commercev1.LiveCommerceServiceEndSessionResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	session, summary, isDup, err := h.svc.EndSession(ctx, wsID, msg.SessionId, idempotencyKey)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceEndSessionResponse{
		Session:     toProtoLiveSession(session),
		Summary:     toProtoProofSummary(summary),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) PauseSession(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServicePauseSessionRequest]) (*connect.Response[commercev1.LiveCommerceServicePauseSessionResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	session, isDup, err := h.svc.PauseSession(ctx, wsID, msg.SessionId, idempotencyKey)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServicePauseSessionResponse{
		Session:     toProtoLiveSession(session),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) ResumeSession(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceResumeSessionRequest]) (*connect.Response[commercev1.LiveCommerceServiceResumeSessionResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	session, isDup, err := h.svc.ResumeSession(ctx, wsID, msg.SessionId, idempotencyKey)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceResumeSessionResponse{
		Session:     toProtoLiveSession(session),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) AddCue(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceAddCueRequest]) (*connect.Response[commercev1.LiveCommerceServiceAddCueResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	cue, isDup, err := h.svc.AddCue(ctx, wsID, msg.SessionId, idempotencyKey, msg.CueType, msg.Title, msg.Body, msg.PinnedProductId, msg.PinnedOfferId, msg.DisplayOrder)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceAddCueResponse{
		CueCard:     toProtoCueCard(cue),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) RemoveCue(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceRemoveCueRequest]) (*connect.Response[commercev1.LiveCommerceServiceRemoveCueResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	if err := h.svc.RemoveCue(ctx, wsID, msg.SessionId, msg.CueCardId); err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceRemoveCueResponse{
		Success: true,
	}), nil
}

func (h *LiveCommerceHandler) TriggerCue(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceTriggerCueRequest]) (*connect.Response[commercev1.LiveCommerceServiceTriggerCueResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	cue, isDup, err := h.svc.TriggerCue(ctx, wsID, msg.SessionId, msg.CueCardId, idempotencyKey)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceTriggerCueResponse{
		CueCard:     toProtoCueCard(cue),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) HighlightProduct(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceHighlightProductRequest]) (*connect.Response[commercev1.LiveCommerceServiceHighlightProductResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	isDup, err := h.svc.HighlightProduct(ctx, wsID, msg.SessionId, msg.ProductId, msg.OfferId, idempotencyKey, msg.IsPinned, msg.ActiveTimeOffsetSeconds)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceHighlightProductResponse{
		SessionId:       msg.SessionId,
		PinnedProductId: msg.ProductId,
		PinnedOfferId:   msg.OfferId,
		IsPinned:        msg.IsPinned,
		IsDuplicate:     isDup,
	}), nil
}

func (h *LiveCommerceHandler) GetAnalytics(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceGetAnalyticsRequest]) (*connect.Response[commercev1.LiveCommerceServiceGetAnalyticsResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}

	metrics, orders, err := h.svc.GetAnalytics(ctx, wsID, msg.SessionId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	var protoOrders []*commercev1.TraceableOrderLink
	for _, o := range orders {
		protoOrders = append(protoOrders, toProtoTraceableOrder(o))
	}

	rev, _ := metrics.RevenueDuringLive.ToProtoMoney(metrics.RevenueCurrency, false)

	return connect.NewResponse(&commercev1.LiveCommerceServiceGetAnalyticsResponse{
		SessionId:       msg.SessionId,
		Metrics:         toProtoMetricsSnapshot(metrics),
		OrdersCount:     metrics.OrdersDuringLive,
		TotalRevenue:    rev,
		TraceableOrders: protoOrders,
	}), nil
}

func (h *LiveCommerceHandler) UpdateRunOfShow(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceUpdateRunOfShowRequest]) (*connect.Response[commercev1.LiveCommerceServiceUpdateRunOfShowResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	var ros []RunOfShowItem
	for _, it := range msg.Items {
		var execAt *time.Time
		if it.ExecutedAt != nil {
			t := it.ExecutedAt.AsTime()
			execAt = &t
		}
		ros = append(ros, RunOfShowItem{
			TimeOffsetMin: it.TimeOffsetMin,
			Type:          it.Type,
			Title:         it.Title,
			ProductID:     it.ProductId,
			OfferID:       it.OfferId,
			Notes:         it.Notes,
			DurationMin:   it.DurationMin,
			Executed:      it.Executed,
			ExecutedAt:    execAt,
			CueCardIDs:    it.CueCardIds,
		})
	}

	session, isDup, err := h.svc.UpdateRunOfShow(ctx, wsID, msg.SessionId, idempotencyKey, ros)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceUpdateRunOfShowResponse{
		Session:     toProtoLiveSession(session),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) CreateHighlight(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceCreateHighlightRequest]) (*connect.Response[commercev1.LiveCommerceServiceCreateHighlightResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	hl, isDup, err := h.svc.CreateHighlight(ctx, wsID, msg.SessionId, idempotencyKey, msg.Title, msg.HighlightType, msg.Notes, msg.PinnedOfferId, msg.PinnedProductId, msg.StartOffsetSeconds, msg.EndOffsetSeconds, msg.AutoDetected, msg.EngagementScore)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceCreateHighlightResponse{
		Highlight:   toProtoHighlight(hl),
		IsDuplicate: isDup,
	}), nil
}

func (h *LiveCommerceHandler) ExtractHighlights(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceExtractHighlightsRequest]) (*connect.Response[commercev1.LiveCommerceServiceExtractHighlightsResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, "", msg.Context)
	if err != nil {
		return nil, err
	}

	idempotencyKey := ""
	if msg.Context != nil {
		idempotencyKey = msg.Context.IdempotencyKey
	}

	count, hls, assets, isDup, err := h.svc.ExtractHighlights(ctx, wsID, msg.SessionId, msg.SourceAssetId, idempotencyKey, msg.HighlightIds)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	var protoHls []*commercev1.Highlight
	for _, hl := range hls {
		protoHls = append(protoHls, toProtoHighlight(hl))
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceExtractHighlightsResponse{
		SessionId:                    msg.SessionId,
		ExtractedCount:               count,
		UpdatedHighlights:            protoHls,
		RegisteredDerivativeAssetIds: assets,
		IsDuplicate:                  isDup,
	}), nil
}

func (h *LiveCommerceHandler) GetProofSummary(ctx context.Context, req *connect.Request[commercev1.LiveCommerceServiceGetProofSummaryRequest]) (*connect.Response[commercev1.LiveCommerceServiceGetProofSummaryResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId, nil)
	if err != nil {
		return nil, err
	}

	summary, err := h.svc.GetProofSummary(ctx, wsID, msg.SessionId)
	if err != nil {
		return nil, MapErrorToConnect(err)
	}

	return connect.NewResponse(&commercev1.LiveCommerceServiceGetProofSummaryResponse{
		Summary: toProtoProofSummary(summary),
	}), nil
}

// ----------------------------------------------------------------------------
// Conversion Helpers
// ----------------------------------------------------------------------------

func toProtoLiveSession(s *LiveSession) *commercev1.LiveSession {
	if s == nil {
		return nil
	}

	var ros []*commercev1.RunOfShowItem
	for _, it := range s.RunOfShow {
		var execAt *timestamppb.Timestamp
		if it.ExecutedAt != nil {
			execAt = timestamppb.New(*it.ExecutedAt)
		}
		ros = append(ros, &commercev1.RunOfShowItem{
			TimeOffsetMin: it.TimeOffsetMin,
			Type:          it.Type,
			Title:         it.Title,
			ProductId:     it.ProductID,
			OfferId:       it.OfferID,
			Notes:         it.Notes,
			DurationMin:   it.DurationMin,
			Executed:      it.Executed,
			ExecutedAt:    execAt,
			CueCardIds:    it.CueCardIDs,
		})
	}

	meta := make(map[string]string)
	for k, v := range s.Metadata {
		meta[k] = ""
		if str, ok := v.(string); ok {
			meta[k] = str
		}
	}

	var pStart, aStart, aEnd *timestamppb.Timestamp
	if s.PlannedStartAt != nil {
		pStart = timestamppb.New(*s.PlannedStartAt)
	}
	if s.ActualStartAt != nil {
		aStart = timestamppb.New(*s.ActualStartAt)
	}
	if s.ActualEndAt != nil {
		aEnd = timestamppb.New(*s.ActualEndAt)
	}

	return &commercev1.LiveSession{
		SessionId:          s.SessionID,
		WorkspaceId:        s.WorkspaceID,
		Title:              s.Title,
		Platform:           s.Platform,
		ConnectedAccountId: s.ConnectedAccountID,
		Status:             toProtoSessionStatus(s.Status),
		PlannedStartAt:     pStart,
		ActualStartAt:      aStart,
		ActualEndAt:        aEnd,
		RunOfShow:          ros,
		MetricsSnapshot:    toProtoMetricsSnapshot(&s.MetricsSnapshot),
		Metadata:           meta,
		CreatedAt:          timestamppb.New(s.CreatedAt),
		UpdatedAt:          timestamppb.New(s.UpdatedAt),
	}
}

func toProtoSessionStatus(st SessionStatus) commercev1.LiveSessionStatus {
	switch st {
	case SessionStatusPlanned:
		return commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_PLANNED
	case SessionStatusReady:
		return commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_READY
	case SessionStatusLive:
		return commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_LIVE
	case SessionStatusPaused:
		return commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_PAUSED
	case SessionStatusEnded:
		return commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_ENDED
	case SessionStatusPostLiveProcessing:
		return commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_POST_LIVE_PROCESSING
	case SessionStatusClosed:
		return commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_CLOSED
	default:
		return commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_UNSPECIFIED
	}
}

func toProtoCueCard(c *CueCard) *commercev1.CueCard {
	if c == nil {
		return nil
	}
	var trigAt *timestamppb.Timestamp
	if c.TriggeredAt != nil {
		trigAt = timestamppb.New(*c.TriggeredAt)
	}
	return &commercev1.CueCard{
		CueCardId:       c.CueCardID,
		SessionId:       c.SessionID,
		WorkspaceId:     c.WorkspaceID,
		SegmentId:       c.SegmentID,
		CueType:         c.CueType,
		Title:           c.Title,
		Body:            c.Body,
		PinnedProductId: c.PinnedProductID,
		PinnedOfferId:   c.PinnedOfferID,
		DisplayOrder:    c.DisplayOrder,
		TriggeredAt:     trigAt,
		Status:          toProtoCueStatus(c.Status),
		CreatedAt:       timestamppb.New(c.CreatedAt),
		UpdatedAt:       timestamppb.New(c.UpdatedAt),
	}
}

func toProtoCueStatus(st CueStatus) commercev1.CueCardStatus {
	switch st {
	case CueStatusPending:
		return commercev1.CueCardStatus_CUE_CARD_STATUS_PENDING
	case CueStatusActive:
		return commercev1.CueCardStatus_CUE_CARD_STATUS_ACTIVE
	case CueStatusUsed:
		return commercev1.CueCardStatus_CUE_CARD_STATUS_USED
	case CueStatusSkipped:
		return commercev1.CueCardStatus_CUE_CARD_STATUS_SKIPPED
	default:
		return commercev1.CueCardStatus_CUE_CARD_STATUS_UNSPECIFIED
	}
}

func toProtoHighlight(h *Highlight) *commercev1.Highlight {
	if h == nil {
		return nil
	}
	return &commercev1.Highlight{
		HighlightId:        h.HighlightID,
		SessionId:          h.SessionID,
		WorkspaceId:        h.WorkspaceID,
		Title:              h.Title,
		StartOffsetSeconds: h.StartOffsetSeconds,
		EndOffsetSeconds:   h.EndOffsetSeconds,
		HighlightType:      h.HighlightType,
		AutoDetected:       h.AutoDetected,
		AssetId:            h.AssetID,
		EngagementScore:    h.EngagementScore,
		Notes:              h.Notes,
		PinnedOfferId:      h.PinnedOfferID,
		PinnedProductId:    h.PinnedProductID,
		CreatedAt:          timestamppb.New(h.CreatedAt),
		UpdatedAt:          timestamppb.New(h.UpdatedAt),
	}
}

func toProtoMetricsSnapshot(m *LiveMetricsSnapshot) *commercev1.LiveMetricsSnapshot {
	if m == nil {
		return nil
	}
	curr := m.RevenueCurrency
	if curr == "" {
		curr = "VND"
	}
	rev, _ := m.RevenueDuringLive.ToProtoMoney(curr, false)
	return &commercev1.LiveMetricsSnapshot{
		PeakViewers:       m.PeakViewers,
		AvgViewers:        m.AvgViewers,
		TotalViewers:      m.TotalViewers,
		TotalComments:     m.TotalComments,
		TotalLikes:        m.TotalLikes,
		TotalShares:       m.TotalShares,
		ProductsShown:     m.ProductsShown,
		OrdersDuringLive:  m.OrdersDuringLive,
		RevenueDuringLive: rev,
		EngagementRate:    m.EngagementRate,
	}
}

func toProtoTraceableOrder(o TraceableOrderLink) *commercev1.TraceableOrderLink {
	curr := o.Currency
	if curr == "" {
		curr = "VND"
	}
	amt, _ := o.Amount.ToProtoMoney(curr, false)
	return &commercev1.TraceableOrderLink{
		OrderId:             o.OrderID,
		ProductId:           o.ProductID,
		OfferId:             o.OfferID,
		CustomerId:          o.CustomerID,
		Amount:              amt,
		CreatedAt:           timestamppb.New(o.CreatedAt),
		ReconciliationState: o.ReconciliationState,
	}
}

func toProtoProofSummary(s *PostLiveProofSummary) *commercev1.PostLiveProofSummary {
	if s == nil {
		return nil
	}
	var protoHls []*commercev1.Highlight
	for _, hl := range s.Highlights {
		protoHls = append(protoHls, toProtoHighlight(&hl))
	}

	var protoOrders []*commercev1.TraceableOrderLink
	for _, o := range s.Orders {
		protoOrders = append(protoOrders, toProtoTraceableOrder(o))
	}

	curr := s.RevenueCurrency
	if curr == "" {
		curr = "VND"
	}
	totRev, _ := s.TotalRevenue.ToProtoMoney(curr, false)

	return &commercev1.PostLiveProofSummary{
		SummaryId:             s.SummaryID,
		SessionId:             s.SessionID,
		WorkspaceId:           s.WorkspaceID,
		SessionTitle:          s.SessionTitle,
		Platform:              s.Platform,
		Metrics:               toProtoMetricsSnapshot(&s.Metrics),
		Highlights:            protoHls,
		ExtractedClipAssetIds: s.ExtractedClipAssetIDs,
		Orders:                protoOrders,
		TotalRevenue:          totRev,
		SourceClass:           s.SourceClass,
		ProofBundleId:         s.ProofBundleID,
		GeneratedAt:           timestamppb.New(s.GeneratedAt),
	}
}

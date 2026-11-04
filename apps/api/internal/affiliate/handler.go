package affiliate

import (
	"context"
	"encoding/json"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func resolveTenant(ctx context.Context, requestedWS string) (string, error) {
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.WorkspaceID != "" {
		if requestedWS != "" && requestedWS != session.WorkspaceID && !session.InternalAdmin {
			return "", connect.NewError(connect.CodePermissionDenied, ErrLinkNotFound)
		}
		return session.WorkspaceID, nil
	}
	if requestedWS != "" {
		return requestedWS, nil
	}
	return "", connect.NewError(connect.CodeUnauthenticated, ErrLinkNotFound)
}

// ----------------------------------------------------------------------------
// AffiliateHandler
// ----------------------------------------------------------------------------

type AffiliateHandler struct {
	svc *Service
}

func NewAffiliateHandler(svc *Service) *AffiliateHandler {
	return &AffiliateHandler{svc: svc}
}

var _ commercev1connect.AffiliateServiceHandler = (*AffiliateHandler)(nil)

func (h *AffiliateHandler) CreateAffiliateLink(ctx context.Context, req *connect.Request[commercev1.CreateAffiliateLinkRequest]) (*connect.Response[commercev1.CreateAffiliateLinkResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	commRate, err := tenantdb.ParseExactDecimal(msg.CommissionRate)
	if err != nil && msg.CommissionRate != "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidCommissionRate)
	}

	var prodID, offerID, campID *string
	if msg.ProductId != "" {
		prodID = &msg.ProductId
	}
	if msg.OfferId != "" {
		offerID = &msg.OfferId
	}
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}

	var expiresAt *time.Time
	if msg.ExpiresAt != nil {
		t := msg.ExpiresAt.AsTime()
		expiresAt = &t
	}

	link := &AffiliateLink{
		WorkspaceID:    wsID,
		ProductID:      prodID,
		OfferID:        offerID,
		CampaignID:     campID,
		Platform:       msg.Platform,
		OriginalURL:    msg.OriginalUrl,
		ShortCode:      msg.CustomShortCode,
		CommissionRate: commRate,
		ExpiresAt:      expiresAt,
	}

	res, err := h.svc.CreateLink(ctx, link)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.CreateAffiliateLinkResponse{
		Link: linkToProto(res),
	}), nil
}

func (h *AffiliateHandler) GetAffiliateLink(ctx context.Context, req *connect.Request[commercev1.GetAffiliateLinkRequest]) (*connect.Response[commercev1.GetAffiliateLinkResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	link, health, err := h.svc.GetLink(ctx, wsID, req.Msg.AffiliateLinkId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	resp := &commercev1.GetAffiliateLinkResponse{
		Link: linkToProto(link),
	}
	if health != nil {
		resp.LatestHealth = healthToProto(health)
	}
	return connect.NewResponse(resp), nil
}

func (h *AffiliateHandler) ListAffiliateLinks(ctx context.Context, req *connect.Request[commercev1.ListAffiliateLinksRequest]) (*connect.Response[commercev1.ListAffiliateLinksResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var campID, platform *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}
	if msg.Platform != "" {
		platform = &msg.Platform
	}

	var state *LinkLifecycleState
	if msg.LifecycleState != commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_UNSPECIFIED {
		st := protoToLinkState(msg.LifecycleState)
		state = &st
	}

	limit := int(msg.PageSize)
	if limit <= 0 {
		limit = 20
	}

	links, total, err := h.svc.ListLinks(ctx, wsID, campID, platform, state, limit, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var pbLinks []*commercev1.AffiliateLink
	for _, l := range links {
		pbLinks = append(pbLinks, linkToProto(l))
	}

	return connect.NewResponse(&commercev1.ListAffiliateLinksResponse{
		Links:      pbLinks,
		TotalCount: int32(total),
	}), nil
}

func (h *AffiliateHandler) UpdateAffiliateLink(ctx context.Context, req *connect.Request[commercev1.UpdateAffiliateLinkRequest]) (*connect.Response[commercev1.UpdateAffiliateLinkResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var expiresAt *time.Time
	if msg.ExpiresAt != nil {
		t := msg.ExpiresAt.AsTime()
		expiresAt = &t
	}

	link, err := h.svc.UpdateLink(ctx, wsID, msg.AffiliateLinkId, msg.CommissionRate, msg.OriginalUrl, expiresAt)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.UpdateAffiliateLinkResponse{
		Link: linkToProto(link),
	}), nil
}

func (h *AffiliateHandler) DeleteAffiliateLink(ctx context.Context, req *connect.Request[commercev1.DeleteAffiliateLinkRequest]) (*connect.Response[commercev1.DeleteAffiliateLinkResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	if err := h.svc.DeleteLink(ctx, wsID, req.Msg.AffiliateLinkId); err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(&commercev1.DeleteAffiliateLinkResponse{Success: true}), nil
}

func (h *AffiliateHandler) PauseAffiliateLink(ctx context.Context, req *connect.Request[commercev1.PauseAffiliateLinkRequest]) (*connect.Response[commercev1.PauseAffiliateLinkResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	link, err := h.svc.PauseLink(ctx, wsID, req.Msg.AffiliateLinkId)
	if err != nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}

	return connect.NewResponse(&commercev1.PauseAffiliateLinkResponse{Link: linkToProto(link)}), nil
}

func (h *AffiliateHandler) ResumeAffiliateLink(ctx context.Context, req *connect.Request[commercev1.ResumeAffiliateLinkRequest]) (*connect.Response[commercev1.ResumeAffiliateLinkResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	link, err := h.svc.ResumeLink(ctx, wsID, req.Msg.AffiliateLinkId)
	if err != nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}

	return connect.NewResponse(&commercev1.ResumeAffiliateLinkResponse{Link: linkToProto(link)}), nil
}

func (h *AffiliateHandler) GetAffiliateAnalytics(ctx context.Context, req *connect.Request[commercev1.GetAffiliateAnalyticsRequest]) (*connect.Response[commercev1.GetAffiliateAnalyticsResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	link, _, err := h.svc.GetLink(ctx, wsID, req.Msg.AffiliateLinkId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(&commercev1.GetAffiliateAnalyticsResponse{
		AffiliateLinkId:       link.AffiliateLinkID,
		ClickCount:            link.ClickCount,
		ConversionCount:       link.ConversionCount,
		RevenueAttributed:     link.RevenueAttributed.String(),
		TotalCommissionEarned: calculateCommissionAmount(link.RevenueAttributed, link.CommissionRate).String(),
		Currency:              "VND",
	}), nil
}

// ----------------------------------------------------------------------------
// CreatorAssignmentHandler
// ----------------------------------------------------------------------------

type CreatorAssignmentHandler struct {
	svc *Service
}

func NewCreatorAssignmentHandler(svc *Service) *CreatorAssignmentHandler {
	return &CreatorAssignmentHandler{svc: svc}
}

var _ commercev1connect.CreatorAssignmentServiceHandler = (*CreatorAssignmentHandler)(nil)

func (h *CreatorAssignmentHandler) CreateAssignment(ctx context.Context, req *connect.Request[commercev1.CreateAssignmentRequest]) (*connect.Response[commercev1.CreateAssignmentResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var campID, linkID, couponID *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}
	if msg.AffiliateLinkId != "" {
		linkID = &msg.AffiliateLinkId
	}
	if msg.CouponId != "" {
		couponID = &msg.CouponId
	}

	assignment := &CreatorAssignment{
		WorkspaceID:     wsID,
		CampaignID:      campID,
		CreatorEntityID: msg.CreatorEntityId,
		AffiliateLinkID: linkID,
		CouponID:        couponID,
		Notes:           msg.Notes,
	}

	res, err := h.svc.CreateAssignment(ctx, assignment)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.CreateAssignmentResponse{
		Assignment: assignmentToProto(res),
	}), nil
}

func (h *CreatorAssignmentHandler) ListAssignments(ctx context.Context, req *connect.Request[commercev1.ListAssignmentsRequest]) (*connect.Response[commercev1.ListAssignmentsResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var campID, creatorID *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}
	if msg.CreatorEntityId != "" {
		creatorID = &msg.CreatorEntityId
	}

	limit := int(msg.PageSize)
	if limit <= 0 {
		limit = 20
	}

	assignments, err := h.svc.ListAssignments(ctx, wsID, campID, creatorID, limit, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var pbAssignments []*commercev1.CreatorAssignment
	for _, a := range assignments {
		pbAssignments = append(pbAssignments, assignmentToProto(a))
	}

	return connect.NewResponse(&commercev1.ListAssignmentsResponse{
		Assignments: pbAssignments,
	}), nil
}

func (h *CreatorAssignmentHandler) UpdateAssignment(ctx context.Context, req *connect.Request[commercev1.UpdateAssignmentRequest]) (*connect.Response[commercev1.UpdateAssignmentResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var st AssignmentState
	switch msg.Status {
	case commercev1.AssignmentStatus_ASSIGNMENT_STATUS_ACTIVE:
		st = AssignmentActive
	case commercev1.AssignmentStatus_ASSIGNMENT_STATUS_COMPLETED:
		st = AssignmentCompleted
	case commercev1.AssignmentStatus_ASSIGNMENT_STATUS_CANCELLED:
		st = AssignmentCancelled
	}

	res, err := h.svc.UpdateAssignment(ctx, wsID, msg.AssignmentId, st, msg.Notes)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.UpdateAssignmentResponse{
		Assignment: assignmentToProto(res),
	}), nil
}

// ----------------------------------------------------------------------------
// AttributionHandler
// ----------------------------------------------------------------------------

type AttributionHandler struct {
	svc *Service
}

func NewAttributionHandler(svc *Service) *AttributionHandler {
	return &AttributionHandler{svc: svc}
}

var _ commercev1connect.AttributionServiceHandler = (*AttributionHandler)(nil)

func (h *AttributionHandler) RecordAttribution(ctx context.Context, req *connect.Request[commercev1.RecordAttributionRequest]) (*connect.Response[commercev1.RecordAttributionResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	ordAmt, err := tenantdb.ParseExactDecimal(msg.OrderAmount)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	var creatorID *string
	if msg.CreatorEntityId != "" {
		creatorID = &msg.CreatorEntityId
	}

	input := &AttributionInput{
		WorkspaceID:     wsID,
		OrderID:         msg.OrderId,
		AffiliateLinkID: msg.AffiliateLinkId,
		CreatorEntityID: creatorID,
		ClickID:         msg.ClickId,
		TouchpointCount: msg.TouchpointCount,
		IsMultiTouch:    msg.IsMultiTouch,
		OrderAmount:     ordAmt,
		Currency:        msg.Currency,
		IsOfficialAPI:   msg.IsOfficialApi,
	}

	res, err := h.svc.RecordAttribution(ctx, input)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.RecordAttributionResponse{
		Attribution: attributionToProto(res),
	}), nil
}

func (h *AttributionHandler) GetAttributionReport(ctx context.Context, req *connect.Request[commercev1.GetAttributionReportRequest]) (*connect.Response[commercev1.GetAttributionReportResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var linkID *string
	if req.Msg.AffiliateLinkId != "" {
		linkID = &req.Msg.AffiliateLinkId
	}

	records, counts, totRev, err := h.svc.GetAttributionReport(ctx, wsID, linkID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var pbRecords []*commercev1.AttributionRecord
	for _, r := range records {
		pbRecords = append(pbRecords, attributionToProto(r))
	}

	return connect.NewResponse(&commercev1.GetAttributionReportResponse{
		Attributions:           pbRecords,
		OfficialCount:          int32(counts["official"]),
		InferredCount:          int32(counts["inferred"]),
		ImportedCount:          int32(counts["imported"]),
		UnreconciledCount:      int32(counts["unreconciled"]),
		TotalAttributedRevenue: totRev.String(),
	}), nil
}

// ----------------------------------------------------------------------------
// AffiliateCommissionHandler
// ----------------------------------------------------------------------------

type AffiliateCommissionHandler struct {
	svc *Service
}

func NewAffiliateCommissionHandler(svc *Service) *AffiliateCommissionHandler {
	return &AffiliateCommissionHandler{svc: svc}
}

var _ commercev1connect.AffiliateCommissionServiceHandler = (*AffiliateCommissionHandler)(nil)

func (h *AffiliateCommissionHandler) CalculateCommission(ctx context.Context, req *connect.Request[commercev1.CalculateCommissionRequest]) (*connect.Response[commercev1.CalculateCommissionResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	ordAmt, err := tenantdb.ParseExactDecimal(msg.OrderAmount)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	var creatorID *string
	if msg.CreatorEntityId != "" {
		creatorID = &msg.CreatorEntityId
	}

	comm, err := h.svc.CalculateCommission(ctx, wsID, msg.AffiliateLinkId, msg.OrderId, creatorID, ordAmt, msg.Currency, int(msg.HoldPeriodDays))
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.CalculateCommissionResponse{
		Commission: commissionToProto(comm),
	}), nil
}

func (h *AffiliateCommissionHandler) ConfirmCommission(ctx context.Context, req *connect.Request[commercev1.ConfirmCommissionRequest]) (*connect.Response[commercev1.ConfirmCommissionResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	comm, err := h.svc.ConfirmCommission(ctx, wsID, req.Msg.CommissionId)
	if err != nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}

	return connect.NewResponse(&commercev1.ConfirmCommissionResponse{
		Commission: commissionToProto(comm),
	}), nil
}

func (h *AffiliateCommissionHandler) ClawbackCommission(ctx context.Context, req *connect.Request[commercev1.ClawbackCommissionRequest]) (*connect.Response[commercev1.ClawbackCommissionResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	comm, err := h.svc.ClawbackCommission(ctx, wsID, msg.CommissionId, msg.Reason, msg.Amount)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.ClawbackCommissionResponse{
		Commission: commissionToProto(comm),
	}), nil
}

func (h *AffiliateCommissionHandler) ListCommissions(ctx context.Context, req *connect.Request[commercev1.ListCommissionsRequest]) (*connect.Response[commercev1.ListCommissionsResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var linkID *string
	if msg.AffiliateLinkId != "" {
		linkID = &msg.AffiliateLinkId
	}

	var st *CommissionState
	if msg.Status != commercev1.CommissionStatus_COMMISSION_STATUS_UNSPECIFIED {
		c := protoToCommState(msg.Status)
		st = &c
	}

	limit := int(msg.PageSize)
	if limit <= 0 {
		limit = 20
	}

	commissions, err := h.svc.store.ListCommissions(ctx, wsID, linkID, st, limit, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var pbComms []*commercev1.AffiliateCommission
	for _, c := range commissions {
		pbComms = append(pbComms, commissionToProto(c))
	}

	return connect.NewResponse(&commercev1.ListCommissionsResponse{
		Commissions: pbComms,
	}), nil
}

func (h *AffiliateCommissionHandler) PostCommissionToLedger(ctx context.Context, req *connect.Request[commercev1.PostCommissionToLedgerRequest]) (*connect.Response[commercev1.PostCommissionToLedgerResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var role EconomicRole
	switch msg.EconomicRole {
	case commercev1.WorkspaceEconomicRole_WORKSPACE_ECONOMIC_ROLE_CREATOR:
		role = EconomicRoleCreator
	case commercev1.WorkspaceEconomicRole_WORKSPACE_ECONOMIC_ROLE_SELLER:
		role = EconomicRoleSeller
	default:
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrEconomicRoleRequired)
	}

	res, err := h.svc.PostCommissionToLedger(ctx, wsID, msg.CommissionId, role)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.PostCommissionToLedgerResponse{
		Result: &commercev1.LedgerAffiliatePostingResult{
			PostingId:       res.PostingID,
			WorkspaceId:     res.WorkspaceID,
			EconomicRole:    msg.EconomicRole,
			PostingType:     res.PostingType,
			Amount:          res.Amount.String(),
			Currency:        res.Currency,
			CogsDeducted:    res.COGSDeducted,
			NetProfitImpact: res.NetProfitImpact.String(),
			PostedAt:        timestamppb.New(res.PostedAt),
		},
	}), nil
}

// ----------------------------------------------------------------------------
// AffiliatePayoutHandler
// ----------------------------------------------------------------------------

type AffiliatePayoutHandler struct {
	svc *Service
}

func NewAffiliatePayoutHandler(svc *Service) *AffiliatePayoutHandler {
	return &AffiliatePayoutHandler{svc: svc}
}

var _ commercev1connect.AffiliatePayoutServiceHandler = (*AffiliatePayoutHandler)(nil)

func (h *AffiliatePayoutHandler) CreatePayoutBatch(ctx context.Context, req *connect.Request[commercev1.CreatePayoutBatchRequest]) (*connect.Response[commercev1.CreatePayoutBatchResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	payout, err := h.svc.CreatePayoutBatch(ctx, wsID, msg.CreatorEntityId, msg.CommissionIds)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.CreatePayoutBatchResponse{
		Payout: payoutToProto(payout),
	}), nil
}

func (h *AffiliatePayoutHandler) ExecutePayoutBatch(ctx context.Context, req *connect.Request[commercev1.ExecutePayoutBatchRequest]) (*connect.Response[commercev1.ExecutePayoutBatchResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	payout, err := h.svc.ExecutePayoutBatch(ctx, wsID, msg.PayoutId, msg.SettlementId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.ExecutePayoutBatchResponse{
		Payout: payoutToProto(payout),
	}), nil
}

func (h *AffiliatePayoutHandler) GetPayoutProof(ctx context.Context, req *connect.Request[commercev1.GetPayoutProofRequest]) (*connect.Response[commercev1.GetPayoutProofResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	payout, proofHash, proofURL, err := h.svc.GetPayoutProof(ctx, wsID, msg.PayoutId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(&commercev1.GetPayoutProofResponse{
		Payout:    payoutToProto(payout),
		ProofHash: proofHash,
		ProofUrl:  proofURL,
	}), nil
}

func (h *AffiliatePayoutHandler) ImportStatement(ctx context.Context, req *connect.Request[commercev1.ImportStatementRequest]) (*connect.Response[commercev1.ImportStatementResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var items []*AffiliateStatementItem
	for _, it := range msg.Items {
		ordAmt, _ := tenantdb.ParseExactDecimal(it.OrderAmount)
		commAmt, _ := tenantdb.ParseExactDecimal(it.CommissionAmount)
		items = append(items, &AffiliateStatementItem{
			ExternalOrderID:  it.ExternalOrderId,
			OrderAmount:      ordAmt,
			CommissionAmount: commAmt,
		})
	}

	stmt := &AffiliateStatement{
		WorkspaceID:          wsID,
		Platform:             msg.Platform,
		ExternalStatementRef: msg.ExternalStatementRef,
		PeriodStart:          msg.PeriodStart,
		PeriodEnd:            msg.PeriodEnd,
		Currency:             msg.Currency,
	}

	res, err := h.svc.ImportStatement(ctx, stmt, items)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.ImportStatementResponse{
		Statement: statementToProto(res),
	}), nil
}

func (h *AffiliatePayoutHandler) ReconcileStatement(ctx context.Context, req *connect.Request[commercev1.ReconcileStatementRequest]) (*connect.Response[commercev1.ReconcileStatementResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	stmt, matched, conflict, unreconciled, err := h.svc.ReconcileStatement(ctx, wsID, msg.StatementId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.ReconcileStatementResponse{
		Statement:         statementToProto(stmt),
		MatchedCount:      matched,
		ConflictCount:     conflict,
		UnreconciledCount: unreconciled,
	}), nil
}

// ----------------------------------------------------------------------------
// LinkHealthHandler
// ----------------------------------------------------------------------------

type LinkHealthHandler struct {
	svc *Service
}

func NewLinkHealthHandler(svc *Service) *LinkHealthHandler {
	return &LinkHealthHandler{svc: svc}
}

var _ commercev1connect.LinkHealthServiceHandler = (*LinkHealthHandler)(nil)

func (h *LinkHealthHandler) RunHealthCheck(ctx context.Context, req *connect.Request[commercev1.RunHealthCheckRequest]) (*connect.Response[commercev1.RunHealthCheckResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	hr, degraded, err := h.svc.RunHealthCheck(ctx, wsID, msg.AffiliateLinkId, msg.SimulatedHttpStatus, msg.SimulatedProductStatus, msg.SimulatedCommissionRate)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.RunHealthCheckResponse{
		Health:         healthToProto(hr),
		HealthDegraded: degraded,
	}), nil
}

func (h *LinkHealthHandler) RepairBrokenLink(ctx context.Context, req *connect.Request[commercev1.RepairBrokenLinkRequest]) (*connect.Response[commercev1.RepairBrokenLinkResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	link, hr, err := h.svc.RepairBrokenLink(ctx, wsID, msg.AffiliateLinkId, msg.NewDestinationUrl, msg.ReplacementProductId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&commercev1.RepairBrokenLinkResponse{
		Link:   linkToProto(link),
		Health: healthToProto(hr),
	}), nil
}

func (h *LinkHealthHandler) GetHealthReport(ctx context.Context, req *connect.Request[commercev1.GetHealthReportRequest]) (*connect.Response[commercev1.GetHealthReportResponse], error) {
	wsID, err := resolveTenant(ctx, req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	records, healthy, warning, broken, totRisk, err := h.svc.GetHealthReport(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var pbRecords []*commercev1.LinkHealthRecord
	for _, r := range records {
		pbRecords = append(pbRecords, healthToProto(r))
	}

	return connect.NewResponse(&commercev1.GetHealthReportResponse{
		HealthRecords:      pbRecords,
		HealthyCount:       healthy,
		WarningCount:       warning,
		BrokenCount:        broken,
		TotalRevenueAtRisk: totRisk.String(),
	}), nil
}

// ----------------------------------------------------------------------------
// Mapping Helpers
// ----------------------------------------------------------------------------

func linkToProto(l *AffiliateLink) *commercev1.AffiliateLink {
	if l == nil {
		return nil
	}
	pb := &commercev1.AffiliateLink{
		AffiliateLinkId:   l.AffiliateLinkID,
		WorkspaceId:       l.WorkspaceID,
		Platform:          l.Platform,
		OriginalUrl:       l.OriginalURL,
		TrackedUrl:        l.TrackedURL,
		ShortCode:         l.ShortCode,
		CommissionRate:    l.CommissionRate.String(),
		LifecycleState:    linkStateToProto(l.LifecycleState),
		HealthStatus:      healthStateToProto(l.HealthStatus),
		ClickCount:        l.ClickCount,
		ConversionCount:   l.ConversionCount,
		RevenueAttributed: l.RevenueAttributed.String(),
		CreatedAt:         timestamppb.New(l.CreatedAt),
		UpdatedAt:         timestamppb.New(l.UpdatedAt),
	}
	if l.ProductID != nil {
		pb.ProductId = *l.ProductID
	}
	if l.OfferID != nil {
		pb.OfferId = *l.OfferID
	}
	if l.CampaignID != nil {
		pb.CampaignId = *l.CampaignID
	}
	if l.ExpiresAt != nil {
		pb.ExpiresAt = timestamppb.New(*l.ExpiresAt)
	}
	if l.LastHealthCheckAt != nil {
		pb.LastHealthCheckAt = timestamppb.New(*l.LastHealthCheckAt)
	}
	if l.SuggestedReplacementProductID != nil {
		pb.SuggestedReplacementProductId = *l.SuggestedReplacementProductID
	}
	return pb
}

func assignmentToProto(a *CreatorAssignment) *commercev1.CreatorAssignment {
	if a == nil {
		return nil
	}
	pb := &commercev1.CreatorAssignment{
		AssignmentId:    a.AssignmentID,
		WorkspaceId:     a.WorkspaceID,
		CreatorEntityId: a.CreatorEntityID,
		Notes:           a.Notes,
		CreatedAt:       timestamppb.New(a.CreatedAt),
		UpdatedAt:       timestamppb.New(a.UpdatedAt),
	}
	if a.CampaignID != nil {
		pb.CampaignId = *a.CampaignID
	}
	if a.AffiliateLinkID != nil {
		pb.AffiliateLinkId = *a.AffiliateLinkID
	}
	if a.CouponID != nil {
		pb.CouponId = *a.CouponID
	}
	switch a.Status {
	case AssignmentActive:
		pb.Status = commercev1.AssignmentStatus_ASSIGNMENT_STATUS_ACTIVE
	case AssignmentCompleted:
		pb.Status = commercev1.AssignmentStatus_ASSIGNMENT_STATUS_COMPLETED
	case AssignmentCancelled:
		pb.Status = commercev1.AssignmentStatus_ASSIGNMENT_STATUS_CANCELLED
	}
	return pb
}

func attributionToProto(r *AttributionRecord) *commercev1.AttributionRecord {
	if r == nil {
		return nil
	}
	pb := &commercev1.AttributionRecord{
		AttributionId:     r.AttributionID,
		WorkspaceId:       r.WorkspaceID,
		OrderId:           r.OrderID,
		AffiliateLinkId:   r.AffiliateLinkID,
		ClickId:           r.ClickID,
		TouchpointCount:   r.TouchpointCount,
		IsMultiTouch:      r.IsMultiTouch,
		AttributionNote:   r.AttributionNote,
		OrderAmount:       r.OrderAmount.String(),
		AttributedRevenue: r.AttributedRevenue.String(),
		CommissionAmount:  r.CommissionAmount.String(),
		Currency:          r.Currency,
		AttributedAt:      timestamppb.New(r.CreatedAt),
	}
	if r.CreatorEntityID != nil {
		pb.CreatorEntityId = *r.CreatorEntityID
	}
	switch r.SourceClass {
	case SourceClassOfficial:
		pb.SourceClass = commercev1.AttributionSourceClass_ATTRIBUTION_SOURCE_CLASS_OFFICIAL
	case SourceClassImported:
		pb.SourceClass = commercev1.AttributionSourceClass_ATTRIBUTION_SOURCE_CLASS_IMPORTED
	case SourceClassInferred:
		pb.SourceClass = commercev1.AttributionSourceClass_ATTRIBUTION_SOURCE_CLASS_INFERRED
	case SourceClassEstimated:
		pb.SourceClass = commercev1.AttributionSourceClass_ATTRIBUTION_SOURCE_CLASS_ESTIMATED
	default:
		pb.SourceClass = commercev1.AttributionSourceClass_ATTRIBUTION_SOURCE_CLASS_UNRECONCILED
	}
	switch r.Confidence {
	case ConfidenceHigh:
		pb.Confidence = commercev1.AttributionConfidence_ATTRIBUTION_CONFIDENCE_HIGH
	case ConfidenceMedium:
		pb.Confidence = commercev1.AttributionConfidence_ATTRIBUTION_CONFIDENCE_MEDIUM
	default:
		pb.Confidence = commercev1.AttributionConfidence_ATTRIBUTION_CONFIDENCE_LOW
	}
	return pb
}

func commissionToProto(c *AffiliateCommission) *commercev1.AffiliateCommission {
	if c == nil {
		return nil
	}
	pb := &commercev1.AffiliateCommission{
		CommissionId:     c.CommissionID,
		WorkspaceId:      c.WorkspaceID,
		AffiliateLinkId:  c.AffiliateLinkID,
		OrderId:          c.OrderID,
		CommissionAmount: c.CommissionAmount.String(),
		Currency:         c.Currency,
		HoldUntil:        timestamppb.New(c.HoldUntil),
		ClawbackReason:   c.ClawbackReason,
		CreatedAt:        timestamppb.New(c.CreatedAt),
		UpdatedAt:        timestamppb.New(c.UpdatedAt),
	}
	if c.CreatorEntityID != nil {
		pb.CreatorEntityId = *c.CreatorEntityID
	}
	if c.ClawbackAmount != nil {
		pb.ClawbackAmount = c.ClawbackAmount.String()
	}
	if c.PayoutID != nil {
		pb.PayoutId = *c.PayoutID
	}
	if c.ConfirmedAt != nil {
		pb.ConfirmedAt = timestamppb.New(*c.ConfirmedAt)
	}
	if c.ClawedBackAt != nil {
		pb.ClawedBackAt = timestamppb.New(*c.ClawedBackAt)
	}
	if c.PaidOutAt != nil {
		pb.PaidOutAt = timestamppb.New(*c.PaidOutAt)
	}
	switch c.Status {
	case CommissionPending:
		pb.Status = commercev1.CommissionStatus_COMMISSION_STATUS_PENDING
	case CommissionConfirmed:
		pb.Status = commercev1.CommissionStatus_COMMISSION_STATUS_CONFIRMED
	case CommissionClawedBack:
		pb.Status = commercev1.CommissionStatus_COMMISSION_STATUS_CLAWED_BACK
	case CommissionPaidOut:
		pb.Status = commercev1.CommissionStatus_COMMISSION_STATUS_PAID_OUT
	}
	return pb
}

func payoutToProto(p *AffiliatePayout) *commercev1.AffiliatePayout {
	if p == nil {
		return nil
	}
	pb := &commercev1.AffiliatePayout{
		PayoutId:        p.PayoutID,
		WorkspaceId:     p.WorkspaceID,
		CreatorEntityId: p.CreatorEntityID,
		CommissionIds:   p.CommissionIDs,
		TotalAmount:     p.TotalAmount.String(),
		Currency:        p.Currency,
		ProofHash:       p.ProofHash,
		CreatedAt:       timestamppb.New(p.CreatedAt),
	}
	if p.SettlementID != nil {
		pb.SettlementId = *p.SettlementID
	}
	if p.PaidAt != nil {
		pb.PaidAt = timestamppb.New(*p.PaidAt)
	}
	if p.ProofMetadata != nil {
		b, _ := json.Marshal(p.ProofMetadata)
		pb.ProofMetadataJson = string(b)
	}
	switch p.Status {
	case PayoutPending:
		pb.Status = commercev1.PayoutStatus_PAYOUT_STATUS_PENDING
	case PayoutProcessing:
		pb.Status = commercev1.PayoutStatus_PAYOUT_STATUS_PROCESSING
	case PayoutCompleted:
		pb.Status = commercev1.PayoutStatus_PAYOUT_STATUS_COMPLETED
	case PayoutFailed:
		pb.Status = commercev1.PayoutStatus_PAYOUT_STATUS_FAILED
	}
	return pb
}

func healthToProto(h *LinkHealthRecord) *commercev1.LinkHealthRecord {
	if h == nil {
		return nil
	}
	pb := &commercev1.LinkHealthRecord{
		HealthId:               h.HealthID,
		WorkspaceId:            h.WorkspaceID,
		AffiliateLinkId:        h.AffiliateLinkID,
		HttpStatus:             h.HTTPStatus,
		ProductStatus:          h.ProductStatus,
		CommissionStatus:       h.CommissionStatus,
		LinkStatus:             healthStateToProto(h.LinkStatus),
		SuggestedAction:        h.SuggestedAction,
		CheckedAt:              timestamppb.New(h.CheckedAt),
		AlertSent:              h.AlertSent,
		EstimatedRevenueImpact: h.EstimatedRevenueImpact.String(),
	}
	if h.ExpiryDate != nil {
		pb.ExpiryDate = timestamppb.New(*h.ExpiryDate)
	}
	if h.SuggestedReplacementProductID != nil {
		pb.SuggestedReplacementProductId = *h.SuggestedReplacementProductID
	}
	return pb
}

func statementToProto(s *AffiliateStatement) *commercev1.AffiliateStatement {
	if s == nil {
		return nil
	}
	return &commercev1.AffiliateStatement{
		StatementId:          s.StatementID,
		WorkspaceId:          s.WorkspaceID,
		Platform:             s.Platform,
		ExternalStatementRef: s.ExternalStatementRef,
		PeriodStart:          s.PeriodStart,
		PeriodEnd:            s.PeriodEnd,
		TotalCommission:      s.TotalCommission.String(),
		Currency:             s.Currency,
		ReconciliationState:  s.ReconciliationState,
		ItemCount:            s.ItemCount,
		ReconciledItemCount:  s.ReconciledItemCount,
		ImportedAt:           timestamppb.New(s.ImportedAt),
	}
}

func linkStateToProto(st LinkLifecycleState) commercev1.AffiliateLinkLifecycleState {
	switch st {
	case LinkStateDraft:
		return commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_DRAFT
	case LinkStateActive:
		return commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_ACTIVE
	case LinkStatePaused:
		return commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_PAUSED
	case LinkStateRevoked:
		return commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED
	case LinkStateExpired:
		return commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_EXPIRED
	default:
		return commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func protoToLinkState(st commercev1.AffiliateLinkLifecycleState) LinkLifecycleState {
	switch st {
	case commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_DRAFT:
		return LinkStateDraft
	case commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_ACTIVE:
		return LinkStateActive
	case commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_PAUSED:
		return LinkStatePaused
	case commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED:
		return LinkStateRevoked
	case commercev1.AffiliateLinkLifecycleState_AFFILIATE_LINK_LIFECYCLE_STATE_EXPIRED:
		return LinkStateExpired
	default:
		return LinkStateActive
	}
}

func healthStateToProto(h HealthStatus) commercev1.LinkHealthStatus {
	switch h {
	case HealthStatusHealthy:
		return commercev1.LinkHealthStatus_LINK_HEALTH_STATUS_HEALTHY
	case HealthStatusWarning:
		return commercev1.LinkHealthStatus_LINK_HEALTH_STATUS_WARNING
	case HealthStatusBroken:
		return commercev1.LinkHealthStatus_LINK_HEALTH_STATUS_BROKEN
	case HealthStatusExpired:
		return commercev1.LinkHealthStatus_LINK_HEALTH_STATUS_EXPIRED
	case HealthStatusProductUnavailable:
		return commercev1.LinkHealthStatus_LINK_HEALTH_STATUS_PRODUCT_UNAVAILABLE
	default:
		return commercev1.LinkHealthStatus_LINK_HEALTH_STATUS_UNSPECIFIED
	}
}

func protoToCommState(st commercev1.CommissionStatus) CommissionState {
	switch st {
	case commercev1.CommissionStatus_COMMISSION_STATUS_PENDING:
		return CommissionPending
	case commercev1.CommissionStatus_COMMISSION_STATUS_CONFIRMED:
		return CommissionConfirmed
	case commercev1.CommissionStatus_COMMISSION_STATUS_CLAWED_BACK:
		return CommissionClawedBack
	case commercev1.CommissionStatus_COMMISSION_STATUS_PAID_OUT:
		return CommissionPaidOut
	default:
		return CommissionPending
	}
}

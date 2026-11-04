package seeding

import (
	"context"
	"errors"
	"fmt"
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
			return "", connect.NewError(connect.CodePermissionDenied, ErrSampleRequestNotFound)
		}
		return session.WorkspaceID, nil
	}
	if requestedWS != "" {
		return requestedWS, nil
	}
	return "", connect.NewError(connect.CodeUnauthenticated, ErrSampleRequestNotFound)
}

func mapError(err error) error {
	if err == nil {
		return nil
	}
	switch {
	case errors.Is(err, ErrSampleRequestNotFound), errors.Is(err, ErrSampleShipmentNotFound), errors.Is(err, ErrCampaignNotFound), errors.Is(err, ErrProductNotFound), errors.Is(err, ErrCreatorEntityNotFound), errors.Is(err, ErrAssignmentNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrMissingCarrierOrTracking), errors.Is(err, ErrDeclineReasonRequired), errors.Is(err, ErrQuantityNonPositive):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, ErrInvalidLifecycleTransition), errors.Is(err, ErrInvalidShipmentTransition), errors.Is(err, ErrInvalidFollowUpTransition):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, ErrCarrierUnavailable):
		return connect.NewError(connect.CodeUnavailable, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

// ----------------------------------------------------------------------------
// SeedingHandler
// ----------------------------------------------------------------------------

type SeedingHandler struct {
	svc *Service
}

func NewSeedingHandler(svc *Service) *SeedingHandler {
	return &SeedingHandler{svc: svc}
}

var _ commercev1connect.SeedingServiceHandler = (*SeedingHandler)(nil)

type SampleHandler struct {
	svc *Service
}

func NewSampleHandler(svc *Service) *SampleHandler {
	return &SampleHandler{svc: svc}
}

var _ commercev1connect.SampleServiceHandler = (*SampleHandler)(nil)

// ============================================================================
// SeedingService RPC Implementations
// ============================================================================

func (h *SeedingHandler) CreateSample(ctx context.Context, req *connect.Request[commercev1.SeedingServiceCreateSampleRequest]) (*connect.Response[commercev1.SeedingServiceCreateSampleResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var campID *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}
	var deadline *string
	if msg.Deadline != "" {
		deadline = &msg.Deadline
	}

	var addr ShippingAddress
	if msg.ShippingAddress != nil {
		addr = ShippingAddress{
			Name:         msg.ShippingAddress.Name,
			Phone:        msg.ShippingAddress.Phone,
			AddressLine1: msg.ShippingAddress.AddressLine_1,
			AddressLine2: msg.ShippingAddress.AddressLine_2,
			City:         msg.ShippingAddress.City,
			PostalCode:   msg.ShippingAddress.PostalCode,
			Country:      msg.ShippingAddress.Country,
		}
	}

	modelReq := &SampleRequest{
		WorkspaceID:         wsID,
		CampaignID:          campID,
		ProductID:           msg.ProductId,
		CreatorEntityID:     msg.CreatorEntityId,
		Quantity:            msg.Quantity,
		ShippingAddress:     addr,
		ContentRequirements: msg.ContentRequirements,
		Deadline:            deadline,
		Notes:               msg.Notes,
	}

	created, isDuplicate, err := h.svc.CreateSample(ctx, modelReq, msg.IdempotencyKey)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceCreateSampleResponse{
		SampleRequest:  toProtoSampleRequest(created),
		AlreadyExisted: isDuplicate,
	}), nil
}

func (h *SeedingHandler) Get(ctx context.Context, req *connect.Request[commercev1.SeedingServiceGetRequest]) (*connect.Response[commercev1.SeedingServiceGetResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	r, err := h.svc.GetSample(ctx, wsID, msg.RequestId)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceGetResponse{
		SampleRequest: toProtoSampleRequest(r),
	}), nil
}

func (h *SeedingHandler) List(ctx context.Context, req *connect.Request[commercev1.SeedingServiceListRequest]) (*connect.Response[commercev1.SeedingServiceListResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var campID, prodID, creatorID *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}
	if msg.ProductId != "" {
		prodID = &msg.ProductId
	}
	if msg.CreatorEntityId != "" {
		creatorID = &msg.CreatorEntityId
	}

	var status *SampleRequestStatus
	if msg.Status != commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_UNSPECIFIED {
		st := fromProtoRequestStatus(msg.Status)
		status = &st
	}

	var outcomeStatus *SampleOutcomeStatus
	if msg.OutcomeStatus != commercev1.SampleOutcomeStatus_SAMPLE_OUTCOME_STATUS_UNSPECIFIED {
		ost := fromProtoOutcomeStatus(msg.OutcomeStatus)
		outcomeStatus = &ost
	}

	var followUpStatus *FollowUpStatus
	if msg.FollowUpStatus != commercev1.FollowUpStatus_FOLLOW_UP_STATUS_UNSPECIFIED {
		fst := fromProtoFollowUpStatus(msg.FollowUpStatus)
		followUpStatus = &fst
	}

	limit := int(msg.Limit)
	if limit <= 0 {
		limit = 50
	}
	offset := int(msg.Offset)

	items, total, counts, err := h.svc.ListSamples(ctx, wsID, campID, prodID, creatorID, status, outcomeStatus, followUpStatus, limit, offset)
	if err != nil {
		return nil, mapError(err)
	}

	var protoList []*commercev1.SampleRequest
	for _, it := range items {
		protoList = append(protoList, toProtoSampleRequest(it))
	}

	return connect.NewResponse(&commercev1.SeedingServiceListResponse{
		SampleRequests:       protoList,
		TotalCount:           int64(total),
		RequestedCount:       counts["requested"],
		ApprovedCount:        counts["approved"],
		ShippedCount:         counts["shipped"],
		ReceivedCount:        counts["received"],
		ReviewPublishedCount: counts["review_published"],
	}), nil
}

func (h *SeedingHandler) Approve(ctx context.Context, req *connect.Request[commercev1.SeedingServiceApproveRequest]) (*connect.Response[commercev1.SeedingServiceApproveResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	actorID := "user"
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.UserID != "" {
		actorID = session.UserID
	}

	updated, costItem, replayed, err := h.svc.ApproveSample(ctx, wsID, msg.RequestId, actorID, msg.IdempotencyKey)
	if err != nil {
		return nil, mapError(err)
	}

	var costID, costAmt, currency string
	if costItem != nil {
		costID = costItem.CostItemID
		costAmt = costItem.Amount.Fixed6String()
		currency = costItem.Currency
	}

	return connect.NewResponse(&commercev1.SeedingServiceApproveResponse{
		SampleRequest: toProtoSampleRequest(updated),
		CostItemId:    costID,
		CostAmount:    costAmt,
		Currency:      currency,
		Replayed:      replayed,
	}), nil
}

func (h *SeedingHandler) Ship(ctx context.Context, req *connect.Request[commercev1.SeedingServiceShipRequest]) (*connect.Response[commercev1.SeedingServiceShipResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	shippingCost, err := tenantdb.ParseExactDecimal(msg.ShippingCost)
	if err != nil && msg.ShippingCost != "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid shipping_cost decimal: %w", err))
	}

	updatedReq, shipment, replayed, err := h.svc.ShipSample(ctx, wsID, msg.RequestId, msg.Carrier, msg.TrackingNumber, shippingCost, msg.IdempotencyKey)
	if err != nil {
		return nil, mapError(err)
	}

	costItem, _ := h.svc.store.GetCostItemForRequest(ctx, wsID, msg.RequestId)
	totalCostStr := "0.000000"
	if costItem != nil {
		totalCostStr = costItem.Amount.Fixed6String()
	}

	return connect.NewResponse(&commercev1.SeedingServiceShipResponse{
		SampleRequest:    toProtoSampleRequest(updatedReq),
		Shipment:         toProtoSampleShipment(shipment),
		TotalUpdatedCost: totalCostStr,
		Replayed:         replayed,
	}), nil
}

func (h *SeedingHandler) TrackDelivery(ctx context.Context, req *connect.Request[commercev1.SeedingServiceTrackDeliveryRequest]) (*connect.Response[commercev1.SeedingServiceTrackDeliveryResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	shipment, err := h.svc.store.GetShipment(ctx, wsID, msg.ShipmentId)
	if err != nil {
		return nil, mapError(err)
	}

	carrierStatus := "In transit with " + shipment.Carrier
	if shipment.Status == ShipmentStatusDelivered {
		carrierStatus = "Delivered to recipient"
	}

	return connect.NewResponse(&commercev1.SeedingServiceTrackDeliveryResponse{
		Shipment:          toProtoSampleShipment(shipment),
		CarrierStatus:     carrierStatus,
		EstimatedDelivery: timestamppb.New(time.Now().Add(48 * time.Hour)),
	}), nil
}

func (h *SeedingHandler) GetReport(ctx context.Context, req *connect.Request[commercev1.SeedingServiceGetReportRequest]) (*connect.Response[commercev1.SeedingServiceGetReportResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	report, err := h.svc.GetReport(ctx, wsID, msg.CampaignId)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceGetReportResponse{
		Report: toProtoSeedingReport(report),
	}), nil
}

func (h *SeedingHandler) CreateCampaign(ctx context.Context, req *connect.Request[commercev1.SeedingServiceCreateCampaignRequest]) (*connect.Response[commercev1.SeedingServiceCreateCampaignResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	budget, _ := tenantdb.ParseExactDecimal(msg.Budget)
	camp := &SeedingCampaign{
		WorkspaceID:       wsID,
		Title:             msg.Title,
		Objective:         msg.Objective,
		Status:            "planned",
		StartDate:         msg.StartDate,
		EndDate:           msg.EndDate,
		Budget:            budget,
		BudgetCurrency:    msg.BudgetCurrency,
		RelatedProductIDs: msg.RelatedProductIds,
	}

	if err := h.svc.CreateCampaign(ctx, camp); err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceCreateCampaignResponse{
		Campaign: toProtoSeedingCampaign(camp),
	}), nil
}

func (h *SeedingHandler) ListCampaigns(ctx context.Context, req *connect.Request[commercev1.SeedingServiceListCampaignsRequest]) (*connect.Response[commercev1.SeedingServiceListCampaignsResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	limit := int(msg.Limit)
	if limit <= 0 {
		limit = 50
	}
	offset := int(msg.Offset)

	camps, total, err := h.svc.ListCampaigns(ctx, wsID, msg.Status, limit, offset)
	if err != nil {
		return nil, mapError(err)
	}

	var protoList []*commercev1.SeedingCampaign
	for _, c := range camps {
		protoList = append(protoList, toProtoSeedingCampaign(c))
	}

	return connect.NewResponse(&commercev1.SeedingServiceListCampaignsResponse{
		Campaigns:  protoList,
		TotalCount: int64(total),
	}), nil
}

func (h *SeedingHandler) CreateAssignment(ctx context.Context, req *connect.Request[commercev1.SeedingServiceCreateAssignmentRequest]) (*connect.Response[commercev1.SeedingServiceCreateAssignmentResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	assignID, err := h.svc.CreateAssignment(ctx, wsID, msg.CampaignId, msg.CreatorEntityId, msg.ProductId, msg.Notes)
	if err != nil {
		return nil, mapError(err)
	}

	items, _, _, _ := h.svc.ListSamples(ctx, wsID, &msg.CampaignId, nil, nil, nil, nil, nil, 1, 0)
	var createdReq *commercev1.SampleRequest
	if len(items) > 0 {
		createdReq = toProtoSampleRequest(items[0])
	}

	return connect.NewResponse(&commercev1.SeedingServiceCreateAssignmentResponse{
		AssignmentId:  assignID,
		SampleRequest: createdReq,
	}), nil
}

func (h *SeedingHandler) RemoveAssignment(ctx context.Context, req *connect.Request[commercev1.SeedingServiceRemoveAssignmentRequest]) (*connect.Response[commercev1.SeedingServiceRemoveAssignmentResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	if err := h.svc.RemoveAssignment(ctx, wsID, msg.AssignmentId); err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceRemoveAssignmentResponse{
		Success: true,
	}), nil
}

func (h *SeedingHandler) ListAssignments(ctx context.Context, req *connect.Request[commercev1.SeedingServiceListAssignmentsRequest]) (*connect.Response[commercev1.SeedingServiceListAssignmentsResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	limit := int(msg.Limit)
	if limit <= 0 {
		limit = 50
	}
	offset := int(msg.Offset)

	items, total, err := h.svc.ListAssignments(ctx, wsID, msg.CampaignId, limit, offset)
	if err != nil {
		return nil, mapError(err)
	}

	var protoList []*commercev1.SampleRequest
	for _, it := range items {
		protoList = append(protoList, toProtoSampleRequest(it))
	}

	return connect.NewResponse(&commercev1.SeedingServiceListAssignmentsResponse{
		Assignments: protoList,
		TotalCount:  int64(total),
	}), nil
}

func (h *SeedingHandler) ListRequests(ctx context.Context, req *connect.Request[commercev1.SeedingServiceListRequestsRequest]) (*connect.Response[commercev1.SeedingServiceListRequestsResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var campID *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}
	var status *SampleRequestStatus
	if msg.Status != commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_UNSPECIFIED {
		st := fromProtoRequestStatus(msg.Status)
		status = &st
	}

	limit := int(msg.Limit)
	if limit <= 0 {
		limit = 50
	}
	offset := int(msg.Offset)

	items, total, _, err := h.svc.ListSamples(ctx, wsID, campID, nil, nil, status, nil, nil, limit, offset)
	if err != nil {
		return nil, mapError(err)
	}

	var protoList []*commercev1.SampleRequest
	for _, it := range items {
		protoList = append(protoList, toProtoSampleRequest(it))
	}

	return connect.NewResponse(&commercev1.SeedingServiceListRequestsResponse{
		SampleRequests: protoList,
		TotalCount:     int64(total),
	}), nil
}

func (h *SeedingHandler) MarkReceived(ctx context.Context, req *connect.Request[commercev1.SeedingServiceMarkReceivedRequest]) (*connect.Response[commercev1.SeedingServiceMarkReceivedResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	updatedReq, shipment, err := h.svc.MarkReceived(ctx, wsID, msg.RequestId)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceMarkReceivedResponse{
		SampleRequest: toProtoSampleRequest(updatedReq),
		Shipment:      toProtoSampleShipment(shipment),
	}), nil
}

func (h *SeedingHandler) MarkShipped(ctx context.Context, req *connect.Request[commercev1.SeedingServiceMarkShippedRequest]) (*connect.Response[commercev1.SeedingServiceMarkShippedResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	cost, _ := tenantdb.ParseExactDecimal(msg.ShippingCost)
	updatedReq, shipment, _, err := h.svc.ShipSample(ctx, wsID, msg.RequestId, msg.Carrier, msg.TrackingNumber, cost, msg.IdempotencyKey)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceMarkShippedResponse{
		SampleRequest: toProtoSampleRequest(updatedReq),
		Shipment:      toProtoSampleShipment(shipment),
	}), nil
}

func (h *SeedingHandler) SendReminder(ctx context.Context, req *connect.Request[commercev1.SeedingServiceSendReminderRequest]) (*connect.Response[commercev1.SeedingServiceSendReminderResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	updatedReq, err := h.svc.UpdateFollowUp(ctx, wsID, msg.RequestId, FollowUpContacted, msg.Message)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceSendReminderResponse{
		RequestId:      updatedReq.RequestID,
		FollowUpStatus: toProtoFollowUpStatus(updatedReq.FollowUpStatus),
		ReminderSentAt: timestamppb.New(time.Now()),
	}), nil
}

func (h *SeedingHandler) UpdateStatus(ctx context.Context, req *connect.Request[commercev1.SeedingServiceUpdateStatusRequest]) (*connect.Response[commercev1.SeedingServiceUpdateStatusResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	targetStatus := fromProtoRequestStatus(msg.NewStatus)
	r, err := h.svc.store.GetRequest(ctx, wsID, msg.RequestId)
	if err != nil {
		return nil, mapError(err)
	}

	r.Status = targetStatus
	if msg.Notes != "" {
		r.Notes = r.Notes + " " + msg.Notes
	}
	r.UpdatedAt = time.Now().UTC()
	if err := h.svc.store.UpdateRequest(ctx, r); err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceUpdateStatusResponse{
		SampleRequest: toProtoSampleRequest(r),
	}), nil
}

func (h *SeedingHandler) Duplicate(ctx context.Context, req *connect.Request[commercev1.SeedingServiceDuplicateRequest]) (*connect.Response[commercev1.SeedingServiceDuplicateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	r, err := h.svc.store.GetRequest(ctx, wsID, msg.RequestId)
	if err != nil {
		return nil, mapError(err)
	}

	dup := *r
	dup.RequestID = newUUID()
	dup.Status = RequestStatusRequested
	dup.OutcomeStatus = OutcomeStatusPending
	dup.FollowUpStatus = FollowUpPending
	dup.Shipment = nil
	now := time.Now().UTC()
	dup.CreatedAt = now
	dup.UpdatedAt = now

	if err := h.svc.store.CreateRequest(ctx, &dup); err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceDuplicateResponse{
		NewRequest: toProtoSampleRequest(&dup),
	}), nil
}

func (h *SeedingHandler) DuplicateCampaign(ctx context.Context, req *connect.Request[commercev1.SeedingServiceDuplicateCampaignRequest]) (*connect.Response[commercev1.SeedingServiceDuplicateCampaignResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	camp, err := h.svc.store.GetCampaign(ctx, wsID, msg.CampaignId)
	if err != nil {
		return nil, mapError(err)
	}

	dup := *camp
	dup.CampaignID = newUUID()
	dup.Title = dup.Title + " (Copy)"
	dup.Status = "planned"
	now := time.Now().UTC()
	dup.CreatedAt = now
	dup.UpdatedAt = now

	if err := h.svc.store.CreateCampaign(ctx, &dup); err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceDuplicateCampaignResponse{
		NewCampaign: toProtoSeedingCampaign(&dup),
	}), nil
}

func (h *SeedingHandler) Launch(ctx context.Context, req *connect.Request[commercev1.SeedingServiceLaunchRequest]) (*connect.Response[commercev1.SeedingServiceLaunchResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	camp, err := h.svc.store.GetCampaign(ctx, wsID, msg.CampaignId)
	if err != nil {
		return nil, mapError(err)
	}

	camp.Status = "live"
	camp.UpdatedAt = time.Now().UTC()
	if err := h.svc.store.UpdateCampaign(ctx, camp); err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceLaunchResponse{
		Campaign: toProtoSeedingCampaign(camp),
	}), nil
}

func (h *SeedingHandler) LinkContent(ctx context.Context, req *connect.Request[commercev1.SeedingServiceLinkContentRequest]) (*connect.Response[commercev1.SeedingServiceLinkContentResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	rev, _ := tenantdb.ParseExactDecimal(msg.AttributableRevenue)
	outcome := SampleOutcome{
		ContentURL:          msg.ContentUrl,
		ContentType:         msg.ContentType,
		PublishItemID:       msg.PublishItemId,
		Impressions:         msg.Impressions,
		Views:               msg.Views,
		Engagements:         msg.Engagements,
		ConversionsCount:    msg.ConversionsCount,
		AttributableRevenue: rev,
		Currency:            msg.Currency,
		SourceClass:         fromProtoSourceClass(msg.SourceClass),
		ConfidenceLevel:     fromProtoConfidenceLevel(msg.ConfidenceLevel),
		ConfidenceReason:    msg.ConfidenceReason,
		Notes:               msg.Notes,
	}

	updatedReq, err := h.svc.LinkContent(ctx, wsID, msg.RequestId, outcome)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SeedingServiceLinkContentResponse{
		SampleRequest: toProtoSampleRequest(updatedReq),
		Outcome:       toProtoSampleOutcome(&updatedReq.Outcome),
	}), nil
}

// ============================================================================
// SampleService RPC Implementations (Consolidated per protobuf_contracts.md §3)
// ============================================================================

func (h *SampleHandler) Create(ctx context.Context, req *connect.Request[commercev1.SampleServiceCreateRequest]) (*connect.Response[commercev1.SampleServiceCreateResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var campID *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}
	var deadline *string
	if msg.Deadline != "" {
		deadline = &msg.Deadline
	}

	var addr ShippingAddress
	if msg.ShippingAddress != nil {
		addr = ShippingAddress{
			Name:         msg.ShippingAddress.Name,
			Phone:        msg.ShippingAddress.Phone,
			AddressLine1: msg.ShippingAddress.AddressLine_1,
			AddressLine2: msg.ShippingAddress.AddressLine_2,
			City:         msg.ShippingAddress.City,
			PostalCode:   msg.ShippingAddress.PostalCode,
			Country:      msg.ShippingAddress.Country,
		}
	}

	modelReq := &SampleRequest{
		WorkspaceID:         wsID,
		CampaignID:          campID,
		ProductID:           msg.ProductId,
		CreatorEntityID:     msg.CreatorEntityId,
		Quantity:            msg.Quantity,
		ShippingAddress:     addr,
		ContentRequirements: msg.ContentRequirements,
		Deadline:            deadline,
		Notes:               msg.Notes,
	}

	created, _, err := h.svc.CreateSample(ctx, modelReq, msg.IdempotencyKey)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SampleServiceCreateResponse{
		SampleRequest: toProtoSampleRequest(created),
	}), nil
}

func (h *SampleHandler) List(ctx context.Context, req *connect.Request[commercev1.SampleServiceListRequest]) (*connect.Response[commercev1.SampleServiceListResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	var campID *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}
	limit := int(msg.Limit)
	if limit <= 0 {
		limit = 50
	}
	items, total, _, err := h.svc.ListSamples(ctx, wsID, campID, nil, nil, nil, nil, nil, limit, int(msg.Offset))
	if err != nil {
		return nil, mapError(err)
	}
	var protoList []*commercev1.SampleRequest
	for _, it := range items {
		protoList = append(protoList, toProtoSampleRequest(it))
	}
	return connect.NewResponse(&commercev1.SampleServiceListResponse{
		SampleRequests: protoList,
		TotalCount:     int64(total),
	}), nil
}

func (h *SampleHandler) Approve(ctx context.Context, req *connect.Request[commercev1.SampleServiceApproveRequest]) (*connect.Response[commercev1.SampleServiceApproveResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	actorID := "user"
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.UserID != "" {
		actorID = session.UserID
	}
	updated, _, _, err := h.svc.ApproveSample(ctx, wsID, msg.RequestId, actorID, msg.IdempotencyKey)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.SampleServiceApproveResponse{
		SampleRequest: toProtoSampleRequest(updated),
	}), nil
}

func (h *SampleHandler) Decline(ctx context.Context, req *connect.Request[commercev1.SampleServiceDeclineRequest]) (*connect.Response[commercev1.SampleServiceDeclineResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	updated, err := h.svc.DeclineSample(ctx, wsID, msg.RequestId, msg.Reason)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SampleServiceDeclineResponse{
		SampleRequest: toProtoSampleRequest(updated),
	}), nil
}

func (h *SampleHandler) Cancel(ctx context.Context, req *connect.Request[commercev1.SampleServiceCancelRequest]) (*connect.Response[commercev1.SampleServiceCancelResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	updated, err := h.svc.CancelSample(ctx, wsID, msg.RequestId, msg.Reason)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SampleServiceCancelResponse{
		SampleRequest: toProtoSampleRequest(updated),
	}), nil
}

func (h *SampleHandler) MarkShipped(ctx context.Context, req *connect.Request[commercev1.SampleServiceMarkShippedRequest]) (*connect.Response[commercev1.SampleServiceMarkShippedResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	cost, _ := tenantdb.ParseExactDecimal(msg.ShippingCost)
	updated, ship, _, err := h.svc.ShipSample(ctx, wsID, msg.RequestId, msg.Carrier, msg.TrackingNumber, cost, msg.IdempotencyKey)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.SampleServiceMarkShippedResponse{
		SampleRequest: toProtoSampleRequest(updated),
		Shipment:      toProtoSampleShipment(ship),
	}), nil
}

func (h *SampleHandler) MarkReceived(ctx context.Context, req *connect.Request[commercev1.SampleServiceMarkReceivedRequest]) (*connect.Response[commercev1.SampleServiceMarkReceivedResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	updated, ship, err := h.svc.MarkReceived(ctx, wsID, msg.RequestId)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.SampleServiceMarkReceivedResponse{
		SampleRequest: toProtoSampleRequest(updated),
		Shipment:      toProtoSampleShipment(ship),
	}), nil
}

func (h *SampleHandler) UpdateStatus(ctx context.Context, req *connect.Request[commercev1.SampleServiceUpdateStatusRequest]) (*connect.Response[commercev1.SampleServiceUpdateStatusResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}
	targetStatus := fromProtoRequestStatus(msg.NewStatus)
	r, err := h.svc.store.GetRequest(ctx, wsID, msg.RequestId)
	if err != nil {
		return nil, mapError(err)
	}
	r.Status = targetStatus
	if msg.Notes != "" {
		r.Notes = r.Notes + " " + msg.Notes
	}
	r.UpdatedAt = time.Now().UTC()
	if err := h.svc.store.UpdateRequest(ctx, r); err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.SampleServiceUpdateStatusResponse{
		SampleRequest: toProtoSampleRequest(r),
	}), nil
}

func (h *SampleHandler) GetSummary(ctx context.Context, req *connect.Request[commercev1.SampleServiceGetSummaryRequest]) (*connect.Response[commercev1.SampleServiceGetSummaryResponse], error) {
	msg := req.Msg
	rep, err := h.svc.GetReport(ctx, msg.WorkspaceId, msg.CampaignId)
	if err != nil {
		return nil, mapError(err)
	}
	return connect.NewResponse(&commercev1.SampleServiceGetSummaryResponse{
		Report: toProtoSeedingReport(rep),
	}), nil
}

func (h *SampleHandler) GetStats(ctx context.Context, req *connect.Request[commercev1.SampleServiceGetStatsRequest]) (*connect.Response[commercev1.SampleServiceGetStatsResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	var campID *string
	if msg.CampaignId != "" {
		campID = &msg.CampaignId
	}

	_, _, counts, err := h.svc.ListSamples(ctx, wsID, campID, nil, nil, nil, nil, nil, 1, 0)
	if err != nil {
		return nil, mapError(err)
	}

	rep, _ := h.svc.GetReport(ctx, wsID, msg.CampaignId)
	totCost := "0.000000"
	covRate := "0.0%"
	if rep != nil {
		totCost = rep.TotalCost.Fixed6String()
		covRate = rep.OutcomeCoverageRate
	}

	return connect.NewResponse(&commercev1.SampleServiceGetStatsResponse{
		RequestedCount:       counts["requested"],
		ApprovedCount:        counts["approved"],
		ShippedCount:         counts["shipped"],
		ReceivedCount:        counts["received"],
		ReviewPublishedCount: counts["review_published"],
		OverdueCount:         0,
		TotalCost:            totCost,
		ReviewRate:           covRate,
	}), nil
}

func (h *SampleHandler) LinkReview(ctx context.Context, req *connect.Request[commercev1.SampleServiceLinkReviewRequest]) (*connect.Response[commercev1.SampleServiceLinkReviewResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	outcome := SampleOutcome{
		ContentURL:       msg.ReviewUrl,
		ContentType:      msg.Platform,
		SourceClass:      SourceClassImported,
		ConfidenceLevel:  ConfidenceMedium,
		ConfidenceReason: "Manually linked creator review URL",
	}

	updated, err := h.svc.LinkContent(ctx, wsID, msg.RequestId, outcome)
	if err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SampleServiceLinkReviewResponse{
		SampleRequest: toProtoSampleRequest(updated),
	}), nil
}

func (h *SampleHandler) RateCreator(ctx context.Context, req *connect.Request[commercev1.SampleServiceRateCreatorRequest]) (*connect.Response[commercev1.SampleServiceRateCreatorResponse], error) {
	return connect.NewResponse(&commercev1.SampleServiceRateCreatorResponse{
		Success: true,
	}), nil
}

func (h *SampleHandler) GetReviewRevenue(ctx context.Context, req *connect.Request[commercev1.SampleServiceGetReviewRevenueRequest]) (*connect.Response[commercev1.SampleServiceGetReviewRevenueResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	r, err := h.svc.store.GetRequest(ctx, wsID, msg.RequestId)
	if err != nil {
		return nil, mapError(err)
	}

	// Target 2: If outcome is pending, revenue is NOT definitive zero!
	sourceClass := toProtoSourceClass(r.Outcome.SourceClass)
	if r.OutcomeStatus == OutcomeStatusPending {
		sourceClass = commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_UNRECONCILED
	}

	return connect.NewResponse(&commercev1.SampleServiceGetReviewRevenueResponse{
		AttributableRevenue: r.Outcome.AttributableRevenue.Fixed6String(),
		Currency:            r.Outcome.Currency,
		SourceClass:         sourceClass,
	}), nil
}

func (h *SampleHandler) ExtendDeadline(ctx context.Context, req *connect.Request[commercev1.SampleServiceExtendDeadlineRequest]) (*connect.Response[commercev1.SampleServiceExtendDeadlineResponse], error) {
	msg := req.Msg
	wsID, err := resolveTenant(ctx, msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	r, err := h.svc.store.GetRequest(ctx, wsID, msg.RequestId)
	if err != nil {
		return nil, mapError(err)
	}

	r.Deadline = &msg.NewDeadline
	if msg.Reason != "" {
		r.Notes = r.Notes + " [Deadline extended: " + msg.Reason + "]"
	}
	r.UpdatedAt = time.Now().UTC()
	if err := h.svc.store.UpdateRequest(ctx, r); err != nil {
		return nil, mapError(err)
	}

	return connect.NewResponse(&commercev1.SampleServiceExtendDeadlineResponse{
		SampleRequest: toProtoSampleRequest(r),
	}), nil
}

func (h *SampleHandler) ExportReport(ctx context.Context, req *connect.Request[commercev1.SampleServiceExportReportRequest]) (*connect.Response[commercev1.SampleServiceExportReportResponse], error) {
	return connect.NewResponse(&commercev1.SampleServiceExportReportResponse{
		FileUrl: "https://exports.creativanta.local/seeding_report.csv",
		Content: "request_id,creator,product,status,cost,revenue\n",
	}), nil
}

// ============================================================================
// Proto Mapping Helpers
// ============================================================================

func toProtoSampleRequest(m *SampleRequest) *commercev1.SampleRequest {
	if m == nil {
		return nil
	}
	var campID, deadline, declineReason string
	if m.CampaignID != nil {
		campID = *m.CampaignID
	}
	if m.Deadline != nil {
		deadline = *m.Deadline
	}
	if m.DeclineReason != nil {
		declineReason = *m.DeclineReason
	}

	return &commercev1.SampleRequest{
		RequestId:           m.RequestID,
		WorkspaceId:         m.WorkspaceID,
		CampaignId:          campID,
		ProductId:           m.ProductID,
		CreatorEntityId:     m.CreatorEntityID,
		Status:              toProtoRequestStatus(m.Status),
		Quantity:            m.Quantity,
		OutcomeStatus:       toProtoOutcomeStatus(m.OutcomeStatus),
		Outcome:             toProtoSampleOutcome(&m.Outcome),
		FollowUpStatus:      toProtoFollowUpStatus(m.FollowUpStatus),
		ShippingAddress:     toProtoShippingAddress(&m.ShippingAddress),
		ContentRequirements: m.ContentRequirements,
		Deadline:            deadline,
		DeclineReason:       declineReason,
		Notes:               m.Notes,
		ProductTitle:        m.ProductTitle,
		ProductCogs:         m.ProductCOGS.Fixed6String(),
		CreatorName:         m.CreatorName,
		CreatorHandle:       m.CreatorHandle,
		CreatorAvatarUrl:    m.CreatorAvatarURL,
		CreatorFollowers:    m.CreatorFollowers,
		CreatorPlatform:     m.CreatorPlatform,
		Shipment:            toProtoSampleShipment(m.Shipment),
		CreatedAt:           timestamppb.New(m.CreatedAt),
		UpdatedAt:           timestamppb.New(m.UpdatedAt),
	}
}

func toProtoSampleShipment(m *SampleShipment) *commercev1.SampleShipment {
	if m == nil {
		return nil
	}
	var shipAt, delAt *timestamppb.Timestamp
	if m.ShippedAt != nil {
		shipAt = timestamppb.New(*m.ShippedAt)
	}
	if m.DeliveredAt != nil {
		delAt = timestamppb.New(*m.DeliveredAt)
	}
	return &commercev1.SampleShipment{
		ShipmentId:     m.ShipmentID,
		RequestId:      m.RequestID,
		WorkspaceId:    m.WorkspaceID,
		TrackingNumber: m.TrackingNumber,
		Carrier:        m.Carrier,
		ShippingCost:   m.ShippingCost.Fixed6String(),
		ShippedAt:      shipAt,
		DeliveredAt:    delAt,
		Status:         toProtoShipmentStatus(m.Status),
		CreatedAt:      timestamppb.New(m.CreatedAt),
		UpdatedAt:      timestamppb.New(m.UpdatedAt),
	}
}

func toProtoSampleOutcome(m *SampleOutcome) *commercev1.SampleOutcome {
	if m == nil {
		return nil
	}
	return &commercev1.SampleOutcome{
		ContentUrl:          m.ContentURL,
		ContentType:         m.ContentType,
		PublishItemId:       m.PublishItemID,
		Impressions:         m.Impressions,
		Views:               m.Views,
		Engagements:         m.Engagements,
		ConversionsCount:    m.ConversionsCount,
		AttributableRevenue: m.AttributableRevenue.Fixed6String(),
		Currency:            m.Currency,
		SourceClass:         toProtoSourceClass(m.SourceClass),
		ConfidenceLevel:     toProtoConfidenceLevel(m.ConfidenceLevel),
		ConfidenceReason:    m.ConfidenceReason,
		Notes:               m.Notes,
		LoggedAt:            timestamppb.New(m.LoggedAt),
	}
}

func toProtoShippingAddress(m *ShippingAddress) *commercev1.ShippingAddress {
	if m == nil {
		return nil
	}
	return &commercev1.ShippingAddress{
		Name:          m.Name,
		Phone:         m.Phone,
		AddressLine_1: m.AddressLine1,
		AddressLine_2: m.AddressLine2,
		City:          m.City,
		PostalCode:    m.PostalCode,
		Country:       m.Country,
	}
}

func toProtoSeedingCampaign(m *SeedingCampaign) *commercev1.SeedingCampaign {
	if m == nil {
		return nil
	}
	return &commercev1.SeedingCampaign{
		CampaignId:        m.CampaignID,
		WorkspaceId:       m.WorkspaceID,
		Title:             m.Title,
		Objective:         m.Objective,
		Status:            m.Status,
		StartDate:         m.StartDate,
		EndDate:           m.EndDate,
		Budget:            m.Budget.Fixed6String(),
		BudgetCurrency:    m.BudgetCurrency,
		RelatedProductIds: m.RelatedProductIDs,
		TotalRequests:     m.TotalRequests,
		ShippedCount:      m.ShippedCount,
		PublishedCount:    m.PublishedCount,
		TotalCost:         m.TotalCost.Fixed6String(),
		AttributedRevenue: m.AttributedRevenue.Fixed6String(),
		CreatedAt:         timestamppb.New(m.CreatedAt),
		UpdatedAt:         timestamppb.New(m.UpdatedAt),
	}
}

func toProtoSeedingReport(m *SeedingReport) *commercev1.SeedingReport {
	if m == nil {
		return nil
	}
	return &commercev1.SeedingReport{
		CampaignId:              m.CampaignID,
		WorkspaceId:             m.WorkspaceID,
		TotalSamplesRequested:   m.TotalSamplesRequested,
		TotalSamplesApproved:    m.TotalSamplesApproved,
		TotalSamplesShipped:     m.TotalSamplesShipped,
		TotalSamplesDelivered:   m.TotalSamplesDelivered,
		OutcomesLoggedCount:     m.OutcomesLoggedCount,
		PendingOutcomesCount:    m.PendingOutcomesCount,
		OutcomeCoverageRate:     m.OutcomeCoverageRate,
		TotalCogs:               m.TotalCOGS.Fixed6String(),
		TotalShipping:           m.TotalShipping.Fixed6String(),
		TotalCost:               m.TotalCost.Fixed6String(),
		AttributableRevenue:     m.AttributableRevenue.Fixed6String(),
		RoiPercentage:           m.ROIPercentage,
		OverallConfidence:       toProtoConfidenceLevel(m.OverallConfidence),
		ConfidenceNotes:         m.ConfidenceNotes,
		Currency:                m.Currency,
		IsMissingOutcomePending: m.IsMissingOutcomePending,
	}
}

func toProtoRequestStatus(s SampleRequestStatus) commercev1.SampleRequestStatus {
	switch s {
	case RequestStatusRequested:
		return commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_REQUESTED
	case RequestStatusApproved:
		return commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_APPROVED
	case RequestStatusDeclined:
		return commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_DECLINED
	case RequestStatusFulfilled:
		return commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_FULFILLED
	case RequestStatusCancelled:
		return commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_CANCELLED
	default:
		return commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_UNSPECIFIED
	}
}

func fromProtoRequestStatus(s commercev1.SampleRequestStatus) SampleRequestStatus {
	switch s {
	case commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_REQUESTED:
		return RequestStatusRequested
	case commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_APPROVED:
		return RequestStatusApproved
	case commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_DECLINED:
		return RequestStatusDeclined
	case commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_FULFILLED:
		return RequestStatusFulfilled
	case commercev1.SampleRequestStatus_SAMPLE_REQUEST_STATUS_CANCELLED:
		return RequestStatusCancelled
	default:
		return RequestStatusRequested
	}
}

func toProtoShipmentStatus(s SampleShipmentStatus) commercev1.SampleShipmentStatus {
	switch s {
	case ShipmentStatusPreparing:
		return commercev1.SampleShipmentStatus_SAMPLE_SHIPMENT_STATUS_PREPARING
	case ShipmentStatusShipped:
		return commercev1.SampleShipmentStatus_SAMPLE_SHIPMENT_STATUS_SHIPPED
	case ShipmentStatusDelivered:
		return commercev1.SampleShipmentStatus_SAMPLE_SHIPMENT_STATUS_DELIVERED
	case ShipmentStatusLost:
		return commercev1.SampleShipmentStatus_SAMPLE_SHIPMENT_STATUS_LOST
	case ShipmentStatusReturned:
		return commercev1.SampleShipmentStatus_SAMPLE_SHIPMENT_STATUS_RETURNED
	case ShipmentStatusClosed:
		return commercev1.SampleShipmentStatus_SAMPLE_SHIPMENT_STATUS_CLOSED
	default:
		return commercev1.SampleShipmentStatus_SAMPLE_SHIPMENT_STATUS_UNSPECIFIED
	}
}

func toProtoOutcomeStatus(s SampleOutcomeStatus) commercev1.SampleOutcomeStatus {
	switch s {
	case OutcomeStatusPending:
		return commercev1.SampleOutcomeStatus_SAMPLE_OUTCOME_STATUS_PENDING
	case OutcomeStatusLogged:
		return commercev1.SampleOutcomeStatus_SAMPLE_OUTCOME_STATUS_LOGGED
	default:
		return commercev1.SampleOutcomeStatus_SAMPLE_OUTCOME_STATUS_UNSPECIFIED
	}
}

func fromProtoOutcomeStatus(s commercev1.SampleOutcomeStatus) SampleOutcomeStatus {
	switch s {
	case commercev1.SampleOutcomeStatus_SAMPLE_OUTCOME_STATUS_LOGGED:
		return OutcomeStatusLogged
	default:
		return OutcomeStatusPending
	}
}

func toProtoFollowUpStatus(s FollowUpStatus) commercev1.FollowUpStatus {
	switch s {
	case FollowUpPending:
		return commercev1.FollowUpStatus_FOLLOW_UP_STATUS_PENDING_FOLLOWUP
	case FollowUpContacted:
		return commercev1.FollowUpStatus_FOLLOW_UP_STATUS_CONTACTED
	case FollowUpResponded:
		return commercev1.FollowUpStatus_FOLLOW_UP_STATUS_RESPONDED
	case FollowUpNoResponse:
		return commercev1.FollowUpStatus_FOLLOW_UP_STATUS_NO_RESPONSE
	default:
		return commercev1.FollowUpStatus_FOLLOW_UP_STATUS_UNSPECIFIED
	}
}

func fromProtoFollowUpStatus(s commercev1.FollowUpStatus) FollowUpStatus {
	switch s {
	case commercev1.FollowUpStatus_FOLLOW_UP_STATUS_CONTACTED:
		return FollowUpContacted
	case commercev1.FollowUpStatus_FOLLOW_UP_STATUS_RESPONDED:
		return FollowUpResponded
	case commercev1.FollowUpStatus_FOLLOW_UP_STATUS_NO_RESPONSE:
		return FollowUpNoResponse
	default:
		return FollowUpPending
	}
}

func toProtoSourceClass(s SourceClass) commercev1.SeedingSourceClass {
	switch s {
	case SourceClassOfficial:
		return commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_OFFICIAL
	case SourceClassImported:
		return commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_IMPORTED
	case SourceClassInferred:
		return commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_INFERRED
	case SourceClassEstimated:
		return commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_ESTIMATED
	case SourceClassUnreconciled:
		return commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_UNRECONCILED
	default:
		return commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_UNSPECIFIED
	}
}

func fromProtoSourceClass(s commercev1.SeedingSourceClass) SourceClass {
	switch s {
	case commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_OFFICIAL:
		return SourceClassOfficial
	case commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_IMPORTED:
		return SourceClassImported
	case commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_INFERRED:
		return SourceClassInferred
	case commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_ESTIMATED:
		return SourceClassEstimated
	case commercev1.SeedingSourceClass_SEEDING_SOURCE_CLASS_UNRECONCILED:
		return SourceClassUnreconciled
	default:
		return SourceClassImported
	}
}

func toProtoConfidenceLevel(c ConfidenceLevel) commercev1.SeedingConfidenceLevel {
	switch c {
	case ConfidenceHigh:
		return commercev1.SeedingConfidenceLevel_SEEDING_CONFIDENCE_LEVEL_HIGH
	case ConfidenceMedium:
		return commercev1.SeedingConfidenceLevel_SEEDING_CONFIDENCE_LEVEL_MEDIUM
	case ConfidenceLow:
		return commercev1.SeedingConfidenceLevel_SEEDING_CONFIDENCE_LEVEL_LOW
	default:
		return commercev1.SeedingConfidenceLevel_SEEDING_CONFIDENCE_LEVEL_UNSPECIFIED
	}
}

func fromProtoConfidenceLevel(c commercev1.SeedingConfidenceLevel) ConfidenceLevel {
	switch c {
	case commercev1.SeedingConfidenceLevel_SEEDING_CONFIDENCE_LEVEL_HIGH:
		return ConfidenceHigh
	case commercev1.SeedingConfidenceLevel_SEEDING_CONFIDENCE_LEVEL_MEDIUM:
		return ConfidenceMedium
	case commercev1.SeedingConfidenceLevel_SEEDING_CONFIDENCE_LEVEL_LOW:
		return ConfidenceLow
	default:
		return ConfidenceMedium
	}
}

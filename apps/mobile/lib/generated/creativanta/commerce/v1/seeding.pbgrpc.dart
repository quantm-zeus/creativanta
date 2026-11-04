// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/seeding.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'seeding.pb.dart' as $0;

export 'seeding.pb.dart';

@$pb.GrpcServiceName('creativanta.commerce.v1.SeedingService')
class SeedingServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SeedingServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SeedingServiceCreateSampleResponse> createSample(
    $0.SeedingServiceCreateSampleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createSample, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceGetResponse> get(
    $0.SeedingServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceListResponse> list(
    $0.SeedingServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceApproveResponse> approve(
    $0.SeedingServiceApproveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approve, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceShipResponse> ship(
    $0.SeedingServiceShipRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$ship, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceTrackDeliveryResponse> trackDelivery(
    $0.SeedingServiceTrackDeliveryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$trackDelivery, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceGetReportResponse> getReport(
    $0.SeedingServiceGetReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReport, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceCreateCampaignResponse> createCampaign(
    $0.SeedingServiceCreateCampaignRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createCampaign, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceListCampaignsResponse> listCampaigns(
    $0.SeedingServiceListCampaignsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listCampaigns, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceCreateAssignmentResponse>
      createAssignment(
    $0.SeedingServiceCreateAssignmentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createAssignment, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceRemoveAssignmentResponse>
      removeAssignment(
    $0.SeedingServiceRemoveAssignmentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeAssignment, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceListAssignmentsResponse>
      listAssignments(
    $0.SeedingServiceListAssignmentsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAssignments, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceListRequestsResponse> listRequests(
    $0.SeedingServiceListRequestsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRequests, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceMarkReceivedResponse> markReceived(
    $0.SeedingServiceMarkReceivedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markReceived, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceMarkShippedResponse> markShipped(
    $0.SeedingServiceMarkShippedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markShipped, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceSendReminderResponse> sendReminder(
    $0.SeedingServiceSendReminderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendReminder, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceUpdateStatusResponse> updateStatus(
    $0.SeedingServiceUpdateStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceDuplicateResponse> duplicate(
    $0.SeedingServiceDuplicateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$duplicate, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceDuplicateCampaignResponse>
      duplicateCampaign(
    $0.SeedingServiceDuplicateCampaignRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$duplicateCampaign, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceLaunchResponse> launch(
    $0.SeedingServiceLaunchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$launch, request, options: options);
  }

  $grpc.ResponseFuture<$0.SeedingServiceLinkContentResponse> linkContent(
    $0.SeedingServiceLinkContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$linkContent, request, options: options);
  }

  // method descriptors

  static final _$createSample = $grpc.ClientMethod<
          $0.SeedingServiceCreateSampleRequest,
          $0.SeedingServiceCreateSampleResponse>(
      '/creativanta.commerce.v1.SeedingService/CreateSample',
      ($0.SeedingServiceCreateSampleRequest value) => value.writeToBuffer(),
      $0.SeedingServiceCreateSampleResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.SeedingServiceGetRequest,
          $0.SeedingServiceGetResponse>(
      '/creativanta.commerce.v1.SeedingService/Get',
      ($0.SeedingServiceGetRequest value) => value.writeToBuffer(),
      $0.SeedingServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.SeedingServiceListRequest,
          $0.SeedingServiceListResponse>(
      '/creativanta.commerce.v1.SeedingService/List',
      ($0.SeedingServiceListRequest value) => value.writeToBuffer(),
      $0.SeedingServiceListResponse.fromBuffer);
  static final _$approve = $grpc.ClientMethod<$0.SeedingServiceApproveRequest,
          $0.SeedingServiceApproveResponse>(
      '/creativanta.commerce.v1.SeedingService/Approve',
      ($0.SeedingServiceApproveRequest value) => value.writeToBuffer(),
      $0.SeedingServiceApproveResponse.fromBuffer);
  static final _$ship = $grpc.ClientMethod<$0.SeedingServiceShipRequest,
          $0.SeedingServiceShipResponse>(
      '/creativanta.commerce.v1.SeedingService/Ship',
      ($0.SeedingServiceShipRequest value) => value.writeToBuffer(),
      $0.SeedingServiceShipResponse.fromBuffer);
  static final _$trackDelivery = $grpc.ClientMethod<
          $0.SeedingServiceTrackDeliveryRequest,
          $0.SeedingServiceTrackDeliveryResponse>(
      '/creativanta.commerce.v1.SeedingService/TrackDelivery',
      ($0.SeedingServiceTrackDeliveryRequest value) => value.writeToBuffer(),
      $0.SeedingServiceTrackDeliveryResponse.fromBuffer);
  static final _$getReport = $grpc.ClientMethod<
          $0.SeedingServiceGetReportRequest,
          $0.SeedingServiceGetReportResponse>(
      '/creativanta.commerce.v1.SeedingService/GetReport',
      ($0.SeedingServiceGetReportRequest value) => value.writeToBuffer(),
      $0.SeedingServiceGetReportResponse.fromBuffer);
  static final _$createCampaign = $grpc.ClientMethod<
          $0.SeedingServiceCreateCampaignRequest,
          $0.SeedingServiceCreateCampaignResponse>(
      '/creativanta.commerce.v1.SeedingService/CreateCampaign',
      ($0.SeedingServiceCreateCampaignRequest value) => value.writeToBuffer(),
      $0.SeedingServiceCreateCampaignResponse.fromBuffer);
  static final _$listCampaigns = $grpc.ClientMethod<
          $0.SeedingServiceListCampaignsRequest,
          $0.SeedingServiceListCampaignsResponse>(
      '/creativanta.commerce.v1.SeedingService/ListCampaigns',
      ($0.SeedingServiceListCampaignsRequest value) => value.writeToBuffer(),
      $0.SeedingServiceListCampaignsResponse.fromBuffer);
  static final _$createAssignment = $grpc.ClientMethod<
          $0.SeedingServiceCreateAssignmentRequest,
          $0.SeedingServiceCreateAssignmentResponse>(
      '/creativanta.commerce.v1.SeedingService/CreateAssignment',
      ($0.SeedingServiceCreateAssignmentRequest value) => value.writeToBuffer(),
      $0.SeedingServiceCreateAssignmentResponse.fromBuffer);
  static final _$removeAssignment = $grpc.ClientMethod<
          $0.SeedingServiceRemoveAssignmentRequest,
          $0.SeedingServiceRemoveAssignmentResponse>(
      '/creativanta.commerce.v1.SeedingService/RemoveAssignment',
      ($0.SeedingServiceRemoveAssignmentRequest value) => value.writeToBuffer(),
      $0.SeedingServiceRemoveAssignmentResponse.fromBuffer);
  static final _$listAssignments = $grpc.ClientMethod<
          $0.SeedingServiceListAssignmentsRequest,
          $0.SeedingServiceListAssignmentsResponse>(
      '/creativanta.commerce.v1.SeedingService/ListAssignments',
      ($0.SeedingServiceListAssignmentsRequest value) => value.writeToBuffer(),
      $0.SeedingServiceListAssignmentsResponse.fromBuffer);
  static final _$listRequests = $grpc.ClientMethod<
          $0.SeedingServiceListRequestsRequest,
          $0.SeedingServiceListRequestsResponse>(
      '/creativanta.commerce.v1.SeedingService/ListRequests',
      ($0.SeedingServiceListRequestsRequest value) => value.writeToBuffer(),
      $0.SeedingServiceListRequestsResponse.fromBuffer);
  static final _$markReceived = $grpc.ClientMethod<
          $0.SeedingServiceMarkReceivedRequest,
          $0.SeedingServiceMarkReceivedResponse>(
      '/creativanta.commerce.v1.SeedingService/MarkReceived',
      ($0.SeedingServiceMarkReceivedRequest value) => value.writeToBuffer(),
      $0.SeedingServiceMarkReceivedResponse.fromBuffer);
  static final _$markShipped = $grpc.ClientMethod<
          $0.SeedingServiceMarkShippedRequest,
          $0.SeedingServiceMarkShippedResponse>(
      '/creativanta.commerce.v1.SeedingService/MarkShipped',
      ($0.SeedingServiceMarkShippedRequest value) => value.writeToBuffer(),
      $0.SeedingServiceMarkShippedResponse.fromBuffer);
  static final _$sendReminder = $grpc.ClientMethod<
          $0.SeedingServiceSendReminderRequest,
          $0.SeedingServiceSendReminderResponse>(
      '/creativanta.commerce.v1.SeedingService/SendReminder',
      ($0.SeedingServiceSendReminderRequest value) => value.writeToBuffer(),
      $0.SeedingServiceSendReminderResponse.fromBuffer);
  static final _$updateStatus = $grpc.ClientMethod<
          $0.SeedingServiceUpdateStatusRequest,
          $0.SeedingServiceUpdateStatusResponse>(
      '/creativanta.commerce.v1.SeedingService/UpdateStatus',
      ($0.SeedingServiceUpdateStatusRequest value) => value.writeToBuffer(),
      $0.SeedingServiceUpdateStatusResponse.fromBuffer);
  static final _$duplicate = $grpc.ClientMethod<
          $0.SeedingServiceDuplicateRequest,
          $0.SeedingServiceDuplicateResponse>(
      '/creativanta.commerce.v1.SeedingService/Duplicate',
      ($0.SeedingServiceDuplicateRequest value) => value.writeToBuffer(),
      $0.SeedingServiceDuplicateResponse.fromBuffer);
  static final _$duplicateCampaign = $grpc.ClientMethod<
          $0.SeedingServiceDuplicateCampaignRequest,
          $0.SeedingServiceDuplicateCampaignResponse>(
      '/creativanta.commerce.v1.SeedingService/DuplicateCampaign',
      ($0.SeedingServiceDuplicateCampaignRequest value) =>
          value.writeToBuffer(),
      $0.SeedingServiceDuplicateCampaignResponse.fromBuffer);
  static final _$launch = $grpc.ClientMethod<$0.SeedingServiceLaunchRequest,
          $0.SeedingServiceLaunchResponse>(
      '/creativanta.commerce.v1.SeedingService/Launch',
      ($0.SeedingServiceLaunchRequest value) => value.writeToBuffer(),
      $0.SeedingServiceLaunchResponse.fromBuffer);
  static final _$linkContent = $grpc.ClientMethod<
          $0.SeedingServiceLinkContentRequest,
          $0.SeedingServiceLinkContentResponse>(
      '/creativanta.commerce.v1.SeedingService/LinkContent',
      ($0.SeedingServiceLinkContentRequest value) => value.writeToBuffer(),
      $0.SeedingServiceLinkContentResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.SeedingService')
abstract class SeedingServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.SeedingService';

  SeedingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceCreateSampleRequest,
            $0.SeedingServiceCreateSampleResponse>(
        'CreateSample',
        createSample_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceCreateSampleRequest.fromBuffer(value),
        ($0.SeedingServiceCreateSampleResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceGetRequest,
            $0.SeedingServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceGetRequest.fromBuffer(value),
        ($0.SeedingServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceListRequest,
            $0.SeedingServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceListRequest.fromBuffer(value),
        ($0.SeedingServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceApproveRequest,
            $0.SeedingServiceApproveResponse>(
        'Approve',
        approve_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceApproveRequest.fromBuffer(value),
        ($0.SeedingServiceApproveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceShipRequest,
            $0.SeedingServiceShipResponse>(
        'Ship',
        ship_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceShipRequest.fromBuffer(value),
        ($0.SeedingServiceShipResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceTrackDeliveryRequest,
            $0.SeedingServiceTrackDeliveryResponse>(
        'TrackDelivery',
        trackDelivery_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceTrackDeliveryRequest.fromBuffer(value),
        ($0.SeedingServiceTrackDeliveryResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceGetReportRequest,
            $0.SeedingServiceGetReportResponse>(
        'GetReport',
        getReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceGetReportRequest.fromBuffer(value),
        ($0.SeedingServiceGetReportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceCreateCampaignRequest,
            $0.SeedingServiceCreateCampaignResponse>(
        'CreateCampaign',
        createCampaign_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceCreateCampaignRequest.fromBuffer(value),
        ($0.SeedingServiceCreateCampaignResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceListCampaignsRequest,
            $0.SeedingServiceListCampaignsResponse>(
        'ListCampaigns',
        listCampaigns_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceListCampaignsRequest.fromBuffer(value),
        ($0.SeedingServiceListCampaignsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceCreateAssignmentRequest,
            $0.SeedingServiceCreateAssignmentResponse>(
        'CreateAssignment',
        createAssignment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceCreateAssignmentRequest.fromBuffer(value),
        ($0.SeedingServiceCreateAssignmentResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceRemoveAssignmentRequest,
            $0.SeedingServiceRemoveAssignmentResponse>(
        'RemoveAssignment',
        removeAssignment_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceRemoveAssignmentRequest.fromBuffer(value),
        ($0.SeedingServiceRemoveAssignmentResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceListAssignmentsRequest,
            $0.SeedingServiceListAssignmentsResponse>(
        'ListAssignments',
        listAssignments_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceListAssignmentsRequest.fromBuffer(value),
        ($0.SeedingServiceListAssignmentsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceListRequestsRequest,
            $0.SeedingServiceListRequestsResponse>(
        'ListRequests',
        listRequests_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceListRequestsRequest.fromBuffer(value),
        ($0.SeedingServiceListRequestsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceMarkReceivedRequest,
            $0.SeedingServiceMarkReceivedResponse>(
        'MarkReceived',
        markReceived_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceMarkReceivedRequest.fromBuffer(value),
        ($0.SeedingServiceMarkReceivedResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceMarkShippedRequest,
            $0.SeedingServiceMarkShippedResponse>(
        'MarkShipped',
        markShipped_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceMarkShippedRequest.fromBuffer(value),
        ($0.SeedingServiceMarkShippedResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceSendReminderRequest,
            $0.SeedingServiceSendReminderResponse>(
        'SendReminder',
        sendReminder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceSendReminderRequest.fromBuffer(value),
        ($0.SeedingServiceSendReminderResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceUpdateStatusRequest,
            $0.SeedingServiceUpdateStatusResponse>(
        'UpdateStatus',
        updateStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceUpdateStatusRequest.fromBuffer(value),
        ($0.SeedingServiceUpdateStatusResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceDuplicateRequest,
            $0.SeedingServiceDuplicateResponse>(
        'Duplicate',
        duplicate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceDuplicateRequest.fromBuffer(value),
        ($0.SeedingServiceDuplicateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceDuplicateCampaignRequest,
            $0.SeedingServiceDuplicateCampaignResponse>(
        'DuplicateCampaign',
        duplicateCampaign_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceDuplicateCampaignRequest.fromBuffer(value),
        ($0.SeedingServiceDuplicateCampaignResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceLaunchRequest,
            $0.SeedingServiceLaunchResponse>(
        'Launch',
        launch_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceLaunchRequest.fromBuffer(value),
        ($0.SeedingServiceLaunchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedingServiceLinkContentRequest,
            $0.SeedingServiceLinkContentResponse>(
        'LinkContent',
        linkContent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SeedingServiceLinkContentRequest.fromBuffer(value),
        ($0.SeedingServiceLinkContentResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SeedingServiceCreateSampleResponse> createSample_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceCreateSampleRequest> $request) async {
    return createSample($call, await $request);
  }

  $async.Future<$0.SeedingServiceCreateSampleResponse> createSample(
      $grpc.ServiceCall call, $0.SeedingServiceCreateSampleRequest request);

  $async.Future<$0.SeedingServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.SeedingServiceGetResponse> get(
      $grpc.ServiceCall call, $0.SeedingServiceGetRequest request);

  $async.Future<$0.SeedingServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.SeedingServiceListResponse> list(
      $grpc.ServiceCall call, $0.SeedingServiceListRequest request);

  $async.Future<$0.SeedingServiceApproveResponse> approve_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceApproveRequest> $request) async {
    return approve($call, await $request);
  }

  $async.Future<$0.SeedingServiceApproveResponse> approve(
      $grpc.ServiceCall call, $0.SeedingServiceApproveRequest request);

  $async.Future<$0.SeedingServiceShipResponse> ship_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceShipRequest> $request) async {
    return ship($call, await $request);
  }

  $async.Future<$0.SeedingServiceShipResponse> ship(
      $grpc.ServiceCall call, $0.SeedingServiceShipRequest request);

  $async.Future<$0.SeedingServiceTrackDeliveryResponse> trackDelivery_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceTrackDeliveryRequest> $request) async {
    return trackDelivery($call, await $request);
  }

  $async.Future<$0.SeedingServiceTrackDeliveryResponse> trackDelivery(
      $grpc.ServiceCall call, $0.SeedingServiceTrackDeliveryRequest request);

  $async.Future<$0.SeedingServiceGetReportResponse> getReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceGetReportRequest> $request) async {
    return getReport($call, await $request);
  }

  $async.Future<$0.SeedingServiceGetReportResponse> getReport(
      $grpc.ServiceCall call, $0.SeedingServiceGetReportRequest request);

  $async.Future<$0.SeedingServiceCreateCampaignResponse> createCampaign_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceCreateCampaignRequest> $request) async {
    return createCampaign($call, await $request);
  }

  $async.Future<$0.SeedingServiceCreateCampaignResponse> createCampaign(
      $grpc.ServiceCall call, $0.SeedingServiceCreateCampaignRequest request);

  $async.Future<$0.SeedingServiceListCampaignsResponse> listCampaigns_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceListCampaignsRequest> $request) async {
    return listCampaigns($call, await $request);
  }

  $async.Future<$0.SeedingServiceListCampaignsResponse> listCampaigns(
      $grpc.ServiceCall call, $0.SeedingServiceListCampaignsRequest request);

  $async.Future<$0.SeedingServiceCreateAssignmentResponse> createAssignment_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceCreateAssignmentRequest> $request) async {
    return createAssignment($call, await $request);
  }

  $async.Future<$0.SeedingServiceCreateAssignmentResponse> createAssignment(
      $grpc.ServiceCall call, $0.SeedingServiceCreateAssignmentRequest request);

  $async.Future<$0.SeedingServiceRemoveAssignmentResponse> removeAssignment_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceRemoveAssignmentRequest> $request) async {
    return removeAssignment($call, await $request);
  }

  $async.Future<$0.SeedingServiceRemoveAssignmentResponse> removeAssignment(
      $grpc.ServiceCall call, $0.SeedingServiceRemoveAssignmentRequest request);

  $async.Future<$0.SeedingServiceListAssignmentsResponse> listAssignments_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceListAssignmentsRequest> $request) async {
    return listAssignments($call, await $request);
  }

  $async.Future<$0.SeedingServiceListAssignmentsResponse> listAssignments(
      $grpc.ServiceCall call, $0.SeedingServiceListAssignmentsRequest request);

  $async.Future<$0.SeedingServiceListRequestsResponse> listRequests_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceListRequestsRequest> $request) async {
    return listRequests($call, await $request);
  }

  $async.Future<$0.SeedingServiceListRequestsResponse> listRequests(
      $grpc.ServiceCall call, $0.SeedingServiceListRequestsRequest request);

  $async.Future<$0.SeedingServiceMarkReceivedResponse> markReceived_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceMarkReceivedRequest> $request) async {
    return markReceived($call, await $request);
  }

  $async.Future<$0.SeedingServiceMarkReceivedResponse> markReceived(
      $grpc.ServiceCall call, $0.SeedingServiceMarkReceivedRequest request);

  $async.Future<$0.SeedingServiceMarkShippedResponse> markShipped_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceMarkShippedRequest> $request) async {
    return markShipped($call, await $request);
  }

  $async.Future<$0.SeedingServiceMarkShippedResponse> markShipped(
      $grpc.ServiceCall call, $0.SeedingServiceMarkShippedRequest request);

  $async.Future<$0.SeedingServiceSendReminderResponse> sendReminder_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceSendReminderRequest> $request) async {
    return sendReminder($call, await $request);
  }

  $async.Future<$0.SeedingServiceSendReminderResponse> sendReminder(
      $grpc.ServiceCall call, $0.SeedingServiceSendReminderRequest request);

  $async.Future<$0.SeedingServiceUpdateStatusResponse> updateStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceUpdateStatusRequest> $request) async {
    return updateStatus($call, await $request);
  }

  $async.Future<$0.SeedingServiceUpdateStatusResponse> updateStatus(
      $grpc.ServiceCall call, $0.SeedingServiceUpdateStatusRequest request);

  $async.Future<$0.SeedingServiceDuplicateResponse> duplicate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceDuplicateRequest> $request) async {
    return duplicate($call, await $request);
  }

  $async.Future<$0.SeedingServiceDuplicateResponse> duplicate(
      $grpc.ServiceCall call, $0.SeedingServiceDuplicateRequest request);

  $async.Future<$0.SeedingServiceDuplicateCampaignResponse>
      duplicateCampaign_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.SeedingServiceDuplicateCampaignRequest>
              $request) async {
    return duplicateCampaign($call, await $request);
  }

  $async.Future<$0.SeedingServiceDuplicateCampaignResponse> duplicateCampaign(
      $grpc.ServiceCall call,
      $0.SeedingServiceDuplicateCampaignRequest request);

  $async.Future<$0.SeedingServiceLaunchResponse> launch_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceLaunchRequest> $request) async {
    return launch($call, await $request);
  }

  $async.Future<$0.SeedingServiceLaunchResponse> launch(
      $grpc.ServiceCall call, $0.SeedingServiceLaunchRequest request);

  $async.Future<$0.SeedingServiceLinkContentResponse> linkContent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SeedingServiceLinkContentRequest> $request) async {
    return linkContent($call, await $request);
  }

  $async.Future<$0.SeedingServiceLinkContentResponse> linkContent(
      $grpc.ServiceCall call, $0.SeedingServiceLinkContentRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.SampleService')
class SampleServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SampleServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SampleServiceCreateResponse> create(
    $0.SampleServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceListResponse> list(
    $0.SampleServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceApproveResponse> approve(
    $0.SampleServiceApproveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approve, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceDeclineResponse> decline(
    $0.SampleServiceDeclineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$decline, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceCancelResponse> cancel(
    $0.SampleServiceCancelRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancel, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceMarkShippedResponse> markShipped(
    $0.SampleServiceMarkShippedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markShipped, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceMarkReceivedResponse> markReceived(
    $0.SampleServiceMarkReceivedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markReceived, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceUpdateStatusResponse> updateStatus(
    $0.SampleServiceUpdateStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceGetSummaryResponse> getSummary(
    $0.SampleServiceGetSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSummary, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceGetStatsResponse> getStats(
    $0.SampleServiceGetStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceLinkReviewResponse> linkReview(
    $0.SampleServiceLinkReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$linkReview, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceRateCreatorResponse> rateCreator(
    $0.SampleServiceRateCreatorRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rateCreator, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceGetReviewRevenueResponse>
      getReviewRevenue(
    $0.SampleServiceGetReviewRevenueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReviewRevenue, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceExtendDeadlineResponse> extendDeadline(
    $0.SampleServiceExtendDeadlineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$extendDeadline, request, options: options);
  }

  $grpc.ResponseFuture<$0.SampleServiceExportReportResponse> exportReport(
    $0.SampleServiceExportReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exportReport, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.SampleServiceCreateRequest,
          $0.SampleServiceCreateResponse>(
      '/creativanta.commerce.v1.SampleService/Create',
      ($0.SampleServiceCreateRequest value) => value.writeToBuffer(),
      $0.SampleServiceCreateResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.SampleServiceListRequest,
          $0.SampleServiceListResponse>(
      '/creativanta.commerce.v1.SampleService/List',
      ($0.SampleServiceListRequest value) => value.writeToBuffer(),
      $0.SampleServiceListResponse.fromBuffer);
  static final _$approve = $grpc.ClientMethod<$0.SampleServiceApproveRequest,
          $0.SampleServiceApproveResponse>(
      '/creativanta.commerce.v1.SampleService/Approve',
      ($0.SampleServiceApproveRequest value) => value.writeToBuffer(),
      $0.SampleServiceApproveResponse.fromBuffer);
  static final _$decline = $grpc.ClientMethod<$0.SampleServiceDeclineRequest,
          $0.SampleServiceDeclineResponse>(
      '/creativanta.commerce.v1.SampleService/Decline',
      ($0.SampleServiceDeclineRequest value) => value.writeToBuffer(),
      $0.SampleServiceDeclineResponse.fromBuffer);
  static final _$cancel = $grpc.ClientMethod<$0.SampleServiceCancelRequest,
          $0.SampleServiceCancelResponse>(
      '/creativanta.commerce.v1.SampleService/Cancel',
      ($0.SampleServiceCancelRequest value) => value.writeToBuffer(),
      $0.SampleServiceCancelResponse.fromBuffer);
  static final _$markShipped = $grpc.ClientMethod<
          $0.SampleServiceMarkShippedRequest,
          $0.SampleServiceMarkShippedResponse>(
      '/creativanta.commerce.v1.SampleService/MarkShipped',
      ($0.SampleServiceMarkShippedRequest value) => value.writeToBuffer(),
      $0.SampleServiceMarkShippedResponse.fromBuffer);
  static final _$markReceived = $grpc.ClientMethod<
          $0.SampleServiceMarkReceivedRequest,
          $0.SampleServiceMarkReceivedResponse>(
      '/creativanta.commerce.v1.SampleService/MarkReceived',
      ($0.SampleServiceMarkReceivedRequest value) => value.writeToBuffer(),
      $0.SampleServiceMarkReceivedResponse.fromBuffer);
  static final _$updateStatus = $grpc.ClientMethod<
          $0.SampleServiceUpdateStatusRequest,
          $0.SampleServiceUpdateStatusResponse>(
      '/creativanta.commerce.v1.SampleService/UpdateStatus',
      ($0.SampleServiceUpdateStatusRequest value) => value.writeToBuffer(),
      $0.SampleServiceUpdateStatusResponse.fromBuffer);
  static final _$getSummary = $grpc.ClientMethod<
          $0.SampleServiceGetSummaryRequest,
          $0.SampleServiceGetSummaryResponse>(
      '/creativanta.commerce.v1.SampleService/GetSummary',
      ($0.SampleServiceGetSummaryRequest value) => value.writeToBuffer(),
      $0.SampleServiceGetSummaryResponse.fromBuffer);
  static final _$getStats = $grpc.ClientMethod<$0.SampleServiceGetStatsRequest,
          $0.SampleServiceGetStatsResponse>(
      '/creativanta.commerce.v1.SampleService/GetStats',
      ($0.SampleServiceGetStatsRequest value) => value.writeToBuffer(),
      $0.SampleServiceGetStatsResponse.fromBuffer);
  static final _$linkReview = $grpc.ClientMethod<
          $0.SampleServiceLinkReviewRequest,
          $0.SampleServiceLinkReviewResponse>(
      '/creativanta.commerce.v1.SampleService/LinkReview',
      ($0.SampleServiceLinkReviewRequest value) => value.writeToBuffer(),
      $0.SampleServiceLinkReviewResponse.fromBuffer);
  static final _$rateCreator = $grpc.ClientMethod<
          $0.SampleServiceRateCreatorRequest,
          $0.SampleServiceRateCreatorResponse>(
      '/creativanta.commerce.v1.SampleService/RateCreator',
      ($0.SampleServiceRateCreatorRequest value) => value.writeToBuffer(),
      $0.SampleServiceRateCreatorResponse.fromBuffer);
  static final _$getReviewRevenue = $grpc.ClientMethod<
          $0.SampleServiceGetReviewRevenueRequest,
          $0.SampleServiceGetReviewRevenueResponse>(
      '/creativanta.commerce.v1.SampleService/GetReviewRevenue',
      ($0.SampleServiceGetReviewRevenueRequest value) => value.writeToBuffer(),
      $0.SampleServiceGetReviewRevenueResponse.fromBuffer);
  static final _$extendDeadline = $grpc.ClientMethod<
          $0.SampleServiceExtendDeadlineRequest,
          $0.SampleServiceExtendDeadlineResponse>(
      '/creativanta.commerce.v1.SampleService/ExtendDeadline',
      ($0.SampleServiceExtendDeadlineRequest value) => value.writeToBuffer(),
      $0.SampleServiceExtendDeadlineResponse.fromBuffer);
  static final _$exportReport = $grpc.ClientMethod<
          $0.SampleServiceExportReportRequest,
          $0.SampleServiceExportReportResponse>(
      '/creativanta.commerce.v1.SampleService/ExportReport',
      ($0.SampleServiceExportReportRequest value) => value.writeToBuffer(),
      $0.SampleServiceExportReportResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.SampleService')
abstract class SampleServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.SampleService';

  SampleServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SampleServiceCreateRequest,
            $0.SampleServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceCreateRequest.fromBuffer(value),
        ($0.SampleServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceListRequest,
            $0.SampleServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceListRequest.fromBuffer(value),
        ($0.SampleServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceApproveRequest,
            $0.SampleServiceApproveResponse>(
        'Approve',
        approve_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceApproveRequest.fromBuffer(value),
        ($0.SampleServiceApproveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceDeclineRequest,
            $0.SampleServiceDeclineResponse>(
        'Decline',
        decline_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceDeclineRequest.fromBuffer(value),
        ($0.SampleServiceDeclineResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceCancelRequest,
            $0.SampleServiceCancelResponse>(
        'Cancel',
        cancel_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceCancelRequest.fromBuffer(value),
        ($0.SampleServiceCancelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceMarkShippedRequest,
            $0.SampleServiceMarkShippedResponse>(
        'MarkShipped',
        markShipped_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceMarkShippedRequest.fromBuffer(value),
        ($0.SampleServiceMarkShippedResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceMarkReceivedRequest,
            $0.SampleServiceMarkReceivedResponse>(
        'MarkReceived',
        markReceived_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceMarkReceivedRequest.fromBuffer(value),
        ($0.SampleServiceMarkReceivedResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceUpdateStatusRequest,
            $0.SampleServiceUpdateStatusResponse>(
        'UpdateStatus',
        updateStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceUpdateStatusRequest.fromBuffer(value),
        ($0.SampleServiceUpdateStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceGetSummaryRequest,
            $0.SampleServiceGetSummaryResponse>(
        'GetSummary',
        getSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceGetSummaryRequest.fromBuffer(value),
        ($0.SampleServiceGetSummaryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceGetStatsRequest,
            $0.SampleServiceGetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceGetStatsRequest.fromBuffer(value),
        ($0.SampleServiceGetStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceLinkReviewRequest,
            $0.SampleServiceLinkReviewResponse>(
        'LinkReview',
        linkReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceLinkReviewRequest.fromBuffer(value),
        ($0.SampleServiceLinkReviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceRateCreatorRequest,
            $0.SampleServiceRateCreatorResponse>(
        'RateCreator',
        rateCreator_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceRateCreatorRequest.fromBuffer(value),
        ($0.SampleServiceRateCreatorResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceGetReviewRevenueRequest,
            $0.SampleServiceGetReviewRevenueResponse>(
        'GetReviewRevenue',
        getReviewRevenue_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceGetReviewRevenueRequest.fromBuffer(value),
        ($0.SampleServiceGetReviewRevenueResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceExtendDeadlineRequest,
            $0.SampleServiceExtendDeadlineResponse>(
        'ExtendDeadline',
        extendDeadline_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceExtendDeadlineRequest.fromBuffer(value),
        ($0.SampleServiceExtendDeadlineResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SampleServiceExportReportRequest,
            $0.SampleServiceExportReportResponse>(
        'ExportReport',
        exportReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SampleServiceExportReportRequest.fromBuffer(value),
        ($0.SampleServiceExportReportResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SampleServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.SampleServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.SampleServiceCreateRequest request);

  $async.Future<$0.SampleServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.SampleServiceListResponse> list(
      $grpc.ServiceCall call, $0.SampleServiceListRequest request);

  $async.Future<$0.SampleServiceApproveResponse> approve_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceApproveRequest> $request) async {
    return approve($call, await $request);
  }

  $async.Future<$0.SampleServiceApproveResponse> approve(
      $grpc.ServiceCall call, $0.SampleServiceApproveRequest request);

  $async.Future<$0.SampleServiceDeclineResponse> decline_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceDeclineRequest> $request) async {
    return decline($call, await $request);
  }

  $async.Future<$0.SampleServiceDeclineResponse> decline(
      $grpc.ServiceCall call, $0.SampleServiceDeclineRequest request);

  $async.Future<$0.SampleServiceCancelResponse> cancel_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceCancelRequest> $request) async {
    return cancel($call, await $request);
  }

  $async.Future<$0.SampleServiceCancelResponse> cancel(
      $grpc.ServiceCall call, $0.SampleServiceCancelRequest request);

  $async.Future<$0.SampleServiceMarkShippedResponse> markShipped_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceMarkShippedRequest> $request) async {
    return markShipped($call, await $request);
  }

  $async.Future<$0.SampleServiceMarkShippedResponse> markShipped(
      $grpc.ServiceCall call, $0.SampleServiceMarkShippedRequest request);

  $async.Future<$0.SampleServiceMarkReceivedResponse> markReceived_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceMarkReceivedRequest> $request) async {
    return markReceived($call, await $request);
  }

  $async.Future<$0.SampleServiceMarkReceivedResponse> markReceived(
      $grpc.ServiceCall call, $0.SampleServiceMarkReceivedRequest request);

  $async.Future<$0.SampleServiceUpdateStatusResponse> updateStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceUpdateStatusRequest> $request) async {
    return updateStatus($call, await $request);
  }

  $async.Future<$0.SampleServiceUpdateStatusResponse> updateStatus(
      $grpc.ServiceCall call, $0.SampleServiceUpdateStatusRequest request);

  $async.Future<$0.SampleServiceGetSummaryResponse> getSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceGetSummaryRequest> $request) async {
    return getSummary($call, await $request);
  }

  $async.Future<$0.SampleServiceGetSummaryResponse> getSummary(
      $grpc.ServiceCall call, $0.SampleServiceGetSummaryRequest request);

  $async.Future<$0.SampleServiceGetStatsResponse> getStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceGetStatsRequest> $request) async {
    return getStats($call, await $request);
  }

  $async.Future<$0.SampleServiceGetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.SampleServiceGetStatsRequest request);

  $async.Future<$0.SampleServiceLinkReviewResponse> linkReview_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceLinkReviewRequest> $request) async {
    return linkReview($call, await $request);
  }

  $async.Future<$0.SampleServiceLinkReviewResponse> linkReview(
      $grpc.ServiceCall call, $0.SampleServiceLinkReviewRequest request);

  $async.Future<$0.SampleServiceRateCreatorResponse> rateCreator_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceRateCreatorRequest> $request) async {
    return rateCreator($call, await $request);
  }

  $async.Future<$0.SampleServiceRateCreatorResponse> rateCreator(
      $grpc.ServiceCall call, $0.SampleServiceRateCreatorRequest request);

  $async.Future<$0.SampleServiceGetReviewRevenueResponse> getReviewRevenue_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceGetReviewRevenueRequest> $request) async {
    return getReviewRevenue($call, await $request);
  }

  $async.Future<$0.SampleServiceGetReviewRevenueResponse> getReviewRevenue(
      $grpc.ServiceCall call, $0.SampleServiceGetReviewRevenueRequest request);

  $async.Future<$0.SampleServiceExtendDeadlineResponse> extendDeadline_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceExtendDeadlineRequest> $request) async {
    return extendDeadline($call, await $request);
  }

  $async.Future<$0.SampleServiceExtendDeadlineResponse> extendDeadline(
      $grpc.ServiceCall call, $0.SampleServiceExtendDeadlineRequest request);

  $async.Future<$0.SampleServiceExportReportResponse> exportReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SampleServiceExportReportRequest> $request) async {
    return exportReport($call, await $request);
  }

  $async.Future<$0.SampleServiceExportReportResponse> exportReport(
      $grpc.ServiceCall call, $0.SampleServiceExportReportRequest request);
}

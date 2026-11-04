// This is a generated file - do not edit.
//
// Generated from creativanta/publish/v1/publish.proto.

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

import 'publish.pb.dart' as $0;

export 'publish.pb.dart';

/// PublishService is the multi-platform publish orchestrator (M11).
@$pb.GrpcServiceName('creativanta.publish.v1.PublishService')
class PublishServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PublishServiceClient(super.channel, {super.options, super.interceptors});

  /// Core M11 RPCs (api_endpoint_map.md §2.4)
  $grpc.ResponseFuture<$0.CreateItemResponse> createItem(
    $0.CreateItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScheduleResponse> schedule(
    $0.ScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$schedule, request, options: options);
  }

  $grpc.ResponseFuture<$0.ExecuteResponse> execute(
    $0.ExecuteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$execute, request, options: options);
  }

  $grpc.ResponseFuture<$0.RetryResponse> retry(
    $0.RetryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$retry, request, options: options);
  }

  $grpc.ResponseFuture<$0.CancelResponse> cancel(
    $0.CancelRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancel, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListQueueResponse> listQueue(
    $0.ListQueueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listQueue, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetLogsResponse> getLogs(
    $0.GetLogsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLogs, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetDiagnosticsResponse> getDiagnostics(
    $0.GetDiagnosticsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDiagnostics, request, options: options);
  }

  /// Acceptance targets & critical flows
  $grpc.ResponseFuture<$0.SubmitManualProofResponse> submitManualProof(
    $0.SubmitManualProofRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$submitManualProof, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReconcilePublishResponse> reconcilePublish(
    $0.ReconcilePublishRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reconcilePublish, request, options: options);
  }

  $grpc.ResponseFuture<$0.ExportManualPackageResponse> exportManualPackage(
    $0.ExportManualPackageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exportManualPackage, request, options: options);
  }

  $grpc.ResponseFuture<$0.PauseQueueResponse> pauseQueue(
    $0.PauseQueueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pauseQueue, request, options: options);
  }

  /// Extended Publish RPCs (api_endpoint_map.md §12.1)
  $grpc.ResponseFuture<$0.GetResponse> get(
    $0.GetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListResponse> list(
    $0.ListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetDraftResponse> getDraft(
    $0.GetDraftRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDraft, request, options: options);
  }

  $grpc.ResponseFuture<$0.SaveDraftResponse> saveDraft(
    $0.SaveDraftRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$saveDraft, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateDraftResponse> updateDraft(
    $0.UpdateDraftRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateDraft, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListDraftsResponse> listDrafts(
    $0.ListDraftsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listDrafts, request, options: options);
  }

  $grpc.ResponseFuture<$0.PublishNowResponse> publishNow(
    $0.PublishNowRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$publishNow, request, options: options);
  }

  $grpc.ResponseFuture<$0.RescheduleResponse> reschedule(
    $0.RescheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reschedule, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteResponse> delete(
    $0.DeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.DuplicateResponse> duplicate(
    $0.DuplicateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$duplicate, request, options: options);
  }

  $grpc.ResponseFuture<$0.PauseResponse> pause(
    $0.PauseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pause, request, options: options);
  }

  $grpc.ResponseFuture<$0.CheckCompatibilityResponse> checkCompatibility(
    $0.CheckCompatibilityRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkCompatibility, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateMetadataResponse> updateMetadata(
    $0.UpdateMetadataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateMetadata, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCalendarResponse> getCalendar(
    $0.GetCalendarRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCalendar, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListByDateRangeResponse> listByDateRange(
    $0.ListByDateRangeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listByDateRange, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListUpcomingResponse> listUpcoming(
    $0.ListUpcomingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listUpcoming, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPublishedResponse> listPublished(
    $0.ListPublishedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPublished, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPostsResponse> listPosts(
    $0.ListPostsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPosts, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPlatformStatusResponse> getPlatformStatus(
    $0.GetPlatformStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPlatformStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetCrossPostInsightsResponse> getCrossPostInsights(
    $0.GetCrossPostInsightsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCrossPostInsights, request, options: options);
  }

  $grpc.ResponseFuture<$0.PublishVariantsResponse> publishVariants(
    $0.PublishVariantsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$publishVariants, request, options: options);
  }

  $grpc.ResponseFuture<$0.HoldScheduleResponse> holdSchedule(
    $0.HoldScheduleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$holdSchedule, request, options: options);
  }

  $grpc.ResponseFuture<$0.ScheduleRetryResponse> scheduleRetry(
    $0.ScheduleRetryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$scheduleRetry, request, options: options);
  }

  $grpc.ResponseFuture<$0.TagProductResponse> tagProduct(
    $0.TagProductRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$tagProduct, request, options: options);
  }

  $grpc.ResponseFuture<$0.UntagProductResponse> untagProduct(
    $0.UntagProductRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$untagProduct, request, options: options);
  }

  // method descriptors

  static final _$createItem =
      $grpc.ClientMethod<$0.CreateItemRequest, $0.CreateItemResponse>(
          '/creativanta.publish.v1.PublishService/CreateItem',
          ($0.CreateItemRequest value) => value.writeToBuffer(),
          $0.CreateItemResponse.fromBuffer);
  static final _$schedule =
      $grpc.ClientMethod<$0.ScheduleRequest, $0.ScheduleResponse>(
          '/creativanta.publish.v1.PublishService/Schedule',
          ($0.ScheduleRequest value) => value.writeToBuffer(),
          $0.ScheduleResponse.fromBuffer);
  static final _$execute =
      $grpc.ClientMethod<$0.ExecuteRequest, $0.ExecuteResponse>(
          '/creativanta.publish.v1.PublishService/Execute',
          ($0.ExecuteRequest value) => value.writeToBuffer(),
          $0.ExecuteResponse.fromBuffer);
  static final _$retry = $grpc.ClientMethod<$0.RetryRequest, $0.RetryResponse>(
      '/creativanta.publish.v1.PublishService/Retry',
      ($0.RetryRequest value) => value.writeToBuffer(),
      $0.RetryResponse.fromBuffer);
  static final _$cancel =
      $grpc.ClientMethod<$0.CancelRequest, $0.CancelResponse>(
          '/creativanta.publish.v1.PublishService/Cancel',
          ($0.CancelRequest value) => value.writeToBuffer(),
          $0.CancelResponse.fromBuffer);
  static final _$listQueue =
      $grpc.ClientMethod<$0.ListQueueRequest, $0.ListQueueResponse>(
          '/creativanta.publish.v1.PublishService/ListQueue',
          ($0.ListQueueRequest value) => value.writeToBuffer(),
          $0.ListQueueResponse.fromBuffer);
  static final _$getLogs =
      $grpc.ClientMethod<$0.GetLogsRequest, $0.GetLogsResponse>(
          '/creativanta.publish.v1.PublishService/GetLogs',
          ($0.GetLogsRequest value) => value.writeToBuffer(),
          $0.GetLogsResponse.fromBuffer);
  static final _$getDiagnostics =
      $grpc.ClientMethod<$0.GetDiagnosticsRequest, $0.GetDiagnosticsResponse>(
          '/creativanta.publish.v1.PublishService/GetDiagnostics',
          ($0.GetDiagnosticsRequest value) => value.writeToBuffer(),
          $0.GetDiagnosticsResponse.fromBuffer);
  static final _$submitManualProof = $grpc.ClientMethod<
          $0.SubmitManualProofRequest, $0.SubmitManualProofResponse>(
      '/creativanta.publish.v1.PublishService/SubmitManualProof',
      ($0.SubmitManualProofRequest value) => value.writeToBuffer(),
      $0.SubmitManualProofResponse.fromBuffer);
  static final _$reconcilePublish = $grpc.ClientMethod<
          $0.ReconcilePublishRequest, $0.ReconcilePublishResponse>(
      '/creativanta.publish.v1.PublishService/ReconcilePublish',
      ($0.ReconcilePublishRequest value) => value.writeToBuffer(),
      $0.ReconcilePublishResponse.fromBuffer);
  static final _$exportManualPackage = $grpc.ClientMethod<
          $0.ExportManualPackageRequest, $0.ExportManualPackageResponse>(
      '/creativanta.publish.v1.PublishService/ExportManualPackage',
      ($0.ExportManualPackageRequest value) => value.writeToBuffer(),
      $0.ExportManualPackageResponse.fromBuffer);
  static final _$pauseQueue =
      $grpc.ClientMethod<$0.PauseQueueRequest, $0.PauseQueueResponse>(
          '/creativanta.publish.v1.PublishService/PauseQueue',
          ($0.PauseQueueRequest value) => value.writeToBuffer(),
          $0.PauseQueueResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.GetRequest, $0.GetResponse>(
      '/creativanta.publish.v1.PublishService/Get',
      ($0.GetRequest value) => value.writeToBuffer(),
      $0.GetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
      '/creativanta.publish.v1.PublishService/List',
      ($0.ListRequest value) => value.writeToBuffer(),
      $0.ListResponse.fromBuffer);
  static final _$getDraft =
      $grpc.ClientMethod<$0.GetDraftRequest, $0.GetDraftResponse>(
          '/creativanta.publish.v1.PublishService/GetDraft',
          ($0.GetDraftRequest value) => value.writeToBuffer(),
          $0.GetDraftResponse.fromBuffer);
  static final _$saveDraft =
      $grpc.ClientMethod<$0.SaveDraftRequest, $0.SaveDraftResponse>(
          '/creativanta.publish.v1.PublishService/SaveDraft',
          ($0.SaveDraftRequest value) => value.writeToBuffer(),
          $0.SaveDraftResponse.fromBuffer);
  static final _$updateDraft =
      $grpc.ClientMethod<$0.UpdateDraftRequest, $0.UpdateDraftResponse>(
          '/creativanta.publish.v1.PublishService/UpdateDraft',
          ($0.UpdateDraftRequest value) => value.writeToBuffer(),
          $0.UpdateDraftResponse.fromBuffer);
  static final _$listDrafts =
      $grpc.ClientMethod<$0.ListDraftsRequest, $0.ListDraftsResponse>(
          '/creativanta.publish.v1.PublishService/ListDrafts',
          ($0.ListDraftsRequest value) => value.writeToBuffer(),
          $0.ListDraftsResponse.fromBuffer);
  static final _$publishNow =
      $grpc.ClientMethod<$0.PublishNowRequest, $0.PublishNowResponse>(
          '/creativanta.publish.v1.PublishService/PublishNow',
          ($0.PublishNowRequest value) => value.writeToBuffer(),
          $0.PublishNowResponse.fromBuffer);
  static final _$reschedule =
      $grpc.ClientMethod<$0.RescheduleRequest, $0.RescheduleResponse>(
          '/creativanta.publish.v1.PublishService/Reschedule',
          ($0.RescheduleRequest value) => value.writeToBuffer(),
          $0.RescheduleResponse.fromBuffer);
  static final _$delete =
      $grpc.ClientMethod<$0.DeleteRequest, $0.DeleteResponse>(
          '/creativanta.publish.v1.PublishService/Delete',
          ($0.DeleteRequest value) => value.writeToBuffer(),
          $0.DeleteResponse.fromBuffer);
  static final _$duplicate =
      $grpc.ClientMethod<$0.DuplicateRequest, $0.DuplicateResponse>(
          '/creativanta.publish.v1.PublishService/Duplicate',
          ($0.DuplicateRequest value) => value.writeToBuffer(),
          $0.DuplicateResponse.fromBuffer);
  static final _$pause = $grpc.ClientMethod<$0.PauseRequest, $0.PauseResponse>(
      '/creativanta.publish.v1.PublishService/Pause',
      ($0.PauseRequest value) => value.writeToBuffer(),
      $0.PauseResponse.fromBuffer);
  static final _$checkCompatibility = $grpc.ClientMethod<
          $0.CheckCompatibilityRequest, $0.CheckCompatibilityResponse>(
      '/creativanta.publish.v1.PublishService/CheckCompatibility',
      ($0.CheckCompatibilityRequest value) => value.writeToBuffer(),
      $0.CheckCompatibilityResponse.fromBuffer);
  static final _$updateMetadata =
      $grpc.ClientMethod<$0.UpdateMetadataRequest, $0.UpdateMetadataResponse>(
          '/creativanta.publish.v1.PublishService/UpdateMetadata',
          ($0.UpdateMetadataRequest value) => value.writeToBuffer(),
          $0.UpdateMetadataResponse.fromBuffer);
  static final _$getCalendar =
      $grpc.ClientMethod<$0.GetCalendarRequest, $0.GetCalendarResponse>(
          '/creativanta.publish.v1.PublishService/GetCalendar',
          ($0.GetCalendarRequest value) => value.writeToBuffer(),
          $0.GetCalendarResponse.fromBuffer);
  static final _$listByDateRange =
      $grpc.ClientMethod<$0.ListByDateRangeRequest, $0.ListByDateRangeResponse>(
          '/creativanta.publish.v1.PublishService/ListByDateRange',
          ($0.ListByDateRangeRequest value) => value.writeToBuffer(),
          $0.ListByDateRangeResponse.fromBuffer);
  static final _$listUpcoming =
      $grpc.ClientMethod<$0.ListUpcomingRequest, $0.ListUpcomingResponse>(
          '/creativanta.publish.v1.PublishService/ListUpcoming',
          ($0.ListUpcomingRequest value) => value.writeToBuffer(),
          $0.ListUpcomingResponse.fromBuffer);
  static final _$listPublished =
      $grpc.ClientMethod<$0.ListPublishedRequest, $0.ListPublishedResponse>(
          '/creativanta.publish.v1.PublishService/ListPublished',
          ($0.ListPublishedRequest value) => value.writeToBuffer(),
          $0.ListPublishedResponse.fromBuffer);
  static final _$listPosts =
      $grpc.ClientMethod<$0.ListPostsRequest, $0.ListPostsResponse>(
          '/creativanta.publish.v1.PublishService/ListPosts',
          ($0.ListPostsRequest value) => value.writeToBuffer(),
          $0.ListPostsResponse.fromBuffer);
  static final _$getPlatformStatus = $grpc.ClientMethod<
          $0.GetPlatformStatusRequest, $0.GetPlatformStatusResponse>(
      '/creativanta.publish.v1.PublishService/GetPlatformStatus',
      ($0.GetPlatformStatusRequest value) => value.writeToBuffer(),
      $0.GetPlatformStatusResponse.fromBuffer);
  static final _$getCrossPostInsights = $grpc.ClientMethod<
          $0.GetCrossPostInsightsRequest, $0.GetCrossPostInsightsResponse>(
      '/creativanta.publish.v1.PublishService/GetCrossPostInsights',
      ($0.GetCrossPostInsightsRequest value) => value.writeToBuffer(),
      $0.GetCrossPostInsightsResponse.fromBuffer);
  static final _$publishVariants =
      $grpc.ClientMethod<$0.PublishVariantsRequest, $0.PublishVariantsResponse>(
          '/creativanta.publish.v1.PublishService/PublishVariants',
          ($0.PublishVariantsRequest value) => value.writeToBuffer(),
          $0.PublishVariantsResponse.fromBuffer);
  static final _$holdSchedule =
      $grpc.ClientMethod<$0.HoldScheduleRequest, $0.HoldScheduleResponse>(
          '/creativanta.publish.v1.PublishService/HoldSchedule',
          ($0.HoldScheduleRequest value) => value.writeToBuffer(),
          $0.HoldScheduleResponse.fromBuffer);
  static final _$scheduleRetry =
      $grpc.ClientMethod<$0.ScheduleRetryRequest, $0.ScheduleRetryResponse>(
          '/creativanta.publish.v1.PublishService/ScheduleRetry',
          ($0.ScheduleRetryRequest value) => value.writeToBuffer(),
          $0.ScheduleRetryResponse.fromBuffer);
  static final _$tagProduct =
      $grpc.ClientMethod<$0.TagProductRequest, $0.TagProductResponse>(
          '/creativanta.publish.v1.PublishService/TagProduct',
          ($0.TagProductRequest value) => value.writeToBuffer(),
          $0.TagProductResponse.fromBuffer);
  static final _$untagProduct =
      $grpc.ClientMethod<$0.UntagProductRequest, $0.UntagProductResponse>(
          '/creativanta.publish.v1.PublishService/UntagProduct',
          ($0.UntagProductRequest value) => value.writeToBuffer(),
          $0.UntagProductResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.publish.v1.PublishService')
abstract class PublishServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.publish.v1.PublishService';

  PublishServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateItemRequest, $0.CreateItemResponse>(
        'CreateItem',
        createItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateItemRequest.fromBuffer(value),
        ($0.CreateItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScheduleRequest, $0.ScheduleResponse>(
        'Schedule',
        schedule_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ScheduleRequest.fromBuffer(value),
        ($0.ScheduleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExecuteRequest, $0.ExecuteResponse>(
        'Execute',
        execute_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ExecuteRequest.fromBuffer(value),
        ($0.ExecuteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RetryRequest, $0.RetryResponse>(
        'Retry',
        retry_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RetryRequest.fromBuffer(value),
        ($0.RetryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelRequest, $0.CancelResponse>(
        'Cancel',
        cancel_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CancelRequest.fromBuffer(value),
        ($0.CancelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListQueueRequest, $0.ListQueueResponse>(
        'ListQueue',
        listQueue_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListQueueRequest.fromBuffer(value),
        ($0.ListQueueResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLogsRequest, $0.GetLogsResponse>(
        'GetLogs',
        getLogs_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetLogsRequest.fromBuffer(value),
        ($0.GetLogsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDiagnosticsRequest,
            $0.GetDiagnosticsResponse>(
        'GetDiagnostics',
        getDiagnostics_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDiagnosticsRequest.fromBuffer(value),
        ($0.GetDiagnosticsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubmitManualProofRequest,
            $0.SubmitManualProofResponse>(
        'SubmitManualProof',
        submitManualProof_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SubmitManualProofRequest.fromBuffer(value),
        ($0.SubmitManualProofResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconcilePublishRequest,
            $0.ReconcilePublishResponse>(
        'ReconcilePublish',
        reconcilePublish_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconcilePublishRequest.fromBuffer(value),
        ($0.ReconcilePublishResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExportManualPackageRequest,
            $0.ExportManualPackageResponse>(
        'ExportManualPackage',
        exportManualPackage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExportManualPackageRequest.fromBuffer(value),
        ($0.ExportManualPackageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PauseQueueRequest, $0.PauseQueueResponse>(
        'PauseQueue',
        pauseQueue_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PauseQueueRequest.fromBuffer(value),
        ($0.PauseQueueResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRequest, $0.GetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetRequest.fromBuffer(value),
        ($0.GetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRequest, $0.ListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRequest.fromBuffer(value),
        ($0.ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDraftRequest, $0.GetDraftResponse>(
        'GetDraft',
        getDraft_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetDraftRequest.fromBuffer(value),
        ($0.GetDraftResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SaveDraftRequest, $0.SaveDraftResponse>(
        'SaveDraft',
        saveDraft_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SaveDraftRequest.fromBuffer(value),
        ($0.SaveDraftResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateDraftRequest, $0.UpdateDraftResponse>(
            'UpdateDraft',
            updateDraft_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateDraftRequest.fromBuffer(value),
            ($0.UpdateDraftResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListDraftsRequest, $0.ListDraftsResponse>(
        'ListDrafts',
        listDrafts_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListDraftsRequest.fromBuffer(value),
        ($0.ListDraftsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PublishNowRequest, $0.PublishNowResponse>(
        'PublishNow',
        publishNow_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PublishNowRequest.fromBuffer(value),
        ($0.PublishNowResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RescheduleRequest, $0.RescheduleResponse>(
        'Reschedule',
        reschedule_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RescheduleRequest.fromBuffer(value),
        ($0.RescheduleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteRequest, $0.DeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteRequest.fromBuffer(value),
        ($0.DeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DuplicateRequest, $0.DuplicateResponse>(
        'Duplicate',
        duplicate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DuplicateRequest.fromBuffer(value),
        ($0.DuplicateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PauseRequest, $0.PauseResponse>(
        'Pause',
        pause_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PauseRequest.fromBuffer(value),
        ($0.PauseResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CheckCompatibilityRequest,
            $0.CheckCompatibilityResponse>(
        'CheckCompatibility',
        checkCompatibility_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CheckCompatibilityRequest.fromBuffer(value),
        ($0.CheckCompatibilityResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateMetadataRequest,
            $0.UpdateMetadataResponse>(
        'UpdateMetadata',
        updateMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateMetadataRequest.fromBuffer(value),
        ($0.UpdateMetadataResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetCalendarRequest, $0.GetCalendarResponse>(
            'GetCalendar',
            getCalendar_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetCalendarRequest.fromBuffer(value),
            ($0.GetCalendarResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListByDateRangeRequest,
            $0.ListByDateRangeResponse>(
        'ListByDateRange',
        listByDateRange_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListByDateRangeRequest.fromBuffer(value),
        ($0.ListByDateRangeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListUpcomingRequest, $0.ListUpcomingResponse>(
            'ListUpcoming',
            listUpcoming_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListUpcomingRequest.fromBuffer(value),
            ($0.ListUpcomingResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPublishedRequest, $0.ListPublishedResponse>(
            'ListPublished',
            listPublished_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPublishedRequest.fromBuffer(value),
            ($0.ListPublishedResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPostsRequest, $0.ListPostsResponse>(
        'ListPosts',
        listPosts_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListPostsRequest.fromBuffer(value),
        ($0.ListPostsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPlatformStatusRequest,
            $0.GetPlatformStatusResponse>(
        'GetPlatformStatus',
        getPlatformStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPlatformStatusRequest.fromBuffer(value),
        ($0.GetPlatformStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCrossPostInsightsRequest,
            $0.GetCrossPostInsightsResponse>(
        'GetCrossPostInsights',
        getCrossPostInsights_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCrossPostInsightsRequest.fromBuffer(value),
        ($0.GetCrossPostInsightsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PublishVariantsRequest,
            $0.PublishVariantsResponse>(
        'PublishVariants',
        publishVariants_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PublishVariantsRequest.fromBuffer(value),
        ($0.PublishVariantsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.HoldScheduleRequest, $0.HoldScheduleResponse>(
            'HoldSchedule',
            holdSchedule_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.HoldScheduleRequest.fromBuffer(value),
            ($0.HoldScheduleResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ScheduleRetryRequest, $0.ScheduleRetryResponse>(
            'ScheduleRetry',
            scheduleRetry_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ScheduleRetryRequest.fromBuffer(value),
            ($0.ScheduleRetryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TagProductRequest, $0.TagProductResponse>(
        'TagProduct',
        tagProduct_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TagProductRequest.fromBuffer(value),
        ($0.TagProductResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UntagProductRequest, $0.UntagProductResponse>(
            'UntagProduct',
            untagProduct_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UntagProductRequest.fromBuffer(value),
            ($0.UntagProductResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateItemResponse> createItem_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateItemRequest> $request) async {
    return createItem($call, await $request);
  }

  $async.Future<$0.CreateItemResponse> createItem(
      $grpc.ServiceCall call, $0.CreateItemRequest request);

  $async.Future<$0.ScheduleResponse> schedule_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ScheduleRequest> $request) async {
    return schedule($call, await $request);
  }

  $async.Future<$0.ScheduleResponse> schedule(
      $grpc.ServiceCall call, $0.ScheduleRequest request);

  $async.Future<$0.ExecuteResponse> execute_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ExecuteRequest> $request) async {
    return execute($call, await $request);
  }

  $async.Future<$0.ExecuteResponse> execute(
      $grpc.ServiceCall call, $0.ExecuteRequest request);

  $async.Future<$0.RetryResponse> retry_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.RetryRequest> $request) async {
    return retry($call, await $request);
  }

  $async.Future<$0.RetryResponse> retry(
      $grpc.ServiceCall call, $0.RetryRequest request);

  $async.Future<$0.CancelResponse> cancel_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.CancelRequest> $request) async {
    return cancel($call, await $request);
  }

  $async.Future<$0.CancelResponse> cancel(
      $grpc.ServiceCall call, $0.CancelRequest request);

  $async.Future<$0.ListQueueResponse> listQueue_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListQueueRequest> $request) async {
    return listQueue($call, await $request);
  }

  $async.Future<$0.ListQueueResponse> listQueue(
      $grpc.ServiceCall call, $0.ListQueueRequest request);

  $async.Future<$0.GetLogsResponse> getLogs_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetLogsRequest> $request) async {
    return getLogs($call, await $request);
  }

  $async.Future<$0.GetLogsResponse> getLogs(
      $grpc.ServiceCall call, $0.GetLogsRequest request);

  $async.Future<$0.GetDiagnosticsResponse> getDiagnostics_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDiagnosticsRequest> $request) async {
    return getDiagnostics($call, await $request);
  }

  $async.Future<$0.GetDiagnosticsResponse> getDiagnostics(
      $grpc.ServiceCall call, $0.GetDiagnosticsRequest request);

  $async.Future<$0.SubmitManualProofResponse> submitManualProof_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SubmitManualProofRequest> $request) async {
    return submitManualProof($call, await $request);
  }

  $async.Future<$0.SubmitManualProofResponse> submitManualProof(
      $grpc.ServiceCall call, $0.SubmitManualProofRequest request);

  $async.Future<$0.ReconcilePublishResponse> reconcilePublish_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconcilePublishRequest> $request) async {
    return reconcilePublish($call, await $request);
  }

  $async.Future<$0.ReconcilePublishResponse> reconcilePublish(
      $grpc.ServiceCall call, $0.ReconcilePublishRequest request);

  $async.Future<$0.ExportManualPackageResponse> exportManualPackage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExportManualPackageRequest> $request) async {
    return exportManualPackage($call, await $request);
  }

  $async.Future<$0.ExportManualPackageResponse> exportManualPackage(
      $grpc.ServiceCall call, $0.ExportManualPackageRequest request);

  $async.Future<$0.PauseQueueResponse> pauseQueue_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PauseQueueRequest> $request) async {
    return pauseQueue($call, await $request);
  }

  $async.Future<$0.PauseQueueResponse> pauseQueue(
      $grpc.ServiceCall call, $0.PauseQueueRequest request);

  $async.Future<$0.GetResponse> get_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.GetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.GetResponse> get(
      $grpc.ServiceCall call, $0.GetRequest request);

  $async.Future<$0.ListResponse> list_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ListResponse> list(
      $grpc.ServiceCall call, $0.ListRequest request);

  $async.Future<$0.GetDraftResponse> getDraft_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetDraftRequest> $request) async {
    return getDraft($call, await $request);
  }

  $async.Future<$0.GetDraftResponse> getDraft(
      $grpc.ServiceCall call, $0.GetDraftRequest request);

  $async.Future<$0.SaveDraftResponse> saveDraft_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SaveDraftRequest> $request) async {
    return saveDraft($call, await $request);
  }

  $async.Future<$0.SaveDraftResponse> saveDraft(
      $grpc.ServiceCall call, $0.SaveDraftRequest request);

  $async.Future<$0.UpdateDraftResponse> updateDraft_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateDraftRequest> $request) async {
    return updateDraft($call, await $request);
  }

  $async.Future<$0.UpdateDraftResponse> updateDraft(
      $grpc.ServiceCall call, $0.UpdateDraftRequest request);

  $async.Future<$0.ListDraftsResponse> listDrafts_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListDraftsRequest> $request) async {
    return listDrafts($call, await $request);
  }

  $async.Future<$0.ListDraftsResponse> listDrafts(
      $grpc.ServiceCall call, $0.ListDraftsRequest request);

  $async.Future<$0.PublishNowResponse> publishNow_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PublishNowRequest> $request) async {
    return publishNow($call, await $request);
  }

  $async.Future<$0.PublishNowResponse> publishNow(
      $grpc.ServiceCall call, $0.PublishNowRequest request);

  $async.Future<$0.RescheduleResponse> reschedule_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RescheduleRequest> $request) async {
    return reschedule($call, await $request);
  }

  $async.Future<$0.RescheduleResponse> reschedule(
      $grpc.ServiceCall call, $0.RescheduleRequest request);

  $async.Future<$0.DeleteResponse> delete_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.DeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.DeleteResponse> delete(
      $grpc.ServiceCall call, $0.DeleteRequest request);

  $async.Future<$0.DuplicateResponse> duplicate_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DuplicateRequest> $request) async {
    return duplicate($call, await $request);
  }

  $async.Future<$0.DuplicateResponse> duplicate(
      $grpc.ServiceCall call, $0.DuplicateRequest request);

  $async.Future<$0.PauseResponse> pause_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.PauseRequest> $request) async {
    return pause($call, await $request);
  }

  $async.Future<$0.PauseResponse> pause(
      $grpc.ServiceCall call, $0.PauseRequest request);

  $async.Future<$0.CheckCompatibilityResponse> checkCompatibility_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CheckCompatibilityRequest> $request) async {
    return checkCompatibility($call, await $request);
  }

  $async.Future<$0.CheckCompatibilityResponse> checkCompatibility(
      $grpc.ServiceCall call, $0.CheckCompatibilityRequest request);

  $async.Future<$0.UpdateMetadataResponse> updateMetadata_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateMetadataRequest> $request) async {
    return updateMetadata($call, await $request);
  }

  $async.Future<$0.UpdateMetadataResponse> updateMetadata(
      $grpc.ServiceCall call, $0.UpdateMetadataRequest request);

  $async.Future<$0.GetCalendarResponse> getCalendar_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCalendarRequest> $request) async {
    return getCalendar($call, await $request);
  }

  $async.Future<$0.GetCalendarResponse> getCalendar(
      $grpc.ServiceCall call, $0.GetCalendarRequest request);

  $async.Future<$0.ListByDateRangeResponse> listByDateRange_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListByDateRangeRequest> $request) async {
    return listByDateRange($call, await $request);
  }

  $async.Future<$0.ListByDateRangeResponse> listByDateRange(
      $grpc.ServiceCall call, $0.ListByDateRangeRequest request);

  $async.Future<$0.ListUpcomingResponse> listUpcoming_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListUpcomingRequest> $request) async {
    return listUpcoming($call, await $request);
  }

  $async.Future<$0.ListUpcomingResponse> listUpcoming(
      $grpc.ServiceCall call, $0.ListUpcomingRequest request);

  $async.Future<$0.ListPublishedResponse> listPublished_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPublishedRequest> $request) async {
    return listPublished($call, await $request);
  }

  $async.Future<$0.ListPublishedResponse> listPublished(
      $grpc.ServiceCall call, $0.ListPublishedRequest request);

  $async.Future<$0.ListPostsResponse> listPosts_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListPostsRequest> $request) async {
    return listPosts($call, await $request);
  }

  $async.Future<$0.ListPostsResponse> listPosts(
      $grpc.ServiceCall call, $0.ListPostsRequest request);

  $async.Future<$0.GetPlatformStatusResponse> getPlatformStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPlatformStatusRequest> $request) async {
    return getPlatformStatus($call, await $request);
  }

  $async.Future<$0.GetPlatformStatusResponse> getPlatformStatus(
      $grpc.ServiceCall call, $0.GetPlatformStatusRequest request);

  $async.Future<$0.GetCrossPostInsightsResponse> getCrossPostInsights_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCrossPostInsightsRequest> $request) async {
    return getCrossPostInsights($call, await $request);
  }

  $async.Future<$0.GetCrossPostInsightsResponse> getCrossPostInsights(
      $grpc.ServiceCall call, $0.GetCrossPostInsightsRequest request);

  $async.Future<$0.PublishVariantsResponse> publishVariants_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PublishVariantsRequest> $request) async {
    return publishVariants($call, await $request);
  }

  $async.Future<$0.PublishVariantsResponse> publishVariants(
      $grpc.ServiceCall call, $0.PublishVariantsRequest request);

  $async.Future<$0.HoldScheduleResponse> holdSchedule_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.HoldScheduleRequest> $request) async {
    return holdSchedule($call, await $request);
  }

  $async.Future<$0.HoldScheduleResponse> holdSchedule(
      $grpc.ServiceCall call, $0.HoldScheduleRequest request);

  $async.Future<$0.ScheduleRetryResponse> scheduleRetry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ScheduleRetryRequest> $request) async {
    return scheduleRetry($call, await $request);
  }

  $async.Future<$0.ScheduleRetryResponse> scheduleRetry(
      $grpc.ServiceCall call, $0.ScheduleRetryRequest request);

  $async.Future<$0.TagProductResponse> tagProduct_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TagProductRequest> $request) async {
    return tagProduct($call, await $request);
  }

  $async.Future<$0.TagProductResponse> tagProduct(
      $grpc.ServiceCall call, $0.TagProductRequest request);

  $async.Future<$0.UntagProductResponse> untagProduct_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UntagProductRequest> $request) async {
    return untagProduct($call, await $request);
  }

  $async.Future<$0.UntagProductResponse> untagProduct(
      $grpc.ServiceCall call, $0.UntagProductRequest request);
}

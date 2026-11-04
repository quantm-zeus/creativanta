// This is a generated file - do not edit.
//
// Generated from creativanta/finance/v1/finance.proto.

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

import 'finance.pb.dart' as $0;

export 'finance.pb.dart';

@$pb.GrpcServiceName('creativanta.finance.v1.ProfitService')
class ProfitServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ProfitServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ProfitServiceGetSummaryResponse> getSummary(
    $0.ProfitServiceGetSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSummary, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProfitServiceDrillDownResponse> drillDown(
    $0.ProfitServiceDrillDownRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$drillDown, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProfitServiceGetAnomaliesResponse> getAnomalies(
    $0.ProfitServiceGetAnomaliesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAnomalies, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProfitServiceGetSnapshotResponse> getSnapshot(
    $0.ProfitServiceGetSnapshotRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSnapshot, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProfitServiceRefreshSnapshotResponse> refreshSnapshot(
    $0.ProfitServiceRefreshSnapshotRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$refreshSnapshot, request, options: options);
  }

  // method descriptors

  static final _$getSummary = $grpc.ClientMethod<
          $0.ProfitServiceGetSummaryRequest,
          $0.ProfitServiceGetSummaryResponse>(
      '/creativanta.finance.v1.ProfitService/GetSummary',
      ($0.ProfitServiceGetSummaryRequest value) => value.writeToBuffer(),
      $0.ProfitServiceGetSummaryResponse.fromBuffer);
  static final _$drillDown = $grpc.ClientMethod<
          $0.ProfitServiceDrillDownRequest, $0.ProfitServiceDrillDownResponse>(
      '/creativanta.finance.v1.ProfitService/DrillDown',
      ($0.ProfitServiceDrillDownRequest value) => value.writeToBuffer(),
      $0.ProfitServiceDrillDownResponse.fromBuffer);
  static final _$getAnomalies = $grpc.ClientMethod<
          $0.ProfitServiceGetAnomaliesRequest,
          $0.ProfitServiceGetAnomaliesResponse>(
      '/creativanta.finance.v1.ProfitService/GetAnomalies',
      ($0.ProfitServiceGetAnomaliesRequest value) => value.writeToBuffer(),
      $0.ProfitServiceGetAnomaliesResponse.fromBuffer);
  static final _$getSnapshot = $grpc.ClientMethod<
          $0.ProfitServiceGetSnapshotRequest,
          $0.ProfitServiceGetSnapshotResponse>(
      '/creativanta.finance.v1.ProfitService/GetSnapshot',
      ($0.ProfitServiceGetSnapshotRequest value) => value.writeToBuffer(),
      $0.ProfitServiceGetSnapshotResponse.fromBuffer);
  static final _$refreshSnapshot = $grpc.ClientMethod<
          $0.ProfitServiceRefreshSnapshotRequest,
          $0.ProfitServiceRefreshSnapshotResponse>(
      '/creativanta.finance.v1.ProfitService/RefreshSnapshot',
      ($0.ProfitServiceRefreshSnapshotRequest value) => value.writeToBuffer(),
      $0.ProfitServiceRefreshSnapshotResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.finance.v1.ProfitService')
abstract class ProfitServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.finance.v1.ProfitService';

  ProfitServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ProfitServiceGetSummaryRequest,
            $0.ProfitServiceGetSummaryResponse>(
        'GetSummary',
        getSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProfitServiceGetSummaryRequest.fromBuffer(value),
        ($0.ProfitServiceGetSummaryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfitServiceDrillDownRequest,
            $0.ProfitServiceDrillDownResponse>(
        'DrillDown',
        drillDown_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProfitServiceDrillDownRequest.fromBuffer(value),
        ($0.ProfitServiceDrillDownResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfitServiceGetAnomaliesRequest,
            $0.ProfitServiceGetAnomaliesResponse>(
        'GetAnomalies',
        getAnomalies_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProfitServiceGetAnomaliesRequest.fromBuffer(value),
        ($0.ProfitServiceGetAnomaliesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfitServiceGetSnapshotRequest,
            $0.ProfitServiceGetSnapshotResponse>(
        'GetSnapshot',
        getSnapshot_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProfitServiceGetSnapshotRequest.fromBuffer(value),
        ($0.ProfitServiceGetSnapshotResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfitServiceRefreshSnapshotRequest,
            $0.ProfitServiceRefreshSnapshotResponse>(
        'RefreshSnapshot',
        refreshSnapshot_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProfitServiceRefreshSnapshotRequest.fromBuffer(value),
        ($0.ProfitServiceRefreshSnapshotResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ProfitServiceGetSummaryResponse> getSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProfitServiceGetSummaryRequest> $request) async {
    return getSummary($call, await $request);
  }

  $async.Future<$0.ProfitServiceGetSummaryResponse> getSummary(
      $grpc.ServiceCall call, $0.ProfitServiceGetSummaryRequest request);

  $async.Future<$0.ProfitServiceDrillDownResponse> drillDown_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProfitServiceDrillDownRequest> $request) async {
    return drillDown($call, await $request);
  }

  $async.Future<$0.ProfitServiceDrillDownResponse> drillDown(
      $grpc.ServiceCall call, $0.ProfitServiceDrillDownRequest request);

  $async.Future<$0.ProfitServiceGetAnomaliesResponse> getAnomalies_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProfitServiceGetAnomaliesRequest> $request) async {
    return getAnomalies($call, await $request);
  }

  $async.Future<$0.ProfitServiceGetAnomaliesResponse> getAnomalies(
      $grpc.ServiceCall call, $0.ProfitServiceGetAnomaliesRequest request);

  $async.Future<$0.ProfitServiceGetSnapshotResponse> getSnapshot_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProfitServiceGetSnapshotRequest> $request) async {
    return getSnapshot($call, await $request);
  }

  $async.Future<$0.ProfitServiceGetSnapshotResponse> getSnapshot(
      $grpc.ServiceCall call, $0.ProfitServiceGetSnapshotRequest request);

  $async.Future<$0.ProfitServiceRefreshSnapshotResponse> refreshSnapshot_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProfitServiceRefreshSnapshotRequest> $request) async {
    return refreshSnapshot($call, await $request);
  }

  $async.Future<$0.ProfitServiceRefreshSnapshotResponse> refreshSnapshot(
      $grpc.ServiceCall call, $0.ProfitServiceRefreshSnapshotRequest request);
}

@$pb.GrpcServiceName('creativanta.finance.v1.SettlementService')
class SettlementServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SettlementServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SettlementServiceImportResponse> import(
    $0.SettlementServiceImportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$import, request, options: options);
  }

  $grpc.ResponseFuture<$0.SettlementServiceListResponse> list(
    $0.SettlementServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.SettlementServiceGetResponse> get(
    $0.SettlementServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  // method descriptors

  static final _$import = $grpc.ClientMethod<$0.SettlementServiceImportRequest,
          $0.SettlementServiceImportResponse>(
      '/creativanta.finance.v1.SettlementService/Import',
      ($0.SettlementServiceImportRequest value) => value.writeToBuffer(),
      $0.SettlementServiceImportResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.SettlementServiceListRequest,
          $0.SettlementServiceListResponse>(
      '/creativanta.finance.v1.SettlementService/List',
      ($0.SettlementServiceListRequest value) => value.writeToBuffer(),
      $0.SettlementServiceListResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.SettlementServiceGetRequest,
          $0.SettlementServiceGetResponse>(
      '/creativanta.finance.v1.SettlementService/Get',
      ($0.SettlementServiceGetRequest value) => value.writeToBuffer(),
      $0.SettlementServiceGetResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.finance.v1.SettlementService')
abstract class SettlementServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.finance.v1.SettlementService';

  SettlementServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SettlementServiceImportRequest,
            $0.SettlementServiceImportResponse>(
        'Import',
        import_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SettlementServiceImportRequest.fromBuffer(value),
        ($0.SettlementServiceImportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SettlementServiceListRequest,
            $0.SettlementServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SettlementServiceListRequest.fromBuffer(value),
        ($0.SettlementServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SettlementServiceGetRequest,
            $0.SettlementServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SettlementServiceGetRequest.fromBuffer(value),
        ($0.SettlementServiceGetResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SettlementServiceImportResponse> import_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SettlementServiceImportRequest> $request) async {
    return import($call, await $request);
  }

  $async.Future<$0.SettlementServiceImportResponse> import(
      $grpc.ServiceCall call, $0.SettlementServiceImportRequest request);

  $async.Future<$0.SettlementServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SettlementServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.SettlementServiceListResponse> list(
      $grpc.ServiceCall call, $0.SettlementServiceListRequest request);

  $async.Future<$0.SettlementServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SettlementServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.SettlementServiceGetResponse> get(
      $grpc.ServiceCall call, $0.SettlementServiceGetRequest request);
}

@$pb.GrpcServiceName('creativanta.finance.v1.CostService')
class CostServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CostServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CostServiceCreateResponse> create(
    $0.CostServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.CostServiceListResponse> list(
    $0.CostServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.CostServiceUpdateResponse> update(
    $0.CostServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.CostServiceDeleteResponse> delete(
    $0.CostServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.CostServiceCreateRequest,
          $0.CostServiceCreateResponse>(
      '/creativanta.finance.v1.CostService/Create',
      ($0.CostServiceCreateRequest value) => value.writeToBuffer(),
      $0.CostServiceCreateResponse.fromBuffer);
  static final _$list =
      $grpc.ClientMethod<$0.CostServiceListRequest, $0.CostServiceListResponse>(
          '/creativanta.finance.v1.CostService/List',
          ($0.CostServiceListRequest value) => value.writeToBuffer(),
          $0.CostServiceListResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.CostServiceUpdateRequest,
          $0.CostServiceUpdateResponse>(
      '/creativanta.finance.v1.CostService/Update',
      ($0.CostServiceUpdateRequest value) => value.writeToBuffer(),
      $0.CostServiceUpdateResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.CostServiceDeleteRequest,
          $0.CostServiceDeleteResponse>(
      '/creativanta.finance.v1.CostService/Delete',
      ($0.CostServiceDeleteRequest value) => value.writeToBuffer(),
      $0.CostServiceDeleteResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.finance.v1.CostService')
abstract class CostServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.finance.v1.CostService';

  CostServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CostServiceCreateRequest,
            $0.CostServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CostServiceCreateRequest.fromBuffer(value),
        ($0.CostServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CostServiceListRequest,
            $0.CostServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CostServiceListRequest.fromBuffer(value),
        ($0.CostServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CostServiceUpdateRequest,
            $0.CostServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CostServiceUpdateRequest.fromBuffer(value),
        ($0.CostServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CostServiceDeleteRequest,
            $0.CostServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CostServiceDeleteRequest.fromBuffer(value),
        ($0.CostServiceDeleteResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CostServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CostServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.CostServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.CostServiceCreateRequest request);

  $async.Future<$0.CostServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CostServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.CostServiceListResponse> list(
      $grpc.ServiceCall call, $0.CostServiceListRequest request);

  $async.Future<$0.CostServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CostServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.CostServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.CostServiceUpdateRequest request);

  $async.Future<$0.CostServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CostServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.CostServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.CostServiceDeleteRequest request);
}

@$pb.GrpcServiceName('creativanta.finance.v1.ReconciliationService')
class ReconciliationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ReconciliationServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ReconciliationServiceQueueResponse> queue(
    $0.ReconciliationServiceQueueRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$queue, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReconciliationServiceMatchResponse> match(
    $0.ReconciliationServiceMatchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$match, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReconciliationServiceManualMatchResponse> manualMatch(
    $0.ReconciliationServiceManualMatchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$manualMatch, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReconciliationServiceOverrideResponse> override(
    $0.ReconciliationServiceOverrideRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$override, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReconciliationServiceGetRecordResponse> getRecord(
    $0.ReconciliationServiceGetRecordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRecord, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReconciliationServiceListRecordsResponse> listRecords(
    $0.ReconciliationServiceListRecordsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRecords, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReconciliationServiceListPendingResponse> listPending(
    $0.ReconciliationServiceListPendingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPending, request, options: options);
  }

  // method descriptors

  static final _$queue = $grpc.ClientMethod<
          $0.ReconciliationServiceQueueRequest,
          $0.ReconciliationServiceQueueResponse>(
      '/creativanta.finance.v1.ReconciliationService/Queue',
      ($0.ReconciliationServiceQueueRequest value) => value.writeToBuffer(),
      $0.ReconciliationServiceQueueResponse.fromBuffer);
  static final _$match = $grpc.ClientMethod<
          $0.ReconciliationServiceMatchRequest,
          $0.ReconciliationServiceMatchResponse>(
      '/creativanta.finance.v1.ReconciliationService/Match',
      ($0.ReconciliationServiceMatchRequest value) => value.writeToBuffer(),
      $0.ReconciliationServiceMatchResponse.fromBuffer);
  static final _$manualMatch = $grpc.ClientMethod<
          $0.ReconciliationServiceManualMatchRequest,
          $0.ReconciliationServiceManualMatchResponse>(
      '/creativanta.finance.v1.ReconciliationService/ManualMatch',
      ($0.ReconciliationServiceManualMatchRequest value) =>
          value.writeToBuffer(),
      $0.ReconciliationServiceManualMatchResponse.fromBuffer);
  static final _$override = $grpc.ClientMethod<
          $0.ReconciliationServiceOverrideRequest,
          $0.ReconciliationServiceOverrideResponse>(
      '/creativanta.finance.v1.ReconciliationService/Override',
      ($0.ReconciliationServiceOverrideRequest value) => value.writeToBuffer(),
      $0.ReconciliationServiceOverrideResponse.fromBuffer);
  static final _$getRecord = $grpc.ClientMethod<
          $0.ReconciliationServiceGetRecordRequest,
          $0.ReconciliationServiceGetRecordResponse>(
      '/creativanta.finance.v1.ReconciliationService/GetRecord',
      ($0.ReconciliationServiceGetRecordRequest value) => value.writeToBuffer(),
      $0.ReconciliationServiceGetRecordResponse.fromBuffer);
  static final _$listRecords = $grpc.ClientMethod<
          $0.ReconciliationServiceListRecordsRequest,
          $0.ReconciliationServiceListRecordsResponse>(
      '/creativanta.finance.v1.ReconciliationService/ListRecords',
      ($0.ReconciliationServiceListRecordsRequest value) =>
          value.writeToBuffer(),
      $0.ReconciliationServiceListRecordsResponse.fromBuffer);
  static final _$listPending = $grpc.ClientMethod<
          $0.ReconciliationServiceListPendingRequest,
          $0.ReconciliationServiceListPendingResponse>(
      '/creativanta.finance.v1.ReconciliationService/ListPending',
      ($0.ReconciliationServiceListPendingRequest value) =>
          value.writeToBuffer(),
      $0.ReconciliationServiceListPendingResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.finance.v1.ReconciliationService')
abstract class ReconciliationServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.finance.v1.ReconciliationService';

  ReconciliationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ReconciliationServiceQueueRequest,
            $0.ReconciliationServiceQueueResponse>(
        'Queue',
        queue_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconciliationServiceQueueRequest.fromBuffer(value),
        ($0.ReconciliationServiceQueueResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconciliationServiceMatchRequest,
            $0.ReconciliationServiceMatchResponse>(
        'Match',
        match_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconciliationServiceMatchRequest.fromBuffer(value),
        ($0.ReconciliationServiceMatchResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconciliationServiceManualMatchRequest,
            $0.ReconciliationServiceManualMatchResponse>(
        'ManualMatch',
        manualMatch_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconciliationServiceManualMatchRequest.fromBuffer(value),
        ($0.ReconciliationServiceManualMatchResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconciliationServiceOverrideRequest,
            $0.ReconciliationServiceOverrideResponse>(
        'Override',
        override_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconciliationServiceOverrideRequest.fromBuffer(value),
        ($0.ReconciliationServiceOverrideResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconciliationServiceGetRecordRequest,
            $0.ReconciliationServiceGetRecordResponse>(
        'GetRecord',
        getRecord_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconciliationServiceGetRecordRequest.fromBuffer(value),
        ($0.ReconciliationServiceGetRecordResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconciliationServiceListRecordsRequest,
            $0.ReconciliationServiceListRecordsResponse>(
        'ListRecords',
        listRecords_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconciliationServiceListRecordsRequest.fromBuffer(value),
        ($0.ReconciliationServiceListRecordsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconciliationServiceListPendingRequest,
            $0.ReconciliationServiceListPendingResponse>(
        'ListPending',
        listPending_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconciliationServiceListPendingRequest.fromBuffer(value),
        ($0.ReconciliationServiceListPendingResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ReconciliationServiceQueueResponse> queue_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconciliationServiceQueueRequest> $request) async {
    return queue($call, await $request);
  }

  $async.Future<$0.ReconciliationServiceQueueResponse> queue(
      $grpc.ServiceCall call, $0.ReconciliationServiceQueueRequest request);

  $async.Future<$0.ReconciliationServiceMatchResponse> match_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconciliationServiceMatchRequest> $request) async {
    return match($call, await $request);
  }

  $async.Future<$0.ReconciliationServiceMatchResponse> match(
      $grpc.ServiceCall call, $0.ReconciliationServiceMatchRequest request);

  $async.Future<$0.ReconciliationServiceManualMatchResponse> manualMatch_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconciliationServiceManualMatchRequest>
          $request) async {
    return manualMatch($call, await $request);
  }

  $async.Future<$0.ReconciliationServiceManualMatchResponse> manualMatch(
      $grpc.ServiceCall call,
      $0.ReconciliationServiceManualMatchRequest request);

  $async.Future<$0.ReconciliationServiceOverrideResponse> override_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconciliationServiceOverrideRequest> $request) async {
    return override($call, await $request);
  }

  $async.Future<$0.ReconciliationServiceOverrideResponse> override(
      $grpc.ServiceCall call, $0.ReconciliationServiceOverrideRequest request);

  $async.Future<$0.ReconciliationServiceGetRecordResponse> getRecord_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconciliationServiceGetRecordRequest> $request) async {
    return getRecord($call, await $request);
  }

  $async.Future<$0.ReconciliationServiceGetRecordResponse> getRecord(
      $grpc.ServiceCall call, $0.ReconciliationServiceGetRecordRequest request);

  $async.Future<$0.ReconciliationServiceListRecordsResponse> listRecords_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconciliationServiceListRecordsRequest>
          $request) async {
    return listRecords($call, await $request);
  }

  $async.Future<$0.ReconciliationServiceListRecordsResponse> listRecords(
      $grpc.ServiceCall call,
      $0.ReconciliationServiceListRecordsRequest request);

  $async.Future<$0.ReconciliationServiceListPendingResponse> listPending_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReconciliationServiceListPendingRequest>
          $request) async {
    return listPending($call, await $request);
  }

  $async.Future<$0.ReconciliationServiceListPendingResponse> listPending(
      $grpc.ServiceCall call,
      $0.ReconciliationServiceListPendingRequest request);
}

@$pb.GrpcServiceName('creativanta.finance.v1.EvidenceService')
class EvidenceServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  EvidenceServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.EvidenceServiceSubmitResponse> submit(
    $0.EvidenceServiceSubmitRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$submit, request, options: options);
  }

  $grpc.ResponseFuture<$0.EvidenceServiceGetResponse> get(
    $0.EvidenceServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.EvidenceServiceListResponse> list(
    $0.EvidenceServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  // method descriptors

  static final _$submit = $grpc.ClientMethod<$0.EvidenceServiceSubmitRequest,
          $0.EvidenceServiceSubmitResponse>(
      '/creativanta.finance.v1.EvidenceService/Submit',
      ($0.EvidenceServiceSubmitRequest value) => value.writeToBuffer(),
      $0.EvidenceServiceSubmitResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.EvidenceServiceGetRequest,
          $0.EvidenceServiceGetResponse>(
      '/creativanta.finance.v1.EvidenceService/Get',
      ($0.EvidenceServiceGetRequest value) => value.writeToBuffer(),
      $0.EvidenceServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.EvidenceServiceListRequest,
          $0.EvidenceServiceListResponse>(
      '/creativanta.finance.v1.EvidenceService/List',
      ($0.EvidenceServiceListRequest value) => value.writeToBuffer(),
      $0.EvidenceServiceListResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.finance.v1.EvidenceService')
abstract class EvidenceServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.finance.v1.EvidenceService';

  EvidenceServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.EvidenceServiceSubmitRequest,
            $0.EvidenceServiceSubmitResponse>(
        'Submit',
        submit_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EvidenceServiceSubmitRequest.fromBuffer(value),
        ($0.EvidenceServiceSubmitResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EvidenceServiceGetRequest,
            $0.EvidenceServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EvidenceServiceGetRequest.fromBuffer(value),
        ($0.EvidenceServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EvidenceServiceListRequest,
            $0.EvidenceServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EvidenceServiceListRequest.fromBuffer(value),
        ($0.EvidenceServiceListResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.EvidenceServiceSubmitResponse> submit_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EvidenceServiceSubmitRequest> $request) async {
    return submit($call, await $request);
  }

  $async.Future<$0.EvidenceServiceSubmitResponse> submit(
      $grpc.ServiceCall call, $0.EvidenceServiceSubmitRequest request);

  $async.Future<$0.EvidenceServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.EvidenceServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.EvidenceServiceGetResponse> get(
      $grpc.ServiceCall call, $0.EvidenceServiceGetRequest request);

  $async.Future<$0.EvidenceServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EvidenceServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.EvidenceServiceListResponse> list(
      $grpc.ServiceCall call, $0.EvidenceServiceListRequest request);
}

@$pb.GrpcServiceName('creativanta.finance.v1.ProofService')
class ProofServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ProofServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ProofServiceAssembleResponse> assemble(
    $0.ProofServiceAssembleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$assemble, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProofServiceGetResponse> get(
    $0.ProofServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProofServiceListResponse> list(
    $0.ProofServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  // method descriptors

  static final _$assemble = $grpc.ClientMethod<$0.ProofServiceAssembleRequest,
          $0.ProofServiceAssembleResponse>(
      '/creativanta.finance.v1.ProofService/Assemble',
      ($0.ProofServiceAssembleRequest value) => value.writeToBuffer(),
      $0.ProofServiceAssembleResponse.fromBuffer);
  static final _$get =
      $grpc.ClientMethod<$0.ProofServiceGetRequest, $0.ProofServiceGetResponse>(
          '/creativanta.finance.v1.ProofService/Get',
          ($0.ProofServiceGetRequest value) => value.writeToBuffer(),
          $0.ProofServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.ProofServiceListRequest,
          $0.ProofServiceListResponse>(
      '/creativanta.finance.v1.ProofService/List',
      ($0.ProofServiceListRequest value) => value.writeToBuffer(),
      $0.ProofServiceListResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.finance.v1.ProofService')
abstract class ProofServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.finance.v1.ProofService';

  ProofServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ProofServiceAssembleRequest,
            $0.ProofServiceAssembleResponse>(
        'Assemble',
        assemble_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProofServiceAssembleRequest.fromBuffer(value),
        ($0.ProofServiceAssembleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProofServiceGetRequest,
            $0.ProofServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProofServiceGetRequest.fromBuffer(value),
        ($0.ProofServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProofServiceListRequest,
            $0.ProofServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProofServiceListRequest.fromBuffer(value),
        ($0.ProofServiceListResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ProofServiceAssembleResponse> assemble_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProofServiceAssembleRequest> $request) async {
    return assemble($call, await $request);
  }

  $async.Future<$0.ProofServiceAssembleResponse> assemble(
      $grpc.ServiceCall call, $0.ProofServiceAssembleRequest request);

  $async.Future<$0.ProofServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ProofServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.ProofServiceGetResponse> get(
      $grpc.ServiceCall call, $0.ProofServiceGetRequest request);

  $async.Future<$0.ProofServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ProofServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ProofServiceListResponse> list(
      $grpc.ServiceCall call, $0.ProofServiceListRequest request);
}

@$pb.GrpcServiceName('creativanta.finance.v1.ContentRevenueService')
class ContentRevenueServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ContentRevenueServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ContentRevenueServiceGetAttributionResponse>
      getAttribution(
    $0.ContentRevenueServiceGetAttributionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAttribution, request, options: options);
  }

  // method descriptors

  static final _$getAttribution = $grpc.ClientMethod<
          $0.ContentRevenueServiceGetAttributionRequest,
          $0.ContentRevenueServiceGetAttributionResponse>(
      '/creativanta.finance.v1.ContentRevenueService/GetAttribution',
      ($0.ContentRevenueServiceGetAttributionRequest value) =>
          value.writeToBuffer(),
      $0.ContentRevenueServiceGetAttributionResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.finance.v1.ContentRevenueService')
abstract class ContentRevenueServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.finance.v1.ContentRevenueService';

  ContentRevenueServiceBase() {
    $addMethod($grpc.ServiceMethod<
            $0.ContentRevenueServiceGetAttributionRequest,
            $0.ContentRevenueServiceGetAttributionResponse>(
        'GetAttribution',
        getAttribution_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ContentRevenueServiceGetAttributionRequest.fromBuffer(value),
        ($0.ContentRevenueServiceGetAttributionResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ContentRevenueServiceGetAttributionResponse>
      getAttribution_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.ContentRevenueServiceGetAttributionRequest>
              $request) async {
    return getAttribution($call, await $request);
  }

  $async.Future<$0.ContentRevenueServiceGetAttributionResponse> getAttribution(
      $grpc.ServiceCall call,
      $0.ContentRevenueServiceGetAttributionRequest request);
}

@$pb.GrpcServiceName('creativanta.finance.v1.AttributionService')
class AttributionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AttributionServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.AttributionServiceGetByContentResponse> getByContent(
    $0.AttributionServiceGetByContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getByContent, request, options: options);
  }

  $grpc.ResponseFuture<$0.AttributionServiceRecordAttributionResponse>
      recordAttribution(
    $0.AttributionServiceRecordAttributionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$recordAttribution, request, options: options);
  }

  // method descriptors

  static final _$getByContent = $grpc.ClientMethod<
          $0.AttributionServiceGetByContentRequest,
          $0.AttributionServiceGetByContentResponse>(
      '/creativanta.finance.v1.AttributionService/GetByContent',
      ($0.AttributionServiceGetByContentRequest value) => value.writeToBuffer(),
      $0.AttributionServiceGetByContentResponse.fromBuffer);
  static final _$recordAttribution = $grpc.ClientMethod<
          $0.AttributionServiceRecordAttributionRequest,
          $0.AttributionServiceRecordAttributionResponse>(
      '/creativanta.finance.v1.AttributionService/RecordAttribution',
      ($0.AttributionServiceRecordAttributionRequest value) =>
          value.writeToBuffer(),
      $0.AttributionServiceRecordAttributionResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.finance.v1.AttributionService')
abstract class AttributionServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.finance.v1.AttributionService';

  AttributionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AttributionServiceGetByContentRequest,
            $0.AttributionServiceGetByContentResponse>(
        'GetByContent',
        getByContent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AttributionServiceGetByContentRequest.fromBuffer(value),
        ($0.AttributionServiceGetByContentResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<
            $0.AttributionServiceRecordAttributionRequest,
            $0.AttributionServiceRecordAttributionResponse>(
        'RecordAttribution',
        recordAttribution_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AttributionServiceRecordAttributionRequest.fromBuffer(value),
        ($0.AttributionServiceRecordAttributionResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.AttributionServiceGetByContentResponse> getByContent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AttributionServiceGetByContentRequest> $request) async {
    return getByContent($call, await $request);
  }

  $async.Future<$0.AttributionServiceGetByContentResponse> getByContent(
      $grpc.ServiceCall call, $0.AttributionServiceGetByContentRequest request);

  $async.Future<$0.AttributionServiceRecordAttributionResponse>
      recordAttribution_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.AttributionServiceRecordAttributionRequest>
              $request) async {
    return recordAttribution($call, await $request);
  }

  $async.Future<$0.AttributionServiceRecordAttributionResponse>
      recordAttribution($grpc.ServiceCall call,
          $0.AttributionServiceRecordAttributionRequest request);
}

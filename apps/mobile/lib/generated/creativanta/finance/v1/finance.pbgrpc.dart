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

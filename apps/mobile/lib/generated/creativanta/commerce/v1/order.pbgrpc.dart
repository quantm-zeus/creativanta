// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/order.proto.

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

import 'order.pb.dart' as $0;

export 'order.pb.dart';

/// OrderService manages order lifecycle, ingestion, search, and status transitions.
@$pb.GrpcServiceName('creativanta.commerce.v1.OrderService')
class OrderServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  OrderServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.OrderServiceListResponse> list(
    $0.OrderServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceGetResponse> get(
    $0.OrderServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceImportResponse> import(
    $0.OrderServiceImportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$import, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceExportResponse> export(
    $0.OrderServiceExportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$export, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceUpdateStatusResponse> updateStatus(
    $0.OrderServiceUpdateStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceSearchResponse> search(
    $0.OrderServiceSearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$search, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceConfirmResponse> confirm(
    $0.OrderServiceConfirmRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$confirm, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceGetTodayStatsResponse> getTodayStats(
    $0.OrderServiceGetTodayStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTodayStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceGetDailyStatsResponse> getDailyStats(
    $0.OrderServiceGetDailyStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDailyStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceGetLabelResponse> getLabel(
    $0.OrderServiceGetLabelRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLabel, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceListRecentResponse> listRecent(
    $0.OrderServiceListRecentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRecent, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceBulkCancelResponse> bulkCancel(
    $0.OrderServiceBulkCancelRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$bulkCancel, request, options: options);
  }

  $grpc.ResponseFuture<$0.OrderServiceBulkUpdateStatusResponse>
      bulkUpdateStatus(
    $0.OrderServiceBulkUpdateStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$bulkUpdateStatus, request, options: options);
  }

  // method descriptors

  static final _$list = $grpc.ClientMethod<$0.OrderServiceListRequest,
          $0.OrderServiceListResponse>(
      '/creativanta.commerce.v1.OrderService/List',
      ($0.OrderServiceListRequest value) => value.writeToBuffer(),
      $0.OrderServiceListResponse.fromBuffer);
  static final _$get =
      $grpc.ClientMethod<$0.OrderServiceGetRequest, $0.OrderServiceGetResponse>(
          '/creativanta.commerce.v1.OrderService/Get',
          ($0.OrderServiceGetRequest value) => value.writeToBuffer(),
          $0.OrderServiceGetResponse.fromBuffer);
  static final _$import = $grpc.ClientMethod<$0.OrderServiceImportRequest,
          $0.OrderServiceImportResponse>(
      '/creativanta.commerce.v1.OrderService/Import',
      ($0.OrderServiceImportRequest value) => value.writeToBuffer(),
      $0.OrderServiceImportResponse.fromBuffer);
  static final _$export = $grpc.ClientMethod<$0.OrderServiceExportRequest,
          $0.OrderServiceExportResponse>(
      '/creativanta.commerce.v1.OrderService/Export',
      ($0.OrderServiceExportRequest value) => value.writeToBuffer(),
      $0.OrderServiceExportResponse.fromBuffer);
  static final _$updateStatus = $grpc.ClientMethod<
          $0.OrderServiceUpdateStatusRequest,
          $0.OrderServiceUpdateStatusResponse>(
      '/creativanta.commerce.v1.OrderService/UpdateStatus',
      ($0.OrderServiceUpdateStatusRequest value) => value.writeToBuffer(),
      $0.OrderServiceUpdateStatusResponse.fromBuffer);
  static final _$search = $grpc.ClientMethod<$0.OrderServiceSearchRequest,
          $0.OrderServiceSearchResponse>(
      '/creativanta.commerce.v1.OrderService/Search',
      ($0.OrderServiceSearchRequest value) => value.writeToBuffer(),
      $0.OrderServiceSearchResponse.fromBuffer);
  static final _$confirm = $grpc.ClientMethod<$0.OrderServiceConfirmRequest,
          $0.OrderServiceConfirmResponse>(
      '/creativanta.commerce.v1.OrderService/Confirm',
      ($0.OrderServiceConfirmRequest value) => value.writeToBuffer(),
      $0.OrderServiceConfirmResponse.fromBuffer);
  static final _$getTodayStats = $grpc.ClientMethod<
          $0.OrderServiceGetTodayStatsRequest,
          $0.OrderServiceGetTodayStatsResponse>(
      '/creativanta.commerce.v1.OrderService/GetTodayStats',
      ($0.OrderServiceGetTodayStatsRequest value) => value.writeToBuffer(),
      $0.OrderServiceGetTodayStatsResponse.fromBuffer);
  static final _$getDailyStats = $grpc.ClientMethod<
          $0.OrderServiceGetDailyStatsRequest,
          $0.OrderServiceGetDailyStatsResponse>(
      '/creativanta.commerce.v1.OrderService/GetDailyStats',
      ($0.OrderServiceGetDailyStatsRequest value) => value.writeToBuffer(),
      $0.OrderServiceGetDailyStatsResponse.fromBuffer);
  static final _$getLabel = $grpc.ClientMethod<$0.OrderServiceGetLabelRequest,
          $0.OrderServiceGetLabelResponse>(
      '/creativanta.commerce.v1.OrderService/GetLabel',
      ($0.OrderServiceGetLabelRequest value) => value.writeToBuffer(),
      $0.OrderServiceGetLabelResponse.fromBuffer);
  static final _$listRecent = $grpc.ClientMethod<
          $0.OrderServiceListRecentRequest, $0.OrderServiceListRecentResponse>(
      '/creativanta.commerce.v1.OrderService/ListRecent',
      ($0.OrderServiceListRecentRequest value) => value.writeToBuffer(),
      $0.OrderServiceListRecentResponse.fromBuffer);
  static final _$bulkCancel = $grpc.ClientMethod<
          $0.OrderServiceBulkCancelRequest, $0.OrderServiceBulkCancelResponse>(
      '/creativanta.commerce.v1.OrderService/BulkCancel',
      ($0.OrderServiceBulkCancelRequest value) => value.writeToBuffer(),
      $0.OrderServiceBulkCancelResponse.fromBuffer);
  static final _$bulkUpdateStatus = $grpc.ClientMethod<
          $0.OrderServiceBulkUpdateStatusRequest,
          $0.OrderServiceBulkUpdateStatusResponse>(
      '/creativanta.commerce.v1.OrderService/BulkUpdateStatus',
      ($0.OrderServiceBulkUpdateStatusRequest value) => value.writeToBuffer(),
      $0.OrderServiceBulkUpdateStatusResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.OrderService')
abstract class OrderServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.OrderService';

  OrderServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.OrderServiceListRequest,
            $0.OrderServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceListRequest.fromBuffer(value),
        ($0.OrderServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceGetRequest,
            $0.OrderServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceGetRequest.fromBuffer(value),
        ($0.OrderServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceImportRequest,
            $0.OrderServiceImportResponse>(
        'Import',
        import_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceImportRequest.fromBuffer(value),
        ($0.OrderServiceImportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceExportRequest,
            $0.OrderServiceExportResponse>(
        'Export',
        export_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceExportRequest.fromBuffer(value),
        ($0.OrderServiceExportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceUpdateStatusRequest,
            $0.OrderServiceUpdateStatusResponse>(
        'UpdateStatus',
        updateStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceUpdateStatusRequest.fromBuffer(value),
        ($0.OrderServiceUpdateStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceSearchRequest,
            $0.OrderServiceSearchResponse>(
        'Search',
        search_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceSearchRequest.fromBuffer(value),
        ($0.OrderServiceSearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceConfirmRequest,
            $0.OrderServiceConfirmResponse>(
        'Confirm',
        confirm_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceConfirmRequest.fromBuffer(value),
        ($0.OrderServiceConfirmResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceGetTodayStatsRequest,
            $0.OrderServiceGetTodayStatsResponse>(
        'GetTodayStats',
        getTodayStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceGetTodayStatsRequest.fromBuffer(value),
        ($0.OrderServiceGetTodayStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceGetDailyStatsRequest,
            $0.OrderServiceGetDailyStatsResponse>(
        'GetDailyStats',
        getDailyStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceGetDailyStatsRequest.fromBuffer(value),
        ($0.OrderServiceGetDailyStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceGetLabelRequest,
            $0.OrderServiceGetLabelResponse>(
        'GetLabel',
        getLabel_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceGetLabelRequest.fromBuffer(value),
        ($0.OrderServiceGetLabelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceListRecentRequest,
            $0.OrderServiceListRecentResponse>(
        'ListRecent',
        listRecent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceListRecentRequest.fromBuffer(value),
        ($0.OrderServiceListRecentResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceBulkCancelRequest,
            $0.OrderServiceBulkCancelResponse>(
        'BulkCancel',
        bulkCancel_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceBulkCancelRequest.fromBuffer(value),
        ($0.OrderServiceBulkCancelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OrderServiceBulkUpdateStatusRequest,
            $0.OrderServiceBulkUpdateStatusResponse>(
        'BulkUpdateStatus',
        bulkUpdateStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OrderServiceBulkUpdateStatusRequest.fromBuffer(value),
        ($0.OrderServiceBulkUpdateStatusResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.OrderServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.OrderServiceListResponse> list(
      $grpc.ServiceCall call, $0.OrderServiceListRequest request);

  $async.Future<$0.OrderServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.OrderServiceGetResponse> get(
      $grpc.ServiceCall call, $0.OrderServiceGetRequest request);

  $async.Future<$0.OrderServiceImportResponse> import_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceImportRequest> $request) async {
    return import($call, await $request);
  }

  $async.Future<$0.OrderServiceImportResponse> import(
      $grpc.ServiceCall call, $0.OrderServiceImportRequest request);

  $async.Future<$0.OrderServiceExportResponse> export_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceExportRequest> $request) async {
    return export($call, await $request);
  }

  $async.Future<$0.OrderServiceExportResponse> export(
      $grpc.ServiceCall call, $0.OrderServiceExportRequest request);

  $async.Future<$0.OrderServiceUpdateStatusResponse> updateStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceUpdateStatusRequest> $request) async {
    return updateStatus($call, await $request);
  }

  $async.Future<$0.OrderServiceUpdateStatusResponse> updateStatus(
      $grpc.ServiceCall call, $0.OrderServiceUpdateStatusRequest request);

  $async.Future<$0.OrderServiceSearchResponse> search_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceSearchRequest> $request) async {
    return search($call, await $request);
  }

  $async.Future<$0.OrderServiceSearchResponse> search(
      $grpc.ServiceCall call, $0.OrderServiceSearchRequest request);

  $async.Future<$0.OrderServiceConfirmResponse> confirm_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceConfirmRequest> $request) async {
    return confirm($call, await $request);
  }

  $async.Future<$0.OrderServiceConfirmResponse> confirm(
      $grpc.ServiceCall call, $0.OrderServiceConfirmRequest request);

  $async.Future<$0.OrderServiceGetTodayStatsResponse> getTodayStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceGetTodayStatsRequest> $request) async {
    return getTodayStats($call, await $request);
  }

  $async.Future<$0.OrderServiceGetTodayStatsResponse> getTodayStats(
      $grpc.ServiceCall call, $0.OrderServiceGetTodayStatsRequest request);

  $async.Future<$0.OrderServiceGetDailyStatsResponse> getDailyStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceGetDailyStatsRequest> $request) async {
    return getDailyStats($call, await $request);
  }

  $async.Future<$0.OrderServiceGetDailyStatsResponse> getDailyStats(
      $grpc.ServiceCall call, $0.OrderServiceGetDailyStatsRequest request);

  $async.Future<$0.OrderServiceGetLabelResponse> getLabel_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceGetLabelRequest> $request) async {
    return getLabel($call, await $request);
  }

  $async.Future<$0.OrderServiceGetLabelResponse> getLabel(
      $grpc.ServiceCall call, $0.OrderServiceGetLabelRequest request);

  $async.Future<$0.OrderServiceListRecentResponse> listRecent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceListRecentRequest> $request) async {
    return listRecent($call, await $request);
  }

  $async.Future<$0.OrderServiceListRecentResponse> listRecent(
      $grpc.ServiceCall call, $0.OrderServiceListRecentRequest request);

  $async.Future<$0.OrderServiceBulkCancelResponse> bulkCancel_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceBulkCancelRequest> $request) async {
    return bulkCancel($call, await $request);
  }

  $async.Future<$0.OrderServiceBulkCancelResponse> bulkCancel(
      $grpc.ServiceCall call, $0.OrderServiceBulkCancelRequest request);

  $async.Future<$0.OrderServiceBulkUpdateStatusResponse> bulkUpdateStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OrderServiceBulkUpdateStatusRequest> $request) async {
    return bulkUpdateStatus($call, await $request);
  }

  $async.Future<$0.OrderServiceBulkUpdateStatusResponse> bulkUpdateStatus(
      $grpc.ServiceCall call, $0.OrderServiceBulkUpdateStatusRequest request);
}

/// InventoryService manages warehouses, stock balances, movements, and alerts.
@$pb.GrpcServiceName('creativanta.commerce.v1.InventoryService')
class InventoryServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  InventoryServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.InventoryServiceGetSummaryResponse> getSummary(
    $0.InventoryServiceGetSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSummary, request, options: options);
  }

  $grpc.ResponseFuture<$0.InventoryServiceListStockResponse> listStock(
    $0.InventoryServiceListStockRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listStock, request, options: options);
  }

  $grpc.ResponseFuture<$0.InventoryServiceListMovementsResponse> listMovements(
    $0.InventoryServiceListMovementsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMovements, request, options: options);
  }

  $grpc.ResponseFuture<$0.InventoryServiceCreateStockMovementResponse>
      createStockMovement(
    $0.InventoryServiceCreateStockMovementRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createStockMovement, request, options: options);
  }

  $grpc.ResponseFuture<$0.InventoryServiceBulkStockInResponse> bulkStockIn(
    $0.InventoryServiceBulkStockInRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$bulkStockIn, request, options: options);
  }

  $grpc.ResponseFuture<$0.InventoryServiceGetAlertsResponse> getAlerts(
    $0.InventoryServiceGetAlertsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAlerts, request, options: options);
  }

  $grpc.ResponseFuture<$0.InventoryServiceUpdateThresholdsResponse>
      updateThresholds(
    $0.InventoryServiceUpdateThresholdsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateThresholds, request, options: options);
  }

  $grpc.ResponseFuture<$0.InventoryServiceExportResponse> export(
    $0.InventoryServiceExportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$export, request, options: options);
  }

  // method descriptors

  static final _$getSummary = $grpc.ClientMethod<
          $0.InventoryServiceGetSummaryRequest,
          $0.InventoryServiceGetSummaryResponse>(
      '/creativanta.commerce.v1.InventoryService/GetSummary',
      ($0.InventoryServiceGetSummaryRequest value) => value.writeToBuffer(),
      $0.InventoryServiceGetSummaryResponse.fromBuffer);
  static final _$listStock = $grpc.ClientMethod<
          $0.InventoryServiceListStockRequest,
          $0.InventoryServiceListStockResponse>(
      '/creativanta.commerce.v1.InventoryService/ListStock',
      ($0.InventoryServiceListStockRequest value) => value.writeToBuffer(),
      $0.InventoryServiceListStockResponse.fromBuffer);
  static final _$listMovements = $grpc.ClientMethod<
          $0.InventoryServiceListMovementsRequest,
          $0.InventoryServiceListMovementsResponse>(
      '/creativanta.commerce.v1.InventoryService/ListMovements',
      ($0.InventoryServiceListMovementsRequest value) => value.writeToBuffer(),
      $0.InventoryServiceListMovementsResponse.fromBuffer);
  static final _$createStockMovement = $grpc.ClientMethod<
          $0.InventoryServiceCreateStockMovementRequest,
          $0.InventoryServiceCreateStockMovementResponse>(
      '/creativanta.commerce.v1.InventoryService/CreateStockMovement',
      ($0.InventoryServiceCreateStockMovementRequest value) =>
          value.writeToBuffer(),
      $0.InventoryServiceCreateStockMovementResponse.fromBuffer);
  static final _$bulkStockIn = $grpc.ClientMethod<
          $0.InventoryServiceBulkStockInRequest,
          $0.InventoryServiceBulkStockInResponse>(
      '/creativanta.commerce.v1.InventoryService/BulkStockIn',
      ($0.InventoryServiceBulkStockInRequest value) => value.writeToBuffer(),
      $0.InventoryServiceBulkStockInResponse.fromBuffer);
  static final _$getAlerts = $grpc.ClientMethod<
          $0.InventoryServiceGetAlertsRequest,
          $0.InventoryServiceGetAlertsResponse>(
      '/creativanta.commerce.v1.InventoryService/GetAlerts',
      ($0.InventoryServiceGetAlertsRequest value) => value.writeToBuffer(),
      $0.InventoryServiceGetAlertsResponse.fromBuffer);
  static final _$updateThresholds = $grpc.ClientMethod<
          $0.InventoryServiceUpdateThresholdsRequest,
          $0.InventoryServiceUpdateThresholdsResponse>(
      '/creativanta.commerce.v1.InventoryService/UpdateThresholds',
      ($0.InventoryServiceUpdateThresholdsRequest value) =>
          value.writeToBuffer(),
      $0.InventoryServiceUpdateThresholdsResponse.fromBuffer);
  static final _$export = $grpc.ClientMethod<$0.InventoryServiceExportRequest,
          $0.InventoryServiceExportResponse>(
      '/creativanta.commerce.v1.InventoryService/Export',
      ($0.InventoryServiceExportRequest value) => value.writeToBuffer(),
      $0.InventoryServiceExportResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.InventoryService')
abstract class InventoryServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.InventoryService';

  InventoryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.InventoryServiceGetSummaryRequest,
            $0.InventoryServiceGetSummaryResponse>(
        'GetSummary',
        getSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InventoryServiceGetSummaryRequest.fromBuffer(value),
        ($0.InventoryServiceGetSummaryResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InventoryServiceListStockRequest,
            $0.InventoryServiceListStockResponse>(
        'ListStock',
        listStock_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InventoryServiceListStockRequest.fromBuffer(value),
        ($0.InventoryServiceListStockResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InventoryServiceListMovementsRequest,
            $0.InventoryServiceListMovementsResponse>(
        'ListMovements',
        listMovements_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InventoryServiceListMovementsRequest.fromBuffer(value),
        ($0.InventoryServiceListMovementsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<
            $0.InventoryServiceCreateStockMovementRequest,
            $0.InventoryServiceCreateStockMovementResponse>(
        'CreateStockMovement',
        createStockMovement_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InventoryServiceCreateStockMovementRequest.fromBuffer(value),
        ($0.InventoryServiceCreateStockMovementResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InventoryServiceBulkStockInRequest,
            $0.InventoryServiceBulkStockInResponse>(
        'BulkStockIn',
        bulkStockIn_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InventoryServiceBulkStockInRequest.fromBuffer(value),
        ($0.InventoryServiceBulkStockInResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InventoryServiceGetAlertsRequest,
            $0.InventoryServiceGetAlertsResponse>(
        'GetAlerts',
        getAlerts_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InventoryServiceGetAlertsRequest.fromBuffer(value),
        ($0.InventoryServiceGetAlertsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InventoryServiceUpdateThresholdsRequest,
            $0.InventoryServiceUpdateThresholdsResponse>(
        'UpdateThresholds',
        updateThresholds_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InventoryServiceUpdateThresholdsRequest.fromBuffer(value),
        ($0.InventoryServiceUpdateThresholdsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InventoryServiceExportRequest,
            $0.InventoryServiceExportResponse>(
        'Export',
        export_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InventoryServiceExportRequest.fromBuffer(value),
        ($0.InventoryServiceExportResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.InventoryServiceGetSummaryResponse> getSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InventoryServiceGetSummaryRequest> $request) async {
    return getSummary($call, await $request);
  }

  $async.Future<$0.InventoryServiceGetSummaryResponse> getSummary(
      $grpc.ServiceCall call, $0.InventoryServiceGetSummaryRequest request);

  $async.Future<$0.InventoryServiceListStockResponse> listStock_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InventoryServiceListStockRequest> $request) async {
    return listStock($call, await $request);
  }

  $async.Future<$0.InventoryServiceListStockResponse> listStock(
      $grpc.ServiceCall call, $0.InventoryServiceListStockRequest request);

  $async.Future<$0.InventoryServiceListMovementsResponse> listMovements_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InventoryServiceListMovementsRequest> $request) async {
    return listMovements($call, await $request);
  }

  $async.Future<$0.InventoryServiceListMovementsResponse> listMovements(
      $grpc.ServiceCall call, $0.InventoryServiceListMovementsRequest request);

  $async.Future<$0.InventoryServiceCreateStockMovementResponse>
      createStockMovement_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.InventoryServiceCreateStockMovementRequest>
              $request) async {
    return createStockMovement($call, await $request);
  }

  $async.Future<$0.InventoryServiceCreateStockMovementResponse>
      createStockMovement($grpc.ServiceCall call,
          $0.InventoryServiceCreateStockMovementRequest request);

  $async.Future<$0.InventoryServiceBulkStockInResponse> bulkStockIn_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InventoryServiceBulkStockInRequest> $request) async {
    return bulkStockIn($call, await $request);
  }

  $async.Future<$0.InventoryServiceBulkStockInResponse> bulkStockIn(
      $grpc.ServiceCall call, $0.InventoryServiceBulkStockInRequest request);

  $async.Future<$0.InventoryServiceGetAlertsResponse> getAlerts_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InventoryServiceGetAlertsRequest> $request) async {
    return getAlerts($call, await $request);
  }

  $async.Future<$0.InventoryServiceGetAlertsResponse> getAlerts(
      $grpc.ServiceCall call, $0.InventoryServiceGetAlertsRequest request);

  $async.Future<$0.InventoryServiceUpdateThresholdsResponse>
      updateThresholds_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.InventoryServiceUpdateThresholdsRequest>
              $request) async {
    return updateThresholds($call, await $request);
  }

  $async.Future<$0.InventoryServiceUpdateThresholdsResponse> updateThresholds(
      $grpc.ServiceCall call,
      $0.InventoryServiceUpdateThresholdsRequest request);

  $async.Future<$0.InventoryServiceExportResponse> export_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InventoryServiceExportRequest> $request) async {
    return export($call, await $request);
  }

  $async.Future<$0.InventoryServiceExportResponse> export(
      $grpc.ServiceCall call, $0.InventoryServiceExportRequest request);
}

/// RefundService handles financial refund requests, approvals, and metrics.
@$pb.GrpcServiceName('creativanta.commerce.v1.RefundService')
class RefundServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RefundServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RefundServiceCreateResponse> create(
    $0.RefundServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.RefundServiceGetResponse> get(
    $0.RefundServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.RefundServiceListResponse> list(
    $0.RefundServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.RefundServiceApproveResponse> approve(
    $0.RefundServiceApproveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approve, request, options: options);
  }

  $grpc.ResponseFuture<$0.RefundServiceRejectResponse> reject(
    $0.RefundServiceRejectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reject, request, options: options);
  }

  $grpc.ResponseFuture<$0.RefundServiceGetStatsResponse> getStats(
    $0.RefundServiceGetStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.RefundServiceCreateRequest,
          $0.RefundServiceCreateResponse>(
      '/creativanta.commerce.v1.RefundService/Create',
      ($0.RefundServiceCreateRequest value) => value.writeToBuffer(),
      $0.RefundServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.RefundServiceGetRequest,
          $0.RefundServiceGetResponse>(
      '/creativanta.commerce.v1.RefundService/Get',
      ($0.RefundServiceGetRequest value) => value.writeToBuffer(),
      $0.RefundServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.RefundServiceListRequest,
          $0.RefundServiceListResponse>(
      '/creativanta.commerce.v1.RefundService/List',
      ($0.RefundServiceListRequest value) => value.writeToBuffer(),
      $0.RefundServiceListResponse.fromBuffer);
  static final _$approve = $grpc.ClientMethod<$0.RefundServiceApproveRequest,
          $0.RefundServiceApproveResponse>(
      '/creativanta.commerce.v1.RefundService/Approve',
      ($0.RefundServiceApproveRequest value) => value.writeToBuffer(),
      $0.RefundServiceApproveResponse.fromBuffer);
  static final _$reject = $grpc.ClientMethod<$0.RefundServiceRejectRequest,
          $0.RefundServiceRejectResponse>(
      '/creativanta.commerce.v1.RefundService/Reject',
      ($0.RefundServiceRejectRequest value) => value.writeToBuffer(),
      $0.RefundServiceRejectResponse.fromBuffer);
  static final _$getStats = $grpc.ClientMethod<$0.RefundServiceGetStatsRequest,
          $0.RefundServiceGetStatsResponse>(
      '/creativanta.commerce.v1.RefundService/GetStats',
      ($0.RefundServiceGetStatsRequest value) => value.writeToBuffer(),
      $0.RefundServiceGetStatsResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.RefundService')
abstract class RefundServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.RefundService';

  RefundServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RefundServiceCreateRequest,
            $0.RefundServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RefundServiceCreateRequest.fromBuffer(value),
        ($0.RefundServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RefundServiceGetRequest,
            $0.RefundServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RefundServiceGetRequest.fromBuffer(value),
        ($0.RefundServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RefundServiceListRequest,
            $0.RefundServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RefundServiceListRequest.fromBuffer(value),
        ($0.RefundServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RefundServiceApproveRequest,
            $0.RefundServiceApproveResponse>(
        'Approve',
        approve_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RefundServiceApproveRequest.fromBuffer(value),
        ($0.RefundServiceApproveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RefundServiceRejectRequest,
            $0.RefundServiceRejectResponse>(
        'Reject',
        reject_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RefundServiceRejectRequest.fromBuffer(value),
        ($0.RefundServiceRejectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RefundServiceGetStatsRequest,
            $0.RefundServiceGetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RefundServiceGetStatsRequest.fromBuffer(value),
        ($0.RefundServiceGetStatsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RefundServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RefundServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.RefundServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.RefundServiceCreateRequest request);

  $async.Future<$0.RefundServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RefundServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.RefundServiceGetResponse> get(
      $grpc.ServiceCall call, $0.RefundServiceGetRequest request);

  $async.Future<$0.RefundServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RefundServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.RefundServiceListResponse> list(
      $grpc.ServiceCall call, $0.RefundServiceListRequest request);

  $async.Future<$0.RefundServiceApproveResponse> approve_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RefundServiceApproveRequest> $request) async {
    return approve($call, await $request);
  }

  $async.Future<$0.RefundServiceApproveResponse> approve(
      $grpc.ServiceCall call, $0.RefundServiceApproveRequest request);

  $async.Future<$0.RefundServiceRejectResponse> reject_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RefundServiceRejectRequest> $request) async {
    return reject($call, await $request);
  }

  $async.Future<$0.RefundServiceRejectResponse> reject(
      $grpc.ServiceCall call, $0.RefundServiceRejectRequest request);

  $async.Future<$0.RefundServiceGetStatsResponse> getStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RefundServiceGetStatsRequest> $request) async {
    return getStats($call, await $request);
  }

  $async.Future<$0.RefundServiceGetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.RefundServiceGetStatsRequest request);
}

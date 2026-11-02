// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/trend.proto.

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

import 'trend.pb.dart' as $0;

export 'trend.pb.dart';

/// TrendService provides signal ingestion, multi-dimensional scoring,
/// degraded source handling, provenance lineage, and tenant-scoped search.
@$pb.GrpcServiceName('creativanta.intelligence.v1.TrendService')
class TrendServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TrendServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.TrendServiceListResponse> list(
    $0.TrendServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceGetResponse> get(
    $0.TrendServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceSearchResponse> search(
    $0.TrendServiceSearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$search, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceManageWatchlistResponse> manageWatchlist(
    $0.TrendServiceManageWatchlistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$manageWatchlist, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceGetTopResponse> getTop(
    $0.TrendServiceGetTopRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTop, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceListTopResponse> listTop(
    $0.TrendServiceListTopRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTop, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceListRelatedResponse> listRelated(
    $0.TrendServiceListRelatedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRelated, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceGetTimeSeriesResponse> getTimeSeries(
    $0.TrendServiceGetTimeSeriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTimeSeries, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceGetSparklinesResponse> getSparklines(
    $0.TrendServiceGetSparklinesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSparklines, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceGetStatsResponse> getStats(
    $0.TrendServiceGetStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceGetExamplesResponse> getExamples(
    $0.TrendServiceGetExamplesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getExamples, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendServiceGetAudienceFitResponse> getAudienceFit(
    $0.TrendServiceGetAudienceFitRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAudienceFit, request, options: options);
  }

  // method descriptors

  static final _$list = $grpc.ClientMethod<$0.TrendServiceListRequest,
          $0.TrendServiceListResponse>(
      '/creativanta.intelligence.v1.TrendService/List',
      ($0.TrendServiceListRequest value) => value.writeToBuffer(),
      $0.TrendServiceListResponse.fromBuffer);
  static final _$get =
      $grpc.ClientMethod<$0.TrendServiceGetRequest, $0.TrendServiceGetResponse>(
          '/creativanta.intelligence.v1.TrendService/Get',
          ($0.TrendServiceGetRequest value) => value.writeToBuffer(),
          $0.TrendServiceGetResponse.fromBuffer);
  static final _$search = $grpc.ClientMethod<$0.TrendServiceSearchRequest,
          $0.TrendServiceSearchResponse>(
      '/creativanta.intelligence.v1.TrendService/Search',
      ($0.TrendServiceSearchRequest value) => value.writeToBuffer(),
      $0.TrendServiceSearchResponse.fromBuffer);
  static final _$manageWatchlist = $grpc.ClientMethod<
          $0.TrendServiceManageWatchlistRequest,
          $0.TrendServiceManageWatchlistResponse>(
      '/creativanta.intelligence.v1.TrendService/ManageWatchlist',
      ($0.TrendServiceManageWatchlistRequest value) => value.writeToBuffer(),
      $0.TrendServiceManageWatchlistResponse.fromBuffer);
  static final _$getTop = $grpc.ClientMethod<$0.TrendServiceGetTopRequest,
          $0.TrendServiceGetTopResponse>(
      '/creativanta.intelligence.v1.TrendService/GetTop',
      ($0.TrendServiceGetTopRequest value) => value.writeToBuffer(),
      $0.TrendServiceGetTopResponse.fromBuffer);
  static final _$listTop = $grpc.ClientMethod<$0.TrendServiceListTopRequest,
          $0.TrendServiceListTopResponse>(
      '/creativanta.intelligence.v1.TrendService/ListTop',
      ($0.TrendServiceListTopRequest value) => value.writeToBuffer(),
      $0.TrendServiceListTopResponse.fromBuffer);
  static final _$listRelated = $grpc.ClientMethod<
          $0.TrendServiceListRelatedRequest,
          $0.TrendServiceListRelatedResponse>(
      '/creativanta.intelligence.v1.TrendService/ListRelated',
      ($0.TrendServiceListRelatedRequest value) => value.writeToBuffer(),
      $0.TrendServiceListRelatedResponse.fromBuffer);
  static final _$getTimeSeries = $grpc.ClientMethod<
          $0.TrendServiceGetTimeSeriesRequest,
          $0.TrendServiceGetTimeSeriesResponse>(
      '/creativanta.intelligence.v1.TrendService/GetTimeSeries',
      ($0.TrendServiceGetTimeSeriesRequest value) => value.writeToBuffer(),
      $0.TrendServiceGetTimeSeriesResponse.fromBuffer);
  static final _$getSparklines = $grpc.ClientMethod<
          $0.TrendServiceGetSparklinesRequest,
          $0.TrendServiceGetSparklinesResponse>(
      '/creativanta.intelligence.v1.TrendService/GetSparklines',
      ($0.TrendServiceGetSparklinesRequest value) => value.writeToBuffer(),
      $0.TrendServiceGetSparklinesResponse.fromBuffer);
  static final _$getStats = $grpc.ClientMethod<$0.TrendServiceGetStatsRequest,
          $0.TrendServiceGetStatsResponse>(
      '/creativanta.intelligence.v1.TrendService/GetStats',
      ($0.TrendServiceGetStatsRequest value) => value.writeToBuffer(),
      $0.TrendServiceGetStatsResponse.fromBuffer);
  static final _$getExamples = $grpc.ClientMethod<
          $0.TrendServiceGetExamplesRequest,
          $0.TrendServiceGetExamplesResponse>(
      '/creativanta.intelligence.v1.TrendService/GetExamples',
      ($0.TrendServiceGetExamplesRequest value) => value.writeToBuffer(),
      $0.TrendServiceGetExamplesResponse.fromBuffer);
  static final _$getAudienceFit = $grpc.ClientMethod<
          $0.TrendServiceGetAudienceFitRequest,
          $0.TrendServiceGetAudienceFitResponse>(
      '/creativanta.intelligence.v1.TrendService/GetAudienceFit',
      ($0.TrendServiceGetAudienceFitRequest value) => value.writeToBuffer(),
      $0.TrendServiceGetAudienceFitResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.intelligence.v1.TrendService')
abstract class TrendServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.intelligence.v1.TrendService';

  TrendServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TrendServiceListRequest,
            $0.TrendServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceListRequest.fromBuffer(value),
        ($0.TrendServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceGetRequest,
            $0.TrendServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceGetRequest.fromBuffer(value),
        ($0.TrendServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceSearchRequest,
            $0.TrendServiceSearchResponse>(
        'Search',
        search_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceSearchRequest.fromBuffer(value),
        ($0.TrendServiceSearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceManageWatchlistRequest,
            $0.TrendServiceManageWatchlistResponse>(
        'ManageWatchlist',
        manageWatchlist_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceManageWatchlistRequest.fromBuffer(value),
        ($0.TrendServiceManageWatchlistResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceGetTopRequest,
            $0.TrendServiceGetTopResponse>(
        'GetTop',
        getTop_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceGetTopRequest.fromBuffer(value),
        ($0.TrendServiceGetTopResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceListTopRequest,
            $0.TrendServiceListTopResponse>(
        'ListTop',
        listTop_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceListTopRequest.fromBuffer(value),
        ($0.TrendServiceListTopResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceListRelatedRequest,
            $0.TrendServiceListRelatedResponse>(
        'ListRelated',
        listRelated_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceListRelatedRequest.fromBuffer(value),
        ($0.TrendServiceListRelatedResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceGetTimeSeriesRequest,
            $0.TrendServiceGetTimeSeriesResponse>(
        'GetTimeSeries',
        getTimeSeries_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceGetTimeSeriesRequest.fromBuffer(value),
        ($0.TrendServiceGetTimeSeriesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceGetSparklinesRequest,
            $0.TrendServiceGetSparklinesResponse>(
        'GetSparklines',
        getSparklines_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceGetSparklinesRequest.fromBuffer(value),
        ($0.TrendServiceGetSparklinesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceGetStatsRequest,
            $0.TrendServiceGetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceGetStatsRequest.fromBuffer(value),
        ($0.TrendServiceGetStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceGetExamplesRequest,
            $0.TrendServiceGetExamplesResponse>(
        'GetExamples',
        getExamples_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceGetExamplesRequest.fromBuffer(value),
        ($0.TrendServiceGetExamplesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendServiceGetAudienceFitRequest,
            $0.TrendServiceGetAudienceFitResponse>(
        'GetAudienceFit',
        getAudienceFit_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TrendServiceGetAudienceFitRequest.fromBuffer(value),
        ($0.TrendServiceGetAudienceFitResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.TrendServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.TrendServiceListResponse> list(
      $grpc.ServiceCall call, $0.TrendServiceListRequest request);

  $async.Future<$0.TrendServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.TrendServiceGetResponse> get(
      $grpc.ServiceCall call, $0.TrendServiceGetRequest request);

  $async.Future<$0.TrendServiceSearchResponse> search_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceSearchRequest> $request) async {
    return search($call, await $request);
  }

  $async.Future<$0.TrendServiceSearchResponse> search(
      $grpc.ServiceCall call, $0.TrendServiceSearchRequest request);

  $async.Future<$0.TrendServiceManageWatchlistResponse> manageWatchlist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceManageWatchlistRequest> $request) async {
    return manageWatchlist($call, await $request);
  }

  $async.Future<$0.TrendServiceManageWatchlistResponse> manageWatchlist(
      $grpc.ServiceCall call, $0.TrendServiceManageWatchlistRequest request);

  $async.Future<$0.TrendServiceGetTopResponse> getTop_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceGetTopRequest> $request) async {
    return getTop($call, await $request);
  }

  $async.Future<$0.TrendServiceGetTopResponse> getTop(
      $grpc.ServiceCall call, $0.TrendServiceGetTopRequest request);

  $async.Future<$0.TrendServiceListTopResponse> listTop_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceListTopRequest> $request) async {
    return listTop($call, await $request);
  }

  $async.Future<$0.TrendServiceListTopResponse> listTop(
      $grpc.ServiceCall call, $0.TrendServiceListTopRequest request);

  $async.Future<$0.TrendServiceListRelatedResponse> listRelated_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceListRelatedRequest> $request) async {
    return listRelated($call, await $request);
  }

  $async.Future<$0.TrendServiceListRelatedResponse> listRelated(
      $grpc.ServiceCall call, $0.TrendServiceListRelatedRequest request);

  $async.Future<$0.TrendServiceGetTimeSeriesResponse> getTimeSeries_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceGetTimeSeriesRequest> $request) async {
    return getTimeSeries($call, await $request);
  }

  $async.Future<$0.TrendServiceGetTimeSeriesResponse> getTimeSeries(
      $grpc.ServiceCall call, $0.TrendServiceGetTimeSeriesRequest request);

  $async.Future<$0.TrendServiceGetSparklinesResponse> getSparklines_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceGetSparklinesRequest> $request) async {
    return getSparklines($call, await $request);
  }

  $async.Future<$0.TrendServiceGetSparklinesResponse> getSparklines(
      $grpc.ServiceCall call, $0.TrendServiceGetSparklinesRequest request);

  $async.Future<$0.TrendServiceGetStatsResponse> getStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceGetStatsRequest> $request) async {
    return getStats($call, await $request);
  }

  $async.Future<$0.TrendServiceGetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.TrendServiceGetStatsRequest request);

  $async.Future<$0.TrendServiceGetExamplesResponse> getExamples_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceGetExamplesRequest> $request) async {
    return getExamples($call, await $request);
  }

  $async.Future<$0.TrendServiceGetExamplesResponse> getExamples(
      $grpc.ServiceCall call, $0.TrendServiceGetExamplesRequest request);

  $async.Future<$0.TrendServiceGetAudienceFitResponse> getAudienceFit_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendServiceGetAudienceFitRequest> $request) async {
    return getAudienceFit($call, await $request);
  }

  $async.Future<$0.TrendServiceGetAudienceFitResponse> getAudienceFit(
      $grpc.ServiceCall call, $0.TrendServiceGetAudienceFitRequest request);
}

/// WatchlistService manages trend/competitor/keyword watchlists and alert thresholds.
@$pb.GrpcServiceName('creativanta.intelligence.v1.WatchlistService')
class WatchlistServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  WatchlistServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.WatchlistServiceCreateResponse> create(
    $0.WatchlistServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.WatchlistServiceListResponse> list(
    $0.WatchlistServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.WatchlistServiceDeleteResponse> delete(
    $0.WatchlistServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.WatchlistServiceUpdateResponse> update(
    $0.WatchlistServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.WatchlistServiceAddItemResponse> addItem(
    $0.WatchlistServiceAddItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.WatchlistServiceRemoveItemResponse> removeItem(
    $0.WatchlistServiceRemoveItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.WatchlistServiceGetItemsResponse> getItems(
    $0.WatchlistServiceGetItemsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getItems, request, options: options);
  }

  $grpc.ResponseFuture<$0.WatchlistServiceMuteItemResponse> muteItem(
    $0.WatchlistServiceMuteItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$muteItem, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.WatchlistServiceCreateRequest,
          $0.WatchlistServiceCreateResponse>(
      '/creativanta.intelligence.v1.WatchlistService/Create',
      ($0.WatchlistServiceCreateRequest value) => value.writeToBuffer(),
      $0.WatchlistServiceCreateResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.WatchlistServiceListRequest,
          $0.WatchlistServiceListResponse>(
      '/creativanta.intelligence.v1.WatchlistService/List',
      ($0.WatchlistServiceListRequest value) => value.writeToBuffer(),
      $0.WatchlistServiceListResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.WatchlistServiceDeleteRequest,
          $0.WatchlistServiceDeleteResponse>(
      '/creativanta.intelligence.v1.WatchlistService/Delete',
      ($0.WatchlistServiceDeleteRequest value) => value.writeToBuffer(),
      $0.WatchlistServiceDeleteResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.WatchlistServiceUpdateRequest,
          $0.WatchlistServiceUpdateResponse>(
      '/creativanta.intelligence.v1.WatchlistService/Update',
      ($0.WatchlistServiceUpdateRequest value) => value.writeToBuffer(),
      $0.WatchlistServiceUpdateResponse.fromBuffer);
  static final _$addItem = $grpc.ClientMethod<$0.WatchlistServiceAddItemRequest,
          $0.WatchlistServiceAddItemResponse>(
      '/creativanta.intelligence.v1.WatchlistService/AddItem',
      ($0.WatchlistServiceAddItemRequest value) => value.writeToBuffer(),
      $0.WatchlistServiceAddItemResponse.fromBuffer);
  static final _$removeItem = $grpc.ClientMethod<
          $0.WatchlistServiceRemoveItemRequest,
          $0.WatchlistServiceRemoveItemResponse>(
      '/creativanta.intelligence.v1.WatchlistService/RemoveItem',
      ($0.WatchlistServiceRemoveItemRequest value) => value.writeToBuffer(),
      $0.WatchlistServiceRemoveItemResponse.fromBuffer);
  static final _$getItems = $grpc.ClientMethod<
          $0.WatchlistServiceGetItemsRequest,
          $0.WatchlistServiceGetItemsResponse>(
      '/creativanta.intelligence.v1.WatchlistService/GetItems',
      ($0.WatchlistServiceGetItemsRequest value) => value.writeToBuffer(),
      $0.WatchlistServiceGetItemsResponse.fromBuffer);
  static final _$muteItem = $grpc.ClientMethod<
          $0.WatchlistServiceMuteItemRequest,
          $0.WatchlistServiceMuteItemResponse>(
      '/creativanta.intelligence.v1.WatchlistService/MuteItem',
      ($0.WatchlistServiceMuteItemRequest value) => value.writeToBuffer(),
      $0.WatchlistServiceMuteItemResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.intelligence.v1.WatchlistService')
abstract class WatchlistServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.intelligence.v1.WatchlistService';

  WatchlistServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.WatchlistServiceCreateRequest,
            $0.WatchlistServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WatchlistServiceCreateRequest.fromBuffer(value),
        ($0.WatchlistServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchlistServiceListRequest,
            $0.WatchlistServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WatchlistServiceListRequest.fromBuffer(value),
        ($0.WatchlistServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchlistServiceDeleteRequest,
            $0.WatchlistServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WatchlistServiceDeleteRequest.fromBuffer(value),
        ($0.WatchlistServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchlistServiceUpdateRequest,
            $0.WatchlistServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WatchlistServiceUpdateRequest.fromBuffer(value),
        ($0.WatchlistServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchlistServiceAddItemRequest,
            $0.WatchlistServiceAddItemResponse>(
        'AddItem',
        addItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WatchlistServiceAddItemRequest.fromBuffer(value),
        ($0.WatchlistServiceAddItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchlistServiceRemoveItemRequest,
            $0.WatchlistServiceRemoveItemResponse>(
        'RemoveItem',
        removeItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WatchlistServiceRemoveItemRequest.fromBuffer(value),
        ($0.WatchlistServiceRemoveItemResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchlistServiceGetItemsRequest,
            $0.WatchlistServiceGetItemsResponse>(
        'GetItems',
        getItems_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WatchlistServiceGetItemsRequest.fromBuffer(value),
        ($0.WatchlistServiceGetItemsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchlistServiceMuteItemRequest,
            $0.WatchlistServiceMuteItemResponse>(
        'MuteItem',
        muteItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.WatchlistServiceMuteItemRequest.fromBuffer(value),
        ($0.WatchlistServiceMuteItemResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.WatchlistServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchlistServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.WatchlistServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.WatchlistServiceCreateRequest request);

  $async.Future<$0.WatchlistServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchlistServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.WatchlistServiceListResponse> list(
      $grpc.ServiceCall call, $0.WatchlistServiceListRequest request);

  $async.Future<$0.WatchlistServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchlistServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.WatchlistServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.WatchlistServiceDeleteRequest request);

  $async.Future<$0.WatchlistServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchlistServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.WatchlistServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.WatchlistServiceUpdateRequest request);

  $async.Future<$0.WatchlistServiceAddItemResponse> addItem_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchlistServiceAddItemRequest> $request) async {
    return addItem($call, await $request);
  }

  $async.Future<$0.WatchlistServiceAddItemResponse> addItem(
      $grpc.ServiceCall call, $0.WatchlistServiceAddItemRequest request);

  $async.Future<$0.WatchlistServiceRemoveItemResponse> removeItem_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchlistServiceRemoveItemRequest> $request) async {
    return removeItem($call, await $request);
  }

  $async.Future<$0.WatchlistServiceRemoveItemResponse> removeItem(
      $grpc.ServiceCall call, $0.WatchlistServiceRemoveItemRequest request);

  $async.Future<$0.WatchlistServiceGetItemsResponse> getItems_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchlistServiceGetItemsRequest> $request) async {
    return getItems($call, await $request);
  }

  $async.Future<$0.WatchlistServiceGetItemsResponse> getItems(
      $grpc.ServiceCall call, $0.WatchlistServiceGetItemsRequest request);

  $async.Future<$0.WatchlistServiceMuteItemResponse> muteItem_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchlistServiceMuteItemRequest> $request) async {
    return muteItem($call, await $request);
  }

  $async.Future<$0.WatchlistServiceMuteItemResponse> muteItem(
      $grpc.ServiceCall call, $0.WatchlistServiceMuteItemRequest request);
}

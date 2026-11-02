// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/product.proto.

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

import 'product.pb.dart' as $0;

export 'product.pb.dart';

/// ProductService manages catalog items, variant SKUs, imports, and linked content.
@$pb.GrpcServiceName('creativanta.commerce.v1.ProductService')
class ProductServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ProductServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateResponse> create(
    $0.CreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

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

  $grpc.ResponseFuture<$0.UpdateResponse> update(
    $0.UpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteResponse> delete(
    $0.DeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.ArchiveResponse> archive(
    $0.ArchiveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$archive, request, options: options);
  }

  $grpc.ResponseFuture<$0.BatchTagResponse> batchTag(
    $0.BatchTagRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$batchTag, request, options: options);
  }

  $grpc.ResponseFuture<$0.ImportResponse> import(
    $0.ImportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$import, request, options: options);
  }

  $grpc.ResponseFuture<$0.SearchResponse> search(
    $0.SearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$search, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetStatsResponse> getStats(
    $0.GetStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSalesStatsResponse> getSalesStats(
    $0.GetSalesStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSalesStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSalesChartResponse> getSalesChart(
    $0.GetSalesChartRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSalesChart, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetReviewsResponse> getReviews(
    $0.GetReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReviews, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRankResponse> getRank(
    $0.GetRankRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRank, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetLinkedContentResponse> getLinkedContent(
    $0.GetLinkedContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLinkedContent, request, options: options);
  }

  $grpc.ResponseFuture<$0.LinkContentResponse> linkContent(
    $0.LinkContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$linkContent, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateStockResponse> updateStock(
    $0.UpdateStockRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateStock, request, options: options);
  }

  $grpc.ResponseFuture<$0.SetAlertThresholdResponse> setAlertThreshold(
    $0.SetAlertThresholdRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setAlertThreshold, request, options: options);
  }

  $grpc.ResponseFuture<$0.BulkArchiveResponse> bulkArchive(
    $0.BulkArchiveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$bulkArchive, request, options: options);
  }

  // method descriptors

  static final _$create =
      $grpc.ClientMethod<$0.CreateRequest, $0.CreateResponse>(
          '/creativanta.commerce.v1.ProductService/Create',
          ($0.CreateRequest value) => value.writeToBuffer(),
          $0.CreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.GetRequest, $0.GetResponse>(
      '/creativanta.commerce.v1.ProductService/Get',
      ($0.GetRequest value) => value.writeToBuffer(),
      $0.GetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
      '/creativanta.commerce.v1.ProductService/List',
      ($0.ListRequest value) => value.writeToBuffer(),
      $0.ListResponse.fromBuffer);
  static final _$update =
      $grpc.ClientMethod<$0.UpdateRequest, $0.UpdateResponse>(
          '/creativanta.commerce.v1.ProductService/Update',
          ($0.UpdateRequest value) => value.writeToBuffer(),
          $0.UpdateResponse.fromBuffer);
  static final _$delete =
      $grpc.ClientMethod<$0.DeleteRequest, $0.DeleteResponse>(
          '/creativanta.commerce.v1.ProductService/Delete',
          ($0.DeleteRequest value) => value.writeToBuffer(),
          $0.DeleteResponse.fromBuffer);
  static final _$archive =
      $grpc.ClientMethod<$0.ArchiveRequest, $0.ArchiveResponse>(
          '/creativanta.commerce.v1.ProductService/Archive',
          ($0.ArchiveRequest value) => value.writeToBuffer(),
          $0.ArchiveResponse.fromBuffer);
  static final _$batchTag =
      $grpc.ClientMethod<$0.BatchTagRequest, $0.BatchTagResponse>(
          '/creativanta.commerce.v1.ProductService/BatchTag',
          ($0.BatchTagRequest value) => value.writeToBuffer(),
          $0.BatchTagResponse.fromBuffer);
  static final _$import =
      $grpc.ClientMethod<$0.ImportRequest, $0.ImportResponse>(
          '/creativanta.commerce.v1.ProductService/Import',
          ($0.ImportRequest value) => value.writeToBuffer(),
          $0.ImportResponse.fromBuffer);
  static final _$search =
      $grpc.ClientMethod<$0.SearchRequest, $0.SearchResponse>(
          '/creativanta.commerce.v1.ProductService/Search',
          ($0.SearchRequest value) => value.writeToBuffer(),
          $0.SearchResponse.fromBuffer);
  static final _$getStats =
      $grpc.ClientMethod<$0.GetStatsRequest, $0.GetStatsResponse>(
          '/creativanta.commerce.v1.ProductService/GetStats',
          ($0.GetStatsRequest value) => value.writeToBuffer(),
          $0.GetStatsResponse.fromBuffer);
  static final _$getSalesStats =
      $grpc.ClientMethod<$0.GetSalesStatsRequest, $0.GetSalesStatsResponse>(
          '/creativanta.commerce.v1.ProductService/GetSalesStats',
          ($0.GetSalesStatsRequest value) => value.writeToBuffer(),
          $0.GetSalesStatsResponse.fromBuffer);
  static final _$getSalesChart =
      $grpc.ClientMethod<$0.GetSalesChartRequest, $0.GetSalesChartResponse>(
          '/creativanta.commerce.v1.ProductService/GetSalesChart',
          ($0.GetSalesChartRequest value) => value.writeToBuffer(),
          $0.GetSalesChartResponse.fromBuffer);
  static final _$getReviews =
      $grpc.ClientMethod<$0.GetReviewsRequest, $0.GetReviewsResponse>(
          '/creativanta.commerce.v1.ProductService/GetReviews',
          ($0.GetReviewsRequest value) => value.writeToBuffer(),
          $0.GetReviewsResponse.fromBuffer);
  static final _$getRank =
      $grpc.ClientMethod<$0.GetRankRequest, $0.GetRankResponse>(
          '/creativanta.commerce.v1.ProductService/GetRank',
          ($0.GetRankRequest value) => value.writeToBuffer(),
          $0.GetRankResponse.fromBuffer);
  static final _$getLinkedContent = $grpc.ClientMethod<
          $0.GetLinkedContentRequest, $0.GetLinkedContentResponse>(
      '/creativanta.commerce.v1.ProductService/GetLinkedContent',
      ($0.GetLinkedContentRequest value) => value.writeToBuffer(),
      $0.GetLinkedContentResponse.fromBuffer);
  static final _$linkContent =
      $grpc.ClientMethod<$0.LinkContentRequest, $0.LinkContentResponse>(
          '/creativanta.commerce.v1.ProductService/LinkContent',
          ($0.LinkContentRequest value) => value.writeToBuffer(),
          $0.LinkContentResponse.fromBuffer);
  static final _$updateStock =
      $grpc.ClientMethod<$0.UpdateStockRequest, $0.UpdateStockResponse>(
          '/creativanta.commerce.v1.ProductService/UpdateStock',
          ($0.UpdateStockRequest value) => value.writeToBuffer(),
          $0.UpdateStockResponse.fromBuffer);
  static final _$setAlertThreshold = $grpc.ClientMethod<
          $0.SetAlertThresholdRequest, $0.SetAlertThresholdResponse>(
      '/creativanta.commerce.v1.ProductService/SetAlertThreshold',
      ($0.SetAlertThresholdRequest value) => value.writeToBuffer(),
      $0.SetAlertThresholdResponse.fromBuffer);
  static final _$bulkArchive =
      $grpc.ClientMethod<$0.BulkArchiveRequest, $0.BulkArchiveResponse>(
          '/creativanta.commerce.v1.ProductService/BulkArchive',
          ($0.BulkArchiveRequest value) => value.writeToBuffer(),
          $0.BulkArchiveResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.ProductService')
abstract class ProductServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.ProductService';

  ProductServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateRequest, $0.CreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateRequest.fromBuffer(value),
        ($0.CreateResponse value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.UpdateRequest, $0.UpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateRequest.fromBuffer(value),
        ($0.UpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteRequest, $0.DeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteRequest.fromBuffer(value),
        ($0.DeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ArchiveRequest, $0.ArchiveResponse>(
        'Archive',
        archive_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ArchiveRequest.fromBuffer(value),
        ($0.ArchiveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BatchTagRequest, $0.BatchTagResponse>(
        'BatchTag',
        batchTag_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.BatchTagRequest.fromBuffer(value),
        ($0.BatchTagResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ImportRequest, $0.ImportResponse>(
        'Import',
        import_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ImportRequest.fromBuffer(value),
        ($0.ImportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SearchRequest, $0.SearchResponse>(
        'Search',
        search_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SearchRequest.fromBuffer(value),
        ($0.SearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetStatsRequest, $0.GetStatsResponse>(
        'GetStats',
        getStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStatsRequest.fromBuffer(value),
        ($0.GetStatsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetSalesStatsRequest, $0.GetSalesStatsResponse>(
            'GetSalesStats',
            getSalesStats_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSalesStatsRequest.fromBuffer(value),
            ($0.GetSalesStatsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetSalesChartRequest, $0.GetSalesChartResponse>(
            'GetSalesChart',
            getSalesChart_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSalesChartRequest.fromBuffer(value),
            ($0.GetSalesChartResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetReviewsRequest, $0.GetReviewsResponse>(
        'GetReviews',
        getReviews_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetReviewsRequest.fromBuffer(value),
        ($0.GetReviewsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRankRequest, $0.GetRankResponse>(
        'GetRank',
        getRank_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetRankRequest.fromBuffer(value),
        ($0.GetRankResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLinkedContentRequest,
            $0.GetLinkedContentResponse>(
        'GetLinkedContent',
        getLinkedContent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLinkedContentRequest.fromBuffer(value),
        ($0.GetLinkedContentResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.LinkContentRequest, $0.LinkContentResponse>(
            'LinkContent',
            linkContent_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.LinkContentRequest.fromBuffer(value),
            ($0.LinkContentResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateStockRequest, $0.UpdateStockResponse>(
            'UpdateStock',
            updateStock_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateStockRequest.fromBuffer(value),
            ($0.UpdateStockResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetAlertThresholdRequest,
            $0.SetAlertThresholdResponse>(
        'SetAlertThreshold',
        setAlertThreshold_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetAlertThresholdRequest.fromBuffer(value),
        ($0.SetAlertThresholdResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.BulkArchiveRequest, $0.BulkArchiveResponse>(
            'BulkArchive',
            bulkArchive_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.BulkArchiveRequest.fromBuffer(value),
            ($0.BulkArchiveResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateResponse> create_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.CreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.CreateResponse> create(
      $grpc.ServiceCall call, $0.CreateRequest request);

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

  $async.Future<$0.UpdateResponse> update_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.UpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.UpdateResponse> update(
      $grpc.ServiceCall call, $0.UpdateRequest request);

  $async.Future<$0.DeleteResponse> delete_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.DeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.DeleteResponse> delete(
      $grpc.ServiceCall call, $0.DeleteRequest request);

  $async.Future<$0.ArchiveResponse> archive_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ArchiveRequest> $request) async {
    return archive($call, await $request);
  }

  $async.Future<$0.ArchiveResponse> archive(
      $grpc.ServiceCall call, $0.ArchiveRequest request);

  $async.Future<$0.BatchTagResponse> batchTag_Pre($grpc.ServiceCall $call,
      $async.Future<$0.BatchTagRequest> $request) async {
    return batchTag($call, await $request);
  }

  $async.Future<$0.BatchTagResponse> batchTag(
      $grpc.ServiceCall call, $0.BatchTagRequest request);

  $async.Future<$0.ImportResponse> import_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ImportRequest> $request) async {
    return import($call, await $request);
  }

  $async.Future<$0.ImportResponse> import(
      $grpc.ServiceCall call, $0.ImportRequest request);

  $async.Future<$0.SearchResponse> search_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SearchRequest> $request) async {
    return search($call, await $request);
  }

  $async.Future<$0.SearchResponse> search(
      $grpc.ServiceCall call, $0.SearchRequest request);

  $async.Future<$0.GetStatsResponse> getStats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetStatsRequest> $request) async {
    return getStats($call, await $request);
  }

  $async.Future<$0.GetStatsResponse> getStats(
      $grpc.ServiceCall call, $0.GetStatsRequest request);

  $async.Future<$0.GetSalesStatsResponse> getSalesStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSalesStatsRequest> $request) async {
    return getSalesStats($call, await $request);
  }

  $async.Future<$0.GetSalesStatsResponse> getSalesStats(
      $grpc.ServiceCall call, $0.GetSalesStatsRequest request);

  $async.Future<$0.GetSalesChartResponse> getSalesChart_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSalesChartRequest> $request) async {
    return getSalesChart($call, await $request);
  }

  $async.Future<$0.GetSalesChartResponse> getSalesChart(
      $grpc.ServiceCall call, $0.GetSalesChartRequest request);

  $async.Future<$0.GetReviewsResponse> getReviews_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetReviewsRequest> $request) async {
    return getReviews($call, await $request);
  }

  $async.Future<$0.GetReviewsResponse> getReviews(
      $grpc.ServiceCall call, $0.GetReviewsRequest request);

  $async.Future<$0.GetRankResponse> getRank_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRankRequest> $request) async {
    return getRank($call, await $request);
  }

  $async.Future<$0.GetRankResponse> getRank(
      $grpc.ServiceCall call, $0.GetRankRequest request);

  $async.Future<$0.GetLinkedContentResponse> getLinkedContent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetLinkedContentRequest> $request) async {
    return getLinkedContent($call, await $request);
  }

  $async.Future<$0.GetLinkedContentResponse> getLinkedContent(
      $grpc.ServiceCall call, $0.GetLinkedContentRequest request);

  $async.Future<$0.LinkContentResponse> linkContent_Pre($grpc.ServiceCall $call,
      $async.Future<$0.LinkContentRequest> $request) async {
    return linkContent($call, await $request);
  }

  $async.Future<$0.LinkContentResponse> linkContent(
      $grpc.ServiceCall call, $0.LinkContentRequest request);

  $async.Future<$0.UpdateStockResponse> updateStock_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateStockRequest> $request) async {
    return updateStock($call, await $request);
  }

  $async.Future<$0.UpdateStockResponse> updateStock(
      $grpc.ServiceCall call, $0.UpdateStockRequest request);

  $async.Future<$0.SetAlertThresholdResponse> setAlertThreshold_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetAlertThresholdRequest> $request) async {
    return setAlertThreshold($call, await $request);
  }

  $async.Future<$0.SetAlertThresholdResponse> setAlertThreshold(
      $grpc.ServiceCall call, $0.SetAlertThresholdRequest request);

  $async.Future<$0.BulkArchiveResponse> bulkArchive_Pre($grpc.ServiceCall $call,
      $async.Future<$0.BulkArchiveRequest> $request) async {
    return bulkArchive($call, await $request);
  }

  $async.Future<$0.BulkArchiveResponse> bulkArchive(
      $grpc.ServiceCall call, $0.BulkArchiveRequest request);
}

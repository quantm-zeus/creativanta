// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/store.proto.

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

import 'store.pb.dart' as $0;

export 'store.pb.dart';

@$pb.GrpcServiceName('creativanta.commerce.v1.StoreService')
class StoreServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  StoreServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.StoreServiceCreatePageResponse> createPage(
    $0.StoreServiceCreatePageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPage, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceGetResponse> get(
    $0.StoreServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceGetPageResponse> getPage(
    $0.StoreServiceGetPageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPage, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceListResponse> list(
    $0.StoreServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceListPagesResponse> listPages(
    $0.StoreServiceListPagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPages, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceUpdatePageResponse> updatePage(
    $0.StoreServiceUpdatePageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePage, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServicePublishPageResponse> publishPage(
    $0.StoreServicePublishPageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$publishPage, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServicePublishResponse> publish(
    $0.StoreServicePublishRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$publish, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceUnpublishResponse> unpublish(
    $0.StoreServiceUnpublishRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unpublish, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceDeletePageResponse> deletePage(
    $0.StoreServiceDeletePageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deletePage, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceDuplicatePageResponse> duplicatePage(
    $0.StoreServiceDuplicatePageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$duplicatePage, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceGetThemesResponse> getThemes(
    $0.StoreServiceGetThemesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getThemes, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceGetPageStatsResponse> getPageStats(
    $0.StoreServiceGetPageStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPageStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceCheckoutResponse> checkout(
    $0.StoreServiceCheckoutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkout, request, options: options);
  }

  $grpc.ResponseFuture<$0.StoreServiceGetBuyerEntitlementsResponse>
      getBuyerEntitlements(
    $0.StoreServiceGetBuyerEntitlementsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBuyerEntitlements, request, options: options);
  }

  // method descriptors

  static final _$createPage = $grpc.ClientMethod<
          $0.StoreServiceCreatePageRequest, $0.StoreServiceCreatePageResponse>(
      '/creativanta.commerce.v1.StoreService/CreatePage',
      ($0.StoreServiceCreatePageRequest value) => value.writeToBuffer(),
      $0.StoreServiceCreatePageResponse.fromBuffer);
  static final _$get =
      $grpc.ClientMethod<$0.StoreServiceGetRequest, $0.StoreServiceGetResponse>(
          '/creativanta.commerce.v1.StoreService/Get',
          ($0.StoreServiceGetRequest value) => value.writeToBuffer(),
          $0.StoreServiceGetResponse.fromBuffer);
  static final _$getPage = $grpc.ClientMethod<$0.StoreServiceGetPageRequest,
          $0.StoreServiceGetPageResponse>(
      '/creativanta.commerce.v1.StoreService/GetPage',
      ($0.StoreServiceGetPageRequest value) => value.writeToBuffer(),
      $0.StoreServiceGetPageResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.StoreServiceListRequest,
          $0.StoreServiceListResponse>(
      '/creativanta.commerce.v1.StoreService/List',
      ($0.StoreServiceListRequest value) => value.writeToBuffer(),
      $0.StoreServiceListResponse.fromBuffer);
  static final _$listPages = $grpc.ClientMethod<$0.StoreServiceListPagesRequest,
          $0.StoreServiceListPagesResponse>(
      '/creativanta.commerce.v1.StoreService/ListPages',
      ($0.StoreServiceListPagesRequest value) => value.writeToBuffer(),
      $0.StoreServiceListPagesResponse.fromBuffer);
  static final _$updatePage = $grpc.ClientMethod<
          $0.StoreServiceUpdatePageRequest, $0.StoreServiceUpdatePageResponse>(
      '/creativanta.commerce.v1.StoreService/UpdatePage',
      ($0.StoreServiceUpdatePageRequest value) => value.writeToBuffer(),
      $0.StoreServiceUpdatePageResponse.fromBuffer);
  static final _$publishPage = $grpc.ClientMethod<
          $0.StoreServicePublishPageRequest,
          $0.StoreServicePublishPageResponse>(
      '/creativanta.commerce.v1.StoreService/PublishPage',
      ($0.StoreServicePublishPageRequest value) => value.writeToBuffer(),
      $0.StoreServicePublishPageResponse.fromBuffer);
  static final _$publish = $grpc.ClientMethod<$0.StoreServicePublishRequest,
          $0.StoreServicePublishResponse>(
      '/creativanta.commerce.v1.StoreService/Publish',
      ($0.StoreServicePublishRequest value) => value.writeToBuffer(),
      $0.StoreServicePublishResponse.fromBuffer);
  static final _$unpublish = $grpc.ClientMethod<$0.StoreServiceUnpublishRequest,
          $0.StoreServiceUnpublishResponse>(
      '/creativanta.commerce.v1.StoreService/Unpublish',
      ($0.StoreServiceUnpublishRequest value) => value.writeToBuffer(),
      $0.StoreServiceUnpublishResponse.fromBuffer);
  static final _$deletePage = $grpc.ClientMethod<
          $0.StoreServiceDeletePageRequest, $0.StoreServiceDeletePageResponse>(
      '/creativanta.commerce.v1.StoreService/DeletePage',
      ($0.StoreServiceDeletePageRequest value) => value.writeToBuffer(),
      $0.StoreServiceDeletePageResponse.fromBuffer);
  static final _$duplicatePage = $grpc.ClientMethod<
          $0.StoreServiceDuplicatePageRequest,
          $0.StoreServiceDuplicatePageResponse>(
      '/creativanta.commerce.v1.StoreService/DuplicatePage',
      ($0.StoreServiceDuplicatePageRequest value) => value.writeToBuffer(),
      $0.StoreServiceDuplicatePageResponse.fromBuffer);
  static final _$getThemes = $grpc.ClientMethod<$0.StoreServiceGetThemesRequest,
          $0.StoreServiceGetThemesResponse>(
      '/creativanta.commerce.v1.StoreService/GetThemes',
      ($0.StoreServiceGetThemesRequest value) => value.writeToBuffer(),
      $0.StoreServiceGetThemesResponse.fromBuffer);
  static final _$getPageStats = $grpc.ClientMethod<
          $0.StoreServiceGetPageStatsRequest,
          $0.StoreServiceGetPageStatsResponse>(
      '/creativanta.commerce.v1.StoreService/GetPageStats',
      ($0.StoreServiceGetPageStatsRequest value) => value.writeToBuffer(),
      $0.StoreServiceGetPageStatsResponse.fromBuffer);
  static final _$checkout = $grpc.ClientMethod<$0.StoreServiceCheckoutRequest,
          $0.StoreServiceCheckoutResponse>(
      '/creativanta.commerce.v1.StoreService/Checkout',
      ($0.StoreServiceCheckoutRequest value) => value.writeToBuffer(),
      $0.StoreServiceCheckoutResponse.fromBuffer);
  static final _$getBuyerEntitlements = $grpc.ClientMethod<
          $0.StoreServiceGetBuyerEntitlementsRequest,
          $0.StoreServiceGetBuyerEntitlementsResponse>(
      '/creativanta.commerce.v1.StoreService/GetBuyerEntitlements',
      ($0.StoreServiceGetBuyerEntitlementsRequest value) =>
          value.writeToBuffer(),
      $0.StoreServiceGetBuyerEntitlementsResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.StoreService')
abstract class StoreServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.StoreService';

  StoreServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.StoreServiceCreatePageRequest,
            $0.StoreServiceCreatePageResponse>(
        'CreatePage',
        createPage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceCreatePageRequest.fromBuffer(value),
        ($0.StoreServiceCreatePageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceGetRequest,
            $0.StoreServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceGetRequest.fromBuffer(value),
        ($0.StoreServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceGetPageRequest,
            $0.StoreServiceGetPageResponse>(
        'GetPage',
        getPage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceGetPageRequest.fromBuffer(value),
        ($0.StoreServiceGetPageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceListRequest,
            $0.StoreServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceListRequest.fromBuffer(value),
        ($0.StoreServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceListPagesRequest,
            $0.StoreServiceListPagesResponse>(
        'ListPages',
        listPages_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceListPagesRequest.fromBuffer(value),
        ($0.StoreServiceListPagesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceUpdatePageRequest,
            $0.StoreServiceUpdatePageResponse>(
        'UpdatePage',
        updatePage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceUpdatePageRequest.fromBuffer(value),
        ($0.StoreServiceUpdatePageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServicePublishPageRequest,
            $0.StoreServicePublishPageResponse>(
        'PublishPage',
        publishPage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServicePublishPageRequest.fromBuffer(value),
        ($0.StoreServicePublishPageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServicePublishRequest,
            $0.StoreServicePublishResponse>(
        'Publish',
        publish_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServicePublishRequest.fromBuffer(value),
        ($0.StoreServicePublishResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceUnpublishRequest,
            $0.StoreServiceUnpublishResponse>(
        'Unpublish',
        unpublish_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceUnpublishRequest.fromBuffer(value),
        ($0.StoreServiceUnpublishResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceDeletePageRequest,
            $0.StoreServiceDeletePageResponse>(
        'DeletePage',
        deletePage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceDeletePageRequest.fromBuffer(value),
        ($0.StoreServiceDeletePageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceDuplicatePageRequest,
            $0.StoreServiceDuplicatePageResponse>(
        'DuplicatePage',
        duplicatePage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceDuplicatePageRequest.fromBuffer(value),
        ($0.StoreServiceDuplicatePageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceGetThemesRequest,
            $0.StoreServiceGetThemesResponse>(
        'GetThemes',
        getThemes_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceGetThemesRequest.fromBuffer(value),
        ($0.StoreServiceGetThemesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceGetPageStatsRequest,
            $0.StoreServiceGetPageStatsResponse>(
        'GetPageStats',
        getPageStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceGetPageStatsRequest.fromBuffer(value),
        ($0.StoreServiceGetPageStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceCheckoutRequest,
            $0.StoreServiceCheckoutResponse>(
        'Checkout',
        checkout_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceCheckoutRequest.fromBuffer(value),
        ($0.StoreServiceCheckoutResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StoreServiceGetBuyerEntitlementsRequest,
            $0.StoreServiceGetBuyerEntitlementsResponse>(
        'GetBuyerEntitlements',
        getBuyerEntitlements_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StoreServiceGetBuyerEntitlementsRequest.fromBuffer(value),
        ($0.StoreServiceGetBuyerEntitlementsResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.StoreServiceCreatePageResponse> createPage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceCreatePageRequest> $request) async {
    return createPage($call, await $request);
  }

  $async.Future<$0.StoreServiceCreatePageResponse> createPage(
      $grpc.ServiceCall call, $0.StoreServiceCreatePageRequest request);

  $async.Future<$0.StoreServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.StoreServiceGetResponse> get(
      $grpc.ServiceCall call, $0.StoreServiceGetRequest request);

  $async.Future<$0.StoreServiceGetPageResponse> getPage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceGetPageRequest> $request) async {
    return getPage($call, await $request);
  }

  $async.Future<$0.StoreServiceGetPageResponse> getPage(
      $grpc.ServiceCall call, $0.StoreServiceGetPageRequest request);

  $async.Future<$0.StoreServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.StoreServiceListResponse> list(
      $grpc.ServiceCall call, $0.StoreServiceListRequest request);

  $async.Future<$0.StoreServiceListPagesResponse> listPages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceListPagesRequest> $request) async {
    return listPages($call, await $request);
  }

  $async.Future<$0.StoreServiceListPagesResponse> listPages(
      $grpc.ServiceCall call, $0.StoreServiceListPagesRequest request);

  $async.Future<$0.StoreServiceUpdatePageResponse> updatePage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceUpdatePageRequest> $request) async {
    return updatePage($call, await $request);
  }

  $async.Future<$0.StoreServiceUpdatePageResponse> updatePage(
      $grpc.ServiceCall call, $0.StoreServiceUpdatePageRequest request);

  $async.Future<$0.StoreServicePublishPageResponse> publishPage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServicePublishPageRequest> $request) async {
    return publishPage($call, await $request);
  }

  $async.Future<$0.StoreServicePublishPageResponse> publishPage(
      $grpc.ServiceCall call, $0.StoreServicePublishPageRequest request);

  $async.Future<$0.StoreServicePublishResponse> publish_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServicePublishRequest> $request) async {
    return publish($call, await $request);
  }

  $async.Future<$0.StoreServicePublishResponse> publish(
      $grpc.ServiceCall call, $0.StoreServicePublishRequest request);

  $async.Future<$0.StoreServiceUnpublishResponse> unpublish_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceUnpublishRequest> $request) async {
    return unpublish($call, await $request);
  }

  $async.Future<$0.StoreServiceUnpublishResponse> unpublish(
      $grpc.ServiceCall call, $0.StoreServiceUnpublishRequest request);

  $async.Future<$0.StoreServiceDeletePageResponse> deletePage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceDeletePageRequest> $request) async {
    return deletePage($call, await $request);
  }

  $async.Future<$0.StoreServiceDeletePageResponse> deletePage(
      $grpc.ServiceCall call, $0.StoreServiceDeletePageRequest request);

  $async.Future<$0.StoreServiceDuplicatePageResponse> duplicatePage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceDuplicatePageRequest> $request) async {
    return duplicatePage($call, await $request);
  }

  $async.Future<$0.StoreServiceDuplicatePageResponse> duplicatePage(
      $grpc.ServiceCall call, $0.StoreServiceDuplicatePageRequest request);

  $async.Future<$0.StoreServiceGetThemesResponse> getThemes_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceGetThemesRequest> $request) async {
    return getThemes($call, await $request);
  }

  $async.Future<$0.StoreServiceGetThemesResponse> getThemes(
      $grpc.ServiceCall call, $0.StoreServiceGetThemesRequest request);

  $async.Future<$0.StoreServiceGetPageStatsResponse> getPageStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceGetPageStatsRequest> $request) async {
    return getPageStats($call, await $request);
  }

  $async.Future<$0.StoreServiceGetPageStatsResponse> getPageStats(
      $grpc.ServiceCall call, $0.StoreServiceGetPageStatsRequest request);

  $async.Future<$0.StoreServiceCheckoutResponse> checkout_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StoreServiceCheckoutRequest> $request) async {
    return checkout($call, await $request);
  }

  $async.Future<$0.StoreServiceCheckoutResponse> checkout(
      $grpc.ServiceCall call, $0.StoreServiceCheckoutRequest request);

  $async.Future<$0.StoreServiceGetBuyerEntitlementsResponse>
      getBuyerEntitlements_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.StoreServiceGetBuyerEntitlementsRequest>
              $request) async {
    return getBuyerEntitlements($call, await $request);
  }

  $async.Future<$0.StoreServiceGetBuyerEntitlementsResponse>
      getBuyerEntitlements($grpc.ServiceCall call,
          $0.StoreServiceGetBuyerEntitlementsRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.MembershipService')
class MembershipServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MembershipServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.MembershipServiceCreatePlanResponse> createPlan(
    $0.MembershipServiceCreatePlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceGetPlanResponse> getPlan(
    $0.MembershipServiceGetPlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceListPlansResponse> listPlans(
    $0.MembershipServiceListPlansRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPlans, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceUpdatePlanResponse> updatePlan(
    $0.MembershipServiceUpdatePlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceDuplicatePlanResponse> duplicatePlan(
    $0.MembershipServiceDuplicatePlanRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$duplicatePlan, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceDeleteResponse> delete(
    $0.MembershipServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceArchiveResponse> archive(
    $0.MembershipServiceArchiveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$archive, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServicePublishResponse> publish(
    $0.MembershipServicePublishRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$publish, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServicePauseResponse> pause(
    $0.MembershipServicePauseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pause, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceResumeResponse> resume(
    $0.MembershipServiceResumeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resume, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceGetMRRSummaryResponse> getMRRSummary(
    $0.MembershipServiceGetMRRSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMRRSummary, request, options: options);
  }

  $grpc.ResponseFuture<$0.MembershipServiceGetMRRTrendResponse> getMRRTrend(
    $0.MembershipServiceGetMRRTrendRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMRRTrend, request, options: options);
  }

  // method descriptors

  static final _$createPlan = $grpc.ClientMethod<
          $0.MembershipServiceCreatePlanRequest,
          $0.MembershipServiceCreatePlanResponse>(
      '/creativanta.commerce.v1.MembershipService/CreatePlan',
      ($0.MembershipServiceCreatePlanRequest value) => value.writeToBuffer(),
      $0.MembershipServiceCreatePlanResponse.fromBuffer);
  static final _$getPlan = $grpc.ClientMethod<
          $0.MembershipServiceGetPlanRequest,
          $0.MembershipServiceGetPlanResponse>(
      '/creativanta.commerce.v1.MembershipService/GetPlan',
      ($0.MembershipServiceGetPlanRequest value) => value.writeToBuffer(),
      $0.MembershipServiceGetPlanResponse.fromBuffer);
  static final _$listPlans = $grpc.ClientMethod<
          $0.MembershipServiceListPlansRequest,
          $0.MembershipServiceListPlansResponse>(
      '/creativanta.commerce.v1.MembershipService/ListPlans',
      ($0.MembershipServiceListPlansRequest value) => value.writeToBuffer(),
      $0.MembershipServiceListPlansResponse.fromBuffer);
  static final _$updatePlan = $grpc.ClientMethod<
          $0.MembershipServiceUpdatePlanRequest,
          $0.MembershipServiceUpdatePlanResponse>(
      '/creativanta.commerce.v1.MembershipService/UpdatePlan',
      ($0.MembershipServiceUpdatePlanRequest value) => value.writeToBuffer(),
      $0.MembershipServiceUpdatePlanResponse.fromBuffer);
  static final _$duplicatePlan = $grpc.ClientMethod<
          $0.MembershipServiceDuplicatePlanRequest,
          $0.MembershipServiceDuplicatePlanResponse>(
      '/creativanta.commerce.v1.MembershipService/DuplicatePlan',
      ($0.MembershipServiceDuplicatePlanRequest value) => value.writeToBuffer(),
      $0.MembershipServiceDuplicatePlanResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.MembershipServiceDeleteRequest,
          $0.MembershipServiceDeleteResponse>(
      '/creativanta.commerce.v1.MembershipService/Delete',
      ($0.MembershipServiceDeleteRequest value) => value.writeToBuffer(),
      $0.MembershipServiceDeleteResponse.fromBuffer);
  static final _$archive = $grpc.ClientMethod<
          $0.MembershipServiceArchiveRequest,
          $0.MembershipServiceArchiveResponse>(
      '/creativanta.commerce.v1.MembershipService/Archive',
      ($0.MembershipServiceArchiveRequest value) => value.writeToBuffer(),
      $0.MembershipServiceArchiveResponse.fromBuffer);
  static final _$publish = $grpc.ClientMethod<
          $0.MembershipServicePublishRequest,
          $0.MembershipServicePublishResponse>(
      '/creativanta.commerce.v1.MembershipService/Publish',
      ($0.MembershipServicePublishRequest value) => value.writeToBuffer(),
      $0.MembershipServicePublishResponse.fromBuffer);
  static final _$pause = $grpc.ClientMethod<$0.MembershipServicePauseRequest,
          $0.MembershipServicePauseResponse>(
      '/creativanta.commerce.v1.MembershipService/Pause',
      ($0.MembershipServicePauseRequest value) => value.writeToBuffer(),
      $0.MembershipServicePauseResponse.fromBuffer);
  static final _$resume = $grpc.ClientMethod<$0.MembershipServiceResumeRequest,
          $0.MembershipServiceResumeResponse>(
      '/creativanta.commerce.v1.MembershipService/Resume',
      ($0.MembershipServiceResumeRequest value) => value.writeToBuffer(),
      $0.MembershipServiceResumeResponse.fromBuffer);
  static final _$getMRRSummary = $grpc.ClientMethod<
          $0.MembershipServiceGetMRRSummaryRequest,
          $0.MembershipServiceGetMRRSummaryResponse>(
      '/creativanta.commerce.v1.MembershipService/GetMRRSummary',
      ($0.MembershipServiceGetMRRSummaryRequest value) => value.writeToBuffer(),
      $0.MembershipServiceGetMRRSummaryResponse.fromBuffer);
  static final _$getMRRTrend = $grpc.ClientMethod<
          $0.MembershipServiceGetMRRTrendRequest,
          $0.MembershipServiceGetMRRTrendResponse>(
      '/creativanta.commerce.v1.MembershipService/GetMRRTrend',
      ($0.MembershipServiceGetMRRTrendRequest value) => value.writeToBuffer(),
      $0.MembershipServiceGetMRRTrendResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.MembershipService')
abstract class MembershipServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.MembershipService';

  MembershipServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceCreatePlanRequest,
            $0.MembershipServiceCreatePlanResponse>(
        'CreatePlan',
        createPlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceCreatePlanRequest.fromBuffer(value),
        ($0.MembershipServiceCreatePlanResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceGetPlanRequest,
            $0.MembershipServiceGetPlanResponse>(
        'GetPlan',
        getPlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceGetPlanRequest.fromBuffer(value),
        ($0.MembershipServiceGetPlanResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceListPlansRequest,
            $0.MembershipServiceListPlansResponse>(
        'ListPlans',
        listPlans_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceListPlansRequest.fromBuffer(value),
        ($0.MembershipServiceListPlansResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceUpdatePlanRequest,
            $0.MembershipServiceUpdatePlanResponse>(
        'UpdatePlan',
        updatePlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceUpdatePlanRequest.fromBuffer(value),
        ($0.MembershipServiceUpdatePlanResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceDuplicatePlanRequest,
            $0.MembershipServiceDuplicatePlanResponse>(
        'DuplicatePlan',
        duplicatePlan_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceDuplicatePlanRequest.fromBuffer(value),
        ($0.MembershipServiceDuplicatePlanResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceDeleteRequest,
            $0.MembershipServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceDeleteRequest.fromBuffer(value),
        ($0.MembershipServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceArchiveRequest,
            $0.MembershipServiceArchiveResponse>(
        'Archive',
        archive_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceArchiveRequest.fromBuffer(value),
        ($0.MembershipServiceArchiveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServicePublishRequest,
            $0.MembershipServicePublishResponse>(
        'Publish',
        publish_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServicePublishRequest.fromBuffer(value),
        ($0.MembershipServicePublishResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServicePauseRequest,
            $0.MembershipServicePauseResponse>(
        'Pause',
        pause_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServicePauseRequest.fromBuffer(value),
        ($0.MembershipServicePauseResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceResumeRequest,
            $0.MembershipServiceResumeResponse>(
        'Resume',
        resume_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceResumeRequest.fromBuffer(value),
        ($0.MembershipServiceResumeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceGetMRRSummaryRequest,
            $0.MembershipServiceGetMRRSummaryResponse>(
        'GetMRRSummary',
        getMRRSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceGetMRRSummaryRequest.fromBuffer(value),
        ($0.MembershipServiceGetMRRSummaryResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MembershipServiceGetMRRTrendRequest,
            $0.MembershipServiceGetMRRTrendResponse>(
        'GetMRRTrend',
        getMRRTrend_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MembershipServiceGetMRRTrendRequest.fromBuffer(value),
        ($0.MembershipServiceGetMRRTrendResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.MembershipServiceCreatePlanResponse> createPlan_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceCreatePlanRequest> $request) async {
    return createPlan($call, await $request);
  }

  $async.Future<$0.MembershipServiceCreatePlanResponse> createPlan(
      $grpc.ServiceCall call, $0.MembershipServiceCreatePlanRequest request);

  $async.Future<$0.MembershipServiceGetPlanResponse> getPlan_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceGetPlanRequest> $request) async {
    return getPlan($call, await $request);
  }

  $async.Future<$0.MembershipServiceGetPlanResponse> getPlan(
      $grpc.ServiceCall call, $0.MembershipServiceGetPlanRequest request);

  $async.Future<$0.MembershipServiceListPlansResponse> listPlans_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceListPlansRequest> $request) async {
    return listPlans($call, await $request);
  }

  $async.Future<$0.MembershipServiceListPlansResponse> listPlans(
      $grpc.ServiceCall call, $0.MembershipServiceListPlansRequest request);

  $async.Future<$0.MembershipServiceUpdatePlanResponse> updatePlan_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceUpdatePlanRequest> $request) async {
    return updatePlan($call, await $request);
  }

  $async.Future<$0.MembershipServiceUpdatePlanResponse> updatePlan(
      $grpc.ServiceCall call, $0.MembershipServiceUpdatePlanRequest request);

  $async.Future<$0.MembershipServiceDuplicatePlanResponse> duplicatePlan_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceDuplicatePlanRequest> $request) async {
    return duplicatePlan($call, await $request);
  }

  $async.Future<$0.MembershipServiceDuplicatePlanResponse> duplicatePlan(
      $grpc.ServiceCall call, $0.MembershipServiceDuplicatePlanRequest request);

  $async.Future<$0.MembershipServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.MembershipServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.MembershipServiceDeleteRequest request);

  $async.Future<$0.MembershipServiceArchiveResponse> archive_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceArchiveRequest> $request) async {
    return archive($call, await $request);
  }

  $async.Future<$0.MembershipServiceArchiveResponse> archive(
      $grpc.ServiceCall call, $0.MembershipServiceArchiveRequest request);

  $async.Future<$0.MembershipServicePublishResponse> publish_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServicePublishRequest> $request) async {
    return publish($call, await $request);
  }

  $async.Future<$0.MembershipServicePublishResponse> publish(
      $grpc.ServiceCall call, $0.MembershipServicePublishRequest request);

  $async.Future<$0.MembershipServicePauseResponse> pause_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServicePauseRequest> $request) async {
    return pause($call, await $request);
  }

  $async.Future<$0.MembershipServicePauseResponse> pause(
      $grpc.ServiceCall call, $0.MembershipServicePauseRequest request);

  $async.Future<$0.MembershipServiceResumeResponse> resume_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceResumeRequest> $request) async {
    return resume($call, await $request);
  }

  $async.Future<$0.MembershipServiceResumeResponse> resume(
      $grpc.ServiceCall call, $0.MembershipServiceResumeRequest request);

  $async.Future<$0.MembershipServiceGetMRRSummaryResponse> getMRRSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceGetMRRSummaryRequest> $request) async {
    return getMRRSummary($call, await $request);
  }

  $async.Future<$0.MembershipServiceGetMRRSummaryResponse> getMRRSummary(
      $grpc.ServiceCall call, $0.MembershipServiceGetMRRSummaryRequest request);

  $async.Future<$0.MembershipServiceGetMRRTrendResponse> getMRRTrend_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MembershipServiceGetMRRTrendRequest> $request) async {
    return getMRRTrend($call, await $request);
  }

  $async.Future<$0.MembershipServiceGetMRRTrendResponse> getMRRTrend(
      $grpc.ServiceCall call, $0.MembershipServiceGetMRRTrendRequest request);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.BundleService')
class BundleServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  BundleServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.BundleServiceCreateBundleResponse> createBundle(
    $0.BundleServiceCreateBundleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createBundle, request, options: options);
  }

  $grpc.ResponseFuture<$0.BundleServiceGetBundleResponse> getBundle(
    $0.BundleServiceGetBundleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBundle, request, options: options);
  }

  $grpc.ResponseFuture<$0.BundleServiceListBundlesResponse> listBundles(
    $0.BundleServiceListBundlesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listBundles, request, options: options);
  }

  $grpc.ResponseFuture<$0.BundleServiceCheckBundleStockResponse>
      checkBundleStock(
    $0.BundleServiceCheckBundleStockRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkBundleStock, request, options: options);
  }

  // method descriptors

  static final _$createBundle = $grpc.ClientMethod<
          $0.BundleServiceCreateBundleRequest,
          $0.BundleServiceCreateBundleResponse>(
      '/creativanta.commerce.v1.BundleService/CreateBundle',
      ($0.BundleServiceCreateBundleRequest value) => value.writeToBuffer(),
      $0.BundleServiceCreateBundleResponse.fromBuffer);
  static final _$getBundle = $grpc.ClientMethod<
          $0.BundleServiceGetBundleRequest, $0.BundleServiceGetBundleResponse>(
      '/creativanta.commerce.v1.BundleService/GetBundle',
      ($0.BundleServiceGetBundleRequest value) => value.writeToBuffer(),
      $0.BundleServiceGetBundleResponse.fromBuffer);
  static final _$listBundles = $grpc.ClientMethod<
          $0.BundleServiceListBundlesRequest,
          $0.BundleServiceListBundlesResponse>(
      '/creativanta.commerce.v1.BundleService/ListBundles',
      ($0.BundleServiceListBundlesRequest value) => value.writeToBuffer(),
      $0.BundleServiceListBundlesResponse.fromBuffer);
  static final _$checkBundleStock = $grpc.ClientMethod<
          $0.BundleServiceCheckBundleStockRequest,
          $0.BundleServiceCheckBundleStockResponse>(
      '/creativanta.commerce.v1.BundleService/CheckBundleStock',
      ($0.BundleServiceCheckBundleStockRequest value) => value.writeToBuffer(),
      $0.BundleServiceCheckBundleStockResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.BundleService')
abstract class BundleServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.BundleService';

  BundleServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.BundleServiceCreateBundleRequest,
            $0.BundleServiceCreateBundleResponse>(
        'CreateBundle',
        createBundle_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BundleServiceCreateBundleRequest.fromBuffer(value),
        ($0.BundleServiceCreateBundleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BundleServiceGetBundleRequest,
            $0.BundleServiceGetBundleResponse>(
        'GetBundle',
        getBundle_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BundleServiceGetBundleRequest.fromBuffer(value),
        ($0.BundleServiceGetBundleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BundleServiceListBundlesRequest,
            $0.BundleServiceListBundlesResponse>(
        'ListBundles',
        listBundles_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BundleServiceListBundlesRequest.fromBuffer(value),
        ($0.BundleServiceListBundlesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BundleServiceCheckBundleStockRequest,
            $0.BundleServiceCheckBundleStockResponse>(
        'CheckBundleStock',
        checkBundleStock_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BundleServiceCheckBundleStockRequest.fromBuffer(value),
        ($0.BundleServiceCheckBundleStockResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.BundleServiceCreateBundleResponse> createBundle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BundleServiceCreateBundleRequest> $request) async {
    return createBundle($call, await $request);
  }

  $async.Future<$0.BundleServiceCreateBundleResponse> createBundle(
      $grpc.ServiceCall call, $0.BundleServiceCreateBundleRequest request);

  $async.Future<$0.BundleServiceGetBundleResponse> getBundle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BundleServiceGetBundleRequest> $request) async {
    return getBundle($call, await $request);
  }

  $async.Future<$0.BundleServiceGetBundleResponse> getBundle(
      $grpc.ServiceCall call, $0.BundleServiceGetBundleRequest request);

  $async.Future<$0.BundleServiceListBundlesResponse> listBundles_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BundleServiceListBundlesRequest> $request) async {
    return listBundles($call, await $request);
  }

  $async.Future<$0.BundleServiceListBundlesResponse> listBundles(
      $grpc.ServiceCall call, $0.BundleServiceListBundlesRequest request);

  $async.Future<$0.BundleServiceCheckBundleStockResponse> checkBundleStock_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BundleServiceCheckBundleStockRequest> $request) async {
    return checkBundleStock($call, await $request);
  }

  $async.Future<$0.BundleServiceCheckBundleStockResponse> checkBundleStock(
      $grpc.ServiceCall call, $0.BundleServiceCheckBundleStockRequest request);
}

// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/monetization.proto.

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

import 'monetization.pb.dart' as $0;

export 'monetization.pb.dart';

/// Canonical Offer Service.
@$pb.GrpcServiceName('creativanta.commerce.v1.OfferService')
class OfferServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  OfferServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.OfferServiceCreateResponse> create(
    $0.OfferServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceGetResponse> get(
    $0.OfferServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceListResponse> list(
    $0.OfferServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceUpdateResponse> update(
    $0.OfferServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceActivateResponse> activate(
    $0.OfferServiceActivateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$activate, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServicePauseResponse> pause(
    $0.OfferServicePauseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pause, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceResumeResponse> resume(
    $0.OfferServiceResumeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resume, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceExpireResponse> expire(
    $0.OfferServiceExpireRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$expire, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceRetireResponse> retire(
    $0.OfferServiceRetireRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$retire, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceDuplicateResponse> duplicate(
    $0.OfferServiceDuplicateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$duplicate, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceDeleteResponse> delete(
    $0.OfferServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceBulkPauseResponse> bulkPause(
    $0.OfferServiceBulkPauseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$bulkPause, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceGetPerformanceResponse> getPerformance(
    $0.OfferServiceGetPerformanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPerformance, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceGetRedemptionStatsResponse>
      getRedemptionStats(
    $0.OfferServiceGetRedemptionStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRedemptionStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceGetStatusCountsResponse> getStatusCounts(
    $0.OfferServiceGetStatusCountsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStatusCounts, request, options: options);
  }

  $grpc.ResponseFuture<$0.OfferServiceGetTabSummaryResponse> getTabSummary(
    $0.OfferServiceGetTabSummaryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTabSummary, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.OfferServiceCreateRequest,
          $0.OfferServiceCreateResponse>(
      '/creativanta.commerce.v1.OfferService/Create',
      ($0.OfferServiceCreateRequest value) => value.writeToBuffer(),
      $0.OfferServiceCreateResponse.fromBuffer);
  static final _$get =
      $grpc.ClientMethod<$0.OfferServiceGetRequest, $0.OfferServiceGetResponse>(
          '/creativanta.commerce.v1.OfferService/Get',
          ($0.OfferServiceGetRequest value) => value.writeToBuffer(),
          $0.OfferServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.OfferServiceListRequest,
          $0.OfferServiceListResponse>(
      '/creativanta.commerce.v1.OfferService/List',
      ($0.OfferServiceListRequest value) => value.writeToBuffer(),
      $0.OfferServiceListResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.OfferServiceUpdateRequest,
          $0.OfferServiceUpdateResponse>(
      '/creativanta.commerce.v1.OfferService/Update',
      ($0.OfferServiceUpdateRequest value) => value.writeToBuffer(),
      $0.OfferServiceUpdateResponse.fromBuffer);
  static final _$activate = $grpc.ClientMethod<$0.OfferServiceActivateRequest,
          $0.OfferServiceActivateResponse>(
      '/creativanta.commerce.v1.OfferService/Activate',
      ($0.OfferServiceActivateRequest value) => value.writeToBuffer(),
      $0.OfferServiceActivateResponse.fromBuffer);
  static final _$pause = $grpc.ClientMethod<$0.OfferServicePauseRequest,
          $0.OfferServicePauseResponse>(
      '/creativanta.commerce.v1.OfferService/Pause',
      ($0.OfferServicePauseRequest value) => value.writeToBuffer(),
      $0.OfferServicePauseResponse.fromBuffer);
  static final _$resume = $grpc.ClientMethod<$0.OfferServiceResumeRequest,
          $0.OfferServiceResumeResponse>(
      '/creativanta.commerce.v1.OfferService/Resume',
      ($0.OfferServiceResumeRequest value) => value.writeToBuffer(),
      $0.OfferServiceResumeResponse.fromBuffer);
  static final _$expire = $grpc.ClientMethod<$0.OfferServiceExpireRequest,
          $0.OfferServiceExpireResponse>(
      '/creativanta.commerce.v1.OfferService/Expire',
      ($0.OfferServiceExpireRequest value) => value.writeToBuffer(),
      $0.OfferServiceExpireResponse.fromBuffer);
  static final _$retire = $grpc.ClientMethod<$0.OfferServiceRetireRequest,
          $0.OfferServiceRetireResponse>(
      '/creativanta.commerce.v1.OfferService/Retire',
      ($0.OfferServiceRetireRequest value) => value.writeToBuffer(),
      $0.OfferServiceRetireResponse.fromBuffer);
  static final _$duplicate = $grpc.ClientMethod<$0.OfferServiceDuplicateRequest,
          $0.OfferServiceDuplicateResponse>(
      '/creativanta.commerce.v1.OfferService/Duplicate',
      ($0.OfferServiceDuplicateRequest value) => value.writeToBuffer(),
      $0.OfferServiceDuplicateResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.OfferServiceDeleteRequest,
          $0.OfferServiceDeleteResponse>(
      '/creativanta.commerce.v1.OfferService/Delete',
      ($0.OfferServiceDeleteRequest value) => value.writeToBuffer(),
      $0.OfferServiceDeleteResponse.fromBuffer);
  static final _$bulkPause = $grpc.ClientMethod<$0.OfferServiceBulkPauseRequest,
          $0.OfferServiceBulkPauseResponse>(
      '/creativanta.commerce.v1.OfferService/BulkPause',
      ($0.OfferServiceBulkPauseRequest value) => value.writeToBuffer(),
      $0.OfferServiceBulkPauseResponse.fromBuffer);
  static final _$getPerformance = $grpc.ClientMethod<
          $0.OfferServiceGetPerformanceRequest,
          $0.OfferServiceGetPerformanceResponse>(
      '/creativanta.commerce.v1.OfferService/GetPerformance',
      ($0.OfferServiceGetPerformanceRequest value) => value.writeToBuffer(),
      $0.OfferServiceGetPerformanceResponse.fromBuffer);
  static final _$getRedemptionStats = $grpc.ClientMethod<
          $0.OfferServiceGetRedemptionStatsRequest,
          $0.OfferServiceGetRedemptionStatsResponse>(
      '/creativanta.commerce.v1.OfferService/GetRedemptionStats',
      ($0.OfferServiceGetRedemptionStatsRequest value) => value.writeToBuffer(),
      $0.OfferServiceGetRedemptionStatsResponse.fromBuffer);
  static final _$getStatusCounts = $grpc.ClientMethod<
          $0.OfferServiceGetStatusCountsRequest,
          $0.OfferServiceGetStatusCountsResponse>(
      '/creativanta.commerce.v1.OfferService/GetStatusCounts',
      ($0.OfferServiceGetStatusCountsRequest value) => value.writeToBuffer(),
      $0.OfferServiceGetStatusCountsResponse.fromBuffer);
  static final _$getTabSummary = $grpc.ClientMethod<
          $0.OfferServiceGetTabSummaryRequest,
          $0.OfferServiceGetTabSummaryResponse>(
      '/creativanta.commerce.v1.OfferService/GetTabSummary',
      ($0.OfferServiceGetTabSummaryRequest value) => value.writeToBuffer(),
      $0.OfferServiceGetTabSummaryResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.OfferService')
abstract class OfferServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.OfferService';

  OfferServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.OfferServiceCreateRequest,
            $0.OfferServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceCreateRequest.fromBuffer(value),
        ($0.OfferServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceGetRequest,
            $0.OfferServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceGetRequest.fromBuffer(value),
        ($0.OfferServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceListRequest,
            $0.OfferServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceListRequest.fromBuffer(value),
        ($0.OfferServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceUpdateRequest,
            $0.OfferServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceUpdateRequest.fromBuffer(value),
        ($0.OfferServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceActivateRequest,
            $0.OfferServiceActivateResponse>(
        'Activate',
        activate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceActivateRequest.fromBuffer(value),
        ($0.OfferServiceActivateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServicePauseRequest,
            $0.OfferServicePauseResponse>(
        'Pause',
        pause_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServicePauseRequest.fromBuffer(value),
        ($0.OfferServicePauseResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceResumeRequest,
            $0.OfferServiceResumeResponse>(
        'Resume',
        resume_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceResumeRequest.fromBuffer(value),
        ($0.OfferServiceResumeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceExpireRequest,
            $0.OfferServiceExpireResponse>(
        'Expire',
        expire_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceExpireRequest.fromBuffer(value),
        ($0.OfferServiceExpireResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceRetireRequest,
            $0.OfferServiceRetireResponse>(
        'Retire',
        retire_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceRetireRequest.fromBuffer(value),
        ($0.OfferServiceRetireResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceDuplicateRequest,
            $0.OfferServiceDuplicateResponse>(
        'Duplicate',
        duplicate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceDuplicateRequest.fromBuffer(value),
        ($0.OfferServiceDuplicateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceDeleteRequest,
            $0.OfferServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceDeleteRequest.fromBuffer(value),
        ($0.OfferServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceBulkPauseRequest,
            $0.OfferServiceBulkPauseResponse>(
        'BulkPause',
        bulkPause_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceBulkPauseRequest.fromBuffer(value),
        ($0.OfferServiceBulkPauseResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceGetPerformanceRequest,
            $0.OfferServiceGetPerformanceResponse>(
        'GetPerformance',
        getPerformance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceGetPerformanceRequest.fromBuffer(value),
        ($0.OfferServiceGetPerformanceResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceGetRedemptionStatsRequest,
            $0.OfferServiceGetRedemptionStatsResponse>(
        'GetRedemptionStats',
        getRedemptionStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceGetRedemptionStatsRequest.fromBuffer(value),
        ($0.OfferServiceGetRedemptionStatsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceGetStatusCountsRequest,
            $0.OfferServiceGetStatusCountsResponse>(
        'GetStatusCounts',
        getStatusCounts_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceGetStatusCountsRequest.fromBuffer(value),
        ($0.OfferServiceGetStatusCountsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferServiceGetTabSummaryRequest,
            $0.OfferServiceGetTabSummaryResponse>(
        'GetTabSummary',
        getTabSummary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OfferServiceGetTabSummaryRequest.fromBuffer(value),
        ($0.OfferServiceGetTabSummaryResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.OfferServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.OfferServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.OfferServiceCreateRequest request);

  $async.Future<$0.OfferServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.OfferServiceGetResponse> get(
      $grpc.ServiceCall call, $0.OfferServiceGetRequest request);

  $async.Future<$0.OfferServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.OfferServiceListResponse> list(
      $grpc.ServiceCall call, $0.OfferServiceListRequest request);

  $async.Future<$0.OfferServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.OfferServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.OfferServiceUpdateRequest request);

  $async.Future<$0.OfferServiceActivateResponse> activate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceActivateRequest> $request) async {
    return activate($call, await $request);
  }

  $async.Future<$0.OfferServiceActivateResponse> activate(
      $grpc.ServiceCall call, $0.OfferServiceActivateRequest request);

  $async.Future<$0.OfferServicePauseResponse> pause_Pre($grpc.ServiceCall $call,
      $async.Future<$0.OfferServicePauseRequest> $request) async {
    return pause($call, await $request);
  }

  $async.Future<$0.OfferServicePauseResponse> pause(
      $grpc.ServiceCall call, $0.OfferServicePauseRequest request);

  $async.Future<$0.OfferServiceResumeResponse> resume_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceResumeRequest> $request) async {
    return resume($call, await $request);
  }

  $async.Future<$0.OfferServiceResumeResponse> resume(
      $grpc.ServiceCall call, $0.OfferServiceResumeRequest request);

  $async.Future<$0.OfferServiceExpireResponse> expire_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceExpireRequest> $request) async {
    return expire($call, await $request);
  }

  $async.Future<$0.OfferServiceExpireResponse> expire(
      $grpc.ServiceCall call, $0.OfferServiceExpireRequest request);

  $async.Future<$0.OfferServiceRetireResponse> retire_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceRetireRequest> $request) async {
    return retire($call, await $request);
  }

  $async.Future<$0.OfferServiceRetireResponse> retire(
      $grpc.ServiceCall call, $0.OfferServiceRetireRequest request);

  $async.Future<$0.OfferServiceDuplicateResponse> duplicate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceDuplicateRequest> $request) async {
    return duplicate($call, await $request);
  }

  $async.Future<$0.OfferServiceDuplicateResponse> duplicate(
      $grpc.ServiceCall call, $0.OfferServiceDuplicateRequest request);

  $async.Future<$0.OfferServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.OfferServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.OfferServiceDeleteRequest request);

  $async.Future<$0.OfferServiceBulkPauseResponse> bulkPause_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceBulkPauseRequest> $request) async {
    return bulkPause($call, await $request);
  }

  $async.Future<$0.OfferServiceBulkPauseResponse> bulkPause(
      $grpc.ServiceCall call, $0.OfferServiceBulkPauseRequest request);

  $async.Future<$0.OfferServiceGetPerformanceResponse> getPerformance_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceGetPerformanceRequest> $request) async {
    return getPerformance($call, await $request);
  }

  $async.Future<$0.OfferServiceGetPerformanceResponse> getPerformance(
      $grpc.ServiceCall call, $0.OfferServiceGetPerformanceRequest request);

  $async.Future<$0.OfferServiceGetRedemptionStatsResponse>
      getRedemptionStats_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.OfferServiceGetRedemptionStatsRequest>
              $request) async {
    return getRedemptionStats($call, await $request);
  }

  $async.Future<$0.OfferServiceGetRedemptionStatsResponse> getRedemptionStats(
      $grpc.ServiceCall call, $0.OfferServiceGetRedemptionStatsRequest request);

  $async.Future<$0.OfferServiceGetStatusCountsResponse> getStatusCounts_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceGetStatusCountsRequest> $request) async {
    return getStatusCounts($call, await $request);
  }

  $async.Future<$0.OfferServiceGetStatusCountsResponse> getStatusCounts(
      $grpc.ServiceCall call, $0.OfferServiceGetStatusCountsRequest request);

  $async.Future<$0.OfferServiceGetTabSummaryResponse> getTabSummary_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OfferServiceGetTabSummaryRequest> $request) async {
    return getTabSummary($call, await $request);
  }

  $async.Future<$0.OfferServiceGetTabSummaryResponse> getTabSummary(
      $grpc.ServiceCall call, $0.OfferServiceGetTabSummaryRequest request);
}

/// Canonical Coupon Service.
@$pb.GrpcServiceName('creativanta.commerce.v1.CouponService')
class CouponServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CouponServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CouponServiceCreateResponse> create(
    $0.CouponServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceGetResponse> get(
    $0.CouponServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceListResponse> list(
    $0.CouponServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceValidateCouponResponse> validateCoupon(
    $0.CouponServiceValidateCouponRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$validateCoupon, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceUpdateResponse> update(
    $0.CouponServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceActivateResponse> activate(
    $0.CouponServiceActivateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$activate, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServicePauseResponse> pause(
    $0.CouponServicePauseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pause, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceResumeResponse> resume(
    $0.CouponServiceResumeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resume, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceDeactivateResponse> deactivate(
    $0.CouponServiceDeactivateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deactivate, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceDeleteResponse> delete(
    $0.CouponServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceRevokeResponse> revoke(
    $0.CouponServiceRevokeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$revoke, request, options: options);
  }

  $grpc.ResponseFuture<$0.CouponServiceCheckAvailabilityResponse>
      checkAvailability(
    $0.CouponServiceCheckAvailabilityRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkAvailability, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.CouponServiceCreateRequest,
          $0.CouponServiceCreateResponse>(
      '/creativanta.commerce.v1.CouponService/Create',
      ($0.CouponServiceCreateRequest value) => value.writeToBuffer(),
      $0.CouponServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.CouponServiceGetRequest,
          $0.CouponServiceGetResponse>(
      '/creativanta.commerce.v1.CouponService/Get',
      ($0.CouponServiceGetRequest value) => value.writeToBuffer(),
      $0.CouponServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.CouponServiceListRequest,
          $0.CouponServiceListResponse>(
      '/creativanta.commerce.v1.CouponService/List',
      ($0.CouponServiceListRequest value) => value.writeToBuffer(),
      $0.CouponServiceListResponse.fromBuffer);
  static final _$validateCoupon = $grpc.ClientMethod<
          $0.CouponServiceValidateCouponRequest,
          $0.CouponServiceValidateCouponResponse>(
      '/creativanta.commerce.v1.CouponService/ValidateCoupon',
      ($0.CouponServiceValidateCouponRequest value) => value.writeToBuffer(),
      $0.CouponServiceValidateCouponResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.CouponServiceUpdateRequest,
          $0.CouponServiceUpdateResponse>(
      '/creativanta.commerce.v1.CouponService/Update',
      ($0.CouponServiceUpdateRequest value) => value.writeToBuffer(),
      $0.CouponServiceUpdateResponse.fromBuffer);
  static final _$activate = $grpc.ClientMethod<$0.CouponServiceActivateRequest,
          $0.CouponServiceActivateResponse>(
      '/creativanta.commerce.v1.CouponService/Activate',
      ($0.CouponServiceActivateRequest value) => value.writeToBuffer(),
      $0.CouponServiceActivateResponse.fromBuffer);
  static final _$pause = $grpc.ClientMethod<$0.CouponServicePauseRequest,
          $0.CouponServicePauseResponse>(
      '/creativanta.commerce.v1.CouponService/Pause',
      ($0.CouponServicePauseRequest value) => value.writeToBuffer(),
      $0.CouponServicePauseResponse.fromBuffer);
  static final _$resume = $grpc.ClientMethod<$0.CouponServiceResumeRequest,
          $0.CouponServiceResumeResponse>(
      '/creativanta.commerce.v1.CouponService/Resume',
      ($0.CouponServiceResumeRequest value) => value.writeToBuffer(),
      $0.CouponServiceResumeResponse.fromBuffer);
  static final _$deactivate = $grpc.ClientMethod<
          $0.CouponServiceDeactivateRequest,
          $0.CouponServiceDeactivateResponse>(
      '/creativanta.commerce.v1.CouponService/Deactivate',
      ($0.CouponServiceDeactivateRequest value) => value.writeToBuffer(),
      $0.CouponServiceDeactivateResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.CouponServiceDeleteRequest,
          $0.CouponServiceDeleteResponse>(
      '/creativanta.commerce.v1.CouponService/Delete',
      ($0.CouponServiceDeleteRequest value) => value.writeToBuffer(),
      $0.CouponServiceDeleteResponse.fromBuffer);
  static final _$revoke = $grpc.ClientMethod<$0.CouponServiceRevokeRequest,
          $0.CouponServiceRevokeResponse>(
      '/creativanta.commerce.v1.CouponService/Revoke',
      ($0.CouponServiceRevokeRequest value) => value.writeToBuffer(),
      $0.CouponServiceRevokeResponse.fromBuffer);
  static final _$checkAvailability = $grpc.ClientMethod<
          $0.CouponServiceCheckAvailabilityRequest,
          $0.CouponServiceCheckAvailabilityResponse>(
      '/creativanta.commerce.v1.CouponService/CheckAvailability',
      ($0.CouponServiceCheckAvailabilityRequest value) => value.writeToBuffer(),
      $0.CouponServiceCheckAvailabilityResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.CouponService')
abstract class CouponServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.CouponService';

  CouponServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CouponServiceCreateRequest,
            $0.CouponServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceCreateRequest.fromBuffer(value),
        ($0.CouponServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceGetRequest,
            $0.CouponServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceGetRequest.fromBuffer(value),
        ($0.CouponServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceListRequest,
            $0.CouponServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceListRequest.fromBuffer(value),
        ($0.CouponServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceValidateCouponRequest,
            $0.CouponServiceValidateCouponResponse>(
        'ValidateCoupon',
        validateCoupon_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceValidateCouponRequest.fromBuffer(value),
        ($0.CouponServiceValidateCouponResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceUpdateRequest,
            $0.CouponServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceUpdateRequest.fromBuffer(value),
        ($0.CouponServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceActivateRequest,
            $0.CouponServiceActivateResponse>(
        'Activate',
        activate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceActivateRequest.fromBuffer(value),
        ($0.CouponServiceActivateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServicePauseRequest,
            $0.CouponServicePauseResponse>(
        'Pause',
        pause_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServicePauseRequest.fromBuffer(value),
        ($0.CouponServicePauseResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceResumeRequest,
            $0.CouponServiceResumeResponse>(
        'Resume',
        resume_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceResumeRequest.fromBuffer(value),
        ($0.CouponServiceResumeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceDeactivateRequest,
            $0.CouponServiceDeactivateResponse>(
        'Deactivate',
        deactivate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceDeactivateRequest.fromBuffer(value),
        ($0.CouponServiceDeactivateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceDeleteRequest,
            $0.CouponServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceDeleteRequest.fromBuffer(value),
        ($0.CouponServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceRevokeRequest,
            $0.CouponServiceRevokeResponse>(
        'Revoke',
        revoke_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceRevokeRequest.fromBuffer(value),
        ($0.CouponServiceRevokeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CouponServiceCheckAvailabilityRequest,
            $0.CouponServiceCheckAvailabilityResponse>(
        'CheckAvailability',
        checkAvailability_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CouponServiceCheckAvailabilityRequest.fromBuffer(value),
        ($0.CouponServiceCheckAvailabilityResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.CouponServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.CouponServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.CouponServiceCreateRequest request);

  $async.Future<$0.CouponServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.CouponServiceGetResponse> get(
      $grpc.ServiceCall call, $0.CouponServiceGetRequest request);

  $async.Future<$0.CouponServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.CouponServiceListResponse> list(
      $grpc.ServiceCall call, $0.CouponServiceListRequest request);

  $async.Future<$0.CouponServiceValidateCouponResponse> validateCoupon_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceValidateCouponRequest> $request) async {
    return validateCoupon($call, await $request);
  }

  $async.Future<$0.CouponServiceValidateCouponResponse> validateCoupon(
      $grpc.ServiceCall call, $0.CouponServiceValidateCouponRequest request);

  $async.Future<$0.CouponServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.CouponServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.CouponServiceUpdateRequest request);

  $async.Future<$0.CouponServiceActivateResponse> activate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceActivateRequest> $request) async {
    return activate($call, await $request);
  }

  $async.Future<$0.CouponServiceActivateResponse> activate(
      $grpc.ServiceCall call, $0.CouponServiceActivateRequest request);

  $async.Future<$0.CouponServicePauseResponse> pause_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServicePauseRequest> $request) async {
    return pause($call, await $request);
  }

  $async.Future<$0.CouponServicePauseResponse> pause(
      $grpc.ServiceCall call, $0.CouponServicePauseRequest request);

  $async.Future<$0.CouponServiceResumeResponse> resume_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceResumeRequest> $request) async {
    return resume($call, await $request);
  }

  $async.Future<$0.CouponServiceResumeResponse> resume(
      $grpc.ServiceCall call, $0.CouponServiceResumeRequest request);

  $async.Future<$0.CouponServiceDeactivateResponse> deactivate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceDeactivateRequest> $request) async {
    return deactivate($call, await $request);
  }

  $async.Future<$0.CouponServiceDeactivateResponse> deactivate(
      $grpc.ServiceCall call, $0.CouponServiceDeactivateRequest request);

  $async.Future<$0.CouponServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.CouponServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.CouponServiceDeleteRequest request);

  $async.Future<$0.CouponServiceRevokeResponse> revoke_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CouponServiceRevokeRequest> $request) async {
    return revoke($call, await $request);
  }

  $async.Future<$0.CouponServiceRevokeResponse> revoke(
      $grpc.ServiceCall call, $0.CouponServiceRevokeRequest request);

  $async.Future<$0.CouponServiceCheckAvailabilityResponse>
      checkAvailability_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CouponServiceCheckAvailabilityRequest>
              $request) async {
    return checkAvailability($call, await $request);
  }

  $async.Future<$0.CouponServiceCheckAvailabilityResponse> checkAvailability(
      $grpc.ServiceCall call, $0.CouponServiceCheckAvailabilityRequest request);
}

/// Canonical Campaign Service.
@$pb.GrpcServiceName('creativanta.commerce.v1.CampaignService')
class CampaignServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CampaignServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CampaignServiceCreateResponse> create(
    $0.CampaignServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetResponse> get(
    $0.CampaignServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceListResponse> list(
    $0.CampaignServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceUpdateResponse> update(
    $0.CampaignServiceUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceActivateResponse> activate(
    $0.CampaignServiceActivateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$activate, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServicePauseResponse> pause(
    $0.CampaignServicePauseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pause, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceResumeResponse> resume(
    $0.CampaignServiceResumeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resume, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceEndResponse> end(
    $0.CampaignServiceEndRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$end, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceDeleteResponse> delete(
    $0.CampaignServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceDuplicateResponse> duplicate(
    $0.CampaignServiceDuplicateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$duplicate, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceExportReportResponse> exportReport(
    $0.CampaignServiceExportReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exportReport, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceAddCostResponse> addCost(
    $0.CampaignServiceAddCostRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addCost, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetCostsResponse> getCosts(
    $0.CampaignServiceGetCostsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCosts, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetFunnelResponse> getFunnel(
    $0.CampaignServiceGetFunnelRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFunnel, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetMetricsResponse> getMetrics(
    $0.CampaignServiceGetMetricsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMetrics, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetLinkedContentResponse>
      getLinkedContent(
    $0.CampaignServiceGetLinkedContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLinkedContent, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetLinkedOffersResponse>
      getLinkedOffers(
    $0.CampaignServiceGetLinkedOffersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLinkedOffers, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetPlatformBreakdownResponse>
      getPlatformBreakdown(
    $0.CampaignServiceGetPlatformBreakdownRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPlatformBreakdown, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetRevenueTimelineResponse>
      getRevenueTimeline(
    $0.CampaignServiceGetRevenueTimelineRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRevenueTimeline, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceGetTopProductsResponse> getTopProducts(
    $0.CampaignServiceGetTopProductsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTopProducts, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceLinkContentResponse> linkContent(
    $0.CampaignServiceLinkContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$linkContent, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceLinkOfferResponse> linkOffer(
    $0.CampaignServiceLinkOfferRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$linkOffer, request, options: options);
  }

  $grpc.ResponseFuture<$0.CampaignServiceUnlinkContentResponse> unlinkContent(
    $0.CampaignServiceUnlinkContentRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unlinkContent, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.CampaignServiceCreateRequest,
          $0.CampaignServiceCreateResponse>(
      '/creativanta.commerce.v1.CampaignService/Create',
      ($0.CampaignServiceCreateRequest value) => value.writeToBuffer(),
      $0.CampaignServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.CampaignServiceGetRequest,
          $0.CampaignServiceGetResponse>(
      '/creativanta.commerce.v1.CampaignService/Get',
      ($0.CampaignServiceGetRequest value) => value.writeToBuffer(),
      $0.CampaignServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.CampaignServiceListRequest,
          $0.CampaignServiceListResponse>(
      '/creativanta.commerce.v1.CampaignService/List',
      ($0.CampaignServiceListRequest value) => value.writeToBuffer(),
      $0.CampaignServiceListResponse.fromBuffer);
  static final _$update = $grpc.ClientMethod<$0.CampaignServiceUpdateRequest,
          $0.CampaignServiceUpdateResponse>(
      '/creativanta.commerce.v1.CampaignService/Update',
      ($0.CampaignServiceUpdateRequest value) => value.writeToBuffer(),
      $0.CampaignServiceUpdateResponse.fromBuffer);
  static final _$activate = $grpc.ClientMethod<
          $0.CampaignServiceActivateRequest,
          $0.CampaignServiceActivateResponse>(
      '/creativanta.commerce.v1.CampaignService/Activate',
      ($0.CampaignServiceActivateRequest value) => value.writeToBuffer(),
      $0.CampaignServiceActivateResponse.fromBuffer);
  static final _$pause = $grpc.ClientMethod<$0.CampaignServicePauseRequest,
          $0.CampaignServicePauseResponse>(
      '/creativanta.commerce.v1.CampaignService/Pause',
      ($0.CampaignServicePauseRequest value) => value.writeToBuffer(),
      $0.CampaignServicePauseResponse.fromBuffer);
  static final _$resume = $grpc.ClientMethod<$0.CampaignServiceResumeRequest,
          $0.CampaignServiceResumeResponse>(
      '/creativanta.commerce.v1.CampaignService/Resume',
      ($0.CampaignServiceResumeRequest value) => value.writeToBuffer(),
      $0.CampaignServiceResumeResponse.fromBuffer);
  static final _$end = $grpc.ClientMethod<$0.CampaignServiceEndRequest,
          $0.CampaignServiceEndResponse>(
      '/creativanta.commerce.v1.CampaignService/End',
      ($0.CampaignServiceEndRequest value) => value.writeToBuffer(),
      $0.CampaignServiceEndResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.CampaignServiceDeleteRequest,
          $0.CampaignServiceDeleteResponse>(
      '/creativanta.commerce.v1.CampaignService/Delete',
      ($0.CampaignServiceDeleteRequest value) => value.writeToBuffer(),
      $0.CampaignServiceDeleteResponse.fromBuffer);
  static final _$duplicate = $grpc.ClientMethod<
          $0.CampaignServiceDuplicateRequest,
          $0.CampaignServiceDuplicateResponse>(
      '/creativanta.commerce.v1.CampaignService/Duplicate',
      ($0.CampaignServiceDuplicateRequest value) => value.writeToBuffer(),
      $0.CampaignServiceDuplicateResponse.fromBuffer);
  static final _$exportReport = $grpc.ClientMethod<
          $0.CampaignServiceExportReportRequest,
          $0.CampaignServiceExportReportResponse>(
      '/creativanta.commerce.v1.CampaignService/ExportReport',
      ($0.CampaignServiceExportReportRequest value) => value.writeToBuffer(),
      $0.CampaignServiceExportReportResponse.fromBuffer);
  static final _$addCost = $grpc.ClientMethod<$0.CampaignServiceAddCostRequest,
          $0.CampaignServiceAddCostResponse>(
      '/creativanta.commerce.v1.CampaignService/AddCost',
      ($0.CampaignServiceAddCostRequest value) => value.writeToBuffer(),
      $0.CampaignServiceAddCostResponse.fromBuffer);
  static final _$getCosts = $grpc.ClientMethod<
          $0.CampaignServiceGetCostsRequest,
          $0.CampaignServiceGetCostsResponse>(
      '/creativanta.commerce.v1.CampaignService/GetCosts',
      ($0.CampaignServiceGetCostsRequest value) => value.writeToBuffer(),
      $0.CampaignServiceGetCostsResponse.fromBuffer);
  static final _$getFunnel = $grpc.ClientMethod<
          $0.CampaignServiceGetFunnelRequest,
          $0.CampaignServiceGetFunnelResponse>(
      '/creativanta.commerce.v1.CampaignService/GetFunnel',
      ($0.CampaignServiceGetFunnelRequest value) => value.writeToBuffer(),
      $0.CampaignServiceGetFunnelResponse.fromBuffer);
  static final _$getMetrics = $grpc.ClientMethod<
          $0.CampaignServiceGetMetricsRequest,
          $0.CampaignServiceGetMetricsResponse>(
      '/creativanta.commerce.v1.CampaignService/GetMetrics',
      ($0.CampaignServiceGetMetricsRequest value) => value.writeToBuffer(),
      $0.CampaignServiceGetMetricsResponse.fromBuffer);
  static final _$getLinkedContent = $grpc.ClientMethod<
          $0.CampaignServiceGetLinkedContentRequest,
          $0.CampaignServiceGetLinkedContentResponse>(
      '/creativanta.commerce.v1.CampaignService/GetLinkedContent',
      ($0.CampaignServiceGetLinkedContentRequest value) =>
          value.writeToBuffer(),
      $0.CampaignServiceGetLinkedContentResponse.fromBuffer);
  static final _$getLinkedOffers = $grpc.ClientMethod<
          $0.CampaignServiceGetLinkedOffersRequest,
          $0.CampaignServiceGetLinkedOffersResponse>(
      '/creativanta.commerce.v1.CampaignService/GetLinkedOffers',
      ($0.CampaignServiceGetLinkedOffersRequest value) => value.writeToBuffer(),
      $0.CampaignServiceGetLinkedOffersResponse.fromBuffer);
  static final _$getPlatformBreakdown = $grpc.ClientMethod<
          $0.CampaignServiceGetPlatformBreakdownRequest,
          $0.CampaignServiceGetPlatformBreakdownResponse>(
      '/creativanta.commerce.v1.CampaignService/GetPlatformBreakdown',
      ($0.CampaignServiceGetPlatformBreakdownRequest value) =>
          value.writeToBuffer(),
      $0.CampaignServiceGetPlatformBreakdownResponse.fromBuffer);
  static final _$getRevenueTimeline = $grpc.ClientMethod<
          $0.CampaignServiceGetRevenueTimelineRequest,
          $0.CampaignServiceGetRevenueTimelineResponse>(
      '/creativanta.commerce.v1.CampaignService/GetRevenueTimeline',
      ($0.CampaignServiceGetRevenueTimelineRequest value) =>
          value.writeToBuffer(),
      $0.CampaignServiceGetRevenueTimelineResponse.fromBuffer);
  static final _$getTopProducts = $grpc.ClientMethod<
          $0.CampaignServiceGetTopProductsRequest,
          $0.CampaignServiceGetTopProductsResponse>(
      '/creativanta.commerce.v1.CampaignService/GetTopProducts',
      ($0.CampaignServiceGetTopProductsRequest value) => value.writeToBuffer(),
      $0.CampaignServiceGetTopProductsResponse.fromBuffer);
  static final _$linkContent = $grpc.ClientMethod<
          $0.CampaignServiceLinkContentRequest,
          $0.CampaignServiceLinkContentResponse>(
      '/creativanta.commerce.v1.CampaignService/LinkContent',
      ($0.CampaignServiceLinkContentRequest value) => value.writeToBuffer(),
      $0.CampaignServiceLinkContentResponse.fromBuffer);
  static final _$linkOffer = $grpc.ClientMethod<
          $0.CampaignServiceLinkOfferRequest,
          $0.CampaignServiceLinkOfferResponse>(
      '/creativanta.commerce.v1.CampaignService/LinkOffer',
      ($0.CampaignServiceLinkOfferRequest value) => value.writeToBuffer(),
      $0.CampaignServiceLinkOfferResponse.fromBuffer);
  static final _$unlinkContent = $grpc.ClientMethod<
          $0.CampaignServiceUnlinkContentRequest,
          $0.CampaignServiceUnlinkContentResponse>(
      '/creativanta.commerce.v1.CampaignService/UnlinkContent',
      ($0.CampaignServiceUnlinkContentRequest value) => value.writeToBuffer(),
      $0.CampaignServiceUnlinkContentResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.CampaignService')
abstract class CampaignServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.CampaignService';

  CampaignServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceCreateRequest,
            $0.CampaignServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceCreateRequest.fromBuffer(value),
        ($0.CampaignServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceGetRequest,
            $0.CampaignServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetRequest.fromBuffer(value),
        ($0.CampaignServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceListRequest,
            $0.CampaignServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceListRequest.fromBuffer(value),
        ($0.CampaignServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceUpdateRequest,
            $0.CampaignServiceUpdateResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceUpdateRequest.fromBuffer(value),
        ($0.CampaignServiceUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceActivateRequest,
            $0.CampaignServiceActivateResponse>(
        'Activate',
        activate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceActivateRequest.fromBuffer(value),
        ($0.CampaignServiceActivateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServicePauseRequest,
            $0.CampaignServicePauseResponse>(
        'Pause',
        pause_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServicePauseRequest.fromBuffer(value),
        ($0.CampaignServicePauseResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceResumeRequest,
            $0.CampaignServiceResumeResponse>(
        'Resume',
        resume_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceResumeRequest.fromBuffer(value),
        ($0.CampaignServiceResumeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceEndRequest,
            $0.CampaignServiceEndResponse>(
        'End',
        end_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceEndRequest.fromBuffer(value),
        ($0.CampaignServiceEndResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceDeleteRequest,
            $0.CampaignServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceDeleteRequest.fromBuffer(value),
        ($0.CampaignServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceDuplicateRequest,
            $0.CampaignServiceDuplicateResponse>(
        'Duplicate',
        duplicate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceDuplicateRequest.fromBuffer(value),
        ($0.CampaignServiceDuplicateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceExportReportRequest,
            $0.CampaignServiceExportReportResponse>(
        'ExportReport',
        exportReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceExportReportRequest.fromBuffer(value),
        ($0.CampaignServiceExportReportResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceAddCostRequest,
            $0.CampaignServiceAddCostResponse>(
        'AddCost',
        addCost_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceAddCostRequest.fromBuffer(value),
        ($0.CampaignServiceAddCostResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceGetCostsRequest,
            $0.CampaignServiceGetCostsResponse>(
        'GetCosts',
        getCosts_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetCostsRequest.fromBuffer(value),
        ($0.CampaignServiceGetCostsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceGetFunnelRequest,
            $0.CampaignServiceGetFunnelResponse>(
        'GetFunnel',
        getFunnel_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetFunnelRequest.fromBuffer(value),
        ($0.CampaignServiceGetFunnelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceGetMetricsRequest,
            $0.CampaignServiceGetMetricsResponse>(
        'GetMetrics',
        getMetrics_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetMetricsRequest.fromBuffer(value),
        ($0.CampaignServiceGetMetricsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceGetLinkedContentRequest,
            $0.CampaignServiceGetLinkedContentResponse>(
        'GetLinkedContent',
        getLinkedContent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetLinkedContentRequest.fromBuffer(value),
        ($0.CampaignServiceGetLinkedContentResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceGetLinkedOffersRequest,
            $0.CampaignServiceGetLinkedOffersResponse>(
        'GetLinkedOffers',
        getLinkedOffers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetLinkedOffersRequest.fromBuffer(value),
        ($0.CampaignServiceGetLinkedOffersResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<
            $0.CampaignServiceGetPlatformBreakdownRequest,
            $0.CampaignServiceGetPlatformBreakdownResponse>(
        'GetPlatformBreakdown',
        getPlatformBreakdown_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetPlatformBreakdownRequest.fromBuffer(value),
        ($0.CampaignServiceGetPlatformBreakdownResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceGetRevenueTimelineRequest,
            $0.CampaignServiceGetRevenueTimelineResponse>(
        'GetRevenueTimeline',
        getRevenueTimeline_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetRevenueTimelineRequest.fromBuffer(value),
        ($0.CampaignServiceGetRevenueTimelineResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceGetTopProductsRequest,
            $0.CampaignServiceGetTopProductsResponse>(
        'GetTopProducts',
        getTopProducts_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceGetTopProductsRequest.fromBuffer(value),
        ($0.CampaignServiceGetTopProductsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceLinkContentRequest,
            $0.CampaignServiceLinkContentResponse>(
        'LinkContent',
        linkContent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceLinkContentRequest.fromBuffer(value),
        ($0.CampaignServiceLinkContentResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceLinkOfferRequest,
            $0.CampaignServiceLinkOfferResponse>(
        'LinkOffer',
        linkOffer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceLinkOfferRequest.fromBuffer(value),
        ($0.CampaignServiceLinkOfferResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CampaignServiceUnlinkContentRequest,
            $0.CampaignServiceUnlinkContentResponse>(
        'UnlinkContent',
        unlinkContent_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CampaignServiceUnlinkContentRequest.fromBuffer(value),
        ($0.CampaignServiceUnlinkContentResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.CampaignServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.CampaignServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.CampaignServiceCreateRequest request);

  $async.Future<$0.CampaignServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetResponse> get(
      $grpc.ServiceCall call, $0.CampaignServiceGetRequest request);

  $async.Future<$0.CampaignServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.CampaignServiceListResponse> list(
      $grpc.ServiceCall call, $0.CampaignServiceListRequest request);

  $async.Future<$0.CampaignServiceUpdateResponse> update_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceUpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$0.CampaignServiceUpdateResponse> update(
      $grpc.ServiceCall call, $0.CampaignServiceUpdateRequest request);

  $async.Future<$0.CampaignServiceActivateResponse> activate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceActivateRequest> $request) async {
    return activate($call, await $request);
  }

  $async.Future<$0.CampaignServiceActivateResponse> activate(
      $grpc.ServiceCall call, $0.CampaignServiceActivateRequest request);

  $async.Future<$0.CampaignServicePauseResponse> pause_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServicePauseRequest> $request) async {
    return pause($call, await $request);
  }

  $async.Future<$0.CampaignServicePauseResponse> pause(
      $grpc.ServiceCall call, $0.CampaignServicePauseRequest request);

  $async.Future<$0.CampaignServiceResumeResponse> resume_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceResumeRequest> $request) async {
    return resume($call, await $request);
  }

  $async.Future<$0.CampaignServiceResumeResponse> resume(
      $grpc.ServiceCall call, $0.CampaignServiceResumeRequest request);

  $async.Future<$0.CampaignServiceEndResponse> end_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceEndRequest> $request) async {
    return end($call, await $request);
  }

  $async.Future<$0.CampaignServiceEndResponse> end(
      $grpc.ServiceCall call, $0.CampaignServiceEndRequest request);

  $async.Future<$0.CampaignServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.CampaignServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.CampaignServiceDeleteRequest request);

  $async.Future<$0.CampaignServiceDuplicateResponse> duplicate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceDuplicateRequest> $request) async {
    return duplicate($call, await $request);
  }

  $async.Future<$0.CampaignServiceDuplicateResponse> duplicate(
      $grpc.ServiceCall call, $0.CampaignServiceDuplicateRequest request);

  $async.Future<$0.CampaignServiceExportReportResponse> exportReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceExportReportRequest> $request) async {
    return exportReport($call, await $request);
  }

  $async.Future<$0.CampaignServiceExportReportResponse> exportReport(
      $grpc.ServiceCall call, $0.CampaignServiceExportReportRequest request);

  $async.Future<$0.CampaignServiceAddCostResponse> addCost_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceAddCostRequest> $request) async {
    return addCost($call, await $request);
  }

  $async.Future<$0.CampaignServiceAddCostResponse> addCost(
      $grpc.ServiceCall call, $0.CampaignServiceAddCostRequest request);

  $async.Future<$0.CampaignServiceGetCostsResponse> getCosts_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceGetCostsRequest> $request) async {
    return getCosts($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetCostsResponse> getCosts(
      $grpc.ServiceCall call, $0.CampaignServiceGetCostsRequest request);

  $async.Future<$0.CampaignServiceGetFunnelResponse> getFunnel_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceGetFunnelRequest> $request) async {
    return getFunnel($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetFunnelResponse> getFunnel(
      $grpc.ServiceCall call, $0.CampaignServiceGetFunnelRequest request);

  $async.Future<$0.CampaignServiceGetMetricsResponse> getMetrics_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceGetMetricsRequest> $request) async {
    return getMetrics($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetMetricsResponse> getMetrics(
      $grpc.ServiceCall call, $0.CampaignServiceGetMetricsRequest request);

  $async.Future<$0.CampaignServiceGetLinkedContentResponse>
      getLinkedContent_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CampaignServiceGetLinkedContentRequest>
              $request) async {
    return getLinkedContent($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetLinkedContentResponse> getLinkedContent(
      $grpc.ServiceCall call,
      $0.CampaignServiceGetLinkedContentRequest request);

  $async.Future<$0.CampaignServiceGetLinkedOffersResponse> getLinkedOffers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceGetLinkedOffersRequest> $request) async {
    return getLinkedOffers($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetLinkedOffersResponse> getLinkedOffers(
      $grpc.ServiceCall call, $0.CampaignServiceGetLinkedOffersRequest request);

  $async.Future<$0.CampaignServiceGetPlatformBreakdownResponse>
      getPlatformBreakdown_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CampaignServiceGetPlatformBreakdownRequest>
              $request) async {
    return getPlatformBreakdown($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetPlatformBreakdownResponse>
      getPlatformBreakdown($grpc.ServiceCall call,
          $0.CampaignServiceGetPlatformBreakdownRequest request);

  $async.Future<$0.CampaignServiceGetRevenueTimelineResponse>
      getRevenueTimeline_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.CampaignServiceGetRevenueTimelineRequest>
              $request) async {
    return getRevenueTimeline($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetRevenueTimelineResponse>
      getRevenueTimeline($grpc.ServiceCall call,
          $0.CampaignServiceGetRevenueTimelineRequest request);

  $async.Future<$0.CampaignServiceGetTopProductsResponse> getTopProducts_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceGetTopProductsRequest> $request) async {
    return getTopProducts($call, await $request);
  }

  $async.Future<$0.CampaignServiceGetTopProductsResponse> getTopProducts(
      $grpc.ServiceCall call, $0.CampaignServiceGetTopProductsRequest request);

  $async.Future<$0.CampaignServiceLinkContentResponse> linkContent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceLinkContentRequest> $request) async {
    return linkContent($call, await $request);
  }

  $async.Future<$0.CampaignServiceLinkContentResponse> linkContent(
      $grpc.ServiceCall call, $0.CampaignServiceLinkContentRequest request);

  $async.Future<$0.CampaignServiceLinkOfferResponse> linkOffer_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceLinkOfferRequest> $request) async {
    return linkOffer($call, await $request);
  }

  $async.Future<$0.CampaignServiceLinkOfferResponse> linkOffer(
      $grpc.ServiceCall call, $0.CampaignServiceLinkOfferRequest request);

  $async.Future<$0.CampaignServiceUnlinkContentResponse> unlinkContent_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CampaignServiceUnlinkContentRequest> $request) async {
    return unlinkContent($call, await $request);
  }

  $async.Future<$0.CampaignServiceUnlinkContentResponse> unlinkContent(
      $grpc.ServiceCall call, $0.CampaignServiceUnlinkContentRequest request);
}

/// Canonical Monetization Service coordinating checkout and ledger integration.
@$pb.GrpcServiceName('creativanta.commerce.v1.MonetizationService')
class MonetizationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MonetizationServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.MonetizationServiceEvaluateCheckoutResponse>
      evaluateCheckout(
    $0.MonetizationServiceEvaluateCheckoutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$evaluateCheckout, request, options: options);
  }

  // method descriptors

  static final _$evaluateCheckout = $grpc.ClientMethod<
          $0.MonetizationServiceEvaluateCheckoutRequest,
          $0.MonetizationServiceEvaluateCheckoutResponse>(
      '/creativanta.commerce.v1.MonetizationService/EvaluateCheckout',
      ($0.MonetizationServiceEvaluateCheckoutRequest value) =>
          value.writeToBuffer(),
      $0.MonetizationServiceEvaluateCheckoutResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.commerce.v1.MonetizationService')
abstract class MonetizationServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.commerce.v1.MonetizationService';

  MonetizationServiceBase() {
    $addMethod($grpc.ServiceMethod<
            $0.MonetizationServiceEvaluateCheckoutRequest,
            $0.MonetizationServiceEvaluateCheckoutResponse>(
        'EvaluateCheckout',
        evaluateCheckout_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.MonetizationServiceEvaluateCheckoutRequest.fromBuffer(value),
        ($0.MonetizationServiceEvaluateCheckoutResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.MonetizationServiceEvaluateCheckoutResponse>
      evaluateCheckout_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.MonetizationServiceEvaluateCheckoutRequest>
              $request) async {
    return evaluateCheckout($call, await $request);
  }

  $async.Future<$0.MonetizationServiceEvaluateCheckoutResponse>
      evaluateCheckout($grpc.ServiceCall call,
          $0.MonetizationServiceEvaluateCheckoutRequest request);
}

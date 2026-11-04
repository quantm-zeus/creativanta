// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/public_api.proto.

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

import 'public_api.pb.dart' as $0;

export 'public_api.pb.dart';

/// APIKeyService manages developer API keys, scoping, rate limits and rotation per S24.
@$pb.GrpcServiceName('creativanta.platform.v1.APIKeyService')
class APIKeyServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  APIKeyServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateResponse> create(
    $0.CreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListResponse> list(
    $0.ListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.RevokeResponse> revoke(
    $0.RevokeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$revoke, request, options: options);
  }

  $grpc.ResponseFuture<$0.RotateResponse> rotate(
    $0.RotateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rotate, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUsageResponse> getUsage(
    $0.GetUsageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUsage, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUsageStatsResponse> getUsageStats(
    $0.GetUsageStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUsageStats, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateScopesResponse> updateScopes(
    $0.UpdateScopesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateScopes, request, options: options);
  }

  // method descriptors

  static final _$create =
      $grpc.ClientMethod<$0.CreateRequest, $0.CreateResponse>(
          '/creativanta.platform.v1.APIKeyService/Create',
          ($0.CreateRequest value) => value.writeToBuffer(),
          $0.CreateResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
      '/creativanta.platform.v1.APIKeyService/List',
      ($0.ListRequest value) => value.writeToBuffer(),
      $0.ListResponse.fromBuffer);
  static final _$revoke =
      $grpc.ClientMethod<$0.RevokeRequest, $0.RevokeResponse>(
          '/creativanta.platform.v1.APIKeyService/Revoke',
          ($0.RevokeRequest value) => value.writeToBuffer(),
          $0.RevokeResponse.fromBuffer);
  static final _$rotate =
      $grpc.ClientMethod<$0.RotateRequest, $0.RotateResponse>(
          '/creativanta.platform.v1.APIKeyService/Rotate',
          ($0.RotateRequest value) => value.writeToBuffer(),
          $0.RotateResponse.fromBuffer);
  static final _$getUsage =
      $grpc.ClientMethod<$0.GetUsageRequest, $0.GetUsageResponse>(
          '/creativanta.platform.v1.APIKeyService/GetUsage',
          ($0.GetUsageRequest value) => value.writeToBuffer(),
          $0.GetUsageResponse.fromBuffer);
  static final _$getUsageStats =
      $grpc.ClientMethod<$0.GetUsageStatsRequest, $0.GetUsageStatsResponse>(
          '/creativanta.platform.v1.APIKeyService/GetUsageStats',
          ($0.GetUsageStatsRequest value) => value.writeToBuffer(),
          $0.GetUsageStatsResponse.fromBuffer);
  static final _$updateScopes =
      $grpc.ClientMethod<$0.UpdateScopesRequest, $0.UpdateScopesResponse>(
          '/creativanta.platform.v1.APIKeyService/UpdateScopes',
          ($0.UpdateScopesRequest value) => value.writeToBuffer(),
          $0.UpdateScopesResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.platform.v1.APIKeyService')
abstract class APIKeyServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.platform.v1.APIKeyService';

  APIKeyServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateRequest, $0.CreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateRequest.fromBuffer(value),
        ($0.CreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRequest, $0.ListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRequest.fromBuffer(value),
        ($0.ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RevokeRequest, $0.RevokeResponse>(
        'Revoke',
        revoke_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RevokeRequest.fromBuffer(value),
        ($0.RevokeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RotateRequest, $0.RotateResponse>(
        'Rotate',
        rotate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RotateRequest.fromBuffer(value),
        ($0.RotateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUsageRequest, $0.GetUsageResponse>(
        'GetUsage',
        getUsage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetUsageRequest.fromBuffer(value),
        ($0.GetUsageResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetUsageStatsRequest, $0.GetUsageStatsResponse>(
            'GetUsageStats',
            getUsageStats_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetUsageStatsRequest.fromBuffer(value),
            ($0.GetUsageStatsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdateScopesRequest, $0.UpdateScopesResponse>(
            'UpdateScopes',
            updateScopes_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdateScopesRequest.fromBuffer(value),
            ($0.UpdateScopesResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateResponse> create_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.CreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.CreateResponse> create(
      $grpc.ServiceCall call, $0.CreateRequest request);

  $async.Future<$0.ListResponse> list_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ListResponse> list(
      $grpc.ServiceCall call, $0.ListRequest request);

  $async.Future<$0.RevokeResponse> revoke_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.RevokeRequest> $request) async {
    return revoke($call, await $request);
  }

  $async.Future<$0.RevokeResponse> revoke(
      $grpc.ServiceCall call, $0.RevokeRequest request);

  $async.Future<$0.RotateResponse> rotate_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.RotateRequest> $request) async {
    return rotate($call, await $request);
  }

  $async.Future<$0.RotateResponse> rotate(
      $grpc.ServiceCall call, $0.RotateRequest request);

  $async.Future<$0.GetUsageResponse> getUsage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetUsageRequest> $request) async {
    return getUsage($call, await $request);
  }

  $async.Future<$0.GetUsageResponse> getUsage(
      $grpc.ServiceCall call, $0.GetUsageRequest request);

  $async.Future<$0.GetUsageStatsResponse> getUsageStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUsageStatsRequest> $request) async {
    return getUsageStats($call, await $request);
  }

  $async.Future<$0.GetUsageStatsResponse> getUsageStats(
      $grpc.ServiceCall call, $0.GetUsageStatsRequest request);

  $async.Future<$0.UpdateScopesResponse> updateScopes_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateScopesRequest> $request) async {
    return updateScopes($call, await $request);
  }

  $async.Future<$0.UpdateScopesResponse> updateScopes(
      $grpc.ServiceCall call, $0.UpdateScopesRequest request);
}

/// WebhookSubscriptionService manages outbound webhook registrations and deliveries.
@$pb.GrpcServiceName('creativanta.platform.v1.WebhookSubscriptionService')
class WebhookSubscriptionServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  WebhookSubscriptionServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreateWebhookSubscriptionResponse>
      createWebhookSubscription(
    $0.CreateWebhookSubscriptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createWebhookSubscription, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ListWebhookSubscriptionsResponse>
      listWebhookSubscriptions(
    $0.ListWebhookSubscriptionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listWebhookSubscriptions, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.DeleteWebhookSubscriptionResponse>
      deleteWebhookSubscription(
    $0.DeleteWebhookSubscriptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteWebhookSubscription, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.TestWebhookSubscriptionResponse>
      testWebhookSubscription(
    $0.TestWebhookSubscriptionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$testWebhookSubscription, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ReplayWebhookDeliveryResponse> replayWebhookDelivery(
    $0.ReplayWebhookDeliveryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$replayWebhookDelivery, request, options: options);
  }

  // method descriptors

  static final _$createWebhookSubscription = $grpc.ClientMethod<
          $0.CreateWebhookSubscriptionRequest,
          $0.CreateWebhookSubscriptionResponse>(
      '/creativanta.platform.v1.WebhookSubscriptionService/CreateWebhookSubscription',
      ($0.CreateWebhookSubscriptionRequest value) => value.writeToBuffer(),
      $0.CreateWebhookSubscriptionResponse.fromBuffer);
  static final _$listWebhookSubscriptions = $grpc.ClientMethod<
          $0.ListWebhookSubscriptionsRequest,
          $0.ListWebhookSubscriptionsResponse>(
      '/creativanta.platform.v1.WebhookSubscriptionService/ListWebhookSubscriptions',
      ($0.ListWebhookSubscriptionsRequest value) => value.writeToBuffer(),
      $0.ListWebhookSubscriptionsResponse.fromBuffer);
  static final _$deleteWebhookSubscription = $grpc.ClientMethod<
          $0.DeleteWebhookSubscriptionRequest,
          $0.DeleteWebhookSubscriptionResponse>(
      '/creativanta.platform.v1.WebhookSubscriptionService/DeleteWebhookSubscription',
      ($0.DeleteWebhookSubscriptionRequest value) => value.writeToBuffer(),
      $0.DeleteWebhookSubscriptionResponse.fromBuffer);
  static final _$testWebhookSubscription = $grpc.ClientMethod<
          $0.TestWebhookSubscriptionRequest,
          $0.TestWebhookSubscriptionResponse>(
      '/creativanta.platform.v1.WebhookSubscriptionService/TestWebhookSubscription',
      ($0.TestWebhookSubscriptionRequest value) => value.writeToBuffer(),
      $0.TestWebhookSubscriptionResponse.fromBuffer);
  static final _$replayWebhookDelivery = $grpc.ClientMethod<
          $0.ReplayWebhookDeliveryRequest, $0.ReplayWebhookDeliveryResponse>(
      '/creativanta.platform.v1.WebhookSubscriptionService/ReplayWebhookDelivery',
      ($0.ReplayWebhookDeliveryRequest value) => value.writeToBuffer(),
      $0.ReplayWebhookDeliveryResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.platform.v1.WebhookSubscriptionService')
abstract class WebhookSubscriptionServiceBase extends $grpc.Service {
  $core.String get $name =>
      'creativanta.platform.v1.WebhookSubscriptionService';

  WebhookSubscriptionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateWebhookSubscriptionRequest,
            $0.CreateWebhookSubscriptionResponse>(
        'CreateWebhookSubscription',
        createWebhookSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateWebhookSubscriptionRequest.fromBuffer(value),
        ($0.CreateWebhookSubscriptionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListWebhookSubscriptionsRequest,
            $0.ListWebhookSubscriptionsResponse>(
        'ListWebhookSubscriptions',
        listWebhookSubscriptions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListWebhookSubscriptionsRequest.fromBuffer(value),
        ($0.ListWebhookSubscriptionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteWebhookSubscriptionRequest,
            $0.DeleteWebhookSubscriptionResponse>(
        'DeleteWebhookSubscription',
        deleteWebhookSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteWebhookSubscriptionRequest.fromBuffer(value),
        ($0.DeleteWebhookSubscriptionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TestWebhookSubscriptionRequest,
            $0.TestWebhookSubscriptionResponse>(
        'TestWebhookSubscription',
        testWebhookSubscription_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TestWebhookSubscriptionRequest.fromBuffer(value),
        ($0.TestWebhookSubscriptionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReplayWebhookDeliveryRequest,
            $0.ReplayWebhookDeliveryResponse>(
        'ReplayWebhookDelivery',
        replayWebhookDelivery_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReplayWebhookDeliveryRequest.fromBuffer(value),
        ($0.ReplayWebhookDeliveryResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateWebhookSubscriptionResponse>
      createWebhookSubscription_Pre($grpc.ServiceCall $call,
          $async.Future<$0.CreateWebhookSubscriptionRequest> $request) async {
    return createWebhookSubscription($call, await $request);
  }

  $async.Future<$0.CreateWebhookSubscriptionResponse> createWebhookSubscription(
      $grpc.ServiceCall call, $0.CreateWebhookSubscriptionRequest request);

  $async.Future<$0.ListWebhookSubscriptionsResponse>
      listWebhookSubscriptions_Pre($grpc.ServiceCall $call,
          $async.Future<$0.ListWebhookSubscriptionsRequest> $request) async {
    return listWebhookSubscriptions($call, await $request);
  }

  $async.Future<$0.ListWebhookSubscriptionsResponse> listWebhookSubscriptions(
      $grpc.ServiceCall call, $0.ListWebhookSubscriptionsRequest request);

  $async.Future<$0.DeleteWebhookSubscriptionResponse>
      deleteWebhookSubscription_Pre($grpc.ServiceCall $call,
          $async.Future<$0.DeleteWebhookSubscriptionRequest> $request) async {
    return deleteWebhookSubscription($call, await $request);
  }

  $async.Future<$0.DeleteWebhookSubscriptionResponse> deleteWebhookSubscription(
      $grpc.ServiceCall call, $0.DeleteWebhookSubscriptionRequest request);

  $async.Future<$0.TestWebhookSubscriptionResponse> testWebhookSubscription_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TestWebhookSubscriptionRequest> $request) async {
    return testWebhookSubscription($call, await $request);
  }

  $async.Future<$0.TestWebhookSubscriptionResponse> testWebhookSubscription(
      $grpc.ServiceCall call, $0.TestWebhookSubscriptionRequest request);

  $async.Future<$0.ReplayWebhookDeliveryResponse> replayWebhookDelivery_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReplayWebhookDeliveryRequest> $request) async {
    return replayWebhookDelivery($call, await $request);
  }

  $async.Future<$0.ReplayWebhookDeliveryResponse> replayWebhookDelivery(
      $grpc.ServiceCall call, $0.ReplayWebhookDeliveryRequest request);
}

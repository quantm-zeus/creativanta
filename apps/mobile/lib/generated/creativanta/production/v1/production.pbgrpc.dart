// This is a generated file - do not edit.
//
// Generated from creativanta/production/v1/production.proto.

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

import 'production.pb.dart' as $0;

export 'production.pb.dart';

/// StudioService manages studio modes, monitoring, and job queues.
@$pb.GrpcServiceName('creativanta.production.v1.StudioService')
class StudioServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  StudioServiceClient(super.channel, {super.options, super.interceptors});

  /// GetModes returns the list of available studio modes and current pricing/limits.
  $grpc.ResponseFuture<$0.GetModesResponse> getModes(
    $0.GetModesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getModes, request, options: options);
  }

  /// GetActiveJobs returns active processing and queued generation jobs.
  $grpc.ResponseFuture<$0.GetActiveJobsResponse> getActiveJobs(
    $0.GetActiveJobsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getActiveJobs, request, options: options);
  }

  /// GetRecentAssets returns the most recent outputs for the studio launcher.
  $grpc.ResponseFuture<$0.GetRecentAssetsResponse> getRecentAssets(
    $0.GetRecentAssetsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRecentAssets, request, options: options);
  }

  /// Cancel cancels an in-flight or queued job and handles credit reconciliation/refund.
  $grpc.ResponseFuture<$0.CancelResponse> cancel(
    $0.CancelRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancel, request, options: options);
  }

  /// Retry retries a failed generation job, optionally switching to a fallback provider.
  $grpc.ResponseFuture<$0.RetryResponse> retry(
    $0.RetryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$retry, request, options: options);
  }

  // method descriptors

  static final _$getModes =
      $grpc.ClientMethod<$0.GetModesRequest, $0.GetModesResponse>(
          '/creativanta.production.v1.StudioService/GetModes',
          ($0.GetModesRequest value) => value.writeToBuffer(),
          $0.GetModesResponse.fromBuffer);
  static final _$getActiveJobs =
      $grpc.ClientMethod<$0.GetActiveJobsRequest, $0.GetActiveJobsResponse>(
          '/creativanta.production.v1.StudioService/GetActiveJobs',
          ($0.GetActiveJobsRequest value) => value.writeToBuffer(),
          $0.GetActiveJobsResponse.fromBuffer);
  static final _$getRecentAssets =
      $grpc.ClientMethod<$0.GetRecentAssetsRequest, $0.GetRecentAssetsResponse>(
          '/creativanta.production.v1.StudioService/GetRecentAssets',
          ($0.GetRecentAssetsRequest value) => value.writeToBuffer(),
          $0.GetRecentAssetsResponse.fromBuffer);
  static final _$cancel =
      $grpc.ClientMethod<$0.CancelRequest, $0.CancelResponse>(
          '/creativanta.production.v1.StudioService/Cancel',
          ($0.CancelRequest value) => value.writeToBuffer(),
          $0.CancelResponse.fromBuffer);
  static final _$retry = $grpc.ClientMethod<$0.RetryRequest, $0.RetryResponse>(
      '/creativanta.production.v1.StudioService/Retry',
      ($0.RetryRequest value) => value.writeToBuffer(),
      $0.RetryResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.StudioService')
abstract class StudioServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.StudioService';

  StudioServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetModesRequest, $0.GetModesResponse>(
        'GetModes',
        getModes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetModesRequest.fromBuffer(value),
        ($0.GetModesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetActiveJobsRequest, $0.GetActiveJobsResponse>(
            'GetActiveJobs',
            getActiveJobs_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetActiveJobsRequest.fromBuffer(value),
            ($0.GetActiveJobsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRecentAssetsRequest,
            $0.GetRecentAssetsResponse>(
        'GetRecentAssets',
        getRecentAssets_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRecentAssetsRequest.fromBuffer(value),
        ($0.GetRecentAssetsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelRequest, $0.CancelResponse>(
        'Cancel',
        cancel_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CancelRequest.fromBuffer(value),
        ($0.CancelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RetryRequest, $0.RetryResponse>(
        'Retry',
        retry_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RetryRequest.fromBuffer(value),
        ($0.RetryResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetModesResponse> getModes_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetModesRequest> $request) async {
    return getModes($call, await $request);
  }

  $async.Future<$0.GetModesResponse> getModes(
      $grpc.ServiceCall call, $0.GetModesRequest request);

  $async.Future<$0.GetActiveJobsResponse> getActiveJobs_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetActiveJobsRequest> $request) async {
    return getActiveJobs($call, await $request);
  }

  $async.Future<$0.GetActiveJobsResponse> getActiveJobs(
      $grpc.ServiceCall call, $0.GetActiveJobsRequest request);

  $async.Future<$0.GetRecentAssetsResponse> getRecentAssets_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRecentAssetsRequest> $request) async {
    return getRecentAssets($call, await $request);
  }

  $async.Future<$0.GetRecentAssetsResponse> getRecentAssets(
      $grpc.ServiceCall call, $0.GetRecentAssetsRequest request);

  $async.Future<$0.CancelResponse> cancel_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.CancelRequest> $request) async {
    return cancel($call, await $request);
  }

  $async.Future<$0.CancelResponse> cancel(
      $grpc.ServiceCall call, $0.CancelRequest request);

  $async.Future<$0.RetryResponse> retry_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.RetryRequest> $request) async {
    return retry($call, await $request);
  }

  $async.Future<$0.RetryResponse> retry(
      $grpc.ServiceCall call, $0.RetryRequest request);
}

/// AssetService manages generation, lifecycle, approval, and promotion of assets.
@$pb.GrpcServiceName('creativanta.production.v1.AssetService')
class AssetServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AssetServiceClient(super.channel, {super.options, super.interceptors});

  /// Generate initiates AI generation or executes preflight budget preview (dry_run).
  $grpc.ResponseFuture<$0.GenerateResponse> generate(
    $0.GenerateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generate, request, options: options);
  }

  /// GetStatus polls current job execution and aggregate asset state.
  $grpc.ResponseFuture<$0.GetStatusResponse> getStatus(
    $0.GetStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStatus, request, options: options);
  }

  /// List returns workspace assets filtered by state or type.
  $grpc.ResponseFuture<$0.ListResponse> list(
    $0.ListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  /// Get retrieves a single asset with full lineage metadata.
  $grpc.ResponseFuture<$0.GetResponse> get(
    $0.GetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  /// Approve marks an asset approved (Manager+).
  $grpc.ResponseFuture<$0.ApproveResponse> approve(
    $0.ApproveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approve, request, options: options);
  }

  /// PromoteCanonical promotes an approved asset to canonical character/brand pack (Manager+).
  $grpc.ResponseFuture<$0.PromoteCanonicalResponse> promoteCanonical(
    $0.PromoteCanonicalRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$promoteCanonical, request, options: options);
  }

  /// Upload uploads a source asset safely with MIME and virus scan checks.
  $grpc.ResponseFuture<$0.UploadResponse> upload(
    $0.UploadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$upload, request, options: options);
  }

  // method descriptors

  static final _$generate =
      $grpc.ClientMethod<$0.GenerateRequest, $0.GenerateResponse>(
          '/creativanta.production.v1.AssetService/Generate',
          ($0.GenerateRequest value) => value.writeToBuffer(),
          $0.GenerateResponse.fromBuffer);
  static final _$getStatus =
      $grpc.ClientMethod<$0.GetStatusRequest, $0.GetStatusResponse>(
          '/creativanta.production.v1.AssetService/GetStatus',
          ($0.GetStatusRequest value) => value.writeToBuffer(),
          $0.GetStatusResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.ListRequest, $0.ListResponse>(
      '/creativanta.production.v1.AssetService/List',
      ($0.ListRequest value) => value.writeToBuffer(),
      $0.ListResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.GetRequest, $0.GetResponse>(
      '/creativanta.production.v1.AssetService/Get',
      ($0.GetRequest value) => value.writeToBuffer(),
      $0.GetResponse.fromBuffer);
  static final _$approve =
      $grpc.ClientMethod<$0.ApproveRequest, $0.ApproveResponse>(
          '/creativanta.production.v1.AssetService/Approve',
          ($0.ApproveRequest value) => value.writeToBuffer(),
          $0.ApproveResponse.fromBuffer);
  static final _$promoteCanonical = $grpc.ClientMethod<
          $0.PromoteCanonicalRequest, $0.PromoteCanonicalResponse>(
      '/creativanta.production.v1.AssetService/PromoteCanonical',
      ($0.PromoteCanonicalRequest value) => value.writeToBuffer(),
      $0.PromoteCanonicalResponse.fromBuffer);
  static final _$upload =
      $grpc.ClientMethod<$0.UploadRequest, $0.UploadResponse>(
          '/creativanta.production.v1.AssetService/Upload',
          ($0.UploadRequest value) => value.writeToBuffer(),
          $0.UploadResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.AssetService')
abstract class AssetServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.AssetService';

  AssetServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GenerateRequest, $0.GenerateResponse>(
        'Generate',
        generate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GenerateRequest.fromBuffer(value),
        ($0.GenerateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetStatusRequest, $0.GetStatusResponse>(
        'GetStatus',
        getStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStatusRequest.fromBuffer(value),
        ($0.GetStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRequest, $0.ListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRequest.fromBuffer(value),
        ($0.ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRequest, $0.GetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetRequest.fromBuffer(value),
        ($0.GetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApproveRequest, $0.ApproveResponse>(
        'Approve',
        approve_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ApproveRequest.fromBuffer(value),
        ($0.ApproveResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PromoteCanonicalRequest,
            $0.PromoteCanonicalResponse>(
        'PromoteCanonical',
        promoteCanonical_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PromoteCanonicalRequest.fromBuffer(value),
        ($0.PromoteCanonicalResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UploadRequest, $0.UploadResponse>(
        'Upload',
        upload_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UploadRequest.fromBuffer(value),
        ($0.UploadResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GenerateResponse> generate_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GenerateRequest> $request) async {
    return generate($call, await $request);
  }

  $async.Future<$0.GenerateResponse> generate(
      $grpc.ServiceCall call, $0.GenerateRequest request);

  $async.Future<$0.GetStatusResponse> getStatus_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetStatusRequest> $request) async {
    return getStatus($call, await $request);
  }

  $async.Future<$0.GetStatusResponse> getStatus(
      $grpc.ServiceCall call, $0.GetStatusRequest request);

  $async.Future<$0.ListResponse> list_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ListResponse> list(
      $grpc.ServiceCall call, $0.ListRequest request);

  $async.Future<$0.GetResponse> get_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.GetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.GetResponse> get(
      $grpc.ServiceCall call, $0.GetRequest request);

  $async.Future<$0.ApproveResponse> approve_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ApproveRequest> $request) async {
    return approve($call, await $request);
  }

  $async.Future<$0.ApproveResponse> approve(
      $grpc.ServiceCall call, $0.ApproveRequest request);

  $async.Future<$0.PromoteCanonicalResponse> promoteCanonical_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PromoteCanonicalRequest> $request) async {
    return promoteCanonical($call, await $request);
  }

  $async.Future<$0.PromoteCanonicalResponse> promoteCanonical(
      $grpc.ServiceCall call, $0.PromoteCanonicalRequest request);

  $async.Future<$0.UploadResponse> upload_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.UploadRequest> $request) async {
    return upload($call, await $request);
  }

  $async.Future<$0.UploadResponse> upload(
      $grpc.ServiceCall call, $0.UploadRequest request);
}

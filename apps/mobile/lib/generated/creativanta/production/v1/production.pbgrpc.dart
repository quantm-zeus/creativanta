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

  /// EvaluateDrift evaluates asset drift against canonical references and blocks high drift (QA).
  $grpc.ResponseFuture<$0.EvaluateDriftResponse> evaluateDrift(
    $0.EvaluateDriftRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$evaluateDrift, request, options: options);
  }

  /// OverrideDriftViolation resolves a blocking drift violation with manager justification.
  $grpc.ResponseFuture<$0.OverrideDriftViolationResponse>
      overrideDriftViolation(
    $0.OverrideDriftViolationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$overrideDriftViolation, request,
        options: options);
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
  static final _$evaluateDrift =
      $grpc.ClientMethod<$0.EvaluateDriftRequest, $0.EvaluateDriftResponse>(
          '/creativanta.production.v1.AssetService/EvaluateDrift',
          ($0.EvaluateDriftRequest value) => value.writeToBuffer(),
          $0.EvaluateDriftResponse.fromBuffer);
  static final _$overrideDriftViolation = $grpc.ClientMethod<
          $0.OverrideDriftViolationRequest, $0.OverrideDriftViolationResponse>(
      '/creativanta.production.v1.AssetService/OverrideDriftViolation',
      ($0.OverrideDriftViolationRequest value) => value.writeToBuffer(),
      $0.OverrideDriftViolationResponse.fromBuffer);
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
    $addMethod(
        $grpc.ServiceMethod<$0.EvaluateDriftRequest, $0.EvaluateDriftResponse>(
            'EvaluateDrift',
            evaluateDrift_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.EvaluateDriftRequest.fromBuffer(value),
            ($0.EvaluateDriftResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OverrideDriftViolationRequest,
            $0.OverrideDriftViolationResponse>(
        'OverrideDriftViolation',
        overrideDriftViolation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.OverrideDriftViolationRequest.fromBuffer(value),
        ($0.OverrideDriftViolationResponse value) => value.writeToBuffer()));
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

  $async.Future<$0.EvaluateDriftResponse> evaluateDrift_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EvaluateDriftRequest> $request) async {
    return evaluateDrift($call, await $request);
  }

  $async.Future<$0.EvaluateDriftResponse> evaluateDrift(
      $grpc.ServiceCall call, $0.EvaluateDriftRequest request);

  $async.Future<$0.OverrideDriftViolationResponse> overrideDriftViolation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OverrideDriftViolationRequest> $request) async {
    return overrideDriftViolation($call, await $request);
  }

  $async.Future<$0.OverrideDriftViolationResponse> overrideDriftViolation(
      $grpc.ServiceCall call, $0.OverrideDriftViolationRequest request);
}

/// QuickEditService manages Quick Edit drafts and text-based timeline editing.
@$pb.GrpcServiceName('creativanta.production.v1.QuickEditService')
class QuickEditServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  QuickEditServiceClient(super.channel, {super.options, super.interceptors});

  /// SaveDraft persists an in-progress quick edit draft.
  $grpc.ResponseFuture<$0.QuickEditServiceSaveDraftResponse> saveDraft(
    $0.QuickEditServiceSaveDraftRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$saveDraft, request, options: options);
  }

  // method descriptors

  static final _$saveDraft = $grpc.ClientMethod<
          $0.QuickEditServiceSaveDraftRequest,
          $0.QuickEditServiceSaveDraftResponse>(
      '/creativanta.production.v1.QuickEditService/SaveDraft',
      ($0.QuickEditServiceSaveDraftRequest value) => value.writeToBuffer(),
      $0.QuickEditServiceSaveDraftResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.QuickEditService')
abstract class QuickEditServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.QuickEditService';

  QuickEditServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.QuickEditServiceSaveDraftRequest,
            $0.QuickEditServiceSaveDraftResponse>(
        'SaveDraft',
        saveDraft_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QuickEditServiceSaveDraftRequest.fromBuffer(value),
        ($0.QuickEditServiceSaveDraftResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.QuickEditServiceSaveDraftResponse> saveDraft_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.QuickEditServiceSaveDraftRequest> $request) async {
    return saveDraft($call, await $request);
  }

  $async.Future<$0.QuickEditServiceSaveDraftResponse> saveDraft(
      $grpc.ServiceCall call, $0.QuickEditServiceSaveDraftRequest request);
}

/// TranslationService manages AI video translation, lip-sync, cultural adaptation and localization (M07 EF-05).
@$pb.GrpcServiceName('creativanta.production.v1.TranslationService')
class TranslationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TranslationServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.TranslationServiceCreateResponse> create(
    $0.TranslationServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.TranslationServiceGetResponse> get(
    $0.TranslationServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.TranslationServiceListResponse> list(
    $0.TranslationServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.TranslationServiceCreateRequest,
          $0.TranslationServiceCreateResponse>(
      '/creativanta.production.v1.TranslationService/Create',
      ($0.TranslationServiceCreateRequest value) => value.writeToBuffer(),
      $0.TranslationServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.TranslationServiceGetRequest,
          $0.TranslationServiceGetResponse>(
      '/creativanta.production.v1.TranslationService/Get',
      ($0.TranslationServiceGetRequest value) => value.writeToBuffer(),
      $0.TranslationServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.TranslationServiceListRequest,
          $0.TranslationServiceListResponse>(
      '/creativanta.production.v1.TranslationService/List',
      ($0.TranslationServiceListRequest value) => value.writeToBuffer(),
      $0.TranslationServiceListResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.TranslationService')
abstract class TranslationServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.TranslationService';

  TranslationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TranslationServiceCreateRequest,
            $0.TranslationServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TranslationServiceCreateRequest.fromBuffer(value),
        ($0.TranslationServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TranslationServiceGetRequest,
            $0.TranslationServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TranslationServiceGetRequest.fromBuffer(value),
        ($0.TranslationServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TranslationServiceListRequest,
            $0.TranslationServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TranslationServiceListRequest.fromBuffer(value),
        ($0.TranslationServiceListResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.TranslationServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TranslationServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.TranslationServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.TranslationServiceCreateRequest request);

  $async.Future<$0.TranslationServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TranslationServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.TranslationServiceGetResponse> get(
      $grpc.ServiceCall call, $0.TranslationServiceGetRequest request);

  $async.Future<$0.TranslationServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TranslationServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.TranslationServiceListResponse> list(
      $grpc.ServiceCall call, $0.TranslationServiceListRequest request);
}

/// SoundStudioService manages background music generation, beat synchronization, SFX, and sound library (M07 EF-06).
@$pb.GrpcServiceName('creativanta.production.v1.SoundStudioService')
class SoundStudioServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SoundStudioServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SoundStudioServiceGenerateMusicResponse>
      generateMusic(
    $0.SoundStudioServiceGenerateMusicRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateMusic, request, options: options);
  }

  $grpc.ResponseFuture<$0.SoundStudioServiceGenerateSFXResponse> generateSFX(
    $0.SoundStudioServiceGenerateSFXRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateSFX, request, options: options);
  }

  $grpc.ResponseFuture<$0.SoundStudioServiceAnalyzeBeatResponse> analyzeBeat(
    $0.SoundStudioServiceAnalyzeBeatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$analyzeBeat, request, options: options);
  }

  $grpc.ResponseFuture<$0.SoundStudioServiceListSoundLibraryResponse>
      listSoundLibrary(
    $0.SoundStudioServiceListSoundLibraryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listSoundLibrary, request, options: options);
  }

  $grpc.ResponseFuture<$0.SoundStudioServiceGetSoundResponse> getSound(
    $0.SoundStudioServiceGetSoundRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSound, request, options: options);
  }

  $grpc.ResponseFuture<$0.SoundStudioServicePreviewSoundResponse> previewSound(
    $0.SoundStudioServicePreviewSoundRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$previewSound, request, options: options);
  }

  // method descriptors

  static final _$generateMusic = $grpc.ClientMethod<
          $0.SoundStudioServiceGenerateMusicRequest,
          $0.SoundStudioServiceGenerateMusicResponse>(
      '/creativanta.production.v1.SoundStudioService/GenerateMusic',
      ($0.SoundStudioServiceGenerateMusicRequest value) =>
          value.writeToBuffer(),
      $0.SoundStudioServiceGenerateMusicResponse.fromBuffer);
  static final _$generateSFX = $grpc.ClientMethod<
          $0.SoundStudioServiceGenerateSFXRequest,
          $0.SoundStudioServiceGenerateSFXResponse>(
      '/creativanta.production.v1.SoundStudioService/GenerateSFX',
      ($0.SoundStudioServiceGenerateSFXRequest value) => value.writeToBuffer(),
      $0.SoundStudioServiceGenerateSFXResponse.fromBuffer);
  static final _$analyzeBeat = $grpc.ClientMethod<
          $0.SoundStudioServiceAnalyzeBeatRequest,
          $0.SoundStudioServiceAnalyzeBeatResponse>(
      '/creativanta.production.v1.SoundStudioService/AnalyzeBeat',
      ($0.SoundStudioServiceAnalyzeBeatRequest value) => value.writeToBuffer(),
      $0.SoundStudioServiceAnalyzeBeatResponse.fromBuffer);
  static final _$listSoundLibrary = $grpc.ClientMethod<
          $0.SoundStudioServiceListSoundLibraryRequest,
          $0.SoundStudioServiceListSoundLibraryResponse>(
      '/creativanta.production.v1.SoundStudioService/ListSoundLibrary',
      ($0.SoundStudioServiceListSoundLibraryRequest value) =>
          value.writeToBuffer(),
      $0.SoundStudioServiceListSoundLibraryResponse.fromBuffer);
  static final _$getSound = $grpc.ClientMethod<
          $0.SoundStudioServiceGetSoundRequest,
          $0.SoundStudioServiceGetSoundResponse>(
      '/creativanta.production.v1.SoundStudioService/GetSound',
      ($0.SoundStudioServiceGetSoundRequest value) => value.writeToBuffer(),
      $0.SoundStudioServiceGetSoundResponse.fromBuffer);
  static final _$previewSound = $grpc.ClientMethod<
          $0.SoundStudioServicePreviewSoundRequest,
          $0.SoundStudioServicePreviewSoundResponse>(
      '/creativanta.production.v1.SoundStudioService/PreviewSound',
      ($0.SoundStudioServicePreviewSoundRequest value) => value.writeToBuffer(),
      $0.SoundStudioServicePreviewSoundResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.SoundStudioService')
abstract class SoundStudioServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.SoundStudioService';

  SoundStudioServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SoundStudioServiceGenerateMusicRequest,
            $0.SoundStudioServiceGenerateMusicResponse>(
        'GenerateMusic',
        generateMusic_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SoundStudioServiceGenerateMusicRequest.fromBuffer(value),
        ($0.SoundStudioServiceGenerateMusicResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SoundStudioServiceGenerateSFXRequest,
            $0.SoundStudioServiceGenerateSFXResponse>(
        'GenerateSFX',
        generateSFX_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SoundStudioServiceGenerateSFXRequest.fromBuffer(value),
        ($0.SoundStudioServiceGenerateSFXResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SoundStudioServiceAnalyzeBeatRequest,
            $0.SoundStudioServiceAnalyzeBeatResponse>(
        'AnalyzeBeat',
        analyzeBeat_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SoundStudioServiceAnalyzeBeatRequest.fromBuffer(value),
        ($0.SoundStudioServiceAnalyzeBeatResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SoundStudioServiceListSoundLibraryRequest,
            $0.SoundStudioServiceListSoundLibraryResponse>(
        'ListSoundLibrary',
        listSoundLibrary_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SoundStudioServiceListSoundLibraryRequest.fromBuffer(value),
        ($0.SoundStudioServiceListSoundLibraryResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SoundStudioServiceGetSoundRequest,
            $0.SoundStudioServiceGetSoundResponse>(
        'GetSound',
        getSound_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SoundStudioServiceGetSoundRequest.fromBuffer(value),
        ($0.SoundStudioServiceGetSoundResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SoundStudioServicePreviewSoundRequest,
            $0.SoundStudioServicePreviewSoundResponse>(
        'PreviewSound',
        previewSound_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SoundStudioServicePreviewSoundRequest.fromBuffer(value),
        ($0.SoundStudioServicePreviewSoundResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.SoundStudioServiceGenerateMusicResponse> generateMusic_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SoundStudioServiceGenerateMusicRequest> $request) async {
    return generateMusic($call, await $request);
  }

  $async.Future<$0.SoundStudioServiceGenerateMusicResponse> generateMusic(
      $grpc.ServiceCall call,
      $0.SoundStudioServiceGenerateMusicRequest request);

  $async.Future<$0.SoundStudioServiceGenerateSFXResponse> generateSFX_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SoundStudioServiceGenerateSFXRequest> $request) async {
    return generateSFX($call, await $request);
  }

  $async.Future<$0.SoundStudioServiceGenerateSFXResponse> generateSFX(
      $grpc.ServiceCall call, $0.SoundStudioServiceGenerateSFXRequest request);

  $async.Future<$0.SoundStudioServiceAnalyzeBeatResponse> analyzeBeat_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SoundStudioServiceAnalyzeBeatRequest> $request) async {
    return analyzeBeat($call, await $request);
  }

  $async.Future<$0.SoundStudioServiceAnalyzeBeatResponse> analyzeBeat(
      $grpc.ServiceCall call, $0.SoundStudioServiceAnalyzeBeatRequest request);

  $async.Future<$0.SoundStudioServiceListSoundLibraryResponse>
      listSoundLibrary_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.SoundStudioServiceListSoundLibraryRequest>
              $request) async {
    return listSoundLibrary($call, await $request);
  }

  $async.Future<$0.SoundStudioServiceListSoundLibraryResponse> listSoundLibrary(
      $grpc.ServiceCall call,
      $0.SoundStudioServiceListSoundLibraryRequest request);

  $async.Future<$0.SoundStudioServiceGetSoundResponse> getSound_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SoundStudioServiceGetSoundRequest> $request) async {
    return getSound($call, await $request);
  }

  $async.Future<$0.SoundStudioServiceGetSoundResponse> getSound(
      $grpc.ServiceCall call, $0.SoundStudioServiceGetSoundRequest request);

  $async.Future<$0.SoundStudioServicePreviewSoundResponse> previewSound_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SoundStudioServicePreviewSoundRequest> $request) async {
    return previewSound($call, await $request);
  }

  $async.Future<$0.SoundStudioServicePreviewSoundResponse> previewSound(
      $grpc.ServiceCall call, $0.SoundStudioServicePreviewSoundRequest request);
}

/// VoiceCloneService manages digital voice cloning, consent gating, voiceover synthesis and revocation (M08).
@$pb.GrpcServiceName('creativanta.production.v1.VoiceCloneService')
class VoiceCloneServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  VoiceCloneServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.VoiceCloneServiceCreateResponse> create(
    $0.VoiceCloneServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoiceCloneServiceGetResponse> get(
    $0.VoiceCloneServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoiceCloneServiceListResponse> list(
    $0.VoiceCloneServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoiceCloneServiceDeleteResponse> delete(
    $0.VoiceCloneServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoiceCloneServiceGenerateVoiceoverResponse>
      generateVoiceover(
    $0.VoiceCloneServiceGenerateVoiceoverRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateVoiceover, request, options: options);
  }

  $grpc.ResponseFuture<$0.VoiceCloneServiceGetConsentStatusResponse>
      getConsentStatus(
    $0.VoiceCloneServiceGetConsentStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getConsentStatus, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<$0.VoiceCloneServiceCreateRequest,
          $0.VoiceCloneServiceCreateResponse>(
      '/creativanta.production.v1.VoiceCloneService/Create',
      ($0.VoiceCloneServiceCreateRequest value) => value.writeToBuffer(),
      $0.VoiceCloneServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.VoiceCloneServiceGetRequest,
          $0.VoiceCloneServiceGetResponse>(
      '/creativanta.production.v1.VoiceCloneService/Get',
      ($0.VoiceCloneServiceGetRequest value) => value.writeToBuffer(),
      $0.VoiceCloneServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.VoiceCloneServiceListRequest,
          $0.VoiceCloneServiceListResponse>(
      '/creativanta.production.v1.VoiceCloneService/List',
      ($0.VoiceCloneServiceListRequest value) => value.writeToBuffer(),
      $0.VoiceCloneServiceListResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.VoiceCloneServiceDeleteRequest,
          $0.VoiceCloneServiceDeleteResponse>(
      '/creativanta.production.v1.VoiceCloneService/Delete',
      ($0.VoiceCloneServiceDeleteRequest value) => value.writeToBuffer(),
      $0.VoiceCloneServiceDeleteResponse.fromBuffer);
  static final _$generateVoiceover = $grpc.ClientMethod<
          $0.VoiceCloneServiceGenerateVoiceoverRequest,
          $0.VoiceCloneServiceGenerateVoiceoverResponse>(
      '/creativanta.production.v1.VoiceCloneService/GenerateVoiceover',
      ($0.VoiceCloneServiceGenerateVoiceoverRequest value) =>
          value.writeToBuffer(),
      $0.VoiceCloneServiceGenerateVoiceoverResponse.fromBuffer);
  static final _$getConsentStatus = $grpc.ClientMethod<
          $0.VoiceCloneServiceGetConsentStatusRequest,
          $0.VoiceCloneServiceGetConsentStatusResponse>(
      '/creativanta.production.v1.VoiceCloneService/GetConsentStatus',
      ($0.VoiceCloneServiceGetConsentStatusRequest value) =>
          value.writeToBuffer(),
      $0.VoiceCloneServiceGetConsentStatusResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.VoiceCloneService')
abstract class VoiceCloneServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.VoiceCloneService';

  VoiceCloneServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.VoiceCloneServiceCreateRequest,
            $0.VoiceCloneServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VoiceCloneServiceCreateRequest.fromBuffer(value),
        ($0.VoiceCloneServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VoiceCloneServiceGetRequest,
            $0.VoiceCloneServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VoiceCloneServiceGetRequest.fromBuffer(value),
        ($0.VoiceCloneServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VoiceCloneServiceListRequest,
            $0.VoiceCloneServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VoiceCloneServiceListRequest.fromBuffer(value),
        ($0.VoiceCloneServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VoiceCloneServiceDeleteRequest,
            $0.VoiceCloneServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VoiceCloneServiceDeleteRequest.fromBuffer(value),
        ($0.VoiceCloneServiceDeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VoiceCloneServiceGenerateVoiceoverRequest,
            $0.VoiceCloneServiceGenerateVoiceoverResponse>(
        'GenerateVoiceover',
        generateVoiceover_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VoiceCloneServiceGenerateVoiceoverRequest.fromBuffer(value),
        ($0.VoiceCloneServiceGenerateVoiceoverResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VoiceCloneServiceGetConsentStatusRequest,
            $0.VoiceCloneServiceGetConsentStatusResponse>(
        'GetConsentStatus',
        getConsentStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VoiceCloneServiceGetConsentStatusRequest.fromBuffer(value),
        ($0.VoiceCloneServiceGetConsentStatusResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.VoiceCloneServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VoiceCloneServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.VoiceCloneServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.VoiceCloneServiceCreateRequest request);

  $async.Future<$0.VoiceCloneServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VoiceCloneServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.VoiceCloneServiceGetResponse> get(
      $grpc.ServiceCall call, $0.VoiceCloneServiceGetRequest request);

  $async.Future<$0.VoiceCloneServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VoiceCloneServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.VoiceCloneServiceListResponse> list(
      $grpc.ServiceCall call, $0.VoiceCloneServiceListRequest request);

  $async.Future<$0.VoiceCloneServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VoiceCloneServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.VoiceCloneServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.VoiceCloneServiceDeleteRequest request);

  $async.Future<$0.VoiceCloneServiceGenerateVoiceoverResponse>
      generateVoiceover_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.VoiceCloneServiceGenerateVoiceoverRequest>
              $request) async {
    return generateVoiceover($call, await $request);
  }

  $async.Future<$0.VoiceCloneServiceGenerateVoiceoverResponse>
      generateVoiceover($grpc.ServiceCall call,
          $0.VoiceCloneServiceGenerateVoiceoverRequest request);

  $async.Future<$0.VoiceCloneServiceGetConsentStatusResponse>
      getConsentStatus_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.VoiceCloneServiceGetConsentStatusRequest>
              $request) async {
    return getConsentStatus($call, await $request);
  }

  $async.Future<$0.VoiceCloneServiceGetConsentStatusResponse> getConsentStatus(
      $grpc.ServiceCall call,
      $0.VoiceCloneServiceGetConsentStatusRequest request);
}

/// RemixService implements Phase 1-3 AI Remix Studio pipeline (api_endpoint_map.md §7.2).
@$pb.GrpcServiceName('creativanta.production.v1.RemixService')
class RemixServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RemixServiceClient(super.channel, {super.options, super.interceptors});

  /// Analyze extracts Creative DNA from reference video (Phase 1).
  $grpc.ResponseFuture<$0.RemixServiceAnalyzeResponse> analyze(
    $0.RemixServiceAnalyzeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$analyze, request, options: options);
  }

  /// GetBlueprint retrieves Creative DNA blueprint and editable script.
  $grpc.ResponseFuture<$0.RemixServiceGetBlueprintResponse> getBlueprint(
    $0.RemixServiceGetBlueprintRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBlueprint, request, options: options);
  }

  /// Generate recreates original remix with strict originality check (<30% similarity).
  $grpc.ResponseFuture<$0.RemixServiceGenerateResponse> generate(
    $0.RemixServiceGenerateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generate, request, options: options);
  }

  /// Regenerate adjusts an individual scene or regenerated output.
  $grpc.ResponseFuture<$0.RemixServiceRegenerateResponse> regenerate(
    $0.RemixServiceRegenerateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$regenerate, request, options: options);
  }

  // method descriptors

  static final _$analyze = $grpc.ClientMethod<$0.RemixServiceAnalyzeRequest,
          $0.RemixServiceAnalyzeResponse>(
      '/creativanta.production.v1.RemixService/Analyze',
      ($0.RemixServiceAnalyzeRequest value) => value.writeToBuffer(),
      $0.RemixServiceAnalyzeResponse.fromBuffer);
  static final _$getBlueprint = $grpc.ClientMethod<
          $0.RemixServiceGetBlueprintRequest,
          $0.RemixServiceGetBlueprintResponse>(
      '/creativanta.production.v1.RemixService/GetBlueprint',
      ($0.RemixServiceGetBlueprintRequest value) => value.writeToBuffer(),
      $0.RemixServiceGetBlueprintResponse.fromBuffer);
  static final _$generate = $grpc.ClientMethod<$0.RemixServiceGenerateRequest,
          $0.RemixServiceGenerateResponse>(
      '/creativanta.production.v1.RemixService/Generate',
      ($0.RemixServiceGenerateRequest value) => value.writeToBuffer(),
      $0.RemixServiceGenerateResponse.fromBuffer);
  static final _$regenerate = $grpc.ClientMethod<
          $0.RemixServiceRegenerateRequest, $0.RemixServiceRegenerateResponse>(
      '/creativanta.production.v1.RemixService/Regenerate',
      ($0.RemixServiceRegenerateRequest value) => value.writeToBuffer(),
      $0.RemixServiceRegenerateResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.RemixService')
abstract class RemixServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.RemixService';

  RemixServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RemixServiceAnalyzeRequest,
            $0.RemixServiceAnalyzeResponse>(
        'Analyze',
        analyze_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemixServiceAnalyzeRequest.fromBuffer(value),
        ($0.RemixServiceAnalyzeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemixServiceGetBlueprintRequest,
            $0.RemixServiceGetBlueprintResponse>(
        'GetBlueprint',
        getBlueprint_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemixServiceGetBlueprintRequest.fromBuffer(value),
        ($0.RemixServiceGetBlueprintResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemixServiceGenerateRequest,
            $0.RemixServiceGenerateResponse>(
        'Generate',
        generate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemixServiceGenerateRequest.fromBuffer(value),
        ($0.RemixServiceGenerateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemixServiceRegenerateRequest,
            $0.RemixServiceRegenerateResponse>(
        'Regenerate',
        regenerate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RemixServiceRegenerateRequest.fromBuffer(value),
        ($0.RemixServiceRegenerateResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RemixServiceAnalyzeResponse> analyze_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemixServiceAnalyzeRequest> $request) async {
    return analyze($call, await $request);
  }

  $async.Future<$0.RemixServiceAnalyzeResponse> analyze(
      $grpc.ServiceCall call, $0.RemixServiceAnalyzeRequest request);

  $async.Future<$0.RemixServiceGetBlueprintResponse> getBlueprint_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemixServiceGetBlueprintRequest> $request) async {
    return getBlueprint($call, await $request);
  }

  $async.Future<$0.RemixServiceGetBlueprintResponse> getBlueprint(
      $grpc.ServiceCall call, $0.RemixServiceGetBlueprintRequest request);

  $async.Future<$0.RemixServiceGenerateResponse> generate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemixServiceGenerateRequest> $request) async {
    return generate($call, await $request);
  }

  $async.Future<$0.RemixServiceGenerateResponse> generate(
      $grpc.ServiceCall call, $0.RemixServiceGenerateRequest request);

  $async.Future<$0.RemixServiceRegenerateResponse> regenerate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RemixServiceRegenerateRequest> $request) async {
    return regenerate($call, await $request);
  }

  $async.Future<$0.RemixServiceRegenerateResponse> regenerate(
      $grpc.ServiceCall call, $0.RemixServiceRegenerateRequest request);
}

/// VideoEditJobService manages production editing jobs including Multi-Merge (api_endpoint_map.md §7.1).
@$pb.GrpcServiceName('creativanta.production.v1.VideoEditJobService')
class VideoEditJobServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  VideoEditJobServiceClient(super.channel, {super.options, super.interceptors});

  /// Create starts a new production job (e.g. multi_merge, quick_edit).
  $grpc.ResponseFuture<$0.VideoEditJobServiceCreateResponse> create(
    $0.VideoEditJobServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  /// Get retrieves job status and metadata.
  $grpc.ResponseFuture<$0.VideoEditJobServiceGetResponse> get(
    $0.VideoEditJobServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  /// List returns filtered production jobs for a workspace.
  $grpc.ResponseFuture<$0.VideoEditJobServiceListResponse> list(
    $0.VideoEditJobServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  /// Cancel cancels an in-flight video edit job and refunds unspent credits.
  $grpc.ResponseFuture<$0.VideoEditJobServiceCancelResponse> cancel(
    $0.VideoEditJobServiceCancelRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancel, request, options: options);
  }

  /// Retry retries a failed video edit job.
  $grpc.ResponseFuture<$0.VideoEditJobServiceRetryResponse> retry(
    $0.VideoEditJobServiceRetryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$retry, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<
          $0.VideoEditJobServiceCreateRequest,
          $0.VideoEditJobServiceCreateResponse>(
      '/creativanta.production.v1.VideoEditJobService/Create',
      ($0.VideoEditJobServiceCreateRequest value) => value.writeToBuffer(),
      $0.VideoEditJobServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.VideoEditJobServiceGetRequest,
          $0.VideoEditJobServiceGetResponse>(
      '/creativanta.production.v1.VideoEditJobService/Get',
      ($0.VideoEditJobServiceGetRequest value) => value.writeToBuffer(),
      $0.VideoEditJobServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.VideoEditJobServiceListRequest,
          $0.VideoEditJobServiceListResponse>(
      '/creativanta.production.v1.VideoEditJobService/List',
      ($0.VideoEditJobServiceListRequest value) => value.writeToBuffer(),
      $0.VideoEditJobServiceListResponse.fromBuffer);
  static final _$cancel = $grpc.ClientMethod<
          $0.VideoEditJobServiceCancelRequest,
          $0.VideoEditJobServiceCancelResponse>(
      '/creativanta.production.v1.VideoEditJobService/Cancel',
      ($0.VideoEditJobServiceCancelRequest value) => value.writeToBuffer(),
      $0.VideoEditJobServiceCancelResponse.fromBuffer);
  static final _$retry = $grpc.ClientMethod<$0.VideoEditJobServiceRetryRequest,
          $0.VideoEditJobServiceRetryResponse>(
      '/creativanta.production.v1.VideoEditJobService/Retry',
      ($0.VideoEditJobServiceRetryRequest value) => value.writeToBuffer(),
      $0.VideoEditJobServiceRetryResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.VideoEditJobService')
abstract class VideoEditJobServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.VideoEditJobService';

  VideoEditJobServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.VideoEditJobServiceCreateRequest,
            $0.VideoEditJobServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VideoEditJobServiceCreateRequest.fromBuffer(value),
        ($0.VideoEditJobServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VideoEditJobServiceGetRequest,
            $0.VideoEditJobServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VideoEditJobServiceGetRequest.fromBuffer(value),
        ($0.VideoEditJobServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VideoEditJobServiceListRequest,
            $0.VideoEditJobServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VideoEditJobServiceListRequest.fromBuffer(value),
        ($0.VideoEditJobServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VideoEditJobServiceCancelRequest,
            $0.VideoEditJobServiceCancelResponse>(
        'Cancel',
        cancel_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VideoEditJobServiceCancelRequest.fromBuffer(value),
        ($0.VideoEditJobServiceCancelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VideoEditJobServiceRetryRequest,
            $0.VideoEditJobServiceRetryResponse>(
        'Retry',
        retry_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VideoEditJobServiceRetryRequest.fromBuffer(value),
        ($0.VideoEditJobServiceRetryResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.VideoEditJobServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VideoEditJobServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.VideoEditJobServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.VideoEditJobServiceCreateRequest request);

  $async.Future<$0.VideoEditJobServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VideoEditJobServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.VideoEditJobServiceGetResponse> get(
      $grpc.ServiceCall call, $0.VideoEditJobServiceGetRequest request);

  $async.Future<$0.VideoEditJobServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VideoEditJobServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.VideoEditJobServiceListResponse> list(
      $grpc.ServiceCall call, $0.VideoEditJobServiceListRequest request);

  $async.Future<$0.VideoEditJobServiceCancelResponse> cancel_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VideoEditJobServiceCancelRequest> $request) async {
    return cancel($call, await $request);
  }

  $async.Future<$0.VideoEditJobServiceCancelResponse> cancel(
      $grpc.ServiceCall call, $0.VideoEditJobServiceCancelRequest request);

  $async.Future<$0.VideoEditJobServiceRetryResponse> retry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VideoEditJobServiceRetryRequest> $request) async {
    return retry($call, await $request);
  }

  $async.Future<$0.VideoEditJobServiceRetryResponse> retry(
      $grpc.ServiceCall call, $0.VideoEditJobServiceRetryRequest request);
}

/// ClipFactoryService manages Mode 2: Clip Factory (1->N) AI Video Studio operations.
/// Canonical Source: docs/02_features/production/ai_video_studio.md §Mode 2
///                   docs/04_contracts/api_endpoint_map.md §7.3
///                   docs/04_contracts/rpc_permission_bindings.csv (rows 308-310)
@$pb.GrpcServiceName('creativanta.production.v1.ClipFactoryService')
class ClipFactoryServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ClipFactoryServiceClient(super.channel, {super.options, super.interceptors});

  /// Analyze scans long video via scene/beat/ASR detection and proposes scored clips.
  /// RBAC: Editor+ (production_job:manage).
  $grpc.ResponseFuture<$0.ClipFactoryServiceAnalyzeResponse> analyze(
    $0.ClipFactoryServiceAnalyzeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$analyze, request, options: options);
  }

  /// GetCollection retrieves clip boundary proposals and virality scores.
  /// RBAC: Editor+ (production_job:read).
  $grpc.ResponseFuture<$0.ClipFactoryServiceGetCollectionResponse>
      getCollection(
    $0.ClipFactoryServiceGetCollectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCollection, request, options: options);
  }

  /// ProcessClips processes selected clips into platform variants and exports.
  /// RBAC: Editor+ (production_job:manage).
  $grpc.ResponseFuture<$0.ClipFactoryServiceProcessClipsResponse> processClips(
    $0.ClipFactoryServiceProcessClipsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$processClips, request, options: options);
  }

  // method descriptors

  static final _$analyze = $grpc.ClientMethod<
          $0.ClipFactoryServiceAnalyzeRequest,
          $0.ClipFactoryServiceAnalyzeResponse>(
      '/creativanta.production.v1.ClipFactoryService/Analyze',
      ($0.ClipFactoryServiceAnalyzeRequest value) => value.writeToBuffer(),
      $0.ClipFactoryServiceAnalyzeResponse.fromBuffer);
  static final _$getCollection = $grpc.ClientMethod<
          $0.ClipFactoryServiceGetCollectionRequest,
          $0.ClipFactoryServiceGetCollectionResponse>(
      '/creativanta.production.v1.ClipFactoryService/GetCollection',
      ($0.ClipFactoryServiceGetCollectionRequest value) =>
          value.writeToBuffer(),
      $0.ClipFactoryServiceGetCollectionResponse.fromBuffer);
  static final _$processClips = $grpc.ClientMethod<
          $0.ClipFactoryServiceProcessClipsRequest,
          $0.ClipFactoryServiceProcessClipsResponse>(
      '/creativanta.production.v1.ClipFactoryService/ProcessClips',
      ($0.ClipFactoryServiceProcessClipsRequest value) => value.writeToBuffer(),
      $0.ClipFactoryServiceProcessClipsResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.ClipFactoryService')
abstract class ClipFactoryServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.ClipFactoryService';

  ClipFactoryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ClipFactoryServiceAnalyzeRequest,
            $0.ClipFactoryServiceAnalyzeResponse>(
        'Analyze',
        analyze_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ClipFactoryServiceAnalyzeRequest.fromBuffer(value),
        ($0.ClipFactoryServiceAnalyzeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClipFactoryServiceGetCollectionRequest,
            $0.ClipFactoryServiceGetCollectionResponse>(
        'GetCollection',
        getCollection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ClipFactoryServiceGetCollectionRequest.fromBuffer(value),
        ($0.ClipFactoryServiceGetCollectionResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClipFactoryServiceProcessClipsRequest,
            $0.ClipFactoryServiceProcessClipsResponse>(
        'ProcessClips',
        processClips_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ClipFactoryServiceProcessClipsRequest.fromBuffer(value),
        ($0.ClipFactoryServiceProcessClipsResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ClipFactoryServiceAnalyzeResponse> analyze_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClipFactoryServiceAnalyzeRequest> $request) async {
    return analyze($call, await $request);
  }

  $async.Future<$0.ClipFactoryServiceAnalyzeResponse> analyze(
      $grpc.ServiceCall call, $0.ClipFactoryServiceAnalyzeRequest request);

  $async.Future<$0.ClipFactoryServiceGetCollectionResponse> getCollection_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClipFactoryServiceGetCollectionRequest> $request) async {
    return getCollection($call, await $request);
  }

  $async.Future<$0.ClipFactoryServiceGetCollectionResponse> getCollection(
      $grpc.ServiceCall call,
      $0.ClipFactoryServiceGetCollectionRequest request);

  $async.Future<$0.ClipFactoryServiceProcessClipsResponse> processClips_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClipFactoryServiceProcessClipsRequest> $request) async {
    return processClips($call, await $request);
  }

  $async.Future<$0.ClipFactoryServiceProcessClipsResponse> processClips(
      $grpc.ServiceCall call, $0.ClipFactoryServiceProcessClipsRequest request);
}

/// StylePackService manages learned editing styles (api_endpoint_map.md §7.7).
@$pb.GrpcServiceName('creativanta.production.v1.StylePackService')
class StylePackServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  StylePackServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.StylePackServiceExtractResponse> extract(
    $0.StylePackServiceExtractRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$extract, request, options: options);
  }

  $grpc.ResponseFuture<$0.StylePackServiceCreateResponse> create(
    $0.StylePackServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.StylePackServiceGetResponse> get(
    $0.StylePackServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.StylePackServiceListResponse> list(
    $0.StylePackServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.StylePackServiceApplyResponse> apply(
    $0.StylePackServiceApplyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$apply, request, options: options);
  }

  $grpc.ResponseFuture<$0.StylePackServiceDeleteResponse> delete(
    $0.StylePackServiceDeleteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  // method descriptors

  static final _$extract = $grpc.ClientMethod<$0.StylePackServiceExtractRequest,
          $0.StylePackServiceExtractResponse>(
      '/creativanta.production.v1.StylePackService/Extract',
      ($0.StylePackServiceExtractRequest value) => value.writeToBuffer(),
      $0.StylePackServiceExtractResponse.fromBuffer);
  static final _$create = $grpc.ClientMethod<$0.StylePackServiceCreateRequest,
          $0.StylePackServiceCreateResponse>(
      '/creativanta.production.v1.StylePackService/Create',
      ($0.StylePackServiceCreateRequest value) => value.writeToBuffer(),
      $0.StylePackServiceCreateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.StylePackServiceGetRequest,
          $0.StylePackServiceGetResponse>(
      '/creativanta.production.v1.StylePackService/Get',
      ($0.StylePackServiceGetRequest value) => value.writeToBuffer(),
      $0.StylePackServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.StylePackServiceListRequest,
          $0.StylePackServiceListResponse>(
      '/creativanta.production.v1.StylePackService/List',
      ($0.StylePackServiceListRequest value) => value.writeToBuffer(),
      $0.StylePackServiceListResponse.fromBuffer);
  static final _$apply = $grpc.ClientMethod<$0.StylePackServiceApplyRequest,
          $0.StylePackServiceApplyResponse>(
      '/creativanta.production.v1.StylePackService/Apply',
      ($0.StylePackServiceApplyRequest value) => value.writeToBuffer(),
      $0.StylePackServiceApplyResponse.fromBuffer);
  static final _$delete = $grpc.ClientMethod<$0.StylePackServiceDeleteRequest,
          $0.StylePackServiceDeleteResponse>(
      '/creativanta.production.v1.StylePackService/Delete',
      ($0.StylePackServiceDeleteRequest value) => value.writeToBuffer(),
      $0.StylePackServiceDeleteResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.StylePackService')
abstract class StylePackServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.StylePackService';

  StylePackServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.StylePackServiceExtractRequest,
            $0.StylePackServiceExtractResponse>(
        'Extract',
        extract_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StylePackServiceExtractRequest.fromBuffer(value),
        ($0.StylePackServiceExtractResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StylePackServiceCreateRequest,
            $0.StylePackServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StylePackServiceCreateRequest.fromBuffer(value),
        ($0.StylePackServiceCreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StylePackServiceGetRequest,
            $0.StylePackServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StylePackServiceGetRequest.fromBuffer(value),
        ($0.StylePackServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StylePackServiceListRequest,
            $0.StylePackServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StylePackServiceListRequest.fromBuffer(value),
        ($0.StylePackServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StylePackServiceApplyRequest,
            $0.StylePackServiceApplyResponse>(
        'Apply',
        apply_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StylePackServiceApplyRequest.fromBuffer(value),
        ($0.StylePackServiceApplyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StylePackServiceDeleteRequest,
            $0.StylePackServiceDeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StylePackServiceDeleteRequest.fromBuffer(value),
        ($0.StylePackServiceDeleteResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.StylePackServiceExtractResponse> extract_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StylePackServiceExtractRequest> $request) async {
    return extract($call, await $request);
  }

  $async.Future<$0.StylePackServiceExtractResponse> extract(
      $grpc.ServiceCall call, $0.StylePackServiceExtractRequest request);

  $async.Future<$0.StylePackServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StylePackServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.StylePackServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.StylePackServiceCreateRequest request);

  $async.Future<$0.StylePackServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StylePackServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.StylePackServiceGetResponse> get(
      $grpc.ServiceCall call, $0.StylePackServiceGetRequest request);

  $async.Future<$0.StylePackServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StylePackServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.StylePackServiceListResponse> list(
      $grpc.ServiceCall call, $0.StylePackServiceListRequest request);

  $async.Future<$0.StylePackServiceApplyResponse> apply_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StylePackServiceApplyRequest> $request) async {
    return apply($call, await $request);
  }

  $async.Future<$0.StylePackServiceApplyResponse> apply(
      $grpc.ServiceCall call, $0.StylePackServiceApplyRequest request);

  $async.Future<$0.StylePackServiceDeleteResponse> delete_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StylePackServiceDeleteRequest> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$0.StylePackServiceDeleteResponse> delete(
      $grpc.ServiceCall call, $0.StylePackServiceDeleteRequest request);
}

/// AIService manages AI style analysis, preview generation, thumbnails and quoting (api_endpoint_map.md §13, §14, §15.1).
@$pb.GrpcServiceName('creativanta.production.v1.AIService')
class AIServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AIServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GenerateCharacterPreviewResponse>
      generateCharacterPreview(
    $0.GenerateCharacterPreviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateCharacterPreview, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.QuoteCharacterPreviewResponse> quoteCharacterPreview(
    $0.QuoteCharacterPreviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$quoteCharacterPreview, request, options: options);
  }

  $grpc.ResponseFuture<$0.AnalyzeStyleResponse> analyzeStyle(
    $0.AnalyzeStyleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$analyzeStyle, request, options: options);
  }

  $grpc.ResponseFuture<$0.GenerateThumbnailsResponse> generateThumbnails(
    $0.GenerateThumbnailsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generateThumbnails, request, options: options);
  }

  // method descriptors

  static final _$generateCharacterPreview = $grpc.ClientMethod<
          $0.GenerateCharacterPreviewRequest,
          $0.GenerateCharacterPreviewResponse>(
      '/creativanta.production.v1.AIService/GenerateCharacterPreview',
      ($0.GenerateCharacterPreviewRequest value) => value.writeToBuffer(),
      $0.GenerateCharacterPreviewResponse.fromBuffer);
  static final _$quoteCharacterPreview = $grpc.ClientMethod<
          $0.QuoteCharacterPreviewRequest, $0.QuoteCharacterPreviewResponse>(
      '/creativanta.production.v1.AIService/QuoteCharacterPreview',
      ($0.QuoteCharacterPreviewRequest value) => value.writeToBuffer(),
      $0.QuoteCharacterPreviewResponse.fromBuffer);
  static final _$analyzeStyle =
      $grpc.ClientMethod<$0.AnalyzeStyleRequest, $0.AnalyzeStyleResponse>(
          '/creativanta.production.v1.AIService/AnalyzeStyle',
          ($0.AnalyzeStyleRequest value) => value.writeToBuffer(),
          $0.AnalyzeStyleResponse.fromBuffer);
  static final _$generateThumbnails = $grpc.ClientMethod<
          $0.GenerateThumbnailsRequest, $0.GenerateThumbnailsResponse>(
      '/creativanta.production.v1.AIService/GenerateThumbnails',
      ($0.GenerateThumbnailsRequest value) => value.writeToBuffer(),
      $0.GenerateThumbnailsResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.AIService')
abstract class AIServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.AIService';

  AIServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GenerateCharacterPreviewRequest,
            $0.GenerateCharacterPreviewResponse>(
        'GenerateCharacterPreview',
        generateCharacterPreview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GenerateCharacterPreviewRequest.fromBuffer(value),
        ($0.GenerateCharacterPreviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QuoteCharacterPreviewRequest,
            $0.QuoteCharacterPreviewResponse>(
        'QuoteCharacterPreview',
        quoteCharacterPreview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QuoteCharacterPreviewRequest.fromBuffer(value),
        ($0.QuoteCharacterPreviewResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AnalyzeStyleRequest, $0.AnalyzeStyleResponse>(
            'AnalyzeStyle',
            analyzeStyle_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AnalyzeStyleRequest.fromBuffer(value),
            ($0.AnalyzeStyleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GenerateThumbnailsRequest,
            $0.GenerateThumbnailsResponse>(
        'GenerateThumbnails',
        generateThumbnails_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GenerateThumbnailsRequest.fromBuffer(value),
        ($0.GenerateThumbnailsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GenerateCharacterPreviewResponse>
      generateCharacterPreview_Pre($grpc.ServiceCall $call,
          $async.Future<$0.GenerateCharacterPreviewRequest> $request) async {
    return generateCharacterPreview($call, await $request);
  }

  $async.Future<$0.GenerateCharacterPreviewResponse> generateCharacterPreview(
      $grpc.ServiceCall call, $0.GenerateCharacterPreviewRequest request);

  $async.Future<$0.QuoteCharacterPreviewResponse> quoteCharacterPreview_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.QuoteCharacterPreviewRequest> $request) async {
    return quoteCharacterPreview($call, await $request);
  }

  $async.Future<$0.QuoteCharacterPreviewResponse> quoteCharacterPreview(
      $grpc.ServiceCall call, $0.QuoteCharacterPreviewRequest request);

  $async.Future<$0.AnalyzeStyleResponse> analyzeStyle_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AnalyzeStyleRequest> $request) async {
    return analyzeStyle($call, await $request);
  }

  $async.Future<$0.AnalyzeStyleResponse> analyzeStyle(
      $grpc.ServiceCall call, $0.AnalyzeStyleRequest request);

  $async.Future<$0.GenerateThumbnailsResponse> generateThumbnails_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GenerateThumbnailsRequest> $request) async {
    return generateThumbnails($call, await $request);
  }

  $async.Future<$0.GenerateThumbnailsResponse> generateThumbnails(
      $grpc.ServiceCall call, $0.GenerateThumbnailsRequest request);
}

/// ProductShowcaseService manages AI product showcase video generation (api_endpoint_map.md §7.4).
@$pb.GrpcServiceName('creativanta.production.v1.ProductShowcaseService')
class ProductShowcaseServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ProductShowcaseServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ProductShowcaseServiceCreateResponse> create(
    $0.ProductShowcaseServiceCreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProductShowcaseServiceCreateBatchResponse>
      createBatch(
    $0.ProductShowcaseServiceCreateBatchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createBatch, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProductShowcaseServiceGetResponse> get(
    $0.ProductShowcaseServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.ProductShowcaseServiceListResponse> list(
    $0.ProductShowcaseServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  // method descriptors

  static final _$create = $grpc.ClientMethod<
          $0.ProductShowcaseServiceCreateRequest,
          $0.ProductShowcaseServiceCreateResponse>(
      '/creativanta.production.v1.ProductShowcaseService/Create',
      ($0.ProductShowcaseServiceCreateRequest value) => value.writeToBuffer(),
      $0.ProductShowcaseServiceCreateResponse.fromBuffer);
  static final _$createBatch = $grpc.ClientMethod<
          $0.ProductShowcaseServiceCreateBatchRequest,
          $0.ProductShowcaseServiceCreateBatchResponse>(
      '/creativanta.production.v1.ProductShowcaseService/CreateBatch',
      ($0.ProductShowcaseServiceCreateBatchRequest value) =>
          value.writeToBuffer(),
      $0.ProductShowcaseServiceCreateBatchResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.ProductShowcaseServiceGetRequest,
          $0.ProductShowcaseServiceGetResponse>(
      '/creativanta.production.v1.ProductShowcaseService/Get',
      ($0.ProductShowcaseServiceGetRequest value) => value.writeToBuffer(),
      $0.ProductShowcaseServiceGetResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.ProductShowcaseServiceListRequest,
          $0.ProductShowcaseServiceListResponse>(
      '/creativanta.production.v1.ProductShowcaseService/List',
      ($0.ProductShowcaseServiceListRequest value) => value.writeToBuffer(),
      $0.ProductShowcaseServiceListResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.ProductShowcaseService')
abstract class ProductShowcaseServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.ProductShowcaseService';

  ProductShowcaseServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ProductShowcaseServiceCreateRequest,
            $0.ProductShowcaseServiceCreateResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProductShowcaseServiceCreateRequest.fromBuffer(value),
        ($0.ProductShowcaseServiceCreateResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProductShowcaseServiceCreateBatchRequest,
            $0.ProductShowcaseServiceCreateBatchResponse>(
        'CreateBatch',
        createBatch_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProductShowcaseServiceCreateBatchRequest.fromBuffer(value),
        ($0.ProductShowcaseServiceCreateBatchResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProductShowcaseServiceGetRequest,
            $0.ProductShowcaseServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProductShowcaseServiceGetRequest.fromBuffer(value),
        ($0.ProductShowcaseServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProductShowcaseServiceListRequest,
            $0.ProductShowcaseServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ProductShowcaseServiceListRequest.fromBuffer(value),
        ($0.ProductShowcaseServiceListResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ProductShowcaseServiceCreateResponse> create_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProductShowcaseServiceCreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$0.ProductShowcaseServiceCreateResponse> create(
      $grpc.ServiceCall call, $0.ProductShowcaseServiceCreateRequest request);

  $async.Future<$0.ProductShowcaseServiceCreateBatchResponse> createBatch_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProductShowcaseServiceCreateBatchRequest>
          $request) async {
    return createBatch($call, await $request);
  }

  $async.Future<$0.ProductShowcaseServiceCreateBatchResponse> createBatch(
      $grpc.ServiceCall call,
      $0.ProductShowcaseServiceCreateBatchRequest request);

  $async.Future<$0.ProductShowcaseServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProductShowcaseServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.ProductShowcaseServiceGetResponse> get(
      $grpc.ServiceCall call, $0.ProductShowcaseServiceGetRequest request);

  $async.Future<$0.ProductShowcaseServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ProductShowcaseServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ProductShowcaseServiceListResponse> list(
      $grpc.ServiceCall call, $0.ProductShowcaseServiceListRequest request);
}

/// LinkToVideoService manages scraping and video ad generation from product links (api_endpoint_map.md §7.5).
@$pb.GrpcServiceName('creativanta.production.v1.LinkToVideoService')
class LinkToVideoServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  LinkToVideoServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.LinkToVideoServiceScrapeResponse> scrape(
    $0.LinkToVideoServiceScrapeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$scrape, request, options: options);
  }

  $grpc.ResponseFuture<$0.LinkToVideoServiceGenerateResponse> generate(
    $0.LinkToVideoServiceGenerateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$generate, request, options: options);
  }

  $grpc.ResponseFuture<$0.LinkToVideoServiceGetResponse> get(
    $0.LinkToVideoServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  // method descriptors

  static final _$scrape = $grpc.ClientMethod<$0.LinkToVideoServiceScrapeRequest,
          $0.LinkToVideoServiceScrapeResponse>(
      '/creativanta.production.v1.LinkToVideoService/Scrape',
      ($0.LinkToVideoServiceScrapeRequest value) => value.writeToBuffer(),
      $0.LinkToVideoServiceScrapeResponse.fromBuffer);
  static final _$generate = $grpc.ClientMethod<
          $0.LinkToVideoServiceGenerateRequest,
          $0.LinkToVideoServiceGenerateResponse>(
      '/creativanta.production.v1.LinkToVideoService/Generate',
      ($0.LinkToVideoServiceGenerateRequest value) => value.writeToBuffer(),
      $0.LinkToVideoServiceGenerateResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.LinkToVideoServiceGetRequest,
          $0.LinkToVideoServiceGetResponse>(
      '/creativanta.production.v1.LinkToVideoService/Get',
      ($0.LinkToVideoServiceGetRequest value) => value.writeToBuffer(),
      $0.LinkToVideoServiceGetResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.production.v1.LinkToVideoService')
abstract class LinkToVideoServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.production.v1.LinkToVideoService';

  LinkToVideoServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LinkToVideoServiceScrapeRequest,
            $0.LinkToVideoServiceScrapeResponse>(
        'Scrape',
        scrape_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LinkToVideoServiceScrapeRequest.fromBuffer(value),
        ($0.LinkToVideoServiceScrapeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LinkToVideoServiceGenerateRequest,
            $0.LinkToVideoServiceGenerateResponse>(
        'Generate',
        generate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LinkToVideoServiceGenerateRequest.fromBuffer(value),
        ($0.LinkToVideoServiceGenerateResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LinkToVideoServiceGetRequest,
            $0.LinkToVideoServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.LinkToVideoServiceGetRequest.fromBuffer(value),
        ($0.LinkToVideoServiceGetResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LinkToVideoServiceScrapeResponse> scrape_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LinkToVideoServiceScrapeRequest> $request) async {
    return scrape($call, await $request);
  }

  $async.Future<$0.LinkToVideoServiceScrapeResponse> scrape(
      $grpc.ServiceCall call, $0.LinkToVideoServiceScrapeRequest request);

  $async.Future<$0.LinkToVideoServiceGenerateResponse> generate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LinkToVideoServiceGenerateRequest> $request) async {
    return generate($call, await $request);
  }

  $async.Future<$0.LinkToVideoServiceGenerateResponse> generate(
      $grpc.ServiceCall call, $0.LinkToVideoServiceGenerateRequest request);

  $async.Future<$0.LinkToVideoServiceGetResponse> get_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.LinkToVideoServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.LinkToVideoServiceGetResponse> get(
      $grpc.ServiceCall call, $0.LinkToVideoServiceGetRequest request);
}

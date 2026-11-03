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

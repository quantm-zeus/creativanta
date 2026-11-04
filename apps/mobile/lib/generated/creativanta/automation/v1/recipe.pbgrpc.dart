// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/recipe.proto.

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

import 'recipe.pb.dart' as $0;

export 'recipe.pb.dart';

/// RecipeService provides workspace recipe installation, configuration, and execution.
@$pb.GrpcServiceName('creativanta.automation.v1.RecipeService')
class RecipeServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RecipeServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.RecipeServiceInstallResponse> install(
    $0.RecipeServiceInstallRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$install, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecipeServiceUninstallResponse> uninstall(
    $0.RecipeServiceUninstallRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$uninstall, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecipeServiceListResponse> list(
    $0.RecipeServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecipeServiceGetResponse> get(
    $0.RecipeServiceGetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecipeServiceRunResponse> run(
    $0.RecipeServiceRunRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$run, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecipeServiceGetRunStatusResponse> getRunStatus(
    $0.RecipeServiceGetRunStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRunStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecipeServiceListRunsResponse> listRuns(
    $0.RecipeServiceListRunsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRuns, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecipeServiceConfigureResponse> configure(
    $0.RecipeServiceConfigureRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$configure, request, options: options);
  }

  // method descriptors

  static final _$install = $grpc.ClientMethod<$0.RecipeServiceInstallRequest,
          $0.RecipeServiceInstallResponse>(
      '/creativanta.automation.v1.RecipeService/Install',
      ($0.RecipeServiceInstallRequest value) => value.writeToBuffer(),
      $0.RecipeServiceInstallResponse.fromBuffer);
  static final _$uninstall = $grpc.ClientMethod<
          $0.RecipeServiceUninstallRequest, $0.RecipeServiceUninstallResponse>(
      '/creativanta.automation.v1.RecipeService/Uninstall',
      ($0.RecipeServiceUninstallRequest value) => value.writeToBuffer(),
      $0.RecipeServiceUninstallResponse.fromBuffer);
  static final _$list = $grpc.ClientMethod<$0.RecipeServiceListRequest,
          $0.RecipeServiceListResponse>(
      '/creativanta.automation.v1.RecipeService/List',
      ($0.RecipeServiceListRequest value) => value.writeToBuffer(),
      $0.RecipeServiceListResponse.fromBuffer);
  static final _$get = $grpc.ClientMethod<$0.RecipeServiceGetRequest,
          $0.RecipeServiceGetResponse>(
      '/creativanta.automation.v1.RecipeService/Get',
      ($0.RecipeServiceGetRequest value) => value.writeToBuffer(),
      $0.RecipeServiceGetResponse.fromBuffer);
  static final _$run = $grpc.ClientMethod<$0.RecipeServiceRunRequest,
          $0.RecipeServiceRunResponse>(
      '/creativanta.automation.v1.RecipeService/Run',
      ($0.RecipeServiceRunRequest value) => value.writeToBuffer(),
      $0.RecipeServiceRunResponse.fromBuffer);
  static final _$getRunStatus = $grpc.ClientMethod<
          $0.RecipeServiceGetRunStatusRequest,
          $0.RecipeServiceGetRunStatusResponse>(
      '/creativanta.automation.v1.RecipeService/GetRunStatus',
      ($0.RecipeServiceGetRunStatusRequest value) => value.writeToBuffer(),
      $0.RecipeServiceGetRunStatusResponse.fromBuffer);
  static final _$listRuns = $grpc.ClientMethod<$0.RecipeServiceListRunsRequest,
          $0.RecipeServiceListRunsResponse>(
      '/creativanta.automation.v1.RecipeService/ListRuns',
      ($0.RecipeServiceListRunsRequest value) => value.writeToBuffer(),
      $0.RecipeServiceListRunsResponse.fromBuffer);
  static final _$configure = $grpc.ClientMethod<
          $0.RecipeServiceConfigureRequest, $0.RecipeServiceConfigureResponse>(
      '/creativanta.automation.v1.RecipeService/Configure',
      ($0.RecipeServiceConfigureRequest value) => value.writeToBuffer(),
      $0.RecipeServiceConfigureResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.automation.v1.RecipeService')
abstract class RecipeServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.automation.v1.RecipeService';

  RecipeServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RecipeServiceInstallRequest,
            $0.RecipeServiceInstallResponse>(
        'Install',
        install_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecipeServiceInstallRequest.fromBuffer(value),
        ($0.RecipeServiceInstallResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecipeServiceUninstallRequest,
            $0.RecipeServiceUninstallResponse>(
        'Uninstall',
        uninstall_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecipeServiceUninstallRequest.fromBuffer(value),
        ($0.RecipeServiceUninstallResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecipeServiceListRequest,
            $0.RecipeServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecipeServiceListRequest.fromBuffer(value),
        ($0.RecipeServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecipeServiceGetRequest,
            $0.RecipeServiceGetResponse>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecipeServiceGetRequest.fromBuffer(value),
        ($0.RecipeServiceGetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecipeServiceRunRequest,
            $0.RecipeServiceRunResponse>(
        'Run',
        run_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecipeServiceRunRequest.fromBuffer(value),
        ($0.RecipeServiceRunResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecipeServiceGetRunStatusRequest,
            $0.RecipeServiceGetRunStatusResponse>(
        'GetRunStatus',
        getRunStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecipeServiceGetRunStatusRequest.fromBuffer(value),
        ($0.RecipeServiceGetRunStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecipeServiceListRunsRequest,
            $0.RecipeServiceListRunsResponse>(
        'ListRuns',
        listRuns_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecipeServiceListRunsRequest.fromBuffer(value),
        ($0.RecipeServiceListRunsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecipeServiceConfigureRequest,
            $0.RecipeServiceConfigureResponse>(
        'Configure',
        configure_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecipeServiceConfigureRequest.fromBuffer(value),
        ($0.RecipeServiceConfigureResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RecipeServiceInstallResponse> install_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RecipeServiceInstallRequest> $request) async {
    return install($call, await $request);
  }

  $async.Future<$0.RecipeServiceInstallResponse> install(
      $grpc.ServiceCall call, $0.RecipeServiceInstallRequest request);

  $async.Future<$0.RecipeServiceUninstallResponse> uninstall_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RecipeServiceUninstallRequest> $request) async {
    return uninstall($call, await $request);
  }

  $async.Future<$0.RecipeServiceUninstallResponse> uninstall(
      $grpc.ServiceCall call, $0.RecipeServiceUninstallRequest request);

  $async.Future<$0.RecipeServiceListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RecipeServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.RecipeServiceListResponse> list(
      $grpc.ServiceCall call, $0.RecipeServiceListRequest request);

  $async.Future<$0.RecipeServiceGetResponse> get_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RecipeServiceGetRequest> $request) async {
    return get($call, await $request);
  }

  $async.Future<$0.RecipeServiceGetResponse> get(
      $grpc.ServiceCall call, $0.RecipeServiceGetRequest request);

  $async.Future<$0.RecipeServiceRunResponse> run_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RecipeServiceRunRequest> $request) async {
    return run($call, await $request);
  }

  $async.Future<$0.RecipeServiceRunResponse> run(
      $grpc.ServiceCall call, $0.RecipeServiceRunRequest request);

  $async.Future<$0.RecipeServiceGetRunStatusResponse> getRunStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RecipeServiceGetRunStatusRequest> $request) async {
    return getRunStatus($call, await $request);
  }

  $async.Future<$0.RecipeServiceGetRunStatusResponse> getRunStatus(
      $grpc.ServiceCall call, $0.RecipeServiceGetRunStatusRequest request);

  $async.Future<$0.RecipeServiceListRunsResponse> listRuns_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RecipeServiceListRunsRequest> $request) async {
    return listRuns($call, await $request);
  }

  $async.Future<$0.RecipeServiceListRunsResponse> listRuns(
      $grpc.ServiceCall call, $0.RecipeServiceListRunsRequest request);

  $async.Future<$0.RecipeServiceConfigureResponse> configure_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RecipeServiceConfigureRequest> $request) async {
    return configure($call, await $request);
  }

  $async.Future<$0.RecipeServiceConfigureResponse> configure(
      $grpc.ServiceCall call, $0.RecipeServiceConfigureRequest request);
}

/// TemplateService provides public and tenant template marketplace discovery and deployment.
@$pb.GrpcServiceName('creativanta.automation.v1.TemplateService')
class TemplateServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TemplateServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.TemplateServiceListTemplatesResponse> listTemplates(
    $0.TemplateServiceListTemplatesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTemplates, request, options: options);
  }

  $grpc.ResponseFuture<$0.TemplateServiceGetTemplateResponse> getTemplate(
    $0.TemplateServiceGetTemplateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTemplate, request, options: options);
  }

  $grpc.ResponseFuture<$0.TemplateServiceSearchTemplatesResponse>
      searchTemplates(
    $0.TemplateServiceSearchTemplatesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$searchTemplates, request, options: options);
  }

  $grpc.ResponseFuture<$0.TemplateServiceGetFeaturedResponse> getFeatured(
    $0.TemplateServiceGetFeaturedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFeatured, request, options: options);
  }

  $grpc.ResponseFuture<$0.TemplateServiceGetReviewsResponse> getReviews(
    $0.TemplateServiceGetReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReviews, request, options: options);
  }

  $grpc.ResponseFuture<$0.TemplateServiceDeployResponse> deploy(
    $0.TemplateServiceDeployRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deploy, request, options: options);
  }

  // method descriptors

  static final _$listTemplates = $grpc.ClientMethod<
          $0.TemplateServiceListTemplatesRequest,
          $0.TemplateServiceListTemplatesResponse>(
      '/creativanta.automation.v1.TemplateService/ListTemplates',
      ($0.TemplateServiceListTemplatesRequest value) => value.writeToBuffer(),
      $0.TemplateServiceListTemplatesResponse.fromBuffer);
  static final _$getTemplate = $grpc.ClientMethod<
          $0.TemplateServiceGetTemplateRequest,
          $0.TemplateServiceGetTemplateResponse>(
      '/creativanta.automation.v1.TemplateService/GetTemplate',
      ($0.TemplateServiceGetTemplateRequest value) => value.writeToBuffer(),
      $0.TemplateServiceGetTemplateResponse.fromBuffer);
  static final _$searchTemplates = $grpc.ClientMethod<
          $0.TemplateServiceSearchTemplatesRequest,
          $0.TemplateServiceSearchTemplatesResponse>(
      '/creativanta.automation.v1.TemplateService/SearchTemplates',
      ($0.TemplateServiceSearchTemplatesRequest value) => value.writeToBuffer(),
      $0.TemplateServiceSearchTemplatesResponse.fromBuffer);
  static final _$getFeatured = $grpc.ClientMethod<
          $0.TemplateServiceGetFeaturedRequest,
          $0.TemplateServiceGetFeaturedResponse>(
      '/creativanta.automation.v1.TemplateService/GetFeatured',
      ($0.TemplateServiceGetFeaturedRequest value) => value.writeToBuffer(),
      $0.TemplateServiceGetFeaturedResponse.fromBuffer);
  static final _$getReviews = $grpc.ClientMethod<
          $0.TemplateServiceGetReviewsRequest,
          $0.TemplateServiceGetReviewsResponse>(
      '/creativanta.automation.v1.TemplateService/GetReviews',
      ($0.TemplateServiceGetReviewsRequest value) => value.writeToBuffer(),
      $0.TemplateServiceGetReviewsResponse.fromBuffer);
  static final _$deploy = $grpc.ClientMethod<$0.TemplateServiceDeployRequest,
          $0.TemplateServiceDeployResponse>(
      '/creativanta.automation.v1.TemplateService/Deploy',
      ($0.TemplateServiceDeployRequest value) => value.writeToBuffer(),
      $0.TemplateServiceDeployResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.automation.v1.TemplateService')
abstract class TemplateServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.automation.v1.TemplateService';

  TemplateServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TemplateServiceListTemplatesRequest,
            $0.TemplateServiceListTemplatesResponse>(
        'ListTemplates',
        listTemplates_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TemplateServiceListTemplatesRequest.fromBuffer(value),
        ($0.TemplateServiceListTemplatesResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TemplateServiceGetTemplateRequest,
            $0.TemplateServiceGetTemplateResponse>(
        'GetTemplate',
        getTemplate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TemplateServiceGetTemplateRequest.fromBuffer(value),
        ($0.TemplateServiceGetTemplateResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TemplateServiceSearchTemplatesRequest,
            $0.TemplateServiceSearchTemplatesResponse>(
        'SearchTemplates',
        searchTemplates_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TemplateServiceSearchTemplatesRequest.fromBuffer(value),
        ($0.TemplateServiceSearchTemplatesResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TemplateServiceGetFeaturedRequest,
            $0.TemplateServiceGetFeaturedResponse>(
        'GetFeatured',
        getFeatured_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TemplateServiceGetFeaturedRequest.fromBuffer(value),
        ($0.TemplateServiceGetFeaturedResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TemplateServiceGetReviewsRequest,
            $0.TemplateServiceGetReviewsResponse>(
        'GetReviews',
        getReviews_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TemplateServiceGetReviewsRequest.fromBuffer(value),
        ($0.TemplateServiceGetReviewsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TemplateServiceDeployRequest,
            $0.TemplateServiceDeployResponse>(
        'Deploy',
        deploy_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TemplateServiceDeployRequest.fromBuffer(value),
        ($0.TemplateServiceDeployResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.TemplateServiceListTemplatesResponse> listTemplates_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TemplateServiceListTemplatesRequest> $request) async {
    return listTemplates($call, await $request);
  }

  $async.Future<$0.TemplateServiceListTemplatesResponse> listTemplates(
      $grpc.ServiceCall call, $0.TemplateServiceListTemplatesRequest request);

  $async.Future<$0.TemplateServiceGetTemplateResponse> getTemplate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TemplateServiceGetTemplateRequest> $request) async {
    return getTemplate($call, await $request);
  }

  $async.Future<$0.TemplateServiceGetTemplateResponse> getTemplate(
      $grpc.ServiceCall call, $0.TemplateServiceGetTemplateRequest request);

  $async.Future<$0.TemplateServiceSearchTemplatesResponse> searchTemplates_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TemplateServiceSearchTemplatesRequest> $request) async {
    return searchTemplates($call, await $request);
  }

  $async.Future<$0.TemplateServiceSearchTemplatesResponse> searchTemplates(
      $grpc.ServiceCall call, $0.TemplateServiceSearchTemplatesRequest request);

  $async.Future<$0.TemplateServiceGetFeaturedResponse> getFeatured_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TemplateServiceGetFeaturedRequest> $request) async {
    return getFeatured($call, await $request);
  }

  $async.Future<$0.TemplateServiceGetFeaturedResponse> getFeatured(
      $grpc.ServiceCall call, $0.TemplateServiceGetFeaturedRequest request);

  $async.Future<$0.TemplateServiceGetReviewsResponse> getReviews_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TemplateServiceGetReviewsRequest> $request) async {
    return getReviews($call, await $request);
  }

  $async.Future<$0.TemplateServiceGetReviewsResponse> getReviews(
      $grpc.ServiceCall call, $0.TemplateServiceGetReviewsRequest request);

  $async.Future<$0.TemplateServiceDeployResponse> deploy_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TemplateServiceDeployRequest> $request) async {
    return deploy($call, await $request);
  }

  $async.Future<$0.TemplateServiceDeployResponse> deploy(
      $grpc.ServiceCall call, $0.TemplateServiceDeployRequest request);
}

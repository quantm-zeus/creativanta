// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/capability.proto.

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

import 'capability.pb.dart' as $0;

export 'capability.pb.dart';

/// Workspace Capability Matrix & Policy Transparency service (M22).
/// Enforces the 5-state capability contract (native, read_only, manual, degraded, unsupported),
/// ActionAccessVerification pre-execution gates, policy notes, fallback paths, and composite
/// platform health scores with proactive business coaching (RULE-M22-001 through RULE-M22-005).
@$pb.GrpcServiceName('creativanta.admin.v1.CapabilityService')
class CapabilityServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CapabilityServiceClient(super.channel, {super.options, super.interceptors});

  /// Returns the workspace capability matrix across all 6 canonical platforms and actions.
  /// Required RBAC permission: capability:read.
  $grpc.ResponseFuture<$0.GetMatrixResponse> getMatrix(
    $0.GetMatrixRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMatrix, request, options: options);
  }

  /// Returns composite platform health scores (0-100) and proactive coaching cards for connected accounts.
  /// Required RBAC permission: capability:read.
  $grpc.ResponseFuture<$0.GetHealthScoresResponse> getHealthScores(
    $0.GetHealthScoresRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHealthScores, request, options: options);
  }

  /// Lists policy notes explaining platform restrictions and approval requirements.
  /// Required RBAC permission: capability:read.
  $grpc.ResponseFuture<$0.ListPolicyNotesResponse> listPolicyNotes(
    $0.ListPolicyNotesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPolicyNotes, request, options: options);
  }

  /// Lists guided fallback paths for actions in manual, read_only, degraded, or unsupported state.
  /// Required RBAC permission: capability:read.
  $grpc.ResponseFuture<$0.ListFallbackPathsResponse> listFallbackPaths(
    $0.ListFallbackPathsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listFallbackPaths, request, options: options);
  }

  // method descriptors

  static final _$getMatrix =
      $grpc.ClientMethod<$0.GetMatrixRequest, $0.GetMatrixResponse>(
          '/creativanta.admin.v1.CapabilityService/GetMatrix',
          ($0.GetMatrixRequest value) => value.writeToBuffer(),
          $0.GetMatrixResponse.fromBuffer);
  static final _$getHealthScores =
      $grpc.ClientMethod<$0.GetHealthScoresRequest, $0.GetHealthScoresResponse>(
          '/creativanta.admin.v1.CapabilityService/GetHealthScores',
          ($0.GetHealthScoresRequest value) => value.writeToBuffer(),
          $0.GetHealthScoresResponse.fromBuffer);
  static final _$listPolicyNotes =
      $grpc.ClientMethod<$0.ListPolicyNotesRequest, $0.ListPolicyNotesResponse>(
          '/creativanta.admin.v1.CapabilityService/ListPolicyNotes',
          ($0.ListPolicyNotesRequest value) => value.writeToBuffer(),
          $0.ListPolicyNotesResponse.fromBuffer);
  static final _$listFallbackPaths = $grpc.ClientMethod<
          $0.ListFallbackPathsRequest, $0.ListFallbackPathsResponse>(
      '/creativanta.admin.v1.CapabilityService/ListFallbackPaths',
      ($0.ListFallbackPathsRequest value) => value.writeToBuffer(),
      $0.ListFallbackPathsResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.CapabilityService')
abstract class CapabilityServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.CapabilityService';

  CapabilityServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetMatrixRequest, $0.GetMatrixResponse>(
        'GetMatrix',
        getMatrix_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetMatrixRequest.fromBuffer(value),
        ($0.GetMatrixResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetHealthScoresRequest,
            $0.GetHealthScoresResponse>(
        'GetHealthScores',
        getHealthScores_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetHealthScoresRequest.fromBuffer(value),
        ($0.GetHealthScoresResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPolicyNotesRequest,
            $0.ListPolicyNotesResponse>(
        'ListPolicyNotes',
        listPolicyNotes_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListPolicyNotesRequest.fromBuffer(value),
        ($0.ListPolicyNotesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListFallbackPathsRequest,
            $0.ListFallbackPathsResponse>(
        'ListFallbackPaths',
        listFallbackPaths_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListFallbackPathsRequest.fromBuffer(value),
        ($0.ListFallbackPathsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetMatrixResponse> getMatrix_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMatrixRequest> $request) async {
    return getMatrix($call, await $request);
  }

  $async.Future<$0.GetMatrixResponse> getMatrix(
      $grpc.ServiceCall call, $0.GetMatrixRequest request);

  $async.Future<$0.GetHealthScoresResponse> getHealthScores_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetHealthScoresRequest> $request) async {
    return getHealthScores($call, await $request);
  }

  $async.Future<$0.GetHealthScoresResponse> getHealthScores(
      $grpc.ServiceCall call, $0.GetHealthScoresRequest request);

  $async.Future<$0.ListPolicyNotesResponse> listPolicyNotes_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPolicyNotesRequest> $request) async {
    return listPolicyNotes($call, await $request);
  }

  $async.Future<$0.ListPolicyNotesResponse> listPolicyNotes(
      $grpc.ServiceCall call, $0.ListPolicyNotesRequest request);

  $async.Future<$0.ListFallbackPathsResponse> listFallbackPaths_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListFallbackPathsRequest> $request) async {
    return listFallbackPaths($call, await $request);
  }

  $async.Future<$0.ListFallbackPathsResponse> listFallbackPaths(
      $grpc.ServiceCall call, $0.ListFallbackPathsRequest request);
}

/// Workspace Connected Accounts & Action Verification service (M22).
/// Never exposes access_token_encrypted or refresh_token_encrypted (RULE-M22-005).
@$pb.GrpcServiceName('creativanta.admin.v1.ConnectorService')
class ConnectorServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ConnectorServiceClient(super.channel, {super.options, super.interceptors});

  /// Lists connected accounts in the workspace with sanitized token status and health score.
  /// Required RBAC permission: account:read.
  $grpc.ResponseFuture<$0.ConnectorServiceListResponse> list(
    $0.ConnectorServiceListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  /// Evaluates whether a specific platform action is verified and executable for a connected account.
  /// Required RBAC permission: account:read.
  $grpc.ResponseFuture<$0.ConnectorServiceCheckResponse> check(
    $0.ConnectorServiceCheckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$check, request, options: options);
  }

  /// Computes and persists the composite platform health score for a connected account.
  /// Required RBAC permission: account:read.
  $grpc.ResponseFuture<$0.ConnectorServiceCheckHealthResponse> checkHealth(
    $0.ConnectorServiceCheckHealthRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkHealth, request, options: options);
  }

  /// Disconnects a connected account and revokes its active capability snapshots.
  /// Required RBAC permission: account:disconnect.
  $grpc.ResponseFuture<$0.ConnectorServiceDisconnectResponse> disconnect(
    $0.ConnectorServiceDisconnectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$disconnect, request, options: options);
  }

  // method descriptors

  static final _$list = $grpc.ClientMethod<$0.ConnectorServiceListRequest,
          $0.ConnectorServiceListResponse>(
      '/creativanta.admin.v1.ConnectorService/List',
      ($0.ConnectorServiceListRequest value) => value.writeToBuffer(),
      $0.ConnectorServiceListResponse.fromBuffer);
  static final _$check = $grpc.ClientMethod<$0.ConnectorServiceCheckRequest,
          $0.ConnectorServiceCheckResponse>(
      '/creativanta.admin.v1.ConnectorService/Check',
      ($0.ConnectorServiceCheckRequest value) => value.writeToBuffer(),
      $0.ConnectorServiceCheckResponse.fromBuffer);
  static final _$checkHealth = $grpc.ClientMethod<
          $0.ConnectorServiceCheckHealthRequest,
          $0.ConnectorServiceCheckHealthResponse>(
      '/creativanta.admin.v1.ConnectorService/CheckHealth',
      ($0.ConnectorServiceCheckHealthRequest value) => value.writeToBuffer(),
      $0.ConnectorServiceCheckHealthResponse.fromBuffer);
  static final _$disconnect = $grpc.ClientMethod<
          $0.ConnectorServiceDisconnectRequest,
          $0.ConnectorServiceDisconnectResponse>(
      '/creativanta.admin.v1.ConnectorService/Disconnect',
      ($0.ConnectorServiceDisconnectRequest value) => value.writeToBuffer(),
      $0.ConnectorServiceDisconnectResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.ConnectorService')
abstract class ConnectorServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.ConnectorService';

  ConnectorServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ConnectorServiceListRequest,
            $0.ConnectorServiceListResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConnectorServiceListRequest.fromBuffer(value),
        ($0.ConnectorServiceListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConnectorServiceCheckRequest,
            $0.ConnectorServiceCheckResponse>(
        'Check',
        check_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConnectorServiceCheckRequest.fromBuffer(value),
        ($0.ConnectorServiceCheckResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConnectorServiceCheckHealthRequest,
            $0.ConnectorServiceCheckHealthResponse>(
        'CheckHealth',
        checkHealth_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConnectorServiceCheckHealthRequest.fromBuffer(value),
        ($0.ConnectorServiceCheckHealthResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConnectorServiceDisconnectRequest,
            $0.ConnectorServiceDisconnectResponse>(
        'Disconnect',
        disconnect_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConnectorServiceDisconnectRequest.fromBuffer(value),
        ($0.ConnectorServiceDisconnectResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.ConnectorServiceListResponse> list_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ConnectorServiceListRequest> $request) async {
    return list($call, await $request);
  }

  $async.Future<$0.ConnectorServiceListResponse> list(
      $grpc.ServiceCall call, $0.ConnectorServiceListRequest request);

  $async.Future<$0.ConnectorServiceCheckResponse> check_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ConnectorServiceCheckRequest> $request) async {
    return check($call, await $request);
  }

  $async.Future<$0.ConnectorServiceCheckResponse> check(
      $grpc.ServiceCall call, $0.ConnectorServiceCheckRequest request);

  $async.Future<$0.ConnectorServiceCheckHealthResponse> checkHealth_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ConnectorServiceCheckHealthRequest> $request) async {
    return checkHealth($call, await $request);
  }

  $async.Future<$0.ConnectorServiceCheckHealthResponse> checkHealth(
      $grpc.ServiceCall call, $0.ConnectorServiceCheckHealthRequest request);

  $async.Future<$0.ConnectorServiceDisconnectResponse> disconnect_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ConnectorServiceDisconnectRequest> $request) async {
    return disconnect($call, await $request);
  }

  $async.Future<$0.ConnectorServiceDisconnectResponse> disconnect(
      $grpc.ServiceCall call, $0.ConnectorServiceDisconnectRequest request);
}

// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/diagnostics.proto.

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

import 'diagnostics.pb.dart' as $0;

export 'diagnostics.pb.dart';

/// Workspace Diagnostics Center service (M23).
/// Provides health summary, 8-category health grid, user-friendly issue explanations
/// (RULE-M23-A04), full health checks, and 4-step guided repair wizard execution
/// including unknown external effect reconciliation.
@$pb.GrpcServiceName('creativanta.admin.v1.DiagnosticsService')
class DiagnosticsServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  DiagnosticsServiceClient(super.channel, {super.options, super.interceptors});

  /// Returns high-level workspace health KPIs (overall status, active issues, connected accounts, queue health).
  /// Required RBAC permission: diagnostics:read.
  $grpc.ResponseFuture<$0.GetOverviewResponse> getOverview(
    $0.GetOverviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOverview, request, options: options);
  }

  /// Returns the 8-category diagnostic health grid for the workspace.
  /// Required RBAC permission: diagnostics:read.
  $grpc.ResponseFuture<$0.GetHealthGridResponse> getHealthGrid(
    $0.GetHealthGridRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHealthGrid, request, options: options);
  }

  /// Lists diagnostic issues with user-facing explanations, likely causes, and recommended actions.
  /// Required RBAC permission: diagnostics:read.
  $grpc.ResponseFuture<$0.ListIssuesResponse> listIssues(
    $0.ListIssuesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listIssues, request, options: options);
  }

  /// Runs a full diagnostic health check across connected accounts, queues, webhooks, and external effects.
  /// Required RBAC permission: workspace:settings:manage.
  $grpc.ResponseFuture<$0.RunFullCheckResponse> runFullCheck(
    $0.RunFullCheckRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$runFullCheck, request, options: options);
  }

  /// Executes one step of the 4-step guided repair wizard (Verify -> Diagnose -> Fix -> Confirm).
  /// Required RBAC permission: workspace:settings:manage.
  $grpc.ResponseFuture<$0.ExecuteRepairStepResponse> executeRepairStep(
    $0.ExecuteRepairStepRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$executeRepairStep, request, options: options);
  }

  // method descriptors

  static final _$getOverview =
      $grpc.ClientMethod<$0.GetOverviewRequest, $0.GetOverviewResponse>(
          '/creativanta.admin.v1.DiagnosticsService/GetOverview',
          ($0.GetOverviewRequest value) => value.writeToBuffer(),
          $0.GetOverviewResponse.fromBuffer);
  static final _$getHealthGrid =
      $grpc.ClientMethod<$0.GetHealthGridRequest, $0.GetHealthGridResponse>(
          '/creativanta.admin.v1.DiagnosticsService/GetHealthGrid',
          ($0.GetHealthGridRequest value) => value.writeToBuffer(),
          $0.GetHealthGridResponse.fromBuffer);
  static final _$listIssues =
      $grpc.ClientMethod<$0.ListIssuesRequest, $0.ListIssuesResponse>(
          '/creativanta.admin.v1.DiagnosticsService/ListIssues',
          ($0.ListIssuesRequest value) => value.writeToBuffer(),
          $0.ListIssuesResponse.fromBuffer);
  static final _$runFullCheck =
      $grpc.ClientMethod<$0.RunFullCheckRequest, $0.RunFullCheckResponse>(
          '/creativanta.admin.v1.DiagnosticsService/RunFullCheck',
          ($0.RunFullCheckRequest value) => value.writeToBuffer(),
          $0.RunFullCheckResponse.fromBuffer);
  static final _$executeRepairStep = $grpc.ClientMethod<
          $0.ExecuteRepairStepRequest, $0.ExecuteRepairStepResponse>(
      '/creativanta.admin.v1.DiagnosticsService/ExecuteRepairStep',
      ($0.ExecuteRepairStepRequest value) => value.writeToBuffer(),
      $0.ExecuteRepairStepResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.DiagnosticsService')
abstract class DiagnosticsServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.DiagnosticsService';

  DiagnosticsServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetOverviewRequest, $0.GetOverviewResponse>(
            'GetOverview',
            getOverview_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetOverviewRequest.fromBuffer(value),
            ($0.GetOverviewResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetHealthGridRequest, $0.GetHealthGridResponse>(
            'GetHealthGrid',
            getHealthGrid_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetHealthGridRequest.fromBuffer(value),
            ($0.GetHealthGridResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListIssuesRequest, $0.ListIssuesResponse>(
        'ListIssues',
        listIssues_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListIssuesRequest.fromBuffer(value),
        ($0.ListIssuesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RunFullCheckRequest, $0.RunFullCheckResponse>(
            'RunFullCheck',
            runFullCheck_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RunFullCheckRequest.fromBuffer(value),
            ($0.RunFullCheckResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExecuteRepairStepRequest,
            $0.ExecuteRepairStepResponse>(
        'ExecuteRepairStep',
        executeRepairStep_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExecuteRepairStepRequest.fromBuffer(value),
        ($0.ExecuteRepairStepResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetOverviewResponse> getOverview_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetOverviewRequest> $request) async {
    return getOverview($call, await $request);
  }

  $async.Future<$0.GetOverviewResponse> getOverview(
      $grpc.ServiceCall call, $0.GetOverviewRequest request);

  $async.Future<$0.GetHealthGridResponse> getHealthGrid_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetHealthGridRequest> $request) async {
    return getHealthGrid($call, await $request);
  }

  $async.Future<$0.GetHealthGridResponse> getHealthGrid(
      $grpc.ServiceCall call, $0.GetHealthGridRequest request);

  $async.Future<$0.ListIssuesResponse> listIssues_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListIssuesRequest> $request) async {
    return listIssues($call, await $request);
  }

  $async.Future<$0.ListIssuesResponse> listIssues(
      $grpc.ServiceCall call, $0.ListIssuesRequest request);

  $async.Future<$0.RunFullCheckResponse> runFullCheck_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RunFullCheckRequest> $request) async {
    return runFullCheck($call, await $request);
  }

  $async.Future<$0.RunFullCheckResponse> runFullCheck(
      $grpc.ServiceCall call, $0.RunFullCheckRequest request);

  $async.Future<$0.ExecuteRepairStepResponse> executeRepairStep_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ExecuteRepairStepRequest> $request) async {
    return executeRepairStep($call, await $request);
  }

  $async.Future<$0.ExecuteRepairStepResponse> executeRepairStep(
      $grpc.ServiceCall call, $0.ExecuteRepairStepRequest request);
}

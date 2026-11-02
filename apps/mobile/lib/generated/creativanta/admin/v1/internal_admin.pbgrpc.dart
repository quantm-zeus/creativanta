// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/internal_admin.proto.

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

import 'internal_admin.pb.dart' as $0;

export 'internal_admin.pb.dart';

/// Isolated Internal Admin Authentication & Read-Only Impersonation service (S26).
/// Mounted ONLY on the isolated admin listener (RoleAdminAPI / ModeAdminAPI).
/// Workspace tokens and workspace roles are strictly rejected with ADMIN_FORBIDDEN_001.
@$pb.GrpcServiceName('creativanta.admin.v1.AdminAuthService')
class AdminAuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AdminAuthServiceClient(super.channel, {super.options, super.interceptors});

  /// Authenticates an internal admin with email, password, VPN verification, and TOTP MFA code.
  /// Permission binding: PUBLIC (isolated admin listener only).
  $grpc.ResponseFuture<$0.LoginResponse> login(
    $0.LoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$login, request, options: options);
  }

  /// Starts a strictly read-only, 30-minute time-bounded impersonation session for support investigation.
  /// Required admin RBAC permission: admin:impersonate.
  $grpc.ResponseFuture<$0.ImpersonateResponse> impersonate(
    $0.ImpersonateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$impersonate, request, options: options);
  }

  /// Ends an active read-only impersonation session and records an immutable internal audit log entry.
  /// Required admin RBAC permission: admin:impersonate.
  $grpc.ResponseFuture<$0.EndImpersonationResponse> endImpersonation(
    $0.EndImpersonationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$endImpersonation, request, options: options);
  }

  // method descriptors

  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
      '/creativanta.admin.v1.AdminAuthService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      $0.LoginResponse.fromBuffer);
  static final _$impersonate =
      $grpc.ClientMethod<$0.ImpersonateRequest, $0.ImpersonateResponse>(
          '/creativanta.admin.v1.AdminAuthService/Impersonate',
          ($0.ImpersonateRequest value) => value.writeToBuffer(),
          $0.ImpersonateResponse.fromBuffer);
  static final _$endImpersonation = $grpc.ClientMethod<
          $0.EndImpersonationRequest, $0.EndImpersonationResponse>(
      '/creativanta.admin.v1.AdminAuthService/EndImpersonation',
      ($0.EndImpersonationRequest value) => value.writeToBuffer(),
      $0.EndImpersonationResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.AdminAuthService')
abstract class AdminAuthServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.AdminAuthService';

  AdminAuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ImpersonateRequest, $0.ImpersonateResponse>(
            'Impersonate',
            impersonate_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ImpersonateRequest.fromBuffer(value),
            ($0.ImpersonateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EndImpersonationRequest,
            $0.EndImpersonationResponse>(
        'EndImpersonation',
        endImpersonation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EndImpersonationRequest.fromBuffer(value),
        ($0.EndImpersonationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LoginResponse> login_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LoginRequest> $request) async {
    return login($call, await $request);
  }

  $async.Future<$0.LoginResponse> login(
      $grpc.ServiceCall call, $0.LoginRequest request);

  $async.Future<$0.ImpersonateResponse> impersonate_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ImpersonateRequest> $request) async {
    return impersonate($call, await $request);
  }

  $async.Future<$0.ImpersonateResponse> impersonate(
      $grpc.ServiceCall call, $0.ImpersonateRequest request);

  $async.Future<$0.EndImpersonationResponse> endImpersonation_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EndImpersonationRequest> $request) async {
    return endImpersonation($call, await $request);
  }

  $async.Future<$0.EndImpersonationResponse> endImpersonation(
      $grpc.ServiceCall call, $0.EndImpersonationRequest request);
}

/// Isolated Internal Admin Moderation Queue & Rules Engine service (S26).
/// Enforces normalized 0-100 risk bands, non-overridable hard blocks (SAFE-2026-02),
/// self-review conflict-of-interest protection (EC-S26-002), and SLA tracking (RULE-S26-006).
@$pb.GrpcServiceName('creativanta.admin.v1.ModerationService')
class ModerationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ModerationServiceClient(super.channel, {super.options, super.interceptors});

  /// Lists moderation cases ordered by SLA deadline and severity.
  /// Required admin RBAC permission: admin:moderation:manage.
  $grpc.ResponseFuture<$0.ListCasesResponse> listCases(
    $0.ListCasesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listCases, request, options: options);
  }

  /// Executes a moderation decision (approve, reject, warn, suspend, escalate) with mandatory reason and audit log.
  /// Required admin RBAC permission: admin:moderation:manage.
  $grpc.ResponseFuture<$0.ActOnCaseResponse> actOnCase(
    $0.ActOnCaseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$actOnCase, request, options: options);
  }

  // method descriptors

  static final _$listCases =
      $grpc.ClientMethod<$0.ListCasesRequest, $0.ListCasesResponse>(
          '/creativanta.admin.v1.ModerationService/ListCases',
          ($0.ListCasesRequest value) => value.writeToBuffer(),
          $0.ListCasesResponse.fromBuffer);
  static final _$actOnCase =
      $grpc.ClientMethod<$0.ActOnCaseRequest, $0.ActOnCaseResponse>(
          '/creativanta.admin.v1.ModerationService/ActOnCase',
          ($0.ActOnCaseRequest value) => value.writeToBuffer(),
          $0.ActOnCaseResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.ModerationService')
abstract class ModerationServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.ModerationService';

  ModerationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListCasesRequest, $0.ListCasesResponse>(
        'ListCases',
        listCases_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListCasesRequest.fromBuffer(value),
        ($0.ListCasesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ActOnCaseRequest, $0.ActOnCaseResponse>(
        'ActOnCase',
        actOnCase_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ActOnCaseRequest.fromBuffer(value),
        ($0.ActOnCaseResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListCasesResponse> listCases_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListCasesRequest> $request) async {
    return listCases($call, await $request);
  }

  $async.Future<$0.ListCasesResponse> listCases(
      $grpc.ServiceCall call, $0.ListCasesRequest request);

  $async.Future<$0.ActOnCaseResponse> actOnCase_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ActOnCaseRequest> $request) async {
    return actOnCase($call, await $request);
  }

  $async.Future<$0.ActOnCaseResponse> actOnCase(
      $grpc.ServiceCall call, $0.ActOnCaseRequest request);
}

/// Isolated Internal Admin System Configuration, Kill Switch & Maintenance service (S26).
@$pb.GrpcServiceName('creativanta.admin.v1.SystemConfigService')
class SystemConfigServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SystemConfigServiceClient(super.channel, {super.options, super.interceptors});

  /// Returns the internal admin operational health dashboard summary (A001).
  /// Required admin RBAC permission: admin:analytics:read.
  $grpc.ResponseFuture<$0.GetDashboardResponse> getDashboard(
    $0.GetDashboardRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDashboard, request, options: options);
  }

  /// Toggles a feature flag or emergency kill switch with mandatory audit reason and MFA session.
  /// Required admin RBAC permission: admin:feature_flag:toggle.
  $grpc.ResponseFuture<$0.ToggleFlagResponse> toggleFlag(
    $0.ToggleFlagRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$toggleFlag, request, options: options);
  }

  /// Toggles platform-wide maintenance mode with mandatory audit reason and MFA session.
  /// Required admin RBAC permission: admin:maintenance:toggle.
  $grpc.ResponseFuture<$0.ToggleMaintenanceResponse> toggleMaintenance(
    $0.ToggleMaintenanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$toggleMaintenance, request, options: options);
  }

  // method descriptors

  static final _$getDashboard =
      $grpc.ClientMethod<$0.GetDashboardRequest, $0.GetDashboardResponse>(
          '/creativanta.admin.v1.SystemConfigService/GetDashboard',
          ($0.GetDashboardRequest value) => value.writeToBuffer(),
          $0.GetDashboardResponse.fromBuffer);
  static final _$toggleFlag =
      $grpc.ClientMethod<$0.ToggleFlagRequest, $0.ToggleFlagResponse>(
          '/creativanta.admin.v1.SystemConfigService/ToggleFlag',
          ($0.ToggleFlagRequest value) => value.writeToBuffer(),
          $0.ToggleFlagResponse.fromBuffer);
  static final _$toggleMaintenance = $grpc.ClientMethod<
          $0.ToggleMaintenanceRequest, $0.ToggleMaintenanceResponse>(
      '/creativanta.admin.v1.SystemConfigService/ToggleMaintenance',
      ($0.ToggleMaintenanceRequest value) => value.writeToBuffer(),
      $0.ToggleMaintenanceResponse.fromBuffer);
}

@$pb.GrpcServiceName('creativanta.admin.v1.SystemConfigService')
abstract class SystemConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'creativanta.admin.v1.SystemConfigService';

  SystemConfigServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetDashboardRequest, $0.GetDashboardResponse>(
            'GetDashboard',
            getDashboard_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetDashboardRequest.fromBuffer(value),
            ($0.GetDashboardResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ToggleFlagRequest, $0.ToggleFlagResponse>(
        'ToggleFlag',
        toggleFlag_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ToggleFlagRequest.fromBuffer(value),
        ($0.ToggleFlagResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ToggleMaintenanceRequest,
            $0.ToggleMaintenanceResponse>(
        'ToggleMaintenance',
        toggleMaintenance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ToggleMaintenanceRequest.fromBuffer(value),
        ($0.ToggleMaintenanceResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetDashboardResponse> getDashboard_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDashboardRequest> $request) async {
    return getDashboard($call, await $request);
  }

  $async.Future<$0.GetDashboardResponse> getDashboard(
      $grpc.ServiceCall call, $0.GetDashboardRequest request);

  $async.Future<$0.ToggleFlagResponse> toggleFlag_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ToggleFlagRequest> $request) async {
    return toggleFlag($call, await $request);
  }

  $async.Future<$0.ToggleFlagResponse> toggleFlag(
      $grpc.ServiceCall call, $0.ToggleFlagRequest request);

  $async.Future<$0.ToggleMaintenanceResponse> toggleMaintenance_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ToggleMaintenanceRequest> $request) async {
    return toggleMaintenance($call, await $request);
  }

  $async.Future<$0.ToggleMaintenanceResponse> toggleMaintenance(
      $grpc.ServiceCall call, $0.ToggleMaintenanceRequest request);
}

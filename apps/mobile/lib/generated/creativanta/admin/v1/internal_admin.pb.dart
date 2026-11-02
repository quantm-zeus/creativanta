// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/internal_admin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $2;

import '../../common/v1/types.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Request for AdminAuthService/Login.
class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? email,
    $core.String? password,
    $core.String? totpCode,
    $core.String? ipAddress,
    $core.String? userAgent,
    $core.bool? vpnVerified,
  }) {
    final result = LoginRequest._();
    if (email != null) result.email = email;
    if (password != null) result.password = password;
    if (totpCode != null) result.totpCode = totpCode;
    if (ipAddress != null) result.ipAddress = ipAddress;
    if (userAgent != null) result.userAgent = userAgent;
    if (vpnVerified != null) result.vpnVerified = vpnVerified;
    return result;
  }

  LoginRequest._();

  factory LoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginRequest()..mergeFromBuffer(data, registry);
  factory LoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: LoginRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'totpCode')
    ..aOS(4, _omitFieldNames ? '' : 'ipAddress')
    ..aOS(5, _omitFieldNames ? '' : 'userAgent')
    ..aOB(6, _omitFieldNames ? '' : 'vpnVerified')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest copyWith(void Function(LoginRequest) updates) =>
      super.copyWith((message) => updates(message as LoginRequest))
          as LoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LoginRequest() / LoginRequest.new instead')
  static LoginRequest create() => LoginRequest._();
  static $pb.GeneratedMessage $_createMessage() => LoginRequest._();
  @$core.override
  LoginRequest createEmptyInstance() => LoginRequest._();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(
          LoginRequest.$_createMessage);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get totpCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set totpCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotpCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotpCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ipAddress => $_getSZ(3);
  @$pb.TagNumber(4)
  set ipAddress($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIpAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearIpAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get userAgent => $_getSZ(4);
  @$pb.TagNumber(5)
  set userAgent($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserAgent() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserAgent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get vpnVerified => $_getBF(5);
  @$pb.TagNumber(6)
  set vpnVerified($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVpnVerified() => $_has(5);
  @$pb.TagNumber(6)
  void clearVpnVerified() => $_clearField(6);
}

/// Response for AdminAuthService/Login.
class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $1.UUID? sessionId,
    $1.UUID? adminId,
    $core.String? role,
    $core.String? sessionToken,
    $core.bool? mfaVerified,
    $core.bool? vpnVerified,
    $2.Timestamp? expiresAt,
  }) {
    final result = LoginResponse._();
    if (sessionId != null) result.sessionId = sessionId;
    if (adminId != null) result.adminId = adminId;
    if (role != null) result.role = role;
    if (sessionToken != null) result.sessionToken = sessionToken;
    if (mfaVerified != null) result.mfaVerified = mfaVerified;
    if (vpnVerified != null) result.vpnVerified = vpnVerified;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginResponse()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LoginResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: LoginResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'sessionId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'adminId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'sessionToken')
    ..aOB(5, _omitFieldNames ? '' : 'mfaVerified')
    ..aOB(6, _omitFieldNames ? '' : 'vpnVerified')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse copyWith(void Function(LoginResponse) updates) =>
      super.copyWith((message) => updates(message as LoginResponse))
          as LoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LoginResponse() / LoginResponse.new instead')
  static LoginResponse create() => LoginResponse._();
  static $pb.GeneratedMessage $_createMessage() => LoginResponse._();
  @$core.override
  LoginResponse createEmptyInstance() => LoginResponse._();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse>(
          LoginResponse.$_createMessage);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get sessionId => $_getN(0);
  @$pb.TagNumber(1)
  set sessionId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureSessionId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get adminId => $_getN(1);
  @$pb.TagNumber(2)
  set adminId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAdminId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdminId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureAdminId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sessionToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set sessionToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSessionToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionToken() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get mfaVerified => $_getBF(4);
  @$pb.TagNumber(5)
  set mfaVerified($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMfaVerified() => $_has(4);
  @$pb.TagNumber(5)
  void clearMfaVerified() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get vpnVerified => $_getBF(5);
  @$pb.TagNumber(6)
  set vpnVerified($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVpnVerified() => $_has(5);
  @$pb.TagNumber(6)
  void clearVpnVerified() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Timestamp get expiresAt => $_getN(6);
  @$pb.TagNumber(7)
  set expiresAt($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExpiresAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpiresAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureExpiresAt() => $_ensure(6);
}

/// Request for AdminAuthService/Impersonate.
class ImpersonateRequest extends $pb.GeneratedMessage {
  factory ImpersonateRequest({
    $1.UUID? targetUserId,
    $1.UUID? targetWorkspaceId,
    $core.String? reason,
    $core.String? supportTicketId,
    $core.String? idempotencyKey,
  }) {
    final result = ImpersonateRequest._();
    if (targetUserId != null) result.targetUserId = targetUserId;
    if (targetWorkspaceId != null) result.targetWorkspaceId = targetWorkspaceId;
    if (reason != null) result.reason = reason;
    if (supportTicketId != null) result.supportTicketId = supportTicketId;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  ImpersonateRequest._();

  factory ImpersonateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImpersonateRequest()..mergeFromBuffer(data, registry);
  factory ImpersonateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImpersonateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImpersonateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ImpersonateRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'targetUserId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'targetWorkspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'supportTicketId')
    ..aOS(5, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImpersonateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImpersonateRequest copyWith(void Function(ImpersonateRequest) updates) =>
      super.copyWith((message) => updates(message as ImpersonateRequest))
          as ImpersonateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImpersonateRequest() / ImpersonateRequest.new instead')
  static ImpersonateRequest create() => ImpersonateRequest._();
  static $pb.GeneratedMessage $_createMessage() => ImpersonateRequest._();
  @$core.override
  ImpersonateRequest createEmptyInstance() => ImpersonateRequest._();
  @$core.pragma('dart2js:noInline')
  static ImpersonateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImpersonateRequest>(
          ImpersonateRequest.$_createMessage);
  static ImpersonateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get targetUserId => $_getN(0);
  @$pb.TagNumber(1)
  set targetUserId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTargetUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetUserId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureTargetUserId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get targetWorkspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set targetWorkspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureTargetWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get supportTicketId => $_getSZ(3);
  @$pb.TagNumber(4)
  set supportTicketId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSupportTicketId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSupportTicketId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get idempotencyKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set idempotencyKey($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIdempotencyKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdempotencyKey() => $_clearField(5);
}

/// Response for AdminAuthService/Impersonate.
class ImpersonateResponse extends $pb.GeneratedMessage {
  factory ImpersonateResponse({
    $1.UUID? impersonationId,
    $1.UUID? adminId,
    $1.UUID? targetUserId,
    $1.UUID? targetWorkspaceId,
    $core.String? mode,
    $2.Timestamp? startedAt,
    $2.Timestamp? expiresAt,
    $core.bool? replayed,
  }) {
    final result = ImpersonateResponse._();
    if (impersonationId != null) result.impersonationId = impersonationId;
    if (adminId != null) result.adminId = adminId;
    if (targetUserId != null) result.targetUserId = targetUserId;
    if (targetWorkspaceId != null) result.targetWorkspaceId = targetWorkspaceId;
    if (mode != null) result.mode = mode;
    if (startedAt != null) result.startedAt = startedAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (replayed != null) result.replayed = replayed;
    return result;
  }

  ImpersonateResponse._();

  factory ImpersonateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImpersonateResponse()..mergeFromBuffer(data, registry);
  factory ImpersonateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImpersonateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImpersonateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ImpersonateResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'impersonationId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'adminId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(3, _omitFieldNames ? '' : 'targetUserId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(4, _omitFieldNames ? '' : 'targetWorkspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'mode')
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOB(8, _omitFieldNames ? '' : 'replayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImpersonateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImpersonateResponse copyWith(void Function(ImpersonateResponse) updates) =>
      super.copyWith((message) => updates(message as ImpersonateResponse))
          as ImpersonateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ImpersonateResponse() / ImpersonateResponse.new instead')
  static ImpersonateResponse create() => ImpersonateResponse._();
  static $pb.GeneratedMessage $_createMessage() => ImpersonateResponse._();
  @$core.override
  ImpersonateResponse createEmptyInstance() => ImpersonateResponse._();
  @$core.pragma('dart2js:noInline')
  static ImpersonateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImpersonateResponse>(
          ImpersonateResponse.$_createMessage);
  static ImpersonateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get impersonationId => $_getN(0);
  @$pb.TagNumber(1)
  set impersonationId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasImpersonationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearImpersonationId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureImpersonationId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get adminId => $_getN(1);
  @$pb.TagNumber(2)
  set adminId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAdminId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdminId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureAdminId() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.UUID get targetUserId => $_getN(2);
  @$pb.TagNumber(3)
  set targetUserId($1.UUID value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetUserId() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.UUID ensureTargetUserId() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.UUID get targetWorkspaceId => $_getN(3);
  @$pb.TagNumber(4)
  set targetWorkspaceId($1.UUID value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetWorkspaceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetWorkspaceId() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.UUID ensureTargetWorkspaceId() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get mode => $_getSZ(4);
  @$pb.TagNumber(5)
  set mode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get startedAt => $_getN(5);
  @$pb.TagNumber(6)
  set startedAt($2.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStartedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureStartedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.Timestamp get expiresAt => $_getN(6);
  @$pb.TagNumber(7)
  set expiresAt($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExpiresAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpiresAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureExpiresAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get replayed => $_getBF(7);
  @$pb.TagNumber(8)
  set replayed($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReplayed() => $_has(7);
  @$pb.TagNumber(8)
  void clearReplayed() => $_clearField(8);
}

/// Request for AdminAuthService/EndImpersonation.
class EndImpersonationRequest extends $pb.GeneratedMessage {
  factory EndImpersonationRequest({
    $1.UUID? impersonationId,
    $core.String? reason,
  }) {
    final result = EndImpersonationRequest._();
    if (impersonationId != null) result.impersonationId = impersonationId;
    if (reason != null) result.reason = reason;
    return result;
  }

  EndImpersonationRequest._();

  factory EndImpersonationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EndImpersonationRequest()..mergeFromBuffer(data, registry);
  factory EndImpersonationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EndImpersonationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndImpersonationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: EndImpersonationRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'impersonationId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndImpersonationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndImpersonationRequest copyWith(
          void Function(EndImpersonationRequest) updates) =>
      super.copyWith((message) => updates(message as EndImpersonationRequest))
          as EndImpersonationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EndImpersonationRequest() / EndImpersonationRequest.new instead')
  static EndImpersonationRequest create() => EndImpersonationRequest._();
  static $pb.GeneratedMessage $_createMessage() => EndImpersonationRequest._();
  @$core.override
  EndImpersonationRequest createEmptyInstance() => EndImpersonationRequest._();
  @$core.pragma('dart2js:noInline')
  static EndImpersonationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndImpersonationRequest>(
          EndImpersonationRequest.$_createMessage);
  static EndImpersonationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get impersonationId => $_getN(0);
  @$pb.TagNumber(1)
  set impersonationId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasImpersonationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearImpersonationId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureImpersonationId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// Response for AdminAuthService/EndImpersonation.
class EndImpersonationResponse extends $pb.GeneratedMessage {
  factory EndImpersonationResponse({
    $1.UUID? impersonationId,
    $2.Timestamp? endedAt,
  }) {
    final result = EndImpersonationResponse._();
    if (impersonationId != null) result.impersonationId = impersonationId;
    if (endedAt != null) result.endedAt = endedAt;
    return result;
  }

  EndImpersonationResponse._();

  factory EndImpersonationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EndImpersonationResponse()..mergeFromBuffer(data, registry);
  factory EndImpersonationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EndImpersonationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndImpersonationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: EndImpersonationResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'impersonationId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndImpersonationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndImpersonationResponse copyWith(
          void Function(EndImpersonationResponse) updates) =>
      super.copyWith((message) => updates(message as EndImpersonationResponse))
          as EndImpersonationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EndImpersonationResponse() / EndImpersonationResponse.new instead')
  static EndImpersonationResponse create() => EndImpersonationResponse._();
  static $pb.GeneratedMessage $_createMessage() => EndImpersonationResponse._();
  @$core.override
  EndImpersonationResponse createEmptyInstance() =>
      EndImpersonationResponse._();
  @$core.pragma('dart2js:noInline')
  static EndImpersonationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndImpersonationResponse>(
          EndImpersonationResponse.$_createMessage);
  static EndImpersonationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get impersonationId => $_getN(0);
  @$pb.TagNumber(1)
  set impersonationId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasImpersonationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearImpersonationId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureImpersonationId() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Timestamp get endedAt => $_getN(1);
  @$pb.TagNumber(2)
  set endedAt($2.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureEndedAt() => $_ensure(1);
}

/// Moderation case item for A015 queue.
class ModerationCaseItem extends $pb.GeneratedMessage {
  factory ModerationCaseItem({
    $1.UUID? caseId,
    $1.UUID? workspaceId,
    $core.String? contentType,
    $1.UUID? contentId,
    $core.String? flagReason,
    $core.String? flagSource,
    $core.int? riskScore,
    $core.bool? isHardBlock,
    $core.String? status,
    $1.UUID? assignedAdminId,
    $core.String? decisionReason,
    $2.Timestamp? slaDeadline,
    $2.Timestamp? createdAt,
    $2.Timestamp? decidedAt,
  }) {
    final result = ModerationCaseItem._();
    if (caseId != null) result.caseId = caseId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (contentType != null) result.contentType = contentType;
    if (contentId != null) result.contentId = contentId;
    if (flagReason != null) result.flagReason = flagReason;
    if (flagSource != null) result.flagSource = flagSource;
    if (riskScore != null) result.riskScore = riskScore;
    if (isHardBlock != null) result.isHardBlock = isHardBlock;
    if (status != null) result.status = status;
    if (assignedAdminId != null) result.assignedAdminId = assignedAdminId;
    if (decisionReason != null) result.decisionReason = decisionReason;
    if (slaDeadline != null) result.slaDeadline = slaDeadline;
    if (createdAt != null) result.createdAt = createdAt;
    if (decidedAt != null) result.decidedAt = decidedAt;
    return result;
  }

  ModerationCaseItem._();

  factory ModerationCaseItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerationCaseItem()..mergeFromBuffer(data, registry);
  factory ModerationCaseItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModerationCaseItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerationCaseItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ModerationCaseItem.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'caseId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'contentType')
    ..aOM<$1.UUID>(4, _omitFieldNames ? '' : 'contentId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'flagReason')
    ..aOS(6, _omitFieldNames ? '' : 'flagSource')
    ..aI(7, _omitFieldNames ? '' : 'riskScore')
    ..aOB(8, _omitFieldNames ? '' : 'isHardBlock')
    ..aOS(9, _omitFieldNames ? '' : 'status')
    ..aOM<$1.UUID>(10, _omitFieldNames ? '' : 'assignedAdminId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(11, _omitFieldNames ? '' : 'decisionReason')
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'slaDeadline',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(14, _omitFieldNames ? '' : 'decidedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerationCaseItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerationCaseItem copyWith(void Function(ModerationCaseItem) updates) =>
      super.copyWith((message) => updates(message as ModerationCaseItem))
          as ModerationCaseItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModerationCaseItem() / ModerationCaseItem.new instead')
  static ModerationCaseItem create() => ModerationCaseItem._();
  static $pb.GeneratedMessage $_createMessage() => ModerationCaseItem._();
  @$core.override
  ModerationCaseItem createEmptyInstance() => ModerationCaseItem._();
  @$core.pragma('dart2js:noInline')
  static ModerationCaseItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerationCaseItem>(
          ModerationCaseItem.$_createMessage);
  static ModerationCaseItem? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get caseId => $_getN(0);
  @$pb.TagNumber(1)
  set caseId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureCaseId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get contentType => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentType() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.UUID get contentId => $_getN(3);
  @$pb.TagNumber(4)
  set contentId($1.UUID value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasContentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentId() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.UUID ensureContentId() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get flagReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set flagReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFlagReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearFlagReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get flagSource => $_getSZ(5);
  @$pb.TagNumber(6)
  set flagSource($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFlagSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearFlagSource() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get riskScore => $_getIZ(6);
  @$pb.TagNumber(7)
  set riskScore($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRiskScore() => $_has(6);
  @$pb.TagNumber(7)
  void clearRiskScore() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isHardBlock => $_getBF(7);
  @$pb.TagNumber(8)
  set isHardBlock($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsHardBlock() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsHardBlock() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get status => $_getSZ(8);
  @$pb.TagNumber(9)
  set status($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.UUID get assignedAdminId => $_getN(9);
  @$pb.TagNumber(10)
  set assignedAdminId($1.UUID value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasAssignedAdminId() => $_has(9);
  @$pb.TagNumber(10)
  void clearAssignedAdminId() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.UUID ensureAssignedAdminId() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get decisionReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set decisionReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDecisionReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearDecisionReason() => $_clearField(11);

  @$pb.TagNumber(12)
  $2.Timestamp get slaDeadline => $_getN(11);
  @$pb.TagNumber(12)
  set slaDeadline($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSlaDeadline() => $_has(11);
  @$pb.TagNumber(12)
  void clearSlaDeadline() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureSlaDeadline() => $_ensure(11);

  @$pb.TagNumber(13)
  $2.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $2.Timestamp get decidedAt => $_getN(13);
  @$pb.TagNumber(14)
  set decidedAt($2.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDecidedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearDecidedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Timestamp ensureDecidedAt() => $_ensure(13);
}

/// Request for ModerationService/ListCases.
class ListCasesRequest extends $pb.GeneratedMessage {
  factory ListCasesRequest({
    $core.String? statusFilter,
    $1.Pagination? pagination,
  }) {
    final result = ListCasesRequest._();
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListCasesRequest._();

  factory ListCasesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCasesRequest()..mergeFromBuffer(data, registry);
  factory ListCasesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCasesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCasesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListCasesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'statusFilter')
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCasesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCasesRequest copyWith(void Function(ListCasesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCasesRequest))
          as ListCasesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListCasesRequest() / ListCasesRequest.new instead')
  static ListCasesRequest create() => ListCasesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListCasesRequest._();
  @$core.override
  ListCasesRequest createEmptyInstance() => ListCasesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCasesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCasesRequest>(
          ListCasesRequest.$_createMessage);
  static ListCasesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get statusFilter => $_getSZ(0);
  @$pb.TagNumber(1)
  set statusFilter($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatusFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatusFilter() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);
}

/// Response for ModerationService/ListCases.
class ListCasesResponse extends $pb.GeneratedMessage {
  factory ListCasesResponse({
    $core.Iterable<ModerationCaseItem>? cases,
    $1.PaginatedResponse? pagination,
  }) {
    final result = ListCasesResponse._();
    if (cases != null) result.cases.addAll(cases);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListCasesResponse._();

  factory ListCasesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCasesResponse()..mergeFromBuffer(data, registry);
  factory ListCasesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCasesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCasesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListCasesResponse.$_createMessage)
    ..pPM<ModerationCaseItem>(1, _omitFieldNames ? '' : 'cases',
        subBuilder: ModerationCaseItem.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCasesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCasesResponse copyWith(void Function(ListCasesResponse) updates) =>
      super.copyWith((message) => updates(message as ListCasesResponse))
          as ListCasesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListCasesResponse() / ListCasesResponse.new instead')
  static ListCasesResponse create() => ListCasesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListCasesResponse._();
  @$core.override
  ListCasesResponse createEmptyInstance() => ListCasesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListCasesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCasesResponse>(
          ListCasesResponse.$_createMessage);
  static ListCasesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ModerationCaseItem> get cases => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePagination() => $_ensure(1);
}

/// Request for ModerationService/ActOnCase.
class ActOnCaseRequest extends $pb.GeneratedMessage {
  factory ActOnCaseRequest({
    $1.UUID? caseId,
    $core.String? decision,
    $core.String? reason,
    $core.String? evidenceReference,
    $core.String? idempotencyKey,
  }) {
    final result = ActOnCaseRequest._();
    if (caseId != null) result.caseId = caseId;
    if (decision != null) result.decision = decision;
    if (reason != null) result.reason = reason;
    if (evidenceReference != null) result.evidenceReference = evidenceReference;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  ActOnCaseRequest._();

  factory ActOnCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActOnCaseRequest()..mergeFromBuffer(data, registry);
  factory ActOnCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActOnCaseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActOnCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ActOnCaseRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'caseId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'decision')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'evidenceReference')
    ..aOS(5, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActOnCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActOnCaseRequest copyWith(void Function(ActOnCaseRequest) updates) =>
      super.copyWith((message) => updates(message as ActOnCaseRequest))
          as ActOnCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActOnCaseRequest() / ActOnCaseRequest.new instead')
  static ActOnCaseRequest create() => ActOnCaseRequest._();
  static $pb.GeneratedMessage $_createMessage() => ActOnCaseRequest._();
  @$core.override
  ActOnCaseRequest createEmptyInstance() => ActOnCaseRequest._();
  @$core.pragma('dart2js:noInline')
  static ActOnCaseRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActOnCaseRequest>(
          ActOnCaseRequest.$_createMessage);
  static ActOnCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get caseId => $_getN(0);
  @$pb.TagNumber(1)
  set caseId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureCaseId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get decision => $_getSZ(1);
  @$pb.TagNumber(2)
  set decision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDecision() => $_has(1);
  @$pb.TagNumber(2)
  void clearDecision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get evidenceReference => $_getSZ(3);
  @$pb.TagNumber(4)
  set evidenceReference($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEvidenceReference() => $_has(3);
  @$pb.TagNumber(4)
  void clearEvidenceReference() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get idempotencyKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set idempotencyKey($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIdempotencyKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdempotencyKey() => $_clearField(5);
}

/// Response for ModerationService/ActOnCase.
class ActOnCaseResponse extends $pb.GeneratedMessage {
  factory ActOnCaseResponse({
    ModerationCaseItem? moderationCase,
    $1.UUID? auditLogId,
    $core.bool? replayed,
  }) {
    final result = ActOnCaseResponse._();
    if (moderationCase != null) result.moderationCase = moderationCase;
    if (auditLogId != null) result.auditLogId = auditLogId;
    if (replayed != null) result.replayed = replayed;
    return result;
  }

  ActOnCaseResponse._();

  factory ActOnCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActOnCaseResponse()..mergeFromBuffer(data, registry);
  factory ActOnCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActOnCaseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActOnCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ActOnCaseResponse.$_createMessage)
    ..aOM<ModerationCaseItem>(1, _omitFieldNames ? '' : 'moderationCase',
        subBuilder: ModerationCaseItem.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'auditLogId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'replayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActOnCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActOnCaseResponse copyWith(void Function(ActOnCaseResponse) updates) =>
      super.copyWith((message) => updates(message as ActOnCaseResponse))
          as ActOnCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActOnCaseResponse() / ActOnCaseResponse.new instead')
  static ActOnCaseResponse create() => ActOnCaseResponse._();
  static $pb.GeneratedMessage $_createMessage() => ActOnCaseResponse._();
  @$core.override
  ActOnCaseResponse createEmptyInstance() => ActOnCaseResponse._();
  @$core.pragma('dart2js:noInline')
  static ActOnCaseResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActOnCaseResponse>(
          ActOnCaseResponse.$_createMessage);
  static ActOnCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ModerationCaseItem get moderationCase => $_getN(0);
  @$pb.TagNumber(1)
  set moderationCase(ModerationCaseItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasModerationCase() => $_has(0);
  @$pb.TagNumber(1)
  void clearModerationCase() => $_clearField(1);
  @$pb.TagNumber(1)
  ModerationCaseItem ensureModerationCase() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get auditLogId => $_getN(1);
  @$pb.TagNumber(2)
  set auditLogId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuditLogId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuditLogId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureAuditLogId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get replayed => $_getBF(2);
  @$pb.TagNumber(3)
  set replayed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReplayed() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplayed() => $_clearField(3);
}

/// Feature flag / kill switch item for A009.
class FeatureFlagItem extends $pb.GeneratedMessage {
  factory FeatureFlagItem({
    $1.UUID? flagId,
    $core.String? flagKey,
    $core.String? name,
    $core.String? description,
    $core.String? status,
    $core.int? percentage,
    $core.bool? isKillSwitch,
    $2.Timestamp? updatedAt,
  }) {
    final result = FeatureFlagItem._();
    if (flagId != null) result.flagId = flagId;
    if (flagKey != null) result.flagKey = flagKey;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (status != null) result.status = status;
    if (percentage != null) result.percentage = percentage;
    if (isKillSwitch != null) result.isKillSwitch = isKillSwitch;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  FeatureFlagItem._();

  factory FeatureFlagItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeatureFlagItem()..mergeFromBuffer(data, registry);
  factory FeatureFlagItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeatureFlagItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeatureFlagItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: FeatureFlagItem.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'flagId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'flagKey')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'status')
    ..aI(6, _omitFieldNames ? '' : 'percentage')
    ..aOB(7, _omitFieldNames ? '' : 'isKillSwitch')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeatureFlagItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeatureFlagItem copyWith(void Function(FeatureFlagItem) updates) =>
      super.copyWith((message) => updates(message as FeatureFlagItem))
          as FeatureFlagItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FeatureFlagItem() / FeatureFlagItem.new instead')
  static FeatureFlagItem create() => FeatureFlagItem._();
  static $pb.GeneratedMessage $_createMessage() => FeatureFlagItem._();
  @$core.override
  FeatureFlagItem createEmptyInstance() => FeatureFlagItem._();
  @$core.pragma('dart2js:noInline')
  static FeatureFlagItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeatureFlagItem>(
          FeatureFlagItem.$_createMessage);
  static FeatureFlagItem? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get flagId => $_getN(0);
  @$pb.TagNumber(1)
  set flagId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFlagId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFlagId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureFlagId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get flagKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set flagKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFlagKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlagKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get status => $_getSZ(4);
  @$pb.TagNumber(5)
  set status($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get percentage => $_getIZ(5);
  @$pb.TagNumber(6)
  set percentage($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPercentage() => $_has(5);
  @$pb.TagNumber(6)
  void clearPercentage() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isKillSwitch => $_getBF(6);
  @$pb.TagNumber(7)
  set isKillSwitch($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsKillSwitch() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsKillSwitch() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureUpdatedAt() => $_ensure(7);
}

/// Request for SystemConfigService/GetDashboard.
class GetDashboardRequest extends $pb.GeneratedMessage {
  factory GetDashboardRequest() => GetDashboardRequest._();

  GetDashboardRequest._();

  factory GetDashboardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDashboardRequest()..mergeFromBuffer(data, registry);
  factory GetDashboardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDashboardRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetDashboardRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardRequest copyWith(void Function(GetDashboardRequest) updates) =>
      super.copyWith((message) => updates(message as GetDashboardRequest))
          as GetDashboardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetDashboardRequest() / GetDashboardRequest.new instead')
  static GetDashboardRequest create() => GetDashboardRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetDashboardRequest._();
  @$core.override
  GetDashboardRequest createEmptyInstance() => GetDashboardRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDashboardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardRequest>(
          GetDashboardRequest.$_createMessage);
  static GetDashboardRequest? _defaultInstance;
}

/// Response for SystemConfigService/GetDashboard.
class GetDashboardResponse extends $pb.GeneratedMessage {
  factory GetDashboardResponse({
    $core.bool? maintenanceMode,
    $core.int? activeKillSwitchesCount,
    $core.int? pendingModerationCasesCount,
    $core.int? activeImpersonationSessionsCount,
    $core.int? auditLogEntriesCount,
    $2.Timestamp? generatedAt,
  }) {
    final result = GetDashboardResponse._();
    if (maintenanceMode != null) result.maintenanceMode = maintenanceMode;
    if (activeKillSwitchesCount != null)
      result.activeKillSwitchesCount = activeKillSwitchesCount;
    if (pendingModerationCasesCount != null)
      result.pendingModerationCasesCount = pendingModerationCasesCount;
    if (activeImpersonationSessionsCount != null)
      result.activeImpersonationSessionsCount =
          activeImpersonationSessionsCount;
    if (auditLogEntriesCount != null)
      result.auditLogEntriesCount = auditLogEntriesCount;
    if (generatedAt != null) result.generatedAt = generatedAt;
    return result;
  }

  GetDashboardResponse._();

  factory GetDashboardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDashboardResponse()..mergeFromBuffer(data, registry);
  factory GetDashboardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDashboardResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetDashboardResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'maintenanceMode')
    ..aI(2, _omitFieldNames ? '' : 'activeKillSwitchesCount')
    ..aI(3, _omitFieldNames ? '' : 'pendingModerationCasesCount')
    ..aI(4, _omitFieldNames ? '' : 'activeImpersonationSessionsCount')
    ..aI(5, _omitFieldNames ? '' : 'auditLogEntriesCount')
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'generatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardResponse copyWith(void Function(GetDashboardResponse) updates) =>
      super.copyWith((message) => updates(message as GetDashboardResponse))
          as GetDashboardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDashboardResponse() / GetDashboardResponse.new instead')
  static GetDashboardResponse create() => GetDashboardResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetDashboardResponse._();
  @$core.override
  GetDashboardResponse createEmptyInstance() => GetDashboardResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDashboardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardResponse>(
          GetDashboardResponse.$_createMessage);
  static GetDashboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get maintenanceMode => $_getBF(0);
  @$pb.TagNumber(1)
  set maintenanceMode($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaintenanceMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaintenanceMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get activeKillSwitchesCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set activeKillSwitchesCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveKillSwitchesCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveKillSwitchesCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pendingModerationCasesCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set pendingModerationCasesCount($core.int value) =>
      $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPendingModerationCasesCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPendingModerationCasesCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get activeImpersonationSessionsCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set activeImpersonationSessionsCount($core.int value) =>
      $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActiveImpersonationSessionsCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearActiveImpersonationSessionsCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get auditLogEntriesCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set auditLogEntriesCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAuditLogEntriesCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuditLogEntriesCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get generatedAt => $_getN(5);
  @$pb.TagNumber(6)
  set generatedAt($2.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGeneratedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearGeneratedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureGeneratedAt() => $_ensure(5);
}

/// Request for SystemConfigService/ToggleFlag.
class ToggleFlagRequest extends $pb.GeneratedMessage {
  factory ToggleFlagRequest({
    $core.String? flagKey,
    $core.String? status,
    $core.int? percentage,
    $core.bool? isKillSwitch,
    $core.String? reason,
    $core.String? idempotencyKey,
  }) {
    final result = ToggleFlagRequest._();
    if (flagKey != null) result.flagKey = flagKey;
    if (status != null) result.status = status;
    if (percentage != null) result.percentage = percentage;
    if (isKillSwitch != null) result.isKillSwitch = isKillSwitch;
    if (reason != null) result.reason = reason;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  ToggleFlagRequest._();

  factory ToggleFlagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleFlagRequest()..mergeFromBuffer(data, registry);
  factory ToggleFlagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleFlagRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleFlagRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ToggleFlagRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'flagKey')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aI(3, _omitFieldNames ? '' : 'percentage')
    ..aOB(4, _omitFieldNames ? '' : 'isKillSwitch')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOS(6, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFlagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFlagRequest copyWith(void Function(ToggleFlagRequest) updates) =>
      super.copyWith((message) => updates(message as ToggleFlagRequest))
          as ToggleFlagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ToggleFlagRequest() / ToggleFlagRequest.new instead')
  static ToggleFlagRequest create() => ToggleFlagRequest._();
  static $pb.GeneratedMessage $_createMessage() => ToggleFlagRequest._();
  @$core.override
  ToggleFlagRequest createEmptyInstance() => ToggleFlagRequest._();
  @$core.pragma('dart2js:noInline')
  static ToggleFlagRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToggleFlagRequest>(
          ToggleFlagRequest.$_createMessage);
  static ToggleFlagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get flagKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set flagKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFlagKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearFlagKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get percentage => $_getIZ(2);
  @$pb.TagNumber(3)
  set percentage($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPercentage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPercentage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isKillSwitch => $_getBF(3);
  @$pb.TagNumber(4)
  set isKillSwitch($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsKillSwitch() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsKillSwitch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get idempotencyKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set idempotencyKey($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdempotencyKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdempotencyKey() => $_clearField(6);
}

/// Response for SystemConfigService/ToggleFlag.
class ToggleFlagResponse extends $pb.GeneratedMessage {
  factory ToggleFlagResponse({
    FeatureFlagItem? flag,
    $1.UUID? auditLogId,
    $core.bool? replayed,
  }) {
    final result = ToggleFlagResponse._();
    if (flag != null) result.flag = flag;
    if (auditLogId != null) result.auditLogId = auditLogId;
    if (replayed != null) result.replayed = replayed;
    return result;
  }

  ToggleFlagResponse._();

  factory ToggleFlagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleFlagResponse()..mergeFromBuffer(data, registry);
  factory ToggleFlagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleFlagResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleFlagResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ToggleFlagResponse.$_createMessage)
    ..aOM<FeatureFlagItem>(1, _omitFieldNames ? '' : 'flag',
        subBuilder: FeatureFlagItem.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'auditLogId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'replayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFlagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFlagResponse copyWith(void Function(ToggleFlagResponse) updates) =>
      super.copyWith((message) => updates(message as ToggleFlagResponse))
          as ToggleFlagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ToggleFlagResponse() / ToggleFlagResponse.new instead')
  static ToggleFlagResponse create() => ToggleFlagResponse._();
  static $pb.GeneratedMessage $_createMessage() => ToggleFlagResponse._();
  @$core.override
  ToggleFlagResponse createEmptyInstance() => ToggleFlagResponse._();
  @$core.pragma('dart2js:noInline')
  static ToggleFlagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleFlagResponse>(
          ToggleFlagResponse.$_createMessage);
  static ToggleFlagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeatureFlagItem get flag => $_getN(0);
  @$pb.TagNumber(1)
  set flag(FeatureFlagItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFlag() => $_has(0);
  @$pb.TagNumber(1)
  void clearFlag() => $_clearField(1);
  @$pb.TagNumber(1)
  FeatureFlagItem ensureFlag() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get auditLogId => $_getN(1);
  @$pb.TagNumber(2)
  set auditLogId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuditLogId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuditLogId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureAuditLogId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get replayed => $_getBF(2);
  @$pb.TagNumber(3)
  set replayed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReplayed() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplayed() => $_clearField(3);
}

/// Request for SystemConfigService/ToggleMaintenance.
class ToggleMaintenanceRequest extends $pb.GeneratedMessage {
  factory ToggleMaintenanceRequest({
    $core.bool? enabled,
    $core.String? reason,
    $core.String? idempotencyKey,
  }) {
    final result = ToggleMaintenanceRequest._();
    if (enabled != null) result.enabled = enabled;
    if (reason != null) result.reason = reason;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  ToggleMaintenanceRequest._();

  factory ToggleMaintenanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleMaintenanceRequest()..mergeFromBuffer(data, registry);
  factory ToggleMaintenanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleMaintenanceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleMaintenanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ToggleMaintenanceRequest.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleMaintenanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleMaintenanceRequest copyWith(
          void Function(ToggleMaintenanceRequest) updates) =>
      super.copyWith((message) => updates(message as ToggleMaintenanceRequest))
          as ToggleMaintenanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ToggleMaintenanceRequest() / ToggleMaintenanceRequest.new instead')
  static ToggleMaintenanceRequest create() => ToggleMaintenanceRequest._();
  static $pb.GeneratedMessage $_createMessage() => ToggleMaintenanceRequest._();
  @$core.override
  ToggleMaintenanceRequest createEmptyInstance() =>
      ToggleMaintenanceRequest._();
  @$core.pragma('dart2js:noInline')
  static ToggleMaintenanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleMaintenanceRequest>(
          ToggleMaintenanceRequest.$_createMessage);
  static ToggleMaintenanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

/// Response for SystemConfigService/ToggleMaintenance.
class ToggleMaintenanceResponse extends $pb.GeneratedMessage {
  factory ToggleMaintenanceResponse({
    $core.bool? maintenanceMode,
    $1.UUID? auditLogId,
    $core.bool? replayed,
    $2.Timestamp? updatedAt,
  }) {
    final result = ToggleMaintenanceResponse._();
    if (maintenanceMode != null) result.maintenanceMode = maintenanceMode;
    if (auditLogId != null) result.auditLogId = auditLogId;
    if (replayed != null) result.replayed = replayed;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ToggleMaintenanceResponse._();

  factory ToggleMaintenanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleMaintenanceResponse()..mergeFromBuffer(data, registry);
  factory ToggleMaintenanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleMaintenanceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleMaintenanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ToggleMaintenanceResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'maintenanceMode')
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'auditLogId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'replayed')
    ..aOM<$2.Timestamp>(4, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleMaintenanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleMaintenanceResponse copyWith(
          void Function(ToggleMaintenanceResponse) updates) =>
      super.copyWith((message) => updates(message as ToggleMaintenanceResponse))
          as ToggleMaintenanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ToggleMaintenanceResponse() / ToggleMaintenanceResponse.new instead')
  static ToggleMaintenanceResponse create() => ToggleMaintenanceResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ToggleMaintenanceResponse._();
  @$core.override
  ToggleMaintenanceResponse createEmptyInstance() =>
      ToggleMaintenanceResponse._();
  @$core.pragma('dart2js:noInline')
  static ToggleMaintenanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleMaintenanceResponse>(
          ToggleMaintenanceResponse.$_createMessage);
  static ToggleMaintenanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get maintenanceMode => $_getBF(0);
  @$pb.TagNumber(1)
  set maintenanceMode($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaintenanceMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaintenanceMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.UUID get auditLogId => $_getN(1);
  @$pb.TagNumber(2)
  set auditLogId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuditLogId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuditLogId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureAuditLogId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get replayed => $_getBF(2);
  @$pb.TagNumber(3)
  set replayed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReplayed() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplayed() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Timestamp get updatedAt => $_getN(3);
  @$pb.TagNumber(4)
  set updatedAt($2.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Timestamp ensureUpdatedAt() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

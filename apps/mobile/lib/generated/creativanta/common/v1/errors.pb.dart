// This is a generated file - do not edit.
//
// Generated from creativanta/common/v1/errors.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'types.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Field-level validation or domain error entry.
/// Validation belongs to application code:
/// - field: required dot-delimited field path, bounds 1..255 chars.
/// - reason: required human-readable or machine-parsable field failure reason, bounds 1..500 chars.
class FieldError extends $pb.GeneratedMessage {
  factory FieldError({
    $core.String? field_1,
    $core.String? reason,
  }) {
    final result = FieldError._();
    if (field_1 != null) result.field_1 = field_1;
    if (reason != null) result.reason = reason;
    return result;
  }

  FieldError._();

  factory FieldError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FieldError()..mergeFromBuffer(data, registry);
  factory FieldError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FieldError()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FieldError',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.common.v1'),
      createEmptyInstance: FieldError.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldError copyWith(void Function(FieldError) updates) =>
      super.copyWith((message) => updates(message as FieldError)) as FieldError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FieldError() / FieldError.new instead')
  static FieldError create() => FieldError._();
  static $pb.GeneratedMessage $_createMessage() => FieldError._();
  @$core.override
  FieldError createEmptyInstance() => FieldError._();
  @$core.pragma('dart2js:noInline')
  static FieldError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FieldError>(FieldError.$_createMessage);
  static FieldError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// Canonical wire error detail payload.
/// HTTP/gRPC status code mappings and error codes are defined canonically in docs/04_contracts/error_catalog.md.
/// Do not invent error codes in proto definitions.
/// Validation belongs to application code:
/// - code: required canonical error code from docs/04_contracts/error_catalog.md, bounds 1..128 chars.
/// - message: required safe human-readable summary, bounds 1..2000 chars.
/// - correlation_id: required request correlation UUID.
/// - field_errors: optional list of field-level errors, bounds 0..100 items.
/// - retry_after_ms: optional non-negative backoff duration in milliseconds, bounds >= 0.
/// - fallback_action: optional client recovery hint from error_catalog.md, bounds 0..128 chars.
class ErrorDetail extends $pb.GeneratedMessage {
  factory ErrorDetail({
    $core.String? code,
    $core.String? message,
    $0.UUID? correlationId,
    $core.Iterable<FieldError>? fieldErrors,
    $fixnum.Int64? retryAfterMs,
    $core.String? fallbackAction,
  }) {
    final result = ErrorDetail._();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (correlationId != null) result.correlationId = correlationId;
    if (fieldErrors != null) result.fieldErrors.addAll(fieldErrors);
    if (retryAfterMs != null) result.retryAfterMs = retryAfterMs;
    if (fallbackAction != null) result.fallbackAction = fallbackAction;
    return result;
  }

  ErrorDetail._();

  factory ErrorDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ErrorDetail()..mergeFromBuffer(data, registry);
  factory ErrorDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ErrorDetail()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorDetail',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.common.v1'),
      createEmptyInstance: ErrorDetail.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<$0.UUID>(3, _omitFieldNames ? '' : 'correlationId',
        subBuilder: $0.UUID.$_createMessage)
    ..pPM<FieldError>(4, _omitFieldNames ? '' : 'fieldErrors',
        subBuilder: FieldError.$_createMessage)
    ..aInt64(5, _omitFieldNames ? '' : 'retryAfterMs')
    ..aOS(6, _omitFieldNames ? '' : 'fallbackAction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorDetail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorDetail copyWith(void Function(ErrorDetail) updates) =>
      super.copyWith((message) => updates(message as ErrorDetail))
          as ErrorDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ErrorDetail() / ErrorDetail.new instead')
  static ErrorDetail create() => ErrorDetail._();
  static $pb.GeneratedMessage $_createMessage() => ErrorDetail._();
  @$core.override
  ErrorDetail createEmptyInstance() => ErrorDetail._();
  @$core.pragma('dart2js:noInline')
  static ErrorDetail getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ErrorDetail>(
          ErrorDetail.$_createMessage);
  static ErrorDetail? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.UUID get correlationId => $_getN(2);
  @$pb.TagNumber(3)
  set correlationId($0.UUID value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCorrelationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCorrelationId() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.UUID ensureCorrelationId() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<FieldError> get fieldErrors => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get retryAfterMs => $_getI64(4);
  @$pb.TagNumber(5)
  set retryAfterMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRetryAfterMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearRetryAfterMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fallbackAction => $_getSZ(5);
  @$pb.TagNumber(6)
  set fallbackAction($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFallbackAction() => $_has(5);
  @$pb.TagNumber(6)
  void clearFallbackAction() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/common/v1/types.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'types.pbenum.dart';

/// Canonical UUID wrapper.
/// Timestamps across all contracts MUST use google.protobuf.Timestamp directly.
/// Validation belongs to application code:
/// - value: required canonical RFC 9562 UUID string (including v7), length 36 chars.
class UUID extends $pb.GeneratedMessage {
  factory UUID({
    $core.String? value,
  }) {
    final result = UUID._();
    if (value != null) result.value = value;
    return result;
  }

  UUID._();

  factory UUID.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UUID()..mergeFromBuffer(data, registry);
  factory UUID.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UUID()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UUID',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.common.v1'),
      createEmptyInstance: UUID.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UUID clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UUID copyWith(void Function(UUID) updates) =>
      super.copyWith((message) => updates(message as UUID)) as UUID;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UUID() / UUID.new instead')
  static UUID create() => UUID._();
  static $pb.GeneratedMessage $_createMessage() => UUID._();
  @$core.override
  UUID createEmptyInstance() => UUID._();
  @$core.pragma('dart2js:noInline')
  static UUID getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UUID>(UUID.$_createMessage);
  static UUID? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

/// Monetary amount using exact decimal string representation.
/// Floating-point representations are strictly forbidden.
/// Validation belongs to application code:
/// - amount: canonical base-10 decimal string, precision <=18, scale <=6, no exponent/NaN/Infinity; negative only when permitted by owning command.
/// - currency: required uppercase ISO 4217 3-letter currency code (e.g., "VND", "USD"), length 3 chars.
class Money extends $pb.GeneratedMessage {
  factory Money({
    $core.String? amount,
    $core.String? currency,
  }) {
    final result = Money._();
    if (amount != null) result.amount = amount;
    if (currency != null) result.currency = currency;
    return result;
  }

  Money._();

  factory Money.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Money()..mergeFromBuffer(data, registry);
  factory Money.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Money()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Money',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.common.v1'),
      createEmptyInstance: Money.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'amount')
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Money clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Money copyWith(void Function(Money) updates) =>
      super.copyWith((message) => updates(message as Money)) as Money;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Money() / Money.new instead')
  static Money create() => Money._();
  static $pb.GeneratedMessage $_createMessage() => Money._();
  @$core.override
  Money createEmptyInstance() => Money._();
  @$core.pragma('dart2js:noInline')
  static Money getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Money>(Money.$_createMessage);
  static Money? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get amount => $_getSZ(0);
  @$pb.TagNumber(1)
  set amount($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);
}

/// Cursor-based pagination parameters.
/// Validation belongs to application code:
/// - page_size: bounds 1..100, default 20 when omitted or 0.
/// - page_token: optional opaque cursor string, length 0..512 chars.
class Pagination extends $pb.GeneratedMessage {
  factory Pagination({
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = Pagination._();
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  Pagination._();

  factory Pagination.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pagination()..mergeFromBuffer(data, registry);
  factory Pagination.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pagination()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pagination',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.common.v1'),
      createEmptyInstance: Pagination.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pagination clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pagination copyWith(void Function(Pagination) updates) =>
      super.copyWith((message) => updates(message as Pagination)) as Pagination;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Pagination() / Pagination.new instead')
  static Pagination create() => Pagination._();
  static $pb.GeneratedMessage $_createMessage() => Pagination._();
  @$core.override
  Pagination createEmptyInstance() => Pagination._();
  @$core.pragma('dart2js:noInline')
  static Pagination getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Pagination>(Pagination.$_createMessage);
  static Pagination? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageToken() => $_clearField(2);
}

/// Cursor-based pagination metadata returned in list responses.
/// Validation belongs to application code:
/// - next_page_token: opaque cursor string (0..512 chars); empty when has_more is false.
/// - total_count: bounds >= 0.
/// - has_more: true if additional records exist after this page.
class PaginatedResponse extends $pb.GeneratedMessage {
  factory PaginatedResponse({
    $core.String? nextPageToken,
    $fixnum.Int64? totalCount,
    $core.bool? hasMore,
  }) {
    final result = PaginatedResponse._();
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  PaginatedResponse._();

  factory PaginatedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginatedResponse()..mergeFromBuffer(data, registry);
  factory PaginatedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginatedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaginatedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.common.v1'),
      createEmptyInstance: PaginatedResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'nextPageToken')
    ..aInt64(2, _omitFieldNames ? '' : 'totalCount')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginatedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginatedResponse copyWith(void Function(PaginatedResponse) updates) =>
      super.copyWith((message) => updates(message as PaginatedResponse))
          as PaginatedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaginatedResponse() / PaginatedResponse.new instead')
  static PaginatedResponse create() => PaginatedResponse._();
  static $pb.GeneratedMessage $_createMessage() => PaginatedResponse._();
  @$core.override
  PaginatedResponse createEmptyInstance() => PaginatedResponse._();
  @$core.pragma('dart2js:noInline')
  static PaginatedResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaginatedResponse>(
          PaginatedResponse.$_createMessage);
  static PaginatedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nextPageToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set nextPageToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNextPageToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearNextPageToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalCount => $_getI64(1);
  @$pb.TagNumber(2)
  set totalCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);
}

/// Standard envelope context for mutating commands.
/// Validation belongs to application code:
/// - idempotency_key: required non-empty ASCII string, bounds 1..255 chars.
/// - expected_updated_at: optional optimistic concurrency control timestamp.
/// - reason: optional human-readable audit reason, bounds 1..2000 chars when set (required for privileged/override commands).
/// - workspace_id: optional compatibility tenant UUID; if supplied must equal the authenticated selected workspace (never an authorization source).
class CommandContext extends $pb.GeneratedMessage {
  factory CommandContext({
    $core.String? idempotencyKey,
    $0.Timestamp? expectedUpdatedAt,
    $core.String? reason,
    UUID? workspaceId,
  }) {
    final result = CommandContext._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (expectedUpdatedAt != null) result.expectedUpdatedAt = expectedUpdatedAt;
    if (reason != null) result.reason = reason;
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  CommandContext._();

  factory CommandContext.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommandContext()..mergeFromBuffer(data, registry);
  factory CommandContext.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommandContext()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommandContext',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.common.v1'),
      createEmptyInstance: CommandContext.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'expectedUpdatedAt',
        subBuilder: $0.Timestamp.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOM<UUID>(4, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandContext clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandContext copyWith(void Function(CommandContext) updates) =>
      super.copyWith((message) => updates(message as CommandContext))
          as CommandContext;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CommandContext() / CommandContext.new instead')
  static CommandContext create() => CommandContext._();
  static $pb.GeneratedMessage $_createMessage() => CommandContext._();
  @$core.override
  CommandContext createEmptyInstance() => CommandContext._();
  @$core.pragma('dart2js:noInline')
  static CommandContext getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommandContext>(
          CommandContext.$_createMessage);
  static CommandContext? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get expectedUpdatedAt => $_getN(1);
  @$pb.TagNumber(2)
  set expectedUpdatedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedUpdatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedUpdatedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureExpectedUpdatedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  UUID get workspaceId => $_getN(3);
  @$pb.TagNumber(4)
  set workspaceId(UUID value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkspaceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkspaceId() => $_clearField(4);
  @$pb.TagNumber(4)
  UUID ensureWorkspaceId() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

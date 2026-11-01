// This is a generated file - do not edit.
//
// Generated from creativanta/transport/test/v1/fixture.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../common/v1/types.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Unary echo request.
/// Validation belongs to application code:
/// - text: required non-empty string, bounds 1..1000 chars.
/// - workspace_id: required canonical UUID string, length 36 chars.
class EchoRequest extends $pb.GeneratedMessage {
  factory EchoRequest({
    $core.String? text,
    $core.String? workspaceId,
  }) {
    final result = EchoRequest._();
    if (text != null) result.text = text;
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  EchoRequest._();

  factory EchoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EchoRequest()..mergeFromBuffer(data, registry);
  factory EchoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EchoRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EchoRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.transport.test.v1'),
      createEmptyInstance: EchoRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EchoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EchoRequest copyWith(void Function(EchoRequest) updates) =>
      super.copyWith((message) => updates(message as EchoRequest))
          as EchoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EchoRequest() / EchoRequest.new instead')
  static EchoRequest create() => EchoRequest._();
  static $pb.GeneratedMessage $_createMessage() => EchoRequest._();
  @$core.override
  EchoRequest createEmptyInstance() => EchoRequest._();
  @$core.pragma('dart2js:noInline')
  static EchoRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EchoRequest>(
          EchoRequest.$_createMessage);
  static EchoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
}

/// Unary echo response.
class EchoResponse extends $pb.GeneratedMessage {
  factory EchoResponse({
    $core.String? text,
    $core.String? workspaceId,
  }) {
    final result = EchoResponse._();
    if (text != null) result.text = text;
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  EchoResponse._();

  factory EchoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EchoResponse()..mergeFromBuffer(data, registry);
  factory EchoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EchoResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EchoResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.transport.test.v1'),
      createEmptyInstance: EchoResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EchoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EchoResponse copyWith(void Function(EchoResponse) updates) =>
      super.copyWith((message) => updates(message as EchoResponse))
          as EchoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EchoResponse() / EchoResponse.new instead')
  static EchoResponse create() => EchoResponse._();
  static $pb.GeneratedMessage $_createMessage() => EchoResponse._();
  @$core.override
  EchoResponse createEmptyInstance() => EchoResponse._();
  @$core.pragma('dart2js:noInline')
  static EchoResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EchoResponse>(
          EchoResponse.$_createMessage);
  static EchoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
}

/// Mutating command fixture request.
/// Validation belongs to application code:
/// - context: required CommandContext with valid workspace_id and idempotency_key (1..255 chars).
/// - payload: required string payload, bounds 1..4096 chars.
class ExecuteRequest extends $pb.GeneratedMessage {
  factory ExecuteRequest({
    $1.CommandContext? context,
    $core.String? payload,
  }) {
    final result = ExecuteRequest._();
    if (context != null) result.context = context;
    if (payload != null) result.payload = payload;
    return result;
  }

  ExecuteRequest._();

  factory ExecuteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteRequest()..mergeFromBuffer(data, registry);
  factory ExecuteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.transport.test.v1'),
      createEmptyInstance: ExecuteRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'payload')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteRequest copyWith(void Function(ExecuteRequest) updates) =>
      super.copyWith((message) => updates(message as ExecuteRequest))
          as ExecuteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExecuteRequest() / ExecuteRequest.new instead')
  static ExecuteRequest create() => ExecuteRequest._();
  static $pb.GeneratedMessage $_createMessage() => ExecuteRequest._();
  @$core.override
  ExecuteRequest createEmptyInstance() => ExecuteRequest._();
  @$core.pragma('dart2js:noInline')
  static ExecuteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecuteRequest>(
          ExecuteRequest.$_createMessage);
  static ExecuteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get payload => $_getSZ(1);
  @$pb.TagNumber(2)
  set payload($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPayload() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayload() => $_clearField(2);
}

/// Mutating command fixture response.
class ExecuteResponse extends $pb.GeneratedMessage {
  factory ExecuteResponse({
    $core.String? payload,
    $core.bool? replayed,
  }) {
    final result = ExecuteResponse._();
    if (payload != null) result.payload = payload;
    if (replayed != null) result.replayed = replayed;
    return result;
  }

  ExecuteResponse._();

  factory ExecuteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteResponse()..mergeFromBuffer(data, registry);
  factory ExecuteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.transport.test.v1'),
      createEmptyInstance: ExecuteResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'payload')
    ..aOB(2, _omitFieldNames ? '' : 'replayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteResponse copyWith(void Function(ExecuteResponse) updates) =>
      super.copyWith((message) => updates(message as ExecuteResponse))
          as ExecuteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExecuteResponse() / ExecuteResponse.new instead')
  static ExecuteResponse create() => ExecuteResponse._();
  static $pb.GeneratedMessage $_createMessage() => ExecuteResponse._();
  @$core.override
  ExecuteResponse createEmptyInstance() => ExecuteResponse._();
  @$core.pragma('dart2js:noInline')
  static ExecuteResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecuteResponse>(
          ExecuteResponse.$_createMessage);
  static ExecuteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get payload => $_getSZ(0);
  @$pb.TagNumber(1)
  set payload($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get replayed => $_getBF(1);
  @$pb.TagNumber(2)
  set replayed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReplayed() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplayed() => $_clearField(2);
}

/// Paginated list fixture request.
/// Validation belongs to application code:
/// - pagination: optional Pagination (page_size bounds 1..100, default 20).
/// - workspace_id: required canonical UUID string, length 36 chars.
/// - filter: optional filter expression, bounds 0..255 chars.
/// - sort: optional sort expression, bounds 0..128 chars.
class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $1.Pagination? pagination,
    $core.String? workspaceId,
    $core.String? filter,
    $core.String? sort,
  }) {
    final result = ListRequest._();
    if (pagination != null) result.pagination = pagination;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (filter != null) result.filter = filter;
    if (sort != null) result.sort = sort;
    return result;
  }

  ListRequest._();

  factory ListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRequest()..mergeFromBuffer(data, registry);
  factory ListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.transport.test.v1'),
      createEmptyInstance: ListRequest.$_createMessage)
    ..aOM<$1.Pagination>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'filter')
    ..aOS(4, _omitFieldNames ? '' : 'sort')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest copyWith(void Function(ListRequest) updates) =>
      super.copyWith((message) => updates(message as ListRequest))
          as ListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListRequest() / ListRequest.new instead')
  static ListRequest create() => ListRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListRequest._();
  @$core.override
  ListRequest createEmptyInstance() => ListRequest._();
  @$core.pragma('dart2js:noInline')
  static ListRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRequest>(
          ListRequest.$_createMessage);
  static ListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Pagination get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($1.Pagination value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Pagination ensurePagination() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get filter => $_getSZ(2);
  @$pb.TagNumber(3)
  set filter($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sort => $_getSZ(3);
  @$pb.TagNumber(4)
  set sort($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSort() => $_has(3);
  @$pb.TagNumber(4)
  void clearSort() => $_clearField(4);
}

/// Paginated list fixture response.
class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<$core.String>? items,
    $1.PaginatedResponse? pagination,
  }) {
    final result = ListResponse._();
    if (items != null) result.items.addAll(items);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListResponse._();

  factory ListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListResponse()..mergeFromBuffer(data, registry);
  factory ListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.transport.test.v1'),
      createEmptyInstance: ListResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'items')
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse copyWith(void Function(ListResponse) updates) =>
      super.copyWith((message) => updates(message as ListResponse))
          as ListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListResponse() / ListResponse.new instead')
  static ListResponse create() => ListResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListResponse._();
  @$core.override
  ListResponse createEmptyInstance() => ListResponse._();
  @$core.pragma('dart2js:noInline')
  static ListResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListResponse>(
          ListResponse.$_createMessage);
  static ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get items => $_getList(0);

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

/// Server-streaming watch fixture request.
/// Validation belongs to application code:
/// - max_events: bounds 1..100.
class WatchRequest extends $pb.GeneratedMessage {
  factory WatchRequest({
    $core.int? maxEvents,
  }) {
    final result = WatchRequest._();
    if (maxEvents != null) result.maxEvents = maxEvents;
    return result;
  }

  WatchRequest._();

  factory WatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchRequest()..mergeFromBuffer(data, registry);
  factory WatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.transport.test.v1'),
      createEmptyInstance: WatchRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'maxEvents')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRequest copyWith(void Function(WatchRequest) updates) =>
      super.copyWith((message) => updates(message as WatchRequest))
          as WatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WatchRequest() / WatchRequest.new instead')
  static WatchRequest create() => WatchRequest._();
  static $pb.GeneratedMessage $_createMessage() => WatchRequest._();
  @$core.override
  WatchRequest createEmptyInstance() => WatchRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchRequest>(
          WatchRequest.$_createMessage);
  static WatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get maxEvents => $_getIZ(0);
  @$pb.TagNumber(1)
  set maxEvents($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxEvents() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxEvents() => $_clearField(1);
}

/// Server-streaming watch fixture event.
/// Validation belongs to application code:
/// - sequence: 1-based event sequence number, bounds >= 1.
/// - message: non-empty event payload, bounds 1..1000 chars.
class WatchResponse extends $pb.GeneratedMessage {
  factory WatchResponse({
    $core.int? sequence,
    $core.String? message,
  }) {
    final result = WatchResponse._();
    if (sequence != null) result.sequence = sequence;
    if (message != null) result.message = message;
    return result;
  }

  WatchResponse._();

  factory WatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchResponse()..mergeFromBuffer(data, registry);
  factory WatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.transport.test.v1'),
      createEmptyInstance: WatchResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'sequence')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchResponse copyWith(void Function(WatchResponse) updates) =>
      super.copyWith((message) => updates(message as WatchResponse))
          as WatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WatchResponse() / WatchResponse.new instead')
  static WatchResponse create() => WatchResponse._();
  static $pb.GeneratedMessage $_createMessage() => WatchResponse._();
  @$core.override
  WatchResponse createEmptyInstance() => WatchResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchResponse>(
          WatchResponse.$_createMessage);
  static WatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sequence => $_getIZ(0);
  @$pb.TagNumber(1)
  set sequence($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

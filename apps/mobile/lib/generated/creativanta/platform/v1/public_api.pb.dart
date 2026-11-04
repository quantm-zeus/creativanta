// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/public_api.proto.

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
    as $1;

import 'public_api.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'public_api.pbenum.dart';

class APIKey extends $pb.GeneratedMessage {
  factory APIKey({
    $core.String? apiKeyId,
    $core.String? workspaceId,
    $core.String? keyPrefix,
    $core.String? name,
    $core.Iterable<$core.String>? scopes,
    APIKeyStatus? status,
    $core.String? logicalKeyId,
    $core.String? replacedByKeyId,
    $1.Timestamp? rotationGraceEndsAt,
    $1.Timestamp? lastUsedAt,
    $fixnum.Int64? requestCount,
    $core.int? rateLimitOverride,
    $1.Timestamp? expiresAt,
    $core.String? createdBy,
    $core.String? suspendedReason,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? secretKey,
  }) {
    final result = APIKey._();
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (keyPrefix != null) result.keyPrefix = keyPrefix;
    if (name != null) result.name = name;
    if (scopes != null) result.scopes.addAll(scopes);
    if (status != null) result.status = status;
    if (logicalKeyId != null) result.logicalKeyId = logicalKeyId;
    if (replacedByKeyId != null) result.replacedByKeyId = replacedByKeyId;
    if (rotationGraceEndsAt != null)
      result.rotationGraceEndsAt = rotationGraceEndsAt;
    if (lastUsedAt != null) result.lastUsedAt = lastUsedAt;
    if (requestCount != null) result.requestCount = requestCount;
    if (rateLimitOverride != null) result.rateLimitOverride = rateLimitOverride;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (suspendedReason != null) result.suspendedReason = suspendedReason;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (secretKey != null) result.secretKey = secretKey;
    return result;
  }

  APIKey._();

  factory APIKey.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      APIKey()..mergeFromBuffer(data, registry);
  factory APIKey.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      APIKey()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'APIKey',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: APIKey.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'apiKeyId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'keyPrefix')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..pPS(5, _omitFieldNames ? '' : 'scopes')
    ..aE<APIKeyStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: APIKeyStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'logicalKeyId')
    ..aOS(8, _omitFieldNames ? '' : 'replacedByKeyId')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'rotationGraceEndsAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'lastUsedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aInt64(11, _omitFieldNames ? '' : 'requestCount')
    ..aI(12, _omitFieldNames ? '' : 'rateLimitOverride')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(14, _omitFieldNames ? '' : 'createdBy')
    ..aOS(15, _omitFieldNames ? '' : 'suspendedReason')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(18, _omitFieldNames ? '' : 'secretKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  APIKey clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  APIKey copyWith(void Function(APIKey) updates) =>
      super.copyWith((message) => updates(message as APIKey)) as APIKey;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use APIKey() / APIKey.new instead')
  static APIKey create() => APIKey._();
  static $pb.GeneratedMessage $_createMessage() => APIKey._();
  @$core.override
  APIKey createEmptyInstance() => APIKey._();
  @$core.pragma('dart2js:noInline')
  static APIKey getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<APIKey>(APIKey.$_createMessage);
  static APIKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get apiKeyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set apiKeyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApiKeyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApiKeyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get keyPrefix => $_getSZ(2);
  @$pb.TagNumber(3)
  set keyPrefix($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKeyPrefix() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyPrefix() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get scopes => $_getList(4);

  @$pb.TagNumber(6)
  APIKeyStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(APIKeyStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get logicalKeyId => $_getSZ(6);
  @$pb.TagNumber(7)
  set logicalKeyId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLogicalKeyId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLogicalKeyId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get replacedByKeyId => $_getSZ(7);
  @$pb.TagNumber(8)
  set replacedByKeyId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReplacedByKeyId() => $_has(7);
  @$pb.TagNumber(8)
  void clearReplacedByKeyId() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get rotationGraceEndsAt => $_getN(8);
  @$pb.TagNumber(9)
  set rotationGraceEndsAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRotationGraceEndsAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearRotationGraceEndsAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureRotationGraceEndsAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.Timestamp get lastUsedAt => $_getN(9);
  @$pb.TagNumber(10)
  set lastUsedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLastUsedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearLastUsedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureLastUsedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get requestCount => $_getI64(10);
  @$pb.TagNumber(11)
  set requestCount($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRequestCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearRequestCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get rateLimitOverride => $_getIZ(11);
  @$pb.TagNumber(12)
  set rateLimitOverride($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRateLimitOverride() => $_has(11);
  @$pb.TagNumber(12)
  void clearRateLimitOverride() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get expiresAt => $_getN(12);
  @$pb.TagNumber(13)
  set expiresAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasExpiresAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearExpiresAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureExpiresAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get createdBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set createdBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get suspendedReason => $_getSZ(14);
  @$pb.TagNumber(15)
  set suspendedReason($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSuspendedReason() => $_has(14);
  @$pb.TagNumber(15)
  void clearSuspendedReason() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.Timestamp get createdAt => $_getN(15);
  @$pb.TagNumber(16)
  set createdAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureCreatedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $1.Timestamp get updatedAt => $_getN(16);
  @$pb.TagNumber(17)
  set updatedAt($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasUpdatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearUpdatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureUpdatedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get secretKey => $_getSZ(17);
  @$pb.TagNumber(18)
  set secretKey($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasSecretKey() => $_has(17);
  @$pb.TagNumber(18)
  void clearSecretKey() => $_clearField(18);
}

class CreateRequest extends $pb.GeneratedMessage {
  factory CreateRequest({
    $core.String? workspaceId,
    $core.String? name,
    $core.Iterable<$core.String>? scopes,
    $core.int? rateLimitOverride,
    $core.int? expiryDays,
  }) {
    final result = CreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (name != null) result.name = name;
    if (scopes != null) result.scopes.addAll(scopes);
    if (rateLimitOverride != null) result.rateLimitOverride = rateLimitOverride;
    if (expiryDays != null) result.expiryDays = expiryDays;
    return result;
  }

  CreateRequest._();

  factory CreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRequest()..mergeFromBuffer(data, registry);
  factory CreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: CreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pPS(3, _omitFieldNames ? '' : 'scopes')
    ..aI(4, _omitFieldNames ? '' : 'rateLimitOverride')
    ..aI(5, _omitFieldNames ? '' : 'expiryDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRequest copyWith(void Function(CreateRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRequest))
          as CreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreateRequest() / CreateRequest.new instead')
  static CreateRequest create() => CreateRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateRequest._();
  @$core.override
  CreateRequest createEmptyInstance() => CreateRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRequest>(
          CreateRequest.$_createMessage);
  static CreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get scopes => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get rateLimitOverride => $_getIZ(3);
  @$pb.TagNumber(4)
  set rateLimitOverride($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRateLimitOverride() => $_has(3);
  @$pb.TagNumber(4)
  void clearRateLimitOverride() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get expiryDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set expiryDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiryDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiryDays() => $_clearField(5);
}

class CreateResponse extends $pb.GeneratedMessage {
  factory CreateResponse({
    APIKey? apiKey,
    $core.String? secretKey,
  }) {
    final result = CreateResponse._();
    if (apiKey != null) result.apiKey = apiKey;
    if (secretKey != null) result.secretKey = secretKey;
    return result;
  }

  CreateResponse._();

  factory CreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateResponse()..mergeFromBuffer(data, registry);
  factory CreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: CreateResponse.$_createMessage)
    ..aOM<APIKey>(1, _omitFieldNames ? '' : 'apiKey',
        subBuilder: APIKey.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'secretKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateResponse copyWith(void Function(CreateResponse) updates) =>
      super.copyWith((message) => updates(message as CreateResponse))
          as CreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreateResponse() / CreateResponse.new instead')
  static CreateResponse create() => CreateResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateResponse._();
  @$core.override
  CreateResponse createEmptyInstance() => CreateResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateResponse>(
          CreateResponse.$_createMessage);
  static CreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  APIKey get apiKey => $_getN(0);
  @$pb.TagNumber(1)
  set apiKey(APIKey value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasApiKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearApiKey() => $_clearField(1);
  @$pb.TagNumber(1)
  APIKey ensureApiKey() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get secretKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set secretKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSecretKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecretKey() => $_clearField(2);
}

class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $core.String? workspaceId,
    $core.int? pageSize,
    $core.String? pageToken,
    $core.String? statusFilter,
  }) {
    final result = ListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    if (statusFilter != null) result.statusFilter = statusFilter;
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
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..aOS(4, _omitFieldNames ? '' : 'statusFilter')
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
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pageToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get statusFilter => $_getSZ(3);
  @$pb.TagNumber(4)
  set statusFilter($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStatusFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatusFilter() => $_clearField(4);
}

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<APIKey>? apiKeys,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = ListResponse._();
    if (apiKeys != null) result.apiKeys.addAll(apiKeys);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
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
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListResponse.$_createMessage)
    ..pPM<APIKey>(1, _omitFieldNames ? '' : 'apiKeys',
        subBuilder: APIKey.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
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
  $pb.PbList<APIKey> get apiKeys => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class RevokeRequest extends $pb.GeneratedMessage {
  factory RevokeRequest({
    $core.String? workspaceId,
    $core.String? apiKeyId,
    $core.String? reason,
  }) {
    final result = RevokeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RevokeRequest._();

  factory RevokeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeRequest()..mergeFromBuffer(data, registry);
  factory RevokeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: RevokeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'apiKeyId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeRequest copyWith(void Function(RevokeRequest) updates) =>
      super.copyWith((message) => updates(message as RevokeRequest))
          as RevokeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RevokeRequest() / RevokeRequest.new instead')
  static RevokeRequest create() => RevokeRequest._();
  static $pb.GeneratedMessage $_createMessage() => RevokeRequest._();
  @$core.override
  RevokeRequest createEmptyInstance() => RevokeRequest._();
  @$core.pragma('dart2js:noInline')
  static RevokeRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RevokeRequest>(
          RevokeRequest.$_createMessage);
  static RevokeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get apiKeyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set apiKeyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApiKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApiKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RevokeResponse extends $pb.GeneratedMessage {
  factory RevokeResponse({
    APIKey? apiKey,
  }) {
    final result = RevokeResponse._();
    if (apiKey != null) result.apiKey = apiKey;
    return result;
  }

  RevokeResponse._();

  factory RevokeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeResponse()..mergeFromBuffer(data, registry);
  factory RevokeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevokeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: RevokeResponse.$_createMessage)
    ..aOM<APIKey>(1, _omitFieldNames ? '' : 'apiKey',
        subBuilder: APIKey.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeResponse copyWith(void Function(RevokeResponse) updates) =>
      super.copyWith((message) => updates(message as RevokeResponse))
          as RevokeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RevokeResponse() / RevokeResponse.new instead')
  static RevokeResponse create() => RevokeResponse._();
  static $pb.GeneratedMessage $_createMessage() => RevokeResponse._();
  @$core.override
  RevokeResponse createEmptyInstance() => RevokeResponse._();
  @$core.pragma('dart2js:noInline')
  static RevokeResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RevokeResponse>(
          RevokeResponse.$_createMessage);
  static RevokeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  APIKey get apiKey => $_getN(0);
  @$pb.TagNumber(1)
  set apiKey(APIKey value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasApiKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearApiKey() => $_clearField(1);
  @$pb.TagNumber(1)
  APIKey ensureApiKey() => $_ensure(0);
}

class RotateRequest extends $pb.GeneratedMessage {
  factory RotateRequest({
    $core.String? workspaceId,
    $core.String? apiKeyId,
  }) {
    final result = RotateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    return result;
  }

  RotateRequest._();

  factory RotateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RotateRequest()..mergeFromBuffer(data, registry);
  factory RotateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RotateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RotateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: RotateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'apiKeyId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RotateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RotateRequest copyWith(void Function(RotateRequest) updates) =>
      super.copyWith((message) => updates(message as RotateRequest))
          as RotateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RotateRequest() / RotateRequest.new instead')
  static RotateRequest create() => RotateRequest._();
  static $pb.GeneratedMessage $_createMessage() => RotateRequest._();
  @$core.override
  RotateRequest createEmptyInstance() => RotateRequest._();
  @$core.pragma('dart2js:noInline')
  static RotateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RotateRequest>(
          RotateRequest.$_createMessage);
  static RotateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get apiKeyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set apiKeyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApiKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApiKeyId() => $_clearField(2);
}

class RotateResponse extends $pb.GeneratedMessage {
  factory RotateResponse({
    APIKey? oldKey,
    APIKey? newKey,
    $core.String? newSecretKey,
    $1.Timestamp? graceEndsAt,
  }) {
    final result = RotateResponse._();
    if (oldKey != null) result.oldKey = oldKey;
    if (newKey != null) result.newKey = newKey;
    if (newSecretKey != null) result.newSecretKey = newSecretKey;
    if (graceEndsAt != null) result.graceEndsAt = graceEndsAt;
    return result;
  }

  RotateResponse._();

  factory RotateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RotateResponse()..mergeFromBuffer(data, registry);
  factory RotateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RotateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RotateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: RotateResponse.$_createMessage)
    ..aOM<APIKey>(1, _omitFieldNames ? '' : 'oldKey',
        subBuilder: APIKey.$_createMessage)
    ..aOM<APIKey>(2, _omitFieldNames ? '' : 'newKey',
        subBuilder: APIKey.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'newSecretKey')
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'graceEndsAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RotateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RotateResponse copyWith(void Function(RotateResponse) updates) =>
      super.copyWith((message) => updates(message as RotateResponse))
          as RotateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RotateResponse() / RotateResponse.new instead')
  static RotateResponse create() => RotateResponse._();
  static $pb.GeneratedMessage $_createMessage() => RotateResponse._();
  @$core.override
  RotateResponse createEmptyInstance() => RotateResponse._();
  @$core.pragma('dart2js:noInline')
  static RotateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RotateResponse>(
          RotateResponse.$_createMessage);
  static RotateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  APIKey get oldKey => $_getN(0);
  @$pb.TagNumber(1)
  set oldKey(APIKey value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOldKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearOldKey() => $_clearField(1);
  @$pb.TagNumber(1)
  APIKey ensureOldKey() => $_ensure(0);

  @$pb.TagNumber(2)
  APIKey get newKey => $_getN(1);
  @$pb.TagNumber(2)
  set newKey(APIKey value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNewKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewKey() => $_clearField(2);
  @$pb.TagNumber(2)
  APIKey ensureNewKey() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get newSecretKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set newSecretKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewSecretKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewSecretKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get graceEndsAt => $_getN(3);
  @$pb.TagNumber(4)
  set graceEndsAt($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasGraceEndsAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearGraceEndsAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureGraceEndsAt() => $_ensure(3);
}

class GetUsageRequest extends $pb.GeneratedMessage {
  factory GetUsageRequest({
    $core.String? workspaceId,
    $core.String? apiKeyId,
  }) {
    final result = GetUsageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    return result;
  }

  GetUsageRequest._();

  factory GetUsageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageRequest()..mergeFromBuffer(data, registry);
  factory GetUsageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetUsageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'apiKeyId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageRequest copyWith(void Function(GetUsageRequest) updates) =>
      super.copyWith((message) => updates(message as GetUsageRequest))
          as GetUsageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetUsageRequest() / GetUsageRequest.new instead')
  static GetUsageRequest create() => GetUsageRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetUsageRequest._();
  @$core.override
  GetUsageRequest createEmptyInstance() => GetUsageRequest._();
  @$core.pragma('dart2js:noInline')
  static GetUsageRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUsageRequest>(
          GetUsageRequest.$_createMessage);
  static GetUsageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get apiKeyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set apiKeyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApiKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApiKeyId() => $_clearField(2);
}

class GetUsageResponse extends $pb.GeneratedMessage {
  factory GetUsageResponse({
    $core.String? workspaceId,
    $core.String? apiKeyId,
    $fixnum.Int64? currentMonthRequests,
    $fixnum.Int64? monthlyQuota,
    $core.int? readRateLimitRpm,
    $core.int? writeRateLimitRpm,
    $core.double? billableAiCreditsUsed,
  }) {
    final result = GetUsageResponse._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    if (currentMonthRequests != null)
      result.currentMonthRequests = currentMonthRequests;
    if (monthlyQuota != null) result.monthlyQuota = monthlyQuota;
    if (readRateLimitRpm != null) result.readRateLimitRpm = readRateLimitRpm;
    if (writeRateLimitRpm != null) result.writeRateLimitRpm = writeRateLimitRpm;
    if (billableAiCreditsUsed != null)
      result.billableAiCreditsUsed = billableAiCreditsUsed;
    return result;
  }

  GetUsageResponse._();

  factory GetUsageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageResponse()..mergeFromBuffer(data, registry);
  factory GetUsageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetUsageResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'apiKeyId')
    ..aInt64(3, _omitFieldNames ? '' : 'currentMonthRequests')
    ..aInt64(4, _omitFieldNames ? '' : 'monthlyQuota')
    ..aI(5, _omitFieldNames ? '' : 'readRateLimitRpm')
    ..aI(6, _omitFieldNames ? '' : 'writeRateLimitRpm')
    ..aD(7, _omitFieldNames ? '' : 'billableAiCreditsUsed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageResponse copyWith(void Function(GetUsageResponse) updates) =>
      super.copyWith((message) => updates(message as GetUsageResponse))
          as GetUsageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetUsageResponse() / GetUsageResponse.new instead')
  static GetUsageResponse create() => GetUsageResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetUsageResponse._();
  @$core.override
  GetUsageResponse createEmptyInstance() => GetUsageResponse._();
  @$core.pragma('dart2js:noInline')
  static GetUsageResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUsageResponse>(
          GetUsageResponse.$_createMessage);
  static GetUsageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get apiKeyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set apiKeyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApiKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApiKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get currentMonthRequests => $_getI64(2);
  @$pb.TagNumber(3)
  set currentMonthRequests($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrentMonthRequests() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentMonthRequests() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get monthlyQuota => $_getI64(3);
  @$pb.TagNumber(4)
  set monthlyQuota($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMonthlyQuota() => $_has(3);
  @$pb.TagNumber(4)
  void clearMonthlyQuota() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get readRateLimitRpm => $_getIZ(4);
  @$pb.TagNumber(5)
  set readRateLimitRpm($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReadRateLimitRpm() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadRateLimitRpm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get writeRateLimitRpm => $_getIZ(5);
  @$pb.TagNumber(6)
  set writeRateLimitRpm($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWriteRateLimitRpm() => $_has(5);
  @$pb.TagNumber(6)
  void clearWriteRateLimitRpm() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get billableAiCreditsUsed => $_getN(6);
  @$pb.TagNumber(7)
  set billableAiCreditsUsed($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBillableAiCreditsUsed() => $_has(6);
  @$pb.TagNumber(7)
  void clearBillableAiCreditsUsed() => $_clearField(7);
}

class APIUsageDaily extends $pb.GeneratedMessage {
  factory APIUsageDaily({
    $core.String? usageId,
    $core.String? workspaceId,
    $core.String? apiKeyId,
    $core.String? usageDate,
    $core.int? readRequests,
    $core.int? writeRequests,
    $core.int? error4xxCount,
    $core.int? error5xxCount,
    $core.int? outboundWebhookDeliveries,
    $core.double? billableAiCredits,
  }) {
    final result = APIUsageDaily._();
    if (usageId != null) result.usageId = usageId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    if (usageDate != null) result.usageDate = usageDate;
    if (readRequests != null) result.readRequests = readRequests;
    if (writeRequests != null) result.writeRequests = writeRequests;
    if (error4xxCount != null) result.error4xxCount = error4xxCount;
    if (error5xxCount != null) result.error5xxCount = error5xxCount;
    if (outboundWebhookDeliveries != null)
      result.outboundWebhookDeliveries = outboundWebhookDeliveries;
    if (billableAiCredits != null) result.billableAiCredits = billableAiCredits;
    return result;
  }

  APIUsageDaily._();

  factory APIUsageDaily.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      APIUsageDaily()..mergeFromBuffer(data, registry);
  factory APIUsageDaily.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      APIUsageDaily()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'APIUsageDaily',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: APIUsageDaily.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'usageId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'apiKeyId')
    ..aOS(4, _omitFieldNames ? '' : 'usageDate')
    ..aI(5, _omitFieldNames ? '' : 'readRequests')
    ..aI(6, _omitFieldNames ? '' : 'writeRequests')
    ..aI(7, _omitFieldNames ? '' : 'error4xxCount',
        protoName: 'error_4xx_count')
    ..aI(8, _omitFieldNames ? '' : 'error5xxCount',
        protoName: 'error_5xx_count')
    ..aI(9, _omitFieldNames ? '' : 'outboundWebhookDeliveries')
    ..aD(10, _omitFieldNames ? '' : 'billableAiCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  APIUsageDaily clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  APIUsageDaily copyWith(void Function(APIUsageDaily) updates) =>
      super.copyWith((message) => updates(message as APIUsageDaily))
          as APIUsageDaily;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use APIUsageDaily() / APIUsageDaily.new instead')
  static APIUsageDaily create() => APIUsageDaily._();
  static $pb.GeneratedMessage $_createMessage() => APIUsageDaily._();
  @$core.override
  APIUsageDaily createEmptyInstance() => APIUsageDaily._();
  @$core.pragma('dart2js:noInline')
  static APIUsageDaily getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<APIUsageDaily>(
          APIUsageDaily.$_createMessage);
  static APIUsageDaily? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get usageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set usageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get apiKeyId => $_getSZ(2);
  @$pb.TagNumber(3)
  set apiKeyId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasApiKeyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearApiKeyId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get usageDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set usageDate($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsageDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsageDate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get readRequests => $_getIZ(4);
  @$pb.TagNumber(5)
  set readRequests($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReadRequests() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadRequests() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get writeRequests => $_getIZ(5);
  @$pb.TagNumber(6)
  set writeRequests($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWriteRequests() => $_has(5);
  @$pb.TagNumber(6)
  void clearWriteRequests() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get error4xxCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set error4xxCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasError4xxCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearError4xxCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get error5xxCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set error5xxCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasError5xxCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearError5xxCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get outboundWebhookDeliveries => $_getIZ(8);
  @$pb.TagNumber(9)
  set outboundWebhookDeliveries($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOutboundWebhookDeliveries() => $_has(8);
  @$pb.TagNumber(9)
  void clearOutboundWebhookDeliveries() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get billableAiCredits => $_getN(9);
  @$pb.TagNumber(10)
  set billableAiCredits($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBillableAiCredits() => $_has(9);
  @$pb.TagNumber(10)
  void clearBillableAiCredits() => $_clearField(10);
}

class GetUsageStatsRequest extends $pb.GeneratedMessage {
  factory GetUsageStatsRequest({
    $core.String? workspaceId,
    $core.String? apiKeyId,
    $core.String? startDate,
    $core.String? endDate,
  }) {
    final result = GetUsageStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    return result;
  }

  GetUsageStatsRequest._();

  factory GetUsageStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageStatsRequest()..mergeFromBuffer(data, registry);
  factory GetUsageStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetUsageStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'apiKeyId')
    ..aOS(3, _omitFieldNames ? '' : 'startDate')
    ..aOS(4, _omitFieldNames ? '' : 'endDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageStatsRequest copyWith(void Function(GetUsageStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetUsageStatsRequest))
          as GetUsageStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUsageStatsRequest() / GetUsageStatsRequest.new instead')
  static GetUsageStatsRequest create() => GetUsageStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetUsageStatsRequest._();
  @$core.override
  GetUsageStatsRequest createEmptyInstance() => GetUsageStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetUsageStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUsageStatsRequest>(
          GetUsageStatsRequest.$_createMessage);
  static GetUsageStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get apiKeyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set apiKeyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApiKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApiKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get startDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set startDate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartDate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get endDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set endDate($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEndDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndDate() => $_clearField(4);
}

class GetUsageStatsResponse extends $pb.GeneratedMessage {
  factory GetUsageStatsResponse({
    $core.Iterable<APIUsageDaily>? dailyStats,
    $fixnum.Int64? totalRequests,
    $core.double? totalBillableAiCredits,
  }) {
    final result = GetUsageStatsResponse._();
    if (dailyStats != null) result.dailyStats.addAll(dailyStats);
    if (totalRequests != null) result.totalRequests = totalRequests;
    if (totalBillableAiCredits != null)
      result.totalBillableAiCredits = totalBillableAiCredits;
    return result;
  }

  GetUsageStatsResponse._();

  factory GetUsageStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageStatsResponse()..mergeFromBuffer(data, registry);
  factory GetUsageStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetUsageStatsResponse.$_createMessage)
    ..pPM<APIUsageDaily>(1, _omitFieldNames ? '' : 'dailyStats',
        subBuilder: APIUsageDaily.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'totalRequests')
    ..aD(3, _omitFieldNames ? '' : 'totalBillableAiCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageStatsResponse copyWith(
          void Function(GetUsageStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetUsageStatsResponse))
          as GetUsageStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUsageStatsResponse() / GetUsageStatsResponse.new instead')
  static GetUsageStatsResponse create() => GetUsageStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetUsageStatsResponse._();
  @$core.override
  GetUsageStatsResponse createEmptyInstance() => GetUsageStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetUsageStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUsageStatsResponse>(
          GetUsageStatsResponse.$_createMessage);
  static GetUsageStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<APIUsageDaily> get dailyStats => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalRequests => $_getI64(1);
  @$pb.TagNumber(2)
  set totalRequests($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalRequests() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalRequests() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalBillableAiCredits => $_getN(2);
  @$pb.TagNumber(3)
  set totalBillableAiCredits($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalBillableAiCredits() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalBillableAiCredits() => $_clearField(3);
}

class UpdateScopesRequest extends $pb.GeneratedMessage {
  factory UpdateScopesRequest({
    $core.String? workspaceId,
    $core.String? apiKeyId,
    $core.Iterable<$core.String>? scopes,
  }) {
    final result = UpdateScopesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    if (scopes != null) result.scopes.addAll(scopes);
    return result;
  }

  UpdateScopesRequest._();

  factory UpdateScopesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateScopesRequest()..mergeFromBuffer(data, registry);
  factory UpdateScopesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateScopesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateScopesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: UpdateScopesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'apiKeyId')
    ..pPS(3, _omitFieldNames ? '' : 'scopes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateScopesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateScopesRequest copyWith(void Function(UpdateScopesRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateScopesRequest))
          as UpdateScopesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateScopesRequest() / UpdateScopesRequest.new instead')
  static UpdateScopesRequest create() => UpdateScopesRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateScopesRequest._();
  @$core.override
  UpdateScopesRequest createEmptyInstance() => UpdateScopesRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateScopesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateScopesRequest>(
          UpdateScopesRequest.$_createMessage);
  static UpdateScopesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get apiKeyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set apiKeyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApiKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApiKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get scopes => $_getList(2);
}

class UpdateScopesResponse extends $pb.GeneratedMessage {
  factory UpdateScopesResponse({
    APIKey? apiKey,
  }) {
    final result = UpdateScopesResponse._();
    if (apiKey != null) result.apiKey = apiKey;
    return result;
  }

  UpdateScopesResponse._();

  factory UpdateScopesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateScopesResponse()..mergeFromBuffer(data, registry);
  factory UpdateScopesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateScopesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateScopesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: UpdateScopesResponse.$_createMessage)
    ..aOM<APIKey>(1, _omitFieldNames ? '' : 'apiKey',
        subBuilder: APIKey.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateScopesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateScopesResponse copyWith(void Function(UpdateScopesResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateScopesResponse))
          as UpdateScopesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateScopesResponse() / UpdateScopesResponse.new instead')
  static UpdateScopesResponse create() => UpdateScopesResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateScopesResponse._();
  @$core.override
  UpdateScopesResponse createEmptyInstance() => UpdateScopesResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateScopesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateScopesResponse>(
          UpdateScopesResponse.$_createMessage);
  static UpdateScopesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  APIKey get apiKey => $_getN(0);
  @$pb.TagNumber(1)
  set apiKey(APIKey value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasApiKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearApiKey() => $_clearField(1);
  @$pb.TagNumber(1)
  APIKey ensureApiKey() => $_ensure(0);
}

class WebhookSubscription extends $pb.GeneratedMessage {
  factory WebhookSubscription({
    $core.String? webhookSubscriptionId,
    $core.String? workspaceId,
    $core.String? apiKeyId,
    $core.String? targetUrl,
    $core.Iterable<$core.String>? eventTypes,
    WebhookSubscriptionStatus? status,
    $core.int? consecutiveFailureCount,
    $1.Timestamp? lastDeliveryAt,
    $core.String? lastError,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? signingSecret,
  }) {
    final result = WebhookSubscription._();
    if (webhookSubscriptionId != null)
      result.webhookSubscriptionId = webhookSubscriptionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    if (targetUrl != null) result.targetUrl = targetUrl;
    if (eventTypes != null) result.eventTypes.addAll(eventTypes);
    if (status != null) result.status = status;
    if (consecutiveFailureCount != null)
      result.consecutiveFailureCount = consecutiveFailureCount;
    if (lastDeliveryAt != null) result.lastDeliveryAt = lastDeliveryAt;
    if (lastError != null) result.lastError = lastError;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (signingSecret != null) result.signingSecret = signingSecret;
    return result;
  }

  WebhookSubscription._();

  factory WebhookSubscription.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WebhookSubscription()..mergeFromBuffer(data, registry);
  factory WebhookSubscription.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WebhookSubscription()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebhookSubscription',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: WebhookSubscription.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'webhookSubscriptionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'apiKeyId')
    ..aOS(4, _omitFieldNames ? '' : 'targetUrl')
    ..pPS(5, _omitFieldNames ? '' : 'eventTypes')
    ..aE<WebhookSubscriptionStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: WebhookSubscriptionStatus.values)
    ..aI(7, _omitFieldNames ? '' : 'consecutiveFailureCount')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'lastDeliveryAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'lastError')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'signingSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebhookSubscription clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebhookSubscription copyWith(void Function(WebhookSubscription) updates) =>
      super.copyWith((message) => updates(message as WebhookSubscription))
          as WebhookSubscription;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use WebhookSubscription() / WebhookSubscription.new instead')
  static WebhookSubscription create() => WebhookSubscription._();
  static $pb.GeneratedMessage $_createMessage() => WebhookSubscription._();
  @$core.override
  WebhookSubscription createEmptyInstance() => WebhookSubscription._();
  @$core.pragma('dart2js:noInline')
  static WebhookSubscription getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebhookSubscription>(
          WebhookSubscription.$_createMessage);
  static WebhookSubscription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get webhookSubscriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set webhookSubscriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWebhookSubscriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWebhookSubscriptionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get apiKeyId => $_getSZ(2);
  @$pb.TagNumber(3)
  set apiKeyId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasApiKeyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearApiKeyId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get eventTypes => $_getList(4);

  @$pb.TagNumber(6)
  WebhookSubscriptionStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(WebhookSubscriptionStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get consecutiveFailureCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set consecutiveFailureCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConsecutiveFailureCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearConsecutiveFailureCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get lastDeliveryAt => $_getN(7);
  @$pb.TagNumber(8)
  set lastDeliveryAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLastDeliveryAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastDeliveryAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureLastDeliveryAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get lastError => $_getSZ(8);
  @$pb.TagNumber(9)
  set lastError($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLastError() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastError() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureUpdatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get signingSecret => $_getSZ(11);
  @$pb.TagNumber(12)
  set signingSecret($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSigningSecret() => $_has(11);
  @$pb.TagNumber(12)
  void clearSigningSecret() => $_clearField(12);
}

class WebhookDeliveryRecord extends $pb.GeneratedMessage {
  factory WebhookDeliveryRecord({
    $core.String? webhookEventId,
    $core.String? workspaceId,
    $core.String? subscriptionId,
    $core.String? eventType,
    $core.String? targetUrl,
    $core.int? statusCode,
    $core.int? attemptCount,
    $core.String? deliveryStatus,
    $core.String? errorMessage,
    $1.Timestamp? deliveredAt,
    $core.bool? isReplay,
  }) {
    final result = WebhookDeliveryRecord._();
    if (webhookEventId != null) result.webhookEventId = webhookEventId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (subscriptionId != null) result.subscriptionId = subscriptionId;
    if (eventType != null) result.eventType = eventType;
    if (targetUrl != null) result.targetUrl = targetUrl;
    if (statusCode != null) result.statusCode = statusCode;
    if (attemptCount != null) result.attemptCount = attemptCount;
    if (deliveryStatus != null) result.deliveryStatus = deliveryStatus;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (deliveredAt != null) result.deliveredAt = deliveredAt;
    if (isReplay != null) result.isReplay = isReplay;
    return result;
  }

  WebhookDeliveryRecord._();

  factory WebhookDeliveryRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WebhookDeliveryRecord()..mergeFromBuffer(data, registry);
  factory WebhookDeliveryRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WebhookDeliveryRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebhookDeliveryRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: WebhookDeliveryRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'webhookEventId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'subscriptionId')
    ..aOS(4, _omitFieldNames ? '' : 'eventType')
    ..aOS(5, _omitFieldNames ? '' : 'targetUrl')
    ..aI(6, _omitFieldNames ? '' : 'statusCode')
    ..aI(7, _omitFieldNames ? '' : 'attemptCount')
    ..aOS(8, _omitFieldNames ? '' : 'deliveryStatus')
    ..aOS(9, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'deliveredAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOB(11, _omitFieldNames ? '' : 'isReplay')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebhookDeliveryRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebhookDeliveryRecord copyWith(
          void Function(WebhookDeliveryRecord) updates) =>
      super.copyWith((message) => updates(message as WebhookDeliveryRecord))
          as WebhookDeliveryRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WebhookDeliveryRecord() / WebhookDeliveryRecord.new instead')
  static WebhookDeliveryRecord create() => WebhookDeliveryRecord._();
  static $pb.GeneratedMessage $_createMessage() => WebhookDeliveryRecord._();
  @$core.override
  WebhookDeliveryRecord createEmptyInstance() => WebhookDeliveryRecord._();
  @$core.pragma('dart2js:noInline')
  static WebhookDeliveryRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebhookDeliveryRecord>(
          WebhookDeliveryRecord.$_createMessage);
  static WebhookDeliveryRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get webhookEventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set webhookEventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWebhookEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWebhookEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subscriptionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set subscriptionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubscriptionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubscriptionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get eventType => $_getSZ(3);
  @$pb.TagNumber(4)
  set eventType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEventType() => $_has(3);
  @$pb.TagNumber(4)
  void clearEventType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get statusCode => $_getIZ(5);
  @$pb.TagNumber(6)
  set statusCode($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStatusCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatusCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get attemptCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set attemptCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAttemptCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearAttemptCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get deliveryStatus => $_getSZ(7);
  @$pb.TagNumber(8)
  set deliveryStatus($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeliveryStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeliveryStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get errorMessage => $_getSZ(8);
  @$pb.TagNumber(9)
  set errorMessage($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasErrorMessage() => $_has(8);
  @$pb.TagNumber(9)
  void clearErrorMessage() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get deliveredAt => $_getN(9);
  @$pb.TagNumber(10)
  set deliveredAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDeliveredAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearDeliveredAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureDeliveredAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get isReplay => $_getBF(10);
  @$pb.TagNumber(11)
  set isReplay($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsReplay() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsReplay() => $_clearField(11);
}

class CreateWebhookSubscriptionRequest extends $pb.GeneratedMessage {
  factory CreateWebhookSubscriptionRequest({
    $core.String? workspaceId,
    $core.String? apiKeyId,
    $core.String? targetUrl,
    $core.Iterable<$core.String>? eventTypes,
  }) {
    final result = CreateWebhookSubscriptionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (apiKeyId != null) result.apiKeyId = apiKeyId;
    if (targetUrl != null) result.targetUrl = targetUrl;
    if (eventTypes != null) result.eventTypes.addAll(eventTypes);
    return result;
  }

  CreateWebhookSubscriptionRequest._();

  factory CreateWebhookSubscriptionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateWebhookSubscriptionRequest()..mergeFromBuffer(data, registry);
  factory CreateWebhookSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateWebhookSubscriptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateWebhookSubscriptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: CreateWebhookSubscriptionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'apiKeyId')
    ..aOS(3, _omitFieldNames ? '' : 'targetUrl')
    ..pPS(4, _omitFieldNames ? '' : 'eventTypes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWebhookSubscriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWebhookSubscriptionRequest copyWith(
          void Function(CreateWebhookSubscriptionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CreateWebhookSubscriptionRequest))
          as CreateWebhookSubscriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateWebhookSubscriptionRequest() / CreateWebhookSubscriptionRequest.new instead')
  static CreateWebhookSubscriptionRequest create() =>
      CreateWebhookSubscriptionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateWebhookSubscriptionRequest._();
  @$core.override
  CreateWebhookSubscriptionRequest createEmptyInstance() =>
      CreateWebhookSubscriptionRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateWebhookSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateWebhookSubscriptionRequest>(
          CreateWebhookSubscriptionRequest.$_createMessage);
  static CreateWebhookSubscriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get apiKeyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set apiKeyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApiKeyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApiKeyId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get eventTypes => $_getList(3);
}

class CreateWebhookSubscriptionResponse extends $pb.GeneratedMessage {
  factory CreateWebhookSubscriptionResponse({
    WebhookSubscription? subscription,
    $core.String? signingSecret,
  }) {
    final result = CreateWebhookSubscriptionResponse._();
    if (subscription != null) result.subscription = subscription;
    if (signingSecret != null) result.signingSecret = signingSecret;
    return result;
  }

  CreateWebhookSubscriptionResponse._();

  factory CreateWebhookSubscriptionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateWebhookSubscriptionResponse()..mergeFromBuffer(data, registry);
  factory CreateWebhookSubscriptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateWebhookSubscriptionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateWebhookSubscriptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: CreateWebhookSubscriptionResponse.$_createMessage)
    ..aOM<WebhookSubscription>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: WebhookSubscription.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'signingSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWebhookSubscriptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWebhookSubscriptionResponse copyWith(
          void Function(CreateWebhookSubscriptionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CreateWebhookSubscriptionResponse))
          as CreateWebhookSubscriptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateWebhookSubscriptionResponse() / CreateWebhookSubscriptionResponse.new instead')
  static CreateWebhookSubscriptionResponse create() =>
      CreateWebhookSubscriptionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreateWebhookSubscriptionResponse._();
  @$core.override
  CreateWebhookSubscriptionResponse createEmptyInstance() =>
      CreateWebhookSubscriptionResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateWebhookSubscriptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateWebhookSubscriptionResponse>(
          CreateWebhookSubscriptionResponse.$_createMessage);
  static CreateWebhookSubscriptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WebhookSubscription get subscription => $_getN(0);
  @$pb.TagNumber(1)
  set subscription(WebhookSubscription value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscription() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscription() => $_clearField(1);
  @$pb.TagNumber(1)
  WebhookSubscription ensureSubscription() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get signingSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set signingSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSigningSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearSigningSecret() => $_clearField(2);
}

class ListWebhookSubscriptionsRequest extends $pb.GeneratedMessage {
  factory ListWebhookSubscriptionsRequest({
    $core.String? workspaceId,
  }) {
    final result = ListWebhookSubscriptionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  ListWebhookSubscriptionsRequest._();

  factory ListWebhookSubscriptionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListWebhookSubscriptionsRequest()..mergeFromBuffer(data, registry);
  factory ListWebhookSubscriptionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListWebhookSubscriptionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWebhookSubscriptionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListWebhookSubscriptionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWebhookSubscriptionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWebhookSubscriptionsRequest copyWith(
          void Function(ListWebhookSubscriptionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListWebhookSubscriptionsRequest))
          as ListWebhookSubscriptionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListWebhookSubscriptionsRequest() / ListWebhookSubscriptionsRequest.new instead')
  static ListWebhookSubscriptionsRequest create() =>
      ListWebhookSubscriptionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListWebhookSubscriptionsRequest._();
  @$core.override
  ListWebhookSubscriptionsRequest createEmptyInstance() =>
      ListWebhookSubscriptionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListWebhookSubscriptionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWebhookSubscriptionsRequest>(
          ListWebhookSubscriptionsRequest.$_createMessage);
  static ListWebhookSubscriptionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class ListWebhookSubscriptionsResponse extends $pb.GeneratedMessage {
  factory ListWebhookSubscriptionsResponse({
    $core.Iterable<WebhookSubscription>? subscriptions,
  }) {
    final result = ListWebhookSubscriptionsResponse._();
    if (subscriptions != null) result.subscriptions.addAll(subscriptions);
    return result;
  }

  ListWebhookSubscriptionsResponse._();

  factory ListWebhookSubscriptionsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListWebhookSubscriptionsResponse()..mergeFromBuffer(data, registry);
  factory ListWebhookSubscriptionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListWebhookSubscriptionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWebhookSubscriptionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListWebhookSubscriptionsResponse.$_createMessage)
    ..pPM<WebhookSubscription>(1, _omitFieldNames ? '' : 'subscriptions',
        subBuilder: WebhookSubscription.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWebhookSubscriptionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWebhookSubscriptionsResponse copyWith(
          void Function(ListWebhookSubscriptionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListWebhookSubscriptionsResponse))
          as ListWebhookSubscriptionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListWebhookSubscriptionsResponse() / ListWebhookSubscriptionsResponse.new instead')
  static ListWebhookSubscriptionsResponse create() =>
      ListWebhookSubscriptionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListWebhookSubscriptionsResponse._();
  @$core.override
  ListWebhookSubscriptionsResponse createEmptyInstance() =>
      ListWebhookSubscriptionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListWebhookSubscriptionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWebhookSubscriptionsResponse>(
          ListWebhookSubscriptionsResponse.$_createMessage);
  static ListWebhookSubscriptionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WebhookSubscription> get subscriptions => $_getList(0);
}

class DeleteWebhookSubscriptionRequest extends $pb.GeneratedMessage {
  factory DeleteWebhookSubscriptionRequest({
    $core.String? workspaceId,
    $core.String? webhookSubscriptionId,
  }) {
    final result = DeleteWebhookSubscriptionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (webhookSubscriptionId != null)
      result.webhookSubscriptionId = webhookSubscriptionId;
    return result;
  }

  DeleteWebhookSubscriptionRequest._();

  factory DeleteWebhookSubscriptionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteWebhookSubscriptionRequest()..mergeFromBuffer(data, registry);
  factory DeleteWebhookSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteWebhookSubscriptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteWebhookSubscriptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: DeleteWebhookSubscriptionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'webhookSubscriptionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWebhookSubscriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWebhookSubscriptionRequest copyWith(
          void Function(DeleteWebhookSubscriptionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteWebhookSubscriptionRequest))
          as DeleteWebhookSubscriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteWebhookSubscriptionRequest() / DeleteWebhookSubscriptionRequest.new instead')
  static DeleteWebhookSubscriptionRequest create() =>
      DeleteWebhookSubscriptionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      DeleteWebhookSubscriptionRequest._();
  @$core.override
  DeleteWebhookSubscriptionRequest createEmptyInstance() =>
      DeleteWebhookSubscriptionRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteWebhookSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteWebhookSubscriptionRequest>(
          DeleteWebhookSubscriptionRequest.$_createMessage);
  static DeleteWebhookSubscriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get webhookSubscriptionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set webhookSubscriptionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWebhookSubscriptionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWebhookSubscriptionId() => $_clearField(2);
}

class DeleteWebhookSubscriptionResponse extends $pb.GeneratedMessage {
  factory DeleteWebhookSubscriptionResponse({
    $core.bool? success,
  }) {
    final result = DeleteWebhookSubscriptionResponse._();
    if (success != null) result.success = success;
    return result;
  }

  DeleteWebhookSubscriptionResponse._();

  factory DeleteWebhookSubscriptionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteWebhookSubscriptionResponse()..mergeFromBuffer(data, registry);
  factory DeleteWebhookSubscriptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteWebhookSubscriptionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteWebhookSubscriptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: DeleteWebhookSubscriptionResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWebhookSubscriptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWebhookSubscriptionResponse copyWith(
          void Function(DeleteWebhookSubscriptionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as DeleteWebhookSubscriptionResponse))
          as DeleteWebhookSubscriptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteWebhookSubscriptionResponse() / DeleteWebhookSubscriptionResponse.new instead')
  static DeleteWebhookSubscriptionResponse create() =>
      DeleteWebhookSubscriptionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      DeleteWebhookSubscriptionResponse._();
  @$core.override
  DeleteWebhookSubscriptionResponse createEmptyInstance() =>
      DeleteWebhookSubscriptionResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteWebhookSubscriptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteWebhookSubscriptionResponse>(
          DeleteWebhookSubscriptionResponse.$_createMessage);
  static DeleteWebhookSubscriptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class TestWebhookSubscriptionRequest extends $pb.GeneratedMessage {
  factory TestWebhookSubscriptionRequest({
    $core.String? workspaceId,
    $core.String? webhookSubscriptionId,
    $core.String? eventType,
  }) {
    final result = TestWebhookSubscriptionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (webhookSubscriptionId != null)
      result.webhookSubscriptionId = webhookSubscriptionId;
    if (eventType != null) result.eventType = eventType;
    return result;
  }

  TestWebhookSubscriptionRequest._();

  factory TestWebhookSubscriptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TestWebhookSubscriptionRequest()..mergeFromBuffer(data, registry);
  factory TestWebhookSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TestWebhookSubscriptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestWebhookSubscriptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: TestWebhookSubscriptionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'webhookSubscriptionId')
    ..aOS(3, _omitFieldNames ? '' : 'eventType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestWebhookSubscriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestWebhookSubscriptionRequest copyWith(
          void Function(TestWebhookSubscriptionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TestWebhookSubscriptionRequest))
          as TestWebhookSubscriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TestWebhookSubscriptionRequest() / TestWebhookSubscriptionRequest.new instead')
  static TestWebhookSubscriptionRequest create() =>
      TestWebhookSubscriptionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TestWebhookSubscriptionRequest._();
  @$core.override
  TestWebhookSubscriptionRequest createEmptyInstance() =>
      TestWebhookSubscriptionRequest._();
  @$core.pragma('dart2js:noInline')
  static TestWebhookSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestWebhookSubscriptionRequest>(
          TestWebhookSubscriptionRequest.$_createMessage);
  static TestWebhookSubscriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get webhookSubscriptionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set webhookSubscriptionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWebhookSubscriptionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWebhookSubscriptionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get eventType => $_getSZ(2);
  @$pb.TagNumber(3)
  set eventType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEventType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEventType() => $_clearField(3);
}

class TestWebhookSubscriptionResponse extends $pb.GeneratedMessage {
  factory TestWebhookSubscriptionResponse({
    $core.bool? success,
    $core.int? statusCode,
    $core.String? responseBody,
    $core.String? signatureHeader,
  }) {
    final result = TestWebhookSubscriptionResponse._();
    if (success != null) result.success = success;
    if (statusCode != null) result.statusCode = statusCode;
    if (responseBody != null) result.responseBody = responseBody;
    if (signatureHeader != null) result.signatureHeader = signatureHeader;
    return result;
  }

  TestWebhookSubscriptionResponse._();

  factory TestWebhookSubscriptionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TestWebhookSubscriptionResponse()..mergeFromBuffer(data, registry);
  factory TestWebhookSubscriptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TestWebhookSubscriptionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestWebhookSubscriptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: TestWebhookSubscriptionResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aI(2, _omitFieldNames ? '' : 'statusCode')
    ..aOS(3, _omitFieldNames ? '' : 'responseBody')
    ..aOS(4, _omitFieldNames ? '' : 'signatureHeader')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestWebhookSubscriptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestWebhookSubscriptionResponse copyWith(
          void Function(TestWebhookSubscriptionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TestWebhookSubscriptionResponse))
          as TestWebhookSubscriptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TestWebhookSubscriptionResponse() / TestWebhookSubscriptionResponse.new instead')
  static TestWebhookSubscriptionResponse create() =>
      TestWebhookSubscriptionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TestWebhookSubscriptionResponse._();
  @$core.override
  TestWebhookSubscriptionResponse createEmptyInstance() =>
      TestWebhookSubscriptionResponse._();
  @$core.pragma('dart2js:noInline')
  static TestWebhookSubscriptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestWebhookSubscriptionResponse>(
          TestWebhookSubscriptionResponse.$_createMessage);
  static TestWebhookSubscriptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get statusCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set statusCode($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get responseBody => $_getSZ(2);
  @$pb.TagNumber(3)
  set responseBody($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResponseBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearResponseBody() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get signatureHeader => $_getSZ(3);
  @$pb.TagNumber(4)
  set signatureHeader($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSignatureHeader() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignatureHeader() => $_clearField(4);
}

class ReplayWebhookDeliveryRequest extends $pb.GeneratedMessage {
  factory ReplayWebhookDeliveryRequest({
    $core.String? workspaceId,
    $core.String? webhookEventId,
  }) {
    final result = ReplayWebhookDeliveryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (webhookEventId != null) result.webhookEventId = webhookEventId;
    return result;
  }

  ReplayWebhookDeliveryRequest._();

  factory ReplayWebhookDeliveryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplayWebhookDeliveryRequest()..mergeFromBuffer(data, registry);
  factory ReplayWebhookDeliveryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplayWebhookDeliveryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplayWebhookDeliveryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ReplayWebhookDeliveryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'webhookEventId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplayWebhookDeliveryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplayWebhookDeliveryRequest copyWith(
          void Function(ReplayWebhookDeliveryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ReplayWebhookDeliveryRequest))
          as ReplayWebhookDeliveryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReplayWebhookDeliveryRequest() / ReplayWebhookDeliveryRequest.new instead')
  static ReplayWebhookDeliveryRequest create() =>
      ReplayWebhookDeliveryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReplayWebhookDeliveryRequest._();
  @$core.override
  ReplayWebhookDeliveryRequest createEmptyInstance() =>
      ReplayWebhookDeliveryRequest._();
  @$core.pragma('dart2js:noInline')
  static ReplayWebhookDeliveryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplayWebhookDeliveryRequest>(
          ReplayWebhookDeliveryRequest.$_createMessage);
  static ReplayWebhookDeliveryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get webhookEventId => $_getSZ(1);
  @$pb.TagNumber(2)
  set webhookEventId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWebhookEventId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWebhookEventId() => $_clearField(2);
}

class ReplayWebhookDeliveryResponse extends $pb.GeneratedMessage {
  factory ReplayWebhookDeliveryResponse({
    $core.bool? success,
    WebhookDeliveryRecord? deliveryRecord,
  }) {
    final result = ReplayWebhookDeliveryResponse._();
    if (success != null) result.success = success;
    if (deliveryRecord != null) result.deliveryRecord = deliveryRecord;
    return result;
  }

  ReplayWebhookDeliveryResponse._();

  factory ReplayWebhookDeliveryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplayWebhookDeliveryResponse()..mergeFromBuffer(data, registry);
  factory ReplayWebhookDeliveryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplayWebhookDeliveryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplayWebhookDeliveryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ReplayWebhookDeliveryResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<WebhookDeliveryRecord>(2, _omitFieldNames ? '' : 'deliveryRecord',
        subBuilder: WebhookDeliveryRecord.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplayWebhookDeliveryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplayWebhookDeliveryResponse copyWith(
          void Function(ReplayWebhookDeliveryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ReplayWebhookDeliveryResponse))
          as ReplayWebhookDeliveryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReplayWebhookDeliveryResponse() / ReplayWebhookDeliveryResponse.new instead')
  static ReplayWebhookDeliveryResponse create() =>
      ReplayWebhookDeliveryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReplayWebhookDeliveryResponse._();
  @$core.override
  ReplayWebhookDeliveryResponse createEmptyInstance() =>
      ReplayWebhookDeliveryResponse._();
  @$core.pragma('dart2js:noInline')
  static ReplayWebhookDeliveryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplayWebhookDeliveryResponse>(
          ReplayWebhookDeliveryResponse.$_createMessage);
  static ReplayWebhookDeliveryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  WebhookDeliveryRecord get deliveryRecord => $_getN(1);
  @$pb.TagNumber(2)
  set deliveryRecord(WebhookDeliveryRecord value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDeliveryRecord() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeliveryRecord() => $_clearField(2);
  @$pb.TagNumber(2)
  WebhookDeliveryRecord ensureDeliveryRecord() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

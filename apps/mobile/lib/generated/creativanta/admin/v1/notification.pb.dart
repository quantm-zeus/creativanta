// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/notification.proto.

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
import 'notification.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'notification.pbenum.dart';

/// Single notification item
class NotificationItem extends $pb.GeneratedMessage {
  factory NotificationItem({
    $1.UUID? notificationId,
    $1.UUID? workspaceId,
    $1.UUID? userId,
    NotificationPriority? priority,
    NotificationChannel? channel,
    $core.String? title,
    $core.String? body,
    $core.String? deepLink,
    $core.String? actionButtonsJson,
    $core.String? groupedKey,
    $2.Timestamp? readAt,
    $2.Timestamp? dismissedAt,
    $2.Timestamp? deliveredAt,
    $2.Timestamp? createdAt,
  }) {
    final result = NotificationItem._();
    if (notificationId != null) result.notificationId = notificationId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (priority != null) result.priority = priority;
    if (channel != null) result.channel = channel;
    if (title != null) result.title = title;
    if (body != null) result.body = body;
    if (deepLink != null) result.deepLink = deepLink;
    if (actionButtonsJson != null) result.actionButtonsJson = actionButtonsJson;
    if (groupedKey != null) result.groupedKey = groupedKey;
    if (readAt != null) result.readAt = readAt;
    if (dismissedAt != null) result.dismissedAt = dismissedAt;
    if (deliveredAt != null) result.deliveredAt = deliveredAt;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  NotificationItem._();

  factory NotificationItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationItem()..mergeFromBuffer(data, registry);
  factory NotificationItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: NotificationItem.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'notificationId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(3, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..aE<NotificationPriority>(4, _omitFieldNames ? '' : 'priority',
        enumValues: NotificationPriority.values)
    ..aE<NotificationChannel>(5, _omitFieldNames ? '' : 'channel',
        enumValues: NotificationChannel.values)
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'body')
    ..aOS(8, _omitFieldNames ? '' : 'deepLink')
    ..aOS(9, _omitFieldNames ? '' : 'actionButtonsJson')
    ..aOS(10, _omitFieldNames ? '' : 'groupedKey')
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'readAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'dismissedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'deliveredAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationItem copyWith(void Function(NotificationItem) updates) =>
      super.copyWith((message) => updates(message as NotificationItem))
          as NotificationItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NotificationItem() / NotificationItem.new instead')
  static NotificationItem create() => NotificationItem._();
  static $pb.GeneratedMessage $_createMessage() => NotificationItem._();
  @$core.override
  NotificationItem createEmptyInstance() => NotificationItem._();
  @$core.pragma('dart2js:noInline')
  static NotificationItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotificationItem>(
          NotificationItem.$_createMessage);
  static NotificationItem? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get notificationId => $_getN(0);
  @$pb.TagNumber(1)
  set notificationId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureNotificationId() => $_ensure(0);

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
  $1.UUID get userId => $_getN(2);
  @$pb.TagNumber(3)
  set userId($1.UUID value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.UUID ensureUserId() => $_ensure(2);

  @$pb.TagNumber(4)
  NotificationPriority get priority => $_getN(3);
  @$pb.TagNumber(4)
  set priority(NotificationPriority value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriority() => $_clearField(4);

  @$pb.TagNumber(5)
  NotificationChannel get channel => $_getN(4);
  @$pb.TagNumber(5)
  set channel(NotificationChannel value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasChannel() => $_has(4);
  @$pb.TagNumber(5)
  void clearChannel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get body => $_getSZ(6);
  @$pb.TagNumber(7)
  set body($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBody() => $_has(6);
  @$pb.TagNumber(7)
  void clearBody() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get deepLink => $_getSZ(7);
  @$pb.TagNumber(8)
  set deepLink($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeepLink() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeepLink() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get actionButtonsJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set actionButtonsJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasActionButtonsJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearActionButtonsJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get groupedKey => $_getSZ(9);
  @$pb.TagNumber(10)
  set groupedKey($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasGroupedKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearGroupedKey() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.Timestamp get readAt => $_getN(10);
  @$pb.TagNumber(11)
  set readAt($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasReadAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearReadAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureReadAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $2.Timestamp get dismissedAt => $_getN(11);
  @$pb.TagNumber(12)
  set dismissedAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDismissedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDismissedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureDismissedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $2.Timestamp get deliveredAt => $_getN(12);
  @$pb.TagNumber(13)
  set deliveredAt($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasDeliveredAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearDeliveredAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureDeliveredAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $2.Timestamp get createdAt => $_getN(13);
  @$pb.TagNumber(14)
  set createdAt($2.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Timestamp ensureCreatedAt() => $_ensure(13);
}

class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $1.UUID? workspaceId,
    $1.UUID? userId,
    $core.bool? unreadOnly,
    NotificationPriority? minPriority,
    $1.Pagination? pagination,
  }) {
    final result = ListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (unreadOnly != null) result.unreadOnly = unreadOnly;
    if (minPriority != null) result.minPriority = minPriority;
    if (pagination != null) result.pagination = pagination;
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
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'unreadOnly')
    ..aE<NotificationPriority>(4, _omitFieldNames ? '' : 'minPriority',
        enumValues: NotificationPriority.values)
    ..aOM<$1.Pagination>(5, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
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
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get userId => $_getN(1);
  @$pb.TagNumber(2)
  set userId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureUserId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get unreadOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set unreadOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnreadOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnreadOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  NotificationPriority get minPriority => $_getN(3);
  @$pb.TagNumber(4)
  set minPriority(NotificationPriority value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMinPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinPriority() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Pagination get pagination => $_getN(4);
  @$pb.TagNumber(5)
  set pagination($1.Pagination value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPagination() => $_has(4);
  @$pb.TagNumber(5)
  void clearPagination() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Pagination ensurePagination() => $_ensure(4);
}

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<NotificationItem>? notifications,
    $1.PaginatedResponse? pagination,
    $core.int? unreadCount,
  }) {
    final result = ListResponse._();
    if (notifications != null) result.notifications.addAll(notifications);
    if (pagination != null) result.pagination = pagination;
    if (unreadCount != null) result.unreadCount = unreadCount;
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
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListResponse.$_createMessage)
    ..pPM<NotificationItem>(1, _omitFieldNames ? '' : 'notifications',
        subBuilder: NotificationItem.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'unreadCount')
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
  $pb.PbList<NotificationItem> get notifications => $_getList(0);

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

  @$pb.TagNumber(3)
  $core.int get unreadCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set unreadCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnreadCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnreadCount() => $_clearField(3);
}

class MarkReadRequest extends $pb.GeneratedMessage {
  factory MarkReadRequest({
    $1.UUID? workspaceId,
    $1.UUID? userId,
    $1.UUID? notificationId,
  }) {
    final result = MarkReadRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (notificationId != null) result.notificationId = notificationId;
    return result;
  }

  MarkReadRequest._();

  factory MarkReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkReadRequest()..mergeFromBuffer(data, registry);
  factory MarkReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkReadRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: MarkReadRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(3, _omitFieldNames ? '' : 'notificationId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkReadRequest copyWith(void Function(MarkReadRequest) updates) =>
      super.copyWith((message) => updates(message as MarkReadRequest))
          as MarkReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MarkReadRequest() / MarkReadRequest.new instead')
  static MarkReadRequest create() => MarkReadRequest._();
  static $pb.GeneratedMessage $_createMessage() => MarkReadRequest._();
  @$core.override
  MarkReadRequest createEmptyInstance() => MarkReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkReadRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarkReadRequest>(
          MarkReadRequest.$_createMessage);
  static MarkReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get userId => $_getN(1);
  @$pb.TagNumber(2)
  set userId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureUserId() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.UUID get notificationId => $_getN(2);
  @$pb.TagNumber(3)
  set notificationId($1.UUID value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNotificationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotificationId() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.UUID ensureNotificationId() => $_ensure(2);
}

class MarkReadResponse extends $pb.GeneratedMessage {
  factory MarkReadResponse({
    $core.bool? success,
    $2.Timestamp? readAt,
  }) {
    final result = MarkReadResponse._();
    if (success != null) result.success = success;
    if (readAt != null) result.readAt = readAt;
    return result;
  }

  MarkReadResponse._();

  factory MarkReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkReadResponse()..mergeFromBuffer(data, registry);
  factory MarkReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkReadResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: MarkReadResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'readAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkReadResponse copyWith(void Function(MarkReadResponse) updates) =>
      super.copyWith((message) => updates(message as MarkReadResponse))
          as MarkReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MarkReadResponse() / MarkReadResponse.new instead')
  static MarkReadResponse create() => MarkReadResponse._();
  static $pb.GeneratedMessage $_createMessage() => MarkReadResponse._();
  @$core.override
  MarkReadResponse createEmptyInstance() => MarkReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkReadResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarkReadResponse>(
          MarkReadResponse.$_createMessage);
  static MarkReadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Timestamp get readAt => $_getN(1);
  @$pb.TagNumber(2)
  set readAt($2.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReadAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearReadAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureReadAt() => $_ensure(1);
}

class MarkAllReadRequest extends $pb.GeneratedMessage {
  factory MarkAllReadRequest({
    $1.UUID? workspaceId,
    $1.UUID? userId,
  }) {
    final result = MarkAllReadRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    return result;
  }

  MarkAllReadRequest._();

  factory MarkAllReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAllReadRequest()..mergeFromBuffer(data, registry);
  factory MarkAllReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAllReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAllReadRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: MarkAllReadRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllReadRequest copyWith(void Function(MarkAllReadRequest) updates) =>
      super.copyWith((message) => updates(message as MarkAllReadRequest))
          as MarkAllReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MarkAllReadRequest() / MarkAllReadRequest.new instead')
  static MarkAllReadRequest create() => MarkAllReadRequest._();
  static $pb.GeneratedMessage $_createMessage() => MarkAllReadRequest._();
  @$core.override
  MarkAllReadRequest createEmptyInstance() => MarkAllReadRequest._();
  @$core.pragma('dart2js:noInline')
  static MarkAllReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAllReadRequest>(
          MarkAllReadRequest.$_createMessage);
  static MarkAllReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get userId => $_getN(1);
  @$pb.TagNumber(2)
  set userId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureUserId() => $_ensure(1);
}

class MarkAllReadResponse extends $pb.GeneratedMessage {
  factory MarkAllReadResponse({
    $core.int? countMarkedRead,
    $2.Timestamp? readAt,
  }) {
    final result = MarkAllReadResponse._();
    if (countMarkedRead != null) result.countMarkedRead = countMarkedRead;
    if (readAt != null) result.readAt = readAt;
    return result;
  }

  MarkAllReadResponse._();

  factory MarkAllReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAllReadResponse()..mergeFromBuffer(data, registry);
  factory MarkAllReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MarkAllReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAllReadResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: MarkAllReadResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'countMarkedRead')
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'readAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllReadResponse copyWith(void Function(MarkAllReadResponse) updates) =>
      super.copyWith((message) => updates(message as MarkAllReadResponse))
          as MarkAllReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use MarkAllReadResponse() / MarkAllReadResponse.new instead')
  static MarkAllReadResponse create() => MarkAllReadResponse._();
  static $pb.GeneratedMessage $_createMessage() => MarkAllReadResponse._();
  @$core.override
  MarkAllReadResponse createEmptyInstance() => MarkAllReadResponse._();
  @$core.pragma('dart2js:noInline')
  static MarkAllReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAllReadResponse>(
          MarkAllReadResponse.$_createMessage);
  static MarkAllReadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get countMarkedRead => $_getIZ(0);
  @$pb.TagNumber(1)
  set countMarkedRead($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountMarkedRead() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountMarkedRead() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Timestamp get readAt => $_getN(1);
  @$pb.TagNumber(2)
  set readAt($2.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReadAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearReadAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureReadAt() => $_ensure(1);
}

class DismissRequest extends $pb.GeneratedMessage {
  factory DismissRequest({
    $1.UUID? workspaceId,
    $1.UUID? userId,
    $1.UUID? notificationId,
  }) {
    final result = DismissRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (notificationId != null) result.notificationId = notificationId;
    return result;
  }

  DismissRequest._();

  factory DismissRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissRequest()..mergeFromBuffer(data, registry);
  factory DismissRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: DismissRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(3, _omitFieldNames ? '' : 'notificationId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissRequest copyWith(void Function(DismissRequest) updates) =>
      super.copyWith((message) => updates(message as DismissRequest))
          as DismissRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DismissRequest() / DismissRequest.new instead')
  static DismissRequest create() => DismissRequest._();
  static $pb.GeneratedMessage $_createMessage() => DismissRequest._();
  @$core.override
  DismissRequest createEmptyInstance() => DismissRequest._();
  @$core.pragma('dart2js:noInline')
  static DismissRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DismissRequest>(
          DismissRequest.$_createMessage);
  static DismissRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get userId => $_getN(1);
  @$pb.TagNumber(2)
  set userId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureUserId() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.UUID get notificationId => $_getN(2);
  @$pb.TagNumber(3)
  set notificationId($1.UUID value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNotificationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotificationId() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.UUID ensureNotificationId() => $_ensure(2);
}

class DismissResponse extends $pb.GeneratedMessage {
  factory DismissResponse({
    $core.bool? success,
    $2.Timestamp? dismissedAt,
  }) {
    final result = DismissResponse._();
    if (success != null) result.success = success;
    if (dismissedAt != null) result.dismissedAt = dismissedAt;
    return result;
  }

  DismissResponse._();

  factory DismissResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissResponse()..mergeFromBuffer(data, registry);
  factory DismissResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: DismissResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'dismissedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissResponse copyWith(void Function(DismissResponse) updates) =>
      super.copyWith((message) => updates(message as DismissResponse))
          as DismissResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DismissResponse() / DismissResponse.new instead')
  static DismissResponse create() => DismissResponse._();
  static $pb.GeneratedMessage $_createMessage() => DismissResponse._();
  @$core.override
  DismissResponse createEmptyInstance() => DismissResponse._();
  @$core.pragma('dart2js:noInline')
  static DismissResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DismissResponse>(
          DismissResponse.$_createMessage);
  static DismissResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Timestamp get dismissedAt => $_getN(1);
  @$pb.TagNumber(2)
  set dismissedAt($2.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDismissedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearDismissedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureDismissedAt() => $_ensure(1);
}

class GetUnreadCountRequest extends $pb.GeneratedMessage {
  factory GetUnreadCountRequest({
    $1.UUID? workspaceId,
    $1.UUID? userId,
  }) {
    final result = GetUnreadCountRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    return result;
  }

  GetUnreadCountRequest._();

  factory GetUnreadCountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUnreadCountRequest()..mergeFromBuffer(data, registry);
  factory GetUnreadCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUnreadCountRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnreadCountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetUnreadCountRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnreadCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnreadCountRequest copyWith(
          void Function(GetUnreadCountRequest) updates) =>
      super.copyWith((message) => updates(message as GetUnreadCountRequest))
          as GetUnreadCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUnreadCountRequest() / GetUnreadCountRequest.new instead')
  static GetUnreadCountRequest create() => GetUnreadCountRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetUnreadCountRequest._();
  @$core.override
  GetUnreadCountRequest createEmptyInstance() => GetUnreadCountRequest._();
  @$core.pragma('dart2js:noInline')
  static GetUnreadCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnreadCountRequest>(
          GetUnreadCountRequest.$_createMessage);
  static GetUnreadCountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get userId => $_getN(1);
  @$pb.TagNumber(2)
  set userId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureUserId() => $_ensure(1);
}

class GetUnreadCountResponse extends $pb.GeneratedMessage {
  factory GetUnreadCountResponse({
    $core.int? unreadCount,
    $core.int? urgentCount,
  }) {
    final result = GetUnreadCountResponse._();
    if (unreadCount != null) result.unreadCount = unreadCount;
    if (urgentCount != null) result.urgentCount = urgentCount;
    return result;
  }

  GetUnreadCountResponse._();

  factory GetUnreadCountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUnreadCountResponse()..mergeFromBuffer(data, registry);
  factory GetUnreadCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUnreadCountResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnreadCountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetUnreadCountResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'unreadCount')
    ..aI(2, _omitFieldNames ? '' : 'urgentCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnreadCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnreadCountResponse copyWith(
          void Function(GetUnreadCountResponse) updates) =>
      super.copyWith((message) => updates(message as GetUnreadCountResponse))
          as GetUnreadCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUnreadCountResponse() / GetUnreadCountResponse.new instead')
  static GetUnreadCountResponse create() => GetUnreadCountResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetUnreadCountResponse._();
  @$core.override
  GetUnreadCountResponse createEmptyInstance() => GetUnreadCountResponse._();
  @$core.pragma('dart2js:noInline')
  static GetUnreadCountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnreadCountResponse>(
          GetUnreadCountResponse.$_createMessage);
  static GetUnreadCountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unreadCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set unreadCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnreadCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnreadCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get urgentCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set urgentCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrgentCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrgentCount() => $_clearField(2);
}

class NotificationPreferences extends $pb.GeneratedMessage {
  factory NotificationPreferences({
    $core.bool? emailEnabled,
    $core.bool? pushEnabled,
    $core.bool? inAppEnabled,
    $core.bool? quietHoursEnabled,
    $core.String? quietHoursStart,
    $core.String? quietHoursEnd,
    $core.String? digestFrequency,
  }) {
    final result = NotificationPreferences._();
    if (emailEnabled != null) result.emailEnabled = emailEnabled;
    if (pushEnabled != null) result.pushEnabled = pushEnabled;
    if (inAppEnabled != null) result.inAppEnabled = inAppEnabled;
    if (quietHoursEnabled != null) result.quietHoursEnabled = quietHoursEnabled;
    if (quietHoursStart != null) result.quietHoursStart = quietHoursStart;
    if (quietHoursEnd != null) result.quietHoursEnd = quietHoursEnd;
    if (digestFrequency != null) result.digestFrequency = digestFrequency;
    return result;
  }

  NotificationPreferences._();

  factory NotificationPreferences.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationPreferences()..mergeFromBuffer(data, registry);
  factory NotificationPreferences.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationPreferences()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationPreferences',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: NotificationPreferences.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'emailEnabled')
    ..aOB(2, _omitFieldNames ? '' : 'pushEnabled')
    ..aOB(3, _omitFieldNames ? '' : 'inAppEnabled')
    ..aOB(4, _omitFieldNames ? '' : 'quietHoursEnabled')
    ..aOS(5, _omitFieldNames ? '' : 'quietHoursStart')
    ..aOS(6, _omitFieldNames ? '' : 'quietHoursEnd')
    ..aOS(7, _omitFieldNames ? '' : 'digestFrequency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationPreferences clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationPreferences copyWith(
          void Function(NotificationPreferences) updates) =>
      super.copyWith((message) => updates(message as NotificationPreferences))
          as NotificationPreferences;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use NotificationPreferences() / NotificationPreferences.new instead')
  static NotificationPreferences create() => NotificationPreferences._();
  static $pb.GeneratedMessage $_createMessage() => NotificationPreferences._();
  @$core.override
  NotificationPreferences createEmptyInstance() => NotificationPreferences._();
  @$core.pragma('dart2js:noInline')
  static NotificationPreferences getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationPreferences>(
          NotificationPreferences.$_createMessage);
  static NotificationPreferences? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get emailEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set emailEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmailEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmailEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get pushEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set pushEnabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPushEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearPushEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get inAppEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set inAppEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInAppEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearInAppEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get quietHoursEnabled => $_getBF(3);
  @$pb.TagNumber(4)
  set quietHoursEnabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuietHoursEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuietHoursEnabled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get quietHoursStart => $_getSZ(4);
  @$pb.TagNumber(5)
  set quietHoursStart($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuietHoursStart() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuietHoursStart() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get quietHoursEnd => $_getSZ(5);
  @$pb.TagNumber(6)
  set quietHoursEnd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuietHoursEnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuietHoursEnd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get digestFrequency => $_getSZ(6);
  @$pb.TagNumber(7)
  set digestFrequency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDigestFrequency() => $_has(6);
  @$pb.TagNumber(7)
  void clearDigestFrequency() => $_clearField(7);
}

class GetPreferencesRequest extends $pb.GeneratedMessage {
  factory GetPreferencesRequest({
    $1.UUID? workspaceId,
    $1.UUID? userId,
  }) {
    final result = GetPreferencesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    return result;
  }

  GetPreferencesRequest._();

  factory GetPreferencesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPreferencesRequest()..mergeFromBuffer(data, registry);
  factory GetPreferencesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPreferencesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPreferencesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetPreferencesRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreferencesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreferencesRequest copyWith(
          void Function(GetPreferencesRequest) updates) =>
      super.copyWith((message) => updates(message as GetPreferencesRequest))
          as GetPreferencesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPreferencesRequest() / GetPreferencesRequest.new instead')
  static GetPreferencesRequest create() => GetPreferencesRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPreferencesRequest._();
  @$core.override
  GetPreferencesRequest createEmptyInstance() => GetPreferencesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPreferencesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPreferencesRequest>(
          GetPreferencesRequest.$_createMessage);
  static GetPreferencesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get userId => $_getN(1);
  @$pb.TagNumber(2)
  set userId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureUserId() => $_ensure(1);
}

class GetPreferencesResponse extends $pb.GeneratedMessage {
  factory GetPreferencesResponse({
    NotificationPreferences? preferences,
  }) {
    final result = GetPreferencesResponse._();
    if (preferences != null) result.preferences = preferences;
    return result;
  }

  GetPreferencesResponse._();

  factory GetPreferencesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPreferencesResponse()..mergeFromBuffer(data, registry);
  factory GetPreferencesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPreferencesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPreferencesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetPreferencesResponse.$_createMessage)
    ..aOM<NotificationPreferences>(1, _omitFieldNames ? '' : 'preferences',
        subBuilder: NotificationPreferences.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreferencesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreferencesResponse copyWith(
          void Function(GetPreferencesResponse) updates) =>
      super.copyWith((message) => updates(message as GetPreferencesResponse))
          as GetPreferencesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPreferencesResponse() / GetPreferencesResponse.new instead')
  static GetPreferencesResponse create() => GetPreferencesResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPreferencesResponse._();
  @$core.override
  GetPreferencesResponse createEmptyInstance() => GetPreferencesResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPreferencesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPreferencesResponse>(
          GetPreferencesResponse.$_createMessage);
  static GetPreferencesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  NotificationPreferences get preferences => $_getN(0);
  @$pb.TagNumber(1)
  set preferences(NotificationPreferences value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPreferences() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreferences() => $_clearField(1);
  @$pb.TagNumber(1)
  NotificationPreferences ensurePreferences() => $_ensure(0);
}

class UpdatePreferencesRequest extends $pb.GeneratedMessage {
  factory UpdatePreferencesRequest({
    $1.UUID? workspaceId,
    $1.UUID? userId,
    NotificationPreferences? preferences,
  }) {
    final result = UpdatePreferencesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (preferences != null) result.preferences = preferences;
    return result;
  }

  UpdatePreferencesRequest._();

  factory UpdatePreferencesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePreferencesRequest()..mergeFromBuffer(data, registry);
  factory UpdatePreferencesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePreferencesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePreferencesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: UpdatePreferencesRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<NotificationPreferences>(3, _omitFieldNames ? '' : 'preferences',
        subBuilder: NotificationPreferences.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePreferencesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePreferencesRequest copyWith(
          void Function(UpdatePreferencesRequest) updates) =>
      super.copyWith((message) => updates(message as UpdatePreferencesRequest))
          as UpdatePreferencesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdatePreferencesRequest() / UpdatePreferencesRequest.new instead')
  static UpdatePreferencesRequest create() => UpdatePreferencesRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdatePreferencesRequest._();
  @$core.override
  UpdatePreferencesRequest createEmptyInstance() =>
      UpdatePreferencesRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdatePreferencesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePreferencesRequest>(
          UpdatePreferencesRequest.$_createMessage);
  static UpdatePreferencesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get userId => $_getN(1);
  @$pb.TagNumber(2)
  set userId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureUserId() => $_ensure(1);

  @$pb.TagNumber(3)
  NotificationPreferences get preferences => $_getN(2);
  @$pb.TagNumber(3)
  set preferences(NotificationPreferences value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPreferences() => $_has(2);
  @$pb.TagNumber(3)
  void clearPreferences() => $_clearField(3);
  @$pb.TagNumber(3)
  NotificationPreferences ensurePreferences() => $_ensure(2);
}

class UpdatePreferencesResponse extends $pb.GeneratedMessage {
  factory UpdatePreferencesResponse({
    NotificationPreferences? preferences,
    $2.Timestamp? updatedAt,
  }) {
    final result = UpdatePreferencesResponse._();
    if (preferences != null) result.preferences = preferences;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  UpdatePreferencesResponse._();

  factory UpdatePreferencesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePreferencesResponse()..mergeFromBuffer(data, registry);
  factory UpdatePreferencesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePreferencesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePreferencesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: UpdatePreferencesResponse.$_createMessage)
    ..aOM<NotificationPreferences>(1, _omitFieldNames ? '' : 'preferences',
        subBuilder: NotificationPreferences.$_createMessage)
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePreferencesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePreferencesResponse copyWith(
          void Function(UpdatePreferencesResponse) updates) =>
      super.copyWith((message) => updates(message as UpdatePreferencesResponse))
          as UpdatePreferencesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdatePreferencesResponse() / UpdatePreferencesResponse.new instead')
  static UpdatePreferencesResponse create() => UpdatePreferencesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdatePreferencesResponse._();
  @$core.override
  UpdatePreferencesResponse createEmptyInstance() =>
      UpdatePreferencesResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdatePreferencesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePreferencesResponse>(
          UpdatePreferencesResponse.$_createMessage);
  static UpdatePreferencesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  NotificationPreferences get preferences => $_getN(0);
  @$pb.TagNumber(1)
  set preferences(NotificationPreferences value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPreferences() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreferences() => $_clearField(1);
  @$pb.TagNumber(1)
  NotificationPreferences ensurePreferences() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Timestamp get updatedAt => $_getN(1);
  @$pb.TagNumber(2)
  set updatedAt($2.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdatedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureUpdatedAt() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/engagement/v1/engagement.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import '../../common/v1/types.pb.dart' as $2;
import 'engagement.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'engagement.pbenum.dart';

/// RelatedObjectRef links a thread to downstream business objects (RULE-M12-005).
class RelatedObjectRef extends $pb.GeneratedMessage {
  factory RelatedObjectRef({
    $core.String? type,
    $core.String? id,
    $core.String? label,
    $core.String? taskRef,
    $core.String? phase,
    $core.bool? isP6Deferred,
    $core.String? status,
  }) {
    final result = RelatedObjectRef._();
    if (type != null) result.type = type;
    if (id != null) result.id = id;
    if (label != null) result.label = label;
    if (taskRef != null) result.taskRef = taskRef;
    if (phase != null) result.phase = phase;
    if (isP6Deferred != null) result.isP6Deferred = isP6Deferred;
    if (status != null) result.status = status;
    return result;
  }

  RelatedObjectRef._();

  factory RelatedObjectRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelatedObjectRef()..mergeFromBuffer(data, registry);
  factory RelatedObjectRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelatedObjectRef()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelatedObjectRef',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: RelatedObjectRef.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aOS(4, _omitFieldNames ? '' : 'taskRef')
    ..aOS(5, _omitFieldNames ? '' : 'phase')
    ..aOB(6, _omitFieldNames ? '' : 'isP6Deferred')
    ..aOS(7, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedObjectRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedObjectRef copyWith(void Function(RelatedObjectRef) updates) =>
      super.copyWith((message) => updates(message as RelatedObjectRef))
          as RelatedObjectRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelatedObjectRef() / RelatedObjectRef.new instead')
  static RelatedObjectRef create() => RelatedObjectRef._();
  static $pb.GeneratedMessage $_createMessage() => RelatedObjectRef._();
  @$core.override
  RelatedObjectRef createEmptyInstance() => RelatedObjectRef._();
  @$core.pragma('dart2js:noInline')
  static RelatedObjectRef getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelatedObjectRef>(
          RelatedObjectRef.$_createMessage);
  static RelatedObjectRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get taskRef => $_getSZ(3);
  @$pb.TagNumber(4)
  set taskRef($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTaskRef() => $_has(3);
  @$pb.TagNumber(4)
  void clearTaskRef() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get phase => $_getSZ(4);
  @$pb.TagNumber(5)
  set phase($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPhase() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhase() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isP6Deferred => $_getBF(5);
  @$pb.TagNumber(6)
  set isP6Deferred($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsP6Deferred() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsP6Deferred() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get status => $_getSZ(6);
  @$pb.TagNumber(7)
  set status($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);
}

/// ReplyIdentity represents the color-coded sender badge in multi-account compose (RULE-M12-006).
class ReplyIdentity extends $pb.GeneratedMessage {
  factory ReplyIdentity({
    $core.String? accountId,
    $core.String? platform,
    $core.String? accountName,
    $core.String? avatarUrl,
    $core.String? badgeColor,
    $core.bool? isRevoked,
  }) {
    final result = ReplyIdentity._();
    if (accountId != null) result.accountId = accountId;
    if (platform != null) result.platform = platform;
    if (accountName != null) result.accountName = accountName;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (badgeColor != null) result.badgeColor = badgeColor;
    if (isRevoked != null) result.isRevoked = isRevoked;
    return result;
  }

  ReplyIdentity._();

  factory ReplyIdentity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyIdentity()..mergeFromBuffer(data, registry);
  factory ReplyIdentity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyIdentity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyIdentity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ReplyIdentity.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'accountName')
    ..aOS(4, _omitFieldNames ? '' : 'avatarUrl')
    ..aOS(5, _omitFieldNames ? '' : 'badgeColor')
    ..aOB(6, _omitFieldNames ? '' : 'isRevoked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyIdentity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyIdentity copyWith(void Function(ReplyIdentity) updates) =>
      super.copyWith((message) => updates(message as ReplyIdentity))
          as ReplyIdentity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReplyIdentity() / ReplyIdentity.new instead')
  static ReplyIdentity create() => ReplyIdentity._();
  static $pb.GeneratedMessage $_createMessage() => ReplyIdentity._();
  @$core.override
  ReplyIdentity createEmptyInstance() => ReplyIdentity._();
  @$core.pragma('dart2js:noInline')
  static ReplyIdentity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReplyIdentity>(
          ReplyIdentity.$_createMessage);
  static ReplyIdentity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get accountName => $_getSZ(2);
  @$pb.TagNumber(3)
  set accountName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccountName() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get avatarUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set avatarUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvatarUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatarUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get badgeColor => $_getSZ(4);
  @$pb.TagNumber(5)
  set badgeColor($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBadgeColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearBadgeColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isRevoked => $_getBF(5);
  @$pb.TagNumber(6)
  set isRevoked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsRevoked() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsRevoked() => $_clearField(6);
}

/// Thread represents the canonical engagement thread operating object (database_schema.md §9.2).
class Thread extends $pb.GeneratedMessage {
  factory Thread({
    $core.String? threadId,
    $core.String? workspaceId,
    ThreadType? threadType,
    $core.String? entityId,
    $core.String? sourcePlatform,
    $core.String? sourcePostId,
    $core.String? ownerUserId,
    ThreadIntent? intent,
    ThreadPriority? priority,
    ThreadStatus? status,
    $core.String? nextAction,
    $1.Timestamp? slaDueAt,
    $core.Iterable<RelatedObjectRef>? relatedObjectRefs,
    $1.Timestamp? lastActivityAt,
    $core.int? messageCount,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $1.Timestamp? messagingWindowExpiresAt,
    $core.bool? messagingWindowExpired,
    $core.bool? autoReplyPaused,
    $core.int? autoReplyConsecutiveCount,
    $core.int? autoReplyHourCount,
    $core.bool? autoReplyPermanentlyDisabled,
    $core.bool? isGhost,
    GhostStatus? ghostStatus,
    ThrottleMode? throttleState,
    $core.String? connectedAccountId,
    $core.bool? accountRevoked,
    ReplyIdentity? replyIdentity,
  }) {
    final result = Thread._();
    if (threadId != null) result.threadId = threadId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadType != null) result.threadType = threadType;
    if (entityId != null) result.entityId = entityId;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (sourcePostId != null) result.sourcePostId = sourcePostId;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (intent != null) result.intent = intent;
    if (priority != null) result.priority = priority;
    if (status != null) result.status = status;
    if (nextAction != null) result.nextAction = nextAction;
    if (slaDueAt != null) result.slaDueAt = slaDueAt;
    if (relatedObjectRefs != null)
      result.relatedObjectRefs.addAll(relatedObjectRefs);
    if (lastActivityAt != null) result.lastActivityAt = lastActivityAt;
    if (messageCount != null) result.messageCount = messageCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (messagingWindowExpiresAt != null)
      result.messagingWindowExpiresAt = messagingWindowExpiresAt;
    if (messagingWindowExpired != null)
      result.messagingWindowExpired = messagingWindowExpired;
    if (autoReplyPaused != null) result.autoReplyPaused = autoReplyPaused;
    if (autoReplyConsecutiveCount != null)
      result.autoReplyConsecutiveCount = autoReplyConsecutiveCount;
    if (autoReplyHourCount != null)
      result.autoReplyHourCount = autoReplyHourCount;
    if (autoReplyPermanentlyDisabled != null)
      result.autoReplyPermanentlyDisabled = autoReplyPermanentlyDisabled;
    if (isGhost != null) result.isGhost = isGhost;
    if (ghostStatus != null) result.ghostStatus = ghostStatus;
    if (throttleState != null) result.throttleState = throttleState;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (accountRevoked != null) result.accountRevoked = accountRevoked;
    if (replyIdentity != null) result.replyIdentity = replyIdentity;
    return result;
  }

  Thread._();

  factory Thread.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Thread()..mergeFromBuffer(data, registry);
  factory Thread.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Thread()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Thread',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: Thread.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'threadId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<ThreadType>(3, _omitFieldNames ? '' : 'threadType',
        enumValues: ThreadType.values)
    ..aOS(4, _omitFieldNames ? '' : 'entityId')
    ..aOS(5, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(6, _omitFieldNames ? '' : 'sourcePostId')
    ..aOS(7, _omitFieldNames ? '' : 'ownerUserId')
    ..aE<ThreadIntent>(8, _omitFieldNames ? '' : 'intent',
        enumValues: ThreadIntent.values)
    ..aE<ThreadPriority>(9, _omitFieldNames ? '' : 'priority',
        enumValues: ThreadPriority.values)
    ..aE<ThreadStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: ThreadStatus.values)
    ..aOS(11, _omitFieldNames ? '' : 'nextAction')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'slaDueAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..pPM<RelatedObjectRef>(13, _omitFieldNames ? '' : 'relatedObjectRefs',
        subBuilder: RelatedObjectRef.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'lastActivityAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aI(15, _omitFieldNames ? '' : 'messageCount')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'messagingWindowExpiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOB(19, _omitFieldNames ? '' : 'messagingWindowExpired')
    ..aOB(20, _omitFieldNames ? '' : 'autoReplyPaused')
    ..aI(21, _omitFieldNames ? '' : 'autoReplyConsecutiveCount')
    ..aI(22, _omitFieldNames ? '' : 'autoReplyHourCount')
    ..aOB(23, _omitFieldNames ? '' : 'autoReplyPermanentlyDisabled')
    ..aOB(24, _omitFieldNames ? '' : 'isGhost')
    ..aE<GhostStatus>(25, _omitFieldNames ? '' : 'ghostStatus',
        enumValues: GhostStatus.values)
    ..aE<ThrottleMode>(26, _omitFieldNames ? '' : 'throttleState',
        enumValues: ThrottleMode.values)
    ..aOS(27, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOB(28, _omitFieldNames ? '' : 'accountRevoked')
    ..aOM<ReplyIdentity>(29, _omitFieldNames ? '' : 'replyIdentity',
        subBuilder: ReplyIdentity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Thread clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Thread copyWith(void Function(Thread) updates) =>
      super.copyWith((message) => updates(message as Thread)) as Thread;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Thread() / Thread.new instead')
  static Thread create() => Thread._();
  static $pb.GeneratedMessage $_createMessage() => Thread._();
  @$core.override
  Thread createEmptyInstance() => Thread._();
  @$core.pragma('dart2js:noInline')
  static Thread getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Thread>(Thread.$_createMessage);
  static Thread? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get threadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set threadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasThreadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearThreadId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  ThreadType get threadType => $_getN(2);
  @$pb.TagNumber(3)
  set threadType(ThreadType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadType() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get entityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set entityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourcePlatform => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourcePlatform($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourcePlatform() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourcePlatform() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourcePostId => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourcePostId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourcePostId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourcePostId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get ownerUserId => $_getSZ(6);
  @$pb.TagNumber(7)
  set ownerUserId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOwnerUserId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOwnerUserId() => $_clearField(7);

  @$pb.TagNumber(8)
  ThreadIntent get intent => $_getN(7);
  @$pb.TagNumber(8)
  set intent(ThreadIntent value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasIntent() => $_has(7);
  @$pb.TagNumber(8)
  void clearIntent() => $_clearField(8);

  @$pb.TagNumber(9)
  ThreadPriority get priority => $_getN(8);
  @$pb.TagNumber(9)
  set priority(ThreadPriority value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPriority() => $_has(8);
  @$pb.TagNumber(9)
  void clearPriority() => $_clearField(9);

  @$pb.TagNumber(10)
  ThreadStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(ThreadStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get nextAction => $_getSZ(10);
  @$pb.TagNumber(11)
  set nextAction($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNextAction() => $_has(10);
  @$pb.TagNumber(11)
  void clearNextAction() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Timestamp get slaDueAt => $_getN(11);
  @$pb.TagNumber(12)
  set slaDueAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSlaDueAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearSlaDueAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureSlaDueAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $pb.PbList<RelatedObjectRef> get relatedObjectRefs => $_getList(12);

  @$pb.TagNumber(14)
  $1.Timestamp get lastActivityAt => $_getN(13);
  @$pb.TagNumber(14)
  set lastActivityAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasLastActivityAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearLastActivityAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureLastActivityAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.int get messageCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set messageCount($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasMessageCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearMessageCount() => $_clearField(15);

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
  $1.Timestamp get messagingWindowExpiresAt => $_getN(17);
  @$pb.TagNumber(18)
  set messagingWindowExpiresAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasMessagingWindowExpiresAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearMessagingWindowExpiresAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureMessagingWindowExpiresAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $core.bool get messagingWindowExpired => $_getBF(18);
  @$pb.TagNumber(19)
  set messagingWindowExpired($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasMessagingWindowExpired() => $_has(18);
  @$pb.TagNumber(19)
  void clearMessagingWindowExpired() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.bool get autoReplyPaused => $_getBF(19);
  @$pb.TagNumber(20)
  set autoReplyPaused($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasAutoReplyPaused() => $_has(19);
  @$pb.TagNumber(20)
  void clearAutoReplyPaused() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.int get autoReplyConsecutiveCount => $_getIZ(20);
  @$pb.TagNumber(21)
  set autoReplyConsecutiveCount($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasAutoReplyConsecutiveCount() => $_has(20);
  @$pb.TagNumber(21)
  void clearAutoReplyConsecutiveCount() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.int get autoReplyHourCount => $_getIZ(21);
  @$pb.TagNumber(22)
  set autoReplyHourCount($core.int value) => $_setSignedInt32(21, value);
  @$pb.TagNumber(22)
  $core.bool hasAutoReplyHourCount() => $_has(21);
  @$pb.TagNumber(22)
  void clearAutoReplyHourCount() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.bool get autoReplyPermanentlyDisabled => $_getBF(22);
  @$pb.TagNumber(23)
  set autoReplyPermanentlyDisabled($core.bool value) => $_setBool(22, value);
  @$pb.TagNumber(23)
  $core.bool hasAutoReplyPermanentlyDisabled() => $_has(22);
  @$pb.TagNumber(23)
  void clearAutoReplyPermanentlyDisabled() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.bool get isGhost => $_getBF(23);
  @$pb.TagNumber(24)
  set isGhost($core.bool value) => $_setBool(23, value);
  @$pb.TagNumber(24)
  $core.bool hasIsGhost() => $_has(23);
  @$pb.TagNumber(24)
  void clearIsGhost() => $_clearField(24);

  @$pb.TagNumber(25)
  GhostStatus get ghostStatus => $_getN(24);
  @$pb.TagNumber(25)
  set ghostStatus(GhostStatus value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasGhostStatus() => $_has(24);
  @$pb.TagNumber(25)
  void clearGhostStatus() => $_clearField(25);

  @$pb.TagNumber(26)
  ThrottleMode get throttleState => $_getN(25);
  @$pb.TagNumber(26)
  set throttleState(ThrottleMode value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasThrottleState() => $_has(25);
  @$pb.TagNumber(26)
  void clearThrottleState() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.String get connectedAccountId => $_getSZ(26);
  @$pb.TagNumber(27)
  set connectedAccountId($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasConnectedAccountId() => $_has(26);
  @$pb.TagNumber(27)
  void clearConnectedAccountId() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.bool get accountRevoked => $_getBF(27);
  @$pb.TagNumber(28)
  set accountRevoked($core.bool value) => $_setBool(27, value);
  @$pb.TagNumber(28)
  $core.bool hasAccountRevoked() => $_has(27);
  @$pb.TagNumber(28)
  void clearAccountRevoked() => $_clearField(28);

  @$pb.TagNumber(29)
  ReplyIdentity get replyIdentity => $_getN(28);
  @$pb.TagNumber(29)
  set replyIdentity(ReplyIdentity value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasReplyIdentity() => $_has(28);
  @$pb.TagNumber(29)
  void clearReplyIdentity() => $_clearField(29);
  @$pb.TagNumber(29)
  ReplyIdentity ensureReplyIdentity() => $_ensure(28);
}

/// Message represents an individual comment, DM, or system note (database_schema.md §9.3).
class Message extends $pb.GeneratedMessage {
  factory Message({
    $core.String? messageId,
    $core.String? workspaceId,
    $core.String? threadId,
    MessageSubtype? subtype,
    $core.String? sourcePlatform,
    $core.String? body,
    AuthorDirection? authorDirection,
    $core.String? authorEntityId,
    $core.String? authorUserId,
    $core.String? moderationState,
    $core.String? intentOverlay,
    $core.Iterable<$core.String>? attachments,
    $core.String? externalMessageId,
    $1.Timestamp? createdAt,
  }) {
    final result = Message._();
    if (messageId != null) result.messageId = messageId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (subtype != null) result.subtype = subtype;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (body != null) result.body = body;
    if (authorDirection != null) result.authorDirection = authorDirection;
    if (authorEntityId != null) result.authorEntityId = authorEntityId;
    if (authorUserId != null) result.authorUserId = authorUserId;
    if (moderationState != null) result.moderationState = moderationState;
    if (intentOverlay != null) result.intentOverlay = intentOverlay;
    if (attachments != null) result.attachments.addAll(attachments);
    if (externalMessageId != null) result.externalMessageId = externalMessageId;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Message._();

  factory Message.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Message()..mergeFromBuffer(data, registry);
  factory Message.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Message()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Message',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: Message.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'messageId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aE<MessageSubtype>(4, _omitFieldNames ? '' : 'subtype',
        enumValues: MessageSubtype.values)
    ..aOS(5, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(6, _omitFieldNames ? '' : 'body')
    ..aE<AuthorDirection>(7, _omitFieldNames ? '' : 'authorDirection',
        enumValues: AuthorDirection.values)
    ..aOS(8, _omitFieldNames ? '' : 'authorEntityId')
    ..aOS(9, _omitFieldNames ? '' : 'authorUserId')
    ..aOS(10, _omitFieldNames ? '' : 'moderationState')
    ..aOS(11, _omitFieldNames ? '' : 'intentOverlay')
    ..pPS(12, _omitFieldNames ? '' : 'attachments')
    ..aOS(13, _omitFieldNames ? '' : 'externalMessageId')
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message copyWith(void Function(Message) updates) =>
      super.copyWith((message) => updates(message as Message)) as Message;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Message() / Message.new instead')
  static Message create() => Message._();
  static $pb.GeneratedMessage $_createMessage() => Message._();
  @$core.override
  Message createEmptyInstance() => Message._();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Message>(Message.$_createMessage);
  static Message? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  MessageSubtype get subtype => $_getN(3);
  @$pb.TagNumber(4)
  set subtype(MessageSubtype value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtype() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtype() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourcePlatform => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourcePlatform($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourcePlatform() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourcePlatform() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get body => $_getSZ(5);
  @$pb.TagNumber(6)
  set body($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBody() => $_has(5);
  @$pb.TagNumber(6)
  void clearBody() => $_clearField(6);

  @$pb.TagNumber(7)
  AuthorDirection get authorDirection => $_getN(6);
  @$pb.TagNumber(7)
  set authorDirection(AuthorDirection value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthorDirection() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthorDirection() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get authorEntityId => $_getSZ(7);
  @$pb.TagNumber(8)
  set authorEntityId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthorEntityId() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthorEntityId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get authorUserId => $_getSZ(8);
  @$pb.TagNumber(9)
  set authorUserId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAuthorUserId() => $_has(8);
  @$pb.TagNumber(9)
  void clearAuthorUserId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get moderationState => $_getSZ(9);
  @$pb.TagNumber(10)
  set moderationState($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasModerationState() => $_has(9);
  @$pb.TagNumber(10)
  void clearModerationState() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get intentOverlay => $_getSZ(10);
  @$pb.TagNumber(11)
  set intentOverlay($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIntentOverlay() => $_has(10);
  @$pb.TagNumber(11)
  void clearIntentOverlay() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get attachments => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get externalMessageId => $_getSZ(12);
  @$pb.TagNumber(13)
  set externalMessageId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasExternalMessageId() => $_has(12);
  @$pb.TagNumber(13)
  void clearExternalMessageId() => $_clearField(13);

  @$pb.TagNumber(14)
  $1.Timestamp get createdAt => $_getN(13);
  @$pb.TagNumber(14)
  set createdAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureCreatedAt() => $_ensure(13);
}

/// Entity represents a contact or actor across platforms (database_schema.md §9.1).
class Entity extends $pb.GeneratedMessage {
  factory Entity({
    $core.String? entityId,
    $core.String? workspaceId,
    EntityType? entityType,
    $core.String? displayName,
    $core.Iterable<$core.String>? platformHandlesJson,
    EntityRelationshipState? relationshipState,
    $core.Iterable<$core.String>? tags,
    $core.String? metadataJson,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Entity._();
    if (entityId != null) result.entityId = entityId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (entityType != null) result.entityType = entityType;
    if (displayName != null) result.displayName = displayName;
    if (platformHandlesJson != null)
      result.platformHandlesJson.addAll(platformHandlesJson);
    if (relationshipState != null) result.relationshipState = relationshipState;
    if (tags != null) result.tags.addAll(tags);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Entity._();

  factory Entity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Entity()..mergeFromBuffer(data, registry);
  factory Entity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Entity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Entity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: Entity.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'entityId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<EntityType>(3, _omitFieldNames ? '' : 'entityType',
        enumValues: EntityType.values)
    ..aOS(4, _omitFieldNames ? '' : 'displayName')
    ..pPS(5, _omitFieldNames ? '' : 'platformHandlesJson')
    ..aE<EntityRelationshipState>(6, _omitFieldNames ? '' : 'relationshipState',
        enumValues: EntityRelationshipState.values)
    ..pPS(7, _omitFieldNames ? '' : 'tags')
    ..aOS(8, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Entity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Entity copyWith(void Function(Entity) updates) =>
      super.copyWith((message) => updates(message as Entity)) as Entity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Entity() / Entity.new instead')
  static Entity create() => Entity._();
  static $pb.GeneratedMessage $_createMessage() => Entity._();
  @$core.override
  Entity createEmptyInstance() => Entity._();
  @$core.pragma('dart2js:noInline')
  static Entity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Entity>(Entity.$_createMessage);
  static Entity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  EntityType get entityType => $_getN(2);
  @$pb.TagNumber(3)
  set entityType(EntityType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEntityType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayName() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get platformHandlesJson => $_getList(4);

  @$pb.TagNumber(6)
  EntityRelationshipState get relationshipState => $_getN(5);
  @$pb.TagNumber(6)
  set relationshipState(EntityRelationshipState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRelationshipState() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelationshipState() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get tags => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get metadataJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set metadataJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMetadataJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearMetadataJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureUpdatedAt() => $_ensure(9);
}

/// FollowUpTask represents a thread-linked task (database_schema.md §9.4).
class FollowUpTask extends $pb.GeneratedMessage {
  factory FollowUpTask({
    $core.String? taskId,
    $core.String? workspaceId,
    $core.String? sourceThreadId,
    $core.String? sourceObjectType,
    $core.String? sourceObjectId,
    $core.String? assignedUserId,
    $core.String? taskType,
    $core.String? title,
    $core.String? description,
    $1.Timestamp? dueAt,
    FollowUpTaskStatus? status,
    $core.String? outcomeSummary,
    $core.String? taskRef,
    $core.String? phase,
    $core.bool? isP6Deferred,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = FollowUpTask._();
    if (taskId != null) result.taskId = taskId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sourceThreadId != null) result.sourceThreadId = sourceThreadId;
    if (sourceObjectType != null) result.sourceObjectType = sourceObjectType;
    if (sourceObjectId != null) result.sourceObjectId = sourceObjectId;
    if (assignedUserId != null) result.assignedUserId = assignedUserId;
    if (taskType != null) result.taskType = taskType;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (dueAt != null) result.dueAt = dueAt;
    if (status != null) result.status = status;
    if (outcomeSummary != null) result.outcomeSummary = outcomeSummary;
    if (taskRef != null) result.taskRef = taskRef;
    if (phase != null) result.phase = phase;
    if (isP6Deferred != null) result.isP6Deferred = isP6Deferred;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  FollowUpTask._();

  factory FollowUpTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpTask()..mergeFromBuffer(data, registry);
  factory FollowUpTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpTask()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpTask',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpTask.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'sourceThreadId')
    ..aOS(4, _omitFieldNames ? '' : 'sourceObjectType')
    ..aOS(5, _omitFieldNames ? '' : 'sourceObjectId')
    ..aOS(6, _omitFieldNames ? '' : 'assignedUserId')
    ..aOS(7, _omitFieldNames ? '' : 'taskType')
    ..aOS(8, _omitFieldNames ? '' : 'title')
    ..aOS(9, _omitFieldNames ? '' : 'description')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aE<FollowUpTaskStatus>(11, _omitFieldNames ? '' : 'status',
        enumValues: FollowUpTaskStatus.values)
    ..aOS(12, _omitFieldNames ? '' : 'outcomeSummary')
    ..aOS(13, _omitFieldNames ? '' : 'taskRef')
    ..aOS(14, _omitFieldNames ? '' : 'phase')
    ..aOB(15, _omitFieldNames ? '' : 'isP6Deferred')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpTask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpTask copyWith(void Function(FollowUpTask) updates) =>
      super.copyWith((message) => updates(message as FollowUpTask))
          as FollowUpTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FollowUpTask() / FollowUpTask.new instead')
  static FollowUpTask create() => FollowUpTask._();
  static $pb.GeneratedMessage $_createMessage() => FollowUpTask._();
  @$core.override
  FollowUpTask createEmptyInstance() => FollowUpTask._();
  @$core.pragma('dart2js:noInline')
  static FollowUpTask getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FollowUpTask>(
          FollowUpTask.$_createMessage);
  static FollowUpTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceThreadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceThreadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceObjectType => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceObjectType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceObjectType() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceObjectType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourceObjectId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceObjectId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceObjectId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceObjectId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get assignedUserId => $_getSZ(5);
  @$pb.TagNumber(6)
  set assignedUserId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAssignedUserId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssignedUserId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get taskType => $_getSZ(6);
  @$pb.TagNumber(7)
  set taskType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTaskType() => $_has(6);
  @$pb.TagNumber(7)
  void clearTaskType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get title => $_getSZ(7);
  @$pb.TagNumber(8)
  set title($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTitle() => $_has(7);
  @$pb.TagNumber(8)
  void clearTitle() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(9)
  set description($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescription() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get dueAt => $_getN(9);
  @$pb.TagNumber(10)
  set dueAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDueAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearDueAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureDueAt() => $_ensure(9);

  @$pb.TagNumber(11)
  FollowUpTaskStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(FollowUpTaskStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get outcomeSummary => $_getSZ(11);
  @$pb.TagNumber(12)
  set outcomeSummary($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOutcomeSummary() => $_has(11);
  @$pb.TagNumber(12)
  void clearOutcomeSummary() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get taskRef => $_getSZ(12);
  @$pb.TagNumber(13)
  set taskRef($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTaskRef() => $_has(12);
  @$pb.TagNumber(13)
  void clearTaskRef() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get phase => $_getSZ(13);
  @$pb.TagNumber(14)
  set phase($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPhase() => $_has(13);
  @$pb.TagNumber(14)
  void clearPhase() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get isP6Deferred => $_getBF(14);
  @$pb.TagNumber(15)
  set isP6Deferred($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasIsP6Deferred() => $_has(14);
  @$pb.TagNumber(15)
  void clearIsP6Deferred() => $_clearField(15);

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
}

/// EngagementThrottleStatus represents viral surge state (RULE-M12-007).
class EngagementThrottleStatus extends $pb.GeneratedMessage {
  factory EngagementThrottleStatus({
    $core.String? workspaceId,
    $core.int? currentRatePerMin,
    ThrottleMode? throttleMode,
    $core.int? unprocessedRawCount,
    $1.Timestamp? lastSurgeAt,
    $core.String? userNotice,
    $core.bool? requiresManualBatchTrigger,
  }) {
    final result = EngagementThrottleStatus._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (currentRatePerMin != null) result.currentRatePerMin = currentRatePerMin;
    if (throttleMode != null) result.throttleMode = throttleMode;
    if (unprocessedRawCount != null)
      result.unprocessedRawCount = unprocessedRawCount;
    if (lastSurgeAt != null) result.lastSurgeAt = lastSurgeAt;
    if (userNotice != null) result.userNotice = userNotice;
    if (requiresManualBatchTrigger != null)
      result.requiresManualBatchTrigger = requiresManualBatchTrigger;
    return result;
  }

  EngagementThrottleStatus._();

  factory EngagementThrottleStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementThrottleStatus()..mergeFromBuffer(data, registry);
  factory EngagementThrottleStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementThrottleStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EngagementThrottleStatus',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EngagementThrottleStatus.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'currentRatePerMin')
    ..aE<ThrottleMode>(3, _omitFieldNames ? '' : 'throttleMode',
        enumValues: ThrottleMode.values)
    ..aI(4, _omitFieldNames ? '' : 'unprocessedRawCount')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'lastSurgeAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'userNotice')
    ..aOB(7, _omitFieldNames ? '' : 'requiresManualBatchTrigger')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementThrottleStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementThrottleStatus copyWith(
          void Function(EngagementThrottleStatus) updates) =>
      super.copyWith((message) => updates(message as EngagementThrottleStatus))
          as EngagementThrottleStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EngagementThrottleStatus() / EngagementThrottleStatus.new instead')
  static EngagementThrottleStatus create() => EngagementThrottleStatus._();
  static $pb.GeneratedMessage $_createMessage() => EngagementThrottleStatus._();
  @$core.override
  EngagementThrottleStatus createEmptyInstance() =>
      EngagementThrottleStatus._();
  @$core.pragma('dart2js:noInline')
  static EngagementThrottleStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EngagementThrottleStatus>(
          EngagementThrottleStatus.$_createMessage);
  static EngagementThrottleStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get currentRatePerMin => $_getIZ(1);
  @$pb.TagNumber(2)
  set currentRatePerMin($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentRatePerMin() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentRatePerMin() => $_clearField(2);

  @$pb.TagNumber(3)
  ThrottleMode get throttleMode => $_getN(2);
  @$pb.TagNumber(3)
  set throttleMode(ThrottleMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasThrottleMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearThrottleMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get unprocessedRawCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set unprocessedRawCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnprocessedRawCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnprocessedRawCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get lastSurgeAt => $_getN(4);
  @$pb.TagNumber(5)
  set lastSurgeAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastSurgeAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastSurgeAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureLastSurgeAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get userNotice => $_getSZ(5);
  @$pb.TagNumber(6)
  set userNotice($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUserNotice() => $_has(5);
  @$pb.TagNumber(6)
  void clearUserNotice() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get requiresManualBatchTrigger => $_getBF(6);
  @$pb.TagNumber(7)
  set requiresManualBatchTrigger($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRequiresManualBatchTrigger() => $_has(6);
  @$pb.TagNumber(7)
  void clearRequiresManualBatchTrigger() => $_clearField(7);
}

/// SuggestedReply represents AI reply suggestion.
class SuggestedReply extends $pb.GeneratedMessage {
  factory SuggestedReply({
    $core.String? suggestionId,
    $core.String? replyText,
    $core.double? confidence,
    $core.String? tone,
  }) {
    final result = SuggestedReply._();
    if (suggestionId != null) result.suggestionId = suggestionId;
    if (replyText != null) result.replyText = replyText;
    if (confidence != null) result.confidence = confidence;
    if (tone != null) result.tone = tone;
    return result;
  }

  SuggestedReply._();

  factory SuggestedReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestedReply()..mergeFromBuffer(data, registry);
  factory SuggestedReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestedReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestedReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: SuggestedReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'suggestionId')
    ..aOS(2, _omitFieldNames ? '' : 'replyText')
    ..aD(3, _omitFieldNames ? '' : 'confidence')
    ..aOS(4, _omitFieldNames ? '' : 'tone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestedReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestedReply copyWith(void Function(SuggestedReply) updates) =>
      super.copyWith((message) => updates(message as SuggestedReply))
          as SuggestedReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SuggestedReply() / SuggestedReply.new instead')
  static SuggestedReply create() => SuggestedReply._();
  static $pb.GeneratedMessage $_createMessage() => SuggestedReply._();
  @$core.override
  SuggestedReply createEmptyInstance() => SuggestedReply._();
  @$core.pragma('dart2js:noInline')
  static SuggestedReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SuggestedReply>(
          SuggestedReply.$_createMessage);
  static SuggestedReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get suggestionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set suggestionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuggestionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuggestionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get replyText => $_getSZ(1);
  @$pb.TagNumber(2)
  set replyText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReplyText() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplyText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get confidence => $_getN(2);
  @$pb.TagNumber(3)
  set confidence($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConfidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfidence() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get tone => $_getSZ(3);
  @$pb.TagNumber(4)
  set tone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTone() => $_has(3);
  @$pb.TagNumber(4)
  void clearTone() => $_clearField(4);
}

/// SuggestedAction represents AI commercial or workflow suggestion.
class SuggestedAction extends $pb.GeneratedMessage {
  factory SuggestedAction({
    $core.String? actionType,
    $core.String? title,
    $core.String? description,
    $core.String? targetModule,
  }) {
    final result = SuggestedAction._();
    if (actionType != null) result.actionType = actionType;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (targetModule != null) result.targetModule = targetModule;
    return result;
  }

  SuggestedAction._();

  factory SuggestedAction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestedAction()..mergeFromBuffer(data, registry);
  factory SuggestedAction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestedAction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestedAction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: SuggestedAction.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'actionType')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'targetModule')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestedAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestedAction copyWith(void Function(SuggestedAction) updates) =>
      super.copyWith((message) => updates(message as SuggestedAction))
          as SuggestedAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SuggestedAction() / SuggestedAction.new instead')
  static SuggestedAction create() => SuggestedAction._();
  static $pb.GeneratedMessage $_createMessage() => SuggestedAction._();
  @$core.override
  SuggestedAction createEmptyInstance() => SuggestedAction._();
  @$core.pragma('dart2js:noInline')
  static SuggestedAction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SuggestedAction>(
          SuggestedAction.$_createMessage);
  static SuggestedAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get actionType => $_getSZ(0);
  @$pb.TagNumber(1)
  set actionType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActionType() => $_has(0);
  @$pb.TagNumber(1)
  void clearActionType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetModule => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetModule($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetModule() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetModule() => $_clearField(4);
}

class ThreadServiceListRequest extends $pb.GeneratedMessage {
  factory ThreadServiceListRequest({
    $core.String? workspaceId,
    ThreadStatus? status,
    ThreadPriority? priority,
    ThreadIntent? intent,
    $core.String? sourcePlatform,
    $core.String? ownerUserId,
    $core.bool? slaBreachedOnly,
    $2.Pagination? pagination,
  }) {
    final result = ThreadServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (priority != null) result.priority = priority;
    if (intent != null) result.intent = intent;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (slaBreachedOnly != null) result.slaBreachedOnly = slaBreachedOnly;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ThreadServiceListRequest._();

  factory ThreadServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceListRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<ThreadStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: ThreadStatus.values)
    ..aE<ThreadPriority>(3, _omitFieldNames ? '' : 'priority',
        enumValues: ThreadPriority.values)
    ..aE<ThreadIntent>(4, _omitFieldNames ? '' : 'intent',
        enumValues: ThreadIntent.values)
    ..aOS(5, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(6, _omitFieldNames ? '' : 'ownerUserId')
    ..aOB(7, _omitFieldNames ? '' : 'slaBreachedOnly')
    ..aOM<$2.Pagination>(8, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceListRequest copyWith(
          void Function(ThreadServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as ThreadServiceListRequest))
          as ThreadServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceListRequest() / ThreadServiceListRequest.new instead')
  static ThreadServiceListRequest create() => ThreadServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => ThreadServiceListRequest._();
  @$core.override
  ThreadServiceListRequest createEmptyInstance() =>
      ThreadServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceListRequest>(
          ThreadServiceListRequest.$_createMessage);
  static ThreadServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  ThreadStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ThreadStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  ThreadPriority get priority => $_getN(2);
  @$pb.TagNumber(3)
  set priority(ThreadPriority value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPriority() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriority() => $_clearField(3);

  @$pb.TagNumber(4)
  ThreadIntent get intent => $_getN(3);
  @$pb.TagNumber(4)
  set intent(ThreadIntent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIntent() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourcePlatform => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourcePlatform($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourcePlatform() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourcePlatform() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ownerUserId => $_getSZ(5);
  @$pb.TagNumber(6)
  set ownerUserId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOwnerUserId() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwnerUserId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get slaBreachedOnly => $_getBF(6);
  @$pb.TagNumber(7)
  set slaBreachedOnly($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSlaBreachedOnly() => $_has(6);
  @$pb.TagNumber(7)
  void clearSlaBreachedOnly() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Pagination get pagination => $_getN(7);
  @$pb.TagNumber(8)
  set pagination($2.Pagination value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPagination() => $_has(7);
  @$pb.TagNumber(8)
  void clearPagination() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Pagination ensurePagination() => $_ensure(7);
}

class ThreadServiceListResponse extends $pb.GeneratedMessage {
  factory ThreadServiceListResponse({
    $core.Iterable<Thread>? threads,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ThreadServiceListResponse._();
    if (threads != null) result.threads.addAll(threads);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ThreadServiceListResponse._();

  factory ThreadServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceListResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceListResponse.$_createMessage)
    ..pPM<Thread>(1, _omitFieldNames ? '' : 'threads',
        subBuilder: Thread.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceListResponse copyWith(
          void Function(ThreadServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as ThreadServiceListResponse))
          as ThreadServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceListResponse() / ThreadServiceListResponse.new instead')
  static ThreadServiceListResponse create() => ThreadServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceListResponse._();
  @$core.override
  ThreadServiceListResponse createEmptyInstance() =>
      ThreadServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceListResponse>(
          ThreadServiceListResponse.$_createMessage);
  static ThreadServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Thread> get threads => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class ThreadServiceGetRequest extends $pb.GeneratedMessage {
  factory ThreadServiceGetRequest({
    $core.String? workspaceId,
    $core.String? threadId,
  }) {
    final result = ThreadServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    return result;
  }

  ThreadServiceGetRequest._();

  factory ThreadServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetRequest copyWith(
          void Function(ThreadServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as ThreadServiceGetRequest))
          as ThreadServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceGetRequest() / ThreadServiceGetRequest.new instead')
  static ThreadServiceGetRequest create() => ThreadServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => ThreadServiceGetRequest._();
  @$core.override
  ThreadServiceGetRequest createEmptyInstance() => ThreadServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceGetRequest>(
          ThreadServiceGetRequest.$_createMessage);
  static ThreadServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);
}

class ThreadServiceGetResponse extends $pb.GeneratedMessage {
  factory ThreadServiceGetResponse({
    Thread? thread,
    $core.Iterable<Message>? messages,
    Entity? entity,
    $core.Iterable<FollowUpTask>? followUpTasks,
  }) {
    final result = ThreadServiceGetResponse._();
    if (thread != null) result.thread = thread;
    if (messages != null) result.messages.addAll(messages);
    if (entity != null) result.entity = entity;
    if (followUpTasks != null) result.followUpTasks.addAll(followUpTasks);
    return result;
  }

  ThreadServiceGetResponse._();

  factory ThreadServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceGetResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..pPM<Message>(2, _omitFieldNames ? '' : 'messages',
        subBuilder: Message.$_createMessage)
    ..aOM<Entity>(3, _omitFieldNames ? '' : 'entity',
        subBuilder: Entity.$_createMessage)
    ..pPM<FollowUpTask>(4, _omitFieldNames ? '' : 'followUpTasks',
        subBuilder: FollowUpTask.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetResponse copyWith(
          void Function(ThreadServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as ThreadServiceGetResponse))
          as ThreadServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceGetResponse() / ThreadServiceGetResponse.new instead')
  static ThreadServiceGetResponse create() => ThreadServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => ThreadServiceGetResponse._();
  @$core.override
  ThreadServiceGetResponse createEmptyInstance() =>
      ThreadServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceGetResponse>(
          ThreadServiceGetResponse.$_createMessage);
  static ThreadServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Message> get messages => $_getList(1);

  @$pb.TagNumber(3)
  Entity get entity => $_getN(2);
  @$pb.TagNumber(3)
  set entity(Entity value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  Entity ensureEntity() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<FollowUpTask> get followUpTasks => $_getList(3);
}

class ThreadServiceTriageRequest extends $pb.GeneratedMessage {
  factory ThreadServiceTriageRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
    ThreadIntent? intent,
    ThreadPriority? priority,
    $core.String? nextAction,
    $core.String? ownerUserId,
    $1.Timestamp? slaDueAt,
  }) {
    final result = ThreadServiceTriageRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (intent != null) result.intent = intent;
    if (priority != null) result.priority = priority;
    if (nextAction != null) result.nextAction = nextAction;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (slaDueAt != null) result.slaDueAt = slaDueAt;
    return result;
  }

  ThreadServiceTriageRequest._();

  factory ThreadServiceTriageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceTriageRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceTriageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceTriageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceTriageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceTriageRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aE<ThreadIntent>(4, _omitFieldNames ? '' : 'intent',
        enumValues: ThreadIntent.values)
    ..aE<ThreadPriority>(5, _omitFieldNames ? '' : 'priority',
        enumValues: ThreadPriority.values)
    ..aOS(6, _omitFieldNames ? '' : 'nextAction')
    ..aOS(7, _omitFieldNames ? '' : 'ownerUserId')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'slaDueAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceTriageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceTriageRequest copyWith(
          void Function(ThreadServiceTriageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceTriageRequest))
          as ThreadServiceTriageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceTriageRequest() / ThreadServiceTriageRequest.new instead')
  static ThreadServiceTriageRequest create() => ThreadServiceTriageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceTriageRequest._();
  @$core.override
  ThreadServiceTriageRequest createEmptyInstance() =>
      ThreadServiceTriageRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceTriageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceTriageRequest>(
          ThreadServiceTriageRequest.$_createMessage);
  static ThreadServiceTriageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  ThreadIntent get intent => $_getN(3);
  @$pb.TagNumber(4)
  set intent(ThreadIntent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIntent() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntent() => $_clearField(4);

  @$pb.TagNumber(5)
  ThreadPriority get priority => $_getN(4);
  @$pb.TagNumber(5)
  set priority(ThreadPriority value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPriority() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriority() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get nextAction => $_getSZ(5);
  @$pb.TagNumber(6)
  set nextAction($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNextAction() => $_has(5);
  @$pb.TagNumber(6)
  void clearNextAction() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get ownerUserId => $_getSZ(6);
  @$pb.TagNumber(7)
  set ownerUserId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOwnerUserId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOwnerUserId() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get slaDueAt => $_getN(7);
  @$pb.TagNumber(8)
  set slaDueAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSlaDueAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearSlaDueAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureSlaDueAt() => $_ensure(7);
}

class ThreadServiceTriageResponse extends $pb.GeneratedMessage {
  factory ThreadServiceTriageResponse({
    Thread? thread,
  }) {
    final result = ThreadServiceTriageResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  ThreadServiceTriageResponse._();

  factory ThreadServiceTriageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceTriageResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceTriageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceTriageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceTriageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceTriageResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceTriageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceTriageResponse copyWith(
          void Function(ThreadServiceTriageResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceTriageResponse))
          as ThreadServiceTriageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceTriageResponse() / ThreadServiceTriageResponse.new instead')
  static ThreadServiceTriageResponse create() =>
      ThreadServiceTriageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceTriageResponse._();
  @$core.override
  ThreadServiceTriageResponse createEmptyInstance() =>
      ThreadServiceTriageResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceTriageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceTriageResponse>(
          ThreadServiceTriageResponse.$_createMessage);
  static ThreadServiceTriageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);
}

class ThreadServiceAssignRequest extends $pb.GeneratedMessage {
  factory ThreadServiceAssignRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
    $core.String? ownerUserId,
  }) {
    final result = ThreadServiceAssignRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    return result;
  }

  ThreadServiceAssignRequest._();

  factory ThreadServiceAssignRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceAssignRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceAssignRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceAssignRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceAssignRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceAssignRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aOS(4, _omitFieldNames ? '' : 'ownerUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceAssignRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceAssignRequest copyWith(
          void Function(ThreadServiceAssignRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceAssignRequest))
          as ThreadServiceAssignRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceAssignRequest() / ThreadServiceAssignRequest.new instead')
  static ThreadServiceAssignRequest create() => ThreadServiceAssignRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceAssignRequest._();
  @$core.override
  ThreadServiceAssignRequest createEmptyInstance() =>
      ThreadServiceAssignRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceAssignRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceAssignRequest>(
          ThreadServiceAssignRequest.$_createMessage);
  static ThreadServiceAssignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ownerUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set ownerUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOwnerUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwnerUserId() => $_clearField(4);
}

class ThreadServiceAssignResponse extends $pb.GeneratedMessage {
  factory ThreadServiceAssignResponse({
    Thread? thread,
  }) {
    final result = ThreadServiceAssignResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  ThreadServiceAssignResponse._();

  factory ThreadServiceAssignResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceAssignResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceAssignResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceAssignResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceAssignResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceAssignResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceAssignResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceAssignResponse copyWith(
          void Function(ThreadServiceAssignResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceAssignResponse))
          as ThreadServiceAssignResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceAssignResponse() / ThreadServiceAssignResponse.new instead')
  static ThreadServiceAssignResponse create() =>
      ThreadServiceAssignResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceAssignResponse._();
  @$core.override
  ThreadServiceAssignResponse createEmptyInstance() =>
      ThreadServiceAssignResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceAssignResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceAssignResponse>(
          ThreadServiceAssignResponse.$_createMessage);
  static ThreadServiceAssignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);
}

class ThreadServiceReplyRequest extends $pb.GeneratedMessage {
  factory ThreadServiceReplyRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
    $core.String? body,
    $core.Iterable<$core.String>? attachments,
    $core.String? suggestionId,
    $core.String? targetAccountId,
    $core.bool? isAutoReply,
  }) {
    final result = ThreadServiceReplyRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (body != null) result.body = body;
    if (attachments != null) result.attachments.addAll(attachments);
    if (suggestionId != null) result.suggestionId = suggestionId;
    if (targetAccountId != null) result.targetAccountId = targetAccountId;
    if (isAutoReply != null) result.isAutoReply = isAutoReply;
    return result;
  }

  ThreadServiceReplyRequest._();

  factory ThreadServiceReplyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceReplyRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceReplyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceReplyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceReplyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceReplyRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aOS(4, _omitFieldNames ? '' : 'body')
    ..pPS(5, _omitFieldNames ? '' : 'attachments')
    ..aOS(6, _omitFieldNames ? '' : 'suggestionId')
    ..aOS(7, _omitFieldNames ? '' : 'targetAccountId')
    ..aOB(8, _omitFieldNames ? '' : 'isAutoReply')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceReplyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceReplyRequest copyWith(
          void Function(ThreadServiceReplyRequest) updates) =>
      super.copyWith((message) => updates(message as ThreadServiceReplyRequest))
          as ThreadServiceReplyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceReplyRequest() / ThreadServiceReplyRequest.new instead')
  static ThreadServiceReplyRequest create() => ThreadServiceReplyRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceReplyRequest._();
  @$core.override
  ThreadServiceReplyRequest createEmptyInstance() =>
      ThreadServiceReplyRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceReplyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceReplyRequest>(
          ThreadServiceReplyRequest.$_createMessage);
  static ThreadServiceReplyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get body => $_getSZ(3);
  @$pb.TagNumber(4)
  set body($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBody() => $_has(3);
  @$pb.TagNumber(4)
  void clearBody() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get attachments => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get suggestionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set suggestionId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSuggestionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSuggestionId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get targetAccountId => $_getSZ(6);
  @$pb.TagNumber(7)
  set targetAccountId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetAccountId() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetAccountId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isAutoReply => $_getBF(7);
  @$pb.TagNumber(8)
  set isAutoReply($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsAutoReply() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsAutoReply() => $_clearField(8);
}

class ThreadServiceReplyResponse extends $pb.GeneratedMessage {
  factory ThreadServiceReplyResponse({
    Message? message,
    Thread? thread,
  }) {
    final result = ThreadServiceReplyResponse._();
    if (message != null) result.message = message;
    if (thread != null) result.thread = thread;
    return result;
  }

  ThreadServiceReplyResponse._();

  factory ThreadServiceReplyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceReplyResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceReplyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceReplyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceReplyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceReplyResponse.$_createMessage)
    ..aOM<Message>(1, _omitFieldNames ? '' : 'message',
        subBuilder: Message.$_createMessage)
    ..aOM<Thread>(2, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceReplyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceReplyResponse copyWith(
          void Function(ThreadServiceReplyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceReplyResponse))
          as ThreadServiceReplyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceReplyResponse() / ThreadServiceReplyResponse.new instead')
  static ThreadServiceReplyResponse create() => ThreadServiceReplyResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceReplyResponse._();
  @$core.override
  ThreadServiceReplyResponse createEmptyInstance() =>
      ThreadServiceReplyResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceReplyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceReplyResponse>(
          ThreadServiceReplyResponse.$_createMessage);
  static ThreadServiceReplyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Message get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(Message value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  Message ensureMessage() => $_ensure(0);

  @$pb.TagNumber(2)
  Thread get thread => $_getN(1);
  @$pb.TagNumber(2)
  set thread(Thread value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasThread() => $_has(1);
  @$pb.TagNumber(2)
  void clearThread() => $_clearField(2);
  @$pb.TagNumber(2)
  Thread ensureThread() => $_ensure(1);
}

class ThreadServiceResolveRequest extends $pb.GeneratedMessage {
  factory ThreadServiceResolveRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
    $core.String? outcomeSummary,
  }) {
    final result = ThreadServiceResolveRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (outcomeSummary != null) result.outcomeSummary = outcomeSummary;
    return result;
  }

  ThreadServiceResolveRequest._();

  factory ThreadServiceResolveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceResolveRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceResolveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceResolveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceResolveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceResolveRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aOS(4, _omitFieldNames ? '' : 'outcomeSummary')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceResolveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceResolveRequest copyWith(
          void Function(ThreadServiceResolveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceResolveRequest))
          as ThreadServiceResolveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceResolveRequest() / ThreadServiceResolveRequest.new instead')
  static ThreadServiceResolveRequest create() =>
      ThreadServiceResolveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceResolveRequest._();
  @$core.override
  ThreadServiceResolveRequest createEmptyInstance() =>
      ThreadServiceResolveRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceResolveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceResolveRequest>(
          ThreadServiceResolveRequest.$_createMessage);
  static ThreadServiceResolveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get outcomeSummary => $_getSZ(3);
  @$pb.TagNumber(4)
  set outcomeSummary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutcomeSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutcomeSummary() => $_clearField(4);
}

class ThreadServiceResolveResponse extends $pb.GeneratedMessage {
  factory ThreadServiceResolveResponse({
    Thread? thread,
  }) {
    final result = ThreadServiceResolveResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  ThreadServiceResolveResponse._();

  factory ThreadServiceResolveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceResolveResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceResolveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceResolveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceResolveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceResolveResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceResolveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceResolveResponse copyWith(
          void Function(ThreadServiceResolveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceResolveResponse))
          as ThreadServiceResolveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceResolveResponse() / ThreadServiceResolveResponse.new instead')
  static ThreadServiceResolveResponse create() =>
      ThreadServiceResolveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceResolveResponse._();
  @$core.override
  ThreadServiceResolveResponse createEmptyInstance() =>
      ThreadServiceResolveResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceResolveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceResolveResponse>(
          ThreadServiceResolveResponse.$_createMessage);
  static ThreadServiceResolveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);
}

class ThreadServiceBulkTriageRequest extends $pb.GeneratedMessage {
  factory ThreadServiceBulkTriageRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.Iterable<$core.String>? threadIds,
    ThreadIntent? intent,
    ThreadPriority? priority,
    $core.String? ownerUserId,
    $core.String? nextAction,
    ThreadStatus? targetStatus,
  }) {
    final result = ThreadServiceBulkTriageRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadIds != null) result.threadIds.addAll(threadIds);
    if (intent != null) result.intent = intent;
    if (priority != null) result.priority = priority;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (nextAction != null) result.nextAction = nextAction;
    if (targetStatus != null) result.targetStatus = targetStatus;
    return result;
  }

  ThreadServiceBulkTriageRequest._();

  factory ThreadServiceBulkTriageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceBulkTriageRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceBulkTriageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceBulkTriageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceBulkTriageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceBulkTriageRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..pPS(3, _omitFieldNames ? '' : 'threadIds')
    ..aE<ThreadIntent>(4, _omitFieldNames ? '' : 'intent',
        enumValues: ThreadIntent.values)
    ..aE<ThreadPriority>(5, _omitFieldNames ? '' : 'priority',
        enumValues: ThreadPriority.values)
    ..aOS(6, _omitFieldNames ? '' : 'ownerUserId')
    ..aOS(7, _omitFieldNames ? '' : 'nextAction')
    ..aE<ThreadStatus>(8, _omitFieldNames ? '' : 'targetStatus',
        enumValues: ThreadStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceBulkTriageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceBulkTriageRequest copyWith(
          void Function(ThreadServiceBulkTriageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceBulkTriageRequest))
          as ThreadServiceBulkTriageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceBulkTriageRequest() / ThreadServiceBulkTriageRequest.new instead')
  static ThreadServiceBulkTriageRequest create() =>
      ThreadServiceBulkTriageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceBulkTriageRequest._();
  @$core.override
  ThreadServiceBulkTriageRequest createEmptyInstance() =>
      ThreadServiceBulkTriageRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceBulkTriageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceBulkTriageRequest>(
          ThreadServiceBulkTriageRequest.$_createMessage);
  static ThreadServiceBulkTriageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get threadIds => $_getList(2);

  @$pb.TagNumber(4)
  ThreadIntent get intent => $_getN(3);
  @$pb.TagNumber(4)
  set intent(ThreadIntent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIntent() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntent() => $_clearField(4);

  @$pb.TagNumber(5)
  ThreadPriority get priority => $_getN(4);
  @$pb.TagNumber(5)
  set priority(ThreadPriority value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPriority() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriority() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ownerUserId => $_getSZ(5);
  @$pb.TagNumber(6)
  set ownerUserId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOwnerUserId() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwnerUserId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get nextAction => $_getSZ(6);
  @$pb.TagNumber(7)
  set nextAction($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNextAction() => $_has(6);
  @$pb.TagNumber(7)
  void clearNextAction() => $_clearField(7);

  @$pb.TagNumber(8)
  ThreadStatus get targetStatus => $_getN(7);
  @$pb.TagNumber(8)
  set targetStatus(ThreadStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTargetStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearTargetStatus() => $_clearField(8);
}

class ThreadServiceBulkTriageResponse extends $pb.GeneratedMessage {
  factory ThreadServiceBulkTriageResponse({
    $core.int? triagedCount,
    $core.Iterable<Thread>? threads,
  }) {
    final result = ThreadServiceBulkTriageResponse._();
    if (triagedCount != null) result.triagedCount = triagedCount;
    if (threads != null) result.threads.addAll(threads);
    return result;
  }

  ThreadServiceBulkTriageResponse._();

  factory ThreadServiceBulkTriageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceBulkTriageResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceBulkTriageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceBulkTriageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceBulkTriageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceBulkTriageResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'triagedCount')
    ..pPM<Thread>(2, _omitFieldNames ? '' : 'threads',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceBulkTriageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceBulkTriageResponse copyWith(
          void Function(ThreadServiceBulkTriageResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceBulkTriageResponse))
          as ThreadServiceBulkTriageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceBulkTriageResponse() / ThreadServiceBulkTriageResponse.new instead')
  static ThreadServiceBulkTriageResponse create() =>
      ThreadServiceBulkTriageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceBulkTriageResponse._();
  @$core.override
  ThreadServiceBulkTriageResponse createEmptyInstance() =>
      ThreadServiceBulkTriageResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceBulkTriageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceBulkTriageResponse>(
          ThreadServiceBulkTriageResponse.$_createMessage);
  static ThreadServiceBulkTriageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get triagedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set triagedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTriagedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearTriagedCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Thread> get threads => $_getList(1);
}

class ThreadServiceGetMessagesRequest extends $pb.GeneratedMessage {
  factory ThreadServiceGetMessagesRequest({
    $core.String? workspaceId,
    $core.String? threadId,
    $2.Pagination? pagination,
  }) {
    final result = ThreadServiceGetMessagesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ThreadServiceGetMessagesRequest._();

  factory ThreadServiceGetMessagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetMessagesRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceGetMessagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetMessagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceGetMessagesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceGetMessagesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOM<$2.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetMessagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetMessagesRequest copyWith(
          void Function(ThreadServiceGetMessagesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceGetMessagesRequest))
          as ThreadServiceGetMessagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceGetMessagesRequest() / ThreadServiceGetMessagesRequest.new instead')
  static ThreadServiceGetMessagesRequest create() =>
      ThreadServiceGetMessagesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceGetMessagesRequest._();
  @$core.override
  ThreadServiceGetMessagesRequest createEmptyInstance() =>
      ThreadServiceGetMessagesRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceGetMessagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceGetMessagesRequest>(
          ThreadServiceGetMessagesRequest.$_createMessage);
  static ThreadServiceGetMessagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.Pagination get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($2.Pagination value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Pagination ensurePagination() => $_ensure(2);
}

class ThreadServiceGetMessagesResponse extends $pb.GeneratedMessage {
  factory ThreadServiceGetMessagesResponse({
    $core.Iterable<Message>? messages,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ThreadServiceGetMessagesResponse._();
    if (messages != null) result.messages.addAll(messages);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ThreadServiceGetMessagesResponse._();

  factory ThreadServiceGetMessagesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetMessagesResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceGetMessagesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetMessagesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceGetMessagesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceGetMessagesResponse.$_createMessage)
    ..pPM<Message>(1, _omitFieldNames ? '' : 'messages',
        subBuilder: Message.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetMessagesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetMessagesResponse copyWith(
          void Function(ThreadServiceGetMessagesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceGetMessagesResponse))
          as ThreadServiceGetMessagesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceGetMessagesResponse() / ThreadServiceGetMessagesResponse.new instead')
  static ThreadServiceGetMessagesResponse create() =>
      ThreadServiceGetMessagesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceGetMessagesResponse._();
  @$core.override
  ThreadServiceGetMessagesResponse createEmptyInstance() =>
      ThreadServiceGetMessagesResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceGetMessagesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceGetMessagesResponse>(
          ThreadServiceGetMessagesResponse.$_createMessage);
  static ThreadServiceGetMessagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Message> get messages => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class ThreadServiceGetUnreadCountRequest extends $pb.GeneratedMessage {
  factory ThreadServiceGetUnreadCountRequest({
    $core.String? workspaceId,
    $core.String? ownerUserId,
  }) {
    final result = ThreadServiceGetUnreadCountRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    return result;
  }

  ThreadServiceGetUnreadCountRequest._();

  factory ThreadServiceGetUnreadCountRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetUnreadCountRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceGetUnreadCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetUnreadCountRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceGetUnreadCountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceGetUnreadCountRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ownerUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetUnreadCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetUnreadCountRequest copyWith(
          void Function(ThreadServiceGetUnreadCountRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ThreadServiceGetUnreadCountRequest))
          as ThreadServiceGetUnreadCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceGetUnreadCountRequest() / ThreadServiceGetUnreadCountRequest.new instead')
  static ThreadServiceGetUnreadCountRequest create() =>
      ThreadServiceGetUnreadCountRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceGetUnreadCountRequest._();
  @$core.override
  ThreadServiceGetUnreadCountRequest createEmptyInstance() =>
      ThreadServiceGetUnreadCountRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceGetUnreadCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceGetUnreadCountRequest>(
          ThreadServiceGetUnreadCountRequest.$_createMessage);
  static ThreadServiceGetUnreadCountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ownerUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOwnerUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerUserId() => $_clearField(2);
}

class ThreadServiceGetUnreadCountResponse extends $pb.GeneratedMessage {
  factory ThreadServiceGetUnreadCountResponse({
    $core.int? unreadCount,
    $core.int? slaBreachedCount,
  }) {
    final result = ThreadServiceGetUnreadCountResponse._();
    if (unreadCount != null) result.unreadCount = unreadCount;
    if (slaBreachedCount != null) result.slaBreachedCount = slaBreachedCount;
    return result;
  }

  ThreadServiceGetUnreadCountResponse._();

  factory ThreadServiceGetUnreadCountResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetUnreadCountResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceGetUnreadCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceGetUnreadCountResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceGetUnreadCountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceGetUnreadCountResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'unreadCount')
    ..aI(2, _omitFieldNames ? '' : 'slaBreachedCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetUnreadCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceGetUnreadCountResponse copyWith(
          void Function(ThreadServiceGetUnreadCountResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ThreadServiceGetUnreadCountResponse))
          as ThreadServiceGetUnreadCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceGetUnreadCountResponse() / ThreadServiceGetUnreadCountResponse.new instead')
  static ThreadServiceGetUnreadCountResponse create() =>
      ThreadServiceGetUnreadCountResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceGetUnreadCountResponse._();
  @$core.override
  ThreadServiceGetUnreadCountResponse createEmptyInstance() =>
      ThreadServiceGetUnreadCountResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceGetUnreadCountResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ThreadServiceGetUnreadCountResponse>(
          ThreadServiceGetUnreadCountResponse.$_createMessage);
  static ThreadServiceGetUnreadCountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unreadCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set unreadCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnreadCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnreadCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get slaBreachedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set slaBreachedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSlaBreachedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearSlaBreachedCount() => $_clearField(2);
}

class ThreadServiceMarkReadRequest extends $pb.GeneratedMessage {
  factory ThreadServiceMarkReadRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
  }) {
    final result = ThreadServiceMarkReadRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    return result;
  }

  ThreadServiceMarkReadRequest._();

  factory ThreadServiceMarkReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceMarkReadRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceMarkReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceMarkReadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceMarkReadRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceMarkReadRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceMarkReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceMarkReadRequest copyWith(
          void Function(ThreadServiceMarkReadRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceMarkReadRequest))
          as ThreadServiceMarkReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceMarkReadRequest() / ThreadServiceMarkReadRequest.new instead')
  static ThreadServiceMarkReadRequest create() =>
      ThreadServiceMarkReadRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceMarkReadRequest._();
  @$core.override
  ThreadServiceMarkReadRequest createEmptyInstance() =>
      ThreadServiceMarkReadRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceMarkReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceMarkReadRequest>(
          ThreadServiceMarkReadRequest.$_createMessage);
  static ThreadServiceMarkReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);
}

class ThreadServiceMarkReadResponse extends $pb.GeneratedMessage {
  factory ThreadServiceMarkReadResponse({
    $core.bool? success,
  }) {
    final result = ThreadServiceMarkReadResponse._();
    if (success != null) result.success = success;
    return result;
  }

  ThreadServiceMarkReadResponse._();

  factory ThreadServiceMarkReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceMarkReadResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceMarkReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceMarkReadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceMarkReadResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceMarkReadResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceMarkReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceMarkReadResponse copyWith(
          void Function(ThreadServiceMarkReadResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceMarkReadResponse))
          as ThreadServiceMarkReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceMarkReadResponse() / ThreadServiceMarkReadResponse.new instead')
  static ThreadServiceMarkReadResponse create() =>
      ThreadServiceMarkReadResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceMarkReadResponse._();
  @$core.override
  ThreadServiceMarkReadResponse createEmptyInstance() =>
      ThreadServiceMarkReadResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceMarkReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceMarkReadResponse>(
          ThreadServiceMarkReadResponse.$_createMessage);
  static ThreadServiceMarkReadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ThreadServiceUpdateRequest extends $pb.GeneratedMessage {
  factory ThreadServiceUpdateRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
    $core.String? nextAction,
    ThreadPriority? priority,
    ThreadIntent? intent,
  }) {
    final result = ThreadServiceUpdateRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (nextAction != null) result.nextAction = nextAction;
    if (priority != null) result.priority = priority;
    if (intent != null) result.intent = intent;
    return result;
  }

  ThreadServiceUpdateRequest._();

  factory ThreadServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceUpdateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aOS(4, _omitFieldNames ? '' : 'nextAction')
    ..aE<ThreadPriority>(5, _omitFieldNames ? '' : 'priority',
        enumValues: ThreadPriority.values)
    ..aE<ThreadIntent>(6, _omitFieldNames ? '' : 'intent',
        enumValues: ThreadIntent.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceUpdateRequest copyWith(
          void Function(ThreadServiceUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceUpdateRequest))
          as ThreadServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceUpdateRequest() / ThreadServiceUpdateRequest.new instead')
  static ThreadServiceUpdateRequest create() => ThreadServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceUpdateRequest._();
  @$core.override
  ThreadServiceUpdateRequest createEmptyInstance() =>
      ThreadServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceUpdateRequest>(
          ThreadServiceUpdateRequest.$_createMessage);
  static ThreadServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nextAction => $_getSZ(3);
  @$pb.TagNumber(4)
  set nextAction($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNextAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextAction() => $_clearField(4);

  @$pb.TagNumber(5)
  ThreadPriority get priority => $_getN(4);
  @$pb.TagNumber(5)
  set priority(ThreadPriority value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPriority() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriority() => $_clearField(5);

  @$pb.TagNumber(6)
  ThreadIntent get intent => $_getN(5);
  @$pb.TagNumber(6)
  set intent(ThreadIntent value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasIntent() => $_has(5);
  @$pb.TagNumber(6)
  void clearIntent() => $_clearField(6);
}

class ThreadServiceUpdateResponse extends $pb.GeneratedMessage {
  factory ThreadServiceUpdateResponse({
    Thread? thread,
  }) {
    final result = ThreadServiceUpdateResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  ThreadServiceUpdateResponse._();

  factory ThreadServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceUpdateResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceUpdateResponse copyWith(
          void Function(ThreadServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceUpdateResponse))
          as ThreadServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceUpdateResponse() / ThreadServiceUpdateResponse.new instead')
  static ThreadServiceUpdateResponse create() =>
      ThreadServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceUpdateResponse._();
  @$core.override
  ThreadServiceUpdateResponse createEmptyInstance() =>
      ThreadServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceUpdateResponse>(
          ThreadServiceUpdateResponse.$_createMessage);
  static ThreadServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);
}

class ThreadServiceAddTagRequest extends $pb.GeneratedMessage {
  factory ThreadServiceAddTagRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
    $core.String? tag,
  }) {
    final result = ThreadServiceAddTagRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (tag != null) result.tag = tag;
    return result;
  }

  ThreadServiceAddTagRequest._();

  factory ThreadServiceAddTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceAddTagRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceAddTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceAddTagRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceAddTagRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceAddTagRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aOS(4, _omitFieldNames ? '' : 'tag')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceAddTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceAddTagRequest copyWith(
          void Function(ThreadServiceAddTagRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceAddTagRequest))
          as ThreadServiceAddTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceAddTagRequest() / ThreadServiceAddTagRequest.new instead')
  static ThreadServiceAddTagRequest create() => ThreadServiceAddTagRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceAddTagRequest._();
  @$core.override
  ThreadServiceAddTagRequest createEmptyInstance() =>
      ThreadServiceAddTagRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceAddTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceAddTagRequest>(
          ThreadServiceAddTagRequest.$_createMessage);
  static ThreadServiceAddTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get tag => $_getSZ(3);
  @$pb.TagNumber(4)
  set tag($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTag() => $_has(3);
  @$pb.TagNumber(4)
  void clearTag() => $_clearField(4);
}

class ThreadServiceAddTagResponse extends $pb.GeneratedMessage {
  factory ThreadServiceAddTagResponse({
    Thread? thread,
  }) {
    final result = ThreadServiceAddTagResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  ThreadServiceAddTagResponse._();

  factory ThreadServiceAddTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceAddTagResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceAddTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceAddTagResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceAddTagResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceAddTagResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceAddTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceAddTagResponse copyWith(
          void Function(ThreadServiceAddTagResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceAddTagResponse))
          as ThreadServiceAddTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceAddTagResponse() / ThreadServiceAddTagResponse.new instead')
  static ThreadServiceAddTagResponse create() =>
      ThreadServiceAddTagResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceAddTagResponse._();
  @$core.override
  ThreadServiceAddTagResponse createEmptyInstance() =>
      ThreadServiceAddTagResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceAddTagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceAddTagResponse>(
          ThreadServiceAddTagResponse.$_createMessage);
  static ThreadServiceAddTagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);
}

class ThreadServiceMuteRequest extends $pb.GeneratedMessage {
  factory ThreadServiceMuteRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
  }) {
    final result = ThreadServiceMuteRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    return result;
  }

  ThreadServiceMuteRequest._();

  factory ThreadServiceMuteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceMuteRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceMuteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceMuteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceMuteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceMuteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceMuteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceMuteRequest copyWith(
          void Function(ThreadServiceMuteRequest) updates) =>
      super.copyWith((message) => updates(message as ThreadServiceMuteRequest))
          as ThreadServiceMuteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceMuteRequest() / ThreadServiceMuteRequest.new instead')
  static ThreadServiceMuteRequest create() => ThreadServiceMuteRequest._();
  static $pb.GeneratedMessage $_createMessage() => ThreadServiceMuteRequest._();
  @$core.override
  ThreadServiceMuteRequest createEmptyInstance() =>
      ThreadServiceMuteRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceMuteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceMuteRequest>(
          ThreadServiceMuteRequest.$_createMessage);
  static ThreadServiceMuteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);
}

class ThreadServiceMuteResponse extends $pb.GeneratedMessage {
  factory ThreadServiceMuteResponse({
    $core.bool? muted,
  }) {
    final result = ThreadServiceMuteResponse._();
    if (muted != null) result.muted = muted;
    return result;
  }

  ThreadServiceMuteResponse._();

  factory ThreadServiceMuteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceMuteResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceMuteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceMuteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceMuteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceMuteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'muted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceMuteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceMuteResponse copyWith(
          void Function(ThreadServiceMuteResponse) updates) =>
      super.copyWith((message) => updates(message as ThreadServiceMuteResponse))
          as ThreadServiceMuteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceMuteResponse() / ThreadServiceMuteResponse.new instead')
  static ThreadServiceMuteResponse create() => ThreadServiceMuteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceMuteResponse._();
  @$core.override
  ThreadServiceMuteResponse createEmptyInstance() =>
      ThreadServiceMuteResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceMuteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceMuteResponse>(
          ThreadServiceMuteResponse.$_createMessage);
  static ThreadServiceMuteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get muted => $_getBF(0);
  @$pb.TagNumber(1)
  set muted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMuted() => $_has(0);
  @$pb.TagNumber(1)
  void clearMuted() => $_clearField(1);
}

class ThreadServiceSnoozeRequest extends $pb.GeneratedMessage {
  factory ThreadServiceSnoozeRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
    $1.Timestamp? wakeAt,
  }) {
    final result = ThreadServiceSnoozeRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (wakeAt != null) result.wakeAt = wakeAt;
    return result;
  }

  ThreadServiceSnoozeRequest._();

  factory ThreadServiceSnoozeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceSnoozeRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceSnoozeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceSnoozeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceSnoozeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceSnoozeRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'wakeAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceSnoozeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceSnoozeRequest copyWith(
          void Function(ThreadServiceSnoozeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceSnoozeRequest))
          as ThreadServiceSnoozeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceSnoozeRequest() / ThreadServiceSnoozeRequest.new instead')
  static ThreadServiceSnoozeRequest create() => ThreadServiceSnoozeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceSnoozeRequest._();
  @$core.override
  ThreadServiceSnoozeRequest createEmptyInstance() =>
      ThreadServiceSnoozeRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceSnoozeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceSnoozeRequest>(
          ThreadServiceSnoozeRequest.$_createMessage);
  static ThreadServiceSnoozeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get wakeAt => $_getN(3);
  @$pb.TagNumber(4)
  set wakeAt($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWakeAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearWakeAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureWakeAt() => $_ensure(3);
}

class ThreadServiceSnoozeResponse extends $pb.GeneratedMessage {
  factory ThreadServiceSnoozeResponse({
    Thread? thread,
  }) {
    final result = ThreadServiceSnoozeResponse._();
    if (thread != null) result.thread = thread;
    return result;
  }

  ThreadServiceSnoozeResponse._();

  factory ThreadServiceSnoozeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceSnoozeResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceSnoozeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceSnoozeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceSnoozeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceSnoozeResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceSnoozeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceSnoozeResponse copyWith(
          void Function(ThreadServiceSnoozeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceSnoozeResponse))
          as ThreadServiceSnoozeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceSnoozeResponse() / ThreadServiceSnoozeResponse.new instead')
  static ThreadServiceSnoozeResponse create() =>
      ThreadServiceSnoozeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceSnoozeResponse._();
  @$core.override
  ThreadServiceSnoozeResponse createEmptyInstance() =>
      ThreadServiceSnoozeResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceSnoozeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceSnoozeResponse>(
          ThreadServiceSnoozeResponse.$_createMessage);
  static ThreadServiceSnoozeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);
}

class ThreadServiceListMobileRequest extends $pb.GeneratedMessage {
  factory ThreadServiceListMobileRequest({
    $core.String? workspaceId,
    $core.String? ownerUserId,
    ThreadStatus? status,
    $2.Pagination? pagination,
  }) {
    final result = ThreadServiceListMobileRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (status != null) result.status = status;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ThreadServiceListMobileRequest._();

  factory ThreadServiceListMobileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceListMobileRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceListMobileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceListMobileRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceListMobileRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceListMobileRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ownerUserId')
    ..aE<ThreadStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: ThreadStatus.values)
    ..aOM<$2.Pagination>(4, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceListMobileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceListMobileRequest copyWith(
          void Function(ThreadServiceListMobileRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceListMobileRequest))
          as ThreadServiceListMobileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceListMobileRequest() / ThreadServiceListMobileRequest.new instead')
  static ThreadServiceListMobileRequest create() =>
      ThreadServiceListMobileRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceListMobileRequest._();
  @$core.override
  ThreadServiceListMobileRequest createEmptyInstance() =>
      ThreadServiceListMobileRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceListMobileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceListMobileRequest>(
          ThreadServiceListMobileRequest.$_createMessage);
  static ThreadServiceListMobileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ownerUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOwnerUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  ThreadStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(ThreadStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Pagination get pagination => $_getN(3);
  @$pb.TagNumber(4)
  set pagination($2.Pagination value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPagination() => $_has(3);
  @$pb.TagNumber(4)
  void clearPagination() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Pagination ensurePagination() => $_ensure(3);
}

class ThreadServiceListMobileResponse extends $pb.GeneratedMessage {
  factory ThreadServiceListMobileResponse({
    $core.Iterable<Thread>? threads,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ThreadServiceListMobileResponse._();
    if (threads != null) result.threads.addAll(threads);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ThreadServiceListMobileResponse._();

  factory ThreadServiceListMobileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceListMobileResponse()..mergeFromBuffer(data, registry);
  factory ThreadServiceListMobileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceListMobileResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceListMobileResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: ThreadServiceListMobileResponse.$_createMessage)
    ..pPM<Thread>(1, _omitFieldNames ? '' : 'threads',
        subBuilder: Thread.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceListMobileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceListMobileResponse copyWith(
          void Function(ThreadServiceListMobileResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ThreadServiceListMobileResponse))
          as ThreadServiceListMobileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceListMobileResponse() / ThreadServiceListMobileResponse.new instead')
  static ThreadServiceListMobileResponse create() =>
      ThreadServiceListMobileResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceListMobileResponse._();
  @$core.override
  ThreadServiceListMobileResponse createEmptyInstance() =>
      ThreadServiceListMobileResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceListMobileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreadServiceListMobileResponse>(
          ThreadServiceListMobileResponse.$_createMessage);
  static ThreadServiceListMobileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Thread> get threads => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class ThreadServiceHandleGhostMessageRequest extends $pb.GeneratedMessage {
  factory ThreadServiceHandleGhostMessageRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
    $core.int? platformHttpCode,
    $core.String? errorMessage,
  }) {
    final result = ThreadServiceHandleGhostMessageRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (platformHttpCode != null) result.platformHttpCode = platformHttpCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  ThreadServiceHandleGhostMessageRequest._();

  factory ThreadServiceHandleGhostMessageRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceHandleGhostMessageRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceHandleGhostMessageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceHandleGhostMessageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceHandleGhostMessageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          ThreadServiceHandleGhostMessageRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..aI(4, _omitFieldNames ? '' : 'platformHttpCode')
    ..aOS(5, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceHandleGhostMessageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceHandleGhostMessageRequest copyWith(
          void Function(ThreadServiceHandleGhostMessageRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ThreadServiceHandleGhostMessageRequest))
          as ThreadServiceHandleGhostMessageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceHandleGhostMessageRequest() / ThreadServiceHandleGhostMessageRequest.new instead')
  static ThreadServiceHandleGhostMessageRequest create() =>
      ThreadServiceHandleGhostMessageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceHandleGhostMessageRequest._();
  @$core.override
  ThreadServiceHandleGhostMessageRequest createEmptyInstance() =>
      ThreadServiceHandleGhostMessageRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceHandleGhostMessageRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ThreadServiceHandleGhostMessageRequest>(
          ThreadServiceHandleGhostMessageRequest.$_createMessage);
  static ThreadServiceHandleGhostMessageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get platformHttpCode => $_getIZ(3);
  @$pb.TagNumber(4)
  set platformHttpCode($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlatformHttpCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatformHttpCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get errorMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorMessage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasErrorMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorMessage() => $_clearField(5);
}

class ThreadServiceHandleGhostMessageResponse extends $pb.GeneratedMessage {
  factory ThreadServiceHandleGhostMessageResponse({
    Thread? thread,
    $core.bool? isStale,
    $core.bool? composeDisabled,
    $core.String? userExplanation,
  }) {
    final result = ThreadServiceHandleGhostMessageResponse._();
    if (thread != null) result.thread = thread;
    if (isStale != null) result.isStale = isStale;
    if (composeDisabled != null) result.composeDisabled = composeDisabled;
    if (userExplanation != null) result.userExplanation = userExplanation;
    return result;
  }

  ThreadServiceHandleGhostMessageResponse._();

  factory ThreadServiceHandleGhostMessageResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceHandleGhostMessageResponse()
        ..mergeFromBuffer(data, registry);
  factory ThreadServiceHandleGhostMessageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceHandleGhostMessageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceHandleGhostMessageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          ThreadServiceHandleGhostMessageResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isStale')
    ..aOB(3, _omitFieldNames ? '' : 'composeDisabled')
    ..aOS(4, _omitFieldNames ? '' : 'userExplanation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceHandleGhostMessageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceHandleGhostMessageResponse copyWith(
          void Function(ThreadServiceHandleGhostMessageResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ThreadServiceHandleGhostMessageResponse))
          as ThreadServiceHandleGhostMessageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceHandleGhostMessageResponse() / ThreadServiceHandleGhostMessageResponse.new instead')
  static ThreadServiceHandleGhostMessageResponse create() =>
      ThreadServiceHandleGhostMessageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceHandleGhostMessageResponse._();
  @$core.override
  ThreadServiceHandleGhostMessageResponse createEmptyInstance() =>
      ThreadServiceHandleGhostMessageResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceHandleGhostMessageResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ThreadServiceHandleGhostMessageResponse>(
          ThreadServiceHandleGhostMessageResponse.$_createMessage);
  static ThreadServiceHandleGhostMessageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isStale => $_getBF(1);
  @$pb.TagNumber(2)
  set isStale($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsStale() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsStale() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get composeDisabled => $_getBF(2);
  @$pb.TagNumber(3)
  set composeDisabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasComposeDisabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearComposeDisabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userExplanation => $_getSZ(3);
  @$pb.TagNumber(4)
  set userExplanation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserExplanation() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserExplanation() => $_clearField(4);
}

class ThreadServiceResetAutoReplyLoopRequest extends $pb.GeneratedMessage {
  factory ThreadServiceResetAutoReplyLoopRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? threadId,
  }) {
    final result = ThreadServiceResetAutoReplyLoopRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    return result;
  }

  ThreadServiceResetAutoReplyLoopRequest._();

  factory ThreadServiceResetAutoReplyLoopRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceResetAutoReplyLoopRequest()..mergeFromBuffer(data, registry);
  factory ThreadServiceResetAutoReplyLoopRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceResetAutoReplyLoopRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceResetAutoReplyLoopRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          ThreadServiceResetAutoReplyLoopRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'threadId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceResetAutoReplyLoopRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceResetAutoReplyLoopRequest copyWith(
          void Function(ThreadServiceResetAutoReplyLoopRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ThreadServiceResetAutoReplyLoopRequest))
          as ThreadServiceResetAutoReplyLoopRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceResetAutoReplyLoopRequest() / ThreadServiceResetAutoReplyLoopRequest.new instead')
  static ThreadServiceResetAutoReplyLoopRequest create() =>
      ThreadServiceResetAutoReplyLoopRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceResetAutoReplyLoopRequest._();
  @$core.override
  ThreadServiceResetAutoReplyLoopRequest createEmptyInstance() =>
      ThreadServiceResetAutoReplyLoopRequest._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceResetAutoReplyLoopRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ThreadServiceResetAutoReplyLoopRequest>(
          ThreadServiceResetAutoReplyLoopRequest.$_createMessage);
  static ThreadServiceResetAutoReplyLoopRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get threadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set threadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreadId() => $_clearField(3);
}

class ThreadServiceResetAutoReplyLoopResponse extends $pb.GeneratedMessage {
  factory ThreadServiceResetAutoReplyLoopResponse({
    Thread? thread,
    $core.bool? autoReplyActive,
  }) {
    final result = ThreadServiceResetAutoReplyLoopResponse._();
    if (thread != null) result.thread = thread;
    if (autoReplyActive != null) result.autoReplyActive = autoReplyActive;
    return result;
  }

  ThreadServiceResetAutoReplyLoopResponse._();

  factory ThreadServiceResetAutoReplyLoopResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceResetAutoReplyLoopResponse()
        ..mergeFromBuffer(data, registry);
  factory ThreadServiceResetAutoReplyLoopResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreadServiceResetAutoReplyLoopResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreadServiceResetAutoReplyLoopResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          ThreadServiceResetAutoReplyLoopResponse.$_createMessage)
    ..aOM<Thread>(1, _omitFieldNames ? '' : 'thread',
        subBuilder: Thread.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'autoReplyActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceResetAutoReplyLoopResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreadServiceResetAutoReplyLoopResponse copyWith(
          void Function(ThreadServiceResetAutoReplyLoopResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ThreadServiceResetAutoReplyLoopResponse))
          as ThreadServiceResetAutoReplyLoopResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ThreadServiceResetAutoReplyLoopResponse() / ThreadServiceResetAutoReplyLoopResponse.new instead')
  static ThreadServiceResetAutoReplyLoopResponse create() =>
      ThreadServiceResetAutoReplyLoopResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ThreadServiceResetAutoReplyLoopResponse._();
  @$core.override
  ThreadServiceResetAutoReplyLoopResponse createEmptyInstance() =>
      ThreadServiceResetAutoReplyLoopResponse._();
  @$core.pragma('dart2js:noInline')
  static ThreadServiceResetAutoReplyLoopResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ThreadServiceResetAutoReplyLoopResponse>(
          ThreadServiceResetAutoReplyLoopResponse.$_createMessage);
  static ThreadServiceResetAutoReplyLoopResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Thread get thread => $_getN(0);
  @$pb.TagNumber(1)
  set thread(Thread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThread() => $_has(0);
  @$pb.TagNumber(1)
  void clearThread() => $_clearField(1);
  @$pb.TagNumber(1)
  Thread ensureThread() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get autoReplyActive => $_getBF(1);
  @$pb.TagNumber(2)
  set autoReplyActive($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoReplyActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoReplyActive() => $_clearField(2);
}

class EntityServiceListRequest extends $pb.GeneratedMessage {
  factory EntityServiceListRequest({
    $core.String? workspaceId,
    EntityType? entityType,
    EntityRelationshipState? relationshipState,
    $core.String? searchQuery,
    $2.Pagination? pagination,
  }) {
    final result = EntityServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (entityType != null) result.entityType = entityType;
    if (relationshipState != null) result.relationshipState = relationshipState;
    if (searchQuery != null) result.searchQuery = searchQuery;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  EntityServiceListRequest._();

  factory EntityServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceListRequest()..mergeFromBuffer(data, registry);
  factory EntityServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<EntityType>(2, _omitFieldNames ? '' : 'entityType',
        enumValues: EntityType.values)
    ..aE<EntityRelationshipState>(3, _omitFieldNames ? '' : 'relationshipState',
        enumValues: EntityRelationshipState.values)
    ..aOS(4, _omitFieldNames ? '' : 'searchQuery')
    ..aOM<$2.Pagination>(5, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceListRequest copyWith(
          void Function(EntityServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as EntityServiceListRequest))
          as EntityServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceListRequest() / EntityServiceListRequest.new instead')
  static EntityServiceListRequest create() => EntityServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => EntityServiceListRequest._();
  @$core.override
  EntityServiceListRequest createEmptyInstance() =>
      EntityServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceListRequest>(
          EntityServiceListRequest.$_createMessage);
  static EntityServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  EntityType get entityType => $_getN(1);
  @$pb.TagNumber(2)
  set entityType(EntityType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntityType() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityType() => $_clearField(2);

  @$pb.TagNumber(3)
  EntityRelationshipState get relationshipState => $_getN(2);
  @$pb.TagNumber(3)
  set relationshipState(EntityRelationshipState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRelationshipState() => $_has(2);
  @$pb.TagNumber(3)
  void clearRelationshipState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get searchQuery => $_getSZ(3);
  @$pb.TagNumber(4)
  set searchQuery($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSearchQuery() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearchQuery() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Pagination get pagination => $_getN(4);
  @$pb.TagNumber(5)
  set pagination($2.Pagination value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPagination() => $_has(4);
  @$pb.TagNumber(5)
  void clearPagination() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Pagination ensurePagination() => $_ensure(4);
}

class EntityServiceListResponse extends $pb.GeneratedMessage {
  factory EntityServiceListResponse({
    $core.Iterable<Entity>? entities,
    $2.PaginatedResponse? pagination,
  }) {
    final result = EntityServiceListResponse._();
    if (entities != null) result.entities.addAll(entities);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  EntityServiceListResponse._();

  factory EntityServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceListResponse()..mergeFromBuffer(data, registry);
  factory EntityServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceListResponse.$_createMessage)
    ..pPM<Entity>(1, _omitFieldNames ? '' : 'entities',
        subBuilder: Entity.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceListResponse copyWith(
          void Function(EntityServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as EntityServiceListResponse))
          as EntityServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceListResponse() / EntityServiceListResponse.new instead')
  static EntityServiceListResponse create() => EntityServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceListResponse._();
  @$core.override
  EntityServiceListResponse createEmptyInstance() =>
      EntityServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceListResponse>(
          EntityServiceListResponse.$_createMessage);
  static EntityServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Entity> get entities => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class EntityServiceGetRequest extends $pb.GeneratedMessage {
  factory EntityServiceGetRequest({
    $core.String? workspaceId,
    $core.String? entityId,
  }) {
    final result = EntityServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (entityId != null) result.entityId = entityId;
    return result;
  }

  EntityServiceGetRequest._();

  factory EntityServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceGetRequest()..mergeFromBuffer(data, registry);
  factory EntityServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'entityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceGetRequest copyWith(
          void Function(EntityServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as EntityServiceGetRequest))
          as EntityServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceGetRequest() / EntityServiceGetRequest.new instead')
  static EntityServiceGetRequest create() => EntityServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => EntityServiceGetRequest._();
  @$core.override
  EntityServiceGetRequest createEmptyInstance() => EntityServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceGetRequest>(
          EntityServiceGetRequest.$_createMessage);
  static EntityServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get entityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set entityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEntityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityId() => $_clearField(2);
}

class EntityServiceGetResponse extends $pb.GeneratedMessage {
  factory EntityServiceGetResponse({
    Entity? entity,
    $core.Iterable<Thread>? threads,
  }) {
    final result = EntityServiceGetResponse._();
    if (entity != null) result.entity = entity;
    if (threads != null) result.threads.addAll(threads);
    return result;
  }

  EntityServiceGetResponse._();

  factory EntityServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceGetResponse()..mergeFromBuffer(data, registry);
  factory EntityServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceGetResponse.$_createMessage)
    ..aOM<Entity>(1, _omitFieldNames ? '' : 'entity',
        subBuilder: Entity.$_createMessage)
    ..pPM<Thread>(2, _omitFieldNames ? '' : 'threads',
        subBuilder: Thread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceGetResponse copyWith(
          void Function(EntityServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as EntityServiceGetResponse))
          as EntityServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceGetResponse() / EntityServiceGetResponse.new instead')
  static EntityServiceGetResponse create() => EntityServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => EntityServiceGetResponse._();
  @$core.override
  EntityServiceGetResponse createEmptyInstance() =>
      EntityServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceGetResponse>(
          EntityServiceGetResponse.$_createMessage);
  static EntityServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Entity get entity => $_getN(0);
  @$pb.TagNumber(1)
  set entity(Entity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntity() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntity() => $_clearField(1);
  @$pb.TagNumber(1)
  Entity ensureEntity() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Thread> get threads => $_getList(1);
}

class EntityServiceCreateRequest extends $pb.GeneratedMessage {
  factory EntityServiceCreateRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    EntityType? entityType,
    $core.String? displayName,
    EntityRelationshipState? relationshipState,
    $core.Iterable<$core.String>? platformHandlesJson,
    $core.Iterable<$core.String>? tags,
  }) {
    final result = EntityServiceCreateRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (entityType != null) result.entityType = entityType;
    if (displayName != null) result.displayName = displayName;
    if (relationshipState != null) result.relationshipState = relationshipState;
    if (platformHandlesJson != null)
      result.platformHandlesJson.addAll(platformHandlesJson);
    if (tags != null) result.tags.addAll(tags);
    return result;
  }

  EntityServiceCreateRequest._();

  factory EntityServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory EntityServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceCreateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<EntityType>(3, _omitFieldNames ? '' : 'entityType',
        enumValues: EntityType.values)
    ..aOS(4, _omitFieldNames ? '' : 'displayName')
    ..aE<EntityRelationshipState>(5, _omitFieldNames ? '' : 'relationshipState',
        enumValues: EntityRelationshipState.values)
    ..pPS(6, _omitFieldNames ? '' : 'platformHandlesJson')
    ..pPS(7, _omitFieldNames ? '' : 'tags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceCreateRequest copyWith(
          void Function(EntityServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EntityServiceCreateRequest))
          as EntityServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceCreateRequest() / EntityServiceCreateRequest.new instead')
  static EntityServiceCreateRequest create() => EntityServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceCreateRequest._();
  @$core.override
  EntityServiceCreateRequest createEmptyInstance() =>
      EntityServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceCreateRequest>(
          EntityServiceCreateRequest.$_createMessage);
  static EntityServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  EntityType get entityType => $_getN(2);
  @$pb.TagNumber(3)
  set entityType(EntityType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEntityType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayName() => $_clearField(4);

  @$pb.TagNumber(5)
  EntityRelationshipState get relationshipState => $_getN(4);
  @$pb.TagNumber(5)
  set relationshipState(EntityRelationshipState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRelationshipState() => $_has(4);
  @$pb.TagNumber(5)
  void clearRelationshipState() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get platformHandlesJson => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get tags => $_getList(6);
}

class EntityServiceCreateResponse extends $pb.GeneratedMessage {
  factory EntityServiceCreateResponse({
    Entity? entity,
  }) {
    final result = EntityServiceCreateResponse._();
    if (entity != null) result.entity = entity;
    return result;
  }

  EntityServiceCreateResponse._();

  factory EntityServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory EntityServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceCreateResponse.$_createMessage)
    ..aOM<Entity>(1, _omitFieldNames ? '' : 'entity',
        subBuilder: Entity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceCreateResponse copyWith(
          void Function(EntityServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EntityServiceCreateResponse))
          as EntityServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceCreateResponse() / EntityServiceCreateResponse.new instead')
  static EntityServiceCreateResponse create() =>
      EntityServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceCreateResponse._();
  @$core.override
  EntityServiceCreateResponse createEmptyInstance() =>
      EntityServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceCreateResponse>(
          EntityServiceCreateResponse.$_createMessage);
  static EntityServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Entity get entity => $_getN(0);
  @$pb.TagNumber(1)
  set entity(Entity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntity() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntity() => $_clearField(1);
  @$pb.TagNumber(1)
  Entity ensureEntity() => $_ensure(0);
}

class EntityServiceMergeRequest extends $pb.GeneratedMessage {
  factory EntityServiceMergeRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? primaryEntityId,
    $core.Iterable<$core.String>? secondaryEntityIds,
  }) {
    final result = EntityServiceMergeRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (primaryEntityId != null) result.primaryEntityId = primaryEntityId;
    if (secondaryEntityIds != null)
      result.secondaryEntityIds.addAll(secondaryEntityIds);
    return result;
  }

  EntityServiceMergeRequest._();

  factory EntityServiceMergeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceMergeRequest()..mergeFromBuffer(data, registry);
  factory EntityServiceMergeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceMergeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceMergeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceMergeRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'primaryEntityId')
    ..pPS(4, _omitFieldNames ? '' : 'secondaryEntityIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceMergeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceMergeRequest copyWith(
          void Function(EntityServiceMergeRequest) updates) =>
      super.copyWith((message) => updates(message as EntityServiceMergeRequest))
          as EntityServiceMergeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceMergeRequest() / EntityServiceMergeRequest.new instead')
  static EntityServiceMergeRequest create() => EntityServiceMergeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceMergeRequest._();
  @$core.override
  EntityServiceMergeRequest createEmptyInstance() =>
      EntityServiceMergeRequest._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceMergeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceMergeRequest>(
          EntityServiceMergeRequest.$_createMessage);
  static EntityServiceMergeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get primaryEntityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set primaryEntityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrimaryEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrimaryEntityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get secondaryEntityIds => $_getList(3);
}

class EntityServiceMergeResponse extends $pb.GeneratedMessage {
  factory EntityServiceMergeResponse({
    Entity? mergedEntity,
    $core.int? threadsReassigned,
  }) {
    final result = EntityServiceMergeResponse._();
    if (mergedEntity != null) result.mergedEntity = mergedEntity;
    if (threadsReassigned != null) result.threadsReassigned = threadsReassigned;
    return result;
  }

  EntityServiceMergeResponse._();

  factory EntityServiceMergeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceMergeResponse()..mergeFromBuffer(data, registry);
  factory EntityServiceMergeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceMergeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceMergeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceMergeResponse.$_createMessage)
    ..aOM<Entity>(1, _omitFieldNames ? '' : 'mergedEntity',
        subBuilder: Entity.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'threadsReassigned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceMergeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceMergeResponse copyWith(
          void Function(EntityServiceMergeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EntityServiceMergeResponse))
          as EntityServiceMergeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceMergeResponse() / EntityServiceMergeResponse.new instead')
  static EntityServiceMergeResponse create() => EntityServiceMergeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceMergeResponse._();
  @$core.override
  EntityServiceMergeResponse createEmptyInstance() =>
      EntityServiceMergeResponse._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceMergeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceMergeResponse>(
          EntityServiceMergeResponse.$_createMessage);
  static EntityServiceMergeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Entity get mergedEntity => $_getN(0);
  @$pb.TagNumber(1)
  set mergedEntity(Entity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMergedEntity() => $_has(0);
  @$pb.TagNumber(1)
  void clearMergedEntity() => $_clearField(1);
  @$pb.TagNumber(1)
  Entity ensureMergedEntity() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get threadsReassigned => $_getIZ(1);
  @$pb.TagNumber(2)
  set threadsReassigned($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadsReassigned() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadsReassigned() => $_clearField(2);
}

class EntityServiceAddNoteRequest extends $pb.GeneratedMessage {
  factory EntityServiceAddNoteRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? entityId,
    $core.String? note,
  }) {
    final result = EntityServiceAddNoteRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (entityId != null) result.entityId = entityId;
    if (note != null) result.note = note;
    return result;
  }

  EntityServiceAddNoteRequest._();

  factory EntityServiceAddNoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceAddNoteRequest()..mergeFromBuffer(data, registry);
  factory EntityServiceAddNoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceAddNoteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceAddNoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceAddNoteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'entityId')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceAddNoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceAddNoteRequest copyWith(
          void Function(EntityServiceAddNoteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EntityServiceAddNoteRequest))
          as EntityServiceAddNoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceAddNoteRequest() / EntityServiceAddNoteRequest.new instead')
  static EntityServiceAddNoteRequest create() =>
      EntityServiceAddNoteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceAddNoteRequest._();
  @$core.override
  EntityServiceAddNoteRequest createEmptyInstance() =>
      EntityServiceAddNoteRequest._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceAddNoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceAddNoteRequest>(
          EntityServiceAddNoteRequest.$_createMessage);
  static EntityServiceAddNoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get entityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set entityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class EntityServiceAddNoteResponse extends $pb.GeneratedMessage {
  factory EntityServiceAddNoteResponse({
    Entity? entity,
  }) {
    final result = EntityServiceAddNoteResponse._();
    if (entity != null) result.entity = entity;
    return result;
  }

  EntityServiceAddNoteResponse._();

  factory EntityServiceAddNoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceAddNoteResponse()..mergeFromBuffer(data, registry);
  factory EntityServiceAddNoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceAddNoteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceAddNoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceAddNoteResponse.$_createMessage)
    ..aOM<Entity>(1, _omitFieldNames ? '' : 'entity',
        subBuilder: Entity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceAddNoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceAddNoteResponse copyWith(
          void Function(EntityServiceAddNoteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EntityServiceAddNoteResponse))
          as EntityServiceAddNoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceAddNoteResponse() / EntityServiceAddNoteResponse.new instead')
  static EntityServiceAddNoteResponse create() =>
      EntityServiceAddNoteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceAddNoteResponse._();
  @$core.override
  EntityServiceAddNoteResponse createEmptyInstance() =>
      EntityServiceAddNoteResponse._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceAddNoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceAddNoteResponse>(
          EntityServiceAddNoteResponse.$_createMessage);
  static EntityServiceAddNoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Entity get entity => $_getN(0);
  @$pb.TagNumber(1)
  set entity(Entity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntity() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntity() => $_clearField(1);
  @$pb.TagNumber(1)
  Entity ensureEntity() => $_ensure(0);
}

class EntityServiceAddTagRequest extends $pb.GeneratedMessage {
  factory EntityServiceAddTagRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? entityId,
    $core.String? tag,
  }) {
    final result = EntityServiceAddTagRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (entityId != null) result.entityId = entityId;
    if (tag != null) result.tag = tag;
    return result;
  }

  EntityServiceAddTagRequest._();

  factory EntityServiceAddTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceAddTagRequest()..mergeFromBuffer(data, registry);
  factory EntityServiceAddTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceAddTagRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceAddTagRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceAddTagRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'entityId')
    ..aOS(4, _omitFieldNames ? '' : 'tag')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceAddTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceAddTagRequest copyWith(
          void Function(EntityServiceAddTagRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EntityServiceAddTagRequest))
          as EntityServiceAddTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceAddTagRequest() / EntityServiceAddTagRequest.new instead')
  static EntityServiceAddTagRequest create() => EntityServiceAddTagRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceAddTagRequest._();
  @$core.override
  EntityServiceAddTagRequest createEmptyInstance() =>
      EntityServiceAddTagRequest._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceAddTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceAddTagRequest>(
          EntityServiceAddTagRequest.$_createMessage);
  static EntityServiceAddTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get entityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set entityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get tag => $_getSZ(3);
  @$pb.TagNumber(4)
  set tag($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTag() => $_has(3);
  @$pb.TagNumber(4)
  void clearTag() => $_clearField(4);
}

class EntityServiceAddTagResponse extends $pb.GeneratedMessage {
  factory EntityServiceAddTagResponse({
    Entity? entity,
  }) {
    final result = EntityServiceAddTagResponse._();
    if (entity != null) result.entity = entity;
    return result;
  }

  EntityServiceAddTagResponse._();

  factory EntityServiceAddTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceAddTagResponse()..mergeFromBuffer(data, registry);
  factory EntityServiceAddTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityServiceAddTagResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityServiceAddTagResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: EntityServiceAddTagResponse.$_createMessage)
    ..aOM<Entity>(1, _omitFieldNames ? '' : 'entity',
        subBuilder: Entity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceAddTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityServiceAddTagResponse copyWith(
          void Function(EntityServiceAddTagResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EntityServiceAddTagResponse))
          as EntityServiceAddTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityServiceAddTagResponse() / EntityServiceAddTagResponse.new instead')
  static EntityServiceAddTagResponse create() =>
      EntityServiceAddTagResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EntityServiceAddTagResponse._();
  @$core.override
  EntityServiceAddTagResponse createEmptyInstance() =>
      EntityServiceAddTagResponse._();
  @$core.pragma('dart2js:noInline')
  static EntityServiceAddTagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityServiceAddTagResponse>(
          EntityServiceAddTagResponse.$_createMessage);
  static EntityServiceAddTagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Entity get entity => $_getN(0);
  @$pb.TagNumber(1)
  set entity(Entity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntity() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntity() => $_clearField(1);
  @$pb.TagNumber(1)
  Entity ensureEntity() => $_ensure(0);
}

class SuggestionServiceGetReplyRequest extends $pb.GeneratedMessage {
  factory SuggestionServiceGetReplyRequest({
    $core.String? workspaceId,
    $core.String? threadId,
    $core.String? tone,
  }) {
    final result = SuggestionServiceGetReplyRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    if (tone != null) result.tone = tone;
    return result;
  }

  SuggestionServiceGetReplyRequest._();

  factory SuggestionServiceGetReplyRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionServiceGetReplyRequest()..mergeFromBuffer(data, registry);
  factory SuggestionServiceGetReplyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionServiceGetReplyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestionServiceGetReplyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: SuggestionServiceGetReplyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..aOS(3, _omitFieldNames ? '' : 'tone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionServiceGetReplyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionServiceGetReplyRequest copyWith(
          void Function(SuggestionServiceGetReplyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SuggestionServiceGetReplyRequest))
          as SuggestionServiceGetReplyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SuggestionServiceGetReplyRequest() / SuggestionServiceGetReplyRequest.new instead')
  static SuggestionServiceGetReplyRequest create() =>
      SuggestionServiceGetReplyRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SuggestionServiceGetReplyRequest._();
  @$core.override
  SuggestionServiceGetReplyRequest createEmptyInstance() =>
      SuggestionServiceGetReplyRequest._();
  @$core.pragma('dart2js:noInline')
  static SuggestionServiceGetReplyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestionServiceGetReplyRequest>(
          SuggestionServiceGetReplyRequest.$_createMessage);
  static SuggestionServiceGetReplyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get tone => $_getSZ(2);
  @$pb.TagNumber(3)
  set tone($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTone() => $_has(2);
  @$pb.TagNumber(3)
  void clearTone() => $_clearField(3);
}

class SuggestionServiceGetReplyResponse extends $pb.GeneratedMessage {
  factory SuggestionServiceGetReplyResponse({
    $core.Iterable<SuggestedReply>? suggestions,
  }) {
    final result = SuggestionServiceGetReplyResponse._();
    if (suggestions != null) result.suggestions.addAll(suggestions);
    return result;
  }

  SuggestionServiceGetReplyResponse._();

  factory SuggestionServiceGetReplyResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionServiceGetReplyResponse()..mergeFromBuffer(data, registry);
  factory SuggestionServiceGetReplyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionServiceGetReplyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestionServiceGetReplyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: SuggestionServiceGetReplyResponse.$_createMessage)
    ..pPM<SuggestedReply>(1, _omitFieldNames ? '' : 'suggestions',
        subBuilder: SuggestedReply.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionServiceGetReplyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionServiceGetReplyResponse copyWith(
          void Function(SuggestionServiceGetReplyResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SuggestionServiceGetReplyResponse))
          as SuggestionServiceGetReplyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SuggestionServiceGetReplyResponse() / SuggestionServiceGetReplyResponse.new instead')
  static SuggestionServiceGetReplyResponse create() =>
      SuggestionServiceGetReplyResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SuggestionServiceGetReplyResponse._();
  @$core.override
  SuggestionServiceGetReplyResponse createEmptyInstance() =>
      SuggestionServiceGetReplyResponse._();
  @$core.pragma('dart2js:noInline')
  static SuggestionServiceGetReplyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestionServiceGetReplyResponse>(
          SuggestionServiceGetReplyResponse.$_createMessage);
  static SuggestionServiceGetReplyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SuggestedReply> get suggestions => $_getList(0);
}

class SuggestionServiceGetActionsRequest extends $pb.GeneratedMessage {
  factory SuggestionServiceGetActionsRequest({
    $core.String? workspaceId,
    $core.String? threadId,
  }) {
    final result = SuggestionServiceGetActionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (threadId != null) result.threadId = threadId;
    return result;
  }

  SuggestionServiceGetActionsRequest._();

  factory SuggestionServiceGetActionsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionServiceGetActionsRequest()..mergeFromBuffer(data, registry);
  factory SuggestionServiceGetActionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionServiceGetActionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestionServiceGetActionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: SuggestionServiceGetActionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'threadId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionServiceGetActionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionServiceGetActionsRequest copyWith(
          void Function(SuggestionServiceGetActionsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SuggestionServiceGetActionsRequest))
          as SuggestionServiceGetActionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SuggestionServiceGetActionsRequest() / SuggestionServiceGetActionsRequest.new instead')
  static SuggestionServiceGetActionsRequest create() =>
      SuggestionServiceGetActionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SuggestionServiceGetActionsRequest._();
  @$core.override
  SuggestionServiceGetActionsRequest createEmptyInstance() =>
      SuggestionServiceGetActionsRequest._();
  @$core.pragma('dart2js:noInline')
  static SuggestionServiceGetActionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestionServiceGetActionsRequest>(
          SuggestionServiceGetActionsRequest.$_createMessage);
  static SuggestionServiceGetActionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get threadId => $_getSZ(1);
  @$pb.TagNumber(2)
  set threadId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThreadId() => $_has(1);
  @$pb.TagNumber(2)
  void clearThreadId() => $_clearField(2);
}

class SuggestionServiceGetActionsResponse extends $pb.GeneratedMessage {
  factory SuggestionServiceGetActionsResponse({
    $core.Iterable<SuggestedAction>? actions,
  }) {
    final result = SuggestionServiceGetActionsResponse._();
    if (actions != null) result.actions.addAll(actions);
    return result;
  }

  SuggestionServiceGetActionsResponse._();

  factory SuggestionServiceGetActionsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionServiceGetActionsResponse()..mergeFromBuffer(data, registry);
  factory SuggestionServiceGetActionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionServiceGetActionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestionServiceGetActionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: SuggestionServiceGetActionsResponse.$_createMessage)
    ..pPM<SuggestedAction>(1, _omitFieldNames ? '' : 'actions',
        subBuilder: SuggestedAction.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionServiceGetActionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionServiceGetActionsResponse copyWith(
          void Function(SuggestionServiceGetActionsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SuggestionServiceGetActionsResponse))
          as SuggestionServiceGetActionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SuggestionServiceGetActionsResponse() / SuggestionServiceGetActionsResponse.new instead')
  static SuggestionServiceGetActionsResponse create() =>
      SuggestionServiceGetActionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SuggestionServiceGetActionsResponse._();
  @$core.override
  SuggestionServiceGetActionsResponse createEmptyInstance() =>
      SuggestionServiceGetActionsResponse._();
  @$core.pragma('dart2js:noInline')
  static SuggestionServiceGetActionsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SuggestionServiceGetActionsResponse>(
          SuggestionServiceGetActionsResponse.$_createMessage);
  static SuggestionServiceGetActionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SuggestedAction> get actions => $_getList(0);
}

class FollowUpServiceCreateRequest extends $pb.GeneratedMessage {
  factory FollowUpServiceCreateRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? sourceThreadId,
    $core.String? taskType,
    $core.String? title,
    $core.String? description,
    $1.Timestamp? dueAt,
    $core.String? assignedUserId,
  }) {
    final result = FollowUpServiceCreateRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sourceThreadId != null) result.sourceThreadId = sourceThreadId;
    if (taskType != null) result.taskType = taskType;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (dueAt != null) result.dueAt = dueAt;
    if (assignedUserId != null) result.assignedUserId = assignedUserId;
    return result;
  }

  FollowUpServiceCreateRequest._();

  factory FollowUpServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory FollowUpServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceCreateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'sourceThreadId')
    ..aOS(4, _omitFieldNames ? '' : 'taskType')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'assignedUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceCreateRequest copyWith(
          void Function(FollowUpServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceCreateRequest))
          as FollowUpServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceCreateRequest() / FollowUpServiceCreateRequest.new instead')
  static FollowUpServiceCreateRequest create() =>
      FollowUpServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceCreateRequest._();
  @$core.override
  FollowUpServiceCreateRequest createEmptyInstance() =>
      FollowUpServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceCreateRequest>(
          FollowUpServiceCreateRequest.$_createMessage);
  static FollowUpServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceThreadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceThreadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceThreadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceThreadId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get taskType => $_getSZ(3);
  @$pb.TagNumber(4)
  set taskType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTaskType() => $_has(3);
  @$pb.TagNumber(4)
  void clearTaskType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get dueAt => $_getN(6);
  @$pb.TagNumber(7)
  set dueAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDueAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearDueAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureDueAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get assignedUserId => $_getSZ(7);
  @$pb.TagNumber(8)
  set assignedUserId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAssignedUserId() => $_has(7);
  @$pb.TagNumber(8)
  void clearAssignedUserId() => $_clearField(8);
}

class FollowUpServiceCreateResponse extends $pb.GeneratedMessage {
  factory FollowUpServiceCreateResponse({
    FollowUpTask? task,
  }) {
    final result = FollowUpServiceCreateResponse._();
    if (task != null) result.task = task;
    return result;
  }

  FollowUpServiceCreateResponse._();

  factory FollowUpServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory FollowUpServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceCreateResponse.$_createMessage)
    ..aOM<FollowUpTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: FollowUpTask.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceCreateResponse copyWith(
          void Function(FollowUpServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceCreateResponse))
          as FollowUpServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceCreateResponse() / FollowUpServiceCreateResponse.new instead')
  static FollowUpServiceCreateResponse create() =>
      FollowUpServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceCreateResponse._();
  @$core.override
  FollowUpServiceCreateResponse createEmptyInstance() =>
      FollowUpServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceCreateResponse>(
          FollowUpServiceCreateResponse.$_createMessage);
  static FollowUpServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FollowUpTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(FollowUpTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  FollowUpTask ensureTask() => $_ensure(0);
}

class FollowUpServiceListRequest extends $pb.GeneratedMessage {
  factory FollowUpServiceListRequest({
    $core.String? workspaceId,
    $core.String? assignedUserId,
    FollowUpTaskStatus? status,
    $2.Pagination? pagination,
  }) {
    final result = FollowUpServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assignedUserId != null) result.assignedUserId = assignedUserId;
    if (status != null) result.status = status;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  FollowUpServiceListRequest._();

  factory FollowUpServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceListRequest()..mergeFromBuffer(data, registry);
  factory FollowUpServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'assignedUserId')
    ..aE<FollowUpTaskStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: FollowUpTaskStatus.values)
    ..aOM<$2.Pagination>(4, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceListRequest copyWith(
          void Function(FollowUpServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceListRequest))
          as FollowUpServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceListRequest() / FollowUpServiceListRequest.new instead')
  static FollowUpServiceListRequest create() => FollowUpServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceListRequest._();
  @$core.override
  FollowUpServiceListRequest createEmptyInstance() =>
      FollowUpServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceListRequest>(
          FollowUpServiceListRequest.$_createMessage);
  static FollowUpServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assignedUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assignedUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssignedUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssignedUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  FollowUpTaskStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(FollowUpTaskStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Pagination get pagination => $_getN(3);
  @$pb.TagNumber(4)
  set pagination($2.Pagination value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPagination() => $_has(3);
  @$pb.TagNumber(4)
  void clearPagination() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Pagination ensurePagination() => $_ensure(3);
}

class FollowUpServiceListResponse extends $pb.GeneratedMessage {
  factory FollowUpServiceListResponse({
    $core.Iterable<FollowUpTask>? tasks,
    $2.PaginatedResponse? pagination,
  }) {
    final result = FollowUpServiceListResponse._();
    if (tasks != null) result.tasks.addAll(tasks);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  FollowUpServiceListResponse._();

  factory FollowUpServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceListResponse()..mergeFromBuffer(data, registry);
  factory FollowUpServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceListResponse.$_createMessage)
    ..pPM<FollowUpTask>(1, _omitFieldNames ? '' : 'tasks',
        subBuilder: FollowUpTask.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceListResponse copyWith(
          void Function(FollowUpServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceListResponse))
          as FollowUpServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceListResponse() / FollowUpServiceListResponse.new instead')
  static FollowUpServiceListResponse create() =>
      FollowUpServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceListResponse._();
  @$core.override
  FollowUpServiceListResponse createEmptyInstance() =>
      FollowUpServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceListResponse>(
          FollowUpServiceListResponse.$_createMessage);
  static FollowUpServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FollowUpTask> get tasks => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class FollowUpServiceUpdateRequest extends $pb.GeneratedMessage {
  factory FollowUpServiceUpdateRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? taskId,
    FollowUpTaskStatus? status,
    $core.String? outcomeSummary,
  }) {
    final result = FollowUpServiceUpdateRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (taskId != null) result.taskId = taskId;
    if (status != null) result.status = status;
    if (outcomeSummary != null) result.outcomeSummary = outcomeSummary;
    return result;
  }

  FollowUpServiceUpdateRequest._();

  factory FollowUpServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory FollowUpServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceUpdateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'taskId')
    ..aE<FollowUpTaskStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: FollowUpTaskStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'outcomeSummary')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceUpdateRequest copyWith(
          void Function(FollowUpServiceUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceUpdateRequest))
          as FollowUpServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceUpdateRequest() / FollowUpServiceUpdateRequest.new instead')
  static FollowUpServiceUpdateRequest create() =>
      FollowUpServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceUpdateRequest._();
  @$core.override
  FollowUpServiceUpdateRequest createEmptyInstance() =>
      FollowUpServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceUpdateRequest>(
          FollowUpServiceUpdateRequest.$_createMessage);
  static FollowUpServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get taskId => $_getSZ(2);
  @$pb.TagNumber(3)
  set taskId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTaskId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTaskId() => $_clearField(3);

  @$pb.TagNumber(4)
  FollowUpTaskStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(FollowUpTaskStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get outcomeSummary => $_getSZ(4);
  @$pb.TagNumber(5)
  set outcomeSummary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOutcomeSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutcomeSummary() => $_clearField(5);
}

class FollowUpServiceUpdateResponse extends $pb.GeneratedMessage {
  factory FollowUpServiceUpdateResponse({
    FollowUpTask? task,
  }) {
    final result = FollowUpServiceUpdateResponse._();
    if (task != null) result.task = task;
    return result;
  }

  FollowUpServiceUpdateResponse._();

  factory FollowUpServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory FollowUpServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceUpdateResponse.$_createMessage)
    ..aOM<FollowUpTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: FollowUpTask.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceUpdateResponse copyWith(
          void Function(FollowUpServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceUpdateResponse))
          as FollowUpServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceUpdateResponse() / FollowUpServiceUpdateResponse.new instead')
  static FollowUpServiceUpdateResponse create() =>
      FollowUpServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceUpdateResponse._();
  @$core.override
  FollowUpServiceUpdateResponse createEmptyInstance() =>
      FollowUpServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceUpdateResponse>(
          FollowUpServiceUpdateResponse.$_createMessage);
  static FollowUpServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FollowUpTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(FollowUpTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  FollowUpTask ensureTask() => $_ensure(0);
}

class FollowUpServiceCompleteRequest extends $pb.GeneratedMessage {
  factory FollowUpServiceCompleteRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? taskId,
    $core.String? outcomeSummary,
  }) {
    final result = FollowUpServiceCompleteRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (taskId != null) result.taskId = taskId;
    if (outcomeSummary != null) result.outcomeSummary = outcomeSummary;
    return result;
  }

  FollowUpServiceCompleteRequest._();

  factory FollowUpServiceCompleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceCompleteRequest()..mergeFromBuffer(data, registry);
  factory FollowUpServiceCompleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceCompleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceCompleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceCompleteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'taskId')
    ..aOS(4, _omitFieldNames ? '' : 'outcomeSummary')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceCompleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceCompleteRequest copyWith(
          void Function(FollowUpServiceCompleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceCompleteRequest))
          as FollowUpServiceCompleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceCompleteRequest() / FollowUpServiceCompleteRequest.new instead')
  static FollowUpServiceCompleteRequest create() =>
      FollowUpServiceCompleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceCompleteRequest._();
  @$core.override
  FollowUpServiceCompleteRequest createEmptyInstance() =>
      FollowUpServiceCompleteRequest._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceCompleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceCompleteRequest>(
          FollowUpServiceCompleteRequest.$_createMessage);
  static FollowUpServiceCompleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get taskId => $_getSZ(2);
  @$pb.TagNumber(3)
  set taskId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTaskId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTaskId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get outcomeSummary => $_getSZ(3);
  @$pb.TagNumber(4)
  set outcomeSummary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutcomeSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutcomeSummary() => $_clearField(4);
}

class FollowUpServiceCompleteResponse extends $pb.GeneratedMessage {
  factory FollowUpServiceCompleteResponse({
    FollowUpTask? task,
  }) {
    final result = FollowUpServiceCompleteResponse._();
    if (task != null) result.task = task;
    return result;
  }

  FollowUpServiceCompleteResponse._();

  factory FollowUpServiceCompleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceCompleteResponse()..mergeFromBuffer(data, registry);
  factory FollowUpServiceCompleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceCompleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceCompleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceCompleteResponse.$_createMessage)
    ..aOM<FollowUpTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: FollowUpTask.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceCompleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceCompleteResponse copyWith(
          void Function(FollowUpServiceCompleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceCompleteResponse))
          as FollowUpServiceCompleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceCompleteResponse() / FollowUpServiceCompleteResponse.new instead')
  static FollowUpServiceCompleteResponse create() =>
      FollowUpServiceCompleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceCompleteResponse._();
  @$core.override
  FollowUpServiceCompleteResponse createEmptyInstance() =>
      FollowUpServiceCompleteResponse._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceCompleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceCompleteResponse>(
          FollowUpServiceCompleteResponse.$_createMessage);
  static FollowUpServiceCompleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FollowUpTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(FollowUpTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  FollowUpTask ensureTask() => $_ensure(0);
}

class FollowUpServiceRescheduleRequest extends $pb.GeneratedMessage {
  factory FollowUpServiceRescheduleRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? taskId,
    $1.Timestamp? newDueAt,
  }) {
    final result = FollowUpServiceRescheduleRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (taskId != null) result.taskId = taskId;
    if (newDueAt != null) result.newDueAt = newDueAt;
    return result;
  }

  FollowUpServiceRescheduleRequest._();

  factory FollowUpServiceRescheduleRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceRescheduleRequest()..mergeFromBuffer(data, registry);
  factory FollowUpServiceRescheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceRescheduleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceRescheduleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceRescheduleRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'taskId')
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'newDueAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceRescheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceRescheduleRequest copyWith(
          void Function(FollowUpServiceRescheduleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as FollowUpServiceRescheduleRequest))
          as FollowUpServiceRescheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceRescheduleRequest() / FollowUpServiceRescheduleRequest.new instead')
  static FollowUpServiceRescheduleRequest create() =>
      FollowUpServiceRescheduleRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceRescheduleRequest._();
  @$core.override
  FollowUpServiceRescheduleRequest createEmptyInstance() =>
      FollowUpServiceRescheduleRequest._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceRescheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceRescheduleRequest>(
          FollowUpServiceRescheduleRequest.$_createMessage);
  static FollowUpServiceRescheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get taskId => $_getSZ(2);
  @$pb.TagNumber(3)
  set taskId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTaskId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTaskId() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get newDueAt => $_getN(3);
  @$pb.TagNumber(4)
  set newDueAt($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNewDueAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewDueAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureNewDueAt() => $_ensure(3);
}

class FollowUpServiceRescheduleResponse extends $pb.GeneratedMessage {
  factory FollowUpServiceRescheduleResponse({
    FollowUpTask? task,
  }) {
    final result = FollowUpServiceRescheduleResponse._();
    if (task != null) result.task = task;
    return result;
  }

  FollowUpServiceRescheduleResponse._();

  factory FollowUpServiceRescheduleResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceRescheduleResponse()..mergeFromBuffer(data, registry);
  factory FollowUpServiceRescheduleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowUpServiceRescheduleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowUpServiceRescheduleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance: FollowUpServiceRescheduleResponse.$_createMessage)
    ..aOM<FollowUpTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: FollowUpTask.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceRescheduleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowUpServiceRescheduleResponse copyWith(
          void Function(FollowUpServiceRescheduleResponse) updates) =>
      super.copyWith((message) =>
              updates(message as FollowUpServiceRescheduleResponse))
          as FollowUpServiceRescheduleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FollowUpServiceRescheduleResponse() / FollowUpServiceRescheduleResponse.new instead')
  static FollowUpServiceRescheduleResponse create() =>
      FollowUpServiceRescheduleResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      FollowUpServiceRescheduleResponse._();
  @$core.override
  FollowUpServiceRescheduleResponse createEmptyInstance() =>
      FollowUpServiceRescheduleResponse._();
  @$core.pragma('dart2js:noInline')
  static FollowUpServiceRescheduleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowUpServiceRescheduleResponse>(
          FollowUpServiceRescheduleResponse.$_createMessage);
  static FollowUpServiceRescheduleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FollowUpTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(FollowUpTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  FollowUpTask ensureTask() => $_ensure(0);
}

class EngagementProtectionServiceGetThrottleStatusRequest
    extends $pb.GeneratedMessage {
  factory EngagementProtectionServiceGetThrottleStatusRequest({
    $core.String? workspaceId,
  }) {
    final result = EngagementProtectionServiceGetThrottleStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  EngagementProtectionServiceGetThrottleStatusRequest._();

  factory EngagementProtectionServiceGetThrottleStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceGetThrottleStatusRequest()
        ..mergeFromBuffer(data, registry);
  factory EngagementProtectionServiceGetThrottleStatusRequest.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceGetThrottleStatusRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames
          ? ''
          : 'EngagementProtectionServiceGetThrottleStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          EngagementProtectionServiceGetThrottleStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceGetThrottleStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceGetThrottleStatusRequest copyWith(
          void Function(EngagementProtectionServiceGetThrottleStatusRequest)
              updates) =>
      super.copyWith((message) => updates(
              message as EngagementProtectionServiceGetThrottleStatusRequest))
          as EngagementProtectionServiceGetThrottleStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EngagementProtectionServiceGetThrottleStatusRequest() / EngagementProtectionServiceGetThrottleStatusRequest.new instead')
  static EngagementProtectionServiceGetThrottleStatusRequest create() =>
      EngagementProtectionServiceGetThrottleStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EngagementProtectionServiceGetThrottleStatusRequest._();
  @$core.override
  EngagementProtectionServiceGetThrottleStatusRequest createEmptyInstance() =>
      EngagementProtectionServiceGetThrottleStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static EngagementProtectionServiceGetThrottleStatusRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              EngagementProtectionServiceGetThrottleStatusRequest>(
          EngagementProtectionServiceGetThrottleStatusRequest.$_createMessage);
  static EngagementProtectionServiceGetThrottleStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class EngagementProtectionServiceGetThrottleStatusResponse
    extends $pb.GeneratedMessage {
  factory EngagementProtectionServiceGetThrottleStatusResponse({
    EngagementThrottleStatus? throttleStatus,
  }) {
    final result = EngagementProtectionServiceGetThrottleStatusResponse._();
    if (throttleStatus != null) result.throttleStatus = throttleStatus;
    return result;
  }

  EngagementProtectionServiceGetThrottleStatusResponse._();

  factory EngagementProtectionServiceGetThrottleStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceGetThrottleStatusResponse()
        ..mergeFromBuffer(data, registry);
  factory EngagementProtectionServiceGetThrottleStatusResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceGetThrottleStatusResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames
          ? ''
          : 'EngagementProtectionServiceGetThrottleStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          EngagementProtectionServiceGetThrottleStatusResponse.$_createMessage)
    ..aOM<EngagementThrottleStatus>(1, _omitFieldNames ? '' : 'throttleStatus',
        subBuilder: EngagementThrottleStatus.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceGetThrottleStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceGetThrottleStatusResponse copyWith(
          void Function(EngagementProtectionServiceGetThrottleStatusResponse)
              updates) =>
      super.copyWith((message) => updates(
              message as EngagementProtectionServiceGetThrottleStatusResponse))
          as EngagementProtectionServiceGetThrottleStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EngagementProtectionServiceGetThrottleStatusResponse() / EngagementProtectionServiceGetThrottleStatusResponse.new instead')
  static EngagementProtectionServiceGetThrottleStatusResponse create() =>
      EngagementProtectionServiceGetThrottleStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EngagementProtectionServiceGetThrottleStatusResponse._();
  @$core.override
  EngagementProtectionServiceGetThrottleStatusResponse createEmptyInstance() =>
      EngagementProtectionServiceGetThrottleStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static EngagementProtectionServiceGetThrottleStatusResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              EngagementProtectionServiceGetThrottleStatusResponse>(
          EngagementProtectionServiceGetThrottleStatusResponse.$_createMessage);
  static EngagementProtectionServiceGetThrottleStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EngagementThrottleStatus get throttleStatus => $_getN(0);
  @$pb.TagNumber(1)
  set throttleStatus(EngagementThrottleStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasThrottleStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearThrottleStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  EngagementThrottleStatus ensureThrottleStatus() => $_ensure(0);
}

class EngagementProtectionServiceTriggerBatchAnalysisRequest
    extends $pb.GeneratedMessage {
  factory EngagementProtectionServiceTriggerBatchAnalysisRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.int? maxBatchSize,
  }) {
    final result = EngagementProtectionServiceTriggerBatchAnalysisRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (maxBatchSize != null) result.maxBatchSize = maxBatchSize;
    return result;
  }

  EngagementProtectionServiceTriggerBatchAnalysisRequest._();

  factory EngagementProtectionServiceTriggerBatchAnalysisRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceTriggerBatchAnalysisRequest()
        ..mergeFromBuffer(data, registry);
  factory EngagementProtectionServiceTriggerBatchAnalysisRequest.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceTriggerBatchAnalysisRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames
          ? ''
          : 'EngagementProtectionServiceTriggerBatchAnalysisRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          EngagementProtectionServiceTriggerBatchAnalysisRequest
              .$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aI(3, _omitFieldNames ? '' : 'maxBatchSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceTriggerBatchAnalysisRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceTriggerBatchAnalysisRequest copyWith(
          void Function(EngagementProtectionServiceTriggerBatchAnalysisRequest)
              updates) =>
      super.copyWith((message) => updates(message
              as EngagementProtectionServiceTriggerBatchAnalysisRequest))
          as EngagementProtectionServiceTriggerBatchAnalysisRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EngagementProtectionServiceTriggerBatchAnalysisRequest() / EngagementProtectionServiceTriggerBatchAnalysisRequest.new instead')
  static EngagementProtectionServiceTriggerBatchAnalysisRequest create() =>
      EngagementProtectionServiceTriggerBatchAnalysisRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EngagementProtectionServiceTriggerBatchAnalysisRequest._();
  @$core.override
  EngagementProtectionServiceTriggerBatchAnalysisRequest
      createEmptyInstance() =>
          EngagementProtectionServiceTriggerBatchAnalysisRequest._();
  @$core.pragma('dart2js:noInline')
  static EngagementProtectionServiceTriggerBatchAnalysisRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              EngagementProtectionServiceTriggerBatchAnalysisRequest>(
          EngagementProtectionServiceTriggerBatchAnalysisRequest
              .$_createMessage);
  static EngagementProtectionServiceTriggerBatchAnalysisRequest?
      _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxBatchSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxBatchSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxBatchSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxBatchSize() => $_clearField(3);
}

class EngagementProtectionServiceTriggerBatchAnalysisResponse
    extends $pb.GeneratedMessage {
  factory EngagementProtectionServiceTriggerBatchAnalysisResponse({
    $core.int? analyzedCount,
    EngagementThrottleStatus? throttleStatus,
  }) {
    final result = EngagementProtectionServiceTriggerBatchAnalysisResponse._();
    if (analyzedCount != null) result.analyzedCount = analyzedCount;
    if (throttleStatus != null) result.throttleStatus = throttleStatus;
    return result;
  }

  EngagementProtectionServiceTriggerBatchAnalysisResponse._();

  factory EngagementProtectionServiceTriggerBatchAnalysisResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceTriggerBatchAnalysisResponse()
        ..mergeFromBuffer(data, registry);
  factory EngagementProtectionServiceTriggerBatchAnalysisResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceTriggerBatchAnalysisResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames
          ? ''
          : 'EngagementProtectionServiceTriggerBatchAnalysisResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          EngagementProtectionServiceTriggerBatchAnalysisResponse
              .$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'analyzedCount')
    ..aOM<EngagementThrottleStatus>(2, _omitFieldNames ? '' : 'throttleStatus',
        subBuilder: EngagementThrottleStatus.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceTriggerBatchAnalysisResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceTriggerBatchAnalysisResponse copyWith(
          void Function(EngagementProtectionServiceTriggerBatchAnalysisResponse)
              updates) =>
      super.copyWith((message) => updates(message
              as EngagementProtectionServiceTriggerBatchAnalysisResponse))
          as EngagementProtectionServiceTriggerBatchAnalysisResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EngagementProtectionServiceTriggerBatchAnalysisResponse() / EngagementProtectionServiceTriggerBatchAnalysisResponse.new instead')
  static EngagementProtectionServiceTriggerBatchAnalysisResponse create() =>
      EngagementProtectionServiceTriggerBatchAnalysisResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EngagementProtectionServiceTriggerBatchAnalysisResponse._();
  @$core.override
  EngagementProtectionServiceTriggerBatchAnalysisResponse
      createEmptyInstance() =>
          EngagementProtectionServiceTriggerBatchAnalysisResponse._();
  @$core.pragma('dart2js:noInline')
  static EngagementProtectionServiceTriggerBatchAnalysisResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              EngagementProtectionServiceTriggerBatchAnalysisResponse>(
          EngagementProtectionServiceTriggerBatchAnalysisResponse
              .$_createMessage);
  static EngagementProtectionServiceTriggerBatchAnalysisResponse?
      _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get analyzedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set analyzedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAnalyzedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnalyzedCount() => $_clearField(1);

  @$pb.TagNumber(2)
  EngagementThrottleStatus get throttleStatus => $_getN(1);
  @$pb.TagNumber(2)
  set throttleStatus(EngagementThrottleStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasThrottleStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearThrottleStatus() => $_clearField(2);
  @$pb.TagNumber(2)
  EngagementThrottleStatus ensureThrottleStatus() => $_ensure(1);
}

class EngagementProtectionServiceRepairRevokedAccountRequest
    extends $pb.GeneratedMessage {
  factory EngagementProtectionServiceRepairRevokedAccountRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? connectedAccountId,
    $core.String? newAccessToken,
  }) {
    final result = EngagementProtectionServiceRepairRevokedAccountRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (newAccessToken != null) result.newAccessToken = newAccessToken;
    return result;
  }

  EngagementProtectionServiceRepairRevokedAccountRequest._();

  factory EngagementProtectionServiceRepairRevokedAccountRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceRepairRevokedAccountRequest()
        ..mergeFromBuffer(data, registry);
  factory EngagementProtectionServiceRepairRevokedAccountRequest.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceRepairRevokedAccountRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames
          ? ''
          : 'EngagementProtectionServiceRepairRevokedAccountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          EngagementProtectionServiceRepairRevokedAccountRequest
              .$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOS(4, _omitFieldNames ? '' : 'newAccessToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceRepairRevokedAccountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceRepairRevokedAccountRequest copyWith(
          void Function(EngagementProtectionServiceRepairRevokedAccountRequest)
              updates) =>
      super.copyWith((message) => updates(message
              as EngagementProtectionServiceRepairRevokedAccountRequest))
          as EngagementProtectionServiceRepairRevokedAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EngagementProtectionServiceRepairRevokedAccountRequest() / EngagementProtectionServiceRepairRevokedAccountRequest.new instead')
  static EngagementProtectionServiceRepairRevokedAccountRequest create() =>
      EngagementProtectionServiceRepairRevokedAccountRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EngagementProtectionServiceRepairRevokedAccountRequest._();
  @$core.override
  EngagementProtectionServiceRepairRevokedAccountRequest
      createEmptyInstance() =>
          EngagementProtectionServiceRepairRevokedAccountRequest._();
  @$core.pragma('dart2js:noInline')
  static EngagementProtectionServiceRepairRevokedAccountRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              EngagementProtectionServiceRepairRevokedAccountRequest>(
          EngagementProtectionServiceRepairRevokedAccountRequest
              .$_createMessage);
  static EngagementProtectionServiceRepairRevokedAccountRequest?
      _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get connectedAccountId => $_getSZ(2);
  @$pb.TagNumber(3)
  set connectedAccountId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConnectedAccountId() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectedAccountId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get newAccessToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set newAccessToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewAccessToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewAccessToken() => $_clearField(4);
}

class EngagementProtectionServiceRepairRevokedAccountResponse
    extends $pb.GeneratedMessage {
  factory EngagementProtectionServiceRepairRevokedAccountResponse({
    $core.bool? repaired,
    $core.String? connectedAccountId,
    $core.int? unblockedThreadsCount,
  }) {
    final result = EngagementProtectionServiceRepairRevokedAccountResponse._();
    if (repaired != null) result.repaired = repaired;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (unblockedThreadsCount != null)
      result.unblockedThreadsCount = unblockedThreadsCount;
    return result;
  }

  EngagementProtectionServiceRepairRevokedAccountResponse._();

  factory EngagementProtectionServiceRepairRevokedAccountResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceRepairRevokedAccountResponse()
        ..mergeFromBuffer(data, registry);
  factory EngagementProtectionServiceRepairRevokedAccountResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EngagementProtectionServiceRepairRevokedAccountResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames
          ? ''
          : 'EngagementProtectionServiceRepairRevokedAccountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.engagement.v1'),
      createEmptyInstance:
          EngagementProtectionServiceRepairRevokedAccountResponse
              .$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'repaired')
    ..aOS(2, _omitFieldNames ? '' : 'connectedAccountId')
    ..aI(3, _omitFieldNames ? '' : 'unblockedThreadsCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceRepairRevokedAccountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EngagementProtectionServiceRepairRevokedAccountResponse copyWith(
          void Function(EngagementProtectionServiceRepairRevokedAccountResponse)
              updates) =>
      super.copyWith((message) => updates(message
              as EngagementProtectionServiceRepairRevokedAccountResponse))
          as EngagementProtectionServiceRepairRevokedAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EngagementProtectionServiceRepairRevokedAccountResponse() / EngagementProtectionServiceRepairRevokedAccountResponse.new instead')
  static EngagementProtectionServiceRepairRevokedAccountResponse create() =>
      EngagementProtectionServiceRepairRevokedAccountResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EngagementProtectionServiceRepairRevokedAccountResponse._();
  @$core.override
  EngagementProtectionServiceRepairRevokedAccountResponse
      createEmptyInstance() =>
          EngagementProtectionServiceRepairRevokedAccountResponse._();
  @$core.pragma('dart2js:noInline')
  static EngagementProtectionServiceRepairRevokedAccountResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              EngagementProtectionServiceRepairRevokedAccountResponse>(
          EngagementProtectionServiceRepairRevokedAccountResponse
              .$_createMessage);
  static EngagementProtectionServiceRepairRevokedAccountResponse?
      _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get repaired => $_getBF(0);
  @$pb.TagNumber(1)
  set repaired($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepaired() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepaired() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get connectedAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set connectedAccountId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectedAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectedAccountId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unblockedThreadsCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set unblockedThreadsCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnblockedThreadsCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnblockedThreadsCount() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

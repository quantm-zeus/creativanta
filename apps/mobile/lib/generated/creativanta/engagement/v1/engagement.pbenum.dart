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

/// ThreadType represents the origin kind of an engagement thread.
class ThreadType extends $pb.ProtobufEnum {
  static const ThreadType THREAD_TYPE_UNSPECIFIED =
      ThreadType._(0, _omitEnumNames ? '' : 'THREAD_TYPE_UNSPECIFIED');
  static const ThreadType THREAD_TYPE_COMMENT =
      ThreadType._(1, _omitEnumNames ? '' : 'THREAD_TYPE_COMMENT');
  static const ThreadType THREAD_TYPE_DM =
      ThreadType._(2, _omitEnumNames ? '' : 'THREAD_TYPE_DM');
  static const ThreadType THREAD_TYPE_INQUIRY =
      ThreadType._(3, _omitEnumNames ? '' : 'THREAD_TYPE_INQUIRY');
  static const ThreadType THREAD_TYPE_SPONSOR_INQUIRY =
      ThreadType._(4, _omitEnumNames ? '' : 'THREAD_TYPE_SPONSOR_INQUIRY');
  static const ThreadType THREAD_TYPE_SAMPLE_REQUEST =
      ThreadType._(5, _omitEnumNames ? '' : 'THREAD_TYPE_SAMPLE_REQUEST');
  static const ThreadType THREAD_TYPE_SUPPORT =
      ThreadType._(6, _omitEnumNames ? '' : 'THREAD_TYPE_SUPPORT');

  static const $core.List<ThreadType> values = <ThreadType>[
    THREAD_TYPE_UNSPECIFIED,
    THREAD_TYPE_COMMENT,
    THREAD_TYPE_DM,
    THREAD_TYPE_INQUIRY,
    THREAD_TYPE_SPONSOR_INQUIRY,
    THREAD_TYPE_SAMPLE_REQUEST,
    THREAD_TYPE_SUPPORT,
  ];

  static final $core.List<ThreadType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ThreadType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThreadType._(super.value, super.name);
}

/// ThreadStatus matches database_schema.md §9.2 chk_threads_status.
class ThreadStatus extends $pb.ProtobufEnum {
  static const ThreadStatus THREAD_STATUS_UNSPECIFIED =
      ThreadStatus._(0, _omitEnumNames ? '' : 'THREAD_STATUS_UNSPECIFIED');
  static const ThreadStatus THREAD_STATUS_NEW =
      ThreadStatus._(1, _omitEnumNames ? '' : 'THREAD_STATUS_NEW');
  static const ThreadStatus THREAD_STATUS_TRIAGED =
      ThreadStatus._(2, _omitEnumNames ? '' : 'THREAD_STATUS_TRIAGED');
  static const ThreadStatus THREAD_STATUS_ACTIVE =
      ThreadStatus._(3, _omitEnumNames ? '' : 'THREAD_STATUS_ACTIVE');
  static const ThreadStatus THREAD_STATUS_WAITING_ON_USER =
      ThreadStatus._(4, _omitEnumNames ? '' : 'THREAD_STATUS_WAITING_ON_USER');
  static const ThreadStatus THREAD_STATUS_WAITING_ON_TEAM =
      ThreadStatus._(5, _omitEnumNames ? '' : 'THREAD_STATUS_WAITING_ON_TEAM');
  static const ThreadStatus THREAD_STATUS_SNOOZED =
      ThreadStatus._(6, _omitEnumNames ? '' : 'THREAD_STATUS_SNOOZED');
  static const ThreadStatus THREAD_STATUS_STALE =
      ThreadStatus._(7, _omitEnumNames ? '' : 'THREAD_STATUS_STALE');
  static const ThreadStatus THREAD_STATUS_CONVERTED_TO_TASK = ThreadStatus._(
      8, _omitEnumNames ? '' : 'THREAD_STATUS_CONVERTED_TO_TASK');
  static const ThreadStatus THREAD_STATUS_RESOLVED =
      ThreadStatus._(9, _omitEnumNames ? '' : 'THREAD_STATUS_RESOLVED');
  static const ThreadStatus THREAD_STATUS_ARCHIVED =
      ThreadStatus._(10, _omitEnumNames ? '' : 'THREAD_STATUS_ARCHIVED');

  static const $core.List<ThreadStatus> values = <ThreadStatus>[
    THREAD_STATUS_UNSPECIFIED,
    THREAD_STATUS_NEW,
    THREAD_STATUS_TRIAGED,
    THREAD_STATUS_ACTIVE,
    THREAD_STATUS_WAITING_ON_USER,
    THREAD_STATUS_WAITING_ON_TEAM,
    THREAD_STATUS_SNOOZED,
    THREAD_STATUS_STALE,
    THREAD_STATUS_CONVERTED_TO_TASK,
    THREAD_STATUS_RESOLVED,
    THREAD_STATUS_ARCHIVED,
  ];

  static final $core.List<ThreadStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static ThreadStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThreadStatus._(super.value, super.name);
}

/// ThreadPriority represents priority level.
class ThreadPriority extends $pb.ProtobufEnum {
  static const ThreadPriority THREAD_PRIORITY_UNSPECIFIED =
      ThreadPriority._(0, _omitEnumNames ? '' : 'THREAD_PRIORITY_UNSPECIFIED');
  static const ThreadPriority THREAD_PRIORITY_LOW =
      ThreadPriority._(1, _omitEnumNames ? '' : 'THREAD_PRIORITY_LOW');
  static const ThreadPriority THREAD_PRIORITY_NORMAL =
      ThreadPriority._(2, _omitEnumNames ? '' : 'THREAD_PRIORITY_NORMAL');
  static const ThreadPriority THREAD_PRIORITY_HIGH =
      ThreadPriority._(3, _omitEnumNames ? '' : 'THREAD_PRIORITY_HIGH');
  static const ThreadPriority THREAD_PRIORITY_URGENT =
      ThreadPriority._(4, _omitEnumNames ? '' : 'THREAD_PRIORITY_URGENT');

  static const $core.List<ThreadPriority> values = <ThreadPriority>[
    THREAD_PRIORITY_UNSPECIFIED,
    THREAD_PRIORITY_LOW,
    THREAD_PRIORITY_NORMAL,
    THREAD_PRIORITY_HIGH,
    THREAD_PRIORITY_URGENT,
  ];

  static final $core.List<ThreadPriority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ThreadPriority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThreadPriority._(super.value, super.name);
}

/// ThreadIntent matches database_schema.md §9.2 intent enum.
class ThreadIntent extends $pb.ProtobufEnum {
  static const ThreadIntent THREAD_INTENT_UNSPECIFIED =
      ThreadIntent._(0, _omitEnumNames ? '' : 'THREAD_INTENT_UNSPECIFIED');
  static const ThreadIntent THREAD_INTENT_QUESTION =
      ThreadIntent._(1, _omitEnumNames ? '' : 'THREAD_INTENT_QUESTION');
  static const ThreadIntent THREAD_INTENT_PURCHASE_INTEREST = ThreadIntent._(
      2, _omitEnumNames ? '' : 'THREAD_INTENT_PURCHASE_INTEREST');
  static const ThreadIntent THREAD_INTENT_SUPPORT_ISSUE =
      ThreadIntent._(3, _omitEnumNames ? '' : 'THREAD_INTENT_SUPPORT_ISSUE');
  static const ThreadIntent THREAD_INTENT_OBJECTION =
      ThreadIntent._(4, _omitEnumNames ? '' : 'THREAD_INTENT_OBJECTION');
  static const ThreadIntent THREAD_INTENT_SPONSOR_INTEREST =
      ThreadIntent._(5, _omitEnumNames ? '' : 'THREAD_INTENT_SPONSOR_INTEREST');
  static const ThreadIntent THREAD_INTENT_SAMPLE_REQUEST =
      ThreadIntent._(6, _omitEnumNames ? '' : 'THREAD_INTENT_SAMPLE_REQUEST');
  static const ThreadIntent THREAD_INTENT_MODERATION_RISK =
      ThreadIntent._(7, _omitEnumNames ? '' : 'THREAD_INTENT_MODERATION_RISK');
  static const ThreadIntent THREAD_INTENT_UNKNOWN =
      ThreadIntent._(8, _omitEnumNames ? '' : 'THREAD_INTENT_UNKNOWN');

  static const $core.List<ThreadIntent> values = <ThreadIntent>[
    THREAD_INTENT_UNSPECIFIED,
    THREAD_INTENT_QUESTION,
    THREAD_INTENT_PURCHASE_INTEREST,
    THREAD_INTENT_SUPPORT_ISSUE,
    THREAD_INTENT_OBJECTION,
    THREAD_INTENT_SPONSOR_INTEREST,
    THREAD_INTENT_SAMPLE_REQUEST,
    THREAD_INTENT_MODERATION_RISK,
    THREAD_INTENT_UNKNOWN,
  ];

  static final $core.List<ThreadIntent?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static ThreadIntent? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThreadIntent._(super.value, super.name);
}

/// MessageSubtype matches database_schema.md §9.3 subtype.
class MessageSubtype extends $pb.ProtobufEnum {
  static const MessageSubtype MESSAGE_SUBTYPE_UNSPECIFIED =
      MessageSubtype._(0, _omitEnumNames ? '' : 'MESSAGE_SUBTYPE_UNSPECIFIED');
  static const MessageSubtype MESSAGE_SUBTYPE_COMMENT =
      MessageSubtype._(1, _omitEnumNames ? '' : 'MESSAGE_SUBTYPE_COMMENT');
  static const MessageSubtype MESSAGE_SUBTYPE_DM =
      MessageSubtype._(2, _omitEnumNames ? '' : 'MESSAGE_SUBTYPE_DM');
  static const MessageSubtype MESSAGE_SUBTYPE_INQUIRY =
      MessageSubtype._(3, _omitEnumNames ? '' : 'MESSAGE_SUBTYPE_INQUIRY');
  static const MessageSubtype MESSAGE_SUBTYPE_REPLY =
      MessageSubtype._(4, _omitEnumNames ? '' : 'MESSAGE_SUBTYPE_REPLY');
  static const MessageSubtype MESSAGE_SUBTYPE_SYSTEM =
      MessageSubtype._(5, _omitEnumNames ? '' : 'MESSAGE_SUBTYPE_SYSTEM');

  static const $core.List<MessageSubtype> values = <MessageSubtype>[
    MESSAGE_SUBTYPE_UNSPECIFIED,
    MESSAGE_SUBTYPE_COMMENT,
    MESSAGE_SUBTYPE_DM,
    MESSAGE_SUBTYPE_INQUIRY,
    MESSAGE_SUBTYPE_REPLY,
    MESSAGE_SUBTYPE_SYSTEM,
  ];

  static final $core.List<MessageSubtype?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static MessageSubtype? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageSubtype._(super.value, super.name);
}

/// AuthorDirection matches database_schema.md §9.3 author_direction.
class AuthorDirection extends $pb.ProtobufEnum {
  static const AuthorDirection AUTHOR_DIRECTION_UNSPECIFIED = AuthorDirection._(
      0, _omitEnumNames ? '' : 'AUTHOR_DIRECTION_UNSPECIFIED');
  static const AuthorDirection AUTHOR_DIRECTION_INBOUND =
      AuthorDirection._(1, _omitEnumNames ? '' : 'AUTHOR_DIRECTION_INBOUND');
  static const AuthorDirection AUTHOR_DIRECTION_OUTBOUND =
      AuthorDirection._(2, _omitEnumNames ? '' : 'AUTHOR_DIRECTION_OUTBOUND');
  static const AuthorDirection AUTHOR_DIRECTION_SYSTEM =
      AuthorDirection._(3, _omitEnumNames ? '' : 'AUTHOR_DIRECTION_SYSTEM');

  static const $core.List<AuthorDirection> values = <AuthorDirection>[
    AUTHOR_DIRECTION_UNSPECIFIED,
    AUTHOR_DIRECTION_INBOUND,
    AUTHOR_DIRECTION_OUTBOUND,
    AUTHOR_DIRECTION_SYSTEM,
  ];

  static final $core.List<AuthorDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AuthorDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AuthorDirection._(super.value, super.name);
}

/// GhostStatus represents platform deletion/restriction state (Alternate Flow A4).
class GhostStatus extends $pb.ProtobufEnum {
  static const GhostStatus GHOST_STATUS_UNSPECIFIED =
      GhostStatus._(0, _omitEnumNames ? '' : 'GHOST_STATUS_UNSPECIFIED');
  static const GhostStatus GHOST_STATUS_NONE =
      GhostStatus._(1, _omitEnumNames ? '' : 'GHOST_STATUS_NONE');
  static const GhostStatus GHOST_STATUS_DELETED_BY_USER =
      GhostStatus._(2, _omitEnumNames ? '' : 'GHOST_STATUS_DELETED_BY_USER');
  static const GhostStatus GHOST_STATUS_RESTRICTED_BY_PLATFORM = GhostStatus._(
      3, _omitEnumNames ? '' : 'GHOST_STATUS_RESTRICTED_BY_PLATFORM');
  static const GhostStatus GHOST_STATUS_PERMANENTLY_REMOVED = GhostStatus._(
      4, _omitEnumNames ? '' : 'GHOST_STATUS_PERMANENTLY_REMOVED');

  static const $core.List<GhostStatus> values = <GhostStatus>[
    GHOST_STATUS_UNSPECIFIED,
    GHOST_STATUS_NONE,
    GHOST_STATUS_DELETED_BY_USER,
    GHOST_STATUS_RESTRICTED_BY_PLATFORM,
    GHOST_STATUS_PERMANENTLY_REMOVED,
  ];

  static final $core.List<GhostStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static GhostStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GhostStatus._(super.value, super.name);
}

/// ThrottleMode represents viral surge ingestion mode (RULE-M12-007).
class ThrottleMode extends $pb.ProtobufEnum {
  static const ThrottleMode THROTTLE_MODE_UNSPECIFIED =
      ThrottleMode._(0, _omitEnumNames ? '' : 'THROTTLE_MODE_UNSPECIFIED');
  static const ThrottleMode THROTTLE_MODE_NORMAL =
      ThrottleMode._(1, _omitEnumNames ? '' : 'THROTTLE_MODE_NORMAL');
  static const ThrottleMode THROTTLE_MODE_THROTTLED =
      ThrottleMode._(2, _omitEnumNames ? '' : 'THROTTLE_MODE_THROTTLED');
  static const ThrottleMode THROTTLE_MODE_CIRCUIT_BREAKER =
      ThrottleMode._(3, _omitEnumNames ? '' : 'THROTTLE_MODE_CIRCUIT_BREAKER');

  static const $core.List<ThrottleMode> values = <ThrottleMode>[
    THROTTLE_MODE_UNSPECIFIED,
    THROTTLE_MODE_NORMAL,
    THROTTLE_MODE_THROTTLED,
    THROTTLE_MODE_CIRCUIT_BREAKER,
  ];

  static final $core.List<ThrottleMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ThrottleMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThrottleMode._(super.value, super.name);
}

/// FollowUpTaskStatus matches database_schema.md §9.4 status.
class FollowUpTaskStatus extends $pb.ProtobufEnum {
  static const FollowUpTaskStatus FOLLOW_UP_TASK_STATUS_UNSPECIFIED =
      FollowUpTaskStatus._(
          0, _omitEnumNames ? '' : 'FOLLOW_UP_TASK_STATUS_UNSPECIFIED');
  static const FollowUpTaskStatus FOLLOW_UP_TASK_STATUS_OPEN =
      FollowUpTaskStatus._(
          1, _omitEnumNames ? '' : 'FOLLOW_UP_TASK_STATUS_OPEN');
  static const FollowUpTaskStatus FOLLOW_UP_TASK_STATUS_IN_PROGRESS =
      FollowUpTaskStatus._(
          2, _omitEnumNames ? '' : 'FOLLOW_UP_TASK_STATUS_IN_PROGRESS');
  static const FollowUpTaskStatus FOLLOW_UP_TASK_STATUS_BLOCKED =
      FollowUpTaskStatus._(
          3, _omitEnumNames ? '' : 'FOLLOW_UP_TASK_STATUS_BLOCKED');
  static const FollowUpTaskStatus FOLLOW_UP_TASK_STATUS_COMPLETED =
      FollowUpTaskStatus._(
          4, _omitEnumNames ? '' : 'FOLLOW_UP_TASK_STATUS_COMPLETED');
  static const FollowUpTaskStatus FOLLOW_UP_TASK_STATUS_CANCELLED =
      FollowUpTaskStatus._(
          5, _omitEnumNames ? '' : 'FOLLOW_UP_TASK_STATUS_CANCELLED');

  static const $core.List<FollowUpTaskStatus> values = <FollowUpTaskStatus>[
    FOLLOW_UP_TASK_STATUS_UNSPECIFIED,
    FOLLOW_UP_TASK_STATUS_OPEN,
    FOLLOW_UP_TASK_STATUS_IN_PROGRESS,
    FOLLOW_UP_TASK_STATUS_BLOCKED,
    FOLLOW_UP_TASK_STATUS_COMPLETED,
    FOLLOW_UP_TASK_STATUS_CANCELLED,
  ];

  static final $core.List<FollowUpTaskStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static FollowUpTaskStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FollowUpTaskStatus._(super.value, super.name);
}

/// EntityType matches database_schema.md §9.1 entity_type.
class EntityType extends $pb.ProtobufEnum {
  static const EntityType ENTITY_TYPE_UNSPECIFIED =
      EntityType._(0, _omitEnumNames ? '' : 'ENTITY_TYPE_UNSPECIFIED');
  static const EntityType ENTITY_TYPE_PERSON =
      EntityType._(1, _omitEnumNames ? '' : 'ENTITY_TYPE_PERSON');
  static const EntityType ENTITY_TYPE_BRAND =
      EntityType._(2, _omitEnumNames ? '' : 'ENTITY_TYPE_BRAND');
  static const EntityType ENTITY_TYPE_BOT =
      EntityType._(3, _omitEnumNames ? '' : 'ENTITY_TYPE_BOT');
  static const EntityType ENTITY_TYPE_UNKNOWN =
      EntityType._(4, _omitEnumNames ? '' : 'ENTITY_TYPE_UNKNOWN');

  static const $core.List<EntityType> values = <EntityType>[
    ENTITY_TYPE_UNSPECIFIED,
    ENTITY_TYPE_PERSON,
    ENTITY_TYPE_BRAND,
    ENTITY_TYPE_BOT,
    ENTITY_TYPE_UNKNOWN,
  ];

  static final $core.List<EntityType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EntityType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntityType._(super.value, super.name);
}

/// EntityRelationshipState matches database_schema.md §9.1 relationship_state.
class EntityRelationshipState extends $pb.ProtobufEnum {
  static const EntityRelationshipState ENTITY_RELATIONSHIP_STATE_UNSPECIFIED =
      EntityRelationshipState._(
          0, _omitEnumNames ? '' : 'ENTITY_RELATIONSHIP_STATE_UNSPECIFIED');
  static const EntityRelationshipState ENTITY_RELATIONSHIP_STATE_LEAD =
      EntityRelationshipState._(
          1, _omitEnumNames ? '' : 'ENTITY_RELATIONSHIP_STATE_LEAD');
  static const EntityRelationshipState ENTITY_RELATIONSHIP_STATE_CUSTOMER =
      EntityRelationshipState._(
          2, _omitEnumNames ? '' : 'ENTITY_RELATIONSHIP_STATE_CUSTOMER');
  static const EntityRelationshipState ENTITY_RELATIONSHIP_STATE_CREATOR =
      EntityRelationshipState._(
          3, _omitEnumNames ? '' : 'ENTITY_RELATIONSHIP_STATE_CREATOR');
  static const EntityRelationshipState ENTITY_RELATIONSHIP_STATE_PARTNER =
      EntityRelationshipState._(
          4, _omitEnumNames ? '' : 'ENTITY_RELATIONSHIP_STATE_PARTNER');
  static const EntityRelationshipState ENTITY_RELATIONSHIP_STATE_SPONSOR =
      EntityRelationshipState._(
          5, _omitEnumNames ? '' : 'ENTITY_RELATIONSHIP_STATE_SPONSOR');

  static const $core.List<EntityRelationshipState> values =
      <EntityRelationshipState>[
    ENTITY_RELATIONSHIP_STATE_UNSPECIFIED,
    ENTITY_RELATIONSHIP_STATE_LEAD,
    ENTITY_RELATIONSHIP_STATE_CUSTOMER,
    ENTITY_RELATIONSHIP_STATE_CREATOR,
    ENTITY_RELATIONSHIP_STATE_PARTNER,
    ENTITY_RELATIONSHIP_STATE_SPONSOR,
  ];

  static final $core.List<EntityRelationshipState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static EntityRelationshipState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntityRelationshipState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

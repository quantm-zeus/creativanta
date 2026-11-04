// This is a generated file - do not edit.
//
// Generated from creativanta/engagement/v1/engagement.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use threadTypeDescriptor instead')
const ThreadType$json = {
  '1': 'ThreadType',
  '2': [
    {'1': 'THREAD_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'THREAD_TYPE_COMMENT', '2': 1},
    {'1': 'THREAD_TYPE_DM', '2': 2},
    {'1': 'THREAD_TYPE_INQUIRY', '2': 3},
    {'1': 'THREAD_TYPE_SPONSOR_INQUIRY', '2': 4},
    {'1': 'THREAD_TYPE_SAMPLE_REQUEST', '2': 5},
    {'1': 'THREAD_TYPE_SUPPORT', '2': 6},
  ],
};

/// Descriptor for `ThreadType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List threadTypeDescriptor = $convert.base64Decode(
    'CgpUaHJlYWRUeXBlEhsKF1RIUkVBRF9UWVBFX1VOU1BFQ0lGSUVEEAASFwoTVEhSRUFEX1RZUE'
    'VfQ09NTUVOVBABEhIKDlRIUkVBRF9UWVBFX0RNEAISFwoTVEhSRUFEX1RZUEVfSU5RVUlSWRAD'
    'Eh8KG1RIUkVBRF9UWVBFX1NQT05TT1JfSU5RVUlSWRAEEh4KGlRIUkVBRF9UWVBFX1NBTVBMRV'
    '9SRVFVRVNUEAUSFwoTVEhSRUFEX1RZUEVfU1VQUE9SVBAG');

@$core.Deprecated('Use threadStatusDescriptor instead')
const ThreadStatus$json = {
  '1': 'ThreadStatus',
  '2': [
    {'1': 'THREAD_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'THREAD_STATUS_NEW', '2': 1},
    {'1': 'THREAD_STATUS_TRIAGED', '2': 2},
    {'1': 'THREAD_STATUS_ACTIVE', '2': 3},
    {'1': 'THREAD_STATUS_WAITING_ON_USER', '2': 4},
    {'1': 'THREAD_STATUS_WAITING_ON_TEAM', '2': 5},
    {'1': 'THREAD_STATUS_SNOOZED', '2': 6},
    {'1': 'THREAD_STATUS_STALE', '2': 7},
    {'1': 'THREAD_STATUS_CONVERTED_TO_TASK', '2': 8},
    {'1': 'THREAD_STATUS_RESOLVED', '2': 9},
    {'1': 'THREAD_STATUS_ARCHIVED', '2': 10},
  ],
};

/// Descriptor for `ThreadStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List threadStatusDescriptor = $convert.base64Decode(
    'CgxUaHJlYWRTdGF0dXMSHQoZVEhSRUFEX1NUQVRVU19VTlNQRUNJRklFRBAAEhUKEVRIUkVBRF'
    '9TVEFUVVNfTkVXEAESGQoVVEhSRUFEX1NUQVRVU19UUklBR0VEEAISGAoUVEhSRUFEX1NUQVRV'
    'U19BQ1RJVkUQAxIhCh1USFJFQURfU1RBVFVTX1dBSVRJTkdfT05fVVNFUhAEEiEKHVRIUkVBRF'
    '9TVEFUVVNfV0FJVElOR19PTl9URUFNEAUSGQoVVEhSRUFEX1NUQVRVU19TTk9PWkVEEAYSFwoT'
    'VEhSRUFEX1NUQVRVU19TVEFMRRAHEiMKH1RIUkVBRF9TVEFUVVNfQ09OVkVSVEVEX1RPX1RBU0'
    'sQCBIaChZUSFJFQURfU1RBVFVTX1JFU09MVkVEEAkSGgoWVEhSRUFEX1NUQVRVU19BUkNISVZF'
    'RBAK');

@$core.Deprecated('Use threadPriorityDescriptor instead')
const ThreadPriority$json = {
  '1': 'ThreadPriority',
  '2': [
    {'1': 'THREAD_PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'THREAD_PRIORITY_LOW', '2': 1},
    {'1': 'THREAD_PRIORITY_NORMAL', '2': 2},
    {'1': 'THREAD_PRIORITY_HIGH', '2': 3},
    {'1': 'THREAD_PRIORITY_URGENT', '2': 4},
  ],
};

/// Descriptor for `ThreadPriority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List threadPriorityDescriptor = $convert.base64Decode(
    'Cg5UaHJlYWRQcmlvcml0eRIfChtUSFJFQURfUFJJT1JJVFlfVU5TUEVDSUZJRUQQABIXChNUSF'
    'JFQURfUFJJT1JJVFlfTE9XEAESGgoWVEhSRUFEX1BSSU9SSVRZX05PUk1BTBACEhgKFFRIUkVB'
    'RF9QUklPUklUWV9ISUdIEAMSGgoWVEhSRUFEX1BSSU9SSVRZX1VSR0VOVBAE');

@$core.Deprecated('Use threadIntentDescriptor instead')
const ThreadIntent$json = {
  '1': 'ThreadIntent',
  '2': [
    {'1': 'THREAD_INTENT_UNSPECIFIED', '2': 0},
    {'1': 'THREAD_INTENT_QUESTION', '2': 1},
    {'1': 'THREAD_INTENT_PURCHASE_INTEREST', '2': 2},
    {'1': 'THREAD_INTENT_SUPPORT_ISSUE', '2': 3},
    {'1': 'THREAD_INTENT_OBJECTION', '2': 4},
    {'1': 'THREAD_INTENT_SPONSOR_INTEREST', '2': 5},
    {'1': 'THREAD_INTENT_SAMPLE_REQUEST', '2': 6},
    {'1': 'THREAD_INTENT_MODERATION_RISK', '2': 7},
    {'1': 'THREAD_INTENT_UNKNOWN', '2': 8},
  ],
};

/// Descriptor for `ThreadIntent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List threadIntentDescriptor = $convert.base64Decode(
    'CgxUaHJlYWRJbnRlbnQSHQoZVEhSRUFEX0lOVEVOVF9VTlNQRUNJRklFRBAAEhoKFlRIUkVBRF'
    '9JTlRFTlRfUVVFU1RJT04QARIjCh9USFJFQURfSU5URU5UX1BVUkNIQVNFX0lOVEVSRVNUEAIS'
    'HwobVEhSRUFEX0lOVEVOVF9TVVBQT1JUX0lTU1VFEAMSGwoXVEhSRUFEX0lOVEVOVF9PQkpFQ1'
    'RJT04QBBIiCh5USFJFQURfSU5URU5UX1NQT05TT1JfSU5URVJFU1QQBRIgChxUSFJFQURfSU5U'
    'RU5UX1NBTVBMRV9SRVFVRVNUEAYSIQodVEhSRUFEX0lOVEVOVF9NT0RFUkFUSU9OX1JJU0sQBx'
    'IZChVUSFJFQURfSU5URU5UX1VOS05PV04QCA==');

@$core.Deprecated('Use messageSubtypeDescriptor instead')
const MessageSubtype$json = {
  '1': 'MessageSubtype',
  '2': [
    {'1': 'MESSAGE_SUBTYPE_UNSPECIFIED', '2': 0},
    {'1': 'MESSAGE_SUBTYPE_COMMENT', '2': 1},
    {'1': 'MESSAGE_SUBTYPE_DM', '2': 2},
    {'1': 'MESSAGE_SUBTYPE_INQUIRY', '2': 3},
    {'1': 'MESSAGE_SUBTYPE_REPLY', '2': 4},
    {'1': 'MESSAGE_SUBTYPE_SYSTEM', '2': 5},
  ],
};

/// Descriptor for `MessageSubtype`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageSubtypeDescriptor = $convert.base64Decode(
    'Cg5NZXNzYWdlU3VidHlwZRIfChtNRVNTQUdFX1NVQlRZUEVfVU5TUEVDSUZJRUQQABIbChdNRV'
    'NTQUdFX1NVQlRZUEVfQ09NTUVOVBABEhYKEk1FU1NBR0VfU1VCVFlQRV9ETRACEhsKF01FU1NB'
    'R0VfU1VCVFlQRV9JTlFVSVJZEAMSGQoVTUVTU0FHRV9TVUJUWVBFX1JFUExZEAQSGgoWTUVTU0'
    'FHRV9TVUJUWVBFX1NZU1RFTRAF');

@$core.Deprecated('Use authorDirectionDescriptor instead')
const AuthorDirection$json = {
  '1': 'AuthorDirection',
  '2': [
    {'1': 'AUTHOR_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'AUTHOR_DIRECTION_INBOUND', '2': 1},
    {'1': 'AUTHOR_DIRECTION_OUTBOUND', '2': 2},
    {'1': 'AUTHOR_DIRECTION_SYSTEM', '2': 3},
  ],
};

/// Descriptor for `AuthorDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List authorDirectionDescriptor = $convert.base64Decode(
    'Cg9BdXRob3JEaXJlY3Rpb24SIAocQVVUSE9SX0RJUkVDVElPTl9VTlNQRUNJRklFRBAAEhwKGE'
    'FVVEhPUl9ESVJFQ1RJT05fSU5CT1VORBABEh0KGUFVVEhPUl9ESVJFQ1RJT05fT1VUQk9VTkQQ'
    'AhIbChdBVVRIT1JfRElSRUNUSU9OX1NZU1RFTRAD');

@$core.Deprecated('Use ghostStatusDescriptor instead')
const GhostStatus$json = {
  '1': 'GhostStatus',
  '2': [
    {'1': 'GHOST_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'GHOST_STATUS_NONE', '2': 1},
    {'1': 'GHOST_STATUS_DELETED_BY_USER', '2': 2},
    {'1': 'GHOST_STATUS_RESTRICTED_BY_PLATFORM', '2': 3},
    {'1': 'GHOST_STATUS_PERMANENTLY_REMOVED', '2': 4},
  ],
};

/// Descriptor for `GhostStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List ghostStatusDescriptor = $convert.base64Decode(
    'CgtHaG9zdFN0YXR1cxIcChhHSE9TVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIVChFHSE9TVF9TVE'
    'FUVVNfTk9ORRABEiAKHEdIT1NUX1NUQVRVU19ERUxFVEVEX0JZX1VTRVIQAhInCiNHSE9TVF9T'
    'VEFUVVNfUkVTVFJJQ1RFRF9CWV9QTEFURk9STRADEiQKIEdIT1NUX1NUQVRVU19QRVJNQU5FTl'
    'RMWV9SRU1PVkVEEAQ=');

@$core.Deprecated('Use throttleModeDescriptor instead')
const ThrottleMode$json = {
  '1': 'ThrottleMode',
  '2': [
    {'1': 'THROTTLE_MODE_UNSPECIFIED', '2': 0},
    {'1': 'THROTTLE_MODE_NORMAL', '2': 1},
    {'1': 'THROTTLE_MODE_THROTTLED', '2': 2},
    {'1': 'THROTTLE_MODE_CIRCUIT_BREAKER', '2': 3},
  ],
};

/// Descriptor for `ThrottleMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List throttleModeDescriptor = $convert.base64Decode(
    'CgxUaHJvdHRsZU1vZGUSHQoZVEhST1RUTEVfTU9ERV9VTlNQRUNJRklFRBAAEhgKFFRIUk9UVE'
    'xFX01PREVfTk9STUFMEAESGwoXVEhST1RUTEVfTU9ERV9USFJPVFRMRUQQAhIhCh1USFJPVFRM'
    'RV9NT0RFX0NJUkNVSVRfQlJFQUtFUhAD');

@$core.Deprecated('Use followUpTaskStatusDescriptor instead')
const FollowUpTaskStatus$json = {
  '1': 'FollowUpTaskStatus',
  '2': [
    {'1': 'FOLLOW_UP_TASK_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'FOLLOW_UP_TASK_STATUS_OPEN', '2': 1},
    {'1': 'FOLLOW_UP_TASK_STATUS_IN_PROGRESS', '2': 2},
    {'1': 'FOLLOW_UP_TASK_STATUS_BLOCKED', '2': 3},
    {'1': 'FOLLOW_UP_TASK_STATUS_COMPLETED', '2': 4},
    {'1': 'FOLLOW_UP_TASK_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `FollowUpTaskStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List followUpTaskStatusDescriptor = $convert.base64Decode(
    'ChJGb2xsb3dVcFRhc2tTdGF0dXMSJQohRk9MTE9XX1VQX1RBU0tfU1RBVFVTX1VOU1BFQ0lGSU'
    'VEEAASHgoaRk9MTE9XX1VQX1RBU0tfU1RBVFVTX09QRU4QARIlCiFGT0xMT1dfVVBfVEFTS19T'
    'VEFUVVNfSU5fUFJPR1JFU1MQAhIhCh1GT0xMT1dfVVBfVEFTS19TVEFUVVNfQkxPQ0tFRBADEi'
    'MKH0ZPTExPV19VUF9UQVNLX1NUQVRVU19DT01QTEVURUQQBBIjCh9GT0xMT1dfVVBfVEFTS19T'
    'VEFUVVNfQ0FOQ0VMTEVEEAU=');

@$core.Deprecated('Use entityTypeDescriptor instead')
const EntityType$json = {
  '1': 'EntityType',
  '2': [
    {'1': 'ENTITY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ENTITY_TYPE_PERSON', '2': 1},
    {'1': 'ENTITY_TYPE_BRAND', '2': 2},
    {'1': 'ENTITY_TYPE_BOT', '2': 3},
    {'1': 'ENTITY_TYPE_UNKNOWN', '2': 4},
  ],
};

/// Descriptor for `EntityType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityTypeDescriptor = $convert.base64Decode(
    'CgpFbnRpdHlUeXBlEhsKF0VOVElUWV9UWVBFX1VOU1BFQ0lGSUVEEAASFgoSRU5USVRZX1RZUE'
    'VfUEVSU09OEAESFQoRRU5USVRZX1RZUEVfQlJBTkQQAhITCg9FTlRJVFlfVFlQRV9CT1QQAxIX'
    'ChNFTlRJVFlfVFlQRV9VTktOT1dOEAQ=');

@$core.Deprecated('Use entityRelationshipStateDescriptor instead')
const EntityRelationshipState$json = {
  '1': 'EntityRelationshipState',
  '2': [
    {'1': 'ENTITY_RELATIONSHIP_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ENTITY_RELATIONSHIP_STATE_LEAD', '2': 1},
    {'1': 'ENTITY_RELATIONSHIP_STATE_CUSTOMER', '2': 2},
    {'1': 'ENTITY_RELATIONSHIP_STATE_CREATOR', '2': 3},
    {'1': 'ENTITY_RELATIONSHIP_STATE_PARTNER', '2': 4},
    {'1': 'ENTITY_RELATIONSHIP_STATE_SPONSOR', '2': 5},
  ],
};

/// Descriptor for `EntityRelationshipState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityRelationshipStateDescriptor = $convert.base64Decode(
    'ChdFbnRpdHlSZWxhdGlvbnNoaXBTdGF0ZRIpCiVFTlRJVFlfUkVMQVRJT05TSElQX1NUQVRFX1'
    'VOU1BFQ0lGSUVEEAASIgoeRU5USVRZX1JFTEFUSU9OU0hJUF9TVEFURV9MRUFEEAESJgoiRU5U'
    'SVRZX1JFTEFUSU9OU0hJUF9TVEFURV9DVVNUT01FUhACEiUKIUVOVElUWV9SRUxBVElPTlNISV'
    'BfU1RBVEVfQ1JFQVRPUhADEiUKIUVOVElUWV9SRUxBVElPTlNISVBfU1RBVEVfUEFSVE5FUhAE'
    'EiUKIUVOVElUWV9SRUxBVElPTlNISVBfU1RBVEVfU1BPTlNPUhAF');

@$core.Deprecated('Use relatedObjectRefDescriptor instead')
const RelatedObjectRef$json = {
  '1': 'RelatedObjectRef',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'task_ref', '3': 4, '4': 1, '5': 9, '10': 'taskRef'},
    {'1': 'phase', '3': 5, '4': 1, '5': 9, '10': 'phase'},
    {'1': 'is_p6_deferred', '3': 6, '4': 1, '5': 8, '10': 'isP6Deferred'},
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `RelatedObjectRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relatedObjectRefDescriptor = $convert.base64Decode(
    'ChBSZWxhdGVkT2JqZWN0UmVmEhIKBHR5cGUYASABKAlSBHR5cGUSDgoCaWQYAiABKAlSAmlkEh'
    'QKBWxhYmVsGAMgASgJUgVsYWJlbBIZCgh0YXNrX3JlZhgEIAEoCVIHdGFza1JlZhIUCgVwaGFz'
    'ZRgFIAEoCVIFcGhhc2USJAoOaXNfcDZfZGVmZXJyZWQYBiABKAhSDGlzUDZEZWZlcnJlZBIWCg'
    'ZzdGF0dXMYByABKAlSBnN0YXR1cw==');

@$core.Deprecated('Use replyIdentityDescriptor instead')
const ReplyIdentity$json = {
  '1': 'ReplyIdentity',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'account_name', '3': 3, '4': 1, '5': 9, '10': 'accountName'},
    {'1': 'avatar_url', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'badge_color', '3': 5, '4': 1, '5': 9, '10': 'badgeColor'},
    {'1': 'is_revoked', '3': 6, '4': 1, '5': 8, '10': 'isRevoked'},
  ],
};

/// Descriptor for `ReplyIdentity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyIdentityDescriptor = $convert.base64Decode(
    'Cg1SZXBseUlkZW50aXR5Eh0KCmFjY291bnRfaWQYASABKAlSCWFjY291bnRJZBIaCghwbGF0Zm'
    '9ybRgCIAEoCVIIcGxhdGZvcm0SIQoMYWNjb3VudF9uYW1lGAMgASgJUgthY2NvdW50TmFtZRId'
    'CgphdmF0YXJfdXJsGAQgASgJUglhdmF0YXJVcmwSHwoLYmFkZ2VfY29sb3IYBSABKAlSCmJhZG'
    'dlQ29sb3ISHQoKaXNfcmV2b2tlZBgGIAEoCFIJaXNSZXZva2Vk');

@$core.Deprecated('Use threadDescriptor instead')
const Thread$json = {
  '1': 'Thread',
  '2': [
    {'1': 'thread_id', '3': 1, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'thread_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadType',
      '10': 'threadType'
    },
    {'1': 'entity_id', '3': 4, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'source_platform', '3': 5, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {'1': 'source_post_id', '3': 6, '4': 1, '5': 9, '10': 'sourcePostId'},
    {'1': 'owner_user_id', '3': 7, '4': 1, '5': 9, '10': 'ownerUserId'},
    {
      '1': 'intent',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadIntent',
      '10': 'intent'
    },
    {
      '1': 'priority',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadPriority',
      '10': 'priority'
    },
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadStatus',
      '10': 'status'
    },
    {'1': 'next_action', '3': 11, '4': 1, '5': 9, '10': 'nextAction'},
    {
      '1': 'sla_due_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'slaDueAt'
    },
    {
      '1': 'related_object_refs',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.RelatedObjectRef',
      '10': 'relatedObjectRefs'
    },
    {
      '1': 'last_activity_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastActivityAt'
    },
    {'1': 'message_count', '3': 15, '4': 1, '5': 5, '10': 'messageCount'},
    {
      '1': 'created_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'messaging_window_expires_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'messagingWindowExpiresAt'
    },
    {
      '1': 'messaging_window_expired',
      '3': 19,
      '4': 1,
      '5': 8,
      '10': 'messagingWindowExpired'
    },
    {
      '1': 'auto_reply_paused',
      '3': 20,
      '4': 1,
      '5': 8,
      '10': 'autoReplyPaused'
    },
    {
      '1': 'auto_reply_consecutive_count',
      '3': 21,
      '4': 1,
      '5': 5,
      '10': 'autoReplyConsecutiveCount'
    },
    {
      '1': 'auto_reply_hour_count',
      '3': 22,
      '4': 1,
      '5': 5,
      '10': 'autoReplyHourCount'
    },
    {
      '1': 'auto_reply_permanently_disabled',
      '3': 23,
      '4': 1,
      '5': 8,
      '10': 'autoReplyPermanentlyDisabled'
    },
    {'1': 'is_ghost', '3': 24, '4': 1, '5': 8, '10': 'isGhost'},
    {
      '1': 'ghost_status',
      '3': 25,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.GhostStatus',
      '10': 'ghostStatus'
    },
    {
      '1': 'throttle_state',
      '3': 26,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThrottleMode',
      '10': 'throttleState'
    },
    {
      '1': 'connected_account_id',
      '3': 27,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {'1': 'account_revoked', '3': 28, '4': 1, '5': 8, '10': 'accountRevoked'},
    {
      '1': 'reply_identity',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.ReplyIdentity',
      '10': 'replyIdentity'
    },
  ],
};

/// Descriptor for `Thread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadDescriptor = $convert.base64Decode(
    'CgZUaHJlYWQSGwoJdGhyZWFkX2lkGAEgASgJUgh0aHJlYWRJZBIhCgx3b3Jrc3BhY2VfaWQYAi'
    'ABKAlSC3dvcmtzcGFjZUlkEkYKC3RocmVhZF90eXBlGAMgASgOMiUuY3JlYXRpdmFudGEuZW5n'
    'YWdlbWVudC52MS5UaHJlYWRUeXBlUgp0aHJlYWRUeXBlEhsKCWVudGl0eV9pZBgEIAEoCVIIZW'
    '50aXR5SWQSJwoPc291cmNlX3BsYXRmb3JtGAUgASgJUg5zb3VyY2VQbGF0Zm9ybRIkCg5zb3Vy'
    'Y2VfcG9zdF9pZBgGIAEoCVIMc291cmNlUG9zdElkEiIKDW93bmVyX3VzZXJfaWQYByABKAlSC2'
    '93bmVyVXNlcklkEj8KBmludGVudBgIIAEoDjInLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEu'
    'VGhyZWFkSW50ZW50UgZpbnRlbnQSRQoIcHJpb3JpdHkYCSABKA4yKS5jcmVhdGl2YW50YS5lbm'
    'dhZ2VtZW50LnYxLlRocmVhZFByaW9yaXR5Ughwcmlvcml0eRI/CgZzdGF0dXMYCiABKA4yJy5j'
    'cmVhdGl2YW50YS5lbmdhZ2VtZW50LnYxLlRocmVhZFN0YXR1c1IGc3RhdHVzEh8KC25leHRfYW'
    'N0aW9uGAsgASgJUgpuZXh0QWN0aW9uEjgKCnNsYV9kdWVfYXQYDCABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUghzbGFEdWVBdBJbChNyZWxhdGVkX29iamVjdF9yZWZzGA0gAygLMi'
    'suY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5SZWxhdGVkT2JqZWN0UmVmUhFyZWxhdGVkT2Jq'
    'ZWN0UmVmcxJEChBsYXN0X2FjdGl2aXR5X2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIObGFzdEFjdGl2aXR5QXQSIwoNbWVzc2FnZV9jb3VudBgPIAEoBVIMbWVzc2FnZUNv'
    'dW50EjkKCmNyZWF0ZWRfYXQYECABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcm'
    'VhdGVkQXQSOQoKdXBkYXRlZF9hdBgRIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXVwZGF0ZWRBdBJZChttZXNzYWdpbmdfd2luZG93X2V4cGlyZXNfYXQYEiABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUhhtZXNzYWdpbmdXaW5kb3dFeHBpcmVzQXQSOAoYbWVzc2Fn'
    'aW5nX3dpbmRvd19leHBpcmVkGBMgASgIUhZtZXNzYWdpbmdXaW5kb3dFeHBpcmVkEioKEWF1dG'
    '9fcmVwbHlfcGF1c2VkGBQgASgIUg9hdXRvUmVwbHlQYXVzZWQSPwocYXV0b19yZXBseV9jb25z'
    'ZWN1dGl2ZV9jb3VudBgVIAEoBVIZYXV0b1JlcGx5Q29uc2VjdXRpdmVDb3VudBIxChVhdXRvX3'
    'JlcGx5X2hvdXJfY291bnQYFiABKAVSEmF1dG9SZXBseUhvdXJDb3VudBJFCh9hdXRvX3JlcGx5'
    'X3Blcm1hbmVudGx5X2Rpc2FibGVkGBcgASgIUhxhdXRvUmVwbHlQZXJtYW5lbnRseURpc2FibG'
    'VkEhkKCGlzX2dob3N0GBggASgIUgdpc0dob3N0EkkKDGdob3N0X3N0YXR1cxgZIAEoDjImLmNy'
    'ZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuR2hvc3RTdGF0dXNSC2dob3N0U3RhdHVzEk4KDnRocm'
    '90dGxlX3N0YXRlGBogASgOMicuY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5UaHJvdHRsZU1v'
    'ZGVSDXRocm90dGxlU3RhdGUSMAoUY29ubmVjdGVkX2FjY291bnRfaWQYGyABKAlSEmNvbm5lY3'
    'RlZEFjY291bnRJZBInCg9hY2NvdW50X3Jldm9rZWQYHCABKAhSDmFjY291bnRSZXZva2VkEk8K'
    'DnJlcGx5X2lkZW50aXR5GB0gASgLMiguY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5SZXBseU'
    'lkZW50aXR5Ug1yZXBseUlkZW50aXR5');

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {
      '1': 'subtype',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.MessageSubtype',
      '10': 'subtype'
    },
    {'1': 'source_platform', '3': 5, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {'1': 'body', '3': 6, '4': 1, '5': 9, '10': 'body'},
    {
      '1': 'author_direction',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.AuthorDirection',
      '10': 'authorDirection'
    },
    {'1': 'author_entity_id', '3': 8, '4': 1, '5': 9, '10': 'authorEntityId'},
    {'1': 'author_user_id', '3': 9, '4': 1, '5': 9, '10': 'authorUserId'},
    {'1': 'moderation_state', '3': 10, '4': 1, '5': 9, '10': 'moderationState'},
    {'1': 'intent_overlay', '3': 11, '4': 1, '5': 9, '10': 'intentOverlay'},
    {'1': 'attachments', '3': 12, '4': 3, '5': 9, '10': 'attachments'},
    {
      '1': 'external_message_id',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'externalMessageId'
    },
    {
      '1': 'created_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEh0KCm1lc3NhZ2VfaWQYASABKAlSCW1lc3NhZ2VJZBIhCgx3b3Jrc3BhY2VfaW'
    'QYAiABKAlSC3dvcmtzcGFjZUlkEhsKCXRocmVhZF9pZBgDIAEoCVIIdGhyZWFkSWQSQwoHc3Vi'
    'dHlwZRgEIAEoDjIpLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuTWVzc2FnZVN1YnR5cGVSB3'
    'N1YnR5cGUSJwoPc291cmNlX3BsYXRmb3JtGAUgASgJUg5zb3VyY2VQbGF0Zm9ybRISCgRib2R5'
    'GAYgASgJUgRib2R5ElUKEGF1dGhvcl9kaXJlY3Rpb24YByABKA4yKi5jcmVhdGl2YW50YS5lbm'
    'dhZ2VtZW50LnYxLkF1dGhvckRpcmVjdGlvblIPYXV0aG9yRGlyZWN0aW9uEigKEGF1dGhvcl9l'
    'bnRpdHlfaWQYCCABKAlSDmF1dGhvckVudGl0eUlkEiQKDmF1dGhvcl91c2VyX2lkGAkgASgJUg'
    'xhdXRob3JVc2VySWQSKQoQbW9kZXJhdGlvbl9zdGF0ZRgKIAEoCVIPbW9kZXJhdGlvblN0YXRl'
    'EiUKDmludGVudF9vdmVybGF5GAsgASgJUg1pbnRlbnRPdmVybGF5EiAKC2F0dGFjaG1lbnRzGA'
    'wgAygJUgthdHRhY2htZW50cxIuChNleHRlcm5hbF9tZXNzYWdlX2lkGA0gASgJUhFleHRlcm5h'
    'bE1lc3NhZ2VJZBI5CgpjcmVhdGVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use entityDescriptor instead')
const Entity$json = {
  '1': 'Entity',
  '2': [
    {'1': 'entity_id', '3': 1, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'entity_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.EntityType',
      '10': 'entityType'
    },
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'platform_handles_json',
      '3': 5,
      '4': 3,
      '5': 9,
      '10': 'platformHandlesJson'
    },
    {
      '1': 'relationship_state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.EntityRelationshipState',
      '10': 'relationshipState'
    },
    {'1': 'tags', '3': 7, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'metadata_json', '3': 8, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Entity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityDescriptor = $convert.base64Decode(
    'CgZFbnRpdHkSGwoJZW50aXR5X2lkGAEgASgJUghlbnRpdHlJZBIhCgx3b3Jrc3BhY2VfaWQYAi'
    'ABKAlSC3dvcmtzcGFjZUlkEkYKC2VudGl0eV90eXBlGAMgASgOMiUuY3JlYXRpdmFudGEuZW5n'
    'YWdlbWVudC52MS5FbnRpdHlUeXBlUgplbnRpdHlUeXBlEiEKDGRpc3BsYXlfbmFtZRgEIAEoCV'
    'ILZGlzcGxheU5hbWUSMgoVcGxhdGZvcm1faGFuZGxlc19qc29uGAUgAygJUhNwbGF0Zm9ybUhh'
    'bmRsZXNKc29uEmEKEnJlbGF0aW9uc2hpcF9zdGF0ZRgGIAEoDjIyLmNyZWF0aXZhbnRhLmVuZ2'
    'FnZW1lbnQudjEuRW50aXR5UmVsYXRpb25zaGlwU3RhdGVSEXJlbGF0aW9uc2hpcFN0YXRlEhIK'
    'BHRhZ3MYByADKAlSBHRhZ3MSIwoNbWV0YWRhdGFfanNvbhgIIAEoCVIMbWV0YWRhdGFKc29uEj'
    'kKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVk'
    'QXQSOQoKdXBkYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZG'
    'F0ZWRBdA==');

@$core.Deprecated('Use followUpTaskDescriptor instead')
const FollowUpTask$json = {
  '1': 'FollowUpTask',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'source_thread_id', '3': 3, '4': 1, '5': 9, '10': 'sourceThreadId'},
    {
      '1': 'source_object_type',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'sourceObjectType'
    },
    {'1': 'source_object_id', '3': 5, '4': 1, '5': 9, '10': 'sourceObjectId'},
    {'1': 'assigned_user_id', '3': 6, '4': 1, '5': 9, '10': 'assignedUserId'},
    {'1': 'task_type', '3': 7, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'title', '3': 8, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 9, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'due_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {
      '1': 'status',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.FollowUpTaskStatus',
      '10': 'status'
    },
    {'1': 'outcome_summary', '3': 12, '4': 1, '5': 9, '10': 'outcomeSummary'},
    {'1': 'task_ref', '3': 13, '4': 1, '5': 9, '10': 'taskRef'},
    {'1': 'phase', '3': 14, '4': 1, '5': 9, '10': 'phase'},
    {'1': 'is_p6_deferred', '3': 15, '4': 1, '5': 8, '10': 'isP6Deferred'},
    {
      '1': 'created_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `FollowUpTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpTaskDescriptor = $convert.base64Decode(
    'CgxGb2xsb3dVcFRhc2sSFwoHdGFza19pZBgBIAEoCVIGdGFza0lkEiEKDHdvcmtzcGFjZV9pZB'
    'gCIAEoCVILd29ya3NwYWNlSWQSKAoQc291cmNlX3RocmVhZF9pZBgDIAEoCVIOc291cmNlVGhy'
    'ZWFkSWQSLAoSc291cmNlX29iamVjdF90eXBlGAQgASgJUhBzb3VyY2VPYmplY3RUeXBlEigKEH'
    'NvdXJjZV9vYmplY3RfaWQYBSABKAlSDnNvdXJjZU9iamVjdElkEigKEGFzc2lnbmVkX3VzZXJf'
    'aWQYBiABKAlSDmFzc2lnbmVkVXNlcklkEhsKCXRhc2tfdHlwZRgHIAEoCVIIdGFza1R5cGUSFA'
    'oFdGl0bGUYCCABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGAkgASgJUgtkZXNjcmlwdGlvbhIx'
    'CgZkdWVfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgVkdWVBdBJFCgZzdG'
    'F0dXMYCyABKA4yLS5jcmVhdGl2YW50YS5lbmdhZ2VtZW50LnYxLkZvbGxvd1VwVGFza1N0YXR1'
    'c1IGc3RhdHVzEicKD291dGNvbWVfc3VtbWFyeRgMIAEoCVIOb3V0Y29tZVN1bW1hcnkSGQoIdG'
    'Fza19yZWYYDSABKAlSB3Rhc2tSZWYSFAoFcGhhc2UYDiABKAlSBXBoYXNlEiQKDmlzX3A2X2Rl'
    'ZmVycmVkGA8gASgIUgxpc1A2RGVmZXJyZWQSOQoKY3JlYXRlZF9hdBgQIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBEgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use engagementThrottleStatusDescriptor instead')
const EngagementThrottleStatus$json = {
  '1': 'EngagementThrottleStatus',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'current_rate_per_min',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'currentRatePerMin'
    },
    {
      '1': 'throttle_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThrottleMode',
      '10': 'throttleMode'
    },
    {
      '1': 'unprocessed_raw_count',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'unprocessedRawCount'
    },
    {
      '1': 'last_surge_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastSurgeAt'
    },
    {'1': 'user_notice', '3': 6, '4': 1, '5': 9, '10': 'userNotice'},
    {
      '1': 'requires_manual_batch_trigger',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'requiresManualBatchTrigger'
    },
  ],
};

/// Descriptor for `EngagementThrottleStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List engagementThrottleStatusDescriptor = $convert.base64Decode(
    'ChhFbmdhZ2VtZW50VGhyb3R0bGVTdGF0dXMSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIvChRjdXJyZW50X3JhdGVfcGVyX21pbhgCIAEoBVIRY3VycmVudFJhdGVQZXJNaW4S'
    'TAoNdGhyb3R0bGVfbW9kZRgDIAEoDjInLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuVGhyb3'
    'R0bGVNb2RlUgx0aHJvdHRsZU1vZGUSMgoVdW5wcm9jZXNzZWRfcmF3X2NvdW50GAQgASgFUhN1'
    'bnByb2Nlc3NlZFJhd0NvdW50Ej4KDWxhc3Rfc3VyZ2VfYXQYBSABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgtsYXN0U3VyZ2VBdBIfCgt1c2VyX25vdGljZRgGIAEoCVIKdXNlck5v'
    'dGljZRJBCh1yZXF1aXJlc19tYW51YWxfYmF0Y2hfdHJpZ2dlchgHIAEoCFIacmVxdWlyZXNNYW'
    '51YWxCYXRjaFRyaWdnZXI=');

@$core.Deprecated('Use suggestedReplyDescriptor instead')
const SuggestedReply$json = {
  '1': 'SuggestedReply',
  '2': [
    {'1': 'suggestion_id', '3': 1, '4': 1, '5': 9, '10': 'suggestionId'},
    {'1': 'reply_text', '3': 2, '4': 1, '5': 9, '10': 'replyText'},
    {'1': 'confidence', '3': 3, '4': 1, '5': 1, '10': 'confidence'},
    {'1': 'tone', '3': 4, '4': 1, '5': 9, '10': 'tone'},
  ],
};

/// Descriptor for `SuggestedReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestedReplyDescriptor = $convert.base64Decode(
    'Cg5TdWdnZXN0ZWRSZXBseRIjCg1zdWdnZXN0aW9uX2lkGAEgASgJUgxzdWdnZXN0aW9uSWQSHQ'
    'oKcmVwbHlfdGV4dBgCIAEoCVIJcmVwbHlUZXh0Eh4KCmNvbmZpZGVuY2UYAyABKAFSCmNvbmZp'
    'ZGVuY2USEgoEdG9uZRgEIAEoCVIEdG9uZQ==');

@$core.Deprecated('Use suggestedActionDescriptor instead')
const SuggestedAction$json = {
  '1': 'SuggestedAction',
  '2': [
    {'1': 'action_type', '3': 1, '4': 1, '5': 9, '10': 'actionType'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'target_module', '3': 4, '4': 1, '5': 9, '10': 'targetModule'},
  ],
};

/// Descriptor for `SuggestedAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestedActionDescriptor = $convert.base64Decode(
    'Cg9TdWdnZXN0ZWRBY3Rpb24SHwoLYWN0aW9uX3R5cGUYASABKAlSCmFjdGlvblR5cGUSFAoFdG'
    'l0bGUYAiABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhIjCg10'
    'YXJnZXRfbW9kdWxlGAQgASgJUgx0YXJnZXRNb2R1bGU=');

@$core.Deprecated('Use threadServiceListRequestDescriptor instead')
const ThreadServiceListRequest$json = {
  '1': 'ThreadServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadStatus',
      '10': 'status'
    },
    {
      '1': 'priority',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadPriority',
      '10': 'priority'
    },
    {
      '1': 'intent',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadIntent',
      '10': 'intent'
    },
    {'1': 'source_platform', '3': 5, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {'1': 'owner_user_id', '3': 6, '4': 1, '5': 9, '10': 'ownerUserId'},
    {'1': 'sla_breached_only', '3': 7, '4': 1, '5': 8, '10': 'slaBreachedOnly'},
    {
      '1': 'pagination',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ThreadServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceListRequestDescriptor = $convert.base64Decode(
    'ChhUaHJlYWRTZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBI/CgZzdGF0dXMYAiABKA4yJy5jcmVhdGl2YW50YS5lbmdhZ2VtZW50LnYxLlRocmVh'
    'ZFN0YXR1c1IGc3RhdHVzEkUKCHByaW9yaXR5GAMgASgOMikuY3JlYXRpdmFudGEuZW5nYWdlbW'
    'VudC52MS5UaHJlYWRQcmlvcml0eVIIcHJpb3JpdHkSPwoGaW50ZW50GAQgASgOMicuY3JlYXRp'
    'dmFudGEuZW5nYWdlbWVudC52MS5UaHJlYWRJbnRlbnRSBmludGVudBInCg9zb3VyY2VfcGxhdG'
    'Zvcm0YBSABKAlSDnNvdXJjZVBsYXRmb3JtEiIKDW93bmVyX3VzZXJfaWQYBiABKAlSC293bmVy'
    'VXNlcklkEioKEXNsYV9icmVhY2hlZF9vbmx5GAcgASgIUg9zbGFCcmVhY2hlZE9ubHkSQQoKcG'
    'FnaW5hdGlvbhgIIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdp'
    'bmF0aW9u');

@$core.Deprecated('Use threadServiceListResponseDescriptor instead')
const ThreadServiceListResponse$json = {
  '1': 'ThreadServiceListResponse',
  '2': [
    {
      '1': 'threads',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'threads'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ThreadServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceListResponseDescriptor = $convert.base64Decode(
    'ChlUaHJlYWRTZXJ2aWNlTGlzdFJlc3BvbnNlEjsKB3RocmVhZHMYASADKAsyIS5jcmVhdGl2YW'
    '50YS5lbmdhZ2VtZW50LnYxLlRocmVhZFIHdGhyZWFkcxJICgpwYWdpbmF0aW9uGAIgASgLMigu'
    'Y3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use threadServiceGetRequestDescriptor instead')
const ThreadServiceGetRequest$json = {
  '1': 'ThreadServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `ThreadServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChdUaHJlYWRTZXJ2aWNlR2V0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlkEhsKCXRocmVhZF9pZBgCIAEoCVIIdGhyZWFkSWQ=');

@$core.Deprecated('Use threadServiceGetResponseDescriptor instead')
const ThreadServiceGetResponse$json = {
  '1': 'ThreadServiceGetResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
    {
      '1': 'messages',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.Message',
      '10': 'messages'
    },
    {
      '1': 'entity',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Entity',
      '10': 'entity'
    },
    {
      '1': 'follow_up_tasks',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.FollowUpTask',
      '10': 'followUpTasks'
    },
  ],
};

/// Descriptor for `ThreadServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceGetResponseDescriptor = $convert.base64Decode(
    'ChhUaHJlYWRTZXJ2aWNlR2V0UmVzcG9uc2USOQoGdGhyZWFkGAEgASgLMiEuY3JlYXRpdmFudG'
    'EuZW5nYWdlbWVudC52MS5UaHJlYWRSBnRocmVhZBI+CghtZXNzYWdlcxgCIAMoCzIiLmNyZWF0'
    'aXZhbnRhLmVuZ2FnZW1lbnQudjEuTWVzc2FnZVIIbWVzc2FnZXMSOQoGZW50aXR5GAMgASgLMi'
    'EuY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5FbnRpdHlSBmVudGl0eRJPCg9mb2xsb3dfdXBf'
    'dGFza3MYBCADKAsyJy5jcmVhdGl2YW50YS5lbmdhZ2VtZW50LnYxLkZvbGxvd1VwVGFza1INZm'
    '9sbG93VXBUYXNrcw==');

@$core.Deprecated('Use threadServiceTriageRequestDescriptor instead')
const ThreadServiceTriageRequest$json = {
  '1': 'ThreadServiceTriageRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {
      '1': 'intent',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadIntent',
      '10': 'intent'
    },
    {
      '1': 'priority',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadPriority',
      '10': 'priority'
    },
    {'1': 'next_action', '3': 6, '4': 1, '5': 9, '10': 'nextAction'},
    {'1': 'owner_user_id', '3': 7, '4': 1, '5': 9, '10': 'ownerUserId'},
    {
      '1': 'sla_due_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'slaDueAt'
    },
  ],
};

/// Descriptor for `ThreadServiceTriageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceTriageRequestDescriptor = $convert.base64Decode(
    'ChpUaHJlYWRTZXJ2aWNlVHJpYWdlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgC'
    'IAEoCVILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAMgASgJUgh0aHJlYWRJZBI/CgZpbnRlbn'
    'QYBCABKA4yJy5jcmVhdGl2YW50YS5lbmdhZ2VtZW50LnYxLlRocmVhZEludGVudFIGaW50ZW50'
    'EkUKCHByaW9yaXR5GAUgASgOMikuY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5UaHJlYWRQcm'
    'lvcml0eVIIcHJpb3JpdHkSHwoLbmV4dF9hY3Rpb24YBiABKAlSCm5leHRBY3Rpb24SIgoNb3du'
    'ZXJfdXNlcl9pZBgHIAEoCVILb3duZXJVc2VySWQSOAoKc2xhX2R1ZV9hdBgIIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHNsYUR1ZUF0');

@$core.Deprecated('Use threadServiceTriageResponseDescriptor instead')
const ThreadServiceTriageResponse$json = {
  '1': 'ThreadServiceTriageResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `ThreadServiceTriageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceTriageResponseDescriptor =
    $convert.base64Decode(
        'ChtUaHJlYWRTZXJ2aWNlVHJpYWdlUmVzcG9uc2USOQoGdGhyZWFkGAEgASgLMiEuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5UaHJlYWRSBnRocmVhZA==');

@$core.Deprecated('Use threadServiceAssignRequestDescriptor instead')
const ThreadServiceAssignRequest$json = {
  '1': 'ThreadServiceAssignRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'owner_user_id', '3': 4, '4': 1, '5': 9, '10': 'ownerUserId'},
  ],
};

/// Descriptor for `ThreadServiceAssignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceAssignRequestDescriptor = $convert.base64Decode(
    'ChpUaHJlYWRTZXJ2aWNlQXNzaWduUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgC'
    'IAEoCVILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAMgASgJUgh0aHJlYWRJZBIiCg1vd25lcl'
    '91c2VyX2lkGAQgASgJUgtvd25lclVzZXJJZA==');

@$core.Deprecated('Use threadServiceAssignResponseDescriptor instead')
const ThreadServiceAssignResponse$json = {
  '1': 'ThreadServiceAssignResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `ThreadServiceAssignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceAssignResponseDescriptor =
    $convert.base64Decode(
        'ChtUaHJlYWRTZXJ2aWNlQXNzaWduUmVzcG9uc2USOQoGdGhyZWFkGAEgASgLMiEuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5UaHJlYWRSBnRocmVhZA==');

@$core.Deprecated('Use threadServiceReplyRequestDescriptor instead')
const ThreadServiceReplyRequest$json = {
  '1': 'ThreadServiceReplyRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'body', '3': 4, '4': 1, '5': 9, '10': 'body'},
    {'1': 'attachments', '3': 5, '4': 3, '5': 9, '10': 'attachments'},
    {'1': 'suggestion_id', '3': 6, '4': 1, '5': 9, '10': 'suggestionId'},
    {'1': 'target_account_id', '3': 7, '4': 1, '5': 9, '10': 'targetAccountId'},
    {'1': 'is_auto_reply', '3': 8, '4': 1, '5': 8, '10': 'isAutoReply'},
  ],
};

/// Descriptor for `ThreadServiceReplyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceReplyRequestDescriptor = $convert.base64Decode(
    'ChlUaHJlYWRTZXJ2aWNlUmVwbHlSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNlX2lkGAIg'
    'ASgJUgt3b3Jrc3BhY2VJZBIbCgl0aHJlYWRfaWQYAyABKAlSCHRocmVhZElkEhIKBGJvZHkYBC'
    'ABKAlSBGJvZHkSIAoLYXR0YWNobWVudHMYBSADKAlSC2F0dGFjaG1lbnRzEiMKDXN1Z2dlc3Rp'
    'b25faWQYBiABKAlSDHN1Z2dlc3Rpb25JZBIqChF0YXJnZXRfYWNjb3VudF9pZBgHIAEoCVIPdG'
    'FyZ2V0QWNjb3VudElkEiIKDWlzX2F1dG9fcmVwbHkYCCABKAhSC2lzQXV0b1JlcGx5');

@$core.Deprecated('Use threadServiceReplyResponseDescriptor instead')
const ThreadServiceReplyResponse$json = {
  '1': 'ThreadServiceReplyResponse',
  '2': [
    {
      '1': 'message',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Message',
      '10': 'message'
    },
    {
      '1': 'thread',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `ThreadServiceReplyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceReplyResponseDescriptor =
    $convert.base64Decode(
        'ChpUaHJlYWRTZXJ2aWNlUmVwbHlSZXNwb25zZRI8CgdtZXNzYWdlGAEgASgLMiIuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5NZXNzYWdlUgdtZXNzYWdlEjkKBnRocmVhZBgCIAEoCzIhLmNy'
        'ZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuVGhyZWFkUgZ0aHJlYWQ=');

@$core.Deprecated('Use threadServiceResolveRequestDescriptor instead')
const ThreadServiceResolveRequest$json = {
  '1': 'ThreadServiceResolveRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'outcome_summary', '3': 4, '4': 1, '5': 9, '10': 'outcomeSummary'},
  ],
};

/// Descriptor for `ThreadServiceResolveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceResolveRequestDescriptor = $convert.base64Decode(
    'ChtUaHJlYWRTZXJ2aWNlUmVzb2x2ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQY'
    'AiABKAlSC3dvcmtzcGFjZUlkEhsKCXRocmVhZF9pZBgDIAEoCVIIdGhyZWFkSWQSJwoPb3V0Y2'
    '9tZV9zdW1tYXJ5GAQgASgJUg5vdXRjb21lU3VtbWFyeQ==');

@$core.Deprecated('Use threadServiceResolveResponseDescriptor instead')
const ThreadServiceResolveResponse$json = {
  '1': 'ThreadServiceResolveResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `ThreadServiceResolveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceResolveResponseDescriptor =
    $convert.base64Decode(
        'ChxUaHJlYWRTZXJ2aWNlUmVzb2x2ZVJlc3BvbnNlEjkKBnRocmVhZBgBIAEoCzIhLmNyZWF0aX'
        'ZhbnRhLmVuZ2FnZW1lbnQudjEuVGhyZWFkUgZ0aHJlYWQ=');

@$core.Deprecated('Use threadServiceBulkTriageRequestDescriptor instead')
const ThreadServiceBulkTriageRequest$json = {
  '1': 'ThreadServiceBulkTriageRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_ids', '3': 3, '4': 3, '5': 9, '10': 'threadIds'},
    {
      '1': 'intent',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadIntent',
      '10': 'intent'
    },
    {
      '1': 'priority',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadPriority',
      '10': 'priority'
    },
    {'1': 'owner_user_id', '3': 6, '4': 1, '5': 9, '10': 'ownerUserId'},
    {'1': 'next_action', '3': 7, '4': 1, '5': 9, '10': 'nextAction'},
    {
      '1': 'target_status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadStatus',
      '10': 'targetStatus'
    },
  ],
};

/// Descriptor for `ThreadServiceBulkTriageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceBulkTriageRequestDescriptor = $convert.base64Decode(
    'Ch5UaHJlYWRTZXJ2aWNlQnVsa1RyaWFnZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
    'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2Vf'
    'aWQYAiABKAlSC3dvcmtzcGFjZUlkEh0KCnRocmVhZF9pZHMYAyADKAlSCXRocmVhZElkcxI/Cg'
    'ZpbnRlbnQYBCABKA4yJy5jcmVhdGl2YW50YS5lbmdhZ2VtZW50LnYxLlRocmVhZEludGVudFIG'
    'aW50ZW50EkUKCHByaW9yaXR5GAUgASgOMikuY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5UaH'
    'JlYWRQcmlvcml0eVIIcHJpb3JpdHkSIgoNb3duZXJfdXNlcl9pZBgGIAEoCVILb3duZXJVc2Vy'
    'SWQSHwoLbmV4dF9hY3Rpb24YByABKAlSCm5leHRBY3Rpb24STAoNdGFyZ2V0X3N0YXR1cxgIIA'
    'EoDjInLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuVGhyZWFkU3RhdHVzUgx0YXJnZXRTdGF0'
    'dXM=');

@$core.Deprecated('Use threadServiceBulkTriageResponseDescriptor instead')
const ThreadServiceBulkTriageResponse$json = {
  '1': 'ThreadServiceBulkTriageResponse',
  '2': [
    {'1': 'triaged_count', '3': 1, '4': 1, '5': 5, '10': 'triagedCount'},
    {
      '1': 'threads',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'threads'
    },
  ],
};

/// Descriptor for `ThreadServiceBulkTriageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceBulkTriageResponseDescriptor =
    $convert.base64Decode(
        'Ch9UaHJlYWRTZXJ2aWNlQnVsa1RyaWFnZVJlc3BvbnNlEiMKDXRyaWFnZWRfY291bnQYASABKA'
        'VSDHRyaWFnZWRDb3VudBI7Cgd0aHJlYWRzGAIgAygLMiEuY3JlYXRpdmFudGEuZW5nYWdlbWVu'
        'dC52MS5UaHJlYWRSB3RocmVhZHM=');

@$core.Deprecated('Use threadServiceGetMessagesRequestDescriptor instead')
const ThreadServiceGetMessagesRequest$json = {
  '1': 'ThreadServiceGetMessagesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ThreadServiceGetMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceGetMessagesRequestDescriptor =
    $convert.base64Decode(
        'Ch9UaHJlYWRTZXJ2aWNlR2V0TWVzc2FnZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZBJBCgpwYWdpbmF0aW9u'
        'GAMgASgLMiEuY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use threadServiceGetMessagesResponseDescriptor instead')
const ThreadServiceGetMessagesResponse$json = {
  '1': 'ThreadServiceGetMessagesResponse',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.Message',
      '10': 'messages'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ThreadServiceGetMessagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceGetMessagesResponseDescriptor =
    $convert.base64Decode(
        'CiBUaHJlYWRTZXJ2aWNlR2V0TWVzc2FnZXNSZXNwb25zZRI+CghtZXNzYWdlcxgBIAMoCzIiLm'
        'NyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuTWVzc2FnZVIIbWVzc2FnZXMSSAoKcGFnaW5hdGlv'
        'bhgCIAEoCzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcGFnaW'
        '5hdGlvbg==');

@$core.Deprecated('Use threadServiceGetUnreadCountRequestDescriptor instead')
const ThreadServiceGetUnreadCountRequest$json = {
  '1': 'ThreadServiceGetUnreadCountRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'owner_user_id', '3': 2, '4': 1, '5': 9, '10': 'ownerUserId'},
  ],
};

/// Descriptor for `ThreadServiceGetUnreadCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceGetUnreadCountRequestDescriptor =
    $convert.base64Decode(
        'CiJUaHJlYWRTZXJ2aWNlR2V0VW5yZWFkQ291bnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSIgoNb3duZXJfdXNlcl9pZBgCIAEoCVILb3duZXJVc2VySWQ=');

@$core.Deprecated('Use threadServiceGetUnreadCountResponseDescriptor instead')
const ThreadServiceGetUnreadCountResponse$json = {
  '1': 'ThreadServiceGetUnreadCountResponse',
  '2': [
    {'1': 'unread_count', '3': 1, '4': 1, '5': 5, '10': 'unreadCount'},
    {
      '1': 'sla_breached_count',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'slaBreachedCount'
    },
  ],
};

/// Descriptor for `ThreadServiceGetUnreadCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceGetUnreadCountResponseDescriptor =
    $convert.base64Decode(
        'CiNUaHJlYWRTZXJ2aWNlR2V0VW5yZWFkQ291bnRSZXNwb25zZRIhCgx1bnJlYWRfY291bnQYAS'
        'ABKAVSC3VucmVhZENvdW50EiwKEnNsYV9icmVhY2hlZF9jb3VudBgCIAEoBVIQc2xhQnJlYWNo'
        'ZWRDb3VudA==');

@$core.Deprecated('Use threadServiceMarkReadRequestDescriptor instead')
const ThreadServiceMarkReadRequest$json = {
  '1': 'ThreadServiceMarkReadRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `ThreadServiceMarkReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceMarkReadRequestDescriptor =
    $convert.base64Decode(
        'ChxUaHJlYWRTZXJ2aWNlTWFya1JlYWRSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdG'
        'l2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNlX2lk'
        'GAIgASgJUgt3b3Jrc3BhY2VJZBIbCgl0aHJlYWRfaWQYAyABKAlSCHRocmVhZElk');

@$core.Deprecated('Use threadServiceMarkReadResponseDescriptor instead')
const ThreadServiceMarkReadResponse$json = {
  '1': 'ThreadServiceMarkReadResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ThreadServiceMarkReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceMarkReadResponseDescriptor =
    $convert.base64Decode(
        'Ch1UaHJlYWRTZXJ2aWNlTWFya1JlYWRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZX'
        'Nz');

@$core.Deprecated('Use threadServiceUpdateRequestDescriptor instead')
const ThreadServiceUpdateRequest$json = {
  '1': 'ThreadServiceUpdateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'next_action', '3': 4, '4': 1, '5': 9, '10': 'nextAction'},
    {
      '1': 'priority',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadPriority',
      '10': 'priority'
    },
    {
      '1': 'intent',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadIntent',
      '10': 'intent'
    },
  ],
};

/// Descriptor for `ThreadServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChpUaHJlYWRTZXJ2aWNlVXBkYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgC'
    'IAEoCVILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAMgASgJUgh0aHJlYWRJZBIfCgtuZXh0X2'
    'FjdGlvbhgEIAEoCVIKbmV4dEFjdGlvbhJFCghwcmlvcml0eRgFIAEoDjIpLmNyZWF0aXZhbnRh'
    'LmVuZ2FnZW1lbnQudjEuVGhyZWFkUHJpb3JpdHlSCHByaW9yaXR5Ej8KBmludGVudBgGIAEoDj'
    'InLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuVGhyZWFkSW50ZW50UgZpbnRlbnQ=');

@$core.Deprecated('Use threadServiceUpdateResponseDescriptor instead')
const ThreadServiceUpdateResponse$json = {
  '1': 'ThreadServiceUpdateResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `ThreadServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'ChtUaHJlYWRTZXJ2aWNlVXBkYXRlUmVzcG9uc2USOQoGdGhyZWFkGAEgASgLMiEuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5UaHJlYWRSBnRocmVhZA==');

@$core.Deprecated('Use threadServiceAddTagRequestDescriptor instead')
const ThreadServiceAddTagRequest$json = {
  '1': 'ThreadServiceAddTagRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'tag', '3': 4, '4': 1, '5': 9, '10': 'tag'},
  ],
};

/// Descriptor for `ThreadServiceAddTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceAddTagRequestDescriptor = $convert.base64Decode(
    'ChpUaHJlYWRTZXJ2aWNlQWRkVGFnUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgC'
    'IAEoCVILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAMgASgJUgh0aHJlYWRJZBIQCgN0YWcYBC'
    'ABKAlSA3RhZw==');

@$core.Deprecated('Use threadServiceAddTagResponseDescriptor instead')
const ThreadServiceAddTagResponse$json = {
  '1': 'ThreadServiceAddTagResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `ThreadServiceAddTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceAddTagResponseDescriptor =
    $convert.base64Decode(
        'ChtUaHJlYWRTZXJ2aWNlQWRkVGFnUmVzcG9uc2USOQoGdGhyZWFkGAEgASgLMiEuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5UaHJlYWRSBnRocmVhZA==');

@$core.Deprecated('Use threadServiceMuteRequestDescriptor instead')
const ThreadServiceMuteRequest$json = {
  '1': 'ThreadServiceMuteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `ThreadServiceMuteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceMuteRequestDescriptor = $convert.base64Decode(
    'ChhUaHJlYWRTZXJ2aWNlTXV0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQYAiAB'
    'KAlSC3dvcmtzcGFjZUlkEhsKCXRocmVhZF9pZBgDIAEoCVIIdGhyZWFkSWQ=');

@$core.Deprecated('Use threadServiceMuteResponseDescriptor instead')
const ThreadServiceMuteResponse$json = {
  '1': 'ThreadServiceMuteResponse',
  '2': [
    {'1': 'muted', '3': 1, '4': 1, '5': 8, '10': 'muted'},
  ],
};

/// Descriptor for `ThreadServiceMuteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceMuteResponseDescriptor =
    $convert.base64Decode(
        'ChlUaHJlYWRTZXJ2aWNlTXV0ZVJlc3BvbnNlEhQKBW11dGVkGAEgASgIUgVtdXRlZA==');

@$core.Deprecated('Use threadServiceSnoozeRequestDescriptor instead')
const ThreadServiceSnoozeRequest$json = {
  '1': 'ThreadServiceSnoozeRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {
      '1': 'wake_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'wakeAt'
    },
  ],
};

/// Descriptor for `ThreadServiceSnoozeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceSnoozeRequestDescriptor = $convert.base64Decode(
    'ChpUaHJlYWRTZXJ2aWNlU25vb3plUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgC'
    'IAEoCVILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAMgASgJUgh0aHJlYWRJZBIzCgd3YWtlX2'
    'F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIGd2FrZUF0');

@$core.Deprecated('Use threadServiceSnoozeResponseDescriptor instead')
const ThreadServiceSnoozeResponse$json = {
  '1': 'ThreadServiceSnoozeResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
  ],
};

/// Descriptor for `ThreadServiceSnoozeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceSnoozeResponseDescriptor =
    $convert.base64Decode(
        'ChtUaHJlYWRTZXJ2aWNlU25vb3plUmVzcG9uc2USOQoGdGhyZWFkGAEgASgLMiEuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5UaHJlYWRSBnRocmVhZA==');

@$core.Deprecated('Use threadServiceListMobileRequestDescriptor instead')
const ThreadServiceListMobileRequest$json = {
  '1': 'ThreadServiceListMobileRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'owner_user_id', '3': 2, '4': 1, '5': 9, '10': 'ownerUserId'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.ThreadStatus',
      '10': 'status'
    },
    {
      '1': 'pagination',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ThreadServiceListMobileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceListMobileRequestDescriptor = $convert.base64Decode(
    'Ch5UaHJlYWRTZXJ2aWNlTGlzdE1vYmlsZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
    't3b3Jrc3BhY2VJZBIiCg1vd25lcl91c2VyX2lkGAIgASgJUgtvd25lclVzZXJJZBI/CgZzdGF0'
    'dXMYAyABKA4yJy5jcmVhdGl2YW50YS5lbmdhZ2VtZW50LnYxLlRocmVhZFN0YXR1c1IGc3RhdH'
    'VzEkEKCnBhZ2luYXRpb24YBCABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGlv'
    'blIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use threadServiceListMobileResponseDescriptor instead')
const ThreadServiceListMobileResponse$json = {
  '1': 'ThreadServiceListMobileResponse',
  '2': [
    {
      '1': 'threads',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'threads'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ThreadServiceListMobileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceListMobileResponseDescriptor =
    $convert.base64Decode(
        'Ch9UaHJlYWRTZXJ2aWNlTGlzdE1vYmlsZVJlc3BvbnNlEjsKB3RocmVhZHMYASADKAsyIS5jcm'
        'VhdGl2YW50YS5lbmdhZ2VtZW50LnYxLlRocmVhZFIHdGhyZWFkcxJICgpwYWdpbmF0aW9uGAIg'
        'ASgLMiguY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW'
        '9u');

@$core
    .Deprecated('Use threadServiceHandleGhostMessageRequestDescriptor instead')
const ThreadServiceHandleGhostMessageRequest$json = {
  '1': 'ThreadServiceHandleGhostMessageRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
    {
      '1': 'platform_http_code',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'platformHttpCode'
    },
    {'1': 'error_message', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `ThreadServiceHandleGhostMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceHandleGhostMessageRequestDescriptor =
    $convert.base64Decode(
        'CiZUaHJlYWRTZXJ2aWNlSGFuZGxlR2hvc3RNZXNzYWdlUmVxdWVzdBI/Cgdjb250ZXh0GAEgAS'
        'gLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdv'
        'cmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAMgASgJUgh0aHJlYW'
        'RJZBIsChJwbGF0Zm9ybV9odHRwX2NvZGUYBCABKAVSEHBsYXRmb3JtSHR0cENvZGUSIwoNZXJy'
        'b3JfbWVzc2FnZRgFIAEoCVIMZXJyb3JNZXNzYWdl');

@$core
    .Deprecated('Use threadServiceHandleGhostMessageResponseDescriptor instead')
const ThreadServiceHandleGhostMessageResponse$json = {
  '1': 'ThreadServiceHandleGhostMessageResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
    {'1': 'is_stale', '3': 2, '4': 1, '5': 8, '10': 'isStale'},
    {'1': 'compose_disabled', '3': 3, '4': 1, '5': 8, '10': 'composeDisabled'},
    {'1': 'user_explanation', '3': 4, '4': 1, '5': 9, '10': 'userExplanation'},
  ],
};

/// Descriptor for `ThreadServiceHandleGhostMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceHandleGhostMessageResponseDescriptor =
    $convert.base64Decode(
        'CidUaHJlYWRTZXJ2aWNlSGFuZGxlR2hvc3RNZXNzYWdlUmVzcG9uc2USOQoGdGhyZWFkGAEgAS'
        'gLMiEuY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5UaHJlYWRSBnRocmVhZBIZCghpc19zdGFs'
        'ZRgCIAEoCFIHaXNTdGFsZRIpChBjb21wb3NlX2Rpc2FibGVkGAMgASgIUg9jb21wb3NlRGlzYW'
        'JsZWQSKQoQdXNlcl9leHBsYW5hdGlvbhgEIAEoCVIPdXNlckV4cGxhbmF0aW9u');

@$core
    .Deprecated('Use threadServiceResetAutoReplyLoopRequestDescriptor instead')
const ThreadServiceResetAutoReplyLoopRequest$json = {
  '1': 'ThreadServiceResetAutoReplyLoopRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 3, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `ThreadServiceResetAutoReplyLoopRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceResetAutoReplyLoopRequestDescriptor =
    $convert.base64Decode(
        'CiZUaHJlYWRTZXJ2aWNlUmVzZXRBdXRvUmVwbHlMb29wUmVxdWVzdBI/Cgdjb250ZXh0GAEgAS'
        'gLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdv'
        'cmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAMgASgJUgh0aHJlYW'
        'RJZA==');

@$core
    .Deprecated('Use threadServiceResetAutoReplyLoopResponseDescriptor instead')
const ThreadServiceResetAutoReplyLoopResponse$json = {
  '1': 'ThreadServiceResetAutoReplyLoopResponse',
  '2': [
    {
      '1': 'thread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'thread'
    },
    {'1': 'auto_reply_active', '3': 2, '4': 1, '5': 8, '10': 'autoReplyActive'},
  ],
};

/// Descriptor for `ThreadServiceResetAutoReplyLoopResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threadServiceResetAutoReplyLoopResponseDescriptor =
    $convert.base64Decode(
        'CidUaHJlYWRTZXJ2aWNlUmVzZXRBdXRvUmVwbHlMb29wUmVzcG9uc2USOQoGdGhyZWFkGAEgAS'
        'gLMiEuY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5UaHJlYWRSBnRocmVhZBIqChFhdXRvX3Jl'
        'cGx5X2FjdGl2ZRgCIAEoCFIPYXV0b1JlcGx5QWN0aXZl');

@$core.Deprecated('Use entityServiceListRequestDescriptor instead')
const EntityServiceListRequest$json = {
  '1': 'EntityServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'entity_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.EntityType',
      '10': 'entityType'
    },
    {
      '1': 'relationship_state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.EntityRelationshipState',
      '10': 'relationshipState'
    },
    {'1': 'search_query', '3': 4, '4': 1, '5': 9, '10': 'searchQuery'},
    {
      '1': 'pagination',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `EntityServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceListRequestDescriptor = $convert.base64Decode(
    'ChhFbnRpdHlTZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBJGCgtlbnRpdHlfdHlwZRgCIAEoDjIlLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEu'
    'RW50aXR5VHlwZVIKZW50aXR5VHlwZRJhChJyZWxhdGlvbnNoaXBfc3RhdGUYAyABKA4yMi5jcm'
    'VhdGl2YW50YS5lbmdhZ2VtZW50LnYxLkVudGl0eVJlbGF0aW9uc2hpcFN0YXRlUhFyZWxhdGlv'
    'bnNoaXBTdGF0ZRIhCgxzZWFyY2hfcXVlcnkYBCABKAlSC3NlYXJjaFF1ZXJ5EkEKCnBhZ2luYX'
    'Rpb24YBSABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGlvblIKcGFnaW5hdGlv'
    'bg==');

@$core.Deprecated('Use entityServiceListResponseDescriptor instead')
const EntityServiceListResponse$json = {
  '1': 'EntityServiceListResponse',
  '2': [
    {
      '1': 'entities',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.Entity',
      '10': 'entities'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `EntityServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceListResponseDescriptor = $convert.base64Decode(
    'ChlFbnRpdHlTZXJ2aWNlTGlzdFJlc3BvbnNlEj0KCGVudGl0aWVzGAEgAygLMiEuY3JlYXRpdm'
    'FudGEuZW5nYWdlbWVudC52MS5FbnRpdHlSCGVudGl0aWVzEkgKCnBhZ2luYXRpb24YAiABKAsy'
    'KC5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use entityServiceGetRequestDescriptor instead')
const EntityServiceGetRequest$json = {
  '1': 'EntityServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'entity_id', '3': 2, '4': 1, '5': 9, '10': 'entityId'},
  ],
};

/// Descriptor for `EntityServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChdFbnRpdHlTZXJ2aWNlR2V0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlkEhsKCWVudGl0eV9pZBgCIAEoCVIIZW50aXR5SWQ=');

@$core.Deprecated('Use entityServiceGetResponseDescriptor instead')
const EntityServiceGetResponse$json = {
  '1': 'EntityServiceGetResponse',
  '2': [
    {
      '1': 'entity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Entity',
      '10': 'entity'
    },
    {
      '1': 'threads',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.Thread',
      '10': 'threads'
    },
  ],
};

/// Descriptor for `EntityServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceGetResponseDescriptor = $convert.base64Decode(
    'ChhFbnRpdHlTZXJ2aWNlR2V0UmVzcG9uc2USOQoGZW50aXR5GAEgASgLMiEuY3JlYXRpdmFudG'
    'EuZW5nYWdlbWVudC52MS5FbnRpdHlSBmVudGl0eRI7Cgd0aHJlYWRzGAIgAygLMiEuY3JlYXRp'
    'dmFudGEuZW5nYWdlbWVudC52MS5UaHJlYWRSB3RocmVhZHM=');

@$core.Deprecated('Use entityServiceCreateRequestDescriptor instead')
const EntityServiceCreateRequest$json = {
  '1': 'EntityServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'entity_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.EntityType',
      '10': 'entityType'
    },
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'relationship_state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.EntityRelationshipState',
      '10': 'relationshipState'
    },
    {
      '1': 'platform_handles_json',
      '3': 6,
      '4': 3,
      '5': 9,
      '10': 'platformHandlesJson'
    },
    {'1': 'tags', '3': 7, '4': 3, '5': 9, '10': 'tags'},
  ],
};

/// Descriptor for `EntityServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChpFbnRpdHlTZXJ2aWNlQ3JlYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgC'
    'IAEoCVILd29ya3NwYWNlSWQSRgoLZW50aXR5X3R5cGUYAyABKA4yJS5jcmVhdGl2YW50YS5lbm'
    'dhZ2VtZW50LnYxLkVudGl0eVR5cGVSCmVudGl0eVR5cGUSIQoMZGlzcGxheV9uYW1lGAQgASgJ'
    'UgtkaXNwbGF5TmFtZRJhChJyZWxhdGlvbnNoaXBfc3RhdGUYBSABKA4yMi5jcmVhdGl2YW50YS'
    '5lbmdhZ2VtZW50LnYxLkVudGl0eVJlbGF0aW9uc2hpcFN0YXRlUhFyZWxhdGlvbnNoaXBTdGF0'
    'ZRIyChVwbGF0Zm9ybV9oYW5kbGVzX2pzb24YBiADKAlSE3BsYXRmb3JtSGFuZGxlc0pzb24SEg'
    'oEdGFncxgHIAMoCVIEdGFncw==');

@$core.Deprecated('Use entityServiceCreateResponseDescriptor instead')
const EntityServiceCreateResponse$json = {
  '1': 'EntityServiceCreateResponse',
  '2': [
    {
      '1': 'entity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Entity',
      '10': 'entity'
    },
  ],
};

/// Descriptor for `EntityServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'ChtFbnRpdHlTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USOQoGZW50aXR5GAEgASgLMiEuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5FbnRpdHlSBmVudGl0eQ==');

@$core.Deprecated('Use entityServiceMergeRequestDescriptor instead')
const EntityServiceMergeRequest$json = {
  '1': 'EntityServiceMergeRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'primary_entity_id', '3': 3, '4': 1, '5': 9, '10': 'primaryEntityId'},
    {
      '1': 'secondary_entity_ids',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'secondaryEntityIds'
    },
  ],
};

/// Descriptor for `EntityServiceMergeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceMergeRequestDescriptor = $convert.base64Decode(
    'ChlFbnRpdHlTZXJ2aWNlTWVyZ2VSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNlX2lkGAIg'
    'ASgJUgt3b3Jrc3BhY2VJZBIqChFwcmltYXJ5X2VudGl0eV9pZBgDIAEoCVIPcHJpbWFyeUVudG'
    'l0eUlkEjAKFHNlY29uZGFyeV9lbnRpdHlfaWRzGAQgAygJUhJzZWNvbmRhcnlFbnRpdHlJZHM=');

@$core.Deprecated('Use entityServiceMergeResponseDescriptor instead')
const EntityServiceMergeResponse$json = {
  '1': 'EntityServiceMergeResponse',
  '2': [
    {
      '1': 'merged_entity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Entity',
      '10': 'mergedEntity'
    },
    {
      '1': 'threads_reassigned',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'threadsReassigned'
    },
  ],
};

/// Descriptor for `EntityServiceMergeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceMergeResponseDescriptor =
    $convert.base64Decode(
        'ChpFbnRpdHlTZXJ2aWNlTWVyZ2VSZXNwb25zZRJGCg1tZXJnZWRfZW50aXR5GAEgASgLMiEuY3'
        'JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5FbnRpdHlSDG1lcmdlZEVudGl0eRItChJ0aHJlYWRz'
        'X3JlYXNzaWduZWQYAiABKAVSEXRocmVhZHNSZWFzc2lnbmVk');

@$core.Deprecated('Use entityServiceAddNoteRequestDescriptor instead')
const EntityServiceAddNoteRequest$json = {
  '1': 'EntityServiceAddNoteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'entity_id', '3': 3, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `EntityServiceAddNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceAddNoteRequestDescriptor = $convert.base64Decode(
    'ChtFbnRpdHlTZXJ2aWNlQWRkTm90ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQY'
    'AiABKAlSC3dvcmtzcGFjZUlkEhsKCWVudGl0eV9pZBgDIAEoCVIIZW50aXR5SWQSEgoEbm90ZR'
    'gEIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use entityServiceAddNoteResponseDescriptor instead')
const EntityServiceAddNoteResponse$json = {
  '1': 'EntityServiceAddNoteResponse',
  '2': [
    {
      '1': 'entity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Entity',
      '10': 'entity'
    },
  ],
};

/// Descriptor for `EntityServiceAddNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceAddNoteResponseDescriptor =
    $convert.base64Decode(
        'ChxFbnRpdHlTZXJ2aWNlQWRkTm90ZVJlc3BvbnNlEjkKBmVudGl0eRgBIAEoCzIhLmNyZWF0aX'
        'ZhbnRhLmVuZ2FnZW1lbnQudjEuRW50aXR5UgZlbnRpdHk=');

@$core.Deprecated('Use entityServiceAddTagRequestDescriptor instead')
const EntityServiceAddTagRequest$json = {
  '1': 'EntityServiceAddTagRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'entity_id', '3': 3, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'tag', '3': 4, '4': 1, '5': 9, '10': 'tag'},
  ],
};

/// Descriptor for `EntityServiceAddTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceAddTagRequestDescriptor = $convert.base64Decode(
    'ChpFbnRpdHlTZXJ2aWNlQWRkVGFnUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgC'
    'IAEoCVILd29ya3NwYWNlSWQSGwoJZW50aXR5X2lkGAMgASgJUghlbnRpdHlJZBIQCgN0YWcYBC'
    'ABKAlSA3RhZw==');

@$core.Deprecated('Use entityServiceAddTagResponseDescriptor instead')
const EntityServiceAddTagResponse$json = {
  '1': 'EntityServiceAddTagResponse',
  '2': [
    {
      '1': 'entity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.Entity',
      '10': 'entity'
    },
  ],
};

/// Descriptor for `EntityServiceAddTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityServiceAddTagResponseDescriptor =
    $convert.base64Decode(
        'ChtFbnRpdHlTZXJ2aWNlQWRkVGFnUmVzcG9uc2USOQoGZW50aXR5GAEgASgLMiEuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5FbnRpdHlSBmVudGl0eQ==');

@$core.Deprecated('Use suggestionServiceGetReplyRequestDescriptor instead')
const SuggestionServiceGetReplyRequest$json = {
  '1': 'SuggestionServiceGetReplyRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
    {'1': 'tone', '3': 3, '4': 1, '5': 9, '10': 'tone'},
  ],
};

/// Descriptor for `SuggestionServiceGetReplyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestionServiceGetReplyRequestDescriptor =
    $convert.base64Decode(
        'CiBTdWdnZXN0aW9uU2VydmljZUdldFJlcGx5UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEhsKCXRocmVhZF9pZBgCIAEoCVIIdGhyZWFkSWQSEgoEdG9uZRgDIAEo'
        'CVIEdG9uZQ==');

@$core.Deprecated('Use suggestionServiceGetReplyResponseDescriptor instead')
const SuggestionServiceGetReplyResponse$json = {
  '1': 'SuggestionServiceGetReplyResponse',
  '2': [
    {
      '1': 'suggestions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.SuggestedReply',
      '10': 'suggestions'
    },
  ],
};

/// Descriptor for `SuggestionServiceGetReplyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestionServiceGetReplyResponseDescriptor =
    $convert.base64Decode(
        'CiFTdWdnZXN0aW9uU2VydmljZUdldFJlcGx5UmVzcG9uc2USSwoLc3VnZ2VzdGlvbnMYASADKA'
        'syKS5jcmVhdGl2YW50YS5lbmdhZ2VtZW50LnYxLlN1Z2dlc3RlZFJlcGx5UgtzdWdnZXN0aW9u'
        'cw==');

@$core.Deprecated('Use suggestionServiceGetActionsRequestDescriptor instead')
const SuggestionServiceGetActionsRequest$json = {
  '1': 'SuggestionServiceGetActionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'thread_id', '3': 2, '4': 1, '5': 9, '10': 'threadId'},
  ],
};

/// Descriptor for `SuggestionServiceGetActionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestionServiceGetActionsRequestDescriptor =
    $convert.base64Decode(
        'CiJTdWdnZXN0aW9uU2VydmljZUdldEFjdGlvbnNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSGwoJdGhyZWFkX2lkGAIgASgJUgh0aHJlYWRJZA==');

@$core.Deprecated('Use suggestionServiceGetActionsResponseDescriptor instead')
const SuggestionServiceGetActionsResponse$json = {
  '1': 'SuggestionServiceGetActionsResponse',
  '2': [
    {
      '1': 'actions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.SuggestedAction',
      '10': 'actions'
    },
  ],
};

/// Descriptor for `SuggestionServiceGetActionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestionServiceGetActionsResponseDescriptor =
    $convert.base64Decode(
        'CiNTdWdnZXN0aW9uU2VydmljZUdldEFjdGlvbnNSZXNwb25zZRJECgdhY3Rpb25zGAEgAygLMi'
        'ouY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5TdWdnZXN0ZWRBY3Rpb25SB2FjdGlvbnM=');

@$core.Deprecated('Use followUpServiceCreateRequestDescriptor instead')
const FollowUpServiceCreateRequest$json = {
  '1': 'FollowUpServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'source_thread_id', '3': 3, '4': 1, '5': 9, '10': 'sourceThreadId'},
    {'1': 'task_type', '3': 4, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'due_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {'1': 'assigned_user_id', '3': 8, '4': 1, '5': 9, '10': 'assignedUserId'},
  ],
};

/// Descriptor for `FollowUpServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChxGb2xsb3dVcFNlcnZpY2VDcmVhdGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNlX2lk'
    'GAIgASgJUgt3b3Jrc3BhY2VJZBIoChBzb3VyY2VfdGhyZWFkX2lkGAMgASgJUg5zb3VyY2VUaH'
    'JlYWRJZBIbCgl0YXNrX3R5cGUYBCABKAlSCHRhc2tUeXBlEhQKBXRpdGxlGAUgASgJUgV0aXRs'
    'ZRIgCgtkZXNjcmlwdGlvbhgGIAEoCVILZGVzY3JpcHRpb24SMQoGZHVlX2F0GAcgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIFZHVlQXQSKAoQYXNzaWduZWRfdXNlcl9pZBgIIAEo'
    'CVIOYXNzaWduZWRVc2VySWQ=');

@$core.Deprecated('Use followUpServiceCreateResponseDescriptor instead')
const FollowUpServiceCreateResponse$json = {
  '1': 'FollowUpServiceCreateResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.FollowUpTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `FollowUpServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch1Gb2xsb3dVcFNlcnZpY2VDcmVhdGVSZXNwb25zZRI7CgR0YXNrGAEgASgLMicuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5Gb2xsb3dVcFRhc2tSBHRhc2s=');

@$core.Deprecated('Use followUpServiceListRequestDescriptor instead')
const FollowUpServiceListRequest$json = {
  '1': 'FollowUpServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'assigned_user_id', '3': 2, '4': 1, '5': 9, '10': 'assignedUserId'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.FollowUpTaskStatus',
      '10': 'status'
    },
    {
      '1': 'pagination',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `FollowUpServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceListRequestDescriptor = $convert.base64Decode(
    'ChpGb2xsb3dVcFNlcnZpY2VMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEigKEGFzc2lnbmVkX3VzZXJfaWQYAiABKAlSDmFzc2lnbmVkVXNlcklkEkUKBnN0'
    'YXR1cxgDIAEoDjItLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuRm9sbG93VXBUYXNrU3RhdH'
    'VzUgZzdGF0dXMSQQoKcGFnaW5hdGlvbhgEIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Q'
    'YWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use followUpServiceListResponseDescriptor instead')
const FollowUpServiceListResponse$json = {
  '1': 'FollowUpServiceListResponse',
  '2': [
    {
      '1': 'tasks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.engagement.v1.FollowUpTask',
      '10': 'tasks'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `FollowUpServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceListResponseDescriptor = $convert.base64Decode(
    'ChtGb2xsb3dVcFNlcnZpY2VMaXN0UmVzcG9uc2USPQoFdGFza3MYASADKAsyJy5jcmVhdGl2YW'
    '50YS5lbmdhZ2VtZW50LnYxLkZvbGxvd1VwVGFza1IFdGFza3MSSAoKcGFnaW5hdGlvbhgCIAEo'
    'CzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcGFnaW5hdGlvbg'
    '==');

@$core.Deprecated('Use followUpServiceUpdateRequestDescriptor instead')
const FollowUpServiceUpdateRequest$json = {
  '1': 'FollowUpServiceUpdateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'task_id', '3': 3, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.engagement.v1.FollowUpTaskStatus',
      '10': 'status'
    },
    {'1': 'outcome_summary', '3': 5, '4': 1, '5': 9, '10': 'outcomeSummary'},
  ],
};

/// Descriptor for `FollowUpServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChxGb2xsb3dVcFNlcnZpY2VVcGRhdGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNlX2lk'
    'GAIgASgJUgt3b3Jrc3BhY2VJZBIXCgd0YXNrX2lkGAMgASgJUgZ0YXNrSWQSRQoGc3RhdHVzGA'
    'QgASgOMi0uY3JlYXRpdmFudGEuZW5nYWdlbWVudC52MS5Gb2xsb3dVcFRhc2tTdGF0dXNSBnN0'
    'YXR1cxInCg9vdXRjb21lX3N1bW1hcnkYBSABKAlSDm91dGNvbWVTdW1tYXJ5');

@$core.Deprecated('Use followUpServiceUpdateResponseDescriptor instead')
const FollowUpServiceUpdateResponse$json = {
  '1': 'FollowUpServiceUpdateResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.FollowUpTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `FollowUpServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'Ch1Gb2xsb3dVcFNlcnZpY2VVcGRhdGVSZXNwb25zZRI7CgR0YXNrGAEgASgLMicuY3JlYXRpdm'
        'FudGEuZW5nYWdlbWVudC52MS5Gb2xsb3dVcFRhc2tSBHRhc2s=');

@$core.Deprecated('Use followUpServiceCompleteRequestDescriptor instead')
const FollowUpServiceCompleteRequest$json = {
  '1': 'FollowUpServiceCompleteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'task_id', '3': 3, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'outcome_summary', '3': 4, '4': 1, '5': 9, '10': 'outcomeSummary'},
  ],
};

/// Descriptor for `FollowUpServiceCompleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceCompleteRequestDescriptor =
    $convert.base64Decode(
        'Ch5Gb2xsb3dVcFNlcnZpY2VDb21wbGV0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
        'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2Vf'
        'aWQYAiABKAlSC3dvcmtzcGFjZUlkEhcKB3Rhc2tfaWQYAyABKAlSBnRhc2tJZBInCg9vdXRjb2'
        '1lX3N1bW1hcnkYBCABKAlSDm91dGNvbWVTdW1tYXJ5');

@$core.Deprecated('Use followUpServiceCompleteResponseDescriptor instead')
const FollowUpServiceCompleteResponse$json = {
  '1': 'FollowUpServiceCompleteResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.FollowUpTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `FollowUpServiceCompleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceCompleteResponseDescriptor =
    $convert.base64Decode(
        'Ch9Gb2xsb3dVcFNlcnZpY2VDb21wbGV0ZVJlc3BvbnNlEjsKBHRhc2sYASABKAsyJy5jcmVhdG'
        'l2YW50YS5lbmdhZ2VtZW50LnYxLkZvbGxvd1VwVGFza1IEdGFzaw==');

@$core.Deprecated('Use followUpServiceRescheduleRequestDescriptor instead')
const FollowUpServiceRescheduleRequest$json = {
  '1': 'FollowUpServiceRescheduleRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'task_id', '3': 3, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'new_due_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'newDueAt'
    },
  ],
};

/// Descriptor for `FollowUpServiceRescheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceRescheduleRequestDescriptor =
    $convert.base64Decode(
        'CiBGb2xsb3dVcFNlcnZpY2VSZXNjaGVkdWxlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFj'
        'ZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSFwoHdGFza19pZBgDIAEoCVIGdGFza0lkEjgKCm5ld1'
        '9kdWVfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghuZXdEdWVBdA==');

@$core.Deprecated('Use followUpServiceRescheduleResponseDescriptor instead')
const FollowUpServiceRescheduleResponse$json = {
  '1': 'FollowUpServiceRescheduleResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.FollowUpTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `FollowUpServiceRescheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followUpServiceRescheduleResponseDescriptor =
    $convert.base64Decode(
        'CiFGb2xsb3dVcFNlcnZpY2VSZXNjaGVkdWxlUmVzcG9uc2USOwoEdGFzaxgBIAEoCzInLmNyZW'
        'F0aXZhbnRhLmVuZ2FnZW1lbnQudjEuRm9sbG93VXBUYXNrUgR0YXNr');

@$core.Deprecated(
    'Use engagementProtectionServiceGetThrottleStatusRequestDescriptor instead')
const EngagementProtectionServiceGetThrottleStatusRequest$json = {
  '1': 'EngagementProtectionServiceGetThrottleStatusRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `EngagementProtectionServiceGetThrottleStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    engagementProtectionServiceGetThrottleStatusRequestDescriptor =
    $convert.base64Decode(
        'CjNFbmdhZ2VtZW50UHJvdGVjdGlvblNlcnZpY2VHZXRUaHJvdHRsZVN0YXR1c1JlcXVlc3QSIQ'
        'oMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated(
    'Use engagementProtectionServiceGetThrottleStatusResponseDescriptor instead')
const EngagementProtectionServiceGetThrottleStatusResponse$json = {
  '1': 'EngagementProtectionServiceGetThrottleStatusResponse',
  '2': [
    {
      '1': 'throttle_status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.EngagementThrottleStatus',
      '10': 'throttleStatus'
    },
  ],
};

/// Descriptor for `EngagementProtectionServiceGetThrottleStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    engagementProtectionServiceGetThrottleStatusResponseDescriptor =
    $convert.base64Decode(
        'CjRFbmdhZ2VtZW50UHJvdGVjdGlvblNlcnZpY2VHZXRUaHJvdHRsZVN0YXR1c1Jlc3BvbnNlEl'
        'wKD3Rocm90dGxlX3N0YXR1cxgBIAEoCzIzLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuRW5n'
        'YWdlbWVudFRocm90dGxlU3RhdHVzUg50aHJvdHRsZVN0YXR1cw==');

@$core.Deprecated(
    'Use engagementProtectionServiceTriggerBatchAnalysisRequestDescriptor instead')
const EngagementProtectionServiceTriggerBatchAnalysisRequest$json = {
  '1': 'EngagementProtectionServiceTriggerBatchAnalysisRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'max_batch_size', '3': 3, '4': 1, '5': 5, '10': 'maxBatchSize'},
  ],
};

/// Descriptor for `EngagementProtectionServiceTriggerBatchAnalysisRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    engagementProtectionServiceTriggerBatchAnalysisRequestDescriptor =
    $convert.base64Decode(
        'CjZFbmdhZ2VtZW50UHJvdGVjdGlvblNlcnZpY2VUcmlnZ2VyQmF0Y2hBbmFseXNpc1JlcXVlc3'
        'QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4'
        'dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEiQKDm1heF9iYX'
        'RjaF9zaXplGAMgASgFUgxtYXhCYXRjaFNpemU=');

@$core.Deprecated(
    'Use engagementProtectionServiceTriggerBatchAnalysisResponseDescriptor instead')
const EngagementProtectionServiceTriggerBatchAnalysisResponse$json = {
  '1': 'EngagementProtectionServiceTriggerBatchAnalysisResponse',
  '2': [
    {'1': 'analyzed_count', '3': 1, '4': 1, '5': 5, '10': 'analyzedCount'},
    {
      '1': 'throttle_status',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.engagement.v1.EngagementThrottleStatus',
      '10': 'throttleStatus'
    },
  ],
};

/// Descriptor for `EngagementProtectionServiceTriggerBatchAnalysisResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    engagementProtectionServiceTriggerBatchAnalysisResponseDescriptor =
    $convert.base64Decode(
        'CjdFbmdhZ2VtZW50UHJvdGVjdGlvblNlcnZpY2VUcmlnZ2VyQmF0Y2hBbmFseXNpc1Jlc3Bvbn'
        'NlEiUKDmFuYWx5emVkX2NvdW50GAEgASgFUg1hbmFseXplZENvdW50ElwKD3Rocm90dGxlX3N0'
        'YXR1cxgCIAEoCzIzLmNyZWF0aXZhbnRhLmVuZ2FnZW1lbnQudjEuRW5nYWdlbWVudFRocm90dG'
        'xlU3RhdHVzUg50aHJvdHRsZVN0YXR1cw==');

@$core.Deprecated(
    'Use engagementProtectionServiceRepairRevokedAccountRequestDescriptor instead')
const EngagementProtectionServiceRepairRevokedAccountRequest$json = {
  '1': 'EngagementProtectionServiceRepairRevokedAccountRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'connected_account_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {'1': 'new_access_token', '3': 4, '4': 1, '5': 9, '10': 'newAccessToken'},
  ],
};

/// Descriptor for `EngagementProtectionServiceRepairRevokedAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    engagementProtectionServiceRepairRevokedAccountRequestDescriptor =
    $convert.base64Decode(
        'CjZFbmdhZ2VtZW50UHJvdGVjdGlvblNlcnZpY2VSZXBhaXJSZXZva2VkQWNjb3VudFJlcXVlc3'
        'QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4'
        'dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEjAKFGNvbm5lY3'
        'RlZF9hY2NvdW50X2lkGAMgASgJUhJjb25uZWN0ZWRBY2NvdW50SWQSKAoQbmV3X2FjY2Vzc190'
        'b2tlbhgEIAEoCVIObmV3QWNjZXNzVG9rZW4=');

@$core.Deprecated(
    'Use engagementProtectionServiceRepairRevokedAccountResponseDescriptor instead')
const EngagementProtectionServiceRepairRevokedAccountResponse$json = {
  '1': 'EngagementProtectionServiceRepairRevokedAccountResponse',
  '2': [
    {'1': 'repaired', '3': 1, '4': 1, '5': 8, '10': 'repaired'},
    {
      '1': 'connected_account_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {
      '1': 'unblocked_threads_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'unblockedThreadsCount'
    },
  ],
};

/// Descriptor for `EngagementProtectionServiceRepairRevokedAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    engagementProtectionServiceRepairRevokedAccountResponseDescriptor =
    $convert.base64Decode(
        'CjdFbmdhZ2VtZW50UHJvdGVjdGlvblNlcnZpY2VSZXBhaXJSZXZva2VkQWNjb3VudFJlc3Bvbn'
        'NlEhoKCHJlcGFpcmVkGAEgASgIUghyZXBhaXJlZBIwChRjb25uZWN0ZWRfYWNjb3VudF9pZBgC'
        'IAEoCVISY29ubmVjdGVkQWNjb3VudElkEjYKF3VuYmxvY2tlZF90aHJlYWRzX2NvdW50GAMgAS'
        'gFUhV1bmJsb2NrZWRUaHJlYWRzQ291bnQ=');

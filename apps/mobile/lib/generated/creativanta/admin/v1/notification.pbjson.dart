// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/notification.proto.

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

@$core.Deprecated('Use notificationPriorityDescriptor instead')
const NotificationPriority$json = {
  '1': 'NotificationPriority',
  '2': [
    {'1': 'NOTIFICATION_PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'NOTIFICATION_PRIORITY_LOW', '2': 1},
    {'1': 'NOTIFICATION_PRIORITY_NORMAL', '2': 2},
    {'1': 'NOTIFICATION_PRIORITY_HIGH', '2': 3},
    {'1': 'NOTIFICATION_PRIORITY_URGENT', '2': 4},
  ],
};

/// Descriptor for `NotificationPriority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationPriorityDescriptor = $convert.base64Decode(
    'ChROb3RpZmljYXRpb25Qcmlvcml0eRIlCiFOT1RJRklDQVRJT05fUFJJT1JJVFlfVU5TUEVDSU'
    'ZJRUQQABIdChlOT1RJRklDQVRJT05fUFJJT1JJVFlfTE9XEAESIAocTk9USUZJQ0FUSU9OX1BS'
    'SU9SSVRZX05PUk1BTBACEh4KGk5PVElGSUNBVElPTl9QUklPUklUWV9ISUdIEAMSIAocTk9USU'
    'ZJQ0FUSU9OX1BSSU9SSVRZX1VSR0VOVBAE');

@$core.Deprecated('Use notificationChannelDescriptor instead')
const NotificationChannel$json = {
  '1': 'NotificationChannel',
  '2': [
    {'1': 'NOTIFICATION_CHANNEL_UNSPECIFIED', '2': 0},
    {'1': 'NOTIFICATION_CHANNEL_IN_APP', '2': 1},
    {'1': 'NOTIFICATION_CHANNEL_PUSH', '2': 2},
    {'1': 'NOTIFICATION_CHANNEL_EMAIL', '2': 3},
  ],
};

/// Descriptor for `NotificationChannel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationChannelDescriptor = $convert.base64Decode(
    'ChNOb3RpZmljYXRpb25DaGFubmVsEiQKIE5PVElGSUNBVElPTl9DSEFOTkVMX1VOU1BFQ0lGSU'
    'VEEAASHwobTk9USUZJQ0FUSU9OX0NIQU5ORUxfSU5fQVBQEAESHQoZTk9USUZJQ0FUSU9OX0NI'
    'QU5ORUxfUFVTSBACEh4KGk5PVElGSUNBVElPTl9DSEFOTkVMX0VNQUlMEAM=');

@$core.Deprecated('Use notificationItemDescriptor instead')
const NotificationItem$json = {
  '1': 'NotificationItem',
  '2': [
    {
      '1': 'notification_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'notificationId'
    },
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
    {
      '1': 'priority',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.NotificationPriority',
      '10': 'priority'
    },
    {
      '1': 'channel',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.NotificationChannel',
      '10': 'channel'
    },
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'body', '3': 7, '4': 1, '5': 9, '10': 'body'},
    {'1': 'deep_link', '3': 8, '4': 1, '5': 9, '10': 'deepLink'},
    {
      '1': 'action_buttons_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'actionButtonsJson'
    },
    {'1': 'grouped_key', '3': 10, '4': 1, '5': 9, '10': 'groupedKey'},
    {
      '1': 'read_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'readAt',
      '17': true
    },
    {
      '1': 'dismissed_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 1,
      '10': 'dismissedAt',
      '17': true
    },
    {
      '1': 'delivered_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 2,
      '10': 'deliveredAt',
      '17': true
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
  '8': [
    {'1': '_read_at'},
    {'1': '_dismissed_at'},
    {'1': '_delivered_at'},
  ],
};

/// Descriptor for `NotificationItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationItemDescriptor = $convert.base64Decode(
    'ChBOb3RpZmljYXRpb25JdGVtEkQKD25vdGlmaWNhdGlvbl9pZBgBIAEoCzIbLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5VVUlEUg5ub3RpZmljYXRpb25JZBI+Cgx3b3Jrc3BhY2VfaWQYAiABKAsy'
    'Gy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSNAoHdXNlcl9pZBgDIA'
    'EoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgZ1c2VySWQSRgoIcHJpb3JpdHkYBCAB'
    'KA4yKi5jcmVhdGl2YW50YS5hZG1pbi52MS5Ob3RpZmljYXRpb25Qcmlvcml0eVIIcHJpb3JpdH'
    'kSQwoHY2hhbm5lbBgFIAEoDjIpLmNyZWF0aXZhbnRhLmFkbWluLnYxLk5vdGlmaWNhdGlvbkNo'
    'YW5uZWxSB2NoYW5uZWwSFAoFdGl0bGUYBiABKAlSBXRpdGxlEhIKBGJvZHkYByABKAlSBGJvZH'
    'kSGwoJZGVlcF9saW5rGAggASgJUghkZWVwTGluaxIuChNhY3Rpb25fYnV0dG9uc19qc29uGAkg'
    'ASgJUhFhY3Rpb25CdXR0b25zSnNvbhIfCgtncm91cGVkX2tleRgKIAEoCVIKZ3JvdXBlZEtleR'
    'I4CgdyZWFkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEgAUgZyZWFkQXSI'
    'AQESQgoMZGlzbWlzc2VkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEgBUg'
    'tkaXNtaXNzZWRBdIgBARJCCgxkZWxpdmVyZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wSAJSC2RlbGl2ZXJlZEF0iAEBEjkKCmNyZWF0ZWRfYXQYDiABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXRCCgoIX3JlYWRfYXRCDwoNX2Rpc21pc3Nl'
    'ZF9hdEIPCg1fZGVsaXZlcmVkX2F0');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
    {'1': 'unread_only', '3': 3, '4': 1, '5': 8, '10': 'unreadOnly'},
    {
      '1': 'min_priority',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.NotificationPriority',
      '10': 'minPriority'
    },
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

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW50YS5jb21tb2'
    '4udjEuVVVJRFILd29ya3NwYWNlSWQSNAoHdXNlcl9pZBgCIAEoCzIbLmNyZWF0aXZhbnRhLmNv'
    'bW1vbi52MS5VVUlEUgZ1c2VySWQSHwoLdW5yZWFkX29ubHkYAyABKAhSCnVucmVhZE9ubHkSTQ'
    'oMbWluX3ByaW9yaXR5GAQgASgOMiouY3JlYXRpdmFudGEuYWRtaW4udjEuTm90aWZpY2F0aW9u'
    'UHJpb3JpdHlSC21pblByaW9yaXR5EkEKCnBhZ2luYXRpb24YBSABKAsyIS5jcmVhdGl2YW50YS'
    '5jb21tb24udjEuUGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'notifications',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.NotificationItem',
      '10': 'notifications'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
    {'1': 'unread_count', '3': 3, '4': 1, '5': 5, '10': 'unreadCount'},
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USTAoNbm90aWZpY2F0aW9ucxgBIAMoCzImLmNyZWF0aXZhbnRhLmFkbW'
    'luLnYxLk5vdGlmaWNhdGlvbkl0ZW1SDW5vdGlmaWNhdGlvbnMSSAoKcGFnaW5hdGlvbhgCIAEo'
    'CzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcGFnaW5hdGlvbh'
    'IhCgx1bnJlYWRfY291bnQYAyABKAVSC3VucmVhZENvdW50');

@$core.Deprecated('Use markReadRequestDescriptor instead')
const MarkReadRequest$json = {
  '1': 'MarkReadRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
    {
      '1': 'notification_id',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'notificationId'
    },
  ],
};

/// Descriptor for `MarkReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markReadRequestDescriptor = $convert.base64Decode(
    'Cg9NYXJrUmVhZFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdmFudGEuY2'
    '9tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEjQKB3VzZXJfaWQYAiABKAsyGy5jcmVhdGl2YW50'
    'YS5jb21tb24udjEuVVVJRFIGdXNlcklkEkQKD25vdGlmaWNhdGlvbl9pZBgDIAEoCzIbLmNyZW'
    'F0aXZhbnRhLmNvbW1vbi52MS5VVUlEUg5ub3RpZmljYXRpb25JZA==');

@$core.Deprecated('Use markReadResponseDescriptor instead')
const MarkReadResponse$json = {
  '1': 'MarkReadResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'read_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readAt'
    },
  ],
};

/// Descriptor for `MarkReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markReadResponseDescriptor = $convert.base64Decode(
    'ChBNYXJrUmVhZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSMwoHcmVhZF9hdB'
    'gCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBnJlYWRBdA==');

@$core.Deprecated('Use markAllReadRequestDescriptor instead')
const MarkAllReadRequest$json = {
  '1': 'MarkAllReadRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
  ],
};

/// Descriptor for `MarkAllReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAllReadRequestDescriptor = $convert.base64Decode(
    'ChJNYXJrQWxsUmVhZFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEjQKB3VzZXJfaWQYAiABKAsyGy5jcmVhdGl2'
    'YW50YS5jb21tb24udjEuVVVJRFIGdXNlcklk');

@$core.Deprecated('Use markAllReadResponseDescriptor instead')
const MarkAllReadResponse$json = {
  '1': 'MarkAllReadResponse',
  '2': [
    {'1': 'count_marked_read', '3': 1, '4': 1, '5': 5, '10': 'countMarkedRead'},
    {
      '1': 'read_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readAt'
    },
  ],
};

/// Descriptor for `MarkAllReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAllReadResponseDescriptor = $convert.base64Decode(
    'ChNNYXJrQWxsUmVhZFJlc3BvbnNlEioKEWNvdW50X21hcmtlZF9yZWFkGAEgASgFUg9jb3VudE'
    '1hcmtlZFJlYWQSMwoHcmVhZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'BnJlYWRBdA==');

@$core.Deprecated('Use dismissRequestDescriptor instead')
const DismissRequest$json = {
  '1': 'DismissRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
    {
      '1': 'notification_id',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'notificationId'
    },
  ],
};

/// Descriptor for `DismissRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissRequestDescriptor = $convert.base64Decode(
    'Cg5EaXNtaXNzUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuVVVJRFILd29ya3NwYWNlSWQSNAoHdXNlcl9pZBgCIAEoCzIbLmNyZWF0aXZhbnRh'
    'LmNvbW1vbi52MS5VVUlEUgZ1c2VySWQSRAoPbm90aWZpY2F0aW9uX2lkGAMgASgLMhsuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLlVVSURSDm5vdGlmaWNhdGlvbklk');

@$core.Deprecated('Use dismissResponseDescriptor instead')
const DismissResponse$json = {
  '1': 'DismissResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'dismissed_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dismissedAt'
    },
  ],
};

/// Descriptor for `DismissResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissResponseDescriptor = $convert.base64Decode(
    'Cg9EaXNtaXNzUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxI9CgxkaXNtaXNzZW'
    'RfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtkaXNtaXNzZWRBdA==');

@$core.Deprecated('Use getUnreadCountRequestDescriptor instead')
const GetUnreadCountRequest$json = {
  '1': 'GetUnreadCountRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
  ],
};

/// Descriptor for `GetUnreadCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnreadCountRequestDescriptor = $convert.base64Decode(
    'ChVHZXRVbnJlYWRDb3VudFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEjQKB3VzZXJfaWQYAiABKAsyGy5jcmVh'
    'dGl2YW50YS5jb21tb24udjEuVVVJRFIGdXNlcklk');

@$core.Deprecated('Use getUnreadCountResponseDescriptor instead')
const GetUnreadCountResponse$json = {
  '1': 'GetUnreadCountResponse',
  '2': [
    {'1': 'unread_count', '3': 1, '4': 1, '5': 5, '10': 'unreadCount'},
    {'1': 'urgent_count', '3': 2, '4': 1, '5': 5, '10': 'urgentCount'},
  ],
};

/// Descriptor for `GetUnreadCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnreadCountResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRVbnJlYWRDb3VudFJlc3BvbnNlEiEKDHVucmVhZF9jb3VudBgBIAEoBVILdW5yZWFkQ2'
        '91bnQSIQoMdXJnZW50X2NvdW50GAIgASgFUgt1cmdlbnRDb3VudA==');

@$core.Deprecated('Use notificationPreferencesDescriptor instead')
const NotificationPreferences$json = {
  '1': 'NotificationPreferences',
  '2': [
    {'1': 'email_enabled', '3': 1, '4': 1, '5': 8, '10': 'emailEnabled'},
    {'1': 'push_enabled', '3': 2, '4': 1, '5': 8, '10': 'pushEnabled'},
    {'1': 'in_app_enabled', '3': 3, '4': 1, '5': 8, '10': 'inAppEnabled'},
    {
      '1': 'quiet_hours_enabled',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'quietHoursEnabled'
    },
    {'1': 'quiet_hours_start', '3': 5, '4': 1, '5': 9, '10': 'quietHoursStart'},
    {'1': 'quiet_hours_end', '3': 6, '4': 1, '5': 9, '10': 'quietHoursEnd'},
    {'1': 'digest_frequency', '3': 7, '4': 1, '5': 9, '10': 'digestFrequency'},
  ],
};

/// Descriptor for `NotificationPreferences`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationPreferencesDescriptor = $convert.base64Decode(
    'ChdOb3RpZmljYXRpb25QcmVmZXJlbmNlcxIjCg1lbWFpbF9lbmFibGVkGAEgASgIUgxlbWFpbE'
    'VuYWJsZWQSIQoMcHVzaF9lbmFibGVkGAIgASgIUgtwdXNoRW5hYmxlZBIkCg5pbl9hcHBfZW5h'
    'YmxlZBgDIAEoCFIMaW5BcHBFbmFibGVkEi4KE3F1aWV0X2hvdXJzX2VuYWJsZWQYBCABKAhSEX'
    'F1aWV0SG91cnNFbmFibGVkEioKEXF1aWV0X2hvdXJzX3N0YXJ0GAUgASgJUg9xdWlldEhvdXJz'
    'U3RhcnQSJgoPcXVpZXRfaG91cnNfZW5kGAYgASgJUg1xdWlldEhvdXJzRW5kEikKEGRpZ2VzdF'
    '9mcmVxdWVuY3kYByABKAlSD2RpZ2VzdEZyZXF1ZW5jeQ==');

@$core.Deprecated('Use getPreferencesRequestDescriptor instead')
const GetPreferencesRequest$json = {
  '1': 'GetPreferencesRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
  ],
};

/// Descriptor for `GetPreferencesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPreferencesRequestDescriptor = $convert.base64Decode(
    'ChVHZXRQcmVmZXJlbmNlc1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEjQKB3VzZXJfaWQYAiABKAsyGy5jcmVh'
    'dGl2YW50YS5jb21tb24udjEuVVVJRFIGdXNlcklk');

@$core.Deprecated('Use getPreferencesResponseDescriptor instead')
const GetPreferencesResponse$json = {
  '1': 'GetPreferencesResponse',
  '2': [
    {
      '1': 'preferences',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.NotificationPreferences',
      '10': 'preferences'
    },
  ],
};

/// Descriptor for `GetPreferencesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPreferencesResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRQcmVmZXJlbmNlc1Jlc3BvbnNlEk8KC3ByZWZlcmVuY2VzGAEgASgLMi0uY3JlYXRpdm'
        'FudGEuYWRtaW4udjEuTm90aWZpY2F0aW9uUHJlZmVyZW5jZXNSC3ByZWZlcmVuY2Vz');

@$core.Deprecated('Use updatePreferencesRequestDescriptor instead')
const UpdatePreferencesRequest$json = {
  '1': 'UpdatePreferencesRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
    {
      '1': 'preferences',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.NotificationPreferences',
      '10': 'preferences'
    },
  ],
};

/// Descriptor for `UpdatePreferencesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePreferencesRequestDescriptor = $convert.base64Decode(
    'ChhVcGRhdGVQcmVmZXJlbmNlc1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEjQKB3VzZXJfaWQYAiABKAsyGy5j'
    'cmVhdGl2YW50YS5jb21tb24udjEuVVVJRFIGdXNlcklkEk8KC3ByZWZlcmVuY2VzGAMgASgLMi'
    '0uY3JlYXRpdmFudGEuYWRtaW4udjEuTm90aWZpY2F0aW9uUHJlZmVyZW5jZXNSC3ByZWZlcmVu'
    'Y2Vz');

@$core.Deprecated('Use updatePreferencesResponseDescriptor instead')
const UpdatePreferencesResponse$json = {
  '1': 'UpdatePreferencesResponse',
  '2': [
    {
      '1': 'preferences',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.NotificationPreferences',
      '10': 'preferences'
    },
    {
      '1': 'updated_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `UpdatePreferencesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePreferencesResponseDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVQcmVmZXJlbmNlc1Jlc3BvbnNlEk8KC3ByZWZlcmVuY2VzGAEgASgLMi0uY3JlYX'
    'RpdmFudGEuYWRtaW4udjEuTm90aWZpY2F0aW9uUHJlZmVyZW5jZXNSC3ByZWZlcmVuY2VzEjkK'
    'CnVwZGF0ZWRfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQX'
    'Q=');

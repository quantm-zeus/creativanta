// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/dashboard.proto.

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

@$core.Deprecated('Use operatorModeIdDescriptor instead')
const OperatorModeId$json = {
  '1': 'OperatorModeId',
  '2': [
    {'1': 'OPERATOR_MODE_ID_UNSPECIFIED', '2': 0},
    {'1': 'OPERATOR_MODE_ID_CREATOR', '2': 1},
    {'1': 'OPERATOR_MODE_ID_SELLER', '2': 2},
    {'1': 'OPERATOR_MODE_ID_AFFILIATE_OPERATOR', '2': 3},
    {'1': 'OPERATOR_MODE_ID_LIVE_OPERATOR', '2': 4},
    {'1': 'OPERATOR_MODE_ID_AGENCY_MCN', '2': 5},
    {'1': 'OPERATOR_MODE_ID_BRAND_COLLABORATION', '2': 6},
  ],
};

/// Descriptor for `OperatorModeId`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List operatorModeIdDescriptor = $convert.base64Decode(
    'Cg5PcGVyYXRvck1vZGVJZBIgChxPUEVSQVRPUl9NT0RFX0lEX1VOU1BFQ0lGSUVEEAASHAoYT1'
    'BFUkFUT1JfTU9ERV9JRF9DUkVBVE9SEAESGwoXT1BFUkFUT1JfTU9ERV9JRF9TRUxMRVIQAhIn'
    'CiNPUEVSQVRPUl9NT0RFX0lEX0FGRklMSUFURV9PUEVSQVRPUhADEiIKHk9QRVJBVE9SX01PRE'
    'VfSURfTElWRV9PUEVSQVRPUhAEEh8KG09QRVJBVE9SX01PREVfSURfQUdFTkNZX01DThAFEigK'
    'JE9QRVJBVE9SX01PREVfSURfQlJBTkRfQ09MTEFCT1JBVElPThAG');

@$core.Deprecated('Use dataSourceBadgeDescriptor instead')
const DataSourceBadge$json = {
  '1': 'DataSourceBadge',
  '2': [
    {'1': 'DATA_SOURCE_BADGE_UNSPECIFIED', '2': 0},
    {'1': 'DATA_SOURCE_BADGE_OFFICIAL', '2': 1},
    {'1': 'DATA_SOURCE_BADGE_IMPORTED', '2': 2},
    {'1': 'DATA_SOURCE_BADGE_INFERRED', '2': 3},
    {'1': 'DATA_SOURCE_BADGE_DEMO', '2': 4},
  ],
};

/// Descriptor for `DataSourceBadge`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dataSourceBadgeDescriptor = $convert.base64Decode(
    'Cg9EYXRhU291cmNlQmFkZ2USIQodREFUQV9TT1VSQ0VfQkFER0VfVU5TUEVDSUZJRUQQABIeCh'
    'pEQVRBX1NPVVJDRV9CQURHRV9PRkZJQ0lBTBABEh4KGkRBVEFfU09VUkNFX0JBREdFX0lNUE9S'
    'VEVEEAISHgoaREFUQV9TT1VSQ0VfQkFER0VfSU5GRVJSRUQQAxIaChZEQVRBX1NPVVJDRV9CQU'
    'RHRV9ERU1PEAQ=');

@$core.Deprecated('Use confidenceLevelDescriptor instead')
const ConfidenceLevel$json = {
  '1': 'ConfidenceLevel',
  '2': [
    {'1': 'CONFIDENCE_LEVEL_UNSPECIFIED', '2': 0},
    {'1': 'CONFIDENCE_LEVEL_HIGH', '2': 1},
    {'1': 'CONFIDENCE_LEVEL_MEDIUM', '2': 2},
    {'1': 'CONFIDENCE_LEVEL_LOW', '2': 3},
  ],
};

/// Descriptor for `ConfidenceLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List confidenceLevelDescriptor = $convert.base64Decode(
    'Cg9Db25maWRlbmNlTGV2ZWwSIAocQ09ORklERU5DRV9MRVZFTF9VTlNQRUNJRklFRBAAEhkKFU'
    'NPTkZJREVOQ0VfTEVWRUxfSElHSBABEhsKF0NPTkZJREVOQ0VfTEVWRUxfTUVESVVNEAISGAoU'
    'Q09ORklERU5DRV9MRVZFTF9MT1cQAw==');

@$core.Deprecated('Use uIStateTypeDescriptor instead')
const UIStateType$json = {
  '1': 'UIStateType',
  '2': [
    {'1': 'UI_STATE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'UI_STATE_TYPE_NORMAL', '2': 1},
    {'1': 'UI_STATE_TYPE_LOADING', '2': 2},
    {'1': 'UI_STATE_TYPE_EMPTY', '2': 3},
    {'1': 'UI_STATE_TYPE_ERROR', '2': 4},
    {'1': 'UI_STATE_TYPE_REPAIR', '2': 5},
  ],
};

/// Descriptor for `UIStateType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List uIStateTypeDescriptor = $convert.base64Decode(
    'CgtVSVN0YXRlVHlwZRIdChlVSV9TVEFURV9UWVBFX1VOU1BFQ0lGSUVEEAASGAoUVUlfU1RBVE'
    'VfVFlQRV9OT1JNQUwQARIZChVVSV9TVEFURV9UWVBFX0xPQURJTkcQAhIXChNVSV9TVEFURV9U'
    'WVBFX0VNUFRZEAMSFwoTVUlfU1RBVEVfVFlQRV9FUlJPUhAEEhgKFFVJX1NUQVRFX1RZUEVfUk'
    'VQQUlSEAU=');

@$core.Deprecated('Use decisionCardDescriptor instead')
const DecisionCard$json = {
  '1': 'DecisionCard',
  '2': [
    {'1': 'card_id', '3': 1, '4': 1, '5': 9, '10': 'cardId'},
    {'1': 'card_family', '3': 2, '4': 1, '5': 9, '10': 'cardFamily'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'primary_cta_label', '3': 5, '4': 1, '5': 9, '10': 'primaryCtaLabel'},
    {'1': 'primary_cta_route', '3': 6, '4': 1, '5': 9, '10': 'primaryCtaRoute'},
    {
      '1': 'is_action_available',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'isActionAvailable'
    },
    {
      '1': 'unavailable_reason',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'unavailableReason'
    },
    {
      '1': 'data_source',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DataSourceBadge',
      '10': 'dataSource'
    },
    {
      '1': 'confidence',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.ConfidenceLevel',
      '10': 'confidence'
    },
    {'1': 'why_this_matters', '3': 11, '4': 1, '5': 9, '10': 'whyThisMatters'},
    {'1': 'priority_rank', '3': 12, '4': 1, '5': 5, '10': 'priorityRank'},
    {'1': 'module_ref', '3': 13, '4': 1, '5': 9, '10': 'moduleRef'},
    {
      '1': 'state_type',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.UIStateType',
      '10': 'stateType'
    },
    {
      '1': 'repair_instructions',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'repairInstructions'
    },
  ],
};

/// Descriptor for `DecisionCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decisionCardDescriptor = $convert.base64Decode(
    'CgxEZWNpc2lvbkNhcmQSFwoHY2FyZF9pZBgBIAEoCVIGY2FyZElkEh8KC2NhcmRfZmFtaWx5GA'
    'IgASgJUgpjYXJkRmFtaWx5EhQKBXRpdGxlGAMgASgJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgE'
    'IAEoCVILZGVzY3JpcHRpb24SKgoRcHJpbWFyeV9jdGFfbGFiZWwYBSABKAlSD3ByaW1hcnlDdG'
    'FMYWJlbBIqChFwcmltYXJ5X2N0YV9yb3V0ZRgGIAEoCVIPcHJpbWFyeUN0YVJvdXRlEi4KE2lz'
    'X2FjdGlvbl9hdmFpbGFibGUYByABKAhSEWlzQWN0aW9uQXZhaWxhYmxlEi0KEnVuYXZhaWxhYm'
    'xlX3JlYXNvbhgIIAEoCVIRdW5hdmFpbGFibGVSZWFzb24SRgoLZGF0YV9zb3VyY2UYCSABKA4y'
    'JS5jcmVhdGl2YW50YS5hZG1pbi52MS5EYXRhU291cmNlQmFkZ2VSCmRhdGFTb3VyY2USRQoKY2'
    '9uZmlkZW5jZRgKIAEoDjIlLmNyZWF0aXZhbnRhLmFkbWluLnYxLkNvbmZpZGVuY2VMZXZlbFIK'
    'Y29uZmlkZW5jZRIoChB3aHlfdGhpc19tYXR0ZXJzGAsgASgJUg53aHlUaGlzTWF0dGVycxIjCg'
    '1wcmlvcml0eV9yYW5rGAwgASgFUgxwcmlvcml0eVJhbmsSHQoKbW9kdWxlX3JlZhgNIAEoCVIJ'
    'bW9kdWxlUmVmEkAKCnN0YXRlX3R5cGUYDiABKA4yIS5jcmVhdGl2YW50YS5hZG1pbi52MS5VSV'
    'N0YXRlVHlwZVIJc3RhdGVUeXBlEi8KE3JlcGFpcl9pbnN0cnVjdGlvbnMYDyABKAlSEnJlcGFp'
    'ckluc3RydWN0aW9ucw==');

@$core.Deprecated('Use onboardingStepProgressDescriptor instead')
const OnboardingStepProgress$json = {
  '1': 'OnboardingStepProgress',
  '2': [
    {'1': 'step_number', '3': 1, '4': 1, '5': 5, '10': 'stepNumber'},
    {'1': 'step_key', '3': 2, '4': 1, '5': 9, '10': 'stepKey'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'is_completed', '3': 5, '4': 1, '5': 8, '10': 'isCompleted'},
    {'1': 'is_available', '3': 6, '4': 1, '5': 8, '10': 'isAvailable'},
    {
      '1': 'unavailable_reason',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'unavailableReason'
    },
  ],
};

/// Descriptor for `OnboardingStepProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onboardingStepProgressDescriptor = $convert.base64Decode(
    'ChZPbmJvYXJkaW5nU3RlcFByb2dyZXNzEh8KC3N0ZXBfbnVtYmVyGAEgASgFUgpzdGVwTnVtYm'
    'VyEhkKCHN0ZXBfa2V5GAIgASgJUgdzdGVwS2V5EhQKBXRpdGxlGAMgASgJUgV0aXRsZRIgCgtk'
    'ZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SIQoMaXNfY29tcGxldGVkGAUgASgIUgtpc0'
    'NvbXBsZXRlZBIhCgxpc19hdmFpbGFibGUYBiABKAhSC2lzQXZhaWxhYmxlEi0KEnVuYXZhaWxh'
    'YmxlX3JlYXNvbhgHIAEoCVIRdW5hdmFpbGFibGVSZWFzb24=');

@$core.Deprecated('Use onboardingChecklistDescriptor instead')
const OnboardingChecklist$json = {
  '1': 'OnboardingChecklist',
  '2': [
    {
      '1': 'steps',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.OnboardingStepProgress',
      '10': 'steps'
    },
    {'1': 'completed_count', '3': 2, '4': 1, '5': 5, '10': 'completedCount'},
    {'1': 'total_steps', '3': 3, '4': 1, '5': 5, '10': 'totalSteps'},
    {
      '1': 'is_closed_loop_complete',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'isClosedLoopComplete'
    },
  ],
};

/// Descriptor for `OnboardingChecklist`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onboardingChecklistDescriptor = $convert.base64Decode(
    'ChNPbmJvYXJkaW5nQ2hlY2tsaXN0EkIKBXN0ZXBzGAEgAygLMiwuY3JlYXRpdmFudGEuYWRtaW'
    '4udjEuT25ib2FyZGluZ1N0ZXBQcm9ncmVzc1IFc3RlcHMSJwoPY29tcGxldGVkX2NvdW50GAIg'
    'ASgFUg5jb21wbGV0ZWRDb3VudBIfCgt0b3RhbF9zdGVwcxgDIAEoBVIKdG90YWxTdGVwcxI1Ch'
    'dpc19jbG9zZWRfbG9vcF9jb21wbGV0ZRgEIAEoCFIUaXNDbG9zZWRMb29wQ29tcGxldGU=');

@$core.Deprecated('Use whyThisNumberDetailsDescriptor instead')
const WhyThisNumberDetails$json = {
  '1': 'WhyThisNumberDetails',
  '2': [
    {'1': 'metric_key', '3': 1, '4': 1, '5': 9, '10': 'metricKey'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'formatted_value', '3': 3, '4': 1, '5': 9, '10': 'formattedValue'},
    {
      '1': 'data_source',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DataSourceBadge',
      '10': 'dataSource'
    },
    {
      '1': 'confidence',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.ConfidenceLevel',
      '10': 'confidence'
    },
    {
      '1': 'last_synced_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastSyncedAt'
    },
    {'1': 'data_origins', '3': 7, '4': 3, '5': 9, '10': 'dataOrigins'},
    {
      '1': 'missing_data_caveats',
      '3': 8,
      '4': 3,
      '5': 9,
      '10': 'missingDataCaveats'
    },
    {
      '1': 'recommended_next_steps',
      '3': 9,
      '4': 3,
      '5': 9,
      '10': 'recommendedNextSteps'
    },
    {
      '1': 'contains_demo_data',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'containsDemoData'
    },
  ],
};

/// Descriptor for `WhyThisNumberDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List whyThisNumberDetailsDescriptor = $convert.base64Decode(
    'ChRXaHlUaGlzTnVtYmVyRGV0YWlscxIdCgptZXRyaWNfa2V5GAEgASgJUgltZXRyaWNLZXkSIQ'
    'oMZGlzcGxheV9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZRInCg9mb3JtYXR0ZWRfdmFsdWUYAyAB'
    'KAlSDmZvcm1hdHRlZFZhbHVlEkYKC2RhdGFfc291cmNlGAQgASgOMiUuY3JlYXRpdmFudGEuYW'
    'RtaW4udjEuRGF0YVNvdXJjZUJhZGdlUgpkYXRhU291cmNlEkUKCmNvbmZpZGVuY2UYBSABKA4y'
    'JS5jcmVhdGl2YW50YS5hZG1pbi52MS5Db25maWRlbmNlTGV2ZWxSCmNvbmZpZGVuY2USQAoObG'
    'FzdF9zeW5jZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxsYXN0U3lu'
    'Y2VkQXQSIQoMZGF0YV9vcmlnaW5zGAcgAygJUgtkYXRhT3JpZ2lucxIwChRtaXNzaW5nX2RhdG'
    'FfY2F2ZWF0cxgIIAMoCVISbWlzc2luZ0RhdGFDYXZlYXRzEjQKFnJlY29tbWVuZGVkX25leHRf'
    'c3RlcHMYCSADKAlSFHJlY29tbWVuZGVkTmV4dFN0ZXBzEiwKEmNvbnRhaW5zX2RlbW9fZGF0YR'
    'gKIAEoCFIQY29udGFpbnNEZW1vRGF0YQ==');

@$core.Deprecated('Use getMobileHomeRequestDescriptor instead')
const GetMobileHomeRequest$json = {
  '1': 'GetMobileHomeRequest',
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
      '1': 'active_mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.OperatorModeId',
      '10': 'activeMode'
    },
  ],
};

/// Descriptor for `GetMobileHomeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMobileHomeRequestDescriptor = $convert.base64Decode(
    'ChRHZXRNb2JpbGVIb21lUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSRQoLYWN0aXZlX21vZGUYAiABKA4yJC5j'
    'cmVhdGl2YW50YS5hZG1pbi52MS5PcGVyYXRvck1vZGVJZFIKYWN0aXZlTW9kZQ==');

@$core.Deprecated('Use getMobileHomeResponseDescriptor instead')
const GetMobileHomeResponse$json = {
  '1': 'GetMobileHomeResponse',
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
      '1': 'active_mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.OperatorModeId',
      '10': 'activeMode'
    },
    {
      '1': 'morning_brief_headline',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'morningBriefHeadline'
    },
    {
      '1': 'decision_cards',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.DecisionCard',
      '10': 'decisionCards'
    },
    {
      '1': 'onboarding',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.OnboardingChecklist',
      '10': 'onboarding'
    },
    {
      '1': 'unread_notification_count',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'unreadNotificationCount'
    },
    {
      '1': 'customer_verified_total_revenue',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'customerVerifiedTotalRevenue'
    },
    {
      '1': 'revenue_source_badge',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DataSourceBadge',
      '10': 'revenueSourceBadge'
    },
    {
      '1': 'generated_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'generatedAt'
    },
  ],
};

/// Descriptor for `GetMobileHomeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMobileHomeResponseDescriptor = $convert.base64Decode(
    'ChVHZXRNb2JpbGVIb21lUmVzcG9uc2USPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEkUKC2FjdGl2ZV9tb2RlGAIgASgOMiQu'
    'Y3JlYXRpdmFudGEuYWRtaW4udjEuT3BlcmF0b3JNb2RlSWRSCmFjdGl2ZU1vZGUSNAoWbW9ybm'
    'luZ19icmllZl9oZWFkbGluZRgDIAEoCVIUbW9ybmluZ0JyaWVmSGVhZGxpbmUSSQoOZGVjaXNp'
    'b25fY2FyZHMYBCADKAsyIi5jcmVhdGl2YW50YS5hZG1pbi52MS5EZWNpc2lvbkNhcmRSDWRlY2'
    'lzaW9uQ2FyZHMSSQoKb25ib2FyZGluZxgFIAEoCzIpLmNyZWF0aXZhbnRhLmFkbWluLnYxLk9u'
    'Ym9hcmRpbmdDaGVja2xpc3RSCm9uYm9hcmRpbmcSOgoZdW5yZWFkX25vdGlmaWNhdGlvbl9jb3'
    'VudBgGIAEoBVIXdW5yZWFkTm90aWZpY2F0aW9uQ291bnQSRQofY3VzdG9tZXJfdmVyaWZpZWRf'
    'dG90YWxfcmV2ZW51ZRgHIAEoCVIcY3VzdG9tZXJWZXJpZmllZFRvdGFsUmV2ZW51ZRJXChRyZX'
    'ZlbnVlX3NvdXJjZV9iYWRnZRgIIAEoDjIlLmNyZWF0aXZhbnRhLmFkbWluLnYxLkRhdGFTb3Vy'
    'Y2VCYWRnZVIScmV2ZW51ZVNvdXJjZUJhZGdlEj0KDGdlbmVyYXRlZF9hdBgJIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2dlbmVyYXRlZEF0');

@$core.Deprecated('Use getPipelineRequestDescriptor instead')
const GetPipelineRequest$json = {
  '1': 'GetPipelineRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetPipelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPipelineRequestDescriptor = $convert.base64Decode(
    'ChJHZXRQaXBlbGluZVJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use getPipelineResponseDescriptor instead')
const GetPipelineResponse$json = {
  '1': 'GetPipelineResponse',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'ideas_count', '3': 2, '4': 1, '5': 5, '10': 'ideasCount'},
    {'1': 'scripts_count', '3': 3, '4': 1, '5': 5, '10': 'scriptsCount'},
    {
      '1': 'assets_generating_count',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'assetsGeneratingCount'
    },
    {
      '1': 'queued_publish_count',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'queuedPublishCount'
    },
    {
      '1': 'pending_approvals_count',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'pendingApprovalsCount'
    },
  ],
};

/// Descriptor for `GetPipelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPipelineResponseDescriptor = $convert.base64Decode(
    'ChNHZXRQaXBlbGluZVJlc3BvbnNlEj4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIfCgtpZGVhc19jb3VudBgCIAEoBVIKaWRl'
    'YXNDb3VudBIjCg1zY3JpcHRzX2NvdW50GAMgASgFUgxzY3JpcHRzQ291bnQSNgoXYXNzZXRzX2'
    'dlbmVyYXRpbmdfY291bnQYBCABKAVSFWFzc2V0c0dlbmVyYXRpbmdDb3VudBIwChRxdWV1ZWRf'
    'cHVibGlzaF9jb3VudBgFIAEoBVIScXVldWVkUHVibGlzaENvdW50EjYKF3BlbmRpbmdfYXBwcm'
    '92YWxzX2NvdW50GAYgASgFUhVwZW5kaW5nQXBwcm92YWxzQ291bnQ=');

@$core.Deprecated('Use getDecisionCardsRequestDescriptor instead')
const GetDecisionCardsRequest$json = {
  '1': 'GetDecisionCardsRequest',
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
      '1': 'operator_mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.OperatorModeId',
      '10': 'operatorMode'
    },
    {
      '1': 'include_demo_fixtures',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'includeDemoFixtures'
    },
  ],
};

/// Descriptor for `GetDecisionCardsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDecisionCardsRequestDescriptor = $convert.base64Decode(
    'ChdHZXREZWNpc2lvbkNhcmRzUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSSQoNb3BlcmF0b3JfbW9kZRgCIAEo'
    'DjIkLmNyZWF0aXZhbnRhLmFkbWluLnYxLk9wZXJhdG9yTW9kZUlkUgxvcGVyYXRvck1vZGUSMg'
    'oVaW5jbHVkZV9kZW1vX2ZpeHR1cmVzGAMgASgIUhNpbmNsdWRlRGVtb0ZpeHR1cmVz');

@$core.Deprecated('Use getDecisionCardsResponseDescriptor instead')
const GetDecisionCardsResponse$json = {
  '1': 'GetDecisionCardsResponse',
  '2': [
    {
      '1': 'operator_mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.OperatorModeId',
      '10': 'operatorMode'
    },
    {
      '1': 'cards',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.DecisionCard',
      '10': 'cards'
    },
    {
      '1': 'as_of',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'asOf'
    },
  ],
};

/// Descriptor for `GetDecisionCardsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDecisionCardsResponseDescriptor = $convert.base64Decode(
    'ChhHZXREZWNpc2lvbkNhcmRzUmVzcG9uc2USSQoNb3BlcmF0b3JfbW9kZRgBIAEoDjIkLmNyZW'
    'F0aXZhbnRhLmFkbWluLnYxLk9wZXJhdG9yTW9kZUlkUgxvcGVyYXRvck1vZGUSOAoFY2FyZHMY'
    'AiADKAsyIi5jcmVhdGl2YW50YS5hZG1pbi52MS5EZWNpc2lvbkNhcmRSBWNhcmRzEi8KBWFzX2'
    '9mGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEYXNPZg==');

@$core.Deprecated('Use getWhyThisNumberRequestDescriptor instead')
const GetWhyThisNumberRequest$json = {
  '1': 'GetWhyThisNumberRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'metric_key', '3': 2, '4': 1, '5': 9, '10': 'metricKey'},
  ],
};

/// Descriptor for `GetWhyThisNumberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWhyThisNumberRequestDescriptor = $convert.base64Decode(
    'ChdHZXRXaHlUaGlzTnVtYmVyUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSHQoKbWV0cmljX2tleRgCIAEoCVIJ'
    'bWV0cmljS2V5');

@$core.Deprecated('Use getWhyThisNumberResponseDescriptor instead')
const GetWhyThisNumberResponse$json = {
  '1': 'GetWhyThisNumberResponse',
  '2': [
    {
      '1': 'details',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.WhyThisNumberDetails',
      '10': 'details'
    },
  ],
};

/// Descriptor for `GetWhyThisNumberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWhyThisNumberResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRXaHlUaGlzTnVtYmVyUmVzcG9uc2USRAoHZGV0YWlscxgBIAEoCzIqLmNyZWF0aXZhbn'
        'RhLmFkbWluLnYxLldoeVRoaXNOdW1iZXJEZXRhaWxzUgdkZXRhaWxz');

@$core.Deprecated('Use completeOnboardingStepRequestDescriptor instead')
const CompleteOnboardingStepRequest$json = {
  '1': 'CompleteOnboardingStepRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'step_number', '3': 2, '4': 1, '5': 5, '10': 'stepNumber'},
  ],
};

/// Descriptor for `CompleteOnboardingStepRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeOnboardingStepRequestDescriptor =
    $convert.base64Decode(
        'Ch1Db21wbGV0ZU9uYm9hcmRpbmdTdGVwUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy'
        '5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSHwoLc3RlcF9udW1iZXIY'
        'AiABKAVSCnN0ZXBOdW1iZXI=');

@$core.Deprecated('Use completeOnboardingStepResponseDescriptor instead')
const CompleteOnboardingStepResponse$json = {
  '1': 'CompleteOnboardingStepResponse',
  '2': [
    {
      '1': 'updated_checklist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.OnboardingChecklist',
      '10': 'updatedChecklist'
    },
  ],
};

/// Descriptor for `CompleteOnboardingStepResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeOnboardingStepResponseDescriptor =
    $convert.base64Decode(
        'Ch5Db21wbGV0ZU9uYm9hcmRpbmdTdGVwUmVzcG9uc2USVgoRdXBkYXRlZF9jaGVja2xpc3QYAS'
        'ABKAsyKS5jcmVhdGl2YW50YS5hZG1pbi52MS5PbmJvYXJkaW5nQ2hlY2tsaXN0UhB1cGRhdGVk'
        'Q2hlY2tsaXN0');

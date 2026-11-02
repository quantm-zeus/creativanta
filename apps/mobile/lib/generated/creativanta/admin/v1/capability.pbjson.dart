// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/capability.proto.

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

@$core.Deprecated('Use capabilityStateDescriptor instead')
const CapabilityState$json = {
  '1': 'CapabilityState',
  '2': [
    {'1': 'CAPABILITY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'CAPABILITY_STATE_NATIVE', '2': 1},
    {'1': 'CAPABILITY_STATE_READ_ONLY', '2': 2},
    {'1': 'CAPABILITY_STATE_MANUAL', '2': 3},
    {'1': 'CAPABILITY_STATE_DEGRADED', '2': 4},
    {'1': 'CAPABILITY_STATE_UNSUPPORTED', '2': 5},
  ],
};

/// Descriptor for `CapabilityState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List capabilityStateDescriptor = $convert.base64Decode(
    'Cg9DYXBhYmlsaXR5U3RhdGUSIAocQ0FQQUJJTElUWV9TVEFURV9VTlNQRUNJRklFRBAAEhsKF0'
    'NBUEFCSUxJVFlfU1RBVEVfTkFUSVZFEAESHgoaQ0FQQUJJTElUWV9TVEFURV9SRUFEX09OTFkQ'
    'AhIbChdDQVBBQklMSVRZX1NUQVRFX01BTlVBTBADEh0KGUNBUEFCSUxJVFlfU1RBVEVfREVHUk'
    'FERUQQBBIgChxDQVBBQklMSVRZX1NUQVRFX1VOU1VQUE9SVEVEEAU=');

@$core.Deprecated('Use fallbackTypeDescriptor instead')
const FallbackType$json = {
  '1': 'FallbackType',
  '2': [
    {'1': 'FALLBACK_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'FALLBACK_TYPE_MANUAL_UPLOAD', '2': 1},
    {'1': 'FALLBACK_TYPE_CSV_IMPORT', '2': 2},
    {'1': 'FALLBACK_TYPE_WEBHOOK_WORKAROUND', '2': 3},
    {'1': 'FALLBACK_TYPE_BROWSER_ASSIST', '2': 4},
    {'1': 'FALLBACK_TYPE_UNSUPPORTED', '2': 5},
  ],
};

/// Descriptor for `FallbackType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fallbackTypeDescriptor = $convert.base64Decode(
    'CgxGYWxsYmFja1R5cGUSHQoZRkFMTEJBQ0tfVFlQRV9VTlNQRUNJRklFRBAAEh8KG0ZBTExCQU'
    'NLX1RZUEVfTUFOVUFMX1VQTE9BRBABEhwKGEZBTExCQUNLX1RZUEVfQ1NWX0lNUE9SVBACEiQK'
    'IEZBTExCQUNLX1RZUEVfV0VCSE9PS19XT1JLQVJPVU5EEAMSIAocRkFMTEJBQ0tfVFlQRV9CUk'
    '9XU0VSX0FTU0lTVBAEEh0KGUZBTExCQUNLX1RZUEVfVU5TVVBQT1JURUQQBQ==');

@$core.Deprecated('Use policyNoteItemDescriptor instead')
const PolicyNoteItem$json = {
  '1': 'PolicyNoteItem',
  '2': [
    {
      '1': 'policy_note_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'policyNoteId'
    },
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'capability_key', '3': 3, '4': 1, '5': 9, '10': 'capabilityKey'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'detail', '3': 5, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'source_url', '3': 6, '4': 1, '5': 9, '10': 'sourceUrl'},
    {
      '1': 'updated_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `PolicyNoteItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List policyNoteItemDescriptor = $convert.base64Decode(
    'Cg5Qb2xpY3lOb3RlSXRlbRJBCg5wb2xpY3lfbm90ZV9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLm'
    'NvbW1vbi52MS5VVUlEUgxwb2xpY3lOb3RlSWQSGgoIcGxhdGZvcm0YAiABKAlSCHBsYXRmb3Jt'
    'EiUKDmNhcGFiaWxpdHlfa2V5GAMgASgJUg1jYXBhYmlsaXR5S2V5EhgKB3N1bW1hcnkYBCABKA'
    'lSB3N1bW1hcnkSFgoGZGV0YWlsGAUgASgJUgZkZXRhaWwSHQoKc291cmNlX3VybBgGIAEoCVIJ'
    'c291cmNlVXJsEjkKCnVwZGF0ZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use fallbackPathItemDescriptor instead')
const FallbackPathItem$json = {
  '1': 'FallbackPathItem',
  '2': [
    {
      '1': 'fallback_path_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'fallbackPathId'
    },
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'capability_key', '3': 3, '4': 1, '5': 9, '10': 'capabilityKey'},
    {
      '1': 'fallback_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.FallbackType',
      '10': 'fallbackType'
    },
    {'1': 'instructions', '3': 5, '4': 1, '5': 9, '10': 'instructions'},
    {'1': 'estimated_effort', '3': 6, '4': 1, '5': 9, '10': 'estimatedEffort'},
    {
      '1': 'related_policy_note_id',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'relatedPolicyNoteId'
    },
  ],
};

/// Descriptor for `FallbackPathItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fallbackPathItemDescriptor = $convert.base64Decode(
    'ChBGYWxsYmFja1BhdGhJdGVtEkUKEGZhbGxiYWNrX3BhdGhfaWQYASABKAsyGy5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuVVVJRFIOZmFsbGJhY2tQYXRoSWQSGgoIcGxhdGZvcm0YAiABKAlSCHBs'
    'YXRmb3JtEiUKDmNhcGFiaWxpdHlfa2V5GAMgASgJUg1jYXBhYmlsaXR5S2V5EkcKDWZhbGxiYW'
    'NrX3R5cGUYBCABKA4yIi5jcmVhdGl2YW50YS5hZG1pbi52MS5GYWxsYmFja1R5cGVSDGZhbGxi'
    'YWNrVHlwZRIiCgxpbnN0cnVjdGlvbnMYBSABKAlSDGluc3RydWN0aW9ucxIpChBlc3RpbWF0ZW'
    'RfZWZmb3J0GAYgASgJUg9lc3RpbWF0ZWRFZmZvcnQSUAoWcmVsYXRlZF9wb2xpY3lfbm90ZV9p'
    'ZBgHIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUhNyZWxhdGVkUG9saWN5Tm90ZU'
    'lk');

@$core.Deprecated('Use capabilityMatrixCellDescriptor instead')
const CapabilityMatrixCell$json = {
  '1': 'CapabilityMatrixCell',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'capability_key', '3': 2, '4': 1, '5': 9, '10': 'capabilityKey'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'state',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.CapabilityState',
      '10': 'state'
    },
    {
      '1': 'verification_fresh',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'verificationFresh'
    },
    {'1': 'executable', '3': 6, '4': 1, '5': 8, '10': 'executable'},
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'policy_note',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.PolicyNoteItem',
      '10': 'policyNote'
    },
    {
      '1': 'fallback_path',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.FallbackPathItem',
      '10': 'fallbackPath'
    },
    {
      '1': 'checked_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'checkedAt'
    },
    {
      '1': 'valid_until',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
    },
  ],
};

/// Descriptor for `CapabilityMatrixCell`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List capabilityMatrixCellDescriptor = $convert.base64Decode(
    'ChRDYXBhYmlsaXR5TWF0cml4Q2VsbBIaCghwbGF0Zm9ybRgBIAEoCVIIcGxhdGZvcm0SJQoOY2'
    'FwYWJpbGl0eV9rZXkYAiABKAlSDWNhcGFiaWxpdHlLZXkSIQoMZGlzcGxheV9uYW1lGAMgASgJ'
    'UgtkaXNwbGF5TmFtZRI7CgVzdGF0ZRgEIAEoDjIlLmNyZWF0aXZhbnRhLmFkbWluLnYxLkNhcG'
    'FiaWxpdHlTdGF0ZVIFc3RhdGUSLQoSdmVyaWZpY2F0aW9uX2ZyZXNoGAUgASgIUhF2ZXJpZmlj'
    'YXRpb25GcmVzaBIeCgpleGVjdXRhYmxlGAYgASgIUgpleGVjdXRhYmxlEhYKBnJlYXNvbhgHIA'
    'EoCVIGcmVhc29uEkUKC3BvbGljeV9ub3RlGAggASgLMiQuY3JlYXRpdmFudGEuYWRtaW4udjEu'
    'UG9saWN5Tm90ZUl0ZW1SCnBvbGljeU5vdGUSSwoNZmFsbGJhY2tfcGF0aBgJIAEoCzImLmNyZW'
    'F0aXZhbnRhLmFkbWluLnYxLkZhbGxiYWNrUGF0aEl0ZW1SDGZhbGxiYWNrUGF0aBI5CgpjaGVj'
    'a2VkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY2hlY2tlZEF0EjsKC3'
    'ZhbGlkX3VudGlsGAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKdmFsaWRVbnRp'
    'bA==');

@$core.Deprecated('Use getMatrixRequestDescriptor instead')
const GetMatrixRequest$json = {
  '1': 'GetMatrixRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'platform_filter', '3': 2, '4': 1, '5': 9, '10': 'platformFilter'},
  ],
};

/// Descriptor for `GetMatrixRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMatrixRequestDescriptor = $convert.base64Decode(
    'ChBHZXRNYXRyaXhSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLm'
    'NvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBInCg9wbGF0Zm9ybV9maWx0ZXIYAiABKAlSDnBs'
    'YXRmb3JtRmlsdGVy');

@$core.Deprecated('Use getMatrixResponseDescriptor instead')
const GetMatrixResponse$json = {
  '1': 'GetMatrixResponse',
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
      '1': 'cells',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.CapabilityMatrixCell',
      '10': 'cells'
    },
    {
      '1': 'generated_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'generatedAt'
    },
  ],
};

/// Descriptor for `GetMatrixResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMatrixResponseDescriptor = $convert.base64Decode(
    'ChFHZXRNYXRyaXhSZXNwb25zZRI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW50YS'
    '5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSQAoFY2VsbHMYAiADKAsyKi5jcmVhdGl2YW50'
    'YS5hZG1pbi52MS5DYXBhYmlsaXR5TWF0cml4Q2VsbFIFY2VsbHMSPQoMZ2VuZXJhdGVkX2F0GA'
    'MgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZ2VuZXJhdGVkQXQ=');

@$core.Deprecated('Use proactiveCoachingCardDescriptor instead')
const ProactiveCoachingCard$json = {
  '1': 'ProactiveCoachingCard',
  '2': [
    {'1': 'metric_key', '3': 1, '4': 1, '5': 9, '10': 'metricKey'},
    {'1': 'observed_value', '3': 2, '4': 1, '5': 9, '10': 'observedValue'},
    {'1': 'threshold_value', '3': 3, '4': 1, '5': 9, '10': 'thresholdValue'},
    {'1': 'numerator', '3': 4, '4': 1, '5': 3, '10': 'numerator'},
    {'1': 'denominator', '3': 5, '4': 1, '5': 3, '10': 'denominator'},
    {'1': 'window_label', '3': 6, '4': 1, '5': 9, '10': 'windowLabel'},
    {'1': 'message', '3': 7, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'recommended_actions',
      '3': 8,
      '4': 3,
      '5': 9,
      '10': 'recommendedActions'
    },
  ],
};

/// Descriptor for `ProactiveCoachingCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proactiveCoachingCardDescriptor = $convert.base64Decode(
    'ChVQcm9hY3RpdmVDb2FjaGluZ0NhcmQSHQoKbWV0cmljX2tleRgBIAEoCVIJbWV0cmljS2V5Ei'
    'UKDm9ic2VydmVkX3ZhbHVlGAIgASgJUg1vYnNlcnZlZFZhbHVlEicKD3RocmVzaG9sZF92YWx1'
    'ZRgDIAEoCVIOdGhyZXNob2xkVmFsdWUSHAoJbnVtZXJhdG9yGAQgASgDUgludW1lcmF0b3ISIA'
    'oLZGVub21pbmF0b3IYBSABKANSC2Rlbm9taW5hdG9yEiEKDHdpbmRvd19sYWJlbBgGIAEoCVIL'
    'd2luZG93TGFiZWwSGAoHbWVzc2FnZRgHIAEoCVIHbWVzc2FnZRIvChNyZWNvbW1lbmRlZF9hY3'
    'Rpb25zGAggAygJUhJyZWNvbW1lbmRlZEFjdGlvbnM=');

@$core.Deprecated('Use platformHealthScoreCardDescriptor instead')
const PlatformHealthScoreCard$json = {
  '1': 'PlatformHealthScoreCard',
  '2': [
    {
      '1': 'health_score_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'healthScoreId'
    },
    {
      '1': 'connected_account_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'connectedAccountId'
    },
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'overall_score', '3': 4, '4': 1, '5': 5, '10': 'overallScore'},
    {'1': 'status_band', '3': 5, '4': 1, '5': 9, '10': 'statusBand'},
    {
      '1': 'availability_score',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'availabilityScore'
    },
    {'1': 'error_rate_score', '3': 7, '4': 1, '5': 5, '10': 'errorRateScore'},
    {'1': 'latency_score', '3': 8, '4': 1, '5': 5, '10': 'latencyScore'},
    {'1': 'rate_limit_score', '3': 9, '4': 1, '5': 5, '10': 'rateLimitScore'},
    {'1': 'risk_flags', '3': 10, '4': 3, '5': 9, '10': 'riskFlags'},
    {
      '1': 'coaching_cards',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.ProactiveCoachingCard',
      '10': 'coachingCards'
    },
    {
      '1': 'captured_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'capturedAt'
    },
  ],
};

/// Descriptor for `PlatformHealthScoreCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List platformHealthScoreCardDescriptor = $convert.base64Decode(
    'ChdQbGF0Zm9ybUhlYWx0aFNjb3JlQ2FyZBJDCg9oZWFsdGhfc2NvcmVfaWQYASABKAsyGy5jcm'
    'VhdGl2YW50YS5jb21tb24udjEuVVVJRFINaGVhbHRoU2NvcmVJZBJNChRjb25uZWN0ZWRfYWNj'
    'b3VudF9pZBgCIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUhJjb25uZWN0ZWRBY2'
    'NvdW50SWQSGgoIcGxhdGZvcm0YAyABKAlSCHBsYXRmb3JtEiMKDW92ZXJhbGxfc2NvcmUYBCAB'
    'KAVSDG92ZXJhbGxTY29yZRIfCgtzdGF0dXNfYmFuZBgFIAEoCVIKc3RhdHVzQmFuZBItChJhdm'
    'FpbGFiaWxpdHlfc2NvcmUYBiABKAVSEWF2YWlsYWJpbGl0eVNjb3JlEigKEGVycm9yX3JhdGVf'
    'c2NvcmUYByABKAVSDmVycm9yUmF0ZVNjb3JlEiMKDWxhdGVuY3lfc2NvcmUYCCABKAVSDGxhdG'
    'VuY3lTY29yZRIoChByYXRlX2xpbWl0X3Njb3JlGAkgASgFUg5yYXRlTGltaXRTY29yZRIdCgpy'
    'aXNrX2ZsYWdzGAogAygJUglyaXNrRmxhZ3MSUgoOY29hY2hpbmdfY2FyZHMYCyADKAsyKy5jcm'
    'VhdGl2YW50YS5hZG1pbi52MS5Qcm9hY3RpdmVDb2FjaGluZ0NhcmRSDWNvYWNoaW5nQ2FyZHMS'
    'OwoLY2FwdHVyZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpjYXB0dX'
    'JlZEF0');

@$core.Deprecated('Use getHealthScoresRequestDescriptor instead')
const GetHealthScoresRequest$json = {
  '1': 'GetHealthScoresRequest',
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

/// Descriptor for `GetHealthScoresRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthScoresRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRIZWFsdGhTY29yZXNSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
        'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated('Use getHealthScoresResponseDescriptor instead')
const GetHealthScoresResponse$json = {
  '1': 'GetHealthScoresResponse',
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
      '1': 'scores',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.PlatformHealthScoreCard',
      '10': 'scores'
    },
  ],
};

/// Descriptor for `GetHealthScoresResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthScoresResponseDescriptor = $convert.base64Decode(
    'ChdHZXRIZWFsdGhTY29yZXNSZXNwb25zZRI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSRQoGc2NvcmVzGAIgAygLMi0uY3Jl'
    'YXRpdmFudGEuYWRtaW4udjEuUGxhdGZvcm1IZWFsdGhTY29yZUNhcmRSBnNjb3Jlcw==');

@$core.Deprecated('Use listPolicyNotesRequestDescriptor instead')
const ListPolicyNotesRequest$json = {
  '1': 'ListPolicyNotesRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'platform_filter', '3': 2, '4': 1, '5': 9, '10': 'platformFilter'},
  ],
};

/// Descriptor for `ListPolicyNotesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPolicyNotesRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0UG9saWN5Tm90ZXNSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBInCg9wbGF0Zm9ybV9maWx0ZXIYAiAB'
    'KAlSDnBsYXRmb3JtRmlsdGVy');

@$core.Deprecated('Use listPolicyNotesResponseDescriptor instead')
const ListPolicyNotesResponse$json = {
  '1': 'ListPolicyNotesResponse',
  '2': [
    {
      '1': 'policy_notes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.PolicyNoteItem',
      '10': 'policyNotes'
    },
  ],
};

/// Descriptor for `ListPolicyNotesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPolicyNotesResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UG9saWN5Tm90ZXNSZXNwb25zZRJHCgxwb2xpY3lfbm90ZXMYASADKAsyJC5jcmVhdG'
        'l2YW50YS5hZG1pbi52MS5Qb2xpY3lOb3RlSXRlbVILcG9saWN5Tm90ZXM=');

@$core.Deprecated('Use listFallbackPathsRequestDescriptor instead')
const ListFallbackPathsRequest$json = {
  '1': 'ListFallbackPathsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'platform_filter', '3': 2, '4': 1, '5': 9, '10': 'platformFilter'},
  ],
};

/// Descriptor for `ListFallbackPathsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFallbackPathsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0RmFsbGJhY2tQYXRoc1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEicKD3BsYXRmb3JtX2ZpbHRlchgC'
    'IAEoCVIOcGxhdGZvcm1GaWx0ZXI=');

@$core.Deprecated('Use listFallbackPathsResponseDescriptor instead')
const ListFallbackPathsResponse$json = {
  '1': 'ListFallbackPathsResponse',
  '2': [
    {
      '1': 'fallback_paths',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.FallbackPathItem',
      '10': 'fallbackPaths'
    },
  ],
};

/// Descriptor for `ListFallbackPathsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFallbackPathsResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0RmFsbGJhY2tQYXRoc1Jlc3BvbnNlEk0KDmZhbGxiYWNrX3BhdGhzGAEgAygLMiYuY3'
        'JlYXRpdmFudGEuYWRtaW4udjEuRmFsbGJhY2tQYXRoSXRlbVINZmFsbGJhY2tQYXRocw==');

@$core.Deprecated('Use connectedAccountItemDescriptor instead')
const ConnectedAccountItem$json = {
  '1': 'ConnectedAccountItem',
  '2': [
    {
      '1': 'connected_account_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'connectedAccountId'
    },
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'account_type', '3': 4, '4': 1, '5': 9, '10': 'accountType'},
    {
      '1': 'external_account_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'externalAccountId'
    },
    {'1': 'account_name', '3': 6, '4': 1, '5': 9, '10': 'accountName'},
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
    {'1': 'health_score', '3': 8, '4': 1, '5': 5, '10': 'healthScore'},
    {'1': 'granted_scopes', '3': 9, '4': 3, '5': 9, '10': 'grantedScopes'},
    {
      '1': 'token_expires_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'tokenExpiresAt'
    },
    {
      '1': 'last_synced_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastSyncedAt'
    },
  ],
};

/// Descriptor for `ConnectedAccountItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectedAccountItemDescriptor = $convert.base64Decode(
    'ChRDb25uZWN0ZWRBY2NvdW50SXRlbRJNChRjb25uZWN0ZWRfYWNjb3VudF9pZBgBIAEoCzIbLm'
    'NyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUhJjb25uZWN0ZWRBY2NvdW50SWQSPgoMd29ya3Nw'
    'YWNlX2lkGAIgASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEh'
    'oKCHBsYXRmb3JtGAMgASgJUghwbGF0Zm9ybRIhCgxhY2NvdW50X3R5cGUYBCABKAlSC2FjY291'
    'bnRUeXBlEi4KE2V4dGVybmFsX2FjY291bnRfaWQYBSABKAlSEWV4dGVybmFsQWNjb3VudElkEi'
    'EKDGFjY291bnRfbmFtZRgGIAEoCVILYWNjb3VudE5hbWUSFgoGc3RhdHVzGAcgASgJUgZzdGF0'
    'dXMSIQoMaGVhbHRoX3Njb3JlGAggASgFUgtoZWFsdGhTY29yZRIlCg5ncmFudGVkX3Njb3Blcx'
    'gJIAMoCVINZ3JhbnRlZFNjb3BlcxJEChB0b2tlbl9leHBpcmVzX2F0GAogASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIOdG9rZW5FeHBpcmVzQXQSQAoObGFzdF9zeW5jZWRfYXQYCy'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxsYXN0U3luY2VkQXQ=');

@$core.Deprecated('Use connectorServiceListRequestDescriptor instead')
const ConnectorServiceListRequest$json = {
  '1': 'ConnectorServiceListRequest',
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

/// Descriptor for `ConnectorServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectorServiceListRequestDescriptor =
    $convert.base64Decode(
        'ChtDb25uZWN0b3JTZXJ2aWNlTGlzdFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use connectorServiceListResponseDescriptor instead')
const ConnectorServiceListResponse$json = {
  '1': 'ConnectorServiceListResponse',
  '2': [
    {
      '1': 'accounts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.ConnectedAccountItem',
      '10': 'accounts'
    },
  ],
};

/// Descriptor for `ConnectorServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectorServiceListResponseDescriptor =
    $convert.base64Decode(
        'ChxDb25uZWN0b3JTZXJ2aWNlTGlzdFJlc3BvbnNlEkYKCGFjY291bnRzGAEgAygLMiouY3JlYX'
        'RpdmFudGEuYWRtaW4udjEuQ29ubmVjdGVkQWNjb3VudEl0ZW1SCGFjY291bnRz');

@$core.Deprecated('Use connectorServiceCheckRequestDescriptor instead')
const ConnectorServiceCheckRequest$json = {
  '1': 'ConnectorServiceCheckRequest',
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
      '1': 'connected_account_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'connectedAccountId'
    },
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'action_key', '3': 4, '4': 1, '5': 9, '10': 'actionKey'},
    {'1': 'target_market', '3': 5, '4': 1, '5': 9, '10': 'targetMarket'},
    {'1': 'require_write', '3': 6, '4': 1, '5': 8, '10': 'requireWrite'},
  ],
};

/// Descriptor for `ConnectorServiceCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectorServiceCheckRequestDescriptor = $convert.base64Decode(
    'ChxDb25uZWN0b3JTZXJ2aWNlQ2hlY2tSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLm'
    'NyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBJNChRjb25uZWN0ZWRfYWNj'
    'b3VudF9pZBgCIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUhJjb25uZWN0ZWRBY2'
    'NvdW50SWQSGgoIcGxhdGZvcm0YAyABKAlSCHBsYXRmb3JtEh0KCmFjdGlvbl9rZXkYBCABKAlS'
    'CWFjdGlvbktleRIjCg10YXJnZXRfbWFya2V0GAUgASgJUgx0YXJnZXRNYXJrZXQSIwoNcmVxdW'
    'lyZV93cml0ZRgGIAEoCFIMcmVxdWlyZVdyaXRl');

@$core.Deprecated('Use connectorServiceCheckResponseDescriptor instead')
const ConnectorServiceCheckResponse$json = {
  '1': 'ConnectorServiceCheckResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.CapabilityState',
      '10': 'state'
    },
    {'1': 'executable', '3': 2, '4': 1, '5': 8, '10': 'executable'},
    {
      '1': 'verification_fresh',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'verificationFresh'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'policy_note',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.PolicyNoteItem',
      '10': 'policyNote'
    },
    {
      '1': 'fallback_path',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.FallbackPathItem',
      '10': 'fallbackPath'
    },
  ],
};

/// Descriptor for `ConnectorServiceCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectorServiceCheckResponseDescriptor = $convert.base64Decode(
    'Ch1Db25uZWN0b3JTZXJ2aWNlQ2hlY2tSZXNwb25zZRI7CgVzdGF0ZRgBIAEoDjIlLmNyZWF0aX'
    'ZhbnRhLmFkbWluLnYxLkNhcGFiaWxpdHlTdGF0ZVIFc3RhdGUSHgoKZXhlY3V0YWJsZRgCIAEo'
    'CFIKZXhlY3V0YWJsZRItChJ2ZXJpZmljYXRpb25fZnJlc2gYAyABKAhSEXZlcmlmaWNhdGlvbk'
    'ZyZXNoEhYKBnJlYXNvbhgEIAEoCVIGcmVhc29uEkUKC3BvbGljeV9ub3RlGAUgASgLMiQuY3Jl'
    'YXRpdmFudGEuYWRtaW4udjEuUG9saWN5Tm90ZUl0ZW1SCnBvbGljeU5vdGUSSwoNZmFsbGJhY2'
    'tfcGF0aBgGIAEoCzImLmNyZWF0aXZhbnRhLmFkbWluLnYxLkZhbGxiYWNrUGF0aEl0ZW1SDGZh'
    'bGxiYWNrUGF0aA==');

@$core.Deprecated('Use connectorServiceCheckHealthRequestDescriptor instead')
const ConnectorServiceCheckHealthRequest$json = {
  '1': 'ConnectorServiceCheckHealthRequest',
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
      '1': 'connected_account_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'connectedAccountId'
    },
  ],
};

/// Descriptor for `ConnectorServiceCheckHealthRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectorServiceCheckHealthRequestDescriptor =
    $convert.base64Decode(
        'CiJDb25uZWN0b3JTZXJ2aWNlQ2hlY2tIZWFsdGhSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIA'
        'EoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBJNChRjb25uZWN0'
        'ZWRfYWNjb3VudF9pZBgCIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUhJjb25uZW'
        'N0ZWRBY2NvdW50SWQ=');

@$core.Deprecated('Use connectorServiceCheckHealthResponseDescriptor instead')
const ConnectorServiceCheckHealthResponse$json = {
  '1': 'ConnectorServiceCheckHealthResponse',
  '2': [
    {
      '1': 'health_score',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.PlatformHealthScoreCard',
      '10': 'healthScore'
    },
  ],
};

/// Descriptor for `ConnectorServiceCheckHealthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectorServiceCheckHealthResponseDescriptor =
    $convert.base64Decode(
        'CiNDb25uZWN0b3JTZXJ2aWNlQ2hlY2tIZWFsdGhSZXNwb25zZRJQCgxoZWFsdGhfc2NvcmUYAS'
        'ABKAsyLS5jcmVhdGl2YW50YS5hZG1pbi52MS5QbGF0Zm9ybUhlYWx0aFNjb3JlQ2FyZFILaGVh'
        'bHRoU2NvcmU=');

@$core.Deprecated('Use connectorServiceDisconnectRequestDescriptor instead')
const ConnectorServiceDisconnectRequest$json = {
  '1': 'ConnectorServiceDisconnectRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {
      '1': 'connected_account_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'connectedAccountId'
    },
  ],
};

/// Descriptor for `ConnectorServiceDisconnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectorServiceDisconnectRequestDescriptor =
    $convert.base64Decode(
        'CiFDb25uZWN0b3JTZXJ2aWNlRGlzY29ubmVjdFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLm'
        'NyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBJNChRjb25uZWN0'
        'ZWRfYWNjb3VudF9pZBgCIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUhJjb25uZW'
        'N0ZWRBY2NvdW50SWQ=');

@$core.Deprecated('Use connectorServiceDisconnectResponseDescriptor instead')
const ConnectorServiceDisconnectResponse$json = {
  '1': 'ConnectorServiceDisconnectResponse',
  '2': [
    {
      '1': 'connected_account_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'connectedAccountId'
    },
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'replayed', '3': 3, '4': 1, '5': 8, '10': 'replayed'},
    {
      '1': 'disconnected_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'disconnectedAt'
    },
  ],
};

/// Descriptor for `ConnectorServiceDisconnectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectorServiceDisconnectResponseDescriptor =
    $convert.base64Decode(
        'CiJDb25uZWN0b3JTZXJ2aWNlRGlzY29ubmVjdFJlc3BvbnNlEk0KFGNvbm5lY3RlZF9hY2NvdW'
        '50X2lkGAEgASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSEmNvbm5lY3RlZEFjY291'
        'bnRJZBIWCgZzdGF0dXMYAiABKAlSBnN0YXR1cxIaCghyZXBsYXllZBgDIAEoCFIIcmVwbGF5ZW'
        'QSQwoPZGlzY29ubmVjdGVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIO'
        'ZGlzY29ubmVjdGVkQXQ=');

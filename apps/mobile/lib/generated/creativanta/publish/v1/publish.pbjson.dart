// This is a generated file - do not edit.
//
// Generated from creativanta/publish/v1/publish.proto.

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

@$core.Deprecated('Use publishModeDescriptor instead')
const PublishMode$json = {
  '1': 'PublishMode',
  '2': [
    {'1': 'PUBLISH_MODE_UNSPECIFIED', '2': 0},
    {'1': 'PUBLISH_MODE_DIRECT', '2': 1},
    {'1': 'PUBLISH_MODE_DRAFT', '2': 2},
    {'1': 'PUBLISH_MODE_EXPORT', '2': 3},
    {'1': 'PUBLISH_MODE_MANUAL', '2': 4},
  ],
};

/// Descriptor for `PublishMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List publishModeDescriptor = $convert.base64Decode(
    'CgtQdWJsaXNoTW9kZRIcChhQVUJMSVNIX01PREVfVU5TUEVDSUZJRUQQABIXChNQVUJMSVNIX0'
    '1PREVfRElSRUNUEAESFgoSUFVCTElTSF9NT0RFX0RSQUZUEAISFwoTUFVCTElTSF9NT0RFX0VY'
    'UE9SVBADEhcKE1BVQkxJU0hfTU9ERV9NQU5VQUwQBA==');

@$core.Deprecated('Use publishItemLifecycleStateDescriptor instead')
const PublishItemLifecycleState$json = {
  '1': 'PublishItemLifecycleState',
  '2': [
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_DRAFT', '2': 1},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_QUEUED', '2': 2},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_SCHEDULED', '2': 3},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_READY_TO_EXECUTE', '2': 4},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_EXECUTING', '2': 5},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED', '2': 6},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_PARTIALLY_PUBLISHED', '2': 7},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_FAILED', '2': 8},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_CANCELLED', '2': 9},
    {'1': 'PUBLISH_ITEM_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK', '2': 10},
  ],
};

/// Descriptor for `PublishItemLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List publishItemLifecycleStateDescriptor = $convert.base64Decode(
    'ChlQdWJsaXNoSXRlbUxpZmVjeWNsZVN0YXRlEiwKKFBVQkxJU0hfSVRFTV9MSUZFQ1lDTEVfU1'
    'RBVEVfVU5TUEVDSUZJRUQQABImCiJQVUJMSVNIX0lURU1fTElGRUNZQ0xFX1NUQVRFX0RSQUZU'
    'EAESJwojUFVCTElTSF9JVEVNX0xJRkVDWUNMRV9TVEFURV9RVUVVRUQQAhIqCiZQVUJMSVNIX0'
    'lURU1fTElGRUNZQ0xFX1NUQVRFX1NDSEVEVUxFRBADEjEKLVBVQkxJU0hfSVRFTV9MSUZFQ1lD'
    'TEVfU1RBVEVfUkVBRFlfVE9fRVhFQ1VURRAEEioKJlBVQkxJU0hfSVRFTV9MSUZFQ1lDTEVfU1'
    'RBVEVfRVhFQ1VUSU5HEAUSKgomUFVCTElTSF9JVEVNX0xJRkVDWUNMRV9TVEFURV9QVUJMSVNI'
    'RUQQBhI0CjBQVUJMSVNIX0lURU1fTElGRUNZQ0xFX1NUQVRFX1BBUlRJQUxMWV9QVUJMSVNIRU'
    'QQBxInCiNQVUJMSVNIX0lURU1fTElGRUNZQ0xFX1NUQVRFX0ZBSUxFRBAIEioKJlBVQkxJU0hf'
    'SVRFTV9MSUZFQ1lDTEVfU1RBVEVfQ0FOQ0VMTEVEEAkSOQo1UFVCTElTSF9JVEVNX0xJRkVDWU'
    'NMRV9TVEFURV9SRVFVSVJFU19NQU5VQUxfRkFMTEJBQ0sQCg==');

@$core.Deprecated('Use publishJobLifecycleStateDescriptor instead')
const PublishJobLifecycleState$json = {
  '1': 'PublishJobLifecycleState',
  '2': [
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_CREATED', '2': 1},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_QUEUED', '2': 2},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_DISPATCHED', '2': 3},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_EXECUTING', '2': 4},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_PARTIALLY_SUCCEEDED', '2': 5},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_SUCCEEDED', '2': 6},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_FAILED', '2': 7},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_CANCELLED', '2': 8},
    {'1': 'PUBLISH_JOB_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK', '2': 9},
  ],
};

/// Descriptor for `PublishJobLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List publishJobLifecycleStateDescriptor = $convert.base64Decode(
    'ChhQdWJsaXNoSm9iTGlmZWN5Y2xlU3RhdGUSKwonUFVCTElTSF9KT0JfTElGRUNZQ0xFX1NUQV'
    'RFX1VOU1BFQ0lGSUVEEAASJwojUFVCTElTSF9KT0JfTElGRUNZQ0xFX1NUQVRFX0NSRUFURUQQ'
    'ARImCiJQVUJMSVNIX0pPQl9MSUZFQ1lDTEVfU1RBVEVfUVVFVUVEEAISKgomUFVCTElTSF9KT0'
    'JfTElGRUNZQ0xFX1NUQVRFX0RJU1BBVENIRUQQAxIpCiVQVUJMSVNIX0pPQl9MSUZFQ1lDTEVf'
    'U1RBVEVfRVhFQ1VUSU5HEAQSMwovUFVCTElTSF9KT0JfTElGRUNZQ0xFX1NUQVRFX1BBUlRJQU'
    'xMWV9TVUNDRUVERUQQBRIpCiVQVUJMSVNIX0pPQl9MSUZFQ1lDTEVfU1RBVEVfU1VDQ0VFREVE'
    'EAYSJgoiUFVCTElTSF9KT0JfTElGRUNZQ0xFX1NUQVRFX0ZBSUxFRBAHEikKJVBVQkxJU0hfSk'
    '9CX0xJRkVDWUNMRV9TVEFURV9DQU5DRUxMRUQQCBI4CjRQVUJMSVNIX0pPQl9MSUZFQ1lDTEVf'
    'U1RBVEVfUkVRVUlSRVNfTUFOVUFMX0ZBTExCQUNLEAk=');

@$core.Deprecated('Use publishResultStatusDescriptor instead')
const PublishResultStatus$json = {
  '1': 'PublishResultStatus',
  '2': [
    {'1': 'PUBLISH_RESULT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PUBLISH_RESULT_STATUS_SUCCESS', '2': 1},
    {'1': 'PUBLISH_RESULT_STATUS_PARTIAL_SUCCESS', '2': 2},
    {'1': 'PUBLISH_RESULT_STATUS_FAILED', '2': 3},
    {'1': 'PUBLISH_RESULT_STATUS_TIMEOUT', '2': 4},
  ],
};

/// Descriptor for `PublishResultStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List publishResultStatusDescriptor = $convert.base64Decode(
    'ChNQdWJsaXNoUmVzdWx0U3RhdHVzEiUKIVBVQkxJU0hfUkVTVUxUX1NUQVRVU19VTlNQRUNJRk'
    'lFRBAAEiEKHVBVQkxJU0hfUkVTVUxUX1NUQVRVU19TVUNDRVNTEAESKQolUFVCTElTSF9SRVNV'
    'TFRfU1RBVFVTX1BBUlRJQUxfU1VDQ0VTUxACEiAKHFBVQkxJU0hfUkVTVUxUX1NUQVRVU19GQU'
    'lMRUQQAxIhCh1QVUJMSVNIX1JFU1VMVF9TVEFUVVNfVElNRU9VVBAE');

@$core.Deprecated('Use executionPathDescriptor instead')
const ExecutionPath$json = {
  '1': 'ExecutionPath',
  '2': [
    {'1': 'EXECUTION_PATH_UNSPECIFIED', '2': 0},
    {'1': 'EXECUTION_PATH_NATIVE_API', '2': 1},
    {'1': 'EXECUTION_PATH_MANUAL_UPLOAD', '2': 2},
    {'1': 'EXECUTION_PATH_EXPORT_PACKAGE', '2': 3},
  ],
};

/// Descriptor for `ExecutionPath`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List executionPathDescriptor = $convert.base64Decode(
    'Cg1FeGVjdXRpb25QYXRoEh4KGkVYRUNVVElPTl9QQVRIX1VOU1BFQ0lGSUVEEAASHQoZRVhFQ1'
    'VUSU9OX1BBVEhfTkFUSVZFX0FQSRABEiAKHEVYRUNVVElPTl9QQVRIX01BTlVBTF9VUExPQUQQ'
    'AhIhCh1FWEVDVVRJT05fUEFUSF9FWFBPUlRfUEFDS0FHRRAD');

@$core.Deprecated('Use diagnosticsStateDescriptor instead')
const DiagnosticsState$json = {
  '1': 'DiagnosticsState',
  '2': [
    {'1': 'DIAGNOSTICS_STATE_UNSPECIFIED', '2': 0},
    {'1': 'DIAGNOSTICS_STATE_HEALTHY', '2': 1},
    {'1': 'DIAGNOSTICS_STATE_WARNING', '2': 2},
    {'1': 'DIAGNOSTICS_STATE_DEGRADED', '2': 3},
    {'1': 'DIAGNOSTICS_STATE_BLOCKED', '2': 4},
  ],
};

/// Descriptor for `DiagnosticsState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List diagnosticsStateDescriptor = $convert.base64Decode(
    'ChBEaWFnbm9zdGljc1N0YXRlEiEKHURJQUdOT1NUSUNTX1NUQVRFX1VOU1BFQ0lGSUVEEAASHQ'
    'oZRElBR05PU1RJQ1NfU1RBVEVfSEVBTFRIWRABEh0KGURJQUdOT1NUSUNTX1NUQVRFX1dBUk5J'
    'TkcQAhIeChpESUFHTk9TVElDU19TVEFURV9ERUdSQURFRBADEh0KGURJQUdOT1NUSUNTX1NUQV'
    'RFX0JMT0NLRUQQBA==');

@$core.Deprecated('Use publishCapabilityStateDescriptor instead')
const PublishCapabilityState$json = {
  '1': 'PublishCapabilityState',
  '2': [
    {'1': 'PUBLISH_CAPABILITY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PUBLISH_CAPABILITY_STATE_NATIVE', '2': 1},
    {'1': 'PUBLISH_CAPABILITY_STATE_READ_ONLY', '2': 2},
    {'1': 'PUBLISH_CAPABILITY_STATE_MANUAL', '2': 3},
    {'1': 'PUBLISH_CAPABILITY_STATE_DEGRADED', '2': 4},
    {'1': 'PUBLISH_CAPABILITY_STATE_UNSUPPORTED', '2': 5},
  ],
};

/// Descriptor for `PublishCapabilityState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List publishCapabilityStateDescriptor = $convert.base64Decode(
    'ChZQdWJsaXNoQ2FwYWJpbGl0eVN0YXRlEigKJFBVQkxJU0hfQ0FQQUJJTElUWV9TVEFURV9VTl'
    'NQRUNJRklFRBAAEiMKH1BVQkxJU0hfQ0FQQUJJTElUWV9TVEFURV9OQVRJVkUQARImCiJQVUJM'
    'SVNIX0NBUEFCSUxJVFlfU1RBVEVfUkVBRF9PTkxZEAISIwofUFVCTElTSF9DQVBBQklMSVRZX1'
    'NUQVRFX01BTlVBTBADEiUKIVBVQkxJU0hfQ0FQQUJJTElUWV9TVEFURV9ERUdSQURFRBAEEigK'
    'JFBVQkxJU0hfQ0FQQUJJTElUWV9TVEFURV9VTlNVUFBPUlRFRBAF');

@$core.Deprecated('Use publishItemDescriptor instead')
const PublishItem$json = {
  '1': 'PublishItem',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'target_platform', '3': 4, '4': 1, '5': 9, '10': 'targetPlatform'},
    {'1': 'target_account_id', '3': 5, '4': 1, '5': 9, '10': 'targetAccountId'},
    {'1': 'target_format', '3': 6, '4': 1, '5': 9, '10': 'targetFormat'},
    {
      '1': 'publish_mode',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.PublishMode',
      '10': 'publishMode'
    },
    {'1': 'title', '3': 8, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 9, '4': 1, '5': 9, '10': 'description'},
    {'1': 'hashtags', '3': 10, '4': 3, '5': 9, '10': 'hashtags'},
    {
      '1': 'schedule_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduleAt'
    },
    {
      '1': 'capability_snapshot_id',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'capabilitySnapshotId'
    },
    {
      '1': 'lifecycle_state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.PublishItemLifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'diagnostics_state',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.DiagnosticsState',
      '10': 'diagnosticsState'
    },
    {'1': 'linked_offer_ids', '3': 15, '4': 3, '5': 9, '10': 'linkedOfferIds'},
    {
      '1': 'linked_campaign_ids',
      '3': 16,
      '4': 3,
      '5': 9,
      '10': 'linkedCampaignIds'
    },
    {'1': 'packaging_score', '3': 17, '4': 1, '5': 2, '10': 'packagingScore'},
    {
      '1': 'compliance_scan_result',
      '3': 18,
      '4': 1,
      '5': 9,
      '10': 'complianceScanResult'
    },
    {'1': 'created_by', '3': 19, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'created_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `PublishItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishItemDescriptor = $convert.base64Decode(
    'CgtQdWJsaXNoSXRlbRImCg9wdWJsaXNoX2l0ZW1faWQYASABKAlSDXB1Ymxpc2hJdGVtSWQSIQ'
    'oMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIZCghhc3NldF9pZBgDIAEoCVIHYXNz'
    'ZXRJZBInCg90YXJnZXRfcGxhdGZvcm0YBCABKAlSDnRhcmdldFBsYXRmb3JtEioKEXRhcmdldF'
    '9hY2NvdW50X2lkGAUgASgJUg90YXJnZXRBY2NvdW50SWQSIwoNdGFyZ2V0X2Zvcm1hdBgGIAEo'
    'CVIMdGFyZ2V0Rm9ybWF0EkYKDHB1Ymxpc2hfbW9kZRgHIAEoDjIjLmNyZWF0aXZhbnRhLnB1Ym'
    'xpc2gudjEuUHVibGlzaE1vZGVSC3B1Ymxpc2hNb2RlEhQKBXRpdGxlGAggASgJUgV0aXRsZRIg'
    'CgtkZXNjcmlwdGlvbhgJIAEoCVILZGVzY3JpcHRpb24SGgoIaGFzaHRhZ3MYCiADKAlSCGhhc2'
    'h0YWdzEjsKC3NjaGVkdWxlX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIK'
    'c2NoZWR1bGVBdBI0ChZjYXBhYmlsaXR5X3NuYXBzaG90X2lkGAwgASgJUhRjYXBhYmlsaXR5U2'
    '5hcHNob3RJZBJaCg9saWZlY3ljbGVfc3RhdGUYDSABKA4yMS5jcmVhdGl2YW50YS5wdWJsaXNo'
    'LnYxLlB1Ymxpc2hJdGVtTGlmZWN5Y2xlU3RhdGVSDmxpZmVjeWNsZVN0YXRlElUKEWRpYWdub3'
    'N0aWNzX3N0YXRlGA4gASgOMiguY3JlYXRpdmFudGEucHVibGlzaC52MS5EaWFnbm9zdGljc1N0'
    'YXRlUhBkaWFnbm9zdGljc1N0YXRlEigKEGxpbmtlZF9vZmZlcl9pZHMYDyADKAlSDmxpbmtlZE'
    '9mZmVySWRzEi4KE2xpbmtlZF9jYW1wYWlnbl9pZHMYECADKAlSEWxpbmtlZENhbXBhaWduSWRz'
    'EicKD3BhY2thZ2luZ19zY29yZRgRIAEoAlIOcGFja2FnaW5nU2NvcmUSNAoWY29tcGxpYW5jZV'
    '9zY2FuX3Jlc3VsdBgSIAEoCVIUY29tcGxpYW5jZVNjYW5SZXN1bHQSHQoKY3JlYXRlZF9ieRgT'
    'IAEoCVIJY3JlYXRlZEJ5EjkKCmNyZWF0ZWRfYXQYFCABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgVIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use publishJobDescriptor instead')
const PublishJob$json = {
  '1': 'PublishJob',
  '2': [
    {'1': 'publish_job_id', '3': 1, '4': 1, '5': 9, '10': 'publishJobId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'publish_item_id', '3': 3, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'dispatch_strategy',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'dispatchStrategy'
    },
    {
      '1': 'lifecycle_state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.PublishJobLifecycleState',
      '10': 'lifecycleState'
    },
    {'1': 'attempt_count', '3': 6, '4': 1, '5': 5, '10': 'attemptCount'},
    {'1': 'max_attempts', '3': 7, '4': 1, '5': 5, '10': 'maxAttempts'},
    {'1': 'current_worker_id', '3': 8, '4': 1, '5': 9, '10': 'currentWorkerId'},
    {
      '1': 'approval_request_id',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'approvalRequestId'
    },
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `PublishJob`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishJobDescriptor = $convert.base64Decode(
    'CgpQdWJsaXNoSm9iEiQKDnB1Ymxpc2hfam9iX2lkGAEgASgJUgxwdWJsaXNoSm9iSWQSIQoMd2'
    '9ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBImCg9wdWJsaXNoX2l0ZW1faWQYAyABKAlS'
    'DXB1Ymxpc2hJdGVtSWQSKwoRZGlzcGF0Y2hfc3RyYXRlZ3kYBCABKAlSEGRpc3BhdGNoU3RyYX'
    'RlZ3kSWQoPbGlmZWN5Y2xlX3N0YXRlGAUgASgOMjAuY3JlYXRpdmFudGEucHVibGlzaC52MS5Q'
    'dWJsaXNoSm9iTGlmZWN5Y2xlU3RhdGVSDmxpZmVjeWNsZVN0YXRlEiMKDWF0dGVtcHRfY291bn'
    'QYBiABKAVSDGF0dGVtcHRDb3VudBIhCgxtYXhfYXR0ZW1wdHMYByABKAVSC21heEF0dGVtcHRz'
    'EioKEWN1cnJlbnRfd29ya2VyX2lkGAggASgJUg9jdXJyZW50V29ya2VySWQSLgoTYXBwcm92YW'
    'xfcmVxdWVzdF9pZBgJIAEoCVIRYXBwcm92YWxSZXF1ZXN0SWQSOQoKY3JlYXRlZF9hdBgKIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GA'
    'sgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use publishLogDescriptor instead')
const PublishLog$json = {
  '1': 'PublishLog',
  '2': [
    {'1': 'publish_log_id', '3': 1, '4': 1, '5': 9, '10': 'publishLogId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'publish_job_id', '3': 3, '4': 1, '5': 9, '10': 'publishJobId'},
    {'1': 'publish_item_id', '3': 4, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'attempted_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'attemptedAt'
    },
    {
      '1': 'completed_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {
      '1': 'failed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'failedAt'
    },
    {'1': 'actor_user_id', '3': 8, '4': 1, '5': 9, '10': 'actorUserId'},
    {
      '1': 'acting_mode',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.OperatorMode',
      '10': 'actingMode'
    },
    {
      '1': 'execution_path',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.ExecutionPath',
      '10': 'executionPath'
    },
    {
      '1': 'capability_snapshot_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'capabilitySnapshotId'
    },
    {
      '1': 'result_status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.PublishResultStatus',
      '10': 'resultStatus'
    },
    {'1': 'external_post_id', '3': 13, '4': 1, '5': 9, '10': 'externalPostId'},
    {
      '1': 'external_post_url',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'externalPostUrl'
    },
    {'1': 'diagnostics_ref', '3': 15, '4': 1, '5': 9, '10': 'diagnosticsRef'},
    {'1': 'evidence_ref', '3': 16, '4': 1, '5': 9, '10': 'evidenceRef'},
    {'1': 'error_code', '3': 17, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 18, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `PublishLog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishLogDescriptor = $convert.base64Decode(
    'CgpQdWJsaXNoTG9nEiQKDnB1Ymxpc2hfbG9nX2lkGAEgASgJUgxwdWJsaXNoTG9nSWQSIQoMd2'
    '9ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIkCg5wdWJsaXNoX2pvYl9pZBgDIAEoCVIM'
    'cHVibGlzaEpvYklkEiYKD3B1Ymxpc2hfaXRlbV9pZBgEIAEoCVINcHVibGlzaEl0ZW1JZBI9Cg'
    'xhdHRlbXB0ZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgthdHRlbXB0'
    'ZWRBdBI9Cgxjb21wbGV0ZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'tjb21wbGV0ZWRBdBI3CglmYWlsZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUghmYWlsZWRBdBIiCg1hY3Rvcl91c2VyX2lkGAggASgJUgthY3RvclVzZXJJZBJECgthY3'
    'RpbmdfbW9kZRgJIAEoDjIjLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5PcGVyYXRvck1vZGVSCmFj'
    'dGluZ01vZGUSTAoOZXhlY3V0aW9uX3BhdGgYCiABKA4yJS5jcmVhdGl2YW50YS5wdWJsaXNoLn'
    'YxLkV4ZWN1dGlvblBhdGhSDWV4ZWN1dGlvblBhdGgSNAoWY2FwYWJpbGl0eV9zbmFwc2hvdF9p'
    'ZBgLIAEoCVIUY2FwYWJpbGl0eVNuYXBzaG90SWQSUAoNcmVzdWx0X3N0YXR1cxgMIAEoDjIrLm'
    'NyZWF0aXZhbnRhLnB1Ymxpc2gudjEuUHVibGlzaFJlc3VsdFN0YXR1c1IMcmVzdWx0U3RhdHVz'
    'EigKEGV4dGVybmFsX3Bvc3RfaWQYDSABKAlSDmV4dGVybmFsUG9zdElkEioKEWV4dGVybmFsX3'
    'Bvc3RfdXJsGA4gASgJUg9leHRlcm5hbFBvc3RVcmwSJwoPZGlhZ25vc3RpY3NfcmVmGA8gASgJ'
    'Ug5kaWFnbm9zdGljc1JlZhIhCgxldmlkZW5jZV9yZWYYECABKAlSC2V2aWRlbmNlUmVmEh0KCm'
    'Vycm9yX2NvZGUYESABKAlSCWVycm9yQ29kZRIjCg1lcnJvcl9tZXNzYWdlGBIgASgJUgxlcnJv'
    'ck1lc3NhZ2U=');

@$core.Deprecated('Use channelPostDescriptor instead')
const ChannelPost$json = {
  '1': 'ChannelPost',
  '2': [
    {'1': 'channel_post_id', '3': 1, '4': 1, '5': 9, '10': 'channelPostId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'publish_item_id', '3': 3, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'connected_account_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {'1': 'external_post_id', '3': 5, '4': 1, '5': 9, '10': 'externalPostId'},
    {
      '1': 'external_permalink',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'externalPermalink'
    },
    {'1': 'title', '3': 7, '4': 1, '5': 9, '10': 'title'},
    {'1': 'thumbnail_url', '3': 8, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {
      '1': 'synced_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'syncedAt'
    },
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `ChannelPost`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelPostDescriptor = $convert.base64Decode(
    'CgtDaGFubmVsUG9zdBImCg9jaGFubmVsX3Bvc3RfaWQYASABKAlSDWNoYW5uZWxQb3N0SWQSIQ'
    'oMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBImCg9wdWJsaXNoX2l0ZW1faWQYAyAB'
    'KAlSDXB1Ymxpc2hJdGVtSWQSMAoUY29ubmVjdGVkX2FjY291bnRfaWQYBCABKAlSEmNvbm5lY3'
    'RlZEFjY291bnRJZBIoChBleHRlcm5hbF9wb3N0X2lkGAUgASgJUg5leHRlcm5hbFBvc3RJZBIt'
    'ChJleHRlcm5hbF9wZXJtYWxpbmsYBiABKAlSEWV4dGVybmFsUGVybWFsaW5rEhQKBXRpdGxlGA'
    'cgASgJUgV0aXRsZRIjCg10aHVtYm5haWxfdXJsGAggASgJUgx0aHVtYm5haWxVcmwSNwoJc3lu'
    'Y2VkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIc3luY2VkQXQSOQoKY3'
    'JlYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5'
    'Cgp1cGRhdGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZE'
    'F0');

@$core.Deprecated('Use platformCapabilitySummaryDescriptor instead')
const PlatformCapabilitySummary$json = {
  '1': 'PlatformCapabilitySummary',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {
      '1': 'capability_state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.PublishCapabilityState',
      '10': 'capabilityState'
    },
    {'1': 'connector_state', '3': 3, '4': 1, '5': 9, '10': 'connectorState'},
    {
      '1': 'requires_manual_fallback',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'requiresManualFallback'
    },
    {'1': 'policy_summary', '3': 5, '4': 1, '5': 9, '10': 'policySummary'},
    {
      '1': 'fallback_instructions',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'fallbackInstructions'
    },
    {'1': 'required_scopes', '3': 7, '4': 3, '5': 9, '10': 'requiredScopes'},
    {'1': 'executable', '3': 8, '4': 1, '5': 8, '10': 'executable'},
  ],
};

/// Descriptor for `PlatformCapabilitySummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List platformCapabilitySummaryDescriptor = $convert.base64Decode(
    'ChlQbGF0Zm9ybUNhcGFiaWxpdHlTdW1tYXJ5EhoKCHBsYXRmb3JtGAEgASgJUghwbGF0Zm9ybR'
    'JZChBjYXBhYmlsaXR5X3N0YXRlGAIgASgOMi4uY3JlYXRpdmFudGEucHVibGlzaC52MS5QdWJs'
    'aXNoQ2FwYWJpbGl0eVN0YXRlUg9jYXBhYmlsaXR5U3RhdGUSJwoPY29ubmVjdG9yX3N0YXRlGA'
    'MgASgJUg5jb25uZWN0b3JTdGF0ZRI4ChhyZXF1aXJlc19tYW51YWxfZmFsbGJhY2sYBCABKAhS'
    'FnJlcXVpcmVzTWFudWFsRmFsbGJhY2sSJQoOcG9saWN5X3N1bW1hcnkYBSABKAlSDXBvbGljeV'
    'N1bW1hcnkSMwoVZmFsbGJhY2tfaW5zdHJ1Y3Rpb25zGAYgASgJUhRmYWxsYmFja0luc3RydWN0'
    'aW9ucxInCg9yZXF1aXJlZF9zY29wZXMYByADKAlSDnJlcXVpcmVkU2NvcGVzEh4KCmV4ZWN1dG'
    'FibGUYCCABKAhSCmV4ZWN1dGFibGU=');

@$core.Deprecated('Use manualExportPackageDescriptor instead')
const ManualExportPackage$json = {
  '1': 'ManualExportPackage',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'hashtags', '3': 4, '4': 3, '5': 9, '10': 'hashtags'},
    {'1': 'media_url', '3': 5, '4': 1, '5': 9, '10': 'mediaUrl'},
    {'1': 'target_platform', '3': 6, '4': 1, '5': 9, '10': 'targetPlatform'},
    {'1': 'instructions', '3': 7, '4': 1, '5': 9, '10': 'instructions'},
    {
      '1': 'recommended_aspect_ratio',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'recommendedAspectRatio'
    },
  ],
};

/// Descriptor for `ManualExportPackage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List manualExportPackageDescriptor = $convert.base64Decode(
    'ChNNYW51YWxFeHBvcnRQYWNrYWdlEiYKD3B1Ymxpc2hfaXRlbV9pZBgBIAEoCVINcHVibGlzaE'
    'l0ZW1JZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2Ny'
    'aXB0aW9uEhoKCGhhc2h0YWdzGAQgAygJUghoYXNodGFncxIbCgltZWRpYV91cmwYBSABKAlSCG'
    '1lZGlhVXJsEicKD3RhcmdldF9wbGF0Zm9ybRgGIAEoCVIOdGFyZ2V0UGxhdGZvcm0SIgoMaW5z'
    'dHJ1Y3Rpb25zGAcgASgJUgxpbnN0cnVjdGlvbnMSOAoYcmVjb21tZW5kZWRfYXNwZWN0X3JhdG'
    'lvGAggASgJUhZyZWNvbW1lbmRlZEFzcGVjdFJhdGlv');

@$core.Deprecated('Use createItemRequestDescriptor instead')
const CreateItemRequest$json = {
  '1': 'CreateItemRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'target_platform', '3': 3, '4': 1, '5': 9, '10': 'targetPlatform'},
    {'1': 'target_account_id', '3': 4, '4': 1, '5': 9, '10': 'targetAccountId'},
    {'1': 'target_format', '3': 5, '4': 1, '5': 9, '10': 'targetFormat'},
    {
      '1': 'publish_mode',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.PublishMode',
      '10': 'publishMode'
    },
    {'1': 'title', '3': 7, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    {'1': 'hashtags', '3': 9, '4': 3, '5': 9, '10': 'hashtags'},
    {
      '1': 'schedule_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduleAt'
    },
  ],
};

/// Descriptor for `CreateItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createItemRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVJdGVtUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhkKCGFzc2V0X2lkGAIgASgJUgdhc3NldElk'
    'EicKD3RhcmdldF9wbGF0Zm9ybRgDIAEoCVIOdGFyZ2V0UGxhdGZvcm0SKgoRdGFyZ2V0X2FjY2'
    '91bnRfaWQYBCABKAlSD3RhcmdldEFjY291bnRJZBIjCg10YXJnZXRfZm9ybWF0GAUgASgJUgx0'
    'YXJnZXRGb3JtYXQSRgoMcHVibGlzaF9tb2RlGAYgASgOMiMuY3JlYXRpdmFudGEucHVibGlzaC'
    '52MS5QdWJsaXNoTW9kZVILcHVibGlzaE1vZGUSFAoFdGl0bGUYByABKAlSBXRpdGxlEiAKC2Rl'
    'c2NyaXB0aW9uGAggASgJUgtkZXNjcmlwdGlvbhIaCghoYXNodGFncxgJIAMoCVIIaGFzaHRhZ3'
    'MSOwoLc2NoZWR1bGVfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpzY2hl'
    'ZHVsZUF0');

@$core.Deprecated('Use createItemResponseDescriptor instead')
const CreateItemResponse$json = {
  '1': 'CreateItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'capability_summary',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PlatformCapabilitySummary',
      '10': 'capabilitySummary'
    },
  ],
};

/// Descriptor for `CreateItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createItemResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVJdGVtUmVzcG9uc2USNwoEaXRlbRgBIAEoCzIjLmNyZWF0aXZhbnRhLnB1Ymxpc2'
    'gudjEuUHVibGlzaEl0ZW1SBGl0ZW0SYAoSY2FwYWJpbGl0eV9zdW1tYXJ5GAIgASgLMjEuY3Jl'
    'YXRpdmFudGEucHVibGlzaC52MS5QbGF0Zm9ybUNhcGFiaWxpdHlTdW1tYXJ5UhFjYXBhYmlsaX'
    'R5U3VtbWFyeQ==');

@$core.Deprecated('Use scheduleRequestDescriptor instead')
const ScheduleRequest$json = {
  '1': 'ScheduleRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'scheduled_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
  ],
};

/// Descriptor for `ScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleRequestDescriptor = $convert.base64Decode(
    'Cg9TY2hlZHVsZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi'
    '52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBImCg9wdWJsaXNoX2l0ZW1faWQYAiABKAlSDXB1'
    'Ymxpc2hJdGVtSWQSPQoMc2NoZWR1bGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFILc2NoZWR1bGVkQXQ=');

@$core.Deprecated('Use scheduleResponseDescriptor instead')
const ScheduleResponse$json = {
  '1': 'ScheduleResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'job',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishJob',
      '10': 'job'
    },
    {
      '1': 'scheduled_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
    {
      '1': 'jitter_delay_seconds',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'jitterDelaySeconds'
    },
  ],
};

/// Descriptor for `ScheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleResponseDescriptor = $convert.base64Decode(
    'ChBTY2hlZHVsZVJlc3BvbnNlEjcKBGl0ZW0YASABKAsyIy5jcmVhdGl2YW50YS5wdWJsaXNoLn'
    'YxLlB1Ymxpc2hJdGVtUgRpdGVtEjQKA2pvYhgCIAEoCzIiLmNyZWF0aXZhbnRhLnB1Ymxpc2gu'
    'djEuUHVibGlzaEpvYlIDam9iEj0KDHNjaGVkdWxlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSC3NjaGVkdWxlZEF0EjAKFGppdHRlcl9kZWxheV9zZWNvbmRzGAQgASgF'
    'UhJqaXR0ZXJEZWxheVNlY29uZHM=');

@$core.Deprecated('Use executeRequestDescriptor instead')
const ExecuteRequest$json = {
  '1': 'ExecuteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'publish_job_id', '3': 3, '4': 1, '5': 9, '10': 'publishJobId'},
  ],
};

/// Descriptor for `ExecuteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeRequestDescriptor = $convert.base64Decode(
    'Cg5FeGVjdXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiYKD3B1Ymxpc2hfaXRlbV9pZBgCIAEoCVINcHVi'
    'bGlzaEl0ZW1JZBIkCg5wdWJsaXNoX2pvYl9pZBgDIAEoCVIMcHVibGlzaEpvYklk');

@$core.Deprecated('Use executeResponseDescriptor instead')
const ExecuteResponse$json = {
  '1': 'ExecuteResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'job',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishJob',
      '10': 'job'
    },
    {
      '1': 'log',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishLog',
      '10': 'log'
    },
    {
      '1': 'channel_post',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.ChannelPost',
      '10': 'channelPost'
    },
  ],
};

/// Descriptor for `ExecuteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeResponseDescriptor = $convert.base64Decode(
    'Cg9FeGVjdXRlUmVzcG9uc2USNwoEaXRlbRgBIAEoCzIjLmNyZWF0aXZhbnRhLnB1Ymxpc2gudj'
    'EuUHVibGlzaEl0ZW1SBGl0ZW0SNAoDam9iGAIgASgLMiIuY3JlYXRpdmFudGEucHVibGlzaC52'
    'MS5QdWJsaXNoSm9iUgNqb2ISNAoDbG9nGAMgASgLMiIuY3JlYXRpdmFudGEucHVibGlzaC52MS'
    '5QdWJsaXNoTG9nUgNsb2cSRgoMY2hhbm5lbF9wb3N0GAQgASgLMiMuY3JlYXRpdmFudGEucHVi'
    'bGlzaC52MS5DaGFubmVsUG9zdFILY2hhbm5lbFBvc3Q=');

@$core.Deprecated('Use retryRequestDescriptor instead')
const RetryRequest$json = {
  '1': 'RetryRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RetryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryRequestDescriptor = $convert.base64Decode(
    'CgxSZXRyeVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS'
    '5Db21tYW5kQ29udGV4dFIHY29udGV4dBImCg9wdWJsaXNoX2l0ZW1faWQYAiABKAlSDXB1Ymxp'
    'c2hJdGVtSWQSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use retryResponseDescriptor instead')
const RetryResponse$json = {
  '1': 'RetryResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'job',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishJob',
      '10': 'job'
    },
  ],
};

/// Descriptor for `RetryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryResponseDescriptor = $convert.base64Decode(
    'Cg1SZXRyeVJlc3BvbnNlEjcKBGl0ZW0YASABKAsyIy5jcmVhdGl2YW50YS5wdWJsaXNoLnYxLl'
    'B1Ymxpc2hJdGVtUgRpdGVtEjQKA2pvYhgCIAEoCzIiLmNyZWF0aXZhbnRhLnB1Ymxpc2gudjEu'
    'UHVibGlzaEpvYlIDam9i');

@$core.Deprecated('Use cancelRequestDescriptor instead')
const CancelRequest$json = {
  '1': 'CancelRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRequestDescriptor = $convert.base64Decode(
    'Cg1DYW5jZWxSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udj'
    'EuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJgoPcHVibGlzaF9pdGVtX2lkGAIgASgJUg1wdWJs'
    'aXNoSXRlbUlkEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use cancelResponseDescriptor instead')
const CancelResponse$json = {
  '1': 'CancelResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {'1': 'cancelled', '3': 2, '4': 1, '5': 8, '10': 'cancelled'},
  ],
};

/// Descriptor for `CancelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelResponseDescriptor = $convert.base64Decode(
    'Cg5DYW5jZWxSZXNwb25zZRI3CgRpdGVtGAEgASgLMiMuY3JlYXRpdmFudGEucHVibGlzaC52MS'
    '5QdWJsaXNoSXRlbVIEaXRlbRIcCgljYW5jZWxsZWQYAiABKAhSCWNhbmNlbGxlZA==');

@$core.Deprecated('Use listQueueRequestDescriptor instead')
const ListQueueRequest$json = {
  '1': 'ListQueueRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'state_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.PublishItemLifecycleState',
      '10': 'stateFilter'
    },
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

/// Descriptor for `ListQueueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listQueueRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0UXVldWVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSVA'
    'oMc3RhdGVfZmlsdGVyGAIgASgOMjEuY3JlYXRpdmFudGEucHVibGlzaC52MS5QdWJsaXNoSXRl'
    'bUxpZmVjeWNsZVN0YXRlUgtzdGF0ZUZpbHRlchJBCgpwYWdpbmF0aW9uGAMgASgLMiEuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use listQueueResponseDescriptor instead')
const ListQueueResponse$json = {
  '1': 'ListQueueResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'items'
    },
    {
      '1': 'jobs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishJob',
      '10': 'jobs'
    },
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListQueueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listQueueResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UXVldWVSZXNwb25zZRI5CgVpdGVtcxgBIAMoCzIjLmNyZWF0aXZhbnRhLnB1Ymxpc2'
    'gudjEuUHVibGlzaEl0ZW1SBWl0ZW1zEjYKBGpvYnMYAiADKAsyIi5jcmVhdGl2YW50YS5wdWJs'
    'aXNoLnYxLlB1Ymxpc2hKb2JSBGpvYnMSSAoKcGFnaW5hdGlvbhgDIAEoCzIoLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use getLogsRequestDescriptor instead')
const GetLogsRequest$json = {
  '1': 'GetLogsRequest',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `GetLogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLogsRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRMb2dzUmVxdWVzdBImCg9wdWJsaXNoX2l0ZW1faWQYASABKAlSDXB1Ymxpc2hJdGVtSW'
    'QSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9u'
    'UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getLogsResponseDescriptor instead')
const GetLogsResponse$json = {
  '1': 'GetLogsResponse',
  '2': [
    {
      '1': 'logs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishLog',
      '10': 'logs'
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

/// Descriptor for `GetLogsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLogsResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRMb2dzUmVzcG9uc2USNgoEbG9ncxgBIAMoCzIiLmNyZWF0aXZhbnRhLnB1Ymxpc2gudj'
    'EuUHVibGlzaExvZ1IEbG9ncxJICgpwYWdpbmF0aW9uGAIgASgLMiguY3JlYXRpdmFudGEuY29t'
    'bW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getDiagnosticsRequestDescriptor instead')
const GetDiagnosticsRequest$json = {
  '1': 'GetDiagnosticsRequest',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `GetDiagnosticsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDiagnosticsRequestDescriptor = $convert.base64Decode(
    'ChVHZXREaWFnbm9zdGljc1JlcXVlc3QSJgoPcHVibGlzaF9pdGVtX2lkGAEgASgJUg1wdWJsaX'
    'NoSXRlbUlk');

@$core.Deprecated('Use getDiagnosticsResponseDescriptor instead')
const GetDiagnosticsResponse$json = {
  '1': 'GetDiagnosticsResponse',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'diagnostics_state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.publish.v1.DiagnosticsState',
      '10': 'diagnosticsState'
    },
    {'1': 'error_code', '3': 3, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 4, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'repair_recommendation',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'repairRecommendation'
    },
    {'1': 'can_reconnect', '3': 6, '4': 1, '5': 8, '10': 'canReconnect'},
    {
      '1': 'can_manual_fallback',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'canManualFallback'
    },
    {'1': 'can_retry', '3': 8, '4': 1, '5': 8, '10': 'canRetry'},
    {
      '1': 'capability_summary',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PlatformCapabilitySummary',
      '10': 'capabilitySummary'
    },
  ],
};

/// Descriptor for `GetDiagnosticsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDiagnosticsResponseDescriptor = $convert.base64Decode(
    'ChZHZXREaWFnbm9zdGljc1Jlc3BvbnNlEiYKD3B1Ymxpc2hfaXRlbV9pZBgBIAEoCVINcHVibG'
    'lzaEl0ZW1JZBJVChFkaWFnbm9zdGljc19zdGF0ZRgCIAEoDjIoLmNyZWF0aXZhbnRhLnB1Ymxp'
    'c2gudjEuRGlhZ25vc3RpY3NTdGF0ZVIQZGlhZ25vc3RpY3NTdGF0ZRIdCgplcnJvcl9jb2RlGA'
    'MgASgJUgllcnJvckNvZGUSIwoNZXJyb3JfbWVzc2FnZRgEIAEoCVIMZXJyb3JNZXNzYWdlEjMK'
    'FXJlcGFpcl9yZWNvbW1lbmRhdGlvbhgFIAEoCVIUcmVwYWlyUmVjb21tZW5kYXRpb24SIwoNY2'
    'FuX3JlY29ubmVjdBgGIAEoCFIMY2FuUmVjb25uZWN0Ei4KE2Nhbl9tYW51YWxfZmFsbGJhY2sY'
    'ByABKAhSEWNhbk1hbnVhbEZhbGxiYWNrEhsKCWNhbl9yZXRyeRgIIAEoCFIIY2FuUmV0cnkSYA'
    'oSY2FwYWJpbGl0eV9zdW1tYXJ5GAkgASgLMjEuY3JlYXRpdmFudGEucHVibGlzaC52MS5QbGF0'
    'Zm9ybUNhcGFiaWxpdHlTdW1tYXJ5UhFjYXBhYmlsaXR5U3VtbWFyeQ==');

@$core.Deprecated('Use submitManualProofRequestDescriptor instead')
const SubmitManualProofRequest$json = {
  '1': 'SubmitManualProofRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'evidence_url', '3': 3, '4': 1, '5': 9, '10': 'evidenceUrl'},
    {'1': 'external_post_url', '3': 4, '4': 1, '5': 9, '10': 'externalPostUrl'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SubmitManualProofRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitManualProofRequestDescriptor = $convert.base64Decode(
    'ChhTdWJtaXRNYW51YWxQcm9vZlJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBImCg9wdWJsaXNoX2l0ZW1faWQY'
    'AiABKAlSDXB1Ymxpc2hJdGVtSWQSIQoMZXZpZGVuY2VfdXJsGAMgASgJUgtldmlkZW5jZVVybB'
    'IqChFleHRlcm5hbF9wb3N0X3VybBgEIAEoCVIPZXh0ZXJuYWxQb3N0VXJsEhQKBW5vdGVzGAUg'
    'ASgJUgVub3Rlcw==');

@$core.Deprecated('Use submitManualProofResponseDescriptor instead')
const SubmitManualProofResponse$json = {
  '1': 'SubmitManualProofResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'log',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishLog',
      '10': 'log'
    },
    {
      '1': 'channel_post',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.ChannelPost',
      '10': 'channelPost'
    },
    {'1': 'graph_retained', '3': 4, '4': 1, '5': 8, '10': 'graphRetained'},
  ],
};

/// Descriptor for `SubmitManualProofResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitManualProofResponseDescriptor = $convert.base64Decode(
    'ChlTdWJtaXRNYW51YWxQcm9vZlJlc3BvbnNlEjcKBGl0ZW0YASABKAsyIy5jcmVhdGl2YW50YS'
    '5wdWJsaXNoLnYxLlB1Ymxpc2hJdGVtUgRpdGVtEjQKA2xvZxgCIAEoCzIiLmNyZWF0aXZhbnRh'
    'LnB1Ymxpc2gudjEuUHVibGlzaExvZ1IDbG9nEkYKDGNoYW5uZWxfcG9zdBgDIAEoCzIjLmNyZW'
    'F0aXZhbnRhLnB1Ymxpc2gudjEuQ2hhbm5lbFBvc3RSC2NoYW5uZWxQb3N0EiUKDmdyYXBoX3Jl'
    'dGFpbmVkGAQgASgIUg1ncmFwaFJldGFpbmVk');

@$core.Deprecated('Use reconcilePublishRequestDescriptor instead')
const ReconcilePublishRequest$json = {
  '1': 'ReconcilePublishRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'publish_job_id', '3': 3, '4': 1, '5': 9, '10': 'publishJobId'},
    {
      '1': 'provider_request_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'providerRequestId'
    },
  ],
};

/// Descriptor for `ReconcilePublishRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcilePublishRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvbmNpbGVQdWJsaXNoUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiYKD3B1Ymxpc2hfaXRlbV9pZBgC'
    'IAEoCVINcHVibGlzaEl0ZW1JZBIkCg5wdWJsaXNoX2pvYl9pZBgDIAEoCVIMcHVibGlzaEpvYk'
    'lkEi4KE3Byb3ZpZGVyX3JlcXVlc3RfaWQYBCABKAlSEXByb3ZpZGVyUmVxdWVzdElk');

@$core.Deprecated('Use reconcilePublishResponseDescriptor instead')
const ReconcilePublishResponse$json = {
  '1': 'ReconcilePublishResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'job',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishJob',
      '10': 'job'
    },
    {
      '1': 'log',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishLog',
      '10': 'log'
    },
    {'1': 'reconciled', '3': 4, '4': 1, '5': 8, '10': 'reconciled'},
    {
      '1': 'reconciliation_outcome',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'reconciliationOutcome'
    },
  ],
};

/// Descriptor for `ReconcilePublishResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcilePublishResponseDescriptor = $convert.base64Decode(
    'ChhSZWNvbmNpbGVQdWJsaXNoUmVzcG9uc2USNwoEaXRlbRgBIAEoCzIjLmNyZWF0aXZhbnRhLn'
    'B1Ymxpc2gudjEuUHVibGlzaEl0ZW1SBGl0ZW0SNAoDam9iGAIgASgLMiIuY3JlYXRpdmFudGEu'
    'cHVibGlzaC52MS5QdWJsaXNoSm9iUgNqb2ISNAoDbG9nGAMgASgLMiIuY3JlYXRpdmFudGEucH'
    'VibGlzaC52MS5QdWJsaXNoTG9nUgNsb2cSHgoKcmVjb25jaWxlZBgEIAEoCFIKcmVjb25jaWxl'
    'ZBI1ChZyZWNvbmNpbGlhdGlvbl9vdXRjb21lGAUgASgJUhVyZWNvbmNpbGlhdGlvbk91dGNvbW'
    'U=');

@$core.Deprecated('Use exportManualPackageRequestDescriptor instead')
const ExportManualPackageRequest$json = {
  '1': 'ExportManualPackageRequest',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `ExportManualPackageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportManualPackageRequestDescriptor =
    $convert.base64Decode(
        'ChpFeHBvcnRNYW51YWxQYWNrYWdlUmVxdWVzdBImCg9wdWJsaXNoX2l0ZW1faWQYASABKAlSDX'
        'B1Ymxpc2hJdGVtSWQ=');

@$core.Deprecated('Use exportManualPackageResponseDescriptor instead')
const ExportManualPackageResponse$json = {
  '1': 'ExportManualPackageResponse',
  '2': [
    {
      '1': 'package',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.ManualExportPackage',
      '10': 'package'
    },
  ],
};

/// Descriptor for `ExportManualPackageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportManualPackageResponseDescriptor =
    $convert.base64Decode(
        'ChtFeHBvcnRNYW51YWxQYWNrYWdlUmVzcG9uc2USRQoHcGFja2FnZRgBIAEoCzIrLmNyZWF0aX'
        'ZhbnRhLnB1Ymxpc2gudjEuTWFudWFsRXhwb3J0UGFja2FnZVIHcGFja2FnZQ==');

@$core.Deprecated('Use pauseQueueRequestDescriptor instead')
const PauseQueueRequest$json = {
  '1': 'PauseQueueRequest',
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
      '5': 9,
      '10': 'connectedAccountId'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `PauseQueueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseQueueRequestDescriptor = $convert.base64Decode(
    'ChFQYXVzZVF1ZXVlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EjAKFGNvbm5lY3RlZF9hY2NvdW50X2lkGAIg'
    'ASgJUhJjb25uZWN0ZWRBY2NvdW50SWQSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use pauseQueueResponseDescriptor instead')
const PauseQueueResponse$json = {
  '1': 'PauseQueueResponse',
  '2': [
    {'1': 'paused_jobs_count', '3': 1, '4': 1, '5': 5, '10': 'pausedJobsCount'},
    {
      '1': 'paused_publish_item_ids',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'pausedPublishItemIds'
    },
  ],
};

/// Descriptor for `PauseQueueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseQueueResponseDescriptor = $convert.base64Decode(
    'ChJQYXVzZVF1ZXVlUmVzcG9uc2USKgoRcGF1c2VkX2pvYnNfY291bnQYASABKAVSD3BhdXNlZE'
    'pvYnNDb3VudBI1ChdwYXVzZWRfcHVibGlzaF9pdGVtX2lkcxgCIAMoCVIUcGF1c2VkUHVibGlz'
    'aEl0ZW1JZHM=');

@$core.Deprecated('Use getRequestDescriptor instead')
const GetRequest$json = {
  '1': 'GetRequest',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `GetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRequestDescriptor = $convert.base64Decode(
    'CgpHZXRSZXF1ZXN0EiYKD3B1Ymxpc2hfaXRlbV9pZBgBIAEoCVINcHVibGlzaEl0ZW1JZA==');

@$core.Deprecated('Use getResponseDescriptor instead')
const GetResponse$json = {
  '1': 'GetResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'capability_summary',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PlatformCapabilitySummary',
      '10': 'capabilitySummary'
    },
  ],
};

/// Descriptor for `GetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getResponseDescriptor = $convert.base64Decode(
    'CgtHZXRSZXNwb25zZRI3CgRpdGVtGAEgASgLMiMuY3JlYXRpdmFudGEucHVibGlzaC52MS5QdW'
    'JsaXNoSXRlbVIEaXRlbRJgChJjYXBhYmlsaXR5X3N1bW1hcnkYAiABKAsyMS5jcmVhdGl2YW50'
    'YS5wdWJsaXNoLnYxLlBsYXRmb3JtQ2FwYWJpbGl0eVN1bW1hcnlSEWNhcGFiaWxpdHlTdW1tYX'
    'J5');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZUlkEkEKCnBhZ2'
    'luYXRpb24YAiABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGlvblIKcGFnaW5h'
    'dGlvbg==');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'items'
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

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USOQoFaXRlbXMYASADKAsyIy5jcmVhdGl2YW50YS5wdWJsaXNoLnYxLl'
    'B1Ymxpc2hJdGVtUgVpdGVtcxJICgpwYWdpbmF0aW9uGAIgASgLMiguY3JlYXRpdmFudGEuY29t'
    'bW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getDraftRequestDescriptor instead')
const GetDraftRequest$json = {
  '1': 'GetDraftRequest',
  '2': [
    {'1': 'draft_id', '3': 1, '4': 1, '5': 9, '10': 'draftId'},
  ],
};

/// Descriptor for `GetDraftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDraftRequestDescriptor = $convert.base64Decode(
    'Cg9HZXREcmFmdFJlcXVlc3QSGQoIZHJhZnRfaWQYASABKAlSB2RyYWZ0SWQ=');

@$core.Deprecated('Use getDraftResponseDescriptor instead')
const GetDraftResponse$json = {
  '1': 'GetDraftResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `GetDraftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDraftResponseDescriptor = $convert.base64Decode(
    'ChBHZXREcmFmdFJlc3BvbnNlEjcKBGl0ZW0YASABKAsyIy5jcmVhdGl2YW50YS5wdWJsaXNoLn'
    'YxLlB1Ymxpc2hJdGVtUgRpdGVt');

@$core.Deprecated('Use saveDraftRequestDescriptor instead')
const SaveDraftRequest$json = {
  '1': 'SaveDraftRequest',
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
      '1': 'item',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `SaveDraftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveDraftRequestDescriptor = $convert.base64Decode(
    'ChBTYXZlRHJhZnRSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb2'
    '4udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSNwoEaXRlbRgCIAEoCzIjLmNyZWF0aXZhbnRh'
    'LnB1Ymxpc2gudjEuUHVibGlzaEl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use saveDraftResponseDescriptor instead')
const SaveDraftResponse$json = {
  '1': 'SaveDraftResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `SaveDraftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveDraftResponseDescriptor = $convert.base64Decode(
    'ChFTYXZlRHJhZnRSZXNwb25zZRI3CgRpdGVtGAEgASgLMiMuY3JlYXRpdmFudGEucHVibGlzaC'
    '52MS5QdWJsaXNoSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use updateDraftRequestDescriptor instead')
const UpdateDraftRequest$json = {
  '1': 'UpdateDraftRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'hashtags', '3': 5, '4': 3, '5': 9, '10': 'hashtags'},
  ],
};

/// Descriptor for `UpdateDraftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDraftRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVEcmFmdFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBImCg9wdWJsaXNoX2l0ZW1faWQYAiABKAlS'
    'DXB1Ymxpc2hJdGVtSWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGAQgAS'
    'gJUgtkZXNjcmlwdGlvbhIaCghoYXNodGFncxgFIAMoCVIIaGFzaHRhZ3M=');

@$core.Deprecated('Use updateDraftResponseDescriptor instead')
const UpdateDraftResponse$json = {
  '1': 'UpdateDraftResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `UpdateDraftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDraftResponseDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVEcmFmdFJlc3BvbnNlEjcKBGl0ZW0YASABKAsyIy5jcmVhdGl2YW50YS5wdWJsaX'
    'NoLnYxLlB1Ymxpc2hJdGVtUgRpdGVt');

@$core.Deprecated('Use listDraftsRequestDescriptor instead')
const ListDraftsRequest$json = {
  '1': 'ListDraftsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListDraftsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDraftsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0RHJhZnRzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZUlkEk'
    'EKCnBhZ2luYXRpb24YAiABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGlvblIK'
    'cGFnaW5hdGlvbg==');

@$core.Deprecated('Use listDraftsResponseDescriptor instead')
const ListDraftsResponse$json = {
  '1': 'ListDraftsResponse',
  '2': [
    {
      '1': 'drafts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'drafts'
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

/// Descriptor for `ListDraftsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDraftsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0RHJhZnRzUmVzcG9uc2USOwoGZHJhZnRzGAEgAygLMiMuY3JlYXRpdmFudGEucHVibG'
    'lzaC52MS5QdWJsaXNoSXRlbVIGZHJhZnRzEkgKCnBhZ2luYXRpb24YAiABKAsyKC5jcmVhdGl2'
    'YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use publishNowRequestDescriptor instead')
const PublishNowRequest$json = {
  '1': 'PublishNowRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `PublishNowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishNowRequestDescriptor = $convert.base64Decode(
    'ChFQdWJsaXNoTm93UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiYKD3B1Ymxpc2hfaXRlbV9pZBgCIAEoCVIN'
    'cHVibGlzaEl0ZW1JZA==');

@$core.Deprecated('Use publishNowResponseDescriptor instead')
const PublishNowResponse$json = {
  '1': 'PublishNowResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'job',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishJob',
      '10': 'job'
    },
  ],
};

/// Descriptor for `PublishNowResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishNowResponseDescriptor = $convert.base64Decode(
    'ChJQdWJsaXNoTm93UmVzcG9uc2USNwoEaXRlbRgBIAEoCzIjLmNyZWF0aXZhbnRhLnB1Ymxpc2'
    'gudjEuUHVibGlzaEl0ZW1SBGl0ZW0SNAoDam9iGAIgASgLMiIuY3JlYXRpdmFudGEucHVibGlz'
    'aC52MS5QdWJsaXNoSm9iUgNqb2I=');

@$core.Deprecated('Use rescheduleRequestDescriptor instead')
const RescheduleRequest$json = {
  '1': 'RescheduleRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'new_schedule_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'newScheduleAt'
    },
  ],
};

/// Descriptor for `RescheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rescheduleRequestDescriptor = $convert.base64Decode(
    'ChFSZXNjaGVkdWxlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiYKD3B1Ymxpc2hfaXRlbV9pZBgCIAEoCVIN'
    'cHVibGlzaEl0ZW1JZBJCCg9uZXdfc2NoZWR1bGVfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUg1uZXdTY2hlZHVsZUF0');

@$core.Deprecated('Use rescheduleResponseDescriptor instead')
const RescheduleResponse$json = {
  '1': 'RescheduleResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `RescheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rescheduleResponseDescriptor = $convert.base64Decode(
    'ChJSZXNjaGVkdWxlUmVzcG9uc2USNwoEaXRlbRgBIAEoCzIjLmNyZWF0aXZhbnRhLnB1Ymxpc2'
    'gudjEuUHVibGlzaEl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use deleteRequestDescriptor instead')
const DeleteRequest$json = {
  '1': 'DeleteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `DeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRequestDescriptor = $convert.base64Decode(
    'Cg1EZWxldGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udj'
    'EuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJgoPcHVibGlzaF9pdGVtX2lkGAIgASgJUg1wdWJs'
    'aXNoSXRlbUlk');

@$core.Deprecated('Use deleteResponseDescriptor instead')
const DeleteResponse$json = {
  '1': 'DeleteResponse',
  '2': [
    {'1': 'deleted', '3': 1, '4': 1, '5': 8, '10': 'deleted'},
  ],
};

/// Descriptor for `DeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteResponseDescriptor = $convert
    .base64Decode('Cg5EZWxldGVSZXNwb25zZRIYCgdkZWxldGVkGAEgASgIUgdkZWxldGVk');

@$core.Deprecated('Use duplicateRequestDescriptor instead')
const DuplicateRequest$json = {
  '1': 'DuplicateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `DuplicateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List duplicateRequestDescriptor = $convert.base64Decode(
    'ChBEdXBsaWNhdGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb2'
    '4udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJgoPcHVibGlzaF9pdGVtX2lkGAIgASgJUg1w'
    'dWJsaXNoSXRlbUlk');

@$core.Deprecated('Use duplicateResponseDescriptor instead')
const DuplicateResponse$json = {
  '1': 'DuplicateResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `DuplicateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List duplicateResponseDescriptor = $convert.base64Decode(
    'ChFEdXBsaWNhdGVSZXNwb25zZRI3CgRpdGVtGAEgASgLMiMuY3JlYXRpdmFudGEucHVibGlzaC'
    '52MS5QdWJsaXNoSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use pauseRequestDescriptor instead')
const PauseRequest$json = {
  '1': 'PauseRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `PauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseRequestDescriptor = $convert.base64Decode(
    'CgxQYXVzZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS'
    '5Db21tYW5kQ29udGV4dFIHY29udGV4dBImCg9wdWJsaXNoX2l0ZW1faWQYAiABKAlSDXB1Ymxp'
    'c2hJdGVtSWQ=');

@$core.Deprecated('Use pauseResponseDescriptor instead')
const PauseResponse$json = {
  '1': 'PauseResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `PauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseResponseDescriptor = $convert.base64Decode(
    'Cg1QYXVzZVJlc3BvbnNlEjcKBGl0ZW0YASABKAsyIy5jcmVhdGl2YW50YS5wdWJsaXNoLnYxLl'
    'B1Ymxpc2hJdGVtUgRpdGVt');

@$core.Deprecated('Use checkCompatibilityRequestDescriptor instead')
const CheckCompatibilityRequest$json = {
  '1': 'CheckCompatibilityRequest',
  '2': [
    {'1': 'target_platform', '3': 1, '4': 1, '5': 9, '10': 'targetPlatform'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'target_account_id', '3': 3, '4': 1, '5': 9, '10': 'targetAccountId'},
  ],
};

/// Descriptor for `CheckCompatibilityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkCompatibilityRequestDescriptor = $convert.base64Decode(
    'ChlDaGVja0NvbXBhdGliaWxpdHlSZXF1ZXN0EicKD3RhcmdldF9wbGF0Zm9ybRgBIAEoCVIOdG'
    'FyZ2V0UGxhdGZvcm0SGQoIYXNzZXRfaWQYAiABKAlSB2Fzc2V0SWQSKgoRdGFyZ2V0X2FjY291'
    'bnRfaWQYAyABKAlSD3RhcmdldEFjY291bnRJZA==');

@$core.Deprecated('Use checkCompatibilityResponseDescriptor instead')
const CheckCompatibilityResponse$json = {
  '1': 'CheckCompatibilityResponse',
  '2': [
    {
      '1': 'capability_summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PlatformCapabilitySummary',
      '10': 'capabilitySummary'
    },
    {'1': 'compatible', '3': 2, '4': 1, '5': 8, '10': 'compatible'},
    {'1': 'issues', '3': 3, '4': 3, '5': 9, '10': 'issues'},
  ],
};

/// Descriptor for `CheckCompatibilityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkCompatibilityResponseDescriptor = $convert.base64Decode(
    'ChpDaGVja0NvbXBhdGliaWxpdHlSZXNwb25zZRJgChJjYXBhYmlsaXR5X3N1bW1hcnkYASABKA'
    'syMS5jcmVhdGl2YW50YS5wdWJsaXNoLnYxLlBsYXRmb3JtQ2FwYWJpbGl0eVN1bW1hcnlSEWNh'
    'cGFiaWxpdHlTdW1tYXJ5Eh4KCmNvbXBhdGlibGUYAiABKAhSCmNvbXBhdGlibGUSFgoGaXNzdW'
    'VzGAMgAygJUgZpc3N1ZXM=');

@$core.Deprecated('Use updateMetadataRequestDescriptor instead')
const UpdateMetadataRequest$json = {
  '1': 'UpdateMetadataRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'hashtags', '3': 5, '4': 3, '5': 9, '10': 'hashtags'},
  ],
};

/// Descriptor for `UpdateMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMetadataRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVNZXRhZGF0YVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLm'
    'NvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBImCg9wdWJsaXNoX2l0ZW1faWQYAiAB'
    'KAlSDXB1Ymxpc2hJdGVtSWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGA'
    'QgASgJUgtkZXNjcmlwdGlvbhIaCghoYXNodGFncxgFIAMoCVIIaGFzaHRhZ3M=');

@$core.Deprecated('Use updateMetadataResponseDescriptor instead')
const UpdateMetadataResponse$json = {
  '1': 'UpdateMetadataResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `UpdateMetadataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMetadataResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVNZXRhZGF0YVJlc3BvbnNlEjcKBGl0ZW0YASABKAsyIy5jcmVhdGl2YW50YS5wdW'
        'JsaXNoLnYxLlB1Ymxpc2hJdGVtUgRpdGVt');

@$core.Deprecated('Use getCalendarRequestDescriptor instead')
const GetCalendarRequest$json = {
  '1': 'GetCalendarRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'start_date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startDate'
    },
    {
      '1': 'end_date',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endDate'
    },
  ],
};

/// Descriptor for `GetCalendarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCalendarRequestDescriptor = $convert.base64Decode(
    'ChJHZXRDYWxlbmRhclJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZB'
    'I5CgpzdGFydF9kYXRlGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRE'
    'YXRlEjUKCGVuZF9kYXRlGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZW5kRG'
    'F0ZQ==');

@$core.Deprecated('Use calendarEntryDescriptor instead')
const CalendarEntry$json = {
  '1': 'CalendarEntry',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
    {
      '1': 'scheduled_time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledTime'
    },
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `CalendarEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calendarEntryDescriptor = $convert.base64Decode(
    'Cg1DYWxlbmRhckVudHJ5EjcKBGl0ZW0YASABKAsyIy5jcmVhdGl2YW50YS5wdWJsaXNoLnYxLl'
    'B1Ymxpc2hJdGVtUgRpdGVtEkEKDnNjaGVkdWxlZF90aW1lGAIgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFINc2NoZWR1bGVkVGltZRIWCgZzdGF0dXMYAyABKAlSBnN0YXR1cw==');

@$core.Deprecated('Use getCalendarResponseDescriptor instead')
const GetCalendarResponse$json = {
  '1': 'GetCalendarResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.CalendarEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `GetCalendarResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCalendarResponseDescriptor = $convert.base64Decode(
    'ChNHZXRDYWxlbmRhclJlc3BvbnNlEj8KB2VudHJpZXMYASADKAsyJS5jcmVhdGl2YW50YS5wdW'
    'JsaXNoLnYxLkNhbGVuZGFyRW50cnlSB2VudHJpZXM=');

@$core.Deprecated('Use listByDateRangeRequestDescriptor instead')
const ListByDateRangeRequest$json = {
  '1': 'ListByDateRangeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'start_date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startDate'
    },
    {
      '1': 'end_date',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endDate'
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

/// Descriptor for `ListByDateRangeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listByDateRangeRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0QnlEYXRlUmFuZ2VSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSOQoKc3RhcnRfZGF0ZRgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0'
    'YXJ0RGF0ZRI1CghlbmRfZGF0ZRgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2'
    'VuZERhdGUSQQoKcGFnaW5hdGlvbhgEIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdp'
    'bmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listByDateRangeResponseDescriptor instead')
const ListByDateRangeResponse$json = {
  '1': 'ListByDateRangeResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'items'
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

/// Descriptor for `ListByDateRangeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listByDateRangeResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0QnlEYXRlUmFuZ2VSZXNwb25zZRI5CgVpdGVtcxgBIAMoCzIjLmNyZWF0aXZhbnRhLn'
    'B1Ymxpc2gudjEuUHVibGlzaEl0ZW1SBWl0ZW1zEkgKCnBhZ2luYXRpb24YAiABKAsyKC5jcmVh'
    'dGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use listUpcomingRequestDescriptor instead')
const ListUpcomingRequest$json = {
  '1': 'ListUpcomingRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListUpcomingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUpcomingRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0VXBjb21pbmdSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSW'
    'QSFAoFbGltaXQYAiABKAVSBWxpbWl0');

@$core.Deprecated('Use listUpcomingResponseDescriptor instead')
const ListUpcomingResponse$json = {
  '1': 'ListUpcomingResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListUpcomingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUpcomingResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0VXBjb21pbmdSZXNwb25zZRI5CgVpdGVtcxgBIAMoCzIjLmNyZWF0aXZhbnRhLnB1Ym'
    'xpc2gudjEuUHVibGlzaEl0ZW1SBWl0ZW1z');

@$core.Deprecated('Use listPublishedRequestDescriptor instead')
const ListPublishedRequest$json = {
  '1': 'ListPublishedRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListPublishedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPublishedRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0UHVibGlzaGVkUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZU'
    'lkEkEKCnBhZ2luYXRpb24YAiABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGlv'
    'blIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use listPublishedResponseDescriptor instead')
const ListPublishedResponse$json = {
  '1': 'ListPublishedResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'items'
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

/// Descriptor for `ListPublishedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPublishedResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0UHVibGlzaGVkUmVzcG9uc2USOQoFaXRlbXMYASADKAsyIy5jcmVhdGl2YW50YS5wdW'
    'JsaXNoLnYxLlB1Ymxpc2hJdGVtUgVpdGVtcxJICgpwYWdpbmF0aW9uGAIgASgLMiguY3JlYXRp'
    'dmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listPostsRequestDescriptor instead')
const ListPostsRequest$json = {
  '1': 'ListPostsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListPostsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPostsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0UG9zdHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSQQ'
    'oKcGFnaW5hdGlvbhgCIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpw'
    'YWdpbmF0aW9u');

@$core.Deprecated('Use listPostsResponseDescriptor instead')
const ListPostsResponse$json = {
  '1': 'ListPostsResponse',
  '2': [
    {
      '1': 'posts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.ChannelPost',
      '10': 'posts'
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

/// Descriptor for `ListPostsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPostsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UG9zdHNSZXNwb25zZRI5CgVwb3N0cxgBIAMoCzIjLmNyZWF0aXZhbnRhLnB1Ymxpc2'
    'gudjEuQ2hhbm5lbFBvc3RSBXBvc3RzEkgKCnBhZ2luYXRpb24YAiABKAsyKC5jcmVhdGl2YW50'
    'YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use getPlatformStatusRequestDescriptor instead')
const GetPlatformStatusRequest$json = {
  '1': 'GetPlatformStatusRequest',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
  ],
};

/// Descriptor for `GetPlatformStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlatformStatusRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRQbGF0Zm9ybVN0YXR1c1JlcXVlc3QSGgoIcGxhdGZvcm0YASABKAlSCHBsYXRmb3Jt');

@$core.Deprecated('Use getPlatformStatusResponseDescriptor instead')
const GetPlatformStatusResponse$json = {
  '1': 'GetPlatformStatusResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PlatformCapabilitySummary',
      '10': 'status'
    },
  ],
};

/// Descriptor for `GetPlatformStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlatformStatusResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRQbGF0Zm9ybVN0YXR1c1Jlc3BvbnNlEkkKBnN0YXR1cxgBIAEoCzIxLmNyZWF0aXZhbn'
        'RhLnB1Ymxpc2gudjEuUGxhdGZvcm1DYXBhYmlsaXR5U3VtbWFyeVIGc3RhdHVz');

@$core.Deprecated('Use getCrossPostInsightsRequestDescriptor instead')
const GetCrossPostInsightsRequest$json = {
  '1': 'GetCrossPostInsightsRequest',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `GetCrossPostInsightsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCrossPostInsightsRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRDcm9zc1Bvc3RJbnNpZ2h0c1JlcXVlc3QSJgoPcHVibGlzaF9pdGVtX2lkGAEgASgJUg'
        '1wdWJsaXNoSXRlbUlk');

@$core.Deprecated('Use getCrossPostInsightsResponseDescriptor instead')
const GetCrossPostInsightsResponse$json = {
  '1': 'GetCrossPostInsightsResponse',
  '2': [
    {'1': 'publish_item_id', '3': 1, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'posts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.ChannelPost',
      '10': 'posts'
    },
    {'1': 'total_views', '3': 3, '4': 1, '5': 3, '10': 'totalViews'},
    {'1': 'total_likes', '3': 4, '4': 1, '5': 3, '10': 'totalLikes'},
  ],
};

/// Descriptor for `GetCrossPostInsightsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCrossPostInsightsResponseDescriptor = $convert.base64Decode(
    'ChxHZXRDcm9zc1Bvc3RJbnNpZ2h0c1Jlc3BvbnNlEiYKD3B1Ymxpc2hfaXRlbV9pZBgBIAEoCV'
    'INcHVibGlzaEl0ZW1JZBI5CgVwb3N0cxgCIAMoCzIjLmNyZWF0aXZhbnRhLnB1Ymxpc2gudjEu'
    'Q2hhbm5lbFBvc3RSBXBvc3RzEh8KC3RvdGFsX3ZpZXdzGAMgASgDUgp0b3RhbFZpZXdzEh8KC3'
    'RvdGFsX2xpa2VzGAQgASgDUgp0b3RhbExpa2Vz');

@$core.Deprecated('Use publishVariantsRequestDescriptor instead')
const PublishVariantsRequest$json = {
  '1': 'PublishVariantsRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_ids', '3': 2, '4': 3, '5': 9, '10': 'publishItemIds'},
  ],
};

/// Descriptor for `PublishVariantsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishVariantsRequestDescriptor = $convert.base64Decode(
    'ChZQdWJsaXNoVmFyaWFudHNSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS'
    '5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSKAoQcHVibGlzaF9pdGVtX2lkcxgC'
    'IAMoCVIOcHVibGlzaEl0ZW1JZHM=');

@$core.Deprecated('Use publishVariantsResponseDescriptor instead')
const PublishVariantsResponse$json = {
  '1': 'PublishVariantsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'items'
    },
    {
      '1': 'jobs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishJob',
      '10': 'jobs'
    },
  ],
};

/// Descriptor for `PublishVariantsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishVariantsResponseDescriptor = $convert.base64Decode(
    'ChdQdWJsaXNoVmFyaWFudHNSZXNwb25zZRI5CgVpdGVtcxgBIAMoCzIjLmNyZWF0aXZhbnRhLn'
    'B1Ymxpc2gudjEuUHVibGlzaEl0ZW1SBWl0ZW1zEjYKBGpvYnMYAiADKAsyIi5jcmVhdGl2YW50'
    'YS5wdWJsaXNoLnYxLlB1Ymxpc2hKb2JSBGpvYnM=');

@$core.Deprecated('Use holdScheduleRequestDescriptor instead')
const HoldScheduleRequest$json = {
  '1': 'HoldScheduleRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `HoldScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdScheduleRequestDescriptor = $convert.base64Decode(
    'ChNIb2xkU2NoZWR1bGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJgoPcHVibGlzaF9pdGVtX2lkGAIgASgJ'
    'Ug1wdWJsaXNoSXRlbUlk');

@$core.Deprecated('Use holdScheduleResponseDescriptor instead')
const HoldScheduleResponse$json = {
  '1': 'HoldScheduleResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `HoldScheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdScheduleResponseDescriptor = $convert.base64Decode(
    'ChRIb2xkU2NoZWR1bGVSZXNwb25zZRI3CgRpdGVtGAEgASgLMiMuY3JlYXRpdmFudGEucHVibG'
    'lzaC52MS5QdWJsaXNoSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use scheduleRetryRequestDescriptor instead')
const ScheduleRetryRequest$json = {
  '1': 'ScheduleRetryRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'retry_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'retryAt'
    },
  ],
};

/// Descriptor for `ScheduleRetryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleRetryRequestDescriptor = $convert.base64Decode(
    'ChRTY2hlZHVsZVJldHJ5UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY2'
    '9tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiYKD3B1Ymxpc2hfaXRlbV9pZBgCIAEo'
    'CVINcHVibGlzaEl0ZW1JZBI1CghyZXRyeV9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSB3JldHJ5QXQ=');

@$core.Deprecated('Use scheduleRetryResponseDescriptor instead')
const ScheduleRetryResponse$json = {
  '1': 'ScheduleRetryResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `ScheduleRetryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleRetryResponseDescriptor = $convert.base64Decode(
    'ChVTY2hlZHVsZVJldHJ5UmVzcG9uc2USNwoEaXRlbRgBIAEoCzIjLmNyZWF0aXZhbnRhLnB1Ym'
    'xpc2gudjEuUHVibGlzaEl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use tagProductRequestDescriptor instead')
const TagProductRequest$json = {
  '1': 'TagProductRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
  ],
};

/// Descriptor for `TagProductRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tagProductRequestDescriptor = $convert.base64Decode(
    'ChFUYWdQcm9kdWN0UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiYKD3B1Ymxpc2hfaXRlbV9pZBgCIAEoCVIN'
    'cHVibGlzaEl0ZW1JZBIdCgpwcm9kdWN0X2lkGAMgASgJUglwcm9kdWN0SWQ=');

@$core.Deprecated('Use tagProductResponseDescriptor instead')
const TagProductResponse$json = {
  '1': 'TagProductResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `TagProductResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tagProductResponseDescriptor = $convert.base64Decode(
    'ChJUYWdQcm9kdWN0UmVzcG9uc2USNwoEaXRlbRgBIAEoCzIjLmNyZWF0aXZhbnRhLnB1Ymxpc2'
    'gudjEuUHVibGlzaEl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use untagProductRequestDescriptor instead')
const UntagProductRequest$json = {
  '1': 'UntagProductRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'publish_item_id', '3': 2, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
  ],
};

/// Descriptor for `UntagProductRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List untagProductRequestDescriptor = $convert.base64Decode(
    'ChNVbnRhZ1Byb2R1Y3RSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJgoPcHVibGlzaF9pdGVtX2lkGAIgASgJ'
    'Ug1wdWJsaXNoSXRlbUlkEh0KCnByb2R1Y3RfaWQYAyABKAlSCXByb2R1Y3RJZA==');

@$core.Deprecated('Use untagProductResponseDescriptor instead')
const UntagProductResponse$json = {
  '1': 'UntagProductResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.publish.v1.PublishItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `UntagProductResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List untagProductResponseDescriptor = $convert.base64Decode(
    'ChRVbnRhZ1Byb2R1Y3RSZXNwb25zZRI3CgRpdGVtGAEgASgLMiMuY3JlYXRpdmFudGEucHVibG'
    'lzaC52MS5QdWJsaXNoSXRlbVIEaXRlbQ==');

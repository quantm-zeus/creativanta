// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/diagnostics.proto.

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

@$core.Deprecated('Use diagnosticHealthStatusDescriptor instead')
const DiagnosticHealthStatus$json = {
  '1': 'DiagnosticHealthStatus',
  '2': [
    {'1': 'DIAGNOSTIC_HEALTH_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DIAGNOSTIC_HEALTH_STATUS_HEALTHY', '2': 1},
    {'1': 'DIAGNOSTIC_HEALTH_STATUS_WARNING', '2': 2},
    {'1': 'DIAGNOSTIC_HEALTH_STATUS_ERROR', '2': 3},
    {'1': 'DIAGNOSTIC_HEALTH_STATUS_CRITICAL', '2': 4},
  ],
};

/// Descriptor for `DiagnosticHealthStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List diagnosticHealthStatusDescriptor = $convert.base64Decode(
    'ChZEaWFnbm9zdGljSGVhbHRoU3RhdHVzEigKJERJQUdOT1NUSUNfSEVBTFRIX1NUQVRVU19VTl'
    'NQRUNJRklFRBAAEiQKIERJQUdOT1NUSUNfSEVBTFRIX1NUQVRVU19IRUFMVEhZEAESJAogRElB'
    'R05PU1RJQ19IRUFMVEhfU1RBVFVTX1dBUk5JTkcQAhIiCh5ESUFHTk9TVElDX0hFQUxUSF9TVE'
    'FUVVNfRVJST1IQAxIlCiFESUFHTk9TVElDX0hFQUxUSF9TVEFUVVNfQ1JJVElDQUwQBA==');

@$core.Deprecated('Use diagnosticSeverityDescriptor instead')
const DiagnosticSeverity$json = {
  '1': 'DiagnosticSeverity',
  '2': [
    {'1': 'DIAGNOSTIC_SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'DIAGNOSTIC_SEVERITY_INFO', '2': 1},
    {'1': 'DIAGNOSTIC_SEVERITY_WARNING', '2': 2},
    {'1': 'DIAGNOSTIC_SEVERITY_ERROR', '2': 3},
    {'1': 'DIAGNOSTIC_SEVERITY_CRITICAL', '2': 4},
  ],
};

/// Descriptor for `DiagnosticSeverity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List diagnosticSeverityDescriptor = $convert.base64Decode(
    'ChJEaWFnbm9zdGljU2V2ZXJpdHkSIwofRElBR05PU1RJQ19TRVZFUklUWV9VTlNQRUNJRklFRB'
    'AAEhwKGERJQUdOT1NUSUNfU0VWRVJJVFlfSU5GTxABEh8KG0RJQUdOT1NUSUNfU0VWRVJJVFlf'
    'V0FSTklORxACEh0KGURJQUdOT1NUSUNfU0VWRVJJVFlfRVJST1IQAxIgChxESUFHTk9TVElDX1'
    'NFVkVSSVRZX0NSSVRJQ0FMEAQ=');

@$core.Deprecated('Use diagnosticIssueStatusDescriptor instead')
const DiagnosticIssueStatus$json = {
  '1': 'DiagnosticIssueStatus',
  '2': [
    {'1': 'DIAGNOSTIC_ISSUE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DIAGNOSTIC_ISSUE_STATUS_OPEN', '2': 1},
    {'1': 'DIAGNOSTIC_ISSUE_STATUS_ACKNOWLEDGED', '2': 2},
    {'1': 'DIAGNOSTIC_ISSUE_STATUS_RESOLVING', '2': 3},
    {'1': 'DIAGNOSTIC_ISSUE_STATUS_RESOLVED', '2': 4},
    {'1': 'DIAGNOSTIC_ISSUE_STATUS_CLOSED', '2': 5},
  ],
};

/// Descriptor for `DiagnosticIssueStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List diagnosticIssueStatusDescriptor = $convert.base64Decode(
    'ChVEaWFnbm9zdGljSXNzdWVTdGF0dXMSJwojRElBR05PU1RJQ19JU1NVRV9TVEFUVVNfVU5TUE'
    'VDSUZJRUQQABIgChxESUFHTk9TVElDX0lTU1VFX1NUQVRVU19PUEVOEAESKAokRElBR05PU1RJ'
    'Q19JU1NVRV9TVEFUVVNfQUNLTk9XTEVER0VEEAISJQohRElBR05PU1RJQ19JU1NVRV9TVEFUVV'
    'NfUkVTT0xWSU5HEAMSJAogRElBR05PU1RJQ19JU1NVRV9TVEFUVVNfUkVTT0xWRUQQBBIiCh5E'
    'SUFHTk9TVElDX0lTU1VFX1NUQVRVU19DTE9TRUQQBQ==');

@$core.Deprecated('Use repairWizardStepDescriptor instead')
const RepairWizardStep$json = {
  '1': 'RepairWizardStep',
  '2': [
    {'1': 'REPAIR_WIZARD_STEP_UNSPECIFIED', '2': 0},
    {'1': 'REPAIR_WIZARD_STEP_VERIFY', '2': 1},
    {'1': 'REPAIR_WIZARD_STEP_DIAGNOSE', '2': 2},
    {'1': 'REPAIR_WIZARD_STEP_FIX', '2': 3},
    {'1': 'REPAIR_WIZARD_STEP_CONFIRM', '2': 4},
  ],
};

/// Descriptor for `RepairWizardStep`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List repairWizardStepDescriptor = $convert.base64Decode(
    'ChBSZXBhaXJXaXphcmRTdGVwEiIKHlJFUEFJUl9XSVpBUkRfU1RFUF9VTlNQRUNJRklFRBAAEh'
    '0KGVJFUEFJUl9XSVpBUkRfU1RFUF9WRVJJRlkQARIfChtSRVBBSVJfV0laQVJEX1NURVBfRElB'
    'R05PU0UQAhIaChZSRVBBSVJfV0laQVJEX1NURVBfRklYEAMSHgoaUkVQQUlSX1dJWkFSRF9TVE'
    'VQX0NPTkZJUk0QBA==');

@$core.Deprecated('Use getOverviewRequestDescriptor instead')
const GetOverviewRequest$json = {
  '1': 'GetOverviewRequest',
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

/// Descriptor for `GetOverviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOverviewRequestDescriptor = $convert.base64Decode(
    'ChJHZXRPdmVydmlld1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use getOverviewResponseDescriptor instead')
const GetOverviewResponse$json = {
  '1': 'GetOverviewResponse',
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
      '1': 'overall_status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DiagnosticHealthStatus',
      '10': 'overallStatus'
    },
    {
      '1': 'active_issues_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'activeIssuesCount'
    },
    {
      '1': 'critical_issues_count',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'criticalIssuesCount'
    },
    {
      '1': 'warning_issues_count',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'warningIssuesCount'
    },
    {
      '1': 'healthy_categories_count',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'healthyCategoriesCount'
    },
    {
      '1': 'total_categories_count',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'totalCategoriesCount'
    },
    {
      '1': 'unknown_external_effects_count',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'unknownExternalEffectsCount'
    },
    {'1': 'pending_dlq_count', '3': 9, '4': 1, '5': 5, '10': 'pendingDlqCount'},
    {
      '1': 'last_checked_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastCheckedAt'
    },
  ],
};

/// Descriptor for `GetOverviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOverviewResponseDescriptor = $convert.base64Decode(
    'ChNHZXRPdmVydmlld1Jlc3BvbnNlEj4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBJTCg5vdmVyYWxsX3N0YXR1cxgCIAEoDjIs'
    'LmNyZWF0aXZhbnRhLmFkbWluLnYxLkRpYWdub3N0aWNIZWFsdGhTdGF0dXNSDW92ZXJhbGxTdG'
    'F0dXMSLgoTYWN0aXZlX2lzc3Vlc19jb3VudBgDIAEoBVIRYWN0aXZlSXNzdWVzQ291bnQSMgoV'
    'Y3JpdGljYWxfaXNzdWVzX2NvdW50GAQgASgFUhNjcml0aWNhbElzc3Vlc0NvdW50EjAKFHdhcm'
    '5pbmdfaXNzdWVzX2NvdW50GAUgASgFUhJ3YXJuaW5nSXNzdWVzQ291bnQSOAoYaGVhbHRoeV9j'
    'YXRlZ29yaWVzX2NvdW50GAYgASgFUhZoZWFsdGh5Q2F0ZWdvcmllc0NvdW50EjQKFnRvdGFsX2'
    'NhdGVnb3JpZXNfY291bnQYByABKAVSFHRvdGFsQ2F0ZWdvcmllc0NvdW50EkMKHnVua25vd25f'
    'ZXh0ZXJuYWxfZWZmZWN0c19jb3VudBgIIAEoBVIbdW5rbm93bkV4dGVybmFsRWZmZWN0c0NvdW'
    '50EioKEXBlbmRpbmdfZGxxX2NvdW50GAkgASgFUg9wZW5kaW5nRGxxQ291bnQSQgoPbGFzdF9j'
    'aGVja2VkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINbGFzdENoZWNrZW'
    'RBdA==');

@$core.Deprecated('Use getHealthGridRequestDescriptor instead')
const GetHealthGridRequest$json = {
  '1': 'GetHealthGridRequest',
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

/// Descriptor for `GetHealthGridRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthGridRequestDescriptor = $convert.base64Decode(
    'ChRHZXRIZWFsdGhHcmlkUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use healthCategoryCardDescriptor instead')
const HealthCategoryCard$json = {
  '1': 'HealthCategoryCard',
  '2': [
    {'1': 'category_key', '3': 1, '4': 1, '5': 9, '10': 'categoryKey'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DiagnosticHealthStatus',
      '10': 'status'
    },
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'open_issues_count', '3': 5, '4': 1, '5': 5, '10': 'openIssuesCount'},
    {
      '1': 'last_checked_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastCheckedAt'
    },
  ],
};

/// Descriptor for `HealthCategoryCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthCategoryCardDescriptor = $convert.base64Decode(
    'ChJIZWFsdGhDYXRlZ29yeUNhcmQSIQoMY2F0ZWdvcnlfa2V5GAEgASgJUgtjYXRlZ29yeUtleR'
    'IhCgxkaXNwbGF5X25hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEkQKBnN0YXR1cxgDIAEoDjIsLmNy'
    'ZWF0aXZhbnRhLmFkbWluLnYxLkRpYWdub3N0aWNIZWFsdGhTdGF0dXNSBnN0YXR1cxIYCgdzdW'
    '1tYXJ5GAQgASgJUgdzdW1tYXJ5EioKEW9wZW5faXNzdWVzX2NvdW50GAUgASgFUg9vcGVuSXNz'
    'dWVzQ291bnQSQgoPbGFzdF9jaGVja2VkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFINbGFzdENoZWNrZWRBdA==');

@$core.Deprecated('Use getHealthGridResponseDescriptor instead')
const GetHealthGridResponse$json = {
  '1': 'GetHealthGridResponse',
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
      '1': 'categories',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.HealthCategoryCard',
      '10': 'categories'
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

/// Descriptor for `GetHealthGridResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthGridResponseDescriptor = $convert.base64Decode(
    'ChVHZXRIZWFsdGhHcmlkUmVzcG9uc2USPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEkgKCmNhdGVnb3JpZXMYAiADKAsyKC5j'
    'cmVhdGl2YW50YS5hZG1pbi52MS5IZWFsdGhDYXRlZ29yeUNhcmRSCmNhdGVnb3JpZXMSPQoMZ2'
    'VuZXJhdGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZ2VuZXJhdGVk'
    'QXQ=');

@$core.Deprecated('Use listIssuesRequestDescriptor instead')
const ListIssuesRequest$json = {
  '1': 'ListIssuesRequest',
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
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
    {
      '1': 'severity_filter',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DiagnosticSeverity',
      '10': 'severityFilter'
    },
    {
      '1': 'status_filter',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DiagnosticIssueStatus',
      '10': 'statusFilter'
    },
    {'1': 'scope_type_filter', '3': 5, '4': 1, '5': 9, '10': 'scopeTypeFilter'},
  ],
};

/// Descriptor for `ListIssuesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listIssuesRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0SXNzdWVzUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW50YS'
    '5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNyZWF0'
    'aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdpbmF0aW9uElEKD3NldmVyaXR5X2ZpbH'
    'RlchgDIAEoDjIoLmNyZWF0aXZhbnRhLmFkbWluLnYxLkRpYWdub3N0aWNTZXZlcml0eVIOc2V2'
    'ZXJpdHlGaWx0ZXISUAoNc3RhdHVzX2ZpbHRlchgEIAEoDjIrLmNyZWF0aXZhbnRhLmFkbWluLn'
    'YxLkRpYWdub3N0aWNJc3N1ZVN0YXR1c1IMc3RhdHVzRmlsdGVyEioKEXNjb3BlX3R5cGVfZmls'
    'dGVyGAUgASgJUg9zY29wZVR5cGVGaWx0ZXI=');

@$core.Deprecated('Use diagnosticIssueDescriptor instead')
const DiagnosticIssue$json = {
  '1': 'DiagnosticIssue',
  '2': [
    {
      '1': 'diagnostics_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'diagnosticsId'
    },
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'scope_type', '3': 3, '4': 1, '5': 9, '10': 'scopeType'},
    {
      '1': 'scope_id',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'scopeId'
    },
    {'1': 'error_type', '3': 5, '4': 1, '5': 9, '10': 'errorType'},
    {
      '1': 'severity',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DiagnosticSeverity',
      '10': 'severity'
    },
    {
      '1': 'user_facing_explanation',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'userFacingExplanation'
    },
    {'1': 'likely_causes', '3': 8, '4': 3, '5': 9, '10': 'likelyCauses'},
    {
      '1': 'suggested_actions',
      '3': 9,
      '4': 3,
      '5': 9,
      '10': 'suggestedActions'
    },
    {'1': 'repair_path', '3': 10, '4': 1, '5': 9, '10': 'repairPath'},
    {
      '1': 'status',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DiagnosticIssueStatus',
      '10': 'status'
    },
    {
      '1': 'requires_manual_reconciliation',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'requiresManualReconciliation'
    },
    {
      '1': 'detected_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'detectedAt'
    },
    {
      '1': 'resolved_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolvedAt'
    },
  ],
};

/// Descriptor for `DiagnosticIssue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List diagnosticIssueDescriptor = $convert.base64Decode(
    'Cg9EaWFnbm9zdGljSXNzdWUSQgoOZGlhZ25vc3RpY3NfaWQYASABKAsyGy5jcmVhdGl2YW50YS'
    '5jb21tb24udjEuVVVJRFINZGlhZ25vc3RpY3NJZBI+Cgx3b3Jrc3BhY2VfaWQYAiABKAsyGy5j'
    'cmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSHQoKc2NvcGVfdHlwZRgDIA'
    'EoCVIJc2NvcGVUeXBlEjYKCHNjb3BlX2lkGAQgASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYx'
    'LlVVSURSB3Njb3BlSWQSHQoKZXJyb3JfdHlwZRgFIAEoCVIJZXJyb3JUeXBlEkQKCHNldmVyaX'
    'R5GAYgASgOMiguY3JlYXRpdmFudGEuYWRtaW4udjEuRGlhZ25vc3RpY1NldmVyaXR5UghzZXZl'
    'cml0eRI2Chd1c2VyX2ZhY2luZ19leHBsYW5hdGlvbhgHIAEoCVIVdXNlckZhY2luZ0V4cGxhbm'
    'F0aW9uEiMKDWxpa2VseV9jYXVzZXMYCCADKAlSDGxpa2VseUNhdXNlcxIrChFzdWdnZXN0ZWRf'
    'YWN0aW9ucxgJIAMoCVIQc3VnZ2VzdGVkQWN0aW9ucxIfCgtyZXBhaXJfcGF0aBgKIAEoCVIKcm'
    'VwYWlyUGF0aBJDCgZzdGF0dXMYCyABKA4yKy5jcmVhdGl2YW50YS5hZG1pbi52MS5EaWFnbm9z'
    'dGljSXNzdWVTdGF0dXNSBnN0YXR1cxJECh5yZXF1aXJlc19tYW51YWxfcmVjb25jaWxpYXRpb2'
    '4YDCABKAhSHHJlcXVpcmVzTWFudWFsUmVjb25jaWxpYXRpb24SOwoLZGV0ZWN0ZWRfYXQYDSAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpkZXRlY3RlZEF0EjsKC3Jlc29sdmVkX2'
    'F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVzb2x2ZWRBdA==');

@$core.Deprecated('Use listIssuesResponseDescriptor instead')
const ListIssuesResponse$json = {
  '1': 'ListIssuesResponse',
  '2': [
    {
      '1': 'issues',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.DiagnosticIssue',
      '10': 'issues'
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

/// Descriptor for `ListIssuesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listIssuesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0SXNzdWVzUmVzcG9uc2USPQoGaXNzdWVzGAEgAygLMiUuY3JlYXRpdmFudGEuYWRtaW'
    '4udjEuRGlhZ25vc3RpY0lzc3VlUgZpc3N1ZXMSSAoKcGFnaW5hdGlvbhgCIAEoCzIoLmNyZWF0'
    'aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use runFullCheckRequestDescriptor instead')
const RunFullCheckRequest$json = {
  '1': 'RunFullCheckRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
  ],
};

/// Descriptor for `RunFullCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runFullCheckRequestDescriptor = $convert.base64Decode(
    'ChNSdW5GdWxsQ2hlY2tSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQ=');

@$core.Deprecated('Use runFullCheckResponseDescriptor instead')
const RunFullCheckResponse$json = {
  '1': 'RunFullCheckResponse',
  '2': [
    {
      '1': 'check_run_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'checkRunId'
    },
    {
      '1': 'overall_status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DiagnosticHealthStatus',
      '10': 'overallStatus'
    },
    {'1': 'issues_detected', '3': 3, '4': 1, '5': 5, '10': 'issuesDetected'},
    {
      '1': 'unknown_effects_detected',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'unknownEffectsDetected'
    },
    {
      '1': 'categories',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.HealthCategoryCard',
      '10': 'categories'
    },
    {
      '1': 'completed_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'replayed', '3': 7, '4': 1, '5': 8, '10': 'replayed'},
  ],
};

/// Descriptor for `RunFullCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runFullCheckResponseDescriptor = $convert.base64Decode(
    'ChRSdW5GdWxsQ2hlY2tSZXNwb25zZRI9CgxjaGVja19ydW5faWQYASABKAsyGy5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuVVVJRFIKY2hlY2tSdW5JZBJTCg5vdmVyYWxsX3N0YXR1cxgCIAEoDjIs'
    'LmNyZWF0aXZhbnRhLmFkbWluLnYxLkRpYWdub3N0aWNIZWFsdGhTdGF0dXNSDW92ZXJhbGxTdG'
    'F0dXMSJwoPaXNzdWVzX2RldGVjdGVkGAMgASgFUg5pc3N1ZXNEZXRlY3RlZBI4Chh1bmtub3du'
    'X2VmZmVjdHNfZGV0ZWN0ZWQYBCABKAVSFnVua25vd25FZmZlY3RzRGV0ZWN0ZWQSSAoKY2F0ZW'
    'dvcmllcxgFIAMoCzIoLmNyZWF0aXZhbnRhLmFkbWluLnYxLkhlYWx0aENhdGVnb3J5Q2FyZFIK'
    'Y2F0ZWdvcmllcxI9Cgxjb21wbGV0ZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgtjb21wbGV0ZWRBdBIaCghyZXBsYXllZBgHIAEoCFIIcmVwbGF5ZWQ=');

@$core.Deprecated('Use executeRepairStepRequestDescriptor instead')
const ExecuteRepairStepRequest$json = {
  '1': 'ExecuteRepairStepRequest',
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
      '1': 'diagnostics_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'diagnosticsId'
    },
    {
      '1': 'step',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.RepairWizardStep',
      '10': 'step'
    },
    {'1': 'action_key', '3': 4, '4': 1, '5': 9, '10': 'actionKey'},
    {
      '1': 'verification_reference',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'verificationReference'
    },
  ],
};

/// Descriptor for `ExecuteRepairStepRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeRepairStepRequestDescriptor = $convert.base64Decode(
    'ChhFeGVjdXRlUmVwYWlyU3RlcFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBJCCg5kaWFnbm9zdGljc19pZBgC'
    'IAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUg1kaWFnbm9zdGljc0lkEjoKBHN0ZX'
    'AYAyABKA4yJi5jcmVhdGl2YW50YS5hZG1pbi52MS5SZXBhaXJXaXphcmRTdGVwUgRzdGVwEh0K'
    'CmFjdGlvbl9rZXkYBCABKAlSCWFjdGlvbktleRI1ChZ2ZXJpZmljYXRpb25fcmVmZXJlbmNlGA'
    'UgASgJUhV2ZXJpZmljYXRpb25SZWZlcmVuY2U=');

@$core.Deprecated('Use executeRepairStepResponseDescriptor instead')
const ExecuteRepairStepResponse$json = {
  '1': 'ExecuteRepairStepResponse',
  '2': [
    {
      '1': 'diagnostics_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'diagnosticsId'
    },
    {
      '1': 'completed_step',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.RepairWizardStep',
      '10': 'completedStep'
    },
    {
      '1': 'next_step',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.RepairWizardStep',
      '10': 'nextStep'
    },
    {
      '1': 'issue_status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.DiagnosticIssueStatus',
      '10': 'issueStatus'
    },
    {
      '1': 'user_facing_result',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'userFacingResult'
    },
    {'1': 'resolved', '3': 6, '4': 1, '5': 8, '10': 'resolved'},
    {'1': 'replayed', '3': 7, '4': 1, '5': 8, '10': 'replayed'},
    {
      '1': 'updated_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `ExecuteRepairStepResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeRepairStepResponseDescriptor = $convert.base64Decode(
    'ChlFeGVjdXRlUmVwYWlyU3RlcFJlc3BvbnNlEkIKDmRpYWdub3N0aWNzX2lkGAEgASgLMhsuY3'
    'JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSDWRpYWdub3N0aWNzSWQSTQoOY29tcGxldGVkX3N0'
    'ZXAYAiABKA4yJi5jcmVhdGl2YW50YS5hZG1pbi52MS5SZXBhaXJXaXphcmRTdGVwUg1jb21wbG'
    'V0ZWRTdGVwEkMKCW5leHRfc3RlcBgDIAEoDjImLmNyZWF0aXZhbnRhLmFkbWluLnYxLlJlcGFp'
    'cldpemFyZFN0ZXBSCG5leHRTdGVwEk4KDGlzc3VlX3N0YXR1cxgEIAEoDjIrLmNyZWF0aXZhbn'
    'RhLmFkbWluLnYxLkRpYWdub3N0aWNJc3N1ZVN0YXR1c1ILaXNzdWVTdGF0dXMSLAoSdXNlcl9m'
    'YWNpbmdfcmVzdWx0GAUgASgJUhB1c2VyRmFjaW5nUmVzdWx0EhoKCHJlc29sdmVkGAYgASgIUg'
    'hyZXNvbHZlZBIaCghyZXBsYXllZBgHIAEoCFIIcmVwbGF5ZWQSOQoKdXBkYXRlZF9hdBgIIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

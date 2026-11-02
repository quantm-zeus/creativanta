// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/internal_admin.proto.

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

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'totp_code', '3': 3, '4': 1, '5': 9, '10': 'totpCode'},
    {'1': 'ip_address', '3': 4, '4': 1, '5': 9, '10': 'ipAddress'},
    {'1': 'user_agent', '3': 5, '4': 1, '5': 9, '10': 'userAgent'},
    {'1': 'vpn_verified', '3': 6, '4': 1, '5': 8, '10': 'vpnVerified'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZBIbCgl0b3RwX2NvZGUYAyABKAlSCHRvdHBDb2RlEh0KCmlwX2FkZHJlc3MYBCAB'
    'KAlSCWlwQWRkcmVzcxIdCgp1c2VyX2FnZW50GAUgASgJUgl1c2VyQWdlbnQSIQoMdnBuX3Zlcm'
    'lmaWVkGAYgASgIUgt2cG5WZXJpZmllZA==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {
      '1': 'session_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'sessionId'
    },
    {
      '1': 'admin_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'adminId'
    },
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {'1': 'session_token', '3': 4, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'mfa_verified', '3': 5, '4': 1, '5': 8, '10': 'mfaVerified'},
    {'1': 'vpn_verified', '3': 6, '4': 1, '5': 8, '10': 'vpnVerified'},
    {
      '1': 'expires_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEjoKCnNlc3Npb25faWQYASABKAsyGy5jcmVhdGl2YW50YS5jb21tb2'
    '4udjEuVVVJRFIJc2Vzc2lvbklkEjYKCGFkbWluX2lkGAIgASgLMhsuY3JlYXRpdmFudGEuY29t'
    'bW9uLnYxLlVVSURSB2FkbWluSWQSEgoEcm9sZRgDIAEoCVIEcm9sZRIjCg1zZXNzaW9uX3Rva2'
    'VuGAQgASgJUgxzZXNzaW9uVG9rZW4SIQoMbWZhX3ZlcmlmaWVkGAUgASgIUgttZmFWZXJpZmll'
    'ZBIhCgx2cG5fdmVyaWZpZWQYBiABKAhSC3ZwblZlcmlmaWVkEjkKCmV4cGlyZXNfYXQYByABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglleHBpcmVzQXQ=');

@$core.Deprecated('Use impersonateRequestDescriptor instead')
const ImpersonateRequest$json = {
  '1': 'ImpersonateRequest',
  '2': [
    {
      '1': 'target_user_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'targetUserId'
    },
    {
      '1': 'target_workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'targetWorkspaceId'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'support_ticket_id', '3': 4, '4': 1, '5': 9, '10': 'supportTicketId'},
    {'1': 'idempotency_key', '3': 5, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `ImpersonateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List impersonateRequestDescriptor = $convert.base64Decode(
    'ChJJbXBlcnNvbmF0ZVJlcXVlc3QSQQoOdGFyZ2V0X3VzZXJfaWQYASABKAsyGy5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuVVVJRFIMdGFyZ2V0VXNlcklkEksKE3RhcmdldF93b3Jrc3BhY2VfaWQY'
    'AiABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFIRdGFyZ2V0V29ya3NwYWNlSWQSFg'
    'oGcmVhc29uGAMgASgJUgZyZWFzb24SKgoRc3VwcG9ydF90aWNrZXRfaWQYBCABKAlSD3N1cHBv'
    'cnRUaWNrZXRJZBInCg9pZGVtcG90ZW5jeV9rZXkYBSABKAlSDmlkZW1wb3RlbmN5S2V5');

@$core.Deprecated('Use impersonateResponseDescriptor instead')
const ImpersonateResponse$json = {
  '1': 'ImpersonateResponse',
  '2': [
    {
      '1': 'impersonation_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'impersonationId'
    },
    {
      '1': 'admin_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'adminId'
    },
    {
      '1': 'target_user_id',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'targetUserId'
    },
    {
      '1': 'target_workspace_id',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'targetWorkspaceId'
    },
    {'1': 'mode', '3': 5, '4': 1, '5': 9, '10': 'mode'},
    {
      '1': 'started_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'expires_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {'1': 'replayed', '3': 8, '4': 1, '5': 8, '10': 'replayed'},
  ],
};

/// Descriptor for `ImpersonateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List impersonateResponseDescriptor = $convert.base64Decode(
    'ChNJbXBlcnNvbmF0ZVJlc3BvbnNlEkYKEGltcGVyc29uYXRpb25faWQYASABKAsyGy5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuVVVJRFIPaW1wZXJzb25hdGlvbklkEjYKCGFkbWluX2lkGAIgASgL'
    'MhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSB2FkbWluSWQSQQoOdGFyZ2V0X3VzZXJfaW'
    'QYAyABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFIMdGFyZ2V0VXNlcklkEksKE3Rh'
    'cmdldF93b3Jrc3BhY2VfaWQYBCABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFIRdG'
    'FyZ2V0V29ya3NwYWNlSWQSEgoEbW9kZRgFIAEoCVIEbW9kZRI5CgpzdGFydGVkX2F0GAYgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0EjkKCmV4cGlyZXNfYXQYBy'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglleHBpcmVzQXQSGgoIcmVwbGF5ZWQY'
    'CCABKAhSCHJlcGxheWVk');

@$core.Deprecated('Use endImpersonationRequestDescriptor instead')
const EndImpersonationRequest$json = {
  '1': 'EndImpersonationRequest',
  '2': [
    {
      '1': 'impersonation_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'impersonationId'
    },
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `EndImpersonationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endImpersonationRequestDescriptor = $convert.base64Decode(
    'ChdFbmRJbXBlcnNvbmF0aW9uUmVxdWVzdBJGChBpbXBlcnNvbmF0aW9uX2lkGAEgASgLMhsuY3'
    'JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSD2ltcGVyc29uYXRpb25JZBIWCgZyZWFzb24YAiAB'
    'KAlSBnJlYXNvbg==');

@$core.Deprecated('Use endImpersonationResponseDescriptor instead')
const EndImpersonationResponse$json = {
  '1': 'EndImpersonationResponse',
  '2': [
    {
      '1': 'impersonation_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'impersonationId'
    },
    {
      '1': 'ended_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
  ],
};

/// Descriptor for `EndImpersonationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endImpersonationResponseDescriptor = $convert.base64Decode(
    'ChhFbmRJbXBlcnNvbmF0aW9uUmVzcG9uc2USRgoQaW1wZXJzb25hdGlvbl9pZBgBIAEoCzIbLm'
    'NyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUg9pbXBlcnNvbmF0aW9uSWQSNQoIZW5kZWRfYXQY'
    'AiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdlbmRlZEF0');

@$core.Deprecated('Use moderationCaseItemDescriptor instead')
const ModerationCaseItem$json = {
  '1': 'ModerationCaseItem',
  '2': [
    {
      '1': 'case_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'caseId'
    },
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'content_type', '3': 3, '4': 1, '5': 9, '10': 'contentType'},
    {
      '1': 'content_id',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'contentId'
    },
    {'1': 'flag_reason', '3': 5, '4': 1, '5': 9, '10': 'flagReason'},
    {'1': 'flag_source', '3': 6, '4': 1, '5': 9, '10': 'flagSource'},
    {'1': 'risk_score', '3': 7, '4': 1, '5': 5, '10': 'riskScore'},
    {'1': 'is_hard_block', '3': 8, '4': 1, '5': 8, '10': 'isHardBlock'},
    {'1': 'status', '3': 9, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'assigned_admin_id',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'assignedAdminId'
    },
    {'1': 'decision_reason', '3': 11, '4': 1, '5': 9, '10': 'decisionReason'},
    {
      '1': 'sla_deadline',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'slaDeadline'
    },
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'decided_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'decidedAt'
    },
  ],
};

/// Descriptor for `ModerationCaseItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moderationCaseItemDescriptor = $convert.base64Decode(
    'ChJNb2RlcmF0aW9uQ2FzZUl0ZW0SNAoHY2FzZV9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5VVUlEUgZjYXNlSWQSPgoMd29ya3NwYWNlX2lkGAIgASgLMhsuY3JlYXRpdmFudGEu'
    'Y29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEiEKDGNvbnRlbnRfdHlwZRgDIAEoCVILY29udG'
    'VudFR5cGUSOgoKY29udGVudF9pZBgEIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlE'
    'Ugljb250ZW50SWQSHwoLZmxhZ19yZWFzb24YBSABKAlSCmZsYWdSZWFzb24SHwoLZmxhZ19zb3'
    'VyY2UYBiABKAlSCmZsYWdTb3VyY2USHQoKcmlza19zY29yZRgHIAEoBVIJcmlza1Njb3JlEiIK'
    'DWlzX2hhcmRfYmxvY2sYCCABKAhSC2lzSGFyZEJsb2NrEhYKBnN0YXR1cxgJIAEoCVIGc3RhdH'
    'VzEkcKEWFzc2lnbmVkX2FkbWluX2lkGAogASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVV'
    'SURSD2Fzc2lnbmVkQWRtaW5JZBInCg9kZWNpc2lvbl9yZWFzb24YCyABKAlSDmRlY2lzaW9uUm'
    'Vhc29uEj0KDHNsYV9kZWFkbGluZRgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'C3NsYURlYWRsaW5lEjkKCmNyZWF0ZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgljcmVhdGVkQXQSOQoKZGVjaWRlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCWRlY2lkZWRBdA==');

@$core.Deprecated('Use listCasesRequestDescriptor instead')
const ListCasesRequest$json = {
  '1': 'ListCasesRequest',
  '2': [
    {'1': 'status_filter', '3': 1, '4': 1, '5': 9, '10': 'statusFilter'},
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

/// Descriptor for `ListCasesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCasesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Q2FzZXNSZXF1ZXN0EiMKDXN0YXR1c19maWx0ZXIYASABKAlSDHN0YXR1c0ZpbHRlch'
    'JBCgpwYWdpbmF0aW9uGAIgASgLMiEuY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRpb25S'
    'CnBhZ2luYXRpb24=');

@$core.Deprecated('Use listCasesResponseDescriptor instead')
const ListCasesResponse$json = {
  '1': 'ListCasesResponse',
  '2': [
    {
      '1': 'cases',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.ModerationCaseItem',
      '10': 'cases'
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

/// Descriptor for `ListCasesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCasesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Q2FzZXNSZXNwb25zZRI+CgVjYXNlcxgBIAMoCzIoLmNyZWF0aXZhbnRhLmFkbWluLn'
    'YxLk1vZGVyYXRpb25DYXNlSXRlbVIFY2FzZXMSSAoKcGFnaW5hdGlvbhgCIAEoCzIoLmNyZWF0'
    'aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use actOnCaseRequestDescriptor instead')
const ActOnCaseRequest$json = {
  '1': 'ActOnCaseRequest',
  '2': [
    {
      '1': 'case_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'caseId'
    },
    {'1': 'decision', '3': 2, '4': 1, '5': 9, '10': 'decision'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'evidence_reference',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'evidenceReference'
    },
    {'1': 'idempotency_key', '3': 5, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `ActOnCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actOnCaseRequestDescriptor = $convert.base64Decode(
    'ChBBY3RPbkNhc2VSZXF1ZXN0EjQKB2Nhc2VfaWQYASABKAsyGy5jcmVhdGl2YW50YS5jb21tb2'
    '4udjEuVVVJRFIGY2FzZUlkEhoKCGRlY2lzaW9uGAIgASgJUghkZWNpc2lvbhIWCgZyZWFzb24Y'
    'AyABKAlSBnJlYXNvbhItChJldmlkZW5jZV9yZWZlcmVuY2UYBCABKAlSEWV2aWRlbmNlUmVmZX'
    'JlbmNlEicKD2lkZW1wb3RlbmN5X2tleRgFIAEoCVIOaWRlbXBvdGVuY3lLZXk=');

@$core.Deprecated('Use actOnCaseResponseDescriptor instead')
const ActOnCaseResponse$json = {
  '1': 'ActOnCaseResponse',
  '2': [
    {
      '1': 'moderation_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.ModerationCaseItem',
      '10': 'moderationCase'
    },
    {
      '1': 'audit_log_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'auditLogId'
    },
    {'1': 'replayed', '3': 3, '4': 1, '5': 8, '10': 'replayed'},
  ],
};

/// Descriptor for `ActOnCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actOnCaseResponseDescriptor = $convert.base64Decode(
    'ChFBY3RPbkNhc2VSZXNwb25zZRJRCg9tb2RlcmF0aW9uX2Nhc2UYASABKAsyKC5jcmVhdGl2YW'
    '50YS5hZG1pbi52MS5Nb2RlcmF0aW9uQ2FzZUl0ZW1SDm1vZGVyYXRpb25DYXNlEj0KDGF1ZGl0'
    'X2xvZ19pZBgCIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgphdWRpdExvZ0lkEh'
    'oKCHJlcGxheWVkGAMgASgIUghyZXBsYXllZA==');

@$core.Deprecated('Use featureFlagItemDescriptor instead')
const FeatureFlagItem$json = {
  '1': 'FeatureFlagItem',
  '2': [
    {
      '1': 'flag_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'flagId'
    },
    {'1': 'flag_key', '3': 2, '4': 1, '5': 9, '10': 'flagKey'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
    {'1': 'percentage', '3': 6, '4': 1, '5': 5, '10': 'percentage'},
    {'1': 'is_kill_switch', '3': 7, '4': 1, '5': 8, '10': 'isKillSwitch'},
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

/// Descriptor for `FeatureFlagItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureFlagItemDescriptor = $convert.base64Decode(
    'Cg9GZWF0dXJlRmxhZ0l0ZW0SNAoHZmxhZ19pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi'
    '52MS5VVUlEUgZmbGFnSWQSGQoIZmxhZ19rZXkYAiABKAlSB2ZsYWdLZXkSEgoEbmFtZRgDIAEo'
    'CVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SFgoGc3RhdHVzGAUgAS'
    'gJUgZzdGF0dXMSHgoKcGVyY2VudGFnZRgGIAEoBVIKcGVyY2VudGFnZRIkCg5pc19raWxsX3N3'
    'aXRjaBgHIAEoCFIMaXNLaWxsU3dpdGNoEjkKCnVwZGF0ZWRfYXQYCCABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use getDashboardRequestDescriptor instead')
const GetDashboardRequest$json = {
  '1': 'GetDashboardRequest',
};

/// Descriptor for `GetDashboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardRequestDescriptor =
    $convert.base64Decode('ChNHZXREYXNoYm9hcmRSZXF1ZXN0');

@$core.Deprecated('Use getDashboardResponseDescriptor instead')
const GetDashboardResponse$json = {
  '1': 'GetDashboardResponse',
  '2': [
    {'1': 'maintenance_mode', '3': 1, '4': 1, '5': 8, '10': 'maintenanceMode'},
    {
      '1': 'active_kill_switches_count',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'activeKillSwitchesCount'
    },
    {
      '1': 'pending_moderation_cases_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'pendingModerationCasesCount'
    },
    {
      '1': 'active_impersonation_sessions_count',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'activeImpersonationSessionsCount'
    },
    {
      '1': 'audit_log_entries_count',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'auditLogEntriesCount'
    },
    {
      '1': 'generated_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'generatedAt'
    },
  ],
};

/// Descriptor for `GetDashboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardResponseDescriptor = $convert.base64Decode(
    'ChRHZXREYXNoYm9hcmRSZXNwb25zZRIpChBtYWludGVuYW5jZV9tb2RlGAEgASgIUg9tYWludG'
    'VuYW5jZU1vZGUSOwoaYWN0aXZlX2tpbGxfc3dpdGNoZXNfY291bnQYAiABKAVSF2FjdGl2ZUtp'
    'bGxTd2l0Y2hlc0NvdW50EkMKHnBlbmRpbmdfbW9kZXJhdGlvbl9jYXNlc19jb3VudBgDIAEoBV'
    'IbcGVuZGluZ01vZGVyYXRpb25DYXNlc0NvdW50Ek0KI2FjdGl2ZV9pbXBlcnNvbmF0aW9uX3Nl'
    'c3Npb25zX2NvdW50GAQgASgFUiBhY3RpdmVJbXBlcnNvbmF0aW9uU2Vzc2lvbnNDb3VudBI1Ch'
    'dhdWRpdF9sb2dfZW50cmllc19jb3VudBgFIAEoBVIUYXVkaXRMb2dFbnRyaWVzQ291bnQSPQoM'
    'Z2VuZXJhdGVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZ2VuZXJhdG'
    'VkQXQ=');

@$core.Deprecated('Use toggleFlagRequestDescriptor instead')
const ToggleFlagRequest$json = {
  '1': 'ToggleFlagRequest',
  '2': [
    {'1': 'flag_key', '3': 1, '4': 1, '5': 9, '10': 'flagKey'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'percentage', '3': 3, '4': 1, '5': 5, '10': 'percentage'},
    {'1': 'is_kill_switch', '3': 4, '4': 1, '5': 8, '10': 'isKillSwitch'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'idempotency_key', '3': 6, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `ToggleFlagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleFlagRequestDescriptor = $convert.base64Decode(
    'ChFUb2dnbGVGbGFnUmVxdWVzdBIZCghmbGFnX2tleRgBIAEoCVIHZmxhZ0tleRIWCgZzdGF0dX'
    'MYAiABKAlSBnN0YXR1cxIeCgpwZXJjZW50YWdlGAMgASgFUgpwZXJjZW50YWdlEiQKDmlzX2tp'
    'bGxfc3dpdGNoGAQgASgIUgxpc0tpbGxTd2l0Y2gSFgoGcmVhc29uGAUgASgJUgZyZWFzb24SJw'
    'oPaWRlbXBvdGVuY3lfa2V5GAYgASgJUg5pZGVtcG90ZW5jeUtleQ==');

@$core.Deprecated('Use toggleFlagResponseDescriptor instead')
const ToggleFlagResponse$json = {
  '1': 'ToggleFlagResponse',
  '2': [
    {
      '1': 'flag',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.FeatureFlagItem',
      '10': 'flag'
    },
    {
      '1': 'audit_log_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'auditLogId'
    },
    {'1': 'replayed', '3': 3, '4': 1, '5': 8, '10': 'replayed'},
  ],
};

/// Descriptor for `ToggleFlagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleFlagResponseDescriptor = $convert.base64Decode(
    'ChJUb2dnbGVGbGFnUmVzcG9uc2USOQoEZmxhZxgBIAEoCzIlLmNyZWF0aXZhbnRhLmFkbWluLn'
    'YxLkZlYXR1cmVGbGFnSXRlbVIEZmxhZxI9CgxhdWRpdF9sb2dfaWQYAiABKAsyGy5jcmVhdGl2'
    'YW50YS5jb21tb24udjEuVVVJRFIKYXVkaXRMb2dJZBIaCghyZXBsYXllZBgDIAEoCFIIcmVwbG'
    'F5ZWQ=');

@$core.Deprecated('Use toggleMaintenanceRequestDescriptor instead')
const ToggleMaintenanceRequest$json = {
  '1': 'ToggleMaintenanceRequest',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `ToggleMaintenanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleMaintenanceRequestDescriptor = $convert.base64Decode(
    'ChhUb2dnbGVNYWludGVuYW5jZVJlcXVlc3QSGAoHZW5hYmxlZBgBIAEoCFIHZW5hYmxlZBIWCg'
    'ZyZWFzb24YAiABKAlSBnJlYXNvbhInCg9pZGVtcG90ZW5jeV9rZXkYAyABKAlSDmlkZW1wb3Rl'
    'bmN5S2V5');

@$core.Deprecated('Use toggleMaintenanceResponseDescriptor instead')
const ToggleMaintenanceResponse$json = {
  '1': 'ToggleMaintenanceResponse',
  '2': [
    {'1': 'maintenance_mode', '3': 1, '4': 1, '5': 8, '10': 'maintenanceMode'},
    {
      '1': 'audit_log_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'auditLogId'
    },
    {'1': 'replayed', '3': 3, '4': 1, '5': 8, '10': 'replayed'},
    {
      '1': 'updated_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `ToggleMaintenanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleMaintenanceResponseDescriptor = $convert.base64Decode(
    'ChlUb2dnbGVNYWludGVuYW5jZVJlc3BvbnNlEikKEG1haW50ZW5hbmNlX21vZGUYASABKAhSD2'
    '1haW50ZW5hbmNlTW9kZRI9CgxhdWRpdF9sb2dfaWQYAiABKAsyGy5jcmVhdGl2YW50YS5jb21t'
    'b24udjEuVVVJRFIKYXVkaXRMb2dJZBIaCghyZXBsYXllZBgDIAEoCFIIcmVwbGF5ZWQSOQoKdX'
    'BkYXRlZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

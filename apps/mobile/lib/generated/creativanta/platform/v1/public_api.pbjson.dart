// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/public_api.proto.

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

@$core.Deprecated('Use aPIKeyStatusDescriptor instead')
const APIKeyStatus$json = {
  '1': 'APIKeyStatus',
  '2': [
    {'1': 'API_KEY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'API_KEY_STATUS_ACTIVE', '2': 1},
    {'1': 'API_KEY_STATUS_ROTATING', '2': 2},
    {'1': 'API_KEY_STATUS_SUSPENDED', '2': 3},
    {'1': 'API_KEY_STATUS_REVOKED', '2': 4},
    {'1': 'API_KEY_STATUS_EXPIRED', '2': 5},
  ],
};

/// Descriptor for `APIKeyStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List aPIKeyStatusDescriptor = $convert.base64Decode(
    'CgxBUElLZXlTdGF0dXMSHgoaQVBJX0tFWV9TVEFUVVNfVU5TUEVDSUZJRUQQABIZChVBUElfS0'
    'VZX1NUQVRVU19BQ1RJVkUQARIbChdBUElfS0VZX1NUQVRVU19ST1RBVElORxACEhwKGEFQSV9L'
    'RVlfU1RBVFVTX1NVU1BFTkRFRBADEhoKFkFQSV9LRVlfU1RBVFVTX1JFVk9LRUQQBBIaChZBUE'
    'lfS0VZX1NUQVRVU19FWFBJUkVEEAU=');

@$core.Deprecated('Use webhookSubscriptionStatusDescriptor instead')
const WebhookSubscriptionStatus$json = {
  '1': 'WebhookSubscriptionStatus',
  '2': [
    {'1': 'WEBHOOK_SUBSCRIPTION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE', '2': 1},
    {'1': 'WEBHOOK_SUBSCRIPTION_STATUS_SUSPENDED', '2': 2},
    {'1': 'WEBHOOK_SUBSCRIPTION_STATUS_REVOKED', '2': 3},
  ],
};

/// Descriptor for `WebhookSubscriptionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List webhookSubscriptionStatusDescriptor = $convert.base64Decode(
    'ChlXZWJob29rU3Vic2NyaXB0aW9uU3RhdHVzEisKJ1dFQkhPT0tfU1VCU0NSSVBUSU9OX1NUQV'
    'RVU19VTlNQRUNJRklFRBAAEiYKIldFQkhPT0tfU1VCU0NSSVBUSU9OX1NUQVRVU19BQ1RJVkUQ'
    'ARIpCiVXRUJIT09LX1NVQlNDUklQVElPTl9TVEFUVVNfU1VTUEVOREVEEAISJwojV0VCSE9PS1'
    '9TVUJTQ1JJUFRJT05fU1RBVFVTX1JFVk9LRUQQAw==');

@$core.Deprecated('Use aPIKeyDescriptor instead')
const APIKey$json = {
  '1': 'APIKey',
  '2': [
    {'1': 'api_key_id', '3': 1, '4': 1, '5': 9, '10': 'apiKeyId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'key_prefix', '3': 3, '4': 1, '5': 9, '10': 'keyPrefix'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'scopes', '3': 5, '4': 3, '5': 9, '10': 'scopes'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.APIKeyStatus',
      '10': 'status'
    },
    {'1': 'logical_key_id', '3': 7, '4': 1, '5': 9, '10': 'logicalKeyId'},
    {
      '1': 'replaced_by_key_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'replacedByKeyId'
    },
    {
      '1': 'rotation_grace_ends_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'rotationGraceEndsAt'
    },
    {
      '1': 'last_used_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastUsedAt'
    },
    {'1': 'request_count', '3': 11, '4': 1, '5': 3, '10': 'requestCount'},
    {
      '1': 'rate_limit_override',
      '3': 12,
      '4': 1,
      '5': 5,
      '10': 'rateLimitOverride'
    },
    {
      '1': 'expires_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {'1': 'created_by', '3': 14, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'suspended_reason', '3': 15, '4': 1, '5': 9, '10': 'suspendedReason'},
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
    {'1': 'secret_key', '3': 18, '4': 1, '5': 9, '10': 'secretKey'},
  ],
};

/// Descriptor for `APIKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List aPIKeyDescriptor = $convert.base64Decode(
    'CgZBUElLZXkSHAoKYXBpX2tleV9pZBgBIAEoCVIIYXBpS2V5SWQSIQoMd29ya3NwYWNlX2lkGA'
    'IgASgJUgt3b3Jrc3BhY2VJZBIdCgprZXlfcHJlZml4GAMgASgJUglrZXlQcmVmaXgSEgoEbmFt'
    'ZRgEIAEoCVIEbmFtZRIWCgZzY29wZXMYBSADKAlSBnNjb3BlcxI9CgZzdGF0dXMYBiABKA4yJS'
    '5jcmVhdGl2YW50YS5wbGF0Zm9ybS52MS5BUElLZXlTdGF0dXNSBnN0YXR1cxIkCg5sb2dpY2Fs'
    'X2tleV9pZBgHIAEoCVIMbG9naWNhbEtleUlkEisKEnJlcGxhY2VkX2J5X2tleV9pZBgIIAEoCV'
    'IPcmVwbGFjZWRCeUtleUlkEk8KFnJvdGF0aW9uX2dyYWNlX2VuZHNfYXQYCSABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUhNyb3RhdGlvbkdyYWNlRW5kc0F0EjwKDGxhc3RfdXNlZF'
    '9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmxhc3RVc2VkQXQSIwoNcmVx'
    'dWVzdF9jb3VudBgLIAEoA1IMcmVxdWVzdENvdW50Ei4KE3JhdGVfbGltaXRfb3ZlcnJpZGUYDC'
    'ABKAVSEXJhdGVMaW1pdE92ZXJyaWRlEjkKCmV4cGlyZXNfYXQYDSABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUglleHBpcmVzQXQSHQoKY3JlYXRlZF9ieRgOIAEoCVIJY3JlYXRlZE'
    'J5EikKEHN1c3BlbmRlZF9yZWFzb24YDyABKAlSD3N1c3BlbmRlZFJlYXNvbhI5CgpjcmVhdGVk'
    'X2F0GBAgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZG'
    'F0ZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSHQoK'
    'c2VjcmV0X2tleRgSIAEoCVIJc2VjcmV0S2V5');

@$core.Deprecated('Use createRequestDescriptor instead')
const CreateRequest$json = {
  '1': 'CreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'scopes', '3': 3, '4': 3, '5': 9, '10': 'scopes'},
    {
      '1': 'rate_limit_override',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'rateLimitOverride'
    },
    {'1': 'expiry_days', '3': 5, '4': 1, '5': 5, '10': 'expiryDays'},
  ],
};

/// Descriptor for `CreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRequestDescriptor = $convert.base64Decode(
    'Cg1DcmVhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSEgoEbm'
    'FtZRgCIAEoCVIEbmFtZRIWCgZzY29wZXMYAyADKAlSBnNjb3BlcxIuChNyYXRlX2xpbWl0X292'
    'ZXJyaWRlGAQgASgFUhFyYXRlTGltaXRPdmVycmlkZRIfCgtleHBpcnlfZGF5cxgFIAEoBVIKZX'
    'hwaXJ5RGF5cw==');

@$core.Deprecated('Use createResponseDescriptor instead')
const CreateResponse$json = {
  '1': 'CreateResponse',
  '2': [
    {
      '1': 'api_key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.APIKey',
      '10': 'apiKey'
    },
    {'1': 'secret_key', '3': 2, '4': 1, '5': 9, '10': 'secretKey'},
  ],
};

/// Descriptor for `CreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createResponseDescriptor = $convert.base64Decode(
    'Cg5DcmVhdGVSZXNwb25zZRI4CgdhcGlfa2V5GAEgASgLMh8uY3JlYXRpdmFudGEucGxhdGZvcm'
    '0udjEuQVBJS2V5UgZhcGlLZXkSHQoKc2VjcmV0X2tleRgCIAEoCVIJc2VjcmV0S2V5');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'status_filter', '3': 4, '4': 1, '5': 9, '10': 'statusFilter'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZUlkEhsKCXBhZ2'
    'Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgDIAEoCVIJcGFnZVRva2VuEiMK'
    'DXN0YXR1c19maWx0ZXIYBCABKAlSDHN0YXR1c0ZpbHRlcg==');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'api_keys',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.APIKey',
      '10': 'apiKeys'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USOgoIYXBpX2tleXMYASADKAsyHy5jcmVhdGl2YW50YS5wbGF0Zm9ybS'
    '52MS5BUElLZXlSB2FwaUtleXMSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJUg1uZXh0UGFnZVRv'
    'a2VuEh8KC3RvdGFsX2NvdW50GAMgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use revokeRequestDescriptor instead')
const RevokeRequest$json = {
  '1': 'RevokeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 2, '4': 1, '5': 9, '10': 'apiKeyId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RevokeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeRequestDescriptor = $convert.base64Decode(
    'Cg1SZXZva2VSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSHAoKYX'
    'BpX2tleV9pZBgCIAEoCVIIYXBpS2V5SWQSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use revokeResponseDescriptor instead')
const RevokeResponse$json = {
  '1': 'RevokeResponse',
  '2': [
    {
      '1': 'api_key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.APIKey',
      '10': 'apiKey'
    },
  ],
};

/// Descriptor for `RevokeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeResponseDescriptor = $convert.base64Decode(
    'Cg5SZXZva2VSZXNwb25zZRI4CgdhcGlfa2V5GAEgASgLMh8uY3JlYXRpdmFudGEucGxhdGZvcm'
    '0udjEuQVBJS2V5UgZhcGlLZXk=');

@$core.Deprecated('Use rotateRequestDescriptor instead')
const RotateRequest$json = {
  '1': 'RotateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 2, '4': 1, '5': 9, '10': 'apiKeyId'},
  ],
};

/// Descriptor for `RotateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rotateRequestDescriptor = $convert.base64Decode(
    'Cg1Sb3RhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSHAoKYX'
    'BpX2tleV9pZBgCIAEoCVIIYXBpS2V5SWQ=');

@$core.Deprecated('Use rotateResponseDescriptor instead')
const RotateResponse$json = {
  '1': 'RotateResponse',
  '2': [
    {
      '1': 'old_key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.APIKey',
      '10': 'oldKey'
    },
    {
      '1': 'new_key',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.APIKey',
      '10': 'newKey'
    },
    {'1': 'new_secret_key', '3': 3, '4': 1, '5': 9, '10': 'newSecretKey'},
    {
      '1': 'grace_ends_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'graceEndsAt'
    },
  ],
};

/// Descriptor for `RotateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rotateResponseDescriptor = $convert.base64Decode(
    'Cg5Sb3RhdGVSZXNwb25zZRI4CgdvbGRfa2V5GAEgASgLMh8uY3JlYXRpdmFudGEucGxhdGZvcm'
    '0udjEuQVBJS2V5UgZvbGRLZXkSOAoHbmV3X2tleRgCIAEoCzIfLmNyZWF0aXZhbnRhLnBsYXRm'
    'b3JtLnYxLkFQSUtleVIGbmV3S2V5EiQKDm5ld19zZWNyZXRfa2V5GAMgASgJUgxuZXdTZWNyZX'
    'RLZXkSPgoNZ3JhY2VfZW5kc19hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'C2dyYWNlRW5kc0F0');

@$core.Deprecated('Use getUsageRequestDescriptor instead')
const GetUsageRequest$json = {
  '1': 'GetUsageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 2, '4': 1, '5': 9, '10': 'apiKeyId'},
  ],
};

/// Descriptor for `GetUsageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsageRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRVc2FnZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZBIcCg'
    'phcGlfa2V5X2lkGAIgASgJUghhcGlLZXlJZA==');

@$core.Deprecated('Use getUsageResponseDescriptor instead')
const GetUsageResponse$json = {
  '1': 'GetUsageResponse',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 2, '4': 1, '5': 9, '10': 'apiKeyId'},
    {
      '1': 'current_month_requests',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'currentMonthRequests'
    },
    {'1': 'monthly_quota', '3': 4, '4': 1, '5': 3, '10': 'monthlyQuota'},
    {
      '1': 'read_rate_limit_rpm',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'readRateLimitRpm'
    },
    {
      '1': 'write_rate_limit_rpm',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'writeRateLimitRpm'
    },
    {
      '1': 'billable_ai_credits_used',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'billableAiCreditsUsed'
    },
  ],
};

/// Descriptor for `GetUsageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsageResponseDescriptor = $convert.base64Decode(
    'ChBHZXRVc2FnZVJlc3BvbnNlEiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSHA'
    'oKYXBpX2tleV9pZBgCIAEoCVIIYXBpS2V5SWQSNAoWY3VycmVudF9tb250aF9yZXF1ZXN0cxgD'
    'IAEoA1IUY3VycmVudE1vbnRoUmVxdWVzdHMSIwoNbW9udGhseV9xdW90YRgEIAEoA1IMbW9udG'
    'hseVF1b3RhEi0KE3JlYWRfcmF0ZV9saW1pdF9ycG0YBSABKAVSEHJlYWRSYXRlTGltaXRScG0S'
    'LwoUd3JpdGVfcmF0ZV9saW1pdF9ycG0YBiABKAVSEXdyaXRlUmF0ZUxpbWl0UnBtEjcKGGJpbG'
    'xhYmxlX2FpX2NyZWRpdHNfdXNlZBgHIAEoAVIVYmlsbGFibGVBaUNyZWRpdHNVc2Vk');

@$core.Deprecated('Use aPIUsageDailyDescriptor instead')
const APIUsageDaily$json = {
  '1': 'APIUsageDaily',
  '2': [
    {'1': 'usage_id', '3': 1, '4': 1, '5': 9, '10': 'usageId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 3, '4': 1, '5': 9, '10': 'apiKeyId'},
    {'1': 'usage_date', '3': 4, '4': 1, '5': 9, '10': 'usageDate'},
    {'1': 'read_requests', '3': 5, '4': 1, '5': 5, '10': 'readRequests'},
    {'1': 'write_requests', '3': 6, '4': 1, '5': 5, '10': 'writeRequests'},
    {'1': 'error_4xx_count', '3': 7, '4': 1, '5': 5, '10': 'error4xxCount'},
    {'1': 'error_5xx_count', '3': 8, '4': 1, '5': 5, '10': 'error5xxCount'},
    {
      '1': 'outbound_webhook_deliveries',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'outboundWebhookDeliveries'
    },
    {
      '1': 'billable_ai_credits',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'billableAiCredits'
    },
  ],
};

/// Descriptor for `APIUsageDaily`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List aPIUsageDailyDescriptor = $convert.base64Decode(
    'Cg1BUElVc2FnZURhaWx5EhkKCHVzYWdlX2lkGAEgASgJUgd1c2FnZUlkEiEKDHdvcmtzcGFjZV'
    '9pZBgCIAEoCVILd29ya3NwYWNlSWQSHAoKYXBpX2tleV9pZBgDIAEoCVIIYXBpS2V5SWQSHQoK'
    'dXNhZ2VfZGF0ZRgEIAEoCVIJdXNhZ2VEYXRlEiMKDXJlYWRfcmVxdWVzdHMYBSABKAVSDHJlYW'
    'RSZXF1ZXN0cxIlCg53cml0ZV9yZXF1ZXN0cxgGIAEoBVINd3JpdGVSZXF1ZXN0cxImCg9lcnJv'
    'cl80eHhfY291bnQYByABKAVSDWVycm9yNHh4Q291bnQSJgoPZXJyb3JfNXh4X2NvdW50GAggAS'
    'gFUg1lcnJvcjV4eENvdW50Ej4KG291dGJvdW5kX3dlYmhvb2tfZGVsaXZlcmllcxgJIAEoBVIZ'
    'b3V0Ym91bmRXZWJob29rRGVsaXZlcmllcxIuChNiaWxsYWJsZV9haV9jcmVkaXRzGAogASgBUh'
    'FiaWxsYWJsZUFpQ3JlZGl0cw==');

@$core.Deprecated('Use getUsageStatsRequestDescriptor instead')
const GetUsageStatsRequest$json = {
  '1': 'GetUsageStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 2, '4': 1, '5': 9, '10': 'apiKeyId'},
    {'1': 'start_date', '3': 3, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 4, '4': 1, '5': 9, '10': 'endDate'},
  ],
};

/// Descriptor for `GetUsageStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsageStatsRequestDescriptor = $convert.base64Decode(
    'ChRHZXRVc2FnZVN0YXRzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZU'
    'lkEhwKCmFwaV9rZXlfaWQYAiABKAlSCGFwaUtleUlkEh0KCnN0YXJ0X2RhdGUYAyABKAlSCXN0'
    'YXJ0RGF0ZRIZCghlbmRfZGF0ZRgEIAEoCVIHZW5kRGF0ZQ==');

@$core.Deprecated('Use getUsageStatsResponseDescriptor instead')
const GetUsageStatsResponse$json = {
  '1': 'GetUsageStatsResponse',
  '2': [
    {
      '1': 'daily_stats',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.APIUsageDaily',
      '10': 'dailyStats'
    },
    {'1': 'total_requests', '3': 2, '4': 1, '5': 3, '10': 'totalRequests'},
    {
      '1': 'total_billable_ai_credits',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'totalBillableAiCredits'
    },
  ],
};

/// Descriptor for `GetUsageStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsageStatsResponseDescriptor = $convert.base64Decode(
    'ChVHZXRVc2FnZVN0YXRzUmVzcG9uc2USRwoLZGFpbHlfc3RhdHMYASADKAsyJi5jcmVhdGl2YW'
    '50YS5wbGF0Zm9ybS52MS5BUElVc2FnZURhaWx5UgpkYWlseVN0YXRzEiUKDnRvdGFsX3JlcXVl'
    'c3RzGAIgASgDUg10b3RhbFJlcXVlc3RzEjkKGXRvdGFsX2JpbGxhYmxlX2FpX2NyZWRpdHMYAy'
    'ABKAFSFnRvdGFsQmlsbGFibGVBaUNyZWRpdHM=');

@$core.Deprecated('Use updateScopesRequestDescriptor instead')
const UpdateScopesRequest$json = {
  '1': 'UpdateScopesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 2, '4': 1, '5': 9, '10': 'apiKeyId'},
    {'1': 'scopes', '3': 3, '4': 3, '5': 9, '10': 'scopes'},
  ],
};

/// Descriptor for `UpdateScopesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateScopesRequestDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVTY29wZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSW'
    'QSHAoKYXBpX2tleV9pZBgCIAEoCVIIYXBpS2V5SWQSFgoGc2NvcGVzGAMgAygJUgZzY29wZXM=');

@$core.Deprecated('Use updateScopesResponseDescriptor instead')
const UpdateScopesResponse$json = {
  '1': 'UpdateScopesResponse',
  '2': [
    {
      '1': 'api_key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.APIKey',
      '10': 'apiKey'
    },
  ],
};

/// Descriptor for `UpdateScopesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateScopesResponseDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVTY29wZXNSZXNwb25zZRI4CgdhcGlfa2V5GAEgASgLMh8uY3JlYXRpdmFudGEucG'
    'xhdGZvcm0udjEuQVBJS2V5UgZhcGlLZXk=');

@$core.Deprecated('Use webhookSubscriptionDescriptor instead')
const WebhookSubscription$json = {
  '1': 'WebhookSubscription',
  '2': [
    {
      '1': 'webhook_subscription_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'webhookSubscriptionId'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 3, '4': 1, '5': 9, '10': 'apiKeyId'},
    {'1': 'target_url', '3': 4, '4': 1, '5': 9, '10': 'targetUrl'},
    {'1': 'event_types', '3': 5, '4': 3, '5': 9, '10': 'eventTypes'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.WebhookSubscriptionStatus',
      '10': 'status'
    },
    {
      '1': 'consecutive_failure_count',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'consecutiveFailureCount'
    },
    {
      '1': 'last_delivery_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastDeliveryAt'
    },
    {'1': 'last_error', '3': 9, '4': 1, '5': 9, '10': 'lastError'},
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
    {'1': 'signing_secret', '3': 12, '4': 1, '5': 9, '10': 'signingSecret'},
  ],
};

/// Descriptor for `WebhookSubscription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webhookSubscriptionDescriptor = $convert.base64Decode(
    'ChNXZWJob29rU3Vic2NyaXB0aW9uEjYKF3dlYmhvb2tfc3Vic2NyaXB0aW9uX2lkGAEgASgJUh'
    'V3ZWJob29rU3Vic2NyaXB0aW9uSWQSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJ'
    'ZBIcCgphcGlfa2V5X2lkGAMgASgJUghhcGlLZXlJZBIdCgp0YXJnZXRfdXJsGAQgASgJUgl0YX'
    'JnZXRVcmwSHwoLZXZlbnRfdHlwZXMYBSADKAlSCmV2ZW50VHlwZXMSSgoGc3RhdHVzGAYgASgO'
    'MjIuY3JlYXRpdmFudGEucGxhdGZvcm0udjEuV2ViaG9va1N1YnNjcmlwdGlvblN0YXR1c1IGc3'
    'RhdHVzEjoKGWNvbnNlY3V0aXZlX2ZhaWx1cmVfY291bnQYByABKAVSF2NvbnNlY3V0aXZlRmFp'
    'bHVyZUNvdW50EkQKEGxhc3RfZGVsaXZlcnlfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUg5sYXN0RGVsaXZlcnlBdBIdCgpsYXN0X2Vycm9yGAkgASgJUglsYXN0RXJyb3IS'
    'OQoKY3JlYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZW'
    'RBdBI5Cgp1cGRhdGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBk'
    'YXRlZEF0EiUKDnNpZ25pbmdfc2VjcmV0GAwgASgJUg1zaWduaW5nU2VjcmV0');

@$core.Deprecated('Use webhookDeliveryRecordDescriptor instead')
const WebhookDeliveryRecord$json = {
  '1': 'WebhookDeliveryRecord',
  '2': [
    {'1': 'webhook_event_id', '3': 1, '4': 1, '5': 9, '10': 'webhookEventId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'subscription_id', '3': 3, '4': 1, '5': 9, '10': 'subscriptionId'},
    {'1': 'event_type', '3': 4, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'target_url', '3': 5, '4': 1, '5': 9, '10': 'targetUrl'},
    {'1': 'status_code', '3': 6, '4': 1, '5': 5, '10': 'statusCode'},
    {'1': 'attempt_count', '3': 7, '4': 1, '5': 5, '10': 'attemptCount'},
    {'1': 'delivery_status', '3': 8, '4': 1, '5': 9, '10': 'deliveryStatus'},
    {'1': 'error_message', '3': 9, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'delivered_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deliveredAt'
    },
    {'1': 'is_replay', '3': 11, '4': 1, '5': 8, '10': 'isReplay'},
  ],
};

/// Descriptor for `WebhookDeliveryRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webhookDeliveryRecordDescriptor = $convert.base64Decode(
    'ChVXZWJob29rRGVsaXZlcnlSZWNvcmQSKAoQd2ViaG9va19ldmVudF9pZBgBIAEoCVIOd2ViaG'
    '9va0V2ZW50SWQSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBInCg9zdWJzY3Jp'
    'cHRpb25faWQYAyABKAlSDnN1YnNjcmlwdGlvbklkEh0KCmV2ZW50X3R5cGUYBCABKAlSCWV2ZW'
    '50VHlwZRIdCgp0YXJnZXRfdXJsGAUgASgJUgl0YXJnZXRVcmwSHwoLc3RhdHVzX2NvZGUYBiAB'
    'KAVSCnN0YXR1c0NvZGUSIwoNYXR0ZW1wdF9jb3VudBgHIAEoBVIMYXR0ZW1wdENvdW50EicKD2'
    'RlbGl2ZXJ5X3N0YXR1cxgIIAEoCVIOZGVsaXZlcnlTdGF0dXMSIwoNZXJyb3JfbWVzc2FnZRgJ'
    'IAEoCVIMZXJyb3JNZXNzYWdlEj0KDGRlbGl2ZXJlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSC2RlbGl2ZXJlZEF0EhsKCWlzX3JlcGxheRgLIAEoCFIIaXNSZXBsYXk=');

@$core.Deprecated('Use createWebhookSubscriptionRequestDescriptor instead')
const CreateWebhookSubscriptionRequest$json = {
  '1': 'CreateWebhookSubscriptionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'api_key_id', '3': 2, '4': 1, '5': 9, '10': 'apiKeyId'},
    {'1': 'target_url', '3': 3, '4': 1, '5': 9, '10': 'targetUrl'},
    {'1': 'event_types', '3': 4, '4': 3, '5': 9, '10': 'eventTypes'},
  ],
};

/// Descriptor for `CreateWebhookSubscriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWebhookSubscriptionRequestDescriptor =
    $convert.base64Decode(
        'CiBDcmVhdGVXZWJob29rU3Vic2NyaXB0aW9uUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEhwKCmFwaV9rZXlfaWQYAiABKAlSCGFwaUtleUlkEh0KCnRhcmdldF91'
        'cmwYAyABKAlSCXRhcmdldFVybBIfCgtldmVudF90eXBlcxgEIAMoCVIKZXZlbnRUeXBlcw==');

@$core.Deprecated('Use createWebhookSubscriptionResponseDescriptor instead')
const CreateWebhookSubscriptionResponse$json = {
  '1': 'CreateWebhookSubscriptionResponse',
  '2': [
    {
      '1': 'subscription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.WebhookSubscription',
      '10': 'subscription'
    },
    {'1': 'signing_secret', '3': 2, '4': 1, '5': 9, '10': 'signingSecret'},
  ],
};

/// Descriptor for `CreateWebhookSubscriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWebhookSubscriptionResponseDescriptor =
    $convert.base64Decode(
        'CiFDcmVhdGVXZWJob29rU3Vic2NyaXB0aW9uUmVzcG9uc2USUAoMc3Vic2NyaXB0aW9uGAEgAS'
        'gLMiwuY3JlYXRpdmFudGEucGxhdGZvcm0udjEuV2ViaG9va1N1YnNjcmlwdGlvblIMc3Vic2Ny'
        'aXB0aW9uEiUKDnNpZ25pbmdfc2VjcmV0GAIgASgJUg1zaWduaW5nU2VjcmV0');

@$core.Deprecated('Use listWebhookSubscriptionsRequestDescriptor instead')
const ListWebhookSubscriptionsRequest$json = {
  '1': 'ListWebhookSubscriptionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `ListWebhookSubscriptionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWebhookSubscriptionsRequestDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0V2ViaG9va1N1YnNjcmlwdGlvbnNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use listWebhookSubscriptionsResponseDescriptor instead')
const ListWebhookSubscriptionsResponse$json = {
  '1': 'ListWebhookSubscriptionsResponse',
  '2': [
    {
      '1': 'subscriptions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.WebhookSubscription',
      '10': 'subscriptions'
    },
  ],
};

/// Descriptor for `ListWebhookSubscriptionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWebhookSubscriptionsResponseDescriptor =
    $convert.base64Decode(
        'CiBMaXN0V2ViaG9va1N1YnNjcmlwdGlvbnNSZXNwb25zZRJSCg1zdWJzY3JpcHRpb25zGAEgAy'
        'gLMiwuY3JlYXRpdmFudGEucGxhdGZvcm0udjEuV2ViaG9va1N1YnNjcmlwdGlvblINc3Vic2Ny'
        'aXB0aW9ucw==');

@$core.Deprecated('Use deleteWebhookSubscriptionRequestDescriptor instead')
const DeleteWebhookSubscriptionRequest$json = {
  '1': 'DeleteWebhookSubscriptionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'webhook_subscription_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'webhookSubscriptionId'
    },
  ],
};

/// Descriptor for `DeleteWebhookSubscriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteWebhookSubscriptionRequestDescriptor =
    $convert.base64Decode(
        'CiBEZWxldGVXZWJob29rU3Vic2NyaXB0aW9uUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEjYKF3dlYmhvb2tfc3Vic2NyaXB0aW9uX2lkGAIgASgJUhV3ZWJob29r'
        'U3Vic2NyaXB0aW9uSWQ=');

@$core.Deprecated('Use deleteWebhookSubscriptionResponseDescriptor instead')
const DeleteWebhookSubscriptionResponse$json = {
  '1': 'DeleteWebhookSubscriptionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteWebhookSubscriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteWebhookSubscriptionResponseDescriptor =
    $convert.base64Decode(
        'CiFEZWxldGVXZWJob29rU3Vic2NyaXB0aW9uUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3'
        'VjY2Vzcw==');

@$core.Deprecated('Use testWebhookSubscriptionRequestDescriptor instead')
const TestWebhookSubscriptionRequest$json = {
  '1': 'TestWebhookSubscriptionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'webhook_subscription_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'webhookSubscriptionId'
    },
    {'1': 'event_type', '3': 3, '4': 1, '5': 9, '10': 'eventType'},
  ],
};

/// Descriptor for `TestWebhookSubscriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testWebhookSubscriptionRequestDescriptor =
    $convert.base64Decode(
        'Ch5UZXN0V2ViaG9va1N1YnNjcmlwdGlvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBI2Chd3ZWJob29rX3N1YnNjcmlwdGlvbl9pZBgCIAEoCVIVd2ViaG9va1N1'
        'YnNjcmlwdGlvbklkEh0KCmV2ZW50X3R5cGUYAyABKAlSCWV2ZW50VHlwZQ==');

@$core.Deprecated('Use testWebhookSubscriptionResponseDescriptor instead')
const TestWebhookSubscriptionResponse$json = {
  '1': 'TestWebhookSubscriptionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'status_code', '3': 2, '4': 1, '5': 5, '10': 'statusCode'},
    {'1': 'response_body', '3': 3, '4': 1, '5': 9, '10': 'responseBody'},
    {'1': 'signature_header', '3': 4, '4': 1, '5': 9, '10': 'signatureHeader'},
  ],
};

/// Descriptor for `TestWebhookSubscriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testWebhookSubscriptionResponseDescriptor =
    $convert.base64Decode(
        'Ch9UZXN0V2ViaG9va1N1YnNjcmlwdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2'
        'Nlc3MSHwoLc3RhdHVzX2NvZGUYAiABKAVSCnN0YXR1c0NvZGUSIwoNcmVzcG9uc2VfYm9keRgD'
        'IAEoCVIMcmVzcG9uc2VCb2R5EikKEHNpZ25hdHVyZV9oZWFkZXIYBCABKAlSD3NpZ25hdHVyZU'
        'hlYWRlcg==');

@$core.Deprecated('Use replayWebhookDeliveryRequestDescriptor instead')
const ReplayWebhookDeliveryRequest$json = {
  '1': 'ReplayWebhookDeliveryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'webhook_event_id', '3': 2, '4': 1, '5': 9, '10': 'webhookEventId'},
  ],
};

/// Descriptor for `ReplayWebhookDeliveryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replayWebhookDeliveryRequestDescriptor =
    $convert.base64Decode(
        'ChxSZXBsYXlXZWJob29rRGVsaXZlcnlSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSKAoQd2ViaG9va19ldmVudF9pZBgCIAEoCVIOd2ViaG9va0V2ZW50SWQ=');

@$core.Deprecated('Use replayWebhookDeliveryResponseDescriptor instead')
const ReplayWebhookDeliveryResponse$json = {
  '1': 'ReplayWebhookDeliveryResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'delivery_record',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.WebhookDeliveryRecord',
      '10': 'deliveryRecord'
    },
  ],
};

/// Descriptor for `ReplayWebhookDeliveryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replayWebhookDeliveryResponseDescriptor =
    $convert.base64Decode(
        'Ch1SZXBsYXlXZWJob29rRGVsaXZlcnlSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZX'
        'NzElcKD2RlbGl2ZXJ5X3JlY29yZBgCIAEoCzIuLmNyZWF0aXZhbnRhLnBsYXRmb3JtLnYxLldl'
        'Ymhvb2tEZWxpdmVyeVJlY29yZFIOZGVsaXZlcnlSZWNvcmQ=');

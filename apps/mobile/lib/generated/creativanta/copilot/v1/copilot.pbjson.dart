// This is a generated file - do not edit.
//
// Generated from creativanta/copilot/v1/copilot.proto.

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

@$core.Deprecated('Use copilotModeDescriptor instead')
const CopilotMode$json = {
  '1': 'CopilotMode',
  '2': [
    {'1': 'COPILOT_MODE_UNSPECIFIED', '2': 0},
    {'1': 'COPILOT_MODE_CREATIVE', '2': 1},
    {'1': 'COPILOT_MODE_ANALYTICS', '2': 2},
    {'1': 'COPILOT_MODE_ACTION', '2': 3},
    {'1': 'COPILOT_MODE_VIDEO_PRODUCTION', '2': 4},
    {'1': 'COPILOT_MODE_HELP', '2': 5},
  ],
};

/// Descriptor for `CopilotMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List copilotModeDescriptor = $convert.base64Decode(
    'CgtDb3BpbG90TW9kZRIcChhDT1BJTE9UX01PREVfVU5TUEVDSUZJRUQQABIZChVDT1BJTE9UX0'
    '1PREVfQ1JFQVRJVkUQARIaChZDT1BJTE9UX01PREVfQU5BTFlUSUNTEAISFwoTQ09QSUxPVF9N'
    'T0RFX0FDVElPThADEiEKHUNPUElMT1RfTU9ERV9WSURFT19QUk9EVUNUSU9OEAQSFQoRQ09QSU'
    'xPVF9NT0RFX0hFTFAQBQ==');

@$core.Deprecated('Use actionQuoteStatusDescriptor instead')
const ActionQuoteStatus$json = {
  '1': 'ActionQuoteStatus',
  '2': [
    {'1': 'ACTION_QUOTE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ACTION_QUOTE_STATUS_PENDING', '2': 1},
    {'1': 'ACTION_QUOTE_STATUS_CONFIRMED', '2': 2},
    {'1': 'ACTION_QUOTE_STATUS_CANCELLED', '2': 3},
    {'1': 'ACTION_QUOTE_STATUS_EXPIRED', '2': 4},
  ],
};

/// Descriptor for `ActionQuoteStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List actionQuoteStatusDescriptor = $convert.base64Decode(
    'ChFBY3Rpb25RdW90ZVN0YXR1cxIjCh9BQ1RJT05fUVVPVEVfU1RBVFVTX1VOU1BFQ0lGSUVEEA'
    'ASHwobQUNUSU9OX1FVT1RFX1NUQVRVU19QRU5ESU5HEAESIQodQUNUSU9OX1FVT1RFX1NUQVRV'
    'U19DT05GSVJNRUQQAhIhCh1BQ1RJT05fUVVPVEVfU1RBVFVTX0NBTkNFTExFRBADEh8KG0FDVE'
    'lPTl9RVU9URV9TVEFUVVNfRVhQSVJFRBAE');

@$core.Deprecated('Use actionQuoteDescriptor instead')
const ActionQuote$json = {
  '1': 'ActionQuote',
  '2': [
    {'1': 'quote_id', '3': 1, '4': 1, '5': 9, '10': 'quoteId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'operation_type', '3': 3, '4': 1, '5': 9, '10': 'operationType'},
    {'1': 'quoted_credits', '3': 4, '4': 1, '5': 3, '10': 'quotedCredits'},
    {'1': 'cost_ceiling_usd', '3': 5, '4': 1, '5': 9, '10': 'costCeilingUsd'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.copilot.v1.ActionQuoteStatus',
      '10': 'status'
    },
    {
      '1': 'expires_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'action_preview', '3': 9, '4': 1, '5': 9, '10': 'actionPreview'},
  ],
};

/// Descriptor for `ActionQuote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionQuoteDescriptor = $convert.base64Decode(
    'CgtBY3Rpb25RdW90ZRIZCghxdW90ZV9pZBgBIAEoCVIHcXVvdGVJZBIhCgx3b3Jrc3BhY2VfaW'
    'QYAiABKAlSC3dvcmtzcGFjZUlkEiUKDm9wZXJhdGlvbl90eXBlGAMgASgJUg1vcGVyYXRpb25U'
    'eXBlEiUKDnF1b3RlZF9jcmVkaXRzGAQgASgDUg1xdW90ZWRDcmVkaXRzEigKEGNvc3RfY2VpbG'
    'luZ191c2QYBSABKAlSDmNvc3RDZWlsaW5nVXNkEkEKBnN0YXR1cxgGIAEoDjIpLmNyZWF0aXZh'
    'bnRhLmNvcGlsb3QudjEuQWN0aW9uUXVvdGVTdGF0dXNSBnN0YXR1cxI5CgpleHBpcmVzX2F0GA'
    'cgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZXhwaXJlc0F0EjkKCmNyZWF0ZWRf'
    'YXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSJQoOYWN0aW'
    '9uX3ByZXZpZXcYCSABKAlSDWFjdGlvblByZXZpZXc=');

@$core.Deprecated('Use actionCardDescriptor instead')
const ActionCard$json = {
  '1': 'ActionCard',
  '2': [
    {'1': 'action_id', '3': 1, '4': 1, '5': 9, '10': 'actionId'},
    {'1': 'action_type', '3': 2, '4': 1, '5': 9, '10': 'actionType'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'required_permission',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'requiredPermission'
    },
    {
      '1': 'requires_confirmation',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'requiresConfirmation'
    },
    {
      '1': 'quote',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.ActionQuote',
      '10': 'quote'
    },
    {
      '1': 'parameters',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.copilot.v1.ActionCard.ParametersEntry',
      '10': 'parameters'
    },
  ],
  '3': [ActionCard_ParametersEntry$json],
};

@$core.Deprecated('Use actionCardDescriptor instead')
const ActionCard_ParametersEntry$json = {
  '1': 'ParametersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ActionCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionCardDescriptor = $convert.base64Decode(
    'CgpBY3Rpb25DYXJkEhsKCWFjdGlvbl9pZBgBIAEoCVIIYWN0aW9uSWQSHwoLYWN0aW9uX3R5cG'
    'UYAiABKAlSCmFjdGlvblR5cGUSFAoFdGl0bGUYAyABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9u'
    'GAQgASgJUgtkZXNjcmlwdGlvbhIvChNyZXF1aXJlZF9wZXJtaXNzaW9uGAUgASgJUhJyZXF1aX'
    'JlZFBlcm1pc3Npb24SMwoVcmVxdWlyZXNfY29uZmlybWF0aW9uGAYgASgIUhRyZXF1aXJlc0Nv'
    'bmZpcm1hdGlvbhI5CgVxdW90ZRgHIAEoCzIjLmNyZWF0aXZhbnRhLmNvcGlsb3QudjEuQWN0aW'
    '9uUXVvdGVSBXF1b3RlElIKCnBhcmFtZXRlcnMYCCADKAsyMi5jcmVhdGl2YW50YS5jb3BpbG90'
    'LnYxLkFjdGlvbkNhcmQuUGFyYW1ldGVyc0VudHJ5UgpwYXJhbWV0ZXJzGj0KD1BhcmFtZXRlcn'
    'NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use dataCardDescriptor instead')
const DataCard$json = {
  '1': 'DataCard',
  '2': [
    {'1': 'card_id', '3': 1, '4': 1, '5': 9, '10': 'cardId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 3, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'is_financial', '3': 4, '4': 1, '5': 8, '10': 'isFinancial'},
    {'1': 'is_redacted', '3': 5, '4': 1, '5': 8, '10': 'isRedacted'},
    {'1': 'redaction_reason', '3': 6, '4': 1, '5': 9, '10': 'redactionReason'},
    {'1': 'source_badges', '3': 7, '4': 3, '5': 9, '10': 'sourceBadges'},
    {
      '1': 'metrics',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.copilot.v1.DataCard.MetricsEntry',
      '10': 'metrics'
    },
  ],
  '3': [DataCard_MetricsEntry$json],
};

@$core.Deprecated('Use dataCardDescriptor instead')
const DataCard_MetricsEntry$json = {
  '1': 'MetricsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `DataCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataCardDescriptor = $convert.base64Decode(
    'CghEYXRhQ2FyZBIXCgdjYXJkX2lkGAEgASgJUgZjYXJkSWQSFAoFdGl0bGUYAiABKAlSBXRpdG'
    'xlEhgKB3N1bW1hcnkYAyABKAlSB3N1bW1hcnkSIQoMaXNfZmluYW5jaWFsGAQgASgIUgtpc0Zp'
    'bmFuY2lhbBIfCgtpc19yZWRhY3RlZBgFIAEoCFIKaXNSZWRhY3RlZBIpChByZWRhY3Rpb25fcm'
    'Vhc29uGAYgASgJUg9yZWRhY3Rpb25SZWFzb24SIwoNc291cmNlX2JhZGdlcxgHIAMoCVIMc291'
    'cmNlQmFkZ2VzEkcKB21ldHJpY3MYCCADKAsyLS5jcmVhdGl2YW50YS5jb3BpbG90LnYxLkRhdG'
    'FDYXJkLk1ldHJpY3NFbnRyeVIHbWV0cmljcxo6CgxNZXRyaWNzRW50cnkSEAoDa2V5GAEgASgJ'
    'UgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use copilotMessageDescriptor instead')
const CopilotMessage$json = {
  '1': 'CopilotMessage',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {'1': 'content', '3': 4, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'action_cards',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.copilot.v1.ActionCard',
      '10': 'actionCards'
    },
    {
      '1': 'data_cards',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.copilot.v1.DataCard',
      '10': 'dataCards'
    },
    {
      '1': 'pending_quote',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.ActionQuote',
      '10': 'pendingQuote'
    },
    {
      '1': 'permission_denied',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'permissionDenied'
    },
    {'1': 'denial_reason', '3': 9, '4': 1, '5': 9, '10': 'denialReason'},
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `CopilotMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotMessageDescriptor = $convert.base64Decode(
    'Cg5Db3BpbG90TWVzc2FnZRIdCgptZXNzYWdlX2lkGAEgASgJUgltZXNzYWdlSWQSHQoKc2Vzc2'
    'lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEhIKBHJvbGUYAyABKAlSBHJvbGUSGAoHY29udGVudBgE'
    'IAEoCVIHY29udGVudBJFCgxhY3Rpb25fY2FyZHMYBSADKAsyIi5jcmVhdGl2YW50YS5jb3BpbG'
    '90LnYxLkFjdGlvbkNhcmRSC2FjdGlvbkNhcmRzEj8KCmRhdGFfY2FyZHMYBiADKAsyIC5jcmVh'
    'dGl2YW50YS5jb3BpbG90LnYxLkRhdGFDYXJkUglkYXRhQ2FyZHMSSAoNcGVuZGluZ19xdW90ZR'
    'gHIAEoCzIjLmNyZWF0aXZhbnRhLmNvcGlsb3QudjEuQWN0aW9uUXVvdGVSDHBlbmRpbmdRdW90'
    'ZRIrChFwZXJtaXNzaW9uX2RlbmllZBgIIAEoCFIQcGVybWlzc2lvbkRlbmllZBIjCg1kZW5pYW'
    'xfcmVhc29uGAkgASgJUgxkZW5pYWxSZWFzb24SOQoKY3JlYXRlZF9hdBgKIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use copilotSessionDescriptor instead')
const CopilotSession$json = {
  '1': 'CopilotSession',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.copilot.v1.CopilotMode',
      '10': 'mode'
    },
    {'1': 'context_scope', '3': 5, '4': 1, '5': 9, '10': 'contextScope'},
    {
      '1': 'messages',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotMessage',
      '10': 'messages'
    },
    {
      '1': 'total_credits_used',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'totalCreditsUsed'
    },
    {
      '1': 'ended_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
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

/// Descriptor for `CopilotSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotSessionDescriptor = $convert.base64Decode(
    'Cg5Db3BpbG90U2Vzc2lvbhIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSIQoMd29ya3'
    'NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIXCgd1c2VyX2lkGAMgASgJUgZ1c2VySWQSNwoE'
    'bW9kZRgEIAEoDjIjLmNyZWF0aXZhbnRhLmNvcGlsb3QudjEuQ29waWxvdE1vZGVSBG1vZGUSIw'
    'oNY29udGV4dF9zY29wZRgFIAEoCVIMY29udGV4dFNjb3BlEkIKCG1lc3NhZ2VzGAYgAygLMiYu'
    'Y3JlYXRpdmFudGEuY29waWxvdC52MS5Db3BpbG90TWVzc2FnZVIIbWVzc2FnZXMSLAoSdG90YW'
    'xfY3JlZGl0c191c2VkGAcgASgJUhB0b3RhbENyZWRpdHNVc2VkEjUKCGVuZGVkX2F0GAggASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZW5kZWRBdBI5CgpjcmVhdGVkX2F0GAkgAS'
    'gLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQY'
    'CiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use suggestionItemDescriptor instead')
const SuggestionItem$json = {
  '1': 'SuggestionItem',
  '2': [
    {'1': 'suggestion_id', '3': 1, '4': 1, '5': 9, '10': 'suggestionId'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'prompt_text', '3': 3, '4': 1, '5': 9, '10': 'promptText'},
    {'1': 'category', '3': 4, '4': 1, '5': 9, '10': 'category'},
    {'1': 'target_module', '3': 5, '4': 1, '5': 9, '10': 'targetModule'},
  ],
};

/// Descriptor for `SuggestionItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestionItemDescriptor = $convert.base64Decode(
    'Cg5TdWdnZXN0aW9uSXRlbRIjCg1zdWdnZXN0aW9uX2lkGAEgASgJUgxzdWdnZXN0aW9uSWQSFA'
    'oFbGFiZWwYAiABKAlSBWxhYmVsEh8KC3Byb21wdF90ZXh0GAMgASgJUgpwcm9tcHRUZXh0EhoK'
    'CGNhdGVnb3J5GAQgASgJUghjYXRlZ29yeRIjCg10YXJnZXRfbW9kdWxlGAUgASgJUgx0YXJnZX'
    'RNb2R1bGU=');

@$core.Deprecated('Use copilotServiceQueryRequestDescriptor instead')
const CopilotServiceQueryRequest$json = {
  '1': 'CopilotServiceQueryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'query', '3': 3, '4': 1, '5': 9, '10': 'query'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.copilot.v1.CopilotMode',
      '10': 'mode'
    },
    {'1': 'context_scope', '3': 5, '4': 1, '5': 9, '10': 'contextScope'},
    {'1': 'context_ids', '3': 6, '4': 3, '5': 9, '10': 'contextIds'},
    {
      '1': 'confirmed_quote_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'confirmedQuoteId'
    },
  ],
};

/// Descriptor for `CopilotServiceQueryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceQueryRequestDescriptor = $convert.base64Decode(
    'ChpDb3BpbG90U2VydmljZVF1ZXJ5UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBIUCgVxdWVyeRgDIAEoCVIF'
    'cXVlcnkSNwoEbW9kZRgEIAEoDjIjLmNyZWF0aXZhbnRhLmNvcGlsb3QudjEuQ29waWxvdE1vZG'
    'VSBG1vZGUSIwoNY29udGV4dF9zY29wZRgFIAEoCVIMY29udGV4dFNjb3BlEh8KC2NvbnRleHRf'
    'aWRzGAYgAygJUgpjb250ZXh0SWRzEiwKEmNvbmZpcm1lZF9xdW90ZV9pZBgHIAEoCVIQY29uZm'
    'lybWVkUXVvdGVJZA==');

@$core.Deprecated('Use copilotServiceQueryResponseDescriptor instead')
const CopilotServiceQueryResponse$json = {
  '1': 'CopilotServiceQueryResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotSession',
      '10': 'session'
    },
    {
      '1': 'message',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotMessage',
      '10': 'message'
    },
    {
      '1': 'requires_quote_confirmation',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'requiresQuoteConfirmation'
    },
    {
      '1': 'quote',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.ActionQuote',
      '10': 'quote'
    },
    {
      '1': 'is_financial_query',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'isFinancialQuery'
    },
    {
      '1': 'financial_data_redacted',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'financialDataRedacted'
    },
  ],
};

/// Descriptor for `CopilotServiceQueryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceQueryResponseDescriptor = $convert.base64Decode(
    'ChtDb3BpbG90U2VydmljZVF1ZXJ5UmVzcG9uc2USQAoHc2Vzc2lvbhgBIAEoCzImLmNyZWF0aX'
    'ZhbnRhLmNvcGlsb3QudjEuQ29waWxvdFNlc3Npb25SB3Nlc3Npb24SQAoHbWVzc2FnZRgCIAEo'
    'CzImLmNyZWF0aXZhbnRhLmNvcGlsb3QudjEuQ29waWxvdE1lc3NhZ2VSB21lc3NhZ2USPgobcm'
    'VxdWlyZXNfcXVvdGVfY29uZmlybWF0aW9uGAMgASgIUhlyZXF1aXJlc1F1b3RlQ29uZmlybWF0'
    'aW9uEjkKBXF1b3RlGAQgASgLMiMuY3JlYXRpdmFudGEuY29waWxvdC52MS5BY3Rpb25RdW90ZV'
    'IFcXVvdGUSLAoSaXNfZmluYW5jaWFsX3F1ZXJ5GAUgASgIUhBpc0ZpbmFuY2lhbFF1ZXJ5EjYK'
    'F2ZpbmFuY2lhbF9kYXRhX3JlZGFjdGVkGAYgASgIUhVmaW5hbmNpYWxEYXRhUmVkYWN0ZWQ=');

@$core.Deprecated('Use copilotServiceSendMessageRequestDescriptor instead')
const CopilotServiceSendMessageRequest$json = {
  '1': 'CopilotServiceSendMessageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.copilot.v1.CopilotMode',
      '10': 'mode'
    },
    {'1': 'context_scope', '3': 5, '4': 1, '5': 9, '10': 'contextScope'},
    {
      '1': 'confirmed_quote_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'confirmedQuoteId'
    },
  ],
};

/// Descriptor for `CopilotServiceSendMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceSendMessageRequestDescriptor = $convert.base64Decode(
    'CiBDb3BpbG90U2VydmljZVNlbmRNZXNzYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
    'lSC3dvcmtzcGFjZUlkEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBIYCgdjb250ZW50'
    'GAMgASgJUgdjb250ZW50EjcKBG1vZGUYBCABKA4yIy5jcmVhdGl2YW50YS5jb3BpbG90LnYxLk'
    'NvcGlsb3RNb2RlUgRtb2RlEiMKDWNvbnRleHRfc2NvcGUYBSABKAlSDGNvbnRleHRTY29wZRIs'
    'ChJjb25maXJtZWRfcXVvdGVfaWQYBiABKAlSEGNvbmZpcm1lZFF1b3RlSWQ=');

@$core.Deprecated('Use copilotServiceSendMessageResponseDescriptor instead')
const CopilotServiceSendMessageResponse$json = {
  '1': 'CopilotServiceSendMessageResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotSession',
      '10': 'session'
    },
    {
      '1': 'reply',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotMessage',
      '10': 'reply'
    },
    {
      '1': 'requires_quote_confirmation',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'requiresQuoteConfirmation'
    },
    {
      '1': 'quote',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.ActionQuote',
      '10': 'quote'
    },
  ],
};

/// Descriptor for `CopilotServiceSendMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceSendMessageResponseDescriptor = $convert.base64Decode(
    'CiFDb3BpbG90U2VydmljZVNlbmRNZXNzYWdlUmVzcG9uc2USQAoHc2Vzc2lvbhgBIAEoCzImLm'
    'NyZWF0aXZhbnRhLmNvcGlsb3QudjEuQ29waWxvdFNlc3Npb25SB3Nlc3Npb24SPAoFcmVwbHkY'
    'AiABKAsyJi5jcmVhdGl2YW50YS5jb3BpbG90LnYxLkNvcGlsb3RNZXNzYWdlUgVyZXBseRI+Ch'
    'tyZXF1aXJlc19xdW90ZV9jb25maXJtYXRpb24YAyABKAhSGXJlcXVpcmVzUXVvdGVDb25maXJt'
    'YXRpb24SOQoFcXVvdGUYBCABKAsyIy5jcmVhdGl2YW50YS5jb3BpbG90LnYxLkFjdGlvblF1b3'
    'RlUgVxdW90ZQ==');

@$core.Deprecated('Use copilotServiceChatRequestDescriptor instead')
const CopilotServiceChatRequest$json = {
  '1': 'CopilotServiceChatRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.copilot.v1.CopilotMode',
      '10': 'mode'
    },
    {'1': 'context_scope', '3': 5, '4': 1, '5': 9, '10': 'contextScope'},
  ],
};

/// Descriptor for `CopilotServiceChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceChatRequestDescriptor = $convert.base64Decode(
    'ChlDb3BpbG90U2VydmljZUNoYXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEhgKB21lc3NhZ2UYAyABKAlS'
    'B21lc3NhZ2USNwoEbW9kZRgEIAEoDjIjLmNyZWF0aXZhbnRhLmNvcGlsb3QudjEuQ29waWxvdE'
    '1vZGVSBG1vZGUSIwoNY29udGV4dF9zY29wZRgFIAEoCVIMY29udGV4dFNjb3Bl');

@$core.Deprecated('Use copilotServiceChatResponseDescriptor instead')
const CopilotServiceChatResponse$json = {
  '1': 'CopilotServiceChatResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotSession',
      '10': 'session'
    },
    {
      '1': 'reply',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotMessage',
      '10': 'reply'
    },
  ],
};

/// Descriptor for `CopilotServiceChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceChatResponseDescriptor =
    $convert.base64Decode(
        'ChpDb3BpbG90U2VydmljZUNoYXRSZXNwb25zZRJACgdzZXNzaW9uGAEgASgLMiYuY3JlYXRpdm'
        'FudGEuY29waWxvdC52MS5Db3BpbG90U2Vzc2lvblIHc2Vzc2lvbhI8CgVyZXBseRgCIAEoCzIm'
        'LmNyZWF0aXZhbnRhLmNvcGlsb3QudjEuQ29waWxvdE1lc3NhZ2VSBXJlcGx5');

@$core.Deprecated('Use copilotServiceGetSessionRequestDescriptor instead')
const CopilotServiceGetSessionRequest$json = {
  '1': 'CopilotServiceGetSessionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `CopilotServiceGetSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetSessionRequestDescriptor =
    $convert.base64Decode(
        'Ch9Db3BpbG90U2VydmljZUdldFNlc3Npb25SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use copilotServiceGetSessionResponseDescriptor instead')
const CopilotServiceGetSessionResponse$json = {
  '1': 'CopilotServiceGetSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `CopilotServiceGetSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetSessionResponseDescriptor =
    $convert.base64Decode(
        'CiBDb3BpbG90U2VydmljZUdldFNlc3Npb25SZXNwb25zZRJACgdzZXNzaW9uGAEgASgLMiYuY3'
        'JlYXRpdmFudGEuY29waWxvdC52MS5Db3BpbG90U2Vzc2lvblIHc2Vzc2lvbg==');

@$core.Deprecated('Use copilotServiceClearSessionRequestDescriptor instead')
const CopilotServiceClearSessionRequest$json = {
  '1': 'CopilotServiceClearSessionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `CopilotServiceClearSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceClearSessionRequestDescriptor =
    $convert.base64Decode(
        'CiFDb3BpbG90U2VydmljZUNsZWFyU2Vzc2lvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIdCgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use copilotServiceClearSessionResponseDescriptor instead')
const CopilotServiceClearSessionResponse$json = {
  '1': 'CopilotServiceClearSessionResponse',
  '2': [
    {'1': 'cleared', '3': 1, '4': 1, '5': 8, '10': 'cleared'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `CopilotServiceClearSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceClearSessionResponseDescriptor =
    $convert.base64Decode(
        'CiJDb3BpbG90U2VydmljZUNsZWFyU2Vzc2lvblJlc3BvbnNlEhgKB2NsZWFyZWQYASABKAhSB2'
        'NsZWFyZWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use copilotServiceGetSuggestionsRequestDescriptor instead')
const CopilotServiceGetSuggestionsRequest$json = {
  '1': 'CopilotServiceGetSuggestionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'context_scope', '3': 2, '4': 1, '5': 9, '10': 'contextScope'},
    {
      '1': 'mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.copilot.v1.CopilotMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `CopilotServiceGetSuggestionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetSuggestionsRequestDescriptor =
    $convert.base64Decode(
        'CiNDb3BpbG90U2VydmljZUdldFN1Z2dlc3Rpb25zUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEiMKDWNvbnRleHRfc2NvcGUYAiABKAlSDGNvbnRleHRTY29wZRI3'
        'CgRtb2RlGAMgASgOMiMuY3JlYXRpdmFudGEuY29waWxvdC52MS5Db3BpbG90TW9kZVIEbW9kZQ'
        '==');

@$core.Deprecated('Use copilotServiceGetSuggestionsResponseDescriptor instead')
const CopilotServiceGetSuggestionsResponse$json = {
  '1': 'CopilotServiceGetSuggestionsResponse',
  '2': [
    {
      '1': 'suggestions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.copilot.v1.SuggestionItem',
      '10': 'suggestions'
    },
  ],
};

/// Descriptor for `CopilotServiceGetSuggestionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetSuggestionsResponseDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZUdldFN1Z2dlc3Rpb25zUmVzcG9uc2USSAoLc3VnZ2VzdGlvbnMYAS'
        'ADKAsyJi5jcmVhdGl2YW50YS5jb3BpbG90LnYxLlN1Z2dlc3Rpb25JdGVtUgtzdWdnZXN0aW9u'
        'cw==');

@$core.Deprecated(
    'Use copilotServiceGetContextualActionsRequestDescriptor instead')
const CopilotServiceGetContextualActionsRequest$json = {
  '1': 'CopilotServiceGetContextualActionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'screen_route', '3': 2, '4': 1, '5': 9, '10': 'screenRoute'},
    {'1': 'object_id', '3': 3, '4': 1, '5': 9, '10': 'objectId'},
  ],
};

/// Descriptor for `CopilotServiceGetContextualActionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    copilotServiceGetContextualActionsRequestDescriptor = $convert.base64Decode(
        'CilDb3BpbG90U2VydmljZUdldENvbnRleHR1YWxBY3Rpb25zUmVxdWVzdBIhCgx3b3Jrc3BhY2'
        'VfaWQYASABKAlSC3dvcmtzcGFjZUlkEiEKDHNjcmVlbl9yb3V0ZRgCIAEoCVILc2NyZWVuUm91'
        'dGUSGwoJb2JqZWN0X2lkGAMgASgJUghvYmplY3RJZA==');

@$core.Deprecated(
    'Use copilotServiceGetContextualActionsResponseDescriptor instead')
const CopilotServiceGetContextualActionsResponse$json = {
  '1': 'CopilotServiceGetContextualActionsResponse',
  '2': [
    {
      '1': 'actions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.copilot.v1.ActionCard',
      '10': 'actions'
    },
  ],
};

/// Descriptor for `CopilotServiceGetContextualActionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    copilotServiceGetContextualActionsResponseDescriptor =
    $convert.base64Decode(
        'CipDb3BpbG90U2VydmljZUdldENvbnRleHR1YWxBY3Rpb25zUmVzcG9uc2USPAoHYWN0aW9ucx'
        'gBIAMoCzIiLmNyZWF0aXZhbnRhLmNvcGlsb3QudjEuQWN0aW9uQ2FyZFIHYWN0aW9ucw==');

@$core.Deprecated('Use copilotServiceSetContextRequestDescriptor instead')
const CopilotServiceSetContextRequest$json = {
  '1': 'CopilotServiceSetContextRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'context_scope', '3': 3, '4': 1, '5': 9, '10': 'contextScope'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.copilot.v1.CopilotMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `CopilotServiceSetContextRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceSetContextRequestDescriptor =
    $convert.base64Decode(
        'Ch9Db3BpbG90U2VydmljZVNldENvbnRleHRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEiMKDWNvbnRleHRf'
        'c2NvcGUYAyABKAlSDGNvbnRleHRTY29wZRI3CgRtb2RlGAQgASgOMiMuY3JlYXRpdmFudGEuY2'
        '9waWxvdC52MS5Db3BpbG90TW9kZVIEbW9kZQ==');

@$core.Deprecated('Use copilotServiceSetContextResponseDescriptor instead')
const CopilotServiceSetContextResponse$json = {
  '1': 'CopilotServiceSetContextResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `CopilotServiceSetContextResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceSetContextResponseDescriptor =
    $convert.base64Decode(
        'CiBDb3BpbG90U2VydmljZVNldENvbnRleHRSZXNwb25zZRJACgdzZXNzaW9uGAEgASgLMiYuY3'
        'JlYXRpdmFudGEuY29waWxvdC52MS5Db3BpbG90U2Vzc2lvblIHc2Vzc2lvbg==');

@$core.Deprecated('Use copilotServiceGetHistoryRequestDescriptor instead')
const CopilotServiceGetHistoryRequest$json = {
  '1': 'CopilotServiceGetHistoryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `CopilotServiceGetHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetHistoryRequestDescriptor =
    $convert.base64Decode(
        'Ch9Db3BpbG90U2VydmljZUdldEhpc3RvcnlSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSFAoFbGltaXQYAiABKAVSBWxpbWl0Eh0KCnBhZ2VfdG9rZW4YAyABKAlS'
        'CXBhZ2VUb2tlbg==');

@$core.Deprecated('Use copilotServiceGetHistoryResponseDescriptor instead')
const CopilotServiceGetHistoryResponse$json = {
  '1': 'CopilotServiceGetHistoryResponse',
  '2': [
    {
      '1': 'sessions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.copilot.v1.CopilotSession',
      '10': 'sessions'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `CopilotServiceGetHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetHistoryResponseDescriptor =
    $convert.base64Decode(
        'CiBDb3BpbG90U2VydmljZUdldEhpc3RvcnlSZXNwb25zZRJCCghzZXNzaW9ucxgBIAMoCzImLm'
        'NyZWF0aXZhbnRhLmNvcGlsb3QudjEuQ29waWxvdFNlc3Npb25SCHNlc3Npb25zEiYKD25leHRf'
        'cGFnZV90b2tlbhgCIAEoCVINbmV4dFBhZ2VUb2tlbg==');

@$core.Deprecated('Use copilotServiceFeedbackRequestDescriptor instead')
const CopilotServiceFeedbackRequest$json = {
  '1': 'CopilotServiceFeedbackRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'message_id', '3': 3, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'is_positive', '3': 4, '4': 1, '5': 8, '10': 'isPositive'},
    {'1': 'feedback_text', '3': 5, '4': 1, '5': 9, '10': 'feedbackText'},
  ],
};

/// Descriptor for `CopilotServiceFeedbackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceFeedbackRequestDescriptor = $convert.base64Decode(
    'Ch1Db3BpbG90U2VydmljZUZlZWRiYWNrUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEh0KCnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBIdCgptZXNzYWdlX2lk'
    'GAMgASgJUgltZXNzYWdlSWQSHwoLaXNfcG9zaXRpdmUYBCABKAhSCmlzUG9zaXRpdmUSIwoNZm'
    'VlZGJhY2tfdGV4dBgFIAEoCVIMZmVlZGJhY2tUZXh0');

@$core.Deprecated('Use copilotServiceFeedbackResponseDescriptor instead')
const CopilotServiceFeedbackResponse$json = {
  '1': 'CopilotServiceFeedbackResponse',
  '2': [
    {'1': 'recorded', '3': 1, '4': 1, '5': 8, '10': 'recorded'},
  ],
};

/// Descriptor for `CopilotServiceFeedbackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceFeedbackResponseDescriptor =
    $convert.base64Decode(
        'Ch5Db3BpbG90U2VydmljZUZlZWRiYWNrUmVzcG9uc2USGgoIcmVjb3JkZWQYASABKAhSCHJlY2'
        '9yZGVk');

@$core.Deprecated('Use copilotServiceGenerateIdeasRequestDescriptor instead')
const CopilotServiceGenerateIdeasRequest$json = {
  '1': 'CopilotServiceGenerateIdeasRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'topic', '3': 2, '4': 1, '5': 9, '10': 'topic'},
    {'1': 'count', '3': 3, '4': 1, '5': 5, '10': 'count'},
    {
      '1': 'confirmed_quote_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'confirmedQuoteId'
    },
  ],
};

/// Descriptor for `CopilotServiceGenerateIdeasRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGenerateIdeasRequestDescriptor =
    $convert.base64Decode(
        'CiJDb3BpbG90U2VydmljZUdlbmVyYXRlSWRlYXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSFAoFdG9waWMYAiABKAlSBXRvcGljEhQKBWNvdW50GAMgASgFUgVj'
        'b3VudBIsChJjb25maXJtZWRfcXVvdGVfaWQYBCABKAlSEGNvbmZpcm1lZFF1b3RlSWQ=');

@$core.Deprecated('Use copilotServiceGenerateIdeasResponseDescriptor instead')
const CopilotServiceGenerateIdeasResponse$json = {
  '1': 'CopilotServiceGenerateIdeasResponse',
  '2': [
    {'1': 'ideas', '3': 1, '4': 3, '5': 9, '10': 'ideas'},
    {
      '1': 'quote',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.copilot.v1.ActionQuote',
      '10': 'quote'
    },
    {
      '1': 'requires_confirmation',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'requiresConfirmation'
    },
  ],
};

/// Descriptor for `CopilotServiceGenerateIdeasResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGenerateIdeasResponseDescriptor =
    $convert.base64Decode(
        'CiNDb3BpbG90U2VydmljZUdlbmVyYXRlSWRlYXNSZXNwb25zZRIUCgVpZGVhcxgBIAMoCVIFaW'
        'RlYXMSOQoFcXVvdGUYAiABKAsyIy5jcmVhdGl2YW50YS5jb3BpbG90LnYxLkFjdGlvblF1b3Rl'
        'UgVxdW90ZRIzChVyZXF1aXJlc19jb25maXJtYXRpb24YAyABKAhSFHJlcXVpcmVzQ29uZmlybW'
        'F0aW9u');

@$core.Deprecated('Use copilotServiceGenerateCaptionRequestDescriptor instead')
const CopilotServiceGenerateCaptionRequest$json = {
  '1': 'CopilotServiceGenerateCaptionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'content_summary', '3': 2, '4': 1, '5': 9, '10': 'contentSummary'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
  ],
};

/// Descriptor for `CopilotServiceGenerateCaptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGenerateCaptionRequestDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZUdlbmVyYXRlQ2FwdGlvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBInCg9jb250ZW50X3N1bW1hcnkYAiABKAlSDmNvbnRlbnRTdW1t'
        'YXJ5EhoKCHBsYXRmb3JtGAMgASgJUghwbGF0Zm9ybQ==');

@$core.Deprecated('Use copilotServiceGenerateCaptionResponseDescriptor instead')
const CopilotServiceGenerateCaptionResponse$json = {
  '1': 'CopilotServiceGenerateCaptionResponse',
  '2': [
    {'1': 'caption', '3': 1, '4': 1, '5': 9, '10': 'caption'},
    {'1': 'hashtags', '3': 2, '4': 3, '5': 9, '10': 'hashtags'},
  ],
};

/// Descriptor for `CopilotServiceGenerateCaptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGenerateCaptionResponseDescriptor =
    $convert.base64Decode(
        'CiVDb3BpbG90U2VydmljZUdlbmVyYXRlQ2FwdGlvblJlc3BvbnNlEhgKB2NhcHRpb24YASABKA'
        'lSB2NhcHRpb24SGgoIaGFzaHRhZ3MYAiADKAlSCGhhc2h0YWdz');

@$core.Deprecated('Use copilotServiceGenerateReplyRequestDescriptor instead')
const CopilotServiceGenerateReplyRequest$json = {
  '1': 'CopilotServiceGenerateReplyRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'incoming_message', '3': 2, '4': 1, '5': 9, '10': 'incomingMessage'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
  ],
};

/// Descriptor for `CopilotServiceGenerateReplyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGenerateReplyRequestDescriptor =
    $convert.base64Decode(
        'CiJDb3BpbG90U2VydmljZUdlbmVyYXRlUmVwbHlSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSKQoQaW5jb21pbmdfbWVzc2FnZRgCIAEoCVIPaW5jb21pbmdNZXNz'
        'YWdlEhoKCHBsYXRmb3JtGAMgASgJUghwbGF0Zm9ybQ==');

@$core.Deprecated('Use copilotServiceGenerateReplyResponseDescriptor instead')
const CopilotServiceGenerateReplyResponse$json = {
  '1': 'CopilotServiceGenerateReplyResponse',
  '2': [
    {'1': 'suggested_reply', '3': 1, '4': 1, '5': 9, '10': 'suggestedReply'},
  ],
};

/// Descriptor for `CopilotServiceGenerateReplyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGenerateReplyResponseDescriptor =
    $convert.base64Decode(
        'CiNDb3BpbG90U2VydmljZUdlbmVyYXRlUmVwbHlSZXNwb25zZRInCg9zdWdnZXN0ZWRfcmVwbH'
        'kYASABKAlSDnN1Z2dlc3RlZFJlcGx5');

@$core.Deprecated('Use copilotServiceGenerateAvatarRequestDescriptor instead')
const CopilotServiceGenerateAvatarRequest$json = {
  '1': 'CopilotServiceGenerateAvatarRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'prompt', '3': 2, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'style', '3': 3, '4': 1, '5': 9, '10': 'style'},
  ],
};

/// Descriptor for `CopilotServiceGenerateAvatarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGenerateAvatarRequestDescriptor =
    $convert.base64Decode(
        'CiNDb3BpbG90U2VydmljZUdlbmVyYXRlQXZhdGFyUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEhYKBnByb21wdBgCIAEoCVIGcHJvbXB0EhQKBXN0eWxlGAMgASgJ'
        'UgVzdHlsZQ==');

@$core.Deprecated('Use copilotServiceGenerateAvatarResponseDescriptor instead')
const CopilotServiceGenerateAvatarResponse$json = {
  '1': 'CopilotServiceGenerateAvatarResponse',
  '2': [
    {'1': 'avatar_url', '3': 1, '4': 1, '5': 9, '10': 'avatarUrl'},
  ],
};

/// Descriptor for `CopilotServiceGenerateAvatarResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGenerateAvatarResponseDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZUdlbmVyYXRlQXZhdGFyUmVzcG9uc2USHQoKYXZhdGFyX3VybBgBIA'
        'EoCVIJYXZhdGFyVXJs');

@$core.Deprecated('Use copilotServiceShortenCaptionRequestDescriptor instead')
const CopilotServiceShortenCaptionRequest$json = {
  '1': 'CopilotServiceShortenCaptionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'max_length', '3': 3, '4': 1, '5': 5, '10': 'maxLength'},
  ],
};

/// Descriptor for `CopilotServiceShortenCaptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceShortenCaptionRequestDescriptor =
    $convert.base64Decode(
        'CiNDb3BpbG90U2VydmljZVNob3J0ZW5DYXB0aW9uUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEhIKBHRleHQYAiABKAlSBHRleHQSHQoKbWF4X2xlbmd0aBgDIAEo'
        'BVIJbWF4TGVuZ3Ro');

@$core.Deprecated('Use copilotServiceShortenCaptionResponseDescriptor instead')
const CopilotServiceShortenCaptionResponse$json = {
  '1': 'CopilotServiceShortenCaptionResponse',
  '2': [
    {'1': 'shortened_text', '3': 1, '4': 1, '5': 9, '10': 'shortenedText'},
  ],
};

/// Descriptor for `CopilotServiceShortenCaptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceShortenCaptionResponseDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZVNob3J0ZW5DYXB0aW9uUmVzcG9uc2USJQoOc2hvcnRlbmVkX3RleH'
        'QYASABKAlSDXNob3J0ZW5lZFRleHQ=');

@$core.Deprecated('Use copilotServiceSuggestHashtagsRequestDescriptor instead')
const CopilotServiceSuggestHashtagsRequest$json = {
  '1': 'CopilotServiceSuggestHashtagsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'topic', '3': 2, '4': 1, '5': 9, '10': 'topic'},
    {'1': 'count', '3': 3, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `CopilotServiceSuggestHashtagsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceSuggestHashtagsRequestDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZVN1Z2dlc3RIYXNodGFnc1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBIUCgV0b3BpYxgCIAEoCVIFdG9waWMSFAoFY291bnQYAyABKAVS'
        'BWNvdW50');

@$core.Deprecated('Use copilotServiceSuggestHashtagsResponseDescriptor instead')
const CopilotServiceSuggestHashtagsResponse$json = {
  '1': 'CopilotServiceSuggestHashtagsResponse',
  '2': [
    {'1': 'hashtags', '3': 1, '4': 3, '5': 9, '10': 'hashtags'},
  ],
};

/// Descriptor for `CopilotServiceSuggestHashtagsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceSuggestHashtagsResponseDescriptor =
    $convert.base64Decode(
        'CiVDb3BpbG90U2VydmljZVN1Z2dlc3RIYXNodGFnc1Jlc3BvbnNlEhoKCGhhc2h0YWdzGAEgAy'
        'gJUghoYXNodGFncw==');

@$core.Deprecated('Use copilotServiceDismissReplyRequestDescriptor instead')
const CopilotServiceDismissReplyRequest$json = {
  '1': 'CopilotServiceDismissReplyRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'reply_id', '3': 2, '4': 1, '5': 9, '10': 'replyId'},
  ],
};

/// Descriptor for `CopilotServiceDismissReplyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceDismissReplyRequestDescriptor =
    $convert.base64Decode(
        'CiFDb3BpbG90U2VydmljZURpc21pc3NSZXBseVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIZCghyZXBseV9pZBgCIAEoCVIHcmVwbHlJZA==');

@$core.Deprecated('Use copilotServiceDismissReplyResponseDescriptor instead')
const CopilotServiceDismissReplyResponse$json = {
  '1': 'CopilotServiceDismissReplyResponse',
  '2': [
    {'1': 'dismissed', '3': 1, '4': 1, '5': 8, '10': 'dismissed'},
  ],
};

/// Descriptor for `CopilotServiceDismissReplyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceDismissReplyResponseDescriptor =
    $convert.base64Decode(
        'CiJDb3BpbG90U2VydmljZURpc21pc3NSZXBseVJlc3BvbnNlEhwKCWRpc21pc3NlZBgBIAEoCF'
        'IJZGlzbWlzc2Vk');

@$core
    .Deprecated('Use copilotServiceRegenerateSectionRequestDescriptor instead')
const CopilotServiceRegenerateSectionRequest$json = {
  '1': 'CopilotServiceRegenerateSectionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'section_text', '3': 2, '4': 1, '5': 9, '10': 'sectionText'},
    {'1': 'instruction', '3': 3, '4': 1, '5': 9, '10': 'instruction'},
  ],
};

/// Descriptor for `CopilotServiceRegenerateSectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceRegenerateSectionRequestDescriptor =
    $convert.base64Decode(
        'CiZDb3BpbG90U2VydmljZVJlZ2VuZXJhdGVTZWN0aW9uUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaW'
        'QYASABKAlSC3dvcmtzcGFjZUlkEiEKDHNlY3Rpb25fdGV4dBgCIAEoCVILc2VjdGlvblRleHQS'
        'IAoLaW5zdHJ1Y3Rpb24YAyABKAlSC2luc3RydWN0aW9u');

@$core
    .Deprecated('Use copilotServiceRegenerateSectionResponseDescriptor instead')
const CopilotServiceRegenerateSectionResponse$json = {
  '1': 'CopilotServiceRegenerateSectionResponse',
  '2': [
    {'1': 'regenerated_text', '3': 1, '4': 1, '5': 9, '10': 'regeneratedText'},
  ],
};

/// Descriptor for `CopilotServiceRegenerateSectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceRegenerateSectionResponseDescriptor =
    $convert.base64Decode(
        'CidDb3BpbG90U2VydmljZVJlZ2VuZXJhdGVTZWN0aW9uUmVzcG9uc2USKQoQcmVnZW5lcmF0ZW'
        'RfdGV4dBgBIAEoCVIPcmVnZW5lcmF0ZWRUZXh0');

@$core.Deprecated('Use copilotServiceScoreIdeaRequestDescriptor instead')
const CopilotServiceScoreIdeaRequest$json = {
  '1': 'CopilotServiceScoreIdeaRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_text', '3': 2, '4': 1, '5': 9, '10': 'ideaText'},
  ],
};

/// Descriptor for `CopilotServiceScoreIdeaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceScoreIdeaRequestDescriptor =
    $convert.base64Decode(
        'Ch5Db3BpbG90U2VydmljZVNjb3JlSWRlYVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIbCglpZGVhX3RleHQYAiABKAlSCGlkZWFUZXh0');

@$core.Deprecated('Use copilotServiceScoreIdeaResponseDescriptor instead')
const CopilotServiceScoreIdeaResponse$json = {
  '1': 'CopilotServiceScoreIdeaResponse',
  '2': [
    {'1': 'virality_score', '3': 1, '4': 1, '5': 5, '10': 'viralityScore'},
    {'1': 'critique', '3': 2, '4': 1, '5': 9, '10': 'critique'},
  ],
};

/// Descriptor for `CopilotServiceScoreIdeaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceScoreIdeaResponseDescriptor =
    $convert.base64Decode(
        'Ch9Db3BpbG90U2VydmljZVNjb3JlSWRlYVJlc3BvbnNlEiUKDnZpcmFsaXR5X3Njb3JlGAEgAS'
        'gFUg12aXJhbGl0eVNjb3JlEhoKCGNyaXRpcXVlGAIgASgJUghjcml0aXF1ZQ==');

@$core.Deprecated('Use copilotServiceCheckBrandVoiceRequestDescriptor instead')
const CopilotServiceCheckBrandVoiceRequest$json = {
  '1': 'CopilotServiceCheckBrandVoiceRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'brand_pack_id', '3': 3, '4': 1, '5': 9, '10': 'brandPackId'},
  ],
};

/// Descriptor for `CopilotServiceCheckBrandVoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceCheckBrandVoiceRequestDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZUNoZWNrQnJhbmRWb2ljZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBISCgR0ZXh0GAIgASgJUgR0ZXh0EiIKDWJyYW5kX3BhY2tfaWQY'
        'AyABKAlSC2JyYW5kUGFja0lk');

@$core.Deprecated('Use copilotServiceCheckBrandVoiceResponseDescriptor instead')
const CopilotServiceCheckBrandVoiceResponse$json = {
  '1': 'CopilotServiceCheckBrandVoiceResponse',
  '2': [
    {
      '1': 'consistency_score',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'consistencyScore'
    },
    {'1': 'recommendations', '3': 2, '4': 3, '5': 9, '10': 'recommendations'},
  ],
};

/// Descriptor for `CopilotServiceCheckBrandVoiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceCheckBrandVoiceResponseDescriptor =
    $convert.base64Decode(
        'CiVDb3BpbG90U2VydmljZUNoZWNrQnJhbmRWb2ljZVJlc3BvbnNlEisKEWNvbnNpc3RlbmN5X3'
        'Njb3JlGAEgASgFUhBjb25zaXN0ZW5jeVNjb3JlEigKD3JlY29tbWVuZGF0aW9ucxgCIAMoCVIP'
        'cmVjb21tZW5kYXRpb25z');

@$core.Deprecated('Use copilotServiceAnalyzeAnalyticsRequestDescriptor instead')
const CopilotServiceAnalyzeAnalyticsRequest$json = {
  '1': 'CopilotServiceAnalyzeAnalyticsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'timeframe', '3': 2, '4': 1, '5': 9, '10': 'timeframe'},
  ],
};

/// Descriptor for `CopilotServiceAnalyzeAnalyticsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceAnalyzeAnalyticsRequestDescriptor =
    $convert.base64Decode(
        'CiVDb3BpbG90U2VydmljZUFuYWx5emVBbmFseXRpY3NSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSHAoJdGltZWZyYW1lGAIgASgJUgl0aW1lZnJhbWU=');

@$core
    .Deprecated('Use copilotServiceAnalyzeAnalyticsResponseDescriptor instead')
const CopilotServiceAnalyzeAnalyticsResponse$json = {
  '1': 'CopilotServiceAnalyzeAnalyticsResponse',
  '2': [
    {'1': 'summary', '3': 1, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'findings', '3': 2, '4': 3, '5': 9, '10': 'findings'},
    {'1': 'is_redacted', '3': 3, '4': 1, '5': 8, '10': 'isRedacted'},
  ],
};

/// Descriptor for `CopilotServiceAnalyzeAnalyticsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceAnalyzeAnalyticsResponseDescriptor =
    $convert.base64Decode(
        'CiZDb3BpbG90U2VydmljZUFuYWx5emVBbmFseXRpY3NSZXNwb25zZRIYCgdzdW1tYXJ5GAEgAS'
        'gJUgdzdW1tYXJ5EhoKCGZpbmRpbmdzGAIgAygJUghmaW5kaW5ncxIfCgtpc19yZWRhY3RlZBgD'
        'IAEoCFIKaXNSZWRhY3RlZA==');

@$core.Deprecated('Use copilotServiceAnalyzePipelineRequestDescriptor instead')
const CopilotServiceAnalyzePipelineRequest$json = {
  '1': 'CopilotServiceAnalyzePipelineRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `CopilotServiceAnalyzePipelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceAnalyzePipelineRequestDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZUFuYWx5emVQaXBlbGluZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated('Use copilotServiceAnalyzePipelineResponseDescriptor instead')
const CopilotServiceAnalyzePipelineResponse$json = {
  '1': 'CopilotServiceAnalyzePipelineResponse',
  '2': [
    {'1': 'pipeline_health', '3': 1, '4': 1, '5': 9, '10': 'pipelineHealth'},
    {'1': 'bottlenecks', '3': 2, '4': 3, '5': 9, '10': 'bottlenecks'},
  ],
};

/// Descriptor for `CopilotServiceAnalyzePipelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceAnalyzePipelineResponseDescriptor =
    $convert.base64Decode(
        'CiVDb3BpbG90U2VydmljZUFuYWx5emVQaXBlbGluZVJlc3BvbnNlEicKD3BpcGVsaW5lX2hlYW'
        'x0aBgBIAEoCVIOcGlwZWxpbmVIZWFsdGgSIAoLYm90dGxlbmVja3MYAiADKAlSC2JvdHRsZW5l'
        'Y2tz');

@$core
    .Deprecated('Use copilotServiceAnalyticsInsightsRequestDescriptor instead')
const CopilotServiceAnalyticsInsightsRequest$json = {
  '1': 'CopilotServiceAnalyticsInsightsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'module', '3': 2, '4': 1, '5': 9, '10': 'module'},
  ],
};

/// Descriptor for `CopilotServiceAnalyticsInsightsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceAnalyticsInsightsRequestDescriptor =
    $convert.base64Decode(
        'CiZDb3BpbG90U2VydmljZUFuYWx5dGljc0luc2lnaHRzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaW'
        'QYASABKAlSC3dvcmtzcGFjZUlkEhYKBm1vZHVsZRgCIAEoCVIGbW9kdWxl');

@$core
    .Deprecated('Use copilotServiceAnalyticsInsightsResponseDescriptor instead')
const CopilotServiceAnalyticsInsightsResponse$json = {
  '1': 'CopilotServiceAnalyticsInsightsResponse',
  '2': [
    {'1': 'insights', '3': 1, '4': 3, '5': 9, '10': 'insights'},
  ],
};

/// Descriptor for `CopilotServiceAnalyticsInsightsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceAnalyticsInsightsResponseDescriptor =
    $convert.base64Decode(
        'CidDb3BpbG90U2VydmljZUFuYWx5dGljc0luc2lnaHRzUmVzcG9uc2USGgoIaW5zaWdodHMYAS'
        'ADKAlSCGluc2lnaHRz');

@$core.Deprecated('Use copilotServiceFinanceInsightRequestDescriptor instead')
const CopilotServiceFinanceInsightRequest$json = {
  '1': 'CopilotServiceFinanceInsightRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'period', '3': 2, '4': 1, '5': 9, '10': 'period'},
  ],
};

/// Descriptor for `CopilotServiceFinanceInsightRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceFinanceInsightRequestDescriptor =
    $convert.base64Decode(
        'CiNDb3BpbG90U2VydmljZUZpbmFuY2VJbnNpZ2h0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEhYKBnBlcmlvZBgCIAEoCVIGcGVyaW9k');

@$core.Deprecated('Use copilotServiceFinanceInsightResponseDescriptor instead')
const CopilotServiceFinanceInsightResponse$json = {
  '1': 'CopilotServiceFinanceInsightResponse',
  '2': [
    {'1': 'insight', '3': 1, '4': 1, '5': 9, '10': 'insight'},
    {'1': 'is_redacted', '3': 2, '4': 1, '5': 8, '10': 'isRedacted'},
    {'1': 'redaction_reason', '3': 3, '4': 1, '5': 9, '10': 'redactionReason'},
  ],
};

/// Descriptor for `CopilotServiceFinanceInsightResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceFinanceInsightResponseDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZUZpbmFuY2VJbnNpZ2h0UmVzcG9uc2USGAoHaW5zaWdodBgBIAEoCV'
        'IHaW5zaWdodBIfCgtpc19yZWRhY3RlZBgCIAEoCFIKaXNSZWRhY3RlZBIpChByZWRhY3Rpb25f'
        'cmVhc29uGAMgASgJUg9yZWRhY3Rpb25SZWFzb24=');

@$core.Deprecated('Use copilotServiceTrendInsightRequestDescriptor instead')
const CopilotServiceTrendInsightRequest$json = {
  '1': 'CopilotServiceTrendInsightRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
  ],
};

/// Descriptor for `CopilotServiceTrendInsightRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceTrendInsightRequestDescriptor =
    $convert.base64Decode(
        'CiFDb3BpbG90U2VydmljZVRyZW5kSW5zaWdodFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIaCghjYXRlZ29yeRgCIAEoCVIIY2F0ZWdvcnk=');

@$core.Deprecated('Use copilotServiceTrendInsightResponseDescriptor instead')
const CopilotServiceTrendInsightResponse$json = {
  '1': 'CopilotServiceTrendInsightResponse',
  '2': [
    {
      '1': 'trend_recommendations',
      '3': 1,
      '4': 3,
      '5': 9,
      '10': 'trendRecommendations'
    },
  ],
};

/// Descriptor for `CopilotServiceTrendInsightResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceTrendInsightResponseDescriptor =
    $convert.base64Decode(
        'CiJDb3BpbG90U2VydmljZVRyZW5kSW5zaWdodFJlc3BvbnNlEjMKFXRyZW5kX3JlY29tbWVuZG'
        'F0aW9ucxgBIAMoCVIUdHJlbmRSZWNvbW1lbmRhdGlvbnM=');

@$core.Deprecated(
    'Use copilotServiceGetContentOptimizationRequestDescriptor instead')
const CopilotServiceGetContentOptimizationRequest$json = {
  '1': 'CopilotServiceGetContentOptimizationRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'content_id', '3': 2, '4': 1, '5': 9, '10': 'contentId'},
  ],
};

/// Descriptor for `CopilotServiceGetContentOptimizationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    copilotServiceGetContentOptimizationRequestDescriptor =
    $convert.base64Decode(
        'CitDb3BpbG90U2VydmljZUdldENvbnRlbnRPcHRpbWl6YXRpb25SZXF1ZXN0EiEKDHdvcmtzcG'
        'FjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSHQoKY29udGVudF9pZBgCIAEoCVIJY29udGVudElk');

@$core.Deprecated(
    'Use copilotServiceGetContentOptimizationResponseDescriptor instead')
const CopilotServiceGetContentOptimizationResponse$json = {
  '1': 'CopilotServiceGetContentOptimizationResponse',
  '2': [
    {'1': 'suggestions', '3': 1, '4': 3, '5': 9, '10': 'suggestions'},
  ],
};

/// Descriptor for `CopilotServiceGetContentOptimizationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    copilotServiceGetContentOptimizationResponseDescriptor =
    $convert.base64Decode(
        'CixDb3BpbG90U2VydmljZUdldENvbnRlbnRPcHRpbWl6YXRpb25SZXNwb25zZRIgCgtzdWdnZX'
        'N0aW9ucxgBIAMoCVILc3VnZ2VzdGlvbnM=');

@$core.Deprecated(
    'Use copilotServiceGetCostOptimizationRequestDescriptor instead')
const CopilotServiceGetCostOptimizationRequest$json = {
  '1': 'CopilotServiceGetCostOptimizationRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `CopilotServiceGetCostOptimizationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetCostOptimizationRequestDescriptor =
    $convert.base64Decode(
        'CihDb3BpbG90U2VydmljZUdldENvc3RPcHRpbWl6YXRpb25SZXF1ZXN0EiEKDHdvcmtzcGFjZV'
        '9pZBgBIAEoCVILd29ya3NwYWNlSWQ=');

@$core.Deprecated(
    'Use copilotServiceGetCostOptimizationResponseDescriptor instead')
const CopilotServiceGetCostOptimizationResponse$json = {
  '1': 'CopilotServiceGetCostOptimizationResponse',
  '2': [
    {'1': 'suggestions', '3': 1, '4': 3, '5': 9, '10': 'suggestions'},
    {'1': 'is_redacted', '3': 2, '4': 1, '5': 8, '10': 'isRedacted'},
  ],
};

/// Descriptor for `CopilotServiceGetCostOptimizationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    copilotServiceGetCostOptimizationResponseDescriptor = $convert.base64Decode(
        'CilDb3BpbG90U2VydmljZUdldENvc3RPcHRpbWl6YXRpb25SZXNwb25zZRIgCgtzdWdnZXN0aW'
        '9ucxgBIAMoCVILc3VnZ2VzdGlvbnMSHwoLaXNfcmVkYWN0ZWQYAiABKAhSCmlzUmVkYWN0ZWQ=');

@$core.Deprecated('Use copilotServiceGetOptimalTimesRequestDescriptor instead')
const CopilotServiceGetOptimalTimesRequest$json = {
  '1': 'CopilotServiceGetOptimalTimesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
  ],
};

/// Descriptor for `CopilotServiceGetOptimalTimesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetOptimalTimesRequestDescriptor =
    $convert.base64Decode(
        'CiRDb3BpbG90U2VydmljZUdldE9wdGltYWxUaW1lc1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBIaCghwbGF0Zm9ybRgCIAEoCVIIcGxhdGZvcm0=');

@$core.Deprecated('Use copilotServiceGetOptimalTimesResponseDescriptor instead')
const CopilotServiceGetOptimalTimesResponse$json = {
  '1': 'CopilotServiceGetOptimalTimesResponse',
  '2': [
    {
      '1': 'optimal_time_slots',
      '3': 1,
      '4': 3,
      '5': 9,
      '10': 'optimalTimeSlots'
    },
  ],
};

/// Descriptor for `CopilotServiceGetOptimalTimesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copilotServiceGetOptimalTimesResponseDescriptor =
    $convert.base64Decode(
        'CiVDb3BpbG90U2VydmljZUdldE9wdGltYWxUaW1lc1Jlc3BvbnNlEiwKEm9wdGltYWxfdGltZV'
        '9zbG90cxgBIAMoCVIQb3B0aW1hbFRpbWVTbG90cw==');

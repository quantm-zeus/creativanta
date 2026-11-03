// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/idea.proto.

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

@$core.Deprecated('Use ideaStatusDescriptor instead')
const IdeaStatus$json = {
  '1': 'IdeaStatus',
  '2': [
    {'1': 'IDEA_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'IDEA_STATUS_DRAFT', '2': 1},
    {'1': 'IDEA_STATUS_CANDIDATE', '2': 2},
    {'1': 'IDEA_STATUS_SELECTED', '2': 3},
    {'1': 'IDEA_STATUS_CONVERTED', '2': 4},
    {'1': 'IDEA_STATUS_ARCHIVED', '2': 5},
  ],
};

/// Descriptor for `IdeaStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List ideaStatusDescriptor = $convert.base64Decode(
    'CgpJZGVhU3RhdHVzEhsKF0lERUFfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFQoRSURFQV9TVEFUVV'
    'NfRFJBRlQQARIZChVJREVBX1NUQVRVU19DQU5ESURBVEUQAhIYChRJREVBX1NUQVRVU19TRUxF'
    'Q1RFRBADEhkKFUlERUFfU1RBVFVTX0NPTlZFUlRFRBAEEhgKFElERUFfU1RBVFVTX0FSQ0hJVk'
    'VEEAU=');

@$core.Deprecated('Use hookTypeDescriptor instead')
const HookType$json = {
  '1': 'HookType',
  '2': [
    {'1': 'HOOK_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'HOOK_TYPE_QUESTION', '2': 1},
    {'1': 'HOOK_TYPE_SHOCK', '2': 2},
    {'1': 'HOOK_TYPE_STORY', '2': 3},
    {'1': 'HOOK_TYPE_POV', '2': 4},
    {'1': 'HOOK_TYPE_LISTICLE', '2': 5},
    {'1': 'HOOK_TYPE_CONTRAST', '2': 6},
  ],
};

/// Descriptor for `HookType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hookTypeDescriptor = $convert.base64Decode(
    'CghIb29rVHlwZRIZChVIT09LX1RZUEVfVU5TUEVDSUZJRUQQABIWChJIT09LX1RZUEVfUVVFU1'
    'RJT04QARITCg9IT09LX1RZUEVfU0hPQ0sQAhITCg9IT09LX1RZUEVfU1RPUlkQAxIRCg1IT09L'
    'X1RZUEVfUE9WEAQSFgoSSE9PS19UWVBFX0xJU1RJQ0xFEAUSFgoSSE9PS19UWVBFX0NPTlRSQV'
    'NUEAY=');

@$core.Deprecated('Use hookSourceDescriptor instead')
const HookSource$json = {
  '1': 'HookSource',
  '2': [
    {'1': 'HOOK_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'HOOK_SOURCE_MANUAL', '2': 1},
    {'1': 'HOOK_SOURCE_AI_GENERATED', '2': 2},
    {'1': 'HOOK_SOURCE_LIBRARY', '2': 3},
  ],
};

/// Descriptor for `HookSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hookSourceDescriptor = $convert.base64Decode(
    'CgpIb29rU291cmNlEhsKF0hPT0tfU09VUkNFX1VOU1BFQ0lGSUVEEAASFgoSSE9PS19TT1VSQ0'
    'VfTUFOVUFMEAESHAoYSE9PS19TT1VSQ0VfQUlfR0VORVJBVEVEEAISFwoTSE9PS19TT1VSQ0Vf'
    'TElCUkFSWRAD');

@$core.Deprecated('Use ideaSourceRefDescriptor instead')
const IdeaSourceRef$json = {
  '1': 'IdeaSourceRef',
  '2': [
    {'1': 'source_type', '3': 1, '4': 1, '5': 9, '10': 'sourceType'},
    {'1': 'source_id', '3': 2, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'source_title', '3': 3, '4': 1, '5': 9, '10': 'sourceTitle'},
    {'1': 'source_url', '3': 4, '4': 1, '5': 9, '10': 'sourceUrl'},
    {'1': 'is_archived', '3': 5, '4': 1, '5': 8, '10': 'isArchived'},
    {'1': 'archive_notice', '3': 6, '4': 1, '5': 9, '10': 'archiveNotice'},
  ],
};

/// Descriptor for `IdeaSourceRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaSourceRefDescriptor = $convert.base64Decode(
    'Cg1JZGVhU291cmNlUmVmEh8KC3NvdXJjZV90eXBlGAEgASgJUgpzb3VyY2VUeXBlEhsKCXNvdX'
    'JjZV9pZBgCIAEoCVIIc291cmNlSWQSIQoMc291cmNlX3RpdGxlGAMgASgJUgtzb3VyY2VUaXRs'
    'ZRIdCgpzb3VyY2VfdXJsGAQgASgJUglzb3VyY2VVcmwSHwoLaXNfYXJjaGl2ZWQYBSABKAhSCm'
    'lzQXJjaGl2ZWQSJQoOYXJjaGl2ZV9ub3RpY2UYBiABKAlSDWFyY2hpdmVOb3RpY2U=');

@$core.Deprecated('Use hookDescriptor instead')
const Hook$json = {
  '1': 'Hook',
  '2': [
    {'1': 'hook_id', '3': 1, '4': 1, '5': 9, '10': 'hookId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_id', '3': 3, '4': 1, '5': 9, '10': 'ideaId'},
    {'1': 'hook_text', '3': 4, '4': 1, '5': 9, '10': 'hookText'},
    {
      '1': 'hook_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.HookType',
      '10': 'hookType'
    },
    {
      '1': 'effectiveness_score',
      '3': 6,
      '4': 1,
      '5': 2,
      '10': 'effectivenessScore'
    },
    {'1': 'usage_count', '3': 7, '4': 1, '5': 5, '10': 'usageCount'},
    {
      '1': 'source',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.HookSource',
      '10': 'source'
    },
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Hook`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hookDescriptor = $convert.base64Decode(
    'CgRIb29rEhcKB2hvb2tfaWQYASABKAlSBmhvb2tJZBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3'
    'dvcmtzcGFjZUlkEhcKB2lkZWFfaWQYAyABKAlSBmlkZWFJZBIbCglob29rX3RleHQYBCABKAlS'
    'CGhvb2tUZXh0Ej0KCWhvb2tfdHlwZRgFIAEoDjIgLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuSG'
    '9va1R5cGVSCGhvb2tUeXBlEi8KE2VmZmVjdGl2ZW5lc3Nfc2NvcmUYBiABKAJSEmVmZmVjdGl2'
    'ZW5lc3NTY29yZRIfCgt1c2FnZV9jb3VudBgHIAEoBVIKdXNhZ2VDb3VudBI6CgZzb3VyY2UYCC'
    'ABKA4yIi5jcmVhdGl2YW50YS5jb250ZW50LnYxLkhvb2tTb3VyY2VSBnNvdXJjZRI5CgpjcmVh'
    'dGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use duplicateWarningDescriptor instead')
const DuplicateWarning$json = {
  '1': 'DuplicateWarning',
  '2': [
    {'1': 'is_duplicate', '3': 1, '4': 1, '5': 8, '10': 'isDuplicate'},
    {'1': 'similarity_score', '3': 2, '4': 1, '5': 2, '10': 'similarityScore'},
    {'1': 'existing_idea_id', '3': 3, '4': 1, '5': 9, '10': 'existingIdeaId'},
    {
      '1': 'existing_idea_title',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'existingIdeaTitle'
    },
    {'1': 'warning_message', '3': 5, '4': 1, '5': 9, '10': 'warningMessage'},
  ],
};

/// Descriptor for `DuplicateWarning`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List duplicateWarningDescriptor = $convert.base64Decode(
    'ChBEdXBsaWNhdGVXYXJuaW5nEiEKDGlzX2R1cGxpY2F0ZRgBIAEoCFILaXNEdXBsaWNhdGUSKQ'
    'oQc2ltaWxhcml0eV9zY29yZRgCIAEoAlIPc2ltaWxhcml0eVNjb3JlEigKEGV4aXN0aW5nX2lk'
    'ZWFfaWQYAyABKAlSDmV4aXN0aW5nSWRlYUlkEi4KE2V4aXN0aW5nX2lkZWFfdGl0bGUYBCABKA'
    'lSEWV4aXN0aW5nSWRlYVRpdGxlEicKD3dhcm5pbmdfbWVzc2FnZRgFIAEoCVIOd2FybmluZ01l'
    'c3NhZ2U=');

@$core.Deprecated('Use ideaDescriptor instead')
const Idea$json = {
  '1': 'Idea',
  '2': [
    {'1': 'idea_id', '3': 1, '4': 1, '5': 9, '10': 'ideaId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'audience_intent', '3': 5, '4': 1, '5': 9, '10': 'audienceIntent'},
    {'1': 'creator_intent', '3': 6, '4': 1, '5': 9, '10': 'creatorIntent'},
    {'1': 'suggested_format', '3': 7, '4': 1, '5': 9, '10': 'suggestedFormat'},
    {
      '1': 'suggested_direction',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'suggestedDirection'
    },
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.IdeaStatus',
      '10': 'status'
    },
    {'1': 'idea_score', '3': 10, '4': 1, '5': 2, '10': 'ideaScore'},
    {
      '1': 'converted_to_type',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'convertedToType'
    },
    {'1': 'converted_to_id', '3': 12, '4': 1, '5': 9, '10': 'convertedToId'},
    {'1': 'created_by', '3': 13, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'sources',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.IdeaSourceRef',
      '10': 'sources'
    },
    {
      '1': 'hooks',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Hook',
      '10': 'hooks'
    },
    {'1': 'embedding_vector', '3': 16, '4': 3, '5': 2, '10': 'embeddingVector'},
    {
      '1': 'created_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'source_class',
      '3': 19,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence',
      '3': 20,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'recommended_formats',
      '3': 21,
      '4': 3,
      '5': 9,
      '10': 'recommendedFormats'
    },
    {
      '1': 'recommended_platforms',
      '3': 22,
      '4': 3,
      '5': 9,
      '10': 'recommendedPlatforms'
    },
    {'1': 'angle', '3': 23, '4': 1, '5': 9, '10': 'angle'},
    {'1': 'hook_suggestion', '3': 24, '4': 1, '5': 9, '10': 'hookSuggestion'},
  ],
};

/// Descriptor for `Idea`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaDescriptor = $convert.base64Decode(
    'CgRJZGVhEhcKB2lkZWFfaWQYASABKAlSBmlkZWFJZBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3'
    'dvcmtzcGFjZUlkEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgEIAEoCVIL'
    'ZGVzY3JpcHRpb24SJwoPYXVkaWVuY2VfaW50ZW50GAUgASgJUg5hdWRpZW5jZUludGVudBIlCg'
    '5jcmVhdG9yX2ludGVudBgGIAEoCVINY3JlYXRvckludGVudBIpChBzdWdnZXN0ZWRfZm9ybWF0'
    'GAcgASgJUg9zdWdnZXN0ZWRGb3JtYXQSLwoTc3VnZ2VzdGVkX2RpcmVjdGlvbhgIIAEoCVISc3'
    'VnZ2VzdGVkRGlyZWN0aW9uEjoKBnN0YXR1cxgJIAEoDjIiLmNyZWF0aXZhbnRhLmNvbnRlbnQu'
    'djEuSWRlYVN0YXR1c1IGc3RhdHVzEh0KCmlkZWFfc2NvcmUYCiABKAJSCWlkZWFTY29yZRIqCh'
    'Fjb252ZXJ0ZWRfdG9fdHlwZRgLIAEoCVIPY29udmVydGVkVG9UeXBlEiYKD2NvbnZlcnRlZF90'
    'b19pZBgMIAEoCVINY29udmVydGVkVG9JZBIdCgpjcmVhdGVkX2J5GA0gASgJUgljcmVhdGVkQn'
    'kSPwoHc291cmNlcxgOIAMoCzIlLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuSWRlYVNvdXJjZVJl'
    'ZlIHc291cmNlcxIyCgVob29rcxgPIAMoCzIcLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuSG9va1'
    'IFaG9va3MSKQoQZW1iZWRkaW5nX3ZlY3RvchgQIAMoAlIPZW1iZWRkaW5nVmVjdG9yEjkKCmNy'
    'ZWF0ZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQ'
    'oKdXBkYXRlZF9hdBgSIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRB'
    'dBJLCgxzb3VyY2VfY2xhc3MYEyABKA4yKC5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuU2'
    '91cmNlQ2xhc3NSC3NvdXJjZUNsYXNzEksKCmNvbmZpZGVuY2UYFCABKA4yKy5jcmVhdGl2YW50'
    'YS5pbnRlbGxpZ2VuY2UudjEuQ29uZmlkZW5jZUJhbmRSCmNvbmZpZGVuY2USLwoTcmVjb21tZW'
    '5kZWRfZm9ybWF0cxgVIAMoCVIScmVjb21tZW5kZWRGb3JtYXRzEjMKFXJlY29tbWVuZGVkX3Bs'
    'YXRmb3JtcxgWIAMoCVIUcmVjb21tZW5kZWRQbGF0Zm9ybXMSFAoFYW5nbGUYFyABKAlSBWFuZ2'
    'xlEicKD2hvb2tfc3VnZ2VzdGlvbhgYIAEoCVIOaG9va1N1Z2dlc3Rpb24=');

@$core.Deprecated('Use ideaServiceCreateRequestDescriptor instead')
const IdeaServiceCreateRequest$json = {
  '1': 'IdeaServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'audience_intent', '3': 4, '4': 1, '5': 9, '10': 'audienceIntent'},
    {'1': 'creator_intent', '3': 5, '4': 1, '5': 9, '10': 'creatorIntent'},
    {'1': 'suggested_format', '3': 6, '4': 1, '5': 9, '10': 'suggestedFormat'},
    {
      '1': 'suggested_direction',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'suggestedDirection'
    },
    {
      '1': 'source_refs',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.IdeaSourceRef',
      '10': 'sourceRefs'
    },
    {'1': 'initial_hooks', '3': 9, '4': 3, '5': 9, '10': 'initialHooks'},
    {
      '1': 'confirm_duplicate',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'confirmDuplicate'
    },
    {
      '1': 'check_duplicate_only',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'checkDuplicateOnly'
    },
    {
      '1': 'is_mobile_quick_capture',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'isMobileQuickCapture'
    },
  ],
};

/// Descriptor for `IdeaServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChhJZGVhU2VydmljZUNyZWF0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2Ny'
    'aXB0aW9uEicKD2F1ZGllbmNlX2ludGVudBgEIAEoCVIOYXVkaWVuY2VJbnRlbnQSJQoOY3JlYX'
    'Rvcl9pbnRlbnQYBSABKAlSDWNyZWF0b3JJbnRlbnQSKQoQc3VnZ2VzdGVkX2Zvcm1hdBgGIAEo'
    'CVIPc3VnZ2VzdGVkRm9ybWF0Ei8KE3N1Z2dlc3RlZF9kaXJlY3Rpb24YByABKAlSEnN1Z2dlc3'
    'RlZERpcmVjdGlvbhJGCgtzb3VyY2VfcmVmcxgIIAMoCzIlLmNyZWF0aXZhbnRhLmNvbnRlbnQu'
    'djEuSWRlYVNvdXJjZVJlZlIKc291cmNlUmVmcxIjCg1pbml0aWFsX2hvb2tzGAkgAygJUgxpbm'
    'l0aWFsSG9va3MSKwoRY29uZmlybV9kdXBsaWNhdGUYCiABKAhSEGNvbmZpcm1EdXBsaWNhdGUS'
    'MAoUY2hlY2tfZHVwbGljYXRlX29ubHkYCyABKAhSEmNoZWNrRHVwbGljYXRlT25seRI1Chdpc1'
    '9tb2JpbGVfcXVpY2tfY2FwdHVyZRgMIAEoCFIUaXNNb2JpbGVRdWlja0NhcHR1cmU=');

@$core.Deprecated('Use ideaServiceCreateResponseDescriptor instead')
const IdeaServiceCreateResponse$json = {
  '1': 'IdeaServiceCreateResponse',
  '2': [
    {
      '1': 'idea',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'idea'
    },
    {
      '1': 'duplicate_warning',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.DuplicateWarning',
      '10': 'duplicateWarning'
    },
    {'1': 'created', '3': 3, '4': 1, '5': 8, '10': 'created'},
  ],
};

/// Descriptor for `IdeaServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceCreateResponseDescriptor = $convert.base64Decode(
    'ChlJZGVhU2VydmljZUNyZWF0ZVJlc3BvbnNlEjAKBGlkZWEYASABKAsyHC5jcmVhdGl2YW50YS'
    '5jb250ZW50LnYxLklkZWFSBGlkZWESVQoRZHVwbGljYXRlX3dhcm5pbmcYAiABKAsyKC5jcmVh'
    'dGl2YW50YS5jb250ZW50LnYxLkR1cGxpY2F0ZVdhcm5pbmdSEGR1cGxpY2F0ZVdhcm5pbmcSGA'
    'oHY3JlYXRlZBgDIAEoCFIHY3JlYXRlZA==');

@$core.Deprecated('Use ideaServiceListRequestDescriptor instead')
const IdeaServiceListRequest$json = {
  '1': 'IdeaServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.IdeaStatus',
      '10': 'status'
    },
    {'1': 'source_type', '3': 3, '4': 1, '5': 9, '10': 'sourceType'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'search_query', '3': 6, '4': 1, '5': 9, '10': 'searchQuery'},
  ],
};

/// Descriptor for `IdeaServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceListRequestDescriptor = $convert.base64Decode(
    'ChZJZGVhU2VydmljZUxpc3RSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSOgoGc3RhdHVzGAIgASgOMiIuY3JlYXRpdmFudGEuY29udGVudC52MS5JZGVhU3RhdHVz'
    'UgZzdGF0dXMSHwoLc291cmNlX3R5cGUYAyABKAlSCnNvdXJjZVR5cGUSGwoJcGFnZV9zaXplGA'
    'QgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2VuGAUgASgJUglwYWdlVG9rZW4SIQoMc2VhcmNo'
    'X3F1ZXJ5GAYgASgJUgtzZWFyY2hRdWVyeQ==');

@$core.Deprecated('Use ideaServiceListResponseDescriptor instead')
const IdeaServiceListResponse$json = {
  '1': 'IdeaServiceListResponse',
  '2': [
    {
      '1': 'ideas',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'ideas'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `IdeaServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceListResponseDescriptor = $convert.base64Decode(
    'ChdJZGVhU2VydmljZUxpc3RSZXNwb25zZRIyCgVpZGVhcxgBIAMoCzIcLmNyZWF0aXZhbnRhLm'
    'NvbnRlbnQudjEuSWRlYVIFaWRlYXMSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJUg1uZXh0UGFn'
    'ZVRva2VuEh8KC3RvdGFsX2NvdW50GAMgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use ideaServiceGetRequestDescriptor instead')
const IdeaServiceGetRequest$json = {
  '1': 'IdeaServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_id', '3': 2, '4': 1, '5': 9, '10': 'ideaId'},
  ],
};

/// Descriptor for `IdeaServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceGetRequestDescriptor = $convert.base64Decode(
    'ChVJZGVhU2VydmljZUdldFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2'
    'VJZBIXCgdpZGVhX2lkGAIgASgJUgZpZGVhSWQ=');

@$core.Deprecated('Use ideaServiceGetResponseDescriptor instead')
const IdeaServiceGetResponse$json = {
  '1': 'IdeaServiceGetResponse',
  '2': [
    {
      '1': 'idea',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'idea'
    },
  ],
};

/// Descriptor for `IdeaServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChZJZGVhU2VydmljZUdldFJlc3BvbnNlEjAKBGlkZWEYASABKAsyHC5jcmVhdGl2YW50YS5jb2'
        '50ZW50LnYxLklkZWFSBGlkZWE=');

@$core.Deprecated('Use ideaServiceUpdateRequestDescriptor instead')
const IdeaServiceUpdateRequest$json = {
  '1': 'IdeaServiceUpdateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_id', '3': 2, '4': 1, '5': 9, '10': 'ideaId'},
    {
      '1': 'expected_updated_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expectedUpdatedAt'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'audience_intent', '3': 6, '4': 1, '5': 9, '10': 'audienceIntent'},
    {'1': 'creator_intent', '3': 7, '4': 1, '5': 9, '10': 'creatorIntent'},
    {'1': 'suggested_format', '3': 8, '4': 1, '5': 9, '10': 'suggestedFormat'},
    {
      '1': 'suggested_direction',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'suggestedDirection'
    },
    {'1': 'angle', '3': 10, '4': 1, '5': 9, '10': 'angle'},
  ],
};

/// Descriptor for `IdeaServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChhJZGVhU2VydmljZVVwZGF0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIXCgdpZGVhX2lkGAIgASgJUgZpZGVhSWQSSgoTZXhwZWN0ZWRfdXBkYXRlZF9hdBgD'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSEWV4cGVjdGVkVXBkYXRlZEF0EhQKBX'
    'RpdGxlGAQgASgJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SJwoP'
    'YXVkaWVuY2VfaW50ZW50GAYgASgJUg5hdWRpZW5jZUludGVudBIlCg5jcmVhdG9yX2ludGVudB'
    'gHIAEoCVINY3JlYXRvckludGVudBIpChBzdWdnZXN0ZWRfZm9ybWF0GAggASgJUg9zdWdnZXN0'
    'ZWRGb3JtYXQSLwoTc3VnZ2VzdGVkX2RpcmVjdGlvbhgJIAEoCVISc3VnZ2VzdGVkRGlyZWN0aW'
    '9uEhQKBWFuZ2xlGAogASgJUgVhbmdsZQ==');

@$core.Deprecated('Use ideaServiceUpdateResponseDescriptor instead')
const IdeaServiceUpdateResponse$json = {
  '1': 'IdeaServiceUpdateResponse',
  '2': [
    {
      '1': 'idea',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'idea'
    },
  ],
};

/// Descriptor for `IdeaServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'ChlJZGVhU2VydmljZVVwZGF0ZVJlc3BvbnNlEjAKBGlkZWEYASABKAsyHC5jcmVhdGl2YW50YS'
        '5jb250ZW50LnYxLklkZWFSBGlkZWE=');

@$core.Deprecated('Use ideaServiceDeleteRequestDescriptor instead')
const IdeaServiceDeleteRequest$json = {
  '1': 'IdeaServiceDeleteRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_id', '3': 2, '4': 1, '5': 9, '10': 'ideaId'},
  ],
};

/// Descriptor for `IdeaServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceDeleteRequestDescriptor =
    $convert.base64Decode(
        'ChhJZGVhU2VydmljZURlbGV0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
        'BhY2VJZBIXCgdpZGVhX2lkGAIgASgJUgZpZGVhSWQ=');

@$core.Deprecated('Use ideaServiceDeleteResponseDescriptor instead')
const IdeaServiceDeleteResponse$json = {
  '1': 'IdeaServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `IdeaServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'ChlJZGVhU2VydmljZURlbGV0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use ideaServiceUpdateStatusRequestDescriptor instead')
const IdeaServiceUpdateStatusRequest$json = {
  '1': 'IdeaServiceUpdateStatusRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_id', '3': 2, '4': 1, '5': 9, '10': 'ideaId'},
    {
      '1': 'expected_updated_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expectedUpdatedAt'
    },
    {
      '1': 'target_status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.IdeaStatus',
      '10': 'targetStatus'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `IdeaServiceUpdateStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceUpdateStatusRequestDescriptor = $convert.base64Decode(
    'Ch5JZGVhU2VydmljZVVwZGF0ZVN0YXR1c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
    't3b3Jrc3BhY2VJZBIXCgdpZGVhX2lkGAIgASgJUgZpZGVhSWQSSgoTZXhwZWN0ZWRfdXBkYXRl'
    'ZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSEWV4cGVjdGVkVXBkYXRlZE'
    'F0EkcKDXRhcmdldF9zdGF0dXMYBCABKA4yIi5jcmVhdGl2YW50YS5jb250ZW50LnYxLklkZWFT'
    'dGF0dXNSDHRhcmdldFN0YXR1cxIWCgZyZWFzb24YBSABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use ideaServiceUpdateStatusResponseDescriptor instead')
const IdeaServiceUpdateStatusResponse$json = {
  '1': 'IdeaServiceUpdateStatusResponse',
  '2': [
    {
      '1': 'idea',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'idea'
    },
  ],
};

/// Descriptor for `IdeaServiceUpdateStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceUpdateStatusResponseDescriptor =
    $convert.base64Decode(
        'Ch9JZGVhU2VydmljZVVwZGF0ZVN0YXR1c1Jlc3BvbnNlEjAKBGlkZWEYASABKAsyHC5jcmVhdG'
        'l2YW50YS5jb250ZW50LnYxLklkZWFSBGlkZWE=');

@$core.Deprecated('Use ideaServiceGenerateRequestDescriptor instead')
const IdeaServiceGenerateRequest$json = {
  '1': 'IdeaServiceGenerateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'prompt', '3': 2, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'source_type', '3': 3, '4': 1, '5': 9, '10': 'sourceType'},
    {'1': 'source_id', '3': 4, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'target_audience', '3': 5, '4': 1, '5': 9, '10': 'targetAudience'},
    {'1': 'count', '3': 6, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `IdeaServiceGenerateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceGenerateRequestDescriptor = $convert.base64Decode(
    'ChpJZGVhU2VydmljZUdlbmVyYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhYKBnByb21wdBgCIAEoCVIGcHJvbXB0Eh8KC3NvdXJjZV90eXBlGAMgASgJUgpz'
    'b3VyY2VUeXBlEhsKCXNvdXJjZV9pZBgEIAEoCVIIc291cmNlSWQSJwoPdGFyZ2V0X2F1ZGllbm'
    'NlGAUgASgJUg50YXJnZXRBdWRpZW5jZRIUCgVjb3VudBgGIAEoBVIFY291bnQ=');

@$core.Deprecated('Use ideaServiceGenerateResponseDescriptor instead')
const IdeaServiceGenerateResponse$json = {
  '1': 'IdeaServiceGenerateResponse',
  '2': [
    {
      '1': 'generated_ideas',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'generatedIdeas'
    },
    {
      '1': 'remaining_hourly_quota',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'remainingHourlyQuota'
    },
  ],
};

/// Descriptor for `IdeaServiceGenerateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceGenerateResponseDescriptor =
    $convert.base64Decode(
        'ChtJZGVhU2VydmljZUdlbmVyYXRlUmVzcG9uc2USRQoPZ2VuZXJhdGVkX2lkZWFzGAEgAygLMh'
        'wuY3JlYXRpdmFudGEuY29udGVudC52MS5JZGVhUg5nZW5lcmF0ZWRJZGVhcxI0ChZyZW1haW5p'
        'bmdfaG91cmx5X3F1b3RhGAIgASgFUhRyZW1haW5pbmdIb3VybHlRdW90YQ==');

@$core.Deprecated('Use ideaServiceConvertRequestDescriptor instead')
const IdeaServiceConvertRequest$json = {
  '1': 'IdeaServiceConvertRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_id', '3': 2, '4': 1, '5': 9, '10': 'ideaId'},
    {
      '1': 'expected_updated_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expectedUpdatedAt'
    },
    {'1': 'conversion_type', '3': 4, '4': 1, '5': 9, '10': 'conversionType'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `IdeaServiceConvertRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceConvertRequestDescriptor = $convert.base64Decode(
    'ChlJZGVhU2VydmljZUNvbnZlcnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSFwoHaWRlYV9pZBgCIAEoCVIGaWRlYUlkEkoKE2V4cGVjdGVkX3VwZGF0ZWRfYXQY'
    'AyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhFleHBlY3RlZFVwZGF0ZWRBdBInCg'
    '9jb252ZXJzaW9uX3R5cGUYBCABKAlSDmNvbnZlcnNpb25UeXBlEhQKBXRpdGxlGAUgASgJUgV0'
    'aXRsZQ==');

@$core.Deprecated('Use ideaServiceConvertResponseDescriptor instead')
const IdeaServiceConvertResponse$json = {
  '1': 'IdeaServiceConvertResponse',
  '2': [
    {
      '1': 'idea',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'idea'
    },
    {'1': 'converted_to_type', '3': 2, '4': 1, '5': 9, '10': 'convertedToType'},
    {'1': 'converted_to_id', '3': 3, '4': 1, '5': 9, '10': 'convertedToId'},
    {'1': 'script_id', '3': 4, '4': 1, '5': 9, '10': 'scriptId'},
  ],
};

/// Descriptor for `IdeaServiceConvertResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceConvertResponseDescriptor = $convert.base64Decode(
    'ChpJZGVhU2VydmljZUNvbnZlcnRSZXNwb25zZRIwCgRpZGVhGAEgASgLMhwuY3JlYXRpdmFudG'
    'EuY29udGVudC52MS5JZGVhUgRpZGVhEioKEWNvbnZlcnRlZF90b190eXBlGAIgASgJUg9jb252'
    'ZXJ0ZWRUb1R5cGUSJgoPY29udmVydGVkX3RvX2lkGAMgASgJUg1jb252ZXJ0ZWRUb0lkEhsKCX'
    'NjcmlwdF9pZBgEIAEoCVIIc2NyaXB0SWQ=');

@$core.Deprecated('Use ideaServiceSearchRequestDescriptor instead')
const IdeaServiceSearchRequest$json = {
  '1': 'IdeaServiceSearchRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '10': 'query'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'min_similarity', '3': 4, '4': 1, '5': 2, '10': 'minSimilarity'},
  ],
};

/// Descriptor for `IdeaServiceSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceSearchRequestDescriptor = $convert.base64Decode(
    'ChhJZGVhU2VydmljZVNlYXJjaFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIUCgVxdWVyeRgCIAEoCVIFcXVlcnkSFAoFbGltaXQYAyABKAVSBWxpbWl0EiUKDm1p'
    'bl9zaW1pbGFyaXR5GAQgASgCUg1taW5TaW1pbGFyaXR5');

@$core.Deprecated('Use ideaServiceSearchResponseDescriptor instead')
const IdeaServiceSearchResponse$json = {
  '1': 'IdeaServiceSearchResponse',
  '2': [
    {
      '1': 'ideas',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'ideas'
    },
    {
      '1': 'similarity_scores',
      '3': 2,
      '4': 3,
      '5': 2,
      '10': 'similarityScores'
    },
  ],
};

/// Descriptor for `IdeaServiceSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceSearchResponseDescriptor = $convert.base64Decode(
    'ChlJZGVhU2VydmljZVNlYXJjaFJlc3BvbnNlEjIKBWlkZWFzGAEgAygLMhwuY3JlYXRpdmFudG'
    'EuY29udGVudC52MS5JZGVhUgVpZGVhcxIrChFzaW1pbGFyaXR5X3Njb3JlcxgCIAMoAlIQc2lt'
    'aWxhcml0eVNjb3Jlcw==');

@$core.Deprecated('Use ideaServiceCreateFromTrendRequestDescriptor instead')
const IdeaServiceCreateFromTrendRequest$json = {
  '1': 'IdeaServiceCreateFromTrendRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'trend_id', '3': 2, '4': 1, '5': 9, '10': 'trendId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'audience_intent', '3': 4, '4': 1, '5': 9, '10': 'audienceIntent'},
  ],
};

/// Descriptor for `IdeaServiceCreateFromTrendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceCreateFromTrendRequestDescriptor =
    $convert.base64Decode(
        'CiFJZGVhU2VydmljZUNyZWF0ZUZyb21UcmVuZFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIZCgh0cmVuZF9pZBgCIAEoCVIHdHJlbmRJZBIUCgV0aXRsZRgDIAEo'
        'CVIFdGl0bGUSJwoPYXVkaWVuY2VfaW50ZW50GAQgASgJUg5hdWRpZW5jZUludGVudA==');

@$core.Deprecated('Use ideaServiceCreateFromTrendResponseDescriptor instead')
const IdeaServiceCreateFromTrendResponse$json = {
  '1': 'IdeaServiceCreateFromTrendResponse',
  '2': [
    {
      '1': 'idea',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'idea'
    },
  ],
};

/// Descriptor for `IdeaServiceCreateFromTrendResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceCreateFromTrendResponseDescriptor =
    $convert.base64Decode(
        'CiJJZGVhU2VydmljZUNyZWF0ZUZyb21UcmVuZFJlc3BvbnNlEjAKBGlkZWEYASABKAsyHC5jcm'
        'VhdGl2YW50YS5jb250ZW50LnYxLklkZWFSBGlkZWE=');

@$core.Deprecated('Use ideaServiceListMobileRequestDescriptor instead')
const IdeaServiceListMobileRequest$json = {
  '1': 'IdeaServiceListMobileRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.IdeaStatus',
      '10': 'status'
    },
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `IdeaServiceListMobileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceListMobileRequestDescriptor =
    $convert.base64Decode(
        'ChxJZGVhU2VydmljZUxpc3RNb2JpbGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSOgoGc3RhdHVzGAIgASgOMiIuY3JlYXRpdmFudGEuY29udGVudC52MS5JZGVh'
        'U3RhdHVzUgZzdGF0dXMSFAoFbGltaXQYAyABKAVSBWxpbWl0');

@$core.Deprecated('Use ideaServiceListMobileResponseDescriptor instead')
const IdeaServiceListMobileResponse$json = {
  '1': 'IdeaServiceListMobileResponse',
  '2': [
    {
      '1': 'ideas',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Idea',
      '10': 'ideas'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `IdeaServiceListMobileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ideaServiceListMobileResponseDescriptor =
    $convert.base64Decode(
        'Ch1JZGVhU2VydmljZUxpc3RNb2JpbGVSZXNwb25zZRIyCgVpZGVhcxgBIAMoCzIcLmNyZWF0aX'
        'ZhbnRhLmNvbnRlbnQudjEuSWRlYVIFaWRlYXMSHwoLdG90YWxfY291bnQYAiABKAVSCnRvdGFs'
        'Q291bnQ=');

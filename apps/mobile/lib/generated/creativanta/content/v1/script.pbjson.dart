// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/script.proto.

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

@$core.Deprecated('Use scriptLifecycleStateDescriptor instead')
const ScriptLifecycleState$json = {
  '1': 'ScriptLifecycleState',
  '2': [
    {'1': 'SCRIPT_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SCRIPT_LIFECYCLE_STATE_DRAFT', '2': 1},
    {'1': 'SCRIPT_LIFECYCLE_STATE_IN_REVIEW', '2': 2},
    {'1': 'SCRIPT_LIFECYCLE_STATE_APPROVED', '2': 3},
    {'1': 'SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED', '2': 4},
    {'1': 'SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION', '2': 5},
    {'1': 'SCRIPT_LIFECYCLE_STATE_ARCHIVED', '2': 6},
  ],
};

/// Descriptor for `ScriptLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List scriptLifecycleStateDescriptor = $convert.base64Decode(
    'ChRTY3JpcHRMaWZlY3ljbGVTdGF0ZRImCiJTQ1JJUFRfTElGRUNZQ0xFX1NUQVRFX1VOU1BFQ0'
    'lGSUVEEAASIAocU0NSSVBUX0xJRkVDWUNMRV9TVEFURV9EUkFGVBABEiQKIFNDUklQVF9MSUZF'
    'Q1lDTEVfU1RBVEVfSU5fUkVWSUVXEAISIwofU0NSSVBUX0xJRkVDWUNMRV9TVEFURV9BUFBST1'
    'ZFRBADEiwKKFNDUklQVF9MSUZFQ1lDTEVfU1RBVEVfUkVWSVNJT05fUkVRVUlSRUQQBBIvCitT'
    'Q1JJUFRfTElGRUNZQ0xFX1NUQVRFX1JFQURZX0ZPUl9QUk9EVUNUSU9OEAUSIwofU0NSSVBUX0'
    'xJRkVDWUNMRV9TVEFURV9BUkNISVZFRBAG');

@$core.Deprecated('Use scriptApprovalStateDescriptor instead')
const ScriptApprovalState$json = {
  '1': 'ScriptApprovalState',
  '2': [
    {'1': 'SCRIPT_APPROVAL_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SCRIPT_APPROVAL_STATE_NOT_SUBMITTED', '2': 1},
    {'1': 'SCRIPT_APPROVAL_STATE_PENDING_APPROVAL', '2': 2},
    {'1': 'SCRIPT_APPROVAL_STATE_APPROVED', '2': 3},
    {'1': 'SCRIPT_APPROVAL_STATE_REJECTED', '2': 4},
  ],
};

/// Descriptor for `ScriptApprovalState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List scriptApprovalStateDescriptor = $convert.base64Decode(
    'ChNTY3JpcHRBcHByb3ZhbFN0YXRlEiUKIVNDUklQVF9BUFBST1ZBTF9TVEFURV9VTlNQRUNJRk'
    'lFRBAAEicKI1NDUklQVF9BUFBST1ZBTF9TVEFURV9OT1RfU1VCTUlUVEVEEAESKgomU0NSSVBU'
    'X0FQUFJPVkFMX1NUQVRFX1BFTkRJTkdfQVBQUk9WQUwQAhIiCh5TQ1JJUFRfQVBQUk9WQUxfU1'
    'RBVEVfQVBQUk9WRUQQAxIiCh5TQ1JJUFRfQVBQUk9WQUxfU1RBVEVfUkVKRUNURUQQBA==');

@$core.Deprecated('Use assetBriefStatusDescriptor instead')
const AssetBriefStatus$json = {
  '1': 'AssetBriefStatus',
  '2': [
    {'1': 'ASSET_BRIEF_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ASSET_BRIEF_STATUS_DRAFT', '2': 1},
    {'1': 'ASSET_BRIEF_STATUS_READY', '2': 2},
    {'1': 'ASSET_BRIEF_STATUS_LOCKED', '2': 3},
    {'1': 'ASSET_BRIEF_STATUS_SUPERSEDED', '2': 4},
  ],
};

/// Descriptor for `AssetBriefStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetBriefStatusDescriptor = $convert.base64Decode(
    'ChBBc3NldEJyaWVmU3RhdHVzEiIKHkFTU0VUX0JSSUVGX1NUQVRVU19VTlNQRUNJRklFRBAAEh'
    'wKGEFTU0VUX0JSSUVGX1NUQVRVU19EUkFGVBABEhwKGEFTU0VUX0JSSUVGX1NUQVRVU19SRUFE'
    'WRACEh0KGUFTU0VUX0JSSUVGX1NUQVRVU19MT0NLRUQQAxIhCh1BU1NFVF9CUklFRl9TVEFUVV'
    'NfU1VQRVJTRURFRBAE');

@$core.Deprecated('Use shotDescriptor instead')
const Shot$json = {
  '1': 'Shot',
  '2': [
    {'1': 'shot_id', '3': 1, '4': 1, '5': 9, '10': 'shotId'},
    {'1': 'scene_id', '3': 2, '4': 1, '5': 9, '10': 'sceneId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'shot_index', '3': 4, '4': 1, '5': 5, '10': 'shotIndex'},
    {'1': 'shot_type', '3': 5, '4': 1, '5': 9, '10': 'shotType'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {'1': 'duration_seconds', '3': 7, '4': 1, '5': 5, '10': 'durationSeconds'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Shot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shotDescriptor = $convert.base64Decode(
    'CgRTaG90EhcKB3Nob3RfaWQYASABKAlSBnNob3RJZBIZCghzY2VuZV9pZBgCIAEoCVIHc2Nlbm'
    'VJZBIhCgx3b3Jrc3BhY2VfaWQYAyABKAlSC3dvcmtzcGFjZUlkEh0KCnNob3RfaW5kZXgYBCAB'
    'KAVSCXNob3RJbmRleBIbCglzaG90X3R5cGUYBSABKAlSCHNob3RUeXBlEiAKC2Rlc2NyaXB0aW'
    '9uGAYgASgJUgtkZXNjcmlwdGlvbhIpChBkdXJhdGlvbl9zZWNvbmRzGAcgASgFUg9kdXJhdGlv'
    'blNlY29uZHMSOQoKY3JlYXRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use sceneDescriptor instead')
const Scene$json = {
  '1': 'Scene',
  '2': [
    {'1': 'scene_id', '3': 1, '4': 1, '5': 9, '10': 'sceneId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'scene_index', '3': 4, '4': 1, '5': 5, '10': 'sceneIndex'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'content', '3': 6, '4': 1, '5': 9, '10': 'content'},
    {'1': 'duration_seconds', '3': 7, '4': 1, '5': 5, '10': 'durationSeconds'},
    {'1': 'visual_notes', '3': 8, '4': 1, '5': 9, '10': 'visualNotes'},
    {'1': 'audio_notes', '3': 9, '4': 1, '5': 9, '10': 'audioNotes'},
    {
      '1': 'shot_list',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Shot',
      '10': 'shotList'
    },
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Scene`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sceneDescriptor = $convert.base64Decode(
    'CgVTY2VuZRIZCghzY2VuZV9pZBgBIAEoCVIHc2NlbmVJZBIbCglzY3JpcHRfaWQYAiABKAlSCH'
    'NjcmlwdElkEiEKDHdvcmtzcGFjZV9pZBgDIAEoCVILd29ya3NwYWNlSWQSHwoLc2NlbmVfaW5k'
    'ZXgYBCABKAVSCnNjZW5lSW5kZXgSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEh'
    'gKB2NvbnRlbnQYBiABKAlSB2NvbnRlbnQSKQoQZHVyYXRpb25fc2Vjb25kcxgHIAEoBVIPZHVy'
    'YXRpb25TZWNvbmRzEiEKDHZpc3VhbF9ub3RlcxgIIAEoCVILdmlzdWFsTm90ZXMSHwoLYXVkaW'
    '9fbm90ZXMYCSABKAlSCmF1ZGlvTm90ZXMSOQoJc2hvdF9saXN0GAogAygLMhwuY3JlYXRpdmFu'
    'dGEuY29udGVudC52MS5TaG90UghzaG90TGlzdBI5CgpjcmVhdGVkX2F0GAsgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use ctaBlockDescriptor instead')
const CtaBlock$json = {
  '1': 'CtaBlock',
  '2': [
    {'1': 'cta_id', '3': 1, '4': 1, '5': 9, '10': 'ctaId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'button_text', '3': 3, '4': 1, '5': 9, '10': 'buttonText'},
    {'1': 'destination_url', '3': 4, '4': 1, '5': 9, '10': 'destinationUrl'},
    {'1': 'cta_type', '3': 5, '4': 1, '5': 9, '10': 'ctaType'},
  ],
};

/// Descriptor for `CtaBlock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ctaBlockDescriptor = $convert.base64Decode(
    'CghDdGFCbG9jaxIVCgZjdGFfaWQYASABKAlSBWN0YUlkEhIKBHRleHQYAiABKAlSBHRleHQSHw'
    'oLYnV0dG9uX3RleHQYAyABKAlSCmJ1dHRvblRleHQSJwoPZGVzdGluYXRpb25fdXJsGAQgASgJ'
    'Ug5kZXN0aW5hdGlvblVybBIZCghjdGFfdHlwZRgFIAEoCVIHY3RhVHlwZQ==');

@$core.Deprecated('Use disclosureBlockDescriptor instead')
const DisclosureBlock$json = {
  '1': 'DisclosureBlock',
  '2': [
    {'1': 'disclosure_id', '3': 1, '4': 1, '5': 9, '10': 'disclosureId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'is_dismissed', '3': 4, '4': 1, '5': 8, '10': 'isDismissed'},
    {'1': 'dismissed_by', '3': 5, '4': 1, '5': 9, '10': 'dismissedBy'},
    {
      '1': 'dismissed_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dismissedAt'
    },
    {'1': 'dismissal_reason', '3': 7, '4': 1, '5': 9, '10': 'dismissalReason'},
  ],
};

/// Descriptor for `DisclosureBlock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disclosureBlockDescriptor = $convert.base64Decode(
    'Cg9EaXNjbG9zdXJlQmxvY2sSIwoNZGlzY2xvc3VyZV9pZBgBIAEoCVIMZGlzY2xvc3VyZUlkEh'
    'IKBHRleHQYAiABKAlSBHRleHQSGgoIcGxhdGZvcm0YAyABKAlSCHBsYXRmb3JtEiEKDGlzX2Rp'
    'c21pc3NlZBgEIAEoCFILaXNEaXNtaXNzZWQSIQoMZGlzbWlzc2VkX2J5GAUgASgJUgtkaXNtaX'
    'NzZWRCeRI9CgxkaXNtaXNzZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1w'
    'UgtkaXNtaXNzZWRBdBIpChBkaXNtaXNzYWxfcmVhc29uGAcgASgJUg9kaXNtaXNzYWxSZWFzb2'
    '4=');

@$core.Deprecated('Use publishTargetProfileDescriptor instead')
const PublishTargetProfile$json = {
  '1': 'PublishTargetProfile',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
    {'1': 'account_id', '3': 3, '4': 1, '5': 9, '10': 'accountId'},
  ],
};

/// Descriptor for `PublishTargetProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishTargetProfileDescriptor = $convert.base64Decode(
    'ChRQdWJsaXNoVGFyZ2V0UHJvZmlsZRIaCghwbGF0Zm9ybRgBIAEoCVIIcGxhdGZvcm0SFgoGZm'
    '9ybWF0GAIgASgJUgZmb3JtYXQSHQoKYWNjb3VudF9pZBgDIAEoCVIJYWNjb3VudElk');

@$core.Deprecated('Use assetBriefDescriptor instead')
const AssetBrief$json = {
  '1': 'AssetBrief',
  '2': [
    {'1': 'asset_brief_id', '3': 1, '4': 1, '5': 9, '10': 'assetBriefId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 3, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'output_type', '3': 4, '4': 1, '5': 9, '10': 'outputType'},
    {'1': 'target_format', '3': 5, '4': 1, '5': 9, '10': 'targetFormat'},
    {
      '1': 'target_duration_seconds',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'targetDurationSeconds'
    },
    {'1': 'target_platforms', '3': 7, '4': 3, '5': 9, '10': 'targetPlatforms'},
    {
      '1': 'continuity_requirements_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'continuityRequirementsJson'
    },
    {
      '1': 'brand_voice_requirements_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'brandVoiceRequirementsJson'
    },
    {
      '1': 'production_instructions',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'productionInstructions'
    },
    {
      '1': 'status',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.AssetBriefStatus',
      '10': 'status'
    },
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `AssetBrief`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetBriefDescriptor = $convert.base64Decode(
    'CgpBc3NldEJyaWVmEiQKDmFzc2V0X2JyaWVmX2lkGAEgASgJUgxhc3NldEJyaWVmSWQSIQoMd2'
    '9ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIbCglzY3JpcHRfaWQYAyABKAlSCHNjcmlw'
    'dElkEh8KC291dHB1dF90eXBlGAQgASgJUgpvdXRwdXRUeXBlEiMKDXRhcmdldF9mb3JtYXQYBS'
    'ABKAlSDHRhcmdldEZvcm1hdBI2Chd0YXJnZXRfZHVyYXRpb25fc2Vjb25kcxgGIAEoBVIVdGFy'
    'Z2V0RHVyYXRpb25TZWNvbmRzEikKEHRhcmdldF9wbGF0Zm9ybXMYByADKAlSD3RhcmdldFBsYX'
    'Rmb3JtcxJAChxjb250aW51aXR5X3JlcXVpcmVtZW50c19qc29uGAggASgJUhpjb250aW51aXR5'
    'UmVxdWlyZW1lbnRzSnNvbhJBCh1icmFuZF92b2ljZV9yZXF1aXJlbWVudHNfanNvbhgJIAEoCV'
    'IaYnJhbmRWb2ljZVJlcXVpcmVtZW50c0pzb24SNwoXcHJvZHVjdGlvbl9pbnN0cnVjdGlvbnMY'
    'CiABKAlSFnByb2R1Y3Rpb25JbnN0cnVjdGlvbnMSQAoGc3RhdHVzGAsgASgOMiguY3JlYXRpdm'
    'FudGEuY29udGVudC52MS5Bc3NldEJyaWVmU3RhdHVzUgZzdGF0dXMSOQoKY3JlYXRlZF9hdBgM'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2'
    'F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use scriptVersionDescriptor instead')
const ScriptVersion$json = {
  '1': 'ScriptVersion',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 3, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'version_index', '3': 4, '4': 1, '5': 5, '10': 'versionIndex'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'scenes',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Scene',
      '10': 'scenes'
    },
    {
      '1': 'cta_blocks',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.CtaBlock',
      '10': 'ctaBlocks'
    },
    {
      '1': 'disclosure_blocks',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.DisclosureBlock',
      '10': 'disclosureBlocks'
    },
    {
      '1': 'duration_target_seconds',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'durationTargetSeconds'
    },
    {
      '1': 'lifecycle_state',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.ScriptLifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'approval_state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.ScriptApprovalState',
      '10': 'approvalState'
    },
    {'1': 'snapshot_reason', '3': 12, '4': 1, '5': 9, '10': 'snapshotReason'},
    {'1': 'created_by', '3': 13, '4': 1, '5': 9, '10': 'createdBy'},
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

/// Descriptor for `ScriptVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptVersionDescriptor = $convert.base64Decode(
    'Cg1TY3JpcHRWZXJzaW9uEh0KCnZlcnNpb25faWQYASABKAlSCXZlcnNpb25JZBIhCgx3b3Jrc3'
    'BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhsKCXNjcmlwdF9pZBgDIAEoCVIIc2NyaXB0SWQS'
    'IwoNdmVyc2lvbl9pbmRleBgEIAEoBVIMdmVyc2lvbkluZGV4EhQKBXRpdGxlGAUgASgJUgV0aX'
    'RsZRI1CgZzY2VuZXMYBiADKAsyHS5jcmVhdGl2YW50YS5jb250ZW50LnYxLlNjZW5lUgZzY2Vu'
    'ZXMSPwoKY3RhX2Jsb2NrcxgHIAMoCzIgLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuQ3RhQmxvY2'
    'tSCWN0YUJsb2NrcxJUChFkaXNjbG9zdXJlX2Jsb2NrcxgIIAMoCzInLmNyZWF0aXZhbnRhLmNv'
    'bnRlbnQudjEuRGlzY2xvc3VyZUJsb2NrUhBkaXNjbG9zdXJlQmxvY2tzEjYKF2R1cmF0aW9uX3'
    'RhcmdldF9zZWNvbmRzGAkgASgFUhVkdXJhdGlvblRhcmdldFNlY29uZHMSVQoPbGlmZWN5Y2xl'
    'X3N0YXRlGAogASgOMiwuY3JlYXRpdmFudGEuY29udGVudC52MS5TY3JpcHRMaWZlY3ljbGVTdG'
    'F0ZVIObGlmZWN5Y2xlU3RhdGUSUgoOYXBwcm92YWxfc3RhdGUYCyABKA4yKy5jcmVhdGl2YW50'
    'YS5jb250ZW50LnYxLlNjcmlwdEFwcHJvdmFsU3RhdGVSDWFwcHJvdmFsU3RhdGUSJwoPc25hcH'
    'Nob3RfcmVhc29uGAwgASgJUg5zbmFwc2hvdFJlYXNvbhIdCgpjcmVhdGVkX2J5GA0gASgJUglj'
    'cmVhdGVkQnkSOQoKY3JlYXRlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use scriptReviewCommentDescriptor instead')
const ScriptReviewComment$json = {
  '1': 'ScriptReviewComment',
  '2': [
    {'1': 'comment_id', '3': 1, '4': 1, '5': 9, '10': 'commentId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'author_name', '3': 4, '4': 1, '5': 9, '10': 'authorName'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {'1': 'scene_index', '3': 6, '4': 1, '5': 5, '10': 'sceneIndex'},
    {'1': 'is_resolved', '3': 7, '4': 1, '5': 8, '10': 'isResolved'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `ScriptReviewComment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptReviewCommentDescriptor = $convert.base64Decode(
    'ChNTY3JpcHRSZXZpZXdDb21tZW50Eh0KCmNvbW1lbnRfaWQYASABKAlSCWNvbW1lbnRJZBIbCg'
    'lzY3JpcHRfaWQYAiABKAlSCHNjcmlwdElkEhcKB3VzZXJfaWQYAyABKAlSBnVzZXJJZBIfCgth'
    'dXRob3JfbmFtZRgEIAEoCVIKYXV0aG9yTmFtZRIYCgdjb250ZW50GAUgASgJUgdjb250ZW50Eh'
    '8KC3NjZW5lX2luZGV4GAYgASgFUgpzY2VuZUluZGV4Eh8KC2lzX3Jlc29sdmVkGAcgASgIUgpp'
    'c1Jlc29sdmVkEjkKCmNyZWF0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use scriptDescriptor instead')
const Script$json = {
  '1': 'Script',
  '2': [
    {'1': 'script_id', '3': 1, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_id', '3': 3, '4': 1, '5': 9, '10': 'ideaId'},
    {'1': 'source_idea_title', '3': 4, '4': 1, '5': 9, '10': 'sourceIdeaTitle'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'format_type', '3': 6, '4': 1, '5': 9, '10': 'formatType'},
    {
      '1': 'scenes',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Scene',
      '10': 'scenes'
    },
    {
      '1': 'cta_blocks',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.CtaBlock',
      '10': 'ctaBlocks'
    },
    {
      '1': 'disclosure_blocks',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.DisclosureBlock',
      '10': 'disclosureBlocks'
    },
    {
      '1': 'duration_target_seconds',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'durationTargetSeconds'
    },
    {
      '1': 'lifecycle_state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.ScriptLifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'approval_state',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.ScriptApprovalState',
      '10': 'approvalState'
    },
    {
      '1': 'publish_target_profiles',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.PublishTargetProfile',
      '10': 'publishTargetProfiles'
    },
    {'1': 'continuity_refs', '3': 14, '4': 3, '5': 9, '10': 'continuityRefs'},
    {
      '1': 'offer_product_hooks',
      '3': 15,
      '4': 3,
      '5': 9,
      '10': 'offerProductHooks'
    },
    {'1': 'rejection_reason', '3': 16, '4': 1, '5': 9, '10': 'rejectionReason'},
    {'1': 'version_index', '3': 17, '4': 1, '5': 5, '10': 'versionIndex'},
    {'1': 'created_by', '3': 18, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'approved_by', '3': 19, '4': 1, '5': 9, '10': 'approvedBy'},
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

/// Descriptor for `Script`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptDescriptor = $convert.base64Decode(
    'CgZTY3JpcHQSGwoJc2NyaXB0X2lkGAEgASgJUghzY3JpcHRJZBIhCgx3b3Jrc3BhY2VfaWQYAi'
    'ABKAlSC3dvcmtzcGFjZUlkEhcKB2lkZWFfaWQYAyABKAlSBmlkZWFJZBIqChFzb3VyY2VfaWRl'
    'YV90aXRsZRgEIAEoCVIPc291cmNlSWRlYVRpdGxlEhQKBXRpdGxlGAUgASgJUgV0aXRsZRIfCg'
    'tmb3JtYXRfdHlwZRgGIAEoCVIKZm9ybWF0VHlwZRI1CgZzY2VuZXMYByADKAsyHS5jcmVhdGl2'
    'YW50YS5jb250ZW50LnYxLlNjZW5lUgZzY2VuZXMSPwoKY3RhX2Jsb2NrcxgIIAMoCzIgLmNyZW'
    'F0aXZhbnRhLmNvbnRlbnQudjEuQ3RhQmxvY2tSCWN0YUJsb2NrcxJUChFkaXNjbG9zdXJlX2Js'
    'b2NrcxgJIAMoCzInLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuRGlzY2xvc3VyZUJsb2NrUhBkaX'
    'NjbG9zdXJlQmxvY2tzEjYKF2R1cmF0aW9uX3RhcmdldF9zZWNvbmRzGAogASgFUhVkdXJhdGlv'
    'blRhcmdldFNlY29uZHMSVQoPbGlmZWN5Y2xlX3N0YXRlGAsgASgOMiwuY3JlYXRpdmFudGEuY2'
    '9udGVudC52MS5TY3JpcHRMaWZlY3ljbGVTdGF0ZVIObGlmZWN5Y2xlU3RhdGUSUgoOYXBwcm92'
    'YWxfc3RhdGUYDCABKA4yKy5jcmVhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdEFwcHJvdmFsU3'
    'RhdGVSDWFwcHJvdmFsU3RhdGUSZAoXcHVibGlzaF90YXJnZXRfcHJvZmlsZXMYDSADKAsyLC5j'
    'cmVhdGl2YW50YS5jb250ZW50LnYxLlB1Ymxpc2hUYXJnZXRQcm9maWxlUhVwdWJsaXNoVGFyZ2'
    'V0UHJvZmlsZXMSJwoPY29udGludWl0eV9yZWZzGA4gAygJUg5jb250aW51aXR5UmVmcxIuChNv'
    'ZmZlcl9wcm9kdWN0X2hvb2tzGA8gAygJUhFvZmZlclByb2R1Y3RIb29rcxIpChByZWplY3Rpb2'
    '5fcmVhc29uGBAgASgJUg9yZWplY3Rpb25SZWFzb24SIwoNdmVyc2lvbl9pbmRleBgRIAEoBVIM'
    'dmVyc2lvbkluZGV4Eh0KCmNyZWF0ZWRfYnkYEiABKAlSCWNyZWF0ZWRCeRIfCgthcHByb3ZlZF'
    '9ieRgTIAEoCVIKYXBwcm92ZWRCeRI5CgpjcmVhdGVkX2F0GBQgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYFSABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use scriptServiceCreateRequestDescriptor instead')
const ScriptServiceCreateRequest$json = {
  '1': 'ScriptServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'idea_id', '3': 2, '4': 1, '5': 9, '10': 'ideaId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'format_type', '3': 4, '4': 1, '5': 9, '10': 'formatType'},
    {
      '1': 'scenes',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Scene',
      '10': 'scenes'
    },
    {
      '1': 'cta_blocks',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.CtaBlock',
      '10': 'ctaBlocks'
    },
    {
      '1': 'disclosure_blocks',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.DisclosureBlock',
      '10': 'disclosureBlocks'
    },
    {
      '1': 'duration_target_seconds',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'durationTargetSeconds'
    },
    {
      '1': 'publish_target_profiles',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.PublishTargetProfile',
      '10': 'publishTargetProfiles'
    },
    {'1': 'continuity_refs', '3': 10, '4': 3, '5': 9, '10': 'continuityRefs'},
    {
      '1': 'offer_product_hooks',
      '3': 11,
      '4': 3,
      '5': 9,
      '10': 'offerProductHooks'
    },
  ],
};

/// Descriptor for `ScriptServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChpTY3JpcHRTZXJ2aWNlQ3JlYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhcKB2lkZWFfaWQYAiABKAlSBmlkZWFJZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUS'
    'HwoLZm9ybWF0X3R5cGUYBCABKAlSCmZvcm1hdFR5cGUSNQoGc2NlbmVzGAUgAygLMh0uY3JlYX'
    'RpdmFudGEuY29udGVudC52MS5TY2VuZVIGc2NlbmVzEj8KCmN0YV9ibG9ja3MYBiADKAsyIC5j'
    'cmVhdGl2YW50YS5jb250ZW50LnYxLkN0YUJsb2NrUgljdGFCbG9ja3MSVAoRZGlzY2xvc3VyZV'
    '9ibG9ja3MYByADKAsyJy5jcmVhdGl2YW50YS5jb250ZW50LnYxLkRpc2Nsb3N1cmVCbG9ja1IQ'
    'ZGlzY2xvc3VyZUJsb2NrcxI2ChdkdXJhdGlvbl90YXJnZXRfc2Vjb25kcxgIIAEoBVIVZHVyYX'
    'Rpb25UYXJnZXRTZWNvbmRzEmQKF3B1Ymxpc2hfdGFyZ2V0X3Byb2ZpbGVzGAkgAygLMiwuY3Jl'
    'YXRpdmFudGEuY29udGVudC52MS5QdWJsaXNoVGFyZ2V0UHJvZmlsZVIVcHVibGlzaFRhcmdldF'
    'Byb2ZpbGVzEicKD2NvbnRpbnVpdHlfcmVmcxgKIAMoCVIOY29udGludWl0eVJlZnMSLgoTb2Zm'
    'ZXJfcHJvZHVjdF9ob29rcxgLIAMoCVIRb2ZmZXJQcm9kdWN0SG9va3M=');

@$core.Deprecated('Use scriptServiceCreateResponseDescriptor instead')
const ScriptServiceCreateResponse$json = {
  '1': 'ScriptServiceCreateResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
    {
      '1': 'disclosure_recommended',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'disclosureRecommended'
    },
    {
      '1': 'disclosure_suggestion_text',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'disclosureSuggestionText'
    },
  ],
};

/// Descriptor for `ScriptServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceCreateResponseDescriptor = $convert.base64Decode(
    'ChtTY3JpcHRTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USNgoGc2NyaXB0GAEgASgLMh4uY3JlYXRpdm'
    'FudGEuY29udGVudC52MS5TY3JpcHRSBnNjcmlwdBI1ChZkaXNjbG9zdXJlX3JlY29tbWVuZGVk'
    'GAIgASgIUhVkaXNjbG9zdXJlUmVjb21tZW5kZWQSPAoaZGlzY2xvc3VyZV9zdWdnZXN0aW9uX3'
    'RleHQYAyABKAlSGGRpc2Nsb3N1cmVTdWdnZXN0aW9uVGV4dA==');

@$core.Deprecated('Use scriptServiceGetRequestDescriptor instead')
const ScriptServiceGetRequest$json = {
  '1': 'ScriptServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
  ],
};

/// Descriptor for `ScriptServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChdTY3JpcHRTZXJ2aWNlR2V0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQ=');

@$core.Deprecated('Use scriptServiceGetResponseDescriptor instead')
const ScriptServiceGetResponse$json = {
  '1': 'ScriptServiceGetResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
    {
      '1': 'asset_brief',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.AssetBrief',
      '10': 'assetBrief'
    },
  ],
};

/// Descriptor for `ScriptServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetResponseDescriptor = $convert.base64Decode(
    'ChhTY3JpcHRTZXJ2aWNlR2V0UmVzcG9uc2USNgoGc2NyaXB0GAEgASgLMh4uY3JlYXRpdmFudG'
    'EuY29udGVudC52MS5TY3JpcHRSBnNjcmlwdBJDCgthc3NldF9icmllZhgCIAEoCzIiLmNyZWF0'
    'aXZhbnRhLmNvbnRlbnQudjEuQXNzZXRCcmllZlIKYXNzZXRCcmllZg==');

@$core.Deprecated('Use scriptServiceUpdateRequestDescriptor instead')
const ScriptServiceUpdateRequest$json = {
  '1': 'ScriptServiceUpdateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'format_type', '3': 4, '4': 1, '5': 9, '10': 'formatType'},
    {
      '1': 'scenes',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Scene',
      '10': 'scenes'
    },
    {
      '1': 'cta_blocks',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.CtaBlock',
      '10': 'ctaBlocks'
    },
    {
      '1': 'disclosure_blocks',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.DisclosureBlock',
      '10': 'disclosureBlocks'
    },
    {
      '1': 'duration_target_seconds',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'durationTargetSeconds'
    },
    {
      '1': 'publish_target_profiles',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.PublishTargetProfile',
      '10': 'publishTargetProfiles'
    },
    {'1': 'continuity_refs', '3': 10, '4': 3, '5': 9, '10': 'continuityRefs'},
    {
      '1': 'offer_product_hooks',
      '3': 11,
      '4': 3,
      '5': 9,
      '10': 'offerProductHooks'
    },
    {'1': 'expected_version', '3': 12, '4': 1, '5': 5, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `ScriptServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChpTY3JpcHRTZXJ2aWNlVXBkYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQSFAoFdGl0bGUYAyABKAlSBXRp'
    'dGxlEh8KC2Zvcm1hdF90eXBlGAQgASgJUgpmb3JtYXRUeXBlEjUKBnNjZW5lcxgFIAMoCzIdLm'
    'NyZWF0aXZhbnRhLmNvbnRlbnQudjEuU2NlbmVSBnNjZW5lcxI/CgpjdGFfYmxvY2tzGAYgAygL'
    'MiAuY3JlYXRpdmFudGEuY29udGVudC52MS5DdGFCbG9ja1IJY3RhQmxvY2tzElQKEWRpc2Nsb3'
    'N1cmVfYmxvY2tzGAcgAygLMicuY3JlYXRpdmFudGEuY29udGVudC52MS5EaXNjbG9zdXJlQmxv'
    'Y2tSEGRpc2Nsb3N1cmVCbG9ja3MSNgoXZHVyYXRpb25fdGFyZ2V0X3NlY29uZHMYCCABKAVSFW'
    'R1cmF0aW9uVGFyZ2V0U2Vjb25kcxJkChdwdWJsaXNoX3RhcmdldF9wcm9maWxlcxgJIAMoCzIs'
    'LmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuUHVibGlzaFRhcmdldFByb2ZpbGVSFXB1Ymxpc2hUYX'
    'JnZXRQcm9maWxlcxInCg9jb250aW51aXR5X3JlZnMYCiADKAlSDmNvbnRpbnVpdHlSZWZzEi4K'
    'E29mZmVyX3Byb2R1Y3RfaG9va3MYCyADKAlSEW9mZmVyUHJvZHVjdEhvb2tzEikKEGV4cGVjdG'
    'VkX3ZlcnNpb24YDCABKAVSD2V4cGVjdGVkVmVyc2lvbg==');

@$core.Deprecated('Use scriptServiceUpdateResponseDescriptor instead')
const ScriptServiceUpdateResponse$json = {
  '1': 'ScriptServiceUpdateResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
  ],
};

/// Descriptor for `ScriptServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'ChtTY3JpcHRTZXJ2aWNlVXBkYXRlUmVzcG9uc2USNgoGc2NyaXB0GAEgASgLMh4uY3JlYXRpdm'
        'FudGEuY29udGVudC52MS5TY3JpcHRSBnNjcmlwdA==');

@$core.Deprecated('Use scriptServiceSubmitApprovalRequestDescriptor instead')
const ScriptServiceSubmitApprovalRequest$json = {
  '1': 'ScriptServiceSubmitApprovalRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 5, '10': 'expectedVersion'},
    {'1': 'reviewer_id', '3': 4, '4': 1, '5': 9, '10': 'reviewerId'},
  ],
};

/// Descriptor for `ScriptServiceSubmitApprovalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceSubmitApprovalRequestDescriptor =
    $convert.base64Decode(
        'CiJTY3JpcHRTZXJ2aWNlU3VibWl0QXBwcm92YWxSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSGwoJc2NyaXB0X2lkGAIgASgJUghzY3JpcHRJZBIpChBleHBlY3Rl'
        'ZF92ZXJzaW9uGAMgASgFUg9leHBlY3RlZFZlcnNpb24SHwoLcmV2aWV3ZXJfaWQYBCABKAlSCn'
        'Jldmlld2VySWQ=');

@$core.Deprecated('Use scriptServiceSubmitApprovalResponseDescriptor instead')
const ScriptServiceSubmitApprovalResponse$json = {
  '1': 'ScriptServiceSubmitApprovalResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
    {
      '1': 'approval_request_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'approvalRequestId'
    },
  ],
};

/// Descriptor for `ScriptServiceSubmitApprovalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceSubmitApprovalResponseDescriptor =
    $convert.base64Decode(
        'CiNTY3JpcHRTZXJ2aWNlU3VibWl0QXBwcm92YWxSZXNwb25zZRI2CgZzY3JpcHQYASABKAsyHi'
        '5jcmVhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdFIGc2NyaXB0Ei4KE2FwcHJvdmFsX3JlcXVl'
        'c3RfaWQYAiABKAlSEWFwcHJvdmFsUmVxdWVzdElk');

@$core.Deprecated('Use scriptServiceApproveRequestDescriptor instead')
const ScriptServiceApproveRequest$json = {
  '1': 'ScriptServiceApproveRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 5, '10': 'expectedVersion'},
    {
      '1': 'reviewer_snapshot_time',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewerSnapshotTime'
    },
  ],
};

/// Descriptor for `ScriptServiceApproveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceApproveRequestDescriptor = $convert.base64Decode(
    'ChtTY3JpcHRTZXJ2aWNlQXBwcm92ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
    'Jrc3BhY2VJZBIbCglzY3JpcHRfaWQYAiABKAlSCHNjcmlwdElkEikKEGV4cGVjdGVkX3ZlcnNp'
    'b24YAyABKAVSD2V4cGVjdGVkVmVyc2lvbhJQChZyZXZpZXdlcl9zbmFwc2hvdF90aW1lGAQgAS'
    'gLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIUcmV2aWV3ZXJTbmFwc2hvdFRpbWU=');

@$core.Deprecated('Use scriptServiceApproveResponseDescriptor instead')
const ScriptServiceApproveResponse$json = {
  '1': 'ScriptServiceApproveResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
    {
      '1': 'approved_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
  ],
};

/// Descriptor for `ScriptServiceApproveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceApproveResponseDescriptor =
    $convert.base64Decode(
        'ChxTY3JpcHRTZXJ2aWNlQXBwcm92ZVJlc3BvbnNlEjYKBnNjcmlwdBgBIAEoCzIeLmNyZWF0aX'
        'ZhbnRhLmNvbnRlbnQudjEuU2NyaXB0UgZzY3JpcHQSOwoLYXBwcm92ZWRfYXQYAiABKAsyGi5n'
        'b29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphcHByb3ZlZEF0');

@$core.Deprecated('Use scriptServiceRejectRequestDescriptor instead')
const ScriptServiceRejectRequest$json = {
  '1': 'ScriptServiceRejectRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'rejection_reason', '3': 3, '4': 1, '5': 9, '10': 'rejectionReason'},
    {'1': 'expected_version', '3': 4, '4': 1, '5': 5, '10': 'expectedVersion'},
    {
      '1': 'reviewer_snapshot_time',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewerSnapshotTime'
    },
  ],
};

/// Descriptor for `ScriptServiceRejectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceRejectRequestDescriptor = $convert.base64Decode(
    'ChpTY3JpcHRTZXJ2aWNlUmVqZWN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQSKQoQcmVqZWN0aW9uX3JlYXNv'
    'bhgDIAEoCVIPcmVqZWN0aW9uUmVhc29uEikKEGV4cGVjdGVkX3ZlcnNpb24YBCABKAVSD2V4cG'
    'VjdGVkVmVyc2lvbhJQChZyZXZpZXdlcl9zbmFwc2hvdF90aW1lGAUgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIUcmV2aWV3ZXJTbmFwc2hvdFRpbWU=');

@$core.Deprecated('Use scriptServiceRejectResponseDescriptor instead')
const ScriptServiceRejectResponse$json = {
  '1': 'ScriptServiceRejectResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
  ],
};

/// Descriptor for `ScriptServiceRejectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceRejectResponseDescriptor =
    $convert.base64Decode(
        'ChtTY3JpcHRTZXJ2aWNlUmVqZWN0UmVzcG9uc2USNgoGc2NyaXB0GAEgASgLMh4uY3JlYXRpdm'
        'FudGEuY29udGVudC52MS5TY3JpcHRSBnNjcmlwdA==');

@$core.Deprecated('Use scriptServiceListRequestDescriptor instead')
const ScriptServiceListRequest$json = {
  '1': 'ScriptServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'lifecycle_state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.ScriptLifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'approval_state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.ScriptApprovalState',
      '10': 'approvalState'
    },
    {'1': 'idea_id', '3': 4, '4': 1, '5': 9, '10': 'ideaId'},
    {'1': 'limit', '3': 5, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'page_token', '3': 6, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ScriptServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceListRequestDescriptor = $convert.base64Decode(
    'ChhTY3JpcHRTZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBJVCg9saWZlY3ljbGVfc3RhdGUYAiABKA4yLC5jcmVhdGl2YW50YS5jb250ZW50LnYx'
    'LlNjcmlwdExpZmVjeWNsZVN0YXRlUg5saWZlY3ljbGVTdGF0ZRJSCg5hcHByb3ZhbF9zdGF0ZR'
    'gDIAEoDjIrLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuU2NyaXB0QXBwcm92YWxTdGF0ZVINYXBw'
    'cm92YWxTdGF0ZRIXCgdpZGVhX2lkGAQgASgJUgZpZGVhSWQSFAoFbGltaXQYBSABKAVSBWxpbW'
    'l0Eh0KCnBhZ2VfdG9rZW4YBiABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use scriptServiceListResponseDescriptor instead')
const ScriptServiceListResponse$json = {
  '1': 'ScriptServiceListResponse',
  '2': [
    {
      '1': 'scripts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'scripts'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ScriptServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceListResponseDescriptor = $convert.base64Decode(
    'ChlTY3JpcHRTZXJ2aWNlTGlzdFJlc3BvbnNlEjgKB3NjcmlwdHMYASADKAsyHi5jcmVhdGl2YW'
    '50YS5jb250ZW50LnYxLlNjcmlwdFIHc2NyaXB0cxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlS'
    'DW5leHRQYWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKAVSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use scriptServiceDeleteRequestDescriptor instead')
const ScriptServiceDeleteRequest$json = {
  '1': 'ScriptServiceDeleteRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
  ],
};

/// Descriptor for `ScriptServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceDeleteRequestDescriptor =
    $convert.base64Decode(
        'ChpTY3JpcHRTZXJ2aWNlRGVsZXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQ=');

@$core.Deprecated('Use scriptServiceDeleteResponseDescriptor instead')
const ScriptServiceDeleteResponse$json = {
  '1': 'ScriptServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ScriptServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'ChtTY3JpcHRTZXJ2aWNlRGVsZXRlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw'
        '==');

@$core.Deprecated('Use scriptServiceDuplicateRequestDescriptor instead')
const ScriptServiceDuplicateRequest$json = {
  '1': 'ScriptServiceDuplicateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'target_platform', '3': 3, '4': 1, '5': 9, '10': 'targetPlatform'},
    {'1': 'new_format_type', '3': 4, '4': 1, '5': 9, '10': 'newFormatType'},
    {
      '1': 'adjusted_duration_seconds',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'adjustedDurationSeconds'
    },
    {'1': 'new_title', '3': 6, '4': 1, '5': 9, '10': 'newTitle'},
  ],
};

/// Descriptor for `ScriptServiceDuplicateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceDuplicateRequestDescriptor = $convert.base64Decode(
    'Ch1TY3JpcHRTZXJ2aWNlRHVwbGljYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQSJwoPdGFyZ2V0X3BsYXRm'
    'b3JtGAMgASgJUg50YXJnZXRQbGF0Zm9ybRImCg9uZXdfZm9ybWF0X3R5cGUYBCABKAlSDW5ld0'
    'Zvcm1hdFR5cGUSOgoZYWRqdXN0ZWRfZHVyYXRpb25fc2Vjb25kcxgFIAEoBVIXYWRqdXN0ZWRE'
    'dXJhdGlvblNlY29uZHMSGwoJbmV3X3RpdGxlGAYgASgJUghuZXdUaXRsZQ==');

@$core.Deprecated('Use scriptServiceDuplicateResponseDescriptor instead')
const ScriptServiceDuplicateResponse$json = {
  '1': 'ScriptServiceDuplicateResponse',
  '2': [
    {
      '1': 'duplicated_script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'duplicatedScript'
    },
  ],
};

/// Descriptor for `ScriptServiceDuplicateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceDuplicateResponseDescriptor =
    $convert.base64Decode(
        'Ch5TY3JpcHRTZXJ2aWNlRHVwbGljYXRlUmVzcG9uc2USSwoRZHVwbGljYXRlZF9zY3JpcHQYAS'
        'ABKAsyHi5jcmVhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdFIQZHVwbGljYXRlZFNjcmlwdA==');

@$core.Deprecated('Use scriptServiceGetStatsRequestDescriptor instead')
const ScriptServiceGetStatsRequest$json = {
  '1': 'ScriptServiceGetStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `ScriptServiceGetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetStatsRequestDescriptor =
    $convert.base64Decode(
        'ChxTY3JpcHRTZXJ2aWNlR2V0U3RhdHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQ=');

@$core.Deprecated('Use scriptServiceGetStatsResponseDescriptor instead')
const ScriptServiceGetStatsResponse$json = {
  '1': 'ScriptServiceGetStatsResponse',
  '2': [
    {'1': 'total_scripts', '3': 1, '4': 1, '5': 5, '10': 'totalScripts'},
    {'1': 'draft_count', '3': 2, '4': 1, '5': 5, '10': 'draftCount'},
    {
      '1': 'pending_approval_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'pendingApprovalCount'
    },
    {'1': 'approved_count', '3': 4, '4': 1, '5': 5, '10': 'approvedCount'},
    {
      '1': 'ready_for_production_count',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'readyForProductionCount'
    },
    {'1': 'archived_count', '3': 6, '4': 1, '5': 5, '10': 'archivedCount'},
  ],
};

/// Descriptor for `ScriptServiceGetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetStatsResponseDescriptor = $convert.base64Decode(
    'Ch1TY3JpcHRTZXJ2aWNlR2V0U3RhdHNSZXNwb25zZRIjCg10b3RhbF9zY3JpcHRzGAEgASgFUg'
    'x0b3RhbFNjcmlwdHMSHwoLZHJhZnRfY291bnQYAiABKAVSCmRyYWZ0Q291bnQSNAoWcGVuZGlu'
    'Z19hcHByb3ZhbF9jb3VudBgDIAEoBVIUcGVuZGluZ0FwcHJvdmFsQ291bnQSJQoOYXBwcm92ZW'
    'RfY291bnQYBCABKAVSDWFwcHJvdmVkQ291bnQSOwoacmVhZHlfZm9yX3Byb2R1Y3Rpb25fY291'
    'bnQYBSABKAVSF3JlYWR5Rm9yUHJvZHVjdGlvbkNvdW50EiUKDmFyY2hpdmVkX2NvdW50GAYgAS'
    'gFUg1hcmNoaXZlZENvdW50');

@$core.Deprecated('Use scriptServiceGetBriefRequestDescriptor instead')
const ScriptServiceGetBriefRequest$json = {
  '1': 'ScriptServiceGetBriefRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'create_if_missing', '3': 3, '4': 1, '5': 8, '10': 'createIfMissing'},
    {'1': 'output_type', '3': 4, '4': 1, '5': 9, '10': 'outputType'},
    {'1': 'target_format', '3': 5, '4': 1, '5': 9, '10': 'targetFormat'},
    {
      '1': 'target_duration_seconds',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'targetDurationSeconds'
    },
    {
      '1': 'continuity_requirements_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'continuityRequirementsJson'
    },
    {
      '1': 'brand_voice_requirements_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'brandVoiceRequirementsJson'
    },
    {
      '1': 'production_instructions',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'productionInstructions'
    },
  ],
};

/// Descriptor for `ScriptServiceGetBriefRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetBriefRequestDescriptor = $convert.base64Decode(
    'ChxTY3JpcHRTZXJ2aWNlR2V0QnJpZWZSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSGwoJc2NyaXB0X2lkGAIgASgJUghzY3JpcHRJZBIqChFjcmVhdGVfaWZfbWlz'
    'c2luZxgDIAEoCFIPY3JlYXRlSWZNaXNzaW5nEh8KC291dHB1dF90eXBlGAQgASgJUgpvdXRwdX'
    'RUeXBlEiMKDXRhcmdldF9mb3JtYXQYBSABKAlSDHRhcmdldEZvcm1hdBI2Chd0YXJnZXRfZHVy'
    'YXRpb25fc2Vjb25kcxgGIAEoBVIVdGFyZ2V0RHVyYXRpb25TZWNvbmRzEkAKHGNvbnRpbnVpdH'
    'lfcmVxdWlyZW1lbnRzX2pzb24YByABKAlSGmNvbnRpbnVpdHlSZXF1aXJlbWVudHNKc29uEkEK'
    'HWJyYW5kX3ZvaWNlX3JlcXVpcmVtZW50c19qc29uGAggASgJUhpicmFuZFZvaWNlUmVxdWlyZW'
    '1lbnRzSnNvbhI3Chdwcm9kdWN0aW9uX2luc3RydWN0aW9ucxgJIAEoCVIWcHJvZHVjdGlvbklu'
    'c3RydWN0aW9ucw==');

@$core.Deprecated('Use scriptServiceGetBriefResponseDescriptor instead')
const ScriptServiceGetBriefResponse$json = {
  '1': 'ScriptServiceGetBriefResponse',
  '2': [
    {
      '1': 'asset_brief',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.AssetBrief',
      '10': 'assetBrief'
    },
    {
      '1': 'ready_for_production',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'readyForProduction'
    },
  ],
};

/// Descriptor for `ScriptServiceGetBriefResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetBriefResponseDescriptor =
    $convert.base64Decode(
        'Ch1TY3JpcHRTZXJ2aWNlR2V0QnJpZWZSZXNwb25zZRJDCgthc3NldF9icmllZhgBIAEoCzIiLm'
        'NyZWF0aXZhbnRhLmNvbnRlbnQudjEuQXNzZXRCcmllZlIKYXNzZXRCcmllZhIwChRyZWFkeV9m'
        'b3JfcHJvZHVjdGlvbhgCIAEoCFIScmVhZHlGb3JQcm9kdWN0aW9u');

@$core.Deprecated('Use scriptServiceGetReviewRequestDescriptor instead')
const ScriptServiceGetReviewRequest$json = {
  '1': 'ScriptServiceGetReviewRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
  ],
};

/// Descriptor for `ScriptServiceGetReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetReviewRequestDescriptor =
    $convert.base64Decode(
        'Ch1TY3JpcHRTZXJ2aWNlR2V0UmV2aWV3UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
        'dvcmtzcGFjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQ=');

@$core.Deprecated('Use scriptServiceGetReviewResponseDescriptor instead')
const ScriptServiceGetReviewResponse$json = {
  '1': 'ScriptServiceGetReviewResponse',
  '2': [
    {'1': 'script_id', '3': 1, '4': 1, '5': 9, '10': 'scriptId'},
    {
      '1': 'approval_state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.ScriptApprovalState',
      '10': 'approvalState'
    },
    {'1': 'rejection_reason', '3': 3, '4': 1, '5': 9, '10': 'rejectionReason'},
    {'1': 'approved_by', '3': 4, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'comments',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.ScriptReviewComment',
      '10': 'comments'
    },
  ],
};

/// Descriptor for `ScriptServiceGetReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetReviewResponseDescriptor = $convert.base64Decode(
    'Ch5TY3JpcHRTZXJ2aWNlR2V0UmV2aWV3UmVzcG9uc2USGwoJc2NyaXB0X2lkGAEgASgJUghzY3'
    'JpcHRJZBJSCg5hcHByb3ZhbF9zdGF0ZRgCIAEoDjIrLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEu'
    'U2NyaXB0QXBwcm92YWxTdGF0ZVINYXBwcm92YWxTdGF0ZRIpChByZWplY3Rpb25fcmVhc29uGA'
    'MgASgJUg9yZWplY3Rpb25SZWFzb24SHwoLYXBwcm92ZWRfYnkYBCABKAlSCmFwcHJvdmVkQnkS'
    'RwoIY29tbWVudHMYBSADKAsyKy5jcmVhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdFJldmlld0'
    'NvbW1lbnRSCGNvbW1lbnRz');

@$core.Deprecated('Use scriptServiceSubmitReviewRequestDescriptor instead')
const ScriptServiceSubmitReviewRequest$json = {
  '1': 'ScriptServiceSubmitReviewRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'review_notes', '3': 3, '4': 1, '5': 9, '10': 'reviewNotes'},
  ],
};

/// Descriptor for `ScriptServiceSubmitReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceSubmitReviewRequestDescriptor =
    $convert.base64Decode(
        'CiBTY3JpcHRTZXJ2aWNlU3VibWl0UmV2aWV3UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQSIQoMcmV2aWV3X25v'
        'dGVzGAMgASgJUgtyZXZpZXdOb3Rlcw==');

@$core.Deprecated('Use scriptServiceSubmitReviewResponseDescriptor instead')
const ScriptServiceSubmitReviewResponse$json = {
  '1': 'ScriptServiceSubmitReviewResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ScriptServiceSubmitReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceSubmitReviewResponseDescriptor =
    $convert.base64Decode(
        'CiFTY3JpcHRTZXJ2aWNlU3VibWl0UmV2aWV3UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3'
        'VjY2Vzcw==');

@$core.Deprecated('Use scriptServiceRequestChangesRequestDescriptor instead')
const ScriptServiceRequestChangesRequest$json = {
  '1': 'ScriptServiceRequestChangesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'feedback', '3': 3, '4': 1, '5': 9, '10': 'feedback'},
    {'1': 'expected_version', '3': 4, '4': 1, '5': 5, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `ScriptServiceRequestChangesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceRequestChangesRequestDescriptor =
    $convert.base64Decode(
        'CiJTY3JpcHRTZXJ2aWNlUmVxdWVzdENoYW5nZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSGwoJc2NyaXB0X2lkGAIgASgJUghzY3JpcHRJZBIaCghmZWVkYmFj'
        'axgDIAEoCVIIZmVlZGJhY2sSKQoQZXhwZWN0ZWRfdmVyc2lvbhgEIAEoBVIPZXhwZWN0ZWRWZX'
        'JzaW9u');

@$core.Deprecated('Use scriptServiceRequestChangesResponseDescriptor instead')
const ScriptServiceRequestChangesResponse$json = {
  '1': 'ScriptServiceRequestChangesResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
  ],
};

/// Descriptor for `ScriptServiceRequestChangesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceRequestChangesResponseDescriptor =
    $convert.base64Decode(
        'CiNTY3JpcHRTZXJ2aWNlUmVxdWVzdENoYW5nZXNSZXNwb25zZRI2CgZzY3JpcHQYASABKAsyHi'
        '5jcmVhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdFIGc2NyaXB0');

@$core.Deprecated('Use scriptServiceAddSectionRequestDescriptor instead')
const ScriptServiceAddSectionRequest$json = {
  '1': 'ScriptServiceAddSectionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {
      '1': 'scene',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Scene',
      '10': 'scene'
    },
  ],
};

/// Descriptor for `ScriptServiceAddSectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceAddSectionRequestDescriptor =
    $convert.base64Decode(
        'Ch5TY3JpcHRTZXJ2aWNlQWRkU2VjdGlvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIbCglzY3JpcHRfaWQYAiABKAlSCHNjcmlwdElkEjMKBXNjZW5lGAMgASgL'
        'Mh0uY3JlYXRpdmFudGEuY29udGVudC52MS5TY2VuZVIFc2NlbmU=');

@$core.Deprecated('Use scriptServiceAddSectionResponseDescriptor instead')
const ScriptServiceAddSectionResponse$json = {
  '1': 'ScriptServiceAddSectionResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
  ],
};

/// Descriptor for `ScriptServiceAddSectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceAddSectionResponseDescriptor =
    $convert.base64Decode(
        'Ch9TY3JpcHRTZXJ2aWNlQWRkU2VjdGlvblJlc3BvbnNlEjYKBnNjcmlwdBgBIAEoCzIeLmNyZW'
        'F0aXZhbnRhLmNvbnRlbnQudjEuU2NyaXB0UgZzY3JpcHQ=');

@$core.Deprecated('Use scriptServiceUpdateSectionRequestDescriptor instead')
const ScriptServiceUpdateSectionRequest$json = {
  '1': 'ScriptServiceUpdateSectionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {
      '1': 'scene',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Scene',
      '10': 'scene'
    },
  ],
};

/// Descriptor for `ScriptServiceUpdateSectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceUpdateSectionRequestDescriptor =
    $convert.base64Decode(
        'CiFTY3JpcHRTZXJ2aWNlVXBkYXRlU2VjdGlvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIbCglzY3JpcHRfaWQYAiABKAlSCHNjcmlwdElkEjMKBXNjZW5lGAMg'
        'ASgLMh0uY3JlYXRpdmFudGEuY29udGVudC52MS5TY2VuZVIFc2NlbmU=');

@$core.Deprecated('Use scriptServiceUpdateSectionResponseDescriptor instead')
const ScriptServiceUpdateSectionResponse$json = {
  '1': 'ScriptServiceUpdateSectionResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
  ],
};

/// Descriptor for `ScriptServiceUpdateSectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceUpdateSectionResponseDescriptor =
    $convert.base64Decode(
        'CiJTY3JpcHRTZXJ2aWNlVXBkYXRlU2VjdGlvblJlc3BvbnNlEjYKBnNjcmlwdBgBIAEoCzIeLm'
        'NyZWF0aXZhbnRhLmNvbnRlbnQudjEuU2NyaXB0UgZzY3JpcHQ=');

@$core.Deprecated('Use scriptServiceDeleteSectionRequestDescriptor instead')
const ScriptServiceDeleteSectionRequest$json = {
  '1': 'ScriptServiceDeleteSectionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'scene_id', '3': 3, '4': 1, '5': 9, '10': 'sceneId'},
  ],
};

/// Descriptor for `ScriptServiceDeleteSectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceDeleteSectionRequestDescriptor =
    $convert.base64Decode(
        'CiFTY3JpcHRTZXJ2aWNlRGVsZXRlU2VjdGlvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIbCglzY3JpcHRfaWQYAiABKAlSCHNjcmlwdElkEhkKCHNjZW5lX2lk'
        'GAMgASgJUgdzY2VuZUlk');

@$core.Deprecated('Use scriptServiceDeleteSectionResponseDescriptor instead')
const ScriptServiceDeleteSectionResponse$json = {
  '1': 'ScriptServiceDeleteSectionResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
  ],
};

/// Descriptor for `ScriptServiceDeleteSectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceDeleteSectionResponseDescriptor =
    $convert.base64Decode(
        'CiJTY3JpcHRTZXJ2aWNlRGVsZXRlU2VjdGlvblJlc3BvbnNlEjYKBnNjcmlwdBgBIAEoCzIeLm'
        'NyZWF0aXZhbnRhLmNvbnRlbnQudjEuU2NyaXB0UgZzY3JpcHQ=');

@$core.Deprecated('Use scriptServiceReorderSectionsRequestDescriptor instead')
const ScriptServiceReorderSectionsRequest$json = {
  '1': 'ScriptServiceReorderSectionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {
      '1': 'scene_ids_in_order',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'sceneIdsInOrder'
    },
  ],
};

/// Descriptor for `ScriptServiceReorderSectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceReorderSectionsRequestDescriptor =
    $convert.base64Decode(
        'CiNTY3JpcHRTZXJ2aWNlUmVvcmRlclNlY3Rpb25zUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQSKwoSc2NlbmVf'
        'aWRzX2luX29yZGVyGAMgAygJUg9zY2VuZUlkc0luT3JkZXI=');

@$core.Deprecated('Use scriptServiceReorderSectionsResponseDescriptor instead')
const ScriptServiceReorderSectionsResponse$json = {
  '1': 'ScriptServiceReorderSectionsResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
  ],
};

/// Descriptor for `ScriptServiceReorderSectionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceReorderSectionsResponseDescriptor =
    $convert.base64Decode(
        'CiRTY3JpcHRTZXJ2aWNlUmVvcmRlclNlY3Rpb25zUmVzcG9uc2USNgoGc2NyaXB0GAEgASgLMh'
        '4uY3JlYXRpdmFudGEuY29udGVudC52MS5TY3JpcHRSBnNjcmlwdA==');

@$core.Deprecated('Use scriptServiceAddCommentRequestDescriptor instead')
const ScriptServiceAddCommentRequest$json = {
  '1': 'ScriptServiceAddCommentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    {'1': 'scene_index', '3': 4, '4': 1, '5': 5, '10': 'sceneIndex'},
  ],
};

/// Descriptor for `ScriptServiceAddCommentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceAddCommentRequestDescriptor =
    $convert.base64Decode(
        'Ch5TY3JpcHRTZXJ2aWNlQWRkQ29tbWVudFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIbCglzY3JpcHRfaWQYAiABKAlSCHNjcmlwdElkEhgKB2NvbnRlbnQYAyAB'
        'KAlSB2NvbnRlbnQSHwoLc2NlbmVfaW5kZXgYBCABKAVSCnNjZW5lSW5kZXg=');

@$core.Deprecated('Use scriptServiceAddCommentResponseDescriptor instead')
const ScriptServiceAddCommentResponse$json = {
  '1': 'ScriptServiceAddCommentResponse',
  '2': [
    {
      '1': 'comment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ScriptReviewComment',
      '10': 'comment'
    },
  ],
};

/// Descriptor for `ScriptServiceAddCommentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceAddCommentResponseDescriptor =
    $convert.base64Decode(
        'Ch9TY3JpcHRTZXJ2aWNlQWRkQ29tbWVudFJlc3BvbnNlEkUKB2NvbW1lbnQYASABKAsyKy5jcm'
        'VhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdFJldmlld0NvbW1lbnRSB2NvbW1lbnQ=');

@$core.Deprecated('Use scriptServiceResolveCommentRequestDescriptor instead')
const ScriptServiceResolveCommentRequest$json = {
  '1': 'ScriptServiceResolveCommentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'comment_id', '3': 3, '4': 1, '5': 9, '10': 'commentId'},
  ],
};

/// Descriptor for `ScriptServiceResolveCommentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceResolveCommentRequestDescriptor =
    $convert.base64Decode(
        'CiJTY3JpcHRTZXJ2aWNlUmVzb2x2ZUNvbW1lbnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSGwoJc2NyaXB0X2lkGAIgASgJUghzY3JpcHRJZBIdCgpjb21tZW50'
        'X2lkGAMgASgJUgljb21tZW50SWQ=');

@$core.Deprecated('Use scriptServiceResolveCommentResponseDescriptor instead')
const ScriptServiceResolveCommentResponse$json = {
  '1': 'ScriptServiceResolveCommentResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ScriptServiceResolveCommentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceResolveCommentResponseDescriptor =
    $convert.base64Decode(
        'CiNTY3JpcHRTZXJ2aWNlUmVzb2x2ZUNvbW1lbnRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUg'
        'dzdWNjZXNz');

@$core.Deprecated('Use scriptServiceGetVersionRequestDescriptor instead')
const ScriptServiceGetVersionRequest$json = {
  '1': 'ScriptServiceGetVersionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'version_index', '3': 3, '4': 1, '5': 5, '10': 'versionIndex'},
  ],
};

/// Descriptor for `ScriptServiceGetVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetVersionRequestDescriptor =
    $convert.base64Decode(
        'Ch5TY3JpcHRTZXJ2aWNlR2V0VmVyc2lvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIbCglzY3JpcHRfaWQYAiABKAlSCHNjcmlwdElkEiMKDXZlcnNpb25faW5k'
        'ZXgYAyABKAVSDHZlcnNpb25JbmRleA==');

@$core.Deprecated('Use scriptServiceGetVersionResponseDescriptor instead')
const ScriptServiceGetVersionResponse$json = {
  '1': 'ScriptServiceGetVersionResponse',
  '2': [
    {
      '1': 'version',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ScriptVersion',
      '10': 'version'
    },
  ],
};

/// Descriptor for `ScriptServiceGetVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceGetVersionResponseDescriptor =
    $convert.base64Decode(
        'Ch9TY3JpcHRTZXJ2aWNlR2V0VmVyc2lvblJlc3BvbnNlEj8KB3ZlcnNpb24YASABKAsyJS5jcm'
        'VhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdFZlcnNpb25SB3ZlcnNpb24=');

@$core.Deprecated('Use scriptServiceListVersionsRequestDescriptor instead')
const ScriptServiceListVersionsRequest$json = {
  '1': 'ScriptServiceListVersionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
  ],
};

/// Descriptor for `ScriptServiceListVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceListVersionsRequestDescriptor =
    $convert.base64Decode(
        'CiBTY3JpcHRTZXJ2aWNlTGlzdFZlcnNpb25zUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEhsKCXNjcmlwdF9pZBgCIAEoCVIIc2NyaXB0SWQ=');

@$core.Deprecated('Use scriptServiceListVersionsResponseDescriptor instead')
const ScriptServiceListVersionsResponse$json = {
  '1': 'ScriptServiceListVersionsResponse',
  '2': [
    {
      '1': 'versions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.ScriptVersion',
      '10': 'versions'
    },
  ],
};

/// Descriptor for `ScriptServiceListVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceListVersionsResponseDescriptor =
    $convert.base64Decode(
        'CiFTY3JpcHRTZXJ2aWNlTGlzdFZlcnNpb25zUmVzcG9uc2USQQoIdmVyc2lvbnMYASADKAsyJS'
        '5jcmVhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdFZlcnNpb25SCHZlcnNpb25z');

@$core.Deprecated('Use scriptServiceRestoreVersionRequestDescriptor instead')
const ScriptServiceRestoreVersionRequest$json = {
  '1': 'ScriptServiceRestoreVersionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'script_id', '3': 2, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'version_index', '3': 3, '4': 1, '5': 5, '10': 'versionIndex'},
  ],
};

/// Descriptor for `ScriptServiceRestoreVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceRestoreVersionRequestDescriptor =
    $convert.base64Decode(
        'CiJTY3JpcHRTZXJ2aWNlUmVzdG9yZVZlcnNpb25SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSGwoJc2NyaXB0X2lkGAIgASgJUghzY3JpcHRJZBIjCg12ZXJzaW9u'
        'X2luZGV4GAMgASgFUgx2ZXJzaW9uSW5kZXg=');

@$core.Deprecated('Use scriptServiceRestoreVersionResponseDescriptor instead')
const ScriptServiceRestoreVersionResponse$json = {
  '1': 'ScriptServiceRestoreVersionResponse',
  '2': [
    {
      '1': 'script',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Script',
      '10': 'script'
    },
  ],
};

/// Descriptor for `ScriptServiceRestoreVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scriptServiceRestoreVersionResponseDescriptor =
    $convert.base64Decode(
        'CiNTY3JpcHRTZXJ2aWNlUmVzdG9yZVZlcnNpb25SZXNwb25zZRI2CgZzY3JpcHQYASABKAsyHi'
        '5jcmVhdGl2YW50YS5jb250ZW50LnYxLlNjcmlwdFIGc2NyaXB0');

// This is a generated file - do not edit.
//
// Generated from creativanta/production/v1/production.proto.

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

@$core.Deprecated('Use generationJobStatusDescriptor instead')
const GenerationJobStatus$json = {
  '1': 'GenerationJobStatus',
  '2': [
    {'1': 'GENERATION_JOB_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'GENERATION_JOB_STATUS_QUEUED', '2': 1},
    {'1': 'GENERATION_JOB_STATUS_PROCESSING', '2': 2},
    {'1': 'GENERATION_JOB_STATUS_COMPLETED', '2': 3},
    {'1': 'GENERATION_JOB_STATUS_FAILED', '2': 4},
    {'1': 'GENERATION_JOB_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `GenerationJobStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List generationJobStatusDescriptor = $convert.base64Decode(
    'ChNHZW5lcmF0aW9uSm9iU3RhdHVzEiUKIUdFTkVSQVRJT05fSk9CX1NUQVRVU19VTlNQRUNJRk'
    'lFRBAAEiAKHEdFTkVSQVRJT05fSk9CX1NUQVRVU19RVUVVRUQQARIkCiBHRU5FUkFUSU9OX0pP'
    'Ql9TVEFUVVNfUFJPQ0VTU0lORxACEiMKH0dFTkVSQVRJT05fSk9CX1NUQVRVU19DT01QTEVURU'
    'QQAxIgChxHRU5FUkFUSU9OX0pPQl9TVEFUVVNfRkFJTEVEEAQSIwofR0VORVJBVElPTl9KT0Jf'
    'U1RBVFVTX0NBTkNFTExFRBAF');

@$core.Deprecated('Use assetGenerationStateDescriptor instead')
const AssetGenerationState$json = {
  '1': 'AssetGenerationState',
  '2': [
    {'1': 'ASSET_GENERATION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ASSET_GENERATION_STATE_QUEUED', '2': 1},
    {'1': 'ASSET_GENERATION_STATE_GENERATING', '2': 2},
    {'1': 'ASSET_GENERATION_STATE_GENERATED', '2': 3},
    {'1': 'ASSET_GENERATION_STATE_FAILED', '2': 4},
    {'1': 'ASSET_GENERATION_STATE_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `AssetGenerationState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetGenerationStateDescriptor = $convert.base64Decode(
    'ChRBc3NldEdlbmVyYXRpb25TdGF0ZRImCiJBU1NFVF9HRU5FUkFUSU9OX1NUQVRFX1VOU1BFQ0'
    'lGSUVEEAASIQodQVNTRVRfR0VORVJBVElPTl9TVEFURV9RVUVVRUQQARIlCiFBU1NFVF9HRU5F'
    'UkFUSU9OX1NUQVRFX0dFTkVSQVRJTkcQAhIkCiBBU1NFVF9HRU5FUkFUSU9OX1NUQVRFX0dFTk'
    'VSQVRFRBADEiEKHUFTU0VUX0dFTkVSQVRJT05fU1RBVEVfRkFJTEVEEAQSJAogQVNTRVRfR0VO'
    'RVJBVElPTl9TVEFURV9DQU5DRUxMRUQQBQ==');

@$core.Deprecated('Use assetQualityStateDescriptor instead')
const AssetQualityState$json = {
  '1': 'AssetQualityState',
  '2': [
    {'1': 'ASSET_QUALITY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ASSET_QUALITY_STATE_DRAFT', '2': 1},
    {'1': 'ASSET_QUALITY_STATE_REVIEW_REQUIRED', '2': 2},
    {'1': 'ASSET_QUALITY_STATE_APPROVED', '2': 3},
    {'1': 'ASSET_QUALITY_STATE_REJECTED', '2': 4},
    {'1': 'ASSET_QUALITY_STATE_PROMOTED_CANONICAL', '2': 5},
  ],
};

/// Descriptor for `AssetQualityState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetQualityStateDescriptor = $convert.base64Decode(
    'ChFBc3NldFF1YWxpdHlTdGF0ZRIjCh9BU1NFVF9RVUFMSVRZX1NUQVRFX1VOU1BFQ0lGSUVEEA'
    'ASHQoZQVNTRVRfUVVBTElUWV9TVEFURV9EUkFGVBABEicKI0FTU0VUX1FVQUxJVFlfU1RBVEVf'
    'UkVWSUVXX1JFUVVJUkVEEAISIAocQVNTRVRfUVVBTElUWV9TVEFURV9BUFBST1ZFRBADEiAKHE'
    'FTU0VUX1FVQUxJVFlfU1RBVEVfUkVKRUNURUQQBBIqCiZBU1NFVF9RVUFMSVRZX1NUQVRFX1BS'
    'T01PVEVEX0NBTk9OSUNBTBAF');

@$core.Deprecated('Use pipelineStrategyDescriptor instead')
const PipelineStrategy$json = {
  '1': 'PipelineStrategy',
  '2': [
    {'1': 'PIPELINE_STRATEGY_UNSPECIFIED', '2': 0},
    {'1': 'PIPELINE_STRATEGY_NATIVE_AUDIO', '2': 1},
    {'1': 'PIPELINE_STRATEGY_AUDIO_FIRST', '2': 2},
    {'1': 'PIPELINE_STRATEGY_POST_PROD_LIP_SYNC', '2': 3},
    {'1': 'PIPELINE_STRATEGY_SIMPLE_VOICE_OVER', '2': 4},
  ],
};

/// Descriptor for `PipelineStrategy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pipelineStrategyDescriptor = $convert.base64Decode(
    'ChBQaXBlbGluZVN0cmF0ZWd5EiEKHVBJUEVMSU5FX1NUUkFURUdZX1VOU1BFQ0lGSUVEEAASIg'
    'oeUElQRUxJTkVfU1RSQVRFR1lfTkFUSVZFX0FVRElPEAESIQodUElQRUxJTkVfU1RSQVRFR1lf'
    'QVVESU9fRklSU1QQAhIoCiRQSVBFTElORV9TVFJBVEVHWV9QT1NUX1BST0RfTElQX1NZTkMQAx'
    'InCiNQSVBFTElORV9TVFJBVEVHWV9TSU1QTEVfVk9JQ0VfT1ZFUhAE');

@$core.Deprecated('Use productionModeDescriptor instead')
const ProductionMode$json = {
  '1': 'ProductionMode',
  '2': [
    {'1': 'PRODUCTION_MODE_UNSPECIFIED', '2': 0},
    {'1': 'PRODUCTION_MODE_QUICK_EDIT', '2': 1},
    {'1': 'PRODUCTION_MODE_CLIP_FACTORY', '2': 2},
    {'1': 'PRODUCTION_MODE_MULTI_MERGE', '2': 3},
    {'1': 'PRODUCTION_MODE_AI_REMIX', '2': 4},
    {'1': 'PRODUCTION_MODE_PRODUCT_SHOWCASE', '2': 5},
    {'1': 'PRODUCTION_MODE_IMAGE_TO_VIDEO', '2': 6},
    {'1': 'PRODUCTION_MODE_LINK_TO_VIDEO', '2': 7},
    {'1': 'PRODUCTION_MODE_TRANSLATION', '2': 8},
    {'1': 'PRODUCTION_MODE_VIDEO_AGENT', '2': 9},
    {'1': 'PRODUCTION_MODE_THUMBNAIL_STUDIO', '2': 10},
    {'1': 'PRODUCTION_MODE_SOUND_STUDIO', '2': 11},
    {'1': 'PRODUCTION_MODE_STYLE_LEARNING', '2': 12},
  ],
};

/// Descriptor for `ProductionMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List productionModeDescriptor = $convert.base64Decode(
    'Cg5Qcm9kdWN0aW9uTW9kZRIfChtQUk9EVUNUSU9OX01PREVfVU5TUEVDSUZJRUQQABIeChpQUk'
    '9EVUNUSU9OX01PREVfUVVJQ0tfRURJVBABEiAKHFBST0RVQ1RJT05fTU9ERV9DTElQX0ZBQ1RP'
    'UlkQAhIfChtQUk9EVUNUSU9OX01PREVfTVVMVElfTUVSR0UQAxIcChhQUk9EVUNUSU9OX01PRE'
    'VfQUlfUkVNSVgQBBIkCiBQUk9EVUNUSU9OX01PREVfUFJPRFVDVF9TSE9XQ0FTRRAFEiIKHlBS'
    'T0RVQ1RJT05fTU9ERV9JTUFHRV9UT19WSURFTxAGEiEKHVBST0RVQ1RJT05fTU9ERV9MSU5LX1'
    'RPX1ZJREVPEAcSHwobUFJPRFVDVElPTl9NT0RFX1RSQU5TTEFUSU9OEAgSHwobUFJPRFVDVElP'
    'Tl9NT0RFX1ZJREVPX0FHRU5UEAkSJAogUFJPRFVDVElPTl9NT0RFX1RIVU1CTkFJTF9TVFVESU'
    '8QChIgChxQUk9EVUNUSU9OX01PREVfU09VTkRfU1RVRElPEAsSIgoeUFJPRFVDVElPTl9NT0RF'
    'X1NUWUxFX0xFQVJOSU5HEAw=');

@$core.Deprecated('Use fidelityLevelDescriptor instead')
const FidelityLevel$json = {
  '1': 'FidelityLevel',
  '2': [
    {'1': 'FIDELITY_LEVEL_UNSPECIFIED', '2': 0},
    {'1': 'FIDELITY_LEVEL_MATCH_1TO1', '2': 1},
    {'1': 'FIDELITY_LEVEL_ADAPT', '2': 2},
    {'1': 'FIDELITY_LEVEL_LOOSE', '2': 3},
  ],
};

/// Descriptor for `FidelityLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fidelityLevelDescriptor = $convert.base64Decode(
    'Cg1GaWRlbGl0eUxldmVsEh4KGkZJREVMSVRZX0xFVkVMX1VOU1BFQ0lGSUVEEAASHQoZRklERU'
    'xJVFlfTEVWRUxfTUFUQ0hfMVRPMRABEhgKFEZJREVMSVRZX0xFVkVMX0FEQVBUEAISGAoURklE'
    'RUxJVFlfTEVWRUxfTE9PU0UQAw==');

@$core.Deprecated('Use remixStatusDescriptor instead')
const RemixStatus$json = {
  '1': 'RemixStatus',
  '2': [
    {'1': 'REMIX_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REMIX_STATUS_ANALYZING', '2': 1},
    {'1': 'REMIX_STATUS_ANALYZED', '2': 2},
    {'1': 'REMIX_STATUS_GENERATING', '2': 3},
    {'1': 'REMIX_STATUS_GENERATED', '2': 4},
    {'1': 'REMIX_STATUS_FAILED', '2': 5},
    {'1': 'REMIX_STATUS_REJECTED', '2': 6},
  ],
};

/// Descriptor for `RemixStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List remixStatusDescriptor = $convert.base64Decode(
    'CgtSZW1peFN0YXR1cxIcChhSRU1JWF9TVEFUVVNfVU5TUEVDSUZJRUQQABIaChZSRU1JWF9TVE'
    'FUVVNfQU5BTFlaSU5HEAESGQoVUkVNSVhfU1RBVFVTX0FOQUxZWkVEEAISGwoXUkVNSVhfU1RB'
    'VFVTX0dFTkVSQVRJTkcQAxIaChZSRU1JWF9TVEFUVVNfR0VORVJBVEVEEAQSFwoTUkVNSVhfU1'
    'RBVFVTX0ZBSUxFRBAFEhkKFVJFTUlYX1NUQVRVU19SRUpFQ1RFRBAG');

@$core.Deprecated('Use videoEditJobStatusDescriptor instead')
const VideoEditJobStatus$json = {
  '1': 'VideoEditJobStatus',
  '2': [
    {'1': 'VIDEO_EDIT_JOB_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'VIDEO_EDIT_JOB_STATUS_QUEUED', '2': 1},
    {'1': 'VIDEO_EDIT_JOB_STATUS_PROCESSING', '2': 2},
    {'1': 'VIDEO_EDIT_JOB_STATUS_COMPLETED', '2': 3},
    {'1': 'VIDEO_EDIT_JOB_STATUS_PARTIALLY_COMPLETED', '2': 4},
    {'1': 'VIDEO_EDIT_JOB_STATUS_FAILED', '2': 5},
    {'1': 'VIDEO_EDIT_JOB_STATUS_CANCELLED', '2': 6},
  ],
};

/// Descriptor for `VideoEditJobStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List videoEditJobStatusDescriptor = $convert.base64Decode(
    'ChJWaWRlb0VkaXRKb2JTdGF0dXMSJQohVklERU9fRURJVF9KT0JfU1RBVFVTX1VOU1BFQ0lGSU'
    'VEEAASIAocVklERU9fRURJVF9KT0JfU1RBVFVTX1FVRVVFRBABEiQKIFZJREVPX0VESVRfSk9C'
    'X1NUQVRVU19QUk9DRVNTSU5HEAISIwofVklERU9fRURJVF9KT0JfU1RBVFVTX0NPTVBMRVRFRB'
    'ADEi0KKVZJREVPX0VESVRfSk9CX1NUQVRVU19QQVJUSUFMTFlfQ09NUExFVEVEEAQSIAocVklE'
    'RU9fRURJVF9KT0JfU1RBVFVTX0ZBSUxFRBAFEiMKH1ZJREVPX0VESVRfSk9CX1NUQVRVU19DQU'
    '5DRUxMRUQQBg==');

@$core.Deprecated('Use productionModeInfoDescriptor instead')
const ProductionModeInfo$json = {
  '1': 'ProductionModeInfo',
  '2': [
    {
      '1': 'mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ProductionMode',
      '10': 'mode'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'icon', '3': 4, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'credit_cost_range', '3': 5, '4': 1, '5': 9, '10': 'creditCostRange'},
    {'1': 'is_available', '3': 6, '4': 1, '5': 8, '10': 'isAvailable'},
    {
      '1': 'supported_aspect_ratios',
      '3': 7,
      '4': 3,
      '5': 9,
      '10': 'supportedAspectRatios'
    },
  ],
};

/// Descriptor for `ProductionModeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productionModeInfoDescriptor = $convert.base64Decode(
    'ChJQcm9kdWN0aW9uTW9kZUluZm8SPQoEbW9kZRgBIAEoDjIpLmNyZWF0aXZhbnRhLnByb2R1Y3'
    'Rpb24udjEuUHJvZHVjdGlvbk1vZGVSBG1vZGUSFAoFdGl0bGUYAiABKAlSBXRpdGxlEiAKC2Rl'
    'c2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhISCgRpY29uGAQgASgJUgRpY29uEioKEWNyZW'
    'RpdF9jb3N0X3JhbmdlGAUgASgJUg9jcmVkaXRDb3N0UmFuZ2USIQoMaXNfYXZhaWxhYmxlGAYg'
    'ASgIUgtpc0F2YWlsYWJsZRI2ChdzdXBwb3J0ZWRfYXNwZWN0X3JhdGlvcxgHIAMoCVIVc3VwcG'
    '9ydGVkQXNwZWN0UmF0aW9z');

@$core.Deprecated('Use lineageItemDescriptor instead')
const LineageItem$json = {
  '1': 'LineageItem',
  '2': [
    {'1': 'source_provider', '3': 1, '4': 1, '5': 9, '10': 'sourceProvider'},
    {'1': 'source_model', '3': 2, '4': 1, '5': 9, '10': 'sourceModel'},
    {
      '1': 'generation_prompt',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'generationPrompt'
    },
    {
      '1': 'continuity_pack_ids',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'continuityPackIds'
    },
    {
      '1': 'generation_cost_credits',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'generationCostCredits'
    },
    {
      '1': 'generation_cost_usd',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'generationCostUsd'
    },
    {'1': 'parent_asset_id', '3': 7, '4': 1, '5': 9, '10': 'parentAssetId'},
    {
      '1': 'recorded_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
  ],
};

/// Descriptor for `LineageItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lineageItemDescriptor = $convert.base64Decode(
    'CgtMaW5lYWdlSXRlbRInCg9zb3VyY2VfcHJvdmlkZXIYASABKAlSDnNvdXJjZVByb3ZpZGVyEi'
    'EKDHNvdXJjZV9tb2RlbBgCIAEoCVILc291cmNlTW9kZWwSKwoRZ2VuZXJhdGlvbl9wcm9tcHQY'
    'AyABKAlSEGdlbmVyYXRpb25Qcm9tcHQSLgoTY29udGludWl0eV9wYWNrX2lkcxgEIAMoCVIRY2'
    '9udGludWl0eVBhY2tJZHMSNgoXZ2VuZXJhdGlvbl9jb3N0X2NyZWRpdHMYBSABKAlSFWdlbmVy'
    'YXRpb25Db3N0Q3JlZGl0cxIuChNnZW5lcmF0aW9uX2Nvc3RfdXNkGAYgASgJUhFnZW5lcmF0aW'
    '9uQ29zdFVzZBImCg9wYXJlbnRfYXNzZXRfaWQYByABKAlSDXBhcmVudEFzc2V0SWQSOwoLcmVj'
    'b3JkZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0');

@$core.Deprecated('Use postProductionConfigDescriptor instead')
const PostProductionConfig$json = {
  '1': 'PostProductionConfig',
  '2': [
    {'1': 'normalize_audio', '3': 1, '4': 1, '5': 8, '10': 'normalizeAudio'},
    {'1': 'target_lufs', '3': 2, '4': 1, '5': 1, '10': 'targetLufs'},
    {'1': 'aspect_ratio', '3': 3, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'subtitle_overlay', '3': 4, '4': 1, '5': 8, '10': 'subtitleOverlay'},
    {'1': 'subtitle_style', '3': 5, '4': 1, '5': 9, '10': 'subtitleStyle'},
    {
      '1': 'active_speaker_reframe',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'activeSpeakerReframe'
    },
  ],
};

/// Descriptor for `PostProductionConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postProductionConfigDescriptor = $convert.base64Decode(
    'ChRQb3N0UHJvZHVjdGlvbkNvbmZpZxInCg9ub3JtYWxpemVfYXVkaW8YASABKAhSDm5vcm1hbG'
    'l6ZUF1ZGlvEh8KC3RhcmdldF9sdWZzGAIgASgBUgp0YXJnZXRMdWZzEiEKDGFzcGVjdF9yYXRp'
    'bxgDIAEoCVILYXNwZWN0UmF0aW8SKQoQc3VidGl0bGVfb3ZlcmxheRgEIAEoCFIPc3VidGl0bG'
    'VPdmVybGF5EiUKDnN1YnRpdGxlX3N0eWxlGAUgASgJUg1zdWJ0aXRsZVN0eWxlEjQKFmFjdGl2'
    'ZV9zcGVha2VyX3JlZnJhbWUYBiABKAhSFGFjdGl2ZVNwZWFrZXJSZWZyYW1l');

@$core.Deprecated('Use generationJobDescriptor instead')
const GenerationJob$json = {
  '1': 'GenerationJob',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'job_type', '3': 4, '4': 1, '5': 9, '10': 'jobType'},
    {'1': 'provider', '3': 5, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'model', '3': 6, '4': 1, '5': 9, '10': 'model'},
    {
      '1': 'pipeline_strategy',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.PipelineStrategy',
      '10': 'pipelineStrategy'
    },
    {'1': 'input_params_json', '3': 8, '4': 1, '5': 9, '10': 'inputParamsJson'},
    {
      '1': 'prompt_package_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'promptPackageJson'
    },
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.GenerationJobStatus',
      '10': 'status'
    },
    {'1': 'progress_pct', '3': 11, '4': 1, '5': 5, '10': 'progressPct'},
    {'1': 'current_step', '3': 12, '4': 1, '5': 9, '10': 'currentStep'},
    {
      '1': 'estimated_credits',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'estimatedCredits'
    },
    {'1': 'actual_credits', '3': 14, '4': 1, '5': 9, '10': 'actualCredits'},
    {'1': 'actual_cost_usd', '3': 15, '4': 1, '5': 9, '10': 'actualCostUsd'},
    {'1': 'provider_job_id', '3': 16, '4': 1, '5': 9, '10': 'providerJobId'},
    {'1': 'result_url', '3': 17, '4': 1, '5': 9, '10': 'resultUrl'},
    {
      '1': 'result_metadata_json',
      '3': 18,
      '4': 1,
      '5': 9,
      '10': 'resultMetadataJson'
    },
    {'1': 'error_code', '3': 19, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 20, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'retry_count', '3': 21, '4': 1, '5': 5, '10': 'retryCount'},
    {'1': 'max_retries', '3': 22, '4': 1, '5': 5, '10': 'maxRetries'},
    {
      '1': 'started_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'completed_at',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {
      '1': 'created_at',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'quote_id', '3': 27, '4': 1, '5': 9, '10': 'quoteId'},
    {'1': 'reservation_id', '3': 28, '4': 1, '5': 9, '10': 'reservationId'},
  ],
};

/// Descriptor for `GenerationJob`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generationJobDescriptor = $convert.base64Decode(
    'Cg1HZW5lcmF0aW9uSm9iEhUKBmpvYl9pZBgBIAEoCVIFam9iSWQSIQoMd29ya3NwYWNlX2lkGA'
    'IgASgJUgt3b3Jrc3BhY2VJZBIZCghhc3NldF9pZBgDIAEoCVIHYXNzZXRJZBIZCghqb2JfdHlw'
    'ZRgEIAEoCVIHam9iVHlwZRIaCghwcm92aWRlchgFIAEoCVIIcHJvdmlkZXISFAoFbW9kZWwYBi'
    'ABKAlSBW1vZGVsElgKEXBpcGVsaW5lX3N0cmF0ZWd5GAcgASgOMisuY3JlYXRpdmFudGEucHJv'
    'ZHVjdGlvbi52MS5QaXBlbGluZVN0cmF0ZWd5UhBwaXBlbGluZVN0cmF0ZWd5EioKEWlucHV0X3'
    'BhcmFtc19qc29uGAggASgJUg9pbnB1dFBhcmFtc0pzb24SLgoTcHJvbXB0X3BhY2thZ2VfanNv'
    'bhgJIAEoCVIRcHJvbXB0UGFja2FnZUpzb24SRgoGc3RhdHVzGAogASgOMi4uY3JlYXRpdmFudG'
    'EucHJvZHVjdGlvbi52MS5HZW5lcmF0aW9uSm9iU3RhdHVzUgZzdGF0dXMSIQoMcHJvZ3Jlc3Nf'
    'cGN0GAsgASgFUgtwcm9ncmVzc1BjdBIhCgxjdXJyZW50X3N0ZXAYDCABKAlSC2N1cnJlbnRTdG'
    'VwEisKEWVzdGltYXRlZF9jcmVkaXRzGA0gASgJUhBlc3RpbWF0ZWRDcmVkaXRzEiUKDmFjdHVh'
    'bF9jcmVkaXRzGA4gASgJUg1hY3R1YWxDcmVkaXRzEiYKD2FjdHVhbF9jb3N0X3VzZBgPIAEoCV'
    'INYWN0dWFsQ29zdFVzZBImCg9wcm92aWRlcl9qb2JfaWQYECABKAlSDXByb3ZpZGVySm9iSWQS'
    'HQoKcmVzdWx0X3VybBgRIAEoCVIJcmVzdWx0VXJsEjAKFHJlc3VsdF9tZXRhZGF0YV9qc29uGB'
    'IgASgJUhJyZXN1bHRNZXRhZGF0YUpzb24SHQoKZXJyb3JfY29kZRgTIAEoCVIJZXJyb3JDb2Rl'
    'EiMKDWVycm9yX21lc3NhZ2UYFCABKAlSDGVycm9yTWVzc2FnZRIfCgtyZXRyeV9jb3VudBgVIA'
    'EoBVIKcmV0cnlDb3VudBIfCgttYXhfcmV0cmllcxgWIAEoBVIKbWF4UmV0cmllcxI5CgpzdGFy'
    'dGVkX2F0GBcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0Ej0KDG'
    'NvbXBsZXRlZF9hdBgYIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbXBsZXRl'
    'ZEF0EjkKCmNyZWF0ZWRfYXQYGSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcm'
    'VhdGVkQXQSOQoKdXBkYXRlZF9hdBgaIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXVwZGF0ZWRBdBIZCghxdW90ZV9pZBgbIAEoCVIHcXVvdGVJZBIlCg5yZXNlcnZhdGlvbl9pZB'
    'gcIAEoCVINcmVzZXJ2YXRpb25JZA==');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'asset_type', '3': 3, '4': 1, '5': 9, '10': 'assetType'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'script_id', '3': 5, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'asset_brief_id', '3': 6, '4': 1, '5': 9, '10': 'assetBriefId'},
    {
      '1': 'source_generation_mode',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'sourceGenerationMode'
    },
    {'1': 'source_provider', '3': 8, '4': 1, '5': 9, '10': 'sourceProvider'},
    {'1': 'source_model', '3': 9, '4': 1, '5': 9, '10': 'sourceModel'},
    {'1': 'file_url', '3': 10, '4': 1, '5': 9, '10': 'fileUrl'},
    {'1': 'file_size_bytes', '3': 11, '4': 1, '5': 3, '10': 'fileSizeBytes'},
    {'1': 'duration_seconds', '3': 12, '4': 1, '5': 9, '10': 'durationSeconds'},
    {'1': 'resolution', '3': 13, '4': 1, '5': 9, '10': 'resolution'},
    {'1': 'aspect_ratio', '3': 14, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'mime_type', '3': 15, '4': 1, '5': 9, '10': 'mimeType'},
    {
      '1': 'generation_state',
      '3': 16,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.AssetGenerationState',
      '10': 'generationState'
    },
    {
      '1': 'quality_state',
      '3': 17,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.AssetQualityState',
      '10': 'qualityState'
    },
    {
      '1': 'lineage',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.LineageItem',
      '10': 'lineage'
    },
    {
      '1': 'continuity_pack_ids',
      '3': 19,
      '4': 3,
      '5': 9,
      '10': 'continuityPackIds'
    },
    {
      '1': 'generation_cost_credits',
      '3': 20,
      '4': 1,
      '5': 9,
      '10': 'generationCostCredits'
    },
    {
      '1': 'generation_cost_usd',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'generationCostUsd'
    },
    {
      '1': 'generation_prompt',
      '3': 22,
      '4': 1,
      '5': 9,
      '10': 'generationPrompt'
    },
    {'1': 'parent_asset_id', '3': 23, '4': 1, '5': 9, '10': 'parentAssetId'},
    {'1': 'derivative_type', '3': 24, '4': 1, '5': 9, '10': 'derivativeType'},
    {
      '1': 'created_at',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'drift_score', '3': 27, '4': 1, '5': 2, '10': 'driftScore'},
    {'1': 'drift_severity', '3': 28, '4': 1, '5': 9, '10': 'driftSeverity'},
    {
      '1': 'drift_details_json',
      '3': 29,
      '4': 1,
      '5': 9,
      '10': 'driftDetailsJson'
    },
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIhCgx3b3Jrc3BhY2VfaWQYAiABKA'
    'lSC3dvcmtzcGFjZUlkEh0KCmFzc2V0X3R5cGUYAyABKAlSCWFzc2V0VHlwZRIUCgV0aXRsZRgE'
    'IAEoCVIFdGl0bGUSGwoJc2NyaXB0X2lkGAUgASgJUghzY3JpcHRJZBIkCg5hc3NldF9icmllZl'
    '9pZBgGIAEoCVIMYXNzZXRCcmllZklkEjQKFnNvdXJjZV9nZW5lcmF0aW9uX21vZGUYByABKAlS'
    'FHNvdXJjZUdlbmVyYXRpb25Nb2RlEicKD3NvdXJjZV9wcm92aWRlchgIIAEoCVIOc291cmNlUH'
    'JvdmlkZXISIQoMc291cmNlX21vZGVsGAkgASgJUgtzb3VyY2VNb2RlbBIZCghmaWxlX3VybBgK'
    'IAEoCVIHZmlsZVVybBImCg9maWxlX3NpemVfYnl0ZXMYCyABKANSDWZpbGVTaXplQnl0ZXMSKQ'
    'oQZHVyYXRpb25fc2Vjb25kcxgMIAEoCVIPZHVyYXRpb25TZWNvbmRzEh4KCnJlc29sdXRpb24Y'
    'DSABKAlSCnJlc29sdXRpb24SIQoMYXNwZWN0X3JhdGlvGA4gASgJUgthc3BlY3RSYXRpbxIbCg'
    'ltaW1lX3R5cGUYDyABKAlSCG1pbWVUeXBlEloKEGdlbmVyYXRpb25fc3RhdGUYECABKA4yLy5j'
    'cmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkFzc2V0R2VuZXJhdGlvblN0YXRlUg9nZW5lcmF0aW'
    '9uU3RhdGUSUQoNcXVhbGl0eV9zdGF0ZRgRIAEoDjIsLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24u'
    'djEuQXNzZXRRdWFsaXR5U3RhdGVSDHF1YWxpdHlTdGF0ZRJACgdsaW5lYWdlGBIgAygLMiYuY3'
    'JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5MaW5lYWdlSXRlbVIHbGluZWFnZRIuChNjb250aW51'
    'aXR5X3BhY2tfaWRzGBMgAygJUhFjb250aW51aXR5UGFja0lkcxI2ChdnZW5lcmF0aW9uX2Nvc3'
    'RfY3JlZGl0cxgUIAEoCVIVZ2VuZXJhdGlvbkNvc3RDcmVkaXRzEi4KE2dlbmVyYXRpb25fY29z'
    'dF91c2QYFSABKAlSEWdlbmVyYXRpb25Db3N0VXNkEisKEWdlbmVyYXRpb25fcHJvbXB0GBYgAS'
    'gJUhBnZW5lcmF0aW9uUHJvbXB0EiYKD3BhcmVudF9hc3NldF9pZBgXIAEoCVINcGFyZW50QXNz'
    'ZXRJZBInCg9kZXJpdmF0aXZlX3R5cGUYGCABKAlSDmRlcml2YXRpdmVUeXBlEjkKCmNyZWF0ZW'
    'RfYXQYGSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBk'
    'YXRlZF9hdBgaIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBIfCg'
    'tkcmlmdF9zY29yZRgbIAEoAlIKZHJpZnRTY29yZRIlCg5kcmlmdF9zZXZlcml0eRgcIAEoCVIN'
    'ZHJpZnRTZXZlcml0eRIsChJkcmlmdF9kZXRhaWxzX2pzb24YHSABKAlSEGRyaWZ0RGV0YWlsc0'
    'pzb24=');

@$core.Deprecated('Use batchInputValidationItemDescriptor instead')
const BatchInputValidationItem$json = {
  '1': 'BatchInputValidationItem',
  '2': [
    {'1': 'row_index', '3': 1, '4': 1, '5': 5, '10': 'rowIndex'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'item_name', '3': 3, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'is_valid', '3': 4, '4': 1, '5': 8, '10': 'isValid'},
    {'1': 'validation_error', '3': 5, '4': 1, '5': 9, '10': 'validationError'},
    {
      '1': 'estimated_credits',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'estimatedCredits'
    },
    {
      '1': 'estimated_cost_usd',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'estimatedCostUsd'
    },
  ],
};

/// Descriptor for `BatchInputValidationItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchInputValidationItemDescriptor = $convert.base64Decode(
    'ChhCYXRjaElucHV0VmFsaWRhdGlvbkl0ZW0SGwoJcm93X2luZGV4GAEgASgFUghyb3dJbmRleB'
    'IXCgdpdGVtX2lkGAIgASgJUgZpdGVtSWQSGwoJaXRlbV9uYW1lGAMgASgJUghpdGVtTmFtZRIZ'
    'Cghpc192YWxpZBgEIAEoCFIHaXNWYWxpZBIpChB2YWxpZGF0aW9uX2Vycm9yGAUgASgJUg92YW'
    'xpZGF0aW9uRXJyb3ISKwoRZXN0aW1hdGVkX2NyZWRpdHMYBiABKAlSEGVzdGltYXRlZENyZWRp'
    'dHMSLAoSZXN0aW1hdGVkX2Nvc3RfdXNkGAcgASgJUhBlc3RpbWF0ZWRDb3N0VXNk');

@$core.Deprecated('Use batchBudgetPreviewDescriptor instead')
const BatchBudgetPreview$json = {
  '1': 'BatchBudgetPreview',
  '2': [
    {
      '1': 'total_estimated_credits',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'totalEstimatedCredits'
    },
    {
      '1': 'total_cost_ceiling_usd',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'totalCostCeilingUsd'
    },
    {'1': 'total_items', '3': 3, '4': 1, '5': 5, '10': 'totalItems'},
    {'1': 'valid_items_count', '3': 4, '4': 1, '5': 5, '10': 'validItemsCount'},
    {
      '1': 'invalid_items_count',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'invalidItemsCount'
    },
    {
      '1': 'items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.BatchInputValidationItem',
      '10': 'items'
    },
    {
      '1': 'sufficient_credits',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'sufficientCredits'
    },
    {
      '1': 'current_available_credits',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'currentAvailableCredits'
    },
    {'1': 'quote_id', '3': 9, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'quote_expires_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'quoteExpiresAt'
    },
  ],
};

/// Descriptor for `BatchBudgetPreview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchBudgetPreviewDescriptor = $convert.base64Decode(
    'ChJCYXRjaEJ1ZGdldFByZXZpZXcSNgoXdG90YWxfZXN0aW1hdGVkX2NyZWRpdHMYASABKAlSFX'
    'RvdGFsRXN0aW1hdGVkQ3JlZGl0cxIzChZ0b3RhbF9jb3N0X2NlaWxpbmdfdXNkGAIgASgJUhN0'
    'b3RhbENvc3RDZWlsaW5nVXNkEh8KC3RvdGFsX2l0ZW1zGAMgASgFUgp0b3RhbEl0ZW1zEioKEX'
    'ZhbGlkX2l0ZW1zX2NvdW50GAQgASgFUg92YWxpZEl0ZW1zQ291bnQSLgoTaW52YWxpZF9pdGVt'
    'c19jb3VudBgFIAEoBVIRaW52YWxpZEl0ZW1zQ291bnQSSQoFaXRlbXMYBiADKAsyMy5jcmVhdG'
    'l2YW50YS5wcm9kdWN0aW9uLnYxLkJhdGNoSW5wdXRWYWxpZGF0aW9uSXRlbVIFaXRlbXMSLQoS'
    'c3VmZmljaWVudF9jcmVkaXRzGAcgASgIUhFzdWZmaWNpZW50Q3JlZGl0cxI6ChljdXJyZW50X2'
    'F2YWlsYWJsZV9jcmVkaXRzGAggASgJUhdjdXJyZW50QXZhaWxhYmxlQ3JlZGl0cxIZCghxdW90'
    'ZV9pZBgJIAEoCVIHcXVvdGVJZBJEChBxdW90ZV9leHBpcmVzX2F0GAogASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIOcXVvdGVFeHBpcmVzQXQ=');

@$core.Deprecated('Use getModesRequestDescriptor instead')
const GetModesRequest$json = {
  '1': 'GetModesRequest',
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

/// Descriptor for `GetModesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getModesRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRNb2Rlc1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdmFudGEuY2'
    '9tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use getModesResponseDescriptor instead')
const GetModesResponse$json = {
  '1': 'GetModesResponse',
  '2': [
    {
      '1': 'modes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ProductionModeInfo',
      '10': 'modes'
    },
  ],
};

/// Descriptor for `GetModesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getModesResponseDescriptor = $convert.base64Decode(
    'ChBHZXRNb2Rlc1Jlc3BvbnNlEkMKBW1vZGVzGAEgAygLMi0uY3JlYXRpdmFudGEucHJvZHVjdG'
    'lvbi52MS5Qcm9kdWN0aW9uTW9kZUluZm9SBW1vZGVz');

@$core.Deprecated('Use getActiveJobsRequestDescriptor instead')
const GetActiveJobsRequest$json = {
  '1': 'GetActiveJobsRequest',
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
  ],
};

/// Descriptor for `GetActiveJobsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActiveJobsRequestDescriptor = $convert.base64Decode(
    'ChRHZXRBY3RpdmVKb2JzUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNy'
    'ZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getActiveJobsResponseDescriptor instead')
const GetActiveJobsResponse$json = {
  '1': 'GetActiveJobsResponse',
  '2': [
    {
      '1': 'jobs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.GenerationJob',
      '10': 'jobs'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
    {
      '1': 'total_active_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'totalActiveCount'
    },
  ],
};

/// Descriptor for `GetActiveJobsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActiveJobsResponseDescriptor = $convert.base64Decode(
    'ChVHZXRBY3RpdmVKb2JzUmVzcG9uc2USPAoEam9icxgBIAMoCzIoLmNyZWF0aXZhbnRhLnByb2'
    'R1Y3Rpb24udjEuR2VuZXJhdGlvbkpvYlIEam9icxJICgpwYWdpbmF0aW9uGAIgASgLMiguY3Jl'
    'YXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW9uEiwKEnRvdG'
    'FsX2FjdGl2ZV9jb3VudBgDIAEoBVIQdG90YWxBY3RpdmVDb3VudA==');

@$core.Deprecated('Use getRecentAssetsRequestDescriptor instead')
const GetRecentAssetsRequest$json = {
  '1': 'GetRecentAssetsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetRecentAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecentAssetsRequestDescriptor = $convert.base64Decode(
    'ChZHZXRSZWNlbnRBc3NldHNSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIUCgVsaW1pdBgCIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getRecentAssetsResponseDescriptor instead')
const GetRecentAssetsResponse$json = {
  '1': 'GetRecentAssetsResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'assets'
    },
  ],
};

/// Descriptor for `GetRecentAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecentAssetsResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRSZWNlbnRBc3NldHNSZXNwb25zZRI4CgZhc3NldHMYASADKAsyIC5jcmVhdGl2YW50YS'
        '5wcm9kdWN0aW9uLnYxLkFzc2V0UgZhc3NldHM=');

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
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `CancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRequestDescriptor = $convert.base64Decode(
    'Cg1DYW5jZWxSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udj'
    'EuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSFQoGam9iX2lkGAIgASgJUgVqb2JJZA==');

@$core.Deprecated('Use cancelResponseDescriptor instead')
const CancelResponse$json = {
  '1': 'CancelResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.GenerationJob',
      '10': 'job'
    },
    {'1': 'credits_refunded', '3': 2, '4': 1, '5': 8, '10': 'creditsRefunded'},
    {'1': 'refunded_credits', '3': 3, '4': 1, '5': 9, '10': 'refundedCredits'},
  ],
};

/// Descriptor for `CancelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelResponseDescriptor = $convert.base64Decode(
    'Cg5DYW5jZWxSZXNwb25zZRI6CgNqb2IYASABKAsyKC5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLn'
    'YxLkdlbmVyYXRpb25Kb2JSA2pvYhIpChBjcmVkaXRzX3JlZnVuZGVkGAIgASgIUg9jcmVkaXRz'
    'UmVmdW5kZWQSKQoQcmVmdW5kZWRfY3JlZGl0cxgDIAEoCVIPcmVmdW5kZWRDcmVkaXRz');

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
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
    {
      '1': 'use_fallback_provider',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'useFallbackProvider'
    },
  ],
};

/// Descriptor for `RetryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryRequestDescriptor = $convert.base64Decode(
    'CgxSZXRyeVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS'
    '5Db21tYW5kQ29udGV4dFIHY29udGV4dBIVCgZqb2JfaWQYAiABKAlSBWpvYklkEjIKFXVzZV9m'
    'YWxsYmFja19wcm92aWRlchgDIAEoCFITdXNlRmFsbGJhY2tQcm92aWRlcg==');

@$core.Deprecated('Use retryResponseDescriptor instead')
const RetryResponse$json = {
  '1': 'RetryResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.GenerationJob',
      '10': 'job'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RetryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryResponseDescriptor = $convert.base64Decode(
    'Cg1SZXRyeVJlc3BvbnNlEjoKA2pvYhgBIAEoCzIoLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udj'
    'EuR2VuZXJhdGlvbkpvYlIDam9iEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use batchGenerationItemDescriptor instead')
const BatchGenerationItem$json = {
  '1': 'BatchGenerationItem',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'item_name', '3': 2, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'prompt', '3': 3, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'reference_url', '3': 4, '4': 1, '5': 9, '10': 'referenceUrl'},
    {'1': 'image_urls', '3': 5, '4': 3, '5': 9, '10': 'imageUrls'},
  ],
};

/// Descriptor for `BatchGenerationItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchGenerationItemDescriptor = $convert.base64Decode(
    'ChNCYXRjaEdlbmVyYXRpb25JdGVtEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIbCglpdGVtX2'
    '5hbWUYAiABKAlSCGl0ZW1OYW1lEhYKBnByb21wdBgDIAEoCVIGcHJvbXB0EiMKDXJlZmVyZW5j'
    'ZV91cmwYBCABKAlSDHJlZmVyZW5jZVVybBIdCgppbWFnZV91cmxzGAUgAygJUglpbWFnZVVybH'
    'M=');

@$core.Deprecated('Use generateRequestDescriptor instead')
const GenerateRequest$json = {
  '1': 'GenerateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ProductionMode',
      '10': 'mode'
    },
    {'1': 'prompt', '3': 4, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'script_id', '3': 5, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'asset_brief_id', '3': 6, '4': 1, '5': 9, '10': 'assetBriefId'},
    {
      '1': 'continuity_pack_ids',
      '3': 7,
      '4': 3,
      '5': 9,
      '10': 'continuityPackIds'
    },
    {
      '1': 'pipeline_strategy',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.PipelineStrategy',
      '10': 'pipelineStrategy'
    },
    {
      '1': 'preferred_provider',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'preferredProvider'
    },
    {'1': 'preferred_model', '3': 10, '4': 1, '5': 9, '10': 'preferredModel'},
    {
      '1': 'post_production',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.PostProductionConfig',
      '10': 'postProduction'
    },
    {'1': 'byok_api_key', '3': 12, '4': 1, '5': 9, '10': 'byokApiKey'},
    {'1': 'quote_id', '3': 13, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
    {'1': 'dry_run', '3': 15, '4': 1, '5': 8, '10': 'dryRun'},
    {
      '1': 'batch_items',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.BatchGenerationItem',
      '10': 'batchItems'
    },
  ],
};

/// Descriptor for `GenerateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateRequestDescriptor = $convert.base64Decode(
    'Cg9HZW5lcmF0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi'
    '52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSPQoEbW9k'
    'ZRgDIAEoDjIpLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuUHJvZHVjdGlvbk1vZGVSBG1vZG'
    'USFgoGcHJvbXB0GAQgASgJUgZwcm9tcHQSGwoJc2NyaXB0X2lkGAUgASgJUghzY3JpcHRJZBIk'
    'Cg5hc3NldF9icmllZl9pZBgGIAEoCVIMYXNzZXRCcmllZklkEi4KE2NvbnRpbnVpdHlfcGFja1'
    '9pZHMYByADKAlSEWNvbnRpbnVpdHlQYWNrSWRzElgKEXBpcGVsaW5lX3N0cmF0ZWd5GAggASgO'
    'MisuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5QaXBlbGluZVN0cmF0ZWd5UhBwaXBlbGluZV'
    'N0cmF0ZWd5Ei0KEnByZWZlcnJlZF9wcm92aWRlchgJIAEoCVIRcHJlZmVycmVkUHJvdmlkZXIS'
    'JwoPcHJlZmVycmVkX21vZGVsGAogASgJUg5wcmVmZXJyZWRNb2RlbBJYCg9wb3N0X3Byb2R1Y3'
    'Rpb24YCyABKAsyLy5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlBvc3RQcm9kdWN0aW9uQ29u'
    'ZmlnUg5wb3N0UHJvZHVjdGlvbhIgCgxieW9rX2FwaV9rZXkYDCABKAlSCmJ5b2tBcGlLZXkSGQ'
    'oIcXVvdGVfaWQYDSABKAlSB3F1b3RlSWQSKwoRY29uZmlybWVkX2NyZWRpdHMYDiABKAlSEGNv'
    'bmZpcm1lZENyZWRpdHMSFwoHZHJ5X3J1bhgPIAEoCFIGZHJ5UnVuEk8KC2JhdGNoX2l0ZW1zGB'
    'AgAygLMi4uY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5CYXRjaEdlbmVyYXRpb25JdGVtUgpi'
    'YXRjaEl0ZW1z');

@$core.Deprecated('Use generateResponseDescriptor instead')
const GenerateResponse$json = {
  '1': 'GenerateResponse',
  '2': [
    {'1': 'is_dry_run', '3': 1, '4': 1, '5': 8, '10': 'isDryRun'},
    {
      '1': 'budget_preview',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.BatchBudgetPreview',
      '10': 'budgetPreview'
    },
    {
      '1': 'job',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.GenerationJob',
      '10': 'job'
    },
    {
      '1': 'asset',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
    {
      '1': 'batch_jobs',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.GenerationJob',
      '10': 'batchJobs'
    },
    {
      '1': 'batch_assets',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'batchAssets'
    },
  ],
};

/// Descriptor for `GenerateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateResponseDescriptor = $convert.base64Decode(
    'ChBHZW5lcmF0ZVJlc3BvbnNlEhwKCmlzX2RyeV9ydW4YASABKAhSCGlzRHJ5UnVuElQKDmJ1ZG'
    'dldF9wcmV2aWV3GAIgASgLMi0uY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5CYXRjaEJ1ZGdl'
    'dFByZXZpZXdSDWJ1ZGdldFByZXZpZXcSOgoDam9iGAMgASgLMiguY3JlYXRpdmFudGEucHJvZH'
    'VjdGlvbi52MS5HZW5lcmF0aW9uSm9iUgNqb2ISNgoFYXNzZXQYBCABKAsyIC5jcmVhdGl2YW50'
    'YS5wcm9kdWN0aW9uLnYxLkFzc2V0UgVhc3NldBJHCgpiYXRjaF9qb2JzGAUgAygLMiguY3JlYX'
    'RpdmFudGEucHJvZHVjdGlvbi52MS5HZW5lcmF0aW9uSm9iUgliYXRjaEpvYnMSQwoMYmF0Y2hf'
    'YXNzZXRzGAYgAygLMiAuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5Bc3NldFILYmF0Y2hBc3'
    'NldHM=');

@$core.Deprecated('Use getStatusRequestDescriptor instead')
const GetStatusRequest$json = {
  '1': 'GetStatusRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `GetStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusRequestDescriptor = $convert.base64Decode(
    'ChBHZXRTdGF0dXNSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLm'
    'NvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIVCgZqb2JfaWQYAiABKAlSBWpvYklk');

@$core.Deprecated('Use getStatusResponseDescriptor instead')
const GetStatusResponse$json = {
  '1': 'GetStatusResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.GenerationJob',
      '10': 'job'
    },
    {
      '1': 'asset',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `GetStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatusResponseDescriptor = $convert.base64Decode(
    'ChFHZXRTdGF0dXNSZXNwb25zZRI6CgNqb2IYASABKAsyKC5jcmVhdGl2YW50YS5wcm9kdWN0aW'
    '9uLnYxLkdlbmVyYXRpb25Kb2JSA2pvYhI2CgVhc3NldBgCIAEoCzIgLmNyZWF0aXZhbnRhLnBy'
    'b2R1Y3Rpb24udjEuQXNzZXRSBWFzc2V0');

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
    {'1': 'asset_type', '3': 2, '4': 1, '5': 9, '10': 'assetType'},
    {'1': 'generation_state', '3': 3, '4': 1, '5': 9, '10': 'generationState'},
    {'1': 'quality_state', '3': 4, '4': 1, '5': 9, '10': 'qualityState'},
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
    '4udjEuVVVJRFILd29ya3NwYWNlSWQSHQoKYXNzZXRfdHlwZRgCIAEoCVIJYXNzZXRUeXBlEikK'
    'EGdlbmVyYXRpb25fc3RhdGUYAyABKAlSD2dlbmVyYXRpb25TdGF0ZRIjCg1xdWFsaXR5X3N0YX'
    'RlGAQgASgJUgxxdWFsaXR5U3RhdGUSQQoKcGFnaW5hdGlvbhgFIAEoCzIhLmNyZWF0aXZhbnRh'
    'LmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'assets'
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
    'CgxMaXN0UmVzcG9uc2USOAoGYXNzZXRzGAEgAygLMiAuY3JlYXRpdmFudGEucHJvZHVjdGlvbi'
    '52MS5Bc3NldFIGYXNzZXRzEkgKCnBhZ2luYXRpb24YAiABKAsyKC5jcmVhdGl2YW50YS5jb21t'
    'b24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use getRequestDescriptor instead')
const GetRequest$json = {
  '1': 'GetRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `GetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRequestDescriptor = $convert.base64Decode(
    'CgpHZXRSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi'
    '52MS5VVUlEUgt3b3Jrc3BhY2VJZBIZCghhc3NldF9pZBgCIAEoCVIHYXNzZXRJZA==');

@$core.Deprecated('Use getResponseDescriptor instead')
const GetResponse$json = {
  '1': 'GetResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `GetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getResponseDescriptor = $convert.base64Decode(
    'CgtHZXRSZXNwb25zZRI2CgVhc3NldBgBIAEoCzIgLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udj'
    'EuQXNzZXRSBWFzc2V0');

@$core.Deprecated('Use approveRequestDescriptor instead')
const ApproveRequest$json = {
  '1': 'ApproveRequest',
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
    {'1': 'feedback_notes', '3': 3, '4': 1, '5': 9, '10': 'feedbackNotes'},
  ],
};

/// Descriptor for `ApproveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveRequestDescriptor = $convert.base64Decode(
    'Cg5BcHByb3ZlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhkKCGFzc2V0X2lkGAIgASgJUgdhc3NldElkEiUK'
    'DmZlZWRiYWNrX25vdGVzGAMgASgJUg1mZWVkYmFja05vdGVz');

@$core.Deprecated('Use approveResponseDescriptor instead')
const ApproveResponse$json = {
  '1': 'ApproveResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `ApproveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveResponseDescriptor = $convert.base64Decode(
    'Cg9BcHByb3ZlUmVzcG9uc2USNgoFYXNzZXQYASABKAsyIC5jcmVhdGl2YW50YS5wcm9kdWN0aW'
    '9uLnYxLkFzc2V0UgVhc3NldA==');

@$core.Deprecated('Use promoteCanonicalRequestDescriptor instead')
const PromoteCanonicalRequest$json = {
  '1': 'PromoteCanonicalRequest',
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
    {'1': 'pack_id', '3': 3, '4': 1, '5': 9, '10': 'packId'},
  ],
};

/// Descriptor for `PromoteCanonicalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List promoteCanonicalRequestDescriptor = $convert.base64Decode(
    'ChdQcm9tb3RlQ2Fub25pY2FsUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhkKCGFzc2V0X2lkGAIgASgJUgdh'
    'c3NldElkEhcKB3BhY2tfaWQYAyABKAlSBnBhY2tJZA==');

@$core.Deprecated('Use promoteCanonicalResponseDescriptor instead')
const PromoteCanonicalResponse$json = {
  '1': 'PromoteCanonicalResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
    {'1': 'canonical_pack_id', '3': 2, '4': 1, '5': 9, '10': 'canonicalPackId'},
  ],
};

/// Descriptor for `PromoteCanonicalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List promoteCanonicalResponseDescriptor = $convert.base64Decode(
    'ChhQcm9tb3RlQ2Fub25pY2FsUmVzcG9uc2USNgoFYXNzZXQYASABKAsyIC5jcmVhdGl2YW50YS'
    '5wcm9kdWN0aW9uLnYxLkFzc2V0UgVhc3NldBIqChFjYW5vbmljYWxfcGFja19pZBgCIAEoCVIP'
    'Y2Fub25pY2FsUGFja0lk');

@$core.Deprecated('Use uploadRequestDescriptor instead')
const UploadRequest$json = {
  '1': 'UploadRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'file_name', '3': 2, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'mime_type', '3': 3, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'file_size_bytes', '3': 4, '4': 1, '5': 3, '10': 'fileSizeBytes'},
    {'1': 'file_content', '3': 5, '4': 1, '5': 12, '10': 'fileContent'},
    {'1': 'upload_purpose', '3': 6, '4': 1, '5': 9, '10': 'uploadPurpose'},
  ],
};

/// Descriptor for `UploadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadRequestDescriptor = $convert.base64Decode(
    'Cg1VcGxvYWRSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udj'
    'EuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGwoJZmlsZV9uYW1lGAIgASgJUghmaWxlTmFtZRIb'
    'CgltaW1lX3R5cGUYAyABKAlSCG1pbWVUeXBlEiYKD2ZpbGVfc2l6ZV9ieXRlcxgEIAEoA1INZm'
    'lsZVNpemVCeXRlcxIhCgxmaWxlX2NvbnRlbnQYBSABKAxSC2ZpbGVDb250ZW50EiUKDnVwbG9h'
    'ZF9wdXJwb3NlGAYgASgJUg11cGxvYWRQdXJwb3Nl');

@$core.Deprecated('Use uploadResponseDescriptor instead')
const UploadResponse$json = {
  '1': 'UploadResponse',
  '2': [
    {'1': 'upload_id', '3': 1, '4': 1, '5': 9, '10': 'uploadId'},
    {'1': 'storage_url', '3': 2, '4': 1, '5': 9, '10': 'storageUrl'},
    {'1': 'virus_scan_status', '3': 3, '4': 1, '5': 9, '10': 'virusScanStatus'},
    {
      '1': 'asset',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `UploadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadResponseDescriptor = $convert.base64Decode(
    'Cg5VcGxvYWRSZXNwb25zZRIbCgl1cGxvYWRfaWQYASABKAlSCHVwbG9hZElkEh8KC3N0b3JhZ2'
    'VfdXJsGAIgASgJUgpzdG9yYWdlVXJsEioKEXZpcnVzX3NjYW5fc3RhdHVzGAMgASgJUg92aXJ1'
    'c1NjYW5TdGF0dXMSNgoFYXNzZXQYBCABKAsyIC5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLk'
    'Fzc2V0UgVhc3NldA==');

@$core.Deprecated('Use translationJobDescriptor instead')
const TranslationJob$json = {
  '1': 'TranslationJob',
  '2': [
    {
      '1': 'translation_job_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'translationJobId'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'video_edit_job_id', '3': 3, '4': 1, '5': 9, '10': 'videoEditJobId'},
    {'1': 'source_asset_id', '3': 4, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {'1': 'target_languages', '3': 5, '4': 3, '5': 9, '10': 'targetLanguages'},
    {'1': 'lip_sync_enabled', '3': 6, '4': 1, '5': 8, '10': 'lipSyncEnabled'},
    {
      '1': 'cultural_adaptation_enabled',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'culturalAdaptationEnabled'
    },
    {
      '1': 'translate_captions',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'translateCaptions'
    },
    {
      '1': 'translate_overlays',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'translateOverlays'
    },
    {'1': 'voice_option', '3': 10, '4': 1, '5': 9, '10': 'voiceOption'},
    {'1': 'voice_clone_id', '3': 11, '4': 1, '5': 9, '10': 'voiceCloneId'},
    {
      '1': 'per_language_status',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationJob.PerLanguageStatusEntry',
      '10': 'perLanguageStatus'
    },
    {
      '1': 'output_asset_ids',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationJob.OutputAssetIdsEntry',
      '10': 'outputAssetIds'
    },
    {
      '1': 'total_credits_used',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'totalCreditsUsed'
    },
    {'1': 'status', '3': 15, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'quality_scores',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationJob.QualityScoresEntry',
      '10': 'qualityScores'
    },
    {
      '1': 'repair_notes',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationJob.RepairNotesEntry',
      '10': 'repairNotes'
    },
    {'1': 'quote_id', '3': 18, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'created_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
  '3': [
    TranslationJob_PerLanguageStatusEntry$json,
    TranslationJob_OutputAssetIdsEntry$json,
    TranslationJob_QualityScoresEntry$json,
    TranslationJob_RepairNotesEntry$json
  ],
};

@$core.Deprecated('Use translationJobDescriptor instead')
const TranslationJob_PerLanguageStatusEntry$json = {
  '1': 'PerLanguageStatusEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use translationJobDescriptor instead')
const TranslationJob_OutputAssetIdsEntry$json = {
  '1': 'OutputAssetIdsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use translationJobDescriptor instead')
const TranslationJob_QualityScoresEntry$json = {
  '1': 'QualityScoresEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use translationJobDescriptor instead')
const TranslationJob_RepairNotesEntry$json = {
  '1': 'RepairNotesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TranslationJob`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationJobDescriptor = $convert.base64Decode(
    'Cg5UcmFuc2xhdGlvbkpvYhIsChJ0cmFuc2xhdGlvbl9qb2JfaWQYASABKAlSEHRyYW5zbGF0aW'
    '9uSm9iSWQSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIpChF2aWRlb19lZGl0'
    'X2pvYl9pZBgDIAEoCVIOdmlkZW9FZGl0Sm9iSWQSJgoPc291cmNlX2Fzc2V0X2lkGAQgASgJUg'
    '1zb3VyY2VBc3NldElkEikKEHRhcmdldF9sYW5ndWFnZXMYBSADKAlSD3RhcmdldExhbmd1YWdl'
    'cxIoChBsaXBfc3luY19lbmFibGVkGAYgASgIUg5saXBTeW5jRW5hYmxlZBI+ChtjdWx0dXJhbF'
    '9hZGFwdGF0aW9uX2VuYWJsZWQYByABKAhSGWN1bHR1cmFsQWRhcHRhdGlvbkVuYWJsZWQSLQoS'
    'dHJhbnNsYXRlX2NhcHRpb25zGAggASgIUhF0cmFuc2xhdGVDYXB0aW9ucxItChJ0cmFuc2xhdG'
    'Vfb3ZlcmxheXMYCSABKAhSEXRyYW5zbGF0ZU92ZXJsYXlzEiEKDHZvaWNlX29wdGlvbhgKIAEo'
    'CVILdm9pY2VPcHRpb24SJAoOdm9pY2VfY2xvbmVfaWQYCyABKAlSDHZvaWNlQ2xvbmVJZBJwCh'
    'NwZXJfbGFuZ3VhZ2Vfc3RhdHVzGAwgAygLMkAuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5U'
    'cmFuc2xhdGlvbkpvYi5QZXJMYW5ndWFnZVN0YXR1c0VudHJ5UhFwZXJMYW5ndWFnZVN0YXR1cx'
    'JnChBvdXRwdXRfYXNzZXRfaWRzGA0gAygLMj0uY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5U'
    'cmFuc2xhdGlvbkpvYi5PdXRwdXRBc3NldElkc0VudHJ5Ug5vdXRwdXRBc3NldElkcxIsChJ0b3'
    'RhbF9jcmVkaXRzX3VzZWQYDiABKAlSEHRvdGFsQ3JlZGl0c1VzZWQSFgoGc3RhdHVzGA8gASgJ'
    'UgZzdGF0dXMSYwoOcXVhbGl0eV9zY29yZXMYECADKAsyPC5jcmVhdGl2YW50YS5wcm9kdWN0aW'
    '9uLnYxLlRyYW5zbGF0aW9uSm9iLlF1YWxpdHlTY29yZXNFbnRyeVINcXVhbGl0eVNjb3JlcxJd'
    'CgxyZXBhaXJfbm90ZXMYESADKAsyOi5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlRyYW5zbG'
    'F0aW9uSm9iLlJlcGFpck5vdGVzRW50cnlSC3JlcGFpck5vdGVzEhkKCHF1b3RlX2lkGBIgASgJ'
    'UgdxdW90ZUlkEjkKCmNyZWF0ZWRfYXQYEyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgUIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSCXVwZGF0ZWRBdBpEChZQZXJMYW5ndWFnZVN0YXR1c0VudHJ5EhAKA2tleRgBIAEoCV'
    'IDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAEaQQoTT3V0cHV0QXNzZXRJZHNFbnRyeRIQ'
    'CgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBGkAKElF1YWxpdHlTY2'
    '9yZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgBGj4K'
    'EFJlcGFpck5vdGVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbH'
    'VlOgI4AQ==');

@$core.Deprecated('Use translationSegmentDescriptor instead')
const TranslationSegment$json = {
  '1': 'TranslationSegment',
  '2': [
    {'1': 'segment_id', '3': 1, '4': 1, '5': 9, '10': 'segmentId'},
    {'1': 'start_time_s', '3': 2, '4': 1, '5': 1, '10': 'startTimeS'},
    {'1': 'end_time_s', '3': 3, '4': 1, '5': 1, '10': 'endTimeS'},
    {'1': 'source_text', '3': 4, '4': 1, '5': 9, '10': 'sourceText'},
    {
      '1': 'translations',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationSegment.TranslationsEntry',
      '10': 'translations'
    },
    {'1': 'quality_score', '3': 6, '4': 1, '5': 1, '10': 'qualityScore'},
    {'1': 'needs_repair', '3': 7, '4': 1, '5': 8, '10': 'needsRepair'},
    {'1': 'repair_reason', '3': 8, '4': 1, '5': 9, '10': 'repairReason'},
  ],
  '3': [TranslationSegment_TranslationsEntry$json],
};

@$core.Deprecated('Use translationSegmentDescriptor instead')
const TranslationSegment_TranslationsEntry$json = {
  '1': 'TranslationsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TranslationSegment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationSegmentDescriptor = $convert.base64Decode(
    'ChJUcmFuc2xhdGlvblNlZ21lbnQSHQoKc2VnbWVudF9pZBgBIAEoCVIJc2VnbWVudElkEiAKDH'
    'N0YXJ0X3RpbWVfcxgCIAEoAVIKc3RhcnRUaW1lUxIcCgplbmRfdGltZV9zGAMgASgBUghlbmRU'
    'aW1lUxIfCgtzb3VyY2VfdGV4dBgEIAEoCVIKc291cmNlVGV4dBJjCgx0cmFuc2xhdGlvbnMYBS'
    'ADKAsyPy5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlRyYW5zbGF0aW9uU2VnbWVudC5UcmFu'
    'c2xhdGlvbnNFbnRyeVIMdHJhbnNsYXRpb25zEiMKDXF1YWxpdHlfc2NvcmUYBiABKAFSDHF1YW'
    'xpdHlTY29yZRIhCgxuZWVkc19yZXBhaXIYByABKAhSC25lZWRzUmVwYWlyEiMKDXJlcGFpcl9y'
    'ZWFzb24YCCABKAlSDHJlcGFpclJlYXNvbho/ChFUcmFuc2xhdGlvbnNFbnRyeRIQCgNrZXkYAS'
    'ABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use translationServiceCreateRequestDescriptor instead')
const TranslationServiceCreateRequest$json = {
  '1': 'TranslationServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'source_asset_id', '3': 2, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {'1': 'target_languages', '3': 3, '4': 3, '5': 9, '10': 'targetLanguages'},
    {'1': 'lip_sync_enabled', '3': 4, '4': 1, '5': 8, '10': 'lipSyncEnabled'},
    {
      '1': 'cultural_adaptation_enabled',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'culturalAdaptationEnabled'
    },
    {
      '1': 'translate_captions',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'translateCaptions'
    },
    {
      '1': 'translate_overlays',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'translateOverlays'
    },
    {'1': 'voice_option', '3': 8, '4': 1, '5': 9, '10': 'voiceOption'},
    {'1': 'voice_clone_id', '3': 9, '4': 1, '5': 9, '10': 'voiceCloneId'},
    {'1': 'quote_id', '3': 10, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
    {
      '1': 'custom_script_corrections',
      '3': 12,
      '4': 3,
      '5': 11,
      '6':
          '.creativanta.production.v1.TranslationServiceCreateRequest.CustomScriptCorrectionsEntry',
      '10': 'customScriptCorrections'
    },
  ],
  '3': [TranslationServiceCreateRequest_CustomScriptCorrectionsEntry$json],
};

@$core.Deprecated('Use translationServiceCreateRequestDescriptor instead')
const TranslationServiceCreateRequest_CustomScriptCorrectionsEntry$json = {
  '1': 'CustomScriptCorrectionsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TranslationServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch9UcmFuc2xhdGlvblNlcnZpY2VDcmVhdGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcm'
    'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJgoPc291cmNlX2Fz'
    'c2V0X2lkGAIgASgJUg1zb3VyY2VBc3NldElkEikKEHRhcmdldF9sYW5ndWFnZXMYAyADKAlSD3'
    'RhcmdldExhbmd1YWdlcxIoChBsaXBfc3luY19lbmFibGVkGAQgASgIUg5saXBTeW5jRW5hYmxl'
    'ZBI+ChtjdWx0dXJhbF9hZGFwdGF0aW9uX2VuYWJsZWQYBSABKAhSGWN1bHR1cmFsQWRhcHRhdG'
    'lvbkVuYWJsZWQSLQoSdHJhbnNsYXRlX2NhcHRpb25zGAYgASgIUhF0cmFuc2xhdGVDYXB0aW9u'
    'cxItChJ0cmFuc2xhdGVfb3ZlcmxheXMYByABKAhSEXRyYW5zbGF0ZU92ZXJsYXlzEiEKDHZvaW'
    'NlX29wdGlvbhgIIAEoCVILdm9pY2VPcHRpb24SJAoOdm9pY2VfY2xvbmVfaWQYCSABKAlSDHZv'
    'aWNlQ2xvbmVJZBIZCghxdW90ZV9pZBgKIAEoCVIHcXVvdGVJZBIrChFjb25maXJtZWRfY3JlZG'
    'l0cxgLIAEoCVIQY29uZmlybWVkQ3JlZGl0cxKTAQoZY3VzdG9tX3NjcmlwdF9jb3JyZWN0aW9u'
    'cxgMIAMoCzJXLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuVHJhbnNsYXRpb25TZXJ2aWNlQ3'
    'JlYXRlUmVxdWVzdC5DdXN0b21TY3JpcHRDb3JyZWN0aW9uc0VudHJ5UhdjdXN0b21TY3JpcHRD'
    'b3JyZWN0aW9ucxpKChxDdXN0b21TY3JpcHRDb3JyZWN0aW9uc0VudHJ5EhAKA2tleRgBIAEoCV'
    'IDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use translationServiceCreateResponseDescriptor instead')
const TranslationServiceCreateResponse$json = {
  '1': 'TranslationServiceCreateResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationJob',
      '10': 'job'
    },
    {'1': 'credits_reserved', '3': 2, '4': 1, '5': 9, '10': 'creditsReserved'},
    {
      '1': 'discount_applied_pct',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'discountAppliedPct'
    },
  ],
};

/// Descriptor for `TranslationServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'CiBUcmFuc2xhdGlvblNlcnZpY2VDcmVhdGVSZXNwb25zZRI7CgNqb2IYASABKAsyKS5jcmVhdG'
        'l2YW50YS5wcm9kdWN0aW9uLnYxLlRyYW5zbGF0aW9uSm9iUgNqb2ISKQoQY3JlZGl0c19yZXNl'
        'cnZlZBgCIAEoCVIPY3JlZGl0c1Jlc2VydmVkEjAKFGRpc2NvdW50X2FwcGxpZWRfcGN0GAMgAS'
        'gBUhJkaXNjb3VudEFwcGxpZWRQY3Q=');

@$core.Deprecated('Use translationServiceGetRequestDescriptor instead')
const TranslationServiceGetRequest$json = {
  '1': 'TranslationServiceGetRequest',
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
      '1': 'translation_job_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'translationJobId'
    },
  ],
};

/// Descriptor for `TranslationServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChxUcmFuc2xhdGlvblNlcnZpY2VHZXRSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLm'
        'NyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIsChJ0cmFuc2xhdGlvbl9q'
        'b2JfaWQYAiABKAlSEHRyYW5zbGF0aW9uSm9iSWQ=');

@$core.Deprecated('Use translationServiceGetResponseDescriptor instead')
const TranslationServiceGetResponse$json = {
  '1': 'TranslationServiceGetResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationJob',
      '10': 'job'
    },
    {
      '1': 'output_assets',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'outputAssets'
    },
    {
      '1': 'segments',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationSegment',
      '10': 'segments'
    },
  ],
};

/// Descriptor for `TranslationServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationServiceGetResponseDescriptor = $convert.base64Decode(
    'Ch1UcmFuc2xhdGlvblNlcnZpY2VHZXRSZXNwb25zZRI7CgNqb2IYASABKAsyKS5jcmVhdGl2YW'
    '50YS5wcm9kdWN0aW9uLnYxLlRyYW5zbGF0aW9uSm9iUgNqb2ISRQoNb3V0cHV0X2Fzc2V0cxgC'
    'IAMoCzIgLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuQXNzZXRSDG91dHB1dEFzc2V0cxJJCg'
    'hzZWdtZW50cxgDIAMoCzItLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuVHJhbnNsYXRpb25T'
    'ZWdtZW50UghzZWdtZW50cw==');

@$core.Deprecated('Use translationServiceListRequestDescriptor instead')
const TranslationServiceListRequest$json = {
  '1': 'TranslationServiceListRequest',
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
  ],
};

/// Descriptor for `TranslationServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationServiceListRequestDescriptor =
    $convert.base64Decode(
        'Ch1UcmFuc2xhdGlvblNlcnZpY2VMaXN0UmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy'
        '5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSQQoKcGFnaW5hdGlvbhgC'
        'IAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use translationServiceListResponseDescriptor instead')
const TranslationServiceListResponse$json = {
  '1': 'TranslationServiceListResponse',
  '2': [
    {
      '1': 'jobs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranslationJob',
      '10': 'jobs'
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

/// Descriptor for `TranslationServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationServiceListResponseDescriptor =
    $convert.base64Decode(
        'Ch5UcmFuc2xhdGlvblNlcnZpY2VMaXN0UmVzcG9uc2USPQoEam9icxgBIAMoCzIpLmNyZWF0aX'
        'ZhbnRhLnByb2R1Y3Rpb24udjEuVHJhbnNsYXRpb25Kb2JSBGpvYnMSSAoKcGFnaW5hdGlvbhgC'
        'IAEoCzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcGFnaW5hdG'
        'lvbg==');

@$core.Deprecated('Use soundTrackDescriptor instead')
const SoundTrack$json = {
  '1': 'SoundTrack',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'category', '3': 4, '4': 1, '5': 9, '10': 'category'},
    {'1': 'genre', '3': 5, '4': 1, '5': 9, '10': 'genre'},
    {'1': 'mood', '3': 6, '4': 1, '5': 9, '10': 'mood'},
    {'1': 'bpm', '3': 7, '4': 1, '5': 5, '10': 'bpm'},
    {'1': 'duration_seconds', '3': 8, '4': 1, '5': 1, '10': 'durationSeconds'},
    {'1': 'file_url', '3': 9, '4': 1, '5': 9, '10': 'fileUrl'},
    {'1': 'license_type', '3': 10, '4': 1, '5': 9, '10': 'licenseType'},
    {'1': 'license_id', '3': 11, '4': 1, '5': 9, '10': 'licenseId'},
    {
      '1': 'is_verified_license',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'isVerifiedLicense'
    },
    {'1': 'waveform_peaks', '3': 13, '4': 3, '5': 2, '10': 'waveformPeaks'},
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

/// Descriptor for `SoundTrack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundTrackDescriptor = $convert.base64Decode(
    'CgpTb3VuZFRyYWNrEhkKCHRyYWNrX2lkGAEgASgJUgd0cmFja0lkEiEKDHdvcmtzcGFjZV9pZB'
    'gCIAEoCVILd29ya3NwYWNlSWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEhoKCGNhdGVnb3J5GAQg'
    'ASgJUghjYXRlZ29yeRIUCgVnZW5yZRgFIAEoCVIFZ2VucmUSEgoEbW9vZBgGIAEoCVIEbW9vZB'
    'IQCgNicG0YByABKAVSA2JwbRIpChBkdXJhdGlvbl9zZWNvbmRzGAggASgBUg9kdXJhdGlvblNl'
    'Y29uZHMSGQoIZmlsZV91cmwYCSABKAlSB2ZpbGVVcmwSIQoMbGljZW5zZV90eXBlGAogASgJUg'
    'tsaWNlbnNlVHlwZRIdCgpsaWNlbnNlX2lkGAsgASgJUglsaWNlbnNlSWQSLgoTaXNfdmVyaWZp'
    'ZWRfbGljZW5zZRgMIAEoCFIRaXNWZXJpZmllZExpY2Vuc2USJQoOd2F2ZWZvcm1fcGVha3MYDS'
    'ADKAJSDXdhdmVmb3JtUGVha3MSOQoKY3JlYXRlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core
    .Deprecated('Use soundStudioServiceGenerateMusicRequestDescriptor instead')
const SoundStudioServiceGenerateMusicRequest$json = {
  '1': 'SoundStudioServiceGenerateMusicRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'prompt', '3': 2, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'genre', '3': 3, '4': 1, '5': 9, '10': 'genre'},
    {'1': 'mood', '3': 4, '4': 1, '5': 9, '10': 'mood'},
    {'1': 'bpm', '3': 5, '4': 1, '5': 5, '10': 'bpm'},
    {'1': 'duration_seconds', '3': 6, '4': 1, '5': 5, '10': 'durationSeconds'},
    {'1': 'license_type', '3': 7, '4': 1, '5': 9, '10': 'licenseType'},
    {'1': 'quote_id', '3': 8, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
  ],
};

/// Descriptor for `SoundStudioServiceGenerateMusicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServiceGenerateMusicRequestDescriptor = $convert.base64Decode(
    'CiZTb3VuZFN0dWRpb1NlcnZpY2VHZW5lcmF0ZU11c2ljUmVxdWVzdBI/Cgdjb250ZXh0GAEgAS'
    'gLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhYKBnBy'
    'b21wdBgCIAEoCVIGcHJvbXB0EhQKBWdlbnJlGAMgASgJUgVnZW5yZRISCgRtb29kGAQgASgJUg'
    'Rtb29kEhAKA2JwbRgFIAEoBVIDYnBtEikKEGR1cmF0aW9uX3NlY29uZHMYBiABKAVSD2R1cmF0'
    'aW9uU2Vjb25kcxIhCgxsaWNlbnNlX3R5cGUYByABKAlSC2xpY2Vuc2VUeXBlEhkKCHF1b3RlX2'
    'lkGAggASgJUgdxdW90ZUlkEisKEWNvbmZpcm1lZF9jcmVkaXRzGAkgASgJUhBjb25maXJtZWRD'
    'cmVkaXRz');

@$core
    .Deprecated('Use soundStudioServiceGenerateMusicResponseDescriptor instead')
const SoundStudioServiceGenerateMusicResponse$json = {
  '1': 'SoundStudioServiceGenerateMusicResponse',
  '2': [
    {
      '1': 'track',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.SoundTrack',
      '10': 'track'
    },
    {
      '1': 'asset',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
    {'1': 'credits_deducted', '3': 3, '4': 1, '5': 9, '10': 'creditsDeducted'},
  ],
};

/// Descriptor for `SoundStudioServiceGenerateMusicResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServiceGenerateMusicResponseDescriptor =
    $convert.base64Decode(
        'CidTb3VuZFN0dWRpb1NlcnZpY2VHZW5lcmF0ZU11c2ljUmVzcG9uc2USOwoFdHJhY2sYASABKA'
        'syJS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlNvdW5kVHJhY2tSBXRyYWNrEjYKBWFzc2V0'
        'GAIgASgLMiAuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5Bc3NldFIFYXNzZXQSKQoQY3JlZG'
        'l0c19kZWR1Y3RlZBgDIAEoCVIPY3JlZGl0c0RlZHVjdGVk');

@$core.Deprecated('Use soundStudioServiceGenerateSFXRequestDescriptor instead')
const SoundStudioServiceGenerateSFXRequest$json = {
  '1': 'SoundStudioServiceGenerateSFXRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'prompt', '3': 2, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
    {'1': 'duration_seconds', '3': 4, '4': 1, '5': 1, '10': 'durationSeconds'},
    {'1': 'quote_id', '3': 5, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
  ],
};

/// Descriptor for `SoundStudioServiceGenerateSFXRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServiceGenerateSFXRequestDescriptor =
    $convert.base64Decode(
        'CiRTb3VuZFN0dWRpb1NlcnZpY2VHZW5lcmF0ZVNGWFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCz'
        'IlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIWCgZwcm9t'
        'cHQYAiABKAlSBnByb21wdBIaCghjYXRlZ29yeRgDIAEoCVIIY2F0ZWdvcnkSKQoQZHVyYXRpb2'
        '5fc2Vjb25kcxgEIAEoAVIPZHVyYXRpb25TZWNvbmRzEhkKCHF1b3RlX2lkGAUgASgJUgdxdW90'
        'ZUlkEisKEWNvbmZpcm1lZF9jcmVkaXRzGAYgASgJUhBjb25maXJtZWRDcmVkaXRz');

@$core.Deprecated('Use soundStudioServiceGenerateSFXResponseDescriptor instead')
const SoundStudioServiceGenerateSFXResponse$json = {
  '1': 'SoundStudioServiceGenerateSFXResponse',
  '2': [
    {
      '1': 'track',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.SoundTrack',
      '10': 'track'
    },
    {
      '1': 'asset',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
    {'1': 'credits_deducted', '3': 3, '4': 1, '5': 9, '10': 'creditsDeducted'},
  ],
};

/// Descriptor for `SoundStudioServiceGenerateSFXResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServiceGenerateSFXResponseDescriptor =
    $convert.base64Decode(
        'CiVTb3VuZFN0dWRpb1NlcnZpY2VHZW5lcmF0ZVNGWFJlc3BvbnNlEjsKBXRyYWNrGAEgASgLMi'
        'UuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5Tb3VuZFRyYWNrUgV0cmFjaxI2CgVhc3NldBgC'
        'IAEoCzIgLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuQXNzZXRSBWFzc2V0EikKEGNyZWRpdH'
        'NfZGVkdWN0ZWQYAyABKAlSD2NyZWRpdHNEZWR1Y3RlZA==');

@$core.Deprecated('Use soundStudioServiceAnalyzeBeatRequestDescriptor instead')
const SoundStudioServiceAnalyzeBeatRequest$json = {
  '1': 'SoundStudioServiceAnalyzeBeatRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'audio_asset_id', '3': 2, '4': 1, '5': 9, '10': 'audioAssetId'},
    {'1': 'audio_url', '3': 3, '4': 1, '5': 9, '10': 'audioUrl'},
  ],
};

/// Descriptor for `SoundStudioServiceAnalyzeBeatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServiceAnalyzeBeatRequestDescriptor =
    $convert.base64Decode(
        'CiRTb3VuZFN0dWRpb1NlcnZpY2VBbmFseXplQmVhdFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGA'
        'EgASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEiQKDmF1ZGlv'
        'X2Fzc2V0X2lkGAIgASgJUgxhdWRpb0Fzc2V0SWQSGwoJYXVkaW9fdXJsGAMgASgJUghhdWRpb1'
        'VybA==');

@$core.Deprecated('Use soundStudioServiceAnalyzeBeatResponseDescriptor instead')
const SoundStudioServiceAnalyzeBeatResponse$json = {
  '1': 'SoundStudioServiceAnalyzeBeatResponse',
  '2': [
    {'1': 'bpm', '3': 1, '4': 1, '5': 1, '10': 'bpm'},
    {
      '1': 'beat_timestamps_ms',
      '3': 2,
      '4': 3,
      '5': 3,
      '10': 'beatTimestampsMs'
    },
    {
      '1': 'downbeat_timestamps_ms',
      '3': 3,
      '4': 3,
      '5': 3,
      '10': 'downbeatTimestampsMs'
    },
    {'1': 'tempo_confidence', '3': 4, '4': 1, '5': 1, '10': 'tempoConfidence'},
    {
      '1': 'suggested_cut_points_ms',
      '3': 5,
      '4': 3,
      '5': 3,
      '10': 'suggestedCutPointsMs'
    },
  ],
};

/// Descriptor for `SoundStudioServiceAnalyzeBeatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServiceAnalyzeBeatResponseDescriptor =
    $convert.base64Decode(
        'CiVTb3VuZFN0dWRpb1NlcnZpY2VBbmFseXplQmVhdFJlc3BvbnNlEhAKA2JwbRgBIAEoAVIDYn'
        'BtEiwKEmJlYXRfdGltZXN0YW1wc19tcxgCIAMoA1IQYmVhdFRpbWVzdGFtcHNNcxI0ChZkb3du'
        'YmVhdF90aW1lc3RhbXBzX21zGAMgAygDUhRkb3duYmVhdFRpbWVzdGFtcHNNcxIpChB0ZW1wb1'
        '9jb25maWRlbmNlGAQgASgBUg90ZW1wb0NvbmZpZGVuY2USNQoXc3VnZ2VzdGVkX2N1dF9wb2lu'
        'dHNfbXMYBSADKANSFHN1Z2dlc3RlZEN1dFBvaW50c01z');

@$core.Deprecated(
    'Use soundStudioServiceListSoundLibraryRequestDescriptor instead')
const SoundStudioServiceListSoundLibraryRequest$json = {
  '1': 'SoundStudioServiceListSoundLibraryRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
    {'1': 'genre', '3': 3, '4': 1, '5': 9, '10': 'genre'},
    {'1': 'mood', '3': 4, '4': 1, '5': 9, '10': 'mood'},
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

/// Descriptor for `SoundStudioServiceListSoundLibraryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    soundStudioServiceListSoundLibraryRequestDescriptor = $convert.base64Decode(
        'CilTb3VuZFN0dWRpb1NlcnZpY2VMaXN0U291bmRMaWJyYXJ5UmVxdWVzdBI+Cgx3b3Jrc3BhY2'
        'VfaWQYASABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSGgoI'
        'Y2F0ZWdvcnkYAiABKAlSCGNhdGVnb3J5EhQKBWdlbnJlGAMgASgJUgVnZW5yZRISCgRtb29kGA'
        'QgASgJUgRtb29kEkEKCnBhZ2luYXRpb24YBSABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEu'
        'UGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated(
    'Use soundStudioServiceListSoundLibraryResponseDescriptor instead')
const SoundStudioServiceListSoundLibraryResponse$json = {
  '1': 'SoundStudioServiceListSoundLibraryResponse',
  '2': [
    {
      '1': 'tracks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.SoundTrack',
      '10': 'tracks'
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

/// Descriptor for `SoundStudioServiceListSoundLibraryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    soundStudioServiceListSoundLibraryResponseDescriptor =
    $convert.base64Decode(
        'CipTb3VuZFN0dWRpb1NlcnZpY2VMaXN0U291bmRMaWJyYXJ5UmVzcG9uc2USPQoGdHJhY2tzGA'
        'EgAygLMiUuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5Tb3VuZFRyYWNrUgZ0cmFja3MSSAoK'
        'cGFnaW5hdGlvbhgCIAEoCzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb2'
        '5zZVIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use soundStudioServiceGetSoundRequestDescriptor instead')
const SoundStudioServiceGetSoundRequest$json = {
  '1': 'SoundStudioServiceGetSoundRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `SoundStudioServiceGetSoundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServiceGetSoundRequestDescriptor =
    $convert.base64Decode(
        'CiFTb3VuZFN0dWRpb1NlcnZpY2VHZXRTb3VuZFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgAS'
        'gLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEhkKCGFzc2V0X2lk'
        'GAIgASgJUgdhc3NldElk');

@$core.Deprecated('Use soundStudioServiceGetSoundResponseDescriptor instead')
const SoundStudioServiceGetSoundResponse$json = {
  '1': 'SoundStudioServiceGetSoundResponse',
  '2': [
    {
      '1': 'track',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.SoundTrack',
      '10': 'track'
    },
  ],
};

/// Descriptor for `SoundStudioServiceGetSoundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServiceGetSoundResponseDescriptor =
    $convert.base64Decode(
        'CiJTb3VuZFN0dWRpb1NlcnZpY2VHZXRTb3VuZFJlc3BvbnNlEjsKBXRyYWNrGAEgASgLMiUuY3'
        'JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5Tb3VuZFRyYWNrUgV0cmFjaw==');

@$core.Deprecated('Use soundStudioServicePreviewSoundRequestDescriptor instead')
const SoundStudioServicePreviewSoundRequest$json = {
  '1': 'SoundStudioServicePreviewSoundRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'track_id', '3': 2, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'preview_start_ms', '3': 3, '4': 1, '5': 5, '10': 'previewStartMs'},
    {
      '1': 'preview_duration_ms',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'previewDurationMs'
    },
  ],
};

/// Descriptor for `SoundStudioServicePreviewSoundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServicePreviewSoundRequestDescriptor =
    $convert.base64Decode(
        'CiVTb3VuZFN0dWRpb1NlcnZpY2VQcmV2aWV3U291bmRSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZB'
        'gBIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIZCgh0cmFj'
        'a19pZBgCIAEoCVIHdHJhY2tJZBIoChBwcmV2aWV3X3N0YXJ0X21zGAMgASgFUg5wcmV2aWV3U3'
        'RhcnRNcxIuChNwcmV2aWV3X2R1cmF0aW9uX21zGAQgASgFUhFwcmV2aWV3RHVyYXRpb25Ncw==');

@$core
    .Deprecated('Use soundStudioServicePreviewSoundResponseDescriptor instead')
const SoundStudioServicePreviewSoundResponse$json = {
  '1': 'SoundStudioServicePreviewSoundResponse',
  '2': [
    {'1': 'preview_url', '3': 1, '4': 1, '5': 9, '10': 'previewUrl'},
    {'1': 'waveform_peaks', '3': 2, '4': 3, '5': 2, '10': 'waveformPeaks'},
    {'1': 'is_free', '3': 3, '4': 1, '5': 8, '10': 'isFree'},
  ],
};

/// Descriptor for `SoundStudioServicePreviewSoundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List soundStudioServicePreviewSoundResponseDescriptor =
    $convert.base64Decode(
        'CiZTb3VuZFN0dWRpb1NlcnZpY2VQcmV2aWV3U291bmRSZXNwb25zZRIfCgtwcmV2aWV3X3VybB'
        'gBIAEoCVIKcHJldmlld1VybBIlCg53YXZlZm9ybV9wZWFrcxgCIAMoAlINd2F2ZWZvcm1QZWFr'
        'cxIXCgdpc19mcmVlGAMgASgIUgZpc0ZyZWU=');

@$core.Deprecated('Use voiceCloneRecordDescriptor instead')
const VoiceCloneRecord$json = {
  '1': 'VoiceCloneRecord',
  '2': [
    {'1': 'voice_clone_id', '3': 1, '4': 1, '5': 9, '10': 'voiceCloneId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'character_id', '3': 3, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'provider', '3': 4, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'provider_voice_id', '3': 5, '4': 1, '5': 9, '10': 'providerVoiceId'},
    {'1': 'voice_name', '3': 6, '4': 1, '5': 9, '10': 'voiceName'},
    {'1': 'sample_audio_urls', '3': 7, '4': 3, '5': 9, '10': 'sampleAudioUrls'},
    {'1': 'clone_status', '3': 8, '4': 1, '5': 9, '10': 'cloneStatus'},
    {'1': 'consent_record_id', '3': 9, '4': 1, '5': 9, '10': 'consentRecordId'},
    {'1': 'quality_score', '3': 10, '4': 1, '5': 1, '10': 'qualityScore'},
    {'1': 'repair_applied', '3': 11, '4': 1, '5': 8, '10': 'repairApplied'},
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

/// Descriptor for `VoiceCloneRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneRecordDescriptor = $convert.base64Decode(
    'ChBWb2ljZUNsb25lUmVjb3JkEiQKDnZvaWNlX2Nsb25lX2lkGAEgASgJUgx2b2ljZUNsb25lSW'
    'QSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIhCgxjaGFyYWN0ZXJfaWQYAyAB'
    'KAlSC2NoYXJhY3RlcklkEhoKCHByb3ZpZGVyGAQgASgJUghwcm92aWRlchIqChFwcm92aWRlcl'
    '92b2ljZV9pZBgFIAEoCVIPcHJvdmlkZXJWb2ljZUlkEh0KCnZvaWNlX25hbWUYBiABKAlSCXZv'
    'aWNlTmFtZRIqChFzYW1wbGVfYXVkaW9fdXJscxgHIAMoCVIPc2FtcGxlQXVkaW9VcmxzEiEKDG'
    'Nsb25lX3N0YXR1cxgIIAEoCVILY2xvbmVTdGF0dXMSKgoRY29uc2VudF9yZWNvcmRfaWQYCSAB'
    'KAlSD2NvbnNlbnRSZWNvcmRJZBIjCg1xdWFsaXR5X3Njb3JlGAogASgBUgxxdWFsaXR5U2Nvcm'
    'USJQoOcmVwYWlyX2FwcGxpZWQYCyABKAhSDXJlcGFpckFwcGxpZWQSOQoKY3JlYXRlZF9hdBgM'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2'
    'F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use voiceCloneServiceCreateRequestDescriptor instead')
const VoiceCloneServiceCreateRequest$json = {
  '1': 'VoiceCloneServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'character_id', '3': 2, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'sample_audio_urls', '3': 4, '4': 3, '5': 9, '10': 'sampleAudioUrls'},
    {
      '1': 'consent_confirmed',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'consentConfirmed'
    },
    {'1': 'consent_record_id', '3': 6, '4': 1, '5': 9, '10': 'consentRecordId'},
    {'1': 'language', '3': 7, '4': 1, '5': 9, '10': 'language'},
    {'1': 'quote_id', '3': 8, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
  ],
};

/// Descriptor for `VoiceCloneServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch5Wb2ljZUNsb25lU2VydmljZUNyZWF0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
    'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgxjaGFyYWN0ZXJf'
    'aWQYAiABKAlSC2NoYXJhY3RlcklkEhIKBG5hbWUYAyABKAlSBG5hbWUSKgoRc2FtcGxlX2F1ZG'
    'lvX3VybHMYBCADKAlSD3NhbXBsZUF1ZGlvVXJscxIrChFjb25zZW50X2NvbmZpcm1lZBgFIAEo'
    'CFIQY29uc2VudENvbmZpcm1lZBIqChFjb25zZW50X3JlY29yZF9pZBgGIAEoCVIPY29uc2VudF'
    'JlY29yZElkEhoKCGxhbmd1YWdlGAcgASgJUghsYW5ndWFnZRIZCghxdW90ZV9pZBgIIAEoCVIH'
    'cXVvdGVJZBIrChFjb25maXJtZWRfY3JlZGl0cxgJIAEoCVIQY29uZmlybWVkQ3JlZGl0cw==');

@$core.Deprecated('Use voiceCloneServiceCreateResponseDescriptor instead')
const VoiceCloneServiceCreateResponse$json = {
  '1': 'VoiceCloneServiceCreateResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.VoiceCloneRecord',
      '10': 'record'
    },
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'estimated_duration_s',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'estimatedDurationS'
    },
    {'1': 'credits_reserved', '3': 4, '4': 1, '5': 9, '10': 'creditsReserved'},
    {'1': 'consent_status', '3': 5, '4': 1, '5': 9, '10': 'consentStatus'},
  ],
};

/// Descriptor for `VoiceCloneServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceCreateResponseDescriptor = $convert.base64Decode(
    'Ch9Wb2ljZUNsb25lU2VydmljZUNyZWF0ZVJlc3BvbnNlEkMKBnJlY29yZBgBIAEoCzIrLmNyZW'
    'F0aXZhbnRhLnByb2R1Y3Rpb24udjEuVm9pY2VDbG9uZVJlY29yZFIGcmVjb3JkEhYKBnN0YXR1'
    'cxgCIAEoCVIGc3RhdHVzEjAKFGVzdGltYXRlZF9kdXJhdGlvbl9zGAMgASgFUhJlc3RpbWF0ZW'
    'REdXJhdGlvblMSKQoQY3JlZGl0c19yZXNlcnZlZBgEIAEoCVIPY3JlZGl0c1Jlc2VydmVkEiUK'
    'DmNvbnNlbnRfc3RhdHVzGAUgASgJUg1jb25zZW50U3RhdHVz');

@$core.Deprecated('Use voiceCloneServiceGetRequestDescriptor instead')
const VoiceCloneServiceGetRequest$json = {
  '1': 'VoiceCloneServiceGetRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'voice_clone_id', '3': 2, '4': 1, '5': 9, '10': 'voiceCloneId'},
  ],
};

/// Descriptor for `VoiceCloneServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChtWb2ljZUNsb25lU2VydmljZUdldFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEiQKDnZvaWNlX2Nsb25lX2lk'
        'GAIgASgJUgx2b2ljZUNsb25lSWQ=');

@$core.Deprecated('Use voiceCloneServiceGetResponseDescriptor instead')
const VoiceCloneServiceGetResponse$json = {
  '1': 'VoiceCloneServiceGetResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.VoiceCloneRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `VoiceCloneServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChxWb2ljZUNsb25lU2VydmljZUdldFJlc3BvbnNlEkMKBnJlY29yZBgBIAEoCzIrLmNyZWF0aX'
        'ZhbnRhLnByb2R1Y3Rpb24udjEuVm9pY2VDbG9uZVJlY29yZFIGcmVjb3Jk');

@$core.Deprecated('Use voiceCloneServiceListRequestDescriptor instead')
const VoiceCloneServiceListRequest$json = {
  '1': 'VoiceCloneServiceListRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'character_id', '3': 2, '4': 1, '5': 9, '10': 'characterId'},
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

/// Descriptor for `VoiceCloneServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceListRequestDescriptor = $convert.base64Decode(
    'ChxWb2ljZUNsb25lU2VydmljZUxpc3RSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLm'
    'NyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIhCgxjaGFyYWN0ZXJfaWQY'
    'AiABKAlSC2NoYXJhY3RlcklkEkEKCnBhZ2luYXRpb24YAyABKAsyIS5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuUGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use voiceCloneServiceListResponseDescriptor instead')
const VoiceCloneServiceListResponse$json = {
  '1': 'VoiceCloneServiceListResponse',
  '2': [
    {
      '1': 'records',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.VoiceCloneRecord',
      '10': 'records'
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

/// Descriptor for `VoiceCloneServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceListResponseDescriptor = $convert.base64Decode(
    'Ch1Wb2ljZUNsb25lU2VydmljZUxpc3RSZXNwb25zZRJFCgdyZWNvcmRzGAEgAygLMisuY3JlYX'
    'RpdmFudGEucHJvZHVjdGlvbi52MS5Wb2ljZUNsb25lUmVjb3JkUgdyZWNvcmRzEkgKCnBhZ2lu'
    'YXRpb24YAiABKAsyKC5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCn'
    'BhZ2luYXRpb24=');

@$core.Deprecated('Use voiceCloneServiceDeleteRequestDescriptor instead')
const VoiceCloneServiceDeleteRequest$json = {
  '1': 'VoiceCloneServiceDeleteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'voice_clone_id', '3': 2, '4': 1, '5': 9, '10': 'voiceCloneId'},
    {'1': 'revoke_consent', '3': 3, '4': 1, '5': 8, '10': 'revokeConsent'},
  ],
};

/// Descriptor for `VoiceCloneServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceDeleteRequestDescriptor =
    $convert.base64Decode(
        'Ch5Wb2ljZUNsb25lU2VydmljZURlbGV0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
        'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIkCg52b2ljZV9jbG9u'
        'ZV9pZBgCIAEoCVIMdm9pY2VDbG9uZUlkEiUKDnJldm9rZV9jb25zZW50GAMgASgIUg1yZXZva2'
        'VDb25zZW50');

@$core.Deprecated('Use voiceCloneServiceDeleteResponseDescriptor instead')
const VoiceCloneServiceDeleteResponse$json = {
  '1': 'VoiceCloneServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'consent_revoked', '3': 3, '4': 1, '5': 8, '10': 'consentRevoked'},
  ],
};

/// Descriptor for `VoiceCloneServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'Ch9Wb2ljZUNsb25lU2VydmljZURlbGV0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2'
        'Nlc3MSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRInCg9jb25zZW50X3Jldm9rZWQYAyABKAhS'
        'DmNvbnNlbnRSZXZva2Vk');

@$core.Deprecated(
    'Use voiceCloneServiceGenerateVoiceoverRequestDescriptor instead')
const VoiceCloneServiceGenerateVoiceoverRequest$json = {
  '1': 'VoiceCloneServiceGenerateVoiceoverRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'voice_clone_id', '3': 2, '4': 1, '5': 9, '10': 'voiceCloneId'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'language', '3': 4, '4': 1, '5': 9, '10': 'language'},
    {'1': 'speed', '3': 5, '4': 1, '5': 1, '10': 'speed'},
    {'1': 'pitch', '3': 6, '4': 1, '5': 1, '10': 'pitch'},
    {'1': 'quote_id', '3': 7, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
  ],
};

/// Descriptor for `VoiceCloneServiceGenerateVoiceoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    voiceCloneServiceGenerateVoiceoverRequestDescriptor = $convert.base64Decode(
        'CilWb2ljZUNsb25lU2VydmljZUdlbmVyYXRlVm9pY2VvdmVyUmVxdWVzdBI/Cgdjb250ZXh0GA'
        'EgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiQK'
        'DnZvaWNlX2Nsb25lX2lkGAIgASgJUgx2b2ljZUNsb25lSWQSEgoEdGV4dBgDIAEoCVIEdGV4dB'
        'IaCghsYW5ndWFnZRgEIAEoCVIIbGFuZ3VhZ2USFAoFc3BlZWQYBSABKAFSBXNwZWVkEhQKBXBp'
        'dGNoGAYgASgBUgVwaXRjaBIZCghxdW90ZV9pZBgHIAEoCVIHcXVvdGVJZBIrChFjb25maXJtZW'
        'RfY3JlZGl0cxgIIAEoCVIQY29uZmlybWVkQ3JlZGl0cw==');

@$core.Deprecated(
    'Use voiceCloneServiceGenerateVoiceoverResponseDescriptor instead')
const VoiceCloneServiceGenerateVoiceoverResponse$json = {
  '1': 'VoiceCloneServiceGenerateVoiceoverResponse',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'audio_url', '3': 2, '4': 1, '5': 9, '10': 'audioUrl'},
    {'1': 'duration_seconds', '3': 3, '4': 1, '5': 1, '10': 'durationSeconds'},
    {'1': 'credits_used', '3': 4, '4': 1, '5': 9, '10': 'creditsUsed'},
  ],
};

/// Descriptor for `VoiceCloneServiceGenerateVoiceoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    voiceCloneServiceGenerateVoiceoverResponseDescriptor =
    $convert.base64Decode(
        'CipWb2ljZUNsb25lU2VydmljZUdlbmVyYXRlVm9pY2VvdmVyUmVzcG9uc2USGQoIYXNzZXRfaW'
        'QYASABKAlSB2Fzc2V0SWQSGwoJYXVkaW9fdXJsGAIgASgJUghhdWRpb1VybBIpChBkdXJhdGlv'
        'bl9zZWNvbmRzGAMgASgBUg9kdXJhdGlvblNlY29uZHMSIQoMY3JlZGl0c191c2VkGAQgASgJUg'
        'tjcmVkaXRzVXNlZA==');

@$core.Deprecated(
    'Use voiceCloneServiceGetConsentStatusRequestDescriptor instead')
const VoiceCloneServiceGetConsentStatusRequest$json = {
  '1': 'VoiceCloneServiceGetConsentStatusRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'voice_clone_id', '3': 2, '4': 1, '5': 9, '10': 'voiceCloneId'},
    {'1': 'character_id', '3': 3, '4': 1, '5': 9, '10': 'characterId'},
  ],
};

/// Descriptor for `VoiceCloneServiceGetConsentStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceGetConsentStatusRequestDescriptor =
    $convert.base64Decode(
        'CihWb2ljZUNsb25lU2VydmljZUdldENvbnNlbnRTdGF0dXNSZXF1ZXN0Ej4KDHdvcmtzcGFjZV'
        '9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIkCg52'
        'b2ljZV9jbG9uZV9pZBgCIAEoCVIMdm9pY2VDbG9uZUlkEiEKDGNoYXJhY3Rlcl9pZBgDIAEoCV'
        'ILY2hhcmFjdGVySWQ=');

@$core.Deprecated(
    'Use voiceCloneServiceGetConsentStatusResponseDescriptor instead')
const VoiceCloneServiceGetConsentStatusResponse$json = {
  '1': 'VoiceCloneServiceGetConsentStatusResponse',
  '2': [
    {'1': 'consent_record_id', '3': 1, '4': 1, '5': 9, '10': 'consentRecordId'},
    {'1': 'consent_status', '3': 2, '4': 1, '5': 9, '10': 'consentStatus'},
    {
      '1': 'granted_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'grantedAt'
    },
    {
      '1': 'revoked_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'revokedAt'
    },
    {'1': 'declaration_text', '3': 5, '4': 1, '5': 9, '10': 'declarationText'},
    {
      '1': 'is_valid_for_generation',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'isValidForGeneration'
    },
  ],
};

/// Descriptor for `VoiceCloneServiceGetConsentStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voiceCloneServiceGetConsentStatusResponseDescriptor = $convert.base64Decode(
    'CilWb2ljZUNsb25lU2VydmljZUdldENvbnNlbnRTdGF0dXNSZXNwb25zZRIqChFjb25zZW50X3'
    'JlY29yZF9pZBgBIAEoCVIPY29uc2VudFJlY29yZElkEiUKDmNvbnNlbnRfc3RhdHVzGAIgASgJ'
    'Ug1jb25zZW50U3RhdHVzEjkKCmdyYW50ZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUglncmFudGVkQXQSOQoKcmV2b2tlZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCXJldm9rZWRBdBIpChBkZWNsYXJhdGlvbl90ZXh0GAUgASgJUg9kZWNsYX'
    'JhdGlvblRleHQSNQoXaXNfdmFsaWRfZm9yX2dlbmVyYXRpb24YBiABKAhSFGlzVmFsaWRGb3JH'
    'ZW5lcmF0aW9u');

@$core.Deprecated('Use creativeDnaDescriptor instead')
const CreativeDna$json = {
  '1': 'CreativeDna',
  '2': [
    {'1': 'scene_count', '3': 1, '4': 1, '5': 5, '10': 'sceneCount'},
    {'1': 'hook_type', '3': 2, '4': 1, '5': 9, '10': 'hookType'},
    {
      '1': 'content_structure_json',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'contentStructureJson'
    },
    {
      '1': 'pacing_profile_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'pacingProfileJson'
    },
    {'1': 'visual_style_json', '3': 5, '4': 1, '5': 9, '10': 'visualStyleJson'},
    {
      '1': 'audio_profile_json',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'audioProfileJson'
    },
    {
      '1': 'transition_map_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'transitionMapJson'
    },
    {
      '1': 'total_duration_seconds',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'totalDurationSeconds'
    },
    {
      '1': 'engagement_structure_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'engagementStructureJson'
    },
  ],
};

/// Descriptor for `CreativeDna`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creativeDnaDescriptor = $convert.base64Decode(
    'CgtDcmVhdGl2ZURuYRIfCgtzY2VuZV9jb3VudBgBIAEoBVIKc2NlbmVDb3VudBIbCglob29rX3'
    'R5cGUYAiABKAlSCGhvb2tUeXBlEjQKFmNvbnRlbnRfc3RydWN0dXJlX2pzb24YAyABKAlSFGNv'
    'bnRlbnRTdHJ1Y3R1cmVKc29uEi4KE3BhY2luZ19wcm9maWxlX2pzb24YBCABKAlSEXBhY2luZ1'
    'Byb2ZpbGVKc29uEioKEXZpc3VhbF9zdHlsZV9qc29uGAUgASgJUg92aXN1YWxTdHlsZUpzb24S'
    'LAoSYXVkaW9fcHJvZmlsZV9qc29uGAYgASgJUhBhdWRpb1Byb2ZpbGVKc29uEi4KE3RyYW5zaX'
    'Rpb25fbWFwX2pzb24YByABKAlSEXRyYW5zaXRpb25NYXBKc29uEjQKFnRvdGFsX2R1cmF0aW9u'
    'X3NlY29uZHMYCCABKAFSFHRvdGFsRHVyYXRpb25TZWNvbmRzEjoKGWVuZ2FnZW1lbnRfc3RydW'
    'N0dXJlX2pzb24YCSABKAlSF2VuZ2FnZW1lbnRTdHJ1Y3R1cmVKc29u');

@$core.Deprecated('Use remixBlueprintDescriptor instead')
const RemixBlueprint$json = {
  '1': 'RemixBlueprint',
  '2': [
    {'1': 'blueprint_id', '3': 1, '4': 1, '5': 9, '10': 'blueprintId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'reference_asset_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'referenceAssetId'
    },
    {'1': 'reference_url', '3': 4, '4': 1, '5': 9, '10': 'referenceUrl'},
    {'1': 'output_asset_id', '3': 5, '4': 1, '5': 9, '10': 'outputAssetId'},
    {'1': 'video_edit_job_id', '3': 6, '4': 1, '5': 9, '10': 'videoEditJobId'},
    {
      '1': 'creative_dna',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.CreativeDna',
      '10': 'creativeDna'
    },
    {'1': 'remix_script', '3': 8, '4': 1, '5': 9, '10': 'remixScript'},
    {
      '1': 'fidelity_level',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.FidelityLevel',
      '10': 'fidelityLevel'
    },
    {
      '1': 'originality_score',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'originalityScore'
    },
    {
      '1': 'similarity_percentage',
      '3': 11,
      '4': 1,
      '5': 1,
      '10': 'similarityPercentage'
    },
    {
      '1': 'status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.RemixStatus',
      '10': 'status'
    },
    {'1': 'rejection_reason', '3': 13, '4': 1, '5': 9, '10': 'rejectionReason'},
    {'1': 'error_message', '3': 14, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'created_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RemixBlueprint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixBlueprintDescriptor = $convert.base64Decode(
    'Cg5SZW1peEJsdWVwcmludBIhCgxibHVlcHJpbnRfaWQYASABKAlSC2JsdWVwcmludElkEiEKDH'
    'dvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSLAoScmVmZXJlbmNlX2Fzc2V0X2lkGAMg'
    'ASgJUhByZWZlcmVuY2VBc3NldElkEiMKDXJlZmVyZW5jZV91cmwYBCABKAlSDHJlZmVyZW5jZV'
    'VybBImCg9vdXRwdXRfYXNzZXRfaWQYBSABKAlSDW91dHB1dEFzc2V0SWQSKQoRdmlkZW9fZWRp'
    'dF9qb2JfaWQYBiABKAlSDnZpZGVvRWRpdEpvYklkEkkKDGNyZWF0aXZlX2RuYRgHIAEoCzImLm'
    'NyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuQ3JlYXRpdmVEbmFSC2NyZWF0aXZlRG5hEiEKDHJl'
    'bWl4X3NjcmlwdBgIIAEoCVILcmVtaXhTY3JpcHQSTwoOZmlkZWxpdHlfbGV2ZWwYCSABKA4yKC'
    '5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkZpZGVsaXR5TGV2ZWxSDWZpZGVsaXR5TGV2ZWwS'
    'KwoRb3JpZ2luYWxpdHlfc2NvcmUYCiABKAFSEG9yaWdpbmFsaXR5U2NvcmUSMwoVc2ltaWxhcm'
    'l0eV9wZXJjZW50YWdlGAsgASgBUhRzaW1pbGFyaXR5UGVyY2VudGFnZRI+CgZzdGF0dXMYDCAB'
    'KA4yJi5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlJlbWl4U3RhdHVzUgZzdGF0dXMSKQoQcm'
    'VqZWN0aW9uX3JlYXNvbhgNIAEoCVIPcmVqZWN0aW9uUmVhc29uEiMKDWVycm9yX21lc3NhZ2UY'
    'DiABKAlSDGVycm9yTWVzc2FnZRI5CgpjcmVhdGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYECABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use originalityCheckResultDescriptor instead')
const OriginalityCheckResult$json = {
  '1': 'OriginalityCheckResult',
  '2': [
    {
      '1': 'similarity_percentage',
      '3': 1,
      '4': 1,
      '5': 1,
      '10': 'similarityPercentage'
    },
    {
      '1': 'canonical_threshold_percentage',
      '3': 2,
      '4': 1,
      '5': 1,
      '10': 'canonicalThresholdPercentage'
    },
    {
      '1': 'originality_score',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'originalityScore'
    },
    {'1': 'passed', '3': 4, '4': 1, '5': 8, '10': 'passed'},
    {'1': 'explanation', '3': 5, '4': 1, '5': 9, '10': 'explanation'},
    {
      '1': 'actionable_alternatives',
      '3': 6,
      '4': 3,
      '5': 9,
      '10': 'actionableAlternatives'
    },
  ],
};

/// Descriptor for `OriginalityCheckResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List originalityCheckResultDescriptor = $convert.base64Decode(
    'ChZPcmlnaW5hbGl0eUNoZWNrUmVzdWx0EjMKFXNpbWlsYXJpdHlfcGVyY2VudGFnZRgBIAEoAV'
    'IUc2ltaWxhcml0eVBlcmNlbnRhZ2USRAoeY2Fub25pY2FsX3RocmVzaG9sZF9wZXJjZW50YWdl'
    'GAIgASgBUhxjYW5vbmljYWxUaHJlc2hvbGRQZXJjZW50YWdlEisKEW9yaWdpbmFsaXR5X3Njb3'
    'JlGAMgASgBUhBvcmlnaW5hbGl0eVNjb3JlEhYKBnBhc3NlZBgEIAEoCFIGcGFzc2VkEiAKC2V4'
    'cGxhbmF0aW9uGAUgASgJUgtleHBsYW5hdGlvbhI3ChdhY3Rpb25hYmxlX2FsdGVybmF0aXZlcx'
    'gGIAMoCVIWYWN0aW9uYWJsZUFsdGVybmF0aXZlcw==');

@$core.Deprecated('Use copyrightCheckResultDescriptor instead')
const CopyrightCheckResult$json = {
  '1': 'CopyrightCheckResult',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'media_title', '3': 2, '4': 1, '5': 9, '10': 'mediaTitle'},
    {'1': 'is_copyrighted', '3': 3, '4': 1, '5': 8, '10': 'isCopyrighted'},
    {
      '1': 'detected_song_title',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'detectedSongTitle'
    },
    {'1': 'detected_artist', '3': 5, '4': 1, '5': 9, '10': 'detectedArtist'},
    {'1': 'license_verified', '3': 6, '4': 1, '5': 8, '10': 'licenseVerified'},
    {'1': 'license_key', '3': 7, '4': 1, '5': 9, '10': 'licenseKey'},
    {'1': 'passed', '3': 8, '4': 1, '5': 8, '10': 'passed'},
    {'1': 'can_bypass_risk', '3': 9, '4': 1, '5': 8, '10': 'canBypassRisk'},
    {'1': 'warning_message', '3': 10, '4': 1, '5': 9, '10': 'warningMessage'},
    {
      '1': 'actionable_options',
      '3': 11,
      '4': 3,
      '5': 9,
      '10': 'actionableOptions'
    },
  ],
};

/// Descriptor for `CopyrightCheckResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copyrightCheckResultDescriptor = $convert.base64Decode(
    'ChRDb3B5cmlnaHRDaGVja1Jlc3VsdBIZCghtZWRpYV9pZBgBIAEoCVIHbWVkaWFJZBIfCgttZW'
    'RpYV90aXRsZRgCIAEoCVIKbWVkaWFUaXRsZRIlCg5pc19jb3B5cmlnaHRlZBgDIAEoCFINaXND'
    'b3B5cmlnaHRlZBIuChNkZXRlY3RlZF9zb25nX3RpdGxlGAQgASgJUhFkZXRlY3RlZFNvbmdUaX'
    'RsZRInCg9kZXRlY3RlZF9hcnRpc3QYBSABKAlSDmRldGVjdGVkQXJ0aXN0EikKEGxpY2Vuc2Vf'
    'dmVyaWZpZWQYBiABKAhSD2xpY2Vuc2VWZXJpZmllZBIfCgtsaWNlbnNlX2tleRgHIAEoCVIKbG'
    'ljZW5zZUtleRIWCgZwYXNzZWQYCCABKAhSBnBhc3NlZBImCg9jYW5fYnlwYXNzX3Jpc2sYCSAB'
    'KAhSDWNhbkJ5cGFzc1Jpc2sSJwoPd2FybmluZ19tZXNzYWdlGAogASgJUg53YXJuaW5nTWVzc2'
    'FnZRItChJhY3Rpb25hYmxlX29wdGlvbnMYCyADKAlSEWFjdGlvbmFibGVPcHRpb25z');

@$core.Deprecated('Use multiMergeTimelineItemDescriptor instead')
const MultiMergeTimelineItem$json = {
  '1': 'MultiMergeTimelineItem',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'order_index', '3': 3, '4': 1, '5': 5, '10': 'orderIndex'},
    {'1': 'duration_seconds', '3': 4, '4': 1, '5': 1, '10': 'durationSeconds'},
    {'1': 'media_type', '3': 5, '4': 1, '5': 9, '10': 'mediaType'},
    {
      '1': 'transition_to_next',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'transitionToNext'
    },
    {
      '1': 'transition_duration_seconds',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'transitionDurationSeconds'
    },
    {'1': 'license_status', '3': 8, '4': 1, '5': 9, '10': 'licenseStatus'},
    {'1': 'license_proof_key', '3': 9, '4': 1, '5': 9, '10': 'licenseProofKey'},
  ],
};

/// Descriptor for `MultiMergeTimelineItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiMergeTimelineItemDescriptor = $convert.base64Decode(
    'ChZNdWx0aU1lcmdlVGltZWxpbmVJdGVtEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIZCghhc3'
    'NldF9pZBgCIAEoCVIHYXNzZXRJZBIfCgtvcmRlcl9pbmRleBgDIAEoBVIKb3JkZXJJbmRleBIp'
    'ChBkdXJhdGlvbl9zZWNvbmRzGAQgASgBUg9kdXJhdGlvblNlY29uZHMSHQoKbWVkaWFfdHlwZR'
    'gFIAEoCVIJbWVkaWFUeXBlEiwKEnRyYW5zaXRpb25fdG9fbmV4dBgGIAEoCVIQdHJhbnNpdGlv'
    'blRvTmV4dBI+Cht0cmFuc2l0aW9uX2R1cmF0aW9uX3NlY29uZHMYByABKAFSGXRyYW5zaXRpb2'
    '5EdXJhdGlvblNlY29uZHMSJQoObGljZW5zZV9zdGF0dXMYCCABKAlSDWxpY2Vuc2VTdGF0dXMS'
    'KgoRbGljZW5zZV9wcm9vZl9rZXkYCSABKAlSD2xpY2Vuc2VQcm9vZktleQ==');

@$core.Deprecated('Use multiMergeSettingsDescriptor instead')
const MultiMergeSettings$json = {
  '1': 'MultiMergeSettings',
  '2': [
    {
      '1': 'target_duration_seconds',
      '3': 1,
      '4': 1,
      '5': 1,
      '10': 'targetDurationSeconds'
    },
    {'1': 'auto_transitions', '3': 2, '4': 1, '5': 8, '10': 'autoTransitions'},
    {'1': 'voice_over_type', '3': 3, '4': 1, '5': 9, '10': 'voiceOverType'},
    {
      '1': 'voice_over_character_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'voiceOverCharacterId'
    },
    {'1': 'music_source', '3': 5, '4': 1, '5': 9, '10': 'musicSource'},
    {'1': 'music_asset_id', '3': 6, '4': 1, '5': 9, '10': 'musicAssetId'},
    {
      '1': 'music_license_proof',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'musicLicenseProof'
    },
    {'1': 'aspect_ratio', '3': 8, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'pacing', '3': 9, '4': 1, '5': 9, '10': 'pacing'},
  ],
};

/// Descriptor for `MultiMergeSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiMergeSettingsDescriptor = $convert.base64Decode(
    'ChJNdWx0aU1lcmdlU2V0dGluZ3MSNgoXdGFyZ2V0X2R1cmF0aW9uX3NlY29uZHMYASABKAFSFX'
    'RhcmdldER1cmF0aW9uU2Vjb25kcxIpChBhdXRvX3RyYW5zaXRpb25zGAIgASgIUg9hdXRvVHJh'
    'bnNpdGlvbnMSJgoPdm9pY2Vfb3Zlcl90eXBlGAMgASgJUg12b2ljZU92ZXJUeXBlEjUKF3ZvaW'
    'NlX292ZXJfY2hhcmFjdGVyX2lkGAQgASgJUhR2b2ljZU92ZXJDaGFyYWN0ZXJJZBIhCgxtdXNp'
    'Y19zb3VyY2UYBSABKAlSC211c2ljU291cmNlEiQKDm11c2ljX2Fzc2V0X2lkGAYgASgJUgxtdX'
    'NpY0Fzc2V0SWQSLgoTbXVzaWNfbGljZW5zZV9wcm9vZhgHIAEoCVIRbXVzaWNMaWNlbnNlUHJv'
    'b2YSIQoMYXNwZWN0X3JhdGlvGAggASgJUgthc3BlY3RSYXRpbxIWCgZwYWNpbmcYCSABKAlSBn'
    'BhY2luZw==');

@$core.Deprecated('Use videoEditJobDescriptor instead')
const VideoEditJob$json = {
  '1': 'VideoEditJob',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ProductionMode',
      '10': 'mode'
    },
    {'1': 'source_asset_ids', '3': 4, '4': 3, '5': 9, '10': 'sourceAssetIds'},
    {'1': 'output_asset_ids', '3': 5, '4': 3, '5': 9, '10': 'outputAssetIds'},
    {'1': 'generation_job_id', '3': 6, '4': 1, '5': 9, '10': 'generationJobId'},
    {'1': 'character_id', '3': 7, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'brand_pack_id', '3': 8, '4': 1, '5': 9, '10': 'brandPackId'},
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.VideoEditJobStatus',
      '10': 'status'
    },
    {
      '1': 'input_params_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'inputParamsJson'
    },
    {
      '1': 'output_metadata_json',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'outputMetadataJson'
    },
    {
      '1': 'credits_estimated',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'creditsEstimated'
    },
    {'1': 'credits_used', '3': 13, '4': 1, '5': 9, '10': 'creditsUsed'},
    {'1': 'actual_cost_usd', '3': 14, '4': 1, '5': 9, '10': 'actualCostUsd'},
    {'1': 'error_message', '3': 15, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'started_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'completed_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {
      '1': 'created_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `VideoEditJob`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobDescriptor = $convert.base64Decode(
    'CgxWaWRlb0VkaXRKb2ISFQoGam9iX2lkGAEgASgJUgVqb2JJZBIhCgx3b3Jrc3BhY2VfaWQYAi'
    'ABKAlSC3dvcmtzcGFjZUlkEj0KBG1vZGUYAyABKA4yKS5jcmVhdGl2YW50YS5wcm9kdWN0aW9u'
    'LnYxLlByb2R1Y3Rpb25Nb2RlUgRtb2RlEigKEHNvdXJjZV9hc3NldF9pZHMYBCADKAlSDnNvdX'
    'JjZUFzc2V0SWRzEigKEG91dHB1dF9hc3NldF9pZHMYBSADKAlSDm91dHB1dEFzc2V0SWRzEioK'
    'EWdlbmVyYXRpb25fam9iX2lkGAYgASgJUg9nZW5lcmF0aW9uSm9iSWQSIQoMY2hhcmFjdGVyX2'
    'lkGAcgASgJUgtjaGFyYWN0ZXJJZBIiCg1icmFuZF9wYWNrX2lkGAggASgJUgticmFuZFBhY2tJ'
    'ZBJFCgZzdGF0dXMYCSABKA4yLS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlZpZGVvRWRpdE'
    'pvYlN0YXR1c1IGc3RhdHVzEioKEWlucHV0X3BhcmFtc19qc29uGAogASgJUg9pbnB1dFBhcmFt'
    'c0pzb24SMAoUb3V0cHV0X21ldGFkYXRhX2pzb24YCyABKAlSEm91dHB1dE1ldGFkYXRhSnNvbh'
    'IrChFjcmVkaXRzX2VzdGltYXRlZBgMIAEoCVIQY3JlZGl0c0VzdGltYXRlZBIhCgxjcmVkaXRz'
    'X3VzZWQYDSABKAlSC2NyZWRpdHNVc2VkEiYKD2FjdHVhbF9jb3N0X3VzZBgOIAEoCVINYWN0dW'
    'FsQ29zdFVzZBIjCg1lcnJvcl9tZXNzYWdlGA8gASgJUgxlcnJvck1lc3NhZ2USOQoKc3RhcnRl'
    'ZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBI9Cgxjb2'
    '1wbGV0ZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtjb21wbGV0ZWRB'
    'dBI5CgpjcmVhdGVkX2F0GBIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYX'
    'RlZEF0EjkKCnVwZGF0ZWRfYXQYEyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1'
    'cGRhdGVkQXQ=');

@$core.Deprecated('Use remixServiceAnalyzeRequestDescriptor instead')
const RemixServiceAnalyzeRequest$json = {
  '1': 'RemixServiceAnalyzeRequest',
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
      '1': 'reference_asset_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'referenceAssetId'
    },
    {'1': 'reference_url', '3': 3, '4': 1, '5': 9, '10': 'referenceUrl'},
    {
      '1': 'fidelity_level',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.FidelityLevel',
      '10': 'fidelityLevel'
    },
    {'1': 'topic', '3': 5, '4': 1, '5': 9, '10': 'topic'},
    {'1': 'character_id', '3': 6, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'brand_pack_id', '3': 7, '4': 1, '5': 9, '10': 'brandPackId'},
    {'1': 'target_platforms', '3': 8, '4': 3, '5': 9, '10': 'targetPlatforms'},
  ],
};

/// Descriptor for `RemixServiceAnalyzeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixServiceAnalyzeRequestDescriptor = $convert.base64Decode(
    'ChpSZW1peFNlcnZpY2VBbmFseXplUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiwKEnJlZmVyZW5jZV9hc3Nl'
    'dF9pZBgCIAEoCVIQcmVmZXJlbmNlQXNzZXRJZBIjCg1yZWZlcmVuY2VfdXJsGAMgASgJUgxyZW'
    'ZlcmVuY2VVcmwSTwoOZmlkZWxpdHlfbGV2ZWwYBCABKA4yKC5jcmVhdGl2YW50YS5wcm9kdWN0'
    'aW9uLnYxLkZpZGVsaXR5TGV2ZWxSDWZpZGVsaXR5TGV2ZWwSFAoFdG9waWMYBSABKAlSBXRvcG'
    'ljEiEKDGNoYXJhY3Rlcl9pZBgGIAEoCVILY2hhcmFjdGVySWQSIgoNYnJhbmRfcGFja19pZBgH'
    'IAEoCVILYnJhbmRQYWNrSWQSKQoQdGFyZ2V0X3BsYXRmb3JtcxgIIAMoCVIPdGFyZ2V0UGxhdG'
    'Zvcm1z');

@$core.Deprecated('Use remixServiceAnalyzeResponseDescriptor instead')
const RemixServiceAnalyzeResponse$json = {
  '1': 'RemixServiceAnalyzeResponse',
  '2': [
    {
      '1': 'blueprint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.RemixBlueprint',
      '10': 'blueprint'
    },
    {'1': 'credits_deducted', '3': 2, '4': 1, '5': 9, '10': 'creditsDeducted'},
  ],
};

/// Descriptor for `RemixServiceAnalyzeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixServiceAnalyzeResponseDescriptor =
    $convert.base64Decode(
        'ChtSZW1peFNlcnZpY2VBbmFseXplUmVzcG9uc2USRwoJYmx1ZXByaW50GAEgASgLMikuY3JlYX'
        'RpdmFudGEucHJvZHVjdGlvbi52MS5SZW1peEJsdWVwcmludFIJYmx1ZXByaW50EikKEGNyZWRp'
        'dHNfZGVkdWN0ZWQYAiABKAlSD2NyZWRpdHNEZWR1Y3RlZA==');

@$core.Deprecated('Use remixServiceGetBlueprintRequestDescriptor instead')
const RemixServiceGetBlueprintRequest$json = {
  '1': 'RemixServiceGetBlueprintRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'blueprint_id', '3': 2, '4': 1, '5': 9, '10': 'blueprintId'},
  ],
};

/// Descriptor for `RemixServiceGetBlueprintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixServiceGetBlueprintRequestDescriptor =
    $convert.base64Decode(
        'Ch9SZW1peFNlcnZpY2VHZXRCbHVlcHJpbnRSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCz'
        'IbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIhCgxibHVlcHJpbnRf'
        'aWQYAiABKAlSC2JsdWVwcmludElk');

@$core.Deprecated('Use remixServiceGetBlueprintResponseDescriptor instead')
const RemixServiceGetBlueprintResponse$json = {
  '1': 'RemixServiceGetBlueprintResponse',
  '2': [
    {
      '1': 'blueprint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.RemixBlueprint',
      '10': 'blueprint'
    },
  ],
};

/// Descriptor for `RemixServiceGetBlueprintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixServiceGetBlueprintResponseDescriptor =
    $convert.base64Decode(
        'CiBSZW1peFNlcnZpY2VHZXRCbHVlcHJpbnRSZXNwb25zZRJHCglibHVlcHJpbnQYASABKAsyKS'
        '5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlJlbWl4Qmx1ZXByaW50UglibHVlcHJpbnQ=');

@$core.Deprecated('Use remixServiceGenerateRequestDescriptor instead')
const RemixServiceGenerateRequest$json = {
  '1': 'RemixServiceGenerateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'blueprint_id', '3': 2, '4': 1, '5': 9, '10': 'blueprintId'},
    {'1': 'edited_script', '3': 3, '4': 1, '5': 9, '10': 'editedScript'},
    {
      '1': 'fidelity_level',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.FidelityLevel',
      '10': 'fidelityLevel'
    },
    {'1': 'topic', '3': 5, '4': 1, '5': 9, '10': 'topic'},
    {'1': 'character_id', '3': 6, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'brand_pack_id', '3': 7, '4': 1, '5': 9, '10': 'brandPackId'},
    {'1': 'dry_run', '3': 8, '4': 1, '5': 8, '10': 'dryRun'},
  ],
};

/// Descriptor for `RemixServiceGenerateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixServiceGenerateRequestDescriptor = $convert.base64Decode(
    'ChtSZW1peFNlcnZpY2VHZW5lcmF0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgxibHVlcHJpbnRfaWQY'
    'AiABKAlSC2JsdWVwcmludElkEiMKDWVkaXRlZF9zY3JpcHQYAyABKAlSDGVkaXRlZFNjcmlwdB'
    'JPCg5maWRlbGl0eV9sZXZlbBgEIAEoDjIoLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuRmlk'
    'ZWxpdHlMZXZlbFINZmlkZWxpdHlMZXZlbBIUCgV0b3BpYxgFIAEoCVIFdG9waWMSIQoMY2hhcm'
    'FjdGVyX2lkGAYgASgJUgtjaGFyYWN0ZXJJZBIiCg1icmFuZF9wYWNrX2lkGAcgASgJUgticmFu'
    'ZFBhY2tJZBIXCgdkcnlfcnVuGAggASgIUgZkcnlSdW4=');

@$core.Deprecated('Use remixServiceGenerateResponseDescriptor instead')
const RemixServiceGenerateResponse$json = {
  '1': 'RemixServiceGenerateResponse',
  '2': [
    {
      '1': 'blueprint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.RemixBlueprint',
      '10': 'blueprint'
    },
    {
      '1': 'job',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.VideoEditJob',
      '10': 'job'
    },
    {
      '1': 'asset',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.Asset',
      '10': 'asset'
    },
    {
      '1': 'originality_check',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.OriginalityCheckResult',
      '10': 'originalityCheck'
    },
    {'1': 'credits_deducted', '3': 5, '4': 1, '5': 9, '10': 'creditsDeducted'},
    {'1': 'is_dry_run', '3': 6, '4': 1, '5': 8, '10': 'isDryRun'},
  ],
};

/// Descriptor for `RemixServiceGenerateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixServiceGenerateResponseDescriptor = $convert.base64Decode(
    'ChxSZW1peFNlcnZpY2VHZW5lcmF0ZVJlc3BvbnNlEkcKCWJsdWVwcmludBgBIAEoCzIpLmNyZW'
    'F0aXZhbnRhLnByb2R1Y3Rpb24udjEuUmVtaXhCbHVlcHJpbnRSCWJsdWVwcmludBI5CgNqb2IY'
    'AiABKAsyJy5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlZpZGVvRWRpdEpvYlIDam9iEjYKBW'
    'Fzc2V0GAMgASgLMiAuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5Bc3NldFIFYXNzZXQSXgoR'
    'b3JpZ2luYWxpdHlfY2hlY2sYBCABKAsyMS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLk9yaW'
    'dpbmFsaXR5Q2hlY2tSZXN1bHRSEG9yaWdpbmFsaXR5Q2hlY2sSKQoQY3JlZGl0c19kZWR1Y3Rl'
    'ZBgFIAEoCVIPY3JlZGl0c0RlZHVjdGVkEhwKCmlzX2RyeV9ydW4YBiABKAhSCGlzRHJ5UnVu');

@$core.Deprecated('Use remixServiceRegenerateRequestDescriptor instead')
const RemixServiceRegenerateRequest$json = {
  '1': 'RemixServiceRegenerateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'blueprint_id', '3': 2, '4': 1, '5': 9, '10': 'blueprintId'},
    {'1': 'scene_index', '3': 3, '4': 1, '5': 5, '10': 'sceneIndex'},
    {'1': 'script_segment', '3': 4, '4': 1, '5': 9, '10': 'scriptSegment'},
    {
      '1': 'visual_prompt_override',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'visualPromptOverride'
    },
  ],
};

/// Descriptor for `RemixServiceRegenerateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixServiceRegenerateRequestDescriptor = $convert.base64Decode(
    'Ch1SZW1peFNlcnZpY2VSZWdlbmVyYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDGJsdWVwcmludF9p'
    'ZBgCIAEoCVILYmx1ZXByaW50SWQSHwoLc2NlbmVfaW5kZXgYAyABKAVSCnNjZW5lSW5kZXgSJQ'
    'oOc2NyaXB0X3NlZ21lbnQYBCABKAlSDXNjcmlwdFNlZ21lbnQSNAoWdmlzdWFsX3Byb21wdF9v'
    'dmVycmlkZRgFIAEoCVIUdmlzdWFsUHJvbXB0T3ZlcnJpZGU=');

@$core.Deprecated('Use remixServiceRegenerateResponseDescriptor instead')
const RemixServiceRegenerateResponse$json = {
  '1': 'RemixServiceRegenerateResponse',
  '2': [
    {
      '1': 'blueprint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.RemixBlueprint',
      '10': 'blueprint'
    },
    {
      '1': 'job',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.VideoEditJob',
      '10': 'job'
    },
    {'1': 'scene_index', '3': 3, '4': 1, '5': 5, '10': 'sceneIndex'},
    {'1': 'credits_deducted', '3': 4, '4': 1, '5': 9, '10': 'creditsDeducted'},
  ],
};

/// Descriptor for `RemixServiceRegenerateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List remixServiceRegenerateResponseDescriptor = $convert.base64Decode(
    'Ch5SZW1peFNlcnZpY2VSZWdlbmVyYXRlUmVzcG9uc2USRwoJYmx1ZXByaW50GAEgASgLMikuY3'
    'JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5SZW1peEJsdWVwcmludFIJYmx1ZXByaW50EjkKA2pv'
    'YhgCIAEoCzInLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuVmlkZW9FZGl0Sm9iUgNqb2ISHw'
    'oLc2NlbmVfaW5kZXgYAyABKAVSCnNjZW5lSW5kZXgSKQoQY3JlZGl0c19kZWR1Y3RlZBgEIAEo'
    'CVIPY3JlZGl0c0RlZHVjdGVk');

@$core.Deprecated('Use videoEditJobServiceCreateRequestDescriptor instead')
const VideoEditJobServiceCreateRequest$json = {
  '1': 'VideoEditJobServiceCreateRequest',
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
      '1': 'mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ProductionMode',
      '10': 'mode'
    },
    {'1': 'source_asset_ids', '3': 3, '4': 3, '5': 9, '10': 'sourceAssetIds'},
    {'1': 'character_id', '3': 4, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'brand_pack_id', '3': 5, '4': 1, '5': 9, '10': 'brandPackId'},
    {
      '1': 'timeline_items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.MultiMergeTimelineItem',
      '10': 'timelineItems'
    },
    {
      '1': 'multimerge_settings',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.MultiMergeSettings',
      '10': 'multimergeSettings'
    },
    {'1': 'dry_run', '3': 8, '4': 1, '5': 8, '10': 'dryRun'},
  ],
};

/// Descriptor for `VideoEditJobServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceCreateRequestDescriptor = $convert.base64Decode(
    'CiBWaWRlb0VkaXRKb2JTZXJ2aWNlQ3JlYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
    'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Ej0KBG1vZGUYAiAB'
    'KA4yKS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlByb2R1Y3Rpb25Nb2RlUgRtb2RlEigKEH'
    'NvdXJjZV9hc3NldF9pZHMYAyADKAlSDnNvdXJjZUFzc2V0SWRzEiEKDGNoYXJhY3Rlcl9pZBgE'
    'IAEoCVILY2hhcmFjdGVySWQSIgoNYnJhbmRfcGFja19pZBgFIAEoCVILYnJhbmRQYWNrSWQSWA'
    'oOdGltZWxpbmVfaXRlbXMYBiADKAsyMS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLk11bHRp'
    'TWVyZ2VUaW1lbGluZUl0ZW1SDXRpbWVsaW5lSXRlbXMSXgoTbXVsdGltZXJnZV9zZXR0aW5ncx'
    'gHIAEoCzItLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuTXVsdGlNZXJnZVNldHRpbmdzUhJt'
    'dWx0aW1lcmdlU2V0dGluZ3MSFwoHZHJ5X3J1bhgIIAEoCFIGZHJ5UnVu');

@$core.Deprecated('Use videoEditJobServiceCreateResponseDescriptor instead')
const VideoEditJobServiceCreateResponse$json = {
  '1': 'VideoEditJobServiceCreateResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.VideoEditJob',
      '10': 'job'
    },
    {
      '1': 'credits_estimated',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'creditsEstimated'
    },
    {'1': 'is_dry_run', '3': 3, '4': 1, '5': 8, '10': 'isDryRun'},
    {
      '1': 'copyright_checks',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.CopyrightCheckResult',
      '10': 'copyrightChecks'
    },
  ],
};

/// Descriptor for `VideoEditJobServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceCreateResponseDescriptor = $convert.base64Decode(
    'CiFWaWRlb0VkaXRKb2JTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USOQoDam9iGAEgASgLMicuY3JlYX'
    'RpdmFudGEucHJvZHVjdGlvbi52MS5WaWRlb0VkaXRKb2JSA2pvYhIrChFjcmVkaXRzX2VzdGlt'
    'YXRlZBgCIAEoCVIQY3JlZGl0c0VzdGltYXRlZBIcCgppc19kcnlfcnVuGAMgASgIUghpc0RyeV'
    'J1bhJaChBjb3B5cmlnaHRfY2hlY2tzGAQgAygLMi8uY3JlYXRpdmFudGEucHJvZHVjdGlvbi52'
    'MS5Db3B5cmlnaHRDaGVja1Jlc3VsdFIPY29weXJpZ2h0Q2hlY2tz');

@$core.Deprecated('Use videoEditJobServiceGetRequestDescriptor instead')
const VideoEditJobServiceGetRequest$json = {
  '1': 'VideoEditJobServiceGetRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
  ],
};

/// Descriptor for `VideoEditJobServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceGetRequestDescriptor =
    $convert.base64Decode(
        'Ch1WaWRlb0VkaXRKb2JTZXJ2aWNlR2V0UmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy'
        '5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSFQoGam9iX2lkGAIgASgJ'
        'UgVqb2JJZA==');

@$core.Deprecated('Use videoEditJobServiceGetResponseDescriptor instead')
const VideoEditJobServiceGetResponse$json = {
  '1': 'VideoEditJobServiceGetResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.VideoEditJob',
      '10': 'job'
    },
  ],
};

/// Descriptor for `VideoEditJobServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceGetResponseDescriptor =
    $convert.base64Decode(
        'Ch5WaWRlb0VkaXRKb2JTZXJ2aWNlR2V0UmVzcG9uc2USOQoDam9iGAEgASgLMicuY3JlYXRpdm'
        'FudGEucHJvZHVjdGlvbi52MS5WaWRlb0VkaXRKb2JSA2pvYg==');

@$core.Deprecated('Use videoEditJobServiceListRequestDescriptor instead')
const VideoEditJobServiceListRequest$json = {
  '1': 'VideoEditJobServiceListRequest',
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
      '1': 'mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ProductionMode',
      '10': 'mode'
    },
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.VideoEditJobStatus',
      '10': 'status'
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

/// Descriptor for `VideoEditJobServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceListRequestDescriptor = $convert.base64Decode(
    'Ch5WaWRlb0VkaXRKb2JTZXJ2aWNlTGlzdFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMh'
    'suY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEj0KBG1vZGUYAiABKA4y'
    'KS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlByb2R1Y3Rpb25Nb2RlUgRtb2RlEkUKBnN0YX'
    'R1cxgDIAEoDjItLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuVmlkZW9FZGl0Sm9iU3RhdHVz'
    'UgZzdGF0dXMSQQoKcGFnaW5hdGlvbhgEIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYW'
    'dpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use videoEditJobServiceListResponseDescriptor instead')
const VideoEditJobServiceListResponse$json = {
  '1': 'VideoEditJobServiceListResponse',
  '2': [
    {
      '1': 'jobs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.VideoEditJob',
      '10': 'jobs'
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

/// Descriptor for `VideoEditJobServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceListResponseDescriptor =
    $convert.base64Decode(
        'Ch9WaWRlb0VkaXRKb2JTZXJ2aWNlTGlzdFJlc3BvbnNlEjsKBGpvYnMYASADKAsyJy5jcmVhdG'
        'l2YW50YS5wcm9kdWN0aW9uLnYxLlZpZGVvRWRpdEpvYlIEam9icxJICgpwYWdpbmF0aW9uGAIg'
        'ASgLMiguY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW'
        '9u');

@$core.Deprecated('Use videoEditJobServiceCancelRequestDescriptor instead')
const VideoEditJobServiceCancelRequest$json = {
  '1': 'VideoEditJobServiceCancelRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `VideoEditJobServiceCancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceCancelRequestDescriptor =
    $convert.base64Decode(
        'CiBWaWRlb0VkaXRKb2JTZXJ2aWNlQ2FuY2VsUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhUKBmpvYl9pZBgC'
        'IAEoCVIFam9iSWQSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use videoEditJobServiceCancelResponseDescriptor instead')
const VideoEditJobServiceCancelResponse$json = {
  '1': 'VideoEditJobServiceCancelResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.VideoEditJob',
      '10': 'job'
    },
    {'1': 'credits_refunded', '3': 2, '4': 1, '5': 9, '10': 'creditsRefunded'},
  ],
};

/// Descriptor for `VideoEditJobServiceCancelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceCancelResponseDescriptor =
    $convert.base64Decode(
        'CiFWaWRlb0VkaXRKb2JTZXJ2aWNlQ2FuY2VsUmVzcG9uc2USOQoDam9iGAEgASgLMicuY3JlYX'
        'RpdmFudGEucHJvZHVjdGlvbi52MS5WaWRlb0VkaXRKb2JSA2pvYhIpChBjcmVkaXRzX3JlZnVu'
        'ZGVkGAIgASgJUg9jcmVkaXRzUmVmdW5kZWQ=');

@$core.Deprecated('Use videoEditJobServiceRetryRequestDescriptor instead')
const VideoEditJobServiceRetryRequest$json = {
  '1': 'VideoEditJobServiceRetryRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
    {
      '1': 'fallback_provider',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'fallbackProvider'
    },
  ],
};

/// Descriptor for `VideoEditJobServiceRetryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceRetryRequestDescriptor =
    $convert.base64Decode(
        'Ch9WaWRlb0VkaXRKb2JTZXJ2aWNlUmV0cnlSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcm'
        'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSFQoGam9iX2lkGAIg'
        'ASgJUgVqb2JJZBIrChFmYWxsYmFja19wcm92aWRlchgDIAEoCVIQZmFsbGJhY2tQcm92aWRlcg'
        '==');

@$core.Deprecated('Use videoEditJobServiceRetryResponseDescriptor instead')
const VideoEditJobServiceRetryResponse$json = {
  '1': 'VideoEditJobServiceRetryResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.VideoEditJob',
      '10': 'job'
    },
  ],
};

/// Descriptor for `VideoEditJobServiceRetryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoEditJobServiceRetryResponseDescriptor =
    $convert.base64Decode(
        'CiBWaWRlb0VkaXRKb2JTZXJ2aWNlUmV0cnlSZXNwb25zZRI5CgNqb2IYASABKAsyJy5jcmVhdG'
        'l2YW50YS5wcm9kdWN0aW9uLnYxLlZpZGVvRWRpdEpvYlIDam9i');

@$core.Deprecated('Use styleElementsDescriptor instead')
const StyleElements$json = {
  '1': 'StyleElements',
  '2': [
    {'1': 'color_palette', '3': 1, '4': 1, '5': 9, '10': 'colorPalette'},
    {'1': 'cut_pacing', '3': 2, '4': 1, '5': 9, '10': 'cutPacing'},
    {'1': 'text_style', '3': 3, '4': 1, '5': 9, '10': 'textStyle'},
    {'1': 'music_style', '3': 4, '4': 1, '5': 9, '10': 'musicStyle'},
    {'1': 'transitions', '3': 5, '4': 1, '5': 9, '10': 'transitions'},
    {'1': 'hook_pattern', '3': 6, '4': 1, '5': 9, '10': 'hookPattern'},
    {'1': 'visual_mood', '3': 7, '4': 1, '5': 9, '10': 'visualMood'},
    {
      '1': 'avg_cut_duration_ms',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'avgCutDurationMs'
    },
    {'1': 'color_palette_hex', '3': 9, '4': 3, '5': 9, '10': 'colorPaletteHex'},
  ],
};

/// Descriptor for `StyleElements`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List styleElementsDescriptor = $convert.base64Decode(
    'Cg1TdHlsZUVsZW1lbnRzEiMKDWNvbG9yX3BhbGV0dGUYASABKAlSDGNvbG9yUGFsZXR0ZRIdCg'
    'pjdXRfcGFjaW5nGAIgASgJUgljdXRQYWNpbmcSHQoKdGV4dF9zdHlsZRgDIAEoCVIJdGV4dFN0'
    'eWxlEh8KC211c2ljX3N0eWxlGAQgASgJUgptdXNpY1N0eWxlEiAKC3RyYW5zaXRpb25zGAUgAS'
    'gJUgt0cmFuc2l0aW9ucxIhCgxob29rX3BhdHRlcm4YBiABKAlSC2hvb2tQYXR0ZXJuEh8KC3Zp'
    'c3VhbF9tb29kGAcgASgJUgp2aXN1YWxNb29kEi0KE2F2Z19jdXRfZHVyYXRpb25fbXMYCCABKA'
    'VSEGF2Z0N1dER1cmF0aW9uTXMSKgoRY29sb3JfcGFsZXR0ZV9oZXgYCSADKAlSD2NvbG9yUGFs'
    'ZXR0ZUhleA==');

@$core.Deprecated('Use stylePackDescriptor instead')
const StylePack$json = {
  '1': 'StylePack',
  '2': [
    {'1': 'style_pack_id', '3': 1, '4': 1, '5': 9, '10': 'stylePackId'},
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'source_asset_id', '3': 4, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {
      '1': 'extracted_style_json',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'extractedStyleJson'
    },
    {'1': 'is_active', '3': 6, '4': 1, '5': 8, '10': 'isActive'},
    {
      '1': 'continuity_pack_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'continuityPackId'
    },
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `StylePack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackDescriptor = $convert.base64Decode(
    'CglTdHlsZVBhY2sSIgoNc3R5bGVfcGFja19pZBgBIAEoCVILc3R5bGVQYWNrSWQSPgoMd29ya3'
    'NwYWNlX2lkGAIgASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlk'
    'EhIKBG5hbWUYAyABKAlSBG5hbWUSJgoPc291cmNlX2Fzc2V0X2lkGAQgASgJUg1zb3VyY2VBc3'
    'NldElkEjAKFGV4dHJhY3RlZF9zdHlsZV9qc29uGAUgASgJUhJleHRyYWN0ZWRTdHlsZUpzb24S'
    'GwoJaXNfYWN0aXZlGAYgASgIUghpc0FjdGl2ZRIsChJjb250aW51aXR5X3BhY2tfaWQYByABKA'
    'lSEGNvbnRpbnVpdHlQYWNrSWQSOQoKY3JlYXRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use stylePackServiceExtractRequestDescriptor instead')
const StylePackServiceExtractRequest$json = {
  '1': 'StylePackServiceExtractRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'source_asset_ids', '3': 2, '4': 3, '5': 9, '10': 'sourceAssetIds'},
  ],
};

/// Descriptor for `StylePackServiceExtractRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceExtractRequestDescriptor =
    $convert.base64Decode(
        'Ch5TdHlsZVBhY2tTZXJ2aWNlRXh0cmFjdFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
        'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIoChBzb3VyY2VfYXNz'
        'ZXRfaWRzGAIgAygJUg5zb3VyY2VBc3NldElkcw==');

@$core.Deprecated('Use stylePackServiceExtractResponseDescriptor instead')
const StylePackServiceExtractResponse$json = {
  '1': 'StylePackServiceExtractResponse',
  '2': [
    {
      '1': 'elements',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.StyleElements',
      '10': 'elements'
    },
    {'1': 'credits_used', '3': 2, '4': 1, '5': 9, '10': 'creditsUsed'},
    {
      '1': 'extracted_style_json',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'extractedStyleJson'
    },
  ],
};

/// Descriptor for `StylePackServiceExtractResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceExtractResponseDescriptor =
    $convert.base64Decode(
        'Ch9TdHlsZVBhY2tTZXJ2aWNlRXh0cmFjdFJlc3BvbnNlEkQKCGVsZW1lbnRzGAEgASgLMiguY3'
        'JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5TdHlsZUVsZW1lbnRzUghlbGVtZW50cxIhCgxjcmVk'
        'aXRzX3VzZWQYAiABKAlSC2NyZWRpdHNVc2VkEjAKFGV4dHJhY3RlZF9zdHlsZV9qc29uGAMgAS'
        'gJUhJleHRyYWN0ZWRTdHlsZUpzb24=');

@$core.Deprecated('Use stylePackServiceCreateRequestDescriptor instead')
const StylePackServiceCreateRequest$json = {
  '1': 'StylePackServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'source_asset_id', '3': 3, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {
      '1': 'extracted_style_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'extractedStyleJson'
    },
    {
      '1': 'link_to_continuity_pack',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'linkToContinuityPack'
    },
  ],
};

/// Descriptor for `StylePackServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch1TdHlsZVBhY2tTZXJ2aWNlQ3JlYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhIKBG5hbWUYAiABKAlS'
    'BG5hbWUSJgoPc291cmNlX2Fzc2V0X2lkGAMgASgJUg1zb3VyY2VBc3NldElkEjAKFGV4dHJhY3'
    'RlZF9zdHlsZV9qc29uGAQgASgJUhJleHRyYWN0ZWRTdHlsZUpzb24SNQoXbGlua190b19jb250'
    'aW51aXR5X3BhY2sYBSABKAhSFGxpbmtUb0NvbnRpbnVpdHlQYWNr');

@$core.Deprecated('Use stylePackServiceCreateResponseDescriptor instead')
const StylePackServiceCreateResponse$json = {
  '1': 'StylePackServiceCreateResponse',
  '2': [
    {
      '1': 'style_pack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.StylePack',
      '10': 'stylePack'
    },
    {
      '1': 'continuity_pack_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'continuityPackId'
    },
  ],
};

/// Descriptor for `StylePackServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch5TdHlsZVBhY2tTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USQwoKc3R5bGVfcGFjaxgBIAEoCzIkLm'
        'NyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuU3R5bGVQYWNrUglzdHlsZVBhY2sSLAoSY29udGlu'
        'dWl0eV9wYWNrX2lkGAIgASgJUhBjb250aW51aXR5UGFja0lk');

@$core.Deprecated('Use stylePackServiceGetRequestDescriptor instead')
const StylePackServiceGetRequest$json = {
  '1': 'StylePackServiceGetRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'style_pack_id', '3': 2, '4': 1, '5': 9, '10': 'stylePackId'},
  ],
};

/// Descriptor for `StylePackServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChpTdHlsZVBhY2tTZXJ2aWNlR2V0UmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcm'
        'VhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSIgoNc3R5bGVfcGFja19pZBgC'
        'IAEoCVILc3R5bGVQYWNrSWQ=');

@$core.Deprecated('Use stylePackServiceGetResponseDescriptor instead')
const StylePackServiceGetResponse$json = {
  '1': 'StylePackServiceGetResponse',
  '2': [
    {
      '1': 'style_pack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.StylePack',
      '10': 'stylePack'
    },
    {
      '1': 'elements',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.StyleElements',
      '10': 'elements'
    },
  ],
};

/// Descriptor for `StylePackServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceGetResponseDescriptor = $convert.base64Decode(
    'ChtTdHlsZVBhY2tTZXJ2aWNlR2V0UmVzcG9uc2USQwoKc3R5bGVfcGFjaxgBIAEoCzIkLmNyZW'
    'F0aXZhbnRhLnByb2R1Y3Rpb24udjEuU3R5bGVQYWNrUglzdHlsZVBhY2sSRAoIZWxlbWVudHMY'
    'AiABKAsyKC5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlN0eWxlRWxlbWVudHNSCGVsZW1lbn'
    'Rz');

@$core.Deprecated('Use stylePackServiceListRequestDescriptor instead')
const StylePackServiceListRequest$json = {
  '1': 'StylePackServiceListRequest',
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
  ],
};

/// Descriptor for `StylePackServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceListRequestDescriptor =
    $convert.base64Decode(
        'ChtTdHlsZVBhY2tTZXJ2aWNlTGlzdFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEkEKCnBhZ2luYXRpb24YAiAB'
        'KAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use stylePackServiceListResponseDescriptor instead')
const StylePackServiceListResponse$json = {
  '1': 'StylePackServiceListResponse',
  '2': [
    {
      '1': 'style_packs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.StylePack',
      '10': 'stylePacks'
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

/// Descriptor for `StylePackServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceListResponseDescriptor = $convert.base64Decode(
    'ChxTdHlsZVBhY2tTZXJ2aWNlTGlzdFJlc3BvbnNlEkUKC3N0eWxlX3BhY2tzGAEgAygLMiQuY3'
    'JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5TdHlsZVBhY2tSCnN0eWxlUGFja3MSSAoKcGFnaW5h'
    'dGlvbhgCIAEoCzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcG'
    'FnaW5hdGlvbg==');

@$core.Deprecated('Use stylePackServiceApplyRequestDescriptor instead')
const StylePackServiceApplyRequest$json = {
  '1': 'StylePackServiceApplyRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'style_pack_id', '3': 2, '4': 1, '5': 9, '10': 'stylePackId'},
    {'1': 'target_job_id', '3': 3, '4': 1, '5': 9, '10': 'targetJobId'},
    {'1': 'target_mode', '3': 4, '4': 1, '5': 9, '10': 'targetMode'},
  ],
};

/// Descriptor for `StylePackServiceApplyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceApplyRequestDescriptor = $convert.base64Decode(
    'ChxTdHlsZVBhY2tTZXJ2aWNlQXBwbHlSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIgoNc3R5bGVfcGFja19p'
    'ZBgCIAEoCVILc3R5bGVQYWNrSWQSIgoNdGFyZ2V0X2pvYl9pZBgDIAEoCVILdGFyZ2V0Sm9iSW'
    'QSHwoLdGFyZ2V0X21vZGUYBCABKAlSCnRhcmdldE1vZGU=');

@$core.Deprecated('Use stylePackServiceApplyResponseDescriptor instead')
const StylePackServiceApplyResponse$json = {
  '1': 'StylePackServiceApplyResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'style_pack_id', '3': 3, '4': 1, '5': 9, '10': 'stylePackId'},
    {'1': 'target_job_id', '3': 4, '4': 1, '5': 9, '10': 'targetJobId'},
  ],
};

/// Descriptor for `StylePackServiceApplyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceApplyResponseDescriptor =
    $convert.base64Decode(
        'Ch1TdHlsZVBhY2tTZXJ2aWNlQXBwbHlSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZX'
        'NzEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USIgoNc3R5bGVfcGFja19pZBgDIAEoCVILc3R5'
        'bGVQYWNrSWQSIgoNdGFyZ2V0X2pvYl9pZBgEIAEoCVILdGFyZ2V0Sm9iSWQ=');

@$core.Deprecated('Use stylePackServiceDeleteRequestDescriptor instead')
const StylePackServiceDeleteRequest$json = {
  '1': 'StylePackServiceDeleteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'style_pack_id', '3': 2, '4': 1, '5': 9, '10': 'stylePackId'},
  ],
};

/// Descriptor for `StylePackServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceDeleteRequestDescriptor =
    $convert.base64Decode(
        'Ch1TdHlsZVBhY2tTZXJ2aWNlRGVsZXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
        'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiIKDXN0eWxlX3BhY2tf'
        'aWQYAiABKAlSC3N0eWxlUGFja0lk');

@$core.Deprecated('Use stylePackServiceDeleteResponseDescriptor instead')
const StylePackServiceDeleteResponse$json = {
  '1': 'StylePackServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `StylePackServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stylePackServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'Ch5TdHlsZVBhY2tTZXJ2aWNlRGVsZXRlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
        'Vzcw==');

@$core.Deprecated('Use generateCharacterPreviewRequestDescriptor instead')
const GenerateCharacterPreviewRequest$json = {
  '1': 'GenerateCharacterPreviewRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'character_id', '3': 2, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'visual_prompt', '3': 3, '4': 1, '5': 9, '10': 'visualPrompt'},
    {'1': 'voice_sample_url', '3': 4, '4': 1, '5': 9, '10': 'voiceSampleUrl'},
    {'1': 'aspect_ratio', '3': 5, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'duration_seconds', '3': 6, '4': 1, '5': 5, '10': 'durationSeconds'},
  ],
};

/// Descriptor for `GenerateCharacterPreviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateCharacterPreviewRequestDescriptor = $convert.base64Decode(
    'Ch9HZW5lcmF0ZUNoYXJhY3RlclByZXZpZXdSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcm'
    'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMY2hhcmFjdGVy'
    'X2lkGAIgASgJUgtjaGFyYWN0ZXJJZBIjCg12aXN1YWxfcHJvbXB0GAMgASgJUgx2aXN1YWxQcm'
    '9tcHQSKAoQdm9pY2Vfc2FtcGxlX3VybBgEIAEoCVIOdm9pY2VTYW1wbGVVcmwSIQoMYXNwZWN0'
    'X3JhdGlvGAUgASgJUgthc3BlY3RSYXRpbxIpChBkdXJhdGlvbl9zZWNvbmRzGAYgASgFUg9kdX'
    'JhdGlvblNlY29uZHM=');

@$core.Deprecated('Use generateCharacterPreviewResponseDescriptor instead')
const GenerateCharacterPreviewResponse$json = {
  '1': 'GenerateCharacterPreviewResponse',
  '2': [
    {'1': 'preview_asset_id', '3': 1, '4': 1, '5': 9, '10': 'previewAssetId'},
    {'1': 'preview_url', '3': 2, '4': 1, '5': 9, '10': 'previewUrl'},
    {'1': 'duration_seconds', '3': 3, '4': 1, '5': 5, '10': 'durationSeconds'},
    {'1': 'credits_used', '3': 4, '4': 1, '5': 9, '10': 'creditsUsed'},
    {'1': 'verified', '3': 5, '4': 1, '5': 8, '10': 'verified'},
    {'1': 'character_id', '3': 6, '4': 1, '5': 9, '10': 'characterId'},
  ],
};

/// Descriptor for `GenerateCharacterPreviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateCharacterPreviewResponseDescriptor = $convert.base64Decode(
    'CiBHZW5lcmF0ZUNoYXJhY3RlclByZXZpZXdSZXNwb25zZRIoChBwcmV2aWV3X2Fzc2V0X2lkGA'
    'EgASgJUg5wcmV2aWV3QXNzZXRJZBIfCgtwcmV2aWV3X3VybBgCIAEoCVIKcHJldmlld1VybBIp'
    'ChBkdXJhdGlvbl9zZWNvbmRzGAMgASgFUg9kdXJhdGlvblNlY29uZHMSIQoMY3JlZGl0c191c2'
    'VkGAQgASgJUgtjcmVkaXRzVXNlZBIaCgh2ZXJpZmllZBgFIAEoCFIIdmVyaWZpZWQSIQoMY2hh'
    'cmFjdGVyX2lkGAYgASgJUgtjaGFyYWN0ZXJJZA==');

@$core.Deprecated('Use quoteCharacterPreviewRequestDescriptor instead')
const QuoteCharacterPreviewRequest$json = {
  '1': 'QuoteCharacterPreviewRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'character_id', '3': 2, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'duration_seconds', '3': 3, '4': 1, '5': 5, '10': 'durationSeconds'},
  ],
};

/// Descriptor for `QuoteCharacterPreviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quoteCharacterPreviewRequestDescriptor = $convert.base64Decode(
    'ChxRdW90ZUNoYXJhY3RlclByZXZpZXdSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLm'
    'NyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIhCgxjaGFyYWN0ZXJfaWQY'
    'AiABKAlSC2NoYXJhY3RlcklkEikKEGR1cmF0aW9uX3NlY29uZHMYAyABKAVSD2R1cmF0aW9uU2'
    'Vjb25kcw==');

@$core.Deprecated('Use quoteCharacterPreviewResponseDescriptor instead')
const QuoteCharacterPreviewResponse$json = {
  '1': 'QuoteCharacterPreviewResponse',
  '2': [
    {'1': 'quote_id', '3': 1, '4': 1, '5': 9, '10': 'quoteId'},
    {'1': 'credits_required', '3': 2, '4': 1, '5': 9, '10': 'creditsRequired'},
    {'1': 'duration_seconds', '3': 3, '4': 1, '5': 5, '10': 'durationSeconds'},
    {'1': 'provider', '3': 4, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'can_afford', '3': 5, '4': 1, '5': 8, '10': 'canAfford'},
  ],
};

/// Descriptor for `QuoteCharacterPreviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quoteCharacterPreviewResponseDescriptor = $convert.base64Decode(
    'Ch1RdW90ZUNoYXJhY3RlclByZXZpZXdSZXNwb25zZRIZCghxdW90ZV9pZBgBIAEoCVIHcXVvdG'
    'VJZBIpChBjcmVkaXRzX3JlcXVpcmVkGAIgASgJUg9jcmVkaXRzUmVxdWlyZWQSKQoQZHVyYXRp'
    'b25fc2Vjb25kcxgDIAEoBVIPZHVyYXRpb25TZWNvbmRzEhoKCHByb3ZpZGVyGAQgASgJUghwcm'
    '92aWRlchIdCgpjYW5fYWZmb3JkGAUgASgIUgljYW5BZmZvcmQ=');

@$core.Deprecated('Use analyzeStyleRequestDescriptor instead')
const AnalyzeStyleRequest$json = {
  '1': 'AnalyzeStyleRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'asset_ids', '3': 2, '4': 3, '5': 9, '10': 'assetIds'},
  ],
};

/// Descriptor for `AnalyzeStyleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List analyzeStyleRequestDescriptor = $convert.base64Decode(
    'ChNBbmFseXplU3R5bGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGwoJYXNzZXRfaWRzGAIgAygJUghhc3Nl'
    'dElkcw==');

@$core.Deprecated('Use analyzeStyleResponseDescriptor instead')
const AnalyzeStyleResponse$json = {
  '1': 'AnalyzeStyleResponse',
  '2': [
    {
      '1': 'style_elements',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.StyleElements',
      '10': 'styleElements'
    },
    {'1': 'credits_used', '3': 2, '4': 1, '5': 9, '10': 'creditsUsed'},
  ],
};

/// Descriptor for `AnalyzeStyleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List analyzeStyleResponseDescriptor = $convert.base64Decode(
    'ChRBbmFseXplU3R5bGVSZXNwb25zZRJPCg5zdHlsZV9lbGVtZW50cxgBIAEoCzIoLmNyZWF0aX'
    'ZhbnRhLnByb2R1Y3Rpb24udjEuU3R5bGVFbGVtZW50c1INc3R5bGVFbGVtZW50cxIhCgxjcmVk'
    'aXRzX3VzZWQYAiABKAlSC2NyZWRpdHNVc2Vk');

@$core.Deprecated('Use driftEvaluationResultDescriptor instead')
const DriftEvaluationResult$json = {
  '1': 'DriftEvaluationResult',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
    {'1': 'pack_version', '3': 3, '4': 1, '5': 5, '10': 'packVersion'},
    {'1': 'drift_score', '3': 4, '4': 1, '5': 2, '10': 'driftScore'},
    {'1': 'drift_severity', '3': 5, '4': 1, '5': 9, '10': 'driftSeverity'},
    {'1': 'is_blocked', '3': 6, '4': 1, '5': 8, '10': 'isBlocked'},
    {
      '1': 'violation_reasons',
      '3': 7,
      '4': 3,
      '5': 9,
      '10': 'violationReasons'
    },
    {'1': 'details_json', '3': 8, '4': 1, '5': 9, '10': 'detailsJson'},
    {'1': 'violation_id', '3': 9, '4': 1, '5': 9, '10': 'violationId'},
  ],
};

/// Descriptor for `DriftEvaluationResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List driftEvaluationResultDescriptor = $convert.base64Decode(
    'ChVEcmlmdEV2YWx1YXRpb25SZXN1bHQSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSFwoHcG'
    'Fja19pZBgCIAEoCVIGcGFja0lkEiEKDHBhY2tfdmVyc2lvbhgDIAEoBVILcGFja1ZlcnNpb24S'
    'HwoLZHJpZnRfc2NvcmUYBCABKAJSCmRyaWZ0U2NvcmUSJQoOZHJpZnRfc2V2ZXJpdHkYBSABKA'
    'lSDWRyaWZ0U2V2ZXJpdHkSHQoKaXNfYmxvY2tlZBgGIAEoCFIJaXNCbG9ja2VkEisKEXZpb2xh'
    'dGlvbl9yZWFzb25zGAcgAygJUhB2aW9sYXRpb25SZWFzb25zEiEKDGRldGFpbHNfanNvbhgIIA'
    'EoCVILZGV0YWlsc0pzb24SIQoMdmlvbGF0aW9uX2lkGAkgASgJUgt2aW9sYXRpb25JZA==');

@$core.Deprecated('Use evaluateDriftRequestDescriptor instead')
const EvaluateDriftRequest$json = {
  '1': 'EvaluateDriftRequest',
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
    {'1': 'pack_id', '3': 3, '4': 1, '5': 9, '10': 'packId'},
  ],
};

/// Descriptor for `EvaluateDriftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateDriftRequestDescriptor = $convert.base64Decode(
    'ChRFdmFsdWF0ZURyaWZ0UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY2'
    '9tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhkKCGFzc2V0X2lkGAIgASgJUgdhc3Nl'
    'dElkEhcKB3BhY2tfaWQYAyABKAlSBnBhY2tJZA==');

@$core.Deprecated('Use evaluateDriftResponseDescriptor instead')
const EvaluateDriftResponse$json = {
  '1': 'EvaluateDriftResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.DriftEvaluationResult',
      '10': 'result'
    },
  ],
};

/// Descriptor for `EvaluateDriftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateDriftResponseDescriptor = $convert.base64Decode(
    'ChVFdmFsdWF0ZURyaWZ0UmVzcG9uc2USSAoGcmVzdWx0GAEgASgLMjAuY3JlYXRpdmFudGEucH'
    'JvZHVjdGlvbi52MS5EcmlmdEV2YWx1YXRpb25SZXN1bHRSBnJlc3VsdA==');

@$core.Deprecated('Use overrideDriftViolationRequestDescriptor instead')
const OverrideDriftViolationRequest$json = {
  '1': 'OverrideDriftViolationRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'violation_id', '3': 2, '4': 1, '5': 9, '10': 'violationId'},
    {'1': 'override_reason', '3': 3, '4': 1, '5': 9, '10': 'overrideReason'},
  ],
};

/// Descriptor for `OverrideDriftViolationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideDriftViolationRequestDescriptor = $convert.base64Decode(
    'Ch1PdmVycmlkZURyaWZ0VmlvbGF0aW9uUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHZpb2xhdGlvbl9p'
    'ZBgCIAEoCVILdmlvbGF0aW9uSWQSJwoPb3ZlcnJpZGVfcmVhc29uGAMgASgJUg5vdmVycmlkZV'
    'JlYXNvbg==');

@$core.Deprecated('Use overrideDriftViolationResponseDescriptor instead')
const OverrideDriftViolationResponse$json = {
  '1': 'OverrideDriftViolationResponse',
  '2': [
    {'1': 'resolved', '3': 1, '4': 1, '5': 8, '10': 'resolved'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'new_quality_state', '3': 3, '4': 1, '5': 9, '10': 'newQualityState'},
  ],
};

/// Descriptor for `OverrideDriftViolationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideDriftViolationResponseDescriptor =
    $convert.base64Decode(
        'Ch5PdmVycmlkZURyaWZ0VmlvbGF0aW9uUmVzcG9uc2USGgoIcmVzb2x2ZWQYASABKAhSCHJlc2'
        '9sdmVkEhkKCGFzc2V0X2lkGAIgASgJUgdhc3NldElkEioKEW5ld19xdWFsaXR5X3N0YXRlGAMg'
        'ASgJUg9uZXdRdWFsaXR5U3RhdGU=');

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
    'YXRlZF9hdBgaIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

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

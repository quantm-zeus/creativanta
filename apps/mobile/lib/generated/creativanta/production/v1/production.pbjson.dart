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

@$core.Deprecated('Use transcriptAlignmentStatusDescriptor instead')
const TranscriptAlignmentStatus$json = {
  '1': 'TranscriptAlignmentStatus',
  '2': [
    {'1': 'TRANSCRIPT_ALIGNMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TRANSCRIPT_ALIGNMENT_STATUS_AUTO_ALIGNED', '2': 1},
    {'1': 'TRANSCRIPT_ALIGNMENT_STATUS_REPAIRED', '2': 2},
    {'1': 'TRANSCRIPT_ALIGNMENT_STATUS_MANUAL_FALLBACK', '2': 3},
    {'1': 'TRANSCRIPT_ALIGNMENT_STATUS_FAILED', '2': 4},
  ],
};

/// Descriptor for `TranscriptAlignmentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List transcriptAlignmentStatusDescriptor = $convert.base64Decode(
    'ChlUcmFuc2NyaXB0QWxpZ25tZW50U3RhdHVzEisKJ1RSQU5TQ1JJUFRfQUxJR05NRU5UX1NUQV'
    'RVU19VTlNQRUNJRklFRBAAEiwKKFRSQU5TQ1JJUFRfQUxJR05NRU5UX1NUQVRVU19BVVRPX0FM'
    'SUdORUQQARIoCiRUUkFOU0NSSVBUX0FMSUdOTUVOVF9TVEFUVVNfUkVQQUlSRUQQAhIvCitUUk'
    'FOU0NSSVBUX0FMSUdOTUVOVF9TVEFUVVNfTUFOVUFMX0ZBTExCQUNLEAMSJgoiVFJBTlNDUklQ'
    'VF9BTElHTk1FTlRfU1RBVFVTX0ZBSUxFRBAE');

@$core.Deprecated('Use imageMotionStyleDescriptor instead')
const ImageMotionStyle$json = {
  '1': 'ImageMotionStyle',
  '2': [
    {'1': 'IMAGE_MOTION_STYLE_UNSPECIFIED', '2': 0},
    {'1': 'IMAGE_MOTION_STYLE_CINEMATIC_PAN', '2': 1},
    {'1': 'IMAGE_MOTION_STYLE_PRODUCT_ROTATE', '2': 2},
    {'1': 'IMAGE_MOTION_STYLE_PARALLAX_3D', '2': 3},
    {'1': 'IMAGE_MOTION_STYLE_SUBTLE_MOVEMENT', '2': 4},
    {'1': 'IMAGE_MOTION_STYLE_ZOOM_IN', '2': 5},
    {'1': 'IMAGE_MOTION_STYLE_CUSTOM_PROMPT', '2': 6},
    {'1': 'IMAGE_MOTION_STYLE_KEN_BURNS', '2': 7},
    {'1': 'IMAGE_MOTION_STYLE_MORPH', '2': 8},
    {'1': 'IMAGE_MOTION_STYLE_RANDOM', '2': 9},
  ],
};

/// Descriptor for `ImageMotionStyle`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List imageMotionStyleDescriptor = $convert.base64Decode(
    'ChBJbWFnZU1vdGlvblN0eWxlEiIKHklNQUdFX01PVElPTl9TVFlMRV9VTlNQRUNJRklFRBAAEi'
    'QKIElNQUdFX01PVElPTl9TVFlMRV9DSU5FTUFUSUNfUEFOEAESJQohSU1BR0VfTU9USU9OX1NU'
    'WUxFX1BST0RVQ1RfUk9UQVRFEAISIgoeSU1BR0VfTU9USU9OX1NUWUxFX1BBUkFMTEFYXzNEEA'
    'MSJgoiSU1BR0VfTU9USU9OX1NUWUxFX1NVQlRMRV9NT1ZFTUVOVBAEEh4KGklNQUdFX01PVElP'
    'Tl9TVFlMRV9aT09NX0lOEAUSJAogSU1BR0VfTU9USU9OX1NUWUxFX0NVU1RPTV9QUk9NUFQQBh'
    'IgChxJTUFHRV9NT1RJT05fU1RZTEVfS0VOX0JVUk5TEAcSHAoYSU1BR0VfTU9USU9OX1NUWUxF'
    'X01PUlBIEAgSHQoZSU1BR0VfTU9USU9OX1NUWUxFX1JBTkRPTRAJ');

@$core.Deprecated('Use thumbnailTemplateStyleDescriptor instead')
const ThumbnailTemplateStyle$json = {
  '1': 'ThumbnailTemplateStyle',
  '2': [
    {'1': 'THUMBNAIL_TEMPLATE_STYLE_UNSPECIFIED', '2': 0},
    {'1': 'THUMBNAIL_TEMPLATE_STYLE_EMOTION', '2': 1},
    {'1': 'THUMBNAIL_TEMPLATE_STYLE_YOUTUBE', '2': 2},
    {'1': 'THUMBNAIL_TEMPLATE_STYLE_SPLIT', '2': 3},
    {'1': 'THUMBNAIL_TEMPLATE_STYLE_CLICKBAIT', '2': 4},
    {'1': 'THUMBNAIL_TEMPLATE_STYLE_CLEAN', '2': 5},
  ],
};

/// Descriptor for `ThumbnailTemplateStyle`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List thumbnailTemplateStyleDescriptor = $convert.base64Decode(
    'ChZUaHVtYm5haWxUZW1wbGF0ZVN0eWxlEigKJFRIVU1CTkFJTF9URU1QTEFURV9TVFlMRV9VTl'
    'NQRUNJRklFRBAAEiQKIFRIVU1CTkFJTF9URU1QTEFURV9TVFlMRV9FTU9USU9OEAESJAogVEhV'
    'TUJOQUlMX1RFTVBMQVRFX1NUWUxFX1lPVVRVQkUQAhIiCh5USFVNQk5BSUxfVEVNUExBVEVfU1'
    'RZTEVfU1BMSVQQAxImCiJUSFVNQk5BSUxfVEVNUExBVEVfU1RZTEVfQ0xJQ0tCQUlUEAQSIgoe'
    'VEhVTUJOQUlMX1RFTVBMQVRFX1NUWUxFX0NMRUFOEAU=');

@$core.Deprecated('Use showcaseStyleDescriptor instead')
const ShowcaseStyle$json = {
  '1': 'ShowcaseStyle',
  '2': [
    {'1': 'SHOWCASE_STYLE_UNSPECIFIED', '2': 0},
    {'1': 'SHOWCASE_STYLE_360_SPIN', '2': 1},
    {'1': 'SHOWCASE_STYLE_TABLETOP_DEMO', '2': 2},
    {'1': 'SHOWCASE_STYLE_FLIP_REVEAL', '2': 3},
    {'1': 'SHOWCASE_STYLE_VIRTUAL_TRY_ON', '2': 4},
    {'1': 'SHOWCASE_STYLE_LIFESTYLE_CONTEXT', '2': 5},
    {'1': 'SHOWCASE_STYLE_UNBOXING_SIMULATION', '2': 6},
    {'1': 'SHOWCASE_STYLE_BEFORE_AFTER', '2': 7},
    {'1': 'SHOWCASE_STYLE_REVIEW_STYLE', '2': 8},
  ],
};

/// Descriptor for `ShowcaseStyle`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List showcaseStyleDescriptor = $convert.base64Decode(
    'Cg1TaG93Y2FzZVN0eWxlEh4KGlNIT1dDQVNFX1NUWUxFX1VOU1BFQ0lGSUVEEAASGwoXU0hPV0'
    'NBU0VfU1RZTEVfMzYwX1NQSU4QARIgChxTSE9XQ0FTRV9TVFlMRV9UQUJMRVRPUF9ERU1PEAIS'
    'HgoaU0hPV0NBU0VfU1RZTEVfRkxJUF9SRVZFQUwQAxIhCh1TSE9XQ0FTRV9TVFlMRV9WSVJUVU'
    'FMX1RSWV9PThAEEiQKIFNIT1dDQVNFX1NUWUxFX0xJRkVTVFlMRV9DT05URVhUEAUSJgoiU0hP'
    'V0NBU0VfU1RZTEVfVU5CT1hJTkdfU0lNVUxBVElPThAGEh8KG1NIT1dDQVNFX1NUWUxFX0JFRk'
    '9SRV9BRlRFUhAHEh8KG1NIT1dDQVNFX1NUWUxFX1JFVklFV19TVFlMRRAI');

@$core.Deprecated('Use scriptTemplateDescriptor instead')
const ScriptTemplate$json = {
  '1': 'ScriptTemplate',
  '2': [
    {'1': 'SCRIPT_TEMPLATE_UNSPECIFIED', '2': 0},
    {'1': 'SCRIPT_TEMPLATE_PROBLEM_SOLUTION', '2': 1},
    {'1': 'SCRIPT_TEMPLATE_LISTICLE_REVIEW', '2': 2},
    {'1': 'SCRIPT_TEMPLATE_TESTIMONIAL', '2': 3},
    {'1': 'SCRIPT_TEMPLATE_FLASH_SALE', '2': 4},
    {'1': 'SCRIPT_TEMPLATE_COMPARISON', '2': 5},
  ],
};

/// Descriptor for `ScriptTemplate`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List scriptTemplateDescriptor = $convert.base64Decode(
    'Cg5TY3JpcHRUZW1wbGF0ZRIfChtTQ1JJUFRfVEVNUExBVEVfVU5TUEVDSUZJRUQQABIkCiBTQ1'
    'JJUFRfVEVNUExBVEVfUFJPQkxFTV9TT0xVVElPThABEiMKH1NDUklQVF9URU1QTEFURV9MSVNU'
    'SUNMRV9SRVZJRVcQAhIfChtTQ1JJUFRfVEVNUExBVEVfVEVTVElNT05JQUwQAxIeChpTQ1JJUF'
    'RfVEVNUExBVEVfRkxBU0hfU0FMRRAEEh4KGlNDUklQVF9URU1QTEFURV9DT01QQVJJU09OEAU=');

@$core.Deprecated('Use linkPlatformDescriptor instead')
const LinkPlatform$json = {
  '1': 'LinkPlatform',
  '2': [
    {'1': 'LINK_PLATFORM_UNSPECIFIED', '2': 0},
    {'1': 'LINK_PLATFORM_SHOPEE', '2': 1},
    {'1': 'LINK_PLATFORM_LAZADA', '2': 2},
    {'1': 'LINK_PLATFORM_TIKTOK_SHOP', '2': 3},
    {'1': 'LINK_PLATFORM_AMAZON', '2': 4},
    {'1': 'LINK_PLATFORM_SHOPIFY', '2': 5},
    {'1': 'LINK_PLATFORM_GENERIC', '2': 6},
  ],
};

/// Descriptor for `LinkPlatform`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List linkPlatformDescriptor = $convert.base64Decode(
    'CgxMaW5rUGxhdGZvcm0SHQoZTElOS19QTEFURk9STV9VTlNQRUNJRklFRBAAEhgKFExJTktfUE'
    'xBVEZPUk1fU0hPUEVFEAESGAoUTElOS19QTEFURk9STV9MQVpBREEQAhIdChlMSU5LX1BMQVRG'
    'T1JNX1RJS1RPS19TSE9QEAMSGAoUTElOS19QTEFURk9STV9BTUFaT04QBBIZChVMSU5LX1BMQV'
    'RGT1JNX1NIT1BJRlkQBRIZChVMSU5LX1BMQVRGT1JNX0dFTkVSSUMQBg==');

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
    {'1': 'trend_id', '3': 9, '4': 1, '5': 9, '10': 'trendId'},
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
    'b3JkZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0Eh'
    'kKCHRyZW5kX2lkGAkgASgJUgd0cmVuZElk');

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
    {
      '1': 'image_to_video_config',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ImageToVideoConfig',
      '10': 'imageToVideoConfig'
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
    'YXRjaEl0ZW1zEmAKFWltYWdlX3RvX3ZpZGVvX2NvbmZpZxgRIAEoCzItLmNyZWF0aXZhbnRhLn'
    'Byb2R1Y3Rpb24udjEuSW1hZ2VUb1ZpZGVvQ29uZmlnUhJpbWFnZVRvVmlkZW9Db25maWc=');

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

@$core.Deprecated('Use transcriptWordDescriptor instead')
const TranscriptWord$json = {
  '1': 'TranscriptWord',
  '2': [
    {'1': 'word_id', '3': 1, '4': 1, '5': 9, '10': 'wordId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'start_ms', '3': 3, '4': 1, '5': 3, '10': 'startMs'},
    {'1': 'end_ms', '3': 4, '4': 1, '5': 3, '10': 'endMs'},
    {'1': 'confidence', '3': 5, '4': 1, '5': 1, '10': 'confidence'},
    {'1': 'is_filler', '3': 6, '4': 1, '5': 8, '10': 'isFiller'},
    {'1': 'filler_type', '3': 7, '4': 1, '5': 9, '10': 'fillerType'},
    {'1': 'is_deleted', '3': 8, '4': 1, '5': 8, '10': 'isDeleted'},
  ],
};

/// Descriptor for `TranscriptWord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptWordDescriptor = $convert.base64Decode(
    'Cg5UcmFuc2NyaXB0V29yZBIXCgd3b3JkX2lkGAEgASgJUgZ3b3JkSWQSEgoEdGV4dBgCIAEoCV'
    'IEdGV4dBIZCghzdGFydF9tcxgDIAEoA1IHc3RhcnRNcxIVCgZlbmRfbXMYBCABKANSBWVuZE1z'
    'Eh4KCmNvbmZpZGVuY2UYBSABKAFSCmNvbmZpZGVuY2USGwoJaXNfZmlsbGVyGAYgASgIUghpc0'
    'ZpbGxlchIfCgtmaWxsZXJfdHlwZRgHIAEoCVIKZmlsbGVyVHlwZRIdCgppc19kZWxldGVkGAgg'
    'ASgIUglpc0RlbGV0ZWQ=');

@$core.Deprecated('Use transcriptSegmentDescriptor instead')
const TranscriptSegment$json = {
  '1': 'TranscriptSegment',
  '2': [
    {'1': 'segment_id', '3': 1, '4': 1, '5': 9, '10': 'segmentId'},
    {'1': 'start_ms', '3': 2, '4': 1, '5': 3, '10': 'startMs'},
    {'1': 'end_ms', '3': 3, '4': 1, '5': 3, '10': 'endMs'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
    {'1': 'speaker_id', '3': 5, '4': 1, '5': 9, '10': 'speakerId'},
  ],
};

/// Descriptor for `TranscriptSegment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptSegmentDescriptor = $convert.base64Decode(
    'ChFUcmFuc2NyaXB0U2VnbWVudBIdCgpzZWdtZW50X2lkGAEgASgJUglzZWdtZW50SWQSGQoIc3'
    'RhcnRfbXMYAiABKANSB3N0YXJ0TXMSFQoGZW5kX21zGAMgASgDUgVlbmRNcxISCgR0ZXh0GAQg'
    'ASgJUgR0ZXh0Eh0KCnNwZWFrZXJfaWQYBSABKAlSCXNwZWFrZXJJZA==');

@$core.Deprecated('Use transcriptDescriptor instead')
const Transcript$json = {
  '1': 'Transcript',
  '2': [
    {'1': 'transcript_id', '3': 1, '4': 1, '5': 9, '10': 'transcriptId'},
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'language', '3': 4, '4': 1, '5': 9, '10': 'language'},
    {'1': 'raw_text', '3': 5, '4': 1, '5': 9, '10': 'rawText'},
    {
      '1': 'words',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranscriptWord',
      '10': 'words'
    },
    {
      '1': 'segments',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.TranscriptSegment',
      '10': 'segments'
    },
    {'1': 'filler_count', '3': 8, '4': 1, '5': 5, '10': 'fillerCount'},
    {'1': 'pause_count', '3': 9, '4': 1, '5': 5, '10': 'pauseCount'},
    {
      '1': 'alignment_status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.TranscriptAlignmentStatus',
      '10': 'alignmentStatus'
    },
    {'1': 'alignment_error', '3': 11, '4': 1, '5': 9, '10': 'alignmentError'},
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

/// Descriptor for `Transcript`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptDescriptor = $convert.base64Decode(
    'CgpUcmFuc2NyaXB0EiMKDXRyYW5zY3JpcHRfaWQYASABKAlSDHRyYW5zY3JpcHRJZBI+Cgx3b3'
    'Jrc3BhY2VfaWQYAiABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNl'
    'SWQSGQoIYXNzZXRfaWQYAyABKAlSB2Fzc2V0SWQSGgoIbGFuZ3VhZ2UYBCABKAlSCGxhbmd1YW'
    'dlEhkKCHJhd190ZXh0GAUgASgJUgdyYXdUZXh0Ej8KBXdvcmRzGAYgAygLMikuY3JlYXRpdmFu'
    'dGEucHJvZHVjdGlvbi52MS5UcmFuc2NyaXB0V29yZFIFd29yZHMSSAoIc2VnbWVudHMYByADKA'
    'syLC5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlRyYW5zY3JpcHRTZWdtZW50UghzZWdtZW50'
    'cxIhCgxmaWxsZXJfY291bnQYCCABKAVSC2ZpbGxlckNvdW50Eh8KC3BhdXNlX2NvdW50GAkgAS'
    'gFUgpwYXVzZUNvdW50El8KEGFsaWdubWVudF9zdGF0dXMYCiABKA4yNC5jcmVhdGl2YW50YS5w'
    'cm9kdWN0aW9uLnYxLlRyYW5zY3JpcHRBbGlnbm1lbnRTdGF0dXNSD2FsaWdubWVudFN0YXR1cx'
    'InCg9hbGlnbm1lbnRfZXJyb3IYCyABKAlSDmFsaWdubWVudEVycm9yEjkKCmNyZWF0ZWRfYXQY'
    'DCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF'
    '9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use deadPauseDescriptor instead')
const DeadPause$json = {
  '1': 'DeadPause',
  '2': [
    {'1': 'start_ms', '3': 1, '4': 1, '5': 3, '10': 'startMs'},
    {'1': 'end_ms', '3': 2, '4': 1, '5': 3, '10': 'endMs'},
    {'1': 'duration_ms', '3': 3, '4': 1, '5': 3, '10': 'durationMs'},
  ],
};

/// Descriptor for `DeadPause`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deadPauseDescriptor = $convert.base64Decode(
    'CglEZWFkUGF1c2USGQoIc3RhcnRfbXMYASABKANSB3N0YXJ0TXMSFQoGZW5kX21zGAIgASgDUg'
    'VlbmRNcxIfCgtkdXJhdGlvbl9tcxgDIAEoA1IKZHVyYXRpb25Ncw==');

@$core.Deprecated('Use transcriptAnalysisDescriptor instead')
const TranscriptAnalysis$json = {
  '1': 'TranscriptAnalysis',
  '2': [
    {'1': 'filler_count', '3': 1, '4': 1, '5': 5, '10': 'fillerCount'},
    {'1': 'pause_count', '3': 2, '4': 1, '5': 5, '10': 'pauseCount'},
    {
      '1': 'hook_quality_score',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'hookQualityScore'
    },
    {
      '1': 'estimated_time_saved_ms',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'estimatedTimeSavedMs'
    },
    {'1': 'final_duration_ms', '3': 5, '4': 1, '5': 3, '10': 'finalDurationMs'},
    {'1': 'detected_fillers', '3': 6, '4': 3, '5': 9, '10': 'detectedFillers'},
    {
      '1': 'dead_pauses',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.DeadPause',
      '10': 'deadPauses'
    },
    {'1': 'hook_feedback', '3': 8, '4': 1, '5': 9, '10': 'hookFeedback'},
  ],
};

/// Descriptor for `TranscriptAnalysis`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptAnalysisDescriptor = $convert.base64Decode(
    'ChJUcmFuc2NyaXB0QW5hbHlzaXMSIQoMZmlsbGVyX2NvdW50GAEgASgFUgtmaWxsZXJDb3VudB'
    'IfCgtwYXVzZV9jb3VudBgCIAEoBVIKcGF1c2VDb3VudBIsChJob29rX3F1YWxpdHlfc2NvcmUY'
    'AyABKAFSEGhvb2tRdWFsaXR5U2NvcmUSNQoXZXN0aW1hdGVkX3RpbWVfc2F2ZWRfbXMYBCABKA'
    'NSFGVzdGltYXRlZFRpbWVTYXZlZE1zEioKEWZpbmFsX2R1cmF0aW9uX21zGAUgASgDUg9maW5h'
    'bER1cmF0aW9uTXMSKQoQZGV0ZWN0ZWRfZmlsbGVycxgGIAMoCVIPZGV0ZWN0ZWRGaWxsZXJzEk'
    'UKC2RlYWRfcGF1c2VzGAcgAygLMiQuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5EZWFkUGF1'
    'c2VSCmRlYWRQYXVzZXMSIwoNaG9va19mZWVkYmFjaxgIIAEoCVIMaG9va0ZlZWRiYWNr');

@$core.Deprecated('Use transcriptCorrectionDescriptor instead')
const TranscriptCorrection$json = {
  '1': 'TranscriptCorrection',
  '2': [
    {'1': 'word_id', '3': 1, '4': 1, '5': 9, '10': 'wordId'},
    {'1': 'corrected_text', '3': 2, '4': 1, '5': 9, '10': 'correctedText'},
    {'1': 'new_start_ms', '3': 3, '4': 1, '5': 3, '10': 'newStartMs'},
    {'1': 'new_end_ms', '3': 4, '4': 1, '5': 3, '10': 'newEndMs'},
    {'1': 'mark_cut', '3': 5, '4': 1, '5': 8, '10': 'markCut'},
  ],
};

/// Descriptor for `TranscriptCorrection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptCorrectionDescriptor = $convert.base64Decode(
    'ChRUcmFuc2NyaXB0Q29ycmVjdGlvbhIXCgd3b3JkX2lkGAEgASgJUgZ3b3JkSWQSJQoOY29ycm'
    'VjdGVkX3RleHQYAiABKAlSDWNvcnJlY3RlZFRleHQSIAoMbmV3X3N0YXJ0X21zGAMgASgDUgpu'
    'ZXdTdGFydE1zEhwKCm5ld19lbmRfbXMYBCABKANSCG5ld0VuZE1zEhkKCG1hcmtfY3V0GAUgAS'
    'gIUgdtYXJrQ3V0');

@$core.Deprecated('Use cutIntervalDescriptor instead')
const CutInterval$json = {
  '1': 'CutInterval',
  '2': [
    {'1': 'start_ms', '3': 1, '4': 1, '5': 3, '10': 'startMs'},
    {'1': 'end_ms', '3': 2, '4': 1, '5': 3, '10': 'endMs'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CutInterval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cutIntervalDescriptor = $convert.base64Decode(
    'CgtDdXRJbnRlcnZhbBIZCghzdGFydF9tcxgBIAEoA1IHc3RhcnRNcxIVCgZlbmRfbXMYAiABKA'
    'NSBWVuZE1zEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use quickEditAddonsDescriptor instead')
const QuickEditAddons$json = {
  '1': 'QuickEditAddons',
  '2': [
    {'1': 'auto_captions', '3': 1, '4': 1, '5': 8, '10': 'autoCaptions'},
    {'1': 'caption_style', '3': 2, '4': 1, '5': 9, '10': 'captionStyle'},
    {'1': 'add_hook', '3': 3, '4': 1, '5': 8, '10': 'addHook'},
    {'1': 'hook_id', '3': 4, '4': 1, '5': 9, '10': 'hookId'},
    {'1': 'hook_type', '3': 5, '4': 1, '5': 9, '10': 'hookType'},
    {'1': 'beat_sync', '3': 6, '4': 1, '5': 8, '10': 'beatSync'},
    {'1': 'sound_id', '3': 7, '4': 1, '5': 9, '10': 'soundId'},
    {'1': 'b_roll', '3': 8, '4': 1, '5': 8, '10': 'bRoll'},
    {'1': 'b_roll_scene', '3': 9, '4': 1, '5': 9, '10': 'bRollScene'},
    {'1': 'platform_preset', '3': 10, '4': 1, '5': 9, '10': 'platformPreset'},
    {
      '1': 'audio_enhancement',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'audioEnhancement'
    },
    {'1': 'target_lufs', '3': 12, '4': 1, '5': 1, '10': 'targetLufs'},
    {'1': 'reframe_ratio', '3': 13, '4': 1, '5': 9, '10': 'reframeRatio'},
  ],
};

/// Descriptor for `QuickEditAddons`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quickEditAddonsDescriptor = $convert.base64Decode(
    'Cg9RdWlja0VkaXRBZGRvbnMSIwoNYXV0b19jYXB0aW9ucxgBIAEoCFIMYXV0b0NhcHRpb25zEi'
    'MKDWNhcHRpb25fc3R5bGUYAiABKAlSDGNhcHRpb25TdHlsZRIZCghhZGRfaG9vaxgDIAEoCFIH'
    'YWRkSG9vaxIXCgdob29rX2lkGAQgASgJUgZob29rSWQSGwoJaG9va190eXBlGAUgASgJUghob2'
    '9rVHlwZRIbCgliZWF0X3N5bmMYBiABKAhSCGJlYXRTeW5jEhkKCHNvdW5kX2lkGAcgASgJUgdz'
    'b3VuZElkEhUKBmJfcm9sbBgIIAEoCFIFYlJvbGwSIAoMYl9yb2xsX3NjZW5lGAkgASgJUgpiUm'
    '9sbFNjZW5lEicKD3BsYXRmb3JtX3ByZXNldBgKIAEoCVIOcGxhdGZvcm1QcmVzZXQSKwoRYXVk'
    'aW9fZW5oYW5jZW1lbnQYCyABKAhSEGF1ZGlvRW5oYW5jZW1lbnQSHwoLdGFyZ2V0X2x1ZnMYDC'
    'ABKAFSCnRhcmdldEx1ZnMSIwoNcmVmcmFtZV9yYXRpbxgNIAEoCVIMcmVmcmFtZVJhdGlv');

@$core.Deprecated('Use quickEditPlanDescriptor instead')
const QuickEditPlan$json = {
  '1': 'QuickEditPlan',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'transcript_id', '3': 2, '4': 1, '5': 9, '10': 'transcriptId'},
    {
      '1': 'cuts',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.CutInterval',
      '10': 'cuts'
    },
    {
      '1': 'addons',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.QuickEditAddons',
      '10': 'addons'
    },
    {
      '1': 'estimated_credits',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'estimatedCredits'
    },
    {
      '1': 'balance_after_credits',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'balanceAfterCredits'
    },
  ],
};

/// Descriptor for `QuickEditPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quickEditPlanDescriptor = $convert.base64Decode(
    'Cg1RdWlja0VkaXRQbGFuEhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEiMKDXRyYW5zY3JpcH'
    'RfaWQYAiABKAlSDHRyYW5zY3JpcHRJZBI6CgRjdXRzGAMgAygLMiYuY3JlYXRpdmFudGEucHJv'
    'ZHVjdGlvbi52MS5DdXRJbnRlcnZhbFIEY3V0cxJCCgZhZGRvbnMYBCABKAsyKi5jcmVhdGl2YW'
    '50YS5wcm9kdWN0aW9uLnYxLlF1aWNrRWRpdEFkZG9uc1IGYWRkb25zEisKEWVzdGltYXRlZF9j'
    'cmVkaXRzGAUgASgJUhBlc3RpbWF0ZWRDcmVkaXRzEjIKFWJhbGFuY2VfYWZ0ZXJfY3JlZGl0cx'
    'gGIAEoCVITYmFsYW5jZUFmdGVyQ3JlZGl0cw==');

@$core.Deprecated('Use quickEditDraftDescriptor instead')
const QuickEditDraft$json = {
  '1': 'QuickEditDraft',
  '2': [
    {'1': 'draft_id', '3': 1, '4': 1, '5': 9, '10': 'draftId'},
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'transcript_id', '3': 4, '4': 1, '5': 9, '10': 'transcriptId'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'cuts',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.CutInterval',
      '10': 'cuts'
    },
    {
      '1': 'addons',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.QuickEditAddons',
      '10': 'addons'
    },
    {
      '1': 'estimated_credits',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'estimatedCredits'
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

/// Descriptor for `QuickEditDraft`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quickEditDraftDescriptor = $convert.base64Decode(
    'Cg5RdWlja0VkaXREcmFmdBIZCghkcmFmdF9pZBgBIAEoCVIHZHJhZnRJZBI+Cgx3b3Jrc3BhY2'
    'VfaWQYAiABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSGQoI'
    'YXNzZXRfaWQYAyABKAlSB2Fzc2V0SWQSIwoNdHJhbnNjcmlwdF9pZBgEIAEoCVIMdHJhbnNjcm'
    'lwdElkEhIKBG5hbWUYBSABKAlSBG5hbWUSOgoEY3V0cxgGIAMoCzImLmNyZWF0aXZhbnRhLnBy'
    'b2R1Y3Rpb24udjEuQ3V0SW50ZXJ2YWxSBGN1dHMSQgoGYWRkb25zGAcgASgLMiouY3JlYXRpdm'
    'FudGEucHJvZHVjdGlvbi52MS5RdWlja0VkaXRBZGRvbnNSBmFkZG9ucxIrChFlc3RpbWF0ZWRf'
    'Y3JlZGl0cxgIIAEoCVIQZXN0aW1hdGVkQ3JlZGl0cxI5CgpjcmVhdGVkX2F0GAkgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYCiABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use quickEditServiceSaveDraftRequestDescriptor instead')
const QuickEditServiceSaveDraftRequest$json = {
  '1': 'QuickEditServiceSaveDraftRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'draft_id', '3': 2, '4': 1, '5': 9, '10': 'draftId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'transcript_id', '3': 4, '4': 1, '5': 9, '10': 'transcriptId'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'cuts',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.CutInterval',
      '10': 'cuts'
    },
    {
      '1': 'addons',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.QuickEditAddons',
      '10': 'addons'
    },
    {
      '1': 'estimated_credits',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'estimatedCredits'
    },
  ],
};

/// Descriptor for `QuickEditServiceSaveDraftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quickEditServiceSaveDraftRequestDescriptor = $convert.base64Decode(
    'CiBRdWlja0VkaXRTZXJ2aWNlU2F2ZURyYWZ0UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
    'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhkKCGRyYWZ0X2lk'
    'GAIgASgJUgdkcmFmdElkEhkKCGFzc2V0X2lkGAMgASgJUgdhc3NldElkEiMKDXRyYW5zY3JpcH'
    'RfaWQYBCABKAlSDHRyYW5zY3JpcHRJZBISCgRuYW1lGAUgASgJUgRuYW1lEjoKBGN1dHMYBiAD'
    'KAsyJi5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkN1dEludGVydmFsUgRjdXRzEkIKBmFkZG'
    '9ucxgHIAEoCzIqLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuUXVpY2tFZGl0QWRkb25zUgZh'
    'ZGRvbnMSKwoRZXN0aW1hdGVkX2NyZWRpdHMYCCABKAlSEGVzdGltYXRlZENyZWRpdHM=');

@$core.Deprecated('Use quickEditServiceSaveDraftResponseDescriptor instead')
const QuickEditServiceSaveDraftResponse$json = {
  '1': 'QuickEditServiceSaveDraftResponse',
  '2': [
    {
      '1': 'draft',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.QuickEditDraft',
      '10': 'draft'
    },
  ],
};

/// Descriptor for `QuickEditServiceSaveDraftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quickEditServiceSaveDraftResponseDescriptor =
    $convert.base64Decode(
        'CiFRdWlja0VkaXRTZXJ2aWNlU2F2ZURyYWZ0UmVzcG9uc2USPwoFZHJhZnQYASABKAsyKS5jcm'
        'VhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlF1aWNrRWRpdERyYWZ0UgVkcmFmdA==');

@$core.Deprecated('Use beatSyncGridDescriptor instead')
const BeatSyncGrid$json = {
  '1': 'BeatSyncGrid',
  '2': [
    {'1': 'bpm', '3': 1, '4': 1, '5': 5, '10': 'bpm'},
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
    {'1': 'confidence', '3': 4, '4': 1, '5': 1, '10': 'confidence'},
  ],
};

/// Descriptor for `BeatSyncGrid`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List beatSyncGridDescriptor = $convert.base64Decode(
    'CgxCZWF0U3luY0dyaWQSEAoDYnBtGAEgASgFUgNicG0SLAoSYmVhdF90aW1lc3RhbXBzX21zGA'
    'IgAygDUhBiZWF0VGltZXN0YW1wc01zEjQKFmRvd25iZWF0X3RpbWVzdGFtcHNfbXMYAyADKANS'
    'FGRvd25iZWF0VGltZXN0YW1wc01zEh4KCmNvbmZpZGVuY2UYBCABKAFSCmNvbmZpZGVuY2U=');

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
    {'1': 'trend_id', '3': 17, '4': 1, '5': 9, '10': 'trendId'},
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
    'dG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSGQoIdHJlbmRfaWQYESABKAlSB3RyZW5kSWQ=');

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
    {'1': 'trend_id', '3': 9, '4': 1, '5': 9, '10': 'trendId'},
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
    'Zvcm1zEhkKCHRyZW5kX2lkGAkgASgJUgd0cmVuZElk');

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

@$core.Deprecated('Use viralityScoreBreakdownDescriptor instead')
const ViralityScoreBreakdown$json = {
  '1': 'ViralityScoreBreakdown',
  '2': [
    {
      '1': 'engagement_pattern_match',
      '3': 1,
      '4': 1,
      '5': 1,
      '10': 'engagementPatternMatch'
    },
    {'1': 'hook_strength', '3': 2, '4': 1, '5': 1, '10': 'hookStrength'},
    {'1': 'pacing_score', '3': 3, '4': 1, '5': 1, '10': 'pacingScore'},
    {'1': 'audio_quality', '3': 4, '4': 1, '5': 1, '10': 'audioQuality'},
    {
      '1': 'content_relevance',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'contentRelevance'
    },
    {'1': 'has_trend_data', '3': 6, '4': 1, '5': 8, '10': 'hasTrendData'},
    {'1': 'badge', '3': 7, '4': 1, '5': 9, '10': 'badge'},
    {
      '1': 'hook_analysis_method',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'hookAnalysisMethod'
    },
    {'1': 'total_score', '3': 9, '4': 1, '5': 1, '10': 'totalScore'},
  ],
};

/// Descriptor for `ViralityScoreBreakdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List viralityScoreBreakdownDescriptor = $convert.base64Decode(
    'ChZWaXJhbGl0eVNjb3JlQnJlYWtkb3duEjgKGGVuZ2FnZW1lbnRfcGF0dGVybl9tYXRjaBgBIA'
    'EoAVIWZW5nYWdlbWVudFBhdHRlcm5NYXRjaBIjCg1ob29rX3N0cmVuZ3RoGAIgASgBUgxob29r'
    'U3RyZW5ndGgSIQoMcGFjaW5nX3Njb3JlGAMgASgBUgtwYWNpbmdTY29yZRIjCg1hdWRpb19xdW'
    'FsaXR5GAQgASgBUgxhdWRpb1F1YWxpdHkSKwoRY29udGVudF9yZWxldmFuY2UYBSABKAFSEGNv'
    'bnRlbnRSZWxldmFuY2USJAoOaGFzX3RyZW5kX2RhdGEYBiABKAhSDGhhc1RyZW5kRGF0YRIUCg'
    'ViYWRnZRgHIAEoCVIFYmFkZ2USMAoUaG9va19hbmFseXNpc19tZXRob2QYCCABKAlSEmhvb2tB'
    'bmFseXNpc01ldGhvZBIfCgt0b3RhbF9zY29yZRgJIAEoAVIKdG90YWxTY29yZQ==');

@$core.Deprecated('Use clipProposalDescriptor instead')
const ClipProposal$json = {
  '1': 'ClipProposal',
  '2': [
    {'1': 'clip_id', '3': 1, '4': 1, '5': 9, '10': 'clipId'},
    {'1': 'clip_index', '3': 2, '4': 1, '5': 5, '10': 'clipIndex'},
    {'1': 'start_s', '3': 3, '4': 1, '5': 1, '10': 'startS'},
    {'1': 'end_s', '3': 4, '4': 1, '5': 1, '10': 'endS'},
    {'1': 'duration_s', '3': 5, '4': 1, '5': 1, '10': 'durationS'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'virality_score', '3': 7, '4': 1, '5': 1, '10': 'viralityScore'},
    {
      '1': 'virality_breakdown',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ViralityScoreBreakdown',
      '10': 'viralityBreakdown'
    },
    {'1': 'selected', '3': 9, '4': 1, '5': 8, '10': 'selected'},
    {'1': 'hook_type', '3': 10, '4': 1, '5': 9, '10': 'hookType'},
    {'1': 'pacing_label', '3': 11, '4': 1, '5': 9, '10': 'pacingLabel'},
    {'1': 'script_snippet', '3': 12, '4': 1, '5': 9, '10': 'scriptSnippet'},
    {
      '1': 'is_visual_only_fallback',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'isVisualOnlyFallback'
    },
    {'1': 'has_trend_data', '3': 14, '4': 1, '5': 8, '10': 'hasTrendData'},
    {'1': 'badge', '3': 15, '4': 1, '5': 9, '10': 'badge'},
    {'1': 'key_moments', '3': 16, '4': 3, '5': 9, '10': 'keyMoments'},
    {'1': 'source_asset_id', '3': 17, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {'1': 'thumbnail_url', '3': 18, '4': 1, '5': 9, '10': 'thumbnailUrl'},
  ],
};

/// Descriptor for `ClipProposal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipProposalDescriptor = $convert.base64Decode(
    'CgxDbGlwUHJvcG9zYWwSFwoHY2xpcF9pZBgBIAEoCVIGY2xpcElkEh0KCmNsaXBfaW5kZXgYAi'
    'ABKAVSCWNsaXBJbmRleBIXCgdzdGFydF9zGAMgASgBUgZzdGFydFMSEwoFZW5kX3MYBCABKAFS'
    'BGVuZFMSHQoKZHVyYXRpb25fcxgFIAEoAVIJZHVyYXRpb25TEhQKBXRpdGxlGAYgASgJUgV0aX'
    'RsZRIlCg52aXJhbGl0eV9zY29yZRgHIAEoAVINdmlyYWxpdHlTY29yZRJgChJ2aXJhbGl0eV9i'
    'cmVha2Rvd24YCCABKAsyMS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlZpcmFsaXR5U2Nvcm'
    'VCcmVha2Rvd25SEXZpcmFsaXR5QnJlYWtkb3duEhoKCHNlbGVjdGVkGAkgASgIUghzZWxlY3Rl'
    'ZBIbCglob29rX3R5cGUYCiABKAlSCGhvb2tUeXBlEiEKDHBhY2luZ19sYWJlbBgLIAEoCVILcG'
    'FjaW5nTGFiZWwSJQoOc2NyaXB0X3NuaXBwZXQYDCABKAlSDXNjcmlwdFNuaXBwZXQSNQoXaXNf'
    'dmlzdWFsX29ubHlfZmFsbGJhY2sYDSABKAhSFGlzVmlzdWFsT25seUZhbGxiYWNrEiQKDmhhc1'
    '90cmVuZF9kYXRhGA4gASgIUgxoYXNUcmVuZERhdGESFAoFYmFkZ2UYDyABKAlSBWJhZGdlEh8K'
    'C2tleV9tb21lbnRzGBAgAygJUgprZXlNb21lbnRzEiYKD3NvdXJjZV9hc3NldF9pZBgRIAEoCV'
    'INc291cmNlQXNzZXRJZBIjCg10aHVtYm5haWxfdXJsGBIgASgJUgx0aHVtYm5haWxVcmw=');

@$core.Deprecated('Use clipCollectionDescriptor instead')
const ClipCollection$json = {
  '1': 'ClipCollection',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'source_asset_id', '3': 3, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {'1': 'video_edit_job_id', '3': 4, '4': 1, '5': 9, '10': 'videoEditJobId'},
    {'1': 'total_clips', '3': 5, '4': 1, '5': 5, '10': 'totalClips'},
    {
      '1': 'clips',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ClipProposal',
      '10': 'clips'
    },
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
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
    {'1': 'has_trend_data', '3': 10, '4': 1, '5': 8, '10': 'hasTrendData'},
    {'1': 'is_visual_only', '3': 11, '4': 1, '5': 8, '10': 'isVisualOnly'},
    {'1': 'queue_position', '3': 12, '4': 1, '5': 5, '10': 'queuePosition'},
  ],
};

/// Descriptor for `ClipCollection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipCollectionDescriptor = $convert.base64Decode(
    'Cg5DbGlwQ29sbGVjdGlvbhIjCg1jb2xsZWN0aW9uX2lkGAEgASgJUgxjb2xsZWN0aW9uSWQSIQ'
    'oMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBImCg9zb3VyY2VfYXNzZXRfaWQYAyAB'
    'KAlSDXNvdXJjZUFzc2V0SWQSKQoRdmlkZW9fZWRpdF9qb2JfaWQYBCABKAlSDnZpZGVvRWRpdE'
    'pvYklkEh8KC3RvdGFsX2NsaXBzGAUgASgFUgp0b3RhbENsaXBzEj0KBWNsaXBzGAYgAygLMicu'
    'Y3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5DbGlwUHJvcG9zYWxSBWNsaXBzEhYKBnN0YXR1cx'
    'gHIAEoCVIGc3RhdHVzEjkKCmNyZWF0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCXVwZGF0ZWRBdBIkCg5oYXNfdHJlbmRfZGF0YRgKIAEoCFIMaGFzVHJlbmRE'
    'YXRhEiQKDmlzX3Zpc3VhbF9vbmx5GAsgASgIUgxpc1Zpc3VhbE9ubHkSJQoOcXVldWVfcG9zaX'
    'Rpb24YDCABKAVSDXF1ZXVlUG9zaXRpb24=');

@$core.Deprecated('Use clipVariantConfigDescriptor instead')
const ClipVariantConfig$json = {
  '1': 'ClipVariantConfig',
  '2': [
    {'1': 'clip_id', '3': 1, '4': 1, '5': 9, '10': 'clipId'},
    {'1': 'target_ratios', '3': 2, '4': 3, '5': 9, '10': 'targetRatios'},
    {'1': 'subtitle_first', '3': 3, '4': 1, '5': 8, '10': 'subtitleFirst'},
    {'1': 'cta_text', '3': 4, '4': 1, '5': 9, '10': 'ctaText'},
    {
      '1': 'generate_highlight_reel',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'generateHighlightReel'
    },
    {'1': 'target_platforms', '3': 6, '4': 3, '5': 9, '10': 'targetPlatforms'},
  ],
};

/// Descriptor for `ClipVariantConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipVariantConfigDescriptor = $convert.base64Decode(
    'ChFDbGlwVmFyaWFudENvbmZpZxIXCgdjbGlwX2lkGAEgASgJUgZjbGlwSWQSIwoNdGFyZ2V0X3'
    'JhdGlvcxgCIAMoCVIMdGFyZ2V0UmF0aW9zEiUKDnN1YnRpdGxlX2ZpcnN0GAMgASgIUg1zdWJ0'
    'aXRsZUZpcnN0EhkKCGN0YV90ZXh0GAQgASgJUgdjdGFUZXh0EjYKF2dlbmVyYXRlX2hpZ2hsaW'
    'dodF9yZWVsGAUgASgIUhVnZW5lcmF0ZUhpZ2hsaWdodFJlZWwSKQoQdGFyZ2V0X3BsYXRmb3Jt'
    'cxgGIAMoCVIPdGFyZ2V0UGxhdGZvcm1z');

@$core.Deprecated('Use processedClipOutputDescriptor instead')
const ProcessedClipOutput$json = {
  '1': 'ProcessedClipOutput',
  '2': [
    {'1': 'clip_id', '3': 1, '4': 1, '5': 9, '10': 'clipId'},
    {'1': 'output_asset_id', '3': 2, '4': 1, '5': 9, '10': 'outputAssetId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'aspect_ratio', '3': 4, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'variant_type', '3': 5, '4': 1, '5': 9, '10': 'variantType'},
    {'1': 'playback_url', '3': 6, '4': 1, '5': 9, '10': 'playbackUrl'},
    {'1': 'download_url', '3': 7, '4': 1, '5': 9, '10': 'downloadUrl'},
    {'1': 'virality_score', '3': 8, '4': 1, '5': 1, '10': 'viralityScore'},
    {'1': 'badge', '3': 9, '4': 1, '5': 9, '10': 'badge'},
    {'1': 'lineage_json', '3': 10, '4': 1, '5': 9, '10': 'lineageJson'},
    {'1': 'credits_used', '3': 11, '4': 1, '5': 9, '10': 'creditsUsed'},
    {'1': 'status', '3': 12, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `ProcessedClipOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processedClipOutputDescriptor = $convert.base64Decode(
    'ChNQcm9jZXNzZWRDbGlwT3V0cHV0EhcKB2NsaXBfaWQYASABKAlSBmNsaXBJZBImCg9vdXRwdX'
    'RfYXNzZXRfaWQYAiABKAlSDW91dHB1dEFzc2V0SWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEiEK'
    'DGFzcGVjdF9yYXRpbxgEIAEoCVILYXNwZWN0UmF0aW8SIQoMdmFyaWFudF90eXBlGAUgASgJUg'
    't2YXJpYW50VHlwZRIhCgxwbGF5YmFja191cmwYBiABKAlSC3BsYXliYWNrVXJsEiEKDGRvd25s'
    'b2FkX3VybBgHIAEoCVILZG93bmxvYWRVcmwSJQoOdmlyYWxpdHlfc2NvcmUYCCABKAFSDXZpcm'
    'FsaXR5U2NvcmUSFAoFYmFkZ2UYCSABKAlSBWJhZGdlEiEKDGxpbmVhZ2VfanNvbhgKIAEoCVIL'
    'bGluZWFnZUpzb24SIQoMY3JlZGl0c191c2VkGAsgASgJUgtjcmVkaXRzVXNlZBIWCgZzdGF0dX'
    'MYDCABKAlSBnN0YXR1cw==');

@$core.Deprecated('Use clipFactoryServiceAnalyzeRequestDescriptor instead')
const ClipFactoryServiceAnalyzeRequest$json = {
  '1': 'ClipFactoryServiceAnalyzeRequest',
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
    {'1': 'video_url', '3': 3, '4': 1, '5': 9, '10': 'videoUrl'},
    {'1': 'video_duration_s', '3': 4, '4': 1, '5': 1, '10': 'videoDurationS'},
    {'1': 'force_visual_path', '3': 5, '4': 1, '5': 8, '10': 'forceVisualPath'},
    {'1': 'trend_topic_id', '3': 6, '4': 1, '5': 9, '10': 'trendTopicId'},
    {
      '1': 'has_mock_trend_data',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'hasMockTrendData'
    },
  ],
};

/// Descriptor for `ClipFactoryServiceAnalyzeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipFactoryServiceAnalyzeRequestDescriptor = $convert.base64Decode(
    'CiBDbGlwRmFjdG9yeVNlcnZpY2VBbmFseXplUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
    'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiYKD3NvdXJjZV9h'
    'c3NldF9pZBgCIAEoCVINc291cmNlQXNzZXRJZBIbCgl2aWRlb191cmwYAyABKAlSCHZpZGVvVX'
    'JsEigKEHZpZGVvX2R1cmF0aW9uX3MYBCABKAFSDnZpZGVvRHVyYXRpb25TEioKEWZvcmNlX3Zp'
    'c3VhbF9wYXRoGAUgASgIUg9mb3JjZVZpc3VhbFBhdGgSJAoOdHJlbmRfdG9waWNfaWQYBiABKA'
    'lSDHRyZW5kVG9waWNJZBItChNoYXNfbW9ja190cmVuZF9kYXRhGAcgASgIUhBoYXNNb2NrVHJl'
    'bmREYXRh');

@$core.Deprecated('Use clipFactoryServiceAnalyzeResponseDescriptor instead')
const ClipFactoryServiceAnalyzeResponse$json = {
  '1': 'ClipFactoryServiceAnalyzeResponse',
  '2': [
    {
      '1': 'collection',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ClipCollection',
      '10': 'collection'
    },
    {
      '1': 'estimated_credits',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'estimatedCredits'
    },
    {'1': 'queue_position', '3': 3, '4': 1, '5': 5, '10': 'queuePosition'},
  ],
};

/// Descriptor for `ClipFactoryServiceAnalyzeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipFactoryServiceAnalyzeResponseDescriptor =
    $convert.base64Decode(
        'CiFDbGlwRmFjdG9yeVNlcnZpY2VBbmFseXplUmVzcG9uc2USSQoKY29sbGVjdGlvbhgBIAEoCz'
        'IpLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuQ2xpcENvbGxlY3Rpb25SCmNvbGxlY3Rpb24S'
        'KwoRZXN0aW1hdGVkX2NyZWRpdHMYAiABKAlSEGVzdGltYXRlZENyZWRpdHMSJQoOcXVldWVfcG'
        '9zaXRpb24YAyABKAVSDXF1ZXVlUG9zaXRpb24=');

@$core
    .Deprecated('Use clipFactoryServiceGetCollectionRequestDescriptor instead')
const ClipFactoryServiceGetCollectionRequest$json = {
  '1': 'ClipFactoryServiceGetCollectionRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'collection_id', '3': 2, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'source_asset_id', '3': 3, '4': 1, '5': 9, '10': 'sourceAssetId'},
  ],
};

/// Descriptor for `ClipFactoryServiceGetCollectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipFactoryServiceGetCollectionRequestDescriptor =
    $convert.base64Decode(
        'CiZDbGlwRmFjdG9yeVNlcnZpY2VHZXRDb2xsZWN0aW9uUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaW'
        'QYASABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSIwoNY29s'
        'bGVjdGlvbl9pZBgCIAEoCVIMY29sbGVjdGlvbklkEiYKD3NvdXJjZV9hc3NldF9pZBgDIAEoCV'
        'INc291cmNlQXNzZXRJZA==');

@$core
    .Deprecated('Use clipFactoryServiceGetCollectionResponseDescriptor instead')
const ClipFactoryServiceGetCollectionResponse$json = {
  '1': 'ClipFactoryServiceGetCollectionResponse',
  '2': [
    {
      '1': 'collection',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ClipCollection',
      '10': 'collection'
    },
  ],
};

/// Descriptor for `ClipFactoryServiceGetCollectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipFactoryServiceGetCollectionResponseDescriptor =
    $convert.base64Decode(
        'CidDbGlwRmFjdG9yeVNlcnZpY2VHZXRDb2xsZWN0aW9uUmVzcG9uc2USSQoKY29sbGVjdGlvbh'
        'gBIAEoCzIpLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuQ2xpcENvbGxlY3Rpb25SCmNvbGxl'
        'Y3Rpb24=');

@$core.Deprecated('Use clipFactoryServiceProcessClipsRequestDescriptor instead')
const ClipFactoryServiceProcessClipsRequest$json = {
  '1': 'ClipFactoryServiceProcessClipsRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'collection_id', '3': 2, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'selected_clip_ids', '3': 3, '4': 3, '5': 9, '10': 'selectedClipIds'},
    {
      '1': 'variants',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ClipVariantConfig',
      '10': 'variants'
    },
    {'1': 'target_platforms', '3': 5, '4': 3, '5': 9, '10': 'targetPlatforms'},
  ],
};

/// Descriptor for `ClipFactoryServiceProcessClipsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipFactoryServiceProcessClipsRequestDescriptor = $convert.base64Decode(
    'CiVDbGlwRmFjdG9yeVNlcnZpY2VQcm9jZXNzQ2xpcHNSZXF1ZXN0Ej8KB2NvbnRleHQYASABKA'
    'syJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIwoNY29s'
    'bGVjdGlvbl9pZBgCIAEoCVIMY29sbGVjdGlvbklkEioKEXNlbGVjdGVkX2NsaXBfaWRzGAMgAy'
    'gJUg9zZWxlY3RlZENsaXBJZHMSSAoIdmFyaWFudHMYBCADKAsyLC5jcmVhdGl2YW50YS5wcm9k'
    'dWN0aW9uLnYxLkNsaXBWYXJpYW50Q29uZmlnUgh2YXJpYW50cxIpChB0YXJnZXRfcGxhdGZvcm'
    '1zGAUgAygJUg90YXJnZXRQbGF0Zm9ybXM=');

@$core
    .Deprecated('Use clipFactoryServiceProcessClipsResponseDescriptor instead')
const ClipFactoryServiceProcessClipsResponse$json = {
  '1': 'ClipFactoryServiceProcessClipsResponse',
  '2': [
    {'1': 'video_edit_job_id', '3': 1, '4': 1, '5': 9, '10': 'videoEditJobId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'total_outputs', '3': 3, '4': 1, '5': 5, '10': 'totalOutputs'},
    {
      '1': 'outputs',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ProcessedClipOutput',
      '10': 'outputs'
    },
    {'1': 'credits_deducted', '3': 5, '4': 1, '5': 9, '10': 'creditsDeducted'},
    {'1': 'queue_position', '3': 6, '4': 1, '5': 5, '10': 'queuePosition'},
  ],
};

/// Descriptor for `ClipFactoryServiceProcessClipsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clipFactoryServiceProcessClipsResponseDescriptor =
    $convert.base64Decode(
        'CiZDbGlwRmFjdG9yeVNlcnZpY2VQcm9jZXNzQ2xpcHNSZXNwb25zZRIpChF2aWRlb19lZGl0X2'
        'pvYl9pZBgBIAEoCVIOdmlkZW9FZGl0Sm9iSWQSFgoGc3RhdHVzGAIgASgJUgZzdGF0dXMSIwoN'
        'dG90YWxfb3V0cHV0cxgDIAEoBVIMdG90YWxPdXRwdXRzEkgKB291dHB1dHMYBCADKAsyLi5jcm'
        'VhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlByb2Nlc3NlZENsaXBPdXRwdXRSB291dHB1dHMSKQoQ'
        'Y3JlZGl0c19kZWR1Y3RlZBgFIAEoCVIPY3JlZGl0c0RlZHVjdGVkEiUKDnF1ZXVlX3Bvc2l0aW'
        '9uGAYgASgFUg1xdWV1ZVBvc2l0aW9u');

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

@$core.Deprecated('Use perImageMotionSettingDescriptor instead')
const PerImageMotionSetting$json = {
  '1': 'PerImageMotionSetting',
  '2': [
    {'1': 'image_url', '3': 1, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'duration_seconds', '3': 2, '4': 1, '5': 5, '10': 'durationSeconds'},
    {
      '1': 'motion_style',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ImageMotionStyle',
      '10': 'motionStyle'
    },
    {'1': 'focal_point', '3': 4, '4': 1, '5': 9, '10': 'focalPoint'},
  ],
};

/// Descriptor for `PerImageMotionSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List perImageMotionSettingDescriptor = $convert.base64Decode(
    'ChVQZXJJbWFnZU1vdGlvblNldHRpbmcSGwoJaW1hZ2VfdXJsGAEgASgJUghpbWFnZVVybBIpCh'
    'BkdXJhdGlvbl9zZWNvbmRzGAIgASgFUg9kdXJhdGlvblNlY29uZHMSTgoMbW90aW9uX3N0eWxl'
    'GAMgASgOMisuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5JbWFnZU1vdGlvblN0eWxlUgttb3'
    'Rpb25TdHlsZRIfCgtmb2NhbF9wb2ludBgEIAEoCVIKZm9jYWxQb2ludA==');

@$core.Deprecated('Use imageToVideoConfigDescriptor instead')
const ImageToVideoConfig$json = {
  '1': 'ImageToVideoConfig',
  '2': [
    {'1': 'image_urls', '3': 1, '4': 3, '5': 9, '10': 'imageUrls'},
    {
      '1': 'per_image_settings',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.PerImageMotionSetting',
      '10': 'perImageSettings'
    },
    {
      '1': 'default_motion_style',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ImageMotionStyle',
      '10': 'defaultMotionStyle'
    },
    {'1': 'duration_seconds', '3': 4, '4': 1, '5': 5, '10': 'durationSeconds'},
    {'1': 'loop_friendly', '3': 5, '4': 1, '5': 8, '10': 'loopFriendly'},
    {'1': 'auto_music_sync', '3': 6, '4': 1, '5': 8, '10': 'autoMusicSync'},
    {'1': 'transition_type', '3': 7, '4': 1, '5': 9, '10': 'transitionType'},
    {
      '1': 'transition_duration',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'transitionDuration'
    },
    {'1': 'background_music', '3': 9, '4': 1, '5': 9, '10': 'backgroundMusic'},
    {'1': 'music_volume', '3': 10, '4': 1, '5': 5, '10': 'musicVolume'},
    {
      '1': 'voice_over_character',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'voiceOverCharacter'
    },
    {
      '1': 'voice_over_script',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'voiceOverScript'
    },
    {'1': 'aspect_ratio', '3': 13, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'quality_tier', '3': 14, '4': 1, '5': 9, '10': 'qualityTier'},
  ],
};

/// Descriptor for `ImageToVideoConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageToVideoConfigDescriptor = $convert.base64Decode(
    'ChJJbWFnZVRvVmlkZW9Db25maWcSHQoKaW1hZ2VfdXJscxgBIAMoCVIJaW1hZ2VVcmxzEl4KEn'
    'Blcl9pbWFnZV9zZXR0aW5ncxgCIAMoCzIwLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuUGVy'
    'SW1hZ2VNb3Rpb25TZXR0aW5nUhBwZXJJbWFnZVNldHRpbmdzEl0KFGRlZmF1bHRfbW90aW9uX3'
    'N0eWxlGAMgASgOMisuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5JbWFnZU1vdGlvblN0eWxl'
    'UhJkZWZhdWx0TW90aW9uU3R5bGUSKQoQZHVyYXRpb25fc2Vjb25kcxgEIAEoBVIPZHVyYXRpb2'
    '5TZWNvbmRzEiMKDWxvb3BfZnJpZW5kbHkYBSABKAhSDGxvb3BGcmllbmRseRImCg9hdXRvX211'
    'c2ljX3N5bmMYBiABKAhSDWF1dG9NdXNpY1N5bmMSJwoPdHJhbnNpdGlvbl90eXBlGAcgASgJUg'
    '50cmFuc2l0aW9uVHlwZRIvChN0cmFuc2l0aW9uX2R1cmF0aW9uGAggASgBUhJ0cmFuc2l0aW9u'
    'RHVyYXRpb24SKQoQYmFja2dyb3VuZF9tdXNpYxgJIAEoCVIPYmFja2dyb3VuZE11c2ljEiEKDG'
    '11c2ljX3ZvbHVtZRgKIAEoBVILbXVzaWNWb2x1bWUSMAoUdm9pY2Vfb3Zlcl9jaGFyYWN0ZXIY'
    'CyABKAlSEnZvaWNlT3ZlckNoYXJhY3RlchIqChF2b2ljZV9vdmVyX3NjcmlwdBgMIAEoCVIPdm'
    '9pY2VPdmVyU2NyaXB0EiEKDGFzcGVjdF9yYXRpbxgNIAEoCVILYXNwZWN0UmF0aW8SIQoMcXVh'
    'bGl0eV90aWVyGA4gASgJUgtxdWFsaXR5VGllcg==');

@$core.Deprecated('Use cTRFactorBreakdownDescriptor instead')
const CTRFactorBreakdown$json = {
  '1': 'CTRFactorBreakdown',
  '2': [
    {
      '1': 'face_expression_score',
      '3': 1,
      '4': 1,
      '5': 1,
      '10': 'faceExpressionScore'
    },
    {
      '1': 'text_contrast_score',
      '3': 2,
      '4': 1,
      '5': 1,
      '10': 'textContrastScore'
    },
    {
      '1': 'color_vibrancy_score',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'colorVibrancyScore'
    },
    {
      '1': 'composition_score',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'compositionScore'
    },
    {
      '1': 'trending_match_score',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'trendingMatchScore'
    },
    {
      '1': 'total_predicted_ctr',
      '3': 6,
      '4': 1,
      '5': 1,
      '10': 'totalPredictedCtr'
    },
    {'1': 'level', '3': 7, '4': 1, '5': 9, '10': 'level'},
  ],
};

/// Descriptor for `CTRFactorBreakdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cTRFactorBreakdownDescriptor = $convert.base64Decode(
    'ChJDVFJGYWN0b3JCcmVha2Rvd24SMgoVZmFjZV9leHByZXNzaW9uX3Njb3JlGAEgASgBUhNmYW'
    'NlRXhwcmVzc2lvblNjb3JlEi4KE3RleHRfY29udHJhc3Rfc2NvcmUYAiABKAFSEXRleHRDb250'
    'cmFzdFNjb3JlEjAKFGNvbG9yX3ZpYnJhbmN5X3Njb3JlGAMgASgBUhJjb2xvclZpYnJhbmN5U2'
    'NvcmUSKwoRY29tcG9zaXRpb25fc2NvcmUYBCABKAFSEGNvbXBvc2l0aW9uU2NvcmUSMAoUdHJl'
    'bmRpbmdfbWF0Y2hfc2NvcmUYBSABKAFSEnRyZW5kaW5nTWF0Y2hTY29yZRIuChN0b3RhbF9wcm'
    'VkaWN0ZWRfY3RyGAYgASgBUhF0b3RhbFByZWRpY3RlZEN0chIUCgVsZXZlbBgHIAEoCVIFbGV2'
    'ZWw=');

@$core.Deprecated('Use textOverlayConfigDescriptor instead')
const TextOverlayConfig$json = {
  '1': 'TextOverlayConfig',
  '2': [
    {'1': 'headline', '3': 1, '4': 1, '5': 9, '10': 'headline'},
    {'1': 'font_family', '3': 2, '4': 1, '5': 9, '10': 'fontFamily'},
    {'1': 'font_size', '3': 3, '4': 1, '5': 5, '10': 'fontSize'},
    {'1': 'font_color', '3': 4, '4': 1, '5': 9, '10': 'fontColor'},
    {'1': 'position', '3': 5, '4': 1, '5': 9, '10': 'position'},
    {'1': 'outline', '3': 6, '4': 1, '5': 8, '10': 'outline'},
    {'1': 'shadow', '3': 7, '4': 1, '5': 8, '10': 'shadow'},
  ],
};

/// Descriptor for `TextOverlayConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textOverlayConfigDescriptor = $convert.base64Decode(
    'ChFUZXh0T3ZlcmxheUNvbmZpZxIaCghoZWFkbGluZRgBIAEoCVIIaGVhZGxpbmUSHwoLZm9udF'
    '9mYW1pbHkYAiABKAlSCmZvbnRGYW1pbHkSGwoJZm9udF9zaXplGAMgASgFUghmb250U2l6ZRId'
    'Cgpmb250X2NvbG9yGAQgASgJUglmb250Q29sb3ISGgoIcG9zaXRpb24YBSABKAlSCHBvc2l0aW'
    '9uEhgKB291dGxpbmUYBiABKAhSB291dGxpbmUSFgoGc2hhZG93GAcgASgIUgZzaGFkb3c=');

@$core.Deprecated('Use thumbnailVariantDescriptor instead')
const ThumbnailVariant$json = {
  '1': 'ThumbnailVariant',
  '2': [
    {'1': 'variant_id', '3': 1, '4': 1, '5': 9, '10': 'variantId'},
    {'1': 'image_url', '3': 2, '4': 1, '5': 9, '10': 'imageUrl'},
    {
      '1': 'style',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ThumbnailTemplateStyle',
      '10': 'style'
    },
    {
      '1': 'ctr_breakdown',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.CTRFactorBreakdown',
      '10': 'ctrBreakdown'
    },
    {
      '1': 'text_overlay',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.TextOverlayConfig',
      '10': 'textOverlay'
    },
    {'1': 'has_face_detected', '3': 6, '4': 1, '5': 8, '10': 'hasFaceDetected'},
  ],
};

/// Descriptor for `ThumbnailVariant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thumbnailVariantDescriptor = $convert.base64Decode(
    'ChBUaHVtYm5haWxWYXJpYW50Eh0KCnZhcmlhbnRfaWQYASABKAlSCXZhcmlhbnRJZBIbCglpbW'
    'FnZV91cmwYAiABKAlSCGltYWdlVXJsEkcKBXN0eWxlGAMgASgOMjEuY3JlYXRpdmFudGEucHJv'
    'ZHVjdGlvbi52MS5UaHVtYm5haWxUZW1wbGF0ZVN0eWxlUgVzdHlsZRJSCg1jdHJfYnJlYWtkb3'
    'duGAQgASgLMi0uY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5DVFJGYWN0b3JCcmVha2Rvd25S'
    'DGN0ckJyZWFrZG93bhJPCgx0ZXh0X292ZXJsYXkYBSABKAsyLC5jcmVhdGl2YW50YS5wcm9kdW'
    'N0aW9uLnYxLlRleHRPdmVybGF5Q29uZmlnUgt0ZXh0T3ZlcmxheRIqChFoYXNfZmFjZV9kZXRl'
    'Y3RlZBgGIAEoCFIPaGFzRmFjZURldGVjdGVk');

@$core.Deprecated('Use generateThumbnailsRequestDescriptor instead')
const GenerateThumbnailsRequest$json = {
  '1': 'GenerateThumbnailsRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'source_image_url', '3': 2, '4': 1, '5': 9, '10': 'sourceImageUrl'},
    {
      '1': 'source_video_asset_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'sourceVideoAssetId'
    },
    {
      '1': 'video_frame_timestamp_ms',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'videoFrameTimestampMs'
    },
    {'1': 'prompt', '3': 5, '4': 1, '5': 9, '10': 'prompt'},
    {
      '1': 'template_style',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ThumbnailTemplateStyle',
      '10': 'templateStyle'
    },
    {'1': 'variant_count', '3': 7, '4': 1, '5': 5, '10': 'variantCount'},
    {
      '1': 'text_overlay',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.TextOverlayConfig',
      '10': 'textOverlay'
    },
    {'1': 'quote_id', '3': 9, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
  ],
};

/// Descriptor for `GenerateThumbnailsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateThumbnailsRequestDescriptor = $convert.base64Decode(
    'ChlHZW5lcmF0ZVRodW1ibmFpbHNSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSKAoQc291cmNlX2ltYWdlX3Vy'
    'bBgCIAEoCVIOc291cmNlSW1hZ2VVcmwSMQoVc291cmNlX3ZpZGVvX2Fzc2V0X2lkGAMgASgJUh'
    'Jzb3VyY2VWaWRlb0Fzc2V0SWQSNwoYdmlkZW9fZnJhbWVfdGltZXN0YW1wX21zGAQgASgDUhV2'
    'aWRlb0ZyYW1lVGltZXN0YW1wTXMSFgoGcHJvbXB0GAUgASgJUgZwcm9tcHQSWAoOdGVtcGxhdG'
    'Vfc3R5bGUYBiABKA4yMS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlRodW1ibmFpbFRlbXBs'
    'YXRlU3R5bGVSDXRlbXBsYXRlU3R5bGUSIwoNdmFyaWFudF9jb3VudBgHIAEoBVIMdmFyaWFudE'
    'NvdW50Ek8KDHRleHRfb3ZlcmxheRgIIAEoCzIsLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEu'
    'VGV4dE92ZXJsYXlDb25maWdSC3RleHRPdmVybGF5EhkKCHF1b3RlX2lkGAkgASgJUgdxdW90ZU'
    'lkEisKEWNvbmZpcm1lZF9jcmVkaXRzGAogASgJUhBjb25maXJtZWRDcmVkaXRz');

@$core.Deprecated('Use generateThumbnailsResponseDescriptor instead')
const GenerateThumbnailsResponse$json = {
  '1': 'GenerateThumbnailsResponse',
  '2': [
    {
      '1': 'variants',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ThumbnailVariant',
      '10': 'variants'
    },
    {'1': 'credits_deducted', '3': 2, '4': 1, '5': 9, '10': 'creditsDeducted'},
    {'1': 'warnings', '3': 3, '4': 3, '5': 9, '10': 'warnings'},
  ],
};

/// Descriptor for `GenerateThumbnailsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateThumbnailsResponseDescriptor = $convert.base64Decode(
    'ChpHZW5lcmF0ZVRodW1ibmFpbHNSZXNwb25zZRJHCgh2YXJpYW50cxgBIAMoCzIrLmNyZWF0aX'
    'ZhbnRhLnByb2R1Y3Rpb24udjEuVGh1bWJuYWlsVmFyaWFudFIIdmFyaWFudHMSKQoQY3JlZGl0'
    'c19kZWR1Y3RlZBgCIAEoCVIPY3JlZGl0c0RlZHVjdGVkEhoKCHdhcm5pbmdzGAMgAygJUgh3YX'
    'JuaW5ncw==');

@$core.Deprecated('Use missingProductAttributeDescriptor instead')
const MissingProductAttribute$json = {
  '1': 'MissingProductAttribute',
  '2': [
    {'1': 'attribute', '3': 1, '4': 1, '5': 9, '10': 'attribute'},
    {'1': 'level', '3': 2, '4': 1, '5': 9, '10': 'level'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'actionable_recovery',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'actionableRecovery'
    },
  ],
};

/// Descriptor for `MissingProductAttribute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List missingProductAttributeDescriptor = $convert.base64Decode(
    'ChdNaXNzaW5nUHJvZHVjdEF0dHJpYnV0ZRIcCglhdHRyaWJ1dGUYASABKAlSCWF0dHJpYnV0ZR'
    'IUCgVsZXZlbBgCIAEoCVIFbGV2ZWwSGAoHbWVzc2FnZRgDIAEoCVIHbWVzc2FnZRIvChNhY3Rp'
    'b25hYmxlX3JlY292ZXJ5GAQgASgJUhJhY3Rpb25hYmxlUmVjb3Zlcnk=');

@$core.Deprecated('Use showcaseCustomizationDescriptor instead')
const ShowcaseCustomization$json = {
  '1': 'ShowcaseCustomization',
  '2': [
    {'1': 'background', '3': 1, '4': 1, '5': 9, '10': 'background'},
    {'1': 'duration', '3': 2, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'music', '3': 3, '4': 1, '5': 9, '10': 'music'},
    {'1': 'voice', '3': 4, '4': 1, '5': 9, '10': 'voice'},
    {'1': 'headline', '3': 5, '4': 1, '5': 9, '10': 'headline'},
    {'1': 'subtitle', '3': 6, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'cta', '3': 7, '4': 1, '5': 9, '10': 'cta'},
    {'1': 'aspect_ratio', '3': 8, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'pacing', '3': 9, '4': 1, '5': 9, '10': 'pacing'},
    {'1': 'color_grade', '3': 10, '4': 1, '5': 9, '10': 'colorGrade'},
    {
      '1': 'remove_background',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'removeBackground'
    },
  ],
};

/// Descriptor for `ShowcaseCustomization`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List showcaseCustomizationDescriptor = $convert.base64Decode(
    'ChVTaG93Y2FzZUN1c3RvbWl6YXRpb24SHgoKYmFja2dyb3VuZBgBIAEoCVIKYmFja2dyb3VuZB'
    'IaCghkdXJhdGlvbhgCIAEoBVIIZHVyYXRpb24SFAoFbXVzaWMYAyABKAlSBW11c2ljEhQKBXZv'
    'aWNlGAQgASgJUgV2b2ljZRIaCghoZWFkbGluZRgFIAEoCVIIaGVhZGxpbmUSGgoIc3VidGl0bG'
    'UYBiABKAlSCHN1YnRpdGxlEhAKA2N0YRgHIAEoCVIDY3RhEiEKDGFzcGVjdF9yYXRpbxgIIAEo'
    'CVILYXNwZWN0UmF0aW8SFgoGcGFjaW5nGAkgASgJUgZwYWNpbmcSHwoLY29sb3JfZ3JhZGUYCi'
    'ABKAlSCmNvbG9yR3JhZGUSKwoRcmVtb3ZlX2JhY2tncm91bmQYCyABKAhSEHJlbW92ZUJhY2tn'
    'cm91bmQ=');

@$core.Deprecated('Use productShowcaseJobDescriptor instead')
const ProductShowcaseJob$json = {
  '1': 'ProductShowcaseJob',
  '2': [
    {'1': 'showcase_job_id', '3': 1, '4': 1, '5': 9, '10': 'showcaseJobId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'video_edit_job_id', '3': 3, '4': 1, '5': 9, '10': 'videoEditJobId'},
    {'1': 'product_id', '3': 4, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'style',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ShowcaseStyle',
      '10': 'style'
    },
    {
      '1': 'customization',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ShowcaseCustomization',
      '10': 'customization'
    },
    {'1': 'batch_id', '3': 7, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'output_asset_id', '3': 8, '4': 1, '5': 9, '10': 'outputAssetId'},
    {'1': 'character_id', '3': 9, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'status', '3': 10, '4': 1, '5': 9, '10': 'status'},
    {'1': 'credits_used', '3': 11, '4': 1, '5': 9, '10': 'creditsUsed'},
    {
      '1': 'attribute_explanations',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.MissingProductAttribute',
      '10': 'attributeExplanations'
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
      '1': 'updated_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `ProductShowcaseJob`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseJobDescriptor = $convert.base64Decode(
    'ChJQcm9kdWN0U2hvd2Nhc2VKb2ISJgoPc2hvd2Nhc2Vfam9iX2lkGAEgASgJUg1zaG93Y2FzZU'
    'pvYklkEiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSKQoRdmlkZW9fZWRpdF9q'
    'b2JfaWQYAyABKAlSDnZpZGVvRWRpdEpvYklkEh0KCnByb2R1Y3RfaWQYBCABKAlSCXByb2R1Y3'
    'RJZBI+CgVzdHlsZRgFIAEoDjIoLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuU2hvd2Nhc2VT'
    'dHlsZVIFc3R5bGUSVgoNY3VzdG9taXphdGlvbhgGIAEoCzIwLmNyZWF0aXZhbnRhLnByb2R1Y3'
    'Rpb24udjEuU2hvd2Nhc2VDdXN0b21pemF0aW9uUg1jdXN0b21pemF0aW9uEhkKCGJhdGNoX2lk'
    'GAcgASgJUgdiYXRjaElkEiYKD291dHB1dF9hc3NldF9pZBgIIAEoCVINb3V0cHV0QXNzZXRJZB'
    'IhCgxjaGFyYWN0ZXJfaWQYCSABKAlSC2NoYXJhY3RlcklkEhYKBnN0YXR1cxgKIAEoCVIGc3Rh'
    'dHVzEiEKDGNyZWRpdHNfdXNlZBgLIAEoCVILY3JlZGl0c1VzZWQSaQoWYXR0cmlidXRlX2V4cG'
    'xhbmF0aW9ucxgMIAMoCzIyLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuTWlzc2luZ1Byb2R1'
    'Y3RBdHRyaWJ1dGVSFWF0dHJpYnV0ZUV4cGxhbmF0aW9ucxI5CgpjcmVhdGVkX2F0GA0gASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYDiAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use productShowcaseServiceCreateRequestDescriptor instead')
const ProductShowcaseServiceCreateRequest$json = {
  '1': 'ProductShowcaseServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'style',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ShowcaseStyle',
      '10': 'style'
    },
    {
      '1': 'customization',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ShowcaseCustomization',
      '10': 'customization'
    },
    {'1': 'character_id', '3': 5, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'manual_image_urls', '3': 6, '4': 3, '5': 9, '10': 'manualImageUrls'},
    {
      '1': 'manual_description',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'manualDescription'
    },
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

/// Descriptor for `ProductShowcaseServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseServiceCreateRequestDescriptor = $convert.base64Decode(
    'CiNQcm9kdWN0U2hvd2Nhc2VTZXJ2aWNlQ3JlYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMi'
    'UuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh0KCnByb2R1'
    'Y3RfaWQYAiABKAlSCXByb2R1Y3RJZBI+CgVzdHlsZRgDIAEoDjIoLmNyZWF0aXZhbnRhLnByb2'
    'R1Y3Rpb24udjEuU2hvd2Nhc2VTdHlsZVIFc3R5bGUSVgoNY3VzdG9taXphdGlvbhgEIAEoCzIw'
    'LmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuU2hvd2Nhc2VDdXN0b21pemF0aW9uUg1jdXN0b2'
    '1pemF0aW9uEiEKDGNoYXJhY3Rlcl9pZBgFIAEoCVILY2hhcmFjdGVySWQSKgoRbWFudWFsX2lt'
    'YWdlX3VybHMYBiADKAlSD21hbnVhbEltYWdlVXJscxItChJtYW51YWxfZGVzY3JpcHRpb24YBy'
    'ABKAlSEW1hbnVhbERlc2NyaXB0aW9uEhkKCHF1b3RlX2lkGAggASgJUgdxdW90ZUlkEisKEWNv'
    'bmZpcm1lZF9jcmVkaXRzGAkgASgJUhBjb25maXJtZWRDcmVkaXRz');

@$core.Deprecated('Use productShowcaseServiceCreateResponseDescriptor instead')
const ProductShowcaseServiceCreateResponse$json = {
  '1': 'ProductShowcaseServiceCreateResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ProductShowcaseJob',
      '10': 'job'
    },
    {
      '1': 'warnings',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.MissingProductAttribute',
      '10': 'warnings'
    },
    {
      '1': 'estimated_credits',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'estimatedCredits'
    },
  ],
};

/// Descriptor for `ProductShowcaseServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'CiRQcm9kdWN0U2hvd2Nhc2VTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USPwoDam9iGAEgASgLMi0uY3'
        'JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5Qcm9kdWN0U2hvd2Nhc2VKb2JSA2pvYhJOCgh3YXJu'
        'aW5ncxgCIAMoCzIyLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuTWlzc2luZ1Byb2R1Y3RBdH'
        'RyaWJ1dGVSCHdhcm5pbmdzEisKEWVzdGltYXRlZF9jcmVkaXRzGAMgASgJUhBlc3RpbWF0ZWRD'
        'cmVkaXRz');

@$core.Deprecated('Use productShowcaseBatchItemDescriptor instead')
const ProductShowcaseBatchItem$json = {
  '1': 'ProductShowcaseBatchItem',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'style',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ShowcaseStyle',
      '10': 'style'
    },
    {
      '1': 'customization',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ShowcaseCustomization',
      '10': 'customization'
    },
    {'1': 'character_id', '3': 4, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'manual_image_urls', '3': 5, '4': 3, '5': 9, '10': 'manualImageUrls'},
  ],
};

/// Descriptor for `ProductShowcaseBatchItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseBatchItemDescriptor = $convert.base64Decode(
    'ChhQcm9kdWN0U2hvd2Nhc2VCYXRjaEl0ZW0SHQoKcHJvZHVjdF9pZBgBIAEoCVIJcHJvZHVjdE'
    'lkEj4KBXN0eWxlGAIgASgOMiguY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5TaG93Y2FzZVN0'
    'eWxlUgVzdHlsZRJWCg1jdXN0b21pemF0aW9uGAMgASgLMjAuY3JlYXRpdmFudGEucHJvZHVjdG'
    'lvbi52MS5TaG93Y2FzZUN1c3RvbWl6YXRpb25SDWN1c3RvbWl6YXRpb24SIQoMY2hhcmFjdGVy'
    'X2lkGAQgASgJUgtjaGFyYWN0ZXJJZBIqChFtYW51YWxfaW1hZ2VfdXJscxgFIAMoCVIPbWFudW'
    'FsSW1hZ2VVcmxz');

@$core.Deprecated(
    'Use productShowcaseServiceCreateBatchRequestDescriptor instead')
const ProductShowcaseServiceCreateBatchRequest$json = {
  '1': 'ProductShowcaseServiceCreateBatchRequest',
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
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ProductShowcaseBatchItem',
      '10': 'items'
    },
    {'1': 'dry_run', '3': 3, '4': 1, '5': 8, '10': 'dryRun'},
    {'1': 'quote_id', '3': 4, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
  ],
};

/// Descriptor for `ProductShowcaseServiceCreateBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseServiceCreateBatchRequestDescriptor =
    $convert.base64Decode(
        'CihQcm9kdWN0U2hvd2Nhc2VTZXJ2aWNlQ3JlYXRlQmF0Y2hSZXF1ZXN0Ej8KB2NvbnRleHQYAS'
        'ABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSSQoF'
        'aXRlbXMYAiADKAsyMy5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlByb2R1Y3RTaG93Y2FzZU'
        'JhdGNoSXRlbVIFaXRlbXMSFwoHZHJ5X3J1bhgDIAEoCFIGZHJ5UnVuEhkKCHF1b3RlX2lkGAQg'
        'ASgJUgdxdW90ZUlkEisKEWNvbmZpcm1lZF9jcmVkaXRzGAUgASgJUhBjb25maXJtZWRDcmVkaX'
        'Rz');

@$core.Deprecated('Use productShowcaseBatchItemResultDescriptor instead')
const ProductShowcaseBatchItemResult$json = {
  '1': 'ProductShowcaseBatchItemResult',
  '2': [
    {'1': 'item_index', '3': 1, '4': 1, '5': 5, '10': 'itemIndex'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'valid', '3': 3, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'rejection_reason', '3': 4, '4': 1, '5': 9, '10': 'rejectionReason'},
    {
      '1': 'attribute_explanations',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.MissingProductAttribute',
      '10': 'attributeExplanations'
    },
    {'1': 'credits_required', '3': 6, '4': 1, '5': 9, '10': 'creditsRequired'},
    {'1': 'showcase_job_id', '3': 7, '4': 1, '5': 9, '10': 'showcaseJobId'},
  ],
};

/// Descriptor for `ProductShowcaseBatchItemResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseBatchItemResultDescriptor = $convert.base64Decode(
    'Ch5Qcm9kdWN0U2hvd2Nhc2VCYXRjaEl0ZW1SZXN1bHQSHQoKaXRlbV9pbmRleBgBIAEoBVIJaX'
    'RlbUluZGV4Eh0KCnByb2R1Y3RfaWQYAiABKAlSCXByb2R1Y3RJZBIUCgV2YWxpZBgDIAEoCFIF'
    'dmFsaWQSKQoQcmVqZWN0aW9uX3JlYXNvbhgEIAEoCVIPcmVqZWN0aW9uUmVhc29uEmkKFmF0dH'
    'JpYnV0ZV9leHBsYW5hdGlvbnMYBSADKAsyMi5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLk1p'
    'c3NpbmdQcm9kdWN0QXR0cmlidXRlUhVhdHRyaWJ1dGVFeHBsYW5hdGlvbnMSKQoQY3JlZGl0c1'
    '9yZXF1aXJlZBgGIAEoCVIPY3JlZGl0c1JlcXVpcmVkEiYKD3Nob3djYXNlX2pvYl9pZBgHIAEo'
    'CVINc2hvd2Nhc2VKb2JJZA==');

@$core.Deprecated(
    'Use productShowcaseServiceCreateBatchResponseDescriptor instead')
const ProductShowcaseServiceCreateBatchResponse$json = {
  '1': 'ProductShowcaseServiceCreateBatchResponse',
  '2': [
    {'1': 'batch_id', '3': 1, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'is_dry_run', '3': 2, '4': 1, '5': 8, '10': 'isDryRun'},
    {'1': 'total_items', '3': 3, '4': 1, '5': 5, '10': 'totalItems'},
    {'1': 'valid_items', '3': 4, '4': 1, '5': 5, '10': 'validItems'},
    {'1': 'invalid_items', '3': 5, '4': 1, '5': 5, '10': 'invalidItems'},
    {
      '1': 'total_credits_quoted',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'totalCreditsQuoted'
    },
    {
      '1': 'results',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ProductShowcaseBatchItemResult',
      '10': 'results'
    },
  ],
};

/// Descriptor for `ProductShowcaseServiceCreateBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseServiceCreateBatchResponseDescriptor = $convert.base64Decode(
    'CilQcm9kdWN0U2hvd2Nhc2VTZXJ2aWNlQ3JlYXRlQmF0Y2hSZXNwb25zZRIZCghiYXRjaF9pZB'
    'gBIAEoCVIHYmF0Y2hJZBIcCgppc19kcnlfcnVuGAIgASgIUghpc0RyeVJ1bhIfCgt0b3RhbF9p'
    'dGVtcxgDIAEoBVIKdG90YWxJdGVtcxIfCgt2YWxpZF9pdGVtcxgEIAEoBVIKdmFsaWRJdGVtcx'
    'IjCg1pbnZhbGlkX2l0ZW1zGAUgASgFUgxpbnZhbGlkSXRlbXMSMAoUdG90YWxfY3JlZGl0c19x'
    'dW90ZWQYBiABKAlSEnRvdGFsQ3JlZGl0c1F1b3RlZBJTCgdyZXN1bHRzGAcgAygLMjkuY3JlYX'
    'RpdmFudGEucHJvZHVjdGlvbi52MS5Qcm9kdWN0U2hvd2Nhc2VCYXRjaEl0ZW1SZXN1bHRSB3Jl'
    'c3VsdHM=');

@$core.Deprecated('Use productShowcaseServiceGetRequestDescriptor instead')
const ProductShowcaseServiceGetRequest$json = {
  '1': 'ProductShowcaseServiceGetRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'showcase_job_id', '3': 2, '4': 1, '5': 9, '10': 'showcaseJobId'},
  ],
};

/// Descriptor for `ProductShowcaseServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseServiceGetRequestDescriptor =
    $convert.base64Decode(
        'CiBQcm9kdWN0U2hvd2Nhc2VTZXJ2aWNlR2V0UmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKA'
        'syGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSJgoPc2hvd2Nhc2Vf'
        'am9iX2lkGAIgASgJUg1zaG93Y2FzZUpvYklk');

@$core.Deprecated('Use productShowcaseServiceGetResponseDescriptor instead')
const ProductShowcaseServiceGetResponse$json = {
  '1': 'ProductShowcaseServiceGetResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ProductShowcaseJob',
      '10': 'job'
    },
  ],
};

/// Descriptor for `ProductShowcaseServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseServiceGetResponseDescriptor =
    $convert.base64Decode(
        'CiFQcm9kdWN0U2hvd2Nhc2VTZXJ2aWNlR2V0UmVzcG9uc2USPwoDam9iGAEgASgLMi0uY3JlYX'
        'RpdmFudGEucHJvZHVjdGlvbi52MS5Qcm9kdWN0U2hvd2Nhc2VKb2JSA2pvYg==');

@$core.Deprecated('Use productShowcaseServiceListRequestDescriptor instead')
const ProductShowcaseServiceListRequest$json = {
  '1': 'ProductShowcaseServiceListRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'batch_id', '3': 3, '4': 1, '5': 9, '10': 'batchId'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ProductShowcaseServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseServiceListRequestDescriptor =
    $convert.base64Decode(
        'CiFQcm9kdWN0U2hvd2Nhc2VTZXJ2aWNlTGlzdFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgAS'
        'gLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEh0KCnByb2R1Y3Rf'
        'aWQYAiABKAlSCXByb2R1Y3RJZBIZCghiYXRjaF9pZBgDIAEoCVIHYmF0Y2hJZBIUCgVsaW1pdB'
        'gEIAEoBVIFbGltaXQSHQoKcGFnZV90b2tlbhgFIAEoCVIJcGFnZVRva2Vu');

@$core.Deprecated('Use productShowcaseServiceListResponseDescriptor instead')
const ProductShowcaseServiceListResponse$json = {
  '1': 'ProductShowcaseServiceListResponse',
  '2': [
    {
      '1': 'jobs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ProductShowcaseJob',
      '10': 'jobs'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ProductShowcaseServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productShowcaseServiceListResponseDescriptor =
    $convert.base64Decode(
        'CiJQcm9kdWN0U2hvd2Nhc2VTZXJ2aWNlTGlzdFJlc3BvbnNlEkEKBGpvYnMYASADKAsyLS5jcm'
        'VhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlByb2R1Y3RTaG93Y2FzZUpvYlIEam9icxImCg9uZXh0'
        'X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4=');

@$core.Deprecated('Use scrapedProductDataDescriptor instead')
const ScrapedProductData$json = {
  '1': 'ScrapedProductData',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 2, '4': 1, '5': 9, '10': 'price'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'images', '3': 4, '4': 3, '5': 9, '10': 'images'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'bullet_points', '3': 6, '4': 3, '5': 9, '10': 'bulletPoints'},
    {'1': 'reviews', '3': 7, '4': 3, '5': 9, '10': 'reviews'},
    {
      '1': 'platform',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.LinkPlatform',
      '10': 'platform'
    },
    {
      '1': 'missing_attributes',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.MissingProductAttribute',
      '10': 'missingAttributes'
    },
    {'1': 'summary', '3': 10, '4': 1, '5': 9, '10': 'summary'},
  ],
};

/// Descriptor for `ScrapedProductData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scrapedProductDataDescriptor = $convert.base64Decode(
    'ChJTY3JhcGVkUHJvZHVjdERhdGESEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgVwcmljZRgCIAEoCV'
    'IFcHJpY2USGgoIY3VycmVuY3kYAyABKAlSCGN1cnJlbmN5EhYKBmltYWdlcxgEIAMoCVIGaW1h'
    'Z2VzEiAKC2Rlc2NyaXB0aW9uGAUgASgJUgtkZXNjcmlwdGlvbhIjCg1idWxsZXRfcG9pbnRzGA'
    'YgAygJUgxidWxsZXRQb2ludHMSGAoHcmV2aWV3cxgHIAMoCVIHcmV2aWV3cxJDCghwbGF0Zm9y'
    'bRgIIAEoDjInLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuTGlua1BsYXRmb3JtUghwbGF0Zm'
    '9ybRJhChJtaXNzaW5nX2F0dHJpYnV0ZXMYCSADKAsyMi5jcmVhdGl2YW50YS5wcm9kdWN0aW9u'
    'LnYxLk1pc3NpbmdQcm9kdWN0QXR0cmlidXRlUhFtaXNzaW5nQXR0cmlidXRlcxIYCgdzdW1tYX'
    'J5GAogASgJUgdzdW1tYXJ5');

@$core.Deprecated('Use linkToVideoJobDescriptor instead')
const LinkToVideoJob$json = {
  '1': 'LinkToVideoJob',
  '2': [
    {'1': 'ltv_job_id', '3': 1, '4': 1, '5': 9, '10': 'ltvJobId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'video_edit_job_id', '3': 3, '4': 1, '5': 9, '10': 'videoEditJobId'},
    {'1': 'source_url', '3': 4, '4': 1, '5': 9, '10': 'sourceUrl'},
    {
      '1': 'platform_detected',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.LinkPlatform',
      '10': 'platformDetected'
    },
    {
      '1': 'scraped_data',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ScrapedProductData',
      '10': 'scrapedData'
    },
    {
      '1': 'script_template',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ScriptTemplate',
      '10': 'scriptTemplate'
    },
    {'1': 'generated_script', '3': 8, '4': 1, '5': 9, '10': 'generatedScript'},
    {'1': 'output_asset_id', '3': 9, '4': 1, '5': 9, '10': 'outputAssetId'},
    {'1': 'character_id', '3': 10, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'status', '3': 11, '4': 1, '5': 9, '10': 'status'},
    {'1': 'credits_used', '3': 12, '4': 1, '5': 9, '10': 'creditsUsed'},
    {'1': 'error_code', '3': 13, '4': 1, '5': 9, '10': 'errorCode'},
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

/// Descriptor for `LinkToVideoJob`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkToVideoJobDescriptor = $convert.base64Decode(
    'Cg5MaW5rVG9WaWRlb0pvYhIcCgpsdHZfam9iX2lkGAEgASgJUghsdHZKb2JJZBIhCgx3b3Jrc3'
    'BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEikKEXZpZGVvX2VkaXRfam9iX2lkGAMgASgJUg52'
    'aWRlb0VkaXRKb2JJZBIdCgpzb3VyY2VfdXJsGAQgASgJUglzb3VyY2VVcmwSVAoRcGxhdGZvcm'
    '1fZGV0ZWN0ZWQYBSABKA4yJy5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkxpbmtQbGF0Zm9y'
    'bVIQcGxhdGZvcm1EZXRlY3RlZBJQCgxzY3JhcGVkX2RhdGEYBiABKAsyLS5jcmVhdGl2YW50YS'
    '5wcm9kdWN0aW9uLnYxLlNjcmFwZWRQcm9kdWN0RGF0YVILc2NyYXBlZERhdGESUgoPc2NyaXB0'
    'X3RlbXBsYXRlGAcgASgOMikuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5TY3JpcHRUZW1wbG'
    'F0ZVIOc2NyaXB0VGVtcGxhdGUSKQoQZ2VuZXJhdGVkX3NjcmlwdBgIIAEoCVIPZ2VuZXJhdGVk'
    'U2NyaXB0EiYKD291dHB1dF9hc3NldF9pZBgJIAEoCVINb3V0cHV0QXNzZXRJZBIhCgxjaGFyYW'
    'N0ZXJfaWQYCiABKAlSC2NoYXJhY3RlcklkEhYKBnN0YXR1cxgLIAEoCVIGc3RhdHVzEiEKDGNy'
    'ZWRpdHNfdXNlZBgMIAEoCVILY3JlZGl0c1VzZWQSHQoKZXJyb3JfY29kZRgNIAEoCVIJZXJyb3'
    'JDb2RlEiMKDWVycm9yX21lc3NhZ2UYDiABKAlSDGVycm9yTWVzc2FnZRI5CgpjcmVhdGVkX2F0'
    'GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZW'
    'RfYXQYECABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use linkToVideoServiceScrapeRequestDescriptor instead')
const LinkToVideoServiceScrapeRequest$json = {
  '1': 'LinkToVideoServiceScrapeRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `LinkToVideoServiceScrapeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkToVideoServiceScrapeRequestDescriptor =
    $convert.base64Decode(
        'Ch9MaW5rVG9WaWRlb1NlcnZpY2VTY3JhcGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcm'
        'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSEAoDdXJsGAIgASgJ'
        'UgN1cmw=');

@$core.Deprecated('Use linkToVideoServiceScrapeResponseDescriptor instead')
const LinkToVideoServiceScrapeResponse$json = {
  '1': 'LinkToVideoServiceScrapeResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'data',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ScrapedProductData',
      '10': 'data'
    },
    {'1': 'error_code', '3': 3, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 4, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `LinkToVideoServiceScrapeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkToVideoServiceScrapeResponseDescriptor =
    $convert.base64Decode(
        'CiBMaW5rVG9WaWRlb1NlcnZpY2VTY3JhcGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdW'
        'NjZXNzEkEKBGRhdGEYAiABKAsyLS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlNjcmFwZWRQ'
        'cm9kdWN0RGF0YVIEZGF0YRIdCgplcnJvcl9jb2RlGAMgASgJUgllcnJvckNvZGUSIwoNZXJyb3'
        'JfbWVzc2FnZRgEIAEoCVIMZXJyb3JNZXNzYWdl');

@$core.Deprecated('Use linkToVideoServiceGenerateRequestDescriptor instead')
const LinkToVideoServiceGenerateRequest$json = {
  '1': 'LinkToVideoServiceGenerateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'source_url', '3': 2, '4': 1, '5': 9, '10': 'sourceUrl'},
    {
      '1': 'script_template',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.production.v1.ScriptTemplate',
      '10': 'scriptTemplate'
    },
    {'1': 'custom_script', '3': 4, '4': 1, '5': 9, '10': 'customScript'},
    {
      '1': 'override_data',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.ScrapedProductData',
      '10': 'overrideData'
    },
    {'1': 'character_id', '3': 6, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'visual_style', '3': 7, '4': 1, '5': 9, '10': 'visualStyle'},
    {'1': 'duration_seconds', '3': 8, '4': 1, '5': 5, '10': 'durationSeconds'},
    {'1': 'quote_id', '3': 9, '4': 1, '5': 9, '10': 'quoteId'},
    {
      '1': 'confirmed_credits',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'confirmedCredits'
    },
  ],
};

/// Descriptor for `LinkToVideoServiceGenerateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkToVideoServiceGenerateRequestDescriptor = $convert.base64Decode(
    'CiFMaW5rVG9WaWRlb1NlcnZpY2VHZW5lcmF0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLm'
    'NyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIdCgpzb3VyY2Vf'
    'dXJsGAIgASgJUglzb3VyY2VVcmwSUgoPc2NyaXB0X3RlbXBsYXRlGAMgASgOMikuY3JlYXRpdm'
    'FudGEucHJvZHVjdGlvbi52MS5TY3JpcHRUZW1wbGF0ZVIOc2NyaXB0VGVtcGxhdGUSIwoNY3Vz'
    'dG9tX3NjcmlwdBgEIAEoCVIMY3VzdG9tU2NyaXB0ElIKDW92ZXJyaWRlX2RhdGEYBSABKAsyLS'
    '5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlNjcmFwZWRQcm9kdWN0RGF0YVIMb3ZlcnJpZGVE'
    'YXRhEiEKDGNoYXJhY3Rlcl9pZBgGIAEoCVILY2hhcmFjdGVySWQSIQoMdmlzdWFsX3N0eWxlGA'
    'cgASgJUgt2aXN1YWxTdHlsZRIpChBkdXJhdGlvbl9zZWNvbmRzGAggASgFUg9kdXJhdGlvblNl'
    'Y29uZHMSGQoIcXVvdGVfaWQYCSABKAlSB3F1b3RlSWQSKwoRY29uZmlybWVkX2NyZWRpdHMYCi'
    'ABKAlSEGNvbmZpcm1lZENyZWRpdHM=');

@$core.Deprecated('Use linkToVideoServiceGenerateResponseDescriptor instead')
const LinkToVideoServiceGenerateResponse$json = {
  '1': 'LinkToVideoServiceGenerateResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.LinkToVideoJob',
      '10': 'job'
    },
    {'1': 'credits_deducted', '3': 2, '4': 1, '5': 9, '10': 'creditsDeducted'},
  ],
};

/// Descriptor for `LinkToVideoServiceGenerateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkToVideoServiceGenerateResponseDescriptor =
    $convert.base64Decode(
        'CiJMaW5rVG9WaWRlb1NlcnZpY2VHZW5lcmF0ZVJlc3BvbnNlEjsKA2pvYhgBIAEoCzIpLmNyZW'
        'F0aXZhbnRhLnByb2R1Y3Rpb24udjEuTGlua1RvVmlkZW9Kb2JSA2pvYhIpChBjcmVkaXRzX2Rl'
        'ZHVjdGVkGAIgASgJUg9jcmVkaXRzRGVkdWN0ZWQ=');

@$core.Deprecated('Use linkToVideoServiceGetRequestDescriptor instead')
const LinkToVideoServiceGetRequest$json = {
  '1': 'LinkToVideoServiceGetRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'ltv_job_id', '3': 2, '4': 1, '5': 9, '10': 'ltvJobId'},
  ],
};

/// Descriptor for `LinkToVideoServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkToVideoServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChxMaW5rVG9WaWRlb1NlcnZpY2VHZXRSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLm'
        'NyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIcCgpsdHZfam9iX2lkGAIg'
        'ASgJUghsdHZKb2JJZA==');

@$core.Deprecated('Use linkToVideoServiceGetResponseDescriptor instead')
const LinkToVideoServiceGetResponse$json = {
  '1': 'LinkToVideoServiceGetResponse',
  '2': [
    {
      '1': 'job',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.LinkToVideoJob',
      '10': 'job'
    },
  ],
};

/// Descriptor for `LinkToVideoServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkToVideoServiceGetResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaW5rVG9WaWRlb1NlcnZpY2VHZXRSZXNwb25zZRI7CgNqb2IYASABKAsyKS5jcmVhdGl2YW'
        '50YS5wcm9kdWN0aW9uLnYxLkxpbmtUb1ZpZGVvSm9iUgNqb2I=');

@$core.Deprecated('Use derivativeItemDescriptor instead')
const DerivativeItem$json = {
  '1': 'DerivativeItem',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'parent_asset_id', '3': 2, '4': 1, '5': 9, '10': 'parentAssetId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'derivative_type', '3': 4, '4': 1, '5': 9, '10': 'derivativeType'},
    {'1': 'target_channel', '3': 5, '4': 1, '5': 9, '10': 'targetChannel'},
    {'1': 'aspect_ratio', '3': 6, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'cta_variant', '3': 7, '4': 1, '5': 9, '10': 'ctaVariant'},
    {
      '1': 'subtitle_language',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'subtitleLanguage'
    },
    {'1': 'duration_seconds', '3': 9, '4': 1, '5': 1, '10': 'durationSeconds'},
    {'1': 'resolution', '3': 10, '4': 1, '5': 9, '10': 'resolution'},
    {'1': 'file_url', '3': 11, '4': 1, '5': 9, '10': 'fileUrl'},
    {'1': 'quality_state', '3': 12, '4': 1, '5': 9, '10': 'qualityState'},
    {'1': 'generation_state', '3': 13, '4': 1, '5': 9, '10': 'generationState'},
    {'1': 'tags', '3': 14, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'views', '3': 15, '4': 1, '5': 3, '10': 'views'},
    {'1': 'engagement_rate', '3': 16, '4': 1, '5': 1, '10': 'engagementRate'},
    {'1': 'ctr', '3': 17, '4': 1, '5': 1, '10': 'ctr'},
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
    {
      '1': 'attributed_revenue',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'attributedRevenue'
    },
    {'1': 'orders_count', '3': 21, '4': 1, '5': 3, '10': 'ordersCount'},
    {'1': 'rpm', '3': 22, '4': 1, '5': 9, '10': 'rpm'},
    {'1': 'is_rpm_unknown', '3': 23, '4': 1, '5': 8, '10': 'isRpmUnknown'},
    {'1': 'unknown_reason', '3': 24, '4': 1, '5': 9, '10': 'unknownReason'},
    {
      '1': 'source_class',
      '3': 25,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence',
      '3': 26,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.ConfidenceBand',
      '10': 'confidence'
    },
  ],
};

/// Descriptor for `DerivativeItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeItemDescriptor = $convert.base64Decode(
    'Cg5EZXJpdmF0aXZlSXRlbRIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBImCg9wYXJlbnRfYX'
    'NzZXRfaWQYAiABKAlSDXBhcmVudEFzc2V0SWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEicKD2Rl'
    'cml2YXRpdmVfdHlwZRgEIAEoCVIOZGVyaXZhdGl2ZVR5cGUSJQoOdGFyZ2V0X2NoYW5uZWwYBS'
    'ABKAlSDXRhcmdldENoYW5uZWwSIQoMYXNwZWN0X3JhdGlvGAYgASgJUgthc3BlY3RSYXRpbxIf'
    'CgtjdGFfdmFyaWFudBgHIAEoCVIKY3RhVmFyaWFudBIrChFzdWJ0aXRsZV9sYW5ndWFnZRgIIA'
    'EoCVIQc3VidGl0bGVMYW5ndWFnZRIpChBkdXJhdGlvbl9zZWNvbmRzGAkgASgBUg9kdXJhdGlv'
    'blNlY29uZHMSHgoKcmVzb2x1dGlvbhgKIAEoCVIKcmVzb2x1dGlvbhIZCghmaWxlX3VybBgLIA'
    'EoCVIHZmlsZVVybBIjCg1xdWFsaXR5X3N0YXRlGAwgASgJUgxxdWFsaXR5U3RhdGUSKQoQZ2Vu'
    'ZXJhdGlvbl9zdGF0ZRgNIAEoCVIPZ2VuZXJhdGlvblN0YXRlEhIKBHRhZ3MYDiADKAlSBHRhZ3'
    'MSFAoFdmlld3MYDyABKANSBXZpZXdzEicKD2VuZ2FnZW1lbnRfcmF0ZRgQIAEoAVIOZW5nYWdl'
    'bWVudFJhdGUSEAoDY3RyGBEgASgBUgNjdHISOQoKY3JlYXRlZF9hdBgSIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBMgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EksKEmF0dHJpYnV0ZWRfcmV2ZW51ZR'
    'gUIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIRYXR0cmlidXRlZFJldmVudWUS'
    'IQoMb3JkZXJzX2NvdW50GBUgASgDUgtvcmRlcnNDb3VudBIQCgNycG0YFiABKAlSA3JwbRIkCg'
    '5pc19ycG1fdW5rbm93bhgXIAEoCFIMaXNScG1Vbmtub3duEiUKDnVua25vd25fcmVhc29uGBgg'
    'ASgJUg11bmtub3duUmVhc29uEkUKDHNvdXJjZV9jbGFzcxgZIAEoDjIiLmNyZWF0aXZhbnRhLm'
    'NvbW1vbi52MS5Tb3VyY2VDbGFzc1ILc291cmNlQ2xhc3MSRQoKY29uZmlkZW5jZRgaIAEoDjIl'
    'LmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db25maWRlbmNlQmFuZFIKY29uZmlkZW5jZQ==');

@$core.Deprecated('Use batchItemErrorDescriptor instead')
const BatchItemError$json = {
  '1': 'BatchItemError',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'error_code', '3': 2, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `BatchItemError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchItemErrorDescriptor = $convert.base64Decode(
    'Cg5CYXRjaEl0ZW1FcnJvchIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIdCgplcnJvcl9jb2'
    'RlGAIgASgJUgllcnJvckNvZGUSIwoNZXJyb3JfbWVzc2FnZRgDIAEoCVIMZXJyb3JNZXNzYWdl');

@$core.Deprecated('Use derivativeLineageNodeDescriptor instead')
const DerivativeLineageNode$json = {
  '1': 'DerivativeLineageNode',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'parent_asset_id', '3': 2, '4': 1, '5': 9, '10': 'parentAssetId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'derivative_type', '3': 4, '4': 1, '5': 9, '10': 'derivativeType'},
    {'1': 'asset_type', '3': 5, '4': 1, '5': 9, '10': 'assetType'},
    {'1': 'quality_state', '3': 6, '4': 1, '5': 9, '10': 'qualityState'},
    {'1': 'depth', '3': 7, '4': 1, '5': 5, '10': 'depth'},
    {'1': 'views', '3': 8, '4': 1, '5': 3, '10': 'views'},
    {'1': 'engagement_rate', '3': 9, '4': 1, '5': 1, '10': 'engagementRate'},
    {'1': 'ctr', '3': 10, '4': 1, '5': 1, '10': 'ctr'},
    {
      '1': 'is_source_deleted',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'isSourceDeleted'
    },
    {
      '1': 'children',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeLineageNode',
      '10': 'children'
    },
  ],
};

/// Descriptor for `DerivativeLineageNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeLineageNodeDescriptor = $convert.base64Decode(
    'ChVEZXJpdmF0aXZlTGluZWFnZU5vZGUSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSJgoPcG'
    'FyZW50X2Fzc2V0X2lkGAIgASgJUg1wYXJlbnRBc3NldElkEhQKBXRpdGxlGAMgASgJUgV0aXRs'
    'ZRInCg9kZXJpdmF0aXZlX3R5cGUYBCABKAlSDmRlcml2YXRpdmVUeXBlEh0KCmFzc2V0X3R5cG'
    'UYBSABKAlSCWFzc2V0VHlwZRIjCg1xdWFsaXR5X3N0YXRlGAYgASgJUgxxdWFsaXR5U3RhdGUS'
    'FAoFZGVwdGgYByABKAVSBWRlcHRoEhQKBXZpZXdzGAggASgDUgV2aWV3cxInCg9lbmdhZ2VtZW'
    '50X3JhdGUYCSABKAFSDmVuZ2FnZW1lbnRSYXRlEhAKA2N0chgKIAEoAVIDY3RyEioKEWlzX3Nv'
    'dXJjZV9kZWxldGVkGAsgASgIUg9pc1NvdXJjZURlbGV0ZWQSTAoIY2hpbGRyZW4YDCADKAsyMC'
    '5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkRlcml2YXRpdmVMaW5lYWdlTm9kZVIIY2hpbGRy'
    'ZW4=');

@$core.Deprecated('Use derivativeStatsDescriptor instead')
const DerivativeStats$json = {
  '1': 'DerivativeStats',
  '2': [
    {'1': 'source_asset_id', '3': 1, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {
      '1': 'total_derivatives',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'totalDerivatives'
    },
    {'1': 'aggregate_views', '3': 3, '4': 1, '5': 3, '10': 'aggregateViews'},
    {
      '1': 'average_engagement_rate',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'averageEngagementRate'
    },
    {'1': 'average_ctr', '3': 5, '4': 1, '5': 1, '10': 'averageCtr'},
    {
      '1': 'top_performing_derivative_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'topPerformingDerivativeId'
    },
    {
      '1': 'top_derivatives',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeItem',
      '10': 'topDerivatives'
    },
    {'1': 'is_views_unknown', '3': 8, '4': 1, '5': 8, '10': 'isViewsUnknown'},
    {
      '1': 'is_engagement_rate_unknown',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'isEngagementRateUnknown'
    },
    {'1': 'is_ctr_unknown', '3': 10, '4': 1, '5': 8, '10': 'isCtrUnknown'},
    {'1': 'unknown_reason', '3': 11, '4': 1, '5': 9, '10': 'unknownReason'},
    {'1': 'selection_status', '3': 12, '4': 1, '5': 9, '10': 'selectionStatus'},
    {
      '1': 'aggregate_revenue',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'aggregateRevenue'
    },
    {
      '1': 'total_orders_attributed',
      '3': 14,
      '4': 1,
      '5': 3,
      '10': 'totalOrdersAttributed'
    },
    {
      '1': 'unique_orders_counted',
      '3': 15,
      '4': 1,
      '5': 3,
      '10': 'uniqueOrdersCounted'
    },
    {
      '1': 'confidence',
      '3': 16,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {'1': 'average_rpm', '3': 17, '4': 1, '5': 9, '10': 'averageRpm'},
    {'1': 'is_rpm_unknown', '3': 18, '4': 1, '5': 8, '10': 'isRpmUnknown'},
  ],
};

/// Descriptor for `DerivativeStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeStatsDescriptor = $convert.base64Decode(
    'Cg9EZXJpdmF0aXZlU3RhdHMSJgoPc291cmNlX2Fzc2V0X2lkGAEgASgJUg1zb3VyY2VBc3NldE'
    'lkEisKEXRvdGFsX2Rlcml2YXRpdmVzGAIgASgFUhB0b3RhbERlcml2YXRpdmVzEicKD2FnZ3Jl'
    'Z2F0ZV92aWV3cxgDIAEoA1IOYWdncmVnYXRlVmlld3MSNgoXYXZlcmFnZV9lbmdhZ2VtZW50X3'
    'JhdGUYBCABKAFSFWF2ZXJhZ2VFbmdhZ2VtZW50UmF0ZRIfCgthdmVyYWdlX2N0chgFIAEoAVIK'
    'YXZlcmFnZUN0chI/Chx0b3BfcGVyZm9ybWluZ19kZXJpdmF0aXZlX2lkGAYgASgJUhl0b3BQZX'
    'Jmb3JtaW5nRGVyaXZhdGl2ZUlkElIKD3RvcF9kZXJpdmF0aXZlcxgHIAMoCzIpLmNyZWF0aXZh'
    'bnRhLnByb2R1Y3Rpb24udjEuRGVyaXZhdGl2ZUl0ZW1SDnRvcERlcml2YXRpdmVzEigKEGlzX3'
    'ZpZXdzX3Vua25vd24YCCABKAhSDmlzVmlld3NVbmtub3duEjsKGmlzX2VuZ2FnZW1lbnRfcmF0'
    'ZV91bmtub3duGAkgASgIUhdpc0VuZ2FnZW1lbnRSYXRlVW5rbm93bhIkCg5pc19jdHJfdW5rbm'
    '93bhgKIAEoCFIMaXNDdHJVbmtub3duEiUKDnVua25vd25fcmVhc29uGAsgASgJUg11bmtub3du'
    'UmVhc29uEikKEHNlbGVjdGlvbl9zdGF0dXMYDCABKAlSD3NlbGVjdGlvblN0YXR1cxJJChFhZ2'
    'dyZWdhdGVfcmV2ZW51ZRgNIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIQYWdn'
    'cmVnYXRlUmV2ZW51ZRI2Chd0b3RhbF9vcmRlcnNfYXR0cmlidXRlZBgOIAEoA1IVdG90YWxPcm'
    'RlcnNBdHRyaWJ1dGVkEjIKFXVuaXF1ZV9vcmRlcnNfY291bnRlZBgPIAEoA1ITdW5pcXVlT3Jk'
    'ZXJzQ291bnRlZBJFCgpjb25maWRlbmNlGBAgASgOMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLk'
    'NvbmZpZGVuY2VCYW5kUgpjb25maWRlbmNlEh8KC2F2ZXJhZ2VfcnBtGBEgASgJUgphdmVyYWdl'
    'UnBtEiQKDmlzX3JwbV91bmtub3duGBIgASgIUgxpc1JwbVVua25vd24=');

@$core.Deprecated('Use derivativeServiceListRequestDescriptor instead')
const DerivativeServiceListRequest$json = {
  '1': 'DerivativeServiceListRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'source_asset_id', '3': 2, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {'1': 'derivative_type', '3': 3, '4': 1, '5': 9, '10': 'derivativeType'},
    {'1': 'target_channel', '3': 4, '4': 1, '5': 9, '10': 'targetChannel'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'pagination',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `DerivativeServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceListRequestDescriptor = $convert.base64Decode(
    'ChxEZXJpdmF0aXZlU2VydmljZUxpc3RSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLm'
    'NyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBImCg9zb3VyY2VfYXNzZXRf'
    'aWQYAiABKAlSDXNvdXJjZUFzc2V0SWQSJwoPZGVyaXZhdGl2ZV90eXBlGAMgASgJUg5kZXJpdm'
    'F0aXZlVHlwZRIlCg50YXJnZXRfY2hhbm5lbBgEIAEoCVINdGFyZ2V0Q2hhbm5lbBIWCgZzdGF0'
    'dXMYBSABKAlSBnN0YXR1cxJBCgpwYWdpbmF0aW9uGAYgASgLMiEuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use derivativeServiceListResponseDescriptor instead')
const DerivativeServiceListResponse$json = {
  '1': 'DerivativeServiceListResponse',
  '2': [
    {
      '1': 'derivatives',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeItem',
      '10': 'derivatives'
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

/// Descriptor for `DerivativeServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceListResponseDescriptor = $convert.base64Decode(
    'Ch1EZXJpdmF0aXZlU2VydmljZUxpc3RSZXNwb25zZRJLCgtkZXJpdmF0aXZlcxgBIAMoCzIpLm'
    'NyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuRGVyaXZhdGl2ZUl0ZW1SC2Rlcml2YXRpdmVzEkgK'
    'CnBhZ2luYXRpb24YAiABKAsyKC5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG'
    '9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use derivativeServiceCreateRequestDescriptor instead')
const DerivativeServiceCreateRequest$json = {
  '1': 'DerivativeServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'parent_asset_id', '3': 2, '4': 1, '5': 9, '10': 'parentAssetId'},
    {'1': 'derivative_type', '3': 3, '4': 1, '5': 9, '10': 'derivativeType'},
    {'1': 'target_channel', '3': 4, '4': 1, '5': 9, '10': 'targetChannel'},
    {'1': 'aspect_ratio', '3': 5, '4': 1, '5': 9, '10': 'aspectRatio'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cta_variant', '3': 7, '4': 1, '5': 9, '10': 'ctaVariant'},
    {
      '1': 'subtitle_language',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'subtitleLanguage'
    },
    {'1': 'tags', '3': 9, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'prompt', '3': 10, '4': 1, '5': 9, '10': 'prompt'},
  ],
};

/// Descriptor for `DerivativeServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch5EZXJpdmF0aXZlU2VydmljZUNyZWF0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
    'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBImCg9wYXJlbnRfYXNz'
    'ZXRfaWQYAiABKAlSDXBhcmVudEFzc2V0SWQSJwoPZGVyaXZhdGl2ZV90eXBlGAMgASgJUg5kZX'
    'JpdmF0aXZlVHlwZRIlCg50YXJnZXRfY2hhbm5lbBgEIAEoCVINdGFyZ2V0Q2hhbm5lbBIhCgxh'
    'c3BlY3RfcmF0aW8YBSABKAlSC2FzcGVjdFJhdGlvEhQKBXRpdGxlGAYgASgJUgV0aXRsZRIfCg'
    'tjdGFfdmFyaWFudBgHIAEoCVIKY3RhVmFyaWFudBIrChFzdWJ0aXRsZV9sYW5ndWFnZRgIIAEo'
    'CVIQc3VidGl0bGVMYW5ndWFnZRISCgR0YWdzGAkgAygJUgR0YWdzEhYKBnByb21wdBgKIAEoCV'
    'IGcHJvbXB0');

@$core.Deprecated('Use derivativeServiceCreateResponseDescriptor instead')
const DerivativeServiceCreateResponse$json = {
  '1': 'DerivativeServiceCreateResponse',
  '2': [
    {
      '1': 'derivative',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeItem',
      '10': 'derivative'
    },
    {'1': 'operation_id', '3': 2, '4': 1, '5': 9, '10': 'operationId'},
  ],
};

/// Descriptor for `DerivativeServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch9EZXJpdmF0aXZlU2VydmljZUNyZWF0ZVJlc3BvbnNlEkkKCmRlcml2YXRpdmUYASABKAsyKS'
        '5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkRlcml2YXRpdmVJdGVtUgpkZXJpdmF0aXZlEiEK'
        'DG9wZXJhdGlvbl9pZBgCIAEoCVILb3BlcmF0aW9uSWQ=');

@$core.Deprecated('Use derivativeServiceBatchTagRequestDescriptor instead')
const DerivativeServiceBatchTagRequest$json = {
  '1': 'DerivativeServiceBatchTagRequest',
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
    {'1': 'add_tags', '3': 3, '4': 3, '5': 9, '10': 'addTags'},
    {'1': 'remove_tags', '3': 4, '4': 3, '5': 9, '10': 'removeTags'},
  ],
};

/// Descriptor for `DerivativeServiceBatchTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceBatchTagRequestDescriptor =
    $convert.base64Decode(
        'CiBEZXJpdmF0aXZlU2VydmljZUJhdGNoVGFnUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhsKCWFzc2V0X2lk'
        'cxgCIAMoCVIIYXNzZXRJZHMSGQoIYWRkX3RhZ3MYAyADKAlSB2FkZFRhZ3MSHwoLcmVtb3ZlX3'
        'RhZ3MYBCADKAlSCnJlbW92ZVRhZ3M=');

@$core.Deprecated('Use derivativeServiceBatchTagResponseDescriptor instead')
const DerivativeServiceBatchTagResponse$json = {
  '1': 'DerivativeServiceBatchTagResponse',
  '2': [
    {'1': 'total_items', '3': 1, '4': 1, '5': 5, '10': 'totalItems'},
    {'1': 'succeeded_count', '3': 2, '4': 1, '5': 5, '10': 'succeededCount'},
    {'1': 'failed_count', '3': 3, '4': 1, '5': 5, '10': 'failedCount'},
    {
      '1': 'succeeded_asset_ids',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'succeededAssetIds'
    },
    {
      '1': 'failures',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.BatchItemError',
      '10': 'failures'
    },
    {'1': 'summary', '3': 6, '4': 1, '5': 9, '10': 'summary'},
  ],
};

/// Descriptor for `DerivativeServiceBatchTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceBatchTagResponseDescriptor = $convert.base64Decode(
    'CiFEZXJpdmF0aXZlU2VydmljZUJhdGNoVGFnUmVzcG9uc2USHwoLdG90YWxfaXRlbXMYASABKA'
    'VSCnRvdGFsSXRlbXMSJwoPc3VjY2VlZGVkX2NvdW50GAIgASgFUg5zdWNjZWVkZWRDb3VudBIh'
    'CgxmYWlsZWRfY291bnQYAyABKAVSC2ZhaWxlZENvdW50Ei4KE3N1Y2NlZWRlZF9hc3NldF9pZH'
    'MYBCADKAlSEXN1Y2NlZWRlZEFzc2V0SWRzEkUKCGZhaWx1cmVzGAUgAygLMikuY3JlYXRpdmFu'
    'dGEucHJvZHVjdGlvbi52MS5CYXRjaEl0ZW1FcnJvclIIZmFpbHVyZXMSGAoHc3VtbWFyeRgGIA'
    'EoCVIHc3VtbWFyeQ==');

@$core.Deprecated('Use derivativeServiceGetLineageRequestDescriptor instead')
const DerivativeServiceGetLineageRequest$json = {
  '1': 'DerivativeServiceGetLineageRequest',
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

/// Descriptor for `DerivativeServiceGetLineageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceGetLineageRequestDescriptor =
    $convert.base64Decode(
        'CiJEZXJpdmF0aXZlU2VydmljZUdldExpbmVhZ2VSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIA'
        'EoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIZCghhc3NldF9p'
        'ZBgCIAEoCVIHYXNzZXRJZA==');

@$core.Deprecated('Use derivativeServiceGetLineageResponseDescriptor instead')
const DerivativeServiceGetLineageResponse$json = {
  '1': 'DerivativeServiceGetLineageResponse',
  '2': [
    {
      '1': 'root_source',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeLineageNode',
      '10': 'rootSource'
    },
    {
      '1': 'target_node',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeLineageNode',
      '10': 'targetNode'
    },
    {
      '1': 'chain',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeLineageNode',
      '10': 'chain'
    },
    {'1': 'has_lineage', '3': 4, '4': 1, '5': 8, '10': 'hasLineage'},
    {'1': 'lineage_summary', '3': 5, '4': 1, '5': 9, '10': 'lineageSummary'},
  ],
};

/// Descriptor for `DerivativeServiceGetLineageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceGetLineageResponseDescriptor = $convert.base64Decode(
    'CiNEZXJpdmF0aXZlU2VydmljZUdldExpbmVhZ2VSZXNwb25zZRJRCgtyb290X3NvdXJjZRgBIA'
    'EoCzIwLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuRGVyaXZhdGl2ZUxpbmVhZ2VOb2RlUgpy'
    'b290U291cmNlElEKC3RhcmdldF9ub2RlGAIgASgLMjAuY3JlYXRpdmFudGEucHJvZHVjdGlvbi'
    '52MS5EZXJpdmF0aXZlTGluZWFnZU5vZGVSCnRhcmdldE5vZGUSRgoFY2hhaW4YAyADKAsyMC5j'
    'cmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkRlcml2YXRpdmVMaW5lYWdlTm9kZVIFY2hhaW4SHw'
    'oLaGFzX2xpbmVhZ2UYBCABKAhSCmhhc0xpbmVhZ2USJwoPbGluZWFnZV9zdW1tYXJ5GAUgASgJ'
    'Ug5saW5lYWdlU3VtbWFyeQ==');

@$core.Deprecated('Use derivativeServiceDeleteRequestDescriptor instead')
const DerivativeServiceDeleteRequest$json = {
  '1': 'DerivativeServiceDeleteRequest',
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
  ],
};

/// Descriptor for `DerivativeServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceDeleteRequestDescriptor =
    $convert.base64Decode(
        'Ch5EZXJpdmF0aXZlU2VydmljZURlbGV0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
        'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIZCghhc3NldF9pZBgC'
        'IAEoCVIHYXNzZXRJZA==');

@$core.Deprecated('Use derivativeServiceDeleteResponseDescriptor instead')
const DerivativeServiceDeleteResponse$json = {
  '1': 'DerivativeServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `DerivativeServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'Ch9EZXJpdmF0aXZlU2VydmljZURlbGV0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2'
        'Nlc3MSGQoIYXNzZXRfaWQYAiABKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use derivativeServicePromoteRequestDescriptor instead')
const DerivativeServicePromoteRequest$json = {
  '1': 'DerivativeServicePromoteRequest',
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
  ],
};

/// Descriptor for `DerivativeServicePromoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServicePromoteRequestDescriptor =
    $convert.base64Decode(
        'Ch9EZXJpdmF0aXZlU2VydmljZVByb21vdGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcm'
        'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGQoIYXNzZXRfaWQY'
        'AiABKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use derivativeServicePromoteResponseDescriptor instead')
const DerivativeServicePromoteResponse$json = {
  '1': 'DerivativeServicePromoteResponse',
  '2': [
    {
      '1': 'derivative',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeItem',
      '10': 'derivative'
    },
    {'1': 'is_canonical', '3': 2, '4': 1, '5': 8, '10': 'isCanonical'},
  ],
};

/// Descriptor for `DerivativeServicePromoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServicePromoteResponseDescriptor =
    $convert.base64Decode(
        'CiBEZXJpdmF0aXZlU2VydmljZVByb21vdGVSZXNwb25zZRJJCgpkZXJpdmF0aXZlGAEgASgLMi'
        'kuY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5EZXJpdmF0aXZlSXRlbVIKZGVyaXZhdGl2ZRIh'
        'Cgxpc19jYW5vbmljYWwYAiABKAhSC2lzQ2Fub25pY2Fs');

@$core.Deprecated('Use derivativeServiceGetStatsRequestDescriptor instead')
const DerivativeServiceGetStatsRequest$json = {
  '1': 'DerivativeServiceGetStatsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'source_asset_id', '3': 2, '4': 1, '5': 9, '10': 'sourceAssetId'},
  ],
};

/// Descriptor for `DerivativeServiceGetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceGetStatsRequestDescriptor =
    $convert.base64Decode(
        'CiBEZXJpdmF0aXZlU2VydmljZUdldFN0YXRzUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKA'
        'syGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSJgoPc291cmNlX2Fz'
        'c2V0X2lkGAIgASgJUg1zb3VyY2VBc3NldElk');

@$core.Deprecated('Use derivativeServiceGetStatsResponseDescriptor instead')
const DerivativeServiceGetStatsResponse$json = {
  '1': 'DerivativeServiceGetStatsResponse',
  '2': [
    {
      '1': 'stats',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.DerivativeStats',
      '10': 'stats'
    },
  ],
};

/// Descriptor for `DerivativeServiceGetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List derivativeServiceGetStatsResponseDescriptor =
    $convert.base64Decode(
        'CiFEZXJpdmF0aXZlU2VydmljZUdldFN0YXRzUmVzcG9uc2USQAoFc3RhdHMYASABKAsyKi5jcm'
        'VhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkRlcml2YXRpdmVTdGF0c1IFc3RhdHM=');

@$core.Deprecated('Use packagingScoreComponentDescriptor instead')
const PackagingScoreComponent$json = {
  '1': 'PackagingScoreComponent',
  '2': [
    {'1': 'component_name', '3': 1, '4': 1, '5': 9, '10': 'componentName'},
    {'1': 'score', '3': 2, '4': 1, '5': 1, '10': 'score'},
    {'1': 'weight', '3': 3, '4': 1, '5': 1, '10': 'weight'},
    {'1': 'status', '3': 4, '4': 1, '5': 9, '10': 'status'},
    {'1': 'findings', '3': 5, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'suggested_fix', '3': 6, '4': 1, '5': 9, '10': 'suggestedFix'},
    {'1': 'is_hard_blocked', '3': 7, '4': 1, '5': 8, '10': 'isHardBlocked'},
    {'1': 'can_override', '3': 8, '4': 1, '5': 8, '10': 'canOverride'},
  ],
};

/// Descriptor for `PackagingScoreComponent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingScoreComponentDescriptor = $convert.base64Decode(
    'ChdQYWNrYWdpbmdTY29yZUNvbXBvbmVudBIlCg5jb21wb25lbnRfbmFtZRgBIAEoCVINY29tcG'
    '9uZW50TmFtZRIUCgVzY29yZRgCIAEoAVIFc2NvcmUSFgoGd2VpZ2h0GAMgASgBUgZ3ZWlnaHQS'
    'FgoGc3RhdHVzGAQgASgJUgZzdGF0dXMSGgoIZmluZGluZ3MYBSABKAlSCGZpbmRpbmdzEiMKDX'
    'N1Z2dlc3RlZF9maXgYBiABKAlSDHN1Z2dlc3RlZEZpeBImCg9pc19oYXJkX2Jsb2NrZWQYByAB'
    'KAhSDWlzSGFyZEJsb2NrZWQSIQoMY2FuX292ZXJyaWRlGAggASgIUgtjYW5PdmVycmlkZQ==');

@$core.Deprecated('Use readinessCheckItemDescriptor instead')
const ReadinessCheckItem$json = {
  '1': 'ReadinessCheckItem',
  '2': [
    {'1': 'check_id', '3': 1, '4': 1, '5': 9, '10': 'checkId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'check_type', '3': 3, '4': 1, '5': 9, '10': 'checkType'},
    {'1': 'status', '3': 4, '4': 1, '5': 9, '10': 'status'},
    {'1': 'current_value', '3': 5, '4': 1, '5': 9, '10': 'currentValue'},
    {'1': 'required_value', '3': 6, '4': 1, '5': 9, '10': 'requiredValue'},
    {'1': 'suggested_fix', '3': 7, '4': 1, '5': 9, '10': 'suggestedFix'},
    {'1': 'is_hard_blocked', '3': 8, '4': 1, '5': 8, '10': 'isHardBlocked'},
    {'1': 'can_override', '3': 9, '4': 1, '5': 8, '10': 'canOverride'},
  ],
};

/// Descriptor for `ReadinessCheckItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readinessCheckItemDescriptor = $convert.base64Decode(
    'ChJSZWFkaW5lc3NDaGVja0l0ZW0SGQoIY2hlY2tfaWQYASABKAlSB2NoZWNrSWQSGgoIcGxhdG'
    'Zvcm0YAiABKAlSCHBsYXRmb3JtEh0KCmNoZWNrX3R5cGUYAyABKAlSCWNoZWNrVHlwZRIWCgZz'
    'dGF0dXMYBCABKAlSBnN0YXR1cxIjCg1jdXJyZW50X3ZhbHVlGAUgASgJUgxjdXJyZW50VmFsdW'
    'USJQoOcmVxdWlyZWRfdmFsdWUYBiABKAlSDXJlcXVpcmVkVmFsdWUSIwoNc3VnZ2VzdGVkX2Zp'
    'eBgHIAEoCVIMc3VnZ2VzdGVkRml4EiYKD2lzX2hhcmRfYmxvY2tlZBgIIAEoCFINaXNIYXJkQm'
    'xvY2tlZBIhCgxjYW5fb3ZlcnJpZGUYCSABKAhSC2Nhbk92ZXJyaWRl');

@$core.Deprecated('Use complianceScanDetailDescriptor instead')
const ComplianceScanDetail$json = {
  '1': 'ComplianceScanDetail',
  '2': [
    {'1': 'scan_id', '3': 1, '4': 1, '5': 9, '10': 'scanId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'finding_description',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'findingDescription'
    },
    {'1': 'matched_work', '3': 5, '4': 1, '5': 9, '10': 'matchedWork'},
    {'1': 'match_confidence', '3': 6, '4': 1, '5': 9, '10': 'matchConfidence'},
    {'1': 'is_hard_blocked', '3': 7, '4': 1, '5': 8, '10': 'isHardBlocked'},
    {'1': 'can_override', '3': 8, '4': 1, '5': 8, '10': 'canOverride'},
  ],
};

/// Descriptor for `ComplianceScanDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complianceScanDetailDescriptor = $convert.base64Decode(
    'ChRDb21wbGlhbmNlU2NhbkRldGFpbBIXCgdzY2FuX2lkGAEgASgJUgZzY2FuSWQSGgoIY2F0ZW'
    'dvcnkYAiABKAlSCGNhdGVnb3J5EhYKBnN0YXR1cxgDIAEoCVIGc3RhdHVzEi8KE2ZpbmRpbmdf'
    'ZGVzY3JpcHRpb24YBCABKAlSEmZpbmRpbmdEZXNjcmlwdGlvbhIhCgxtYXRjaGVkX3dvcmsYBS'
    'ABKAlSC21hdGNoZWRXb3JrEikKEG1hdGNoX2NvbmZpZGVuY2UYBiABKAlSD21hdGNoQ29uZmlk'
    'ZW5jZRImCg9pc19oYXJkX2Jsb2NrZWQYByABKAhSDWlzSGFyZEJsb2NrZWQSIQoMY2FuX292ZX'
    'JyaWRlGAggASgIUgtjYW5PdmVycmlkZQ==');

@$core.Deprecated('Use uploadPresetDescriptor instead')
const UploadPreset$json = {
  '1': 'UploadPreset',
  '2': [
    {'1': 'preset_id', '3': 1, '4': 1, '5': 9, '10': 'presetId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'target_platform', '3': 3, '4': 1, '5': 9, '10': 'targetPlatform'},
    {'1': 'target_format', '3': 4, '4': 1, '5': 9, '10': 'targetFormat'},
    {'1': 'hashtag_template', '3': 5, '4': 1, '5': 9, '10': 'hashtagTemplate'},
    {
      '1': 'disclosure_template',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'disclosureTemplate'
    },
    {'1': 'cta_template', '3': 7, '4': 1, '5': 9, '10': 'ctaTemplate'},
    {
      '1': 'default_aspect_ratio',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'defaultAspectRatio'
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

/// Descriptor for `UploadPreset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadPresetDescriptor = $convert.base64Decode(
    'CgxVcGxvYWRQcmVzZXQSGwoJcHJlc2V0X2lkGAEgASgJUghwcmVzZXRJZBISCgRuYW1lGAIgAS'
    'gJUgRuYW1lEicKD3RhcmdldF9wbGF0Zm9ybRgDIAEoCVIOdGFyZ2V0UGxhdGZvcm0SIwoNdGFy'
    'Z2V0X2Zvcm1hdBgEIAEoCVIMdGFyZ2V0Rm9ybWF0EikKEGhhc2h0YWdfdGVtcGxhdGUYBSABKA'
    'lSD2hhc2h0YWdUZW1wbGF0ZRIvChNkaXNjbG9zdXJlX3RlbXBsYXRlGAYgASgJUhJkaXNjbG9z'
    'dXJlVGVtcGxhdGUSIQoMY3RhX3RlbXBsYXRlGAcgASgJUgtjdGFUZW1wbGF0ZRIwChRkZWZhdW'
    'x0X2FzcGVjdF9yYXRpbxgIIAEoCVISZGVmYXVsdEFzcGVjdFJhdGlvEjkKCmNyZWF0ZWRfYXQY'
    'CSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use aBExperimentDescriptor instead')
const ABExperiment$json = {
  '1': 'ABExperiment',
  '2': [
    {'1': 'experiment_id', '3': 1, '4': 1, '5': 9, '10': 'experimentId'},
    {'1': 'source_asset_id', '3': 2, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'hypothesis', '3': 4, '4': 1, '5': 9, '10': 'hypothesis'},
    {'1': 'variant_asset_ids', '3': 5, '4': 3, '5': 9, '10': 'variantAssetIds'},
    {'1': 'variant_count', '3': 6, '4': 1, '5': 5, '10': 'variantCount'},
    {'1': 'target_metric', '3': 7, '4': 1, '5': 9, '10': 'targetMetric'},
    {
      '1': 'min_duration_hours',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'minDurationHours'
    },
    {
      '1': 'min_impressions_per_variant',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'minImpressionsPerVariant'
    },
    {
      '1': 'auto_winner_threshold_multiplier',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'autoWinnerThresholdMultiplier'
    },
    {'1': 'status', '3': 11, '4': 1, '5': 9, '10': 'status'},
    {'1': 'result_status', '3': 12, '4': 1, '5': 9, '10': 'resultStatus'},
    {'1': 'winner_asset_id', '3': 13, '4': 1, '5': 9, '10': 'winnerAssetId'},
    {'1': 'is_observational', '3': 14, '4': 1, '5': 8, '10': 'isObservational'},
    {
      '1': 'inconclusive_reason',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'inconclusiveReason'
    },
  ],
};

/// Descriptor for `ABExperiment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List aBExperimentDescriptor = $convert.base64Decode(
    'CgxBQkV4cGVyaW1lbnQSIwoNZXhwZXJpbWVudF9pZBgBIAEoCVIMZXhwZXJpbWVudElkEiYKD3'
    'NvdXJjZV9hc3NldF9pZBgCIAEoCVINc291cmNlQXNzZXRJZBIUCgV0aXRsZRgDIAEoCVIFdGl0'
    'bGUSHgoKaHlwb3RoZXNpcxgEIAEoCVIKaHlwb3RoZXNpcxIqChF2YXJpYW50X2Fzc2V0X2lkcx'
    'gFIAMoCVIPdmFyaWFudEFzc2V0SWRzEiMKDXZhcmlhbnRfY291bnQYBiABKAVSDHZhcmlhbnRD'
    'b3VudBIjCg10YXJnZXRfbWV0cmljGAcgASgJUgx0YXJnZXRNZXRyaWMSLAoSbWluX2R1cmF0aW'
    '9uX2hvdXJzGAggASgFUhBtaW5EdXJhdGlvbkhvdXJzEj0KG21pbl9pbXByZXNzaW9uc19wZXJf'
    'dmFyaWFudBgJIAEoA1IYbWluSW1wcmVzc2lvbnNQZXJWYXJpYW50EkcKIGF1dG9fd2lubmVyX3'
    'RocmVzaG9sZF9tdWx0aXBsaWVyGAogASgBUh1hdXRvV2lubmVyVGhyZXNob2xkTXVsdGlwbGll'
    'chIWCgZzdGF0dXMYCyABKAlSBnN0YXR1cxIjCg1yZXN1bHRfc3RhdHVzGAwgASgJUgxyZXN1bH'
    'RTdGF0dXMSJgoPd2lubmVyX2Fzc2V0X2lkGA0gASgJUg13aW5uZXJBc3NldElkEikKEGlzX29i'
    'c2VydmF0aW9uYWwYDiABKAhSD2lzT2JzZXJ2YXRpb25hbBIvChNpbmNvbmNsdXNpdmVfcmVhc2'
    '9uGA8gASgJUhJpbmNvbmNsdXNpdmVSZWFzb24=');

@$core.Deprecated('Use overrideAuditRecordDescriptor instead')
const OverrideAuditRecord$json = {
  '1': 'OverrideAuditRecord',
  '2': [
    {'1': 'override_id', '3': 1, '4': 1, '5': 9, '10': 'overrideId'},
    {
      '1': 'check_id_or_category',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'checkIdOrCategory'
    },
    {
      '1': 'overridden_by_user_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'overriddenByUserId'
    },
    {'1': 'actor_role', '3': 4, '4': 1, '5': 9, '10': 'actorRole'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `OverrideAuditRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideAuditRecordDescriptor = $convert.base64Decode(
    'ChNPdmVycmlkZUF1ZGl0UmVjb3JkEh8KC292ZXJyaWRlX2lkGAEgASgJUgpvdmVycmlkZUlkEi'
    '8KFGNoZWNrX2lkX29yX2NhdGVnb3J5GAIgASgJUhFjaGVja0lkT3JDYXRlZ29yeRIxChVvdmVy'
    'cmlkZGVuX2J5X3VzZXJfaWQYAyABKAlSEm92ZXJyaWRkZW5CeVVzZXJJZBIdCgphY3Rvcl9yb2'
    'xlGAQgASgJUglhY3RvclJvbGUSFgoGcmVhc29uGAUgASgJUgZyZWFzb24SOQoKY3JlYXRlZF9h'
    'dBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use packagingReportDescriptor instead')
const PackagingReport$json = {
  '1': 'PackagingReport',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'publish_item_id', '3': 3, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'overall_packaging_score',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'overallPackagingScore'
    },
    {'1': 'score_status', '3': 5, '4': 1, '5': 9, '10': 'scoreStatus'},
    {
      '1': 'components',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.PackagingScoreComponent',
      '10': 'components'
    },
    {
      '1': 'readiness_checks',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ReadinessCheckItem',
      '10': 'readinessChecks'
    },
    {
      '1': 'compliance_details',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ComplianceScanDetail',
      '10': 'complianceDetails'
    },
    {
      '1': 'compliance_overall_result',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'complianceOverallResult'
    },
    {'1': 'has_hard_blocks', '3': 10, '4': 1, '5': 8, '10': 'hasHardBlocks'},
    {
      '1': 'hard_block_reasons',
      '3': 11,
      '4': 3,
      '5': 9,
      '10': 'hardBlockReasons'
    },
    {
      '1': 'ready_for_packaging',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'readyForPackaging'
    },
    {'1': 'ready_to_publish', '3': 13, '4': 1, '5': 8, '10': 'readyToPublish'},
    {
      '1': 'applied_overrides',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.OverrideAuditRecord',
      '10': 'appliedOverrides'
    },
    {
      '1': 'created_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `PackagingReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingReportDescriptor = $convert.base64Decode(
    'Cg9QYWNrYWdpbmdSZXBvcnQSGwoJcmVwb3J0X2lkGAEgASgJUghyZXBvcnRJZBIZCghhc3NldF'
    '9pZBgCIAEoCVIHYXNzZXRJZBImCg9wdWJsaXNoX2l0ZW1faWQYAyABKAlSDXB1Ymxpc2hJdGVt'
    'SWQSNgoXb3ZlcmFsbF9wYWNrYWdpbmdfc2NvcmUYBCABKAFSFW92ZXJhbGxQYWNrYWdpbmdTY2'
    '9yZRIhCgxzY29yZV9zdGF0dXMYBSABKAlSC3Njb3JlU3RhdHVzElIKCmNvbXBvbmVudHMYBiAD'
    'KAsyMi5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlBhY2thZ2luZ1Njb3JlQ29tcG9uZW50Ug'
    'pjb21wb25lbnRzElgKEHJlYWRpbmVzc19jaGVja3MYByADKAsyLS5jcmVhdGl2YW50YS5wcm9k'
    'dWN0aW9uLnYxLlJlYWRpbmVzc0NoZWNrSXRlbVIPcmVhZGluZXNzQ2hlY2tzEl4KEmNvbXBsaW'
    'FuY2VfZGV0YWlscxgIIAMoCzIvLmNyZWF0aXZhbnRhLnByb2R1Y3Rpb24udjEuQ29tcGxpYW5j'
    'ZVNjYW5EZXRhaWxSEWNvbXBsaWFuY2VEZXRhaWxzEjoKGWNvbXBsaWFuY2Vfb3ZlcmFsbF9yZX'
    'N1bHQYCSABKAlSF2NvbXBsaWFuY2VPdmVyYWxsUmVzdWx0EiYKD2hhc19oYXJkX2Jsb2NrcxgK'
    'IAEoCFINaGFzSGFyZEJsb2NrcxIsChJoYXJkX2Jsb2NrX3JlYXNvbnMYCyADKAlSEGhhcmRCbG'
    '9ja1JlYXNvbnMSLgoTcmVhZHlfZm9yX3BhY2thZ2luZxgMIAEoCFIRcmVhZHlGb3JQYWNrYWdp'
    'bmcSKAoQcmVhZHlfdG9fcHVibGlzaBgNIAEoCFIOcmVhZHlUb1B1Ymxpc2gSWwoRYXBwbGllZF'
    '9vdmVycmlkZXMYDiADKAsyLi5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLk92ZXJyaWRlQXVk'
    'aXRSZWNvcmRSEGFwcGxpZWRPdmVycmlkZXMSOQoKY3JlYXRlZF9hdBgPIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use packagingServiceScoreRequestDescriptor instead')
const PackagingServiceScoreRequest$json = {
  '1': 'PackagingServiceScoreRequest',
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
    {'1': 'publish_item_id', '3': 3, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'target_platform', '3': 4, '4': 1, '5': 9, '10': 'targetPlatform'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'caption', '3': 6, '4': 1, '5': 9, '10': 'caption'},
    {'1': 'hashtags', '3': 7, '4': 3, '5': 9, '10': 'hashtags'},
    {'1': 'cta', '3': 8, '4': 1, '5': 9, '10': 'cta'},
    {'1': 'disclosure', '3': 9, '4': 1, '5': 9, '10': 'disclosure'},
    {'1': 'audio_track_id', '3': 10, '4': 1, '5': 9, '10': 'audioTrackId'},
    {'1': 'preset_id', '3': 11, '4': 1, '5': 9, '10': 'presetId'},
    {'1': 'is_commercial', '3': 12, '4': 1, '5': 8, '10': 'isCommercial'},
  ],
};

/// Descriptor for `PackagingServiceScoreRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceScoreRequestDescriptor = $convert.base64Decode(
    'ChxQYWNrYWdpbmdTZXJ2aWNlU2NvcmVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGQoIYXNzZXRfaWQYAiAB'
    'KAlSB2Fzc2V0SWQSJgoPcHVibGlzaF9pdGVtX2lkGAMgASgJUg1wdWJsaXNoSXRlbUlkEicKD3'
    'RhcmdldF9wbGF0Zm9ybRgEIAEoCVIOdGFyZ2V0UGxhdGZvcm0SFAoFdGl0bGUYBSABKAlSBXRp'
    'dGxlEhgKB2NhcHRpb24YBiABKAlSB2NhcHRpb24SGgoIaGFzaHRhZ3MYByADKAlSCGhhc2h0YW'
    'dzEhAKA2N0YRgIIAEoCVIDY3RhEh4KCmRpc2Nsb3N1cmUYCSABKAlSCmRpc2Nsb3N1cmUSJAoO'
    'YXVkaW9fdHJhY2tfaWQYCiABKAlSDGF1ZGlvVHJhY2tJZBIbCglwcmVzZXRfaWQYCyABKAlSCH'
    'ByZXNldElkEiMKDWlzX2NvbW1lcmNpYWwYDCABKAhSDGlzQ29tbWVyY2lhbA==');

@$core.Deprecated('Use packagingServiceScoreResponseDescriptor instead')
const PackagingServiceScoreResponse$json = {
  '1': 'PackagingServiceScoreResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.PackagingReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `PackagingServiceScoreResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceScoreResponseDescriptor =
    $convert.base64Decode(
        'Ch1QYWNrYWdpbmdTZXJ2aWNlU2NvcmVSZXNwb25zZRJCCgZyZXBvcnQYASABKAsyKi5jcmVhdG'
        'l2YW50YS5wcm9kdWN0aW9uLnYxLlBhY2thZ2luZ1JlcG9ydFIGcmVwb3J0');

@$core.Deprecated('Use packagingServiceScanComplianceRequestDescriptor instead')
const PackagingServiceScanComplianceRequest$json = {
  '1': 'PackagingServiceScanComplianceRequest',
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
    {'1': 'publish_item_id', '3': 3, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'target_platform', '3': 4, '4': 1, '5': 9, '10': 'targetPlatform'},
  ],
};

/// Descriptor for `PackagingServiceScanComplianceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceScanComplianceRequestDescriptor =
    $convert.base64Decode(
        'CiVQYWNrYWdpbmdTZXJ2aWNlU2NhbkNvbXBsaWFuY2VSZXF1ZXN0Ej8KB2NvbnRleHQYASABKA'
        'syJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGQoIYXNz'
        'ZXRfaWQYAiABKAlSB2Fzc2V0SWQSJgoPcHVibGlzaF9pdGVtX2lkGAMgASgJUg1wdWJsaXNoSX'
        'RlbUlkEicKD3RhcmdldF9wbGF0Zm9ybRgEIAEoCVIOdGFyZ2V0UGxhdGZvcm0=');

@$core
    .Deprecated('Use packagingServiceScanComplianceResponseDescriptor instead')
const PackagingServiceScanComplianceResponse$json = {
  '1': 'PackagingServiceScanComplianceResponse',
  '2': [
    {
      '1': 'compliance_scan_result',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'complianceScanResult'
    },
    {
      '1': 'details',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.ComplianceScanDetail',
      '10': 'details'
    },
    {'1': 'has_hard_blocks', '3': 3, '4': 1, '5': 8, '10': 'hasHardBlocks'},
  ],
};

/// Descriptor for `PackagingServiceScanComplianceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceScanComplianceResponseDescriptor =
    $convert.base64Decode(
        'CiZQYWNrYWdpbmdTZXJ2aWNlU2NhbkNvbXBsaWFuY2VSZXNwb25zZRI0ChZjb21wbGlhbmNlX3'
        'NjYW5fcmVzdWx0GAEgASgJUhRjb21wbGlhbmNlU2NhblJlc3VsdBJJCgdkZXRhaWxzGAIgAygL'
        'Mi8uY3JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5Db21wbGlhbmNlU2NhbkRldGFpbFIHZGV0YW'
        'lscxImCg9oYXNfaGFyZF9ibG9ja3MYAyABKAhSDWhhc0hhcmRCbG9ja3M=');

@$core.Deprecated('Use packagingServiceGetReportRequestDescriptor instead')
const PackagingServiceGetReportRequest$json = {
  '1': 'PackagingServiceGetReportRequest',
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
    {'1': 'publish_item_id', '3': 3, '4': 1, '5': 9, '10': 'publishItemId'},
  ],
};

/// Descriptor for `PackagingServiceGetReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceGetReportRequestDescriptor =
    $convert.base64Decode(
        'CiBQYWNrYWdpbmdTZXJ2aWNlR2V0UmVwb3J0UmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKA'
        'syGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSGQoIYXNzZXRfaWQY'
        'AiABKAlSB2Fzc2V0SWQSJgoPcHVibGlzaF9pdGVtX2lkGAMgASgJUg1wdWJsaXNoSXRlbUlk');

@$core.Deprecated('Use packagingServiceGetReportResponseDescriptor instead')
const PackagingServiceGetReportResponse$json = {
  '1': 'PackagingServiceGetReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.PackagingReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `PackagingServiceGetReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceGetReportResponseDescriptor =
    $convert.base64Decode(
        'CiFQYWNrYWdpbmdTZXJ2aWNlR2V0UmVwb3J0UmVzcG9uc2USQgoGcmVwb3J0GAEgASgLMiouY3'
        'JlYXRpdmFudGEucHJvZHVjdGlvbi52MS5QYWNrYWdpbmdSZXBvcnRSBnJlcG9ydA==');

@$core.Deprecated('Use packagingServiceBatchScoreRequestDescriptor instead')
const PackagingServiceBatchScoreRequest$json = {
  '1': 'PackagingServiceBatchScoreRequest',
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
    {'1': 'target_platform', '3': 3, '4': 1, '5': 9, '10': 'targetPlatform'},
  ],
};

/// Descriptor for `PackagingServiceBatchScoreRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceBatchScoreRequestDescriptor =
    $convert.base64Decode(
        'CiFQYWNrYWdpbmdTZXJ2aWNlQmF0Y2hTY29yZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLm'
        'NyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIbCglhc3NldF9p'
        'ZHMYAiADKAlSCGFzc2V0SWRzEicKD3RhcmdldF9wbGF0Zm9ybRgDIAEoCVIOdGFyZ2V0UGxhdG'
        'Zvcm0=');

@$core.Deprecated('Use packagingServiceBatchScoreResponseDescriptor instead')
const PackagingServiceBatchScoreResponse$json = {
  '1': 'PackagingServiceBatchScoreResponse',
  '2': [
    {'1': 'total_items', '3': 1, '4': 1, '5': 5, '10': 'totalItems'},
    {'1': 'scored_count', '3': 2, '4': 1, '5': 5, '10': 'scoredCount'},
    {'1': 'failed_count', '3': 3, '4': 1, '5': 5, '10': 'failedCount'},
    {
      '1': 'reports',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.PackagingReport',
      '10': 'reports'
    },
    {
      '1': 'failures',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.BatchItemError',
      '10': 'failures'
    },
  ],
};

/// Descriptor for `PackagingServiceBatchScoreResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceBatchScoreResponseDescriptor = $convert.base64Decode(
    'CiJQYWNrYWdpbmdTZXJ2aWNlQmF0Y2hTY29yZVJlc3BvbnNlEh8KC3RvdGFsX2l0ZW1zGAEgAS'
    'gFUgp0b3RhbEl0ZW1zEiEKDHNjb3JlZF9jb3VudBgCIAEoBVILc2NvcmVkQ291bnQSIQoMZmFp'
    'bGVkX2NvdW50GAMgASgFUgtmYWlsZWRDb3VudBJECgdyZXBvcnRzGAQgAygLMiouY3JlYXRpdm'
    'FudGEucHJvZHVjdGlvbi52MS5QYWNrYWdpbmdSZXBvcnRSB3JlcG9ydHMSRQoIZmFpbHVyZXMY'
    'BSADKAsyKS5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLkJhdGNoSXRlbUVycm9yUghmYWlsdX'
    'Jlcw==');

@$core.Deprecated('Use packagingServiceOverrideResultRequestDescriptor instead')
const PackagingServiceOverrideResultRequest$json = {
  '1': 'PackagingServiceOverrideResultRequest',
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
    {'1': 'publish_item_id', '3': 3, '4': 1, '5': 9, '10': 'publishItemId'},
    {
      '1': 'check_id_or_category',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'checkIdOrCategory'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `PackagingServiceOverrideResultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceOverrideResultRequestDescriptor =
    $convert.base64Decode(
        'CiVQYWNrYWdpbmdTZXJ2aWNlT3ZlcnJpZGVSZXN1bHRSZXF1ZXN0Ej8KB2NvbnRleHQYASABKA'
        'syJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGQoIYXNz'
        'ZXRfaWQYAiABKAlSB2Fzc2V0SWQSJgoPcHVibGlzaF9pdGVtX2lkGAMgASgJUg1wdWJsaXNoSX'
        'RlbUlkEi8KFGNoZWNrX2lkX29yX2NhdGVnb3J5GAQgASgJUhFjaGVja0lkT3JDYXRlZ29yeRIW'
        'CgZyZWFzb24YBSABKAlSBnJlYXNvbg==');

@$core
    .Deprecated('Use packagingServiceOverrideResultResponseDescriptor instead')
const PackagingServiceOverrideResultResponse$json = {
  '1': 'PackagingServiceOverrideResultResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'updated_report',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.PackagingReport',
      '10': 'updatedReport'
    },
  ],
};

/// Descriptor for `PackagingServiceOverrideResultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceOverrideResultResponseDescriptor =
    $convert.base64Decode(
        'CiZQYWNrYWdpbmdTZXJ2aWNlT3ZlcnJpZGVSZXN1bHRSZXNwb25zZRIYCgdzdWNjZXNzGAEgAS'
        'gIUgdzdWNjZXNzEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USUQoOdXBkYXRlZF9yZXBvcnQY'
        'AyABKAsyKi5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlBhY2thZ2luZ1JlcG9ydFINdXBkYX'
        'RlZFJlcG9ydA==');

@$core.Deprecated('Use packagingServiceGetHistoryRequestDescriptor instead')
const PackagingServiceGetHistoryRequest$json = {
  '1': 'PackagingServiceGetHistoryRequest',
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

/// Descriptor for `PackagingServiceGetHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceGetHistoryRequestDescriptor =
    $convert.base64Decode(
        'CiFQYWNrYWdpbmdTZXJ2aWNlR2V0SGlzdG9yeVJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgAS'
        'gLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEhkKCGFzc2V0X2lk'
        'GAIgASgJUgdhc3NldElkEkEKCnBhZ2luYXRpb24YAyABKAsyIS5jcmVhdGl2YW50YS5jb21tb2'
        '4udjEuUGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use packagingServiceGetHistoryResponseDescriptor instead')
const PackagingServiceGetHistoryResponse$json = {
  '1': 'PackagingServiceGetHistoryResponse',
  '2': [
    {
      '1': 'reports',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.production.v1.PackagingReport',
      '10': 'reports'
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

/// Descriptor for `PackagingServiceGetHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceGetHistoryResponseDescriptor =
    $convert.base64Decode(
        'CiJQYWNrYWdpbmdTZXJ2aWNlR2V0SGlzdG9yeVJlc3BvbnNlEkQKB3JlcG9ydHMYASADKAsyKi'
        '5jcmVhdGl2YW50YS5wcm9kdWN0aW9uLnYxLlBhY2thZ2luZ1JlcG9ydFIHcmVwb3J0cxJICgpw'
        'YWdpbmF0aW9uGAIgASgLMiguY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3Bvbn'
        'NlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use packagingServiceRunQARequestDescriptor instead')
const PackagingServiceRunQARequest$json = {
  '1': 'PackagingServiceRunQARequest',
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
    {'1': 'target_platforms', '3': 3, '4': 3, '5': 9, '10': 'targetPlatforms'},
    {'1': 'preset_id', '3': 4, '4': 1, '5': 9, '10': 'presetId'},
  ],
};

/// Descriptor for `PackagingServiceRunQARequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceRunQARequestDescriptor = $convert.base64Decode(
    'ChxQYWNrYWdpbmdTZXJ2aWNlUnVuUUFSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGQoIYXNzZXRfaWQYAiAB'
    'KAlSB2Fzc2V0SWQSKQoQdGFyZ2V0X3BsYXRmb3JtcxgDIAMoCVIPdGFyZ2V0UGxhdGZvcm1zEh'
    'sKCXByZXNldF9pZBgEIAEoCVIIcHJlc2V0SWQ=');

@$core.Deprecated('Use packagingServiceRunQAResponseDescriptor instead')
const PackagingServiceRunQAResponse$json = {
  '1': 'PackagingServiceRunQAResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.production.v1.PackagingReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `PackagingServiceRunQAResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packagingServiceRunQAResponseDescriptor =
    $convert.base64Decode(
        'Ch1QYWNrYWdpbmdTZXJ2aWNlUnVuUUFSZXNwb25zZRJCCgZyZXBvcnQYASABKAsyKi5jcmVhdG'
        'l2YW50YS5wcm9kdWN0aW9uLnYxLlBhY2thZ2luZ1JlcG9ydFIGcmVwb3J0');

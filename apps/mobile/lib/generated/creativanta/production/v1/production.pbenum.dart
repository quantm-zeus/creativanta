// This is a generated file - do not edit.
//
// Generated from creativanta/production/v1/production.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// GenerationJobStatus matches database_schema.md §7.4 generation_jobs.status.
class GenerationJobStatus extends $pb.ProtobufEnum {
  static const GenerationJobStatus GENERATION_JOB_STATUS_UNSPECIFIED =
      GenerationJobStatus._(
          0, _omitEnumNames ? '' : 'GENERATION_JOB_STATUS_UNSPECIFIED');
  static const GenerationJobStatus GENERATION_JOB_STATUS_QUEUED =
      GenerationJobStatus._(
          1, _omitEnumNames ? '' : 'GENERATION_JOB_STATUS_QUEUED');
  static const GenerationJobStatus GENERATION_JOB_STATUS_PROCESSING =
      GenerationJobStatus._(
          2, _omitEnumNames ? '' : 'GENERATION_JOB_STATUS_PROCESSING');
  static const GenerationJobStatus GENERATION_JOB_STATUS_COMPLETED =
      GenerationJobStatus._(
          3, _omitEnumNames ? '' : 'GENERATION_JOB_STATUS_COMPLETED');
  static const GenerationJobStatus GENERATION_JOB_STATUS_FAILED =
      GenerationJobStatus._(
          4, _omitEnumNames ? '' : 'GENERATION_JOB_STATUS_FAILED');
  static const GenerationJobStatus GENERATION_JOB_STATUS_CANCELLED =
      GenerationJobStatus._(
          5, _omitEnumNames ? '' : 'GENERATION_JOB_STATUS_CANCELLED');

  static const $core.List<GenerationJobStatus> values = <GenerationJobStatus>[
    GENERATION_JOB_STATUS_UNSPECIFIED,
    GENERATION_JOB_STATUS_QUEUED,
    GENERATION_JOB_STATUS_PROCESSING,
    GENERATION_JOB_STATUS_COMPLETED,
    GENERATION_JOB_STATUS_FAILED,
    GENERATION_JOB_STATUS_CANCELLED,
  ];

  static final $core.List<GenerationJobStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static GenerationJobStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GenerationJobStatus._(super.value, super.name);
}

/// AssetGenerationState matches database_schema.md §7.3 assets.generation_state.
class AssetGenerationState extends $pb.ProtobufEnum {
  static const AssetGenerationState ASSET_GENERATION_STATE_UNSPECIFIED =
      AssetGenerationState._(
          0, _omitEnumNames ? '' : 'ASSET_GENERATION_STATE_UNSPECIFIED');
  static const AssetGenerationState ASSET_GENERATION_STATE_QUEUED =
      AssetGenerationState._(
          1, _omitEnumNames ? '' : 'ASSET_GENERATION_STATE_QUEUED');
  static const AssetGenerationState ASSET_GENERATION_STATE_GENERATING =
      AssetGenerationState._(
          2, _omitEnumNames ? '' : 'ASSET_GENERATION_STATE_GENERATING');
  static const AssetGenerationState ASSET_GENERATION_STATE_GENERATED =
      AssetGenerationState._(
          3, _omitEnumNames ? '' : 'ASSET_GENERATION_STATE_GENERATED');
  static const AssetGenerationState ASSET_GENERATION_STATE_FAILED =
      AssetGenerationState._(
          4, _omitEnumNames ? '' : 'ASSET_GENERATION_STATE_FAILED');
  static const AssetGenerationState ASSET_GENERATION_STATE_CANCELLED =
      AssetGenerationState._(
          5, _omitEnumNames ? '' : 'ASSET_GENERATION_STATE_CANCELLED');

  static const $core.List<AssetGenerationState> values = <AssetGenerationState>[
    ASSET_GENERATION_STATE_UNSPECIFIED,
    ASSET_GENERATION_STATE_QUEUED,
    ASSET_GENERATION_STATE_GENERATING,
    ASSET_GENERATION_STATE_GENERATED,
    ASSET_GENERATION_STATE_FAILED,
    ASSET_GENERATION_STATE_CANCELLED,
  ];

  static final $core.List<AssetGenerationState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AssetGenerationState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssetGenerationState._(super.value, super.name);
}

/// AssetQualityState matches database_schema.md §7.3 assets.quality_state.
class AssetQualityState extends $pb.ProtobufEnum {
  static const AssetQualityState ASSET_QUALITY_STATE_UNSPECIFIED =
      AssetQualityState._(
          0, _omitEnumNames ? '' : 'ASSET_QUALITY_STATE_UNSPECIFIED');
  static const AssetQualityState ASSET_QUALITY_STATE_DRAFT =
      AssetQualityState._(1, _omitEnumNames ? '' : 'ASSET_QUALITY_STATE_DRAFT');
  static const AssetQualityState ASSET_QUALITY_STATE_REVIEW_REQUIRED =
      AssetQualityState._(
          2, _omitEnumNames ? '' : 'ASSET_QUALITY_STATE_REVIEW_REQUIRED');
  static const AssetQualityState ASSET_QUALITY_STATE_APPROVED =
      AssetQualityState._(
          3, _omitEnumNames ? '' : 'ASSET_QUALITY_STATE_APPROVED');
  static const AssetQualityState ASSET_QUALITY_STATE_REJECTED =
      AssetQualityState._(
          4, _omitEnumNames ? '' : 'ASSET_QUALITY_STATE_REJECTED');
  static const AssetQualityState ASSET_QUALITY_STATE_PROMOTED_CANONICAL =
      AssetQualityState._(
          5, _omitEnumNames ? '' : 'ASSET_QUALITY_STATE_PROMOTED_CANONICAL');

  static const $core.List<AssetQualityState> values = <AssetQualityState>[
    ASSET_QUALITY_STATE_UNSPECIFIED,
    ASSET_QUALITY_STATE_DRAFT,
    ASSET_QUALITY_STATE_REVIEW_REQUIRED,
    ASSET_QUALITY_STATE_APPROVED,
    ASSET_QUALITY_STATE_REJECTED,
    ASSET_QUALITY_STATE_PROMOTED_CANONICAL,
  ];

  static final $core.List<AssetQualityState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AssetQualityState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssetQualityState._(super.value, super.name);
}

/// PipelineStrategy matches database_schema.md §7.4 generation_jobs.pipeline_strategy.
class PipelineStrategy extends $pb.ProtobufEnum {
  static const PipelineStrategy PIPELINE_STRATEGY_UNSPECIFIED =
      PipelineStrategy._(
          0, _omitEnumNames ? '' : 'PIPELINE_STRATEGY_UNSPECIFIED');
  static const PipelineStrategy PIPELINE_STRATEGY_NATIVE_AUDIO =
      PipelineStrategy._(
          1, _omitEnumNames ? '' : 'PIPELINE_STRATEGY_NATIVE_AUDIO');
  static const PipelineStrategy PIPELINE_STRATEGY_AUDIO_FIRST =
      PipelineStrategy._(
          2, _omitEnumNames ? '' : 'PIPELINE_STRATEGY_AUDIO_FIRST');
  static const PipelineStrategy PIPELINE_STRATEGY_POST_PROD_LIP_SYNC =
      PipelineStrategy._(
          3, _omitEnumNames ? '' : 'PIPELINE_STRATEGY_POST_PROD_LIP_SYNC');
  static const PipelineStrategy PIPELINE_STRATEGY_SIMPLE_VOICE_OVER =
      PipelineStrategy._(
          4, _omitEnumNames ? '' : 'PIPELINE_STRATEGY_SIMPLE_VOICE_OVER');

  static const $core.List<PipelineStrategy> values = <PipelineStrategy>[
    PIPELINE_STRATEGY_UNSPECIFIED,
    PIPELINE_STRATEGY_NATIVE_AUDIO,
    PIPELINE_STRATEGY_AUDIO_FIRST,
    PIPELINE_STRATEGY_POST_PROD_LIP_SYNC,
    PIPELINE_STRATEGY_SIMPLE_VOICE_OVER,
  ];

  static final $core.List<PipelineStrategy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PipelineStrategy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PipelineStrategy._(super.value, super.name);
}

/// ProductionMode tracks the 4 core + 11 extended studio modes (ai_video_studio.md §Scope).
class ProductionMode extends $pb.ProtobufEnum {
  static const ProductionMode PRODUCTION_MODE_UNSPECIFIED =
      ProductionMode._(0, _omitEnumNames ? '' : 'PRODUCTION_MODE_UNSPECIFIED');
  static const ProductionMode PRODUCTION_MODE_QUICK_EDIT =
      ProductionMode._(1, _omitEnumNames ? '' : 'PRODUCTION_MODE_QUICK_EDIT');
  static const ProductionMode PRODUCTION_MODE_CLIP_FACTORY =
      ProductionMode._(2, _omitEnumNames ? '' : 'PRODUCTION_MODE_CLIP_FACTORY');
  static const ProductionMode PRODUCTION_MODE_MULTI_MERGE =
      ProductionMode._(3, _omitEnumNames ? '' : 'PRODUCTION_MODE_MULTI_MERGE');
  static const ProductionMode PRODUCTION_MODE_AI_REMIX =
      ProductionMode._(4, _omitEnumNames ? '' : 'PRODUCTION_MODE_AI_REMIX');
  static const ProductionMode PRODUCTION_MODE_PRODUCT_SHOWCASE =
      ProductionMode._(
          5, _omitEnumNames ? '' : 'PRODUCTION_MODE_PRODUCT_SHOWCASE');
  static const ProductionMode PRODUCTION_MODE_IMAGE_TO_VIDEO = ProductionMode._(
      6, _omitEnumNames ? '' : 'PRODUCTION_MODE_IMAGE_TO_VIDEO');
  static const ProductionMode PRODUCTION_MODE_LINK_TO_VIDEO = ProductionMode._(
      7, _omitEnumNames ? '' : 'PRODUCTION_MODE_LINK_TO_VIDEO');
  static const ProductionMode PRODUCTION_MODE_TRANSLATION =
      ProductionMode._(8, _omitEnumNames ? '' : 'PRODUCTION_MODE_TRANSLATION');
  static const ProductionMode PRODUCTION_MODE_VIDEO_AGENT =
      ProductionMode._(9, _omitEnumNames ? '' : 'PRODUCTION_MODE_VIDEO_AGENT');
  static const ProductionMode PRODUCTION_MODE_THUMBNAIL_STUDIO =
      ProductionMode._(
          10, _omitEnumNames ? '' : 'PRODUCTION_MODE_THUMBNAIL_STUDIO');
  static const ProductionMode PRODUCTION_MODE_SOUND_STUDIO = ProductionMode._(
      11, _omitEnumNames ? '' : 'PRODUCTION_MODE_SOUND_STUDIO');
  static const ProductionMode PRODUCTION_MODE_STYLE_LEARNING = ProductionMode._(
      12, _omitEnumNames ? '' : 'PRODUCTION_MODE_STYLE_LEARNING');

  static const $core.List<ProductionMode> values = <ProductionMode>[
    PRODUCTION_MODE_UNSPECIFIED,
    PRODUCTION_MODE_QUICK_EDIT,
    PRODUCTION_MODE_CLIP_FACTORY,
    PRODUCTION_MODE_MULTI_MERGE,
    PRODUCTION_MODE_AI_REMIX,
    PRODUCTION_MODE_PRODUCT_SHOWCASE,
    PRODUCTION_MODE_IMAGE_TO_VIDEO,
    PRODUCTION_MODE_LINK_TO_VIDEO,
    PRODUCTION_MODE_TRANSLATION,
    PRODUCTION_MODE_VIDEO_AGENT,
    PRODUCTION_MODE_THUMBNAIL_STUDIO,
    PRODUCTION_MODE_SOUND_STUDIO,
    PRODUCTION_MODE_STYLE_LEARNING,
  ];

  static final $core.List<ProductionMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 12);
  static ProductionMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProductionMode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

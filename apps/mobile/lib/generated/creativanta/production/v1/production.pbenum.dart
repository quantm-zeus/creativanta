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

/// FidelityLevel represents fidelity options for AI remix recreation (Pack 04 §9.5).
class FidelityLevel extends $pb.ProtobufEnum {
  static const FidelityLevel FIDELITY_LEVEL_UNSPECIFIED =
      FidelityLevel._(0, _omitEnumNames ? '' : 'FIDELITY_LEVEL_UNSPECIFIED');
  static const FidelityLevel FIDELITY_LEVEL_MATCH_1TO1 =
      FidelityLevel._(1, _omitEnumNames ? '' : 'FIDELITY_LEVEL_MATCH_1TO1');
  static const FidelityLevel FIDELITY_LEVEL_ADAPT =
      FidelityLevel._(2, _omitEnumNames ? '' : 'FIDELITY_LEVEL_ADAPT');
  static const FidelityLevel FIDELITY_LEVEL_LOOSE =
      FidelityLevel._(3, _omitEnumNames ? '' : 'FIDELITY_LEVEL_LOOSE');

  static const $core.List<FidelityLevel> values = <FidelityLevel>[
    FIDELITY_LEVEL_UNSPECIFIED,
    FIDELITY_LEVEL_MATCH_1TO1,
    FIDELITY_LEVEL_ADAPT,
    FIDELITY_LEVEL_LOOSE,
  ];

  static final $core.List<FidelityLevel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static FidelityLevel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FidelityLevel._(super.value, super.name);
}

/// RemixStatus represents blueprint progression status (database_schema.md §22.2).
class RemixStatus extends $pb.ProtobufEnum {
  static const RemixStatus REMIX_STATUS_UNSPECIFIED =
      RemixStatus._(0, _omitEnumNames ? '' : 'REMIX_STATUS_UNSPECIFIED');
  static const RemixStatus REMIX_STATUS_ANALYZING =
      RemixStatus._(1, _omitEnumNames ? '' : 'REMIX_STATUS_ANALYZING');
  static const RemixStatus REMIX_STATUS_ANALYZED =
      RemixStatus._(2, _omitEnumNames ? '' : 'REMIX_STATUS_ANALYZED');
  static const RemixStatus REMIX_STATUS_GENERATING =
      RemixStatus._(3, _omitEnumNames ? '' : 'REMIX_STATUS_GENERATING');
  static const RemixStatus REMIX_STATUS_GENERATED =
      RemixStatus._(4, _omitEnumNames ? '' : 'REMIX_STATUS_GENERATED');
  static const RemixStatus REMIX_STATUS_FAILED =
      RemixStatus._(5, _omitEnumNames ? '' : 'REMIX_STATUS_FAILED');
  static const RemixStatus REMIX_STATUS_REJECTED =
      RemixStatus._(6, _omitEnumNames ? '' : 'REMIX_STATUS_REJECTED');

  static const $core.List<RemixStatus> values = <RemixStatus>[
    REMIX_STATUS_UNSPECIFIED,
    REMIX_STATUS_ANALYZING,
    REMIX_STATUS_ANALYZED,
    REMIX_STATUS_GENERATING,
    REMIX_STATUS_GENERATED,
    REMIX_STATUS_FAILED,
    REMIX_STATUS_REJECTED,
  ];

  static final $core.List<RemixStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static RemixStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RemixStatus._(super.value, super.name);
}

/// VideoEditJobStatus represents status of video edit jobs (database_schema.md §22.1).
class VideoEditJobStatus extends $pb.ProtobufEnum {
  static const VideoEditJobStatus VIDEO_EDIT_JOB_STATUS_UNSPECIFIED =
      VideoEditJobStatus._(
          0, _omitEnumNames ? '' : 'VIDEO_EDIT_JOB_STATUS_UNSPECIFIED');
  static const VideoEditJobStatus VIDEO_EDIT_JOB_STATUS_QUEUED =
      VideoEditJobStatus._(
          1, _omitEnumNames ? '' : 'VIDEO_EDIT_JOB_STATUS_QUEUED');
  static const VideoEditJobStatus VIDEO_EDIT_JOB_STATUS_PROCESSING =
      VideoEditJobStatus._(
          2, _omitEnumNames ? '' : 'VIDEO_EDIT_JOB_STATUS_PROCESSING');
  static const VideoEditJobStatus VIDEO_EDIT_JOB_STATUS_COMPLETED =
      VideoEditJobStatus._(
          3, _omitEnumNames ? '' : 'VIDEO_EDIT_JOB_STATUS_COMPLETED');
  static const VideoEditJobStatus VIDEO_EDIT_JOB_STATUS_PARTIALLY_COMPLETED =
      VideoEditJobStatus._(
          4, _omitEnumNames ? '' : 'VIDEO_EDIT_JOB_STATUS_PARTIALLY_COMPLETED');
  static const VideoEditJobStatus VIDEO_EDIT_JOB_STATUS_FAILED =
      VideoEditJobStatus._(
          5, _omitEnumNames ? '' : 'VIDEO_EDIT_JOB_STATUS_FAILED');
  static const VideoEditJobStatus VIDEO_EDIT_JOB_STATUS_CANCELLED =
      VideoEditJobStatus._(
          6, _omitEnumNames ? '' : 'VIDEO_EDIT_JOB_STATUS_CANCELLED');

  static const $core.List<VideoEditJobStatus> values = <VideoEditJobStatus>[
    VIDEO_EDIT_JOB_STATUS_UNSPECIFIED,
    VIDEO_EDIT_JOB_STATUS_QUEUED,
    VIDEO_EDIT_JOB_STATUS_PROCESSING,
    VIDEO_EDIT_JOB_STATUS_COMPLETED,
    VIDEO_EDIT_JOB_STATUS_PARTIALLY_COMPLETED,
    VIDEO_EDIT_JOB_STATUS_FAILED,
    VIDEO_EDIT_JOB_STATUS_CANCELLED,
  ];

  static final $core.List<VideoEditJobStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static VideoEditJobStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VideoEditJobStatus._(super.value, super.name);
}

class TranscriptAlignmentStatus extends $pb.ProtobufEnum {
  static const TranscriptAlignmentStatus
      TRANSCRIPT_ALIGNMENT_STATUS_UNSPECIFIED = TranscriptAlignmentStatus._(
          0, _omitEnumNames ? '' : 'TRANSCRIPT_ALIGNMENT_STATUS_UNSPECIFIED');
  static const TranscriptAlignmentStatus
      TRANSCRIPT_ALIGNMENT_STATUS_AUTO_ALIGNED = TranscriptAlignmentStatus._(
          1, _omitEnumNames ? '' : 'TRANSCRIPT_ALIGNMENT_STATUS_AUTO_ALIGNED');
  static const TranscriptAlignmentStatus TRANSCRIPT_ALIGNMENT_STATUS_REPAIRED =
      TranscriptAlignmentStatus._(
          2, _omitEnumNames ? '' : 'TRANSCRIPT_ALIGNMENT_STATUS_REPAIRED');
  static const TranscriptAlignmentStatus
      TRANSCRIPT_ALIGNMENT_STATUS_MANUAL_FALLBACK = TranscriptAlignmentStatus._(
          3,
          _omitEnumNames ? '' : 'TRANSCRIPT_ALIGNMENT_STATUS_MANUAL_FALLBACK');
  static const TranscriptAlignmentStatus TRANSCRIPT_ALIGNMENT_STATUS_FAILED =
      TranscriptAlignmentStatus._(
          4, _omitEnumNames ? '' : 'TRANSCRIPT_ALIGNMENT_STATUS_FAILED');

  static const $core.List<TranscriptAlignmentStatus> values =
      <TranscriptAlignmentStatus>[
    TRANSCRIPT_ALIGNMENT_STATUS_UNSPECIFIED,
    TRANSCRIPT_ALIGNMENT_STATUS_AUTO_ALIGNED,
    TRANSCRIPT_ALIGNMENT_STATUS_REPAIRED,
    TRANSCRIPT_ALIGNMENT_STATUS_MANUAL_FALLBACK,
    TRANSCRIPT_ALIGNMENT_STATUS_FAILED,
  ];

  static final $core.List<TranscriptAlignmentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TranscriptAlignmentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TranscriptAlignmentStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

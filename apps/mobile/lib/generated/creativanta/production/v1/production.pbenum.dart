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

class ImageMotionStyle extends $pb.ProtobufEnum {
  static const ImageMotionStyle IMAGE_MOTION_STYLE_UNSPECIFIED =
      ImageMotionStyle._(
          0, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_UNSPECIFIED');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_CINEMATIC_PAN =
      ImageMotionStyle._(
          1, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_CINEMATIC_PAN');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_PRODUCT_ROTATE =
      ImageMotionStyle._(
          2, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_PRODUCT_ROTATE');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_PARALLAX_3D =
      ImageMotionStyle._(
          3, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_PARALLAX_3D');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_SUBTLE_MOVEMENT =
      ImageMotionStyle._(
          4, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_SUBTLE_MOVEMENT');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_ZOOM_IN =
      ImageMotionStyle._(5, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_ZOOM_IN');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_CUSTOM_PROMPT =
      ImageMotionStyle._(
          6, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_CUSTOM_PROMPT');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_KEN_BURNS =
      ImageMotionStyle._(
          7, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_KEN_BURNS');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_MORPH =
      ImageMotionStyle._(8, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_MORPH');
  static const ImageMotionStyle IMAGE_MOTION_STYLE_RANDOM =
      ImageMotionStyle._(9, _omitEnumNames ? '' : 'IMAGE_MOTION_STYLE_RANDOM');

  static const $core.List<ImageMotionStyle> values = <ImageMotionStyle>[
    IMAGE_MOTION_STYLE_UNSPECIFIED,
    IMAGE_MOTION_STYLE_CINEMATIC_PAN,
    IMAGE_MOTION_STYLE_PRODUCT_ROTATE,
    IMAGE_MOTION_STYLE_PARALLAX_3D,
    IMAGE_MOTION_STYLE_SUBTLE_MOVEMENT,
    IMAGE_MOTION_STYLE_ZOOM_IN,
    IMAGE_MOTION_STYLE_CUSTOM_PROMPT,
    IMAGE_MOTION_STYLE_KEN_BURNS,
    IMAGE_MOTION_STYLE_MORPH,
    IMAGE_MOTION_STYLE_RANDOM,
  ];

  static final $core.List<ImageMotionStyle?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static ImageMotionStyle? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ImageMotionStyle._(super.value, super.name);
}

class ThumbnailTemplateStyle extends $pb.ProtobufEnum {
  static const ThumbnailTemplateStyle THUMBNAIL_TEMPLATE_STYLE_UNSPECIFIED =
      ThumbnailTemplateStyle._(
          0, _omitEnumNames ? '' : 'THUMBNAIL_TEMPLATE_STYLE_UNSPECIFIED');
  static const ThumbnailTemplateStyle THUMBNAIL_TEMPLATE_STYLE_EMOTION =
      ThumbnailTemplateStyle._(
          1, _omitEnumNames ? '' : 'THUMBNAIL_TEMPLATE_STYLE_EMOTION');
  static const ThumbnailTemplateStyle THUMBNAIL_TEMPLATE_STYLE_YOUTUBE =
      ThumbnailTemplateStyle._(
          2, _omitEnumNames ? '' : 'THUMBNAIL_TEMPLATE_STYLE_YOUTUBE');
  static const ThumbnailTemplateStyle THUMBNAIL_TEMPLATE_STYLE_SPLIT =
      ThumbnailTemplateStyle._(
          3, _omitEnumNames ? '' : 'THUMBNAIL_TEMPLATE_STYLE_SPLIT');
  static const ThumbnailTemplateStyle THUMBNAIL_TEMPLATE_STYLE_CLICKBAIT =
      ThumbnailTemplateStyle._(
          4, _omitEnumNames ? '' : 'THUMBNAIL_TEMPLATE_STYLE_CLICKBAIT');
  static const ThumbnailTemplateStyle THUMBNAIL_TEMPLATE_STYLE_CLEAN =
      ThumbnailTemplateStyle._(
          5, _omitEnumNames ? '' : 'THUMBNAIL_TEMPLATE_STYLE_CLEAN');

  static const $core.List<ThumbnailTemplateStyle> values =
      <ThumbnailTemplateStyle>[
    THUMBNAIL_TEMPLATE_STYLE_UNSPECIFIED,
    THUMBNAIL_TEMPLATE_STYLE_EMOTION,
    THUMBNAIL_TEMPLATE_STYLE_YOUTUBE,
    THUMBNAIL_TEMPLATE_STYLE_SPLIT,
    THUMBNAIL_TEMPLATE_STYLE_CLICKBAIT,
    THUMBNAIL_TEMPLATE_STYLE_CLEAN,
  ];

  static final $core.List<ThumbnailTemplateStyle?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ThumbnailTemplateStyle? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThumbnailTemplateStyle._(super.value, super.name);
}

class ShowcaseStyle extends $pb.ProtobufEnum {
  static const ShowcaseStyle SHOWCASE_STYLE_UNSPECIFIED =
      ShowcaseStyle._(0, _omitEnumNames ? '' : 'SHOWCASE_STYLE_UNSPECIFIED');
  static const ShowcaseStyle SHOWCASE_STYLE_360_SPIN =
      ShowcaseStyle._(1, _omitEnumNames ? '' : 'SHOWCASE_STYLE_360_SPIN');
  static const ShowcaseStyle SHOWCASE_STYLE_TABLETOP_DEMO =
      ShowcaseStyle._(2, _omitEnumNames ? '' : 'SHOWCASE_STYLE_TABLETOP_DEMO');
  static const ShowcaseStyle SHOWCASE_STYLE_FLIP_REVEAL =
      ShowcaseStyle._(3, _omitEnumNames ? '' : 'SHOWCASE_STYLE_FLIP_REVEAL');
  static const ShowcaseStyle SHOWCASE_STYLE_VIRTUAL_TRY_ON =
      ShowcaseStyle._(4, _omitEnumNames ? '' : 'SHOWCASE_STYLE_VIRTUAL_TRY_ON');
  static const ShowcaseStyle SHOWCASE_STYLE_LIFESTYLE_CONTEXT = ShowcaseStyle._(
      5, _omitEnumNames ? '' : 'SHOWCASE_STYLE_LIFESTYLE_CONTEXT');
  static const ShowcaseStyle SHOWCASE_STYLE_UNBOXING_SIMULATION =
      ShowcaseStyle._(
          6, _omitEnumNames ? '' : 'SHOWCASE_STYLE_UNBOXING_SIMULATION');
  static const ShowcaseStyle SHOWCASE_STYLE_BEFORE_AFTER =
      ShowcaseStyle._(7, _omitEnumNames ? '' : 'SHOWCASE_STYLE_BEFORE_AFTER');
  static const ShowcaseStyle SHOWCASE_STYLE_REVIEW_STYLE =
      ShowcaseStyle._(8, _omitEnumNames ? '' : 'SHOWCASE_STYLE_REVIEW_STYLE');

  static const $core.List<ShowcaseStyle> values = <ShowcaseStyle>[
    SHOWCASE_STYLE_UNSPECIFIED,
    SHOWCASE_STYLE_360_SPIN,
    SHOWCASE_STYLE_TABLETOP_DEMO,
    SHOWCASE_STYLE_FLIP_REVEAL,
    SHOWCASE_STYLE_VIRTUAL_TRY_ON,
    SHOWCASE_STYLE_LIFESTYLE_CONTEXT,
    SHOWCASE_STYLE_UNBOXING_SIMULATION,
    SHOWCASE_STYLE_BEFORE_AFTER,
    SHOWCASE_STYLE_REVIEW_STYLE,
  ];

  static final $core.List<ShowcaseStyle?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static ShowcaseStyle? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ShowcaseStyle._(super.value, super.name);
}

class ScriptTemplate extends $pb.ProtobufEnum {
  static const ScriptTemplate SCRIPT_TEMPLATE_UNSPECIFIED =
      ScriptTemplate._(0, _omitEnumNames ? '' : 'SCRIPT_TEMPLATE_UNSPECIFIED');
  static const ScriptTemplate SCRIPT_TEMPLATE_PROBLEM_SOLUTION =
      ScriptTemplate._(
          1, _omitEnumNames ? '' : 'SCRIPT_TEMPLATE_PROBLEM_SOLUTION');
  static const ScriptTemplate SCRIPT_TEMPLATE_LISTICLE_REVIEW =
      ScriptTemplate._(
          2, _omitEnumNames ? '' : 'SCRIPT_TEMPLATE_LISTICLE_REVIEW');
  static const ScriptTemplate SCRIPT_TEMPLATE_TESTIMONIAL =
      ScriptTemplate._(3, _omitEnumNames ? '' : 'SCRIPT_TEMPLATE_TESTIMONIAL');
  static const ScriptTemplate SCRIPT_TEMPLATE_FLASH_SALE =
      ScriptTemplate._(4, _omitEnumNames ? '' : 'SCRIPT_TEMPLATE_FLASH_SALE');
  static const ScriptTemplate SCRIPT_TEMPLATE_COMPARISON =
      ScriptTemplate._(5, _omitEnumNames ? '' : 'SCRIPT_TEMPLATE_COMPARISON');

  static const $core.List<ScriptTemplate> values = <ScriptTemplate>[
    SCRIPT_TEMPLATE_UNSPECIFIED,
    SCRIPT_TEMPLATE_PROBLEM_SOLUTION,
    SCRIPT_TEMPLATE_LISTICLE_REVIEW,
    SCRIPT_TEMPLATE_TESTIMONIAL,
    SCRIPT_TEMPLATE_FLASH_SALE,
    SCRIPT_TEMPLATE_COMPARISON,
  ];

  static final $core.List<ScriptTemplate?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ScriptTemplate? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ScriptTemplate._(super.value, super.name);
}

class LinkPlatform extends $pb.ProtobufEnum {
  static const LinkPlatform LINK_PLATFORM_UNSPECIFIED =
      LinkPlatform._(0, _omitEnumNames ? '' : 'LINK_PLATFORM_UNSPECIFIED');
  static const LinkPlatform LINK_PLATFORM_SHOPEE =
      LinkPlatform._(1, _omitEnumNames ? '' : 'LINK_PLATFORM_SHOPEE');
  static const LinkPlatform LINK_PLATFORM_LAZADA =
      LinkPlatform._(2, _omitEnumNames ? '' : 'LINK_PLATFORM_LAZADA');
  static const LinkPlatform LINK_PLATFORM_TIKTOK_SHOP =
      LinkPlatform._(3, _omitEnumNames ? '' : 'LINK_PLATFORM_TIKTOK_SHOP');
  static const LinkPlatform LINK_PLATFORM_AMAZON =
      LinkPlatform._(4, _omitEnumNames ? '' : 'LINK_PLATFORM_AMAZON');
  static const LinkPlatform LINK_PLATFORM_SHOPIFY =
      LinkPlatform._(5, _omitEnumNames ? '' : 'LINK_PLATFORM_SHOPIFY');
  static const LinkPlatform LINK_PLATFORM_GENERIC =
      LinkPlatform._(6, _omitEnumNames ? '' : 'LINK_PLATFORM_GENERIC');

  static const $core.List<LinkPlatform> values = <LinkPlatform>[
    LINK_PLATFORM_UNSPECIFIED,
    LINK_PLATFORM_SHOPEE,
    LINK_PLATFORM_LAZADA,
    LINK_PLATFORM_TIKTOK_SHOP,
    LINK_PLATFORM_AMAZON,
    LINK_PLATFORM_SHOPIFY,
    LINK_PLATFORM_GENERIC,
  ];

  static final $core.List<LinkPlatform?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static LinkPlatform? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LinkPlatform._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

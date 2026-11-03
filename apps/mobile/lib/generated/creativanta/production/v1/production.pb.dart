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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import '../../common/v1/types.pb.dart' as $2;
import 'production.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'production.pbenum.dart';

/// ProductionModeInfo describes an available production mode for launcher screens.
class ProductionModeInfo extends $pb.GeneratedMessage {
  factory ProductionModeInfo({
    ProductionMode? mode,
    $core.String? title,
    $core.String? description,
    $core.String? icon,
    $core.String? creditCostRange,
    $core.bool? isAvailable,
    $core.Iterable<$core.String>? supportedAspectRatios,
  }) {
    final result = ProductionModeInfo._();
    if (mode != null) result.mode = mode;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (icon != null) result.icon = icon;
    if (creditCostRange != null) result.creditCostRange = creditCostRange;
    if (isAvailable != null) result.isAvailable = isAvailable;
    if (supportedAspectRatios != null)
      result.supportedAspectRatios.addAll(supportedAspectRatios);
    return result;
  }

  ProductionModeInfo._();

  factory ProductionModeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProductionModeInfo()..mergeFromBuffer(data, registry);
  factory ProductionModeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProductionModeInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProductionModeInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: ProductionModeInfo.$_createMessage)
    ..aE<ProductionMode>(1, _omitFieldNames ? '' : 'mode',
        enumValues: ProductionMode.values)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'icon')
    ..aOS(5, _omitFieldNames ? '' : 'creditCostRange')
    ..aOB(6, _omitFieldNames ? '' : 'isAvailable')
    ..pPS(7, _omitFieldNames ? '' : 'supportedAspectRatios')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductionModeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductionModeInfo copyWith(void Function(ProductionModeInfo) updates) =>
      super.copyWith((message) => updates(message as ProductionModeInfo))
          as ProductionModeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProductionModeInfo() / ProductionModeInfo.new instead')
  static ProductionModeInfo create() => ProductionModeInfo._();
  static $pb.GeneratedMessage $_createMessage() => ProductionModeInfo._();
  @$core.override
  ProductionModeInfo createEmptyInstance() => ProductionModeInfo._();
  @$core.pragma('dart2js:noInline')
  static ProductionModeInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProductionModeInfo>(
          ProductionModeInfo.$_createMessage);
  static ProductionModeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  ProductionMode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode(ProductionMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get icon => $_getSZ(3);
  @$pb.TagNumber(4)
  set icon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creditCostRange => $_getSZ(4);
  @$pb.TagNumber(5)
  set creditCostRange($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreditCostRange() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreditCostRange() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isAvailable => $_getBF(5);
  @$pb.TagNumber(6)
  set isAvailable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsAvailable() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsAvailable() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get supportedAspectRatios => $_getList(6);
}

/// LineageItem records provenance per RULE-M07-001.
class LineageItem extends $pb.GeneratedMessage {
  factory LineageItem({
    $core.String? sourceProvider,
    $core.String? sourceModel,
    $core.String? generationPrompt,
    $core.Iterable<$core.String>? continuityPackIds,
    $core.String? generationCostCredits,
    $core.String? generationCostUsd,
    $core.String? parentAssetId,
    $1.Timestamp? recordedAt,
  }) {
    final result = LineageItem._();
    if (sourceProvider != null) result.sourceProvider = sourceProvider;
    if (sourceModel != null) result.sourceModel = sourceModel;
    if (generationPrompt != null) result.generationPrompt = generationPrompt;
    if (continuityPackIds != null)
      result.continuityPackIds.addAll(continuityPackIds);
    if (generationCostCredits != null)
      result.generationCostCredits = generationCostCredits;
    if (generationCostUsd != null) result.generationCostUsd = generationCostUsd;
    if (parentAssetId != null) result.parentAssetId = parentAssetId;
    if (recordedAt != null) result.recordedAt = recordedAt;
    return result;
  }

  LineageItem._();

  factory LineageItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LineageItem()..mergeFromBuffer(data, registry);
  factory LineageItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LineageItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LineageItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: LineageItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sourceProvider')
    ..aOS(2, _omitFieldNames ? '' : 'sourceModel')
    ..aOS(3, _omitFieldNames ? '' : 'generationPrompt')
    ..pPS(4, _omitFieldNames ? '' : 'continuityPackIds')
    ..aOS(5, _omitFieldNames ? '' : 'generationCostCredits')
    ..aOS(6, _omitFieldNames ? '' : 'generationCostUsd')
    ..aOS(7, _omitFieldNames ? '' : 'parentAssetId')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LineageItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LineageItem copyWith(void Function(LineageItem) updates) =>
      super.copyWith((message) => updates(message as LineageItem))
          as LineageItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LineageItem() / LineageItem.new instead')
  static LineageItem create() => LineageItem._();
  static $pb.GeneratedMessage $_createMessage() => LineageItem._();
  @$core.override
  LineageItem createEmptyInstance() => LineageItem._();
  @$core.pragma('dart2js:noInline')
  static LineageItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LineageItem>(
          LineageItem.$_createMessage);
  static LineageItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sourceProvider => $_getSZ(0);
  @$pb.TagNumber(1)
  set sourceProvider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceProvider() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceModel => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceModel($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceModel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get generationPrompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set generationPrompt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGenerationPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearGenerationPrompt() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get continuityPackIds => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get generationCostCredits => $_getSZ(4);
  @$pb.TagNumber(5)
  set generationCostCredits($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGenerationCostCredits() => $_has(4);
  @$pb.TagNumber(5)
  void clearGenerationCostCredits() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get generationCostUsd => $_getSZ(5);
  @$pb.TagNumber(6)
  set generationCostUsd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGenerationCostUsd() => $_has(5);
  @$pb.TagNumber(6)
  void clearGenerationCostUsd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get parentAssetId => $_getSZ(6);
  @$pb.TagNumber(7)
  set parentAssetId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasParentAssetId() => $_has(6);
  @$pb.TagNumber(7)
  void clearParentAssetId() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get recordedAt => $_getN(7);
  @$pb.TagNumber(8)
  set recordedAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRecordedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecordedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureRecordedAt() => $_ensure(7);
}

/// PostProductionConfig configures FFmpeg processing and normalization per RULE-M07-005.
class PostProductionConfig extends $pb.GeneratedMessage {
  factory PostProductionConfig({
    $core.bool? normalizeAudio,
    $core.double? targetLufs,
    $core.String? aspectRatio,
    $core.bool? subtitleOverlay,
    $core.String? subtitleStyle,
    $core.bool? activeSpeakerReframe,
  }) {
    final result = PostProductionConfig._();
    if (normalizeAudio != null) result.normalizeAudio = normalizeAudio;
    if (targetLufs != null) result.targetLufs = targetLufs;
    if (aspectRatio != null) result.aspectRatio = aspectRatio;
    if (subtitleOverlay != null) result.subtitleOverlay = subtitleOverlay;
    if (subtitleStyle != null) result.subtitleStyle = subtitleStyle;
    if (activeSpeakerReframe != null)
      result.activeSpeakerReframe = activeSpeakerReframe;
    return result;
  }

  PostProductionConfig._();

  factory PostProductionConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PostProductionConfig()..mergeFromBuffer(data, registry);
  factory PostProductionConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PostProductionConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostProductionConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: PostProductionConfig.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'normalizeAudio')
    ..aD(2, _omitFieldNames ? '' : 'targetLufs')
    ..aOS(3, _omitFieldNames ? '' : 'aspectRatio')
    ..aOB(4, _omitFieldNames ? '' : 'subtitleOverlay')
    ..aOS(5, _omitFieldNames ? '' : 'subtitleStyle')
    ..aOB(6, _omitFieldNames ? '' : 'activeSpeakerReframe')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostProductionConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostProductionConfig copyWith(void Function(PostProductionConfig) updates) =>
      super.copyWith((message) => updates(message as PostProductionConfig))
          as PostProductionConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PostProductionConfig() / PostProductionConfig.new instead')
  static PostProductionConfig create() => PostProductionConfig._();
  static $pb.GeneratedMessage $_createMessage() => PostProductionConfig._();
  @$core.override
  PostProductionConfig createEmptyInstance() => PostProductionConfig._();
  @$core.pragma('dart2js:noInline')
  static PostProductionConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostProductionConfig>(
          PostProductionConfig.$_createMessage);
  static PostProductionConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get normalizeAudio => $_getBF(0);
  @$pb.TagNumber(1)
  set normalizeAudio($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNormalizeAudio() => $_has(0);
  @$pb.TagNumber(1)
  void clearNormalizeAudio() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get targetLufs => $_getN(1);
  @$pb.TagNumber(2)
  set targetLufs($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetLufs() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetLufs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get aspectRatio => $_getSZ(2);
  @$pb.TagNumber(3)
  set aspectRatio($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAspectRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearAspectRatio() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get subtitleOverlay => $_getBF(3);
  @$pb.TagNumber(4)
  set subtitleOverlay($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitleOverlay() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitleOverlay() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get subtitleStyle => $_getSZ(4);
  @$pb.TagNumber(5)
  set subtitleStyle($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubtitleStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubtitleStyle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get activeSpeakerReframe => $_getBF(5);
  @$pb.TagNumber(6)
  set activeSpeakerReframe($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActiveSpeakerReframe() => $_has(5);
  @$pb.TagNumber(6)
  void clearActiveSpeakerReframe() => $_clearField(6);
}

/// GenerationJob represents a durable generation job per database_schema.md §7.4.
class GenerationJob extends $pb.GeneratedMessage {
  factory GenerationJob({
    $core.String? jobId,
    $core.String? workspaceId,
    $core.String? assetId,
    $core.String? jobType,
    $core.String? provider,
    $core.String? model,
    PipelineStrategy? pipelineStrategy,
    $core.String? inputParamsJson,
    $core.String? promptPackageJson,
    GenerationJobStatus? status,
    $core.int? progressPct,
    $core.String? currentStep,
    $core.String? estimatedCredits,
    $core.String? actualCredits,
    $core.String? actualCostUsd,
    $core.String? providerJobId,
    $core.String? resultUrl,
    $core.String? resultMetadataJson,
    $core.String? errorCode,
    $core.String? errorMessage,
    $core.int? retryCount,
    $core.int? maxRetries,
    $1.Timestamp? startedAt,
    $1.Timestamp? completedAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? quoteId,
    $core.String? reservationId,
  }) {
    final result = GenerationJob._();
    if (jobId != null) result.jobId = jobId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assetId != null) result.assetId = assetId;
    if (jobType != null) result.jobType = jobType;
    if (provider != null) result.provider = provider;
    if (model != null) result.model = model;
    if (pipelineStrategy != null) result.pipelineStrategy = pipelineStrategy;
    if (inputParamsJson != null) result.inputParamsJson = inputParamsJson;
    if (promptPackageJson != null) result.promptPackageJson = promptPackageJson;
    if (status != null) result.status = status;
    if (progressPct != null) result.progressPct = progressPct;
    if (currentStep != null) result.currentStep = currentStep;
    if (estimatedCredits != null) result.estimatedCredits = estimatedCredits;
    if (actualCredits != null) result.actualCredits = actualCredits;
    if (actualCostUsd != null) result.actualCostUsd = actualCostUsd;
    if (providerJobId != null) result.providerJobId = providerJobId;
    if (resultUrl != null) result.resultUrl = resultUrl;
    if (resultMetadataJson != null)
      result.resultMetadataJson = resultMetadataJson;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (retryCount != null) result.retryCount = retryCount;
    if (maxRetries != null) result.maxRetries = maxRetries;
    if (startedAt != null) result.startedAt = startedAt;
    if (completedAt != null) result.completedAt = completedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (quoteId != null) result.quoteId = quoteId;
    if (reservationId != null) result.reservationId = reservationId;
    return result;
  }

  GenerationJob._();

  factory GenerationJob.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerationJob()..mergeFromBuffer(data, registry);
  factory GenerationJob.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerationJob()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerationJob',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GenerationJob.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'jobType')
    ..aOS(5, _omitFieldNames ? '' : 'provider')
    ..aOS(6, _omitFieldNames ? '' : 'model')
    ..aE<PipelineStrategy>(7, _omitFieldNames ? '' : 'pipelineStrategy',
        enumValues: PipelineStrategy.values)
    ..aOS(8, _omitFieldNames ? '' : 'inputParamsJson')
    ..aOS(9, _omitFieldNames ? '' : 'promptPackageJson')
    ..aE<GenerationJobStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: GenerationJobStatus.values)
    ..aI(11, _omitFieldNames ? '' : 'progressPct')
    ..aOS(12, _omitFieldNames ? '' : 'currentStep')
    ..aOS(13, _omitFieldNames ? '' : 'estimatedCredits')
    ..aOS(14, _omitFieldNames ? '' : 'actualCredits')
    ..aOS(15, _omitFieldNames ? '' : 'actualCostUsd')
    ..aOS(16, _omitFieldNames ? '' : 'providerJobId')
    ..aOS(17, _omitFieldNames ? '' : 'resultUrl')
    ..aOS(18, _omitFieldNames ? '' : 'resultMetadataJson')
    ..aOS(19, _omitFieldNames ? '' : 'errorCode')
    ..aOS(20, _omitFieldNames ? '' : 'errorMessage')
    ..aI(21, _omitFieldNames ? '' : 'retryCount')
    ..aI(22, _omitFieldNames ? '' : 'maxRetries')
    ..aOM<$1.Timestamp>(23, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(24, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(25, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(26, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(27, _omitFieldNames ? '' : 'quoteId')
    ..aOS(28, _omitFieldNames ? '' : 'reservationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerationJob clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerationJob copyWith(void Function(GenerationJob) updates) =>
      super.copyWith((message) => updates(message as GenerationJob))
          as GenerationJob;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GenerationJob() / GenerationJob.new instead')
  static GenerationJob create() => GenerationJob._();
  static $pb.GeneratedMessage $_createMessage() => GenerationJob._();
  @$core.override
  GenerationJob createEmptyInstance() => GenerationJob._();
  @$core.pragma('dart2js:noInline')
  static GenerationJob getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerationJob>(
          GenerationJob.$_createMessage);
  static GenerationJob? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get jobType => $_getSZ(3);
  @$pb.TagNumber(4)
  set jobType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJobType() => $_has(3);
  @$pb.TagNumber(4)
  void clearJobType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get provider => $_getSZ(4);
  @$pb.TagNumber(5)
  set provider($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProvider() => $_has(4);
  @$pb.TagNumber(5)
  void clearProvider() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get model => $_getSZ(5);
  @$pb.TagNumber(6)
  set model($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasModel() => $_has(5);
  @$pb.TagNumber(6)
  void clearModel() => $_clearField(6);

  @$pb.TagNumber(7)
  PipelineStrategy get pipelineStrategy => $_getN(6);
  @$pb.TagNumber(7)
  set pipelineStrategy(PipelineStrategy value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPipelineStrategy() => $_has(6);
  @$pb.TagNumber(7)
  void clearPipelineStrategy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get inputParamsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set inputParamsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasInputParamsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearInputParamsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get promptPackageJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set promptPackageJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPromptPackageJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearPromptPackageJson() => $_clearField(9);

  @$pb.TagNumber(10)
  GenerationJobStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(GenerationJobStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get progressPct => $_getIZ(10);
  @$pb.TagNumber(11)
  set progressPct($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasProgressPct() => $_has(10);
  @$pb.TagNumber(11)
  void clearProgressPct() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get currentStep => $_getSZ(11);
  @$pb.TagNumber(12)
  set currentStep($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCurrentStep() => $_has(11);
  @$pb.TagNumber(12)
  void clearCurrentStep() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get estimatedCredits => $_getSZ(12);
  @$pb.TagNumber(13)
  set estimatedCredits($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasEstimatedCredits() => $_has(12);
  @$pb.TagNumber(13)
  void clearEstimatedCredits() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get actualCredits => $_getSZ(13);
  @$pb.TagNumber(14)
  set actualCredits($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasActualCredits() => $_has(13);
  @$pb.TagNumber(14)
  void clearActualCredits() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get actualCostUsd => $_getSZ(14);
  @$pb.TagNumber(15)
  set actualCostUsd($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasActualCostUsd() => $_has(14);
  @$pb.TagNumber(15)
  void clearActualCostUsd() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get providerJobId => $_getSZ(15);
  @$pb.TagNumber(16)
  set providerJobId($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasProviderJobId() => $_has(15);
  @$pb.TagNumber(16)
  void clearProviderJobId() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get resultUrl => $_getSZ(16);
  @$pb.TagNumber(17)
  set resultUrl($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasResultUrl() => $_has(16);
  @$pb.TagNumber(17)
  void clearResultUrl() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get resultMetadataJson => $_getSZ(17);
  @$pb.TagNumber(18)
  set resultMetadataJson($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasResultMetadataJson() => $_has(17);
  @$pb.TagNumber(18)
  void clearResultMetadataJson() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get errorCode => $_getSZ(18);
  @$pb.TagNumber(19)
  set errorCode($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasErrorCode() => $_has(18);
  @$pb.TagNumber(19)
  void clearErrorCode() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get errorMessage => $_getSZ(19);
  @$pb.TagNumber(20)
  set errorMessage($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasErrorMessage() => $_has(19);
  @$pb.TagNumber(20)
  void clearErrorMessage() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.int get retryCount => $_getIZ(20);
  @$pb.TagNumber(21)
  set retryCount($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasRetryCount() => $_has(20);
  @$pb.TagNumber(21)
  void clearRetryCount() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.int get maxRetries => $_getIZ(21);
  @$pb.TagNumber(22)
  set maxRetries($core.int value) => $_setSignedInt32(21, value);
  @$pb.TagNumber(22)
  $core.bool hasMaxRetries() => $_has(21);
  @$pb.TagNumber(22)
  void clearMaxRetries() => $_clearField(22);

  @$pb.TagNumber(23)
  $1.Timestamp get startedAt => $_getN(22);
  @$pb.TagNumber(23)
  set startedAt($1.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasStartedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearStartedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $1.Timestamp ensureStartedAt() => $_ensure(22);

  @$pb.TagNumber(24)
  $1.Timestamp get completedAt => $_getN(23);
  @$pb.TagNumber(24)
  set completedAt($1.Timestamp value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasCompletedAt() => $_has(23);
  @$pb.TagNumber(24)
  void clearCompletedAt() => $_clearField(24);
  @$pb.TagNumber(24)
  $1.Timestamp ensureCompletedAt() => $_ensure(23);

  @$pb.TagNumber(25)
  $1.Timestamp get createdAt => $_getN(24);
  @$pb.TagNumber(25)
  set createdAt($1.Timestamp value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasCreatedAt() => $_has(24);
  @$pb.TagNumber(25)
  void clearCreatedAt() => $_clearField(25);
  @$pb.TagNumber(25)
  $1.Timestamp ensureCreatedAt() => $_ensure(24);

  @$pb.TagNumber(26)
  $1.Timestamp get updatedAt => $_getN(25);
  @$pb.TagNumber(26)
  set updatedAt($1.Timestamp value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasUpdatedAt() => $_has(25);
  @$pb.TagNumber(26)
  void clearUpdatedAt() => $_clearField(26);
  @$pb.TagNumber(26)
  $1.Timestamp ensureUpdatedAt() => $_ensure(25);

  @$pb.TagNumber(27)
  $core.String get quoteId => $_getSZ(26);
  @$pb.TagNumber(27)
  set quoteId($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasQuoteId() => $_has(26);
  @$pb.TagNumber(27)
  void clearQuoteId() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.String get reservationId => $_getSZ(27);
  @$pb.TagNumber(28)
  set reservationId($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasReservationId() => $_has(27);
  @$pb.TagNumber(28)
  void clearReservationId() => $_clearField(28);
}

/// Asset represents a canonical creative asset per database_schema.md §7.3.
class Asset extends $pb.GeneratedMessage {
  factory Asset({
    $core.String? assetId,
    $core.String? workspaceId,
    $core.String? assetType,
    $core.String? title,
    $core.String? scriptId,
    $core.String? assetBriefId,
    $core.String? sourceGenerationMode,
    $core.String? sourceProvider,
    $core.String? sourceModel,
    $core.String? fileUrl,
    $fixnum.Int64? fileSizeBytes,
    $core.String? durationSeconds,
    $core.String? resolution,
    $core.String? aspectRatio,
    $core.String? mimeType,
    AssetGenerationState? generationState,
    AssetQualityState? qualityState,
    $core.Iterable<LineageItem>? lineage,
    $core.Iterable<$core.String>? continuityPackIds,
    $core.String? generationCostCredits,
    $core.String? generationCostUsd,
    $core.String? generationPrompt,
    $core.String? parentAssetId,
    $core.String? derivativeType,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.double? driftScore,
    $core.String? driftSeverity,
    $core.String? driftDetailsJson,
  }) {
    final result = Asset._();
    if (assetId != null) result.assetId = assetId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assetType != null) result.assetType = assetType;
    if (title != null) result.title = title;
    if (scriptId != null) result.scriptId = scriptId;
    if (assetBriefId != null) result.assetBriefId = assetBriefId;
    if (sourceGenerationMode != null)
      result.sourceGenerationMode = sourceGenerationMode;
    if (sourceProvider != null) result.sourceProvider = sourceProvider;
    if (sourceModel != null) result.sourceModel = sourceModel;
    if (fileUrl != null) result.fileUrl = fileUrl;
    if (fileSizeBytes != null) result.fileSizeBytes = fileSizeBytes;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (resolution != null) result.resolution = resolution;
    if (aspectRatio != null) result.aspectRatio = aspectRatio;
    if (mimeType != null) result.mimeType = mimeType;
    if (generationState != null) result.generationState = generationState;
    if (qualityState != null) result.qualityState = qualityState;
    if (lineage != null) result.lineage.addAll(lineage);
    if (continuityPackIds != null)
      result.continuityPackIds.addAll(continuityPackIds);
    if (generationCostCredits != null)
      result.generationCostCredits = generationCostCredits;
    if (generationCostUsd != null) result.generationCostUsd = generationCostUsd;
    if (generationPrompt != null) result.generationPrompt = generationPrompt;
    if (parentAssetId != null) result.parentAssetId = parentAssetId;
    if (derivativeType != null) result.derivativeType = derivativeType;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (driftScore != null) result.driftScore = driftScore;
    if (driftSeverity != null) result.driftSeverity = driftSeverity;
    if (driftDetailsJson != null) result.driftDetailsJson = driftDetailsJson;
    return result;
  }

  Asset._();

  factory Asset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Asset()..mergeFromBuffer(data, registry);
  factory Asset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Asset()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: Asset.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'assetType')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'scriptId')
    ..aOS(6, _omitFieldNames ? '' : 'assetBriefId')
    ..aOS(7, _omitFieldNames ? '' : 'sourceGenerationMode')
    ..aOS(8, _omitFieldNames ? '' : 'sourceProvider')
    ..aOS(9, _omitFieldNames ? '' : 'sourceModel')
    ..aOS(10, _omitFieldNames ? '' : 'fileUrl')
    ..aInt64(11, _omitFieldNames ? '' : 'fileSizeBytes')
    ..aOS(12, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(13, _omitFieldNames ? '' : 'resolution')
    ..aOS(14, _omitFieldNames ? '' : 'aspectRatio')
    ..aOS(15, _omitFieldNames ? '' : 'mimeType')
    ..aE<AssetGenerationState>(16, _omitFieldNames ? '' : 'generationState',
        enumValues: AssetGenerationState.values)
    ..aE<AssetQualityState>(17, _omitFieldNames ? '' : 'qualityState',
        enumValues: AssetQualityState.values)
    ..pPM<LineageItem>(18, _omitFieldNames ? '' : 'lineage',
        subBuilder: LineageItem.$_createMessage)
    ..pPS(19, _omitFieldNames ? '' : 'continuityPackIds')
    ..aOS(20, _omitFieldNames ? '' : 'generationCostCredits')
    ..aOS(21, _omitFieldNames ? '' : 'generationCostUsd')
    ..aOS(22, _omitFieldNames ? '' : 'generationPrompt')
    ..aOS(23, _omitFieldNames ? '' : 'parentAssetId')
    ..aOS(24, _omitFieldNames ? '' : 'derivativeType')
    ..aOM<$1.Timestamp>(25, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(26, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aD(27, _omitFieldNames ? '' : 'driftScore', fieldType: $pb.PbFieldType.OF)
    ..aOS(28, _omitFieldNames ? '' : 'driftSeverity')
    ..aOS(29, _omitFieldNames ? '' : 'driftDetailsJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset copyWith(void Function(Asset) updates) =>
      super.copyWith((message) => updates(message as Asset)) as Asset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Asset() / Asset.new instead')
  static Asset create() => Asset._();
  static $pb.GeneratedMessage $_createMessage() => Asset._();
  @$core.override
  Asset createEmptyInstance() => Asset._();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Asset>(Asset.$_createMessage);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetType => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetType() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get scriptId => $_getSZ(4);
  @$pb.TagNumber(5)
  set scriptId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScriptId() => $_has(4);
  @$pb.TagNumber(5)
  void clearScriptId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get assetBriefId => $_getSZ(5);
  @$pb.TagNumber(6)
  set assetBriefId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAssetBriefId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssetBriefId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sourceGenerationMode => $_getSZ(6);
  @$pb.TagNumber(7)
  set sourceGenerationMode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSourceGenerationMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceGenerationMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get sourceProvider => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceProvider($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceProvider() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceProvider() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get sourceModel => $_getSZ(8);
  @$pb.TagNumber(9)
  set sourceModel($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSourceModel() => $_has(8);
  @$pb.TagNumber(9)
  void clearSourceModel() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get fileUrl => $_getSZ(9);
  @$pb.TagNumber(10)
  set fileUrl($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFileUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearFileUrl() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get fileSizeBytes => $_getI64(10);
  @$pb.TagNumber(11)
  set fileSizeBytes($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasFileSizeBytes() => $_has(10);
  @$pb.TagNumber(11)
  void clearFileSizeBytes() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get durationSeconds => $_getSZ(11);
  @$pb.TagNumber(12)
  set durationSeconds($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDurationSeconds() => $_has(11);
  @$pb.TagNumber(12)
  void clearDurationSeconds() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get resolution => $_getSZ(12);
  @$pb.TagNumber(13)
  set resolution($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasResolution() => $_has(12);
  @$pb.TagNumber(13)
  void clearResolution() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get aspectRatio => $_getSZ(13);
  @$pb.TagNumber(14)
  set aspectRatio($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAspectRatio() => $_has(13);
  @$pb.TagNumber(14)
  void clearAspectRatio() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get mimeType => $_getSZ(14);
  @$pb.TagNumber(15)
  set mimeType($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasMimeType() => $_has(14);
  @$pb.TagNumber(15)
  void clearMimeType() => $_clearField(15);

  @$pb.TagNumber(16)
  AssetGenerationState get generationState => $_getN(15);
  @$pb.TagNumber(16)
  set generationState(AssetGenerationState value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGenerationState() => $_has(15);
  @$pb.TagNumber(16)
  void clearGenerationState() => $_clearField(16);

  @$pb.TagNumber(17)
  AssetQualityState get qualityState => $_getN(16);
  @$pb.TagNumber(17)
  set qualityState(AssetQualityState value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasQualityState() => $_has(16);
  @$pb.TagNumber(17)
  void clearQualityState() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<LineageItem> get lineage => $_getList(17);

  @$pb.TagNumber(19)
  $pb.PbList<$core.String> get continuityPackIds => $_getList(18);

  @$pb.TagNumber(20)
  $core.String get generationCostCredits => $_getSZ(19);
  @$pb.TagNumber(20)
  set generationCostCredits($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasGenerationCostCredits() => $_has(19);
  @$pb.TagNumber(20)
  void clearGenerationCostCredits() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get generationCostUsd => $_getSZ(20);
  @$pb.TagNumber(21)
  set generationCostUsd($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasGenerationCostUsd() => $_has(20);
  @$pb.TagNumber(21)
  void clearGenerationCostUsd() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get generationPrompt => $_getSZ(21);
  @$pb.TagNumber(22)
  set generationPrompt($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasGenerationPrompt() => $_has(21);
  @$pb.TagNumber(22)
  void clearGenerationPrompt() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get parentAssetId => $_getSZ(22);
  @$pb.TagNumber(23)
  set parentAssetId($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasParentAssetId() => $_has(22);
  @$pb.TagNumber(23)
  void clearParentAssetId() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get derivativeType => $_getSZ(23);
  @$pb.TagNumber(24)
  set derivativeType($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasDerivativeType() => $_has(23);
  @$pb.TagNumber(24)
  void clearDerivativeType() => $_clearField(24);

  @$pb.TagNumber(25)
  $1.Timestamp get createdAt => $_getN(24);
  @$pb.TagNumber(25)
  set createdAt($1.Timestamp value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasCreatedAt() => $_has(24);
  @$pb.TagNumber(25)
  void clearCreatedAt() => $_clearField(25);
  @$pb.TagNumber(25)
  $1.Timestamp ensureCreatedAt() => $_ensure(24);

  @$pb.TagNumber(26)
  $1.Timestamp get updatedAt => $_getN(25);
  @$pb.TagNumber(26)
  set updatedAt($1.Timestamp value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasUpdatedAt() => $_has(25);
  @$pb.TagNumber(26)
  void clearUpdatedAt() => $_clearField(26);
  @$pb.TagNumber(26)
  $1.Timestamp ensureUpdatedAt() => $_ensure(25);

  @$pb.TagNumber(27)
  $core.double get driftScore => $_getN(26);
  @$pb.TagNumber(27)
  set driftScore($core.double value) => $_setFloat(26, value);
  @$pb.TagNumber(27)
  $core.bool hasDriftScore() => $_has(26);
  @$pb.TagNumber(27)
  void clearDriftScore() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.String get driftSeverity => $_getSZ(27);
  @$pb.TagNumber(28)
  set driftSeverity($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasDriftSeverity() => $_has(27);
  @$pb.TagNumber(28)
  void clearDriftSeverity() => $_clearField(28);

  @$pb.TagNumber(29)
  $core.String get driftDetailsJson => $_getSZ(28);
  @$pb.TagNumber(29)
  set driftDetailsJson($core.String value) => $_setString(28, value);
  @$pb.TagNumber(29)
  $core.bool hasDriftDetailsJson() => $_has(28);
  @$pb.TagNumber(29)
  void clearDriftDetailsJson() => $_clearField(29);
}

/// BatchInputValidationItem evaluates single row in a batch (RULE-M07-006 & Section 28).
class BatchInputValidationItem extends $pb.GeneratedMessage {
  factory BatchInputValidationItem({
    $core.int? rowIndex,
    $core.String? itemId,
    $core.String? itemName,
    $core.bool? isValid,
    $core.String? validationError,
    $core.String? estimatedCredits,
    $core.String? estimatedCostUsd,
  }) {
    final result = BatchInputValidationItem._();
    if (rowIndex != null) result.rowIndex = rowIndex;
    if (itemId != null) result.itemId = itemId;
    if (itemName != null) result.itemName = itemName;
    if (isValid != null) result.isValid = isValid;
    if (validationError != null) result.validationError = validationError;
    if (estimatedCredits != null) result.estimatedCredits = estimatedCredits;
    if (estimatedCostUsd != null) result.estimatedCostUsd = estimatedCostUsd;
    return result;
  }

  BatchInputValidationItem._();

  factory BatchInputValidationItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchInputValidationItem()..mergeFromBuffer(data, registry);
  factory BatchInputValidationItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchInputValidationItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchInputValidationItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: BatchInputValidationItem.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'rowIndex')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aOS(3, _omitFieldNames ? '' : 'itemName')
    ..aOB(4, _omitFieldNames ? '' : 'isValid')
    ..aOS(5, _omitFieldNames ? '' : 'validationError')
    ..aOS(6, _omitFieldNames ? '' : 'estimatedCredits')
    ..aOS(7, _omitFieldNames ? '' : 'estimatedCostUsd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchInputValidationItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchInputValidationItem copyWith(
          void Function(BatchInputValidationItem) updates) =>
      super.copyWith((message) => updates(message as BatchInputValidationItem))
          as BatchInputValidationItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BatchInputValidationItem() / BatchInputValidationItem.new instead')
  static BatchInputValidationItem create() => BatchInputValidationItem._();
  static $pb.GeneratedMessage $_createMessage() => BatchInputValidationItem._();
  @$core.override
  BatchInputValidationItem createEmptyInstance() =>
      BatchInputValidationItem._();
  @$core.pragma('dart2js:noInline')
  static BatchInputValidationItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchInputValidationItem>(
          BatchInputValidationItem.$_createMessage);
  static BatchInputValidationItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get rowIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set rowIndex($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRowIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearRowIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itemName => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemName() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isValid => $_getBF(3);
  @$pb.TagNumber(4)
  set isValid($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsValid() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsValid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get validationError => $_getSZ(4);
  @$pb.TagNumber(5)
  set validationError($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValidationError() => $_has(4);
  @$pb.TagNumber(5)
  void clearValidationError() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get estimatedCredits => $_getSZ(5);
  @$pb.TagNumber(6)
  set estimatedCredits($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEstimatedCredits() => $_has(5);
  @$pb.TagNumber(6)
  void clearEstimatedCredits() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get estimatedCostUsd => $_getSZ(6);
  @$pb.TagNumber(7)
  set estimatedCostUsd($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEstimatedCostUsd() => $_has(6);
  @$pb.TagNumber(7)
  void clearEstimatedCostUsd() => $_clearField(7);
}

/// BatchBudgetPreview holds preflight quote & partial batch validation results.
class BatchBudgetPreview extends $pb.GeneratedMessage {
  factory BatchBudgetPreview({
    $core.String? totalEstimatedCredits,
    $core.String? totalCostCeilingUsd,
    $core.int? totalItems,
    $core.int? validItemsCount,
    $core.int? invalidItemsCount,
    $core.Iterable<BatchInputValidationItem>? items,
    $core.bool? sufficientCredits,
    $core.String? currentAvailableCredits,
    $core.String? quoteId,
    $1.Timestamp? quoteExpiresAt,
  }) {
    final result = BatchBudgetPreview._();
    if (totalEstimatedCredits != null)
      result.totalEstimatedCredits = totalEstimatedCredits;
    if (totalCostCeilingUsd != null)
      result.totalCostCeilingUsd = totalCostCeilingUsd;
    if (totalItems != null) result.totalItems = totalItems;
    if (validItemsCount != null) result.validItemsCount = validItemsCount;
    if (invalidItemsCount != null) result.invalidItemsCount = invalidItemsCount;
    if (items != null) result.items.addAll(items);
    if (sufficientCredits != null) result.sufficientCredits = sufficientCredits;
    if (currentAvailableCredits != null)
      result.currentAvailableCredits = currentAvailableCredits;
    if (quoteId != null) result.quoteId = quoteId;
    if (quoteExpiresAt != null) result.quoteExpiresAt = quoteExpiresAt;
    return result;
  }

  BatchBudgetPreview._();

  factory BatchBudgetPreview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchBudgetPreview()..mergeFromBuffer(data, registry);
  factory BatchBudgetPreview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchBudgetPreview()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchBudgetPreview',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: BatchBudgetPreview.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'totalEstimatedCredits')
    ..aOS(2, _omitFieldNames ? '' : 'totalCostCeilingUsd')
    ..aI(3, _omitFieldNames ? '' : 'totalItems')
    ..aI(4, _omitFieldNames ? '' : 'validItemsCount')
    ..aI(5, _omitFieldNames ? '' : 'invalidItemsCount')
    ..pPM<BatchInputValidationItem>(6, _omitFieldNames ? '' : 'items',
        subBuilder: BatchInputValidationItem.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'sufficientCredits')
    ..aOS(8, _omitFieldNames ? '' : 'currentAvailableCredits')
    ..aOS(9, _omitFieldNames ? '' : 'quoteId')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'quoteExpiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBudgetPreview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBudgetPreview copyWith(void Function(BatchBudgetPreview) updates) =>
      super.copyWith((message) => updates(message as BatchBudgetPreview))
          as BatchBudgetPreview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BatchBudgetPreview() / BatchBudgetPreview.new instead')
  static BatchBudgetPreview create() => BatchBudgetPreview._();
  static $pb.GeneratedMessage $_createMessage() => BatchBudgetPreview._();
  @$core.override
  BatchBudgetPreview createEmptyInstance() => BatchBudgetPreview._();
  @$core.pragma('dart2js:noInline')
  static BatchBudgetPreview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchBudgetPreview>(
          BatchBudgetPreview.$_createMessage);
  static BatchBudgetPreview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get totalEstimatedCredits => $_getSZ(0);
  @$pb.TagNumber(1)
  set totalEstimatedCredits($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalEstimatedCredits() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalEstimatedCredits() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get totalCostCeilingUsd => $_getSZ(1);
  @$pb.TagNumber(2)
  set totalCostCeilingUsd($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCostCeilingUsd() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCostCeilingUsd() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalItems => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalItems($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalItems() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalItems() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get validItemsCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set validItemsCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasValidItemsCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearValidItemsCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get invalidItemsCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set invalidItemsCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInvalidItemsCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearInvalidItemsCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<BatchInputValidationItem> get items => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get sufficientCredits => $_getBF(6);
  @$pb.TagNumber(7)
  set sufficientCredits($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSufficientCredits() => $_has(6);
  @$pb.TagNumber(7)
  void clearSufficientCredits() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get currentAvailableCredits => $_getSZ(7);
  @$pb.TagNumber(8)
  set currentAvailableCredits($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrentAvailableCredits() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrentAvailableCredits() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get quoteId => $_getSZ(8);
  @$pb.TagNumber(9)
  set quoteId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasQuoteId() => $_has(8);
  @$pb.TagNumber(9)
  void clearQuoteId() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get quoteExpiresAt => $_getN(9);
  @$pb.TagNumber(10)
  set quoteExpiresAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasQuoteExpiresAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearQuoteExpiresAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureQuoteExpiresAt() => $_ensure(9);
}

class GetModesRequest extends $pb.GeneratedMessage {
  factory GetModesRequest({
    $2.UUID? workspaceId,
  }) {
    final result = GetModesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetModesRequest._();

  factory GetModesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetModesRequest()..mergeFromBuffer(data, registry);
  factory GetModesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetModesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetModesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetModesRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetModesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetModesRequest copyWith(void Function(GetModesRequest) updates) =>
      super.copyWith((message) => updates(message as GetModesRequest))
          as GetModesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetModesRequest() / GetModesRequest.new instead')
  static GetModesRequest create() => GetModesRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetModesRequest._();
  @$core.override
  GetModesRequest createEmptyInstance() => GetModesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetModesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetModesRequest>(
          GetModesRequest.$_createMessage);
  static GetModesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetModesResponse extends $pb.GeneratedMessage {
  factory GetModesResponse({
    $core.Iterable<ProductionModeInfo>? modes,
  }) {
    final result = GetModesResponse._();
    if (modes != null) result.modes.addAll(modes);
    return result;
  }

  GetModesResponse._();

  factory GetModesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetModesResponse()..mergeFromBuffer(data, registry);
  factory GetModesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetModesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetModesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetModesResponse.$_createMessage)
    ..pPM<ProductionModeInfo>(1, _omitFieldNames ? '' : 'modes',
        subBuilder: ProductionModeInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetModesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetModesResponse copyWith(void Function(GetModesResponse) updates) =>
      super.copyWith((message) => updates(message as GetModesResponse))
          as GetModesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetModesResponse() / GetModesResponse.new instead')
  static GetModesResponse create() => GetModesResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetModesResponse._();
  @$core.override
  GetModesResponse createEmptyInstance() => GetModesResponse._();
  @$core.pragma('dart2js:noInline')
  static GetModesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetModesResponse>(
          GetModesResponse.$_createMessage);
  static GetModesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProductionModeInfo> get modes => $_getList(0);
}

class GetActiveJobsRequest extends $pb.GeneratedMessage {
  factory GetActiveJobsRequest({
    $2.UUID? workspaceId,
    $2.Pagination? pagination,
  }) {
    final result = GetActiveJobsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetActiveJobsRequest._();

  factory GetActiveJobsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActiveJobsRequest()..mergeFromBuffer(data, registry);
  factory GetActiveJobsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActiveJobsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActiveJobsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetActiveJobsRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveJobsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveJobsRequest copyWith(void Function(GetActiveJobsRequest) updates) =>
      super.copyWith((message) => updates(message as GetActiveJobsRequest))
          as GetActiveJobsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetActiveJobsRequest() / GetActiveJobsRequest.new instead')
  static GetActiveJobsRequest create() => GetActiveJobsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetActiveJobsRequest._();
  @$core.override
  GetActiveJobsRequest createEmptyInstance() => GetActiveJobsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetActiveJobsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActiveJobsRequest>(
          GetActiveJobsRequest.$_createMessage);
  static GetActiveJobsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);
}

class GetActiveJobsResponse extends $pb.GeneratedMessage {
  factory GetActiveJobsResponse({
    $core.Iterable<GenerationJob>? jobs,
    $2.PaginatedResponse? pagination,
    $core.int? totalActiveCount,
  }) {
    final result = GetActiveJobsResponse._();
    if (jobs != null) result.jobs.addAll(jobs);
    if (pagination != null) result.pagination = pagination;
    if (totalActiveCount != null) result.totalActiveCount = totalActiveCount;
    return result;
  }

  GetActiveJobsResponse._();

  factory GetActiveJobsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActiveJobsResponse()..mergeFromBuffer(data, registry);
  factory GetActiveJobsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActiveJobsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActiveJobsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetActiveJobsResponse.$_createMessage)
    ..pPM<GenerationJob>(1, _omitFieldNames ? '' : 'jobs',
        subBuilder: GenerationJob.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'totalActiveCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveJobsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveJobsResponse copyWith(
          void Function(GetActiveJobsResponse) updates) =>
      super.copyWith((message) => updates(message as GetActiveJobsResponse))
          as GetActiveJobsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetActiveJobsResponse() / GetActiveJobsResponse.new instead')
  static GetActiveJobsResponse create() => GetActiveJobsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetActiveJobsResponse._();
  @$core.override
  GetActiveJobsResponse createEmptyInstance() => GetActiveJobsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetActiveJobsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActiveJobsResponse>(
          GetActiveJobsResponse.$_createMessage);
  static GetActiveJobsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GenerationJob> get jobs => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get totalActiveCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalActiveCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalActiveCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalActiveCount() => $_clearField(3);
}

class GetRecentAssetsRequest extends $pb.GeneratedMessage {
  factory GetRecentAssetsRequest({
    $2.UUID? workspaceId,
    $core.int? limit,
  }) {
    final result = GetRecentAssetsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetRecentAssetsRequest._();

  factory GetRecentAssetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRecentAssetsRequest()..mergeFromBuffer(data, registry);
  factory GetRecentAssetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRecentAssetsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecentAssetsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetRecentAssetsRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecentAssetsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecentAssetsRequest copyWith(
          void Function(GetRecentAssetsRequest) updates) =>
      super.copyWith((message) => updates(message as GetRecentAssetsRequest))
          as GetRecentAssetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetRecentAssetsRequest() / GetRecentAssetsRequest.new instead')
  static GetRecentAssetsRequest create() => GetRecentAssetsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetRecentAssetsRequest._();
  @$core.override
  GetRecentAssetsRequest createEmptyInstance() => GetRecentAssetsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRecentAssetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecentAssetsRequest>(
          GetRecentAssetsRequest.$_createMessage);
  static GetRecentAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class GetRecentAssetsResponse extends $pb.GeneratedMessage {
  factory GetRecentAssetsResponse({
    $core.Iterable<Asset>? assets,
  }) {
    final result = GetRecentAssetsResponse._();
    if (assets != null) result.assets.addAll(assets);
    return result;
  }

  GetRecentAssetsResponse._();

  factory GetRecentAssetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRecentAssetsResponse()..mergeFromBuffer(data, registry);
  factory GetRecentAssetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRecentAssetsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecentAssetsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetRecentAssetsResponse.$_createMessage)
    ..pPM<Asset>(1, _omitFieldNames ? '' : 'assets',
        subBuilder: Asset.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecentAssetsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecentAssetsResponse copyWith(
          void Function(GetRecentAssetsResponse) updates) =>
      super.copyWith((message) => updates(message as GetRecentAssetsResponse))
          as GetRecentAssetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetRecentAssetsResponse() / GetRecentAssetsResponse.new instead')
  static GetRecentAssetsResponse create() => GetRecentAssetsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetRecentAssetsResponse._();
  @$core.override
  GetRecentAssetsResponse createEmptyInstance() => GetRecentAssetsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetRecentAssetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecentAssetsResponse>(
          GetRecentAssetsResponse.$_createMessage);
  static GetRecentAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);
}

class CancelRequest extends $pb.GeneratedMessage {
  factory CancelRequest({
    $2.CommandContext? context,
    $core.String? jobId,
  }) {
    final result = CancelRequest._();
    if (context != null) result.context = context;
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  CancelRequest._();

  factory CancelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelRequest()..mergeFromBuffer(data, registry);
  factory CancelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: CancelRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRequest copyWith(void Function(CancelRequest) updates) =>
      super.copyWith((message) => updates(message as CancelRequest))
          as CancelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CancelRequest() / CancelRequest.new instead')
  static CancelRequest create() => CancelRequest._();
  static $pb.GeneratedMessage $_createMessage() => CancelRequest._();
  @$core.override
  CancelRequest createEmptyInstance() => CancelRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelRequest>(
          CancelRequest.$_createMessage);
  static CancelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);
}

class CancelResponse extends $pb.GeneratedMessage {
  factory CancelResponse({
    GenerationJob? job,
    $core.bool? creditsRefunded,
    $core.String? refundedCredits,
  }) {
    final result = CancelResponse._();
    if (job != null) result.job = job;
    if (creditsRefunded != null) result.creditsRefunded = creditsRefunded;
    if (refundedCredits != null) result.refundedCredits = refundedCredits;
    return result;
  }

  CancelResponse._();

  factory CancelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelResponse()..mergeFromBuffer(data, registry);
  factory CancelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: CancelResponse.$_createMessage)
    ..aOM<GenerationJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: GenerationJob.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'creditsRefunded')
    ..aOS(3, _omitFieldNames ? '' : 'refundedCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelResponse copyWith(void Function(CancelResponse) updates) =>
      super.copyWith((message) => updates(message as CancelResponse))
          as CancelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CancelResponse() / CancelResponse.new instead')
  static CancelResponse create() => CancelResponse._();
  static $pb.GeneratedMessage $_createMessage() => CancelResponse._();
  @$core.override
  CancelResponse createEmptyInstance() => CancelResponse._();
  @$core.pragma('dart2js:noInline')
  static CancelResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelResponse>(
          CancelResponse.$_createMessage);
  static CancelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  GenerationJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(GenerationJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  GenerationJob ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get creditsRefunded => $_getBF(1);
  @$pb.TagNumber(2)
  set creditsRefunded($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsRefunded() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsRefunded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get refundedCredits => $_getSZ(2);
  @$pb.TagNumber(3)
  set refundedCredits($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefundedCredits() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefundedCredits() => $_clearField(3);
}

class RetryRequest extends $pb.GeneratedMessage {
  factory RetryRequest({
    $2.CommandContext? context,
    $core.String? jobId,
    $core.bool? useFallbackProvider,
  }) {
    final result = RetryRequest._();
    if (context != null) result.context = context;
    if (jobId != null) result.jobId = jobId;
    if (useFallbackProvider != null)
      result.useFallbackProvider = useFallbackProvider;
    return result;
  }

  RetryRequest._();

  factory RetryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryRequest()..mergeFromBuffer(data, registry);
  factory RetryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RetryRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..aOB(3, _omitFieldNames ? '' : 'useFallbackProvider')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryRequest copyWith(void Function(RetryRequest) updates) =>
      super.copyWith((message) => updates(message as RetryRequest))
          as RetryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RetryRequest() / RetryRequest.new instead')
  static RetryRequest create() => RetryRequest._();
  static $pb.GeneratedMessage $_createMessage() => RetryRequest._();
  @$core.override
  RetryRequest createEmptyInstance() => RetryRequest._();
  @$core.pragma('dart2js:noInline')
  static RetryRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryRequest>(
          RetryRequest.$_createMessage);
  static RetryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get useFallbackProvider => $_getBF(2);
  @$pb.TagNumber(3)
  set useFallbackProvider($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUseFallbackProvider() => $_has(2);
  @$pb.TagNumber(3)
  void clearUseFallbackProvider() => $_clearField(3);
}

class RetryResponse extends $pb.GeneratedMessage {
  factory RetryResponse({
    GenerationJob? job,
    $core.String? message,
  }) {
    final result = RetryResponse._();
    if (job != null) result.job = job;
    if (message != null) result.message = message;
    return result;
  }

  RetryResponse._();

  factory RetryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryResponse()..mergeFromBuffer(data, registry);
  factory RetryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RetryResponse.$_createMessage)
    ..aOM<GenerationJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: GenerationJob.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryResponse copyWith(void Function(RetryResponse) updates) =>
      super.copyWith((message) => updates(message as RetryResponse))
          as RetryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RetryResponse() / RetryResponse.new instead')
  static RetryResponse create() => RetryResponse._();
  static $pb.GeneratedMessage $_createMessage() => RetryResponse._();
  @$core.override
  RetryResponse createEmptyInstance() => RetryResponse._();
  @$core.pragma('dart2js:noInline')
  static RetryResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryResponse>(
          RetryResponse.$_createMessage);
  static RetryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  GenerationJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(GenerationJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  GenerationJob ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class BatchGenerationItem extends $pb.GeneratedMessage {
  factory BatchGenerationItem({
    $core.String? itemId,
    $core.String? itemName,
    $core.String? prompt,
    $core.String? referenceUrl,
    $core.Iterable<$core.String>? imageUrls,
  }) {
    final result = BatchGenerationItem._();
    if (itemId != null) result.itemId = itemId;
    if (itemName != null) result.itemName = itemName;
    if (prompt != null) result.prompt = prompt;
    if (referenceUrl != null) result.referenceUrl = referenceUrl;
    if (imageUrls != null) result.imageUrls.addAll(imageUrls);
    return result;
  }

  BatchGenerationItem._();

  factory BatchGenerationItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchGenerationItem()..mergeFromBuffer(data, registry);
  factory BatchGenerationItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BatchGenerationItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchGenerationItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: BatchGenerationItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'itemName')
    ..aOS(3, _omitFieldNames ? '' : 'prompt')
    ..aOS(4, _omitFieldNames ? '' : 'referenceUrl')
    ..pPS(5, _omitFieldNames ? '' : 'imageUrls')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchGenerationItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchGenerationItem copyWith(void Function(BatchGenerationItem) updates) =>
      super.copyWith((message) => updates(message as BatchGenerationItem))
          as BatchGenerationItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use BatchGenerationItem() / BatchGenerationItem.new instead')
  static BatchGenerationItem create() => BatchGenerationItem._();
  static $pb.GeneratedMessage $_createMessage() => BatchGenerationItem._();
  @$core.override
  BatchGenerationItem createEmptyInstance() => BatchGenerationItem._();
  @$core.pragma('dart2js:noInline')
  static BatchGenerationItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchGenerationItem>(
          BatchGenerationItem.$_createMessage);
  static BatchGenerationItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemName => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemName() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get prompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set prompt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrompt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get referenceUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set referenceUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReferenceUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearReferenceUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get imageUrls => $_getList(4);
}

class GenerateRequest extends $pb.GeneratedMessage {
  factory GenerateRequest({
    $2.CommandContext? context,
    $core.String? title,
    ProductionMode? mode,
    $core.String? prompt,
    $core.String? scriptId,
    $core.String? assetBriefId,
    $core.Iterable<$core.String>? continuityPackIds,
    PipelineStrategy? pipelineStrategy,
    $core.String? preferredProvider,
    $core.String? preferredModel,
    PostProductionConfig? postProduction,
    $core.String? byokApiKey,
    $core.String? quoteId,
    $core.String? confirmedCredits,
    $core.bool? dryRun,
    $core.Iterable<BatchGenerationItem>? batchItems,
  }) {
    final result = GenerateRequest._();
    if (context != null) result.context = context;
    if (title != null) result.title = title;
    if (mode != null) result.mode = mode;
    if (prompt != null) result.prompt = prompt;
    if (scriptId != null) result.scriptId = scriptId;
    if (assetBriefId != null) result.assetBriefId = assetBriefId;
    if (continuityPackIds != null)
      result.continuityPackIds.addAll(continuityPackIds);
    if (pipelineStrategy != null) result.pipelineStrategy = pipelineStrategy;
    if (preferredProvider != null) result.preferredProvider = preferredProvider;
    if (preferredModel != null) result.preferredModel = preferredModel;
    if (postProduction != null) result.postProduction = postProduction;
    if (byokApiKey != null) result.byokApiKey = byokApiKey;
    if (quoteId != null) result.quoteId = quoteId;
    if (confirmedCredits != null) result.confirmedCredits = confirmedCredits;
    if (dryRun != null) result.dryRun = dryRun;
    if (batchItems != null) result.batchItems.addAll(batchItems);
    return result;
  }

  GenerateRequest._();

  factory GenerateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateRequest()..mergeFromBuffer(data, registry);
  factory GenerateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GenerateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aE<ProductionMode>(3, _omitFieldNames ? '' : 'mode',
        enumValues: ProductionMode.values)
    ..aOS(4, _omitFieldNames ? '' : 'prompt')
    ..aOS(5, _omitFieldNames ? '' : 'scriptId')
    ..aOS(6, _omitFieldNames ? '' : 'assetBriefId')
    ..pPS(7, _omitFieldNames ? '' : 'continuityPackIds')
    ..aE<PipelineStrategy>(8, _omitFieldNames ? '' : 'pipelineStrategy',
        enumValues: PipelineStrategy.values)
    ..aOS(9, _omitFieldNames ? '' : 'preferredProvider')
    ..aOS(10, _omitFieldNames ? '' : 'preferredModel')
    ..aOM<PostProductionConfig>(11, _omitFieldNames ? '' : 'postProduction',
        subBuilder: PostProductionConfig.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'byokApiKey')
    ..aOS(13, _omitFieldNames ? '' : 'quoteId')
    ..aOS(14, _omitFieldNames ? '' : 'confirmedCredits')
    ..aOB(15, _omitFieldNames ? '' : 'dryRun')
    ..pPM<BatchGenerationItem>(16, _omitFieldNames ? '' : 'batchItems',
        subBuilder: BatchGenerationItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateRequest copyWith(void Function(GenerateRequest) updates) =>
      super.copyWith((message) => updates(message as GenerateRequest))
          as GenerateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GenerateRequest() / GenerateRequest.new instead')
  static GenerateRequest create() => GenerateRequest._();
  static $pb.GeneratedMessage $_createMessage() => GenerateRequest._();
  @$core.override
  GenerateRequest createEmptyInstance() => GenerateRequest._();
  @$core.pragma('dart2js:noInline')
  static GenerateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateRequest>(
          GenerateRequest.$_createMessage);
  static GenerateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  ProductionMode get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode(ProductionMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get prompt => $_getSZ(3);
  @$pb.TagNumber(4)
  set prompt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrompt() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrompt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get scriptId => $_getSZ(4);
  @$pb.TagNumber(5)
  set scriptId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScriptId() => $_has(4);
  @$pb.TagNumber(5)
  void clearScriptId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get assetBriefId => $_getSZ(5);
  @$pb.TagNumber(6)
  set assetBriefId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAssetBriefId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssetBriefId() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get continuityPackIds => $_getList(6);

  @$pb.TagNumber(8)
  PipelineStrategy get pipelineStrategy => $_getN(7);
  @$pb.TagNumber(8)
  set pipelineStrategy(PipelineStrategy value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPipelineStrategy() => $_has(7);
  @$pb.TagNumber(8)
  void clearPipelineStrategy() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get preferredProvider => $_getSZ(8);
  @$pb.TagNumber(9)
  set preferredProvider($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPreferredProvider() => $_has(8);
  @$pb.TagNumber(9)
  void clearPreferredProvider() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get preferredModel => $_getSZ(9);
  @$pb.TagNumber(10)
  set preferredModel($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPreferredModel() => $_has(9);
  @$pb.TagNumber(10)
  void clearPreferredModel() => $_clearField(10);

  @$pb.TagNumber(11)
  PostProductionConfig get postProduction => $_getN(10);
  @$pb.TagNumber(11)
  set postProduction(PostProductionConfig value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPostProduction() => $_has(10);
  @$pb.TagNumber(11)
  void clearPostProduction() => $_clearField(11);
  @$pb.TagNumber(11)
  PostProductionConfig ensurePostProduction() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get byokApiKey => $_getSZ(11);
  @$pb.TagNumber(12)
  set byokApiKey($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasByokApiKey() => $_has(11);
  @$pb.TagNumber(12)
  void clearByokApiKey() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get quoteId => $_getSZ(12);
  @$pb.TagNumber(13)
  set quoteId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasQuoteId() => $_has(12);
  @$pb.TagNumber(13)
  void clearQuoteId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get confirmedCredits => $_getSZ(13);
  @$pb.TagNumber(14)
  set confirmedCredits($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasConfirmedCredits() => $_has(13);
  @$pb.TagNumber(14)
  void clearConfirmedCredits() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get dryRun => $_getBF(14);
  @$pb.TagNumber(15)
  set dryRun($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDryRun() => $_has(14);
  @$pb.TagNumber(15)
  void clearDryRun() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<BatchGenerationItem> get batchItems => $_getList(15);
}

class GenerateResponse extends $pb.GeneratedMessage {
  factory GenerateResponse({
    $core.bool? isDryRun,
    BatchBudgetPreview? budgetPreview,
    GenerationJob? job,
    Asset? asset,
    $core.Iterable<GenerationJob>? batchJobs,
    $core.Iterable<Asset>? batchAssets,
  }) {
    final result = GenerateResponse._();
    if (isDryRun != null) result.isDryRun = isDryRun;
    if (budgetPreview != null) result.budgetPreview = budgetPreview;
    if (job != null) result.job = job;
    if (asset != null) result.asset = asset;
    if (batchJobs != null) result.batchJobs.addAll(batchJobs);
    if (batchAssets != null) result.batchAssets.addAll(batchAssets);
    return result;
  }

  GenerateResponse._();

  factory GenerateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateResponse()..mergeFromBuffer(data, registry);
  factory GenerateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GenerateResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isDryRun')
    ..aOM<BatchBudgetPreview>(2, _omitFieldNames ? '' : 'budgetPreview',
        subBuilder: BatchBudgetPreview.$_createMessage)
    ..aOM<GenerationJob>(3, _omitFieldNames ? '' : 'job',
        subBuilder: GenerationJob.$_createMessage)
    ..aOM<Asset>(4, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..pPM<GenerationJob>(5, _omitFieldNames ? '' : 'batchJobs',
        subBuilder: GenerationJob.$_createMessage)
    ..pPM<Asset>(6, _omitFieldNames ? '' : 'batchAssets',
        subBuilder: Asset.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateResponse copyWith(void Function(GenerateResponse) updates) =>
      super.copyWith((message) => updates(message as GenerateResponse))
          as GenerateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GenerateResponse() / GenerateResponse.new instead')
  static GenerateResponse create() => GenerateResponse._();
  static $pb.GeneratedMessage $_createMessage() => GenerateResponse._();
  @$core.override
  GenerateResponse createEmptyInstance() => GenerateResponse._();
  @$core.pragma('dart2js:noInline')
  static GenerateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateResponse>(
          GenerateResponse.$_createMessage);
  static GenerateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isDryRun => $_getBF(0);
  @$pb.TagNumber(1)
  set isDryRun($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsDryRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsDryRun() => $_clearField(1);

  @$pb.TagNumber(2)
  BatchBudgetPreview get budgetPreview => $_getN(1);
  @$pb.TagNumber(2)
  set budgetPreview(BatchBudgetPreview value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBudgetPreview() => $_has(1);
  @$pb.TagNumber(2)
  void clearBudgetPreview() => $_clearField(2);
  @$pb.TagNumber(2)
  BatchBudgetPreview ensureBudgetPreview() => $_ensure(1);

  @$pb.TagNumber(3)
  GenerationJob get job => $_getN(2);
  @$pb.TagNumber(3)
  set job(GenerationJob value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasJob() => $_has(2);
  @$pb.TagNumber(3)
  void clearJob() => $_clearField(3);
  @$pb.TagNumber(3)
  GenerationJob ensureJob() => $_ensure(2);

  @$pb.TagNumber(4)
  Asset get asset => $_getN(3);
  @$pb.TagNumber(4)
  set asset(Asset value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAsset() => $_has(3);
  @$pb.TagNumber(4)
  void clearAsset() => $_clearField(4);
  @$pb.TagNumber(4)
  Asset ensureAsset() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<GenerationJob> get batchJobs => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<Asset> get batchAssets => $_getList(5);
}

class GetStatusRequest extends $pb.GeneratedMessage {
  factory GetStatusRequest({
    $2.UUID? workspaceId,
    $core.String? jobId,
  }) {
    final result = GetStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  GetStatusRequest._();

  factory GetStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusRequest()..mergeFromBuffer(data, registry);
  factory GetStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetStatusRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusRequest copyWith(void Function(GetStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetStatusRequest))
          as GetStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatusRequest() / GetStatusRequest.new instead')
  static GetStatusRequest create() => GetStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetStatusRequest._();
  @$core.override
  GetStatusRequest createEmptyInstance() => GetStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetStatusRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatusRequest>(
          GetStatusRequest.$_createMessage);
  static GetStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);
}

class GetStatusResponse extends $pb.GeneratedMessage {
  factory GetStatusResponse({
    GenerationJob? job,
    Asset? asset,
  }) {
    final result = GetStatusResponse._();
    if (job != null) result.job = job;
    if (asset != null) result.asset = asset;
    return result;
  }

  GetStatusResponse._();

  factory GetStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusResponse()..mergeFromBuffer(data, registry);
  factory GetStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetStatusResponse.$_createMessage)
    ..aOM<GenerationJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: GenerationJob.$_createMessage)
    ..aOM<Asset>(2, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatusResponse copyWith(void Function(GetStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetStatusResponse))
          as GetStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatusResponse() / GetStatusResponse.new instead')
  static GetStatusResponse create() => GetStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetStatusResponse._();
  @$core.override
  GetStatusResponse createEmptyInstance() => GetStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static GetStatusResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatusResponse>(
          GetStatusResponse.$_createMessage);
  static GetStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  GenerationJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(GenerationJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  GenerationJob ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  Asset get asset => $_getN(1);
  @$pb.TagNumber(2)
  set asset(Asset value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsset() => $_clearField(2);
  @$pb.TagNumber(2)
  Asset ensureAsset() => $_ensure(1);
}

class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $2.UUID? workspaceId,
    $core.String? assetType,
    $core.String? generationState,
    $core.String? qualityState,
    $2.Pagination? pagination,
  }) {
    final result = ListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assetType != null) result.assetType = assetType;
    if (generationState != null) result.generationState = generationState;
    if (qualityState != null) result.qualityState = qualityState;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListRequest._();

  factory ListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRequest()..mergeFromBuffer(data, registry);
  factory ListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: ListRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'assetType')
    ..aOS(3, _omitFieldNames ? '' : 'generationState')
    ..aOS(4, _omitFieldNames ? '' : 'qualityState')
    ..aOM<$2.Pagination>(5, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest copyWith(void Function(ListRequest) updates) =>
      super.copyWith((message) => updates(message as ListRequest))
          as ListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListRequest() / ListRequest.new instead')
  static ListRequest create() => ListRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListRequest._();
  @$core.override
  ListRequest createEmptyInstance() => ListRequest._();
  @$core.pragma('dart2js:noInline')
  static ListRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRequest>(
          ListRequest.$_createMessage);
  static ListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get assetType => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetType() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get generationState => $_getSZ(2);
  @$pb.TagNumber(3)
  set generationState($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGenerationState() => $_has(2);
  @$pb.TagNumber(3)
  void clearGenerationState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get qualityState => $_getSZ(3);
  @$pb.TagNumber(4)
  set qualityState($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQualityState() => $_has(3);
  @$pb.TagNumber(4)
  void clearQualityState() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Pagination get pagination => $_getN(4);
  @$pb.TagNumber(5)
  set pagination($2.Pagination value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPagination() => $_has(4);
  @$pb.TagNumber(5)
  void clearPagination() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Pagination ensurePagination() => $_ensure(4);
}

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<Asset>? assets,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ListResponse._();
    if (assets != null) result.assets.addAll(assets);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListResponse._();

  factory ListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListResponse()..mergeFromBuffer(data, registry);
  factory ListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: ListResponse.$_createMessage)
    ..pPM<Asset>(1, _omitFieldNames ? '' : 'assets',
        subBuilder: Asset.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse copyWith(void Function(ListResponse) updates) =>
      super.copyWith((message) => updates(message as ListResponse))
          as ListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListResponse() / ListResponse.new instead')
  static ListResponse create() => ListResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListResponse._();
  @$core.override
  ListResponse createEmptyInstance() => ListResponse._();
  @$core.pragma('dart2js:noInline')
  static ListResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListResponse>(
          ListResponse.$_createMessage);
  static ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class GetRequest extends $pb.GeneratedMessage {
  factory GetRequest({
    $2.UUID? workspaceId,
    $core.String? assetId,
  }) {
    final result = GetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  GetRequest._();

  factory GetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRequest()..mergeFromBuffer(data, registry);
  factory GetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequest copyWith(void Function(GetRequest) updates) =>
      super.copyWith((message) => updates(message as GetRequest)) as GetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetRequest() / GetRequest.new instead')
  static GetRequest create() => GetRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetRequest._();
  @$core.override
  GetRequest createEmptyInstance() => GetRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRequest>(GetRequest.$_createMessage);
  static GetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);
}

class GetResponse extends $pb.GeneratedMessage {
  factory GetResponse({
    Asset? asset,
  }) {
    final result = GetResponse._();
    if (asset != null) result.asset = asset;
    return result;
  }

  GetResponse._();

  factory GetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetResponse()..mergeFromBuffer(data, registry);
  factory GetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GetResponse.$_createMessage)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetResponse copyWith(void Function(GetResponse) updates) =>
      super.copyWith((message) => updates(message as GetResponse))
          as GetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetResponse() / GetResponse.new instead')
  static GetResponse create() => GetResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetResponse._();
  @$core.override
  GetResponse createEmptyInstance() => GetResponse._();
  @$core.pragma('dart2js:noInline')
  static GetResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetResponse>(
          GetResponse.$_createMessage);
  static GetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class ApproveRequest extends $pb.GeneratedMessage {
  factory ApproveRequest({
    $2.CommandContext? context,
    $core.String? assetId,
    $core.String? feedbackNotes,
  }) {
    final result = ApproveRequest._();
    if (context != null) result.context = context;
    if (assetId != null) result.assetId = assetId;
    if (feedbackNotes != null) result.feedbackNotes = feedbackNotes;
    return result;
  }

  ApproveRequest._();

  factory ApproveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApproveRequest()..mergeFromBuffer(data, registry);
  factory ApproveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApproveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: ApproveRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'feedbackNotes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRequest copyWith(void Function(ApproveRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveRequest))
          as ApproveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ApproveRequest() / ApproveRequest.new instead')
  static ApproveRequest create() => ApproveRequest._();
  static $pb.GeneratedMessage $_createMessage() => ApproveRequest._();
  @$core.override
  ApproveRequest createEmptyInstance() => ApproveRequest._();
  @$core.pragma('dart2js:noInline')
  static ApproveRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveRequest>(
          ApproveRequest.$_createMessage);
  static ApproveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get feedbackNotes => $_getSZ(2);
  @$pb.TagNumber(3)
  set feedbackNotes($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeedbackNotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeedbackNotes() => $_clearField(3);
}

class ApproveResponse extends $pb.GeneratedMessage {
  factory ApproveResponse({
    Asset? asset,
  }) {
    final result = ApproveResponse._();
    if (asset != null) result.asset = asset;
    return result;
  }

  ApproveResponse._();

  factory ApproveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApproveResponse()..mergeFromBuffer(data, registry);
  factory ApproveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApproveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: ApproveResponse.$_createMessage)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveResponse copyWith(void Function(ApproveResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveResponse))
          as ApproveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ApproveResponse() / ApproveResponse.new instead')
  static ApproveResponse create() => ApproveResponse._();
  static $pb.GeneratedMessage $_createMessage() => ApproveResponse._();
  @$core.override
  ApproveResponse createEmptyInstance() => ApproveResponse._();
  @$core.pragma('dart2js:noInline')
  static ApproveResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveResponse>(
          ApproveResponse.$_createMessage);
  static ApproveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class PromoteCanonicalRequest extends $pb.GeneratedMessage {
  factory PromoteCanonicalRequest({
    $2.CommandContext? context,
    $core.String? assetId,
    $core.String? packId,
  }) {
    final result = PromoteCanonicalRequest._();
    if (context != null) result.context = context;
    if (assetId != null) result.assetId = assetId;
    if (packId != null) result.packId = packId;
    return result;
  }

  PromoteCanonicalRequest._();

  factory PromoteCanonicalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PromoteCanonicalRequest()..mergeFromBuffer(data, registry);
  factory PromoteCanonicalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PromoteCanonicalRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromoteCanonicalRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: PromoteCanonicalRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'packId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromoteCanonicalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromoteCanonicalRequest copyWith(
          void Function(PromoteCanonicalRequest) updates) =>
      super.copyWith((message) => updates(message as PromoteCanonicalRequest))
          as PromoteCanonicalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PromoteCanonicalRequest() / PromoteCanonicalRequest.new instead')
  static PromoteCanonicalRequest create() => PromoteCanonicalRequest._();
  static $pb.GeneratedMessage $_createMessage() => PromoteCanonicalRequest._();
  @$core.override
  PromoteCanonicalRequest createEmptyInstance() => PromoteCanonicalRequest._();
  @$core.pragma('dart2js:noInline')
  static PromoteCanonicalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromoteCanonicalRequest>(
          PromoteCanonicalRequest.$_createMessage);
  static PromoteCanonicalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get packId => $_getSZ(2);
  @$pb.TagNumber(3)
  set packId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPackId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPackId() => $_clearField(3);
}

class PromoteCanonicalResponse extends $pb.GeneratedMessage {
  factory PromoteCanonicalResponse({
    Asset? asset,
    $core.String? canonicalPackId,
  }) {
    final result = PromoteCanonicalResponse._();
    if (asset != null) result.asset = asset;
    if (canonicalPackId != null) result.canonicalPackId = canonicalPackId;
    return result;
  }

  PromoteCanonicalResponse._();

  factory PromoteCanonicalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PromoteCanonicalResponse()..mergeFromBuffer(data, registry);
  factory PromoteCanonicalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PromoteCanonicalResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromoteCanonicalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: PromoteCanonicalResponse.$_createMessage)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'canonicalPackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromoteCanonicalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromoteCanonicalResponse copyWith(
          void Function(PromoteCanonicalResponse) updates) =>
      super.copyWith((message) => updates(message as PromoteCanonicalResponse))
          as PromoteCanonicalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PromoteCanonicalResponse() / PromoteCanonicalResponse.new instead')
  static PromoteCanonicalResponse create() => PromoteCanonicalResponse._();
  static $pb.GeneratedMessage $_createMessage() => PromoteCanonicalResponse._();
  @$core.override
  PromoteCanonicalResponse createEmptyInstance() =>
      PromoteCanonicalResponse._();
  @$core.pragma('dart2js:noInline')
  static PromoteCanonicalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromoteCanonicalResponse>(
          PromoteCanonicalResponse.$_createMessage);
  static PromoteCanonicalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get canonicalPackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set canonicalPackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCanonicalPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCanonicalPackId() => $_clearField(2);
}

class UploadRequest extends $pb.GeneratedMessage {
  factory UploadRequest({
    $2.CommandContext? context,
    $core.String? fileName,
    $core.String? mimeType,
    $fixnum.Int64? fileSizeBytes,
    $core.List<$core.int>? fileContent,
    $core.String? uploadPurpose,
  }) {
    final result = UploadRequest._();
    if (context != null) result.context = context;
    if (fileName != null) result.fileName = fileName;
    if (mimeType != null) result.mimeType = mimeType;
    if (fileSizeBytes != null) result.fileSizeBytes = fileSizeBytes;
    if (fileContent != null) result.fileContent = fileContent;
    if (uploadPurpose != null) result.uploadPurpose = uploadPurpose;
    return result;
  }

  UploadRequest._();

  factory UploadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UploadRequest()..mergeFromBuffer(data, registry);
  factory UploadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UploadRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: UploadRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'fileName')
    ..aOS(3, _omitFieldNames ? '' : 'mimeType')
    ..aInt64(4, _omitFieldNames ? '' : 'fileSizeBytes')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'fileContent', $pb.PbFieldType.OY)
    ..aOS(6, _omitFieldNames ? '' : 'uploadPurpose')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadRequest copyWith(void Function(UploadRequest) updates) =>
      super.copyWith((message) => updates(message as UploadRequest))
          as UploadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UploadRequest() / UploadRequest.new instead')
  static UploadRequest create() => UploadRequest._();
  static $pb.GeneratedMessage $_createMessage() => UploadRequest._();
  @$core.override
  UploadRequest createEmptyInstance() => UploadRequest._();
  @$core.pragma('dart2js:noInline')
  static UploadRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadRequest>(
          UploadRequest.$_createMessage);
  static UploadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get fileName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get mimeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set mimeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMimeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearMimeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get fileSizeBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set fileSizeBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFileSizeBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileSizeBytes() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get fileContent => $_getN(4);
  @$pb.TagNumber(5)
  set fileContent($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFileContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileContent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get uploadPurpose => $_getSZ(5);
  @$pb.TagNumber(6)
  set uploadPurpose($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUploadPurpose() => $_has(5);
  @$pb.TagNumber(6)
  void clearUploadPurpose() => $_clearField(6);
}

class UploadResponse extends $pb.GeneratedMessage {
  factory UploadResponse({
    $core.String? uploadId,
    $core.String? storageUrl,
    $core.String? virusScanStatus,
    Asset? asset,
  }) {
    final result = UploadResponse._();
    if (uploadId != null) result.uploadId = uploadId;
    if (storageUrl != null) result.storageUrl = storageUrl;
    if (virusScanStatus != null) result.virusScanStatus = virusScanStatus;
    if (asset != null) result.asset = asset;
    return result;
  }

  UploadResponse._();

  factory UploadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UploadResponse()..mergeFromBuffer(data, registry);
  factory UploadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UploadResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: UploadResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'uploadId')
    ..aOS(2, _omitFieldNames ? '' : 'storageUrl')
    ..aOS(3, _omitFieldNames ? '' : 'virusScanStatus')
    ..aOM<Asset>(4, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadResponse copyWith(void Function(UploadResponse) updates) =>
      super.copyWith((message) => updates(message as UploadResponse))
          as UploadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UploadResponse() / UploadResponse.new instead')
  static UploadResponse create() => UploadResponse._();
  static $pb.GeneratedMessage $_createMessage() => UploadResponse._();
  @$core.override
  UploadResponse createEmptyInstance() => UploadResponse._();
  @$core.pragma('dart2js:noInline')
  static UploadResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadResponse>(
          UploadResponse.$_createMessage);
  static UploadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUploadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storageUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set storageUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorageUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorageUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get virusScanStatus => $_getSZ(2);
  @$pb.TagNumber(3)
  set virusScanStatus($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVirusScanStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearVirusScanStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  Asset get asset => $_getN(3);
  @$pb.TagNumber(4)
  set asset(Asset value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAsset() => $_has(3);
  @$pb.TagNumber(4)
  void clearAsset() => $_clearField(4);
  @$pb.TagNumber(4)
  Asset ensureAsset() => $_ensure(3);
}

class TranscriptWord extends $pb.GeneratedMessage {
  factory TranscriptWord({
    $core.String? wordId,
    $core.String? text,
    $fixnum.Int64? startMs,
    $fixnum.Int64? endMs,
    $core.double? confidence,
    $core.bool? isFiller,
    $core.String? fillerType,
    $core.bool? isDeleted,
  }) {
    final result = TranscriptWord._();
    if (wordId != null) result.wordId = wordId;
    if (text != null) result.text = text;
    if (startMs != null) result.startMs = startMs;
    if (endMs != null) result.endMs = endMs;
    if (confidence != null) result.confidence = confidence;
    if (isFiller != null) result.isFiller = isFiller;
    if (fillerType != null) result.fillerType = fillerType;
    if (isDeleted != null) result.isDeleted = isDeleted;
    return result;
  }

  TranscriptWord._();

  factory TranscriptWord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranscriptWord()..mergeFromBuffer(data, registry);
  factory TranscriptWord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranscriptWord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranscriptWord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranscriptWord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'wordId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aInt64(3, _omitFieldNames ? '' : 'startMs')
    ..aInt64(4, _omitFieldNames ? '' : 'endMs')
    ..aD(5, _omitFieldNames ? '' : 'confidence')
    ..aOB(6, _omitFieldNames ? '' : 'isFiller')
    ..aOS(7, _omitFieldNames ? '' : 'fillerType')
    ..aOB(8, _omitFieldNames ? '' : 'isDeleted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranscriptWord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranscriptWord copyWith(void Function(TranscriptWord) updates) =>
      super.copyWith((message) => updates(message as TranscriptWord))
          as TranscriptWord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TranscriptWord() / TranscriptWord.new instead')
  static TranscriptWord create() => TranscriptWord._();
  static $pb.GeneratedMessage $_createMessage() => TranscriptWord._();
  @$core.override
  TranscriptWord createEmptyInstance() => TranscriptWord._();
  @$core.pragma('dart2js:noInline')
  static TranscriptWord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranscriptWord>(
          TranscriptWord.$_createMessage);
  static TranscriptWord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get wordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set wordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get startMs => $_getI64(2);
  @$pb.TagNumber(3)
  set startMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get endMs => $_getI64(3);
  @$pb.TagNumber(4)
  set endMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEndMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get confidence => $_getN(4);
  @$pb.TagNumber(5)
  set confidence($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConfidence() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfidence() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isFiller => $_getBF(5);
  @$pb.TagNumber(6)
  set isFiller($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsFiller() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsFiller() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get fillerType => $_getSZ(6);
  @$pb.TagNumber(7)
  set fillerType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFillerType() => $_has(6);
  @$pb.TagNumber(7)
  void clearFillerType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDeleted => $_getBF(7);
  @$pb.TagNumber(8)
  set isDeleted($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDeleted() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDeleted() => $_clearField(8);
}

class TranscriptSegment extends $pb.GeneratedMessage {
  factory TranscriptSegment({
    $core.String? segmentId,
    $fixnum.Int64? startMs,
    $fixnum.Int64? endMs,
    $core.String? text,
    $core.String? speakerId,
  }) {
    final result = TranscriptSegment._();
    if (segmentId != null) result.segmentId = segmentId;
    if (startMs != null) result.startMs = startMs;
    if (endMs != null) result.endMs = endMs;
    if (text != null) result.text = text;
    if (speakerId != null) result.speakerId = speakerId;
    return result;
  }

  TranscriptSegment._();

  factory TranscriptSegment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranscriptSegment()..mergeFromBuffer(data, registry);
  factory TranscriptSegment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranscriptSegment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranscriptSegment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranscriptSegment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'segmentId')
    ..aInt64(2, _omitFieldNames ? '' : 'startMs')
    ..aInt64(3, _omitFieldNames ? '' : 'endMs')
    ..aOS(4, _omitFieldNames ? '' : 'text')
    ..aOS(5, _omitFieldNames ? '' : 'speakerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranscriptSegment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranscriptSegment copyWith(void Function(TranscriptSegment) updates) =>
      super.copyWith((message) => updates(message as TranscriptSegment))
          as TranscriptSegment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TranscriptSegment() / TranscriptSegment.new instead')
  static TranscriptSegment create() => TranscriptSegment._();
  static $pb.GeneratedMessage $_createMessage() => TranscriptSegment._();
  @$core.override
  TranscriptSegment createEmptyInstance() => TranscriptSegment._();
  @$core.pragma('dart2js:noInline')
  static TranscriptSegment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranscriptSegment>(
          TranscriptSegment.$_createMessage);
  static TranscriptSegment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get segmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set segmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSegmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSegmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get startMs => $_getI64(1);
  @$pb.TagNumber(2)
  set startMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endMs => $_getI64(2);
  @$pb.TagNumber(3)
  set endMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get text => $_getSZ(3);
  @$pb.TagNumber(4)
  set text($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get speakerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set speakerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpeakerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpeakerId() => $_clearField(5);
}

class Transcript extends $pb.GeneratedMessage {
  factory Transcript({
    $core.String? transcriptId,
    $2.UUID? workspaceId,
    $core.String? assetId,
    $core.String? language,
    $core.String? rawText,
    $core.Iterable<TranscriptWord>? words,
    $core.Iterable<TranscriptSegment>? segments,
    $core.int? fillerCount,
    $core.int? pauseCount,
    TranscriptAlignmentStatus? alignmentStatus,
    $core.String? alignmentError,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Transcript._();
    if (transcriptId != null) result.transcriptId = transcriptId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assetId != null) result.assetId = assetId;
    if (language != null) result.language = language;
    if (rawText != null) result.rawText = rawText;
    if (words != null) result.words.addAll(words);
    if (segments != null) result.segments.addAll(segments);
    if (fillerCount != null) result.fillerCount = fillerCount;
    if (pauseCount != null) result.pauseCount = pauseCount;
    if (alignmentStatus != null) result.alignmentStatus = alignmentStatus;
    if (alignmentError != null) result.alignmentError = alignmentError;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Transcript._();

  factory Transcript.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Transcript()..mergeFromBuffer(data, registry);
  factory Transcript.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Transcript()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Transcript',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: Transcript.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'transcriptId')
    ..aOM<$2.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'language')
    ..aOS(5, _omitFieldNames ? '' : 'rawText')
    ..pPM<TranscriptWord>(6, _omitFieldNames ? '' : 'words',
        subBuilder: TranscriptWord.$_createMessage)
    ..pPM<TranscriptSegment>(7, _omitFieldNames ? '' : 'segments',
        subBuilder: TranscriptSegment.$_createMessage)
    ..aI(8, _omitFieldNames ? '' : 'fillerCount')
    ..aI(9, _omitFieldNames ? '' : 'pauseCount')
    ..aE<TranscriptAlignmentStatus>(
        10, _omitFieldNames ? '' : 'alignmentStatus',
        enumValues: TranscriptAlignmentStatus.values)
    ..aOS(11, _omitFieldNames ? '' : 'alignmentError')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transcript clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transcript copyWith(void Function(Transcript) updates) =>
      super.copyWith((message) => updates(message as Transcript)) as Transcript;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Transcript() / Transcript.new instead')
  static Transcript create() => Transcript._();
  static $pb.GeneratedMessage $_createMessage() => Transcript._();
  @$core.override
  Transcript createEmptyInstance() => Transcript._();
  @$core.pragma('dart2js:noInline')
  static Transcript getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Transcript>(Transcript.$_createMessage);
  static Transcript? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transcriptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transcriptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTranscriptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTranscriptId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($2.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get language => $_getSZ(3);
  @$pb.TagNumber(4)
  set language($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLanguage() => $_has(3);
  @$pb.TagNumber(4)
  void clearLanguage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get rawText => $_getSZ(4);
  @$pb.TagNumber(5)
  set rawText($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRawText() => $_has(4);
  @$pb.TagNumber(5)
  void clearRawText() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<TranscriptWord> get words => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<TranscriptSegment> get segments => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get fillerCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set fillerCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFillerCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearFillerCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get pauseCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set pauseCount($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPauseCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearPauseCount() => $_clearField(9);

  @$pb.TagNumber(10)
  TranscriptAlignmentStatus get alignmentStatus => $_getN(9);
  @$pb.TagNumber(10)
  set alignmentStatus(TranscriptAlignmentStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasAlignmentStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearAlignmentStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get alignmentError => $_getSZ(10);
  @$pb.TagNumber(11)
  set alignmentError($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAlignmentError() => $_has(10);
  @$pb.TagNumber(11)
  void clearAlignmentError() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureCreatedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $1.Timestamp get updatedAt => $_getN(12);
  @$pb.TagNumber(13)
  set updatedAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasUpdatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearUpdatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureUpdatedAt() => $_ensure(12);
}

class DeadPause extends $pb.GeneratedMessage {
  factory DeadPause({
    $fixnum.Int64? startMs,
    $fixnum.Int64? endMs,
    $fixnum.Int64? durationMs,
  }) {
    final result = DeadPause._();
    if (startMs != null) result.startMs = startMs;
    if (endMs != null) result.endMs = endMs;
    if (durationMs != null) result.durationMs = durationMs;
    return result;
  }

  DeadPause._();

  factory DeadPause.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeadPause()..mergeFromBuffer(data, registry);
  factory DeadPause.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeadPause()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeadPause',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: DeadPause.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'startMs')
    ..aInt64(2, _omitFieldNames ? '' : 'endMs')
    ..aInt64(3, _omitFieldNames ? '' : 'durationMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeadPause clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeadPause copyWith(void Function(DeadPause) updates) =>
      super.copyWith((message) => updates(message as DeadPause)) as DeadPause;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeadPause() / DeadPause.new instead')
  static DeadPause create() => DeadPause._();
  static $pb.GeneratedMessage $_createMessage() => DeadPause._();
  @$core.override
  DeadPause createEmptyInstance() => DeadPause._();
  @$core.pragma('dart2js:noInline')
  static DeadPause getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeadPause>(DeadPause.$_createMessage);
  static DeadPause? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get startMs => $_getI64(0);
  @$pb.TagNumber(1)
  set startMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get endMs => $_getI64(1);
  @$pb.TagNumber(2)
  set endMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get durationMs => $_getI64(2);
  @$pb.TagNumber(3)
  set durationMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationMs() => $_clearField(3);
}

class TranscriptAnalysis extends $pb.GeneratedMessage {
  factory TranscriptAnalysis({
    $core.int? fillerCount,
    $core.int? pauseCount,
    $core.double? hookQualityScore,
    $fixnum.Int64? estimatedTimeSavedMs,
    $fixnum.Int64? finalDurationMs,
    $core.Iterable<$core.String>? detectedFillers,
    $core.Iterable<DeadPause>? deadPauses,
    $core.String? hookFeedback,
  }) {
    final result = TranscriptAnalysis._();
    if (fillerCount != null) result.fillerCount = fillerCount;
    if (pauseCount != null) result.pauseCount = pauseCount;
    if (hookQualityScore != null) result.hookQualityScore = hookQualityScore;
    if (estimatedTimeSavedMs != null)
      result.estimatedTimeSavedMs = estimatedTimeSavedMs;
    if (finalDurationMs != null) result.finalDurationMs = finalDurationMs;
    if (detectedFillers != null) result.detectedFillers.addAll(detectedFillers);
    if (deadPauses != null) result.deadPauses.addAll(deadPauses);
    if (hookFeedback != null) result.hookFeedback = hookFeedback;
    return result;
  }

  TranscriptAnalysis._();

  factory TranscriptAnalysis.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranscriptAnalysis()..mergeFromBuffer(data, registry);
  factory TranscriptAnalysis.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranscriptAnalysis()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranscriptAnalysis',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranscriptAnalysis.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'fillerCount')
    ..aI(2, _omitFieldNames ? '' : 'pauseCount')
    ..aD(3, _omitFieldNames ? '' : 'hookQualityScore')
    ..aInt64(4, _omitFieldNames ? '' : 'estimatedTimeSavedMs')
    ..aInt64(5, _omitFieldNames ? '' : 'finalDurationMs')
    ..pPS(6, _omitFieldNames ? '' : 'detectedFillers')
    ..pPM<DeadPause>(7, _omitFieldNames ? '' : 'deadPauses',
        subBuilder: DeadPause.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'hookFeedback')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranscriptAnalysis clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranscriptAnalysis copyWith(void Function(TranscriptAnalysis) updates) =>
      super.copyWith((message) => updates(message as TranscriptAnalysis))
          as TranscriptAnalysis;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TranscriptAnalysis() / TranscriptAnalysis.new instead')
  static TranscriptAnalysis create() => TranscriptAnalysis._();
  static $pb.GeneratedMessage $_createMessage() => TranscriptAnalysis._();
  @$core.override
  TranscriptAnalysis createEmptyInstance() => TranscriptAnalysis._();
  @$core.pragma('dart2js:noInline')
  static TranscriptAnalysis getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranscriptAnalysis>(
          TranscriptAnalysis.$_createMessage);
  static TranscriptAnalysis? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get fillerCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set fillerCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFillerCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearFillerCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pauseCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set pauseCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPauseCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearPauseCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get hookQualityScore => $_getN(2);
  @$pb.TagNumber(3)
  set hookQualityScore($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHookQualityScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHookQualityScore() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get estimatedTimeSavedMs => $_getI64(3);
  @$pb.TagNumber(4)
  set estimatedTimeSavedMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEstimatedTimeSavedMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearEstimatedTimeSavedMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get finalDurationMs => $_getI64(4);
  @$pb.TagNumber(5)
  set finalDurationMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFinalDurationMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearFinalDurationMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get detectedFillers => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<DeadPause> get deadPauses => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get hookFeedback => $_getSZ(7);
  @$pb.TagNumber(8)
  set hookFeedback($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHookFeedback() => $_has(7);
  @$pb.TagNumber(8)
  void clearHookFeedback() => $_clearField(8);
}

class TranscriptCorrection extends $pb.GeneratedMessage {
  factory TranscriptCorrection({
    $core.String? wordId,
    $core.String? correctedText,
    $fixnum.Int64? newStartMs,
    $fixnum.Int64? newEndMs,
    $core.bool? markCut,
  }) {
    final result = TranscriptCorrection._();
    if (wordId != null) result.wordId = wordId;
    if (correctedText != null) result.correctedText = correctedText;
    if (newStartMs != null) result.newStartMs = newStartMs;
    if (newEndMs != null) result.newEndMs = newEndMs;
    if (markCut != null) result.markCut = markCut;
    return result;
  }

  TranscriptCorrection._();

  factory TranscriptCorrection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranscriptCorrection()..mergeFromBuffer(data, registry);
  factory TranscriptCorrection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranscriptCorrection()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranscriptCorrection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranscriptCorrection.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'wordId')
    ..aOS(2, _omitFieldNames ? '' : 'correctedText')
    ..aInt64(3, _omitFieldNames ? '' : 'newStartMs')
    ..aInt64(4, _omitFieldNames ? '' : 'newEndMs')
    ..aOB(5, _omitFieldNames ? '' : 'markCut')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranscriptCorrection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranscriptCorrection copyWith(void Function(TranscriptCorrection) updates) =>
      super.copyWith((message) => updates(message as TranscriptCorrection))
          as TranscriptCorrection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TranscriptCorrection() / TranscriptCorrection.new instead')
  static TranscriptCorrection create() => TranscriptCorrection._();
  static $pb.GeneratedMessage $_createMessage() => TranscriptCorrection._();
  @$core.override
  TranscriptCorrection createEmptyInstance() => TranscriptCorrection._();
  @$core.pragma('dart2js:noInline')
  static TranscriptCorrection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranscriptCorrection>(
          TranscriptCorrection.$_createMessage);
  static TranscriptCorrection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get wordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set wordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get correctedText => $_getSZ(1);
  @$pb.TagNumber(2)
  set correctedText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCorrectedText() => $_has(1);
  @$pb.TagNumber(2)
  void clearCorrectedText() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get newStartMs => $_getI64(2);
  @$pb.TagNumber(3)
  set newStartMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewStartMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewStartMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get newEndMs => $_getI64(3);
  @$pb.TagNumber(4)
  set newEndMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewEndMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewEndMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get markCut => $_getBF(4);
  @$pb.TagNumber(5)
  set markCut($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMarkCut() => $_has(4);
  @$pb.TagNumber(5)
  void clearMarkCut() => $_clearField(5);
}

class CutInterval extends $pb.GeneratedMessage {
  factory CutInterval({
    $fixnum.Int64? startMs,
    $fixnum.Int64? endMs,
    $core.String? reason,
  }) {
    final result = CutInterval._();
    if (startMs != null) result.startMs = startMs;
    if (endMs != null) result.endMs = endMs;
    if (reason != null) result.reason = reason;
    return result;
  }

  CutInterval._();

  factory CutInterval.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CutInterval()..mergeFromBuffer(data, registry);
  factory CutInterval.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CutInterval()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CutInterval',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: CutInterval.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'startMs')
    ..aInt64(2, _omitFieldNames ? '' : 'endMs')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CutInterval clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CutInterval copyWith(void Function(CutInterval) updates) =>
      super.copyWith((message) => updates(message as CutInterval))
          as CutInterval;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CutInterval() / CutInterval.new instead')
  static CutInterval create() => CutInterval._();
  static $pb.GeneratedMessage $_createMessage() => CutInterval._();
  @$core.override
  CutInterval createEmptyInstance() => CutInterval._();
  @$core.pragma('dart2js:noInline')
  static CutInterval getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CutInterval>(
          CutInterval.$_createMessage);
  static CutInterval? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get startMs => $_getI64(0);
  @$pb.TagNumber(1)
  set startMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get endMs => $_getI64(1);
  @$pb.TagNumber(2)
  set endMs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class QuickEditAddons extends $pb.GeneratedMessage {
  factory QuickEditAddons({
    $core.bool? autoCaptions,
    $core.String? captionStyle,
    $core.bool? addHook,
    $core.String? hookId,
    $core.String? hookType,
    $core.bool? beatSync,
    $core.String? soundId,
    $core.bool? bRoll,
    $core.String? bRollScene,
    $core.String? platformPreset,
    $core.bool? audioEnhancement,
    $core.double? targetLufs,
    $core.String? reframeRatio,
  }) {
    final result = QuickEditAddons._();
    if (autoCaptions != null) result.autoCaptions = autoCaptions;
    if (captionStyle != null) result.captionStyle = captionStyle;
    if (addHook != null) result.addHook = addHook;
    if (hookId != null) result.hookId = hookId;
    if (hookType != null) result.hookType = hookType;
    if (beatSync != null) result.beatSync = beatSync;
    if (soundId != null) result.soundId = soundId;
    if (bRoll != null) result.bRoll = bRoll;
    if (bRollScene != null) result.bRollScene = bRollScene;
    if (platformPreset != null) result.platformPreset = platformPreset;
    if (audioEnhancement != null) result.audioEnhancement = audioEnhancement;
    if (targetLufs != null) result.targetLufs = targetLufs;
    if (reframeRatio != null) result.reframeRatio = reframeRatio;
    return result;
  }

  QuickEditAddons._();

  factory QuickEditAddons.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditAddons()..mergeFromBuffer(data, registry);
  factory QuickEditAddons.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditAddons()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickEditAddons',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: QuickEditAddons.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'autoCaptions')
    ..aOS(2, _omitFieldNames ? '' : 'captionStyle')
    ..aOB(3, _omitFieldNames ? '' : 'addHook')
    ..aOS(4, _omitFieldNames ? '' : 'hookId')
    ..aOS(5, _omitFieldNames ? '' : 'hookType')
    ..aOB(6, _omitFieldNames ? '' : 'beatSync')
    ..aOS(7, _omitFieldNames ? '' : 'soundId')
    ..aOB(8, _omitFieldNames ? '' : 'bRoll')
    ..aOS(9, _omitFieldNames ? '' : 'bRollScene')
    ..aOS(10, _omitFieldNames ? '' : 'platformPreset')
    ..aOB(11, _omitFieldNames ? '' : 'audioEnhancement')
    ..aD(12, _omitFieldNames ? '' : 'targetLufs')
    ..aOS(13, _omitFieldNames ? '' : 'reframeRatio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditAddons clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditAddons copyWith(void Function(QuickEditAddons) updates) =>
      super.copyWith((message) => updates(message as QuickEditAddons))
          as QuickEditAddons;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QuickEditAddons() / QuickEditAddons.new instead')
  static QuickEditAddons create() => QuickEditAddons._();
  static $pb.GeneratedMessage $_createMessage() => QuickEditAddons._();
  @$core.override
  QuickEditAddons createEmptyInstance() => QuickEditAddons._();
  @$core.pragma('dart2js:noInline')
  static QuickEditAddons getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuickEditAddons>(
          QuickEditAddons.$_createMessage);
  static QuickEditAddons? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get autoCaptions => $_getBF(0);
  @$pb.TagNumber(1)
  set autoCaptions($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAutoCaptions() => $_has(0);
  @$pb.TagNumber(1)
  void clearAutoCaptions() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get captionStyle => $_getSZ(1);
  @$pb.TagNumber(2)
  set captionStyle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaptionStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaptionStyle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get addHook => $_getBF(2);
  @$pb.TagNumber(3)
  set addHook($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAddHook() => $_has(2);
  @$pb.TagNumber(3)
  void clearAddHook() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get hookId => $_getSZ(3);
  @$pb.TagNumber(4)
  set hookId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHookId() => $_has(3);
  @$pb.TagNumber(4)
  void clearHookId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get hookType => $_getSZ(4);
  @$pb.TagNumber(5)
  set hookType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHookType() => $_has(4);
  @$pb.TagNumber(5)
  void clearHookType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get beatSync => $_getBF(5);
  @$pb.TagNumber(6)
  set beatSync($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBeatSync() => $_has(5);
  @$pb.TagNumber(6)
  void clearBeatSync() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get soundId => $_getSZ(6);
  @$pb.TagNumber(7)
  set soundId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSoundId() => $_has(6);
  @$pb.TagNumber(7)
  void clearSoundId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get bRoll => $_getBF(7);
  @$pb.TagNumber(8)
  set bRoll($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBRoll() => $_has(7);
  @$pb.TagNumber(8)
  void clearBRoll() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get bRollScene => $_getSZ(8);
  @$pb.TagNumber(9)
  set bRollScene($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBRollScene() => $_has(8);
  @$pb.TagNumber(9)
  void clearBRollScene() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get platformPreset => $_getSZ(9);
  @$pb.TagNumber(10)
  set platformPreset($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPlatformPreset() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlatformPreset() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get audioEnhancement => $_getBF(10);
  @$pb.TagNumber(11)
  set audioEnhancement($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAudioEnhancement() => $_has(10);
  @$pb.TagNumber(11)
  void clearAudioEnhancement() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get targetLufs => $_getN(11);
  @$pb.TagNumber(12)
  set targetLufs($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTargetLufs() => $_has(11);
  @$pb.TagNumber(12)
  void clearTargetLufs() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get reframeRatio => $_getSZ(12);
  @$pb.TagNumber(13)
  set reframeRatio($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasReframeRatio() => $_has(12);
  @$pb.TagNumber(13)
  void clearReframeRatio() => $_clearField(13);
}

class QuickEditPlan extends $pb.GeneratedMessage {
  factory QuickEditPlan({
    $core.String? assetId,
    $core.String? transcriptId,
    $core.Iterable<CutInterval>? cuts,
    QuickEditAddons? addons,
    $core.String? estimatedCredits,
    $core.String? balanceAfterCredits,
  }) {
    final result = QuickEditPlan._();
    if (assetId != null) result.assetId = assetId;
    if (transcriptId != null) result.transcriptId = transcriptId;
    if (cuts != null) result.cuts.addAll(cuts);
    if (addons != null) result.addons = addons;
    if (estimatedCredits != null) result.estimatedCredits = estimatedCredits;
    if (balanceAfterCredits != null)
      result.balanceAfterCredits = balanceAfterCredits;
    return result;
  }

  QuickEditPlan._();

  factory QuickEditPlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditPlan()..mergeFromBuffer(data, registry);
  factory QuickEditPlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditPlan()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickEditPlan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: QuickEditPlan.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'transcriptId')
    ..pPM<CutInterval>(3, _omitFieldNames ? '' : 'cuts',
        subBuilder: CutInterval.$_createMessage)
    ..aOM<QuickEditAddons>(4, _omitFieldNames ? '' : 'addons',
        subBuilder: QuickEditAddons.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'estimatedCredits')
    ..aOS(6, _omitFieldNames ? '' : 'balanceAfterCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditPlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditPlan copyWith(void Function(QuickEditPlan) updates) =>
      super.copyWith((message) => updates(message as QuickEditPlan))
          as QuickEditPlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QuickEditPlan() / QuickEditPlan.new instead')
  static QuickEditPlan create() => QuickEditPlan._();
  static $pb.GeneratedMessage $_createMessage() => QuickEditPlan._();
  @$core.override
  QuickEditPlan createEmptyInstance() => QuickEditPlan._();
  @$core.pragma('dart2js:noInline')
  static QuickEditPlan getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuickEditPlan>(
          QuickEditPlan.$_createMessage);
  static QuickEditPlan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get transcriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set transcriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTranscriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTranscriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<CutInterval> get cuts => $_getList(2);

  @$pb.TagNumber(4)
  QuickEditAddons get addons => $_getN(3);
  @$pb.TagNumber(4)
  set addons(QuickEditAddons value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAddons() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddons() => $_clearField(4);
  @$pb.TagNumber(4)
  QuickEditAddons ensureAddons() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get estimatedCredits => $_getSZ(4);
  @$pb.TagNumber(5)
  set estimatedCredits($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEstimatedCredits() => $_has(4);
  @$pb.TagNumber(5)
  void clearEstimatedCredits() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get balanceAfterCredits => $_getSZ(5);
  @$pb.TagNumber(6)
  set balanceAfterCredits($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBalanceAfterCredits() => $_has(5);
  @$pb.TagNumber(6)
  void clearBalanceAfterCredits() => $_clearField(6);
}

class QuickEditDraft extends $pb.GeneratedMessage {
  factory QuickEditDraft({
    $core.String? draftId,
    $2.UUID? workspaceId,
    $core.String? assetId,
    $core.String? transcriptId,
    $core.String? name,
    $core.Iterable<CutInterval>? cuts,
    QuickEditAddons? addons,
    $core.String? estimatedCredits,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = QuickEditDraft._();
    if (draftId != null) result.draftId = draftId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assetId != null) result.assetId = assetId;
    if (transcriptId != null) result.transcriptId = transcriptId;
    if (name != null) result.name = name;
    if (cuts != null) result.cuts.addAll(cuts);
    if (addons != null) result.addons = addons;
    if (estimatedCredits != null) result.estimatedCredits = estimatedCredits;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  QuickEditDraft._();

  factory QuickEditDraft.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditDraft()..mergeFromBuffer(data, registry);
  factory QuickEditDraft.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditDraft()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickEditDraft',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: QuickEditDraft.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'draftId')
    ..aOM<$2.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'transcriptId')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..pPM<CutInterval>(6, _omitFieldNames ? '' : 'cuts',
        subBuilder: CutInterval.$_createMessage)
    ..aOM<QuickEditAddons>(7, _omitFieldNames ? '' : 'addons',
        subBuilder: QuickEditAddons.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'estimatedCredits')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditDraft clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditDraft copyWith(void Function(QuickEditDraft) updates) =>
      super.copyWith((message) => updates(message as QuickEditDraft))
          as QuickEditDraft;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QuickEditDraft() / QuickEditDraft.new instead')
  static QuickEditDraft create() => QuickEditDraft._();
  static $pb.GeneratedMessage $_createMessage() => QuickEditDraft._();
  @$core.override
  QuickEditDraft createEmptyInstance() => QuickEditDraft._();
  @$core.pragma('dart2js:noInline')
  static QuickEditDraft getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuickEditDraft>(
          QuickEditDraft.$_createMessage);
  static QuickEditDraft? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get draftId => $_getSZ(0);
  @$pb.TagNumber(1)
  set draftId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDraftId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDraftId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($2.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get transcriptId => $_getSZ(3);
  @$pb.TagNumber(4)
  set transcriptId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTranscriptId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTranscriptId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<CutInterval> get cuts => $_getList(5);

  @$pb.TagNumber(7)
  QuickEditAddons get addons => $_getN(6);
  @$pb.TagNumber(7)
  set addons(QuickEditAddons value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAddons() => $_has(6);
  @$pb.TagNumber(7)
  void clearAddons() => $_clearField(7);
  @$pb.TagNumber(7)
  QuickEditAddons ensureAddons() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get estimatedCredits => $_getSZ(7);
  @$pb.TagNumber(8)
  set estimatedCredits($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEstimatedCredits() => $_has(7);
  @$pb.TagNumber(8)
  void clearEstimatedCredits() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureUpdatedAt() => $_ensure(9);
}

class QuickEditServiceSaveDraftRequest extends $pb.GeneratedMessage {
  factory QuickEditServiceSaveDraftRequest({
    $2.CommandContext? context,
    $core.String? draftId,
    $core.String? assetId,
    $core.String? transcriptId,
    $core.String? name,
    $core.Iterable<CutInterval>? cuts,
    QuickEditAddons? addons,
    $core.String? estimatedCredits,
  }) {
    final result = QuickEditServiceSaveDraftRequest._();
    if (context != null) result.context = context;
    if (draftId != null) result.draftId = draftId;
    if (assetId != null) result.assetId = assetId;
    if (transcriptId != null) result.transcriptId = transcriptId;
    if (name != null) result.name = name;
    if (cuts != null) result.cuts.addAll(cuts);
    if (addons != null) result.addons = addons;
    if (estimatedCredits != null) result.estimatedCredits = estimatedCredits;
    return result;
  }

  QuickEditServiceSaveDraftRequest._();

  factory QuickEditServiceSaveDraftRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditServiceSaveDraftRequest()..mergeFromBuffer(data, registry);
  factory QuickEditServiceSaveDraftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditServiceSaveDraftRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickEditServiceSaveDraftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: QuickEditServiceSaveDraftRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'draftId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'transcriptId')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..pPM<CutInterval>(6, _omitFieldNames ? '' : 'cuts',
        subBuilder: CutInterval.$_createMessage)
    ..aOM<QuickEditAddons>(7, _omitFieldNames ? '' : 'addons',
        subBuilder: QuickEditAddons.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'estimatedCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditServiceSaveDraftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditServiceSaveDraftRequest copyWith(
          void Function(QuickEditServiceSaveDraftRequest) updates) =>
      super.copyWith(
              (message) => updates(message as QuickEditServiceSaveDraftRequest))
          as QuickEditServiceSaveDraftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use QuickEditServiceSaveDraftRequest() / QuickEditServiceSaveDraftRequest.new instead')
  static QuickEditServiceSaveDraftRequest create() =>
      QuickEditServiceSaveDraftRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      QuickEditServiceSaveDraftRequest._();
  @$core.override
  QuickEditServiceSaveDraftRequest createEmptyInstance() =>
      QuickEditServiceSaveDraftRequest._();
  @$core.pragma('dart2js:noInline')
  static QuickEditServiceSaveDraftRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuickEditServiceSaveDraftRequest>(
          QuickEditServiceSaveDraftRequest.$_createMessage);
  static QuickEditServiceSaveDraftRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get draftId => $_getSZ(1);
  @$pb.TagNumber(2)
  set draftId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDraftId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDraftId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get transcriptId => $_getSZ(3);
  @$pb.TagNumber(4)
  set transcriptId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTranscriptId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTranscriptId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<CutInterval> get cuts => $_getList(5);

  @$pb.TagNumber(7)
  QuickEditAddons get addons => $_getN(6);
  @$pb.TagNumber(7)
  set addons(QuickEditAddons value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAddons() => $_has(6);
  @$pb.TagNumber(7)
  void clearAddons() => $_clearField(7);
  @$pb.TagNumber(7)
  QuickEditAddons ensureAddons() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get estimatedCredits => $_getSZ(7);
  @$pb.TagNumber(8)
  set estimatedCredits($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEstimatedCredits() => $_has(7);
  @$pb.TagNumber(8)
  void clearEstimatedCredits() => $_clearField(8);
}

class QuickEditServiceSaveDraftResponse extends $pb.GeneratedMessage {
  factory QuickEditServiceSaveDraftResponse({
    QuickEditDraft? draft,
  }) {
    final result = QuickEditServiceSaveDraftResponse._();
    if (draft != null) result.draft = draft;
    return result;
  }

  QuickEditServiceSaveDraftResponse._();

  factory QuickEditServiceSaveDraftResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditServiceSaveDraftResponse()..mergeFromBuffer(data, registry);
  factory QuickEditServiceSaveDraftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickEditServiceSaveDraftResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickEditServiceSaveDraftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: QuickEditServiceSaveDraftResponse.$_createMessage)
    ..aOM<QuickEditDraft>(1, _omitFieldNames ? '' : 'draft',
        subBuilder: QuickEditDraft.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditServiceSaveDraftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickEditServiceSaveDraftResponse copyWith(
          void Function(QuickEditServiceSaveDraftResponse) updates) =>
      super.copyWith((message) =>
              updates(message as QuickEditServiceSaveDraftResponse))
          as QuickEditServiceSaveDraftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use QuickEditServiceSaveDraftResponse() / QuickEditServiceSaveDraftResponse.new instead')
  static QuickEditServiceSaveDraftResponse create() =>
      QuickEditServiceSaveDraftResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      QuickEditServiceSaveDraftResponse._();
  @$core.override
  QuickEditServiceSaveDraftResponse createEmptyInstance() =>
      QuickEditServiceSaveDraftResponse._();
  @$core.pragma('dart2js:noInline')
  static QuickEditServiceSaveDraftResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuickEditServiceSaveDraftResponse>(
          QuickEditServiceSaveDraftResponse.$_createMessage);
  static QuickEditServiceSaveDraftResponse? _defaultInstance;

  @$pb.TagNumber(1)
  QuickEditDraft get draft => $_getN(0);
  @$pb.TagNumber(1)
  set draft(QuickEditDraft value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDraft() => $_has(0);
  @$pb.TagNumber(1)
  void clearDraft() => $_clearField(1);
  @$pb.TagNumber(1)
  QuickEditDraft ensureDraft() => $_ensure(0);
}

class BeatSyncGrid extends $pb.GeneratedMessage {
  factory BeatSyncGrid({
    $core.int? bpm,
    $core.Iterable<$fixnum.Int64>? beatTimestampsMs,
    $core.Iterable<$fixnum.Int64>? downbeatTimestampsMs,
    $core.double? confidence,
  }) {
    final result = BeatSyncGrid._();
    if (bpm != null) result.bpm = bpm;
    if (beatTimestampsMs != null)
      result.beatTimestampsMs.addAll(beatTimestampsMs);
    if (downbeatTimestampsMs != null)
      result.downbeatTimestampsMs.addAll(downbeatTimestampsMs);
    if (confidence != null) result.confidence = confidence;
    return result;
  }

  BeatSyncGrid._();

  factory BeatSyncGrid.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BeatSyncGrid()..mergeFromBuffer(data, registry);
  factory BeatSyncGrid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BeatSyncGrid()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BeatSyncGrid',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: BeatSyncGrid.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'bpm')
    ..p<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'beatTimestampsMs', $pb.PbFieldType.K6)
    ..p<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'downbeatTimestampsMs', $pb.PbFieldType.K6)
    ..aD(4, _omitFieldNames ? '' : 'confidence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BeatSyncGrid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BeatSyncGrid copyWith(void Function(BeatSyncGrid) updates) =>
      super.copyWith((message) => updates(message as BeatSyncGrid))
          as BeatSyncGrid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BeatSyncGrid() / BeatSyncGrid.new instead')
  static BeatSyncGrid create() => BeatSyncGrid._();
  static $pb.GeneratedMessage $_createMessage() => BeatSyncGrid._();
  @$core.override
  BeatSyncGrid createEmptyInstance() => BeatSyncGrid._();
  @$core.pragma('dart2js:noInline')
  static BeatSyncGrid getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BeatSyncGrid>(
          BeatSyncGrid.$_createMessage);
  static BeatSyncGrid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get bpm => $_getIZ(0);
  @$pb.TagNumber(1)
  set bpm($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBpm() => $_has(0);
  @$pb.TagNumber(1)
  void clearBpm() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get beatTimestampsMs => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get downbeatTimestampsMs => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get confidence => $_getN(3);
  @$pb.TagNumber(4)
  set confidence($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConfidence() => $_has(3);
  @$pb.TagNumber(4)
  void clearConfidence() => $_clearField(4);
}

/// TranslationJob represents a multi-language localization job per database_schema.md §22.6.
class TranslationJob extends $pb.GeneratedMessage {
  factory TranslationJob({
    $core.String? translationJobId,
    $core.String? workspaceId,
    $core.String? videoEditJobId,
    $core.String? sourceAssetId,
    $core.Iterable<$core.String>? targetLanguages,
    $core.bool? lipSyncEnabled,
    $core.bool? culturalAdaptationEnabled,
    $core.bool? translateCaptions,
    $core.bool? translateOverlays,
    $core.String? voiceOption,
    $core.String? voiceCloneId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        perLanguageStatus,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? outputAssetIds,
    $core.String? totalCreditsUsed,
    $core.String? status,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? qualityScores,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? repairNotes,
    $core.String? quoteId,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = TranslationJob._();
    if (translationJobId != null) result.translationJobId = translationJobId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (videoEditJobId != null) result.videoEditJobId = videoEditJobId;
    if (sourceAssetId != null) result.sourceAssetId = sourceAssetId;
    if (targetLanguages != null) result.targetLanguages.addAll(targetLanguages);
    if (lipSyncEnabled != null) result.lipSyncEnabled = lipSyncEnabled;
    if (culturalAdaptationEnabled != null)
      result.culturalAdaptationEnabled = culturalAdaptationEnabled;
    if (translateCaptions != null) result.translateCaptions = translateCaptions;
    if (translateOverlays != null) result.translateOverlays = translateOverlays;
    if (voiceOption != null) result.voiceOption = voiceOption;
    if (voiceCloneId != null) result.voiceCloneId = voiceCloneId;
    if (perLanguageStatus != null)
      result.perLanguageStatus.addEntries(perLanguageStatus);
    if (outputAssetIds != null)
      result.outputAssetIds.addEntries(outputAssetIds);
    if (totalCreditsUsed != null) result.totalCreditsUsed = totalCreditsUsed;
    if (status != null) result.status = status;
    if (qualityScores != null) result.qualityScores.addEntries(qualityScores);
    if (repairNotes != null) result.repairNotes.addEntries(repairNotes);
    if (quoteId != null) result.quoteId = quoteId;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  TranslationJob._();

  factory TranslationJob.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationJob()..mergeFromBuffer(data, registry);
  factory TranslationJob.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationJob()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslationJob',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranslationJob.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'translationJobId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'videoEditJobId')
    ..aOS(4, _omitFieldNames ? '' : 'sourceAssetId')
    ..pPS(5, _omitFieldNames ? '' : 'targetLanguages')
    ..aOB(6, _omitFieldNames ? '' : 'lipSyncEnabled')
    ..aOB(7, _omitFieldNames ? '' : 'culturalAdaptationEnabled')
    ..aOB(8, _omitFieldNames ? '' : 'translateCaptions')
    ..aOB(9, _omitFieldNames ? '' : 'translateOverlays')
    ..aOS(10, _omitFieldNames ? '' : 'voiceOption')
    ..aOS(11, _omitFieldNames ? '' : 'voiceCloneId')
    ..m<$core.String, $core.String>(
        12, _omitFieldNames ? '' : 'perLanguageStatus',
        entryClassName: 'TranslationJob.PerLanguageStatusEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.production.v1'))
    ..m<$core.String, $core.String>(13, _omitFieldNames ? '' : 'outputAssetIds',
        entryClassName: 'TranslationJob.OutputAssetIdsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.production.v1'))
    ..aOS(14, _omitFieldNames ? '' : 'totalCreditsUsed')
    ..aOS(15, _omitFieldNames ? '' : 'status')
    ..m<$core.String, $core.double>(16, _omitFieldNames ? '' : 'qualityScores',
        entryClassName: 'TranslationJob.QualityScoresEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('creativanta.production.v1'))
    ..m<$core.String, $core.String>(17, _omitFieldNames ? '' : 'repairNotes',
        entryClassName: 'TranslationJob.RepairNotesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.production.v1'))
    ..aOS(18, _omitFieldNames ? '' : 'quoteId')
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(20, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationJob clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationJob copyWith(void Function(TranslationJob) updates) =>
      super.copyWith((message) => updates(message as TranslationJob))
          as TranslationJob;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TranslationJob() / TranslationJob.new instead')
  static TranslationJob create() => TranslationJob._();
  static $pb.GeneratedMessage $_createMessage() => TranslationJob._();
  @$core.override
  TranslationJob createEmptyInstance() => TranslationJob._();
  @$core.pragma('dart2js:noInline')
  static TranslationJob getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TranslationJob>(
          TranslationJob.$_createMessage);
  static TranslationJob? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get translationJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set translationJobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTranslationJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTranslationJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get videoEditJobId => $_getSZ(2);
  @$pb.TagNumber(3)
  set videoEditJobId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVideoEditJobId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVideoEditJobId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceAssetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceAssetId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceAssetId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get targetLanguages => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get lipSyncEnabled => $_getBF(5);
  @$pb.TagNumber(6)
  set lipSyncEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLipSyncEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearLipSyncEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get culturalAdaptationEnabled => $_getBF(6);
  @$pb.TagNumber(7)
  set culturalAdaptationEnabled($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCulturalAdaptationEnabled() => $_has(6);
  @$pb.TagNumber(7)
  void clearCulturalAdaptationEnabled() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get translateCaptions => $_getBF(7);
  @$pb.TagNumber(8)
  set translateCaptions($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTranslateCaptions() => $_has(7);
  @$pb.TagNumber(8)
  void clearTranslateCaptions() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get translateOverlays => $_getBF(8);
  @$pb.TagNumber(9)
  set translateOverlays($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTranslateOverlays() => $_has(8);
  @$pb.TagNumber(9)
  void clearTranslateOverlays() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get voiceOption => $_getSZ(9);
  @$pb.TagNumber(10)
  set voiceOption($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVoiceOption() => $_has(9);
  @$pb.TagNumber(10)
  void clearVoiceOption() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get voiceCloneId => $_getSZ(10);
  @$pb.TagNumber(11)
  set voiceCloneId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVoiceCloneId() => $_has(10);
  @$pb.TagNumber(11)
  void clearVoiceCloneId() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbMap<$core.String, $core.String> get perLanguageStatus => $_getMap(11);

  @$pb.TagNumber(13)
  $pb.PbMap<$core.String, $core.String> get outputAssetIds => $_getMap(12);

  @$pb.TagNumber(14)
  $core.String get totalCreditsUsed => $_getSZ(13);
  @$pb.TagNumber(14)
  set totalCreditsUsed($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTotalCreditsUsed() => $_has(13);
  @$pb.TagNumber(14)
  void clearTotalCreditsUsed() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get status => $_getSZ(14);
  @$pb.TagNumber(15)
  set status($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasStatus() => $_has(14);
  @$pb.TagNumber(15)
  void clearStatus() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbMap<$core.String, $core.double> get qualityScores => $_getMap(15);

  @$pb.TagNumber(17)
  $pb.PbMap<$core.String, $core.String> get repairNotes => $_getMap(16);

  @$pb.TagNumber(18)
  $core.String get quoteId => $_getSZ(17);
  @$pb.TagNumber(18)
  set quoteId($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasQuoteId() => $_has(17);
  @$pb.TagNumber(18)
  void clearQuoteId() => $_clearField(18);

  @$pb.TagNumber(19)
  $1.Timestamp get createdAt => $_getN(18);
  @$pb.TagNumber(19)
  set createdAt($1.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasCreatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearCreatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $1.Timestamp ensureCreatedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $1.Timestamp get updatedAt => $_getN(19);
  @$pb.TagNumber(20)
  set updatedAt($1.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasUpdatedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearUpdatedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $1.Timestamp ensureUpdatedAt() => $_ensure(19);
}

/// TranslationSegment represents a timecoded speech segment with quality scoring and repair state.
class TranslationSegment extends $pb.GeneratedMessage {
  factory TranslationSegment({
    $core.String? segmentId,
    $core.double? startTimeS,
    $core.double? endTimeS,
    $core.String? sourceText,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? translations,
    $core.double? qualityScore,
    $core.bool? needsRepair,
    $core.String? repairReason,
  }) {
    final result = TranslationSegment._();
    if (segmentId != null) result.segmentId = segmentId;
    if (startTimeS != null) result.startTimeS = startTimeS;
    if (endTimeS != null) result.endTimeS = endTimeS;
    if (sourceText != null) result.sourceText = sourceText;
    if (translations != null) result.translations.addEntries(translations);
    if (qualityScore != null) result.qualityScore = qualityScore;
    if (needsRepair != null) result.needsRepair = needsRepair;
    if (repairReason != null) result.repairReason = repairReason;
    return result;
  }

  TranslationSegment._();

  factory TranslationSegment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationSegment()..mergeFromBuffer(data, registry);
  factory TranslationSegment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationSegment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslationSegment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranslationSegment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'segmentId')
    ..aD(2, _omitFieldNames ? '' : 'startTimeS')
    ..aD(3, _omitFieldNames ? '' : 'endTimeS')
    ..aOS(4, _omitFieldNames ? '' : 'sourceText')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'translations',
        entryClassName: 'TranslationSegment.TranslationsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.production.v1'))
    ..aD(6, _omitFieldNames ? '' : 'qualityScore')
    ..aOB(7, _omitFieldNames ? '' : 'needsRepair')
    ..aOS(8, _omitFieldNames ? '' : 'repairReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationSegment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationSegment copyWith(void Function(TranslationSegment) updates) =>
      super.copyWith((message) => updates(message as TranslationSegment))
          as TranslationSegment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TranslationSegment() / TranslationSegment.new instead')
  static TranslationSegment create() => TranslationSegment._();
  static $pb.GeneratedMessage $_createMessage() => TranslationSegment._();
  @$core.override
  TranslationSegment createEmptyInstance() => TranslationSegment._();
  @$core.pragma('dart2js:noInline')
  static TranslationSegment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslationSegment>(
          TranslationSegment.$_createMessage);
  static TranslationSegment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get segmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set segmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSegmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSegmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get startTimeS => $_getN(1);
  @$pb.TagNumber(2)
  set startTimeS($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartTimeS() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTimeS() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get endTimeS => $_getN(2);
  @$pb.TagNumber(3)
  set endTimeS($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndTimeS() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndTimeS() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceText => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceText() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceText() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get translations => $_getMap(4);

  @$pb.TagNumber(6)
  $core.double get qualityScore => $_getN(5);
  @$pb.TagNumber(6)
  set qualityScore($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQualityScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearQualityScore() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get needsRepair => $_getBF(6);
  @$pb.TagNumber(7)
  set needsRepair($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNeedsRepair() => $_has(6);
  @$pb.TagNumber(7)
  void clearNeedsRepair() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get repairReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set repairReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRepairReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearRepairReason() => $_clearField(8);
}

class TranslationServiceCreateRequest extends $pb.GeneratedMessage {
  factory TranslationServiceCreateRequest({
    $2.CommandContext? context,
    $core.String? sourceAssetId,
    $core.Iterable<$core.String>? targetLanguages,
    $core.bool? lipSyncEnabled,
    $core.bool? culturalAdaptationEnabled,
    $core.bool? translateCaptions,
    $core.bool? translateOverlays,
    $core.String? voiceOption,
    $core.String? voiceCloneId,
    $core.String? quoteId,
    $core.String? confirmedCredits,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        customScriptCorrections,
  }) {
    final result = TranslationServiceCreateRequest._();
    if (context != null) result.context = context;
    if (sourceAssetId != null) result.sourceAssetId = sourceAssetId;
    if (targetLanguages != null) result.targetLanguages.addAll(targetLanguages);
    if (lipSyncEnabled != null) result.lipSyncEnabled = lipSyncEnabled;
    if (culturalAdaptationEnabled != null)
      result.culturalAdaptationEnabled = culturalAdaptationEnabled;
    if (translateCaptions != null) result.translateCaptions = translateCaptions;
    if (translateOverlays != null) result.translateOverlays = translateOverlays;
    if (voiceOption != null) result.voiceOption = voiceOption;
    if (voiceCloneId != null) result.voiceCloneId = voiceCloneId;
    if (quoteId != null) result.quoteId = quoteId;
    if (confirmedCredits != null) result.confirmedCredits = confirmedCredits;
    if (customScriptCorrections != null)
      result.customScriptCorrections.addEntries(customScriptCorrections);
    return result;
  }

  TranslationServiceCreateRequest._();

  factory TranslationServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory TranslationServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslationServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranslationServiceCreateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sourceAssetId')
    ..pPS(3, _omitFieldNames ? '' : 'targetLanguages')
    ..aOB(4, _omitFieldNames ? '' : 'lipSyncEnabled')
    ..aOB(5, _omitFieldNames ? '' : 'culturalAdaptationEnabled')
    ..aOB(6, _omitFieldNames ? '' : 'translateCaptions')
    ..aOB(7, _omitFieldNames ? '' : 'translateOverlays')
    ..aOS(8, _omitFieldNames ? '' : 'voiceOption')
    ..aOS(9, _omitFieldNames ? '' : 'voiceCloneId')
    ..aOS(10, _omitFieldNames ? '' : 'quoteId')
    ..aOS(11, _omitFieldNames ? '' : 'confirmedCredits')
    ..m<$core.String, $core.String>(
        12, _omitFieldNames ? '' : 'customScriptCorrections',
        entryClassName:
            'TranslationServiceCreateRequest.CustomScriptCorrectionsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.production.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceCreateRequest copyWith(
          void Function(TranslationServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TranslationServiceCreateRequest))
          as TranslationServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TranslationServiceCreateRequest() / TranslationServiceCreateRequest.new instead')
  static TranslationServiceCreateRequest create() =>
      TranslationServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TranslationServiceCreateRequest._();
  @$core.override
  TranslationServiceCreateRequest createEmptyInstance() =>
      TranslationServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static TranslationServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslationServiceCreateRequest>(
          TranslationServiceCreateRequest.$_createMessage);
  static TranslationServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get sourceAssetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceAssetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get targetLanguages => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get lipSyncEnabled => $_getBF(3);
  @$pb.TagNumber(4)
  set lipSyncEnabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLipSyncEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearLipSyncEnabled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get culturalAdaptationEnabled => $_getBF(4);
  @$pb.TagNumber(5)
  set culturalAdaptationEnabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCulturalAdaptationEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearCulturalAdaptationEnabled() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get translateCaptions => $_getBF(5);
  @$pb.TagNumber(6)
  set translateCaptions($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTranslateCaptions() => $_has(5);
  @$pb.TagNumber(6)
  void clearTranslateCaptions() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get translateOverlays => $_getBF(6);
  @$pb.TagNumber(7)
  set translateOverlays($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTranslateOverlays() => $_has(6);
  @$pb.TagNumber(7)
  void clearTranslateOverlays() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get voiceOption => $_getSZ(7);
  @$pb.TagNumber(8)
  set voiceOption($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVoiceOption() => $_has(7);
  @$pb.TagNumber(8)
  void clearVoiceOption() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get voiceCloneId => $_getSZ(8);
  @$pb.TagNumber(9)
  set voiceCloneId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVoiceCloneId() => $_has(8);
  @$pb.TagNumber(9)
  void clearVoiceCloneId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get quoteId => $_getSZ(9);
  @$pb.TagNumber(10)
  set quoteId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasQuoteId() => $_has(9);
  @$pb.TagNumber(10)
  void clearQuoteId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get confirmedCredits => $_getSZ(10);
  @$pb.TagNumber(11)
  set confirmedCredits($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasConfirmedCredits() => $_has(10);
  @$pb.TagNumber(11)
  void clearConfirmedCredits() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbMap<$core.String, $core.String> get customScriptCorrections =>
      $_getMap(11);
}

class TranslationServiceCreateResponse extends $pb.GeneratedMessage {
  factory TranslationServiceCreateResponse({
    TranslationJob? job,
    $core.String? creditsReserved,
    $core.double? discountAppliedPct,
  }) {
    final result = TranslationServiceCreateResponse._();
    if (job != null) result.job = job;
    if (creditsReserved != null) result.creditsReserved = creditsReserved;
    if (discountAppliedPct != null)
      result.discountAppliedPct = discountAppliedPct;
    return result;
  }

  TranslationServiceCreateResponse._();

  factory TranslationServiceCreateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory TranslationServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslationServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranslationServiceCreateResponse.$_createMessage)
    ..aOM<TranslationJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: TranslationJob.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'creditsReserved')
    ..aD(3, _omitFieldNames ? '' : 'discountAppliedPct')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceCreateResponse copyWith(
          void Function(TranslationServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TranslationServiceCreateResponse))
          as TranslationServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TranslationServiceCreateResponse() / TranslationServiceCreateResponse.new instead')
  static TranslationServiceCreateResponse create() =>
      TranslationServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TranslationServiceCreateResponse._();
  @$core.override
  TranslationServiceCreateResponse createEmptyInstance() =>
      TranslationServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static TranslationServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslationServiceCreateResponse>(
          TranslationServiceCreateResponse.$_createMessage);
  static TranslationServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TranslationJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(TranslationJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  TranslationJob ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get creditsReserved => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsReserved($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsReserved() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsReserved() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get discountAppliedPct => $_getN(2);
  @$pb.TagNumber(3)
  set discountAppliedPct($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscountAppliedPct() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscountAppliedPct() => $_clearField(3);
}

class TranslationServiceGetRequest extends $pb.GeneratedMessage {
  factory TranslationServiceGetRequest({
    $2.UUID? workspaceId,
    $core.String? translationJobId,
  }) {
    final result = TranslationServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (translationJobId != null) result.translationJobId = translationJobId;
    return result;
  }

  TranslationServiceGetRequest._();

  factory TranslationServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceGetRequest()..mergeFromBuffer(data, registry);
  factory TranslationServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslationServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranslationServiceGetRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'translationJobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceGetRequest copyWith(
          void Function(TranslationServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TranslationServiceGetRequest))
          as TranslationServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TranslationServiceGetRequest() / TranslationServiceGetRequest.new instead')
  static TranslationServiceGetRequest create() =>
      TranslationServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TranslationServiceGetRequest._();
  @$core.override
  TranslationServiceGetRequest createEmptyInstance() =>
      TranslationServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static TranslationServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslationServiceGetRequest>(
          TranslationServiceGetRequest.$_createMessage);
  static TranslationServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get translationJobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set translationJobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTranslationJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTranslationJobId() => $_clearField(2);
}

class TranslationServiceGetResponse extends $pb.GeneratedMessage {
  factory TranslationServiceGetResponse({
    TranslationJob? job,
    $core.Iterable<Asset>? outputAssets,
    $core.Iterable<TranslationSegment>? segments,
  }) {
    final result = TranslationServiceGetResponse._();
    if (job != null) result.job = job;
    if (outputAssets != null) result.outputAssets.addAll(outputAssets);
    if (segments != null) result.segments.addAll(segments);
    return result;
  }

  TranslationServiceGetResponse._();

  factory TranslationServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceGetResponse()..mergeFromBuffer(data, registry);
  factory TranslationServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslationServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranslationServiceGetResponse.$_createMessage)
    ..aOM<TranslationJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: TranslationJob.$_createMessage)
    ..pPM<Asset>(2, _omitFieldNames ? '' : 'outputAssets',
        subBuilder: Asset.$_createMessage)
    ..pPM<TranslationSegment>(3, _omitFieldNames ? '' : 'segments',
        subBuilder: TranslationSegment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceGetResponse copyWith(
          void Function(TranslationServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TranslationServiceGetResponse))
          as TranslationServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TranslationServiceGetResponse() / TranslationServiceGetResponse.new instead')
  static TranslationServiceGetResponse create() =>
      TranslationServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TranslationServiceGetResponse._();
  @$core.override
  TranslationServiceGetResponse createEmptyInstance() =>
      TranslationServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static TranslationServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslationServiceGetResponse>(
          TranslationServiceGetResponse.$_createMessage);
  static TranslationServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TranslationJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(TranslationJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  TranslationJob ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Asset> get outputAssets => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<TranslationSegment> get segments => $_getList(2);
}

class TranslationServiceListRequest extends $pb.GeneratedMessage {
  factory TranslationServiceListRequest({
    $2.UUID? workspaceId,
    $2.Pagination? pagination,
  }) {
    final result = TranslationServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  TranslationServiceListRequest._();

  factory TranslationServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceListRequest()..mergeFromBuffer(data, registry);
  factory TranslationServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslationServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranslationServiceListRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceListRequest copyWith(
          void Function(TranslationServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TranslationServiceListRequest))
          as TranslationServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TranslationServiceListRequest() / TranslationServiceListRequest.new instead')
  static TranslationServiceListRequest create() =>
      TranslationServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TranslationServiceListRequest._();
  @$core.override
  TranslationServiceListRequest createEmptyInstance() =>
      TranslationServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static TranslationServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslationServiceListRequest>(
          TranslationServiceListRequest.$_createMessage);
  static TranslationServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);
}

class TranslationServiceListResponse extends $pb.GeneratedMessage {
  factory TranslationServiceListResponse({
    $core.Iterable<TranslationJob>? jobs,
    $2.PaginatedResponse? pagination,
  }) {
    final result = TranslationServiceListResponse._();
    if (jobs != null) result.jobs.addAll(jobs);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  TranslationServiceListResponse._();

  factory TranslationServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceListResponse()..mergeFromBuffer(data, registry);
  factory TranslationServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TranslationServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslationServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: TranslationServiceListResponse.$_createMessage)
    ..pPM<TranslationJob>(1, _omitFieldNames ? '' : 'jobs',
        subBuilder: TranslationJob.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslationServiceListResponse copyWith(
          void Function(TranslationServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TranslationServiceListResponse))
          as TranslationServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TranslationServiceListResponse() / TranslationServiceListResponse.new instead')
  static TranslationServiceListResponse create() =>
      TranslationServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TranslationServiceListResponse._();
  @$core.override
  TranslationServiceListResponse createEmptyInstance() =>
      TranslationServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static TranslationServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslationServiceListResponse>(
          TranslationServiceListResponse.$_createMessage);
  static TranslationServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TranslationJob> get jobs => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

/// SoundTrack represents an audio or sound design asset with verified licensing metadata.
class SoundTrack extends $pb.GeneratedMessage {
  factory SoundTrack({
    $core.String? trackId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? category,
    $core.String? genre,
    $core.String? mood,
    $core.int? bpm,
    $core.double? durationSeconds,
    $core.String? fileUrl,
    $core.String? licenseType,
    $core.String? licenseId,
    $core.bool? isVerifiedLicense,
    $core.Iterable<$core.double>? waveformPeaks,
    $1.Timestamp? createdAt,
  }) {
    final result = SoundTrack._();
    if (trackId != null) result.trackId = trackId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (category != null) result.category = category;
    if (genre != null) result.genre = genre;
    if (mood != null) result.mood = mood;
    if (bpm != null) result.bpm = bpm;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (fileUrl != null) result.fileUrl = fileUrl;
    if (licenseType != null) result.licenseType = licenseType;
    if (licenseId != null) result.licenseId = licenseId;
    if (isVerifiedLicense != null) result.isVerifiedLicense = isVerifiedLicense;
    if (waveformPeaks != null) result.waveformPeaks.addAll(waveformPeaks);
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  SoundTrack._();

  factory SoundTrack.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundTrack()..mergeFromBuffer(data, registry);
  factory SoundTrack.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundTrack()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundTrack',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: SoundTrack.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'trackId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'category')
    ..aOS(5, _omitFieldNames ? '' : 'genre')
    ..aOS(6, _omitFieldNames ? '' : 'mood')
    ..aI(7, _omitFieldNames ? '' : 'bpm')
    ..aD(8, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(9, _omitFieldNames ? '' : 'fileUrl')
    ..aOS(10, _omitFieldNames ? '' : 'licenseType')
    ..aOS(11, _omitFieldNames ? '' : 'licenseId')
    ..aOB(12, _omitFieldNames ? '' : 'isVerifiedLicense')
    ..p<$core.double>(
        13, _omitFieldNames ? '' : 'waveformPeaks', $pb.PbFieldType.KF)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundTrack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundTrack copyWith(void Function(SoundTrack) updates) =>
      super.copyWith((message) => updates(message as SoundTrack)) as SoundTrack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SoundTrack() / SoundTrack.new instead')
  static SoundTrack create() => SoundTrack._();
  static $pb.GeneratedMessage $_createMessage() => SoundTrack._();
  @$core.override
  SoundTrack createEmptyInstance() => SoundTrack._();
  @$core.pragma('dart2js:noInline')
  static SoundTrack getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SoundTrack>(SoundTrack.$_createMessage);
  static SoundTrack? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get category => $_getSZ(3);
  @$pb.TagNumber(4)
  set category($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get genre => $_getSZ(4);
  @$pb.TagNumber(5)
  set genre($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGenre() => $_has(4);
  @$pb.TagNumber(5)
  void clearGenre() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get mood => $_getSZ(5);
  @$pb.TagNumber(6)
  set mood($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMood() => $_has(5);
  @$pb.TagNumber(6)
  void clearMood() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get bpm => $_getIZ(6);
  @$pb.TagNumber(7)
  set bpm($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBpm() => $_has(6);
  @$pb.TagNumber(7)
  void clearBpm() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get durationSeconds => $_getN(7);
  @$pb.TagNumber(8)
  set durationSeconds($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get fileUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set fileUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFileUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearFileUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get licenseType => $_getSZ(9);
  @$pb.TagNumber(10)
  set licenseType($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLicenseType() => $_has(9);
  @$pb.TagNumber(10)
  void clearLicenseType() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get licenseId => $_getSZ(10);
  @$pb.TagNumber(11)
  set licenseId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLicenseId() => $_has(10);
  @$pb.TagNumber(11)
  void clearLicenseId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get isVerifiedLicense => $_getBF(11);
  @$pb.TagNumber(12)
  set isVerifiedLicense($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIsVerifiedLicense() => $_has(11);
  @$pb.TagNumber(12)
  void clearIsVerifiedLicense() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$core.double> get waveformPeaks => $_getList(12);

  @$pb.TagNumber(14)
  $1.Timestamp get createdAt => $_getN(13);
  @$pb.TagNumber(14)
  set createdAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureCreatedAt() => $_ensure(13);
}

class SoundStudioServiceGenerateMusicRequest extends $pb.GeneratedMessage {
  factory SoundStudioServiceGenerateMusicRequest({
    $2.CommandContext? context,
    $core.String? prompt,
    $core.String? genre,
    $core.String? mood,
    $core.int? bpm,
    $core.int? durationSeconds,
    $core.String? licenseType,
    $core.String? quoteId,
    $core.String? confirmedCredits,
  }) {
    final result = SoundStudioServiceGenerateMusicRequest._();
    if (context != null) result.context = context;
    if (prompt != null) result.prompt = prompt;
    if (genre != null) result.genre = genre;
    if (mood != null) result.mood = mood;
    if (bpm != null) result.bpm = bpm;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (licenseType != null) result.licenseType = licenseType;
    if (quoteId != null) result.quoteId = quoteId;
    if (confirmedCredits != null) result.confirmedCredits = confirmedCredits;
    return result;
  }

  SoundStudioServiceGenerateMusicRequest._();

  factory SoundStudioServiceGenerateMusicRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGenerateMusicRequest()..mergeFromBuffer(data, registry);
  factory SoundStudioServiceGenerateMusicRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGenerateMusicRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceGenerateMusicRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          SoundStudioServiceGenerateMusicRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..aOS(3, _omitFieldNames ? '' : 'genre')
    ..aOS(4, _omitFieldNames ? '' : 'mood')
    ..aI(5, _omitFieldNames ? '' : 'bpm')
    ..aI(6, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(7, _omitFieldNames ? '' : 'licenseType')
    ..aOS(8, _omitFieldNames ? '' : 'quoteId')
    ..aOS(9, _omitFieldNames ? '' : 'confirmedCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGenerateMusicRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGenerateMusicRequest copyWith(
          void Function(SoundStudioServiceGenerateMusicRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceGenerateMusicRequest))
          as SoundStudioServiceGenerateMusicRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceGenerateMusicRequest() / SoundStudioServiceGenerateMusicRequest.new instead')
  static SoundStudioServiceGenerateMusicRequest create() =>
      SoundStudioServiceGenerateMusicRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceGenerateMusicRequest._();
  @$core.override
  SoundStudioServiceGenerateMusicRequest createEmptyInstance() =>
      SoundStudioServiceGenerateMusicRequest._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceGenerateMusicRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServiceGenerateMusicRequest>(
          SoundStudioServiceGenerateMusicRequest.$_createMessage);
  static SoundStudioServiceGenerateMusicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get genre => $_getSZ(2);
  @$pb.TagNumber(3)
  set genre($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGenre() => $_has(2);
  @$pb.TagNumber(3)
  void clearGenre() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get mood => $_getSZ(3);
  @$pb.TagNumber(4)
  set mood($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMood() => $_has(3);
  @$pb.TagNumber(4)
  void clearMood() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get bpm => $_getIZ(4);
  @$pb.TagNumber(5)
  set bpm($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBpm() => $_has(4);
  @$pb.TagNumber(5)
  void clearBpm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get durationSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set durationSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDurationSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearDurationSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get licenseType => $_getSZ(6);
  @$pb.TagNumber(7)
  set licenseType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLicenseType() => $_has(6);
  @$pb.TagNumber(7)
  void clearLicenseType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get quoteId => $_getSZ(7);
  @$pb.TagNumber(8)
  set quoteId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasQuoteId() => $_has(7);
  @$pb.TagNumber(8)
  void clearQuoteId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get confirmedCredits => $_getSZ(8);
  @$pb.TagNumber(9)
  set confirmedCredits($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConfirmedCredits() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfirmedCredits() => $_clearField(9);
}

class SoundStudioServiceGenerateMusicResponse extends $pb.GeneratedMessage {
  factory SoundStudioServiceGenerateMusicResponse({
    SoundTrack? track,
    Asset? asset,
    $core.String? creditsDeducted,
  }) {
    final result = SoundStudioServiceGenerateMusicResponse._();
    if (track != null) result.track = track;
    if (asset != null) result.asset = asset;
    if (creditsDeducted != null) result.creditsDeducted = creditsDeducted;
    return result;
  }

  SoundStudioServiceGenerateMusicResponse._();

  factory SoundStudioServiceGenerateMusicResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGenerateMusicResponse()
        ..mergeFromBuffer(data, registry);
  factory SoundStudioServiceGenerateMusicResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGenerateMusicResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceGenerateMusicResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          SoundStudioServiceGenerateMusicResponse.$_createMessage)
    ..aOM<SoundTrack>(1, _omitFieldNames ? '' : 'track',
        subBuilder: SoundTrack.$_createMessage)
    ..aOM<Asset>(2, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'creditsDeducted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGenerateMusicResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGenerateMusicResponse copyWith(
          void Function(SoundStudioServiceGenerateMusicResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceGenerateMusicResponse))
          as SoundStudioServiceGenerateMusicResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceGenerateMusicResponse() / SoundStudioServiceGenerateMusicResponse.new instead')
  static SoundStudioServiceGenerateMusicResponse create() =>
      SoundStudioServiceGenerateMusicResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceGenerateMusicResponse._();
  @$core.override
  SoundStudioServiceGenerateMusicResponse createEmptyInstance() =>
      SoundStudioServiceGenerateMusicResponse._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceGenerateMusicResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServiceGenerateMusicResponse>(
          SoundStudioServiceGenerateMusicResponse.$_createMessage);
  static SoundStudioServiceGenerateMusicResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SoundTrack get track => $_getN(0);
  @$pb.TagNumber(1)
  set track(SoundTrack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrack() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrack() => $_clearField(1);
  @$pb.TagNumber(1)
  SoundTrack ensureTrack() => $_ensure(0);

  @$pb.TagNumber(2)
  Asset get asset => $_getN(1);
  @$pb.TagNumber(2)
  set asset(Asset value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsset() => $_clearField(2);
  @$pb.TagNumber(2)
  Asset ensureAsset() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get creditsDeducted => $_getSZ(2);
  @$pb.TagNumber(3)
  set creditsDeducted($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreditsDeducted() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreditsDeducted() => $_clearField(3);
}

class SoundStudioServiceGenerateSFXRequest extends $pb.GeneratedMessage {
  factory SoundStudioServiceGenerateSFXRequest({
    $2.CommandContext? context,
    $core.String? prompt,
    $core.String? category,
    $core.double? durationSeconds,
    $core.String? quoteId,
    $core.String? confirmedCredits,
  }) {
    final result = SoundStudioServiceGenerateSFXRequest._();
    if (context != null) result.context = context;
    if (prompt != null) result.prompt = prompt;
    if (category != null) result.category = category;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (quoteId != null) result.quoteId = quoteId;
    if (confirmedCredits != null) result.confirmedCredits = confirmedCredits;
    return result;
  }

  SoundStudioServiceGenerateSFXRequest._();

  factory SoundStudioServiceGenerateSFXRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGenerateSFXRequest()..mergeFromBuffer(data, registry);
  factory SoundStudioServiceGenerateSFXRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGenerateSFXRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceGenerateSFXRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: SoundStudioServiceGenerateSFXRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..aD(4, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(5, _omitFieldNames ? '' : 'quoteId')
    ..aOS(6, _omitFieldNames ? '' : 'confirmedCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGenerateSFXRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGenerateSFXRequest copyWith(
          void Function(SoundStudioServiceGenerateSFXRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceGenerateSFXRequest))
          as SoundStudioServiceGenerateSFXRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceGenerateSFXRequest() / SoundStudioServiceGenerateSFXRequest.new instead')
  static SoundStudioServiceGenerateSFXRequest create() =>
      SoundStudioServiceGenerateSFXRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceGenerateSFXRequest._();
  @$core.override
  SoundStudioServiceGenerateSFXRequest createEmptyInstance() =>
      SoundStudioServiceGenerateSFXRequest._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceGenerateSFXRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServiceGenerateSFXRequest>(
          SoundStudioServiceGenerateSFXRequest.$_createMessage);
  static SoundStudioServiceGenerateSFXRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get durationSeconds => $_getN(3);
  @$pb.TagNumber(4)
  set durationSeconds($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDurationSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearDurationSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get quoteId => $_getSZ(4);
  @$pb.TagNumber(5)
  set quoteId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuoteId() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuoteId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get confirmedCredits => $_getSZ(5);
  @$pb.TagNumber(6)
  set confirmedCredits($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConfirmedCredits() => $_has(5);
  @$pb.TagNumber(6)
  void clearConfirmedCredits() => $_clearField(6);
}

class SoundStudioServiceGenerateSFXResponse extends $pb.GeneratedMessage {
  factory SoundStudioServiceGenerateSFXResponse({
    SoundTrack? track,
    Asset? asset,
    $core.String? creditsDeducted,
  }) {
    final result = SoundStudioServiceGenerateSFXResponse._();
    if (track != null) result.track = track;
    if (asset != null) result.asset = asset;
    if (creditsDeducted != null) result.creditsDeducted = creditsDeducted;
    return result;
  }

  SoundStudioServiceGenerateSFXResponse._();

  factory SoundStudioServiceGenerateSFXResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGenerateSFXResponse()..mergeFromBuffer(data, registry);
  factory SoundStudioServiceGenerateSFXResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGenerateSFXResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceGenerateSFXResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          SoundStudioServiceGenerateSFXResponse.$_createMessage)
    ..aOM<SoundTrack>(1, _omitFieldNames ? '' : 'track',
        subBuilder: SoundTrack.$_createMessage)
    ..aOM<Asset>(2, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'creditsDeducted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGenerateSFXResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGenerateSFXResponse copyWith(
          void Function(SoundStudioServiceGenerateSFXResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceGenerateSFXResponse))
          as SoundStudioServiceGenerateSFXResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceGenerateSFXResponse() / SoundStudioServiceGenerateSFXResponse.new instead')
  static SoundStudioServiceGenerateSFXResponse create() =>
      SoundStudioServiceGenerateSFXResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceGenerateSFXResponse._();
  @$core.override
  SoundStudioServiceGenerateSFXResponse createEmptyInstance() =>
      SoundStudioServiceGenerateSFXResponse._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceGenerateSFXResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServiceGenerateSFXResponse>(
          SoundStudioServiceGenerateSFXResponse.$_createMessage);
  static SoundStudioServiceGenerateSFXResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SoundTrack get track => $_getN(0);
  @$pb.TagNumber(1)
  set track(SoundTrack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrack() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrack() => $_clearField(1);
  @$pb.TagNumber(1)
  SoundTrack ensureTrack() => $_ensure(0);

  @$pb.TagNumber(2)
  Asset get asset => $_getN(1);
  @$pb.TagNumber(2)
  set asset(Asset value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsset() => $_clearField(2);
  @$pb.TagNumber(2)
  Asset ensureAsset() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get creditsDeducted => $_getSZ(2);
  @$pb.TagNumber(3)
  set creditsDeducted($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreditsDeducted() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreditsDeducted() => $_clearField(3);
}

class SoundStudioServiceAnalyzeBeatRequest extends $pb.GeneratedMessage {
  factory SoundStudioServiceAnalyzeBeatRequest({
    $2.UUID? workspaceId,
    $core.String? audioAssetId,
    $core.String? audioUrl,
  }) {
    final result = SoundStudioServiceAnalyzeBeatRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (audioAssetId != null) result.audioAssetId = audioAssetId;
    if (audioUrl != null) result.audioUrl = audioUrl;
    return result;
  }

  SoundStudioServiceAnalyzeBeatRequest._();

  factory SoundStudioServiceAnalyzeBeatRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceAnalyzeBeatRequest()..mergeFromBuffer(data, registry);
  factory SoundStudioServiceAnalyzeBeatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceAnalyzeBeatRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceAnalyzeBeatRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: SoundStudioServiceAnalyzeBeatRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'audioAssetId')
    ..aOS(3, _omitFieldNames ? '' : 'audioUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceAnalyzeBeatRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceAnalyzeBeatRequest copyWith(
          void Function(SoundStudioServiceAnalyzeBeatRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceAnalyzeBeatRequest))
          as SoundStudioServiceAnalyzeBeatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceAnalyzeBeatRequest() / SoundStudioServiceAnalyzeBeatRequest.new instead')
  static SoundStudioServiceAnalyzeBeatRequest create() =>
      SoundStudioServiceAnalyzeBeatRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceAnalyzeBeatRequest._();
  @$core.override
  SoundStudioServiceAnalyzeBeatRequest createEmptyInstance() =>
      SoundStudioServiceAnalyzeBeatRequest._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceAnalyzeBeatRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServiceAnalyzeBeatRequest>(
          SoundStudioServiceAnalyzeBeatRequest.$_createMessage);
  static SoundStudioServiceAnalyzeBeatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get audioAssetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set audioAssetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAudioAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAudioAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get audioUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set audioUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAudioUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearAudioUrl() => $_clearField(3);
}

class SoundStudioServiceAnalyzeBeatResponse extends $pb.GeneratedMessage {
  factory SoundStudioServiceAnalyzeBeatResponse({
    $core.double? bpm,
    $core.Iterable<$fixnum.Int64>? beatTimestampsMs,
    $core.Iterable<$fixnum.Int64>? downbeatTimestampsMs,
    $core.double? tempoConfidence,
    $core.Iterable<$fixnum.Int64>? suggestedCutPointsMs,
  }) {
    final result = SoundStudioServiceAnalyzeBeatResponse._();
    if (bpm != null) result.bpm = bpm;
    if (beatTimestampsMs != null)
      result.beatTimestampsMs.addAll(beatTimestampsMs);
    if (downbeatTimestampsMs != null)
      result.downbeatTimestampsMs.addAll(downbeatTimestampsMs);
    if (tempoConfidence != null) result.tempoConfidence = tempoConfidence;
    if (suggestedCutPointsMs != null)
      result.suggestedCutPointsMs.addAll(suggestedCutPointsMs);
    return result;
  }

  SoundStudioServiceAnalyzeBeatResponse._();

  factory SoundStudioServiceAnalyzeBeatResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceAnalyzeBeatResponse()..mergeFromBuffer(data, registry);
  factory SoundStudioServiceAnalyzeBeatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceAnalyzeBeatResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceAnalyzeBeatResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          SoundStudioServiceAnalyzeBeatResponse.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'bpm')
    ..p<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'beatTimestampsMs', $pb.PbFieldType.K6)
    ..p<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'downbeatTimestampsMs', $pb.PbFieldType.K6)
    ..aD(4, _omitFieldNames ? '' : 'tempoConfidence')
    ..p<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'suggestedCutPointsMs', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceAnalyzeBeatResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceAnalyzeBeatResponse copyWith(
          void Function(SoundStudioServiceAnalyzeBeatResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceAnalyzeBeatResponse))
          as SoundStudioServiceAnalyzeBeatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceAnalyzeBeatResponse() / SoundStudioServiceAnalyzeBeatResponse.new instead')
  static SoundStudioServiceAnalyzeBeatResponse create() =>
      SoundStudioServiceAnalyzeBeatResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceAnalyzeBeatResponse._();
  @$core.override
  SoundStudioServiceAnalyzeBeatResponse createEmptyInstance() =>
      SoundStudioServiceAnalyzeBeatResponse._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceAnalyzeBeatResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServiceAnalyzeBeatResponse>(
          SoundStudioServiceAnalyzeBeatResponse.$_createMessage);
  static SoundStudioServiceAnalyzeBeatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get bpm => $_getN(0);
  @$pb.TagNumber(1)
  set bpm($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBpm() => $_has(0);
  @$pb.TagNumber(1)
  void clearBpm() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get beatTimestampsMs => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get downbeatTimestampsMs => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get tempoConfidence => $_getN(3);
  @$pb.TagNumber(4)
  set tempoConfidence($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTempoConfidence() => $_has(3);
  @$pb.TagNumber(4)
  void clearTempoConfidence() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$fixnum.Int64> get suggestedCutPointsMs => $_getList(4);
}

class SoundStudioServiceListSoundLibraryRequest extends $pb.GeneratedMessage {
  factory SoundStudioServiceListSoundLibraryRequest({
    $2.UUID? workspaceId,
    $core.String? category,
    $core.String? genre,
    $core.String? mood,
    $2.Pagination? pagination,
  }) {
    final result = SoundStudioServiceListSoundLibraryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (category != null) result.category = category;
    if (genre != null) result.genre = genre;
    if (mood != null) result.mood = mood;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SoundStudioServiceListSoundLibraryRequest._();

  factory SoundStudioServiceListSoundLibraryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceListSoundLibraryRequest()
        ..mergeFromBuffer(data, registry);
  factory SoundStudioServiceListSoundLibraryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceListSoundLibraryRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceListSoundLibraryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          SoundStudioServiceListSoundLibraryRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..aOS(3, _omitFieldNames ? '' : 'genre')
    ..aOS(4, _omitFieldNames ? '' : 'mood')
    ..aOM<$2.Pagination>(5, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceListSoundLibraryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceListSoundLibraryRequest copyWith(
          void Function(SoundStudioServiceListSoundLibraryRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceListSoundLibraryRequest))
          as SoundStudioServiceListSoundLibraryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceListSoundLibraryRequest() / SoundStudioServiceListSoundLibraryRequest.new instead')
  static SoundStudioServiceListSoundLibraryRequest create() =>
      SoundStudioServiceListSoundLibraryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceListSoundLibraryRequest._();
  @$core.override
  SoundStudioServiceListSoundLibraryRequest createEmptyInstance() =>
      SoundStudioServiceListSoundLibraryRequest._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceListSoundLibraryRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServiceListSoundLibraryRequest>(
          SoundStudioServiceListSoundLibraryRequest.$_createMessage);
  static SoundStudioServiceListSoundLibraryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get category => $_getSZ(1);
  @$pb.TagNumber(2)
  set category($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get genre => $_getSZ(2);
  @$pb.TagNumber(3)
  set genre($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGenre() => $_has(2);
  @$pb.TagNumber(3)
  void clearGenre() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get mood => $_getSZ(3);
  @$pb.TagNumber(4)
  set mood($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMood() => $_has(3);
  @$pb.TagNumber(4)
  void clearMood() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Pagination get pagination => $_getN(4);
  @$pb.TagNumber(5)
  set pagination($2.Pagination value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPagination() => $_has(4);
  @$pb.TagNumber(5)
  void clearPagination() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Pagination ensurePagination() => $_ensure(4);
}

class SoundStudioServiceListSoundLibraryResponse extends $pb.GeneratedMessage {
  factory SoundStudioServiceListSoundLibraryResponse({
    $core.Iterable<SoundTrack>? tracks,
    $2.PaginatedResponse? pagination,
  }) {
    final result = SoundStudioServiceListSoundLibraryResponse._();
    if (tracks != null) result.tracks.addAll(tracks);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SoundStudioServiceListSoundLibraryResponse._();

  factory SoundStudioServiceListSoundLibraryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceListSoundLibraryResponse()
        ..mergeFromBuffer(data, registry);
  factory SoundStudioServiceListSoundLibraryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceListSoundLibraryResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceListSoundLibraryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          SoundStudioServiceListSoundLibraryResponse.$_createMessage)
    ..pPM<SoundTrack>(1, _omitFieldNames ? '' : 'tracks',
        subBuilder: SoundTrack.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceListSoundLibraryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceListSoundLibraryResponse copyWith(
          void Function(SoundStudioServiceListSoundLibraryResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceListSoundLibraryResponse))
          as SoundStudioServiceListSoundLibraryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceListSoundLibraryResponse() / SoundStudioServiceListSoundLibraryResponse.new instead')
  static SoundStudioServiceListSoundLibraryResponse create() =>
      SoundStudioServiceListSoundLibraryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceListSoundLibraryResponse._();
  @$core.override
  SoundStudioServiceListSoundLibraryResponse createEmptyInstance() =>
      SoundStudioServiceListSoundLibraryResponse._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceListSoundLibraryResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServiceListSoundLibraryResponse>(
          SoundStudioServiceListSoundLibraryResponse.$_createMessage);
  static SoundStudioServiceListSoundLibraryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SoundTrack> get tracks => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class SoundStudioServiceGetSoundRequest extends $pb.GeneratedMessage {
  factory SoundStudioServiceGetSoundRequest({
    $2.UUID? workspaceId,
    $core.String? assetId,
  }) {
    final result = SoundStudioServiceGetSoundRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  SoundStudioServiceGetSoundRequest._();

  factory SoundStudioServiceGetSoundRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGetSoundRequest()..mergeFromBuffer(data, registry);
  factory SoundStudioServiceGetSoundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGetSoundRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceGetSoundRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: SoundStudioServiceGetSoundRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGetSoundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGetSoundRequest copyWith(
          void Function(SoundStudioServiceGetSoundRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceGetSoundRequest))
          as SoundStudioServiceGetSoundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceGetSoundRequest() / SoundStudioServiceGetSoundRequest.new instead')
  static SoundStudioServiceGetSoundRequest create() =>
      SoundStudioServiceGetSoundRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceGetSoundRequest._();
  @$core.override
  SoundStudioServiceGetSoundRequest createEmptyInstance() =>
      SoundStudioServiceGetSoundRequest._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceGetSoundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SoundStudioServiceGetSoundRequest>(
          SoundStudioServiceGetSoundRequest.$_createMessage);
  static SoundStudioServiceGetSoundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);
}

class SoundStudioServiceGetSoundResponse extends $pb.GeneratedMessage {
  factory SoundStudioServiceGetSoundResponse({
    SoundTrack? track,
  }) {
    final result = SoundStudioServiceGetSoundResponse._();
    if (track != null) result.track = track;
    return result;
  }

  SoundStudioServiceGetSoundResponse._();

  factory SoundStudioServiceGetSoundResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGetSoundResponse()..mergeFromBuffer(data, registry);
  factory SoundStudioServiceGetSoundResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServiceGetSoundResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServiceGetSoundResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: SoundStudioServiceGetSoundResponse.$_createMessage)
    ..aOM<SoundTrack>(1, _omitFieldNames ? '' : 'track',
        subBuilder: SoundTrack.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGetSoundResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServiceGetSoundResponse copyWith(
          void Function(SoundStudioServiceGetSoundResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServiceGetSoundResponse))
          as SoundStudioServiceGetSoundResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServiceGetSoundResponse() / SoundStudioServiceGetSoundResponse.new instead')
  static SoundStudioServiceGetSoundResponse create() =>
      SoundStudioServiceGetSoundResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServiceGetSoundResponse._();
  @$core.override
  SoundStudioServiceGetSoundResponse createEmptyInstance() =>
      SoundStudioServiceGetSoundResponse._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServiceGetSoundResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SoundStudioServiceGetSoundResponse>(
          SoundStudioServiceGetSoundResponse.$_createMessage);
  static SoundStudioServiceGetSoundResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SoundTrack get track => $_getN(0);
  @$pb.TagNumber(1)
  set track(SoundTrack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrack() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrack() => $_clearField(1);
  @$pb.TagNumber(1)
  SoundTrack ensureTrack() => $_ensure(0);
}

class SoundStudioServicePreviewSoundRequest extends $pb.GeneratedMessage {
  factory SoundStudioServicePreviewSoundRequest({
    $2.UUID? workspaceId,
    $core.String? trackId,
    $core.int? previewStartMs,
    $core.int? previewDurationMs,
  }) {
    final result = SoundStudioServicePreviewSoundRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trackId != null) result.trackId = trackId;
    if (previewStartMs != null) result.previewStartMs = previewStartMs;
    if (previewDurationMs != null) result.previewDurationMs = previewDurationMs;
    return result;
  }

  SoundStudioServicePreviewSoundRequest._();

  factory SoundStudioServicePreviewSoundRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServicePreviewSoundRequest()..mergeFromBuffer(data, registry);
  factory SoundStudioServicePreviewSoundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServicePreviewSoundRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServicePreviewSoundRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          SoundStudioServicePreviewSoundRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'trackId')
    ..aI(3, _omitFieldNames ? '' : 'previewStartMs')
    ..aI(4, _omitFieldNames ? '' : 'previewDurationMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServicePreviewSoundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServicePreviewSoundRequest copyWith(
          void Function(SoundStudioServicePreviewSoundRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServicePreviewSoundRequest))
          as SoundStudioServicePreviewSoundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServicePreviewSoundRequest() / SoundStudioServicePreviewSoundRequest.new instead')
  static SoundStudioServicePreviewSoundRequest create() =>
      SoundStudioServicePreviewSoundRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServicePreviewSoundRequest._();
  @$core.override
  SoundStudioServicePreviewSoundRequest createEmptyInstance() =>
      SoundStudioServicePreviewSoundRequest._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServicePreviewSoundRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServicePreviewSoundRequest>(
          SoundStudioServicePreviewSoundRequest.$_createMessage);
  static SoundStudioServicePreviewSoundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get trackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set trackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get previewStartMs => $_getIZ(2);
  @$pb.TagNumber(3)
  set previewStartMs($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPreviewStartMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearPreviewStartMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get previewDurationMs => $_getIZ(3);
  @$pb.TagNumber(4)
  set previewDurationMs($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPreviewDurationMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPreviewDurationMs() => $_clearField(4);
}

class SoundStudioServicePreviewSoundResponse extends $pb.GeneratedMessage {
  factory SoundStudioServicePreviewSoundResponse({
    $core.String? previewUrl,
    $core.Iterable<$core.double>? waveformPeaks,
    $core.bool? isFree,
  }) {
    final result = SoundStudioServicePreviewSoundResponse._();
    if (previewUrl != null) result.previewUrl = previewUrl;
    if (waveformPeaks != null) result.waveformPeaks.addAll(waveformPeaks);
    if (isFree != null) result.isFree = isFree;
    return result;
  }

  SoundStudioServicePreviewSoundResponse._();

  factory SoundStudioServicePreviewSoundResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServicePreviewSoundResponse()..mergeFromBuffer(data, registry);
  factory SoundStudioServicePreviewSoundResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SoundStudioServicePreviewSoundResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SoundStudioServicePreviewSoundResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          SoundStudioServicePreviewSoundResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'previewUrl')
    ..p<$core.double>(
        2, _omitFieldNames ? '' : 'waveformPeaks', $pb.PbFieldType.KF)
    ..aOB(3, _omitFieldNames ? '' : 'isFree')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServicePreviewSoundResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SoundStudioServicePreviewSoundResponse copyWith(
          void Function(SoundStudioServicePreviewSoundResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SoundStudioServicePreviewSoundResponse))
          as SoundStudioServicePreviewSoundResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SoundStudioServicePreviewSoundResponse() / SoundStudioServicePreviewSoundResponse.new instead')
  static SoundStudioServicePreviewSoundResponse create() =>
      SoundStudioServicePreviewSoundResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SoundStudioServicePreviewSoundResponse._();
  @$core.override
  SoundStudioServicePreviewSoundResponse createEmptyInstance() =>
      SoundStudioServicePreviewSoundResponse._();
  @$core.pragma('dart2js:noInline')
  static SoundStudioServicePreviewSoundResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SoundStudioServicePreviewSoundResponse>(
          SoundStudioServicePreviewSoundResponse.$_createMessage);
  static SoundStudioServicePreviewSoundResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get previewUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set previewUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPreviewUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreviewUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get waveformPeaks => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get isFree => $_getBF(2);
  @$pb.TagNumber(3)
  set isFree($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsFree() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsFree() => $_clearField(3);
}

/// VoiceCloneRecord represents a cloned voice profile linked to characters and consent records per database_schema.md §22.12.
class VoiceCloneRecord extends $pb.GeneratedMessage {
  factory VoiceCloneRecord({
    $core.String? voiceCloneId,
    $core.String? workspaceId,
    $core.String? characterId,
    $core.String? provider,
    $core.String? providerVoiceId,
    $core.String? voiceName,
    $core.Iterable<$core.String>? sampleAudioUrls,
    $core.String? cloneStatus,
    $core.String? consentRecordId,
    $core.double? qualityScore,
    $core.bool? repairApplied,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = VoiceCloneRecord._();
    if (voiceCloneId != null) result.voiceCloneId = voiceCloneId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (characterId != null) result.characterId = characterId;
    if (provider != null) result.provider = provider;
    if (providerVoiceId != null) result.providerVoiceId = providerVoiceId;
    if (voiceName != null) result.voiceName = voiceName;
    if (sampleAudioUrls != null) result.sampleAudioUrls.addAll(sampleAudioUrls);
    if (cloneStatus != null) result.cloneStatus = cloneStatus;
    if (consentRecordId != null) result.consentRecordId = consentRecordId;
    if (qualityScore != null) result.qualityScore = qualityScore;
    if (repairApplied != null) result.repairApplied = repairApplied;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  VoiceCloneRecord._();

  factory VoiceCloneRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneRecord()..mergeFromBuffer(data, registry);
  factory VoiceCloneRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'voiceCloneId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'characterId')
    ..aOS(4, _omitFieldNames ? '' : 'provider')
    ..aOS(5, _omitFieldNames ? '' : 'providerVoiceId')
    ..aOS(6, _omitFieldNames ? '' : 'voiceName')
    ..pPS(7, _omitFieldNames ? '' : 'sampleAudioUrls')
    ..aOS(8, _omitFieldNames ? '' : 'cloneStatus')
    ..aOS(9, _omitFieldNames ? '' : 'consentRecordId')
    ..aD(10, _omitFieldNames ? '' : 'qualityScore')
    ..aOB(11, _omitFieldNames ? '' : 'repairApplied')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneRecord copyWith(void Function(VoiceCloneRecord) updates) =>
      super.copyWith((message) => updates(message as VoiceCloneRecord))
          as VoiceCloneRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VoiceCloneRecord() / VoiceCloneRecord.new instead')
  static VoiceCloneRecord create() => VoiceCloneRecord._();
  static $pb.GeneratedMessage $_createMessage() => VoiceCloneRecord._();
  @$core.override
  VoiceCloneRecord createEmptyInstance() => VoiceCloneRecord._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneRecord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoiceCloneRecord>(
          VoiceCloneRecord.$_createMessage);
  static VoiceCloneRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get voiceCloneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set voiceCloneId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVoiceCloneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVoiceCloneId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get characterId => $_getSZ(2);
  @$pb.TagNumber(3)
  set characterId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCharacterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacterId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get provider => $_getSZ(3);
  @$pb.TagNumber(4)
  set provider($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProvider() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvider() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get providerVoiceId => $_getSZ(4);
  @$pb.TagNumber(5)
  set providerVoiceId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProviderVoiceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProviderVoiceId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get voiceName => $_getSZ(5);
  @$pb.TagNumber(6)
  set voiceName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVoiceName() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoiceName() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get sampleAudioUrls => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get cloneStatus => $_getSZ(7);
  @$pb.TagNumber(8)
  set cloneStatus($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCloneStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearCloneStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get consentRecordId => $_getSZ(8);
  @$pb.TagNumber(9)
  set consentRecordId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConsentRecordId() => $_has(8);
  @$pb.TagNumber(9)
  void clearConsentRecordId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get qualityScore => $_getN(9);
  @$pb.TagNumber(10)
  set qualityScore($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasQualityScore() => $_has(9);
  @$pb.TagNumber(10)
  void clearQualityScore() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get repairApplied => $_getBF(10);
  @$pb.TagNumber(11)
  set repairApplied($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRepairApplied() => $_has(10);
  @$pb.TagNumber(11)
  void clearRepairApplied() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureCreatedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $1.Timestamp get updatedAt => $_getN(12);
  @$pb.TagNumber(13)
  set updatedAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasUpdatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearUpdatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureUpdatedAt() => $_ensure(12);
}

class VoiceCloneServiceCreateRequest extends $pb.GeneratedMessage {
  factory VoiceCloneServiceCreateRequest({
    $2.CommandContext? context,
    $core.String? characterId,
    $core.String? name,
    $core.Iterable<$core.String>? sampleAudioUrls,
    $core.bool? consentConfirmed,
    $core.String? consentRecordId,
    $core.String? language,
    $core.String? quoteId,
    $core.String? confirmedCredits,
  }) {
    final result = VoiceCloneServiceCreateRequest._();
    if (context != null) result.context = context;
    if (characterId != null) result.characterId = characterId;
    if (name != null) result.name = name;
    if (sampleAudioUrls != null) result.sampleAudioUrls.addAll(sampleAudioUrls);
    if (consentConfirmed != null) result.consentConfirmed = consentConfirmed;
    if (consentRecordId != null) result.consentRecordId = consentRecordId;
    if (language != null) result.language = language;
    if (quoteId != null) result.quoteId = quoteId;
    if (confirmedCredits != null) result.confirmedCredits = confirmedCredits;
    return result;
  }

  VoiceCloneServiceCreateRequest._();

  factory VoiceCloneServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneServiceCreateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'characterId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..pPS(4, _omitFieldNames ? '' : 'sampleAudioUrls')
    ..aOB(5, _omitFieldNames ? '' : 'consentConfirmed')
    ..aOS(6, _omitFieldNames ? '' : 'consentRecordId')
    ..aOS(7, _omitFieldNames ? '' : 'language')
    ..aOS(8, _omitFieldNames ? '' : 'quoteId')
    ..aOS(9, _omitFieldNames ? '' : 'confirmedCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceCreateRequest copyWith(
          void Function(VoiceCloneServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VoiceCloneServiceCreateRequest))
          as VoiceCloneServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceCreateRequest() / VoiceCloneServiceCreateRequest.new instead')
  static VoiceCloneServiceCreateRequest create() =>
      VoiceCloneServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceCreateRequest._();
  @$core.override
  VoiceCloneServiceCreateRequest createEmptyInstance() =>
      VoiceCloneServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoiceCloneServiceCreateRequest>(
          VoiceCloneServiceCreateRequest.$_createMessage);
  static VoiceCloneServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get characterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set characterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCharacterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get sampleAudioUrls => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get consentConfirmed => $_getBF(4);
  @$pb.TagNumber(5)
  set consentConfirmed($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConsentConfirmed() => $_has(4);
  @$pb.TagNumber(5)
  void clearConsentConfirmed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get consentRecordId => $_getSZ(5);
  @$pb.TagNumber(6)
  set consentRecordId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConsentRecordId() => $_has(5);
  @$pb.TagNumber(6)
  void clearConsentRecordId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get language => $_getSZ(6);
  @$pb.TagNumber(7)
  set language($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLanguage() => $_has(6);
  @$pb.TagNumber(7)
  void clearLanguage() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get quoteId => $_getSZ(7);
  @$pb.TagNumber(8)
  set quoteId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasQuoteId() => $_has(7);
  @$pb.TagNumber(8)
  void clearQuoteId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get confirmedCredits => $_getSZ(8);
  @$pb.TagNumber(9)
  set confirmedCredits($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConfirmedCredits() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfirmedCredits() => $_clearField(9);
}

class VoiceCloneServiceCreateResponse extends $pb.GeneratedMessage {
  factory VoiceCloneServiceCreateResponse({
    VoiceCloneRecord? record,
    $core.String? status,
    $core.int? estimatedDurationS,
    $core.String? creditsReserved,
    $core.String? consentStatus,
  }) {
    final result = VoiceCloneServiceCreateResponse._();
    if (record != null) result.record = record;
    if (status != null) result.status = status;
    if (estimatedDurationS != null)
      result.estimatedDurationS = estimatedDurationS;
    if (creditsReserved != null) result.creditsReserved = creditsReserved;
    if (consentStatus != null) result.consentStatus = consentStatus;
    return result;
  }

  VoiceCloneServiceCreateResponse._();

  factory VoiceCloneServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneServiceCreateResponse.$_createMessage)
    ..aOM<VoiceCloneRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: VoiceCloneRecord.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aI(3, _omitFieldNames ? '' : 'estimatedDurationS')
    ..aOS(4, _omitFieldNames ? '' : 'creditsReserved')
    ..aOS(5, _omitFieldNames ? '' : 'consentStatus')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceCreateResponse copyWith(
          void Function(VoiceCloneServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VoiceCloneServiceCreateResponse))
          as VoiceCloneServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceCreateResponse() / VoiceCloneServiceCreateResponse.new instead')
  static VoiceCloneServiceCreateResponse create() =>
      VoiceCloneServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceCreateResponse._();
  @$core.override
  VoiceCloneServiceCreateResponse createEmptyInstance() =>
      VoiceCloneServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoiceCloneServiceCreateResponse>(
          VoiceCloneServiceCreateResponse.$_createMessage);
  static VoiceCloneServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VoiceCloneRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(VoiceCloneRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  VoiceCloneRecord ensureRecord() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get estimatedDurationS => $_getIZ(2);
  @$pb.TagNumber(3)
  set estimatedDurationS($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEstimatedDurationS() => $_has(2);
  @$pb.TagNumber(3)
  void clearEstimatedDurationS() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creditsReserved => $_getSZ(3);
  @$pb.TagNumber(4)
  set creditsReserved($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreditsReserved() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreditsReserved() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get consentStatus => $_getSZ(4);
  @$pb.TagNumber(5)
  set consentStatus($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConsentStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearConsentStatus() => $_clearField(5);
}

class VoiceCloneServiceGetRequest extends $pb.GeneratedMessage {
  factory VoiceCloneServiceGetRequest({
    $2.UUID? workspaceId,
    $core.String? voiceCloneId,
  }) {
    final result = VoiceCloneServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (voiceCloneId != null) result.voiceCloneId = voiceCloneId;
    return result;
  }

  VoiceCloneServiceGetRequest._();

  factory VoiceCloneServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGetRequest()..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneServiceGetRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'voiceCloneId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGetRequest copyWith(
          void Function(VoiceCloneServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VoiceCloneServiceGetRequest))
          as VoiceCloneServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceGetRequest() / VoiceCloneServiceGetRequest.new instead')
  static VoiceCloneServiceGetRequest create() =>
      VoiceCloneServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceGetRequest._();
  @$core.override
  VoiceCloneServiceGetRequest createEmptyInstance() =>
      VoiceCloneServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoiceCloneServiceGetRequest>(
          VoiceCloneServiceGetRequest.$_createMessage);
  static VoiceCloneServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get voiceCloneId => $_getSZ(1);
  @$pb.TagNumber(2)
  set voiceCloneId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVoiceCloneId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoiceCloneId() => $_clearField(2);
}

class VoiceCloneServiceGetResponse extends $pb.GeneratedMessage {
  factory VoiceCloneServiceGetResponse({
    VoiceCloneRecord? record,
  }) {
    final result = VoiceCloneServiceGetResponse._();
    if (record != null) result.record = record;
    return result;
  }

  VoiceCloneServiceGetResponse._();

  factory VoiceCloneServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGetResponse()..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneServiceGetResponse.$_createMessage)
    ..aOM<VoiceCloneRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: VoiceCloneRecord.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGetResponse copyWith(
          void Function(VoiceCloneServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VoiceCloneServiceGetResponse))
          as VoiceCloneServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceGetResponse() / VoiceCloneServiceGetResponse.new instead')
  static VoiceCloneServiceGetResponse create() =>
      VoiceCloneServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceGetResponse._();
  @$core.override
  VoiceCloneServiceGetResponse createEmptyInstance() =>
      VoiceCloneServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoiceCloneServiceGetResponse>(
          VoiceCloneServiceGetResponse.$_createMessage);
  static VoiceCloneServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VoiceCloneRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(VoiceCloneRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  VoiceCloneRecord ensureRecord() => $_ensure(0);
}

class VoiceCloneServiceListRequest extends $pb.GeneratedMessage {
  factory VoiceCloneServiceListRequest({
    $2.UUID? workspaceId,
    $core.String? characterId,
    $2.Pagination? pagination,
  }) {
    final result = VoiceCloneServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (characterId != null) result.characterId = characterId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  VoiceCloneServiceListRequest._();

  factory VoiceCloneServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceListRequest()..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneServiceListRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'characterId')
    ..aOM<$2.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceListRequest copyWith(
          void Function(VoiceCloneServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VoiceCloneServiceListRequest))
          as VoiceCloneServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceListRequest() / VoiceCloneServiceListRequest.new instead')
  static VoiceCloneServiceListRequest create() =>
      VoiceCloneServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceListRequest._();
  @$core.override
  VoiceCloneServiceListRequest createEmptyInstance() =>
      VoiceCloneServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoiceCloneServiceListRequest>(
          VoiceCloneServiceListRequest.$_createMessage);
  static VoiceCloneServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get characterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set characterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCharacterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.Pagination get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($2.Pagination value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Pagination ensurePagination() => $_ensure(2);
}

class VoiceCloneServiceListResponse extends $pb.GeneratedMessage {
  factory VoiceCloneServiceListResponse({
    $core.Iterable<VoiceCloneRecord>? records,
    $2.PaginatedResponse? pagination,
  }) {
    final result = VoiceCloneServiceListResponse._();
    if (records != null) result.records.addAll(records);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  VoiceCloneServiceListResponse._();

  factory VoiceCloneServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceListResponse()..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneServiceListResponse.$_createMessage)
    ..pPM<VoiceCloneRecord>(1, _omitFieldNames ? '' : 'records',
        subBuilder: VoiceCloneRecord.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceListResponse copyWith(
          void Function(VoiceCloneServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VoiceCloneServiceListResponse))
          as VoiceCloneServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceListResponse() / VoiceCloneServiceListResponse.new instead')
  static VoiceCloneServiceListResponse create() =>
      VoiceCloneServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceListResponse._();
  @$core.override
  VoiceCloneServiceListResponse createEmptyInstance() =>
      VoiceCloneServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoiceCloneServiceListResponse>(
          VoiceCloneServiceListResponse.$_createMessage);
  static VoiceCloneServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VoiceCloneRecord> get records => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class VoiceCloneServiceDeleteRequest extends $pb.GeneratedMessage {
  factory VoiceCloneServiceDeleteRequest({
    $2.CommandContext? context,
    $core.String? voiceCloneId,
    $core.bool? revokeConsent,
  }) {
    final result = VoiceCloneServiceDeleteRequest._();
    if (context != null) result.context = context;
    if (voiceCloneId != null) result.voiceCloneId = voiceCloneId;
    if (revokeConsent != null) result.revokeConsent = revokeConsent;
    return result;
  }

  VoiceCloneServiceDeleteRequest._();

  factory VoiceCloneServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneServiceDeleteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'voiceCloneId')
    ..aOB(3, _omitFieldNames ? '' : 'revokeConsent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceDeleteRequest copyWith(
          void Function(VoiceCloneServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VoiceCloneServiceDeleteRequest))
          as VoiceCloneServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceDeleteRequest() / VoiceCloneServiceDeleteRequest.new instead')
  static VoiceCloneServiceDeleteRequest create() =>
      VoiceCloneServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceDeleteRequest._();
  @$core.override
  VoiceCloneServiceDeleteRequest createEmptyInstance() =>
      VoiceCloneServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoiceCloneServiceDeleteRequest>(
          VoiceCloneServiceDeleteRequest.$_createMessage);
  static VoiceCloneServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get voiceCloneId => $_getSZ(1);
  @$pb.TagNumber(2)
  set voiceCloneId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVoiceCloneId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoiceCloneId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get revokeConsent => $_getBF(2);
  @$pb.TagNumber(3)
  set revokeConsent($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevokeConsent() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevokeConsent() => $_clearField(3);
}

class VoiceCloneServiceDeleteResponse extends $pb.GeneratedMessage {
  factory VoiceCloneServiceDeleteResponse({
    $core.bool? success,
    $core.String? message,
    $core.bool? consentRevoked,
  }) {
    final result = VoiceCloneServiceDeleteResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (consentRevoked != null) result.consentRevoked = consentRevoked;
    return result;
  }

  VoiceCloneServiceDeleteResponse._();

  factory VoiceCloneServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VoiceCloneServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'consentRevoked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceDeleteResponse copyWith(
          void Function(VoiceCloneServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VoiceCloneServiceDeleteResponse))
          as VoiceCloneServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceDeleteResponse() / VoiceCloneServiceDeleteResponse.new instead')
  static VoiceCloneServiceDeleteResponse create() =>
      VoiceCloneServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceDeleteResponse._();
  @$core.override
  VoiceCloneServiceDeleteResponse createEmptyInstance() =>
      VoiceCloneServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoiceCloneServiceDeleteResponse>(
          VoiceCloneServiceDeleteResponse.$_createMessage);
  static VoiceCloneServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get consentRevoked => $_getBF(2);
  @$pb.TagNumber(3)
  set consentRevoked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConsentRevoked() => $_has(2);
  @$pb.TagNumber(3)
  void clearConsentRevoked() => $_clearField(3);
}

class VoiceCloneServiceGenerateVoiceoverRequest extends $pb.GeneratedMessage {
  factory VoiceCloneServiceGenerateVoiceoverRequest({
    $2.CommandContext? context,
    $core.String? voiceCloneId,
    $core.String? text,
    $core.String? language,
    $core.double? speed,
    $core.double? pitch,
    $core.String? quoteId,
    $core.String? confirmedCredits,
  }) {
    final result = VoiceCloneServiceGenerateVoiceoverRequest._();
    if (context != null) result.context = context;
    if (voiceCloneId != null) result.voiceCloneId = voiceCloneId;
    if (text != null) result.text = text;
    if (language != null) result.language = language;
    if (speed != null) result.speed = speed;
    if (pitch != null) result.pitch = pitch;
    if (quoteId != null) result.quoteId = quoteId;
    if (confirmedCredits != null) result.confirmedCredits = confirmedCredits;
    return result;
  }

  VoiceCloneServiceGenerateVoiceoverRequest._();

  factory VoiceCloneServiceGenerateVoiceoverRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGenerateVoiceoverRequest()
        ..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceGenerateVoiceoverRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGenerateVoiceoverRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceGenerateVoiceoverRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          VoiceCloneServiceGenerateVoiceoverRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'voiceCloneId')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'language')
    ..aD(5, _omitFieldNames ? '' : 'speed')
    ..aD(6, _omitFieldNames ? '' : 'pitch')
    ..aOS(7, _omitFieldNames ? '' : 'quoteId')
    ..aOS(8, _omitFieldNames ? '' : 'confirmedCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGenerateVoiceoverRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGenerateVoiceoverRequest copyWith(
          void Function(VoiceCloneServiceGenerateVoiceoverRequest) updates) =>
      super.copyWith((message) =>
              updates(message as VoiceCloneServiceGenerateVoiceoverRequest))
          as VoiceCloneServiceGenerateVoiceoverRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceGenerateVoiceoverRequest() / VoiceCloneServiceGenerateVoiceoverRequest.new instead')
  static VoiceCloneServiceGenerateVoiceoverRequest create() =>
      VoiceCloneServiceGenerateVoiceoverRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceGenerateVoiceoverRequest._();
  @$core.override
  VoiceCloneServiceGenerateVoiceoverRequest createEmptyInstance() =>
      VoiceCloneServiceGenerateVoiceoverRequest._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceGenerateVoiceoverRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              VoiceCloneServiceGenerateVoiceoverRequest>(
          VoiceCloneServiceGenerateVoiceoverRequest.$_createMessage);
  static VoiceCloneServiceGenerateVoiceoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get voiceCloneId => $_getSZ(1);
  @$pb.TagNumber(2)
  set voiceCloneId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVoiceCloneId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoiceCloneId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get language => $_getSZ(3);
  @$pb.TagNumber(4)
  set language($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLanguage() => $_has(3);
  @$pb.TagNumber(4)
  void clearLanguage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get speed => $_getN(4);
  @$pb.TagNumber(5)
  set speed($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpeed() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpeed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get pitch => $_getN(5);
  @$pb.TagNumber(6)
  set pitch($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPitch() => $_has(5);
  @$pb.TagNumber(6)
  void clearPitch() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get quoteId => $_getSZ(6);
  @$pb.TagNumber(7)
  set quoteId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuoteId() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuoteId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get confirmedCredits => $_getSZ(7);
  @$pb.TagNumber(8)
  set confirmedCredits($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasConfirmedCredits() => $_has(7);
  @$pb.TagNumber(8)
  void clearConfirmedCredits() => $_clearField(8);
}

class VoiceCloneServiceGenerateVoiceoverResponse extends $pb.GeneratedMessage {
  factory VoiceCloneServiceGenerateVoiceoverResponse({
    $core.String? assetId,
    $core.String? audioUrl,
    $core.double? durationSeconds,
    $core.String? creditsUsed,
  }) {
    final result = VoiceCloneServiceGenerateVoiceoverResponse._();
    if (assetId != null) result.assetId = assetId;
    if (audioUrl != null) result.audioUrl = audioUrl;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (creditsUsed != null) result.creditsUsed = creditsUsed;
    return result;
  }

  VoiceCloneServiceGenerateVoiceoverResponse._();

  factory VoiceCloneServiceGenerateVoiceoverResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGenerateVoiceoverResponse()
        ..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceGenerateVoiceoverResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGenerateVoiceoverResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceGenerateVoiceoverResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          VoiceCloneServiceGenerateVoiceoverResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'audioUrl')
    ..aD(3, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(4, _omitFieldNames ? '' : 'creditsUsed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGenerateVoiceoverResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGenerateVoiceoverResponse copyWith(
          void Function(VoiceCloneServiceGenerateVoiceoverResponse) updates) =>
      super.copyWith((message) =>
              updates(message as VoiceCloneServiceGenerateVoiceoverResponse))
          as VoiceCloneServiceGenerateVoiceoverResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceGenerateVoiceoverResponse() / VoiceCloneServiceGenerateVoiceoverResponse.new instead')
  static VoiceCloneServiceGenerateVoiceoverResponse create() =>
      VoiceCloneServiceGenerateVoiceoverResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceGenerateVoiceoverResponse._();
  @$core.override
  VoiceCloneServiceGenerateVoiceoverResponse createEmptyInstance() =>
      VoiceCloneServiceGenerateVoiceoverResponse._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceGenerateVoiceoverResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              VoiceCloneServiceGenerateVoiceoverResponse>(
          VoiceCloneServiceGenerateVoiceoverResponse.$_createMessage);
  static VoiceCloneServiceGenerateVoiceoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get audioUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set audioUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAudioUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearAudioUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get durationSeconds => $_getN(2);
  @$pb.TagNumber(3)
  set durationSeconds($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creditsUsed => $_getSZ(3);
  @$pb.TagNumber(4)
  set creditsUsed($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreditsUsed() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreditsUsed() => $_clearField(4);
}

class VoiceCloneServiceGetConsentStatusRequest extends $pb.GeneratedMessage {
  factory VoiceCloneServiceGetConsentStatusRequest({
    $2.UUID? workspaceId,
    $core.String? voiceCloneId,
    $core.String? characterId,
  }) {
    final result = VoiceCloneServiceGetConsentStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (voiceCloneId != null) result.voiceCloneId = voiceCloneId;
    if (characterId != null) result.characterId = characterId;
    return result;
  }

  VoiceCloneServiceGetConsentStatusRequest._();

  factory VoiceCloneServiceGetConsentStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGetConsentStatusRequest()
        ..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceGetConsentStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGetConsentStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceGetConsentStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          VoiceCloneServiceGetConsentStatusRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'voiceCloneId')
    ..aOS(3, _omitFieldNames ? '' : 'characterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGetConsentStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGetConsentStatusRequest copyWith(
          void Function(VoiceCloneServiceGetConsentStatusRequest) updates) =>
      super.copyWith((message) =>
              updates(message as VoiceCloneServiceGetConsentStatusRequest))
          as VoiceCloneServiceGetConsentStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceGetConsentStatusRequest() / VoiceCloneServiceGetConsentStatusRequest.new instead')
  static VoiceCloneServiceGetConsentStatusRequest create() =>
      VoiceCloneServiceGetConsentStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceGetConsentStatusRequest._();
  @$core.override
  VoiceCloneServiceGetConsentStatusRequest createEmptyInstance() =>
      VoiceCloneServiceGetConsentStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceGetConsentStatusRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              VoiceCloneServiceGetConsentStatusRequest>(
          VoiceCloneServiceGetConsentStatusRequest.$_createMessage);
  static VoiceCloneServiceGetConsentStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get voiceCloneId => $_getSZ(1);
  @$pb.TagNumber(2)
  set voiceCloneId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVoiceCloneId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoiceCloneId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get characterId => $_getSZ(2);
  @$pb.TagNumber(3)
  set characterId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCharacterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacterId() => $_clearField(3);
}

class VoiceCloneServiceGetConsentStatusResponse extends $pb.GeneratedMessage {
  factory VoiceCloneServiceGetConsentStatusResponse({
    $core.String? consentRecordId,
    $core.String? consentStatus,
    $1.Timestamp? grantedAt,
    $1.Timestamp? revokedAt,
    $core.String? declarationText,
    $core.bool? isValidForGeneration,
  }) {
    final result = VoiceCloneServiceGetConsentStatusResponse._();
    if (consentRecordId != null) result.consentRecordId = consentRecordId;
    if (consentStatus != null) result.consentStatus = consentStatus;
    if (grantedAt != null) result.grantedAt = grantedAt;
    if (revokedAt != null) result.revokedAt = revokedAt;
    if (declarationText != null) result.declarationText = declarationText;
    if (isValidForGeneration != null)
      result.isValidForGeneration = isValidForGeneration;
    return result;
  }

  VoiceCloneServiceGetConsentStatusResponse._();

  factory VoiceCloneServiceGetConsentStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGetConsentStatusResponse()
        ..mergeFromBuffer(data, registry);
  factory VoiceCloneServiceGetConsentStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VoiceCloneServiceGetConsentStatusResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoiceCloneServiceGetConsentStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance:
          VoiceCloneServiceGetConsentStatusResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'consentRecordId')
    ..aOS(2, _omitFieldNames ? '' : 'consentStatus')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'grantedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'revokedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'declarationText')
    ..aOB(6, _omitFieldNames ? '' : 'isValidForGeneration')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGetConsentStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoiceCloneServiceGetConsentStatusResponse copyWith(
          void Function(VoiceCloneServiceGetConsentStatusResponse) updates) =>
      super.copyWith((message) =>
              updates(message as VoiceCloneServiceGetConsentStatusResponse))
          as VoiceCloneServiceGetConsentStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VoiceCloneServiceGetConsentStatusResponse() / VoiceCloneServiceGetConsentStatusResponse.new instead')
  static VoiceCloneServiceGetConsentStatusResponse create() =>
      VoiceCloneServiceGetConsentStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VoiceCloneServiceGetConsentStatusResponse._();
  @$core.override
  VoiceCloneServiceGetConsentStatusResponse createEmptyInstance() =>
      VoiceCloneServiceGetConsentStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static VoiceCloneServiceGetConsentStatusResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              VoiceCloneServiceGetConsentStatusResponse>(
          VoiceCloneServiceGetConsentStatusResponse.$_createMessage);
  static VoiceCloneServiceGetConsentStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get consentRecordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set consentRecordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConsentRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsentRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get consentStatus => $_getSZ(1);
  @$pb.TagNumber(2)
  set consentStatus($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConsentStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearConsentStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get grantedAt => $_getN(2);
  @$pb.TagNumber(3)
  set grantedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGrantedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearGrantedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureGrantedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.Timestamp get revokedAt => $_getN(3);
  @$pb.TagNumber(4)
  set revokedAt($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRevokedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevokedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureRevokedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get declarationText => $_getSZ(4);
  @$pb.TagNumber(5)
  set declarationText($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDeclarationText() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeclarationText() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isValidForGeneration => $_getBF(5);
  @$pb.TagNumber(6)
  set isValidForGeneration($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsValidForGeneration() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsValidForGeneration() => $_clearField(6);
}

/// CreativeDna holds 8-layer video analysis output per Mode 4 (ai_video_studio.md §Mode 4).
class CreativeDna extends $pb.GeneratedMessage {
  factory CreativeDna({
    $core.int? sceneCount,
    $core.String? hookType,
    $core.String? contentStructureJson,
    $core.String? pacingProfileJson,
    $core.String? visualStyleJson,
    $core.String? audioProfileJson,
    $core.String? transitionMapJson,
    $core.double? totalDurationSeconds,
    $core.String? engagementStructureJson,
  }) {
    final result = CreativeDna._();
    if (sceneCount != null) result.sceneCount = sceneCount;
    if (hookType != null) result.hookType = hookType;
    if (contentStructureJson != null)
      result.contentStructureJson = contentStructureJson;
    if (pacingProfileJson != null) result.pacingProfileJson = pacingProfileJson;
    if (visualStyleJson != null) result.visualStyleJson = visualStyleJson;
    if (audioProfileJson != null) result.audioProfileJson = audioProfileJson;
    if (transitionMapJson != null) result.transitionMapJson = transitionMapJson;
    if (totalDurationSeconds != null)
      result.totalDurationSeconds = totalDurationSeconds;
    if (engagementStructureJson != null)
      result.engagementStructureJson = engagementStructureJson;
    return result;
  }

  CreativeDna._();

  factory CreativeDna.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreativeDna()..mergeFromBuffer(data, registry);
  factory CreativeDna.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreativeDna()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreativeDna',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: CreativeDna.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'sceneCount')
    ..aOS(2, _omitFieldNames ? '' : 'hookType')
    ..aOS(3, _omitFieldNames ? '' : 'contentStructureJson')
    ..aOS(4, _omitFieldNames ? '' : 'pacingProfileJson')
    ..aOS(5, _omitFieldNames ? '' : 'visualStyleJson')
    ..aOS(6, _omitFieldNames ? '' : 'audioProfileJson')
    ..aOS(7, _omitFieldNames ? '' : 'transitionMapJson')
    ..aD(8, _omitFieldNames ? '' : 'totalDurationSeconds')
    ..aOS(9, _omitFieldNames ? '' : 'engagementStructureJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreativeDna clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreativeDna copyWith(void Function(CreativeDna) updates) =>
      super.copyWith((message) => updates(message as CreativeDna))
          as CreativeDna;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreativeDna() / CreativeDna.new instead')
  static CreativeDna create() => CreativeDna._();
  static $pb.GeneratedMessage $_createMessage() => CreativeDna._();
  @$core.override
  CreativeDna createEmptyInstance() => CreativeDna._();
  @$core.pragma('dart2js:noInline')
  static CreativeDna getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreativeDna>(
          CreativeDna.$_createMessage);
  static CreativeDna? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sceneCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set sceneCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSceneCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearSceneCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hookType => $_getSZ(1);
  @$pb.TagNumber(2)
  set hookType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHookType() => $_has(1);
  @$pb.TagNumber(2)
  void clearHookType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contentStructureJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentStructureJson($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentStructureJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentStructureJson() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pacingProfileJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set pacingProfileJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPacingProfileJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearPacingProfileJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get visualStyleJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set visualStyleJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVisualStyleJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisualStyleJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get audioProfileJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set audioProfileJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAudioProfileJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearAudioProfileJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get transitionMapJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set transitionMapJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTransitionMapJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransitionMapJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get totalDurationSeconds => $_getN(7);
  @$pb.TagNumber(8)
  set totalDurationSeconds($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalDurationSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalDurationSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get engagementStructureJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set engagementStructureJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEngagementStructureJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearEngagementStructureJson() => $_clearField(9);
}

/// RemixBlueprint represents durable Creative DNA blueprint per database_schema.md §22.2.
class RemixBlueprint extends $pb.GeneratedMessage {
  factory RemixBlueprint({
    $core.String? blueprintId,
    $core.String? workspaceId,
    $core.String? referenceAssetId,
    $core.String? referenceUrl,
    $core.String? outputAssetId,
    $core.String? videoEditJobId,
    CreativeDna? creativeDna,
    $core.String? remixScript,
    FidelityLevel? fidelityLevel,
    $core.double? originalityScore,
    $core.double? similarityPercentage,
    RemixStatus? status,
    $core.String? rejectionReason,
    $core.String? errorMessage,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = RemixBlueprint._();
    if (blueprintId != null) result.blueprintId = blueprintId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (referenceAssetId != null) result.referenceAssetId = referenceAssetId;
    if (referenceUrl != null) result.referenceUrl = referenceUrl;
    if (outputAssetId != null) result.outputAssetId = outputAssetId;
    if (videoEditJobId != null) result.videoEditJobId = videoEditJobId;
    if (creativeDna != null) result.creativeDna = creativeDna;
    if (remixScript != null) result.remixScript = remixScript;
    if (fidelityLevel != null) result.fidelityLevel = fidelityLevel;
    if (originalityScore != null) result.originalityScore = originalityScore;
    if (similarityPercentage != null)
      result.similarityPercentage = similarityPercentage;
    if (status != null) result.status = status;
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  RemixBlueprint._();

  factory RemixBlueprint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixBlueprint()..mergeFromBuffer(data, registry);
  factory RemixBlueprint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixBlueprint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixBlueprint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixBlueprint.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'blueprintId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'referenceAssetId')
    ..aOS(4, _omitFieldNames ? '' : 'referenceUrl')
    ..aOS(5, _omitFieldNames ? '' : 'outputAssetId')
    ..aOS(6, _omitFieldNames ? '' : 'videoEditJobId')
    ..aOM<CreativeDna>(7, _omitFieldNames ? '' : 'creativeDna',
        subBuilder: CreativeDna.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'remixScript')
    ..aE<FidelityLevel>(9, _omitFieldNames ? '' : 'fidelityLevel',
        enumValues: FidelityLevel.values)
    ..aD(10, _omitFieldNames ? '' : 'originalityScore')
    ..aD(11, _omitFieldNames ? '' : 'similarityPercentage')
    ..aE<RemixStatus>(12, _omitFieldNames ? '' : 'status',
        enumValues: RemixStatus.values)
    ..aOS(13, _omitFieldNames ? '' : 'rejectionReason')
    ..aOS(14, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixBlueprint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixBlueprint copyWith(void Function(RemixBlueprint) updates) =>
      super.copyWith((message) => updates(message as RemixBlueprint))
          as RemixBlueprint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RemixBlueprint() / RemixBlueprint.new instead')
  static RemixBlueprint create() => RemixBlueprint._();
  static $pb.GeneratedMessage $_createMessage() => RemixBlueprint._();
  @$core.override
  RemixBlueprint createEmptyInstance() => RemixBlueprint._();
  @$core.pragma('dart2js:noInline')
  static RemixBlueprint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemixBlueprint>(
          RemixBlueprint.$_createMessage);
  static RemixBlueprint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get blueprintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set blueprintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBlueprintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlueprintId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get referenceAssetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set referenceAssetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReferenceAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReferenceAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get referenceUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set referenceUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReferenceUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearReferenceUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get outputAssetId => $_getSZ(4);
  @$pb.TagNumber(5)
  set outputAssetId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOutputAssetId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutputAssetId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get videoEditJobId => $_getSZ(5);
  @$pb.TagNumber(6)
  set videoEditJobId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVideoEditJobId() => $_has(5);
  @$pb.TagNumber(6)
  void clearVideoEditJobId() => $_clearField(6);

  @$pb.TagNumber(7)
  CreativeDna get creativeDna => $_getN(6);
  @$pb.TagNumber(7)
  set creativeDna(CreativeDna value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCreativeDna() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreativeDna() => $_clearField(7);
  @$pb.TagNumber(7)
  CreativeDna ensureCreativeDna() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get remixScript => $_getSZ(7);
  @$pb.TagNumber(8)
  set remixScript($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRemixScript() => $_has(7);
  @$pb.TagNumber(8)
  void clearRemixScript() => $_clearField(8);

  @$pb.TagNumber(9)
  FidelityLevel get fidelityLevel => $_getN(8);
  @$pb.TagNumber(9)
  set fidelityLevel(FidelityLevel value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasFidelityLevel() => $_has(8);
  @$pb.TagNumber(9)
  void clearFidelityLevel() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get originalityScore => $_getN(9);
  @$pb.TagNumber(10)
  set originalityScore($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOriginalityScore() => $_has(9);
  @$pb.TagNumber(10)
  void clearOriginalityScore() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get similarityPercentage => $_getN(10);
  @$pb.TagNumber(11)
  set similarityPercentage($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSimilarityPercentage() => $_has(10);
  @$pb.TagNumber(11)
  void clearSimilarityPercentage() => $_clearField(11);

  @$pb.TagNumber(12)
  RemixStatus get status => $_getN(11);
  @$pb.TagNumber(12)
  set status(RemixStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get rejectionReason => $_getSZ(12);
  @$pb.TagNumber(13)
  set rejectionReason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRejectionReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearRejectionReason() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get errorMessage => $_getSZ(13);
  @$pb.TagNumber(14)
  set errorMessage($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasErrorMessage() => $_has(13);
  @$pb.TagNumber(14)
  void clearErrorMessage() => $_clearField(14);

  @$pb.TagNumber(15)
  $1.Timestamp get createdAt => $_getN(14);
  @$pb.TagNumber(15)
  set createdAt($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCreatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureCreatedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $1.Timestamp get updatedAt => $_getN(15);
  @$pb.TagNumber(16)
  set updatedAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasUpdatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearUpdatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureUpdatedAt() => $_ensure(15);
}

/// OriginalityCheckResult enforces canonical RULE-M07-003 similarity check (<30% threshold).
class OriginalityCheckResult extends $pb.GeneratedMessage {
  factory OriginalityCheckResult({
    $core.double? similarityPercentage,
    $core.double? canonicalThresholdPercentage,
    $core.double? originalityScore,
    $core.bool? passed,
    $core.String? explanation,
    $core.Iterable<$core.String>? actionableAlternatives,
  }) {
    final result = OriginalityCheckResult._();
    if (similarityPercentage != null)
      result.similarityPercentage = similarityPercentage;
    if (canonicalThresholdPercentage != null)
      result.canonicalThresholdPercentage = canonicalThresholdPercentage;
    if (originalityScore != null) result.originalityScore = originalityScore;
    if (passed != null) result.passed = passed;
    if (explanation != null) result.explanation = explanation;
    if (actionableAlternatives != null)
      result.actionableAlternatives.addAll(actionableAlternatives);
    return result;
  }

  OriginalityCheckResult._();

  factory OriginalityCheckResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OriginalityCheckResult()..mergeFromBuffer(data, registry);
  factory OriginalityCheckResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OriginalityCheckResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OriginalityCheckResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: OriginalityCheckResult.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'similarityPercentage')
    ..aD(2, _omitFieldNames ? '' : 'canonicalThresholdPercentage')
    ..aD(3, _omitFieldNames ? '' : 'originalityScore')
    ..aOB(4, _omitFieldNames ? '' : 'passed')
    ..aOS(5, _omitFieldNames ? '' : 'explanation')
    ..pPS(6, _omitFieldNames ? '' : 'actionableAlternatives')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OriginalityCheckResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OriginalityCheckResult copyWith(
          void Function(OriginalityCheckResult) updates) =>
      super.copyWith((message) => updates(message as OriginalityCheckResult))
          as OriginalityCheckResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OriginalityCheckResult() / OriginalityCheckResult.new instead')
  static OriginalityCheckResult create() => OriginalityCheckResult._();
  static $pb.GeneratedMessage $_createMessage() => OriginalityCheckResult._();
  @$core.override
  OriginalityCheckResult createEmptyInstance() => OriginalityCheckResult._();
  @$core.pragma('dart2js:noInline')
  static OriginalityCheckResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OriginalityCheckResult>(
          OriginalityCheckResult.$_createMessage);
  static OriginalityCheckResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get similarityPercentage => $_getN(0);
  @$pb.TagNumber(1)
  set similarityPercentage($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSimilarityPercentage() => $_has(0);
  @$pb.TagNumber(1)
  void clearSimilarityPercentage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get canonicalThresholdPercentage => $_getN(1);
  @$pb.TagNumber(2)
  set canonicalThresholdPercentage($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCanonicalThresholdPercentage() => $_has(1);
  @$pb.TagNumber(2)
  void clearCanonicalThresholdPercentage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get originalityScore => $_getN(2);
  @$pb.TagNumber(3)
  set originalityScore($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOriginalityScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearOriginalityScore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get passed => $_getBF(3);
  @$pb.TagNumber(4)
  set passed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPassed() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get explanation => $_getSZ(4);
  @$pb.TagNumber(5)
  set explanation($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExplanation() => $_has(4);
  @$pb.TagNumber(5)
  void clearExplanation() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get actionableAlternatives => $_getList(5);
}

/// CopyrightCheckResult models media copyright scanning and no-unlicensed-bypass rule.
class CopyrightCheckResult extends $pb.GeneratedMessage {
  factory CopyrightCheckResult({
    $core.String? mediaId,
    $core.String? mediaTitle,
    $core.bool? isCopyrighted,
    $core.String? detectedSongTitle,
    $core.String? detectedArtist,
    $core.bool? licenseVerified,
    $core.String? licenseKey,
    $core.bool? passed,
    $core.bool? canBypassRisk,
    $core.String? warningMessage,
    $core.Iterable<$core.String>? actionableOptions,
  }) {
    final result = CopyrightCheckResult._();
    if (mediaId != null) result.mediaId = mediaId;
    if (mediaTitle != null) result.mediaTitle = mediaTitle;
    if (isCopyrighted != null) result.isCopyrighted = isCopyrighted;
    if (detectedSongTitle != null) result.detectedSongTitle = detectedSongTitle;
    if (detectedArtist != null) result.detectedArtist = detectedArtist;
    if (licenseVerified != null) result.licenseVerified = licenseVerified;
    if (licenseKey != null) result.licenseKey = licenseKey;
    if (passed != null) result.passed = passed;
    if (canBypassRisk != null) result.canBypassRisk = canBypassRisk;
    if (warningMessage != null) result.warningMessage = warningMessage;
    if (actionableOptions != null)
      result.actionableOptions.addAll(actionableOptions);
    return result;
  }

  CopyrightCheckResult._();

  factory CopyrightCheckResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopyrightCheckResult()..mergeFromBuffer(data, registry);
  factory CopyrightCheckResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopyrightCheckResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopyrightCheckResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: CopyrightCheckResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaTitle')
    ..aOB(3, _omitFieldNames ? '' : 'isCopyrighted')
    ..aOS(4, _omitFieldNames ? '' : 'detectedSongTitle')
    ..aOS(5, _omitFieldNames ? '' : 'detectedArtist')
    ..aOB(6, _omitFieldNames ? '' : 'licenseVerified')
    ..aOS(7, _omitFieldNames ? '' : 'licenseKey')
    ..aOB(8, _omitFieldNames ? '' : 'passed')
    ..aOB(9, _omitFieldNames ? '' : 'canBypassRisk')
    ..aOS(10, _omitFieldNames ? '' : 'warningMessage')
    ..pPS(11, _omitFieldNames ? '' : 'actionableOptions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopyrightCheckResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopyrightCheckResult copyWith(void Function(CopyrightCheckResult) updates) =>
      super.copyWith((message) => updates(message as CopyrightCheckResult))
          as CopyrightCheckResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopyrightCheckResult() / CopyrightCheckResult.new instead')
  static CopyrightCheckResult create() => CopyrightCheckResult._();
  static $pb.GeneratedMessage $_createMessage() => CopyrightCheckResult._();
  @$core.override
  CopyrightCheckResult createEmptyInstance() => CopyrightCheckResult._();
  @$core.pragma('dart2js:noInline')
  static CopyrightCheckResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopyrightCheckResult>(
          CopyrightCheckResult.$_createMessage);
  static CopyrightCheckResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isCopyrighted => $_getBF(2);
  @$pb.TagNumber(3)
  set isCopyrighted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsCopyrighted() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsCopyrighted() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get detectedSongTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set detectedSongTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetectedSongTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetectedSongTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get detectedArtist => $_getSZ(4);
  @$pb.TagNumber(5)
  set detectedArtist($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDetectedArtist() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetectedArtist() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get licenseVerified => $_getBF(5);
  @$pb.TagNumber(6)
  set licenseVerified($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLicenseVerified() => $_has(5);
  @$pb.TagNumber(6)
  void clearLicenseVerified() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get licenseKey => $_getSZ(6);
  @$pb.TagNumber(7)
  set licenseKey($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLicenseKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearLicenseKey() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get passed => $_getBF(7);
  @$pb.TagNumber(8)
  set passed($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPassed() => $_has(7);
  @$pb.TagNumber(8)
  void clearPassed() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get canBypassRisk => $_getBF(8);
  @$pb.TagNumber(9)
  set canBypassRisk($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCanBypassRisk() => $_has(8);
  @$pb.TagNumber(9)
  void clearCanBypassRisk() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get warningMessage => $_getSZ(9);
  @$pb.TagNumber(10)
  set warningMessage($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWarningMessage() => $_has(9);
  @$pb.TagNumber(10)
  void clearWarningMessage() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get actionableOptions => $_getList(10);
}

/// MultiMergeTimelineItem represents an individual track element in Mode 3 Multi-Merge.
class MultiMergeTimelineItem extends $pb.GeneratedMessage {
  factory MultiMergeTimelineItem({
    $core.String? itemId,
    $core.String? assetId,
    $core.int? orderIndex,
    $core.double? durationSeconds,
    $core.String? mediaType,
    $core.String? transitionToNext,
    $core.double? transitionDurationSeconds,
    $core.String? licenseStatus,
    $core.String? licenseProofKey,
  }) {
    final result = MultiMergeTimelineItem._();
    if (itemId != null) result.itemId = itemId;
    if (assetId != null) result.assetId = assetId;
    if (orderIndex != null) result.orderIndex = orderIndex;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (mediaType != null) result.mediaType = mediaType;
    if (transitionToNext != null) result.transitionToNext = transitionToNext;
    if (transitionDurationSeconds != null)
      result.transitionDurationSeconds = transitionDurationSeconds;
    if (licenseStatus != null) result.licenseStatus = licenseStatus;
    if (licenseProofKey != null) result.licenseProofKey = licenseProofKey;
    return result;
  }

  MultiMergeTimelineItem._();

  factory MultiMergeTimelineItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MultiMergeTimelineItem()..mergeFromBuffer(data, registry);
  factory MultiMergeTimelineItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MultiMergeTimelineItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MultiMergeTimelineItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: MultiMergeTimelineItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aI(3, _omitFieldNames ? '' : 'orderIndex')
    ..aD(4, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(5, _omitFieldNames ? '' : 'mediaType')
    ..aOS(6, _omitFieldNames ? '' : 'transitionToNext')
    ..aD(7, _omitFieldNames ? '' : 'transitionDurationSeconds')
    ..aOS(8, _omitFieldNames ? '' : 'licenseStatus')
    ..aOS(9, _omitFieldNames ? '' : 'licenseProofKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiMergeTimelineItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiMergeTimelineItem copyWith(
          void Function(MultiMergeTimelineItem) updates) =>
      super.copyWith((message) => updates(message as MultiMergeTimelineItem))
          as MultiMergeTimelineItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MultiMergeTimelineItem() / MultiMergeTimelineItem.new instead')
  static MultiMergeTimelineItem create() => MultiMergeTimelineItem._();
  static $pb.GeneratedMessage $_createMessage() => MultiMergeTimelineItem._();
  @$core.override
  MultiMergeTimelineItem createEmptyInstance() => MultiMergeTimelineItem._();
  @$core.pragma('dart2js:noInline')
  static MultiMergeTimelineItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MultiMergeTimelineItem>(
          MultiMergeTimelineItem.$_createMessage);
  static MultiMergeTimelineItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get orderIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set orderIndex($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get durationSeconds => $_getN(3);
  @$pb.TagNumber(4)
  set durationSeconds($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDurationSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearDurationSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get mediaType => $_getSZ(4);
  @$pb.TagNumber(5)
  set mediaType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMediaType() => $_has(4);
  @$pb.TagNumber(5)
  void clearMediaType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get transitionToNext => $_getSZ(5);
  @$pb.TagNumber(6)
  set transitionToNext($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTransitionToNext() => $_has(5);
  @$pb.TagNumber(6)
  void clearTransitionToNext() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get transitionDurationSeconds => $_getN(6);
  @$pb.TagNumber(7)
  set transitionDurationSeconds($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTransitionDurationSeconds() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransitionDurationSeconds() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get licenseStatus => $_getSZ(7);
  @$pb.TagNumber(8)
  set licenseStatus($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLicenseStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearLicenseStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get licenseProofKey => $_getSZ(8);
  @$pb.TagNumber(9)
  set licenseProofKey($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLicenseProofKey() => $_has(8);
  @$pb.TagNumber(9)
  void clearLicenseProofKey() => $_clearField(9);
}

/// MultiMergeSettings configures overall timeline assembly per Mode 3 (ai_video_studio.md §Mode 3).
class MultiMergeSettings extends $pb.GeneratedMessage {
  factory MultiMergeSettings({
    $core.double? targetDurationSeconds,
    $core.bool? autoTransitions,
    $core.String? voiceOverType,
    $core.String? voiceOverCharacterId,
    $core.String? musicSource,
    $core.String? musicAssetId,
    $core.String? musicLicenseProof,
    $core.String? aspectRatio,
    $core.String? pacing,
  }) {
    final result = MultiMergeSettings._();
    if (targetDurationSeconds != null)
      result.targetDurationSeconds = targetDurationSeconds;
    if (autoTransitions != null) result.autoTransitions = autoTransitions;
    if (voiceOverType != null) result.voiceOverType = voiceOverType;
    if (voiceOverCharacterId != null)
      result.voiceOverCharacterId = voiceOverCharacterId;
    if (musicSource != null) result.musicSource = musicSource;
    if (musicAssetId != null) result.musicAssetId = musicAssetId;
    if (musicLicenseProof != null) result.musicLicenseProof = musicLicenseProof;
    if (aspectRatio != null) result.aspectRatio = aspectRatio;
    if (pacing != null) result.pacing = pacing;
    return result;
  }

  MultiMergeSettings._();

  factory MultiMergeSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MultiMergeSettings()..mergeFromBuffer(data, registry);
  factory MultiMergeSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MultiMergeSettings()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MultiMergeSettings',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: MultiMergeSettings.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'targetDurationSeconds')
    ..aOB(2, _omitFieldNames ? '' : 'autoTransitions')
    ..aOS(3, _omitFieldNames ? '' : 'voiceOverType')
    ..aOS(4, _omitFieldNames ? '' : 'voiceOverCharacterId')
    ..aOS(5, _omitFieldNames ? '' : 'musicSource')
    ..aOS(6, _omitFieldNames ? '' : 'musicAssetId')
    ..aOS(7, _omitFieldNames ? '' : 'musicLicenseProof')
    ..aOS(8, _omitFieldNames ? '' : 'aspectRatio')
    ..aOS(9, _omitFieldNames ? '' : 'pacing')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiMergeSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiMergeSettings copyWith(void Function(MultiMergeSettings) updates) =>
      super.copyWith((message) => updates(message as MultiMergeSettings))
          as MultiMergeSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MultiMergeSettings() / MultiMergeSettings.new instead')
  static MultiMergeSettings create() => MultiMergeSettings._();
  static $pb.GeneratedMessage $_createMessage() => MultiMergeSettings._();
  @$core.override
  MultiMergeSettings createEmptyInstance() => MultiMergeSettings._();
  @$core.pragma('dart2js:noInline')
  static MultiMergeSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MultiMergeSettings>(
          MultiMergeSettings.$_createMessage);
  static MultiMergeSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get targetDurationSeconds => $_getN(0);
  @$pb.TagNumber(1)
  set targetDurationSeconds($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTargetDurationSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetDurationSeconds() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get autoTransitions => $_getBF(1);
  @$pb.TagNumber(2)
  set autoTransitions($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoTransitions() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoTransitions() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get voiceOverType => $_getSZ(2);
  @$pb.TagNumber(3)
  set voiceOverType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVoiceOverType() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoiceOverType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get voiceOverCharacterId => $_getSZ(3);
  @$pb.TagNumber(4)
  set voiceOverCharacterId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVoiceOverCharacterId() => $_has(3);
  @$pb.TagNumber(4)
  void clearVoiceOverCharacterId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get musicSource => $_getSZ(4);
  @$pb.TagNumber(5)
  set musicSource($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMusicSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearMusicSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get musicAssetId => $_getSZ(5);
  @$pb.TagNumber(6)
  set musicAssetId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMusicAssetId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMusicAssetId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get musicLicenseProof => $_getSZ(6);
  @$pb.TagNumber(7)
  set musicLicenseProof($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMusicLicenseProof() => $_has(6);
  @$pb.TagNumber(7)
  void clearMusicLicenseProof() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get aspectRatio => $_getSZ(7);
  @$pb.TagNumber(8)
  set aspectRatio($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAspectRatio() => $_has(7);
  @$pb.TagNumber(8)
  void clearAspectRatio() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get pacing => $_getSZ(8);
  @$pb.TagNumber(9)
  set pacing($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPacing() => $_has(8);
  @$pb.TagNumber(9)
  void clearPacing() => $_clearField(9);
}

/// VideoEditJob represents a video edit job record per database_schema.md §22.1.
class VideoEditJob extends $pb.GeneratedMessage {
  factory VideoEditJob({
    $core.String? jobId,
    $core.String? workspaceId,
    ProductionMode? mode,
    $core.Iterable<$core.String>? sourceAssetIds,
    $core.Iterable<$core.String>? outputAssetIds,
    $core.String? generationJobId,
    $core.String? characterId,
    $core.String? brandPackId,
    VideoEditJobStatus? status,
    $core.String? inputParamsJson,
    $core.String? outputMetadataJson,
    $core.String? creditsEstimated,
    $core.String? creditsUsed,
    $core.String? actualCostUsd,
    $core.String? errorMessage,
    $1.Timestamp? startedAt,
    $1.Timestamp? completedAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = VideoEditJob._();
    if (jobId != null) result.jobId = jobId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (mode != null) result.mode = mode;
    if (sourceAssetIds != null) result.sourceAssetIds.addAll(sourceAssetIds);
    if (outputAssetIds != null) result.outputAssetIds.addAll(outputAssetIds);
    if (generationJobId != null) result.generationJobId = generationJobId;
    if (characterId != null) result.characterId = characterId;
    if (brandPackId != null) result.brandPackId = brandPackId;
    if (status != null) result.status = status;
    if (inputParamsJson != null) result.inputParamsJson = inputParamsJson;
    if (outputMetadataJson != null)
      result.outputMetadataJson = outputMetadataJson;
    if (creditsEstimated != null) result.creditsEstimated = creditsEstimated;
    if (creditsUsed != null) result.creditsUsed = creditsUsed;
    if (actualCostUsd != null) result.actualCostUsd = actualCostUsd;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (startedAt != null) result.startedAt = startedAt;
    if (completedAt != null) result.completedAt = completedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  VideoEditJob._();

  factory VideoEditJob.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJob()..mergeFromBuffer(data, registry);
  factory VideoEditJob.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJob()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJob',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJob.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<ProductionMode>(3, _omitFieldNames ? '' : 'mode',
        enumValues: ProductionMode.values)
    ..pPS(4, _omitFieldNames ? '' : 'sourceAssetIds')
    ..pPS(5, _omitFieldNames ? '' : 'outputAssetIds')
    ..aOS(6, _omitFieldNames ? '' : 'generationJobId')
    ..aOS(7, _omitFieldNames ? '' : 'characterId')
    ..aOS(8, _omitFieldNames ? '' : 'brandPackId')
    ..aE<VideoEditJobStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: VideoEditJobStatus.values)
    ..aOS(10, _omitFieldNames ? '' : 'inputParamsJson')
    ..aOS(11, _omitFieldNames ? '' : 'outputMetadataJson')
    ..aOS(12, _omitFieldNames ? '' : 'creditsEstimated')
    ..aOS(13, _omitFieldNames ? '' : 'creditsUsed')
    ..aOS(14, _omitFieldNames ? '' : 'actualCostUsd')
    ..aOS(15, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJob clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJob copyWith(void Function(VideoEditJob) updates) =>
      super.copyWith((message) => updates(message as VideoEditJob))
          as VideoEditJob;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VideoEditJob() / VideoEditJob.new instead')
  static VideoEditJob create() => VideoEditJob._();
  static $pb.GeneratedMessage $_createMessage() => VideoEditJob._();
  @$core.override
  VideoEditJob createEmptyInstance() => VideoEditJob._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJob getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoEditJob>(
          VideoEditJob.$_createMessage);
  static VideoEditJob? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  ProductionMode get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode(ProductionMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get sourceAssetIds => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get outputAssetIds => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get generationJobId => $_getSZ(5);
  @$pb.TagNumber(6)
  set generationJobId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGenerationJobId() => $_has(5);
  @$pb.TagNumber(6)
  void clearGenerationJobId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get characterId => $_getSZ(6);
  @$pb.TagNumber(7)
  set characterId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCharacterId() => $_has(6);
  @$pb.TagNumber(7)
  void clearCharacterId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get brandPackId => $_getSZ(7);
  @$pb.TagNumber(8)
  set brandPackId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBrandPackId() => $_has(7);
  @$pb.TagNumber(8)
  void clearBrandPackId() => $_clearField(8);

  @$pb.TagNumber(9)
  VideoEditJobStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(VideoEditJobStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get inputParamsJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set inputParamsJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasInputParamsJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearInputParamsJson() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get outputMetadataJson => $_getSZ(10);
  @$pb.TagNumber(11)
  set outputMetadataJson($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOutputMetadataJson() => $_has(10);
  @$pb.TagNumber(11)
  void clearOutputMetadataJson() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get creditsEstimated => $_getSZ(11);
  @$pb.TagNumber(12)
  set creditsEstimated($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCreditsEstimated() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreditsEstimated() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get creditsUsed => $_getSZ(12);
  @$pb.TagNumber(13)
  set creditsUsed($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCreditsUsed() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreditsUsed() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get actualCostUsd => $_getSZ(13);
  @$pb.TagNumber(14)
  set actualCostUsd($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasActualCostUsd() => $_has(13);
  @$pb.TagNumber(14)
  void clearActualCostUsd() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get errorMessage => $_getSZ(14);
  @$pb.TagNumber(15)
  set errorMessage($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasErrorMessage() => $_has(14);
  @$pb.TagNumber(15)
  void clearErrorMessage() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.Timestamp get startedAt => $_getN(15);
  @$pb.TagNumber(16)
  set startedAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasStartedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearStartedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureStartedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $1.Timestamp get completedAt => $_getN(16);
  @$pb.TagNumber(17)
  set completedAt($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCompletedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearCompletedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureCompletedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $1.Timestamp get createdAt => $_getN(17);
  @$pb.TagNumber(18)
  set createdAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureCreatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $1.Timestamp get updatedAt => $_getN(18);
  @$pb.TagNumber(19)
  set updatedAt($1.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasUpdatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $1.Timestamp ensureUpdatedAt() => $_ensure(18);
}

/// ----------------------------------------------------------------------------
/// RemixService Request/Response Messages (§7.2)
/// ----------------------------------------------------------------------------
class RemixServiceAnalyzeRequest extends $pb.GeneratedMessage {
  factory RemixServiceAnalyzeRequest({
    $2.CommandContext? context,
    $core.String? referenceAssetId,
    $core.String? referenceUrl,
    FidelityLevel? fidelityLevel,
    $core.String? topic,
    $core.String? characterId,
    $core.String? brandPackId,
    $core.Iterable<$core.String>? targetPlatforms,
  }) {
    final result = RemixServiceAnalyzeRequest._();
    if (context != null) result.context = context;
    if (referenceAssetId != null) result.referenceAssetId = referenceAssetId;
    if (referenceUrl != null) result.referenceUrl = referenceUrl;
    if (fidelityLevel != null) result.fidelityLevel = fidelityLevel;
    if (topic != null) result.topic = topic;
    if (characterId != null) result.characterId = characterId;
    if (brandPackId != null) result.brandPackId = brandPackId;
    if (targetPlatforms != null) result.targetPlatforms.addAll(targetPlatforms);
    return result;
  }

  RemixServiceAnalyzeRequest._();

  factory RemixServiceAnalyzeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceAnalyzeRequest()..mergeFromBuffer(data, registry);
  factory RemixServiceAnalyzeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceAnalyzeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixServiceAnalyzeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixServiceAnalyzeRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'referenceAssetId')
    ..aOS(3, _omitFieldNames ? '' : 'referenceUrl')
    ..aE<FidelityLevel>(4, _omitFieldNames ? '' : 'fidelityLevel',
        enumValues: FidelityLevel.values)
    ..aOS(5, _omitFieldNames ? '' : 'topic')
    ..aOS(6, _omitFieldNames ? '' : 'characterId')
    ..aOS(7, _omitFieldNames ? '' : 'brandPackId')
    ..pPS(8, _omitFieldNames ? '' : 'targetPlatforms')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceAnalyzeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceAnalyzeRequest copyWith(
          void Function(RemixServiceAnalyzeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemixServiceAnalyzeRequest))
          as RemixServiceAnalyzeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemixServiceAnalyzeRequest() / RemixServiceAnalyzeRequest.new instead')
  static RemixServiceAnalyzeRequest create() => RemixServiceAnalyzeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemixServiceAnalyzeRequest._();
  @$core.override
  RemixServiceAnalyzeRequest createEmptyInstance() =>
      RemixServiceAnalyzeRequest._();
  @$core.pragma('dart2js:noInline')
  static RemixServiceAnalyzeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemixServiceAnalyzeRequest>(
          RemixServiceAnalyzeRequest.$_createMessage);
  static RemixServiceAnalyzeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get referenceAssetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set referenceAssetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReferenceAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReferenceAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get referenceUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set referenceUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReferenceUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearReferenceUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  FidelityLevel get fidelityLevel => $_getN(3);
  @$pb.TagNumber(4)
  set fidelityLevel(FidelityLevel value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFidelityLevel() => $_has(3);
  @$pb.TagNumber(4)
  void clearFidelityLevel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get topic => $_getSZ(4);
  @$pb.TagNumber(5)
  set topic($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTopic() => $_has(4);
  @$pb.TagNumber(5)
  void clearTopic() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get characterId => $_getSZ(5);
  @$pb.TagNumber(6)
  set characterId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCharacterId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCharacterId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get brandPackId => $_getSZ(6);
  @$pb.TagNumber(7)
  set brandPackId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBrandPackId() => $_has(6);
  @$pb.TagNumber(7)
  void clearBrandPackId() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get targetPlatforms => $_getList(7);
}

class RemixServiceAnalyzeResponse extends $pb.GeneratedMessage {
  factory RemixServiceAnalyzeResponse({
    RemixBlueprint? blueprint,
    $core.String? creditsDeducted,
  }) {
    final result = RemixServiceAnalyzeResponse._();
    if (blueprint != null) result.blueprint = blueprint;
    if (creditsDeducted != null) result.creditsDeducted = creditsDeducted;
    return result;
  }

  RemixServiceAnalyzeResponse._();

  factory RemixServiceAnalyzeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceAnalyzeResponse()..mergeFromBuffer(data, registry);
  factory RemixServiceAnalyzeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceAnalyzeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixServiceAnalyzeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixServiceAnalyzeResponse.$_createMessage)
    ..aOM<RemixBlueprint>(1, _omitFieldNames ? '' : 'blueprint',
        subBuilder: RemixBlueprint.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'creditsDeducted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceAnalyzeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceAnalyzeResponse copyWith(
          void Function(RemixServiceAnalyzeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RemixServiceAnalyzeResponse))
          as RemixServiceAnalyzeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemixServiceAnalyzeResponse() / RemixServiceAnalyzeResponse.new instead')
  static RemixServiceAnalyzeResponse create() =>
      RemixServiceAnalyzeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemixServiceAnalyzeResponse._();
  @$core.override
  RemixServiceAnalyzeResponse createEmptyInstance() =>
      RemixServiceAnalyzeResponse._();
  @$core.pragma('dart2js:noInline')
  static RemixServiceAnalyzeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemixServiceAnalyzeResponse>(
          RemixServiceAnalyzeResponse.$_createMessage);
  static RemixServiceAnalyzeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RemixBlueprint get blueprint => $_getN(0);
  @$pb.TagNumber(1)
  set blueprint(RemixBlueprint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBlueprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlueprint() => $_clearField(1);
  @$pb.TagNumber(1)
  RemixBlueprint ensureBlueprint() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get creditsDeducted => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsDeducted($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsDeducted() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsDeducted() => $_clearField(2);
}

class RemixServiceGetBlueprintRequest extends $pb.GeneratedMessage {
  factory RemixServiceGetBlueprintRequest({
    $2.UUID? workspaceId,
    $core.String? blueprintId,
  }) {
    final result = RemixServiceGetBlueprintRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (blueprintId != null) result.blueprintId = blueprintId;
    return result;
  }

  RemixServiceGetBlueprintRequest._();

  factory RemixServiceGetBlueprintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceGetBlueprintRequest()..mergeFromBuffer(data, registry);
  factory RemixServiceGetBlueprintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceGetBlueprintRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixServiceGetBlueprintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixServiceGetBlueprintRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'blueprintId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceGetBlueprintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceGetBlueprintRequest copyWith(
          void Function(RemixServiceGetBlueprintRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemixServiceGetBlueprintRequest))
          as RemixServiceGetBlueprintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemixServiceGetBlueprintRequest() / RemixServiceGetBlueprintRequest.new instead')
  static RemixServiceGetBlueprintRequest create() =>
      RemixServiceGetBlueprintRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemixServiceGetBlueprintRequest._();
  @$core.override
  RemixServiceGetBlueprintRequest createEmptyInstance() =>
      RemixServiceGetBlueprintRequest._();
  @$core.pragma('dart2js:noInline')
  static RemixServiceGetBlueprintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemixServiceGetBlueprintRequest>(
          RemixServiceGetBlueprintRequest.$_createMessage);
  static RemixServiceGetBlueprintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get blueprintId => $_getSZ(1);
  @$pb.TagNumber(2)
  set blueprintId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBlueprintId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlueprintId() => $_clearField(2);
}

class RemixServiceGetBlueprintResponse extends $pb.GeneratedMessage {
  factory RemixServiceGetBlueprintResponse({
    RemixBlueprint? blueprint,
  }) {
    final result = RemixServiceGetBlueprintResponse._();
    if (blueprint != null) result.blueprint = blueprint;
    return result;
  }

  RemixServiceGetBlueprintResponse._();

  factory RemixServiceGetBlueprintResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceGetBlueprintResponse()..mergeFromBuffer(data, registry);
  factory RemixServiceGetBlueprintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceGetBlueprintResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixServiceGetBlueprintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixServiceGetBlueprintResponse.$_createMessage)
    ..aOM<RemixBlueprint>(1, _omitFieldNames ? '' : 'blueprint',
        subBuilder: RemixBlueprint.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceGetBlueprintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceGetBlueprintResponse copyWith(
          void Function(RemixServiceGetBlueprintResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RemixServiceGetBlueprintResponse))
          as RemixServiceGetBlueprintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemixServiceGetBlueprintResponse() / RemixServiceGetBlueprintResponse.new instead')
  static RemixServiceGetBlueprintResponse create() =>
      RemixServiceGetBlueprintResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemixServiceGetBlueprintResponse._();
  @$core.override
  RemixServiceGetBlueprintResponse createEmptyInstance() =>
      RemixServiceGetBlueprintResponse._();
  @$core.pragma('dart2js:noInline')
  static RemixServiceGetBlueprintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemixServiceGetBlueprintResponse>(
          RemixServiceGetBlueprintResponse.$_createMessage);
  static RemixServiceGetBlueprintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RemixBlueprint get blueprint => $_getN(0);
  @$pb.TagNumber(1)
  set blueprint(RemixBlueprint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBlueprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlueprint() => $_clearField(1);
  @$pb.TagNumber(1)
  RemixBlueprint ensureBlueprint() => $_ensure(0);
}

class RemixServiceGenerateRequest extends $pb.GeneratedMessage {
  factory RemixServiceGenerateRequest({
    $2.CommandContext? context,
    $core.String? blueprintId,
    $core.String? editedScript,
    FidelityLevel? fidelityLevel,
    $core.String? topic,
    $core.String? characterId,
    $core.String? brandPackId,
    $core.bool? dryRun,
  }) {
    final result = RemixServiceGenerateRequest._();
    if (context != null) result.context = context;
    if (blueprintId != null) result.blueprintId = blueprintId;
    if (editedScript != null) result.editedScript = editedScript;
    if (fidelityLevel != null) result.fidelityLevel = fidelityLevel;
    if (topic != null) result.topic = topic;
    if (characterId != null) result.characterId = characterId;
    if (brandPackId != null) result.brandPackId = brandPackId;
    if (dryRun != null) result.dryRun = dryRun;
    return result;
  }

  RemixServiceGenerateRequest._();

  factory RemixServiceGenerateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceGenerateRequest()..mergeFromBuffer(data, registry);
  factory RemixServiceGenerateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceGenerateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixServiceGenerateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixServiceGenerateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'blueprintId')
    ..aOS(3, _omitFieldNames ? '' : 'editedScript')
    ..aE<FidelityLevel>(4, _omitFieldNames ? '' : 'fidelityLevel',
        enumValues: FidelityLevel.values)
    ..aOS(5, _omitFieldNames ? '' : 'topic')
    ..aOS(6, _omitFieldNames ? '' : 'characterId')
    ..aOS(7, _omitFieldNames ? '' : 'brandPackId')
    ..aOB(8, _omitFieldNames ? '' : 'dryRun')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceGenerateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceGenerateRequest copyWith(
          void Function(RemixServiceGenerateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemixServiceGenerateRequest))
          as RemixServiceGenerateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemixServiceGenerateRequest() / RemixServiceGenerateRequest.new instead')
  static RemixServiceGenerateRequest create() =>
      RemixServiceGenerateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemixServiceGenerateRequest._();
  @$core.override
  RemixServiceGenerateRequest createEmptyInstance() =>
      RemixServiceGenerateRequest._();
  @$core.pragma('dart2js:noInline')
  static RemixServiceGenerateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemixServiceGenerateRequest>(
          RemixServiceGenerateRequest.$_createMessage);
  static RemixServiceGenerateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get blueprintId => $_getSZ(1);
  @$pb.TagNumber(2)
  set blueprintId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBlueprintId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlueprintId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get editedScript => $_getSZ(2);
  @$pb.TagNumber(3)
  set editedScript($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEditedScript() => $_has(2);
  @$pb.TagNumber(3)
  void clearEditedScript() => $_clearField(3);

  @$pb.TagNumber(4)
  FidelityLevel get fidelityLevel => $_getN(3);
  @$pb.TagNumber(4)
  set fidelityLevel(FidelityLevel value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFidelityLevel() => $_has(3);
  @$pb.TagNumber(4)
  void clearFidelityLevel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get topic => $_getSZ(4);
  @$pb.TagNumber(5)
  set topic($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTopic() => $_has(4);
  @$pb.TagNumber(5)
  void clearTopic() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get characterId => $_getSZ(5);
  @$pb.TagNumber(6)
  set characterId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCharacterId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCharacterId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get brandPackId => $_getSZ(6);
  @$pb.TagNumber(7)
  set brandPackId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBrandPackId() => $_has(6);
  @$pb.TagNumber(7)
  void clearBrandPackId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get dryRun => $_getBF(7);
  @$pb.TagNumber(8)
  set dryRun($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDryRun() => $_has(7);
  @$pb.TagNumber(8)
  void clearDryRun() => $_clearField(8);
}

class RemixServiceGenerateResponse extends $pb.GeneratedMessage {
  factory RemixServiceGenerateResponse({
    RemixBlueprint? blueprint,
    VideoEditJob? job,
    Asset? asset,
    OriginalityCheckResult? originalityCheck,
    $core.String? creditsDeducted,
    $core.bool? isDryRun,
  }) {
    final result = RemixServiceGenerateResponse._();
    if (blueprint != null) result.blueprint = blueprint;
    if (job != null) result.job = job;
    if (asset != null) result.asset = asset;
    if (originalityCheck != null) result.originalityCheck = originalityCheck;
    if (creditsDeducted != null) result.creditsDeducted = creditsDeducted;
    if (isDryRun != null) result.isDryRun = isDryRun;
    return result;
  }

  RemixServiceGenerateResponse._();

  factory RemixServiceGenerateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceGenerateResponse()..mergeFromBuffer(data, registry);
  factory RemixServiceGenerateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceGenerateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixServiceGenerateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixServiceGenerateResponse.$_createMessage)
    ..aOM<RemixBlueprint>(1, _omitFieldNames ? '' : 'blueprint',
        subBuilder: RemixBlueprint.$_createMessage)
    ..aOM<VideoEditJob>(2, _omitFieldNames ? '' : 'job',
        subBuilder: VideoEditJob.$_createMessage)
    ..aOM<Asset>(3, _omitFieldNames ? '' : 'asset',
        subBuilder: Asset.$_createMessage)
    ..aOM<OriginalityCheckResult>(4, _omitFieldNames ? '' : 'originalityCheck',
        subBuilder: OriginalityCheckResult.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'creditsDeducted')
    ..aOB(6, _omitFieldNames ? '' : 'isDryRun')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceGenerateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceGenerateResponse copyWith(
          void Function(RemixServiceGenerateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RemixServiceGenerateResponse))
          as RemixServiceGenerateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemixServiceGenerateResponse() / RemixServiceGenerateResponse.new instead')
  static RemixServiceGenerateResponse create() =>
      RemixServiceGenerateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemixServiceGenerateResponse._();
  @$core.override
  RemixServiceGenerateResponse createEmptyInstance() =>
      RemixServiceGenerateResponse._();
  @$core.pragma('dart2js:noInline')
  static RemixServiceGenerateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemixServiceGenerateResponse>(
          RemixServiceGenerateResponse.$_createMessage);
  static RemixServiceGenerateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RemixBlueprint get blueprint => $_getN(0);
  @$pb.TagNumber(1)
  set blueprint(RemixBlueprint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBlueprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlueprint() => $_clearField(1);
  @$pb.TagNumber(1)
  RemixBlueprint ensureBlueprint() => $_ensure(0);

  @$pb.TagNumber(2)
  VideoEditJob get job => $_getN(1);
  @$pb.TagNumber(2)
  set job(VideoEditJob value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJob() => $_has(1);
  @$pb.TagNumber(2)
  void clearJob() => $_clearField(2);
  @$pb.TagNumber(2)
  VideoEditJob ensureJob() => $_ensure(1);

  @$pb.TagNumber(3)
  Asset get asset => $_getN(2);
  @$pb.TagNumber(3)
  set asset(Asset value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAsset() => $_has(2);
  @$pb.TagNumber(3)
  void clearAsset() => $_clearField(3);
  @$pb.TagNumber(3)
  Asset ensureAsset() => $_ensure(2);

  @$pb.TagNumber(4)
  OriginalityCheckResult get originalityCheck => $_getN(3);
  @$pb.TagNumber(4)
  set originalityCheck(OriginalityCheckResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOriginalityCheck() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginalityCheck() => $_clearField(4);
  @$pb.TagNumber(4)
  OriginalityCheckResult ensureOriginalityCheck() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get creditsDeducted => $_getSZ(4);
  @$pb.TagNumber(5)
  set creditsDeducted($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreditsDeducted() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreditsDeducted() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isDryRun => $_getBF(5);
  @$pb.TagNumber(6)
  set isDryRun($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsDryRun() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsDryRun() => $_clearField(6);
}

class RemixServiceRegenerateRequest extends $pb.GeneratedMessage {
  factory RemixServiceRegenerateRequest({
    $2.CommandContext? context,
    $core.String? blueprintId,
    $core.int? sceneIndex,
    $core.String? scriptSegment,
    $core.String? visualPromptOverride,
  }) {
    final result = RemixServiceRegenerateRequest._();
    if (context != null) result.context = context;
    if (blueprintId != null) result.blueprintId = blueprintId;
    if (sceneIndex != null) result.sceneIndex = sceneIndex;
    if (scriptSegment != null) result.scriptSegment = scriptSegment;
    if (visualPromptOverride != null)
      result.visualPromptOverride = visualPromptOverride;
    return result;
  }

  RemixServiceRegenerateRequest._();

  factory RemixServiceRegenerateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceRegenerateRequest()..mergeFromBuffer(data, registry);
  factory RemixServiceRegenerateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceRegenerateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixServiceRegenerateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixServiceRegenerateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'blueprintId')
    ..aI(3, _omitFieldNames ? '' : 'sceneIndex')
    ..aOS(4, _omitFieldNames ? '' : 'scriptSegment')
    ..aOS(5, _omitFieldNames ? '' : 'visualPromptOverride')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceRegenerateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceRegenerateRequest copyWith(
          void Function(RemixServiceRegenerateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RemixServiceRegenerateRequest))
          as RemixServiceRegenerateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemixServiceRegenerateRequest() / RemixServiceRegenerateRequest.new instead')
  static RemixServiceRegenerateRequest create() =>
      RemixServiceRegenerateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemixServiceRegenerateRequest._();
  @$core.override
  RemixServiceRegenerateRequest createEmptyInstance() =>
      RemixServiceRegenerateRequest._();
  @$core.pragma('dart2js:noInline')
  static RemixServiceRegenerateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemixServiceRegenerateRequest>(
          RemixServiceRegenerateRequest.$_createMessage);
  static RemixServiceRegenerateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get blueprintId => $_getSZ(1);
  @$pb.TagNumber(2)
  set blueprintId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBlueprintId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlueprintId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sceneIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set sceneIndex($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSceneIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSceneIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scriptSegment => $_getSZ(3);
  @$pb.TagNumber(4)
  set scriptSegment($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScriptSegment() => $_has(3);
  @$pb.TagNumber(4)
  void clearScriptSegment() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get visualPromptOverride => $_getSZ(4);
  @$pb.TagNumber(5)
  set visualPromptOverride($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVisualPromptOverride() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisualPromptOverride() => $_clearField(5);
}

class RemixServiceRegenerateResponse extends $pb.GeneratedMessage {
  factory RemixServiceRegenerateResponse({
    RemixBlueprint? blueprint,
    VideoEditJob? job,
    $core.int? sceneIndex,
    $core.String? creditsDeducted,
  }) {
    final result = RemixServiceRegenerateResponse._();
    if (blueprint != null) result.blueprint = blueprint;
    if (job != null) result.job = job;
    if (sceneIndex != null) result.sceneIndex = sceneIndex;
    if (creditsDeducted != null) result.creditsDeducted = creditsDeducted;
    return result;
  }

  RemixServiceRegenerateResponse._();

  factory RemixServiceRegenerateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceRegenerateResponse()..mergeFromBuffer(data, registry);
  factory RemixServiceRegenerateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemixServiceRegenerateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemixServiceRegenerateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: RemixServiceRegenerateResponse.$_createMessage)
    ..aOM<RemixBlueprint>(1, _omitFieldNames ? '' : 'blueprint',
        subBuilder: RemixBlueprint.$_createMessage)
    ..aOM<VideoEditJob>(2, _omitFieldNames ? '' : 'job',
        subBuilder: VideoEditJob.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'sceneIndex')
    ..aOS(4, _omitFieldNames ? '' : 'creditsDeducted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceRegenerateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemixServiceRegenerateResponse copyWith(
          void Function(RemixServiceRegenerateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RemixServiceRegenerateResponse))
          as RemixServiceRegenerateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RemixServiceRegenerateResponse() / RemixServiceRegenerateResponse.new instead')
  static RemixServiceRegenerateResponse create() =>
      RemixServiceRegenerateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RemixServiceRegenerateResponse._();
  @$core.override
  RemixServiceRegenerateResponse createEmptyInstance() =>
      RemixServiceRegenerateResponse._();
  @$core.pragma('dart2js:noInline')
  static RemixServiceRegenerateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemixServiceRegenerateResponse>(
          RemixServiceRegenerateResponse.$_createMessage);
  static RemixServiceRegenerateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RemixBlueprint get blueprint => $_getN(0);
  @$pb.TagNumber(1)
  set blueprint(RemixBlueprint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBlueprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlueprint() => $_clearField(1);
  @$pb.TagNumber(1)
  RemixBlueprint ensureBlueprint() => $_ensure(0);

  @$pb.TagNumber(2)
  VideoEditJob get job => $_getN(1);
  @$pb.TagNumber(2)
  set job(VideoEditJob value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJob() => $_has(1);
  @$pb.TagNumber(2)
  void clearJob() => $_clearField(2);
  @$pb.TagNumber(2)
  VideoEditJob ensureJob() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get sceneIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set sceneIndex($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSceneIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSceneIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creditsDeducted => $_getSZ(3);
  @$pb.TagNumber(4)
  set creditsDeducted($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreditsDeducted() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreditsDeducted() => $_clearField(4);
}

/// ----------------------------------------------------------------------------
/// VideoEditJobService Request/Response Messages (§7.1)
/// ----------------------------------------------------------------------------
class VideoEditJobServiceCreateRequest extends $pb.GeneratedMessage {
  factory VideoEditJobServiceCreateRequest({
    $2.CommandContext? context,
    ProductionMode? mode,
    $core.Iterable<$core.String>? sourceAssetIds,
    $core.String? characterId,
    $core.String? brandPackId,
    $core.Iterable<MultiMergeTimelineItem>? timelineItems,
    MultiMergeSettings? multimergeSettings,
    $core.bool? dryRun,
  }) {
    final result = VideoEditJobServiceCreateRequest._();
    if (context != null) result.context = context;
    if (mode != null) result.mode = mode;
    if (sourceAssetIds != null) result.sourceAssetIds.addAll(sourceAssetIds);
    if (characterId != null) result.characterId = characterId;
    if (brandPackId != null) result.brandPackId = brandPackId;
    if (timelineItems != null) result.timelineItems.addAll(timelineItems);
    if (multimergeSettings != null)
      result.multimergeSettings = multimergeSettings;
    if (dryRun != null) result.dryRun = dryRun;
    return result;
  }

  VideoEditJobServiceCreateRequest._();

  factory VideoEditJobServiceCreateRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceCreateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aE<ProductionMode>(2, _omitFieldNames ? '' : 'mode',
        enumValues: ProductionMode.values)
    ..pPS(3, _omitFieldNames ? '' : 'sourceAssetIds')
    ..aOS(4, _omitFieldNames ? '' : 'characterId')
    ..aOS(5, _omitFieldNames ? '' : 'brandPackId')
    ..pPM<MultiMergeTimelineItem>(6, _omitFieldNames ? '' : 'timelineItems',
        subBuilder: MultiMergeTimelineItem.$_createMessage)
    ..aOM<MultiMergeSettings>(7, _omitFieldNames ? '' : 'multimergeSettings',
        subBuilder: MultiMergeSettings.$_createMessage)
    ..aOB(8, _omitFieldNames ? '' : 'dryRun')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceCreateRequest copyWith(
          void Function(VideoEditJobServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VideoEditJobServiceCreateRequest))
          as VideoEditJobServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceCreateRequest() / VideoEditJobServiceCreateRequest.new instead')
  static VideoEditJobServiceCreateRequest create() =>
      VideoEditJobServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceCreateRequest._();
  @$core.override
  VideoEditJobServiceCreateRequest createEmptyInstance() =>
      VideoEditJobServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceCreateRequest>(
          VideoEditJobServiceCreateRequest.$_createMessage);
  static VideoEditJobServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  ProductionMode get mode => $_getN(1);
  @$pb.TagNumber(2)
  set mode(ProductionMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get sourceAssetIds => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get characterId => $_getSZ(3);
  @$pb.TagNumber(4)
  set characterId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCharacterId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCharacterId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get brandPackId => $_getSZ(4);
  @$pb.TagNumber(5)
  set brandPackId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBrandPackId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBrandPackId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<MultiMergeTimelineItem> get timelineItems => $_getList(5);

  @$pb.TagNumber(7)
  MultiMergeSettings get multimergeSettings => $_getN(6);
  @$pb.TagNumber(7)
  set multimergeSettings(MultiMergeSettings value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMultimergeSettings() => $_has(6);
  @$pb.TagNumber(7)
  void clearMultimergeSettings() => $_clearField(7);
  @$pb.TagNumber(7)
  MultiMergeSettings ensureMultimergeSettings() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get dryRun => $_getBF(7);
  @$pb.TagNumber(8)
  set dryRun($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDryRun() => $_has(7);
  @$pb.TagNumber(8)
  void clearDryRun() => $_clearField(8);
}

class VideoEditJobServiceCreateResponse extends $pb.GeneratedMessage {
  factory VideoEditJobServiceCreateResponse({
    VideoEditJob? job,
    $core.String? creditsEstimated,
    $core.bool? isDryRun,
    $core.Iterable<CopyrightCheckResult>? copyrightChecks,
  }) {
    final result = VideoEditJobServiceCreateResponse._();
    if (job != null) result.job = job;
    if (creditsEstimated != null) result.creditsEstimated = creditsEstimated;
    if (isDryRun != null) result.isDryRun = isDryRun;
    if (copyrightChecks != null) result.copyrightChecks.addAll(copyrightChecks);
    return result;
  }

  VideoEditJobServiceCreateResponse._();

  factory VideoEditJobServiceCreateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceCreateResponse.$_createMessage)
    ..aOM<VideoEditJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: VideoEditJob.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'creditsEstimated')
    ..aOB(3, _omitFieldNames ? '' : 'isDryRun')
    ..pPM<CopyrightCheckResult>(4, _omitFieldNames ? '' : 'copyrightChecks',
        subBuilder: CopyrightCheckResult.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceCreateResponse copyWith(
          void Function(VideoEditJobServiceCreateResponse) updates) =>
      super.copyWith((message) =>
              updates(message as VideoEditJobServiceCreateResponse))
          as VideoEditJobServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceCreateResponse() / VideoEditJobServiceCreateResponse.new instead')
  static VideoEditJobServiceCreateResponse create() =>
      VideoEditJobServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceCreateResponse._();
  @$core.override
  VideoEditJobServiceCreateResponse createEmptyInstance() =>
      VideoEditJobServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceCreateResponse>(
          VideoEditJobServiceCreateResponse.$_createMessage);
  static VideoEditJobServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VideoEditJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(VideoEditJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  VideoEditJob ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get creditsEstimated => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsEstimated($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsEstimated() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsEstimated() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isDryRun => $_getBF(2);
  @$pb.TagNumber(3)
  set isDryRun($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsDryRun() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsDryRun() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<CopyrightCheckResult> get copyrightChecks => $_getList(3);
}

class VideoEditJobServiceGetRequest extends $pb.GeneratedMessage {
  factory VideoEditJobServiceGetRequest({
    $2.UUID? workspaceId,
    $core.String? jobId,
  }) {
    final result = VideoEditJobServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  VideoEditJobServiceGetRequest._();

  factory VideoEditJobServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceGetRequest()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceGetRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceGetRequest copyWith(
          void Function(VideoEditJobServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VideoEditJobServiceGetRequest))
          as VideoEditJobServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceGetRequest() / VideoEditJobServiceGetRequest.new instead')
  static VideoEditJobServiceGetRequest create() =>
      VideoEditJobServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceGetRequest._();
  @$core.override
  VideoEditJobServiceGetRequest createEmptyInstance() =>
      VideoEditJobServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceGetRequest>(
          VideoEditJobServiceGetRequest.$_createMessage);
  static VideoEditJobServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);
}

class VideoEditJobServiceGetResponse extends $pb.GeneratedMessage {
  factory VideoEditJobServiceGetResponse({
    VideoEditJob? job,
  }) {
    final result = VideoEditJobServiceGetResponse._();
    if (job != null) result.job = job;
    return result;
  }

  VideoEditJobServiceGetResponse._();

  factory VideoEditJobServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceGetResponse()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceGetResponse.$_createMessage)
    ..aOM<VideoEditJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: VideoEditJob.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceGetResponse copyWith(
          void Function(VideoEditJobServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VideoEditJobServiceGetResponse))
          as VideoEditJobServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceGetResponse() / VideoEditJobServiceGetResponse.new instead')
  static VideoEditJobServiceGetResponse create() =>
      VideoEditJobServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceGetResponse._();
  @$core.override
  VideoEditJobServiceGetResponse createEmptyInstance() =>
      VideoEditJobServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceGetResponse>(
          VideoEditJobServiceGetResponse.$_createMessage);
  static VideoEditJobServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VideoEditJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(VideoEditJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  VideoEditJob ensureJob() => $_ensure(0);
}

class VideoEditJobServiceListRequest extends $pb.GeneratedMessage {
  factory VideoEditJobServiceListRequest({
    $2.UUID? workspaceId,
    ProductionMode? mode,
    VideoEditJobStatus? status,
    $2.Pagination? pagination,
  }) {
    final result = VideoEditJobServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (mode != null) result.mode = mode;
    if (status != null) result.status = status;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  VideoEditJobServiceListRequest._();

  factory VideoEditJobServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceListRequest()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceListRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aE<ProductionMode>(2, _omitFieldNames ? '' : 'mode',
        enumValues: ProductionMode.values)
    ..aE<VideoEditJobStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: VideoEditJobStatus.values)
    ..aOM<$2.Pagination>(4, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceListRequest copyWith(
          void Function(VideoEditJobServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VideoEditJobServiceListRequest))
          as VideoEditJobServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceListRequest() / VideoEditJobServiceListRequest.new instead')
  static VideoEditJobServiceListRequest create() =>
      VideoEditJobServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceListRequest._();
  @$core.override
  VideoEditJobServiceListRequest createEmptyInstance() =>
      VideoEditJobServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceListRequest>(
          VideoEditJobServiceListRequest.$_createMessage);
  static VideoEditJobServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  ProductionMode get mode => $_getN(1);
  @$pb.TagNumber(2)
  set mode(ProductionMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);

  @$pb.TagNumber(3)
  VideoEditJobStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(VideoEditJobStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Pagination get pagination => $_getN(3);
  @$pb.TagNumber(4)
  set pagination($2.Pagination value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPagination() => $_has(3);
  @$pb.TagNumber(4)
  void clearPagination() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Pagination ensurePagination() => $_ensure(3);
}

class VideoEditJobServiceListResponse extends $pb.GeneratedMessage {
  factory VideoEditJobServiceListResponse({
    $core.Iterable<VideoEditJob>? jobs,
    $2.PaginatedResponse? pagination,
  }) {
    final result = VideoEditJobServiceListResponse._();
    if (jobs != null) result.jobs.addAll(jobs);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  VideoEditJobServiceListResponse._();

  factory VideoEditJobServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceListResponse()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceListResponse.$_createMessage)
    ..pPM<VideoEditJob>(1, _omitFieldNames ? '' : 'jobs',
        subBuilder: VideoEditJob.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceListResponse copyWith(
          void Function(VideoEditJobServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VideoEditJobServiceListResponse))
          as VideoEditJobServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceListResponse() / VideoEditJobServiceListResponse.new instead')
  static VideoEditJobServiceListResponse create() =>
      VideoEditJobServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceListResponse._();
  @$core.override
  VideoEditJobServiceListResponse createEmptyInstance() =>
      VideoEditJobServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceListResponse>(
          VideoEditJobServiceListResponse.$_createMessage);
  static VideoEditJobServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VideoEditJob> get jobs => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class VideoEditJobServiceCancelRequest extends $pb.GeneratedMessage {
  factory VideoEditJobServiceCancelRequest({
    $2.CommandContext? context,
    $core.String? jobId,
    $core.String? reason,
  }) {
    final result = VideoEditJobServiceCancelRequest._();
    if (context != null) result.context = context;
    if (jobId != null) result.jobId = jobId;
    if (reason != null) result.reason = reason;
    return result;
  }

  VideoEditJobServiceCancelRequest._();

  factory VideoEditJobServiceCancelRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceCancelRequest()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceCancelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceCancelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceCancelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceCancelRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceCancelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceCancelRequest copyWith(
          void Function(VideoEditJobServiceCancelRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VideoEditJobServiceCancelRequest))
          as VideoEditJobServiceCancelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceCancelRequest() / VideoEditJobServiceCancelRequest.new instead')
  static VideoEditJobServiceCancelRequest create() =>
      VideoEditJobServiceCancelRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceCancelRequest._();
  @$core.override
  VideoEditJobServiceCancelRequest createEmptyInstance() =>
      VideoEditJobServiceCancelRequest._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceCancelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceCancelRequest>(
          VideoEditJobServiceCancelRequest.$_createMessage);
  static VideoEditJobServiceCancelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class VideoEditJobServiceCancelResponse extends $pb.GeneratedMessage {
  factory VideoEditJobServiceCancelResponse({
    VideoEditJob? job,
    $core.String? creditsRefunded,
  }) {
    final result = VideoEditJobServiceCancelResponse._();
    if (job != null) result.job = job;
    if (creditsRefunded != null) result.creditsRefunded = creditsRefunded;
    return result;
  }

  VideoEditJobServiceCancelResponse._();

  factory VideoEditJobServiceCancelResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceCancelResponse()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceCancelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceCancelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceCancelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceCancelResponse.$_createMessage)
    ..aOM<VideoEditJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: VideoEditJob.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'creditsRefunded')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceCancelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceCancelResponse copyWith(
          void Function(VideoEditJobServiceCancelResponse) updates) =>
      super.copyWith((message) =>
              updates(message as VideoEditJobServiceCancelResponse))
          as VideoEditJobServiceCancelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceCancelResponse() / VideoEditJobServiceCancelResponse.new instead')
  static VideoEditJobServiceCancelResponse create() =>
      VideoEditJobServiceCancelResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceCancelResponse._();
  @$core.override
  VideoEditJobServiceCancelResponse createEmptyInstance() =>
      VideoEditJobServiceCancelResponse._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceCancelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceCancelResponse>(
          VideoEditJobServiceCancelResponse.$_createMessage);
  static VideoEditJobServiceCancelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VideoEditJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(VideoEditJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  VideoEditJob ensureJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get creditsRefunded => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsRefunded($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsRefunded() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsRefunded() => $_clearField(2);
}

class VideoEditJobServiceRetryRequest extends $pb.GeneratedMessage {
  factory VideoEditJobServiceRetryRequest({
    $2.CommandContext? context,
    $core.String? jobId,
    $core.String? fallbackProvider,
  }) {
    final result = VideoEditJobServiceRetryRequest._();
    if (context != null) result.context = context;
    if (jobId != null) result.jobId = jobId;
    if (fallbackProvider != null) result.fallbackProvider = fallbackProvider;
    return result;
  }

  VideoEditJobServiceRetryRequest._();

  factory VideoEditJobServiceRetryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceRetryRequest()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceRetryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceRetryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceRetryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceRetryRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..aOS(3, _omitFieldNames ? '' : 'fallbackProvider')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceRetryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceRetryRequest copyWith(
          void Function(VideoEditJobServiceRetryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VideoEditJobServiceRetryRequest))
          as VideoEditJobServiceRetryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceRetryRequest() / VideoEditJobServiceRetryRequest.new instead')
  static VideoEditJobServiceRetryRequest create() =>
      VideoEditJobServiceRetryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceRetryRequest._();
  @$core.override
  VideoEditJobServiceRetryRequest createEmptyInstance() =>
      VideoEditJobServiceRetryRequest._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceRetryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceRetryRequest>(
          VideoEditJobServiceRetryRequest.$_createMessage);
  static VideoEditJobServiceRetryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fallbackProvider => $_getSZ(2);
  @$pb.TagNumber(3)
  set fallbackProvider($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFallbackProvider() => $_has(2);
  @$pb.TagNumber(3)
  void clearFallbackProvider() => $_clearField(3);
}

class VideoEditJobServiceRetryResponse extends $pb.GeneratedMessage {
  factory VideoEditJobServiceRetryResponse({
    VideoEditJob? job,
  }) {
    final result = VideoEditJobServiceRetryResponse._();
    if (job != null) result.job = job;
    return result;
  }

  VideoEditJobServiceRetryResponse._();

  factory VideoEditJobServiceRetryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceRetryResponse()..mergeFromBuffer(data, registry);
  factory VideoEditJobServiceRetryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoEditJobServiceRetryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoEditJobServiceRetryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: VideoEditJobServiceRetryResponse.$_createMessage)
    ..aOM<VideoEditJob>(1, _omitFieldNames ? '' : 'job',
        subBuilder: VideoEditJob.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceRetryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoEditJobServiceRetryResponse copyWith(
          void Function(VideoEditJobServiceRetryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VideoEditJobServiceRetryResponse))
          as VideoEditJobServiceRetryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VideoEditJobServiceRetryResponse() / VideoEditJobServiceRetryResponse.new instead')
  static VideoEditJobServiceRetryResponse create() =>
      VideoEditJobServiceRetryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VideoEditJobServiceRetryResponse._();
  @$core.override
  VideoEditJobServiceRetryResponse createEmptyInstance() =>
      VideoEditJobServiceRetryResponse._();
  @$core.pragma('dart2js:noInline')
  static VideoEditJobServiceRetryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoEditJobServiceRetryResponse>(
          VideoEditJobServiceRetryResponse.$_createMessage);
  static VideoEditJobServiceRetryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  VideoEditJob get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(VideoEditJob value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  VideoEditJob ensureJob() => $_ensure(0);
}

/// StyleElements captures 7 extracted styling parameters per screen W032 and M07 EF-07.
class StyleElements extends $pb.GeneratedMessage {
  factory StyleElements({
    $core.String? colorPalette,
    $core.String? cutPacing,
    $core.String? textStyle,
    $core.String? musicStyle,
    $core.String? transitions,
    $core.String? hookPattern,
    $core.String? visualMood,
    $core.int? avgCutDurationMs,
    $core.Iterable<$core.String>? colorPaletteHex,
  }) {
    final result = StyleElements._();
    if (colorPalette != null) result.colorPalette = colorPalette;
    if (cutPacing != null) result.cutPacing = cutPacing;
    if (textStyle != null) result.textStyle = textStyle;
    if (musicStyle != null) result.musicStyle = musicStyle;
    if (transitions != null) result.transitions = transitions;
    if (hookPattern != null) result.hookPattern = hookPattern;
    if (visualMood != null) result.visualMood = visualMood;
    if (avgCutDurationMs != null) result.avgCutDurationMs = avgCutDurationMs;
    if (colorPaletteHex != null) result.colorPaletteHex.addAll(colorPaletteHex);
    return result;
  }

  StyleElements._();

  factory StyleElements.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StyleElements()..mergeFromBuffer(data, registry);
  factory StyleElements.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StyleElements()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StyleElements',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StyleElements.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'colorPalette')
    ..aOS(2, _omitFieldNames ? '' : 'cutPacing')
    ..aOS(3, _omitFieldNames ? '' : 'textStyle')
    ..aOS(4, _omitFieldNames ? '' : 'musicStyle')
    ..aOS(5, _omitFieldNames ? '' : 'transitions')
    ..aOS(6, _omitFieldNames ? '' : 'hookPattern')
    ..aOS(7, _omitFieldNames ? '' : 'visualMood')
    ..aI(8, _omitFieldNames ? '' : 'avgCutDurationMs')
    ..pPS(9, _omitFieldNames ? '' : 'colorPaletteHex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StyleElements clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StyleElements copyWith(void Function(StyleElements) updates) =>
      super.copyWith((message) => updates(message as StyleElements))
          as StyleElements;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StyleElements() / StyleElements.new instead')
  static StyleElements create() => StyleElements._();
  static $pb.GeneratedMessage $_createMessage() => StyleElements._();
  @$core.override
  StyleElements createEmptyInstance() => StyleElements._();
  @$core.pragma('dart2js:noInline')
  static StyleElements getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StyleElements>(
          StyleElements.$_createMessage);
  static StyleElements? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get colorPalette => $_getSZ(0);
  @$pb.TagNumber(1)
  set colorPalette($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasColorPalette() => $_has(0);
  @$pb.TagNumber(1)
  void clearColorPalette() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cutPacing => $_getSZ(1);
  @$pb.TagNumber(2)
  set cutPacing($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCutPacing() => $_has(1);
  @$pb.TagNumber(2)
  void clearCutPacing() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textStyle => $_getSZ(2);
  @$pb.TagNumber(3)
  set textStyle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextStyle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get musicStyle => $_getSZ(3);
  @$pb.TagNumber(4)
  set musicStyle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMusicStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearMusicStyle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get transitions => $_getSZ(4);
  @$pb.TagNumber(5)
  set transitions($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTransitions() => $_has(4);
  @$pb.TagNumber(5)
  void clearTransitions() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get hookPattern => $_getSZ(5);
  @$pb.TagNumber(6)
  set hookPattern($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHookPattern() => $_has(5);
  @$pb.TagNumber(6)
  void clearHookPattern() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get visualMood => $_getSZ(6);
  @$pb.TagNumber(7)
  set visualMood($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVisualMood() => $_has(6);
  @$pb.TagNumber(7)
  void clearVisualMood() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get avgCutDurationMs => $_getIZ(7);
  @$pb.TagNumber(8)
  set avgCutDurationMs($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAvgCutDurationMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearAvgCutDurationMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get colorPaletteHex => $_getList(8);
}

/// StylePack represents a learned editing style pack per database_schema.md §22.7.
class StylePack extends $pb.GeneratedMessage {
  factory StylePack({
    $core.String? stylePackId,
    $2.UUID? workspaceId,
    $core.String? name,
    $core.String? sourceAssetId,
    $core.String? extractedStyleJson,
    $core.bool? isActive,
    $core.String? continuityPackId,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = StylePack._();
    if (stylePackId != null) result.stylePackId = stylePackId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (name != null) result.name = name;
    if (sourceAssetId != null) result.sourceAssetId = sourceAssetId;
    if (extractedStyleJson != null)
      result.extractedStyleJson = extractedStyleJson;
    if (isActive != null) result.isActive = isActive;
    if (continuityPackId != null) result.continuityPackId = continuityPackId;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  StylePack._();

  factory StylePack.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePack()..mergeFromBuffer(data, registry);
  factory StylePack.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePack()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePack',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePack.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'stylePackId')
    ..aOM<$2.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'sourceAssetId')
    ..aOS(5, _omitFieldNames ? '' : 'extractedStyleJson')
    ..aOB(6, _omitFieldNames ? '' : 'isActive')
    ..aOS(7, _omitFieldNames ? '' : 'continuityPackId')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePack copyWith(void Function(StylePack) updates) =>
      super.copyWith((message) => updates(message as StylePack)) as StylePack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StylePack() / StylePack.new instead')
  static StylePack create() => StylePack._();
  static $pb.GeneratedMessage $_createMessage() => StylePack._();
  @$core.override
  StylePack createEmptyInstance() => StylePack._();
  @$core.pragma('dart2js:noInline')
  static StylePack getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePack>(StylePack.$_createMessage);
  static StylePack? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stylePackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set stylePackId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStylePackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStylePackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($2.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceAssetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceAssetId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceAssetId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get extractedStyleJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set extractedStyleJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExtractedStyleJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearExtractedStyleJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isActive => $_getBF(5);
  @$pb.TagNumber(6)
  set isActive($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsActive() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsActive() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get continuityPackId => $_getSZ(6);
  @$pb.TagNumber(7)
  set continuityPackId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContinuityPackId() => $_has(6);
  @$pb.TagNumber(7)
  void clearContinuityPackId() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.Timestamp get updatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set updatedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureUpdatedAt() => $_ensure(8);
}

class StylePackServiceExtractRequest extends $pb.GeneratedMessage {
  factory StylePackServiceExtractRequest({
    $2.CommandContext? context,
    $core.Iterable<$core.String>? sourceAssetIds,
  }) {
    final result = StylePackServiceExtractRequest._();
    if (context != null) result.context = context;
    if (sourceAssetIds != null) result.sourceAssetIds.addAll(sourceAssetIds);
    return result;
  }

  StylePackServiceExtractRequest._();

  factory StylePackServiceExtractRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceExtractRequest()..mergeFromBuffer(data, registry);
  factory StylePackServiceExtractRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceExtractRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceExtractRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceExtractRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'sourceAssetIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceExtractRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceExtractRequest copyWith(
          void Function(StylePackServiceExtractRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceExtractRequest))
          as StylePackServiceExtractRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceExtractRequest() / StylePackServiceExtractRequest.new instead')
  static StylePackServiceExtractRequest create() =>
      StylePackServiceExtractRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceExtractRequest._();
  @$core.override
  StylePackServiceExtractRequest createEmptyInstance() =>
      StylePackServiceExtractRequest._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceExtractRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceExtractRequest>(
          StylePackServiceExtractRequest.$_createMessage);
  static StylePackServiceExtractRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get sourceAssetIds => $_getList(1);
}

class StylePackServiceExtractResponse extends $pb.GeneratedMessage {
  factory StylePackServiceExtractResponse({
    StyleElements? elements,
    $core.String? creditsUsed,
    $core.String? extractedStyleJson,
  }) {
    final result = StylePackServiceExtractResponse._();
    if (elements != null) result.elements = elements;
    if (creditsUsed != null) result.creditsUsed = creditsUsed;
    if (extractedStyleJson != null)
      result.extractedStyleJson = extractedStyleJson;
    return result;
  }

  StylePackServiceExtractResponse._();

  factory StylePackServiceExtractResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceExtractResponse()..mergeFromBuffer(data, registry);
  factory StylePackServiceExtractResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceExtractResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceExtractResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceExtractResponse.$_createMessage)
    ..aOM<StyleElements>(1, _omitFieldNames ? '' : 'elements',
        subBuilder: StyleElements.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'creditsUsed')
    ..aOS(3, _omitFieldNames ? '' : 'extractedStyleJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceExtractResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceExtractResponse copyWith(
          void Function(StylePackServiceExtractResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceExtractResponse))
          as StylePackServiceExtractResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceExtractResponse() / StylePackServiceExtractResponse.new instead')
  static StylePackServiceExtractResponse create() =>
      StylePackServiceExtractResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceExtractResponse._();
  @$core.override
  StylePackServiceExtractResponse createEmptyInstance() =>
      StylePackServiceExtractResponse._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceExtractResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceExtractResponse>(
          StylePackServiceExtractResponse.$_createMessage);
  static StylePackServiceExtractResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StyleElements get elements => $_getN(0);
  @$pb.TagNumber(1)
  set elements(StyleElements value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasElements() => $_has(0);
  @$pb.TagNumber(1)
  void clearElements() => $_clearField(1);
  @$pb.TagNumber(1)
  StyleElements ensureElements() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get creditsUsed => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsUsed($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsUsed() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsUsed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get extractedStyleJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set extractedStyleJson($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExtractedStyleJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearExtractedStyleJson() => $_clearField(3);
}

class StylePackServiceCreateRequest extends $pb.GeneratedMessage {
  factory StylePackServiceCreateRequest({
    $2.CommandContext? context,
    $core.String? name,
    $core.String? sourceAssetId,
    $core.String? extractedStyleJson,
    $core.bool? linkToContinuityPack,
  }) {
    final result = StylePackServiceCreateRequest._();
    if (context != null) result.context = context;
    if (name != null) result.name = name;
    if (sourceAssetId != null) result.sourceAssetId = sourceAssetId;
    if (extractedStyleJson != null)
      result.extractedStyleJson = extractedStyleJson;
    if (linkToContinuityPack != null)
      result.linkToContinuityPack = linkToContinuityPack;
    return result;
  }

  StylePackServiceCreateRequest._();

  factory StylePackServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory StylePackServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceCreateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'sourceAssetId')
    ..aOS(4, _omitFieldNames ? '' : 'extractedStyleJson')
    ..aOB(5, _omitFieldNames ? '' : 'linkToContinuityPack')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceCreateRequest copyWith(
          void Function(StylePackServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceCreateRequest))
          as StylePackServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceCreateRequest() / StylePackServiceCreateRequest.new instead')
  static StylePackServiceCreateRequest create() =>
      StylePackServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceCreateRequest._();
  @$core.override
  StylePackServiceCreateRequest createEmptyInstance() =>
      StylePackServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceCreateRequest>(
          StylePackServiceCreateRequest.$_createMessage);
  static StylePackServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceAssetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceAssetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get extractedStyleJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set extractedStyleJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExtractedStyleJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearExtractedStyleJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get linkToContinuityPack => $_getBF(4);
  @$pb.TagNumber(5)
  set linkToContinuityPack($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLinkToContinuityPack() => $_has(4);
  @$pb.TagNumber(5)
  void clearLinkToContinuityPack() => $_clearField(5);
}

class StylePackServiceCreateResponse extends $pb.GeneratedMessage {
  factory StylePackServiceCreateResponse({
    StylePack? stylePack,
    $core.String? continuityPackId,
  }) {
    final result = StylePackServiceCreateResponse._();
    if (stylePack != null) result.stylePack = stylePack;
    if (continuityPackId != null) result.continuityPackId = continuityPackId;
    return result;
  }

  StylePackServiceCreateResponse._();

  factory StylePackServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory StylePackServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceCreateResponse.$_createMessage)
    ..aOM<StylePack>(1, _omitFieldNames ? '' : 'stylePack',
        subBuilder: StylePack.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'continuityPackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceCreateResponse copyWith(
          void Function(StylePackServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceCreateResponse))
          as StylePackServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceCreateResponse() / StylePackServiceCreateResponse.new instead')
  static StylePackServiceCreateResponse create() =>
      StylePackServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceCreateResponse._();
  @$core.override
  StylePackServiceCreateResponse createEmptyInstance() =>
      StylePackServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceCreateResponse>(
          StylePackServiceCreateResponse.$_createMessage);
  static StylePackServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StylePack get stylePack => $_getN(0);
  @$pb.TagNumber(1)
  set stylePack(StylePack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStylePack() => $_has(0);
  @$pb.TagNumber(1)
  void clearStylePack() => $_clearField(1);
  @$pb.TagNumber(1)
  StylePack ensureStylePack() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get continuityPackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set continuityPackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContinuityPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearContinuityPackId() => $_clearField(2);
}

class StylePackServiceGetRequest extends $pb.GeneratedMessage {
  factory StylePackServiceGetRequest({
    $2.UUID? workspaceId,
    $core.String? stylePackId,
  }) {
    final result = StylePackServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (stylePackId != null) result.stylePackId = stylePackId;
    return result;
  }

  StylePackServiceGetRequest._();

  factory StylePackServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceGetRequest()..mergeFromBuffer(data, registry);
  factory StylePackServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceGetRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'stylePackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceGetRequest copyWith(
          void Function(StylePackServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceGetRequest))
          as StylePackServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceGetRequest() / StylePackServiceGetRequest.new instead')
  static StylePackServiceGetRequest create() => StylePackServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceGetRequest._();
  @$core.override
  StylePackServiceGetRequest createEmptyInstance() =>
      StylePackServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceGetRequest>(
          StylePackServiceGetRequest.$_createMessage);
  static StylePackServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get stylePackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set stylePackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStylePackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStylePackId() => $_clearField(2);
}

class StylePackServiceGetResponse extends $pb.GeneratedMessage {
  factory StylePackServiceGetResponse({
    StylePack? stylePack,
    StyleElements? elements,
  }) {
    final result = StylePackServiceGetResponse._();
    if (stylePack != null) result.stylePack = stylePack;
    if (elements != null) result.elements = elements;
    return result;
  }

  StylePackServiceGetResponse._();

  factory StylePackServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceGetResponse()..mergeFromBuffer(data, registry);
  factory StylePackServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceGetResponse.$_createMessage)
    ..aOM<StylePack>(1, _omitFieldNames ? '' : 'stylePack',
        subBuilder: StylePack.$_createMessage)
    ..aOM<StyleElements>(2, _omitFieldNames ? '' : 'elements',
        subBuilder: StyleElements.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceGetResponse copyWith(
          void Function(StylePackServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceGetResponse))
          as StylePackServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceGetResponse() / StylePackServiceGetResponse.new instead')
  static StylePackServiceGetResponse create() =>
      StylePackServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceGetResponse._();
  @$core.override
  StylePackServiceGetResponse createEmptyInstance() =>
      StylePackServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceGetResponse>(
          StylePackServiceGetResponse.$_createMessage);
  static StylePackServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StylePack get stylePack => $_getN(0);
  @$pb.TagNumber(1)
  set stylePack(StylePack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStylePack() => $_has(0);
  @$pb.TagNumber(1)
  void clearStylePack() => $_clearField(1);
  @$pb.TagNumber(1)
  StylePack ensureStylePack() => $_ensure(0);

  @$pb.TagNumber(2)
  StyleElements get elements => $_getN(1);
  @$pb.TagNumber(2)
  set elements(StyleElements value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasElements() => $_has(1);
  @$pb.TagNumber(2)
  void clearElements() => $_clearField(2);
  @$pb.TagNumber(2)
  StyleElements ensureElements() => $_ensure(1);
}

class StylePackServiceListRequest extends $pb.GeneratedMessage {
  factory StylePackServiceListRequest({
    $2.UUID? workspaceId,
    $2.Pagination? pagination,
  }) {
    final result = StylePackServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  StylePackServiceListRequest._();

  factory StylePackServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceListRequest()..mergeFromBuffer(data, registry);
  factory StylePackServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceListRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceListRequest copyWith(
          void Function(StylePackServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceListRequest))
          as StylePackServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceListRequest() / StylePackServiceListRequest.new instead')
  static StylePackServiceListRequest create() =>
      StylePackServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceListRequest._();
  @$core.override
  StylePackServiceListRequest createEmptyInstance() =>
      StylePackServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceListRequest>(
          StylePackServiceListRequest.$_createMessage);
  static StylePackServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);
}

class StylePackServiceListResponse extends $pb.GeneratedMessage {
  factory StylePackServiceListResponse({
    $core.Iterable<StylePack>? stylePacks,
    $2.PaginatedResponse? pagination,
  }) {
    final result = StylePackServiceListResponse._();
    if (stylePacks != null) result.stylePacks.addAll(stylePacks);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  StylePackServiceListResponse._();

  factory StylePackServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceListResponse()..mergeFromBuffer(data, registry);
  factory StylePackServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceListResponse.$_createMessage)
    ..pPM<StylePack>(1, _omitFieldNames ? '' : 'stylePacks',
        subBuilder: StylePack.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceListResponse copyWith(
          void Function(StylePackServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceListResponse))
          as StylePackServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceListResponse() / StylePackServiceListResponse.new instead')
  static StylePackServiceListResponse create() =>
      StylePackServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceListResponse._();
  @$core.override
  StylePackServiceListResponse createEmptyInstance() =>
      StylePackServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceListResponse>(
          StylePackServiceListResponse.$_createMessage);
  static StylePackServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StylePack> get stylePacks => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class StylePackServiceApplyRequest extends $pb.GeneratedMessage {
  factory StylePackServiceApplyRequest({
    $2.CommandContext? context,
    $core.String? stylePackId,
    $core.String? targetJobId,
    $core.String? targetMode,
  }) {
    final result = StylePackServiceApplyRequest._();
    if (context != null) result.context = context;
    if (stylePackId != null) result.stylePackId = stylePackId;
    if (targetJobId != null) result.targetJobId = targetJobId;
    if (targetMode != null) result.targetMode = targetMode;
    return result;
  }

  StylePackServiceApplyRequest._();

  factory StylePackServiceApplyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceApplyRequest()..mergeFromBuffer(data, registry);
  factory StylePackServiceApplyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceApplyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceApplyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceApplyRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'stylePackId')
    ..aOS(3, _omitFieldNames ? '' : 'targetJobId')
    ..aOS(4, _omitFieldNames ? '' : 'targetMode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceApplyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceApplyRequest copyWith(
          void Function(StylePackServiceApplyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceApplyRequest))
          as StylePackServiceApplyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceApplyRequest() / StylePackServiceApplyRequest.new instead')
  static StylePackServiceApplyRequest create() =>
      StylePackServiceApplyRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceApplyRequest._();
  @$core.override
  StylePackServiceApplyRequest createEmptyInstance() =>
      StylePackServiceApplyRequest._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceApplyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceApplyRequest>(
          StylePackServiceApplyRequest.$_createMessage);
  static StylePackServiceApplyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get stylePackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set stylePackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStylePackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStylePackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetJobId => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetJobId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetJobId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetJobId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetMode => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetMode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetMode() => $_clearField(4);
}

class StylePackServiceApplyResponse extends $pb.GeneratedMessage {
  factory StylePackServiceApplyResponse({
    $core.bool? success,
    $core.String? message,
    $core.String? stylePackId,
    $core.String? targetJobId,
  }) {
    final result = StylePackServiceApplyResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    if (stylePackId != null) result.stylePackId = stylePackId;
    if (targetJobId != null) result.targetJobId = targetJobId;
    return result;
  }

  StylePackServiceApplyResponse._();

  factory StylePackServiceApplyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceApplyResponse()..mergeFromBuffer(data, registry);
  factory StylePackServiceApplyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceApplyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceApplyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceApplyResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'stylePackId')
    ..aOS(4, _omitFieldNames ? '' : 'targetJobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceApplyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceApplyResponse copyWith(
          void Function(StylePackServiceApplyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceApplyResponse))
          as StylePackServiceApplyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceApplyResponse() / StylePackServiceApplyResponse.new instead')
  static StylePackServiceApplyResponse create() =>
      StylePackServiceApplyResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceApplyResponse._();
  @$core.override
  StylePackServiceApplyResponse createEmptyInstance() =>
      StylePackServiceApplyResponse._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceApplyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceApplyResponse>(
          StylePackServiceApplyResponse.$_createMessage);
  static StylePackServiceApplyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get stylePackId => $_getSZ(2);
  @$pb.TagNumber(3)
  set stylePackId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStylePackId() => $_has(2);
  @$pb.TagNumber(3)
  void clearStylePackId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetJobId => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetJobId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetJobId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetJobId() => $_clearField(4);
}

class StylePackServiceDeleteRequest extends $pb.GeneratedMessage {
  factory StylePackServiceDeleteRequest({
    $2.CommandContext? context,
    $core.String? stylePackId,
  }) {
    final result = StylePackServiceDeleteRequest._();
    if (context != null) result.context = context;
    if (stylePackId != null) result.stylePackId = stylePackId;
    return result;
  }

  StylePackServiceDeleteRequest._();

  factory StylePackServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory StylePackServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceDeleteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'stylePackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceDeleteRequest copyWith(
          void Function(StylePackServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceDeleteRequest))
          as StylePackServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceDeleteRequest() / StylePackServiceDeleteRequest.new instead')
  static StylePackServiceDeleteRequest create() =>
      StylePackServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceDeleteRequest._();
  @$core.override
  StylePackServiceDeleteRequest createEmptyInstance() =>
      StylePackServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceDeleteRequest>(
          StylePackServiceDeleteRequest.$_createMessage);
  static StylePackServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get stylePackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set stylePackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStylePackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStylePackId() => $_clearField(2);
}

class StylePackServiceDeleteResponse extends $pb.GeneratedMessage {
  factory StylePackServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = StylePackServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  StylePackServiceDeleteResponse._();

  factory StylePackServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory StylePackServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StylePackServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StylePackServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: StylePackServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StylePackServiceDeleteResponse copyWith(
          void Function(StylePackServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StylePackServiceDeleteResponse))
          as StylePackServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StylePackServiceDeleteResponse() / StylePackServiceDeleteResponse.new instead')
  static StylePackServiceDeleteResponse create() =>
      StylePackServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StylePackServiceDeleteResponse._();
  @$core.override
  StylePackServiceDeleteResponse createEmptyInstance() =>
      StylePackServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static StylePackServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StylePackServiceDeleteResponse>(
          StylePackServiceDeleteResponse.$_createMessage);
  static StylePackServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// AIService Request/Response Messages
class GenerateCharacterPreviewRequest extends $pb.GeneratedMessage {
  factory GenerateCharacterPreviewRequest({
    $2.CommandContext? context,
    $core.String? characterId,
    $core.String? visualPrompt,
    $core.String? voiceSampleUrl,
    $core.String? aspectRatio,
    $core.int? durationSeconds,
  }) {
    final result = GenerateCharacterPreviewRequest._();
    if (context != null) result.context = context;
    if (characterId != null) result.characterId = characterId;
    if (visualPrompt != null) result.visualPrompt = visualPrompt;
    if (voiceSampleUrl != null) result.voiceSampleUrl = voiceSampleUrl;
    if (aspectRatio != null) result.aspectRatio = aspectRatio;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    return result;
  }

  GenerateCharacterPreviewRequest._();

  factory GenerateCharacterPreviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateCharacterPreviewRequest()..mergeFromBuffer(data, registry);
  factory GenerateCharacterPreviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateCharacterPreviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerateCharacterPreviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GenerateCharacterPreviewRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'characterId')
    ..aOS(3, _omitFieldNames ? '' : 'visualPrompt')
    ..aOS(4, _omitFieldNames ? '' : 'voiceSampleUrl')
    ..aOS(5, _omitFieldNames ? '' : 'aspectRatio')
    ..aI(6, _omitFieldNames ? '' : 'durationSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateCharacterPreviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateCharacterPreviewRequest copyWith(
          void Function(GenerateCharacterPreviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GenerateCharacterPreviewRequest))
          as GenerateCharacterPreviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GenerateCharacterPreviewRequest() / GenerateCharacterPreviewRequest.new instead')
  static GenerateCharacterPreviewRequest create() =>
      GenerateCharacterPreviewRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GenerateCharacterPreviewRequest._();
  @$core.override
  GenerateCharacterPreviewRequest createEmptyInstance() =>
      GenerateCharacterPreviewRequest._();
  @$core.pragma('dart2js:noInline')
  static GenerateCharacterPreviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenerateCharacterPreviewRequest>(
          GenerateCharacterPreviewRequest.$_createMessage);
  static GenerateCharacterPreviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get characterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set characterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCharacterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get visualPrompt => $_getSZ(2);
  @$pb.TagNumber(3)
  set visualPrompt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVisualPrompt() => $_has(2);
  @$pb.TagNumber(3)
  void clearVisualPrompt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get voiceSampleUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set voiceSampleUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVoiceSampleUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearVoiceSampleUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get aspectRatio => $_getSZ(4);
  @$pb.TagNumber(5)
  set aspectRatio($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAspectRatio() => $_has(4);
  @$pb.TagNumber(5)
  void clearAspectRatio() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get durationSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set durationSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDurationSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearDurationSeconds() => $_clearField(6);
}

class GenerateCharacterPreviewResponse extends $pb.GeneratedMessage {
  factory GenerateCharacterPreviewResponse({
    $core.String? previewAssetId,
    $core.String? previewUrl,
    $core.int? durationSeconds,
    $core.String? creditsUsed,
    $core.bool? verified,
    $core.String? characterId,
  }) {
    final result = GenerateCharacterPreviewResponse._();
    if (previewAssetId != null) result.previewAssetId = previewAssetId;
    if (previewUrl != null) result.previewUrl = previewUrl;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (creditsUsed != null) result.creditsUsed = creditsUsed;
    if (verified != null) result.verified = verified;
    if (characterId != null) result.characterId = characterId;
    return result;
  }

  GenerateCharacterPreviewResponse._();

  factory GenerateCharacterPreviewResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateCharacterPreviewResponse()..mergeFromBuffer(data, registry);
  factory GenerateCharacterPreviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GenerateCharacterPreviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenerateCharacterPreviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: GenerateCharacterPreviewResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'previewAssetId')
    ..aOS(2, _omitFieldNames ? '' : 'previewUrl')
    ..aI(3, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(4, _omitFieldNames ? '' : 'creditsUsed')
    ..aOB(5, _omitFieldNames ? '' : 'verified')
    ..aOS(6, _omitFieldNames ? '' : 'characterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateCharacterPreviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenerateCharacterPreviewResponse copyWith(
          void Function(GenerateCharacterPreviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GenerateCharacterPreviewResponse))
          as GenerateCharacterPreviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GenerateCharacterPreviewResponse() / GenerateCharacterPreviewResponse.new instead')
  static GenerateCharacterPreviewResponse create() =>
      GenerateCharacterPreviewResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GenerateCharacterPreviewResponse._();
  @$core.override
  GenerateCharacterPreviewResponse createEmptyInstance() =>
      GenerateCharacterPreviewResponse._();
  @$core.pragma('dart2js:noInline')
  static GenerateCharacterPreviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenerateCharacterPreviewResponse>(
          GenerateCharacterPreviewResponse.$_createMessage);
  static GenerateCharacterPreviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get previewAssetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set previewAssetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPreviewAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreviewAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get previewUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set previewUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPreviewUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreviewUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get durationSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set durationSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creditsUsed => $_getSZ(3);
  @$pb.TagNumber(4)
  set creditsUsed($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreditsUsed() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreditsUsed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get verified => $_getBF(4);
  @$pb.TagNumber(5)
  set verified($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVerified() => $_has(4);
  @$pb.TagNumber(5)
  void clearVerified() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get characterId => $_getSZ(5);
  @$pb.TagNumber(6)
  set characterId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCharacterId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCharacterId() => $_clearField(6);
}

class QuoteCharacterPreviewRequest extends $pb.GeneratedMessage {
  factory QuoteCharacterPreviewRequest({
    $2.UUID? workspaceId,
    $core.String? characterId,
    $core.int? durationSeconds,
  }) {
    final result = QuoteCharacterPreviewRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (characterId != null) result.characterId = characterId;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    return result;
  }

  QuoteCharacterPreviewRequest._();

  factory QuoteCharacterPreviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuoteCharacterPreviewRequest()..mergeFromBuffer(data, registry);
  factory QuoteCharacterPreviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuoteCharacterPreviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuoteCharacterPreviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: QuoteCharacterPreviewRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'characterId')
    ..aI(3, _omitFieldNames ? '' : 'durationSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuoteCharacterPreviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuoteCharacterPreviewRequest copyWith(
          void Function(QuoteCharacterPreviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as QuoteCharacterPreviewRequest))
          as QuoteCharacterPreviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use QuoteCharacterPreviewRequest() / QuoteCharacterPreviewRequest.new instead')
  static QuoteCharacterPreviewRequest create() =>
      QuoteCharacterPreviewRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      QuoteCharacterPreviewRequest._();
  @$core.override
  QuoteCharacterPreviewRequest createEmptyInstance() =>
      QuoteCharacterPreviewRequest._();
  @$core.pragma('dart2js:noInline')
  static QuoteCharacterPreviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuoteCharacterPreviewRequest>(
          QuoteCharacterPreviewRequest.$_createMessage);
  static QuoteCharacterPreviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get characterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set characterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCharacterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get durationSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set durationSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationSeconds() => $_clearField(3);
}

class QuoteCharacterPreviewResponse extends $pb.GeneratedMessage {
  factory QuoteCharacterPreviewResponse({
    $core.String? quoteId,
    $core.String? creditsRequired,
    $core.int? durationSeconds,
    $core.String? provider,
    $core.bool? canAfford,
  }) {
    final result = QuoteCharacterPreviewResponse._();
    if (quoteId != null) result.quoteId = quoteId;
    if (creditsRequired != null) result.creditsRequired = creditsRequired;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (provider != null) result.provider = provider;
    if (canAfford != null) result.canAfford = canAfford;
    return result;
  }

  QuoteCharacterPreviewResponse._();

  factory QuoteCharacterPreviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuoteCharacterPreviewResponse()..mergeFromBuffer(data, registry);
  factory QuoteCharacterPreviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuoteCharacterPreviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuoteCharacterPreviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: QuoteCharacterPreviewResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'quoteId')
    ..aOS(2, _omitFieldNames ? '' : 'creditsRequired')
    ..aI(3, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(4, _omitFieldNames ? '' : 'provider')
    ..aOB(5, _omitFieldNames ? '' : 'canAfford')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuoteCharacterPreviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuoteCharacterPreviewResponse copyWith(
          void Function(QuoteCharacterPreviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as QuoteCharacterPreviewResponse))
          as QuoteCharacterPreviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use QuoteCharacterPreviewResponse() / QuoteCharacterPreviewResponse.new instead')
  static QuoteCharacterPreviewResponse create() =>
      QuoteCharacterPreviewResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      QuoteCharacterPreviewResponse._();
  @$core.override
  QuoteCharacterPreviewResponse createEmptyInstance() =>
      QuoteCharacterPreviewResponse._();
  @$core.pragma('dart2js:noInline')
  static QuoteCharacterPreviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuoteCharacterPreviewResponse>(
          QuoteCharacterPreviewResponse.$_createMessage);
  static QuoteCharacterPreviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get quoteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set quoteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuoteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get creditsRequired => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsRequired($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsRequired() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsRequired() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get durationSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set durationSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get provider => $_getSZ(3);
  @$pb.TagNumber(4)
  set provider($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProvider() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvider() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get canAfford => $_getBF(4);
  @$pb.TagNumber(5)
  set canAfford($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCanAfford() => $_has(4);
  @$pb.TagNumber(5)
  void clearCanAfford() => $_clearField(5);
}

class AnalyzeStyleRequest extends $pb.GeneratedMessage {
  factory AnalyzeStyleRequest({
    $2.CommandContext? context,
    $core.Iterable<$core.String>? assetIds,
  }) {
    final result = AnalyzeStyleRequest._();
    if (context != null) result.context = context;
    if (assetIds != null) result.assetIds.addAll(assetIds);
    return result;
  }

  AnalyzeStyleRequest._();

  factory AnalyzeStyleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnalyzeStyleRequest()..mergeFromBuffer(data, registry);
  factory AnalyzeStyleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnalyzeStyleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnalyzeStyleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: AnalyzeStyleRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'assetIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeStyleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeStyleRequest copyWith(void Function(AnalyzeStyleRequest) updates) =>
      super.copyWith((message) => updates(message as AnalyzeStyleRequest))
          as AnalyzeStyleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use AnalyzeStyleRequest() / AnalyzeStyleRequest.new instead')
  static AnalyzeStyleRequest create() => AnalyzeStyleRequest._();
  static $pb.GeneratedMessage $_createMessage() => AnalyzeStyleRequest._();
  @$core.override
  AnalyzeStyleRequest createEmptyInstance() => AnalyzeStyleRequest._();
  @$core.pragma('dart2js:noInline')
  static AnalyzeStyleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnalyzeStyleRequest>(
          AnalyzeStyleRequest.$_createMessage);
  static AnalyzeStyleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get assetIds => $_getList(1);
}

class AnalyzeStyleResponse extends $pb.GeneratedMessage {
  factory AnalyzeStyleResponse({
    StyleElements? styleElements,
    $core.String? creditsUsed,
  }) {
    final result = AnalyzeStyleResponse._();
    if (styleElements != null) result.styleElements = styleElements;
    if (creditsUsed != null) result.creditsUsed = creditsUsed;
    return result;
  }

  AnalyzeStyleResponse._();

  factory AnalyzeStyleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnalyzeStyleResponse()..mergeFromBuffer(data, registry);
  factory AnalyzeStyleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnalyzeStyleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnalyzeStyleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: AnalyzeStyleResponse.$_createMessage)
    ..aOM<StyleElements>(1, _omitFieldNames ? '' : 'styleElements',
        subBuilder: StyleElements.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'creditsUsed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeStyleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeStyleResponse copyWith(void Function(AnalyzeStyleResponse) updates) =>
      super.copyWith((message) => updates(message as AnalyzeStyleResponse))
          as AnalyzeStyleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AnalyzeStyleResponse() / AnalyzeStyleResponse.new instead')
  static AnalyzeStyleResponse create() => AnalyzeStyleResponse._();
  static $pb.GeneratedMessage $_createMessage() => AnalyzeStyleResponse._();
  @$core.override
  AnalyzeStyleResponse createEmptyInstance() => AnalyzeStyleResponse._();
  @$core.pragma('dart2js:noInline')
  static AnalyzeStyleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnalyzeStyleResponse>(
          AnalyzeStyleResponse.$_createMessage);
  static AnalyzeStyleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StyleElements get styleElements => $_getN(0);
  @$pb.TagNumber(1)
  set styleElements(StyleElements value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStyleElements() => $_has(0);
  @$pb.TagNumber(1)
  void clearStyleElements() => $_clearField(1);
  @$pb.TagNumber(1)
  StyleElements ensureStyleElements() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get creditsUsed => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsUsed($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsUsed() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsUsed() => $_clearField(2);
}

/// Drift QA Messages
class DriftEvaluationResult extends $pb.GeneratedMessage {
  factory DriftEvaluationResult({
    $core.String? assetId,
    $core.String? packId,
    $core.int? packVersion,
    $core.double? driftScore,
    $core.String? driftSeverity,
    $core.bool? isBlocked,
    $core.Iterable<$core.String>? violationReasons,
    $core.String? detailsJson,
    $core.String? violationId,
  }) {
    final result = DriftEvaluationResult._();
    if (assetId != null) result.assetId = assetId;
    if (packId != null) result.packId = packId;
    if (packVersion != null) result.packVersion = packVersion;
    if (driftScore != null) result.driftScore = driftScore;
    if (driftSeverity != null) result.driftSeverity = driftSeverity;
    if (isBlocked != null) result.isBlocked = isBlocked;
    if (violationReasons != null)
      result.violationReasons.addAll(violationReasons);
    if (detailsJson != null) result.detailsJson = detailsJson;
    if (violationId != null) result.violationId = violationId;
    return result;
  }

  DriftEvaluationResult._();

  factory DriftEvaluationResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DriftEvaluationResult()..mergeFromBuffer(data, registry);
  factory DriftEvaluationResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DriftEvaluationResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DriftEvaluationResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: DriftEvaluationResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..aI(3, _omitFieldNames ? '' : 'packVersion')
    ..aD(4, _omitFieldNames ? '' : 'driftScore', fieldType: $pb.PbFieldType.OF)
    ..aOS(5, _omitFieldNames ? '' : 'driftSeverity')
    ..aOB(6, _omitFieldNames ? '' : 'isBlocked')
    ..pPS(7, _omitFieldNames ? '' : 'violationReasons')
    ..aOS(8, _omitFieldNames ? '' : 'detailsJson')
    ..aOS(9, _omitFieldNames ? '' : 'violationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DriftEvaluationResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DriftEvaluationResult copyWith(
          void Function(DriftEvaluationResult) updates) =>
      super.copyWith((message) => updates(message as DriftEvaluationResult))
          as DriftEvaluationResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DriftEvaluationResult() / DriftEvaluationResult.new instead')
  static DriftEvaluationResult create() => DriftEvaluationResult._();
  static $pb.GeneratedMessage $_createMessage() => DriftEvaluationResult._();
  @$core.override
  DriftEvaluationResult createEmptyInstance() => DriftEvaluationResult._();
  @$core.pragma('dart2js:noInline')
  static DriftEvaluationResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DriftEvaluationResult>(
          DriftEvaluationResult.$_createMessage);
  static DriftEvaluationResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get packVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set packVersion($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPackVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearPackVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get driftScore => $_getN(3);
  @$pb.TagNumber(4)
  set driftScore($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDriftScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearDriftScore() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get driftSeverity => $_getSZ(4);
  @$pb.TagNumber(5)
  set driftSeverity($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDriftSeverity() => $_has(4);
  @$pb.TagNumber(5)
  void clearDriftSeverity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isBlocked => $_getBF(5);
  @$pb.TagNumber(6)
  set isBlocked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsBlocked() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsBlocked() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get violationReasons => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get detailsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set detailsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDetailsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearDetailsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get violationId => $_getSZ(8);
  @$pb.TagNumber(9)
  set violationId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasViolationId() => $_has(8);
  @$pb.TagNumber(9)
  void clearViolationId() => $_clearField(9);
}

class EvaluateDriftRequest extends $pb.GeneratedMessage {
  factory EvaluateDriftRequest({
    $2.CommandContext? context,
    $core.String? assetId,
    $core.String? packId,
  }) {
    final result = EvaluateDriftRequest._();
    if (context != null) result.context = context;
    if (assetId != null) result.assetId = assetId;
    if (packId != null) result.packId = packId;
    return result;
  }

  EvaluateDriftRequest._();

  factory EvaluateDriftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateDriftRequest()..mergeFromBuffer(data, registry);
  factory EvaluateDriftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateDriftRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateDriftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: EvaluateDriftRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'packId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateDriftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateDriftRequest copyWith(void Function(EvaluateDriftRequest) updates) =>
      super.copyWith((message) => updates(message as EvaluateDriftRequest))
          as EvaluateDriftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EvaluateDriftRequest() / EvaluateDriftRequest.new instead')
  static EvaluateDriftRequest create() => EvaluateDriftRequest._();
  static $pb.GeneratedMessage $_createMessage() => EvaluateDriftRequest._();
  @$core.override
  EvaluateDriftRequest createEmptyInstance() => EvaluateDriftRequest._();
  @$core.pragma('dart2js:noInline')
  static EvaluateDriftRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateDriftRequest>(
          EvaluateDriftRequest.$_createMessage);
  static EvaluateDriftRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get packId => $_getSZ(2);
  @$pb.TagNumber(3)
  set packId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPackId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPackId() => $_clearField(3);
}

class EvaluateDriftResponse extends $pb.GeneratedMessage {
  factory EvaluateDriftResponse({
    DriftEvaluationResult? result,
  }) {
    final result$ = EvaluateDriftResponse._();
    if (result != null) result$.result = result;
    return result$;
  }

  EvaluateDriftResponse._();

  factory EvaluateDriftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateDriftResponse()..mergeFromBuffer(data, registry);
  factory EvaluateDriftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvaluateDriftResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateDriftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: EvaluateDriftResponse.$_createMessage)
    ..aOM<DriftEvaluationResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: DriftEvaluationResult.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateDriftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateDriftResponse copyWith(
          void Function(EvaluateDriftResponse) updates) =>
      super.copyWith((message) => updates(message as EvaluateDriftResponse))
          as EvaluateDriftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EvaluateDriftResponse() / EvaluateDriftResponse.new instead')
  static EvaluateDriftResponse create() => EvaluateDriftResponse._();
  static $pb.GeneratedMessage $_createMessage() => EvaluateDriftResponse._();
  @$core.override
  EvaluateDriftResponse createEmptyInstance() => EvaluateDriftResponse._();
  @$core.pragma('dart2js:noInline')
  static EvaluateDriftResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateDriftResponse>(
          EvaluateDriftResponse.$_createMessage);
  static EvaluateDriftResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DriftEvaluationResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(DriftEvaluationResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  DriftEvaluationResult ensureResult() => $_ensure(0);
}

class OverrideDriftViolationRequest extends $pb.GeneratedMessage {
  factory OverrideDriftViolationRequest({
    $2.CommandContext? context,
    $core.String? violationId,
    $core.String? overrideReason,
  }) {
    final result = OverrideDriftViolationRequest._();
    if (context != null) result.context = context;
    if (violationId != null) result.violationId = violationId;
    if (overrideReason != null) result.overrideReason = overrideReason;
    return result;
  }

  OverrideDriftViolationRequest._();

  factory OverrideDriftViolationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OverrideDriftViolationRequest()..mergeFromBuffer(data, registry);
  factory OverrideDriftViolationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OverrideDriftViolationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideDriftViolationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: OverrideDriftViolationRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'violationId')
    ..aOS(3, _omitFieldNames ? '' : 'overrideReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideDriftViolationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideDriftViolationRequest copyWith(
          void Function(OverrideDriftViolationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OverrideDriftViolationRequest))
          as OverrideDriftViolationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OverrideDriftViolationRequest() / OverrideDriftViolationRequest.new instead')
  static OverrideDriftViolationRequest create() =>
      OverrideDriftViolationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OverrideDriftViolationRequest._();
  @$core.override
  OverrideDriftViolationRequest createEmptyInstance() =>
      OverrideDriftViolationRequest._();
  @$core.pragma('dart2js:noInline')
  static OverrideDriftViolationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideDriftViolationRequest>(
          OverrideDriftViolationRequest.$_createMessage);
  static OverrideDriftViolationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get violationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set violationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasViolationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearViolationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get overrideReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set overrideReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverrideReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverrideReason() => $_clearField(3);
}

class OverrideDriftViolationResponse extends $pb.GeneratedMessage {
  factory OverrideDriftViolationResponse({
    $core.bool? resolved,
    $core.String? assetId,
    $core.String? newQualityState,
  }) {
    final result = OverrideDriftViolationResponse._();
    if (resolved != null) result.resolved = resolved;
    if (assetId != null) result.assetId = assetId;
    if (newQualityState != null) result.newQualityState = newQualityState;
    return result;
  }

  OverrideDriftViolationResponse._();

  factory OverrideDriftViolationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OverrideDriftViolationResponse()..mergeFromBuffer(data, registry);
  factory OverrideDriftViolationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OverrideDriftViolationResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideDriftViolationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.production.v1'),
      createEmptyInstance: OverrideDriftViolationResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'resolved')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'newQualityState')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideDriftViolationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideDriftViolationResponse copyWith(
          void Function(OverrideDriftViolationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OverrideDriftViolationResponse))
          as OverrideDriftViolationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OverrideDriftViolationResponse() / OverrideDriftViolationResponse.new instead')
  static OverrideDriftViolationResponse create() =>
      OverrideDriftViolationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OverrideDriftViolationResponse._();
  @$core.override
  OverrideDriftViolationResponse createEmptyInstance() =>
      OverrideDriftViolationResponse._();
  @$core.pragma('dart2js:noInline')
  static OverrideDriftViolationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideDriftViolationResponse>(
          OverrideDriftViolationResponse.$_createMessage);
  static OverrideDriftViolationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get resolved => $_getBF(0);
  @$pb.TagNumber(1)
  set resolved($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResolved() => $_has(0);
  @$pb.TagNumber(1)
  void clearResolved() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newQualityState => $_getSZ(2);
  @$pb.TagNumber(3)
  set newQualityState($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewQualityState() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewQualityState() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

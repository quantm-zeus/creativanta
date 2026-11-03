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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

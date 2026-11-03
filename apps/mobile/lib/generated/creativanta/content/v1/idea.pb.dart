// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/idea.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import '../../intelligence/v1/trend.pbenum.dart' as $2;
import 'idea.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'idea.pbenum.dart';

/// IdeaSourceRef represents an origin link via idea_sources junction per database_schema.md §6.2.
class IdeaSourceRef extends $pb.GeneratedMessage {
  factory IdeaSourceRef({
    $core.String? sourceType,
    $core.String? sourceId,
    $core.String? sourceTitle,
    $core.String? sourceUrl,
    $core.bool? isArchived,
    $core.String? archiveNotice,
  }) {
    final result = IdeaSourceRef._();
    if (sourceType != null) result.sourceType = sourceType;
    if (sourceId != null) result.sourceId = sourceId;
    if (sourceTitle != null) result.sourceTitle = sourceTitle;
    if (sourceUrl != null) result.sourceUrl = sourceUrl;
    if (isArchived != null) result.isArchived = isArchived;
    if (archiveNotice != null) result.archiveNotice = archiveNotice;
    return result;
  }

  IdeaSourceRef._();

  factory IdeaSourceRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaSourceRef()..mergeFromBuffer(data, registry);
  factory IdeaSourceRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaSourceRef()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaSourceRef',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaSourceRef.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sourceType')
    ..aOS(2, _omitFieldNames ? '' : 'sourceId')
    ..aOS(3, _omitFieldNames ? '' : 'sourceTitle')
    ..aOS(4, _omitFieldNames ? '' : 'sourceUrl')
    ..aOB(5, _omitFieldNames ? '' : 'isArchived')
    ..aOS(6, _omitFieldNames ? '' : 'archiveNotice')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaSourceRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaSourceRef copyWith(void Function(IdeaSourceRef) updates) =>
      super.copyWith((message) => updates(message as IdeaSourceRef))
          as IdeaSourceRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IdeaSourceRef() / IdeaSourceRef.new instead')
  static IdeaSourceRef create() => IdeaSourceRef._();
  static $pb.GeneratedMessage $_createMessage() => IdeaSourceRef._();
  @$core.override
  IdeaSourceRef createEmptyInstance() => IdeaSourceRef._();
  @$core.pragma('dart2js:noInline')
  static IdeaSourceRef getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IdeaSourceRef>(
          IdeaSourceRef.$_createMessage);
  static IdeaSourceRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sourceType => $_getSZ(0);
  @$pb.TagNumber(1)
  set sourceType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isArchived => $_getBF(4);
  @$pb.TagNumber(5)
  set isArchived($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsArchived() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsArchived() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get archiveNotice => $_getSZ(5);
  @$pb.TagNumber(6)
  set archiveNotice($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasArchiveNotice() => $_has(5);
  @$pb.TagNumber(6)
  void clearArchiveNotice() => $_clearField(6);
}

/// Hook represents an intro hook associated with an idea per database_schema.md §6.3.
class Hook extends $pb.GeneratedMessage {
  factory Hook({
    $core.String? hookId,
    $core.String? workspaceId,
    $core.String? ideaId,
    $core.String? hookText,
    HookType? hookType,
    $core.double? effectivenessScore,
    $core.int? usageCount,
    HookSource? source,
    $1.Timestamp? createdAt,
  }) {
    final result = Hook._();
    if (hookId != null) result.hookId = hookId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaId != null) result.ideaId = ideaId;
    if (hookText != null) result.hookText = hookText;
    if (hookType != null) result.hookType = hookType;
    if (effectivenessScore != null)
      result.effectivenessScore = effectivenessScore;
    if (usageCount != null) result.usageCount = usageCount;
    if (source != null) result.source = source;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Hook._();

  factory Hook.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Hook()..mergeFromBuffer(data, registry);
  factory Hook.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Hook()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Hook',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: Hook.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'hookId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'ideaId')
    ..aOS(4, _omitFieldNames ? '' : 'hookText')
    ..aE<HookType>(5, _omitFieldNames ? '' : 'hookType',
        enumValues: HookType.values)
    ..aD(6, _omitFieldNames ? '' : 'effectivenessScore',
        fieldType: $pb.PbFieldType.OF)
    ..aI(7, _omitFieldNames ? '' : 'usageCount')
    ..aE<HookSource>(8, _omitFieldNames ? '' : 'source',
        enumValues: HookSource.values)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hook clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hook copyWith(void Function(Hook) updates) =>
      super.copyWith((message) => updates(message as Hook)) as Hook;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Hook() / Hook.new instead')
  static Hook create() => Hook._();
  static $pb.GeneratedMessage $_createMessage() => Hook._();
  @$core.override
  Hook createEmptyInstance() => Hook._();
  @$core.pragma('dart2js:noInline')
  static Hook getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Hook>(Hook.$_createMessage);
  static Hook? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set hookId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHookId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ideaId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ideaId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdeaId() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdeaId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get hookText => $_getSZ(3);
  @$pb.TagNumber(4)
  set hookText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHookText() => $_has(3);
  @$pb.TagNumber(4)
  void clearHookText() => $_clearField(4);

  @$pb.TagNumber(5)
  HookType get hookType => $_getN(4);
  @$pb.TagNumber(5)
  set hookType(HookType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasHookType() => $_has(4);
  @$pb.TagNumber(5)
  void clearHookType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get effectivenessScore => $_getN(5);
  @$pb.TagNumber(6)
  set effectivenessScore($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEffectivenessScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearEffectivenessScore() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get usageCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set usageCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUsageCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearUsageCount() => $_clearField(7);

  @$pb.TagNumber(8)
  HookSource get source => $_getN(7);
  @$pb.TagNumber(8)
  set source(HookSource value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSource() => $_has(7);
  @$pb.TagNumber(8)
  void clearSource() => $_clearField(8);

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
}

/// DuplicateWarning indicates potential semantic duplication per RULE-M05-005 and EC-M05-001.
class DuplicateWarning extends $pb.GeneratedMessage {
  factory DuplicateWarning({
    $core.bool? isDuplicate,
    $core.double? similarityScore,
    $core.String? existingIdeaId,
    $core.String? existingIdeaTitle,
    $core.String? warningMessage,
  }) {
    final result = DuplicateWarning._();
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    if (similarityScore != null) result.similarityScore = similarityScore;
    if (existingIdeaId != null) result.existingIdeaId = existingIdeaId;
    if (existingIdeaTitle != null) result.existingIdeaTitle = existingIdeaTitle;
    if (warningMessage != null) result.warningMessage = warningMessage;
    return result;
  }

  DuplicateWarning._();

  factory DuplicateWarning.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DuplicateWarning()..mergeFromBuffer(data, registry);
  factory DuplicateWarning.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DuplicateWarning()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DuplicateWarning',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: DuplicateWarning.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isDuplicate')
    ..aD(2, _omitFieldNames ? '' : 'similarityScore',
        fieldType: $pb.PbFieldType.OF)
    ..aOS(3, _omitFieldNames ? '' : 'existingIdeaId')
    ..aOS(4, _omitFieldNames ? '' : 'existingIdeaTitle')
    ..aOS(5, _omitFieldNames ? '' : 'warningMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateWarning clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateWarning copyWith(void Function(DuplicateWarning) updates) =>
      super.copyWith((message) => updates(message as DuplicateWarning))
          as DuplicateWarning;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DuplicateWarning() / DuplicateWarning.new instead')
  static DuplicateWarning create() => DuplicateWarning._();
  static $pb.GeneratedMessage $_createMessage() => DuplicateWarning._();
  @$core.override
  DuplicateWarning createEmptyInstance() => DuplicateWarning._();
  @$core.pragma('dart2js:noInline')
  static DuplicateWarning getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DuplicateWarning>(
          DuplicateWarning.$_createMessage);
  static DuplicateWarning? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isDuplicate => $_getBF(0);
  @$pb.TagNumber(1)
  set isDuplicate($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsDuplicate() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsDuplicate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get similarityScore => $_getN(1);
  @$pb.TagNumber(2)
  set similarityScore($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSimilarityScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearSimilarityScore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get existingIdeaId => $_getSZ(2);
  @$pb.TagNumber(3)
  set existingIdeaId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExistingIdeaId() => $_has(2);
  @$pb.TagNumber(3)
  void clearExistingIdeaId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get existingIdeaTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set existingIdeaTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExistingIdeaTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearExistingIdeaTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get warningMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set warningMessage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWarningMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearWarningMessage() => $_clearField(5);
}

/// Idea represents a structured content idea per database_schema.md §6.1.
class Idea extends $pb.GeneratedMessage {
  factory Idea({
    $core.String? ideaId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? description,
    $core.String? audienceIntent,
    $core.String? creatorIntent,
    $core.String? suggestedFormat,
    $core.String? suggestedDirection,
    IdeaStatus? status,
    $core.double? ideaScore,
    $core.String? convertedToType,
    $core.String? convertedToId,
    $core.String? createdBy,
    $core.Iterable<IdeaSourceRef>? sources,
    $core.Iterable<Hook>? hooks,
    $core.Iterable<$core.double>? embeddingVector,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $2.SourceClass? sourceClass,
    $2.ConfidenceBand? confidence,
    $core.Iterable<$core.String>? recommendedFormats,
    $core.Iterable<$core.String>? recommendedPlatforms,
    $core.String? angle,
    $core.String? hookSuggestion,
  }) {
    final result = Idea._();
    if (ideaId != null) result.ideaId = ideaId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (audienceIntent != null) result.audienceIntent = audienceIntent;
    if (creatorIntent != null) result.creatorIntent = creatorIntent;
    if (suggestedFormat != null) result.suggestedFormat = suggestedFormat;
    if (suggestedDirection != null)
      result.suggestedDirection = suggestedDirection;
    if (status != null) result.status = status;
    if (ideaScore != null) result.ideaScore = ideaScore;
    if (convertedToType != null) result.convertedToType = convertedToType;
    if (convertedToId != null) result.convertedToId = convertedToId;
    if (createdBy != null) result.createdBy = createdBy;
    if (sources != null) result.sources.addAll(sources);
    if (hooks != null) result.hooks.addAll(hooks);
    if (embeddingVector != null) result.embeddingVector.addAll(embeddingVector);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (confidence != null) result.confidence = confidence;
    if (recommendedFormats != null)
      result.recommendedFormats.addAll(recommendedFormats);
    if (recommendedPlatforms != null)
      result.recommendedPlatforms.addAll(recommendedPlatforms);
    if (angle != null) result.angle = angle;
    if (hookSuggestion != null) result.hookSuggestion = hookSuggestion;
    return result;
  }

  Idea._();

  factory Idea.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Idea()..mergeFromBuffer(data, registry);
  factory Idea.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Idea()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Idea',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: Idea.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'ideaId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'audienceIntent')
    ..aOS(6, _omitFieldNames ? '' : 'creatorIntent')
    ..aOS(7, _omitFieldNames ? '' : 'suggestedFormat')
    ..aOS(8, _omitFieldNames ? '' : 'suggestedDirection')
    ..aE<IdeaStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: IdeaStatus.values)
    ..aD(10, _omitFieldNames ? '' : 'ideaScore', fieldType: $pb.PbFieldType.OF)
    ..aOS(11, _omitFieldNames ? '' : 'convertedToType')
    ..aOS(12, _omitFieldNames ? '' : 'convertedToId')
    ..aOS(13, _omitFieldNames ? '' : 'createdBy')
    ..pPM<IdeaSourceRef>(14, _omitFieldNames ? '' : 'sources',
        subBuilder: IdeaSourceRef.$_createMessage)
    ..pPM<Hook>(15, _omitFieldNames ? '' : 'hooks',
        subBuilder: Hook.$_createMessage)
    ..p<$core.double>(
        16, _omitFieldNames ? '' : 'embeddingVector', $pb.PbFieldType.KF)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aE<$2.SourceClass>(19, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aE<$2.ConfidenceBand>(20, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..pPS(21, _omitFieldNames ? '' : 'recommendedFormats')
    ..pPS(22, _omitFieldNames ? '' : 'recommendedPlatforms')
    ..aOS(23, _omitFieldNames ? '' : 'angle')
    ..aOS(24, _omitFieldNames ? '' : 'hookSuggestion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Idea clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Idea copyWith(void Function(Idea) updates) =>
      super.copyWith((message) => updates(message as Idea)) as Idea;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Idea() / Idea.new instead')
  static Idea create() => Idea._();
  static $pb.GeneratedMessage $_createMessage() => Idea._();
  @$core.override
  Idea createEmptyInstance() => Idea._();
  @$core.pragma('dart2js:noInline')
  static Idea getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Idea>(Idea.$_createMessage);
  static Idea? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ideaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ideaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdeaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdeaId() => $_clearField(1);

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
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get audienceIntent => $_getSZ(4);
  @$pb.TagNumber(5)
  set audienceIntent($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAudienceIntent() => $_has(4);
  @$pb.TagNumber(5)
  void clearAudienceIntent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get creatorIntent => $_getSZ(5);
  @$pb.TagNumber(6)
  set creatorIntent($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatorIntent() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatorIntent() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get suggestedFormat => $_getSZ(6);
  @$pb.TagNumber(7)
  set suggestedFormat($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSuggestedFormat() => $_has(6);
  @$pb.TagNumber(7)
  void clearSuggestedFormat() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get suggestedDirection => $_getSZ(7);
  @$pb.TagNumber(8)
  set suggestedDirection($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSuggestedDirection() => $_has(7);
  @$pb.TagNumber(8)
  void clearSuggestedDirection() => $_clearField(8);

  @$pb.TagNumber(9)
  IdeaStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(IdeaStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get ideaScore => $_getN(9);
  @$pb.TagNumber(10)
  set ideaScore($core.double value) => $_setFloat(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIdeaScore() => $_has(9);
  @$pb.TagNumber(10)
  void clearIdeaScore() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get convertedToType => $_getSZ(10);
  @$pb.TagNumber(11)
  set convertedToType($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasConvertedToType() => $_has(10);
  @$pb.TagNumber(11)
  void clearConvertedToType() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get convertedToId => $_getSZ(11);
  @$pb.TagNumber(12)
  set convertedToId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasConvertedToId() => $_has(11);
  @$pb.TagNumber(12)
  void clearConvertedToId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get createdBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set createdBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<IdeaSourceRef> get sources => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<Hook> get hooks => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<$core.double> get embeddingVector => $_getList(15);

  @$pb.TagNumber(17)
  $1.Timestamp get createdAt => $_getN(16);
  @$pb.TagNumber(17)
  set createdAt($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCreatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureCreatedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $1.Timestamp get updatedAt => $_getN(17);
  @$pb.TagNumber(18)
  set updatedAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasUpdatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearUpdatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureUpdatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $2.SourceClass get sourceClass => $_getN(18);
  @$pb.TagNumber(19)
  set sourceClass($2.SourceClass value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasSourceClass() => $_has(18);
  @$pb.TagNumber(19)
  void clearSourceClass() => $_clearField(19);

  @$pb.TagNumber(20)
  $2.ConfidenceBand get confidence => $_getN(19);
  @$pb.TagNumber(20)
  set confidence($2.ConfidenceBand value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasConfidence() => $_has(19);
  @$pb.TagNumber(20)
  void clearConfidence() => $_clearField(20);

  @$pb.TagNumber(21)
  $pb.PbList<$core.String> get recommendedFormats => $_getList(20);

  @$pb.TagNumber(22)
  $pb.PbList<$core.String> get recommendedPlatforms => $_getList(21);

  @$pb.TagNumber(23)
  $core.String get angle => $_getSZ(22);
  @$pb.TagNumber(23)
  set angle($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasAngle() => $_has(22);
  @$pb.TagNumber(23)
  void clearAngle() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get hookSuggestion => $_getSZ(23);
  @$pb.TagNumber(24)
  set hookSuggestion($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasHookSuggestion() => $_has(23);
  @$pb.TagNumber(24)
  void clearHookSuggestion() => $_clearField(24);
}

class IdeaServiceCreateRequest extends $pb.GeneratedMessage {
  factory IdeaServiceCreateRequest({
    $core.String? workspaceId,
    $core.String? title,
    $core.String? description,
    $core.String? audienceIntent,
    $core.String? creatorIntent,
    $core.String? suggestedFormat,
    $core.String? suggestedDirection,
    $core.Iterable<IdeaSourceRef>? sourceRefs,
    $core.Iterable<$core.String>? initialHooks,
    $core.bool? confirmDuplicate,
    $core.bool? checkDuplicateOnly,
    $core.bool? isMobileQuickCapture,
  }) {
    final result = IdeaServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (audienceIntent != null) result.audienceIntent = audienceIntent;
    if (creatorIntent != null) result.creatorIntent = creatorIntent;
    if (suggestedFormat != null) result.suggestedFormat = suggestedFormat;
    if (suggestedDirection != null)
      result.suggestedDirection = suggestedDirection;
    if (sourceRefs != null) result.sourceRefs.addAll(sourceRefs);
    if (initialHooks != null) result.initialHooks.addAll(initialHooks);
    if (confirmDuplicate != null) result.confirmDuplicate = confirmDuplicate;
    if (checkDuplicateOnly != null)
      result.checkDuplicateOnly = checkDuplicateOnly;
    if (isMobileQuickCapture != null)
      result.isMobileQuickCapture = isMobileQuickCapture;
    return result;
  }

  IdeaServiceCreateRequest._();

  factory IdeaServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'audienceIntent')
    ..aOS(5, _omitFieldNames ? '' : 'creatorIntent')
    ..aOS(6, _omitFieldNames ? '' : 'suggestedFormat')
    ..aOS(7, _omitFieldNames ? '' : 'suggestedDirection')
    ..pPM<IdeaSourceRef>(8, _omitFieldNames ? '' : 'sourceRefs',
        subBuilder: IdeaSourceRef.$_createMessage)
    ..pPS(9, _omitFieldNames ? '' : 'initialHooks')
    ..aOB(10, _omitFieldNames ? '' : 'confirmDuplicate')
    ..aOB(11, _omitFieldNames ? '' : 'checkDuplicateOnly')
    ..aOB(12, _omitFieldNames ? '' : 'isMobileQuickCapture')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceCreateRequest copyWith(
          void Function(IdeaServiceCreateRequest) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceCreateRequest))
          as IdeaServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceCreateRequest() / IdeaServiceCreateRequest.new instead')
  static IdeaServiceCreateRequest create() => IdeaServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() => IdeaServiceCreateRequest._();
  @$core.override
  IdeaServiceCreateRequest createEmptyInstance() =>
      IdeaServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceCreateRequest>(
          IdeaServiceCreateRequest.$_createMessage);
  static IdeaServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

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
  $core.String get audienceIntent => $_getSZ(3);
  @$pb.TagNumber(4)
  set audienceIntent($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAudienceIntent() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudienceIntent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creatorIntent => $_getSZ(4);
  @$pb.TagNumber(5)
  set creatorIntent($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatorIntent() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatorIntent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get suggestedFormat => $_getSZ(5);
  @$pb.TagNumber(6)
  set suggestedFormat($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSuggestedFormat() => $_has(5);
  @$pb.TagNumber(6)
  void clearSuggestedFormat() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get suggestedDirection => $_getSZ(6);
  @$pb.TagNumber(7)
  set suggestedDirection($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSuggestedDirection() => $_has(6);
  @$pb.TagNumber(7)
  void clearSuggestedDirection() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<IdeaSourceRef> get sourceRefs => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get initialHooks => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get confirmDuplicate => $_getBF(9);
  @$pb.TagNumber(10)
  set confirmDuplicate($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasConfirmDuplicate() => $_has(9);
  @$pb.TagNumber(10)
  void clearConfirmDuplicate() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get checkDuplicateOnly => $_getBF(10);
  @$pb.TagNumber(11)
  set checkDuplicateOnly($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCheckDuplicateOnly() => $_has(10);
  @$pb.TagNumber(11)
  void clearCheckDuplicateOnly() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get isMobileQuickCapture => $_getBF(11);
  @$pb.TagNumber(12)
  set isMobileQuickCapture($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIsMobileQuickCapture() => $_has(11);
  @$pb.TagNumber(12)
  void clearIsMobileQuickCapture() => $_clearField(12);
}

class IdeaServiceCreateResponse extends $pb.GeneratedMessage {
  factory IdeaServiceCreateResponse({
    Idea? idea,
    DuplicateWarning? duplicateWarning,
    $core.bool? created,
  }) {
    final result = IdeaServiceCreateResponse._();
    if (idea != null) result.idea = idea;
    if (duplicateWarning != null) result.duplicateWarning = duplicateWarning;
    if (created != null) result.created = created;
    return result;
  }

  IdeaServiceCreateResponse._();

  factory IdeaServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceCreateResponse.$_createMessage)
    ..aOM<Idea>(1, _omitFieldNames ? '' : 'idea',
        subBuilder: Idea.$_createMessage)
    ..aOM<DuplicateWarning>(2, _omitFieldNames ? '' : 'duplicateWarning',
        subBuilder: DuplicateWarning.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'created')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceCreateResponse copyWith(
          void Function(IdeaServiceCreateResponse) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceCreateResponse))
          as IdeaServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceCreateResponse() / IdeaServiceCreateResponse.new instead')
  static IdeaServiceCreateResponse create() => IdeaServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceCreateResponse._();
  @$core.override
  IdeaServiceCreateResponse createEmptyInstance() =>
      IdeaServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceCreateResponse>(
          IdeaServiceCreateResponse.$_createMessage);
  static IdeaServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Idea get idea => $_getN(0);
  @$pb.TagNumber(1)
  set idea(Idea value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdea() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdea() => $_clearField(1);
  @$pb.TagNumber(1)
  Idea ensureIdea() => $_ensure(0);

  @$pb.TagNumber(2)
  DuplicateWarning get duplicateWarning => $_getN(1);
  @$pb.TagNumber(2)
  set duplicateWarning(DuplicateWarning value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDuplicateWarning() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuplicateWarning() => $_clearField(2);
  @$pb.TagNumber(2)
  DuplicateWarning ensureDuplicateWarning() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get created => $_getBF(2);
  @$pb.TagNumber(3)
  set created($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreated() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreated() => $_clearField(3);
}

class IdeaServiceListRequest extends $pb.GeneratedMessage {
  factory IdeaServiceListRequest({
    $core.String? workspaceId,
    IdeaStatus? status,
    $core.String? sourceType,
    $core.int? pageSize,
    $core.String? pageToken,
    $core.String? searchQuery,
  }) {
    final result = IdeaServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (sourceType != null) result.sourceType = sourceType;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    if (searchQuery != null) result.searchQuery = searchQuery;
    return result;
  }

  IdeaServiceListRequest._();

  factory IdeaServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceListRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<IdeaStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: IdeaStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'sourceType')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aOS(5, _omitFieldNames ? '' : 'pageToken')
    ..aOS(6, _omitFieldNames ? '' : 'searchQuery')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceListRequest copyWith(
          void Function(IdeaServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceListRequest))
          as IdeaServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceListRequest() / IdeaServiceListRequest.new instead')
  static IdeaServiceListRequest create() => IdeaServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => IdeaServiceListRequest._();
  @$core.override
  IdeaServiceListRequest createEmptyInstance() => IdeaServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceListRequest>(
          IdeaServiceListRequest.$_createMessage);
  static IdeaServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  IdeaStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(IdeaStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceType => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceType() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pageToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set pageToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageToken() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get searchQuery => $_getSZ(5);
  @$pb.TagNumber(6)
  set searchQuery($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSearchQuery() => $_has(5);
  @$pb.TagNumber(6)
  void clearSearchQuery() => $_clearField(6);
}

class IdeaServiceListResponse extends $pb.GeneratedMessage {
  factory IdeaServiceListResponse({
    $core.Iterable<Idea>? ideas,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = IdeaServiceListResponse._();
    if (ideas != null) result.ideas.addAll(ideas);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  IdeaServiceListResponse._();

  factory IdeaServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceListResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceListResponse.$_createMessage)
    ..pPM<Idea>(1, _omitFieldNames ? '' : 'ideas',
        subBuilder: Idea.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceListResponse copyWith(
          void Function(IdeaServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceListResponse))
          as IdeaServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceListResponse() / IdeaServiceListResponse.new instead')
  static IdeaServiceListResponse create() => IdeaServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() => IdeaServiceListResponse._();
  @$core.override
  IdeaServiceListResponse createEmptyInstance() => IdeaServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceListResponse>(
          IdeaServiceListResponse.$_createMessage);
  static IdeaServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Idea> get ideas => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class IdeaServiceGetRequest extends $pb.GeneratedMessage {
  factory IdeaServiceGetRequest({
    $core.String? workspaceId,
    $core.String? ideaId,
  }) {
    final result = IdeaServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaId != null) result.ideaId = ideaId;
    return result;
  }

  IdeaServiceGetRequest._();

  factory IdeaServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceGetRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ideaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceGetRequest copyWith(
          void Function(IdeaServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceGetRequest))
          as IdeaServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceGetRequest() / IdeaServiceGetRequest.new instead')
  static IdeaServiceGetRequest create() => IdeaServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => IdeaServiceGetRequest._();
  @$core.override
  IdeaServiceGetRequest createEmptyInstance() => IdeaServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceGetRequest>(
          IdeaServiceGetRequest.$_createMessage);
  static IdeaServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ideaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ideaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdeaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdeaId() => $_clearField(2);
}

class IdeaServiceGetResponse extends $pb.GeneratedMessage {
  factory IdeaServiceGetResponse({
    Idea? idea,
  }) {
    final result = IdeaServiceGetResponse._();
    if (idea != null) result.idea = idea;
    return result;
  }

  IdeaServiceGetResponse._();

  factory IdeaServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceGetResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceGetResponse.$_createMessage)
    ..aOM<Idea>(1, _omitFieldNames ? '' : 'idea',
        subBuilder: Idea.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceGetResponse copyWith(
          void Function(IdeaServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceGetResponse))
          as IdeaServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceGetResponse() / IdeaServiceGetResponse.new instead')
  static IdeaServiceGetResponse create() => IdeaServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => IdeaServiceGetResponse._();
  @$core.override
  IdeaServiceGetResponse createEmptyInstance() => IdeaServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceGetResponse>(
          IdeaServiceGetResponse.$_createMessage);
  static IdeaServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Idea get idea => $_getN(0);
  @$pb.TagNumber(1)
  set idea(Idea value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdea() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdea() => $_clearField(1);
  @$pb.TagNumber(1)
  Idea ensureIdea() => $_ensure(0);
}

class IdeaServiceUpdateRequest extends $pb.GeneratedMessage {
  factory IdeaServiceUpdateRequest({
    $core.String? workspaceId,
    $core.String? ideaId,
    $1.Timestamp? expectedUpdatedAt,
    $core.String? title,
    $core.String? description,
    $core.String? audienceIntent,
    $core.String? creatorIntent,
    $core.String? suggestedFormat,
    $core.String? suggestedDirection,
    $core.String? angle,
  }) {
    final result = IdeaServiceUpdateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaId != null) result.ideaId = ideaId;
    if (expectedUpdatedAt != null) result.expectedUpdatedAt = expectedUpdatedAt;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (audienceIntent != null) result.audienceIntent = audienceIntent;
    if (creatorIntent != null) result.creatorIntent = creatorIntent;
    if (suggestedFormat != null) result.suggestedFormat = suggestedFormat;
    if (suggestedDirection != null)
      result.suggestedDirection = suggestedDirection;
    if (angle != null) result.angle = angle;
    return result;
  }

  IdeaServiceUpdateRequest._();

  factory IdeaServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ideaId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'expectedUpdatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'audienceIntent')
    ..aOS(7, _omitFieldNames ? '' : 'creatorIntent')
    ..aOS(8, _omitFieldNames ? '' : 'suggestedFormat')
    ..aOS(9, _omitFieldNames ? '' : 'suggestedDirection')
    ..aOS(10, _omitFieldNames ? '' : 'angle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceUpdateRequest copyWith(
          void Function(IdeaServiceUpdateRequest) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceUpdateRequest))
          as IdeaServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceUpdateRequest() / IdeaServiceUpdateRequest.new instead')
  static IdeaServiceUpdateRequest create() => IdeaServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() => IdeaServiceUpdateRequest._();
  @$core.override
  IdeaServiceUpdateRequest createEmptyInstance() =>
      IdeaServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceUpdateRequest>(
          IdeaServiceUpdateRequest.$_createMessage);
  static IdeaServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ideaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ideaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdeaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdeaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get expectedUpdatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set expectedUpdatedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedUpdatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureExpectedUpdatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get audienceIntent => $_getSZ(5);
  @$pb.TagNumber(6)
  set audienceIntent($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAudienceIntent() => $_has(5);
  @$pb.TagNumber(6)
  void clearAudienceIntent() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get creatorIntent => $_getSZ(6);
  @$pb.TagNumber(7)
  set creatorIntent($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatorIntent() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatorIntent() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get suggestedFormat => $_getSZ(7);
  @$pb.TagNumber(8)
  set suggestedFormat($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSuggestedFormat() => $_has(7);
  @$pb.TagNumber(8)
  void clearSuggestedFormat() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get suggestedDirection => $_getSZ(8);
  @$pb.TagNumber(9)
  set suggestedDirection($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSuggestedDirection() => $_has(8);
  @$pb.TagNumber(9)
  void clearSuggestedDirection() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get angle => $_getSZ(9);
  @$pb.TagNumber(10)
  set angle($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAngle() => $_has(9);
  @$pb.TagNumber(10)
  void clearAngle() => $_clearField(10);
}

class IdeaServiceUpdateResponse extends $pb.GeneratedMessage {
  factory IdeaServiceUpdateResponse({
    Idea? idea,
  }) {
    final result = IdeaServiceUpdateResponse._();
    if (idea != null) result.idea = idea;
    return result;
  }

  IdeaServiceUpdateResponse._();

  factory IdeaServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceUpdateResponse.$_createMessage)
    ..aOM<Idea>(1, _omitFieldNames ? '' : 'idea',
        subBuilder: Idea.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceUpdateResponse copyWith(
          void Function(IdeaServiceUpdateResponse) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceUpdateResponse))
          as IdeaServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceUpdateResponse() / IdeaServiceUpdateResponse.new instead')
  static IdeaServiceUpdateResponse create() => IdeaServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceUpdateResponse._();
  @$core.override
  IdeaServiceUpdateResponse createEmptyInstance() =>
      IdeaServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceUpdateResponse>(
          IdeaServiceUpdateResponse.$_createMessage);
  static IdeaServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Idea get idea => $_getN(0);
  @$pb.TagNumber(1)
  set idea(Idea value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdea() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdea() => $_clearField(1);
  @$pb.TagNumber(1)
  Idea ensureIdea() => $_ensure(0);
}

class IdeaServiceDeleteRequest extends $pb.GeneratedMessage {
  factory IdeaServiceDeleteRequest({
    $core.String? workspaceId,
    $core.String? ideaId,
  }) {
    final result = IdeaServiceDeleteRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaId != null) result.ideaId = ideaId;
    return result;
  }

  IdeaServiceDeleteRequest._();

  factory IdeaServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceDeleteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ideaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceDeleteRequest copyWith(
          void Function(IdeaServiceDeleteRequest) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceDeleteRequest))
          as IdeaServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceDeleteRequest() / IdeaServiceDeleteRequest.new instead')
  static IdeaServiceDeleteRequest create() => IdeaServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() => IdeaServiceDeleteRequest._();
  @$core.override
  IdeaServiceDeleteRequest createEmptyInstance() =>
      IdeaServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceDeleteRequest>(
          IdeaServiceDeleteRequest.$_createMessage);
  static IdeaServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ideaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ideaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdeaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdeaId() => $_clearField(2);
}

class IdeaServiceDeleteResponse extends $pb.GeneratedMessage {
  factory IdeaServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = IdeaServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  IdeaServiceDeleteResponse._();

  factory IdeaServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceDeleteResponse copyWith(
          void Function(IdeaServiceDeleteResponse) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceDeleteResponse))
          as IdeaServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceDeleteResponse() / IdeaServiceDeleteResponse.new instead')
  static IdeaServiceDeleteResponse create() => IdeaServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceDeleteResponse._();
  @$core.override
  IdeaServiceDeleteResponse createEmptyInstance() =>
      IdeaServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceDeleteResponse>(
          IdeaServiceDeleteResponse.$_createMessage);
  static IdeaServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class IdeaServiceUpdateStatusRequest extends $pb.GeneratedMessage {
  factory IdeaServiceUpdateStatusRequest({
    $core.String? workspaceId,
    $core.String? ideaId,
    $1.Timestamp? expectedUpdatedAt,
    IdeaStatus? targetStatus,
    $core.String? reason,
  }) {
    final result = IdeaServiceUpdateStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaId != null) result.ideaId = ideaId;
    if (expectedUpdatedAt != null) result.expectedUpdatedAt = expectedUpdatedAt;
    if (targetStatus != null) result.targetStatus = targetStatus;
    if (reason != null) result.reason = reason;
    return result;
  }

  IdeaServiceUpdateStatusRequest._();

  factory IdeaServiceUpdateStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceUpdateStatusRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceUpdateStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceUpdateStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceUpdateStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceUpdateStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ideaId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'expectedUpdatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aE<IdeaStatus>(4, _omitFieldNames ? '' : 'targetStatus',
        enumValues: IdeaStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceUpdateStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceUpdateStatusRequest copyWith(
          void Function(IdeaServiceUpdateStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as IdeaServiceUpdateStatusRequest))
          as IdeaServiceUpdateStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceUpdateStatusRequest() / IdeaServiceUpdateStatusRequest.new instead')
  static IdeaServiceUpdateStatusRequest create() =>
      IdeaServiceUpdateStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceUpdateStatusRequest._();
  @$core.override
  IdeaServiceUpdateStatusRequest createEmptyInstance() =>
      IdeaServiceUpdateStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceUpdateStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceUpdateStatusRequest>(
          IdeaServiceUpdateStatusRequest.$_createMessage);
  static IdeaServiceUpdateStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ideaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ideaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdeaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdeaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get expectedUpdatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set expectedUpdatedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedUpdatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureExpectedUpdatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  IdeaStatus get targetStatus => $_getN(3);
  @$pb.TagNumber(4)
  set targetStatus(IdeaStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class IdeaServiceUpdateStatusResponse extends $pb.GeneratedMessage {
  factory IdeaServiceUpdateStatusResponse({
    Idea? idea,
  }) {
    final result = IdeaServiceUpdateStatusResponse._();
    if (idea != null) result.idea = idea;
    return result;
  }

  IdeaServiceUpdateStatusResponse._();

  factory IdeaServiceUpdateStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceUpdateStatusResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceUpdateStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceUpdateStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceUpdateStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceUpdateStatusResponse.$_createMessage)
    ..aOM<Idea>(1, _omitFieldNames ? '' : 'idea',
        subBuilder: Idea.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceUpdateStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceUpdateStatusResponse copyWith(
          void Function(IdeaServiceUpdateStatusResponse) updates) =>
      super.copyWith(
              (message) => updates(message as IdeaServiceUpdateStatusResponse))
          as IdeaServiceUpdateStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceUpdateStatusResponse() / IdeaServiceUpdateStatusResponse.new instead')
  static IdeaServiceUpdateStatusResponse create() =>
      IdeaServiceUpdateStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceUpdateStatusResponse._();
  @$core.override
  IdeaServiceUpdateStatusResponse createEmptyInstance() =>
      IdeaServiceUpdateStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceUpdateStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceUpdateStatusResponse>(
          IdeaServiceUpdateStatusResponse.$_createMessage);
  static IdeaServiceUpdateStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Idea get idea => $_getN(0);
  @$pb.TagNumber(1)
  set idea(Idea value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdea() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdea() => $_clearField(1);
  @$pb.TagNumber(1)
  Idea ensureIdea() => $_ensure(0);
}

class IdeaServiceGenerateRequest extends $pb.GeneratedMessage {
  factory IdeaServiceGenerateRequest({
    $core.String? workspaceId,
    $core.String? prompt,
    $core.String? sourceType,
    $core.String? sourceId,
    $core.String? targetAudience,
    $core.int? count,
  }) {
    final result = IdeaServiceGenerateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (prompt != null) result.prompt = prompt;
    if (sourceType != null) result.sourceType = sourceType;
    if (sourceId != null) result.sourceId = sourceId;
    if (targetAudience != null) result.targetAudience = targetAudience;
    if (count != null) result.count = count;
    return result;
  }

  IdeaServiceGenerateRequest._();

  factory IdeaServiceGenerateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceGenerateRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceGenerateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceGenerateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceGenerateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceGenerateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..aOS(3, _omitFieldNames ? '' : 'sourceType')
    ..aOS(4, _omitFieldNames ? '' : 'sourceId')
    ..aOS(5, _omitFieldNames ? '' : 'targetAudience')
    ..aI(6, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceGenerateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceGenerateRequest copyWith(
          void Function(IdeaServiceGenerateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as IdeaServiceGenerateRequest))
          as IdeaServiceGenerateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceGenerateRequest() / IdeaServiceGenerateRequest.new instead')
  static IdeaServiceGenerateRequest create() => IdeaServiceGenerateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceGenerateRequest._();
  @$core.override
  IdeaServiceGenerateRequest createEmptyInstance() =>
      IdeaServiceGenerateRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceGenerateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceGenerateRequest>(
          IdeaServiceGenerateRequest.$_createMessage);
  static IdeaServiceGenerateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceType => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceType() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetAudience => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetAudience($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetAudience() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetAudience() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get count => $_getIZ(5);
  @$pb.TagNumber(6)
  set count($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearCount() => $_clearField(6);
}

class IdeaServiceGenerateResponse extends $pb.GeneratedMessage {
  factory IdeaServiceGenerateResponse({
    $core.Iterable<Idea>? generatedIdeas,
    $core.int? remainingHourlyQuota,
  }) {
    final result = IdeaServiceGenerateResponse._();
    if (generatedIdeas != null) result.generatedIdeas.addAll(generatedIdeas);
    if (remainingHourlyQuota != null)
      result.remainingHourlyQuota = remainingHourlyQuota;
    return result;
  }

  IdeaServiceGenerateResponse._();

  factory IdeaServiceGenerateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceGenerateResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceGenerateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceGenerateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceGenerateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceGenerateResponse.$_createMessage)
    ..pPM<Idea>(1, _omitFieldNames ? '' : 'generatedIdeas',
        subBuilder: Idea.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'remainingHourlyQuota')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceGenerateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceGenerateResponse copyWith(
          void Function(IdeaServiceGenerateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as IdeaServiceGenerateResponse))
          as IdeaServiceGenerateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceGenerateResponse() / IdeaServiceGenerateResponse.new instead')
  static IdeaServiceGenerateResponse create() =>
      IdeaServiceGenerateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceGenerateResponse._();
  @$core.override
  IdeaServiceGenerateResponse createEmptyInstance() =>
      IdeaServiceGenerateResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceGenerateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceGenerateResponse>(
          IdeaServiceGenerateResponse.$_createMessage);
  static IdeaServiceGenerateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Idea> get generatedIdeas => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get remainingHourlyQuota => $_getIZ(1);
  @$pb.TagNumber(2)
  set remainingHourlyQuota($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemainingHourlyQuota() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemainingHourlyQuota() => $_clearField(2);
}

class IdeaServiceConvertRequest extends $pb.GeneratedMessage {
  factory IdeaServiceConvertRequest({
    $core.String? workspaceId,
    $core.String? ideaId,
    $1.Timestamp? expectedUpdatedAt,
    $core.String? conversionType,
    $core.String? title,
  }) {
    final result = IdeaServiceConvertRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaId != null) result.ideaId = ideaId;
    if (expectedUpdatedAt != null) result.expectedUpdatedAt = expectedUpdatedAt;
    if (conversionType != null) result.conversionType = conversionType;
    if (title != null) result.title = title;
    return result;
  }

  IdeaServiceConvertRequest._();

  factory IdeaServiceConvertRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceConvertRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceConvertRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceConvertRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceConvertRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceConvertRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ideaId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'expectedUpdatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'conversionType')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceConvertRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceConvertRequest copyWith(
          void Function(IdeaServiceConvertRequest) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceConvertRequest))
          as IdeaServiceConvertRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceConvertRequest() / IdeaServiceConvertRequest.new instead')
  static IdeaServiceConvertRequest create() => IdeaServiceConvertRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceConvertRequest._();
  @$core.override
  IdeaServiceConvertRequest createEmptyInstance() =>
      IdeaServiceConvertRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceConvertRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceConvertRequest>(
          IdeaServiceConvertRequest.$_createMessage);
  static IdeaServiceConvertRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ideaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ideaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdeaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdeaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get expectedUpdatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set expectedUpdatedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedUpdatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureExpectedUpdatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get conversionType => $_getSZ(3);
  @$pb.TagNumber(4)
  set conversionType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConversionType() => $_has(3);
  @$pb.TagNumber(4)
  void clearConversionType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);
}

class IdeaServiceConvertResponse extends $pb.GeneratedMessage {
  factory IdeaServiceConvertResponse({
    Idea? idea,
    $core.String? convertedToType,
    $core.String? convertedToId,
    $core.String? scriptId,
  }) {
    final result = IdeaServiceConvertResponse._();
    if (idea != null) result.idea = idea;
    if (convertedToType != null) result.convertedToType = convertedToType;
    if (convertedToId != null) result.convertedToId = convertedToId;
    if (scriptId != null) result.scriptId = scriptId;
    return result;
  }

  IdeaServiceConvertResponse._();

  factory IdeaServiceConvertResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceConvertResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceConvertResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceConvertResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceConvertResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceConvertResponse.$_createMessage)
    ..aOM<Idea>(1, _omitFieldNames ? '' : 'idea',
        subBuilder: Idea.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'convertedToType')
    ..aOS(3, _omitFieldNames ? '' : 'convertedToId')
    ..aOS(4, _omitFieldNames ? '' : 'scriptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceConvertResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceConvertResponse copyWith(
          void Function(IdeaServiceConvertResponse) updates) =>
      super.copyWith(
              (message) => updates(message as IdeaServiceConvertResponse))
          as IdeaServiceConvertResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceConvertResponse() / IdeaServiceConvertResponse.new instead')
  static IdeaServiceConvertResponse create() => IdeaServiceConvertResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceConvertResponse._();
  @$core.override
  IdeaServiceConvertResponse createEmptyInstance() =>
      IdeaServiceConvertResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceConvertResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceConvertResponse>(
          IdeaServiceConvertResponse.$_createMessage);
  static IdeaServiceConvertResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Idea get idea => $_getN(0);
  @$pb.TagNumber(1)
  set idea(Idea value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdea() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdea() => $_clearField(1);
  @$pb.TagNumber(1)
  Idea ensureIdea() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get convertedToType => $_getSZ(1);
  @$pb.TagNumber(2)
  set convertedToType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConvertedToType() => $_has(1);
  @$pb.TagNumber(2)
  void clearConvertedToType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get convertedToId => $_getSZ(2);
  @$pb.TagNumber(3)
  set convertedToId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConvertedToId() => $_has(2);
  @$pb.TagNumber(3)
  void clearConvertedToId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scriptId => $_getSZ(3);
  @$pb.TagNumber(4)
  set scriptId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScriptId() => $_has(3);
  @$pb.TagNumber(4)
  void clearScriptId() => $_clearField(4);
}

class IdeaServiceSearchRequest extends $pb.GeneratedMessage {
  factory IdeaServiceSearchRequest({
    $core.String? workspaceId,
    $core.String? query,
    $core.int? limit,
    $core.double? minSimilarity,
  }) {
    final result = IdeaServiceSearchRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (query != null) result.query = query;
    if (limit != null) result.limit = limit;
    if (minSimilarity != null) result.minSimilarity = minSimilarity;
    return result;
  }

  IdeaServiceSearchRequest._();

  factory IdeaServiceSearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceSearchRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceSearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceSearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceSearchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceSearchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aD(4, _omitFieldNames ? '' : 'minSimilarity',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceSearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceSearchRequest copyWith(
          void Function(IdeaServiceSearchRequest) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceSearchRequest))
          as IdeaServiceSearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceSearchRequest() / IdeaServiceSearchRequest.new instead')
  static IdeaServiceSearchRequest create() => IdeaServiceSearchRequest._();
  static $pb.GeneratedMessage $_createMessage() => IdeaServiceSearchRequest._();
  @$core.override
  IdeaServiceSearchRequest createEmptyInstance() =>
      IdeaServiceSearchRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceSearchRequest>(
          IdeaServiceSearchRequest.$_createMessage);
  static IdeaServiceSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get minSimilarity => $_getN(3);
  @$pb.TagNumber(4)
  set minSimilarity($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinSimilarity() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinSimilarity() => $_clearField(4);
}

class IdeaServiceSearchResponse extends $pb.GeneratedMessage {
  factory IdeaServiceSearchResponse({
    $core.Iterable<Idea>? ideas,
    $core.Iterable<$core.double>? similarityScores,
  }) {
    final result = IdeaServiceSearchResponse._();
    if (ideas != null) result.ideas.addAll(ideas);
    if (similarityScores != null)
      result.similarityScores.addAll(similarityScores);
    return result;
  }

  IdeaServiceSearchResponse._();

  factory IdeaServiceSearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceSearchResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceSearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceSearchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceSearchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceSearchResponse.$_createMessage)
    ..pPM<Idea>(1, _omitFieldNames ? '' : 'ideas',
        subBuilder: Idea.$_createMessage)
    ..p<$core.double>(
        2, _omitFieldNames ? '' : 'similarityScores', $pb.PbFieldType.KF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceSearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceSearchResponse copyWith(
          void Function(IdeaServiceSearchResponse) updates) =>
      super.copyWith((message) => updates(message as IdeaServiceSearchResponse))
          as IdeaServiceSearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceSearchResponse() / IdeaServiceSearchResponse.new instead')
  static IdeaServiceSearchResponse create() => IdeaServiceSearchResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceSearchResponse._();
  @$core.override
  IdeaServiceSearchResponse createEmptyInstance() =>
      IdeaServiceSearchResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceSearchResponse>(
          IdeaServiceSearchResponse.$_createMessage);
  static IdeaServiceSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Idea> get ideas => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get similarityScores => $_getList(1);
}

class IdeaServiceCreateFromTrendRequest extends $pb.GeneratedMessage {
  factory IdeaServiceCreateFromTrendRequest({
    $core.String? workspaceId,
    $core.String? trendId,
    $core.String? title,
    $core.String? audienceIntent,
  }) {
    final result = IdeaServiceCreateFromTrendRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trendId != null) result.trendId = trendId;
    if (title != null) result.title = title;
    if (audienceIntent != null) result.audienceIntent = audienceIntent;
    return result;
  }

  IdeaServiceCreateFromTrendRequest._();

  factory IdeaServiceCreateFromTrendRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceCreateFromTrendRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceCreateFromTrendRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceCreateFromTrendRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceCreateFromTrendRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceCreateFromTrendRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'trendId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'audienceIntent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceCreateFromTrendRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceCreateFromTrendRequest copyWith(
          void Function(IdeaServiceCreateFromTrendRequest) updates) =>
      super.copyWith((message) =>
              updates(message as IdeaServiceCreateFromTrendRequest))
          as IdeaServiceCreateFromTrendRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceCreateFromTrendRequest() / IdeaServiceCreateFromTrendRequest.new instead')
  static IdeaServiceCreateFromTrendRequest create() =>
      IdeaServiceCreateFromTrendRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceCreateFromTrendRequest._();
  @$core.override
  IdeaServiceCreateFromTrendRequest createEmptyInstance() =>
      IdeaServiceCreateFromTrendRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceCreateFromTrendRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceCreateFromTrendRequest>(
          IdeaServiceCreateFromTrendRequest.$_createMessage);
  static IdeaServiceCreateFromTrendRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get trendId => $_getSZ(1);
  @$pb.TagNumber(2)
  set trendId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrendId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrendId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get audienceIntent => $_getSZ(3);
  @$pb.TagNumber(4)
  set audienceIntent($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAudienceIntent() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudienceIntent() => $_clearField(4);
}

class IdeaServiceCreateFromTrendResponse extends $pb.GeneratedMessage {
  factory IdeaServiceCreateFromTrendResponse({
    Idea? idea,
  }) {
    final result = IdeaServiceCreateFromTrendResponse._();
    if (idea != null) result.idea = idea;
    return result;
  }

  IdeaServiceCreateFromTrendResponse._();

  factory IdeaServiceCreateFromTrendResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceCreateFromTrendResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceCreateFromTrendResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceCreateFromTrendResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceCreateFromTrendResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceCreateFromTrendResponse.$_createMessage)
    ..aOM<Idea>(1, _omitFieldNames ? '' : 'idea',
        subBuilder: Idea.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceCreateFromTrendResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceCreateFromTrendResponse copyWith(
          void Function(IdeaServiceCreateFromTrendResponse) updates) =>
      super.copyWith((message) =>
              updates(message as IdeaServiceCreateFromTrendResponse))
          as IdeaServiceCreateFromTrendResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceCreateFromTrendResponse() / IdeaServiceCreateFromTrendResponse.new instead')
  static IdeaServiceCreateFromTrendResponse create() =>
      IdeaServiceCreateFromTrendResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceCreateFromTrendResponse._();
  @$core.override
  IdeaServiceCreateFromTrendResponse createEmptyInstance() =>
      IdeaServiceCreateFromTrendResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceCreateFromTrendResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceCreateFromTrendResponse>(
          IdeaServiceCreateFromTrendResponse.$_createMessage);
  static IdeaServiceCreateFromTrendResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Idea get idea => $_getN(0);
  @$pb.TagNumber(1)
  set idea(Idea value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdea() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdea() => $_clearField(1);
  @$pb.TagNumber(1)
  Idea ensureIdea() => $_ensure(0);
}

class IdeaServiceListMobileRequest extends $pb.GeneratedMessage {
  factory IdeaServiceListMobileRequest({
    $core.String? workspaceId,
    IdeaStatus? status,
    $core.int? limit,
  }) {
    final result = IdeaServiceListMobileRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (limit != null) result.limit = limit;
    return result;
  }

  IdeaServiceListMobileRequest._();

  factory IdeaServiceListMobileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceListMobileRequest()..mergeFromBuffer(data, registry);
  factory IdeaServiceListMobileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceListMobileRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceListMobileRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceListMobileRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<IdeaStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: IdeaStatus.values)
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceListMobileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceListMobileRequest copyWith(
          void Function(IdeaServiceListMobileRequest) updates) =>
      super.copyWith(
              (message) => updates(message as IdeaServiceListMobileRequest))
          as IdeaServiceListMobileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceListMobileRequest() / IdeaServiceListMobileRequest.new instead')
  static IdeaServiceListMobileRequest create() =>
      IdeaServiceListMobileRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceListMobileRequest._();
  @$core.override
  IdeaServiceListMobileRequest createEmptyInstance() =>
      IdeaServiceListMobileRequest._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceListMobileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceListMobileRequest>(
          IdeaServiceListMobileRequest.$_createMessage);
  static IdeaServiceListMobileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  IdeaStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(IdeaStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class IdeaServiceListMobileResponse extends $pb.GeneratedMessage {
  factory IdeaServiceListMobileResponse({
    $core.Iterable<Idea>? ideas,
    $core.int? totalCount,
  }) {
    final result = IdeaServiceListMobileResponse._();
    if (ideas != null) result.ideas.addAll(ideas);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  IdeaServiceListMobileResponse._();

  factory IdeaServiceListMobileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceListMobileResponse()..mergeFromBuffer(data, registry);
  factory IdeaServiceListMobileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IdeaServiceListMobileResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdeaServiceListMobileResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: IdeaServiceListMobileResponse.$_createMessage)
    ..pPM<Idea>(1, _omitFieldNames ? '' : 'ideas',
        subBuilder: Idea.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceListMobileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdeaServiceListMobileResponse copyWith(
          void Function(IdeaServiceListMobileResponse) updates) =>
      super.copyWith(
              (message) => updates(message as IdeaServiceListMobileResponse))
          as IdeaServiceListMobileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use IdeaServiceListMobileResponse() / IdeaServiceListMobileResponse.new instead')
  static IdeaServiceListMobileResponse create() =>
      IdeaServiceListMobileResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      IdeaServiceListMobileResponse._();
  @$core.override
  IdeaServiceListMobileResponse createEmptyInstance() =>
      IdeaServiceListMobileResponse._();
  @$core.pragma('dart2js:noInline')
  static IdeaServiceListMobileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdeaServiceListMobileResponse>(
          IdeaServiceListMobileResponse.$_createMessage);
  static IdeaServiceListMobileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Idea> get ideas => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/trend.proto.

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
import 'trend.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'trend.pbenum.dart';

/// SignalRef represents an ingested provenance signal linked to a trend.
class SignalRef extends $pb.GeneratedMessage {
  factory SignalRef({
    $core.String? signalId,
    $core.String? workspaceId,
    $core.String? sourcePlatform,
    SourceClass? sourceClass,
    $core.String? signalType,
    $core.String? normalizedSummary,
    ConfidenceBand? confidence,
    $1.Timestamp? freshnessAt,
    $1.Timestamp? collectedAt,
  }) {
    final result = SignalRef._();
    if (signalId != null) result.signalId = signalId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (signalType != null) result.signalType = signalType;
    if (normalizedSummary != null) result.normalizedSummary = normalizedSummary;
    if (confidence != null) result.confidence = confidence;
    if (freshnessAt != null) result.freshnessAt = freshnessAt;
    if (collectedAt != null) result.collectedAt = collectedAt;
    return result;
  }

  SignalRef._();

  factory SignalRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SignalRef()..mergeFromBuffer(data, registry);
  factory SignalRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SignalRef()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignalRef',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: SignalRef.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'signalId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'sourcePlatform')
    ..aE<SourceClass>(4, _omitFieldNames ? '' : 'sourceClass',
        enumValues: SourceClass.values)
    ..aOS(5, _omitFieldNames ? '' : 'signalType')
    ..aOS(6, _omitFieldNames ? '' : 'normalizedSummary')
    ..aE<ConfidenceBand>(7, _omitFieldNames ? '' : 'confidence',
        enumValues: ConfidenceBand.values)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'freshnessAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalRef copyWith(void Function(SignalRef) updates) =>
      super.copyWith((message) => updates(message as SignalRef)) as SignalRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SignalRef() / SignalRef.new instead')
  static SignalRef create() => SignalRef._();
  static $pb.GeneratedMessage $_createMessage() => SignalRef._();
  @$core.override
  SignalRef createEmptyInstance() => SignalRef._();
  @$core.pragma('dart2js:noInline')
  static SignalRef getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignalRef>(SignalRef.$_createMessage);
  static SignalRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get signalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set signalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSignalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourcePlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourcePlatform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourcePlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourcePlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  SourceClass get sourceClass => $_getN(3);
  @$pb.TagNumber(4)
  set sourceClass(SourceClass value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get signalType => $_getSZ(4);
  @$pb.TagNumber(5)
  set signalType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSignalType() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignalType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get normalizedSummary => $_getSZ(5);
  @$pb.TagNumber(6)
  set normalizedSummary($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNormalizedSummary() => $_has(5);
  @$pb.TagNumber(6)
  void clearNormalizedSummary() => $_clearField(6);

  @$pb.TagNumber(7)
  ConfidenceBand get confidence => $_getN(6);
  @$pb.TagNumber(7)
  set confidence(ConfidenceBand value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasConfidence() => $_has(6);
  @$pb.TagNumber(7)
  void clearConfidence() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get freshnessAt => $_getN(7);
  @$pb.TagNumber(8)
  set freshnessAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasFreshnessAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearFreshnessAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureFreshnessAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.Timestamp get collectedAt => $_getN(8);
  @$pb.TagNumber(9)
  set collectedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCollectedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCollectedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureCollectedAt() => $_ensure(8);
}

/// Trend represents a scored trend entity with multi-dimensional scores and lineage.
class Trend extends $pb.GeneratedMessage {
  factory Trend({
    $core.String? trendId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? summary,
    $core.String? category,
    $core.Iterable<$core.String>? platforms,
    $core.double? strengthScore,
    $core.double? velocityScore,
    $core.double? freshnessScore,
    $core.double? saturationScore,
    ConfidenceBand? confidence,
    $core.String? confidenceReason,
    SourceClass? sourceClass,
    LifecycleState? lifecycleState,
    $1.Timestamp? freshnessAt,
    $core.String? whyNow,
    $core.String? relevanceDescription,
    $core.Iterable<SignalRef>? sourceSignals,
    $core.bool? isSaved,
    $core.bool? isDegraded,
    $core.String? degradedReason,
    $core.Iterable<$core.double>? embeddingVector,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Trend._();
    if (trendId != null) result.trendId = trendId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (category != null) result.category = category;
    if (platforms != null) result.platforms.addAll(platforms);
    if (strengthScore != null) result.strengthScore = strengthScore;
    if (velocityScore != null) result.velocityScore = velocityScore;
    if (freshnessScore != null) result.freshnessScore = freshnessScore;
    if (saturationScore != null) result.saturationScore = saturationScore;
    if (confidence != null) result.confidence = confidence;
    if (confidenceReason != null) result.confidenceReason = confidenceReason;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (freshnessAt != null) result.freshnessAt = freshnessAt;
    if (whyNow != null) result.whyNow = whyNow;
    if (relevanceDescription != null)
      result.relevanceDescription = relevanceDescription;
    if (sourceSignals != null) result.sourceSignals.addAll(sourceSignals);
    if (isSaved != null) result.isSaved = isSaved;
    if (isDegraded != null) result.isDegraded = isDegraded;
    if (degradedReason != null) result.degradedReason = degradedReason;
    if (embeddingVector != null) result.embeddingVector.addAll(embeddingVector);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Trend._();

  factory Trend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Trend()..mergeFromBuffer(data, registry);
  factory Trend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Trend()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Trend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: Trend.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'trendId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'category')
    ..pPS(6, _omitFieldNames ? '' : 'platforms')
    ..aD(7, _omitFieldNames ? '' : 'strengthScore',
        fieldType: $pb.PbFieldType.OF)
    ..aD(8, _omitFieldNames ? '' : 'velocityScore',
        fieldType: $pb.PbFieldType.OF)
    ..aD(9, _omitFieldNames ? '' : 'freshnessScore',
        fieldType: $pb.PbFieldType.OF)
    ..aD(10, _omitFieldNames ? '' : 'saturationScore',
        fieldType: $pb.PbFieldType.OF)
    ..aE<ConfidenceBand>(11, _omitFieldNames ? '' : 'confidence',
        enumValues: ConfidenceBand.values)
    ..aOS(12, _omitFieldNames ? '' : 'confidenceReason')
    ..aE<SourceClass>(13, _omitFieldNames ? '' : 'sourceClass',
        enumValues: SourceClass.values)
    ..aE<LifecycleState>(14, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: LifecycleState.values)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'freshnessAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(16, _omitFieldNames ? '' : 'whyNow')
    ..aOS(17, _omitFieldNames ? '' : 'relevanceDescription')
    ..pPM<SignalRef>(18, _omitFieldNames ? '' : 'sourceSignals',
        subBuilder: SignalRef.$_createMessage)
    ..aOB(19, _omitFieldNames ? '' : 'isSaved')
    ..aOB(20, _omitFieldNames ? '' : 'isDegraded')
    ..aOS(21, _omitFieldNames ? '' : 'degradedReason')
    ..p<$core.double>(
        22, _omitFieldNames ? '' : 'embeddingVector', $pb.PbFieldType.KF)
    ..aOM<$1.Timestamp>(23, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(24, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trend copyWith(void Function(Trend) updates) =>
      super.copyWith((message) => updates(message as Trend)) as Trend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Trend() / Trend.new instead')
  static Trend create() => Trend._();
  static $pb.GeneratedMessage $_createMessage() => Trend._();
  @$core.override
  Trend createEmptyInstance() => Trend._();
  @$core.pragma('dart2js:noInline')
  static Trend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Trend>(Trend.$_createMessage);
  static Trend? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trendId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trendId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrendId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrendId() => $_clearField(1);

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
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get category => $_getSZ(4);
  @$pb.TagNumber(5)
  set category($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get platforms => $_getList(5);

  @$pb.TagNumber(7)
  $core.double get strengthScore => $_getN(6);
  @$pb.TagNumber(7)
  set strengthScore($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStrengthScore() => $_has(6);
  @$pb.TagNumber(7)
  void clearStrengthScore() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get velocityScore => $_getN(7);
  @$pb.TagNumber(8)
  set velocityScore($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVelocityScore() => $_has(7);
  @$pb.TagNumber(8)
  void clearVelocityScore() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get freshnessScore => $_getN(8);
  @$pb.TagNumber(9)
  set freshnessScore($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFreshnessScore() => $_has(8);
  @$pb.TagNumber(9)
  void clearFreshnessScore() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get saturationScore => $_getN(9);
  @$pb.TagNumber(10)
  set saturationScore($core.double value) => $_setFloat(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSaturationScore() => $_has(9);
  @$pb.TagNumber(10)
  void clearSaturationScore() => $_clearField(10);

  @$pb.TagNumber(11)
  ConfidenceBand get confidence => $_getN(10);
  @$pb.TagNumber(11)
  set confidence(ConfidenceBand value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasConfidence() => $_has(10);
  @$pb.TagNumber(11)
  void clearConfidence() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get confidenceReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set confidenceReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasConfidenceReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearConfidenceReason() => $_clearField(12);

  @$pb.TagNumber(13)
  SourceClass get sourceClass => $_getN(12);
  @$pb.TagNumber(13)
  set sourceClass(SourceClass value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSourceClass() => $_has(12);
  @$pb.TagNumber(13)
  void clearSourceClass() => $_clearField(13);

  @$pb.TagNumber(14)
  LifecycleState get lifecycleState => $_getN(13);
  @$pb.TagNumber(14)
  set lifecycleState(LifecycleState value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasLifecycleState() => $_has(13);
  @$pb.TagNumber(14)
  void clearLifecycleState() => $_clearField(14);

  @$pb.TagNumber(15)
  $1.Timestamp get freshnessAt => $_getN(14);
  @$pb.TagNumber(15)
  set freshnessAt($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasFreshnessAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearFreshnessAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureFreshnessAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get whyNow => $_getSZ(15);
  @$pb.TagNumber(16)
  set whyNow($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasWhyNow() => $_has(15);
  @$pb.TagNumber(16)
  void clearWhyNow() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get relevanceDescription => $_getSZ(16);
  @$pb.TagNumber(17)
  set relevanceDescription($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasRelevanceDescription() => $_has(16);
  @$pb.TagNumber(17)
  void clearRelevanceDescription() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<SignalRef> get sourceSignals => $_getList(17);

  @$pb.TagNumber(19)
  $core.bool get isSaved => $_getBF(18);
  @$pb.TagNumber(19)
  set isSaved($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasIsSaved() => $_has(18);
  @$pb.TagNumber(19)
  void clearIsSaved() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.bool get isDegraded => $_getBF(19);
  @$pb.TagNumber(20)
  set isDegraded($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasIsDegraded() => $_has(19);
  @$pb.TagNumber(20)
  void clearIsDegraded() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get degradedReason => $_getSZ(20);
  @$pb.TagNumber(21)
  set degradedReason($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasDegradedReason() => $_has(20);
  @$pb.TagNumber(21)
  void clearDegradedReason() => $_clearField(21);

  @$pb.TagNumber(22)
  $pb.PbList<$core.double> get embeddingVector => $_getList(21);

  @$pb.TagNumber(23)
  $1.Timestamp get createdAt => $_getN(22);
  @$pb.TagNumber(23)
  set createdAt($1.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasCreatedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearCreatedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $1.Timestamp ensureCreatedAt() => $_ensure(22);

  @$pb.TagNumber(24)
  $1.Timestamp get updatedAt => $_getN(23);
  @$pb.TagNumber(24)
  set updatedAt($1.Timestamp value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasUpdatedAt() => $_has(23);
  @$pb.TagNumber(24)
  void clearUpdatedAt() => $_clearField(24);
  @$pb.TagNumber(24)
  $1.Timestamp ensureUpdatedAt() => $_ensure(23);
}

/// AlertThreshold defines criteria for threshold alert triggers.
class AlertThreshold extends $pb.GeneratedMessage {
  factory AlertThreshold({
    $core.double? minVelocityScore,
    $core.double? minStrengthScore,
    $core.double? spikePercentage,
    $core.int? cooldownMinutes,
  }) {
    final result = AlertThreshold._();
    if (minVelocityScore != null) result.minVelocityScore = minVelocityScore;
    if (minStrengthScore != null) result.minStrengthScore = minStrengthScore;
    if (spikePercentage != null) result.spikePercentage = spikePercentage;
    if (cooldownMinutes != null) result.cooldownMinutes = cooldownMinutes;
    return result;
  }

  AlertThreshold._();

  factory AlertThreshold.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AlertThreshold()..mergeFromBuffer(data, registry);
  factory AlertThreshold.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AlertThreshold()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AlertThreshold',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: AlertThreshold.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'minVelocityScore',
        fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'minStrengthScore',
        fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'spikePercentage',
        fieldType: $pb.PbFieldType.OF)
    ..aI(4, _omitFieldNames ? '' : 'cooldownMinutes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlertThreshold clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlertThreshold copyWith(void Function(AlertThreshold) updates) =>
      super.copyWith((message) => updates(message as AlertThreshold))
          as AlertThreshold;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AlertThreshold() / AlertThreshold.new instead')
  static AlertThreshold create() => AlertThreshold._();
  static $pb.GeneratedMessage $_createMessage() => AlertThreshold._();
  @$core.override
  AlertThreshold createEmptyInstance() => AlertThreshold._();
  @$core.pragma('dart2js:noInline')
  static AlertThreshold getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AlertThreshold>(
          AlertThreshold.$_createMessage);
  static AlertThreshold? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get minVelocityScore => $_getN(0);
  @$pb.TagNumber(1)
  set minVelocityScore($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinVelocityScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinVelocityScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get minStrengthScore => $_getN(1);
  @$pb.TagNumber(2)
  set minStrengthScore($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinStrengthScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinStrengthScore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get spikePercentage => $_getN(2);
  @$pb.TagNumber(3)
  set spikePercentage($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSpikePercentage() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpikePercentage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get cooldownMinutes => $_getIZ(3);
  @$pb.TagNumber(4)
  set cooldownMinutes($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCooldownMinutes() => $_has(3);
  @$pb.TagNumber(4)
  void clearCooldownMinutes() => $_clearField(4);
}

/// Watchlist represents an entity watchlist tracked by the creator/operator.
class Watchlist extends $pb.GeneratedMessage {
  factory Watchlist({
    $core.String? watchlistId,
    $core.String? workspaceId,
    $core.String? name,
    $core.String? type,
    $core.String? criteriaJson,
    $core.bool? alertEnabled,
    AlertThreshold? alertThreshold,
    $core.Iterable<$core.String>? trackedTrendIds,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Watchlist._();
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (criteriaJson != null) result.criteriaJson = criteriaJson;
    if (alertEnabled != null) result.alertEnabled = alertEnabled;
    if (alertThreshold != null) result.alertThreshold = alertThreshold;
    if (trackedTrendIds != null) result.trackedTrendIds.addAll(trackedTrendIds);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Watchlist._();

  factory Watchlist.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Watchlist()..mergeFromBuffer(data, registry);
  factory Watchlist.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Watchlist()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Watchlist',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: Watchlist.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'watchlistId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'type')
    ..aOS(5, _omitFieldNames ? '' : 'criteriaJson')
    ..aOB(6, _omitFieldNames ? '' : 'alertEnabled')
    ..aOM<AlertThreshold>(7, _omitFieldNames ? '' : 'alertThreshold',
        subBuilder: AlertThreshold.$_createMessage)
    ..pPS(8, _omitFieldNames ? '' : 'trackedTrendIds')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Watchlist clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Watchlist copyWith(void Function(Watchlist) updates) =>
      super.copyWith((message) => updates(message as Watchlist)) as Watchlist;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Watchlist() / Watchlist.new instead')
  static Watchlist create() => Watchlist._();
  static $pb.GeneratedMessage $_createMessage() => Watchlist._();
  @$core.override
  Watchlist createEmptyInstance() => Watchlist._();
  @$core.pragma('dart2js:noInline')
  static Watchlist getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Watchlist>(Watchlist.$_createMessage);
  static Watchlist? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get watchlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set watchlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWatchlistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWatchlistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get type => $_getSZ(3);
  @$pb.TagNumber(4)
  set type($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get criteriaJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set criteriaJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCriteriaJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearCriteriaJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get alertEnabled => $_getBF(5);
  @$pb.TagNumber(6)
  set alertEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAlertEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearAlertEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  AlertThreshold get alertThreshold => $_getN(6);
  @$pb.TagNumber(7)
  set alertThreshold(AlertThreshold value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAlertThreshold() => $_has(6);
  @$pb.TagNumber(7)
  void clearAlertThreshold() => $_clearField(7);
  @$pb.TagNumber(7)
  AlertThreshold ensureAlertThreshold() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get trackedTrendIds => $_getList(7);

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

/// WatchlistAlert represents a deduplicated alert event emitted for a watchlist breach.
class WatchlistAlert extends $pb.GeneratedMessage {
  factory WatchlistAlert({
    $core.String? alertLogId,
    $core.String? watchlistId,
    $core.String? trendId,
    $core.String? trendTitle,
    $core.String? alertFingerprint,
    $core.double? velocityScore,
    $core.double? thresholdValue,
    $1.Timestamp? deliveredAt,
    $1.Timestamp? cooldownUntil,
    $core.bool? isBatchedSummary,
    $core.int? batchedAlertCount,
  }) {
    final result = WatchlistAlert._();
    if (alertLogId != null) result.alertLogId = alertLogId;
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (trendId != null) result.trendId = trendId;
    if (trendTitle != null) result.trendTitle = trendTitle;
    if (alertFingerprint != null) result.alertFingerprint = alertFingerprint;
    if (velocityScore != null) result.velocityScore = velocityScore;
    if (thresholdValue != null) result.thresholdValue = thresholdValue;
    if (deliveredAt != null) result.deliveredAt = deliveredAt;
    if (cooldownUntil != null) result.cooldownUntil = cooldownUntil;
    if (isBatchedSummary != null) result.isBatchedSummary = isBatchedSummary;
    if (batchedAlertCount != null) result.batchedAlertCount = batchedAlertCount;
    return result;
  }

  WatchlistAlert._();

  factory WatchlistAlert.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistAlert()..mergeFromBuffer(data, registry);
  factory WatchlistAlert.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistAlert()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistAlert',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistAlert.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'alertLogId')
    ..aOS(2, _omitFieldNames ? '' : 'watchlistId')
    ..aOS(3, _omitFieldNames ? '' : 'trendId')
    ..aOS(4, _omitFieldNames ? '' : 'trendTitle')
    ..aOS(5, _omitFieldNames ? '' : 'alertFingerprint')
    ..aD(6, _omitFieldNames ? '' : 'velocityScore',
        fieldType: $pb.PbFieldType.OF)
    ..aD(7, _omitFieldNames ? '' : 'thresholdValue',
        fieldType: $pb.PbFieldType.OF)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'deliveredAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'cooldownUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOB(10, _omitFieldNames ? '' : 'isBatchedSummary')
    ..aI(11, _omitFieldNames ? '' : 'batchedAlertCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistAlert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistAlert copyWith(void Function(WatchlistAlert) updates) =>
      super.copyWith((message) => updates(message as WatchlistAlert))
          as WatchlistAlert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WatchlistAlert() / WatchlistAlert.new instead')
  static WatchlistAlert create() => WatchlistAlert._();
  static $pb.GeneratedMessage $_createMessage() => WatchlistAlert._();
  @$core.override
  WatchlistAlert createEmptyInstance() => WatchlistAlert._();
  @$core.pragma('dart2js:noInline')
  static WatchlistAlert getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchlistAlert>(
          WatchlistAlert.$_createMessage);
  static WatchlistAlert? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alertLogId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alertLogId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlertLogId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlertLogId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get watchlistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set watchlistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWatchlistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWatchlistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trendId => $_getSZ(2);
  @$pb.TagNumber(3)
  set trendId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrendId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrendId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get trendTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set trendTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrendTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrendTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get alertFingerprint => $_getSZ(4);
  @$pb.TagNumber(5)
  set alertFingerprint($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAlertFingerprint() => $_has(4);
  @$pb.TagNumber(5)
  void clearAlertFingerprint() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get velocityScore => $_getN(5);
  @$pb.TagNumber(6)
  set velocityScore($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVelocityScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearVelocityScore() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get thresholdValue => $_getN(6);
  @$pb.TagNumber(7)
  set thresholdValue($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasThresholdValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearThresholdValue() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get deliveredAt => $_getN(7);
  @$pb.TagNumber(8)
  set deliveredAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDeliveredAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeliveredAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureDeliveredAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.Timestamp get cooldownUntil => $_getN(8);
  @$pb.TagNumber(9)
  set cooldownUntil($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCooldownUntil() => $_has(8);
  @$pb.TagNumber(9)
  void clearCooldownUntil() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureCooldownUntil() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.bool get isBatchedSummary => $_getBF(9);
  @$pb.TagNumber(10)
  set isBatchedSummary($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsBatchedSummary() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsBatchedSummary() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get batchedAlertCount => $_getIZ(10);
  @$pb.TagNumber(11)
  set batchedAlertCount($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBatchedAlertCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearBatchedAlertCount() => $_clearField(11);
}

class TrendServiceListRequest extends $pb.GeneratedMessage {
  factory TrendServiceListRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? category,
    $core.String? platform,
    ConfidenceBand? minConfidence,
    $core.double? minStrengthScore,
    $core.String? sortBy,
    $2.Pagination? pagination,
  }) {
    final result = TrendServiceListRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (category != null) result.category = category;
    if (platform != null) result.platform = platform;
    if (minConfidence != null) result.minConfidence = minConfidence;
    if (minStrengthScore != null) result.minStrengthScore = minStrengthScore;
    if (sortBy != null) result.sortBy = sortBy;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  TrendServiceListRequest._();

  factory TrendServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceListRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..aOS(4, _omitFieldNames ? '' : 'platform')
    ..aE<ConfidenceBand>(5, _omitFieldNames ? '' : 'minConfidence',
        enumValues: ConfidenceBand.values)
    ..aD(6, _omitFieldNames ? '' : 'minStrengthScore',
        fieldType: $pb.PbFieldType.OF)
    ..aOS(7, _omitFieldNames ? '' : 'sortBy')
    ..aOM<$2.Pagination>(8, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListRequest copyWith(
          void Function(TrendServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as TrendServiceListRequest))
          as TrendServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceListRequest() / TrendServiceListRequest.new instead')
  static TrendServiceListRequest create() => TrendServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => TrendServiceListRequest._();
  @$core.override
  TrendServiceListRequest createEmptyInstance() => TrendServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceListRequest>(
          TrendServiceListRequest.$_createMessage);
  static TrendServiceListRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get platform => $_getSZ(3);
  @$pb.TagNumber(4)
  set platform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatform() => $_clearField(4);

  @$pb.TagNumber(5)
  ConfidenceBand get minConfidence => $_getN(4);
  @$pb.TagNumber(5)
  set minConfidence(ConfidenceBand value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMinConfidence() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinConfidence() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get minStrengthScore => $_getN(5);
  @$pb.TagNumber(6)
  set minStrengthScore($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinStrengthScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinStrengthScore() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sortBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set sortBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSortBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearSortBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Pagination get pagination => $_getN(7);
  @$pb.TagNumber(8)
  set pagination($2.Pagination value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPagination() => $_has(7);
  @$pb.TagNumber(8)
  void clearPagination() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Pagination ensurePagination() => $_ensure(7);
}

class TrendServiceListResponse extends $pb.GeneratedMessage {
  factory TrendServiceListResponse({
    $core.Iterable<Trend>? trends,
    $2.Pagination? pagination,
    $core.int? totalCount,
    $core.bool? sourceDegraded,
    $core.Iterable<$core.String>? disconnectedSources,
  }) {
    final result = TrendServiceListResponse._();
    if (trends != null) result.trends.addAll(trends);
    if (pagination != null) result.pagination = pagination;
    if (totalCount != null) result.totalCount = totalCount;
    if (sourceDegraded != null) result.sourceDegraded = sourceDegraded;
    if (disconnectedSources != null)
      result.disconnectedSources.addAll(disconnectedSources);
    return result;
  }

  TrendServiceListResponse._();

  factory TrendServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceListResponse.$_createMessage)
    ..pPM<Trend>(1, _omitFieldNames ? '' : 'trends',
        subBuilder: Trend.$_createMessage)
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..aOB(4, _omitFieldNames ? '' : 'sourceDegraded')
    ..pPS(5, _omitFieldNames ? '' : 'disconnectedSources')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListResponse copyWith(
          void Function(TrendServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as TrendServiceListResponse))
          as TrendServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceListResponse() / TrendServiceListResponse.new instead')
  static TrendServiceListResponse create() => TrendServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() => TrendServiceListResponse._();
  @$core.override
  TrendServiceListResponse createEmptyInstance() =>
      TrendServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceListResponse>(
          TrendServiceListResponse.$_createMessage);
  static TrendServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Trend> get trends => $_getList(0);

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

  @$pb.TagNumber(3)
  $core.int get totalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get sourceDegraded => $_getBF(3);
  @$pb.TagNumber(4)
  set sourceDegraded($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceDegraded() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceDegraded() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get disconnectedSources => $_getList(4);
}

class TrendServiceGetRequest extends $pb.GeneratedMessage {
  factory TrendServiceGetRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? trendId,
  }) {
    final result = TrendServiceGetRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trendId != null) result.trendId = trendId;
    return result;
  }

  TrendServiceGetRequest._();

  factory TrendServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'trendId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetRequest copyWith(
          void Function(TrendServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as TrendServiceGetRequest))
          as TrendServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetRequest() / TrendServiceGetRequest.new instead')
  static TrendServiceGetRequest create() => TrendServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => TrendServiceGetRequest._();
  @$core.override
  TrendServiceGetRequest createEmptyInstance() => TrendServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetRequest>(
          TrendServiceGetRequest.$_createMessage);
  static TrendServiceGetRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trendId => $_getSZ(2);
  @$pb.TagNumber(3)
  set trendId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrendId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrendId() => $_clearField(3);
}

class TrendServiceGetResponse extends $pb.GeneratedMessage {
  factory TrendServiceGetResponse({
    Trend? trend,
    $core.Iterable<SignalRef>? lineageSignals,
    $core.String? improvementAdvice,
  }) {
    final result = TrendServiceGetResponse._();
    if (trend != null) result.trend = trend;
    if (lineageSignals != null) result.lineageSignals.addAll(lineageSignals);
    if (improvementAdvice != null) result.improvementAdvice = improvementAdvice;
    return result;
  }

  TrendServiceGetResponse._();

  factory TrendServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetResponse.$_createMessage)
    ..aOM<Trend>(1, _omitFieldNames ? '' : 'trend',
        subBuilder: Trend.$_createMessage)
    ..pPM<SignalRef>(2, _omitFieldNames ? '' : 'lineageSignals',
        subBuilder: SignalRef.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'improvementAdvice')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetResponse copyWith(
          void Function(TrendServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as TrendServiceGetResponse))
          as TrendServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetResponse() / TrendServiceGetResponse.new instead')
  static TrendServiceGetResponse create() => TrendServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => TrendServiceGetResponse._();
  @$core.override
  TrendServiceGetResponse createEmptyInstance() => TrendServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetResponse>(
          TrendServiceGetResponse.$_createMessage);
  static TrendServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Trend get trend => $_getN(0);
  @$pb.TagNumber(1)
  set trend(Trend value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrend() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrend() => $_clearField(1);
  @$pb.TagNumber(1)
  Trend ensureTrend() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<SignalRef> get lineageSignals => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get improvementAdvice => $_getSZ(2);
  @$pb.TagNumber(3)
  set improvementAdvice($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImprovementAdvice() => $_has(2);
  @$pb.TagNumber(3)
  void clearImprovementAdvice() => $_clearField(3);
}

class TrendServiceSearchRequest extends $pb.GeneratedMessage {
  factory TrendServiceSearchRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? query,
    $core.Iterable<$core.double>? queryEmbedding,
    $core.int? limit,
  }) {
    final result = TrendServiceSearchRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (query != null) result.query = query;
    if (queryEmbedding != null) result.queryEmbedding.addAll(queryEmbedding);
    if (limit != null) result.limit = limit;
    return result;
  }

  TrendServiceSearchRequest._();

  factory TrendServiceSearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceSearchRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceSearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceSearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceSearchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceSearchRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'query')
    ..p<$core.double>(
        4, _omitFieldNames ? '' : 'queryEmbedding', $pb.PbFieldType.KF)
    ..aI(5, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceSearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceSearchRequest copyWith(
          void Function(TrendServiceSearchRequest) updates) =>
      super.copyWith((message) => updates(message as TrendServiceSearchRequest))
          as TrendServiceSearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceSearchRequest() / TrendServiceSearchRequest.new instead')
  static TrendServiceSearchRequest create() => TrendServiceSearchRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceSearchRequest._();
  @$core.override
  TrendServiceSearchRequest createEmptyInstance() =>
      TrendServiceSearchRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceSearchRequest>(
          TrendServiceSearchRequest.$_createMessage);
  static TrendServiceSearchRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get query => $_getSZ(2);
  @$pb.TagNumber(3)
  set query($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuery() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuery() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.double> get queryEmbedding => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get limit => $_getIZ(4);
  @$pb.TagNumber(5)
  set limit($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLimit() => $_has(4);
  @$pb.TagNumber(5)
  void clearLimit() => $_clearField(5);
}

class TrendServiceSearchResponse extends $pb.GeneratedMessage {
  factory TrendServiceSearchResponse({
    $core.Iterable<Trend>? results,
    $core.int? totalMatches,
    $core.String? searchStrategy,
  }) {
    final result = TrendServiceSearchResponse._();
    if (results != null) result.results.addAll(results);
    if (totalMatches != null) result.totalMatches = totalMatches;
    if (searchStrategy != null) result.searchStrategy = searchStrategy;
    return result;
  }

  TrendServiceSearchResponse._();

  factory TrendServiceSearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceSearchResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceSearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceSearchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceSearchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceSearchResponse.$_createMessage)
    ..pPM<Trend>(1, _omitFieldNames ? '' : 'results',
        subBuilder: Trend.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'totalMatches')
    ..aOS(3, _omitFieldNames ? '' : 'searchStrategy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceSearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceSearchResponse copyWith(
          void Function(TrendServiceSearchResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceSearchResponse))
          as TrendServiceSearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceSearchResponse() / TrendServiceSearchResponse.new instead')
  static TrendServiceSearchResponse create() => TrendServiceSearchResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceSearchResponse._();
  @$core.override
  TrendServiceSearchResponse createEmptyInstance() =>
      TrendServiceSearchResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceSearchResponse>(
          TrendServiceSearchResponse.$_createMessage);
  static TrendServiceSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Trend> get results => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalMatches => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalMatches($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalMatches() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalMatches() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get searchStrategy => $_getSZ(2);
  @$pb.TagNumber(3)
  set searchStrategy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSearchStrategy() => $_has(2);
  @$pb.TagNumber(3)
  void clearSearchStrategy() => $_clearField(3);
}

class TrendServiceManageWatchlistRequest extends $pb.GeneratedMessage {
  factory TrendServiceManageWatchlistRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? action,
    $core.String? watchlistId,
    $core.String? name,
    $core.String? type,
    $core.String? criteriaJson,
    $core.bool? alertEnabled,
    AlertThreshold? alertThreshold,
    $core.String? trendId,
  }) {
    final result = TrendServiceManageWatchlistRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (action != null) result.action = action;
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (criteriaJson != null) result.criteriaJson = criteriaJson;
    if (alertEnabled != null) result.alertEnabled = alertEnabled;
    if (alertThreshold != null) result.alertThreshold = alertThreshold;
    if (trendId != null) result.trendId = trendId;
    return result;
  }

  TrendServiceManageWatchlistRequest._();

  factory TrendServiceManageWatchlistRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceManageWatchlistRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceManageWatchlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceManageWatchlistRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceManageWatchlistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceManageWatchlistRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'action')
    ..aOS(4, _omitFieldNames ? '' : 'watchlistId')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..aOS(6, _omitFieldNames ? '' : 'type')
    ..aOS(7, _omitFieldNames ? '' : 'criteriaJson')
    ..aOB(8, _omitFieldNames ? '' : 'alertEnabled')
    ..aOM<AlertThreshold>(9, _omitFieldNames ? '' : 'alertThreshold',
        subBuilder: AlertThreshold.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'trendId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceManageWatchlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceManageWatchlistRequest copyWith(
          void Function(TrendServiceManageWatchlistRequest) updates) =>
      super.copyWith((message) =>
              updates(message as TrendServiceManageWatchlistRequest))
          as TrendServiceManageWatchlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceManageWatchlistRequest() / TrendServiceManageWatchlistRequest.new instead')
  static TrendServiceManageWatchlistRequest create() =>
      TrendServiceManageWatchlistRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceManageWatchlistRequest._();
  @$core.override
  TrendServiceManageWatchlistRequest createEmptyInstance() =>
      TrendServiceManageWatchlistRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceManageWatchlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceManageWatchlistRequest>(
          TrendServiceManageWatchlistRequest.$_createMessage);
  static TrendServiceManageWatchlistRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get action => $_getSZ(2);
  @$pb.TagNumber(3)
  set action($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get watchlistId => $_getSZ(3);
  @$pb.TagNumber(4)
  set watchlistId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWatchlistId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWatchlistId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get type => $_getSZ(5);
  @$pb.TagNumber(6)
  set type($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(6)
  void clearType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get criteriaJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set criteriaJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCriteriaJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearCriteriaJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get alertEnabled => $_getBF(7);
  @$pb.TagNumber(8)
  set alertEnabled($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAlertEnabled() => $_has(7);
  @$pb.TagNumber(8)
  void clearAlertEnabled() => $_clearField(8);

  @$pb.TagNumber(9)
  AlertThreshold get alertThreshold => $_getN(8);
  @$pb.TagNumber(9)
  set alertThreshold(AlertThreshold value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAlertThreshold() => $_has(8);
  @$pb.TagNumber(9)
  void clearAlertThreshold() => $_clearField(9);
  @$pb.TagNumber(9)
  AlertThreshold ensureAlertThreshold() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get trendId => $_getSZ(9);
  @$pb.TagNumber(10)
  set trendId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTrendId() => $_has(9);
  @$pb.TagNumber(10)
  void clearTrendId() => $_clearField(10);
}

class TrendServiceManageWatchlistResponse extends $pb.GeneratedMessage {
  factory TrendServiceManageWatchlistResponse({
    $core.bool? success,
    Watchlist? watchlist,
    $core.String? message,
  }) {
    final result = TrendServiceManageWatchlistResponse._();
    if (success != null) result.success = success;
    if (watchlist != null) result.watchlist = watchlist;
    if (message != null) result.message = message;
    return result;
  }

  TrendServiceManageWatchlistResponse._();

  factory TrendServiceManageWatchlistResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceManageWatchlistResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceManageWatchlistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceManageWatchlistResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceManageWatchlistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceManageWatchlistResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<Watchlist>(2, _omitFieldNames ? '' : 'watchlist',
        subBuilder: Watchlist.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceManageWatchlistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceManageWatchlistResponse copyWith(
          void Function(TrendServiceManageWatchlistResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TrendServiceManageWatchlistResponse))
          as TrendServiceManageWatchlistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceManageWatchlistResponse() / TrendServiceManageWatchlistResponse.new instead')
  static TrendServiceManageWatchlistResponse create() =>
      TrendServiceManageWatchlistResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceManageWatchlistResponse._();
  @$core.override
  TrendServiceManageWatchlistResponse createEmptyInstance() =>
      TrendServiceManageWatchlistResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceManageWatchlistResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              TrendServiceManageWatchlistResponse>(
          TrendServiceManageWatchlistResponse.$_createMessage);
  static TrendServiceManageWatchlistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  Watchlist get watchlist => $_getN(1);
  @$pb.TagNumber(2)
  set watchlist(Watchlist value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWatchlist() => $_has(1);
  @$pb.TagNumber(2)
  void clearWatchlist() => $_clearField(2);
  @$pb.TagNumber(2)
  Watchlist ensureWatchlist() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class TrendServiceGetTopRequest extends $pb.GeneratedMessage {
  factory TrendServiceGetTopRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.int? limit,
  }) {
    final result = TrendServiceGetTopRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (limit != null) result.limit = limit;
    return result;
  }

  TrendServiceGetTopRequest._();

  factory TrendServiceGetTopRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetTopRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceGetTopRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetTopRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetTopRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetTopRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetTopRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetTopRequest copyWith(
          void Function(TrendServiceGetTopRequest) updates) =>
      super.copyWith((message) => updates(message as TrendServiceGetTopRequest))
          as TrendServiceGetTopRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetTopRequest() / TrendServiceGetTopRequest.new instead')
  static TrendServiceGetTopRequest create() => TrendServiceGetTopRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetTopRequest._();
  @$core.override
  TrendServiceGetTopRequest createEmptyInstance() =>
      TrendServiceGetTopRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetTopRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetTopRequest>(
          TrendServiceGetTopRequest.$_createMessage);
  static TrendServiceGetTopRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class TrendServiceGetTopResponse extends $pb.GeneratedMessage {
  factory TrendServiceGetTopResponse({
    $core.Iterable<Trend>? topTrends,
  }) {
    final result = TrendServiceGetTopResponse._();
    if (topTrends != null) result.topTrends.addAll(topTrends);
    return result;
  }

  TrendServiceGetTopResponse._();

  factory TrendServiceGetTopResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetTopResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceGetTopResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetTopResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetTopResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetTopResponse.$_createMessage)
    ..pPM<Trend>(1, _omitFieldNames ? '' : 'topTrends',
        subBuilder: Trend.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetTopResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetTopResponse copyWith(
          void Function(TrendServiceGetTopResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceGetTopResponse))
          as TrendServiceGetTopResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetTopResponse() / TrendServiceGetTopResponse.new instead')
  static TrendServiceGetTopResponse create() => TrendServiceGetTopResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetTopResponse._();
  @$core.override
  TrendServiceGetTopResponse createEmptyInstance() =>
      TrendServiceGetTopResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetTopResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetTopResponse>(
          TrendServiceGetTopResponse.$_createMessage);
  static TrendServiceGetTopResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Trend> get topTrends => $_getList(0);
}

class TrendServiceListTopRequest extends $pb.GeneratedMessage {
  factory TrendServiceListTopRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? timeWindow,
    $core.int? limit,
  }) {
    final result = TrendServiceListTopRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (timeWindow != null) result.timeWindow = timeWindow;
    if (limit != null) result.limit = limit;
    return result;
  }

  TrendServiceListTopRequest._();

  factory TrendServiceListTopRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListTopRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceListTopRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListTopRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceListTopRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceListTopRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'timeWindow')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListTopRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListTopRequest copyWith(
          void Function(TrendServiceListTopRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceListTopRequest))
          as TrendServiceListTopRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceListTopRequest() / TrendServiceListTopRequest.new instead')
  static TrendServiceListTopRequest create() => TrendServiceListTopRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceListTopRequest._();
  @$core.override
  TrendServiceListTopRequest createEmptyInstance() =>
      TrendServiceListTopRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceListTopRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceListTopRequest>(
          TrendServiceListTopRequest.$_createMessage);
  static TrendServiceListTopRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get timeWindow => $_getSZ(2);
  @$pb.TagNumber(3)
  set timeWindow($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeWindow() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeWindow() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);
}

class TrendServiceListTopResponse extends $pb.GeneratedMessage {
  factory TrendServiceListTopResponse({
    $core.Iterable<Trend>? trends,
  }) {
    final result = TrendServiceListTopResponse._();
    if (trends != null) result.trends.addAll(trends);
    return result;
  }

  TrendServiceListTopResponse._();

  factory TrendServiceListTopResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListTopResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceListTopResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListTopResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceListTopResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceListTopResponse.$_createMessage)
    ..pPM<Trend>(1, _omitFieldNames ? '' : 'trends',
        subBuilder: Trend.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListTopResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListTopResponse copyWith(
          void Function(TrendServiceListTopResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceListTopResponse))
          as TrendServiceListTopResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceListTopResponse() / TrendServiceListTopResponse.new instead')
  static TrendServiceListTopResponse create() =>
      TrendServiceListTopResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceListTopResponse._();
  @$core.override
  TrendServiceListTopResponse createEmptyInstance() =>
      TrendServiceListTopResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceListTopResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceListTopResponse>(
          TrendServiceListTopResponse.$_createMessage);
  static TrendServiceListTopResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Trend> get trends => $_getList(0);
}

class TrendServiceListRelatedRequest extends $pb.GeneratedMessage {
  factory TrendServiceListRelatedRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? trendId,
  }) {
    final result = TrendServiceListRelatedRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trendId != null) result.trendId = trendId;
    return result;
  }

  TrendServiceListRelatedRequest._();

  factory TrendServiceListRelatedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListRelatedRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceListRelatedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListRelatedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceListRelatedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceListRelatedRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'trendId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListRelatedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListRelatedRequest copyWith(
          void Function(TrendServiceListRelatedRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceListRelatedRequest))
          as TrendServiceListRelatedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceListRelatedRequest() / TrendServiceListRelatedRequest.new instead')
  static TrendServiceListRelatedRequest create() =>
      TrendServiceListRelatedRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceListRelatedRequest._();
  @$core.override
  TrendServiceListRelatedRequest createEmptyInstance() =>
      TrendServiceListRelatedRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceListRelatedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceListRelatedRequest>(
          TrendServiceListRelatedRequest.$_createMessage);
  static TrendServiceListRelatedRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trendId => $_getSZ(2);
  @$pb.TagNumber(3)
  set trendId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrendId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrendId() => $_clearField(3);
}

class TrendServiceListRelatedResponse extends $pb.GeneratedMessage {
  factory TrendServiceListRelatedResponse({
    $core.Iterable<Trend>? relatedTrends,
  }) {
    final result = TrendServiceListRelatedResponse._();
    if (relatedTrends != null) result.relatedTrends.addAll(relatedTrends);
    return result;
  }

  TrendServiceListRelatedResponse._();

  factory TrendServiceListRelatedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListRelatedResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceListRelatedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceListRelatedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceListRelatedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceListRelatedResponse.$_createMessage)
    ..pPM<Trend>(1, _omitFieldNames ? '' : 'relatedTrends',
        subBuilder: Trend.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListRelatedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceListRelatedResponse copyWith(
          void Function(TrendServiceListRelatedResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceListRelatedResponse))
          as TrendServiceListRelatedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceListRelatedResponse() / TrendServiceListRelatedResponse.new instead')
  static TrendServiceListRelatedResponse create() =>
      TrendServiceListRelatedResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceListRelatedResponse._();
  @$core.override
  TrendServiceListRelatedResponse createEmptyInstance() =>
      TrendServiceListRelatedResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceListRelatedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceListRelatedResponse>(
          TrendServiceListRelatedResponse.$_createMessage);
  static TrendServiceListRelatedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Trend> get relatedTrends => $_getList(0);
}

class TrendServiceGetTimeSeriesRequest extends $pb.GeneratedMessage {
  factory TrendServiceGetTimeSeriesRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? trendId,
    $core.String? interval,
  }) {
    final result = TrendServiceGetTimeSeriesRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trendId != null) result.trendId = trendId;
    if (interval != null) result.interval = interval;
    return result;
  }

  TrendServiceGetTimeSeriesRequest._();

  factory TrendServiceGetTimeSeriesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetTimeSeriesRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceGetTimeSeriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetTimeSeriesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetTimeSeriesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetTimeSeriesRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'trendId')
    ..aOS(4, _omitFieldNames ? '' : 'interval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetTimeSeriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetTimeSeriesRequest copyWith(
          void Function(TrendServiceGetTimeSeriesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceGetTimeSeriesRequest))
          as TrendServiceGetTimeSeriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetTimeSeriesRequest() / TrendServiceGetTimeSeriesRequest.new instead')
  static TrendServiceGetTimeSeriesRequest create() =>
      TrendServiceGetTimeSeriesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetTimeSeriesRequest._();
  @$core.override
  TrendServiceGetTimeSeriesRequest createEmptyInstance() =>
      TrendServiceGetTimeSeriesRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetTimeSeriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetTimeSeriesRequest>(
          TrendServiceGetTimeSeriesRequest.$_createMessage);
  static TrendServiceGetTimeSeriesRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trendId => $_getSZ(2);
  @$pb.TagNumber(3)
  set trendId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrendId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrendId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get interval => $_getSZ(3);
  @$pb.TagNumber(4)
  set interval($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInterval() => $_has(3);
  @$pb.TagNumber(4)
  void clearInterval() => $_clearField(4);
}

class TimeSeriesPoint extends $pb.GeneratedMessage {
  factory TimeSeriesPoint({
    $1.Timestamp? timestamp,
    $core.double? volume,
    $core.double? velocity,
  }) {
    final result = TimeSeriesPoint._();
    if (timestamp != null) result.timestamp = timestamp;
    if (volume != null) result.volume = volume;
    if (velocity != null) result.velocity = velocity;
    return result;
  }

  TimeSeriesPoint._();

  factory TimeSeriesPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TimeSeriesPoint()..mergeFromBuffer(data, registry);
  factory TimeSeriesPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TimeSeriesPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimeSeriesPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TimeSeriesPoint.$_createMessage)
    ..aOM<$1.Timestamp>(1, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aD(2, _omitFieldNames ? '' : 'volume', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'velocity', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeSeriesPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeSeriesPoint copyWith(void Function(TimeSeriesPoint) updates) =>
      super.copyWith((message) => updates(message as TimeSeriesPoint))
          as TimeSeriesPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TimeSeriesPoint() / TimeSeriesPoint.new instead')
  static TimeSeriesPoint create() => TimeSeriesPoint._();
  static $pb.GeneratedMessage $_createMessage() => TimeSeriesPoint._();
  @$core.override
  TimeSeriesPoint createEmptyInstance() => TimeSeriesPoint._();
  @$core.pragma('dart2js:noInline')
  static TimeSeriesPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeSeriesPoint>(
          TimeSeriesPoint.$_createMessage);
  static TimeSeriesPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Timestamp get timestamp => $_getN(0);
  @$pb.TagNumber(1)
  set timestamp($1.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Timestamp ensureTimestamp() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get volume => $_getN(1);
  @$pb.TagNumber(2)
  set volume($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVolume() => $_has(1);
  @$pb.TagNumber(2)
  void clearVolume() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get velocity => $_getN(2);
  @$pb.TagNumber(3)
  set velocity($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVelocity() => $_has(2);
  @$pb.TagNumber(3)
  void clearVelocity() => $_clearField(3);
}

class TrendServiceGetTimeSeriesResponse extends $pb.GeneratedMessage {
  factory TrendServiceGetTimeSeriesResponse({
    $core.String? trendId,
    $core.Iterable<TimeSeriesPoint>? points,
  }) {
    final result = TrendServiceGetTimeSeriesResponse._();
    if (trendId != null) result.trendId = trendId;
    if (points != null) result.points.addAll(points);
    return result;
  }

  TrendServiceGetTimeSeriesResponse._();

  factory TrendServiceGetTimeSeriesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetTimeSeriesResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceGetTimeSeriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetTimeSeriesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetTimeSeriesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetTimeSeriesResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'trendId')
    ..pPM<TimeSeriesPoint>(2, _omitFieldNames ? '' : 'points',
        subBuilder: TimeSeriesPoint.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetTimeSeriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetTimeSeriesResponse copyWith(
          void Function(TrendServiceGetTimeSeriesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TrendServiceGetTimeSeriesResponse))
          as TrendServiceGetTimeSeriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetTimeSeriesResponse() / TrendServiceGetTimeSeriesResponse.new instead')
  static TrendServiceGetTimeSeriesResponse create() =>
      TrendServiceGetTimeSeriesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetTimeSeriesResponse._();
  @$core.override
  TrendServiceGetTimeSeriesResponse createEmptyInstance() =>
      TrendServiceGetTimeSeriesResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetTimeSeriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetTimeSeriesResponse>(
          TrendServiceGetTimeSeriesResponse.$_createMessage);
  static TrendServiceGetTimeSeriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trendId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trendId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrendId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrendId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<TimeSeriesPoint> get points => $_getList(1);
}

class TrendServiceGetSparklinesRequest extends $pb.GeneratedMessage {
  factory TrendServiceGetSparklinesRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.Iterable<$core.String>? trendIds,
  }) {
    final result = TrendServiceGetSparklinesRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trendIds != null) result.trendIds.addAll(trendIds);
    return result;
  }

  TrendServiceGetSparklinesRequest._();

  factory TrendServiceGetSparklinesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetSparklinesRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceGetSparklinesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetSparklinesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetSparklinesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetSparklinesRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..pPS(3, _omitFieldNames ? '' : 'trendIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetSparklinesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetSparklinesRequest copyWith(
          void Function(TrendServiceGetSparklinesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceGetSparklinesRequest))
          as TrendServiceGetSparklinesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetSparklinesRequest() / TrendServiceGetSparklinesRequest.new instead')
  static TrendServiceGetSparklinesRequest create() =>
      TrendServiceGetSparklinesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetSparklinesRequest._();
  @$core.override
  TrendServiceGetSparklinesRequest createEmptyInstance() =>
      TrendServiceGetSparklinesRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetSparklinesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetSparklinesRequest>(
          TrendServiceGetSparklinesRequest.$_createMessage);
  static TrendServiceGetSparklinesRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get trendIds => $_getList(2);
}

class SparklineData extends $pb.GeneratedMessage {
  factory SparklineData({
    $core.String? trendId,
    $core.Iterable<$core.double>? values,
  }) {
    final result = SparklineData._();
    if (trendId != null) result.trendId = trendId;
    if (values != null) result.values.addAll(values);
    return result;
  }

  SparklineData._();

  factory SparklineData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SparklineData()..mergeFromBuffer(data, registry);
  factory SparklineData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SparklineData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SparklineData',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: SparklineData.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'trendId')
    ..p<$core.double>(2, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SparklineData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SparklineData copyWith(void Function(SparklineData) updates) =>
      super.copyWith((message) => updates(message as SparklineData))
          as SparklineData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SparklineData() / SparklineData.new instead')
  static SparklineData create() => SparklineData._();
  static $pb.GeneratedMessage $_createMessage() => SparklineData._();
  @$core.override
  SparklineData createEmptyInstance() => SparklineData._();
  @$core.pragma('dart2js:noInline')
  static SparklineData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SparklineData>(
          SparklineData.$_createMessage);
  static SparklineData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trendId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trendId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrendId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrendId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get values => $_getList(1);
}

class TrendServiceGetSparklinesResponse extends $pb.GeneratedMessage {
  factory TrendServiceGetSparklinesResponse({
    $core.Iterable<SparklineData>? sparklines,
  }) {
    final result = TrendServiceGetSparklinesResponse._();
    if (sparklines != null) result.sparklines.addAll(sparklines);
    return result;
  }

  TrendServiceGetSparklinesResponse._();

  factory TrendServiceGetSparklinesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetSparklinesResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceGetSparklinesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetSparklinesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetSparklinesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetSparklinesResponse.$_createMessage)
    ..pPM<SparklineData>(1, _omitFieldNames ? '' : 'sparklines',
        subBuilder: SparklineData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetSparklinesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetSparklinesResponse copyWith(
          void Function(TrendServiceGetSparklinesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TrendServiceGetSparklinesResponse))
          as TrendServiceGetSparklinesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetSparklinesResponse() / TrendServiceGetSparklinesResponse.new instead')
  static TrendServiceGetSparklinesResponse create() =>
      TrendServiceGetSparklinesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetSparklinesResponse._();
  @$core.override
  TrendServiceGetSparklinesResponse createEmptyInstance() =>
      TrendServiceGetSparklinesResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetSparklinesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetSparklinesResponse>(
          TrendServiceGetSparklinesResponse.$_createMessage);
  static TrendServiceGetSparklinesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SparklineData> get sparklines => $_getList(0);
}

class TrendServiceGetStatsRequest extends $pb.GeneratedMessage {
  factory TrendServiceGetStatsRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
  }) {
    final result = TrendServiceGetStatsRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  TrendServiceGetStatsRequest._();

  factory TrendServiceGetStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetStatsRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceGetStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetStatsRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetStatsRequest copyWith(
          void Function(TrendServiceGetStatsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceGetStatsRequest))
          as TrendServiceGetStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetStatsRequest() / TrendServiceGetStatsRequest.new instead')
  static TrendServiceGetStatsRequest create() =>
      TrendServiceGetStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetStatsRequest._();
  @$core.override
  TrendServiceGetStatsRequest createEmptyInstance() =>
      TrendServiceGetStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetStatsRequest>(
          TrendServiceGetStatsRequest.$_createMessage);
  static TrendServiceGetStatsRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
}

class TrendServiceGetStatsResponse extends $pb.GeneratedMessage {
  factory TrendServiceGetStatsResponse({
    $core.int? totalActiveTrends,
    $core.int? newToday,
    $core.int? spikingCount,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>?
        platformDistribution,
    $core.bool? sourceDegraded,
    $core.Iterable<$core.String>? disconnectedSources,
  }) {
    final result = TrendServiceGetStatsResponse._();
    if (totalActiveTrends != null) result.totalActiveTrends = totalActiveTrends;
    if (newToday != null) result.newToday = newToday;
    if (spikingCount != null) result.spikingCount = spikingCount;
    if (platformDistribution != null)
      result.platformDistribution.addEntries(platformDistribution);
    if (sourceDegraded != null) result.sourceDegraded = sourceDegraded;
    if (disconnectedSources != null)
      result.disconnectedSources.addAll(disconnectedSources);
    return result;
  }

  TrendServiceGetStatsResponse._();

  factory TrendServiceGetStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetStatsResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceGetStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetStatsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalActiveTrends')
    ..aI(2, _omitFieldNames ? '' : 'newToday')
    ..aI(3, _omitFieldNames ? '' : 'spikingCount')
    ..m<$core.String, $core.int>(
        4, _omitFieldNames ? '' : 'platformDistribution',
        entryClassName:
            'TrendServiceGetStatsResponse.PlatformDistributionEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('creativanta.intelligence.v1'))
    ..aOB(5, _omitFieldNames ? '' : 'sourceDegraded')
    ..pPS(6, _omitFieldNames ? '' : 'disconnectedSources')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetStatsResponse copyWith(
          void Function(TrendServiceGetStatsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceGetStatsResponse))
          as TrendServiceGetStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetStatsResponse() / TrendServiceGetStatsResponse.new instead')
  static TrendServiceGetStatsResponse create() =>
      TrendServiceGetStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetStatsResponse._();
  @$core.override
  TrendServiceGetStatsResponse createEmptyInstance() =>
      TrendServiceGetStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetStatsResponse>(
          TrendServiceGetStatsResponse.$_createMessage);
  static TrendServiceGetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalActiveTrends => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalActiveTrends($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalActiveTrends() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalActiveTrends() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get newToday => $_getIZ(1);
  @$pb.TagNumber(2)
  set newToday($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewToday() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewToday() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get spikingCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set spikingCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSpikingCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpikingCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.int> get platformDistribution => $_getMap(3);

  @$pb.TagNumber(5)
  $core.bool get sourceDegraded => $_getBF(4);
  @$pb.TagNumber(5)
  set sourceDegraded($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceDegraded() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceDegraded() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get disconnectedSources => $_getList(5);
}

class TrendServiceGetExamplesRequest extends $pb.GeneratedMessage {
  factory TrendServiceGetExamplesRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? trendId,
  }) {
    final result = TrendServiceGetExamplesRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trendId != null) result.trendId = trendId;
    return result;
  }

  TrendServiceGetExamplesRequest._();

  factory TrendServiceGetExamplesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetExamplesRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceGetExamplesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetExamplesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetExamplesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetExamplesRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'trendId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetExamplesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetExamplesRequest copyWith(
          void Function(TrendServiceGetExamplesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceGetExamplesRequest))
          as TrendServiceGetExamplesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetExamplesRequest() / TrendServiceGetExamplesRequest.new instead')
  static TrendServiceGetExamplesRequest create() =>
      TrendServiceGetExamplesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetExamplesRequest._();
  @$core.override
  TrendServiceGetExamplesRequest createEmptyInstance() =>
      TrendServiceGetExamplesRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetExamplesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetExamplesRequest>(
          TrendServiceGetExamplesRequest.$_createMessage);
  static TrendServiceGetExamplesRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trendId => $_getSZ(2);
  @$pb.TagNumber(3)
  set trendId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrendId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrendId() => $_clearField(3);
}

class TrendExampleItem extends $pb.GeneratedMessage {
  factory TrendExampleItem({
    $core.String? externalUrl,
    $core.String? platform,
    $core.String? creatorHandle,
    $core.String? caption,
    $fixnum.Int64? viewCount,
  }) {
    final result = TrendExampleItem._();
    if (externalUrl != null) result.externalUrl = externalUrl;
    if (platform != null) result.platform = platform;
    if (creatorHandle != null) result.creatorHandle = creatorHandle;
    if (caption != null) result.caption = caption;
    if (viewCount != null) result.viewCount = viewCount;
    return result;
  }

  TrendExampleItem._();

  factory TrendExampleItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendExampleItem()..mergeFromBuffer(data, registry);
  factory TrendExampleItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendExampleItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendExampleItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendExampleItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'externalUrl')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'creatorHandle')
    ..aOS(4, _omitFieldNames ? '' : 'caption')
    ..aInt64(5, _omitFieldNames ? '' : 'viewCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendExampleItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendExampleItem copyWith(void Function(TrendExampleItem) updates) =>
      super.copyWith((message) => updates(message as TrendExampleItem))
          as TrendExampleItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TrendExampleItem() / TrendExampleItem.new instead')
  static TrendExampleItem create() => TrendExampleItem._();
  static $pb.GeneratedMessage $_createMessage() => TrendExampleItem._();
  @$core.override
  TrendExampleItem createEmptyInstance() => TrendExampleItem._();
  @$core.pragma('dart2js:noInline')
  static TrendExampleItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrendExampleItem>(
          TrendExampleItem.$_createMessage);
  static TrendExampleItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get externalUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set externalUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExternalUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearExternalUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get creatorHandle => $_getSZ(2);
  @$pb.TagNumber(3)
  set creatorHandle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatorHandle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatorHandle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get caption => $_getSZ(3);
  @$pb.TagNumber(4)
  set caption($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCaption() => $_has(3);
  @$pb.TagNumber(4)
  void clearCaption() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get viewCount => $_getI64(4);
  @$pb.TagNumber(5)
  set viewCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasViewCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearViewCount() => $_clearField(5);
}

class TrendServiceGetExamplesResponse extends $pb.GeneratedMessage {
  factory TrendServiceGetExamplesResponse({
    $core.String? trendId,
    $core.Iterable<TrendExampleItem>? examples,
  }) {
    final result = TrendServiceGetExamplesResponse._();
    if (trendId != null) result.trendId = trendId;
    if (examples != null) result.examples.addAll(examples);
    return result;
  }

  TrendServiceGetExamplesResponse._();

  factory TrendServiceGetExamplesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetExamplesResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceGetExamplesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetExamplesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetExamplesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetExamplesResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'trendId')
    ..pPM<TrendExampleItem>(2, _omitFieldNames ? '' : 'examples',
        subBuilder: TrendExampleItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetExamplesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetExamplesResponse copyWith(
          void Function(TrendServiceGetExamplesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TrendServiceGetExamplesResponse))
          as TrendServiceGetExamplesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetExamplesResponse() / TrendServiceGetExamplesResponse.new instead')
  static TrendServiceGetExamplesResponse create() =>
      TrendServiceGetExamplesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetExamplesResponse._();
  @$core.override
  TrendServiceGetExamplesResponse createEmptyInstance() =>
      TrendServiceGetExamplesResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetExamplesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetExamplesResponse>(
          TrendServiceGetExamplesResponse.$_createMessage);
  static TrendServiceGetExamplesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trendId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trendId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrendId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrendId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<TrendExampleItem> get examples => $_getList(1);
}

class TrendServiceGetAudienceFitRequest extends $pb.GeneratedMessage {
  factory TrendServiceGetAudienceFitRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? trendId,
  }) {
    final result = TrendServiceGetAudienceFitRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (trendId != null) result.trendId = trendId;
    return result;
  }

  TrendServiceGetAudienceFitRequest._();

  factory TrendServiceGetAudienceFitRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetAudienceFitRequest()..mergeFromBuffer(data, registry);
  factory TrendServiceGetAudienceFitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetAudienceFitRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetAudienceFitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetAudienceFitRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'trendId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetAudienceFitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetAudienceFitRequest copyWith(
          void Function(TrendServiceGetAudienceFitRequest) updates) =>
      super.copyWith((message) =>
              updates(message as TrendServiceGetAudienceFitRequest))
          as TrendServiceGetAudienceFitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetAudienceFitRequest() / TrendServiceGetAudienceFitRequest.new instead')
  static TrendServiceGetAudienceFitRequest create() =>
      TrendServiceGetAudienceFitRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetAudienceFitRequest._();
  @$core.override
  TrendServiceGetAudienceFitRequest createEmptyInstance() =>
      TrendServiceGetAudienceFitRequest._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetAudienceFitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetAudienceFitRequest>(
          TrendServiceGetAudienceFitRequest.$_createMessage);
  static TrendServiceGetAudienceFitRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trendId => $_getSZ(2);
  @$pb.TagNumber(3)
  set trendId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrendId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrendId() => $_clearField(3);
}

class TrendServiceGetAudienceFitResponse extends $pb.GeneratedMessage {
  factory TrendServiceGetAudienceFitResponse({
    $core.String? trendId,
    $core.double? fitScore,
    $core.String? rationale,
    $core.Iterable<$core.String>? suggestedAngles,
  }) {
    final result = TrendServiceGetAudienceFitResponse._();
    if (trendId != null) result.trendId = trendId;
    if (fitScore != null) result.fitScore = fitScore;
    if (rationale != null) result.rationale = rationale;
    if (suggestedAngles != null) result.suggestedAngles.addAll(suggestedAngles);
    return result;
  }

  TrendServiceGetAudienceFitResponse._();

  factory TrendServiceGetAudienceFitResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetAudienceFitResponse()..mergeFromBuffer(data, registry);
  factory TrendServiceGetAudienceFitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TrendServiceGetAudienceFitResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendServiceGetAudienceFitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TrendServiceGetAudienceFitResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'trendId')
    ..aD(2, _omitFieldNames ? '' : 'fitScore', fieldType: $pb.PbFieldType.OF)
    ..aOS(3, _omitFieldNames ? '' : 'rationale')
    ..pPS(4, _omitFieldNames ? '' : 'suggestedAngles')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetAudienceFitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendServiceGetAudienceFitResponse copyWith(
          void Function(TrendServiceGetAudienceFitResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TrendServiceGetAudienceFitResponse))
          as TrendServiceGetAudienceFitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TrendServiceGetAudienceFitResponse() / TrendServiceGetAudienceFitResponse.new instead')
  static TrendServiceGetAudienceFitResponse create() =>
      TrendServiceGetAudienceFitResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TrendServiceGetAudienceFitResponse._();
  @$core.override
  TrendServiceGetAudienceFitResponse createEmptyInstance() =>
      TrendServiceGetAudienceFitResponse._();
  @$core.pragma('dart2js:noInline')
  static TrendServiceGetAudienceFitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendServiceGetAudienceFitResponse>(
          TrendServiceGetAudienceFitResponse.$_createMessage);
  static TrendServiceGetAudienceFitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trendId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trendId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrendId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrendId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get fitScore => $_getN(1);
  @$pb.TagNumber(2)
  set fitScore($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFitScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearFitScore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rationale => $_getSZ(2);
  @$pb.TagNumber(3)
  set rationale($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRationale() => $_has(2);
  @$pb.TagNumber(3)
  void clearRationale() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get suggestedAngles => $_getList(3);
}

class WatchlistServiceCreateRequest extends $pb.GeneratedMessage {
  factory WatchlistServiceCreateRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? name,
    $core.String? type,
    $core.String? criteriaJson,
    $core.bool? alertEnabled,
    AlertThreshold? alertThreshold,
  }) {
    final result = WatchlistServiceCreateRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (criteriaJson != null) result.criteriaJson = criteriaJson;
    if (alertEnabled != null) result.alertEnabled = alertEnabled;
    if (alertThreshold != null) result.alertThreshold = alertThreshold;
    return result;
  }

  WatchlistServiceCreateRequest._();

  factory WatchlistServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory WatchlistServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceCreateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'type')
    ..aOS(5, _omitFieldNames ? '' : 'criteriaJson')
    ..aOB(6, _omitFieldNames ? '' : 'alertEnabled')
    ..aOM<AlertThreshold>(7, _omitFieldNames ? '' : 'alertThreshold',
        subBuilder: AlertThreshold.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceCreateRequest copyWith(
          void Function(WatchlistServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceCreateRequest))
          as WatchlistServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceCreateRequest() / WatchlistServiceCreateRequest.new instead')
  static WatchlistServiceCreateRequest create() =>
      WatchlistServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceCreateRequest._();
  @$core.override
  WatchlistServiceCreateRequest createEmptyInstance() =>
      WatchlistServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceCreateRequest>(
          WatchlistServiceCreateRequest.$_createMessage);
  static WatchlistServiceCreateRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get type => $_getSZ(3);
  @$pb.TagNumber(4)
  set type($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get criteriaJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set criteriaJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCriteriaJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearCriteriaJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get alertEnabled => $_getBF(5);
  @$pb.TagNumber(6)
  set alertEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAlertEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearAlertEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  AlertThreshold get alertThreshold => $_getN(6);
  @$pb.TagNumber(7)
  set alertThreshold(AlertThreshold value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAlertThreshold() => $_has(6);
  @$pb.TagNumber(7)
  void clearAlertThreshold() => $_clearField(7);
  @$pb.TagNumber(7)
  AlertThreshold ensureAlertThreshold() => $_ensure(6);
}

class WatchlistServiceCreateResponse extends $pb.GeneratedMessage {
  factory WatchlistServiceCreateResponse({
    Watchlist? watchlist,
  }) {
    final result = WatchlistServiceCreateResponse._();
    if (watchlist != null) result.watchlist = watchlist;
    return result;
  }

  WatchlistServiceCreateResponse._();

  factory WatchlistServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory WatchlistServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceCreateResponse.$_createMessage)
    ..aOM<Watchlist>(1, _omitFieldNames ? '' : 'watchlist',
        subBuilder: Watchlist.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceCreateResponse copyWith(
          void Function(WatchlistServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceCreateResponse))
          as WatchlistServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceCreateResponse() / WatchlistServiceCreateResponse.new instead')
  static WatchlistServiceCreateResponse create() =>
      WatchlistServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceCreateResponse._();
  @$core.override
  WatchlistServiceCreateResponse createEmptyInstance() =>
      WatchlistServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceCreateResponse>(
          WatchlistServiceCreateResponse.$_createMessage);
  static WatchlistServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Watchlist get watchlist => $_getN(0);
  @$pb.TagNumber(1)
  set watchlist(Watchlist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWatchlist() => $_has(0);
  @$pb.TagNumber(1)
  void clearWatchlist() => $_clearField(1);
  @$pb.TagNumber(1)
  Watchlist ensureWatchlist() => $_ensure(0);
}

class WatchlistServiceListRequest extends $pb.GeneratedMessage {
  factory WatchlistServiceListRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $2.Pagination? pagination,
  }) {
    final result = WatchlistServiceListRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  WatchlistServiceListRequest._();

  factory WatchlistServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceListRequest()..mergeFromBuffer(data, registry);
  factory WatchlistServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceListRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceListRequest copyWith(
          void Function(WatchlistServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceListRequest))
          as WatchlistServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceListRequest() / WatchlistServiceListRequest.new instead')
  static WatchlistServiceListRequest create() =>
      WatchlistServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceListRequest._();
  @$core.override
  WatchlistServiceListRequest createEmptyInstance() =>
      WatchlistServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceListRequest>(
          WatchlistServiceListRequest.$_createMessage);
  static WatchlistServiceListRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

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

class WatchlistServiceListResponse extends $pb.GeneratedMessage {
  factory WatchlistServiceListResponse({
    $core.Iterable<Watchlist>? watchlists,
    $2.Pagination? pagination,
  }) {
    final result = WatchlistServiceListResponse._();
    if (watchlists != null) result.watchlists.addAll(watchlists);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  WatchlistServiceListResponse._();

  factory WatchlistServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceListResponse()..mergeFromBuffer(data, registry);
  factory WatchlistServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceListResponse.$_createMessage)
    ..pPM<Watchlist>(1, _omitFieldNames ? '' : 'watchlists',
        subBuilder: Watchlist.$_createMessage)
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceListResponse copyWith(
          void Function(WatchlistServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceListResponse))
          as WatchlistServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceListResponse() / WatchlistServiceListResponse.new instead')
  static WatchlistServiceListResponse create() =>
      WatchlistServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceListResponse._();
  @$core.override
  WatchlistServiceListResponse createEmptyInstance() =>
      WatchlistServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceListResponse>(
          WatchlistServiceListResponse.$_createMessage);
  static WatchlistServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Watchlist> get watchlists => $_getList(0);

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

class WatchlistServiceDeleteRequest extends $pb.GeneratedMessage {
  factory WatchlistServiceDeleteRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? watchlistId,
  }) {
    final result = WatchlistServiceDeleteRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (watchlistId != null) result.watchlistId = watchlistId;
    return result;
  }

  WatchlistServiceDeleteRequest._();

  factory WatchlistServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory WatchlistServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceDeleteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'watchlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceDeleteRequest copyWith(
          void Function(WatchlistServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceDeleteRequest))
          as WatchlistServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceDeleteRequest() / WatchlistServiceDeleteRequest.new instead')
  static WatchlistServiceDeleteRequest create() =>
      WatchlistServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceDeleteRequest._();
  @$core.override
  WatchlistServiceDeleteRequest createEmptyInstance() =>
      WatchlistServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceDeleteRequest>(
          WatchlistServiceDeleteRequest.$_createMessage);
  static WatchlistServiceDeleteRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get watchlistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set watchlistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchlistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchlistId() => $_clearField(3);
}

class WatchlistServiceDeleteResponse extends $pb.GeneratedMessage {
  factory WatchlistServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = WatchlistServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  WatchlistServiceDeleteResponse._();

  factory WatchlistServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory WatchlistServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceDeleteResponse copyWith(
          void Function(WatchlistServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceDeleteResponse))
          as WatchlistServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceDeleteResponse() / WatchlistServiceDeleteResponse.new instead')
  static WatchlistServiceDeleteResponse create() =>
      WatchlistServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceDeleteResponse._();
  @$core.override
  WatchlistServiceDeleteResponse createEmptyInstance() =>
      WatchlistServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceDeleteResponse>(
          WatchlistServiceDeleteResponse.$_createMessage);
  static WatchlistServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class WatchlistServiceUpdateRequest extends $pb.GeneratedMessage {
  factory WatchlistServiceUpdateRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? watchlistId,
    $core.String? name,
    $core.String? criteriaJson,
    $core.bool? alertEnabled,
    AlertThreshold? alertThreshold,
  }) {
    final result = WatchlistServiceUpdateRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (name != null) result.name = name;
    if (criteriaJson != null) result.criteriaJson = criteriaJson;
    if (alertEnabled != null) result.alertEnabled = alertEnabled;
    if (alertThreshold != null) result.alertThreshold = alertThreshold;
    return result;
  }

  WatchlistServiceUpdateRequest._();

  factory WatchlistServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory WatchlistServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceUpdateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'watchlistId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'criteriaJson')
    ..aOB(6, _omitFieldNames ? '' : 'alertEnabled')
    ..aOM<AlertThreshold>(7, _omitFieldNames ? '' : 'alertThreshold',
        subBuilder: AlertThreshold.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceUpdateRequest copyWith(
          void Function(WatchlistServiceUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceUpdateRequest))
          as WatchlistServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceUpdateRequest() / WatchlistServiceUpdateRequest.new instead')
  static WatchlistServiceUpdateRequest create() =>
      WatchlistServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceUpdateRequest._();
  @$core.override
  WatchlistServiceUpdateRequest createEmptyInstance() =>
      WatchlistServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceUpdateRequest>(
          WatchlistServiceUpdateRequest.$_createMessage);
  static WatchlistServiceUpdateRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get watchlistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set watchlistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchlistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchlistId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get criteriaJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set criteriaJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCriteriaJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearCriteriaJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get alertEnabled => $_getBF(5);
  @$pb.TagNumber(6)
  set alertEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAlertEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearAlertEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  AlertThreshold get alertThreshold => $_getN(6);
  @$pb.TagNumber(7)
  set alertThreshold(AlertThreshold value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAlertThreshold() => $_has(6);
  @$pb.TagNumber(7)
  void clearAlertThreshold() => $_clearField(7);
  @$pb.TagNumber(7)
  AlertThreshold ensureAlertThreshold() => $_ensure(6);
}

class WatchlistServiceUpdateResponse extends $pb.GeneratedMessage {
  factory WatchlistServiceUpdateResponse({
    Watchlist? watchlist,
  }) {
    final result = WatchlistServiceUpdateResponse._();
    if (watchlist != null) result.watchlist = watchlist;
    return result;
  }

  WatchlistServiceUpdateResponse._();

  factory WatchlistServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory WatchlistServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceUpdateResponse.$_createMessage)
    ..aOM<Watchlist>(1, _omitFieldNames ? '' : 'watchlist',
        subBuilder: Watchlist.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceUpdateResponse copyWith(
          void Function(WatchlistServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceUpdateResponse))
          as WatchlistServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceUpdateResponse() / WatchlistServiceUpdateResponse.new instead')
  static WatchlistServiceUpdateResponse create() =>
      WatchlistServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceUpdateResponse._();
  @$core.override
  WatchlistServiceUpdateResponse createEmptyInstance() =>
      WatchlistServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceUpdateResponse>(
          WatchlistServiceUpdateResponse.$_createMessage);
  static WatchlistServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Watchlist get watchlist => $_getN(0);
  @$pb.TagNumber(1)
  set watchlist(Watchlist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWatchlist() => $_has(0);
  @$pb.TagNumber(1)
  void clearWatchlist() => $_clearField(1);
  @$pb.TagNumber(1)
  Watchlist ensureWatchlist() => $_ensure(0);
}

class WatchlistServiceAddItemRequest extends $pb.GeneratedMessage {
  factory WatchlistServiceAddItemRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? watchlistId,
    $core.String? trendId,
  }) {
    final result = WatchlistServiceAddItemRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (trendId != null) result.trendId = trendId;
    return result;
  }

  WatchlistServiceAddItemRequest._();

  factory WatchlistServiceAddItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceAddItemRequest()..mergeFromBuffer(data, registry);
  factory WatchlistServiceAddItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceAddItemRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceAddItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceAddItemRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'watchlistId')
    ..aOS(4, _omitFieldNames ? '' : 'trendId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceAddItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceAddItemRequest copyWith(
          void Function(WatchlistServiceAddItemRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceAddItemRequest))
          as WatchlistServiceAddItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceAddItemRequest() / WatchlistServiceAddItemRequest.new instead')
  static WatchlistServiceAddItemRequest create() =>
      WatchlistServiceAddItemRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceAddItemRequest._();
  @$core.override
  WatchlistServiceAddItemRequest createEmptyInstance() =>
      WatchlistServiceAddItemRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceAddItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceAddItemRequest>(
          WatchlistServiceAddItemRequest.$_createMessage);
  static WatchlistServiceAddItemRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get watchlistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set watchlistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchlistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchlistId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get trendId => $_getSZ(3);
  @$pb.TagNumber(4)
  set trendId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrendId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrendId() => $_clearField(4);
}

class WatchlistServiceAddItemResponse extends $pb.GeneratedMessage {
  factory WatchlistServiceAddItemResponse({
    $core.bool? success,
    $core.int? itemCount,
  }) {
    final result = WatchlistServiceAddItemResponse._();
    if (success != null) result.success = success;
    if (itemCount != null) result.itemCount = itemCount;
    return result;
  }

  WatchlistServiceAddItemResponse._();

  factory WatchlistServiceAddItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceAddItemResponse()..mergeFromBuffer(data, registry);
  factory WatchlistServiceAddItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceAddItemResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceAddItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceAddItemResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aI(2, _omitFieldNames ? '' : 'itemCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceAddItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceAddItemResponse copyWith(
          void Function(WatchlistServiceAddItemResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceAddItemResponse))
          as WatchlistServiceAddItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceAddItemResponse() / WatchlistServiceAddItemResponse.new instead')
  static WatchlistServiceAddItemResponse create() =>
      WatchlistServiceAddItemResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceAddItemResponse._();
  @$core.override
  WatchlistServiceAddItemResponse createEmptyInstance() =>
      WatchlistServiceAddItemResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceAddItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceAddItemResponse>(
          WatchlistServiceAddItemResponse.$_createMessage);
  static WatchlistServiceAddItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get itemCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set itemCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemCount() => $_clearField(2);
}

class WatchlistServiceRemoveItemRequest extends $pb.GeneratedMessage {
  factory WatchlistServiceRemoveItemRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? watchlistId,
    $core.String? trendId,
  }) {
    final result = WatchlistServiceRemoveItemRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (trendId != null) result.trendId = trendId;
    return result;
  }

  WatchlistServiceRemoveItemRequest._();

  factory WatchlistServiceRemoveItemRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceRemoveItemRequest()..mergeFromBuffer(data, registry);
  factory WatchlistServiceRemoveItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceRemoveItemRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceRemoveItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceRemoveItemRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'watchlistId')
    ..aOS(4, _omitFieldNames ? '' : 'trendId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceRemoveItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceRemoveItemRequest copyWith(
          void Function(WatchlistServiceRemoveItemRequest) updates) =>
      super.copyWith((message) =>
              updates(message as WatchlistServiceRemoveItemRequest))
          as WatchlistServiceRemoveItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceRemoveItemRequest() / WatchlistServiceRemoveItemRequest.new instead')
  static WatchlistServiceRemoveItemRequest create() =>
      WatchlistServiceRemoveItemRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceRemoveItemRequest._();
  @$core.override
  WatchlistServiceRemoveItemRequest createEmptyInstance() =>
      WatchlistServiceRemoveItemRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceRemoveItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceRemoveItemRequest>(
          WatchlistServiceRemoveItemRequest.$_createMessage);
  static WatchlistServiceRemoveItemRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get watchlistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set watchlistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchlistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchlistId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get trendId => $_getSZ(3);
  @$pb.TagNumber(4)
  set trendId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrendId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrendId() => $_clearField(4);
}

class WatchlistServiceRemoveItemResponse extends $pb.GeneratedMessage {
  factory WatchlistServiceRemoveItemResponse({
    $core.bool? success,
    $core.int? itemCount,
  }) {
    final result = WatchlistServiceRemoveItemResponse._();
    if (success != null) result.success = success;
    if (itemCount != null) result.itemCount = itemCount;
    return result;
  }

  WatchlistServiceRemoveItemResponse._();

  factory WatchlistServiceRemoveItemResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceRemoveItemResponse()..mergeFromBuffer(data, registry);
  factory WatchlistServiceRemoveItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceRemoveItemResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceRemoveItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceRemoveItemResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aI(2, _omitFieldNames ? '' : 'itemCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceRemoveItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceRemoveItemResponse copyWith(
          void Function(WatchlistServiceRemoveItemResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WatchlistServiceRemoveItemResponse))
          as WatchlistServiceRemoveItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceRemoveItemResponse() / WatchlistServiceRemoveItemResponse.new instead')
  static WatchlistServiceRemoveItemResponse create() =>
      WatchlistServiceRemoveItemResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceRemoveItemResponse._();
  @$core.override
  WatchlistServiceRemoveItemResponse createEmptyInstance() =>
      WatchlistServiceRemoveItemResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceRemoveItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceRemoveItemResponse>(
          WatchlistServiceRemoveItemResponse.$_createMessage);
  static WatchlistServiceRemoveItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get itemCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set itemCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemCount() => $_clearField(2);
}

class WatchlistServiceGetItemsRequest extends $pb.GeneratedMessage {
  factory WatchlistServiceGetItemsRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? watchlistId,
    $2.Pagination? pagination,
  }) {
    final result = WatchlistServiceGetItemsRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  WatchlistServiceGetItemsRequest._();

  factory WatchlistServiceGetItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceGetItemsRequest()..mergeFromBuffer(data, registry);
  factory WatchlistServiceGetItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceGetItemsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceGetItemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceGetItemsRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'watchlistId')
    ..aOM<$2.Pagination>(4, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceGetItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceGetItemsRequest copyWith(
          void Function(WatchlistServiceGetItemsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceGetItemsRequest))
          as WatchlistServiceGetItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceGetItemsRequest() / WatchlistServiceGetItemsRequest.new instead')
  static WatchlistServiceGetItemsRequest create() =>
      WatchlistServiceGetItemsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceGetItemsRequest._();
  @$core.override
  WatchlistServiceGetItemsRequest createEmptyInstance() =>
      WatchlistServiceGetItemsRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceGetItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceGetItemsRequest>(
          WatchlistServiceGetItemsRequest.$_createMessage);
  static WatchlistServiceGetItemsRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get watchlistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set watchlistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchlistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchlistId() => $_clearField(3);

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

class WatchlistServiceGetItemsResponse extends $pb.GeneratedMessage {
  factory WatchlistServiceGetItemsResponse({
    $core.String? watchlistId,
    $core.Iterable<Trend>? items,
    $2.Pagination? pagination,
  }) {
    final result = WatchlistServiceGetItemsResponse._();
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (items != null) result.items.addAll(items);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  WatchlistServiceGetItemsResponse._();

  factory WatchlistServiceGetItemsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceGetItemsResponse()..mergeFromBuffer(data, registry);
  factory WatchlistServiceGetItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceGetItemsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceGetItemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceGetItemsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'watchlistId')
    ..pPM<Trend>(2, _omitFieldNames ? '' : 'items',
        subBuilder: Trend.$_createMessage)
    ..aOM<$2.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceGetItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceGetItemsResponse copyWith(
          void Function(WatchlistServiceGetItemsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceGetItemsResponse))
          as WatchlistServiceGetItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceGetItemsResponse() / WatchlistServiceGetItemsResponse.new instead')
  static WatchlistServiceGetItemsResponse create() =>
      WatchlistServiceGetItemsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceGetItemsResponse._();
  @$core.override
  WatchlistServiceGetItemsResponse createEmptyInstance() =>
      WatchlistServiceGetItemsResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceGetItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceGetItemsResponse>(
          WatchlistServiceGetItemsResponse.$_createMessage);
  static WatchlistServiceGetItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get watchlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set watchlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWatchlistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWatchlistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Trend> get items => $_getList(1);

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

class WatchlistServiceMuteItemRequest extends $pb.GeneratedMessage {
  factory WatchlistServiceMuteItemRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? watchlistId,
    $core.String? trendId,
    $core.int? muteHours,
  }) {
    final result = WatchlistServiceMuteItemRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (watchlistId != null) result.watchlistId = watchlistId;
    if (trendId != null) result.trendId = trendId;
    if (muteHours != null) result.muteHours = muteHours;
    return result;
  }

  WatchlistServiceMuteItemRequest._();

  factory WatchlistServiceMuteItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceMuteItemRequest()..mergeFromBuffer(data, registry);
  factory WatchlistServiceMuteItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceMuteItemRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceMuteItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceMuteItemRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'watchlistId')
    ..aOS(4, _omitFieldNames ? '' : 'trendId')
    ..aI(5, _omitFieldNames ? '' : 'muteHours')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceMuteItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceMuteItemRequest copyWith(
          void Function(WatchlistServiceMuteItemRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceMuteItemRequest))
          as WatchlistServiceMuteItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceMuteItemRequest() / WatchlistServiceMuteItemRequest.new instead')
  static WatchlistServiceMuteItemRequest create() =>
      WatchlistServiceMuteItemRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceMuteItemRequest._();
  @$core.override
  WatchlistServiceMuteItemRequest createEmptyInstance() =>
      WatchlistServiceMuteItemRequest._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceMuteItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceMuteItemRequest>(
          WatchlistServiceMuteItemRequest.$_createMessage);
  static WatchlistServiceMuteItemRequest? _defaultInstance;

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
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get watchlistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set watchlistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchlistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchlistId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get trendId => $_getSZ(3);
  @$pb.TagNumber(4)
  set trendId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrendId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrendId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get muteHours => $_getIZ(4);
  @$pb.TagNumber(5)
  set muteHours($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMuteHours() => $_has(4);
  @$pb.TagNumber(5)
  void clearMuteHours() => $_clearField(5);
}

class WatchlistServiceMuteItemResponse extends $pb.GeneratedMessage {
  factory WatchlistServiceMuteItemResponse({
    $core.bool? success,
    $1.Timestamp? mutedUntil,
  }) {
    final result = WatchlistServiceMuteItemResponse._();
    if (success != null) result.success = success;
    if (mutedUntil != null) result.mutedUntil = mutedUntil;
    return result;
  }

  WatchlistServiceMuteItemResponse._();

  factory WatchlistServiceMuteItemResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceMuteItemResponse()..mergeFromBuffer(data, registry);
  factory WatchlistServiceMuteItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchlistServiceMuteItemResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchlistServiceMuteItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WatchlistServiceMuteItemResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'mutedUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceMuteItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchlistServiceMuteItemResponse copyWith(
          void Function(WatchlistServiceMuteItemResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WatchlistServiceMuteItemResponse))
          as WatchlistServiceMuteItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WatchlistServiceMuteItemResponse() / WatchlistServiceMuteItemResponse.new instead')
  static WatchlistServiceMuteItemResponse create() =>
      WatchlistServiceMuteItemResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WatchlistServiceMuteItemResponse._();
  @$core.override
  WatchlistServiceMuteItemResponse createEmptyInstance() =>
      WatchlistServiceMuteItemResponse._();
  @$core.pragma('dart2js:noInline')
  static WatchlistServiceMuteItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchlistServiceMuteItemResponse>(
          WatchlistServiceMuteItemResponse.$_createMessage);
  static WatchlistServiceMuteItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get mutedUntil => $_getN(1);
  @$pb.TagNumber(2)
  set mutedUntil($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMutedUntil() => $_has(1);
  @$pb.TagNumber(2)
  void clearMutedUntil() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureMutedUntil() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

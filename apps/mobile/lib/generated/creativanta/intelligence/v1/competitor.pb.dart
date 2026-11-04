// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/competitor.proto.

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

import 'competitor.pbenum.dart';
import 'trend.pbenum.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'competitor.pbenum.dart';

/// AlertConfig defines per-competitor alert subscriptions per database_schema.md §27.3.
class AlertConfig extends $pb.GeneratedMessage {
  factory AlertConfig({
    $core.bool? enabled,
    AlertMetric? metric,
    $core.double? threshold,
    AlertDirection? direction,
    $core.int? minIntervalMinutes,
    MonitoringSourceStatus? sourceStatus,
    $core.String? sourceStatusReason,
    $1.Timestamp? lastAlertAt,
    $core.String? lastAlertSnapshotId,
    $core.bool? recoveryLatched,
    $core.bool? insufficientData,
  }) {
    final result = AlertConfig._();
    if (enabled != null) result.enabled = enabled;
    if (metric != null) result.metric = metric;
    if (threshold != null) result.threshold = threshold;
    if (direction != null) result.direction = direction;
    if (minIntervalMinutes != null)
      result.minIntervalMinutes = minIntervalMinutes;
    if (sourceStatus != null) result.sourceStatus = sourceStatus;
    if (sourceStatusReason != null)
      result.sourceStatusReason = sourceStatusReason;
    if (lastAlertAt != null) result.lastAlertAt = lastAlertAt;
    if (lastAlertSnapshotId != null)
      result.lastAlertSnapshotId = lastAlertSnapshotId;
    if (recoveryLatched != null) result.recoveryLatched = recoveryLatched;
    if (insufficientData != null) result.insufficientData = insufficientData;
    return result;
  }

  AlertConfig._();

  factory AlertConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AlertConfig()..mergeFromBuffer(data, registry);
  factory AlertConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AlertConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AlertConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: AlertConfig.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aE<AlertMetric>(2, _omitFieldNames ? '' : 'metric',
        enumValues: AlertMetric.values)
    ..aD(3, _omitFieldNames ? '' : 'threshold')
    ..aE<AlertDirection>(4, _omitFieldNames ? '' : 'direction',
        enumValues: AlertDirection.values)
    ..aI(5, _omitFieldNames ? '' : 'minIntervalMinutes')
    ..aE<MonitoringSourceStatus>(6, _omitFieldNames ? '' : 'sourceStatus',
        enumValues: MonitoringSourceStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'sourceStatusReason')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'lastAlertAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'lastAlertSnapshotId')
    ..aOB(10, _omitFieldNames ? '' : 'recoveryLatched')
    ..aOB(11, _omitFieldNames ? '' : 'insufficientData')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlertConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlertConfig copyWith(void Function(AlertConfig) updates) =>
      super.copyWith((message) => updates(message as AlertConfig))
          as AlertConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AlertConfig() / AlertConfig.new instead')
  static AlertConfig create() => AlertConfig._();
  static $pb.GeneratedMessage $_createMessage() => AlertConfig._();
  @$core.override
  AlertConfig createEmptyInstance() => AlertConfig._();
  @$core.pragma('dart2js:noInline')
  static AlertConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AlertConfig>(
          AlertConfig.$_createMessage);
  static AlertConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  AlertMetric get metric => $_getN(1);
  @$pb.TagNumber(2)
  set metric(AlertMetric value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetric() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetric() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get threshold => $_getN(2);
  @$pb.TagNumber(3)
  set threshold($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThreshold() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreshold() => $_clearField(3);

  @$pb.TagNumber(4)
  AlertDirection get direction => $_getN(3);
  @$pb.TagNumber(4)
  set direction(AlertDirection value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDirection() => $_has(3);
  @$pb.TagNumber(4)
  void clearDirection() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get minIntervalMinutes => $_getIZ(4);
  @$pb.TagNumber(5)
  set minIntervalMinutes($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinIntervalMinutes() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinIntervalMinutes() => $_clearField(5);

  @$pb.TagNumber(6)
  MonitoringSourceStatus get sourceStatus => $_getN(5);
  @$pb.TagNumber(6)
  set sourceStatus(MonitoringSourceStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sourceStatusReason => $_getSZ(6);
  @$pb.TagNumber(7)
  set sourceStatusReason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSourceStatusReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceStatusReason() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get lastAlertAt => $_getN(7);
  @$pb.TagNumber(8)
  set lastAlertAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLastAlertAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastAlertAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureLastAlertAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get lastAlertSnapshotId => $_getSZ(8);
  @$pb.TagNumber(9)
  set lastAlertSnapshotId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLastAlertSnapshotId() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastAlertSnapshotId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get recoveryLatched => $_getBF(9);
  @$pb.TagNumber(10)
  set recoveryLatched($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRecoveryLatched() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecoveryLatched() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get insufficientData => $_getBF(10);
  @$pb.TagNumber(11)
  set insufficientData($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInsufficientData() => $_has(10);
  @$pb.TagNumber(11)
  void clearInsufficientData() => $_clearField(11);
}

/// CompetitorEntity represents a tracked competitor entity per database_schema.md §5.6.
class CompetitorEntity extends $pb.GeneratedMessage {
  factory CompetitorEntity({
    $core.String? competitorId,
    $core.String? workspaceId,
    $core.String? name,
    $core.String? platform,
    $core.String? externalHandle,
    $core.String? category,
    $core.String? notes,
    $core.double? relevanceScore,
    $core.String? relevanceReason,
    $fixnum.Int64? followersCount,
    $core.int? videoCount30d,
    $fixnum.Int64? avgViews,
    $core.double? growthRate30d,
    $core.double? avgEngagementRate,
    $core.double? postingFrequencyPerDay,
    $1.Timestamp? lastPostAt,
    $core.String? status,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    AlertConfig? alertConfig,
  }) {
    final result = CompetitorEntity._();
    if (competitorId != null) result.competitorId = competitorId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (name != null) result.name = name;
    if (platform != null) result.platform = platform;
    if (externalHandle != null) result.externalHandle = externalHandle;
    if (category != null) result.category = category;
    if (notes != null) result.notes = notes;
    if (relevanceScore != null) result.relevanceScore = relevanceScore;
    if (relevanceReason != null) result.relevanceReason = relevanceReason;
    if (followersCount != null) result.followersCount = followersCount;
    if (videoCount30d != null) result.videoCount30d = videoCount30d;
    if (avgViews != null) result.avgViews = avgViews;
    if (growthRate30d != null) result.growthRate30d = growthRate30d;
    if (avgEngagementRate != null) result.avgEngagementRate = avgEngagementRate;
    if (postingFrequencyPerDay != null)
      result.postingFrequencyPerDay = postingFrequencyPerDay;
    if (lastPostAt != null) result.lastPostAt = lastPostAt;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (alertConfig != null) result.alertConfig = alertConfig;
    return result;
  }

  CompetitorEntity._();

  factory CompetitorEntity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorEntity()..mergeFromBuffer(data, registry);
  factory CompetitorEntity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorEntity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorEntity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorEntity.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'competitorId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'platform')
    ..aOS(5, _omitFieldNames ? '' : 'externalHandle')
    ..aOS(6, _omitFieldNames ? '' : 'category')
    ..aOS(7, _omitFieldNames ? '' : 'notes')
    ..aD(8, _omitFieldNames ? '' : 'relevanceScore',
        fieldType: $pb.PbFieldType.OF)
    ..aOS(9, _omitFieldNames ? '' : 'relevanceReason')
    ..aInt64(10, _omitFieldNames ? '' : 'followersCount')
    ..aI(11, _omitFieldNames ? '' : 'videoCount30d',
        protoName: 'video_count_30d')
    ..aInt64(12, _omitFieldNames ? '' : 'avgViews')
    ..aD(13, _omitFieldNames ? '' : 'growthRate30d',
        protoName: 'growth_rate_30d', fieldType: $pb.PbFieldType.OF)
    ..aD(14, _omitFieldNames ? '' : 'avgEngagementRate',
        fieldType: $pb.PbFieldType.OF)
    ..aD(15, _omitFieldNames ? '' : 'postingFrequencyPerDay',
        fieldType: $pb.PbFieldType.OF)
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'lastPostAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(17, _omitFieldNames ? '' : 'status')
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<AlertConfig>(20, _omitFieldNames ? '' : 'alertConfig',
        subBuilder: AlertConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorEntity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorEntity copyWith(void Function(CompetitorEntity) updates) =>
      super.copyWith((message) => updates(message as CompetitorEntity))
          as CompetitorEntity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CompetitorEntity() / CompetitorEntity.new instead')
  static CompetitorEntity create() => CompetitorEntity._();
  static $pb.GeneratedMessage $_createMessage() => CompetitorEntity._();
  @$core.override
  CompetitorEntity createEmptyInstance() => CompetitorEntity._();
  @$core.pragma('dart2js:noInline')
  static CompetitorEntity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CompetitorEntity>(
          CompetitorEntity.$_createMessage);
  static CompetitorEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get competitorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set competitorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCompetitorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompetitorId() => $_clearField(1);

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
  $core.String get platform => $_getSZ(3);
  @$pb.TagNumber(4)
  set platform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatform() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get externalHandle => $_getSZ(4);
  @$pb.TagNumber(5)
  set externalHandle($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExternalHandle() => $_has(4);
  @$pb.TagNumber(5)
  void clearExternalHandle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get category => $_getSZ(5);
  @$pb.TagNumber(6)
  set category($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCategory() => $_has(5);
  @$pb.TagNumber(6)
  void clearCategory() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get notes => $_getSZ(6);
  @$pb.TagNumber(7)
  set notes($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNotes() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotes() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get relevanceScore => $_getN(7);
  @$pb.TagNumber(8)
  set relevanceScore($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRelevanceScore() => $_has(7);
  @$pb.TagNumber(8)
  void clearRelevanceScore() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get relevanceReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set relevanceReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRelevanceReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearRelevanceReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get followersCount => $_getI64(9);
  @$pb.TagNumber(10)
  set followersCount($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFollowersCount() => $_has(9);
  @$pb.TagNumber(10)
  void clearFollowersCount() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get videoCount30d => $_getIZ(10);
  @$pb.TagNumber(11)
  set videoCount30d($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVideoCount30d() => $_has(10);
  @$pb.TagNumber(11)
  void clearVideoCount30d() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get avgViews => $_getI64(11);
  @$pb.TagNumber(12)
  set avgViews($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAvgViews() => $_has(11);
  @$pb.TagNumber(12)
  void clearAvgViews() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get growthRate30d => $_getN(12);
  @$pb.TagNumber(13)
  set growthRate30d($core.double value) => $_setFloat(12, value);
  @$pb.TagNumber(13)
  $core.bool hasGrowthRate30d() => $_has(12);
  @$pb.TagNumber(13)
  void clearGrowthRate30d() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get avgEngagementRate => $_getN(13);
  @$pb.TagNumber(14)
  set avgEngagementRate($core.double value) => $_setFloat(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAvgEngagementRate() => $_has(13);
  @$pb.TagNumber(14)
  void clearAvgEngagementRate() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.double get postingFrequencyPerDay => $_getN(14);
  @$pb.TagNumber(15)
  set postingFrequencyPerDay($core.double value) => $_setFloat(14, value);
  @$pb.TagNumber(15)
  $core.bool hasPostingFrequencyPerDay() => $_has(14);
  @$pb.TagNumber(15)
  void clearPostingFrequencyPerDay() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.Timestamp get lastPostAt => $_getN(15);
  @$pb.TagNumber(16)
  set lastPostAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasLastPostAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearLastPostAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureLastPostAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get status => $_getSZ(16);
  @$pb.TagNumber(17)
  set status($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasStatus() => $_has(16);
  @$pb.TagNumber(17)
  void clearStatus() => $_clearField(17);

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

  @$pb.TagNumber(20)
  AlertConfig get alertConfig => $_getN(19);
  @$pb.TagNumber(20)
  set alertConfig(AlertConfig value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasAlertConfig() => $_has(19);
  @$pb.TagNumber(20)
  void clearAlertConfig() => $_clearField(20);
  @$pb.TagNumber(20)
  AlertConfig ensureAlertConfig() => $_ensure(19);
}

/// CompetitorSuggestion represents an AI-suggested competitor entity.
class CompetitorSuggestion extends $pb.GeneratedMessage {
  factory CompetitorSuggestion({
    $core.String? suggestionId,
    $core.String? name,
    $core.String? platform,
    $core.String? externalHandle,
    $fixnum.Int64? followersCount,
    $core.double? relevanceScore,
    $core.String? aiExplanation,
    $core.String? category,
    $core.bool? isDismissed,
  }) {
    final result = CompetitorSuggestion._();
    if (suggestionId != null) result.suggestionId = suggestionId;
    if (name != null) result.name = name;
    if (platform != null) result.platform = platform;
    if (externalHandle != null) result.externalHandle = externalHandle;
    if (followersCount != null) result.followersCount = followersCount;
    if (relevanceScore != null) result.relevanceScore = relevanceScore;
    if (aiExplanation != null) result.aiExplanation = aiExplanation;
    if (category != null) result.category = category;
    if (isDismissed != null) result.isDismissed = isDismissed;
    return result;
  }

  CompetitorSuggestion._();

  factory CompetitorSuggestion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorSuggestion()..mergeFromBuffer(data, registry);
  factory CompetitorSuggestion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorSuggestion()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorSuggestion',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorSuggestion.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'suggestionId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOS(4, _omitFieldNames ? '' : 'externalHandle')
    ..aInt64(5, _omitFieldNames ? '' : 'followersCount')
    ..aD(6, _omitFieldNames ? '' : 'relevanceScore',
        fieldType: $pb.PbFieldType.OF)
    ..aOS(7, _omitFieldNames ? '' : 'aiExplanation')
    ..aOS(8, _omitFieldNames ? '' : 'category')
    ..aOB(9, _omitFieldNames ? '' : 'isDismissed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorSuggestion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorSuggestion copyWith(void Function(CompetitorSuggestion) updates) =>
      super.copyWith((message) => updates(message as CompetitorSuggestion))
          as CompetitorSuggestion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompetitorSuggestion() / CompetitorSuggestion.new instead')
  static CompetitorSuggestion create() => CompetitorSuggestion._();
  static $pb.GeneratedMessage $_createMessage() => CompetitorSuggestion._();
  @$core.override
  CompetitorSuggestion createEmptyInstance() => CompetitorSuggestion._();
  @$core.pragma('dart2js:noInline')
  static CompetitorSuggestion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompetitorSuggestion>(
          CompetitorSuggestion.$_createMessage);
  static CompetitorSuggestion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get suggestionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set suggestionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuggestionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuggestionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get externalHandle => $_getSZ(3);
  @$pb.TagNumber(4)
  set externalHandle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExternalHandle() => $_has(3);
  @$pb.TagNumber(4)
  void clearExternalHandle() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get followersCount => $_getI64(4);
  @$pb.TagNumber(5)
  set followersCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFollowersCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearFollowersCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get relevanceScore => $_getN(5);
  @$pb.TagNumber(6)
  set relevanceScore($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRelevanceScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelevanceScore() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get aiExplanation => $_getSZ(6);
  @$pb.TagNumber(7)
  set aiExplanation($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAiExplanation() => $_has(6);
  @$pb.TagNumber(7)
  void clearAiExplanation() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get category => $_getSZ(7);
  @$pb.TagNumber(8)
  set category($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCategory() => $_has(7);
  @$pb.TagNumber(8)
  void clearCategory() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isDismissed => $_getBF(8);
  @$pb.TagNumber(9)
  set isDismissed($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsDismissed() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsDismissed() => $_clearField(9);
}

/// WhyExplanation provides the basis, limitations, and data gaps per RULE-M03-002.
class WhyExplanation extends $pb.GeneratedMessage {
  factory WhyExplanation({
    $core.Iterable<$core.String>? dataSources,
    $core.Iterable<$core.String>? limitations,
    $core.Iterable<$core.String>? dataGaps,
    $core.String? basisSummary,
  }) {
    final result = WhyExplanation._();
    if (dataSources != null) result.dataSources.addAll(dataSources);
    if (limitations != null) result.limitations.addAll(limitations);
    if (dataGaps != null) result.dataGaps.addAll(dataGaps);
    if (basisSummary != null) result.basisSummary = basisSummary;
    return result;
  }

  WhyExplanation._();

  factory WhyExplanation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WhyExplanation()..mergeFromBuffer(data, registry);
  factory WhyExplanation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WhyExplanation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WhyExplanation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WhyExplanation.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'dataSources')
    ..pPS(2, _omitFieldNames ? '' : 'limitations')
    ..pPS(3, _omitFieldNames ? '' : 'dataGaps')
    ..aOS(4, _omitFieldNames ? '' : 'basisSummary')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WhyExplanation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WhyExplanation copyWith(void Function(WhyExplanation) updates) =>
      super.copyWith((message) => updates(message as WhyExplanation))
          as WhyExplanation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WhyExplanation() / WhyExplanation.new instead')
  static WhyExplanation create() => WhyExplanation._();
  static $pb.GeneratedMessage $_createMessage() => WhyExplanation._();
  @$core.override
  WhyExplanation createEmptyInstance() => WhyExplanation._();
  @$core.pragma('dart2js:noInline')
  static WhyExplanation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WhyExplanation>(
          WhyExplanation.$_createMessage);
  static WhyExplanation? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get dataSources => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get limitations => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get dataGaps => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get basisSummary => $_getSZ(3);
  @$pb.TagNumber(4)
  set basisSummary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBasisSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearBasisSummary() => $_clearField(4);
}

/// BenchmarkMetrics holds metrics for benchmark analysis per database_schema.md §5.7.
class BenchmarkMetrics extends $pb.GeneratedMessage {
  factory BenchmarkMetrics({
    $core.double? contentFrequencyPerWeek,
    $core.double? engagementRate,
    $fixnum.Int64? avgViews,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>?
        formatDistribution,
    $core.String? observedPriceRange,
    $core.Iterable<$core.String>? offerTypes,
    $fixnum.Int64? followerCount,
    $core.double? followerGrowthPct,
  }) {
    final result = BenchmarkMetrics._();
    if (contentFrequencyPerWeek != null)
      result.contentFrequencyPerWeek = contentFrequencyPerWeek;
    if (engagementRate != null) result.engagementRate = engagementRate;
    if (avgViews != null) result.avgViews = avgViews;
    if (formatDistribution != null)
      result.formatDistribution.addEntries(formatDistribution);
    if (observedPriceRange != null)
      result.observedPriceRange = observedPriceRange;
    if (offerTypes != null) result.offerTypes.addAll(offerTypes);
    if (followerCount != null) result.followerCount = followerCount;
    if (followerGrowthPct != null) result.followerGrowthPct = followerGrowthPct;
    return result;
  }

  BenchmarkMetrics._();

  factory BenchmarkMetrics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkMetrics()..mergeFromBuffer(data, registry);
  factory BenchmarkMetrics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkMetrics()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BenchmarkMetrics',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: BenchmarkMetrics.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'contentFrequencyPerWeek',
        fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'engagementRate',
        fieldType: $pb.PbFieldType.OF)
    ..aInt64(3, _omitFieldNames ? '' : 'avgViews')
    ..m<$core.String, $core.double>(
        4, _omitFieldNames ? '' : 'formatDistribution',
        entryClassName: 'BenchmarkMetrics.FormatDistributionEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OF,
        packageName: const $pb.PackageName('creativanta.intelligence.v1'))
    ..aOS(5, _omitFieldNames ? '' : 'observedPriceRange')
    ..pPS(6, _omitFieldNames ? '' : 'offerTypes')
    ..aInt64(7, _omitFieldNames ? '' : 'followerCount')
    ..aD(8, _omitFieldNames ? '' : 'followerGrowthPct',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkMetrics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkMetrics copyWith(void Function(BenchmarkMetrics) updates) =>
      super.copyWith((message) => updates(message as BenchmarkMetrics))
          as BenchmarkMetrics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BenchmarkMetrics() / BenchmarkMetrics.new instead')
  static BenchmarkMetrics create() => BenchmarkMetrics._();
  static $pb.GeneratedMessage $_createMessage() => BenchmarkMetrics._();
  @$core.override
  BenchmarkMetrics createEmptyInstance() => BenchmarkMetrics._();
  @$core.pragma('dart2js:noInline')
  static BenchmarkMetrics getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BenchmarkMetrics>(
          BenchmarkMetrics.$_createMessage);
  static BenchmarkMetrics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get contentFrequencyPerWeek => $_getN(0);
  @$pb.TagNumber(1)
  set contentFrequencyPerWeek($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContentFrequencyPerWeek() => $_has(0);
  @$pb.TagNumber(1)
  void clearContentFrequencyPerWeek() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get engagementRate => $_getN(1);
  @$pb.TagNumber(2)
  set engagementRate($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEngagementRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearEngagementRate() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get avgViews => $_getI64(2);
  @$pb.TagNumber(3)
  set avgViews($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvgViews() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvgViews() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.double> get formatDistribution => $_getMap(3);

  @$pb.TagNumber(5)
  $core.String get observedPriceRange => $_getSZ(4);
  @$pb.TagNumber(5)
  set observedPriceRange($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasObservedPriceRange() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservedPriceRange() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get offerTypes => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get followerCount => $_getI64(6);
  @$pb.TagNumber(7)
  set followerCount($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowerCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowerCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get followerGrowthPct => $_getN(7);
  @$pb.TagNumber(8)
  set followerGrowthPct($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFollowerGrowthPct() => $_has(7);
  @$pb.TagNumber(8)
  void clearFollowerGrowthPct() => $_clearField(8);
}

/// BenchmarkSnapshot represents a point-in-time benchmark capture per database_schema.md §5.7.
class BenchmarkSnapshot extends $pb.GeneratedMessage {
  factory BenchmarkSnapshot({
    $core.String? snapshotId,
    $core.String? workspaceId,
    $core.String? competitorId,
    $core.String? snapshotType,
    $core.String? dataPeriodStart,
    $core.String? dataPeriodEnd,
    BenchmarkMetrics? metrics,
    $2.SourceClass? sourceClass,
    $2.ConfidenceBand? confidence,
    $1.Timestamp? capturedAt,
    $1.Timestamp? createdAt,
    $core.bool? isStale,
    $core.String? staleWarning,
    $core.int? daysSinceCapture,
    WhyExplanation? whyExplanation,
  }) {
    final result = BenchmarkSnapshot._();
    if (snapshotId != null) result.snapshotId = snapshotId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (competitorId != null) result.competitorId = competitorId;
    if (snapshotType != null) result.snapshotType = snapshotType;
    if (dataPeriodStart != null) result.dataPeriodStart = dataPeriodStart;
    if (dataPeriodEnd != null) result.dataPeriodEnd = dataPeriodEnd;
    if (metrics != null) result.metrics = metrics;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (confidence != null) result.confidence = confidence;
    if (capturedAt != null) result.capturedAt = capturedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (isStale != null) result.isStale = isStale;
    if (staleWarning != null) result.staleWarning = staleWarning;
    if (daysSinceCapture != null) result.daysSinceCapture = daysSinceCapture;
    if (whyExplanation != null) result.whyExplanation = whyExplanation;
    return result;
  }

  BenchmarkSnapshot._();

  factory BenchmarkSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkSnapshot()..mergeFromBuffer(data, registry);
  factory BenchmarkSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkSnapshot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BenchmarkSnapshot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: BenchmarkSnapshot.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'snapshotId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'competitorId')
    ..aOS(4, _omitFieldNames ? '' : 'snapshotType')
    ..aOS(5, _omitFieldNames ? '' : 'dataPeriodStart')
    ..aOS(6, _omitFieldNames ? '' : 'dataPeriodEnd')
    ..aOM<BenchmarkMetrics>(7, _omitFieldNames ? '' : 'metrics',
        subBuilder: BenchmarkMetrics.$_createMessage)
    ..aE<$2.SourceClass>(8, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aE<$2.ConfidenceBand>(9, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'capturedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOB(12, _omitFieldNames ? '' : 'isStale')
    ..aOS(13, _omitFieldNames ? '' : 'staleWarning')
    ..aI(14, _omitFieldNames ? '' : 'daysSinceCapture')
    ..aOM<WhyExplanation>(15, _omitFieldNames ? '' : 'whyExplanation',
        subBuilder: WhyExplanation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkSnapshot copyWith(void Function(BenchmarkSnapshot) updates) =>
      super.copyWith((message) => updates(message as BenchmarkSnapshot))
          as BenchmarkSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BenchmarkSnapshot() / BenchmarkSnapshot.new instead')
  static BenchmarkSnapshot create() => BenchmarkSnapshot._();
  static $pb.GeneratedMessage $_createMessage() => BenchmarkSnapshot._();
  @$core.override
  BenchmarkSnapshot createEmptyInstance() => BenchmarkSnapshot._();
  @$core.pragma('dart2js:noInline')
  static BenchmarkSnapshot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BenchmarkSnapshot>(
          BenchmarkSnapshot.$_createMessage);
  static BenchmarkSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get snapshotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set snapshotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get competitorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set competitorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCompetitorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompetitorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get snapshotType => $_getSZ(3);
  @$pb.TagNumber(4)
  set snapshotType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSnapshotType() => $_has(3);
  @$pb.TagNumber(4)
  void clearSnapshotType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dataPeriodStart => $_getSZ(4);
  @$pb.TagNumber(5)
  set dataPeriodStart($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDataPeriodStart() => $_has(4);
  @$pb.TagNumber(5)
  void clearDataPeriodStart() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dataPeriodEnd => $_getSZ(5);
  @$pb.TagNumber(6)
  set dataPeriodEnd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDataPeriodEnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearDataPeriodEnd() => $_clearField(6);

  @$pb.TagNumber(7)
  BenchmarkMetrics get metrics => $_getN(6);
  @$pb.TagNumber(7)
  set metrics(BenchmarkMetrics value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMetrics() => $_has(6);
  @$pb.TagNumber(7)
  void clearMetrics() => $_clearField(7);
  @$pb.TagNumber(7)
  BenchmarkMetrics ensureMetrics() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.SourceClass get sourceClass => $_getN(7);
  @$pb.TagNumber(8)
  set sourceClass($2.SourceClass value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceClass() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceClass() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.ConfidenceBand get confidence => $_getN(8);
  @$pb.TagNumber(9)
  set confidence($2.ConfidenceBand value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasConfidence() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfidence() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get capturedAt => $_getN(9);
  @$pb.TagNumber(10)
  set capturedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCapturedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCapturedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureCapturedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(11)
  set createdAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureCreatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.bool get isStale => $_getBF(11);
  @$pb.TagNumber(12)
  set isStale($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIsStale() => $_has(11);
  @$pb.TagNumber(12)
  void clearIsStale() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get staleWarning => $_getSZ(12);
  @$pb.TagNumber(13)
  set staleWarning($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasStaleWarning() => $_has(12);
  @$pb.TagNumber(13)
  void clearStaleWarning() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get daysSinceCapture => $_getIZ(13);
  @$pb.TagNumber(14)
  set daysSinceCapture($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDaysSinceCapture() => $_has(13);
  @$pb.TagNumber(14)
  void clearDaysSinceCapture() => $_clearField(14);

  @$pb.TagNumber(15)
  WhyExplanation get whyExplanation => $_getN(14);
  @$pb.TagNumber(15)
  set whyExplanation(WhyExplanation value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasWhyExplanation() => $_has(14);
  @$pb.TagNumber(15)
  void clearWhyExplanation() => $_clearField(15);
  @$pb.TagNumber(15)
  WhyExplanation ensureWhyExplanation() => $_ensure(14);
}

/// WhiteSpaceGap represents an uncovered niche or content opportunity per RULE-M03-001.
class WhiteSpaceGap extends $pb.GeneratedMessage {
  factory WhiteSpaceGap({
    $core.String? gapId,
    $core.String? category,
    $core.String? formatType,
    $core.String? priceTier,
    $core.String? description,
    $core.String? opportunityHypothesis,
    $2.SourceClass? sourceClass,
    $2.ConfidenceBand? confidence,
    $core.Iterable<$core.String>? competitorIds,
    WhyExplanation? whyExplanation,
  }) {
    final result = WhiteSpaceGap._();
    if (gapId != null) result.gapId = gapId;
    if (category != null) result.category = category;
    if (formatType != null) result.formatType = formatType;
    if (priceTier != null) result.priceTier = priceTier;
    if (description != null) result.description = description;
    if (opportunityHypothesis != null)
      result.opportunityHypothesis = opportunityHypothesis;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (confidence != null) result.confidence = confidence;
    if (competitorIds != null) result.competitorIds.addAll(competitorIds);
    if (whyExplanation != null) result.whyExplanation = whyExplanation;
    return result;
  }

  WhiteSpaceGap._();

  factory WhiteSpaceGap.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WhiteSpaceGap()..mergeFromBuffer(data, registry);
  factory WhiteSpaceGap.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WhiteSpaceGap()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WhiteSpaceGap',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: WhiteSpaceGap.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'gapId')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..aOS(3, _omitFieldNames ? '' : 'formatType')
    ..aOS(4, _omitFieldNames ? '' : 'priceTier')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'opportunityHypothesis')
    ..aE<$2.SourceClass>(7, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aE<$2.ConfidenceBand>(8, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..pPS(9, _omitFieldNames ? '' : 'competitorIds')
    ..aOM<WhyExplanation>(10, _omitFieldNames ? '' : 'whyExplanation',
        subBuilder: WhyExplanation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WhiteSpaceGap clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WhiteSpaceGap copyWith(void Function(WhiteSpaceGap) updates) =>
      super.copyWith((message) => updates(message as WhiteSpaceGap))
          as WhiteSpaceGap;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WhiteSpaceGap() / WhiteSpaceGap.new instead')
  static WhiteSpaceGap create() => WhiteSpaceGap._();
  static $pb.GeneratedMessage $_createMessage() => WhiteSpaceGap._();
  @$core.override
  WhiteSpaceGap createEmptyInstance() => WhiteSpaceGap._();
  @$core.pragma('dart2js:noInline')
  static WhiteSpaceGap getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WhiteSpaceGap>(
          WhiteSpaceGap.$_createMessage);
  static WhiteSpaceGap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGapId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get category => $_getSZ(1);
  @$pb.TagNumber(2)
  set category($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get formatType => $_getSZ(2);
  @$pb.TagNumber(3)
  set formatType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormatType() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormatType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get priceTier => $_getSZ(3);
  @$pb.TagNumber(4)
  set priceTier($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPriceTier() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriceTier() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get opportunityHypothesis => $_getSZ(5);
  @$pb.TagNumber(6)
  set opportunityHypothesis($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOpportunityHypothesis() => $_has(5);
  @$pb.TagNumber(6)
  void clearOpportunityHypothesis() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.SourceClass get sourceClass => $_getN(6);
  @$pb.TagNumber(7)
  set sourceClass($2.SourceClass value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSourceClass() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceClass() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.ConfidenceBand get confidence => $_getN(7);
  @$pb.TagNumber(8)
  set confidence($2.ConfidenceBand value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasConfidence() => $_has(7);
  @$pb.TagNumber(8)
  void clearConfidence() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get competitorIds => $_getList(8);

  @$pb.TagNumber(10)
  WhyExplanation get whyExplanation => $_getN(9);
  @$pb.TagNumber(10)
  set whyExplanation(WhyExplanation value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasWhyExplanation() => $_has(9);
  @$pb.TagNumber(10)
  void clearWhyExplanation() => $_clearField(10);
  @$pb.TagNumber(10)
  WhyExplanation ensureWhyExplanation() => $_ensure(9);
}

/// PricingComparisonItem represents observational pricing comparison per RULE-M03-003.
class PricingComparisonItem extends $pb.GeneratedMessage {
  factory PricingComparisonItem({
    $core.String? itemId,
    $core.String? competitorId,
    $core.String? competitorName,
    $core.String? productName,
    $core.String? observedPrice,
    $core.String? currency,
    $core.String? offerType,
    $core.bool? isObservational,
    $core.String? disclaimer,
    $2.SourceClass? sourceClass,
  }) {
    final result = PricingComparisonItem._();
    if (itemId != null) result.itemId = itemId;
    if (competitorId != null) result.competitorId = competitorId;
    if (competitorName != null) result.competitorName = competitorName;
    if (productName != null) result.productName = productName;
    if (observedPrice != null) result.observedPrice = observedPrice;
    if (currency != null) result.currency = currency;
    if (offerType != null) result.offerType = offerType;
    if (isObservational != null) result.isObservational = isObservational;
    if (disclaimer != null) result.disclaimer = disclaimer;
    if (sourceClass != null) result.sourceClass = sourceClass;
    return result;
  }

  PricingComparisonItem._();

  factory PricingComparisonItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PricingComparisonItem()..mergeFromBuffer(data, registry);
  factory PricingComparisonItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PricingComparisonItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PricingComparisonItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: PricingComparisonItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'competitorId')
    ..aOS(3, _omitFieldNames ? '' : 'competitorName')
    ..aOS(4, _omitFieldNames ? '' : 'productName')
    ..aOS(5, _omitFieldNames ? '' : 'observedPrice')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOS(7, _omitFieldNames ? '' : 'offerType')
    ..aOB(8, _omitFieldNames ? '' : 'isObservational')
    ..aOS(9, _omitFieldNames ? '' : 'disclaimer')
    ..aE<$2.SourceClass>(10, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PricingComparisonItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PricingComparisonItem copyWith(
          void Function(PricingComparisonItem) updates) =>
      super.copyWith((message) => updates(message as PricingComparisonItem))
          as PricingComparisonItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PricingComparisonItem() / PricingComparisonItem.new instead')
  static PricingComparisonItem create() => PricingComparisonItem._();
  static $pb.GeneratedMessage $_createMessage() => PricingComparisonItem._();
  @$core.override
  PricingComparisonItem createEmptyInstance() => PricingComparisonItem._();
  @$core.pragma('dart2js:noInline')
  static PricingComparisonItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PricingComparisonItem>(
          PricingComparisonItem.$_createMessage);
  static PricingComparisonItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get competitorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set competitorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompetitorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompetitorId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get competitorName => $_getSZ(2);
  @$pb.TagNumber(3)
  set competitorName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCompetitorName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompetitorName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productName => $_getSZ(3);
  @$pb.TagNumber(4)
  set productName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductName() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get observedPrice => $_getSZ(4);
  @$pb.TagNumber(5)
  set observedPrice($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasObservedPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservedPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get offerType => $_getSZ(6);
  @$pb.TagNumber(7)
  set offerType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOfferType() => $_has(6);
  @$pb.TagNumber(7)
  void clearOfferType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isObservational => $_getBF(7);
  @$pb.TagNumber(8)
  set isObservational($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsObservational() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsObservational() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get disclaimer => $_getSZ(8);
  @$pb.TagNumber(9)
  set disclaimer($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDisclaimer() => $_has(8);
  @$pb.TagNumber(9)
  void clearDisclaimer() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.SourceClass get sourceClass => $_getN(9);
  @$pb.TagNumber(10)
  set sourceClass($2.SourceClass value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSourceClass() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceClass() => $_clearField(10);
}

/// FormatComparisonItem represents content format pattern analysis.
class FormatComparisonItem extends $pb.GeneratedMessage {
  factory FormatComparisonItem({
    $core.String? formatName,
    $core.double? yourSharePct,
    $core.double? marketAvgSharePct,
    $core.double? topCompetitorSharePct,
    $core.String? recommendation,
    $2.SourceClass? sourceClass,
    $2.ConfidenceBand? confidence,
  }) {
    final result = FormatComparisonItem._();
    if (formatName != null) result.formatName = formatName;
    if (yourSharePct != null) result.yourSharePct = yourSharePct;
    if (marketAvgSharePct != null) result.marketAvgSharePct = marketAvgSharePct;
    if (topCompetitorSharePct != null)
      result.topCompetitorSharePct = topCompetitorSharePct;
    if (recommendation != null) result.recommendation = recommendation;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (confidence != null) result.confidence = confidence;
    return result;
  }

  FormatComparisonItem._();

  factory FormatComparisonItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FormatComparisonItem()..mergeFromBuffer(data, registry);
  factory FormatComparisonItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FormatComparisonItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FormatComparisonItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: FormatComparisonItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'formatName')
    ..aD(2, _omitFieldNames ? '' : 'yourSharePct',
        fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'marketAvgSharePct',
        fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'topCompetitorSharePct',
        fieldType: $pb.PbFieldType.OF)
    ..aOS(5, _omitFieldNames ? '' : 'recommendation')
    ..aE<$2.SourceClass>(6, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aE<$2.ConfidenceBand>(7, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormatComparisonItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormatComparisonItem copyWith(void Function(FormatComparisonItem) updates) =>
      super.copyWith((message) => updates(message as FormatComparisonItem))
          as FormatComparisonItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FormatComparisonItem() / FormatComparisonItem.new instead')
  static FormatComparisonItem create() => FormatComparisonItem._();
  static $pb.GeneratedMessage $_createMessage() => FormatComparisonItem._();
  @$core.override
  FormatComparisonItem createEmptyInstance() => FormatComparisonItem._();
  @$core.pragma('dart2js:noInline')
  static FormatComparisonItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FormatComparisonItem>(
          FormatComparisonItem.$_createMessage);
  static FormatComparisonItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get formatName => $_getSZ(0);
  @$pb.TagNumber(1)
  set formatName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFormatName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormatName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get yourSharePct => $_getN(1);
  @$pb.TagNumber(2)
  set yourSharePct($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasYourSharePct() => $_has(1);
  @$pb.TagNumber(2)
  void clearYourSharePct() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get marketAvgSharePct => $_getN(2);
  @$pb.TagNumber(3)
  set marketAvgSharePct($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMarketAvgSharePct() => $_has(2);
  @$pb.TagNumber(3)
  void clearMarketAvgSharePct() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get topCompetitorSharePct => $_getN(3);
  @$pb.TagNumber(4)
  set topCompetitorSharePct($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTopCompetitorSharePct() => $_has(3);
  @$pb.TagNumber(4)
  void clearTopCompetitorSharePct() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get recommendation => $_getSZ(4);
  @$pb.TagNumber(5)
  set recommendation($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecommendation() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecommendation() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.SourceClass get sourceClass => $_getN(5);
  @$pb.TagNumber(6)
  set sourceClass($2.SourceClass value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceClass() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceClass() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.ConfidenceBand get confidence => $_getN(6);
  @$pb.TagNumber(7)
  set confidence($2.ConfidenceBand value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasConfidence() => $_has(6);
  @$pb.TagNumber(7)
  void clearConfidence() => $_clearField(7);
}

/// FinancialNonConflationNotice enforces Acceptance Target 3 and RULE-M03-003.
class FinancialNonConflationNotice extends $pb.GeneratedMessage {
  factory FinancialNonConflationNotice({
    $core.String? metricName,
    $core.String? status,
    $core.String? displayValue,
    $core.String? caveatText,
    $core.bool? isConflationBlocked,
  }) {
    final result = FinancialNonConflationNotice._();
    if (metricName != null) result.metricName = metricName;
    if (status != null) result.status = status;
    if (displayValue != null) result.displayValue = displayValue;
    if (caveatText != null) result.caveatText = caveatText;
    if (isConflationBlocked != null)
      result.isConflationBlocked = isConflationBlocked;
    return result;
  }

  FinancialNonConflationNotice._();

  factory FinancialNonConflationNotice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FinancialNonConflationNotice()..mergeFromBuffer(data, registry);
  factory FinancialNonConflationNotice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FinancialNonConflationNotice()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinancialNonConflationNotice',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: FinancialNonConflationNotice.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'metricName')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'displayValue')
    ..aOS(4, _omitFieldNames ? '' : 'caveatText')
    ..aOB(5, _omitFieldNames ? '' : 'isConflationBlocked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinancialNonConflationNotice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinancialNonConflationNotice copyWith(
          void Function(FinancialNonConflationNotice) updates) =>
      super.copyWith(
              (message) => updates(message as FinancialNonConflationNotice))
          as FinancialNonConflationNotice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use FinancialNonConflationNotice() / FinancialNonConflationNotice.new instead')
  static FinancialNonConflationNotice create() =>
      FinancialNonConflationNotice._();
  static $pb.GeneratedMessage $_createMessage() =>
      FinancialNonConflationNotice._();
  @$core.override
  FinancialNonConflationNotice createEmptyInstance() =>
      FinancialNonConflationNotice._();
  @$core.pragma('dart2js:noInline')
  static FinancialNonConflationNotice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinancialNonConflationNotice>(
          FinancialNonConflationNotice.$_createMessage);
  static FinancialNonConflationNotice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get metricName => $_getSZ(0);
  @$pb.TagNumber(1)
  set metricName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMetricName() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetricName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get caveatText => $_getSZ(3);
  @$pb.TagNumber(4)
  set caveatText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCaveatText() => $_has(3);
  @$pb.TagNumber(4)
  void clearCaveatText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isConflationBlocked => $_getBF(4);
  @$pb.TagNumber(5)
  set isConflationBlocked($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsConflationBlocked() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsConflationBlocked() => $_clearField(5);
}

/// EntityBenchmarkScore summarizes comparative score across key axes.
class EntityBenchmarkScore extends $pb.GeneratedMessage {
  factory EntityBenchmarkScore({
    $core.String? entityId,
    $core.String? entityName,
    $core.String? handle,
    $core.bool? isYou,
    $core.int? rank,
    $core.double? overallScore,
    $fixnum.Int64? followers,
    $core.double? growthRate,
    $core.double? engagementRate,
    $fixnum.Int64? avgViews,
    $core.double? postsPerWeek,
    $core.Iterable<$core.String>? leaderBadges,
  }) {
    final result = EntityBenchmarkScore._();
    if (entityId != null) result.entityId = entityId;
    if (entityName != null) result.entityName = entityName;
    if (handle != null) result.handle = handle;
    if (isYou != null) result.isYou = isYou;
    if (rank != null) result.rank = rank;
    if (overallScore != null) result.overallScore = overallScore;
    if (followers != null) result.followers = followers;
    if (growthRate != null) result.growthRate = growthRate;
    if (engagementRate != null) result.engagementRate = engagementRate;
    if (avgViews != null) result.avgViews = avgViews;
    if (postsPerWeek != null) result.postsPerWeek = postsPerWeek;
    if (leaderBadges != null) result.leaderBadges.addAll(leaderBadges);
    return result;
  }

  EntityBenchmarkScore._();

  factory EntityBenchmarkScore.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityBenchmarkScore()..mergeFromBuffer(data, registry);
  factory EntityBenchmarkScore.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EntityBenchmarkScore()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityBenchmarkScore',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: EntityBenchmarkScore.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'entityId')
    ..aOS(2, _omitFieldNames ? '' : 'entityName')
    ..aOS(3, _omitFieldNames ? '' : 'handle')
    ..aOB(4, _omitFieldNames ? '' : 'isYou')
    ..aI(5, _omitFieldNames ? '' : 'rank')
    ..aD(6, _omitFieldNames ? '' : 'overallScore',
        fieldType: $pb.PbFieldType.OF)
    ..aInt64(7, _omitFieldNames ? '' : 'followers')
    ..aD(8, _omitFieldNames ? '' : 'growthRate', fieldType: $pb.PbFieldType.OF)
    ..aD(9, _omitFieldNames ? '' : 'engagementRate',
        fieldType: $pb.PbFieldType.OF)
    ..aInt64(10, _omitFieldNames ? '' : 'avgViews')
    ..aD(11, _omitFieldNames ? '' : 'postsPerWeek',
        fieldType: $pb.PbFieldType.OF)
    ..pPS(12, _omitFieldNames ? '' : 'leaderBadges')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityBenchmarkScore clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityBenchmarkScore copyWith(void Function(EntityBenchmarkScore) updates) =>
      super.copyWith((message) => updates(message as EntityBenchmarkScore))
          as EntityBenchmarkScore;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EntityBenchmarkScore() / EntityBenchmarkScore.new instead')
  static EntityBenchmarkScore create() => EntityBenchmarkScore._();
  static $pb.GeneratedMessage $_createMessage() => EntityBenchmarkScore._();
  @$core.override
  EntityBenchmarkScore createEmptyInstance() => EntityBenchmarkScore._();
  @$core.pragma('dart2js:noInline')
  static EntityBenchmarkScore getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityBenchmarkScore>(
          EntityBenchmarkScore.$_createMessage);
  static EntityBenchmarkScore? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get entityName => $_getSZ(1);
  @$pb.TagNumber(2)
  set entityName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEntityName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get handle => $_getSZ(2);
  @$pb.TagNumber(3)
  set handle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHandle() => $_has(2);
  @$pb.TagNumber(3)
  void clearHandle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isYou => $_getBF(3);
  @$pb.TagNumber(4)
  set isYou($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsYou() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsYou() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get rank => $_getIZ(4);
  @$pb.TagNumber(5)
  set rank($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRank() => $_has(4);
  @$pb.TagNumber(5)
  void clearRank() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get overallScore => $_getN(5);
  @$pb.TagNumber(6)
  set overallScore($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOverallScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearOverallScore() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get followers => $_getI64(6);
  @$pb.TagNumber(7)
  set followers($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowers() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowers() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get growthRate => $_getN(7);
  @$pb.TagNumber(8)
  set growthRate($core.double value) => $_setFloat(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGrowthRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearGrowthRate() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get engagementRate => $_getN(8);
  @$pb.TagNumber(9)
  set engagementRate($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEngagementRate() => $_has(8);
  @$pb.TagNumber(9)
  void clearEngagementRate() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get avgViews => $_getI64(9);
  @$pb.TagNumber(10)
  set avgViews($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAvgViews() => $_has(9);
  @$pb.TagNumber(10)
  void clearAvgViews() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get postsPerWeek => $_getN(10);
  @$pb.TagNumber(11)
  set postsPerWeek($core.double value) => $_setFloat(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPostsPerWeek() => $_has(10);
  @$pb.TagNumber(11)
  void clearPostsPerWeek() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get leaderBadges => $_getList(11);
}

/// BenchmarkComparison aggregates side-by-side comparison per Screen W041.
class BenchmarkComparison extends $pb.GeneratedMessage {
  factory BenchmarkComparison({
    $core.String? workspaceId,
    $core.String? period,
    $core.int? totalTracked,
    $core.int? yourRank,
    $core.double? yourOverallScore,
    $core.double? scoreDeltaVsLastMonth,
    $core.Iterable<EntityBenchmarkScore>? entities,
    EntityBenchmarkScore? marketAverage,
    FinancialNonConflationNotice? revenueMetricGuard,
    $core.String? aiInsightSummary,
    $2.SourceClass? insightSourceClass,
    $2.ConfidenceBand? insightConfidence,
    WhyExplanation? insightWhy,
  }) {
    final result = BenchmarkComparison._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (period != null) result.period = period;
    if (totalTracked != null) result.totalTracked = totalTracked;
    if (yourRank != null) result.yourRank = yourRank;
    if (yourOverallScore != null) result.yourOverallScore = yourOverallScore;
    if (scoreDeltaVsLastMonth != null)
      result.scoreDeltaVsLastMonth = scoreDeltaVsLastMonth;
    if (entities != null) result.entities.addAll(entities);
    if (marketAverage != null) result.marketAverage = marketAverage;
    if (revenueMetricGuard != null)
      result.revenueMetricGuard = revenueMetricGuard;
    if (aiInsightSummary != null) result.aiInsightSummary = aiInsightSummary;
    if (insightSourceClass != null)
      result.insightSourceClass = insightSourceClass;
    if (insightConfidence != null) result.insightConfidence = insightConfidence;
    if (insightWhy != null) result.insightWhy = insightWhy;
    return result;
  }

  BenchmarkComparison._();

  factory BenchmarkComparison.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkComparison()..mergeFromBuffer(data, registry);
  factory BenchmarkComparison.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkComparison()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BenchmarkComparison',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: BenchmarkComparison.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'period')
    ..aI(3, _omitFieldNames ? '' : 'totalTracked')
    ..aI(4, _omitFieldNames ? '' : 'yourRank')
    ..aD(5, _omitFieldNames ? '' : 'yourOverallScore',
        fieldType: $pb.PbFieldType.OF)
    ..aD(6, _omitFieldNames ? '' : 'scoreDeltaVsLastMonth',
        fieldType: $pb.PbFieldType.OF)
    ..pPM<EntityBenchmarkScore>(7, _omitFieldNames ? '' : 'entities',
        subBuilder: EntityBenchmarkScore.$_createMessage)
    ..aOM<EntityBenchmarkScore>(8, _omitFieldNames ? '' : 'marketAverage',
        subBuilder: EntityBenchmarkScore.$_createMessage)
    ..aOM<FinancialNonConflationNotice>(
        9, _omitFieldNames ? '' : 'revenueMetricGuard',
        subBuilder: FinancialNonConflationNotice.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'aiInsightSummary')
    ..aE<$2.SourceClass>(11, _omitFieldNames ? '' : 'insightSourceClass',
        enumValues: $2.SourceClass.values)
    ..aE<$2.ConfidenceBand>(12, _omitFieldNames ? '' : 'insightConfidence',
        enumValues: $2.ConfidenceBand.values)
    ..aOM<WhyExplanation>(13, _omitFieldNames ? '' : 'insightWhy',
        subBuilder: WhyExplanation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkComparison clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkComparison copyWith(void Function(BenchmarkComparison) updates) =>
      super.copyWith((message) => updates(message as BenchmarkComparison))
          as BenchmarkComparison;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use BenchmarkComparison() / BenchmarkComparison.new instead')
  static BenchmarkComparison create() => BenchmarkComparison._();
  static $pb.GeneratedMessage $_createMessage() => BenchmarkComparison._();
  @$core.override
  BenchmarkComparison createEmptyInstance() => BenchmarkComparison._();
  @$core.pragma('dart2js:noInline')
  static BenchmarkComparison getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BenchmarkComparison>(
          BenchmarkComparison.$_createMessage);
  static BenchmarkComparison? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get period => $_getSZ(1);
  @$pb.TagNumber(2)
  set period($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalTracked => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalTracked($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalTracked() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalTracked() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get yourRank => $_getIZ(3);
  @$pb.TagNumber(4)
  set yourRank($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasYourRank() => $_has(3);
  @$pb.TagNumber(4)
  void clearYourRank() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get yourOverallScore => $_getN(4);
  @$pb.TagNumber(5)
  set yourOverallScore($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasYourOverallScore() => $_has(4);
  @$pb.TagNumber(5)
  void clearYourOverallScore() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get scoreDeltaVsLastMonth => $_getN(5);
  @$pb.TagNumber(6)
  set scoreDeltaVsLastMonth($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasScoreDeltaVsLastMonth() => $_has(5);
  @$pb.TagNumber(6)
  void clearScoreDeltaVsLastMonth() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<EntityBenchmarkScore> get entities => $_getList(6);

  @$pb.TagNumber(8)
  EntityBenchmarkScore get marketAverage => $_getN(7);
  @$pb.TagNumber(8)
  set marketAverage(EntityBenchmarkScore value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasMarketAverage() => $_has(7);
  @$pb.TagNumber(8)
  void clearMarketAverage() => $_clearField(8);
  @$pb.TagNumber(8)
  EntityBenchmarkScore ensureMarketAverage() => $_ensure(7);

  @$pb.TagNumber(9)
  FinancialNonConflationNotice get revenueMetricGuard => $_getN(8);
  @$pb.TagNumber(9)
  set revenueMetricGuard(FinancialNonConflationNotice value) =>
      $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRevenueMetricGuard() => $_has(8);
  @$pb.TagNumber(9)
  void clearRevenueMetricGuard() => $_clearField(9);
  @$pb.TagNumber(9)
  FinancialNonConflationNotice ensureRevenueMetricGuard() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get aiInsightSummary => $_getSZ(9);
  @$pb.TagNumber(10)
  set aiInsightSummary($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAiInsightSummary() => $_has(9);
  @$pb.TagNumber(10)
  void clearAiInsightSummary() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.SourceClass get insightSourceClass => $_getN(10);
  @$pb.TagNumber(11)
  set insightSourceClass($2.SourceClass value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasInsightSourceClass() => $_has(10);
  @$pb.TagNumber(11)
  void clearInsightSourceClass() => $_clearField(11);

  @$pb.TagNumber(12)
  $2.ConfidenceBand get insightConfidence => $_getN(11);
  @$pb.TagNumber(12)
  set insightConfidence($2.ConfidenceBand value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasInsightConfidence() => $_has(11);
  @$pb.TagNumber(12)
  void clearInsightConfidence() => $_clearField(12);

  @$pb.TagNumber(13)
  WhyExplanation get insightWhy => $_getN(12);
  @$pb.TagNumber(13)
  set insightWhy(WhyExplanation value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasInsightWhy() => $_has(12);
  @$pb.TagNumber(13)
  void clearInsightWhy() => $_clearField(13);
  @$pb.TagNumber(13)
  WhyExplanation ensureInsightWhy() => $_ensure(12);
}

/// BenchmarkDataPoint represents a data point on a competitor benchmark curve.
class BenchmarkDataPoint extends $pb.GeneratedMessage {
  factory BenchmarkDataPoint({
    $1.Timestamp? timestamp,
    $core.double? value,
    $core.String? formattedValue,
  }) {
    final result = BenchmarkDataPoint._();
    if (timestamp != null) result.timestamp = timestamp;
    if (value != null) result.value = value;
    if (formattedValue != null) result.formattedValue = formattedValue;
    return result;
  }

  BenchmarkDataPoint._();

  factory BenchmarkDataPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkDataPoint()..mergeFromBuffer(data, registry);
  factory BenchmarkDataPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkDataPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BenchmarkDataPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: BenchmarkDataPoint.$_createMessage)
    ..aOM<$1.Timestamp>(1, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aD(2, _omitFieldNames ? '' : 'value')
    ..aOS(3, _omitFieldNames ? '' : 'formattedValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkDataPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkDataPoint copyWith(void Function(BenchmarkDataPoint) updates) =>
      super.copyWith((message) => updates(message as BenchmarkDataPoint))
          as BenchmarkDataPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BenchmarkDataPoint() / BenchmarkDataPoint.new instead')
  static BenchmarkDataPoint create() => BenchmarkDataPoint._();
  static $pb.GeneratedMessage $_createMessage() => BenchmarkDataPoint._();
  @$core.override
  BenchmarkDataPoint createEmptyInstance() => BenchmarkDataPoint._();
  @$core.pragma('dart2js:noInline')
  static BenchmarkDataPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BenchmarkDataPoint>(
          BenchmarkDataPoint.$_createMessage);
  static BenchmarkDataPoint? _defaultInstance;

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
  $core.double get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get formattedValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set formattedValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormattedValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormattedValue() => $_clearField(3);
}

/// TimeSeriesSeries represents one entity's metric curve.
class TimeSeriesSeries extends $pb.GeneratedMessage {
  factory TimeSeriesSeries({
    $core.String? entityId,
    $core.String? entityName,
    $core.String? handle,
    $core.bool? isYou,
    $core.Iterable<BenchmarkDataPoint>? points,
  }) {
    final result = TimeSeriesSeries._();
    if (entityId != null) result.entityId = entityId;
    if (entityName != null) result.entityName = entityName;
    if (handle != null) result.handle = handle;
    if (isYou != null) result.isYou = isYou;
    if (points != null) result.points.addAll(points);
    return result;
  }

  TimeSeriesSeries._();

  factory TimeSeriesSeries.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TimeSeriesSeries()..mergeFromBuffer(data, registry);
  factory TimeSeriesSeries.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TimeSeriesSeries()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TimeSeriesSeries',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: TimeSeriesSeries.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'entityId')
    ..aOS(2, _omitFieldNames ? '' : 'entityName')
    ..aOS(3, _omitFieldNames ? '' : 'handle')
    ..aOB(4, _omitFieldNames ? '' : 'isYou')
    ..pPM<BenchmarkDataPoint>(5, _omitFieldNames ? '' : 'points',
        subBuilder: BenchmarkDataPoint.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeSeriesSeries clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TimeSeriesSeries copyWith(void Function(TimeSeriesSeries) updates) =>
      super.copyWith((message) => updates(message as TimeSeriesSeries))
          as TimeSeriesSeries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TimeSeriesSeries() / TimeSeriesSeries.new instead')
  static TimeSeriesSeries create() => TimeSeriesSeries._();
  static $pb.GeneratedMessage $_createMessage() => TimeSeriesSeries._();
  @$core.override
  TimeSeriesSeries createEmptyInstance() => TimeSeriesSeries._();
  @$core.pragma('dart2js:noInline')
  static TimeSeriesSeries getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeSeriesSeries>(
          TimeSeriesSeries.$_createMessage);
  static TimeSeriesSeries? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get entityName => $_getSZ(1);
  @$pb.TagNumber(2)
  set entityName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEntityName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get handle => $_getSZ(2);
  @$pb.TagNumber(3)
  set handle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHandle() => $_has(2);
  @$pb.TagNumber(3)
  void clearHandle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isYou => $_getBF(3);
  @$pb.TagNumber(4)
  set isYou($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsYou() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsYou() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<BenchmarkDataPoint> get points => $_getList(4);
}

/// CompetitorPreview provides live handle preview metadata.
class CompetitorPreview extends $pb.GeneratedMessage {
  factory CompetitorPreview({
    $core.String? platform,
    $core.String? externalHandle,
    $core.String? displayName,
    $core.String? avatarUrl,
    $fixnum.Int64? followersCount,
    $core.double? relevancePreview,
    $core.String? relevanceExplanation,
  }) {
    final result = CompetitorPreview._();
    if (platform != null) result.platform = platform;
    if (externalHandle != null) result.externalHandle = externalHandle;
    if (displayName != null) result.displayName = displayName;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (followersCount != null) result.followersCount = followersCount;
    if (relevancePreview != null) result.relevancePreview = relevancePreview;
    if (relevanceExplanation != null)
      result.relevanceExplanation = relevanceExplanation;
    return result;
  }

  CompetitorPreview._();

  factory CompetitorPreview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorPreview()..mergeFromBuffer(data, registry);
  factory CompetitorPreview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorPreview()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorPreview',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorPreview.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOS(2, _omitFieldNames ? '' : 'externalHandle')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aOS(4, _omitFieldNames ? '' : 'avatarUrl')
    ..aInt64(5, _omitFieldNames ? '' : 'followersCount')
    ..aD(6, _omitFieldNames ? '' : 'relevancePreview',
        fieldType: $pb.PbFieldType.OF)
    ..aOS(7, _omitFieldNames ? '' : 'relevanceExplanation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorPreview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorPreview copyWith(void Function(CompetitorPreview) updates) =>
      super.copyWith((message) => updates(message as CompetitorPreview))
          as CompetitorPreview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CompetitorPreview() / CompetitorPreview.new instead')
  static CompetitorPreview create() => CompetitorPreview._();
  static $pb.GeneratedMessage $_createMessage() => CompetitorPreview._();
  @$core.override
  CompetitorPreview createEmptyInstance() => CompetitorPreview._();
  @$core.pragma('dart2js:noInline')
  static CompetitorPreview getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CompetitorPreview>(
          CompetitorPreview.$_createMessage);
  static CompetitorPreview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get externalHandle => $_getSZ(1);
  @$pb.TagNumber(2)
  set externalHandle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExternalHandle() => $_has(1);
  @$pb.TagNumber(2)
  void clearExternalHandle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get avatarUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set avatarUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvatarUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatarUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get followersCount => $_getI64(4);
  @$pb.TagNumber(5)
  set followersCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFollowersCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearFollowersCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get relevancePreview => $_getN(5);
  @$pb.TagNumber(6)
  set relevancePreview($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRelevancePreview() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelevancePreview() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get relevanceExplanation => $_getSZ(6);
  @$pb.TagNumber(7)
  set relevanceExplanation($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRelevanceExplanation() => $_has(6);
  @$pb.TagNumber(7)
  void clearRelevanceExplanation() => $_clearField(7);
}

/// CompetitorServiceListRequest is the request for CompetitorService.List.
class CompetitorServiceListRequest extends $pb.GeneratedMessage {
  factory CompetitorServiceListRequest({
    $core.String? workspaceId,
    $core.int? pageSize,
    $core.String? pageToken,
    $core.String? platform,
    $core.String? category,
    $core.String? searchQuery,
  }) {
    final result = CompetitorServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    if (platform != null) result.platform = platform;
    if (category != null) result.category = category;
    if (searchQuery != null) result.searchQuery = searchQuery;
    return result;
  }

  CompetitorServiceListRequest._();

  factory CompetitorServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceListRequest()..mergeFromBuffer(data, registry);
  factory CompetitorServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..aOS(4, _omitFieldNames ? '' : 'platform')
    ..aOS(5, _omitFieldNames ? '' : 'category')
    ..aOS(6, _omitFieldNames ? '' : 'searchQuery')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceListRequest copyWith(
          void Function(CompetitorServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompetitorServiceListRequest))
          as CompetitorServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompetitorServiceListRequest() / CompetitorServiceListRequest.new instead')
  static CompetitorServiceListRequest create() =>
      CompetitorServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompetitorServiceListRequest._();
  @$core.override
  CompetitorServiceListRequest createEmptyInstance() =>
      CompetitorServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static CompetitorServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompetitorServiceListRequest>(
          CompetitorServiceListRequest.$_createMessage);
  static CompetitorServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pageToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get platform => $_getSZ(3);
  @$pb.TagNumber(4)
  set platform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatform() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get category => $_getSZ(4);
  @$pb.TagNumber(5)
  set category($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get searchQuery => $_getSZ(5);
  @$pb.TagNumber(6)
  set searchQuery($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSearchQuery() => $_has(5);
  @$pb.TagNumber(6)
  void clearSearchQuery() => $_clearField(6);
}

/// CompetitorServiceListResponse is the response for CompetitorService.List.
class CompetitorServiceListResponse extends $pb.GeneratedMessage {
  factory CompetitorServiceListResponse({
    $core.Iterable<CompetitorEntity>? competitors,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = CompetitorServiceListResponse._();
    if (competitors != null) result.competitors.addAll(competitors);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  CompetitorServiceListResponse._();

  factory CompetitorServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceListResponse()..mergeFromBuffer(data, registry);
  factory CompetitorServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorServiceListResponse.$_createMessage)
    ..pPM<CompetitorEntity>(1, _omitFieldNames ? '' : 'competitors',
        subBuilder: CompetitorEntity.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceListResponse copyWith(
          void Function(CompetitorServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompetitorServiceListResponse))
          as CompetitorServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompetitorServiceListResponse() / CompetitorServiceListResponse.new instead')
  static CompetitorServiceListResponse create() =>
      CompetitorServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompetitorServiceListResponse._();
  @$core.override
  CompetitorServiceListResponse createEmptyInstance() =>
      CompetitorServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static CompetitorServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompetitorServiceListResponse>(
          CompetitorServiceListResponse.$_createMessage);
  static CompetitorServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CompetitorEntity> get competitors => $_getList(0);

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

/// CompetitorServiceAddRequest is the request for CompetitorService.Add.
class CompetitorServiceAddRequest extends $pb.GeneratedMessage {
  factory CompetitorServiceAddRequest({
    $core.String? workspaceId,
    $core.String? platform,
    $core.String? externalHandle,
    $core.String? name,
    $core.String? category,
    $core.String? notes,
    $core.String? idempotencyKey,
  }) {
    final result = CompetitorServiceAddRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    if (externalHandle != null) result.externalHandle = externalHandle;
    if (name != null) result.name = name;
    if (category != null) result.category = category;
    if (notes != null) result.notes = notes;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  CompetitorServiceAddRequest._();

  factory CompetitorServiceAddRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceAddRequest()..mergeFromBuffer(data, registry);
  factory CompetitorServiceAddRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceAddRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorServiceAddRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorServiceAddRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'externalHandle')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'category')
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..aOS(7, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceAddRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceAddRequest copyWith(
          void Function(CompetitorServiceAddRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompetitorServiceAddRequest))
          as CompetitorServiceAddRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompetitorServiceAddRequest() / CompetitorServiceAddRequest.new instead')
  static CompetitorServiceAddRequest create() =>
      CompetitorServiceAddRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompetitorServiceAddRequest._();
  @$core.override
  CompetitorServiceAddRequest createEmptyInstance() =>
      CompetitorServiceAddRequest._();
  @$core.pragma('dart2js:noInline')
  static CompetitorServiceAddRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompetitorServiceAddRequest>(
          CompetitorServiceAddRequest.$_createMessage);
  static CompetitorServiceAddRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get externalHandle => $_getSZ(2);
  @$pb.TagNumber(3)
  set externalHandle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExternalHandle() => $_has(2);
  @$pb.TagNumber(3)
  void clearExternalHandle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get category => $_getSZ(4);
  @$pb.TagNumber(5)
  set category($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get idempotencyKey => $_getSZ(6);
  @$pb.TagNumber(7)
  set idempotencyKey($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIdempotencyKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearIdempotencyKey() => $_clearField(7);
}

/// CompetitorServiceAddResponse is the response for CompetitorService.Add.
class CompetitorServiceAddResponse extends $pb.GeneratedMessage {
  factory CompetitorServiceAddResponse({
    CompetitorEntity? competitor,
  }) {
    final result = CompetitorServiceAddResponse._();
    if (competitor != null) result.competitor = competitor;
    return result;
  }

  CompetitorServiceAddResponse._();

  factory CompetitorServiceAddResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceAddResponse()..mergeFromBuffer(data, registry);
  factory CompetitorServiceAddResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceAddResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorServiceAddResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorServiceAddResponse.$_createMessage)
    ..aOM<CompetitorEntity>(1, _omitFieldNames ? '' : 'competitor',
        subBuilder: CompetitorEntity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceAddResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceAddResponse copyWith(
          void Function(CompetitorServiceAddResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompetitorServiceAddResponse))
          as CompetitorServiceAddResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompetitorServiceAddResponse() / CompetitorServiceAddResponse.new instead')
  static CompetitorServiceAddResponse create() =>
      CompetitorServiceAddResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompetitorServiceAddResponse._();
  @$core.override
  CompetitorServiceAddResponse createEmptyInstance() =>
      CompetitorServiceAddResponse._();
  @$core.pragma('dart2js:noInline')
  static CompetitorServiceAddResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompetitorServiceAddResponse>(
          CompetitorServiceAddResponse.$_createMessage);
  static CompetitorServiceAddResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CompetitorEntity get competitor => $_getN(0);
  @$pb.TagNumber(1)
  set competitor(CompetitorEntity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCompetitor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCompetitor() => $_clearField(1);
  @$pb.TagNumber(1)
  CompetitorEntity ensureCompetitor() => $_ensure(0);
}

/// CompetitorServiceRemoveRequest is the request for CompetitorService.Remove.
class CompetitorServiceRemoveRequest extends $pb.GeneratedMessage {
  factory CompetitorServiceRemoveRequest({
    $core.String? workspaceId,
    $core.String? competitorId,
  }) {
    final result = CompetitorServiceRemoveRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (competitorId != null) result.competitorId = competitorId;
    return result;
  }

  CompetitorServiceRemoveRequest._();

  factory CompetitorServiceRemoveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceRemoveRequest()..mergeFromBuffer(data, registry);
  factory CompetitorServiceRemoveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceRemoveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorServiceRemoveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorServiceRemoveRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'competitorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceRemoveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceRemoveRequest copyWith(
          void Function(CompetitorServiceRemoveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompetitorServiceRemoveRequest))
          as CompetitorServiceRemoveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompetitorServiceRemoveRequest() / CompetitorServiceRemoveRequest.new instead')
  static CompetitorServiceRemoveRequest create() =>
      CompetitorServiceRemoveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompetitorServiceRemoveRequest._();
  @$core.override
  CompetitorServiceRemoveRequest createEmptyInstance() =>
      CompetitorServiceRemoveRequest._();
  @$core.pragma('dart2js:noInline')
  static CompetitorServiceRemoveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompetitorServiceRemoveRequest>(
          CompetitorServiceRemoveRequest.$_createMessage);
  static CompetitorServiceRemoveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get competitorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set competitorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompetitorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompetitorId() => $_clearField(2);
}

/// CompetitorServiceRemoveResponse is the response for CompetitorService.Remove.
class CompetitorServiceRemoveResponse extends $pb.GeneratedMessage {
  factory CompetitorServiceRemoveResponse({
    $core.bool? success,
    $core.String? competitorId,
  }) {
    final result = CompetitorServiceRemoveResponse._();
    if (success != null) result.success = success;
    if (competitorId != null) result.competitorId = competitorId;
    return result;
  }

  CompetitorServiceRemoveResponse._();

  factory CompetitorServiceRemoveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceRemoveResponse()..mergeFromBuffer(data, registry);
  factory CompetitorServiceRemoveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompetitorServiceRemoveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompetitorServiceRemoveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: CompetitorServiceRemoveResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'competitorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceRemoveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompetitorServiceRemoveResponse copyWith(
          void Function(CompetitorServiceRemoveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompetitorServiceRemoveResponse))
          as CompetitorServiceRemoveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompetitorServiceRemoveResponse() / CompetitorServiceRemoveResponse.new instead')
  static CompetitorServiceRemoveResponse create() =>
      CompetitorServiceRemoveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompetitorServiceRemoveResponse._();
  @$core.override
  CompetitorServiceRemoveResponse createEmptyInstance() =>
      CompetitorServiceRemoveResponse._();
  @$core.pragma('dart2js:noInline')
  static CompetitorServiceRemoveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompetitorServiceRemoveResponse>(
          CompetitorServiceRemoveResponse.$_createMessage);
  static CompetitorServiceRemoveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get competitorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set competitorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompetitorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompetitorId() => $_clearField(2);
}

/// GetSuggestionsRequest is the request for CompetitorService.GetSuggestions.
class GetSuggestionsRequest extends $pb.GeneratedMessage {
  factory GetSuggestionsRequest({
    $core.String? workspaceId,
    $core.String? category,
    $core.int? limit,
  }) {
    final result = GetSuggestionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (category != null) result.category = category;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetSuggestionsRequest._();

  factory GetSuggestionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSuggestionsRequest()..mergeFromBuffer(data, registry);
  factory GetSuggestionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSuggestionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSuggestionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: GetSuggestionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuggestionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuggestionsRequest copyWith(
          void Function(GetSuggestionsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSuggestionsRequest))
          as GetSuggestionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSuggestionsRequest() / GetSuggestionsRequest.new instead')
  static GetSuggestionsRequest create() => GetSuggestionsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSuggestionsRequest._();
  @$core.override
  GetSuggestionsRequest createEmptyInstance() => GetSuggestionsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSuggestionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSuggestionsRequest>(
          GetSuggestionsRequest.$_createMessage);
  static GetSuggestionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get category => $_getSZ(1);
  @$pb.TagNumber(2)
  set category($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

/// GetSuggestionsResponse is the response for CompetitorService.GetSuggestions.
class GetSuggestionsResponse extends $pb.GeneratedMessage {
  factory GetSuggestionsResponse({
    $core.Iterable<CompetitorSuggestion>? suggestions,
  }) {
    final result = GetSuggestionsResponse._();
    if (suggestions != null) result.suggestions.addAll(suggestions);
    return result;
  }

  GetSuggestionsResponse._();

  factory GetSuggestionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSuggestionsResponse()..mergeFromBuffer(data, registry);
  factory GetSuggestionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSuggestionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSuggestionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: GetSuggestionsResponse.$_createMessage)
    ..pPM<CompetitorSuggestion>(1, _omitFieldNames ? '' : 'suggestions',
        subBuilder: CompetitorSuggestion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuggestionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuggestionsResponse copyWith(
          void Function(GetSuggestionsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSuggestionsResponse))
          as GetSuggestionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSuggestionsResponse() / GetSuggestionsResponse.new instead')
  static GetSuggestionsResponse create() => GetSuggestionsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSuggestionsResponse._();
  @$core.override
  GetSuggestionsResponse createEmptyInstance() => GetSuggestionsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSuggestionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSuggestionsResponse>(
          GetSuggestionsResponse.$_createMessage);
  static GetSuggestionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CompetitorSuggestion> get suggestions => $_getList(0);
}

/// DismissSuggestionRequest is the request for CompetitorService.DismissSuggestion.
class DismissSuggestionRequest extends $pb.GeneratedMessage {
  factory DismissSuggestionRequest({
    $core.String? workspaceId,
    $core.String? suggestionId,
  }) {
    final result = DismissSuggestionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (suggestionId != null) result.suggestionId = suggestionId;
    return result;
  }

  DismissSuggestionRequest._();

  factory DismissSuggestionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissSuggestionRequest()..mergeFromBuffer(data, registry);
  factory DismissSuggestionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissSuggestionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissSuggestionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: DismissSuggestionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'suggestionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissSuggestionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissSuggestionRequest copyWith(
          void Function(DismissSuggestionRequest) updates) =>
      super.copyWith((message) => updates(message as DismissSuggestionRequest))
          as DismissSuggestionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DismissSuggestionRequest() / DismissSuggestionRequest.new instead')
  static DismissSuggestionRequest create() => DismissSuggestionRequest._();
  static $pb.GeneratedMessage $_createMessage() => DismissSuggestionRequest._();
  @$core.override
  DismissSuggestionRequest createEmptyInstance() =>
      DismissSuggestionRequest._();
  @$core.pragma('dart2js:noInline')
  static DismissSuggestionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DismissSuggestionRequest>(
          DismissSuggestionRequest.$_createMessage);
  static DismissSuggestionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get suggestionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set suggestionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuggestionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuggestionId() => $_clearField(2);
}

/// DismissSuggestionResponse is the response for CompetitorService.DismissSuggestion.
class DismissSuggestionResponse extends $pb.GeneratedMessage {
  factory DismissSuggestionResponse({
    $core.bool? success,
    $core.String? suggestionId,
  }) {
    final result = DismissSuggestionResponse._();
    if (success != null) result.success = success;
    if (suggestionId != null) result.suggestionId = suggestionId;
    return result;
  }

  DismissSuggestionResponse._();

  factory DismissSuggestionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissSuggestionResponse()..mergeFromBuffer(data, registry);
  factory DismissSuggestionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DismissSuggestionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissSuggestionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: DismissSuggestionResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'suggestionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissSuggestionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissSuggestionResponse copyWith(
          void Function(DismissSuggestionResponse) updates) =>
      super.copyWith((message) => updates(message as DismissSuggestionResponse))
          as DismissSuggestionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DismissSuggestionResponse() / DismissSuggestionResponse.new instead')
  static DismissSuggestionResponse create() => DismissSuggestionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      DismissSuggestionResponse._();
  @$core.override
  DismissSuggestionResponse createEmptyInstance() =>
      DismissSuggestionResponse._();
  @$core.pragma('dart2js:noInline')
  static DismissSuggestionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DismissSuggestionResponse>(
          DismissSuggestionResponse.$_createMessage);
  static DismissSuggestionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get suggestionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set suggestionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuggestionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuggestionId() => $_clearField(2);
}

/// SetAlertsRequest is the request for CompetitorService.SetAlerts.
class SetAlertsRequest extends $pb.GeneratedMessage {
  factory SetAlertsRequest({
    $core.String? workspaceId,
    $core.String? competitorId,
    AlertConfig? alertConfig,
  }) {
    final result = SetAlertsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (competitorId != null) result.competitorId = competitorId;
    if (alertConfig != null) result.alertConfig = alertConfig;
    return result;
  }

  SetAlertsRequest._();

  factory SetAlertsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlertsRequest()..mergeFromBuffer(data, registry);
  factory SetAlertsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlertsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAlertsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: SetAlertsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'competitorId')
    ..aOM<AlertConfig>(3, _omitFieldNames ? '' : 'alertConfig',
        subBuilder: AlertConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlertsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlertsRequest copyWith(void Function(SetAlertsRequest) updates) =>
      super.copyWith((message) => updates(message as SetAlertsRequest))
          as SetAlertsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SetAlertsRequest() / SetAlertsRequest.new instead')
  static SetAlertsRequest create() => SetAlertsRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetAlertsRequest._();
  @$core.override
  SetAlertsRequest createEmptyInstance() => SetAlertsRequest._();
  @$core.pragma('dart2js:noInline')
  static SetAlertsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetAlertsRequest>(
          SetAlertsRequest.$_createMessage);
  static SetAlertsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get competitorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set competitorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompetitorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompetitorId() => $_clearField(2);

  @$pb.TagNumber(3)
  AlertConfig get alertConfig => $_getN(2);
  @$pb.TagNumber(3)
  set alertConfig(AlertConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAlertConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlertConfig() => $_clearField(3);
  @$pb.TagNumber(3)
  AlertConfig ensureAlertConfig() => $_ensure(2);
}

/// SetAlertsResponse is the response for CompetitorService.SetAlerts.
class SetAlertsResponse extends $pb.GeneratedMessage {
  factory SetAlertsResponse({
    $core.bool? success,
    $core.String? competitorId,
    AlertConfig? alertConfig,
  }) {
    final result = SetAlertsResponse._();
    if (success != null) result.success = success;
    if (competitorId != null) result.competitorId = competitorId;
    if (alertConfig != null) result.alertConfig = alertConfig;
    return result;
  }

  SetAlertsResponse._();

  factory SetAlertsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlertsResponse()..mergeFromBuffer(data, registry);
  factory SetAlertsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetAlertsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAlertsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: SetAlertsResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'competitorId')
    ..aOM<AlertConfig>(3, _omitFieldNames ? '' : 'alertConfig',
        subBuilder: AlertConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlertsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlertsResponse copyWith(void Function(SetAlertsResponse) updates) =>
      super.copyWith((message) => updates(message as SetAlertsResponse))
          as SetAlertsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SetAlertsResponse() / SetAlertsResponse.new instead')
  static SetAlertsResponse create() => SetAlertsResponse._();
  static $pb.GeneratedMessage $_createMessage() => SetAlertsResponse._();
  @$core.override
  SetAlertsResponse createEmptyInstance() => SetAlertsResponse._();
  @$core.pragma('dart2js:noInline')
  static SetAlertsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetAlertsResponse>(
          SetAlertsResponse.$_createMessage);
  static SetAlertsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get competitorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set competitorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompetitorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompetitorId() => $_clearField(2);

  @$pb.TagNumber(3)
  AlertConfig get alertConfig => $_getN(2);
  @$pb.TagNumber(3)
  set alertConfig(AlertConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAlertConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlertConfig() => $_clearField(3);
  @$pb.TagNumber(3)
  AlertConfig ensureAlertConfig() => $_ensure(2);
}

/// ValidateHandleRequest is the request for CompetitorService.ValidateHandle.
class ValidateHandleRequest extends $pb.GeneratedMessage {
  factory ValidateHandleRequest({
    $core.String? workspaceId,
    $core.String? platform,
    $core.String? externalHandle,
  }) {
    final result = ValidateHandleRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    if (externalHandle != null) result.externalHandle = externalHandle;
    return result;
  }

  ValidateHandleRequest._();

  factory ValidateHandleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateHandleRequest()..mergeFromBuffer(data, registry);
  factory ValidateHandleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateHandleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateHandleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: ValidateHandleRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'externalHandle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateHandleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateHandleRequest copyWith(
          void Function(ValidateHandleRequest) updates) =>
      super.copyWith((message) => updates(message as ValidateHandleRequest))
          as ValidateHandleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ValidateHandleRequest() / ValidateHandleRequest.new instead')
  static ValidateHandleRequest create() => ValidateHandleRequest._();
  static $pb.GeneratedMessage $_createMessage() => ValidateHandleRequest._();
  @$core.override
  ValidateHandleRequest createEmptyInstance() => ValidateHandleRequest._();
  @$core.pragma('dart2js:noInline')
  static ValidateHandleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateHandleRequest>(
          ValidateHandleRequest.$_createMessage);
  static ValidateHandleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get externalHandle => $_getSZ(2);
  @$pb.TagNumber(3)
  set externalHandle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExternalHandle() => $_has(2);
  @$pb.TagNumber(3)
  void clearExternalHandle() => $_clearField(3);
}

/// ValidateHandleResponse is the response for CompetitorService.ValidateHandle.
class ValidateHandleResponse extends $pb.GeneratedMessage {
  factory ValidateHandleResponse({
    $core.bool? isValid,
    $core.String? errorMessage,
    CompetitorPreview? preview,
  }) {
    final result = ValidateHandleResponse._();
    if (isValid != null) result.isValid = isValid;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (preview != null) result.preview = preview;
    return result;
  }

  ValidateHandleResponse._();

  factory ValidateHandleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateHandleResponse()..mergeFromBuffer(data, registry);
  factory ValidateHandleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateHandleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateHandleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: ValidateHandleResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isValid')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<CompetitorPreview>(3, _omitFieldNames ? '' : 'preview',
        subBuilder: CompetitorPreview.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateHandleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateHandleResponse copyWith(
          void Function(ValidateHandleResponse) updates) =>
      super.copyWith((message) => updates(message as ValidateHandleResponse))
          as ValidateHandleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ValidateHandleResponse() / ValidateHandleResponse.new instead')
  static ValidateHandleResponse create() => ValidateHandleResponse._();
  static $pb.GeneratedMessage $_createMessage() => ValidateHandleResponse._();
  @$core.override
  ValidateHandleResponse createEmptyInstance() => ValidateHandleResponse._();
  @$core.pragma('dart2js:noInline')
  static ValidateHandleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateHandleResponse>(
          ValidateHandleResponse.$_createMessage);
  static ValidateHandleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isValid => $_getBF(0);
  @$pb.TagNumber(1)
  set isValid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  CompetitorPreview get preview => $_getN(2);
  @$pb.TagNumber(3)
  set preview(CompetitorPreview value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPreview() => $_has(2);
  @$pb.TagNumber(3)
  void clearPreview() => $_clearField(3);
  @$pb.TagNumber(3)
  CompetitorPreview ensurePreview() => $_ensure(2);
}

/// AnalyzeBenchmarkRequest is the request for CompetitorService.AnalyzeBenchmark.
class AnalyzeBenchmarkRequest extends $pb.GeneratedMessage {
  factory AnalyzeBenchmarkRequest({
    $core.String? workspaceId,
    $core.String? competitorId,
    $core.String? snapshotType,
    $core.String? dataPeriodStart,
    $core.String? dataPeriodEnd,
  }) {
    final result = AnalyzeBenchmarkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (competitorId != null) result.competitorId = competitorId;
    if (snapshotType != null) result.snapshotType = snapshotType;
    if (dataPeriodStart != null) result.dataPeriodStart = dataPeriodStart;
    if (dataPeriodEnd != null) result.dataPeriodEnd = dataPeriodEnd;
    return result;
  }

  AnalyzeBenchmarkRequest._();

  factory AnalyzeBenchmarkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnalyzeBenchmarkRequest()..mergeFromBuffer(data, registry);
  factory AnalyzeBenchmarkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnalyzeBenchmarkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnalyzeBenchmarkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: AnalyzeBenchmarkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'competitorId')
    ..aOS(3, _omitFieldNames ? '' : 'snapshotType')
    ..aOS(4, _omitFieldNames ? '' : 'dataPeriodStart')
    ..aOS(5, _omitFieldNames ? '' : 'dataPeriodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeBenchmarkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeBenchmarkRequest copyWith(
          void Function(AnalyzeBenchmarkRequest) updates) =>
      super.copyWith((message) => updates(message as AnalyzeBenchmarkRequest))
          as AnalyzeBenchmarkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AnalyzeBenchmarkRequest() / AnalyzeBenchmarkRequest.new instead')
  static AnalyzeBenchmarkRequest create() => AnalyzeBenchmarkRequest._();
  static $pb.GeneratedMessage $_createMessage() => AnalyzeBenchmarkRequest._();
  @$core.override
  AnalyzeBenchmarkRequest createEmptyInstance() => AnalyzeBenchmarkRequest._();
  @$core.pragma('dart2js:noInline')
  static AnalyzeBenchmarkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnalyzeBenchmarkRequest>(
          AnalyzeBenchmarkRequest.$_createMessage);
  static AnalyzeBenchmarkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get competitorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set competitorId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompetitorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompetitorId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get snapshotType => $_getSZ(2);
  @$pb.TagNumber(3)
  set snapshotType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSnapshotType() => $_has(2);
  @$pb.TagNumber(3)
  void clearSnapshotType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get dataPeriodStart => $_getSZ(3);
  @$pb.TagNumber(4)
  set dataPeriodStart($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDataPeriodStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearDataPeriodStart() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dataPeriodEnd => $_getSZ(4);
  @$pb.TagNumber(5)
  set dataPeriodEnd($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDataPeriodEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearDataPeriodEnd() => $_clearField(5);
}

/// AnalyzeBenchmarkResponse is the response for CompetitorService.AnalyzeBenchmark.
class AnalyzeBenchmarkResponse extends $pb.GeneratedMessage {
  factory AnalyzeBenchmarkResponse({
    BenchmarkSnapshot? snapshot,
    $core.Iterable<WhiteSpaceGap>? whiteSpaceGaps,
    $core.Iterable<PricingComparisonItem>? pricingComparisons,
    $core.Iterable<FormatComparisonItem>? formatComparisons,
  }) {
    final result = AnalyzeBenchmarkResponse._();
    if (snapshot != null) result.snapshot = snapshot;
    if (whiteSpaceGaps != null) result.whiteSpaceGaps.addAll(whiteSpaceGaps);
    if (pricingComparisons != null)
      result.pricingComparisons.addAll(pricingComparisons);
    if (formatComparisons != null)
      result.formatComparisons.addAll(formatComparisons);
    return result;
  }

  AnalyzeBenchmarkResponse._();

  factory AnalyzeBenchmarkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnalyzeBenchmarkResponse()..mergeFromBuffer(data, registry);
  factory AnalyzeBenchmarkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AnalyzeBenchmarkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnalyzeBenchmarkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: AnalyzeBenchmarkResponse.$_createMessage)
    ..aOM<BenchmarkSnapshot>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: BenchmarkSnapshot.$_createMessage)
    ..pPM<WhiteSpaceGap>(2, _omitFieldNames ? '' : 'whiteSpaceGaps',
        subBuilder: WhiteSpaceGap.$_createMessage)
    ..pPM<PricingComparisonItem>(3, _omitFieldNames ? '' : 'pricingComparisons',
        subBuilder: PricingComparisonItem.$_createMessage)
    ..pPM<FormatComparisonItem>(4, _omitFieldNames ? '' : 'formatComparisons',
        subBuilder: FormatComparisonItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeBenchmarkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeBenchmarkResponse copyWith(
          void Function(AnalyzeBenchmarkResponse) updates) =>
      super.copyWith((message) => updates(message as AnalyzeBenchmarkResponse))
          as AnalyzeBenchmarkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AnalyzeBenchmarkResponse() / AnalyzeBenchmarkResponse.new instead')
  static AnalyzeBenchmarkResponse create() => AnalyzeBenchmarkResponse._();
  static $pb.GeneratedMessage $_createMessage() => AnalyzeBenchmarkResponse._();
  @$core.override
  AnalyzeBenchmarkResponse createEmptyInstance() =>
      AnalyzeBenchmarkResponse._();
  @$core.pragma('dart2js:noInline')
  static AnalyzeBenchmarkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnalyzeBenchmarkResponse>(
          AnalyzeBenchmarkResponse.$_createMessage);
  static AnalyzeBenchmarkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BenchmarkSnapshot get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot(BenchmarkSnapshot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  BenchmarkSnapshot ensureSnapshot() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<WhiteSpaceGap> get whiteSpaceGaps => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PricingComparisonItem> get pricingComparisons => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<FormatComparisonItem> get formatComparisons => $_getList(3);
}

/// BenchmarkServiceCompareRequest is the request for BenchmarkService.Compare.
class BenchmarkServiceCompareRequest extends $pb.GeneratedMessage {
  factory BenchmarkServiceCompareRequest({
    $core.String? workspaceId,
    $core.Iterable<$core.String>? competitorIds,
    $core.String? period,
  }) {
    final result = BenchmarkServiceCompareRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (competitorIds != null) result.competitorIds.addAll(competitorIds);
    if (period != null) result.period = period;
    return result;
  }

  BenchmarkServiceCompareRequest._();

  factory BenchmarkServiceCompareRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkServiceCompareRequest()..mergeFromBuffer(data, registry);
  factory BenchmarkServiceCompareRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkServiceCompareRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BenchmarkServiceCompareRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: BenchmarkServiceCompareRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..pPS(2, _omitFieldNames ? '' : 'competitorIds')
    ..aOS(3, _omitFieldNames ? '' : 'period')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkServiceCompareRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkServiceCompareRequest copyWith(
          void Function(BenchmarkServiceCompareRequest) updates) =>
      super.copyWith(
              (message) => updates(message as BenchmarkServiceCompareRequest))
          as BenchmarkServiceCompareRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BenchmarkServiceCompareRequest() / BenchmarkServiceCompareRequest.new instead')
  static BenchmarkServiceCompareRequest create() =>
      BenchmarkServiceCompareRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BenchmarkServiceCompareRequest._();
  @$core.override
  BenchmarkServiceCompareRequest createEmptyInstance() =>
      BenchmarkServiceCompareRequest._();
  @$core.pragma('dart2js:noInline')
  static BenchmarkServiceCompareRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BenchmarkServiceCompareRequest>(
          BenchmarkServiceCompareRequest.$_createMessage);
  static BenchmarkServiceCompareRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get competitorIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get period => $_getSZ(2);
  @$pb.TagNumber(3)
  set period($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriod() => $_clearField(3);
}

/// BenchmarkServiceCompareResponse is the response for BenchmarkService.Compare.
class BenchmarkServiceCompareResponse extends $pb.GeneratedMessage {
  factory BenchmarkServiceCompareResponse({
    BenchmarkComparison? comparison,
  }) {
    final result = BenchmarkServiceCompareResponse._();
    if (comparison != null) result.comparison = comparison;
    return result;
  }

  BenchmarkServiceCompareResponse._();

  factory BenchmarkServiceCompareResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkServiceCompareResponse()..mergeFromBuffer(data, registry);
  factory BenchmarkServiceCompareResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BenchmarkServiceCompareResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BenchmarkServiceCompareResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: BenchmarkServiceCompareResponse.$_createMessage)
    ..aOM<BenchmarkComparison>(1, _omitFieldNames ? '' : 'comparison',
        subBuilder: BenchmarkComparison.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkServiceCompareResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkServiceCompareResponse copyWith(
          void Function(BenchmarkServiceCompareResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BenchmarkServiceCompareResponse))
          as BenchmarkServiceCompareResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BenchmarkServiceCompareResponse() / BenchmarkServiceCompareResponse.new instead')
  static BenchmarkServiceCompareResponse create() =>
      BenchmarkServiceCompareResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BenchmarkServiceCompareResponse._();
  @$core.override
  BenchmarkServiceCompareResponse createEmptyInstance() =>
      BenchmarkServiceCompareResponse._();
  @$core.pragma('dart2js:noInline')
  static BenchmarkServiceCompareResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BenchmarkServiceCompareResponse>(
          BenchmarkServiceCompareResponse.$_createMessage);
  static BenchmarkServiceCompareResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BenchmarkComparison get comparison => $_getN(0);
  @$pb.TagNumber(1)
  set comparison(BenchmarkComparison value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComparison() => $_has(0);
  @$pb.TagNumber(1)
  void clearComparison() => $_clearField(1);
  @$pb.TagNumber(1)
  BenchmarkComparison ensureComparison() => $_ensure(0);
}

/// GetTimeSeriesRequest is the request for BenchmarkService.GetTimeSeries.
class GetTimeSeriesRequest extends $pb.GeneratedMessage {
  factory GetTimeSeriesRequest({
    $core.String? workspaceId,
    $core.Iterable<$core.String>? competitorIds,
    $core.String? metric,
    $core.String? period,
  }) {
    final result = GetTimeSeriesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (competitorIds != null) result.competitorIds.addAll(competitorIds);
    if (metric != null) result.metric = metric;
    if (period != null) result.period = period;
    return result;
  }

  GetTimeSeriesRequest._();

  factory GetTimeSeriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimeSeriesRequest()..mergeFromBuffer(data, registry);
  factory GetTimeSeriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimeSeriesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimeSeriesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: GetTimeSeriesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..pPS(2, _omitFieldNames ? '' : 'competitorIds')
    ..aOS(3, _omitFieldNames ? '' : 'metric')
    ..aOS(4, _omitFieldNames ? '' : 'period')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimeSeriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimeSeriesRequest copyWith(void Function(GetTimeSeriesRequest) updates) =>
      super.copyWith((message) => updates(message as GetTimeSeriesRequest))
          as GetTimeSeriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetTimeSeriesRequest() / GetTimeSeriesRequest.new instead')
  static GetTimeSeriesRequest create() => GetTimeSeriesRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetTimeSeriesRequest._();
  @$core.override
  GetTimeSeriesRequest createEmptyInstance() => GetTimeSeriesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetTimeSeriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimeSeriesRequest>(
          GetTimeSeriesRequest.$_createMessage);
  static GetTimeSeriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get competitorIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get metric => $_getSZ(2);
  @$pb.TagNumber(3)
  set metric($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMetric() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetric() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get period => $_getSZ(3);
  @$pb.TagNumber(4)
  set period($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriod() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriod() => $_clearField(4);
}

/// GetTimeSeriesResponse is the response for BenchmarkService.GetTimeSeries.
class GetTimeSeriesResponse extends $pb.GeneratedMessage {
  factory GetTimeSeriesResponse({
    $core.Iterable<TimeSeriesSeries>? series,
  }) {
    final result = GetTimeSeriesResponse._();
    if (series != null) result.series.addAll(series);
    return result;
  }

  GetTimeSeriesResponse._();

  factory GetTimeSeriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimeSeriesResponse()..mergeFromBuffer(data, registry);
  factory GetTimeSeriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTimeSeriesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimeSeriesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: GetTimeSeriesResponse.$_createMessage)
    ..pPM<TimeSeriesSeries>(1, _omitFieldNames ? '' : 'series',
        subBuilder: TimeSeriesSeries.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimeSeriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimeSeriesResponse copyWith(
          void Function(GetTimeSeriesResponse) updates) =>
      super.copyWith((message) => updates(message as GetTimeSeriesResponse))
          as GetTimeSeriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetTimeSeriesResponse() / GetTimeSeriesResponse.new instead')
  static GetTimeSeriesResponse create() => GetTimeSeriesResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetTimeSeriesResponse._();
  @$core.override
  GetTimeSeriesResponse createEmptyInstance() => GetTimeSeriesResponse._();
  @$core.pragma('dart2js:noInline')
  static GetTimeSeriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimeSeriesResponse>(
          GetTimeSeriesResponse.$_createMessage);
  static GetTimeSeriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TimeSeriesSeries> get series => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

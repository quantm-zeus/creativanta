// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/gamification.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $2;

import '../../common/v1/types.pb.dart' as $1;
import 'gamification.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'gamification.pbenum.dart';

/// CreatorProgress mirrors database_schema.md §14.1.
class CreatorProgress extends $pb.GeneratedMessage {
  factory CreatorProgress({
    $core.String? progressId,
    $1.UUID? workspaceId,
    $core.String? userId,
    $core.int? level,
    $core.int? xp,
    $core.int? xpToNextLevel,
    $core.int? streakDays,
    $core.String? streakLastActivityDate,
    $core.double? creatorScore,
    $core.int? totalAchievements,
    $core.String? seasonId,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
  }) {
    final result = CreatorProgress._();
    if (progressId != null) result.progressId = progressId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (level != null) result.level = level;
    if (xp != null) result.xp = xp;
    if (xpToNextLevel != null) result.xpToNextLevel = xpToNextLevel;
    if (streakDays != null) result.streakDays = streakDays;
    if (streakLastActivityDate != null)
      result.streakLastActivityDate = streakLastActivityDate;
    if (creatorScore != null) result.creatorScore = creatorScore;
    if (totalAchievements != null) result.totalAchievements = totalAchievements;
    if (seasonId != null) result.seasonId = seasonId;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  CreatorProgress._();

  factory CreatorProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatorProgress()..mergeFromBuffer(data, registry);
  factory CreatorProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatorProgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatorProgress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: CreatorProgress.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'progressId')
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aI(4, _omitFieldNames ? '' : 'level')
    ..aI(5, _omitFieldNames ? '' : 'xp')
    ..aI(6, _omitFieldNames ? '' : 'xpToNextLevel')
    ..aI(7, _omitFieldNames ? '' : 'streakDays')
    ..aOS(8, _omitFieldNames ? '' : 'streakLastActivityDate')
    ..aD(9, _omitFieldNames ? '' : 'creatorScore',
        fieldType: $pb.PbFieldType.OF)
    ..aI(10, _omitFieldNames ? '' : 'totalAchievements')
    ..aOS(11, _omitFieldNames ? '' : 'seasonId')
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatorProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatorProgress copyWith(void Function(CreatorProgress) updates) =>
      super.copyWith((message) => updates(message as CreatorProgress))
          as CreatorProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreatorProgress() / CreatorProgress.new instead')
  static CreatorProgress create() => CreatorProgress._();
  static $pb.GeneratedMessage $_createMessage() => CreatorProgress._();
  @$core.override
  CreatorProgress createEmptyInstance() => CreatorProgress._();
  @$core.pragma('dart2js:noInline')
  static CreatorProgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatorProgress>(
          CreatorProgress.$_createMessage);
  static CreatorProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get progressId => $_getSZ(0);
  @$pb.TagNumber(1)
  set progressId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProgressId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgressId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get level => $_getIZ(3);
  @$pb.TagNumber(4)
  set level($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLevel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLevel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get xp => $_getIZ(4);
  @$pb.TagNumber(5)
  set xp($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasXp() => $_has(4);
  @$pb.TagNumber(5)
  void clearXp() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get xpToNextLevel => $_getIZ(5);
  @$pb.TagNumber(6)
  set xpToNextLevel($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasXpToNextLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearXpToNextLevel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get streakDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set streakDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStreakDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearStreakDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get streakLastActivityDate => $_getSZ(7);
  @$pb.TagNumber(8)
  set streakLastActivityDate($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStreakLastActivityDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearStreakLastActivityDate() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get creatorScore => $_getN(8);
  @$pb.TagNumber(9)
  set creatorScore($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatorScore() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatorScore() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get totalAchievements => $_getIZ(9);
  @$pb.TagNumber(10)
  set totalAchievements($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTotalAchievements() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotalAchievements() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get seasonId => $_getSZ(10);
  @$pb.TagNumber(11)
  set seasonId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSeasonId() => $_has(10);
  @$pb.TagNumber(11)
  void clearSeasonId() => $_clearField(11);

  @$pb.TagNumber(12)
  $2.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureCreatedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $2.Timestamp get updatedAt => $_getN(12);
  @$pb.TagNumber(13)
  set updatedAt($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasUpdatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearUpdatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureUpdatedAt() => $_ensure(12);
}

/// AchievementDefinition mirrors database_schema.md §14.2.
class AchievementDefinition extends $pb.GeneratedMessage {
  factory AchievementDefinition({
    $core.String? achievementId,
    $core.String? code,
    $core.String? title,
    $core.String? description,
    $core.String? triggerConditionJson,
    $core.int? rewardCredits,
    $core.String? badgeImageUrl,
    $core.String? category,
    $core.int? sortOrder,
    $core.bool? active,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
  }) {
    final result = AchievementDefinition._();
    if (achievementId != null) result.achievementId = achievementId;
    if (code != null) result.code = code;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (triggerConditionJson != null)
      result.triggerConditionJson = triggerConditionJson;
    if (rewardCredits != null) result.rewardCredits = rewardCredits;
    if (badgeImageUrl != null) result.badgeImageUrl = badgeImageUrl;
    if (category != null) result.category = category;
    if (sortOrder != null) result.sortOrder = sortOrder;
    if (active != null) result.active = active;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  AchievementDefinition._();

  factory AchievementDefinition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AchievementDefinition()..mergeFromBuffer(data, registry);
  factory AchievementDefinition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AchievementDefinition()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AchievementDefinition',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: AchievementDefinition.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'achievementId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'triggerConditionJson')
    ..aI(6, _omitFieldNames ? '' : 'rewardCredits')
    ..aOS(7, _omitFieldNames ? '' : 'badgeImageUrl')
    ..aOS(8, _omitFieldNames ? '' : 'category')
    ..aI(9, _omitFieldNames ? '' : 'sortOrder')
    ..aOB(10, _omitFieldNames ? '' : 'active')
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AchievementDefinition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AchievementDefinition copyWith(
          void Function(AchievementDefinition) updates) =>
      super.copyWith((message) => updates(message as AchievementDefinition))
          as AchievementDefinition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AchievementDefinition() / AchievementDefinition.new instead')
  static AchievementDefinition create() => AchievementDefinition._();
  static $pb.GeneratedMessage $_createMessage() => AchievementDefinition._();
  @$core.override
  AchievementDefinition createEmptyInstance() => AchievementDefinition._();
  @$core.pragma('dart2js:noInline')
  static AchievementDefinition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AchievementDefinition>(
          AchievementDefinition.$_createMessage);
  static AchievementDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get achievementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set achievementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAchievementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAchievementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

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
  $core.String get triggerConditionJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set triggerConditionJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTriggerConditionJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearTriggerConditionJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get rewardCredits => $_getIZ(5);
  @$pb.TagNumber(6)
  set rewardCredits($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRewardCredits() => $_has(5);
  @$pb.TagNumber(6)
  void clearRewardCredits() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get badgeImageUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set badgeImageUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBadgeImageUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearBadgeImageUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get category => $_getSZ(7);
  @$pb.TagNumber(8)
  set category($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCategory() => $_has(7);
  @$pb.TagNumber(8)
  void clearCategory() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get sortOrder => $_getIZ(8);
  @$pb.TagNumber(9)
  set sortOrder($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSortOrder() => $_has(8);
  @$pb.TagNumber(9)
  void clearSortOrder() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get active => $_getBF(9);
  @$pb.TagNumber(10)
  set active($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasActive() => $_has(9);
  @$pb.TagNumber(10)
  void clearActive() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(11)
  set createdAt($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureCreatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $2.Timestamp get updatedAt => $_getN(11);
  @$pb.TagNumber(12)
  set updatedAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureUpdatedAt() => $_ensure(11);
}

/// AchievementRecord mirrors database_schema.md §14.2.
class AchievementRecord extends $pb.GeneratedMessage {
  factory AchievementRecord({
    $core.String? recordId,
    $1.UUID? workspaceId,
    $core.String? userId,
    $core.String? achievementId,
    $core.String? achievementCode,
    $2.Timestamp? earnedAt,
    $core.String? creditsAwarded,
  }) {
    final result = AchievementRecord._();
    if (recordId != null) result.recordId = recordId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (achievementId != null) result.achievementId = achievementId;
    if (achievementCode != null) result.achievementCode = achievementCode;
    if (earnedAt != null) result.earnedAt = earnedAt;
    if (creditsAwarded != null) result.creditsAwarded = creditsAwarded;
    return result;
  }

  AchievementRecord._();

  factory AchievementRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AchievementRecord()..mergeFromBuffer(data, registry);
  factory AchievementRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AchievementRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AchievementRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: AchievementRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'achievementId')
    ..aOS(5, _omitFieldNames ? '' : 'achievementCode')
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'earnedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'creditsAwarded')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AchievementRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AchievementRecord copyWith(void Function(AchievementRecord) updates) =>
      super.copyWith((message) => updates(message as AchievementRecord))
          as AchievementRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AchievementRecord() / AchievementRecord.new instead')
  static AchievementRecord create() => AchievementRecord._();
  static $pb.GeneratedMessage $_createMessage() => AchievementRecord._();
  @$core.override
  AchievementRecord createEmptyInstance() => AchievementRecord._();
  @$core.pragma('dart2js:noInline')
  static AchievementRecord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AchievementRecord>(
          AchievementRecord.$_createMessage);
  static AchievementRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get achievementId => $_getSZ(3);
  @$pb.TagNumber(4)
  set achievementId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAchievementId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAchievementId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get achievementCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set achievementCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAchievementCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearAchievementCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get earnedAt => $_getN(5);
  @$pb.TagNumber(6)
  set earnedAt($2.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEarnedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearEarnedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureEarnedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get creditsAwarded => $_getSZ(6);
  @$pb.TagNumber(7)
  set creditsAwarded($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreditsAwarded() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreditsAwarded() => $_clearField(7);
}

/// AchievementItem presents unified definition + user unlock status.
class AchievementItem extends $pb.GeneratedMessage {
  factory AchievementItem({
    AchievementDefinition? definition,
    $core.bool? unlocked,
    $2.Timestamp? earnedAt,
    $core.String? creditsAwarded,
    $core.int? currentProgress,
    $core.int? targetProgress,
  }) {
    final result = AchievementItem._();
    if (definition != null) result.definition = definition;
    if (unlocked != null) result.unlocked = unlocked;
    if (earnedAt != null) result.earnedAt = earnedAt;
    if (creditsAwarded != null) result.creditsAwarded = creditsAwarded;
    if (currentProgress != null) result.currentProgress = currentProgress;
    if (targetProgress != null) result.targetProgress = targetProgress;
    return result;
  }

  AchievementItem._();

  factory AchievementItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AchievementItem()..mergeFromBuffer(data, registry);
  factory AchievementItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AchievementItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AchievementItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: AchievementItem.$_createMessage)
    ..aOM<AchievementDefinition>(1, _omitFieldNames ? '' : 'definition',
        subBuilder: AchievementDefinition.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'unlocked')
    ..aOM<$2.Timestamp>(3, _omitFieldNames ? '' : 'earnedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'creditsAwarded')
    ..aI(5, _omitFieldNames ? '' : 'currentProgress')
    ..aI(6, _omitFieldNames ? '' : 'targetProgress')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AchievementItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AchievementItem copyWith(void Function(AchievementItem) updates) =>
      super.copyWith((message) => updates(message as AchievementItem))
          as AchievementItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AchievementItem() / AchievementItem.new instead')
  static AchievementItem create() => AchievementItem._();
  static $pb.GeneratedMessage $_createMessage() => AchievementItem._();
  @$core.override
  AchievementItem createEmptyInstance() => AchievementItem._();
  @$core.pragma('dart2js:noInline')
  static AchievementItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AchievementItem>(
          AchievementItem.$_createMessage);
  static AchievementItem? _defaultInstance;

  @$pb.TagNumber(1)
  AchievementDefinition get definition => $_getN(0);
  @$pb.TagNumber(1)
  set definition(AchievementDefinition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDefinition() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefinition() => $_clearField(1);
  @$pb.TagNumber(1)
  AchievementDefinition ensureDefinition() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get unlocked => $_getBF(1);
  @$pb.TagNumber(2)
  set unlocked($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnlocked() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnlocked() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.Timestamp get earnedAt => $_getN(2);
  @$pb.TagNumber(3)
  set earnedAt($2.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEarnedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearEarnedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Timestamp ensureEarnedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get creditsAwarded => $_getSZ(3);
  @$pb.TagNumber(4)
  set creditsAwarded($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreditsAwarded() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreditsAwarded() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get currentProgress => $_getIZ(4);
  @$pb.TagNumber(5)
  set currentProgress($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrentProgress() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentProgress() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get targetProgress => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetProgress($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetProgress() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetProgress() => $_clearField(6);
}

/// ChallengeDefinition mirrors database_schema.md §22.10.
class ChallengeDefinition extends $pb.GeneratedMessage {
  factory ChallengeDefinition({
    $core.String? challengeId,
    $core.String? title,
    $core.String? description,
    ChallengeType? challengeType,
    $core.int? targetValue,
    $core.int? rewardCredits,
    $core.String? startDate,
    $core.String? endDate,
    ChallengeStatus? status,
    $core.bool? isActive,
    $core.int? sortOrder,
    $2.Timestamp? createdAt,
  }) {
    final result = ChallengeDefinition._();
    if (challengeId != null) result.challengeId = challengeId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (challengeType != null) result.challengeType = challengeType;
    if (targetValue != null) result.targetValue = targetValue;
    if (rewardCredits != null) result.rewardCredits = rewardCredits;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (status != null) result.status = status;
    if (isActive != null) result.isActive = isActive;
    if (sortOrder != null) result.sortOrder = sortOrder;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ChallengeDefinition._();

  factory ChallengeDefinition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChallengeDefinition()..mergeFromBuffer(data, registry);
  factory ChallengeDefinition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChallengeDefinition()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChallengeDefinition',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ChallengeDefinition.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'challengeId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aE<ChallengeType>(4, _omitFieldNames ? '' : 'challengeType',
        enumValues: ChallengeType.values)
    ..aI(5, _omitFieldNames ? '' : 'targetValue')
    ..aI(6, _omitFieldNames ? '' : 'rewardCredits')
    ..aOS(7, _omitFieldNames ? '' : 'startDate')
    ..aOS(8, _omitFieldNames ? '' : 'endDate')
    ..aE<ChallengeStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: ChallengeStatus.values)
    ..aOB(10, _omitFieldNames ? '' : 'isActive')
    ..aI(11, _omitFieldNames ? '' : 'sortOrder')
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChallengeDefinition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChallengeDefinition copyWith(void Function(ChallengeDefinition) updates) =>
      super.copyWith((message) => updates(message as ChallengeDefinition))
          as ChallengeDefinition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ChallengeDefinition() / ChallengeDefinition.new instead')
  static ChallengeDefinition create() => ChallengeDefinition._();
  static $pb.GeneratedMessage $_createMessage() => ChallengeDefinition._();
  @$core.override
  ChallengeDefinition createEmptyInstance() => ChallengeDefinition._();
  @$core.pragma('dart2js:noInline')
  static ChallengeDefinition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChallengeDefinition>(
          ChallengeDefinition.$_createMessage);
  static ChallengeDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get challengeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set challengeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallengeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallengeId() => $_clearField(1);

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
  ChallengeType get challengeType => $_getN(3);
  @$pb.TagNumber(4)
  set challengeType(ChallengeType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasChallengeType() => $_has(3);
  @$pb.TagNumber(4)
  void clearChallengeType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get targetValue => $_getIZ(4);
  @$pb.TagNumber(5)
  set targetValue($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get rewardCredits => $_getIZ(5);
  @$pb.TagNumber(6)
  set rewardCredits($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRewardCredits() => $_has(5);
  @$pb.TagNumber(6)
  void clearRewardCredits() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get startDate => $_getSZ(6);
  @$pb.TagNumber(7)
  set startDate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStartDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartDate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get endDate => $_getSZ(7);
  @$pb.TagNumber(8)
  set endDate($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEndDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearEndDate() => $_clearField(8);

  @$pb.TagNumber(9)
  ChallengeStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(ChallengeStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isActive => $_getBF(9);
  @$pb.TagNumber(10)
  set isActive($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsActive() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsActive() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get sortOrder => $_getIZ(10);
  @$pb.TagNumber(11)
  set sortOrder($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSortOrder() => $_has(10);
  @$pb.TagNumber(11)
  void clearSortOrder() => $_clearField(11);

  @$pb.TagNumber(12)
  $2.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureCreatedAt() => $_ensure(11);
}

/// ChallengeProgress mirrors database_schema.md §22.11.
class ChallengeProgress extends $pb.GeneratedMessage {
  factory ChallengeProgress({
    $core.String? progressId,
    $1.UUID? workspaceId,
    $core.String? userId,
    $core.String? challengeId,
    $core.int? currentValue,
    $core.int? targetValue,
    $core.bool? completed,
    $2.Timestamp? completedAt,
    $core.bool? rewardCredited,
    $core.String? rewardTransactionId,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
  }) {
    final result = ChallengeProgress._();
    if (progressId != null) result.progressId = progressId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (challengeId != null) result.challengeId = challengeId;
    if (currentValue != null) result.currentValue = currentValue;
    if (targetValue != null) result.targetValue = targetValue;
    if (completed != null) result.completed = completed;
    if (completedAt != null) result.completedAt = completedAt;
    if (rewardCredited != null) result.rewardCredited = rewardCredited;
    if (rewardTransactionId != null)
      result.rewardTransactionId = rewardTransactionId;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ChallengeProgress._();

  factory ChallengeProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChallengeProgress()..mergeFromBuffer(data, registry);
  factory ChallengeProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChallengeProgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChallengeProgress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ChallengeProgress.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'progressId')
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'challengeId')
    ..aI(5, _omitFieldNames ? '' : 'currentValue')
    ..aI(6, _omitFieldNames ? '' : 'targetValue')
    ..aOB(7, _omitFieldNames ? '' : 'completed')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOB(9, _omitFieldNames ? '' : 'rewardCredited')
    ..aOS(10, _omitFieldNames ? '' : 'rewardTransactionId')
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChallengeProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChallengeProgress copyWith(void Function(ChallengeProgress) updates) =>
      super.copyWith((message) => updates(message as ChallengeProgress))
          as ChallengeProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChallengeProgress() / ChallengeProgress.new instead')
  static ChallengeProgress create() => ChallengeProgress._();
  static $pb.GeneratedMessage $_createMessage() => ChallengeProgress._();
  @$core.override
  ChallengeProgress createEmptyInstance() => ChallengeProgress._();
  @$core.pragma('dart2js:noInline')
  static ChallengeProgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChallengeProgress>(
          ChallengeProgress.$_createMessage);
  static ChallengeProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get progressId => $_getSZ(0);
  @$pb.TagNumber(1)
  set progressId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProgressId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgressId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get challengeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set challengeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChallengeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearChallengeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get currentValue => $_getIZ(4);
  @$pb.TagNumber(5)
  set currentValue($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrentValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get targetValue => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetValue($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get completed => $_getBF(6);
  @$pb.TagNumber(7)
  set completed($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCompleted() => $_has(6);
  @$pb.TagNumber(7)
  void clearCompleted() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Timestamp get completedAt => $_getN(7);
  @$pb.TagNumber(8)
  set completedAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCompletedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompletedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureCompletedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.bool get rewardCredited => $_getBF(8);
  @$pb.TagNumber(9)
  set rewardCredited($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRewardCredited() => $_has(8);
  @$pb.TagNumber(9)
  void clearRewardCredited() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get rewardTransactionId => $_getSZ(9);
  @$pb.TagNumber(10)
  set rewardTransactionId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRewardTransactionId() => $_has(9);
  @$pb.TagNumber(10)
  void clearRewardTransactionId() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(11)
  set createdAt($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureCreatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $2.Timestamp get updatedAt => $_getN(11);
  @$pb.TagNumber(12)
  set updatedAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureUpdatedAt() => $_ensure(11);
}

/// ChallengeItem presents challenge definition combined with user progress.
class ChallengeItem extends $pb.GeneratedMessage {
  factory ChallengeItem({
    ChallengeDefinition? challenge,
    ChallengeProgress? progress,
    $core.bool? enrolled,
  }) {
    final result = ChallengeItem._();
    if (challenge != null) result.challenge = challenge;
    if (progress != null) result.progress = progress;
    if (enrolled != null) result.enrolled = enrolled;
    return result;
  }

  ChallengeItem._();

  factory ChallengeItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChallengeItem()..mergeFromBuffer(data, registry);
  factory ChallengeItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChallengeItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChallengeItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ChallengeItem.$_createMessage)
    ..aOM<ChallengeDefinition>(1, _omitFieldNames ? '' : 'challenge',
        subBuilder: ChallengeDefinition.$_createMessage)
    ..aOM<ChallengeProgress>(2, _omitFieldNames ? '' : 'progress',
        subBuilder: ChallengeProgress.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'enrolled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChallengeItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChallengeItem copyWith(void Function(ChallengeItem) updates) =>
      super.copyWith((message) => updates(message as ChallengeItem))
          as ChallengeItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChallengeItem() / ChallengeItem.new instead')
  static ChallengeItem create() => ChallengeItem._();
  static $pb.GeneratedMessage $_createMessage() => ChallengeItem._();
  @$core.override
  ChallengeItem createEmptyInstance() => ChallengeItem._();
  @$core.pragma('dart2js:noInline')
  static ChallengeItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChallengeItem>(
          ChallengeItem.$_createMessage);
  static ChallengeItem? _defaultInstance;

  @$pb.TagNumber(1)
  ChallengeDefinition get challenge => $_getN(0);
  @$pb.TagNumber(1)
  set challenge(ChallengeDefinition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChallenge() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallenge() => $_clearField(1);
  @$pb.TagNumber(1)
  ChallengeDefinition ensureChallenge() => $_ensure(0);

  @$pb.TagNumber(2)
  ChallengeProgress get progress => $_getN(1);
  @$pb.TagNumber(2)
  set progress(ChallengeProgress value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);
  @$pb.TagNumber(2)
  ChallengeProgress ensureProgress() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get enrolled => $_getBF(2);
  @$pb.TagNumber(3)
  set enrolled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnrolled() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnrolled() => $_clearField(3);
}

/// LeaderboardEntry presents creator ranking for a workspace or global challenge.
class LeaderboardEntry extends $pb.GeneratedMessage {
  factory LeaderboardEntry({
    $core.int? rank,
    $core.String? userId,
    $core.String? userName,
    $core.String? avatarUrl,
    $core.int? score,
    $core.int? level,
    $core.int? streakDays,
  }) {
    final result = LeaderboardEntry._();
    if (rank != null) result.rank = rank;
    if (userId != null) result.userId = userId;
    if (userName != null) result.userName = userName;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (score != null) result.score = score;
    if (level != null) result.level = level;
    if (streakDays != null) result.streakDays = streakDays;
    return result;
  }

  LeaderboardEntry._();

  factory LeaderboardEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaderboardEntry()..mergeFromBuffer(data, registry);
  factory LeaderboardEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LeaderboardEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaderboardEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: LeaderboardEntry.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'rank')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'userName')
    ..aOS(4, _omitFieldNames ? '' : 'avatarUrl')
    ..aI(5, _omitFieldNames ? '' : 'score')
    ..aI(6, _omitFieldNames ? '' : 'level')
    ..aI(7, _omitFieldNames ? '' : 'streakDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaderboardEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaderboardEntry copyWith(void Function(LeaderboardEntry) updates) =>
      super.copyWith((message) => updates(message as LeaderboardEntry))
          as LeaderboardEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LeaderboardEntry() / LeaderboardEntry.new instead')
  static LeaderboardEntry create() => LeaderboardEntry._();
  static $pb.GeneratedMessage $_createMessage() => LeaderboardEntry._();
  @$core.override
  LeaderboardEntry createEmptyInstance() => LeaderboardEntry._();
  @$core.pragma('dart2js:noInline')
  static LeaderboardEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaderboardEntry>(
          LeaderboardEntry.$_createMessage);
  static LeaderboardEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get rank => $_getIZ(0);
  @$pb.TagNumber(1)
  set rank($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRank() => $_has(0);
  @$pb.TagNumber(1)
  void clearRank() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userName => $_getSZ(2);
  @$pb.TagNumber(3)
  set userName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get avatarUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set avatarUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvatarUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatarUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get score => $_getIZ(4);
  @$pb.TagNumber(5)
  set score($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScore() => $_has(4);
  @$pb.TagNumber(5)
  void clearScore() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get level => $_getIZ(5);
  @$pb.TagNumber(6)
  set level($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearLevel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get streakDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set streakDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStreakDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearStreakDays() => $_clearField(7);
}

class GetProgressRequest extends $pb.GeneratedMessage {
  factory GetProgressRequest({
    $1.UUID? workspaceId,
    $core.String? userId,
  }) {
    final result = GetProgressRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    return result;
  }

  GetProgressRequest._();

  factory GetProgressRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetProgressRequest()..mergeFromBuffer(data, registry);
  factory GetProgressRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetProgressRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProgressRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetProgressRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProgressRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProgressRequest copyWith(void Function(GetProgressRequest) updates) =>
      super.copyWith((message) => updates(message as GetProgressRequest))
          as GetProgressRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetProgressRequest() / GetProgressRequest.new instead')
  static GetProgressRequest create() => GetProgressRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetProgressRequest._();
  @$core.override
  GetProgressRequest createEmptyInstance() => GetProgressRequest._();
  @$core.pragma('dart2js:noInline')
  static GetProgressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProgressRequest>(
          GetProgressRequest.$_createMessage);
  static GetProgressRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class GetProgressResponse extends $pb.GeneratedMessage {
  factory GetProgressResponse({
    CreatorProgress? progress,
  }) {
    final result = GetProgressResponse._();
    if (progress != null) result.progress = progress;
    return result;
  }

  GetProgressResponse._();

  factory GetProgressResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetProgressResponse()..mergeFromBuffer(data, registry);
  factory GetProgressResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetProgressResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProgressResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetProgressResponse.$_createMessage)
    ..aOM<CreatorProgress>(1, _omitFieldNames ? '' : 'progress',
        subBuilder: CreatorProgress.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProgressResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProgressResponse copyWith(void Function(GetProgressResponse) updates) =>
      super.copyWith((message) => updates(message as GetProgressResponse))
          as GetProgressResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetProgressResponse() / GetProgressResponse.new instead')
  static GetProgressResponse create() => GetProgressResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetProgressResponse._();
  @$core.override
  GetProgressResponse createEmptyInstance() => GetProgressResponse._();
  @$core.pragma('dart2js:noInline')
  static GetProgressResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProgressResponse>(
          GetProgressResponse.$_createMessage);
  static GetProgressResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CreatorProgress get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(CreatorProgress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => $_clearField(1);
  @$pb.TagNumber(1)
  CreatorProgress ensureProgress() => $_ensure(0);
}

class ListAchievementsRequest extends $pb.GeneratedMessage {
  factory ListAchievementsRequest({
    $1.UUID? workspaceId,
    $core.String? userId,
    $core.String? category,
  }) {
    final result = ListAchievementsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (category != null) result.category = category;
    return result;
  }

  ListAchievementsRequest._();

  factory ListAchievementsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAchievementsRequest()..mergeFromBuffer(data, registry);
  factory ListAchievementsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAchievementsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAchievementsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListAchievementsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAchievementsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAchievementsRequest copyWith(
          void Function(ListAchievementsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAchievementsRequest))
          as ListAchievementsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAchievementsRequest() / ListAchievementsRequest.new instead')
  static ListAchievementsRequest create() => ListAchievementsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListAchievementsRequest._();
  @$core.override
  ListAchievementsRequest createEmptyInstance() => ListAchievementsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListAchievementsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAchievementsRequest>(
          ListAchievementsRequest.$_createMessage);
  static ListAchievementsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);
}

class ListAchievementsResponse extends $pb.GeneratedMessage {
  factory ListAchievementsResponse({
    $core.Iterable<AchievementItem>? achievements,
    $core.int? totalUnlocked,
    $core.int? totalAvailable,
  }) {
    final result = ListAchievementsResponse._();
    if (achievements != null) result.achievements.addAll(achievements);
    if (totalUnlocked != null) result.totalUnlocked = totalUnlocked;
    if (totalAvailable != null) result.totalAvailable = totalAvailable;
    return result;
  }

  ListAchievementsResponse._();

  factory ListAchievementsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAchievementsResponse()..mergeFromBuffer(data, registry);
  factory ListAchievementsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListAchievementsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAchievementsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListAchievementsResponse.$_createMessage)
    ..pPM<AchievementItem>(1, _omitFieldNames ? '' : 'achievements',
        subBuilder: AchievementItem.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'totalUnlocked')
    ..aI(3, _omitFieldNames ? '' : 'totalAvailable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAchievementsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAchievementsResponse copyWith(
          void Function(ListAchievementsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAchievementsResponse))
          as ListAchievementsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListAchievementsResponse() / ListAchievementsResponse.new instead')
  static ListAchievementsResponse create() => ListAchievementsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListAchievementsResponse._();
  @$core.override
  ListAchievementsResponse createEmptyInstance() =>
      ListAchievementsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListAchievementsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAchievementsResponse>(
          ListAchievementsResponse.$_createMessage);
  static ListAchievementsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AchievementItem> get achievements => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalUnlocked => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalUnlocked($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalUnlocked() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalUnlocked() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalAvailable => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalAvailable($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalAvailable() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalAvailable() => $_clearField(3);
}

class ListChallengesRequest extends $pb.GeneratedMessage {
  factory ListChallengesRequest({
    $1.UUID? workspaceId,
    $core.String? userId,
    ChallengeStatus? statusFilter,
  }) {
    final result = ListChallengesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  ListChallengesRequest._();

  factory ListChallengesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChallengesRequest()..mergeFromBuffer(data, registry);
  factory ListChallengesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChallengesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChallengesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListChallengesRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aE<ChallengeStatus>(3, _omitFieldNames ? '' : 'statusFilter',
        enumValues: ChallengeStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChallengesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChallengesRequest copyWith(
          void Function(ListChallengesRequest) updates) =>
      super.copyWith((message) => updates(message as ListChallengesRequest))
          as ListChallengesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListChallengesRequest() / ListChallengesRequest.new instead')
  static ListChallengesRequest create() => ListChallengesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListChallengesRequest._();
  @$core.override
  ListChallengesRequest createEmptyInstance() => ListChallengesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListChallengesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChallengesRequest>(
          ListChallengesRequest.$_createMessage);
  static ListChallengesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  ChallengeStatus get statusFilter => $_getN(2);
  @$pb.TagNumber(3)
  set statusFilter(ChallengeStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatusFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatusFilter() => $_clearField(3);
}

class ListChallengesResponse extends $pb.GeneratedMessage {
  factory ListChallengesResponse({
    $core.Iterable<ChallengeItem>? challenges,
  }) {
    final result = ListChallengesResponse._();
    if (challenges != null) result.challenges.addAll(challenges);
    return result;
  }

  ListChallengesResponse._();

  factory ListChallengesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChallengesResponse()..mergeFromBuffer(data, registry);
  factory ListChallengesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListChallengesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChallengesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListChallengesResponse.$_createMessage)
    ..pPM<ChallengeItem>(1, _omitFieldNames ? '' : 'challenges',
        subBuilder: ChallengeItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChallengesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChallengesResponse copyWith(
          void Function(ListChallengesResponse) updates) =>
      super.copyWith((message) => updates(message as ListChallengesResponse))
          as ListChallengesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListChallengesResponse() / ListChallengesResponse.new instead')
  static ListChallengesResponse create() => ListChallengesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListChallengesResponse._();
  @$core.override
  ListChallengesResponse createEmptyInstance() => ListChallengesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListChallengesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChallengesResponse>(
          ListChallengesResponse.$_createMessage);
  static ListChallengesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChallengeItem> get challenges => $_getList(0);
}

class GetChallengeProgressRequest extends $pb.GeneratedMessage {
  factory GetChallengeProgressRequest({
    $1.UUID? workspaceId,
    $core.String? userId,
    $core.String? challengeId,
  }) {
    final result = GetChallengeProgressRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (challengeId != null) result.challengeId = challengeId;
    return result;
  }

  GetChallengeProgressRequest._();

  factory GetChallengeProgressRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChallengeProgressRequest()..mergeFromBuffer(data, registry);
  factory GetChallengeProgressRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChallengeProgressRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChallengeProgressRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetChallengeProgressRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'challengeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChallengeProgressRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChallengeProgressRequest copyWith(
          void Function(GetChallengeProgressRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetChallengeProgressRequest))
          as GetChallengeProgressRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetChallengeProgressRequest() / GetChallengeProgressRequest.new instead')
  static GetChallengeProgressRequest create() =>
      GetChallengeProgressRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetChallengeProgressRequest._();
  @$core.override
  GetChallengeProgressRequest createEmptyInstance() =>
      GetChallengeProgressRequest._();
  @$core.pragma('dart2js:noInline')
  static GetChallengeProgressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChallengeProgressRequest>(
          GetChallengeProgressRequest.$_createMessage);
  static GetChallengeProgressRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get challengeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set challengeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChallengeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChallengeId() => $_clearField(3);
}

class GetChallengeProgressResponse extends $pb.GeneratedMessage {
  factory GetChallengeProgressResponse({
    ChallengeDefinition? challenge,
    ChallengeProgress? progress,
  }) {
    final result = GetChallengeProgressResponse._();
    if (challenge != null) result.challenge = challenge;
    if (progress != null) result.progress = progress;
    return result;
  }

  GetChallengeProgressResponse._();

  factory GetChallengeProgressResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChallengeProgressResponse()..mergeFromBuffer(data, registry);
  factory GetChallengeProgressResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetChallengeProgressResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChallengeProgressResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetChallengeProgressResponse.$_createMessage)
    ..aOM<ChallengeDefinition>(1, _omitFieldNames ? '' : 'challenge',
        subBuilder: ChallengeDefinition.$_createMessage)
    ..aOM<ChallengeProgress>(2, _omitFieldNames ? '' : 'progress',
        subBuilder: ChallengeProgress.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChallengeProgressResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChallengeProgressResponse copyWith(
          void Function(GetChallengeProgressResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetChallengeProgressResponse))
          as GetChallengeProgressResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetChallengeProgressResponse() / GetChallengeProgressResponse.new instead')
  static GetChallengeProgressResponse create() =>
      GetChallengeProgressResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetChallengeProgressResponse._();
  @$core.override
  GetChallengeProgressResponse createEmptyInstance() =>
      GetChallengeProgressResponse._();
  @$core.pragma('dart2js:noInline')
  static GetChallengeProgressResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChallengeProgressResponse>(
          GetChallengeProgressResponse.$_createMessage);
  static GetChallengeProgressResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ChallengeDefinition get challenge => $_getN(0);
  @$pb.TagNumber(1)
  set challenge(ChallengeDefinition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChallenge() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallenge() => $_clearField(1);
  @$pb.TagNumber(1)
  ChallengeDefinition ensureChallenge() => $_ensure(0);

  @$pb.TagNumber(2)
  ChallengeProgress get progress => $_getN(1);
  @$pb.TagNumber(2)
  set progress(ChallengeProgress value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);
  @$pb.TagNumber(2)
  ChallengeProgress ensureProgress() => $_ensure(1);
}

class ShareAchievementRequest extends $pb.GeneratedMessage {
  factory ShareAchievementRequest({
    $1.CommandContext? context,
    $core.String? achievementCode,
    $core.String? targetChannel,
  }) {
    final result = ShareAchievementRequest._();
    if (context != null) result.context = context;
    if (achievementCode != null) result.achievementCode = achievementCode;
    if (targetChannel != null) result.targetChannel = targetChannel;
    return result;
  }

  ShareAchievementRequest._();

  factory ShareAchievementRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShareAchievementRequest()..mergeFromBuffer(data, registry);
  factory ShareAchievementRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShareAchievementRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareAchievementRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ShareAchievementRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'achievementCode')
    ..aOS(3, _omitFieldNames ? '' : 'targetChannel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareAchievementRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareAchievementRequest copyWith(
          void Function(ShareAchievementRequest) updates) =>
      super.copyWith((message) => updates(message as ShareAchievementRequest))
          as ShareAchievementRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ShareAchievementRequest() / ShareAchievementRequest.new instead')
  static ShareAchievementRequest create() => ShareAchievementRequest._();
  static $pb.GeneratedMessage $_createMessage() => ShareAchievementRequest._();
  @$core.override
  ShareAchievementRequest createEmptyInstance() => ShareAchievementRequest._();
  @$core.pragma('dart2js:noInline')
  static ShareAchievementRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareAchievementRequest>(
          ShareAchievementRequest.$_createMessage);
  static ShareAchievementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get achievementCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set achievementCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAchievementCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearAchievementCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetChannel => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetChannel($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetChannel() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetChannel() => $_clearField(3);
}

class ShareAchievementResponse extends $pb.GeneratedMessage {
  factory ShareAchievementResponse({
    $core.bool? success,
    $core.String? shareUrl,
    $core.String? shareCardUrl,
    $core.String? message,
  }) {
    final result = ShareAchievementResponse._();
    if (success != null) result.success = success;
    if (shareUrl != null) result.shareUrl = shareUrl;
    if (shareCardUrl != null) result.shareCardUrl = shareCardUrl;
    if (message != null) result.message = message;
    return result;
  }

  ShareAchievementResponse._();

  factory ShareAchievementResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShareAchievementResponse()..mergeFromBuffer(data, registry);
  factory ShareAchievementResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShareAchievementResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareAchievementResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ShareAchievementResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'shareUrl')
    ..aOS(3, _omitFieldNames ? '' : 'shareCardUrl')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareAchievementResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareAchievementResponse copyWith(
          void Function(ShareAchievementResponse) updates) =>
      super.copyWith((message) => updates(message as ShareAchievementResponse))
          as ShareAchievementResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ShareAchievementResponse() / ShareAchievementResponse.new instead')
  static ShareAchievementResponse create() => ShareAchievementResponse._();
  static $pb.GeneratedMessage $_createMessage() => ShareAchievementResponse._();
  @$core.override
  ShareAchievementResponse createEmptyInstance() =>
      ShareAchievementResponse._();
  @$core.pragma('dart2js:noInline')
  static ShareAchievementResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareAchievementResponse>(
          ShareAchievementResponse.$_createMessage);
  static ShareAchievementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shareUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set shareUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShareUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get shareCardUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set shareCardUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShareCardUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearShareCardUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);
}

class GamificationServiceGetDashboardRequest extends $pb.GeneratedMessage {
  factory GamificationServiceGetDashboardRequest({
    $1.UUID? workspaceId,
    $core.String? userId,
  }) {
    final result = GamificationServiceGetDashboardRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    return result;
  }

  GamificationServiceGetDashboardRequest._();

  factory GamificationServiceGetDashboardRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GamificationServiceGetDashboardRequest()..mergeFromBuffer(data, registry);
  factory GamificationServiceGetDashboardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GamificationServiceGetDashboardRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GamificationServiceGetDashboardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance:
          GamificationServiceGetDashboardRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GamificationServiceGetDashboardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GamificationServiceGetDashboardRequest copyWith(
          void Function(GamificationServiceGetDashboardRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GamificationServiceGetDashboardRequest))
          as GamificationServiceGetDashboardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GamificationServiceGetDashboardRequest() / GamificationServiceGetDashboardRequest.new instead')
  static GamificationServiceGetDashboardRequest create() =>
      GamificationServiceGetDashboardRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GamificationServiceGetDashboardRequest._();
  @$core.override
  GamificationServiceGetDashboardRequest createEmptyInstance() =>
      GamificationServiceGetDashboardRequest._();
  @$core.pragma('dart2js:noInline')
  static GamificationServiceGetDashboardRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              GamificationServiceGetDashboardRequest>(
          GamificationServiceGetDashboardRequest.$_createMessage);
  static GamificationServiceGetDashboardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class GamificationServiceGetDashboardResponse extends $pb.GeneratedMessage {
  factory GamificationServiceGetDashboardResponse({
    CreatorProgress? progress,
    $core.Iterable<AchievementItem>? recentAchievements,
    $core.Iterable<ChallengeItem>? activeChallenges,
    $core.Iterable<LeaderboardEntry>? topCreators,
    $core.int? currentStreakDays,
    $core.String? streakMilestoneTarget,
    $core.int? streakMilestoneRewardCredits,
  }) {
    final result = GamificationServiceGetDashboardResponse._();
    if (progress != null) result.progress = progress;
    if (recentAchievements != null)
      result.recentAchievements.addAll(recentAchievements);
    if (activeChallenges != null)
      result.activeChallenges.addAll(activeChallenges);
    if (topCreators != null) result.topCreators.addAll(topCreators);
    if (currentStreakDays != null) result.currentStreakDays = currentStreakDays;
    if (streakMilestoneTarget != null)
      result.streakMilestoneTarget = streakMilestoneTarget;
    if (streakMilestoneRewardCredits != null)
      result.streakMilestoneRewardCredits = streakMilestoneRewardCredits;
    return result;
  }

  GamificationServiceGetDashboardResponse._();

  factory GamificationServiceGetDashboardResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GamificationServiceGetDashboardResponse()
        ..mergeFromBuffer(data, registry);
  factory GamificationServiceGetDashboardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GamificationServiceGetDashboardResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GamificationServiceGetDashboardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance:
          GamificationServiceGetDashboardResponse.$_createMessage)
    ..aOM<CreatorProgress>(1, _omitFieldNames ? '' : 'progress',
        subBuilder: CreatorProgress.$_createMessage)
    ..pPM<AchievementItem>(2, _omitFieldNames ? '' : 'recentAchievements',
        subBuilder: AchievementItem.$_createMessage)
    ..pPM<ChallengeItem>(3, _omitFieldNames ? '' : 'activeChallenges',
        subBuilder: ChallengeItem.$_createMessage)
    ..pPM<LeaderboardEntry>(4, _omitFieldNames ? '' : 'topCreators',
        subBuilder: LeaderboardEntry.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'currentStreakDays')
    ..aOS(6, _omitFieldNames ? '' : 'streakMilestoneTarget')
    ..aI(7, _omitFieldNames ? '' : 'streakMilestoneRewardCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GamificationServiceGetDashboardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GamificationServiceGetDashboardResponse copyWith(
          void Function(GamificationServiceGetDashboardResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GamificationServiceGetDashboardResponse))
          as GamificationServiceGetDashboardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GamificationServiceGetDashboardResponse() / GamificationServiceGetDashboardResponse.new instead')
  static GamificationServiceGetDashboardResponse create() =>
      GamificationServiceGetDashboardResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GamificationServiceGetDashboardResponse._();
  @$core.override
  GamificationServiceGetDashboardResponse createEmptyInstance() =>
      GamificationServiceGetDashboardResponse._();
  @$core.pragma('dart2js:noInline')
  static GamificationServiceGetDashboardResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              GamificationServiceGetDashboardResponse>(
          GamificationServiceGetDashboardResponse.$_createMessage);
  static GamificationServiceGetDashboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CreatorProgress get progress => $_getN(0);
  @$pb.TagNumber(1)
  set progress(CreatorProgress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => $_clearField(1);
  @$pb.TagNumber(1)
  CreatorProgress ensureProgress() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<AchievementItem> get recentAchievements => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ChallengeItem> get activeChallenges => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<LeaderboardEntry> get topCreators => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get currentStreakDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set currentStreakDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrentStreakDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentStreakDays() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get streakMilestoneTarget => $_getSZ(5);
  @$pb.TagNumber(6)
  set streakMilestoneTarget($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStreakMilestoneTarget() => $_has(5);
  @$pb.TagNumber(6)
  void clearStreakMilestoneTarget() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get streakMilestoneRewardCredits => $_getIZ(6);
  @$pb.TagNumber(7)
  set streakMilestoneRewardCredits($core.int value) =>
      $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStreakMilestoneRewardCredits() => $_has(6);
  @$pb.TagNumber(7)
  void clearStreakMilestoneRewardCredits() => $_clearField(7);
}

class GetAchievementsRequest extends $pb.GeneratedMessage {
  factory GetAchievementsRequest({
    $1.UUID? workspaceId,
    $core.String? userId,
  }) {
    final result = GetAchievementsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    return result;
  }

  GetAchievementsRequest._();

  factory GetAchievementsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAchievementsRequest()..mergeFromBuffer(data, registry);
  factory GetAchievementsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAchievementsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAchievementsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetAchievementsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAchievementsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAchievementsRequest copyWith(
          void Function(GetAchievementsRequest) updates) =>
      super.copyWith((message) => updates(message as GetAchievementsRequest))
          as GetAchievementsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAchievementsRequest() / GetAchievementsRequest.new instead')
  static GetAchievementsRequest create() => GetAchievementsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetAchievementsRequest._();
  @$core.override
  GetAchievementsRequest createEmptyInstance() => GetAchievementsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAchievementsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAchievementsRequest>(
          GetAchievementsRequest.$_createMessage);
  static GetAchievementsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class GetAchievementsResponse extends $pb.GeneratedMessage {
  factory GetAchievementsResponse({
    $core.Iterable<AchievementItem>? achievements,
  }) {
    final result = GetAchievementsResponse._();
    if (achievements != null) result.achievements.addAll(achievements);
    return result;
  }

  GetAchievementsResponse._();

  factory GetAchievementsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAchievementsResponse()..mergeFromBuffer(data, registry);
  factory GetAchievementsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAchievementsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAchievementsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetAchievementsResponse.$_createMessage)
    ..pPM<AchievementItem>(1, _omitFieldNames ? '' : 'achievements',
        subBuilder: AchievementItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAchievementsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAchievementsResponse copyWith(
          void Function(GetAchievementsResponse) updates) =>
      super.copyWith((message) => updates(message as GetAchievementsResponse))
          as GetAchievementsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAchievementsResponse() / GetAchievementsResponse.new instead')
  static GetAchievementsResponse create() => GetAchievementsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetAchievementsResponse._();
  @$core.override
  GetAchievementsResponse createEmptyInstance() => GetAchievementsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetAchievementsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAchievementsResponse>(
          GetAchievementsResponse.$_createMessage);
  static GetAchievementsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AchievementItem> get achievements => $_getList(0);
}

class GetActiveQuestsRequest extends $pb.GeneratedMessage {
  factory GetActiveQuestsRequest({
    $1.UUID? workspaceId,
    $core.String? userId,
  }) {
    final result = GetActiveQuestsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    return result;
  }

  GetActiveQuestsRequest._();

  factory GetActiveQuestsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActiveQuestsRequest()..mergeFromBuffer(data, registry);
  factory GetActiveQuestsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActiveQuestsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActiveQuestsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetActiveQuestsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveQuestsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveQuestsRequest copyWith(
          void Function(GetActiveQuestsRequest) updates) =>
      super.copyWith((message) => updates(message as GetActiveQuestsRequest))
          as GetActiveQuestsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetActiveQuestsRequest() / GetActiveQuestsRequest.new instead')
  static GetActiveQuestsRequest create() => GetActiveQuestsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetActiveQuestsRequest._();
  @$core.override
  GetActiveQuestsRequest createEmptyInstance() => GetActiveQuestsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetActiveQuestsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActiveQuestsRequest>(
          GetActiveQuestsRequest.$_createMessage);
  static GetActiveQuestsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class GetActiveQuestsResponse extends $pb.GeneratedMessage {
  factory GetActiveQuestsResponse({
    $core.Iterable<ChallengeItem>? quests,
  }) {
    final result = GetActiveQuestsResponse._();
    if (quests != null) result.quests.addAll(quests);
    return result;
  }

  GetActiveQuestsResponse._();

  factory GetActiveQuestsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActiveQuestsResponse()..mergeFromBuffer(data, registry);
  factory GetActiveQuestsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActiveQuestsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActiveQuestsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetActiveQuestsResponse.$_createMessage)
    ..pPM<ChallengeItem>(1, _omitFieldNames ? '' : 'quests',
        subBuilder: ChallengeItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveQuestsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActiveQuestsResponse copyWith(
          void Function(GetActiveQuestsResponse) updates) =>
      super.copyWith((message) => updates(message as GetActiveQuestsResponse))
          as GetActiveQuestsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetActiveQuestsResponse() / GetActiveQuestsResponse.new instead')
  static GetActiveQuestsResponse create() => GetActiveQuestsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetActiveQuestsResponse._();
  @$core.override
  GetActiveQuestsResponse createEmptyInstance() => GetActiveQuestsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetActiveQuestsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActiveQuestsResponse>(
          GetActiveQuestsResponse.$_createMessage);
  static GetActiveQuestsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChallengeItem> get quests => $_getList(0);
}

class GetLeaderboardRequest extends $pb.GeneratedMessage {
  factory GetLeaderboardRequest({
    $1.UUID? workspaceId,
    $core.String? timeframe,
    $core.int? limit,
  }) {
    final result = GetLeaderboardRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (timeframe != null) result.timeframe = timeframe;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetLeaderboardRequest._();

  factory GetLeaderboardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLeaderboardRequest()..mergeFromBuffer(data, registry);
  factory GetLeaderboardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLeaderboardRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLeaderboardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetLeaderboardRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'timeframe')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLeaderboardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLeaderboardRequest copyWith(
          void Function(GetLeaderboardRequest) updates) =>
      super.copyWith((message) => updates(message as GetLeaderboardRequest))
          as GetLeaderboardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetLeaderboardRequest() / GetLeaderboardRequest.new instead')
  static GetLeaderboardRequest create() => GetLeaderboardRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetLeaderboardRequest._();
  @$core.override
  GetLeaderboardRequest createEmptyInstance() => GetLeaderboardRequest._();
  @$core.pragma('dart2js:noInline')
  static GetLeaderboardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLeaderboardRequest>(
          GetLeaderboardRequest.$_createMessage);
  static GetLeaderboardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get timeframe => $_getSZ(1);
  @$pb.TagNumber(2)
  set timeframe($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeframe() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeframe() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class GetLeaderboardResponse extends $pb.GeneratedMessage {
  factory GetLeaderboardResponse({
    $core.Iterable<LeaderboardEntry>? entries,
    LeaderboardEntry? userEntry,
  }) {
    final result = GetLeaderboardResponse._();
    if (entries != null) result.entries.addAll(entries);
    if (userEntry != null) result.userEntry = userEntry;
    return result;
  }

  GetLeaderboardResponse._();

  factory GetLeaderboardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLeaderboardResponse()..mergeFromBuffer(data, registry);
  factory GetLeaderboardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLeaderboardResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLeaderboardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetLeaderboardResponse.$_createMessage)
    ..pPM<LeaderboardEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: LeaderboardEntry.$_createMessage)
    ..aOM<LeaderboardEntry>(2, _omitFieldNames ? '' : 'userEntry',
        subBuilder: LeaderboardEntry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLeaderboardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLeaderboardResponse copyWith(
          void Function(GetLeaderboardResponse) updates) =>
      super.copyWith((message) => updates(message as GetLeaderboardResponse))
          as GetLeaderboardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetLeaderboardResponse() / GetLeaderboardResponse.new instead')
  static GetLeaderboardResponse create() => GetLeaderboardResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetLeaderboardResponse._();
  @$core.override
  GetLeaderboardResponse createEmptyInstance() => GetLeaderboardResponse._();
  @$core.pragma('dart2js:noInline')
  static GetLeaderboardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLeaderboardResponse>(
          GetLeaderboardResponse.$_createMessage);
  static GetLeaderboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LeaderboardEntry> get entries => $_getList(0);

  @$pb.TagNumber(2)
  LeaderboardEntry get userEntry => $_getN(1);
  @$pb.TagNumber(2)
  set userEntry(LeaderboardEntry value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserEntry() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserEntry() => $_clearField(2);
  @$pb.TagNumber(2)
  LeaderboardEntry ensureUserEntry() => $_ensure(1);
}

class GetStreakRequest extends $pb.GeneratedMessage {
  factory GetStreakRequest({
    $1.UUID? workspaceId,
    $core.String? userId,
  }) {
    final result = GetStreakRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    return result;
  }

  GetStreakRequest._();

  factory GetStreakRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStreakRequest()..mergeFromBuffer(data, registry);
  factory GetStreakRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStreakRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStreakRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetStreakRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreakRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreakRequest copyWith(void Function(GetStreakRequest) updates) =>
      super.copyWith((message) => updates(message as GetStreakRequest))
          as GetStreakRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStreakRequest() / GetStreakRequest.new instead')
  static GetStreakRequest create() => GetStreakRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetStreakRequest._();
  @$core.override
  GetStreakRequest createEmptyInstance() => GetStreakRequest._();
  @$core.pragma('dart2js:noInline')
  static GetStreakRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStreakRequest>(
          GetStreakRequest.$_createMessage);
  static GetStreakRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class GetStreakResponse extends $pb.GeneratedMessage {
  factory GetStreakResponse({
    $core.int? streakDays,
    $core.String? lastActivityDate,
    $core.bool? isActiveToday,
    $core.int? nextMilestoneDays,
    $core.int? nextMilestoneRewardCredits,
  }) {
    final result = GetStreakResponse._();
    if (streakDays != null) result.streakDays = streakDays;
    if (lastActivityDate != null) result.lastActivityDate = lastActivityDate;
    if (isActiveToday != null) result.isActiveToday = isActiveToday;
    if (nextMilestoneDays != null) result.nextMilestoneDays = nextMilestoneDays;
    if (nextMilestoneRewardCredits != null)
      result.nextMilestoneRewardCredits = nextMilestoneRewardCredits;
    return result;
  }

  GetStreakResponse._();

  factory GetStreakResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStreakResponse()..mergeFromBuffer(data, registry);
  factory GetStreakResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStreakResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStreakResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetStreakResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'streakDays')
    ..aOS(2, _omitFieldNames ? '' : 'lastActivityDate')
    ..aOB(3, _omitFieldNames ? '' : 'isActiveToday')
    ..aI(4, _omitFieldNames ? '' : 'nextMilestoneDays')
    ..aI(5, _omitFieldNames ? '' : 'nextMilestoneRewardCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreakResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreakResponse copyWith(void Function(GetStreakResponse) updates) =>
      super.copyWith((message) => updates(message as GetStreakResponse))
          as GetStreakResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStreakResponse() / GetStreakResponse.new instead')
  static GetStreakResponse create() => GetStreakResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetStreakResponse._();
  @$core.override
  GetStreakResponse createEmptyInstance() => GetStreakResponse._();
  @$core.pragma('dart2js:noInline')
  static GetStreakResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStreakResponse>(
          GetStreakResponse.$_createMessage);
  static GetStreakResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get streakDays => $_getIZ(0);
  @$pb.TagNumber(1)
  set streakDays($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStreakDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreakDays() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastActivityDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastActivityDate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastActivityDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastActivityDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isActiveToday => $_getBF(2);
  @$pb.TagNumber(3)
  set isActiveToday($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsActiveToday() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsActiveToday() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get nextMilestoneDays => $_getIZ(3);
  @$pb.TagNumber(4)
  set nextMilestoneDays($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNextMilestoneDays() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextMilestoneDays() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get nextMilestoneRewardCredits => $_getIZ(4);
  @$pb.TagNumber(5)
  set nextMilestoneRewardCredits($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNextMilestoneRewardCredits() => $_has(4);
  @$pb.TagNumber(5)
  void clearNextMilestoneRewardCredits() => $_clearField(5);
}

class AdminRestoreStreakRequest extends $pb.GeneratedMessage {
  factory AdminRestoreStreakRequest({
    $1.CommandContext? context,
    $core.String? targetUserId,
    $core.int? restoredStreakDays,
    $core.String? reason,
  }) {
    final result = AdminRestoreStreakRequest._();
    if (context != null) result.context = context;
    if (targetUserId != null) result.targetUserId = targetUserId;
    if (restoredStreakDays != null)
      result.restoredStreakDays = restoredStreakDays;
    if (reason != null) result.reason = reason;
    return result;
  }

  AdminRestoreStreakRequest._();

  factory AdminRestoreStreakRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdminRestoreStreakRequest()..mergeFromBuffer(data, registry);
  factory AdminRestoreStreakRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdminRestoreStreakRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdminRestoreStreakRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: AdminRestoreStreakRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'targetUserId')
    ..aI(3, _omitFieldNames ? '' : 'restoredStreakDays')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminRestoreStreakRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminRestoreStreakRequest copyWith(
          void Function(AdminRestoreStreakRequest) updates) =>
      super.copyWith((message) => updates(message as AdminRestoreStreakRequest))
          as AdminRestoreStreakRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AdminRestoreStreakRequest() / AdminRestoreStreakRequest.new instead')
  static AdminRestoreStreakRequest create() => AdminRestoreStreakRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      AdminRestoreStreakRequest._();
  @$core.override
  AdminRestoreStreakRequest createEmptyInstance() =>
      AdminRestoreStreakRequest._();
  @$core.pragma('dart2js:noInline')
  static AdminRestoreStreakRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdminRestoreStreakRequest>(
          AdminRestoreStreakRequest.$_createMessage);
  static AdminRestoreStreakRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get targetUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get restoredStreakDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set restoredStreakDays($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRestoredStreakDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearRestoredStreakDays() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class AdminRestoreStreakResponse extends $pb.GeneratedMessage {
  factory AdminRestoreStreakResponse({
    $core.bool? success,
    CreatorProgress? progress,
    $core.String? message,
  }) {
    final result = AdminRestoreStreakResponse._();
    if (success != null) result.success = success;
    if (progress != null) result.progress = progress;
    if (message != null) result.message = message;
    return result;
  }

  AdminRestoreStreakResponse._();

  factory AdminRestoreStreakResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdminRestoreStreakResponse()..mergeFromBuffer(data, registry);
  factory AdminRestoreStreakResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdminRestoreStreakResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdminRestoreStreakResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: AdminRestoreStreakResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<CreatorProgress>(2, _omitFieldNames ? '' : 'progress',
        subBuilder: CreatorProgress.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminRestoreStreakResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminRestoreStreakResponse copyWith(
          void Function(AdminRestoreStreakResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AdminRestoreStreakResponse))
          as AdminRestoreStreakResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AdminRestoreStreakResponse() / AdminRestoreStreakResponse.new instead')
  static AdminRestoreStreakResponse create() => AdminRestoreStreakResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      AdminRestoreStreakResponse._();
  @$core.override
  AdminRestoreStreakResponse createEmptyInstance() =>
      AdminRestoreStreakResponse._();
  @$core.pragma('dart2js:noInline')
  static AdminRestoreStreakResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdminRestoreStreakResponse>(
          AdminRestoreStreakResponse.$_createMessage);
  static AdminRestoreStreakResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  CreatorProgress get progress => $_getN(1);
  @$pb.TagNumber(2)
  set progress(CreatorProgress value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);
  @$pb.TagNumber(2)
  CreatorProgress ensureProgress() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/script.proto.

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

import 'script.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'script.pbenum.dart';

/// Shot represents a single visual/audio camera shot inside a scene per database_schema.md §6.6.
class Shot extends $pb.GeneratedMessage {
  factory Shot({
    $core.String? shotId,
    $core.String? sceneId,
    $core.String? workspaceId,
    $core.int? shotIndex,
    $core.String? shotType,
    $core.String? description,
    $core.int? durationSeconds,
    $1.Timestamp? createdAt,
  }) {
    final result = Shot._();
    if (shotId != null) result.shotId = shotId;
    if (sceneId != null) result.sceneId = sceneId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (shotIndex != null) result.shotIndex = shotIndex;
    if (shotType != null) result.shotType = shotType;
    if (description != null) result.description = description;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Shot._();

  factory Shot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Shot()..mergeFromBuffer(data, registry);
  factory Shot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Shot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Shot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: Shot.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'shotId')
    ..aOS(2, _omitFieldNames ? '' : 'sceneId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aI(4, _omitFieldNames ? '' : 'shotIndex')
    ..aOS(5, _omitFieldNames ? '' : 'shotType')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..aI(7, _omitFieldNames ? '' : 'durationSeconds')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shot copyWith(void Function(Shot) updates) =>
      super.copyWith((message) => updates(message as Shot)) as Shot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Shot() / Shot.new instead')
  static Shot create() => Shot._();
  static $pb.GeneratedMessage $_createMessage() => Shot._();
  @$core.override
  Shot createEmptyInstance() => Shot._();
  @$core.pragma('dart2js:noInline')
  static Shot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Shot>(Shot.$_createMessage);
  static Shot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set shotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sceneId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sceneId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSceneId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSceneId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get shotIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set shotIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShotIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearShotIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get shotType => $_getSZ(4);
  @$pb.TagNumber(5)
  set shotType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShotType() => $_has(4);
  @$pb.TagNumber(5)
  void clearShotType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get durationSeconds => $_getIZ(6);
  @$pb.TagNumber(7)
  set durationSeconds($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDurationSeconds() => $_has(6);
  @$pb.TagNumber(7)
  void clearDurationSeconds() => $_clearField(7);

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
}

/// Scene represents a structured scene block with notes and duration target per database_schema.md §6.6.
class Scene extends $pb.GeneratedMessage {
  factory Scene({
    $core.String? sceneId,
    $core.String? scriptId,
    $core.String? workspaceId,
    $core.int? sceneIndex,
    $core.String? description,
    $core.String? content,
    $core.int? durationSeconds,
    $core.String? visualNotes,
    $core.String? audioNotes,
    $core.Iterable<Shot>? shotList,
    $1.Timestamp? createdAt,
  }) {
    final result = Scene._();
    if (sceneId != null) result.sceneId = sceneId;
    if (scriptId != null) result.scriptId = scriptId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sceneIndex != null) result.sceneIndex = sceneIndex;
    if (description != null) result.description = description;
    if (content != null) result.content = content;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (visualNotes != null) result.visualNotes = visualNotes;
    if (audioNotes != null) result.audioNotes = audioNotes;
    if (shotList != null) result.shotList.addAll(shotList);
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Scene._();

  factory Scene.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Scene()..mergeFromBuffer(data, registry);
  factory Scene.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Scene()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Scene',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: Scene.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sceneId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aI(4, _omitFieldNames ? '' : 'sceneIndex')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'content')
    ..aI(7, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(8, _omitFieldNames ? '' : 'visualNotes')
    ..aOS(9, _omitFieldNames ? '' : 'audioNotes')
    ..pPM<Shot>(10, _omitFieldNames ? '' : 'shotList',
        subBuilder: Shot.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Scene clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Scene copyWith(void Function(Scene) updates) =>
      super.copyWith((message) => updates(message as Scene)) as Scene;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Scene() / Scene.new instead')
  static Scene create() => Scene._();
  static $pb.GeneratedMessage $_createMessage() => Scene._();
  @$core.override
  Scene createEmptyInstance() => Scene._();
  @$core.pragma('dart2js:noInline')
  static Scene getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Scene>(Scene.$_createMessage);
  static Scene? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sceneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sceneId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSceneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSceneId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get sceneIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set sceneIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSceneIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSceneIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get durationSeconds => $_getIZ(6);
  @$pb.TagNumber(7)
  set durationSeconds($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDurationSeconds() => $_has(6);
  @$pb.TagNumber(7)
  void clearDurationSeconds() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get visualNotes => $_getSZ(7);
  @$pb.TagNumber(8)
  set visualNotes($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVisualNotes() => $_has(7);
  @$pb.TagNumber(8)
  void clearVisualNotes() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get audioNotes => $_getSZ(8);
  @$pb.TagNumber(9)
  set audioNotes($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAudioNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearAudioNotes() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<Shot> get shotList => $_getList(9);

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
}

/// CtaBlock represents a Call-To-Action element embedded in the script.
class CtaBlock extends $pb.GeneratedMessage {
  factory CtaBlock({
    $core.String? ctaId,
    $core.String? text,
    $core.String? buttonText,
    $core.String? destinationUrl,
    $core.String? ctaType,
  }) {
    final result = CtaBlock._();
    if (ctaId != null) result.ctaId = ctaId;
    if (text != null) result.text = text;
    if (buttonText != null) result.buttonText = buttonText;
    if (destinationUrl != null) result.destinationUrl = destinationUrl;
    if (ctaType != null) result.ctaType = ctaType;
    return result;
  }

  CtaBlock._();

  factory CtaBlock.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CtaBlock()..mergeFromBuffer(data, registry);
  factory CtaBlock.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CtaBlock()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CtaBlock',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CtaBlock.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'ctaId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'buttonText')
    ..aOS(4, _omitFieldNames ? '' : 'destinationUrl')
    ..aOS(5, _omitFieldNames ? '' : 'ctaType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CtaBlock clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CtaBlock copyWith(void Function(CtaBlock) updates) =>
      super.copyWith((message) => updates(message as CtaBlock)) as CtaBlock;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CtaBlock() / CtaBlock.new instead')
  static CtaBlock create() => CtaBlock._();
  static $pb.GeneratedMessage $_createMessage() => CtaBlock._();
  @$core.override
  CtaBlock createEmptyInstance() => CtaBlock._();
  @$core.pragma('dart2js:noInline')
  static CtaBlock getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CtaBlock>(CtaBlock.$_createMessage);
  static CtaBlock? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ctaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ctaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCtaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCtaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get buttonText => $_getSZ(2);
  @$pb.TagNumber(3)
  set buttonText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasButtonText() => $_has(2);
  @$pb.TagNumber(3)
  void clearButtonText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get destinationUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set destinationUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDestinationUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearDestinationUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get ctaType => $_getSZ(4);
  @$pb.TagNumber(5)
  set ctaType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCtaType() => $_has(4);
  @$pb.TagNumber(5)
  void clearCtaType() => $_clearField(5);
}

/// DisclosureBlock represents legal / platform disclosure requirements (RULE-M06-007).
class DisclosureBlock extends $pb.GeneratedMessage {
  factory DisclosureBlock({
    $core.String? disclosureId,
    $core.String? text,
    $core.String? platform,
    $core.bool? isDismissed,
    $core.String? dismissedBy,
    $1.Timestamp? dismissedAt,
    $core.String? dismissalReason,
  }) {
    final result = DisclosureBlock._();
    if (disclosureId != null) result.disclosureId = disclosureId;
    if (text != null) result.text = text;
    if (platform != null) result.platform = platform;
    if (isDismissed != null) result.isDismissed = isDismissed;
    if (dismissedBy != null) result.dismissedBy = dismissedBy;
    if (dismissedAt != null) result.dismissedAt = dismissedAt;
    if (dismissalReason != null) result.dismissalReason = dismissalReason;
    return result;
  }

  DisclosureBlock._();

  factory DisclosureBlock.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DisclosureBlock()..mergeFromBuffer(data, registry);
  factory DisclosureBlock.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DisclosureBlock()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisclosureBlock',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: DisclosureBlock.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'disclosureId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOB(4, _omitFieldNames ? '' : 'isDismissed')
    ..aOS(5, _omitFieldNames ? '' : 'dismissedBy')
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'dismissedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'dismissalReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisclosureBlock clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisclosureBlock copyWith(void Function(DisclosureBlock) updates) =>
      super.copyWith((message) => updates(message as DisclosureBlock))
          as DisclosureBlock;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DisclosureBlock() / DisclosureBlock.new instead')
  static DisclosureBlock create() => DisclosureBlock._();
  static $pb.GeneratedMessage $_createMessage() => DisclosureBlock._();
  @$core.override
  DisclosureBlock createEmptyInstance() => DisclosureBlock._();
  @$core.pragma('dart2js:noInline')
  static DisclosureBlock getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisclosureBlock>(
          DisclosureBlock.$_createMessage);
  static DisclosureBlock? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get disclosureId => $_getSZ(0);
  @$pb.TagNumber(1)
  set disclosureId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisclosureId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisclosureId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isDismissed => $_getBF(3);
  @$pb.TagNumber(4)
  set isDismissed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsDismissed() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsDismissed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dismissedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set dismissedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDismissedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearDismissedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Timestamp get dismissedAt => $_getN(5);
  @$pb.TagNumber(6)
  set dismissedAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDismissedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearDismissedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureDismissedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get dismissalReason => $_getSZ(6);
  @$pb.TagNumber(7)
  set dismissalReason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDismissalReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearDismissalReason() => $_clearField(7);
}

/// PublishTargetProfile represents target social platform configurations.
class PublishTargetProfile extends $pb.GeneratedMessage {
  factory PublishTargetProfile({
    $core.String? platform,
    $core.String? format,
    $core.String? accountId,
  }) {
    final result = PublishTargetProfile._();
    if (platform != null) result.platform = platform;
    if (format != null) result.format = format;
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  PublishTargetProfile._();

  factory PublishTargetProfile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishTargetProfile()..mergeFromBuffer(data, registry);
  factory PublishTargetProfile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishTargetProfile()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishTargetProfile',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: PublishTargetProfile.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOS(2, _omitFieldNames ? '' : 'format')
    ..aOS(3, _omitFieldNames ? '' : 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishTargetProfile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishTargetProfile copyWith(void Function(PublishTargetProfile) updates) =>
      super.copyWith((message) => updates(message as PublishTargetProfile))
          as PublishTargetProfile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PublishTargetProfile() / PublishTargetProfile.new instead')
  static PublishTargetProfile create() => PublishTargetProfile._();
  static $pb.GeneratedMessage $_createMessage() => PublishTargetProfile._();
  @$core.override
  PublishTargetProfile createEmptyInstance() => PublishTargetProfile._();
  @$core.pragma('dart2js:noInline')
  static PublishTargetProfile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishTargetProfile>(
          PublishTargetProfile.$_createMessage);
  static PublishTargetProfile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get format => $_getSZ(1);
  @$pb.TagNumber(2)
  set format($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFormat() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormat() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get accountId => $_getSZ(2);
  @$pb.TagNumber(3)
  set accountId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccountId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountId() => $_clearField(3);
}

/// AssetBrief represents production instructions feeding AI Video Studio (M07) per database_schema.md §6.5.
class AssetBrief extends $pb.GeneratedMessage {
  factory AssetBrief({
    $core.String? assetBriefId,
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? outputType,
    $core.String? targetFormat,
    $core.int? targetDurationSeconds,
    $core.Iterable<$core.String>? targetPlatforms,
    $core.String? continuityRequirementsJson,
    $core.String? brandVoiceRequirementsJson,
    $core.String? productionInstructions,
    AssetBriefStatus? status,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = AssetBrief._();
    if (assetBriefId != null) result.assetBriefId = assetBriefId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (outputType != null) result.outputType = outputType;
    if (targetFormat != null) result.targetFormat = targetFormat;
    if (targetDurationSeconds != null)
      result.targetDurationSeconds = targetDurationSeconds;
    if (targetPlatforms != null) result.targetPlatforms.addAll(targetPlatforms);
    if (continuityRequirementsJson != null)
      result.continuityRequirementsJson = continuityRequirementsJson;
    if (brandVoiceRequirementsJson != null)
      result.brandVoiceRequirementsJson = brandVoiceRequirementsJson;
    if (productionInstructions != null)
      result.productionInstructions = productionInstructions;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  AssetBrief._();

  factory AssetBrief.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AssetBrief()..mergeFromBuffer(data, registry);
  factory AssetBrief.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AssetBrief()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssetBrief',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: AssetBrief.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'assetBriefId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'scriptId')
    ..aOS(4, _omitFieldNames ? '' : 'outputType')
    ..aOS(5, _omitFieldNames ? '' : 'targetFormat')
    ..aI(6, _omitFieldNames ? '' : 'targetDurationSeconds')
    ..pPS(7, _omitFieldNames ? '' : 'targetPlatforms')
    ..aOS(8, _omitFieldNames ? '' : 'continuityRequirementsJson')
    ..aOS(9, _omitFieldNames ? '' : 'brandVoiceRequirementsJson')
    ..aOS(10, _omitFieldNames ? '' : 'productionInstructions')
    ..aE<AssetBriefStatus>(11, _omitFieldNames ? '' : 'status',
        enumValues: AssetBriefStatus.values)
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetBrief clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssetBrief copyWith(void Function(AssetBrief) updates) =>
      super.copyWith((message) => updates(message as AssetBrief)) as AssetBrief;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AssetBrief() / AssetBrief.new instead')
  static AssetBrief create() => AssetBrief._();
  static $pb.GeneratedMessage $_createMessage() => AssetBrief._();
  @$core.override
  AssetBrief createEmptyInstance() => AssetBrief._();
  @$core.pragma('dart2js:noInline')
  static AssetBrief getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssetBrief>(AssetBrief.$_createMessage);
  static AssetBrief? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetBriefId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetBriefId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetBriefId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetBriefId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scriptId => $_getSZ(2);
  @$pb.TagNumber(3)
  set scriptId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScriptId() => $_has(2);
  @$pb.TagNumber(3)
  void clearScriptId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get outputType => $_getSZ(3);
  @$pb.TagNumber(4)
  set outputType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutputType() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutputType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetFormat => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetFormat($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetFormat() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get targetDurationSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetDurationSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetDurationSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetDurationSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get targetPlatforms => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get continuityRequirementsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set continuityRequirementsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasContinuityRequirementsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearContinuityRequirementsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get brandVoiceRequirementsJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set brandVoiceRequirementsJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBrandVoiceRequirementsJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearBrandVoiceRequirementsJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get productionInstructions => $_getSZ(9);
  @$pb.TagNumber(10)
  set productionInstructions($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasProductionInstructions() => $_has(9);
  @$pb.TagNumber(10)
  void clearProductionInstructions() => $_clearField(10);

  @$pb.TagNumber(11)
  AssetBriefStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(AssetBriefStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => $_clearField(11);

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

/// ScriptVersion stores historical snapshot for compare and restore per Alternate Flow A3.
class ScriptVersion extends $pb.GeneratedMessage {
  factory ScriptVersion({
    $core.String? versionId,
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.int? versionIndex,
    $core.String? title,
    $core.Iterable<Scene>? scenes,
    $core.Iterable<CtaBlock>? ctaBlocks,
    $core.Iterable<DisclosureBlock>? disclosureBlocks,
    $core.int? durationTargetSeconds,
    ScriptLifecycleState? lifecycleState,
    ScriptApprovalState? approvalState,
    $core.String? snapshotReason,
    $core.String? createdBy,
    $1.Timestamp? createdAt,
  }) {
    final result = ScriptVersion._();
    if (versionId != null) result.versionId = versionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (versionIndex != null) result.versionIndex = versionIndex;
    if (title != null) result.title = title;
    if (scenes != null) result.scenes.addAll(scenes);
    if (ctaBlocks != null) result.ctaBlocks.addAll(ctaBlocks);
    if (disclosureBlocks != null)
      result.disclosureBlocks.addAll(disclosureBlocks);
    if (durationTargetSeconds != null)
      result.durationTargetSeconds = durationTargetSeconds;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (approvalState != null) result.approvalState = approvalState;
    if (snapshotReason != null) result.snapshotReason = snapshotReason;
    if (createdBy != null) result.createdBy = createdBy;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ScriptVersion._();

  factory ScriptVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptVersion()..mergeFromBuffer(data, registry);
  factory ScriptVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptVersion()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptVersion',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptVersion.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'versionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'scriptId')
    ..aI(4, _omitFieldNames ? '' : 'versionIndex')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..pPM<Scene>(6, _omitFieldNames ? '' : 'scenes',
        subBuilder: Scene.$_createMessage)
    ..pPM<CtaBlock>(7, _omitFieldNames ? '' : 'ctaBlocks',
        subBuilder: CtaBlock.$_createMessage)
    ..pPM<DisclosureBlock>(8, _omitFieldNames ? '' : 'disclosureBlocks',
        subBuilder: DisclosureBlock.$_createMessage)
    ..aI(9, _omitFieldNames ? '' : 'durationTargetSeconds')
    ..aE<ScriptLifecycleState>(10, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: ScriptLifecycleState.values)
    ..aE<ScriptApprovalState>(11, _omitFieldNames ? '' : 'approvalState',
        enumValues: ScriptApprovalState.values)
    ..aOS(12, _omitFieldNames ? '' : 'snapshotReason')
    ..aOS(13, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptVersion copyWith(void Function(ScriptVersion) updates) =>
      super.copyWith((message) => updates(message as ScriptVersion))
          as ScriptVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ScriptVersion() / ScriptVersion.new instead')
  static ScriptVersion create() => ScriptVersion._();
  static $pb.GeneratedMessage $_createMessage() => ScriptVersion._();
  @$core.override
  ScriptVersion createEmptyInstance() => ScriptVersion._();
  @$core.pragma('dart2js:noInline')
  static ScriptVersion getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScriptVersion>(
          ScriptVersion.$_createMessage);
  static ScriptVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get versionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set versionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scriptId => $_getSZ(2);
  @$pb.TagNumber(3)
  set scriptId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScriptId() => $_has(2);
  @$pb.TagNumber(3)
  void clearScriptId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get versionIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set versionIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersionIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersionIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<Scene> get scenes => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<CtaBlock> get ctaBlocks => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<DisclosureBlock> get disclosureBlocks => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get durationTargetSeconds => $_getIZ(8);
  @$pb.TagNumber(9)
  set durationTargetSeconds($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDurationTargetSeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearDurationTargetSeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  ScriptLifecycleState get lifecycleState => $_getN(9);
  @$pb.TagNumber(10)
  set lifecycleState(ScriptLifecycleState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLifecycleState() => $_has(9);
  @$pb.TagNumber(10)
  void clearLifecycleState() => $_clearField(10);

  @$pb.TagNumber(11)
  ScriptApprovalState get approvalState => $_getN(10);
  @$pb.TagNumber(11)
  set approvalState(ScriptApprovalState value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasApprovalState() => $_has(10);
  @$pb.TagNumber(11)
  void clearApprovalState() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get snapshotReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set snapshotReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSnapshotReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearSnapshotReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get createdBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set createdBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedBy() => $_clearField(13);

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

/// ScriptReviewComment represents inline collaborator/reviewer feedback.
class ScriptReviewComment extends $pb.GeneratedMessage {
  factory ScriptReviewComment({
    $core.String? commentId,
    $core.String? scriptId,
    $core.String? userId,
    $core.String? authorName,
    $core.String? content,
    $core.int? sceneIndex,
    $core.bool? isResolved,
    $1.Timestamp? createdAt,
  }) {
    final result = ScriptReviewComment._();
    if (commentId != null) result.commentId = commentId;
    if (scriptId != null) result.scriptId = scriptId;
    if (userId != null) result.userId = userId;
    if (authorName != null) result.authorName = authorName;
    if (content != null) result.content = content;
    if (sceneIndex != null) result.sceneIndex = sceneIndex;
    if (isResolved != null) result.isResolved = isResolved;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ScriptReviewComment._();

  factory ScriptReviewComment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptReviewComment()..mergeFromBuffer(data, registry);
  factory ScriptReviewComment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptReviewComment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptReviewComment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptReviewComment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'commentId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'authorName')
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..aI(6, _omitFieldNames ? '' : 'sceneIndex')
    ..aOB(7, _omitFieldNames ? '' : 'isResolved')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptReviewComment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptReviewComment copyWith(void Function(ScriptReviewComment) updates) =>
      super.copyWith((message) => updates(message as ScriptReviewComment))
          as ScriptReviewComment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ScriptReviewComment() / ScriptReviewComment.new instead')
  static ScriptReviewComment create() => ScriptReviewComment._();
  static $pb.GeneratedMessage $_createMessage() => ScriptReviewComment._();
  @$core.override
  ScriptReviewComment createEmptyInstance() => ScriptReviewComment._();
  @$core.pragma('dart2js:noInline')
  static ScriptReviewComment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptReviewComment>(
          ScriptReviewComment.$_createMessage);
  static ScriptReviewComment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set commentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get authorName => $_getSZ(3);
  @$pb.TagNumber(4)
  set authorName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthorName() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get sceneIndex => $_getIZ(5);
  @$pb.TagNumber(6)
  set sceneIndex($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSceneIndex() => $_has(5);
  @$pb.TagNumber(6)
  void clearSceneIndex() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isResolved => $_getBF(6);
  @$pb.TagNumber(7)
  set isResolved($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsResolved() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsResolved() => $_clearField(7);

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
}

/// Script represents the central structured authoring and approval object (M06) per database_schema.md §6.4.
class Script extends $pb.GeneratedMessage {
  factory Script({
    $core.String? scriptId,
    $core.String? workspaceId,
    $core.String? ideaId,
    $core.String? sourceIdeaTitle,
    $core.String? title,
    $core.String? formatType,
    $core.Iterable<Scene>? scenes,
    $core.Iterable<CtaBlock>? ctaBlocks,
    $core.Iterable<DisclosureBlock>? disclosureBlocks,
    $core.int? durationTargetSeconds,
    ScriptLifecycleState? lifecycleState,
    ScriptApprovalState? approvalState,
    $core.Iterable<PublishTargetProfile>? publishTargetProfiles,
    $core.Iterable<$core.String>? continuityRefs,
    $core.Iterable<$core.String>? offerProductHooks,
    $core.String? rejectionReason,
    $core.int? versionIndex,
    $core.String? createdBy,
    $core.String? approvedBy,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Script._();
    if (scriptId != null) result.scriptId = scriptId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaId != null) result.ideaId = ideaId;
    if (sourceIdeaTitle != null) result.sourceIdeaTitle = sourceIdeaTitle;
    if (title != null) result.title = title;
    if (formatType != null) result.formatType = formatType;
    if (scenes != null) result.scenes.addAll(scenes);
    if (ctaBlocks != null) result.ctaBlocks.addAll(ctaBlocks);
    if (disclosureBlocks != null)
      result.disclosureBlocks.addAll(disclosureBlocks);
    if (durationTargetSeconds != null)
      result.durationTargetSeconds = durationTargetSeconds;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (approvalState != null) result.approvalState = approvalState;
    if (publishTargetProfiles != null)
      result.publishTargetProfiles.addAll(publishTargetProfiles);
    if (continuityRefs != null) result.continuityRefs.addAll(continuityRefs);
    if (offerProductHooks != null)
      result.offerProductHooks.addAll(offerProductHooks);
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    if (versionIndex != null) result.versionIndex = versionIndex;
    if (createdBy != null) result.createdBy = createdBy;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Script._();

  factory Script.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Script()..mergeFromBuffer(data, registry);
  factory Script.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Script()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Script',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: Script.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'scriptId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'ideaId')
    ..aOS(4, _omitFieldNames ? '' : 'sourceIdeaTitle')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'formatType')
    ..pPM<Scene>(7, _omitFieldNames ? '' : 'scenes',
        subBuilder: Scene.$_createMessage)
    ..pPM<CtaBlock>(8, _omitFieldNames ? '' : 'ctaBlocks',
        subBuilder: CtaBlock.$_createMessage)
    ..pPM<DisclosureBlock>(9, _omitFieldNames ? '' : 'disclosureBlocks',
        subBuilder: DisclosureBlock.$_createMessage)
    ..aI(10, _omitFieldNames ? '' : 'durationTargetSeconds')
    ..aE<ScriptLifecycleState>(11, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: ScriptLifecycleState.values)
    ..aE<ScriptApprovalState>(12, _omitFieldNames ? '' : 'approvalState',
        enumValues: ScriptApprovalState.values)
    ..pPM<PublishTargetProfile>(
        13, _omitFieldNames ? '' : 'publishTargetProfiles',
        subBuilder: PublishTargetProfile.$_createMessage)
    ..pPS(14, _omitFieldNames ? '' : 'continuityRefs')
    ..pPS(15, _omitFieldNames ? '' : 'offerProductHooks')
    ..aOS(16, _omitFieldNames ? '' : 'rejectionReason')
    ..aI(17, _omitFieldNames ? '' : 'versionIndex')
    ..aOS(18, _omitFieldNames ? '' : 'createdBy')
    ..aOS(19, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$1.Timestamp>(20, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(21, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Script clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Script copyWith(void Function(Script) updates) =>
      super.copyWith((message) => updates(message as Script)) as Script;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Script() / Script.new instead')
  static Script create() => Script._();
  static $pb.GeneratedMessage $_createMessage() => Script._();
  @$core.override
  Script createEmptyInstance() => Script._();
  @$core.pragma('dart2js:noInline')
  static Script getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Script>(Script.$_createMessage);
  static Script? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scriptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set scriptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScriptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearScriptId() => $_clearField(1);

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
  $core.String get sourceIdeaTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceIdeaTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceIdeaTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceIdeaTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get formatType => $_getSZ(5);
  @$pb.TagNumber(6)
  set formatType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFormatType() => $_has(5);
  @$pb.TagNumber(6)
  void clearFormatType() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<Scene> get scenes => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<CtaBlock> get ctaBlocks => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<DisclosureBlock> get disclosureBlocks => $_getList(8);

  @$pb.TagNumber(10)
  $core.int get durationTargetSeconds => $_getIZ(9);
  @$pb.TagNumber(10)
  set durationTargetSeconds($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDurationTargetSeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearDurationTargetSeconds() => $_clearField(10);

  @$pb.TagNumber(11)
  ScriptLifecycleState get lifecycleState => $_getN(10);
  @$pb.TagNumber(11)
  set lifecycleState(ScriptLifecycleState value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLifecycleState() => $_has(10);
  @$pb.TagNumber(11)
  void clearLifecycleState() => $_clearField(11);

  @$pb.TagNumber(12)
  ScriptApprovalState get approvalState => $_getN(11);
  @$pb.TagNumber(12)
  set approvalState(ScriptApprovalState value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasApprovalState() => $_has(11);
  @$pb.TagNumber(12)
  void clearApprovalState() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<PublishTargetProfile> get publishTargetProfiles => $_getList(12);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get continuityRefs => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<$core.String> get offerProductHooks => $_getList(14);

  @$pb.TagNumber(16)
  $core.String get rejectionReason => $_getSZ(15);
  @$pb.TagNumber(16)
  set rejectionReason($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRejectionReason() => $_has(15);
  @$pb.TagNumber(16)
  void clearRejectionReason() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get versionIndex => $_getIZ(16);
  @$pb.TagNumber(17)
  set versionIndex($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasVersionIndex() => $_has(16);
  @$pb.TagNumber(17)
  void clearVersionIndex() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get createdBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set createdBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get approvedBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set approvedBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasApprovedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearApprovedBy() => $_clearField(19);

  @$pb.TagNumber(20)
  $1.Timestamp get createdAt => $_getN(19);
  @$pb.TagNumber(20)
  set createdAt($1.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $1.Timestamp ensureCreatedAt() => $_ensure(19);

  @$pb.TagNumber(21)
  $1.Timestamp get updatedAt => $_getN(20);
  @$pb.TagNumber(21)
  set updatedAt($1.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasUpdatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearUpdatedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $1.Timestamp ensureUpdatedAt() => $_ensure(20);
}

class ScriptServiceCreateRequest extends $pb.GeneratedMessage {
  factory ScriptServiceCreateRequest({
    $core.String? workspaceId,
    $core.String? ideaId,
    $core.String? title,
    $core.String? formatType,
    $core.Iterable<Scene>? scenes,
    $core.Iterable<CtaBlock>? ctaBlocks,
    $core.Iterable<DisclosureBlock>? disclosureBlocks,
    $core.int? durationTargetSeconds,
    $core.Iterable<PublishTargetProfile>? publishTargetProfiles,
    $core.Iterable<$core.String>? continuityRefs,
    $core.Iterable<$core.String>? offerProductHooks,
  }) {
    final result = ScriptServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaId != null) result.ideaId = ideaId;
    if (title != null) result.title = title;
    if (formatType != null) result.formatType = formatType;
    if (scenes != null) result.scenes.addAll(scenes);
    if (ctaBlocks != null) result.ctaBlocks.addAll(ctaBlocks);
    if (disclosureBlocks != null)
      result.disclosureBlocks.addAll(disclosureBlocks);
    if (durationTargetSeconds != null)
      result.durationTargetSeconds = durationTargetSeconds;
    if (publishTargetProfiles != null)
      result.publishTargetProfiles.addAll(publishTargetProfiles);
    if (continuityRefs != null) result.continuityRefs.addAll(continuityRefs);
    if (offerProductHooks != null)
      result.offerProductHooks.addAll(offerProductHooks);
    return result;
  }

  ScriptServiceCreateRequest._();

  factory ScriptServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ideaId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'formatType')
    ..pPM<Scene>(5, _omitFieldNames ? '' : 'scenes',
        subBuilder: Scene.$_createMessage)
    ..pPM<CtaBlock>(6, _omitFieldNames ? '' : 'ctaBlocks',
        subBuilder: CtaBlock.$_createMessage)
    ..pPM<DisclosureBlock>(7, _omitFieldNames ? '' : 'disclosureBlocks',
        subBuilder: DisclosureBlock.$_createMessage)
    ..aI(8, _omitFieldNames ? '' : 'durationTargetSeconds')
    ..pPM<PublishTargetProfile>(
        9, _omitFieldNames ? '' : 'publishTargetProfiles',
        subBuilder: PublishTargetProfile.$_createMessage)
    ..pPS(10, _omitFieldNames ? '' : 'continuityRefs')
    ..pPS(11, _omitFieldNames ? '' : 'offerProductHooks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceCreateRequest copyWith(
          void Function(ScriptServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceCreateRequest))
          as ScriptServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceCreateRequest() / ScriptServiceCreateRequest.new instead')
  static ScriptServiceCreateRequest create() => ScriptServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceCreateRequest._();
  @$core.override
  ScriptServiceCreateRequest createEmptyInstance() =>
      ScriptServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceCreateRequest>(
          ScriptServiceCreateRequest.$_createMessage);
  static ScriptServiceCreateRequest? _defaultInstance;

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
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get formatType => $_getSZ(3);
  @$pb.TagNumber(4)
  set formatType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormatType() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormatType() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<Scene> get scenes => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<CtaBlock> get ctaBlocks => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<DisclosureBlock> get disclosureBlocks => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get durationTargetSeconds => $_getIZ(7);
  @$pb.TagNumber(8)
  set durationTargetSeconds($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationTargetSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationTargetSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<PublishTargetProfile> get publishTargetProfiles => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get continuityRefs => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get offerProductHooks => $_getList(10);
}

class ScriptServiceCreateResponse extends $pb.GeneratedMessage {
  factory ScriptServiceCreateResponse({
    Script? script,
    $core.bool? disclosureRecommended,
    $core.String? disclosureSuggestionText,
  }) {
    final result = ScriptServiceCreateResponse._();
    if (script != null) result.script = script;
    if (disclosureRecommended != null)
      result.disclosureRecommended = disclosureRecommended;
    if (disclosureSuggestionText != null)
      result.disclosureSuggestionText = disclosureSuggestionText;
    return result;
  }

  ScriptServiceCreateResponse._();

  factory ScriptServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceCreateResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'disclosureRecommended')
    ..aOS(3, _omitFieldNames ? '' : 'disclosureSuggestionText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceCreateResponse copyWith(
          void Function(ScriptServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceCreateResponse))
          as ScriptServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceCreateResponse() / ScriptServiceCreateResponse.new instead')
  static ScriptServiceCreateResponse create() =>
      ScriptServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceCreateResponse._();
  @$core.override
  ScriptServiceCreateResponse createEmptyInstance() =>
      ScriptServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceCreateResponse>(
          ScriptServiceCreateResponse.$_createMessage);
  static ScriptServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get disclosureRecommended => $_getBF(1);
  @$pb.TagNumber(2)
  set disclosureRecommended($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisclosureRecommended() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisclosureRecommended() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get disclosureSuggestionText => $_getSZ(2);
  @$pb.TagNumber(3)
  set disclosureSuggestionText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisclosureSuggestionText() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisclosureSuggestionText() => $_clearField(3);
}

class ScriptServiceGetRequest extends $pb.GeneratedMessage {
  factory ScriptServiceGetRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
  }) {
    final result = ScriptServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    return result;
  }

  ScriptServiceGetRequest._();

  factory ScriptServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetRequest copyWith(
          void Function(ScriptServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as ScriptServiceGetRequest))
          as ScriptServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetRequest() / ScriptServiceGetRequest.new instead')
  static ScriptServiceGetRequest create() => ScriptServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => ScriptServiceGetRequest._();
  @$core.override
  ScriptServiceGetRequest createEmptyInstance() => ScriptServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetRequest>(
          ScriptServiceGetRequest.$_createMessage);
  static ScriptServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);
}

class ScriptServiceGetResponse extends $pb.GeneratedMessage {
  factory ScriptServiceGetResponse({
    Script? script,
    AssetBrief? assetBrief,
  }) {
    final result = ScriptServiceGetResponse._();
    if (script != null) result.script = script;
    if (assetBrief != null) result.assetBrief = assetBrief;
    return result;
  }

  ScriptServiceGetResponse._();

  factory ScriptServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..aOM<AssetBrief>(2, _omitFieldNames ? '' : 'assetBrief',
        subBuilder: AssetBrief.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetResponse copyWith(
          void Function(ScriptServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as ScriptServiceGetResponse))
          as ScriptServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetResponse() / ScriptServiceGetResponse.new instead')
  static ScriptServiceGetResponse create() => ScriptServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => ScriptServiceGetResponse._();
  @$core.override
  ScriptServiceGetResponse createEmptyInstance() =>
      ScriptServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetResponse>(
          ScriptServiceGetResponse.$_createMessage);
  static ScriptServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);

  @$pb.TagNumber(2)
  AssetBrief get assetBrief => $_getN(1);
  @$pb.TagNumber(2)
  set assetBrief(AssetBrief value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetBrief() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetBrief() => $_clearField(2);
  @$pb.TagNumber(2)
  AssetBrief ensureAssetBrief() => $_ensure(1);
}

class ScriptServiceUpdateRequest extends $pb.GeneratedMessage {
  factory ScriptServiceUpdateRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? title,
    $core.String? formatType,
    $core.Iterable<Scene>? scenes,
    $core.Iterable<CtaBlock>? ctaBlocks,
    $core.Iterable<DisclosureBlock>? disclosureBlocks,
    $core.int? durationTargetSeconds,
    $core.Iterable<PublishTargetProfile>? publishTargetProfiles,
    $core.Iterable<$core.String>? continuityRefs,
    $core.Iterable<$core.String>? offerProductHooks,
    $core.int? expectedVersion,
  }) {
    final result = ScriptServiceUpdateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (title != null) result.title = title;
    if (formatType != null) result.formatType = formatType;
    if (scenes != null) result.scenes.addAll(scenes);
    if (ctaBlocks != null) result.ctaBlocks.addAll(ctaBlocks);
    if (disclosureBlocks != null)
      result.disclosureBlocks.addAll(disclosureBlocks);
    if (durationTargetSeconds != null)
      result.durationTargetSeconds = durationTargetSeconds;
    if (publishTargetProfiles != null)
      result.publishTargetProfiles.addAll(publishTargetProfiles);
    if (continuityRefs != null) result.continuityRefs.addAll(continuityRefs);
    if (offerProductHooks != null)
      result.offerProductHooks.addAll(offerProductHooks);
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  ScriptServiceUpdateRequest._();

  factory ScriptServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'formatType')
    ..pPM<Scene>(5, _omitFieldNames ? '' : 'scenes',
        subBuilder: Scene.$_createMessage)
    ..pPM<CtaBlock>(6, _omitFieldNames ? '' : 'ctaBlocks',
        subBuilder: CtaBlock.$_createMessage)
    ..pPM<DisclosureBlock>(7, _omitFieldNames ? '' : 'disclosureBlocks',
        subBuilder: DisclosureBlock.$_createMessage)
    ..aI(8, _omitFieldNames ? '' : 'durationTargetSeconds')
    ..pPM<PublishTargetProfile>(
        9, _omitFieldNames ? '' : 'publishTargetProfiles',
        subBuilder: PublishTargetProfile.$_createMessage)
    ..pPS(10, _omitFieldNames ? '' : 'continuityRefs')
    ..pPS(11, _omitFieldNames ? '' : 'offerProductHooks')
    ..aI(12, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceUpdateRequest copyWith(
          void Function(ScriptServiceUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceUpdateRequest))
          as ScriptServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceUpdateRequest() / ScriptServiceUpdateRequest.new instead')
  static ScriptServiceUpdateRequest create() => ScriptServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceUpdateRequest._();
  @$core.override
  ScriptServiceUpdateRequest createEmptyInstance() =>
      ScriptServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceUpdateRequest>(
          ScriptServiceUpdateRequest.$_createMessage);
  static ScriptServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get formatType => $_getSZ(3);
  @$pb.TagNumber(4)
  set formatType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormatType() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormatType() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<Scene> get scenes => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<CtaBlock> get ctaBlocks => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<DisclosureBlock> get disclosureBlocks => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get durationTargetSeconds => $_getIZ(7);
  @$pb.TagNumber(8)
  set durationTargetSeconds($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationTargetSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationTargetSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<PublishTargetProfile> get publishTargetProfiles => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get continuityRefs => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get offerProductHooks => $_getList(10);

  @$pb.TagNumber(12)
  $core.int get expectedVersion => $_getIZ(11);
  @$pb.TagNumber(12)
  set expectedVersion($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasExpectedVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearExpectedVersion() => $_clearField(12);
}

class ScriptServiceUpdateResponse extends $pb.GeneratedMessage {
  factory ScriptServiceUpdateResponse({
    Script? script,
  }) {
    final result = ScriptServiceUpdateResponse._();
    if (script != null) result.script = script;
    return result;
  }

  ScriptServiceUpdateResponse._();

  factory ScriptServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceUpdateResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceUpdateResponse copyWith(
          void Function(ScriptServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceUpdateResponse))
          as ScriptServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceUpdateResponse() / ScriptServiceUpdateResponse.new instead')
  static ScriptServiceUpdateResponse create() =>
      ScriptServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceUpdateResponse._();
  @$core.override
  ScriptServiceUpdateResponse createEmptyInstance() =>
      ScriptServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceUpdateResponse>(
          ScriptServiceUpdateResponse.$_createMessage);
  static ScriptServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);
}

class ScriptServiceSubmitApprovalRequest extends $pb.GeneratedMessage {
  factory ScriptServiceSubmitApprovalRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.int? expectedVersion,
    $core.String? reviewerId,
  }) {
    final result = ScriptServiceSubmitApprovalRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    if (reviewerId != null) result.reviewerId = reviewerId;
    return result;
  }

  ScriptServiceSubmitApprovalRequest._();

  factory ScriptServiceSubmitApprovalRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceSubmitApprovalRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceSubmitApprovalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceSubmitApprovalRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceSubmitApprovalRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceSubmitApprovalRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aI(3, _omitFieldNames ? '' : 'expectedVersion')
    ..aOS(4, _omitFieldNames ? '' : 'reviewerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceSubmitApprovalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceSubmitApprovalRequest copyWith(
          void Function(ScriptServiceSubmitApprovalRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceSubmitApprovalRequest))
          as ScriptServiceSubmitApprovalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceSubmitApprovalRequest() / ScriptServiceSubmitApprovalRequest.new instead')
  static ScriptServiceSubmitApprovalRequest create() =>
      ScriptServiceSubmitApprovalRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceSubmitApprovalRequest._();
  @$core.override
  ScriptServiceSubmitApprovalRequest createEmptyInstance() =>
      ScriptServiceSubmitApprovalRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceSubmitApprovalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceSubmitApprovalRequest>(
          ScriptServiceSubmitApprovalRequest.$_createMessage);
  static ScriptServiceSubmitApprovalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get expectedVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set expectedVersion($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reviewerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set reviewerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReviewerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReviewerId() => $_clearField(4);
}

class ScriptServiceSubmitApprovalResponse extends $pb.GeneratedMessage {
  factory ScriptServiceSubmitApprovalResponse({
    Script? script,
    $core.String? approvalRequestId,
  }) {
    final result = ScriptServiceSubmitApprovalResponse._();
    if (script != null) result.script = script;
    if (approvalRequestId != null) result.approvalRequestId = approvalRequestId;
    return result;
  }

  ScriptServiceSubmitApprovalResponse._();

  factory ScriptServiceSubmitApprovalResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceSubmitApprovalResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceSubmitApprovalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceSubmitApprovalResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceSubmitApprovalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceSubmitApprovalResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'approvalRequestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceSubmitApprovalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceSubmitApprovalResponse copyWith(
          void Function(ScriptServiceSubmitApprovalResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceSubmitApprovalResponse))
          as ScriptServiceSubmitApprovalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceSubmitApprovalResponse() / ScriptServiceSubmitApprovalResponse.new instead')
  static ScriptServiceSubmitApprovalResponse create() =>
      ScriptServiceSubmitApprovalResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceSubmitApprovalResponse._();
  @$core.override
  ScriptServiceSubmitApprovalResponse createEmptyInstance() =>
      ScriptServiceSubmitApprovalResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceSubmitApprovalResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ScriptServiceSubmitApprovalResponse>(
          ScriptServiceSubmitApprovalResponse.$_createMessage);
  static ScriptServiceSubmitApprovalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get approvalRequestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set approvalRequestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApprovalRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprovalRequestId() => $_clearField(2);
}

class ScriptServiceApproveRequest extends $pb.GeneratedMessage {
  factory ScriptServiceApproveRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.int? expectedVersion,
    $1.Timestamp? reviewerSnapshotTime,
  }) {
    final result = ScriptServiceApproveRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    if (reviewerSnapshotTime != null)
      result.reviewerSnapshotTime = reviewerSnapshotTime;
    return result;
  }

  ScriptServiceApproveRequest._();

  factory ScriptServiceApproveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceApproveRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceApproveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceApproveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceApproveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceApproveRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aI(3, _omitFieldNames ? '' : 'expectedVersion')
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'reviewerSnapshotTime',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceApproveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceApproveRequest copyWith(
          void Function(ScriptServiceApproveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceApproveRequest))
          as ScriptServiceApproveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceApproveRequest() / ScriptServiceApproveRequest.new instead')
  static ScriptServiceApproveRequest create() =>
      ScriptServiceApproveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceApproveRequest._();
  @$core.override
  ScriptServiceApproveRequest createEmptyInstance() =>
      ScriptServiceApproveRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceApproveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceApproveRequest>(
          ScriptServiceApproveRequest.$_createMessage);
  static ScriptServiceApproveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get expectedVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set expectedVersion($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get reviewerSnapshotTime => $_getN(3);
  @$pb.TagNumber(4)
  set reviewerSnapshotTime($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReviewerSnapshotTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearReviewerSnapshotTime() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureReviewerSnapshotTime() => $_ensure(3);
}

class ScriptServiceApproveResponse extends $pb.GeneratedMessage {
  factory ScriptServiceApproveResponse({
    Script? script,
    $1.Timestamp? approvedAt,
  }) {
    final result = ScriptServiceApproveResponse._();
    if (script != null) result.script = script;
    if (approvedAt != null) result.approvedAt = approvedAt;
    return result;
  }

  ScriptServiceApproveResponse._();

  factory ScriptServiceApproveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceApproveResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceApproveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceApproveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceApproveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceApproveResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceApproveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceApproveResponse copyWith(
          void Function(ScriptServiceApproveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceApproveResponse))
          as ScriptServiceApproveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceApproveResponse() / ScriptServiceApproveResponse.new instead')
  static ScriptServiceApproveResponse create() =>
      ScriptServiceApproveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceApproveResponse._();
  @$core.override
  ScriptServiceApproveResponse createEmptyInstance() =>
      ScriptServiceApproveResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceApproveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceApproveResponse>(
          ScriptServiceApproveResponse.$_createMessage);
  static ScriptServiceApproveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Timestamp get approvedAt => $_getN(1);
  @$pb.TagNumber(2)
  set approvedAt($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasApprovedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprovedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureApprovedAt() => $_ensure(1);
}

class ScriptServiceRejectRequest extends $pb.GeneratedMessage {
  factory ScriptServiceRejectRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? rejectionReason,
    $core.int? expectedVersion,
    $1.Timestamp? reviewerSnapshotTime,
  }) {
    final result = ScriptServiceRejectRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    if (reviewerSnapshotTime != null)
      result.reviewerSnapshotTime = reviewerSnapshotTime;
    return result;
  }

  ScriptServiceRejectRequest._();

  factory ScriptServiceRejectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRejectRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceRejectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRejectRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceRejectRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceRejectRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'rejectionReason')
    ..aI(4, _omitFieldNames ? '' : 'expectedVersion')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'reviewerSnapshotTime',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRejectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRejectRequest copyWith(
          void Function(ScriptServiceRejectRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceRejectRequest))
          as ScriptServiceRejectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceRejectRequest() / ScriptServiceRejectRequest.new instead')
  static ScriptServiceRejectRequest create() => ScriptServiceRejectRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceRejectRequest._();
  @$core.override
  ScriptServiceRejectRequest createEmptyInstance() =>
      ScriptServiceRejectRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceRejectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceRejectRequest>(
          ScriptServiceRejectRequest.$_createMessage);
  static ScriptServiceRejectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rejectionReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set rejectionReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRejectionReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearRejectionReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get expectedVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set expectedVersion($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get reviewerSnapshotTime => $_getN(4);
  @$pb.TagNumber(5)
  set reviewerSnapshotTime($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReviewerSnapshotTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearReviewerSnapshotTime() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureReviewerSnapshotTime() => $_ensure(4);
}

class ScriptServiceRejectResponse extends $pb.GeneratedMessage {
  factory ScriptServiceRejectResponse({
    Script? script,
  }) {
    final result = ScriptServiceRejectResponse._();
    if (script != null) result.script = script;
    return result;
  }

  ScriptServiceRejectResponse._();

  factory ScriptServiceRejectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRejectResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceRejectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRejectResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceRejectResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceRejectResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRejectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRejectResponse copyWith(
          void Function(ScriptServiceRejectResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceRejectResponse))
          as ScriptServiceRejectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceRejectResponse() / ScriptServiceRejectResponse.new instead')
  static ScriptServiceRejectResponse create() =>
      ScriptServiceRejectResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceRejectResponse._();
  @$core.override
  ScriptServiceRejectResponse createEmptyInstance() =>
      ScriptServiceRejectResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceRejectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceRejectResponse>(
          ScriptServiceRejectResponse.$_createMessage);
  static ScriptServiceRejectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);
}

class ScriptServiceListRequest extends $pb.GeneratedMessage {
  factory ScriptServiceListRequest({
    $core.String? workspaceId,
    ScriptLifecycleState? lifecycleState,
    ScriptApprovalState? approvalState,
    $core.String? ideaId,
    $core.int? limit,
    $core.String? pageToken,
  }) {
    final result = ScriptServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (approvalState != null) result.approvalState = approvalState;
    if (ideaId != null) result.ideaId = ideaId;
    if (limit != null) result.limit = limit;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  ScriptServiceListRequest._();

  factory ScriptServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceListRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<ScriptLifecycleState>(2, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: ScriptLifecycleState.values)
    ..aE<ScriptApprovalState>(3, _omitFieldNames ? '' : 'approvalState',
        enumValues: ScriptApprovalState.values)
    ..aOS(4, _omitFieldNames ? '' : 'ideaId')
    ..aI(5, _omitFieldNames ? '' : 'limit')
    ..aOS(6, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceListRequest copyWith(
          void Function(ScriptServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as ScriptServiceListRequest))
          as ScriptServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceListRequest() / ScriptServiceListRequest.new instead')
  static ScriptServiceListRequest create() => ScriptServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => ScriptServiceListRequest._();
  @$core.override
  ScriptServiceListRequest createEmptyInstance() =>
      ScriptServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceListRequest>(
          ScriptServiceListRequest.$_createMessage);
  static ScriptServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  ScriptLifecycleState get lifecycleState => $_getN(1);
  @$pb.TagNumber(2)
  set lifecycleState(ScriptLifecycleState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLifecycleState() => $_has(1);
  @$pb.TagNumber(2)
  void clearLifecycleState() => $_clearField(2);

  @$pb.TagNumber(3)
  ScriptApprovalState get approvalState => $_getN(2);
  @$pb.TagNumber(3)
  set approvalState(ScriptApprovalState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasApprovalState() => $_has(2);
  @$pb.TagNumber(3)
  void clearApprovalState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ideaId => $_getSZ(3);
  @$pb.TagNumber(4)
  set ideaId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdeaId() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdeaId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get limit => $_getIZ(4);
  @$pb.TagNumber(5)
  set limit($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLimit() => $_has(4);
  @$pb.TagNumber(5)
  void clearLimit() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pageToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set pageToken($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageToken() => $_clearField(6);
}

class ScriptServiceListResponse extends $pb.GeneratedMessage {
  factory ScriptServiceListResponse({
    $core.Iterable<Script>? scripts,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = ScriptServiceListResponse._();
    if (scripts != null) result.scripts.addAll(scripts);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  ScriptServiceListResponse._();

  factory ScriptServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceListResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceListResponse.$_createMessage)
    ..pPM<Script>(1, _omitFieldNames ? '' : 'scripts',
        subBuilder: Script.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceListResponse copyWith(
          void Function(ScriptServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as ScriptServiceListResponse))
          as ScriptServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceListResponse() / ScriptServiceListResponse.new instead')
  static ScriptServiceListResponse create() => ScriptServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceListResponse._();
  @$core.override
  ScriptServiceListResponse createEmptyInstance() =>
      ScriptServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceListResponse>(
          ScriptServiceListResponse.$_createMessage);
  static ScriptServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Script> get scripts => $_getList(0);

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

class ScriptServiceDeleteRequest extends $pb.GeneratedMessage {
  factory ScriptServiceDeleteRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
  }) {
    final result = ScriptServiceDeleteRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    return result;
  }

  ScriptServiceDeleteRequest._();

  factory ScriptServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceDeleteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDeleteRequest copyWith(
          void Function(ScriptServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceDeleteRequest))
          as ScriptServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceDeleteRequest() / ScriptServiceDeleteRequest.new instead')
  static ScriptServiceDeleteRequest create() => ScriptServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceDeleteRequest._();
  @$core.override
  ScriptServiceDeleteRequest createEmptyInstance() =>
      ScriptServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceDeleteRequest>(
          ScriptServiceDeleteRequest.$_createMessage);
  static ScriptServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);
}

class ScriptServiceDeleteResponse extends $pb.GeneratedMessage {
  factory ScriptServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = ScriptServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  ScriptServiceDeleteResponse._();

  factory ScriptServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDeleteResponse copyWith(
          void Function(ScriptServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceDeleteResponse))
          as ScriptServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceDeleteResponse() / ScriptServiceDeleteResponse.new instead')
  static ScriptServiceDeleteResponse create() =>
      ScriptServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceDeleteResponse._();
  @$core.override
  ScriptServiceDeleteResponse createEmptyInstance() =>
      ScriptServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceDeleteResponse>(
          ScriptServiceDeleteResponse.$_createMessage);
  static ScriptServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ScriptServiceDuplicateRequest extends $pb.GeneratedMessage {
  factory ScriptServiceDuplicateRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? targetPlatform,
    $core.String? newFormatType,
    $core.int? adjustedDurationSeconds,
    $core.String? newTitle,
  }) {
    final result = ScriptServiceDuplicateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (targetPlatform != null) result.targetPlatform = targetPlatform;
    if (newFormatType != null) result.newFormatType = newFormatType;
    if (adjustedDurationSeconds != null)
      result.adjustedDurationSeconds = adjustedDurationSeconds;
    if (newTitle != null) result.newTitle = newTitle;
    return result;
  }

  ScriptServiceDuplicateRequest._();

  factory ScriptServiceDuplicateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDuplicateRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceDuplicateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDuplicateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceDuplicateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceDuplicateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'targetPlatform')
    ..aOS(4, _omitFieldNames ? '' : 'newFormatType')
    ..aI(5, _omitFieldNames ? '' : 'adjustedDurationSeconds')
    ..aOS(6, _omitFieldNames ? '' : 'newTitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDuplicateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDuplicateRequest copyWith(
          void Function(ScriptServiceDuplicateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceDuplicateRequest))
          as ScriptServiceDuplicateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceDuplicateRequest() / ScriptServiceDuplicateRequest.new instead')
  static ScriptServiceDuplicateRequest create() =>
      ScriptServiceDuplicateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceDuplicateRequest._();
  @$core.override
  ScriptServiceDuplicateRequest createEmptyInstance() =>
      ScriptServiceDuplicateRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceDuplicateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceDuplicateRequest>(
          ScriptServiceDuplicateRequest.$_createMessage);
  static ScriptServiceDuplicateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetPlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetPlatform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get newFormatType => $_getSZ(3);
  @$pb.TagNumber(4)
  set newFormatType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewFormatType() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewFormatType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get adjustedDurationSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set adjustedDurationSeconds($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAdjustedDurationSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdjustedDurationSeconds() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get newTitle => $_getSZ(5);
  @$pb.TagNumber(6)
  set newTitle($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNewTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearNewTitle() => $_clearField(6);
}

class ScriptServiceDuplicateResponse extends $pb.GeneratedMessage {
  factory ScriptServiceDuplicateResponse({
    Script? duplicatedScript,
  }) {
    final result = ScriptServiceDuplicateResponse._();
    if (duplicatedScript != null) result.duplicatedScript = duplicatedScript;
    return result;
  }

  ScriptServiceDuplicateResponse._();

  factory ScriptServiceDuplicateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDuplicateResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceDuplicateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDuplicateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceDuplicateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceDuplicateResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'duplicatedScript',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDuplicateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDuplicateResponse copyWith(
          void Function(ScriptServiceDuplicateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceDuplicateResponse))
          as ScriptServiceDuplicateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceDuplicateResponse() / ScriptServiceDuplicateResponse.new instead')
  static ScriptServiceDuplicateResponse create() =>
      ScriptServiceDuplicateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceDuplicateResponse._();
  @$core.override
  ScriptServiceDuplicateResponse createEmptyInstance() =>
      ScriptServiceDuplicateResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceDuplicateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceDuplicateResponse>(
          ScriptServiceDuplicateResponse.$_createMessage);
  static ScriptServiceDuplicateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get duplicatedScript => $_getN(0);
  @$pb.TagNumber(1)
  set duplicatedScript(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDuplicatedScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearDuplicatedScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureDuplicatedScript() => $_ensure(0);
}

class ScriptServiceGetStatsRequest extends $pb.GeneratedMessage {
  factory ScriptServiceGetStatsRequest({
    $core.String? workspaceId,
  }) {
    final result = ScriptServiceGetStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  ScriptServiceGetStatsRequest._();

  factory ScriptServiceGetStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetStatsRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetStatsRequest copyWith(
          void Function(ScriptServiceGetStatsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceGetStatsRequest))
          as ScriptServiceGetStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetStatsRequest() / ScriptServiceGetStatsRequest.new instead')
  static ScriptServiceGetStatsRequest create() =>
      ScriptServiceGetStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceGetStatsRequest._();
  @$core.override
  ScriptServiceGetStatsRequest createEmptyInstance() =>
      ScriptServiceGetStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetStatsRequest>(
          ScriptServiceGetStatsRequest.$_createMessage);
  static ScriptServiceGetStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class ScriptServiceGetStatsResponse extends $pb.GeneratedMessage {
  factory ScriptServiceGetStatsResponse({
    $core.int? totalScripts,
    $core.int? draftCount,
    $core.int? pendingApprovalCount,
    $core.int? approvedCount,
    $core.int? readyForProductionCount,
    $core.int? archivedCount,
  }) {
    final result = ScriptServiceGetStatsResponse._();
    if (totalScripts != null) result.totalScripts = totalScripts;
    if (draftCount != null) result.draftCount = draftCount;
    if (pendingApprovalCount != null)
      result.pendingApprovalCount = pendingApprovalCount;
    if (approvedCount != null) result.approvedCount = approvedCount;
    if (readyForProductionCount != null)
      result.readyForProductionCount = readyForProductionCount;
    if (archivedCount != null) result.archivedCount = archivedCount;
    return result;
  }

  ScriptServiceGetStatsResponse._();

  factory ScriptServiceGetStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetStatsResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetStatsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalScripts')
    ..aI(2, _omitFieldNames ? '' : 'draftCount')
    ..aI(3, _omitFieldNames ? '' : 'pendingApprovalCount')
    ..aI(4, _omitFieldNames ? '' : 'approvedCount')
    ..aI(5, _omitFieldNames ? '' : 'readyForProductionCount')
    ..aI(6, _omitFieldNames ? '' : 'archivedCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetStatsResponse copyWith(
          void Function(ScriptServiceGetStatsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceGetStatsResponse))
          as ScriptServiceGetStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetStatsResponse() / ScriptServiceGetStatsResponse.new instead')
  static ScriptServiceGetStatsResponse create() =>
      ScriptServiceGetStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceGetStatsResponse._();
  @$core.override
  ScriptServiceGetStatsResponse createEmptyInstance() =>
      ScriptServiceGetStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetStatsResponse>(
          ScriptServiceGetStatsResponse.$_createMessage);
  static ScriptServiceGetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalScripts => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalScripts($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalScripts() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalScripts() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get draftCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set draftCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDraftCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearDraftCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pendingApprovalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set pendingApprovalCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPendingApprovalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPendingApprovalCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get approvedCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set approvedCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasApprovedCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovedCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get readyForProductionCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set readyForProductionCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReadyForProductionCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadyForProductionCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get archivedCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set archivedCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasArchivedCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearArchivedCount() => $_clearField(6);
}

class ScriptServiceGetBriefRequest extends $pb.GeneratedMessage {
  factory ScriptServiceGetBriefRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.bool? createIfMissing,
    $core.String? outputType,
    $core.String? targetFormat,
    $core.int? targetDurationSeconds,
    $core.String? continuityRequirementsJson,
    $core.String? brandVoiceRequirementsJson,
    $core.String? productionInstructions,
  }) {
    final result = ScriptServiceGetBriefRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (createIfMissing != null) result.createIfMissing = createIfMissing;
    if (outputType != null) result.outputType = outputType;
    if (targetFormat != null) result.targetFormat = targetFormat;
    if (targetDurationSeconds != null)
      result.targetDurationSeconds = targetDurationSeconds;
    if (continuityRequirementsJson != null)
      result.continuityRequirementsJson = continuityRequirementsJson;
    if (brandVoiceRequirementsJson != null)
      result.brandVoiceRequirementsJson = brandVoiceRequirementsJson;
    if (productionInstructions != null)
      result.productionInstructions = productionInstructions;
    return result;
  }

  ScriptServiceGetBriefRequest._();

  factory ScriptServiceGetBriefRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetBriefRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetBriefRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetBriefRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetBriefRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetBriefRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOB(3, _omitFieldNames ? '' : 'createIfMissing')
    ..aOS(4, _omitFieldNames ? '' : 'outputType')
    ..aOS(5, _omitFieldNames ? '' : 'targetFormat')
    ..aI(6, _omitFieldNames ? '' : 'targetDurationSeconds')
    ..aOS(7, _omitFieldNames ? '' : 'continuityRequirementsJson')
    ..aOS(8, _omitFieldNames ? '' : 'brandVoiceRequirementsJson')
    ..aOS(9, _omitFieldNames ? '' : 'productionInstructions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetBriefRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetBriefRequest copyWith(
          void Function(ScriptServiceGetBriefRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceGetBriefRequest))
          as ScriptServiceGetBriefRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetBriefRequest() / ScriptServiceGetBriefRequest.new instead')
  static ScriptServiceGetBriefRequest create() =>
      ScriptServiceGetBriefRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceGetBriefRequest._();
  @$core.override
  ScriptServiceGetBriefRequest createEmptyInstance() =>
      ScriptServiceGetBriefRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetBriefRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetBriefRequest>(
          ScriptServiceGetBriefRequest.$_createMessage);
  static ScriptServiceGetBriefRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get createIfMissing => $_getBF(2);
  @$pb.TagNumber(3)
  set createIfMissing($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreateIfMissing() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreateIfMissing() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get outputType => $_getSZ(3);
  @$pb.TagNumber(4)
  set outputType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutputType() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutputType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetFormat => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetFormat($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetFormat() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get targetDurationSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set targetDurationSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetDurationSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetDurationSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get continuityRequirementsJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set continuityRequirementsJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContinuityRequirementsJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearContinuityRequirementsJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get brandVoiceRequirementsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set brandVoiceRequirementsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBrandVoiceRequirementsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearBrandVoiceRequirementsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get productionInstructions => $_getSZ(8);
  @$pb.TagNumber(9)
  set productionInstructions($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasProductionInstructions() => $_has(8);
  @$pb.TagNumber(9)
  void clearProductionInstructions() => $_clearField(9);
}

class ScriptServiceGetBriefResponse extends $pb.GeneratedMessage {
  factory ScriptServiceGetBriefResponse({
    AssetBrief? assetBrief,
    $core.bool? readyForProduction,
  }) {
    final result = ScriptServiceGetBriefResponse._();
    if (assetBrief != null) result.assetBrief = assetBrief;
    if (readyForProduction != null)
      result.readyForProduction = readyForProduction;
    return result;
  }

  ScriptServiceGetBriefResponse._();

  factory ScriptServiceGetBriefResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetBriefResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetBriefResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetBriefResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetBriefResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetBriefResponse.$_createMessage)
    ..aOM<AssetBrief>(1, _omitFieldNames ? '' : 'assetBrief',
        subBuilder: AssetBrief.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'readyForProduction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetBriefResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetBriefResponse copyWith(
          void Function(ScriptServiceGetBriefResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceGetBriefResponse))
          as ScriptServiceGetBriefResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetBriefResponse() / ScriptServiceGetBriefResponse.new instead')
  static ScriptServiceGetBriefResponse create() =>
      ScriptServiceGetBriefResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceGetBriefResponse._();
  @$core.override
  ScriptServiceGetBriefResponse createEmptyInstance() =>
      ScriptServiceGetBriefResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetBriefResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetBriefResponse>(
          ScriptServiceGetBriefResponse.$_createMessage);
  static ScriptServiceGetBriefResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AssetBrief get assetBrief => $_getN(0);
  @$pb.TagNumber(1)
  set assetBrief(AssetBrief value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetBrief() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetBrief() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetBrief ensureAssetBrief() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get readyForProduction => $_getBF(1);
  @$pb.TagNumber(2)
  set readyForProduction($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReadyForProduction() => $_has(1);
  @$pb.TagNumber(2)
  void clearReadyForProduction() => $_clearField(2);
}

class ScriptServiceGetReviewRequest extends $pb.GeneratedMessage {
  factory ScriptServiceGetReviewRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
  }) {
    final result = ScriptServiceGetReviewRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    return result;
  }

  ScriptServiceGetReviewRequest._();

  factory ScriptServiceGetReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetReviewRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetReviewRequest copyWith(
          void Function(ScriptServiceGetReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceGetReviewRequest))
          as ScriptServiceGetReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetReviewRequest() / ScriptServiceGetReviewRequest.new instead')
  static ScriptServiceGetReviewRequest create() =>
      ScriptServiceGetReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceGetReviewRequest._();
  @$core.override
  ScriptServiceGetReviewRequest createEmptyInstance() =>
      ScriptServiceGetReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetReviewRequest>(
          ScriptServiceGetReviewRequest.$_createMessage);
  static ScriptServiceGetReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);
}

class ScriptServiceGetReviewResponse extends $pb.GeneratedMessage {
  factory ScriptServiceGetReviewResponse({
    $core.String? scriptId,
    ScriptApprovalState? approvalState,
    $core.String? rejectionReason,
    $core.String? approvedBy,
    $core.Iterable<ScriptReviewComment>? comments,
  }) {
    final result = ScriptServiceGetReviewResponse._();
    if (scriptId != null) result.scriptId = scriptId;
    if (approvalState != null) result.approvalState = approvalState;
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (comments != null) result.comments.addAll(comments);
    return result;
  }

  ScriptServiceGetReviewResponse._();

  factory ScriptServiceGetReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetReviewResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetReviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetReviewResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'scriptId')
    ..aE<ScriptApprovalState>(2, _omitFieldNames ? '' : 'approvalState',
        enumValues: ScriptApprovalState.values)
    ..aOS(3, _omitFieldNames ? '' : 'rejectionReason')
    ..aOS(4, _omitFieldNames ? '' : 'approvedBy')
    ..pPM<ScriptReviewComment>(5, _omitFieldNames ? '' : 'comments',
        subBuilder: ScriptReviewComment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetReviewResponse copyWith(
          void Function(ScriptServiceGetReviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceGetReviewResponse))
          as ScriptServiceGetReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetReviewResponse() / ScriptServiceGetReviewResponse.new instead')
  static ScriptServiceGetReviewResponse create() =>
      ScriptServiceGetReviewResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceGetReviewResponse._();
  @$core.override
  ScriptServiceGetReviewResponse createEmptyInstance() =>
      ScriptServiceGetReviewResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetReviewResponse>(
          ScriptServiceGetReviewResponse.$_createMessage);
  static ScriptServiceGetReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scriptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set scriptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScriptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearScriptId() => $_clearField(1);

  @$pb.TagNumber(2)
  ScriptApprovalState get approvalState => $_getN(1);
  @$pb.TagNumber(2)
  set approvalState(ScriptApprovalState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasApprovalState() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprovalState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rejectionReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set rejectionReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRejectionReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearRejectionReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get approvedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set approvedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasApprovedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ScriptReviewComment> get comments => $_getList(4);
}

class ScriptServiceSubmitReviewRequest extends $pb.GeneratedMessage {
  factory ScriptServiceSubmitReviewRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? reviewNotes,
  }) {
    final result = ScriptServiceSubmitReviewRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (reviewNotes != null) result.reviewNotes = reviewNotes;
    return result;
  }

  ScriptServiceSubmitReviewRequest._();

  factory ScriptServiceSubmitReviewRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceSubmitReviewRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceSubmitReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceSubmitReviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceSubmitReviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceSubmitReviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'reviewNotes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceSubmitReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceSubmitReviewRequest copyWith(
          void Function(ScriptServiceSubmitReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceSubmitReviewRequest))
          as ScriptServiceSubmitReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceSubmitReviewRequest() / ScriptServiceSubmitReviewRequest.new instead')
  static ScriptServiceSubmitReviewRequest create() =>
      ScriptServiceSubmitReviewRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceSubmitReviewRequest._();
  @$core.override
  ScriptServiceSubmitReviewRequest createEmptyInstance() =>
      ScriptServiceSubmitReviewRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceSubmitReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceSubmitReviewRequest>(
          ScriptServiceSubmitReviewRequest.$_createMessage);
  static ScriptServiceSubmitReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reviewNotes => $_getSZ(2);
  @$pb.TagNumber(3)
  set reviewNotes($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReviewNotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewNotes() => $_clearField(3);
}

class ScriptServiceSubmitReviewResponse extends $pb.GeneratedMessage {
  factory ScriptServiceSubmitReviewResponse({
    $core.bool? success,
  }) {
    final result = ScriptServiceSubmitReviewResponse._();
    if (success != null) result.success = success;
    return result;
  }

  ScriptServiceSubmitReviewResponse._();

  factory ScriptServiceSubmitReviewResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceSubmitReviewResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceSubmitReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceSubmitReviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceSubmitReviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceSubmitReviewResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceSubmitReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceSubmitReviewResponse copyWith(
          void Function(ScriptServiceSubmitReviewResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceSubmitReviewResponse))
          as ScriptServiceSubmitReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceSubmitReviewResponse() / ScriptServiceSubmitReviewResponse.new instead')
  static ScriptServiceSubmitReviewResponse create() =>
      ScriptServiceSubmitReviewResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceSubmitReviewResponse._();
  @$core.override
  ScriptServiceSubmitReviewResponse createEmptyInstance() =>
      ScriptServiceSubmitReviewResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceSubmitReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceSubmitReviewResponse>(
          ScriptServiceSubmitReviewResponse.$_createMessage);
  static ScriptServiceSubmitReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ScriptServiceRequestChangesRequest extends $pb.GeneratedMessage {
  factory ScriptServiceRequestChangesRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? feedback,
    $core.int? expectedVersion,
  }) {
    final result = ScriptServiceRequestChangesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (feedback != null) result.feedback = feedback;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  ScriptServiceRequestChangesRequest._();

  factory ScriptServiceRequestChangesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRequestChangesRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceRequestChangesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRequestChangesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceRequestChangesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceRequestChangesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'feedback')
    ..aI(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRequestChangesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRequestChangesRequest copyWith(
          void Function(ScriptServiceRequestChangesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceRequestChangesRequest))
          as ScriptServiceRequestChangesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceRequestChangesRequest() / ScriptServiceRequestChangesRequest.new instead')
  static ScriptServiceRequestChangesRequest create() =>
      ScriptServiceRequestChangesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceRequestChangesRequest._();
  @$core.override
  ScriptServiceRequestChangesRequest createEmptyInstance() =>
      ScriptServiceRequestChangesRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceRequestChangesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceRequestChangesRequest>(
          ScriptServiceRequestChangesRequest.$_createMessage);
  static ScriptServiceRequestChangesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get feedback => $_getSZ(2);
  @$pb.TagNumber(3)
  set feedback($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeedback() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeedback() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get expectedVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set expectedVersion($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

class ScriptServiceRequestChangesResponse extends $pb.GeneratedMessage {
  factory ScriptServiceRequestChangesResponse({
    Script? script,
  }) {
    final result = ScriptServiceRequestChangesResponse._();
    if (script != null) result.script = script;
    return result;
  }

  ScriptServiceRequestChangesResponse._();

  factory ScriptServiceRequestChangesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRequestChangesResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceRequestChangesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRequestChangesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceRequestChangesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceRequestChangesResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRequestChangesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRequestChangesResponse copyWith(
          void Function(ScriptServiceRequestChangesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceRequestChangesResponse))
          as ScriptServiceRequestChangesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceRequestChangesResponse() / ScriptServiceRequestChangesResponse.new instead')
  static ScriptServiceRequestChangesResponse create() =>
      ScriptServiceRequestChangesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceRequestChangesResponse._();
  @$core.override
  ScriptServiceRequestChangesResponse createEmptyInstance() =>
      ScriptServiceRequestChangesResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceRequestChangesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ScriptServiceRequestChangesResponse>(
          ScriptServiceRequestChangesResponse.$_createMessage);
  static ScriptServiceRequestChangesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);
}

class ScriptServiceAddSectionRequest extends $pb.GeneratedMessage {
  factory ScriptServiceAddSectionRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    Scene? scene,
  }) {
    final result = ScriptServiceAddSectionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (scene != null) result.scene = scene;
    return result;
  }

  ScriptServiceAddSectionRequest._();

  factory ScriptServiceAddSectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceAddSectionRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceAddSectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceAddSectionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceAddSectionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceAddSectionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOM<Scene>(3, _omitFieldNames ? '' : 'scene',
        subBuilder: Scene.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceAddSectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceAddSectionRequest copyWith(
          void Function(ScriptServiceAddSectionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceAddSectionRequest))
          as ScriptServiceAddSectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceAddSectionRequest() / ScriptServiceAddSectionRequest.new instead')
  static ScriptServiceAddSectionRequest create() =>
      ScriptServiceAddSectionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceAddSectionRequest._();
  @$core.override
  ScriptServiceAddSectionRequest createEmptyInstance() =>
      ScriptServiceAddSectionRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceAddSectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceAddSectionRequest>(
          ScriptServiceAddSectionRequest.$_createMessage);
  static ScriptServiceAddSectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  Scene get scene => $_getN(2);
  @$pb.TagNumber(3)
  set scene(Scene value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScene() => $_has(2);
  @$pb.TagNumber(3)
  void clearScene() => $_clearField(3);
  @$pb.TagNumber(3)
  Scene ensureScene() => $_ensure(2);
}

class ScriptServiceAddSectionResponse extends $pb.GeneratedMessage {
  factory ScriptServiceAddSectionResponse({
    Script? script,
  }) {
    final result = ScriptServiceAddSectionResponse._();
    if (script != null) result.script = script;
    return result;
  }

  ScriptServiceAddSectionResponse._();

  factory ScriptServiceAddSectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceAddSectionResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceAddSectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceAddSectionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceAddSectionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceAddSectionResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceAddSectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceAddSectionResponse copyWith(
          void Function(ScriptServiceAddSectionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceAddSectionResponse))
          as ScriptServiceAddSectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceAddSectionResponse() / ScriptServiceAddSectionResponse.new instead')
  static ScriptServiceAddSectionResponse create() =>
      ScriptServiceAddSectionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceAddSectionResponse._();
  @$core.override
  ScriptServiceAddSectionResponse createEmptyInstance() =>
      ScriptServiceAddSectionResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceAddSectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceAddSectionResponse>(
          ScriptServiceAddSectionResponse.$_createMessage);
  static ScriptServiceAddSectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);
}

class ScriptServiceUpdateSectionRequest extends $pb.GeneratedMessage {
  factory ScriptServiceUpdateSectionRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    Scene? scene,
  }) {
    final result = ScriptServiceUpdateSectionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (scene != null) result.scene = scene;
    return result;
  }

  ScriptServiceUpdateSectionRequest._();

  factory ScriptServiceUpdateSectionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceUpdateSectionRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceUpdateSectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceUpdateSectionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceUpdateSectionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceUpdateSectionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOM<Scene>(3, _omitFieldNames ? '' : 'scene',
        subBuilder: Scene.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceUpdateSectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceUpdateSectionRequest copyWith(
          void Function(ScriptServiceUpdateSectionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceUpdateSectionRequest))
          as ScriptServiceUpdateSectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceUpdateSectionRequest() / ScriptServiceUpdateSectionRequest.new instead')
  static ScriptServiceUpdateSectionRequest create() =>
      ScriptServiceUpdateSectionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceUpdateSectionRequest._();
  @$core.override
  ScriptServiceUpdateSectionRequest createEmptyInstance() =>
      ScriptServiceUpdateSectionRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceUpdateSectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceUpdateSectionRequest>(
          ScriptServiceUpdateSectionRequest.$_createMessage);
  static ScriptServiceUpdateSectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  Scene get scene => $_getN(2);
  @$pb.TagNumber(3)
  set scene(Scene value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScene() => $_has(2);
  @$pb.TagNumber(3)
  void clearScene() => $_clearField(3);
  @$pb.TagNumber(3)
  Scene ensureScene() => $_ensure(2);
}

class ScriptServiceUpdateSectionResponse extends $pb.GeneratedMessage {
  factory ScriptServiceUpdateSectionResponse({
    Script? script,
  }) {
    final result = ScriptServiceUpdateSectionResponse._();
    if (script != null) result.script = script;
    return result;
  }

  ScriptServiceUpdateSectionResponse._();

  factory ScriptServiceUpdateSectionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceUpdateSectionResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceUpdateSectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceUpdateSectionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceUpdateSectionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceUpdateSectionResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceUpdateSectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceUpdateSectionResponse copyWith(
          void Function(ScriptServiceUpdateSectionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceUpdateSectionResponse))
          as ScriptServiceUpdateSectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceUpdateSectionResponse() / ScriptServiceUpdateSectionResponse.new instead')
  static ScriptServiceUpdateSectionResponse create() =>
      ScriptServiceUpdateSectionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceUpdateSectionResponse._();
  @$core.override
  ScriptServiceUpdateSectionResponse createEmptyInstance() =>
      ScriptServiceUpdateSectionResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceUpdateSectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceUpdateSectionResponse>(
          ScriptServiceUpdateSectionResponse.$_createMessage);
  static ScriptServiceUpdateSectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);
}

class ScriptServiceDeleteSectionRequest extends $pb.GeneratedMessage {
  factory ScriptServiceDeleteSectionRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? sceneId,
  }) {
    final result = ScriptServiceDeleteSectionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (sceneId != null) result.sceneId = sceneId;
    return result;
  }

  ScriptServiceDeleteSectionRequest._();

  factory ScriptServiceDeleteSectionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDeleteSectionRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceDeleteSectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDeleteSectionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceDeleteSectionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceDeleteSectionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'sceneId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDeleteSectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDeleteSectionRequest copyWith(
          void Function(ScriptServiceDeleteSectionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceDeleteSectionRequest))
          as ScriptServiceDeleteSectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceDeleteSectionRequest() / ScriptServiceDeleteSectionRequest.new instead')
  static ScriptServiceDeleteSectionRequest create() =>
      ScriptServiceDeleteSectionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceDeleteSectionRequest._();
  @$core.override
  ScriptServiceDeleteSectionRequest createEmptyInstance() =>
      ScriptServiceDeleteSectionRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceDeleteSectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceDeleteSectionRequest>(
          ScriptServiceDeleteSectionRequest.$_createMessage);
  static ScriptServiceDeleteSectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sceneId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sceneId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSceneId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSceneId() => $_clearField(3);
}

class ScriptServiceDeleteSectionResponse extends $pb.GeneratedMessage {
  factory ScriptServiceDeleteSectionResponse({
    Script? script,
  }) {
    final result = ScriptServiceDeleteSectionResponse._();
    if (script != null) result.script = script;
    return result;
  }

  ScriptServiceDeleteSectionResponse._();

  factory ScriptServiceDeleteSectionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDeleteSectionResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceDeleteSectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceDeleteSectionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceDeleteSectionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceDeleteSectionResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDeleteSectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceDeleteSectionResponse copyWith(
          void Function(ScriptServiceDeleteSectionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceDeleteSectionResponse))
          as ScriptServiceDeleteSectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceDeleteSectionResponse() / ScriptServiceDeleteSectionResponse.new instead')
  static ScriptServiceDeleteSectionResponse create() =>
      ScriptServiceDeleteSectionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceDeleteSectionResponse._();
  @$core.override
  ScriptServiceDeleteSectionResponse createEmptyInstance() =>
      ScriptServiceDeleteSectionResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceDeleteSectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceDeleteSectionResponse>(
          ScriptServiceDeleteSectionResponse.$_createMessage);
  static ScriptServiceDeleteSectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);
}

class ScriptServiceReorderSectionsRequest extends $pb.GeneratedMessage {
  factory ScriptServiceReorderSectionsRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.Iterable<$core.String>? sceneIdsInOrder,
  }) {
    final result = ScriptServiceReorderSectionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (sceneIdsInOrder != null) result.sceneIdsInOrder.addAll(sceneIdsInOrder);
    return result;
  }

  ScriptServiceReorderSectionsRequest._();

  factory ScriptServiceReorderSectionsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceReorderSectionsRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceReorderSectionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceReorderSectionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceReorderSectionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceReorderSectionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..pPS(3, _omitFieldNames ? '' : 'sceneIdsInOrder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceReorderSectionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceReorderSectionsRequest copyWith(
          void Function(ScriptServiceReorderSectionsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceReorderSectionsRequest))
          as ScriptServiceReorderSectionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceReorderSectionsRequest() / ScriptServiceReorderSectionsRequest.new instead')
  static ScriptServiceReorderSectionsRequest create() =>
      ScriptServiceReorderSectionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceReorderSectionsRequest._();
  @$core.override
  ScriptServiceReorderSectionsRequest createEmptyInstance() =>
      ScriptServiceReorderSectionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceReorderSectionsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ScriptServiceReorderSectionsRequest>(
          ScriptServiceReorderSectionsRequest.$_createMessage);
  static ScriptServiceReorderSectionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get sceneIdsInOrder => $_getList(2);
}

class ScriptServiceReorderSectionsResponse extends $pb.GeneratedMessage {
  factory ScriptServiceReorderSectionsResponse({
    Script? script,
  }) {
    final result = ScriptServiceReorderSectionsResponse._();
    if (script != null) result.script = script;
    return result;
  }

  ScriptServiceReorderSectionsResponse._();

  factory ScriptServiceReorderSectionsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceReorderSectionsResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceReorderSectionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceReorderSectionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceReorderSectionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceReorderSectionsResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceReorderSectionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceReorderSectionsResponse copyWith(
          void Function(ScriptServiceReorderSectionsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceReorderSectionsResponse))
          as ScriptServiceReorderSectionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceReorderSectionsResponse() / ScriptServiceReorderSectionsResponse.new instead')
  static ScriptServiceReorderSectionsResponse create() =>
      ScriptServiceReorderSectionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceReorderSectionsResponse._();
  @$core.override
  ScriptServiceReorderSectionsResponse createEmptyInstance() =>
      ScriptServiceReorderSectionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceReorderSectionsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ScriptServiceReorderSectionsResponse>(
          ScriptServiceReorderSectionsResponse.$_createMessage);
  static ScriptServiceReorderSectionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);
}

class ScriptServiceAddCommentRequest extends $pb.GeneratedMessage {
  factory ScriptServiceAddCommentRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? content,
    $core.int? sceneIndex,
  }) {
    final result = ScriptServiceAddCommentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (content != null) result.content = content;
    if (sceneIndex != null) result.sceneIndex = sceneIndex;
    return result;
  }

  ScriptServiceAddCommentRequest._();

  factory ScriptServiceAddCommentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceAddCommentRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceAddCommentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceAddCommentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceAddCommentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceAddCommentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..aI(4, _omitFieldNames ? '' : 'sceneIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceAddCommentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceAddCommentRequest copyWith(
          void Function(ScriptServiceAddCommentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceAddCommentRequest))
          as ScriptServiceAddCommentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceAddCommentRequest() / ScriptServiceAddCommentRequest.new instead')
  static ScriptServiceAddCommentRequest create() =>
      ScriptServiceAddCommentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceAddCommentRequest._();
  @$core.override
  ScriptServiceAddCommentRequest createEmptyInstance() =>
      ScriptServiceAddCommentRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceAddCommentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceAddCommentRequest>(
          ScriptServiceAddCommentRequest.$_createMessage);
  static ScriptServiceAddCommentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get sceneIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set sceneIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSceneIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSceneIndex() => $_clearField(4);
}

class ScriptServiceAddCommentResponse extends $pb.GeneratedMessage {
  factory ScriptServiceAddCommentResponse({
    ScriptReviewComment? comment,
  }) {
    final result = ScriptServiceAddCommentResponse._();
    if (comment != null) result.comment = comment;
    return result;
  }

  ScriptServiceAddCommentResponse._();

  factory ScriptServiceAddCommentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceAddCommentResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceAddCommentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceAddCommentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceAddCommentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceAddCommentResponse.$_createMessage)
    ..aOM<ScriptReviewComment>(1, _omitFieldNames ? '' : 'comment',
        subBuilder: ScriptReviewComment.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceAddCommentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceAddCommentResponse copyWith(
          void Function(ScriptServiceAddCommentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceAddCommentResponse))
          as ScriptServiceAddCommentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceAddCommentResponse() / ScriptServiceAddCommentResponse.new instead')
  static ScriptServiceAddCommentResponse create() =>
      ScriptServiceAddCommentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceAddCommentResponse._();
  @$core.override
  ScriptServiceAddCommentResponse createEmptyInstance() =>
      ScriptServiceAddCommentResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceAddCommentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceAddCommentResponse>(
          ScriptServiceAddCommentResponse.$_createMessage);
  static ScriptServiceAddCommentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ScriptReviewComment get comment => $_getN(0);
  @$pb.TagNumber(1)
  set comment(ScriptReviewComment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasComment() => $_has(0);
  @$pb.TagNumber(1)
  void clearComment() => $_clearField(1);
  @$pb.TagNumber(1)
  ScriptReviewComment ensureComment() => $_ensure(0);
}

class ScriptServiceResolveCommentRequest extends $pb.GeneratedMessage {
  factory ScriptServiceResolveCommentRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.String? commentId,
  }) {
    final result = ScriptServiceResolveCommentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (commentId != null) result.commentId = commentId;
    return result;
  }

  ScriptServiceResolveCommentRequest._();

  factory ScriptServiceResolveCommentRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceResolveCommentRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceResolveCommentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceResolveCommentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceResolveCommentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceResolveCommentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aOS(3, _omitFieldNames ? '' : 'commentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceResolveCommentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceResolveCommentRequest copyWith(
          void Function(ScriptServiceResolveCommentRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceResolveCommentRequest))
          as ScriptServiceResolveCommentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceResolveCommentRequest() / ScriptServiceResolveCommentRequest.new instead')
  static ScriptServiceResolveCommentRequest create() =>
      ScriptServiceResolveCommentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceResolveCommentRequest._();
  @$core.override
  ScriptServiceResolveCommentRequest createEmptyInstance() =>
      ScriptServiceResolveCommentRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceResolveCommentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceResolveCommentRequest>(
          ScriptServiceResolveCommentRequest.$_createMessage);
  static ScriptServiceResolveCommentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set commentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommentId() => $_clearField(3);
}

class ScriptServiceResolveCommentResponse extends $pb.GeneratedMessage {
  factory ScriptServiceResolveCommentResponse({
    $core.bool? success,
  }) {
    final result = ScriptServiceResolveCommentResponse._();
    if (success != null) result.success = success;
    return result;
  }

  ScriptServiceResolveCommentResponse._();

  factory ScriptServiceResolveCommentResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceResolveCommentResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceResolveCommentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceResolveCommentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceResolveCommentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceResolveCommentResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceResolveCommentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceResolveCommentResponse copyWith(
          void Function(ScriptServiceResolveCommentResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceResolveCommentResponse))
          as ScriptServiceResolveCommentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceResolveCommentResponse() / ScriptServiceResolveCommentResponse.new instead')
  static ScriptServiceResolveCommentResponse create() =>
      ScriptServiceResolveCommentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceResolveCommentResponse._();
  @$core.override
  ScriptServiceResolveCommentResponse createEmptyInstance() =>
      ScriptServiceResolveCommentResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceResolveCommentResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ScriptServiceResolveCommentResponse>(
          ScriptServiceResolveCommentResponse.$_createMessage);
  static ScriptServiceResolveCommentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ScriptServiceGetVersionRequest extends $pb.GeneratedMessage {
  factory ScriptServiceGetVersionRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.int? versionIndex,
  }) {
    final result = ScriptServiceGetVersionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (versionIndex != null) result.versionIndex = versionIndex;
    return result;
  }

  ScriptServiceGetVersionRequest._();

  factory ScriptServiceGetVersionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetVersionRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetVersionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetVersionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetVersionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetVersionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aI(3, _omitFieldNames ? '' : 'versionIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetVersionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetVersionRequest copyWith(
          void Function(ScriptServiceGetVersionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceGetVersionRequest))
          as ScriptServiceGetVersionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetVersionRequest() / ScriptServiceGetVersionRequest.new instead')
  static ScriptServiceGetVersionRequest create() =>
      ScriptServiceGetVersionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceGetVersionRequest._();
  @$core.override
  ScriptServiceGetVersionRequest createEmptyInstance() =>
      ScriptServiceGetVersionRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetVersionRequest>(
          ScriptServiceGetVersionRequest.$_createMessage);
  static ScriptServiceGetVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get versionIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set versionIndex($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersionIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersionIndex() => $_clearField(3);
}

class ScriptServiceGetVersionResponse extends $pb.GeneratedMessage {
  factory ScriptServiceGetVersionResponse({
    ScriptVersion? version,
  }) {
    final result = ScriptServiceGetVersionResponse._();
    if (version != null) result.version = version;
    return result;
  }

  ScriptServiceGetVersionResponse._();

  factory ScriptServiceGetVersionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetVersionResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceGetVersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceGetVersionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceGetVersionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceGetVersionResponse.$_createMessage)
    ..aOM<ScriptVersion>(1, _omitFieldNames ? '' : 'version',
        subBuilder: ScriptVersion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetVersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceGetVersionResponse copyWith(
          void Function(ScriptServiceGetVersionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceGetVersionResponse))
          as ScriptServiceGetVersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceGetVersionResponse() / ScriptServiceGetVersionResponse.new instead')
  static ScriptServiceGetVersionResponse create() =>
      ScriptServiceGetVersionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceGetVersionResponse._();
  @$core.override
  ScriptServiceGetVersionResponse createEmptyInstance() =>
      ScriptServiceGetVersionResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceGetVersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceGetVersionResponse>(
          ScriptServiceGetVersionResponse.$_createMessage);
  static ScriptServiceGetVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ScriptVersion get version => $_getN(0);
  @$pb.TagNumber(1)
  set version(ScriptVersion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  ScriptVersion ensureVersion() => $_ensure(0);
}

class ScriptServiceListVersionsRequest extends $pb.GeneratedMessage {
  factory ScriptServiceListVersionsRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
  }) {
    final result = ScriptServiceListVersionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    return result;
  }

  ScriptServiceListVersionsRequest._();

  factory ScriptServiceListVersionsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceListVersionsRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceListVersionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceListVersionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceListVersionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceListVersionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceListVersionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceListVersionsRequest copyWith(
          void Function(ScriptServiceListVersionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ScriptServiceListVersionsRequest))
          as ScriptServiceListVersionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceListVersionsRequest() / ScriptServiceListVersionsRequest.new instead')
  static ScriptServiceListVersionsRequest create() =>
      ScriptServiceListVersionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceListVersionsRequest._();
  @$core.override
  ScriptServiceListVersionsRequest createEmptyInstance() =>
      ScriptServiceListVersionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceListVersionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceListVersionsRequest>(
          ScriptServiceListVersionsRequest.$_createMessage);
  static ScriptServiceListVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);
}

class ScriptServiceListVersionsResponse extends $pb.GeneratedMessage {
  factory ScriptServiceListVersionsResponse({
    $core.Iterable<ScriptVersion>? versions,
  }) {
    final result = ScriptServiceListVersionsResponse._();
    if (versions != null) result.versions.addAll(versions);
    return result;
  }

  ScriptServiceListVersionsResponse._();

  factory ScriptServiceListVersionsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceListVersionsResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceListVersionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceListVersionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceListVersionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceListVersionsResponse.$_createMessage)
    ..pPM<ScriptVersion>(1, _omitFieldNames ? '' : 'versions',
        subBuilder: ScriptVersion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceListVersionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceListVersionsResponse copyWith(
          void Function(ScriptServiceListVersionsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceListVersionsResponse))
          as ScriptServiceListVersionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceListVersionsResponse() / ScriptServiceListVersionsResponse.new instead')
  static ScriptServiceListVersionsResponse create() =>
      ScriptServiceListVersionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceListVersionsResponse._();
  @$core.override
  ScriptServiceListVersionsResponse createEmptyInstance() =>
      ScriptServiceListVersionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceListVersionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceListVersionsResponse>(
          ScriptServiceListVersionsResponse.$_createMessage);
  static ScriptServiceListVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ScriptVersion> get versions => $_getList(0);
}

class ScriptServiceRestoreVersionRequest extends $pb.GeneratedMessage {
  factory ScriptServiceRestoreVersionRequest({
    $core.String? workspaceId,
    $core.String? scriptId,
    $core.int? versionIndex,
  }) {
    final result = ScriptServiceRestoreVersionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scriptId != null) result.scriptId = scriptId;
    if (versionIndex != null) result.versionIndex = versionIndex;
    return result;
  }

  ScriptServiceRestoreVersionRequest._();

  factory ScriptServiceRestoreVersionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRestoreVersionRequest()..mergeFromBuffer(data, registry);
  factory ScriptServiceRestoreVersionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRestoreVersionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceRestoreVersionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceRestoreVersionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scriptId')
    ..aI(3, _omitFieldNames ? '' : 'versionIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRestoreVersionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRestoreVersionRequest copyWith(
          void Function(ScriptServiceRestoreVersionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceRestoreVersionRequest))
          as ScriptServiceRestoreVersionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceRestoreVersionRequest() / ScriptServiceRestoreVersionRequest.new instead')
  static ScriptServiceRestoreVersionRequest create() =>
      ScriptServiceRestoreVersionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceRestoreVersionRequest._();
  @$core.override
  ScriptServiceRestoreVersionRequest createEmptyInstance() =>
      ScriptServiceRestoreVersionRequest._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceRestoreVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScriptServiceRestoreVersionRequest>(
          ScriptServiceRestoreVersionRequest.$_createMessage);
  static ScriptServiceRestoreVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scriptId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scriptId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScriptId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScriptId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get versionIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set versionIndex($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersionIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersionIndex() => $_clearField(3);
}

class ScriptServiceRestoreVersionResponse extends $pb.GeneratedMessage {
  factory ScriptServiceRestoreVersionResponse({
    Script? script,
  }) {
    final result = ScriptServiceRestoreVersionResponse._();
    if (script != null) result.script = script;
    return result;
  }

  ScriptServiceRestoreVersionResponse._();

  factory ScriptServiceRestoreVersionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRestoreVersionResponse()..mergeFromBuffer(data, registry);
  factory ScriptServiceRestoreVersionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScriptServiceRestoreVersionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScriptServiceRestoreVersionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ScriptServiceRestoreVersionResponse.$_createMessage)
    ..aOM<Script>(1, _omitFieldNames ? '' : 'script',
        subBuilder: Script.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRestoreVersionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScriptServiceRestoreVersionResponse copyWith(
          void Function(ScriptServiceRestoreVersionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ScriptServiceRestoreVersionResponse))
          as ScriptServiceRestoreVersionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScriptServiceRestoreVersionResponse() / ScriptServiceRestoreVersionResponse.new instead')
  static ScriptServiceRestoreVersionResponse create() =>
      ScriptServiceRestoreVersionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ScriptServiceRestoreVersionResponse._();
  @$core.override
  ScriptServiceRestoreVersionResponse createEmptyInstance() =>
      ScriptServiceRestoreVersionResponse._();
  @$core.pragma('dart2js:noInline')
  static ScriptServiceRestoreVersionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ScriptServiceRestoreVersionResponse>(
          ScriptServiceRestoreVersionResponse.$_createMessage);
  static ScriptServiceRestoreVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Script get script => $_getN(0);
  @$pb.TagNumber(1)
  set script(Script value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScript() => $_has(0);
  @$pb.TagNumber(1)
  void clearScript() => $_clearField(1);
  @$pb.TagNumber(1)
  Script ensureScript() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

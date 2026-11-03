// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/continuity.proto.

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

import 'continuity.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'continuity.pbenum.dart';

/// ApprovedReference represents a first-class canonical asset reference per RULE-M08-008.
class ApprovedReference extends $pb.GeneratedMessage {
  factory ApprovedReference({
    $core.String? referenceId,
    $core.String? packId,
    $core.String? assetId,
    $core.String? scriptId,
    $core.String? name,
    $core.String? mediaUrl,
    $core.String? referenceType,
    $core.String? sourceContext,
    $core.String? status,
    $1.Timestamp? createdAt,
  }) {
    final result = ApprovedReference._();
    if (referenceId != null) result.referenceId = referenceId;
    if (packId != null) result.packId = packId;
    if (assetId != null) result.assetId = assetId;
    if (scriptId != null) result.scriptId = scriptId;
    if (name != null) result.name = name;
    if (mediaUrl != null) result.mediaUrl = mediaUrl;
    if (referenceType != null) result.referenceType = referenceType;
    if (sourceContext != null) result.sourceContext = sourceContext;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ApprovedReference._();

  factory ApprovedReference.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApprovedReference()..mergeFromBuffer(data, registry);
  factory ApprovedReference.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApprovedReference()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApprovedReference',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ApprovedReference.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referenceId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'scriptId')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..aOS(6, _omitFieldNames ? '' : 'mediaUrl')
    ..aOS(7, _omitFieldNames ? '' : 'referenceType')
    ..aOS(8, _omitFieldNames ? '' : 'sourceContext')
    ..aOS(9, _omitFieldNames ? '' : 'status')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApprovedReference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApprovedReference copyWith(void Function(ApprovedReference) updates) =>
      super.copyWith((message) => updates(message as ApprovedReference))
          as ApprovedReference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ApprovedReference() / ApprovedReference.new instead')
  static ApprovedReference create() => ApprovedReference._();
  static $pb.GeneratedMessage $_createMessage() => ApprovedReference._();
  @$core.override
  ApprovedReference createEmptyInstance() => ApprovedReference._();
  @$core.pragma('dart2js:noInline')
  static ApprovedReference getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApprovedReference>(
          ApprovedReference.$_createMessage);
  static ApprovedReference? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referenceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set referenceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferenceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferenceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scriptId => $_getSZ(3);
  @$pb.TagNumber(4)
  set scriptId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScriptId() => $_has(3);
  @$pb.TagNumber(4)
  void clearScriptId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get mediaUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set mediaUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMediaUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearMediaUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get referenceType => $_getSZ(6);
  @$pb.TagNumber(7)
  set referenceType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReferenceType() => $_has(6);
  @$pb.TagNumber(7)
  void clearReferenceType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get sourceContext => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceContext($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceContext() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceContext() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get status => $_getSZ(8);
  @$pb.TagNumber(9)
  set status($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureCreatedAt() => $_ensure(9);
}

/// PackVersion stores an immutable point-in-time version of a continuity pack per RULE-M08-007.
class PackVersion extends $pb.GeneratedMessage {
  factory PackVersion({
    $core.String? versionId,
    $core.String? workspaceId,
    $core.String? packId,
    $core.int? versionIndex,
    $core.String? name,
    PackType? packType,
    $core.Iterable<ApprovedReference>? approvedReferences,
    $core.String? rulesSummary,
    $core.String? settingsJson,
    $core.String? allowedUseScopeJson,
    PackStatus? status,
    $core.String? snapshotReason,
    $1.Timestamp? createdAt,
  }) {
    final result = PackVersion._();
    if (versionId != null) result.versionId = versionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packId != null) result.packId = packId;
    if (versionIndex != null) result.versionIndex = versionIndex;
    if (name != null) result.name = name;
    if (packType != null) result.packType = packType;
    if (approvedReferences != null)
      result.approvedReferences.addAll(approvedReferences);
    if (rulesSummary != null) result.rulesSummary = rulesSummary;
    if (settingsJson != null) result.settingsJson = settingsJson;
    if (allowedUseScopeJson != null)
      result.allowedUseScopeJson = allowedUseScopeJson;
    if (status != null) result.status = status;
    if (snapshotReason != null) result.snapshotReason = snapshotReason;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  PackVersion._();

  factory PackVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PackVersion()..mergeFromBuffer(data, registry);
  factory PackVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PackVersion()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackVersion',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: PackVersion.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'versionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'packId')
    ..aI(4, _omitFieldNames ? '' : 'versionIndex')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..aE<PackType>(6, _omitFieldNames ? '' : 'packType',
        enumValues: PackType.values)
    ..pPM<ApprovedReference>(7, _omitFieldNames ? '' : 'approvedReferences',
        subBuilder: ApprovedReference.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'rulesSummary')
    ..aOS(9, _omitFieldNames ? '' : 'settingsJson')
    ..aOS(10, _omitFieldNames ? '' : 'allowedUseScopeJson')
    ..aE<PackStatus>(11, _omitFieldNames ? '' : 'status',
        enumValues: PackStatus.values)
    ..aOS(12, _omitFieldNames ? '' : 'snapshotReason')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackVersion copyWith(void Function(PackVersion) updates) =>
      super.copyWith((message) => updates(message as PackVersion))
          as PackVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PackVersion() / PackVersion.new instead')
  static PackVersion create() => PackVersion._();
  static $pb.GeneratedMessage $_createMessage() => PackVersion._();
  @$core.override
  PackVersion createEmptyInstance() => PackVersion._();
  @$core.pragma('dart2js:noInline')
  static PackVersion getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PackVersion>(
          PackVersion.$_createMessage);
  static PackVersion? _defaultInstance;

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
  $core.String get packId => $_getSZ(2);
  @$pb.TagNumber(3)
  set packId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPackId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPackId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get versionIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set versionIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersionIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersionIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  PackType get packType => $_getN(5);
  @$pb.TagNumber(6)
  set packType(PackType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPackType() => $_has(5);
  @$pb.TagNumber(6)
  void clearPackType() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<ApprovedReference> get approvedReferences => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get rulesSummary => $_getSZ(7);
  @$pb.TagNumber(8)
  set rulesSummary($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRulesSummary() => $_has(7);
  @$pb.TagNumber(8)
  void clearRulesSummary() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get settingsJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set settingsJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSettingsJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearSettingsJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get allowedUseScopeJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set allowedUseScopeJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAllowedUseScopeJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearAllowedUseScopeJson() => $_clearField(10);

  @$pb.TagNumber(11)
  PackStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(PackStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get snapshotReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set snapshotReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSnapshotReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearSnapshotReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureCreatedAt() => $_ensure(12);
}

/// ContinuityPack represents a canonical consistency pack per database_schema.md §7.2.
class ContinuityPack extends $pb.GeneratedMessage {
  factory ContinuityPack({
    $core.String? packId,
    $core.String? workspaceId,
    PackType? packType,
    $core.String? name,
    $core.String? characterId,
    $core.Iterable<ApprovedReference>? approvedReferences,
    $core.String? rulesSummary,
    $core.String? settingsJson,
    $core.String? allowedUseScopeJson,
    $core.int? version,
    $core.String? parentPackId,
    PackStatus? status,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = ContinuityPack._();
    if (packId != null) result.packId = packId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packType != null) result.packType = packType;
    if (name != null) result.name = name;
    if (characterId != null) result.characterId = characterId;
    if (approvedReferences != null)
      result.approvedReferences.addAll(approvedReferences);
    if (rulesSummary != null) result.rulesSummary = rulesSummary;
    if (settingsJson != null) result.settingsJson = settingsJson;
    if (allowedUseScopeJson != null)
      result.allowedUseScopeJson = allowedUseScopeJson;
    if (version != null) result.version = version;
    if (parentPackId != null) result.parentPackId = parentPackId;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ContinuityPack._();

  factory ContinuityPack.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityPack()..mergeFromBuffer(data, registry);
  factory ContinuityPack.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityPack()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityPack',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityPack.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'packId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<PackType>(3, _omitFieldNames ? '' : 'packType',
        enumValues: PackType.values)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'characterId')
    ..pPM<ApprovedReference>(6, _omitFieldNames ? '' : 'approvedReferences',
        subBuilder: ApprovedReference.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'rulesSummary')
    ..aOS(8, _omitFieldNames ? '' : 'settingsJson')
    ..aOS(9, _omitFieldNames ? '' : 'allowedUseScopeJson')
    ..aI(10, _omitFieldNames ? '' : 'version')
    ..aOS(11, _omitFieldNames ? '' : 'parentPackId')
    ..aE<PackStatus>(12, _omitFieldNames ? '' : 'status',
        enumValues: PackStatus.values)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityPack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityPack copyWith(void Function(ContinuityPack) updates) =>
      super.copyWith((message) => updates(message as ContinuityPack))
          as ContinuityPack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContinuityPack() / ContinuityPack.new instead')
  static ContinuityPack create() => ContinuityPack._();
  static $pb.GeneratedMessage $_createMessage() => ContinuityPack._();
  @$core.override
  ContinuityPack createEmptyInstance() => ContinuityPack._();
  @$core.pragma('dart2js:noInline')
  static ContinuityPack getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContinuityPack>(
          ContinuityPack.$_createMessage);
  static ContinuityPack? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packId => $_getSZ(0);
  @$pb.TagNumber(1)
  set packId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  PackType get packType => $_getN(2);
  @$pb.TagNumber(3)
  set packType(PackType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPackType() => $_has(2);
  @$pb.TagNumber(3)
  void clearPackType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get characterId => $_getSZ(4);
  @$pb.TagNumber(5)
  set characterId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCharacterId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCharacterId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<ApprovedReference> get approvedReferences => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get rulesSummary => $_getSZ(6);
  @$pb.TagNumber(7)
  set rulesSummary($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRulesSummary() => $_has(6);
  @$pb.TagNumber(7)
  void clearRulesSummary() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get settingsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set settingsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSettingsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearSettingsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get allowedUseScopeJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set allowedUseScopeJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAllowedUseScopeJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearAllowedUseScopeJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get version => $_getIZ(9);
  @$pb.TagNumber(10)
  set version($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get parentPackId => $_getSZ(10);
  @$pb.TagNumber(11)
  set parentPackId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasParentPackId() => $_has(10);
  @$pb.TagNumber(11)
  void clearParentPackId() => $_clearField(11);

  @$pb.TagNumber(12)
  PackStatus get status => $_getN(11);
  @$pb.TagNumber(12)
  set status(PackStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $1.Timestamp get updatedAt => $_getN(13);
  @$pb.TagNumber(14)
  set updatedAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasUpdatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearUpdatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureUpdatedAt() => $_ensure(13);
}

/// ConsentRecord stores legally verified or granted consent per database_schema.md §18.3.
class ConsentRecord extends $pb.GeneratedMessage {
  factory ConsentRecord({
    $core.String? consentId,
    $core.String? userId,
    $core.String? workspaceId,
    $core.String? consentType,
    $core.String? version,
    $core.bool? granted,
    $1.Timestamp? grantedAt,
    $1.Timestamp? revokedAt,
    $core.String? ipAddress,
    $core.String? userAgent,
    $1.Timestamp? createdAt,
  }) {
    final result = ConsentRecord._();
    if (consentId != null) result.consentId = consentId;
    if (userId != null) result.userId = userId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (consentType != null) result.consentType = consentType;
    if (version != null) result.version = version;
    if (granted != null) result.granted = granted;
    if (grantedAt != null) result.grantedAt = grantedAt;
    if (revokedAt != null) result.revokedAt = revokedAt;
    if (ipAddress != null) result.ipAddress = ipAddress;
    if (userAgent != null) result.userAgent = userAgent;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ConsentRecord._();

  factory ConsentRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentRecord()..mergeFromBuffer(data, registry);
  factory ConsentRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConsentRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ConsentRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'consentId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'consentType')
    ..aOS(5, _omitFieldNames ? '' : 'version')
    ..aOB(6, _omitFieldNames ? '' : 'granted')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'grantedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'revokedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'ipAddress')
    ..aOS(10, _omitFieldNames ? '' : 'userAgent')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentRecord copyWith(void Function(ConsentRecord) updates) =>
      super.copyWith((message) => updates(message as ConsentRecord))
          as ConsentRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ConsentRecord() / ConsentRecord.new instead')
  static ConsentRecord create() => ConsentRecord._();
  static $pb.GeneratedMessage $_createMessage() => ConsentRecord._();
  @$core.override
  ConsentRecord createEmptyInstance() => ConsentRecord._();
  @$core.pragma('dart2js:noInline')
  static ConsentRecord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConsentRecord>(
          ConsentRecord.$_createMessage);
  static ConsentRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get consentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set consentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConsentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get consentType => $_getSZ(3);
  @$pb.TagNumber(4)
  set consentType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConsentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearConsentType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get version => $_getSZ(4);
  @$pb.TagNumber(5)
  set version($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get granted => $_getBF(5);
  @$pb.TagNumber(6)
  set granted($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGranted() => $_has(5);
  @$pb.TagNumber(6)
  void clearGranted() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get grantedAt => $_getN(6);
  @$pb.TagNumber(7)
  set grantedAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasGrantedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearGrantedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureGrantedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get revokedAt => $_getN(7);
  @$pb.TagNumber(8)
  set revokedAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRevokedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearRevokedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureRevokedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get ipAddress => $_getSZ(8);
  @$pb.TagNumber(9)
  set ipAddress($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIpAddress() => $_has(8);
  @$pb.TagNumber(9)
  void clearIpAddress() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get userAgent => $_getSZ(9);
  @$pb.TagNumber(10)
  set userAgent($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUserAgent() => $_has(9);
  @$pb.TagNumber(10)
  void clearUserAgent() => $_clearField(10);

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

/// Character represents an AI persona, digital twin, or stock avatar per database_schema.md §7.1.
class Character extends $pb.GeneratedMessage {
  factory Character({
    $core.String? characterId,
    $core.String? workspaceId,
    $core.String? name,
    CharacterType? characterType,
    $core.String? description,
    $core.String? referenceImagesJson,
    $core.String? voiceSettingsJson,
    $core.String? visualSettingsJson,
    $core.bool? consentVerified,
    $core.String? consentRecordId,
    $core.bool? isDefault,
    CharacterStatus? status,
    $core.String? characterPackId,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Character._();
    if (characterId != null) result.characterId = characterId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (name != null) result.name = name;
    if (characterType != null) result.characterType = characterType;
    if (description != null) result.description = description;
    if (referenceImagesJson != null)
      result.referenceImagesJson = referenceImagesJson;
    if (voiceSettingsJson != null) result.voiceSettingsJson = voiceSettingsJson;
    if (visualSettingsJson != null)
      result.visualSettingsJson = visualSettingsJson;
    if (consentVerified != null) result.consentVerified = consentVerified;
    if (consentRecordId != null) result.consentRecordId = consentRecordId;
    if (isDefault != null) result.isDefault = isDefault;
    if (status != null) result.status = status;
    if (characterPackId != null) result.characterPackId = characterPackId;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Character._();

  factory Character.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Character()..mergeFromBuffer(data, registry);
  factory Character.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Character()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Character',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: Character.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'characterId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aE<CharacterType>(4, _omitFieldNames ? '' : 'characterType',
        enumValues: CharacterType.values)
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'referenceImagesJson')
    ..aOS(7, _omitFieldNames ? '' : 'voiceSettingsJson')
    ..aOS(8, _omitFieldNames ? '' : 'visualSettingsJson')
    ..aOB(9, _omitFieldNames ? '' : 'consentVerified')
    ..aOS(10, _omitFieldNames ? '' : 'consentRecordId')
    ..aOB(11, _omitFieldNames ? '' : 'isDefault')
    ..aE<CharacterStatus>(12, _omitFieldNames ? '' : 'status',
        enumValues: CharacterStatus.values)
    ..aOS(13, _omitFieldNames ? '' : 'characterPackId')
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Character clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Character copyWith(void Function(Character) updates) =>
      super.copyWith((message) => updates(message as Character)) as Character;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Character() / Character.new instead')
  static Character create() => Character._();
  static $pb.GeneratedMessage $_createMessage() => Character._();
  @$core.override
  Character createEmptyInstance() => Character._();
  @$core.pragma('dart2js:noInline')
  static Character getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Character>(Character.$_createMessage);
  static Character? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get characterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set characterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacterId() => $_clearField(1);

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
  CharacterType get characterType => $_getN(3);
  @$pb.TagNumber(4)
  set characterType(CharacterType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCharacterType() => $_has(3);
  @$pb.TagNumber(4)
  void clearCharacterType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get referenceImagesJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set referenceImagesJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReferenceImagesJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearReferenceImagesJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get voiceSettingsJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set voiceSettingsJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVoiceSettingsJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoiceSettingsJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get visualSettingsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set visualSettingsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVisualSettingsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearVisualSettingsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get consentVerified => $_getBF(8);
  @$pb.TagNumber(9)
  set consentVerified($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConsentVerified() => $_has(8);
  @$pb.TagNumber(9)
  void clearConsentVerified() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get consentRecordId => $_getSZ(9);
  @$pb.TagNumber(10)
  set consentRecordId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasConsentRecordId() => $_has(9);
  @$pb.TagNumber(10)
  void clearConsentRecordId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isDefault => $_getBF(10);
  @$pb.TagNumber(11)
  set isDefault($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsDefault() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsDefault() => $_clearField(11);

  @$pb.TagNumber(12)
  CharacterStatus get status => $_getN(11);
  @$pb.TagNumber(12)
  set status(CharacterStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get characterPackId => $_getSZ(12);
  @$pb.TagNumber(13)
  set characterPackId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCharacterPackId() => $_has(12);
  @$pb.TagNumber(13)
  void clearCharacterPackId() => $_clearField(13);

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

  @$pb.TagNumber(15)
  $1.Timestamp get updatedAt => $_getN(14);
  @$pb.TagNumber(15)
  set updatedAt($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasUpdatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearUpdatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureUpdatedAt() => $_ensure(14);
}

class CharacterServiceCreateRequest extends $pb.GeneratedMessage {
  factory CharacterServiceCreateRequest({
    $core.String? workspaceId,
    $core.String? name,
    CharacterType? characterType,
    $core.String? description,
    $core.String? referenceImagesJson,
    $core.String? voiceSettingsJson,
    $core.String? visualSettingsJson,
    $core.bool? isDefault,
    $core.String? consentRecordId,
    $core.int? wizardStep,
    $core.bool? previewVerified,
    $core.String? previewVideoUrl,
  }) {
    final result = CharacterServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (name != null) result.name = name;
    if (characterType != null) result.characterType = characterType;
    if (description != null) result.description = description;
    if (referenceImagesJson != null)
      result.referenceImagesJson = referenceImagesJson;
    if (voiceSettingsJson != null) result.voiceSettingsJson = voiceSettingsJson;
    if (visualSettingsJson != null)
      result.visualSettingsJson = visualSettingsJson;
    if (isDefault != null) result.isDefault = isDefault;
    if (consentRecordId != null) result.consentRecordId = consentRecordId;
    if (wizardStep != null) result.wizardStep = wizardStep;
    if (previewVerified != null) result.previewVerified = previewVerified;
    if (previewVideoUrl != null) result.previewVideoUrl = previewVideoUrl;
    return result;
  }

  CharacterServiceCreateRequest._();

  factory CharacterServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory CharacterServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aE<CharacterType>(3, _omitFieldNames ? '' : 'characterType',
        enumValues: CharacterType.values)
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'referenceImagesJson')
    ..aOS(6, _omitFieldNames ? '' : 'voiceSettingsJson')
    ..aOS(7, _omitFieldNames ? '' : 'visualSettingsJson')
    ..aOB(8, _omitFieldNames ? '' : 'isDefault')
    ..aOS(9, _omitFieldNames ? '' : 'consentRecordId')
    ..aI(10, _omitFieldNames ? '' : 'wizardStep')
    ..aOB(11, _omitFieldNames ? '' : 'previewVerified')
    ..aOS(12, _omitFieldNames ? '' : 'previewVideoUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceCreateRequest copyWith(
          void Function(CharacterServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceCreateRequest))
          as CharacterServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceCreateRequest() / CharacterServiceCreateRequest.new instead')
  static CharacterServiceCreateRequest create() =>
      CharacterServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceCreateRequest._();
  @$core.override
  CharacterServiceCreateRequest createEmptyInstance() =>
      CharacterServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceCreateRequest>(
          CharacterServiceCreateRequest.$_createMessage);
  static CharacterServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  CharacterType get characterType => $_getN(2);
  @$pb.TagNumber(3)
  set characterType(CharacterType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCharacterType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacterType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get referenceImagesJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set referenceImagesJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReferenceImagesJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearReferenceImagesJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get voiceSettingsJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set voiceSettingsJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVoiceSettingsJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoiceSettingsJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get visualSettingsJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set visualSettingsJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVisualSettingsJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearVisualSettingsJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDefault => $_getBF(7);
  @$pb.TagNumber(8)
  set isDefault($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDefault() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDefault() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get consentRecordId => $_getSZ(8);
  @$pb.TagNumber(9)
  set consentRecordId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConsentRecordId() => $_has(8);
  @$pb.TagNumber(9)
  void clearConsentRecordId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get wizardStep => $_getIZ(9);
  @$pb.TagNumber(10)
  set wizardStep($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWizardStep() => $_has(9);
  @$pb.TagNumber(10)
  void clearWizardStep() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get previewVerified => $_getBF(10);
  @$pb.TagNumber(11)
  set previewVerified($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPreviewVerified() => $_has(10);
  @$pb.TagNumber(11)
  void clearPreviewVerified() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get previewVideoUrl => $_getSZ(11);
  @$pb.TagNumber(12)
  set previewVideoUrl($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPreviewVideoUrl() => $_has(11);
  @$pb.TagNumber(12)
  void clearPreviewVideoUrl() => $_clearField(12);
}

class CharacterServiceCreateResponse extends $pb.GeneratedMessage {
  factory CharacterServiceCreateResponse({
    Character? character,
    ContinuityPack? characterPack,
  }) {
    final result = CharacterServiceCreateResponse._();
    if (character != null) result.character = character;
    if (characterPack != null) result.characterPack = characterPack;
    return result;
  }

  CharacterServiceCreateResponse._();

  factory CharacterServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory CharacterServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceCreateResponse.$_createMessage)
    ..aOM<Character>(1, _omitFieldNames ? '' : 'character',
        subBuilder: Character.$_createMessage)
    ..aOM<ContinuityPack>(2, _omitFieldNames ? '' : 'characterPack',
        subBuilder: ContinuityPack.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceCreateResponse copyWith(
          void Function(CharacterServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceCreateResponse))
          as CharacterServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceCreateResponse() / CharacterServiceCreateResponse.new instead')
  static CharacterServiceCreateResponse create() =>
      CharacterServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceCreateResponse._();
  @$core.override
  CharacterServiceCreateResponse createEmptyInstance() =>
      CharacterServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceCreateResponse>(
          CharacterServiceCreateResponse.$_createMessage);
  static CharacterServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Character get character => $_getN(0);
  @$pb.TagNumber(1)
  set character(Character value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacter() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacter() => $_clearField(1);
  @$pb.TagNumber(1)
  Character ensureCharacter() => $_ensure(0);

  @$pb.TagNumber(2)
  ContinuityPack get characterPack => $_getN(1);
  @$pb.TagNumber(2)
  set characterPack(ContinuityPack value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCharacterPack() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacterPack() => $_clearField(2);
  @$pb.TagNumber(2)
  ContinuityPack ensureCharacterPack() => $_ensure(1);
}

class CharacterServiceGetRequest extends $pb.GeneratedMessage {
  factory CharacterServiceGetRequest({
    $core.String? workspaceId,
    $core.String? characterId,
  }) {
    final result = CharacterServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (characterId != null) result.characterId = characterId;
    return result;
  }

  CharacterServiceGetRequest._();

  factory CharacterServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceGetRequest()..mergeFromBuffer(data, registry);
  factory CharacterServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'characterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceGetRequest copyWith(
          void Function(CharacterServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceGetRequest))
          as CharacterServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceGetRequest() / CharacterServiceGetRequest.new instead')
  static CharacterServiceGetRequest create() => CharacterServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceGetRequest._();
  @$core.override
  CharacterServiceGetRequest createEmptyInstance() =>
      CharacterServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceGetRequest>(
          CharacterServiceGetRequest.$_createMessage);
  static CharacterServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get characterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set characterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCharacterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacterId() => $_clearField(2);
}

class CharacterServiceGetResponse extends $pb.GeneratedMessage {
  factory CharacterServiceGetResponse({
    Character? character,
    ContinuityPack? characterPack,
  }) {
    final result = CharacterServiceGetResponse._();
    if (character != null) result.character = character;
    if (characterPack != null) result.characterPack = characterPack;
    return result;
  }

  CharacterServiceGetResponse._();

  factory CharacterServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceGetResponse()..mergeFromBuffer(data, registry);
  factory CharacterServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceGetResponse.$_createMessage)
    ..aOM<Character>(1, _omitFieldNames ? '' : 'character',
        subBuilder: Character.$_createMessage)
    ..aOM<ContinuityPack>(2, _omitFieldNames ? '' : 'characterPack',
        subBuilder: ContinuityPack.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceGetResponse copyWith(
          void Function(CharacterServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceGetResponse))
          as CharacterServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceGetResponse() / CharacterServiceGetResponse.new instead')
  static CharacterServiceGetResponse create() =>
      CharacterServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceGetResponse._();
  @$core.override
  CharacterServiceGetResponse createEmptyInstance() =>
      CharacterServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceGetResponse>(
          CharacterServiceGetResponse.$_createMessage);
  static CharacterServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Character get character => $_getN(0);
  @$pb.TagNumber(1)
  set character(Character value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacter() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacter() => $_clearField(1);
  @$pb.TagNumber(1)
  Character ensureCharacter() => $_ensure(0);

  @$pb.TagNumber(2)
  ContinuityPack get characterPack => $_getN(1);
  @$pb.TagNumber(2)
  set characterPack(ContinuityPack value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCharacterPack() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacterPack() => $_clearField(2);
  @$pb.TagNumber(2)
  ContinuityPack ensureCharacterPack() => $_ensure(1);
}

class CharacterServiceListRequest extends $pb.GeneratedMessage {
  factory CharacterServiceListRequest({
    $core.String? workspaceId,
    CharacterStatus? statusFilter,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = CharacterServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  CharacterServiceListRequest._();

  factory CharacterServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceListRequest()..mergeFromBuffer(data, registry);
  factory CharacterServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<CharacterStatus>(2, _omitFieldNames ? '' : 'statusFilter',
        enumValues: CharacterStatus.values)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aOS(4, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceListRequest copyWith(
          void Function(CharacterServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceListRequest))
          as CharacterServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceListRequest() / CharacterServiceListRequest.new instead')
  static CharacterServiceListRequest create() =>
      CharacterServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceListRequest._();
  @$core.override
  CharacterServiceListRequest createEmptyInstance() =>
      CharacterServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceListRequest>(
          CharacterServiceListRequest.$_createMessage);
  static CharacterServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  CharacterStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter(CharacterStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pageToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set pageToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageToken() => $_clearField(4);
}

class CharacterServiceListResponse extends $pb.GeneratedMessage {
  factory CharacterServiceListResponse({
    $core.Iterable<Character>? characters,
    $core.String? nextPageToken,
    $core.int? totalCount,
    $core.int? activeCharacterCount,
    $core.int? slotQuota,
  }) {
    final result = CharacterServiceListResponse._();
    if (characters != null) result.characters.addAll(characters);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    if (activeCharacterCount != null)
      result.activeCharacterCount = activeCharacterCount;
    if (slotQuota != null) result.slotQuota = slotQuota;
    return result;
  }

  CharacterServiceListResponse._();

  factory CharacterServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceListResponse()..mergeFromBuffer(data, registry);
  factory CharacterServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceListResponse.$_createMessage)
    ..pPM<Character>(1, _omitFieldNames ? '' : 'characters',
        subBuilder: Character.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..aI(4, _omitFieldNames ? '' : 'activeCharacterCount')
    ..aI(5, _omitFieldNames ? '' : 'slotQuota')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceListResponse copyWith(
          void Function(CharacterServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceListResponse))
          as CharacterServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceListResponse() / CharacterServiceListResponse.new instead')
  static CharacterServiceListResponse create() =>
      CharacterServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceListResponse._();
  @$core.override
  CharacterServiceListResponse createEmptyInstance() =>
      CharacterServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceListResponse>(
          CharacterServiceListResponse.$_createMessage);
  static CharacterServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Character> get characters => $_getList(0);

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

  @$pb.TagNumber(4)
  $core.int get activeCharacterCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set activeCharacterCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActiveCharacterCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearActiveCharacterCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get slotQuota => $_getIZ(4);
  @$pb.TagNumber(5)
  set slotQuota($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSlotQuota() => $_has(4);
  @$pb.TagNumber(5)
  void clearSlotQuota() => $_clearField(5);
}

class CharacterServiceUpdateRequest extends $pb.GeneratedMessage {
  factory CharacterServiceUpdateRequest({
    $core.String? workspaceId,
    $core.String? characterId,
    $core.String? name,
    $core.String? description,
    $core.String? referenceImagesJson,
    $core.String? voiceSettingsJson,
    $core.String? visualSettingsJson,
    $core.bool? isDefault,
    CharacterStatus? status,
  }) {
    final result = CharacterServiceUpdateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (characterId != null) result.characterId = characterId;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (referenceImagesJson != null)
      result.referenceImagesJson = referenceImagesJson;
    if (voiceSettingsJson != null) result.voiceSettingsJson = voiceSettingsJson;
    if (visualSettingsJson != null)
      result.visualSettingsJson = visualSettingsJson;
    if (isDefault != null) result.isDefault = isDefault;
    if (status != null) result.status = status;
    return result;
  }

  CharacterServiceUpdateRequest._();

  factory CharacterServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory CharacterServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'characterId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'referenceImagesJson')
    ..aOS(6, _omitFieldNames ? '' : 'voiceSettingsJson')
    ..aOS(7, _omitFieldNames ? '' : 'visualSettingsJson')
    ..aOB(8, _omitFieldNames ? '' : 'isDefault')
    ..aE<CharacterStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: CharacterStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceUpdateRequest copyWith(
          void Function(CharacterServiceUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceUpdateRequest))
          as CharacterServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceUpdateRequest() / CharacterServiceUpdateRequest.new instead')
  static CharacterServiceUpdateRequest create() =>
      CharacterServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceUpdateRequest._();
  @$core.override
  CharacterServiceUpdateRequest createEmptyInstance() =>
      CharacterServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceUpdateRequest>(
          CharacterServiceUpdateRequest.$_createMessage);
  static CharacterServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

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
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get referenceImagesJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set referenceImagesJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReferenceImagesJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearReferenceImagesJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get voiceSettingsJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set voiceSettingsJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVoiceSettingsJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoiceSettingsJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get visualSettingsJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set visualSettingsJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVisualSettingsJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearVisualSettingsJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDefault => $_getBF(7);
  @$pb.TagNumber(8)
  set isDefault($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDefault() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDefault() => $_clearField(8);

  @$pb.TagNumber(9)
  CharacterStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(CharacterStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);
}

class CharacterServiceUpdateResponse extends $pb.GeneratedMessage {
  factory CharacterServiceUpdateResponse({
    Character? character,
  }) {
    final result = CharacterServiceUpdateResponse._();
    if (character != null) result.character = character;
    return result;
  }

  CharacterServiceUpdateResponse._();

  factory CharacterServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory CharacterServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceUpdateResponse.$_createMessage)
    ..aOM<Character>(1, _omitFieldNames ? '' : 'character',
        subBuilder: Character.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceUpdateResponse copyWith(
          void Function(CharacterServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceUpdateResponse))
          as CharacterServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceUpdateResponse() / CharacterServiceUpdateResponse.new instead')
  static CharacterServiceUpdateResponse create() =>
      CharacterServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceUpdateResponse._();
  @$core.override
  CharacterServiceUpdateResponse createEmptyInstance() =>
      CharacterServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceUpdateResponse>(
          CharacterServiceUpdateResponse.$_createMessage);
  static CharacterServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Character get character => $_getN(0);
  @$pb.TagNumber(1)
  set character(Character value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacter() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacter() => $_clearField(1);
  @$pb.TagNumber(1)
  Character ensureCharacter() => $_ensure(0);
}

class CharacterServiceDeleteRequest extends $pb.GeneratedMessage {
  factory CharacterServiceDeleteRequest({
    $core.String? workspaceId,
    $core.String? characterId,
    $core.bool? hardDelete,
  }) {
    final result = CharacterServiceDeleteRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (characterId != null) result.characterId = characterId;
    if (hardDelete != null) result.hardDelete = hardDelete;
    return result;
  }

  CharacterServiceDeleteRequest._();

  factory CharacterServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory CharacterServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceDeleteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'characterId')
    ..aOB(3, _omitFieldNames ? '' : 'hardDelete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceDeleteRequest copyWith(
          void Function(CharacterServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceDeleteRequest))
          as CharacterServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceDeleteRequest() / CharacterServiceDeleteRequest.new instead')
  static CharacterServiceDeleteRequest create() =>
      CharacterServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceDeleteRequest._();
  @$core.override
  CharacterServiceDeleteRequest createEmptyInstance() =>
      CharacterServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceDeleteRequest>(
          CharacterServiceDeleteRequest.$_createMessage);
  static CharacterServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get characterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set characterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCharacterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hardDelete => $_getBF(2);
  @$pb.TagNumber(3)
  set hardDelete($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHardDelete() => $_has(2);
  @$pb.TagNumber(3)
  void clearHardDelete() => $_clearField(3);
}

class CharacterServiceDeleteResponse extends $pb.GeneratedMessage {
  factory CharacterServiceDeleteResponse({
    $core.bool? success,
    CharacterStatus? newStatus,
  }) {
    final result = CharacterServiceDeleteResponse._();
    if (success != null) result.success = success;
    if (newStatus != null) result.newStatus = newStatus;
    return result;
  }

  CharacterServiceDeleteResponse._();

  factory CharacterServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory CharacterServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: CharacterServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aE<CharacterStatus>(2, _omitFieldNames ? '' : 'newStatus',
        enumValues: CharacterStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterServiceDeleteResponse copyWith(
          void Function(CharacterServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CharacterServiceDeleteResponse))
          as CharacterServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CharacterServiceDeleteResponse() / CharacterServiceDeleteResponse.new instead')
  static CharacterServiceDeleteResponse create() =>
      CharacterServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CharacterServiceDeleteResponse._();
  @$core.override
  CharacterServiceDeleteResponse createEmptyInstance() =>
      CharacterServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static CharacterServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacterServiceDeleteResponse>(
          CharacterServiceDeleteResponse.$_createMessage);
  static CharacterServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  CharacterStatus get newStatus => $_getN(1);
  @$pb.TagNumber(2)
  set newStatus(CharacterStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNewStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewStatus() => $_clearField(2);
}

class ContinuityServiceCreateRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceCreateRequest({
    $core.String? workspaceId,
    PackType? packType,
    $core.String? name,
    $core.String? characterId,
    $core.Iterable<ApprovedReference>? approvedReferences,
    $core.String? rulesSummary,
    $core.String? settingsJson,
    $core.String? allowedUseScopeJson,
  }) {
    final result = ContinuityServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packType != null) result.packType = packType;
    if (name != null) result.name = name;
    if (characterId != null) result.characterId = characterId;
    if (approvedReferences != null)
      result.approvedReferences.addAll(approvedReferences);
    if (rulesSummary != null) result.rulesSummary = rulesSummary;
    if (settingsJson != null) result.settingsJson = settingsJson;
    if (allowedUseScopeJson != null)
      result.allowedUseScopeJson = allowedUseScopeJson;
    return result;
  }

  ContinuityServiceCreateRequest._();

  factory ContinuityServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<PackType>(2, _omitFieldNames ? '' : 'packType',
        enumValues: PackType.values)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'characterId')
    ..pPM<ApprovedReference>(5, _omitFieldNames ? '' : 'approvedReferences',
        subBuilder: ApprovedReference.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'rulesSummary')
    ..aOS(7, _omitFieldNames ? '' : 'settingsJson')
    ..aOS(8, _omitFieldNames ? '' : 'allowedUseScopeJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceCreateRequest copyWith(
          void Function(ContinuityServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceCreateRequest))
          as ContinuityServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceCreateRequest() / ContinuityServiceCreateRequest.new instead')
  static ContinuityServiceCreateRequest create() =>
      ContinuityServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceCreateRequest._();
  @$core.override
  ContinuityServiceCreateRequest createEmptyInstance() =>
      ContinuityServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceCreateRequest>(
          ContinuityServiceCreateRequest.$_createMessage);
  static ContinuityServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  PackType get packType => $_getN(1);
  @$pb.TagNumber(2)
  set packType(PackType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPackType() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get characterId => $_getSZ(3);
  @$pb.TagNumber(4)
  set characterId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCharacterId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCharacterId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ApprovedReference> get approvedReferences => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get rulesSummary => $_getSZ(5);
  @$pb.TagNumber(6)
  set rulesSummary($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRulesSummary() => $_has(5);
  @$pb.TagNumber(6)
  void clearRulesSummary() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get settingsJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set settingsJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSettingsJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearSettingsJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get allowedUseScopeJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set allowedUseScopeJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAllowedUseScopeJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearAllowedUseScopeJson() => $_clearField(8);
}

class ContinuityServiceCreateResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceCreateResponse({
    ContinuityPack? pack,
  }) {
    final result = ContinuityServiceCreateResponse._();
    if (pack != null) result.pack = pack;
    return result;
  }

  ContinuityServiceCreateResponse._();

  factory ContinuityServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory ContinuityServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceCreateResponse.$_createMessage)
    ..aOM<ContinuityPack>(1, _omitFieldNames ? '' : 'pack',
        subBuilder: ContinuityPack.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceCreateResponse copyWith(
          void Function(ContinuityServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceCreateResponse))
          as ContinuityServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceCreateResponse() / ContinuityServiceCreateResponse.new instead')
  static ContinuityServiceCreateResponse create() =>
      ContinuityServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceCreateResponse._();
  @$core.override
  ContinuityServiceCreateResponse createEmptyInstance() =>
      ContinuityServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceCreateResponse>(
          ContinuityServiceCreateResponse.$_createMessage);
  static ContinuityServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ContinuityPack get pack => $_getN(0);
  @$pb.TagNumber(1)
  set pack(ContinuityPack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);
  @$pb.TagNumber(1)
  ContinuityPack ensurePack() => $_ensure(0);
}

class ContinuityServiceGetRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceGetRequest({
    $core.String? workspaceId,
    $core.String? packId,
  }) {
    final result = ContinuityServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packId != null) result.packId = packId;
    return result;
  }

  ContinuityServiceGetRequest._();

  factory ContinuityServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetRequest copyWith(
          void Function(ContinuityServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceGetRequest))
          as ContinuityServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceGetRequest() / ContinuityServiceGetRequest.new instead')
  static ContinuityServiceGetRequest create() =>
      ContinuityServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceGetRequest._();
  @$core.override
  ContinuityServiceGetRequest createEmptyInstance() =>
      ContinuityServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceGetRequest>(
          ContinuityServiceGetRequest.$_createMessage);
  static ContinuityServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);
}

class ContinuityServiceGetResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceGetResponse({
    ContinuityPack? pack,
    $core.Iterable<PackVersion>? versionHistory,
  }) {
    final result = ContinuityServiceGetResponse._();
    if (pack != null) result.pack = pack;
    if (versionHistory != null) result.versionHistory.addAll(versionHistory);
    return result;
  }

  ContinuityServiceGetResponse._();

  factory ContinuityServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetResponse()..mergeFromBuffer(data, registry);
  factory ContinuityServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceGetResponse.$_createMessage)
    ..aOM<ContinuityPack>(1, _omitFieldNames ? '' : 'pack',
        subBuilder: ContinuityPack.$_createMessage)
    ..pPM<PackVersion>(2, _omitFieldNames ? '' : 'versionHistory',
        subBuilder: PackVersion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetResponse copyWith(
          void Function(ContinuityServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceGetResponse))
          as ContinuityServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceGetResponse() / ContinuityServiceGetResponse.new instead')
  static ContinuityServiceGetResponse create() =>
      ContinuityServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceGetResponse._();
  @$core.override
  ContinuityServiceGetResponse createEmptyInstance() =>
      ContinuityServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceGetResponse>(
          ContinuityServiceGetResponse.$_createMessage);
  static ContinuityServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ContinuityPack get pack => $_getN(0);
  @$pb.TagNumber(1)
  set pack(ContinuityPack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);
  @$pb.TagNumber(1)
  ContinuityPack ensurePack() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PackVersion> get versionHistory => $_getList(1);
}

class ContinuityServiceGetPackRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceGetPackRequest({
    $core.String? workspaceId,
    $core.String? packId,
  }) {
    final result = ContinuityServiceGetPackRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packId != null) result.packId = packId;
    return result;
  }

  ContinuityServiceGetPackRequest._();

  factory ContinuityServiceGetPackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetPackRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceGetPackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetPackRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceGetPackRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceGetPackRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetPackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetPackRequest copyWith(
          void Function(ContinuityServiceGetPackRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceGetPackRequest))
          as ContinuityServiceGetPackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceGetPackRequest() / ContinuityServiceGetPackRequest.new instead')
  static ContinuityServiceGetPackRequest create() =>
      ContinuityServiceGetPackRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceGetPackRequest._();
  @$core.override
  ContinuityServiceGetPackRequest createEmptyInstance() =>
      ContinuityServiceGetPackRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceGetPackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceGetPackRequest>(
          ContinuityServiceGetPackRequest.$_createMessage);
  static ContinuityServiceGetPackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);
}

class ContinuityServiceGetPackResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceGetPackResponse({
    ContinuityPack? pack,
    $core.Iterable<PackVersion>? versionHistory,
  }) {
    final result = ContinuityServiceGetPackResponse._();
    if (pack != null) result.pack = pack;
    if (versionHistory != null) result.versionHistory.addAll(versionHistory);
    return result;
  }

  ContinuityServiceGetPackResponse._();

  factory ContinuityServiceGetPackResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetPackResponse()..mergeFromBuffer(data, registry);
  factory ContinuityServiceGetPackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetPackResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceGetPackResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceGetPackResponse.$_createMessage)
    ..aOM<ContinuityPack>(1, _omitFieldNames ? '' : 'pack',
        subBuilder: ContinuityPack.$_createMessage)
    ..pPM<PackVersion>(2, _omitFieldNames ? '' : 'versionHistory',
        subBuilder: PackVersion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetPackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetPackResponse copyWith(
          void Function(ContinuityServiceGetPackResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceGetPackResponse))
          as ContinuityServiceGetPackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceGetPackResponse() / ContinuityServiceGetPackResponse.new instead')
  static ContinuityServiceGetPackResponse create() =>
      ContinuityServiceGetPackResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceGetPackResponse._();
  @$core.override
  ContinuityServiceGetPackResponse createEmptyInstance() =>
      ContinuityServiceGetPackResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceGetPackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceGetPackResponse>(
          ContinuityServiceGetPackResponse.$_createMessage);
  static ContinuityServiceGetPackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ContinuityPack get pack => $_getN(0);
  @$pb.TagNumber(1)
  set pack(ContinuityPack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);
  @$pb.TagNumber(1)
  ContinuityPack ensurePack() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PackVersion> get versionHistory => $_getList(1);
}

class ContinuityServiceUpdatePackRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceUpdatePackRequest({
    $core.String? workspaceId,
    $core.String? packId,
    $core.String? name,
    $core.Iterable<ApprovedReference>? approvedReferences,
    $core.String? rulesSummary,
    $core.String? settingsJson,
    $core.String? allowedUseScopeJson,
    PackStatus? status,
    $core.String? updateReason,
  }) {
    final result = ContinuityServiceUpdatePackRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packId != null) result.packId = packId;
    if (name != null) result.name = name;
    if (approvedReferences != null)
      result.approvedReferences.addAll(approvedReferences);
    if (rulesSummary != null) result.rulesSummary = rulesSummary;
    if (settingsJson != null) result.settingsJson = settingsJson;
    if (allowedUseScopeJson != null)
      result.allowedUseScopeJson = allowedUseScopeJson;
    if (status != null) result.status = status;
    if (updateReason != null) result.updateReason = updateReason;
    return result;
  }

  ContinuityServiceUpdatePackRequest._();

  factory ContinuityServiceUpdatePackRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceUpdatePackRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceUpdatePackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceUpdatePackRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceUpdatePackRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceUpdatePackRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..pPM<ApprovedReference>(4, _omitFieldNames ? '' : 'approvedReferences',
        subBuilder: ApprovedReference.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'rulesSummary')
    ..aOS(6, _omitFieldNames ? '' : 'settingsJson')
    ..aOS(7, _omitFieldNames ? '' : 'allowedUseScopeJson')
    ..aE<PackStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: PackStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'updateReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceUpdatePackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceUpdatePackRequest copyWith(
          void Function(ContinuityServiceUpdatePackRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceUpdatePackRequest))
          as ContinuityServiceUpdatePackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceUpdatePackRequest() / ContinuityServiceUpdatePackRequest.new instead')
  static ContinuityServiceUpdatePackRequest create() =>
      ContinuityServiceUpdatePackRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceUpdatePackRequest._();
  @$core.override
  ContinuityServiceUpdatePackRequest createEmptyInstance() =>
      ContinuityServiceUpdatePackRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceUpdatePackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceUpdatePackRequest>(
          ContinuityServiceUpdatePackRequest.$_createMessage);
  static ContinuityServiceUpdatePackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ApprovedReference> get approvedReferences => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get rulesSummary => $_getSZ(4);
  @$pb.TagNumber(5)
  set rulesSummary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRulesSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearRulesSummary() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get settingsJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set settingsJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSettingsJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearSettingsJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get allowedUseScopeJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set allowedUseScopeJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAllowedUseScopeJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearAllowedUseScopeJson() => $_clearField(7);

  @$pb.TagNumber(8)
  PackStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(PackStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get updateReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set updateReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdateReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdateReason() => $_clearField(9);
}

class ContinuityServiceUpdatePackResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceUpdatePackResponse({
    ContinuityPack? pack,
    PackVersion? archivedVersion,
  }) {
    final result = ContinuityServiceUpdatePackResponse._();
    if (pack != null) result.pack = pack;
    if (archivedVersion != null) result.archivedVersion = archivedVersion;
    return result;
  }

  ContinuityServiceUpdatePackResponse._();

  factory ContinuityServiceUpdatePackResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceUpdatePackResponse()..mergeFromBuffer(data, registry);
  factory ContinuityServiceUpdatePackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceUpdatePackResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceUpdatePackResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceUpdatePackResponse.$_createMessage)
    ..aOM<ContinuityPack>(1, _omitFieldNames ? '' : 'pack',
        subBuilder: ContinuityPack.$_createMessage)
    ..aOM<PackVersion>(2, _omitFieldNames ? '' : 'archivedVersion',
        subBuilder: PackVersion.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceUpdatePackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceUpdatePackResponse copyWith(
          void Function(ContinuityServiceUpdatePackResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceUpdatePackResponse))
          as ContinuityServiceUpdatePackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceUpdatePackResponse() / ContinuityServiceUpdatePackResponse.new instead')
  static ContinuityServiceUpdatePackResponse create() =>
      ContinuityServiceUpdatePackResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceUpdatePackResponse._();
  @$core.override
  ContinuityServiceUpdatePackResponse createEmptyInstance() =>
      ContinuityServiceUpdatePackResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceUpdatePackResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ContinuityServiceUpdatePackResponse>(
          ContinuityServiceUpdatePackResponse.$_createMessage);
  static ContinuityServiceUpdatePackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ContinuityPack get pack => $_getN(0);
  @$pb.TagNumber(1)
  set pack(ContinuityPack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);
  @$pb.TagNumber(1)
  ContinuityPack ensurePack() => $_ensure(0);

  @$pb.TagNumber(2)
  PackVersion get archivedVersion => $_getN(1);
  @$pb.TagNumber(2)
  set archivedVersion(PackVersion value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasArchivedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearArchivedVersion() => $_clearField(2);
  @$pb.TagNumber(2)
  PackVersion ensureArchivedVersion() => $_ensure(1);
}

class ContinuityServiceCloneRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceCloneRequest({
    $core.String? workspaceId,
    $core.String? sourcePackId,
    $core.String? newName,
  }) {
    final result = ContinuityServiceCloneRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sourcePackId != null) result.sourcePackId = sourcePackId;
    if (newName != null) result.newName = newName;
    return result;
  }

  ContinuityServiceCloneRequest._();

  factory ContinuityServiceCloneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceCloneRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceCloneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceCloneRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceCloneRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceCloneRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sourcePackId')
    ..aOS(3, _omitFieldNames ? '' : 'newName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceCloneRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceCloneRequest copyWith(
          void Function(ContinuityServiceCloneRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceCloneRequest))
          as ContinuityServiceCloneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceCloneRequest() / ContinuityServiceCloneRequest.new instead')
  static ContinuityServiceCloneRequest create() =>
      ContinuityServiceCloneRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceCloneRequest._();
  @$core.override
  ContinuityServiceCloneRequest createEmptyInstance() =>
      ContinuityServiceCloneRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceCloneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceCloneRequest>(
          ContinuityServiceCloneRequest.$_createMessage);
  static ContinuityServiceCloneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourcePackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourcePackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourcePackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourcePackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newName => $_getSZ(2);
  @$pb.TagNumber(3)
  set newName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewName() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewName() => $_clearField(3);
}

class ContinuityServiceCloneResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceCloneResponse({
    ContinuityPack? pack,
  }) {
    final result = ContinuityServiceCloneResponse._();
    if (pack != null) result.pack = pack;
    return result;
  }

  ContinuityServiceCloneResponse._();

  factory ContinuityServiceCloneResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceCloneResponse()..mergeFromBuffer(data, registry);
  factory ContinuityServiceCloneResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceCloneResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceCloneResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceCloneResponse.$_createMessage)
    ..aOM<ContinuityPack>(1, _omitFieldNames ? '' : 'pack',
        subBuilder: ContinuityPack.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceCloneResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceCloneResponse copyWith(
          void Function(ContinuityServiceCloneResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceCloneResponse))
          as ContinuityServiceCloneResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceCloneResponse() / ContinuityServiceCloneResponse.new instead')
  static ContinuityServiceCloneResponse create() =>
      ContinuityServiceCloneResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceCloneResponse._();
  @$core.override
  ContinuityServiceCloneResponse createEmptyInstance() =>
      ContinuityServiceCloneResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceCloneResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceCloneResponse>(
          ContinuityServiceCloneResponse.$_createMessage);
  static ContinuityServiceCloneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ContinuityPack get pack => $_getN(0);
  @$pb.TagNumber(1)
  set pack(ContinuityPack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);
  @$pb.TagNumber(1)
  ContinuityPack ensurePack() => $_ensure(0);
}

class ContinuityServiceDeleteRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceDeleteRequest({
    $core.String? workspaceId,
    $core.String? packId,
  }) {
    final result = ContinuityServiceDeleteRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packId != null) result.packId = packId;
    return result;
  }

  ContinuityServiceDeleteRequest._();

  factory ContinuityServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceDeleteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceDeleteRequest copyWith(
          void Function(ContinuityServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceDeleteRequest))
          as ContinuityServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceDeleteRequest() / ContinuityServiceDeleteRequest.new instead')
  static ContinuityServiceDeleteRequest create() =>
      ContinuityServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceDeleteRequest._();
  @$core.override
  ContinuityServiceDeleteRequest createEmptyInstance() =>
      ContinuityServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceDeleteRequest>(
          ContinuityServiceDeleteRequest.$_createMessage);
  static ContinuityServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);
}

class ContinuityServiceDeleteResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = ContinuityServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  ContinuityServiceDeleteResponse._();

  factory ContinuityServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory ContinuityServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceDeleteResponse copyWith(
          void Function(ContinuityServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ContinuityServiceDeleteResponse))
          as ContinuityServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceDeleteResponse() / ContinuityServiceDeleteResponse.new instead')
  static ContinuityServiceDeleteResponse create() =>
      ContinuityServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceDeleteResponse._();
  @$core.override
  ContinuityServiceDeleteResponse createEmptyInstance() =>
      ContinuityServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceDeleteResponse>(
          ContinuityServiceDeleteResponse.$_createMessage);
  static ContinuityServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ContinuityServiceGetUsageStatsRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceGetUsageStatsRequest({
    $core.String? workspaceId,
    $core.String? packId,
  }) {
    final result = ContinuityServiceGetUsageStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packId != null) result.packId = packId;
    return result;
  }

  ContinuityServiceGetUsageStatsRequest._();

  factory ContinuityServiceGetUsageStatsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetUsageStatsRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceGetUsageStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetUsageStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceGetUsageStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance:
          ContinuityServiceGetUsageStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetUsageStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetUsageStatsRequest copyWith(
          void Function(ContinuityServiceGetUsageStatsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceGetUsageStatsRequest))
          as ContinuityServiceGetUsageStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceGetUsageStatsRequest() / ContinuityServiceGetUsageStatsRequest.new instead')
  static ContinuityServiceGetUsageStatsRequest create() =>
      ContinuityServiceGetUsageStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceGetUsageStatsRequest._();
  @$core.override
  ContinuityServiceGetUsageStatsRequest createEmptyInstance() =>
      ContinuityServiceGetUsageStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceGetUsageStatsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ContinuityServiceGetUsageStatsRequest>(
          ContinuityServiceGetUsageStatsRequest.$_createMessage);
  static ContinuityServiceGetUsageStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);
}

class ContinuityServiceGetUsageStatsResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceGetUsageStatsResponse({
    $core.String? packId,
    $core.int? totalAssetsGenerated,
    $core.int? driftWarningsCount,
    $core.Iterable<$core.String>? recentAssetIds,
  }) {
    final result = ContinuityServiceGetUsageStatsResponse._();
    if (packId != null) result.packId = packId;
    if (totalAssetsGenerated != null)
      result.totalAssetsGenerated = totalAssetsGenerated;
    if (driftWarningsCount != null)
      result.driftWarningsCount = driftWarningsCount;
    if (recentAssetIds != null) result.recentAssetIds.addAll(recentAssetIds);
    return result;
  }

  ContinuityServiceGetUsageStatsResponse._();

  factory ContinuityServiceGetUsageStatsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetUsageStatsResponse()..mergeFromBuffer(data, registry);
  factory ContinuityServiceGetUsageStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceGetUsageStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceGetUsageStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance:
          ContinuityServiceGetUsageStatsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'packId')
    ..aI(2, _omitFieldNames ? '' : 'totalAssetsGenerated')
    ..aI(3, _omitFieldNames ? '' : 'driftWarningsCount')
    ..pPS(4, _omitFieldNames ? '' : 'recentAssetIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetUsageStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceGetUsageStatsResponse copyWith(
          void Function(ContinuityServiceGetUsageStatsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceGetUsageStatsResponse))
          as ContinuityServiceGetUsageStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceGetUsageStatsResponse() / ContinuityServiceGetUsageStatsResponse.new instead')
  static ContinuityServiceGetUsageStatsResponse create() =>
      ContinuityServiceGetUsageStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceGetUsageStatsResponse._();
  @$core.override
  ContinuityServiceGetUsageStatsResponse createEmptyInstance() =>
      ContinuityServiceGetUsageStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceGetUsageStatsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ContinuityServiceGetUsageStatsResponse>(
          ContinuityServiceGetUsageStatsResponse.$_createMessage);
  static ContinuityServiceGetUsageStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packId => $_getSZ(0);
  @$pb.TagNumber(1)
  set packId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalAssetsGenerated => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalAssetsGenerated($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalAssetsGenerated() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalAssetsGenerated() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get driftWarningsCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set driftWarningsCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDriftWarningsCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearDriftWarningsCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get recentAssetIds => $_getList(3);
}

class ContinuityServiceListBrandPacksRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceListBrandPacksRequest({
    $core.String? workspaceId,
  }) {
    final result = ContinuityServiceListBrandPacksRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  ContinuityServiceListBrandPacksRequest._();

  factory ContinuityServiceListBrandPacksRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListBrandPacksRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceListBrandPacksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListBrandPacksRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceListBrandPacksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance:
          ContinuityServiceListBrandPacksRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListBrandPacksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListBrandPacksRequest copyWith(
          void Function(ContinuityServiceListBrandPacksRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceListBrandPacksRequest))
          as ContinuityServiceListBrandPacksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceListBrandPacksRequest() / ContinuityServiceListBrandPacksRequest.new instead')
  static ContinuityServiceListBrandPacksRequest create() =>
      ContinuityServiceListBrandPacksRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceListBrandPacksRequest._();
  @$core.override
  ContinuityServiceListBrandPacksRequest createEmptyInstance() =>
      ContinuityServiceListBrandPacksRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceListBrandPacksRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ContinuityServiceListBrandPacksRequest>(
          ContinuityServiceListBrandPacksRequest.$_createMessage);
  static ContinuityServiceListBrandPacksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class ContinuityServiceListBrandPacksResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceListBrandPacksResponse({
    $core.Iterable<ContinuityPack>? brandPacks,
  }) {
    final result = ContinuityServiceListBrandPacksResponse._();
    if (brandPacks != null) result.brandPacks.addAll(brandPacks);
    return result;
  }

  ContinuityServiceListBrandPacksResponse._();

  factory ContinuityServiceListBrandPacksResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListBrandPacksResponse()
        ..mergeFromBuffer(data, registry);
  factory ContinuityServiceListBrandPacksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListBrandPacksResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceListBrandPacksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance:
          ContinuityServiceListBrandPacksResponse.$_createMessage)
    ..pPM<ContinuityPack>(1, _omitFieldNames ? '' : 'brandPacks',
        subBuilder: ContinuityPack.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListBrandPacksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListBrandPacksResponse copyWith(
          void Function(ContinuityServiceListBrandPacksResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceListBrandPacksResponse))
          as ContinuityServiceListBrandPacksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceListBrandPacksResponse() / ContinuityServiceListBrandPacksResponse.new instead')
  static ContinuityServiceListBrandPacksResponse create() =>
      ContinuityServiceListBrandPacksResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceListBrandPacksResponse._();
  @$core.override
  ContinuityServiceListBrandPacksResponse createEmptyInstance() =>
      ContinuityServiceListBrandPacksResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceListBrandPacksResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ContinuityServiceListBrandPacksResponse>(
          ContinuityServiceListBrandPacksResponse.$_createMessage);
  static ContinuityServiceListBrandPacksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContinuityPack> get brandPacks => $_getList(0);
}

class ContinuityServiceListCharactersRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceListCharactersRequest({
    $core.String? workspaceId,
    $core.String? packId,
  }) {
    final result = ContinuityServiceListCharactersRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packId != null) result.packId = packId;
    return result;
  }

  ContinuityServiceListCharactersRequest._();

  factory ContinuityServiceListCharactersRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListCharactersRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceListCharactersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListCharactersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceListCharactersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance:
          ContinuityServiceListCharactersRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListCharactersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListCharactersRequest copyWith(
          void Function(ContinuityServiceListCharactersRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceListCharactersRequest))
          as ContinuityServiceListCharactersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceListCharactersRequest() / ContinuityServiceListCharactersRequest.new instead')
  static ContinuityServiceListCharactersRequest create() =>
      ContinuityServiceListCharactersRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceListCharactersRequest._();
  @$core.override
  ContinuityServiceListCharactersRequest createEmptyInstance() =>
      ContinuityServiceListCharactersRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceListCharactersRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ContinuityServiceListCharactersRequest>(
          ContinuityServiceListCharactersRequest.$_createMessage);
  static ContinuityServiceListCharactersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);
}

class ContinuityServiceListCharactersResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceListCharactersResponse({
    $core.Iterable<Character>? characters,
  }) {
    final result = ContinuityServiceListCharactersResponse._();
    if (characters != null) result.characters.addAll(characters);
    return result;
  }

  ContinuityServiceListCharactersResponse._();

  factory ContinuityServiceListCharactersResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListCharactersResponse()
        ..mergeFromBuffer(data, registry);
  factory ContinuityServiceListCharactersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListCharactersResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceListCharactersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance:
          ContinuityServiceListCharactersResponse.$_createMessage)
    ..pPM<Character>(1, _omitFieldNames ? '' : 'characters',
        subBuilder: Character.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListCharactersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListCharactersResponse copyWith(
          void Function(ContinuityServiceListCharactersResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceListCharactersResponse))
          as ContinuityServiceListCharactersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceListCharactersResponse() / ContinuityServiceListCharactersResponse.new instead')
  static ContinuityServiceListCharactersResponse create() =>
      ContinuityServiceListCharactersResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceListCharactersResponse._();
  @$core.override
  ContinuityServiceListCharactersResponse createEmptyInstance() =>
      ContinuityServiceListCharactersResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceListCharactersResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ContinuityServiceListCharactersResponse>(
          ContinuityServiceListCharactersResponse.$_createMessage);
  static ContinuityServiceListCharactersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Character> get characters => $_getList(0);
}

class ContinuityServiceListVoicesRequest extends $pb.GeneratedMessage {
  factory ContinuityServiceListVoicesRequest({
    $core.String? workspaceId,
    $core.String? packId,
  }) {
    final result = ContinuityServiceListVoicesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (packId != null) result.packId = packId;
    return result;
  }

  ContinuityServiceListVoicesRequest._();

  factory ContinuityServiceListVoicesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListVoicesRequest()..mergeFromBuffer(data, registry);
  factory ContinuityServiceListVoicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListVoicesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceListVoicesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceListVoicesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'packId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListVoicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListVoicesRequest copyWith(
          void Function(ContinuityServiceListVoicesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceListVoicesRequest))
          as ContinuityServiceListVoicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceListVoicesRequest() / ContinuityServiceListVoicesRequest.new instead')
  static ContinuityServiceListVoicesRequest create() =>
      ContinuityServiceListVoicesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceListVoicesRequest._();
  @$core.override
  ContinuityServiceListVoicesRequest createEmptyInstance() =>
      ContinuityServiceListVoicesRequest._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceListVoicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContinuityServiceListVoicesRequest>(
          ContinuityServiceListVoicesRequest.$_createMessage);
  static ContinuityServiceListVoicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get packId => $_getSZ(1);
  @$pb.TagNumber(2)
  set packId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackId() => $_clearField(2);
}

class ContinuityServiceListVoicesResponse extends $pb.GeneratedMessage {
  factory ContinuityServiceListVoicesResponse({
    $core.Iterable<ContinuityPack>? voicePacks,
  }) {
    final result = ContinuityServiceListVoicesResponse._();
    if (voicePacks != null) result.voicePacks.addAll(voicePacks);
    return result;
  }

  ContinuityServiceListVoicesResponse._();

  factory ContinuityServiceListVoicesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListVoicesResponse()..mergeFromBuffer(data, registry);
  factory ContinuityServiceListVoicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContinuityServiceListVoicesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContinuityServiceListVoicesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ContinuityServiceListVoicesResponse.$_createMessage)
    ..pPM<ContinuityPack>(1, _omitFieldNames ? '' : 'voicePacks',
        subBuilder: ContinuityPack.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListVoicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContinuityServiceListVoicesResponse copyWith(
          void Function(ContinuityServiceListVoicesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ContinuityServiceListVoicesResponse))
          as ContinuityServiceListVoicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ContinuityServiceListVoicesResponse() / ContinuityServiceListVoicesResponse.new instead')
  static ContinuityServiceListVoicesResponse create() =>
      ContinuityServiceListVoicesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ContinuityServiceListVoicesResponse._();
  @$core.override
  ContinuityServiceListVoicesResponse createEmptyInstance() =>
      ContinuityServiceListVoicesResponse._();
  @$core.pragma('dart2js:noInline')
  static ContinuityServiceListVoicesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ContinuityServiceListVoicesResponse>(
          ContinuityServiceListVoicesResponse.$_createMessage);
  static ContinuityServiceListVoicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContinuityPack> get voicePacks => $_getList(0);
}

class ConsentServiceGrantRequest extends $pb.GeneratedMessage {
  factory ConsentServiceGrantRequest({
    $core.String? userId,
    $core.String? workspaceId,
    $core.String? consentType,
    $core.String? version,
    $core.String? sourceFootageUrl,
    $core.String? consentVideoUrl,
    $core.bool? declarationSigned,
  }) {
    final result = ConsentServiceGrantRequest._();
    if (userId != null) result.userId = userId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (consentType != null) result.consentType = consentType;
    if (version != null) result.version = version;
    if (sourceFootageUrl != null) result.sourceFootageUrl = sourceFootageUrl;
    if (consentVideoUrl != null) result.consentVideoUrl = consentVideoUrl;
    if (declarationSigned != null) result.declarationSigned = declarationSigned;
    return result;
  }

  ConsentServiceGrantRequest._();

  factory ConsentServiceGrantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentServiceGrantRequest()..mergeFromBuffer(data, registry);
  factory ConsentServiceGrantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentServiceGrantRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConsentServiceGrantRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ConsentServiceGrantRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'consentType')
    ..aOS(4, _omitFieldNames ? '' : 'version')
    ..aOS(5, _omitFieldNames ? '' : 'sourceFootageUrl')
    ..aOS(6, _omitFieldNames ? '' : 'consentVideoUrl')
    ..aOB(7, _omitFieldNames ? '' : 'declarationSigned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentServiceGrantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentServiceGrantRequest copyWith(
          void Function(ConsentServiceGrantRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ConsentServiceGrantRequest))
          as ConsentServiceGrantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConsentServiceGrantRequest() / ConsentServiceGrantRequest.new instead')
  static ConsentServiceGrantRequest create() => ConsentServiceGrantRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConsentServiceGrantRequest._();
  @$core.override
  ConsentServiceGrantRequest createEmptyInstance() =>
      ConsentServiceGrantRequest._();
  @$core.pragma('dart2js:noInline')
  static ConsentServiceGrantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConsentServiceGrantRequest>(
          ConsentServiceGrantRequest.$_createMessage);
  static ConsentServiceGrantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get consentType => $_getSZ(2);
  @$pb.TagNumber(3)
  set consentType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConsentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearConsentType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourceFootageUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceFootageUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceFootageUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceFootageUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get consentVideoUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set consentVideoUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConsentVideoUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearConsentVideoUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get declarationSigned => $_getBF(6);
  @$pb.TagNumber(7)
  set declarationSigned($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDeclarationSigned() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeclarationSigned() => $_clearField(7);
}

class ConsentServiceGrantResponse extends $pb.GeneratedMessage {
  factory ConsentServiceGrantResponse({
    ConsentRecord? record,
    $core.bool? faceMatchVerified,
  }) {
    final result = ConsentServiceGrantResponse._();
    if (record != null) result.record = record;
    if (faceMatchVerified != null) result.faceMatchVerified = faceMatchVerified;
    return result;
  }

  ConsentServiceGrantResponse._();

  factory ConsentServiceGrantResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentServiceGrantResponse()..mergeFromBuffer(data, registry);
  factory ConsentServiceGrantResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentServiceGrantResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConsentServiceGrantResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ConsentServiceGrantResponse.$_createMessage)
    ..aOM<ConsentRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: ConsentRecord.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'faceMatchVerified')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentServiceGrantResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentServiceGrantResponse copyWith(
          void Function(ConsentServiceGrantResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ConsentServiceGrantResponse))
          as ConsentServiceGrantResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConsentServiceGrantResponse() / ConsentServiceGrantResponse.new instead')
  static ConsentServiceGrantResponse create() =>
      ConsentServiceGrantResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConsentServiceGrantResponse._();
  @$core.override
  ConsentServiceGrantResponse createEmptyInstance() =>
      ConsentServiceGrantResponse._();
  @$core.pragma('dart2js:noInline')
  static ConsentServiceGrantResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConsentServiceGrantResponse>(
          ConsentServiceGrantResponse.$_createMessage);
  static ConsentServiceGrantResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ConsentRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(ConsentRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  ConsentRecord ensureRecord() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get faceMatchVerified => $_getBF(1);
  @$pb.TagNumber(2)
  set faceMatchVerified($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFaceMatchVerified() => $_has(1);
  @$pb.TagNumber(2)
  void clearFaceMatchVerified() => $_clearField(2);
}

class ConsentServiceRevokeRequest extends $pb.GeneratedMessage {
  factory ConsentServiceRevokeRequest({
    $core.String? userId,
    $core.String? workspaceId,
    $core.String? consentType,
    $core.String? reason,
  }) {
    final result = ConsentServiceRevokeRequest._();
    if (userId != null) result.userId = userId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (consentType != null) result.consentType = consentType;
    if (reason != null) result.reason = reason;
    return result;
  }

  ConsentServiceRevokeRequest._();

  factory ConsentServiceRevokeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentServiceRevokeRequest()..mergeFromBuffer(data, registry);
  factory ConsentServiceRevokeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentServiceRevokeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConsentServiceRevokeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ConsentServiceRevokeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'consentType')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentServiceRevokeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentServiceRevokeRequest copyWith(
          void Function(ConsentServiceRevokeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ConsentServiceRevokeRequest))
          as ConsentServiceRevokeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConsentServiceRevokeRequest() / ConsentServiceRevokeRequest.new instead')
  static ConsentServiceRevokeRequest create() =>
      ConsentServiceRevokeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConsentServiceRevokeRequest._();
  @$core.override
  ConsentServiceRevokeRequest createEmptyInstance() =>
      ConsentServiceRevokeRequest._();
  @$core.pragma('dart2js:noInline')
  static ConsentServiceRevokeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConsentServiceRevokeRequest>(
          ConsentServiceRevokeRequest.$_createMessage);
  static ConsentServiceRevokeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get consentType => $_getSZ(2);
  @$pb.TagNumber(3)
  set consentType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConsentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearConsentType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class ConsentServiceRevokeResponse extends $pb.GeneratedMessage {
  factory ConsentServiceRevokeResponse({
    $core.bool? success,
    ConsentRecord? record,
    $core.int? charactersDisabledCount,
  }) {
    final result = ConsentServiceRevokeResponse._();
    if (success != null) result.success = success;
    if (record != null) result.record = record;
    if (charactersDisabledCount != null)
      result.charactersDisabledCount = charactersDisabledCount;
    return result;
  }

  ConsentServiceRevokeResponse._();

  factory ConsentServiceRevokeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentServiceRevokeResponse()..mergeFromBuffer(data, registry);
  factory ConsentServiceRevokeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConsentServiceRevokeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConsentServiceRevokeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.content.v1'),
      createEmptyInstance: ConsentServiceRevokeResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<ConsentRecord>(2, _omitFieldNames ? '' : 'record',
        subBuilder: ConsentRecord.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'charactersDisabledCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentServiceRevokeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConsentServiceRevokeResponse copyWith(
          void Function(ConsentServiceRevokeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ConsentServiceRevokeResponse))
          as ConsentServiceRevokeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConsentServiceRevokeResponse() / ConsentServiceRevokeResponse.new instead')
  static ConsentServiceRevokeResponse create() =>
      ConsentServiceRevokeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConsentServiceRevokeResponse._();
  @$core.override
  ConsentServiceRevokeResponse createEmptyInstance() =>
      ConsentServiceRevokeResponse._();
  @$core.pragma('dart2js:noInline')
  static ConsentServiceRevokeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConsentServiceRevokeResponse>(
          ConsentServiceRevokeResponse.$_createMessage);
  static ConsentServiceRevokeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  ConsentRecord get record => $_getN(1);
  @$pb.TagNumber(2)
  set record(ConsentRecord value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRecord() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecord() => $_clearField(2);
  @$pb.TagNumber(2)
  ConsentRecord ensureRecord() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get charactersDisabledCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set charactersDisabledCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCharactersDisabledCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharactersDisabledCount() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
